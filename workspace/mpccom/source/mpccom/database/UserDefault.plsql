-----------------------------------------------------------------------------
--
--  Logical unit: UserDefault
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140314  MaEdlk  Bug 115505, Added Pragma to the method Get_User_Contract.
--  130812  MaIklk  TIBE-941, Removed global variables and used conditional compilation instead.
--  130710  AyAmlk  Bug 111144, Modified Get_Planner_Id() to match the END statement name with the procedure/function name.
--  120409  MaEelk  Modified Get_Planner_Id to fetch the default value for Planner ID
--  120409          if no data is specified for a specific user. 
--  110810  LEPESE  Created method New.
--  100430  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  ------------------- Version 14.0.0 --------------------------------------
--  090303  PraWlk  Bug 77435, Added columns planner_id to view USER_DEFAULT and added 
--  090303          functions Get_Planner_Id, Default_Role_Exist and Modify_Default_Role. 
--  090303          Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to validate
--  090303          PLANNER_ID. 
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  051012  MaGuse  Bug 53526, renamed reference in view comment for identity in EDI_APPROVAL_USER_LOV. 
--  051012  MaGuse  Bug 53526, added EDI_APPROVAL_USER_LOV. 
--  050919  NaLrlk  Removed unused variables.
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  ------------------Version 13.3.0-----------------------------------------
--  000925  JOHESE  Added undefines.
--  000425  ANHO  Removed contract and made calls to LU UserAllowedSite.
--  990919  ROOD  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990426  DAZA  General performance improvements.
--  990413  JOHW  Upgraded to performance optimized template.
--  990210  TOBE  Changed buyer_code to 20 characters.
--  990107  ERFI  Changed view comment on authorize_code to 20 characters
--  971120  TOOS  Upgrade to F1 2.0
--  970526  MAGN  Support Id: 122. Changed view comments PROMPT for col.
--                Authorize_Code to Coordinator Id
--  970313  MAGN  Changed tablename from mpc_user_defaults to user_default_tab.
--  970226  MAGN  Uses column rowversion as objversion(timestamp).
--  970114  JOKE  Added Get_User_Contract for client calls.
--  961214  JOKE  Modified with new workbench default templates.
--  961213  JOHNI Added Cascade_Delete.
--  961210  JOHNI Replaced USER by Utility_SYS.Get_User.
--  961120  JOKE  Added Contract_Exist, Calls to UserAllowedSite.NewUser__.
--  961115  JOKE  Modified for compatibility with workbench.
--  960918  LEPE  Added exception handling for dynamic SQL.
--  960821  SHVE  Added procedure Get_User_Contract.
--  960814  LEPE  Removed all calls to UserProfileSys.
--  960813  LEPE  Removed all validity checks against User_allowed_Site_API.
--  960812  SHVE  Changed call to Purchase_Buyer_Api with dynamic call.
--  960610  JOBE  Added functionality to CONTRACT.
--  960603  RaKu  Added functions (copied from ver 10.02):
--                Get_Authorize_Code, Get_Buyer_Code, Get_Contract
--  960517  AnAr  Added purpose comment to file.
--  960506  SHVE  Replaced table reference to Mpc_user_contract with
--                USER_ALLOWED_SITE_API.
--  960430  MAOS  Removed call to dual when getting user in Get_Defaults.
--  960307  SHVE  Changed LU Name GenMpcUserDefaults.
--  960214  SHVE  Added Check_Buyer_Code function.
--  951220  JN    Modified Refresh_User_Profile to call
--                User_Profile_Sys.Reset_Entry_code.
--  951205  JN    Created Refresh_User_profile for update of USER_PROFILE_SYS.
--                Added call for Gen_User_Contract_API.New at insert.
--                Added call for Gen_User_Contract_API.Remove_All at delete.
--  951018  JOBR  Created
--  951018  xxxx  Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT user_default_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.buyer_code) THEN
      IF NOT(Component_Purch_SYS.INSTALLED) THEN
         Error_Sys.Record_General('UserDefault','BUYERID: Buyer code cannot be registered unless the PURCHASE module is installed.');
      END IF;
   END IF;
   IF (indrec_.planner_id) THEN
      IF NOT(Component_Invent_SYS.INSTALLED) THEN
         Error_Sys.Record_General('UserDefault','PLANNERID: Planner Id cannot be registered unless the INVENT module is installed.');
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     user_default_tab%ROWTYPE,
   newrec_ IN OUT user_default_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.buyer_code) THEN
      IF NOT(Component_Purch_SYS.INSTALLED) THEN
         Error_Sys.Record_General('UserDefault','BUYERID: Buyer code cannot be registered unless the PURCHASE module is installed.');
      END IF;
   END IF;
   IF (indrec_.planner_id) THEN
      IF NOT(Component_Invent_SYS.INSTALLED) THEN
         Error_Sys.Record_General('UserDefault','PLANNERID: Planner Id cannot be registered unless the INVENT module is installed.');
      END IF;
   END IF;   
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Buyer_Code RETURN VARCHAR2
IS
   userid_ VARCHAR2(30);
   temp_ USER_DEFAULT_TAB.buyer_code%TYPE;
   CURSOR get_attr IS
      SELECT buyer_code
      FROM   USER_DEFAULT_TAB
      WHERE  userid = userid_;
BEGIN
   userid_ := Fnd_Session_API.Get_Fnd_User;
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Buyer_Code;


