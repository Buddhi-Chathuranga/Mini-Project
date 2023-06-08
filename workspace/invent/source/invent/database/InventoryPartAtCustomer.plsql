-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartAtCustomer
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210125  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  190802  NiDalk   Bug 149058(SCZ-5668), Modified Decrease_Our_Qty_At_Customer to support consignment stock created before APP10 correctly by replacing '*' in eng_chg_level_ with '1'
--  190802           and replacing NULL handling_unit_id_ with '0'.
--  171208  KHVESE   STRSC-14829, Added parameter validate_hu_struct_position_ to interface of methods Insert___, Update___, Check_Handling_Unit___, Increase_Our_Qty_At_Customer
--  171208           and updated call to these methods accordingly.
--  171004  KHVESE   STRSC-9352, Modified methods Increase_Our_Qty_At_Customer and Decrease_Our_Qty_At_Customer to pass the correct value to expiration_date 
--  171004           and inv stock keys when local location group is CONSIGNMENT. Also added an overload of method Get_Our_Total_Qty_At_Customer. 
--  170522  ChBnlk   Bug 135688, Added new method Get_Handling_Unit_Row_Count() to check the number of rows that are using a particular handling_unit_id. 
--  150903  MAHPLK   AFT-3340, Modified Decrease_Our_Qty_At_Customer () for not to create inventory transactions for UNCODELVOU and UNDELCONOU transactions codes.
--  150812  MAHPLK   KES-1081, Added new parameter source_ref5_ to Increase_Our_Qty_At_Customer() and Decrease_Our_Qty_At_Customer().
--  150812           Added new defalut null parameter alt_source_ref5_ to Decrease_Our_Qty_At_Customer(). 
--  150812           Renamed order_no_, release_no_, sequence_no_, line_item_no_ to source_ref1_, source_ref2_, source_ref3_, source_ref4_ 
--  150812           in Increase_Our_Qty_At_Customer() and Decrease_Our_Qty_At_Customer().
--  150520  LEPESE  LIM-2885, removed LIM01 tag for final implementation of Handling Units.
--  150515  IsSalk   KES-409, Passed new parameter to Inventory_Transaction_Hist_API.Set_Alt_Source_Ref().
--  150512  IsSalk   KES-422, Passed new parameter source_ref5_ to Inventory_Transaction_Hist_API.Create_And_Account().
--  150415  LEPESE  LIM-88, added method Handling_Unit_Exist.
--  150414  JeLise   Added new key column handling_unit_id.
--  130924  UdGnlk   EBALL-192, Modified Unpack_Check_Insert___() include conditional compilation.
--  130905  UdGnlk   EBALL-145, Modified Decrease_Our_Qty_At_Customer() for code review comments receive part from stock at customer. 
--  130624  UdGnlk   EBALL-94, Added transaction_id parameter to Decrease_Our_Qty_At_Customer().
--  130620  UdGnlk   EBALL-128, Added alter reference parameters to the Decrease_Our_Qty_At_Customer() and its logic to update alter references. 
--  130610  AwWelk   EBALL-98, Added scrap information parameters to the Decrease_Our_Qty_At_Customer() and modified the logic.
--  130607  AwWelk   EBALL-108, Modified INVENTORY_PART_AT_CUSTOMER_OVW view by adding /NOCHECK option for REF column comments.
--  130607  Asawlk   EBALL-90, Modified Increase_Our_Qty_At_Customer and Decrease_Our_Qty_At_Customer to pass the correct value to expiration_date
--  130607           when Inventory_Transaction_Hist_API.Create_And_Account is called. 
--  130605  AwWelk   EBALL-108, Created INVENTORY_PART_AT_CUSTOMER_OVW view.
--  130510  UdGnlk   EBALL-69, Modified Increase_Our_Qty_At_Customer() for part exchange include the customer order section.
--  130530  Asawlk   EBALL-37, Added new method Get_Company_Owned_Inventory().
--  130528  Asawlk   EBALL-37, Added new method Check_Quantity_Exist().
--  130528  ChJalk   EBALL-88, Modified Key_Validation_Required___ to handle activity_seq correctly.
--  130516  Asawlk   EBALL-37, Added new methods Modify_Lot_Expiration_Date() and Quantity_Exists().
--  130515  Asawlk   EBALL-37, Removed views INVENTORY_PART_AT_CUST_LOCAL_1, INVENTORY_PART_VALUE_SNAPSHOT and INVEPART_VALUE_DETAIL_SNAPSHOT.
--  130510  UdGnlk   EBALL-70, Modified Key_Validation_Required___() to support key validations for part exchange functionality.
--  130502  Asawlk   EBALL-37, Added method Key_Validation_Required___().
--  130426  Asawlk   EBALL-37, Modified Increase_Our_Qty_At_Customer() and Decrease_Our_Qty_At_Customer() to gain better encapsulation. 
--  130401  Asawlk   EBALL-37, Added the new set of keys and modified the LU and the methods accordingly.
--  130325  Asawlk   EBALL-37, Modified Get_Our_Total_Qty_At_Customer() in order to make the call to Customer_Consignment_Stock_API dynamic.
--  130321  Asawlk   EBALL-37, Moved LU InventoryPartAtCustomer from ORDER to INVENT module. 
--  110228  ChJalk   Added 'User Allowed Site' condition to INVENTORY_PART_VALUE_SNAPSHOT and INVEPART_VALUE_DETAIL_SNAPSHOT.
--  090902   SuSalk    Bug 85609, Changed description length to 200 in INVEPART_VALUE_DETAIL_SNAPSHOT
--  090902          and INVENTORY_PART_VALUE_SNAPSHOT views.
--  060317  LEPESE   Removed view INVENTORY_PART_AT_CUST_LOCAL_1 and joined the table directly
--  060317           to INVENTORY_PART_VALUE_SNAPSHOT and INVEPART_VALUE_DETAIL_SNAPSHOT.
--  060111  JoEd     Changed type_code and type_code_db in the two ...Snapshot views.
--  051229  JoEd     Added comments to ...LOCAL_1 and ...LOCAL_2 views.
--  051215  JoEd     Added a Customer Order version of the Inventory_Part_Value_Snapshot
--                   and Invepart_Value_Detail_Snapshot views.
--                   The original versions are defined in Invent - InventoryValueCalc.
--  050629  MaEelk   Added General_SYS.Init method to Get_Our_Total_Qty_At_Customer.
--  050406  JOHESE   Added procedures Increase_Our_Qty_At_Customer and Decrease_Our_Qty_At_Customer
--  050322  JOHESE   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Key_Validation_Required___ (
   key_name_ IN VARCHAR2,
   rec_      IN inventory_part_at_customer_tab%ROWTYPE ) RETURN BOOLEAN
