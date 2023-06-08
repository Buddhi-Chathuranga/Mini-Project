-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : PRE_Order_G2C.sql
--  
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 14.1.0-GET  
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210310   WaSalk  Set column exc_svc_delnote_1410 in customer_order_deliv_note_tab to nullable. 
--  210305   WaSalk  Modified names of TAX_PAYING_PARTY, EDIT_PRICE_INCL_SEL_TAX to TAX_PAYING_PARTY_TEMP, EDIT_PRICE_INCL_SEL_TAX_1410 to support GET9 UPD17 Data Integrity Test.
--  191004   Ashelk  Created Sample. Content will be added later
--  191028   kusplk  Added Section 1 and 2 content.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'ORDER'

------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
--    Sub Section: Make nullable/rename table columns, drop table columns from temporary tables moved to core
--        Pre Upgrade sections: customer_order_tab 
--        Pre Upgrade sections: company_order_info_tab
--        Pre Upgrade sections: customer_order_line_tab
--        Pre Upgrade sections: order_quotation_tab 
--        Pre Upgrade sections: order_quotation_line_tab
--        Pre Upgrade sections: cust_invoice_item_discount_tab
--        Pre Upgrade sections: customer_order_charge_tab 
--        Pre Upgrade sections: cust_order_line_discount_tab
--        Pre Upgrade sections: order_quotation_charge_tab
--        Pre Upgrade sections: quote_charge_tax_lines_tab 
--        Pre Upgrade sections: quote_line_tax_lines_tab
--        Pre Upgrade sections: return_material_charge_tab
--        Pre Upgrade sections: return_material_line_tab
--        Pre Upgrade sections: customer_order_deliv_note_tab 
--
--    Sub Section: Rename tables moved to core
--        Pre Upgrade sections: cust_ord_charge_tax_struct_tab 
--        Pre Upgrade sections: cust_ord_line_tax_struct_tab
--        Pre Upgrade sections: quote_charge_tax_struct_tab
--        Pre Upgrade sections: quote_line_tax_struct_tab 
--        Pre Upgrade sections: rma_charge_tax_struct_tab
--        Pre Upgrade sections: rma_line_tax_struct_tab
--  
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
--    Sub Section: Provide Oracle Default values to columns added to core tables
--        Pre Upgrade sections: customer_order_tab
--        Pre Upgrade sections: order_quotation_tab 
--        Pre Upgrade sections: customer_order_line_tab
--  
--    Sub Section: Make not null columns to nullable added to core tables  
--        Pre Upgrade sections: customer_order_line_tab
--        Pre Upgrade sections: order_quotation_line_tab

---------------------------------------------------------------------------------------------
-- SECTION 1 : HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
---------------------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_1');
PROMPT Starting PRE_Order_G2C.sql

---------------------------------------------------------------------------------------------
--------------------- Make nullable/rename table columns moved to core-----------------------
---------------------------------------------------------------------------------------------

-- ***** customer_order_tab Start *****
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_2');
PROMPT Rename columns in table customer_order_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_        VARCHAR2(30) := 'CUSTOMER_ORDER_TAB';
BEGIN
   new_column_name_ := 'BRANCH_ID_1410';
   old_column_name_ := 'BRANCH_ID';  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;  
   
   new_column_name_ := 'BRANCH_DESC_1410';
   old_column_name_ := 'BRANCH_DESC';  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'EDIT_PRICE_INCL_SEL_TAX_1410';
   old_column_name_ := 'EDIT_PRICE_INCL_SEL_TAX';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_))AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'INCLUDE_INDIAN_EXCISE_INF_1410';
   old_column_name_ := 'INCLUDE_INDIAN_EXCISE_INFO';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_))AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'TAX_PAYING_PARTY_TEMP';
   old_column_name_ := 'TAX_PAYING_PARTY';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_3');
PROMPT Set columns tax_paying_party, edit_price_incl_sel_tax in table customer_order_tab to nullable
DECLARE
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_TAB';
BEGIN
   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_PARTY_TEMP') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_PARTY_TEMP', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'EDIT_PRICE_INCL_SEL_TAX_1410') THEN
      column_ := Database_SYS.Set_Column_Values('EDIT_PRICE_INCL_SEL_TAX_1410', nullable_ =>'Y');       
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;
END;
/

