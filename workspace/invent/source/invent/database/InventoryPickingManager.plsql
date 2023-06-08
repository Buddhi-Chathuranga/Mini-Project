-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPickingManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211207  PamPlk  SC21R2-2979, Added Check_Source_Ref_Type_Db__ and modified Pick_By_Choice, Pick_Hu_By_Choice in order to restrict Pick_By_Choice for Purchase Receipt Return.
--  201105  ErRalk  SC2020R1-11001, Modified methods Unreserve_Handling_Unit___, Pick_Hu_By_Choice_Allowed and Pick_Hu_Reservations___ to support Pick Handling Unit By Choice for Shipment Order and Project Deliverables.
--  200903  ErRalk  SC2020R1-7302, Modified Pick_Stock_Reservations___ to support for Shipment Order and Project Deliverables.
--  200225  DaZase  Bug 152587 (SCZ-9158), Modified Get_Hu_Reservation_Content___ to include an extra reservation loop so several serial reservations on same HU will work again.
--  200206  Rulilk  Bug 152261 (SCZ-8411), Modified Get_Hu_Reservation_Content___ by replacing CONNECT BY PRIO with FOR loop handling to improve performance.
--  191029  RuLiLk  Bug 149974 (SCZ-6834), Modified method Pick_Hu_By_Choice_Allowed by removing Connect by Prio used in cursor. Replaced it with Handling_Unit_API.Get_Node_And_Descendants to improve performance.
--  191023  SWiclk  Bug 150632 (SCZ-6808), Modified Pick_By_Choice_Allowed() by removing NVL in Where statement.
--  190927  SURBLK  Added Raise_Picking_Not_Allowed_Error___ to handle error messages and avoid code duplication.
--  190821  BudKlk  Bug 149616 (SCZ-6398), Modified the file to replace INV_PART_STOCK_RESERVATION from INV_PART_STOCK_RES_MOVE in order to fetch correct keys of customer order reservation when the source is from 'Distribution Order'.
--  190821          Reverted the correction of the Bug 144952.
--  190624  BudKlk  Bug 148910 (SCZ-5481), Modified the method Pick_Hu_By_Choice() to get the database value of the variable has_reservation to avoid buffer string error when using from other languages. 
--  190617  ShPrlk  Bug 148455 (SCZ-5011), Replaced the Source_Ref_Type_Tab structure of pick_by_choice_src_type_tab_ to individual constants
--  190617          to reduce performance overheads.
--  181027  ChBnlk  Bug 144952, Modified Unreserve_Handling_Unit___() in order to fetch keys of the customer order reservation if the returned record is a distribution order.
--  180223  KHVESE  STRSC-15956, Modified method Reserve_Stock___.
--  180209  JeLise  STRSC-16913, Added pick_by_choice_blocked_db to Inv_Part_In_Stock_Res_Rec and updated Find_Reservations___ and 
--  180209          Get_Hu_Reservation_Content___ to fetch pick_by_choice_blocked_db. Also added new parameter in call to 
--  180209          Inv_Part_Stock_Reservation_API.Get_Pick_By_Choice_Blocked_Db in Pick_By_Choice.
--  180124  JoAnSe  STRMF-17200, Added WHEN OTHERS to Pick_By_Choice and Puck_HU_By_Choice and also NVL for qty_reserved_ to handle case when an exception is raised.
--  171213  MaAuse  STRSC-15088, Added parameter trigger_shipment_flow_ in Pick_By_Choice, Pick_Stock_Reservations___, Pick_Hu_Reservations___ and Pick_Hu_By_Choice.
--  171125  JeLise  STRSC-14745, Added check on pick_by_choice_blocked in Pick_Hu_By_Choice.
--  171122  JeLise  STRSC-14497, Added check on pick_by_choice_blocked in Pick_By_Choice.
--  171102  ChFolk  STRSC-14015, Modifed message constant SAMESTOCKKEYS in method Check_Handl_Unit_Attributes___ to a different name as the same constant exists with a different description.
--  171102          Added new method Raise_Pick_Choice_Not_Allowed___ which centralize the error constant SOURCEREFTYPEERROR and it is used in calling places.  
--  170727  JoAnSe  STRSC-11019, Changes in cursor in Find_Reservations___ to support DOP reservation for which qty_picked will be NULL.
--  170718  MAHPLK  STRSC-10837, Modified Reserve_Stock___ to pass the Inv_Part_Stock_Reservation_API.Transport_Task_Line_Rec as parameter  to handle the reservation for transport task line. 
--  170512  KhVese  STRSC-8416, Modified method Remove_Duplicate_Source_Ref___.
--  170427  KhVese  STRSC-7211, Modified methods Find_Reservations__ , Pick_By_Choice_Allowed, Pick_Hu_By_Choice_Allowed, Find_And_Reserve_Stock___, Reserve_Stock___, Unreserve_Stock___ and Unreserve_Handling_Unit___.
--  170328  KhVese  LIM-10884, Modified method Pick_By_Choice and Pick_Hu_By_Choice to reserve new stock records for current pick list first and then pick all new reservation.
--  170323  KhVese  LIM-10485, Added new parameter add_hu_to_shipment_ to interface of Pick_Stock_Reservations___ and Unpack_Attribute_string___ 
--  170323          used in customer order pick reservation and modified Pick_By_Choice method accordingly.
--  170228  KhVese  LIM-5836, Modified method Pick_Hu_By_Choice_Allowed to include initial reservation when pick by choice option is set to not allow reserved or pick listed stock.
--  170213  KhVese  LIM-10625, Modified method Pick_By_Choice_Allowed to include initial reservation when pick by choice option is allowed or not printed pick list.
--  170207  KhVese  LIM-10625, Added parameter pick_list_no_ to methods Pick_By_Choice_Allowed and Pick_HU_By_Choice_Allowed.
--  170206  JoAnSe  LIM-10624, Added support for picking of handling units for shop order material lines.
--  170206  KHVESE  LIM-10242, Moved the code for pick handling by choice from ReserveCustomeOrder and PickCustomerOrder to this LU.
--  170113  KHVESE  LIM-10241, Created and moved the code for pick by choice from ReserveCustomeOrder and PickCustomerOrder to this LU.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Inv_Part_In_Stock_Res_Rec IS RECORD (
   source_ref1               VARCHAR2(50),
   source_ref2               VARCHAR2(50),
   source_ref3               VARCHAR2(50),
   source_ref4               NUMBER,
   source_ref_type_db        VARCHAR2(50),
   contract                  VARCHAR2(5),
   part_no                   VARCHAR2(25),
   configuration_id          VARCHAR2(50),
   location_no               VARCHAR2(35),
   lot_batch_no              VARCHAR2(20),
   serial_no                 VARCHAR2(50),
   eng_chg_level             VARCHAR2(6),
   waiv_dev_rej_no           VARCHAR2(15),                  
   activity_seq              NUMBER,
   handling_unit_id          NUMBER,
   pick_list_no              VARCHAR2(40),
   shipment_id               NUMBER,
   quantity                  NUMBER,
   active                    VARCHAR2(5),  --TRUE/FALSE
   pick_by_choice_blocked_db VARCHAR2(5)); 
   

TYPE Keys_And_Qty_Rec IS RECORD (
   location_no                VARCHAR2(35),
   lot_batch_no               VARCHAR2(20),
   serial_no                  VARCHAR2(50),
   eng_chg_level              VARCHAR2(6),
   waiv_dev_rej_no            VARCHAR2(15),                  
   activity_seq               NUMBER,
   handling_unit_id           NUMBER,
   part_tracking_session_id   NUMBER,
   input_qty                  NUMBER,
   input_unit_meas            VARCHAR2(30),
   input_conv_factor          NUMBER,
   input_variable_values      VARCHAR2(2000),
   quantity                   NUMBER,
   catch_quantity             NUMBER);


TYPE Inv_Part_In_Stock_Res_Table IS TABLE OF Inv_Part_In_Stock_Res_Rec INDEX BY BINARY_INTEGER;
TYPE Keys_And_Qty_Table IS TABLE OF Keys_And_Qty_Rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

mixed_value_ CONSTANT VARCHAR2(3)  := '...';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Find_Reservations__ 
-- Will find all reservations that pass the criteria and return a table of records containig the inventory stock reservations.
FUNCTION Find_Reservations___ (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   qty_to_ureserve_             IN NUMBER,
   pick_by_choice_option_       IN VARCHAR2 ) RETURN Inv_Part_In_Stock_Res_Table
IS
   inv_part_in_stock_res_tab_   Inv_Part_In_Stock_Res_Table;   
   
   CURSOR get_attr IS
      SELECT order_no, line_no, release_no, line_item_no, order_supply_demand_type_db, contract, part_no, configuration_id, 
             location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, 
             pick_list_no, shipment_id, qty_reserved, 'TRUE', pick_by_choice_blocked_db
      FROM  INV_PART_STOCK_RES_MOVE 
      WHERE contract                    = contract_
      AND   part_no                     = part_no_
      AND   configuration_id            = configuration_id_
      AND   location_no                 = location_no_
      AND   lot_batch_no                = lot_batch_no_
      AND   serial_no                   = serial_no_
      AND   eng_chg_level               = eng_chg_level_
      AND   waiv_dev_rej_no             = waiv_dev_rej_no_
      AND   activity_seq                = activity_seq_
      AND   handling_unit_id            = handling_unit_id_                  
      AND   NVL(qty_picked, 0)          = 0
      AND   pick_by_choice_blocked_db   = Fnd_Boolean_API.DB_FALSE
      AND   order_supply_demand_type_db IN ( Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_1_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_2_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_3_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_4_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_5_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_6_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_7_)
      AND   CASE WHEN (NVL(pick_list_no, '*') = '*') AND (pick_by_choice_option_ IN ('ALLOWED', 'NOT_PICK_LISTED', 'NOT_PRINTED_PICKLIST'))  THEN 1
                 WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'FALSE') AND (pick_by_choice_option_ IN ('ALLOWED','NOT_PRINTED_PICKLIST')) THEN 1
                 WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'TRUE') AND (pick_by_choice_option_ = 'ALLOWED') THEN 1
                 ELSE 0
            END = 1
      ORDER BY DECODE(NVL(pick_list_no, '*'), '*', 1, DECODE(pick_list_printed_db, 'FALSE', 2, 3)) ASC,
               date_required DESC NULLS LAST,
               (DECODE(TRUNC(qty_reserved/qty_to_ureserve_), 0, TO_NUMBER(NULL), qty_reserved)) ASC NULLS LAST, qty_reserved DESC;  
