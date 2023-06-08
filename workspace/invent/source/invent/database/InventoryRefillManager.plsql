-----------------------------------------------------------------------------
--
--  Logical unit: InventoryRefillManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  191022  BudKlk  Bug 149953(SCZ-7202), Modified Refill_Using_Putaway___ to stop creation of refill job if to_location is situated in a warehouse 
--  191022          where automatic refill is disabled. 
--  190627  SBalLK  SCUXXW4-22873, Modified Refill_All_Putaway_Zones__() method to fetch sql_where_statement seperately since it can be exceed the 4000 chars.
--  190618  NipKlk  Bug 148556 (SCZ-5079), Modified methods Refill_All_Putaway_Zones and Refill_All_Putaway_Zones__ to capture new client value ONLY_ASSORT_CONN_PARTS and
--  190618          modified method Refill_All_Putaway_Zones__ by writing a new cursor to fetch parts that are only connected to remote warehouses to fill the putaway zones and
--  190618          added a new validation method Validate_Refill_Putaway_Zones to validate the new client checkbox value for ONLY_ASSORT_CONN_PARTS.
--  190610  Asawlk  Bug 148655(SCZ-4987), Modified Refill_All_Putaway_Zones__ by removing the COMMIT, to prevent access to the created transport task before 
--  190610          handling unit snapshot being refreshed.
--  180601  UdGnlk  Bug 142266, Modified Refill_Using_Putaway___() to pass the 3rd parameter as NULL to Language_SYS.Translate_Constant().   
--  180427  BudKlk  Bug 141281, Modified the method Refill_All_Putaway_Zones() to add a conditon in order to handle the Deferred_Call when it comes from a schedule task.
--  170809  ErRalk  Bug 135979, Modified messages in Refill_Using_Putaway___ by eliminating duplicated definition for same message and rearranged into PUTAWAYREFILLS1 and PUTAWAYREFILLS2.
--  170427  Chfose  LIM-11445, Fixed handling of inventory_event_id_ inside Refill_All_Putaway_Zones__ to correctly only trigger
--  170427          one HU snapshot refresh but call Putaway_To_Empty_Event_API.Remove_Putaway_Event each time inside the loop.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  151126  JeLise  LIM-4470, Removed parameter include_pallet_locations_ in call to Warehouse_Bay_Bin_API.Get_Putaway_Bins.
--  151029  Chfose  LIM-3941, Removed all code regarding refill using pallets.
--  150128  LEPESE  PRSC-5630, added warning message NOZONEFOUND in Refill_All_Putaway_Zones__ when no putaway zones were found.
--  141127  MAHPLK  PRSC-2774, Modified Using_Pallets_Is_Posted___  and Using_Putaway_Is_Posted___ methods to use overloaded 
--  141127          Transaction_SYS.Get_Posted_Job_Arguments which returns plsql table.
--  140922  LEPESE  PRSC-2518, moved method Get_Next_Putaway_Event_Id___ to InventoryPutawayManager. Added call to
--  140922          Putaway_To_Empty_Event_API.Remove_Putaway_Event in Refill_All_Putaway_Zones__.
--  140321  LEPESE  PBSC-6065, added parameter putaway_event_id_ to methods Refill_Using_Putaway___, Refill_Putaway_Zone___,
--  140321          Refill_This_Location, Refill_Using_Putaway__. Added method Get_Next_Putaway_Event_Id___. Added logic in 
--  140321          method Refill_All_Putaway_Zones__ that picks a putaway_event_id_ from a sequence and passes it on to the
--  140321          putaway logic. Also added call to Remote_Whse_Refill_Event_API.Remove_Part_Event. 
--  130805  ChJalk  TIBE-885, Removed the global variable inst_KanbanManagerInt_.
--  120222  LEPESE  Excluded Kanban controlled locations as refill source in Refill_Other_Locations.
--  120214  LEPESE  Added checks on putaway_zone_refill_option in method Refill_Using_Putaway___.
--  120209  LEPESE  Changed implementation method Is_Kanban_Controlled___ into public Is_Kanban_Controlled.
--  120203  LEPESE  Added methods Is_Kanban_Controlled___, Refill_Using_Pallets___, Refill_Using_Pallets__,
--  120203          Refill_Using_Putaway___ and Refill_Using_Putaway__, Using_Pallets_Is_Posted___, Using_Pallets_Is_Executing,
--  120203          Using_Putaway_Is_Posted___ and Using_Putaway_Is_Executing___. Removed method Refill_Location__.
--  120202  LEPESE  Changed name of method Refill_Location to Refill_This_Location and renamed
--  120202          parameter location_no_ into refill_to_location_no_. Changed name of method
--  120202          Refill_Part to Refill_Other_Locations and added parameter refill_from_locaton_no_.
--  120131  LEPESE  Redesigned Refill_Location to be aware of the "Refill Using Putaway" functionality.
--  120131          Restructured Refill_Location__ by moving the logic related to "Refill From Pallet" functionality
--  120131          to method Refill_Location_From_Pallet___. Added call to Inventory_Part_In_Stock_API.Refill_Using_Putaway
--  120131          from Refill_Location__ for refill_type_ = 'PUTAWAY'.
--  070627  MaJalk  Bug 65026, Modified method Refill_Location__ in order to use the
--  070627          value over_delivery_accepted_ as an in parameter value to method
--  070627          Transport_Task_Manager_API.Find_And_Create_Task.
--  061020  NiDalk  Bug 60372, Modified the call Get_Inventory_Quantity in method Refill_Location__.
--  060123  NiDalk  Added Assert safe annotation. 
--  041112  Asawlk  Bug 46794, Moved some validation checks from Refill_Location__  to
--  041112          Refill_Location. Changed batch desc in Refill_Location.   
--  041005  Asawlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_           CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

