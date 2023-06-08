-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderPickList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210111  MaEelk  SC2020-12023, Replaced the logic inside New with NEw___. Revoved the unnecessary caall to Client_SYS.Add_to_attr from Modify_Default_Ship_Location.
--  191023  SBalLK  Bug 150436 (SCZ-6914), Added Homogeneous_Location_Group() method.
--  171024  SBalLK  Bug 138299, Modified Set_Picking_Confirmed() method to fetch pick list connected site when the contract parameter is NULL.
--  170726  RuLiLk  Bug 136433 Modified method Set_Consolidated_Orders to append consolidated order numbers to existing list if the pick list already exists.
--  170406  Jhalse  LIM-11096, Removed method Check_Pick_List_Use_Ship_Inv as it was now obsolete.
--  170323  Jhalse  LIM-10113, Added method Modify_Ship_Inventory_Loc_No to allow update of the this value when picking.
--  170317  Jhalse  LIM-10113, Changed how Modify_Default_Ship_Location fetches its value, also reworked method on how to get a confirm shipment location from a pick list.
--  170307  Jhalse  LIM-10113, Removed error handling for Modify_Default_Ship_Location as this is now checked in the picking process for a more consistent behaviour.
--  170202  UdGnlk  LIM-10483 Added Lock_By_Keys_And_Get() to support move reservation with transport task.
--  161108  RoJalk  LIM-9412, Modified Insert___ and used Inventory_Pick_List_API.Get_Next_Pick_List_No to get next pick list no.
--  151106  MaEelk  LIM-4453, Removed pallet_id from Set_Picking_Confirmed
--  151103  JeLise  LIM-4392, Removed check on pallet_id in Set_Picking_Confirmed.
--  141213  MeAblk  Added new method Check_Ship_Inv_Loc_Required.
--  140604  MAHPLK  Added new attribute storage_zone_id to LU and parameter storage_zone_id_ to Set_Selection, 
--  140212  MAHPLK  Made attribute sel_consol_shipment_id public and added method Get_Sel_Consol_Shipment_Id.
--  140130  MAHPLK  Modified Get_First_Shipment_Id to use Client_SYS.text_separator_ as text separator.
--  131030  MaMalk  Made create_date mandatory. Changed the view lengths of printed_flag_db, picking_confirmed_db, consolidated_flag_db, pick_inventory_type_db
--  131030          and sel_include_cust_orders_db according to the table length.
--  130509  MAHPLK  Added sel_shipment_id, sel_consol_shipment_id, sel_shipment_type, sel_ship_date sel_shipment_location and max_ship_on_pick_list. 
--  130509          Modified method Set_Selections. Renamed existing sel_ship_date column to sel_due_date.
--  130418  MAHPLK  Added new method Get_First_Shipment_Id.
--  130405  MAHPLK  Added public attribute shipments_consolidated to LU.
--  130110  MHAPLK  Added private attribute sel_include_cust_orders and removed sel_pick_all_lines_in_co.
--  121207  MAHPLK  Added private attribute SelStorageZone.
--  121129  RoJalk  Modified Unpack_Check_Insert___ and removed newrec_.shipment_id != '0' when calling Shipment_API.Exist. 
--  120731  MeAblk  Added methods Check_Pick_List_Exist, Check_Pick_List_Use_Ship_Inv.
--  120725  MeAblk  Added procedure Modify_Pick_Ship_Location in order to update the default shipment inventory location of unpicked,
--  120725          consolidated shipment pick lists when pick reporting with diviating shipment inventory location.
--  120327  MalLlk  Modified Modify_Default_Ship_Location to fetch a value for Ship_Inventory_Location_No from Shipment_API.
--  120123  ChJalk  Modified view comments of base view to remove 'N'.
--  111007  SudJlk  Bug 99275, Modified Update___ to update the objversion when the object is modified.
--  110711  MaMalk  Added the user allowed site filteration to the base view.
--  100520  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090831  ChFolk  Bug 84675, Added new table columns sel_order_type, sel_coordinator and sel_priority and do the necessary modifications
--  090831          in base view, Unpack_Check_Insert___, Insert___, Unpack_Check_Update___, Update___ and
--  090831          Modified Set_Selections by adding parameters sel_order_type_, sel_coordinator_ and sel_priority.
--  090610  DaGulk  Bug 83694, Removed method Exist_Pick_Lists_For_Order.
--  090528  SudJlk  Bug 80756, Added method Exist_Pick_Lists_For_Order.
--  090226  NaLrlk  Added method Check_Before_Update___ and modified the code accordingly.
--  090225  KiSalk  Added method Modify_Default_Ship_Location and replaced inventory_location_tab with warehouse_bay_bin_tab.
--  090225  Kisalk  Added public attribute ship_inventory_location_no. Added contract to view customer_order_pick_list.
--  071123  SaJjlk  Bug 68581,Made attribute SHIPMENT_ID public and added method Get_Shipment_Id.
--  070222  MaJalk  Added few parameters and modified method Set_Selections.
--  060112  IsWilk  Modified the PROCEDURE Insert__ according to template 2.3.
--  050922  NaLrlk  Removed unused variables.
--  050714  SaJjlk  Added method Unreported_Pick_Lists_Exist.
--  050105  NuFilk  Added new parameter shipment_id_ for the method Set_Selections.
--  040224  IsWilk  Removed SUBSTRB from the view for Unicode Changes.
--  040121  PrTilk  Bug 41402, Modified method Set_Consolidated_Orders. Changed the attr_ length to 32000.
--  040102  IsWilk  Bug 39282, Added the parameter create_date to the FUNCTION New
--  040102          and set the insertable flag to the create_date and modified the
--  040102          procedures Unpack_Check_Insert___, Insert___.
--  ********************* VSHSB Merge End*****************************
--  020219  MaGu  Added new parameter shipment_id to method New.
--  020208  MaGu  Added new attribute shipment_id.
--  ********************* VSHSB Merge Start*****************************
--  001031  JakH  Added get_*_db functions.
--  000913  FBen  Added UNDEFINED.
--  991021  PaLj  Removed Function Order_On_Quick which was added some days ago.
--  991011  PaLj  Moved view PRINT_PICK_LIST_JOIN to ordpick.apy
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990909  PaLj  Changed VIEW PRINT_PICK_LIST_JOIN
--  990830  PaLj  Added VIEW PRINT_PICK_LIST_JOIN
--  990823  PaLj  Changed VIEW CUSTOMER_ORDER_PICK_LIST
--  990823  PaLj  Added Procedure Get_Consolidated_Flag, Get_Consolidated_Orders
--  990601  JoEd  Call id 18477: Added contract and pallet_id to Set_Picking_Confirmed.
--                Moved Report_Task___ code to same method.
--  990414  JoAn  Removed obsolete methods Order_Pick_List_Not_Picked,
--                Order_Pick_List_Not_Printed.
--  990412  JoAn  Changed implementation of the Set_Picking_Confirmed and Set_Printed_Flag
--                methods
--  990408  JoAn  Y.CID 10557 Adapted to F1 2.2.1 template
--  990406  JakH  Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  990113  JoEd  Changed call to WarehouseTask in Report_Task___.
--  990112  JoEd  Added method Report_Task___ for warehouse task reporting.
--  971124  RaKu  Changed to FND200 Templates.
--  970522  JOED  Added _db columns in the view for all IID columns.
--                Rebuild the Get_... methods using Get_Instance___.
--  970425  RaKu  Added check of picking_confirmed in procedure Update___.
--  970408  RaKu  Removed function Connected_To_Shipment_List.
--  970401  RaKu  Changed shipped_conf to picking_confirmed and all code
--                connected to it. Renamed funtions to Get_Picking_Confirmed,
--                Set_Picking_Confirmed and Order_Pick_List_Not_Picked.
--                Added function Connected_To_Shipment_List.
--  970312  RaKu  Changed table name.
--  970219  EVWE  Changed to rowversion (10.3 Project)
--  960417  JOAN  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Before_Update___ (
   newrec_ IN OUT CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE,
   oldrec_ IN     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE )
IS
BEGIN

   IF (newrec_.pick_inventory_type = 'SHIPINV') THEN
      IF (NVL(oldrec_.ship_inventory_location_no, CHR(32)) != NVL(newrec_.ship_inventory_location_no, CHR(32))) THEN
         IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
            IF (Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.ship_inventory_location_no) != 'SHIPMENT') THEN
               Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: The location :P1 is not a shipment location.', newrec_.ship_inventory_location_no);
            END IF;
         ELSE
            Error_SYS.Record_General(lu_name_,'NOTSHIPINVLOC: The shipment inventory location must have a value.');
         END IF;
      END IF;
   END IF;
END Check_Before_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Retrieve a new pick_list_no
   newrec_.pick_list_no := TO_CHAR(Inventory_Pick_List_API.Get_Next_Pick_List_No());
   
   Client_SYS.Add_To_Attr('PICK_LIST_NO', newrec_.pick_list_no, attr_);

   newrec_.source := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('SOURCE', newrec_.source, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.picking_confirmed != oldrec_.picking_confirmed) AND
      (newrec_.picking_confirmed = 'UNPICKED') THEN
      Error_SYS.Record_General(lu_name_, 'PICKLISTPICKED: Cannot set an already pick reported picklist to unpicked.');
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_pick_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- Assign default values for new record
   IF (indrec_.printed_flag = FALSE) THEN
      newrec_.printed_flag := 'N';
   END IF; 
   IF (indrec_.picking_confirmed = FALSE) THEN
      newrec_.picking_confirmed := 'UNPICKED';
   END IF; 
   IF (indrec_.consolidated_flag = FALSE) THEN
      newrec_.consolidated_flag := 'NOT CONSOLIDATED';
   END IF; 

   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_pick_list_tab%ROWTYPE,
   newrec_ IN OUT customer_order_pick_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Check_Before_Update___(newrec_, oldrec_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_First_Shipment_Id
--   This method returns the first shipment id from consolidate shipment list, to a given pick list.
@UncheckedAccess
FUNCTION Get_First_Shipment_Id (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   pos_          PLS_INTEGER;
   shipment_ids_ CUSTOMER_ORDER_PICK_LIST_TAB.shipments_consolidated%TYPE;
   separator_    VARCHAR2(1) := Client_SYS.text_separator_;
   CURSOR get_attr IS
      SELECT shipments_consolidated
      FROM   CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE  pick_list_no = pick_list_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO shipment_ids_;
   CLOSE get_attr;
   
   pos_ := INSTR(shipment_ids_, separator_ , 1, 1);
   IF (pos_ = 0) OR (shipment_ids_ IS NULL)THEN
      RETURN TO_NUMBER(shipment_ids_);
   ELSE
      RETURN TO_NUMBER(SUBSTR(shipment_ids_, 1 ,pos_ - 1));
   END IF;
END Get_First_Shipment_Id;


-- New
--   Create a new pick list from another logical unit.
FUNCTION New (
   order_no_            IN VARCHAR2,
   pick_inventory_type_ IN VARCHAR2,
   shipment_id_         IN NUMBER DEFAULT NULL,
   create_date_         IN DATE ) RETURN VARCHAR2
IS
   newrec_       CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
BEGIN
   newrec_.order_no := order_no_;
   newrec_.pick_inventory_type := pick_inventory_type_;
   newrec_.shipment_id := shipment_id_;
   newrec_.create_date := create_date_;
   newrec_.contract := Customer_Order_Api.Get_Contract(order_no_);
   New___(newrec_);  
   RETURN newrec_.pick_list_no;
END New;


-- Set_Printed_Flag
--   Set the printed flag for the current LU instance.
PROCEDURE Set_Printed_Flag (
   pick_list_no_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_ CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.printed_flag := 'Y';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Printed_Flag;


-- Set_Picking_Confirmed
--   Set the picking confirmed flag for the current LU instance.
PROCEDURE Set_Picking_Confirmed (
   pick_list_no_ IN VARCHAR2,
   contract_     IN VARCHAR2 )
IS
   oldrec_        CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_        CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_         CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_    CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   attr_          VARCHAR2(2000);
   task_type_     VARCHAR2(200);
   temp_contract_ CUSTOMER_ORDER_PICK_LIST_TAB.contract%TYPE := contract_;
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.picking_confirmed := 'PICKED';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   -- IF the picklist was picked then report the warehouse task
   IF (newrec_.picking_confirmed != oldrec_.picking_confirmed) THEN
      task_type_ := Warehouse_Task_Type_API.Decode('CUSTOMER ORDER PICK LIST');
      IF (temp_contract_ IS NULL ) THEN
         temp_contract_ := newrec_.contract;
      END IF;
      Trace_SYS.Field('Now  calling Find_And_Report_Task_Source for picklist ',pick_list_no_);
      Trace_SYS.Field('Now  calling Find_And_Report_Task_Source for contract ',temp_contract_);
      Trace_SYS.Field('Now  calling Find_And_Report_Task_Source for picklist ',task_type_);
      Warehouse_Task_API.Find_And_Report_Task_Source(temp_contract_, 
                                                     task_type_, 
                                                     pick_list_no_, 
                                                     NULL, NULL, NULL);
   END IF;
END Set_Picking_Confirmed;


-- Get_Order_Pick_Lists
--   Return all unprinted pick lists for the specified order in a list
--   separated by ASCII 31 characters.
PROCEDURE Get_Order_Pick_Lists (
   pick_list_list_  OUT VARCHAR2,
   order_no_        IN  VARCHAR2 )
IS
   list_    VARCHAR2(2000);

   CURSOR get_pick_lists IS
      SELECT pick_list_no
      FROM   CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE  order_no = order_no_
      AND    printed_flag = 'N';
BEGIN
   list_ := NULL;
   FOR rec_ IN get_pick_lists LOOP
      list_ := list_ || rec_.pick_list_no || Client_SYS.field_separator_;
   END LOOP;
   pick_list_list_ := list_;
END Get_Order_Pick_Lists;


-- Set_Consolidated
--   This sets the consolidated Pick List flag
PROCEDURE Set_Consolidated (
   pick_list_no_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_ CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.consolidated_flag := 'CONSOLIDATED';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Consolidated;


-- Set_Consolidated_Orders
--   This sets the order numbers of the orders incuded in the Consolidated Pick List
PROCEDURE Set_Consolidated_Orders (
   pick_list_no_  IN VARCHAR2,
   order_no_list_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_ CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   orders_     VARCHAR2(2000);
   prev_consol_orders_   VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   prev_consol_orders_ := (Get_Consolidated_Orders(pick_list_no_));   
   IF prev_consol_orders_ IS NULL THEN
      orders_ := order_no_list_;
   ELSIF INSTR(prev_consol_orders_,order_no_list_)=0 THEN
      -- If the  sent order number list does not exisist for the pick list append.
      orders_ := prev_consol_orders_ || '^' || order_no_list_;
   END IF;
   IF orders_ IS NOT NULL THEN
      oldrec_ := Lock_By_Keys___(pick_list_no_);
      newrec_ := oldrec_;
      newrec_.consolidated_orders := orders_;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Set_Consolidated_Orders;


-- Set_Shipments_Consolidated
--   This sets the shipment ids of the shipments incuded in the Consolidated Pick List
PROCEDURE Set_Shipments_Consolidated (
   pick_list_no_     IN VARCHAR2,
   shipment_id_list_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_ CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.shipments_consolidated := shipment_id_list_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Shipments_Consolidated;


-- Set_Selections
--   This saves the Selections from the Create Consolidated Pick List Dialog
PROCEDURE Set_Selections (
   pick_list_no_              IN VARCHAR2,
   sel_contract_              IN VARCHAR2,
   sel_order_                 IN VARCHAR2,
   sel_customer_              IN VARCHAR2,
   sel_route_                 IN VARCHAR2,
   sel_ship_period_           IN VARCHAR2,
   sel_forward_agent_         IN VARCHAR2,
   sel_location_group_        IN VARCHAR2,
   consolidation_             IN VARCHAR2,
   sel_due_date_              IN DATE,
   sel_part_no_               IN VARCHAR2,
   sel_ship_via_code_         IN VARCHAR2,
   sel_include_cust_orders_   IN VARCHAR2,
   max_orders_on_pick_list_   IN NUMBER,
   sel_order_type_            IN VARCHAR2,
   sel_coordinator_           IN VARCHAR2,
   sel_priority_              IN NUMBER,
   sel_storage_zone_          IN VARCHAR2,
   shipment_id_               IN NUMBER,
   sel_ship_date_             IN DATE,
   sel_shipment_id_           IN VARCHAR2,
   sel_consol_shipment_id_    IN VARCHAR2,   
   sel_shipment_type_         IN VARCHAR2,
   sel_shipment_location_     IN VARCHAR2,
   max_ship_on_pick_list_     IN NUMBER,
   storage_zone_id_           IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_ CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.contract := sel_contract_;
   newrec_.sel_order := sel_order_;
   newrec_.sel_customer := sel_customer_;
   newrec_.sel_route := sel_route_;
   newrec_.sel_due_date := sel_due_date_;
   newrec_.sel_ship_period := sel_ship_period_;
   newrec_.sel_forward_agent := sel_forward_agent_;
   newrec_.sel_location_group := sel_location_group_;
   newrec_.consolidation := consolidation_;
   newrec_.sel_part_no := sel_part_no_;
   newrec_.sel_ship_via_code := sel_ship_via_code_;
   newrec_.sel_include_cust_orders := sel_include_cust_orders_;
   newrec_.sel_max_orders_on_picklist := max_orders_on_pick_list_;
   newrec_.shipment_id := shipment_id_;
   newrec_.sel_order_type := sel_order_type_;
   newrec_.sel_coordinator := sel_coordinator_;
   newrec_.sel_priority := sel_priority_;
   newrec_.sel_storage_zone := sel_storage_zone_;
   newrec_.sel_ship_date := sel_ship_date_;
   newrec_.sel_shipment_id := sel_shipment_id_;
   newrec_.sel_consol_shipment_id := sel_consol_shipment_id_;
   newrec_.sel_shipment_type := sel_storage_zone_;
   newrec_.sel_shipment_location := sel_shipment_location_;
   newrec_.sel_max_ship_on_picklist := max_ship_on_pick_list_;
   newrec_.storage_zone_id := storage_zone_id_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Selections;


-- Uses_Shipment_Inventory
--   Reurns true (1) if this picklist uses shipment inventory
@UncheckedAccess
FUNCTION Uses_Shipment_Inventory (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_PICK_LIST_TAB.pick_inventory_type%TYPE;
   CURSOR get_type IS
      SELECT pick_inventory_type
      FROM CUSTOMER_ORDER_PICK_LIST_TAB
      WHERE pick_list_no = pick_list_no_;
BEGIN
   OPEN get_type;
   FETCH get_type INTO temp_;
   IF (temp_ = 'SHIPINV') THEN
      CLOSE get_type;
      RETURN 1;
   ELSE
      CLOSE get_type;
      RETURN 0;
   END IF;
END Uses_Shipment_Inventory;


-- Is_Consolidated
--   Returns 1 if the pick list is consolidated. If not it returns 0
@UncheckedAccess
FUNCTION Is_Consolidated (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Get_Consolidated_Flag(pick_list_no_) =
       Consolidated_Pick_List_API.Decode('CONSOLIDATED')) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Consolidated;


-- Unreported_Pick_Lists_Exist
--   This method is used to check whether unreported pick lists exist
--   for a given shipment identity.
@UncheckedAccess
FUNCTION Unreported_Pick_Lists_Exist (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_            NUMBER;
   pick_lists_exist_ VARCHAR2(5) := 'FALSE';

   CURSOR check_exist IS
      SELECT 1      
      FROM  CUSTOMER_ORDER_PICK_LIST_TAB cop, consolidated_orders_tab con
      WHERE con.shipment_id = shipment_id_
      AND   con.pick_list_no = cop.pick_list_no
      AND   cop.picking_confirmed = 'UNPICKED';
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
       pick_lists_exist_ := 'TRUE';
   END IF;
   CLOSE check_exist;
   RETURN pick_lists_exist_;
END Unreported_Pick_Lists_Exist;


PROCEDURE Modify_Default_Ship_Location (
   pick_list_no_ IN  VARCHAR2 )
IS
   oldrec_         CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_         CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   objid_          CUSTOMER_ORDER_PICK_LIST.objid%TYPE;
   objversion_     CUSTOMER_ORDER_PICK_LIST.objversion%TYPE;
   pick_list_rec_  Public_Rec;
   attr_           VARCHAR2(2000);
   ship_inv_loc_   CUSTOMER_ORDER_PICK_LIST_TAB.ship_inventory_location_no%TYPE;
   
BEGIN
   pick_list_rec_ := Get(pick_list_no_);
   -- Ship inventory location no is required for shipment inventory.
   IF (pick_list_rec_.pick_inventory_type = 'SHIPINV') THEN
      -- Fetch correct value from Shipment->SCM->Site
      IF (pick_list_rec_.ship_inventory_location_no IS NULL) THEN
         ship_inv_loc_ := Pick_Shipment_API.Get_Default_Shipment_Location(pick_list_no_);
         oldrec_ := Lock_By_Keys___(pick_list_no_);
         newrec_ := oldrec_;
         newrec_.ship_inventory_location_no := ship_inv_loc_;
         Check_Before_Update___(newrec_, oldrec_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;
END Modify_Default_Ship_Location;


-- Modify_Pick_Ship_Location
--   This method is used to update the default shipment inventory location of unpicked,
--   consolidated shipment pick lists when pick reporting with diviating shipment inventory location.
PROCEDURE Modify_Pick_Ship_Location (
   shipment_id_ IN NUMBER,
   location_no_ IN VARCHAR2 )
IS
   CURSOR get_all_picked_lists IS
      SELECT DISTINCT cop.pick_list_no
      FROM CUSTOMER_ORDER_PICK_LIST_TAB cop, consolidated_orders_tab con
      WHERE con.shipment_id  = shipment_id_
      AND   con.pick_list_no = cop.pick_list_no
      AND   cop.picking_confirmed = 'UNPICKED'
      AND   cop.consolidated_flag = 'CONSOLIDATED'
      AND   cop.ship_inventory_location_no != location_no_;
   
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_all_picked_lists LOOP
      oldrec_ := Lock_By_Keys___(rec_.pick_list_no);
      newrec_ := oldrec_;
      newrec_.ship_inventory_location_no := location_no_;
      Check_Before_Update___(newrec_, oldrec_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);     
   END LOOP;   
END  Modify_Pick_Ship_Location ;  

-- Check_Pick_List_Exist
--   This method checks whether there exist at least one unpicked, consolidated shipment pick list with a diviating default
--   shipment inventory from a considered shipment inventory location for a considered shipment.
@UncheckedAccess
FUNCTION Check_Pick_List_Exist (
   shipment_id_ IN NUMBER,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   exist_ VARCHAR2(5) := 'FALSE';
   CURSOR exist_pick_list IS
      SELECT 1
      FROM  CUSTOMER_ORDER_PICK_LIST_TAB cop, consolidated_orders_tab con
      WHERE con.shipment_id = shipment_id_
      AND   con.pick_list_no = cop.pick_list_no
      AND   cop.picking_confirmed = 'UNPICKED'
      AND   cop.consolidated_flag = 'CONSOLIDATED'
      AND   cop.ship_inventory_location_no != location_no_;
BEGIN
   OPEN  exist_pick_list;
   FETCH exist_pick_list INTO dummy_;
   IF (exist_pick_list%FOUND) THEN
      exist_ := 'TRUE';
   END IF;   
   CLOSE exist_pick_list;
   RETURN exist_;
END Check_Pick_List_Exist;   


@UncheckedAccess
FUNCTION Check_Ship_Inv_Loc_Required (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   req_ship_inv_loc_ NUMBER := 0;
   rec_              Customer_Order_Pick_List_API.Public_Rec; 
BEGIN
   rec_ := Get(pick_list_no_);
   IF (rec_.pick_inventory_type = 'SHIPINV') THEN
      req_ship_inv_loc_ := 1;
   END IF;   
   RETURN req_ship_inv_loc_;
END Check_Ship_Inv_Loc_Required;    

FUNCTION  Lock_By_Keys_And_Get (           
   pick_list_no_      IN  VARCHAR2 )  RETURN Public_Rec
   
IS
   co_pick_list_rec_  CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;   
BEGIN
   co_pick_list_rec_ := Lock_By_Keys___(pick_list_no_);
   RETURN Get(pick_list_no_);                                            
END Lock_By_Keys_And_Get;


FUNCTION Get_Confirm_Ship_Location__(
   pick_list_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   confirm_shipment_location_ VARCHAR2(5) := 'TRUE';
   count_                     NUMBER := 0;

   CURSOR get_confirm_shipment_location IS
   SELECT DISTINCT st.confirm_shipment_location_db
     FROM create_pick_list_ship_join cpls, shipment_type st
      WHERE cpls.shipment_type = st.shipment_type
      AND pick_list_no = pick_list_no_;
      
   TYPE Confirm_Shipment_Location_Tab IS TABLE OF get_confirm_shipment_location%ROWTYPE INDEX BY PLS_INTEGER;
   confirm_shipment_location_tab_      Confirm_Shipment_Location_Tab;
BEGIN
   
   OPEN get_confirm_shipment_location;
   FETCH get_confirm_shipment_location BULK COLLECT INTO confirm_shipment_location_tab_;
   CLOSE get_confirm_shipment_location;
   
   count_ := confirm_shipment_location_tab_.COUNT;
   
   IF(count_ = 1) THEN
      -- There is only one value, so we can fetch it. Multiple values means that at least one is TRUE as TRUE trumps FALSE we fall back to default behaviour.
      confirm_shipment_location_ := confirm_shipment_location_tab_(1).confirm_shipment_location_db;
   END IF;

   RETURN confirm_shipment_location_;
END Get_Confirm_Ship_Location__;

PROCEDURE Modify_Ship_Inventory_Loc_No(
   pick_list_no_ IN VARCHAR2,
   location_no_  IN VARCHAR2)
IS
   oldrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_PICK_LIST_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(pick_list_no_);
   newrec_ := oldrec_;
   newrec_.ship_inventory_location_no := location_no_;
   Check_Before_Update___(newrec_, oldrec_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Ship_Inventory_Loc_No;

@UncheckedAccess
FUNCTION Homogeneous_Location_Group(
   pick_list_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   single_location_group_ BOOLEAN := FALSE;
BEGIN
   IF (Customer_order_Reservation_API.Get_Homogeneous_Location_Group(pick_list_no_) IS NOT NULL ) THEN
      single_location_group_ := TRUE;
   END IF;
   RETURN single_location_group_;
END Homogeneous_Location_Group;
