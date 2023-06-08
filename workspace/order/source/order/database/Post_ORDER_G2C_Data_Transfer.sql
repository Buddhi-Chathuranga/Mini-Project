-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : Post_ORDER_G2C_Data_Transfer.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210430   cecobr  FI21R2-916, gelr:brazilian_specific_attributes, Add Acquisition Reason to Business Transaction, Sales Part and CO Line
-----------------------------------------------------------------------------

SET SERVEROUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_ORDER_G2C_Data_Transfer.sql','Timestamp_1');
PROMPT Starting Post_ORDER_G2C_Data_Transfer.sql



-- gelr:brazilian_specific_attributes, begin
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_ORDER_G2C_Data_Transfer.sql','Timestamp_2');
PROMPT Data migrating FROM TABLE tax_part_tab TO TABLE sales_part_tab.
DECLARE
   table_name_ VARCHAR2(30) := 'tax_part_tab';
   stmt_       VARCHAR2(2000);

   TYPE tax_part_reg_cursor         IS REF CURSOR;
   TYPE rec_type                    IS RECORD
        (contract                   VARCHAR2(5),
         part_no                    VARCHAR2(25),
         destination                VARCHAR2(10) );
   get_tax_part_reg                 tax_part_reg_cursor;
   rec_                             rec_type;
   sel_stmt_get_tax_part_reg        VARCHAR2(2000) := 'SELECT t.contract, t.part_no, t.destination 
                                                         FROM tax_part_tab t, sales_part_tab s
                                                         WHERE t.fiscal_part_type = ''2''
                                                           AND t.destination      IS NOT NULL
                                                           AND s.contract         = t.contract
                                                           AND s.part_no          = t.part_no';
BEGIN
   -- gelr:brazilian_specific_attributes, begin
   IF (Database_SYS.Column_Exist(table_name_, 'FISCAL_PART_TYPE') AND Database_SYS.Column_Exist(table_name_, 'DESTINATION') AND
       Database_SYS.Column_Exist(table_name_, 'CONTRACT') AND Database_SYS.Column_Exist(table_name_, 'PART_NO')) THEN   
         
      OPEN get_tax_part_reg FOR sel_stmt_get_tax_part_reg;
      LOOP 
         FETCH get_tax_part_reg INTO rec_;
         EXIT WHEN get_tax_part_reg%NOTFOUND;
         
         BEGIN
            stmt_ := 'UPDATE sales_part_TAB SET acquisition_reason_id = :destination WHERE contract = :contract AND part_no = :part_no';

            EXECUTE IMMEDIATE stmt_ USING rec_.destination, rec_.contract, rec_.part_no;
         
         EXCEPTION  
         WHEN dup_val_on_index  THEN 
            NULL;
         END;
      END LOOP;
      CLOSE get_tax_part_reg;
      COMMIT;
      
   END IF;
END;
/
-- gelr:brazilian_specific_attributes, end


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','Post_ORDER_G2C_Data_Transfer.sql','Done');
PROMPT Finished with Post_ORDER_G2C_Data_Transfer.sql
