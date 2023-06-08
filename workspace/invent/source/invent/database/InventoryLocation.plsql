-----------------------------------------------------------------------------
--
--  Logical unit: InventoryLocation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220127  Aabalk  Bug 162269(SCZ-17476), Modified Create_Data_Capture_Lov() by moving condition to filter out receipts blocked locations from get_list_of_values_4 cursor to the view.
--  220112  DaZase  SC21R2-7047, Changed Create_Data_Capture_Lov() so for lov_id 3 there is now a check if its for Register Arrival and new flag is enabled we show warehouse info as description.
--  211216  SbalLK  SC21R2-2833, Modified Get_Remote_Warehouse() method to use warehouse micro cache through Get_Remote_Warehouse_Db() instead using Is_Remote().
--  210416  DiJwlk  SC21R2-955, Modified Create_Data_Capture_Lov() added else part for lov_id_ = 4 to clear lov_item_description_ for next iteration.
--  210223  BudKlk  Bug 157543(SCZ-13440), Modified Create_Data_Capture_Lov() to add a condtion to the lov_id_ 4 to exculde the receipts_blocked locations.
--  201203  LEPESE  SC2020R1-10961, Added parameters include_warehouse_id_ and exclude_remote_warehouses_ to method Create_Data_Capture_Lov. 
--  201203          Added logic to consider these new parameters when lov_id_ = 3. 
--  200601  Aabalk  SCSPRING20-1687, Added function Is_Location_In_Warehouse.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  190405  ChFolk  SCUXXW4-16439, Added record type location_details_rec and method Get_Location_Details which is used by Aurena client.
--  180126  SWiclk  STRSC-16210, Modified Create_Data_Capture_Lov() in order to exclude a location from cursor 3 and 9.
--  171114  SURBLK  Modified Create_Data_Capture_Lov, get_list_of_values_1 have location_type as one of the description columns.
--  171020  SURBLK  Modified Get_Location_No_If_Unique() by adding lov_id_ as a parameter.
--  171012  CKumlk  STRSC-12692, Modified Create_Data_Capture_Lov so cursor get_list_of_values_10 have location_type as one of the description columns.
--  170102  RuLiLk  Bug 133378, Modified method Create_Data_Capture_Lov() by introducing lov_id_ 10 to generate lov from the view INVENTORY_LOCATION11 for Move_Into_Stock process.
--  151125  JeLise  LIM-4470, Removed method Get_First_Free_Pallet_Storage.
--  151124  KhVese  LIM-4561, Added default parameter sql_where_expression_ to method Record_With_Column_Value_Exist(). 
--  151124          Also added new coursor to Create_Data_Capture_Lov().
--  151029  JeLise  LIM-3941, Removed Location_Type_Db_Is_Pallet and Is_Pallet_Location.
--  150903  DaZase  AFT-3274 and AFT-2988, Changed Create_Data_Capture_Lov so all cursors have location_name as one of the description columns.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150706  RILASE  COB-25, Added Is_Shipment_Location.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150429  DaZase  COB-18, Added lov_id 5 on Create_Data_Capture_Lov. Added method Record_With_Column_Value_Exist.
--  141121  DaZase  PRSC-3888, Changed Create_Data_Capture_Lov so cursor get_list_of_values_3 now uses INVENTORY_LOCATION25 view. 
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140513  DaZase  PBSC-8663, Added method Get_Location_No_If_Unique.
--  120827  DaZase  Added method Create_Data_Capture_Lov.
--  120608  MaEelk  Replaced the usage of Company_Distribution_Info_API with Company_Invent_Info_API.
--  1120130 MaEelk  Added code gen property to the view.
--  111021  MaEelk  Added UAS filter to INVENTORY_LOCATION7, INVENTORY_LOCATION10, INVENTORY_LOCATION11, INVENTORY_LOCATION13, 
--  111021          INVENTORY_LOCATION14, INVENTORY_LOCATION15 and INVENTORY_LOCATION18.
--  110526  ShKolk  Added General_SYS to Get_Location_No().
--  110308  DaZase  Removed obsolete PRIORITY column.
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100511  KRPELK  Merge Rose Method Documentation.
--  090924  MaEelk  Removed unused view INVENTORY_LOCATION9.
--  ------------------------------------ 14.0.0 -------------------------------
--  100406  JeLise  Added column receipts_blocked to INVENTORY_LOCATION6, INVENTORY_LOCATION7, INVENTORY_LOCATION8,
--                  INVENTORY_LOCATION9, INVENTORY_LOCATION13, INVENTORY_LOCATION15, INVENTORY_LOCATION19, 
--                  INVENTORY_LOCATION21, INVENTORY_LOCATION22, INVENTORY_LOCATION23 AND INVENTORY_LOCATION24.
--  100406  JeLise  Added loc.receipts_blocked = 'FALSE' in where statement on INVENTORY_LOCATION17.
--  100401  JeLise  Added loc.receipts_blocked = 'FALSE' in where statement on INVENTORY_LOCATION5, INVENTORY_LOCATION10, 
--                  INVENTORY_LOCATION11, INVENTORY_LOCATION14, INVENTORY_LOCATION18 and INVENTORY_LOCATION20.
--  100122  DaZase  Added FALSE parameter to call Get_Any_Location in BINPKG..Get_Any_Location.
--  091008  NaLrlk  Modified the INVENTORY_LOCATION view ref columns to NOCHECK check.
--  090826  ShKolk  Added characteristice columns to lov views.
--  090826  NaLrlk  Added characteristice columns to INVENTORY_LOCATION view.
--  090820  NaLrlk  Added characteristice columns to view INVENTORY_LOCATION5, INVENTORY_LOCATION11 and INVENTORY_LOCATION17.
--  090701  HoInlk  Removed General_SYS call from functions to maintain previous interface.
--  090626  HoInlk  Restructured LU to redirect to WarehouseBayBin.
--  090129  NaLrlk  Added VIEW26 (used in Warehousing Manager Task Planning).
--  080303  NiBalk  Bug 72023, Modified Check_Warehouse_Exist, to have a single return.
--  061120  LEPESE  Major redesign of change made 061117. We now call just one method in 
--  061120          package InventoryLocationManager from method Update__. The name of the method
--  061120          is Handle_Location_Group_Change. The purpose is same as below.
--  061117  LEPESE  Added calls to two methods in package Invent_Location_Group_Util_API in
--  061117          method Update___. The reason for this is that we need to create inventory
--  061117          transaction history records and postings when location_group is changed
--  061117          on an inventory location.
--  061106  NiBalk  Bug 60671, Modified the procedure Unpack_Check_Insert___, 
--  061106          in order to avoid special characters used by F1.
--  060905  IsWilk  Added the FUNCTION Check_Warehouse_Exist.
--  060803  IsWilk  Modified the LOV View VIEW 25 by adding the contract.
--  060731  IsWilk  Modified the LOV View VIEW 25 by adding the contract.
--  060711  NaLrlk  Added new LOV view VIEW25 , for Warehouse Location.
--  ------------------------------------ 13.4.0 -------------------------------
--  060212  GeKalk  Added LOCATION_TYPE_DB to view Inventory_Location17.
--  060118  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050920  NiDalk  Removed unused variables.
--  050525  RaKalk  Added method Arrival_Or_Quality_Location
--  040604  VeMolk  Bug 44034, Increased the column length of location_name in all the views containing this column.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ------------------------------------ 13.3.0 -------------------------------
--  020215  LEPESE  Added method Get_Control_Type_Values.
--  010618  SUSALK  Bug 21888 fixed, Added a new seperator and check the two srting values in 'Location_Exists_On_Site___'.
--  000925  JOHESE  Added undefines.
--  000511  ANLASE  Added new LOV views, VIEW19 - VIEW24, for Location_no in Query,
--                  added where clause contract=site in view5, view6, view8 and view17.
--  000503  SHVE    Removed obsolete overloaded methods Get_Location_Type,Get_Warehouse,Get_Bay_No,
--                  Get_Row_No,Get_Tier_No, Get_Bin_No with location_no as IN parameter.
--                  Removed view INVENTORY_LOCATION4 and implementation method Validate_Location_Group___.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000225  NISOSE  Extended lov in view Inventory_Location14.
--  000225  NISOSE  Removed shipment in view Inventory_Location6.
--  000218  LEPE    Added some location types to view INVENTORY_LOCATION17.
--  000209  LEPE    Replaced call to Pallet_Transport_Task_API to Transport_Task_API.
--  000112  LEPE    Added function Location_Type_Db_Is_Pallet.
--  991029  ANHO    Bug 12361; replaced commasigns in error message "EXISTONSITE".
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990709  MATA    Changed substr to substrb in VIEW definitions
--  990529  ROOD    Changed tags on error messages, to avoid multiple tags.
--  990526  LEPE    Improved the error message in method Validate_Location_Group___.
--  990503  ROOD    Removed method Get_Specific_Location.
--  990428  SHVE    Removed obsolete VIEW2,VIEW3,VIEW12.
--                  General performance improvements.
--  990414  SHVE    Upgraded to performance optimized template.
--  990330  LEPE    Added new LOV view, view18, for moving pallets in Purchase Arrival.
--  990316  JOHW    Added new LOV view, view17, only for To Location in Pallet Transport Task.
--  990226  ANHO    Made location_no uppercase on the column prompts on the views.
--  990226  JOHW    Correction in Get_First_Free_Pallet_Storage.
--  990203  JOHW    Added VIEW16 (used in Warehousing).
--  990127  ANHO    Made location_sequence public.
--  990125  LEPE    Added VIEW15 (used in Manufacturing).
--  981116  ANHO    Added VIEW14 (used on the defaultlocationtab on Inventory Part).
--  980903  SHVE    Added VIEW13(used    in Maintenance).
--  980826  SHVE    Added VIEW12(used in PURCH).
--  980820  SHVE    Changed LOV views VIEW5 and VIEW11.
--  980707  LEPE    Corrections of hard coded location types in view definitions. Bad spelling.
--  980625  GOPE    Added Get_Location_Type_Db to get the db value to be used in checks
--  980617  RaKu    Changed comments for VIEW11.
--  980615  GOPE    Add view for delivery from purchase
--  980615  SHVE    Added view no 10 for arrival and inspection locations.
--  980609  GOPE    Added IsPalletLocation
--  980415  LEPE    Added LOV view no 9 for manufacturing cell locations.
--  980408  LEPE    Added view no 8.
--  980326  SHVE    SID 1082:View6-Added flag 'L' for warehouse, bay_no,row_no,tier_no,bin_no(LOV)
--  971128  GOPE    Upgrade to fnd 2.0
--  971010  GOPE    Performance enhacements in method Get_Specific_Location
--  970917  GOPE    BUG 97-0170 added check on bay_no in method Get_Specific_Location
--  970611  LEPE    Added contract in functionality for Get_First_Free_Pallet_Storage.
--  970523  LEPE    Correction of syntax error in one Error_SYS message.
--  970509  LEPE    Changes to the views in order to increase performance.
--  970509  PELA    Small changes to please the Workbench.
--  970508  LEPE    Added LOV view no 7.
--  970429  PELA    Added function Get_Any_Location.
--  970428  JOKE    Added function Get_First_Free_Pallet_Storage.
--  970417  PEKR    Add Get_Location_Name.
--  970414  CHAN    Added new LOV for pallet
--  970410  GOPE    Added location_type column to the LOV-views
--  970319  MAGN    Changed view columnname location_type to location_group and function Get_location_Type.
--  970312  CHAN    Changed table name: locations is replace to
--                  inventory_location_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  961218  JOKE    Added rtrim(rpad(...,2000)) on Define Objversion.
--  961218  MAOR    Moved Get_Location_No to the begining of
--                  unpack_check_insert___.
--  961214  MAOR    Changed Get_Db_Value to Get_Client_Value.
--  961213  LEPE    Modified for new template standard.
--  961114  MAOR    Changed to new workbench.
--  961101  MAOR    Modified file to Rational Rose Model-standard.
--  961016  MAOR    Changed location_no to be rtrim(location_no) in procedure
--                  Get_Location_Strings.
--  960902  GOPE    Changes in cursor min max for bay an warehouse in function
--                  Get_Specific_Location
--  960828  GOPE    Changes in the FUNCTION Get_Specific_Location
--  960613  GOPE    Removed the pragma comment for function Get_Location_Type
--  960529  LEPE    Changed a number of column prompts on the views
--  960509  MAOS    Added function Get_Specific_Location.
--  960425  JOAN    Added function Check_Exist
--  960308  JICE    Renamed from InvStoreLocation
--  960206  LEPE    Bug 96-0006: Changed parameter-type for newrec_ in procedure
--                  Insert___ in order to make it work on Oracle 7.2.3.
--  951203  STOL    Added check for duplicate key in proc. Validate_Comb___.
--  951122  STOL    Added rtrim on location_no in procedure Get_Location_No.
--  951122  STOL    Added rtrim on location_no in Update___ and Insert___.
--  951114  OYME    Increase length of res-variable in function
--                  Get_Location_Type from 2 to 20 characters.
--  951112  OYME    Added View InvStoreLocation2. Used to get a better LOV on
--                  location_no.
--  951004  STOL    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

