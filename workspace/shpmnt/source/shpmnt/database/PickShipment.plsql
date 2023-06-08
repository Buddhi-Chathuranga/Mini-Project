-----------------------------------------------------------------------------
--
--  Logical unit: PickShipment
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  221103  AvWilk  SCDEV-17249, performance improvement,added condition as qty_assigned > qty_picked to the cursor in Add_Pick_Lists_To_Hu_Refr_List and Generate_Handl_Unit_Snapshot.
--  220722  RoJalk  SCDEV-12300, Added the method Check_Src_Demand_Code_Exist_HU.
--  220710  RoJalk  SCDEV-12305, Modified Use_Report_Pick_List_Lines to allow pick reporting from Shipment header for PO Receipt shipment order for serial parts with at receipt and issue tracking.  
--  220523  RoJalk  SCDEV-9134, Added the method Validate_Unreserve_Pick.
--  220405  Aabalk  SCDEV-7737, Modified Pick_Shipment_API.Report_Reserved_As_Picked__ to fetch shipment inventory location from shipment when not specified for generic reservation logic.
--  220328  PamPlk  SCDEV-6856, Modified the method Use_Report_Pick_List_Lines in order to support for Purchase Receipt Return.
--  211123  KiSalk  Bug 161378(SC21R2-5470), Fixed Print_Pick_List__ to properly split shipments_consolidated by text separator and assign to shipment id without the separator.
--  211103  DaZase  SC21R2-5900, Changes in Is_Fully_Picked to increase performance by removing old connect by prior cursor with a smaller cursor and hu collection loop instead.
--  210819  RoJalk  SC21R2-2343, Modified Pick_Report_Ship_Handl_Unit__ and code improvements to fecth values for clob_out_data_ at the end of pick reporting.
--  210727  RoJalk  SC21R2-1374, Modified Get_Pick_List_No_For_Shpmnt_Hu to exclude not pick listed reservations.
--  210708  MoinLK  SC21R2-1825, Added Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist methods to support
--  210708          REPORT_PICK_SHIPMENT_HU Wadaco Process.
--  210722  RoJalk  SC21R2-1374, Pick_Report_Ship_Handl_Unit__ so that ship_handling_unit_id_ will be included in the attr for CO pick reporting.
--  210722  RasDlk  SC21R2-1374, Modified Pick_Report_Ship_Handl_Unit__ by adding shipment_id as an IN parameter. 
--  210722          Added a method call to Can_Pick_Shipment_Hu to check whether the pick list is valid for report picking.
--  210712  RoJalk  SC21R2-1374, Modified Pick_Report_Ship_Handl_Unit__ and included handling_unit_id in aggregated_line_msg_.
--  210711  RoJalk  SC21R2-1374, Modified Pick_Report_Ship_Handl_Unit__ and passed the parameter ship_handling_unit_id_Pick_Customer_Order_API.Pick_Reservations__.
--  210709  RoJalk  SC21R2-1374, Modified Pick_Report_Ship_Handl_Unit__ changed the order of parameters and changed pick_list_type_ to be default null.   
--  210625  RasDlk  SC21R2-1036, Added the Can_Pick_Shipment_Hu, Get_Pick_List_No_For_Shpmnt_Hu and Is_Shpmnt_Hu_Fully_Picked functions.
--  210617  RoJalk  SC21R2-1374, Added the method Pick_Report_Ship_Handl_Unit__.
--  210514  Aabalk  SCZ-14792, Added method Print_Pick_List__() to print picks lists and process optional events.
--  210224  RoJalk  SC2020R1-10729, Modified Post_Pick_Report_Shipment and moved the call Shipment_Handling_Utility_API.Connect_Hus_From_Inventory before Shipment_Flow_API.Start_Shipment_Flow.
--  20202   RoJalk  SC2020R1-10729, Modified Post_Pick_Report_Shipment and changed the parameter trigger_shipment_flow_ to be BOOLEAN.
--  201127  BudKlk  SC2020R1-11383, Added Order BY clause to the Create_Data_Capture_Lov for START_PICK process in order to make sure the PICK_PART process comes before the PICK_HU.
--  201109  ErRalk  SC2020R1-11001, Added method Get_HU_Shipment_Reference_Info to fetch shipment reference info for Pick Handling Unit By Choice.
--  201023  DaZase  Bug 156114 (SCZ-116479), Added extra sorting on outermost_handling_unit_id in Create_Data_Capture_Lov for lov_id_ 2.
--  201014  Aabalk  SC2020R1-2119, Added Get_Sender_Id(), Get_Sender_Type_Db(), Get_Receiver_Id() and Get_Receiver_Type_Db() methods.
--  201014  ThKrlk  SCZ-11655, Modified Post_Print_Pick_List__() to call Shipment_Flow_API.Process_Optional_Events() if shipment id is not null.
--  200925  NiAslk  SC2020R1-1102, Added Create_Data_Capture_Lov(), Get_Column_Value_If_Unique(), Record_With_Column_Value_Exist() to use in the DataCapturePickPart.plsql
--  200911  RoJalk  SC2020R1-9192, Modified Post_Pick_Report_Shipment method and replaced the source_ref_type_db_ parameter with use_generic_reservation_.
--  200910  DiJwlk  SC2020R1-1104, Added Create_Data_Capture_Lov(), Get_Column_Value_If_Unique(), Record_With_Column_Value_Exist()
--  200910          Added Generate_Start_Exec_Stmt___().
--  200902  BudKlk  SC2020R1-1103, Added Create_Data_Capture_Lov(), Get_Column_Value_If_Unique(), Record_With_Column_Value_Exist() to use in the DataCapturePickHu.plsql
--  200902          and added a new method  Raise_No_Picklist_Error___(), Raise_No_Value_Exist_Error___().
--  200622  RasDlk  SC2020R1-689, Added the new method Check_Unpicked_Pick_List_Exist to check whether there exists at least one not fully_picked,
--  200622          inventory pick list with a deviating default shipment inventory from a considered shipment inventory location for a particular shipment.
--  191115  MeAblk  SCSPRING20-934, Increased the length of receiver_id upto 50 characters.
--  191106  RoJalk  SCSPRING20-173, Modified Get_Pick_Lists_For_Shipment, Post_Print_Pick_List__ to support Shipment Order.
--  190506  RoJalk  SCUXXW4-4869, Added the method Serial_Identification_Needed.
--  190319  NipKlk  Bug 147451(SCZ-3540), Modified the method Get_Shipment_Id() to fetch the first shipment id from the consolidated shipments if shipment_id is not retrieved initially.
--  180907  KiSalk  Bug 144063(SCZ-988), Modified WHERE clause of get_lines in Use_Report_Pick_List_Lines, for better performance, considering either shipment_id_ or pick_list_no_ must have a value.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180425  ErRalk  Bug 141558, Modified get_unpicked_reservation cursor in Reserved_As_Picked_Allowed method to fetch correct values for package components and for the normal parts.
--  180207  RoJalk  STRSC-16660, Modified Print_Ship_Consol_Pl__ to call correct method for printing.
--  180112  RoJalk  STRSC-12406, Modified Use_Report_Pick_List_Lines and removed teh parameter source_ref_type_db_.
--  180111  RoJalk  STRSC-12406, Modified Use_Report_Pick_List_Lines and included pick_list_no_ as a parameter to support when called on pick list no context.
--  171213  ChFolk  STRSC-14898, Added new method Get_Pick_List_Printed which returns true when the shipment connected pick list is printed.
--  171129  RoJalk  STRSC-9591, Added the method Get_Res_Not_Pick_Listed_Line.
--  171106  RoJalk  STRSC-12406, Changed the return type of Use_Report_Pick_List_Lines to be VARCHAR2.
--  171030  RoJalk  STRSC-9583, Added methods Start_Print_Ship_Consol_Pl__ and Print_Ship_Consol_Pl__.
--  171018  RoJalk  STRSC-9581, Changed the return type of Inventory_Pick_List_API.Is_Fully_Reported method to be VARCHAR2.
--  171012  RoJalk  STRSC-9564, Modified Execute_Pick_Event and replaced Inventory_Pick_List_API.New
--  171012          with Inventory_Pick_List_API.New_Per_Loc_Group.
--  170608  KhVese  LIM-11499, Added method Get_Source_Ref_Type_HU.
--  170530  RoJalk  LIM-11494, Added the method Use_Report_Pick_List_Lines and called from Pick_Event_Allowed.
--  170522  Jhalse  LIM-11468, Added method Check_Res_Picked_To_Ship_Loc.
--  170516  RoJalk  LIM-11281, Removed the method Remove_Picked_Line.
--  170510  RoJalk  STRSC-8047, Added the method Modify_Reserv_Hu_Pick_List_No. Modified Report_Reserved_As_Picked__ so that
--                  Inventory_Part_Reservation_API.Report_Reserved_As_Picked will pass the Inv Res Source Type Db.
--  170508  MaRalk  LIM-11258, Modified Pick_Event_Allowed in order to reflect Print_Pick_List_Allowed event.  
--  170508          Moved Print_Pick_List_Allowed method content for customer order source handling to ShipmentSourceUtility. 
--  170504  MaRalk  LIM-11258, Added methods Print_Pick_List, Print_Pick_List___, Create_Print_Jobs___ and Printing_Print_Jobs___
--  170504          in order to support printing Semi-Centralized Pick List report from Shipments overview. 
--  170504          Modified Execute_Pick_Event in order to reflect Print Pick List event.
--  170502  RoJalk  LIM-11324, Added the method Keep_Remaining_Reservation. 
--  170502  RoJalk  LIM-11324, Modified Post_Pick_Report_Shipment and added a call to Shipment_Handling_Utility_API.Connect_Hus_From_Inventory.
--  170427  RoJalk  LIM-11324, Modified Execute_Pick_Event and replaced Inventory_Part_Reservation_API.Set_Shipment_Qty_Res_As_Picked
--  170427          with Inventory_Pick_List_API.Set_Shipment_Qty_Res_As_Picked.
--  170424  NiAslk  STRSC-7439, Modified Report_Reserved_As_Picked__.
--  170421  NiAslk  STRSC-7369, Modified Report_Reserved_As_Picked__ to avoid Blocked customer order lines from being picked.
--  170421  RoJalk  LIM-11281, Added the method Remove_Picked_Line.
--  170418  Chfose  LIM-9427, Added new methods Get_Shipment_Id_HU, Get_Source_Ref1_HU, Get_Source_Ref2_HU, Get_Source_Ref3_HU, Get_Source_Ref4_HU.
--  170418  RoJalk  LIM-11324, Added method Is_Fully_Picked.
--  170412  RoJalk  LIM-10538, Modified Get_Forward_Agent_Id, Get_Route_Id, Get_Planned_Ship_Period, 
--  170412          Get_Planned_Ship_Date to fetch values from source if null value in shipment.
--  170407  RoJalk  LIM-11313, Replaced Customer_Order_Reservation_API.Get_Qty_Picked_HU with Pick_Shipment_API.Get_Qty_Picked_HU 
--  170406  Jhalse  LIM-11096, Removed reference to use_ship_inventory_ in Execute_Pick_Event as shipment inventory is mandatory for shipment.
--  170405  RoJalk  LIM-10554, Added the method Post_Pick_Report_Shipment.
--  170330  MaRalk  LIM-9052, Moved methods Print_Pick_List_Allowed, Get_Pick_Lists_For_Shipment from  
--  170330          ShipmentSourceUtility and handled for semi-centralized scenario.
--  170329  MaRalk  LIM-9646, Moved Post_Print_Pick_List__ method from ShipmentSourceUtility.
--  170324  Chfose  LIM-11152, Moved Add_Pick_Lists_To_Hu_Refr_List from CustomerOrderReservation and made generic.
--  170322  RoJalk  LIM-9117, Added the methods Reserved_As_Picked_Allowed, Reserved_As_Picked_Allowed__, 
--  170322          Report_Reserved_As_Picked__. 
--  170322  RoJalk  LIM-11253, Added the method Unreported_Pick_Lists_Exist.
--  170317  Jhalse  LIM-10113, Fixed source ref types, reworked some earlier functions for better functionality. Added Validate_Pick_Lists and Check Confirm_Ship_Location
--  170314  Chfose  LIM-11152, Moved Generate_Handl_Unit_Snapshot from Pick_Customer_Order_API.
--  170310  Jhalse  LIM-10113, Added generic interfaces to support new picking functionality.
--  170228  RoJalk  LIM-10218, Added the method Get_Receiver_Name, Get_Planned_Ship_Period and Get_Planned_Ship_Date.
--  170222  RoJalk  LIM-10218, Added methods Get_Receiver_Id, Get_Forward_Agent_Id, Get_Route_Id.
--  170224  RoJalk  LIM-10811, Added the method Pick_Report_Allowed.
--  170220  RoJalk  LIM-10811, Removed Create_Pick_Lists and included the logic in Execute_Pick_Event.
--  170215  RoJalk  LIM-10811, Added the method Execute_Pick_Event.
--  170209  RoJalk  LIM-9118, Removed Create_Pick_List_Allowed and added Pick_Event_Allowed
--  170208  RoJalk  LIM-10213, Added the method Pick_List_Fully_Reported.
--  170207  RoJalk  LIM-10594, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE Lov_Value_Tab  IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;

string_null_     CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-- Used by the client to determine if a dialog should be raised or not
@UncheckedAccess
FUNCTION Confirm_Shipment_Location_No__(
   pick_list_no_       IN VARCHAR2,
   pick_list_type_     IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   shipment_id_           NUMBER;
   shipment_type_         VARCHAR2(5);
   confirm_ship_location_ VARCHAR2(5) := 'TRUE';
   local_pick_list_type_  Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   local_pick_list_type_ := NVL(pick_list_type_, Get_Pick_List_Type(pick_list_no_));  
   IF(local_pick_list_type_ = 'CUST_ORDER_PICK_LIST') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         confirm_ship_location_ := Customer_Order_Pick_List_API.Get_Confirm_Ship_Location__(pick_list_no_);
      $ELSE
         NULL;
      $END  
   ELSE
      shipment_id_   := Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_);
      shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_id_);
      confirm_ship_location_ := Shipment_Type_API.Get_Confirm_Ship_Loc_No_Db(shipment_type_);
   END IF; 
   
   RETURN CASE WHEN confirm_ship_location_ = 'TRUE' THEN 1 ELSE 0 END;  
END Confirm_Shipment_Location_No__;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Print_Pick_List
--   Print the Consolidated Pick List for Shipment(Non-CO) report.
PROCEDURE Print_Pick_List___ (
   pick_list_no_  IN VARCHAR2 )
IS
     printer_id_               VARCHAR2(100);
     attr_                     VARCHAR2(200);
     report_attr_              VARCHAR2(2000);
     parameter_attr_           VARCHAR2(2000);
     print_job_id_             NUMBER;     
     report_id_                VARCHAR2(30);     
     inventory_pick_list_rec_  Inventory_Pick_List_API.Public_Rec;

BEGIN  
   Trace_SYS.Field('In Print_Pick_List__ ', pick_list_no_);  
   inventory_pick_list_rec_ := Inventory_Pick_List_API.Get(pick_list_no_);       
 
   -- Generate a new print job id
   report_id_  := 'SHPMNT_CONSOLID_PICK_LIST_REP';
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, attr_);   
   Print_Job_API.New(print_job_id_, attr_);
   
   -- Create the report
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, parameter_attr_);
   Create_Print_Jobs___(print_job_id_, report_id_, parameter_attr_);
   Printing_Print_Jobs___(print_job_id_);
   IF print_job_id_ IS NOT NULL THEN
      Inventory_Pick_List_API.Set_Printed(pick_list_no_);
   END IF;   
END Print_Pick_List___;


--   Create print job for a report. Only one job will be created for a particular report.
--   If a report has more than one result key then rest of the result keys will be
--   attached as pirnt job instances.
PROCEDURE Create_Print_Jobs___ (
   print_job_id_      IN OUT NUMBER,   
   report_            IN     VARCHAR2,
   in_parameter_attr_ IN     VARCHAR2) 
IS
   report_attr_       VARCHAR2(2000);
   result_key_        NUMBER;
   printer_id_        VARCHAR2(100);
   parameter_attr_    VARCHAR2(2000);
   job_attr_          VARCHAR2(2000);   
   job_contents_attr_ VARCHAR2(2000);
   print_job_ids_     VARCHAR2(25);
   instance_attr_     VARCHAR2(32000);
   lang_code_         VARCHAR2(2);
   
BEGIN
   parameter_attr_ := in_parameter_attr_;
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_, report_attr_);
   Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);
   
   --Note: Get the language code from archive instance
   Client_SYS.Clear_Attr(instance_attr_);
   Client_SYS.Clear_Attr(parameter_attr_);
   Archive_API.Get_Info(instance_attr_, parameter_attr_, result_key_);
   
   lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', instance_attr_);
   
   --Note: Get the printer which is defined in Priter Definition window
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 
                                                             report_,
                                                             language_code_ => lang_code_);
   
   Client_SYS.Clear_Attr(job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, job_attr_);

   Client_SYS.Clear_Attr(job_contents_attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, job_contents_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, job_contents_attr_); 

   -- Generate a new print job ids and Connect the created report  
   IF print_job_id_ IS NULL THEN      
      Print_Job_API.New_Print_Job(print_job_ids_, job_attr_, job_contents_attr_);
      -- Separate print job ids 
      IF print_job_ids_ IS NOT NULL THEN         
         print_job_id_ := print_job_ids_;            
      END IF;
   ELSE      
      -- If a report has more than one result key, the rest of the result keys, attach as print job instances to same print job
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, job_contents_attr_);
      Print_Job_Contents_API.New_Instance(job_contents_attr_);      
   END IF;    
END Create_Print_Jobs___;


PROCEDURE Printing_Print_Jobs___ (
   print_job_id_ IN NUMBER )
IS
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;   
END Printing_Print_Jobs___;


