-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : POST_Order_RemoveObsoleteReports.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200923   MaRalk  SC2020R1-9694, Removed Patch Registration when preparing the file for 2020R1 Release.
--  180808   KiSalk  Bug 143315, Remove the report definition for the obsolete reports BONUS_SETTLEMENT_REP and INTRASTAT_EXPORT_REP.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
   
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_RemoveObsoleteReports.sql','Timestamp_1');
PROMPT Remove obsolete report definitions BONUS_SETTLEMENT_REP and INTRASTAT_EXPORT_REP

BEGIN   
   Report_SYS.Remove_Report_Definition('BONUS_SETTLEMENT_REP'); 
   Report_SYS.Remove_Report_Definition('INTRASTAT_EXPORT_REP');   
   COMMIT;    
END;
/

PROMPT Finished with POST_Order_RemoveObsoleteReports.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_RemoveObsoleteReports.sql','Done');