IS
   key_validation_required_ BOOLEAN := TRUE;
BEGIN
   IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
      IF key_name_ IN ('LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'CUSTOMER_NO', 'ADDR_NO') THEN
         key_validation_required_ := FALSE;
      END IF;
   ELSIF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
      IF key_name_ IN ('LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ') THEN
         key_validation_required_ := FALSE;
      END IF;
   ELSIF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
      IF ((key_name_ = 'LOT_BATCH_NO') AND (rec_.lot_batch_no = '*')) THEN
         key_validation_required_ := FALSE;
      ELSIF ((key_name_ = 'SERIAL_NO') AND (rec_.serial_no = '*')) THEN
         key_validation_required_ := FALSE;
      ELSIF ((key_name_ = 'ACTIVITY_SEQ') AND (rec_.activity_seq = 0)) THEN
         key_validation_required_ := FALSE;     
      END IF;
   END IF;
  RETURN (key_validation_required_);
END Key_Validation_Required___;


@Override
PROCEDURE Insert___ (
   objid_                           OUT VARCHAR2,
   objversion_                      OUT VARCHAR2,
   newrec_                       IN OUT inventory_part_at_customer_tab%ROWTYPE,
   attr_                         IN OUT VARCHAR2,
   validate_hu_struct_position_  IN     BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Check_Handling_Unit___(handling_unit_id_              => newrec_.handling_unit_id,
                          old_quantity_                  => 0, 
                          new_quantity_                  => newrec_.quantity,
                          validate_hu_struct_position_   => validate_hu_struct_position_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-- Update___
--   Update a record in database with new data.
@Override
PROCEDURE Update___ (
   objid_                        IN     VARCHAR2,
   oldrec_                       IN     inventory_part_at_customer_tab%ROWTYPE,
   newrec_                       IN OUT inventory_part_at_customer_tab%ROWTYPE,
   attr_                         IN OUT VARCHAR2,
   objversion_                   IN OUT VARCHAR2,
   by_keys_                      IN     BOOLEAN DEFAULT FALSE,
   validate_hu_struct_position_  IN     BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   Check_Handling_Unit___(handling_unit_id_              => newrec_.handling_unit_id,
                          old_quantity_                  => oldrec_.quantity, 
                          new_quantity_                  => newrec_.quantity,
                          validate_hu_struct_position_   => validate_hu_struct_position_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_            IN VARCHAR2,
   remrec_           IN inventory_part_at_customer_tab%ROWTYPE,
   remove_unit_cost_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, remrec_);
   IF (remove_unit_cost_) THEN
      Inventory_Part_Unit_Cost_API.Remove(remrec_.contract,
                                          remrec_.part_no,
                                          remrec_.configuration_id,
                                          remrec_.lot_batch_no,
                                          remrec_.serial_no);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.expiration_date IS NULL) THEN
      newrec_.expiration_date := Database_SYS.last_calendar_date_;
   END IF;   
   
   super(newrec_, indrec_, attr_);

   IF (newrec_.quantity <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOTZERO: Qty at Customer must be greater then zero.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_part_at_customer_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.quantity <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOTZERO: Qty at Customer must be greater then zero.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

   
PROCEDURE Check_Configuration_Id_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('CONFIGURATION_ID', newrec_)) THEN
      Inventory_Part_Config_API.Exist(newrec_.contract, newrec_.part_no, newrec_.configuration_id);
   END IF;
END Check_Configuration_Id_Ref___;

PROCEDURE Check_Lot_Batch_No_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('LOT_BATCH_NO', newrec_)) THEN
      Lot_Batch_Master_API.Exist(newrec_.part_no, newrec_.lot_batch_no);
   END IF;
END Check_Lot_Batch_No_Ref___;

PROCEDURE Check_Serial_No_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('SERIAL_NO', newrec_)) THEN
      Part_Serial_Catalog_API.Exist(newrec_.part_no, newrec_.serial_no);
   END IF;
END Check_Serial_No_Ref___;

PROCEDURE Check_Eng_Chg_Level_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('ENG_CHG_LEVEL', newrec_)) THEN
     $IF Component_Mfgstd_SYS.INSTALLED $THEN
        Part_Revision_API.Exist(newrec_.contract, newrec_.part_no, newrec_.eng_chg_level);
     $ELSE
        NULL;
     $END
   END IF; 
