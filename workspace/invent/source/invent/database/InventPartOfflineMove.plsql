-----------------------------------------------------------------------------
--
--  Logical unit: InventPartOfflineMove
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180131  LEPESE  STRSC-16619, Added attribute handling_unit_id.
--  170427  BudKlk  Bug 135534, Modified the method Run_Pending_Move_Part___() to add a savepoint to rollback the move part operation when an exception caught.
--  160921  SBalLK  Bug 131225, Added Acknowledge__() method to enable Acknowledge functionality in "Inventory Part Offline Move Transactions" window
--  160921          by partially reversing bug 129710. Made method private since method used only in client window.
--  160920  MAWILK  Bug 129710, Added Get_Status_Db, Rerun_Error_Unplan_Invent_Move, Auto_Acknowledge_Invent_Move and Rerun_Move_With_New_Data.
--  151123  Chfose  LIM-5033, Removed pallet_list-parameter in call to Inventory_Part_In_Stock_API.Move_Part.
--  150512  KhVeSe  COB-409, Added verification.        
--  150422  KhVeSe  Created.        
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Offline_Move_Id___ RETURN NUMBER
IS
   internal_offline_move_id_  NUMBER;
BEGIN
   SELECT INTERNAL_OFFLINE_MOVE_ID.NEXTVAL INTO internal_offline_move_id_ FROM dual;
   RETURN internal_offline_move_id_;
END Get_Next_Offline_Move_Id___;


@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_        IN OUT invent_part_offline_move_tab%ROWTYPE,
   attr_          IN OUT VARCHAR2 )
IS
BEGIN

   newrec_.internal_offline_move_id := Get_Next_Offline_Move_Id___();
   super(objid_, objversion_, newrec_, attr_);
   
END Insert___;


PROCEDURE Set_Move_Exec_Date_Time___ (
   external_offline_move_id_ IN VARCHAR2 )
IS
   record_ INVENT_PART_OFFLINE_MOVE_TAB%ROWTYPE;
BEGIN
   record_                     := Lock_By_Keys___(external_offline_move_id_);
   record_.move_execution_date_time := Site_API.Get_Site_Date(record_.from_contract);
   record_.error_description   := NULL;
   Modify___(record_);
END Set_Move_Exec_Date_Time___;
   

PROCEDURE Modify_Error_Description___ (
   external_offline_move_id_ IN VARCHAR2,
   error_description_        IN VARCHAR2 )
IS
   record_ INVENT_PART_OFFLINE_MOVE_TAB%ROWTYPE;
BEGIN
   record_                   := Lock_By_Keys___(external_offline_move_id_);
   record_.error_description := error_description_;
   Modify___(record_);
END Modify_Error_Description___;


PROCEDURE Run_Pending_Move_Part___ ( 
   record_ IN invent_part_offline_move_tab%ROWTYPE )
IS
   local_catch_quantity_ NUMBER := record_.catch_quantity;
   sqlerrm_              VARCHAR2(2000);
   has_error_            BOOLEAN := FALSE;

   CURSOR get_uncompleted_records IS
      SELECT *
      FROM invent_part_offline_move_tab
      WHERE part_no          = record_.part_no
        AND configuration_id = record_.configuration_id
        AND lot_batch_no     = record_.lot_batch_no
        AND serial_no        = record_.serial_no
        AND eng_chg_level    = record_.eng_chg_level
        AND waiv_dev_rej_no  = record_.waiv_dev_rej_no
        AND activity_seq     = record_.activity_seq
        AND handling_unit_id = record_.handling_unit_id
        AND from_contract    = record_.to_contract
        AND from_location_no = record_.to_location_no
        AND MOVE_Execution_Date_Time IS NULL
      FOR UPDATE;

   TYPE Uncompleted_Records_Tab IS TABLE OF get_uncompleted_records%ROWTYPE
      INDEX BY PLS_INTEGER;

   uncompleted_records_tab_ Uncompleted_Records_Tab;     