TYPE Warehouse_Refill_Source_Rec IS RECORD (
    warehouse_id     VARCHAR2(15),
    refill_source_db VARCHAR2(25));

TYPE Warehouse_Refill_Source_Tab IS TABLE OF Warehouse_Refill_Source_Rec
INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Using_Putaway_Is_Posted___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   to_location_no_   IN VARCHAR2,
   from_location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   local_contract_         inventory_part_in_stock_tab.contract%TYPE;
   local_part_no_          inventory_part_in_stock_tab.part_no%TYPE;
   local_to_location_no_   inventory_part_in_stock_tab.location_no%TYPE;
   local_from_location_no_ inventory_part_in_stock_tab.location_no%TYPE;
   deferred_call_          CONSTANT VARCHAR2(200) := 'Inventory_Refill_Manager_API.Refill_Using_Putaway__';
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   arg_tab_                Transaction_SYS.Arguments_Table;
   attrib_value_           VARCHAR2(32000);
BEGIN
   -- Find the parameters and job id's for the currently executing jobs with
   -- the procedure name that is defined in deferred_call_.
   arg_tab_:= Transaction_SYS.Get_Posted_Job_Arguments(deferred_call_, NULL);
   
   IF (arg_tab_.COUNT > 0) THEN
      FOR i_ IN arg_tab_.FIRST..arg_tab_.LAST LOOP
         attrib_value_   := arg_tab_(i_).arguments_string;
         -- Get the parameter values for the job under investigation.
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
            IF (name_ = 'CONTRACT') THEN
               local_contract_ := value_;
            ELSIF (name_ = 'PART_NO') THEN
               local_part_no_ := value_;
            ELSIF (name_ = 'TO_LOCATION_NO') THEN
               local_to_location_no_ := value_;
            ELSIF (name_ = 'FROM_LOCATION_NO') THEN
               local_from_location_no_ := value_;
            ELSIF (name_ = 'CALLING_PROCESS') THEN
               NULL;
            ELSIF (name_ = 'TO_WAREHOUSE_ID') THEN
               NULL;
            ELSIF (name_ = 'TO_BAY_ID') THEN
               NULL;
            ELSIF (name_ = 'INVENTORY_EVENT_ID') THEN
               NULL;
            ELSE
               Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
            END IF;
         END LOOP;

         -- When we find the first disqualifying case, stop processing and return TRUE.
         IF ((local_contract_ = contract_) AND
             (local_part_no_  = part_no_ ) AND
             (NVL(local_to_location_no_  , string_null_) = NVL(to_location_no_  , string_null_)) AND
             (NVL(local_from_location_no_, string_null_) = NVL(from_location_no_, string_null_))) THEN
            -- matching parameter values
            RETURN TRUE;
         END IF;
      END LOOP;
   END IF;

   RETURN FALSE;

END Using_Putaway_Is_Posted___;


FUNCTION Using_Putaway_Is_Executing___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   to_location_no_   IN VARCHAR2,
   from_location_no_ IN VARCHAR2,
   my_job_id_        IN NUMBER ) RETURN BOOLEAN
