-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : Post_Discom_G2C_Data_Transfer.sql
--
--  IFS Developer Studio Template Version 3.0
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211217   NiRalk  SC21R2-5531, Code block for data migration from DESTINATION_TAB to ACQUISITION_REASON_TAB moved to POST_INVENT_G2c_Data_Transfer.sql
--  211014   cecobr  FI21R2-4615, Move Entity and associated clint/logic of BusinessTransactionCode from MPCCOM to DISCOM
--  210407   Carabr  Data migration from DESTINATION_TAB to ACQUISITION_REASON_TAB
-----------------------------------------------------------------------------

SET SERVEROUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_G2C_Data_Transfer.sql','Timestamp_1');
PROMPT Starting Post_Discom_G2C_Data_Transfer.sql

-- gelr:brazilian_specific_attributes, begin
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_G2C_Data_Transfer.sql','Timestamp_2');
PROMPT Data migrating FROM TABLE operation_tab TO TABLE business_transaction_id_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'operation_tab';
   stmt_       VARCHAR2(2000);

   TYPE operation_reg_cursor        IS REF CURSOR;
   TYPE rec_type                    IS RECORD
        (company                    VARCHAR2(20),
         operation_id               NUMBER,
         description                VARCHAR2(50),
         direction                  VARCHAR2(50),
         presence_type              VARCHAR2(50) );
   get_operation_reg                operation_reg_cursor;
   rec_                             rec_type;
   sel_stmt_get_operation_reg VARCHAR2(2000) := 'SELECT c.company,
                                                        o.operation_id, 
                                                        o.description, 
                                                        DECODE(o.operation_type, ''1'', ''INBOUND'', ''OUTBOUND'') direction, 
                                                        DECODE(presence_type, ''0'', ''NOT_APPLIED'', ''1'', ''PRESENCE_ONSITE'', ''2'', ''INTERNET'', ''3'', ''PHONE'', ''9'', ''NON_PRESENCE'', ''5'', ''PRESENCE_OFFSITE'') presence_type
                                                        FROM   operation_tab o, company_tab c
                                                        WHERE c.localization_country = ''BR''';
BEGIN
   IF (Database_SYS.Column_Exist(table_name_, 'OPERATION_ID') AND Database_SYS.Column_Exist(table_name_, 'DESCRIPTION') AND
       Database_SYS.Column_Exist(table_name_, 'OPERATION_TYPE') AND Database_SYS.Column_Exist(table_name_, 'PRESENCE_TYPE')) THEN   
         
      OPEN get_operation_reg FOR sel_stmt_get_operation_reg;
      LOOP 
         FETCH get_operation_reg INTO rec_;
         EXIT WHEN get_operation_reg%NOTFOUND;
         
         BEGIN
            stmt_ := 'INSERT INTO business_transaction_id_tab(company, business_transaction_id, description, direction, presence_type, ROWVERSION)
            VALUES (:company_, :business_transaction_id, :description, :direction, :presence_type, SYSDATE)';

            EXECUTE IMMEDIATE stmt_ USING rec_.company, rec_.operation_id, rec_.description, rec_.direction, rec_.presence_type;
         
         EXCEPTION  
         WHEN dup_val_on_index  THEN 
            NULL;
         END;
      END LOOP;
      CLOSE get_operation_reg;
      COMMIT;
      
   END IF;
END;
/
-- gelr:brazilian_specific_attributes, end

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_G2C_Data_Transfer.sql','Done');
PROMPT Finished with Post_Discom_G2C_Data_Transfer.sql