BEGIN 
   OPEN get_attr;
   FETCH get_attr BULK COLLECT INTO inv_part_in_stock_res_tab_;
   CLOSE get_attr;     
   RETURN inv_part_in_stock_res_tab_;
END Find_Reservations___;


-- Reset_Reservations__
-- Reset the active attribute of all records in inv_part_stock_res_tab_ to TRUE
PROCEDURE Reset_Reservations___ ( 
   inv_part_stock_res_tab_   IN OUT Inv_Part_In_Stock_Res_Table )
IS
BEGIN
   IF inv_part_stock_res_tab_.COUNT > 0 THEN
      FOR i IN inv_part_stock_res_tab_.FIRST..inv_part_stock_res_tab_.LAST LOOP
         inv_part_stock_res_tab_(i).active := Fnd_Boolean_API.DB_TRUE;
      END LOOP;
   END IF ;
END Reset_Reservations___;

-- Have_Enough_Qty_To_Pick__ 
-- Return TRUE if sum of the quantity in inv_part_stock_res_tab_ is equall or more than qty_to_pick_ otherwisw return FALSE
FUNCTION Have_Enough_Qty_To_Pick___ (qty_to_pick_              IN NUMBER,
                                     inv_part_stock_res_tab_   IN Inv_Part_In_Stock_Res_Table) RETURN BOOLEAN
IS
   reserved_qty_in_stock_  NUMBER := 0;
BEGIN
   IF inv_part_stock_res_tab_.COUNT > 0 THEN
      FOR i IN inv_part_stock_res_tab_.FIRST..inv_part_stock_res_tab_.LAST LOOP
         reserved_qty_in_stock_ := reserved_qty_in_stock_ + inv_part_stock_res_tab_(i).quantity;
      END LOOP;            
   END IF;
   RETURN (reserved_qty_in_stock_ >= qty_to_pick_);
END Have_Enough_Qty_To_Pick___;


-- Unreserve_Stock___ 
-- Return parameter: 
-- 1) quantity_unreserved_ return NULL or unreserved quantity. unreserve quantity can be less, equal or more than quantity_to_unreserve_.
--    If the last stock records to be unreserve have more quantity than is needed whole quantity will be unreserve so quantity_unreserved_ 
--    can be more than quantity_to_unreserve_ 
-- 2) inv_part_stock_res_tab_ return table of records of inventory reservation. The records that fail in unreserve process will 
--    be removed from the table of records and active property of un-consumed stock records will be set to false. 
PROCEDURE Unreserve_Stock___ ( 
   quantity_unreserved_    OUT NUMBER,
   inv_part_stock_res_tab_ IN OUT Inv_Part_In_Stock_Res_Table,   
   quantity_to_unreserve_  IN NUMBER)
IS 
   reserved_qty_           NUMBER := 0;   
   total_unreserved_qty_   NUMBER := 0;   
   dummy_number_           NUMBER;
   dummy_varchar_          VARCHAR2(2000);
BEGIN   
   IF (inv_part_stock_res_tab_.COUNT > 0 ) THEN
      FOR i IN inv_part_stock_res_tab_.FIRST..inv_part_stock_res_tab_.LAST LOOP
         IF (total_unreserved_qty_ >= abs(quantity_to_unreserve_)) THEN
            -- If nothing to be unreserved more, then set the rest of record's status to inactive.
            inv_part_stock_res_tab_(i).active := Fnd_Boolean_API.DB_FALSE;
            CONTINUE;
         END IF;   
         Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => reserved_qty_,
                                                      input_qty_                 => dummy_number_,
                                                      input_unit_meas_           => dummy_varchar_,
                                                      input_conv_factor_         => dummy_number_,
                                                      input_variable_values_     => dummy_varchar_,
                                                      source_ref1_               => inv_part_stock_res_tab_(i).source_ref1, 
                                                      source_ref2_               => inv_part_stock_res_tab_(i).source_ref2,
                                                      source_ref3_               => inv_part_stock_res_tab_(i).source_ref3, 
                                                      source_ref4_               => inv_part_stock_res_tab_(i).source_ref4, 
                                                      source_ref_type_db_        => inv_part_stock_res_tab_(i).source_ref_type_db ,
                                                      contract_                  => inv_part_stock_res_tab_(i).contract,
                                                      part_no_                   => inv_part_stock_res_tab_(i).part_no,
                                                      location_no_               => inv_part_stock_res_tab_(i).location_no,
                                                      lot_batch_no_              => inv_part_stock_res_tab_(i).lot_batch_no,
                                                      serial_no_                 => inv_part_stock_res_tab_(i).serial_no,
                                                      eng_chg_level_             => inv_part_stock_res_tab_(i).eng_chg_level,
                                                      waiv_dev_rej_no_           => inv_part_stock_res_tab_(i).waiv_dev_rej_no,
                                                      activity_seq_              => inv_part_stock_res_tab_(i).activity_seq,
                                                      handling_unit_id_          => inv_part_stock_res_tab_(i).handling_unit_id,
                                                      configuration_id_          => inv_part_stock_res_tab_(i).configuration_id,
                                                      pick_list_no_              => inv_part_stock_res_tab_(i).pick_list_no,
                                                      shipment_id_               => inv_part_stock_res_tab_(i).shipment_id,
                                                      quantity_to_reserve_       => inv_part_stock_res_tab_(i).quantity * -1,
                                                      reservation_operation_id_  => Inv_Part_Stock_Reservation_API.pick_by_choice_);

         -- We assume the unreservation is successful if unreserved qty is equal inv_part_stock_res_tab_(i).quantity. 
         IF (abs(reserved_qty_) < inv_part_stock_res_tab_(i).quantity) THEN          
            inv_part_stock_res_tab_.DELETE(i);
         ELSE 
            total_unreserved_qty_ := total_unreserved_qty_ + abs(reserved_qty_);
         END IF;

      END LOOP;
      quantity_unreserved_ := total_unreserved_qty_;
   END IF;
END Unreserve_Stock___;


-- Find_And_Reserve_Stock___ 
-- Will find and reserve orders with active property TRUE in inv_part_stock_res_tab_ and will exit process if one reservation fail.
-- Return parameter: 
-- 1) quantity_reserved_ return NULL or Reserved quantity.  Reserved quantity is always less or equal quantity_to_reserve_
-- 2) inv_part_stock_res_tab_ return table of records of inventory reservation. The stock record that fails in reservation process will 
--    be removed from the table of records.
PROCEDURE Find_And_Reserve_Stock___ ( 
   quantity_reserved_      OUT NUMBER,
   inv_part_stock_res_tab_ IN OUT Inv_Part_In_Stock_Res_Table,   
   quantity_to_reserve_    IN NUMBER)
IS 
   reserved_qty_           NUMBER;   
   total_reserved_qty_     NUMBER := 0;   
   dummy_number_           NUMBER;
   dummy_varchar_          VARCHAR2(2000);
BEGIN   
   IF (inv_part_stock_res_tab_.COUNT > 0 ) THEN
      
      FOR i IN inv_part_stock_res_tab_.FIRST..inv_part_stock_res_tab_.LAST LOOP
         IF (total_reserved_qty_ >= abs(quantity_to_reserve_)) THEN
            -- If nothing to be reserve/unreserved more, then set the rest of record's status to inactive.
            inv_part_stock_res_tab_(i).active := Fnd_Boolean_API.DB_FALSE;
            CONTINUE;
         END IF;   
         IF inv_part_stock_res_tab_(i).active = Fnd_Boolean_API.DB_TRUE THEN           
            Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => reserved_qty_,
                                                         input_qty_                 => dummy_number_,
                                                         input_unit_meas_           => dummy_varchar_,
                                                         input_conv_factor_         => dummy_number_,
                                                         input_variable_values_     => dummy_varchar_,
                                                         source_ref1_               => inv_part_stock_res_tab_(i).source_ref1, 
                                                         source_ref2_               => inv_part_stock_res_tab_(i).source_ref2,
                                                         source_ref3_               => inv_part_stock_res_tab_(i).source_ref3, 
                                                         source_ref4_               => inv_part_stock_res_tab_(i).source_ref4, 
                                                         source_ref_type_db_        => inv_part_stock_res_tab_(i).source_ref_type_db ,
                                                         contract_                  => inv_part_stock_res_tab_(i).contract,
                                                         part_no_                   => inv_part_stock_res_tab_(i).part_no,
                                                         location_no_               => NULL,
                                                         lot_batch_no_              => NULL,
                                                         serial_no_                 => NULL,
                                                         eng_chg_level_             => NULL,
                                                         waiv_dev_rej_no_           => NULL,
                                                         activity_seq_              => NULL,
                                                         handling_unit_id_          => NULL,
                                                         configuration_id_          => inv_part_stock_res_tab_(i).configuration_id,
                                                         pick_list_no_              => inv_part_stock_res_tab_(i).pick_list_no,
                                                         shipment_id_               => inv_part_stock_res_tab_(i).shipment_id,
                                                         quantity_to_reserve_       => inv_part_stock_res_tab_(i).quantity,
                                                         reservation_operation_id_  => Inv_Part_Stock_Reservation_API.pick_by_choice_);
         END IF;
         -- We assume the unreservation is successful if unreserved qty is equal inv_part_stock_res_tab_(i).quantity. 
         IF (NVL(abs(reserved_qty_), 0) < inv_part_stock_res_tab_(i).quantity) THEN          
            inv_part_stock_res_tab_.DELETE(i);
            EXIT;
         ELSE 
            total_reserved_qty_ := total_reserved_qty_ + reserved_qty_;
         END IF;   
      END LOOP;

      quantity_reserved_ := total_reserved_qty_;
   END IF;
END Find_And_Reserve_Stock___;


