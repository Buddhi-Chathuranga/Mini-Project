-----------------------------------------------------------------------------
--
--  Logical unit: TransportTaskHandlUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210720  BWITLK  Bug 159950 (SCZ-15210), Modified Create_Data_Capture_Lov(), Added to_location_no_ filter parameter for dynamic query.
--  200506  JaThlk  SC2020R1-7030, Removed declarations to avoid code generation errors.
--  200311  DaZase  SCXTEND-3803, Small change in both Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191210  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191210          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191210          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190521  ChFolk  SCUXXW4-20397, Modified method New__ to handle no new line inserted and added Is_Odp_Session for the methods that are used only by Aurena client.
--  190510  DiKuLk  Bug 148108(SCZ-4560), Modified Execute_Handling_Unit() to identify transport tasks with hadling units for different destinations
--  190510          and disconnect the parent handling unit upon the execution of the transport task.
--  180816  ChFolk  SCUXXW4-6502, Added new methods HU_Revoke_Two_Step_Tr_Task_Str and HU_Apply_Drop_Off_Location_Str to be used by Aurena client and modified existing methods to encapsulate.
--  180814  ChFolk  SCUXXW4-6502, Modified New__ to return objid_ which requires UXX client to work.
--  180809  ChFolk  SCUXXW4-6502, Modified existing methods Line_With_Status_Exist, Line_With_Fwd_To_Loc_Exist and Line_With_No_Fwd_To_Loc_Exist to use common codes from new methods.
--  180726  ChFolk  SCUXXW4-6502, Duplicated methods Line_With_Status_Exist, Line_With_Fwd_To_Loc_Exist and Line_With_No_Fwd_To_Loc_Exist with passing line parameters
--  180726          which are used by the Aurena client where it needs to have line level check for handling enable disable condition in Aggregated tab.
--  180301  LEPESE  STRSC-17288, Added method Check_Storage_Requirements and called it from New___. 
--  180212  DaZase  STRSC-16924, Added Last_Hndl_Unit_Structure_On_TT().
--  180112  BudKlk  Bug 139555, Modified the method Generate_Aggr_Handl_Unit_View() to change the cursors to improve the performance.
--  171206  Mwerse  STRCC-11918, Added new method Split_By_Hu_Capacity___.
--  170929  Chfose  STRSC-8922, Added new method Execute_Handling_Unit to gather shared logic for executing in a handling unit context.
--  170614  Chfose  STRSC-8192, Reworked Modify__, Remove__, Execute_Transport_Task, Pick_HU_Transport_Task, New_HU_Transport_Task, HU_Apply_Drop_Off_Location,
--  170614          HU_Revoke_Two_Step_Trp_Task to include lines aggregated by location (without a HU id) and work in a unified manner. Added methods 
--  170614          Get_Stock_Records___ & Get_Transport_Task_Lines___.
--  170531  KHVESE  LIM-10758, Modified methods New___ and Modify__ to call to methods Transport_Task_Line_API.New_Or_Add_To_Existing_ and Transport_Task_Line_API.Modify_Stock_Rec_Destination with check_storage_requirements_ => TRUE.
--  170530  KHVESE  STRSC-8342, Modified method New___ to verify handling unit location and contract.
--  170508  DaZase  STRSC-7996, Added transport_task_status_db as first sorting criteria so created lines are handled before picked ones in both Create_Data_Capture_Lov methods.
--  170405  KHVESE  LIM-11362, Modified method Execute_Transport_Task to call Get_Outermost_Units_Only instead of Get_Node_Level_Sorted_Units.
--  170405          Also updated local_inventory_event_id_ to get Next_Inventory_Event_Id when inventory_event_id is null.
--  170330  LEPESE  LIM-9464, Added calls to Handling_Unit_API.Convert_Manual_Weight_And_Volu, Handling_Unit_API.Get_Contract and 
--  170330          Handling_Unit_API.Get_Transport_Destination_Site in method Execute_Transport_Task.
--  170323  DaZase  LIM-2928, Added Lines_Left_To_Execute() and overloaded methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist. 
--  170309  DaZase  LIM-9901, Added methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist. Added default parameters
--  170309          inventory_event_id_ and finish_inventory_event_ to Pick_HU_Transport_Task/Unpick_HU_Transport_Task/Execute_Transport_Task so these can 
--  170309          be used from wadaco process also since there we need to control inventory_event_id_ and when its finished. 
--  170301  Erlise  LIM-7315, Added method Get_From_Location_No_Tab. 
--  170301          Modified methods HU_Apply_Drop_Off_Location and HU_Revoke_Two_Step_Trp_Task, added handling of aggregated transport task single lines.
--  170214  Erlise  LIM-7315, Added method Aggr_Line_With_Status_Exist.
--  170124  Erlise  LIM-7315, Changed method Generate_Aggr_Handl_Unit_View to include transport task lines with handling unit id = 0 in the snapshot.
--  170113  MaEelk  LIM-10139, Passed pick_list_no and shipment_id as NULL parameter to Transport_Task_Line_API.New_Or_Add_To_Existing_.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160512  Erlise  LIM-7368, Modified Remove__ to handle multiple selected rows that belong to the same handling unit structure.
--  160512  LEPESE  LIM-7363, Added parameter putaway_event_id_ to method New___. Passing putaway_event_id_ when calling methods that makes inserts, updates or deletes
--  160512          in Transport_Task_Line_API. this applies to methods New___, Modify__, Remove__, Unpick_HU_Transport_Task, New_HU_Transport_Task, 
--  160512          HU_Apply_Drop_Off_Location and HU_Revoke_Two_Step_Trp_Task.
--  160511  LEPESE  LIM-7363, added handling of putaway_event_id_ in Pick_HU_Transport_Task.
--  160414  KhVese  LIM-7040, Modified method New__ to delete serials_to_add_ records when part is not serial track.
--  160329  Erlise  LIM-6039, Added method Execute_Transport_Task.
--  160212  DaZase  LIM-3655, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


TYPE Trans_Task_Line_Status_Rec IS RECORD (line_no                  transport_task_line_tab.line_no%TYPE,
                                           transport_task_status    transport_task_line_tab.transport_task_status%TYPE);
TYPE Trans_Task_Line_Status_Tab IS TABLE OF Trans_Task_Line_Status_Rec INDEX BY PLS_INTEGER;

TYPE Aggr_Transport_Task_Line_Rec IS RECORD (transport_task_id   transport_task_line_tab.transport_task_id%TYPE,
                                             handling_unit_id    transport_task_line_tab.handling_unit_id%TYPE,
                                             from_contract       transport_task_line_tab.from_contract%TYPE,
                                             from_location_no    transport_task_line_tab.from_location_no%TYPE);
TYPE Aggr_Transport_Task_Line_Tab IS TABLE OF Aggr_Transport_Task_Line_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Object_By_Id___ (
   transport_task_id_    OUT NUMBER,
   handling_unit_id_     OUT NUMBER,
   from_contract_        OUT VARCHAR2,
   from_location_no_     OUT VARCHAR2,
   objid_                IN  VARCHAR2 )
IS
BEGIN
  SELECT transport_task_id, handling_unit_id, from_contract, from_location_no
      INTO  transport_task_id_, handling_unit_id_, from_contract_, from_location_no_
      FROM  transport_task_handling_unit
      WHERE objid = objid_;
END Get_Object_By_Id___;

PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   default_contract_ VARCHAR2(5);
BEGIN
   default_contract_ := User_Default_API.Get_Contract;
   Client_SYS.Add_To_Attr('FROM_CONTRACT', default_contract_, attr_);
   Client_SYS.Add_To_Attr('TO_CONTRACT', default_contract_, attr_);
   Client_SYS.Add_To_Attr('DESTINATION', Inventory_Part_Destination_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('ALLOW_DEVIATING_AVAIL_CTRL_DB', Fnd_Boolean_API.DB_TRUE, attr_); 
END Prepare_Insert___;


PROCEDURE New___ (
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(32000);
   msg_                    VARCHAR2(32000);
   stock_keys_tab_         Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   transport_task_id_      transport_task_handling_unit.transport_task_id%TYPE;
   handling_unit_id_       transport_task_handling_unit.handling_unit_id%TYPE;
   to_contract_            transport_task_handling_unit.to_contract%TYPE;
   to_location_no_         transport_task_handling_unit.to_location_no%TYPE;
   from_contract_          transport_task_handling_unit.from_contract%TYPE;
   from_location_no_       transport_task_handling_unit.from_location_no%TYPE;
   forward_to_location_no_ transport_task_handling_unit.forward_to_location_no%TYPE;
   destination_db_         transport_task_handling_unit.destination_db%TYPE;
   serials_to_add_         Part_Serial_Catalog_API.Serial_No_Tab;
   serial_dummy_tab_       Part_Serial_Catalog_API.Serial_No_Tab;
   quantity_to_add_        NUMBER;
   catch_quantity_to_add_  NUMBER;
   total_quantity_         NUMBER;
   total_catch_quantity_   NUMBER;
   sum_quantity_           NUMBER;
   sum_catch_quantity_     NUMBER;
   quantity_added_         NUMBER;
   deviating_destination   EXCEPTION;
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   -- Unpacking attribute string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('TRANSPORT_TASK_ID') THEN
         transport_task_id_ := value_;
      WHEN ('HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      WHEN ('DESTINATION') THEN
         destination_db_ := Inventory_Part_Destination_API.Encode(value_);
      WHEN ('DESTINATION_DB') THEN
         destination_db_ := value_;
      WHEN ('TO_CONTRACT') THEN
         to_contract_ := value_;
      WHEN ('TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      WHEN ('FORWARD_TO_LOCATION_NO') THEN
         forward_to_location_no_ := value_;
      WHEN ('FROM_CONTRACT') THEN
         from_contract_ := value_;
      WHEN ('FROM_LOCATION_NO') THEN
         from_location_no_ := value_;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;

   -- Fetching stock record collection
   stock_keys_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);

   -- 
   IF (stock_keys_tab_.COUNT > 0) THEN
      IF stock_keys_tab_(1).contract != from_contract_ OR stock_keys_tab_(1).location_no != from_location_no_  THEN 
         Error_SYS.Record_General(lu_name_,'MISTMACHLOCATION: Handling unit :P1 does not exist on site :P2 and location number :P3.', handling_unit_id_, from_contract_, from_location_no_);
      END IF;
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         IF (Transport_Task_Line_API.Deviating_Destination_Exist(transport_task_id_      => transport_task_id_,
                                                                 from_contract_          => stock_keys_tab_(i).contract,
                                                                 part_no_                => stock_keys_tab_(i).part_no,
                                                                 configuration_id_       => stock_keys_tab_(i).configuration_id,
                                                                 from_location_no_       => stock_keys_tab_(i).location_no,
                                                                 lot_batch_no_           => stock_keys_tab_(i).lot_batch_no,
                                                                 serial_no_              => stock_keys_tab_(i).serial_no,
                                                                 eng_chg_level_          => stock_keys_tab_(i).eng_chg_level,
                                                                 waiv_dev_rej_no_        => stock_keys_tab_(i).waiv_dev_rej_no,
                                                                 activity_seq_           => stock_keys_tab_(i).activity_seq,
                                                                 handling_unit_id_       => stock_keys_tab_(i).handling_unit_id,
                                                                 to_contract_            => to_contract_,
                                                                 to_location_no_         => to_location_no_,
                                                                 forward_to_location_no_ => forward_to_location_no_,
                                                                 destination_db_         => destination_db_)) THEN
            RAISE deviating_destination;
         END IF;

         Transport_Task_Line_API.Get_Sum_Quantities(sum_quantity_       => sum_quantity_,
                                                    sum_catch_quantity_ => sum_catch_quantity_,
                                                    transport_task_id_  => transport_task_id_,
                                                    from_contract_      => stock_keys_tab_(i).contract,
                                                    part_no_            => stock_keys_tab_(i).part_no,
                                                    configuration_id_   => stock_keys_tab_(i).configuration_id,
                                                    from_location_no_   => stock_keys_tab_(i).location_no,
                                                    lot_batch_no_       => stock_keys_tab_(i).lot_batch_no,
                                                    serial_no_          => stock_keys_tab_(i).serial_no,
                                                    eng_chg_level_      => stock_keys_tab_(i).eng_chg_level,
                                                    waiv_dev_rej_no_    => stock_keys_tab_(i).waiv_dev_rej_no,
                                                    activity_seq_       => stock_keys_tab_(i).activity_seq,
                                                    handling_unit_id_   => stock_keys_tab_(i).handling_unit_id);
         -- Reduce stock records qty onhand with the already added quantities on the transport task
         total_quantity_       :=  stock_keys_tab_(i).quantity       - sum_quantity_;
         total_catch_quantity_ :=  stock_keys_tab_(i).catch_quantity - sum_catch_quantity_;
         -- Only Add record if the stock record have quantity to add that is larger then zero
         IF (total_quantity_ > 0) THEN
            IF (stock_keys_tab_(i).serial_no = '*') THEN
               serials_to_add_.DELETE;
               quantity_to_add_       := total_quantity_;
               catch_quantity_to_add_ := total_catch_quantity_;
            ELSE
               serials_to_add_(1).serial_no := stock_keys_tab_(i).serial_no;
               quantity_to_add_             := NULL;
               catch_quantity_to_add_       := NULL;
            END IF;
            
            Transport_Task_Line_API.New_Or_Add_To_Existing_(quantity_added_             => quantity_added_,
                                                            serials_added_              => serial_dummy_tab_,
                                                            transport_task_id_          => transport_task_id_,
                                                            part_no_                    => stock_keys_tab_(i).part_no,
                                                            configuration_id_           => stock_keys_tab_(i).configuration_id,
                                                            from_contract_              => stock_keys_tab_(i).contract,
                                                            from_location_no_           => stock_keys_tab_(i).location_no,
                                                            to_contract_                => to_contract_,
                                                            to_location_no_             => to_location_no_,
                                                            forward_to_location_no_     => forward_to_location_no_,
                                                            destination_db_             => destination_db_,
                                                            order_type_db_              => NULL,
                                                            order_ref1_                 => NULL,
                                                            order_ref2_                 => NULL,
                                                            order_ref3_                 => NULL,
                                                            order_ref4_                 => NULL,
                                                            pick_list_no_               => NULL,
                                                            shipment_id_                => NULL,
                                                            lot_batch_no_               => stock_keys_tab_(i).lot_batch_no,
                                                            serial_no_tab_              => serials_to_add_,
                                                            eng_chg_level_              => stock_keys_tab_(i).eng_chg_level,
                                                            waiv_dev_rej_no_            => stock_keys_tab_(i).waiv_dev_rej_no,
                                                            activity_seq_               => stock_keys_tab_(i).activity_seq,
                                                            handling_unit_id_           => stock_keys_tab_(i).handling_unit_id,
                                                            quantity_to_add_            => quantity_to_add_,
                                                            catch_quantity_to_add_      => catch_quantity_to_add_,
                                                            requested_date_finished_    => NULL, 
                                                            allow_deviating_avail_ctrl_ => Fnd_Boolean_API.DB_TRUE,
                                                            check_storage_requirements_ => FALSE);
         END IF;

      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
      handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
      Check_Storage_Requirements(handling_unit_id_tab_);
   ELSE -- no stock records found
      IF (Fnd_Session_API.Is_Odp_Session)THEN
         Client_SYS.Add_To_Attr('LINE_INSERTED', 'FALSE', attr_);        
      ELSE   
         Client_SYS.Add_Info(lu_name_, 'NOLINEINSERTED: No line was inserted due to empty handling unit or no available quantity.');
      END IF;
   END IF;
EXCEPTION
   WHEN deviating_destination THEN
      Error_SYS.Record_General(lu_name_,'DEVDEST: Parts of this quantity have been planned to be moved to another destination.', NULL, NULL);
END New___;
   
   
FUNCTION Get_Stock_Records___ (
   transport_task_id_    IN NUMBER,
   handling_unit_id_     IN NUMBER,
   from_contract_        IN VARCHAR2,
   from_location_no_     IN VARCHAR2 ) RETURN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab
IS
 stock_keys_tab_     Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;

   CURSOR get_stock_by_location IS
        SELECT contract, part_no, configuration_id, location_no, lot_batch_no,
               serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id,
               NULL, NULL, NULL, NULL, NULL
          FROM INV_PART_STOCK_SNAPSHOT
         WHERE source_ref_type_db = 'TRANSPORT_TASK'
           AND source_ref1        = transport_task_id_
           AND contract           = from_contract_
           AND location_no        = from_location_no_;
BEGIN
   -- If a HU id is specified we fetch the stock records from the HU structure, otherwise this is
   -- fetched by looking at what could not be aggregated in the snapshot for the location.
   IF (NVL(handling_unit_id_, 0) != 0) THEN
      stock_keys_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
   ELSE
      OPEN get_stock_by_location;
      FETCH get_stock_by_location BULK COLLECT INTO stock_keys_tab_;
      CLOSE get_stock_by_location;
   END IF;

   RETURN stock_keys_tab_;
END Get_Stock_Records___;


FUNCTION Get_Transport_Task_Lines___ (
   transport_task_id_    IN NUMBER,
   handling_unit_id_     IN NUMBER,
   from_contract_        IN VARCHAR2,
   from_location_no_     IN VARCHAR2 ) RETURN Trans_Task_Line_Status_Tab
IS
   -- Get all the transport task lines that are in the HU structure.
   CURSOR get_trans_task_line_hu IS
     SELECT line_no, transport_task_status
       FROM transport_task_line_tab ttlt
      WHERE transport_task_id = transport_task_id_
        AND ttlt.handling_unit_id IN (SELECT hu.handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_);

   -- Get all the transport task lines that exists for the specified location excluding full HUs.
   CURSOR get_trans_task_line_loc IS
     SELECT line_no, transport_task_status
       FROM transport_task_line_tab ttlt
      WHERE transport_task_id     = transport_task_id_
        AND ttlt.from_contract    = from_contract_
        AND ttlt.from_location_no = from_location_no_
        AND Transport_Task_Line_API.Get_Outermost_Handling_Unit_Id(transport_task_id, line_no) IS NULL;

   trans_task_line_tab_  Trans_Task_Line_Status_Tab;
BEGIN
   IF (NVL(handling_unit_id_, 0) != 0) THEN
      OPEN get_trans_task_line_hu;
      FETCH get_trans_task_line_hu BULK COLLECT INTO trans_task_line_tab_;
      CLOSE get_trans_task_line_hu;
   ELSE
      OPEN get_trans_task_line_loc;
      FETCH get_trans_task_line_loc BULK COLLECT INTO trans_task_line_tab_;
      CLOSE get_trans_task_line_loc;
   END IF;

   RETURN trans_task_line_tab_;
END Get_Transport_Task_Lines___;


FUNCTION Get_Aggr_Trans_Task_Lines___ (
   message_  IN CLOB ) RETURN Aggr_Transport_Task_Line_Tab
IS
   count_                            NUMBER;
   name_arr_                         Message_SYS.name_table;
   value_arr_                        Message_SYS.line_table;
   index_                            NUMBER := 0;
   temp_aggr_trans_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   aggr_trans_task_line_tab_         Aggr_Transport_Task_Line_Tab;
   handling_unit_id_tab_             Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1 .. count_ LOOP
      IF (name_arr_(n_) = 'TRANSPORT_TASK_ID') THEN
         index_ := index_ + 1;
         temp_aggr_trans_task_line_tab_(index_).transport_task_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         temp_aggr_trans_task_line_tab_(index_).handling_unit_id := value_arr_(n_);

         IF (NVL(value_arr_(n_), 0) != 0) THEN
             handling_unit_id_tab_(handling_unit_id_tab_.COUNT + 1).handling_unit_id := value_arr_(n_);
         END IF;
      ELSIF (name_arr_(n_) = 'FROM_CONTRACT') THEN
         temp_aggr_trans_task_line_tab_(index_).from_contract := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'FROM_LOCATION_NO') THEN
         temp_aggr_trans_task_line_tab_(index_).from_location_no := value_arr_(n_);
      END IF;
   END LOOP;

   -- When the message contains both parent and child Handling Units within the same structure we want
   -- to filter out any lower-level Handling Units and only perform the action e.g. Execute upon
   -- the highest / outermost Handling Unit.
   handling_unit_id_tab_ := Handling_Unit_API.Get_Outermost_Units_Only(handling_unit_id_tab_);
   index_ := 1;

   IF (temp_aggr_trans_task_line_tab_.COUNT > 0) THEN
      FOR i IN temp_aggr_trans_task_line_tab_.FIRST .. temp_aggr_trans_task_line_tab_.LAST LOOP
         -- If the Aggregated Transport Task Line is a Handling Unit and it is one of the outermost Handling Units
         -- or if the line is a location we want to save the record in the aggr_trans_task_line_tab_.
         IF (NVL(temp_aggr_trans_task_line_tab_(i).handling_unit_id, 0) != 0) THEN
            IF (handling_unit_id_tab_.COUNT > 0) THEN
               FOR j IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
                  IF (temp_aggr_trans_task_line_tab_(i).handling_unit_id = handling_unit_id_tab_(j).handling_unit_id) THEN
                     aggr_trans_task_line_tab_(index_) := temp_aggr_trans_task_line_tab_(i);
                     index_ := index_ + 1;
                  END IF;
               END LOOP;
            END IF;
         ELSE
            aggr_trans_task_line_tab_(index_) := temp_aggr_trans_task_line_tab_(i);
            index_ := index_ + 1;
         END IF;
      END LOOP;
   END IF;

   RETURN aggr_trans_task_line_tab_;
END Get_Aggr_Trans_Task_Lines___;
   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   transport_task_id_ NUMBER;
   handling_unit_id_  NUMBER;
   from_contract_     VARCHAR2(5);
   from_location_no_  VARCHAR2(35);
   line_inserted_     VARCHAR2(5) := 'TRUE';
BEGIN
   IF (action_ = 'PREPARE') THEN
      Prepare_Insert___(attr_);
   ELSIF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      transport_task_id_ := Client_SYS.Get_Item_Value('TRANSPORT_TASK_ID', attr_);
      handling_unit_id_ := Client_SYS.Get_Item_Value('HANDLING_UNIT_ID', attr_);
      from_contract_ := Client_SYS.Get_Item_Value('FROM_CONTRACT', attr_);
      from_location_no_ := Client_SYS.Get_Item_Value('FROM_LOCATION_NO', attr_);
      
      New___(attr_);
      IF (Fnd_Session_API.Is_Odp_Session)THEN
         -- The following code is written to handle UXX client which requires objid_ to be returned.
         line_inserted_ := Client_SYS.Get_Item_Value('LINE_INSERTED', attr_);
         IF (line_inserted_ = 'FALSE') THEN
            Error_SYS.Record_General(lu_name_, 'NOLINEINSERTED: No line was inserted due to empty handling unit or no available quantity.');
         END IF;   
         Handl_Unit_Stock_Snapshot_API.Get_Id_Version_By_Keys(objid_,
                                                              objversion_,
                                                              transport_task_id_,
                                                              '*',
                                                              '*',
                                                              '*',
                                                              '*',
                                                              Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK,
                                                              handling_unit_id_,
                                                              from_contract_,
                                                              from_location_no_);
      END IF;                                                              
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New__;


PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      Modify__(objid_ , attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      Remove__(objid_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


PROCEDURE Modify__ (
   objid_         IN     VARCHAR2,
   attr_          IN OUT NOCOPY VARCHAR2,
   window_source_ IN     VARCHAR2 DEFAULT NULL )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(32000);
   msg_                    VARCHAR2(32000);
   stock_keys_tab_         Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   transport_task_id_      transport_task_handling_unit.transport_task_id%TYPE;
   handling_unit_id_       transport_task_handling_unit.handling_unit_id%TYPE;
   from_contract_          transport_task_handling_unit.from_contract%TYPE;
   from_location_no_       transport_task_handling_unit.from_location_no%TYPE;
   to_contract_            transport_task_handling_unit.to_contract%TYPE;
   to_location_no_         transport_task_handling_unit.to_location_no%TYPE;
   forward_to_location_no_ transport_task_handling_unit.forward_to_location_no%TYPE;
   destination_db_         transport_task_handling_unit.destination_db%TYPE;
BEGIN
   -- Fetching keys from objid
   Get_Object_By_Id___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_, objid_);

   -- Unpacking attribute string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('DESTINATION') THEN
         destination_db_ := Inventory_Part_Destination_API.Encode(value_);
      WHEN ('DESTINATION_DB') THEN
         destination_db_ := value_;
      WHEN ('TO_CONTRACT') THEN
         to_contract_ := value_;
      WHEN ('TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      WHEN ('FORWARD_TO_LOCATION_NO') THEN
         forward_to_location_no_ := value_;
         -- using this solution for NULL values instead of Indicator_Rec since we are sending this between 2 objects
         IF (forward_to_location_no_ IS NULL) THEN 
            forward_to_location_no_ := Database_SYS.string_null_; 
         END IF;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;

   stock_keys_tab_ := Get_Stock_Records___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_);

   -- Modifying any affected transport task lines
   IF (stock_keys_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         Transport_Task_Line_API.Modify_Stock_Rec_Destination(transport_task_id_          => transport_task_id_,
                                                              from_contract_              => stock_keys_tab_(i).contract,
                                                              part_no_                    => stock_keys_tab_(i).part_no,
                                                              configuration_id_           => stock_keys_tab_(i).configuration_id,
                                                              from_location_no_           => stock_keys_tab_(i).location_no,
                                                              lot_batch_no_               => stock_keys_tab_(i).lot_batch_no,
                                                              serial_no_                  => stock_keys_tab_(i).serial_no,
                                                              eng_chg_level_              => stock_keys_tab_(i).eng_chg_level,
                                                              waiv_dev_rej_no_            => stock_keys_tab_(i).waiv_dev_rej_no,
                                                              activity_seq_               => stock_keys_tab_(i).activity_seq,
                                                              handling_unit_id_           => stock_keys_tab_(i).handling_unit_id,
                                                              to_contract_                => to_contract_,
                                                              to_location_no_             => to_location_no_,
                                                              forward_to_location_no_     => forward_to_location_no_,
                                                              destination_db_             => destination_db_,
                                                              check_storage_requirements_ => TRUE);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Modify__;


FUNCTION Trp_Task_Hu_Line_Exist___ (
   objid_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_  NUMBER;
   return_ BOOLEAN;
   
   CURSOR check_objid_exist IS
      SELECT 1
      FROM TRANSPORT_TASK_HANDLING_UNIT
      WHERE objid = objid_;
BEGIN
   OPEN check_objid_exist;
   FETCH check_objid_exist INTO dummy_;
   return_ := check_objid_exist%FOUND;
   CLOSE check_objid_exist;
   RETURN return_;
END Trp_Task_Hu_Line_Exist___;


PROCEDURE Remove__ (
   objid_         IN  VARCHAR2,
   window_source_ IN  VARCHAR2 DEFAULT NULL )
IS
   stock_keys_tab_     Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   transport_task_id_  transport_task_handling_unit.transport_task_id%TYPE;
   handling_unit_id_   transport_task_handling_unit.handling_unit_id%TYPE;
   from_contract_      transport_task_handling_unit.from_contract%TYPE;
   from_location_no_   transport_task_handling_unit.from_location_no%TYPE;
   remove_empty_task_  BOOLEAN := FALSE;  
BEGIN
   -- Skip a handling unit that is included in an already deleted structure.
   -- Since a new snapshot is triggered for each call to remove we need to check if the objid still exists in the session before proceeding.
   -- In the client there can be multiple lines selected for removal that belongs to the same handling unit structure.
   IF (Trp_Task_Hu_Line_Exist___(objid_)) THEN
      -- Transport Task will be removed if no transport task lines exist after this remove if its from the overview window/available handling units tab 
      -- but not from the handling unit tab
      IF (window_source_ = 'OVERVIEW') THEN
         remove_empty_task_ := TRUE;
      END IF;

      Get_Object_By_Id___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_, objid_);
      stock_keys_tab_ := Get_Stock_Records___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_);
      IF (stock_keys_tab_.COUNT > 0) THEN
         Inventory_Event_Manager_API.Start_Session;

         FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
            Transport_Task_Line_API.Remove(transport_task_id_  => transport_task_id_,
                                           from_contract_      => stock_keys_tab_(i).contract,
                                           part_no_            => stock_keys_tab_(i).part_no,
                                           configuration_id_   => stock_keys_tab_(i).configuration_id,
                                           from_location_no_   => stock_keys_tab_(i).location_no,
                                           lot_batch_no_       => stock_keys_tab_(i).lot_batch_no,
                                           serial_no_          => stock_keys_tab_(i).serial_no,
                                           eng_chg_level_      => stock_keys_tab_(i).eng_chg_level,
                                           waiv_dev_rej_no_    => stock_keys_tab_(i).waiv_dev_rej_no,
                                           activity_seq_       => stock_keys_tab_(i).activity_seq,
                                           handling_unit_id_   => stock_keys_tab_(i).handling_unit_id,
                                           remove_empty_task_  => remove_empty_task_);
         END LOOP;

         Inventory_Event_Manager_API.Finish_Session;
      END IF;
   END IF;
END Remove__;

PROCEDURE Split_By_Hu_Capacity___(
   transport_task_id_   IN NUMBER)
IS
   CURSOR get_aggr_line_count IS 
      SELECT count(*)
      FROM Transport_Task_Handling_Unit
      WHERE transport_task_id = transport_task_id_
      AND outermost_db = 'TRUE';
      
   CURSOR get_hu_type_count IS 
      SELECT count(*) hu_count, 
             handling_unit_type_id
      FROM Transport_Task_Handling_Unit
      WHERE transport_task_id = transport_task_id_
      AND handling_unit_id != 0
      AND outermost_db = 'TRUE'
      GROUP BY handling_unit_type_id;
      
   CURSOR get_handling_units_to_move (handling_unit_type_id_ VARCHAR2) IS
      SELECT handling_unit_id
      FROM Transport_Task_Handling_unit
      WHERE handling_unit_type_id = handling_unit_type_id_
      AND transport_task_id = transport_task_id_
      AND handling_unit_id != 0
      AND outermost_db = 'TRUE';
      
   new_transport_task_id_     NUMBER;
   aggr_line_count_           NUMBER;
   message_                   CLOB;
   transport_task_capacity_    NUMBER;
   TYPE get_handling_units_to_move_tab IS TABLE OF get_handling_units_to_move%ROWTYPE;
   handling_units_to_move_    get_handling_units_to_move_tab;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   OPEN get_aggr_line_count;
   FETCH get_aggr_line_count INTO aggr_line_count_;
   CLOSE get_aggr_line_count;
   
   FOR rec_ IN get_hu_type_count LOOP
      transport_task_capacity_ := Handling_Unit_Type_Api.Get_Transport_Task_Capacity(rec_.handling_unit_type_id);
      IF (transport_task_capacity_ IS NOT NULL AND rec_.hu_count >= transport_task_capacity_) THEN
         OPEN get_handling_units_to_move(rec_.handling_unit_type_id);
         FETCH get_handling_units_to_move BULK COLLECT INTO handling_units_to_move_;
         CLOSE get_handling_units_to_move;
         
         WHILE (handling_units_to_move_.COUNT >= transport_task_capacity_) LOOP
            IF (transport_task_capacity_ = aggr_line_count_) THEN
               handling_units_to_move_.DELETE(handling_units_to_move_.COUNT - transport_task_capacity_, handling_units_to_move_.LAST);
               Transport_Task_API.Set_As_Fixed(transport_task_id_);
               EXIT;
            ELSE
               message_ := NULL;
               FOR i IN 1..transport_task_capacity_ LOOP
                  Message_SYS.Add_Attribute(message_, 'TRANSPORT_TASK_ID', transport_task_id_);
                  Message_SYS.Add_Attribute(message_, 'HANDLING_UNIT_ID', handling_units_to_move_(handling_units_to_move_.LAST).handling_unit_id);
                  handling_units_to_move_.DELETE(handling_units_to_move_.LAST);
               END LOOP;
            
               new_transport_task_id_ := NULL;
               Transport_Task_API.New(new_transport_task_id_);
               New_HU_Transport_Task(message_, new_transport_task_id_);
               Transport_Task_API.Set_As_Fixed(new_transport_task_id_);
            END IF;
            
            aggr_line_count_ := aggr_line_count_ - transport_task_capacity_;
         END LOOP;
      END IF;
   END LOOP;
   Transport_Task_API.Set_Split_By_Hu_Capacity(transport_task_id_, FALSE);
   Inventory_Event_Manager_API.Finish_Session;
END Split_By_Hu_Capacity___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Execute_Transport_Task (
   message_                IN CLOB)
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);
   
   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         IF (NVL(aggr_transport_task_line_tab_(i).handling_unit_id, 0) != 0) THEN
            Execute_Handling_Unit(transport_task_id_    => aggr_transport_task_line_tab_(i).transport_task_id,
                                  handling_unit_id_     => aggr_transport_task_line_tab_(i).handling_unit_id);
         ELSE
            transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id, 
                                                                    handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id, 
                                                                    from_contract_     => aggr_transport_task_line_tab_(i).from_contract, 
                                                                    from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no);
            IF (transport_task_line_tab_.COUNT > 0) THEN 
               FOR j IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
                  IF (transport_task_line_tab_(j).transport_task_status != Transport_Task_Status_API.DB_EXECUTED) THEN
                     Transport_Task_Line_API.Execute(transport_task_id_           => aggr_transport_task_line_tab_(i).transport_task_id,
                                                     line_no_                     => transport_task_line_tab_(j).line_no);
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Execute_Transport_Task;


PROCEDURE Execute_Handling_Unit (
   transport_task_id_   IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   CURSOR get_transport_task_lines (transport_task_id_ IN NUMBER,
                                    handling_unit_id_  IN NUMBER) IS 
     SELECT *
       FROM transport_task_line_tab ttlt
      WHERE transport_task_id = transport_task_id_
        AND ttlt.handling_unit_id IN (SELECT hu.handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      ORDER BY forward_to_location_no;
         
   from_contract_                   transport_task_line_tab.from_contract%TYPE;
   to_contract_                     transport_task_line_tab.to_contract%TYPE;
   to_location_no_                  transport_task_line_tab.to_location_no%TYPE;
   last_fwd_to_location_no_         transport_task_line_tab.forward_to_location_no%TYPE;
   forward_to_transport_task_id_    NUMBER;
   multiple_destinations_           BOOLEAN := FALSE;
   child_handling_unit_tab_         Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   IF (NVL(handling_unit_id_, 0) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXECINVHU: Cannot execute :P1 since it is not a valid handling unit.', handling_unit_id_);
   END IF;
   child_handling_unit_tab_ := Handling_Unit_API.Get_Children(handling_unit_id_) ;
   
   IF (child_handling_unit_tab_.COUNT > 0) THEN
      FOR i IN child_handling_unit_tab_.FIRST..child_handling_unit_tab_.LAST LOOP
         FOR line_rec_ IN get_transport_task_lines(transport_task_id_, child_handling_unit_tab_(i).handling_unit_id) LOOP
            to_contract_    := NVL(to_contract_   , line_rec_.to_contract   );
            to_location_no_ := NVL(to_location_no_, line_rec_.to_location_no);
            IF (line_rec_.to_contract != to_contract_) OR (line_rec_.to_location_no != to_location_no_) THEN 
               multiple_destinations_ := TRUE;
            END IF;            
            EXIT WHEN multiple_destinations_;
         END LOOP;
         EXIT WHEN multiple_destinations_;
      END LOOP;
   END IF;
   
   IF (multiple_destinations_) THEN
      FOR i IN child_handling_unit_tab_.FIRST..child_handling_unit_tab_.LAST LOOP
         Execute_Handling_Unit(transport_task_id_, child_handling_unit_tab_(i).handling_unit_id);
      END LOOP;
   END IF;
   from_contract_   := Handling_Unit_API.Get_Contract(handling_unit_id_);
   to_contract_     := Handling_Unit_API.Get_Transport_Destination_Site(handling_unit_id_);

   IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_        => handling_unit_id_, 
                                                       parent_handling_unit_id_ => NULL);
   END IF;
   
   IF (from_contract_ != to_contract_) THEN
      Handling_Unit_API.Convert_Manual_Weight_And_Volu(handling_unit_id_ => handling_unit_id_, 
                                                       from_contract_    => from_contract_, 
                                                       to_contract_      => to_contract_);
   END IF;
 
   FOR line_rec_ IN get_transport_task_lines(transport_task_id_, handling_unit_id_) LOOP
      Trace_SYS.Message('line_rec_.forward_to_location_no ' || line_rec_.forward_to_location_no);
      
      IF (line_rec_.forward_to_location_no IS NULL) THEN
         forward_to_transport_task_id_ := NULL;
      ELSIF (line_rec_.forward_to_location_no != NVL(last_fwd_to_location_no_, Database_SYS.string_null_)) THEN
         Trace_SYS.Message('finding transport task');
         Transport_Task_API.Find_Or_Create_New_Task(transport_task_id_          => forward_to_transport_task_id_, 
                                                    part_no_                    => line_rec_.part_no, 
                                                    configuration_id_           => line_rec_.configuration_id, 
                                                    from_contract_              => line_rec_.from_contract, 
                                                    from_location_no_           => line_rec_.to_location_no, 
                                                    to_contract_                => line_rec_.to_contract, 
                                                    to_location_no_             => line_rec_.forward_to_location_no, 
                                                    destination_                => Inventory_Part_Destination_API.Decode(line_rec_.destination), 
                                                    order_type_                 => Order_Type_API.Decode(line_rec_.order_type), 
                                                    order_ref1_                 => line_rec_.order_ref1, 
                                                    order_ref2_                 => line_rec_.order_ref2, 
                                                    order_ref3_                 => line_rec_.order_ref3, 
                                                    order_ref4_                 => line_rec_.order_ref4, 
                                                    pick_list_no_               => line_rec_.pick_list_no, 
                                                    shipment_id_                => line_rec_.shipment_id, 
                                                    lot_batch_no_               => line_rec_.lot_batch_no, 
                                                    serial_no_                  => line_rec_.serial_no, 
                                                    eng_chg_level_              => line_rec_.eng_chg_level, 
                                                    waiv_dev_rej_no_            => line_rec_.waiv_dev_rej_no, 
                                                    activity_seq_               => line_rec_.activity_seq, 
                                                    handling_unit_id_           => line_rec_.handling_unit_id, 
                                                    quantity_to_add_            => line_rec_.quantity, 
                                                    reserved_by_source_db_      => line_rec_.reserved_by_source);
         last_fwd_to_location_no_ := line_rec_.forward_to_location_no;
      END IF;
   
      Trace_SYS.Message('forward_to_transport_task_id_ ' || forward_to_transport_task_id_);
      Transport_Task_Line_API.Execute(transport_task_id_            => transport_task_id_,
                                      line_no_                      => line_rec_.line_no,
                                      validate_hu_struct_position_  => Fnd_Boolean_API.DB_FALSE,
                                      forward_to_transport_task_id_ => forward_to_transport_task_id_);
   END LOOP;
END Execute_Handling_Unit;


PROCEDURE Pick_HU_Transport_Task (
   message_                IN CLOB)
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);

   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;

      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_     => aggr_transport_task_line_tab_(i).transport_task_id,
                                                                 handling_unit_id_      => aggr_transport_task_line_tab_(i).handling_unit_id,
                                                                 from_contract_         => aggr_transport_task_line_tab_(i).from_contract,
                                                                 from_location_no_      => aggr_transport_task_line_tab_(i).from_location_no);
         
         IF (transport_task_line_tab_.COUNT > 0) THEN 
            FOR j IN transport_task_line_tab_.FIRST..transport_task_line_tab_.LAST LOOP
               IF (transport_task_line_tab_(j).transport_task_status = Transport_Task_Status_API.DB_CREATED) THEN
                  Transport_Task_Line_API.Pick(transport_task_id_  => aggr_transport_task_line_tab_(i).transport_task_id,
                                               line_no_            => transport_task_line_tab_(j).line_no);
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Pick_HU_Transport_Task;


PROCEDURE Unpick_HU_Transport_Task (
   message_                IN CLOB)
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);

   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;

      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_     => aggr_transport_task_line_tab_(i).transport_task_id,
                                                                 handling_unit_id_      => aggr_transport_task_line_tab_(i).handling_unit_id,
                                                                 from_contract_         => aggr_transport_task_line_tab_(i).from_contract,
                                                                 from_location_no_      => aggr_transport_task_line_tab_(i).from_location_no);
         
         IF (transport_task_line_tab_.COUNT > 0) THEN 
            FOR j IN transport_task_line_tab_.FIRST..transport_task_line_tab_.LAST LOOP
               IF (transport_task_line_tab_(j).transport_task_status = Transport_Task_Status_API.DB_PICKED) THEN
                  Transport_Task_Line_API.Unpick(transport_task_id_  => aggr_transport_task_line_tab_(i).transport_task_id,
                                                 line_no_            => transport_task_line_tab_(j).line_no);
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Unpick_HU_Transport_Task;


