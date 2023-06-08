-----------------------------------------------------------------------------
--
--  Logical unit: FndProjEntity
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

FUNCTION Get_Num_Actions(
   projection_name_ IN VARCHAR2,
   entity_name_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM Fnd_Proj_Ent_Action_TAB
      WHERE projection_name = projection_name_
      AND entity_name = entity_name_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Actions;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   operations_allowed_  IN VARCHAR2 DEFAULT NULL,
   from_view_           IN VARCHAR2 DEFAULT NULL,
   used_lu_             IN VARCHAR2 DEFAULT NULL,
   usage_type_          IN VARCHAR2 DEFAULT NULL,
   exclude_from_config_ IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_entity_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.from_view   := UPPER(from_view_);
   rec_.exclude_from_config := nvl(exclude_from_config_, 'FALSE');
   rec_.operations_allowed  := nvl(operations_allowed_, 'CRUDS');
   rec_.usage_type          := nvl(usage_type_, 'Main');
   rec_.used_lu             := used_lu_;
   
   IF Check_Exist___(projection_name_,entity_name_) THEN
      IF Installation_SYS.Get_Installation_Mode THEN
         --Since FndProjEntAction has CASCADE reference to FndProjEntity, deleting records from both fnd_proj_ent_action_tab
         --and fnd_proj_entity_tab
         DELETE
            FROM fnd_proj_ent_action_tab
            WHERE projection_name = projection_name_ 
            AND entity_name = entity_name_;
            
         DELETE
            FROM fnd_proj_entity_tab
            WHERE projection_name = projection_name_ 
            AND entity_name = entity_name_;
      ELSE
         Remove___(rec_,FALSE);
      END IF;
   END IF;
   New___(rec_);

END Create_Or_Replace;

PROCEDURE New_Entry(
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   operations_allowed_  IN VARCHAR2 DEFAULT NULL,
   from_view_           IN VARCHAR2 DEFAULT NULL,
   used_lu_             IN VARCHAR2 DEFAULT NULL,
   usage_type_          IN VARCHAR2 DEFAULT NULL,
   exclude_from_config_ IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_entity_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.from_view   := UPPER(from_view_);
   rec_.exclude_from_config := nvl(exclude_from_config_, 'FALSE');
   rec_.operations_allowed  := nvl(operations_allowed_, 'CRUDS');
   rec_.usage_type          := nvl(usage_type_, 'Main');
   rec_.used_lu             := used_lu_;
   New___(rec_);
END New_Entry;

PROCEDURE Remove_Projection_Entity (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   show_info_       IN BOOLEAN DEFAULT FALSE)
IS
   rec_ fnd_proj_entity_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_name_,entity_name_) THEN
      rec_ := Get_Object_By_Keys___(projection_name_,entity_name_);
      Remove___(rec_,FALSE);         
         
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection_Entity: In the Projection ' || projection_name_ ||' Entity '||entity_name_|| ' dropped.');
      END IF;
   ELSE 
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection_Entity: In the Projection ' || projection_name_ ||' Entity '||entity_name_|| ' not exist.');
      END IF;
   END IF;
END Remove_Projection_Entity;

FUNCTION Is_Grantable(
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2) RETURN VARCHAR2
IS
   result_ VARCHAR2(100);
   num_entity_actions_ NUMBER;
   
   CURSOR get_num_entity_actions IS
      SELECT count(*)
      FROM fnd_proj_ent_action_tab e
      WHERE e.projection_name = projection_name_
      AND e.entity_name = entity_name_;
BEGIN
   IF Get_Operations_Allowed(projection_name_, entity_name_) <> 'R' THEN
      result_ := 'TRUE';
   ELSE
      OPEN get_num_entity_actions;
      FETCH get_num_entity_actions INTO num_entity_actions_;
      CLOSE get_num_entity_actions;
      
      IF num_entity_actions_ > 0 THEN
         result_ := 'TRUE';
      ELSE
         result_ := 'FALSE';
      END IF;
   END IF;
   RETURN result_;
END Is_Grantable;
