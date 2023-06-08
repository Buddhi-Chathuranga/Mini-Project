--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Order_InsertMissingBasicDataTranslations.sql
--
--  Module      : ORDER 14.0.0
--
--  Purpose     : Translations were missing for some basic data, in LUs that introduced basic data translation in APP8.
--                This is used to insert the missing basic data translations in 'PROG' language to such LUs.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  140813   TiRalk  Bug 118250, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_1');
PROMPT Starting POST_Order_InsertMissingBasicDataTranslations


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_2');
PROMPT Inserting the missing basic data translations for LU CustOrderType
DECLARE
   CURSOR get_records IS
      SELECT order_id, description
      FROM   cust_order_type_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'CustOrderType', rec_.order_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'CustOrderType', rec_.order_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_3');
PROMPT Inserting the missing basic data translations for LU CustomerGroup
DECLARE
   CURSOR get_records IS
      SELECT cust_grp, description
      FROM   customer_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'CustomerGroup', rec_.cust_grp, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'CustomerGroup', rec_.cust_grp, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_4');
PROMPT Inserting the missing basic data translations for LU SalesDiscountType
DECLARE
   CURSOR get_records IS
      SELECT discount_type, description
      FROM   sales_discount_type_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesDiscountType', rec_.discount_type, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesDiscountType', rec_.discount_type, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_5');
PROMPT Inserting the missing basic data translations for LU SalesRegion
DECLARE
   CURSOR get_records IS
      SELECT region_code, description
      FROM   sales_region_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesRegion', rec_.region_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesRegion', rec_.region_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_6');
PROMPT Inserting the missing basic data translations for LU SalesDistrict
DECLARE
   CURSOR get_records IS
      SELECT district_code, description
      FROM   sales_district_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesDistrict', rec_.district_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesDistrict', rec_.district_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_7');
PROMPT Inserting the missing basic data translations for LU SalesMarket
DECLARE
   CURSOR get_records IS
      SELECT market_code, description
      FROM   sales_market_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesMarket', rec_.market_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesMarket', rec_.market_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_8');
PROMPT Inserting the missing basic data translations for LU SalesGroup
DECLARE
   CURSOR get_records IS
      SELECT catalog_group, description
      FROM   sales_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesGroup', rec_.catalog_group, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesGroup', rec_.catalog_group, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_9');
PROMPT Inserting the missing basic data translations for LU CreditControlGroup
DECLARE
   CURSOR get_records IS
      SELECT credit_control_group_id, description
      FROM   credit_control_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'CreditControlGroup', rec_.credit_control_group_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'CreditControlGroup', rec_.credit_control_group_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_10');
PROMPT Inserting the missing basic data translations for LU SalesPriceGroup
DECLARE
   CURSOR get_records IS
      SELECT sales_price_group_id, description
      FROM   sales_price_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesPriceGroup', rec_.sales_price_group_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesPriceGroup', rec_.sales_price_group_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_11');
PROMPT Inserting the missing basic data translations for LU CustMilestoneTempl
DECLARE
   CURSOR get_records IS
      SELECT template_id, description
      FROM   cust_milestone_templ_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'CustMilestoneTempl', rec_.template_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'CustMilestoneTempl', rec_.template_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_12');
PROMPT Inserting the missing basic data translations for LU ReturnMaterialReason
DECLARE
   CURSOR get_records IS
      SELECT return_reason_code, return_reason_description
      FROM   return_material_reason_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'ReturnMaterialReason', rec_.return_reason_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'ReturnMaterialReason', rec_.return_reason_code, 'PROG', rec_.return_reason_description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_13');
PROMPT Inserting the missing basic data translations for LU CommissionReceiverGroup
DECLARE
   CURSOR get_records IS
      SELECT commission_receiver_group, description
      FROM   commission_receiver_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'CommissionReceiverGroup', rec_.commission_receiver_group, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'CommissionReceiverGroup', rec_.commission_receiver_group, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_14');
PROMPT Inserting the missing basic data translations for LU SelfBillingDevReason
DECLARE
   CURSOR get_records IS
      SELECT reason, description
      FROM   self_billing_dev_reason_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SelfBillingDevReason', rec_.reason, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SelfBillingDevReason', rec_.reason, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_15');
PROMPT Inserting the missing basic data translations for LU Competitiveness
DECLARE
   CURSOR get_records IS
      SELECT compete_id, compete_description
      FROM   competitiveness_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'Competitiveness', rec_.compete_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'Competitiveness', rec_.compete_id, 'PROG', rec_.compete_description);
      END IF;
   END LOOP;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_16');
PROMPT Inserting the missing basic data translations for LU LoseWinReason
DECLARE
   CURSOR get_records IS
      SELECT reason_id, reason_description
      FROM   lose_win_reason_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'LoseWinReason', rec_.reason_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'LoseWinReason', rec_.reason_id, 'PROG', rec_.reason_description);
      END IF;
   END LOOP;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Timestamp_17');
PROMPT Inserting the missing basic data translations for LU SalesRevisionReason
DECLARE
   CURSOR get_records IS
      SELECT reason_id, reason_description
      FROM   sales_revision_reason_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('ORDER', 'SalesRevisionReason', rec_.reason_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('ORDER', 'SalesRevisionReason', rec_.reason_id, 'PROG', rec_.reason_description);
      END IF;
   END LOOP;
END;
/

PROMPT Finished with POST_Order_InsertMissingBasicDataTranslations.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_InsertMissingBasicDataTranslations.sql','Done');
