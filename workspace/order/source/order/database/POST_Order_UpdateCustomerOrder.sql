-----------------------------------------------------------------------------
--
--  Filename      : POST_Order_UpdateCustomerOrder.sql
--
--  Module        : ORDER
--
--  Purpose       : This is to update the column Main_Representative_Id for the existing records in Customer_Order_Tab.
--                  If the user that created the Customer Order is a Business Representative, he is added as the Main
--                  Representative of the CO. If not, the Main Representative of the Customer is added. Otherwise, the
--                  CO Main Representative will be kept as NULL.
--
--  Date           Sign    History
--  ------------   ------  --------------------------------------------------
--  201009         HaPulk  SC2020R1-10456, No need to check Table_Exist since all components are installed.
--  200923         MaRalk  SC2020R1-9694, Removed 'SET SERVEROUTPUT OFF' when preparing the file for 2020R1 Release.
--  170403         KoDelk  STRSC-6363, Rename BusinessObjectRep to BusObjRepresentative
--  161206         SudJlk  VAULT-2190, Added block to insert a new record to business_object_rep_tab for the particular
--  161206                 customer_order_tab record.
--  161111         SudJlk  Created.
--  ------------   ------  --------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateCustomerOrder.sql','Timestamp_1');
PROMPT Starting POST_Order_UpdateCustomerOrder.SQL
PROMPT Update new column Main_Representative_Id in Customer_Order_Tab
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   --IF Database_SYS.Table_Exist('CRM_CUST_INFO_TAB') AND Database_SYS.Table_Exist('BUSINESS_REPRESENTATIVE_TAB') THEN

      -- The first step - If the user that created the Customer Order is a Business Representative
      -- The second step - If the main representative is still null, add the customer's main representative
      stmt_ := 'BEGIN  '||
               '   UPDATE customer_Order_tab co '||
               '   SET co.main_representative_id = (SELECT pi.person_id '||
               '                                    FROM person_info_tab pi, customer_order_history_tab coh, business_representative_tab br '||
               '                                    WHERE pi.user_id = coh.userid '||
               '                                    AND coh.hist_state = ''Planned'' '||
               '                                    AND coh.message_text = ''Planned'' '||
               '                                    AND co.order_no = coh.order_no '||
               '                                    AND pi.person_id = br.representative_id) '||
               '   WHERE co.main_representative_id IS NULL; '||
               '   UPDATE customer_Order_tab co '||
               '   SET co.main_representative_id = (SELECT cci.main_representative_id '||
               '                                    FROM crm_cust_info_tab cci '||
               '                                    WHERE cci.customer_id = co.customer_no) '||
               '   WHERE co.main_representative_id IS NULL; '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   --END IF;
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateCustomerOrder.sql','Timestamp_2');
PROMPT Insert new RECORD TO bus_obj_representative_tab

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- Even though we are inserting a record to a table in RMCOM, it has to be done in the same ORDER post script as this insertion
   -- depends on the customer order update that is been done in the previous block. A record can be inserted to bus_obj_representative_tab
   -- only if the relevant record in customer_order_tab has been updated with the main representative id.
   -- The check for CRM_CUST_INFO_TAB is done here as well to make sure CRM is installed.
   --IF Database_SYS.Table_Exist('CRM_CUST_INFO_TAB') AND Database_SYS.Table_Exist('BUS_OBJ_REPRESENTATIVE_TAB') THEN
      stmt_ := 'DECLARE  '||
               '   object_type_   VARCHAR2(30);' ||
               '   main_rep_      VARCHAR2(5);' ||
               'BEGIN  '||
               '   object_type_ :=  Business_Object_Type_API.DB_CUSTOMER_ORDER; '||
               '   main_rep_ :=  Fnd_Boolean_API.DB_TRUE; '||
               '   INSERT INTO bus_obj_representative_tab (business_object_id, business_object_type, representative_id, main_representative, rowversion, rowkey) '||
               '   (SELECT co.order_no, object_type_, co.main_representative_id, main_rep_, SYSDATE, sys_guid() '||
               '    FROM customer_order_tab co '||
               '    WHERE co.main_representative_id IS NOT NULL '||
               '    AND co.order_no NOT IN (SELECT bor.business_object_id '||
               '                            FROM bus_obj_representative_tab bor '||
               '                            WHERE bor.business_object_type = object_type_)); '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   --END IF;
END;
/

PROMPT Finished POST_Order_UpdateCustomerOrder.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateCustomerOrder.sql','Done');

