-----------------------------------------------------------------------------
--  Module : SHPMNT
--
--  File   : PRE_Shpmnt_G2C.sql
--  
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 14.1.0-GET  
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  191004  Ashelk  Created. 
--  191025  Kagalk  Added section 1, 2 contents.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'SHPMNT'

------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
--
--    Sub Section: Make nullable/rename table columns, drop table columns from temporary tables moved to core 
--       Pre Upgrade sections:  
--
--    Sub Section: Rename tables moved to core
--       Pre Upgrade sections: 
--
--    Sub Section: Drop packages/views moved to core       
--  
--    Sub Section: Remove company creation basic data moved to core 
--
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
--
--    Sub Section: Provide Oracle Default values to columns added to core tables
--        Pre Upgrade sections: shipment_tab
--
--
------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
---------------------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C.sql','Timestamp_1');
PROMPT Starting PRE_Shpmnt_G2C.sql
                     
---------------------------------------------------------------------------------------------
--------------------- Make nullable/rename table columns moved to core-----------------------
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--------------------- Rename tables moved to core--------------------------------------------
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--------------------- Drop packages/views moved to core -------------------------------------
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--------------------- Remove company creation basic data moved to core ----------------------
---------------------------------------------------------------------------------------------


-- END SECTION 1: Handling of Functionalities moved into core/Functionalities obsolete in Ext layer

---------------------------------------------------------------------------------------------
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Add Oracle Defaults to NOT NULL Columns added to Core Tables ----------
---------------------------------------------------------------------------------------------

--************* shipment_tab Start *************

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C.sql','Timestamp_2');
PROMPT Setting default value for deliv_confirm_after_prt_invoic to shipment_tab.
DECLARE
   table_name_  VARCHAR2(30) := 'SHIPMENT_TAB';
   column_ Database_SYS.ColRec;
BEGIN
   column_ := Database_SYS.Set_Column_Values('DELIV_CONFIRM_AFTER_PRT_INVOIC', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
END;
/

--************* shipment_tab End ***************
             
-----------------------------------------------------------------------------------------
-- END SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -----------------------
-----------------------------------------------------------------------------------------


SET SERVEROUTPUT OFF

UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C.sql','Done');
PROMPT Finished with PRE_Shpmnt_G2C.sql
