---------------------------------------------------------------------------------------------------
--  Filename      : CreateContext.sql
-- 
--  Module        : FNDBAS 6.0.0
--
--  Purpose       : Refresh the navigator with new entries
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  180920   Maddlk    Created
---------------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','CreateContext.sql','Timestamp_1');
PROMPT Starting CreateContext.SQL

PROMPT Creating text context objects

SET SERVEROUTPUT ON
DECLARE
   error_msg_ VARCHAR2(4000);
   ctx_error  EXCEPTION;
   PRAGMA     EXCEPTION_INIT(ctx_error, -20000);
   crlf_      CONSTANT VARCHAR2(2) := chr(13)||chr(10);
BEGIN
   BEGIN
      Ctx_Ddl.Create_Policy('BLOB_POLICY', 'CTXSYS.AUTO_FILTER');
      Dbms_Output.Put_Line('Policy BLOB_POLICY created');
   EXCEPTION
      WHEN ctx_error THEN
         error_msg_ := UPPER(SQLERRM);
         IF INSTR(error_msg_, 'DUPLICATE') > 0
         OR  INSTR(error_msg_, 'ALREADY EXIST') > 0THEN
            Dbms_Output.Put_Line('The policy BLOB_POLICY already exists');
         ELSE
            Dbms_Output.Put_Line('Unhandled error:'||crlf_||error_msg_);
         END IF;
   END;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','CreateContext.sql','Timestamp_2');
PROMPT Creating normal context objects

DECLARE
   appowner_ CONSTANT VARCHAR2(30) := Sys_Context('USERENV', 'CURRENT_SCHEMA');
   context_  CONSTANT VARCHAR2(30) := 'FND_' || appowner_ || '_CTX';
BEGIN
   -- Drop previously used context
   IF Installation_SYS.Context_Exist(context_, appowner_) THEN
      Installation_SYS.Remove_Context(context_);
   END IF;
   IF Installation_SYS.Context_Exist('FND_SESSION_CTX', appowner_) THEN
      Installation_SYS.Remove_Context('FND_SESSION_CTX');
   END IF;
   -- Create context
   Installation_SYS.Create_Context('FNDSESSION_CTX', 'FND_SESSION_UTIL_API', NULL, NULL, TRUE);
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','CreateContext.sql','Timestamp_3');
PROMPT Creating contexts for language codes

DECLARE
BEGIN
   -- Create context
   Installation_SYS.Create_Context('LANGUAGECODE_CTX', 'LANGUAGE_CODE_API', NULL, 'GLOBALLY');
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','CreateContext.sql','Done');
PROMPT Finished with CreateContext.sql