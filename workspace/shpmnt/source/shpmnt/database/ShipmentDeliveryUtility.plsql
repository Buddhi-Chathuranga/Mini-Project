-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentDeliveryUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220808  Aabalk  SCDEV-13038, Modified Deliver_Shipment method to use automatic receipt value as true only when a shipment contains only shipment order lines.
--  220728  MaEelk  SCDEV-10873, Added Validate_Tax_Doc_Connection___ to check if active tax document connected to the shipment
--  220727  SaLelk  SCDEV-12912, Modified Deliver_Shipment and validate that DESADV is configured on company level before running the Automatic Receipt.
--  220713  MaEelk  SCDEV-11672, Modified Deliver_Ship_Line_Inv___ to calculate Amounts and Taxes in connected Tax Document.
--  220705  SaLelk  SCDEV-7837, Added new method Deliver_Shipment to deliver shipment by source_ref1_, etc.
--  220629  SaLelk  SCDEV-7837, Modified Deliver_Shipment to Send Dispatch Advice for automatic receipt and send it after post deliver actions.
--  220530  PrRtlk  SCZ-18337, Deadlock in Shipment Picking (Cloned  from SCZ-18115)
--  220510  SaLelk  SCDEV-7796, Modified Deliver_Shipment by handling the sender and receiver can not be the same validation.
--  220411  PrRtlk  SCDEV-8742, Modified Unissue_Delivered_Parts___ to bypass the SHPMNTDELIVEARLIER error message for Supplier Return Type.
--  220318  AsZelk  SCDEV-7716, Added Undo_Deliv_Shp_Line_Non_Inv___() and Modified Do_Undo_Shipment_Delivery().
--  220126  RasDlk  SC21R2-7374, Modified Unissue_Delivered_Parts___ by changing the error message for old deliveries.
--  220118  ErRalk  SC21R2-7072, Modified Shipment_Source_Utility_API.Pre_Deliver_Shipment_Line call by passing shipment_id as a paramater.
--  211230  RasDlk  SC21R2-3145, Added the methods Do_Undo_Shipment_Delivery, Undo_Deliv_Shp_Line_Inv___ and Unissue_Delivered_Parts___  to support Undo Shipment Delivery 
--  211230          for sources other than Customer Order.
--  211221  ErRalk  SC21R2-2980, Modified Deliver_Ship_Line_Inv___ to fetch delivery transaction for supplier return.
--  201105  DaZase  Bug 156393 (SCZ-12164), Removed route_id from Create_Data_Capture_Lov/Record_With_Column_Value_Exist since it dont work here because that column is not saved for shipments. 
--  200424  RoJalk  SC2020R1-1977, Modified Deliver_Ship_Line_Inv__to pass ignore_this_avail_control_id_ 
--  200424          to Inventory_Part_Reservation_API.Issue_Shipment_Line.
--  200512  MalLlk  GESPRING20-4424, Modified Deliver_Shipment() to proceed with the shipment delivery although no delivery note created
--  200512          with localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES'.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200220  NiEdlk  Bug 152123(SCZ-8776), Modified the order by statment of get_lines curosr in Deliver_Shipment.
--  191114  RoJalk  SCSPRING20-984, Modified Deliver_Ship_Line_Inv___ and passed source_ref1_ to 
--  191114          Shipment_Source_Utility_API.Get_Delivery_Transaction_Code to support Shipment Order.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  170830  KhVese  STRSC-9595, Added methods Record_With_Column_Value_Exist and Create_Data_Capture_Lov.
--  170210  Jhalse  LIM-10150, Added snapshot for when delivering a shipment using a generic source.
--  170124  MaIklk  LIM-9819, Handled to send "*" to InventoryPartReservation when source ref columns are NULL. 
--  170123  MaRalk  LIM-10080, Removed default null clause from Deliver_Shipment method and implement
--  170123          to handle inventory_event_id_ parameter when null values passing. 
--  170113  MaRalk  LIM-10080, Modified Deliver_Ship_Line_Inv___ to use Inventory_Part_Reservation_API.Issue_Shipment_Line.
--  170113          Added method Post_Update_Delivery_Actions.
--  161110  MaRalk  LIM-9129, Added method Deliver_Ship_Line_Inv___ and modified Deliver_Shipment.
--  161101  MaRalk  LIM-9143, Modified Deliver_Shipment. Added parameter qty_to_ship_ to Deliver_Ship_Line_Non_Inv___.
--  161026  MaRalk  LIM-9153, Created. Added method Deliver_Ship_Line_Non_Inv___.
--  161026          Moved methods Deliver_Shipment, Handle_Dates_On_Delivery___ from Shipment LU and modified.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
                                 
