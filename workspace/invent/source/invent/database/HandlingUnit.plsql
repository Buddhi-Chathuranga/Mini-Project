-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  220118  LEPESE  SC21R2-2766, Changed package constant mixed_value_ from private to public.
--  220107  LEPESE  SC21R2-2766, Changed method Putaway to call Inventory_Putaway_Manager_API.Putaway_Handling_Units to process several handling units in one call.
--  220107          Added new version of method Putaway that takes Handling_Unit_Id_Tab as parameter instead of a number or varchar2.
--  220103  LEPESE  SC21R2-2766, Added TYPE Public_Tab. 
--  211203  SBalLK  SC21R2-6433, Added Clear_Hu_Details_From_Tmp(), Get_Hu_Details_From_Tmp() and Save_Hu_Details_Into_Tmp() methods.
--  211026  PrRtlk  SC21R2-901, Added requisitioner_code_ parameter to Move_With_Shipment_Order methods and in order to create Shipment Order with Requisitioner Code.
--  211001  PamPlk  SC21R2-901, Added method Move_With_Shipment_Order and an overload of it, in order to support Move with Shipment Order functionality.
--  210728  RoJalk  SC21R2-1034, Added method Get_Inventory_Quantity.
--  210705  MoInlk  Bug 159673 (SCZ-14915), Modified Get_Trans_Attr_Value_If_Unique(), passed order_type_db_ parameter, 
--  210705          as Transport_Task_Line_API.Get_Column_Value_If_Unique method got a new parameter.
--  210119  SBalLK  Issue SC2020R1-11830, Modified Modify_Shipment_Id() and Apply_Pack_Instr_Node_Settings() methods by removing attr_
--  210119          functionality to optimize the performance.
--  201104  Aabalk  SCZ-12088, Modified Clear_Manual_Weight_And_Volume() to check shipment type setting to keep manual weight and volume. 
--  201104          Added Handle_Shipment_On_Update___ to Clear_Manual_Weight_And_Volume() to reset shipment flags and recalculate freight charges.
--  201026  ThKrlk  Bug 155999 (SCZ-12106), Modified Get_Net_Weight() to get UOM of the weight if passed uom_for_weight_ is null.
--  200728  Aabalk  SCXTEND-4364, Added function Get_Operative_Unit_Tare_Weight() to return the current tare weight of a particular handling unit.
--  200728          Modified Update___ method to include manual_tare_weight changes when handling shipment udpates.
--  200601  RoJalk  SC2020R1-1391, Modified MULTORDTRANS error text in Validate_Structure_Position to consider warehouse context.  
--  200520  UdGnlk  Bug 153793 (SCZ-10016), Modified New_With_Pack_Instr_Settings() by removing the bug correction 149527 partially inorder to retrieve values in Check_Insert___().
--  200506  PAMMLK  MF2020R1-940, Modified Change_Ownership_To_Company and Temporary_Part_Ownership_API.Create_New to pass ownership_transfer_reason_id_.
--  200504  PAMMLK  MF2020R1-939, Modified Change_Ownership_Between_Cust, Perform_Stock_Operation___ ,Perform_Stock_Operat_Invent___ to pass ownership_transfer_reason_id_.
--  200316  Aabalk  Bug 152790(SCZ-8697), Modified Check_Common___ to allow only positive values for manual tare weight. 
--  190926  DaZase  SCSPRING20-113, Changed some info and error message ids to solve MessageDefinitionValidation issue.
--  200316          Modified Get_Tare_Weight_This_Level___ method to use manual tare weight when available.
--  200311  DaZase  SCXTEND-3803, Small change in both Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200306  SBalLK  Bug 152775(SCZ-8855), Added Modify_Avail_Control_Id___(), Modify_Avail_Control_Id__() methods and modified Modify_Availability_Control_Id()
--  200306          method to enable change availability control id change in background.
--  191224  PamPlk  Bug 151550 (SCZ-7964), Modified the method 'Add_To_Transport_Task' in order to validate the storage requirement apart from ARRIVAL or QA locations.
--  191118  SBalLK  Bug 150995 (SCZ-7783), Modified Putaway() method by removing space added to beginning of the information message for correctly decode messages in client framework.
--  191024  SWiclk  Bug 150632 (SCZ-6808), Modified Create_Data_Capture_Lov(), Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist() methods  
--  191024          in order to improve performance by avoiding NVL in Where statements.
--  190829  UdGnlk  Bug 149527 (SCZ-6329), Modified New_With_Pack_Instr_Settings() to initialize values for Fnd_Boolean_API.DB_FALSE.
--  190722  BudKlk  Bug 149275 (SCZ-5522), Modified the method Has_Immovable_Stock_Reserv() to allow move reservation with transport task for distribution order. 
--  190710  RoJalk  SCUXXW4-22687, Added method Check_Generate_Sscc_No_Shpmnt and renamed Generate_Sscc_No_Exist_In_Strc to Check_Generate_Sscc_No_Struct. 
--  190617  ShPrlk  Bug 148455 (SCZ-5011), Replaced the Source_Ref_Type_Tab structure of move_reserve_src_type_tab_ to individual constants
--  190617          to reduce performance overheads.
--  190510  DiKuLk  Bug 148108(SCZ-4560), Added Get_Children() as the public wrapper for Get_Children___().
--  190405  ChFolk  SCUXXW4-16439, Added record type handling_unit_details_rec and method Get_Handling_Unit_Details which is used by Aurena client.
--  190208  LEPESE  SCUXXW4-16190, Correction in Insert___ to inherit location_no and contract from parent.
--  180307  RaVdlk  STRSC-17471, Removed installation errors from sql plus tool
--  180305  ChFolk  STRSC-17433, Modfied type of the variable additive_accessory_volume_ from VARCHAR2 to NUMBER in Get_Operative_Volume.
--  180301  LEPESE  STRSC-17288, Modifications in Add_To_Transport_Task in order to run Check_Storage_Requirements when all content of
--  180301          the handling unit has been added to transport task lines, so that the snapshot can see the whole Handling Unit being on TT.
--  180104  ChFolk  STRSC-15533, Modified Has_Immovable_Stock_Reserv to use Fnd_Boolean_API instead of hard coded values. Modified Has_Stock_On_Transport_Task
--  180104          to avoid not in condition as it is not good for performance.
--  171205  LEPESE  STRSC-12062, Added method Other_Attribute_Is_Changed___.
--  171127  RoJalk  STRSC-14706, Added the method Handle_Shipment_On_Update___ and called from Update___ to handle changes in shipment when HU info is changed.
--  171107  LEPESE  STRSC-12861, Added methods Check_Max_Capacity_Exceeded and Validate_Max_Capacity___.
--  171107          Moved implementation of Get_Max_Capacity_Exceeded_Info into Validate_Max_Capacity___.
--  171026  MaRalk  STRSC-12065, Modified method Insert___ in order to handle document text.
--  171023  ChFolk  STRSC-13721, Modified Has_Immovable_Stock_Reserv to consider all options in Reservat_Adjustment_Option_API otherwise it gives an error in runtime.
--  171017  ChFolk  STRSC-12120, Added new method Has_Stock_On_Transport_Task which is to check if any un executed transport task exists for any child
--  171017          of the given root handling unit. Added method Has_Immovable_Stock_Reserv which checks the full handling unit can be moved
--  171017          according to the stock reservation parameter defined in the site. 
--  171009  Chfose  STRSC-8922, Extracted the logic from Perform_Stock_Operat_Invent___ into Add_To_Transport_Task to add sorting by qty.
--  170919  Chfose  STRSC-8922, Modified Perform_Stock_Operat_Invent___ to add everything within the handling unit to the same transport task.
--  170911  Mwerse  STRSC-11836, Fixed Has_Mixed_Lot_Batches___ to only consider lot batches within same part_no, conformed the solutions in Has_Mixed_Cond_Codes___ and Has_Mixed_Part_Numbers___
--  170830  ChFolk  STRSC-11366, Modified Is_Hu_Type_And_Category_Match to make it general for any given hanlding unit with handling unit type and category.
--  170816  ChFolk  STRSC-11295, Modified Is_Hu_Type_And_Category_Match to consider top_handling_unit parameters for hanlding_units which do not have children.
--  170731  SWiclk  STRSC-9013, Added Get_Id_Version_By_Keys().
--  170726  ChFolk  STRSC-10952, Added new method Is_Hu_Type_And_Category_Match which is used when creating counting report to 
--  170726          check the handling unit is matched with defined parameter.
--  170705  Chfose  STRSC-8933, Added new overloaded methods for Create_Sscc, Modify_Waiv_Dev_Rej_No, Modify_Availability_Control_Id, Modify_Expiration_Date,
--  170705          Change_Ownership_Between_Cust and Change_Ownership_To_Company that takes a list of handling unit ids.
--  170609  LEPESE  LIM-11487, Added method Clear_Manual_Weight_And_Volume and used it in Clear_Manual_Weight_Volume___, Handle_Change_Of_Parent___, Insert___, Post_Delete___, 
--  170609          Remove_Manual_Gross_Weight and Remove_Manual_Volume. Added method Clear_Manual_Weight_Volume___ and removed methods Remove_Manual_Gross_Weight___ and Remove_Manual_Volume___. 
--  170605  LEPESE  LIM-11502, Modified Get_Max_Capacity_Exceeded_Info to get leading zero before decimal point if number smaller than 1.
--  170601  LEPESE  LIM-11502, Added method Get_Hu_Type_Tare_Weight___. Modified Get_Content_Weight___ and Get_Content_Volume___ to start with operative weight/volume and then reduce with 
--  170601          tare weight or volume for the handling unit type. But for non-additive HU types or when additive accessories are used then calculate volume using only content in form 
--  170601          of packed parts, children HU's and accessories. 
--  170531  KHVESE  LIM-10758, Modified method Perform_Stock_Operat_Invent___ to call to methods Move_Hu_Res_Wth_Transp_Task and New_Or_Add_To_Existing with check_storage_requirements_ => TRUE.
--  170530  ChBnlk  Bug 135688, Modified Post_Delete___() to call Accessory_On_Handling_Unit_API.Remove(remrec_.handling_unit_id). Added new method Raise_Record_Delete_Error___() and 
--  170530          override the method Check_Delete___() to be able to display the framework error message when the trying to delete an InventoryPartAtCustomer, InventoryPartInStock, InventoryTransactionHist
--  170530          or InventoryPartInTransit object.
--  170526  LEPESE  STRSC-8697, Added methods Get_Content_Volume___ and Get_Content_Weight___ to be used in Get_Max_Capacity_Exceeded_Info.
--  170524  LEPESE  STRSC-7683, Changed info messages in method Get_Max_Capacity_Exceeded_Info to include handling unit type ID.
--  170518  LEPESE  STRSC-7683, Added method Get_Max_Capacity_Exceeded_Info.
--  170515  Chfose  STRSC-8116, Added logic in Get_Operative_Volume to consider the volume of the Inventory Parts on a Handling Unit when using additive volume.
--  170512  LEPESE  STRSC-8437, Added parameter calling_process_ to method Putaway.
--  170508  LEPESE  LIM-11466, Added validations for negative manual gross weight and manual volume. Opened up for zero lenght measures.
--  170508  Chfose  STRSC-5503, Changed the function Get_Net_Weight_This_Level___ to a procedure.
--  170508          Moved the logic which was within Get_Net_Weight into the new procedure Get_Net_And_Adjusted_Weight___.
--  170508          Modified the methods Get_Net_Weight and Get_Operational_Gross_Weight by calling the new method Get_Net_And_Adjusted_Weight___.
--  170506  MaRalk  STRSC-7532, Modified method Check_Common___ to restrict saving negative values for manual gross weight and manual volume.
--  170426  KHVESE  STRSC-2419, Modified method Create_Data_Capture_Lov, added structure level to HANDLING_UNIT_TYPE_DESCRIPTION_SSCC AND HANDLING_UNIT_TYPE_DESCRIPTION_ALT.
--  170405  LEPESE  LIM-11349, Added method Get_Full_Tree_Given_Any_Node and made modifications in Set_Stock_Location, Clear_Stock_Location, 
--  170405          Handle_Change_Of_Parent___ and Modify_Parent_Handling_Unit_Id to support always having location info on all nodes in a structure. 
--  170330  LEPESE  LIM-9464, Added methods Get_Weight_Vol_Convert_Info___ and Convert_Weight_And_Volume___. Called them from Perform_Stock_Operat_Invent___.
--  170330          Added methods Get_Transport_Destination_Site and Convert_Manual_Weight_And_Volu.
--  170328  Chfose  LIM-11173, Added source_ref-parameters to Putaway and new method Src_Ref_Type_To_Order_Type___.
--  170308  DaZase  LIM-9901, Added Get_Trans_Attr_Value_If_Unique and Get_Sum_Trans_Column_Value.
--  170307  Chfose  LIM-8585, Added parameter perform_putaway to Modify_Source_Ref and Clear_Source_Ref to be able to trigger a putaway
--  170307          when a structure is fully disconnected from a source.
--  170228  MaEelk  LIM-10886, Modified Perform_Stock_Operat_Invent___ and called Inv_Part_Stock_Reservation_API.Move_Hu_Res_Wth_Transp_Task
--  170228          to allow moving Handling Units having reserved materials with Transport Task.
--  170220  KHVESE  LIM-8608, Removed ROWNUM limitation from methods Create_Data_Capture_Lov to prevent empty lov and also have correct sorting.
--  170217  DaZase  LIM-2931, Changed view in Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist from HANDLING_UNIT_EXTENDED to HANDLING_UNIT_TAB 
--  170217          since the extended view is not suited anymore as a wadaco process data source due to performance issues.
--  170209  Maeelk  LIM-STRSC-5375, Added default value of has_stock_reservation to Check_Insert___.
--  170208  Chfose  LIM-10633, Added new method Is_In_Transit that checks both Inventory Transit and Order Transit. 
--  170203  KhVeSe  LIM-10240, Added public method Get_Outermost_Units_Only.
--  170202  Jhalse  LIM-10592, Added a check in Handle_Change_Of_Parent___ to consider has_stock_reservation when changing parent.
--  170202  Chfose  LIM-10117, Removed methods Prt_Shp_Labels_Exist_In_Struct, Get_Prnt_Shp_Labels_For_Struct and Is_Connected_To_Shipment_Lines.
--  170111  MaEelk  LIM-10139, Added necessary changes relevant to newly added  pick_list_no and shipment_id columns in Transport_Task_Line_Tab.
--  170105  LEPESE  LIM-10228, Added parameter ignore_this_handling_unit_id_ to methods Get_Operative_Gross_Weight and Get_Operative_Volume.
--  161223  MaEelk  LIM-9196, Moved the call Temporary_Part_Ownership_API.Create_New which had been called from Perform_Stock_Operation___ to Perform_Stock_Operat_Invent___.
--  161223  DaZase  LIM-5062, Changed Has_Children___  to become public method Has_Children so it can be used outside this package.
--  161216  LEPESE  LIM-9401, Moved some validations from Check_Insert___ and Check_Update___ into Check_Common___.
--  161214  RALASE  LIM-9321, Added method Has_Source_Ref_Connected_Child() which checks if there exist any child handling unit that is connected to the same source ref.
--  161125  LEPESE  LIM-9193, modifications in methods called from Handle_Change_Of_Shipment___ to make sure we do not affect closed shipments with recalculations. 
--  161122  Asawlk  LIM-9593, Modified Perform_Stock_Operat_Invent___ by removing the error HURESERVEDMOVE which prevented moving reserved stock and replaced the call
--  161122          Inventory_Part_In_Stock_API.Move_Part with Invent_Part_Quantity_Util_API.Move_Part.
--  161121  UdGnlk  LIM-9811, Modified calls from Handling_Unit_Composition_API.DB_HOMOGENOUS to Handling_Unit_Composition_API.DB_HOMOGENEOUS.
--  161104  MaEelk  LIM-9193, Added Create_Shipment_Hist_Snapshot and Create_History_Snapshot to take a handling unit snapshop to be stored in Handling Unit History.
--  161104          Create_Shipment_Hist_Snapshot would be called when a shipment is going to 'Closed' state.
--  161115  KHVESE  LIM-7621, Added Method Get_Project_Id().
--  161115  RALASE  LIM-9449, Changed Get_Configuration_Id, Get_Part_No, Get_Lot_Batch_No, Get_Serial_No, Get_Eng_Chg_Level and Get_Waiv_Dev_Rej_No
--                            to return a mixed value when there exists more than one kind.  
--  161108  Jhalse  LIM-9188, Modifed Insert___ and Update___ to fetch location_type when updating location_no.
--  161107  Erlise  LIM-2933, Modified overloaded methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist, improved handling of shipment_id_.
--  161104  LEPESE  LIM-9401, Added overloaded methods Get_Operative_Gross_Weight and Get_Operative_Volume having contract, warehouse, bay, row, tier and bin parameters. 
--  161103  DaZase  LIM-7326, Added 6 new default parameters to Modify method.
--  161103  Erlise  LIM-2933, Modified Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist.
--  161102  DaZase  LIM-7326, Added methods Print_Handling_Unit_Label/Print_Hand_Unit_Content_Label.
--  161027  LEPESE  LIM-9401, Added info_ OUT parameter to methods Putaway.
--  161026  LEPESE  LIM-9401, Added overloaded version of Putaway with handling_unit_id_list_ parameter. Added Get_Outermost_Units_Only___.
--  161026  Chfose  LIM-9213, Replaced some calls to Get_Node_And_Descendants with a nested cursor getting the structure to improve performance of "Compiled View"-methods.
--  161025  DaZase  LIM-7326, Added PRINT_CONTENT_LABEL_DB and PRINT_SHIPMENT_LABEL_DB to New_With_Pack_Instr_Settings did some refactoring in that method. 
--  161025          Added these parameters and NO_OF_CONTENT_LABELS and NO_OF_SHIPMENT_LABELS to New(). Added methods Prt_Cnt_Labels_Exist_In_Struct, 
--  161025          Prt_Shp_Labels_Exist_In_Struct, Get_Prnt_Cnt_Labels_For_Struct and Get_Prnt_Shp_Labels_For_Struct. Changed Apply_Pack_Instr_Node_Settings 
--  161025          to support these new print flags.
--  161024  LEPESE  LIM-9401, Added methods Lock_Node_And_Descendants, Raise_Not_In_Stock_Error, Putaway and Lock_By_Keys.
--  161024  DaZase  LIM-7326, Added checks for NO_OF_CONTENT_LABELS and NO_OF_SHIPMENT_LABELS in Check_Insert___ and Check_Update___.
--  161024  LEPESE  LIM-1304, Added methods Lock_Node_And_Descendants___, Raise_Not_In_Stock_Error___, Putaway and Lock_By_Keys.
--  161014  LEPESE  LIM-9313, Added check on NULL variable in Disconnect_Zero_Stock_In_Struc. 
--  161012  UdGnlk  LIM-8759, Modified Check_Insert___() to add values  to PRINT_CONTENT_LABEL_DB, NO_OF_CONTENT_LABELS,
--  161012          PRINT_SHIPMENT_LABEL_DB and NO_OF_SHIPMENT_LABELS coulmns.    
--  161012  RALASE  LIM-8382, Added method Get_Node_And_Desc_By_Sourc_Ref that returns a node structure with nodes connected to a specific source.
--  161011  RALASE  LIM-8498, Added function Get_Total_Source_Ref_Part_Qty that will return the total SOURCE_REF_PART_QTY for a node structure
--  161005  LEPESE  LIM-3531, Changed logic in method Disconnect_Zero_Stock_In_Struc to work bottom-up and only disconnect empty handling units
--  161005          in the same branch of the structure instead of cleaning up the whole structure. Removed method Disconn_Zero_Stock_Children___.
--  161005  RALASE  LIM-8702, Added validation in Check_Insert___ concerning Shop Order, when SOURCE_REF_PART_QTY is changed for a parent handling unit.
--  161004  LEPESE  LIM-8378, Change in Modify_Parent_Handling_Unit_Id to fetch root node for parent and use it in fetching parent_location_no. 
--  160930  SWiclk  Bug 131288, Modified Get_Column_Value_If_Unique(), Create_Data_Capture_Lov() and Record_With_Column_Value_Exist() by removing NVL checks.
--  160930          Added Get_Column_Value_If_Unique(), Create_Data_Capture_Lov() and Record_With_Column_Value_Exist() with parameter shipment_id.
--  160929  NaLrlk  LIM-8899, Modified Perform_Stock_Operation___() to exclude modify_availability_ctrl_id_ for receipt operation.
--  160921  NaSalk  LIM-8708, Get_Node_And_Descendants___ was changed into a public method. Modified Perform_Stock_Operation___ and moved inventory specific operations to 
--  160921          Perform_Stock_Operat_Invent___ and added code to support operations for Arrival and QA locations. Modified Change_Stock_Location methods to add 
--  160921          string_parameter1_ parameter. Private constancts used as stock operations in Perform_Stock_Operation___ were made public.
--  160915  RALASE  LIM-8499, Added method Get_Part_Qty_Onhand and call Get_Part_Qty_Onhand in Update___.
--  160826  MaEelk  LIM-8454, Replaced the method call Get_Part_Stock_Onhand_Content with Get_Part_Stock_Total_Content in Get_Compiled_Part_Stock_Info.
--  160824  THIMLK  LIM-8430, Added Get_Contract_From_Reference___(). Modified Insert___() and Update___() methods to fetch and set the Site on the 
--  160824          Handling Unit when location_no is NULL and source_ref is not null and equal to Shop Order or shipment id is not null. 
--  160823  RaKalk  LIM-7860, Removed Check_Change_Of_Shipment___, Check_Source_Ref___ and moved validation to Check_Common___.
--  160819  RaKalk  LIM-7860, Added method Modify_Source_Ref___ and Modified Undate___ to control adding source ref to child handling units.
--  160818  MaEelk  LIM-7828, Created new record type Compiled_Part_Stock_Rec that could be used to keep compiled values of Part In Stock information 
--  160818          Added method Get_Compiled_Part_Stock_Info 
--  160818  LEpESE  LIM-8377, Modified Get_Node_Level to return NULL for handling_unit_id = 0 and to use level = 1 for the root node instead of 0.
--  160810  LEPESE  LIM-7596, Added methods Set_Stock_Reservation and Clear_Stock_Reservation.
--  160801  KhVese  LIM-7491, Renamed method Get_Below_Top_Handl_Unit_Id to Get_Second_Level_Parent_Hu_Id.
--  160729  Chfose  LIM-7613, Modified 'compiled view'-methods to properly handle and compare NULL values.
--  160728  THIMLK  LIM-7983, Added a new method, Source_Ref_Exists().
--  160725  Chfose  LIM-7613, Added a string value of '...' to the 'compiled view'-methods when there is a mix of values in a handling unit.
--  160722  RaKalk  LIM-7979, Added method Clear_Order_Ref.
--  160721  Rakalk  LIM-7993, Added method Set_Order_Ref.
--  160714  THIMLK  LIM-7862, Modified the method New(), to consider Shop Order keys when saving records from shop order.
--  160707  KhVese  LIM-7491, Added Get_Below_Top_Handl_Unit_Id().
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160603  RoJalk  LIM-7358, Moved Reassign_Handling_Unit method from Shipment_Line_Handl_Unit_API to Reassign_Shipment_Utility_API.
--  160601  LEPESE  LIM-7581, added condition for ROWNUM in Create_Data_Capture_Lov.
--  160526  LEPESE  LIM-7474, Added CONTRACT and LOCATION_NO to the entity. Added methods Set_Stock_Location and Clear_Stock_Location.
--  160524  UdGnlk  LIM-7475, Renamed Print_Transport_Package_Label() to Print_Shpmnt_Hand_Unit_Label() and TRANSPORT_PACKAGE_LABEL_REP to SHPMNT_HANDL_UNIT_LABEL_REP.
--  160524  KhVese  STRSC-2419, Modified method Create_Data_Capture_Lov to add stracture level to the second column of Handling-unit's LOV.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160518  LEPESE  LIM-7363, Modifications in Handle_Change_Of_Parent___ to trigger refresh of handling unit snapshots when parent_handling_unit_id gets modified. 
--  160517  MaEelk  LIM-6922, Added Get_Node_And_Ascendants that would return all parents of handling_unit in the ascending direction. 
--  160517  LEPESE  LIM-7363, Added putaway_event_id_ logic to Scrap, Receive_From_Inventory_Transit and Issue_With_Posting.
--  160512  LEPESE  LIM-7363, added putaway_event_id_ logic to both versions of method Add_To_Transport_Task. Removed shipment_id filter from Get_Location_No.
--  160511  Erlise  LIM-7056, Added Has_Quantity_Reserved___, modified New_Counting_Result.
--  160429  LEPESE  LIM-7154, Added Get_Part_Stock_Total_Content and made use of it in methods for fetching unique part_no, serial_no, lot_batch_no and other attributes from the stock records.
--  160427  MaEelk  LIM-6910, Addec Get_Part_Stock_Transit_Content and Get_Qty_In_Transit to fetch the total qty of parts connected to a HU which is in Transit.
--  160415  Jhalse  LIM-6932, Modified method New, Prepare_Insert___ and Check_Insert___ to fix a bug that was causing different behaviour for creating a handling unit, depending on from where you called it.
--  160412  MaEelk  LIM-6911, Added Get_Condition_Code to return the condition code of a given handling unit if it is unique through the entire structure.
--  160411  DaZase  LIM-5066, Added Get_Transport_Task_Id.
--  160405  KhVese  LIM-3658, Added method Add_To_Transport_Task and an overload of it taking a list of HU id's as a VARCHAR2.
--  160405          Modified method Perform_Stock_Operation___ to call Transport_Task_API.New_Or_Add_To_Existing.
--  160330  MaEelk  LIM-6609, Added Get_Part_No and Get_Configuration_Id methods to return part_no and cofiguration_id of a handling unit if it has a unique value through out the entire structure.
--  160322  Chfose  LIM-6145, Added validation in Get_Qty_Onhand and Get_Qty_Reserved for only calculating a quantity when the handling unit contains one part_no.
--  160315  Chfose  LIM-6145, Added methods Get_Qty_Onhand, Get_Qty_Reserved, Get_Lot_Batch_No, Get_Serial_No, Get_Eng_Chg_Level, Get_Waiv_Dev_Rej_No,
--  160315                    Get_Activity_Seq, Get_Availability_Control_Id, Get_Part_Ownership, Get_Owner, Get_Owner_Name, Get_Earliest_Expiration_Date & Get_Earliest_Receipt_Date.
--  160308  Erlise  LIM-6539, Modified method New_Counting_Result, added overloaded method Has_Stock_Frozen_For_Counting to support count of handling units.
--  160301  LEPESE  LIM-6169  Modified method Get_Part_Stock_Onhand_Content so that it can be called from SQL by removing usage of temporary table.
--  160219  Chfose  LIM-5711, Added method Get_Handling_Unit_Identifiers.
--  160204  Erlise  LIM-5948, Added out parameter to method Perform_Stock_Operation___.
--  160128  Erlise  LIM-4893, Added method Get_Last_Count_Date.
--  160118  Erlise  LIM-4893, Count handling units. Added method New_Counting_Result. Added section to Perform_Stock_Operation.
--  160118  Chfose  LIM-5895, Modified method Modify_Parent_Handling_Unit_Id to hinder changing parent when shipment is in state 'Completed'/'Closed' or 'Cancelled.
--  160114  Chfose  LIM-5883, Renamed all occurences of operational to operative.
--  160114  LEPESE  LIM-3742, added method Get_Node_Level.
--  160113  KhVese  LIM-5873, Modified cursor in method Get_Cust_Own_Stock_Acqui_Value().
--  160111  LEPESE  LIM-3742, added method Get_Part_Stock_Onhand_Content.
--  160107  Chfose  LIM-5407, Added validations for checking if any Handling Unit is in transit in Modify_Parent_Handling_Unit_Id.
--  151222  Chfose  LIM-5631, Added new method Has_Any_Parent_At_Any_Level and new overloaded Modify_Parent_Handling_Unit_Id that takes a list of HU id's.
--  151217  Chfose  LIM-5408, Replaced number_null_ with an empty string in the Removal of Volume/Gross Weight methods in order to properly clear the values.
--  151214  Erlise  LIM-4922, Added method Transfer_To_Project_Inventory and an overload version, accepting a list of HU id's as VARCHAR2.
--                  Modified method Perform_Stock_Operation___ to call Inventory_Part_In_Stock_API.Move_Part_Project.
--  151214  Erlise  LIM-3550, Added method Transfer_To_Standard_Inventory and an overload version, accepting a list of HU id's as VARCHAR2.
--                  Modified method Perform_Stock_Operation___ to call Inventory_Part_In_Stock_API.Move_Part_Project.
--  151210  Chfose  LIM-3538, Removed method Modify_Parent_And_Shipment and added functionality in Modify_Parent_Handling_Unit_Id to support both inventory and shipment.
--  151208  KhVese  LIM-4898, Added sql_where_expression_ parameter to interface of Get_Column_Value_If_Unique() and changed the table to view.
--  151207  LEPESE  LIM-5293, modifications in Validate_Structure_Position to disallowed qty_in_transit and qty_onhand at the same time, same location.
--  151207  KhVese  LIM-4898, Modified cursor in Get_Handling_Unit_From_Alt_Id(). Also renamed methods Get_Value_If_Unique() to Get_Stock_Attr_Value_If_Unique()
--  151207          Get_Total_Quantity_() to Get_Sum_Stock_Column_Value(), Get_Total_Inventory_Value() to Get_Total_Part_In_stock_Value(), Get_Freeze_Flag_Db() 
--  151207          to Has_Stock_Frozen_For_Counting() and Get_Acquisition_Value() to Get_Cust_Own_Stock_Acqui_Value() along with minor logic changes in those methods.
--  151203  Chfose  LIM-4842, ALOT of refactoring and restructuring done aswell as making some methods work for both Inventory and Shipment.
--  151203          Shipment-specific methods have been moved to new HandlingUnitShipUtil in order to keep this file as generic as possible.
--  151203          The interfaces of some public methods have been modified or broken apart, some methods have been split into two and renamed
--  151203          to make the outcome of the method more obvious.
--  151201  KhVese  LIM-2917, Added method Receive_From_Inventory_Transit and an overload of it taking a list of HU id's as a VARCHAR2.
--  151201          Modified method Perform_Stock_Operation___ to call Inventory_Part_In_Stock_API.Receive_Part_From_Transit.
--  151201          Added method Is_In_Inventory_Transit and Is_In_Inventory_Transit___.
--  151201  DaZase  LIM-4851, Added default parameter check_sscc_exist_ to Validate_Sscc().
--  151125  KhVese  LIM-2924, Modified Get_Handling_Unit_From_Alt_Id() to return NULL if too many rows found.
--  151123  KhVese  LIM-2924, renamed Get_Unique_Stock_Part_Value to Get_Value_If_Unique() and the method's logic.
--  151120  Chfose  Added new method Get_Structure_Level.
--  151118  KhVese  LIM-2926, Added methods Get_Acquisition_Value(), Get_Total_Inventory_Value(), Get_Total_Quantity_(), 
--  151118          Get_Unique_Stock_Part_Value() and Get_Freeze_Flag_Db().
--  151118  MaEelk  LIM-3580, Modified Update___ and moved parent chaged and shipment_id changed codes to Handle_Change_Of_Parent___ and Handle_Change_Of_Shipment___ respectively.
--  151112  Chfose  LIM-4595, Added Has_Mixed_Part_Numbers___ and modified Get_Composition to use the new method when handling unit is in inventory.
--  151104  Chfose  LIM-4475, Modified Get_Net_Weight_This_Level___ to be able to get net weight without shipment and
--  151104                    added new methods Get_Max_Volume_Capacity and Get_Max_Weight_Capacity to get hu-type capacity with custom uom.
--  151103  KhVese  LIM-2926, Adde parameter "sql_where_expression_" to method Create_Data_Capture_Lov() and 
--  151103          Record_With_Column_Value_Exist() and also modified the sql statment block to get values from HANDLING_UNIT_EXTENDED view.
--  151026  DaZase  LIM-4297, Renamed method Get_Handling_Unit_From_Atl_Id to Get_Handling_Unit_From_Alt_Id.
--  151015  JeLise  LIM-1026, Added call to Get_Shipment_Contract___ in Get_Contract to fetch the site if the handling unit is connected to a shipment.
--  151013  MaEelk  LIM-3580, Modified Update___ to gatther removing manual weight and volume logic after the base method. 
--  151013          Also gathered the logic related to moving between shipments under one condition.
--  151001  MaEelk  LIM-3579, Removed the usage of Get_Top_Shipment_Id and Get_Root_Shipment_Id. Made changes relevant to the LCS Bug 124141.
--  150925  JeLise  LIM-3669, Renamned Get_Company_For_Uom___ to Get_Company___ and called it from Create_Sscc.
--  150921  Chfose  LIM-3666, Added public methods Get_Contract, Get_Location_No and Has_Quantity_In_Stock.
--  150916  Chfose  LIM-3654, Renamed Get_Default_Uom_For_Length into a public method and moved to be invoked from Check_Insert instead of New.
--  150915  LEPESE  LIM-3652, redesigned Get_Uom_For_Weight and Get_Uom_For_Volume, moved logic to Get_Uom_For_Unit_Type___ and Get_Company_For_Uom___.
--  150911  LEPESE  LIM-3535, added logic in Get_Default_Uom_For_Length___ to fetch company from user default site.
--  150901  MaEelk   Bug 124141, shipment_id was set to be stored in all handling unit levels. Get_Top_Shipment_Id was made obsolete.
--  150827  Chfose  LIM-3595, Added parameter error_when_stock_not_exist_ to Perform_Stock_Operation, Scrap and Issue_With_Posting
--  150827                    and added new overloaded methods for Scrap and Issue_With_Posting to handle a list of handling units.
--  150827  JeLise  LIM-1316, Added method Get_Unique_Part_Ownership_Db, Change_Ownership_Between_Cust and Change_Ownership_To_Company.
--  150824  Chfose  LIM-3592, Added methods Get_Top_Parent_Handl_Unit_Id, Get_Top_Parent_Hu_Type_Id, Get_Top_Parent_Sscc, Get_Top_Parent_Alt_Hu_Label_Id.
--  150630  Chfose  LIM-3532, Added methods Get_Handling_Unit_Id_Tab___, Get_Node_Level_Sorted_Units___, Get_Current_Stock_Location___ and
--  150630          a new overload to the method Change_Stock_Location taking a list of HU id's as a VARCHAR2.
--  150630  Chfose  LIM-3331, Added method Modify_Alt_Handling_Unit_Label_Id.
--  150629  LEPESE  LIM-3513, added method Change_Stock_Location and added call to Inventory_Part_In_Stock_API.Move_Part in Perform_Stock_Operation___ .
--  150626  LEPESE  LIM-3151, renamed Get_Parent___ into Get_Root_Handling_Unit_Id. Renamed Get_Top_Shipment_Id into Get_Root_Shipment_Id. Renamed a lot of
--  150626          and parameters from 'top_xxx' to 'root_xxx'. Added methods Get_Root_Handling_Unit_Type_Id, Get_Root_Sscc and Get_Root_Alt_Transp_Label_Id.
--  150622  LEPESE  LIM3106, added parameter print_serviceability_tag_db_ to method Scrap_Part and passed on to Inventory_Part_In_Stock_API.Scrap_Part.
--  150616  Chfose  LIM-1373, Added new method Is_Connected_To_Shipment_Lines.
--  150615  LEPESE  LIM-3101, added methods Pre_Delete___ and Post_Delete___, made override of both versions of Delete___.
--  150612  LEPESE  LIM-3101, added methods Disconnect_Zero_Stock_In_Struc, Disconn_Zero_Stock_Children___, Has_Quantity_In_Stock___, Get_Children___.
--  150612          Renamed Get_Attach_Hand_Unit_Id_Tab___ to Get_Node_And_Descendants___.
--  150610  LEPESE  LIM-3101, modifications and improvements of method Perform_Stock_Operation___.
--  150605  LEPESE  LIM-3101, added method Issue_With_Posting.
--  150605  LEPESE  LIM-3106, added method Scrap.
--  150604  RILASE   COB-461, Added the possibility to print multiple copies of the transport label in Print_Transport_Package_Label.
--  150603  LEPESE  LIM-3093, added method Modify_Expiration_Date.
--  150602  LEPESE  LIM-3087, added methods Modify_Availability_Control_Id and Perform_Stock_Operation___. Removed Modify_Waiv_Dev_Rej_No___.
--  150601  LEPESE  LIM-3066, added methods Modify_Waiv_Dev_Rej_No___ and Modify_Waiv_Dev_Rej_No.
--  150417  LEPESE  LIM-88, added method Validate_Structure_Position.
--  150415  LEPESE  LIM-88, added methods Is_In_Inventory, Is_At_Customer and Is_In_Transit.
--  150305  RILASE   COB-21, Added Modify_Sscc___, Modify_Alt_Transport_Lbl_Id___,  Print_Transport_Package_Label, Get_Handling_Unit_From_Sscc, Get_Handling_Unit_From_Atl_Id
--  150305           and Modify. Made Validate_Sscc and Check_Structure public. Added the possibility to create SSCC, modify SSCC, modify Alternative Transport Label Id and print
--  150305           Transport Package Label in New_Units.
--  150220  RoJalk   Renamed the method Additive_Volume___ to Volume_Is_Additive___.
--  150218  RoJalk   Added the method Additive_Volume___ and replaced the usages of the logic. Modified Update___ and called Remove_Manual_Volume,
--  150218           Remove_Manu_Shipment_Volume___ when the shipment id is changed in the handling unit level - reassignment.
--  140407  MaEelk   Modified Insert___ and Delete___ methods to remove the shipment manual volume when a top level node is added or deleted.
--  140219  MAHPLK   Added new attribute no_of_handling_unit_labels.  
--  140219           Modified out parameter name handling_unit_list_ of the Get_Print_Label_Handl_Units to handling_unit_info_list_.
--  140213  HimRlk   Added new public column uom_for_length. Added new method Get_Default_Uom_For_Length().
--  130828  MaEelk   Modified Update___ to calculate freight charges when changing either the manual_gross_weight or the manual_volume
--  130828  JeLise   Changed Create_Sscc from implementation method to public method.
--  130823  MaEelk   Added Calculate_Shipment_Charges. This would find all shipment id connected tto a given handling_unit_type_is and calculate freight charges for them.
--  130822  MaEelk   When a change to the handling unit(insert or delete or update) and if it affects the shipment weight and volume,
--  130822           made a call to Calculate_Shipment_Charges___ that would calculete the freight charges of the shipment.
--  130822  JeLise   Added call to Packing_Instruction_Node_API.Get_Flags_For_Node in New to get the correct flags when creating an empty packing instruction.
--  130807  MaEelk   Added condition to check if the volume is not fixed for that hu before calling the method Remove_Manual_Volume
--  130806  MaEelk   Changed the parameter list of Check_Allow_Mix. Replaced the usage of Check_Allow_Move_Handl_Unit___ with Check_Allow_Mix.
--  130806           changed the parameter list of Check_Allow_Mix_Part_No___, Check_Allow_Mix_Lot_Batches___ and Check_Allow_Mix_Cond_Codes___
--  130730  MaEelk   Moved the SSCC validation logic from Shipment_Handling_Utility_API to this package
--  130627  MaEelk   Modified Check_Allow_Move_Handl_Unit___ by passing the handling_unit_id_ to the recursive call Check_Allow_Move_Handl_Unit___
--  130619  MaEelk   Removed the parameter mix_of_blocked_attrib_changed from Check_Allow_Mix. Changed Unpack_Check_Update to validate mix of blocked attributes.
--  130619           Added Get_Attach_Hand_Unit_Id_Tab___ to fetch handdling units connected a given handling unit including that given handling unit
--  130617  MaEelk   Added Check_Allow_Move_Handl_Unit___ and called it from Unpack_check_Update___ 
--  130617           to handle moving a handling unit with mix of blocked attribute validations correctly. 
--  130613  MaEelk   Added a new parameter mix_of_blocked_attrib_changed_ to  Check_Allow_Mix and called it from Unpack_Check_Update___
--  130612  MaEelk   Modified Check_Allow_Mix to trigger validations for lot batches and condition codes. 
--  130610  MeAblk   Added new methods Get_Top_Level_Handl_Unit_Count, Get_Ship_Second_Level_Hu_Count.
--  130607  MaEelk   Added method Check_Allow_Mix. This would make validations over mix of part numbers blocked, Mix of condition codes blocked and mix of lot batches blocked.
--                   Added implementation methods Check_Allow_Mix_Part_No, Check_Allow_Mix_Lot_Batches and Check_Allow_Mix_Cond_Codes in order to support it.
--  130605  RoJalk   Replaced the method Reassign_Structure with Reassign_Shipment_Lines__ and called from Update___
--  130605           so it will be triggered when a shipment id of a handling unit is updated. Added the parameter release_reservations_
--  130605           to the methods Update___, Modify_Parent_And_Shipment, Modify_Shipment_Id to identify if customer order
--  130605           reservations needs to be released during the reassignment of the handling units.  
--  130528  MeAblk   Added new method Get_Shipment_Net_Weight.
--  130528  MeAblk   Added new method Check_Print_Labels and renamed the method Get_All_Sub_Handling_Units into Get_Print_Label_Handl_Units.  
--  130526  MeAblk   Added methods Get_All_Sub_Handling_Units and Get_No_Of_Containers. 
--  130524  JeLise   Added method Check_Exist.
--  130523  MaEelk   Did modifications to Remove_Manual_Volume in order to remove manual volumes when necessary.
--  130521  MeAblk   Removed method Modify.
--  130521  MeAblk   Added new method Create_Sscc___, Connect_Sscc, Check_Exist_For_Sscc.
--  130521  RoJalk   Add the method Reassign_Structure to be used in Reassign Handling Unit functionality in Shipment.
--  130516  JeLise   Changed the in parameters in New, added check on package_instruction_id_ and added call to 
--  130516           Pack_Instr_Node_Accessory_API.Add_Accesories_To_Handl_Unit also added methods Get_No_Of_Connected_Children
--  130516           and Violates_Mix_Of_Combinations.
--  130515  MeAblk   Added new attributes sscc, alt_transport_label_id, new method Modify and validation for the sscc.
--  130507  MaEelk   Added Remove_Manual_Volume to clear the manual volume of the handling unit.
--  130507           Called Remove_Manual_Volume when adding or removing a handling unit. Called Remove_Manual_Volume when moving handling units.
--  130507           Added Remove_Manual_Volume___ to remove manual volume when moving between parents. Introduced additive_volume_ as a parameter to 
--  130507           Create_Dif_Hand_Unit_Id_Tab___ that support all values TRUE, FALSR and NULL values of additive volume. 
--  130429  JeLise   Added method Modify_Parent_Handling_Unit_Id to be able to change parent within the same shipment.
--  130423  MaEelk   Agged Get_Ship_Operational_Volume.
--  130423           it would be calculated as the sum of volume for all the top nodes connected to the shipment
--  130419  MaEelk   Added Get_Operational_Volume and Get_Uom_For_Volume. Get_Operational_Volume would calculate the volume according to the values
--  130419           given for manual_volum and additive vloume of the HU and the additive vloume of the accessories connected to HU.
--  130419           Get_Uom_For_Volume would return the UOM specified for the company connected for a given handling unit id. 
--  130417  JeLise   Added call to Shipment_Line_Handl_Unit_API.Remove_Handling_Unit in Delete___.
--  130416  MaEelk   Modified Modify_Parent_And_Shipment to supprt changing the parent handling unit id and the shipment id in one update.
--  130416           Removed Modify_Parent_Handl_Unit_Id___ and replaced its calling places with Modify_Parent_And_Shipment.
--  130410  MaEelk   Added MANUAL_VOLUME to the Logical Unit.
--  130410  MaEelk   Added boolean parameter also_remove_on_parent_ to Remove_Manual_Gross_Weight. 
--  130410           This would decide if the manual gross weight of the parent handling unit should be removed or not. Called Remove_Manual_Gross_Weight 
--  130410           when adding or deleting a handling unit to a structure. 
--  130410           Modidied Update___ to support moving a handling unit from one shipment to another shipment or within the same shipment. 
--  130327  MeAblk   Added new attributes generate_sscc_no,print_label,mix_of_part_no_blocked,mix_of_lot_batch_blocked,mix_of_cond_code_blocked.
--  130322  MaEelk   Added Remove_Manual_Gross_Weight to remove the manual gross weight of a handling unit in handling_unit_tab.
--  130320  MaEelk   Added Get_Ship_Operat_Gross_Weight to calculated the operational gross weight of top handling units connected to the shipment.
--  130313  MaEelk   Added Get_Shipment_Tare_Weight that would calculate the tare weight of the top handling unit nodes connected to the system.
--  130313  MeAblk   Converted Modify_Shipment_Id___ into a public one.
--  130312  MaEelk   Modified Get_Operational_Gross_Weight and added new parameter include_adjusted_weight_ 
--  130312           to support the calculation of adjusted operational gross weight.
--  130311  MaEelk   Added parameter apply_freight_factor_ to Get_Net_Weight. This would make the method reusable in Adjusted Net weight Calculation.
--  130311  MaEelk   Renamed GROSS_WEIGHT as MANUAL_GROSS_WEIGHT.Renamed Get_Gross_Weight_Method as Get_Operational_Gross_Weight.
--  130311  MaEelk   Changed Get_Operational_Gross_Weight to a more simple code segment.
--  130308  MeAblk   Converted the method New___ into public method New.
--  130306  MaEelk   Added ORDER BY clause to the cursor get_handling_units in Get_Gross_Weight 
--  130306           to stop go in an endless recursive loop in some instances.
--  130227  MaEelk   Added attribute GROSS_WEIGHT and calculated operational gross weight using Get_Gross_Weight_Method
--  130223  MeAblk   Added new methods New and Modify_Shipment_Id.
--  130121  MaEelk   Added Get_Tare_Weight to calculate the weight of all materials and accessories connected to a handling unit.
--  130219  MaEelk   Added Get_Net_Weight to calculate the net weight of all parts connected to a handling unit structure.
--  130214  MaEelk   Added Get_Composition to dervive the composition of the handling unit.
--  130207  MaEelk   Added public attributes width , Height and Weight to the LU. Add function Get_Uom_For_Length
--  121109  JeLise   Created
-----------------------------------------------------------------------------

layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Handling_Unit_Id_Rec IS RECORD (
   handling_unit_id handling_unit_tab.handling_unit_id%TYPE );

TYPE Handling_Unit_Id_Tab IS TABLE OF Handling_Unit_Id_Rec INDEX BY PLS_INTEGER;

TYPE Attribute_Name_Tab IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;

TYPE Compiled_Part_Stock_Rec IS RECORD
   (part_no                     inventory_part_in_stock_tab.part_no%TYPE,
   configuration_id             inventory_part_in_stock_tab.configuration_id%TYPE,
   lot_batch_no                 inventory_part_in_stock_tab.lot_batch_no%TYPE,
   serial_no                    inventory_part_in_stock_tab.serial_no%TYPE,
   eng_chg_level                inventory_part_in_stock_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no              inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE,
   activity_seq                 inventory_part_in_stock_tab.activity_seq%TYPE,  
   qty_onhand                   inventory_part_in_stock_tab.qty_onhand%TYPE,
   catch_qty_onhand             inventory_part_in_stock_tab.catch_qty_onhand%TYPE,
   qty_in_transit               inventory_part_in_stock_tab.qty_in_transit%TYPE,
   catch_qty_in_transit         inventory_part_in_stock_tab.catch_qty_in_transit%TYPE,   
   rotable_part_pool_id         inventory_part_in_stock_tab.rotable_part_pool_id%TYPE, 
   last_activity_date           inventory_part_in_stock_tab.last_activity_date%TYPE,
   receipt_date                 inventory_part_in_stock_tab.receipt_date%TYPE,
   last_count_date              inventory_part_in_stock_tab.last_count_date%TYPE,
   expiration_date              inventory_part_in_stock_tab.expiration_date%TYPE,
   availability_control_id      inventory_part_in_stock_tab.availability_control_id%TYPE,   
   part_ownership               inventory_part_in_stock_tab.part_ownership%TYPE,
   owner                        inventory_part_in_stock_tab.owning_customer_no%TYPE,
   owner_name                   VARCHAR2(100),
   project_id                   inventory_part_in_stock_tab.project_id%TYPE,  
   condition_code               VARCHAR2(10),
   inventory_uom                VARCHAR2(30),
   catch_uom                    VARCHAR2(30),
   unified_uom                  VARCHAR2(30),
   unified_catch_uom            VARCHAR2(30),   
   gtin_no                      VARCHAR2(14),
   hazard_code                  VARCHAR2(6),    
   unified_qty_onhand           inventory_part_in_stock_tab.qty_onhand%TYPE,
   unified_catch_qty_onhand     inventory_part_in_stock_tab.catch_qty_onhand%TYPE,
   unified_qty_in_transit       inventory_part_in_stock_tab.qty_in_transit%TYPE,
   unified_catch_qty_in_transit inventory_part_in_stock_tab.catch_qty_in_transit%TYPE,
   total_inventory_value        NUMBER,
   part_acquisition_value       NUMBER,
   total_acquisition_value      NUMBER);

modify_waiv_dev_rej_no_       CONSTANT NUMBER := 1;
modify_availability_ctrl_id_  CONSTANT NUMBER := 2;
modify_expiration_date_       CONSTANT NUMBER := 3;
scrap_                        CONSTANT NUMBER := 4;
issue_with_posting_           CONSTANT NUMBER := 5;
change_stock_location_        CONSTANT NUMBER := 6;
change_ownership_btwn_cust_   CONSTANT NUMBER := 7;
change_ownership_to_company_  CONSTANT NUMBER := 8;
receive_from_invent_transit_  CONSTANT NUMBER := 9;
transfer_to_proj_inventory_   CONSTANT NUMBER := 10;
transfer_to_std_inventory_    CONSTANT NUMBER := 11;
report_counting_result_       CONSTANT NUMBER := 12;

mixed_value_ CONSTANT VARCHAR2(3)  := '...';

TYPE handling_unit_details_rec   IS RECORD (
   hu_type_id                  handling_unit_tab.handling_unit_type_id%TYPE,
   hu_type_desc                HANDLING_UNIT_TYPE_TAB.description%TYPE,
   sscc                        handling_unit_tab.sscc%TYPE,
   alt_hu_label_id             handling_unit_tab.alt_handling_unit_label_id%TYPE,
   top_parent_hu_id            handling_unit_tab.handling_unit_id%TYPE,
   top_parent_hu_type_id       handling_unit_tab.handling_unit_type_id%TYPE,
   top_parent_hu_type_desc     HANDLING_UNIT_TYPE_TAB.description%TYPE,
   top_parent_sscc             handling_unit_tab.sscc%TYPE,
   top_parent_alt_hu_label_id  handling_unit_tab.alt_handling_unit_label_id%TYPE,
   level2_hu_id                handling_unit_tab.handling_unit_id%TYPE,
   level2_sscc                 handling_unit_tab.sscc%TYPE,
   level2_alt_hu_label_id      handling_unit_tab.alt_handling_unit_label_id%TYPE);

TYPE handling_unit_details_arr IS TABLE OF handling_unit_details_rec;

TYPE Public_Tab                IS TABLE OF Public_Rec INDEX BY VARCHAR2(20);

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;
number_null_ CONSTANT NUMBER       := -9999999999;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Handling_Unit_Id___ RETURN NUMBER
IS
   temp_ NUMBER;

   CURSOR get_next_id IS
      SELECT handling_unit_seq.nextval
      FROM dual;
BEGIN
   OPEN get_next_id;
   FETCH get_next_id INTO temp_;
   CLOSE get_next_id;
   RETURN temp_;
END Get_Next_Handling_Unit_Id___;


PROCEDURE Get_Net_Weight_This_Level___ (
   net_weight_          OUT NUMBER,
   adj_net_weight_      OUT NUMBER,
   handling_unit_id_     IN NUMBER,
   uom_for_weight_       IN VARCHAR2 )
IS
   shipment_id_     NUMBER;
   
   CURSOR get_inv_parts_this_level IS
      SELECT SUM(qty_onhand + qty_in_transit) quantity, contract, part_no
        FROM INVENTORY_PART_IN_STOCK_TAB
       WHERE handling_unit_id = handling_unit_id_
         AND qty_onhand + qty_in_transit > 0
       GROUP BY part_no, contract;
       
   inv_part_weight_         NUMBER := 0;
   comp_uom_for_weight_     VARCHAR2(30);  
BEGIN
   shipment_id_ := Get_Shipment_Id(handling_unit_id_);
   IF (shipment_id_ IS NOT NULL) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         Shipment_Line_Handl_Unit_API.Get_Connected_Part_Weight(net_weight_         => net_weight_, 
                                                                adj_net_weight_     => adj_net_weight_, 
                                                                shipment_id_        => shipment_id_, 
                                                                handling_unit_id_   => handling_unit_id_, 
                                                                uom_for_weight_     => uom_for_weight_);
      $ELSE
         NULL;
      $END
   ELSE
      net_weight_      := 0;
      adj_net_weight_  := 0;
   
      FOR rec_ IN get_inv_parts_this_level LOOP
         inv_part_weight_ := inv_part_weight_ + (rec_.quantity * NVL(Inventory_Part_API.Get_Weight_Net(contract_    => rec_.contract, 
                                                                                                       part_no_     => rec_.part_no), 0));
      END LOOP;
      
      IF (inv_part_weight_ > 0) THEN
         comp_uom_for_weight_ := Company_Invent_Info_API.Get_Uom_For_Weight(Get_Company___(handling_unit_id_));
         IF (uom_for_weight_ != comp_uom_for_weight_) THEN
            inv_part_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => inv_part_weight_, 
                                                                         from_unit_code_   => comp_uom_for_weight_, 
                                                                         to_unit_code_     => uom_for_weight_);
         END IF;
         
         net_weight_     := net_weight_ + inv_part_weight_;
         adj_net_weight_ := net_weight_;
      END IF;
   END IF;
END Get_Net_Weight_This_Level___;


FUNCTION Get_Hu_Type_Tare_Weight___ (
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2 ) RETURN NUMBER
IS
   handling_unit_type_id_   handling_unit_tab.handling_unit_type_ID%TYPE;
   handling_unit_type_rec_  Handling_Unit_Type_API.Public_Rec;  
   tare_weight_             NUMBER := 0;
BEGIN
   handling_unit_type_id_  := Get_Handling_Unit_Type_Id(handling_unit_id_);
   handling_unit_type_rec_ := Handling_Unit_Type_API.Get(handling_unit_type_id_);
   
   IF (handling_unit_type_rec_.tare_weight IS NOT NULL) THEN
      IF (uom_for_weight_ != handling_unit_type_rec_.uom_for_weight) THEN
         tare_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_   => handling_unit_type_rec_.tare_weight,
                                                                  from_unit_code_  => handling_unit_type_rec_.uom_for_weight,
                                                                  to_unit_code_    => uom_for_weight_);
      ELSE
         tare_weight_ := handling_unit_type_rec_.tare_weight;
      END IF;
   END IF;
   
   RETURN tare_weight_;
END Get_Hu_Type_Tare_Weight___;


FUNCTION Get_Tare_Weight_This_Level___ (
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2 ) RETURN NUMBER
IS
   hu_manual_tare_weight_   NUMBER;
   hu_type_tare_weight_     NUMBER := 0;
   tare_weight_this_level_  NUMBER;
BEGIN
   hu_manual_tare_weight_ := Get_Manual_Tare_Weight(handling_unit_id_);
   IF (hu_manual_tare_weight_ IS NULL) THEN
      -- Get the tare weight of the handling unit itself
      hu_type_tare_weight_    := Get_Hu_Type_Tare_Weight___(handling_unit_id_, uom_for_weight_);
      -- Add the tare weight of all the accessories
      tare_weight_this_level_ := hu_type_tare_weight_ + Accessory_On_Handling_Unit_API.Get_Connected_Accessory_Weight(handling_unit_id_   => handling_unit_id_,
                                                                                                                      uom_for_weight_     => uom_for_weight_);
   ELSE
      tare_weight_this_level_ := hu_manual_tare_weight_;
   END IF;
   RETURN tare_weight_this_level_;
END Get_Tare_Weight_This_Level___;


PROCEDURE Get_Net_And_Adjusted_Weight___ (
   net_weight_          OUT NUMBER,
   adj_net_weight_      OUT NUMBER,
   handling_unit_id_    IN  NUMBER,
   uom_for_weight_      IN VARCHAR2 )
IS
   CURSOR get_all_nodes IS
      SELECT handling_unit_id
        FROM handling_unit_tab
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;
       
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
   temp_net_weight_         NUMBER;
   temp_adj_net_weight_     NUMBER;
BEGIN
   net_weight_      := 0;
   adj_net_weight_  := 0;
   
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes;
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
         Get_Net_Weight_This_Level___(net_weight_       => temp_net_weight_,
                                      adj_net_weight_   => temp_adj_net_weight_,
                                      handling_unit_id_ => handling_unit_id_tab_(i).handling_unit_id,
                                      uom_for_weight_   => uom_for_weight_);
                                      
         net_weight_     := net_weight_ + temp_net_weight_;
         adj_net_weight_ := adj_net_weight_ + temp_adj_net_weight_;
      END LOOP;
   END IF;
END Get_Net_And_Adjusted_Weight___;


FUNCTION Get_Part_Volume_This_Level___ (
   handling_unit_id_    IN NUMBER,
   uom_for_volume_      IN VARCHAR2 ) RETURN NUMBER
IS  
   CURSOR get_inv_parts_this_level IS
      SELECT SUM(qty_onhand + qty_in_transit) quantity, contract, part_no
        FROM INVENTORY_PART_IN_STOCK_TAB
       WHERE handling_unit_id = handling_unit_id_
         AND qty_onhand + qty_in_transit > 0
    GROUP BY part_no, contract;
    
    part_volume_                NUMBER := 0;
    company_uom_for_volume_     VARCHAR2(30);
BEGIN
   FOR rec_ IN get_inv_parts_this_level LOOP
      part_volume_ := part_volume_ + (rec_.quantity * NVL(Inventory_Part_API.Get_Volume_Net(rec_.contract, rec_.part_no), 0));
   END LOOP;
   
   IF (part_volume_ > 0) THEN
      company_uom_for_volume_ := Company_Invent_Info_API.Get_Uom_For_Volume(Get_Company___(handling_unit_id_));
      IF (company_uom_for_volume_ != uom_for_volume_) THEN
         part_volume_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => part_volume_,
                                                                  from_unit_code_   => company_uom_for_volume_,
                                                                  to_unit_code_     => uom_for_volume_);
      END IF;
   END IF;
   
   RETURN part_volume_;
END Get_Part_Volume_This_Level___;


PROCEDURE Check_Length___ (
   length_ IN NUMBER )
IS
BEGIN
   IF (NVL(length_, 1) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'LENGTH: Negative length measures cannot be handled.');
   END IF;
END Check_Length___;


PROCEDURE Check_Uom_For_Length___ (
   uom_for_length_ IN VARCHAR2 )
IS
BEGIN
   IF (Iso_Unit_Type_API.Encode(ISO_UNIT_API.Get_Unit_Type(uom_for_length_)) != 'LENGTH') THEN
      Error_SYS.Record_General(lu_name_, 'UOMNOTLENTYPE: Field UoM for Length requires a unit of measure of type Length.');
   END IF;
END Check_Uom_For_Length___;


FUNCTION Get_Parent_Hand_Unit_Id_Tab___ (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
   CURSOR get_all_nodes(parent_handling_unit_id_ NUMBER) IS  
      SELECT handling_unit_id
      FROM handling_unit_tab
           CONNECT BY handling_unit_id = PRIOR parent_handling_unit_id
           START WITH handling_unit_id = parent_handling_unit_id_;   
   
   parent_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
   parent_hand_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN   
   parent_handling_unit_id_ := Get_Parent_Handling_Unit_Id(handling_unit_id_);
   OPEN get_all_nodes(parent_handling_unit_id_);
   FETCH get_all_nodes BULK COLLECT INTO parent_hand_unit_id_tab_;
   CLOSE get_all_nodes;
      
   RETURN parent_hand_unit_id_tab_;
END Get_Parent_Hand_Unit_Id_Tab___;


FUNCTION Create_Dif_Hand_Unit_Id_Tab___ (
   old_handl_unit_id_tab_ IN Handling_Unit_Id_Tab,
   new_handl_unit_id_tab_ IN Handling_Unit_Id_Tab,
   additive_volume_       IN VARCHAR2 DEFAULT NULL ) RETURN Handling_Unit_Id_Tab
IS
   missing_in_old_tab_   BOOLEAN;
   missing_in_new_tab_   BOOLEAN;   
   index_                PLS_INTEGER := 1; 
   dif_hand_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   IF (old_handl_unit_id_tab_.COUNT > 0) THEN
      FOR i IN old_handl_unit_id_tab_.FIRST..old_handl_unit_id_tab_.LAST LOOP
         IF ((additive_volume_ IS NOT NULL) AND
             (NOT(Volume_Is_Additive___(old_handl_unit_id_tab_(i).handling_unit_id)))) THEN
            EXIT;
         END IF;            
         missing_in_new_tab_ := TRUE;
         IF (new_handl_unit_id_tab_.COUNT > 0) THEN        
            FOR j IN new_handl_unit_id_tab_.FIRST..new_handl_unit_id_tab_.LAST LOOP
               IF (old_handl_unit_id_tab_(i).handling_unit_id = new_handl_unit_id_tab_(j).handling_unit_id) THEN
                  missing_in_new_tab_ := FALSE;
               END IF;                 
            END LOOP;
         END IF;
         IF (missing_in_new_tab_) THEN
            dif_hand_unit_id_tab_(index_) := old_handl_unit_id_tab_(i);
            index_ := index_ + 1;
         END IF;            
      END LOOP;
   END IF;
   IF (new_handl_unit_id_tab_.COUNT > 0) THEN
      FOR i IN new_handl_unit_id_tab_.FIRST..new_handl_unit_id_tab_.LAST LOOP
         IF ((additive_volume_ IS NOT NULL) AND 
             (NOT(Volume_Is_Additive___(new_handl_unit_id_tab_(i).handling_unit_id)))) THEN
            EXIT;
         END IF;          
         missing_in_old_tab_ := TRUE;
         IF (old_handl_unit_id_tab_.COUNT > 0) THEN        
            FOR j IN old_handl_unit_id_tab_.FIRST..old_handl_unit_id_tab_.LAST LOOP
               IF (new_handl_unit_id_tab_(i).handling_unit_id = old_handl_unit_id_tab_(j).handling_unit_id) THEN
                  missing_in_old_tab_ := FALSE;
               END IF;                 
            END LOOP;
         END IF;
         IF (missing_in_old_tab_) THEN
            dif_hand_unit_id_tab_(index_) := new_handl_unit_id_tab_(i);
            index_ := index_ + 1;
         END IF;            
      END LOOP;
   END IF;   
   RETURN dif_hand_unit_id_tab_;
END Create_Dif_Hand_Unit_Id_Tab___;


PROCEDURE Clear_Manual_Weight_Volume___ (
   old_handl_unit_id_tab_ IN Handling_Unit_Id_Tab,
   new_handl_unit_id_tab_ IN Handling_Unit_Id_Tab )
IS
   dif_hand_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   dif_hand_unit_id_tab_ := Create_Dif_Hand_Unit_Id_Tab___(old_handl_unit_id_tab_,
                                                           new_handl_unit_id_tab_);
   IF (dif_hand_unit_id_tab_.COUNT > 0) THEN
      FOR i IN dif_hand_unit_id_tab_.FIRST..dif_hand_unit_id_tab_.LAST LOOP
         Clear_Manual_Weight_And_Volume(dif_hand_unit_id_tab_(i).handling_unit_id, FALSE);
      END LOOP;
   END IF;
END Clear_Manual_Weight_Volume___;


PROCEDURE Remove_Manual_Ship_Weight___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   IF (shipment_id_ IS NOT NULL) THEN
      IF NOT (Shipment_Is_Delivered___(shipment_id_)) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            Shipment_API.Remove_Manual_Gross_Weight(shipment_id_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END       
      END IF;
   END IF;      
END Remove_Manual_Ship_Weight___;

   
PROCEDURE Remove_Manual_Ship_Volume___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   IF (shipment_id_ IS NOT NULL) THEN
      IF NOT (Shipment_Is_Delivered___(shipment_id_)) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            Shipment_API.Remove_Manual_Volume(shipment_id_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END       
      END IF;
   END IF;
END Remove_Manual_Ship_Volume___;


FUNCTION Shipment_Is_Delivered___ (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   shipment_is_delivered_ BOOLEAN := FALSE;
BEGIN
   IF (shipment_id_ IS NOT NULL) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         IF (Shipment_API.All_Lines_Delivered__(shipment_id_) = 1) THEN
            shipment_is_delivered_ := TRUE;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('SHPMNT');
      $END       
   END IF;      
   RETURN (shipment_is_delivered_);
END Shipment_Is_Delivered___;

-- Reassign_Shipment_Lines___
--   This method is used by Reassign Handling Unit functionality in Shipment.
--   Reassign the connected HU structure and connected shipmnet lines to a new
--   or existing shipment.
PROCEDURE Reassign_Shipment_Lines___ (
   handling_unit_id_     IN NUMBER,  
   from_shipment_id_     IN NUMBER,
   to_shipment_id_       IN NUMBER,
   release_reservations_ IN BOOLEAN )
IS
   handling_unit_tab_ Handling_Unit_Id_Tab;
   exit_procedure_    EXCEPTION;
BEGIN
   IF (from_shipment_id_ IS NOT NULL) THEN
      IF (Shipment_Is_Delivered___(from_shipment_id_)) THEN
         RAISE exit_procedure_;
      END IF;
   END IF;
   IF (to_shipment_id_ IS NOT NULL) THEN
      IF (Shipment_Is_Delivered___(to_shipment_id_)) THEN
         RAISE exit_procedure_;
      END IF;
   END IF;

   handling_unit_tab_ := Get_Children___(handling_unit_id_);

   IF (handling_unit_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
         Reassign_Shipment_Lines___(handling_unit_tab_(i).handling_unit_id, from_shipment_id_, to_shipment_id_, release_reservations_);
      END LOOP;
   END IF;
   
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      IF (to_shipment_id_ IS NULL) THEN
         Shipment_Line_Handl_Unit_API.Remove_Handling_Unit(from_shipment_id_, handling_unit_id_);
      ELSE
            Reassign_Shipment_Utility_API.Reassign_Handling_Unit(from_shipment_id_, to_shipment_id_, handling_unit_id_, release_reservations_ );
      END IF;
   $ELSE
      Error_SYS.Component_Not_Exist('SHPMNT');
   $END
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Reassign_Shipment_Lines___;


PROCEDURE Check_Allow_Mix_Part_No___ (
   handling_unit_id_tab_   IN Handling_Unit_Id_Tab, 
   mix_of_part_no_blocked_ IN BOOLEAN )
IS
   mixed_part_numbers_     BOOLEAN := FALSE;    
   handling_unit_type_id_  handling_unit_tab.handling_unit_type_id%TYPE;
BEGIN
   mixed_part_numbers_ := Has_Mixed_Part_Numbers___(handling_unit_id_tab_);
   
   IF (mixed_part_numbers_) THEN
      handling_unit_type_id_ := Get_Handling_Unit_Type_Id( handling_unit_id_tab_(1).handling_unit_id);
      IF (mix_of_part_no_blocked_) THEN 
         Error_Sys.Record_General(lu_name_, 'UPDATEMIXPARTBLOCKED: It is not possible to set mix of parts is blocked on handling unit :P1 of type :P2 - :P3 as the content of the handling unit violates that rule.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));   
      ELSE         
         Error_Sys.Record_General(lu_name_, 'MIXPARTBLOCKED: The mix of parts is blocked on handling unit :P1 of type :P2 - :P3.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));   
      END IF;   
   END IF;          
END Check_Allow_Mix_Part_No___;


PROCEDURE Check_Allow_Mix_Lot_Batches___ (
   handling_unit_id_tab_     IN Handling_Unit_Id_Tab,
   mix_of_lot_batch_blocked_ IN BOOLEAN )
IS
   mixed_lot_batches_      BOOLEAN := FALSE;    
   handling_unit_type_id_  handling_unit_tab.handling_unit_type_id%TYPE;
BEGIN
   mixed_lot_batches_ := Has_Mixed_Lot_Batches___(handling_unit_id_tab_);
   
   IF (mixed_lot_batches_) THEN
      handling_unit_type_id_ := Get_Handling_Unit_Type_Id(handling_unit_id_tab_(1).handling_unit_id);
      IF (mix_of_lot_batch_blocked_) THEN
         Error_Sys.Record_General(lu_name_, 'UPDATEMIXLOTBATBLOCK: It is not possible to set mix of lot batches is blocked on handling unit :P1 of type :P2 - :P3 as the content of the handling unit violates that rule.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));    
      ELSE   
         Error_Sys.Record_General(lu_name_, 'MIXLOTBATCHBLOCKED: The mix of lot batches is blocked on handling unit :P1 of type :P2 - :P3.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));   
      END IF;   
   END IF;          
END Check_Allow_Mix_Lot_Batches___;


PROCEDURE Check_Allow_Mix_Cond_Codes___ (
   handling_unit_id_tab_     IN Handling_Unit_Id_Tab,
   mix_of_cond_code_blocked_ IN BOOLEAN )
IS
   mixed_cond_codes_       BOOLEAN := FALSE;    
   handling_unit_type_id_  handling_unit_tab.handling_unit_type_id%TYPE;
BEGIN
   mixed_cond_codes_ := Has_Mixed_Cond_Codes___(handling_unit_id_tab_);
   
   IF (mixed_cond_codes_) THEN
      handling_unit_type_id_ := Get_Handling_Unit_Type_Id(handling_unit_id_tab_(1).handling_unit_id);
      IF (mix_of_cond_code_blocked_) THEN
         Error_Sys.Record_General(lu_name_, 'UPDATEMIXCONCODBLOCK: It is not possible to set mix of condition codes is blocked on handling unit :P1 of type :P2 - :P3 as the content of the handling unit violates that rule.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));
      ELSE   
         Error_Sys.Record_General(lu_name_, 'MIXCONDCODEBLOCKED: The mix of condition codes is blocked on handling unit :P1 of type :P2 - :P3.', 
                                  handling_unit_id_tab_(1).handling_unit_id, handling_unit_type_id_, Handling_Unit_Type_API.Get_Description(handling_unit_type_id_));   
      END IF;   
   END IF;          
END Check_Allow_Mix_Cond_Codes___;

-- Is_Number___
--   Method checkes whether the passes string is a numeric value.
--   Returns TRUE if it is a numeric value, FALSE otherwise.
FUNCTION Is_Number___ (
   string_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   c_ NUMBER;
BEGIN
   FOR i_ IN 1..LENGTH( string_ ) LOOP
      c_ := ASCII( SUBSTR( string_, i_, 1 ) );
      IF ( c_ < ASCII( '0' ) OR c_ > ASCII( '9' ) ) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Number___;


FUNCTION Sscc_Exist___ (
   sscc_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_ BOOLEAN := FALSE;
   dummy_ NUMBER;

   CURSOR get_sscc IS
      SELECT 1
      FROM handling_unit_tab
      WHERE sscc = sscc_;
BEGIN
   OPEN get_sscc;
   FETCH get_sscc INTO dummy_;
   IF (get_sscc%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE get_sscc;
   RETURN exist_;
END Sscc_Exist___;


-- Volume_Is_Additive___
--   When this method returns true it means that any handling unit that is connected as a child to
--   this handling unit will add to the volume of this Handling Unit. Typical example is pallets. 
--   If a box is placed on the pallet is adds to the volume of the pallet.   
FUNCTION Volume_Is_Additive___ (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   exist_ BOOLEAN := FALSE;
BEGIN
   IF ((Handling_Unit_Type_API.Get_Additive_Volume_Db(Get_Handling_Unit_Type_Id(handling_unit_id_)) = Fnd_Boolean_API.DB_TRUE) AND
       (NOT(Accessory_On_Handling_Unit_API.Contains_Additive_Volume(handling_unit_id_)))) THEN
      exist_ := TRUE;          
   END IF;
   RETURN exist_;
END Volume_Is_Additive___;


-- Calculate_Shipment_Charges___
--   This method will calculate the shipment freight charges if any change that affects the weight and volume of the shipment is occurred.
PROCEDURE Calculate_Shipment_Charges___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   IF (shipment_id_ IS NOT NULL) THEN
      IF NOT (Shipment_Is_Delivered___(shipment_id_)) THEN
         $IF (Component_Order_SYS.INSTALLED) $THEN
            Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_, NULL, NULL, NULL, NULL, 1);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      END IF;
   END IF;
END Calculate_Shipment_Charges___;


PROCEDURE Handle_Change_Of_Parent___ (
   oldrec_                       IN handling_unit_tab%ROWTYPE, 
   newrec_                       IN handling_unit_tab%ROWTYPE, 
   old_parent_handl_unit_id_tab_ IN Handling_Unit_Id_Tab,
   moved_between_parents_        IN BOOLEAN,
   old_root_handling_unit_id_    IN handling_unit_tab.handling_unit_id%TYPE)
IS
   new_parent_handl_unit_id_tab_  Handling_Unit_Id_Tab;
   new_root_handling_unit_id_     handling_unit_tab.handling_unit_id%TYPE;
   new_parent_rec_                handling_unit_tab%ROWTYPE;
BEGIN
   new_root_handling_unit_id_ := Get_Root_Handling_Unit_Id(newrec_.handling_unit_id);

   IF (oldrec_.parent_handling_unit_id IS NULL) THEN
      IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
         Check_Allow_Mix(new_root_handling_unit_id_);
         Clear_Manual_Weight_And_Volume(newrec_.parent_handling_unit_id);
         IF NOT (Volume_Is_Additive___(newrec_.parent_handling_unit_id)) THEN
            Remove_Manual_Ship_Volume___(oldrec_.shipment_id);
         END IF;
      END IF;
   ELSE
      IF (newrec_.parent_handling_unit_id IS NULL) THEN
         Clear_Manual_Weight_And_Volume(oldrec_.parent_handling_unit_id);
         IF NOT (Volume_Is_Additive___(oldrec_.parent_handling_unit_id)) THEN
            Remove_Manual_Ship_Volume___(newrec_.shipment_id);        
         END IF;
      ELSIF (moved_between_parents_) THEN
         Check_Allow_Mix(new_root_handling_unit_id_);
         new_parent_handl_unit_id_tab_ := Get_Parent_Hand_Unit_Id_Tab___(newrec_.handling_unit_id); 
         Clear_Manual_Weight_Volume___(old_parent_handl_unit_id_tab_,
                                       new_parent_handl_unit_id_tab_);
      END IF;         
   END IF;

   --------- Refresh of Handling Unit Snapshots Start ----------
   Inventory_Event_Manager_API.Start_Session;
   
   Handling_Unit_For_Refresh_API.New(old_root_handling_unit_id_);
   Handling_Unit_For_Refresh_API.New(new_root_handling_unit_id_);

   Inventory_Event_Manager_API.Finish_Session;
   --------- Refresh of Handling Unit Snapshots End ----------

   --------- Refresh of Stock Location Information Start ----------
   IF (oldrec_.parent_handling_unit_id IS NOT NULL) THEN
      -- Old parent disconnected
      IF (oldrec_.location_no IS NOT NULL) THEN
         -- This HU was in stock, so investigate and clear stock location info on old parent
         Clear_Stock_Location(oldrec_.parent_handling_unit_id);
         IF (newrec_.parent_handling_unit_id IS NULL) THEN
            -- If This HU does not have any stock connection after having been disconnected from its parent then clear the location info
            Clear_Stock_Location(oldrec_.handling_unit_id);
         END IF;
      END IF;
      IF(NOT Has_Quantity_Reserved___(oldrec_.parent_handling_unit_id)) THEN
         Clear_Stock_Reservation(oldrec_.parent_handling_unit_id);
      END IF;
   END IF;

   IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
      -- New parent connected
      IF ((newrec_.location_no IS NULL) OR (NOT Has_Quantity_In_Stock___(newrec_.handling_unit_id))) THEN
         new_parent_rec_ := Get_Object_By_Keys___(newrec_.parent_handling_unit_id);
         IF (new_parent_rec_.location_no IS NOT NULL) THEN
            -- The new parent of this HU is in stock, so set stock location info from new parent
            Set_Stock_Location(newrec_.handling_unit_id, new_parent_rec_.contract, new_parent_rec_.location_no);
         END IF;
      ELSE
         -- This HU is in stock, so set stock location info on new parent
         Set_Stock_Location(newrec_.parent_handling_unit_id, newrec_.contract, newrec_.location_no);
      END IF;
      IF(newrec_.has_stock_reservation = Fnd_Boolean_API.DB_TRUE) THEN
         Set_Stock_Reservation(newrec_.parent_handling_unit_id);
      END IF;
   END IF;
   --------- Refresh of Stock Location Information End ----------
   
END Handle_Change_Of_Parent___;

   
PROCEDURE Handle_Change_Of_Shipment___ (
   oldrec_               IN handling_unit_tab%ROWTYPE, 
   newrec_               IN handling_unit_tab%ROWTYPE, 
   release_reservations_ IN BOOLEAN)
IS
   CURSOR get_children IS
      SELECT *
      FROM handling_unit_tab
      WHERE parent_handling_unit_id = newrec_.handling_unit_id
      FOR UPDATE;   
BEGIN
      Remove_Manual_Ship_Weight___(oldrec_.shipment_id);
      Remove_Manual_Ship_Weight___(newrec_.shipment_id);
      IF (oldrec_.parent_handling_unit_id IS NULL) THEN 
         -- remove manual volume from the source shipmnet
         Remove_Manual_Ship_Volume___(oldrec_.shipment_id); 
      END IF; 
      
      Remove_Manual_Ship_Volume___(newrec_.shipment_id);
      
      Reassign_Shipment_Lines___(newrec_.handling_unit_id, 
                                 oldrec_.shipment_id, 
                                 newrec_.shipment_id, 
                                 release_reservations_);
      Calculate_Shipment_Charges___(oldrec_.shipment_id);
      Calculate_Shipment_Charges___(newrec_.shipment_id);
   
      FOR childrec_ IN get_children LOOP 
         childrec_.shipment_id := newrec_.shipment_id;
         Modify___(childrec_);
      END LOOP;
END Handle_Change_Of_Shipment___;
   
   
PROCEDURE Handle_Shipment_On_Update___ (
   shipment_id_                     IN NUMBER, 
   sscc_is_changed_                 IN BOOLEAN,
   alt_hu_unit_label_id_is_changed_ IN BOOLEAN,
   manual_gross_weight_is_changed_  IN BOOLEAN,
   manual_volume_is_changed_        IN BOOLEAN,
   shipment_is_changed_             IN BOOLEAN,
   parent_is_changed_               IN BOOLEAN )
IS
BEGIN
   -- Untag the Printed Flags in Shipment Header  
   IF (sscc_is_changed_ OR alt_hu_unit_label_id_is_changed_ OR manual_gross_weight_is_changed_ OR manual_volume_is_changed_) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         Shipment_API.Reset_Printed_On_Hu_Info_Chg(shipment_id_, sscc_is_changed_, alt_hu_unit_label_id_is_changed_,
                                                   manual_gross_weight_is_changed_, manual_volume_is_changed_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHPMNT');
      $END  
   END IF;
   
   -- HU is not moved to anywhere within the shipment or to a different shipment
   IF ((NOT(shipment_is_changed_) AND NOT(parent_is_changed_)) AND
       ((manual_gross_weight_is_changed_) OR (manual_volume_is_changed_))) THEN
      Calculate_Shipment_Charges___(shipment_id_);
   END IF;
   
END Handle_Shipment_On_Update___;   
   

PROCEDURE Handle_Change_Of_Source_Ref___ (   
   newrec_                  IN handling_unit_tab%ROWTYPE )
IS   
   CURSOR get_hu_structure IS
      SELECT handling_unit_id 
        FROM handling_unit_tab
       WHERE parent_handling_unit_id = newrec_.handling_unit_id
       FOR UPDATE NOWAIT;     
BEGIN
   FOR rec_ IN get_hu_structure LOOP
      Modify_Source_Ref (rec_.handling_unit_id,
                         newrec_.source_ref_type,
                         newrec_.source_ref1,
                         newrec_.source_ref2,
                         newrec_.source_ref3,
                         TRUE);
   END LOOP;
END Handle_Change_Of_Source_Ref___;

PROCEDURE Check_Change_Of_Source_Ref___ (   
   oldrec_               IN handling_unit_tab%ROWTYPE,
   newrec_               IN handling_unit_tab%ROWTYPE )
IS
BEGIN   
   IF (oldrec_.source_ref_type IS NOT NULL AND newrec_.source_ref_type IS NOT NULL AND oldrec_.source_ref_type != newrec_.source_ref_type) OR
      (oldrec_.source_ref1 IS NOT NULL AND newrec_.source_ref1 IS NOT NULL AND oldrec_.source_ref1 != newrec_.source_ref1) OR
      (oldrec_.source_ref2 IS NOT NULL AND newrec_.source_ref2 IS NOT NULL AND oldrec_.source_ref2 != newrec_.source_ref2) OR
      (oldrec_.source_ref3 IS NOT NULL AND newrec_.source_ref3 IS NOT NULL AND oldrec_.source_ref3 != newrec_.source_ref3) THEN
      Error_SYS.Record_General(lu_name_, 'HUALREADYCONNECTED: Handling Unit :P1 is already connected to a :P2', newrec_.handling_unit_id, Handl_Unit_Source_Ref_Type_API.Decode(oldrec_.source_ref_type));
   END IF;
END Check_Change_Of_Source_Ref___;

FUNCTION Get_Contract_From_Reference___ (
   newrec_ handling_unit_tab%ROWTYPE ) RETURN handling_unit_tab.contract%TYPE
IS
   contract_ handling_unit_tab.contract%TYPE;
BEGIN
   IF (newrec_.location_no IS NULL) THEN
      IF (newrec_.shipment_id IS NOT NULL) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            contract_ := Shipment_API.Get_Contract(newrec_.shipment_id);  
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      ELSIF (newrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            contract_ := Shop_Ord_API.Get_Contract(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3);  
         $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
         $END
      END IF;
   END IF;

   RETURN (contract_);
END Get_Contract_From_Reference___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MIX_OF_PART_NO_BLOCKED_DB',   Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_BLOCKED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_COND_CODE_BLOCKED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT handling_unit_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   source_part_no_   VARCHAR2(25);
   parent_rec_       handling_unit_tab%ROWTYPE;
BEGIN
   newrec_.handling_unit_id := Get_Next_Handling_Unit_Id___;
   Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', newrec_.handling_unit_id, attr_);
   
   IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
      parent_rec_           := Get_Object_By_Keys___(newrec_.parent_handling_unit_id);
      newrec_.shipment_id   := parent_rec_.shipment_id;
      IF ((newrec_.location_no IS NULL) AND (parent_rec_.location_no IS NOT NULL)) THEN 
         -- An new HU without stock is connected to a parent being in stock. The new one should inherit from the parent.
         newrec_.contract      := parent_rec_.contract;
         newrec_.location_no   := parent_rec_.location_no;
      END IF;       
   END IF;
   
   IF (newrec_.location_no IS NULL) THEN
      newrec_.contract := Get_Contract_From_Reference___(newrec_);
      newrec_.is_in_stock := Fnd_Boolean_API.DB_FALSE;
   ELSE
      newrec_.location_type := Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.location_no);
      newrec_.is_in_stock := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   IF (newrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         source_part_no_ := Shop_Ord_API.Get_Part_No(newrec_.source_ref1 , newrec_.source_ref2, newrec_.source_ref3);
         newrec_.source_ref_part_qty := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(source_part_no_, 
                                                                                         newrec_.handling_unit_type_id, 
                                                                                         Inventory_Part_API.Get_Unit_Meas(newrec_.contract, source_part_no_));
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END
   END IF;
   
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_ );
    
   super(objid_, objversion_, newrec_, attr_);
   
   IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN 
      IF ((parent_rec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) AND
          (parent_rec_.source_ref_part_qty IS NOT NULL)) THEN
         Modify_Source_Ref_Part_Qty(newrec_.parent_handling_unit_id, NULL);
      END IF;
   END IF;
     
   IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
      Clear_Manual_Weight_And_Volume(newrec_.parent_handling_unit_id);
   ELSIF (newrec_.shipment_id IS NOT NULL) THEN
      Remove_Manual_Ship_Volume___(newrec_.shipment_id);
   END IF;
   
   IF (newrec_.shipment_id IS NOT NULL) THEN
      Remove_Manual_Ship_Weight___(newrec_.shipment_id);
      Calculate_Shipment_Charges___(newrec_.shipment_id);            
   END IF;   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_                        IN     VARCHAR2,
   oldrec_                       IN     handling_unit_tab%ROWTYPE,
   newrec_                       IN OUT handling_unit_tab%ROWTYPE,
   attr_                         IN OUT VARCHAR2,
   objversion_                   IN OUT VARCHAR2,
   by_keys_                      IN     BOOLEAN DEFAULT FALSE,
   release_reservations_         IN     BOOLEAN DEFAULT FALSE,
   connect_source_to_decendants_ IN     BOOLEAN DEFAULT FALSE   )
IS
   shipment_is_changed_             BOOLEAN := FALSE; 
   source_ref_is_changed_           BOOLEAN := FALSE; 
   parent_is_changed_               BOOLEAN := FALSE;
   moved_between_parents_           BOOLEAN := FALSE;
   sscc_is_changed_                 BOOLEAN := FALSE;
   alt_hu_unit_label_id_is_changed_ BOOLEAN := FALSE; 
   manual_weight_is_changed_        BOOLEAN := FALSE;
   manual_volume_is_changed_        BOOLEAN := FALSE;   
   
   old_parent_handl_unit_id_tab_  Handling_Unit_Id_Tab;
   attached_handling_unit_id_tab_ Handling_Unit_Id_Tab; 
   old_root_handling_unit_id_     handling_unit_tab.handling_unit_id%TYPE;
   
   source_part_no_                VARCHAR2(25);
   parent_rec_                    handling_unit_tab%ROWTYPE;  
BEGIN
   IF (Validate_SYS.Is_Changed(oldrec_.parent_handling_unit_id, newrec_.parent_handling_unit_id)) THEN
      old_root_handling_unit_id_ := Get_Root_Handling_Unit_Id(newrec_.handling_unit_id);
      parent_is_changed_ := TRUE;

      IF ((oldrec_.parent_handling_unit_id IS NOT NULL) AND
          (newrec_.parent_handling_unit_id IS NOT NULL)) THEN
         old_parent_handl_unit_id_tab_ := Get_Parent_Hand_Unit_Id_Tab___(oldrec_.handling_unit_id);
         moved_between_parents_        := TRUE;     
      END IF;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.shipment_id, newrec_.shipment_id)) THEN
      shipment_is_changed_ := TRUE;
   END IF;      
   
   IF Validate_SYS.Is_Changed(oldrec_.source_ref_type, newrec_.source_ref_type) OR 
      Validate_SYS.Is_Changed(oldrec_.source_ref1, newrec_.source_ref1) OR
      Validate_SYS.Is_Changed(oldrec_.source_ref2, newrec_.source_ref2) OR
      Validate_SYS.Is_Changed(oldrec_.source_ref3, newrec_.source_ref3) THEN
      source_ref_is_changed_ := TRUE;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.manual_tare_weight, newrec_.manual_tare_weight)) THEN
      manual_weight_is_changed_ := TRUE;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) THEN
      manual_weight_is_changed_ := TRUE;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.manual_volume, newrec_.manual_volume)) THEN
      manual_volume_is_changed_ := TRUE;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.sscc, newrec_.sscc)) THEN
      sscc_is_changed_ := TRUE;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.alt_handling_unit_label_id, newrec_.alt_handling_unit_label_id)) THEN
      alt_hu_unit_label_id_is_changed_ := TRUE;
   END IF;

   IF ((newrec_.location_no     IS NULL) AND
       (newrec_.shipment_id     IS NULL) AND
       (newrec_.source_ref_type IS NULL)) THEN
      newrec_.contract := NULL;
   ELSE
      IF ((newrec_.location_no IS NULL) AND (shipment_is_changed_ OR source_ref_is_changed_)) THEN
         newrec_.contract := Get_Contract_From_Reference___(newrec_);
      END IF;
   END IF;

   IF ((source_ref_is_changed_) AND 
       ((oldrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) OR 
        (newrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER))) THEN
      IF (newrec_.source_ref_type IS NULL) THEN
         newrec_.source_ref_part_qty := NULL;
      ELSIF ((newrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) AND 
             (NOT (Has_Children(newrec_.handling_unit_id)))) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            source_part_no_ := Shop_Ord_API.Get_Part_No(newrec_.source_ref1 , newrec_.source_ref2, newrec_.source_ref3);
            newrec_.source_ref_part_qty := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(source_part_no_, 
                                                                                            newrec_.handling_unit_type_id, 
                                                                                            Inventory_Part_API.Get_Unit_Meas(newrec_.contract, source_part_no_)) -
                                           Get_Part_Qty_Onhand(newrec_.handling_unit_id, source_part_no_); 
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END                               
      END IF;
   END IF;

   IF Validate_SYS.Is_Changed(oldrec_.location_no, newrec_.location_no) THEN
      newrec_.location_type := CASE newrec_.location_no WHEN NULL THEN NULL ELSE Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.location_no) END;
   END IF;
   
   IF (newrec_.location_no IS NULL) THEN
      newrec_.is_in_stock := Fnd_Boolean_API.DB_FALSE;
   ELSE
      newrec_.is_in_stock := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF ((parent_is_changed_) AND (newrec_.parent_handling_unit_id IS NOT NULL)) THEN
      parent_rec_ := Get_Object_By_Keys___(newrec_.parent_handling_unit_id);
      
      IF ((parent_rec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) AND 
          (parent_rec_.source_ref_part_qty IS NOT NULL)) THEN
         Modify_Source_Ref_Part_Qty(newrec_.parent_handling_unit_id, NULL);
      END IF;
   END IF;
   
   IF (((newrec_.mix_of_part_no_blocked != oldrec_.mix_of_part_no_blocked) AND (newrec_.mix_of_part_no_blocked = Fnd_Boolean_API.DB_TRUE)) OR 
       ((newrec_.mix_of_lot_batch_blocked != oldrec_.mix_of_lot_batch_blocked) AND (newrec_.mix_of_lot_batch_blocked = Fnd_Boolean_API.DB_TRUE)) OR 
       ((newrec_.mix_of_cond_code_blocked != oldrec_.mix_of_cond_code_blocked) AND (newrec_.mix_of_cond_code_blocked = Fnd_Boolean_API.DB_TRUE))) THEN
      attached_handling_unit_id_tab_ := Get_Node_And_Descendants(newrec_.handling_unit_id);
       
      IF ((newrec_.mix_of_part_no_blocked != oldrec_.mix_of_part_no_blocked) AND (newrec_.mix_of_part_no_blocked = Fnd_Boolean_API.DB_TRUE)) THEN
         Check_Allow_Mix_Part_No___ (attached_handling_unit_id_tab_, TRUE);
      END IF;
       
      IF ((newrec_.mix_of_lot_batch_blocked != oldrec_.mix_of_lot_batch_blocked) AND (newrec_.mix_of_lot_batch_blocked = Fnd_Boolean_API.DB_TRUE)) THEN
         Check_Allow_Mix_Lot_Batches___(attached_handling_unit_id_tab_, TRUE);
      END IF;
       
      IF ((newrec_.mix_of_cond_code_blocked != oldrec_.mix_of_cond_code_blocked) AND (newrec_.mix_of_cond_code_blocked = Fnd_Boolean_API.DB_TRUE)) THEN
         Check_Allow_Mix_Cond_Codes___(attached_handling_unit_id_tab_, TRUE);
      END IF;
   END IF;
    
   IF (parent_is_changed_) THEN 
      Handle_Change_Of_Parent___ (oldrec_, newrec_, old_parent_handl_unit_id_tab_, moved_between_parents_, old_root_handling_unit_id_);      
   END IF;
    
   IF (shipment_is_changed_) THEN
      Handle_Change_Of_Shipment___(oldrec_, newrec_, release_reservations_);
   END IF;
   
   IF (source_ref_is_changed_) THEN
      IF (connect_source_to_decendants_) THEN
         Handle_Change_Of_Source_Ref___ (newrec_);
      END IF;
   END IF;
   
   IF (newrec_.shipment_id IS NOT NULL) THEN
      Handle_Shipment_On_Update___ (newrec_.shipment_id, sscc_is_changed_, alt_hu_unit_label_id_is_changed_, manual_weight_is_changed_,
                                    manual_volume_is_changed_, shipment_is_changed_, parent_is_changed_);
   END IF;                              
      
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


PROCEDURE Pre_Delete___ (
   remrec_             IN handling_unit_tab%ROWTYPE )
IS
   handling_unit_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_tab_ := Get_Children___(remrec_.handling_unit_id);

   IF (handling_unit_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
         -- This transfers the parent reference of the removed HU to its children.
         -- IF the removed HU did not have any parent then the children will be new top nodes
         Modify_Parent_Handling_Unit_Id(handling_unit_tab_(i).handling_unit_id, 
                                        remrec_.parent_handling_unit_id);
      END LOOP;
   END IF;
END Pre_Delete___;


PROCEDURE Post_Delete___ (
   remrec_ IN handling_unit_tab%ROWTYPE )
IS
   connected_shipment_line_exist_ VARCHAR2(5);
BEGIN
   IF (remrec_.parent_handling_unit_id IS NOT NULL) THEN
      Clear_Manual_Weight_And_Volume(remrec_.parent_handling_unit_id);
   ELSIF (remrec_.shipment_id IS NOT NULL) THEN
      Remove_Manual_Ship_Volume___(remrec_.shipment_id);
   END IF;
   
   IF (remrec_.shipment_id IS NOT NULL) THEN
      Remove_Manual_Ship_Weight___(remrec_.shipment_id);
   END IF;
   
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      connected_shipment_line_exist_ := Shipment_Line_Handl_Unit_API.Handling_Unit_Exist(remrec_.shipment_id, remrec_.handling_unit_id);
      IF (connected_shipment_line_exist_ = Fnd_Boolean_API.DB_TRUE) THEN
         Shipment_Line_Handl_Unit_API.Remove_Handling_Unit(remrec_.shipment_id, remrec_.handling_unit_id);
      END IF;
      Calculate_Shipment_Charges___(remrec_.shipment_id);
   $END
   Accessory_On_Handling_Unit_API.Remove(remrec_.handling_unit_id);
END Post_Delete___;


@Override
PROCEDURE Delete___ (
   objid_              IN VARCHAR2,
   remrec_             IN handling_unit_tab%ROWTYPE )
IS
BEGIN
   Pre_Delete___(remrec_);

   super(objid_, remrec_);

   Post_Delete___(remrec_);
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     handling_unit_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY handling_unit_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   parent_shipment_id_ NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (Validate_SYS.Is_Different(oldrec_.shipment_id, newrec_.shipment_id)) THEN
      IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
         parent_shipment_id_ := Get_Shipment_Id(newrec_.parent_handling_unit_id);
         IF (Validate_SYS.Is_Different(parent_shipment_id_, newrec_.shipment_id)) THEN
            Error_SYS.Record_General(lu_name_, 'DIFFSHIPID: Handling Unit ID :P1 and its Parent Handling Unit ID :P2 should be connected to the same shipment.', newrec_.handling_unit_id, newrec_.parent_handling_unit_id);
         END IF;
      END IF;
      IF (newrec_.shipment_id IS NOT NULL AND (Shipment_Is_Delivered___(newrec_.shipment_id))) THEN
         Error_SYS.Record_General(lu_name_, 'DELIVSHIPM: It is not allowed to connect a handling unit to a delivered shipment.');
      END IF;
   END IF;
   
   IF (newrec_.contract IS NULL AND newrec_.location_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SITELOCATION: Location No cannot be entered without entering also Site.');
   END IF;
   
   IF ((newrec_.shipment_id IS NOT NULL) AND (newrec_.source_ref_type IS NOT NULL)) THEN 
      Error_SYS.Record_General(lu_name_, 'SHIPSOURCEREF: Handling unit :P1 cannot be connected to a shipment and a :P2 at the same time.', newrec_.handling_unit_id, Handl_Unit_Source_Ref_Type_API.Decode(newrec_.source_ref_type));
   END IF;   

   IF newrec_.source_ref_type IS NOT NULL THEN
      Error_SYS.Check_Not_Null(lu_name_, 'SOURCE_REF1', newrec_.source_ref1);
   END IF;
   
   IF newrec_.source_ref1 IS NOT NULL OR 
      newrec_.source_ref2 IS NOT NULL OR
      newrec_.source_ref3 IS NOT NULL THEN
      Error_SYS.Check_Not_Null(lu_name_, 'SOURCE_REF_TYPE', newrec_.source_ref_type);
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.width, oldrec_.width)) THEN
      Check_Length___(newrec_.width);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.height, oldrec_.height)) THEN
      Check_Length___(newrec_.height);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.depth, oldrec_.depth)) THEN
      Check_Length___(newrec_.depth);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.uom_for_length, oldrec_.uom_for_length)) THEN
      Check_Uom_For_Length___(newrec_.uom_for_length);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.manual_tare_weight, oldrec_.manual_tare_weight)) THEN
      IF (NVL(newrec_.manual_tare_weight, 0) < 0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVETAREWEIGHT: Manual tare weight cannot be negative.');   
      END IF;
   END IF;
   
   IF (Validate_SYS.Is_Changed(newrec_.manual_gross_weight, oldrec_.manual_gross_weight)) THEN
      IF (NVL(newrec_.manual_gross_weight, 0) < 0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVEGROSSWEIGHT: Manual gross weight cannot be negative.');   
      END IF;
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.manual_volume, oldrec_.manual_volume)) THEN
      IF (NVL(newrec_.manual_volume, 0) < 0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVEVOLUME: Manual volume cannot be negative.');   
      END IF;
   END IF;

   IF (newrec_.no_of_handling_unit_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHULABELFORMAT: No of Handling Unit Labels must be greater than or equal to 1.');   
   END IF;
   IF (newrec_.no_of_content_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHUCONTENTLABELFORMAT: No of Handling Unit Content Labels must be greater than or equal to 1.');   
   END IF;
   IF (newrec_.no_of_shipment_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOSHIPMENTHULABELFORMAT: No of Shipment Handling Unit Labels must be greater than or equal to 1.');   
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.sscc, oldrec_.sscc)) THEN
      IF (newrec_.sscc IS NOT NULL) THEN
         Validate_Sscc(newrec_.sscc);
      END IF;
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.parent_handling_unit_id, oldrec_.parent_handling_unit_id)) THEN
      IF (newrec_.parent_handling_unit_id IS NOT NULL) THEN
         Check_Structure(newrec_.handling_unit_id, newrec_.parent_handling_unit_id);
      END IF;
   END IF;

END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   handling_unit_type_rec_ Handling_Unit_Type_API.Public_Rec;
BEGIN
   handling_unit_type_rec_ := Handling_Unit_Type_API.Get(newrec_.handling_unit_type_id);
   
   IF NOT(indrec_.generate_sscc_no) THEN
      newrec_.generate_sscc_no := handling_unit_type_rec_.generate_sscc_no;
   END IF;
   
   IF NOT(indrec_.print_label) THEN
      newrec_.print_label := handling_unit_type_rec_.print_label;
   END IF;
   
   IF NOT(indrec_.no_of_handling_unit_labels) THEN
      newrec_.no_of_handling_unit_labels := handling_unit_type_rec_.no_of_handling_unit_labels;
   END IF;
   
   IF NOT(indrec_.print_content_label) THEN
      newrec_.print_content_label := handling_unit_type_rec_.print_content_label;
   END IF;
   
   IF NOT(indrec_.no_of_content_labels) THEN
      newrec_.no_of_content_labels := handling_unit_type_rec_.no_of_content_labels;
   END IF;
   
   IF NOT(indrec_.print_shipment_label) THEN
      newrec_.print_shipment_label := handling_unit_type_rec_.print_shipment_label;
   END IF;
   
   IF NOT(indrec_.no_of_shipment_labels) THEN
      newrec_.no_of_shipment_labels := handling_unit_type_rec_.no_of_shipment_labels;
   END IF;
   
   IF NOT(indrec_.width) THEN
      newrec_.width := handling_unit_type_rec_.width;
   END IF;
   
   IF NOT(indrec_.height) THEN
      newrec_.height := handling_unit_type_rec_.height;
   END IF;
      
   IF NOT(indrec_.depth) THEN
      newrec_.depth := handling_unit_type_rec_.depth;
   END IF;
   
   IF NOT(indrec_.mix_of_part_no_blocked) THEN
      newrec_.mix_of_part_no_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.mix_of_lot_batch_blocked) THEN
      newrec_.mix_of_lot_batch_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.mix_of_cond_code_blocked) THEN
      newrec_.mix_of_cond_code_blocked := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF (newrec_.uom_for_length IS NULL) THEN
      newrec_.uom_for_length := Get_Default_Uom_For_Length(newrec_.parent_handling_unit_id, newrec_.handling_unit_type_id);
   END IF;

   IF NOT(indrec_.has_stock_reservation) THEN
      newrec_.has_stock_reservation := Fnd_Boolean_API.DB_FALSE;  
   END IF;
   
   super(newrec_, indrec_, attr_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     handling_unit_tab%ROWTYPE,
   newrec_ IN OUT handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
      
   IF indrec_.source_ref_type OR indrec_.source_ref1 OR indrec_.source_ref2 OR indrec_.source_ref3 THEN
      Check_Change_Of_Source_Ref___(oldrec_,newrec_);
   END IF;
   
   IF (newrec_.source_ref_part_qty <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDSOURCEREFQTY: Quantity to attach must be greater than zero.');
   END IF;

   IF ((newrec_.source_ref_type = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER) AND
       (newrec_.source_ref_part_qty IS NOT NULL) AND 
       ((Validate_SYS.Is_Changed(oldrec_.source_ref_type, newrec_.source_ref_type)) OR 
        (Validate_SYS.Is_Changed(oldrec_.source_ref_part_qty, newrec_.source_ref_part_qty))) AND
       (Has_Children(newrec_.handling_unit_id))) THEN
      Error_SYS.Record_General(lu_name_, 'SOURCEREFQTYPARENTNOTNULL: Qty to Attach cannot have a value for a Parent Handling Unit connected to a Shop Order.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Modify_Sscc___(
   handling_unit_id_ IN NUMBER,
   sscc_             IN VARCHAR2 )
IS
   newrec_ handling_unit_tab%ROWTYPE;
BEGIN
   newrec_      := Lock_By_Keys___(handling_unit_id_);
   newrec_.sscc := sscc_;
   Modify___(newrec_);
END Modify_Sscc___;


PROCEDURE Perform_Stock_Operation___ (
   out_parameter1_                OUT VARCHAR2,
   handling_unit_id_              IN NUMBER,
   stock_operation_id_            IN NUMBER,
   string_parameter1_             IN VARCHAR2 DEFAULT NULL,
   string_parameter2_             IN VARCHAR2 DEFAULT NULL,
   string_parameter3_             IN VARCHAR2 DEFAULT NULL,
   string_parameter4_             IN VARCHAR2 DEFAULT NULL,
   string_parameter5_             IN VARCHAR2 DEFAULT NULL,
   string_parameter6_             IN VARCHAR2 DEFAULT NULL,
   string_parameter7_             IN VARCHAR2 DEFAULT NULL,
   string_parameter8_             IN VARCHAR2 DEFAULT NULL,
   string_parameter9_             IN VARCHAR2 DEFAULT NULL,
   string_parameter10_            IN VARCHAR2 DEFAULT NULL,
   string_parameter11_            IN VARCHAR2 DEFAULT NULL,
   string_parameter12_            IN VARCHAR2 DEFAULT NULL,
   date_parameter1_               IN DATE     DEFAULT NULL,
   number_parameter1_             IN NUMBER   DEFAULT NULL,
   number_parameter2_             IN NUMBER   DEFAULT NULL,
   source_ref1_                   IN VARCHAR2 DEFAULT NULL,
   source_ref2_                   IN VARCHAR2 DEFAULT NULL,
   source_ref3_                   IN VARCHAR2 DEFAULT NULL,
   source_ref4_                   IN VARCHAR2 DEFAULT NULL,
   source_ref_type_               IN VARCHAR2 DEFAULT NULL,
   error_when_stock_not_exist_    IN BOOLEAN  DEFAULT TRUE,
   ownership_transfer_reason_id_  IN VARCHAR2 DEFAULT NULL)
IS
   stock_exist_in_structure_  BOOLEAN := FALSE;
   oldrec_                    handling_unit_tab%ROWTYPE;
   exit_procedure_            EXCEPTION;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   Exist(handling_unit_id_);
   oldrec_ := Lock_By_Keys___(handling_unit_id_);
   
   IF ((stock_operation_id_ IN (change_stock_location_, receive_from_invent_transit_)) AND
       (oldrec_.parent_handling_unit_id IS NOT NULL)) THEN
      -- A handling unit that is being moved to another location must be disconnected from its parent which will stay in the original location.
      Modify_Parent_Handling_Unit_Id(handling_unit_id_, parent_handling_unit_id_ => NULL);
   END IF;
   IF ((oldrec_.location_type IN (Inventory_Location_Type_API.DB_ARRIVAL,
                              Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) AND
       (stock_operation_id_ NOT IN (modify_expiration_date_, modify_availability_ctrl_id_))) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Receive_Order_API.Make_Handl_Unit_Stock_Action(stock_exist_in_structure_   => stock_exist_in_structure_,
                                                        handling_unit_id_           => handling_unit_id_,
                                                        stock_operation_id_         => stock_operation_id_,
                                                        string_parameter1_          => string_parameter1_,
                                                        string_parameter2_          => string_parameter2_,
                                                        string_parameter3_          => string_parameter3_,
                                                        string_parameter4_          => string_parameter4_,
                                                        string_parameter5_          => string_parameter12_);
      $ELSE
        Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSE
      Perform_Stock_Operat_Invent___(out_parameter1_               => out_parameter1_,
                                     stock_exist_in_structure_     => stock_exist_in_structure_,
                                     handling_unit_id_             => handling_unit_id_,
                                     stock_operation_id_           => stock_operation_id_,
                                     string_parameter1_            => string_parameter1_,
                                     string_parameter2_            => string_parameter2_,
                                     string_parameter3_            => string_parameter3_,
                                     string_parameter4_            => string_parameter4_,
                                     string_parameter5_            => string_parameter5_,
                                     string_parameter6_            => string_parameter6_,
                                     string_parameter7_            => string_parameter7_,
                                     string_parameter8_            => string_parameter8_,
                                     string_parameter9_            => string_parameter9_,
                                     string_parameter10_           => string_parameter10_,
                                     string_parameter11_           => string_parameter11_,
                                     date_parameter1_              => date_parameter1_,
                                     number_parameter1_            => number_parameter1_,
                                     number_parameter2_            => number_parameter2_,
                                     source_ref1_                  => source_ref1_,
                                     source_ref2_                  => source_ref2_,
                                     source_ref3_                  => source_ref3_,
                                     source_ref4_                  => source_ref4_,
                                     source_ref_type_              => source_ref_type_,
                                     contract_                     => oldrec_.contract,
                                     ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
   END IF;

   IF NOT (stock_exist_in_structure_) THEN
      IF (error_when_stock_not_exist_) THEN
         Raise_Not_In_Stock_Error(handling_unit_id_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (stock_operation_id_ IN (scrap_, issue_with_posting_)) THEN
   -- If the handling unit is being removed from stock then it must be disconnected from its parent which might be left in stock.
   -- if the handling unit is the top parent then this will not cause any update.
      Disconnect_Zero_Stock_In_Struc(handling_unit_id_);
   END IF;

   IF ((stock_operation_id_ in (change_stock_location_, receive_from_invent_transit_)) AND (oldrec_.parent_handling_unit_id IS NOT NULL)) THEN
      -- the moved handling unit has been disconnected from its parent which was not included in the move. So now the parent might not have
      -- any connection to any stock on itself or any of its children. If this parent is not the top parent in the structure there might be connections
      -- to stock records on other places in the structure. In that case we should remove the connection to the parent of the parent. 
      Disconnect_Zero_Stock_In_Struc(oldrec_.parent_handling_unit_id);
   END IF;

   Inventory_Event_Manager_API.Finish_Session;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Perform_Stock_Operation___;

               
FUNCTION Get_Children___ (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;

   CURSOR get_children IS  
      SELECT handling_unit_id
      FROM handling_unit_tab
      WHERE parent_handling_unit_id = handling_unit_id_;   
BEGIN   
   OPEN get_children;
   FETCH get_children BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_children;
      
   RETURN handling_unit_id_tab_;
END Get_Children___;

   
FUNCTION Has_Quantity_To_Move___ (
   handling_unit_id_ IN  NUMBER) RETURN BOOLEAN
IS
   CURSOR has_quantity_to_move IS
      SELECT 1
      FROM inventory_part_in_stock_tab ipis
      WHERE ipis.handling_unit_id IN (SELECT handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      AND (qty_onhand - qty_reserved > 0)
      AND (location_type NOT IN ('ARRIVAL','QA'));
      
   dummy_number_         NUMBER;
   has_quantity_to_move_ BOOLEAN := FALSE;
BEGIN
   OPEN  has_quantity_to_move;
   FETCH has_quantity_to_move INTO dummy_number_;
   IF (has_quantity_to_move%FOUND) THEN
      has_quantity_to_move_ := TRUE;
   END IF;
   
   RETURN (has_quantity_to_move_);
END Has_Quantity_To_Move___;


FUNCTION Is_In_Inventory_Transit___ (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN  
IS
   CURSOR has_quantity_in_transit IS
      SELECT 1
      FROM inventory_part_in_stock_tab ipis
      WHERE ipis.handling_unit_id IN (SELECT handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      AND  (qty_in_transit != 0);

   has_quantity_in_transit_  BOOLEAN := FALSE;
   dummy_number_             NUMBER;
BEGIN
   OPEN  has_quantity_in_transit;
   FETCH has_quantity_in_transit INTO dummy_number_;
   IF (has_quantity_in_transit%FOUND) THEN
      has_quantity_in_transit_ := TRUE;
   END IF;
   CLOSE has_quantity_in_transit;

RETURN has_quantity_in_transit_;
END Is_In_Inventory_Transit___;


FUNCTION Is_In_Project_Inventory___ (
   handling_unit_id_ IN  NUMBER) RETURN BOOLEAN
IS
   CURSOR is_in_project_inventory IS
      SELECT 1
      FROM inventory_part_in_stock_tab ipis
      WHERE ipis.handling_unit_id IN (SELECT handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      AND activity_seq != 0
      AND (qty_onhand > 0 OR qty_in_transit > 0);

   is_in_project_inventory_ BOOLEAN := FALSE;
   dummy_number_            NUMBER;
BEGIN
   OPEN  is_in_project_inventory;
   FETCH is_in_project_inventory INTO dummy_number_;
   IF (is_in_project_inventory%FOUND) THEN
      is_in_project_inventory_ := TRUE;
   END IF;
   CLOSE is_in_project_inventory;

   RETURN is_in_project_inventory_;
END Is_In_Project_Inventory___;


FUNCTION Has_Quantity_In_Stock___ (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR has_quantity_in_stock IS
      SELECT 1
      FROM inventory_part_in_stock_tab ipis
      WHERE ipis.handling_unit_id IN (SELECT handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      AND (qty_onhand > 0 OR qty_in_transit > 0);
      
   has_quantity_in_stock_ BOOLEAN := FALSE;
   dummy_number_            NUMBER;
BEGIN
   OPEN  has_quantity_in_stock;
   FETCH has_quantity_in_stock INTO dummy_number_;
   IF (has_quantity_in_stock%FOUND) THEN
      has_quantity_in_stock_ := TRUE;
   END IF;
   CLOSE has_quantity_in_stock;

   RETURN has_quantity_in_stock_;
END Has_Quantity_In_Stock___;

   
FUNCTION Has_Quantity_Reserved___ (
   handling_unit_id_ IN NUMBER) RETURN BOOLEAN
IS
   CURSOR has_qty_reserved IS
      SELECT 1
      FROM inventory_part_in_stock_tab ipis
      WHERE ipis.handling_unit_id IN (SELECT handling_unit_id
                                        FROM handling_unit_tab hu
                                     CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                       START WITH     hu.handling_unit_id = handling_unit_id_)
      AND (qty_reserved > 0);
      
   has_qty_reserved_     BOOLEAN := FALSE;
   dummy_number_         NUMBER;
BEGIN
   OPEN  has_qty_reserved;
   FETCH has_qty_reserved INTO dummy_number_;
   IF (has_qty_reserved%FOUND) THEN
      has_qty_reserved_ := TRUE;
   END IF;
   CLOSE has_qty_reserved;
   
   RETURN has_qty_reserved_;
END Has_Quantity_Reserved___;


FUNCTION Has_Quantity_Reserved___ (
   handling_unit_id_tab_ IN Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   has_qty_reserved_ BOOLEAN := FALSE;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         has_qty_reserved_ := Has_Quantity_Reserved___(handling_unit_id_tab_(i).handling_unit_id);
         EXIT WHEN has_qty_reserved_;
      END LOOP;
   END IF;
   RETURN (has_qty_reserved_);
END Has_Quantity_Reserved___;


FUNCTION Has_Mixed_Part_Numbers___ (
   handling_unit_id_tab_ IN Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   CURSOR get_parts_in_stock IS
      SELECT DISTINCT part_no
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND (qty_onhand != 0 OR qty_in_transit != 0);
   TYPE parts_in_stock_tab IS TABLE OF get_parts_in_stock%ROWTYPE INDEX BY PLS_INTEGER;
   parts_in_stock_tab_     Parts_In_Stock_Tab;
   
   has_mixed_parts_  BOOLEAN := FALSE;
   shipment_id_      Handling_Unit_Tab.shipment_id%TYPE;
BEGIN  
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      shipment_id_ := Get_Shipment_Id(handling_unit_id_tab_(1).handling_unit_id);
      IF (shipment_id_ IS NOT NULL) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            has_mixed_parts_ := Shipment_Line_Handl_Unit_API.Mixed_Part_Numbers_Connected(handling_unit_id_tab_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      ELSE
         OPEN  get_parts_in_stock;
         FETCH get_parts_in_stock BULK COLLECT INTO parts_in_stock_tab_;
         CLOSE get_parts_in_stock;

         IF (parts_in_stock_tab_.COUNT > 1) THEN
            has_mixed_parts_ := TRUE;
         END IF;   
      END IF;
   END IF;
   RETURN has_mixed_parts_;
END Has_Mixed_Part_Numbers___;

   
FUNCTION Has_Mixed_Lot_Batches___(
   handling_unit_id_tab_ IN Handling_Unit_Id_Tab) RETURN BOOLEAN
IS
   CURSOR get_parts_in_stock IS
      SELECT DISTINCT part_no, lot_batch_no
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND (qty_onhand != 0 OR qty_in_transit != 0)
         ORDER BY part_no;
   TYPE parts_in_stock_tab IS TABLE OF get_parts_in_stock%ROWTYPE INDEX BY PLS_INTEGER;
   parts_in_stock_tab_     Parts_In_Stock_Tab;
   
   has_mixed_lot_batches_  BOOLEAN := FALSE;
   shipment_id_            Handling_Unit_Tab.shipment_id%TYPE;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      shipment_id_ := Get_Shipment_Id(handling_unit_id_tab_(1).handling_unit_id);
      IF (shipment_id_ IS NOT NULL) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            has_mixed_lot_batches_ := Shipment_Reserv_Handl_Unit_API.Mixed_Lot_Batches_Connected(shipment_id_, handling_unit_id_tab_);
         $ELSE
            NULL;
         $END
      ELSE
         OPEN  get_parts_in_stock;
         FETCH get_parts_in_stock BULK COLLECT INTO parts_in_stock_tab_;
         CLOSE get_parts_in_stock;

         IF parts_in_stock_tab_.COUNT > 0 THEN
            FOR j_ IN parts_in_stock_tab_.FIRST .. parts_in_stock_tab_.LAST LOOP
               IF (j_ < parts_in_stock_tab_.COUNT) THEN 
                  IF (parts_in_stock_tab_(j_).part_no = parts_in_stock_tab_(j_+1).part_no) THEN
                     has_mixed_lot_batches_ := TRUE;
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      END IF;
   END IF;
   RETURN has_mixed_lot_batches_;
END Has_Mixed_Lot_Batches___;

 
FUNCTION Has_Mixed_Cond_Codes___(
   handling_unit_id_tab_ IN Handling_Unit_Id_Tab) RETURN BOOLEAN
IS
   CURSOR get_parts_in_stock IS
      SELECT DISTINCT part_no, Condition_Code_Manager_API.Get_Condition_Code(part_no, serial_no, lot_batch_no) condition_code
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND (qty_onhand != 0 OR qty_in_transit != 0)
         ORDER BY part_no;
   TYPE parts_in_stock_tab IS TABLE OF get_parts_in_stock%ROWTYPE INDEX BY PLS_INTEGER;
   parts_in_stock_tab_     Parts_In_Stock_Tab;

   has_mixed_cond_codes_  BOOLEAN := FALSE;
   shipment_id_           Handling_Unit_Tab.shipment_id%TYPE;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      shipment_id_ := Get_Shipment_Id(handling_unit_id_tab_(1).handling_unit_id);
      IF (shipment_id_ IS NOT NULL) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            has_mixed_cond_codes_ := Shipment_Reserv_Handl_Unit_API.Mixed_Cond_Codes_Connected(shipment_id_, handling_unit_id_tab_);
         $ELSE
            NULL;
         $END
      ELSE
         OPEN  get_parts_in_stock;
         FETCH get_parts_in_stock BULK COLLECT INTO parts_in_stock_tab_;
         CLOSE get_parts_in_stock;

         IF parts_in_stock_tab_.COUNT > 0 THEN
            FOR j_ IN parts_in_stock_tab_.FIRST .. parts_in_stock_tab_.LAST LOOP
               IF (j_ < parts_in_stock_tab_.COUNT) THEN 
                  IF (parts_in_stock_tab_(j_).part_no = parts_in_stock_tab_(j_+1).part_no) THEN
                     has_mixed_cond_codes_ := TRUE;
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      END IF;
   END IF;
   RETURN has_mixed_cond_codes_;
END Has_Mixed_Cond_Codes___;
   

FUNCTION Get_Handling_Unit_Id_Tab___ (
   handling_unit_id_list_ IN VARCHAR2 ) RETURN Handling_Unit_Id_Tab
IS
   separator_position_          NUMBER;
   local_handling_unit_id_list_ VARCHAR2(32000);
   index_                       BINARY_INTEGER := 0;
   handling_unit_id_tab_        Handling_Unit_Id_Tab;
BEGIN
   local_handling_unit_id_list_ := handling_unit_id_list_;
   WHILE (local_handling_unit_id_list_ IS NOT NULL) LOOP
      separator_position_ := instr(local_handling_unit_id_list_, Client_SYS.record_separator_);
      IF (separator_position_ > 1) THEN
         handling_unit_id_tab_(index_).handling_unit_id  := substr(local_handling_unit_id_list_, 1, separator_position_ - 1);
         local_handling_unit_id_list_                    := substr(local_handling_unit_id_list_, separator_position_ + 1);
         index_                                          := index_ + 1;
      ELSE
         -- Handle the case where the list does not end with a separator.
         handling_unit_id_tab_(index_).handling_unit_id  := local_handling_unit_id_list_;
         local_handling_unit_id_list_ := NULL;
      END IF;
   END LOOP;

   RETURN handling_unit_id_tab_;
END Get_Handling_Unit_Id_Tab___;

   
FUNCTION Get_Node_Level_Sorted_Units___ (
   handling_unit_id_tab_ Handling_Unit_Id_Tab ) RETURN Handling_Unit_Id_Tab
IS
   sorted_handling_unit_id_tab_ Handling_Unit_Id_Tab;
   node_level_                  NUMBER;

   CURSOR get_node_level_sorted_units IS
      SELECT handling_unit_id
      FROM handling_unit_tmp
      ORDER BY node_level;
BEGIN
   DELETE FROM handling_unit_tmp;

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         node_level_ := Get_Node_Level(handling_unit_id_tab_(i).handling_unit_id);
      
         INSERT INTO handling_unit_tmp
            (handling_unit_id,
             node_level)
         VALUES
            (handling_unit_id_tab_(i).handling_unit_id,
             node_level_);
      END LOOP;
   
      OPEN get_node_level_sorted_units;
      FETCH get_node_level_sorted_units BULK COLLECT INTO sorted_handling_unit_id_tab_;
      CLOSE get_node_level_sorted_units;
   END IF;

   RETURN sorted_handling_unit_id_tab_;
END Get_Node_Level_Sorted_Units___;


FUNCTION Get_Outermost_Units_Only___ (
   handling_unit_id_tab_ Handling_Unit_Id_Tab ) RETURN Handling_Unit_Id_Tab
IS
   parent_handling_unit_id_tab_  Handling_Unit_Id_Tab;
   outermost_handl_unit_id_tab_  Handling_Unit_Id_Tab;
   counter_                      PLS_INTEGER := 0;
   parent_is_also_in_collection_ BOOLEAN;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         parent_handling_unit_id_tab_  := Get_Parent_Hand_Unit_Id_Tab___(handling_unit_id_tab_(i).handling_unit_id);
         parent_is_also_in_collection_ := FALSE;
         IF (parent_handling_unit_id_tab_.COUNT > 0) THEN
            FOR j IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
               FOR k IN parent_handling_unit_id_tab_.FIRST..parent_handling_unit_id_tab_.LAST LOOP
                  IF (parent_handling_unit_id_tab_(k).handling_unit_id = handling_unit_id_tab_(j).handling_unit_id) THEN
                     parent_is_also_in_collection_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
               EXIT WHEN parent_is_also_in_collection_;
            END LOOP;
         END IF;
         IF NOT (parent_is_also_in_collection_) THEN
            counter_ := counter_ + 1;
            outermost_handl_unit_id_tab_(counter_).handling_unit_id := handling_unit_id_tab_(i).handling_unit_id;
         END IF;
      END LOOP;
   END IF;
   RETURN (outermost_handl_unit_id_tab_);
END Get_Outermost_Units_Only___;
   

FUNCTION Get_Company___ (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   contract_              VARCHAR2(5);
   company_               VARCHAR2(20);
BEGIN
   contract_ := Get_Contract(handling_unit_id_); 
   IF (contract_ IS NULL) THEN
      -- If the HU structure is not on a shipment and not connected to any stock quantities, then use the default company of the session user.
      company_ := User_Finance_API.Get_Default_Company_Func;
   ELSE
      -- The HU structure was either on a shipment or in stock. Use the company of the site.
      company_ := Site_API.Get_Company(contract_);
   END IF;      

   RETURN (company_);
END Get_Company___;


FUNCTION Get_Uom_For_Unit_Type___ (
   handling_unit_id_ IN NUMBER,
   iso_unit_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   uom_         VARCHAR2(30); 
   company_     VARCHAR2(20);
   company_rec_ Company_Invent_Info_API.Public_Rec;
BEGIN
   company_     := Get_Company___(handling_unit_id_);
   company_rec_ := Company_Invent_Info_API.Get(company_);
   uom_         := CASE iso_unit_type_db_
                      WHEN Iso_Unit_Type_API.DB_VOLUME THEN company_rec_.uom_for_volume
                      WHEN Iso_Unit_Type_API.DB_WEIGHT THEN company_rec_.uom_for_weight
                   END;

   RETURN (uom_);
END Get_Uom_For_Unit_Type___;


PROCEDURE Convert_Weight_And_Volume___ (
   handling_unit_id_ IN handling_unit_tab.handling_unit_id%TYPE,
   from_company_rec_ IN Company_Invent_Info_API.Public_Rec,
   to_company_rec_   IN Company_Invent_Info_API.Public_Rec )
IS
   handling_unit_rec_ handling_unit_tab%ROWTYPE;
   modify_            BOOLEAN := FALSE;
BEGIN
   handling_unit_rec_ := Lock_By_Keys___(handling_unit_id_);
   IF (handling_unit_rec_.manual_volume IS NOT NULL) THEN
      modify_                          := TRUE;
      handling_unit_rec_.manual_volume := Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.manual_volume,
                                                                                   from_company_rec_.uom_for_volume,
                                                                                   to_company_rec_.uom_for_volume);
   END IF;
   IF (handling_unit_rec_.manual_gross_weight IS NOT NULL) THEN
      modify_                                := TRUE;
      handling_unit_rec_.manual_gross_weight := Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_rec_.manual_gross_weight,
                                                                                         from_company_rec_.uom_for_weight,
                                                                                         to_company_rec_.uom_for_weight);
   END IF;
   IF (modify_) THEN
      Modify___(handling_unit_rec_);
   END IF;
END Convert_Weight_And_Volume___;


PROCEDURE Get_Weight_Vol_Convert_Info___ (
   weight_conversion_needed_ OUT BOOLEAN,
   volume_conversion_needed_ OUT BOOLEAN,
   from_company_rec_         OUT Company_Invent_Info_API.Public_Rec,
   to_company_rec_           OUT Company_Invent_Info_API.Public_Rec,
   stock_operation_id_       IN  NUMBER,
   from_contract_            IN  VARCHAR2,
   to_contract_              IN  VARCHAR2 )
IS
   from_company_ VARCHAR2(20);
   to_company_   VARCHAR2(20);
BEGIN
   weight_conversion_needed_ := FALSE;
   volume_conversion_needed_ := FALSE;
   IF ((stock_operation_id_ = change_stock_location_) AND (from_contract_ != to_contract_)) THEN
      -- Move between two sites
      from_company_ := Site_API.Get_Company(from_contract_);
      to_company_   := Site_API.Get_Company(to_contract_);
      IF (to_company_ != from_company_) THEN
         -- Move between two companies
         from_company_rec_         := Company_Invent_Info_API.Get(from_company_);
         to_company_rec_           := Company_Invent_Info_API.Get(to_company_);
         weight_conversion_needed_ := CASE to_company_rec_.uom_for_weight WHEN from_company_rec_.uom_for_weight THEN FALSE ELSE TRUE END;
         volume_conversion_needed_ := CASE to_company_rec_.uom_for_volume WHEN from_company_rec_.uom_for_volume THEN FALSE ELSE TRUE END;
      END IF;
   END IF;
END Get_Weight_Vol_Convert_Info___;

                
PROCEDURE Perform_Stock_Operat_Invent___(
   out_parameter1_               OUT VARCHAR2,
   stock_exist_in_structure_     OUT BOOLEAN,
   handling_unit_id_             IN NUMBER,
   stock_operation_id_           IN NUMBER,
   string_parameter1_            IN VARCHAR2,
   string_parameter2_            IN VARCHAR2,
   string_parameter3_            IN VARCHAR2,
   string_parameter4_            IN VARCHAR2,
   string_parameter5_            IN VARCHAR2,
   string_parameter6_            IN VARCHAR2,
   string_parameter7_            IN VARCHAR2,
   string_parameter8_            IN VARCHAR2,
   string_parameter9_            IN VARCHAR2,
   string_parameter10_           IN VARCHAR2,
   string_parameter11_           IN VARCHAR2,
   date_parameter1_              IN DATE,
   number_parameter1_            IN NUMBER,
   number_parameter2_            IN NUMBER,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref_type_              IN VARCHAR2,
   contract_                     IN VARCHAR2,
   ownership_transfer_reason_id_ IN VARCHAR2)
IS 
   handling_unit_tab_           Handling_Unit_Id_Tab;
   dummy_number_                NUMBER;
   session_id_                  NUMBER;
   dummy_char_                  VARCHAR2(2000);
   qty_counted_                 NUMBER;
   catch_qty_counted_           NUMBER;
   counting_result_rejected_    BOOLEAN := FALSE;
   weight_conversion_needed_    BOOLEAN := FALSE;
   volume_conversion_needed_    BOOLEAN := FALSE;
   from_company_rec_            Company_Invent_Info_API.Public_Rec;
   to_company_rec_              Company_Invent_Info_API.Public_Rec;

   CURSOR get_stock_records (handling_unit_id_ IN VARCHAR2) IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, qty_onhand, catch_qty_onhand, qty_reserved, qty_in_transit, expiration_date,
             owning_customer_no, location_type
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id = handling_unit_id_
         AND (qty_onhand != 0 OR qty_in_transit != 0);
         
   TYPE Stock_Record_Tab IS TABLE OF get_stock_records%ROWTYPE;
   stock_record_tab_ Stock_Record_Tab;
BEGIN
   Get_Weight_Vol_Convert_Info___(weight_conversion_needed_, volume_conversion_needed_, from_company_rec_, to_company_rec_, stock_operation_id_, contract_, string_parameter1_);
   
   handling_unit_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP

      IF (weight_conversion_needed_ OR volume_conversion_needed_) THEN
         Convert_Weight_And_Volume___(handling_unit_tab_(i).handling_unit_id, from_company_rec_, to_company_rec_);
      END IF;

      OPEN  get_stock_records(handling_unit_tab_(i).handling_unit_id);
      FETCH get_stock_records BULK COLLECT INTO stock_record_tab_;
      CLOSE get_stock_records;
 
      IF (stock_record_tab_.COUNT > 0) THEN
         stock_exist_in_structure_ := TRUE;
         FOR j IN stock_record_tab_.FIRST..stock_record_tab_.LAST LOOP

            CASE (stock_operation_id_)
               WHEN (modify_waiv_dev_rej_no_) THEN
                  IF (stock_record_tab_(j).qty_reserved != 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HURESERVEDWDR: Cannot change W/D/R No for all stock in handling unit :P1 on location :P2 since there is a reserved quantity for part :P3.',
                                                                       stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  Inventory_Part_In_Stock_API.Change_Waiv_Dev_Rej_No(contract_           => stock_record_tab_(j).contract,
                                                                     part_no_            => stock_record_tab_(j).part_no,
                                                                     configuration_id_   => stock_record_tab_(j).configuration_id,
                                                                     location_no_        => stock_record_tab_(j).location_no,
                                                                     lot_batch_no_       => stock_record_tab_(j).lot_batch_no,
                                                                     serial_no_          => stock_record_tab_(j).serial_no,
                                                                     eng_chg_level_      => stock_record_tab_(j).eng_chg_level,
                                                                     waiv_dev_rej_no_    => stock_record_tab_(j).waiv_dev_rej_no,
                                                                     activity_seq_       => stock_record_tab_(j).activity_seq,
                                                                     handling_unit_id_   => stock_record_tab_(j).handling_unit_id,
                                                                     to_waiv_dev_rej_no_ => string_parameter1_,
                                                                     quantity_           => stock_record_tab_(j).qty_onhand,
                                                                     catch_quantity_     => stock_record_tab_(j).catch_qty_onhand,
                                                                     order_no_           => source_ref1_,
                                                                     release_no_         => source_ref2_,
                                                                     sequence_no_        => source_ref3_,
                                                                     line_item_no_       => source_ref4_,
                                                                     order_type_         => source_ref_type_);
               WHEN (modify_availability_ctrl_id_) THEN
                  Inventory_Part_In_Stock_API.Modify_Availability_Control_Id(contract_                => stock_record_tab_(j).contract,
                                                                             part_no_                 => stock_record_tab_(j).part_no,
                                                                             configuration_id_        => stock_record_tab_(j).configuration_id,
                                                                             location_no_             => stock_record_tab_(j).location_no,
                                                                             lot_batch_no_            => stock_record_tab_(j).lot_batch_no,
                                                                             serial_no_               => stock_record_tab_(j).serial_no,
                                                                             eng_chg_level_           => stock_record_tab_(j).eng_chg_level,
                                                                             waiv_dev_rej_no_         => stock_record_tab_(j).waiv_dev_rej_no,
                                                                             activity_seq_            => stock_record_tab_(j).activity_seq,
                                                                             handling_unit_id_        => stock_record_tab_(j).handling_unit_id,
                                                                             availability_control_id_ => string_parameter1_);
               WHEN (modify_expiration_date_) THEN
                  Inventory_Part_In_Stock_API.Modify_Expiration_Date(contract_         => stock_record_tab_(j).contract,
                                                                     part_no_          => stock_record_tab_(j).part_no,
                                                                     configuration_id_ => stock_record_tab_(j).configuration_id,
                                                                     location_no_      => stock_record_tab_(j).location_no,
                                                                     lot_batch_no_     => stock_record_tab_(j).lot_batch_no,
                                                                     serial_no_        => stock_record_tab_(j).serial_no,
                                                                     eng_chg_level_    => stock_record_tab_(j).eng_chg_level,
                                                                     waiv_dev_rej_no_  => stock_record_tab_(j).waiv_dev_rej_no,
                                                                     activity_seq_     => stock_record_tab_(j).activity_seq,
                                                                     handling_unit_id_ => stock_record_tab_(j).handling_unit_id,
                                                                     expiration_date_  => date_parameter1_);
               WHEN (scrap_) THEN
                  IF (stock_record_tab_(j).qty_reserved != 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HURESERVEDSCRAP: Cannot scrap all stock in handling unit :P1 on location :P2 since there is a reserved quantity for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  IF (stock_record_tab_(j).qty_in_transit != 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HURTRANSITSCRAP: Cannot scrap all stock in handling unit :P1 on location :P2 since there is a quantity in transit for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  Inventory_Part_In_Stock_API.Scrap_Part(catch_quantity_                => dummy_number_,
                                                         contract_                      => stock_record_tab_(j).contract,             
                                                         part_no_                       => stock_record_tab_(j).part_no,              
                                                         configuration_id_              => stock_record_tab_(j).configuration_id,     
                                                         location_no_                   => stock_record_tab_(j).location_no,          
                                                         lot_batch_no_                  => stock_record_tab_(j).lot_batch_no,         
                                                         serial_no_                     => stock_record_tab_(j).serial_no,            
                                                         eng_chg_level_                 => stock_record_tab_(j).eng_chg_level,        
                                                         waiv_dev_rej_no_               => stock_record_tab_(j).waiv_dev_rej_no,      
                                                         activity_seq_                  => stock_record_tab_(j).activity_seq,         
                                                         handling_unit_id_              => stock_record_tab_(j).handling_unit_id,     
                                                         quantity_                      => stock_record_tab_(j).qty_onhand,
                                                         scrap_cause_                   => string_parameter1_,
                                                         scrap_note_                    => string_parameter2_,
                                                         order_no_                      => source_ref1_,
                                                         release_no_                    => source_ref2_,
                                                         sequence_no_                   => source_ref3_,
                                                         line_item_no_                  => source_ref4_,
                                                         order_type_                    => source_ref_type_,
                                                         discon_zero_stock_handl_unit_  => FALSE,
                                                         print_serviceability_tag_db_   => string_parameter3_);
               WHEN (issue_with_posting_) THEN
                  IF (stock_record_tab_(j).qty_reserved != 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HURESERVEDIWP: Cannot issue all stock in handling unit :P1 on location :P2 since there is a reserved quantity for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  IF (stock_record_tab_(j).qty_in_transit != 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HURTRANSITIWP: Cannot issue all stock in handling unit :P1 on location :P2 since there is a quantity in transit for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  IF (stock_record_tab_(j).qty_onhand < 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HUONHANDIWP: Cannot issue all stock in handling unit :P1 on location :P2 since there is a negative quantity on hand for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  Inventory_Part_In_Stock_API.Issue_Part_With_Posting(contract_                     => stock_record_tab_(j).contract,            
                                                                      part_no_                      => stock_record_tab_(j).part_no,             
                                                                      configuration_id_             => stock_record_tab_(j).configuration_id,    
                                                                      location_no_                  => stock_record_tab_(j).location_no,         
                                                                      lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,        
                                                                      serial_no_                    => stock_record_tab_(j).serial_no,           
                                                                      eng_chg_level_                => stock_record_tab_(j).eng_chg_level,       
                                                                      waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no,     
                                                                      activity_seq_                 => stock_record_tab_(j).activity_seq,        
                                                                      handling_unit_id_             => stock_record_tab_(j).handling_unit_id,    
                                                                      transaction_                  => 'NISS',
                                                                      quantity_                     => stock_record_tab_(j).qty_onhand,
                                                                      catch_quantity_               => stock_record_tab_(j).catch_qty_onhand,
                                                                      account_no_                   => string_parameter1_,  
                                                                      code_b_                       => string_parameter2_,  
                                                                      code_c_                       => string_parameter3_,  
                                                                      code_d_                       => string_parameter4_,  
                                                                      code_e_                       => string_parameter5_,  
                                                                      code_f_                       => string_parameter6_,  
                                                                      code_g_                       => string_parameter7_,  
                                                                      code_h_                       => string_parameter8_,  
                                                                      code_i_                       => string_parameter9_,  
                                                                      code_j_                       => string_parameter10_, 
                                                                      source_                       => string_parameter11_,
                                                                      part_tracking_session_id_     => NULL,
                                                                      discon_zero_stock_handl_unit_ => FALSE);
               WHEN (change_stock_location_) THEN
                  IF (stock_record_tab_(j).qty_in_transit != 0) THEN
                      Error_SYS.Record_General(lu_name_, 'HUTRANSITMOVE: Cannot move all stock in handling unit :P1 away from location :P2 since there is a quantity in transit for part :P3.',
                                               stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;
                  IF (stock_record_tab_(j).qty_onhand < 0) THEN
                     Error_SYS.Record_General(lu_name_, 'HUONHANDMOVE: Cannot move all stock in handling unit :P1 away from location :P2 since there is a negative quantity on hand for part :P3.',
                                              stock_record_tab_(j).handling_unit_id, stock_record_tab_(j).location_no, stock_record_tab_(j).part_no);
                  END IF;                                    
                  Invent_Part_Quantity_Util_API.Move_Part(unattached_from_handling_unit_ => dummy_char_,
                                                          catch_quantity_                => stock_record_tab_(j).catch_qty_onhand,
                                                          contract_                      => stock_record_tab_(j).contract,
                                                          part_no_                       => stock_record_tab_(j).part_no,
                                                          configuration_id_              => stock_record_tab_(j).configuration_id,
                                                          location_no_                   => stock_record_tab_(j).location_no,
                                                          lot_batch_no_                  => stock_record_tab_(j).lot_batch_no,     
                                                          serial_no_                     => stock_record_tab_(j).serial_no,
                                                          eng_chg_level_                 => stock_record_tab_(j).eng_chg_level,    
                                                          waiv_dev_rej_no_               => stock_record_tab_(j).waiv_dev_rej_no,  
                                                          activity_seq_                  => stock_record_tab_(j).activity_seq,
                                                          handling_unit_id_              => stock_record_tab_(j).handling_unit_id, 
                                                          expiration_date_               => stock_record_tab_(j).expiration_date,
                                                          to_contract_                   => string_parameter1_,
                                                          to_location_no_                => string_parameter2_,
                                                          to_destination_                => string_parameter3_,
                                                          quantity_                      => stock_record_tab_(j).qty_onhand,
                                                          quantity_reserved_             => 0,
                                                          move_comment_                  => string_parameter4_,
                                                          order_no_                      => string_parameter5_,
                                                          release_no_                    => string_parameter6_,
                                                          sequence_no_                   => string_parameter7_,
                                                          line_item_no_                  => string_parameter8_,
                                                          order_type_                    => string_parameter9_,
                                                          consume_consignment_stock_     => string_parameter10_,
                                                          to_waiv_dev_rej_no_            => string_parameter11_,
                                                          part_tracking_session_id_      => number_parameter1_,
                                                          transport_task_id_             => number_parameter2_,
                                                          validate_hu_struct_position_   => FALSE );                                                        
               WHEN (change_ownership_btwn_cust_) THEN
                  -- Only change owner on the once that are not already changed
                  IF (stock_record_tab_(j).owning_customer_no != string_parameter1_) THEN
                     Inventory_Part_In_Stock_API.Modify_Owning_Customer_No(contract_                     => stock_record_tab_(j).contract,
                                                                           part_no_                      => stock_record_tab_(j).part_no,
                                                                           configuration_id_             => stock_record_tab_(j).configuration_id,
                                                                           location_no_                  => stock_record_tab_(j).location_no,
                                                                           lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,
                                                                           serial_no_                    => stock_record_tab_(j).serial_no,
                                                                           eng_chg_level_                => stock_record_tab_(j).eng_chg_level,
                                                                           waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no,
                                                                           activity_seq_                 => stock_record_tab_(j).activity_seq,
                                                                           handling_unit_id_             => stock_record_tab_(j).handling_unit_id,
                                                                           owning_customer_              => string_parameter1_,
                                                                           part_tracking_session_id_     => number_parameter1_,
                                                                           ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
                  END IF;
                  WHEN (change_ownership_to_company_) THEN

                  $IF Component_Purch_SYS.INSTALLED $THEN
                     Temporary_Part_Ownership_API.Create_New(session_id_                   => session_id_,
                                                             contract_                     => stock_record_tab_(j).contract,
                                                             part_no_                      => stock_record_tab_(j).part_no,
                                                             configuration_id_             => stock_record_tab_(j).configuration_id,
                                                             location_no_                  => stock_record_tab_(j).location_no,
                                                             lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,
                                                             serial_no_                    => stock_record_tab_(j).serial_no,
                                                             eng_chg_level_                => stock_record_tab_(j).eng_chg_level,
                                                             waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no,
                                                             activity_seq_                 => stock_record_tab_(j).activity_seq,
                                                             handling_unit_id_             => stock_record_tab_(j).handling_unit_id,
                                                             condition_code_               => Condition_Code_Manager_API.Get_Condition_Code(part_no_      => stock_record_tab_(j).part_no,
                                                                                                                                 serial_no_    => stock_record_tab_(j).serial_no,
                                                                                                                                 lot_batch_no_ => stock_record_tab_(j).lot_batch_no),
                                                             qty_                          => stock_record_tab_(j).qty_onhand,
                                                             temp_tab_complete_            => 'FALSE',
                                                             ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
                  $ELSE
                     NULL;
                  $END
               WHEN (receive_from_invent_transit_) THEN
                  Inventory_Part_In_Stock_API.Receive_Part_From_Transit(dummy_char_, 
                                                                        contract_                     => stock_record_tab_(j).contract,
                                                                        part_no_                      => stock_record_tab_(j).part_no,
                                                                        configuration_id_             => stock_record_tab_(j).configuration_id,
                                                                        location_no_                  => stock_record_tab_(j).location_no,
                                                                        lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,
                                                                        serial_no_                    => stock_record_tab_(j).serial_no,
                                                                        eng_chg_level_                => stock_record_tab_(j).eng_chg_level,
                                                                        waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no,
                                                                        activity_seq_                 => stock_record_tab_(j).activity_seq,
                                                                        handling_unit_id_             => stock_record_tab_(j).handling_unit_id,
                                                                        quantity_                     => stock_record_tab_(j).qty_in_transit, 
                                                                        catch_quantity_               => NULL,
                                                                        validate_hu_struct_position_  => FALSE);
               WHEN (transfer_to_proj_inventory_) THEN
                  IF (stock_record_tab_(j).qty_onhand - stock_record_tab_(j).qty_reserved > 0 
                      AND stock_record_tab_(j).location_type NOT IN ('ARRIVAL','QA')
                      AND stock_record_tab_(j).activity_seq != string_parameter1_) THEN
                     Inventory_Part_In_Stock_API.Move_Part_Project(contract_                     => stock_record_tab_(j).contract,
                                                                   part_no_                      => stock_record_tab_(j).part_no,
                                                                   configuration_id_             => stock_record_tab_(j).configuration_id,
                                                                   location_no_                  => stock_record_tab_(j).location_no,
                                                                   lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,
                                                                   serial_no_                    => stock_record_tab_(j).serial_no,
                                                                   eng_chg_level_                => stock_record_tab_(j).eng_chg_level, 
                                                                   waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no, 
                                                                   activity_seq_                 => stock_record_tab_(j).activity_seq, 
                                                                   handling_unit_id_             => stock_record_tab_(j).handling_unit_id, 
                                                                   expiration_date_              => stock_record_tab_(j).expiration_date,
                                                                   to_activity_seq_              => string_parameter1_,
                                                                   quantity_                     => (stock_record_tab_(j).qty_onhand - stock_record_tab_(j).qty_reserved),
                                                                   quantity_reserved_            => 0,
                                                                   move_comment_                 => string_parameter2_,
                                                                   report_earned_value_db_       => string_parameter3_,
                                                                   ownership_transfer_reason_id_ => NULL);
                  END IF;
               WHEN (transfer_to_std_inventory_) THEN
                  IF (stock_record_tab_(j).activity_seq != 0 AND stock_record_tab_(j).qty_onhand - stock_record_tab_(j).qty_reserved > 0 
                      AND stock_record_tab_(j).location_type NOT IN ('ARRIVAL','QA')) THEN
                     Inventory_Part_In_Stock_API.Move_Part_Project(contract_                     => stock_record_tab_(j).contract,
                                                                   part_no_                      => stock_record_tab_(j).part_no,
                                                                   configuration_id_             => stock_record_tab_(j).configuration_id,
                                                                   location_no_                  => stock_record_tab_(j).location_no,
                                                                   lot_batch_no_                 => stock_record_tab_(j).lot_batch_no,
                                                                   serial_no_                    => stock_record_tab_(j).serial_no,
                                                                   eng_chg_level_                => stock_record_tab_(j).eng_chg_level, 
                                                                   waiv_dev_rej_no_              => stock_record_tab_(j).waiv_dev_rej_no, 
                                                                   activity_seq_                 => stock_record_tab_(j).activity_seq, 
                                                                   handling_unit_id_             => stock_record_tab_(j).handling_unit_id, 
                                                                   expiration_date_              => stock_record_tab_(j).expiration_date,
                                                                   to_activity_seq_              => 0,
                                                                   quantity_                     => (stock_record_tab_(j).qty_onhand - stock_record_tab_(j).qty_reserved),
                                                                   quantity_reserved_            => 0,
                                                                   move_comment_                 => string_parameter1_,
                                                                   report_earned_value_db_       => string_parameter2_,
                                                                   ownership_transfer_reason_id_ => NULL);
                  END IF;
               WHEN (report_counting_result_) THEN
                  IF (string_parameter2_ = Fnd_Boolean_API.DB_TRUE) THEN
                     -- Count down to zero
                     qty_counted_       := 0;
                     catch_qty_counted_ := 0;
                  ELSE
                     qty_counted_       := stock_record_tab_(j).qty_onhand;
                     catch_qty_counted_ := stock_record_tab_(j).catch_qty_onhand;
                  END IF;

                  Counting_Result_API.New_Result(tot_qty_onhand_           => dummy_number_,
                                                 tot_qty_reserved_         => dummy_number_,
                                                 tot_qty_in_transit_       => dummy_number_,
                                                 tot_qty_in_order_transit_ => dummy_number_,
                                                 acc_count_diff_           => dummy_number_,
                                                 state_                    => out_parameter1_,
                                                 contract_                 => stock_record_tab_(j).contract,
                                                 part_no_                  => stock_record_tab_(j).part_no,
                                                 configuration_id_         => stock_record_tab_(j).configuration_id,
                                                 location_no_              => stock_record_tab_(j).location_no,
                                                 lot_batch_no_             => stock_record_tab_(j).lot_batch_no,
                                                 serial_no_                => stock_record_tab_(j).serial_no,
                                                 eng_chg_level_            => stock_record_tab_(j).eng_chg_level,
                                                 waiv_dev_rej_no_          => stock_record_tab_(j).waiv_dev_rej_no,
                                                 activity_seq_             => stock_record_tab_(j).activity_seq,
                                                 handling_unit_id_         => stock_record_tab_(j).handling_unit_id,
                                                 count_date_               => NULL,
                                                 inv_list_no_              => NULL,
                                                 seq_                      => NULL,
                                                 qty_onhand_               => stock_record_tab_(j).qty_onhand,
                                                 qty_counted_              => qty_counted_,
                                                 catch_qty_onhand_         => stock_record_tab_(j).catch_qty_onhand,
                                                 catch_qty_counted_        => catch_qty_counted_,
                                                 count_user_id_            => NULL,
                                                 inventory_value_          => NULL,
                                                 condition_code_           => '',
                                                 note_text_                => string_parameter1_,
                                                 cost_detail_id_           => NULL);
                  IF (out_parameter1_ = 'Rejected') THEN
                     counting_result_rejected_ := TRUE;
                  END IF;    
            END CASE;
         END LOOP;
      END IF;     
   END LOOP; 
   IF (stock_operation_id_ = report_counting_result_ AND counting_result_rejected_) THEN
      out_parameter1_ := 'Rejected';
   END IF;

   IF ((stock_operation_id_ = change_ownership_to_company_) AND (session_id_ IS NOT NULL)) THEN
      -- When the last line has been sent temp_tab_complete_ 'TRUE' needs to be sent to do the actual transfer.
      $IF Component_Purch_SYS.INSTALLED $THEN
         Temporary_Part_Ownership_API.Create_New(session_id_        => session_id_,
                                                 contract_          => NULL,
                                                 part_no_           => NULL,
                                                 configuration_id_  => NULL,
                                                 location_no_       => NULL,
                                                 lot_batch_no_      => NULL,
                                                 serial_no_         => NULL,
                                                 eng_chg_level_     => NULL,
                                                 waiv_dev_rej_no_   => NULL,
                                                 activity_seq_      => NULL,
                                                 handling_unit_id_  => NULL,
                                                 condition_code_    => NULL,
                                                 qty_               => NULL,
                                                 temp_tab_complete_ => 'TRUE');
      $ELSE
         Error_SYS.Component_Not_Exist('PURCH');
      $END
   END IF;

END Perform_Stock_Operat_Invent___;


FUNCTION Src_Ref_Type_To_Order_Type___ (
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   order_type_ VARCHAR2(25);
BEGIN
   order_type_ := 
      CASE source_ref_type_db_
         WHEN Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER THEN Order_Type_API.DB_SHOP_ORDER
         WHEN Handl_Unit_Source_Ref_Type_API.DB_PRODUCTION_SCHEDULE THEN Order_Type_API.DB_PRODUCTION_SCHEDULE 
      END;
  RETURN order_type_;
END Src_Ref_Type_To_Order_Type___;


FUNCTION Get_Content_Volume___ (
   handling_unit_id_ IN NUMBER,
   uom_for_volume_   IN VARCHAR2 ) RETURN NUMBER
IS
   lu_rec_                        handling_unit_tab%ROWTYPE; 
   handling_unit_type_rec_        Handling_Unit_Type_API.Public_Rec;
   handling_unit_tab_             Handling_Unit_Id_Tab;
   content_volume_                NUMBER;
   operative_volume_              NUMBER;
   handling_unit_type_volume_     NUMBER;
   has_additive_volume_accessory_ BOOLEAN;
BEGIN
   lu_rec_                        := Get_Object_By_Keys___(handling_unit_id_);
   handling_unit_type_rec_        := Handling_Unit_Type_API.Get(lu_rec_.handling_unit_type_id);
   has_additive_volume_accessory_ := Accessory_On_Handling_Unit_API.Contains_Additive_Volume(handling_unit_id_);

   IF ((handling_unit_type_rec_.additive_volume = Fnd_Boolean_API.DB_FALSE) OR (has_additive_volume_accessory_)) THEN
      -- this is the content volume calculation for a handling unit this has a fixed outer volume, either because the handling unit type itself
      -- indicate that it is of a non-additive type or because there is an accessory of additive type connected (that gives a fixed outer volume).
      -- Getting the volume of non-additive accessories like packing beans:
      content_volume_ :=  Accessory_On_Handling_Unit_API.Get_Connected_Accessory_Volume(handling_unit_id_  => handling_unit_id_,
                                                                                        uom_for_volume_    => uom_for_volume_,
                                                                                        additive_volume_   => Fnd_Boolean_API.DB_FALSE);
      handling_unit_tab_ := Get_Children___(handling_unit_id_);
      IF (handling_unit_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
            -- Adding the volume of all handling units packed into this one:
            content_volume_ := content_volume_ + Get_Operative_Volume(handling_unit_id_ => handling_unit_tab_(i).handling_unit_id,
                                                                      uom_for_volume_   => uom_for_volume_);
         END LOOP;
      END IF;

      IF (lu_rec_.shipment_id IS NULL) THEN
         -- Adding the volume of all parts packed directly into this handling unit:
         content_volume_ := content_volume_ + Get_Part_Volume_This_Level___(handling_unit_id_  => handling_unit_id_,
                                                                            uom_for_volume_    => uom_for_volume_);
      ELSE
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            content_volume_ := content_volume_ + Shipment_Line_Handl_Unit_API.Get_Connected_Part_Volume(shipment_id_         => lu_rec_.shipment_id,
                                                                                                        handling_unit_id_    => handling_unit_id_, 
                                                                                                        uom_for_volume_      => uom_for_volume_);  
         $ELSE
            NULL;
         $END
      END IF;
   ELSE
      -- This is a handling unit with additive volume (typically a pallet) that does not have any additive volume accessories (typically pallet collars).
      -- Calculate content volume as operative volume minus the volume of the handling unit type
      operative_volume_ := Get_Operative_Volume(handling_unit_id_, uom_for_volume_);
      IF (uom_for_volume_ != handling_unit_type_rec_.uom_for_volume) THEN
         handling_unit_type_volume_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => NVL(handling_unit_type_rec_.volume, 0),
                                                                                from_unit_code_   => handling_unit_type_rec_.uom_for_volume,
                                                                                to_unit_code_     => uom_for_volume_); 
      ELSE
         handling_unit_type_volume_ := NVL(handling_unit_type_rec_.volume, 0);
      END IF;
      content_volume_ := operative_volume_ - handling_unit_type_volume_;
   END IF;

   RETURN content_volume_;
END Get_Content_Volume___;


FUNCTION Get_Content_Weight___ (
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2 ) RETURN NUMBER
IS   
   operative_gross_weight_ NUMBER;
   hu_type_tare_weight_    NUMBER;
BEGIN
   -- Content weight is calculated as the operative gross weight minus the tare weight of the handling unit type (i.e. the weight of the empty pallet or box). 
   operative_gross_weight_  := Get_Operative_Gross_Weight(handling_unit_id_, uom_for_weight_);
   hu_type_tare_weight_     := Get_Hu_Type_Tare_Weight___(handling_unit_id_, uom_for_weight_);

   RETURN (operative_gross_weight_ - hu_type_tare_weight_);
END Get_Content_Weight___;


@Override   
PROCEDURE Check_Delete___ (
   remrec_ IN handling_unit_tab%ROWTYPE )
IS
   count_ NUMBER;
BEGIN
   -- The below code segment is added to manually check for the usage of a perticular handling unit in the reference tables
   -- to improve performance, since this would be faster than the standard framework implementation of having a RESTRICTED reference 
   -- and letting Reference_SYS.Check_Restricted_Delete to perform the checks. Also to make this correction work the respective LUs
   -- should have NOCHECK reference to the HandlingUnit entity. 
   count_ := Inventory_Part_At_Customer_API.Get_Handling_Unit_Row_Count(remrec_.handling_unit_id);
   IF count_ > 0 THEN
      Raise_Record_Delete_Error___(lu_name_, Inventory_Part_At_Customer_API.lu_name_, count_, remrec_.handling_unit_id); 
   END IF;
   
   count_ := Inventory_Part_In_Stock_API.Get_Handling_Unit_Row_Count(remrec_.handling_unit_id);
   IF count_ > 0 THEN
      Raise_Record_Delete_Error___(lu_name_, Inventory_Part_In_Stock_API.lu_name_, count_, remrec_.handling_unit_id); 
   END IF;
   
   count_ := Inventory_Part_In_Transit_API.Get_Handling_Unit_Row_Count(remrec_.handling_unit_id);
   IF count_ > 0 THEN
      Raise_Record_Delete_Error___(lu_name_, Inventory_Part_In_Transit_API.lu_name_, count_, remrec_.handling_unit_id);
   END IF;
   
   count_ := Inventory_Transaction_Hist_API.Get_Handling_Unit_Row_Count(remrec_.handling_unit_id);
   IF count_ > 0 THEN
      Raise_Record_Delete_Error___(lu_name_, Inventory_Transaction_Hist_API.lu_name_, count_, remrec_.handling_unit_id);
   END IF;        
   
   super(remrec_);
END Check_Delete___;

-- This method is used to provide the same error message provided by the framework 
-- on a similar senario.
PROCEDURE Raise_Record_Delete_Error___ (
   lu_name_          IN VARCHAR2,
   used_lu_          IN VARCHAR2,
   count_            IN VARCHAR2,
   handling_unit_id_ IN NUMBER)
IS   
   ref_prompt_      VARCHAR2(2000);
BEGIN   
   ref_prompt_ := Language_SYS.Translate_Lu_Prompt_(used_lu_);
   Error_SYS.Record_Constraint(lu_name_, ref_prompt_, to_char(count_), NULL, to_char(handling_unit_id_));
    
END Raise_Record_Delete_Error___;


PROCEDURE Validate_Max_Capacity___ (
   info_             OUT VARCHAR2,
   handling_unit_id_ IN  NUMBER,
   throw_exception_  IN  BOOLEAN ) 
IS
   handling_unit_id_tab_       Handling_Unit_Id_Tab;
   max_volume_capacity_        NUMBER;
   content_volume_             NUMBER;
   max_weight_capacity_        NUMBER;
   content_weight_             NUMBER;
   handling_unit_type_id_      handling_unit_tab.handling_unit_type_id%TYPE;
   handling_unit_id_and_type_  VARCHAR2(100);
   uom_for_volume_             VARCHAR2(30);
   uom_for_weight_             VARCHAR2(30);
   content_minus_capacity_str_ VARCHAR2(1000);
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Ascendants(handling_unit_id_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         -- Volume Start
         uom_for_volume_      := Get_Uom_For_Volume(handling_unit_id_tab_(i).handling_unit_id);
         max_volume_capacity_ := Get_Max_Volume_Capacity(handling_unit_id_tab_(i).handling_unit_id, uom_for_volume_);
         IF (max_volume_capacity_ IS NOT NULL) THEN
            content_volume_ := Get_Content_Volume___(handling_unit_id_tab_(i).handling_unit_id, uom_for_volume_);
            IF (content_volume_ > max_volume_capacity_) THEN
               handling_unit_type_id_      := Get_Handling_Unit_Type_Id(handling_unit_id_tab_(i).handling_unit_id);
               handling_unit_id_and_type_  := handling_unit_id_tab_(i).handling_unit_id ||' ('||handling_unit_type_id_||')';
               content_minus_capacity_str_ := content_volume_ - max_volume_capacity_;
               IF ((content_volume_ - max_volume_capacity_) < 1) THEN
                  content_minus_capacity_str_ := '0'||content_minus_capacity_str_;
               END IF;
               IF (throw_exception_) THEN
                  Error_SYS.Record_General('HandlingUnit', 'MAXVOLUMEEXCEED: Content volume for handling unit :P1 is :P2 :P3 above the max volume capacity.', handling_unit_id_and_type_, content_minus_capacity_str_, uom_for_volume_);
               END IF;
               Client_SYS.Add_Info        ('HandlingUnit', 'MAXVOLUMEEXCEED: Content volume for handling unit :P1 is :P2 :P3 above the max volume capacity.', handling_unit_id_and_type_, content_minus_capacity_str_, uom_for_volume_);
            END IF;
         END IF;
         -- Volume End
         -- Weight Start
         uom_for_weight_      := Get_Uom_For_Weight(handling_unit_id_tab_(i).handling_unit_id);
         max_weight_capacity_ := Get_Max_Weight_Capacity(handling_unit_id_tab_(i).handling_unit_id, uom_for_weight_);
         IF (max_weight_capacity_ IS NOT NULL) THEN
            content_weight_ := Get_Content_Weight___(handling_unit_id_tab_(i).handling_unit_id, uom_for_weight_);
            IF (content_weight_ > max_weight_capacity_) THEN
               handling_unit_type_id_      := NVL(handling_unit_type_id_, Get_Handling_Unit_Type_Id(handling_unit_id_tab_(i).handling_unit_id));
               handling_unit_id_and_type_  := handling_unit_id_tab_(i).handling_unit_id ||' ('||handling_unit_type_id_||')';
               content_minus_capacity_str_ := content_weight_ - max_weight_capacity_;
               IF ((content_weight_ - max_weight_capacity_) < 1) THEN
                  content_minus_capacity_str_ := '0'||content_minus_capacity_str_;
               END IF;
               IF (throw_exception_) THEN
                  Error_SYS.Record_General('HandlingUnit', 'MAXWEIGHTEXCEED: Content weight for handling unit :P1 is :P2 :P3 above the max weight capacity.', handling_unit_id_and_type_, content_minus_capacity_str_, uom_for_weight_);
               END IF;
               Client_SYS.Add_Info        ('HandlingUnit', 'MAXWEIGHTEXCEED: Content weight for handling unit :P1 is :P2 :P3 above the max weight capacity.', handling_unit_id_and_type_, content_minus_capacity_str_, uom_for_weight_);
            END IF;
         END IF;
         -- Weight End
         handling_unit_type_id_ := NULL;
      END LOOP;
   END IF;

   info_ := Client_SYS.Get_All_Info;
END Validate_Max_Capacity___;


FUNCTION Other_Attribute_Is_Changed___ (
   oldrec_             IN handling_unit_tab%ROWTYPE,
   newrec_             IN handling_unit_tab%ROWTYPE,
   attribute_name_tab_ IN Attribute_Name_Tab ) RETURN BOOLEAN
IS
   is_changed_ VARCHAR2(10);
   stmt_       VARCHAR2(2000);

   CURSOR get_column_names IS
      SELECT column_name
        FROM user_tab_columns
       WHERE table_name = 'HANDLING_UNIT_TAB'
         AND column_name NOT IN (SELECT * FROM TABLE (attribute_name_tab_));
BEGIN
   FOR rec_ IN get_column_names LOOP
      stmt_ := 'DECLARE
                   oldrec_ handling_unit_tab%ROWTYPE := :oldrec;
                   newrec_ handling_unit_tab%ROWTYPE := :newrec;
                BEGIN
                   IF Validate_SYS.Is_Different(oldrec_.'||rec_.column_name||', newrec_.'||rec_.column_name||') THEN
                      :is_changed := Fnd_Boolean_API.DB_TRUE;
                   END IF;
                END;';
      @ApproveDynamicStatement(2017-12-01,LEPESE)
      EXECUTE IMMEDIATE stmt_ USING IN oldrec_, IN newrec_, OUT is_changed_;
   END LOOP;
   RETURN(is_changed_ = Fnd_Boolean_API.DB_TRUE);
END Other_Attribute_Is_Changed___;

PROCEDURE Modify_Avail_Control_Id___( 
   handling_unit_id_list_   IN VARCHAR2,
   availability_control_id_ IN VARCHAR2 )
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Modify_Availability_Control_Id(handling_unit_id_          => handling_unit_id_tab_(i).handling_unit_id,
                                     availability_control_id_   => availability_control_id_);
   END LOOP;
END Modify_Avail_Control_Id___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Modify_Avail_Control_Id__ (
   attr_ IN VARCHAR2 )
IS
   handling_unit_id_list_   VARCHAR2(32000);
   availability_control_id_ VARCHAR2(25);
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(32000);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('HANDLING_UNIT_ID_LIST') THEN
         handling_unit_id_list_ := REPLACE(value_, Client_SYS.text_separator_, Client_SYS.record_separator_);
      WHEN ('AVAILABILITY_CONTROL_ID') THEN
         availability_control_id_ := value_;
      END CASE;
   END LOOP;
   
   Modify_Avail_Control_Id___(handling_unit_id_list_, availability_control_id_);
END Modify_Avail_Control_Id__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Has_Children (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_         NUMBER;
   has_children_  BOOLEAN := FALSE;
   
   CURSOR has_children IS
      SELECT 1 
      FROM  handling_unit_tab
      WHERE parent_handling_unit_id = handling_unit_id_;
BEGIN
   OPEN has_children;
   FETCH has_children INTO dummy_;
   
   IF (has_children%FOUND) THEN
      has_children_ := TRUE;
   END IF;
   
   CLOSE has_children;
   RETURN has_children_;
END Has_Children;


@UncheckedAccess
FUNCTION Is_In_Inventory_Transit (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   is_in_inventory_transit_ VARCHAR2(5);
BEGIN
   IF Is_In_Inventory_Transit___(handling_unit_id_) THEN
      is_in_inventory_transit_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      is_in_inventory_transit_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
      
   RETURN is_in_inventory_transit_;
END Is_In_Inventory_Transit;


@UncheckedAccess
FUNCTION Is_In_Transit (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   is_in_transit_ VARCHAR2(5);
BEGIN
   IF (Is_In_Inventory_Transit___(handling_unit_id_) OR 
      Inventory_Part_In_Transit_API.Handling_Unit_Exists(handling_unit_id_)) THEN
      is_in_transit_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      is_in_transit_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   RETURN is_in_transit_;
END Is_In_Transit;


@UncheckedAccess
FUNCTION Is_In_Project_Inventory (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   is_in_project_inventory_ VARCHAR2(5);
BEGIN
   IF Is_In_Project_Inventory___(handling_unit_id_) THEN
      is_in_project_inventory_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      is_in_project_inventory_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
      
   RETURN is_in_project_inventory_;
END Is_In_Project_Inventory;


@UncheckedAccess
FUNCTION Has_Parent_At_Any_Level (
   handling_unit_id_        IN NUMBER,
   parent_handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_parent_at_any_level_ VARCHAR2(5);
   rec_                    handling_unit_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(handling_unit_id_);

   IF (rec_.parent_handling_unit_id IS NULL) THEN
      has_parent_at_any_level_ := 'FALSE';
   ELSE
      IF (rec_.parent_handling_unit_id = parent_handling_unit_id_) THEN
         has_parent_at_any_level_ := 'TRUE';
      ELSE
         has_parent_at_any_level_ := Has_Parent_At_Any_Level(rec_.parent_handling_unit_id,
                                                            parent_handling_unit_id_);
      END IF;
   END IF;

   RETURN(has_parent_at_any_level_);
END Has_Parent_At_Any_Level;


PROCEDURE Remove_Structure (
   handling_unit_id_   IN NUMBER )
IS
   handling_unit_tab_        Handling_Unit_Id_Tab;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   handling_unit_tab_        := Get_Children___(handling_unit_id_);
   IF (handling_unit_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
         Remove_Structure(handling_unit_tab_(i).handling_unit_id);
      END LOOP;
   END IF;  
   Remove(handling_unit_id_);
   
   Inventory_Event_Manager_API.Finish_Session;
END Remove_Structure;


PROCEDURE Remove (
   handling_unit_id_   IN NUMBER )
IS
   remrec_ handling_unit_tab%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(handling_unit_id_);
   Check_Delete___(remrec_);
   Delete___(objid_              => NULL,
             remrec_             => remrec_);
END Remove;


-- Copy_Structure
--  Copies the handling unit and its full structure below and outputs the new handling unit
--  Optionally a parent and/or a shipment_id can be entered to have the new handling unit attached to.
PROCEDURE Copy_Structure (
   handling_unit_id_          OUT NUMBER,
   from_handling_unit_id_      IN NUMBER,
   to_parent_handling_unit_id_ IN NUMBER DEFAULT NULL,
   to_shipment_id_             IN NUMBER DEFAULT NULL)
IS
   from_rec_              handling_unit_tab%ROWTYPE;
   local_handling_unit_id_ handling_unit_tab.handling_unit_id%TYPE; 
   handling_unit_tab_     Handling_Unit_Id_Tab;   
BEGIN
   from_rec_ := Get_Object_By_Keys___(from_handling_unit_id_);

   New(handling_unit_id_,
       from_rec_.handling_unit_type_id,
       to_parent_handling_unit_id_,
       to_shipment_id_);
   
   handling_unit_tab_ := Get_Children___(from_handling_unit_id_);
   IF (handling_unit_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
         Copy_Structure(local_handling_unit_id_, handling_unit_tab_(i).handling_unit_id, handling_unit_id_, to_shipment_id_);
      END LOOP;
   END IF;
   
   IF (Accessory_On_Handling_Unit_API.Handling_Unit_Connected_Exist(from_handling_unit_id_) = Fnd_Boolean_API.DB_TRUE) THEN 
      Accessory_On_Handling_Unit_API.Copy(from_handling_unit_id_, handling_unit_id_);
   END IF;
END Copy_Structure;


PROCEDURE Modify_Shipment_Id (
   handling_unit_id_     IN NUMBER,
   shipment_id_          IN NUMBER,
   release_reservations_ IN BOOLEAN DEFAULT FALSE )
IS
   oldrec_      handling_unit_tab%ROWTYPE;
   newrec_      handling_unit_tab%ROWTYPE;
   attr_        VARCHAR2(2000);
   objid_       handling_unit.objid%TYPE;
   objversion_  handling_unit.objversion%TYPE;
   indrec_      Indicator_Rec;
BEGIN   
   oldrec_ := Lock_By_Keys___(handling_unit_id_);

   IF (oldrec_.parent_handling_unit_id IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'MODSHIPID: Modification of the shipment ID can only be done on top parent handling unit ID :P1', Get_Top_Parent_Handl_Unit_Id(handling_unit_id_));
   END IF;
   
   IF (NVL(shipment_id_, number_null_) != NVL(oldrec_.shipment_id, number_null_)) THEN
      newrec_ := oldrec_;
      newrec_.shipment_id := shipment_id_;
      indrec_ := Get_Indicator_Rec___(newrec_, oldrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, release_reservations_);
   END IF;
END Modify_Shipment_Id;


PROCEDURE Modify_Parent_Handling_Unit_Id (
   handling_unit_id_        IN NUMBER,
   parent_handling_unit_id_ IN NUMBER )
IS
   newrec_     handling_unit_tab%ROWTYPE;

   location_no_                  Inventory_Part_In_Stock_Tab.location_no%TYPE;
   parent_location_no_           Inventory_Part_In_Stock_Tab.location_no%TYPE;
   parent_shipment_no_           Handling_Unit_Tab.shipment_id%TYPE;
   shipment_state_               VARCHAR2(20);
   parent_root_handling_unit_id_ handling_unit_tab.handling_unit_id%TYPE;
   contract_                     handling_unit_tab.contract%TYPE;
   parent_contract_              handling_unit_tab.contract%TYPE;
BEGIN   
   newrec_ := Lock_By_Keys___(handling_unit_id_);
   
   IF (NVL(newrec_.parent_handling_unit_id, number_null_) != NVL(parent_handling_unit_id_, number_null_)) THEN
      IF (parent_handling_unit_id_ IS NOT NULL) THEN  
         IF (NOT Handling_Unit_API.Exists(parent_handling_unit_id_)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDPARENT: Unable to change parent to Handling Unit :P1 since it does not exist.', parent_handling_unit_id_);
         END IF;  
         
         parent_root_handling_unit_id_ := Get_Root_Handling_Unit_Id(parent_handling_unit_id_);
         
         IF (Is_In_Inventory_Transit___(Get_Root_Handling_Unit_Id(handling_unit_id_))) THEN
            Error_SYS.Record_General(lu_name_, 'ISINTRANSIT: It''s not allowed to change the parent of Handling Unit :P1 since it is in transit.', handling_unit_id_);
         ELSIF (Is_In_Inventory_Transit___(parent_root_handling_unit_id_)) THEN
            Error_SYS.Record_General(lu_name_, 'PARENTINTRANSIT: It''s not allowed to change the parent to Handling Unit :P1 since it is in transit.', parent_handling_unit_id_);
         END IF;

         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            IF (newrec_.shipment_id IS NOT NULL) THEN
                  shipment_state_ := Shipment_API.Get_Objstate(newrec_.shipment_id);         
                  IF (shipment_state_ IN ('Completed', 'Closed', 'Cancelled')) THEN
                     Error_SYS.Record_General(lu_name_, 'INVALIDSHIPSTATE: It''s not allowed to change the parent of Handling Unit :P1 due to its shipment being in state :P2', handling_unit_id_, shipment_state_);
                  END IF;
            END IF;
         $END
        
         parent_shipment_no_ := Get_Shipment_Id(parent_handling_unit_id_);
         -- Prevent a change of shipment being done.
         IF (NVL(newrec_.shipment_id, number_null_) != NVL(parent_shipment_no_, number_null_)) THEN
            IF (newrec_.shipment_id IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOTTOSHIPMENT: It''s not allowed to change the parent of Handling Unit :P1 to a Handling Unit on a shipment.', handling_unit_id_);
            ELSE
               Error_Sys.Record_General(lu_name_, 'NOTSAMESHIPMENT: It''s not allowed to change the parent of Handling Unit :P1 to a Handling Unit outside of shipment :P2.', handling_unit_id_, newrec_.shipment_id);
            END IF;
         END IF;

         location_no_        := Get_Location_No(handling_unit_id_);
         parent_location_no_ := Get_Location_No(parent_root_handling_unit_id_);
         contract_           := Get_Contract(handling_unit_id_);
         parent_contract_    := Get_Contract(parent_root_handling_unit_id_);
         -- Ensure that we're not doing a "move" operation by having different locations.
         IF ((location_no_ IS NOT NULL AND parent_location_no_ IS NOT NULL AND location_no_ != parent_location_no_) OR
             (contract_    IS NOT NULL AND parent_contract_    IS NOT NULL AND contract_    != parent_contract_   )) THEN
            IF (Has_Quantity_In_Stock___(handling_unit_id_)) THEN
               Error_SYS.Record_General(lu_name_, 'NOTSAMELOCATION: It''s not allowed to change the parent of Handling Unit :P1 to a Handling Unit on another location.', handling_unit_id_);
            END IF;
         END IF;
      END IF;

      newrec_.parent_handling_unit_id := parent_handling_unit_id_;
      Modify___(newrec_);
   END IF;
END Modify_Parent_Handling_Unit_Id;

   
PROCEDURE New (
   handling_unit_id_             OUT NUMBER,
   handling_unit_type_id_        IN VARCHAR2,
   parent_handling_unit_id_      IN NUMBER   DEFAULT NULL,
   shipment_id_                  IN NUMBER   DEFAULT NULL,
   sscc_                         IN VARCHAR2 DEFAULT NULL,
   generate_sscc_no_db_          IN VARCHAR2 DEFAULT NULL,
   print_label_db_               IN VARCHAR2 DEFAULT NULL,
   print_content_label_db_       IN VARCHAR2 DEFAULT NULL,
   print_shipment_label_db_      IN VARCHAR2 DEFAULT NULL,
   mix_of_part_no_blocked_db_    IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   mix_of_lot_batch_blocked_db_  IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   mix_of_cond_code_blocked_db_  IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   no_of_handling_unit_labels_   IN NUMBER   DEFAULT NULL,
   no_of_content_labels_         IN NUMBER   DEFAULT NULL,
   no_of_shipment_labels_        IN NUMBER   DEFAULT NULL,
   alt_handling_unit_label_id_   IN VARCHAR2 DEFAULT NULL,
   source_ref_type_db_           IN VARCHAR2 DEFAULT NULL,
   source_ref1_                  IN VARCHAR2 DEFAULT NULL,
   source_ref2_                  IN VARCHAR2 DEFAULT NULL,
   source_ref3_                  IN VARCHAR2 DEFAULT NULL )
IS 
   newrec_  handling_unit_tab%ROWTYPE;
BEGIN
   newrec_.handling_unit_type_id       := handling_unit_type_id_;
   newrec_.parent_handling_unit_id     := parent_handling_unit_id_;
   newrec_.shipment_id                 := shipment_id_;
   newrec_.sscc                        := sscc_;
   newrec_.alt_handling_unit_label_id  := alt_handling_unit_label_id_;
   newrec_.generate_sscc_no            := generate_sscc_no_db_;
   newrec_.print_label                 := print_label_db_;
   newrec_.print_content_label         := print_content_label_db_;
   newrec_.print_shipment_label        := print_shipment_label_db_;
   newrec_.mix_of_part_no_blocked      := mix_of_part_no_blocked_db_;
   newrec_.mix_of_lot_batch_blocked    := mix_of_lot_batch_blocked_db_;
   newrec_.mix_of_cond_code_blocked    := mix_of_cond_code_blocked_db_;
   newrec_.no_of_handling_unit_labels  := no_of_handling_unit_labels_;
   newrec_.no_of_content_labels        := no_of_content_labels_;
   newrec_.no_of_shipment_labels       := no_of_shipment_labels_;
   newrec_.source_ref_type             := source_ref_type_db_;
   newrec_.source_ref1                 := source_ref1_;
   newrec_.source_ref2                 := source_ref2_;
   newrec_.source_ref3                 := source_ref3_;
   
   New___(newrec_);
   
   handling_unit_id_ := newrec_.handling_unit_id;
END New;
   

PROCEDURE New_With_Pack_Instr_Settings (
   handling_unit_id_             OUT NUMBER,
   handling_unit_type_id_        IN VARCHAR2,
   packing_instruction_id_       IN VARCHAR2,
   parent_handling_unit_id_      IN NUMBER   DEFAULT NULL,
   shipment_id_                  IN NUMBER   DEFAULT NULL,
   sscc_                         IN VARCHAR2 DEFAULT NULL,
   alt_handling_unit_label_id_   IN VARCHAR2 DEFAULT NULL,
   source_ref_type_db_           IN VARCHAR2 DEFAULT NULL,
   source_ref1_                  IN VARCHAR2 DEFAULT NULL,
   source_ref2_                  IN VARCHAR2 DEFAULT NULL,
   source_ref3_                  IN VARCHAR2 DEFAULT NULL )
IS
   node_id_                    NUMBER;
   generate_sscc_no_db_           VARCHAR2(5);
   print_label_db_                VARCHAR2(5);
   print_content_label_db_        VARCHAR2(5);
   print_shipment_label_db_       VARCHAR2(5);
   mix_of_cond_code_blocked_db_   VARCHAR2(5);
   mix_of_lot_batch_blocked_db_   VARCHAR2(5);
   mix_of_part_no_blocked_db_     VARCHAR2(5);
   no_of_handling_unit_labels_    NUMBER;
   no_of_content_labels_          NUMBER;
   no_of_shipment_labels_         NUMBER;
   pack_instr_pub_rec_            Packing_Instruction_Node_API.Public_Rec;
BEGIN
   
   IF (packing_instruction_id_ IS NOT NULL) THEN   
      node_id_ := Packing_Instruction_Node_API.Get_Node_Id(packing_instruction_id_, handling_unit_type_id_);
      pack_instr_pub_rec_         := Packing_Instruction_Node_API.Get(packing_instruction_id_, node_id_);
      no_of_handling_unit_labels_ := pack_instr_pub_rec_.no_of_handling_unit_labels;
      no_of_content_labels_       := pack_instr_pub_rec_.no_of_content_labels;
      no_of_shipment_labels_      := pack_instr_pub_rec_.no_of_shipment_labels;
      
      IF (shipment_id_ IS NOT NULL) THEN
         Packing_Instruction_Node_API.Get_Flags_For_Node_And_Parents(generate_sscc_no_db_,
                                                                     print_label_db_,
                                                                     print_content_label_db_,
                                                                     print_shipment_label_db_,
                                                                     mix_of_cond_code_blocked_db_,
                                                                     mix_of_lot_batch_blocked_db_,
                                                                     mix_of_part_no_blocked_db_,
                                                                     packing_instruction_id_, 
                                                                     node_id_);
      ELSE
         Packing_Instruction_Node_API.Get_Flags_For_Node(generate_sscc_no_db_,
                                                         print_label_db_,
                                                         print_content_label_db_,
                                                         print_shipment_label_db_,
                                                         mix_of_cond_code_blocked_db_,
                                                         mix_of_lot_batch_blocked_db_,
                                                         mix_of_part_no_blocked_db_,
                                                         packing_instruction_id_, 
                                                         node_id_);
      END IF;
   END IF;
   
   New(handling_unit_id_,
       handling_unit_type_id_,
       parent_handling_unit_id_,
       shipment_id_,
       sscc_,
       generate_sscc_no_db_,
       print_label_db_,
       print_content_label_db_,
       print_shipment_label_db_,
       mix_of_part_no_blocked_db_,
       mix_of_lot_batch_blocked_db_,
       mix_of_cond_code_blocked_db_,
       no_of_handling_unit_labels_,
       no_of_content_labels_,
       no_of_shipment_labels_,
       alt_handling_unit_label_id_,
       source_ref_type_db_,
       source_ref1_,
       source_ref2_,
       source_ref3_);
   
   Pack_Instr_Node_Accessory_API.Add_Accesories_To_Handl_Unit(packing_instruction_id_, node_id_, handling_unit_id_);
END New_With_Pack_Instr_Settings;


@UncheckedAccess
FUNCTION Get_Composition (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS            
   handling_unit_id_tab_         Handling_Unit_Id_Tab;  
   mixed_part_numbers_connected_ BOOLEAN := FALSE; 
   composition_                  VARCHAR2(200);   
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
      
   IF (handling_unit_id_tab_.COUNT > 0) THEN   
      mixed_part_numbers_connected_ := Has_Mixed_Part_Numbers___(handling_unit_id_tab_);
      
      IF (mixed_part_numbers_connected_) THEN
        composition_ := Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_MIXED);
      ELSIF (handling_unit_id_tab_.COUNT > 1) THEN
        composition_ := Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_HOMOGENEOUS);
      ELSE
        composition_ := Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_SIMPLIFIED);
      END IF;
   END IF;  
   RETURN composition_;
END Get_Composition;


@UncheckedAccess
FUNCTION Get_Operative_Unit_Tare_Weight (
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Tare_Weight_This_Level___(handling_unit_id_, uom_for_weight_);
END Get_Operative_Unit_Tare_Weight;


@UncheckedAccess
FUNCTION Get_Net_Weight (
   handling_unit_id_     IN NUMBER,
   uom_for_weight_       IN VARCHAR2 DEFAULT NULL,
   apply_freight_factor_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN NUMBER
IS
   net_weight_          NUMBER;
   adj_net_weight_      NUMBER;
   to_uom_for_weight_   VARCHAR2(30);
BEGIN
   to_uom_for_weight_ := NVL(uom_for_weight_, Get_Uom_For_Weight(handling_unit_id_));
   
   Get_Net_And_Adjusted_Weight___(net_weight_       => net_weight_, 
                                  adj_net_weight_   => adj_net_weight_, 
                                  handling_unit_id_ => handling_unit_id_, 
                                  uom_for_weight_   => to_uom_for_weight_);
    
   IF (apply_freight_factor_ = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN adj_net_weight_;
   ELSE
      RETURN net_weight_;
   END IF;
END Get_Net_Weight;


@UncheckedAccess
FUNCTION Get_Tare_Weight (
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   CURSOR get_handling_units IS  
      SELECT handling_unit_id
      FROM handling_unit_tab
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = handling_unit_id_;
            
   tare_weight_         NUMBER := 0;
   to_uom_for_weight_   VARCHAR2(30);
BEGIN
   to_uom_for_weight_ := NVL(uom_for_weight_, Get_Uom_For_Weight(handling_unit_id_));
   
   FOR rec_ IN get_handling_units LOOP
      tare_weight_ := tare_weight_ + Get_Tare_Weight_This_Level___(handling_unit_id_    => rec_.handling_unit_id, 
                                                                   uom_for_weight_      => to_uom_for_weight_);
   END LOOP;

   RETURN tare_weight_;
END Get_Tare_Weight;


@UncheckedAccess
FUNCTION Get_Operative_Gross_Weight (
   handling_unit_id_     IN NUMBER,
   uom_for_weight_       IN VARCHAR2 DEFAULT NULL,
   apply_freight_factor_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS   
   manual_gross_weight_         handling_unit_tab.manual_gross_weight%TYPE;      
   operative_gross_weight_      handling_unit_tab.manual_gross_weight%TYPE := 0; 
   handling_unit_tab_           Handling_Unit_Id_Tab;
   net_weight_                  NUMBER;
   adj_net_weight_              NUMBER;
   hu_uom_for_weight_           VARCHAR2(30);
   to_uom_for_weight_           VARCHAR2(30);
BEGIN
   hu_uom_for_weight_ := Get_Uom_For_Weight(handling_unit_id_);
   to_uom_for_weight_ := NVL(uom_for_weight_, hu_uom_for_weight_);
   
   manual_gross_weight_ := Get_Manual_Gross_Weight(handling_unit_id_);
   
   IF (manual_gross_weight_ IS NULL) THEN
      Get_Net_Weight_This_Level___(net_weight_, adj_net_weight_, handling_unit_id_, to_uom_for_weight_);
      
      IF (apply_freight_factor_ = Fnd_Boolean_Api.DB_TRUE) THEN
         operative_gross_weight_ := adj_net_weight_;
      ELSE
         operative_gross_weight_ := net_weight_;
      END IF;
      
      operative_gross_weight_ := operative_gross_weight_ + Get_Tare_Weight_This_Level___(handling_unit_id_, to_uom_for_weight_);

      handling_unit_tab_ := Get_Children___(handling_unit_id_);
      IF (handling_unit_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
            operative_gross_weight_ := operative_gross_weight_ + Get_Operative_Gross_Weight(handling_unit_id_       => handling_unit_tab_(i).handling_unit_id, 
                                                                                            uom_for_weight_         => to_uom_for_weight_, 
                                                                                            apply_freight_factor_   => apply_freight_factor_);
         END LOOP;
      END IF;
   ELSE
      IF (hu_uom_for_weight_ != to_uom_for_weight_) THEN
         operative_gross_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_     => manual_gross_weight_, 
                                                                             from_unit_code_    => hu_uom_for_weight_, 
                                                                             to_unit_code_      => to_uom_for_weight_);
      ELSE
         operative_gross_weight_ := manual_gross_weight_;
      END IF;
      
      IF (apply_freight_factor_ = Fnd_Boolean_Api.DB_TRUE) THEN
         Get_Net_And_Adjusted_Weight___(net_weight_, adj_net_weight_, handling_unit_id_, to_uom_for_weight_);
         operative_gross_weight_ := operative_gross_weight_ + (adj_net_weight_ - net_weight_);
      END IF;
   END IF;
   
   RETURN operative_gross_weight_;
END Get_Operative_Gross_Weight;


@UncheckedAccess
FUNCTION Get_Operative_Gross_Weight (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2 DEFAULT NULL,
   row_id_                       IN VARCHAR2 DEFAULT NULL,
   bin_id_                       IN VARCHAR2 DEFAULT NULL,
   ignore_this_handling_unit_id_ IN NUMBER   DEFAULT NULL ) RETURN NUMBER
IS
   handling_unit_id_tab_   Handling_Unit_Id_Tab;
   operative_gross_weight_ NUMBER := 0;
   company_rec_            Company_Invent_Info_API.Public_Rec;

   CURSOR get_bin_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND tier_no           = tier_id_
                                                  AND row_no            = row_id_
                                                  AND bin_no            = bin_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
   CURSOR get_tier_row_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND tier_no           = tier_id_
                                                  AND row_no            = row_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
   CURSOR get_row_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND row_no            = row_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
   CURSOR get_tier_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND tier_no           = tier_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
   CURSOR get_bay_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
BEGIN
   IF (bin_id_ IS NULL) THEN
      IF (row_id_ IS NULL) THEN
         IF (tier_id_ IS NULL) THEN
            OPEN  get_bay_top_parents;
            FETCH get_bay_top_parents BULK COLLECT INTO handling_unit_id_tab_;
            CLOSE get_bay_top_parents;
         ELSE
            OPEN  get_tier_top_parents;
            FETCH get_tier_top_parents BULK COLLECT INTO handling_unit_id_tab_;
            CLOSE get_tier_top_parents;
         END IF;
      ELSE
         IF (tier_id_ IS NULL) THEN
            OPEN  get_row_top_parents;
            FETCH get_row_top_parents BULK COLLECT INTO handling_unit_id_tab_;
            CLOSE get_row_top_parents;
         ELSE
            OPEN  get_tier_row_top_parents;
            FETCH get_tier_row_top_parents BULK COLLECT INTO handling_unit_id_tab_;
            CLOSE get_tier_row_top_parents;
         END IF;
      END IF;
   ELSE
      OPEN  get_bin_top_parents;
      FETCH get_bin_top_parents BULK COLLECT INTO handling_unit_id_tab_;
      CLOSE get_bin_top_parents;
   END IF;

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      company_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         operative_gross_weight_ := operative_gross_weight_ + Get_Operative_Gross_Weight(handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                                                                         uom_for_weight_       => company_rec_.uom_for_weight,
                                                                                         apply_freight_factor_ => Fnd_Boolean_Api.DB_FALSE);
      END LOOP;
   END IF;

   RETURN (operative_gross_weight_);
END Get_Operative_Gross_Weight;


@UncheckedAccess
FUNCTION Get_Max_Volume_Capacity (
   handling_unit_id_       IN NUMBER,
   uom_for_volume_         IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   handling_unit_type_rec_  Handling_Unit_Type_API.Public_Rec;
   to_uom_for_volume_       VARCHAR2(30);
   max_volume_capacity_     NUMBER;
BEGIN
   handling_unit_type_rec_ := Handling_Unit_Type_API.Get(Get_Handling_Unit_Type_Id(handling_unit_id_));
   
   IF (handling_unit_type_rec_.max_volume_capacity IS NOT NULL) THEN
      to_uom_for_volume_      := NVL(uom_for_volume_, Handling_Unit_API.Get_Uom_For_Volume(handling_unit_id_));
      
      IF (to_uom_for_volume_ != handling_unit_type_rec_.uom_for_volume) THEN
         max_volume_capacity_ := Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_type_rec_.max_volume_capacity,
                                                                          handling_unit_type_rec_.uom_for_volume,
                                                                          to_uom_for_volume_);
      ELSE
         max_volume_capacity_ := handling_unit_type_rec_.max_volume_capacity;
      END IF;
   END IF;
                                                                           
   RETURN max_volume_capacity_;
END Get_Max_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Max_Weight_Capacity (
   handling_unit_id_       IN NUMBER,
   uom_for_weight_         IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   handling_unit_type_rec_  Handling_Unit_Type_API.Public_Rec;
   to_uom_for_weight_       VARCHAR2(30);
   max_weight_capacity_     NUMBER;
BEGIN
   handling_unit_type_rec_ := Handling_Unit_Type_API.Get(Get_Handling_Unit_Type_Id(handling_unit_id_));
   
   IF (handling_unit_type_rec_.max_weight_capacity IS NOT NULL) THEN
      to_uom_for_weight_ := NVL(uom_for_weight_, Handling_Unit_API.Get_Uom_For_Weight(handling_unit_id_));
      
      IF (to_uom_for_weight_ != handling_unit_type_rec_.uom_for_weight) THEN
         max_weight_capacity_ := Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_type_rec_.max_weight_capacity,
                                                                          handling_unit_type_rec_.uom_for_weight,
                                                                          to_uom_for_weight_);
      ELSE
         max_weight_capacity_ := handling_unit_type_rec_.max_weight_capacity;
      END IF;
   END IF;
   
   RETURN max_weight_capacity_;
END Get_Max_Weight_Capacity;


@UncheckedAccess
FUNCTION Get_Structure_Level (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN (Get_Node_Level(handling_unit_id_));
END Get_Structure_Level;
   

PROCEDURE Remove_Manual_Gross_Weight (
   handling_unit_id_      IN NUMBER,
   also_remove_on_parent_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   Clear_Manual_Weight_And_Volume(handling_unit_id_      => handling_unit_id_,
                                  also_remove_on_parent_ => also_remove_on_parent_,
                                  remove_manual_weight_  => TRUE,
                                  remove_manual_volume_  => FALSE);
END Remove_Manual_Gross_Weight;


@UncheckedAccess
FUNCTION Get_Operative_Volume (
   handling_unit_id_ IN NUMBER,
   uom_for_volume_   IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   lu_rec_                      handling_unit_tab%ROWTYPE; 
   handling_unit_type_rec_      Handling_Unit_Type_API.Public_Rec;
   handling_unit_tab_           Handling_Unit_Id_Tab;
   hu_uom_for_volume_           VARCHAR2(30);
   to_uom_for_volume_           VARCHAR2(30);
   additive_accessory_volume_   NUMBER;
   operative_volume_            NUMBER;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(handling_unit_id_);
   
   hu_uom_for_volume_   := Get_Uom_For_Volume(handling_unit_id_);
   to_uom_for_volume_   := NVL(uom_for_volume_, hu_uom_for_volume_);
   
   IF (lu_rec_.manual_volume IS NULL) THEN
      handling_unit_type_rec_ := Handling_Unit_Type_API.Get(lu_rec_.handling_unit_type_id);
      
      -- Get the volume from the Handling Unit Type.
      IF (to_uom_for_volume_ != handling_unit_type_rec_.uom_for_volume) THEN
         operative_volume_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => NVL(handling_unit_type_rec_.volume, 0),
                                                                       from_unit_code_   => handling_unit_type_rec_.uom_for_volume,
                                                                       to_unit_code_     => to_uom_for_volume_); 
      ELSE
         operative_volume_ := NVL(handling_unit_type_rec_.volume, 0);
      END IF;

      -- Add this Handling Unit's accessories that have additive volume.
      additive_accessory_volume_ :=  Accessory_On_Handling_Unit_API.Get_Connected_Accessory_Volume(handling_unit_id_  => handling_unit_id_, 
                                                                                                   uom_for_volume_    => to_uom_for_volume_,
                                                                                                   additive_volume_   => Fnd_Boolean_API.DB_TRUE);
      operative_volume_ := operative_volume_ + additive_accessory_volume_;

      -- If there is additive accessory volume on the Handling Unit (e.g. a pallet rim) we can't consider the volume
      -- of the parts and/or children. The Handling Unit along with its accessory volume is now instead considered 
      -- as a box with all of the contents within it.
      IF (NVL(additive_accessory_volume_, 0) = 0) THEN
         -- If the Handling Unit Type has an additive volume we need to add the volume of the content (HU children and/or parts).
         IF (handling_unit_type_rec_.additive_volume = Fnd_Boolean_API.DB_TRUE) THEN
            handling_unit_tab_ := Get_Children___(handling_unit_id_);
            IF (handling_unit_tab_.COUNT > 0) THEN
               FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
                  operative_volume_ := operative_volume_ + Get_Operative_Volume(handling_unit_id_   => handling_unit_tab_(i).handling_unit_id, 
                                                                                uom_for_volume_     => to_uom_for_volume_);
               END LOOP;
            END IF;

            -- If the Handling Unit is on a Shipment we let the ask the shipment for the weight of the attached parts.
            IF (lu_rec_.shipment_id IS NOT NULL) THEN
               $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
                  operative_volume_ := operative_volume_ + Shipment_Line_Handl_Unit_API.Get_Connected_Part_Volume(shipment_id_         => lu_rec_.shipment_id,
                                                                                                                  handling_unit_id_    => handling_unit_id_, 
                                                                                                                  uom_for_volume_      => to_uom_for_volume_);  
               $ELSE
                  NULL;
               $END
            ELSE
               operative_volume_ := operative_volume_ + Get_Part_Volume_This_Level___(handling_unit_id_  => handling_unit_id_, 
                                                                                      uom_for_volume_    => to_uom_for_volume_);
            END IF;
         END IF;
      END IF;
   ELSE
      IF (to_uom_for_volume_ != hu_uom_for_volume_) THEN
         operative_volume_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_   => lu_rec_.manual_volume,
                                                                       from_unit_code_  => hu_uom_for_volume_,
                                                                       to_unit_code_    => to_uom_for_volume_);
      ELSE
         operative_volume_ := lu_rec_.manual_volume;
      END IF;
   END IF;

   RETURN operative_volume_;
END Get_Operative_Volume;


@UncheckedAccess
FUNCTION Get_Operative_Volume (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
   operative_volume_     NUMBER := 0;
   company_rec_          Company_Invent_Info_API.Public_Rec;

   CURSOR get_bin_top_parents IS
      SELECT DISTINCT handling_unit_id
        FROM handling_unit_tab
       WHERE parent_handling_unit_id IS NULL
         AND (handling_unit_id != ignore_this_handling_unit_id_ OR ignore_this_handling_unit_id_ IS NULL)
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id IN (SELECT DISTINCT handling_unit_id
                                                 FROM inventory_part_in_stock_tab
                                                WHERE contract          = contract_
                                                  AND warehouse         = warehouse_id_
                                                  AND bay_no            = bay_id_
                                                  AND tier_no           = tier_id_
                                                  AND row_no            = row_id_
                                                  AND bin_no            = bin_id_
                                                  AND handling_unit_id != 0
                                                  AND (qty_onhand > 0 OR qty_in_transit > 0));
BEGIN
   OPEN  get_bin_top_parents;
   FETCH get_bin_top_parents BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_bin_top_parents;

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      company_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         operative_volume_ := operative_volume_ + Get_Operative_Volume(handling_unit_id_tab_(i).handling_unit_id, company_rec_.uom_for_volume);
      END LOOP;
   END IF;

   RETURN (operative_volume_);
END Get_Operative_Volume;


-----------------------------------------------------------------------------
-- Get_Default_Uom_For_Length
-- Return the default Uom for length fetched in the priority order as below
--  1. Basic data for handling unit type
--  2. UoM for length of the shipment connected company
--  3. From the company of user default site
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Default_Uom_For_Length (
   handling_unit_id_       IN NUMBER,   
   handling_unit_type_id_  IN VARCHAR2) RETURN VARCHAR2
IS
   uom_for_length_    VARCHAR2(30); 
   contract_          VARCHAR2(5);
   company_           VARCHAR2(20);
BEGIN
   uom_for_length_ := Handling_Unit_Type_API.Get_Uom_For_Length(handling_unit_type_id_);

   IF (uom_for_length_ IS NULL) THEN
      contract_ := Get_Contract(handling_unit_id_);
      IF (contract_ IS NULL) THEN
         contract_ := User_Allowed_Site_API.Get_Default_Site;
      END IF;
      company_        := Site_API.Get_Company(contract_);
      uom_for_length_ := Company_Invent_Info_API.Get_Uom_For_Length(company_);      
   END IF;

   RETURN uom_for_length_;
END Get_Default_Uom_For_Length;


@UncheckedAccess
FUNCTION Get_Uom_For_Volume (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   uom_for_volume_ VARCHAR2(30);
BEGIN
   uom_for_volume_ := Get_Uom_For_Unit_Type___(handling_unit_id_, Iso_Unit_Type_API.DB_VOLUME);
   RETURN (uom_for_volume_);
END Get_Uom_For_Volume;


@UncheckedAccess
FUNCTION Get_Uom_For_Weight (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   uom_for_weight_ VARCHAR2(30); 
BEGIN
   uom_for_weight_ := Get_Uom_For_Unit_Type___(handling_unit_id_, Iso_Unit_Type_API.DB_WEIGHT);
   RETURN (uom_for_weight_);
END Get_Uom_For_Weight;


PROCEDURE Remove_Manual_Volume (
   handling_unit_id_      IN NUMBER,
   also_remove_on_parent_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   Clear_Manual_Weight_And_Volume(handling_unit_id_      => handling_unit_id_,
                                  also_remove_on_parent_ => also_remove_on_parent_,
                                  remove_manual_weight_  => FALSE,
                                  remove_manual_volume_  => TRUE);
END Remove_Manual_Volume;


-- Get_No_Of_Children
--   Gets the number of directly connected children to a handling unit.
--   Optionally a handling_unit_type_id can also be passed as a parameter to get
--   directly connected children of that specific type.
@UncheckedAccess
FUNCTION Get_No_Of_Children (
   handling_unit_id_      IN NUMBER,
   handling_unit_type_id_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER 
IS
   number_of_children_ NUMBER;
   CURSOR get_number_of_children IS 
      SELECT count(*)
      FROM handling_unit_tab
      WHERE parent_handling_unit_id = handling_unit_id_
      AND   handling_unit_type_id   = NVL(handling_unit_type_id_, handling_unit_type_id);
BEGIN
   OPEN get_number_of_children;
   FETCH get_number_of_children INTO number_of_children_;
   CLOSE get_number_of_children;
   
   RETURN number_of_children_;
END Get_No_Of_Children;


@UncheckedAccess
FUNCTION Check_Generate_Sscc_No_Struct (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_                     NUMBER;
   generate_sscc_no_exist_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_generate_sscc_no(handling_unit_id_ NUMBER) IS
      SELECT 1
      FROM handling_unit_tab 
      WHERE generate_sscc_no = Fnd_Boolean_API.DB_TRUE
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id = handling_unit_id_;
BEGIN    
   OPEN check_generate_sscc_no(handling_unit_id_);
   FETCH check_generate_sscc_no INTO temp_;
   IF (check_generate_sscc_no%FOUND) THEN
      generate_sscc_no_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   CLOSE check_generate_sscc_no;
   RETURN  generate_sscc_no_exist_;
END Check_Generate_Sscc_No_Struct;


@UncheckedAccess
FUNCTION Check_Generate_Sscc_No_Shpmnt (
   shipment_id_  IN NUMBER ) RETURN VARCHAR2
IS
   temp_                     NUMBER;
   generate_sscc_no_exist_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_generate_sscc_no IS
      SELECT 1
        FROM handling_unit_tab 
       WHERE shipment_id = shipment_id_
         AND generate_sscc_no = Fnd_Boolean_API.DB_TRUE;
BEGIN    
   OPEN check_generate_sscc_no;
   FETCH check_generate_sscc_no INTO temp_;
   IF (check_generate_sscc_no%FOUND) THEN
      generate_sscc_no_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   CLOSE check_generate_sscc_no;
   RETURN  generate_sscc_no_exist_;
END Check_Generate_Sscc_No_Shpmnt;


@UncheckedAccess
FUNCTION Print_Labels_Exist_In_Struct (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_              NUMBER;
   print_label_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   CURSOR check_print_labels(handling_unit_id_ NUMBER) IS
      SELECT 1
      FROM handling_unit_tab 
      WHERE print_label = Fnd_Boolean_API.DB_TRUE
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id = handling_unit_id_;
BEGIN    
   OPEN check_print_labels(handling_unit_id_);
   FETCH check_print_labels INTO temp_;
   IF (check_print_labels%FOUND) THEN
      print_label_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   CLOSE check_print_labels;
   RETURN  print_label_exist_;
END Print_Labels_Exist_In_Struct;    

   
@UncheckedAccess
FUNCTION Prt_Cnt_Labels_Exist_In_Struct (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_                      NUMBER;
   print_content_label_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   CURSOR check_content_print_labels(handling_unit_id_ NUMBER) IS
      SELECT 1
      FROM handling_unit_tab 
      WHERE print_content_label = Fnd_Boolean_API.DB_TRUE
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id = handling_unit_id_;
BEGIN    
   OPEN check_content_print_labels(handling_unit_id_);
   FETCH check_content_print_labels INTO temp_;
   IF (check_content_print_labels%FOUND) THEN
      print_content_label_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   CLOSE check_content_print_labels;
   RETURN  print_content_label_exist_;
END Prt_Cnt_Labels_Exist_In_Struct;

   
PROCEDURE Get_Print_Labels_For_Structure (
   handling_unit_info_list_ OUT VARCHAR2,
   handling_unit_id_        IN  NUMBER )
IS
   local_info_list_ VARCHAR2(2000) := NULL;
   
   CURSOR get_print_label_hus(handling_unit_id_ NUMBER) IS
      SELECT handling_unit_id, no_of_handling_unit_labels
      FROM handling_unit_tab 
      WHERE print_label = Fnd_Boolean_API.DB_TRUE
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id = handling_unit_id_;
BEGIN 
   FOR rec_ IN get_print_label_hus(handling_unit_id_) LOOP
      local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_handling_unit_labels || '^';
   END LOOP;   
   handling_unit_info_list_ := local_info_list_;
END Get_Print_Labels_For_Structure;


PROCEDURE Get_Prnt_Cnt_Labels_For_Struct (
   handling_unit_info_list_ OUT VARCHAR2,
   handling_unit_id_        IN  NUMBER )
IS
   local_info_list_ VARCHAR2(2000) := NULL;
   
   CURSOR get_print_content_label_hus(handling_unit_id_ NUMBER) IS
      SELECT handling_unit_id, no_of_content_labels
      FROM handling_unit_tab 
      WHERE print_content_label = Fnd_Boolean_API.DB_TRUE
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id = handling_unit_id_;
BEGIN 
   FOR rec_ IN get_print_content_label_hus(handling_unit_id_) LOOP
      local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_content_labels || '^';
   END LOOP;   
   handling_unit_info_list_ := local_info_list_;
END Get_Prnt_Cnt_Labels_For_Struct;


@UncheckedAccess
FUNCTION Get_Handling_Unit_From_Sscc (
   sscc_ IN VARCHAR2 ) RETURN NUMBER
IS
   handling_unit_id_ NUMBER;
   CURSOR get_handling_unit IS
      SELECT handling_unit_id
      FROM handling_unit_tab
      WHERE sscc =  sscc_;
BEGIN
   OPEN get_handling_unit;
   FETCH get_handling_unit INTO handling_unit_id_;
   CLOSE get_handling_unit;
   RETURN handling_unit_id_;
END Get_Handling_Unit_From_Sscc;   


@UncheckedAccess
FUNCTION Get_Handling_Unit_From_Alt_Id (
   alt_handling_unit_label_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   handling_unit_id_ handling_unit_tab.handling_unit_id%TYPE;

   CURSOR get_handling_unit_id IS
      SELECT handling_unit_id
        FROM handling_unit_tab
       WHERE alt_handling_unit_label_id = alt_handling_unit_label_id_;

   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   OPEN  get_handling_unit_id;
   FETCH get_handling_unit_id BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_handling_unit_id;

   IF (handling_unit_id_tab_.COUNT = 1) THEN
      handling_unit_id_ := handling_unit_id_tab_(handling_unit_id_tab_.FIRST).handling_unit_id;
   END IF;

   RETURN (handling_unit_id_);
END Get_Handling_Unit_From_Alt_Id;   


@UncheckedAccess
PROCEDURE Get_Handling_Unit_Identifiers (
   handling_unit_id_             IN OUT NUMBER,
   sscc_                         IN OUT VARCHAR2,
   alt_handling_unit_label_id_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (handling_unit_id_ IS NULL) THEN
      IF (sscc_ IS NOT NULL) THEN
         handling_unit_id_ := Get_Handling_Unit_From_Sscc(sscc_);
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN
         handling_unit_id_ := Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOHUIDENTIFIERS: At least one handling unit identifier has to be sent as input.');
      END IF;
   END IF;
   
   IF (sscc_ IS NULL) THEN
      sscc_ := Get_Sscc(handling_unit_id_);
   END IF;
   
   IF (alt_handling_unit_label_id_ IS NULL) THEN
      alt_handling_unit_label_id_ := Get_Alt_Handling_Unit_Label_Id(handling_unit_id_);
   END IF;
END Get_Handling_Unit_Identifiers;



PROCEDURE Apply_Pack_Instr_Node_Settings (
   handling_unit_id_       IN NUMBER,
   packing_instruction_id_ IN VARCHAR2 )
IS
   handling_unit_type_id_   handling_unit_tab.handling_unit_type_id%TYPE;
   node_id_                 NUMBER;
   packing_instruction_rec_ Packing_Instruction_Node_API.Public_Rec;
   newrec_                  handling_unit_tab%ROWTYPE;
BEGIN
   handling_unit_type_id_   := Get_Handling_Unit_Type_Id(handling_unit_id_);
   node_id_                 := Packing_Instruction_Node_API.Get_Node_Id(packing_instruction_id_,
                                                                        handling_unit_type_id_);
   packing_instruction_rec_ := Packing_Instruction_Node_API.Get(packing_instruction_id_, 
                                                                node_id_);

   newrec_ := Lock_By_Keys___(handling_unit_id_);
   newrec_.generate_sscc_no         := packing_instruction_rec_.generate_sscc_no;
   newrec_.print_label              := packing_instruction_rec_.print_label;
   newrec_.print_content_label      := packing_instruction_rec_.print_content_label;
   newrec_.print_shipment_label     := packing_instruction_rec_.print_shipment_label;
   newrec_.mix_of_part_no_blocked   := packing_instruction_rec_.mix_of_part_no_blocked;
   newrec_.mix_of_lot_batch_blocked := packing_instruction_rec_.mix_of_lot_batch_blocked;
   newrec_.mix_of_cond_code_blocked := packing_instruction_rec_.mix_of_cond_code_blocked;
   Modify___(newrec_);
END Apply_Pack_Instr_Node_Settings;


PROCEDURE Check_Allow_Mix (
   handling_unit_id_ IN NUMBER )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;  
   lu_rec_               handling_unit_tab%ROWTYPE; 
   true_                 VARCHAR2(4) := Fnd_Boolean_API.DB_TRUE;
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN  
      lu_rec_ := Get_Object_By_Keys___(handling_unit_id_);
      IF (lu_rec_.mix_of_part_no_blocked = true_) THEN
         Check_Allow_Mix_Part_No___(handling_unit_id_tab_, FALSE);
      END IF;

      IF (lu_rec_.mix_of_lot_batch_blocked = true_) THEN
         Check_Allow_Mix_Lot_Batches___(handling_unit_id_tab_, FALSE);
      END IF;

      IF (lu_rec_.mix_of_cond_code_blocked = true_) THEN
         Check_Allow_Mix_Cond_Codes___(handling_unit_id_tab_, FALSE);
      END IF;

      IF (lu_rec_.parent_handling_unit_id IS NOT NULL) THEN
         Check_Allow_Mix(lu_rec_.parent_handling_unit_id);  
      END IF;         
   END IF;
END Check_Allow_Mix;


PROCEDURE Create_Sscc (
   handling_unit_id_ IN NUMBER )
IS
   new_sscc_   handling_unit_tab.sscc%TYPE;
   newrec_     handling_unit_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(handling_unit_id_);
   -- To retreive the automatic sscc 
   Sscc_Basic_Data_API.Get_Auto_Created_Sscc(new_sscc_,
                                             Get_Company___(handling_unit_id_),
                                             newrec_.handling_unit_type_id);

   Trace_Sys.Message('The SSCC '|| new_sscc_ || ' is connected to handling unit ' || handling_unit_id_ || '.');
   newrec_.sscc := new_sscc_;
   Modify___(newrec_);
END Create_Sscc;


PROCEDURE Create_Sscc (
   handling_unit_id_list_   IN VARCHAR2 )
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Create_Sscc(handling_unit_id_ => handling_unit_id_tab_(i).handling_unit_id);
   END LOOP;
END Create_Sscc;


-- Create_Ssccs_For_Structure
--   When this method is triggered on a particular handling unit in the
--   handling unit structure it will generate the SSCC for its all
--   sub handling units(in the tree structure) underneath it.
PROCEDURE Create_Ssccs_For_Structure (
   handling_unit_id_ IN NUMBER)
IS
   CURSOR get_all_sub_handling_units(handling_unit_id_ NUMBER) IS
      SELECT handling_unit_id, generate_sscc_no, sscc
        FROM handling_unit_tab
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;
BEGIN
   FOR handling_unit_ IN get_all_sub_handling_units(handling_unit_id_) LOOP
      IF (handling_unit_.sscc IS NULL AND handling_unit_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE) THEN
         Create_Sscc(handling_unit_.handling_unit_id);
      END IF;
   END LOOP;
END Create_Ssccs_For_Structure;


-- Sscc_Exists
--   This method checks whether the given SSCC already exists for a handling unit.
@UncheckedAccess
FUNCTION Sscc_Exist (
   sscc_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(5) := 'FALSE';
   dummy_ NUMBER;

   CURSOR check_sscc_exist IS
      SELECT 1
      FROM handling_unit_tab
      WHERE sscc = sscc_;
BEGIN
   OPEN  check_sscc_exist;
   FETCH check_sscc_exist INTO dummy_;
   IF (check_sscc_exist%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE check_sscc_exist;
   RETURN exist_;
END Sscc_Exist;


-- Validate_Sscc
--   This method checks and validates whether the given SSCC value
--   is a valid sscc number.
PROCEDURE Validate_Sscc (
   sscc_             IN VARCHAR2,
   check_sscc_exist_ IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   IF NOT (Is_Number___(sscc_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTNUMBER: The SSCC must be a numeric value.');
   ELSIF check_sscc_exist_ AND Sscc_Exist___(sscc_) THEN
      Error_SYS.Record_General(lu_name_,'ALREADYEXIST: The SSCC ":P1" already exist.', sscc_);
   END IF; 
   Sscc_Handling_Util_API.Validate_Sscc_Digits(sscc_);
END Validate_Sscc;


-- Check_Structure
--   Gives an error if a handling unit is parent/child of its own structure.
PROCEDURE Check_Structure (
   handling_unit_id_        IN NUMBER,
   parent_handling_unit_id_ IN NUMBER )
IS
   temp_ NUMBER;
   CURSOR check_handling_unit IS
      SELECT 1
      FROM dual
      WHERE handling_unit_id_ IN
         (SELECT handling_unit_id
          FROM handling_unit_tab
          CONNECT BY handling_unit_id = PRIOR parent_handling_unit_id
          START WITH handling_unit_id = parent_handling_unit_id_);
BEGIN
   IF (handling_unit_id_ = parent_handling_unit_id_ ) THEN
      Error_Sys.Record_General(lu_name_, 'SELFPARENT: A Handling Unit cannot have itself as a parent.');
   ELSE
      OPEN check_handling_unit;
      FETCH check_handling_unit INTO temp_;
      IF (check_handling_unit%FOUND) THEN
         CLOSE check_handling_unit;
         Error_Sys.Record_General(lu_name_, 'CHILDPARENT: A Handling Unit cannot have one of its children as a parent.');
      ELSE
         CLOSE check_handling_unit;
      END IF;
   END IF;
END Check_Structure;

   
PROCEDURE Validate_Structure_Position (
   handling_unit_id_ IN NUMBER )
IS
   root_handling_unit_id_        handling_unit_tab.parent_handling_unit_id%TYPE;
   in_inventory_                 VARCHAR2(100) := Language_SYS.Translate_Constant(lu_name_,'ININVENTORY: in inventory');
   in_inventory_move_transit_    VARCHAR2(100) := Language_SYS.Translate_Constant(lu_name_,'INVENTORYTRANSIT: in inventory move transit');
   in_internal_order_transit_    VARCHAR2(100) := Language_SYS.Translate_Constant(lu_name_,'INTORDERTRANSIT: in internal order transit');
   at_customer_                  VARCHAR2(100) := Language_SYS.Translate_Constant(lu_name_,'ATCUSTOMER: at customer');
   unique_in_stock_counter_      NUMBER;
   unique_move_transit_counter_  NUMBER;
   unique_order_transit_counter_ NUMBER;
   unique_at_customer_counter_   NUMBER;
   position_1_                   VARCHAR2(100);
   position_2_                   VARCHAR2(100);
   position_error                EXCEPTION;

   CURSOR get_unique_in_stock_counter IS
      SELECT count(DISTINCT contract||'^'||location_no)
        FROM inventory_part_in_stock_tab
       WHERE qty_onhand != 0
         AND handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_tab
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH handling_unit_id = root_handling_unit_id_);

   CURSOR get_unique_move_transit_count IS
      SELECT count(DISTINCT contract||'^'||location_no)
        FROM inventory_part_in_stock_tab
       WHERE qty_in_transit != 0
         AND handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_tab
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH handling_unit_id = root_handling_unit_id_);

   CURSOR get_unique_order_transit_count IS
      SELECT count(DISTINCT delivering_contract||'^'||delivering_warehouse_id||'^'||contract||'^'||receiving_warehouse_id)
        FROM inventory_part_in_transit_tab
       WHERE quantity != 0
         AND handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_tab
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH handling_unit_id = root_handling_unit_id_);

   CURSOR get_unique_at_customer_counter IS
      SELECT count(DISTINCT customer_no||'^'||addr_no||'^'||process_type)
        FROM inventory_part_at_customer_tab
       WHERE quantity != 0
         AND handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_tab
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH handling_unit_id = root_handling_unit_id_);
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);

   OPEN  get_unique_in_stock_counter;
   FETCH get_unique_in_stock_counter INTO unique_in_stock_counter_;
   CLOSE get_unique_in_stock_counter;
   IF (unique_in_stock_counter_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTIINVLOC: Handling Unit :P1 cannot be stored at more than one inventory location.', root_handling_unit_id_);
   END IF;

   OPEN  get_unique_move_transit_count;
   FETCH get_unique_move_transit_count INTO unique_move_transit_counter_;
   CLOSE get_unique_move_transit_count;
   IF (unique_move_transit_counter_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTISTOCKTRANS: Handling Unit :P1 cannot be in transit to more than one inventory location.', root_handling_unit_id_);
   END IF;

   OPEN  get_unique_order_transit_count;
   FETCH get_unique_order_transit_count INTO unique_order_transit_counter_;
   CLOSE get_unique_order_transit_count;
   IF (unique_order_transit_counter_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTORDTRANS: Handling Unit :P1 cannot be in transit between more than one source and destination site or warehouse.', root_handling_unit_id_);
   END IF;

   OPEN  get_unique_at_customer_counter;
   FETCH get_unique_at_customer_counter INTO unique_at_customer_counter_;
   CLOSE get_unique_at_customer_counter;
   IF (unique_at_customer_counter_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTIATCUST: Handling Unit :P1 cannot be stored at more than one customer address.', root_handling_unit_id_);
   END IF;

   IF (unique_in_stock_counter_ > 0 AND unique_move_transit_counter_ > 0) THEN
      position_1_ := in_inventory_;
      position_2_ := in_inventory_move_transit_;
      RAISE position_error;
   END IF;

   IF (unique_in_stock_counter_ > 0 AND unique_order_transit_counter_ > 0) THEN
      position_1_ := in_inventory_;
      position_2_ := in_internal_order_transit_;
      RAISE position_error;
   END IF;

   IF (unique_in_stock_counter_ > 0 AND unique_at_customer_counter_ > 0) THEN
      position_1_ := in_inventory_;
      position_2_ := at_customer_;
      RAISE position_error;
   END IF;

   IF (unique_move_transit_counter_ > 0 AND unique_order_transit_counter_ > 0) THEN
      position_1_ := in_inventory_move_transit_;
      position_2_ := in_internal_order_transit_;
      RAISE position_error;
   END IF;

   IF (unique_move_transit_counter_ > 0 AND unique_at_customer_counter_ > 0) THEN
      position_1_ := in_inventory_move_transit_;
      position_2_ := at_customer_;
      RAISE position_error;
   END IF;

   IF (unique_order_transit_counter_ > 0 AND unique_at_customer_counter_ > 0) THEN
      position_1_ := in_internal_order_transit_;
      position_2_ := at_customer_;
      RAISE position_error;
   END IF;

EXCEPTION
   WHEN position_error THEN
      Error_Sys.Record_General(lu_name_, 'MULTIPOSERR: Handling Unit :P1 cannot be :P2 and :P3 at the same time.', root_handling_unit_id_, position_1_, position_2_);
END Validate_Structure_Position;


PROCEDURE Modify_Waiv_Dev_Rej_No (
   handling_unit_id_ IN NUMBER,
   waiv_dev_rej_no_  IN VARCHAR2,
   source_ref1_      IN VARCHAR2 DEFAULT NULL,
   source_ref2_      IN VARCHAR2 DEFAULT NULL,
   source_ref3_      IN VARCHAR2 DEFAULT NULL,
   source_ref4_      IN VARCHAR2 DEFAULT NULL,
   source_ref_type_  IN VARCHAR2 DEFAULT NULL )
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => modify_waiv_dev_rej_no_,
                              string_parameter1_  => waiv_dev_rej_no_,
                              source_ref1_        => source_ref1_,
                              source_ref2_        => source_ref2_,
                              source_ref3_        => source_ref3_,
                              source_ref4_        => source_ref4_,
                              source_ref_type_    => source_ref_type_);
END Modify_Waiv_Dev_Rej_No;


PROCEDURE Modify_Waiv_Dev_Rej_No (
    handling_unit_id_list_  IN VARCHAR2,
    waiv_dev_rej_no_        IN VARCHAR2,
    source_ref1_            IN VARCHAR2 DEFAULT NULL,
    source_ref2_            IN VARCHAR2 DEFAULT NULL,
    source_ref3_            IN VARCHAR2 DEFAULT NULL,
    source_ref4_            IN VARCHAR2 DEFAULT NULL,
    source_ref_type_        IN VARCHAR2 DEFAULT NULL )
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Modify_Waiv_Dev_Rej_No(handling_unit_id_      => handling_unit_id_tab_(i).handling_unit_id,
                             waiv_dev_rej_no_       => waiv_dev_rej_no_,
                             source_ref1_           => source_ref1_,
                             source_ref2_           => source_ref2_,
                             source_ref3_           => source_ref3_,
                             source_ref4_           => source_ref4_,
                             source_ref_type_       => source_ref_type_);
   END LOOP;
END Modify_Waiv_Dev_Rej_No;


PROCEDURE Modify_Availability_Control_Id (
   handling_unit_id_        IN NUMBER,
   availability_control_id_ IN VARCHAR2 )
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => modify_availability_ctrl_id_,
                              string_parameter1_  => availability_control_id_);
END Modify_Availability_Control_Id;


PROCEDURE Modify_Availability_Control_Id (
   handling_unit_id_list_   IN VARCHAR2,
   availability_control_id_ IN VARCHAR2,
   execute_background_      IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   attr_               VARCHAR2(32000);
   description_        VARCHAR2(100);
BEGIN
   IF ( execute_background_ = Fnd_Boolean_API.DB_TRUE ) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID_LIST',   REPLACE(handling_unit_id_list_, Client_SYS.record_separator_, Client_SYS.text_separator_),   attr_);
      Client_SYS.Add_To_Attr('AVAILABILITY_CONTROL_ID', availability_control_id_, attr_);
      
      description_ := Language_SYS.Translate_Constant(lu_name_, 'EXECUTETASK: Changing availability control to :P1.', NULL, availability_control_id_) ;
      Transaction_SYS.Deferred_Call('Handling_Unit_API.Modify_Avail_Control_Id__', attr_, description_);
   ELSE
      Modify_Avail_Control_Id___(handling_unit_id_list_, availability_control_id_);
   END IF;
END Modify_Availability_Control_Id;


PROCEDURE Modify_Expiration_Date (
   handling_unit_id_ IN NUMBER,
   expiration_date_  IN DATE )
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => modify_expiration_date_,
                              date_parameter1_    => expiration_date_);
END Modify_Expiration_Date;


PROCEDURE Modify_Expiration_Date (
   handling_unit_id_list_   IN VARCHAR2,
   expiration_date_         IN DATE )
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Modify_Expiration_Date(handling_unit_id_  => handling_unit_id_tab_(i).handling_unit_id,
                             expiration_date_   => expiration_date_);
   END LOOP;
END Modify_Expiration_Date;


PROCEDURE Scrap (
   handling_unit_id_            IN NUMBER,
   scrap_cause_                 IN VARCHAR2,
   scrap_note_                  IN VARCHAR2,
   source_ref1_                 IN VARCHAR2 DEFAULT NULL,
   source_ref2_                 IN VARCHAR2 DEFAULT NULL,
   source_ref3_                 IN VARCHAR2 DEFAULT NULL,
   source_ref4_                 IN VARCHAR2 DEFAULT NULL,
   source_ref_type_             IN VARCHAR2 DEFAULT NULL,
   print_serviceability_tag_db_ IN VARCHAR2 DEFAULT Gen_Yes_No_API.DB_NO,
   error_when_stock_not_exist_  IN BOOLEAN  DEFAULT TRUE )
IS
   dummy_char_               VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_             => dummy_char_,
                              handling_unit_id_           => handling_unit_id_,
                              stock_operation_id_         => scrap_,
                              string_parameter1_          => scrap_cause_,
                              string_parameter2_          => scrap_note_,
                              string_parameter3_          => print_serviceability_tag_db_,
                              source_ref1_                => source_ref1_,
                              source_ref2_                => source_ref2_,
                              source_ref3_                => source_ref3_,
                              source_ref4_                => source_ref4_,
                              source_ref_type_            => source_ref_type_,
                              error_when_stock_not_exist_ => error_when_stock_not_exist_);
END Scrap;


PROCEDURE Issue_With_Posting (
   handling_unit_id_           IN NUMBER,
   account_no_                 IN VARCHAR2,
   code_b_                     IN VARCHAR2,
   code_c_                     IN VARCHAR2,
   code_d_                     IN VARCHAR2,
   code_e_                     IN VARCHAR2,
   code_f_                     IN VARCHAR2,
   code_g_                     IN VARCHAR2,
   code_h_                     IN VARCHAR2,
   code_i_                     IN VARCHAR2,
   code_j_                     IN VARCHAR2,
   source_                     IN VARCHAR2,
   error_when_stock_not_exist_ IN BOOLEAN DEFAULT TRUE )
IS
   dummy_char_               VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_             => dummy_char_,
                              handling_unit_id_           => handling_unit_id_,
                              stock_operation_id_         => issue_with_posting_,
                              string_parameter1_          => account_no_,
                              string_parameter2_          => code_b_,
                              string_parameter3_          => code_c_,
                              string_parameter4_          => code_d_,
                              string_parameter5_          => code_e_,
                              string_parameter6_          => code_f_,
                              string_parameter7_          => code_g_,
                              string_parameter8_          => code_h_,
                              string_parameter9_          => code_i_,
                              string_parameter10_         => code_j_,
                              string_parameter11_         => source_,
                              error_when_stock_not_exist_ => error_when_stock_not_exist_);
END Issue_With_Posting;


PROCEDURE Change_Stock_Location (
   handling_unit_id_          IN NUMBER, 
   to_contract_               IN VARCHAR2,
   to_location_no_            IN VARCHAR2,
   to_destination_            IN VARCHAR2 DEFAULT Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY),
   move_comment_              IN VARCHAR2 DEFAULT NULL,
   source_ref1_               IN VARCHAR2 DEFAULT NULL,
   source_ref2_               IN VARCHAR2 DEFAULT NULL,
   source_ref3_               IN VARCHAR2 DEFAULT NULL,
   source_ref4_               IN VARCHAR2 DEFAULT NULL,
   source_ref_type_           IN VARCHAR2 DEFAULT NULL,
   consume_consignment_stock_ IN VARCHAR2 DEFAULT NULL,
   to_waiv_dev_rej_no_        IN VARCHAR2 DEFAULT NULL,
   part_tracking_session_id_  IN NUMBER   DEFAULT NULL,
   transport_task_id_         IN NUMBER   DEFAULT NULL,
   string_parameter1_         IN VARCHAR2 DEFAULT NULL)
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => change_stock_location_,
                              string_parameter1_  => to_contract_,
                              string_parameter2_  => to_location_no_,
                              string_parameter3_  => to_destination_,
                              string_parameter4_  => move_comment_,
                              string_parameter5_  => source_ref1_,
                              string_parameter6_  => source_ref2_,
                              string_parameter7_  => source_ref3_,
                              string_parameter8_  => source_ref4_,
                              string_parameter9_  => source_ref_type_,
                              string_parameter10_ => consume_consignment_stock_,
                              string_parameter11_ => to_waiv_dev_rej_no_,
                              string_parameter12_ => string_parameter1_,
                              number_parameter1_  => part_tracking_session_id_,
                              number_parameter2_  => transport_task_id_);
END Change_Stock_Location;

   
PROCEDURE Receive_From_Inventory_Transit (
   handling_unit_id_   IN NUMBER )
IS
   dummy_char_               VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => receive_from_invent_transit_);
END Receive_From_Inventory_Transit;


   
PROCEDURE Add_To_Transport_Task (
   handling_unit_id_   IN NUMBER, 
   to_contract_        IN VARCHAR2,
   to_location_no_     IN VARCHAR2,
   to_destination_     IN VARCHAR2 DEFAULT Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY))
IS
   dummy_number_                NUMBER;
   local_available_qty_to_move_ NUMBER;
   transport_task_id_           NUMBER;
   location_type_               handling_unit_tab.location_type%TYPE;
   serial_dummy_tab_            Part_Serial_Catalog_API.Serial_No_Tab;
   serial_no_tab_               Part_Serial_Catalog_API.Serial_No_Tab;
   handling_unit_id_tab_        Handling_Unit_Id_Tab;
   
   CURSOR get_stock_records IS
      SELECT *
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND qty_onhand > 0
       ORDER BY qty_onhand DESC;
BEGIN
   location_type_ := Get_Location_Type_DB(handling_unit_id_);
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   
   IF (location_type_ IN (Inventory_Location_Type_API.DB_ARRIVAL,
                          Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Receive_Order_API.Add_Hu_To_Transport_Task(handling_unit_id_           => handling_unit_id_,
                                                    to_contract_                => to_contract_,
                                                    to_location_no_             => to_location_no_,
                                                    to_destination_             => to_destination_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSE
      Inventory_Event_Manager_API.Start_Session;
      
      FOR stock_rec_ IN get_stock_records LOOP
         IF (stock_rec_.qty_reserved > 0) THEN
            Inv_Part_Stock_Reservation_API.Move_Hu_Res_Wth_Transp_Task(transport_task_id_          => transport_task_id_,
                                                                       contract_                   => stock_rec_.contract,
                                                                       part_no_                    => stock_rec_.part_no,
                                                                       configuration_id_           => stock_rec_.configuration_id,
                                                                       from_location_no_           => stock_rec_.location_no,
                                                                       lot_batch_no_               => stock_rec_.lot_batch_no,
                                                                       serial_no_                  => stock_rec_.serial_no,
                                                                       eng_chg_level_              => stock_rec_.eng_chg_level,
                                                                       waiv_dev_rej_no_            => stock_rec_.waiv_dev_rej_no,
                                                                       activity_seq_               => stock_rec_.activity_seq,
                                                                       handling_unit_id_           => stock_rec_.handling_unit_id,
                                                                       to_location_no_             => to_location_no_,
                                                                       quantity_to_move_           => stock_rec_.qty_reserved,
                                                                       check_storage_requirements_ => FALSE);
         END IF;

         IF ((stock_rec_.qty_onhand - stock_rec_.qty_reserved) > 0) THEN
            IF (stock_rec_.serial_no != '*') THEN
               serial_no_tab_(1).serial_no := stock_rec_.serial_no;
               local_available_qty_to_move_ := NULL;
            ELSE
               local_available_qty_to_move_ := stock_rec_.qty_onhand - stock_rec_.qty_reserved;
               serial_no_tab_.DELETE;
            END IF;

            Transport_Task_Manager_API.New_Or_Add_To_Existing(transport_task_id_          => transport_task_id_,
                                                              quantity_added_             => dummy_number_,
                                                              serials_added_              => serial_dummy_tab_,
                                                              part_no_                    => stock_rec_.part_no,
                                                              configuration_id_           => stock_rec_.configuration_id,
                                                              from_contract_              => stock_rec_.contract,
                                                              from_location_no_           => stock_rec_.location_no,
                                                              to_contract_                => to_contract_,
                                                              to_location_no_             => to_location_no_,
                                                              destination_                => to_destination_,
                                                              order_type_                 => NULL,
                                                              order_ref1_                 => NULL,
                                                              order_ref2_                 => NULL,  
                                                              order_ref3_                 => NULL,
                                                              order_ref4_                 => NULL,
                                                              pick_list_no_               => NULL,
                                                              shipment_id_                => NULL,
                                                              lot_batch_no_               => stock_rec_.lot_batch_no,
                                                              serial_no_tab_              => serial_no_tab_, 
                                                              eng_chg_level_              => stock_rec_.eng_chg_level,
                                                              waiv_dev_rej_no_            => stock_rec_.waiv_dev_rej_no,
                                                              activity_seq_               => stock_rec_.activity_seq,
                                                              handling_unit_id_           => stock_rec_.handling_unit_id,
                                                              quantity_to_add_            => local_available_qty_to_move_,
                                                              check_storage_requirements_ => FALSE);
         END IF;   
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   Transport_Task_Handl_Unit_API.Check_Storage_Requirements(handling_unit_id_tab_);
END Add_To_Transport_Task;


PROCEDURE Disconnect_Zero_Stock_In_Struc (
   handling_unit_id_   IN NUMBER )
IS
   handling_unit_id_tab_          Handling_Unit_Id_Tab;
   disconnect_this_handl_unit_id_ handling_unit_tab.handling_unit_id%TYPE;
BEGIN
   handling_unit_id_tab_     := Get_Node_And_Ascendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         IF (Has_Quantity_In_Stock___(handling_unit_id_tab_(i).handling_unit_id)) THEN
            IF (disconnect_this_handl_unit_id_ IS NOT NULL) THEN
               Modify_Parent_Handling_Unit_Id(handling_unit_id_        => disconnect_this_handl_unit_id_,
                                              parent_handling_unit_id_ => NULL);
            END IF;
         ELSE
            disconnect_this_handl_unit_id_ := handling_unit_id_tab_(i).handling_unit_id;
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Disconnect_Zero_Stock_In_Struc;


@UncheckedAccess
FUNCTION Get_Root_Handling_Unit_Id (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   parent_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
   root_handling_unit_id_   handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   parent_handling_unit_id_ := Get_Parent_Handling_Unit_Id(handling_unit_id_);

   IF (parent_handling_unit_id_ IS NULL) THEN
      root_handling_unit_id_ := handling_unit_id_;
   ELSE
      root_handling_unit_id_ := Get_Root_Handling_Unit_Id(parent_handling_unit_id_);
   END IF;

   RETURN (root_handling_unit_id_);
END Get_Root_Handling_Unit_Id;


@UncheckedAccess
FUNCTION Get_Root_Handling_Unit_Type_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   root_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);
   RETURN(Get_Handling_Unit_Type_Id(root_handling_unit_id_));
END Get_Root_Handling_Unit_Type_Id;


@UncheckedAccess
FUNCTION Get_Root_Sscc (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   root_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);
   RETURN(Get_Sscc(root_handling_unit_id_));
END Get_Root_Sscc;


@UncheckedAccess
FUNCTION Get_Root_Alt_Hu_Label_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   root_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);
   RETURN(Get_Alt_Handling_Unit_Label_Id(root_handling_unit_id_));
END Get_Root_Alt_Hu_Label_Id;

   
PROCEDURE Modify_Alt_Handl_Unit_Label_Id (
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2 )
IS
   record_ handling_unit_tab%ROWTYPE;
BEGIN
   record_                            := Lock_By_Keys___(handling_unit_id_);
   record_.alt_handling_unit_label_id := alt_handling_unit_label_id_; 
   Modify___(record_);
END Modify_Alt_Handl_Unit_Label_Id;


PROCEDURE Change_Stock_Location (
   handling_unit_id_list_ IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_location_no_        IN VARCHAR2,
   to_destination_        IN VARCHAR2 DEFAULT Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY),
   move_comment_          IN VARCHAR2 DEFAULT NULL,
   string_parameter1_     IN VARCHAR2 DEFAULT NULL)
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
   rec_                  handling_unit_tab%ROWTYPE;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         rec_ := Get_Object_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);
            
         IF (rec_.contract    != to_contract_ OR
             rec_.location_no != to_location_no_) THEN
             Change_Stock_Location(handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,
                                   to_contract_          => to_contract_,
                                   to_location_no_       => to_location_no_,
                                   to_destination_       => to_destination_,
                                   move_comment_         => move_comment_,
                                   string_parameter1_    => string_parameter1_);
         END IF;
      END LOOP;
   END IF;
END Change_Stock_Location;


PROCEDURE Receive_From_Inventory_Transit (
   handling_unit_id_list_       IN VARCHAR2 )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         IF (Is_In_Inventory_Transit___(handling_unit_id_tab_(i).handling_unit_id)) THEN
               Receive_From_Inventory_Transit(handling_unit_id_   => handling_unit_id_tab_(i).handling_unit_id);
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Receive_From_Inventory_Transit;


PROCEDURE Add_To_Transport_Task (
   handling_unit_id_list_ IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_location_no_        IN VARCHAR2,
   to_destination_        IN VARCHAR2 DEFAULT Inventory_Part_Destination_API.Decode(Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY))
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
   rec_                  handling_unit_tab%ROWTYPE;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         rec_ := Get_Object_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);
            
         IF ((rec_.contract    != to_contract_   ) OR
             (rec_.location_no != to_location_no_)) THEN
             Add_To_Transport_Task(handling_unit_id_tab_(i).handling_unit_id,
                                   to_contract_,
                                   to_location_no_,
                                   to_destination_);
         END IF;
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Add_To_Transport_Task;


PROCEDURE Scrap (
   handling_unit_id_list_       IN VARCHAR2,
   scrap_cause_                 IN VARCHAR2,
   scrap_note_                  IN VARCHAR2,
   source_ref1_                 IN VARCHAR2 DEFAULT NULL,
   source_ref2_                 IN VARCHAR2 DEFAULT NULL,
   source_ref3_                 IN VARCHAR2 DEFAULT NULL,
   source_ref4_                 IN VARCHAR2 DEFAULT NULL,
   source_ref_type_             IN VARCHAR2 DEFAULT NULL,
   print_serviceability_tag_db_ IN VARCHAR2 DEFAULT Gen_Yes_No_API.DB_NO,
   error_when_stock_not_exist_  IN BOOLEAN  DEFAULT TRUE )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         Scrap(handling_unit_id_            => handling_unit_id_tab_(i).handling_unit_id,
               scrap_cause_                 => scrap_cause_,
               scrap_note_                  => scrap_note_,
               source_ref1_                 => source_ref1_,
               source_ref2_                 => source_ref2_,
               source_ref3_                 => source_ref3_,
               source_ref4_                 => source_ref4_,
               source_ref_type_             => source_ref_type_,
               print_serviceability_tag_db_ => print_serviceability_tag_db_,
               error_when_stock_not_exist_  => error_when_stock_not_exist_);
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;  
END Scrap;


PROCEDURE Issue_With_Posting (
   handling_unit_id_list_      IN VARCHAR2,
   account_no_                 IN VARCHAR2,
   code_b_                     IN VARCHAR2,
   code_c_                     IN VARCHAR2,
   code_d_                     IN VARCHAR2,
   code_e_                     IN VARCHAR2,
   code_f_                     IN VARCHAR2,
   code_g_                     IN VARCHAR2,
   code_h_                     IN VARCHAR2,
   code_i_                     IN VARCHAR2,
   code_j_                     IN VARCHAR2,
   source_                     IN VARCHAR2,
   error_when_stock_not_exist_ IN BOOLEAN DEFAULT TRUE)
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         Issue_With_Posting(handling_unit_id_           => handling_unit_id_tab_(i).handling_unit_id,
                            account_no_                 => account_no_,
                            code_b_                     => code_b_,
                            code_c_                     => code_c_,
                            code_d_                     => code_d_,
                            code_e_                     => code_e_,
                            code_f_                     => code_f_,
                            code_g_                     => code_g_,
                            code_h_                     => code_h_,
                            code_i_                     => code_i_,
                            code_j_                     => code_j_,
                            source_                     => source_,
                            error_when_stock_not_exist_ => error_when_stock_not_exist_);
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Issue_With_Posting;

PROCEDURE Modify_Parent_Handling_Unit_Id (
   handling_unit_id_list_       IN VARCHAR2,
   parent_handling_unit_id_     IN NUMBER,
   keep_structure_              IN VARCHAR2 DEFAULT 'FALSE')
IS
   handling_unit_id_tab_   Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      <<outer>>
      FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
         IF (keep_structure_ = 'TRUE' AND i > 1) THEN
            FOR j IN 1 .. i - 1 LOOP
               IF (Has_Parent_At_Any_Level(handling_unit_id_tab_(i).handling_unit_id,
                                           handling_unit_id_tab_(j).handling_unit_id) = 'TRUE') THEN
                  CONTINUE outer;
               END IF;
            END LOOP;
         END IF;

         Modify_Parent_Handling_Unit_Id(handling_unit_id_        => handling_unit_id_tab_(i).handling_unit_id, 
                                        parent_handling_unit_id_ => parent_handling_unit_id_);
      END LOOP;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Modify_Parent_Handling_Unit_Id;


@UncheckedAccess
FUNCTION Has_Any_Parent_At_Any_Level (
   handling_unit_id_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_id_tab_   Handling_Unit_Id_Tab;
   contains_related_       VARCHAR2(5) := 'FALSE';
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      <<outer>>
      FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
         IF (i > 1) THEN
            -- Backtrack the handling unit tab to see if any previous HU is a parent of the current one.
            -- Since the tab is ordered by node level the topmost parents will be earliest in the tab.
            FOR j IN 1 .. i - 1 LOOP
               IF (Has_Parent_At_Any_Level(handling_unit_id_tab_(i).handling_unit_id,
                                           handling_unit_id_tab_(j).handling_unit_id) = 'TRUE') THEN
                  contains_related_ := 'TRUE';
                  EXIT outer;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END IF;

   RETURN contains_related_;
END Has_Any_Parent_At_Any_Level;
   


@UncheckedAccess
FUNCTION Get_Top_Parent_Handl_Unit_Id (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   root_handling_unit_id_ NUMBER;
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);
   IF (handling_unit_id_ = root_handling_unit_id_) THEN
      RETURN NULL;
   END IF;  
   RETURN root_handling_unit_id_;
END Get_Top_Parent_Handl_Unit_Id;


@UncheckedAccess
FUNCTION Get_Top_Parent_Hu_Type_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   top_parent_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   top_parent_handling_unit_id_ := Get_Top_Parent_Handl_Unit_Id(handling_unit_id_);
   RETURN(Get_Handling_Unit_Type_Id(top_parent_handling_unit_id_));
END Get_Top_Parent_Hu_Type_Id;


@UncheckedAccess
FUNCTION Get_Top_Parent_Sscc (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   top_parent_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   top_parent_handling_unit_id_ := Get_Top_Parent_Handl_Unit_Id(handling_unit_id_);
   RETURN(Get_Sscc(top_parent_handling_unit_id_));
END Get_Top_Parent_Sscc;


@UncheckedAccess
FUNCTION Get_Top_Parent_Alt_Hu_Label_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   top_parent_handling_unit_id_ handling_unit_tab.parent_handling_unit_id%TYPE;
BEGIN
   top_parent_handling_unit_id_ := Get_Top_Parent_Handl_Unit_Id(handling_unit_id_);
   RETURN(Get_Alt_Handling_Unit_Label_Id(top_parent_handling_unit_id_));
END Get_Top_Parent_Alt_Hu_Label_Id;


@UncheckedAccess
FUNCTION Get_Second_Level_Parent_Hu_Id (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_second_level_parent_hu_id IS
      SELECT PRIOR handling_unit_id
         FROM handling_unit_tab
         WHERE parent_handling_unit_id IS NULL
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id = handling_unit_id_;
   second_level_parent_hu_id_ handling_unit_tab.handling_unit_id%TYPE;
BEGIN
   OPEN get_second_level_parent_hu_id;
   FETCH get_second_level_parent_hu_id INTO second_level_parent_hu_id_;
   CLOSE get_second_level_parent_hu_id;
   IF (handling_unit_id_ = second_level_parent_hu_id_) THEN
      second_level_parent_hu_id_ := NULL;
   END IF;  
   RETURN second_level_parent_hu_id_;
END Get_Second_Level_Parent_Hu_Id;


FUNCTION Get_Last_Count_Date (
   handling_unit_id_ IN NUMBER ) RETURN DATE
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
   temp_count_date_      inventory_part_in_stock_tab.last_count_date%TYPE;
   oldest_count_date_    inventory_part_in_stock_tab.last_count_date%TYPE;
   empty_count_date_     BOOLEAN := FALSE;
   dummy_                NUMBER;

   CURSOR get_min_count_date(handling_unit_id_ IN NUMBER) IS
      SELECT MIN(last_count_date)
      FROM inventory_part_in_stock_tab
      WHERE handling_unit_id = handling_unit_id_
      AND last_count_date IS NOT NULL
      AND (qty_onhand != 0 OR qty_in_transit != 0);

   CURSOR check_empty_count_date(handling_unit_id_ IN NUMBER) IS
      SELECT 1
      FROM inventory_part_in_stock_tab
      WHERE handling_unit_id = handling_unit_id_
      AND last_count_date IS NULL
      AND (qty_onhand != 0 OR qty_in_transit != 0);
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN 1 .. handling_unit_id_tab_.COUNT LOOP
         OPEN check_empty_count_date(handling_unit_id_tab_(i).handling_unit_id);
         FETCH check_empty_count_date INTO dummy_;
         IF (check_empty_count_date%FOUND) THEN
            empty_count_date_ := TRUE;
         END IF;
         CLOSE check_empty_count_date;

         IF (empty_count_date_) THEN
            oldest_count_date_ := NULL;
            EXIT;
         ELSE
            OPEN get_min_count_date(handling_unit_id_tab_(i).handling_unit_id);
            FETCH get_min_count_date INTO temp_count_date_;
            CLOSE get_min_count_date;
            IF (oldest_count_date_ IS NULL OR oldest_count_date_ > temp_count_date_) THEN
               oldest_count_date_ := temp_count_date_;
            END IF;
         END IF;
      END LOOP;
   END IF;
   RETURN oldest_count_date_;
END Get_Last_Count_Date;


FUNCTION Has_Stock_Frozen_For_Counting (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN  
IS
   handling_unit_id_tab_          Handling_Unit_Id_Tab;  
   has_stock_frozen_for_counting_ BOOLEAN := FALSE;
   dummy_                         NUMBER;

   CURSOR exist_control (handling_unit_id_ IN NUMBER) IS
      SELECT 1
      FROM inventory_part_in_stock_tab
      WHERE handling_unit_id = handling_unit_id_
      AND (qty_onhand != 0 OR qty_in_transit != 0)
      AND freeze_flag = Inventory_Part_Freeze_Code_API.DB_FROZEN_FOR_COUNTING;
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN exist_control(handling_unit_id_tab_(i).handling_unit_id);
         FETCH exist_control INTO dummy_;
         IF (exist_control%FOUND) THEN
            has_stock_frozen_for_counting_ := TRUE;
         END IF;
         CLOSE exist_control;

         EXIT WHEN has_stock_frozen_for_counting_;
      END LOOP;
   END IF;
   RETURN (has_stock_frozen_for_counting_);
END Has_Stock_Frozen_For_Counting;


FUNCTION Has_Stock_Frozen_For_Counting (
   handling_unit_id_tab_ IN Handling_Unit_Id_Tab ) RETURN BOOLEAN  
IS
   has_stock_frozen_for_counting_ BOOLEAN := FALSE;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         IF (Has_Stock_Frozen_For_Counting(handling_unit_id_tab_(i).handling_unit_id)) THEN
            has_stock_frozen_for_counting_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN (has_stock_frozen_for_counting_);
END Has_Stock_Frozen_For_Counting;


FUNCTION Get_Stock_Attr_Value_If_Unique (
   no_unique_value_found_  OUT BOOLEAN,
   handling_unit_id_       IN  NUMBER,
   column_name_            IN  VARCHAR2,
   sql_where_expression_   IN  VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   handling_unit_id_tab_         Handling_Unit_Id_Tab;  
   local_sql_where_expression_   VARCHAR2(2000) := sql_where_expression_ || ' AND (QTY_ONHAND != 0 OR QTY_IN_TRANSIT != 0) ';
   handling_unit_unique_value_   VARCHAR2(2000);
   hu_structure_unique_value_    VARCHAR2(2000);
   too_many_values_found_        BOOLEAN := FALSE;
   local_no_unique_value_found_  BOOLEAN;
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN

      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         handling_unit_unique_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => local_no_unique_value_found_, 
                                                                                               contract_                   => NULL,  
                                                                                               part_no_                    => NULL,  
                                                                                               configuration_id_           => NULL,  
                                                                                               location_no_                => NULL,  
                                                                                               lot_batch_no_               => NULL,  
                                                                                               serial_no_                  => NULL, 
                                                                                               eng_chg_level_              => NULL, 
                                                                                               waiv_dev_rej_no_            => NULL, 
                                                                                               activity_seq_               => NULL, 
                                                                                               handling_unit_id_           => handling_unit_id_tab_(i).handling_unit_id,  
                                                                                               alt_handling_unit_label_id_ => '%',  
                                                                                               column_name_                => column_name_,  
                                                                                               sql_where_expression_       => local_sql_where_expression_ );

         IF (local_no_unique_value_found_ = TRUE) THEN
         -- no record found
            CONTINUE; 
         ELSIF (local_no_unique_value_found_ = FALSE) AND (handling_unit_unique_value_ IS NULL) THEN
         -- too many values was found
            hu_structure_unique_value_ := NULL;
            too_many_values_found_ := TRUE;
            EXIT; 
         END IF;

         IF (hu_structure_unique_value_ IS NULL) THEN 
            hu_structure_unique_value_ := handling_unit_unique_value_;
         ELSIF Validate_SYS.Is_Different(handling_unit_unique_value_, hu_structure_unique_value_) THEN
            hu_structure_unique_value_ := NULL;
            too_many_values_found_ := TRUE; 
            EXIT; 
         END IF;
      END LOOP;
      
      IF (hu_structure_unique_value_ IS NULL AND NOT too_many_values_found_) THEN 
         no_unique_value_found_ := TRUE;  -- No record found
      ELSE
         no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
      END IF;
      
   END IF;
   RETURN hu_structure_unique_value_;
END Get_Stock_Attr_Value_If_Unique;


FUNCTION Get_Trans_Attr_Value_If_Unique (
   no_unique_value_found_  OUT BOOLEAN,
   handling_unit_id_       IN  NUMBER,
   column_name_            IN  VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_id_tab_         Handling_Unit_Id_Tab;  
   handling_unit_unique_value_   VARCHAR2(2000);
   hu_structure_unique_value_    VARCHAR2(2000);
   too_many_values_found_        BOOLEAN := FALSE;
   local_no_unique_value_found_  BOOLEAN;
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN

      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         handling_unit_unique_value_ := Transport_Task_Line_API.Get_Column_Value_If_Unique(no_unique_value_found_      => local_no_unique_value_found_, 
                                                                                           transport_task_id_          => NULL,
                                                                                           line_no_                    => NULL,
                                                                                           transport_task_status_db_   => NULL,
                                                                                           order_type_db_              => '%',
                                                                                           part_no_                    => NULL,
                                                                                           from_contract_              => NULL,
                                                                                           from_location_no_           => NULL,
                                                                                           to_contract_                => NULL,
                                                                                           destination_db_             => NULL,
                                                                                           serial_no_                  => NULL,
                                                                                           lot_batch_no_               => NULL,
                                                                                           eng_chg_level_              => NULL,
                                                                                           waiv_dev_rej_no_            => NULL,
                                                                                           activity_seq_               => NULL,
                                                                                           handling_unit_id_           => handling_unit_id_tab_(i).handling_unit_id,  
                                                                                           alt_handling_unit_label_id_ => '%',  
                                                                                           configuration_id_           => NULL,
                                                                                           column_name_                => column_name_);
   

         IF (local_no_unique_value_found_ = TRUE) THEN
         -- no record found
            CONTINUE; 
         ELSIF (local_no_unique_value_found_ = FALSE) AND (handling_unit_unique_value_ IS NULL) THEN
         -- too many values was found
            hu_structure_unique_value_ := NULL;
            too_many_values_found_ := TRUE;
            EXIT; 
         END IF;

         IF (hu_structure_unique_value_ IS NULL) THEN 
            hu_structure_unique_value_ := handling_unit_unique_value_;
         ELSIF Validate_SYS.Is_Different(handling_unit_unique_value_, hu_structure_unique_value_) THEN
            hu_structure_unique_value_ := NULL;
            too_many_values_found_ := TRUE; 
            EXIT; 
         END IF;
      END LOOP;
      
      IF (hu_structure_unique_value_ IS NULL AND NOT too_many_values_found_) THEN 
         no_unique_value_found_ := TRUE;  -- No record found
      ELSE
         no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
      END IF;
      
   END IF;
   RETURN hu_structure_unique_value_;
END Get_Trans_Attr_Value_If_Unique;

   
FUNCTION Get_Sum_Stock_Column_Value (
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   handling_unit_id_       IN  NUMBER,
   column_name_            IN  VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_id_tab_     Handling_Unit_Id_Tab;  
   sum_value_                NUMBER;
   column_value_             NUMBER;
BEGIN
   IF Get_Composition(handling_unit_id_) = Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_MIXED) THEN 
      sum_value_ := NULL;
   ELSE 
      handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
            column_value_ := Inventory_Part_In_Stock_API.Get_Sum_Column_Value(contract_             => contract_,  
                                                                              part_no_              => part_no_,  
                                                                              configuration_id_     => NULL,  
                                                                              location_no_          => NULL,  
                                                                              lot_batch_no_         => NULL,  
                                                                              serial_no_            => NULL, 
                                                                              eng_chg_level_        => NULL, 
                                                                              waiv_dev_rej_no_      => NULL, 
                                                                              activity_seq_         => NULL, 
                                                                              handling_unit_id_     => handling_unit_id_tab_(i).handling_unit_id,  
                                                                              column_name_          => column_name_,  
                                                                              sql_where_expression_ => NULL);
            IF column_value_ IS NOT NULL THEN 
               sum_value_ := NVL(sum_value_, 0) + column_value_;
            END IF; 
         END LOOP;
      END IF;
   END IF ; 
   RETURN sum_value_;
END Get_Sum_Stock_Column_Value;


FUNCTION Get_Sum_Trans_Column_Value (
   from_contract_          IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   handling_unit_id_       IN  NUMBER,
   column_name_            IN  VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_id_tab_     Handling_Unit_Id_Tab;  
   sum_value_                NUMBER;
   column_value_             NUMBER;
BEGIN
   IF Get_Composition(handling_unit_id_) = Handling_Unit_Composition_API.Decode(Handling_Unit_Composition_API.DB_MIXED) THEN 
      sum_value_ := NULL;
   ELSE 
      handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
            column_value_ := Transport_Task_Line_API.Get_Sum_Column_Value(transport_task_id_          => NULL,
                                                                          line_no_                    => NULL,
                                                                          transport_task_status_db_   => NULL,
                                                                          part_no_                    => part_no_,
                                                                          from_contract_              => from_contract_,
                                                                          from_location_no_           => NULL,
                                                                          to_contract_                => NULL,
                                                                          destination_db_             => NULL,
                                                                          serial_no_                  => NULL,
                                                                          lot_batch_no_               => NULL,
                                                                          eng_chg_level_              => NULL,
                                                                          waiv_dev_rej_no_            => NULL,
                                                                          activity_seq_               => NULL,
                                                                          handling_unit_id_           => handling_unit_id_tab_(i).handling_unit_id,
                                                                          configuration_id_           => NULL,
                                                                          column_name_                => column_name_);
            IF column_value_ IS NOT NULL THEN 
               sum_value_ := NVL(sum_value_, 0) + column_value_;
            END IF; 
         END LOOP;
      END IF;
   END IF ; 
   RETURN sum_value_;
END Get_Sum_Trans_Column_Value;

   
FUNCTION Get_Total_Part_In_stock_Value (
   handling_unit_id_       IN  NUMBER ) RETURN NUMBER
IS
   handling_unit_id_tab_     Handling_Unit_Id_Tab;  
   total_inventory_value_        NUMBER := 0;
   
   CURSOR get_stock_rec_(handling_unit_id_ IN NUMBER) IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, 
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, qty_onhand
      FROM inventory_part_in_stock_tab
      WHERE handling_unit_id = handling_unit_id_
      AND (qty_onhand != 0 OR qty_in_transit != 0);
      
   TYPE Stock_Rec_Tab IS TABLE OF get_stock_rec_%ROWTYPE;
   stock_rec_tab_ Stock_Rec_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN get_stock_rec_(handling_unit_id_tab_(i).handling_unit_id);
         FETCH get_stock_rec_ BULK COLLECT INTO stock_rec_tab_;
         CLOSE get_stock_rec_;

         IF stock_rec_tab_.COUNT > 0 THEN 
            FOR j IN stock_rec_tab_.FIRST..stock_rec_tab_.LAST LOOP
               total_inventory_value_ := total_inventory_value_ + (stock_rec_tab_(j).qty_onhand * 
                                         Inventory_Part_In_Stock_API.Get_Company_Owned_Unit_Cost (stock_rec_tab_(j).Contract, 
                                                                                                  stock_rec_tab_(j).part_no, 
                                                                                                  stock_rec_tab_(j).configuration_id, 
                                                                                                  stock_rec_tab_(j).location_no, 
                                                                                                  stock_rec_tab_(j).lot_batch_no, 
                                                                                                  stock_rec_tab_(j).serial_no,  
                                                                                                  stock_rec_tab_(j).eng_chg_level, 
                                                                                                  stock_rec_tab_(j).waiv_dev_rej_no, 
                                                                                                  stock_rec_tab_(j).activity_seq, 
                                                                                                  handling_unit_id_tab_(i).handling_unit_id));
                                                                                                     
            END LOOP;
         END IF;
      END LOOP;
   END IF;
   RETURN total_inventory_value_;
END Get_Total_Part_In_stock_Value;
   

FUNCTION Get_Cust_Own_Stock_Acqui_Value (
   handling_unit_id_       IN  NUMBER ) RETURN NUMBER
IS
   handling_unit_id_tab_     Handling_Unit_Id_Tab;  
   acquisition_value_        NUMBER := 0;
   
   CURSOR get_stock_rec_(handling_unit_id_ IN NUMBER) IS
      SELECT owning_customer_no,part_no,serial_no,lot_batch_no,qty_onhand
      FROM inventory_part_in_stock_tab
      WHERE handling_unit_id = handling_unit_id_
      AND part_ownership = 'CUSTOMER OWNED'
      AND (qty_onhand != 0 OR qty_in_transit != 0);
      
   TYPE Stock_Rec_Tab IS TABLE OF get_stock_rec_%ROWTYPE;
   stock_rec_tab_ Stock_Rec_Tab;
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
            OPEN get_stock_rec_(handling_unit_id_tab_(i).handling_unit_id);
            FETCH get_stock_rec_ BULK COLLECT INTO stock_rec_tab_;
            CLOSE get_stock_rec_;

            IF stock_rec_tab_.COUNT > 0 THEN 
               FOR j IN stock_rec_tab_.FIRST..stock_rec_tab_.LAST LOOP
                  acquisition_value_  := acquisition_value_  + 
                                        (stock_rec_tab_(j).qty_onhand * 
                                         Cust_Part_Acq_Value_API.Get_Acquisition_Value(stock_rec_tab_(j).owning_customer_no,
                                                                                       stock_rec_tab_(j).part_no,
                                                                                       stock_rec_tab_(j).serial_no,
                                                                                       stock_rec_tab_(j).lot_batch_no));
               END LOOP;
            END IF;
         END LOOP;
      END IF;
      RETURN acquisition_value_;
   $ELSE 
      NULL;            
   $END          
END Get_Cust_Own_Stock_Acqui_Value;


   
PROCEDURE Change_Ownership_Between_Cust (
   handling_unit_id_             IN NUMBER,
   to_customer_                  IN VARCHAR2,
   ownership_transfer_reason_id_ IN VARCHAR2)
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_               => dummy_char_,
                              handling_unit_id_             => handling_unit_id_,
                              stock_operation_id_           => change_ownership_btwn_cust_,
                              string_parameter1_            => to_customer_,
                              ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
END Change_Ownership_Between_Cust;


PROCEDURE Change_Ownership_Between_Cust (
   handling_unit_id_list_         IN VARCHAR2,
   to_customer_                   IN VARCHAR2,
   ownership_transfer_reason_id_  IN VARCHAR2)
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Change_Ownership_Between_Cust(handling_unit_id_             => handling_unit_id_tab_(i).handling_unit_id,
                                    to_customer_                  => to_customer_,
                                    ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
   END LOOP;
END Change_Ownership_Between_Cust;


PROCEDURE Change_Ownership_To_Company (
   handling_unit_id_              IN NUMBER,
   ownership_transfer_reason_id_  IN VARCHAR2)
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Perform_Stock_Operation___(out_parameter1_               => dummy_char_,
                                 handling_unit_id_             => handling_unit_id_,
                                 stock_operation_id_           => change_ownership_to_company_,
                                 ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
   $ELSE
      NULL;            
   $END 
END Change_Ownership_To_Company;


PROCEDURE Change_Ownership_To_Company (
   handling_unit_id_list_         IN VARCHAR2,
   ownership_transfer_reason_id_  IN VARCHAR2)
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   
   FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
      Change_Ownership_To_Company(handling_unit_id_ => handling_unit_id_tab_(i).handling_unit_id,
                                  ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
   END LOOP;
END Change_Ownership_To_Company;


PROCEDURE Transfer_To_Proj_Inventory (
   handling_unit_id_    IN NUMBER,
   to_activity_seq_     IN VARCHAR2,
   notes_               IN VARCHAR2,
   report_earned_value_ IN VARCHAR2)
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => transfer_to_proj_inventory_,
                              string_parameter1_  => to_activity_seq_,
                              string_parameter2_  => notes_,
                              string_parameter3_  => report_earned_value_);
END Transfer_To_Proj_Inventory;


PROCEDURE Transfer_To_Proj_Inventory (
   handling_unit_id_list_  IN VARCHAR2,
   to_activity_seq_        IN VARCHAR2,
   notes_                  IN VARCHAR2,
   report_earned_value_    IN VARCHAR2 )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         IF (Has_Quantity_To_Move___(handling_unit_id_tab_(i).handling_unit_id)) THEN
            Transfer_To_Proj_Inventory(handling_unit_id_tab_(i).handling_unit_id,
                                       to_activity_seq_,
                                       notes_,
                                       report_earned_value_);
         END IF;
      END LOOP;
   END IF;
END Transfer_To_Proj_Inventory;


PROCEDURE Transfer_To_Std_Inventory (
   handling_unit_id_    IN NUMBER,
   notes_               IN VARCHAR2,
   report_earned_value_ IN VARCHAR2)
IS
   dummy_char_ VARCHAR2(2000);
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => dummy_char_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => transfer_to_std_inventory_,
                              string_parameter1_  => notes_,
                              string_parameter2_  => report_earned_value_);
END Transfer_To_Std_Inventory;


PROCEDURE Transfer_To_Std_Inventory (
   handling_unit_id_list_  IN VARCHAR2,
   notes_                  IN VARCHAR2,
   report_earned_value_    IN VARCHAR2 )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         IF (Has_Quantity_To_Move___(handling_unit_id_tab_(i).handling_unit_id)) THEN
            Transfer_To_Std_Inventory(handling_unit_id_tab_(i).handling_unit_id,
                                      notes_,
                                      report_earned_value_);
         END IF;
      END LOOP;
   END IF;
END Transfer_To_Std_Inventory;


@UncheckedAccess
FUNCTION Source_Ref_Exists (
   source_ref1_    IN VARCHAR2,
   source_ref2_    IN VARCHAR2,
   source_ref3_    IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_           NUMBER;
   hu_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR check_exist IS
      SELECT 1
      FROM  handling_unit_tab
      WHERE source_ref1 = source_ref1_
      AND   source_ref2  = source_ref2_
      AND   source_ref3  = source_ref3_
      AND   source_ref_type  = source_ref_type_db_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      hu_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN hu_exist_;
END Source_Ref_Exists;


@UncheckedAccess
FUNCTION Is_Connected_To_Source_Ref (
   handling_unit_id_    IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   is_connected_to_source_ref_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   rec_                          Handling_Unit_API.Public_Rec;
BEGIN
   rec_ := Get(handling_unit_id_);
   
   IF ((rec_.source_ref_type = source_ref_type_db_) AND
       (rec_.source_ref1 = source_ref1_) AND
       (Validate_SYS.Is_Equal(rec_.source_ref2, source_ref2_)) AND
       (Validate_SYS.Is_Equal(rec_.source_ref3, source_ref3_))) THEN
      is_connected_to_source_ref_ := Fnd_Boolean_API.DB_TRUE;
   END IF;

   RETURN is_connected_to_source_ref_;
END Is_Connected_To_Source_Ref;


@UncheckedAccess
FUNCTION Has_Quantity_In_Stock (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_quantity_in_stock_ VARCHAR2(5);
BEGIN
   IF Has_Quantity_In_Stock___(handling_unit_id_) THEN
      has_quantity_in_stock_ := 'TRUE';
   ELSE
      has_quantity_in_stock_ := 'FALSE';
   END IF;
      
   RETURN has_quantity_in_stock_;
END Has_Quantity_In_Stock;


@UncheckedAccess
FUNCTION Has_Inventory_Transaction_Hist (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_inventory_transaction_ VARCHAR2(5);
BEGIN
   IF (Inventory_Transaction_Hist_API.Check_Handling_Unit_Exist(handling_unit_id_)) THEN
      has_inventory_transaction_ := 'TRUE';
   ELSE
      has_inventory_transaction_ := 'FALSE';
   END IF;
   
   RETURN has_inventory_transaction_;
END Has_Inventory_Transaction_Hist;

-- Modify
--   Public interface for modifying a handling unit.
PROCEDURE Modify (
   handling_unit_id_           IN VARCHAR2,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   width_                      IN NUMBER,
   height_                     IN NUMBER,
   depth_                      IN NUMBER,
   manual_gross_weight_        IN NUMBER,
   manual_volume_              IN NUMBER,
   print_label_db_             IN VARCHAR2 DEFAULT NULL,
   print_content_label_db_     IN VARCHAR2 DEFAULT NULL,
   print_shipment_label_db_    IN VARCHAR2 DEFAULT NULL,
   no_of_handling_unit_labels_ IN NUMBER   DEFAULT NULL,
   no_of_content_labels_       IN NUMBER   DEFAULT NULL,
   no_of_shipment_labels_      IN NUMBER   DEFAULT NULL )
IS
   newrec_ handling_unit_tab%ROWTYPE;
BEGIN
   newrec_                            := Lock_By_Keys___(handling_unit_id_);
   newrec_.sscc                       := sscc_;
   newrec_.alt_handling_unit_label_id := alt_handling_unit_label_id_;
   newrec_.width                      := width_;
   newrec_.height                     := height_;
   newrec_.depth                      := depth_;
   newrec_.manual_gross_weight        := manual_gross_weight_;
   newrec_.manual_volume              := manual_volume_;
   IF (print_label_db_ IS NOT NULL) THEN
      newrec_.print_label             := print_label_db_;
   END IF;
   IF (print_content_label_db_ IS NOT NULL) THEN
      newrec_.print_content_label     := print_content_label_db_;
   END IF;
   IF (print_shipment_label_db_ IS NOT NULL) THEN
      newrec_.print_shipment_label    := print_shipment_label_db_;
   END IF;
   IF (no_of_handling_unit_labels_ IS NOT NULL) THEN
      newrec_.no_of_handling_unit_labels := no_of_handling_unit_labels_;
   END IF;
   IF (no_of_content_labels_ IS NOT NULL) THEN
      newrec_.no_of_content_labels       := no_of_content_labels_;
   END IF;                               
   IF (no_of_shipment_labels_ IS NOT NULL) THEN
      newrec_.no_of_shipment_labels      := no_of_shipment_labels_;
   END IF;

   Modify___(newrec_);
END Modify;


PROCEDURE Print_Handling_Unit_Label (
   handling_unit_id_           IN NUMBER,
   no_of_handling_unit_labels_ IN NUMBER DEFAULT 1 )
IS
   printer_id_      VARCHAR2(250);
   print_job_attr_  VARCHAR2(200);
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   print_job_id_    NUMBER;
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Generate a new print job id
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'HANDLING_UNIT_LABEL_REP');
   Client_SYS.Clear_Attr(print_job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_job_attr_);
   Print_Job_API.New(print_job_id_, print_job_attr_);

   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'HANDLING_UNIT_LABEL_REP', report_attr_);

   FOR i_ IN 1 .. no_of_handling_unit_labels_ LOOP          
      -- Create the report
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

      -- Connect the created report to a print job id
      Client_SYS.Clear_Attr(print_job_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_job_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, print_job_attr_);
      Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', print_job_attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout('HANDLING_UNIT_LABEL_REP'), print_job_attr_);
      Print_Job_Contents_API.New_Instance(print_job_attr_);
   END LOOP;

   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;
END Print_Handling_Unit_Label;


PROCEDURE Print_Hand_Unit_Content_Label (
   handling_unit_id_           IN NUMBER,
   no_of_handling_unit_labels_ IN NUMBER DEFAULT 1 )
IS
   printer_id_      VARCHAR2(250);
   print_job_attr_  VARCHAR2(200);
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   print_job_id_    NUMBER;
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Generate a new print job id
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'HANDL_UNIT_CONTENT_LABEL_REP');
   Client_SYS.Clear_Attr(print_job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_job_attr_);
   Print_Job_API.New(print_job_id_, print_job_attr_);

   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'HANDL_UNIT_CONTENT_LABEL_REP', report_attr_);

   FOR i_ IN 1 .. no_of_handling_unit_labels_ LOOP          
      -- Create the report
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

      -- Connect the created report to a print job id
      Client_SYS.Clear_Attr(print_job_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_job_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, print_job_attr_);
      Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', print_job_attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout('HANDL_UNIT_CONTENT_LABEL_REP'), print_job_attr_);
      Print_Job_Contents_API.New_Instance(print_job_attr_);
   END LOOP;

   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;
END Print_Hand_Unit_Content_Label;


PROCEDURE Print_Shpmnt_Hand_Unit_Label (
   handling_unit_id_           IN NUMBER,
   shipment_id_                IN NUMBER,
   no_of_handling_unit_labels_ IN NUMBER DEFAULT 1 )
IS
   printer_id_      VARCHAR2(250);
   print_job_attr_  VARCHAR2(200);
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   print_job_id_    NUMBER;
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Generate a new print job id
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'SHPMNT_HANDL_UNIT_LABEL_REP');
   Client_SYS.Clear_Attr(print_job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_job_attr_);
   Print_Job_API.New(print_job_id_, print_job_attr_);

   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'SHPMNT_HANDL_UNIT_LABEL_REP', report_attr_);

   FOR i_ IN 1 .. no_of_handling_unit_labels_ LOOP          
      -- Create the report
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, parameter_attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

      -- Connect the created report to a print job id
      Client_SYS.Clear_Attr(print_job_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_job_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, print_job_attr_);
      Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', print_job_attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout('SHPMNT_HANDL_UNIT_LABEL_REP'), print_job_attr_);
      Print_Job_Contents_API.New_Instance(print_job_attr_);
   END LOOP;

   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;
END Print_Shpmnt_Hand_Unit_Label;


-- This method is used by DataCapRecHuFromTrans, DataCaptAttachPartHu, DataCaptChangeParentHu, 
-- DataCaptCountHandlUnit, DataCaptCreateHndlUnit, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
-- DataCaptMoveHandlUnit, DataCaptScrapHandlUnit, DataCaptReportPickHu, DataCapAttachReceiptHu,
-- DataCaptRecSoByProd, DataCaptRepPickHuSo and DataCaptUnissueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   handling_unit_id_             IN NUMBER,
   sscc_                         IN VARCHAR2,
   alt_handling_unit_label_id_   IN VARCHAR2,
   capture_session_id_           IN NUMBER,
   column_name_                  IN VARCHAR2,
   lov_type_db_                  IN VARCHAR2,    
   sql_where_expression_         IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values           IS REF CURSOR;
   get_lov_values_               Get_Lov_Values;
   stmt_                         VARCHAR2(4000);
   TYPE Lov_Value_Tab            IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_                Lov_Value_Tab;
   second_column_name_           VARCHAR2(200);
   second_column_value_          VARCHAR2(200);
   lov_item_description_         VARCHAR2(200);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   temp_handling_unit_id_        NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM  HANDLING_UNIT_TAB ';
                          
      IF (handling_unit_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
      END IF;
      IF (sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
      ELSIF (sscc_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND sscc = :sscc_ ';
      ELSE
         stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
      END IF;

      IF (alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
      END IF;
      
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC';

      @ApproveDynamicStatement(2015-10-29,KHVESE)
      OPEN get_lov_values_ FOR stmt_ USING handling_unit_id_,                                       
                                           sscc_,                                           
                                           alt_handling_unit_label_id_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         IF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION';
         ELSIF (column_name_ IN ('SSCC')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT';
         ELSIF (column_name_ IN ('LOCATION_NO')) THEN
            --Description should conditionally remove for those processes that their LOV contains locations from different sites with same
            --id and different descriptions. Otherwise since distinction is only on location id and description shows the name of location
            --on current site, description can be confusing for user. 
            second_column_name_ := 'LOCATION_DESCRIPTION';
         END IF;

         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC') THEN
                     temp_handling_unit_id_ := Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') THEN
                     temp_handling_unit_id_ := Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'LOCATION_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(session_rec_.session_contract, lov_value_tab_(i));            
                  END IF;

                  IF temp_handling_unit_id_ IS NOT NULL THEN 
                     second_column_value_ := Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
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


-- This method is used by DataCaptReportPickHu, DataCaptReportPickPart, DataCapPackIntoHuShip, 
-- DataCaptRecSo and DataCaptRecSoHu
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   handling_unit_id_              IN NUMBER,
   shipment_id_                   IN NUMBER, 
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   capture_session_id_            IN NUMBER,
   column_name_                   IN VARCHAR2,
   source_ref1_                   IN VARCHAR2,
   source_ref2_                   IN VARCHAR2,
   source_ref3_                   IN VARCHAR2,
   source_ref_type_db_            IN VARCHAR2,
   lov_type_db_                   IN VARCHAR2, 
   sql_where_expression_          IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values            IS REF CURSOR;
   get_lov_values_                Get_Lov_Values;
   stmt_                          VARCHAR2(4000);
   TYPE Lov_Value_Tab             IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_                 Lov_Value_Tab;
   second_column_name_            VARCHAR2(200);
   second_column_value_           VARCHAR2(200);
   lov_item_description_          VARCHAR2(200);
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_            NUMBER;
   exit_lov_                      BOOLEAN := FALSE;
   temp_handling_unit_id_         NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      -- temporary remove when we have changed so lov_type_db_ is always sent into all lov methods
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;
      stmt_ := stmt_  || ' FROM  HANDLING_UNIT_TAB ';
                           
      IF (handling_unit_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
      END IF;
      IF (shipment_id_ = -1) THEN
         stmt_ := stmt_|| ' AND :shipment_id_ = -1 ';
      ELSIF (shipment_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND (shipment_id IS NULL AND :shipment_id_ IS NULL)  ';
      END IF;
      IF (sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
      ELSIF (sscc_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND sscc = :sscc_ ';
      ELSE
         stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
      END IF;

      IF (alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
      END IF;
       IF (source_ref_type_db_ = '%') THEN 
         stmt_ := stmt_ || ' AND :source_ref_type_db_ = ''%'' ';
      ELSIF (source_ref_type_db_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND source_ref_type = :source_ref_type_db_ ';
      ELSE
         stmt_ := stmt_ || ' AND (source_ref_type IS NULL AND :source_ref_type_db_ IS NULL) ';
      END IF;
       IF (source_ref1_ = '%') THEN 
         stmt_ := stmt_ || ' AND :source_ref1_ = ''%'' ';
      ELSIF (source_ref1_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_ ';
      ELSE
         stmt_ := stmt_ || ' AND (source_ref1 IS NULL AND :source_ref1_ IS NULL) ';
      END IF;
       IF (source_ref2_ = '%') THEN 
         stmt_ := stmt_ || ' AND :source_ref2_ = ''%'' ';
      ELSIF (source_ref2_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_ ';
      ELSE
         stmt_ := stmt_ || ' AND (source_ref2 IS NULL AND :source_ref2_ IS NULL) ';
      END IF;
       IF (source_ref3_ = '%') THEN 
         stmt_ := stmt_ || ' AND :source_ref3_ = ''%'' ';
      ELSIF (source_ref3_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_ ';
      ELSE
         stmt_ := stmt_ || ' AND (source_ref3 IS NULL AND :source_ref3_ IS NULL) ';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC';

      @ApproveDynamicStatement(2015-10-29,KHVESE)
      OPEN get_lov_values_ FOR stmt_ USING handling_unit_id_, 
                                           shipment_id_,
                                           sscc_,                                           
                                           alt_handling_unit_label_id_,
                                           source_ref_type_db_,                                           
                                           source_ref1_,
                                           source_ref2_,                                          
                                           source_ref3_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         IF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION';
         ELSIF (column_name_ IN ('SSCC')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
            second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT';
         ELSIF (column_name_ IN ('LOCATION_NO')) THEN
            --Description should conditionally remove for those processes that their LOV contains locations from different sites with same
            --id and different descriptions. Otherwise since distinction is only on location id and description shows the name of location
            --on current site, description can be confusing for user. 
            second_column_name_ := 'LOCATION_DESCRIPTION';
         END IF;

         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC') THEN
                     temp_handling_unit_id_ := Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') THEN
                     temp_handling_unit_id_ := Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'LOCATION_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(session_rec_.session_contract, lov_value_tab_(i));            
                  END IF;
                  
                  IF temp_handling_unit_id_ IS NOT NULL THEN 
                     second_column_value_ := Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
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


-- This method is used by DataCapRecHuFromTrans, DataCaptAttachPartHu, DataCaptChangeParentHu,
-- DataCaptCountHandlUnit, DataCaptCreateHndlUnit, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
-- DataCaptMoveHandlUnit, DataCaptScrapHandlUnit, DataCaptReportPickHu, DataCapAttachReceiptHu,
-- DataCaptRecSoByProd and DataCaptRepPickHuSo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_         OUT BOOLEAN,
   handling_unit_id_              IN  NUMBER,
   sscc_                          IN  VARCHAR2,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);   
   unique_column_value_           VARCHAR2(50);
   too_many_values_found_         BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN
   Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);
   
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  HANDLING_UNIT_TAB ';
   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;

   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   

   @ApproveDynamicStatement(2015-10-25,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING handling_unit_id_,
                                           sscc_,
                                           alt_handling_unit_label_id_;  
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');  
      ELSIF  (column_value_tab_.COUNT = 2) THEN
         too_many_values_found_ := TRUE;
      END IF;
   CLOSE get_column_values_;

   -- If no values was found at all then set no_unique_value_found_ out-param to TRUE else set it to FALSE. 
   -- This to be able to see the why this method returned NULL so we can know if it was because no values 
   -- was found at all or if it was because to many values was found. This can be used in process utilities which
   -- fetch unique values from several data sources for a specific data item, so that utility can check if 
   -- there was a combined unique value from the data sources or not.
   IF (unique_column_value_ IS NULL AND NOT too_many_values_found_) THEN 
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;

 
-- This method is used by DataCaptReportPickHu, DataCaptReportPickPart, DataCapPackIntoHuShip,
-- DataCaptRecSo and DataCaptRecSoHu
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_         OUT BOOLEAN,
   handling_unit_id_              IN  NUMBER,
   shipment_id_                   IN  NUMBER,
   sscc_                          IN  VARCHAR2,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   source_ref1_                   IN  VARCHAR2,
   source_ref2_                   IN  VARCHAR2,
   source_ref3_                   IN  VARCHAR2,
   source_ref_type_db_            IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);   
   unique_column_value_           VARCHAR2(50);
   too_many_values_found_         BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN
   Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
            FROM  HANDLING_UNIT_TAB ';
    
   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
   END IF;
   IF (shipment_id_ = -1) THEN
      stmt_ := stmt_|| ' AND :shipment_id_ = -1 ';
   ELSIF (shipment_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND (shipment_id IS NULL AND :shipment_id_ IS NULL)  ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;

   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
    IF (source_ref_type_db_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref_type_db_ = ''%'' ';
   ELSIF (source_ref_type_db_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref_type = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref_type IS NULL AND :source_ref_type_db_ IS NULL) ';
   END IF;
    IF (source_ref1_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref1_ = ''%'' ';
   ELSIF (source_ref1_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref1 IS NULL AND :source_ref1_ IS NULL) ';
   END IF;
    IF (source_ref2_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref2_ = ''%'' ';
   ELSIF (source_ref2_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref2 IS NULL AND :source_ref2_ IS NULL) ';
   END IF;
    IF (source_ref3_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref3_ = ''%'' ';
   ELSIF (source_ref3_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref3 IS NULL AND :source_ref3_ IS NULL) ';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2015-10-25,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING handling_unit_id_,
                                           shipment_id_,
                                           sscc_,                                           
                                           alt_handling_unit_label_id_,
                                           source_ref_type_db_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_;   
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');  
      ELSIF  (column_value_tab_.COUNT = 2) THEN
         too_many_values_found_ := TRUE;
      END IF;
   CLOSE get_column_values_;

   -- If no values was found at all then set no_unique_value_found_ out-param to TRUE else set it to FALSE. 
   -- This to be able to see the why this method returned NULL so we can know if it was because no values 
   -- was found at all or if it was because to many values was found. This can be used in process utilities which
   -- fetch unique values from several data sources for a specific data item, so that utility can check if 
   -- there was a combined unique value from the data sources or not.
   IF (unique_column_value_ IS NULL AND NOT too_many_values_found_) THEN 
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapRecHuFromTrans, DataCaptAttachPartHu, DataCaptChangeParentHu,
-- DataCaptCountHandlUnit, DataCaptCreateHndlUnit, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
-- DataCaptMoveHandlUnit, DataCaptScrapHandlUnit, DataCaptReportPickHu, DataCapAttachReceiptHu,
-- DataCaptRecSo, DataCaptRecSoByProd, DataCaptRecSoHu and DataCaptRepPickHuSo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_                 OUT BOOLEAN,
   handling_unit_id_              IN  NUMBER,   
   sscc_                          IN  VARCHAR2,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   column_value_                  IN  VARCHAR2,
   column_description_            IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL,
   raise_error_                   IN  BOOLEAN  DEFAULT TRUE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);
   
   stmt_ := ' SELECT 1
              FROM  HANDLING_UNIT_TAB ';

   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;

   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL))';
   
   @ApproveDynamicStatement(2015-10-29,KHVESE)
   OPEN exist_control_ FOR stmt_ USING handling_unit_id_,                                          
                                       sscc_,                                       
                                       alt_handling_unit_label_id_,                                          
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


-- This method is used by DataCaptReportPickHu, DataCaptReportPickPart, DataCapPackIntoHuShip,
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_                 OUT BOOLEAN,
   handling_unit_id_              IN  NUMBER,
   shipment_id_                   IN  NUMBER,
   sscc_                          IN  VARCHAR2,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   column_value_                  IN  VARCHAR2,
   column_description_            IN  VARCHAR2,
   source_ref1_                   IN  VARCHAR2,
   source_ref2_                   IN  VARCHAR2,
   source_ref3_                   IN  VARCHAR2,
   source_ref_type_db_            IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL,
   raise_error_                   IN  BOOLEAN  DEFAULT TRUE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_Table_Column('HANDLING_UNIT_TAB', column_name_);

   stmt_ := ' SELECT 1
              FROM  HANDLING_UNIT_TAB ';
   
   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' WHERE handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' WHERE :handling_unit_id_ IS NULL  ';
   END IF;
   IF (shipment_id_ = -1) THEN
      stmt_ := stmt_|| ' AND :shipment_id_ = -1 ';
   ELSIF (shipment_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND (shipment_id IS NULL AND :shipment_id_ IS NULL)  ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc = :sscc_ ';
   ELSE
      stmt_ := stmt_ || ' AND (sscc IS NULL AND :sscc_ IS NULL) ';
   END IF;
   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
    IF (source_ref_type_db_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref_type_db_ = ''%'' ';
   ELSIF (source_ref_type_db_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref_type = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref_type IS NULL AND :source_ref_type_db_ IS NULL) ';
   END IF;
    IF (source_ref1_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref1_ = ''%'' ';
   ELSIF (source_ref1_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref1 IS NULL AND :source_ref1_ IS NULL) ';
   END IF;
    IF (source_ref2_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref2_ = ''%'' ';
   ELSIF (source_ref2_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref2 IS NULL AND :source_ref2_ IS NULL) ';
   END IF;
    IF (source_ref3_ = '%') THEN 
      stmt_ := stmt_ || ' AND :source_ref3_ = ''%'' ';
   ELSIF (source_ref3_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_ ';
   ELSE
      stmt_ := stmt_ || ' AND (source_ref3 IS NULL AND :source_ref3_ IS NULL) ';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL))';
   @ApproveDynamicStatement(2015-10-29,KHVESE)
   OPEN exist_control_ FOR stmt_ USING handling_unit_id_,
                                       shipment_id_,
                                       sscc_,                                          
                                       alt_handling_unit_label_id_,
                                       source_ref_type_db_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
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


@UncheckedAccess
FUNCTION Get_Part_Stock_Onhand_Content (
   handling_unit_id_ IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab
IS
   stock_keys_and_qty_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;

   CURSOR get_stock_records IS
      SELECT ipis.contract         contract,
             ipis.part_no          part_no,
             ipis.configuration_id configuration_id,
             ipis.location_no      location_no,
             ipis.lot_batch_no     lot_batch_no,
             ipis.serial_no        serial_no,
             ipis.eng_chg_level    eng_chg_level,
             ipis.waiv_dev_rej_no  waiv_dev_rej_no,
             ipis.activity_seq     activity_seq,
             ipis.handling_unit_id handling_unit_id,
             ipis.qty_onhand       quantity,
             ipis.catch_qty_onhand catch_quantity,
             NULL                  transaction_id,
             NULL                  transport_task_id,
             NULL                  to_location_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH       hu.handling_unit_id = handling_unit_id_)
         AND qty_onhand != 0;
BEGIN
   OPEN  get_stock_records;
   FETCH get_stock_records BULK COLLECT INTO stock_keys_and_qty_tab_;
   CLOSE get_stock_records;

   RETURN(stock_keys_and_qty_tab_);
END Get_Part_Stock_Onhand_Content;

@UncheckedAccess
FUNCTION Get_Part_Stock_Transit_Content (
   handling_unit_id_ IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab
IS
   stock_keys_and_qty_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;

   CURSOR get_stock_records IS
      SELECT ipis.contract             contract,
             ipis.part_no              part_no,
             ipis.configuration_id     configuration_id,
             ipis.location_no          location_no,
             ipis.lot_batch_no         lot_batch_no,
             ipis.serial_no            serial_no,
             ipis.eng_chg_level        eng_chg_level,
             ipis.waiv_dev_rej_no      waiv_dev_rej_no,
             ipis.activity_seq         activity_seq,
             ipis.handling_unit_id     handling_unit_id,
             ipis.qty_in_transit       quantity,
             ipis.catch_qty_in_transit catch_quantity,
             NULL                      transaction_id,
             NULL                      transport_task_id,
             NULL                      to_location_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH       hu.handling_unit_id = handling_unit_id_)
         AND qty_in_transit != 0;
BEGIN
   OPEN  get_stock_records;
   FETCH get_stock_records BULK COLLECT INTO stock_keys_and_qty_tab_;
   CLOSE get_stock_records;

   RETURN(stock_keys_and_qty_tab_);
END Get_Part_Stock_Transit_Content;


@UncheckedAccess
FUNCTION Get_Part_Stock_Total_Content (
   handling_unit_id_ IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab
IS
   stock_keys_and_qty_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;

   CURSOR get_stock_records IS
      SELECT ipis.contract                                       contract,
             ipis.part_no                                        part_no,
             ipis.configuration_id                               configuration_id,
             ipis.location_no                                    location_no,
             ipis.lot_batch_no                                   lot_batch_no,
             ipis.serial_no                                      serial_no,
             ipis.eng_chg_level                                  eng_chg_level,
             ipis.waiv_dev_rej_no                                waiv_dev_rej_no,
             ipis.activity_seq                                   activity_seq,
             ipis.handling_unit_id                               handling_unit_id,
             (ipis.qty_onhand + ipis.qty_in_transit)             quantity,
             (ipis.catch_qty_onhand + ipis.catch_qty_in_transit) catch_quantity,
             NULL                                                transaction_id,
             NULL                                                transport_task_id,
             NULL                                                to_location_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                       CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                       START WITH       hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
BEGIN
   OPEN  get_stock_records;
   FETCH get_stock_records BULK COLLECT INTO stock_keys_and_qty_tab_;
   CLOSE get_stock_records;

   RETURN(stock_keys_and_qty_tab_);
END Get_Part_Stock_Total_Content;


PROCEDURE New_Counting_Result (
   state_             OUT VARCHAR2,
   handling_unit_id_  IN NUMBER,
   notes_             IN VARCHAR2,
   count_all_to_zero_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
BEGIN
   Perform_Stock_Operation___(out_parameter1_     => state_,
                              handling_unit_id_   => handling_unit_id_,
                              stock_operation_id_ => report_counting_result_,
                              string_parameter1_  => notes_,
                              string_parameter2_  => count_all_to_zero_);
END New_Counting_Result;


PROCEDURE New_Counting_Result (
   info_                  OUT VARCHAR2,
   state_                 OUT VARCHAR2,
   freeze_flag_           OUT VARCHAR2,
   handling_unit_id_list_ IN  VARCHAR2,
   notes_                 IN  VARCHAR2,
   count_all_to_zero_     IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   freeze_flag_ := Inventory_Part_Freeze_Code_API.DB_NOT_FROZEN;
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (Has_Stock_Frozen_For_Counting(handling_unit_id_tab_)) THEN
      freeze_flag_ := Inventory_Part_Freeze_Code_API.DB_FROZEN_FOR_COUNTING;
      Error_SYS.Record_General(lu_name_, 'FROZENFORCOUNTING: Stock record is frozen for counting.');
      -- Check if all selected handling units can be counted to zero.
   ELSIF (count_all_to_zero_ = Fnd_Boolean_API.DB_TRUE AND Has_Quantity_Reserved___(handling_unit_id_tab_)) THEN
      Error_SYS.Record_General(lu_name_, 'COUNTEDONHAND: Counted on hand is less than the allocation(s).');
   ELSE
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
            New_Counting_Result(state_,
                                handling_unit_id_tab_(i).handling_unit_id, 
                                notes_, 
                                count_all_to_zero_);
         END LOOP;
      END IF;
   END IF;
   info_ := Client_SYS.Get_All_Info;
END  New_Counting_Result;


@UncheckedAccess
FUNCTION Get_Node_Level (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   parent_handling_unit_id_tab_ Handling_Unit_Id_Tab;
   node_level_                  NUMBER;
BEGIN
   IF (NVL(handling_unit_id_, 0) != 0) THEN
      parent_handling_unit_id_tab_ := Get_Parent_Hand_Unit_Id_Tab___(handling_unit_id_);
      node_level_                  := parent_handling_unit_id_tab_.COUNT + 1;
   END IF;
   RETURN (node_level_);
END Get_Node_Level;


@UncheckedAccess
FUNCTION Get_Handling_Unit_Id_Tab (
   handling_unit_id_list_ IN VARCHAR2 ) RETURN Handling_Unit_Id_Tab
IS
BEGIN
   RETURN Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
END Get_Handling_Unit_Id_Tab;


@UncheckedAccess
FUNCTION Get_Node_Level_Sorted_Units (
   handling_unit_id_tab_ Handling_Unit_Id_Tab ) RETURN Handling_Unit_Id_Tab
IS
BEGIN
   RETURN Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
END Get_Node_Level_Sorted_Units;


@UncheckedAccess
FUNCTION Get_Qty_Onhand (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_qty_onhand IS
      SELECT SUM(qty_onhand) qty_onhand
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0)
       GROUP BY part_no;
         
   TYPE Qty_Onhand_Tab IS TABLE OF get_qty_onhand%ROWTYPE INDEX BY PLS_INTEGER;
   qty_onhand_tab_      Qty_Onhand_Tab;
   result_              NUMBER;
BEGIN
   OPEN get_qty_onhand;
   FETCH get_qty_onhand BULK COLLECT INTO qty_onhand_tab_;
   CLOSE get_qty_onhand;
   
   IF (qty_onhand_tab_.COUNT = 1) THEN
      result_ := qty_onhand_tab_(1).qty_onhand;
   END IF;
   
   RETURN(result_);
END Get_Qty_Onhand;

@UncheckedAccess
FUNCTION Get_Qty_In_Transit (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_qty_in_transit IS
      SELECT SUM(qty_in_transit) qty_in_transit
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0)
       GROUP BY part_no;
         
   TYPE Qty_In_Transit_Tab IS TABLE OF get_qty_in_transit%ROWTYPE INDEX BY PLS_INTEGER;
   qty_in_transit_tab_     Qty_In_Transit_Tab;
   result_                 NUMBER;
BEGIN
   OPEN get_qty_in_transit;
   FETCH get_qty_in_transit BULK COLLECT INTO qty_in_transit_tab_;
   CLOSE get_qty_in_transit;
   
   IF (qty_in_transit_tab_.COUNT = 1) THEN
      result_ := qty_in_transit_tab_(1).qty_in_transit;
   END IF;
   
   RETURN(result_);
END Get_Qty_In_Transit;

@UncheckedAccess
FUNCTION Get_Qty_Reserved (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_qty_reserved IS
      SELECT SUM(qty_reserved) qty_reserved
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0)
       GROUP BY part_no;
         
   TYPE Qty_Reserved_Tab IS TABLE OF get_qty_reserved%ROWTYPE INDEX BY PLS_INTEGER;
   qty_reserved_tab_    Qty_Reserved_Tab;
   result_              NUMBER;
BEGIN
   OPEN get_qty_reserved;
   FETCH get_qty_reserved BULK COLLECT INTO qty_reserved_tab_;
   CLOSE get_qty_reserved;
   
   IF (qty_reserved_tab_.COUNT = 1) THEN
      result_ := qty_reserved_tab_(1).qty_reserved;
   END IF;
   
   RETURN(result_);
END Get_Qty_Reserved;


@UncheckedAccess
PROCEDURE Get_Inventory_Quantity (
   qty_onhand_       OUT NUMBER,
   qty_reserved_     OUT NUMBER,
   qty_in_transit_   OUT NUMBER,
   handling_unit_id_ IN NUMBER)
IS
   CURSOR get_inventory_quantity IS
      SELECT SUM(qty_onhand) qty_onhand, SUM(qty_reserved) qty_reserved, SUM(qty_in_transit) qty_in_transit
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0)
       GROUP BY part_no;
    
   TYPE Inventory_Quantity_Tab IS TABLE OF get_inventory_quantity%ROWTYPE INDEX BY PLS_INTEGER;
   inventory_quantity_tab_    Inventory_Quantity_Tab;
BEGIN
   OPEN  get_inventory_quantity;
   FETCH get_inventory_quantity BULK COLLECT INTO inventory_quantity_tab_;
   CLOSE get_inventory_quantity;
   
   IF (inventory_quantity_tab_.COUNT = 1) THEN
      qty_onhand_     := inventory_quantity_tab_(1).qty_onhand;
      qty_reserved_   := inventory_quantity_tab_(1).qty_reserved;
      qty_in_transit_ := inventory_quantity_tab_(1).qty_in_transit;
   END IF;
END Get_Inventory_Quantity;


@UncheckedAccess
FUNCTION Get_Part_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_part_no IS
      SELECT DISTINCT part_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Part_No_Tab IS TABLE OF get_part_no%ROWTYPE INDEX BY PLS_INTEGER;
   part_no_tab_      Part_No_Tab;
   result_           VARCHAR2(25);
BEGIN
   OPEN get_part_no;
   FETCH get_part_no BULK COLLECT INTO part_no_tab_;
   CLOSE get_part_no;
   
   IF (part_no_tab_.COUNT = 1) THEN
      result_ := part_no_tab_(1).part_no;
   ELSIF (part_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Part_No;


@UncheckedAccess
FUNCTION Get_Configuration_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_configuration_id IS
      SELECT DISTINCT configuration_id
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Configuration_Id_Tab IS TABLE OF get_configuration_id%ROWTYPE INDEX BY PLS_INTEGER;
   configuration_id_tab_      Configuration_Id_Tab;
   result_                    VARCHAR2(50);
BEGIN
   OPEN get_configuration_id;
   FETCH get_configuration_id BULK COLLECT INTO configuration_id_tab_;
   CLOSE get_configuration_id;
   
   IF (configuration_id_tab_.COUNT = 1) THEN
      result_ := configuration_id_tab_(1).configuration_id;
   ELSIF (configuration_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Configuration_Id;


@UncheckedAccess
FUNCTION Get_Lot_Batch_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_lot_batch_no IS
      SELECT DISTINCT lot_batch_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Lot_Batch_No_Tab IS TABLE OF get_lot_batch_no%ROWTYPE INDEX BY PLS_INTEGER;
   lot_batch_no_tab_    Lot_Batch_No_Tab;
   result_              VARCHAR2(20);
BEGIN
   OPEN get_lot_batch_no;
   FETCH get_lot_batch_no BULK COLLECT INTO lot_batch_no_tab_;
   CLOSE get_lot_batch_no;
   
   IF (lot_batch_no_tab_.COUNT = 1) THEN
      result_ := lot_batch_no_tab_(1).lot_batch_no;
   ELSIF (lot_batch_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Lot_Batch_No;


@UncheckedAccess
FUNCTION Get_Serial_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_serial_no IS
      SELECT DISTINCT serial_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Serial_No_Tab IS TABLE OF get_serial_no%ROWTYPE INDEX BY PLS_INTEGER;
   serial_no_tab_    Serial_No_Tab;
   result_           VARCHAR2(50);
BEGIN
   OPEN get_serial_no;
   FETCH get_serial_no BULK COLLECT INTO serial_no_tab_;
   CLOSE get_serial_no;
   
   IF (serial_no_tab_.COUNT = 1) THEN
      result_ := serial_no_tab_(1).serial_no;
   ELSIF (serial_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Serial_No;


@UncheckedAccess
FUNCTION Get_Eng_Chg_Level (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_eng_chg_level IS
      SELECT DISTINCT eng_chg_level
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Eng_Chg_Level_Tab IS TABLE OF get_eng_chg_level%ROWTYPE INDEX BY PLS_INTEGER;
   eng_chg_level_tab_   Eng_Chg_Level_Tab;
   result_              VARCHAR2(6);
BEGIN
   OPEN get_eng_chg_level;
   FETCH get_eng_chg_level BULK COLLECT INTO eng_chg_level_tab_;
   CLOSE get_eng_chg_level;
   
   IF (eng_chg_level_tab_.COUNT = 1) THEN
      result_ := eng_chg_level_tab_(1).eng_chg_level;
   ELSIF (eng_chg_level_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Eng_Chg_Level;


@UncheckedAccess
FUNCTION Get_Waiv_Dev_Rej_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_waiv_dev_rej_no IS
      SELECT DISTINCT waiv_dev_rej_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
         
   TYPE Waiv_Dev_Rej_No_Tab IS TABLE OF get_waiv_dev_rej_no%ROWTYPE INDEX BY PLS_INTEGER;
   waiv_dev_rej_no_tab_    Waiv_Dev_Rej_No_Tab;
   result_                 VARCHAR2(15);
BEGIN
   OPEN get_waiv_dev_rej_no;
   FETCH get_waiv_dev_rej_no BULK COLLECT INTO waiv_dev_rej_no_tab_;
   CLOSE get_waiv_dev_rej_no;
   
   IF (waiv_dev_rej_no_tab_.COUNT = 1) THEN
      result_ := waiv_dev_rej_no_tab_(1).waiv_dev_rej_no;
   ELSIF (waiv_dev_rej_no_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Waiv_Dev_Rej_No;


@UncheckedAccess
FUNCTION Get_Activity_Seq (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_activity_seq IS
      SELECT DISTINCT activity_seq
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Activity_Seq_Tab IS TABLE OF get_activity_seq%ROWTYPE INDEX BY PLS_INTEGER;
   activity_seq_tab_  Activity_Seq_Tab;
   result_            NUMBER;
BEGIN
   OPEN get_activity_seq;
   FETCH get_activity_seq BULK COLLECT INTO activity_seq_tab_;
   CLOSE get_activity_seq;
   
   IF (activity_seq_tab_.COUNT = 1) THEN
      result_ := activity_seq_tab_(1).activity_seq;
   END IF;
   
   RETURN(result_);
END Get_Activity_Seq;


@UncheckedAccess
FUNCTION Get_Project_Id(
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_project_id IS
      SELECT DISTINCT project_id
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Project_Id_Tab IS TABLE OF get_project_id%ROWTYPE INDEX BY PLS_INTEGER;
   project_id_tab_     Project_Id_Tab ;
   result_             VARCHAR2(10);
BEGIN
   OPEN get_project_id;
   FETCH get_project_id BULK COLLECT INTO project_id_tab_;
   CLOSE get_project_id;
   
   IF (project_id_tab_.COUNT = 1) THEN
      result_ := project_id_tab_(1).project_id;
   ELSIF (project_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Project_Id;


@UncheckedAccess
FUNCTION Get_Program_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN      
      CURSOR get_program_id IS
         SELECT DISTINCT Activity_API.Get_Program_Id(ipis.activity_seq) program_id
           FROM inventory_part_in_stock_tab ipis
          WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                            FROM handling_unit_tab hu
                                         CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                           START WITH     hu.handling_unit_id = handling_unit_id_)
            AND (qty_onhand + qty_in_transit != 0);

      TYPE Program_Id_Tab IS TABLE OF get_program_id%ROWTYPE INDEX BY PLS_INTEGER;
      program_id_tab_   Program_Id_Tab;
   $END
   result_           VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN      
      OPEN get_program_id;
      FETCH get_program_id BULK COLLECT INTO program_id_tab_;
      CLOSE get_program_id;

      IF (program_id_tab_.COUNT = 1) THEN
         result_ := program_id_tab_(1).program_id;
      ELSIF (program_id_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END   
   RETURN(result_);
END Get_Program_Id;         


@UncheckedAccess 
FUNCTION Get_Activity_No (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR get_activity_no IS
         SELECT DISTINCT Activity_API.Get_Activity_No(ipis.activity_seq) activity_no
           FROM inventory_part_in_stock_tab ipis
          WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                            FROM handling_unit_tab hu
                                         CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                           START WITH     hu.handling_unit_id = handling_unit_id_)
            AND (qty_onhand + qty_in_transit != 0);

      TYPE Activity_No_Tab IS TABLE OF get_activity_no%ROWTYPE INDEX BY PLS_INTEGER;
      activity_no_tab_  Activity_No_Tab;
   $END
   result_           VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN    
      OPEN get_activity_no;
      FETCH get_activity_no BULK COLLECT INTO activity_no_tab_;
      CLOSE get_activity_no;

      IF (activity_no_tab_.COUNT = 1) THEN
         result_ := activity_no_tab_(1).activity_no;
      ELSIF (activity_no_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END
   RETURN(result_);
END Get_Activity_No;


@UncheckedAccess
FUNCTION Get_Sub_Project_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   $IF Component_Proj_SYS.INSTALLED $THEN      
      CURSOR get_sub_project_id IS
         SELECT DISTINCT Activity_API.Get_Sub_Project_Id(ipis.activity_seq) sub_project_id
           FROM inventory_part_in_stock_tab ipis
          WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                            FROM handling_unit_tab hu
                                         CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                           START WITH     hu.handling_unit_id = handling_unit_id_)
            AND (qty_onhand + qty_in_transit != 0);

      TYPE Sub_Project_Id_Tab IS TABLE OF get_sub_project_id%ROWTYPE INDEX BY PLS_INTEGER;
      sub_project_id_tab_  Sub_Project_Id_Tab;
   $END
   result_              VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN      
      OPEN get_sub_project_id;
      FETCH get_sub_project_id BULK COLLECT INTO sub_project_id_tab_;
      CLOSE get_sub_project_id;

      IF (sub_project_id_tab_.COUNT = 1) THEN
         result_ := sub_project_id_tab_(1).sub_project_id;
      ELSIF (sub_project_id_tab_.COUNT > 1) THEN
         result_ := mixed_value_;
      END IF;
   $END
   RETURN(result_);
END Get_Sub_Project_Id;


@UncheckedAccess
FUNCTION Get_Availability_Control_Id (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_availability_control_id IS
      SELECT DISTINCT availability_control_id
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Availability_Control_Id_Tab IS TABLE OF get_availability_control_id%ROWTYPE INDEX BY PLS_INTEGER;
   availability_control_id_tab_  Availability_Control_Id_Tab;
   result_                       VARCHAR2(25);
BEGIN
   OPEN get_availability_control_id;
   FETCH get_availability_control_id BULK COLLECT INTO availability_control_id_tab_;
   CLOSE get_availability_control_id;
   
   IF (availability_control_id_tab_.COUNT = 1) THEN
      result_ := availability_control_id_tab_(1).availability_control_id;
   ELSIF (availability_control_id_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Availability_Control_Id;


@UncheckedAccess
FUNCTION Get_Part_Ownership (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_part_ownership IS
      SELECT DISTINCT part_ownership
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Part_Ownership_Tab IS TABLE OF get_part_ownership%ROWTYPE INDEX BY PLS_INTEGER;
   part_ownership_tab_     Part_Ownership_Tab;
   result_                 VARCHAR2(20);
BEGIN
   OPEN get_part_ownership;
   FETCH get_part_ownership BULK COLLECT INTO part_ownership_tab_;
   CLOSE get_part_ownership;
   
   IF (part_ownership_tab_.COUNT = 1) THEN
      result_ := part_ownership_tab_(1).part_ownership;
   ELSIF (part_ownership_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Part_Ownership;


@UncheckedAccess
FUNCTION Get_Owner (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_owner IS
      SELECT DISTINCT owning_customer_no, owning_vendor_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Owner_Tab IS TABLE OF get_owner%ROWTYPE INDEX BY PLS_INTEGER;
   owner_tab_     Owner_Tab;
   result_        VARCHAR2(20);
BEGIN
   OPEN get_owner;
   FETCH get_owner BULK COLLECT INTO owner_tab_;
   CLOSE get_owner;
   
   IF (owner_tab_.COUNT = 1) THEN
      result_ := NVL(owner_tab_(1).owning_customer_no, owner_tab_(1).owning_vendor_no);
   ELSIF (owner_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Owner;


@UncheckedAccess
FUNCTION Get_Owner_Name (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_owner IS
      SELECT DISTINCT owning_customer_no, owning_vendor_no
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Owner_Tab IS TABLE OF get_owner%ROWTYPE INDEX BY PLS_INTEGER;
   owner_tab_     Owner_Tab;
   result_        VARCHAR2(200);
BEGIN
   OPEN get_owner;
   FETCH get_owner BULK COLLECT INTO owner_tab_;
   CLOSE get_owner;
   
   IF (owner_tab_.COUNT = 1) THEN
      IF (owner_tab_(1).owning_customer_no IS NOT NULL) THEN
         $IF Component_Order_SYS.INSTALLED $THEN      
            result_ := Cust_Ord_Customer_API.Get_Name(owner_tab_(1).owning_customer_no);
         $ELSIF Component_Purch_SYS.INSTALLED $THEN
            IF (owner_tab_(1).owning_vendor_no IS NOT NULL) THEN
               result_ := Supplier_API.Get_Vendor_Name(owner_tab_(1).owning_vendor_no);
            END IF;  
         $ELSE
            NULL;
         $END
      ELSIF (owner_tab_(1).owning_vendor_no IS NOT NULL) THEN
         $IF Component_Purch_SYS.INSTALLED $THEN      
            result_ := Supplier_API.Get_Vendor_Name(owner_tab_(1).owning_vendor_no);
         $ELSE
            NULL;
         $END
      END IF; 
   ELSIF (owner_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN result_;
END Get_Owner_Name;


@UncheckedAccess
FUNCTION Get_Earliest_Expiration_Date (
   handling_unit_id_ IN NUMBER ) RETURN DATE
IS
   CURSOR get_earliest_expiration_date IS
      SELECT MIN(expiration_date) expiration_date
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   result_                 DATE;
BEGIN
   OPEN get_earliest_expiration_date;
   FETCH get_earliest_expiration_date INTO result_;
   CLOSE get_earliest_expiration_date;
   
   RETURN(result_);
END Get_Earliest_Expiration_Date;


@UncheckedAccess
FUNCTION Get_Earliest_Receipt_Date (
   handling_unit_id_ IN NUMBER ) RETURN DATE
IS
   CURSOR get_earliest_receipt_date IS
      SELECT MIN(receipt_date) receipt_date
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);

   result_           DATE;
BEGIN
   OPEN get_earliest_receipt_date;
   FETCH get_earliest_receipt_date INTO result_;
   CLOSE get_earliest_receipt_date;
   
   RETURN(result_);
END Get_Earliest_Receipt_Date;


@UncheckedAccess
FUNCTION Get_Transport_Task_Id (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   keys_and_qty_tab_       Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
BEGIN
   keys_and_qty_tab_ := Get_Part_Stock_Onhand_Content(handling_unit_id_);

   RETURN Transport_Task_Line_API.Get_Transport_Task_Id(keys_and_qty_tab_);
END Get_Transport_Task_Id;


@UncheckedAccess
FUNCTION Get_Transport_Destination_Site (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   keys_and_qty_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
BEGIN
   keys_and_qty_tab_ := Get_Part_Stock_Onhand_Content(handling_unit_id_);

   RETURN Transport_Task_Line_API.Get_Unique_Destination_Site(keys_and_qty_tab_);
END Get_Transport_Destination_Site;


@UncheckedAccess
FUNCTION Get_Condition_Code (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_condition_code IS
      SELECT DISTINCT Condition_Code_Manager_API.Get_Condition_Code(part_no, serial_no, lot_batch_no) condition_code
        FROM inventory_part_in_stock_tab ipis
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0);
   
   TYPE Condition_Code_Tab IS TABLE OF get_condition_code%ROWTYPE INDEX BY PLS_INTEGER;
   condition_code_tab_     Condition_Code_Tab;
   result_                 VARCHAR2(10);
BEGIN
   OPEN get_condition_code;
   FETCH get_condition_code BULK COLLECT INTO condition_code_tab_;
   CLOSE get_condition_code;
   
   IF (condition_code_tab_.COUNT = 1) THEN
      result_ := condition_code_tab_(1).condition_code;
   ELSIF (condition_code_tab_.COUNT > 1) THEN
      result_ := mixed_value_;
   END IF;
   
   RETURN(result_);
END Get_Condition_Code;


FUNCTION Get_Node_And_Ascendants (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
   CURSOR get_all_nodes IS
      SELECT handling_unit_id
         FROM handling_unit_tab
         CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
         START WITH       handling_unit_id = handling_unit_id_;
         
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes;
   
   RETURN handling_unit_id_tab_;
END Get_Node_And_Ascendants;


@UncheckedAccess
FUNCTION Get_Full_Tree_Given_Any_Node (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
   handling_unit_id_tab_  Handling_Unit_Id_Tab;

   -- The cursor below finds all nodes in a tree given the ID of any node in the tree, at any level.
   CURSOR get_all_nodes_in_tree IS
      SELECT handling_unit_id
      FROM handling_unit_tab
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = (SELECT handling_unit_id
                                             FROM handling_unit_tab
                                             WHERE parent_handling_unit_id IS NULL
                                             CONNECT BY PRIOR parent_handling_unit_id = handling_unit_id
                                             START WITH       handling_unit_id = handling_unit_id_);
BEGIN
   OPEN  get_all_nodes_in_tree;
   FETCH get_all_nodes_in_tree BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes_in_tree;

   RETURN(handling_unit_id_tab_);
END Get_Full_Tree_Given_Any_Node;


PROCEDURE Set_Stock_Location (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2 )
IS
   rec_                   handling_unit_tab%ROWTYPE;
   handling_unit_id_tab_  Handling_Unit_Id_Tab;

BEGIN
   IF ((contract_ IS NULL) OR (location_no_ IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'STOCKLOC: Both Site ID and Location No must have a value when connecting a handling unit to a stock location.');
   END IF;

   rec_ := Get_Object_By_Keys___(handling_unit_id_);

   IF ((Validate_SYS.Is_Different(rec_.contract   , contract_   ))  OR
       (Validate_SYS.Is_Different(rec_.location_no, location_no_))) THEN
      -- We need to update all nodes in the handling unit structure to make the information consistent
      handling_unit_id_tab_ := Get_Full_Tree_Given_Any_Node(handling_unit_id_);

      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         rec_ := Lock_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);

         IF ((Validate_SYS.Is_Different(rec_.contract   , contract_   ))  OR
             (Validate_SYS.Is_Different(rec_.location_no, location_no_))) THEN
            rec_.contract    := contract_;
            rec_.location_no := location_no_;
            Modify___(rec_);
         END IF;
      END LOOP;
   END IF;
END Set_Stock_Location;


PROCEDURE Clear_Stock_Location (
   handling_unit_id_ IN NUMBER )
IS
   rec_                   handling_unit_tab%ROWTYPE;
   root_handling_unit_id_ handling_unit_tab.handling_unit_id%TYPE;
   handling_unit_id_tab_  Handling_Unit_Id_Tab;
BEGIN
   root_handling_unit_id_ := Get_Root_Handling_Unit_Id(handling_unit_id_);

   IF (NOT Has_Quantity_In_Stock___(root_handling_unit_id_)) THEN
      handling_unit_id_tab_ := Get_Node_And_Descendants(root_handling_unit_id_);
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         rec_             := Lock_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);
         rec_.location_no := NULL;
         IF (rec_.shipment_id IS NULL) THEN
            -- have to preserve the Site information if connected to a shipment.
            rec_.contract := NULL;
         END IF;
         Modify___(rec_);
      END LOOP;
   END IF;
END Clear_Stock_Location;


PROCEDURE Set_Stock_Reservation (
   handling_unit_id_ IN NUMBER )
IS
   rec_ handling_unit_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(handling_unit_id_);

   IF (rec_.has_stock_reservation = Fnd_Boolean_API.DB_FALSE) THEN

      rec_                       := Lock_By_Keys___(handling_unit_id_);
      rec_.has_stock_reservation := Fnd_Boolean_API.DB_TRUE;
      Modify___(rec_);

      IF (rec_.parent_handling_unit_id IS NOT NULL) THEN
         Set_Stock_Reservation(rec_.parent_handling_unit_id);
      END IF;
   END IF;
END Set_Stock_Reservation;


PROCEDURE Clear_Stock_Reservation (
   handling_unit_id_ IN NUMBER )
IS
   rec_ handling_unit_tab%ROWTYPE;
BEGIN
   IF (NOT Has_Quantity_Reserved___(handling_unit_id_)) THEN
      -- no quantity reserved in stock for this HU or any of its children.
      rec_                       := Lock_By_Keys___(handling_unit_id_);
      rec_.has_stock_reservation := Fnd_Boolean_API.DB_FALSE;
      Modify___(rec_);

      IF (rec_.parent_handling_unit_id IS NOT NULL) THEN
         Clear_Stock_Reservation(rec_.parent_handling_unit_id);
      END IF;
   END IF;
END Clear_Stock_Reservation;


PROCEDURE Modify_Source_Ref (
   handling_unit_id_      IN NUMBER,
   source_ref_type_db_    IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   connect_to_decendants_ IN BOOLEAN DEFAULT TRUE,
   perform_putaway_       IN BOOLEAN DEFAULT FALSE )
IS   
   objid_               VARCHAR2(20);
   objversion_          VARCHAR2(100);
   info_                VARCHAR2(2000);
   attr_                VARCHAR2(32000);
   indrec_              Indicator_rec;
   oldrec_              handling_unit_tab%ROWTYPE;
   newrec_              handling_unit_tab%ROWTYPE;
   dummy_               NUMBER;
  
   CURSOR source_ref_type_exists IS
      SELECT 1 -- Check if any children have a source_ref_type
        FROM handling_unit_tab hu
       WHERE source_ref_type IS NOT NULL
     CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
       START WITH     hu.handling_unit_id = handling_unit_id_
       UNION
      SELECT 1 -- Check if any parent have a source_ref_type
        FROM handling_unit_tab hu
       WHERE source_ref_type IS NOT NULL
     CONNECT BY   hu.handling_unit_id = PRIOR hu.parent_handling_unit_id
       START WITH hu.handling_unit_id = handling_unit_id_;
BEGIN
   oldrec_                 := Lock_By_Keys_Nowait___(handling_unit_id_);
   newrec_                 := oldrec_;
   newrec_.source_ref_type := source_ref_type_db_;
   newrec_.source_ref1     := source_ref1_;
   newrec_.source_ref2     := source_ref2_;
   newrec_.source_ref3     := source_ref3_;
   indrec_                 := Get_Indicator_Rec___(oldrec_, newrec_);

   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_                        => objid_, 
             oldrec_                       => oldrec_, 
             newrec_                       => newrec_, 
             attr_                         => attr_, 
             objversion_                   => objversion_, 
             by_keys_                      => TRUE,
             connect_source_to_decendants_ => connect_to_decendants_);
             
   IF (perform_putaway_) THEN
      -- Check if any source_ref_type exists in the structure (children and parents).
      OPEN source_ref_type_exists;
      FETCH source_ref_type_exists INTO dummy_;
      IF (source_ref_type_exists%NOTFOUND) THEN
         Inventory_Event_Manager_API.Start_Session;
         
         -- We must disconnect the current handling unit from its parent since this is the HU that we're doing putaway on.
         IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_) IS NOT NULL) THEN
            Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, NULL);
         END IF;
         
         Putaway(info_                 => info_, 
                 handling_unit_id_     => handling_unit_id_, 
                 source_ref_type_db_   => Src_Ref_Type_To_Order_Type___(oldrec_.source_ref_type),
                 source_ref1_          => oldrec_.source_ref1,
                 source_ref2_          => oldrec_.source_ref2,
                 source_ref3_          => oldrec_.source_ref3);
                 
         Inventory_Event_Manager_API.Finish_Session;
      END IF;
      CLOSE source_ref_type_exists;
   END IF;
END Modify_Source_Ref;


PROCEDURE Clear_Source_Ref (
   handling_unit_id_ IN NUMBER,
   perform_putaway_  IN BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_hu_structure IS
      SELECT handling_unit_id
        FROM handling_unit_tab
       START WITH (handling_unit_id = handling_unit_id_ AND source_ref_type IS NOT NULL)
     CONNECT BY PRIOR handling_unit_id  = parent_handling_unit_id
            AND PRIOR source_ref_type   = source_ref_type
            AND PRIOR source_ref1       = source_ref1
            AND (PRIOR source_ref2      = source_ref2 OR (PRIOR source_ref2 IS NULL AND source_ref2 IS NULL))
            AND (PRIOR source_ref3      = source_ref3 OR (PRIOR source_ref3 IS NULL AND source_ref3 IS NULL))
      -- Order by desc structure level to perform a possible putaway on the outermost handling unit.
      ORDER BY Handling_Unit_API.Get_Structure_Level(handling_unit_id) DESC;

BEGIN
   FOR rec_ IN get_hu_structure LOOP      
      Modify_Source_Ref(handling_unit_id_       => rec_.handling_unit_id, 
                        source_ref_type_db_     => NULL, 
                        source_ref1_            => NULL, 
                        source_ref2_            => NULL, 
                        source_ref3_            => NULL, 
                        connect_to_decendants_  => FALSE,
                        perform_putaway_        => perform_putaway_);
   END LOOP;
END Clear_Source_Ref;

FUNCTION Get_Compiled_Part_Stock_Info (
      handling_unit_id_         IN   NUMBER) RETURN Compiled_Part_Stock_Rec
IS 
   compiled_part_stock_rec_       Compiled_Part_Stock_Rec;   
   keys_and_qty_tab_               Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   part_in_stock_rec_              Inventory_Part_In_Stock_API.Public_Rec;
   inventory_part_rec_             Inventory_Part_API.Public_Rec;
   previous_part_no_               VARCHAR2(25);
   last_activity_date_             inventory_part_in_stock_tab.last_activity_date%TYPE;
   owner_                          inventory_part_in_stock_tab.owning_customer_no%TYPE;
   owner_name_                     VARCHAR2(100);
   condition_code_                 VARCHAR2(10);
   catch_uom_                      VARCHAR2(30);
   unified_uom_                    VARCHAR2(30);
   unified_catch_uom_              VARCHAR2(30);
   gtin_no_                        VARCHAR2(14);
   part_acquisition_value_         NUMBER;
   part_no_changed_                BOOLEAN := FALSE;
   configuration_id_changed_       BOOLEAN := FALSE;
   lot_batch_no_changed_           BOOLEAN := FALSE;
   serial_no_changed_              BOOLEAN := FALSE;
   eng_chg_level_changed_          BOOLEAN := FALSE;
   waiv_dev_rej_no_changed_        BOOLEAN := FALSE;
   activity_seq_changed_           BOOLEAN := FALSE; 
   rotable_part_pool_id_changed_   BOOLEAN := FALSE;
   last_activity_date_changed_     BOOLEAN := FALSE;
   receipt_date_changed_           BOOLEAN := FALSE;
   last_count_date_changed_        BOOLEAN := FALSE;
   expiration_date_changed_        BOOLEAN := FALSE;
   availability_ctrl_id_changed_   BOOLEAN := FALSE;
   part_ownership_changed_         BOOLEAN := FALSE;
   owner_changed_                  BOOLEAN := FALSE;
   owner_name_changed_             BOOLEAN := FALSE;
   project_id_changed_             BOOLEAN := FALSE;
   condition_code_changed_         BOOLEAN := FALSE;
   inventory_uom_changed_          BOOLEAN := FALSE;
   catch_uom_changed_              BOOLEAN := FALSE;
   unified_uom_changed_            BOOLEAN := FALSE;
   unified_catch_uom_changed_      BOOLEAN := FALSE;
   gtin_no_changed_                BOOLEAN := FALSE;
   hazard_code_changed_            BOOLEAN := FALSE;
BEGIN
   keys_and_qty_tab_ := Get_Part_Stock_Total_Content(handling_unit_id_);
   compiled_part_stock_rec_.qty_onhand              := 0;
   compiled_part_stock_rec_.catch_qty_onhand        := 0;
   compiled_part_stock_rec_.qty_in_transit          := 0;
   compiled_part_stock_rec_.catch_qty_in_transit    := 0;                
   compiled_part_stock_rec_.total_inventory_value   := 0;
   compiled_part_stock_rec_.part_acquisition_value  := 0;
   compiled_part_stock_rec_.total_acquisition_value := 0;               
   
   
   IF (keys_and_qty_tab_.COUNT > 0) THEN
      FOR i IN keys_and_qty_tab_.FIRST .. keys_and_qty_tab_.LAST LOOP
         part_in_stock_rec_    := Inventory_Part_In_Stock_API.Get(keys_and_qty_tab_(i).contract, 
                                                                  keys_and_qty_tab_(i).part_no, 
                                                                  keys_and_qty_tab_(i).configuration_id, 
                                                                  keys_and_qty_tab_(i).location_no, 
                                                                  keys_and_qty_tab_(i).lot_batch_no, 
                                                                  keys_and_qty_tab_(i).serial_no, 
                                                                  keys_and_qty_tab_(i).eng_chg_level,
                                                                  keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                                  keys_and_qty_tab_(i).activity_seq,
                                                                  keys_and_qty_tab_(i).handling_unit_id);
                                                                   
         IF NOT(part_no_changed_) THEN
            compiled_part_stock_rec_.part_no                  := keys_and_qty_tab_(i).part_no;
            
            IF (compiled_part_stock_rec_.part_no = NVL(previous_part_no_, compiled_part_stock_rec_.part_no)) THEN
               compiled_part_stock_rec_.qty_onhand            := compiled_part_stock_rec_.qty_onhand + part_in_stock_rec_.qty_onhand;
               compiled_part_stock_rec_.catch_qty_onhand      := compiled_part_stock_rec_.catch_qty_onhand + part_in_stock_rec_.catch_qty_onhand;
               compiled_part_stock_rec_.qty_in_transit        := compiled_part_stock_rec_.qty_in_transit + part_in_stock_rec_.qty_in_transit;
               compiled_part_stock_rec_.catch_qty_in_transit  := compiled_part_stock_rec_.catch_qty_in_transit + part_in_stock_rec_.catch_qty_in_transit; 
            ELSE
               part_no_changed_                                  := TRUE;
               compiled_part_stock_rec_.part_no                  := NULL;
               compiled_part_stock_rec_.hazard_code              := NULL;
               compiled_part_stock_rec_.qty_onhand               := NULL;
               compiled_part_stock_rec_.catch_qty_onhand         := NULL;
               compiled_part_stock_rec_.qty_in_transit           := NULL;
               compiled_part_stock_rec_.catch_qty_in_transit     := NULL;
            END IF;
         END IF;
 
         IF NOT(configuration_id_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.configuration_id            := keys_and_qty_tab_(i).configuration_id;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.configuration_id, keys_and_qty_tab_(i).configuration_id) THEN  
               configuration_id_changed_                         := TRUE;
               compiled_part_stock_rec_.configuration_id         := NULL;
            END IF;
         END IF;

         IF NOT(lot_batch_no_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN            
               compiled_part_stock_rec_.lot_batch_no                := keys_and_qty_tab_(i).lot_batch_no;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.lot_batch_no, keys_and_qty_tab_(i).lot_batch_no) THEN 
                lot_batch_no_changed_                            := TRUE;
                compiled_part_stock_rec_.lot_batch_no            := NULL;
            END IF;          
         END IF;   

         IF NOT(serial_no_changed_) THEN 
            IF (i = keys_and_qty_tab_.FIRST) THEN            
               compiled_part_stock_rec_.serial_no                   := keys_and_qty_tab_(i).serial_no;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.serial_no, keys_and_qty_tab_(i).serial_no) THEN
               serial_no_changed_                                := TRUE;
               compiled_part_stock_rec_.serial_no                := NULL;
            END IF;  
         END IF;
      
         IF NOT(eng_chg_level_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN                        
               compiled_part_stock_rec_.eng_chg_level               := keys_and_qty_tab_(i).eng_chg_level;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.eng_chg_level, keys_and_qty_tab_(i).eng_chg_level) THEN
               eng_chg_level_changed_                            := TRUE;
               compiled_part_stock_rec_.eng_chg_level            := NULL;
            END IF;
         END IF;

         IF NOT(waiv_dev_rej_no_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN                                    
               compiled_part_stock_rec_.waiv_dev_rej_no             := keys_and_qty_tab_(i).waiv_dev_rej_no;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.waiv_dev_rej_no, keys_and_qty_tab_(i).waiv_dev_rej_no) THEN
               waiv_dev_rej_no_changed_                          := TRUE;
               compiled_part_stock_rec_.waiv_dev_rej_no          := NULL;
            END IF;        
         END IF;   
      
         IF NOT(activity_seq_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN                                                
               compiled_part_stock_rec_.activity_seq                := keys_and_qty_tab_(i).activity_seq;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.activity_seq , keys_and_qty_tab_(i).activity_seq) THEN
               activity_seq_changed_                             := TRUE;
               compiled_part_stock_rec_.activity_seq             := NULL;
            END IF;        
         END IF;   

         IF NOT(rotable_part_pool_id_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN                                                            
               compiled_part_stock_rec_.rotable_part_pool_id      := part_in_stock_rec_.rotable_part_pool_id;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.rotable_part_pool_id, part_in_stock_rec_.rotable_part_pool_id) THEN
               rotable_part_pool_id_changed_                      := TRUE;
               compiled_part_stock_rec_.rotable_part_pool_id      := NULL;
            END IF;        
         END IF;   
      
         IF NOT(last_activity_date_changed_) THEN
            last_activity_date_                                   :=  Inventory_Part_In_Stock_API.Get_Last_Activity_Date(keys_and_qty_tab_(i).contract, 
                                                                                          keys_and_qty_tab_(i).part_no, 
                                                                                          keys_and_qty_tab_(i).configuration_id, 
                                                                                          keys_and_qty_tab_(i).location_no, 
                                                                                          keys_and_qty_tab_(i).lot_batch_no, 
                                                                                          keys_and_qty_tab_(i).serial_no, 
                                                                                          keys_and_qty_tab_(i).eng_chg_level,
                                                                                          keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                                                          keys_and_qty_tab_(i).activity_seq,
                                                                                          keys_and_qty_tab_(i).handling_unit_id);          
            IF (i = keys_and_qty_tab_.FIRST) THEN 
               compiled_part_stock_rec_.last_activity_date        := last_activity_date_;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.last_activity_date, last_activity_date_) THEN
               last_activity_date_changed_                       := TRUE;
               compiled_part_stock_rec_.last_activity_date       := NULL;
            END IF;        
         END IF;

         IF NOT(receipt_date_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.receipt_date             := part_in_stock_rec_.receipt_date;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.receipt_date, part_in_stock_rec_.receipt_date) THEN
               receipt_date_changed_                             := TRUE;
               compiled_part_stock_rec_.receipt_date             := NULL;
            END IF;        
         END IF;
      
         IF NOT(last_count_date_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.last_count_date          := part_in_stock_rec_.last_count_date;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.last_count_date, part_in_stock_rec_.last_count_date) THEN
               last_count_date_changed_                          := TRUE;
               compiled_part_stock_rec_.last_count_date          := NULL;
            END IF;        
         END IF;

         IF NOT(expiration_date_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.expiration_date             := part_in_stock_rec_.expiration_date;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.expiration_date, part_in_stock_rec_.expiration_date) THEN
               expiration_date_changed_                          := TRUE;
               compiled_part_stock_rec_.expiration_date          := NULL;
            END IF;        
         END IF;
      
         IF NOT(availability_ctrl_id_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.availability_control_id  := part_in_stock_rec_.availability_control_id;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.availability_control_id, part_in_stock_rec_.availability_control_id) THEN
               availability_ctrl_id_changed_                     := TRUE;
               compiled_part_stock_rec_.availability_control_id  := NULL;
            END IF;        
         END IF;   

         IF NOT(part_ownership_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.part_ownership           := part_in_stock_rec_.part_ownership;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.part_ownership, part_in_stock_rec_.part_ownership) THEN
               part_ownership_changed_                           := TRUE;
               compiled_part_stock_rec_.part_ownership           := mixed_value_;
            END IF;                 
         END IF;
      
         IF NOT(owner_changed_) THEN
            owner_                                               := Inventory_Part_In_Stock_API.Get_Owner(keys_and_qty_tab_(i).contract, 
                                                                                                      keys_and_qty_tab_(i).part_no, 
                                                                                                      keys_and_qty_tab_(i).configuration_id, 
                                                                                                      keys_and_qty_tab_(i).location_no, 
                                                                                                      keys_and_qty_tab_(i).lot_batch_no, 
                                                                                                      keys_and_qty_tab_(i).serial_no,
                                                                                                      keys_and_qty_tab_(i).eng_chg_level, 
                                                                                                      keys_and_qty_tab_(i).waiv_dev_rej_no, 
                                                                                                      keys_and_qty_tab_(i).activity_seq, 
                                                                                                      keys_and_qty_tab_(i).handling_unit_id); 
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.owner                     :=  owner_;                  
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.owner, owner_) THEN
               owner_changed_                                   := TRUE;
               compiled_part_stock_rec_.owner                   := mixed_value_;
            END IF;                          
         END IF;

         IF NOT(owner_name_changed_) THEN
            owner_name_                                         := Inventory_Part_In_Stock_API.Get_Owner_Name(keys_and_qty_tab_(i).contract, 
                                                                                                      keys_and_qty_tab_(i).part_no, 
                                                                                                      keys_and_qty_tab_(i).configuration_id, 
                                                                                                      keys_and_qty_tab_(i).location_no, 
                                                                                                      keys_and_qty_tab_(i).lot_batch_no, 
                                                                                                      keys_and_qty_tab_(i).serial_no, 
                                                                                                      keys_and_qty_tab_(i).eng_chg_level,
                                                                                                      keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                                                                      keys_and_qty_tab_(i).activity_seq,
                                                                                                      keys_and_qty_tab_(i).handling_unit_id);
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.owner_name               :=  owner_name_;             
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.owner_name, owner_name_) THEN
               owner_name_changed_                                   := TRUE;
               compiled_part_stock_rec_.owner_name                   := mixed_value_;
            END IF;                                                                                                                                                                                                          
         END IF;

         IF NOT(project_id_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.project_id                   := part_in_stock_rec_.project_id; 
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.project_id, part_in_stock_rec_.project_id) THEN
               project_id_changed_                                   := TRUE;
               compiled_part_stock_rec_.project_id                   := NULL;
            END IF;                                                                                                                                                                                                          
         END IF;

         IF NOT(condition_code_changed_) THEN
            condition_code_                                          := Condition_Code_Manager_API.Get_Condition_Code(keys_and_qty_tab_(i).part_no,
                                                                                                                      keys_and_qty_tab_(i).serial_no,
                                                                                                                      keys_and_qty_tab_(i).lot_batch_no);
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.condition_code               := condition_code_;              
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.condition_code, condition_code_) THEN
               condition_code_changed_                               := TRUE;
               compiled_part_stock_rec_.condition_code               := mixed_value_;
            END IF;                                                                                                                                                                                                          
         END IF; 

         compiled_part_stock_rec_.total_inventory_value := compiled_part_stock_rec_.total_inventory_value +
                                                           part_in_stock_rec_.qty_onhand * (Inventory_Part_In_Stock_API.Get_Company_Owned_Unit_Cost (keys_and_qty_tab_(i).contract,
                                                                                                                                 keys_and_qty_tab_(i).part_no,
                                                                                                                                 keys_and_qty_tab_(i).configuration_id,
                                                                                                                                 keys_and_qty_tab_(i).location_no,
                                                                                                                                 keys_and_qty_tab_(i).lot_batch_no,
                                                                                                                                 keys_and_qty_tab_(i).serial_no,
                                                                                                                                 keys_and_qty_tab_(i).eng_chg_level,
                                                                                                                                 keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                                                                                                 keys_and_qty_tab_(i).activity_seq, 
                                                                                                                                 keys_and_qty_tab_(i).handling_unit_id));

         $IF Component_Order_SYS.INSTALLED $THEN
            part_acquisition_value_                                  := Cust_Part_Acq_Value_API.Get_Acquisition_Value(part_in_stock_rec_.owning_customer_no,
                                                                                                                      keys_and_qty_tab_(i).part_no, 
                                                                                                                      keys_and_qty_tab_(i).serial_no,
                                                                                                                      keys_and_qty_tab_(i).lot_batch_no);
            compiled_part_stock_rec_.part_acquisition_value          := compiled_part_stock_rec_.part_acquisition_value + part_acquisition_value_;
            compiled_part_stock_rec_.total_acquisition_value         := compiled_part_stock_rec_.total_acquisition_value + part_in_stock_rec_.qty_onhand * part_acquisition_value_;
         $END

         
         IF (keys_and_qty_tab_(i).part_no !=  NVL(previous_part_no_, string_null_)) THEN
            previous_part_no_                                        := keys_and_qty_tab_(i).part_no;
            inventory_part_rec_                                      := Inventory_Part_API.Get(keys_and_qty_tab_(i).contract,
                                                                                                keys_and_qty_tab_(i).part_no); 
            IF NOT(catch_uom_changed_) THEN
               catch_uom_                                            := Inventory_Part_API.Get_Enabled_Catch_Unit_Meas(keys_and_qty_tab_(i).contract,keys_and_qty_tab_(i).part_no);            
            END IF;

            IF NOT(unified_uom_changed_) THEN
               unified_uom_                                          := Inventory_Part_API.Get_User_Default_Unit_Meas(keys_and_qty_tab_(i).part_no);
            END IF;

            IF NOT(unified_catch_uom_changed_) THEN
               unified_catch_uom_                                    := Inventory_Part_API.Get_User_Default_Unit_Meas(keys_and_qty_tab_(i).part_no,'CATCH');             
            END IF;

            IF NOT(gtin_no_changed_) THEN
               gtin_no_                                              := Part_Gtin_API.Get_Default_Gtin_No(keys_and_qty_tab_(i).part_no);   
            END IF;       
         END IF;
                                                         
         IF NOT(inventory_uom_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.inventory_uom                   := inventory_part_rec_.unit_meas;  
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.inventory_uom,inventory_part_rec_.unit_meas) THEN
               inventory_uom_changed_                                := TRUE;
               compiled_part_stock_rec_.inventory_uom                := NULL;
            END IF;  
         END IF;

         IF NOT(catch_uom_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.catch_uom                    := catch_uom_;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.catch_uom, catch_uom_) THEN
               catch_uom_changed_                                    := TRUE;
               compiled_part_stock_rec_.catch_uom                    := NULL;
            END IF;           
         END IF;

         IF NOT(unified_uom_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.unified_uom                  := unified_uom_;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.unified_uom, unified_uom_) THEN
               unified_uom_changed_                                  := TRUE;
               compiled_part_stock_rec_.unified_uom                  := NULL;
            END IF;           
         END IF;

         IF NOT(unified_catch_uom_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.unified_catch_uom           := unified_catch_uom_;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.unified_catch_uom, unified_catch_uom_) THEN
               unified_catch_uom_changed_                           := TRUE;
               compiled_part_stock_rec_.unified_catch_uom           := NULL;
            END IF;           
         END IF;

         IF NOT(gtin_no_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.gtin_no                     := gtin_no_;
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.gtin_no, gtin_no_) THEN
               gtin_no_changed_                                     := TRUE;
               compiled_part_stock_rec_.gtin_no                     := NULL;
            END IF;           
         END IF;

         IF NOT(hazard_code_changed_) THEN
            IF (i = keys_and_qty_tab_.FIRST) THEN
               compiled_part_stock_rec_.hazard_code                 := inventory_part_rec_.hazard_code;  
            ELSIF Validate_SYS.Is_Different(compiled_part_stock_rec_.hazard_code, inventory_part_rec_.hazard_code) THEN
               hazard_code_changed_                                 := TRUE;
               compiled_part_stock_rec_.hazard_code                 := NULL;
            END IF;  
         END IF;
         
      END LOOP;
      
      IF (compiled_part_stock_rec_.part_no IS NOT NULL) THEN
         compiled_part_stock_rec_.unified_qty_onhand                := Inventory_Part_API.Get_User_Default_Converted_Qty(keys_and_qty_tab_(1).contract, compiled_part_stock_rec_.part_no, compiled_part_stock_rec_.qty_onhand,'REMOVE');
         compiled_part_stock_rec_.unified_catch_qty_onhand          := Inventory_Part_API.Get_User_Default_Converted_Qty(keys_and_qty_tab_(1).contract, compiled_part_stock_rec_.part_no, compiled_part_stock_rec_.catch_qty_onhand,'REMOVE','CATCH');
         compiled_part_stock_rec_.unified_qty_in_transit            := Inventory_Part_API.Get_User_Default_Converted_Qty(keys_and_qty_tab_(1).contract,compiled_part_stock_rec_.part_no,compiled_part_stock_rec_.qty_in_transit,'REMOVE');
         compiled_part_stock_rec_.unified_catch_qty_in_transit      := Inventory_Part_API.Get_User_Default_Converted_Qty(keys_and_qty_tab_(1).contract, compiled_part_stock_rec_.part_no, compiled_part_stock_rec_.catch_qty_in_transit,'REMOVE','CATCH');
      END IF;      
   END IF;
   
   RETURN compiled_part_stock_rec_;
   
END Get_Compiled_Part_Stock_Info;


PROCEDURE Modify_Source_Ref_Part_Qty (
   handling_unit_id_    IN NUMBER,
   source_ref_part_qty_ IN NUMBER )
IS
   newrec_ handling_unit_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(handling_unit_id_);
   newrec_.source_ref_part_qty := source_ref_part_qty_;
   Modify___(newrec_);
END Modify_Source_Ref_Part_Qty;


@UncheckedAccess
FUNCTION Get_Part_Qty_Onhand (
   handling_unit_id_ IN NUMBER,
   part_no_          IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_part_qty_onhand IS
      SELECT SUM(qty_onhand)
        FROM inventory_part_in_stock_tab ipis 
       WHERE ipis.handling_unit_id IN (SELECT hu.handling_unit_id
                                         FROM handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                        START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_onhand + qty_in_transit != 0)
         AND part_no = part_no_;
   result_     NUMBER;
BEGIN
   OPEN get_part_qty_onhand;
   FETCH get_part_qty_onhand INTO result_;
   CLOSE get_part_qty_onhand;
   
   RETURN NVL(result_, 0);
END Get_Part_Qty_Onhand;


-- Get_Node_And_Descendants
--   This method returns the handling_unit_id that is passed in plus all 
--   its decendants (all children) at all the levels below in the structure.
@UncheckedAccess
FUNCTION Get_Node_And_Descendants (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
   CURSOR get_all_nodes IS  
      SELECT handling_unit_id
      FROM handling_unit_tab
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = handling_unit_id_;
   
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN   
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes;
   RETURN handling_unit_id_tab_;
END Get_Node_And_Descendants;


@UncheckedAccess
FUNCTION Get_Total_Source_Ref_Part_Qty (
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   handling_unit_id_tab_      Handling_Unit_Id_Tab;
   total_source_ref_part_qty_ NUMBER := 0;
BEGIN   
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST .. handling_unit_id_tab_.LAST LOOP
         total_source_ref_part_qty_ := total_source_ref_part_qty_ + 
                                       NVL(Handling_Unit_API.Get_Source_Ref_Part_Qty(handling_unit_id_tab_(i).handling_unit_id), 0);
      END LOOP;
   END IF;
   
   RETURN total_source_ref_part_qty_;
END Get_Total_Source_Ref_Part_Qty;


@UncheckedAccess
FUNCTION Get_Node_And_Desc_By_Sourc_Ref (
   handling_unit_id_    IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2 ) RETURN Handling_Unit_Id_Tab
IS
   CURSOR get_all_nodes IS  
      SELECT handling_unit_id
      FROM  handling_unit_tab
      WHERE source_ref_type   = source_ref_type_db_
      AND   source_ref1       = source_ref1_
      AND   ((source_ref2 = source_ref2_) OR (source_ref2 IS NULL AND source_ref2_ IS NULL))
      AND   ((source_ref3 = source_ref3_) OR (source_ref3 IS NULL AND source_ref3_ IS NULL))
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = handling_unit_id_;
   
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN   
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes;
   RETURN handling_unit_id_tab_;
END Get_Node_And_Desc_By_Sourc_Ref;


PROCEDURE Putaway (
   info_               OUT VARCHAR2,
   handling_unit_id_   IN  NUMBER,
   source_ref_type_db_ IN  VARCHAR2 DEFAULT NULL,
   source_ref1_        IN  VARCHAR2 DEFAULT NULL,
   source_ref2_        IN  VARCHAR2 DEFAULT NULL,
   source_ref3_        IN  VARCHAR2 DEFAULT NULL,
   source_ref4_        IN  VARCHAR2 DEFAULT NULL,
   calling_process_    IN  VARCHAR2 DEFAULT 'PUTAWAY')
IS
BEGIN
   Inventory_Putaway_Manager_API.Putaway_Handling_Unit(info_               => info_, 
                                                       handling_unit_id_   => handling_unit_id_, 
                                                       source_ref_type_db_ => source_ref_type_db_,
                                                       source_ref1_        => source_ref1_,
                                                       source_ref2_        => source_ref2_,
                                                       source_ref3_        => source_ref3_,
                                                       source_ref4_        => source_ref4_,
                                                       calling_process_    => calling_process_);
END Putaway;


PROCEDURE Putaway (
   info_                  OUT VARCHAR2,
   handling_unit_id_list_ IN  VARCHAR2 )
IS
   handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);

   Putaway(info_, handling_unit_id_tab_);
END Putaway;


PROCEDURE Putaway (
   info_                 OUT VARCHAR2,
   handling_unit_id_tab_ IN  Handling_Unit_Id_Tab )
IS
   local_handling_unit_id_tab_ Handling_Unit_Id_Tab;
BEGIN
   local_handling_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);

   IF (handling_unit_id_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      
      Inventory_Putaway_Manager_API.Putaway_Handling_Units(info_, local_handling_unit_id_tab_);
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Putaway;


PROCEDURE Lock_By_Keys (
   handling_unit_id_ IN NUMBER )
IS
   dummy_ handling_unit_tab%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Keys___(handling_unit_id_);
END Lock_By_Keys;


PROCEDURE Lock_Node_And_Descendants (
   handling_unit_id_ IN NUMBER )
IS
   CURSOR get_all_nodes IS  
      SELECT handling_unit_id
      FROM handling_unit_tab
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = handling_unit_id_
      FOR UPDATE;
   
   dummy_ Handling_Unit_Id_Tab;
BEGIN   
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO dummy_;
   CLOSE get_all_nodes;
END Lock_Node_And_Descendants;


PROCEDURE Raise_Not_In_Stock_Error (
   handling_unit_id_ IN NUMBER )
IS
BEGIN
   Error_Sys.Record_General(lu_name_, 'NOSTOCKQTY: Handling Unit :P1 is not in stock.', handling_unit_id_);
END Raise_Not_In_Stock_Error;


PROCEDURE Create_History_Snapshot (
   root_handling_unit_id_tab_   IN Handling_Unit_Id_Tab )
IS
BEGIN
   Handling_Unit_History_API.Create_Snapshot(root_handling_unit_id_tab_);            
END Create_History_Snapshot;


PROCEDURE Create_Shipment_Hist_Snapshot (
   shipment_id_                IN NUMBER,
   remove_shipment_connection_ IN BOOLEAN DEFAULT TRUE )
IS
   CURSOR get_root_handling_unit_id IS
      SELECT handling_unit_id
      FROM handling_unit_tab
      WHERE shipment_id = shipment_id_
      AND   parent_handling_unit_id IS NULL;
      
   root_handling_unit_id_tab_  Handling_Unit_Id_Tab;
BEGIN 
   OPEN get_root_handling_unit_id;
   FETCH get_root_handling_unit_id BULK COLLECT INTO root_handling_unit_id_tab_;
   CLOSE get_root_handling_unit_id;
   
   IF (root_handling_unit_id_tab_.COUNT > 0) THEN

      Handling_Unit_History_API.Create_Snapshot(root_handling_unit_id_tab_);

      IF (remove_shipment_connection_) THEN
         FOR i IN root_handling_unit_id_tab_.FIRST..root_handling_unit_id_tab_.LAST LOOP
            Modify_Shipment_Id(handling_unit_id_ => root_handling_unit_id_tab_(i).handling_unit_id, shipment_id_ => NULL);
         END LOOP;
      END IF;
   END IF;

END Create_Shipment_Hist_Snapshot;

@UncheckedAccess
FUNCTION Has_Source_Ref_Connected_Child (
   handling_unit_id_    IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_sourc_ref_connect_child_  VARCHAR2(20) := Fnd_Boolean_API.DB_FALSE;
   dummy_                        NUMBER;
   
   CURSOR check_children_exist IS
      SELECT 1 
      FROM  handling_unit_tab 
      WHERE parent_handling_unit_id = handling_unit_id_
      AND   source_ref_type         = source_ref_type_db_
      AND   source_ref1             = source_ref1_
      AND   ((source_ref2 = source_ref2_) OR (source_ref2 IS NULL AND source_ref2_ IS NULL))
      AND   ((source_ref3 = source_ref3_) OR (source_ref3 IS NULL AND source_ref3_ IS NULL));
BEGIN
   OPEN check_children_exist;
   FETCH check_children_exist INTO dummy_;
   IF (check_children_exist%FOUND) THEN
      has_sourc_ref_connect_child_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_children_exist;
   RETURN has_sourc_ref_connect_child_;
END Has_Source_Ref_Connected_Child;


@UncheckedAccess
FUNCTION Get_Outermost_Units_Only (
   handling_unit_id_tab_ Handling_Unit_Id_Tab ) RETURN Handling_Unit_Id_Tab
IS
   outermost_handl_unit_id_tab_  Handling_Unit_Id_Tab;
BEGIN
   outermost_handl_unit_id_tab_ := Get_Outermost_Units_Only___(handling_unit_id_tab_);
   RETURN (outermost_handl_unit_id_tab_);
END Get_Outermost_Units_Only;


PROCEDURE Convert_Manual_Weight_And_Volu (
   handling_unit_id_ IN NUMBER,
   from_contract_    IN VARCHAR2,
   to_contract_      IN VARCHAR2 )
IS
   from_company_rec_         Company_Invent_Info_API.Public_Rec;
   to_company_rec_           Company_Invent_Info_API.Public_Rec;
   weight_conversion_needed_ BOOLEAN;
   volume_conversion_needed_ BOOLEAN;
BEGIN
   Get_Weight_Vol_Convert_Info___(weight_conversion_needed_,
                                  volume_conversion_needed_,
                                  from_company_rec_,
                                  to_company_rec_,
                                  stock_operation_id_ => change_stock_location_,
                                  from_contract_      => from_contract_,
                                  to_contract_        => to_contract_);

   IF (weight_conversion_needed_ OR volume_conversion_needed_) THEN
      Convert_Weight_And_Volume___(handling_unit_id_,
                                   from_company_rec_,
                                   to_company_rec_);
   END IF;
END Convert_Manual_Weight_And_Volu;


@UncheckedAccess
FUNCTION Get_Max_Capacity_Exceeded_Info (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   info_ VARCHAR2(2000);
BEGIN
   Validate_Max_Capacity___(info_ => info_, handling_unit_id_ => handling_unit_id_, throw_exception_ => FALSE);
   RETURN (info_);
END Get_Max_Capacity_Exceeded_Info;


PROCEDURE Clear_Manual_Weight_And_Volume (
   handling_unit_id_      IN NUMBER,
   also_remove_on_parent_ IN BOOLEAN DEFAULT TRUE,
   remove_manual_weight_  IN BOOLEAN DEFAULT TRUE,
   remove_manual_volume_  IN BOOLEAN DEFAULT TRUE )
IS
   handling_unit_id_tab_            Handling_Unit_Id_Tab;
   weight_cleared_                  BOOLEAN;
   volume_cleared_                  BOOLEAN;
   local_remove_manual_volume_      BOOLEAN;
   rec_                             handling_unit_tab%ROWTYPE;
   shipment_id_                     handling_unit_tab.shipment_id%TYPE;
   shipment_type_                   VARCHAR2(3);
   keep_manual_weight_and_volume_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   exit_procedure_                  EXCEPTION;
BEGIN
   
   shipment_id_      := Get_Shipment_Id(handling_unit_id_);
   IF (shipment_id_ IS NOT NULL) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         shipment_type_                 := Shipment_API.Get_Shipment_Type(shipment_id_);
         IF shipment_type_ IS NOT NULL THEN
            keep_manual_weight_and_volume_ := Shipment_Type_API.Get_Keep_Manual_Weight_Vol_Db(shipment_type_);
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('SHPMNT');
      $END
   END IF;
   
   IF keep_manual_weight_and_volume_ = Fnd_Boolean_API.DB_TRUE THEN
      -- This method is called in order to trigger resetting of the shipment printed flags and to recalculate 
      -- the shipment freight charges. This needs to done as there isn't a manual weight or volume change on 
      -- the shipment handling unit structure when keep_manual_weight_and_volume is TRUE.
      Handle_Shipment_On_Update___(shipment_id_                      => shipment_id_, 
                                   sscc_is_changed_                  => FALSE,
                                   alt_hu_unit_label_id_is_changed_  => FALSE, 
                                   manual_gross_weight_is_changed_   => remove_manual_weight_,
                                   manual_volume_is_changed_         => remove_manual_volume_,
                                   shipment_is_changed_              => FALSE,
                                   parent_is_changed_                => FALSE);
      RAISE exit_procedure_;
   END IF;
   
   local_remove_manual_volume_ := remove_manual_volume_;
   IF (also_remove_on_parent_) THEN
      handling_unit_id_tab_ := Get_Node_And_Ascendants(handling_unit_id_);
   ELSE
      handling_unit_id_tab_(1).handling_unit_id := handling_unit_id_;
   END IF;

   FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
      weight_cleared_ := FALSE;
      volume_cleared_ := FALSE;
      rec_    := Lock_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);
      IF (remove_manual_weight_ AND rec_.manual_gross_weight IS NOT NULL) THEN
         rec_.manual_gross_weight := NULL;
         weight_cleared_          := TRUE;
      END IF;
      IF (local_remove_manual_volume_) THEN
         IF (Volume_Is_Additive___(handling_unit_id_tab_(i).handling_unit_id)) THEN
            IF (rec_.manual_volume IS NOT NULL) THEN
               rec_.manual_volume := NULL;
               volume_cleared_    := TRUE;
            END IF;
         ELSE
            local_remove_manual_volume_ := FALSE;
         END IF;
      END IF;
      IF (weight_cleared_ OR volume_cleared_) THEN
         Modify___(rec_);
      END IF;
      IF (volume_cleared_ AND (rec_.parent_handling_unit_id IS NULL) AND (rec_.shipment_id IS NOT NULL)) THEN
         Remove_Manual_Ship_Volume___ (rec_.shipment_id);
         Calculate_Shipment_Charges___(rec_.shipment_id);
      END IF;
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Clear_Manual_Weight_And_Volume;

FUNCTION Is_Hu_Type_And_Category_Match (
   handling_unit_id_          IN NUMBER, 
   handling_unit_type_id_     IN VARCHAR2, 
   handling_category_type_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   type_category_matched_    BOOLEAN := FALSE;
   dummy_                    NUMBER;  
   
   CURSOR check_top_handling_unit IS
      SELECT 1
      FROM handling_unit_tab hu, handling_unit_type_tab hut
      WHERE hu.handling_unit_id = handling_unit_id_
      AND   hu.handling_unit_type_id = hut.handling_unit_type_id
      AND  (hut.handling_unit_type_id = handling_unit_type_id_ OR handling_unit_type_id_ IS NULL)
      AND  (hut.handling_unit_category_id = handling_category_type_id_ OR handling_category_type_id_ IS NULL);
   
BEGIN
   OPEN check_top_handling_unit;
   FETCH check_top_handling_unit INTO dummy_;
   IF (check_top_handling_unit%FOUND) THEN
      CLOSE check_top_handling_unit;
      type_category_matched_ := TRUE;
   ELSE
      CLOSE check_top_handling_unit;
      type_category_matched_ := FALSE;
   END IF; 
   RETURN type_category_matched_;
   
END Is_Hu_Type_And_Category_Match;

PROCEDURE Get_Id_Version_By_Keys (
   objid_            IN OUT VARCHAR2,
   objversion_       IN OUT VARCHAR2,
   handling_unit_id_ IN     NUMBER )
IS
BEGIN
   Get_Id_Version_By_Keys___ (objid_,
                              objversion_,
                              handling_unit_id_ );
END Get_Id_Version_By_Keys;

@UncheckedAccess
FUNCTION Has_Stock_On_Transport_Task (   
   handling_unit_id_      IN NUMBER ) RETURN BOOLEAN 
IS
   handling_unit_id_tab_   Handling_Unit_Id_Tab;
   exists_                 NUMBER := 0;  
         
   CURSOR check_exist IS 
      SELECT 1
      FROM  transport_task_line_tab ttl
      WHERE ttl.handling_unit_id IN (SELECT handling_unit_id FROM TABLE (handling_unit_id_tab_)) 
      AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);                                 
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   OPEN check_exist;
   FETCH check_exist INTO exists_;   
   CLOSE check_exist;
   
   RETURN (exists_ = 1);
END Has_Stock_On_Transport_Task;


@UncheckedAccess
FUNCTION Has_Immovable_Stock_Reserv (
   handling_unit_id_            IN NUMBER,
   move_reservation_option_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   handling_unit_id_tab_           Handling_Unit_Id_Tab;
   exists_                         NUMBER := 0; 
   move_not_pick_listed_           VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   move_not_on_printed_pick_list_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   db_true_                        VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   
   CURSOR check_exist IS
      SELECT 1
      FROM  INV_PART_STOCK_RESERVATION ipsr
      WHERE ipsr.handling_unit_id IN (SELECT handling_unit_id FROM TABLE (handling_unit_id_tab_))                  
      AND ((CASE WHEN (NVL(ipsr.pick_list_no, '*') != '*')  AND (move_not_pick_listed_ = db_true_)  THEN 1
               WHEN (NVL(ipsr.pick_list_no, '*') != '*') AND (ipsr.pick_list_printed_db = db_true_) AND (move_not_on_printed_pick_list_ = db_true_) THEN 1
               ELSE 0
          END = 1) OR (order_supply_demand_type_db NOT IN ( Inv_Part_Stock_Reservation_API.move_reserve_src_type_1_,
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_2_,
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_3_, 
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_4_,
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_5_, 
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_6_,
                                                            Inv_Part_Stock_Reservation_API.move_reserve_src_type_7_))) 
      AND NVL(ipsr.qty_picked, 0) = 0; 
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);
   CASE move_reservation_option_db_
      WHEN Reservat_Adjustment_Option_API.DB_NOT_ALLOWED THEN
         NULL;
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED THEN
         move_not_pick_listed_ := db_true_;
      WHEN Reservat_Adjustment_Option_API.DB_NOT_PRINTED_PICKLIST THEN
         move_not_on_printed_pick_list_ := db_true_;
      WHEN Reservat_Adjustment_Option_API.DB_ALLOWED THEN
         NULL;
   END CASE;
   
   OPEN check_exist;
   FETCH check_exist INTO exists_;         
   CLOSE check_exist;
   RETURN (exists_ = 1);
   
END Has_Immovable_Stock_Reserv;


PROCEDURE Check_Max_Capacity_Exceeded (
   handling_unit_id_ IN NUMBER )
IS
   dummy_ VARCHAR2(2000);
BEGIN
   Validate_Max_Capacity___(info_ => dummy_, handling_unit_id_ => handling_unit_id_, throw_exception_ => TRUE);
END Check_Max_Capacity_Exceeded;

@UncheckedAccess
FUNCTION Get_Children (
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_Id_Tab
IS
BEGIN
   RETURN (Get_Children___(handling_unit_id_));
END Get_Children;

  
FUNCTION Get_Handling_Unit_Details (
   handling_unit_id_  IN NUMBER ) RETURN handling_unit_details_arr PIPELINED
IS
   rec_     handling_unit_details_rec;
   hu_rec_  Handling_Unit_API.Public_Rec;
   
BEGIN
   hu_rec_ := Handling_Unit_API.Get(handling_unit_id_);
   rec_.hu_type_id                 := hu_rec_.handling_unit_type_id;
   rec_.hu_type_desc               := Handling_Unit_Type_API.Get_Description(rec_.hu_type_id);
   rec_.sscc                       := hu_rec_.sscc;
   rec_.alt_hu_label_id            := hu_rec_.alt_handling_unit_label_id;
   rec_.top_parent_hu_id           := Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_);
   rec_.top_parent_hu_type_id      := Handling_Unit_API.Get_Top_Parent_Hu_Type_Id(handling_unit_id_);
   rec_.top_parent_hu_type_desc    := Handling_Unit_Type_API.Get_Description(rec_.top_parent_hu_type_id);
   rec_.top_parent_sscc            := Handling_Unit_API.Get_Top_Parent_Sscc(handling_unit_id_);
   rec_.top_parent_alt_hu_label_id := Handling_Unit_API.Get_Top_Parent_Alt_Hu_Label_Id(handling_unit_id_);
   rec_.level2_hu_id               := Handling_Unit_API.Get_Second_Level_Parent_Hu_Id(handling_unit_id_);
   rec_.level2_sscc                := Handling_Unit_API.Get_Sscc(rec_.level2_hu_id);
   rec_.level2_alt_hu_label_id     := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(rec_.level2_hu_id);
   
   PIPE ROW (rec_);
END Get_Handling_Unit_Details;


PROCEDURE Move_With_Shipment_Order (
   shipment_order_id_      OUT NUMBER,
   handling_unit_id_list_  IN  VARCHAR2, 
   receiver_type_db_       IN  VARCHAR2, 
   receiver_id_            IN  VARCHAR2,
   requisitioner_code_     IN  VARCHAR2)
IS
   handling_unit_id_tab_         Handling_Unit_Id_Tab;
   handling_unit_rec_            handling_unit_tab%ROWTYPE;
   warehouse_id_                 VARCHAR2(15);
   warehouse_is_remote_          BOOLEAN;
   previous_contract_            VARCHAR2(5); 
   previous_location_no_         VARCHAR2(35); 
   previous_warehouse_id_        VARCHAR2(15); 
   previous_warehouse_is_remote_ BOOLEAN;
BEGIN   
   handling_unit_id_tab_ := Get_Handling_Unit_Id_Tab___(handling_unit_id_list_);
   handling_unit_id_tab_ := Get_Node_Level_Sorted_Units___(handling_unit_id_tab_);
   
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP

         handling_unit_rec_ := Get_Object_By_Keys___(handling_unit_id_tab_(i).handling_unit_id);

         IF (previous_contract_ IS NULL) THEN
            -- This is the first record in the collection....
            warehouse_id_        := Inventory_Location_API.Get_Warehouse(handling_unit_rec_.contract, handling_unit_rec_.location_no);
            warehouse_is_remote_ := Warehouse_API.Get_Remote_Warehouse_Db(handling_unit_rec_.contract, warehouse_id_) = Fnd_Boolean_API.DB_TRUE;
         ELSE
            -- This is not the first record in the collection....
            IF (previous_contract_ != handling_unit_rec_.contract) THEN 
               -- All handling units on the shipment order must have the same sender and sender type...
               Error_SYS.Record_General(lu_name_, 'DIFFSITES: Handling units from several sites cannot be selected when creating the shipment order.');
            END IF;
            IF (previous_location_no_ != handling_unit_rec_.location_no) THEN
               -- This handling unit is stored in a different location than the previous one
               warehouse_id_ := Inventory_Location_API.Get_Warehouse(handling_unit_rec_.contract, handling_unit_rec_.location_no);
               IF (previous_warehouse_id_ != warehouse_id_ ) THEN
                  -- since there are multiple warehouses involved then none of them can be remote.
                  warehouse_is_remote_ := Warehouse_API.Get_Remote_Warehouse_Db(handling_unit_rec_.contract, warehouse_id_) = Fnd_Boolean_API.DB_TRUE;
                  IF (previous_warehouse_is_remote_ OR warehouse_is_remote_) THEN
                     -- We can only involve one specific remote warehouse as sender.
                     Error_SYS.Record_General(lu_name_, 'DIFFRWHS: Multiple warehouses cannot be selected if one of them is a remote warehouse.');
                  END IF;
               END IF;
            END IF;
         END IF;
         
         previous_contract_            := handling_unit_rec_.contract;
         previous_location_no_         := handling_unit_rec_.location_no;
         previous_warehouse_id_        := warehouse_id_;
         previous_warehouse_is_remote_ := warehouse_is_remote_;
         
         Move_With_Shipment_Order(shipment_order_id_, 
                                  handling_unit_id_tab_(i).handling_unit_id, 
                                  receiver_type_db_, 
                                  receiver_id_,
                                  requisitioner_code_);
         
      END LOOP; 
   END IF;
END Move_With_Shipment_Order;


PROCEDURE Move_With_Shipment_Order (
   shipment_order_id_  IN OUT NUMBER,
   handling_unit_id_   IN     NUMBER, 
   receiver_type_db_   IN     VARCHAR2, 
   receiver_id_        IN     VARCHAR2,
   requisitioner_code_ IN     VARCHAR2)
IS
   handling_unit_id_tab_    Handling_Unit_Id_Tab;
   line_no_                 NUMBER;
   info_                    VARCHAR2(2000);
   sender_type_db_          VARCHAR2(20);
   rwh_sender_type_db_      VARCHAR2(20);
   site_sender_type_db_     VARCHAR2(20);
   sender_id_               VARCHAR2(50);
   warehouse_rec_           Warehouse_API.Public_Rec;
   
   CURSOR get_stock_records IS
      SELECT *
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE(handling_unit_id_tab_))
         AND qty_onhand > 0;
       
BEGIN
   handling_unit_id_tab_ := Get_Node_And_Descendants(handling_unit_id_);

   $IF Component_Discom_SYS.INSTALLED $THEN
      rwh_sender_type_db_  := Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE;
      site_sender_type_db_ := Sender_Receiver_Type_API.DB_SITE;
   $ELSE
      Error_SYS.Component_Not_Exist('DISCOM');
   $END
   
   FOR stock_rec_ IN get_stock_records LOOP 
      IF (sender_id_ IS NULL) THEN
         -- This is the first record in the collection....
         warehouse_rec_ := Warehouse_API.Get(stock_rec_.contract, stock_rec_.warehouse);
         IF (warehouse_rec_.remote_warehouse = Fnd_Boolean_API.DB_TRUE) THEN 
            sender_id_      := warehouse_rec_.global_warehouse_id;
            sender_type_db_ := rwh_sender_type_db_;
         ELSE
            sender_id_      := stock_rec_.contract;
            sender_type_db_ := site_sender_type_db_;
         END IF;
      END IF;
      
      IF ((sender_type_db_ != receiver_type_db_) OR (sender_id_ != receiver_id_)) THEN
         $IF Component_Shipod_SYS.INSTALLED $THEN
            Shipment_Ord_Utility_API.Create_And_Reserve_Ship_Order(info_               => info_,        
                                                                   shipment_order_id_  => shipment_order_id_, 
                                                                   line_no_            => line_no_, 
                                                                   sender_id_          => sender_id_, 
                                                                   sender_type_        => sender_type_db_, 
                                                                   receiver_id_        => receiver_id_, 
                                                                   receiver_type_      => receiver_type_db_, 
                                                                   requisitioner_code_ => requisitioner_code_,
                                                                   part_no_            => stock_rec_.part_no, 
                                                                   quantity_           => stock_rec_.qty_onhand, 
                                                                   contract_           => stock_rec_.contract, 
                                                                   condition_code_     => Condition_Code_Manager_API.Get_Condition_Code(stock_rec_.part_no, stock_rec_.serial_no, stock_rec_.lot_batch_no), 
                                                                   configuration_id_   => stock_rec_.configuration_id, 
                                                                   location_no_        => stock_rec_.location_no, 
                                                                   lot_batch_no_       => stock_rec_.lot_batch_no, 
                                                                   serial_no_          => stock_rec_.serial_no, 
                                                                   eng_chg_level_      => stock_rec_.eng_chg_level, 
                                                                   waiv_dev_rej_no_    => stock_rec_.waiv_dev_rej_no, 
                                                                   handling_unit_id_   => stock_rec_.handling_unit_id, 
                                                                   activity_seq_       => stock_rec_.activity_seq, 
                                                                   project_id_         => stock_rec_.project_id,
                                                                   part_ownership_db_  => stock_rec_.part_ownership, 
                                                                   owning_customer_no_ => stock_rec_.owning_customer_no,
                                                                   owning_vendor_no_   => stock_rec_.owning_vendor_no);
         $ELSE
            Error_SYS.Component_Not_Exist('SHIPOD');
         $END
      END IF;
   END LOOP;
END Move_With_Shipment_Order;


PROCEDURE Save_Hu_Details_Into_Tmp(
   hu_details_temp_rec_ IN handling_unit_details_tmp%ROWTYPE)
IS
BEGIN
   INSERT INTO handling_unit_details_tmp VALUES hu_details_temp_rec_;
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Save_Hu_Details_Into_Tmp;


FUNCTION Get_Hu_Details_From_Tmp(
   handling_unit_id_ IN handling_unit_tab.handling_unit_id%TYPE) RETURN handling_unit_details_tmp%ROWTYPE
IS
   CURSOR registered_hu IS
      SELECT *
      FROM handling_unit_details_tmp
      WHERE handling_unit_id = handling_unit_id_;
   
   hu_details_temp_rec_ handling_unit_details_tmp%ROWTYPE;
BEGIN
   OPEN registered_hu;
   FETCH registered_hu INTO hu_details_temp_rec_;
   CLOSE registered_hu;
   RETURN hu_details_temp_rec_;
END Get_Hu_Details_From_Tmp;

PROCEDURE Clear_Hu_Details_From_Tmp
IS
BEGIN
   DELETE FROM handling_unit_details_tmp;
END Clear_Hu_Details_From_Tmp;

