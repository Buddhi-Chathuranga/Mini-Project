-----------------------------------------------------------------------------
--
--  Logical unit: FndProjection
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200227  RAKUSE  Added argument remove_plsql_package_ in Remove_Projection (TEAURENAFW-2024).
--  210419  RAKUSE  Added handling of QR Report templates in Remove_Projection (EXPFWCG-49).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

FUNCTION Get_Num_Granted_Roles(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(Role)
      FROM Fnd_Projection_Grant
      WHERE projection = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Granted_Roles;

FUNCTION Get_Num_Granted_Users(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT
         --user_role.identity,
         --user_role.role,
         --fnd_projection_grant_api.Get_Grant_Access(projection, user_role.role),
         --fnd_role_api.Get_Fnd_Role_Type_Db(user_role.role) type,
         count (*) count
      FROM
         fnd_projection_grant projection_grant,
         fnd_user_role user_role
      WHERE
         projection_grant.role = user_role.role and
         projection = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Granted_Users;

FUNCTION Get_Num_Entitysets(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Entityset
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Entitysets;

FUNCTION Get_Num_Queries(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Query
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Queries;

FUNCTION Get_Num_Grantable_Entities(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Entity e
      WHERE Fnd_Proj_Entity_API.Is_Grantable(e.projection_name, e.entity_name) = 'TRUE'
      AND e.projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Grantable_Entities;


FUNCTION Get_Num_Entities(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Entity
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Entities;

FUNCTION Get_Num_Virtual_Entities(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Virtual_Entity
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Virtual_Entities;

FUNCTION Get_Num_Entity_Actions(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Ent_Action
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Entity_Actions;


FUNCTION Get_Num_Projection_Actions(
   projection_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Action
      WHERE projection_name = projection_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Projection_Actions;


--SOLSETFW
FUNCTION Is_Active(
   projection_name_   IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(projection_name_) AND Module_API.Is_Active(Fnd_Projection_API.Get_Component(projection_name_));   
END Is_Active;


PROCEDURE Check_Active (
   projection_name_  IN VARCHAR2 )
IS
BEGIN
   --SOLSETFW
   Module_API.Check_Active(Fnd_Projection_API.Get_Component(projection_name_));
END Check_Active;

-------------------- PRIVATE DECLARATIONS -----------------------------------

report_template_name_      CONSTANT VARCHAR2(20) := 'OrderReportTemplate';
qr_report_template_name_   CONSTANT VARCHAR2(20) := 'QuickReportTemplate';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   projection_name_ IN VARCHAR2,
   description_     IN VARCHAR2 DEFAULT NULL,
   categories_ IN VARCHAR2 DEFAULT NULL,
   component_ IN VARCHAR2 DEFAULT NULL,
   plsql_package_ IN VARCHAR2 DEFAULT NULL,
   layer_ IN VARCHAR2 DEFAULT NULL,
   capability_ IN VARCHAR2 DEFAULT NULL,
   api_class_        IN VARCHAR2 DEFAULT NULL,
   deprecated_       IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_projection_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.description := description_;
   rec_.categories := categories_;
   rec_.component := component_;
   rec_.plsql_package := plsql_package_;
   rec_.layer := layer_;
   rec_.capability := capability_;
   rec_.api_class := api_class_;
   rec_.deprecated := upper(deprecated_);
   
   IF INSTR(categories_, 'Integration', 1) != 0 AND categories_ != 'Integration' THEN
      Error_SYS.Projection_General(lu_name_, 'PROJECTION_CATEGORY: Integration category should not be combined with other categories.');
   END IF;
   
   IF Check_Exist___(projection_name_) THEN
      IF Installation_SYS.Get_Installation_Mode THEN
         -- Since FndProjEntActionUsage has CASCADE reference to FndProjEntAction
         -- deleting fnd_proj_ent_action_usage_tab records
         DELETE
            FROM fnd_proj_ent_action_usage_tab
            WHERE projection_name = projection_name_;
            
         -- Since FndProjActionUsage has CASCADE reference to FndProjAction
         -- deleting fnd_proj_action_usage_tab records
         DELETE
            FROM fnd_proj_action_usage_tab
            WHERE projection_name = projection_name_;

         -- Since FndProjectionUsage has CASCADE reference to FndProjection
         -- deleting fnd_projection_usage_tab records
         DELETE
            FROM fnd_projection_usage_tab
            WHERE projection_name = projection_name_;
            
         -- Since FndProjEntity has CASCADE reference to FndProjection and FndProjEntAction has CASCADE reference to FndProjEntity,
         -- deleting fnd_proj_ent_action_tab records first and then fnd_proj_entity_tab
         DELETE
            FROM fnd_proj_ent_action_tab
            WHERE projection_name = projection_name_;
            
         DELETE
            FROM fnd_proj_entity_tab
            WHERE projection_name = projection_name_;

         --Since FndProjAction also has CASCADE reference to FndProjection, deleting fnd_proj_action_tab records
         DELETE
            FROM fnd_proj_action_tab
            WHERE projection_name = projection_name_;

         --Deleting the parent records after deleting the CASCADE references
         DELETE
            FROM fnd_projection_tab
            WHERE projection_name = projection_name_;
            
         DELETE
            FROM fnd_proj_query_tab
            WHERE projection_name = projection_name_;
         
         DELETE
            FROM fnd_proj_entityset_tab
            WHERE projection_name = projection_name_;
      ELSE
         Remove___(rec_,FALSE);
      END IF;         
   END IF;
   New___(rec_);
   IF NOT Installation_SYS.Get_Installation_Mode THEN
      $IF Component_Fndcob_SYS.INSTALLED $THEN
         IF (Projection_Config_API.Get_Published_Db(projection_name_) = 'TRUE') THEN
            Projection_Config_API.Synchronize(projection_name_);
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
END Create_Or_Replace;


PROCEDURE Remove_Projection (
   projection_name_      IN VARCHAR2,
   show_info_            IN BOOLEAN DEFAULT FALSE,
   remove_plsql_package_ IN BOOLEAN DEFAULT TRUE)
IS
   rec_ fnd_projection_tab%ROWTYPE;      
BEGIN
   Fnd_Proj_Virtual_Entity_API.Remove_Proj_Virtual_Entities(projection_name_, show_info_);
   Model_Design_SYS.Remove_Projection_Metadata(projection_name_);      
   Fnd_Java_Impl_Util_API.Remove_Projection_Impls(projection_name_);
   Fnd_Proj_Large_Attr_Supp_API.Remove_Proj_Large_Attr(projection_name_);
   rec_ := Get_Object_By_Keys___(projection_name_);
   IF (rec_.projection_name IS NOT NULL) THEN
      Remove___(rec_,FALSE);
      
      IF (remove_plsql_package_) THEN
         IF (rec_.plsql_package IS NULL) THEN 
            Database_SYS.Remove_Package(Dictionary_SYS.Clientnametodbname_(projection_name_)||'_SVC', show_info_);
         ELSE
            -- Special Handling for Report and Quick Report Projections:
            IF (projection_name_ != report_template_name_ AND
               rec_.plsql_package = Dictionary_SYS.Clientnametodbname_(report_template_name_)||'_SVC') THEN
               -- The Order Report Template SVC is generic and managing all reports meaning is should not be dropped for
               -- report projections unless the OrderReportTemplate projection itself is being dropped.
               Dbms_Output.Put_Line('Remove_Projection: Report Projection uses generic SVC package, not to be dropped.');
            ELSIF (projection_name_ != qr_report_template_name_ AND
               rec_.plsql_package = Dictionary_SYS.Clientnametodbname_(qr_report_template_name_)||'_SVC') THEN
               -- The Quick Report Template SVC is generic and managing all Quick Reports meaning is should not be dropped for
               -- quick report projections unless the QuickReportTemplate projection itself is being dropped.
               Dbms_Output.Put_Line('Remove_Projection: Quick Report Projection uses generic SVC package, not to be dropped.');
            ELSE
               Database_SYS.Remove_Package(rec_.plsql_package, show_info_);
               -- Projection may also support Offline apps, having to drop its corresponding *_JSN package
               IF (rec_.capability = 'Offline') THEN
                  Database_SYS.Remove_Package(Dictionary_SYS.Clientnametodbname_(projection_name_)||'_JSN', show_info_);
               END IF;
            END IF;
         END IF;
      END IF;
     
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection: Projection ' || projection_name_ || ' dropped.');
      END IF;
   ELSE 
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection: Projection ' || projection_name_ || ' not exist.');
      END IF;
   END IF;   
END Remove_Projection;
