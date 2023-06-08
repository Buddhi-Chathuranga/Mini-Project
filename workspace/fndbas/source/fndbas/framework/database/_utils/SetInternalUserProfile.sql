DECLARE

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

PROCEDURE Run_Ddl_Command___ (
   stmt_      IN VARCHAR2,
   procedure_ IN VARCHAR2,
   show_info_ IN BOOLEAN DEFAULT FALSE,
   raise_     IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   -- Safe due to deployed as sys
   -- ifs_assert_safe haarse 2010-09-23
   IF show_info_ THEN
      Dbms_Output.Put_Line('Executing ' || stmt_);
   END IF;
   EXECUTE IMMEDIATE stmt_;
EXCEPTION
   WHEN OTHERS THEN
      Show_Message___ (procedure_ || ' generates error when executing: ');
      Show_Message___ (stmt_);
      IF raise_ THEN
         RAISE;
      END IF;
END Run_Ddl_Command___;

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
      Run_Ddl_Command___('ALTER USER ' || username_ || stmt_, 'Update_User___', FALSE);
   END IF;
END Update_User___;

PROCEDURE Set_Internal_User_Profile
IS
   int_user_profile_    CONSTANT VARCHAR2(30) := '&INTERNAL_USER_PROFILE';
BEGIN
   Update_User___('IFSADMIN', profile_ => int_user_profile_);
   Update_User___('IFSCONNECT', profile_ => int_user_profile_);
   Update_User___('IFSPLSQLAP', profile_ => int_user_profile_);
   Update_User___('IFSPRINT', profile_ => int_user_profile_);
   Update_User___('CBSSERVER', profile_ => int_user_profile_);
   Update_User___('DOCVUETICKETUSER', profile_ => int_user_profile_);
   Update_User___('DEMANDSERVER', profile_ => int_user_profile_);
END Set_Internal_User_Profile;

BEGIN
   Set_Internal_User_Profile;
END;
/