PROCEDURE New_HU_Transport_Task (
   message_                     IN CLOB,
   to_transport_task_id_        IN NUMBER,
   allow_move_to_fixed_task_db_ IN VARCHAR2 DEFAULT 'FALSE',
   set_to_task_fixed_db_        IN VARCHAR2 DEFAULT 'FALSE')
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);

   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_     => aggr_transport_task_line_tab_(i).transport_task_id,
                                                                 handling_unit_id_      => aggr_transport_task_line_tab_(i).handling_unit_id,
                                                                 from_contract_         => aggr_transport_task_line_tab_(i).from_contract,
                                                                 from_location_no_      => aggr_transport_task_line_tab_(i).from_location_no);
         
         IF (transport_task_line_tab_.COUNT > 0) THEN 
            FOR j IN transport_task_line_tab_.FIRST..transport_task_line_tab_.LAST LOOP
               IF (transport_task_line_tab_(j).transport_task_status = Transport_Task_Status_API.DB_CREATED) THEN
                  Transport_Task_Line_API.Move(from_transport_task_id_        => aggr_transport_task_line_tab_(i).transport_task_id,
                                               line_no_                       => transport_task_line_tab_(j).line_no,
                                               to_transport_task_id_          => to_transport_task_id_, 
                                               allow_move_from_fixed_task_db_ => Fnd_Boolean_API.DB_TRUE,
                                               allow_move_to_fixed_task_db_   => allow_move_to_fixed_task_db_,
                                               set_from_task_as_fixed_db_     => Fnd_Boolean_API.DB_FALSE,
                                               set_to_task_as_fixed_db_       => set_to_task_fixed_db_);
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END New_HU_Transport_Task;


