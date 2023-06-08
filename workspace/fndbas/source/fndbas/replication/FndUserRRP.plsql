-----------------------------------------------------------------------------
--
--  Logical unit: FndUser ReplReceive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
ifssys_ CONSTANT VARCHAR2(6) := 'IFSSYS';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------
PROCEDURE Execute_Immediate_Ddl___ (
   stmt_ IN VARCHAR2 )
IS

   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      --@ApproveDynamicStatement(2016-06-22,nadelk)
      EXECUTE IMMEDIATE stmt_;
      --@ApproveTransactionStatement(2016-06-22,nadelk)
      COMMIT;
   END Execute_Immediate_Ddl___;
   
PROCEDURE Lock_Oracle_Account___ (
   userid_     IN    VARCHAR2,
   lock_type_  IN    VARCHAR2 DEFAULT 'LOCK' )
IS
   stmnt_                VARCHAR2(200);
   oracle_user_notexists EXCEPTION;
   PRAGMA                exception_init(oracle_user_notexists, -01918);
   oracle_user_empty     EXCEPTION;
   PRAGMA                exception_init(oracle_user_empty, -01741);
   assert_is_not_user    EXCEPTION;
   PRAGMA                exception_init(assert_is_not_user, -20105);

   FUNCTION Is_Locked___ (
      userid_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_   NUMBER;
      CURSOR get_user IS
      SELECT 1
        FROM dba_users
       WHERE username = userid_
         AND account_status LIKE '%LOCKED%';
   BEGIN
      OPEN  get_user;
      FETCH get_user INTO dummy_;
      CLOSE get_user;
      IF (dummy_ = 1) THEN -- Account locked
         RETURN(TRUE);
      ELSE
         RETURN(FALSE);
      END IF;
   END Is_Locked___;
BEGIN
   IF (userid_ IS NOT NULL) THEN
      -- Check so that the user (appowner) has the privilege to lock an Oracle account
      IF Database_SYS.Check_System_Privilege('ALTER USER') = TRUE THEN
         BEGIN
            IF lock_type_ = 'LOCK' THEN
               IF NOT Is_Locked___(userid_) THEN
                  stmnt_ := 'ALTER USER "'||userid_||'" ACCOUNT '||lock_type_;
                  Assert_SYS.Assert_Is_User(userid_);
                  @ApproveDynamicStatement(2016-06-22,nadelk)
                  EXECUTE IMMEDIATE stmnt_;
                  Client_SYS.Add_Info(lu_name_, 'LOCKACCOUNT: The Oracle account ":P1" has been locked.', userid_);
               END IF;
            ELSIF lock_type_ = 'UNLOCK' THEN
               IF Is_Locked___(userid_) THEN
                  stmnt_ := 'ALTER USER "'||userid_||'" ACCOUNT '||lock_type_;
                  Assert_SYS.Assert_Is_User(userid_);
                  @ApproveDynamicStatement(2016-06-22,nadelk)
                  EXECUTE IMMEDIATE stmnt_;
                  Client_SYS.Add_Info(lu_name_, 'UNLOCKACCOUNT: The Oracle account ":P1" has been unlocked.', userid_);
               END IF;
            END IF;
         EXCEPTION
            WHEN oracle_user_notexists THEN
               NULL;
            WHEN oracle_user_empty THEN
               NULL;
            WHEN assert_is_not_user THEN
               NULL;
         END;
      END IF;
   END IF;
END Lock_Oracle_Account___;
   
PROCEDURE New_Oracle_User___(
   newrec_ IN OUT FND_USER_TAB%ROWTYPE,
   oldrec_ IN OUT FND_USER_TAB%ROWTYPE,
   attr_    IN OUT VARCHAR2)
IS
   ts_default_        VARCHAR2(30);
   ts_temporary_      VARCHAR2(30);
   def_profile_       VARCHAR2(30);
   oracle_password_   VARCHAR2(30);
   stmnt_             VARCHAR2(200);
BEGIN
   IF (oldrec_.oracle_user IS NULL AND newrec_.oracle_user IS NOT NULL) THEN
      ts_default_      := Nvl(Client_SYS.Get_Item_Value('DEFAULT_TABLESPACE', attr_), Fnd_Setting_API.Get_Value('TS_DEFAULT'));
      ts_temporary_    := Nvl(Client_SYS.Get_Item_Value('TEMPORARY_TABLESPACE', attr_), Fnd_Setting_API.Get_Value('TS_TEMPORARY'));
      def_profile_     := Nvl(Nvl(Client_SYS.Get_Item_Value('ORACLE_PROFILE', attr_), Fnd_Setting_API.Get_Value('DEFAULT_PROFILE')), 'DEFAULT');
      oracle_password_ := Nvl(Client_SYS.Get_Item_Value('ORACLE_PASSWORD', attr_),Create_Random_Pwd___);
      stmnt_ := 'CREATE USER "'||newrec_.oracle_user||
                '" IDENTIFIED BY "'||oracle_password_||
                '" PROFILE "'||def_profile_||
                '" DEFAULT TABLESPACE '||ts_default_||
                ' TEMPORARY TABLESPACE '||ts_temporary_;
      IF (Nvl(Client_SYS.Get_Item_Value('EXPIRE_PASSWORD', attr_), 'FALSE') = 'TRUE') OR (NVL(Client_SYS.Get_Item_Value('EXPIRE_PASSWORD',attr_),'0') = '1') THEN
         stmnt_ := stmnt_ || ' PASSWORD EXPIRE';
      END IF;
      Assert_SYS.Assert_Is_Valid_New_User(newrec_.oracle_user);
      Assert_SYS.Assert_Is_Valid_Password(oracle_password_);
      Assert_SYS.Assert_Is_Profile(def_profile_);
      Assert_SYS.Assert_Is_Tablespace(ts_temporary_);
      Assert_SYS.Assert_Is_Tablespace(ts_default_);

      Execute_Immediate_Ddl___( stmnt_ );

      stmnt_ := 'ALTER USER "'||newrec_.oracle_user||'" GRANT CONNECT THROUGH '||ifssys_;
      Execute_Immediate_Ddl___( stmnt_ );
      --
      Fnd_User_Role_API.Refresh__(newrec_.oracle_user);
      Client_SYS.Add_Info(lu_name_, 'CREUSR_I: The Oracle account ":P1" is created.', newrec_.oracle_user);
      Client_SYS.Set_Item_Value('ORACLE_PASSWORD', '', attr_);

   END IF;
   IF (newrec_.active = 'FALSE') THEN
      Lock_Oracle_Account___(newrec_.oracle_user, 'LOCK');
   ELSIF (newrec_.active = 'TRUE') THEN
      Lock_Oracle_Account___(newrec_.oracle_user, 'UNLOCK');
   END IF;
END New_Oracle_User___;

FUNCTION Create_Random_Pwd___ RETURN VARCHAR2
IS
  pwd_ varchar2(20);
BEGIN
   -- complies to ora12c_verify_function and ora12c_strong_verify_function
   -- 2 lower 2 upper, 2 digits, 1 special character , 12 random any character, 1 special character. Replace of unwanted characters 
   -- If the verification function is different than ora12c_verify_function, need to override this function 
   pwd_ := dbms_random.string('l',2) || dbms_random.string('u',2) || to_char(trunc(dbms_random.value(0,9))) || to_char(trunc(dbms_random.value(0,9))) ||  '(' || dbms_random.string('p',12)  ||  ')' ;
   pwd_ := regexp_replace(pwd_,'["]|[@]|[\]|[/]|['']',dbms_random.string('a',1));   
  Assert_Sys.Assert_Is_Valid_Password(pwd_);
  RETURN pwd_;
END Create_Random_Pwd___;

-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------
PROCEDURE Reresh_Security_Cache(
   attr_ IN VARCHAR2)
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   dummy_no_   NUMBER;
BEGIN 
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'DUMMY_NUMBER')THEN
         dummy_no_ := value_;  
      END IF;
   END LOOP;
   Security_SYS.Refresh_Active_List__(dummy_no_);
