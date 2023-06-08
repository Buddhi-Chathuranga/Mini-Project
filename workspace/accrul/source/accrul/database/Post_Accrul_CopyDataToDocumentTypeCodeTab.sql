-----------------------------------------------------------------------------
--  Module : ACCRUL
--
--  File   : Post_Accrul_CopyDataToDocumentTypeCodeTab.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220104   Ckumlk  FI21R2-8021, Copy data and translations from invoice_item_text_tab to document_type_code_tab.
--  220228   Ckumlk  FIDEV-9218, Renamed file as Post_Accrul_CopyDataToDocumentTypeCodeTab.sql.
--  220323   ckumlk  FIDEV-8879,  Correction for Copy translations from invoice_item_text_tab to document_type_code_tab.
-----------------------------------------------------------------------------
    
SET SERVEROUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_CopyDataToDocumentTypeCodeTab.sql','Timestamp_1');
PROMPT Starting Post_Accrul_CopyDataToDocumentTypeCodeTab.SQL

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_CopyDataToDocumentTypeCodeTab.sql','Timestamp_2');
PROMPT Data migrating from invoice_item_text_tab to document_type_code_tab

DECLARE
   table_name_     VARCHAR2(30) := 'invoice_item_text_tab';
   stmt_           VARCHAR2(3000);
BEGIN
   stmt_ := 'INSERT INTO document_type_code_tab
               (  company,
                  document_type_code,
                  description,
                  rowversion,
                  rowkey )
               (SELECT
                  company,
                  text_id,
                  text,
                  SYSDATE,
                  rowkey
               FROM invoice_item_text_tab t
               WHERE t.text_id in (''TD02'', ''TD05'', ''TD16'', ''TD17'', ''TD18'', ''TD19'', ''TD20'', ''TD21'', ''TD22'', ''TD23'', ''TD25'', ''TD26'')
               AND NOT EXISTS (SELECT 1
                               FROM  document_type_code_tab
                               WHERE company            = t.company
                               AND   document_type_code = t.text_id ))';
   IF (Database_SYS.Table_Exist(table_name_)) THEN
      EXECUTE IMMEDIATE stmt_ ;
      COMMIT;
   END IF;
   
   -- Insert Translations into key_lu_attribute_tab
   INSERT INTO key_lu_attribute_tab  
               (    key_name,
                    key_value,
                    module,
                    lu,
                    attribute_key,
                    attribute_text,
                    first_reg_text,
                    rowversion,
                    rowkey,
                    rowtype)
               (SELECT
                    key_name,
                    key_value,
                    'ACCRUL',
                    'DocumentTypeCode',
                    attribute_key,
                    attribute_text,
                    first_reg_text,
                    SYSDATE,
                    sys_guid(),
                    rowtype
               FROM key_lu_attribute_tab t
               WHERE t.attribute_key in ('TD02', 'TD05', 'TD16', 'TD17', 'TD18', 'TD19', 'TD20', 'TD21', 'TD22', 'TD23', 'TD25', 'TD26')
               AND   t.module = 'INVOIC' 
               AND   t.lu     = 'InvoiceItemText'
               AND NOT EXISTS (SELECT 1
                               FROM  key_lu_attribute_tab
                               WHERE key_name      = t.key_name
                               AND   key_value     = t.key_value
                               AND   module        = 'ACCRUL'
                               AND   lu            = 'DocumentTypeCode'
                               AND   attribute_key =  t.attribute_key));
   
   -- Insert Translations into key_lu_translation_tab
   INSERT INTO key_lu_translation_tab
            (    key_name,
                 key_value,
                 module,
                 lu,
                 attribute_key,
                 language_code,
                 current_translation,
                 installation_translation,
                 system_defined,
                 rowversion,
                 ROWTYPE,
                 rowkey)
            (SELECT
                 t.key_name,
                 t.key_value,
                 'ACCRUL',
                 'DocumentTypeCode',
                 t.attribute_key,
                 t.language_code,
                 t.current_translation,
                 t.installation_translation,
                 t.system_defined,
                 SYSDATE,
                 t.rowtype,
                 sys_guid()
            FROM key_lu_translation_tab t
            WHERE t.attribute_key in ('TD02', 'TD05', 'TD16', 'TD17', 'TD18', 'TD19', 'TD20', 'TD21', 'TD22', 'TD23', 'TD25', 'TD26')
            AND   t.module = 'INVOIC' 
            AND   t.lu     = 'InvoiceItemText'
            AND NOT EXISTS (SELECT 1
                            FROM  key_lu_translation_tab
                            WHERE key_name      = t.key_name
                            AND   key_value     = t.key_value
                            AND   module        = 'ACCRUL'
                            AND   lu            = 'DocumentTypeCode'
                            AND   attribute_key = t.attribute_key
                            AND   language_code = t.language_code));
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_CopyDataToDocumentTypeCodeTab.sql','Done');
PROMPT Finished with Post_Accrul_CopyDataToDocumentTypeCodeTab.sql