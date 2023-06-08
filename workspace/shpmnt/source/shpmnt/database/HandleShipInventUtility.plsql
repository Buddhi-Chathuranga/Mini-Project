-----------------------------------------------------------------------------
--
--  Logical unit: HandleShipInventUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220624  Aabalk  SCDEV-9149, Modified Raise_Not_Correct_Return_Loc method to take in source ref type and demand code as parameters and raise errors based on them.
--  220624  Aabalk  SCDEV-10967, Modified Scrap_Part_In_Ship_Inv__ method to restrict scrapping of parts for Shipment Orders with Purchase Receipt demand code.
--  220620  Aabalk  SCDEV-9149, Modified Return_From_Ship_Inv__ method to allow return of parts to QA and Arrival locations for Shipment Orders with Purchase Receipt demand code.
--  220523  RoJalk  SCDEV-9134, Modified Move_To_Shipment_Location and added parameters source_ref_type_db_, source_ref_demand_code_ to Inventory_Part_In_Stock_API.Reserve_Part call. 
--  220513  Moinlk  SCDEV-7787, Add sql_where_expression_ to Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist methods.
--  220509  RoJalk  SCDEV-8951, Added the parameter source_ref_demand_code_ to the method Move_To_Shipment_Location.
--  220316  Aabalk  Bug 162662(SCDEV-8198), Added method Get_Default_Shipment_Location to fetch the default shipment location for a customer order line.
--  220222          Modified Get_Shipment_Inv_Location to fetch default shipment location using customer order line parameters instead of header values if a shipment is not used.
--  220105  PamPlk  SC21R2-7012, Modified the methods Move_Between_Ship_Inv__ and Scrap_Part_In_Ship_Inv__ in order to raise an error for Purchase Receipt Return.
--  211220  PamPlk  SC21R2-2979, Added the parameter shipment_id_ to the methods Move_Between_Ship_Inv__, Move_To_Shipment_Location and Return_From_Ship_Inv__.
--  211217  AsZelk  SC21R2-6630, Modified Return_From_Ship_Inv__() to allow Return Part from Shipment location to QA or Arrival location for Purchase Receipt Return types and Revert Receipt Return.
--  211102  PrRtlk  SC21R2-5678, Added DB_PURCH_RECEIPT_RETURN value to the Get_Inv_Trans_Src_Ref_Type_Db method.
--  210716  RoJalk  SC21R2-1374, Modified Move_To_Shipment_Location and passed ship_handling_unit_id_ to Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked.
--  210711  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_ to the method Move_To_Shipment_Location
--  210711          to support report picking on shipment handling unit level.
--  210303  BudKlk  Bug 157543(SCZ-13440), Modified Get_Shipment_Inv_Location_No() method to exculde receipt_blocked locations for the Move Parts into Shipment Inventory dialog.
--  210208  DaZase  Bug 157925 (SCZ-13480), Changed size on unique_column_value_/Column_Value_Tab from 50 to 200 in Get_Column_Value_If_Unique methods.
--  201109  RoJalk  SC2020R1-10460, Modified Move_To_Shipment_Location and called Validate_Sender_Location for shipment connected records.
--  200317  RasDlk  SCSPRING20-1238, Modified Get_Shipment_Inv_Location(), Get_Default_Shipment_Location() by adding sender and receiver information.
--  200311  DhAplk  Bug 152533 (SCZ-9094), Modified Move_To_Shipment_Location() to correct the comparison validation in same UoM values.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200310  RasDlk  SCSPRING20-1238, Modified the method Get_Default_Shipment_Location() to fetch the shipment inventory location no in Shipment Order flow.
--  200221  Aabalk  SCSPRING20-663, Added Validate_Sender_Location method to validate warehouse inventory locations based on sender info.
--                  Modified Move_Between_Ship_Inv__ in order to validate the move based on the sender type.
--  200219  RasDlk  SCSPRING20-689, Modified Get_Shipment_Inv_Location_No by adding sender_type_ and sender_id_ parameters to filter location no based on sender type.
--  191211  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191211          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191211         'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  191206  Aabalk  SCSPRING20-663, Included SHIPMENT_ORDER in Get_Inv_Trans_Src_Ref_Type_Db.
--  190927  DaZase  SCSPRING20-166, Added Raise_Value_Context_Error___ to solve MessageDefinitionValidation issue.
--  190821  SBalLK  Bug 149413 (SCZ-6113), Modified Move_To_Shipment_Location() method to not reset manual weight and volumn of the handling unit when moving from inventory to shipment location.
--  190327  KHVESE  SCUXXW4-5659, Modified the interface of one instances of method Get_Shipment_Inv_Location and renamed the method to Get_Ship_Inv_Location.
--  190425  KiSalk  Bug 147862(SCZ-4366), Modified methods Move_Between_Ship_Inv__, Return_From_Ship_Inv__, Scrap_Part_In_Ship_Inv__ to accept un converted source_ref parameters.
--  190207  ChBnlk  Bug 146742 (SCZ-3197), Modified Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist by removing the filterations
--  190207          on qty_picked to select 'Mixed' handling units as well and Inventory_Location_Type to improve performance. 
--  190120  RasDlk  SCUXXW4-4694, Added the Get_Shipment_Inv_Location_No method to retrieve the shipment location required for Move Parts into Shipment Inventory dialog.
--  181221  RasDlk  SCUXXW4-4694, Added the Get_Shipment_Inv_Location overloaded methods to retrieve the shipment location required for Move Parts into Shipment Inventory dialog.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180223  KHVESE  STRSC-15956, Modified method Move_To_Shipment_Location.
--  180213  CKumlk  STRSC-16948, Modified Create_Data_Capture_Lov to use customer description as source_ref2 to 4 descriptions when shipment id is null or zero. 
--  180208  SWiclk  STRSC-16141, Modified Get_Column_Value_If_Unique() by changing the view from HANDL_UNIT_IN_SHIP_INV_ALT to HANDLE_SOURCE_IN_SHIP_INV_ALT.
--  180202  CKumlk  STRSC-15914, Modified Create_Data_Capture_Lov to use customer description as source ref 1 description When shipment id is null or zero.  
--  180119  KHVESE  STRSC-8813, Modified method Move_To_Shipment_Location.
--  171208  DaZase  STRSC-15116, Replaced server calls to fetch location type in where-statment with location_type_db in Create_Data_Capture_Lov,
--  171208          Get_Column_Value_If_Unique and Record_With_Column_Value_Exist to improve performance.
--  171128  SURBLK  STRSC-11724, Added Add_Detail_For_Ship_Inv_Hu to add the feedback items to values.
--  171120  CKumlk  STRSC-13592, Added method Validate_Qty_To_Scrap to validate scrap quantity.
--  171120  SURBLK  STRSC-14508, Added Record_With_Column_Value_Exist.
--  171110  SURBLK  STRSC-13906, Create_Data_Capture_Lov to support for the Handling Units in shipment Inventory.
--  171106  SURBLK  STRSC-11724, Added Get_Column_Value_If_Unique to add the feedback items to values.
--  170621  KhVese  STRSC-9112, Modified method Move_To_Shipment_Location to call to Set_Delivery_Note_Invalid().
--  170523  MaAuse  LIM-11433, Modified the call to Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked in Move_To_Shipment_Location,
--  170523          added calculation of input_qty.
--  170508  RoJalk  STRSC-8047, Modified Move_HU_Between_Ship_Inv__, Scrap_HU_In_Ship_Inv__, Return_HU_From_Ship_Inv__
--  170508          to convert shipment source refernce from * to null using Shipment_Line_API.Get_Converted_Source_Ref.
--  170507  MaIklk  STRSC-7566, Fixed to call Remove_Without_Unpack() for semi centralized scrap part as well and used the same methods as in CO to call scrap part.
--  170328  RoJalk  LIM-11080, Included PROJECT DELIVERABLES in Get_Inv_Trans_Src_Ref_Type_Db.
--  170320  Cpeilk  Bug 132676, Modified Return_From_Ship_Inv__ to change the sign of qty_returned_ so that correct rental comparisons can be done.
--  170317  Jhalse  LIM-10113, Reworked earlier implementation and removed unused methods.
--  170310  Jhalse  LIM-10113, Added comments and changed source specific calls to generic ones.
--  170310  MaIklk  LIM-10562, Changed data type of line_item_no_ to varchar2 in Move_To_Shipment_Location.
--  170307  Jhalse  LIM-10113, Added new methods Confirm_Shipment_Location_No, Get_Valid_Ship_Loc_No for to support the new picking functionality.
--  170303  RoJalk  LIM-9848, Replaced Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info with
--  170303          Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info.
--  170223  MaIklk  LIM-9422, Fixed to pass shipment_line_no as parameter when calling ShipmentReservHandlUnit methods.
--  170210  Chfose  LIM-10509, Added new methods Get_Handl_Unit_Unit_Meas & Get_Handl_Unit_Qty_Picked.
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170103  Chfose  LIM-10154, Added handling of move_comment in Return_From_Ship_Inv__ & Return_HU_From_Ship_Inv__, Move_Between_Ship_Inv__ & Move_HU_Between_Ship_Inv__.
--  161222  Chfose  LIM-3663, Aligned Scrap, Return and Move_Between_Ship_Inv methods for part + hu with the new repacking in shipment inventory.
--  161220  Jhalse  LIM-10062, Fixed bug regarding scrap and move that caused handling units to be unpacked from their structures.
--  161219  Chfose  LIM-10070, Made Get_Inv_Trans_Src_Ref_Type a public method and added Get_Inv_Trans_Src_Ref_Type_Db.
--  161219	Jhalse  LIM-9191, Removed parent if the handling unit is not a top node in Move_Between_HU, and subdued the hu_struct validation.
--  161215  Chfose  LIM-3663, Fetched the pre-defined packing (ShipmentReservHandlUnit-records) before reserving in Move_To_Shipment_Location in order
--  161215          to only reserve the quantity that will not be packed (and reserved when applying the packing).
--  161128  MaIklk  LIM-9749, Fixed the usages of renaming columns in Shipment_Reserv_Handl_Unit_Tab.
--  161116  MaIklk	LIM-9429, Implemented to call Reserve_Shipment_API.Scrap_Part when do scrap part.
--  160923  DaZase  LIM-8337, Added methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist.
--  160909  RoJalk  LIM-8191, Added the method Get_Default_Shipment_Loc__.
--  160905  RoJalk  LIM-8592, Modified Scrap_Part_In_Ship_Inv__ and included source ref info.
--  160902  RoJalk  LIM-8268, Added the method Get_Inv_Trans_Src_Ref_Type___ to fetch the mapping order type
--  160902          for the given source line to be used in the inventory transaction creation.     
--  160816  Chfose  LIM-8006, Modified calls to Shipment_Reserv_Handl_Unit_API in order to make use of new parameter reserv_handling_unit_id.
--  160802  RoJalk  LIM-8178, Created. Included the generic shipment inventory handling code.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_             CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;
db_false_            CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Value_Context_Error___ (
   column_description_ IN VARCHAR2,
   column_value_       IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
END Raise_Value_Context_Error___;   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Scrap_Part_In_Ship_Inv__
--   Scrap part in shipment inventory
PROCEDURE Scrap_Part_In_Ship_Inv__ (
   info_                         OUT VARCHAR2,  
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2,
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   pick_list_no_                 IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   qty_to_scrap_                 IN  NUMBER,
   catch_qty_to_scrap_           IN  NUMBER,
   scrap_cause_                  IN  VARCHAR2,
   scrap_note_                   IN  VARCHAR2,
   shipment_id_                  IN  NUMBER,
   discon_zero_stock_handl_unit_ IN  BOOLEAN DEFAULT TRUE)
IS 
   catch_quantity_                NUMBER := NULL;   
   public_reservation_rec_        Reserve_Shipment_API.Public_Reservation_Rec;
   inv_trans_source_ref_type_     VARCHAR2(50);
   part_cat_rec_                  Part_Catalog_API.Public_Rec;
   configuration_id_              VARCHAR2(50);
   shipment_line_no_              NUMBER;
   source_ref_demand_code_        VARCHAR2(20);
   converted_source_ref2_ shipment_line_tab.source_ref2%TYPE;
   converted_source_ref3_ shipment_line_tab.source_ref3%TYPE;
   converted_source_ref4_ shipment_line_tab.source_ref4%TYPE;
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      Error_SYS.Record_General(lu_name_, 'SCRAPPINGNOTALLOWED: Scrapping of parts is restricted for shipments created for :P1.', Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_));
   END IF;
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         source_ref_demand_code_ := Shipment_Order_Line_API.Get_Demand_Code_Db(source_ref1_, source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
      IF (source_ref_demand_code_ IS NOT NULL AND source_ref_demand_code_ = Order_Supply_Type_API.DB_PURCHASE_RECEIPT) THEN
         Error_SYS.Record_General(lu_name_, 'SCRAPNOTALLOWEDSOPR: Scrapping of parts is restricted for shipments created for :P1 having demand code :P2.', 
                                  Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_), Order_Supply_Type_API.Decode(Order_Supply_Type_API.DB_PURCHASE_RECEIPT));
      END IF;
   END IF;
   converted_source_ref2_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2);
   converted_source_ref3_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3);
   converted_source_ref4_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4);
   configuration_id_   := Shipment_Source_Utility_API.Get_Configuration_id(source_ref1_, converted_source_ref2_,
                                                                           converted_source_ref3_, converted_source_ref4_, source_ref_type_db_);
   -- To_Do_Lime
   -- Lock___(order_no_);
   
   -- Check that the scrapped part is in a Shipment Inventory and that the
   -- scrapping cause exists.
   IF (Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_) = 'SHIPMENT') THEN
      
      Scrapping_Cause_API.Exist(scrap_cause_, TRUE);
      Inventory_Event_Manager_API.Start_Session;
      inv_trans_source_ref_type_ := Get_Inv_Trans_Src_Ref_Type(source_ref_type_db_);
      -- Scrap part
      -- Reduce assigned quantity with the scrapped quantity.
      public_reservation_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                                  source_ref2_            => converted_source_ref2_, 
                                                                                  source_ref3_            => converted_source_ref3_,
                                                                                  source_ref4_            => converted_source_ref4_, 
                                                                                  source_ref_type_db_     => source_ref_type_db_,
                                                                                  contract_               => contract_, 
                                                                                  part_no_                => part_no_, 
                                                                                  location_no_            => location_no_, 
                                                                                  lot_batch_no_           => lot_batch_no_, 
                                                                                  serial_no_              => serial_no_,
                                                                                  eng_chg_level_          => eng_chg_level_, 
                                                                                  waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                  activity_seq_           => activity_seq_, 
                                                                                  handling_unit_id_       => handling_unit_id_,
                                                                                  pick_list_no_           => pick_list_no_, 
                                                                                  configuration_id_       => configuration_id_, 
                                                                                  shipment_id_            => shipment_id_);
      
      -- Added a check to raise an error message when quantity to scrap is greater than the quantity assigned.
      IF (qty_to_scrap_ > public_reservation_rec_.qty_assigned) THEN
         Error_SYS.Record_General('PickCustomerOrder', 'QTYSCRAPGTQRYASSIGN: Quantity to scrap is greater than the assigned quantity');
      END IF;
      
      IF(shipment_id_ != 0 AND handling_unit_id_ != 0) THEN
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, converted_source_ref2_, converted_source_ref3_, converted_source_ref4_,
                                                                             source_ref_type_db_ );
         
         -- This is done to avoid unpacking when we later modify the reservation.
         Shipment_Reserv_Handl_Unit_API.Remove_Without_Unpack(source_ref1_               => source_ref1_,
                                                              source_ref2_               => NVL(converted_source_ref2_,'*'),
                                                              source_ref3_               => NVL(converted_source_ref3_,'*'),
                                                              source_ref4_               => NVL(converted_source_ref4_,'*'),                                                                                 
                                                              contract_                  => contract_, 
                                                              part_no_                   => part_no_, 
                                                              location_no_               => location_no_, 
                                                              lot_batch_no_              => lot_batch_no_, 
                                                              serial_no_                 => serial_no_, 
                                                              eng_chg_level_             => eng_chg_level_,
                                                              waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                              activity_seq_              => activity_seq_, 
                                                              reserv_handling_unit_id_   => handling_unit_id_,
                                                              configuration_id_          => configuration_id_, 
                                                              pick_list_no_              => pick_list_no_, 
                                                              shipment_id_               => shipment_id_,
                                                              shipment_line_no_          => shipment_line_no_,
                                                              quantity_                  => qty_to_scrap_);
      END IF;
      IF(Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
         Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => contract_,       
                                                                     part_no_              => part_no_    ,
                                                                     configuration_id_     => configuration_id_  ,
                                                                     location_no_          => location_no_,
                                                                     lot_batch_no_         => lot_batch_no_,
                                                                     serial_no_            => serial_no_,
                                                                     eng_chg_level_        => eng_chg_level_,
                                                                     waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                     activity_seq_         => activity_seq_,
                                                                     handling_unit_id_     => handling_unit_id_,
                                                                     pick_list_no_         => pick_list_no_,
                                                                     qty_picked_           => - (qty_to_scrap_),  
                                                                     catch_qty_picked_     => - (catch_qty_to_scrap_),
                                                                     source_ref_type_db_   => Reserve_Shipment_API.Get_Inv_Res_Source_Type_Db(source_ref_type_db_),
                                                                     source_ref1_          => source_ref1_, 
                                                                     source_ref2_          => NVL(converted_source_ref2_,'*'),
                                                                     source_ref3_          => NVL(converted_source_ref3_,'*'),
                                                                     source_ref4_          => NVL(converted_source_ref4_,'*'),
                                                                     shipment_id_          => shipment_id_,        
                                                                     reserve_in_inventory_ => FALSE );                          
      ELSE                       
         Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_            => source_ref1_, 
                                                                   source_ref2_            => converted_source_ref2_, 
                                                                   source_ref3_            => converted_source_ref3_,
                                                                   source_ref4_            => converted_source_ref4_, 
                                                                   source_ref_type_db_     => source_ref_type_db_,
                                                                   contract_               => contract_, 
                                                                   part_no_                => part_no_, 
                                                                   location_no_            => location_no_,
                                                                   lot_batch_no_           => lot_batch_no_, 
                                                                   serial_no_              => serial_no_, 
                                                                   eng_chg_level_          => eng_chg_level_, 
                                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                                   activity_seq_           => activity_seq_, 
                                                                   handling_unit_id_       => handling_unit_id_,
                                                                   pick_list_no_           => pick_list_no_, 
                                                                   configuration_id_       => configuration_id_,
                                                                   shipment_id_            => shipment_id_,  
                                                                   remaining_qty_assigned_ => NULL,
                                                                   qty_picked_             => public_reservation_rec_.qty_picked - qty_to_scrap_,
                                                                   catch_qty_              => public_reservation_rec_.catch_qty  - catch_qty_to_scrap_,
                                                                   input_qty_              => NULL,
                                                                   input_unit_meas_        => NULL,           
                                                                   input_conv_factor_      => NULL,              
                                                                   input_variable_values_  => NULL,
                                                                   move_to_ship_location_  => 'FALSE');
      END IF;
      info_ := Client_SYS.Get_All_Info; 
      
      -- Unreserve at old location
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_    => catch_quantity_, 
                                               contract_          => contract_, 
                                               part_no_           => part_no_, 
                                               configuration_id_  => configuration_id_, 
                                               location_no_       => location_no_, 
                                               lot_batch_no_      => lot_batch_no_,
                                               serial_no_         => serial_no_, 
                                               eng_chg_level_     => eng_chg_level_, 
                                               waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                               activity_seq_      => activity_seq_,
                                               handling_unit_id_  => handling_unit_id_,
                                               quantity_          => -qty_to_scrap_);
      
      catch_quantity_               := catch_qty_to_scrap_;      
      
      Inventory_Part_In_Stock_API.Scrap_Part(catch_quantity_               => catch_quantity_, 
                                             contract_                     => contract_,
                                             part_no_                      => part_no_,
                                             configuration_id_             => configuration_id_, 
                                             location_no_                  => location_no_,
                                             lot_batch_no_                 => lot_batch_no_, 
                                             serial_no_                    => serial_no_,
                                             eng_chg_level_                => eng_chg_level_, 
                                             waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                                             activity_seq_                 => activity_seq_, 
                                             handling_unit_id_             => handling_unit_id_,
                                             quantity_                     => qty_to_scrap_, 
                                             scrap_cause_                  => scrap_cause_, 
                                             scrap_note_                   => scrap_note_,
                                             order_no_                     => source_ref1_,
                                             release_no_                   => converted_source_ref2_,
                                             sequence_no_                  => converted_source_ref3_,
                                             line_item_no_                 => converted_source_ref4_,
                                             order_type_                   => inv_trans_source_ref_type_,
                                             discon_zero_stock_handl_unit_ => discon_zero_stock_handl_unit_);
      
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         IF (public_reservation_rec_.delnote_no IS NOT NULL) THEN
            Delivery_Note_API.Set_Invalid(public_reservation_rec_.delnote_no);
         END IF;
      END IF;      
      
      Shipment_Source_Utility_API.Post_Scrap_Return_In_Ship_Inv(source_ref1_, converted_source_ref2_, converted_source_ref3_, converted_source_ref4_,
                                                                source_ref_type_db_, qty_to_scrap_);                                                                
      part_cat_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_cat_rec_.catch_unit_enabled = db_true_) THEN
         -- calculate and update the new price conv factor based on the catch quantities for catch unit handled parts.
         Shipment_Source_Utility_API.Recalc_Catch_Price_Conv_Factor(source_ref1_, converted_source_ref2_, source_ref3_, converted_source_ref4_, source_ref_type_db_);
      END IF;                                                  
      Inventory_Event_Manager_API.Finish_Session;  
      info_ := info_ || Client_SYS.Get_All_Info;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTCORRECTSCRAPLOC: You can only scrap parts in a Shipment Inventory.');
   END IF;