-- Reserve_Stock__ 
-- Will reserve stock for order with allowed source_ref_type_.
-- Return parameter: 
-- 1) quantity_reserved_ Reserved quantity.  
PROCEDURE Reserve_Stock___ ( 
   quantity_reserved_   OUT NUMBER,
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  NUMBER,
   source_ref_type_db_  IN  VARCHAR2,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   configuration_id_    IN  VARCHAR2,
   location_no_         IN  VARCHAR2,
   lot_batch_no_        IN  VARCHAR2,
   serial_no_           IN  VARCHAR2,
   eng_chg_level_       IN  VARCHAR2,
   waiv_dev_rej_no_     IN  VARCHAR2,
   activity_seq_        IN  NUMBER,
   handling_unit_id_    IN  NUMBER,
   pick_list_no_        IN  VARCHAR2,
   shipment_id_         IN  NUMBER,
   quantity_to_reserve_ IN  NUMBER )
IS 
   input_qty_           NUMBER;
   input_conv_factor_   NUMBER;
   input_var_values_    VARCHAR2(2000);
   input_unit_meas_     VARCHAR2(30);
BEGIN   
   Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => quantity_reserved_,
                                                input_qty_                 => input_qty_,
                                                input_unit_meas_           => input_unit_meas_,
                                                input_conv_factor_         => input_conv_factor_,
                                                input_variable_values_     => input_var_values_,
                                                source_ref1_               => source_ref1_, 
                                                source_ref2_               => source_ref2_,
                                                source_ref3_               => source_ref3_, 
                                                source_ref4_               => source_ref4_, 
                                                source_ref_type_db_        => source_ref_type_db_ ,
                                                contract_                  => contract_,
                                                part_no_                   => part_no_,
                                                location_no_               => location_no_,
                                                lot_batch_no_              => lot_batch_no_,
                                                serial_no_                 => serial_no_,
                                                eng_chg_level_             => eng_chg_level_,
                                                waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                                activity_seq_              => activity_seq_,
                                                handling_unit_id_          => handling_unit_id_,
                                                configuration_id_          => configuration_id_,
                                                pick_list_no_              => pick_list_no_,
                                                shipment_id_               => shipment_id_,
                                                quantity_to_reserve_       => quantity_to_reserve_,
                                                reservation_operation_id_  => Inv_Part_Stock_Reservation_API.pick_by_choice_,
                                                raise_exception_           => TRUE);
EXCEPTION
   WHEN OTHERS THEN
      IF Instr(sqlerrm,'QTYOVERRIDES', 1, 1) != 0 THEN 
         Error_SYS.Record_General(lu_name_, 'QTYOVERRIDES: Pick by choice is not allowed when more than the required quantity of the order line is already reserved.');
      ELSE 
         RAISE;
      END IF; 
END Reserve_Stock___;


PROCEDURE Remove_Duplicate_Source_Ref___ ( 
   stock_reservation_tab_  IN OUT Inv_Part_In_Stock_Res_Table )
IS 
   counter_                NUMBER;
BEGIN   
   IF (stock_reservation_tab_.COUNT > 1 ) THEN
      counter_ := stock_reservation_tab_.LAST;
      FOR i IN stock_reservation_tab_.FIRST..counter_-1  LOOP
         IF (counter_ > 1 AND i+1 <= counter_) THEN
            FOR j IN REVERSE i+1..counter_ LOOP
               IF (Validate_SYS.Is_Equal(stock_reservation_tab_(i).source_ref_type_db, stock_reservation_tab_(j).source_ref_type_db) AND  
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).source_ref1, stock_reservation_tab_(j).source_ref1) AND   
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).source_ref2, stock_reservation_tab_(j).source_ref2) AND   
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).source_ref3, stock_reservation_tab_(j).source_ref3) AND   
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).source_ref4, stock_reservation_tab_(j).source_ref4) AND
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).pick_list_no, stock_reservation_tab_(j).pick_list_no) AND
                   Validate_SYS.Is_Equal(stock_reservation_tab_(i).shipment_id, stock_reservation_tab_(j).shipment_id)) THEN  

                  counter_ := counter_ - 1;
                  stock_reservation_tab_(i).quantity := stock_reservation_tab_(i).quantity + stock_reservation_tab_(j).quantity;
                  stock_reservation_tab_.Delete(j);
                  stock_reservation_tab_(i).location_no := NULL; 
                  stock_reservation_tab_(i).lot_batch_no := NULL; 
                  stock_reservation_tab_(i).serial_no := NULL; 
                  stock_reservation_tab_(i).eng_chg_level := NULL;
                  stock_reservation_tab_(i).waiv_dev_rej_no := NULL;
                  stock_reservation_tab_(i).activity_seq := NULL;
                  stock_reservation_tab_(i).handling_unit_id := NULL;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END IF;
END Remove_Duplicate_Source_Ref___;                              


--Get_Order_Line_Content___
--This method will return all order lines that have reserved stock attached to handling unit structure as a table of records
FUNCTION Get_Hu_Reservation_Content___ (
   handling_unit_id_ IN NUMBER ) RETURN Inv_Part_In_Stock_Res_Table
IS
   stock_reservation_info_tab_   Inv_Part_In_Stock_Res_Table;    
   pos_                          NUMBER := 0;
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   CURSOR get_reservation (handling_unit_ NUMBER)IS
     SELECT order_no, line_no, release_no, line_item_no, order_supply_demand_type_db, contract, part_no, configuration_id, 
               location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, 
               pick_list_no, shipment_id, qty_reserved-NVL(qty_picked,0), 'TRUE', pick_by_choice_blocked_db
     FROM  INV_PART_STOCK_RES_MOVE
     WHERE handling_unit_id = handling_unit_;       
BEGIN    
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_); 
   IF handling_unit_id_tab_.Count > 0 THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN get_reservation(handling_unit_id_tab_(i).handling_unit_id);
         LOOP
            FETCH get_reservation  INTO stock_reservation_info_tab_(pos_);
            EXIT WHEN get_reservation%NOTFOUND;
            pos_ := pos_ + 1;
         END LOOP;   
         CLOSE get_reservation;  
      END LOOP;
   END IF;
   RETURN stock_reservation_info_tab_;
END Get_Hu_Reservation_Content___;                              


--Unreserve_Handling_Unit___
--This method will unreserve all reserved stock attached to handling unit structure if all stock records attached to handling unit are
--reserved for demand types that allow Pick by Choice process. For now it is only customer order that allow pick by choice functionality.
--The method returns table of unreserved stock records and unreserved quantity.
--qty_unreserved_ will return values : 
-- 1) "total unreserved qty" 
-- 2) "-1" When one or more stock record(s) attached to handling unit is/are reserved for order supply demand types that don't allow Pick by Choice.
-- 3) "Null" in case of other issues
PROCEDURE Unreserve_Handling_Unit___ ( 
   qty_unreserved_         OUT NUMBER,
   stock_reservation_tab_  OUT Inv_Part_In_Stock_Res_Table,
   handling_unit_id_       IN  NUMBER )
IS 
   reserved_qty_           NUMBER;   
   total_unreserved_qty_   NUMBER := 0;  
   dummy_number_           NUMBER;
   dummy_varchar_          VARCHAR2(2000);
   
 BEGIN   
   -- Get all Reserved stock records attached to the handling unit structure   
   stock_reservation_tab_ := Get_Hu_Reservation_Content___(handling_unit_id_);
   
   IF (stock_reservation_tab_.COUNT > 0 ) THEN
      FOR i IN stock_reservation_tab_.FIRST..stock_reservation_tab_.LAST LOOP
         IF stock_reservation_tab_(i).source_ref_type_db IN ( Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_1_,
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_2_,
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_3_,
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_4_,
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_5_,                                                              
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_6_,
                                                              Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_7_) THEN             
            
            Inv_Part_Stock_Reservation_API.Reserve_Stock(quantity_reserved_         => reserved_qty_,
                                                         input_qty_                 => dummy_number_,
                                                         input_unit_meas_           => dummy_varchar_,
                                                         input_conv_factor_         => dummy_number_,
                                                         input_variable_values_     => dummy_varchar_,
                                                         source_ref1_               => stock_reservation_tab_(i).source_ref1, 
                                                         source_ref2_               => stock_reservation_tab_(i).source_ref2,
                                                         source_ref3_               => stock_reservation_tab_(i).source_ref3, 
                                                         source_ref4_               => stock_reservation_tab_(i).source_ref4, 
                                                         source_ref_type_db_        => stock_reservation_tab_(i).source_ref_type_db ,
                                                         contract_                  => stock_reservation_tab_(i).contract,
                                                         part_no_                   => stock_reservation_tab_(i).part_no,
                                                         location_no_               => stock_reservation_tab_(i).location_no,
                                                         lot_batch_no_              => stock_reservation_tab_(i).lot_batch_no,
                                                         serial_no_                 => stock_reservation_tab_(i).serial_no,
                                                         eng_chg_level_             => stock_reservation_tab_(i).eng_chg_level,
                                                         waiv_dev_rej_no_           => stock_reservation_tab_(i).waiv_dev_rej_no,
                                                         activity_seq_              => stock_reservation_tab_(i).activity_seq,
                                                         handling_unit_id_          => stock_reservation_tab_(i).handling_unit_id,
                                                         configuration_id_          => stock_reservation_tab_(i).configuration_id,
                                                         pick_list_no_              => stock_reservation_tab_(i).pick_list_no,
                                                         shipment_id_               => stock_reservation_tab_(i).shipment_id,
                                                         quantity_to_reserve_       => stock_reservation_tab_(i).quantity * -1,
                                                         reservation_operation_id_  => Inv_Part_Stock_Reservation_API.pick_by_choice_,
                                                         pick_by_choice_blocked_    => stock_reservation_tab_(i).pick_by_choice_blocked_db);

         ELSE
            Raise_Pick_Choice_Not_Allowed___(handling_unit_id_);
         END IF;                                                                                          
         -- We assume the unreservation is successful if reserved_qty_ is not null. 
         IF (abs(reserved_qty_) != stock_reservation_tab_(i).quantity) THEN               
            total_unreserved_qty_ := 0;
            EXIT;
         ELSE 
            total_unreserved_qty_ := total_unreserved_qty_ + stock_reservation_tab_(i).quantity;
         END IF;   
      END LOOP;
   END IF;
   qty_unreserved_ := total_unreserved_qty_;
END Unreserve_Handling_Unit___;


