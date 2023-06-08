-----------------------------------------------------------------------------
--
--  Logical unit: CleanupInventory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign   History
--  ------  ------ ---------------------------------------------------------
--  191022  SBalLK  Bug 150622 (SCZ-7491), Modified Cleanup_Routine__() by replacing Transaction_SYS.Set_Progress_Info() with Transaction_SYS.Log_Progress_Info()
--  191022          as it may lead to a deadlock situation when the task is run in a Schedule Chain.
--  190918  SBalLK  Bug 150234 (SCZ-6522), Modified Cleanup_Routine__() method to fetch latest transaction id from InventoryPartInStock LU.
--  170106  NiDalk LIM-10102, Modified Cleanup_Routine__ to correct an issue in setting site variable.
--  161207  NiDalk LIM-9969, Modified Cleanup_Routine__ to consider parameter HANDLING_UNITS_ONLY.
--  160927  LaThlk Bug 131212, Modified Cleanup_Routine() in order to create one backgraound job per site. Also modified Cleanup_Routine__()
--  160927         to lock the stock record in a later stage and release the lock on the records that are not full filling the conditions.
--  160927         Also modified Clear_Inventory_Part_Loc___() to accept keys of InventoryPartInStock LU as parameters instead of rowid.
--  151103  UdGnlk LIM-3746, Removed method  Remove_Empty_Pallet_Records___() since INVENTORY_PART_LOC_PALLET_TAB will be obsolete.  
--  151029  JeLise LIM-3941, Removed call to Inventory_Location_API.Is_Pallet_Location.
--  150522  LEPESE LIM-2001, added handling_unit_id in call to Remove_Empty_Pallet_Records___.
--  150421  Chfose LIM-1245, Fixed calls to Counting_Report_Line_API & Inventory_Transaction_Hist_API by including handling_unit_id.
--  130828  ErFelk Bug 110921, Added procedure Remove_Empty_Pallet_Records___() to remove on hand quantity 0 pallets and modified 
--  130828         Cleanup_Routine__() by adding the above method and a condition to check Inventory_Location before calling it.  
--  110916  Darklk Bug 98988, Modified Cleanup_Routine to avoid creating another background job when it's invoked from a schedule job.
--  101020  Hasplk Bug 93519, Modified method Cleanup_Routine__ to check date from InventoryTransactionHistory.
--  091015  PraWlk Bug 59406, Removed the commit from Clear_Inventory_Part_Loc___.Modified cursor  
--  091015         select_records in procedure Cleanup_Routine__ and added for update. 
--  080422  NiBalk Bug 72596, Added new public method Cleanup_Routine.
--  050516   JOHESE Added parameter PROJECT_ID to enable cleanup on a project level
--  050324  IsWilk Added PROCEDURE Validate_Params to handle the validation 
--  050324         of the parameters in the Schedule Clenup Inventory. 
--  041104  DiVelk Modified Cleanup_Routine__ to get the client values of the check boxes.
--  040908  DiVelk Removed method Batch_Cleanup_Routine__.
--  040719  DiVelk Modified [Cleanup_Routine__].
--  040414  JaBalk Removed Schedule_Cleanup_Routine__ method and update Cleanup_Routine__ by adding NVL to location_type column.
--  010612  THJALK Bug Fix 22452, Modified the cursor SELECT_RECORDS with a NVL in procedure Cleanup_Routine__.
--  000925  JOHESE Added undefines.
--  000823  PERK   Added configuration_id in calls to functions in Counting_Report_Line_API
--  000815  ANLASE Moved check for contract, location_type and number_of_days from Cleanup_Routine__
--                 to Batch_Cleanup_Routine__ and Schedule_Cleanup_Routine__ .
--  000814  ANLASE Replaced inventory_part_location with new inventory_part_in_stock_tab ipis.
--  000810  ANLASE Added handling for configuration_id. Replaced cursors in Cleanup_Routine__
--                 and Batch_Cleanup_Routine with cursor select_records.
--  000619  SHVE   Added validations for unconfirmed lines on a count report.
--  000503  ANLASE Added Error_SYS for negative values in Batch_Cleanup_Routine__.
--  000217  JOHW   Changed to new User_Allowed_Site functionality.
--  991115  FRDI   Bug fix 12633, Added errors for negative values in Schedule_Cleanup_Routine__.
--  990919  ROOD   Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990412  SHVE   Upgraded to performance optimized template.
--  990325  SHVE   CID 11837- Only delete records with serial numbers.
--  990215  RaKu   Changed parameter LAST_ACTIVITY_DATE to NUMBER_OF_DAYS in
--                 Cleanup_Routine__.
--  990208  RaKu   Replaced Gen_Def_Key_Value_API.Get_Client_Value(1) with '*'.
--  990208  RaKu   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Clear_Inventory_Part_Loc___
--   Removes specified Inventory_part_In_Stock record.
PROCEDURE Clear_Inventory_Part_Loc___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
BEGIN
   DELETE
   FROM  INVENTORY_PART_IN_STOCK_TAB
   WHERE contract         = contract_
   AND   part_no          = part_no_
   AND   configuration_id = configuration_id_
   AND   location_no      = location_no_
   AND   lot_batch_no     = lot_batch_no_
   AND   serial_no        = serial_no_
   AND   waiv_dev_rej_no  = waiv_dev_rej_no_
   AND   eng_chg_level    = eng_chg_level_                                                                                         
   AND   activity_seq     = activity_seq_
   AND   handling_unit_id = handling_unit_id_;
