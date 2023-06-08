--
--  File        : POST_Invent_RenameObsoleteTables.sql
--
--  Module      : INVNET 14.1.0
--
--  Usage       : Rename obsolete tables after the whole installation because of the references to rest of the components.
--
--  Date    Sign    History
--  ------  -----   --------------------------------------------------------------------------------------------
--  151124  UdGnlk  LIM-4612, Modified to obsolete inventory_part_loc_pallet_tab. Its depend on purch/receipt_pallet_location_tab upgrade.
--  140312  MAHPLK  Created.
----------------------------------------------------------------------------------------------------------------

SET SERVEROUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RenameObsoleteTables.sql','Timestamp_1');
PROMPT Starting POST_Invent_RenameObsoleteTables.sql

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RenameObsoleteTables.sql','Timestamp_2');
PROMPT Renaming obsolete table PALLET_TYPE_TAB.
BEGIN
   Database_SYS.Rename_Table('PALLET_TYPE_TAB',  'PALLET_TYPE_1410',  TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RenameObsoleteTables.sql','Timestamp_3');
PROMPT Renaming obsolete table inventory_part_loc_pallet_tab
BEGIN
   Database_SYS.Remove_Constraints ('INVENTORY_PART_LOC_PALLET_TAB', 'INVENTORY_PART_LOC_PALLET_RK');
   Database_SYS.Remove_Constraints ('INVENTORY_PART_LOC_PALLET_TAB', 'INVENTORY_PART_LOC_PALLET_PK');
   Database_SYS.Rename_Table('INVENTORY_PART_LOC_PALLET_TAB',  'INVENTORY_PART_LOC_PALLET_1500',  TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RenameObsoleteTables.sql','Timestamp_4');
PROMPT Removed indexes INVENTORY_PART_LOC_PALLET_IX1
BEGIN
   Database_SYS.Remove_Indexes('INVENTORY_PART_LOC_PALLET_TAB', 'INVENTORY_PART_LOC_PALLET_IX1', TRUE);
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RenameObsoleteTables.sql','Done');
PROMPT Finished with POST_Invent_RenameObsoleteTables.sql
