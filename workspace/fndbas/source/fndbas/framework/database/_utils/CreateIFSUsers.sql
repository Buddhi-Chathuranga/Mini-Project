PROMPT CREATE APPLICATION OWNERS AND OTHER USERS


DECLARE
   schema_exists        EXCEPTION;
   schema_object_exists EXCEPTION;


PROCEDURE Show_Message___ (
   message_ IN VARCHAR2 )
IS
   temp_msg_         VARCHAR2(4000);
   space_position_   NUMBER;
BEGIN
   temp_msg_ := message_;
   WHILE (LENGTH(temp_msg_) > 255) LOOP
      space_position_ := INSTR(SUBSTR(temp_msg_,1,255), ' ', -1);
      IF space_position_ < 240 THEN
         space_position_ := 240;
      END IF;
      Dbms_Output.Put_Line(SUBSTR(temp_msg_,1,space_position_));
      temp_msg_ := SUBSTR(temp_msg_, space_position_+1);
   END LOOP;
   IF temp_msg_ IS NOT NULL THEN
      Dbms_Output.Put_Line(temp_msg_);
   END IF;
END Show_Message___;

FUNCTION Create_Random_Pwd___ RETURN VARCHAR2
IS
  pwd_ varchar2(20);
BEGIN
   -- complies to ora12c_verify_function and ora12c_strong_verify_function
   -- 2 lower 2 upper, 2 digits, 1 special character , 12 random any character, 1 special character. Replace of unwanted characters 
   pwd_ := dbms_random.string('l',2) || dbms_random.string('u',2) || to_char(trunc(dbms_random.value(0,9))) || to_char(trunc(dbms_random.value(0,9))) ||  '(' || dbms_random.string('p',12)  ||  ')' ;
   pwd_ := regexp_replace(pwd_,'["]|[@]|[\]|[/]|['']',dbms_random.string('a',1));   
  RETURN pwd_;
END Create_Random_Pwd___;