END Clear_Inventory_Part_Loc___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Cleanup_Routine__
--   Removes records (using "raw" delete) from tables using options
--   specified in the message-variable.
PROCEDURE Cleanup_Routine__ (
   message_ IN VARCHAR2 )
IS
   count_     NUMBER;
   name_arr_  Message_SYS.name_table;
   value_arr_ Message_SYS.line_table;

   contract_              VARCHAR2(5);
   project_id_            VARCHAR2(10);
   last_activity_date_    DATE;
   location_type_         VARCHAR2(20);
   serials_only_          VARCHAR2(20) := 'FALSE';
   configurations_only_   VARCHAR2(20) := 'FALSE';
   number_of_days_        NUMBER;
   counter_               NUMBER := 0;
   info_                  VARCHAR2(2000);
   unconfirmed_partloc_   VARCHAR2(10);
   latest_transaction_id_     NUMBER;
   latest_transaction_date_   DATE;
   inv_part_in_stock_pub_rec_ Inventory_Part_In_Stock_API.Public_Rec;
   record_removed_            BOOLEAN;
   handling_units_only_       VARCHAR2(10);
   
-- New cursor handles both serial_no and configuration_id.
   CURSOR select_records IS
      SELECT contract,      part_no,         location_no,  lot_batch_no,     serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, configuration_id
      FROM   INVENTORY_PART_IN_STOCK_TAB
      WHERE  freeze_flag      = 'N'
      AND    qty_in_transit   = 0
      AND    qty_onhand       = 0
      AND    qty_reserved     = 0
      AND    contract         = contract_
      AND    (project_id    LIKE project_id_ OR project_id_ = '%')
      AND    (location_type LIKE nvl(location_type_,'%'))
      AND    (serial_no != '*'        OR serials_only_='FALSE')
      AND    (configuration_id != '*' OR configurations_only_='FALSE')
      AND    (handling_unit_id != 0   OR handling_units_only_ = 'FALSE');

BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SITE') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PROJECT_ID') THEN
         project_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'NUMBER_OF_DAYS') THEN
         number_of_days_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'LOCATION_TYPE') THEN
         location_type_ := NVL(value_arr_(n_),'%');
      ELSIF (name_arr_(n_) = 'SERIALS_ONLY') THEN
         serials_only_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATIONS_ONLY') THEN
         configurations_only_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNITS_ONLY') THEN
         handling_units_only_ := value_arr_(n_);   
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;

   last_activity_date_ := TRUNC(SYSDATE - number_of_days_);

    -- Delete records.
   FOR rec_ IN select_records LOOP
      record_removed_ := FALSE;      
      @ApproveTransactionStatement(2016-09-20,Asawlk)
      SAVEPOINT before_processing_stock_rec; 
      inv_part_in_stock_pub_rec_ := Inventory_Part_In_Stock_API.Lock_By_Keys(rec_.contract, 
                                                                             rec_.part_no, 
                                                                             rec_.configuration_id,
                                                                             rec_.location_no, 
                                                                             rec_.lot_batch_no,
                                                                             rec_.serial_no, 
                                                                             rec_.eng_chg_level, 
                                                                             rec_.waiv_dev_rej_no, 
                                                                             rec_.activity_seq,
                                                                             rec_.handling_unit_id);
      -- Re-check the conditions after locking the record.
      IF ((inv_part_in_stock_pub_rec_.freeze_flag     = 'N')   AND 
          (inv_part_in_stock_pub_rec_.qty_in_transit  = 0)     AND 
          (inv_part_in_stock_pub_rec_.qty_onhand      = 0)     AND 
          (inv_part_in_stock_pub_rec_.qty_reserved    = 0))    THEN
         IF (inv_part_in_stock_pub_rec_.latest_transaction_id IS NOT NULL) THEN
            latest_transaction_id_ := inv_part_in_stock_pub_rec_.latest_transaction_id;
         ELSE   
            latest_transaction_id_ := Inventory_Transaction_Hist_API.Get_Latest_Transaction_Id(rec_.contract,
                                                                                               rec_.part_no,
                                                                                               rec_.configuration_id,
                                                                                               rec_.location_no,
                                                                                               rec_.lot_batch_no,
                                                                                               rec_.serial_no,
                                                                                               rec_.waiv_dev_rej_no,
                                                                                               rec_.eng_chg_level,                                                                                         
                                                                                               rec_.activity_seq,
                                                                                               rec_.handling_unit_id);
            END IF;
         IF latest_transaction_id_ IS NOT NULL THEN
            latest_transaction_date_ := TRUNC(Inventory_Transaction_Hist_API.Get_Date_Time_Created(latest_transaction_id_));
         END IF;      
         IF (NVL(latest_transaction_date_, Database_SYS.first_calendar_date_) < last_activity_date_) THEN
            unconfirmed_partloc_:= Counting_Report_Line_API.Check_Unconfirmed_Part_Loc(rec_.contract,
                                                                                       rec_.part_no,
                                                                                       rec_.configuration_id,
                                                                                       rec_.location_no,
                                                                                       rec_.lot_batch_no,
                                                                                       rec_.serial_no,
                                                                                       rec_.eng_chg_level,
                                                                                       rec_.waiv_dev_rej_no,
                                                                                       rec_.activity_seq,
                                                                                       rec_.handling_unit_id);
            IF (unconfirmed_partloc_ = 'FALSE') THEN
               Clear_Inventory_Part_Loc___(rec_.contract,
                                           rec_.part_no,
                                           rec_.configuration_id,
                                           rec_.location_no,
                                           rec_.lot_batch_no, 
                                           rec_.serial_no,
                                           rec_.waiv_dev_rej_no,
                                           rec_.eng_chg_level,                                                                                         
                                           rec_.activity_seq,
                                           rec_.handling_unit_id);
               record_removed_ := TRUE;
               counter_ := counter_ + 1;
            END IF;   
         END IF;            
      END IF;
      
      IF record_removed_ THEN
         @ApproveTransactionStatement(2016-09-20,Asawlk)
         COMMIT;
      ELSE
         @ApproveTransactionStatement(2016-09-20,Asawlk)         
         ROLLBACK TO before_processing_stock_rec;
      END IF;
   END LOOP;

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (counter_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NUMBER_OF_UPDATES: :P1 Inventory Part Location records were removed.', NULL, TO_CHAR(counter_));
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_REC_REMOVED: No records were removed.');
      END IF;
      Transaction_SYS.Log_Progress_Info(info_);
   END IF;
END Cleanup_Routine__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup_Routine (
   message_ IN VARCHAR2 )
IS
   batch_desc_    VARCHAR2(100);
   message_local_ VARCHAR2(32000);
   contract_      VARCHAR2(5);
   
   CURSOR get_contracts (in_contract_ IN VARCHAR2) IS
      SELECT site    contract
      FROM   user_allowed_site_pub
      WHERE  site LIKE in_contract_;
      
   TYPE Contract_Tab_Type IS TABLE OF get_contracts%ROWTYPE INDEX BY BINARY_INTEGER;
   contract_tab_          Contract_Tab_Type;
BEGIN
   message_local_ := message_;
   Message_SYS.Get_Attribute(message_local_, 'SITE', contract_);
   contract_ := NVL(contract_, '%');
   User_Allowed_Site_API.Exist_With_Wildcard(contract_);
   
   OPEN get_contracts(contract_);
   FETCH get_contracts BULK COLLECT INTO contract_tab_;
   CLOSE get_contracts;
   
   -- Need not to check for the COUNT > 0 since the collection should have atleast more than zero record. Else there will be an error raised by
   -- User_Allowed_Site_API.Exist_With_Wildcard.
   FOR i IN contract_tab_.FIRST..contract_tab_.LAST LOOP
      Message_SYS.Set_Attribute(message_local_, 'SITE', contract_tab_(i).contract);
      
      -- We will execute the cleanup job online if it is only for one site.
      IF (contract_tab_.COUNT = 1) AND (Transaction_SYS.Is_Session_Deferred()) THEN
         Cleanup_Routine__(message_local_);
      ELSE
         batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCCR: Cleanup of Inventory for site :P1.', NULL, contract_tab_(i).contract);
         Transaction_SYS.Deferred_Call('Cleanup_Inventory_API.Cleanup_Routine__', message_local_, batch_desc_);
      END IF;
   END LOOP;
END Cleanup_Routine;


-- Validate_Params
--   This procedure is calling when running the Cleanup Inventory Schedule.This
--   is also called by the Online process of the Cleanup Inventory.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   contract_                VARCHAR2(5);

BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SITE') THEN
         contract_ := NVL(value_arr_(n_), '%');
      END IF;
   END LOOP;

   IF ((contract_ IS NOT NULL) AND (contract_ != '%')) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
END Validate_Params;