END Check_Eng_Chg_Level_Ref___;

PROCEDURE Check_Activity_Seq_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('ACTIVITY_SEQ', newrec_)) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN  
         Activity_API.Exist(newrec_.activity_seq);
      $ELSE
         NULL;
      $END
   END IF;
END Check_Activity_Seq_Ref___;

PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('CUSTOMER_NO', newrec_)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN  
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);
      $ELSE
         NULL;
      $END
   END IF;
END Check_Customer_No_Ref___;

PROCEDURE Check_Addr_No_Ref___ (
   newrec_ IN OUT inventory_part_at_customer_tab%ROWTYPE )
IS
BEGIN
   IF (Key_Validation_Required___('ADDR_NO', newrec_)) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        Cust_Ord_Customer_Address_API.Exist(newrec_.customer_no, newrec_.addr_no);
     $ELSE
        NULL;
      $END 
   END IF;
END Check_Addr_No_Ref___;


PROCEDURE Check_Handling_Unit___ (
   handling_unit_id_             IN NUMBER,
   old_quantity_                 IN NUMBER,
   new_quantity_                 IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN )
IS
BEGIN
   IF (handling_unit_id_ != 0 AND old_quantity_ = 0 AND new_quantity_ != 0) THEN
      IF validate_hu_struct_position_ THEN
         Handling_Unit_API.Validate_Structure_Position(handling_unit_id_);
      END IF;
   END IF;
END Check_Handling_Unit___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Our_Total_Qty_At_Customer (
   qty_to_deliv_confirm_    OUT NUMBER,
   qty_in_consignment_      OUT NUMBER,
   qty_in_exchange_         OUT NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2 )
IS
   CURSOR get_quantity IS
      SELECT   process_type, SUM(quantity) total_quantity
      FROM     inventory_part_at_customer_tab
      WHERE    contract = contract_
      AND      part_no  = part_no_
      GROUP BY process_type;
BEGIN
   FOR rec_ IN get_quantity LOOP
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
         qty_to_deliv_confirm_ := rec_.total_quantity;
      END IF;
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
         qty_in_consignment_ := rec_.total_quantity;
      END IF;
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
         qty_in_exchange_ := rec_.total_quantity;
      END IF;
   END LOOP;
END Get_Our_Total_Qty_At_Customer;


PROCEDURE Increase_Our_Qty_At_Customer (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   customer_no_                  IN VARCHAR2,
   addr_no_                      IN VARCHAR2,
   expiration_date_              IN DATE,
   process_type_db_              IN VARCHAR2,
   transaction_id_               IN NUMBER,
   transaction_code_             IN VARCHAR2,
   project_id_                   IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref5_                  IN VARCHAR2,
   quantity_                     IN NUMBER,
   catch_quantity_               IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE )
IS
   attr_                   VARCHAR2(32000) := NULL;
   oldrec_                 inventory_part_at_customer_tab%ROWTYPE;
   newrec_                 inventory_part_at_customer_tab%ROWTYPE;
   objid_                  INVENTORY_PART_AT_CUSTOMER.objid%TYPE;
   objversion_             INVENTORY_PART_AT_CUSTOMER.objversion%TYPE;
   cost_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   dummy_number_           NUMBER;
   local_location_group_   VARCHAR2(20);
   local_configuration_id_ inventory_part_at_customer_tab.configuration_id%TYPE;
   local_lot_batch_no_     inventory_part_at_customer_tab.lot_batch_no%TYPE;
   local_serial_no_        inventory_part_at_customer_tab.serial_no%TYPE;
   local_eng_chg_level_    inventory_part_at_customer_tab.eng_chg_level%TYPE;
   local_waiv_dev_rej_no_  inventory_part_at_customer_tab.waiv_dev_rej_no%TYPE;
   local_activity_seq_     inventory_part_at_customer_tab.activity_seq%TYPE;
   local_handling_unit_id_ inventory_part_at_customer_tab.handling_unit_id%TYPE;
   local_customer_no_      inventory_part_at_customer_tab.customer_no%TYPE;
   local_addr_no_          inventory_part_at_customer_tab.addr_no%TYPE;
   local_expiration_date_  inventory_part_at_customer_tab.expiration_date%TYPE;
   indrec_                 Indicator_Rec;
