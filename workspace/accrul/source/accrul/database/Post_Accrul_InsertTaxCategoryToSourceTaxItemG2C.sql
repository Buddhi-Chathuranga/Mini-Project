-----------------------------------------------------------------------------
--
--  Filename      : Post_Accrul_InsertTaxCategoryToSourceTaxItemG2C.sql
--
--  Module        : ACCRUL
--
--  Purpose       : Move tax_category data from invoice_item_tab to source_tax_item_tab.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220111   Kgamlk  FI21R2-7209, Created, Copy code_of_supply and cs_fill_mode_code from invoice_item_tab to tax_category1 and tax_category2 source_tax_item_tab.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

-- gelr: cz_tax_reporting, start

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_InsertTaxCategoryToSourceTaxItemG2C.sql','Timestamp_1');
PROMPT set values for TAX_CATEGORY1 and TAX_CATEGORY2 columns in SOURCE_TAX_ITEM_TAB from INVOICE_ITEM_TAB.
DECLARE
   stmt_         VARCHAR2(4000);
BEGIN
   IF (Database_SYS.Column_Exist('SOURCE_TAX_ITEM_TAB','TAX_CATEGORY1') AND Database_SYS.Column_Exist('SOURCE_TAX_ITEM_TAB', 'TAX_CATEGORY2')
      AND Database_SYS.Column_Exist('INVOICE_ITEM_TAB','CODE_OF_SUPPLY_2210') AND Database_SYS.Column_Exist('INVOICE_ITEM_TAB', 'CS_FILL_MODE_CODE_2210')) THEN
      stmt_ := 'UPDATE source_tax_item_tab t
                  SET t.tax_category1  = (SELECT i.code_of_supply_2210
                                          FROM  invoice_item_tab i
                                          WHERE i.company      = t.company
                                          AND   i.invoice_id   = t.source_ref1
                                          AND   i.item_id      = t.source_ref2),
                      t.tax_category2  = (SELECT i.cs_fill_mode_code_2210
                                          FROM  invoice_item_tab i
                                          WHERE i.company      = t.company
                                          AND   i.invoice_id   = t.source_ref1
                                          AND   i.item_id      = t.source_ref2)
                  WHERE t.source_ref_type = ''INVOICE''
                  AND   t.source_ref3     = ''*''
                  AND   t.source_ref4     = ''*''
                  AND   t.source_ref5     = ''*''
                  AND   t.tax_category1   IS NULL
                  AND   EXISTS (SELECT x.company
                                FROM company_localization_info_tab x
                                WHERE x.parameter       = ''CZ_TAX_REPORTING''
                                AND x.parameter_value   = ''TRUE''
                                AND x.company           = t.company)';
      Execute IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/
-- gelr: cz_tax_reporting, end

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_InsertTaxCategoryToSourceTaxItemG2C.sql','Done');