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

PROCEDURE Create_Audit_Policy___
IS
BEGIN
     -- Audit policy containing all Secure Configuration audit-options
   Run_Ddl_Command___( 
    'CREATE AUDIT POLICY IFS_SECURECONFIG ' ||
                 'PRIVILEGES ALTER ANY TABLE, CREATE ANY TABLE, ' ||
                            'DROP ANY TABLE, CREATE ANY PROCEDURE, ' ||
                            'DROP ANY PROCEDURE, ALTER ANY PROCEDURE, '||
                            'GRANT ANY PRIVILEGE, ' ||
                            'GRANT ANY OBJECT PRIVILEGE, GRANT ANY ROLE, '||
                            'AUDIT SYSTEM, CREATE EXTERNAL JOB, ' || 
                            'CREATE ANY JOB, CREATE ANY LIBRARY, ' ||
                            'EXEMPT ACCESS POLICY, CREATE USER, ' ||
                            'DROP USER, ALTER DATABASE, ALTER SYSTEM, '||
                            'CREATE PUBLIC SYNONYM, DROP PUBLIC SYNONYM, ' ||
                            'CREATE SQL TRANSLATION PROFILE, ' ||
                            'CREATE ANY SQL TRANSLATION PROFILE, ' ||
                            'DROP ANY SQL TRANSLATION PROFILE, ' ||
                            'ALTER ANY SQL TRANSLATION PROFILE, ' ||
                            'TRANSLATE ANY SQL, ' ||
                            'CREATE ANY SQL TRANSLATION PROFILE, ' ||
                            'DROP ANY SQL TRANSLATION PROFILE, ' ||
                            'ALTER ANY SQL TRANSLATION PROFILE, ' ||
                            'TRANSLATE ANY SQL, EXEMPT REDACTION POLICY, ' ||
                            'PURGE DBA_RECYCLEBIN, LOGMINING, ' ||
                            'ADMINISTER KEY MANAGEMENT ' ||
                            'ACTIONS ALTER USER, CREATE ROLE, ALTER ROLE, DROP ROLE, '||
                            'SET ROLE, CREATE PROFILE, ALTER PROFILE, ' ||
                            'DROP PROFILE, CREATE DATABASE LINK, ' ||
                            'ALTER DATABASE LINK, DROP DATABASE LINK, '||
                            'CREATE DIRECTORY, DROP DIRECTORY', 'Create_Audit_Policy___', FALSE);
END Create_Audit_Policy___;


PROCEDURE Create_Audit_Policy 
IS
   ifs_policy_name_  CONSTANT VARCHAR2(100) := 'IFS_SECURECONFIG';
   policy_name_      VARCHAR2(100);
   policy_enabled_   VARCHAR2(6) := 'FALSE';
   dummy_            NUMBER;
   CURSOR check_policy IS
      SELECT 1
      FROM audit_unified_policies
      WHERE policy_name = ifs_policy_name_;
   CURSOR check_enable IS
      SELECT 'TRUE'
      FROM audit_unified_enabled_policies
      WHERE policy_name = ifs_policy_name_;
BEGIN
   -- Check if IFS_SECURECONFIG is enabled
   OPEN check_enable;
   FETCH check_enable INTO policy_enabled_;
   CLOSE check_enable;
   --
   OPEN check_policy;
   FETCH check_policy INTO dummy_;
   IF check_policy%FOUND THEN
      Run_Ddl_Command___('NOAUDIT POLICY ' || ifs_policy_name_, 'Create_Audit_Policy', FALSE);
      Run_DDL_Command___('DROP AUDIT POLICY ' || ifs_policy_name_, 'Create_Audit_Policy', FALSE);
   END IF;
   CLOSE check_policy;
   Create_Audit_Policy___;
   -- Disable ORA_SECURECONFIG for all users
   Run_Ddl_Command___('NOAUDIT POLICY ORA_SECURECONFIG', 'Create_Audit_Policy', FALSE);
   -- Enable IFS_SECURECONFIG for all users
   IF (policy_enabled_ = 'TRUE') THEN
      Run_Ddl_Command___('AUDIT POLICY ' || ifs_policy_name_, 'Create_Audit_Policy', FALSE);
   ELSE
      Run_Ddl_Command___('NOAUDIT POLICY ' || ifs_policy_name_, 'Create_Audit_Policy', FALSE);
   END IF;
END Create_Audit_Policy;

BEGIN
   Create_Audit_Policy;
END;
/