-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValuePart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220104  MAJOSE  SC21R2-5108, Get rid of string manipulations in New() and Modify().
--  120127  MaEelk  Corrected the DATE FORMAT of create_date in view comments.
--  110719  MaEelk  Added user allowed site filter to INVENTORY_VALUE_PART_LEVEL_EXT, INVENT_VALUE_LOCGRP_LEVEL_EXT
--  110719          INVENTORY_VALUE_PART_SUM_EXT and INVENT_VALUE_LOCGRP_SUM_EXT .
--  110322  UMDOLK  EANE-5175, Added user allowed site filter into inventory_value_part_local_1.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090902  SuSalk  Description view column length increased to 200 in column comments of 
--                  INVENTORY_VALUE_PART_SUM_EXT, INVENTORY_VALUE_PART_LEVEL_EXT, 
--                  INVENT_VALUE_LOCGRP_SUM_EXT and INVENT_VALUE_LOCGRP_LEVEL_EXT views.
--  070516  LEPESE  Modified method Get_For_Configuration: Now this method returns one set
--  070516          of quantities for each location_group found. 
--  061115  LEPESE  Added view INVENT_VALUE_PART_LOCGRP_LOV.
--  061110  LEPESE  Changed implementation method Get_Total_Company_Owned_Qty___ into
--  061110          a private method Get_Total_Company_Owned_Qty__. 
--  061108  LEPESE  Added views INVENT_VALUE_LOCGRP_LEVEL, INVENT_VALUE_LOCGRP_LEVEL_EXT,
--  061108          INVENT_VALUE_LOCGRP_SUM, INVENT_VALUE_LOCGRP_SUM_EXT.
--  061108          Added methods Get_Total_Company_Owned_Qty___, Get_Location_Group_Value__
--  061108          and Get_Unit_Cost__.
--  061025  LEPESE  Added new view INVENTORY_VALUE_PART_LOCAL_1. Used it as data source for
--  061025          view INVENTORY_VALUE_PART_LEVEL.
--  061024  LEPESE  Added new key column location_group.
--  060815  Asawlk  Bug 59253, Fixed a miscoding in the cursor get_attr in Get_For_Configuration.
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060620  KaDilk  Added views INVENTORY_VALUE_PART_COND_EXT and INVENTORY_VALUE_PART_CONDITION. 
--  ------------------------- 13.4.0 ------------------------------------------
--  051129  LEPESE  Bug correction in view INVENTORY_VALUE_PART_LEVEL.
--  051122  LEPESE  Created views INVENTORY_VALUE_PART_LEVEL, INVENTORY_VALUE_PART_LEVEL_EXT,
--  051122          INVENTORY_VALUE_PART_SUM, INVENTORY_VALUE_PART_SUM_EXT.
--  051118  LEPESE  Added method Get_For_Configuration.
--  051117  LEPESE  Added method Remove.
--  051117  LEPESE  Added new key columns lot_batch_no, serial_no, condition_code.
--  051117          Removed obsolete attributes total_standard and total_value.
--  051115  LEPESE  Removed methods Get_Previous_Value and Get_Last_Value.
--  040513  RoJalk  Bug 42037, Added parameters prev_stat_year_no_,prev_stat_period_no_
--  040513          and removed date_applied_ and modified method Get_Previous_Value.
--  **************  Touchdown Merge Begin  *********************
--  040223  LEPESE  Removed rounding of total_value from methods insert___ and update___.
--  **************  Touchdown Merge End    *********************
--  040301  GeKalk  Removed substrb from the view for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  031022  LEPESE  Removed public cursor Get_Simulate_Part_Cur.
--  020426  ANHO    Bug Id 26791. Added stat_year_no_ and stat_period_no_ to Get_Last_Value and Get_Previous_Value.
--  001130  LEPE    Made several attributes public.
--  000928  JOHW    Changed prompt from Configuration Id to Configuration ID.
--  000926  JOKE    Added method Get_Last_Value.
--  000925  JOHESE  Added undefines.
--  000921  JOKE    Added vendor_owned_qty.
--  000920  JOHW    Added configuration_id.
--  000518  LEPE    Added DESC option to cursor in method Get_Previous_Value.
--  000505  ANHO    Replaced call to USER_DEFAULT_API.Get_Contract with USER_ALLOWED_SITE_API.Get_Default_Site.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_Previous_Value.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990505  SHVE    General performance improvements.
--                  Removed method Check_If_Inv_Val_Exists___
--  990427  ROOD    Changed usage of public view from LU InventoryPart.
--  990414  SHVE    Upgraded to performance optimized template.
--  990404  JOKE    Added qty_in_transit_, qty_at_customer_ as parameters in
--                  methods Get_Previous_Value, New and Modify.
--  990401  JOHW    Added attributes qty_in_transit and qty_at_customer.
--  990223  JOKE    Changed order of Primary Key to adapt to new model.
--  990222  JOKE    Removed view INVENTORY_VALUE_DISTINCT since that is replaced
--                  by the Inventory_Value LU.
--  990213  JOKE    Added public method: Modify.
--  990212  JOKE    Modified Get_Previous_Value.
--  990212  JOKE    Added public cursor Get_Simulate_Part_Cur.
--  990210  JOKE    Renamed InventoryValue TO InventoryValuePart.
--  990210  ROOD    Removed obsololete methods Get_Previous_Value_Sum, Check_Period_Exists
--                  and Count_Parts_in_Period. Removed method Modify_Inventory_Value since
--                  it will be moved to a utility LU.
--  990210  RaKu    Added prefix in viewdefinition INVENTORY_VALUE_EXTENDED for
--                  upgrade reasons.
--  990209  RaKu    Added view INVENTORY_VALUE_EXTENDED.
--  990209  ROOD    Removed str_code, second_commodity and cost_set. Added attribute total_standard.
--                  Major changes due to these attribute changes.
--  990209  RaKu    Added view INVENTORY_VALUE_DISTINCT.
--  990112  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981202  SHVE    Commented calls to Cost_Set and Cost_Type_Cost_Set.
--  981122  FRDI    Full precision for UOM, change comments in tab.
--  980305  JICE    Bug 3651, JOHNIs 10.3.1-changes: Major changes in inventory
--                  statistics batch.
--                  Added functions Check_Part_Period_Exist and Count_Parts_In_Period.
--                  Modified Modify_Inventory_Value.
--  980216  FRDI     Format on Amount Columns.
--  971128  GOPE    Upgrade to fnd 2.0
--  971106  GOPE    removed transaction POINV in the inventory value counting
--  970926  JOKE    Corrected previous changes to use iid-lu instead.
--  970926  JOKE    Changed system parameter sum_str_codes from 'J' to 'Y'.
--  970919  GOPE    BUG 97-0090 change method Modify_Inventory_Value Count quantity just once
--  970312  CHAN    Changed table name: mpc_inventory_value is replace by
--                  inventory_value_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970116  MAOR    Made changes in Modify_Inventory_Value.(Changed order of
--                  parameter in call to
--                  Mpccom_Transaction_Code_API.Check_Valid_Transaction_Code.
--  961214  MAOR    Removed batch-user. Removed user from New and
--                  Modify_Inventory_Value.
--  961213  AnAr    Modified file for new template standard.
--  961205  MAOR    Changed order of parameters in call to
--                  Inventory_Part_Cost_API.Get_Standard_Total. Also changed name
--                  to Get_Total_Standard.
--  961125  MAOR    Changed to Rational Rose Model standard and Workbench.
--  961122  MAOR    Moved procedure Insert_Inventory_Value__ to LU InventoryPart.
--                  Added function Check_Period_Exist and procedures New,
--                  Get_Previous_Value and Get_Previous_Value_Sum.
--  961118  JOBE    Changed function call Mpccom_System_Parameter_API.Get_Value to
--                  Mpccom_System_Parameter_API.Get_Parameter_Value1.
--  961114  JOBE    Changed function name Get_Transaction to Check_Valid_Transaction_Code.
--  961015  MAOR    Added user_ in procedure Update_Inventory_Value and
--                  Insert_Inventory_Value__. Added check if batch_user is in
--                  attr_ in procedure Unpack_Check_Insert__.
--  961010  MAOR    Added exception in procedure Insert___, Update___,
--                  Unpack_Check_Update___, Unpack_Check_Insert___.
--                  Changed declaration of local variables to be number instead
--                  of column length in table.
--  961003  MAOR    Changed handle of notfound in procedure
--                  Insert_Inventory_Value__,cursor Get_Previous_Value_Sum
--  960903  MAOR    Changed call to INVENTORY_PART_COST_API.Get_Total_Standard
--                  to be INVENTORY_PART_COST_API.Get_Standard_Total in procedure
--                  Update_Inventory_Value.
--  960826  MAOR    Added function Check_If_Inv_Val_Exists and procedure
--                  Update_Inventory_Value, Insert_Inventory_Value__.
--  960607  JOBE    Added functionality to CONTRACT.
--  960508  SHVE    Replaced the old code.
--  960506  SHVE    Replaced table reference to Ac_Am_Str_Code with call to their
--                  package - POSTING_CTRL_STR_CODE_API.
--  960307  JICE    Renamed from InvInventoryValue
--  951006  STOL    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Location_Group_Quantities_Rec IS RECORD (
   location_group   inventory_value_part_tab.location_group%TYPE,
   qty_waiv_dev_rej inventory_value_part_tab.qty_waiv_dev_rej%TYPE,
   quantity         inventory_value_part_tab.quantity%TYPE,
   qty_in_transit   inventory_value_part_tab.qty_in_transit%TYPE,
   qty_at_customer  inventory_value_part_tab.qty_at_customer%TYPE,
   vendor_owned_qty inventory_value_part_tab.vendor_owned_qty%TYPE);

TYPE Location_Group_Quantities_Tab IS TABLE OF Location_Group_Quantities_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT',USER_ALLOWED_SITE_API.Get_Default_Site,attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_value_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Location_Group_Value__ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   location_group_   IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   quantity_  NUMBER;
   value_     NUMBER;
   unit_cost_ NUMBER;

BEGIN
   unit_cost_ := Get_Unit_Cost__(contract_,
                                 stat_year_no_,
                                 stat_period_no_,
                                 part_no_,
                                 configuration_id_,
                                 lot_batch_no_,
                                 serial_no_,
                                 condition_code_);

   quantity_ := Get_Total_Company_Owned_Qty__(contract_,
                                              stat_year_no_,
                                              stat_period_no_,
                                              part_no_,
                                              configuration_id_,
                                              lot_batch_no_,
                                              serial_no_,
                                              condition_code_,
                                              location_group_);
   value_ := unit_cost_ * quantity_;

   RETURN (NVL(value_,0));
END Get_Location_Group_Value__;


@UncheckedAccess
FUNCTION Get_Unit_Cost__ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   total_quantity_ NUMBER;
   total_value_    NUMBER;
   unit_cost_      NUMBER;
BEGIN
   total_quantity_ := Get_Total_Company_Owned_Qty__(contract_,
                                                    stat_year_no_,
                                                    stat_period_no_,
                                                    part_no_,
                                                    configuration_id_,
                                                    lot_batch_no_,
                                                    serial_no_,
                                                    condition_code_,
                                                    NULL);

   total_value_ := Invent_Value_Part_Detail_API.Get_Total_Value__(contract_,
                                                                  stat_year_no_,
                                                                  stat_period_no_,
                                                                  part_no_,
                                                                  configuration_id_,
                                                                  lot_batch_no_,
                                                                  serial_no_,
                                                                  condition_code_);
   IF (total_quantity_ = 0) THEN
      total_quantity_ := 1;
   END IF;

   unit_cost_ := total_value_ / total_quantity_;

   RETURN (NVL(unit_cost_,0));
END Get_Unit_Cost__;


@UncheckedAccess
FUNCTION Get_Total_Company_Owned_Qty__ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2 ) RETURN NUMBER
IS
   total_company_owned_qty_ NUMBER;

   CURSOR get_total_company_owned_qty IS
      SELECT SUM(quantity + qty_waiv_dev_rej + qty_in_transit + qty_at_customer)
        FROM INVENTORY_VALUE_PART_TAB
       WHERE  stat_year_no     = stat_year_no_
         AND  stat_period_no   = stat_period_no_
         AND  contract         = contract_
         AND  part_no          = part_no_
         AND  configuration_id = configuration_id_
         AND  condition_code   = condition_code_
         AND  lot_batch_no     = lot_batch_no_
         AND  serial_no        = serial_no_
         AND (location_group   = location_group_ OR location_group_ IS NULL);