PROCEDURE Generate_Start_Exec_Stmt___(
   stmt_                  IN OUT VARCHAR2,
   pick_list_no_          IN     VARCHAR2,
   location_no_           IN     VARCHAR2,
   pick_list_no_level_db_ IN     VARCHAR2,
   sql_where_expression_  IN     VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
   END IF;
   IF (pick_list_no_level_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND part_or_handling_unit = :pick_list_no_level_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_level_db_ IS NULL  ';
   END IF;
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
END Generate_Start_Exec_Stmt___;


PROCEDURE Raise_No_Value_Exist_Error___(
   column_description_  IN VARCHAR2,
   column_value_        IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
END Raise_No_Value_Exist_Error___;

PROCEDURE Raise_No_Picklist_Error___(
   column_value_  IN VARCHAR2,
   pick_list_no_  IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTINPICKLIST: The value :P1 does not exist on Pick List :P2.', column_value_, pick_list_no_);
END Raise_No_Picklist_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Post_Print_Pick_List__ (
   pick_list_no_           IN VARCHAR2,
   consolidated_flag_db_   IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
   shipment_id_            IN VARCHAR2 DEFAULT NULL)
IS      
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
   shipment_type_          shipment_tab.shipment_type%TYPE;
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Customer_Order_Flow_API.Create_Print_Pick_List_Hist__(pick_list_no_, consolidated_flag_db_);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END   
      ELSIF(Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN
         Inventory_Pick_List_API.Set_Printed(pick_list_no_);
      END IF;
   END LOOP;  
   IF (shipment_id_ IS NOT NULL) THEN
      shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_id_);
      Shipment_Flow_API.Process_Optional_Events(shipment_id_, shipment_type_, '30');
   END IF;
END Post_Print_Pick_List__;

@UncheckedAccess
FUNCTION Reserved_As_Picked_Allowed__ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER   DEFAULT 0,
   incl_ship_connected_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   reserved_as_picked_allowed_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN   
   IF (Shipment_Source_Utility_API.Reserved_As_Picked_Allowed__(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                                shipment_id_, incl_ship_connected_, source_ref_type_db_) = Fnd_Boolean_API.DB_TRUE) THEN 
      reserved_as_picked_allowed_ := Reserved_As_Picked_Allowed(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_);                                                          
   END IF;
   RETURN reserved_as_picked_allowed_;
END Reserved_As_Picked_Allowed__;


PROCEDURE Report_Reserved_As_Picked__ (
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2,
   shipment_id_                IN NUMBER,   
   source_ref_type_db_         IN VARCHAR2)
IS
   temp_ship_inv_location_     VARCHAR2(35) := ship_inventory_location_no_;
BEGIN   
   IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
      temp_ship_inv_location_ := NVL(ship_inventory_location_no_, Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_));
      Inventory_Part_Reservation_API.Report_Reserved_As_Picked(source_ref1_,
                                                               source_ref2_,
                                                               source_ref3_, 
                                                               source_ref4_, 
                                                               Reserve_Shipment_API.Get_Inv_Res_Source_Type_Db(source_ref_type_db_), 
                                                               shipment_id_, 
                                                               Shipment_API.Get_Contract(shipment_id_),
                                                               temp_ship_inv_location_);
   ELSE
      Shipment_Source_Utility_API.Report_Reserved_As_Picked__(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                              temp_ship_inv_location_, shipment_id_, source_ref_type_db_);
   END IF;   
   
END Report_Reserved_As_Picked__;
   
  
PROCEDURE Start_Print_Ship_Consol_Pl__ (
   attr_ IN VARCHAR2 )
IS
   description_ VARCHAR2(200);
BEGIN
   description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINTSHPCONSOL: Print Consolidated Pick List for Shipment');
   Transaction_SYS.Deferred_Call('Pick_Shipment_API.Print_Ship_Consol_Pl__', attr_, description_);
END Start_Print_Ship_Consol_Pl__;


PROCEDURE Print_Ship_Consol_Pl__ (
   attr_ IN VARCHAR2 )
IS
   ptr_            NUMBER;
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   pick_list_no_   VARCHAR2(15);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PICK_LIST_NO') THEN
         -- Keeping the pick list no as VARCHAR2 since report method support this as a string report parameter.
         pick_list_no_ := value_;
         Print_Pick_List___(pick_list_no_);
      END IF;
   END LOOP;
END Print_Ship_Consol_Pl__;


PROCEDURE Print_Pick_List__ (
   attr_ IN VARCHAR2)
IS
   current_pick_list_no_      VARCHAR2(40);
   attr1_                     VARCHAR2(32000);
   attr_consol_               VARCHAR2(32000);
   attr_inv_                  VARCHAR2(32000);
   attr_current_              VARCHAR2(32000);
   shipments_consolidated_    VARCHAR2(2000);
   shipment_type_             VARCHAR2(3);
   shipment_id_               NUMBER;
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   index_                     NUMBER := 1;
   separator_position_        NUMBER;
   optional_event_            NUMBER := 30;
   
   CURSOR get_picklist_info(pick_list_no_ IN VARCHAR2) IS
      SELECT pick_list_no, pick_list_type, order_no, shipment_id, shipments_consolidated
      FROM   print_pick_list
      WHERE  pick_list_no =  pick_list_no_;
   
   TYPE Pick_List_Tab IS TABLE OF get_picklist_info%ROWTYPE INDEX BY BINARY_INTEGER;
   pick_list_tab_         Pick_List_Tab;
BEGIN
   Client_SYS.Clear_Attr(attr1_);
   Client_SYS.Clear_Attr(attr_consol_);
   Client_SYS.Clear_Attr(attr_inv_);
   -- Get all the selected Pick List numbers to the attr_
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PICK_LIST_NO') THEN
         current_pick_list_no_ := value_;
         OPEN get_picklist_info(current_pick_list_no_);
         FETCH get_picklist_info INTO pick_list_tab_(index_);
         CLOSE get_picklist_info;
         
         IF pick_list_tab_(index_).pick_list_type = 'INVENTORY_PICK_LIST' THEN
            Client_SYS.Clear_Attr(attr_current_);
            Client_SYS.Add_To_Attr('PICK_LIST_NO', current_pick_list_no_, attr_current_);         
            attr_inv_ := attr_inv_ || attr_current_;
         ELSIF pick_list_tab_(index_).pick_list_type = 'CUST_ORDER_PICK_LIST' THEN
            IF pick_list_tab_(index_).order_no IS NULL THEN
               Client_SYS.Clear_Attr(attr_current_);
               Client_SYS.Add_To_Attr('PICK_LIST_NO', current_pick_list_no_, attr_current_);
               Client_SYS.Add_To_Attr('END', '', attr_current_);            
               attr_consol_ := attr_consol_ || attr_current_;            
            ELSE
               Client_SYS.Clear_Attr(attr_current_);
               Client_SYS.Add_To_Attr('START_EVENT', 80, attr_current_);
               Client_SYS.Add_To_Attr('ORDER_NO', pick_list_tab_(index_).order_no, attr_current_);
               Client_SYS.Add_To_Attr('PICK_LIST_NO', current_pick_list_no_, attr_current_);
               Client_SYS.Add_To_Attr('END', '', attr_current_);            
               attr1_ := attr1_ || attr_current_;            
            END IF;
         END IF;
         index_ := index_ + 1;
      END IF;
   END LOOP;
   
   $IF Component_Order_SYS.INSTALLED $THEN            
   IF attr1_ IS NOT NULL THEN
      Customer_Order_Flow_API.Start_Print_Pick_List__(attr1_);
   END IF;
   IF attr_consol_ IS NOT NULL THEN
      Customer_Order_Flow_API.Start_Print_Consol_Pl__(attr_consol_);
   END IF;
   $END
   IF attr_inv_ IS NOT NULL THEN
      Start_Print_Ship_Consol_Pl__(attr_inv_);
   END IF;

   -- Process all optional events
   FOR i_ IN 1..pick_list_tab_.COUNT LOOP
      IF pick_list_tab_(i_).pick_list_type = 'INVENTORY_PICK_LIST' THEN
         IF (pick_list_tab_(i_).shipment_id IS NOT NULL) THEN
            shipment_type_ := Shipment_API.Get_Shipment_Type(pick_list_tab_(i_).shipment_id);
            Shipment_Flow_API.Process_Optional_Events(pick_list_tab_(i_).shipment_id, shipment_type_, optional_event_);
         END IF;
      ELSIF pick_list_tab_(i_).pick_list_type = 'CUST_ORDER_PICK_LIST' THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            shipments_consolidated_ := pick_list_tab_(i_).shipments_consolidated;
            -- Loop through the consolidated shipments and process optional events for each shipment individually.
            WHILE (shipments_consolidated_ IS NOT NULL) LOOP
               separator_position_ := instr(shipments_consolidated_, Client_SYS.text_separator_);
               IF (separator_position_ > 1) THEN
                  shipment_id_ := substr(shipments_consolidated_, 1, separator_position_ - 1);
                  shipments_consolidated_ := substr(shipments_consolidated_, separator_position_ + 1);
               ELSE
                  -- Handles the case when there is only one shipment remaining to process
                  shipment_id_ := to_number(shipments_consolidated_);
                  shipments_consolidated_ := NULL;
               END IF;
               shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_id_);
               Shipment_Flow_API.Process_Optional_Events(shipment_id_, shipment_type_, optional_event_);
            END LOOP;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
END Print_Pick_List__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Reserved_As_Picked_Allowed (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   shipment_id_         IN NUMBER   DEFAULT 0) RETURN VARCHAR2
IS
   catch_qty_onhand_    NUMBER;
   number_null_         NUMBER := -99999999999;
   return_val_          VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   part_catalog_rec_    Part_Catalog_API.Public_Rec;

   CURSOR get_unpicked_reservation IS
      SELECT *
      FROM   shipment_source_reservation 
      WHERE  source_ref1        = source_ref1_
      AND    source_ref2        = NVL(source_ref2_,  '*')
      AND    source_ref3        = NVL(source_ref3_ , '*')
      AND    (((source_ref_type_db  = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND ((Utility_SYS.String_To_Number(source_ref4_) = -1 AND source_ref4 > 0) OR source_ref4 = source_ref4_ )) OR
              ((source_ref_type_db != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (source_ref4 = NVL(source_ref4_, '*'))))
      AND    source_ref_type_db = source_ref_type_db_            
      AND    shipment_id        = shipment_id_ 
      AND    pick_list_no       = '*';
BEGIN  
   FOR res_rec_ IN get_unpicked_reservation LOOP
      return_val_       := Fnd_Boolean_API.DB_TRUE;
      part_catalog_rec_ := Part_Catalog_API.Get(res_rec_.part_no);

      IF (part_catalog_rec_.catch_unit_enabled = Fnd_Boolean_API.DB_TRUE ) THEN
         catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand(contract_           => res_rec_.contract,      
                                                                                   part_no_            => res_rec_.part_no,         
                                                                                   configuration_id_   => res_rec_.configuration_id,
                                                                                   location_no_        => res_rec_.location_no,   
                                                                                   lot_batch_no_       => res_rec_.lot_batch_no,    
                                                                                   serial_no_          => res_rec_.serial_no,
                                                                                   eng_chg_level_      => res_rec_.eng_chg_level, 
                                                                                   waiv_dev_rej_no_    => res_rec_.waiv_dev_rej_no, 
                                                                                   activity_seq_       => res_rec_.activity_seq, 
                                                                                   handling_unit_id_   => res_rec_.handling_unit_id);
         IF (catch_qty_onhand_ != NVL(res_rec_.catch_qty, number_null_)) THEN
            return_val_ := Fnd_Boolean_API.DB_FALSE;
            EXIT;
         END IF;  
      END IF;

      -- Check the receipt and issue serial tracking flag for serial parts 
      IF (res_rec_.serial_no = '*' AND part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE) THEN
         return_val_ := Fnd_Boolean_API.DB_FALSE;
         EXIT;
      END IF;
   END LOOP;   
   RETURN return_val_;   
END Reserved_As_Picked_Allowed;


@UncheckedAccess
FUNCTION Pick_Event_Allowed (
   shipment_id_                   IN NUMBER,
   shipment_event_                IN NUMBER,
   report_pick_from_source_lines_ IN VARCHAR2 ) RETURN NUMBER
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER; 
   shipment_rec_           Shipment_API.Public_Rec;
   allowed_                NUMBER := 0;
BEGIN   
   shipment_rec_:= Shipment_API.Get(shipment_id_);
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, shipment_rec_.source_ref_type);
   
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         CASE shipment_event_ 
            WHEN 20 THEN
               allowed_ := Shipment_Source_Utility_API.Create_Pick_List_Allowed(shipment_id_, source_ref_type_list_(i_));
            WHEN 30 THEN
               allowed_ := Shipment_Source_Utility_API.Print_Pick_List_Allowed(shipment_id_, source_ref_type_list_(i_));
               WHEN 40 THEN
                  IF ((NVL(report_pick_from_source_lines_, 'FALSE') = 'TRUE') OR
                      ((NVL(report_pick_from_source_lines_, 'FALSE') = 'FALSE') AND (Use_Report_Pick_List_Lines(shipment_id_, NULL)) = 'FALSE')) THEN   
                     allowed_ := Shipment_Source_Utility_API.Pick_Report_Ship_Allowed(shipment_id_, source_ref_type_list_(i_), report_pick_from_source_lines_);
                  END IF;     
            END CASE;
      ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN
         CASE shipment_event_ 
            WHEN 20 THEN
               IF (Inventory_Part_Reservation_API.Create_Pick_List_Allowed(shipment_id_)) THEN
                  allowed_ := 1;
               END IF;
            WHEN 30 THEN
               allowed_ := CASE (Inventory_Pick_List_API.Shipment_Has_Unprinted_List(shipment_id_))
                              WHEN TRUE THEN 1
                              ELSE 0
                              END;  
            WHEN 40 THEN
               IF (NOT(Inventory_Pick_List_API.Shipment_Is_Fully_Reported(shipment_id_))) THEN
                  IF ((NVL(report_pick_from_source_lines_, 'FALSE') = 'TRUE') OR
                      ((NVL(report_pick_from_source_lines_, 'FALSE') = 'FALSE') AND (Use_Report_Pick_List_Lines(shipment_id_, NULL) = 'FALSE'))) THEN
                     allowed_ := 1;
                  END IF;
               END IF;
            END CASE;
      END IF;  
   END LOOP; 
   
   RETURN allowed_;  
END Pick_Event_Allowed;


PROCEDURE Execute_Pick_Event (
   shipment_id_        IN NUMBER,
   shipment_event_     IN NUMBER,
   location_no_        IN VARCHAR2) 
IS
   source_ref_type_list_       Utility_SYS.STRING_TABLE;
   num_sources_                NUMBER; 
   shipment_rec_               Shipment_API.Public_Rec;
   ship_inventory_location_no_ VARCHAR2(35);
BEGIN   
   shipment_rec_:= Shipment_API.Get(shipment_id_);
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, shipment_rec_.source_ref_type);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         CASE shipment_event_ 
            WHEN 20 THEN
               Shipment_Source_Utility_API.Create_Shipment_Pick_Lists(shipment_id_, source_ref_type_list_(i_));
            WHEN 30 THEN
               Shipment_Source_Utility_API.Print_Pick_List(shipment_id_, source_ref_type_list_(i_));
            WHEN 40 THEN
               Shipment_Source_Utility_API.Report_Shipment_Pick_Lists(shipment_id_, location_no_, source_ref_type_list_(i_)); 
            END CASE;
      ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN
         CASE shipment_event_ 
            WHEN 20 THEN
               ship_inventory_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
               Inventory_Pick_List_API.New_Per_Loc_Group(shipment_id_, shipment_rec_.contract, ship_inventory_location_no_);
            WHEN 30 THEN
               Print_Pick_List(shipment_id_);
            WHEN 40 THEN
               Inventory_Pick_List_API.Set_Shipment_Qty_Res_As_Picked(shipment_id_, location_no_);
            END CASE;
      END IF;  
   END LOOP;   
END Execute_Pick_Event;

@UncheckedAccess
FUNCTION Pick_List_Fully_Reported (
   pick_list_no_       IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pick_list_fully_reported_   VARCHAR2(5) := 'TRUE';
   invent_pick_list_no_        NUMBER;
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Customer_Order_Pick_List_API.Get_Picking_Confirmed_Db(pick_list_no_) = 'UNPICKED') THEN
            pick_list_fully_reported_ := 'FALSE';
         END IF;  
      $ELSE
         NULL;
      $END  
   ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
      invent_pick_list_no_ := CASE WHEN pick_list_no_ = '*' THEN 0 ELSE to_number(pick_list_no_) END;
      IF (Inventory_Pick_List_API.Is_Fully_Reported(TO_NUMBER(invent_pick_list_no_)) = 'FALSE') THEN
         pick_list_fully_reported_ := 'FALSE';
      END IF;
   END IF;             
   RETURN pick_list_fully_reported_;  
END Pick_List_Fully_Reported;

@UncheckedAccess
FUNCTION Pick_Report_Allowed (
   shipment_id_                   IN NUMBER,   
   source_ref_type_db_            IN VARCHAR2,
   report_pick_from_source_lines_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   pick_report_ship_allowed_  NUMBER;
BEGIN   
   IF (Shipment_API.Get_Objstate(shipment_id_) != 'Preliminary' AND 
      Shipment_API.Any_Unpicked_Reservations__(shipment_id_) != Fnd_Boolean_API.DB_TRUE) THEN
      pick_report_ship_allowed_:= 0;
   END IF;   
   pick_report_ship_allowed_ := Pick_Event_Allowed(shipment_id_, 40, report_pick_from_source_lines_);
   RETURN pick_report_ship_allowed_;
END Pick_Report_Allowed;


@UncheckedAccess
FUNCTION Get_Sender_Id (
   shipment_id_         IN NUMBER,
   contract_            IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   sender_id_  VARCHAR2(50);
BEGIN
   IF (NVL(shipment_id_, 0) = 0) THEN 
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         sender_id_ := contract_;
      END IF;
   ELSE 
      sender_id_ := Shipment_API.Get_Sender_Id(shipment_id_);
   END IF;
   RETURN sender_id_;
END Get_Sender_Id;


@UncheckedAccess
FUNCTION Get_Sender_Type_Db (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   sender_type_db_   VARCHAR2(20);
BEGIN
   IF (NVL(shipment_id_, 0) = 0) THEN
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         sender_type_db_ := Sender_Receiver_Type_API.DB_SITE;
      END IF;
   ELSE 
      sender_type_db_ := Shipment_API.Get_Sender_Type_Db(shipment_id_);
   END IF;
   RETURN sender_type_db_;
END Get_Sender_Type_Db;


@UncheckedAccess
FUNCTION Get_Receiver_Id (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   receiver_id_      VARCHAR2(50);
BEGIN
   IF (NVL(shipment_id_, 0) = 0) THEN
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            receiver_id_ := Customer_Order_Line_API.Get_Deliver_To_Customer_No(source_ref1_, source_ref2_, source_ref2_, source_ref4_);
         $ELSE
            NULL;
         $END
      END IF;
   ELSE
      receiver_id_ := Shipment_API.Get_Receiver_Id(shipment_id_);
   END IF;
   RETURN receiver_id_;
END Get_Receiver_Id;


@UncheckedAccess
FUNCTION Get_Receiver_Id (
   shipment_id_   IN NUMBER,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2 ) RETURN VARCHAR2
IS  
   receiver_id_   VARCHAR2(50);
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) = 0) THEN      
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_id_:= Customer_Order_Line_API.Get_Deliver_To_Customer_No(source_ref1_, source_ref2_, source_ref3_, TO_NUMBER(source_ref4_));   
      $ELSE
         NULL;
      $END
   ELSE
      receiver_id_:= Shipment_API.Get_Receiver_Id(shipment_id_);
   END IF;
   RETURN receiver_id_;       
END Get_Receiver_Id;


@UncheckedAccess
FUNCTION Get_Receiver_Name (
   shipment_id_   IN NUMBER,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2 ) RETURN VARCHAR2
IS  
   receiver_name_   VARCHAR2(100);
   shipment_rec_    Shipment_API.Public_Rec;
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) = 0) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_name_:= Customer_Info_API.Get_Name(Customer_Order_Line_API.Get_Deliver_To_Customer_No(source_ref1_, source_ref2_,
                                                                                                        source_ref3_, TO_NUMBER(source_ref4_)));   
      $ELSE
         NULL;
      $END
   ELSE
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      receiver_name_:= Shipment_Source_Utility_API.Get_Receiver_Name(shipment_rec_.receiver_id, shipment_rec_.receiver_type);
   END IF;
   RETURN receiver_name_;       
END Get_Receiver_Name;


@UncheckedAccess
FUNCTION Get_Receiver_Type_Db (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS 
   receiver_type_db_ VARCHAR2(20);
BEGIN
   IF (NVL(shipment_id_, 0) = 0) THEN
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         receiver_type_db_ := Sender_Receiver_Type_API.DB_CUSTOMER;
      END IF;
   ELSE
      receiver_type_db_ := Shipment_API.Get_Receiver_Type_Db(shipment_id_);
   END IF;
   RETURN receiver_type_db_;
END Get_Receiver_Type_Db;


@UncheckedAccess
FUNCTION Get_Forward_Agent_Id (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   forward_agent_id_   VARCHAR2(20);
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) != 0) THEN 
      forward_agent_id_:= Shipment_API.Get_Forward_Agent_Id(shipment_id_);
   END IF;  
   
   IF (forward_agent_id_ IS NULL) THEN      
      forward_agent_id_:= Shipment_Source_Utility_API.Get_Forward_Agent_Id(source_ref1_, source_ref2_, 
                                                                           source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;
   
   RETURN forward_agent_id_;       
END Get_Forward_Agent_Id;


@UncheckedAccess
FUNCTION Get_Route_Id (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   route_id_   VARCHAR2(12);
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) != 0) THEN 
      route_id_:= Shipment_API.Get_Route_Id(shipment_id_);
   END IF;  
   
   IF (route_id_ IS NULL) THEN      
      route_id_:= Shipment_Source_Utility_API.Get_Route_Id(source_ref1_, source_ref2_, 
                                                           source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;
   
   RETURN route_id_;       
END Get_Route_Id;


@UncheckedAccess
FUNCTION Get_Planned_Ship_Period (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   planned_ship_period_   VARCHAR2(10);
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) != 0) THEN 
      planned_ship_period_:= Shipment_API.Get_Planned_Ship_Period(shipment_id_);
   END IF;  
   
   IF (planned_ship_period_ IS NULL) THEN   
      planned_ship_period_:= Shipment_Source_Utility_API.Get_Line_Planned_Ship_Period__(source_ref1_, source_ref2_, source_ref3_,
                                                                                        source_ref4_, source_ref_type_db_);   
   END IF;
   
   RETURN planned_ship_period_;       
END Get_Planned_Ship_Period;


@UncheckedAccess
FUNCTION Get_Planned_Ship_Date (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN DATE
IS  
   planned_ship_date_   DATE;
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   IF (NVL(shipment_id_, 0) != 0) THEN 
      planned_ship_date_:= Shipment_API.Get_Planned_Ship_Date(shipment_id_);
   END IF;  
   
   IF (planned_ship_date_ IS NULL) THEN      
      planned_ship_date_:= Shipment_Source_Utility_API.Get_Line_Planned_Ship_Date__(source_ref1_, source_ref2_, 
                                                                                    source_ref3_, source_ref4_, source_ref_type_db_);
   END IF;
   
   RETURN planned_ship_date_;       
END Get_Planned_Ship_Date;


@UncheckedAccess
FUNCTION Get_Shipment_Id(
   pick_list_no_       IN VARCHAR2,
   pick_list_type_     IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   shipment_id_            NUMBER := 0;
   local_pick_list_type_   Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   local_pick_list_type_ := NVL(pick_list_type_, Get_Pick_List_Type(pick_list_no_));
   IF(local_pick_list_type_ = 'CUST_ORDER_PICK_LIST') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         shipment_id_ := Customer_Order_Pick_List_API.Get_Shipment_Id(pick_list_no_);
         IF shipment_id_ IS NULL THEN
            shipment_id_ := Customer_Order_Pick_List_API.Get_First_Shipment_Id(pick_list_no_);
         END IF;
      $ELSE
         NULL;
      $END
   ELSE
      shipment_id_ := Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_);
   END IF;             
   RETURN shipment_id_;  
END Get_Shipment_Id;


@UncheckedAccess
FUNCTION Get_Contract(
   pick_list_no_       IN VARCHAR2,
   pick_list_type_     IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   contract_               VARCHAR2(5);
   local_pick_list_type_   Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   local_pick_list_type_ := NVL(pick_list_type_, Get_Pick_List_Type(pick_list_no_));  
   IF(local_pick_list_type_ = 'CUST_ORDER_PICK_LIST')THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         contract_ := Customer_Order_Pick_List_API.Get_Contract(pick_list_no_);
      $ELSE
         NULL;
      $END  
   ELSE
      contract_ := Inventory_Pick_List_API.Get_Contract(pick_list_no_);
   END IF;             
   RETURN contract_;  
END Get_Contract;


@UncheckedAccess
FUNCTION Get_Ship_Inventory_Location_No(
   pick_list_no_       IN VARCHAR2,
   pick_list_type_     IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   ship_inventory_location_no_ VARCHAR2(35);
   local_pick_list_type_       Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   local_pick_list_type_ := NVL(pick_list_type_, Get_Pick_List_Type(pick_list_no_));  
   IF(pick_list_type_ = 'CUST_ORDER_PICK_LIST') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         ship_inventory_location_no_ := Customer_Order_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_);
      $ELSE
         NULL;
      $END  
   ELSE
      ship_inventory_location_no_ := Inventory_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_);
   END IF;             
   RETURN ship_inventory_location_no_;  
END Get_Ship_Inventory_Location_No;


-- Gets the default shipment location for a pick list. Returns the shipment inventory location the pick list
-- should have gotten at creation. It does NOT return the location currently saved in the pick list header.
@UncheckedAccess
FUNCTION Get_Default_Shipment_Location(
   pick_list_no_       IN NUMBER,
   pick_list_type_     IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   ship_inventory_location_no_ VARCHAR2(35);
   shipment_id_                NUMBER;
   source_ref1_                VARCHAR2(20);
   local_pick_list_type_       Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   local_pick_list_type_ := NVL(pick_list_type_, Get_Pick_List_Type(pick_list_no_));  
   shipment_id_ := Get_Shipment_Id(pick_list_no_, local_pick_list_type_);
   -- If there is a shipment, the pick list should get the location set on the shipment
   IF(shipment_id_ IS NOT NULL)THEN
      ship_inventory_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
   -- Otherwise, get it from the Customer Order. First checks SCM then Site.
   ELSIF(local_pick_list_type_ = 'CUST_ORDER_PICK_LIST') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         source_ref1_ := Customer_Order_Pick_List_API.Get_Order_No(pick_list_no_);
         ship_inventory_location_no_ := Customer_Order_API.Get_Default_Shipment_Location(source_ref1_);
      $ELSE
         NULL;
      $END   
   END IF;
   
   -- Falls back to site setting when unable to resolve a shipment inventory location no.
   IF(shipment_id_ IS NULL AND source_ref1_ IS NULL) THEN
      ship_inventory_location_no_ := Site_Discom_Info_API.Get_Ship_Inventory_Location_No(Get_Contract(pick_list_no_, local_pick_list_type_));
   END IF;
   RETURN ship_inventory_location_no_;
END Get_Default_Shipment_Location;


PROCEDURE Generate_Handl_Unit_Snapshot (
   pick_list_no_ IN VARCHAR2 )         
IS
   reservation_tab_ Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   CURSOR get_reservations IS
      SELECT contract, part_no, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, 
             handling_unit_id, qty_assigned quantity
      FROM   SHIPMENT_SOURCE_RESERVATION
      WHERE  pick_list_no = pick_list_no_
      AND    qty_assigned > qty_picked;
BEGIN
   OPEN get_reservations;
   FETCH get_reservations BULK COLLECT INTO reservation_tab_;
   CLOSE get_reservations;

   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_              => pick_list_no_,
                                                  source_ref_type_db_       => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST,
                                                  inv_part_stock_tab_       => reservation_tab_,
                                                  only_outermost_in_result_ => FALSE,
                                                  incl_hu_zero_in_result_   => TRUE);
END Generate_Handl_Unit_Snapshot; 


PROCEDURE Add_Pick_Lists_To_Hu_Refr_List (  
   stock_keys_tab_      IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   inventory_event_id_  IN NUMBER )
IS
   CURSOR get_pick_list_no(contract_          VARCHAR2,
                           part_no_           VARCHAR2,
                           configuration_id_  VARCHAR2,
                           location_no_       VARCHAR2,
                           lot_batch_no_      VARCHAR2,
                           serial_no_         VARCHAR2,
                           eng_chg_level_     VARCHAR2,
                           waiv_dev_rej_no_   VARCHAR2,
                           activity_seq_      NUMBER,
                           handling_unit_id_  NUMBER) IS
      SELECT DISTINCT res.pick_list_no
      FROM   SHIPMENT_SOURCE_RESERVATION res
      WHERE  res.contract          = contract_
      AND    res.part_no           = part_no_
      AND    res.configuration_id  = configuration_id_
      AND    res.location_no       = location_no_
      AND    res.lot_batch_no      = lot_batch_no_
      AND    res.serial_no         = serial_no_
      AND    res.eng_chg_level     = eng_chg_level_
      AND    res.waiv_dev_rej_no   = waiv_dev_rej_no_
      AND    res.activity_seq      = activity_seq_
      AND    res.handling_unit_id  = handling_unit_id_
      AND    res.pick_list_no     != '*'
      AND    res.qty_assigned      > qty_picked;
BEGIN
   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         FOR rec_ IN get_pick_list_no(stock_keys_tab_(i).contract,
                                      stock_keys_tab_(i).part_no,
                                      stock_keys_tab_(i).configuration_id,
                                      stock_keys_tab_(i).location_no,
                                      stock_keys_tab_(i).lot_batch_no,
                                      stock_keys_tab_(i).serial_no,
                                      stock_keys_tab_(i).eng_chg_level,
                                      stock_keys_tab_(i).waiv_dev_rej_no,
                                      stock_keys_tab_(i).activity_seq,
                                      stock_keys_tab_(i).handling_unit_id) LOOP
            Hu_Snapshot_For_Refresh_API.New(source_ref1_         => rec_.pick_list_no,
                                            source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST,
                                            inventory_event_id_  => inventory_event_id_);
         END LOOP;
      END LOOP;
   END IF;
END Add_Pick_Lists_To_Hu_Refr_List;

-- Gets the Confirm_Ship_Location setting based on a source.
-- Default is always confirm -> Specific dialog triggers and queries the user to select a shipment location.
@UncheckedAccess
FUNCTION Check_Confirm_Ship_Location(
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS
   confirm_ship_location_ NUMBER := 1;
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         confirm_ship_location_ := Pick_Customer_Order_API.Check_Confirm_Ship_Location(order_no_ => source_ref1_);
      END IF;
   $END
   RETURN confirm_ship_location_;
END Check_Confirm_Ship_Location;


@UncheckedAccess
FUNCTION Check_Confirm_Ship_Location(
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER DEFAULT 0) RETURN NUMBER
IS
   confirm_ship_location_ NUMBER := 1;
BEGIN
   IF(NVL(shipment_id_, 0) = 0) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
            confirm_ship_location_ := Pick_Customer_Order_API.Check_Confirm_Ship_Location(order_no_      => source_ref1_,
                                                                                          line_no_       => source_ref2_,
                                                                                          rel_no_        => source_ref3_,
                                                                                          line_item_no_  => source_ref4_);
         END IF;
      $ELSE
         NULL;
      $END
   ELSE
      confirm_ship_location_ := CASE WHEN Shipment_Type_API.Get_Confirm_Ship_Loc_No_Db(Shipment_API.Get_Shipment_Type(shipment_id_)) = 'TRUE' THEN 1 ELSE 0 END;
   END IF;
   RETURN confirm_ship_location_;
END Check_Confirm_Ship_Location;


@UncheckedAccess
FUNCTION Unreported_Pick_Lists_Exist (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   unreported_pick_lists_exist_ VARCHAR2(5) := 'FALSE';
   source_ref_type_list_        Utility_SYS.STRING_TABLE;
   num_sources_                 NUMBER;
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP     
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN
         IF (NOT(Inventory_Pick_List_API.Shipment_Is_Fully_Reported(shipment_id_))) THEN
            unreported_pick_lists_exist_ := 'TRUE';
         END IF;
      ELSE   
         unreported_pick_lists_exist_ := Shipment_Source_Utility_API.Unreported_Pick_Lists_Exist(shipment_id_); 
      END IF;
      IF (unreported_pick_lists_exist_ = 'TRUE') THEN
         EXIT;
      END IF;    
   END LOOP; 
   RETURN NVL(unreported_pick_lists_exist_, 'FALSE');
END Unreported_Pick_Lists_Exist;


@UncheckedAccess
FUNCTION Get_Pick_Lists_For_Shipment (
   shipment_id_         IN NUMBER,
   printed_flag_        IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 ) RETURN VARCHAR2
IS    
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
   inv_pick_list_printed_db_ VARCHAR2(5);
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            RETURN Pick_Customer_Order_API.Get_Pick_Lists_For_Shipment(shipment_id_, printed_flag_);             
         $ELSE
            NULL; 
         $END
      ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN  
         IF (printed_flag_ = 'N') THEN
            inv_pick_list_printed_db_ := Fnd_Boolean_API.DB_FALSE;
         ELSIF (printed_flag_ = 'Y') THEN
            inv_pick_list_printed_db_ := Fnd_Boolean_API.DB_TRUE;
         END IF;   
         RETURN Inventory_Pick_List_API.Get_Pick_Lists_For_Shipment(shipment_id_, inv_pick_list_printed_db_, Fnd_Boolean_API.DB_FALSE);         
      END IF;             
   END LOOP;
   RETURN NULL;
END Get_Pick_Lists_For_Shipment;


-- This method returns the sum of QtyPicked (or NULL if there's multiple part_no's) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Qty_Picked_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN NUMBER 
IS
   CURSOR get_qty_picked_hu IS 
      SELECT SUM(qty_picked) qty_picked
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                   FROM handling_unit_tab hu
                                CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                  START WITH     hu.handling_unit_id = handling_unit_id_)
       GROUP BY part_no;
       
   CURSOR get_qty_picked_loc IS
      SELECT SUM(psr.qty_picked) qty_picked
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE psr.pick_list_no = pick_list_no_
         AND psr.contract     = contract_
         AND psr.location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id)
       GROUP BY part_no;

   TYPE Qty_Picked_Tab IS TABLE OF get_qty_picked_hu%ROWTYPE;
   qty_picked_tab_   Qty_Picked_Tab;
   qty_picked_       NUMBER;
BEGIN
   IF (handling_unit_id_ != 0) THEN
      OPEN get_qty_picked_hu;
      FETCH get_qty_picked_hu BULK COLLECT INTO qty_picked_tab_;
      CLOSE get_qty_picked_hu;
   ELSE
      OPEN get_qty_picked_loc;
      FETCH get_qty_picked_loc BULK COLLECT INTO qty_picked_tab_;
      CLOSE get_qty_picked_loc;
   END IF;
   
   IF (qty_picked_tab_.COUNT = 1) THEN
      qty_picked_ := qty_picked_tab_(1).qty_picked;
   END IF;
   
   RETURN qty_picked_;
END Get_Qty_Picked_HU;


-- This method returns a unique ShipmentId (or NULL if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Shipment_Id_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_shipment_id_hu IS
      SELECT DISTINCT shipment_id
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
                                   
   CURSOR get_shipment_id_loc IS
      SELECT DISTINCT shipment_id
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                                   
   TYPE Shipment_Id_Tab IS TABLE OF get_shipment_id_hu%ROWTYPE;
   shipment_id_tab_  Shipment_Id_Tab;
   shipment_id_      NUMBER;
BEGIN
   IF (handling_unit_id_ != 0) THEN
      OPEN get_shipment_id_hu;
      FETCH get_shipment_id_hu BULK COLLECT INTO shipment_id_tab_;
      CLOSE get_shipment_id_hu;
   ELSE
      OPEN get_shipment_id_loc;
      FETCH get_shipment_id_loc BULK COLLECT INTO shipment_id_tab_;
      CLOSE get_shipment_id_loc;
   END IF;
   
   IF (shipment_id_tab_.COUNT = 1) THEN
      shipment_id_ := shipment_id_tab_(1).shipment_id;
   END IF;
   
   RETURN shipment_id_;
END Get_Shipment_Id_HU;


-- This method returns a unique SourceRef1 (or '...' if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Source_Ref1_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_source_ref1_hu IS
      SELECT DISTINCT source_ref1
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
                                   
   CURSOR get_source_ref1_loc IS
      SELECT DISTINCT source_ref1
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                                   
   TYPE Source_Ref1_Tab IS TABLE OF get_source_ref1_hu%ROWTYPE;
   source_ref1_tab_  Source_Ref1_Tab;
   source_ref1_      VARCHAR2(50);
BEGIN
   IF (handling_unit_id_ != 0) THEN
      OPEN get_source_ref1_hu;
      FETCH get_source_ref1_hu BULK COLLECT INTO source_ref1_tab_;
      CLOSE get_source_ref1_hu;
   ELSE
      OPEN get_source_ref1_loc;
      FETCH get_source_ref1_loc BULK COLLECT INTO source_ref1_tab_;
      CLOSE get_source_ref1_loc;
   END IF;

   IF (source_ref1_tab_.COUNT = 1) THEN
      source_ref1_ := source_ref1_tab_(1).source_ref1;
   ELSIF (source_ref1_tab_.COUNT > 1) THEN
      source_ref1_ := '...';
   END IF;
   
   RETURN source_ref1_;
END Get_Source_Ref1_HU;


-- This method returns a unique SourceRef2 (or '...' if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Source_Ref2_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_source_ref2_hu IS
      SELECT DISTINCT source_ref2
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
   CURSOR get_source_ref2_loc IS
      SELECT DISTINCT source_ref2
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                             
   TYPE Source_Ref2_Tab IS TABLE OF get_source_ref2_hu%ROWTYPE;
   source_ref2_tab_  Source_Ref2_Tab;
   source_ref2_      VARCHAR2(50);
BEGIN
   IF (handling_unit_id_ != 0) THEN
      OPEN get_source_ref2_hu;
      FETCH get_source_ref2_hu BULK COLLECT INTO source_ref2_tab_;
      CLOSE get_source_ref2_hu;
   ELSE
      OPEN get_source_ref2_loc;
      FETCH get_source_ref2_loc BULK COLLECT INTO source_ref2_tab_;
      CLOSE get_source_ref2_loc;
   END IF;
   
   IF (source_ref2_tab_.COUNT = 1) THEN
      source_ref2_ := source_ref2_tab_(1).source_ref2;
   ELSIF (source_ref2_tab_.COUNT > 1) THEN
      source_ref2_ := '...';
   END IF;
   
   RETURN source_ref2_;
END Get_Source_Ref2_HU;


-- This method returns a unique SourceRef3 (or '...' if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Source_Ref3_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_source_ref3_hu IS
      SELECT DISTINCT source_ref3
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
   
     CURSOR get_source_ref3_loc IS
      SELECT DISTINCT source_ref3
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                        
   TYPE Source_Ref3_Tab IS TABLE OF get_source_ref3_hu%ROWTYPE;
   source_ref3_tab_  Source_Ref3_Tab;
   source_ref3_      VARCHAR2(50);
  BEGIN
   IF (handling_unit_id_ != 0) THEN
      OPEN get_source_ref3_hu;
      FETCH get_source_ref3_hu BULK COLLECT INTO source_ref3_tab_;
      CLOSE get_source_ref3_hu;
   ELSE
      OPEN get_source_ref3_loc;
      FETCH get_source_ref3_loc BULK COLLECT INTO source_ref3_tab_;
      CLOSE get_source_ref3_loc;
   END IF;
   
   IF (source_ref3_tab_.COUNT = 1) THEN
      source_ref3_ := source_ref3_tab_(1).source_ref3;
   ELSIF (source_ref3_tab_.COUNT > 1) THEN
      source_ref3_ := '...';
   END IF;
   
   RETURN source_ref3_;
END Get_Source_Ref3_HU;


-- This method returns a unique SourceRef4 (or '...' if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Source_Ref4_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_source_ref4_hu IS
      SELECT DISTINCT source_ref4
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
                                   
     CURSOR get_source_ref4_loc IS
      SELECT DISTINCT source_ref4
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                                   
   TYPE Source_Ref4_Tab IS TABLE OF get_source_ref4_hu%ROWTYPE;
   source_ref4_tab_  Source_Ref4_Tab;
   source_ref4_      VARCHAR2(50);
BEGIN
   IF (handling_unit_id_ != 0) THEN  
      OPEN get_source_ref4_hu;
      FETCH get_source_ref4_hu BULK COLLECT INTO source_ref4_tab_;
      CLOSE get_source_ref4_hu;
   ELSE
      OPEN get_source_ref4_loc;
      FETCH get_source_ref4_loc BULK COLLECT INTO source_ref4_tab_;
      CLOSE get_source_ref4_loc;
   END IF;
   
   IF (source_ref4_tab_.COUNT = 1) THEN
      source_ref4_ := source_ref4_tab_(1).source_ref4;
   ELSIF (source_ref4_tab_.COUNT > 1) THEN
      source_ref4_ := '...';
   END IF;
   
   RETURN source_ref4_;
END Get_Source_Ref4_HU;

-- This method returns a unique SourceRefType (or '...' if there's a mix of values) for reservations in a Handling Unit on the pick list. 
-- If handling_unit_id = 0 it will instead return the same thing for the reservations on a specific location where 
-- the reservations are either not in a HU or where their HU is not fully on the pick list.
@UncheckedAccess
FUNCTION Get_Source_Ref_Type_HU (
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   pick_list_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_source_ref_type_hu IS
      SELECT DISTINCT source_ref_type
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
                                   
     CURSOR get_source_ref_type_loc IS
      SELECT DISTINCT source_ref_type
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                                   
   TYPE Source_Ref_Type_Tab IS TABLE OF get_source_ref_type_hu%ROWTYPE;
   source_ref_type_tab_  Source_Ref_type_Tab;
   source_ref_type_      VARCHAR2(50);
BEGIN
   IF (handling_unit_id_ != 0) THEN  
      OPEN get_source_ref_type_hu;
      FETCH get_source_ref_type_hu BULK COLLECT INTO source_ref_type_tab_;
      CLOSE get_source_ref_type_hu;
   ELSE
      OPEN get_source_ref_type_loc;
      FETCH get_source_ref_type_loc BULK COLLECT INTO source_ref_type_tab_;
      CLOSE get_source_ref_type_loc;
   END IF;
   
   IF (source_ref_type_tab_.COUNT = 1) THEN
      source_ref_type_ := source_ref_type_tab_(1).source_ref_type;
   ELSIF (source_ref_type_tab_.COUNT > 1) THEN
      source_ref_type_ := '...';
   END IF;
   
   RETURN source_ref_type_;
END Get_Source_Ref_Type_HU;

@UncheckedAccess
FUNCTION Check_Src_Demand_Code_Exist_HU (
   handling_unit_id_          IN NUMBER,
   contract_                  IN VARCHAR2,
   location_no_               IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   source_ref_demand_code_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_src_demand_code_exist_hu IS
      SELECT 1
        FROM PICK_SHIPMENT_RESERVATION
       WHERE pick_list_no       = pick_list_no_
         AND source_ref_type_db = source_ref_type_db_
         AND (source_ref_demand_code_db_ IS NOT NULL AND source_ref_demand_code_db = source_ref_demand_code_db_)
         AND handling_unit_id IN (SELECT hu.handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
                                   
     CURSOR get_src_demand_code_exist_loc IS
      SELECT 1
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no       = pick_list_no_
         AND contract           = contract_
         AND location_no        = location_no_
         AND source_ref_type_db = source_ref_type_db_
         AND (source_ref_demand_code_db_ IS NOT NULL AND source_ref_demand_code_db = source_ref_demand_code_db_)
         AND EXISTS (SELECT 1
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);
                                   
   demand_code_exist_hu_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   dummy_                 NUMBER;
BEGIN
   IF (handling_unit_id_ = 0) THEN  
      OPEN get_src_demand_code_exist_loc;
      FETCH get_src_demand_code_exist_loc INTO dummy_;
      IF (get_src_demand_code_exist_loc%FOUND) THEN
         demand_code_exist_hu_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
      CLOSE get_src_demand_code_exist_loc;
   ELSE
     OPEN get_src_demand_code_exist_hu;
      FETCH get_src_demand_code_exist_hu INTO dummy_;
      IF (get_src_demand_code_exist_hu%FOUND) THEN
         demand_code_exist_hu_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
      CLOSE get_src_demand_code_exist_hu;
   END IF;
   RETURN demand_code_exist_hu_;
END Check_Src_Demand_Code_Exist_HU;


@UncheckedAccess
FUNCTION Get_Pick_List_Type(
   pick_list_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   pick_list_type_ Pick_Report_Pick_List.pick_list_type%TYPE;
   CURSOR get_pick_list_type_ IS
      SELECT pick_list_type
        FROM Pick_Report_Pick_List
       WHERE pick_list_no = pick_list_no_;
BEGIN
   OPEN get_pick_list_type_;
   FETCH get_pick_list_type_ INTO pick_list_type_;
   CLOSE get_pick_list_type_;
      
   RETURN pick_list_type_;
END Get_Pick_List_Type;

@UncheckedAccess
FUNCTION Validate_Shipment_Pick_Lists(
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   result_ VARCHAR2(5) := 'TRUE';
   
   CURSOR get_shipment_pick_lists IS
      SELECT pick_list_no, ship_inventory_location_no
      FROM   Pick_Report_Pick_List
      WHERE  shipment_id = shipment_id_;
   
BEGIN
   FOR rec_ IN get_shipment_pick_lists LOOP
      IF(rec_.ship_inventory_location_no IS NULL) THEN
         result_ := 'FALSE';
         Trace_SYS.Message('Shipment Pick List: ' || rec_.pick_list_no || ' did not have a shipment inventory location specified.');
         EXIT;
      END IF;
   END LOOP;
   RETURN result_;
END Validate_Shipment_Pick_Lists;

@UncheckedAccess
PROCEDURE Get_Ship_Inv_Loc_And_Confirm__(
   ship_inv_location_         OUT VARCHAR2,
   confirm_ship_inv_location_ OUT NUMBER,
   attr_                      IN  VARCHAR2,
   contract_                  IN  VARCHAR2)
IS
   ptr_                       NUMBER := NULL;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   pick_list_no_              VARCHAR2(20);
   pick_list_type_            Pick_Report_Pick_List.pick_list_type%TYPE;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF(name_ = 'PICK_LIST_NO')THEN
         pick_list_no_ := value_;
         Trace_SYS.Message('Pick_list_no found! ' || pick_list_no_);
      ELSIF(name_ = 'PICK_LIST_TYPE') THEN
         pick_list_type_ := value_;
         Trace_SYS.Message('PICK_LIST_TYPE found! ' || pick_list_type_);

         
         ship_inv_location_         := Pick_Shipment_API.Get_Ship_Inventory_Location_No(pick_list_no_, pick_list_type_);         
         confirm_ship_inv_location_ := Pick_Shipment_API.Confirm_Shipment_Location_No__(pick_list_no_, pick_list_type_);
         
         IF(ship_inv_location_ IS NULL)THEN
            confirm_ship_inv_location_ := 1;
            Trace_SYS.Put_Line('Pick List No :P1 did not have a shipment inv location, needs to be confirmed.', pick_list_no_);
         END IF;
         EXIT WHEN confirm_ship_inv_location_ = 1;
      END IF;
   END LOOP;
END Get_Ship_Inv_Loc_And_Confirm__;

PROCEDURE Post_Pick_Report_Shipment (
   shipment_id_                IN NUMBER,
   pick_list_no_               IN VARCHAR2,
   use_generic_reservation_    IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2,
   trigger_shipment_flow_      IN BOOLEAN )
IS
   ship_default_location_no_ VARCHAR2(35);
BEGIN
   -- This method is only called when using generic reservation and picking logic in inventory.
   IF (use_generic_reservation_ = 'TRUE') THEN   
      Inventory_Pick_List_API.Modify_Ship_Inv_Location_No(pick_list_no_, ship_inventory_location_no_); 
   END IF;
   
   ship_default_location_no_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);  
   IF (ship_default_location_no_ IS NULL) THEN
      Shipment_API.Modify_Ship_Inv_Location_No(shipment_id_, ship_inventory_location_no_);
      IF (use_generic_reservation_ = 'TRUE') THEN
         Inventory_Pick_List_API.Modify_Ship_Inv_Loc_Shipment(shipment_id_, ship_inventory_location_no_);
      END IF;    
   END IF; 
   
   Shipment_Handling_Utility_API.Connect_Hus_From_Inventory(shipment_id_);
   
   IF (trigger_shipment_flow_) THEN
      Shipment_Flow_API.Start_Shipment_Flow(shipment_id_, 40);
   END IF;
   
END Post_Pick_Report_Shipment;

FUNCTION Pick_Report_Ship_Handl_Unit__ (
   message_          IN CLOB,
   ship_location_no_ IN VARCHAR2,
   pick_list_no_     IN VARCHAR2,
   shipment_id_      IN NUMBER,
   pick_list_type_   IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
   CURSOR get_pick_list_lines_hu(shipment_handling_unit_id_ NUMBER) IS
      SELECT srhu.source_ref1, srhu.source_ref2, srhu.source_ref3, srhu.source_ref4,  srhu.contract, srhu.part_no,
             srhu.location_no, srhu.lot_batch_no, srhu.serial_no, srhu.eng_chg_level, srhu.waiv_dev_rej_no, srhu.activity_seq,
             srhu.reserv_handling_unit_id, srhu.configuration_id, srhu.pick_list_no, srhu.shipment_id, sol.source_ref_type, 
             srhu.handling_unit_id, SUM(srhu.quantity) qty_to_pick
        FROM shipment_reserv_handl_unit_tab srhu, shipment_line_tab sol
       WHERE handling_unit_id              = shipment_handling_unit_id_
         AND srhu.shipment_id              = sol.shipment_id
         AND srhu.shipment_line_no         = sol.shipment_line_no
         AND srhu.reserv_handling_unit_id != srhu.handling_unit_id
         AND srhu.pick_list_no             = pick_list_no_
      GROUP BY srhu.source_ref1, srhu.source_ref2, srhu.source_ref3, srhu.source_ref4,  srhu.contract, srhu.part_no,
               srhu.location_no, srhu.lot_batch_no, srhu.serial_no, srhu.eng_chg_level, srhu.waiv_dev_rej_no, srhu.activity_seq,
               srhu.reserv_handling_unit_id, srhu.configuration_id, srhu.pick_list_no, srhu.shipment_id, sol.source_ref_type, srhu.handling_unit_id;
               
   TYPE Pick_List_Lines_Tab IS TABLE OF get_pick_list_lines_hu%ROWTYPE INDEX BY PLS_INTEGER;
   pick_list_lines_tab_         Pick_List_Lines_Tab;
   
   attr_                        VARCHAR2(32000);
   count_                       NUMBER;
   name_arr_                    Message_SYS.name_table;
   value_arr_                   Message_SYS.line_table;
   last_line_                   BOOLEAN := FALSE;
   clob_out_data_               CLOB;
   info_                        VARCHAR2(2000);
   all_reported_                NUMBER;
   closed_lines_                NUMBER;
   overpicked_lines_            VARCHAR2(5);
   local_session_id_            NUMBER;
   shipment_id_message_         VARCHAR2(32000);
   handling_units_to_pick_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
   aggregated_line_msg_         CLOB;
   local_pick_list_type_        VARCHAR2(20);
   trigger_pick_reporting_      BOOLEAN := FALSE;
BEGIN
   IF (pick_list_type_ IS NULL) THEN
      local_pick_list_type_ := Pick_Shipment_API.Get_Pick_List_Type(pick_list_no_);
   ELSE
      local_pick_list_type_ := pick_list_type_;
   END IF;   
   
   -- calling Validations
   
   IF (local_pick_list_type_ = 'INVENTORY_PICK_LIST') THEN
      aggregated_line_msg_ := Message_SYS.Construct_Clob_Message('AGGREGATED_LINE');
   END IF;
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1 .. count_ LOOP
      IF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_units_to_pick_tab_(handling_units_to_pick_tab_.COUNT + 1).handling_unit_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LAST_LINE') THEN
         last_line_ := TRUE;
      END IF;
   END LOOP;
   
   IF (handling_units_to_pick_tab_.COUNT > 0) THEN
      FOR i IN handling_units_to_pick_tab_.FIRST .. handling_units_to_pick_tab_.LAST LOOP
         
         IF (Can_Pick_Shipment_Hu(handling_units_to_pick_tab_(i).handling_unit_id, shipment_id_) = 'TRUE') THEN            
            IF (ship_location_no_ IS NOT NULL) THEN
               Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_        => handling_units_to_pick_tab_(i).handling_unit_id, 
                                                                parent_handling_unit_id_ => NULL);
            END IF;
            
            OPEN get_pick_list_lines_hu(handling_units_to_pick_tab_(i).handling_unit_id);
            FETCH get_pick_list_lines_hu BULK COLLECT INTO pick_list_lines_tab_;
            CLOSE get_pick_list_lines_hu;
            
            IF (pick_list_lines_tab_.COUNT > 0) THEN
               FOR j IN pick_list_lines_tab_.FIRST .. pick_list_lines_tab_.LAST LOOP
                  IF (local_pick_list_type_ = 'CUST_ORDER_PICK_LIST') THEN
                     
                     Client_SYS.Clear_Attr(attr_);
                     Client_SYS.Add_To_Attr('PICK_LIST_NO',          pick_list_no_,                                                     attr_);
                     Client_SYS.Add_To_Attr('ORDER_NO',              pick_list_lines_tab_(j).source_ref1,                               attr_);
                     Client_SYS.Add_To_Attr('LINE_NO',               pick_list_lines_tab_(j).source_ref2,                               attr_);
                     Client_SYS.Add_To_Attr('REL_NO',                pick_list_lines_tab_(j).source_ref3,                               attr_);
                     Client_SYS.Add_To_Attr('LINE_ITEM_NO',          Utility_SYS.String_To_Number(pick_list_lines_tab_(j).source_ref4), attr_);
                     Client_SYS.Add_To_Attr('CONTRACT',              pick_list_lines_tab_(j).contract,                                  attr_);
                     Client_SYS.Add_To_Attr('PART_NO',               pick_list_lines_tab_(j).part_no,                                   attr_);
                     Client_SYS.Add_To_Attr('CONFIGURATION_ID',      pick_list_lines_tab_(j).configuration_id,                          attr_);
                     Client_SYS.Add_To_Attr('LOCATION_NO',           pick_list_lines_tab_(j).location_no,                               attr_);
                     Client_SYS.Add_To_Attr('LOT_BATCH_NO',          pick_list_lines_tab_(j).lot_batch_no,                              attr_);
                     Client_SYS.Add_To_Attr('SERIAL_NO',             pick_list_lines_tab_(j).serial_no,                                 attr_);
                     Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',         pick_list_lines_tab_(j).eng_chg_level,                             attr_);
                     Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',       pick_list_lines_tab_(j).waiv_dev_rej_no,                           attr_);
                     Client_SYS.Add_To_Attr('ACTIVITY_SEQ',          pick_list_lines_tab_(j).activity_seq,                              attr_);
                     Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',      pick_list_lines_tab_(j).reserv_handling_unit_id,                   attr_);         
                     Client_SYS.Add_To_Attr('SHIPMENT_ID',           pick_list_lines_tab_(j).shipment_id,                               attr_);
                     Client_SYS.Add_To_Attr('SHIP_HANDLING_UNIT_ID', pick_list_lines_tab_(j).handling_unit_id,                          attr_);
                     Client_SYS.Add_To_Attr('QTY_TO_PICK',           pick_list_lines_tab_(j).qty_to_pick ,                              attr_); 
                     
                     -- Only pass LAST_LINE if this is the last reservation in the last Handling Unit to pick.
                     IF ((j = pick_list_lines_tab_.LAST) AND (i = handling_units_to_pick_tab_.LAST) AND last_line_) THEN 
                        Client_SYS.Add_To_Attr('LAST_LINE', 'TRUE', attr_);
                        trigger_pick_reporting_ := TRUE;
                     END IF;
                     
                     $IF Component_Order_SYS.INSTALLED $THEN
                        Pick_Customer_Order_API.Pick_Reservations__(info_                        => info_,
                                                                    all_reported_                => all_reported_,
                                                                    closed_lines_                => closed_lines_,
                                                                    overpicked_lines_            => overpicked_lines_,
                                                                    session_id_                  => local_session_id_,
                                                                    shipment_id_message_         => shipment_id_message_,
                                                                    attr_                        => attr_,
                                                                    pick_list_no_                => pick_list_no_,
                                                                    ship_location_no_            => ship_location_no_,
                                                                    trigger_shipment_flow_       => 'TRUE',
                                                                    validate_hu_struct_position_ => FALSE,
                                                                    add_hu_to_shipment_          => FALSE ); 
                     $END 
                     
                     IF trigger_pick_reporting_ THEN 
                        clob_out_data_ := Message_SYS.Construct('');
                        Message_SYS.Add_Attribute(clob_out_data_, 'ALL_REPORTED',     all_reported_);
                        Message_SYS.Add_Attribute(clob_out_data_, 'CLOSED_LINES',     closed_lines_);
                        Message_SYS.Add_Attribute(clob_out_data_, 'OVERPICKED_LINES', overpicked_lines_);
                        Message_SYS.Add_Attribute(clob_out_data_, 'SESSION_ID',       local_session_id_);
                        IF (info_ IS NOT NULL) THEN
                           Message_SYS.Add_Attribute(clob_out_data_, 'INFO', info_);
                        END IF;
                     END IF;
                     
                  ELSIF (local_pick_list_type_ = 'INVENTORY_PICK_LIST') THEN
                     
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONTRACT',              pick_list_lines_tab_(j).contract);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'PART_NO',               pick_list_lines_tab_(j).part_no);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONFIGURATION_ID',      pick_list_lines_tab_(j).configuration_id);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOCATION_NO',           pick_list_lines_tab_(j).location_no);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOT_BATCH_NO',          pick_list_lines_tab_(j).lot_batch_no);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SERIAL_NO',             pick_list_lines_tab_(j).serial_no);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'ENG_CHG_LEVEL',         pick_list_lines_tab_(j).eng_chg_level);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'WAIV_DEV_REJ_NO',       pick_list_lines_tab_(j).waiv_dev_rej_no);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'ACTIVITY_SEQ',          pick_list_lines_tab_(j).activity_seq);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'HANDLING_UNIT_ID',      pick_list_lines_tab_(j).reserv_handling_unit_id);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF1',           pick_list_lines_tab_(j).source_ref1);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF2',           pick_list_lines_tab_(j).source_ref2);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF3',           pick_list_lines_tab_(j).source_ref3);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF4',           pick_list_lines_tab_(j).source_ref4);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF_TYPE_DB',    pick_list_lines_tab_(j).source_ref_type);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'QTY_PICKED',            pick_list_lines_tab_(j).qty_to_pick);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'SHIP_HANDLING_UNIT_ID', pick_list_lines_tab_(j).handling_unit_id);
                     Message_SYS.Add_Attribute(aggregated_line_msg_, 'PACK_COMPLETE',         'TRUE');
                     
                     IF (handling_units_to_pick_tab_.LAST = i AND pick_list_lines_tab_.LAST = j) THEN 
                        -- Only call Pick_Inv_Part_Reservations when passing the last handling unit 
                        clob_out_data_ := Inventory_Part_Reservation_API.Pick_Inv_Part_Reservations(message_                      => aggregated_line_msg_,
                                                                                                    pick_list_no_                 => to_number(pick_list_no_),
                                                                                                    report_from_pick_list_header_ => 'FALSE',
                                                                                                    ship_inventory_location_no_   => ship_location_no_,
                                                                                                    validate_hu_struct_position_  => FALSE,
                                                                                                    add_hu_to_shipment_           => FALSE);
                     END IF;
                  END IF;      
               END LOOP;   
            END IF;
         ELSE
            Error_SYS.Record_General(lu_name_, 'CANTPICKREPORTSHIPHU: Shipment Handling Unit :P1 cannot be pick reported.', handling_units_to_pick_tab_(i).handling_unit_id);
         END IF; 
      END LOOP;
   END IF;
   RETURN clob_out_data_;
END Pick_Report_Ship_Handl_Unit__;


@UncheckedAccess
FUNCTION Is_Fully_Picked (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   location_no_      IN VARCHAR2 ) RETURN VARCHAR2 
IS
   is_fully_picked_ VARCHAR2(5) := 'TRUE';
   dummy_                NUMBER;
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;   

   CURSOR not_picked_hu_exist (local_handling_unit_id_ IN NUMBER) IS
      SELECT 1
      FROM   PICK_SHIPMENT_RESERVATION
      WHERE  pick_list_no = pick_list_no_
      AND    handling_unit_id = local_handling_unit_id_
      AND    qty_reserved > qty_picked;  
                                  
   CURSOR get_quantities IS
      SELECT qty_reserved, qty_picked
        FROM PICK_SHIPMENT_RESERVATION psr
       WHERE pick_list_no = pick_list_no_
         AND location_no  = location_no_
         AND EXISTS (SELECT *
                       FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                      WHERE ipss.source_ref1        = psr.pick_list_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id
                        AND ipss.location_no        = psr.location_no
                        AND ipss.source_ref_type_db = Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
BEGIN
   -- Check lines that attached to a handling unit
   IF (handling_unit_id_ IS NOT NULL) THEN
      handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR i_ IN handling_unit_id_tab_.first..handling_unit_id_tab_.last LOOP
            OPEN not_picked_hu_exist(handling_unit_id_tab_(i_).handling_unit_id);
            FETCH not_picked_hu_exist INTO dummy_;
            -- If any of the handling units has qty to pick return false
            IF (not_picked_hu_exist%FOUND) THEN
               is_fully_picked_ := 'FALSE';
               CLOSE not_picked_hu_exist;
               EXIT;
            END IF;
            CLOSE not_picked_hu_exist;
         END LOOP;
      END IF;
   ELSE
      -- Check lines that are not attached to a handling unit or should be picked out of a handling unit
      FOR rec_ IN get_quantities LOOP 
         IF (rec_.qty_reserved > rec_.qty_picked) THEN
            is_fully_picked_ := 'FALSE';
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
	RETURN is_fully_picked_;
END Is_Fully_Picked;


@UncheckedAccess
FUNCTION Keep_Remaining_Reservation (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   keep_remaining_reservation_ VARCHAR2(5):= 'FALSE';  
BEGIN
   IF (Shipment_Type_API.Get_Allow_Partial_Picking_Db(Shipment_API.Get_Shipment_Type(shipment_id_)) = 'TRUE') THEN
      keep_remaining_reservation_ := 'TRUE';
   END IF;   
   RETURN keep_remaining_reservation_;
END Keep_Remaining_Reservation;

-- Print_Pick_List
--   This method is called when printing the Semi-Centralized pick list report from Shipments overview window.
PROCEDURE Print_Pick_List (
   shipment_id_ IN NUMBER )
IS  
   pick_list_no_list_     VARCHAR2(32000); 
   pick_list_no_list_tab_ Utility_SYS.STRING_TABLE;
   pick_list_count_       NUMBER;   
  
BEGIN   
   pick_list_no_list_ := Inventory_Pick_List_API.Get_Pick_Lists_For_Shipment(shipment_id_, Fnd_Boolean_API.DB_FALSE, Fnd_Boolean_API.DB_FALSE);
   IF (pick_list_no_list_ IS NOT NULL) THEN
      Utility_SYS.Tokenize(pick_list_no_list_, Client_SYS.field_separator_, pick_list_no_list_tab_, pick_list_count_);       
   END IF; 
   
   FOR i_ IN 1..pick_list_no_list_tab_.COUNT LOOP
      Print_Pick_List___(pick_list_no_list_tab_(i_));      
   END LOOP;   
   
END Print_Pick_List;


PROCEDURE Modify_Reserv_Hu_Pick_List_No (
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,  
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   reserv_handling_unit_id_     IN NUMBER,
   configuration_id_            IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   new_pick_list_no_            IN VARCHAR2,
   inv_part_res_source_type_db_ IN VARCHAR2)
IS
   shipment_line_no_         NUMBER;
   local_source_ref_type_db_ VARCHAR2(20);
BEGIN
   IF (inv_part_res_source_type_db_ IS NULL) THEN
      local_source_ref_type_db_ := source_ref_type_db_;
   ELSE
      local_source_ref_type_db_ := Reserve_Shipment_API.Get_Logistic_Source_Type_Db(inv_part_res_source_type_db_);
   END IF;
   
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, local_source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, local_source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, local_source_ref_type_db_, 4), local_source_ref_type_db_);
                                                                       
   Shipment_Reserv_Handl_Unit_API.Modify_Pick_List_No(source_ref1_             => source_ref1_,
                                                      source_ref2_             => source_ref2_,
                                                      source_ref3_             => source_ref3_,
                                                      source_ref4_             => source_ref4_,
                                                      contract_                => contract_,
                                                      part_no_                 => part_no_,
                                                      location_no_             => location_no_,
                                                      lot_batch_no_            => lot_batch_no_,
                                                      serial_no_               => serial_no_,
                                                      eng_chg_level_           => eng_chg_level_,
                                                      waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                      activity_seq_            => activity_seq_,
                                                      reserv_handling_unit_id_ => reserv_handling_unit_id_,
                                                      configuration_id_        => configuration_id_,
                                                      pick_list_no_            => pick_list_no_,
                                                      shipment_id_             => shipment_id_,
                                                      shipment_line_no_        => shipment_line_no_,
                                                      new_pick_list_no_        => new_pick_list_no_);                                                                    
                                                                       
END Modify_Reserv_Hu_Pick_List_No;


PROCEDURE Validate_Pick_List_Status (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS 
BEGIN   
   IF (Reserve_Shipment_API.Unreported_Pick_List_Exists(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CONSPICKCRE: Removal of the line is not allowed when the consolidated pick list is created.');
   END IF;
END Validate_Pick_List_Status;


PROCEDURE Validate_Unreserve_Pick (
   source_ref_type_db_         IN VARCHAR2,
   source_ref_demand_code_     IN VARCHAR2,
   qty_to_reserve_             IN NUMBER,
   qty_picked_                 IN NUMBER,
   keep_remaining_reservation_ IN BOOLEAN)
IS 
BEGIN   
   IF ((source_ref_type_db_ = Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN) OR
       ((source_ref_type_db_ = Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER) AND 
        (NVL(source_ref_demand_code_, string_null_) = Order_Supply_Type_API.DB_PURCHASE_RECEIPT))) THEN  
      IF (qty_picked_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'ZEROPICKINGFORPRR: Unreserve is not allowed for :P1 or :P2 with demand code :P3.', Inv_Part_Res_Source_Type_API.Decode(Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN), Inv_Part_Res_Source_Type_API.Decode(Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER), Order_Supply_Type_API.Decode(Order_Supply_Type_API.DB_PURCHASE_RECEIPT));
      END IF;
      IF ((qty_to_reserve_ < 0) AND (NOT keep_remaining_reservation_)) THEN
         Error_SYS.Record_General(lu_name_, 'PARTIALPICKINGFORPRR: Partial picking that unreserves the remaining quantity is not allowed for :P1 or :P2 with demand code :P3.', Inv_Part_Res_Source_Type_API.Decode(Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN), Inv_Part_Res_Source_Type_API.Decode(Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER), Order_Supply_Type_API.Decode(Order_Supply_Type_API.DB_PURCHASE_RECEIPT));
      END IF;
   END IF;
END Validate_Unreserve_Pick;


-- Used for checking the source line when connecting to a shipment. 
-- Any picked reservations on a pick list should be picked to shipment inventory,
-- as shipment inventory is mandatory for shipments.
PROCEDURE Check_Res_Picked_To_Ship_Loc(
   source_ref1_        VARCHAR2,
   source_ref2_        VARCHAR2,
   source_ref3_        VARCHAR2,
   source_ref4_        VARCHAR2,
   source_ref_type_db_ VARCHAR2)
IS
   dummy_      NUMBER;
   CURSOR reserv_on_pick_list_exist IS
   SELECT 1
     FROM Shipment_Source_Reservation
      WHERE qty_assigned  > 0
      AND   source_ref1          = source_ref1_
      AND   source_ref2          = source_ref2_
      AND   source_ref3          = source_ref3_
      AND   source_ref4          = source_ref4_
      AND   source_ref_type_db   = source_ref_type_db_
      AND   pick_list_no        != '*'
      AND   qty_picked           > 0 
      AND   Inventory_Location_API.Get_Location_Type_Db(contract, location_no) != 'SHIPMENT';

BEGIN
   -- Not allowed to connect reserved qty that is not in shipment inventory or will not be picked to shipment inventory
   dummy_ := NULL;
   
   OPEN reserv_on_pick_list_exist;
   FETCH reserv_on_pick_list_exist INTO dummy_;
   CLOSE reserv_on_pick_list_exist;
   
   IF dummy_ IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'SHIPINVCONNECT: Cannot connect as quantity attached to the Source Line :P1, :P2, :P3 is not picked to Shipment Inventory.', source_ref1_, source_ref2_, source_ref3_);
   END IF;
END Check_Res_Picked_To_Ship_Loc;


-- Use_Report_Pick_List_Lines 
--    Use this method to check if it is mandatory to use the window
--    Report Picking of Pick List Lines for pick reporting.

@UncheckedAccess
FUNCTION Use_Report_Pick_List_Lines (
   shipment_id_        IN NUMBER,
   pick_list_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_catalog_rec_            Part_Catalog_API.Public_Rec;
   catch_qty_onhand_            NUMBER;
   number_null_                 NUMBER := -99999999999;  
   use_report_pick_list_lines_  VARCHAR2(5):= 'FALSE';
   CURSOR get_lines IS
      SELECT contract,          part_no,          configuration_id,
             location_no,       lot_batch_no,     serial_no,
             eng_chg_level,     waiv_dev_rej_no,  activity_seq,
             catch_qty_to_pick, handling_unit_id, source_ref1,
             source_ref2,       source_ref3,      source_ref4,
             source_ref_type_db
        FROM pick_shipment_reservation
       WHERE (shipment_id  = shipment_id_ OR pick_list_no = pick_list_no_) 
         AND qty_reserved > qty_picked
       ORDER BY part_no;
BEGIN
   -- Note: This method is specific to semi-centralize picking logic and clients
   FOR linerec_ IN get_lines LOOP
      part_catalog_rec_    := Part_Catalog_API.Get(linerec_.part_no);
      
      IF (part_catalog_rec_.catch_unit_enabled = Fnd_Boolean_API.DB_TRUE ) THEN
         IF (linerec_.source_ref_type_db IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN
            catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand(contract_         => linerec_.contract, 
                                                                                      part_no_          => linerec_.part_no, 
                                                                                      configuration_id_ => linerec_.configuration_id,
                                                                                      location_no_      => linerec_.location_no, 
                                                                                      lot_batch_no_     => linerec_.lot_batch_no, 
                                                                                      serial_no_        => linerec_.serial_no,
                                                                                      eng_chg_level_    => linerec_.eng_chg_level, 
                                                                                      waiv_dev_rej_no_  => linerec_.waiv_dev_rej_no, 
                                                                                      activity_seq_     => linerec_.activity_seq,
                                                                                      handling_unit_id_ => linerec_.handling_unit_id);                                                                                                                                                          
            IF (catch_qty_onhand_ != NVL(linerec_.catch_qty_to_pick, number_null_)) THEN   
               use_report_pick_list_lines_ := 'TRUE';
               EXIT;
            END IF;   
         ELSE
            use_report_pick_list_lines_ := 'TRUE';
            EXIT;
         END IF;  
      END IF;
      
      -- Check the receipt and issue serial tracking flag for serial parts 
      IF ((linerec_.serial_no = '*') AND
          (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE) AND
          (Shipment_Source_Utility_API.Enforce_Report_Pick_From_Lines(source_ref1_                => linerec_.source_ref1,
                                                                      source_ref2_                => linerec_.source_ref2, 
                                                                      source_ref3_                => linerec_.source_ref3,
                                                                      source_ref4_                => linerec_.source_ref4, 
                                                                      source_ref_type_db_         => linerec_.source_ref_type_db,
                                                                      receipt_issue_serial_track_ => 'TRUE')= 'TRUE')) THEN
         use_report_pick_list_lines_ := 'TRUE';
         EXIT;
      END IF;
      
   END LOOP;
   
   RETURN use_report_pick_list_lines_;
END Use_Report_Pick_List_Lines;


@UncheckedAccess
FUNCTION Get_Res_Not_Pick_Listed_Line (
   shipment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   shipment_line_no_   SHIPMENT_LINE_TAB.shipment_line_no%TYPE;
   
   -- this cursor will fetch multiple records, but method will return
   -- single shipment_line_no considering the method usage. 
   CURSOR get_reserved_not_pick_listed IS
      SELECT sl.shipment_line_no
      FROM   shipment_source_reservation ssr, shipment_line_tab sl
      WHERE  ssr.source_ref1        = sl.source_ref1
      AND    ssr.source_ref2        = NVL(sl.source_ref2,'*')
      AND    ssr.source_ref3        = NVL(sl.source_ref3,'*')
      AND    ssr.source_ref4        = NVL(sl.source_ref4,'*')
      AND    ssr.source_ref_type_db = sl.source_ref_type
      AND    ssr.shipment_id        = sl.shipment_id
      AND    sl.shipment_id         = shipment_id_
      AND    ssr.pick_list_no       = '*'
      AND    ssr.qty_assigned       > 0;
BEGIN   
   OPEN  get_reserved_not_pick_listed;
   FETCH get_reserved_not_pick_listed INTO shipment_line_no_;
   CLOSE get_reserved_not_pick_listed;
   RETURN shipment_line_no_;  
END Get_Res_Not_Pick_Listed_Line;

@UncheckedAccess
FUNCTION Get_Pick_List_Printed (
   pick_list_no_          IN VARCHAR2,   
   source_ref_type_db_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   pick_list_printed_    BOOLEAN := FALSE;
BEGIN   
   IF Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_) THEN
      IF (Inventory_Pick_List_API.Get_Printed_Db(pick_list_no_) = Fnd_Boolean_API.DB_TRUE) THEN
         pick_list_printed_ := TRUE;
      END IF;   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN   
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Customer_Order_Pick_List_API.Get_Printed_Flag_Db(pick_list_no_) = 'Y') THEN
            pick_list_printed_ := TRUE;
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   RETURN pick_list_printed_;         
END Get_Pick_List_Printed;

@UncheckedAccess
FUNCTION Serial_Identification_Needed (
   receipt_issue_serial_track_  IN VARCHAR2,   
   serial_no_                   IN VARCHAR2,
   qty_to_pick_                 IN NUMBER ) RETURN VARCHAR2
IS
   serial_dentification_needed_  VARCHAR2(5):= 'FALSE';  
BEGIN   
   IF ((receipt_issue_serial_track_ = 'TRUE') AND (serial_no_ = '*') AND (qty_to_pick_ > 0)) THEN
      serial_dentification_needed_ := 'TRUE';
   END IF;
   RETURN serial_dentification_needed_;         
END Serial_Identification_Needed;

@UncheckedAccess
FUNCTION Check_Unpicked_Pick_List_Exist (
   shipment_id_          IN NUMBER,
   ship_location_        IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2) RETURN VARCHAR2
IS
   unpicked_pick_lists_exist_ VARCHAR2(5) := 'FALSE';
   source_ref_type_list_      Utility_SYS.STRING_TABLE;
   num_sources_               NUMBER;         
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_list_(i_))) THEN
         IF (Inventory_Pick_List_API.Check_Pick_List_Exist(shipment_id_, ship_location_) = 'TRUE') THEN
            unpicked_pick_lists_exist_ := 'TRUE';
         END IF;
      ELSE   
         unpicked_pick_lists_exist_ := Shipment_Source_Utility_API.Check_Pick_List_Exist(shipment_id_, ship_location_, source_ref_type_list_(i_));
      END IF;
      IF (unpicked_pick_lists_exist_ = 'TRUE') THEN
         EXIT;
      END IF;
   END LOOP;   
   RETURN NVL(unpicked_pick_lists_exist_, 'FALSE'); 
END Check_Unpicked_Pick_List_Exist;  


-- This method is used by DataCapturePickHu, DataCaptStartPick
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_             IN VARCHAR2,
   capture_session_id_   IN NUMBER,
   lov_type_db_          IN VARCHAR2,
   sql_where_expression_ IN VARCHAR2 DEFAULT NULL )
IS
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_ NUMBER;
   exit_lov_           BOOLEAN := FALSE;
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_     Get_Lov_Values;
   stmt_               VARCHAR2(4000);
   lov_value_tab_      Lov_Value_Tab;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      stmt_ := 'SELECT DISTINCT pick_list_no 
                FROM  Pick_Report_Pick_List prpl
                WHERE contract      = :contract_
                AND pick_list_type  = ''INVENTORY_PICK_LIST''';                

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY Utility_SYS.String_To_Number(pick_list_no) ASC, pick_list_no ASC';

      @ApproveDynamicStatement(2020-09-08,BUDKLK)
      OPEN get_lov_values_ FOR stmt_ USING contract_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;

   $ELSE
      NULL;   
   $END
END Create_Data_Capture_Lov;

-- This method is used by DataCaptStartPick
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_              IN VARCHAR2,
   pick_list_no_          IN VARCHAR2,
   location_no_           IN VARCHAR2,
   pick_list_no_level_db_ IN VARCHAR2,
   capture_session_id_    IN NUMBER,
   column_name_           IN VARCHAR2,
   lov_type_db_           IN VARCHAR2,
   sql_where_expression_  IN VARCHAR2 DEFAULT NULL)
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_     NUMBER;
   stmt_                   VARCHAR2(6000);
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   lov_value_tab_          Lov_Value_Tab;
   exit_lov_               BOOLEAN := FALSE;
   temp_lov_item_value_    VARCHAR2(200);
   lov_item_description_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      Assert_SYS.Assert_Is_View_Column('START_SHIP_PICK_PROCESS', column_name_);

      stmt_ := 'SELECT ' || column_name_ ||
               ' FROM START_SHIP_PICK_PROCESS sspp
                 WHERE contract  = :contract_ ';
      Generate_Start_Exec_Stmt___(stmt_, pick_list_no_, location_no_, pick_list_no_level_db_, sql_where_expression_);
      -- Add the general route order sorting 
      -- The NVL on handling_unit_id becuase 0 is NULL in this view and we still want non handling units to come before handling units in the start process.
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                    location_no,
                                    NVL(handling_unit_id,0) ';

      @ApproveDynamicStatement(2020-08-26,DIJWLK)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           location_no_,
                                           pick_list_no_level_db_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
               IF (column_name_ = 'LOCATION_NO') THEN
                  lov_item_description_ :=  Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
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

-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   source_ref_type_db_         IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_              Get_Lov_Values;
   stmt_                        VARCHAR2(6000);
   lov_value_tab_               Lov_Value_Tab;
   second_column_name_          VARCHAR2(200);
   second_column_value_         VARCHAR2(200);
   lov_item_description_        VARCHAR2(200);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   aggr_line_id_in_a_loop_       BOOLEAN := FALSE;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   tmp_location_no_              VARCHAR2(35);
   temp_handling_unit_id_        NUMBER;
   temp_sscc_                    VARCHAR2(18);
   temp_alt_handl_unit_label_id_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Pick_Hu_Process', column_name_);
      
      stmt_ := 'SELECT ' || column_name_ 
           || ' FROM Pick_Hu_Process 
                WHERE contract  = :contract_ ';
               
      IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
      END IF;
      IF (aggregated_line_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
      END IF;

      IF (location_no_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND location_no = :location_no_ ';
      ELSE
         stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
      END IF;

      IF (handling_unit_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
      END IF;

      IF (sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
      ELSIF (sscc_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
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
      
      IF (source_ref_type_db_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
      ELSE
         stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
      END IF;
      
      -- Add extra filtering of earlier scanned values of this data item to dynamic cursor if data item is AGGREGATED_LINE_ID and is in a loop for this configuration
      IF (column_name_ = 'AGGREGATED_LINE_ID') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, 'AGGREGATED_LINE_ID')) THEN
            stmt_ := stmt_  || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id_
                                                                                              AND  data_item_id = ''AGGREGATED_LINE_ID''
                                                                                              AND  data_item_detail_id IS NULL
                                                                                              AND  data_item_value = ROWIDTOCHAR(aggregated_line_id)) ';   
            aggr_line_id_in_a_loop_ := TRUE;
         END IF;
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      
      -- Add the general route order sorting 
      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes since this needs be exactly same order 
      -- as the IEE client (frmPickReportDiffAggregated.tblPickAggregated). Also this is the exact same ORDER BY as the IEE client have, but if it will not give 
      -- the same order everytime for things that are not part of the ORDER BY, so sometimes the order in this LOV and that of the IEE client could be different.
      
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                    location_no,
                                    structure_level ';

      IF (aggr_line_id_in_a_loop_) THEN
         @ApproveDynamicStatement(2020-09-08,BUDKLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                     pick_list_no_,
                                     aggregated_line_id_,
                                     location_no_,
                                     handling_unit_id_,                                    
                                     sscc_,                                     
                                     alt_handling_unit_label_id_,
                                     source_ref_type_db_,
                                     capture_session_id_;
      ELSE
         @ApproveDynamicStatement(2020-09-08,BUDKLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              pick_list_no_,
                                              aggregated_line_id_,
                                              location_no_,
                                              handling_unit_id_,                                             
                                              sscc_,                                              
                                              alt_handling_unit_label_id_,
                                              source_ref_type_db_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('AGGREGATED_LINE_ID') THEN
               second_column_name_ := 'LOCATION_AND_HU';
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HU_STR_LEVEL_AND_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'SSCC_STR_LEVEL_AND_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'ALT_STR_LEVEL_AND_DESC';
            ELSE
               NULL;
         END CASE;
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'LOCATION_AND_HU') THEN
                     IF (session_rec_.capture_process_id = 'PICK_HU') THEN -- just in case some other process starts using this LOV since they dont have these details probably
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_HANDLING_UNIT_ID'))) THEN
                           temp_handling_unit_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                pick_list_no_               => pick_list_no_,
                                                                                aggregated_line_id_         => lov_value_tab_(i),
                                                                                location_no_                => location_no_,
                                                                                handling_unit_id_           => handling_unit_id_,
                                                                                sscc_                       => sscc_,
                                                                                alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                source_ref_type_db_         => source_ref_type_db_,
                                                                                column_name_                => 'HANDLING_UNIT_ID');
                        END IF;
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_SSCC'))) THEN
                           temp_sscc_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                    pick_list_no_               => pick_list_no_,
                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                    location_no_                => location_no_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    sscc_                       => sscc_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    source_ref_type_db_         => source_ref_type_db_,
                                                                    column_name_                => 'SSCC');
                        END IF;
                        IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID'))) THEN
                           temp_alt_handl_unit_label_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                       pick_list_no_               => pick_list_no_,
                                                                                       aggregated_line_id_         => lov_value_tab_(i),
                                                                                       location_no_                => location_no_,
                                                                                       handling_unit_id_           => handling_unit_id_,
                                                                                       sscc_                       => sscc_,
                                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                       source_ref_type_db_         => source_ref_type_db_,
                                                                                       column_name_                => 'ALT_HANDLING_UNIT_LABEL_ID');
                        END IF;
                        tmp_location_no_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                       pick_list_no_               => pick_list_no_,
                                                                       aggregated_line_id_         => lov_value_tab_(i),
                                                                       location_no_                => location_no_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       sscc_                       => sscc_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       source_ref_type_db_         => source_ref_type_db_,
                                                                       column_name_                => 'LOCATION_NO');


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
   
                  ELSIF (second_column_name_ IN ('LOCATION_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HU_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'SSCC_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'ALT_STR_LEVEL_AND_DESC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  END IF;
                  
                  -- Method Handling_Unit_API.Get_Handling_Unit_From_Alt_Id can return null if alt_handling_unit_id is not unique so we better to 
                  -- check if temp_handling_unit_id_ is not null when concatenate with | to avoid empty description with character '|'
                  IF (second_column_name_ IN ('HU_STR_LEVEL_AND_DESC', 'SSCC_STR_LEVEL_AND_DESC', 'ALT_STR_LEVEL_AND_DESC') AND 
                      temp_handling_unit_id_ IS NOT NULL) THEN 
                     second_column_value_ := Handling_Unit_API.Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
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

-- This method is used by DataCaptRepPickShipHu 
PROCEDURE Create_Data_Capture_Lov (
   contract_                       IN VARCHAR2,
   shipment_id_                    IN VARCHAR2,
   pick_list_no_                   IN VARCHAR2,
   shp_handling_unit_id_           IN VARCHAR2,
   shp_sscc_                       IN VARCHAR2,
   shp_alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                    IN VARCHAR2,
   capture_session_id_             IN NUMBER,
   lov_type_db_                    IN VARCHAR2,
   sql_where_expression_           IN VARCHAR2 DEFAULT NULL)
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_     NUMBER;
   stmt_                   VARCHAR2(6000);
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   lov_value_tab_          Lov_Value_Tab;
   exit_lov_               BOOLEAN := FALSE;
--   temp_lov_item_value_    VARCHAR2(200);
--   lov_item_description_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      Assert_SYS.Assert_Is_View_Column('Pick_Shipment_Handling_Unit', column_name_);

      stmt_ := 'SELECT ' || column_name_ ||
               ' FROM Pick_Shipment_Handling_Unit WHERE Pick_Shipment_API.Is_Shpmnt_Hu_Fully_Picked(pick_list_no, handling_unit_id)=''FALSE'''||
               ' AND contract = :contract_ ';
               
      IF(shipment_id_ IS NOT NULL) THEN
         stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
      ELSE
         stmt_ := stmt_|| ' AND :shipment_id_ is NULL';
      END IF;

      IF (pick_list_no_ IS NOT NULL) THEN
          stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
       ELSE
          stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
       END IF;

       IF (shp_handling_unit_id_ IS NOT NULL) THEN
          stmt_ := stmt_|| ' AND handling_unit_id = :shp_handling_unit_id_ ';
       ELSE
          stmt_ := stmt_|| ' AND :shp_handling_unit_id_ IS NULL  ';
       END IF;

      IF (shp_sscc_ IS NULL) THEN 
         stmt_ := stmt_ || ' AND sscc IS NULL AND :shp_sscc_ IS NULL ';
      ELSIF (shp_sscc_ = '%') THEN 
         stmt_ := stmt_ || ' AND :shp_sscc_ = ''%'' ';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :shp_sscc_ ';
      END IF;
   
      IF (shp_alt_handling_unit_label_id_ IS NULL) THEN 
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id IS NULL AND :shp_alt_handling_unit_label_id_ IS NULL ';
      ELSIF (shp_alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :shp_alt_handling_unit_label_id_ = ''%'' ';
      ELSE
         stmt_ := stmt_ || ' AND  alt_handling_unit_label_id = :shp_alt_handling_unit_label_id_';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;  

      @ApproveDynamicStatement(2021-07-19,MOINLK)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           shipment_id_,
                                           pick_list_no_,
                                           shp_handling_unit_id_,                                       
                                           shp_sscc_,                                      
                                           shp_alt_handling_unit_label_id_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;

   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;
-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   source_ref_type_db_         IN VARCHAR2,
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(6000);   
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Pick_Hu_Process', column_name_);
   
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  Pick_Hu_Process 
             WHERE contract  = :contract_ ';

   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (aggregated_line_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
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
   
   IF (source_ref_type_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
   END IF;
      
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
   
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   
   
   @ApproveDynamicStatement(2020-09-08,BUDKLK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           aggregated_line_id_,
                                           location_no_,
                                           handling_unit_id_,                                           
                                           sscc_,                                           
                                           alt_handling_unit_label_id_,
                                           source_ref_type_db_;
                                        
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');     
      END IF;  
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;
   
-- This method is used by DataCaptRepPickShipHu   
@ServerOnlyAccess   
FUNCTION Get_Column_Value_If_Unique(
   contract_                       IN VARCHAR2,
   shipment_id_                    IN VARCHAR2,
   pick_list_no_                   IN VARCHAR2,
   shp_handling_unit_id_           IN VARCHAR2,
   shp_sscc_                       IN VARCHAR2,
   shp_alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                    IN VARCHAR2,
   sql_where_expression_           IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(6000);   
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN
      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Pick_Shipment_Handling_Unit', column_name_);
   
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  Pick_Shipment_Handling_Unit WHERE Pick_Shipment_API.Is_Shpmnt_Hu_Fully_Picked(pick_list_no, handling_unit_id)=''FALSE'''||
             ' AND contract = :contract_ ';

   IF(shipment_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :shipment_id_ is NULL';
   END IF;
   
   IF (pick_list_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
    END IF;

    IF (shp_handling_unit_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND handling_unit_id = :shp_handling_unit_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :shp_handling_unit_id_ IS NULL  ';
    END IF;
   
   IF (shp_sscc_ IS NULL) THEN 
      stmt_ := stmt_ || ' AND sscc IS NULL AND :shp_sscc_ IS NULL ';
   ELSIF (shp_sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :shp_sscc_ = ''%'' ';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :shp_sscc_ ';
   END IF;
   
   IF (shp_alt_handling_unit_label_id_ IS NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id IS NULL AND :shp_alt_handling_unit_label_id_ IS NULL ';
   ELSIF (shp_alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :shp_alt_handling_unit_label_id_ = ''%'' ';
   ELSE
      stmt_ := stmt_ || ' AND  alt_handling_unit_label_id = :shp_alt_handling_unit_label_id_';
   END IF;
      
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;  
   
   @ApproveDynamicStatement(2021-07-18,MOINLK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           shipment_id_,
                                           pick_list_no_,
                                           shp_handling_unit_id_,                                          
                                           shp_sscc_,                                           
                                           shp_alt_handling_unit_label_id_;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');     
      END IF;  
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
                                        
END Get_Column_Value_If_Unique;
   
-- This method is used by DataCaptReportPickHu
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   source_ref_type_db_         IN VARCHAR2, 
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN  VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(6000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Pick_Hu_Process', column_name_);

   stmt_ := 'SELECT 1
             FROM  Pick_Hu_Process
             WHERE contract  = :contract_ ';
   
   IF (pick_list_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
    END IF;
    IF (aggregated_line_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND aggregated_line_id = :aggregated_line_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :aggregated_line_id_ IS NULL  ';
    END IF;

    IF (location_no_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND location_no = :location_no_ ';
    ELSE
       stmt_ := stmt_|| ' AND :location_no_ IS NULL  ';
    END IF;

    IF (handling_unit_id_ IS NOT NULL) THEN
       stmt_ := stmt_|| ' AND handling_unit_id = :handling_unit_id_ ';
    ELSE
       stmt_ := stmt_|| ' AND :handling_unit_id_ IS NULL  ';
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
    
   IF (source_ref_type_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
   END IF;
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
   
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2020-09-08,BUDKLK)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       pick_list_no_,
                                       aggregated_line_id_,
                                       location_no_,
                                       handling_unit_id_,                                       
                                       sscc_,                                      
                                       alt_handling_unit_label_id_,
                                       source_ref_type_db_,
                                       column_value_,
                                       column_value_;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (column_name_ = 'PICK_LIST_NO') THEN
         Raise_No_Value_Exist_Error___(column_description_, column_value_);
      ELSE
         Raise_No_Picklist_Error___(column_value_, pick_list_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;

-- This method is used by DataCaptRepPickShipHu
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                       IN VARCHAR2,
   shipment_id_                    IN VARCHAR2,
   pick_list_no_                   IN VARCHAR2,
   shp_handling_unit_id_           IN VARCHAR2,
   shp_sscc_                       IN VARCHAR2,
   shp_alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                    IN VARCHAR2,
   column_description_             IN VARCHAR2,
   column_value_                   IN VARCHAR2,
   sql_where_expression_           IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(6000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN
   
   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Pick_Shipment_Handling_Unit', column_name_);

   stmt_ := 'SELECT 1
             FROM  Pick_Shipment_Handling_Unit WHERE Pick_Shipment_API.Is_Shpmnt_Hu_Fully_Picked(pick_list_no, handling_unit_id)=''FALSE'''||
             ' AND contract = :contract_ ';
             
   IF(shipment_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND shipment_id = :shipment_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :shipment_id_ is NULL';
   END IF;
   
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;

   IF (shp_handling_unit_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND handling_unit_id = :shp_handling_unit_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :shp_handling_unit_id_ IS NULL  ';
   END IF;
   
   IF (shp_sscc_ IS NULL) THEN 
      stmt_ := stmt_ || ' AND sscc IS NULL AND :shp_sscc_ IS NULL ';
   ELSIF (shp_sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :shp_sscc_ = ''%'' ';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :shp_sscc_ ';
   END IF;
   
   IF (shp_alt_handling_unit_label_id_ IS NULL) THEN 
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id IS NULL AND :shp_alt_handling_unit_label_id_ IS NULL ';
   ELSIF (shp_alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :shp_alt_handling_unit_label_id_ = ''%'' ';
   ELSE
      stmt_ := stmt_ || ' AND  alt_handling_unit_label_id = :shp_alt_handling_unit_label_id_';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;
   
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2021-07-14,MOINLK)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       shipment_id_,
                                       pick_list_no_,
                                       shp_handling_unit_id_,                                       
                                       shp_sscc_,                                      
                                       shp_alt_handling_unit_label_id_,
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

@UncheckedAccess
FUNCTION Handl_Unit_Exist_On_Pick_List (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   hu_exist_  BOOLEAN := FALSE;
   dummy_     NUMBER;
   CURSOR check_if_hu_exist_ IS
      SELECT 1 
      FROM  Report_Pick_Handling_Unit 
      WHERE pick_list_no = pick_list_no_
      AND   handling_unit_id = handling_unit_id_;
BEGIN
   OPEN check_if_hu_exist_;
   FETCH check_if_hu_exist_ INTO dummy_;
   IF (check_if_hu_exist_%FOUND) THEN
      hu_exist_ := TRUE;
   END IF;
   CLOSE check_if_hu_exist_;
   RETURN hu_exist_;
END Handl_Unit_Exist_On_Pick_List;

-- This method was created especially for wadaco process Report Picking of Handling Units and will probably not suit anything else
--@UncheckedAccess
FUNCTION Last_Hndl_Unit_Structure_On_PL (
   pick_list_no_ IN VARCHAR2,
   root_handling_unit_id_ IN NUMBER) RETURN BOOLEAN
IS
   part_lines_                NUMBER;
   temp_handling_unit_id_     NUMBER;
   last_handl_unit_structure_ BOOLEAN := FALSE;

   CURSOR part_lines_left_to_pick_ IS
      SELECT COUNT(*)
      FROM   START_SHIP_PICK_PROCESS 
      WHERE  pick_list_no = pick_list_no_
      AND   part_or_handling_unit = 'PART';  

   CURSOR get_all_remaing_hu_ IS
      SELECT handling_unit_id
      FROM   START_SHIP_PICK_PROCESS   
      WHERE  pick_list_no = pick_list_no_;

BEGIN
   OPEN  part_lines_left_to_pick_;
   FETCH part_lines_left_to_pick_ INTO part_lines_;
   CLOSE part_lines_left_to_pick_;

   IF part_lines_ > 0 THEN
      last_handl_unit_structure_  := FALSE;  -- Make sure no part lines are still left to pick
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
END Last_Hndl_Unit_Structure_On_PL;

-- This method was created especially for wadaco process Pick Handling Units and will probably not suit anything else
@UncheckedAccess
FUNCTION Lines_Left_To_Pick (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   lines_   NUMBER;
   CURSOR get_lines_left_to_pick IS
      SELECT COUNT(*)
      FROM   START_SHIP_PICK_PROCESS
      WHERE  pick_list_no = pick_list_no_;
BEGIN
   OPEN  get_lines_left_to_pick;
   FETCH get_lines_left_to_pick INTO lines_;
   CLOSE get_lines_left_to_pick;
   RETURN lines_;
END Lines_Left_To_Pick;

-- This method is used by DataCaptStartPick
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_              IN VARCHAR2,
   pick_list_no_          IN VARCHAR2,
   location_no_           IN VARCHAR2,
   pick_list_no_level_db_ IN VARCHAR2,
   column_name_           IN VARCHAR2,
   sql_where_expression_  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_    Get_Column_Value;
   stmt_                 VARCHAR2(2000);
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;
BEGIN
   Assert_SYS.Assert_Is_View_Column('START_SHIP_PICK_PROCESS', column_name_);

   stmt_ := 'SELECT DISTINCT(' || column_name_ || ')
             FROM START_SHIP_PICK_PROCESS
             WHERE contract  = :contract_ ';
   Generate_Start_Exec_Stmt___(stmt_, pick_list_no_, location_no_, pick_list_no_level_db_, sql_where_expression_);
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2020-08-26,DIJWLK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           location_no_,
                                           pick_list_no_level_db_;

   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');
   END IF;
   CLOSE get_column_values_;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptStartPick
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   location_no_                IN VARCHAR2,
   pick_list_no_level_db_      IN VARCHAR2,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   Assert_SYS.Assert_Is_View_Column('START_SHIP_PICK_PROCESS', column_name_);

   stmt_ := 'SELECT 1
             FROM START_SHIP_PICK_PROCESS
             WHERE contract  = :contract_ ';
   Generate_Start_Exec_Stmt___(stmt_, pick_list_no_, location_no_, pick_list_no_level_db_, sql_where_expression_);
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2020-08-26,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       pick_list_no_,
                                       location_no_,
                                       pick_list_no_level_db_,
                                       column_value_,
                                       column_value_;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Raise_No_Value_Exist_Error___(column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCapturePickPart
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   data_item_id_               IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   lov_id_                     IN NUMBER DEFAULT 1 )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(6000);
   lov_value_tab_            Lov_Value_Tab;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   local_part_no_            VARCHAR2(25);
   local_location_no_        VARCHAR2(35);
   qty_reserved_             NUMBER;
   qty_picked_               NUMBER;
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   unique_line_id_in_a_loop_ BOOLEAN := FALSE;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      IF lov_id_ = 1 THEN  -- using Report_Pick_List as data source
         
         -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('Pick_Part_Process', column_name_);
         stmt_ := 'SELECT ' || column_name_ 
              || ' FROM Pick_Part_Process
                   WHERE contract      = :contract_                   
                   AND   pick_list_no  != ''*''
                   AND   qty_picked    = 0
                   AND   qty_reserved  > 0';
         
         IF (pick_list_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
         END IF;
         IF (unique_line_id_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND unique_line_id = :unique_line_id_ ';
         ELSE
            stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
         END IF;
         IF (source_ref1_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref1 = :source_ref1_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref1_ IS NULL  ';
         END IF;
         IF (source_ref2_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref2 = :source_ref2_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref2_ IS NULL  ';
         END IF;
         IF (source_ref3_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref3 = :source_ref3_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref3_ IS NULL  ';
         END IF;
         IF (source_ref4_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref4 = :source_ref4_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref4_ IS NULL  ';
         END IF;
         IF (source_ref_type_db_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
         END IF;
         IF (part_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND part_no = :part_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
         END IF;
         IF (location_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND location_no = :location_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
         END IF;
         IF (serial_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
         END IF;
         IF (lot_batch_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
         END IF;
         IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
         END IF;
         IF (eng_chg_level_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_ ';
         ELSE
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
         END IF;
         IF (configuration_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
         END IF;      
         IF (activity_seq_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_ ';
         ELSE
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
         END IF;
         IF (handling_unit_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
         END IF;
         
         IF (sscc_ = '%') THEN 
            stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
         ELSIF (sscc_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
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
         IF (shipment_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND shipment_id  = :shipment_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
         END IF;                  
         
         IF (column_name_ = 'UNIQUE_LINE_ID') THEN
            IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_)) THEN
               stmt_ := stmt_  || ' AND Data_Capture_Pick_Part_API.Consume_Unique_Line_Id(:capture_session_id_, CONTRACT, PICK_LIST_NO,
                                                                                              ROWIDTOCHAR(unique_line_id), SOURCE_REF1,
                                                                                              SOURCE_REF2, SOURCE_REF3, SOURCE_REF4, SOURCE_REF_TYPE, PART_NO, SERIAL_NO, LOCATION_NO,
                                                                                              LOT_BATCH_NO, WAIV_DEV_REJ_NO, ENG_CHG_LEVEL,
                                                                                              CONFIGURATION_ID, ACTIVITY_SEQ, HANDLING_UNIT_ID, SHIPMENT_ID) = ''FALSE'' ';
               unique_line_id_in_a_loop_ := TRUE;
            END IF;
         END IF;
         IF (column_name_ = 'SHIPMENT_ID') THEN
            stmt_ := stmt_  || ' ORDER BY SHIPMENT_ID ';
         ELSE
            -- Add the general route order sorting 
            -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes since this needs be exactly same order 
            -- as the IEE client (tbwPickReportDiffSingle). Also this is the exact same ORDER BY as the IEE client have, but if it will not give the same order everytime 
            -- for things that are not part of the ORDER BY, so sometimes the order in this LOV and that of the IEE client could be different.
            stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                          UPPER(warehouse_route_order) ASC,
                                          Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                          UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                          Utility_SYS.String_To_Number(row_route_order) ASC, 
                                          UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                          Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                          UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                          Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                          UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                          location_no, 
                                          LPAD(source_ref1,50),                                 
                                          LPAD(source_ref2,50),
                                          LPAD(source_ref3,50),
                                          LPAD(source_ref4,50) ';
         END IF;
         
         IF (unique_line_id_in_a_loop_) THEN
            @ApproveDynamicStatement(2020-09-15,NIASLK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                pick_list_no_,
                                                unique_line_id_,
                                                source_ref1_,
                                                source_ref2_,
                                                source_ref3_,
                                                source_ref4_,
                                                source_ref_type_db_,
                                                part_no_,
                                                location_no_,
                                                serial_no_,
                                                lot_batch_no_,
                                                waiv_dev_rej_no_,
                                                eng_chg_level_,
                                                configuration_id_,
                                                activity_seq_,
                                                handling_unit_id_,
                                                sscc_,                                      
                                                alt_handling_unit_label_id_,
                                                shipment_id_,
                                                capture_session_id_;
         ELSE
            @ApproveDynamicStatement(2020-09-15,NIASLK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                 pick_list_no_,
                                                 unique_line_id_,
                                                 source_ref1_,
                                                 source_ref2_,
                                                 source_ref3_,
                                                 source_ref4_,
                                                 source_ref_type_db_,
                                                 part_no_,
                                                 location_no_,
                                                 serial_no_,
                                                 lot_batch_no_,
                                                 waiv_dev_rej_no_,
                                                 eng_chg_level_,
                                                 configuration_id_,
                                                 activity_seq_,
                                                 handling_unit_id_,                                                
                                                 sscc_,                                                 
                                                 alt_handling_unit_label_id_,
                                                 shipment_id_;
            
         END IF;
         
         
         -- If this process is used together with the START_PICKING process we need to break current sorting and add route order/location/handling unit 
         -- sorting similar to the aggregated tab. This so we can group the lines connected to a specific location and handling unit id together. 
      ELSIF lov_id_ = 2 THEN  -- using Report_Picking_Part_Process as a data source and different sorting
         -- No unique_line_id_in_a_loop_ handling in this LOV variant since this variant is more of 1 record at the time and then back to 
         -- Start Process for the next record without Loops inside Part Process
         
         -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('Pick_Part', column_name_);
         
         stmt_ := 'SELECT ' || column_name_ 
              || ' FROM Pick_Part
                   WHERE contract                   = :contract                   
                   AND   pick_list_no              != ''*''
                   AND   qty_picked                 = 0
                   AND   qty_reserved               > 0';

         IF (pick_list_no_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   pick_list_no = :pick_list_no_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :pick_list_no_ IS NULL  ';
         END IF;
         IF (unique_line_id_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND   unique_line_id = :unique_line_id_ ';
         ELSE
            stmt_ := stmt_|| ' AND   :unique_line_id_ IS NULL  ';
         END IF;
         IF (source_ref1_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref1 = :source_ref1_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref1_ IS NULL  ';
         END IF;
         IF (source_ref2_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref2 = :source_ref2_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref2_ IS NULL  ';
         END IF;
         IF (source_ref3_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref3 = :source_ref3_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref3_ IS NULL  ';
         END IF;
         IF (source_ref4_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref4 = :source_ref4_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref4_ IS NULL  ';
         END IF;
         IF (source_ref_type_db_ IS NOT NULL) THEN
            stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
         ELSE
            stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
         END IF;
         IF (part_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND part_no  = :part_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
         END IF;
         IF (location_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND location_no  = :location_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
         END IF;
         IF (serial_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND serial_no  = :serial_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
         END IF;
         IF (lot_batch_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND lot_batch_no  = :lot_batch_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
         END IF;
         IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND waiv_dev_rej_no  = :waiv_dev_rej_no_ ';
         ELSE
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
         END IF;
         IF (eng_chg_level_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND eng_chg_level  = :eng_chg_level_ ';
         ELSE
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
         END IF;
         IF (configuration_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND configuration_id  = :configuration_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
         END IF;      
         IF (activity_seq_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND activity_seq  = :activity_seq_ ';
         ELSE
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
         END IF;
         IF (handling_unit_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND handling_unit_id  = :handling_unit_id_ ';
         ELSE
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
         END IF;
         IF (sscc_ = '%') THEN 
            stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
         ELSIF (sscc_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
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
         IF (shipment_id_ IS NOT NULL) THEN 
            stmt_ := stmt_ || ' AND shipment_id  = :shipment_id ';
         ELSE
            stmt_ := stmt_ || ' AND :shipment_id IS NULL ';
         END IF;         
 
         -- Add the general route order sorting 
         -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
         -- since this needs be route order sorted. 
         -- The decode in top_parent_handling_unit_id handling and the NVL on structure_level is so broken handling units 
         -- (hu id != 0 and outmost hu = NULL) will come after non handling units and before complete handlings units per location.
         -- Extra sorting on outermost_handling_unit_id to make sure broken handling units comes before complete handling units.
         stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                       UPPER(warehouse_route_order) ASC,
                                       Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                       UPPER(decode(bay_route_order, ''  -'', Database_SYS.Get_Last_Character, bay_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(row_route_order) ASC, 
                                       UPPER(decode(row_route_order, ''  -'', Database_SYS.Get_Last_Character,row_route_order)) ASC,
                                       Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                       UPPER(decode(tier_route_order, ''  -'', Database_SYS.Get_Last_Character, tier_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                       UPPER(decode(bin_route_order, ''  -'', Database_SYS.Get_Last_Character, bin_route_order)) ASC,
                                       location_no,
                                       NVL(outermost_handling_unit_id,0),
                                       NVL(top_parent_handling_unit_id, DECODE(outermost_handling_unit_id,NULL,0,handling_unit_id)),
                                       NVL(structure_level,0),
                                       handling_unit_id,
                                       LPAD(source_ref1,50),                                 
                                       LPAD(source_ref2,50),
                                       LPAD(source_ref3,50),
                                       LPAD(source_ref4,50) ';
         
         @ApproveDynamicStatement(2020-09-15,NIASLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              pick_list_no_,
                                              unique_line_id_,
                                              source_ref1_,
                                              source_ref2_,
                                              source_ref3_,
                                              source_ref4_,
                                              source_ref_type_db_,
                                              part_no_,
                                              location_no_,
                                              serial_no_,
                                              lot_batch_no_,
                                              waiv_dev_rej_no_,
                                              eng_chg_level_,
                                              configuration_id_,
                                              activity_seq_,
                                              handling_unit_id_,                                             
                                              sscc_,                                              
                                              alt_handling_unit_label_id_,
                                              shipment_id_;
      END IF;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
         lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('UNIQUE_LINE_ID') THEN
               second_column_name_ := 'PART_DESC_LOC_DESC_QTY';
            WHEN ('PART_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            ELSE
               NULL;
         END CASE;
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ IN ('PART_DESC_LOC_DESC_QTY')) THEN
                     local_part_no_     := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                      waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'PART_NO');
                     local_location_no_ := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                      waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'LOCATION_NO');
                     
                     
                     qty_reserved_ := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                 waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'QTY_RESERVED');
                     qty_picked_   := Get_Column_Value_If_Unique(contract_, pick_list_no_, lov_value_tab_(i), source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, location_no_, serial_no_, lot_batch_no_, 
                                                                 waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, shipment_id_, 'QTY_PICKED');
                     
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, local_part_no_) || ' | ' ||
                                             Inventory_Location_API.Get_Location_Name(contract_, local_location_no_) || ' | ' ||
                                             TO_CHAR(NVL(qty_reserved_,0) - NVL(qty_picked_,0));
                     
                  ELSIF (second_column_name_ IN ('PART_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ IN ('LOCATION_DESCRIPTION')) THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
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

FUNCTION Remove_Duplicate_Lov_Values___ (
   old_lov_value_tab_ Lov_Value_Tab ) RETURN Lov_Value_Tab
IS
   new_lov_value_tab_ Lov_Value_Tab;
   lov_value_found_   BOOLEAN;
   index_             PLS_INTEGER := 1;
BEGIN
   IF (old_lov_value_tab_.COUNT > 0) THEN
      FOR i IN old_lov_value_tab_.FIRST..old_lov_value_tab_.LAST LOOP
         lov_value_found_ := FALSE;
         IF (new_lov_value_tab_.COUNT > 0) THEN
            FOR j IN new_lov_value_tab_.FIRST..new_lov_value_tab_.LAST LOOP
               IF (old_lov_value_tab_(i) = new_lov_value_tab_(j)) THEN
                  lov_value_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         IF NOT (lov_value_found_) THEN
            new_lov_value_tab_(index_) := old_lov_value_tab_(i);
            index_ := index_ + 1;
         END IF;
      END LOOP;
   END IF;
   RETURN new_lov_value_tab_;
END Remove_Duplicate_Lov_Values___;

-- This method is used by DataCapturePickPart
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER,
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);   
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab;  
BEGIN
   
   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('Pick_Part_Process', column_name_);
   stmt_ := 'SELECT DISTINCT(' || column_name_ || ') 
             FROM  Pick_Part_Process
             WHERE contract      = :contract_
             AND   pick_list_no  != ''*''
             AND   qty_picked    = 0
             AND   qty_reserved  > 0 ';
   
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (unique_line_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND unique_line_id = :unique_line_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
   END IF;
   IF (source_ref1_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref1 = :source_ref1_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref1_ IS NULL  ';
   END IF;
   IF (source_ref2_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref2 = :source_ref2_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref2_ IS NULL  ';
   END IF;
   IF (source_ref3_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref3 = :source_ref3_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref3_ IS NULL  ';
   END IF;
   IF (source_ref4_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref4 = :source_ref4_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref4_ IS NULL  ';
   END IF;
   IF (source_ref_type_db_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref_type_db = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref_type_db_ IS NULL  ';
   END IF;
   IF (part_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND part_no = :part_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
   END IF;
   IF (serial_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
   END IF;
   IF (lot_batch_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
   END IF;
   IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND waiv_dev_rej_no  = :waiv_dev_rej_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
   END IF;
   IF (eng_chg_level_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND eng_chg_level  = :eng_chg_level_ ';
   ELSE
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
   END IF;
   IF (configuration_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND configuration_id  = :configuration_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
   END IF;      
   IF (activity_seq_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND activity_seq  = :activity_seq_ ';
   ELSE
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND handling_unit_id  = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
   END IF;
   IF (sscc_ = '%') THEN 
      stmt_ := stmt_ || ' AND :sscc_ = ''%'' ';
   ELSIF (sscc_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND sscc  = :sscc_ ';
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
   IF (shipment_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND shipment_id  = :shipment_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   

   @ApproveDynamicStatement(2020-09-15,NIASLK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           pick_list_no_,
                                           unique_line_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           part_no_,
                                           location_no_,
                                           serial_no_,
                                           lot_batch_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           configuration_id_,
                                           activity_seq_,
                                           handling_unit_id_,                                           
                                           sscc_,                                          
                                           alt_handling_unit_label_id_,
                                           shipment_id_;  
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;      
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');    
   END IF;
   CLOSE get_column_values_;     
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapturePickPart
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   unique_line_id_             IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   shipment_id_                IN NUMBER,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   inv_barcode_validation_     IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(4000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN
   
   IF (NOT inv_barcode_validation_) THEN  
      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('Pick_Part_Process', column_name_);
   END IF;
   
   stmt_ := 'SELECT 1
             FROM  Pick_Part_Process
             WHERE contract      = :contract_             
             AND   pick_list_no  != ''*''
             AND   qty_picked    = 0
             AND   qty_reserved  > 0 ';
   
   IF (pick_list_no_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND pick_list_no = :pick_list_no_ ';
   ELSE
      stmt_ := stmt_|| ' AND :pick_list_no_ IS NULL  ';
   END IF;
   IF (unique_line_id_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND unique_line_id = :unique_line_id_ ';
   ELSE
      stmt_ := stmt_|| ' AND :unique_line_id_ IS NULL  ';
   END IF;
   IF (source_ref1_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref1 = :source_ref1_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref1_ IS NULL  ';
   END IF;
   IF (source_ref2_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref2 = :source_ref2_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref2_ IS NULL  ';
   END IF;
   IF (source_ref3_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref3 = :source_ref3_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref3_ IS NULL  ';
   END IF;
   IF (source_ref4_ IS NOT NULL) THEN
      stmt_ := stmt_|| ' AND source_ref4 = :source_ref4_ ';
   ELSE
      stmt_ := stmt_|| ' AND :source_ref4_ IS NULL  ';
   END IF;
   IF (source_ref_type_db_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_ ';
   ELSE
      stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL  ';
   END IF;
   IF (part_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND part_no = :part_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
   END IF;
   IF (serial_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND serial_no = :serial_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
   END IF;
   IF (lot_batch_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
   END IF;
   IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
   END IF;
   IF (eng_chg_level_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_ ';
   ELSE
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
   END IF;
   IF (configuration_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
   END IF;      
   IF (activity_seq_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_ ';
   ELSE
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
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
   IF (shipment_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL ';
   END IF;
   IF (NOT inv_barcode_validation_) THEN  
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   END IF;
   
   
   IF (inv_barcode_validation_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2020-09-15,NIASLK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          pick_list_no_,
                                          unique_line_id_,
                                          source_ref1_,
                                          source_ref2_,
                                          source_ref3_,
                                          source_ref4_,
                                          source_ref_type_db_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,                                         
                                          sscc_,                                          
                                          alt_handling_unit_label_id_,
                                          shipment_id_;
   ELSE
      @ApproveDynamicStatement(2020-09-15,NIASLK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          pick_list_no_,
                                          unique_line_id_,
                                          source_ref1_,
                                          source_ref2_,
                                          source_ref3_,
                                          source_ref4_,
                                          source_ref_type_db_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,                                          
                                          sscc_,                                          
                                          alt_handling_unit_label_id_,
                                          shipment_id_,
                                          column_value_,
                                          column_value_;
   END IF;
   
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (inv_barcode_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'BARCODENOTEXIST: The Barcode record does not match current Report Picking Line.');
      ELSE
         Raise_No_Picklist_Error___(column_value_, pick_list_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;

-- This method fetch Shipment reference info for Pick Handling Unit By Choice
@UncheckedAccess
PROCEDURE Get_HU_Shipment_Reference_Info (
   source_ref1_      OUT VARCHAR2,
   source_ref2_      OUT VARCHAR2,
   source_ref3_      OUT VARCHAR2,
   source_ref4_      OUT VARCHAR2,
   shipment_id_      OUT VARCHAR2,
   sender_id_        OUT VARCHAR2,
   sender_type_      OUT VARCHAR2,
   qty_to_pick_      OUT NUMBER,
   pick_list_no_     IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   location_no_      IN  VARCHAR2,
	handling_unit_id_ IN  NUMBER)
IS 
   CURSOR get_source_ref IS
      SELECT DISTINCT source_ref1, source_ref2, source_ref3, source_ref4
      FROM PICK_SHIPMENT_RESERVATION
      WHERE pick_list_no = pick_list_no_
      AND handling_unit_id IN (SELECT hu.handling_unit_id
                               FROM handling_unit_tab hu
                               CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                               START WITH       hu.handling_unit_id = handling_unit_id_);
								   
								   
   CURSOR get_source_ref_loc IS
      SELECT DISTINCT source_ref1, source_ref2, source_ref3, source_ref4
      FROM PICK_SHIPMENT_RESERVATION psr
      WHERE  pick_list_no = pick_list_no_
         AND contract     = contract_
         AND location_no  = location_no_
         AND EXISTS (SELECT 1
                     FROM INV_PART_STOCK_SNAPSHOT_PUB ipss
                     WHERE  ipss.source_ref1        = pick_list_no_
                        AND ipss.source_ref_type_db = 'PICK_LIST'
                        AND ipss.contract           = psr.contract
                        AND ipss.location_no        = psr.location_no
                        AND ipss.handling_unit_id   = psr.handling_unit_id);	

   TYPE Source_Rec IS RECORD (
      source_ref1      VARCHAR2(50),
      source_ref2      VARCHAR2(50),
      source_ref3      VARCHAR2(50),
      source_ref4      VARCHAR2(50));
   
   TYPE Source_Info_Tab IS TABLE OF Source_Rec INDEX BY PLS_INTEGER;
   source_info_tab_  Source_Info_Tab;
   shipment_rec_     Shipment_API.Public_Rec;
BEGIN
   
   IF (handling_unit_id_ != 0) THEN
      OPEN get_source_ref;
      FETCH get_source_ref BULK COLLECT INTO source_info_tab_;
      CLOSE get_source_ref;
   ELSE
      OPEN get_source_ref_loc;
      FETCH get_source_ref_loc BULK COLLECT INTO source_info_tab_;
      CLOSE get_source_ref_loc;
   END IF;
   
   IF (source_info_tab_.COUNT = 1) THEN
      source_ref1_ := source_info_tab_(1).source_ref1;
      source_ref2_ := source_info_tab_(1).source_ref2;
      source_ref3_ := source_info_tab_(1).source_ref3;
      source_ref4_ := source_info_tab_(1).source_ref4;
   ELSIF (source_info_tab_.COUNT > 1) THEN
      source_ref1_ := '...';
      source_ref2_ := '...';
      source_ref3_ := '...';
      source_ref4_ := '...';
   END IF;
  
   shipment_id_     := Get_Shipment_Id(pick_list_no_, 'INVENTORY_PICK_LIST');   
   shipment_rec_    := Shipment_API.Get(shipment_id_);
   sender_id_       := shipment_rec_.sender_id;
   sender_type_     := shipment_rec_.sender_type;
   
   qty_to_pick_     := Handling_Unit_API.Get_Qty_Reserved(handling_unit_id_) - Get_Qty_Picked_HU(handling_unit_id_, contract_, location_no_, pick_list_no_);                                                 
END Get_HU_Shipment_Reference_Info;


@UncheckedAccess
FUNCTION Get_Pick_List_No_For_Shpmnt_Hu (   
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER) RETURN VARCHAR2 
IS      
   CURSOR get_pick_list_part_lines IS
      SELECT DISTINCT srhu1.pick_list_no, srhu1.part_no
        FROM shipment_reserv_handl_unit_tab srhu1
       WHERE srhu1.handling_unit_id  = handling_unit_id_
         AND srhu1.shipment_id       = shipment_id_
         AND srhu1.pick_list_no     != '*'
         AND NOT EXISTS (SELECT 1
                           FROM shipment_reserv_handl_unit_tab srhu2
                          WHERE srhu1.handling_unit_id = srhu2.handling_unit_id
                            AND srhu1.pick_list_no    != srhu2.pick_list_no);
                                          
   CURSOR get_valid_shipment_hu IS
      SELECT 1
        FROM shipment_line_handl_unit_tab slhu
       WHERE slhu.handling_unit_id = handling_unit_id_
         AND slhu.shipment_id      = shipment_id_
         AND Shipment_Line_Handl_Unit_API.Get_Qty_Left_To_Assign(shipment_id_, slhu.shipment_line_no, handling_unit_id_) > 0
          OR handling_unit_id_ IN (SELECT hu.parent_handling_unit_id
                                     FROM handling_unit_pub hu
                                    WHERE hu.shipment_id = shipment_id_
                                      AND hu.parent_handling_unit_id IS NOT NULL);
   
   TYPE Pick_List_Part_Lines_Tab IS TABLE OF get_pick_list_part_lines%ROWTYPE INDEX BY PLS_INTEGER;
   pick_list_part_lines_tab_     Pick_List_Part_Lines_Tab;
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   pick_list_no_                 VARCHAR2(15);
   is_valid_shipment_hu_         VARCHAR2(5) := 'TRUE';
   dummy_                        NUMBER;
   
BEGIN   
   OPEN get_valid_shipment_hu;
   FETCH get_valid_shipment_hu INTO dummy_;
   IF (get_valid_shipment_hu%FOUND) THEN      
      is_valid_shipment_hu_ := 'FALSE';
   END IF;
   CLOSE get_valid_shipment_hu; 
   
   IF (is_valid_shipment_hu_ = 'TRUE') THEN
      OPEN get_pick_list_part_lines;
      FETCH get_pick_list_part_lines BULK COLLECT INTO pick_list_part_lines_tab_;
      CLOSE get_pick_list_part_lines;
      
      IF pick_list_part_lines_tab_.COUNT > 0 THEN
         FOR i IN pick_list_part_lines_tab_.FIRST..pick_list_part_lines_tab_.LAST LOOP         
            pick_list_no_ := pick_list_part_lines_tab_(i).pick_list_no;
            
            part_catalog_rec_ := Part_Catalog_API.Get(pick_list_part_lines_tab_(i).part_no);
            
            IF (part_catalog_rec_.catch_unit_enabled = 'TRUE' OR part_catalog_rec_.receipt_issue_serial_track = 'TRUE') THEN
               pick_list_no_ := NULL;
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END IF;
   RETURN pick_list_no_;
END Get_Pick_List_No_For_Shpmnt_Hu;


@UncheckedAccess
FUNCTION Can_Pick_Shipment_Hu (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER) RETURN VARCHAR2 
IS
BEGIN   
   IF (Get_Pick_List_No_For_Shpmnt_Hu(handling_unit_id_, shipment_id_) IS NOT NULL) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;   
END Can_Pick_Shipment_Hu;


@UncheckedAccess
FUNCTION Is_Shpmnt_Hu_Fully_Picked (
   pick_list_no_     IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2 
IS   
   CURSOR get_shipment_hu IS
      SELECT 1
        FROM shipment_reserv_handl_unit_tab  
       WHERE pick_list_no      = pick_list_no_
         AND handling_unit_id  = handling_unit_id_
         AND handling_unit_id != reserv_handling_unit_id;
         
   dummy_           NUMBER;
   is_fully_picked_ VARCHAR2(5) := 'TRUE';
BEGIN
   OPEN get_shipment_hu;
   FETCH get_shipment_hu INTO dummy_;               
   IF (get_shipment_hu%FOUND) THEN
      is_fully_picked_ := 'FALSE';
   END IF;
   CLOSE get_shipment_hu;
	RETURN is_fully_picked_;
END Is_Shpmnt_Hu_Fully_Picked;


-------------------- LU  NEW METHODS -------------------------------------