FUNCTION HU_Apply_Drop_Off_Location (
   message_     IN CLOB ) RETURN CLOB
IS   
   info_                            VARCHAR2(25000);
   clob_out_data_                   CLOB;
BEGIN
   info_ := HU_Apply_Drop_Off_Location_Str(message_);
   
   IF (info_ IS NOT NULL) THEN  
      clob_out_data_ := Message_SYS.Construct('');
      Message_SYS.Add_Clob_Attribute(clob_out_data_, 'INFO', info_);
   END IF;    
   
   RETURN clob_out_data_;
END HU_Apply_Drop_Off_Location;


FUNCTION HU_Apply_Drop_Off_Location_Str (
   message_     IN CLOB ) RETURN VARCHAR2
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
   info_                            VARCHAR2(25000);
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);

   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
    
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id, 
                                                                 handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id, 
                                                                 from_contract_     => aggr_transport_task_line_tab_(i).from_contract, 
                                                                 from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no);
                                                                 
         IF (transport_task_line_tab_.COUNT > 0) THEN
            FOR j IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
               Transport_Task_Line_API.Apply_Drop_Off_Location(info_               => info_,
                                                               transport_task_id_  => aggr_transport_task_line_tab_(i).transport_task_id,
                                                               line_no_            => transport_task_line_tab_(j).line_no);
            END LOOP;
         END IF;
      END LOOP;      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
   RETURN info_;
