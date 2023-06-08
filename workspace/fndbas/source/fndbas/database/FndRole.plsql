-----------------------------------------------------------------------------
--
--  Logical unit: FndRole
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040220  ROOD  Created (F1PR413).
--  040604  ROOD  Added comments in Insert___ and Update___ (F1PR413).
--  040607  ROOD  Updated template (F1PR413).
--  040705  ROOD  Added view fnd_role_role (F1PR413).
--  050126  RAKU  Removed calls to client_role/client_role_restriction (F1PR484).
--  050302  JORA  Added assert of dynamic SQL (F1PR481).
--  050309  JORA  Fixed assert error with "create role" (F1PR481).
--  050404  JORA  Added assertion for dynamic SQL of grantee.  (F1PR481)
--  050502  JORA  Added support for role type (F1PR480).
--  060105  UTGULK Annotated Sql injection.
--  061030  DUWILK Modified functionality in insert__ to get values using RETURNING (Bug#61922)
--  100805  UsRaLK Added procedure Create__ to create or update a ROLE (Bug#90361).
--  110824  MaDrSE Added columns LIMITED_TASK_USER and ADDITIONAL_TASK_USER (RDTERUNTIME-542).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('FND_ROLE_TYPE', Fnd_Role_Type_API.Decode('ENDUSERROLE'), attr_);

END Prepare_Insert___;



@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_ROLE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   role_already_exist EXCEPTION;
   PRAGMA             exception_init(role_already_exist, -1921);
   role_not_granted   EXCEPTION;
   PRAGMA             exception_init(role_not_granted, -1951);
   fnd_user_exist     EXCEPTION;
   dummy_             NUMBER;
   CURSOR find_user(identity_ IN VARCHAR2) IS
      SELECT 1
      FROM fnd_user_tab
      WHERE upper(identity) = identity_;
BEGIN
   --
   -- Note that some of the code here is copied to the script where
   -- the predefined roles are created. If any changes are made here,
   -- the functionality of that script must be verified too!
   --

   -- Verify that no Foundation1 user exist with the same name
   OPEN find_user(newrec_.role);
   FETCH find_user INTO dummy_;
   IF find_user%FOUND THEN
      CLOSE find_user;
      RAISE fnd_user_exist;
   ELSE
      CLOSE find_user;
   END IF;

   newrec_.created := SYSDATE;
   newrec_.role := upper(newrec_.role);
   -- Insert the role
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN role_already_exist THEN
      Error_SYS.Record_General(lu_name_, 'SIMILARUSERORROLE: The role ":P1" could not be created since it conflicts with another Oracle user or role name!', newrec_.role);
   WHEN role_not_granted THEN
      NULL;
   WHEN fnd_user_exist THEN
      Error_SYS.Record_General(lu_name_, 'SIMILARFNDUSER: The role ":P1" could not be created since it conflicts with an existing Foundation1 user!', newrec_.role);
END Insert___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_ROLE_TAB%ROWTYPE )
IS

   role_not_found EXCEPTION;
   PRAGMA         exception_init(role_not_found, -1919);
BEGIN
   super(objid_, remrec_);

   -- This delete section should be possible to remove when the references has been made correct.
   -- The the call the Do_Cascade_Delete should handle this completely.
   -- If performance demands it, keep the simple deletes

   -- It is expected that the role is in uppercase here. If there is any risk, make sure to
   -- UPPER the role before the deletes...

   -- Delete all grants to users
   
   DELETE FROM fnd_user_role_runtime_tab
      WHERE role = remrec_.role;

   -- Delete all method restrictions

   DELETE FROM security_sys_tab
   WHERE role = remrec_.role;

   DELETE FROM security_sys_privs_tab
   WHERE grantee = remrec_.role;
   
EXCEPTION
   -- If the role does not exist, do nothing
   WHEN role_not_found THEN
      NULL;
   -- All other cases will cause raise and rollback
END Delete___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create__ (
   role_        IN VARCHAR2,
   description_ IN VARCHAR2,
   role_type_   IN VARCHAR2,
   update_      IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      FND_ROLE.objid%TYPE;
   objversion_ FND_ROLE.objversion%TYPE;
   oldrec_     FND_ROLE_TAB%ROWTYPE;
   newrec_     FND_ROLE_TAB%ROWTYPE;
   indrec_     Fnd_Role_API.Indicator_Rec;
BEGIN

   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('FND_ROLE_TYPE_DB', role_type_, attr_);

   -- If the update_ flag cleared even for the existing roles system will
   -- attempt to insert and return the error code as in earlier case.
   IF ( Check_Exist___(role_) ) AND ( update_ = 'TRUE') THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, role_);
      -- Modify__ with 'DO' option
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   ELSE
      Client_SYS.Add_To_Attr('ROLE', role_, attr_);
      -- New__ with 'DO' option
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Create__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_User_Role_License (
   is_valid_      OUT VARCHAR2,
   role_          IN VARCHAR2,
   identity_      IN VARCHAR2 )
IS
BEGIN
-- TODO: we do not support activities any longer...
/*
   record_ := Plsqlap_Record_API.New_record('VALID_LICENSE');
   Plsqlap_Record_API.Set_Value(record_, 'ROLE', role_, Plsqlap_Record_API.dt_Text_Key, FALSE);
   Plsqlap_Record_API.Set_Value(record_, 'IDENTITY', identity_, Plsqlap_Record_API.dt_Text_Key, FALSE);
   Plsqlap_Server_API.Invoke_Record_Impersonate('BrowseLicenseFile', 'CheckUserRoleLicense', record_, activity_ => TRUE);
   is_valid_ := Plsqlap_Record_API.Get_Value(record_, 'IS_VALID');
*/
   is_valid_ := 'TRUE';
END Check_User_Role_License;

PROCEDURE Check_Role_Role_License (
   is_valid_      OUT VARCHAR2,
   role_          IN VARCHAR2,
   sub_role_      IN VARCHAR2 )
IS
BEGIN
-- TODO: we do not support activities any longer...
/*
   record_ := Plsqlap_Record_API.New_record('VALID_LICENSE');
   Plsqlap_Record_API.Set_Value(record_, 'ROLE', role_, Plsqlap_Record_API.dt_Text_Key, FALSE);
   Plsqlap_Record_API.Set_Value(record_, 'SUB_ROLE', sub_role_, Plsqlap_Record_API.dt_Text_Key, FALSE);
   Plsqlap_Server_API.Invoke_Record_Impersonate('BrowseLicenseFile', 'CheckRoleRoleLicense', record_, activity_ => TRUE);
   is_valid_ := Plsqlap_Record_API.Get_Value(record_, 'IS_VALID');
*/
   is_valid_ := 'TRUE';
END Check_Role_Role_License;

FUNCTION Get_Num_Proj_Granted(
   role_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT NVL(COUNT(*), 0)
      FROM Fnd_Projection_Grant
      WHERE role = role_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Proj_Granted;

FUNCTION Get_Num_Proj_Read_Granted(
   role_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT NVL(COUNT(*), 0)
      FROM Fnd_Projection_Grant
      WHERE role = role_
      AND Fnd_Projection_Grant_Api.Get_Grant_Access(projection, role) = Projection_Access_Level_API.DB_READ_ONLY;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Proj_Read_Granted;

FUNCTION Get_Num_Proj_Cust_Granted(
   role_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT NVL(COUNT(*), 0)
      FROM Fnd_Projection_Grant
      WHERE role = role_
      AND Fnd_Projection_Grant_Api.Get_Grant_Access(projection, role) = Projection_Access_Level_API.DB_CUSTOM;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Proj_Cust_Granted;

FUNCTION Get_Num_Proj_Full_Granted(
   role_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT NVL(COUNT(*), 0)
      FROM Fnd_Projection_Grant
      WHERE role = role_
      AND Fnd_Projection_Grant_Api.Get_Grant_Access(projection, role) = Projection_Access_Level_API.DB_FULL;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Proj_Full_Granted;

FUNCTION Get_Num_Sys_Priv_Granted(
   role_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT NVL(COUNT(*), 0)
      FROM System_Privilege_Grant
      WHERE role = role_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Get_Num_Sys_Priv_Granted;

FUNCTION Get_Unimportable_Proj_Items(
   msg_ IN CLOB) RETURN CLOB
IS
   projection_item_table_ Utility_SYS.STRING_TABLE;
   projection_item_count_ NUMBER;
   
   item_ VARCHAR2(1000);
   item_type_ VARCHAR2(100);
   projection_name_ Fnd_Projection.projection_name%TYPE;
   entity_name_ Fnd_Proj_Entity.entity_name%TYPE;
   action_name_ Fnd_Proj_Action.action_name%TYPE;
   
   item_key_table_ Utility_SYS.STRING_TABLE;
   item_key_count_ NUMBER;
   
   result_ CLOB;
   append_ VARCHAR2(2000);
BEGIN
   Utility_SYS.Tokenize(msg_, ';', projection_item_table_, projection_item_count_);
   
   DBMS_LOB.CREATETEMPORARY(result_, TRUE);
      
   FOR i_ IN 1..projection_item_count_ LOOP
      item_ := projection_item_table_(i_);
      Utility_SYS.Tokenize(item_, '^', item_key_table_, item_key_count_);
      
      item_type_ := item_key_table_(1);
      
      IF item_type_ = 'Projection' THEN
         projection_name_ := item_key_table_(2);
         --SOLSETFW
         IF NOT Fnd_Projection_API.Is_Active(projection_name_) THEN
            IF DBMS_LOB.GETLENGTH(result_) != 0 THEN
              result_ := result_ || ';';
            END IF;
            append_ := 'Projection^' || projection_name_;
            DBMS_LOB.WRITEAPPEND(result_, LENGTH(append_), append_);
         END IF;
      ELSIF item_type_ = 'ProjectionAction' THEN
         projection_name_ := item_key_table_(2);
         action_name_ := item_key_table_(3);
         IF NOT Fnd_Proj_Action_API.Exists(projection_name_, action_name_) THEN
            IF DBMS_LOB.GETLENGTH(result_) != 0 THEN
              result_ := result_ || ';';
            END IF;
            append_ := 'ProjectionAction^' || projection_name_ || '^' || action_name_;
            DBMS_LOB.WRITEAPPEND(result_, LENGTH(append_), append_);
         END IF;
      ELSIF item_type_ = 'ProjectionEntity' THEN
         projection_name_ := item_key_table_(2);
         entity_name_ := item_key_table_(3);
         IF NOT Fnd_Proj_Entity_API.Exists(projection_name_, entity_name_) THEN
            IF DBMS_LOB.GETLENGTH(result_) != 0 THEN
              result_ := result_ || ';';
            END IF;
            append_ := 'ProjectionEntity^' || projection_name_ || '^' || entity_name_;
            DBMS_LOB.WRITEAPPEND(result_, LENGTH(append_), append_);
         END IF;
      ELSIF item_type_ = 'ProjectionEntityAction' THEN
         projection_name_ := item_key_table_(2);
         entity_name_ := item_key_table_(3);
         action_name_ := item_key_table_(4);
         IF NOT Fnd_Proj_Ent_Action_API.Exists(projection_name_, entity_name_, action_name_) THEN
            IF DBMS_LOB.GETLENGTH(result_) != 0 THEN
              result_ := result_ || ';';
            END IF;
            append_ := 'ProjectionEntityAction^' || projection_name_ || '^' || entity_name_ || '^' || action_name_;
            DBMS_LOB.WRITEAPPEND(result_, LENGTH(append_), append_);
         END IF;
      END IF;
      
   END LOOP;
   
   RETURN result_;
END Get_Unimportable_Proj_Items;

PROCEDURE Set_Limited_Task_User (
   role_ IN VARCHAR2 )
IS
BEGIN
   IF Validate_LTU(role_)='TRUE' THEN  
   UPDATE fnd_role_tab
      SET Limited_Task_User = 'TRUE'
      WHERE role = role_;
   ELSE 
      Error_SYS.Record_General(lu_name_,'SET_LTU_ERR: Cannot set [:P1] as LTU. Permission structure contains basic role(s) that are not LTU.',role_);
   END IF;
END Set_Limited_Task_User;

PROCEDURE Grant_Oracle_System_Privs__ (
   role_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'OBSOLETE_METHOD: Calling obsolete interface Fnd_Role_API.Grant_Oracle_System_Privs__! Arguments: :P1', role_);
END Grant_Oracle_System_Privs__;

PROCEDURE Remove_Limited_Task_User (
   role_ IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_role_tab
      SET Limited_Task_User = 'FALSE'
      WHERE role = role_;   
END Remove_Limited_Task_User;

FUNCTION Validate_LTU(role_ VARCHAR2) RETURN VARCHAR2 
IS
   validate_flag_ VARCHAR2(20):= 'TRUE';
   CURSOR get_permission_sets_ IS 
   SELECT granted_role
   FROM Fnd_role_role
   WHERE grantee = role_;   
BEGIN
   FOR permission_ IN get_permission_sets_ LOOP
      IF permission_.granted_role NOT IN('FND_WEBENDUSER_B2B','FND_WEBENDUSER_MAIN','FND_WEBRUNTIME','AURENA_NATIVE_RUNTIME') THEN
         validate_flag_ := 'FALSE';         
      END IF;
   END LOOP;   
   RETURN validate_flag_;
END Validate_LTU;

FUNCTION LTU_User_Validation(user_ VARCHAR2) RETURN varchar2
IS
   validation_flag_ VARCHAR2(20) := 'FALSE';
   CURSOR get_user_permission_details_ IS 
   SELECT role 
   FROM fnd_user_role
   WHERE identity = user_;
BEGIN
   FOR role_ IN get_user_permission_details_ LOOP
      IF Get_Limited_Task_User(role_.role) = 'TRUE' THEN
      Error_SYS.Record_General(lu_name_,'LTU_USER_ERR: Cannot assign permission set for the user [:P1] with existing [:P2] LTU permissions.',user_, role_.role);
      validation_flag_ := 'TRUE';
      END IF;
   END LOOP;
   RETURN validation_flag_;
END LTU_User_Validation;