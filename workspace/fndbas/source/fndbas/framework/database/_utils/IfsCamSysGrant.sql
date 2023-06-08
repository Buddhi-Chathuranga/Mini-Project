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

PROCEDURE IfsCamSys_Grant (
   camunda_owner_ IN VARCHAR2,
   app_owner_     IN VARCHAR2 )
IS
BEGIN
--
-- Execute on Camunda Installation package
--
   Run_Ddl_Command___('GRANT EXECUTE ON '||camunda_owner_||'.CAMUNDA_INSTALL_SYS TO ' || app_owner_, 'IfsCamSys_Grant', FALSE);
END IfsCamSys_Grant;

BEGIN
   IfsCamSys_Grant('&CAMUNDA_APPOWNER', '&APPLICATION_OWNER');
END;
/