PROCEDURE Deliver_Ship_Line_Inv___(
   info_               OUT VARCHAR2,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2,
   delnote_no_         IN  VARCHAR2,   
   shipment_id_        IN  NUMBER )
IS 
   shipment_line_rec_            SHIPMENT_LINE_API.Public_Rec;     
   transaction_code_             VARCHAR2(10);
   dest_contract_                VARCHAR2(5);
   dest_warehouse_id_            VARCHAR2(15);
   ignore_this_avail_control_id_ VARCHAR2(25);

BEGIN 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Deliver_Customer_Order_API.Deliver_Ship_Line_Inv(info_               => info_, 
                                                          order_no_           => source_ref1_, 
                                                          line_no_            => source_ref2_, 
                                                          rel_no_             => source_ref3_, 
                                                          line_item_no_       => source_ref4_, 
                                                          delnote_no_         => delnote_no_, 
                                                          shipment_id_        => shipment_id_);
      $ELSE
         NULL;
      $END
   ELSE 
      shipment_line_rec_ := Shipment_Line_API.Get_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
      -- Fetch the relevant transaction_code 
      Shipment_Source_Utility_API.Get_Delivery_Transaction_Info(transaction_code_, dest_contract_, dest_warehouse_id_, 
                                                                ignore_this_avail_control_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);      
      --  Handle source specific code to update source line attributes before the delivery.
      Shipment_Source_Utility_API.Pre_Deliver_Shipment_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 0, shipment_line_rec_.qty_picked, shipment_id_);  
      -- Issue shipment line  
      Inventory_Part_Reservation_API.Issue_Shipment_Line(source_ref1_, NVL(source_ref2_,'*'),  NVL(source_ref3_,'*'),  NVL(source_ref4_,'*'), source_ref_type_db_,
                                                         shipment_id_, transaction_code_, dest_contract_, dest_warehouse_id_, ignore_this_avail_control_id_); 
      
      -- Handle source specific code to update source line attributes after shipment line quantity update.
      Shipment_Source_Utility_API.Post_Deliver_Shipment_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, 0, shipment_line_rec_.qty_picked, transaction_code_);
   END IF;   
END Deliver_Ship_Line_Inv___;


PROCEDURE Deliver_Ship_Line_Non_Inv___ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,   
   shipment_id_        IN NUMBER,   
   delnote_no_         IN VARCHAR2,
   qty_to_ship_        IN NUMBER)
IS  
BEGIN 
   -- If the shipment line source ref type is Customer Order, order specific delivery process is called.
   -- Otherwise Shipment Delivery is done through semi-centralized delivery process. 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Deliver_Customer_Order_API.Deliver_Ship_Line_Non_Inv(order_no_     => source_ref1_,
                                                              line_no_      => source_ref2_, 
                                                              rel_no_       => source_ref3_,
                                                              line_item_no_ => source_ref4_, 
                                                              delnote_no_   => delnote_no_, 
                                                              shipment_id_  => shipment_id_);
      $ELSE
         NULL;
      $END   
   ELSE  
      IF (qty_to_ship_ != 0) THEN
         --  Handle source specific code to update source line attributes before shipment line quantity update.
         Shipment_Source_Utility_API.Pre_Deliver_Shipment_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, qty_to_ship_, 0, shipment_id_);  
         
         -- Shipment Line Quantity Update
         Shipment_Line_API.Modify_On_Delivery(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);  

         -- Handle source specific code to update source line attributes after shipment line quantity update.
         Shipment_Source_Utility_API.Post_Deliver_Shipment_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, qty_to_ship_, 0);
      END IF;
   END IF;