@UncheckedAccess
FUNCTION Get_Authorize_Code RETURN VARCHAR2
IS
   userid_ VARCHAR2(30);
   temp_ USER_DEFAULT_TAB.authorize_code%TYPE;
   CURSOR get_attr IS
      SELECT authorize_code
      FROM   USER_DEFAULT_TAB
      WHERE  userid = userid_;
BEGIN
   userid_ := Fnd_Session_API.Get_Fnd_User;
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Authorize_Code;


@Override
@UncheckedAccess
FUNCTION Get_Planner_Id (
   userid_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ user_default_tab.planner_id%TYPE;
BEGIN
   temp_ := super(userid_);
   temp_ := NVL(temp_, Mpccom_Defaults_API.Get_Char_Value('*', '*', 'PLANNER_BUYER'));
   RETURN temp_;
END Get_Planner_Id;


@UncheckedAccess
FUNCTION Default_Role_Exist (
   person_id_     IN VARCHAR2,
   role_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(5) := 'FALSE';
   temp_ NUMBER;

    CURSOR user_exists IS
      SELECT 1
      FROM USER_DEFAULT_TAB
      WHERE  CASE role_
                WHEN 'BUYER'       THEN buyer_code 
                WHEN 'PLANNER'     THEN planner_id 
                WHEN 'COORDINATOR' THEN authorize_code 
                END = person_id_;
BEGIN  
   OPEN user_exists;
   FETCH user_exists INTO temp_;
   IF (user_exists%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE user_exists;
   RETURN exist_;
END Default_Role_Exist;


PROCEDURE Modify_Default_Role (
   old_person_id_   IN  VARCHAR2,
   new_person_id_   IN  VARCHAR2,
   role_           IN  VARCHAR2)
IS 
   CURSOR get_users IS
      SELECT userid
      FROM   USER_DEFAULT_TAB
      WHERE CASE role_
               WHEN 'BUYER'       THEN buyer_code
               WHEN 'PLANNER'     THEN planner_id
               WHEN 'COORDINATOR' THEN authorize_code
               END = old_person_id_;
               
   TYPE User_Tab IS TABLE OF get_users%ROWTYPE
   INDEX BY PLS_INTEGER;

   user_tab_           User_Tab;
   attr_               VARCHAR2(2000);
   oldrec_             USER_DEFAULT_TAB%ROWTYPE;
   newrec_             USER_DEFAULT_TAB%ROWTYPE;
   objid_              USER_DEFAULT.objid%TYPE;
   objversion_         USER_DEFAULT.objversion%TYPE;
   indrec_             Indicator_Rec;
BEGIN  

   OPEN  get_users;
   FETCH get_users BULK COLLECT INTO user_tab_;
   CLOSE get_users;
   
   IF (user_tab_.COUNT > 0 ) THEN
      FOR i IN user_tab_.FIRST..user_tab_.LAST LOOP
         CASE role_
            WHEN 'BUYER' THEN
               Client_SYS.Add_To_Attr('BUYER_CODE', new_person_id_, attr_);
            WHEN 'PLANNER' THEN
               Client_SYS.Add_To_Attr('PLANNER_ID', new_person_id_, attr_);
            WHEN 'COORDINATOR' THEN
               Client_SYS.Add_To_Attr('AUTHORIZE_CODE', new_person_id_, attr_);
         END CASE;
         oldrec_ := Lock_By_Keys___(user_tab_(i).userid);
         newrec_ := oldrec_;         
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END LOOP;
   END IF;
END Modify_Default_Role;


@UncheckedAccess
FUNCTION Get_Contract RETURN VARCHAR2
IS
BEGIN
   RETURN USER_ALLOWED_SITE_API.Get_Default_Site;
END Get_Contract;


-- Get_Defaults
--   To fetch user_defaults when client has logged on
PROCEDURE Get_Defaults (
   contract_        OUT VARCHAR2,
   buyer_code_      OUT VARCHAR2,
   authorize_code_  OUT VARCHAR2 )
IS
   user_id_ varchar2(30);
   --
   CURSOR get_defaults IS
      SELECT buyer_code,authorize_code
      FROM   USER_DEFAULT_TAB
      WHERE  userid = user_id_;
BEGIN
    --
    user_id_ := Fnd_Session_API.Get_Fnd_User;
    --
    contract_ := USER_ALLOWED_SITE_API.Get_Default_Site;
    OPEN  get_defaults;
    FETCH get_defaults INTO buyer_code_,authorize_code_;
    CLOSE get_defaults;
END Get_Defaults;


-- Contract_Exist
--   Checks if combination of user and site exists.
FUNCTION Contract_Exist (
   userid_ IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN USER_ALLOWED_SITE_API.Check_Default_Site(userid_, contract_);
END Contract_Exist;


-- Get_User_Contract
--   Procedure for fetch of site for specific user.
@UncheckedAccess
PROCEDURE Get_User_Contract (
   contract_ OUT VARCHAR2 )
IS
BEGIN
  contract_ := USER_ALLOWED_SITE_API.Get_Default_Site;
END Get_User_Contract;


PROCEDURE New (
   userid_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   newrec_     USER_DEFAULT_TAB%ROWTYPE;
   objid_      USER_DEFAULT.objid%TYPE;
   objversion_ USER_DEFAULT.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   IF (NOT Check_Exist___(userid_)) THEN

      Client_SYS.Add_To_Attr('USERID', userid_, attr_);      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

   END IF;
END New;