BEGIN
   OPEN  get_total_company_owned_qty;
   FETCH get_total_company_owned_qty INTO total_company_owned_qty_;
   CLOSE get_total_company_owned_qty;

   RETURN(NVL(total_company_owned_qty_,0));
END Get_Total_Company_Owned_Qty__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new instance of this class.
PROCEDURE New (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2,
   qty_waiv_dev_rej_ IN NUMBER,
   quantity_         IN NUMBER,
   qty_in_transit_   IN NUMBER,
   qty_at_customer_  IN NUMBER,
   vendor_owned_qty_ IN NUMBER,
   create_date_      IN DATE )
IS
   newrec_      INVENTORY_VALUE_PART_TAB%ROWTYPE;
BEGIN
   newrec_.contract           := contract_;
   newrec_.stat_year_no       := stat_year_no_;
   newrec_.stat_period_no     := stat_period_no_;
   newrec_.part_no            := part_no_;
   newrec_.configuration_id   := configuration_id_;
   newrec_.lot_batch_no       := lot_batch_no_;
   newrec_.serial_no          := serial_no_;
   newrec_.condition_code     := condition_code_;
   newrec_.location_group     := location_group_;
   newrec_.qty_waiv_dev_rej   := qty_waiv_dev_rej_;
   newrec_.quantity           := quantity_;
   newrec_.qty_in_transit     := qty_in_transit_;
   newrec_.qty_at_customer    := qty_at_customer_;
   newrec_.vendor_owned_qty   := vendor_owned_qty_;
   newrec_.create_date        := create_date_;
   
   New___(newrec_);