-- Pick_Reservations___
-- Pick report a single reservation
PROCEDURE Pick_Stock_Reservations___ (
   qty_picked_                OUT NUMBER,
   all_reported_              OUT NUMBER,
   session_id_                IN OUT NOCOPY NUMBER,
   pick_list_no_              IN VARCHAR2,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN NUMBER,
   source_ref_type_db_        IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   handling_unit_id_          IN NUMBER,
   input_qty_                 IN NUMBER,
   input_conv_factor_         IN NUMBER,
   input_unit_meas_           IN VARCHAR2,
   input_variable_values_     IN VARCHAR2,
   qty_to_pick_               IN NUMBER,
   catch_qty_to_pick_         IN NUMBER,
   part_tracking_session_id_  IN NUMBER,
   shipment_id_               IN NUMBER,
   ship_location_no_          IN VARCHAR2,
   add_hu_to_shipment_        IN BOOLEAN,
   close_line_                IN VARCHAR2,
   last_line_                 IN VARCHAR2,
   trigger_shipment_flow_     IN VARCHAR2 )
IS
   dummy_number_              NUMBER;
   dummy_varchar_             VARCHAR2(50);
BEGIN
   IF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_CUST_ORDER, Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER)) THEN           
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Pick_Reservations(qty_picked_                => qty_picked_, 
                                                   all_reported_              => all_reported_, 
                                                   closed_lines_              => dummy_number_, 
                                                   overpicked_lines_          => dummy_varchar_, 
                                                   session_id_                => session_id_, 
                                                   pick_list_no_              => pick_list_no_, 
                                                   order_no_                  => source_ref1_, 
                                                   line_no_                   => source_ref2_, 
                                                   rel_no_                    => source_ref3_, 
                                                   line_item_no_              => source_ref4_, 
                                                   contract_                  => contract_, 
                                                   part_no_                   => part_no_, 
                                                   configuration_id_          => configuration_id_, 
                                                   location_no_               => location_no_, 
                                                   lot_batch_no_              => lot_batch_no_, 
                                                   serial_no_                 => serial_no_, 
                                                   eng_chg_level_             => eng_chg_level_, 
                                                   waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                   activity_seq_              => activity_seq_, 
                                                   handling_unit_id_          => handling_unit_id_, 
                                                   input_qty_                 => input_qty_, 
                                                   input_conv_factor_         => input_conv_factor_, 
                                                   input_unit_meas_           => input_unit_meas_, 
                                                   input_variable_values_     => input_variable_values_, 
                                                   shipment_id_               => shipment_id_, 
                                                   ship_location_no_          => ship_location_no_, 
                                                   qty_to_pick_               => qty_to_pick_, 
                                                   catch_qty_to_pick_         => catch_qty_to_pick_, 
                                                   part_tracking_session_id_  => part_tracking_session_id_, 
                                                   close_line_                => close_line_, 
                                                   last_line_                 => last_line_,
                                                   add_hu_to_shipment_        => add_hu_to_shipment_,
                                                   raise_exception_           => TRUE,
                                                   trigger_shipment_flow_     => trigger_shipment_flow_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END   
   ELSIF source_ref_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO THEN           
      $IF Component_Shpord_SYS.INSTALLED $THEN
         Shop_Material_Pick_Line_API.Report_Pick_Line(new_qty_assigned_          => dummy_number_, 
                                                      order_no_                  => source_ref1_, 
                                                      release_no_                => source_ref2_, 
                                                      sequence_no_               => source_ref3_, 
                                                      line_item_no_              => source_ref4_, 
                                                      contract_                  => contract_, 
                                                      part_no_                   => part_no_, 
                                                      location_no_               => location_no_, 
                                                      lot_batch_no_              => lot_batch_no_, 
                                                      serial_no_                 => serial_no_, 
                                                      eng_chg_level_             => eng_chg_level_, 
                                                      waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                      pick_list_no_              => pick_list_no_, 
                                                      configuration_id_          => configuration_id_, 
                                                      activity_seq_              => activity_seq_, 
                                                      handling_unit_id_          => handling_unit_id_, 
                                                      qty_to_pick_               => qty_to_pick_, 
                                                      catch_qty_to_pick_         => catch_qty_to_pick_, 
                                                      part_tracking_session_id_  => part_tracking_session_id_); 
         qty_picked_ := qty_to_pick_;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   ELSIF source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER, Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES) THEN 
      Inventory_Part_Reservation_API.Pick_Reservation(contract_                   => contract_, 
                                                      part_no_                    => part_no_, 
                                                      configuration_id_           => configuration_id_, 
                                                      location_no_                => location_no_, 
                                                      lot_batch_no_               => lot_batch_no_, 
                                                      serial_no_                  => serial_no_, 
                                                      eng_chg_level_              => eng_chg_level_, 
                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                      activity_seq_               => activity_seq_, 
                                                      handling_unit_id_           => handling_unit_id_,
                                                      source_ref1_                => source_ref1_, 
                                                      source_ref2_                => source_ref2_, 
                                                      source_ref3_                => source_ref3_, 
                                                      source_ref4_                => source_ref4_,
                                                      source_ref_type_db_         => source_ref_type_db_,
                                                      qty_to_pick_                => qty_to_pick_,
                                                      catch_qty_to_pick_          => catch_qty_to_pick_,
                                                      ship_inventory_location_no_ => ship_location_no_,
                                                      pick_list_no_               => pick_list_no_);
   ELSE 
      Error_SYS.Record_General(lu_name_, 'INVALIDSOURCEREFTYPE: Source Reference Type :P1 is not supported in method Pick_Stock_Reservations___. Contact System Support.', source_ref_type_db_);
   END IF;
END Pick_Stock_Reservations___;


-- Pick_Reservations___
-- Pick report a Handling Unit reservation
PROCEDURE Pick_Hu_Reservations___ (
   hu_picked_                 OUT NUMBER,
   session_id_                IN OUT NOCOPY NUMBER,
   pick_list_no_              IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   handling_unit_id_          IN NUMBER,
   ship_location_no_          IN VARCHAR2,
   last_line_                 IN VARCHAR2,
   trigger_shipment_flow_     IN VARCHAR2)
IS
BEGIN
   IF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_CUST_ORDER, Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER)) THEN           
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Pick_Reservations_HU(hu_picked_             => hu_picked_,
                                                      session_id_            => session_id_, 
                                                      pick_list_no_          => pick_list_no_,
                                                      source_ref_type_db_    => source_ref_type_db_,
                                                      handling_unit_id_      => handling_unit_id_,
                                                      ship_location_no_      => ship_location_no_,
                                                      last_line_             => last_line_,
                                                      raise_exception_       => TRUE,
                                                      trigger_shipment_flow_ => trigger_shipment_flow_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END   
   ELSIF (source_ref_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO) THEN           
      $IF Component_Shpord_SYS.INSTALLED $THEN
         Shop_Material_Pick_Util_API.Report_Pick_For_Handling_Unit(hu_qty_picked_      => hu_picked_,
                                                                   pick_list_no_       => pick_list_no_,
                                                                   handling_unit_id_   => handling_unit_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END 
   ELSIF (source_ref_type_db_ IN (Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER, Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES)) THEN
      Inventory_Part_Reservation_API.Pick_HU_Reservations(pick_list_no_          => pick_list_no_,                                                      
                                                          handling_unit_id_      => handling_unit_id_,
                                                          ship_location_no_      => ship_location_no_);
      hu_picked_ := 1;                                                    
   END IF;
END Pick_Hu_Reservations___;


PROCEDURE Unpack_Attribute_string___ (
   total_qty_to_pick_      OUT NUMBER,
   keys_and_qty_tab_       OUT Keys_And_Qty_Table,
   add_hu_to_shipment_  IN OUT BOOLEAN,
   message_             IN     CLOB )
IS
   name_arr_          Message_SYS.name_table_clob;
   value_arr_         Message_SYS.line_table_clob;
   count_             NUMBER;
   rec_counter_       NUMBER := 0;
BEGIN
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);  
   FOR n_ IN 1..count_ LOOP
      Trace_SYS.message('**name : ' || name_arr_(n_) || ' value_: ' || value_arr_(n_));
      IF (name_arr_(n_) = 'PART_TRACKING_SESSION_ID') THEN   
         keys_and_qty_tab_(rec_counter_).part_tracking_session_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'ADD_HU_TO_SHIPMENT') THEN
         add_hu_to_shipment_ := value_arr_(n_) = 'TRUE';
      ELSIF (name_arr_(n_) = 'INPUT_QUANTITY') THEN
         keys_and_qty_tab_(rec_counter_).input_qty := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INPUT_CONV_FACTOR') THEN
         keys_and_qty_tab_(rec_counter_).input_conv_factor := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'INPUT_UNIT_MEAS') THEN
         keys_and_qty_tab_(rec_counter_).input_unit_meas := value_arr_(n_) ;
      ELSIF (name_arr_(n_) = 'INPUT_VARIABLE_VALUES') THEN
         keys_and_qty_tab_(rec_counter_).input_variable_values := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CATCH_QTY_TO_PICK') THEN        
         keys_and_qty_tab_(rec_counter_).catch_quantity := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_TO_PICK') THEN    
         keys_and_qty_tab_(rec_counter_).quantity := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         total_qty_to_pick_ := nvl(total_qty_to_pick_, 0) + keys_and_qty_tab_(rec_counter_).quantity;
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         keys_and_qty_tab_(rec_counter_).location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         keys_and_qty_tab_(rec_counter_).lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         keys_and_qty_tab_(rec_counter_).serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         keys_and_qty_tab_(rec_counter_).eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         keys_and_qty_tab_(rec_counter_).waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         keys_and_qty_tab_(rec_counter_).activity_seq := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         keys_and_qty_tab_(rec_counter_).handling_unit_id :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         rec_counter_ := rec_counter_ + 1;
      END IF;
   END LOOP;
END Unpack_Attribute_string___;


PROCEDURE Check_Attributes___ (
   keys_and_qty_tab_  IN Keys_And_Qty_Table )