END Scrap_Part_In_Ship_Inv__;


PROCEDURE Move_HU_Between_Ship_Inv__(
   info_             OUT VARCHAR2,  
   handling_unit_id_ IN  NUMBER,
   to_contract_      IN  VARCHAR2,
   to_location_no_   IN  VARCHAR2,
   move_comment_     IN  VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_handl_unit IS
   SELECT
         ssr.source_ref1,
         ssr.source_ref2,
         ssr.source_ref3,
         ssr.source_ref4,
         ssr.source_ref_type_db,
         ssr.contract,
         ssr.part_no,
         ssr.location_no,
         ssr.lot_batch_no,
         ssr.serial_no,
         ssr.eng_chg_level,
         ssr.waiv_dev_rej_no,
         ssr.pick_list_no,
         ssr.activity_seq,
         ssr.handling_unit_id,
         ssr.shipment_id,
         ssr.qty_picked
   FROM shipment_source_reservation ssr
   WHERE (ssr.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
   AND ssr.qty_assigned > 0;
   
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   IF(Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, NULL);
   END IF;
   
   FOR rec_ IN get_handl_unit LOOP
      Move_Between_Ship_Inv__(info_                         => info_,
                              source_ref1_                  => rec_.source_ref1, 
                              source_ref2_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref2, rec_.source_ref_type_db  ), 
                              source_ref3_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref3, rec_.source_ref_type_db, 3), 
                              source_ref4_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref4, rec_.source_ref_type_db, 4), 
                              source_ref_type_db_           => rec_.source_ref_type_db, 
                              from_contract_                => rec_.contract, 
                              part_no_                      => rec_.part_no, 
                              from_location_no_             => rec_.location_no, 
                              lot_batch_no_                 => rec_.lot_batch_no, 
                              serial_no_                    => rec_.serial_no, 
                              eng_chg_level_                => rec_.eng_chg_level, 
                              waiv_dev_rej_no_              => rec_.waiv_dev_rej_no, 
                              pick_list_no_                 => rec_.pick_list_no, 
                              activity_seq_                 => rec_.activity_seq, 
                              handling_unit_id_             => rec_.handling_unit_id, 
                              to_contract_                  => to_contract_, 
                              to_location_no_               => to_location_no_, 
                              qty_to_move_                  => rec_.qty_picked,
                              catch_qty_to_move_            => NULL,
                              shipment_id_                  => rec_.shipment_id, 
                              move_comment_                 => move_comment_,
                              validate_hu_struct_position_  => FALSE);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Move_HU_Between_Ship_Inv__;

PROCEDURE Move_HU_Between_Ship_Inv__(
   info_                  OUT VARCHAR2,  
   handling_unit_id_list_ IN  VARCHAR2,
   to_contract_           IN  VARCHAR2,
   to_location_no_        IN  VARCHAR2,
   move_comment_          IN  VARCHAR2 DEFAULT NULL )
IS
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Handling_Unit_Id_Tab(handling_unit_id_list_);
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_Level_Sorted_Units(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         Move_HU_Between_Ship_Inv__(info_                 => info_,
                                    handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                    to_contract_          => to_contract_,
                                    to_location_no_       => to_location_no_,
                                    move_comment_         => move_comment_);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Move_HU_Between_Ship_Inv__;

PROCEDURE Scrap_HU_In_Ship_Inv__(
   info_             OUT VARCHAR2,  
   handling_unit_id_ IN  NUMBER,
   scrap_cause_      IN  VARCHAR2,
   scrap_note_       IN  VARCHAR2 )
IS
   CURSOR get_handl_unit_ IS
   SELECT 
         ssr.source_ref1, 
         ssr.source_ref2, 
         ssr.source_ref3, 
         ssr.source_ref4, 
         ssr.source_ref_type_db,
         ssr.contract, 
         ssr.part_no, 
         ssr.location_no, 
         ssr.lot_batch_no, 
         ssr.serial_no, 
         ssr.eng_chg_level, 
         ssr.waiv_dev_rej_no, 
         ssr.pick_list_no, 
         ssr.activity_seq, 
         ssr.handling_unit_id,
         ssr.qty_picked,
         ssr.shipment_id
   FROM shipment_source_reservation ssr
   WHERE (ssr.handling_unit_id IN (SELECT hu.handling_unit_id 
                  FROM handling_unit hu
                  CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                  START WITH hu.handling_unit_id IN (handling_unit_id_)))
   AND ssr.qty_assigned > 0; 
   
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL ) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, NULL);
   END IF; 
   
   FOR rec_ IN get_handl_unit_ LOOP
      Scrap_Part_In_Ship_Inv__(info_                         => info_,
                               source_ref1_                  => rec_.source_ref1,
                               source_ref2_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref2, rec_.source_ref_type_db  ),
                               source_ref3_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref3, rec_.source_ref_type_db, 3),
                               source_ref4_                  => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref4, rec_.source_ref_type_db, 4),
                               source_ref_type_db_           => rec_.source_ref_type_db, 
                               contract_                     => rec_.contract, 
                               part_no_                      => rec_.part_no, 
                               location_no_                  => rec_.location_no, 
                               lot_batch_no_                 => rec_.lot_batch_no, 
                               serial_no_                    => rec_.serial_no, 
                               eng_chg_level_                => rec_.eng_chg_level, 
                               waiv_dev_rej_no_              => rec_.waiv_dev_rej_no, 
                               pick_list_no_                 => rec_.pick_list_no, 
                               activity_seq_                 => rec_.activity_seq, 
                               handling_unit_id_             => rec_.handling_unit_id, 
                               qty_to_scrap_                 => rec_.qty_picked, 
                               catch_qty_to_scrap_           => NULL, 
                               scrap_cause_                  => scrap_cause_, 
                               scrap_note_                   => scrap_note_, 
                               shipment_id_                  => rec_.shipment_id, 
                               discon_zero_stock_handl_unit_ => FALSE);
   END LOOP;
   
   Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_, NULL);
   Inventory_Event_Manager_API.Finish_Session;
END Scrap_HU_In_Ship_Inv__;

PROCEDURE Scrap_HU_In_Ship_Inv__(
   info_                  OUT VARCHAR2,  
   handling_unit_id_list_ IN  VARCHAR2,
   scrap_cause_           IN  VARCHAR2,
   scrap_note_            IN  VARCHAR2)
IS
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Handling_Unit_Id_Tab(handling_unit_id_list_);
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_Level_Sorted_Units(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         Scrap_HU_In_Ship_Inv__(info_                 => info_,
                                handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                scrap_cause_          => scrap_cause_,
                                scrap_note_           => scrap_note_);
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Scrap_HU_In_Ship_Inv__;

PROCEDURE Return_HU_From_Ship_Inv__(
   info_             OUT VARCHAR2,  
   handling_unit_id_ IN  NUMBER,
   to_contract_      IN  VARCHAR2,
   to_location_no_   IN  VARCHAR2,
   move_comment_     IN  VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_handl_unit IS
   SELECT            
         ssr.source_ref1,
         ssr.source_ref2,
         ssr.source_ref3,
         ssr.source_ref4,
         ssr.source_ref_type_db,
         ssr.contract,
         ssr.part_no,
         ssr.location_no,
         ssr.lot_batch_no,
         ssr.serial_no,
         ssr.eng_chg_level,
         ssr.waiv_dev_rej_no,
         ssr.pick_list_no,
         ssr.activity_seq,
         ssr.handling_unit_id,
         ssr.shipment_id,
         ssr.qty_picked
   FROM shipment_source_reservation ssr
   WHERE (ssr.handling_unit_id IN (SELECT hu.handling_unit_id 
                  FROM handling_unit hu
                  CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                  START WITH hu.handling_unit_id IN (handling_unit_id_)))
   AND ssr.qty_assigned > 0;
   
   shipment_id_ NUMBER;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   IF(Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, NULL);
   END IF;
   
   shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
   IF(shipment_id_ IS NOT NULL) THEN
      Shipment_Reserv_Handl_Unit_API.Remove_Without_Unpack(shipment_id_, handling_unit_id_);
      Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_, NULL);
   END IF;
   
   FOR rec_ IN get_handl_unit LOOP
      Return_From_Ship_Inv__(info_                          => info_,
                             source_ref1_                   => rec_.source_ref1,
                             source_ref2_                   => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref2,rec_.source_ref_type_db  ),
                             source_ref3_                   => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref3,rec_.source_ref_type_db, 3),
                             source_ref4_                   => Shipment_Line_API.Get_Converted_Source_Ref(rec_.source_ref4,rec_.source_ref_type_db, 4),
                             source_ref_type_db_            => rec_.source_ref_type_db,
                             from_contract_                 => rec_.contract,
                             part_no_                       => rec_.part_no,
                             from_location_no_              => rec_.location_no,
                             lot_batch_no_                  => rec_.lot_batch_no,
                             serial_no_                     => rec_.serial_no,
                             eng_chg_level_                 => rec_.eng_chg_level,
                             waiv_dev_rej_no_               => rec_.waiv_dev_rej_no,
                             pick_list_no_                  => rec_.pick_list_no,
                             activity_seq_                  => rec_.activity_seq,
                             handling_unit_id_              => rec_.handling_unit_id,
                             to_contract_                   => to_contract_,
                             to_location_no_                => to_location_no_,
                             qty_returned_                  => rec_.qty_picked,
                             catch_qty_returned_            => NULL,
                             shipment_id_                   => rec_.shipment_id,
                             move_comment_                  => move_comment_,
                             return_handling_unit_          => TRUE);
   END LOOP;
   
   Inventory_Event_Manager_API.Finish_Session;
END Return_HU_From_Ship_Inv__;

PROCEDURE Return_HU_From_Ship_Inv__(
   info_                  OUT VARCHAR2,  
   handling_unit_id_list_ IN  VARCHAR2,
   to_contract_           IN  VARCHAR2,
   to_location_no_        IN  VARCHAR2,
   move_comment_          IN  VARCHAR2 DEFAULT NULL )
