-----------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_GeneratePickListSnapshots.sql
--
--  Module        : SHPMNT
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
--  ------  ------  ----------------------------------------------------------
--  170313  Chfose  LIM-11152, Moved from ORDER and made generic.
--  160822  Chfose  LIM-8418, Created.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GeneratePickListSnapshots.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_GeneratePickListSnapshots.sql

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GeneratePickListSnapshots.sql','Timestamp_2');
PROMPT Generating snapshots for all existing pick lists.
DECLARE
   CURSOR get_pick_lists IS
      SELECT pick_list_no
        FROM PICK_REPORT_PICK_LIST;
BEGIN
   FOR rec_ IN get_pick_lists LOOP
      Pick_Shipment_API.Generate_Handl_Unit_Snapshot(rec_.pick_list_no);
   END LOOP;
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GeneratePickListSnapshots.sql','Done');
PROMPT Finished with POST_Shpmnt_GeneratePickListSnapshots.sql
