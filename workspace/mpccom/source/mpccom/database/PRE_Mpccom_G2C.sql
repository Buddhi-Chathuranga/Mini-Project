-----------------------------------------------------------------------------
--  Module : MPCCOM
--
--  File   : PRE_Mpccom_G2C.sql
--  
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 14.1.0-GET  
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  191028  NWeelk  Added the content.
--  191004  Ashelk  Created Sample. Content will be added later
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'MPCCOM'

------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER

--       Pre Upgrade sections: acc_event_posting_type_tab 
--       Pre Upgrade sections: order_delivery_term_tab 

-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
--    Sub Section: Provide Oracle Default values to columns added to core tables

---------------------------------------------------------------------------------------------
-- SECTION 1 : HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
---------------------------------------------------------------------------------------------
--*************acc_event_posting_type_tab Start*************

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C.sql','Timestamp_1');
PROMPT Changing booking to 40 for str_code m263.

DECLARE
   columns_ Database_SYS.ColumnTabType;
BEGIN
   UPDATE ACC_EVENT_POSTING_TYPE_TAB
   SET BOOKING = 40
   WHERE STR_CODE = 'M263';
   COMMIT;
END;
/

--*************acc_event_posting_type_tab End***************

-----------------------------------------------------------------------------------------

--*************order_delivery_term_tab Start*************

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C.sql','Timestamp_2');
PROMPT Alter column receiver_resp_for_freight in order_delivery_term_tab
DECLARE
   table_name_ VARCHAR2(30) := 'ORDER_DELIVERY_TERM_TAB';
   columns_ Database_SYS.ColumnTabType ;
BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column(columns_, 'RECEIVER_RESP_FOR_FREIGHT', 'VARCHAR2(5)', 'Y');
   Database_SYS.Alter_Table(table_name_, columns_);
END;         
/

--*************order_delivery_term_tab End***************

---------------------------------------------------------------------------------------------
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -------------------------------
---------------------------------------------------------------------------------------------



UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C.sql','Done');
PROMPT Finished with PRE_Mpccom_G2C.sql