-- ***** customer_order_tab End *****


-- ***** company_order_info_tab Start ********
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_4');
PROMPT Set columns in table company_order_info_tab to nullable 
DECLARE
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'COMPANY_ORDER_INFO_TAB';
BEGIN
   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_PARTY') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_PARTY', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_THRESHOLD_AMT') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_THRESHOLD_AMT', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'TAX_BASIS_SOURCE') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_BASIS_SOURCE', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_PARTY') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_PARTY', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_THRESHOLD_AMT') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_THRESHOLD_AMT', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;

   IF Database_SYS.Column_Exist(table_name_, 'TAX_BASIS_SOURCE') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_BASIS_SOURCE', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_5');
PROMPT Rename columns in table company_order_info_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'COMPANY_ORDER_INFO_TAB';
BEGIN
   new_column_name_ := 'TAX_PAYING_PARTY_TEMP';
   old_column_name_ := 'TAX_PAYING_PARTY';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'TAX_PAYING_THRESHOLD_AMT_TEMP';
   old_column_name_ := 'TAX_PAYING_THRESHOLD_AMT';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'TAX_BASIS_SOURCE_1410';
   old_column_name_ := 'TAX_BASIS_SOURCE';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/
-- ***** company_order_info_tab End *****


-- ***** customer_order_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_6');
PROMPT Set column free_of_charge in table customer_order_line_tab to nullable
DECLARE  
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_LINE_TAB';
BEGIN 
   IF Database_SYS.Column_Exist(table_name_, 'FREE_OF_CHARGE') THEN
      column_ := Database_SYS.Set_Column_Values('FREE_OF_CHARGE', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_7');
PROMPT Rename columns in table customer_order_line_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_LINE_TAB';
BEGIN
   
   new_column_name_ := 'FREE_OF_CHARGE_TEMP';
   old_column_name_ := 'FREE_OF_CHARGE';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'FREE_OF_CHARGE_TAX_BASIS_TEMP';
   old_column_name_ := 'FREE_OF_CHARGE_TAX_BASIS';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT_1410';
   old_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'PRICE_INCL_SEL_TAX_1410';
   old_column_name_ := 'PRICE_INCL_SEL_TAX';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'PRICE_INCL_SEL_TAX_BASE_1410';
   old_column_name_ := 'PRICE_INCL_SEL_TAX_BASE';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** customer_order_line_tab End *****


-- ***** order_quotation_tab Start *****
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_8');
PROMPT Set column tax_paying_party in table order_quotation_tab to nullable
DECLARE  
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'ORDER_QUOTATION_TAB';
BEGIN 
   IF Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_PARTY') THEN
      column_ := Database_SYS.Set_Column_Values('TAX_PAYING_PARTY', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;   
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_9');
PROMPT Rename column tax_paying_party in table order_quotation_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'ORDER_QUOTATION_TAB';
BEGIN
   
   new_column_name_ := 'TAX_PAYING_PARTY_TEMP';
   old_column_name_ := 'TAX_PAYING_PARTY';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** order_quotation_tab End *****


-- ***** order_quotation_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_10');
PROMPT Set column free_of_charge in table order_quotation_line_tab to nullable
DECLARE  
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'ORDER_QUOTATION_LINE_TAB';
BEGIN 
   IF Database_SYS.Column_Exist(table_name_, 'FREE_OF_CHARGE') THEN
      column_ := Database_SYS.Set_Column_Values('FREE_OF_CHARGE', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;   
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_11');
PROMPT Rename columns in table order_quotation_line_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'ORDER_QUOTATION_LINE_TAB';
BEGIN
   
   new_column_name_ := 'FREE_OF_CHARGE_TEMP';
   old_column_name_ := 'FREE_OF_CHARGE';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'FREE_OF_CHARGE_TAX_BASIS_TEMP';
   old_column_name_ := 'FREE_OF_CHARGE_TAX_BASIS';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT_1410';
   old_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

END;
/

-- ***** order_quotation_line_tab End *****


-- ***** cust_invoice_item_discount_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_12');
PROMPT Rename columns in table cust_invoice_item_discount_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'CUST_INVOICE_ITEM_DISCOUNT_TAB';
BEGIN
   new_column_name_ := 'CALCULATION_BASIS_INCL_SE_1410';
   old_column_name_ := 'CALCULATION_BASIS_INCL_SEL_TAX';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'DISCOUNT_AMOUNT_INCL_SE_1410';
   old_column_name_ := 'DISCOUNT_AMOUNT_INCL_SEL_TAX';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'PRICE_INCL_SEL_TAX_CUR_1410';
   old_column_name_ := 'PRICE_INCL_SEL_TAX_CURRENCY';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   
   new_column_name_ := 'PRICE_INCL_SEL_TAX_BASE_1410';
   old_column_name_ := 'PRICE_INCL_SEL_TAX_BASE';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** cust_invoice_item_discount_tab End *****


-- ***** customer_order_charge_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_13');
PROMPT Rename columns in table customer_order_charge_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_CHARGE_TAB';
BEGIN
   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** customer_order_charge_tab End ***** 


-- ***** cust_order_line_discount_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_14');
PROMPT Rename columns in table cust_order_line_discount_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'CUST_ORDER_LINE_DISCOUNT_TAB';
BEGIN
   new_column_name_ := 'CALCULATION_BASIS_INCL_SE_1410';
   old_column_name_ := 'CALCULATION_BASIS_INCL_SEL_TAX';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   new_column_name_ := 'DISCOUNT_AMOUNT_INCL_SE_1410';
   old_column_name_ := 'DISCOUNT_AMOUNT_INCL_SEL_TAX';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   new_column_name_ := 'PRICE_INCL_SEL_TAX_CUR_1410';
   old_column_name_ := 'PRICE_INCL_SEL_TAX_CURRENCY';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
      new_column_name_ := 'PRICE_INCL_SEL_TAX_BASE_1410';
      old_column_name_ := 'PRICE_INCL_SEL_TAX_BASE';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;   
/

-- ***** cust_order_line_discount_tab End *****


-- ***** order_quotation_charge_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_15');
PROMPT Rename columns in table order_quotation_charge_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'ORDER_QUOTATION_CHARGE_TAB';
BEGIN
   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** order_quotation_charge_tab End ***** 


-- ***** quote_charge_tax_lines_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_16');
PROMPT Rename columns in table quote_charge_tax_lines_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'QUOTE_CHARGE_TAX_LINES_TAB';
BEGIN
   new_column_name_ := 'TAX_AMOUNT_1410';
   old_column_name_ := 'TAX_AMOUNT';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   new_column_name_ := 'TAX_AMOUNT_CURR_1410';
   old_column_name_ := 'TAX_AMOUNT_CURR';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** quote_charge_tax_lines_tab End *****


-- ***** quote_line_tax_lines_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_17');
PROMPT Rename columns in table quote_line_tax_lines_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'QUOTE_LINE_TAX_LINES_TAB';
BEGIN
   new_column_name_ := 'TAX_AMOUNT_1410';
   old_column_name_ := 'TAX_AMOUNT';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   new_column_name_ := 'TAX_AMOUNT_CURR_1410';
   old_column_name_ := 'TAX_AMOUNT_CURR';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** quote_line_tax_lines_tab End *****


-- ***** return_material_charge_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_18');
PROMPT Rename columns in table return_material_charge_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'RETURN_MATERIAL_CHARGE_TAB';
BEGIN
   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** return_material_charge_tab End ***** 


-- ***** return_material_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_19');
PROMPT Rename columns in table return_material_line_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'RETURN_MATERIAL_LINE_TAB';
BEGIN
   new_column_name_ := 'TAX_CODE_STRUCT_ID_1410';
   old_column_name_ := 'TAX_CODE_STRUCT_ID';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_))AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
   new_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT_1410';
   old_column_name_ := 'UNIT_MANUAL_BASE_AMOUNT';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** return_material_line_tab End *****  



--*************customer_order_deliv_note_tab Start*************

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_20');
PROMPT Rename columns in customer_order_deliv_note_tab 
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_DELIV_NOTE_TAB';
BEGIN
   new_column_name_ := 'EXC_SVC_DELNOTE_1410';
   old_column_name_ := 'EXC_SVC_DELNOTE';
  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;   
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_21');
PROMPT Set column exc_svc_delnote_1410 in customer_order_deliv_note_tab to nullable
DECLARE  
   column_       Database_SYS.ColRec;
   table_name_   VARCHAR2(30) := 'CUSTOMER_ORDER_DELIV_NOTE_TAB';
BEGIN 
   IF Database_SYS.Column_Exist(table_name_, 'EXC_SVC_DELNOTE_1410') THEN
      column_ := Database_SYS.Set_Column_Values('EXC_SVC_DELNOTE_1410', nullable_ =>'Y'); 
      Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
   END IF;   
END;
/

--*************customer_order_deliv_note_tab End***************

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Rename tables moved to core--------------------------------------------
---------------------------------------------------------------------------------------------

-- ***** cust_ord_charge_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_22');
PROMPT Rename table cust_ord_charge_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'CUST_ORD_CHARGE_TAX_STRUCT_TAB';
   new_table_name_ := 'CUST_ORD_CHARGE_TAX_STRUC_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN  
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** cust_ord_charge_tax_struct_tab End *****


-- ***** cust_ord_line_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_23');
PROMPT Rename table cust_ord_line_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'CUST_ORD_LINE_TAX_STRUCT_TAB';
   new_table_name_ := 'CUST_ORD_LINE_TAX_STRUC_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** cust_ord_line_tax_struct_tab End *****


-- ***** quote_charge_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_24');
PROMPT Rename table quote_charge_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'QUOTE_CHARGE_TAX_STRUCT_TAB';
   new_table_name_ := 'QUOTE_CHARGE_TAX_STRUC_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** quote_charge_tax_struct_tab End *****

-- ***** quote_line_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_25');
PROMPT Rename table quote_line_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'QUOTE_LINE_TAX_STRUCT_TAB';
   new_table_name_ := 'QUOTE_LINE_TAX_STRUCT_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** quote_charge_tax_struct_tab End *****


-- ***** rma_charge_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_26');
PROMPT Rename table rma_charge_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'RMA_CHARGE_TAX_STRUCT_TAB';
   new_table_name_ := 'RMA_CHARGE_TAX_STRUCT_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** rma_charge_tax_struct_tab End *****


-- ***** rma_line_tax_struct_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_27');
PROMPT Rename table rma_line_tax_struct_tab
DECLARE
   new_table_name_   VARCHAR2(30);
   old_table_name_   VARCHAR2(30);
BEGIN
   old_table_name_ := 'RMA_LINE_TAX_STRUCT_TAB';
   new_table_name_ := 'RMA_LINE_TAX_STRUCT_1410';
  
   IF Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, FALSE, TRUE, TRUE, TRUE);
   END IF;