IS
   count_                  NUMBER;
   job_id_tab_             Message_Sys.name_table;
   attrib_tab_             Message_Sys.line_table;
   local_contract_         inventory_part_in_stock_tab.contract%TYPE;
   local_part_no_          inventory_part_in_stock_tab.part_no%TYPE;
   local_to_location_no_   inventory_part_in_stock_tab.location_no%TYPE;
   local_from_location_no_ inventory_part_in_stock_tab.location_no%TYPE;
   msg_                    VARCHAR2 (32000);
   deferred_call_          CONSTANT VARCHAR2(200) := 'Inventory_Refill_Manager_API.Refill_Using_Putaway__';
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
BEGIN
   -- Find the parameters and job id's for the currently executing jobs with
   -- the procedure name that is defined in deferred_call_.
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   -- Store in internal tables.
   Message_Sys.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);

   WHILE (count_ > 0) LOOP
      IF (NVL(my_job_id_, -9999999999) != job_id_tab_(count_)) THEN
         -- Get the parameter values for the job under investigation.
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attrib_tab_(count_), ptr_, name_, value_)) LOOP
            IF (name_ = 'CONTRACT') THEN
               local_contract_ := value_;
            ELSIF (name_ = 'PART_NO') THEN
               local_part_no_ := value_;
            ELSIF (name_ = 'TO_LOCATION_NO') THEN
               local_to_location_no_ := value_;
            ELSIF (name_ = 'FROM_LOCATION_NO') THEN
               local_from_location_no_ := value_;
            ELSIF (name_ = 'CALLING_PROCESS') THEN
               NULL;
            ELSIF (name_ = 'TO_WAREHOUSE_ID') THEN
               NULL;
            ELSIF (name_ = 'TO_BAY_ID') THEN
               NULL;
            ELSIF (name_ = 'INVENTORY_EVENT_ID') THEN
               NULL;
            ELSE
               Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
            END IF;
         END LOOP;

         -- When we find the first disqualifying case, stop processing and return TRUE.
         IF ((local_contract_ = contract_) AND
             (local_part_no_  = part_no_ ) AND
             (NVL(local_to_location_no_  , string_null_) = NVL(to_location_no_  , string_null_)) AND
             (NVL(local_from_location_no_, string_null_) = NVL(from_location_no_, string_null_))) THEN
            -- matching parameter values
            RETURN TRUE;
         END IF;
      END IF;
      count_ := count_ - 1;
   END LOOP;

   RETURN FALSE;

END Using_Putaway_Is_Executing___;


PROCEDURE Refill_Using_Putaway___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   to_location_no_     IN VARCHAR2,
   from_location_no_   IN VARCHAR2,
   calling_process_    IN VARCHAR2,
   to_warehouse_id_    IN VARCHAR2 DEFAULT NULL,
   to_bay_id_          IN VARCHAR2 DEFAULT NULL )
IS
   attr_                          VARCHAR2(2000);
   batch_desc_                    VARCHAR2(500);
   exit_procedure_                EXCEPTION;
   putaway_zone_refill_option_db_ VARCHAR2(20);
   location_is_in_operative_zone_ BOOLEAN;
   part_has_operative_zone_       BOOLEAN;
   location_is_in_best_ranked_    BOOLEAN;