IS
BEGIN
   IF keys_and_qty_tab_.Count > 0 THEN 
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP
         FOR j IN i..keys_and_qty_tab_.LAST LOOP
            IF (i != j) THEN 
               IF (keys_and_qty_tab_(j).handling_unit_id = keys_and_qty_tab_(i).handling_unit_id AND 
                   keys_and_qty_tab_(j).location_no = keys_and_qty_tab_(i).location_no AND 
                   keys_and_qty_tab_(j).lot_batch_no = keys_and_qty_tab_(i).lot_batch_no AND 
                   keys_and_qty_tab_(j).serial_no = keys_and_qty_tab_(i).serial_no AND 
                   keys_and_qty_tab_(j).eng_chg_level = keys_and_qty_tab_(i).eng_chg_level AND 
                   keys_and_qty_tab_(j).waiv_dev_rej_no = keys_and_qty_tab_(i).waiv_dev_rej_no AND 
                   keys_and_qty_tab_(j).activity_seq = keys_and_qty_tab_(i).activity_seq) THEN 
                  Error_SYS.Record_General(lu_name_, 'SAMESTOCKKEYS: Pick by choice is not allowed when duplicated stock records are entered.');
               END IF ;
            END IF ;
         END LOOP; 
      END LOOP;
   END IF;
END Check_Attributes___ ;
   

PROCEDURE Unpack_Hu_Attribute_string___ (
   handling_unit_id_tab_  OUT Handling_Unit_API.Handling_Unit_Id_Tab,
   message_               IN CLOB )
IS
   name_arr_          Message_SYS.name_table_clob;
   value_arr_         Message_SYS.line_table_clob;
   count_             NUMBER;
   rec_counter_       NUMBER := 0;
BEGIN
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);  
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_tab_(rec_counter_).handling_unit_id :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         rec_counter_ := rec_counter_ + 1;
      END IF;
   END LOOP;
END Unpack_Hu_Attribute_string___;


PROCEDURE Check_Handl_Unit_Attributes___ (
   handling_unit_id_tab_  IN OUT Handling_Unit_API.Handling_Unit_Id_Tab )
IS
   number_of_rec_         NUMBER;
BEGIN
   number_of_rec_ := handling_unit_id_tab_.Count;
   IF handling_unit_id_tab_.Count > 0 THEN 
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         FOR j IN i..handling_unit_id_tab_.LAST LOOP
            IF (i != j) THEN 
               IF (handling_unit_id_tab_(j).handling_unit_id = handling_unit_id_tab_(i).handling_unit_id)  THEN 
                  Error_SYS.Record_General(lu_name_, 'SAMEHANDLINGUNIT: Pick by choice is not allowed when duplicated handling units are entered.');
               END IF ;
            END IF ;
         END LOOP; 
      END LOOP;
   END IF;
   handling_unit_id_tab_ := Handling_Unit_API.Get_Outermost_Units_Only(handling_unit_id_tab_);
   IF handling_unit_id_tab_.Count < number_of_rec_ THEN
      Error_SYS.Record_General(lu_name_, 'PARENTCHILDCOLLISION: You can not pick both a parent in a handling unit structure and its child using pick by choice, you can only pick one of them.');
   END IF;
END Check_Handl_Unit_Attributes___ ;

PROCEDURE Raise_Pick_Choice_Not_Allowed___ (
   handling_unit_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'SOURCEREFTYPEERROR: Handling unit :P1 cannot be picked since it contains stock reserved for a demand source that does not allow pick by choice.', handling_unit_id_);
END Raise_Pick_Choice_Not_Allowed___;


-- Check_Pick_By_Choice_Blocked___
-- If the reservation line is Blocked for Pick by Choice the reserved line must be picked
PROCEDURE Check_Blocked_Attributes___ (
   keys_and_qty_tab_ IN Keys_And_Qty_Table,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
BEGIN
   IF (keys_and_qty_tab_.Count > 0) THEN 
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP
         IF ((location_no_      != keys_and_qty_tab_(i).location_no) OR 
             (lot_batch_no_     != keys_and_qty_tab_(i).lot_batch_no) OR 
             (serial_no_        != keys_and_qty_tab_(i).serial_no) OR 
             (eng_chg_level_    != keys_and_qty_tab_(i).eng_chg_level) OR 
             (waiv_dev_rej_no_  != keys_and_qty_tab_(i).waiv_dev_rej_no) OR 
             (activity_seq_     != keys_and_qty_tab_(i).activity_seq) OR 
             (handling_unit_id_ != keys_and_qty_tab_(i).handling_unit_id)) THEN 
             Raise_Picking_Not_Allowed_Error___;
         END IF ;
      END LOOP;
   END IF;
END Check_Blocked_Attributes___ ;


PROCEDURE Raise_Picking_Not_Allowed_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTSAMESTOCKKEYS: Picking another stock record than the one that is already reserved is not allowed. Check the configuration setting.');
END Raise_Picking_Not_Allowed_Error___;


PROCEDURE Check_Source_Ref_Type_Db__ (
   source_ref_type_db_  IN VARCHAR2)
IS
BEGIN
   IF (source_ref_type_db_ = Order_Supply_Demand_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWEDFORPRR: Pick by choice is not allowed for Purchase Receipt Return.');
   END IF;
END Check_Source_Ref_Type_Db__;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Pick_By_Choice_Allowed
-- Return DB_TRUE if any records exist
-- This method will be called from PickByChoice dialog and WADACO to filter list of values and validate data item.
@UncheckedAccess
FUNCTION Pick_By_Choice_Allowed (
   pick_list_no_           IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN NUMBER,
   source_ref_type_db_     IN VARCHAR2,
   ref_location_no_        IN VARCHAR2,
   ref_lot_batch_no_       IN VARCHAR2,
   ref_serial_no_          IN VARCHAR2,
   ref_eng_chg_level_      IN VARCHAR2,
   ref_waiv_dev_rej_no_    IN VARCHAR2,
   ref_activity_seq_       IN NUMBER,
   ref_handling_unit_id_   IN NUMBER,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,   
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER ) RETURN VARCHAR2 
IS
   inv_rec_                         Inventory_Part_In_Stock_API.Public_Rec;
   pick_by_choice_allowed_          VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   pick_by_choice_option_           VARCHAR2(20);
   qty_available_                   NUMBER := 0;
   dummy_                           NUMBER;
 
   CURSOR check_exist IS
      SELECT 1
      FROM  INV_PART_STOCK_RES_MOVE
      WHERE contract                    = contract_
      AND   part_no                     = part_no_
      AND   configuration_id            = configuration_id_
      AND   location_no                 = location_no_
      AND   lot_batch_no                = lot_batch_no_
      AND   serial_no                   = serial_no_
      AND   eng_chg_level               = eng_chg_level_
      AND   waiv_dev_rej_no             = waiv_dev_rej_no_
      AND   activity_seq                = activity_seq_
      AND   handling_unit_id            = handling_unit_id_                  
      AND  ((pick_list_no               = pick_list_no_        
      AND   ((source_ref1_ IS NOT NULL AND order_no = source_ref1_)     OR source_ref1_ IS NULL)      
      AND   ((source_ref2_ IS NOT NULL AND line_no = source_ref2_)      OR source_ref2_ IS NULL)     
      AND   ((source_ref3_ IS NOT NULL AND release_no = source_ref3_)   OR source_ref3_ IS NULL)      
      AND   ((source_ref4_ IS NOT NULL AND line_item_no = source_ref4_) OR source_ref4_ IS NULL)       
      AND   ((ref_location_no_   IS NOT NULL AND location_no = ref_location_no_)     OR ref_location_no_ IS NULL)      
      AND   ((ref_lot_batch_no_  IS NOT NULL AND lot_batch_no = ref_lot_batch_no_)   OR ref_lot_batch_no_ IS NULL)      
      AND   ((ref_serial_no_     IS NOT NULL AND serial_no = ref_serial_no_)         OR ref_serial_no_ IS NULL)     
      AND   ((ref_eng_chg_level_ IS NOT NULL AND eng_chg_level = ref_eng_chg_level_) OR ref_eng_chg_level_ IS NULL)     
      AND   ((ref_waiv_dev_rej_no_  IS NOT NULL AND waiv_dev_rej_no = ref_waiv_dev_rej_no_)   OR ref_waiv_dev_rej_no_ IS NULL)       
      AND   ((ref_activity_seq_     IS NOT NULL AND activity_seq = ref_activity_seq_)         OR ref_activity_seq_ IS NULL)      
      AND   ((ref_handling_unit_id_ IS NOT NULL AND handling_unit_id = ref_handling_unit_id_) OR ref_handling_unit_id_ IS NULL) 
      AND   order_supply_demand_type_db = source_ref_type_db_)
      OR    (CASE WHEN (pick_list_no IS NULL OR pick_list_no = '*') AND (pick_by_choice_option_ IN ('ALLOWED', 'NOT_PICK_LISTED', 'NOT_PRINTED_PICKLIST'))  THEN 1
                  WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'FALSE') AND (pick_by_choice_option_ IN ('ALLOWED', 'NOT_PRINTED_PICKLIST')) THEN 1
                  WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'TRUE') AND (pick_by_choice_option_ = 'ALLOWED') THEN 1
                  ELSE 0
            END = 1)
      AND   pick_by_choice_blocked_db   = Fnd_Boolean_API.DB_FALSE
      AND   order_supply_demand_type_db IN ( Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_1_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_2_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_3_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_4_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_5_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_6_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_7_))
      AND   NVL(qty_picked, 0)          = 0;
BEGIN   
   pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);

   IF pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
      inv_rec_ := Inventory_Part_In_Stock_API.Get(contract_          => contract_, 
                                                  part_no_           => part_no_, 
                                                  configuration_id_  => configuration_id_,  
                                                  location_no_       => location_no_,  
                                                  lot_batch_no_      => lot_batch_no_,  
                                                  serial_no_         => serial_no_, 
                                                  eng_chg_level_     => eng_chg_level_,  
                                                  waiv_dev_rej_no_   => waiv_dev_rej_no_,  
                                                  activity_seq_      => activity_seq_,  
                                                  handling_unit_id_  => handling_unit_id_ );
      qty_available_ := inv_rec_.qty_onhand - inv_rec_.qty_Reserved;
      IF qty_available_ > 0 THEN 
         pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
      ELSE         
         OPEN check_exist;
         FETCH check_exist INTO dummy_;
         IF check_exist%FOUND THEN
            pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         CLOSE check_exist;
      END IF ; 
   END IF; 
   RETURN pick_by_choice_allowed_;
END Pick_By_Choice_Allowed;   


-- Pick_By_Choice
PROCEDURE Pick_By_Choice ( 
   message_               IN CLOB,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN NUMBER,
   source_ref_type_db_    IN VARCHAR2,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   shipment_id_           IN NUMBER,
   ship_location_no_      IN VARCHAR2,
   reserved_qty_          IN NUMBER,
   close_line_            IN VARCHAR2,
   trigger_shipment_flow_ IN VARCHAR2 DEFAULT 'TRUE' ) 