END Deliver_Ship_Line_Non_Inv___;

PROCEDURE Handle_Dates_On_Delivery___  (
   shipment_id_     IN NUMBER ) 
IS 
   shipment_rec_  Shipment_API.Public_Rec;
   site_date_     DATE;
   shipment_attr_ VARCHAR2(2000); 
BEGIN 
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   site_date_ := Site_API.Get_Site_Date(shipment_rec_.contract);    
   Client_SYS.Clear_Attr(shipment_attr_);   
   Client_SYS.Add_To_Attr('ACTUAL_SHIP_DATE', site_date_, shipment_attr_); 
   IF (shipment_rec_.planned_ship_date IS NULL) THEN
      Client_SYS.Add_To_Attr('PLANNED_SHIP_DATE',  site_date_, shipment_attr_); 
   END IF; 
   Shipment_API.Modify(shipment_attr_, shipment_id_); 
END Handle_Dates_On_Delivery___;


@IgnoreUnitTest NoOutParams
PROCEDURE Undo_Deliv_Shp_Line_Inv___(
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2,   
   shipment_id_        IN  NUMBER)
IS   
BEGIN 
   Unissue_Delivered_Parts___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_);
END Undo_Deliv_Shp_Line_Inv___;

@IgnoreUnitTest NoOutParams
PROCEDURE Undo_Deliv_Shp_Line_Non_Inv___(
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2,   
   shipment_id_        IN  NUMBER,
   undo_qty_           in  NUMBER )
IS   
BEGIN
   Shipment_Line_API.Modify_On_Undo_Delivery(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 0, undo_qty_);
END Undo_Deliv_Shp_Line_Non_Inv___;

PROCEDURE Unissue_Delivered_Parts___(
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,   
   shipment_id_        IN NUMBER)
IS
   undo_available_   BOOLEAN;
BEGIN                                            
   Inventory_Part_Reservation_API.Unissue_Shipment_Line(undo_available_,
                                                        source_ref1_, 
                                                        source_ref2_, 
                                                        source_ref3_, 
                                                        source_ref4_, 
                                                        Reserve_Shipment_API.Get_Inv_Res_Source_Type_Db(source_ref_type_db_), 
                                                        shipment_id_);
   IF (NOT undo_available_ AND source_ref_type_db_ != Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      -- Undo not supported for source objects which do not have a value for shipment id.
      Error_SYS.Record_General(lu_name_, 'SHPMNTDELIVEARLIER: Shipment has been delivered in an earlier release and cannot be undone.');
   END IF;
END Unissue_Delivered_Parts___;

PROCEDURE Validate_Tax_Doc_Connection___ (
   shipment_id_   IN NUMBER)
IS 
   shipment_rec_   Shipment_API.Public_Rec;   
BEGIN
   shipment_rec_  := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.source_ref_type IN ('^SHIPMENT_ORDER^')) THEN
      IF (Tax_Document_API.Active_Tax_Document_Exist(shipment_rec_.shipment_id, Site_API.Get_Company(shipment_rec_.contract),'SHIPMENT','OUTBOUND') = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'TAXDOCEXIST: You have to cancel the connected outgoing tax document before undo delivery of the shipment');   
      END IF;
   END IF;
END Validate_Tax_Doc_Connection___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
                                                                
-- Deliver_Shipment__
--   Deliver lines connected to a shipment.
PROCEDURE Deliver_Shipment (
   shipment_id_        IN NUMBER )
