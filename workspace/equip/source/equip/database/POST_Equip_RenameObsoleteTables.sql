-------------------------------------------------------------------------------
--
--  Filename: POST_Equip_RenameObsoleteTables.sql
--
--  Module  : EQUIP 
--  
--  Purpose : Use this file to rename obsolete tables at the end of the installation.
--            The tables listed in this file are referred in components outside EQUIP
--            and therefore needs to be renamed at the end of the installation.
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  160330  Chamlk  STRSA-3713, Moved rename table statement for equipment_object_address_tab from 800.upg.
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON
EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RenameObsoleteTables.sql','Timestamp_1');
PROMPT Starting POST_Equip_RenameObsoleteTables.sql

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RenameObsoleteTables.sql','Timestamp_2');
PROMPT Rename obsolete table EQUIPMENT_OBJECT_ADDRESS_TAB.
BEGIN
   IF NOT(Database_Sys.Table_Exist('EQUIPMENT_OBJECT_ADDRESS_800')) THEN
      Database_SYS.Rename_Table('EQUIPMENT_OBJECT_ADDRESS_TAB', 'EQUIPMENT_OBJECT_ADDRESS_800',TRUE);    
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RenameObsoleteTables.sql','Done');