BEGIN
   IF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
      local_location_group_   := 'DELIVERY CONFIRM';
      local_configuration_id_ := '*';
      local_lot_batch_no_     := '*';
      local_serial_no_        := '*';
      local_eng_chg_level_    := '1';
      local_waiv_dev_rej_no_  := '*';
      local_activity_seq_     := 0;
      local_handling_unit_id_ := 0;
      local_customer_no_      := '*';
      local_addr_no_          := '*';
   ELSIF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
      local_location_group_   := 'CONSIGNMENT';
      local_configuration_id_ := configuration_id_;
      local_lot_batch_no_     := lot_batch_no_;
      local_serial_no_        := serial_no_;
      local_eng_chg_level_    := eng_chg_level_;
      local_waiv_dev_rej_no_  := waiv_dev_rej_no_;
      local_activity_seq_     := activity_seq_;
      local_handling_unit_id_ := handling_unit_id_;
      local_customer_no_      := customer_no_;
      local_addr_no_          := addr_no_;
   ELSIF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
      local_location_group_   := 'PART EXCHANGE';
      local_configuration_id_ := configuration_id_;
      local_lot_batch_no_     := lot_batch_no_;
      local_serial_no_        := serial_no_;
      local_eng_chg_level_    := eng_chg_level_;
      local_waiv_dev_rej_no_  := waiv_dev_rej_no_;
      local_activity_seq_     := activity_seq_;
      local_handling_unit_id_ := handling_unit_id_;
      
      $IF (Component_Order_SYS.INSTALLED) $THEN
          DECLARE
             co_line_rec_  Customer_Order_Line_API.Public_Rec;                            
          BEGIN
             co_line_rec_       := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
             local_customer_no_ := co_line_rec_.customer_no;
             local_addr_no_     := co_line_rec_.ship_addr_no;
          END;
      $ELSE
          Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;
   
   IF (expiration_date_ IS NULL) THEN
      local_expiration_date_ := Database_SYS.last_Calendar_date_;
   ELSE
      local_expiration_date_ := expiration_date_;
   END IF;

   cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);

   Inventory_Transaction_Hist_API.Create_And_Account( transaction_id_     => dummy_number_,
                                                      accounting_id_      => dummy_number_,
                                                      value_              => dummy_number_,
                                                      transaction_code_   => transaction_code_,
                                                      contract_           => contract_,
                                                      part_no_            => part_no_,
                                                      configuration_id_   => local_configuration_id_,
                                                      location_no_        => NULL,
                                                      lot_batch_no_       => local_lot_batch_no_,
                                                      serial_no_          => local_serial_no_,
                                                      waiv_dev_rej_no_    => local_waiv_dev_rej_no_,
                                                      eng_chg_level_      => local_eng_chg_level_,
                                                      activity_seq_       => local_activity_seq_,
                                                      handling_unit_id_   => local_handling_unit_id_,
                                                      project_id_         => project_id_,
                                                      source_ref1_        => source_ref1_,
                                                      source_ref2_        => source_ref2_,
                                                      source_ref3_        => source_ref3_,
                                                      source_ref4_        => source_ref4_,
                                                      source_ref5_        => source_ref5_,
                                                      reject_code_        => NULL,
                                                      cost_detail_tab_    => cost_detail_tab_,
                                                      unit_cost_          => NULL,
                                                      quantity_           => quantity_,
                                                      qty_reversed_       => 0,
                                                      catch_quantity_     => catch_quantity_,
                                                      source_             => NULL,
                                                      source_ref_type_    => NULL,
                                                      owning_vendor_no_   => NULL,
                                                      condition_code_     => NULL,
                                                      location_group_     => local_location_group_,
                                                      part_ownership_db_  => 'COMPANY OWNED',
                                                      owning_customer_no_ => NULL,
                                                      expiration_date_    => expiration_date_);

   -- Update the existing record
   IF (Check_Exist___(contract_,
                      part_no_,
                      local_configuration_id_,
                      local_lot_batch_no_,
                      local_serial_no_,
                      local_eng_chg_level_,
                      local_waiv_dev_rej_no_,
                      local_activity_seq_,
                      local_handling_unit_id_,
                      local_customer_no_,
                      local_addr_no_,
                      local_expiration_date_,
                      process_type_db_)) THEN
      oldrec_ := Lock_By_Keys___(contract_,
                                 part_no_,
                                 local_configuration_id_,
                                 local_lot_batch_no_,
                                 local_serial_no_,
                                 local_eng_chg_level_,
                                 local_waiv_dev_rej_no_,
                                 local_activity_seq_,
                                 local_handling_unit_id_,
                                 local_customer_no_,
                                 local_addr_no_,
                                 local_expiration_date_,
                                 process_type_db_);
      newrec_ := oldrec_;
      newrec_.quantity := newrec_.quantity + quantity_;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, validate_hu_struct_position_);
   -- Create new record
   ELSE
      newrec_.contract         := contract_;
      newrec_.part_no          := part_no_;
      newrec_.configuration_id := local_configuration_id_;
      newrec_.lot_batch_no     := local_lot_batch_no_;
      newrec_.serial_no        := local_serial_no_;
      newrec_.eng_chg_level    := local_eng_chg_level_;
      newrec_.waiv_dev_rej_no  := local_waiv_dev_rej_no_;
      newrec_.activity_seq     := local_activity_seq_;
      newrec_.handling_unit_id := local_handling_unit_id_;
      newrec_.customer_no      := local_customer_no_;
      newrec_.addr_no          := local_addr_no_;
      newrec_.expiration_date  := local_expiration_date_;
      newrec_.process_type     := process_type_db_;
      newrec_.quantity         := quantity_;
      indrec_ := Get_Indicator_Rec___(newrec_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_, validate_hu_struct_position_);
   END IF;