END New;


-- Modify
--   Modifies a instance of this class.
PROCEDURE Modify (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2,
   qty_waiv_dev_rej_ IN NUMBER,
   quantity_         IN NUMBER,
   qty_in_transit_   IN NUMBER,
   qty_at_customer_  IN NUMBER,
   vendor_owned_qty_ IN NUMBER )
IS
   newrec_     INVENTORY_VALUE_PART_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_,
                                    stat_year_no_,
                                    stat_period_no_,
                                    part_no_,
                                    configuration_id_,
                                    lot_batch_no_,
                                    serial_no_,
                                    condition_code_,
                                    location_group_);

   newrec_.create_date := Site_API.Get_Site_Date(contract_);
   newrec_.qty_waiv_dev_rej := qty_waiv_dev_rej_;
   newrec_.quantity := quantity_;
   newrec_.qty_in_transit := qty_in_transit_;
   newrec_.qty_at_customer := qty_at_customer_;
   newrec_.vendor_owned_qty := vendor_owned_qty_;

   Modify___(newrec_);
END Modify;


-- Remove
--   Removes an instance of this class.
PROCEDURE Remove (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2 )
IS
   remrec_     INVENTORY_VALUE_PART_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(contract_,
                              stat_year_no_,
                              stat_period_no_,
                              part_no_,
                              configuration_id_,
                              lot_batch_no_,
                              serial_no_,
                              condition_code_,
                              location_group_);

   Check_Delete___(remrec_);
   Delete___(NULL, remrec_);
END Remove;


-- Get_For_Configuration
--   Returns a record containing the summarized quantity information for
--   one configuration of an inventory part in a specific statistical period.
@UncheckedAccess
FUNCTION Get_For_Configuration (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN Location_Group_Quantities_Tab
IS
   location_group_quantities_tab_ Location_Group_Quantities_Tab;
   CURSOR get_attr IS
      SELECT location_group,
             SUM(qty_waiv_dev_rej) qty_waiv_dev_rej,
             SUM(quantity)         quantity,
             SUM(qty_in_transit)   qty_in_transit,
             SUM(qty_at_customer)  qty_at_customer,
             SUM(vendor_owned_qty) vendor_owned_qty
      FROM INVENTORY_VALUE_PART_TAB
      WHERE contract         = contract_
      AND   stat_year_no     = stat_year_no_
      AND   stat_period_no   = stat_period_no_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_
      GROUP BY location_group;
BEGIN
   OPEN get_attr;
   FETCH get_attr BULK COLLECT INTO location_group_quantities_tab_;
   CLOSE get_attr;
   RETURN location_group_quantities_tab_;
END Get_For_Configuration;