BEGIN
   IF (record_.move_execution_date_time IS NULL) THEN
      BEGIN
         @ApproveTransactionStatement(2017-04-27,BudKLK)
         SAVEPOINT before_move_part;
         Inventory_Part_In_Stock_API.Move_Part(catch_quantity_    =>  local_catch_quantity_,
                                               contract_          =>  record_.from_contract,
                                               part_no_           =>  record_.part_no,
                                               configuration_id_  =>  record_.configuration_id,
                                               location_no_       =>  record_.from_location_no,
                                               lot_batch_no_      =>  record_.lot_batch_no,
                                               serial_no_         =>  record_.serial_no,
                                               eng_chg_level_     =>  record_.eng_chg_level,
                                               waiv_dev_rej_no_   =>  record_.waiv_dev_rej_no,
                                               activity_seq_      =>  record_.activity_seq,
                                               handling_unit_id_  =>  record_.handling_unit_id,
                                               expiration_date_   =>  NULL,             
                                               to_contract_       =>  record_.to_contract,
                                               to_location_no_    =>  record_.to_location_no,
                                               to_destination_    =>  Inventory_Part_Destination_API.Decode('N'),
                                               quantity_          =>  record_.quantity,
                                               quantity_reserved_ =>  NULL,
                                               move_comment_      =>  NULL,
                                               order_no_          =>  record_.internal_offline_move_id,
                                               order_type_        =>  Order_Type_API.Decode(Order_Type_API.DB_INVENTORY_PART_OFFLINE_MOVE));
         Set_Move_Exec_Date_Time___(record_.external_offline_move_id);
      EXCEPTION
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2017-04-27,BudKLK)
            ROLLBACK TO before_move_part;
            sqlerrm_ := SUBSTR(sqlerrm,Instr(sqlerrm,':', 1, 2)+2,2000);
            Modify_Error_Description___(record_.external_offline_move_id, sqlerrm_);
            has_error_ := TRUE;
         END;                
      
       IF (NOT has_error_) THEN
         OPEN get_uncompleted_records;
         FETCH get_uncompleted_records BULK COLLECT INTO uncompleted_records_tab_;
         CLOSE get_uncompleted_records;

         IF (uncompleted_records_tab_.COUNT > 0) THEN
            FOR i IN uncompleted_records_tab_.FIRST..uncompleted_records_tab_.LAST LOOP
               Run_Pending_Move_Part___(uncompleted_records_tab_(i));
            END LOOP;
         END IF;
      END IF;
   END IF;
END Run_Pending_Move_Part___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Acknowledge__(
   external_offline_move_id_ IN  VARCHAR2,
   acknowledge_reason_id_    IN  VARCHAR2,
   acknowledge_note_text_    IN  VARCHAR2 )
IS
   rec_ invent_part_offline_move_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(external_offline_move_id_);
   
   rec_.acknowledge_reason_id := acknowledge_reason_id_;
   rec_.acknowledge_note_text := acknowledge_note_text_;
   rec_.second_sync_user_id   := Fnd_Session_API.Get_Fnd_User;
   rec_.error_description     := NULL;
   Modify___(rec_);
END Acknowledge__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Run_Pending_Move_Part (
   external_offline_move_id_ IN VARCHAR2 )
IS
   record_ invent_part_offline_move_tab%ROWTYPE;
BEGIN
   record_ := Get_Object_By_Keys___(external_offline_move_id_);
   Run_Pending_Move_Part___(record_);
END Run_Pending_Move_Part;

   
PROCEDURE Move_Part (
   external_offline_move_id_ IN VARCHAR2,
   from_contract_            IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   from_location_no_         IN VARCHAR2,
   to_location_no_           IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   quantity_                 IN NUMBER,
   catch_quantity_           IN NUMBER,
   handling_unit_id_         IN NUMBER DEFAULT 0 )
IS
   newrec_                   invent_part_offline_move_tab%ROWTYPE;
   record_exists_            BOOLEAN;    
BEGIN
   record_exists_ := Invent_Part_Offline_Move_API.Exists(external_offline_move_id_);
   IF (record_exists_) THEN
      newrec_ := Lock_By_Keys___(external_offline_move_id_);
      IF (newrec_.second_sync_user_id IS NULL) THEN
         newrec_.second_sync_user_id  := Fnd_Session_API.Get_Fnd_User; 
         newrec_.second_sync_date_time := Site_API.Get_Site_Date(from_contract_);
      END IF;
   ELSE
      newrec_.first_sync_user_id   := Fnd_Session_API.Get_Fnd_User;
      newrec_.first_sync_date_time := Site_API.Get_Site_Date(from_contract_);
   END IF;
   
   newrec_.external_offline_move_id := external_offline_move_id_;
   newrec_.from_contract            := from_contract_;
   newrec_.to_contract              := to_contract_;
   newrec_.from_location_no         := from_location_no_;
   newrec_.to_location_no           := to_location_no_;
   newrec_.part_no                  := part_no_;
   newrec_.configuration_id         := configuration_id_;
   newrec_.lot_batch_no             := lot_batch_no_;
   newrec_.serial_no                := serial_no_;
   newrec_.eng_chg_level            := eng_chg_level_;
   newrec_.waiv_dev_rej_no          := waiv_dev_rej_no_;
   newrec_.activity_seq             := activity_seq_;
   newrec_.handling_unit_id         := handling_unit_id_;
   newrec_.quantity                 := quantity_;
   newrec_.catch_quantity           := catch_quantity_;
   
   IF (record_exists_) THEN
      Modify___(newrec_);
   ELSE
      New___(newrec_);
   END IF;
   
   IF newrec_.move_execution_date_time IS NULL THEN
      Run_Pending_Move_Part___(newrec_);
   END IF;