END Increase_Our_Qty_At_Customer;


PROCEDURE Decrease_Our_Qty_At_Customer (
   transaction_id_         OUT VARCHAR2,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN  NUMBER,
   customer_no_            IN VARCHAR2,
   addr_no_                IN VARCHAR2,
   expiration_date_        IN DATE,
   process_type_db_        IN VARCHAR2,
   transaction_code_       IN VARCHAR2,
   project_id_             IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2,
   quantity_               IN NUMBER,
   catch_quantity_         IN NUMBER,
   scrap_cause_            IN VARCHAR2,
   scrap_note_             IN VARCHAR2,
   alt_source_ref1_        IN VARCHAR2 DEFAULT NULL,
   alt_source_ref2_        IN VARCHAR2 DEFAULT NULL,
   alt_source_ref3_        IN VARCHAR2 DEFAULT NULL,
   alt_source_ref4_        IN VARCHAR2 DEFAULT NULL,
   alt_source_ref5_        IN VARCHAR2 DEFAULT NULL,
   alt_source_ref_type_db_ IN VARCHAR2 DEFAULT NULL)
IS
   oldrec_                 inventory_part_at_customer_tab%ROWTYPE;
   newrec_                 inventory_part_at_customer_tab%ROWTYPE;
   objid_                  INVENTORY_PART_AT_CUSTOMER.objid%TYPE;
   objversion_             INVENTORY_PART_AT_CUSTOMER.objversion%TYPE;
   dummy_number_           NUMBER;
   quantity_available_     NUMBER;
   local_location_group_   VARCHAR2(20);
   local_configuration_id_ inventory_part_at_customer_tab.configuration_id%TYPE;
   local_lot_batch_no_     inventory_part_at_customer_tab.lot_batch_no%TYPE;
   local_serial_no_        inventory_part_at_customer_tab.serial_no%TYPE;
   local_eng_chg_level_    inventory_part_at_customer_tab.eng_chg_level%TYPE;
   local_waiv_dev_rej_no_  inventory_part_at_customer_tab.waiv_dev_rej_no%TYPE;
   local_activity_seq_     inventory_part_at_customer_tab.activity_seq%TYPE;
   local_handling_unit_id_ inventory_part_at_customer_tab.handling_unit_id%TYPE;
   local_customer_no_      inventory_part_at_customer_tab.customer_no%TYPE;
   local_addr_no_          inventory_part_at_customer_tab.addr_no%TYPE;
   local_expiration_date_  inventory_part_at_customer_tab.expiration_date%TYPE;
   empty_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   remove_unit_cost_       BOOLEAN := TRUE;
