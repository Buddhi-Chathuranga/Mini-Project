-----------------------------------------------------------------------------
--  Module : FNDBAS
--
--  File   : POST_FNDBAS_RemoveObsoleteReports.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180808   CHAALK  Bug 143315, Remove the obsolete report data for FND_SESSION_REP
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
   
EXEC Database_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteReports.sql','Timestamp_1');
PROMPT Drop obsolete report data
DECLARE
BEGIN
   IF( NOT Database_SYS.Is_Db_Patch_Registered('FNDBAS', 143315)) THEN
      Report_SYS.Remove_Report_Definition('FND_SESSION_REP');
      Database_SYS.Register_Db_Patch('FNDBAS', 143315, 'Remove obsolete report data');
      COMMIT;
   END IF;
END;
/

PROMPT Finished with POST_FNDBAS_RemoveObsoleteReports.sql
EXEC Database_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteReports.sql','Done');

SET SERVEROUTPUT OFF