END HU_Apply_Drop_Off_Location_Str;


FUNCTION HU_Revoke_Two_Step_Trp_Task (
   message_     IN CLOB ) RETURN CLOB
IS 
   info_                            VARCHAR2(25000);
   clob_out_data_                   CLOB;
BEGIN
   info_ := HU_Revoke_Two_Step_Tr_Task_Str(message_);
   IF (info_ IS NOT NULL ) THEN   
      clob_out_data_ := Message_SYS.Construct('');
      Message_SYS.Add_Clob_Attribute(clob_out_data_, 'INFO', info_);      
   END IF;   
   RETURN clob_out_data_;
END HU_Revoke_Two_Step_Trp_Task;

FUNCTION HU_Revoke_Two_Step_Tr_Task_Str (
   message_     IN CLOB ) RETURN VARCHAR2
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
   info_                            VARCHAR2(25000);  
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);
   
   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id, 
                                                                 handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id, 
                                                                 from_contract_     => aggr_transport_task_line_tab_(i).from_contract, 
                                                                 from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no);
                                                                 
         IF (transport_task_line_tab_.COUNT > 0) THEN
            FOR j IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
               Transport_Task_Line_API.Revoke_Two_Step_Transport_Task(info_               => info_,
                                                                      transport_task_id_  => aggr_transport_task_line_tab_(i).transport_task_id,
                                                                      line_no_            => transport_task_line_tab_(j).line_no);
            END LOOP;
         END IF;
      END LOOP;      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
  RETURN info_;