TYPE Public_Rec IS RECORD
   (location_group WAREHOUSE_BAY_BIN_TAB.location_group%TYPE,
    warehouse WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE,
    bay_no WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE,
    row_no WAREHOUSE_BAY_BIN_TAB.row_id%TYPE,
    tier_no WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE,
    bin_no WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE,
    location_name WAREHOUSE_BAY_BIN_TAB.description%TYPE,
    location_sequence WAREHOUSE_BAY_BIN_TAB.location_sequence%TYPE);

TYPE location_details_rec   IS RECORD (
   location_group WAREHOUSE_BAY_BIN_TAB.location_group%TYPE,
   warehouse WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE,
   bay_no WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE,
   row_no WAREHOUSE_BAY_BIN_TAB.row_id%TYPE,
   tier_no WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE,
   bin_no WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE);

TYPE location_details_arr IS TABLE OF location_details_rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


@UncheckedAccess
PROCEDURE Exist (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS   
BEGIN
   IF (NOT WAREHOUSE_BAY_BIN_API.Location_Exists_On_Site(contract_, location_no_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_,'NOTEXIST: Inventory location :P1 does not exist on site :P2.',location_no_,contract_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Warehouse (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   dummy_         VARCHAR2(15);
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 dummy_,
                                 dummy_,
                                 dummy_,
                                 dummy_,
                                 contract_,
                                 location_no_);
   RETURN warehouse_id_;
END Get_Warehouse;

@UncheckedAccess
FUNCTION Get_Remote_Warehouse (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
BEGIN
   warehouse_id_ := Get_Warehouse(contract_,location_no_);
   IF Warehouse_API.Get_Remote_Warehouse_Db(contract_, warehouse_id_)= 'TRUE' THEN  
      RETURN warehouse_id_;
   ELSE
      RETURN NULL;
   END IF;
   
END Get_Remote_Warehouse;

@UncheckedAccess
FUNCTION Get_Bay_No (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   dummy_         VARCHAR2(15);
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(dummy_,
                                 bay_id_,
                                 dummy_,
                                 dummy_,
                                 dummy_,
                                 contract_,
                                 location_no_);
   RETURN bay_id_;
END Get_Bay_No;


@UncheckedAccess
FUNCTION Get_Row_No (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   dummy_         VARCHAR2(15);
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(dummy_,
                                 dummy_,
                                 dummy_,
                                 row_id_,
                                 dummy_,
                                 contract_,
                                 location_no_);
   RETURN row_id_;
END Get_Row_No;


@UncheckedAccess
FUNCTION Get_Tier_No (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   dummy_         VARCHAR2(15);
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(dummy_,
                                 dummy_,
                                 tier_id_,
                                 dummy_,
                                 dummy_,
                                 contract_,
                                 location_no_);
   RETURN tier_id_;
END Get_Tier_No;


@UncheckedAccess
FUNCTION Get_Bin_No (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
   dummy_         VARCHAR2(15);
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(dummy_,
                                 dummy_,
                                 dummy_,
                                 dummy_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN bin_id_;
END Get_Bin_No;


@UncheckedAccess
FUNCTION Get_Location_Name (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN WAREHOUSE_BAY_BIN_API.Get_Description(contract_,
                                   warehouse_id_,
                                   bay_id_,
                                   tier_id_,
                                   row_id_,
                                   bin_id_);
END Get_Location_Name;


@UncheckedAccess
FUNCTION Get_Location_Sequence (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN WAREHOUSE_BAY_BIN_API.Get_Location_Sequence(contract_,
                                         warehouse_id_,
                                         bay_id_,
                                         tier_id_,
                                         row_id_,
                                         bin_id_);
END Get_Location_Sequence;


@UncheckedAccess
FUNCTION Get_Location_Group (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN WAREHOUSE_BAY_BIN_API.Get_Location_Group(contract_,
                                      warehouse_id_,
                                      bay_id_,
                                      tier_id_,
                                      row_id_,
                                      bin_id_);
END Get_Location_Group;


-- Get_Location_Strings
--   Splits location no into the parts Warehouse, Bay, Row, Tier and Bin.
PROCEDURE Get_Location_Strings (
   warehouse_   OUT VARCHAR2,
   bay_no_      OUT VARCHAR2,
   row_no_      OUT VARCHAR2,
   tier_no_     OUT VARCHAR2,
   bin_no_      OUT VARCHAR2,
   contract_    IN VARCHAR2,
   location_no_ IN  VARCHAR2 )
IS
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_,
                                 bay_no_,
                                 tier_no_,
                                 row_no_,
                                 bin_no_,
                                 contract_,
                                 location_no_);
END Get_Location_Strings;


-- Get_Location_No
--   Concatenates Warehouse, Bay, Row, Tier and Bin and returns the complete
--   string as location no.
PROCEDURE Get_Location_No (
   location_no_ IN OUT VARCHAR2,
   contract_    IN     VARCHAR2,
   warehouse_   IN     VARCHAR2,
   bay_no_      IN     VARCHAR2,
   row_no_      IN     VARCHAR2,
   tier_no_     IN     VARCHAR2,
   bin_no_      IN     VARCHAR2 )
IS
BEGIN
   location_no_ := WAREHOUSE_BAY_BIN_API.Get_Location_No(contract_,
                                            warehouse_,
                                            bay_no_,
                                            tier_no_,
                                            row_no_,
                                            bin_no_);
END Get_Location_No;


-- Check_Exist
--   Returns TRUE if inventory location exists, otherwise FALSE.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN WAREHOUSE_BAY_BIN_API.Location_Exists_On_Site(contract_, location_no_);
END Check_Exist;


-- Get_Location_Type
--   Method returns the location type for specific location. It takes
--   location no as in parameter and calls a method in LU InventoryLocationGroup
--   which returns the location type for the group.
@UncheckedAccess
FUNCTION Get_Location_Type (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN WAREHOUSE_BAY_BIN_API.Get_Location_Type(contract_,
                                     warehouse_id_,
                                     bay_id_,
                                     tier_id_,
                                     row_id_,
                                     bin_id_);
END Get_Location_Type;


-- Get_Any_Location
--   Returns any location for the specified location group. Null if there is
--   no location for the group.
@UncheckedAccess
FUNCTION Get_Any_Location (
   contract_        IN VARCHAR2,
   location_group_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN WAREHOUSE_BAY_BIN_API.Get_Any_Location(contract_, location_group_, FALSE);
END Get_Any_Location;


@UncheckedAccess
FUNCTION Is_Shipment_Location (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN Warehouse_Bay_Bin_API.Is_Shipment_Location(contract_,
                                                     warehouse_id_,
                                                     bay_id_,
                                                     tier_id_,
                                                     row_id_,
                                                     bin_id_);
END Is_Shipment_Location;


@UncheckedAccess
FUNCTION Is_Location_In_Warehouse (
   contract_     IN VARCHAR2,
   location_no_  IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   location_warehouse_id_ warehouse_tab.warehouse_id%TYPE;
BEGIN
   location_warehouse_id_ := Get_Warehouse(contract_, location_no_);
   RETURN(warehouse_id_ = location_warehouse_id_);
END Is_Location_In_Warehouse;


-- Get_Location_Type_Db
--   Returns the DB value of Location Type
@UncheckedAccess
FUNCTION Get_Location_Type_Db (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   RETURN WAREHOUSE_BAY_BIN_API.Get_Location_Type_Db(contract_,
                                        warehouse_id_,
                                        bay_id_,
                                        tier_id_,
                                        row_id_,
                                        bin_id_);
END Get_Location_Type_Db;


-- Get_Control_Type_Values
--   Returns values of control types C46 - Location Type - and C83  -
--   Location Group - for a specific location.
PROCEDURE Get_Control_Type_Values (
   location_type_db_ OUT    VARCHAR2,
   location_group_   IN OUT VARCHAR2,
   contract_         IN     VARCHAR2,
   location_no_      IN     VARCHAR2 )
IS
   warehouse_id_  WAREHOUSE_BAY_BIN_TAB.warehouse_id%TYPE;
   bay_id_        WAREHOUSE_BAY_BIN_TAB.bay_id%TYPE;
   tier_id_       WAREHOUSE_BAY_BIN_TAB.tier_id%TYPE;
   row_id_        WAREHOUSE_BAY_BIN_TAB.row_id%TYPE;
   bin_id_        WAREHOUSE_BAY_BIN_TAB.bin_id%TYPE;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(warehouse_id_,
                                 bay_id_,
                                 tier_id_,
                                 row_id_,
                                 bin_id_,
                                 contract_,
                                 location_no_);
   WAREHOUSE_BAY_BIN_API.Get_Control_Type_Values(location_type_db_,
                                    location_group_,
                                    contract_,
                                    warehouse_id_,
                                    bay_id_,
                                    tier_id_,
                                    row_id_,
                                    bin_id_);
END Get_Control_Type_Values;


@UncheckedAccess
FUNCTION Arrival_Or_Quality_Location (
   location_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN WAREHOUSE_BAY_BIN_API.Arrival_Or_Quality_Location(location_type_db_);
END Arrival_Or_Quality_Location;


@UncheckedAccess
FUNCTION Check_Warehouse_Exist (
   contract_  IN VARCHAR2,
   warehouse_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (WAREHOUSE_BAY_BIN_API.Warehouse_Exists_On_Site(contract_, warehouse_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Warehouse_Exist;


-- This method is used by DataCaptMoveHandlUnit, DataCaptureInventUtil, DataCaptureMovePart, DataCaptReportPickHu, 
-- DataCaptReportPickPart, DataCaptRecvDispAdvice, DataCaptRecvHuDispAdv, DataCaptureMoveReceipt, DataCaptureRceiptUtil, 
-- DataCapProcessHuShip, DataCapProcessPartShip and DataCaptProcessShipment 
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                  IN VARCHAR2,
   capture_session_id_        IN NUMBER,
   lov_id_                    IN NUMBER DEFAULT 1,
   exclude_location_no_       IN VARCHAR2 DEFAULT NULL,
   include_location_no_       IN VARCHAR2 DEFAULT NULL,
   include_warehouse_id_      IN VARCHAR2 DEFAULT NULL,    
   exclude_remote_warehouses_ IN BOOLEAN DEFAULT FALSE )
IS
   lov_item_description_ VARCHAR2(200);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
   include_location_     BOOLEAN;
   display_warehouse_info_ BOOLEAN := FALSE;
   location_rec_         Inventory_Location_API.Public_Rec;
   
   CURSOR get_list_of_values_1 IS
      SELECT location_no, location_name, location_type
      FROM   INVENTORY_LOCATION5
      WHERE  contract = contract_
      ORDER BY  Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_2 IS
      SELECT location_no, contract, location_name
      FROM   INVENTORY_LOCATION5
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_3 IS
      SELECT location_no, location_group, location_name, location_type, warehouse
      FROM   INVENTORY_LOCATION25
      WHERE  contract = contract_
      AND    location_no != NVL(exclude_location_no_, string_null_)
      AND   (warehouse = include_warehouse_id_ OR include_warehouse_id_ IS NULL)
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;
   
   CURSOR get_list_of_values_4 IS
      SELECT location_no, location_name 
      FROM   INVENTORY_LOCATION7
      WHERE  contract = contract_ 
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_5 IS
      SELECT location_no, location_group, location_type, location_name
      FROM   INVENTORY_LOCATION14
      WHERE  contract = contract_
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_6 IS
      SELECT location_no, location_group, location_type, location_name
      FROM   INVENTORY_LOCATION7
      WHERE  contract = contract_
      AND    location_no != NVL(exclude_location_no_, string_null_)
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_7 IS
      SELECT location_no, location_group, location_type, location_name
      FROM   INVENTORY_LOCATION8
      WHERE  contract = contract_
      AND    location_no != NVL(exclude_location_no_, string_null_)
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;

   CURSOR get_list_of_values_8 IS
      SELECT contract
      FROM   INVENTORY_LOCATION5
      WHERE  location_no = include_location_no_
      ORDER BY Utility_SYS.String_To_Number(contract) ASC, contract ASC;
   
   CURSOR get_list_of_values_9 IS
      SELECT distinct location_no
      FROM   INVENTORY_LOCATION5
      WHERE  location_no != NVL(exclude_location_no_, string_null_)
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;
      
   CURSOR get_list_of_values_10 IS
         SELECT location_no, location_name, location_type
         FROM   INVENTORY_LOCATION11
         WHERE  contract = contract_
         ORDER BY  Utility_SYS.String_To_Number(location_no) ASC, location_no ASC;
      
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF lov_id_ = 1 THEN
         FOR lov_rec_ IN get_list_of_values_1 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type;
            ELSE
               lov_item_description_ := lov_rec_.location_type;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;

         END LOOP;
      ELSIF lov_id_ = 2 THEN
         FOR lov_rec_ IN get_list_of_values_2 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.contract;
            ELSE
               lov_item_description_ := lov_rec_.contract;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;

         END LOOP;
      ELSIF lov_id_ = 3 THEN
         IF (session_rec_.capture_process_id = 'REGISTER_ARRIVALS' AND 
            Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_WAREHOUSE_INFO'))) THEN
            display_warehouse_info_ := TRUE;
         END IF;
         FOR lov_rec_ IN get_list_of_values_3 LOOP
            include_location_ := TRUE;
            IF (exclude_remote_warehouses_) THEN
               include_location_ := Warehouse_API.Is_Remote(contract_, lov_rec_.warehouse) = Fnd_Boolean_API.DB_FALSE;
            END IF;
            IF (include_location_) THEN
               IF (lov_rec_.location_name IS NOT NULL) THEN
                  lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type;
               ELSE
                  lov_item_description_ := lov_rec_.location_type;
               END IF;
               IF display_warehouse_info_ THEN
                  location_rec_ := Inventory_Location_API.Get(contract_, lov_rec_.location_no);
                  lov_item_description_ := location_rec_.warehouse || ' | ' || location_rec_.bay_no || ' | ' || location_rec_.row_no || ' | ' || location_rec_.tier_no || ' | ' || location_rec_.bin_no;
               END IF;
               Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                                capture_session_id_    => capture_session_id_,
                                                lov_item_value_        => lov_rec_.location_no,
                                                lov_item_description_  => lov_item_description_,
                                                lov_row_limitation_    => lov_row_limitation_,    
                                                session_rec_           => session_rec_);
               EXIT WHEN exit_lov_;
            END IF;
         END LOOP;
      ELSIF lov_id_ = 4 THEN
         FOR lov_rec_ IN get_list_of_values_4 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name;
            ELSE
               lov_item_description_ := NULL;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF lov_id_ = 5 THEN
         FOR lov_rec_ IN get_list_of_values_5 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            ELSE
               lov_item_description_ := lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF lov_id_ = 6 THEN
         FOR lov_rec_ IN get_list_of_values_6 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            ELSE
               lov_item_description_ := lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF lov_id_ = 7 THEN
         FOR lov_rec_ IN get_list_of_values_7 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            ELSE
               lov_item_description_ := lov_rec_.location_type || ' | ' || lov_rec_.location_group;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;

      ELSIF lov_id_ = 8 THEN
         FOR lov_rec_ IN get_list_of_values_8 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.contract,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF lov_id_ = 9 THEN
         FOR lov_rec_ IN get_list_of_values_9 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF lov_id_ = 10 THEN
         FOR lov_rec_ IN get_list_of_values_10 LOOP
            IF (lov_rec_.location_name IS NOT NULL) THEN
               lov_item_description_ := lov_rec_.location_name || ' | ' || lov_rec_.location_type;
            ELSE 
               lov_item_description_ := lov_rec_.location_type;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.location_no,
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


@UncheckedAccess
FUNCTION Get_Location_No_If_Unique (
   contract_              IN VARCHAR2,
   lov_id_                IN NUMBER,
   exclude_location_no_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   column_value_                  VARCHAR2(50);
   unique_column_value_           VARCHAR2(50):= NULL;

   CURSOR get_location_no5 IS
      SELECT location_no
      FROM   INVENTORY_LOCATION14
      WHERE  contract = contract_
      AND    location_no != NVL(exclude_location_no_, string_null_);

   -- shipment locations
   CURSOR get_location_no7 IS
      SELECT location_no 
      FROM   INVENTORY_LOCATION7
      WHERE  contract = contract_
      AND    location_no != NVL(exclude_location_no_, string_null_);
     
BEGIN
   IF lov_id_ = 7 THEN
      OPEN get_location_no7;
      LOOP
         FETCH get_location_no7 INTO column_value_;
         EXIT WHEN get_location_no7%NOTFOUND;

         IF (unique_column_value_ IS NULL) THEN
            unique_column_value_ := column_value_;
         ELSIF (unique_column_value_ != column_value_) THEN
            unique_column_value_ := NULL;
            EXIT;
         END IF;
      END LOOP;
      CLOSE get_location_no7;
   ELSIF lov_id_ = 5 THEN
      OPEN get_location_no5;
      LOOP
         FETCH get_location_no5 INTO column_value_;
         EXIT WHEN get_location_no5%NOTFOUND;

         IF (unique_column_value_ IS NULL) THEN
            unique_column_value_ := column_value_;
         ELSIF (unique_column_value_ != column_value_) THEN
            unique_column_value_ := NULL;
            EXIT;
         END IF;
      END LOOP;
      CLOSE get_location_no5;
   END IF;
      
   RETURN unique_column_value_;
END Get_Location_No_If_Unique;


@UncheckedAccess
FUNCTION Get (
   contract_ IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rec_     Public_Rec;
   binrec_  WAREHOUSE_BAY_BIN_API.Public_Rec;
BEGIN
   WAREHOUSE_BAY_BIN_API.Get_Location_Strings(rec_.warehouse,
                                 rec_.bay_no,
                                 rec_.tier_no,
                                 rec_.row_no,
                                 rec_.bin_no,
                                 contract_,
                                 location_no_);
   binrec_ := WAREHOUSE_BAY_BIN_API.Get(contract_,
                           rec_.warehouse,
                           rec_.bay_no,
                           rec_.tier_no,
                           rec_.row_no,
                           rec_.bin_no);
   rec_.location_group := binrec_.location_group;
   rec_.location_name := binrec_.description;
   rec_.location_sequence := binrec_.location_sequence;
   RETURN rec_;
END Get;


-- This method is used by DataCaptMoveHandlUnit and DataCaptUnissueWo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_             IN VARCHAR2,
   location_no_          IN VARCHAR2,
   column_name_          IN VARCHAR2,
   column_value_         IN VARCHAR2,
   column_description_   IN VARCHAR2,
   sql_where_expression_ IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
   -- NOTE: This method can be changed to have several cursors/views etc if more wadaco processes start to use it (it was created for Unissue WO)
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('INVENTORY_LOCATION14', column_name_);

   stmt_ := ' SELECT 1
              FROM INVENTORY_LOCATION14
              WHERE contract          = NVL(:contract_, contract)
              AND   location_no       = NVL(:location_no_, location_no) ';

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_';

   @ApproveDynamicStatement(2015-04-29,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       location_no_,
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

FUNCTION Get_Location_Details (
   contract_     IN VARCHAR2,
   location_no_  IN VARCHAR2 ) RETURN location_details_arr PIPELINED
IS
   rec_  location_details_rec;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(rec_.warehouse,
                                              rec_.bay_no,
                                              rec_.tier_no,
                                              rec_.row_no,
                                              rec_.bin_no,
                                              contract_,
                                              location_no_);
   rec_.location_group := Warehouse_Bay_Bin_API.Get_Location_Group(contract_,
                                                                   rec_.warehouse,
                                                                   rec_.bay_no,
                                                                   rec_.tier_no,
                                                                   rec_.row_no,
                                                                   rec_.bin_no);                                     
   PIPE ROW (rec_);
END Get_Location_Details;

FUNCTION Get_Location_No(
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   serial_no_        IN VARCHAR2) RETURN VARCHAR2
IS
   location_no_   VARCHAR2(100);
   
   CURSOR get_location_no IS
   SELECT LOCATION_NO
   FROM INVENTORY_PART_IN_STOCK_DELIV 
   where  part_no = part_no_ 
      AND contract = contract_ 
      AND serial_no = serial_no_;
   
BEGIN
   FOR rec_ IN get_location_no LOOP
      location_no_ := rec_.LOCATION_NO;
   END LOOP;
   RETURN location_no_;
END Get_Location_No;