IS
   reserved_stock_tab_     Inv_Part_In_Stock_Res_Table;   
   inv_part_in_stock_rec_  Inventory_Part_In_Stock_API.Public_Rec;
   add_hu_to_shipment_     BOOLEAN := TRUE;
   keys_and_qty_tab_       Keys_And_Qty_Table;
   pick_by_choice_option_  VARCHAR2(20);
   last_line_              VARCHAR2(5);
   transaction_succeeded_  BOOLEAN := FALSE;
   reserved_qty_to_pick_   NUMBER;
   total_qty_to_pick_      NUMBER;
   qty_unreserved_         NUMBER := 0; 
   qty_reserved_           NUMBER := 0;
   qty_picked_             NUMBER := 0;
   all_reported_           NUMBER;
   session_id_             NUMBER;
   exit_with_fail          EXCEPTION;
   not_allowed             EXCEPTION;
   pick_by_choice_blocked_ VARCHAR2(5);
BEGIN
   Check_Source_Ref_Type_Db__(source_ref_type_db_);
   
   pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);

   IF pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
      RAISE not_allowed;
   END IF;
   
   pick_by_choice_blocked_ := Inv_Part_Stock_Reservation_API.Get_Pick_By_Choice_Blocked_Db(order_no_                    => source_ref1_,
                                                                                           line_no_                     => source_ref2_,
                                                                                           release_no_                  => source_ref3_,
                                                                                           line_item_no_                => source_ref4_,
                                                                                           order_supply_demand_type_db_ => source_ref_type_db_,
                                                                                           contract_                    => contract_,
                                                                                           part_no_                     => part_no_,
                                                                                           configuration_id_            => configuration_id_,
                                                                                           location_no_                 => location_no_, 
                                                                                           lot_batch_no_                => lot_batch_no_, 
                                                                                           serial_no_                   => serial_no_, 
                                                                                           eng_chg_level_               => eng_chg_level_, 
                                                                                           waiv_dev_rej_no_             => waiv_dev_rej_no_, 
                                                                                           activity_seq_                => activity_seq_, 
                                                                                           handling_unit_id_            => handling_unit_id_,
                                                                                           pick_list_no_                => pick_list_no_); 

   Unpack_Attribute_string___(total_qty_to_pick_   => total_qty_to_pick_,
                              keys_and_qty_tab_    => keys_and_qty_tab_,
                              add_hu_to_shipment_  => add_hu_to_shipment_,
                              message_             => message_);

   IF (pick_by_choice_blocked_ = Fnd_Boolean_API.DB_TRUE) THEN 
      Check_Blocked_Attributes___(keys_and_qty_tab_,
                                  location_no_,
                                  lot_batch_no_,
                                  serial_no_,
                                  eng_chg_level_,
                                  waiv_dev_rej_no_,
                                  activity_seq_,
                                  handling_unit_id_); 
   END IF;

   Check_Attributes___(keys_and_qty_tab_);

   -- Quantity to unreserve will always be same as quantity reserved on original pick list line exept 
   -- when under pickicking happens without request to close the order line.
   IF (close_line_ = Fnd_Boolean_API.DB_TRUE) OR (total_qty_to_pick_ >= reserved_qty_) THEN
      qty_reserved_ := reserved_qty_;
   ELSE 
      qty_reserved_ := total_qty_to_pick_;
   END IF;
   
   Reserve_Stock___(quantity_reserved_   => qty_unreserved_, 
                    source_ref1_         => source_ref1_,  
                    source_ref2_         => source_ref2_,  
                    source_ref3_         => source_ref3_, 
                    source_ref4_         => source_ref4_, 
                    source_ref_type_db_  => source_ref_type_db_,
                    contract_            => contract_,
                    part_no_             => part_no_,
                    configuration_id_    => configuration_id_,
                    location_no_         => location_no_, 
                    lot_batch_no_        => lot_batch_no_, 
                    serial_no_           => serial_no_, 
                    eng_chg_level_       => eng_chg_level_, 
                    waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                    activity_seq_        => activity_seq_, 
                    handling_unit_id_    => handling_unit_id_,
                    pick_list_no_        => pick_list_no_,
                    shipment_id_         => shipment_id_, 
                    quantity_to_reserve_ => qty_reserved_ * -1);

   IF abs(qty_unreserved_) < qty_reserved_ THEN 
      RAISE exit_with_fail;
   END IF; 
   IF keys_and_qty_tab_.Count > 0 THEN 
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP

         transaction_succeeded_ := FALSE;

         @ApproveTransactionStatement(2016-09-28,khvese)   
         SAVEPOINT before_stock_locked;
         inv_part_in_stock_rec_ := Inventory_Part_In_Stock_API.Lock_By_Keys(contract_,
                                                                            part_no_,
                                                                            configuration_id_,
                                                                            keys_and_qty_tab_(i).location_no,
                                                                            keys_and_qty_tab_(i).lot_batch_no,
                                                                            keys_and_qty_tab_(i).serial_no,
                                                                            keys_and_qty_tab_(i).eng_chg_level,
                                                                            keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                                            keys_and_qty_tab_(i).activity_seq,
                                                                            keys_and_qty_tab_(i).handling_unit_id);
         IF (keys_and_qty_tab_(i).quantity <= inv_part_in_stock_rec_.qty_onhand) THEN 
            reserved_qty_to_pick_ := keys_and_qty_tab_(i).quantity - (inv_part_in_stock_rec_.qty_onhand - inv_part_in_stock_rec_.qty_reserved);  
            IF (reserved_qty_to_pick_ > 0 ) THEN
               -- Find_Reservations___ Will find all reservations that pass the criteria of pick_by_choice_option_ on the site and returns a table of records contains
               -- the inventory stock reservations in a sort order which pick reported reservations appear at the end of series and not pick listed at the first.
               reserved_stock_tab_ := Find_Reservations___(contract_                => contract_,
                                                           part_no_                 => part_no_,
                                                           configuration_id_        => configuration_id_,
                                                           location_no_             => keys_and_qty_tab_(i).location_no,
                                                           lot_batch_no_            => keys_and_qty_tab_(i).lot_batch_no,
                                                           serial_no_               => keys_and_qty_tab_(i).serial_no,
                                                           eng_chg_level_           => keys_and_qty_tab_(i).eng_chg_level,
                                                           waiv_dev_rej_no_         => keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                           activity_seq_            => keys_and_qty_tab_(i).activity_seq,
                                                           handling_unit_id_        => keys_and_qty_tab_(i).handling_unit_id,
                                                           qty_to_ureserve_         => reserved_qty_to_pick_,
                                                           pick_by_choice_option_   => pick_by_choice_option_);
            ELSE
               -- No need to lock the stock records when there is enough available stock records to consume
               @ApproveTransactionStatement(2016-09-28,khvese)   
               ROLLBACK TO before_stock_locked; 
            END IF;

            LOOP 
               @ApproveTransactionStatement(2016-09-28,khvese)   
               SAVEPOINT pick_and_adjust;
               IF (reserved_qty_to_pick_ > 0 ) THEN
                  -- exit if there is not enough quantity in reserved_stock_tab_ to unreserve
                  EXIT WHEN NOT Have_Enough_Qty_To_Pick___(reserved_qty_to_pick_, reserved_stock_tab_);

                  qty_unreserved_ := 0;
                  Unreserve_Stock___(qty_unreserved_, reserved_stock_tab_, -reserved_qty_to_pick_);
                  -- if qty_unreserved_ is less than reserved_qty_to_pick_ means there is not enough reserved stock that
                  -- pass our criteria to unreserve and it will exit the loop and the consequently the method with fail.  
                  EXIT WHEN qty_unreserved_ < reserved_qty_to_pick_ ; 
               END IF;   

               qty_reserved_ := 0;
               -- Reserve available stock (unreserved stock) for current pick list line. 
               Reserve_Stock___(quantity_reserved_   => qty_reserved_, 
                                source_ref1_         => source_ref1_,  
                                source_ref2_         => source_ref2_,  
                                source_ref3_         => source_ref3_, 
                                source_ref4_         => source_ref4_, 
                                source_ref_type_db_  => source_ref_type_db_,
                                contract_            => contract_,
                                part_no_             => part_no_,
                                configuration_id_    => configuration_id_,
                                location_no_         => keys_and_qty_tab_(i).location_no, 
                                lot_batch_no_        => keys_and_qty_tab_(i).lot_batch_no, 
                                serial_no_           => keys_and_qty_tab_(i).serial_no, 
                                eng_chg_level_       => keys_and_qty_tab_(i).eng_chg_level, 
                                waiv_dev_rej_no_     => keys_and_qty_tab_(i).waiv_dev_rej_no, 
                                activity_seq_        => keys_and_qty_tab_(i).activity_seq, 
                                handling_unit_id_    => keys_and_qty_tab_(i).handling_unit_id,
                                pick_list_no_        => pick_list_no_,
                                shipment_id_         => shipment_id_, 
                                quantity_to_reserve_ => keys_and_qty_tab_(i).quantity);

               EXIT WHEN qty_reserved_ < keys_and_qty_tab_(i).quantity ;

               IF (reserved_qty_to_pick_ > 0 ) THEN
                  qty_reserved_ := 0; 
                  -- Find and reserve stock for source refrences that lost their reservation.
                  Find_And_Reserve_Stock___(qty_reserved_, reserved_stock_tab_, reserved_qty_to_pick_);
                  IF NVL(qty_reserved_, 0) < reserved_qty_to_pick_ THEN 
                     -- exit if there is not enough quantity in reserved_stock_tab_ to unreserve
                     EXIT WHEN NOT Have_Enough_Qty_To_Pick___(reserved_qty_to_pick_, reserved_stock_tab_);
                     Reset_Reservations___(reserved_stock_tab_);
                     @ApproveTransactionStatement(2016-09-28,khvese)   
                     ROLLBACK TO pick_and_adjust; 
                  ELSE 
                     transaction_succeeded_ := TRUE;
                     EXIT;
                  END IF ; 
               ELSE 
                  transaction_succeeded_ := TRUE;
                  EXIT;
               END IF;  
            END LOOP; 
         END IF;   
         
         IF NOT transaction_succeeded_ THEN 
            RAISE exit_with_fail;
         END IF ;
      END LOOP;
      
      -- It is very important to keep picking in seperate loop outside of the reservation loop since we want to do reservation(s) first and then pick the new reservation(s)
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP

         IF (i = keys_and_qty_tab_.LAST) THEN
            last_line_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         
         Pick_Stock_Reservations___(qty_picked_                => qty_picked_, 
                                    all_reported_              => all_reported_, 
                                    session_id_                => session_id_, 
                                    pick_list_no_              => pick_list_no_, 
                                    source_ref1_               => source_ref1_, 
                                    source_ref2_               => source_ref2_, 
                                    source_ref3_               => source_ref3_, 
                                    source_ref4_               => source_ref4_, 
                                    source_ref_type_db_        => source_ref_type_db_,
                                    contract_                  => contract_, 
                                    part_no_                   => part_no_, 
                                    configuration_id_          => configuration_id_, 
                                    location_no_               => keys_and_qty_tab_(i).location_no, 
                                    lot_batch_no_              => keys_and_qty_tab_(i).lot_batch_no, 
                                    serial_no_                 => keys_and_qty_tab_(i).serial_no, 
                                    eng_chg_level_             => keys_and_qty_tab_(i).eng_chg_level, 
                                    waiv_dev_rej_no_           => keys_and_qty_tab_(i).waiv_dev_rej_no, 
                                    activity_seq_              => keys_and_qty_tab_(i).activity_seq, 
                                    handling_unit_id_          => keys_and_qty_tab_(i).handling_unit_id, 
                                    input_qty_                 => keys_and_qty_tab_(i).input_qty, 
                                    input_conv_factor_         => keys_and_qty_tab_(i).input_conv_factor, 
                                    input_unit_meas_           => keys_and_qty_tab_(i).input_unit_meas, 
                                    input_variable_values_     => keys_and_qty_tab_(i).input_variable_values, 
                                    qty_to_pick_               => keys_and_qty_tab_(i).quantity, 
                                    catch_qty_to_pick_         => keys_and_qty_tab_(i).catch_quantity, 
                                    part_tracking_session_id_  => keys_and_qty_tab_(i).part_tracking_session_id, 
                                    shipment_id_               => shipment_id_, 
                                    ship_location_no_          => ship_location_no_, 
                                    add_hu_to_shipment_        => add_hu_to_shipment_,
                                    close_line_                => close_line_, 
                                    last_line_                 => last_line_,
                                    trigger_shipment_flow_     => trigger_shipment_flow_);
         IF qty_picked_ = 0 THEN 
            transaction_succeeded_ := FALSE;
         END IF ; 
      END LOOP;
   END IF;