END HU_Revoke_Two_Step_Tr_Task_Str;

-- Method used from the client to check if RMBs in the aggregated handling unit tab should be lit or not.
@UncheckedAccess
FUNCTION Line_With_Status_Exist (
   message_             IN CLOB,
   status_db_           IN VARCHAR2 ) RETURN CLOB
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;  
   status_exist_                    VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   clob_out_data_                   CLOB;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);
   
   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         status_exist_ := Line_With_Status_Exist(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id,
                                                 handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id,
                                                 from_contract_     => aggr_transport_task_line_tab_(i).from_contract,
                                                 from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no,
                                                 status_db_ => status_db_);
         EXIT WHEN status_exist_ = Fnd_Boolean_API.DB_TRUE;
      END LOOP;
   END IF;
   
   clob_out_data_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(clob_out_data_, 'STATUS_EXIST', status_exist_);
   
   RETURN clob_out_data_;
END Line_With_Status_Exist;


-- Method used from the client to check if RMBs in the aggregated handling unit tab should be lit or not
-- Check if at least one line has no forward_to_location
@UncheckedAccess
FUNCTION Line_With_No_Fwd_To_Loc_Exist (
   message_     IN CLOB ) RETURN CLOB
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;   
   no_fwd_to_loc_exist_             VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   clob_out_data_                   CLOB;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);
   
   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         no_fwd_to_loc_exist_ := Line_With_No_Fwd_To_Loc_Exist(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id, 
                                                                 handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id, 
                                                                 from_contract_     => aggr_transport_task_line_tab_(i).from_contract, 
                                                                 from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no);
         EXIT WHEN no_fwd_to_loc_exist_ = Fnd_Boolean_API.DB_TRUE;
      END LOOP;
   END IF;
   
   clob_out_data_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(clob_out_data_, 'NO_FWD_TO_LOC_EXIST', no_fwd_to_loc_exist_);
   
   RETURN clob_out_data_;
END Line_With_No_Fwd_To_Loc_Exist;


-- Method used from the client to check if RMBs in the aggregated handling unit tab should be lit or not
-- Check if at least one line has a forward_to_location
FUNCTION Line_With_Fwd_To_Loc_Exist (
   message_     IN CLOB ) RETURN CLOB
IS
   aggr_transport_task_line_tab_    Aggr_Transport_Task_Line_Tab;   
   fwd_to_loc_exist_                VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   clob_out_data_                   CLOB;