IS
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Handling_Unit_Id_Tab(handling_unit_id_list_);
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_Level_Sorted_Units(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         Return_HU_From_Ship_Inv__(info_                 => info_,
                                   handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                   to_contract_          => to_contract_,
                                   to_location_no_       => to_location_no_,
                                   move_comment_         => move_comment_);
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Return_HU_From_Ship_Inv__;

-- Move_Between_Ship_Inv__
--   Move a part between shipment inventories
PROCEDURE Move_Between_Ship_Inv__ (
   info_                        OUT VARCHAR2,  
   source_ref1_                 IN  VARCHAR2,
   source_ref2_                 IN  VARCHAR2,
   source_ref3_                 IN  VARCHAR2,
   source_ref4_                 IN  VARCHAR2,
   source_ref_type_db_          IN  VARCHAR2,
   from_contract_               IN  VARCHAR2,
   part_no_                     IN  VARCHAR2,
   from_location_no_            IN  VARCHAR2,
   lot_batch_no_                IN  VARCHAR2,
   serial_no_                   IN  VARCHAR2,
   eng_chg_level_               IN  VARCHAR2,
   waiv_dev_rej_no_             IN  VARCHAR2,
   pick_list_no_                IN  VARCHAR2,
   activity_seq_                IN  NUMBER,
   handling_unit_id_            IN  NUMBER,
   to_contract_                 IN  VARCHAR2,
   to_location_no_              IN  VARCHAR2,
   qty_to_move_                 IN  NUMBER,
   catch_qty_to_move_           IN  NUMBER,
   shipment_id_                 IN  NUMBER,
   move_comment_                IN  VARCHAR2 DEFAULT NULL,
   validate_hu_struct_position_ IN  BOOLEAN  DEFAULT TRUE )
IS
   location_type_db_              VARCHAR2(20);
   expiration_date_               DATE;
   qty_picked_                    NUMBER;
   qty_assigned_                  NUMBER;
   qty_shipped_                   NUMBER;
   remove_ord_line_               BOOLEAN;
   configuration_id_              VARCHAR2(50);
   catch_quantity_                NUMBER;
   to_delnote_no_                 VARCHAR2(15);
   unattached_from_handling_unit_ VARCHAR2(5);
   to_handling_unit_id_           NUMBER;
   from_loc_qty_assigned_         NUMBER:=0;
   from_loc_qty_picked_           NUMBER:=0;
   from_loc_catch_qty_            NUMBER:=0; 
   from_loc_qty_shipped_          NUMBER:=0;
   to_loc_qty_assigned_           NUMBER:=0;
   to_loc_qty_picked_             NUMBER:=0;
   to_loc_catch_qty_              NUMBER:=0;
   from_public_res_rec_           Reserve_Shipment_API.Public_Reservation_Rec;
   to_public_res_rec_             Reserve_Shipment_API.Public_Reservation_Rec;
   inv_trans_source_ref_type_     VARCHAR2(50);
   shipment_line_no_              NUMBER;
   handling_unit_tab_             Shipment_Reserv_Handl_Unit_API.Reserv_Handl_Unit_Qty_Tab;
   shipment_rec_                  Shipment_API.Public_Rec;
   sender_type_                   VARCHAR2(20);
   sender_id_                     VARCHAR2(50);
   converted_source_ref2_ shipment_line_tab.source_ref2%TYPE;
   converted_source_ref3_ shipment_line_tab.source_ref3%TYPE;
   converted_source_ref4_ shipment_line_tab.source_ref4%TYPE;
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      Error_SYS.Record_General(lu_name_, 'MOVEPARTSNOTALLOWED: Moving of parts is restricted for shipments created for :P1.', Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_));
   END IF; 
   converted_source_ref2_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2);
   converted_source_ref3_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3);
   converted_source_ref4_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4);
   location_type_db_  := Inventory_Location_API.Get_Location_Type_Db(to_contract_, to_location_no_);
   configuration_id_  := Shipment_Source_Utility_API.Get_Configuration_id(source_ref1_, converted_source_ref2_, converted_source_ref3_,
                                                                          converted_source_ref4_, source_ref_type_db_);
   catch_quantity_    := catch_qty_to_move_;
   
   --To_Do_Lime
   --Lock___(order_no_);
   
   -- Check that to_location is a Shipment Location.
   IF (location_type_db_ = 'SHIPMENT') THEN
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         shipment_rec_ := Shipment_API.Get(shipment_id_);
         sender_type_  := shipment_rec_.sender_type;
         sender_id_    := shipment_rec_.sender_id;
      ELSE
         sender_type_  := Sender_Receiver_Type_API.DB_SITE;
         sender_id_    := from_contract_;
      END IF;
      Validate_Sender_Location(from_contract_, to_location_no_, sender_type_, sender_id_);
      
      -- Reduce assigned quantity with the moved quantity.                                                 
      from_public_res_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                               source_ref2_            => converted_source_ref2_, 
                                                                               source_ref3_            => converted_source_ref3_,
                                                                               source_ref4_            => converted_source_ref4_, 
                                                                               source_ref_type_db_     => source_ref_type_db_,
                                                                               contract_               => from_contract_, 
                                                                               part_no_                => part_no_, 
                                                                               location_no_            => from_location_no_, 
                                                                               lot_batch_no_           => lot_batch_no_, 
                                                                               serial_no_              => serial_no_,
                                                                               eng_chg_level_          => eng_chg_level_, 
                                                                               waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                               activity_seq_           => activity_seq_, 
                                                                               handling_unit_id_       => handling_unit_id_,
                                                                               pick_list_no_           => pick_list_no_, 
                                                                               configuration_id_       => configuration_id_,
                                                                               shipment_id_            => shipment_id_);                                                  
      
      from_loc_qty_assigned_ := from_public_res_rec_.qty_assigned;
      from_loc_qty_picked_   := from_public_res_rec_.qty_picked;
      from_loc_catch_qty_    := from_public_res_rec_.catch_qty;
      from_loc_qty_shipped_  := from_public_res_rec_.qty_shipped;
      
      -- Added a check to raise an error if the quantitiy to move is greater than the assigned quantitiy
      Validate_Qty_To_Move(qty_to_move_, from_loc_qty_assigned_);
      
      remove_ord_line_ := (from_loc_qty_assigned_ - qty_to_move_ = 0);
      
      -- Get the correct expiration date.
      expiration_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_          => from_contract_, 
                                                                          part_no_           => part_no_, 
                                                                          configuration_id_  => configuration_id_, 
                                                                          location_no_       => from_location_no_, 
                                                                          lot_batch_no_      => lot_batch_no_,
                                                                          serial_no_         => serial_no_, 
                                                                          eng_chg_level_     => eng_chg_level_, 
                                                                          waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                                                          activity_seq_      => activity_seq_, 
                                                                          handling_unit_id_  => handling_unit_id_);
      
      Inventory_Event_Manager_API.Start_Session;
      
      inv_trans_source_ref_type_ := Get_Inv_Trans_Src_Ref_Type(source_ref_type_db_);
      Inventory_Part_In_Stock_API.Move_Part_Shipment(unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                                     catch_quantity_                => catch_quantity_, 
                                                     contract_                      => from_contract_,
                                                     part_no_                       => part_no_, 
                                                     configuration_id_              => configuration_id_, 
                                                     location_no_                   => from_location_no_,
                                                     lot_batch_no_                  => lot_batch_no_, 
                                                     serial_no_                     => serial_no_, 
                                                     eng_chg_level_                 => eng_chg_level_, 
                                                     waiv_dev_rej_no_               => waiv_dev_rej_no_, 
                                                     activity_seq_                  => activity_seq_,
                                                     handling_unit_id_              => handling_unit_id_,
                                                     expiration_date_               => expiration_date_, 
                                                     to_contract_                   => to_contract_, 
                                                     to_location_no_                => to_location_no_, 
                                                     quantity_                      => qty_to_move_,
                                                     quantity_reserved_             => qty_to_move_, 
                                                     move_comment_                  => move_comment_,
                                                     order_no_                      => source_ref1_,
                                                     line_no_                       => converted_source_ref2_, 
                                                     release_no_                    => converted_source_ref3_, 
                                                     line_item_no_                  => converted_source_ref4_,
                                                     source_ref5_                   => shipment_id_,
                                                     order_type_                    => inv_trans_source_ref_type_,
                                                     validate_hu_struct_position_   => validate_hu_struct_position_);
      
      to_handling_unit_id_ := CASE unattached_from_handling_unit_ WHEN Fnd_Boolean_API.DB_TRUE THEN 0 ELSE handling_unit_id_ END; 
      IF (unattached_from_handling_unit_ = 'TRUE') THEN
         Client_SYS.Add_Info(lu_name_, 'MOVEHUUNATTACH: One or more records were unattached from a Handling Unit.');
      END IF;
      
      IF (shipment_id_ != 0 AND handling_unit_id_ != 0) THEN
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, converted_source_ref2_, converted_source_ref3_, converted_source_ref4_,
                                                                             source_ref_type_db_ );
         
         IF (unattached_from_handling_unit_ = 'FALSE') THEN
            -- If the content is still in its handling unit we want to keep the ShipmentReservHandlUnit-records and
            -- so that we can create the same records at the new location.
            handling_unit_tab_ := Shipment_Reserv_Handl_Unit_API.Get_Handling_Units(source_ref1_               => source_ref1_,
                                                                                    source_ref2_               => NVL(converted_source_ref2_,'*'),
                                                                                    source_ref3_               => NVL(converted_source_ref3_,'*'),
                                                                                    source_ref4_               => NVL(converted_source_ref4_,'*'),                                                                                  
                                                                                    contract_                  => from_contract_, 
                                                                                    part_no_                   => part_no_, 
                                                                                    location_no_               => from_location_no_, 
                                                                                    lot_batch_no_              => lot_batch_no_, 
                                                                                    serial_no_                 => serial_no_, 
                                                                                    eng_chg_level_             => eng_chg_level_,
                                                                                    waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                                                    activity_seq_              => activity_seq_, 
                                                                                    reserv_handling_unit_id_   => handling_unit_id_,
                                                                                    configuration_id_          => configuration_id_, 
                                                                                    pick_list_no_              => pick_list_no_, 
                                                                                    shipment_id_               => shipment_id_,
                                                                                    shipment_line_no_          => shipment_line_no_,
                                                                                    handling_unit_id_          => handling_unit_id_ );
         END IF;         
         -- We don't want the modification of the reservation to cause things to be unpacked if it is in it's handling unit.
         Shipment_Reserv_Handl_Unit_API.Remove_Without_Unpack(source_ref1_               => source_ref1_,
                                                              source_ref2_               => NVL(converted_source_ref2_,'*'),
                                                              source_ref3_               => NVL(converted_source_ref3_,'*'),
                                                              source_ref4_               => NVL(converted_source_ref4_,'*'),                                                                                 
                                                              contract_                  => from_contract_, 
                                                              part_no_                   => part_no_, 
                                                              location_no_               => from_location_no_, 
                                                              lot_batch_no_              => lot_batch_no_, 
                                                              serial_no_                 => serial_no_, 
                                                              eng_chg_level_             => eng_chg_level_,
                                                              waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                              activity_seq_              => activity_seq_, 
                                                              reserv_handling_unit_id_   => handling_unit_id_,
                                                              configuration_id_          => configuration_id_, 
                                                              pick_list_no_              => pick_list_no_, 
                                                              shipment_id_               => shipment_id_,
                                                              shipment_line_no_          => shipment_line_no_,
                                                              quantity_                  => qty_to_move_);
      END IF;
      
      -- Reserve at new location
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_    => catch_quantity_, 
                                               contract_          => to_contract_, 
                                               part_no_           => part_no_, 
                                               configuration_id_  => configuration_id_, 
                                               location_no_       => to_location_no_,
                                               lot_batch_no_      => lot_batch_no_, 
                                               serial_no_         => serial_no_, 
                                               eng_chg_level_     => eng_chg_level_, 
                                               waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                               activity_seq_      => activity_seq_, 
                                               handling_unit_id_  => to_handling_unit_id_,
                                               quantity_          => qty_to_move_);
      
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
         Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => from_contract_,       
                                                                     part_no_              => part_no_    ,
                                                                     configuration_id_     => configuration_id_  ,
                                                                     location_no_          => from_location_no_,
                                                                     lot_batch_no_         => lot_batch_no_,
                                                                     serial_no_            => serial_no_,
                                                                     eng_chg_level_        => eng_chg_level_,
                                                                     waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                     activity_seq_         => activity_seq_,
                                                                     handling_unit_id_     => handling_unit_id_,
                                                                     pick_list_no_         => pick_list_no_,
                                                                     qty_picked_           => - (qty_to_move_),  
                                                                     catch_qty_picked_     => - (catch_qty_to_move_),
                                                                     source_ref_type_db_   => source_ref_type_db_,
                                                                     source_ref1_          => source_ref1_, 
                                                                     source_ref2_          => NVL(converted_source_ref2_,'*'),
                                                                     source_ref3_          => NVL(converted_source_ref3_,'*'),
                                                                     source_ref4_          => NVL(converted_source_ref4_,'*'),
                                                                     shipment_id_          => shipment_id_,        
                                                                     reserve_in_inventory_ => FALSE );
      ELSE
         Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_            => source_ref1_, 
                                                                   source_ref2_            => converted_source_ref2_, 
                                                                   source_ref3_            => converted_source_ref3_, 
                                                                   source_ref4_            => converted_source_ref4_,
                                                                   source_ref_type_db_     => source_ref_type_db_,
                                                                   contract_               => from_contract_, 
                                                                   part_no_                => part_no_, 
                                                                   location_no_            => from_location_no_,
                                                                   lot_batch_no_           => lot_batch_no_, 
                                                                   serial_no_              => serial_no_, 
                                                                   eng_chg_level_          => eng_chg_level_, 
                                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                                   activity_seq_           => activity_seq_, 
                                                                   handling_unit_id_       => handling_unit_id_,
                                                                   pick_list_no_           => pick_list_no_, 
                                                                   configuration_id_       => configuration_id_,
                                                                   shipment_id_            => shipment_id_, 
                                                                   remaining_qty_assigned_ => NULL,
                                                                   qty_picked_             => from_loc_qty_picked_ - qty_to_move_,
                                                                   catch_qty_              => from_loc_catch_qty_  - catch_qty_to_move_,
                                                                   input_qty_              => NULL,
                                                                   input_unit_meas_        => NULL,           
                                                                   input_conv_factor_      => NULL,              
                                                                   input_variable_values_  => NULL,
                                                                   move_to_ship_location_  => 'FALSE');
      END IF;
      info_ := Client_SYS.Get_All_Info;
      
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
         Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => to_contract_,       
                                                                     part_no_              => part_no_    ,
                                                                     configuration_id_     => configuration_id_  ,
                                                                     location_no_          => to_location_no_,
                                                                     lot_batch_no_         => lot_batch_no_,
                                                                     serial_no_            => serial_no_,
                                                                     eng_chg_level_        => eng_chg_level_,
                                                                     waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                     activity_seq_         => activity_seq_,
                                                                     handling_unit_id_     => to_handling_unit_id_,
                                                                     pick_list_no_         => pick_list_no_,
                                                                     qty_picked_           => qty_to_move_,  
                                                                     catch_qty_picked_     => catch_qty_to_move_,
                                                                     source_ref_type_db_   => source_ref_type_db_,
                                                                     source_ref1_          => source_ref1_, 
                                                                     source_ref2_          => NVL(converted_source_ref2_,'*'),
                                                                     source_ref3_          => NVL(converted_source_ref3_,'*'),
                                                                     source_ref4_          => NVL(converted_source_ref4_,'*'),
                                                                     shipment_id_          => shipment_id_,        
                                                                     reserve_in_inventory_ => FALSE );
      ELSE                                                               
         -- If a reservation already exists in the Shipment Location to move to, then increase assigned
         -- quantity, picked quantity and picked catch quantity with the moved qty.
         IF (Shipment_Source_Utility_API.Reservation_Exists(source_ref1_        => source_ref1_, 
                                                            source_ref2_        => converted_source_ref2_, 
                                                            source_ref3_        => converted_source_ref3_, 
                                                            source_ref4_        => converted_source_ref4_, 
                                                            source_ref_type_db_ => source_ref_type_db_,
                                                            contract_           => to_contract_,
                                                            part_no_            => part_no_,
                                                            location_no_        => to_location_no_, 
                                                            lot_batch_no_       => lot_batch_no_,
                                                            serial_no_          => serial_no_,
                                                            eng_chg_level_      => eng_chg_level_,
                                                            waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                            activity_seq_       => activity_seq_, 
                                                            handling_unit_id_   => to_handling_unit_id_,
                                                            configuration_id_   => configuration_id_, 
                                                            pick_list_no_       => pick_list_no_, 
                                                            shipment_id_        => shipment_id_) = 'TRUE') THEN
            
            to_public_res_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                                   source_ref2_            => converted_source_ref2_, 
                                                                                   source_ref3_            => converted_source_ref3_,
                                                                                   source_ref4_            => converted_source_ref4_, 
                                                                                   source_ref_type_db_     => source_ref_type_db_,
                                                                                   contract_               => to_contract_, 
                                                                                   part_no_                => part_no_,
                                                                                   location_no_            => to_location_no_, 
                                                                                   lot_batch_no_           => lot_batch_no_, 
                                                                                   serial_no_              => serial_no_, 
                                                                                   eng_chg_level_          => eng_chg_level_,
                                                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                   activity_seq_           => activity_seq_, 
                                                                                   handling_unit_id_       => to_handling_unit_id_,
                                                                                   pick_list_no_           => pick_list_no_, 
                                                                                   configuration_id_       => configuration_id_, 
                                                                                   shipment_id_            => shipment_id_);
            
            to_loc_qty_assigned_ := to_public_res_rec_.qty_assigned;
            to_loc_qty_picked_   := to_public_res_rec_.qty_picked;
            to_loc_catch_qty_    := to_public_res_rec_.catch_qty;
            
            Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_            => source_ref1_, 
                                                                      source_ref2_            => converted_source_ref2_, 
                                                                      source_ref3_            => converted_source_ref3_, 
                                                                      source_ref4_            => converted_source_ref4_,
                                                                      source_ref_type_db_     => source_ref_type_db_,
                                                                      contract_               => to_contract_, 
                                                                      part_no_                => part_no_, 
                                                                      location_no_            => to_location_no_,
                                                                      lot_batch_no_           => lot_batch_no_, 
                                                                      serial_no_              => serial_no_, 
                                                                      eng_chg_level_          => eng_chg_level_, 
                                                                      waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                                      activity_seq_           => activity_seq_, 
                                                                      handling_unit_id_       => to_handling_unit_id_,
                                                                      pick_list_no_           => pick_list_no_, 
                                                                      configuration_id_       => configuration_id_,
                                                                      shipment_id_            => shipment_id_,  
                                                                      remaining_qty_assigned_ => NULL,
                                                                      qty_picked_             => to_loc_qty_picked_ + qty_to_move_,
                                                                      catch_qty_              => to_loc_catch_qty_ + catch_qty_to_move_,
                                                                      input_qty_              => NULL,
                                                                      input_unit_meas_        => NULL,           
                                                                      input_conv_factor_      => NULL,              
                                                                      input_variable_values_  => NULL,
                                                                      move_to_ship_location_  => 'FALSE');
         ELSE
            -- If a reservation does not exist, then move the parts and make
            -- a new reservation at the Shipment Location.
            qty_picked_   := qty_to_move_ ;
            qty_assigned_ := qty_to_move_ ;
            qty_shipped_  := 0 ;
            
            Shipment_Source_Utility_API.New_Reservation(source_ref1_              => source_ref1_, 
                                                        source_ref2_              => converted_source_ref2_,
                                                        source_ref3_              => converted_source_ref3_,
                                                        source_ref4_              => converted_source_ref4_,
                                                        source_ref_type_db_       => source_ref_type_db_,
                                                        contract_                 => to_contract_, 
                                                        part_no_                  => part_no_, 
                                                        location_no_              => to_location_no_, 
                                                        lot_batch_no_             => lot_batch_no_, 
                                                        serial_no_                => serial_no_,
                                                        eng_chg_level_            => eng_chg_level_, 
                                                        waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                        activity_seq_             => activity_seq_, 
                                                        handling_unit_id_         => to_handling_unit_id_,
                                                        pick_list_no_             => pick_list_no_, 
                                                        preliminary_pick_list_no_ => from_public_res_rec_.preliminary_pick_list_no,
                                                        configuration_id_         => configuration_id_, 
                                                        new_shipment_id_          => shipment_id_,
                                                        qty_assigned_             => qty_assigned_, 
                                                        qty_picked_               => qty_picked_, 
                                                        catch_qty_                => catch_quantity_,
                                                        qty_shipped_              => 0,
                                                        input_qty_                => NULL,
                                                        input_unit_meas_          => NULL,
                                                        input_conv_factor_        => NULL,
                                                        input_variable_values_    => NULL,
                                                        reassignment_type_        => NULL );
         END IF;
         
         IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
            IF (from_public_res_rec_.delnote_no IS NOT NULL) THEN
               Delivery_Note_API.Set_Invalid(from_public_res_rec_.delnote_no);
            END IF;
            $IF Component_Order_SYS.INSTALLED $THEN
               to_delnote_no_ := Deliver_Customer_Order_API.Find_Pre_Ship_Delivery_Note(source_ref1_, to_location_no_);
               IF to_delnote_no_ IS NOT NULL THEN
                  Delivery_Note_API.Set_Invalid(to_delnote_no_);
               END IF;
            $END
         END IF;
         
      END IF;
      
      IF (shipment_id_ != 0) AND (handling_unit_tab_.COUNT > 0) THEN
         Shipment_Reserv_Handl_Unit_API.Add_Handling_Units(source_ref1_             => source_ref1_,
                                                           source_ref2_             => NVL(converted_source_ref2_,'*'),
                                                           source_ref3_             => NVL(converted_source_ref3_,'*'),
                                                           source_ref4_             => NVL(converted_source_ref4_,'*'),                                                           
                                                           contract_                => to_contract_, 
                                                           part_no_                 => part_no_, 
                                                           location_no_             => to_location_no_, 
                                                           lot_batch_no_            => lot_batch_no_, 
                                                           serial_no_               => serial_no_, 
                                                           eng_chg_level_           => eng_chg_level_,
                                                           waiv_dev_rej_no_         => waiv_dev_rej_no_, 
                                                           activity_seq_            => activity_seq_, 
                                                           reserv_handling_unit_id_ => to_handling_unit_id_,
                                                           configuration_id_        => configuration_id_, 
                                                           pick_list_no_            => pick_list_no_, 
                                                           shipment_id_             => shipment_id_,
                                                           shipment_line_no_        => shipment_line_no_,
                                                           handling_unit_tab_       => handling_unit_tab_);                                                  
      END IF;
      
      IF (remove_ord_line_ AND (from_loc_qty_shipped_ = 0)) THEN
         Shipment_Source_Utility_API.Remove_Reservation(source_ref1_           => source_ref1_, 
                                                        source_ref2_           => converted_source_ref2_, 
                                                        source_ref3_           => converted_source_ref3_, 
                                                        source_ref4_           => converted_source_ref4_,
                                                        source_ref_type_db_    => source_ref_type_db_,
                                                        contract_              => from_contract_, 
                                                        part_no_               => part_no_, 
                                                        location_no_           => from_location_no_, 
                                                        lot_batch_no_          => lot_batch_no_, 
                                                        serial_no_             => serial_no_,
                                                        eng_chg_level_         => eng_chg_level_, 
                                                        waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                        activity_seq_          => activity_seq_, 
                                                        handling_unit_id_      => handling_unit_id_,
                                                        pick_list_no_          => pick_list_no_, 
                                                        configuration_id_      => configuration_id_, 
                                                        shipment_id_           => shipment_id_,
                                                        reassignment_type_     => NULL ,
                                                        move_to_ship_location_ => 'FALSE' );         
      END IF;
      
      Inventory_Event_Manager_API.Finish_Session;
      info_ := info_ || Client_SYS.Get_All_Info; 
   ELSE
      Raise_Not_A_Shipment_Location;
   END IF;
END Move_Between_Ship_Inv__;

-- Return_From_Ship_Inv__
--   Return a part from shipment location to a Picking location.
PROCEDURE Return_From_Ship_Inv__ (
   info_                 OUT VARCHAR2,                                
   source_ref1_          IN  VARCHAR2,
   source_ref2_          IN  VARCHAR2,
   source_ref3_          IN  VARCHAR2,
   source_ref4_          IN  VARCHAR2,
   source_ref_type_db_   IN  VARCHAR2,
   from_contract_        IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   from_location_no_     IN  VARCHAR2,
   lot_batch_no_         IN  VARCHAR2,
   serial_no_            IN  VARCHAR2,
   eng_chg_level_        IN  VARCHAR2,
   waiv_dev_rej_no_      IN  VARCHAR2,
   pick_list_no_         IN  VARCHAR2,
   activity_seq_         IN  NUMBER,
   handling_unit_id_     IN  NUMBER,
   to_contract_          IN  VARCHAR2,
   to_location_no_       IN  VARCHAR2,
   qty_returned_         IN  NUMBER,
   catch_qty_returned_   IN  NUMBER,
   shipment_id_          IN  NUMBER,
   move_comment_         IN  VARCHAR2 DEFAULT NULL,
   return_handling_unit_ IN  BOOLEAN  DEFAULT FALSE )
