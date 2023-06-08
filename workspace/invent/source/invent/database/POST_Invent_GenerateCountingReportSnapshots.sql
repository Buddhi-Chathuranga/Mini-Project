-----------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_GenerateCountingReportSnapshots.sql
--
--  Module        : INVENT
--
--  Purpose       : Generating the Handling Unit-snapshots for all Pick Lists
--                  so that the data will be aggregated by location.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  160822  Chfose  LIM-8418, Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_GenerateCountingReportSnapshots.sql','Timestamp_1');
PROMPT Starting POST_INVENT_V1500_GenerateCountingReportSnapshots.sql

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_GenerateCountingReportSnapshots.sql','Timestamp_2');
PROMPT Generating snapshots for all existing counting reports.
DECLARE
   CURSOR get_counting_reports IS
      SELECT inv_list_no
      FROM COUNTING_REPORT_TAB;
BEGIN
   FOR rec_ IN get_counting_reports LOOP
      Counting_Report_Handl_Unit_API.Generate_Aggr_Handl_Unit_View(rec_.inv_list_no);
   END LOOP;
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_GenerateCountingReportSnapshots.sql','Timestamp_3');
PROMPT Finished with POST_INVENT_V1500_GenerateCountingReportSnapshots.sql
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_GenerateCountingReportSnapshots.sql','Done');