BEGIN
   aggr_transport_task_line_tab_ := Get_Aggr_Trans_Task_Lines___(message_);
   
   IF (aggr_transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN aggr_transport_task_line_tab_.FIRST .. aggr_transport_task_line_tab_.LAST LOOP
         fwd_to_loc_exist_ := Line_With_Fwd_To_Loc_Exist(transport_task_id_ => aggr_transport_task_line_tab_(i).transport_task_id, 
                                                         handling_unit_id_  => aggr_transport_task_line_tab_(i).handling_unit_id, 
                                                         from_contract_     => aggr_transport_task_line_tab_(i).from_contract, 
                                                         from_location_no_  => aggr_transport_task_line_tab_(i).from_location_no);
         EXIT WHEN fwd_to_loc_exist_ = Fnd_Boolean_API.DB_TRUE;
      END LOOP;
   END IF;
   
   clob_out_data_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(clob_out_data_, 'FWD_TO_LOC_EXIST', fwd_to_loc_exist_);
   
   RETURN clob_out_data_;
END Line_With_Fwd_To_Loc_Exist;

-- This method is used by the Aurena client where it needs to have line level check for handling enable disable condition
@UncheckedAccess
FUNCTION Line_With_Status_Exist (
   transport_task_id_   IN NUMBER,
   handling_unit_id_    IN NUMBER,
   from_contract_       IN VARCHAR2,
   from_location_no_    IN VARCHAR2,
   status_db_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_task_line_tab_   Trans_Task_Line_Status_Tab;
   status_exist_              VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
BEGIN
   transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_);
   IF (transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
         IF (transport_task_line_tab_(i).transport_task_status = status_db_) THEN
            status_exist_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
      
   RETURN status_exist_;
END Line_With_Status_Exist;

-- This method is used by the Aurena client where it needs to have line level check for handling enable disable condition
@UncheckedAccess
FUNCTION Line_With_No_Fwd_To_Loc_Exist (
   transport_task_id_   IN NUMBER,
   handling_unit_id_    IN NUMBER,
   from_contract_       IN VARCHAR2,
   from_location_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS  
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
   no_fwd_to_loc_exist_             VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
  
BEGIN
   transport_task_line_tab_ := Get_Transport_Task_Lines___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_);
   IF (transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
         IF (Transport_Task_Line_API.Get_Forward_To_Location_No(transport_task_id_, transport_task_line_tab_(i).line_no) IS NULL) THEN
            no_fwd_to_loc_exist_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;  
   
   RETURN no_fwd_to_loc_exist_;
END Line_With_No_Fwd_To_Loc_Exist;

-- This method is used by the Aurena client where it needs to have line level check for handling enable disable condition
FUNCTION Line_With_Fwd_To_Loc_Exist (
   transport_task_id_   IN NUMBER,
   handling_unit_id_    IN NUMBER,
   from_contract_       IN VARCHAR2,
   from_location_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   transport_task_line_tab_         Trans_Task_Line_Status_Tab;
   fwd_to_loc_exist_                VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;   
BEGIN
   transport_task_line_tab_ :=  Get_Transport_Task_Lines___(transport_task_id_, handling_unit_id_, from_contract_, from_location_no_);
   IF (transport_task_line_tab_.COUNT > 0) THEN
      FOR i IN transport_task_line_tab_.FIRST .. transport_task_line_tab_.LAST LOOP
         IF (Transport_Task_Line_API.Get_Forward_To_Location_No(transport_task_id_, transport_task_line_tab_(i).line_no) IS NOT NULL) THEN
            fwd_to_loc_exist_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
  
   RETURN fwd_to_loc_exist_;
END Line_With_Fwd_To_Loc_Exist;

PROCEDURE Generate_Aggr_Handl_Unit_View (
   transport_task_id_ IN NUMBER )         
IS
   transport_task_line_tab_  Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;

   CURSOR get_all_lines IS
      SELECT from_contract contract, part_no, configuration_id, from_location_no location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, 
             handling_unit_id, quantity
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE transport_task_id = transport_task_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN get_all_lines;
   FETCH get_all_lines BULK COLLECT INTO transport_task_line_tab_;
   CLOSE get_all_lines;

   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_              => transport_task_id_,
                                                  source_ref_type_db_       => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK,
                                                  inv_part_stock_tab_       => transport_task_line_tab_,
                                                  only_outermost_in_result_ => FALSE,
                                                  incl_hu_zero_in_result_   => TRUE);
   IF (Transport_Task_API.Get_Split_By_Hu_Capacity_Db(transport_task_id_) = 'TRUE') THEN
      Split_By_Hu_Capacity___(transport_task_id_);
   END IF;
   
END Generate_Aggr_Handl_Unit_View;


-- This method is used by DataCaptTranspTaskHu
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,   -- session contract
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   to_location_no_             IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2 )
IS
   -- The reason why this method have session contract as parameter while the other methods don't have it, is that we want the LOV to 
   -- only show data filtered on session contract, but it will still be possible to entered/scan manually other values so thats why 
   -- Get_Column_Value_If_Unique/Record_With_Column_Value_Exist don't have session contract as a filter/parameter. This will also mean 
   -- this LOV will not work properly for any items if user chooses another from contract than session contract, so then user 
   -- should not use LOV for any other item.
   TYPE Get_Lov_Values           IS REF CURSOR;
   get_lov_values_               Get_Lov_Values;
   stmt_                         VARCHAR2(4000);
   TYPE Lov_Value_Tab            IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_                Lov_Value_Tab;
   second_column_name_           VARCHAR2(200);
   second_column_value_          VARCHAR2(200);
   lov_item_description_         VARCHAR2(200);
   lov_value_                    VARCHAR2(2000);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   temp_handling_unit_id_        NUMBER;
   tmp_location_no_              VARCHAR2(35);
   temp_sscc_                    VARCHAR2(18);
   temp_alt_handl_unit_label_id_ VARCHAR2(25);
   --aggr_line_id_in_a_loop_       BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Transp_Task_Handl_Unit_Process', column_name_);

      stmt_ := ' SELECT ' || column_name_ || '
                 FROM Transp_Task_Handl_Unit_Process ';
      IF transport_task_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
      END IF;
      IF aggregated_line_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
      END IF;
      IF transport_task_status_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND transport_task_status_db is NULL AND :transport_task_status_db_ IS NULL';
      ELSIF transport_task_status_db_ = '%' THEN
         stmt_ := stmt_ || ' AND :transport_task_status_db_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
      END IF;
      IF from_contract_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND from_contract = :from_contract_';
      END IF;
      IF from_location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
      END IF;
      IF to_contract_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND to_contract is NULL AND :to_contract_ IS NULL';
      ELSIF to_contract_ = '%' THEN
         stmt_ := stmt_ || ' AND :to_contract_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND to_contract = :to_contract_';
      END IF;
      IF to_location_no_ IS NULL THEN
         stmt_ := stmt_ || ' AND to_location_no IS NULL AND :to_location_no_ IS NULL';
      ELSIF to_location_no_ = '%' THEN
         stmt_ := stmt_ || ' AND :to_location_no_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND to_location_no = :to_location_no_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
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
      stmt_ := stmt_ || ' AND from_contract = :contract_ ';

      -- TODO: not sure if this is enough here especially for PICK/UNPICK actions since then the lines are still executable and should show up here, maybe we need to add check if the action was EXECUTE or not
      -- TODO2: what happens if it was a large hu structure with several levels, those will not be consumed here with this solution (similar problem with the other 2 hu processes).
      -- Add extra filtering of earlier scanned values of this data item to dynamic cursor if data item is AGGREGATED_LINE_ID and is in a loop for this configuration
      /*IF (column_name_ = 'AGGREGATED_LINE_ID') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, column_name_)) THEN
            stmt_ := stmt_  || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id_
                                                                                              AND  data_item_id = ''AGGREGATED_LINE_ID''
                                                                                              AND  data_item_detail_id IS NULL
                                                                                              AND  data_item_value = ROWIDTOCHAR(aggregated_line_id)) ';   
            aggr_line_id_in_a_loop_ := TRUE;
         END IF;
      END IF; */ 
      -- No fake consumation in this process to start with since part process dont have it and its to complicated (like the issues in the TODOs above).
      -- Not sure that we can support fake consumation for large hu structures, needs investigation if we get issues with this.


     --ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
     -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
     -- since this needs be exactly same order as the IEE client (frmTransportTaskHandlingUnits).
     stmt_ := stmt_  || ' ORDER BY transport_task_status_db,
                                   from_location_no,
                                   NVL(top_parent_handling_unit_id, handling_unit_id),
                                   structure_level,
                                   handling_unit_id ';

       
     @ApproveDynamicStatement(2017-03-03,DAZASE)
     OPEN get_lov_values_ FOR stmt_ USING transport_task_id_,
                                          aggregated_line_id_,
                                          transport_task_status_db_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          to_location_no_,
                                          handling_unit_id_,
                                          sscc_,
                                          alt_handling_unit_label_id_,
                                          contract_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('FROM_CONTRACT') THEN
               second_column_name_ := 'CONTRACT_DESCRIPTION';
            WHEN ('FROM_LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('TO_CONTRACT') THEN
               second_column_name_ := 'CONTRACT_DESCRIPTION';
            WHEN ('TO_LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('AGGREGATED_LINE_ID') THEN
               IF (session_rec_.capture_process_id = 'PROCESS_TRANSPORT_TASK_HU') THEN -- just in case some other process starts using this LOV since they dont have these details probably
                  second_column_name_ := 'AGGREGATED_LINE_DESC';
               ELSE
                  NULL;
               END IF;
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'CONTRACT_DESCRIPTION') THEN
                     second_column_value_ := Site_API.Get_Description(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'LOCATION_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN
                     IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                        temp_handling_unit_id_ := lov_value_tab_(i);
                     ELSIF (column_name_ = 'SSCC') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                     ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     END IF;
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));

                  ELSIF (second_column_name_ = 'AGGREGATED_LINE_DESC') THEN
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_HANDLING_UNIT_ID'))) THEN
                        temp_handling_unit_id_ := Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                             aggregated_line_id_         => lov_value_tab_(i),
                                                                             transport_task_status_db_   => transport_task_status_db_, 
                                                                             from_contract_              => from_contract_,
                                                                             from_location_no_           => from_location_no_, 
                                                                             to_contract_                => to_contract_, 
                                                                             handling_unit_id_           => handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             column_name_                => 'HANDLING_UNIT_ID');
                     END IF;
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_SSCC'))) THEN
                        temp_sscc_ := Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                 aggregated_line_id_         => lov_value_tab_(i),
                                                                 transport_task_status_db_   => transport_task_status_db_, 
                                                                 from_contract_              => from_contract_,
                                                                 from_location_no_           => from_location_no_, 
                                                                 to_contract_                => to_contract_, 
                                                                 handling_unit_id_           => handling_unit_id_,
                                                                 sscc_                       => sscc_,
                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                 column_name_                => 'SSCC');
                     END IF;
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID'))) THEN
                        temp_alt_handl_unit_label_id_ := Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                                    transport_task_status_db_   => transport_task_status_db_, 
                                                                                    from_contract_              => from_contract_,
                                                                                    from_location_no_           => from_location_no_, 
                                                                                    to_contract_                => to_contract_, 
                                                                                    handling_unit_id_           => handling_unit_id_,
                                                                                    sscc_                       => sscc_,
                                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                    column_name_                => 'ALT_HANDLING_UNIT_LABEL_ID');
                     END IF;
                     tmp_location_no_ := Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                    transport_task_status_db_   => transport_task_status_db_, 
                                                                    from_contract_              => from_contract_,
                                                                    from_location_no_           => from_location_no_, 
                                                                    to_contract_                => to_contract_, 
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    sscc_                       => sscc_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => 'FROM_LOCATION_NO');


                     second_column_value_ := tmp_location_no_; 
                     IF (temp_handling_unit_id_ IS NOT NULL) THEN
                        second_column_value_ := second_column_value_ || ' | ' || temp_handling_unit_id_; 
                     END IF;
                     IF (temp_sscc_ IS NOT NULL AND temp_sscc_ != 'NULL') THEN
                        second_column_value_ := second_column_value_ || ' | ' || temp_sscc_; 
                     END IF;
                     IF (temp_alt_handl_unit_label_id_ IS NOT NULL AND temp_alt_handl_unit_label_id_ != 'NULL') THEN
                        second_column_value_ := second_column_value_ || ' | ' || temp_alt_handl_unit_label_id_; 
                     END IF;
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                     lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;

            IF (column_name_ = 'TRANSPORT_TASK_STATUS_DB') THEN
               lov_value_ := Transport_Task_Status_API.Decode(lov_value_tab_(i));
            ELSE
               lov_value_ := lov_value_tab_(i);
            END IF;
           
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_,
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


-- This method is used by DataCaptStartTransTask
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   transport_task_id_          IN NUMBER,
   from_contract_              IN VARCHAR2,   
   from_location_no_           IN VARCHAR2,
   transport_task_level_db_    IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2 )
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
   temp_lov_item_value_    VARCHAR2(200);
   temp_from_contract_     VARCHAR2(5);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('START_TRANSPORT_TASK_PROCESS', column_name_);

      stmt_ := 'SELECT ' || column_name_;
      stmt_ := stmt_  || ' FROM START_TRANSPORT_TASK_PROCESS ';
      IF transport_task_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
      END IF;
      IF from_contract_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND from_contract = :from_contract_';
      END IF;
      IF from_location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
      END IF;
      IF transport_task_level_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :transport_task_level_db_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_or_handling_unit = :transport_task_level_db_';
      END IF;


      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
      -- since this needs be location/hu sorted.
      -- The NVL on handling_unit_id becuase 0 is NULL in this view and we still want non handling units to come before handling units in the start process.
      stmt_ := stmt_  || ' ORDER BY transport_task_status_db,
                                    from_location_no, 
                                    NVL(handling_unit_id,0) ';
      -- Having handling_unit_id after location_no makes sure that we always get non handling unit lines handle before handling unit lines on each location

      --stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';

      @ApproveDynamicStatement(2017-03-23,DAZASE)
      OPEN get_lov_values_ FOR stmt_ USING transport_task_id_,
                                           from_contract_,
                                           from_location_no_,
                                           transport_task_level_db_;

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
               IF (column_name_ = 'FROM_LOCATION_NO') THEN
                  IF from_contract_ IS NULL THEN
                     temp_from_contract_ := Get_Column_Value_If_Unique(transport_task_id_       => transport_task_id_,
                                                                       from_contract_           => from_contract_,   
                                                                       from_location_no_        => lov_value_tab_(i),
                                                                       transport_task_level_db_ => transport_task_level_db_,
                                                                       column_name_             => 'FROM_CONTRACT');
                  ELSE
                     temp_from_contract_ := from_contract_;
                  END IF;
                  IF temp_from_contract_ IS NOT NULL THEN
                     lov_item_description_ :=  Inventory_Location_API.Get_Location_Name(temp_from_contract_, lov_value_tab_(i));
                  END IF;
               END IF;
            END IF;
            IF (column_name_ = 'PART_OR_HANDLING_UNIT') THEN
               temp_lov_item_value_ :=  Part_Or_Handl_Unit_Level_API.Decode(lov_value_tab_(i));
            ELSE
               temp_lov_item_value_ :=  lov_value_tab_(i);
            END IF;

            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => temp_lov_item_value_,
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