IS
   delnote_no_                  VARCHAR2(15);
   line_delivered_              NUMBER := 0;
   shipment_rec_                Shipment_API.Public_Rec;    
   media_code_                  VARCHAR2(30);
   info_                        VARCHAR2(32000) := NULL;
   deliver_allowed_             VARCHAR2(5):='FALSE';  
   inventory_event_id_          NUMBER;
   inv_part_reservation_tab_    Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   automatic_receipt_           BOOLEAN    := FALSE;
   all_shipod_lines_            BOOLEAN    := TRUE;
   
   CURSOR get_lines IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, inventory_part_no, qty_to_ship
        FROM SHIPMENT_LINE_TAB 
       WHERE shipment_id  =  shipment_id_
         AND (((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) >= 0))
                OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
         AND (qty_picked  >  0 OR qty_to_ship >  0 )
       ORDER BY NVL(inventory_part_no, qty_picked); -- to prevent deadlock 
      
   CURSOR get_reservations IS
      SELECT contract, part_no, ssr.configuration_id, location_no, lot_batch_no, serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, SUM(qty_picked) quantity
      FROM   Shipment_Source_Reservation ssr
      WHERE  ssr.shipment_id         = shipment_id_
      GROUP BY    contract, part_no, configuration_id, location_no, lot_batch_no,
                  serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   shipment_rec_  := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.sender_type = shipment_rec_.receiver_type AND shipment_rec_.sender_id = shipment_rec_.receiver_id) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDRECEIVER: The Sender and Receiver cannot be the same at Delivery.');
   END IF; 
   
   Shipment_Source_Utility_API.Pre_Deliver_Shipment(deliver_allowed_, shipment_id_);   
   
   --Perform delivery if non of the connected orders are blocked
   IF (deliver_allowed_ = 'TRUE') THEN
      -- Create delivery note for the shipment if none exists.
      Create_Delivery_Note_API.Create_Shipment_Deliv_Note(delnote_no_, shipment_id_);
      -- gelr:no_delivery_note_for_services, Modified the condition to check, company localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES' and proceed with the shipment delivery.
      IF (Delivery_Note_API.Exists(delnote_no_) OR Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Shipment_API.Get_Contract(shipment_id_),'NO_DELIVERY_NOTE_FOR_SERVICES') = Fnd_boolean_API.DB_TRUE) THEN
          inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
         --Get all reservervations that is getting delivered
         OPEN get_reservations;
         FETCH get_reservations BULK COLLECT INTO inv_part_reservation_tab_;
         CLOSE get_reservations;
         
         Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_          => inventory_event_id_,
                                                        source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_DELIVERY,
                                                        inv_part_stock_tab_   => inv_part_reservation_tab_);
         FOR linerec_ IN get_lines LOOP
            IF (linerec_.inventory_part_no IS NULL) THEN
               -- Delivery non inventory line.
               Deliver_Ship_Line_Non_Inv___(linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4,  
                                            linerec_.source_ref_type, shipment_id_, delnote_no_, linerec_.qty_to_ship);           
            ELSE 
               -- Delivery inventory line.
               Deliver_Ship_Line_Inv___(info_, linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4,
                                        linerec_.source_ref_type, delnote_no_, shipment_id_); 
            END IF;
            
            -- Check if all lines on the shipment are from a shipment order
            IF linerec_.source_ref_type != Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER AND all_shipod_lines_ THEN
               all_shipod_lines_ := FALSE;
            END IF;
            line_delivered_ := 1;
         END LOOP;
         
         Handl_Unit_Snapshot_Util_API.Delete_Snapshot(source_ref1_         => inventory_event_id_,
                                                      source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_DELIVERY);
                                                      
      ELSE
         Error_SYS.Record_General(lu_name_, 'CANNOTDELIVSHIPMENT: The shipment :P1 cannot be delivered as delivery note has not been created.', shipment_id_);
      END IF;   
      IF line_delivered_ = 1 THEN         
         -- gelr:no_delivery_note_for_services, Skip connecting delivery note, when no delivery note is created.
         IF (delnote_no_ IS NOT NULL) THEN
            -- Connect delivery note to delivery record.
            Create_Delivery_Note_API.Post_Create_Deliv_Note(delnote_no_, shipment_id_);
         END IF;
         Handle_Dates_On_Delivery___(shipment_id_);

         Shipment_Source_Utility_API.Post_Deliver_Shipment(delnote_no_, shipment_id_); 
         
         -- Automatic Receipt will only be used when all lines in a shipment are from a shipment order
         IF (Shipment_Type_API.Get_Automatic_Receipt_Db(shipment_rec_.shipment_type) = Fnd_Boolean_API.DB_TRUE) AND all_shipod_lines_ THEN 
            automatic_receipt_ := TRUE;
         END IF;
         
         -- moved the order of execution to execute all steps on shipment before sending automatic dispatch advice
         -- Sending Automatic Dispatch Advice
         IF (Shipment_Source_Utility_API.Get_Receiver_Auto_Des_Adv_Send(shipment_rec_.receiver_id, shipment_rec_.receiver_type) = Fnd_Boolean_API.DB_TRUE OR automatic_receipt_) THEN
            media_code_ := Shipment_Source_Utility_API.Get_Default_Media_Code(shipment_rec_.receiver_id, 'DESADV', shipment_rec_.receiver_type);
            IF (media_code_ IS NULL AND automatic_receipt_) THEN 
               Error_SYS.Record_General(lu_name_, 'MEDIACODENULL: Message class DESADV needs to be set up on company level in order to run Automatic Receipt at Delivery');
            END IF;
            
            IF (media_code_ IS NOT NULL AND delnote_no_ IS NOT NULL) THEN
               Dispatch_Advice_Utility_API.Send_Dispatch_Advice(delnote_no_, media_code_, automatic_receipt_);
            END IF;
         END IF;
      END IF;    
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Deliver_Shipment;