IS
   location_type_db_              VARCHAR2(20);
   expiration_date_               DATE;
   temp_assigned_                 NUMBER;
   catch_quantity_returned_       NUMBER;
   unattached_from_handling_unit_ VARCHAR2(5);
   public_reservation_rec_        Reserve_Shipment_API.Public_Reservation_Rec;
   inv_trans_source_ref_type_     VARCHAR2(50);
   part_cat_rec_                  Part_Catalog_API.Public_Rec;
   configuration_id_              VARCHAR2(50);
   local_handling_unit_id_        NUMBER;
   catch_quantity_                NUMBER;
   source_ref_demand_code_        VARCHAR2(20);
   converted_source_ref2_ shipment_line_tab.source_ref2%TYPE;
   converted_source_ref3_ shipment_line_tab.source_ref3%TYPE;
   converted_source_ref4_ shipment_line_tab.source_ref4%TYPE;
BEGIN
   converted_source_ref2_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2);
   converted_source_ref3_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3);
   converted_source_ref4_ := Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4);
   location_type_db_        := Inventory_Location_API.Get_Location_Type_Db(to_contract_, to_location_no_);
   configuration_id_        := Shipment_Source_Utility_API.Get_Configuration_id(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   catch_quantity_returned_ := catch_qty_returned_;
   local_handling_unit_id_  := handling_unit_id_;   
   
   --To_Do_Lime
   --Lock___(order_no_);
   
   IF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         source_ref_demand_code_ := Shipment_Order_Line_API.Get_Demand_Code_Db(source_ref1_, source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   END IF;
   
   -- Check If to_location is a picking location or If source ref type is Purchase Receipt Return then allow for QA and ARRIVAL locations.
   IF (location_type_db_ IN ('PICKING','F','MANUFACTURING') 
         AND NOT (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER AND NVL(source_ref_demand_code_, string_null_) = Order_Supply_Type_API.DB_PURCHASE_RECEIPT)
         AND NOT (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)
      OR (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN AND location_type_db_ IN ('PICKING', 'QA', 'ARRIVAL'))
      OR (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER AND NVL(source_ref_demand_code_, string_null_) = Order_Supply_Type_API.DB_PURCHASE_RECEIPT
         AND location_type_db_ IN ('QA', 'ARRIVAL'))) THEN
      -- Reduce picked quantity with the returned quantity in Customer Order Reservation.
      public_reservation_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => source_ref1_, 
                                                                                  source_ref2_            => converted_source_ref2_, 
                                                                                  source_ref3_            => converted_source_ref3_,
                                                                                  source_ref4_            => converted_source_ref4_, 
                                                                                  source_ref_type_db_     => source_ref_type_db_,
                                                                                  contract_               => from_contract_, 
                                                                                  part_no_                => part_no_, 
                                                                                  location_no_            => from_location_no_, 
                                                                                  lot_batch_no_           => lot_batch_no_, 
                                                                                  serial_no_              => serial_no_,
                                                                                  eng_chg_level_          => eng_chg_level_, 
                                                                                  waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                  activity_seq_           => activity_seq_, 
                                                                                  handling_unit_id_       => local_handling_unit_id_,
                                                                                  pick_list_no_           => pick_list_no_, 
                                                                                  configuration_id_       => configuration_id_, 
                                                                                  shipment_id_            => shipment_id_);
      
      -- Added a check to raise an error message if the quantity to return is greater than the quantity assigned.
      Validate_Qty_To_Return(qty_returned_, public_reservation_rec_.qty_assigned);
      
      Shipment_Source_Utility_API.Validate_Return_From_Ship_Inv(source_ref1_,
                                                                converted_source_ref2_,
                                                                converted_source_ref3_,
                                                                converted_source_ref4_,
                                                                source_ref_type_db_,
                                                                lot_batch_no_,
                                                                serial_no_,
                                                                qty_returned_);
      
      Inventory_Event_Manager_API.Start_Session;
      
      -- In order to properly unpack the contents of the handling unit via the modification of the reservation
      -- we manually need to unreserve it in inventory followed by a reservation after having done the modification.
      IF(shipment_id_ != 0 AND local_handling_unit_id_ != 0 AND NOT return_handling_unit_) THEN
         Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_, 
                                                  from_contract_, 
                                                  part_no_, 
                                                  configuration_id_, 
                                                  from_location_no_, 
                                                  lot_batch_no_, 
                                                  serial_no_, 
                                                  eng_chg_level_, 
                                                  waiv_dev_rej_no_, 
                                                  activity_seq_, 
                                                  local_handling_unit_id_, 
                                                  -qty_returned_);        
      END IF;                                                        
      
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN                                                                
         Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => from_contract_,       
                                                                     part_no_              => part_no_    ,
                                                                     configuration_id_     => configuration_id_  ,
                                                                     location_no_          => from_location_no_,
                                                                     lot_batch_no_         => lot_batch_no_,
                                                                     serial_no_            => serial_no_,
                                                                     eng_chg_level_        => eng_chg_level_,
                                                                     waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                     activity_seq_         => activity_seq_,
                                                                     handling_unit_id_     => local_handling_unit_id_,
                                                                     pick_list_no_         => pick_list_no_,
                                                                     qty_picked_           => - (qty_returned_),  
                                                                     catch_qty_picked_     => - (catch_qty_returned_),
                                                                     source_ref_type_db_   => source_ref_type_db_,
                                                                     source_ref1_          => source_ref1_, 
                                                                     source_ref2_          => NVL(converted_source_ref2_, '*'),
                                                                     source_ref3_          => NVL(converted_source_ref3_, '*'),
                                                                     source_ref4_          => NVL(converted_source_ref4_, '*'),
                                                                     shipment_id_          => shipment_id_,        
                                                                     reserve_in_inventory_ => FALSE );
      ELSE   
         Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_            => source_ref1_, 
                                                                   source_ref2_            => converted_source_ref2_, 
                                                                   source_ref3_            => converted_source_ref3_, 
                                                                   source_ref4_            => converted_source_ref4_,
                                                                   source_ref_type_db_     => source_ref_type_db_,
                                                                   contract_               => from_contract_, 
                                                                   part_no_                => part_no_, 
                                                                   location_no_            => from_location_no_,
                                                                   lot_batch_no_           => lot_batch_no_, 
                                                                   serial_no_              => serial_no_, 
                                                                   eng_chg_level_          => eng_chg_level_, 
                                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                                   activity_seq_           => activity_seq_, 
                                                                   handling_unit_id_       => local_handling_unit_id_,
                                                                   pick_list_no_           => pick_list_no_, 
                                                                   configuration_id_       => configuration_id_,
                                                                   shipment_id_            => shipment_id_,  
                                                                   remaining_qty_assigned_ => NULL,
                                                                   qty_picked_             => public_reservation_rec_.qty_picked - qty_returned_,
                                                                   catch_qty_              => public_reservation_rec_.catch_qty  - catch_qty_returned_, 
                                                                   input_qty_              => NULL,
                                                                   input_unit_meas_        => NULL,           
                                                                   input_conv_factor_      => NULL,              
                                                                   input_variable_values_  => NULL,
                                                                   move_to_ship_location_  => 'FALSE');                                                 
         
         IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
            IF (public_reservation_rec_.delnote_no IS NOT NULL) THEN
               Delivery_Note_API.Set_Invalid(public_reservation_rec_.delnote_no);
            END IF;
         END IF;
         
         -- Reduce assigned quantity with the returned quantity in Customer Order Reservation.
         temp_assigned_ := public_reservation_rec_.qty_assigned - qty_returned_;
         
         IF (temp_assigned_ = 0) AND (public_reservation_rec_.qty_shipped = 0) THEN                                        
            Shipment_Source_Utility_API.Remove_Reservation(source_ref1_           => source_ref1_, 
                                                           source_ref2_           => converted_source_ref2_, 
                                                           source_ref3_           => converted_source_ref3_, 
                                                           source_ref4_           => converted_source_ref4_,
                                                           source_ref_type_db_    => source_ref_type_db_,
                                                           contract_              => from_contract_, 
                                                           part_no_               => part_no_, 
                                                           location_no_           => from_location_no_, 
                                                           lot_batch_no_          => lot_batch_no_, 
                                                           serial_no_             => serial_no_,
                                                           eng_chg_level_         => eng_chg_level_, 
                                                           waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                           activity_seq_          => activity_seq_, 
                                                           handling_unit_id_      => local_handling_unit_id_,
                                                           pick_list_no_          => pick_list_no_, 
                                                           configuration_id_      => configuration_id_, 
                                                           shipment_id_           => shipment_id_,
                                                           reassignment_type_     => NULL,
                                                           move_to_ship_location_ => 'FALSE');                                               
         END IF;
      END IF;
      
      -- When modifying/removing the reservation, the stock gets unpacked from the handling unit, 
      -- the handling unit will still remain attached to the shipment. But the contents are now 
      -- outside of the handling unit and need to be reserved again.
      IF(shipment_id_ != 0 AND local_handling_unit_id_ != 0 AND NOT return_handling_unit_) THEN
         local_handling_unit_id_ := 0;
         Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_,
                                                  from_contract_, 
                                                  part_no_, 
                                                  configuration_id_, 
                                                  from_location_no_, 
                                                  lot_batch_no_, 
                                                  serial_no_, 
                                                  eng_chg_level_, 
                                                  waiv_dev_rej_no_, 
                                                  activity_seq_, 
                                                  local_handling_unit_id_, 
                                                  qty_returned_);     
      END IF; 
      
      info_ := Client_SYS.Get_All_Info; 
      
      part_cat_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_cat_rec_.catch_unit_enabled = db_true_) THEN
         -- calculate and update the new price conv factor based on the catch quantities for catch unit handled parts.
         Shipment_Source_Utility_API.Recalc_Catch_Price_Conv_Factor(source_ref1_, converted_source_ref2_, converted_source_ref3_, converted_source_ref4_, source_ref_type_db_);
      END IF; 
      
      -- Get the correct expiration date.
      expiration_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_         => from_contract_,
                                                                          part_no_          => part_no_,
                                                                          configuration_id_ => configuration_id_, 
                                                                          location_no_      => from_location_no_,
                                                                          lot_batch_no_     => lot_batch_no_,     
                                                                          serial_no_        => serial_no_,
                                                                          eng_chg_level_    => eng_chg_level_,    
                                                                          waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                          activity_seq_     => activity_seq_,  
                                                                          handling_unit_id_ => local_handling_unit_id_);
      
      inv_trans_source_ref_type_ := Get_Inv_Trans_Src_Ref_Type(source_ref_type_db_);
      
      Inventory_Part_In_Stock_API.Move_Part_Shipment(unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                                     catch_quantity_                => catch_quantity_returned_, 
                                                     contract_                      => from_contract_,    
                                                     part_no_                       => part_no_,
                                                     configuration_id_              => configuration_id_,        
                                                     location_no_                   => from_location_no_, 
                                                     lot_batch_no_                  => lot_batch_no_,
                                                     serial_no_                     => serial_no_,               
                                                     eng_chg_level_                 => eng_chg_level_,    
                                                     waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                                     activity_seq_                  => activity_seq_,  
                                                     handling_unit_id_              => local_handling_unit_id_,
                                                     expiration_date_               => expiration_date_,  
                                                     to_contract_                   => to_contract_,
                                                     to_location_no_                => to_location_no_,         
                                                     quantity_                      => qty_returned_,     
                                                     quantity_reserved_             => qty_returned_,
                                                     move_comment_                  => move_comment_,
                                                     order_no_                      => source_ref1_,               
                                                     line_no_                       => converted_source_ref2_,          
                                                     release_no_                    => converted_source_ref3_,
                                                     line_item_no_                  => converted_source_ref4_,
                                                     source_ref5_                   => shipment_id_,                                                     
                                                     order_type_                    => inv_trans_source_ref_type_,
                                                     validate_hu_struct_position_   => NOT return_handling_unit_,
                                                     source_ref_demand_code_        => source_ref_demand_code_);
      
      Inventory_Event_Manager_API.Finish_Session;
      
      IF (unattached_from_handling_unit_ = 'TRUE') THEN
         Client_SYS.Add_Info(lu_name_, 'MOVEHUUNATTACH: One or more records were unattached from a Handling Unit.');
      END IF;

      Shipment_Source_Utility_API.Post_Scrap_Return_In_Ship_Inv(source_ref1_         => source_ref1_,
                                                                source_ref2_         => converted_source_ref2_,
                                                                source_ref3_         => converted_source_ref3_,
                                                                source_ref4_         => converted_source_ref4_,
                                                                source_ref_type_db_  => source_ref_type_db_,
                                                                quantity_            => qty_returned_,
                                                                configuration_id_    => configuration_id_,
                                                                to_location_no_      => to_location_no_,
                                                                lot_batch_no_        => lot_batch_no_,
                                                                serial_no_           => serial_no_,
                                                                eng_chg_level_       => eng_chg_level_,
                                                                waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                activity_seq_        => activity_seq_,
                                                                handling_unit_id_    => local_handling_unit_id_,
                                                                catch_qty_returned_  => catch_qty_returned_,
                                                                shipment_id_         => shipment_id_,
                                                                qty_reserved_        => public_reservation_rec_.qty_assigned);
      
      info_ := info_ || Client_SYS.Get_All_Info; 
   ELSE
      Raise_Not_Correct_Return_Loc(source_ref_type_db_, source_ref_demand_code_);
   END IF;
