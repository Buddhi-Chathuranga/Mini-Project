-----------------------------------------------------------------------------
--  Module : MPCCOM
--
--  File   : Post_Mpccom_G2C_Data_Transfer.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180524   fiallk  Data migrations from CPA
--  200711   cecobr  gelr:brazilian_specific_attributes, Data migration from FISNOT\operation_tab to MPCCOM\business_transaction_code_tab
--  200810   Utbalk  Data migrations from NATURE_OPERATION_TAB to BUSINESS_OPERATION_TAB
--  201002   WaSalk  Corrected a column name 'company' at Data migration from NATURE_OPERATION_TAB to BUSINESS_OPERATION_TAB.
-----------------------------------------------------------------------------

SET SERVEROUT ON

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','Post_Mpccom_G2C_Data_Transfer.sql','Timestamp_1');
PROMPT Starting Post_Mpccom_G2C_Data_Transfer.sql

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','Post_Mpccom_G2C_Data_Transfer.sql','Timestamp_2');
PROMPT Supporting data migration FROM CPA
DECLARE
    stmt_ VARCHAR2(4000);
 BEGIN
   IF (Database_SYS.Table_Exist('non_inv_sales_part_cpa_1500')) THEN
      stmt_ := 'INSERT INTO  statistical_code_tab 
                 (company,
                  statistical_code,
                  description,
                  rowversion,
                  rowstate)
                  SELECT  c.company, t.cpa_code,t.description,SYSDATE,''Active'' 
                  FROM    non_inv_sales_part_cpa_1500 t,
                              company_tab c 
                  WHERE   c.localization_country =''IT''
                  AND NOT EXISTS ( SELECT 1
                                    FROM statistical_code_tab s
                                    WHERE s.company          = c.company
                                    AND   s.statistical_code = t.cpa_code)';

       EXECUTE IMMEDIATE stmt_;
    END IF;
    
    IF (Database_SYS.Table_Exist('non_inv_purchase_part_cpa_1500')) THEN
      stmt_ := 'INSERT INTO  statistical_code_tab 
                 (company,
                  statistical_code,
                  description,
                  rowversion,
                  rowstate)
                  SELECT  c.company, t.cpa_code,t.description,SYSDATE,''Active''
                  FROM    non_inv_purchase_part_cpa_1500 t,
                             company_tab c 
                  WHERE   c.localization_country =''IT''
                  AND NOT EXISTS ( SELECT 1
                                    FROM statistical_code_tab s
                                    WHERE s.company          = c.company
                                    AND   s.statistical_code = t.cpa_code)';

      EXECUTE IMMEDIATE stmt_;
    END IF;
     
    COMMIT;                         
 END;
 /


-- gelr:br_business_operation, begin
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','Post_Mpccom_G2C_Data_Transfer.sql','Timestamp_3');
PROMPT Data migrating FROM TABLE NATURE_OPERATION_TAB TO TABLE BUSINESS_OPERATION_TAB.
DECLARE                       
   stmt_    VARCHAR2(2000); 
BEGIN
   stmt_  := 'INSERT INTO BUSINESS_OPERATION_TAB 
                     (company,
                      business_operation,
                      description,
                      rowversion,
                      rowstate)
               SELECT c.company,
                      n. nature_operation,
                      n.description,
                      SYSDATE,
                      ''Active''
               FROM company_tab c
               CROSS JOIN NATURE_OPERATION_TAB n
               WHERE c.localization_country = ''BR''
               AND NOT EXISTS ( SELECT 1
                                FROM BUSINESS_OPERATION_TAB b
                                WHERE c.company = b.company)';
                                                     
   IF Database_SYS.Table_Exist('NATURE_OPERATION_TAB') AND Database_SYS.Table_Exist('BUSINESS_OPERATION_TAB') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;  
   END IF;
END;
/
-- gelr:br_business_operation, end

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','Post_Mpccom_G2C_Data_Transfer.sql','Done');
PROMPT Finished with Post_Mpccom_G2C_Data_Transfer.sql
