-----------------------------------------------------------------------------
--  Module  : DISCOM
--
--  File    : POST_Discom_UpdateFOCData.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose : Moving FOC data from company_order_info_tab to company_tax_discom_info_tab.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210212   MalLlk  SC2020R1-12473, Updated the company_tax_discom_info_tab, if its company only exists in  
--  210212           company_order_info_tab, in order to avoid tring to update mandatory columns with NULL values.
--  180614   NWeeLK  Created. gelr: Added to support Global Extension Functionalities.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateFOCData.sql','Timestamp_1');
PROMPT Transfering data from columns in company_order_info_tab to company_tax_discom_info_tab
DECLARE
   stmt_           VARCHAR2(2000);
   table_name_     VARCHAR2(30) := 'COMPANY_ORDER_INFO_TAB';
BEGIN
   IF (Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_PARTY_TEMP') AND
       Database_SYS.Column_Exist(table_name_, 'TAX_BASIS_SOURCE_1410') AND
       Database_SYS.Column_Exist(table_name_, 'TAX_PAYING_THRESHOLD_AMT_TEMP')) THEN
         stmt_ :='UPDATE company_tax_discom_info_tab t
                     SET (t.tax_paying_threshold_amt, t.tax_basis_source, t.tax_paying_party) = (SELECT x.tax_paying_threshold_amt_temp,
                                                                                                        x.tax_basis_source_1410,
                                                                                                        x.tax_paying_party_temp
                                                                                                 FROM   company_order_info_tab x
                                                                                                 WHERE  x.company = t.company)
                     WHERE t.company IN (SELECT company FROM company_order_info_tab)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateFOCData.sql','Timestamp_2');
PROMPT Rename temp columns in table company_order_info_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_        VARCHAR2(30) := 'COMPANY_ORDER_INFO_TAB';
BEGIN

   new_column_name_ := 'TAX_PAYING_PARTY_1410';
   old_column_name_ := 'TAX_PAYING_PARTY_TEMP';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'TAX_PAYING_THRESHOLD_AMT_1410';
   old_column_name_ := 'TAX_PAYING_THRESHOLD_AMT_TEMP';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateFOCData.sql','Done');
PROMPT Finished with POST_Discom_UpdateFOCData.SQL
