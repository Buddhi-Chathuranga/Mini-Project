-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseJournal
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200511  WaSalk  GESPRING20-4420, Modified Generate_Journal_Data___() to access REPORT_EARNED_VALUE_DB.
--  200217  DiHelk  GESPRING20-1803, Generate Warehouse Journal Data
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- gelr: warehouse_journal, begin
PROCEDURE Generate_Journal_Data___(
   journal_attr_ IN VARCHAR2 )
IS
   ptr_      NUMBER;
   name_     VARCHAR2(30);
   value_    VARCHAR2(2000);
   company_  WAREHOUSE_JOURNAL_TAB.COMPANY%TYPE;
  
   CURSOR get_contracts IS
      SELECT contract
        FROM site_public
       WHERE company = company_;
   
   CURSOR get_parts (current_contract_ VARCHAR2) IS
      SELECT DISTINCT part_no
        FROM inventory_transaction_hist_tab 
       WHERE contract = current_contract_
         AND direction IN ('+','-')
    ORDER BY part_no;
       
   CURSOR get_locations (current_contract_ VARCHAR2, current_part_ VARCHAR2) IS 
      SELECT DISTINCT location_no
        FROM inventory_transaction_hist_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND direction IN ('+','-')
    ORDER BY location_no;
         
   CURSOR get_configurations (current_contract_ VARCHAR2, current_part_ VARCHAR2, current_location_ VARCHAR2) IS
      SELECT DISTINCT configuration_id
        FROM inventory_transaction_hist_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND location_no = current_location_ 
         AND direction IN ('+','-');  
         
   CURSOR get_conditions (current_contract_ VARCHAR2, current_part_ VARCHAR2, current_location_ VARCHAR2, current_config_ VARCHAR2) IS
      SELECT DISTINCT condition_code
        FROM inventory_transaction_hist_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND location_no = current_location_ 
         AND configuration_id = current_config_ 
         AND direction IN ('+','-');
   
   -- Get periods until the last full period(sysdate's accounting period -1).
   CURSOR get_periods IS
      SELECT accounting_year, accounting_period, date_until, date_from
        FROM accounting_period_tab
       WHERE company = company_
         AND date_from < trunc(sysdate)
         AND year_end_period = 'ORDINARY'
    ORDER BY accounting_year ASC, accounting_period ASC; 
   
   CURSOR get_max_transaction_id IS
      SELECT MAX(transaction_id)
        FROM warehouse_journal_tab
       WHERE company = company_;
         
   CURSOR get_transactions (current_contract_ VARCHAR2, current_part_ VARCHAR2, current_location_ VARCHAR2, 
                            current_config_ VARCHAR2, current_condition_ VARCHAR2, current_date_until_ DATE, 
                            current_date_from_ DATE, max_transaction_id_ NUMBER) IS   
      SELECT *
        FROM inventory_transaction_hist_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND location_no = current_location_
         AND configuration_id = current_config_
         AND (condition_code = current_condition_ OR condition_code IS NULL)
         AND date_applied <= current_date_until_ 
         AND current_date_from_ <= date_applied
         AND direction IN ('+','-')
         AND transaction_id > NVL(max_transaction_id_, 0)
    ORDER BY contract, part_no, location_no, configuration_id, transaction_id ASC;   
   
   CURSOR get_prev_max_trans_id_per_part(current_contract_ VARCHAR2, current_part_ VARCHAR2, current_location_ VARCHAR2, 
                                         current_config_ VARCHAR2, current_condition_ VARCHAR2) IS
      SELECT MAX(transaction_id)
        FROM warehouse_journal_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND location_no = current_location_
         AND configuration_id = current_config_
         AND (condition_code = current_condition_ OR condition_code IS NULL);
   
   CURSOR get_prev_end_balance_per_part (current_contract_ VARCHAR2, current_part_ VARCHAR2, current_location_ VARCHAR2, 
                                         current_config_ VARCHAR2, current_condition_ VARCHAR2, max_trans_id_ NUMBER) IS
      SELECT end_balance
        FROM warehouse_journal_tab
       WHERE contract = current_contract_
         AND part_no = current_part_
         AND location_no = current_location_
         AND configuration_id = current_config_
         AND (condition_code = current_condition_ OR condition_code IS NULL)
         AND transaction_id = max_trans_id_;
   
   current_contract_    warehouse_journal_tab.CONTRACT%TYPE;
   current_date_until_  warehouse_journal_tab.DATE_CREATED%TYPE;
   current_date_from_   warehouse_journal_tab.DATE_CREATED%TYPE;
   current_acc_year_    warehouse_journal_tab.ACCOUNTING_YEAR%TYPE;
   current_acc_period_  warehouse_journal_tab.ACCOUNTING_PERIOD%TYPE;   
   current_part_        warehouse_journal_tab.PART_NO%TYPE;
   current_location_    warehouse_journal_tab.LOCATION_NO%TYPE;
   current_config_      warehouse_journal_tab.CONFIGURATION_ID%TYPE;
   current_condition_   warehouse_journal_tab.CONDITION_CODE%TYPE;
   newrec_              warehouse_journal_tab%ROWTYPE;
   attr_                VARCHAR2(32000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   indrec_              Indicator_Rec;
   start_balance_       NUMBER := 0;
   end_balance_         NUMBER := 0;
   quantity_            NUMBER := 0;
   max_transaction_id_  NUMBER := 0;
   max_trans_id_        NUMBER := 0;
   
BEGIN   
   WHILE (Client_SYS.Get_Next_From_Attr(journal_attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
      END IF;
   END LOOP; 
   OPEN get_max_transaction_id;
   FETCH get_max_transaction_id INTO max_transaction_id_; 
   CLOSE get_max_transaction_id;
      
   FOR site_rec_ IN get_contracts LOOP
      current_contract_ := site_rec_.contract;
      FOR part_rec_ IN get_parts(current_contract_) LOOP         
         current_part_ := part_rec_.part_no;
         FOR location_rec_ IN get_locations(current_contract_, current_part_) LOOP
            current_location_ := location_rec_.location_no; 
            FOR config_rec_ IN get_configurations(current_contract_, current_part_, current_location_ ) LOOP
               current_config_ := config_rec_.configuration_id;
               FOR condition_rec_ IN get_conditions(current_contract_, current_part_, current_location_, current_config_) LOOP
                  current_condition_ := condition_rec_.condition_code;  
                  IF max_transaction_id_ IS NULL THEN
                     start_balance_ := 0;
                     end_balance_ := 0; 
                  ELSE                     
                     OPEN get_prev_max_trans_id_per_part (current_contract_, current_part_, current_location_, current_config_, current_condition_);
                     FETCH get_prev_max_trans_id_per_part INTO max_trans_id_; 
                     CLOSE get_prev_max_trans_id_per_part;
                     IF max_trans_id_ IS NOT NULL THEN                        
                        OPEN get_prev_end_balance_per_part (current_contract_, current_part_, current_location_, current_config_, current_condition_, max_trans_id_);
                        FETCH get_prev_end_balance_per_part INTO end_balance_; 
                        CLOSE get_prev_end_balance_per_part;
                     ELSE
                        start_balance_ := 0;
                        end_balance_ := 0; 
                     END IF;
                  END IF;                  
                  FOR periods_rec_ IN get_periods LOOP
                     current_date_until_ := periods_rec_.date_until;
                     current_date_from_ := periods_rec_.date_from;
                     current_acc_year_ := periods_rec_.accounting_year;
                     current_acc_period_ := periods_rec_.accounting_period;  
                     FOR rec_ IN get_transactions(current_contract_, current_part_, current_location_, 
                                                  current_config_, current_condition_, current_date_until_, 
                                                  current_date_from_, max_transaction_id_) LOOP      
                        Client_SYS.Clear_Attr(attr_);
                        Client_SYS.Add_To_Attr('COMPANY', company_, attr_);            
                        Client_SYS.Add_To_Attr('ACCOUNTING_YEAR', current_acc_year_, attr_);            
                        Client_SYS.Add_To_Attr('ACCOUNTING_PERIOD', current_acc_period_, attr_);
                        Client_SYS.Add_To_Attr('TRANSACTION_ID', rec_.transaction_id, attr_);            
                        Client_SYS.Add_To_Attr('ACCOUNTING_ID', rec_.accounting_id, attr_);
                        Client_SYS.Add_To_Attr('TRANSACTION_CODE', rec_.transaction_code, attr_);
                        Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, attr_);
                        Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
                        Client_SYS.Add_To_Attr('CONFIGURATION_ID', rec_.configuration_id, attr_);
                        Client_SYS.Add_To_Attr('DIRECTION', rec_.direction, attr_); 
                        Client_SYS.Add_To_Attr('QUANTITY', rec_.quantity, attr_);
                        Client_SYS.Add_To_Attr('CATCH_DIRECTION', rec_.catch_direction, attr_);
                        Client_SYS.Add_To_Attr('CATCH_QUANTITY', rec_.catch_quantity, attr_);
                        Client_SYS.Add_To_Attr('LOCATION_NO', rec_.location_no, attr_);
                        Client_SYS.Add_To_Attr('LOCATION_GROUP', rec_.location_group, attr_);
                        Client_SYS.Add_To_Attr('LOT_BATCH_NO', rec_.lot_batch_no, attr_);
                        Client_SYS.Add_To_Attr('SERIAL_NO', rec_.serial_no, attr_);
                        Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
                        Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', rec_.waiv_dev_rej_no, attr_);
                        Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', rec_.eng_chg_level, attr_);
                        Client_SYS.Add_To_Attr('EXPIRATION_DATE', rec_.expiration_date, attr_); 
                        Client_SYS.Add_To_Attr('SOURCE_REF1', rec_.source_ref1, attr_);
                        Client_SYS.Add_To_Attr('SOURCE_REF2', rec_.source_ref2, attr_);
                        Client_SYS.Add_To_Attr('SOURCE_REF3', rec_.source_ref3, attr_);
                        Client_SYS.Add_To_Attr('SOURCE_REF4', rec_.source_ref4, attr_);
                        Client_SYS.Add_To_Attr('SOURCE_REF5', rec_.source_ref5, attr_);
                        --Client_SYS.Add_To_Attr('SOURCE_REF_TYPE', rec_.source_ref_type, attr_);
                        Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
                        Client_SYS.Add_To_Attr('DATE_TIME_CREATED', rec_.date_time_created, attr_);
                        Client_SYS.Add_To_Attr('SOURCE', rec_.source, attr_);
                        Client_SYS.Add_To_Attr('USERID', rec_.userid, attr_);
                        Client_SYS.Add_To_Attr('DATE_APPLIED', rec_.Date_applied, attr_);
                        Client_SYS.Add_To_Attr('PARTSTAT_FLAG', rec_.partstat_flag, attr_);
                        Client_SYS.Add_To_Attr('VALUESTAT_FLAG', rec_.valuestat_flag, attr_);
                        Client_SYS.Add_To_Attr('REJECT_CODE', rec_.reject_code, attr_);
                        --Client_SYS.Add_To_Attr('PART_OWNERSHIP', rec_.part_ownership, attr_);
                        Client_SYS.Add_To_Attr('OWNING_CUSTOMER_NO', rec_.owning_customer_no, attr_);
                        Client_SYS.Add_To_Attr('OWNING_VENDOR_NO', rec_.owning_vendor_no, attr_);
                        Client_SYS.Add_To_Attr('PREVIOUS_PART_OWNERSHIP', rec_.previous_part_ownership, attr_);
                        Client_SYS.Add_To_Attr('PREVIOUS_OWNING_VENDOR_NO', rec_.previous_owning_vendor_no, attr_);
                        Client_SYS.Add_To_Attr('PROJECT_ID', rec_.project_id, attr_);
                        Client_SYS.Add_To_Attr('ACTIVITY_SEQ', rec_.activity_seq, attr_);
                        Client_SYS.Add_To_Attr('REPORT_EARNED_VALUE_DB', rec_.report_earned_value, attr_);
                        Client_SYS.Add_To_Attr('TRANSACTION_REPORT_ID', rec_.transaction_report_id, attr_);
                        Client_SYS.Add_To_Attr('MODIFY_DATE_APPLIED_DATE', rec_.modify_date_applied_date, attr_);
                        Client_SYS.Add_To_Attr('MODIFY_DATE_APPLIED_USER', rec_.modify_date_applied_user, attr_);
                        Client_SYS.Add_To_Attr('DELIVERY_REASON_ID', rec_.delivery_reason_id, attr_);
                        Client_SYS.Add_To_Attr('ALT_DEL_NOTE_NO', rec_.alt_del_note_no, attr_);
                        Client_SYS.Add_To_Attr('DEL_NOTE_DATE', rec_.del_note_date, attr_);

                        -- calculate the start balance and end balance
                        IF (rec_.direction = '-') THEN
                           quantity_ := rec_.quantity * (-1);
                        ELSE
                           quantity_ := rec_.quantity;
                        END IF;
                        start_balance_ := end_balance_;
                        end_balance_ := start_balance_ + quantity_;
                        Client_SYS.Add_To_Attr('START_BALANCE', start_balance_, attr_);
                        Client_SYS.Add_To_Attr('END_BALANCE', end_balance_, attr_);

                        Unpack___(newrec_, indrec_, attr_);
                        Check_Insert___(newrec_, indrec_, attr_);            
                        Insert___(objid_, objversion_, newrec_, attr_);
                     END LOOP;                        
                 END LOOP;                     
               END LOOP;               
            END LOOP;            
         END LOOP;  
      END LOOP;      
   END LOOP;
   
END Generate_Journal_Data___;
-- gelr: warehouse_journal, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- gelr: warehouse_journal, begin
PROCEDURE Generate_Journal_Data (
   company_        IN VARCHAR2 )
IS
   journal_attr_     VARCHAR2(2000);
   description_      VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(journal_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, journal_attr_);
   IF (NOT Transaction_SYS.Is_Session_Deferred()) THEN
      Generate_Journal_Data___(journal_attr_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'UPDATE_JOURNAL_DATA: Update Warehouse Journal Data');
      Transaction_SYS.Deferred_Call('Warehouse_Journal_API.Generate_Journal_Data__', journal_attr_, description_);
   END IF;      
END Generate_Journal_Data;

PROCEDURE Validate_Params (
   message_     IN VARCHAR2 )
IS
   count_       NUMBER;
   name_arr_    Message_SYS.name_table;
   value_arr_   Message_SYS.line_table;
   company_     warehouse_journal_tab.company%TYPE;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY_') THEN
         company_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   
   -- User has access to company
   User_Finance_API.Exist(company_, Fnd_Session_API.Get_Fnd_User);
   
   -- Company has localization feature enabled
   Company_Localization_Info_API.Check_Parameter_Enabled(company_, 'WAREHOUSE_JOURNAL');
END Validate_Params;
-- gelr: warehouse_journal, end