END Return_From_Ship_Inv__;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Ref_Type (
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_source_ref_type IS
      SELECT DISTINCT source_ref_type_db
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Source_Ref_Type_Tab IS TABLE OF get_source_ref_type%ROWTYPE INDEX BY PLS_INTEGER;
   
   source_ref_type_tab_ Source_Ref_Type_Tab;
   result_ VARCHAR2(50);
BEGIN
   OPEN get_source_ref_type;
   FETCH get_source_ref_type BULK COLLECT INTO source_ref_type_tab_;
   CLOSE get_source_ref_type;
   
   IF(source_ref_type_tab_.COUNT = 1) THEN
      result_ := source_ref_type_tab_(1).source_ref_type_db;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Source_Ref_Type;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Ref1 (
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_source_ref1 IS
      SELECT DISTINCT source_ref1
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Source_Ref1_Tab IS TABLE OF get_source_ref1%ROWTYPE INDEX BY PLS_INTEGER;
   source_ref1_tab_ Source_Ref1_Tab;
   result_ VARCHAR2(50);
BEGIN
   OPEN get_source_ref1;
   FETCH get_source_ref1 BULK COLLECT INTO source_ref1_tab_;
   CLOSE get_source_ref1;
   
   IF(source_ref1_tab_.COUNT = 1) THEN
      result_ := source_ref1_tab_(1).source_ref1;
   END IF; 
   RETURN result_;
END Get_Handl_Unit_Source_Ref1;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Ref2 (
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_source_ref2 IS
      SELECT DISTINCT source_ref2
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Source_Ref2_Tab IS TABLE OF get_source_ref2%ROWTYPE INDEX BY PLS_INTEGER;
   source_ref2_tab_ Source_Ref2_Tab;
   result_ VARCHAR2(50);
BEGIN
   OPEN get_source_ref2;
   FETCH get_source_ref2 BULK COLLECT INTO source_ref2_tab_;
   CLOSE get_source_ref2;
   
   IF(source_ref2_tab_.COUNT = 1) THEN
      result_ := source_ref2_tab_(1).source_ref2;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Source_Ref2;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Ref3 (
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_source_ref3 IS
      SELECT DISTINCT source_ref3
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Source_Ref3_Tab IS TABLE OF get_source_ref3%ROWTYPE INDEX BY PLS_INTEGER;
   source_ref3_tab_ Source_Ref3_Tab;
   result_ VARCHAR2(50);
   
BEGIN
   OPEN get_source_ref3;
   FETCH get_source_ref3 BULK COLLECT INTO source_ref3_tab_;
   CLOSE get_source_ref3;
   
   IF(source_ref3_tab_.COUNT = 1) THEN
      result_ := source_ref3_tab_(1).source_ref3;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Source_Ref3;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Ref4 (
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_source_ref4 IS
      SELECT DISTINCT source_ref4
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Source_Ref4_Tab IS TABLE OF get_source_ref4%ROWTYPE INDEX BY PLS_INTEGER;
   source_ref4_tab_ Source_Ref4_Tab;
   result_ VARCHAR2(50);
BEGIN
   OPEN get_source_ref4;
   FETCH get_source_ref4 BULK COLLECT INTO source_ref4_tab_;
   CLOSE get_source_ref4;
   
   IF(source_ref4_tab_.COUNT = 1) THEN
      result_ := source_ref4_tab_(1).source_ref4;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Source_Ref4;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Ship_Line_No (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_shipment_line_no IS
      SELECT DISTINCT shipment_line_no
      FROM shipment_source_reservation ssrs, shipment_line_tab slt
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0
      AND ssrs.source_ref1        = slt.source_ref1
      AND ssrs.source_ref2        = NVL(slt.source_ref2,'*')
      AND ssrs.source_ref3        = NVL(slt.source_ref3,'*')
      AND ssrs.source_ref4        = NVL(slt.source_ref4,'*')
      AND ssrs.source_ref_type_db = slt.source_ref_type;
   
   TYPE Shipment_Line_No_Tab IS TABLE OF get_shipment_line_no%ROWTYPE INDEX BY PLS_INTEGER;
   shipment_line_no_tab_ Shipment_Line_No_Tab;
   result_ NUMBER;
BEGIN
   OPEN get_shipment_line_no;
   FETCH get_shipment_line_no BULK COLLECT INTO shipment_line_no_tab_;
   CLOSE get_shipment_line_no;
   
   IF(shipment_line_no_tab_.COUNT = 1) THEN
      result_ := shipment_line_no_tab_(1).shipment_line_no;
   END IF;
   RETURN result_;   
END Get_Handl_Unit_Ship_Line_No;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Source_Part_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_source_part_no IS
      SELECT DISTINCT source_part_no
        FROM shipment_source_reservation ssrs, shipment_line_tab slt
       WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0
      AND ssrs.source_ref1          = slt.source_ref1
      AND ssrs.source_ref2          = NVL(slt.source_ref2,'*')
      AND ssrs.source_ref3          = NVL(slt.source_ref3,'*')
      AND ssrs.source_ref4          = NVL(slt.source_ref4,'*')
      AND ssrs.source_ref_type_db   = slt.source_ref_type;
   
   TYPE Source_Part_No_Tab IS TABLE OF get_source_part_no%ROWTYPE INDEX BY PLS_INTEGER;
   source_part_no_tab_ Source_Part_No_Tab;
   result_   VARCHAR2(200);
BEGIN
   OPEN get_source_part_no;
   FETCH get_source_part_no BULK COLLECT INTO source_part_no_tab_;
   CLOSE get_source_part_no;
   
   IF(source_part_no_tab_.COUNT = 1) THEN
      result_ := source_part_no_tab_(1).source_part_no;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Source_Part_No;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Pick_List_No(
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_pick_list_no IS
      SELECT DISTINCT pick_list_no
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                     FROM handling_unit hu
                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                     START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Pick_List_No_Tab IS TABLE OF get_pick_list_no%ROWTYPE INDEX BY PLS_INTEGER;
   pick_list_no_tab_ Pick_List_No_Tab;
   result_   VARCHAR2(200);
BEGIN
   OPEN get_pick_list_no;
   FETCH get_pick_list_no BULK COLLECT INTO pick_list_no_tab_;
   CLOSE get_pick_list_no;
   
   IF (pick_list_no_tab_.COUNT = 1) THEN
      result_ := pick_list_no_tab_(1).pick_list_no;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Pick_List_No;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Qty_Picked (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_qty_picked IS
      SELECT SUM(qty_picked) qty_picked
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                                       FROM handling_unit hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                                       START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_picked > 0
    GROUP BY part_no;
   
   TYPE Qty_Picked_Tab IS TABLE OF get_qty_picked%ROWTYPE;
   qty_picked_tab_ Qty_Picked_Tab;
   result_   VARCHAR2(10);
BEGIN
   OPEN get_qty_picked;
   FETCH get_qty_picked BULK COLLECT INTO qty_picked_tab_;
   CLOSE get_qty_picked;
   
   IF (qty_picked_tab_.COUNT = 1) THEN
      result_ := qty_picked_tab_(1).qty_picked;
   END IF;   
   RETURN result_;
END Get_Handl_Unit_Qty_Picked;

@UncheckedAccess
FUNCTION Get_Handl_Unit_Unit_Meas (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_unit_meas IS
      SELECT DISTINCT Inventory_Part_API.Get_Unit_Meas(contract, part_no) unit_meas
      FROM shipment_source_reservation ssrs
      WHERE (ssrs.handling_unit_id IN (SELECT hu.handling_unit_id 
                                       FROM handling_unit hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id 
                                       START WITH hu.handling_unit_id IN (handling_unit_id_)))
      AND ssrs.qty_assigned > 0;
   
   TYPE Unit_Meas_Tab IS TABLE OF get_unit_meas%ROWTYPE INDEX BY PLS_INTEGER;
   unit_meas_tab_ Unit_Meas_Tab;
   result_        VARCHAR2(10);
BEGIN
   OPEN get_unit_meas;
   FETCH get_unit_meas BULK COLLECT INTO unit_meas_tab_;
   CLOSE get_unit_meas;
   
   IF (unit_meas_tab_.COUNT = 1) THEN
      result_ := unit_meas_tab_(1).unit_meas;
   END IF;
   RETURN result_;
END Get_Handl_Unit_Unit_Meas;

@UncheckedAccess
PROCEDURE Check_For_Valid_Ship_Loc__(
   contract_ IN VARCHAR2)
IS
   dummy_                      NUMBER;          
   CURSOR get_ship_location IS
      SELECT 1
        FROM warehouse_bay_bin_tab wbb, inventory_location_group_tab lg
       WHERE wbb.location_group           = lg.location_group
         AND lg.inventory_location_type   = 'SHIPMENT'
         AND contract                     = contract_;        
BEGIN
   OPEN  get_ship_location;
   FETCH get_ship_location INTO dummy_;
   CLOSE get_ship_location;
   
   IF (dummy_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTSITESHIPLOC: There is no shipment location defined for site :P1.', contract_ );
   END IF;
END Check_For_Valid_Ship_Loc__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


@UncheckedAccess
FUNCTION Get_Inv_Trans_Src_Ref_Type_Db (
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   inv_trans_source_ref_type_db_   VARCHAR2(50);
BEGIN
   -- fetch the order type to be used in inventory transaction created.
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      inv_trans_source_ref_type_db_ := Order_Type_API.DB_CUSTOMER_ORDER;
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      inv_trans_source_ref_type_db_ := Order_Type_API.DB_PROJECT_DELIVERABLES;
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      inv_trans_source_ref_type_db_ := Order_Type_API.DB_SHIPMENT_ORDER;
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      inv_trans_source_ref_type_db_ := Order_Type_API.DB_PURCH_RECEIPT_RETURN;
   END IF;    
   RETURN inv_trans_source_ref_type_db_;
END Get_Inv_Trans_Src_Ref_Type_Db;


@UncheckedAccess
FUNCTION Get_Inv_Trans_Src_Ref_Type (
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   inv_trans_source_ref_type_db_    VARCHAR2(50);
BEGIN
   inv_trans_source_ref_type_db_ := Get_Inv_Trans_Src_Ref_Type_Db(source_ref_type_db_);
   
   RETURN Order_Type_API.Decode(inv_trans_source_ref_type_db_);
END Get_Inv_Trans_Src_Ref_Type;


PROCEDURE Validate_Qty_To_Move(
   qty_to_move_  IN NUMBER,
   qty_assigned_ IN NUMBER )
IS
BEGIN
   IF (qty_to_move_ > qty_assigned_) THEN
      Error_SYS.Record_General(lu_name_, 'QTYTOMOVGTQTYASS: Quantity to move is greater than the picked quantity :P1.', qty_assigned_);
   END IF;
END Validate_Qty_To_Move;

PROCEDURE Validate_Qty_To_Return(
   qty_returned_ IN NUMBER,
   qty_assigned_ IN NUMBER )
IS
BEGIN
   IF (qty_returned_ > qty_assigned_) THEN
      Error_SYS.Record_General(lu_name_ , 'QTYTORETGTASSQTY: Quantity to return is greater than the picked quantity :P1.', qty_assigned_);
   END IF;
END Validate_Qty_To_Return;

PROCEDURE Validate_Qty_To_Scrap(
   qty_scrapped_ IN NUMBER,
   qty_assigned_ IN NUMBER )
IS
BEGIN
   IF (qty_scrapped_ > qty_assigned_) THEN
      Error_SYS.Record_General(lu_name_ , 'QTYTOSCRPGTASSQTY: Quantity to scrap is greater than the picked quantity :P1.', qty_assigned_);
   END IF;
END Validate_Qty_To_Scrap;


-- Validate_Sender_Location
--    Validates the inventory location based on the sender type and ID specified. If the sender type is SITE, then only a non-remote
--    warehouse location within the site can be selected and if the sender type is REMOTE_WAREHOUSE, then only a location within the 
--    specified sender warehouse can be selected.
PROCEDURE Validate_Sender_Location (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2,
   sender_type_ IN VARCHAR2,
   sender_id_   IN VARCHAR2)
IS
   location_warehouse_id_  WAREHOUSE_TAB.warehouse_id%TYPE;
   sender_warehouse_id_    WAREHOUSE_TAB.warehouse_id%TYPE;
BEGIN
   -- Null if the location is a non-remote warehouse location
   location_warehouse_id_ := Inventory_Location_API.Get_Remote_Warehouse(contract_, location_no_);
   
   IF (sender_type_ = Sender_Receiver_Type_API.DB_SITE) THEN
      IF (location_warehouse_id_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INV_SIT_LOC: Only non-remote warehouse locations within the site :P1 can be selected when the sender type is Site.', contract_);
      END IF;
   ELSIF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      sender_warehouse_id_ := Warehouse_API.Get_Warehouse_Id_By_Global_Id(sender_id_);
      IF (NVL(location_warehouse_id_, 'NULL') !=  sender_warehouse_id_) THEN
         Error_SYS.Record_General(lu_name_, 'INV_REM_LOC: Only remote warehouse locations within the sender warehouse :P1 can be selected when the sender type is Remote Warehouse.', 
                                  sender_warehouse_id_);
      END IF;
   END IF;
END Validate_Sender_Location;


PROCEDURE Raise_Not_Correct_Return_Loc (
   source_ref_type_db_           VARCHAR2,
   source_ref_demand_code_db_    VARCHAR2)
IS
BEGIN 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      Error_SYS.Record_General(lu_name_, 'NOTCORRECTLOCPRR: To location must be a Picking, QA or Arrival location for Purchase Receipt Returns.');
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER AND 
          NVL(source_ref_demand_code_db_, string_null_) = Order_Supply_Type_API.DB_PURCHASE_RECEIPT) THEN
      Error_SYS.Record_General(lu_name_, 'NOTCORRECTLOCSOPR: To location must be a QA or Arrival location for :P1 with demand code :P2.', 
                               Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_), Order_Supply_Type_API.Decode(source_ref_demand_code_db_));
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTCORRECTLOC: To location is not a Picking, Production Line or Floor Stock location.');
   END IF;
END Raise_Not_Correct_Return_Loc;

PROCEDURE Raise_Not_A_Shipment_Location
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTCORRECTLOCTO: To location is not a Shipment Location.');
END Raise_Not_A_Shipment_Location;

PROCEDURE Move_To_Shipment_Location (
   info_                        OUT VARCHAR2,
   order_no_                    IN  VARCHAR2,
   line_no_                     IN  VARCHAR2,
   rel_no_                      IN  VARCHAR2,
   line_item_no_                IN  VARCHAR2,
   source_ref_type_db_          IN  VARCHAR2,
   contract_                    IN  VARCHAR2,
   part_no_                     IN  VARCHAR2,
   location_no_                 IN  VARCHAR2,
   lot_batch_no_                IN  VARCHAR2,
   serial_no_                   IN  VARCHAR2,
   eng_chg_level_               IN  VARCHAR2,
   waiv_dev_rej_no_             IN  VARCHAR2,
   pick_list_no_                IN  VARCHAR2,
   configuration_id_            IN  VARCHAR2,
   activity_seq_                IN  NUMBER,
   handling_unit_id_            IN  NUMBER,
   shipment_location_           IN  VARCHAR2,
   input_qty_                   IN  NUMBER,
   input_unit_meas_             IN  VARCHAR2,
   input_conv_factor_           IN  NUMBER,
   input_variable_values_       IN  VARCHAR2,
   shipment_id_                 IN  NUMBER,
   validate_hu_struct_position_ IN  BOOLEAN,
   source_ref_demand_code_      IN  VARCHAR2,
   add_hu_to_shipment_          IN  BOOLEAN  DEFAULT TRUE,
   ship_handling_unit_id_       IN  NUMBER   DEFAULT NULL )
IS
   unattached_from_handling_unit_   VARCHAR2(5);
   to_handling_unit_id_             NUMBER;
   qty_picked_                      NUMBER;
   expiration_date_                 DATE;
   catch_quantity_                  NUMBER := NULL;
   catch_qty_picked_                NUMBER;
   qty_to_pack_                     NUMBER;
   catch_qty_to_pack_               NUMBER;
   qty_to_reserve_                  NUMBER;
   catch_qty_to_reserve_            NUMBER;
   avail_ship_line_qty_             NUMBER;
   handling_unit_tab_               Shipment_Reserv_Handl_Unit_API.Reserv_Handl_Unit_Qty_Tab;   
   qty_assigned_                    NUMBER;
   shipment_line_no_                NUMBER;
   ship_loc_qty_assigned_           NUMBER;
   ship_loc_qty_shipped_            NUMBER;
   ship_loc_catch_qty_picked_       NUMBER;
   ship_loc_qty_picked_             NUMBER; 
   public_reservation_rec_          Reserve_Shipment_API.Public_Reservation_Rec;
   ship_loc_public_res_rec_         Reserve_Shipment_API.Public_Reservation_Rec;
   inv_trans_source_ref_type_       VARCHAR2(50);
   ship_loc_input_qty_              NUMBER;
   ship_loc_input_unit_meas_        VARCHAR2(30);
   ship_loc_input_conv_factor_      NUMBER;
   ship_loc_input_variable_values_  VARCHAR2(2000);
   conv_ship_line_qty_              NUMBER;
   shipment_rec_                    Shipment_API.Public_Rec;
BEGIN
   IF (shipment_id_ != 0) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      Validate_Sender_Location(contract_, shipment_location_, shipment_rec_.sender_type, shipment_rec_.sender_id);
   END IF;
   
   -- Move reserved quantity to shipment inventory.
   public_reservation_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => order_no_, 
                                                                               source_ref2_            => line_no_, 
                                                                               source_ref3_            => rel_no_,
                                                                               source_ref4_            => line_item_no_, 
                                                                               source_ref_type_db_     => source_ref_type_db_,
                                                                               contract_               => contract_, 
                                                                               part_no_                => part_no_, 
                                                                               location_no_            => location_no_, 
                                                                               lot_batch_no_           => lot_batch_no_, 
                                                                               serial_no_              => serial_no_,
                                                                               eng_chg_level_          => eng_chg_level_, 
                                                                               waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                               activity_seq_           => activity_seq_, 
                                                                               handling_unit_id_       => handling_unit_id_,
                                                                               pick_list_no_           => pick_list_no_, 
                                                                               configuration_id_       => configuration_id_, 
                                                                               shipment_id_            => shipment_id_);
   
   qty_assigned_     := public_reservation_rec_.qty_assigned;
   qty_picked_       := public_reservation_rec_.qty_picked;
   catch_qty_picked_ := public_reservation_rec_.catch_qty;
   
   -- Move single part
   expiration_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_          => contract_,     
                                                                       part_no_           => part_no_,   
                                                                       configuration_id_  => configuration_id_, 
                                                                       location_no_       => location_no_,
                                                                       lot_batch_no_      => lot_batch_no_, 
                                                                       serial_no_         => serial_no_, 
                                                                       eng_chg_level_     => eng_chg_level_,    
                                                                       waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                                                       activity_seq_      => activity_seq_, 
                                                                       handling_unit_id_  => handling_unit_id_);
   
   inv_trans_source_ref_type_ := Get_Inv_Trans_Src_Ref_Type(source_ref_type_db_);                                                                    
   
   Inventory_Event_Manager_API.Start_Session;
   Inventory_Part_In_Stock_API.Move_Part_Shipment(unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                                  catch_quantity_                => catch_qty_picked_,
                                                  contract_                      => contract_,     
                                                  part_no_                       => part_no_,         
                                                  configuration_id_              => configuration_id_,
                                                  location_no_                   => location_no_,        
                                                  lot_batch_no_                  => lot_batch_no_, 
                                                  serial_no_                     => serial_no_,       
                                                  eng_chg_level_                 => eng_chg_level_,
                                                  waiv_dev_rej_no_               => waiv_dev_rej_no_,    
                                                  activity_seq_                  => activity_seq_, 
                                                  handling_unit_id_              => handling_unit_id_,
                                                  expiration_date_               => expiration_date_, 
                                                  to_contract_                   => contract_,
                                                  to_location_no_                => shipment_location_,  
                                                  quantity_                      => qty_picked_,   
                                                  quantity_reserved_             => qty_picked_,    
                                                  move_comment_                  => NULL,
                                                  order_no_                      => order_no_,
                                                  line_no_                       => line_no_,            
                                                  release_no_                    => rel_no_,       
                                                  line_item_no_                  => line_item_no_,
                                                  source_ref5_                   => shipment_id_,
                                                  order_type_                    => inv_trans_source_ref_type_,
                                                  validate_hu_struct_position_   => validate_hu_struct_position_,
                                                  source_ref_demand_code_        => source_ref_demand_code_ );
   
   to_handling_unit_id_ := CASE unattached_from_handling_unit_ WHEN Fnd_Boolean_API.DB_TRUE THEN 0 ELSE handling_unit_id_ END;
   
   Client_SYS.Clear_Info;
   IF (unattached_from_handling_unit_ = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'MOVEHUUNATTACH: One or more records were unattached from a Handling Unit.');
   END IF;
   info_ := Client_SYS.Get_All_Info;
   
   IF (shipment_id_ != 0) THEN
      shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_,
                                                                          source_ref_type_db_ );
      
      -- Fetches the quantity that will be possible to pack on the new shipment inventory location.
      Shipment_Reserv_Handl_Unit_API.Get_Valid_Qty_To_Be_Packed(qty_to_pack_              => qty_to_pack_,
                                                                catch_qty_to_pack_        => catch_qty_to_pack_,
                                                                source_ref1_              => order_no_, 
                                                                source_ref2_              => NVL(line_no_,'*'), 
                                                                source_ref3_              => NVL(rel_no_,'*'), 
                                                                source_ref4_              => NVL(line_item_no_,'*'),                                                                                           
                                                                contract_                 => contract_, 
                                                                part_no_                  => part_no_, 
                                                                location_no_              => location_no_, 
                                                                lot_batch_no_             => lot_batch_no_, 
                                                                serial_no_                => serial_no_, 
                                                                eng_chg_level_            => eng_chg_level_,
                                                                waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                                activity_seq_             => activity_seq_, 
                                                                reserv_handling_unit_id_  => handling_unit_id_, 
                                                                configuration_id_         => configuration_id_,
                                                                pick_list_no_             => pick_list_no_, 
                                                                shipment_id_              => shipment_id_,
                                                                shipment_line_no_         => shipment_line_no_,
                                                                to_location_no_           => shipment_location_,
                                                                handling_unit_id_         => ship_handling_unit_id_);
      IF (qty_picked_ >= qty_to_pack_) THEN
         handling_unit_tab_ := Shipment_Reserv_Handl_Unit_API.Get_Handling_Units(source_ref1_               => order_no_, 
                                                                                 source_ref2_               => NVL(line_no_,'*'), 
                                                                                 source_ref3_               => NVL(rel_no_,'*'), 
                                                                                 source_ref4_               => NVL(line_item_no_,'*'),                                                                                  
                                                                                 contract_                  => contract_, 
                                                                                 part_no_                   => part_no_, 
                                                                                 location_no_               => location_no_, 
                                                                                 lot_batch_no_              => lot_batch_no_, 
                                                                                 serial_no_                 => serial_no_, 
                                                                                 eng_chg_level_             => eng_chg_level_,
                                                                                 waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                                                 activity_seq_              => activity_seq_, 
                                                                                 reserv_handling_unit_id_   => handling_unit_id_,
                                                                                 configuration_id_          => configuration_id_, 
                                                                                 pick_list_no_              => pick_list_no_, 
                                                                                 shipment_id_               => shipment_id_,
                                                                                 shipment_line_no_          => shipment_line_no_,
                                                                                 handling_unit_id_          => ship_handling_unit_id_);
      ELSE
         qty_to_pack_ := 0;
      END IF;
   END IF;
   -- NOTE: The qty_to_pack will be reserved inside Shipment_Reserv_Handl_Unit_API.Add_Handling_Units to reduce the number of
   -- changes made to the reservations.
   qty_to_reserve_         := qty_picked_ - NVL(qty_to_pack_,0);
   catch_qty_to_reserve_   := catch_qty_picked_ - NVL(catch_qty_to_pack_,0);
   
   IF (qty_to_reserve_ > 0) THEN
      -- Reserve single part on new location
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_         => catch_quantity_, 
                                               contract_               => contract_,  
                                               part_no_                => part_no_,       
                                               configuration_id_       => configuration_id_, 
                                               location_no_            => shipment_location_,
                                               lot_batch_no_           => lot_batch_no_,   
                                               serial_no_              => serial_no_, 
                                               eng_chg_level_          => eng_chg_level_, 
                                               waiv_dev_rej_no_        => waiv_dev_rej_no_,  
                                               activity_seq_           => activity_seq_, 
                                               handling_unit_id_       => to_handling_unit_id_,
                                               quantity_               => qty_to_reserve_,
                                               source_ref_type_db_     => Order_Type_API.Encode(inv_trans_source_ref_type_),
                                               source_ref_demand_code_ => source_ref_demand_code_);
      
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
         Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => contract_,       
                                                                     part_no_              => part_no_    ,
                                                                     configuration_id_     => configuration_id_  ,
                                                                     location_no_          => shipment_location_,
                                                                     lot_batch_no_         => lot_batch_no_,
                                                                     serial_no_            => serial_no_,
                                                                     eng_chg_level_        => eng_chg_level_,
                                                                     waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                     activity_seq_         => activity_seq_,
                                                                     handling_unit_id_     => to_handling_unit_id_,
                                                                     pick_list_no_         => pick_list_no_,
                                                                     qty_picked_           => qty_to_reserve_,         
                                                                     catch_qty_picked_     => catch_qty_to_reserve_,
                                                                     source_ref_type_db_   => source_ref_type_db_,
                                                                     source_ref1_          => order_no_, 
                                                                     source_ref2_          => NVL(line_no_,      '*'),
                                                                     source_ref3_          => NVL(rel_no_,       '*'),
                                                                     source_ref4_          => NVL(line_item_no_, '*'),
                                                                     shipment_id_          => shipment_id_,        
                                                                     string_parameter2_    => 'TRUE'   ,
                                                                     reserve_in_inventory_ => FALSE,
                                                                     number_parameter1_    => ship_handling_unit_id_);
      ELSE   
         IF (Shipment_Source_Utility_API.Reservation_Exists(source_ref1_        => order_no_, 
                                                            source_ref2_        => line_no_, 
                                                            source_ref3_        => rel_no_, 
                                                            source_ref4_        => line_item_no_, 
                                                            source_ref_type_db_ => source_ref_type_db_,
                                                            contract_           => contract_,
                                                            part_no_            => part_no_,
                                                            location_no_        => shipment_location_, 
                                                            lot_batch_no_       => lot_batch_no_,
                                                            serial_no_          => serial_no_,
                                                            eng_chg_level_      => eng_chg_level_,
                                                            waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                            activity_seq_       => activity_seq_, 
                                                            handling_unit_id_   => to_handling_unit_id_,
                                                            pick_list_no_       => pick_list_no_, 
                                                            configuration_id_   => configuration_id_,       
                                                            shipment_id_        => shipment_id_) = 'TRUE' ) THEN
            
            -- Already picked on this shipment location -> Update qty_picked, qty_assigned.
            ship_loc_public_res_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => order_no_, 
                                                                                         source_ref2_            => line_no_, 
                                                                                         source_ref3_            => rel_no_,
                                                                                         source_ref4_            => line_item_no_, 
                                                                                         source_ref_type_db_     => source_ref_type_db_,
                                                                                         contract_               => contract_, 
                                                                                         part_no_                => part_no_, 
                                                                                         location_no_            => shipment_location_, 
                                                                                         lot_batch_no_           => lot_batch_no_, 
                                                                                         serial_no_              => serial_no_,
                                                                                         eng_chg_level_          => eng_chg_level_, 
                                                                                         waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                                                         activity_seq_           => activity_seq_, 
                                                                                         handling_unit_id_       => to_handling_unit_id_,
                                                                                         pick_list_no_           => pick_list_no_, 
                                                                                         configuration_id_       => configuration_id_, 
                                                                                         shipment_id_            => shipment_id_);
            
            ship_loc_qty_assigned_     := ship_loc_public_res_rec_.qty_assigned;
            ship_loc_qty_picked_       := ship_loc_public_res_rec_.qty_picked;
            ship_loc_catch_qty_picked_ := ship_loc_public_res_rec_.catch_qty;
            ship_loc_qty_shipped_      := ship_loc_public_res_rec_.qty_shipped; 
            
            -- We calculate Input Qty based on current Input UoM (if it is not null) on the shipment location to have correct conversion when partial picking is allowed 
            -- and different Input UoM has been used for picking same stock.
            IF ship_loc_public_res_rec_.input_conv_factor IS NOT NULL THEN 
               ship_loc_input_qty_              := (ship_loc_qty_picked_ + qty_to_reserve_) / ship_loc_public_res_rec_.input_conv_factor;
               ship_loc_input_unit_meas_        := ship_loc_public_res_rec_.input_unit_meas;
               ship_loc_input_conv_factor_      := ship_loc_public_res_rec_.input_conv_factor;
               ship_loc_input_variable_values_  := Input_Unit_Meas_API.Get_Input_Value_String(ship_loc_input_qty_, ship_loc_input_unit_meas_);
               -- If current Input UoM information is not defined on the shipment location for previously picked stock, we do the calculation based on user's input data
            ELSIF input_conv_factor_ IS NOT NULL THEN 
               ship_loc_input_qty_              := (ship_loc_qty_picked_ + qty_to_reserve_) / input_conv_factor_;
               ship_loc_input_unit_meas_        := input_unit_meas_;
               ship_loc_input_conv_factor_      := input_conv_factor_;
               ship_loc_input_variable_values_  := Input_Unit_Meas_API.Get_Input_Value_String(ship_loc_input_qty_, ship_loc_input_unit_meas_);
            END IF;
            
            Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_            => order_no_,        
                                                                      source_ref2_            => line_no_,          
                                                                      source_ref3_            => rel_no_,             
                                                                      source_ref4_            => line_item_no_,
                                                                      source_ref_type_db_     => source_ref_type_db_,
                                                                      contract_               => contract_,        
                                                                      part_no_                => part_no_,          
                                                                      location_no_            => shipment_location_,  
                                                                      lot_batch_no_           => lot_batch_no_,
                                                                      serial_no_              => serial_no_,       
                                                                      eng_chg_level_          => eng_chg_level_,    
                                                                      waiv_dev_rej_no_        => waiv_dev_rej_no_,    
                                                                      activity_seq_           => activity_seq_,
                                                                      handling_unit_id_       => to_handling_unit_id_,
                                                                      pick_list_no_           => pick_list_no_,     
                                                                      configuration_id_       => configuration_id_,   
                                                                      shipment_id_            => shipment_id_,
                                                                      remaining_qty_assigned_ => NULL,
                                                                      qty_picked_             => ship_loc_qty_picked_ + qty_to_reserve_,
                                                                      catch_qty_              => ship_loc_catch_qty_picked_ + catch_qty_to_reserve_,
                                                                      input_qty_              => ship_loc_input_qty_, 
                                                                      input_unit_meas_        => ship_loc_input_unit_meas_, 
                                                                      input_conv_factor_      => ship_loc_input_conv_factor_,
                                                                      input_variable_values_  => ship_loc_input_variable_values_, 
                                                                      move_to_ship_location_  => 'TRUE',
                                                                      ship_handling_unit_id_  => ship_handling_unit_id_);
         ELSE
            -- Nothing picked on this shipment location -> Create new.
            -- We recalculate input_qty_ and input_variable_values_ instead of using client value to get correct values when part is serial tracked in reciept and issue.
            IF input_conv_factor_ IS NOT NULL THEN 
               ship_loc_input_qty_              := qty_to_reserve_ / input_conv_factor_;
               ship_loc_input_variable_values_  := Input_Unit_Meas_API.Get_Input_Value_String(ship_loc_input_qty_, input_unit_meas_);
            END IF;
            
            Shipment_Source_Utility_API.New_Reservation(source_ref1_              => order_no_, 
                                                        source_ref2_              => line_no_,
                                                        source_ref3_              => rel_no_,
                                                        source_ref4_              => line_item_no_,
                                                        source_ref_type_db_       => source_ref_type_db_,
                                                        contract_                 => contract_, 
                                                        part_no_                  => part_no_, 
                                                        location_no_              => shipment_location_, 
                                                        lot_batch_no_             => lot_batch_no_,
                                                        serial_no_                => serial_no_,
                                                        eng_chg_level_            => eng_chg_level_, 
                                                        waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                        activity_seq_             => activity_seq_,     
                                                        handling_unit_id_         => to_handling_unit_id_,
                                                        pick_list_no_             => pick_list_no_,       
                                                        preliminary_pick_list_no_ => public_reservation_rec_.preliminary_pick_list_no,
                                                        configuration_id_         => configuration_id_, 
                                                        new_shipment_id_          => shipment_id_,
                                                        qty_assigned_             => qty_to_reserve_, 
                                                        qty_picked_               => qty_to_reserve_, 
                                                        catch_qty_                => catch_qty_to_reserve_,
                                                        qty_shipped_              => 0,
                                                        input_qty_                => ship_loc_input_qty_,                           
                                                        input_unit_meas_          => input_unit_meas_,
                                                        input_conv_factor_        => input_conv_factor_, 
                                                        input_variable_values_    => ship_loc_input_variable_values_, 
                                                        reassignment_type_        => NULL,
                                                        move_to_ship_location_    => 'TRUE');
            
         END IF;
      END IF;
   END IF;
   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Set_Delivery_Note_Invalid(order_no_, shipment_location_);
      $ELSE
         NULL;   
      $END
   END IF;
   
   IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN 
      Inventory_Part_Reservation_API.Reserve_And_Report_As_Picked(contract_             => contract_,       
                                                                  part_no_              => part_no_    ,
                                                                  configuration_id_     => configuration_id_  ,
                                                                  location_no_          => location_no_,
                                                                  lot_batch_no_         => lot_batch_no_,
                                                                  serial_no_            => serial_no_,
                                                                  eng_chg_level_        => eng_chg_level_,
                                                                  waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                  activity_seq_         => activity_seq_,
                                                                  handling_unit_id_     => handling_unit_id_,
                                                                  pick_list_no_         => pick_list_no_,
                                                                  qty_picked_           => -(public_reservation_rec_.qty_picked),         
                                                                  catch_qty_picked_     => -(public_reservation_rec_.catch_qty),
                                                                  source_ref_type_db_   => source_ref_type_db_,
                                                                  source_ref1_          => order_no_, 
                                                                  source_ref2_          => NVL(line_no_, '*'),
                                                                  source_ref3_          => NVL(rel_no_,  '*'),
                                                                  source_ref4_          => NVL(line_item_no_, '*'),
                                                                  shipment_id_          => shipment_id_,        
                                                                  string_parameter2_    => 'TRUE'   ,
                                                                  reserve_in_inventory_ => FALSE,
                                                                  number_parameter1_    => ship_handling_unit_id_);
   ELSE   
      -- Keep source reservation when Reserved Qty > Picked Qty
      IF (qty_picked_ < qty_assigned_) THEN
         IF public_reservation_rec_.input_conv_factor IS NOT NULL THEN 
            public_reservation_rec_.input_qty              := (qty_assigned_ - qty_picked_) / public_reservation_rec_.input_conv_factor;
            public_reservation_rec_.input_variable_values  := Input_Unit_Meas_API.Get_Input_Value_String(public_reservation_rec_.input_qty, public_reservation_rec_.input_unit_meas);
         END IF;
         
         Shipment_Source_Utility_API.Modify_Reservation_Qty_Picked(source_ref1_              => order_no_,        
                                                                   source_ref2_              => line_no_,          
                                                                   source_ref3_              => rel_no_,             
                                                                   source_ref4_              => line_item_no_,
                                                                   source_ref_type_db_       => source_ref_type_db_,
                                                                   contract_                 => contract_,        
                                                                   part_no_                  => part_no_,          
                                                                   location_no_              => location_no_,        
                                                                   lot_batch_no_             => lot_batch_no_,
                                                                   serial_no_                => serial_no_,       
                                                                   eng_chg_level_            => eng_chg_level_,    
                                                                   waiv_dev_rej_no_          => waiv_dev_rej_no_,    
                                                                   activity_seq_             => activity_seq_,
                                                                   handling_unit_id_         => handling_unit_id_,
                                                                   pick_list_no_             => pick_list_no_,     
                                                                   configuration_id_         => configuration_id_,   
                                                                   shipment_id_              => shipment_id_,
                                                                   remaining_qty_assigned_   => (qty_assigned_ - qty_picked_),
                                                                   qty_picked_               => 0,
                                                                   catch_qty_                => public_reservation_rec_.catch_qty + catch_qty_picked_,
                                                                   input_qty_                => public_reservation_rec_.input_qty, 
                                                                   input_unit_meas_          => public_reservation_rec_.input_unit_meas,
                                                                   input_conv_factor_        => public_reservation_rec_.input_conv_factor,       
                                                                   input_variable_values_    => public_reservation_rec_.input_variable_values,
                                                                   move_to_ship_location_    => 'TRUE',
                                                                   ship_handling_unit_id_    => ship_handling_unit_id_ );
      ELSE                                      
         Shipment_Source_Utility_API.Remove_Reservation(source_ref1_           => order_no_, 
                                                        source_ref2_           => line_no_, 
                                                        source_ref3_           => rel_no_, 
                                                        source_ref4_           => line_item_no_,
                                                        source_ref_type_db_    => source_ref_type_db_,
                                                        contract_              => contract_, 
                                                        part_no_               => part_no_, 
                                                        location_no_           => location_no_, 
                                                        lot_batch_no_          => lot_batch_no_, 
                                                        serial_no_             => serial_no_,
                                                        eng_chg_level_         => eng_chg_level_, 
                                                        waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                        activity_seq_          => activity_seq_, 
                                                        handling_unit_id_      => handling_unit_id_,
                                                        pick_list_no_          => pick_list_no_, 
                                                        configuration_id_      => configuration_id_, 
                                                        shipment_id_           => shipment_id_,
                                                        reassignment_type_     => NULL,
                                                        move_to_ship_location_ => 'TRUE');
         
      END IF;
   END IF;
   
   IF (shipment_id_ != 0) THEN
      IF (handling_unit_tab_.COUNT > 0) THEN
         -- We have already unreserved the full qty_picked hence we send move_to_ship_location_ = TRUE into Shipment_Reserv_Handl_Unit_API.Add_Handling_Units this
         -- prevents it from unreserving the quantity again and helps us to keep down the amount of changes made to the reservations.
         Shipment_Reserv_Handl_Unit_API.Add_Handling_Units(source_ref1_             => order_no_, 
                                                           source_ref2_             => NVL(line_no_,'*'), 
                                                           source_ref3_             => NVL(rel_no_,'*'), 
                                                           source_ref4_             => NVL(line_item_no_,'*'),                                                           
                                                           contract_                => contract_, 
                                                           part_no_                 => part_no_, 
                                                           location_no_             => shipment_location_, 
                                                           lot_batch_no_            => lot_batch_no_, 
                                                           serial_no_               => serial_no_, 
                                                           eng_chg_level_           => eng_chg_level_,
                                                           waiv_dev_rej_no_         => waiv_dev_rej_no_, 
                                                           activity_seq_            => activity_seq_, 
                                                           reserv_handling_unit_id_ => to_handling_unit_id_,
                                                           configuration_id_        => configuration_id_, 
                                                           pick_list_no_            => pick_list_no_, 
                                                           shipment_id_             => shipment_id_,
                                                           shipment_line_no_        => shipment_line_no_,
                                                           handling_unit_tab_       => handling_unit_tab_,
                                                           move_to_ship_location_   => 'TRUE');                                                  
      END IF;
      
      IF (to_handling_unit_id_ != 0) THEN
         -- If the reservation is a package component we wont add the Handling Units from Inventory.
         IF (NOT (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND line_item_no_ > 0)) THEN
            -- If there is qty_picked that was not assigned to a handling unit on the shipment we want to try to place the resevation's
            -- current handling unit (from inventory) on the shipment.
            IF ((qty_picked_ - qty_to_pack_) > 0) THEN
               avail_ship_line_qty_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_, 
                                                                                                 order_no_, 
                                                                                                 line_no_, 
                                                                                                 rel_no_, 
                                                                                                 line_item_no_, 
                                                                                                 source_ref_type_db_);
               conv_ship_line_qty_  := Shipment_Handling_Utility_API.Get_Converted_Inv_Qty(shipment_id_, 
                                                                                              shipment_line_no_,
                                                                                              avail_ship_line_qty_,
                                                                                              NULL,
                                                                                              NULL);                                                                                   
               
               -- If there isn't enough qty left to attach the handling unit that we want to connect to the shipment then
               -- we need to remove the Shipment_Line_Handl_Unit-records that has no specific reservations assigned to
               -- make room for this new handling unit.
               IF ((qty_picked_ - qty_to_pack_) > conv_ship_line_qty_) THEN
                  Shipment_Line_Handl_Unit_API.Remove_Unattached_Qty(shipment_id_, shipment_line_no_);
               END IF;
               
               IF (add_hu_to_shipment_) THEN
                  Shipment_Handling_Utility_API.Add_Hu_To_Shipment(to_handling_unit_id_, shipment_id_, assign_existing_hu_=> TRUE);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Move_To_Shipment_Location;

-------------------- LU  NEW METHODS -------------------------------------


-- This method is used by DataCapProcessPartShip
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   receiver_id_                IN VARCHAR2,
   condition_code_             IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_        Get_Lov_Values;
   stmt_                  VARCHAR2(8000);
   TYPE Lov_Value_Tab     IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_         Lov_Value_Tab;
   second_column_name_    VARCHAR2(200);
   second_column_value_   VARCHAR2(200);
   lov_item_description_  VARCHAR2(200);
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_    NUMBER;
   exit_lov_              BOOLEAN := FALSE;
   temp_handling_unit_id_ NUMBER;
   temp_part_no_          VARCHAR2(25);
   temp_shipment_id_      NUMBER;
   temp_reciever_id_      VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDLE_SOURCES_IN_SHIPMENT_INV', column_name_);
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;
      
      stmt_ := stmt_  || ' FROM HANDLE_SOURCES_IN_SHIPMENT_INV ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
      END IF;
      IF source_ref1_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
      END IF;      
      IF source_ref2_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
      END IF;      
      IF source_ref3_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref3_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
      END IF;      
      IF source_ref4_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref4_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
      END IF;      
      IF source_ref_type_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
      END IF;      
      IF pick_list_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
      END IF;      
      IF part_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :part_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_no = :part_no_';
      END IF;      
      IF configuration_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
      END IF;      
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;      
      IF lot_batch_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
      END IF;
      IF serial_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND serial_no = :serial_no_';
      END IF;
      IF waiv_dev_rej_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
      END IF;
      IF eng_chg_level_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
      END IF;
      IF activity_seq_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      IF receiver_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
      END IF;   
      IF condition_code_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND condition_code is NULL AND :condition_code_ IS NULL';
      ELSIF condition_code_ = '%' THEN
         stmt_ := stmt_ || ' AND :condition_code_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND condition_code = :condition_code_';
      END IF;
      stmt_ := stmt_  || ' AND   contract = :contract_
                           AND   location_type_db = ''SHIPMENT''
                           AND   qty_picked > 0 ';
      
      IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
      
      @ApproveDynamicStatement(2015-03-13,RILASE)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           pick_list_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           receiver_id_,
                                           condition_code_,
                                           contract_;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         IF (column_name_ IN ('SHIPMENT_ID')) THEN
            second_column_name_ := 'RECEIVER_NAME_SHP';
         ELSIF (column_name_ IN ('PART_NO')) THEN
            second_column_name_ := 'PART_NO_PART_DESCRIPTION';
         ELSIF (column_name_ IN ('LOT_BATCH_NO', 'SERIAL_NO', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO')) THEN
            second_column_name_ := 'PART_DESCRIPTION';
         ELSIF (column_name_ IN ('SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4')) THEN
            second_column_name_ := 'RECEIVER_DESC';
         ELSIF (column_name_ IN ('RECEIVER_ID')) THEN
            second_column_name_ := 'RECEIVER_ID_RECEIVER_DESC';
         ELSIF (column_name_ IN ('CONDITION_CODE')) THEN
            second_column_name_ := 'CONDITION_CODE_DESCRIPTION';
         ELSIF (column_name_ IN ('LOCATION_NO')) THEN
            second_column_name_ := 'LOCATION_NO_DESCRIPTION';
         ELSIF (column_name_ IN ('ACTIVITY_SEQ')) THEN
            second_column_name_ := 'PROJECT_ID';
         ELSIF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
         ELSIF (column_name_ IN ('SSCC')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
         END IF;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'RECEIVER_NAME_SHP') THEN
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(Shipment_API.Get_Receiver_Id(lov_value_tab_(i)), 
                                                                                           Shipment_API.Get_Receiver_Type_Db(lov_value_tab_(i)));
                     
                  ELSIF (second_column_name_ = 'PART_NO_PART_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'PART_DESCRIPTION') THEN
                     IF column_name_ = 'LOT_BATCH_NO' THEN
                        temp_part_no_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                    shipment_id_                 => shipment_id_,
                                                                    source_ref1_                 => source_ref1_,
                                                                    source_ref2_                 => source_ref2_,
                                                                    source_ref3_                 => source_ref3_,
                                                                    source_ref4_                 => source_ref4_,
                                                                    source_ref_type_db_          => source_ref_type_db_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    part_no_                     => part_no_,
                                                                    configuration_id_            => configuration_id_,
                                                                    location_no_                 => location_no_,
                                                                    lot_batch_no_                => lov_value_tab_(i),
                                                                    serial_no_                   => serial_no_,
                                                                    waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                    eng_chg_level_               => eng_chg_level_,
                                                                    activity_seq_                => activity_seq_,
                                                                    handling_unit_id_            => handling_unit_id_,
                                                                    alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                    receiver_id_                 => receiver_id_,
                                                                    condition_code_              => condition_code_,
                                                                    column_name_                 => 'PART_NO',
                                                                    sql_where_expression_        => sql_where_expression_);
                     ELSIF column_name_ = 'SERIAL_NO' THEN
                        temp_part_no_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                    shipment_id_                 => shipment_id_,
                                                                    source_ref1_                 => source_ref1_,
                                                                    source_ref2_                 => source_ref2_,
                                                                    source_ref3_                 => source_ref3_,
                                                                    source_ref4_                 => source_ref4_,
                                                                    source_ref_type_db_          => source_ref_type_db_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    part_no_                     => part_no_,
                                                                    configuration_id_            => configuration_id_,
                                                                    location_no_                 => location_no_,
                                                                    lot_batch_no_                => lot_batch_no_,
                                                                    serial_no_                   => lov_value_tab_(i),
                                                                    waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                    eng_chg_level_               => eng_chg_level_,
                                                                    activity_seq_                => activity_seq_,
                                                                    handling_unit_id_            => handling_unit_id_,
                                                                    alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                    receiver_id_                 => receiver_id_,
                                                                    condition_code_              => condition_code_,
                                                                    column_name_                 => 'PART_NO',
                                                                    sql_where_expression_        => sql_where_expression_);
                     ELSIF column_name_ = 'CONFIGURATION_ID' THEN
                        temp_part_no_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                    shipment_id_                 => shipment_id_,
                                                                    source_ref1_                 => source_ref1_,
                                                                    source_ref2_                 => source_ref2_,
                                                                    source_ref3_                 => source_ref3_,
                                                                    source_ref4_                 => source_ref4_,
                                                                    source_ref_type_db_          => source_ref_type_db_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    part_no_                     => part_no_,
                                                                    configuration_id_            => lov_value_tab_(i),
                                                                    location_no_                 => location_no_,
                                                                    lot_batch_no_                => lot_batch_no_,
                                                                    serial_no_                   => serial_no_,
                                                                    waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                    eng_chg_level_               => eng_chg_level_,
                                                                    activity_seq_                => activity_seq_,
                                                                    handling_unit_id_            => handling_unit_id_,
                                                                    alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                    receiver_id_                 => receiver_id_,
                                                                    condition_code_              => condition_code_,
                                                                    column_name_                 => 'PART_NO',
                                                                    sql_where_expression_        => sql_where_expression_);
                     ELSIF column_name_ = 'ENG_CHG_LEVEL' THEN
                        temp_part_no_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                    shipment_id_                 => shipment_id_,
                                                                    source_ref1_                 => source_ref1_,
                                                                    source_ref2_                 => source_ref2_,
                                                                    source_ref3_                 => source_ref3_,
                                                                    source_ref4_                 => source_ref4_,
                                                                    source_ref_type_db_          => source_ref_type_db_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    part_no_                     => part_no_,
                                                                    configuration_id_            => configuration_id_,
                                                                    location_no_                 => location_no_,
                                                                    lot_batch_no_                => lot_batch_no_,
                                                                    serial_no_                   => serial_no_,
                                                                    waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                    eng_chg_level_               => lov_value_tab_(i),
                                                                    activity_seq_                => activity_seq_,
                                                                    handling_unit_id_            => handling_unit_id_,
                                                                    alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                    receiver_id_                 => receiver_id_,
                                                                    condition_code_              => condition_code_,
                                                                    column_name_                 => 'PART_NO',
                                                                    sql_where_expression_        => sql_where_expression_);
                     ELSIF column_name_ = 'WAIV_DEV_REJ_NO' THEN
                        temp_part_no_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                    shipment_id_                 => shipment_id_,
                                                                    source_ref1_                 => source_ref1_,
                                                                    source_ref2_                 => source_ref2_,
                                                                    source_ref3_                 => source_ref3_,
                                                                    source_ref4_                 => source_ref4_,
                                                                    source_ref_type_db_          => source_ref_type_db_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    part_no_                     => part_no_,
                                                                    configuration_id_            => configuration_id_,
                                                                    location_no_                 => location_no_,
                                                                    lot_batch_no_                => lot_batch_no_,
                                                                    serial_no_                   => serial_no_,
                                                                    waiv_dev_rej_no_             => lov_value_tab_(i),
                                                                    eng_chg_level_               => eng_chg_level_,
                                                                    activity_seq_                => activity_seq_,
                                                                    handling_unit_id_            => handling_unit_id_,
                                                                    alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                    receiver_id_                 => receiver_id_,
                                                                    condition_code_              => condition_code_,
                                                                    column_name_                 => 'PART_NO',
                                                                    sql_where_expression_        => sql_where_expression_);
                     END IF;
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, temp_part_no_);
                  ELSIF (second_column_name_ = 'RECEIVER_DESC') THEN
                     IF column_name_ = 'SOURCE_REF1' THEN
                        temp_shipment_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                        shipment_id_                 => shipment_id_,
                                                                        source_ref1_                 => lov_value_tab_(i),
                                                                        source_ref2_                 => source_ref2_,
                                                                        source_ref3_                 => source_ref3_,
                                                                        source_ref4_                 => source_ref4_,
                                                                        source_ref_type_db_          => source_ref_type_db_,
                                                                        pick_list_no_                => pick_list_no_,
                                                                        part_no_                     => part_no_,
                                                                        configuration_id_            => configuration_id_,
                                                                        location_no_                 => location_no_,
                                                                        lot_batch_no_                => lot_batch_no_,
                                                                        serial_no_                   => serial_no_,
                                                                        waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                        eng_chg_level_               => eng_chg_level_,
                                                                        activity_seq_                => activity_seq_,
                                                                        handling_unit_id_            => handling_unit_id_,
                                                                        alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                        receiver_id_                 => receiver_id_,
                                                                        condition_code_              => condition_code_,
                                                                        column_name_                 => 'SHIPMENT_ID',
                                                                        sql_where_expression_        => sql_where_expression_);
                        
                        IF temp_shipment_id_ IS NULL OR temp_shipment_id_ = 0 THEN
                           temp_reciever_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                           shipment_id_                 => shipment_id_,
                                                                           source_ref1_                 => lov_value_tab_(i),
                                                                           source_ref2_                 => source_ref2_,
                                                                           source_ref3_                 => source_ref3_,
                                                                           source_ref4_                 => source_ref4_,
                                                                           source_ref_type_db_          => source_ref_type_db_,
                                                                           pick_list_no_                => pick_list_no_,
                                                                           part_no_                     => part_no_,
                                                                           configuration_id_            => configuration_id_,
                                                                           location_no_                 => location_no_,
                                                                           lot_batch_no_                => lot_batch_no_,
                                                                           serial_no_                   => serial_no_,
                                                                           waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                           eng_chg_level_               => eng_chg_level_,
                                                                           activity_seq_                => activity_seq_,
                                                                           handling_unit_id_            => handling_unit_id_,
                                                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                           receiver_id_                 => receiver_id_,
                                                                           condition_code_              => condition_code_,
                                                                           column_name_                 => 'RECEIVER_ID',
                                                                           sql_where_expression_        => sql_where_expression_);
                        END IF;
                        
                     ELSIF column_name_ = 'SOURCE_REF2' THEN
                        temp_shipment_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                        shipment_id_                 => shipment_id_,
                                                                        source_ref1_                 => source_ref1_,
                                                                        source_ref2_                 => lov_value_tab_(i),
                                                                        source_ref3_                 => source_ref3_,
                                                                        source_ref4_                 => source_ref4_,
                                                                        source_ref_type_db_          => source_ref_type_db_,
                                                                        pick_list_no_                => pick_list_no_,
                                                                        part_no_                     => part_no_,
                                                                        configuration_id_            => configuration_id_,
                                                                        location_no_                 => location_no_,
                                                                        lot_batch_no_                => lot_batch_no_,
                                                                        serial_no_                   => serial_no_,
                                                                        waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                        eng_chg_level_               => eng_chg_level_,
                                                                        activity_seq_                => activity_seq_,
                                                                        handling_unit_id_            => handling_unit_id_,
                                                                        alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                        receiver_id_                 => receiver_id_,
                                                                        condition_code_              => condition_code_,
                                                                        column_name_                 => 'SHIPMENT_ID',
                                                                        sql_where_expression_        => sql_where_expression_);
                        
                        IF temp_shipment_id_ IS NULL OR temp_shipment_id_ = 0 THEN
                           temp_reciever_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                           shipment_id_                 => shipment_id_,
                                                                           source_ref1_                 => source_ref1_,
                                                                           source_ref2_                 => lov_value_tab_(i),
                                                                           source_ref3_                 => source_ref3_,
                                                                           source_ref4_                 => source_ref4_,
                                                                           source_ref_type_db_          => source_ref_type_db_,
                                                                           pick_list_no_                => pick_list_no_,
                                                                           part_no_                     => part_no_,
                                                                           configuration_id_            => configuration_id_,
                                                                           location_no_                 => location_no_,
                                                                           lot_batch_no_                => lot_batch_no_,
                                                                           serial_no_                   => serial_no_,
                                                                           waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                           eng_chg_level_               => eng_chg_level_,
                                                                           activity_seq_                => activity_seq_,
                                                                           handling_unit_id_            => handling_unit_id_,
                                                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                           receiver_id_                 => receiver_id_,
                                                                           condition_code_              => condition_code_,
                                                                           column_name_                 => 'RECEIVER_ID',
                                                                           sql_where_expression_        => sql_where_expression_);
                        END IF;
                        
                     ELSIF column_name_ = 'SOURCE_REF3' THEN
                        temp_shipment_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                        shipment_id_                 => shipment_id_,
                                                                        source_ref1_                 => source_ref1_,
                                                                        source_ref2_                 => source_ref2_,
                                                                        source_ref3_                 => lov_value_tab_(i),
                                                                        source_ref4_                 => source_ref4_,
                                                                        source_ref_type_db_          => source_ref_type_db_,
                                                                        pick_list_no_                => pick_list_no_,
                                                                        part_no_                     => part_no_,
                                                                        configuration_id_            => configuration_id_,
                                                                        location_no_                 => location_no_,
                                                                        lot_batch_no_                => lot_batch_no_,
                                                                        serial_no_                   => serial_no_,
                                                                        waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                        eng_chg_level_               => eng_chg_level_,
                                                                        activity_seq_                => activity_seq_,
                                                                        handling_unit_id_            => handling_unit_id_,
                                                                        alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                        receiver_id_                 => receiver_id_,
                                                                        condition_code_              => condition_code_,
                                                                        column_name_                 => 'SHIPMENT_ID',
                                                                        sql_where_expression_        => sql_where_expression_);
                        
                        IF temp_shipment_id_ IS NULL OR temp_shipment_id_ = 0 THEN
                           temp_reciever_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                           shipment_id_                 => shipment_id_,
                                                                           source_ref1_                 => source_ref1_,
                                                                           source_ref2_                 => source_ref2_,
                                                                           source_ref3_                 => lov_value_tab_(i),
                                                                           source_ref4_                 => source_ref4_,
                                                                           source_ref_type_db_          => source_ref_type_db_,
                                                                           pick_list_no_                => pick_list_no_,
                                                                           part_no_                     => part_no_,
                                                                           configuration_id_            => configuration_id_,
                                                                           location_no_                 => location_no_,
                                                                           lot_batch_no_                => lot_batch_no_,
                                                                           serial_no_                   => serial_no_,
                                                                           waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                           eng_chg_level_               => eng_chg_level_,
                                                                           activity_seq_                => activity_seq_,
                                                                           handling_unit_id_            => handling_unit_id_,
                                                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                           receiver_id_                 => receiver_id_,
                                                                           condition_code_              => condition_code_,
                                                                           column_name_                 => 'RECEIVER_ID',
                                                                           sql_where_expression_        => sql_where_expression_);
                        END IF;
                        
                     ELSIF column_name_ = 'SOURCE_REF4' THEN
                        temp_shipment_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                        shipment_id_                 => shipment_id_,
                                                                        source_ref1_                 => source_ref1_,
                                                                        source_ref2_                 => source_ref2_,
                                                                        source_ref3_                 => source_ref3_,
                                                                        source_ref4_                 => lov_value_tab_(i),
                                                                        source_ref_type_db_          => source_ref_type_db_,
                                                                        pick_list_no_                => pick_list_no_,
                                                                        part_no_                     => part_no_,
                                                                        configuration_id_            => configuration_id_,
                                                                        location_no_                 => location_no_,
                                                                        lot_batch_no_                => lot_batch_no_,
                                                                        serial_no_                   => serial_no_,
                                                                        waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                        eng_chg_level_               => eng_chg_level_,
                                                                        activity_seq_                => activity_seq_,
                                                                        handling_unit_id_            => handling_unit_id_,
                                                                        alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                        receiver_id_                 => receiver_id_,
                                                                        condition_code_              => condition_code_,
                                                                        column_name_                 => 'SHIPMENT_ID',
                                                                        sql_where_expression_        => sql_where_expression_);
                        
                        IF temp_shipment_id_ IS NULL OR temp_shipment_id_ = 0 THEN
                           temp_reciever_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                           shipment_id_                 => shipment_id_,
                                                                           source_ref1_                 => source_ref1_,
                                                                           source_ref2_                 => source_ref2_,
                                                                           source_ref3_                 => source_ref3_,
                                                                           source_ref4_                 => lov_value_tab_(i),
                                                                           source_ref_type_db_          => source_ref_type_db_,
                                                                           pick_list_no_                => pick_list_no_,
                                                                           part_no_                     => part_no_,
                                                                           configuration_id_            => configuration_id_,
                                                                           location_no_                 => location_no_,
                                                                           lot_batch_no_                => lot_batch_no_,
                                                                           serial_no_                   => serial_no_,
                                                                           waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                           eng_chg_level_               => eng_chg_level_,
                                                                           activity_seq_                => activity_seq_,
                                                                           handling_unit_id_            => handling_unit_id_,
                                                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                           receiver_id_                 => receiver_id_,
                                                                           condition_code_              => condition_code_,
                                                                           column_name_                 => 'RECEIVER_ID',
                                                                           sql_where_expression_        => sql_where_expression_);
                        END IF;
                        
                     END IF;
                     
                     IF temp_shipment_id_ IS NOT NULL AND temp_shipment_id_ != 0 THEN 
                        second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(Shipment_API.Get_Receiver_Id(temp_shipment_id_), 
                                                                                              Shipment_API.Get_Receiver_Type_Db(temp_shipment_id_));                                                                                                         
                     ELSE 
                        -- This solution might have to be changed when the data source support other sources then customer order  
                        second_column_value_ := Customer_Info_API.Get_Name(temp_reciever_id_);
                     END IF;
                     
                  ELSIF (second_column_name_ = 'RECEIVER_ID_RECEIVER_DESC') THEN
                     temp_shipment_id_ := Get_Column_Value_If_Unique(contract_                    => contract_,
                                                                     shipment_id_                 => shipment_id_,
                                                                     source_ref1_                 => source_ref1_,
                                                                     source_ref2_                 => source_ref2_,
                                                                     source_ref3_                 => source_ref3_,
                                                                     source_ref4_                 => source_ref4_,
                                                                     source_ref_type_db_          => source_ref_type_db_,
                                                                     pick_list_no_                => pick_list_no_,
                                                                     part_no_                     => part_no_,
                                                                     configuration_id_            => configuration_id_,
                                                                     location_no_                 => location_no_,
                                                                     lot_batch_no_                => lot_batch_no_,
                                                                     serial_no_                   => serial_no_,
                                                                     waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                     eng_chg_level_               => eng_chg_level_,
                                                                     activity_seq_                => activity_seq_,
                                                                     handling_unit_id_            => handling_unit_id_,
                                                                     alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                     receiver_id_                 => lov_value_tab_(i),
                                                                     condition_code_              => condition_code_,
                                                                     column_name_                 => 'SHIPMENT_ID',
                                                                     sql_where_expression_        => sql_where_expression_);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(lov_value_tab_(i), 
                                                                                           Shipment_API.Get_Receiver_Type_Db(temp_shipment_id_));
                  ELSIF (second_column_name_ = 'CONDITION_CODE_DESCRIPTION') THEN
                     second_column_value_ := Condition_Code_API.Get_Description(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'LOCATION_NO_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'PROJECT_ID') THEN
                     $IF (Component_Proj_SYS.INSTALLED) $THEN
                        second_column_value_ := Activity_API.Get_Project_Id(lov_value_tab_(i));
                     $ELSE
                        NULL;
                     $END
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN
                     IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                        temp_handling_unit_id_ := lov_value_tab_(i);
                     ELSIF (column_name_ = 'SSCC') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                     ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     END IF;
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                     lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCapProcessHuShip
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,  
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2, -- send '%' if this item have not been entered/scanned yet
   sscc_                       IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)  
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(2000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   lov_item_description_     VARCHAR2(200);
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
   temp_handling_unit_id_    NUMBER;
   temp_location_des_        VARCHAR2(200);
   temp_location_type_       VARCHAR2(200);
BEGIN
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDL_UNIT_IN_SHIP_INV_ALT', column_name_);
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;
      
      -- Removed user_allowed_site_pub check since it already exist in the views used by this view and it was never used in Get_Column_Value_If_Unique/Record_With_Column_Value_Exist
      stmt_ := 'SELECT ' || column_name_ || '
             FROM  HANDL_UNIT_IN_SHIP_INV_ALT ';
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' WHERE :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' WHERE handling_unit_id = :handling_unit_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;
      stmt_ := stmt_ || ' AND contract = :contract_ ';
      
      IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      
      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
      
      @ApproveDynamicStatement(2017-10-31,SURBLK)
      OPEN get_lov_values_ FOR stmt_ USING   handling_unit_id_,
                                             sscc_,
                                             alt_handling_unit_label_id_,
                                             location_no_,
                                             contract_;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         
         IF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
         ELSIF (column_name_ IN ('LOCATION_NO')) THEN
            second_column_name_ := 'LOCATION_NO_DESCRIPTION';   
         END IF;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP        
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN                     
                  IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (column_name_ = 'SSCC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  END IF;
                  second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));                                    
               ELSIF (second_column_name_ = 'LOCATION_NO_DESCRIPTION') THEN
                  temp_location_des_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  temp_location_type_ := Inventory_Location_API.Get_Location_Type(contract_, lov_value_tab_(i));
                  IF (temp_location_des_ IS NOT NULL) THEN
                     second_column_value_ := temp_location_des_ || ' | ' || temp_location_type_;
                  ELSE
                     second_column_value_ := temp_location_type_;
                  END IF;
               END IF;
               IF (second_column_value_ IS NOT NULL) THEN
                  lov_item_description_ := second_column_value_;
               ELSE
                  lov_item_description_ := NULL;
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
      
   $ELSE
      NULL;
   $END
   