BEGIN
   IF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
      local_location_group_   := 'DELIVERY CONFIRM';
      local_configuration_id_ := '*';
      local_lot_batch_no_     := '*';
      local_serial_no_        := '*';
      local_eng_chg_level_    := '1';
      local_waiv_dev_rej_no_  := '*';
      local_activity_seq_     := 0;
      local_handling_unit_id_ := 0;
      local_customer_no_      := '*';
      local_addr_no_          := '*';
   ELSIF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
      local_location_group_   := 'CONSIGNMENT';
      local_configuration_id_ := configuration_id_;
      local_lot_batch_no_     := lot_batch_no_;
      local_serial_no_        := serial_no_;
      local_eng_chg_level_    := REPLACE(eng_chg_level_, '*', 1);
      local_waiv_dev_rej_no_  := waiv_dev_rej_no_;
      local_activity_seq_     := activity_seq_;
      local_handling_unit_id_ := NVL(handling_unit_id_, 0);
      local_customer_no_      := customer_no_;
      local_addr_no_          := addr_no_;
   ELSIF (process_type_db_ = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
      local_location_group_   := 'PART EXCHANGE';
      local_configuration_id_ := configuration_id_;
      local_lot_batch_no_     := lot_batch_no_;
      local_serial_no_        := serial_no_;
      local_eng_chg_level_    := eng_chg_level_;
      local_waiv_dev_rej_no_  := waiv_dev_rej_no_;
      local_activity_seq_     := activity_seq_;
      local_handling_unit_id_ := handling_unit_id_;
      
      $IF (Component_Order_SYS.INSTALLED) $THEN
          DECLARE
             co_line_rec_  Customer_Order_Line_API.Public_Rec;                            
          BEGIN
             co_line_rec_       := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
             local_customer_no_ := co_line_rec_.customer_no;
             local_addr_no_     := co_line_rec_.ship_addr_no;
          END;
      $ELSE
          Error_SYS.Component_Not_Exist('ORDER');
      $END     
   END IF;

   IF (expiration_date_ IS NULL) THEN
      local_expiration_date_ := Database_SYS.last_Calendar_date_;
   ELSE
      local_expiration_date_ := expiration_date_;
   END IF;

   IF (transaction_code_ = 'CRO-EXR-OU') THEN
      remove_unit_cost_ := FALSE;
   END IF;

   IF (transaction_code_ NOT IN ('UNCODELVOU', 'UNDELCONOU')) THEN
      -- EBALL-90, Passed expiration_date_ as the value to expiration_date_ parameter.
      Inventory_Transaction_Hist_API.Create_And_Account( transaction_id_     => transaction_id_,
                                                         accounting_id_      => dummy_number_,
                                                         value_              => dummy_number_,
                                                         transaction_code_   => transaction_code_,
                                                         contract_           => contract_,
                                                         part_no_            => part_no_,
                                                         configuration_id_   => local_configuration_id_,
                                                         location_no_        => NULL,
                                                         lot_batch_no_       => local_lot_batch_no_,
                                                         serial_no_          => local_serial_no_,
                                                         waiv_dev_rej_no_    => local_waiv_dev_rej_no_,
                                                         eng_chg_level_      => local_eng_chg_level_,
                                                         activity_seq_       => local_activity_seq_,
                                                      	handling_unit_id_   => local_handling_unit_id_,
                                                         project_id_         => project_id_,
                                                         source_ref1_        => source_ref1_,
                                                         source_ref2_        => source_ref2_,
                                                         source_ref3_        => source_ref3_,
                                                         source_ref4_        => source_ref4_,
                                                         source_ref5_        => source_ref5_,
                                                         reject_code_        => scrap_cause_,
                                                         cost_detail_tab_    => empty_cost_detail_tab_,
                                                         unit_cost_          => NULL,
                                                         quantity_           => quantity_,
                                                         qty_reversed_       => 0,
                                                         catch_quantity_     => catch_quantity_,
                                                         source_             => scrap_note_,
                                                         source_ref_type_    => NULL,
                                                         owning_vendor_no_   => NULL,
                                                         condition_code_     => NULL,
                                                         location_group_     => local_location_group_,
                                                         part_ownership_db_  => 'COMPANY OWNED',
                                                         owning_customer_no_ => NULL,
                                                         expiration_date_    => expiration_date_);

      Inventory_Transaction_Hist_API.Set_Alt_Source_Ref(transaction_id_,
                                                        alt_source_ref1_,
                                                        alt_source_ref2_,
                                                        alt_source_ref3_,
                                                        alt_source_ref4_,
                                                        alt_source_ref5_,
                                                        alt_source_ref_type_db_);
   END IF;
   
   quantity_available_ := NVL(Get_Quantity(contract_,
                                           part_no_,
                                           local_configuration_id_,
                                           local_lot_batch_no_,
                                           local_serial_no_,
                                           local_eng_chg_level_,
                                           local_waiv_dev_rej_no_,
                                           local_activity_seq_,
                                           local_handling_unit_id_,
                                           local_customer_no_,
                                           local_addr_no_,
                                           local_expiration_date_,
                                           Stock_At_Cust_Process_Type_API.Decode(process_type_db_)), 0);

   -- Delete existing record
   IF (quantity_available_ = quantity_) THEN
      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                contract_,
                                part_no_,
                                local_configuration_id_,
                                local_lot_batch_no_,
                                local_serial_no_,
                                local_eng_chg_level_,
                                local_waiv_dev_rej_no_,
                                local_activity_seq_,
                                local_handling_unit_id_,
                                local_customer_no_,
                                local_addr_no_,
                                local_expiration_date_,
                                process_type_db_);
      oldrec_ := Get_Object_By_Id___(objid_);

      Check_Delete___(oldrec_);
      Delete___(objid_, oldrec_, remove_unit_cost_);
   -- Update the existing record
   ELSE
      newrec_ := Lock_By_Keys___(contract_,
                                 part_no_,
                                 local_configuration_id_,
                                 local_lot_batch_no_,
                                 local_serial_no_,
                                 local_eng_chg_level_,
                                 local_waiv_dev_rej_no_,
                                 local_activity_seq_,
                                 local_handling_unit_id_,
                                 local_customer_no_,
                                 local_addr_no_,
                                 local_expiration_date_,
                                 process_type_db_);
      newrec_.quantity := newrec_.quantity - quantity_;
      Modify___(newrec_);
   END IF;