BEGIN

   putaway_zone_refill_option_db_ := Inventory_Part_API.Get_Putaway_Zone_Refill_Opt_Db(contract_, part_no_);

   IF (putaway_zone_refill_option_db_ = Putaway_Zone_Refill_Option_API.DB_NO_REFILL) THEN
      -- Refill Using Putaway is switched off on Site or Inventory Part level
      RAISE exit_procedure_;
   END IF;

   part_has_operative_zone_ := Invent_Part_Putaway_Zone_API.Part_Has_Operative_Zone(contract_, part_no_);

   IF NOT (part_has_operative_zone_) THEN
      RAISE exit_procedure_;
   END IF;

   IF (from_location_no_ IS NOT NULL) THEN
      -- In this situation we are pushing quantities from one known location to any location in a better ranked zone.
      location_is_in_operative_zone_ := Invent_Part_Putaway_Zone_API.Location_Is_In_Operative_Zone(contract_,
                                                                                                   part_no_,
                                                                                                   from_location_no_);
      IF (location_is_in_operative_zone_) THEN
         -- We need to check whether this location is in 
         -- the top ranked zone or if there is a better zone for the stock.
         location_is_in_best_ranked_ := Invent_Part_Putaway_Zone_API.Location_Is_In_Best_Ranked(contract_,
                                                                                                part_no_,
                                                                                                from_location_no_);
         IF (location_is_in_best_ranked_) THEN
            -- No need to move the stock since it is already in the best ranked zone for the part.
            RAISE exit_procedure_;
         END IF;
      ELSE
         -- The refill source location is not within a putaway zone for the part
         IF (putaway_zone_refill_option_db_ = Putaway_Zone_Refill_Option_API.DB_FROM_PUTAWAY_ZONES) THEN
            -- We should only refill from putaway zone locations and this location is not in a putaway zone.
            RAISE exit_procedure_;
         END IF;
      END IF;
   END IF;

   IF (to_location_no_ IS NOT NULL) THEN
      -- Refill this location only if it is in a putaway zone for the part.
      location_is_in_operative_zone_ := Invent_Part_Putaway_Zone_API.Location_Is_In_Operative_Zone(contract_,
                                                                                                   part_no_,
                                                                                                   to_location_no_);
      IF NOT (location_is_in_operative_zone_) THEN
         RAISE exit_procedure_;
      END IF;
      IF (calling_process_ = 'AUTOMATIC_REFILL') THEN
         IF (Warehouse_API.Get_Auto_Refill_Putaway_Zon_Db(contract_, 
                                                          Inventory_Location_API.Get_Warehouse(contract_, to_location_no_)) = Fnd_Boolean_API.DB_FALSE) THEN
            -- Do not automatically start a refill job if to_location is situated in a warehouse where automatic refill is disabled.
            RAISE exit_procedure_;
         END IF;
      END IF;   
   END IF;

   IF (Using_Putaway_Is_Posted___(contract_, part_no_, to_location_no_, from_location_no_)) THEN
      RAISE exit_procedure_;
   END IF;

   IF (Using_Putaway_Is_Executing___(contract_, part_no_, to_location_no_, from_location_no_, my_job_id_ => NULL)) THEN
      RAISE exit_procedure_;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT'          , contract_        , attr_);
   Client_SYS.Add_To_Attr('PART_NO'           , part_no_         , attr_);
   Client_SYS.Add_To_Attr('TO_LOCATION_NO'    , to_location_no_  , attr_);
   Client_SYS.Add_To_Attr('FROM_LOCATION_NO'  , from_location_no_, attr_);
   Client_SYS.Add_To_Attr('CALLING_PROCESS'   , calling_process_ , attr_);
   Client_SYS.Add_To_Attr('TO_WAREHOUSE_ID'   , to_warehouse_id_ , attr_);
   Client_SYS.Add_To_Attr('TO_BAY_ID'         , to_bay_id_       , attr_);
   
   -- We make sure we don't create new background job for each call to Refill_Using_Putaway___ since that could potentially be very troublesome
   -- in the context of 'Refill All Putaway Zones' (That procedure is already running in a background job).
   IF (calling_process_ = 'DEFERRED_REFILL') THEN
      Refill_Using_Putaway__(attr_);
   ELSE
      IF (from_location_no_ IS NULL) THEN
         -- Refilling one specific location from unknown source locations        
         batch_desc_  := Language_SYS.Translate_Constant(lu_name_, 'PUTAWAYREFILLS1: Refill Inventory Part :P1 at Location :P2 on Site :P3 using Putaway Zones', NULL, part_no_, to_location_no_, contract_);
      ELSE
         -- Refilling unknown locations from a known source location        
         batch_desc_  := Language_SYS.Translate_Constant(lu_name_, 'PUTAWAYREFILLS2: Refill Inventory Part :P1 at Putaways Zones on Site :P2 using stock on Location :P3', NULL, part_no_, contract_, from_location_no_);
      END IF;
      Transaction_SYS.Deferred_Call('Inventory_Refill_Manager_API.Refill_Using_Putaway__', attr_, batch_desc_);
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Refill_Using_Putaway___;


PROCEDURE Create_Purchase_Requisition___ (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   remote_whse_refill_qty_ IN NUMBER,
   warehouse_id_           IN VARCHAR2,
   assortment_id_          IN VARCHAR2 )
IS
   unit_meas_             VARCHAR2(10);
   order_processing_type_ VARCHAR2(3);
BEGIN  
   $IF Component_Purch_SYS.INSTALLED $THEN 
      unit_meas_             := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
      order_processing_type_ := Remote_Whse_Assortment_API.Get_Order_Processing_Type(assortment_id_);
   
      Purchase_Req_Util_API.Create_Requisition_And_Line(order_code_               => '1', 
                                                        contract_                 => contract_, 
                                                        requisitioner_code_       => Mpccom_Defaults_API.Get_Char_Value('RWH', 'REQUISITION_HEADER', 'REQUISITIONER_CODE'),
                                                        part_no_                  => part_no_,
                                                        unit_meas_                => unit_meas_,
                                                        original_qty_             => remote_whse_refill_qty_,
                                                        demand_code_              => Order_Supply_Type_API.Decode('IO'),
                                                        order_processing_type_    => order_processing_type_,
                                                        destination_warehouse_id_ => warehouse_id_);
   $ELSE
      NULL;
   $END 
END Create_Purchase_Requisition___;