END Move_Part;


@UncheckedAccess
FUNCTION Get_Status (
   external_offline_move_id_  IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Part_Move_Status_API.Decode(Get_Status_Db(external_offline_move_id_));
END Get_Status;
   

@UncheckedAccess
FUNCTION Get_Status_Db (
   external_offline_move_id_  IN  VARCHAR2 ) RETURN VARCHAR2
IS  
   status_db_ VARCHAR2(200);
   record_    invent_part_offline_move_tab%ROWTYPE;
BEGIN
   record_ := Get_Object_By_Keys___(external_offline_move_id_);

   IF ((record_.move_execution_date_time IS NOT NULL) AND 
       (record_.acknowledge_reason_id IS NOT NULL OR record_.second_sync_user_id IS NOT NULL)) THEN
      status_db_ := Part_Move_Status_API.DB_COMPLETE;
   ELSIF (record_.error_description IS NOT NULL AND
          record_.move_execution_date_time IS NULL) THEN
      status_db_ := Part_Move_Status_API.DB_ERROR;
   ELSE
      status_db_ := Part_Move_Status_API.DB_UNACKNOWLEDGED;
   END IF ;
   RETURN status_db_;  
   
END Get_Status_Db;


PROCEDURE Rerun_Error_Unplan_Invent_Move
IS    
   CURSOR error_move IS
   SELECT external_offline_move_id
   FROM  invent_part_offline_move_tab
   WHERE Invent_Part_Offline_Move_API.Get_Status_Db(external_offline_move_id) = 'ERROR';
BEGIN
   FOR rec_ IN error_move LOOP
      Run_Pending_Move_Part (rec_.external_offline_move_id);      
   END LOOP;
END Rerun_Error_Unplan_Invent_Move; 

PROCEDURE Auto_Acknowledge_Invent_Move (
   number_of_days_        IN NUMBER,
   acknowledge_reason_id_ IN VARCHAR2 )
IS    
   CURSOR unack_move IS
   SELECT *
   FROM  invent_part_offline_move_tab
   WHERE Invent_Part_Offline_Move_API.Get_Status_Db(external_offline_move_id) = 'UNACKNOWLEDGED'
   AND   move_execution_date_time + number_of_days_ < Site_API.Get_Site_Date(from_contract);
BEGIN
   IF (number_of_days_ IS NOT NULL AND number_of_days_ > 0 AND number_of_days_ < 36500 AND Part_Move_Acknowldg_Reason_API.Exists(acknowledge_reason_id_)) THEN
      FOR rec_ IN unack_move LOOP
         --update reason id and second user. reason text is not to be given for auto ack.
         rec_.acknowledge_reason_id := acknowledge_reason_id_;
         rec_.second_sync_user_id   := Fnd_Session_API.Get_Fnd_User;
         rec_.error_description     := NULL;
         Modify___(rec_);
      END LOOP;
   END IF;
END Auto_Acknowledge_Invent_Move;


PROCEDURE Rerun_Move_With_New_Data (
   external_offline_move_id_  IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   from_location_no_          IN VARCHAR2,
   to_location_no_            IN VARCHAR2 )
IS
   old_rec_   invent_part_offline_move_tab%ROWTYPE;
   temp_rec_  invent_part_offline_move_tab%ROWTYPE;
   status_db_ VARCHAR2(200);
   error_des_ invent_part_offline_move_tab.error_description%TYPE;
BEGIN
   -- remove old rec 
   old_rec_ := Lock_By_Keys___(external_offline_move_id_);
   temp_rec_ := old_rec_; 
   Delete___(NULL, old_rec_);   
   -- move part with new data
   move_part( external_offline_move_id_ ,
              old_rec_.from_contract,
              old_rec_.to_contract,
              from_location_no_,
              to_location_no_,
              old_rec_.part_no,
              old_rec_.configuration_id,
              lot_batch_no_,
              serial_no_,
              old_rec_.eng_chg_level,
              old_rec_.waiv_dev_rej_no,
              old_rec_.activity_seq,
              old_rec_.handling_unit_id,
              old_rec_.quantity,
              old_rec_.catch_quantity);
   -- if error remove and restore
   status_db_ := Get_Status_Db(external_offline_move_id_);
   IF (status_db_ = Part_Move_Status_API.DB_ERROR) THEN
      old_rec_ := Lock_By_Keys___(external_offline_move_id_);
      Delete___(NULL, old_rec_);
      temp_rec_.internal_offline_move_id := NULL;
      error_des_ := temp_rec_.error_description;
      temp_rec_.error_description := NULL;
      New___(temp_rec_);
      temp_rec_.error_description := error_des_;
      Modify___(temp_rec_);
   END IF;   
END Rerun_Move_With_New_Data;