END Reresh_Security_Cache;

PROCEDURE NewModify (
   warning_      OUT VARCHAR2,
   old_attr_     IN  VARCHAR2,
   new_attr_     IN  VARCHAR2,
   lu_name_      IN  VARCHAR2,
   package_name_ IN  VARCHAR2,
   user_id_      IN  VARCHAR2) 
IS
   attr_  VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   
   oldrec_   fnd_user_tab%ROWTYPE;
   newrec_   fnd_user_tab%ROWTYPE;
   indrec_   Indicator_Rec;
   
   security_attr_ VARCHAR2(2000);
   refersh_desc_  VARCHAR2(100);
   
BEGIN
   attr_ := new_attr_;
   oldrec_.identity := Client_SYS.Get_Item_Value('IDENTITY', old_attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, oldrec_.identity);
   
   IF (objid_ IS NOT NULL) THEN
      -- record exist! update record
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, FALSE);
      New_Oracle_User___(newrec_,oldrec_,attr_);
   ELSE
      -- record does not exists! insert as new
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      New_Oracle_User___(newrec_,oldrec_,attr_);
   END IF;
   refersh_desc_ := Language_SYS.Translate_Constant(lu_name_,'USERS: Refresh Security Cache after creating a user ') ;
   Client_SYS.Add_To_Attr('DUMMY_NO', 1, security_attr_);
   Transaction_Sys.Deferred_Call('Fnd_User_RRP.Reresh_Security_Cache',security_attr_,refersh_desc_); 
END NewModify;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   profile_id_        VARCHAR2(100);
   profile_name_      VARCHAR2(200);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   profile_name_ := Language_SYS.Translate_Constant(lu_name_, 'PERPRFNAME: :P1 Personal', NULL, Fnd_User_API.Get_Description(newrec_.identity));
   Fndrr_Client_Profile_API.Create_Personal__(profile_id_, profile_name_, newrec_.identity );
   Fndrr_User_Client_Profile_API.Assign_Personal_Profile__(profile_id_, newrec_.identity, 'TRUE');  
END Insert___;