PROCEDURE Refill_Putaway_Zone___ (
   warehouse_refill_source_tab_ IN OUT Warehouse_Refill_Source_Tab,
   contract_                    IN     VARCHAR2,
   part_no_                     IN     VARCHAR2,
   location_no_                 IN     VARCHAR2,
   warehouse_id_                IN     VARCHAR2,
   bay_id_                      IN     VARCHAR2 )
IS
   refill_source_db_       VARCHAR2(25);
   remote_warehouse_db_    VARCHAR2(15);
   assortment_id_          VARCHAR2(50);
   plannable_qty_          NUMBER := 0;
   refill_point_qty_       NUMBER := 0;
   refill_to_qty_          NUMBER := 0;
   remote_whse_refill_qty_ NUMBER := 0;
BEGIN   
   IF (warehouse_refill_source_tab_.COUNT > 0) THEN
      FOR i IN warehouse_refill_source_tab_.FIRST..warehouse_refill_source_tab_.LAST LOOP
         IF (warehouse_refill_source_tab_(i).warehouse_id = warehouse_id_) THEN
            IF (warehouse_refill_source_tab_(i).refill_source_db = Remote_Whse_Refill_Source_API.DB_PURCHASE) THEN
               -- Purchase has already been indicated once so a PR has already been created.
               warehouse_refill_source_tab_(i).refill_source_db := 'NO_REFILL';
            END IF;
            refill_source_db_ := warehouse_refill_source_tab_(i).refill_source_db;
            EXIT;
         END IF;
      END LOOP;
   END IF;

   IF (refill_source_db_ IS NULL) THEN
      -- First time this warehouse appears for this part number. No data in the collection.
      -- Assume that refill should be done from other inventory location. Might change below.
      refill_source_db_    := Remote_Whse_Refill_Source_API.DB_INVENTORY;
      remote_warehouse_db_ := Warehouse_API.Get_Remote_Warehouse_Db(contract_, warehouse_id_);

      IF (remote_warehouse_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         -- This is a remote warehouse so the part might be connected to an assortment for the warehouse.
         assortment_id_ := Remote_Whse_Assort_Part_API.Get_Prioritized_Assortment_Id(part_no_, contract_, warehouse_id_);

         IF (assortment_id_ IS NOT NULL) THEN
            refill_source_db_ := Remote_Whse_Assort_Part_API.Get_Refill_Source_Db(assortment_id_, part_no_);

            IF (refill_source_db_ = Remote_Whse_Refill_Source_API.DB_PURCHASE) THEN
               -- We need to lock the assortment on the warehouse to avoid parallell processes from
               -- looking at the same plannable_qty_ and risking to over-refill the warehouse.
               -- This is handled in InventoryPutawayManager.apy for refill_source = 'INVENTORY'.
               Remote_Whse_Assort_Connect_API.Lock_By_Keys_Wait(contract_, warehouse_id_, assortment_id_);

               plannable_qty_    := Remote_Whse_Assort_Part_API.Get_Plannable_Qty(part_no_, contract_, warehouse_id_);
               refill_point_qty_ := Remote_Whse_Assort_Part_API.Get_Refill_Point_Inv_Qty(assortment_id_, part_no_, contract_);
               refill_to_qty_    := Remote_Whse_Assort_Part_API.Get_Refill_To_Inv_Qty(assortment_id_, part_no_, contract_);

               IF ((plannable_qty_ < refill_point_qty_) OR
                   ((refill_point_qty_ = 0) AND (plannable_qty_ = 0))) THEN
                  remote_whse_refill_qty_ := refill_to_qty_ - plannable_qty_;
               ELSE
                  remote_whse_refill_qty_ := 0;
                  refill_source_db_       := 'NO_REFILL';
               END IF;
            END IF;
         END IF;
      END IF;
      warehouse_refill_source_tab_(warehouse_refill_source_tab_.COUNT + 1).warehouse_id     := warehouse_id_;
      warehouse_refill_source_tab_(warehouse_refill_source_tab_.COUNT + 1).refill_source_db := refill_source_db_;
   END IF;

   CASE refill_source_db_
      WHEN Remote_Whse_Refill_Source_API.DB_PURCHASE  THEN Create_Purchase_Requisition___(contract_,
                                                                                          part_no_,
                                                                                          remote_whse_refill_qty_,
                                                                                          warehouse_id_,
                                                                                          assortment_id_);
      WHEN Remote_Whse_Refill_Source_API.DB_INVENTORY THEN Refill_This_Location(contract_,
                                                                                part_no_,
                                                                                location_no_,
                                                                                'DEFERRED_REFILL',
                                                                                warehouse_id_,
                                                                                bay_id_);
      ELSE NULL;
   END CASE;
END Refill_Putaway_Zone___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


PROCEDURE Refill_Using_Putaway__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   calling_process_    VARCHAR2(2000);
   contract_           inventory_part_in_stock_tab.contract%TYPE;
   part_no_            inventory_part_in_stock_tab.part_no%TYPE;
   to_location_no_     inventory_part_in_stock_tab.location_no%TYPE;
   from_location_no_   inventory_part_in_stock_tab.location_no%TYPE;
   to_warehouse_id_    VARCHAR2(15);
   to_bay_id_          VARCHAR2(5);
   current_job_id_     NUMBER;
BEGIN

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      ELSIF (name_ = 'FROM_LOCATION_NO') THEN
         from_location_no_ := value_;
      ELSIF (name_ = 'CALLING_PROCESS') THEN
         calling_process_ := value_;
      ELSIF (name_ = 'TO_WAREHOUSE_ID') THEN
        to_warehouse_id_ := value_;
      ELSIF (name_ = 'TO_BAY_ID') THEN
         to_bay_id_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   
    -- Don't get job id when in the context of 'Refill All Putaway Zones'. 
   IF (calling_process_ != 'DEFERRED_REFILL') THEN
      current_job_id_ := Transaction_SYS.Get_Current_Job_Id;
   END IF;

   IF NOT (Using_Putaway_Is_Executing___(contract_,
                                         part_no_,
                                         to_location_no_,
                                         from_location_no_,
                                         current_job_id_)) THEN
      Inventory_Part_In_Stock_API.Refill_Using_Putaway(contract_, 
                                                       part_no_, 
                                                       to_location_no_, 
                                                       from_location_no_,
                                                       calling_process_,
                                                       to_warehouse_id_    => to_warehouse_id_,
                                                       to_bay_id_          => to_bay_id_);
   END IF;

END Refill_Using_Putaway__;


PROCEDURE Refill_All_Putaway_Zones__ (
   message_ IN VARCHAR2 )
IS
   count_              NUMBER;
   inventory_event_id_ NUMBER;
   name_arr_           Message_SYS.name_table;
   value_arr_          Message_SYS.line_table;
   contract_           VARCHAR2(5);
   warehouse_id_       VARCHAR2(15);
   bay_id_             VARCHAR2(15);
   part_no_            VARCHAR2(25);
   putaway_zone_tab_   Invent_Part_Putaway_Zone_API.Putaway_Zone_Tab;
   putaway_bin_tab_    Warehouse_Bay_Bin_API.Putaway_Bin_Tab;
   putaway_zone_found_ BOOLEAN := FALSE;
   warning_text_       VARCHAR2(2000);
   only_assort_conn_parts_ VARCHAR2(5) := 'FALSE';
   
   CURSOR get_parts IS
      SELECT ip.part_no
      FROM  inventory_part_tab ip,
            inventory_part_status_par_tab ipsp
      WHERE ip.part_status   = ipsp.part_status
      AND   ipsp.onhand_flag = Inventory_Part_Onhand_Flag_API.DB_ONHAND_ALLOWED
      AND   ip.contract      = contract_
      AND   ip.part_no       LIKE part_no_;
    
   CURSOR get_remote_warehouse_parts IS
         SELECT ip.part_no
         FROM  inventory_part_tab ip, inventory_part_status_par_tab ipsp, remote_whse_assort_part_tab rwap, remote_whse_assort_connect_tab rmac
         WHERE ip.part_status   = ipsp.part_status
         AND   ipsp.onhand_flag = Inventory_Part_Onhand_Flag_API.DB_ONHAND_ALLOWED
         AND   ip.contract      = rmac.contract
         AND   ip.part_no       = rwap.part_no
         AND   rwap.assortment_id = rmac.assortment_id
         AND   rmac.contract =  contract_
         AND   rmac.warehouse_id = warehouse_id_;   
   
   TYPE Parts_Tab IS TABLE OF VARCHAR2(25);
   parts_tab_                   Parts_Tab;
   warehouse_refill_source_tab_ Warehouse_Refill_Source_Tab;
BEGIN   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAREHOUSE_ID') THEN
         warehouse_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'BAY_ID') THEN
         bay_id_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         part_no_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'ONLY_ASSORT_CONN_PARTS') THEN
         only_assort_conn_parts_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in method Refill_All_Putaway_Zones__.');
      END IF;
   END LOOP;
   
   IF (only_assort_conn_parts_ = 'TRUE' AND Warehouse_API.Is_Remote(contract_, warehouse_id_) = 'TRUE' )THEN
      OPEN get_remote_warehouse_parts;
      FETCH get_remote_warehouse_parts BULK COLLECT INTO parts_tab_;
      CLOSE get_remote_warehouse_parts;
   ELSE   
      OPEN get_parts;
      FETCH get_parts BULK COLLECT INTO parts_tab_;
      CLOSE get_parts;
   END IF;
   
   IF(parts_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
      FOR i IN parts_tab_.FIRST..parts_tab_.LAST LOOP
         putaway_zone_tab_ := Invent_Part_Putaway_Zone_API.Get_Putaway_Zones(contract_, parts_tab_(i));
         IF (putaway_zone_tab_.COUNT > 0) THEN
            FOR j IN putaway_zone_tab_.FIRST..putaway_zone_tab_.LAST LOOP
               putaway_bin_tab_ := Warehouse_Bay_Bin_API.Get_Putaway_Bins(contract_, Invent_Part_Putaway_Zone_API.Get_Sql_Where_Expression(contract_, putaway_zone_tab_(j).storage_zone_id, putaway_zone_tab_(j).source_db));
               IF (putaway_bin_tab_.COUNT > 0) THEN
                  FOR k IN putaway_bin_tab_.FIRST..putaway_bin_tab_.LAST LOOP
                     IF ((putaway_bin_tab_(k).warehouse_id LIKE warehouse_id_) AND
                         (putaway_bin_tab_(k).bay_id       LIKE bay_id_)) THEN
                        putaway_zone_found_ := TRUE;
                        Refill_Putaway_Zone___(warehouse_refill_source_tab_ => warehouse_refill_source_tab_,
                                               contract_                    => contract_,
                                               part_no_                     => parts_tab_(i),
                                               location_no_                 => putaway_bin_tab_(k).location_no,
                                               warehouse_id_                => putaway_bin_tab_(k).warehouse_id,
                                               bay_id_                      => putaway_bin_tab_(k).bay_id);
                     END IF;
                  END LOOP; -- Putaway bins for operative putaway zone
               END IF;
            END LOOP; -- Operative putaway zones for part
         END IF;
         -- Empty the warehouse_refill_source_tab_ because new settings can be found for different part number
         warehouse_refill_source_tab_.DELETE;
         -- We are done with trying to refill a specific inventory part so we delete the records in RemoteWhseRefillEvent
         -- that indicates that there is an ongoing refill event for that part number on any remote warehouses. 
         Remote_Whse_Refill_Event_API.Remove_Part_Event(contract_, parts_tab_(i), inventory_event_id_);
         Putaway_To_Empty_Event_API.Remove_Putaway_Event(inventory_event_id_);
      END LOOP; -- Inventory parts for contract
      Inventory_Event_Manager_API.Finish_Session;
   END IF;

   IF (NOT putaway_zone_found_) THEN
      warning_text_ := Language_SYS.Translate_Constant(lu_name_, 'NOZONEFOUND: No putaway zones found for the entered job arguments');
      Transaction_SYS.Set_Status_Info(warning_text_, 'WARNING');
   END IF;
END Refill_All_Putaway_Zones__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Refill_This_Location (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   refill_to_location_no_ IN VARCHAR2,
   calling_process_       IN VARCHAR2 DEFAULT 'AUTOMATIC_REFILL',
   to_warehouse_id_       IN VARCHAR2 DEFAULT NULL,
   to_bay_id_             IN VARCHAR2 DEFAULT NULL )
IS
BEGIN

   IF NOT (Is_Kanban_Controlled(contract_, part_no_, refill_to_location_no_)) THEN
      Refill_Using_Putaway___(contract_           => contract_,
                              part_no_            => part_no_,
                              to_location_no_     => refill_to_location_no_,
                              from_location_no_   => NULL,
                              calling_process_    => calling_process_,
                              to_warehouse_id_    => to_warehouse_id_,
                              to_bay_id_          => to_bay_id_);
   END IF;

END Refill_This_Location;


PROCEDURE Refill_Other_Locations (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   refill_from_location_no_ IN VARCHAR2 )
IS
   location_type_db_           VARCHAR2(20);
   is_stock_location_          BOOLEAN;
BEGIN

   IF NOT (Is_Kanban_Controlled(contract_, part_no_, refill_from_location_no_)) THEN
      location_type_db_   := Inventory_Location_API.Get_Location_Type_Db(contract_,refill_from_location_no_);
      is_stock_location_  := Inventory_Location_API.Arrival_Or_Quality_Location(location_type_db_) = Fnd_Boolean_API.db_false;

      IF (is_stock_location_) THEN
         Refill_Using_Putaway___(contract_         => contract_,
                                 part_no_          => part_no_,
                                 to_location_no_   => NULL,
                                 from_location_no_ => refill_from_location_no_,
                                 calling_process_  => 'AUTOMATIC_REFILL');
      END IF;
   END IF;
END Refill_Other_Locations;


FUNCTION Is_Kanban_Controlled (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   kanban_controlled_    NUMBER;
   is_kanban_controlled_ BOOLEAN := FALSE;
BEGIN
   
   $IF Component_Kanban_SYS.INSTALLED $THEN
      kanban_controlled_ := Kanban_Manager_Int_API.Check_Kanban_Controlled( contract_, part_no_, location_no_);      
      IF (kanban_controlled_ = 1) THEN
         is_kanban_controlled_ := TRUE;
      END IF;
   $END

   RETURN (is_kanban_controlled_);

END Is_Kanban_Controlled;


PROCEDURE Refill_All_Putaway_Zones (
   message_ IN VARCHAR2 )
IS
   batch_desc_   VARCHAR2(500);
   batch_desc_1_ VARCHAR2(100);
   batch_desc_2_ VARCHAR2(100);
   batch_desc_3_ VARCHAR2(100);
   batch_desc_4_ VARCHAR2(100);
   count_        NUMBER;
   name_arr_     Message_SYS.name_table;
   value_arr_    Message_SYS.line_table;
   contract_     VARCHAR2(5);
   warehouse_id_ VARCHAR2(15);
   bay_id_       VARCHAR2(15);
   part_no_      VARCHAR2(25);
   only_assort_conn_parts_ VARCHAR2(5) := 'FALSE';
BEGIN  
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAREHOUSE_ID') THEN
         warehouse_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'BAY_ID') THEN
         bay_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         part_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ONLY_ASSORT_CONN_PARTS') THEN
         only_assort_conn_parts_ := value_arr_(n_);   
      END IF;
   END LOOP;
   
   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Refill_All_Putaway_Zones__(message_);
   ELSE   
      batch_desc_1_ := Language_SYS.Translate_Constant(lu_name_,'REFILLZONES1: Refill Putaway Zones on Site');
      batch_desc_2_ := Language_SYS.Translate_Constant(lu_name_,'REFILLZONES2: in Warehouse');
      batch_desc_3_ := Language_SYS.Translate_Constant(lu_name_,'REFILLZONES3: in Bay');
      batch_desc_4_ := Language_SYS.Translate_Constant(lu_name_,'REFILLZONES4: for Part');
      batch_desc_4_ := Language_SYS.Translate_Constant(lu_name_,'REFILLZONES5: with Parts in Assortments Connected to the Remote Warehouse');
      
      batch_desc_  := batch_desc_1_ || ' ' || contract_ || ' ' || CASE WHEN warehouse_id_ IS NULL THEN '' ELSE batch_desc_2_ || ' ' || warehouse_id_ || ' ' END ||
                                                                  CASE WHEN bay_id_       IS NULL THEN '' ELSE batch_desc_3_ || ' ' || bay_id_       || ' ' END ||
                                                                  CASE WHEN part_no_      IS NULL THEN '' ELSE batch_desc_4_ || ' ' || part_no_      || ' '  END||
                                                                  CASE WHEN only_assort_conn_parts_ = 'FALSE'  THEN '' ELSE batch_desc_4_  END ;

      Transaction_SYS.Deferred_Call('Inventory_Refill_Manager_API.Refill_All_Putaway_Zones__', message_, batch_desc_);
   END IF;
   
END Refill_All_Putaway_Zones;


-- Validate_Refill_Putaway_Zones
--   Validates the parameters when running the Schedule for Refill All Putaway Zones with use only assortment connected parts check box checked.
PROCEDURE Validate_Refill_Putaway_Zones (
   message_ IN VARCHAR2 )
IS  
   only_assort_conn_parts_     VARCHAR2(5);
   part_no_                    VARCHAR2(25);
   warehouse_id_               VARCHAR2(15);
BEGIN
   Message_SYS.Get_Attribute(message_, 'PART_NO', part_no_);
   Message_SYS.Get_Attribute(message_, 'ONLY_ASSORT_CONN_PARTS', only_assort_conn_parts_);
   Message_SYS.Get_Attribute(message_, 'WAREHOUSE_ID', warehouse_id_); 
   
   IF (part_no_ IS NOT NULL AND only_assort_conn_parts_ = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'PARTANDASSORT: Use Only Assortment Connected Parts checkbox cannot be checked when Part No has a value.');
   END IF; 
   IF (warehouse_id_ IS NULL AND only_assort_conn_parts_ = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'NOWAREHOUSE: Warehouse must have a value when Use Only Assortment Connected Parts checkbox is checked.');
   END IF; 
END Validate_Refill_Putaway_Zones;



