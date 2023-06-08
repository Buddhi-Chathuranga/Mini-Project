-------------------------------------------------------------------------------
--
--  Filename      : Post_Order_Remove_Defaults_G2C.sql
--
--  Module        : ORDER
--
--  Purpose       : Remove Oracle Default values from columns added by Global Extension to core tables
--                  This need to be done in a post data file to ensure error free deployment of core upgrade scripts
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  200928  PraWlk  FISPRING20-7523, Removed default setting in FINAL_CONSUMER in CUSTOMER_ORDER_TAB.
--  200923  MaRalk  SC2020R1-9694, Removed 'SET SERVEROUTPUT OFF' when preparing the file for 2020R1 Release.
--  200918  MaEelk  GESPRING20-5399, Removed default setting in at DISC_PRICE_ROUND in ORDER_QUOTATION_TAB.
--  200909  MaEelk  GESPRING20-5398, Removed default setting in at DISC_PRICE_ROUND in CUSTOMER_ORDER_TAB.
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_Order_Remove_Defaults_G2C.sql','Timestamp_1');
PROMPT Post_Order_Remove_Defaults_G2C.sql Start

-----------------------------------------------------------------------------------------
-- Removing Oracle Defaults from table columns
-----------------------------------------------------------------------------------------

-- ***** CUSTOMER_ORDER_TAB Begin *****
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_Order_Remove_Defaults_G2C.sql','Timestamp_2');
PROMPT Removing Oracle default values from columns in order_ledger_item_tab
DECLARE
   column_             Database_SYS.ColRec;
   table_              VARCHAR2(30) := 'CUSTOMER_ORDER_TAB';
BEGIN
   column_ := Database_SYS.Set_Column_Values('DISC_PRICE_ROUND', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);   
   
   column_ := Database_SYS.Set_Column_Values('FINAL_CONSUMER', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);
END;
/
-- ***** CUSTOMER_ORDER_TAB End *****

-- ***** ORDER_QUOTATION_TAB Begin *****
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_Order_Remove_Defaults_G2C.sql','Timestamp_3');
PROMPT Removing Oracle default values from columns in order_ledger_item_tab
DECLARE
   column_             Database_SYS.ColRec;
   table_              VARCHAR2(30) := 'ORDER_QUOTATION_TAB';
BEGIN
   column_ := Database_SYS.Set_Column_Values('DISC_PRICE_ROUND', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);
END;
/
-- ***** ORDER_QUOTATION_TAB End *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_Order_Remove_Defaults_G2C.sql','Timestamp_4');
PROMPT Post_Order_Remove_Defaults_G2C.sql END
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_Order_Remove_Defaults_G2C.sql','Done');