-- Post_Update_Delivery_Actions
--   Post actions of updating reservation record
PROCEDURE Post_Update_Delivery_Actions (
   shipment_id_                  IN NUMBER,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   inv_part_res_source_type_db_  IN VARCHAR2)
IS  
   logistics_source_type_db_     VARCHAR2(50);     
BEGIN            
   logistics_source_type_db_ := Reserve_Shipment_API.Get_Logistic_Source_Type_Db(inv_part_res_source_type_db_);    
   -- Post actions in Shipment
   -- Shipment Line Quantity Update after the shipment delivery
   Shipment_Line_API.Modify_On_Delivery(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, logistics_source_type_db_);     
   
END Post_Update_Delivery_Actions;


--revise needed
-- This method is used by DataCaptProcessShipment
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_               IN VARCHAR2,
   delnote_no_             IN VARCHAR2,  
   shipment_id_            IN NUMBER,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   forward_agent_id_       IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   capture_session_id_     IN NUMBER,
   column_name_            IN VARCHAR2,
   lov_type_db_            IN VARCHAR2,
   sql_where_expression_   IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   stmt_                   VARCHAR2(4000);
   TYPE Lov_Value_Tab      IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_          Lov_Value_Tab;
   lov_item_description_   VARCHAR2(200);
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_     NUMBER;
   exit_lov_               BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Delivery_Note_Join', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM  Delivery_Note_Join
                           WHERE shipment_id                                        = NVL(:shipment_id_, shipment_id)
                           AND   delnote_no                                         = NVL(:delnote_no_, delnote_no)
                           AND   ((receiver_id = :receiver_id_)                      OR (receiver_id IS NULL AND :receiver_id_ IS NULL)                     OR :receiver_id_ = ''%'')
                           AND   ((forward_agent_id = :forward_agent_id_)            OR (forward_agent_id IS NULL AND :forward_agent_id_ IS NULL)           OR :forward_agent_id_ = ''%'')
                           AND   ((ship_via_code = :ship_via_code_)                  OR (ship_via_code IS NULL AND :ship_via_code_ IS NULL)                 OR :ship_via_code_ = ''%'')
                           AND   contract                                           = :contract_ 
                           AND   shipment_id IS NOT NULL
                           AND   state NOT IN (''Invalid'') ';

      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
      @ApproveDynamicStatement(2017-08-23,KHVESE)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           delnote_no_,
                                           receiver_id_,
                                           receiver_id_,
                                           receiver_id_,
                                           forward_agent_id_,
                                           forward_agent_id_,                                           
                                           forward_agent_id_,
                                           ship_via_code_,
                                           ship_via_code_,                                           
                                           ship_via_code_,
                                           contract_;
         
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ = 'FORWARD_AGENT_ID') THEN
                  lov_item_description_ :=  Forwarder_Info_API.Get_Name(lov_value_tab_(i));
               ELSIF (column_name_ = 'SHIP_VIA_CODE') THEN
                  lov_item_description_ := Mpccom_Ship_Via_API.Get_Description(lov_value_tab_(i));
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


