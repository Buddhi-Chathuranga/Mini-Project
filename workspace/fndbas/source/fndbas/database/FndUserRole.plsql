-----------------------------------------------------------------------------
--
--  Logical unit: FndUserRole
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970417  JaPa  Created
--  971008  ERFO  Added validation against Oracle roles (Bug #1691).
--  971008  ERFO  Added GRANT/REVOKE ROLE feature when connecting and
--                disconnecting Oracle roles for FndUsers (ToDo #1688).
--  971013  ERFO  Added control of DDL-exceptions.
--                Rewritten logic in in method Set_Role.
--  971014  TOWR  Fixed bugs in Set_Role and added CASCADE
--  980126  ERFO  Added method Refresh__ (ToDo #2002).
--  990305  ERFO  Consistency changes in Set_Role and Refresh__ (Bug #3191).
--  990310  ERFO  Handle of revoke-operations in the same way as grants
--                in method Set_Role (Bug #3191).
--  990921  HAAR  Solved performance problem in method Refresh__ (Bug #3579).
--  000314  ERFO  Major performance issue in Refresh__ (Bug #13983).
--  001026  ROOD  Added quotation around all roles and users in all ddl calls. (Bug#17619).
--  010105  ROOD  Removed call to Fnd_User_API.Generate_Fnd_User_ and rewrote Refresh__ (ToDo#3937).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020905  HAAR  Rewrite of method Refresh to increase performance (ToDo#4037).
--                 - Make usage of all new PL/SQL features.
--                 - Let Oracle grant tables be drivers over FND grant tables.
--  021206  HAAR  Minor correction in Refresh__.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030910  ROOD  Modified FND_ORA_ROLE_LOV and renamed it to FND_ROLE (ToDo#4160).
--  040209  NIPE  Check that the Role List string does not exceed 3500 characters
--                in Unpack_Check_Insert___ (Bug #42362) 
--  040223  ROOD  Removed view FND_ROLE, since the LU FndRole now has been created.
--                Added reference to FndRole. Replaced oracle_role with role and
--                oracle_user with fnd_user in methods (F1PR413).
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--                   Remove Run_Ddl_Command___.
--  060105  UTGULK Annotated Sql injection.
--  061003  SUKMLK Made chandes to Refresh__ and Delete___ (Bug#60216)
--  120309  MADRSE Refresh__ synchronizes only from FndUserRole to database (RDTERUNTIME-2239)
--  120320  MADRSE Refresh__ revokes grants missing in FND_USER_ROLE_TAB (RDTERUNTIME-2239)
--  121112  ASWILK Checked if oracle user is null before granting in Refresh__(Bug#106672)
--  140904  TMADLK Avoided inserting oracle default users to fnd_grant_role_tmp table (Bug#118428).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_USER_ROLE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   fnd_user_ VARCHAR2(30);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   fnd_user_ := newrec_.identity;
   IF (fnd_user_ IS NOT NULL) THEN
      Assert_SYS.Assert_Is_Grantee(newrec_.role);
      Assert_SYS.Assert_Is_Grantee(fnd_user_);
   END IF;
   -- Keep the cache updated as much as possible...
   BEGIN
      INSERT
         INTO fnd_user_role_runtime_tab (
            identity,
            role)
         VALUES (
            newrec_.identity,
            newrec_.role);
   EXCEPTION
      WHEN dup_val_on_index THEN
         NULL;
   END;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   -- Control dynamic DDL-statement
   WHEN OTHERS THEN
      NULL;
END Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_user_role_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   
   role_list_length_ NUMBER;
   
   CURSOR get_role_list (user_ VARCHAR2) IS
      SELECT nvl(sum(Lengthb(role)+1),1) -1 
      FROM fnd_user_role_runtime_tab 
      WHERE identity = user_;
BEGIN
   super(newrec_, indrec_, attr_);
   -- Check that overflow will not occur for all the roles for this user.
   OPEN get_role_list(newrec_.identity);
   FETCH get_role_list INTO role_list_length_;
   CLOSE get_role_list;
   role_list_length_ := role_list_length_ + length(newrec_.role);
   
   -- here, the number 4587 is calculated as 148(max roles per user)*30(max length for a role name) + 147 spaces
   -- without spaces, the max lenght of role list can be 4440 (4587 - 147)
   IF (role_list_length_ > 4587) THEN
      Error_SYS.Appl_General(lu_name_, 'ROLELISTOVERFLOW: The role list string for the user :P1 exceeds 4440 characters. Could not add more roles.', newrec_.identity);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Set_Role__ (
   identity_ IN VARCHAR2,
   role_     IN VARCHAR2,
   enable_   IN VARCHAR2 )
IS
BEGIN
   IF enable_ = 'ON' THEN
      Set_Role(identity_, role_, TRUE);
   ELSIF enable_ = 'OFF' THEN
      Set_Role(identity_, role_, FALSE);
   ELSE
      Error_SYS.Item_Format(lu_name_, 'ENABLE', enable_);
   END IF;
END Set_Role__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Role (
   identity_ IN VARCHAR2,
   role_     IN VARCHAR2,
   enable_   IN BOOLEAN )
IS
   record_exist EXCEPTION;     
   PRAGMA      exception_init(record_exist, -20112);
   remrec_     FND_USER_ROLE_TAB%ROWTYPE;
   newrec_     FND_USER_ROLE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   --
   -- Ensure that FndUser and FndRole exist
   --
   Fnd_User_API.Exist(identity_);
   Fnd_Role_API.Exist(role_);
   --
   -- Perform the Grant/Revoke
   --
   IF enable_ THEN
      --
      -- Grant role to FndUser
      --
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
      Client_SYS.Add_To_Attr('ROLE', role_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      --
      -- Revoke role from FndUser
      --
      Get_Id_Version_By_Keys___(objid_, objversion_, identity_, role_);      
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
EXCEPTION
   WHEN record_exist THEN
      NULL;  
   WHEN dup_val_on_index THEN
      NULL;
END Set_Role;