END Create_Data_Capture_Lov;


PROCEDURE Add_Detail_For_Ship_Inv_Hu (
   capture_session_id_         IN NUMBER,
   owning_data_item_id_        IN VARCHAR2,
   data_item_detail_id_        IN VARCHAR2,
   contract_                   IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2)
IS
   feedback_item_value_          VARCHAR2(200);
   mixed_item_value_             VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
   no_unique_value_found_        BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      feedback_item_value_ := Get_Column_Value_If_Unique(no_unique_value_found_      => no_unique_value_found_,              
                                                         contract_                   => contract_,
                                                         location_no_                => location_no_,
                                                         handling_unit_id_           => handling_unit_id_,
                                                         sscc_                       => sscc_,
                                                         alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                         column_name_                => data_item_detail_id_);
      
      -- Too many found      
      IF (no_unique_value_found_ = FALSE AND feedback_item_value_ IS NULL ) THEN
         feedback_item_value_ := mixed_item_value_;
      END IF ; 
      
      feedback_item_value_ := CASE feedback_item_value_ WHEN 'NULL' THEN NULL ELSE feedback_item_value_ END;   
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
END Add_Detail_For_Ship_Inv_Hu;


-- This method is used by DataCapProcessPartShip
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   receiver_id_                IN VARCHAR2,
   condition_code_             IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(8000);
   unique_column_value_           VARCHAR2(200);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   Assert_SYS.Assert_Is_View_Column('HANDLE_SOURCES_IN_SHIPMENT_INV', column_name_);
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM  HANDLE_SOURCES_IN_SHIPMENT_INV ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
   END IF;
   IF source_ref1_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
   END IF;      
   IF source_ref2_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
   END IF;      
   IF source_ref3_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref3_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
   END IF;      
   IF source_ref4_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref4_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
   END IF;      
   IF source_ref_type_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
   END IF;      
   IF pick_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
   END IF;      
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;      
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;      
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;      
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;   
   IF condition_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND condition_code is NULL AND :condition_code_ IS NULL';
   ELSIF condition_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :condition_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND condition_code = :condition_code_';
   END IF;
   stmt_ := stmt_  || ' AND   contract = :contract_
             AND   location_type_db = ''SHIPMENT''
             AND   qty_picked > 0 ';
   
   IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2015-03-13,RILASE)
   OPEN get_column_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           pick_list_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           receiver_id_,
                                           condition_code_,
                                           contract_;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF;