-- This method is used by DataCaptTranspTaskHu
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Transp_Task_Handl_Unit_Process', column_name_);
   stmt_ := ' SELECT DISTINCT ' || column_name_ || '
              FROM  Transp_Task_Handl_Unit_Process ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF aggregated_line_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
   END IF;
   IF transport_task_status_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND transport_task_status_db is NULL AND :transport_task_status_db_ IS NULL';
   ELSIF transport_task_status_db_ = '%' THEN
      stmt_ := stmt_ || ' AND :transport_task_status_db_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF to_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND to_contract is NULL AND :to_contract_ IS NULL';
   ELSIF to_contract_ = '%' THEN
      stmt_ := stmt_ || ' AND :to_contract_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND to_contract = :to_contract_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
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

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2017-03-03,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING transport_task_id_,
                                           aggregated_line_id_,
                                           transport_task_status_db_,
                                           from_contract_,
                                           from_location_no_,
                                           to_contract_,
                                           handling_unit_id_,
                                           sscc_,
                                           alt_handling_unit_label_id_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF;
   CLOSE get_column_values_;
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptStartTransTask
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   transport_task_id_          IN NUMBER,
   from_contract_              IN VARCHAR2,   
   from_location_no_           IN VARCHAR2,
   transport_task_level_db_    IN VARCHAR2,
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;                 
   get_column_values_    Get_Column_Value;     
   stmt_                 VARCHAR2(2000);
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('START_TRANSPORT_TASK_PROCESS', column_name_);

   stmt_ := 'SELECT DISTINCT ' || column_name_ || ' 
             FROM START_TRANSPORT_TASK_PROCESS ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF transport_task_level_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :transport_task_level_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_or_handling_unit = :transport_task_level_db_';
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
                          
   @ApproveDynamicStatement(2017-03-23,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING transport_task_id_,
                                           from_contract_,
                                           from_location_no_,
                                           transport_task_level_db_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF; 
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptTranspTaskHu
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   data_item_description_      IN VARCHAR2,
   column_value_nullable_      IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_ Check_Exist;
   stmt_          VARCHAR2(4000);
   dummy_         NUMBER;
   exist_         BOOLEAN := FALSE;
BEGIN
-- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Transp_Task_Handl_Unit_Process', column_name_);
   stmt_ := ' SELECT 1  
              FROM Transp_Task_Handl_Unit_Process ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF aggregated_line_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
   END IF;
   IF transport_task_status_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND transport_task_status_db is NULL AND :transport_task_status_db_ IS NULL';
   ELSIF transport_task_status_db_ = '%' THEN
      stmt_ := stmt_ || ' AND :transport_task_status_db_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF to_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND to_contract is NULL AND :to_contract_ IS NULL';
   ELSIF to_contract_ = '%' THEN
      stmt_ := stmt_ || ' AND :to_contract_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND to_contract = :to_contract_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
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

             
   IF (column_value_nullable_) THEN
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   ELSE -- NOT column_value_nullable_
     stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_ '; -- TODO: this and column_value_nullable_ might be unnecessary the above one will take care of all variants
   END IF;


   IF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2017-03-03,DAZASE)
      OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                          aggregated_line_id_,
                                          transport_task_status_db_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          handling_unit_id_,
                                          sscc_,
                                          alt_handling_unit_label_id_,
                                          column_value_,
                                          column_value_;
   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2017-03-03,DAZASE)
      OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                          aggregated_line_id_,
                                          transport_task_status_db_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          handling_unit_id_,
                                          sscc_,
                                          alt_handling_unit_label_id_,
                                          column_value_;
   END IF;
                                                    
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCaptStartTransTask
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   transport_task_id_          IN NUMBER,
   from_contract_              IN VARCHAR2,   
   from_location_no_           IN VARCHAR2,
   transport_task_level_db_    IN VARCHAR2,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2 ) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('START_TRANSPORT_TASK_PROCESS', column_name_);

   stmt_ := 'SELECT 1 
             FROM START_TRANSPORT_TASK_PROCESS ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF transport_task_level_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :transport_task_level_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_or_handling_unit = :transport_task_level_db_';
   END IF;


   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2017-03-23,DAZASE)
   OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                       from_contract_,
                                       from_location_no_,
                                       transport_task_level_db_,
                                       column_value_,
                                       column_value_;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method was created especially for Process Handling Unit on Transport Task (wadaco process) and will probably not suit anything else
@UncheckedAccess
FUNCTION Lines_Left_To_Execute (
   transport_task_id_ IN NUMBER ) RETURN NUMBER
IS
   lines_   NUMBER;
   CURSOR get_lines_left_to_exec IS
      SELECT COUNT(*)
      FROM   START_TRANSPORT_TASK_PROCESS
      WHERE  transport_task_id = transport_task_id_;
BEGIN
   OPEN  get_lines_left_to_exec;
   FETCH get_lines_left_to_exec INTO lines_;
   CLOSE get_lines_left_to_exec;
   RETURN lines_;
END Lines_Left_To_Execute;


-- This method was created especially for Process Handling Unit on Transport Task (wadaco process) and will probably not suit anything else
@UncheckedAccess
FUNCTION Last_Hndl_Unit_Structure_On_TT (
   transport_task_id_     IN NUMBER,
   root_handling_unit_id_ IN NUMBER) RETURN BOOLEAN
IS
   part_lines_                NUMBER;
   temp_handling_unit_id_     NUMBER;
   last_handl_unit_structure_ BOOLEAN := FALSE;

   CURSOR part_lines_left_to_execute_ IS
      SELECT COUNT(*)
      FROM   START_TRANSPORT_TASK_PROCESS
      WHERE  transport_task_id = transport_task_id_
       AND   part_or_handling_unit = 'PART';

   CURSOR get_all_remaing_hu_ IS
      SELECT handling_unit_id
      FROM   START_TRANSPORT_TASK_PROCESS
      WHERE  transport_task_id = transport_task_id_;

BEGIN
   OPEN  part_lines_left_to_execute_;
   FETCH part_lines_left_to_execute_ INTO part_lines_;
   CLOSE part_lines_left_to_execute_;

   IF part_lines_ > 0 THEN
      last_handl_unit_structure_  := FALSE;  -- Make sure no part lines are still left to execute
   ELSE
      OPEN  get_all_remaing_hu_;
      LOOP
         FETCH get_all_remaing_hu_ INTO temp_handling_unit_id_;         
         EXIT WHEN get_all_remaing_hu_%NOTFOUND;
         IF (temp_handling_unit_id_ != root_handling_unit_id_ AND 
            Handling_Unit_API.Get_Root_Handling_Unit_Id(temp_handling_unit_id_) != root_handling_unit_id_) THEN
            last_handl_unit_structure_  := FALSE;  
            -- If current hu is not root and its root is not the same as the root sent in to this method 
            -- then all remaining hu's dont belong to the same hu structure
            EXIT;
         ELSE
            last_handl_unit_structure_  := TRUE;
         END IF;		
      END LOOP;
      CLOSE get_all_remaing_hu_;
   END IF;

   RETURN last_handl_unit_structure_;
END Last_Hndl_Unit_Structure_On_TT;


PROCEDURE Check_Storage_Requirements (
   handling_unit_id_tab_ IN Handling_Unit_API.Handling_Unit_Id_Tab )
IS
   to_location_no_ transport_task_line_tab.to_location_no%TYPE;

   CURSOR get_transport_task_lines IS
      SELECT *
        FROM transport_task_line_tab
       WHERE handling_unit_id      IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   -- Find all created transport task lines and run the Storage Requirements Check. We need to do this as a separate step afterwards
   -- so that the complete content of the Handling Unit is already on the transport task. This is to make sure that the Storage Requirements Check
   -- can recognize the correct top parent handling unit type when taking the snapshot for the destination locations. 
   FOR tt_line_rec_ IN get_transport_task_lines LOOP
      FOR i IN 1..2 LOOP
         -- Need to check for both to_location and forward_to_location.
         to_location_no_ := CASE i WHEN 1 THEN tt_line_rec_.to_location_no ELSE tt_line_rec_.forward_to_location_no END;
         IF (to_location_no_ IS NOT NULL) THEN
            Inventory_Putaway_Manager_API.Check_Storage_Requirements(to_contract_        => tt_line_rec_.to_contract,
                                                                     part_no_            => tt_line_rec_.part_no,
                                                                     configuration_id_   => tt_line_rec_.configuration_id,
                                                                     to_location_no_     => to_location_no_,
                                                                     lot_batch_no_       => tt_line_rec_.lot_batch_no,
                                                                     serial_no_          => tt_line_rec_.serial_no,
                                                                     eng_chg_level_      => tt_line_rec_.eng_chg_level,
                                                                     waiv_dev_rej_no_    => tt_line_rec_.waiv_dev_rej_no,
                                                                     activity_seq_       => tt_line_rec_.activity_seq,
                                                                     handling_unit_id_   => tt_line_rec_.handling_unit_id,
                                                                     quantity_           => tt_line_rec_.quantity);
         END IF;
      END LOOP;
   END LOOP;
END Check_Storage_Requirements;