-- This method is used by DataCaptProcessShipment
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_          OUT BOOLEAN,
   contract_               IN VARCHAR2,
   delnote_no_             IN VARCHAR2,  
   shipment_id_            IN NUMBER,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   forward_agent_id_       IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   column_name_            IN  VARCHAR2,
   column_value_           IN  VARCHAR2,
   column_description_     IN VARCHAR2,
   sql_where_expression_   IN  VARCHAR2 DEFAULT NULL,
   raise_error_            IN  BOOLEAN  DEFAULT TRUE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- the conditon null only applies when validating from/to date
   IF column_name_ IS NOT NULL OR column_name_ != '' THEN 
      Assert_SYS.Assert_Is_View_Column('Delivery_Note_Join', column_name_);
   END IF;
   
   stmt_ := ' SELECT 1
              FROM   Delivery_Note_Join
              WHERE  shipment_id                                        = NVL(:shipment_id_, shipment_id)
               AND   delnote_no                                         = NVL(:delnote_no_, delnote_no)
               AND   ((receiver_id = :receiver_id_)                      OR (receiver_id IS NULL AND :receiver_id_ IS NULL)                     OR :receiver_id_ = ''%'')
               AND   ((forward_agent_id = :forward_agent_id_)            OR (forward_agent_id IS NULL AND :forward_agent_id_ IS NULL)           OR :forward_agent_id_ = ''%'')
               AND   ((ship_via_code = :ship_via_code_)                  OR (ship_via_code IS NULL AND :ship_via_code_ IS NULL)                 OR :ship_via_code_ = ''%'')
               AND   contract                                           = :contract_ 
               AND   shipment_id IS NOT NULL
               AND   state NOT IN (''Invalid'') ';

   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   
         Trace_SYS.Field('-----------column_name_', column_name_);
         Trace_SYS.Field('-----------column_value_', column_value_);

   IF column_name_ IS NOT NULL OR column_name_ != '' THEN 
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   END IF;
   
      @ApproveDynamicStatement(2017-08-23,KHVESE)
      OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                           delnote_no_,
                                           receiver_id_,
                                           receiver_id_,
                                           receiver_id_,
                                           forward_agent_id_,
                                           forward_agent_id_,                                           
                                           forward_agent_id_,
                                           ship_via_code_,
                                           ship_via_code_,                                           
                                           ship_via_code_,
                                           contract_,
                                           column_value_,
                                           column_value_;
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF raise_error_ THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
      ELSE
         record_exists_ := FALSE;
      END IF;
   ELSE
      record_exists_ := TRUE;
   END IF;

END Record_With_Column_Value_Exist;