EXCEPTION
   WHEN not_allowed THEN
      Raise_Picking_Not_Allowed_Error___;
   WHEN exit_with_fail THEN
      Error_SYS.Record_General(lu_name_, 'NOTENOUGHQTY: Picking failed due to insufficient available stock.');
   WHEN OTHERS THEN
      RAISE;
END Pick_By_Choice;

-- Pick_Hu_By_Choice_Allowed
-- Return DB_TRUE if Handling Unit is not partially picked and satisfy the site setting for Pick by Choice
@UncheckedAccess
FUNCTION Pick_Hu_By_Choice_Allowed (
   pick_list_no_           IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
   ref_handling_unit_id_   IN NUMBER,
   contract_               IN VARCHAR2,
   handling_unit_id_       IN NUMBER ) RETURN VARCHAR2 
IS
   pick_by_choice_allowed_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   pick_by_choice_option_  VARCHAR2(20);
   dummy_                  NUMBER;
   
   handling_unit_ref_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;

   CURSOR check_exist(hu_id_ NUMBER) IS
      SELECT 1  
      FROM  INV_PART_STOCK_RES_MOVE 
      WHERE contract                 = contract_
      AND   handling_unit_id = hu_id_
      AND   ((pick_list_no       = pick_list_no_
      AND   order_supply_demand_type_db = source_ref_type_db_)
      OR   (CASE WHEN (NVL(pick_list_no, '*') = '*') AND (pick_by_choice_option_ IN ('ALLOWED', 'NOT_PICK_LISTED', 'NOT_PRINTED_PICKLIST'))  THEN 1
                 WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'FALSE') AND (pick_by_choice_option_ IN ('ALLOWED','NOT_PRINTED_PICKLIST')) THEN 1
                 WHEN (pick_list_no != '*') AND (pick_list_printed_db = 'TRUE') AND (pick_by_choice_option_ = 'ALLOWED') THEN 1
                 ELSE 0
            END = 1)
      AND   pick_by_choice_blocked_db = Fnd_Boolean_API.DB_FALSE
      AND   order_supply_demand_type_db IN ( Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_1_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_2_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_3_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_4_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_5_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_6_,
                                             Inv_Part_Stock_Reservation_API.pick_by_choice_src_type_7_))
      HAVING SUM(NVL(qty_picked,0)) = 0;
BEGIN
   pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);

   IF pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
      IF Handling_Unit_API.Get_Has_Stock_Reservation_Db(handling_unit_id_) = Fnd_Boolean_API.DB_FALSE THEN 
         pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
      ELSIF ref_handling_unit_id_ IS NOT NULL AND ref_handling_unit_id_ = handling_unit_id_  THEN        
         pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
      ELSE  
         handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
         IF handling_unit_id_tab_.Count > 0 THEN
            FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
               OPEN check_exist(handling_unit_id_tab_(i).handling_unit_id);
               FETCH check_exist INTO dummy_;
               CLOSE check_exist;
               IF dummy_ IS NOT NULL THEN
                  pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      END IF;
      
      IF  pick_by_choice_allowed_ = Fnd_Boolean_API.DB_FALSE AND  ref_handling_unit_id_ IS NOT NULL THEN
         -- check if handling_unit_id is eual to one of the reserved handlingunit id children.
         handling_unit_ref_tab_ := Handling_Unit_API.Get_Node_And_Descendants(ref_handling_unit_id_);
         IF handling_unit_ref_tab_.Count > 0 THEN
            FOR i IN handling_unit_ref_tab_.FIRST..handling_unit_ref_tab_.LAST LOOP

               IF handling_unit_ref_tab_(i).handling_unit_id = handling_unit_id_ THEN
                  pick_by_choice_allowed_ := Fnd_Boolean_API.DB_TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      END IF;
      
   END IF; 
   RETURN pick_by_choice_allowed_;
END Pick_Hu_By_Choice_Allowed;   


-- Pick_Hu_By_Choice
-- Pick Handling Unit by choice if the site setting for Pick by Choice is satisfied and new reservation is allowed.
PROCEDURE Pick_Hu_By_Choice ( 
   message_               IN CLOB,
   contract_              IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   ship_location_no_      IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   trigger_shipment_flow_ IN VARCHAR2 DEFAULT 'TRUE' ) 
IS
   stock_reservation_tab_   Inv_Part_In_Stock_Res_Table;   
   pick_list_line_tab_      Inv_Part_In_Stock_Res_Table;
   handling_unit_id_tab_    Handling_Unit_API.Handling_Unit_Id_Tab;
   inv_part_in_stock_tab_   Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   source_part_no_          VARCHAR2(25);
   new_part_no_             VARCHAR2(25);
   has_reservation_db_      VARCHAR2(5) := 'FALSE';
   qty_reserved_            NUMBER;
   qty_unreserved_          NUMBER;
   qty_to_reserve_          NUMBER;
   hu_picked_               NUMBER := 0;
   last_line_               VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   erroneous_hu_id_         NUMBER;
   session_id_              NUMBER;
   over_under_pick_allowed_ BOOLEAN;
   pick_by_choice_blocked_  VARCHAR2(5);
   mixed_part               EXCEPTION;
   unmatched_part           EXCEPTION;
   partially_picked         EXCEPTION;     
   pick_hu_not_allowed      EXCEPTION;     
   reservation_error        EXCEPTION;     
   over_pick                EXCEPTION;
   under_pick               EXCEPTION;
   source_ref_type_error    EXCEPTION;
   not_allowed              EXCEPTION;
   pick_by_choice_blocked   EXCEPTION;