END Decrease_Our_Qty_At_Customer;


PROCEDURE Modify_Lot_Expiration_Date (
   part_no_          IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   expiration_date_  IN DATE ) 
IS
   new_expiration_date_    DATE;

   CURSOR get_record IS
      SELECT *
        FROM inventory_part_at_customer_tab
       WHERE part_no = part_no_
         AND lot_batch_no = lot_batch_no_
         AND process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE
         FOR UPDATE;
BEGIN
   IF (expiration_date_ IS NULL) THEN
      new_expiration_date_ := Database_SYS.last_calendar_date_;
   ELSE
      new_expiration_date_ := expiration_date_;
   END IF;

   FOR oldrec_ IN get_record LOOP
      Check_Delete___(oldrec_);
      Delete___(NULL, oldrec_, FALSE);

      -- Create the new record with new expiration date.
      oldrec_.expiration_date := new_expiration_date_;
      New___(oldrec_);
   END LOOP;
END Modify_Lot_Expiration_Date;


@UncheckedAccess
FUNCTION Quantity_Exists (
   part_no_        IN VARCHAR2,
   serial_tracked_ IN BOOLEAN ) RETURN BOOLEAN
IS
   dummy_               NUMBER;
   quantity_exists_     BOOLEAN     := FALSE;
   serial_tracked_char_ VARCHAR2(5) := Fnd_Boolean_API.db_false;

   CURSOR exist_control IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE ((serial_no != '*' AND serial_tracked_char_ = Fnd_Boolean_API.db_true) OR
              (serial_no  = '*' AND serial_tracked_char_ = Fnd_Boolean_API.db_false))
         AND part_no = part_no_
         AND quantity != 0;
BEGIN
   IF (serial_tracked_) THEN
      serial_tracked_char_ := Fnd_Boolean_API.db_true;
   END IF;

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      quantity_exists_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(quantity_exists_);
END Quantity_Exists;