PROCEDURE Do_Undo_Shipment_Delivery (
   undo_complete_    OUT BOOLEAN,
   delnote_no_       OUT NUMBER,
   shipment_id_       IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, qty_shipped, inventory_part_no
      FROM   SHIPMENT_LINE_TAB 
      WHERE  shipment_id = shipment_id_
      AND    source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    qty_shipped > 0;  
            
   undo_shipment_allowed_  BOOLEAN;
   undo_deliver_allowed_   VARCHAR2(5);
   
BEGIN
   undo_complete_          := FALSE;
   delnote_no_             := Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_);   
   undo_shipment_allowed_  := Shipment_API.Undo_Shipment_Allowed(shipment_id_);
   
   IF (undo_shipment_allowed_) THEN
      Validate_Tax_Doc_Connection___(shipment_id_);     
      FOR linerec_ IN get_lines LOOP
         --  Handle source specific code to update source line attributes before the undo delivery.
         Shipment_Source_Utility_API.Pre_Undo_Deliv_Shipment_Line(undo_deliver_allowed_, linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4, linerec_.source_ref_type, linerec_.qty_shipped, shipment_id_); 
         
         IF (undo_deliver_allowed_ = 'TRUE') THEN
            IF (linerec_.inventory_part_no IS NOT NULL) THEN
               -- Unissue shipment line
               Undo_Deliv_Shp_Line_Inv___(linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4, linerec_.source_ref_type, shipment_id_);
            ELSE
               Undo_Deliv_Shp_Line_Non_Inv___(linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4, linerec_.source_ref_type, shipment_id_, linerec_.qty_shipped);
            END IF;
            
            -- Handle source specific code to update source line attributes after shipment line quantity update.
            Shipment_Source_Utility_API.Post_Undo_Deliv_Shipment_Line(linerec_.source_ref1, linerec_.source_ref2, linerec_.source_ref3, linerec_.source_ref4, linerec_.source_ref_type, linerec_.qty_shipped, shipment_id_);
            -- The undo process will not proceed if all lines cannot be undone.
            undo_complete_ := TRUE;
         END IF;
      END LOOP;  
   END IF;
   
   IF (NOT undo_complete_) THEN
      Error_SYS.Record_General(lu_name_, 'SHPMNTDELIVNOTUNDONE: Shipment delivery has not been undone.');
   END IF;
END Do_Undo_Shipment_Delivery;

PROCEDURE Deliver_Shipment (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS  
   CURSOR get_active_shipments IS
      SELECT DISTINCT s.shipment_id, s.shipment_type, s.rowstate
      FROM   shipment_line_tab sl, shipment_tab s
      WHERE  sl.source_ref1 = source_ref1_
      AND    sl.source_ref_type = source_ref_type_db_
      AND    s.shipment_id = sl.shipment_id
      AND    s.rowstate IN ('Preliminary', 'Completed')
      AND    sl.qty_shipped = 0
      ORDER  BY s.rowstate DESC;
      
   TYPE Active_Shipment_Tab   IS TABLE OF get_active_shipments%ROWTYPE INDEX BY PLS_INTEGER;
   active_shipment_tab_       Active_Shipment_Tab;
   attr_                      VARCHAR2(32000);
BEGIN
   OPEN get_active_shipments;
   FETCH get_active_shipments BULK COLLECT INTO active_shipment_tab_;
   CLOSE get_active_shipments;
   FOR i IN 1 .. active_shipment_tab_.COUNT LOOP
      -- We have to make sure all the shipments attach to shipment order is in Completed state to deliver shipments.
      -- If one shipment is not in Completed state then nothing is delivered.
      IF (active_shipment_tab_(i).rowstate != 'Completed') THEN
         Error_SYS.Record_General(lu_name_, 'NOTCOMPLETED: Shipment :P1 must be in status Completed in order to be delivered.', active_shipment_tab_(i).shipment_id);
      END IF;
      
      Client_SYS.Add_To_Attr('START_EVENT', 60, attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID', active_shipment_tab_(i).shipment_id, attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_TYPE', active_shipment_tab_(i).shipment_type, attr_);
      Client_SYS.Add_To_Attr('END', '', attr_);  
      Shipment_Flow_API.Start_Deliver_Shipment__(attr_);
      Client_SYS.Clear_Attr(attr_);
   END LOOP;
END Deliver_Shipment;

-------------------- LU  NEW METHODS -------------------------------------