END;
/

-- ***** rma_line_tax_struct_tab End *****

---------------------------------------------------------------------------------------------
--------------------- Drop packages/views moved to core -------------------------------------
---------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_28');
PROMPT Removing  packages moved to core
BEGIN
  Database_SYS.Remove_Package('TAX_PAYING_PARTY_API', TRUE);
  Database_SYS.Remove_Package('TAX_BASIS_SOURCE_API', TRUE);
  Database_SYS.Remove_Package('CUST_ORD_CHARGE_TAX_STRUCT_API', TRUE);
  Database_SYS.Remove_Package('CUST_ORD_LINE_TAX_STRUCT_API', TRUE);
  Database_SYS.Remove_Package('QUOTE_CHARGE_TAX_STRUCT_API', TRUE);
  Database_SYS.Remove_Package('QUOTE_LINE_TAX_STRUCT_API', TRUE);
  Database_SYS.Remove_Package('RMA_CHARGE_TAX_STRUCT_API', TRUE);
  Database_SYS.Remove_Package('RMA_LINE_TAX_STRUCT_API', TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_29');
PROMPT Removing  views moved to core
BEGIN
   Database_SYS.Remove_View('CUST_ORD_CHARGE_TAX_STRUCT', TRUE);
   Database_SYS.Remove_View('CUST_ORD_LINE_TAX_STRUCT', TRUE);
   Database_SYS.Remove_View('QUOTE_CHARGE_TAX_STRUCT', TRUE);
   Database_SYS.Remove_View('QUOTE_LINE_TAX_STRUCT', TRUE);
   Database_SYS.Remove_View('RMA_CHARGE_TAX_STRUCT', TRUE);
   Database_SYS.Remove_View('RMA_LINE_TAX_STRUCT', TRUE);
END;
/
---------------------------------------------------------------------------------------------
--------------------- Remove company creation basic data moved to core ----------------------
---------------------------------------------------------------------------------------------

-- Add If any, here


-- END SECTION 1: Handling of Functionalities moved into core/Functionalities obsolete in Ext layer---


---------------------------------------------------------------------------------------------
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -------------------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Add Oracle Defaults to NOT NULL Columns added to Core Tables ----------
---------------------------------------------------------------------------------------------

-- ***** customer_order_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_30');
PROMPT Setting default values for columns in customer_order_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'CUSTOMER_ORDER_TAB';
   column_     Database_SYS.ColRec;
   columns_    Database_SYS.ColumnTabType ;
BEGIN
   column_ := Database_SYS.Set_Column_Values('DISC_PRICE_ROUND', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table_Column (table_name_, 'M', column_, TRUE);

   column_ := Database_SYS.Set_Column_Values('DELIV_CONFIRM_AFTER_PRT_INVOIC', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);

   Database_SYS.Set_Table_Column(columns_, 'FINAL_CONSUMER', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table(table_name_, columns_, TRUE);
END;
/

-- ***** customer_order_tab End *****


-- ***** order_quotation_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_31');
PROMPT Setting default value for disc_price_round to order_quotation_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'ORDER_QUOTATION_TAB';
   column_     Database_SYS.ColRec;
BEGIN
   column_ := Database_SYS.Set_Column_Values('DISC_PRICE_ROUND', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table_Column(table_name_, 'M', column_, TRUE);
END;
/

-- ***** order_quotation_tab End *****


-- ***** customer_order_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_32');
PROMPT Setting default value for released_iss_value_prorate to customer_order_line_tab.
DECLARE
   table_name_  VARCHAR2(30) := 'CUSTOMER_ORDER_LINE_TAB';
   column_ Database_SYS.ColRec;
BEGIN
   column_ := Database_SYS.Set_Column_Values('RELEASED_ISS_VALUE_PRORATE', default_value_ =>'''FALSE''');
   Database_SYS.Alter_Table_Column(table_name_ , 'M', column_, TRUE);
END;
/

-- ***** customer_order_line_tab End *****

---------------------------------------------------------------------------------------------
----------------------Make not null columns to nullable added to core tables-----------------
---------------------------------------------------------------------------------------------

-- ***** customer_order_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_33');
PROMPT Making original_order_discount, original_discount, original_add_discount nullable in customer_order_line_tab.
DECLARE
   columns_       Database_SYS.ColumnTabType ;
BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_ORDER_DISCOUNT', 	'NUMBER', 'Y');
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_DISCOUNT',       	'NUMBER', 'Y');
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_ADD_DISCOUNT',      'NUMBER', 'Y');
   Database_SYS.Alter_Table( 'CUSTOMER_ORDER_LINE_TAB', columns_ );
END;
/    
-- ***** customer_order_line_tab End *****


-- ***** order_quotation_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Timestamp_34');
PROMPT Making original_order_discount, original_discount, original_add_discount nullable in order_quotation_line_tab.
DECLARE
   columns_       Database_SYS.ColumnTabType ;
BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_QUOTATION_DISCOUNT', 'NUMBER', 'Y');
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_DISCOUNT', 'NUMBER', 'Y');
   Database_SYS.Set_Table_Column (columns_ , 'ORIGINAL_ADD_DISCOUNT', 'NUMBER', 'Y');
   Database_SYS.Alter_Table( 'ORDER_QUOTATION_LINE_TAB', columns_ );
END;
/

-- ***** order_quotation_line_tab End *****


---------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

-- END SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -----------------------

UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C.sql','Done');
PROMPT Finished with PRE_Order_G2C.sql