@UncheckedAccess
FUNCTION Check_Quantity_Exist (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2 DEFAULT NULL,
   serial_no_                     IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_               NUMBER;
   qty_found_           BOOLEAN;
   
   CURSOR check_exist IS
      SELECT 1
      FROM   inventory_part_at_customer_tab
      WHERE  quantity != 0
        AND  contract     = contract_
        AND  part_no      = part_no_
        AND  (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND  (lot_batch_no     = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND  (serial_no        = serial_no_        OR serial_no_        IS NULL);
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      qty_found_ := TRUE;
   ELSE
      qty_found_ := FALSE;
   END IF;
   CLOSE check_exist;

   RETURN (qty_found_);
END Check_Quantity_Exist;


@UncheckedAccess
FUNCTION Get_Company_Owned_Inventory (
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2 ) RETURN NUMBER
IS
   quantity_         NUMBER;

   CURSOR get_quantity IS
      SELECT SUM(quantity)
      FROM   inventory_part_at_customer_tab
      WHERE  contract     = contract_
        AND  part_no      = part_no_
        AND  (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND  (lot_batch_no     = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND  (serial_no        = serial_no_        OR serial_no_        IS NULL);
BEGIN
   OPEN get_quantity;
   FETCH get_quantity INTO quantity_;
   CLOSE get_quantity;
   RETURN quantity_;
END Get_Company_Owned_Inventory;


@UncheckedAccess
FUNCTION Get_Company_Owned_Inventory (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2) RETURN Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab
IS
   qty_at_customer_tab_  Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;
   
   CURSOR Get_Company_Owned_Inventory IS 
      SELECT configuration_id                             configuration_id,
             lot_batch_no                                 lot_batch_no,
             serial_no                                    serial_no,
             SUM(quantity)                                sum_quantity
      FROM   inventory_part_at_customer_tab
      WHERE  contract          = contract_
        AND  part_no           = part_no_
        AND  (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND  quantity != 0
   GROUP BY  configuration_id, lot_batch_no, serial_no;
BEGIN
   OPEN  Get_Company_Owned_Inventory;
   FETCH Get_Company_Owned_Inventory BULK COLLECT INTO qty_at_customer_tab_;
   CLOSE Get_Company_Owned_Inventory;

   RETURN (qty_at_customer_tab_);
END Get_Company_Owned_Inventory;


@UncheckedAccess
FUNCTION Check_Part_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_    NUMBER;
   CURSOR get_attr IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE contract = contract_
         AND part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      RETURN TRUE;
   ELSE
      CLOSE get_attr;
      RETURN FALSE;
   END IF;
END Check_Part_Exist;


@UncheckedAccess
FUNCTION Check_Individual_Exist (
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE part_no = part_no_
         AND serial_no = serial_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   RETURN temp_;
END Check_Individual_Exist;


@UncheckedAccess
FUNCTION Check_Lot_Batch_Exist (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE part_no      = part_no_
         AND lot_batch_no = lot_batch_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   RETURN temp_;
END Check_Lot_Batch_Exist;


@UncheckedAccess
FUNCTION Get_Lot_Batch_Track_Status (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_         NUMBER;
   default_value_ BOOLEAN := FALSE;
   other_value_   BOOLEAN := FALSE;
   return_string_ VARCHAR2(20);

   CURSOR get_defaults_at_customer IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE lot_batch_no = '*'
         AND part_no = part_no_
         AND quantity != 0;

   CURSOR get_not_defaults_at_Customer IS
      SELECT 1
        FROM inventory_part_at_customer_tab
       WHERE lot_batch_no != '*'
         AND part_no = part_no_
         AND quantity != 0;
BEGIN
   OPEN get_defaults_at_customer;
   FETCH get_defaults_at_customer INTO dummy_;
   IF get_defaults_at_customer%FOUND THEN
      default_value_ := TRUE;
   END IF;
   CLOSE get_defaults_at_customer;

   OPEN get_not_defaults_at_Customer;
   FETCH get_not_defaults_at_Customer INTO dummy_;
   IF get_not_defaults_at_Customer%FOUND THEN
      other_value_ := TRUE;
   END IF;
   CLOSE get_not_defaults_at_Customer;

   IF other_value_ AND NOT default_value_ THEN
      return_string_ := 'LOT TRACKING';
   ELSIF default_value_ AND NOT other_value_ THEN
      return_string_ := 'NOT LOT TRACKING';
   ELSIF default_value_ AND other_value_ THEN
      return_string_ := 'BOTH';
   ELSIF NOT default_value_ AND NOT other_value_ THEN
      return_string_ := NULL;
   END IF;
   RETURN return_string_;
END Get_Lot_Batch_Track_Status;


@UncheckedAccess
FUNCTION Check_Qty_For_Condition (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2) RETURN NUMBER
IS
   found_      NUMBER := 0;

   CURSOR get_lot_serial IS
      SELECT DISTINCT lot_batch_no, serial_no
      FROM   inventory_part_at_customer_tab
      WHERE  part_no = part_no_
      AND    contract = contract_
      AND    configuration_id = configuration_id_
      AND    quantity != 0;
BEGIN
   FOR lot_serial_rec_ IN get_lot_serial LOOP
      IF condition_code_ = Condition_Code_Manager_API.Get_Condition_Code(part_no_, lot_serial_rec_.serial_no, lot_serial_rec_.lot_batch_no) THEN
         found_ := 1;
         EXIT;
      END IF;
   END LOOP;
   RETURN found_;
END Check_Qty_For_Condition;


@UncheckedAccess
FUNCTION Get_Handling_Unit_Row_Count (
   handling_unit_id_  IN  NUMBER)  RETURN NUMBER
IS
   row_count_ NUMBER;
   CURSOR get_row_count IS
      SELECT count(*)
      FROM   inventory_part_at_customer_tab
      WHERE  handling_unit_id = handling_unit_id_;
BEGIN
   OPEN get_row_count;
   FETCH get_row_count INTO row_count_;
   CLOSE get_row_count;
   
   RETURN row_count_;
END Get_Handling_Unit_Row_Count;


PROCEDURE Get_Our_Total_Qty_At_Customer (
   qty_to_deliv_confirm_    OUT NUMBER,
   qty_in_consignment_      OUT NUMBER,
   qty_in_exchange_         OUT NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2 )
IS
   CURSOR get_quantity IS
      SELECT   process_type, SUM(quantity) total_quantity
      FROM     inventory_part_at_customer_tab
      WHERE    contract = contract_
      AND      part_no  = part_no_
      AND      customer_no = customer_no_
      AND      addr_no = addr_no_
      GROUP BY process_type;
BEGIN
   FOR rec_ IN get_quantity LOOP
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
         qty_to_deliv_confirm_ := rec_.total_quantity;
      END IF;
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
         qty_in_consignment_ := rec_.total_quantity;
      END IF;
      IF (rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
         qty_in_exchange_ := rec_.total_quantity;
      END IF;
   END LOOP;
END Get_Our_Total_Qty_At_Customer;

