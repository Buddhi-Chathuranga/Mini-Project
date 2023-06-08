-----------------------------------------------------------------------------
--
--  Logical unit: FndUser
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970417  JAPA  Created
--  970430  ERFO  Added method Get_Role_List.
--  970514  ERFO  Added method Set_Property.
--  970605  ERFO  Added method Get_Recursive_Property_.
--  970813  MADR  Added protected method Generate_Fnd_User_
--  970817  MANY  Added method Enumerate().
--  971008  ERFO  Added CREATE USER feature when connecting
--                Oracle roles to FndUsers (ToDo #1688).
--  971013  ERFO  Added control of DDL-exceptions.
--  971014  TOWR  Fixed bugs concerning update
--  971028  ERFO  Fixed exception problem when modifying the user.
--  980109  ERFO  Changes in Set_Property to ensure that an end-user
--                may change his own properties only (ToDo #1785).
--  980126  ERFO  Added call to Fnd_User_Role_API.Refresh__ (ToDo #2002).
--  980127  ERFO  Removed possibility to remove application owner.
--  980311  ERFO  Changes in method Geneate_Fnd_User_ to ensure that a non-
--                existing Foundation1 user will be generated (Bug #2228).
--  980505  ERFO  Corrected method Set_Property with error message when
--                trying to set properties for another user (Bug #2421).
--  980929  ERFO  Added method Get_Web_User (ToDo #2733).
--  990104  ERFO  Added method Get_User_Security_Info_ (Bug #3008).
--  990322  ERFO  Added view FND_USER_SECURITY_INFO (Bug #3236).
--  990322  ERFO  Consistency changes in method Insert___, Update___
--                and Get_Role_List_ (Bug #3191).
--  990322  ERFO  Changes in Generate_Fnd_User_ to include roles (Bug #3191).
--  990324  ERFO  Removed view FND_USER_SECURITY_INFO (Bug #3236).
--  990426  ERFO  Fixed tablespace problem for new users (Bug #2975).
--  990823  ERFO  Added warning in Insert___ for wrong tablespaces (Bug #3455).
--  000228  ERFO  Solved exception problem in Remove_Cascade__ (Bug #15116).
--  000525  ERFO  Added method Get_Pres_Security_Setup and property PRES_OBJECT_SEC_SETUP.
--  000925  ROOD  Added validation against license limits in Insert___ (ToDo #3937).
--  001004  ROOD  Modification in Get_Pres_Security_Setup so that it never returns NULL (ToDo#3929).
--  001026  ROOD  Added quotation around all user in all ddl calls. (Bug#17619).
--                Added some exceptions concerning oracle users and tablespaces.
--  001029  ROOD  Updated to new template.
--  001115  ROOD  Added column Active (ToDo#3937).
--  001219  ROOD  Modifications in Insert___ and Update___ (ToDo#3937).
--  001229  ERFO  Added new method (ToDo #3937).
--  010103  ROOD  Modified Get_Web_User_Identity (ToDo #3937).
--  010104  ROOD  Modified Generate_Fnd_User_ (ToDo #3937).
--  011203  HAAR  Modified Insert___ and Update___ to get Default profile from Fnd_Setting (ToDo #4054).
--  011207  ROOD  Added insertion of default paper format in Insert___ (ToDo#4056).
--  020108  HAAR  Removed Run_DDL_Command___ against EXECUTE IMMEDIATE.
--  020118  HAAR  Added password to be able to have different username and password (ToDo#4054).
--  020118  HAAR  Removed Client_Info message from Remove_Cascade__, due to client rewrite.
--  020118  HAAR  Added possibility to expire password for new Oracle accounts.
--  020206  ROOD  Corrected the usage of General_SYS.Init_Method (Bug#27577).
--  020311  ROOD  Added a check that identity is not the same as an
--                existing oracle role (Bug#27944).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020627  HAAR  Lock/Unlock Oracle account when Activating/Deactivating FndUser (ToDo#4068)
--  020703  ROOD  Corrected usage of General_SYS.Init_Method once more... (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030305  ROOD  Increased the length of column web_user in view (ToDo#4157).
--  030306  ROOD  Changed prompt for web_user to Directory Id (ToDo#4238).
--  030816  HAAR  Fixed bug in Lock_Oracle_Account___ when no Oracle account connected to FndUser (ToDo#4068).
--  030816  ROOD  Changed info message in Lock_Oracle_Account___ (ToDo#4068).
--  030829  HAAR  User password shown in Admin tool (Bugg#39099).
--  040324  ROOD  Replaced oracle_role with role where appropriate (F1PR413).
--  040826  ROOD  Limited username to be maximum 30 bytes (F1PR408).
--  041230  HAAR  Changed error message for Exist (Link#116713).
--  050302  JORA  Added assert evaluations to prevent SQL Injection (F1PR481).
--  050307  RAKU  Added creation of user client profiles in Insert___ (F1PR483).
--  050330  RAKU  Changed name on call to method Assign_Personal_Profile__ (F1PR483).
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050405  NiWi  Added validation to limit F1 user identity to 20 characters(Bug#49955).
--  050414  RAKU  Changed name on call to method Create_Personal__ (F1PR480).
--  050414  HAAR  Added Check_Active for validation of active users during login (F1PR489).
--  050615  HAAR  Changed Check_Delete___, Get_User_Security_Info_ and Set_Property to use System privileges (F1PR483).
--  051101  HAAR  Added possibility to add Default and Temporary tablespace to FndUser (F1PR480).
--  051110  RAKU  Removed last parameter ('LOCAL') in call to Assign_Personal_Profile__ (F1PR482).
--  060105  UTGULK Annotated Sql injection.
--  060719  DUWILK Added Condition to check spaces in the newrec_.identity field in Unpack_Check_Insert___ (Bug#59381)
--  060927  RaRuLk Chaged the call in to Assert_Is_Valid_New_User in Insert___ and in Update__(Bug#60819).
--  061012  RaRuLk Added the call Client_Sys.Clear_Info() in Remove_Cascade__(Bug#61123).
--  070213  MARESE Added Text_Id$ column to FND_USER (search domain "Users").
--  070711  HAAR   Made column web_user uppercase (Bug#66382).
--  070710  SUMALK Oracle Account Lock and Unlock depending on active.(Bug#66590)
--  070813  SUMALK  Change lengthb to lenghth.(Call 147296)
--  070808  SUMALK Meaningful messages for user_id value format.(Bug#65193).
--  071026  HAAR   Check if a user is locked before locking it (Bug#68779).
--  080414  HAAR   Added attributes Valid_To and Valid_From (Bug#73104).
--  080526  HAAR   Removed some intelligence regarding Valid_From and Valid_To in Insert___(Bug#74326).
--  080616  HAAR   Fixed so that is possible to change Oracle_User from Solution Manager (Bug#74998).
--  081029  DUSDLK Increased the size of temp_ variable in function Get_Role_List_ (Bug#78126).
--  090227  KAUS   Added private method Set_Anonymous_Web_User__ (Bug #80904).
--  100415  JHMASE Catch exception assert_is_not_user in Lock_Oracle_Account___(Bug #90058).
--  100702  ChMuLK Changed the scope of the attribute Active to public (Bug#91690).
--  110726  ChMuLK Added public method Is_User_Runtime_Role (Bug#97049).
--  120407  UsRaLK Added new method Validate_Fnd_User___ (Bug#99513/RDTERUNTIME-1613).
--  121130  WaWiLK Corrections for Insert___ and Update___ in password expire(Bug#106970).
--  141125  TAORSE   Added Enumerate_Db
--  200525  YATILK Added Mxcore Component dynamic dependency
--  210506  YATILK Added default values for user creation.
--  210812  YATILK User creation error message change (Bug #159591)
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

ifssys_ CONSTANT VARCHAR2(6) := 'IFSSYS';

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: The Foundation1 user ":P1" does not exist.', identity_);
   super(identity_);
   --Add post-processing code here
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('EXPIRE_PASSWORD', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DEFAULT_IDP', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('FROM_SCIM', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_user_tab%ROWTYPE,
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.identity = 'IFSSYS') THEN
      Error_SYS.Record_General('FndUser', 'IFSSYSATTACH: The user identity IFSSYS is not valid as a Foundation1 user.');
   END IF;
   IF newrec_.created IS NULL THEN
      newrec_.created := sysdate;
   END IF;
   
   IF newrec_.user_type IS NULL THEN
      newrec_.user_type := Fnd_User_Type_API.DB_END_USER;
   END IF;
   IF newrec_.web_user IS NULL THEN
      newrec_.web_user := newrec_.identity;
   END IF;
   IF newrec_.default_idp IS NULL THEN
      newrec_.default_idp := 'TRUE';
   END IF;
   newrec_.last_modified := sysdate;
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF  LENGTH(newrec_.identity) > 20 THEN
      Error_SYS.Record_General(lu_name_, 'MAXUSERIDLEN: User id entered is :P1 characters long. Maximum allowed length for Foundation1 User Identity is 20 characters.', LENGTH(newrec_.identity));
   END IF;
   -- (Bug#59381) Check whether the identity has spaces
   IF instr(newrec_.identity, ' ') > 0 THEN
      Error_SYS.Record_General(lu_name_, 'IDWITHNOSPACE: Foundation1 User cannot contain any spaces');
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;




@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_USER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   dummy_             NUMBER;
   license_msg_       VARCHAR2(2000);
   profile_id_        VARCHAR2(100);
   profile_name_      VARCHAR2(200);
   
   no_license_left       EXCEPTION;
   oracle_role_exists    EXCEPTION;
   
   CURSOR find_role(role_ IN VARCHAR2) IS
      SELECT 1
      FROM sys.dba_roles
      WHERE role = role_;
BEGIN
   -- Verify that no Oracle role exist with the same name (necessary to validate against ORACLE role!)
   OPEN find_role(upper(newrec_.identity));
   FETCH find_role INTO dummy_;
   IF find_role%FOUND THEN
      CLOSE find_role;
      RAISE oracle_role_exists;
   ELSE
      CLOSE find_role;
   END IF;
   
   newrec_.from_scim := nvl(newrec_.from_scim,Fnd_Boolean_API.DB_FALSE);
   newrec_.default_idp := nvl(newrec_.default_idp,Fnd_Boolean_API.DB_TRUE);
   Client_SYS.Set_Item_Value('FROM_SCIM', newrec_.from_scim, attr_);
   Client_SYS.Set_Item_Value('DEFAULT_IDP', newrec_.default_idp, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN
      Mx_User_Util_API.Perform_Insert(lu_name_, Pack___(newrec_));
   $END
   
   INSERT
      INTO fnd_user_property_tab (
         identity,
         name,
         value,
         rowversion)
      VALUES (
         newrec_.identity,
         'DEFAULT_PAPER_FORMAT',
         'SYSTEM-DEFINED',
         1);
   
   -- Each Fnd User must have a Personal Profile record connected.
   -- Create a new user profile and...
   profile_name_ := Language_SYS.Translate_Constant(lu_name_, 'PERPRFNAME: :P1 Personal', NULL, Fnd_User_API.Get_Description(newrec_.identity));
   Fndrr_Client_Profile_API.Create_Personal__(profile_id_, profile_name_, newrec_.identity );
   -- ... connect it to the user.
   Fndrr_User_Client_Profile_API.Assign_Personal_Profile__(profile_id_, newrec_.identity, 'TRUE');
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN no_license_left THEN
      Error_SYS.Record_General(lu_name_, 'NOLICENSELEFT_I: The user could not be added since the license limit of :P1 active users has been reached. Please upgrade your license to be able to increase the number of active users!', Message_SYS.Find_Attribute(license_msg_, 'LICENSE_LIMIT', ''));
   WHEN oracle_role_exists THEN
      Error_SYS.Record_General(lu_name_, 'SIMILARORACLEROLE: The user ":P1" could not be created since an oracle role with the name ":P1" do exist!', newrec_.identity);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_USER_TAB%ROWTYPE,
   newrec_     IN OUT FND_USER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   license_msg_       VARCHAR2(2000);
   
   no_license_left       EXCEPTION;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   $IF Component_Fndrem_SYS.INSTALLED $THEN
      IF (Remote_Assistance_User_API.Exists(newrec_.identity) = TRUE) THEN
         IF (newrec_.active = 'FALSE') THEN
            Remote_Assistance_User_API.Set_Active(newrec_.identity, newrec_.active);
         END IF;
      END IF;
   $END
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Update(lu_name_, Pack___(oldrec_), Pack___(newrec_));
   $END
   
   Assert_SYS.Assert_Is_Valid_New_User(newrec_.identity);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN no_license_left THEN
      Error_SYS.Record_General(lu_name_, 'NOLICENSELEFT_U: The user could not be updated to be active since the license limit of :P1 active users has been reached. Please upgrade your license to be able to increase the number of active users!', Message_SYS.Find_Attribute(license_msg_, 'LICENSE_LIMIT', ''));
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN FND_USER_TAB%ROWTYPE )
IS
BEGIN
   IF (Security_SYS.Is_App_Owner(remrec_.identity)) THEN
      Error_SYS.Appl_General(lu_name_, 'OWNDROP: Application owner ":P1" can not be removed!', remrec_.identity);
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_USER_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Delete(lu_name_, Pack___(remrec_));
   $END 
END Delete___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ fnd_user_tab%ROWTYPE )
IS
BEGIN
   IF (Check_Exist___(rec_.identity)) THEN
      Error_SYS.Record_General(lu_name_, 'IDENTITYEXISTS: Fnd User with Identity ":P1" already exists".', rec_.identity);
   ELSE
      IF (Check_Web_User_Exist___(rec_.web_user)) THEN
         Error_SYS.Record_General(lu_name_, 'WEBUSEREXISTS1: The Fnd User with Directory ID ":P1" already exists', rec_.web_user);
      END IF;
   END IF;
   super(rec_);
END Raise_Record_Exist___;

@Override
PROCEDURE Raise_Constraint_Violated___ (
   rec_        IN fnd_user_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   IF (constraint_ = 'FND_USER_IX2') THEN
      Error_SYS.Record_General(lu_name_, 'WEBUSEREXISTS2: The Fnd User with Directory ID ":P1" already exists.', rec_.web_user);
   ELSE
      super(rec_, constraint_);
   END IF;
END Raise_Constraint_Violated___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-----------------------------------------------------------------------------
-- Execute_Immediate_Ddl___
--    This function simply executes DDL statements dynamically.
--    AUTONOMOUS_TRANSACTION PRAGMA is used workaround the implicit commit
--    associated with DDLs.
-----------------------------------------------------------------------------
PROCEDURE Execute_Immediate_Ddl___ (
   stmt_ IN VARCHAR2 )
IS
   PRAGMA autonomous_transaction;
BEGIN
   -- This procedure is not exposed in the header.
   @ApproveDynamicStatement(2010-02-02,UsRaLK)
   EXECUTE IMMEDIATE stmt_;
   @ApproveTransactionStatement(2013-10-25,haarse)
   COMMIT;
END Execute_Immediate_Ddl___;

FUNCTION Check_Web_User_Exist___ (
   web_user_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   FND_USER_TAB
      WHERE  web_user = web_user_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Web_User_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_Cascade__ (
   info_     OUT VARCHAR2,
   identity_ IN  VARCHAR2 )
IS
   remrec_      FND_USER_TAB%ROWTYPE;
   objid_       FND_USER.objid%TYPE;
   objversion_  FND_USER.objversion%TYPE;
   unknown_user EXCEPTION;
   PRAGMA      exception_init(unknown_user, -01918);
BEGIN
   remrec_ := Lock_By_Keys___(identity_);
   Get_Id_Version_By_Keys___(objid_, objversion_, identity_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
   Client_SYS.Clear_Info;
END Remove_Cascade__;


FUNCTION Create_Random_Pwd__ RETURN VARCHAR2
IS
   pwd_ VARCHAR2(20);
BEGIN
   -- complies to ora12c_verify_function and ora12c_strong_verify_function
   -- 2 lower 2 upper, 2 digits, 1 special character , 12 random any character, 1 special character. Replace of unwanted characters
   pwd_ := dbms_random.string('l',2) || dbms_random.string('u',2) || to_char(trunc(dbms_random.value(0,9))) || to_char(trunc(dbms_random.value(0,9))) ||  '(' || dbms_random.string('p',12)  ||  ')' ;
   pwd_ := regexp_replace(pwd_,'["]|[@]|[\]|[/]|['']',dbms_random.string('a',1));
   Assert_SYS.Assert_Is_Valid_Password(pwd_);
   RETURN pwd_;
END Create_Random_Pwd__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Web_User_Identity_ (
   web_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FND_USER_TAB.identity%TYPE;
BEGIN
   SELECT identity
   INTO   temp_
   FROM   FND_USER_TAB
   WHERE  web_user = web_user_
   AND    active = 'TRUE';
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Web_User_Identity_;



@UncheckedAccess
FUNCTION Is_Inactive_Web_User (
   web_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FND_USER_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT active
      FROM FND_USER_TAB
      WHERE web_user = web_user_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ = 'FALSE') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Inactive_Web_User;



@UncheckedAccess
FUNCTION Get_Role_List_ (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(4500);
   CURSOR get_roles IS
      SELECT role
      FROM   fnd_user_role_runtime
      WHERE  identity = identity_;
BEGIN
   FOR rec IN get_roles LOOP
      temp_ := temp_||rec.role||',';
   END LOOP;
   RETURN(substr(temp_, 1, length(temp_) - 1));
END Get_Role_List_;



@UncheckedAccess
FUNCTION Get_Recursive_Property_ (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000);
BEGIN
   temp_ := Fnd_User_Property_API.Get_Value(identity_, name_);
   IF (temp_ IS NULL) THEN
      temp_ := Fnd_User_Property_API.Get_Value(Fnd_Session_API.Get_Fnd_User, name_);
   END IF;
   RETURN(temp_);
END Get_Recursive_Property_;



PROCEDURE Generate_Fnd_User_ (
   fnd_user_      IN VARCHAR2,
   fnd_user_type_ IN VARCHAR2 DEFAULT 'END_USER'
   )
IS
   info_   VARCHAR2(2000);
   objid_  FND_USER.objid%TYPE;
   objv_   FND_USER.objversion%TYPE;
   attr_   VARCHAR2(2000);
BEGIN
   IF NOT Check_Exist___(fnd_user_) THEN
      --
      --  Create new inactive instance of FND user
      --
      Client_SYS.Clear_Attr(attr_);
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('IDENTITY',    fnd_user_, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', fnd_user_, attr_);
      Client_SYS.Add_To_Attr('USER_TYPE_DB', fnd_user_type_, attr_);
      Client_SYS.Add_To_Attr('WEB_USER',    fnd_user_, attr_);
      Client_SYS.Add_To_Attr('ACTIVE', 'FALSE', attr_);
      New__(info_, objid_, objv_, attr_, 'DO');
   END IF;
END Generate_Fnd_User_;


@UncheckedAccess
FUNCTION Get_User_Security_Info_ RETURN VARCHAR2
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   IF (Security_SYS.Has_System_Privilege('ADMINISTRATOR', fnd_user_)) THEN
      RETURN('%');
   ELSE
      RETURN(fnd_user_);
   END IF;
END Get_User_Security_Info_;


PROCEDURE Set_User_Key_ (
   user_ IN VARCHAR2 )
IS
   temp_ VARCHAR2(2000);
BEGIN
   temp_ := concat(lpad(trunc(ascii(user_)+power(log(3,exp(0)),sqrt(3))),''),'');
   Fnd_Session_API.Set_Key_(user_);
   --   General_SYS.Check_License_(temp_);
END Set_User_Key_;

@UncheckedAccess
FUNCTION Get_License_Usage (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   additional_ BOOLEAN := FALSE;
   limited_ BOOLEAN := FALSE;
   full_ BOOLEAN := FALSE;
   
   CURSOR get_licenses_ IS 
      SELECT identity, role, role_scope
      FROM fnd_licensed_role_user
      WHERE identity = identity_;
BEGIN
   FOR license_ IN get_licenses_ LOOP
      IF (license_.role_scope = 'FULL') THEN
         full_ := TRUE;
      ELSIF (license_.role_scope = 'LIMITED') THEN
         limited_ := TRUE;
      ELSIF (license_.role_scope = 'ADDITIONAL') THEN
         additional_ := TRUE;
      END IF;
   END LOOP;
   
   IF(full_ AND additional_) THEN
      RETURN 'Full, Additional';
   ELSIF (limited_ AND additional_) THEN   
      RETURN 'Limited, Additional';
   ELSIF (additional_) THEN   
      RETURN 'Additional';
   ELSIF (limited_ ) THEN   
      RETURN 'Limited';
   ELSIF (full_) THEN   
      RETURN 'Full';
   ELSE
      RETURN 'None';
   END IF;   
END Get_License_Usage;

@UncheckedAccess
FUNCTION Get_Licenses (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   additional_ BOOLEAN := FALSE;
   limited_ BOOLEAN := FALSE;
   full_ BOOLEAN := FALSE;
   limited_to_ VARCHAR2(32000);
   
   CURSOR get_licenses_ IS 
      SELECT identity, role, role_scope
      FROM fnd_licensed_role_user
      WHERE identity = identity_;
BEGIN
   FOR license_ IN get_licenses_ LOOP
      IF (license_.role_scope = 'FULL') THEN
         full_ := TRUE;
      ELSIF (license_.role_scope = 'LIMITED') THEN
         IF(limited_ OR additional_) THEN
            limited_to_ := limited_to_ || ', ' || license_.role;                 
         ELSE
            limited_to_ := license_.role;  
         END IF;
         limited_ := TRUE;
      ELSIF (license_.role_scope = 'ADDITIONAL') THEN
         IF(limited_ OR additional_) THEN
            limited_to_ := limited_to_ || ', ' || license_.role;           
         ELSE
            limited_to_ := license_.role;  
         END IF;
         additional_ := TRUE;
      END IF;
   END LOOP;
   RETURN limited_to_;   
END Get_Licenses;
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Active (
   identity_ IN VARCHAR2 )
IS
   temp_ FND_USER_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT active
      FROM FND_USER_TAB
      WHERE identity = identity_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ != 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'NOTACTIVE: The Foundation1 user ":P1" is not active.', identity_);
   END IF;
END Check_Active;

@UncheckedAccess
FUNCTION Get_Property (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Fnd_User_Property_API.Get_Value(identity_, name_));
END Get_Property;



PROCEDURE Set_Property (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2,
   value_    IN VARCHAR2 )
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   IF (identity_ = fnd_user_ OR
       Security_SYS.Has_System_Privilege('ADMINISTRATOR', fnd_user_)) THEN
      Fnd_User_Property_API.Set_Value(identity_, name_, value_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'ERRUSER: You can not as user ":P1" set properties for user ":P2".',
                             fnd_user_, identity_);
   END IF;
END Set_Property;


@UncheckedAccess
FUNCTION Get_Pres_Security_Setup (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_ VARCHAR2(5) := 'ON';
BEGIN
   RETURN(value_);
END Get_Pres_Security_Setup;

@UncheckedAccess
FUNCTION Is_User_Runtime_Role (
   identity_ IN VARCHAR2,
   role_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_runtime_role IS
      SELECT 1
      FROM fnd_user_role_runtime t
      WHERE identity = identity_
      AND role = role_;
BEGIN
   OPEN check_runtime_role;
   FETCH check_runtime_role INTO dummy_;
   IF (check_runtime_role%FOUND) THEN
      CLOSE check_runtime_role;
      RETURN TRUE;
   END IF;
   CLOSE check_runtime_role;
   RETURN FALSE;
END Is_User_Runtime_Role;

FUNCTION Get_License_Metric_Full_Users RETURN VARCHAR2
IS
   amount_ NUMBER;
   CURSOR get_user_amount IS
      SELECT count(identity)
      FROM fnd_licensed_role_user
      WHERE ROLE_SCOPE = 'FULL';
BEGIN
   OPEN get_user_amount;
   FETCH get_user_amount INTO amount_;
   CLOSE get_user_amount;
   RETURN amount_;
END Get_License_Metric_Full_Users;

FUNCTION Get_License_Metric_LTU_Users RETURN VARCHAR2
IS
   attr_ VARCHAR2(4000);
   CURSOR get_user_amount_by_ltu IS
      SELECT r.role, (SELECT COUNT(*) FROM fnd_licensed_role_user ur WHERE ur.role=r.role) amount
      FROM fnd_role r
      WHERE r.limited_task_user='TRUE';
BEGIN
   FOR item IN get_user_amount_by_ltu LOOP
      Client_SYS.Add_To_Attr(item.role, item.amount, attr_);
   END LOOP;
   RETURN attr_;
END Get_License_Metric_LTU_Users;

FUNCTION Exists_Web_User (
   web_user_ IN VARCHAR2) RETURN BOOLEAN
IS
   existing_web_user_ VARCHAR2(2000);
   
   CURSOR get_web_user_ IS
      SELECT 1
      FROM fnd_user
      WHERE web_user = web_user_;
BEGIN
   OPEN get_web_user_;
   FETCH get_web_user_ INTO existing_web_user_;
   CLOSE get_web_user_;
   
   IF (existing_web_user_ IS NULL) THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
END Exists_Web_User;

FUNCTION Get_License_Metric_Sys_Users RETURN VARCHAR2
IS
   sys_user_list_ VARCHAR2(10000);
   CURSOR Get_Active_Sys_Users_ IS
      SELECT identity
      FROM FND_USER
      WHERE user_type_db = 'SYSTEM_USER' AND active ='TRUE';
BEGIN
   FOR users_ IN Get_Active_Sys_Users_ LOOP
      sys_user_list_ := sys_user_list_ || users_.identity || ',';
   END LOOP;
   RETURN rtrim(sys_user_list_ , ',');
END Get_License_Metric_Sys_Users;

FUNCTION Get_License_Metric_Serv_Users RETURN VARCHAR2
IS
   service_user_list_ VARCHAR2(10000);
   CURSOR get_active_serv_users_ IS
      SELECT identity
      FROM FND_USER
      WHERE user_type_db = 'SERVICE_USER' AND active ='TRUE';
BEGIN
   FOR users_ IN get_active_serv_users_ LOOP
      service_user_list_ := service_user_list_ || users_.identity || ',';
   END LOOP;
   RETURN rtrim(service_user_list_ , ',');
END Get_License_Metric_Serv_Users;