BEGIN
   Check_Source_Ref_Type_Db__(source_ref_type_db_);
   
   -- erroneous_hu_id_ will be use as a parameter in the error messages. 
   erroneous_hu_id_ := handling_unit_id_;
   IF Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_) = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
      RAISE not_allowed;
   ELSIF Handling_Unit_API.Get_Composition(handling_unit_id_) = Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_MIXED) THEN
      RAISE mixed_part;
   ELSIF Inv_Part_Stock_Reservation_API.Get_Qty_Picked(handling_unit_id_) != 0 THEN 
      RAISE partially_picked;
   END IF;

   pick_by_choice_blocked_ := Inv_Part_Stock_Reservation_API.Get_Pick_By_Choice_Blocked_Db(handling_unit_id_);
   
   Unreserve_Handling_Unit___(qty_unreserved_, pick_list_line_tab_, handling_unit_id_);
   
   IF (qty_unreserved_ = 0) THEN
      RAISE reservation_error;
   END IF;

   -- Remove duplicated source refrences from table of record and add their quantity to their equivalent record
   Remove_Duplicate_Source_Ref___(pick_list_line_tab_);
   over_under_pick_allowed_ := pick_list_line_tab_.Count = 1;

   -- Unpack the message to a table of record
   Unpack_Hu_Attribute_string___(handling_unit_id_tab_  => handling_unit_id_tab_,
                                 message_               => message_);
   -- Rais Error if duplicated handling unit is in the collection or a handling unit and its parent(s) are in the collection
   Check_Handl_Unit_Attributes___(handling_unit_id_tab_);
   source_part_no_          := Handling_Unit_API.Get_Part_No(handling_unit_id_);

   IF handling_unit_id_tab_.Count > 0 THEN 
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         -- Validation block start...
         new_part_no_     := Handling_Unit_API.Get_Part_No(handling_unit_id_tab_(i).handling_unit_id);
         
         -- erroneous_hu_id_ will be used as a parameter in the error messages
         erroneous_hu_id_ := handling_unit_id_tab_(i).handling_unit_id;
         IF (new_part_no_ = mixed_value_) THEN 
            RAISE mixed_part;
         ELSIF (new_part_no_ != source_part_no_) THEN 
            RAISE unmatched_part;
         ELSIF (Inv_Part_Stock_Reservation_API.Get_Qty_Picked(handling_unit_id_tab_(i).handling_unit_id) != 0) THEN 
            RAISE partially_picked;
         ELSIF (Pick_Hu_By_Choice_Allowed(pick_list_no_, source_ref_type_db_, handling_unit_id_, contract_, handling_unit_id_tab_(i).handling_unit_id) != Fnd_Boolean_API.DB_TRUE) THEN 
            RAISE pick_hu_not_allowed;
         ELSIF (pick_by_choice_blocked_ = Fnd_Boolean_API.DB_TRUE AND handling_unit_id_ != handling_unit_id_tab_(i).handling_unit_id) THEN 
            RAISE pick_by_choice_blocked;
         END IF;
         -- Validation block end...

         inv_part_in_stock_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_tab_(i).handling_unit_id);
         has_reservation_db_    := Handling_Unit_API.Get_Has_Stock_Reservation_Db(handling_unit_id_tab_(i).handling_unit_id);
         
         IF has_reservation_db_ = Fnd_Boolean_API.DB_TRUE THEN 
            -- Lock handling unit and its descendants
            Handling_Unit_API.Lock_Node_And_Descendants(handling_unit_id_tab_(i).handling_unit_id);
            
            -- the method will unreserve the reserved stock records attached to the handling unit structure
            -- and will return stock_reservation_tab_ as a table of record of unreserved orders with all keys
            -- this table of record will be use later to find reservation for the order lines that lost their reservation.
            qty_unreserved_ := 0;
            Unreserve_Handling_Unit___(qty_unreserved_         => qty_unreserved_,
                                       stock_reservation_tab_  => stock_reservation_tab_,
                                       handling_unit_id_       => handling_unit_id_tab_(i).handling_unit_id);
            Remove_Duplicate_Source_Ref___(stock_reservation_tab_);
                              
            IF (qty_unreserved_ = 0) THEN  
               RAISE reservation_error;
            END IF;
         END IF; 
         
         qty_to_reserve_ := 0;
         IF (pick_list_line_tab_.COUNT > 0 AND inv_part_in_stock_tab_.COUNT > 0 ) THEN
            FOR j IN pick_list_line_tab_.FIRST .. pick_list_line_tab_.LAST LOOP
               IF pick_list_line_tab_(j).quantity > 0 THEN 
                  <<inner_loop>>
                  FOR k IN inv_part_in_stock_tab_.FIRST .. inv_part_in_stock_tab_.LAST LOOP
                     IF inv_part_in_stock_tab_(k).quantity > 0 THEN 
                        IF (inv_part_in_stock_tab_(k).quantity < pick_list_line_tab_(j).quantity) THEN
                           qty_to_reserve_ := inv_part_in_stock_tab_(k).quantity;
                           IF over_under_pick_allowed_ AND i = handling_unit_id_tab_.LAST AND k = inv_part_in_stock_tab_.LAST THEN 
                              -- Under pick if it is last stock attached to last handling unit
                              pick_list_line_tab_(j).quantity := 0;
                           ELSIF NOT over_under_pick_allowed_ AND (i = handling_unit_id_tab_.LAST AND k = inv_part_in_stock_tab_.LAST) THEN
                              RAISE under_pick;
                           ELSE 
                              pick_list_line_tab_(j).quantity := pick_list_line_tab_(j).quantity - qty_to_reserve_;
                           END IF ;
                           inv_part_in_stock_tab_(k).quantity := 0;
                        ELSE
                           IF over_under_pick_allowed_ THEN 
                              -- over picking :  pick_list_line_tab_ has only one record
                              qty_to_reserve_ := inv_part_in_stock_tab_(k).quantity;
                              inv_part_in_stock_tab_(k).quantity := 0;
                              IF i = handling_unit_id_tab_.LAST AND k = inv_part_in_stock_tab_.LAST THEN 
                                 -- if it is last handling unit and last stock record in handling unit we set pick_list_line_tab_ qty to zero otherwise 
                                 -- we keep the qty to be able to continue with over picking.
                                 pick_list_line_tab_(j).quantity := 0;
                              END IF ;
                           ELSIF (inv_part_in_stock_tab_(k).quantity > pick_list_line_tab_(j).quantity) AND j = pick_list_line_tab_.LAST THEN  
                              RAISE over_pick;
                           ELSE 
                              qty_to_reserve_ := pick_list_line_tab_(j).quantity;
                              inv_part_in_stock_tab_(k).quantity := inv_part_in_stock_tab_(k).quantity - qty_to_reserve_;
                              pick_list_line_tab_(j).quantity := 0;
                           END IF;
                        END IF ; 

                        qty_reserved_ := 0;
                        Reserve_Stock___(quantity_reserved_   => qty_reserved_, 
                                         source_ref1_         => pick_list_line_tab_(j).source_ref1,  
                                         source_ref2_         => pick_list_line_tab_(j).source_ref2,  
                                         source_ref3_         => pick_list_line_tab_(j).source_ref3, 
                                         source_ref4_         => pick_list_line_tab_(j).source_ref4, 
                                         source_ref_type_db_  => source_ref_type_db_,
                                         contract_            => pick_list_line_tab_(j).contract,
                                         part_no_             => pick_list_line_tab_(j).part_no,
                                         configuration_id_    => pick_list_line_tab_(j).configuration_id,
                                         location_no_         => inv_part_in_stock_tab_(k).location_no, 
                                         lot_batch_no_        => inv_part_in_stock_tab_(k).lot_batch_no, 
                                         serial_no_           => inv_part_in_stock_tab_(k).serial_no, 
                                         eng_chg_level_       => inv_part_in_stock_tab_(k).eng_chg_level, 
                                         waiv_dev_rej_no_     => inv_part_in_stock_tab_(k).waiv_dev_rej_no, 
                                         activity_seq_        => inv_part_in_stock_tab_(k).activity_seq,
                                         handling_unit_id_    => inv_part_in_stock_tab_(k).handling_unit_id,
                                         pick_list_no_        => pick_list_line_tab_(j).pick_list_no,
                                         shipment_id_         => pick_list_line_tab_(j).shipment_id, 
                                         quantity_to_reserve_ => qty_to_reserve_);

                        IF qty_reserved_ < qty_to_reserve_ THEN 
                           RAISE reservation_error;
                        END IF;
                        EXIT inner_loop WHEN pick_list_line_tab_(j).quantity = 0;
                     END IF;
                  END LOOP; 
               END IF;
            END LOOP;
         END IF;
         
         IF has_reservation_db_ = Fnd_Boolean_API.DB_TRUE THEN 
            IF stock_reservation_tab_.COUNT > 0 THEN 
               FOR j IN stock_reservation_tab_.FIRST .. stock_reservation_tab_.LAST LOOP
                  qty_reserved_ := 0;
                  Find_And_Reserve_Stock___(qty_reserved_, stock_reservation_tab_, stock_reservation_tab_(j).quantity);
                  IF NVL(qty_reserved_, 0) <= 0 THEN 
                     RAISE reservation_error;
                  END IF ;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
      
      -- It is very important to keep picking in seperate loop outside of the reservation loop since we want to do reservation(s) first and then pick the new reservation(s)
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         -- Pick_Reservations_HU__ commits transactions if pick to shipment location happens(Commit happen in Start_Shipment_Flow).
         -- Perform Pick operation at the end to prevent commit to happen before all reservation is done.
         IF (i = handling_unit_id_tab_.LAST) THEN
            last_line_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         
         Pick_Hu_Reservations___(hu_picked_                 => hu_picked_, 
                                 session_id_                => session_id_, 
                                 pick_list_no_              => pick_list_no_,
                                 source_ref_type_db_        => source_ref_type_db_,
                                 handling_unit_id_          => handling_unit_id_tab_(i).handling_unit_id, 
                                 ship_location_no_          => ship_location_no_, 
                                 last_line_                 => last_line_,
                                 trigger_shipment_flow_     => trigger_shipment_flow_);
         IF hu_picked_ = 0 THEN 
            RAISE pick_hu_not_allowed;
         END IF ; 
      END LOOP;
   END IF;
EXCEPTION
   WHEN not_allowed OR pick_by_choice_blocked THEN
      Error_SYS.Record_General(lu_name_, 'PICKBYCHOICEISNOTALLOWED: Picking another handling unit than the one that is already reserved is not allowed. Check the configuration setting.');
   WHEN mixed_part THEN
      Error_SYS.Record_General(lu_name_, 'MIXPARTNOTALLOWED: Handling unit :P1 have mixed parts. Picking by choice is not allowed for handling unit with mixed part.', erroneous_hu_id_);
   WHEN unmatched_part THEN
      Error_SYS.Record_General(lu_name_, 'NEWPARTNONOTALLOWED: Handling unit :P1 doesn''t correspond to the order line details.', erroneous_hu_id_);
   WHEN partially_picked THEN
      Error_SYS.Record_General(lu_name_, 'PARTIALLYPICKEDNOTALLOWED: Picking handling unit :P1 is not allowed because it is picked or partially picked.', erroneous_hu_id_);
   WHEN pick_hu_not_allowed THEN
      Error_SYS.Record_General(lu_name_, 'PICKHUISNOTALLOWED: Picking handling unit :P1 is not allowed. Check the configuration setting.', erroneous_hu_id_);
   WHEN reservation_error THEN
      Error_SYS.Record_General(lu_name_, 'RESERVEHUFAILED: Handling unit :P1 cannot be picked. (Un)reserve process failed. Check the handling unit details', erroneous_hu_id_);
   WHEN over_pick THEN
      Error_SYS.Record_General(lu_name_, 'OVERPICK: Over picking is not allowed since handling unit :P1 consists of several order lines. Over picking can be performed on detail level.', handling_unit_id_);
   WHEN under_pick THEN
      Error_SYS.Record_General(lu_name_, 'UNDERPICK: Picking less than what is reserved is not allowed since handling unit :P1 consists of several order lines. Picking can be performed on detail level.', handling_unit_id_);
   WHEN source_ref_type_error THEN
      Raise_Pick_Choice_Not_Allowed___(erroneous_hu_id_);
   WHEN OTHERS THEN
      RAISE;
END Pick_Hu_By_Choice;

-------------------- LU  NEW METHODS -------------------------------------
