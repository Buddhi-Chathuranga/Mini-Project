-----------------------------------------------------------------------------
--
--  POST_Shpmnt_RemoveObsoleteReports.sql
--
--
--  Purpose:   Remove reports from SHPMNT.
--
--  Notes:     This script will run automatically after an upgrade.
--
--
--  Date     Sign     History
--  ------   ------   ---------------------------------------------------------
--  181004   KiSalk   Bug 144546(SCZ-1263), Removed unnecessary code Report_Lu_Definition_API.Clear_Custom_Fields_For_Report because it is a part of Report_SYS.Remove_Report_Definition  
--  181004            and check existence of objects as the code is re-runnable. Moved view/package removal to 181005_144546_Shpmnt.cdb.
--  150615   DaZase   LIM-7701, Added removal of SHIPMENT_ORDER_LINE_REP.
--  150517   UdGnlk   Created.
-------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_RemoveObsoleteReports.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_RemoveObsoleteReports.sql
PROMPT Remove obsolete report objects
BEGIN
   
   Report_SYS.Remove_Report_Definition('TRANSPORT_PACKAGE_LABEL_REP');
   Report_SYS.Remove_Report_Definition('SHIPMENT_ORDER_LINE_REP');
   COMMIT;

END;
/
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_RemoveObsoleteReports.sql','Done');
PROMPT Finished with POST_Shpmnt_RemoveObsoleteReports.sql