FUNCTION Check_Schema_Object___ (
   username_    IN VARCHAR2,
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_schema IS
   SELECT owner
   FROM dba_objects
   WHERE object_name = upper(object_name_)
   AND   object_type = upper(object_type_)
   AND   owner      != upper(username_);
   schema_        VARCHAR2(30);
BEGIN
   OPEN  get_schema;
   FETCH get_schema INTO schema_;
   CLOSE get_schema;
   IF schema_ IS NULL THEN
      RETURN(NULL);
   ELSE
      RETURN(schema_);
   END IF;
END Check_Schema_Object___;

FUNCTION Check_Schema___ (
   username_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_user IS
   SELECT username
   FROM dba_users
   WHERE username = upper(username_);
   schema_        VARCHAR2(30);
BEGIN
   OPEN  get_user;
   FETCH get_user INTO schema_;
   CLOSE get_user;
   IF schema_ IS NULL THEN
      RETURN(FALSE);
   ELSE
      RETURN(TRUE);
   END IF;
END Check_Schema___;

PROCEDURE Test_Schema___ (
   username_      IN VARCHAR2 )
IS
BEGIN
   IF Check_Schema___(username_) THEN
      RAISE schema_exists;
   END IF;
END Test_Schema___;

FUNCTION Test_Schema_Object___ (
   username_      IN VARCHAR2,
   object_name_   IN VARCHAR2 DEFAULT NULL,
   object_type_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   schema_ VARCHAR2(30);
BEGIN
   IF Check_Schema___(username_) THEN
      RAISE schema_exists;
   END IF;
   schema_ := Check_Schema_Object___(username_, object_name_, object_type_);
   IF schema_ IS NOT NULL THEN
      RETURN(schema_);
   END IF;
   RETURN NULL;
END Test_Schema_Object___;

PROCEDURE Grant_Unlimited_Quota___ (
   username_ IN VARCHAR2 )
IS
   stmt_  VARCHAR2(2000);
BEGIN
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_DATA';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_INDEX';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_ARCHIVE_DATA';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_ARCHIVE_INDEX';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_LOB';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_REPORT_DATA';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
   stmt_ := NULL;
   stmt_ := ' ALTER USER ' || username_ ||' QUOTA UNLIMITED ON &IFSAPP_REPORT_INDEX';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;    
END Grant_Unlimited_Quota___;

PROCEDURE Update_User___ (
   username_   IN VARCHAR2,
   password_   IN VARCHAR2 DEFAULT NULL,
   default_ts_ IN VARCHAR2 DEFAULT NULL,
   temp_ts_    IN VARCHAR2 DEFAULT NULL,
   profile_    IN VARCHAR2 DEFAULT NULL,
   force_prf_  IN BOOLEAN  DEFAULT FALSE )
IS
   CURSOR get_user_info IS
      SELECT profile, default_tablespace, temporary_tablespace
      FROM dba_users
      WHERE username = username_;
   stmt_              VARCHAR2(2000);
   alter_stmt_        VARCHAR2(2000);
   existing_profile_  VARCHAR2(2000);
   existing_def_ts_   VARCHAR2(2000);
   existing_temp_ts_  VARCHAR2(2000);
BEGIN
   stmt_ := NULL;
   OPEN get_user_info;
   FETCH get_user_info INTO existing_profile_, existing_def_ts_, existing_temp_ts_;
   CLOSE get_user_info;
   IF password_ IS NOT NULL THEN
      stmt_ := stmt_ || ' IDENTIFIED BY "'|| password_ || '" ';
      Show_Message___ ('New password for user '||username_);
   END IF;
   IF default_ts_ IS NOT NULL
   AND existing_def_ts_ IS NOT NULL THEN
      IF default_ts_ != existing_def_ts_ THEN
         stmt_ := stmt_ || ' DEFAULT TABLESPACE ' || default_ts_ || ' ';
         Show_Message___ ('Default tablespace for user '||username_||' will be changed to '||default_ts_);
      END IF;
   END IF;
   IF temp_ts_ IS NOT NULL
   AND existing_temp_ts_ IS NOT NULL THEN
      IF temp_ts_ != existing_temp_ts_ THEN
         stmt_ := stmt_ || ' TEMPORARY TABLESPACE ' || temp_ts_ || ' ';
         Show_Message___ ('Temporary tablespace for user '||username_||' will be changed to '||temp_ts_);
      END IF;
   END IF;
   IF profile_ IS NOT NULL
   AND existing_profile_ IS NOT NULL THEN
      IF existing_profile_ != profile_
      AND (existing_profile_ = 'DEFAULT'
      OR   force_prf_)      THEN
         stmt_ := stmt_ || ' PROFILE ' || profile_ || ' ';
         Show_Message___ ('Database profile for user '||username_||' will be changed to '||profile_);
      END IF;
   END IF;
   IF stmt_ IS NOT NULL THEN
      alter_stmt_ := NULL;
      alter_stmt_ := ' ALTER USER ' || username_ || stmt_;
      Dbms_Output.Put_Line(alter_stmt_);
      EXECUTE IMMEDIATE alter_stmt_;
   END IF;
END Update_User___;

PROCEDURE Create_User___ (
   username_ IN VARCHAR2,
   password_ IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
   pwd_  VARCHAR2(120);
   stmt_ VARCHAR2(2000);
BEGIN
   IF password_ = 'CREATE_RANDOM_PASSWORD' THEN
      pwd_ := Create_Random_Pwd___;
   ELSE
      pwd_ := password_;
   END IF;
   IF NVL(username_, ' ') = ' '
      OR NVL(pwd_, ' ') = ' ' THEN
        Raise_Application_Error(-20000, 'Username and password must be set to create a user.');
   ELSE
      stmt_ := NULL;
      stmt_ := ' CREATE USER ' || username_ || ' IDENTIFIED BY "'|| pwd_ || '" DEFAULT TABLESPACE ' || default_ts_ || ' TEMPORARY TABLESPACE ' || temp_ts_ || ' PROFILE ' || profile_;
      --Dbms_Output.Put_Line(stmt_);
      EXECUTE IMMEDIATE stmt_;
   END IF;
END Create_User___;

PROCEDURE Create_Appowner (
   username_   IN VARCHAR2 DEFAULT 'IFSAPP',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
   schema_  VARCHAR2(30);
BEGIN
   BEGIN
      --test if appowner exists
      schema_ := Test_Schema_Object___(username_, 'FND_SESSION_API', 'PACKAGE');
      IF schema_ IS NOT NULL THEN
         RAISE schema_object_exists;
      END IF;
      --create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
      WHEN schema_object_exists THEN
         raise_application_error(-20101, 'An Application Owner "'||schema_||'" already exists in this database.');
   END;
   --grant quota
   Grant_Unlimited_Quota___(username_);
END Create_Appowner;

PROCEDURE Create_Ifssys (
   username_   IN VARCHAR2 DEFAULT 'IFSSYS',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
   stmt_   VARCHAR2(2000);
BEGIN
   BEGIN
      -- Test if ifssys exists
      Test_Schema___(username_);
      -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
   END;
   -- Grant create session
   stmt_ := NULL;
   stmt_ := ' GRANT CREATE SESSION TO ' || username_;
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;
END Create_Ifssys;

PROCEDURE Create_Ifsmonitoring (
   username_   IN VARCHAR2 DEFAULT 'IFSMONITORING',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT')
IS
BEGIN
   BEGIN
      -- Test if IFSMONITORING user exists
      Test_Schema___(username_);
      -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
   END;
END Create_Ifsmonitoring;

PROCEDURE Create_Int_User (
   username_   IN VARCHAR2,
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT',
   connect_ifssys_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   stmt_       VARCHAR2(2000);
BEGIN
   BEGIN
      Test_Schema___(username_);
      -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
   END;
   IF connect_ifssys_ = 'TRUE' THEN
      stmt_ := NULL;
      stmt_ := ' ALTER USER "'||username_||'" GRANT CONNECT THROUGH IFSSYS';
      Dbms_Output.Put_Line(stmt_);
      EXECUTE IMMEDIATE stmt_;
   END IF;
END Create_Int_User;

PROCEDURE Create_Ialowner (
   username_   IN VARCHAR2 DEFAULT 'IFSINFO',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
   schema_ VARCHAR2(30);
   stmt_   VARCHAR2(1000);
BEGIN
   BEGIN
   -- Test if ialowner exists
      schema_ := Test_Schema_Object___(username_, 'IAL_OBJECT_SLAVE_API', 'PACKAGE');
      IF schema_ IS NOT NULL THEN
         RAISE schema_object_exists;
      END IF;
      -- Create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
      WHEN schema_object_exists THEN
         raise_application_error(-20101, 'An IAL Owner "'||schema_||'" already exists in this database.');
   END;
   -- Grant quota
   Grant_Unlimited_Quota___(username_);
   stmt_ := NULL;
   stmt_ := ' ALTER USER "'||username_||'" GRANT CONNECT THROUGH &APPLICATION_OWNER';
   Dbms_Output.Put_Line(stmt_);
   EXECUTE IMMEDIATE stmt_;   
END Create_Ialowner;

PROCEDURE Create_Camunda_Appowner (
   username_   IN VARCHAR2 DEFAULT 'IFSCAMSYS',
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT')
IS
   schema_   VARCHAR2(30);
   password_ VARCHAR2(30);
BEGIN
   password_ := Create_Random_Pwd___;
   BEGIN
   -- Test if IFSCAMSYS user exists
      schema_ := Test_Schema_Object___(username_, 'ACT_GE_PROPERTY', 'TABLE');
      IF schema_ IS NOT NULL THEN
         RAISE schema_object_exists;
      END IF;
   -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
      WHEN schema_object_exists THEN
         raise_application_error(-20101, 'A Camunda Application Owner "'||schema_||'" already exists in this database.');
   END;
   -- Grant quota
   Grant_Unlimited_Quota___(username_);
END Create_Camunda_Appowner;

PROCEDURE Create_Ifsiamsys_Appowner (
   username_   IN VARCHAR2 DEFAULT 'IFSIAMSYS',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT')
IS
BEGIN
   BEGIN
      -- Test if IFSIAMSYS user exists
      Test_Schema___(username_);
      -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
   END;
   -- Grant quota
   Grant_Unlimited_Quota___(username_);
END Create_Ifsiamsys_Appowner;

PROCEDURE Create_Ifscrtsys_Appowner (
   username_   IN VARCHAR2 DEFAULT 'IFSCRTSYS',
   password_   IN VARCHAR2,
   default_ts_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   temp_ts_    IN VARCHAR2 DEFAULT 'TEMP',
   profile_    IN VARCHAR2 DEFAULT 'DEFAULT')
IS
BEGIN
   BEGIN
      -- Test if IFSCRTSYS user exists
      Test_Schema___(username_);
      -- create user/schema
      Create_User___(username_, password_, default_ts_, temp_ts_, profile_);
   EXCEPTION
      WHEN schema_exists THEN
         Dbms_Output.Put_Line('The schema "'||username_||'" already exists in this database.');
         Update_User___(username_, profile_ => profile_);  -- Only change the user profile
   END;
   -- Grant quota
   Grant_Unlimited_Quota___(username_);
END Create_Ifscrtsys_Appowner;


BEGIN
   Create_Appowner('&APPLICATION_OWNER', '&APPLICATION_OWNER_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Ifssys('IFSSYS', '&IFSSYS_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Ifsmonitoring('IFSMONITORING', '&IFSMONITORING_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Int_User('IFSPRINT', '&IFSPRINT_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE', 'TRUE');
   Create_Int_User('IFSDBREADONLY', '&IFSDBREADONLY_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE', 'FALSE');
   Create_Ialowner('&IAL_OWNER', '&IAL_OWNER_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Camunda_Appowner('&CAMUNDA_APPOWNER', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Ifsiamsys_Appowner('&IAM_APPOWNER', '&IFSIAMSYS_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
   Create_Ifscrtsys_Appowner('IFSCRTSYS', '&IFSCRTSYS_PASSWORD', '&IFSAPP_DATA', '&TEMP_TABLESPACE', '&INTERNAL_USER_PROFILE');
END;
/
