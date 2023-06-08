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

PROCEDURE Public_Revoke (
   do_revoke_ VARCHAR2 )
IS
   stmt_  VARCHAR2(200);
   count_ NUMBER := 0;
   CURSOR get_public_privileges IS
      SELECT *
      FROM sys.dba_tab_privs
      WHERE grantee='PUBLIC'
      AND   table_name IN ('UTL_FILE', 'UTL_HTTP', 'UTL_SMTP', 'UTL_TCP');
   PROCEDURE Grant_Object (
      owner_       IN VARCHAR2,
      object_name_ IN VARCHAR2,
      grantee_     IN VARCHAR2,
      privilege_   IN VARCHAR2,
      grantable_   IN VARCHAR2 DEFAULT 'NO' )
   IS
      stmt_ VARCHAR2(2000);
   BEGIN
      stmt_ := 'GRANT '||privilege_||' ON '||owner_||'."'||object_name_||'" TO '||grantee_;
      IF (grantable_ = 'YES') THEN
         stmt_ := stmt_ || ' WITH GRANT OPTION';
      END IF;
      stmt_ := stmt_ || ';';
      Dbms_Output.Put_Line('RUN THIS COMMAND TO REGRANT THE PRIVILEGE: '||stmt_);
   END Grant_Object;
BEGIN
--
-- Revoke access from the role Public
--
   IF UPPER(do_revoke_) = 'Y' THEN
      FOR rec IN get_public_privileges LOOP
         IF count_ = 0 THEN
            Dbms_Output.Put_Line(' ');
            Dbms_Output.Put_Line('Privleges are revoked from PUBLIC. Run the marked lines to regrant these privleges');
            Dbms_Output.Put_Line('==================================================================================');
         END IF;
         count_ := count_ + 1;
         BEGIN
            stmt_ := 'REVOKE ALL ON '||rec.owner||'."'||rec.table_name||'" FROM '||rec.grantee;
            Run_Ddl_Command___(stmt_, 'Public_Revoke', FALSE);
            Dbms_Output.Put_Line('SUCCESS: '||stmt_);
            Grant_Object(rec.owner, rec.table_name, rec.grantee, rec.privilege, rec.grantable);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
      stmt_ := 'GRANT EXECUTE ON utl_file TO XDB';
      Run_Ddl_Command___(stmt_, 'Grant_XDB', FALSE);
	  --PACAPPF-3534 start
      stmt_ := 'GRANT EXECUTE ON utl_http TO CTXSYS';
      Run_Ddl_Command___(stmt_, 'Grant_CTXSYS', FALSE);
      --PACAPPF-3534 end
   END IF;
END Public_Revoke;

BEGIN
   Public_Revoke('&DO_PUBLIC_REVOKE');
END;
/