CLOSE get_column_values_;

RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapProcessHuShip
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_      OUT BOOLEAN,
   contract_                   IN  VARCHAR2,
   location_no_                IN  VARCHAR2,
   handling_unit_id_           IN  NUMBER,
   sscc_                       IN  VARCHAR2,
   alt_handling_unit_label_id_ IN  VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN  VARCHAR2,
   sql_where_expression_       IN  VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(8000);
   unique_column_value_           VARCHAR2(200);
   too_many_values_found_         BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab;
   -- TODO: this method had changed the data source view from HANDL_UNIT_IN_SHIP_INV_ALT to HANDLE_SOURCE_IN_SHIP_INV_ALT due to STRSC-16141 
   -- which was about details/feedback issues connected to from/to location. Not sure if that was necessary or not, maybe some data was only in 
   -- one of the views. But in that case maybe this method should have had the cursor_id parameter solution instead so we could just switch the
   -- the view then it was called for feedbacks and still have the old view for normal automatic handling. Might be something to investigate later on, 
   -- especially if we get performance/data inconsistency issues for the hu shipment inventory processes, since current view is mainly used for 
   -- the part variants of the processes. Also note that HANDLE_SOURCE_IN_SHIP_INV_ALT is a view in order and not in shpmnt and is not the same view used 
   -- in the part processes here either so maybe a new method on the order package where this view exist should be created and used for feedbacks.
   -- We might have inconsistency now in some cases on sscc/alt_handling_unit_label_id where automatic handling dont get the same result as LOV method.  
