-----------------------------------------------------------------------------
--  Module : INVENT
--
--  File   : POST_Invent_RemoveObsoleteReports.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180806   ErRalk  Bug 143315, Dropped the obsolete reports INVENTORY_ABC_ANALYSIS_REP and INVENTORY_PART_LOC_PALLET_REP
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
   
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RemoveObsoleteReports.sql','Timestamp_1');
PROMPT Drop obsolete reports INVENTORY_ABC_ANALYSIS_REP and INVENTORY_PART_LOC_PALLET_REP

BEGIN
   Report_SYS.Remove_Report_Definition('INVENTORY_ABC_ANALYSIS_REP');
   Report_SYS.Remove_Report_Definition('INVENTORY_PART_LOC_PALLET_REP');
END;
/

PROMPT Finished with POST_Invent_RemoveObsoleteReports.SQL
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RemoveObsoleteReports.sql','Done');
