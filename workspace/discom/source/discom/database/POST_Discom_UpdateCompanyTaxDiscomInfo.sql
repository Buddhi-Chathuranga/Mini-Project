-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : POST_Discom_UpdateCompanyTaxDiscomInfo.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose       : Moving data from company_distribution_info_tab, company_order_info_tab
--                  and company_purch_info_tab to company_tax_discom_info_tab.
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220127   HasTlk  SC21R2-7414, Added create_tax_document attribute and set value as False in Timestamp_1.
--  200729   AsZelk  SC2020R1-8927, Added default value for mandatory tax_basis_source column to avoid inserting null values.
--  171113   MAHPLK  STRSC-7556, Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateCompanyTaxDiscomInfo.sql','Timestamp_1');
PROMPT Moving data from company_distribution_info_tab to company_tax_discom_info_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'COMPANY_DISTRIBUTION_INFO_TAB';
   stmt_     VARCHAR2(32767);
BEGIN
   IF (Database_SYS.Table_Exist(table_name_)) THEN
      IF (Database_SYS.Column_Exist(table_name_, 'TAX_FREE_TAX_CODE') AND Database_SYS.Column_Exist(table_name_, 'TAX_CODE')) THEN
         stmt_ := 'INSERT INTO company_tax_discom_info_tab (company, tax_code, tax_free_tax_code, '||
                  '            order_taxable, purch_taxable, use_price_incl_tax_ord, use_price_incl_tax_pur, '||
                  '            tax_paying_party, tax_paying_threshold_amt, modify_tax_percentage, tax_basis_source, create_tax_document, rowversion) '||
                  '(SELECT company, tax_code, tax_free_tax_code , '||
                  ' ''FALSE'', ''FALSE'', ''FALSE'', ''FALSE'', '||
                  ' ''NO_TAX'', ''0'', ''TRUE'', ''PART_COST'', ''FALSE'', SYSDATE '||
                  ' FROM   company_distribution_info_tab cdi '||
                  ' WHERE NOT EXISTS (SELECT 1 '||
                  '                   FROM   company_tax_discom_info_tab ctd '||
                  '                   WHERE  ctd.company = cdi.company))';
         EXECUTE IMMEDIATE stmt_;
         COMMIT;
      END IF;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateCompanyTaxDiscomInfo.sql','Timestamp_2');
PROMPT Moving data from company_order_info_tab to company_tax_discom_info_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'COMPANY_ORDER_INFO_TAB';
   stmt_     VARCHAR2(32767);
BEGIN
   IF (Database_SYS.Table_Exist(table_name_)) THEN
      IF (Database_SYS.Column_Exist(table_name_, 'USE_PRICE_INCL_TAX') AND Database_SYS.Column_Exist(table_name_, 'TAXABLE')) THEN
         stmt_ := 'UPDATE '||
                  '(SELECT o.taxable, o.use_price_incl_tax, d.order_taxable, d.use_price_incl_tax_ord '||
                  ' FROM   company_order_info_tab o '||
                  ' INNER JOIN company_tax_discom_info_tab d '||
                  ' ON o.company = d.company '||
                  ' WHERE d.order_taxable = ''FALSE'' AND d.use_price_incl_tax_ord = ''FALSE'' '||
                  ') t '||
                  'SET t.order_taxable = t.taxable, t.use_price_incl_tax_ord = t.use_price_incl_tax ';
         EXECUTE IMMEDIATE stmt_;
         COMMIT;
      END IF;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateCompanyTaxDiscomInfo.sql','Timestamp_3');
PROMPT Moving data from company_purch_info_tab to company_tax_discom_info_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'COMPANY_PURCH_INFO_TAB';
   stmt_     VARCHAR2(32767);
BEGIN
   IF (Database_SYS.Table_Exist(table_name_)) THEN
      IF (Database_SYS.Column_Exist(table_name_, 'USE_PRICE_INCL_TAX') AND Database_SYS.Column_Exist(table_name_, 'TAXABLE')) THEN
         stmt_ := 'UPDATE '||
                  '(SELECT p.taxable, p.use_price_incl_tax, d.purch_taxable, d.use_price_incl_tax_pur '||
                  ' FROM   company_purch_info_tab p '||
                  ' INNER JOIN company_tax_discom_info_tab d '||
                  ' ON     p.company = d.company '||
                  ' WHERE  d.purch_taxable = ''FALSE'' AND d.use_price_incl_tax_pur = ''FALSE'' '||
                  ') t '||
                  'SET t.purch_taxable = t.taxable, t.use_price_incl_tax_pur = t.use_price_incl_tax ';

         EXECUTE IMMEDIATE stmt_;
         COMMIT;
      END IF;
   END IF;  
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_UpdateCompanyTaxDiscomInfo.sql','Done');