BEGIN
   Assert_SYS.Assert_Is_View_Column('HANDLE_SOURCE_IN_SHIP_INV_ALT', column_name_);
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM  HANDLE_SOURCE_IN_SHIP_INV_ALT ';
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE handling_unit_id = :handling_unit_id_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_ ';
   
   IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
   
   @ApproveDynamicStatement(2017-10-31,SURBLK)
   OPEN get_column_values_ FOR stmt_ USING handling_unit_id_,
                                          sscc_,
                                          alt_handling_unit_label_id_, 
                                          location_no_,
                                          contract_;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');  
   ELSIF (column_value_tab_.COUNT = 2) THEN  
      too_many_values_found_ := TRUE; -- more then one unique value found
   END IF;
CLOSE get_column_values_;


   -- If no values was found at all then set no_unique_value_found_ out-param to TRUE else set it to FALSE. 
   -- This to be able to see the why this method returned NULL so we can know if it was because no values 
   -- was found at all or if it was because to many values was found. This can be used in process utilities which
   -- fetch unique values from several data sources for a specific data item, so that utility can check if 
   -- there was a combined unique value from the data sources or not. Used for detail/feedback handling in this case.
IF (unique_column_value_ IS NULL AND NOT too_many_values_found_) THEN 
   no_unique_value_found_ := TRUE;    -- no records found
ELSE
   no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
END IF;

RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapProcessPartShip
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   receiver_id_                IN VARCHAR2,
   condition_code_             IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(8000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('HANDLE_SOURCES_IN_SHIPMENT_INV', column_name_);
   
   stmt_ := 'SELECT 1
             FROM  HANDLE_SOURCES_IN_SHIPMENT_INV ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
   END IF;
   IF source_ref1_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
   END IF;      
   IF source_ref2_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
   END IF;      
   IF source_ref3_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref3_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
   END IF;      
   IF source_ref4_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref4_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
   END IF;      
   IF source_ref_type_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
   END IF;      
   IF pick_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
   END IF;      
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;      
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;      
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;      
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;   
   IF condition_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND condition_code is NULL AND :condition_code_ IS NULL';
   ELSIF condition_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :condition_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND condition_code = :condition_code_';
   END IF;
   stmt_ := stmt_  || ' AND   contract = :contract_
             AND   location_type_db = ''SHIPMENT''
             AND   qty_picked > 0 ';
   
   IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   
   @ApproveDynamicStatement(2015-03-13,RILASE)
   OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
                                       source_ref4_,
                                       source_ref_type_db_,
                                       pick_list_no_,
                                       part_no_,
                                       configuration_id_,
                                       location_no_,
                                       lot_batch_no_,
                                       serial_no_,
                                       waiv_dev_rej_no_,
                                       eng_chg_level_,
                                       activity_seq_,
                                       handling_unit_id_,
                                       alt_handling_unit_label_id_,
                                       receiver_id_,
                                       condition_code_,
                                       contract_,
                                       column_value_,
                                       column_value_;
   
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Raise_Value_Context_Error___(column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCapProcessHuShip
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(8000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('HANDL_UNIT_IN_SHIP_INV_ALT', column_name_);
   
   stmt_ := 'SELECT 1 
             FROM  HANDL_UNIT_IN_SHIP_INV_ALT ';
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE handling_unit_id = :handling_unit_id_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_ ';  
   
   IF(sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
   END IF;
   
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   
   @ApproveDynamicStatement(2017-11-20,SURBLK)
   OPEN exist_control_ FOR stmt_ USING handling_unit_id_,
                                          sscc_,
                                          alt_handling_unit_label_id_, 
                                          location_no_,
                                          contract_,
                                          column_value_,
                                          column_value_;
   
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Raise_Value_Context_Error___(column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


@UncheckedAccess
FUNCTION Get_Default_Shipment_Location(
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER DEFAULT 0,
   sender_type_        IN VARCHAR2 DEFAULT NULL,
   sender_id_          IN VARCHAR2 DEFAULT NULL,
   receiver_type_      IN VARCHAR2 DEFAULT NULL,
   receiver_id_        IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   ship_location_no_ VARCHAR2(35);
BEGIN
   IF(shipment_id_ = 0)THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
            ship_location_no_ := Customer_Order_API.Get_Default_Shipment_Location(source_ref1_);
         END IF;
      $ELSIF Component_Shipod_SYS.INSTALLED $THEN
         IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
            ship_location_no_ := Ship_Order_Defaults_Util_API.Get_Default_Shipment_Location(sender_type_, sender_id_, receiver_type_, receiver_id_);
         END IF;
      $ELSE
         NULL;
      $END
   ELSE
      ship_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
   END IF;
   
   RETURN ship_location_no_;
END Get_Default_Shipment_Location;


@UncheckedAccess
FUNCTION Get_Default_Shipment_Location (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER DEFAULT 0,
   sender_type_        IN VARCHAR2 DEFAULT NULL,
   sender_id_          IN VARCHAR2 DEFAULT NULL,
   receiver_type_      IN VARCHAR2 DEFAULT NULL,
   receiver_id_        IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   ship_location_no_ VARCHAR2(35);
BEGIN
   IF(NVL(shipment_id_, 0) = 0)THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
            ship_location_no_ := Customer_Order_Line_API.Get_Default_Shipment_Location(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
         END IF;
      $ELSIF Component_Shipod_SYS.INSTALLED $THEN
         IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
            ship_location_no_ := Ship_Order_Defaults_Util_API.Get_Default_Shipment_Location(sender_type_, sender_id_, receiver_type_, receiver_id_);
         END IF;
      $ELSE
         NULL;
      $END
   ELSE
      ship_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
   END IF;

   RETURN ship_location_no_;
END Get_Default_Shipment_Location;


--Checks the pick list type for pick inventory type. If it is Customer Order, fetch it from the header.
--All other sources at this time uses shipment inventory.
@UncheckedAccess
FUNCTION Uses_Shipment_Inventory (
   pick_list_no_   IN VARCHAR2,
   pick_list_type_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   local_pick_list_type_ Pick_Report_Pick_List.pick_list_type%TYPE;
   pick_inventory_type_  VARCHAR2(7);
BEGIN
   local_pick_list_type_ := NVL(pick_list_type_, Pick_Shipment_API.Get_Pick_List_Type(pick_list_no_));
   IF local_pick_list_type_ = 'CUST_ORDER_PICK_LIST' THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         pick_inventory_type_ := Customer_Order_Pick_List_API.Get_Pick_Inventory_Type_Db(pick_list_no_);
      $ELSE
         NULL;   
      $END
   ELSIF (local_pick_list_type_ = 'INVENTORY_PICK_LIST') THEN
      pick_inventory_type_ := 'SHIPINV';
   END IF;
   
   RETURN CASE WHEN pick_inventory_type_ = 'SHIPINV' THEN 1 ELSE 0 END;
END Uses_Shipment_Inventory;

-- Checks if a specific source uses Shipment Inventory. At the time, other sources is using shipment.
@UncheckedAccess
FUNCTION Uses_Shipment_Inventory (   
                                     source_ref1_        IN VARCHAR2,
                                     source_ref2_        IN VARCHAR2,
                                     source_ref3_        IN VARCHAR2,
                                     source_ref4_        IN VARCHAR2,
                                     source_ref_type_db_ IN VARCHAR2,
                                     shipment_id_        IN NUMBER ) RETURN NUMBER
IS   
   uses_shipment_inventory_  NUMBER := 0;
BEGIN
   -- Shipment Inventory is mandatory for Shipments.
   IF (NVL(shipment_id_, 0) != 0) THEN
      uses_shipment_inventory_ := 1;
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         uses_shipment_inventory_ := Customer_Order_Line_API.Uses_Shipment_Inventory(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN uses_shipment_inventory_;
END Uses_Shipment_Inventory;


FUNCTION Get_Shipment_Inv_Location_No (
   contract_    IN VARCHAR2,
   sender_type_ IN VARCHAR2,
   sender_id_   IN VARCHAR2) RETURN VARCHAR2
IS
   location_no_   VARCHAR2(35);
   
   CURSOR get_inventory_location IS
      SELECT location_no
      FROM inventory_location
      WHERE (((sender_type_ IS NULL) OR
            (sender_type_ = 'SITE' AND Warehouse_API.Get_Remote_Warehouse_Db(contract, warehouse) = 'FALSE') OR
            (sender_type_ = 'REMOTE_WAREHOUSE' AND warehouse = Warehouse_API.Get_Warehouse_Id_By_Global_Id(sender_id_))) AND
            (Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group) = 'SHIPMENT' AND contract = contract_))
      ORDER BY location_no;   
BEGIN
   FOR record_ IN get_inventory_location LOOP
      IF NOT(Warehouse_Bay_Bin_API.Receipts_Blocked(contract_, record_.location_no)) THEN 
         location_no_ := record_.location_no;
         EXIT;
      END IF;
   END LOOP; 
   RETURN location_no_;
END Get_Shipment_Inv_Location_No;


PROCEDURE Get_Shipment_Inv_Location(
   show_dialog_       OUT VARCHAR2,
   ship_inv_location_ OUT VARCHAR2,
   shipment_id_       IN  NUMBER)
IS
   shipment_type_             VARCHAR2(3);
   confirm_shipment_location_ VARCHAR2(5);
   valid_pick_list_           VARCHAR2(5);
   contract_                  VARCHAR2(5);
BEGIN
   ship_inv_location_         := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
   shipment_type_             := Shipment_API.Get_Shipment_Type(shipment_id_);
   confirm_shipment_location_ := Shipment_Type_API.Get_Confirm_Ship_Loc_No_Db(shipment_type_);
   valid_pick_list_           := Pick_Shipment_API.Validate_Shipment_Pick_Lists(shipment_id_);
   contract_                  := Shipment_API.Get_Contract(shipment_id_);
   
   Check_For_Valid_Ship_Loc__(contract_);
   
   IF (confirm_shipment_location_ = 'TRUE' OR valid_pick_list_ = 'FALSE') THEN
      show_dialog_ := 'TRUE';
   ELSE
      show_dialog_ := 'FALSE';
   END IF;
END Get_Shipment_Inv_Location;


PROCEDURE Get_Shipment_Inv_Location(
   show_dialog_         OUT VARCHAR2,
   ship_inv_location_   OUT VARCHAR2,
   contract_            IN  VARCHAR2,
   pick_list_type_attr_ IN  VARCHAR2)
IS
   confirm_ship_inv_location_    NUMBER := 1;
BEGIN   
   Pick_Shipment_API.Get_Ship_Inv_Loc_And_Confirm__(ship_inv_location_, confirm_ship_inv_location_, pick_list_type_attr_, contract_);
   Check_For_Valid_Ship_Loc__(contract_);
   
   IF (confirm_ship_inv_location_ = 1 OR ship_inv_location_ IS NULL) THEN
      show_dialog_ := 'TRUE';
   ELSE
      show_dialog_ := 'FALSE';
   END IF;
   
END Get_Shipment_Inv_Location;


PROCEDURE Get_Ship_Inv_Location(
   show_dialog_       OUT VARCHAR2,
   ship_inv_location_ OUT VARCHAR2,
   contract_          IN  VARCHAR2,
   pick_list_no_      IN  VARCHAR2,
   pick_list_type_    IN  VARCHAR2)
IS
   attr_                VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_TYPE', pick_list_type_, attr_);
   Get_Shipment_Inv_Location(show_dialog_, ship_inv_location_, contract_, attr_);
END Get_Ship_Inv_Location;


PROCEDURE Get_Shipment_Inv_Location(
   show_dialog_        OUT VARCHAR2,
   ship_inv_location_  OUT VARCHAR2,
   contract_           IN  VARCHAR2,
   source_ref1_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2)
IS
   confirm_ship_inv_location_    NUMBER := 1;
BEGIN
   ship_inv_location_         := Get_Default_Shipment_Location(source_ref1_, source_ref_type_db_);
   confirm_ship_inv_location_ := Pick_Shipment_API.Check_Confirm_Ship_Location(source_ref1_, source_ref_type_db_);
   Check_For_Valid_Ship_Loc__(contract_);
   
   IF (confirm_ship_inv_location_ = 1 OR ship_inv_location_ IS NULL) THEN
      show_dialog_ := 'TRUE';
   ELSE
      show_dialog_ := 'FALSE';
   END IF;
END Get_Shipment_Inv_Location;


PROCEDURE Get_Shipment_Inv_Location(
   show_dialog_        OUT VARCHAR2,
   ship_inv_location_  OUT VARCHAR2,
   contract_           IN  VARCHAR2,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2,
   shipment_id_        IN  NUMBER,
   sender_type_        IN  VARCHAR2 DEFAULT NULL,
   sender_id_          IN  VARCHAR2 DEFAULT NULL,
   receiver_type_      IN  VARCHAR2 DEFAULT NULL,
   receiver_id_        IN  VARCHAR2 DEFAULT NULL)
IS
   confirm_ship_inv_location_    NUMBER := 1;
BEGIN
   ship_inv_location_         := Get_Default_Shipment_Location(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, sender_type_, sender_id_, receiver_type_, receiver_id_);
   confirm_ship_inv_location_ := Pick_Shipment_API.Check_Confirm_Ship_Location(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_);
   Check_For_Valid_Ship_Loc__(contract_);
   
   IF (confirm_ship_inv_location_ = 1 OR ship_inv_location_ IS NULL) THEN
      show_dialog_ := 'TRUE';
   ELSE
      show_dialog_ := 'FALSE';
   END IF;
END Get_Shipment_Inv_Location;


