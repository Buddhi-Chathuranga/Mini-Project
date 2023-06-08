-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalog
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210427  KETKLK  PJ21R2-448, Removed PDMPRO references.
--  201224  SBalLK  Issue SC2020R1-11830, Modified Create_Part(), Copy() and Modify() methods by removing attr_ functionality to optimize the performance.
--  200720  BudKlk  SCXTEND-4453, Added ObjectConnectionMethod annotation to the Get_Description() method. 
--  200506  UdGnlk  SC2020R1-6883, Modified Update___() to add missing conditional compilation ELSE NULL for Part_Revision_API.Handle_Tech_Drawing_Change();
--  191202  NISMLK  MFSPRING20-531, Modified Update___() and Check_Update___() to update part revisions when technical_drawing_no is modified. 
--  191125  NISMLK  MFSPRING20-144, Modified Modify() by adding parameter technical_drawing_no_ in order to save TECHNICAL_DRAWING_NO.
--  191031  NISMLK  MFSPRING20-88, Modified Create_Part() by adding parameter technical_drawing_no_ in order to save TECHNICAL_DRAWING_NO.
--  190925  DaZase  SCSPRING20-117, Added Raise_Input_Uom_Error___() to solve MessageDefinitionValidation issue.
--  190802  Asawlk  Bug 149259(SCZ-5772) Modified Copy() in order to copy the custom fields when part is copied.
--  190519  Asawlk  Bug 148225(SCZ-4900), Modified Update__ by adding a call to Lot_Batch_Master_API.Reset_Condition_Code to clear the codition code value
--  190515          saved in lot batch master if the part gets enabled for receipt and issue serial tracking.
--  181207  SWiclk  SCUXXW4-5464, Modified Check_For_Valid_Values___() by moving the UoM checks of weight and volume to Check_Insert___() because it is needed to validate at insertion and 
--  181207          when updating it should remove the UoM if value is null for wieght/volume hence modified Update___().
--  181214  LaThlk  Bug 145861(SCZ-2267), Modified the procedure Create_Part() by adding 3 parameters in order to create the part catalog record with lot quantity rule, sub lot rule and serial rule.
--  180123  ShPrlk  Bug 139857, Modified Delete___ to assign the key value to be passed into the method Technical_Object_Reference_API.Delete_Reference
--  171013  AsZelk  Bug 138170, Modified Create_Part() by adding parameter input_unit_meas_group_id_ in order to save INPUT_UNIT_MEAS_GROUP_ID.
--  170929  AmPalk  STRMF-14410. Merged 137856.
--  170929          DAJOLK  Bug 137856, Removed method call to Ecoman_Part_Info_API.Copy_Data in method Copy.
--  170209  RALASE  LIM-10661, Added method Is_Serial_Tracked_In_Inventory
--  170104  MaIklk  LIM-9397, Replaced the Shipment_handling_Utility_API.Calculate_Freight_Charges() call with Shipment_Freight_Charge_API.Calculate_Freight_Charges().
--  160405  Rakalk  MATP-2099, CBS/CBSINT Split Moved code from Scheduling_Int_API to Cbs_So_Int_API.
--  160304  RuLiLk  Bug 127366, Modified method Check_Valid_Serial___ to call Sales_Part_API.Check_Serial_Track_Change() regardless of the value of receipt_issue_serial_track.
--  160301  JeLise  STRSC-1280, Added more info in warning UPDATEALLOWCONDCODE in Check_Update___.
--  150525  MoNilk  Bug 122597, Added lot_tracking_code_db_, configurable_db_, multi_level_tracking_db_ parameters to method Modify().
--  150519  SBalLK  Bug 122249, Modified Update___() method to disable 'Tracked In Inventory' check box in PartSerialCatalog Lu when enable the 'In Inventory'
--  150519          serial tracking.
--  141210  RILASE  Added methods Serial_Tracked_In_Inventory and Rcpt_Issue_Serial_Tracked.
--  141122  MaEelk  PRSC-3144, Removed the Deprecated method Validate_Set_Configurable.
--  140918  BudKlk  Bug 118711, Modified the method Check_Valid_Serial___() by adding an error to stop change the serial rule from manual to automatic when 
--  140918          alphanumeric values exist in either serial_no_reservation_tab or part_serial_catalog_tab.
--  140703  MaEdlk  Bug 117072, Removed rounding of weight_net and volume_net attributes in Check_Insert___ and Check_Update___.
--  140326  MaEdlk  Bug 115984, Modified method Check_For_Valid_Values___() by removing validations for lot_quantity_rule, sub_lot_rule and component_lot_rule  
--  140326          when lot_tracking_code is 'NOT LOT TRACKING'.
--  140319  UdGnlk  PBSC-7608, Modified Check_Update___() replacing old_rec_ with oldrec_.
--  140312  MaEdlk  Bug 113407, Removed the call for Validate_Set_Configurable() in Unpack_Check_Update___() because validations are done 
--  140312          in Order_Config_Util_API.Check_Configurable_Change(). Marked Validate_Set_Configurable() as deprecated.
--  140206  AyAmlk  Bug 115096, Modified Check_Delete___() to raise an error when trying to remove a record with part no having the caret symbol.
--  131125  AwWelk  PBSC-4395, Modified the Check_Insert___() method to set default value for receipt_issue_serial_track if it is not set from unpack loop.
--  130903  SBalLK  Bug 111695, Modified Check_Valid_Serial___() method by validating record existence in serial part catalog when changing engineering serial tracking code.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130823  MaEelk  Made a call to Shipment_Handling_Utility_API.Calculate_Freight_Charges if a change is done to weight_net or volume_net from Update___
--  130814  JeLise  Added call to Installed_Component_SYS."INVENT" before calling Part_Catalog_Capability_API.Copy.
--  130807  MeAblk  Modified method Modify__ by removing the method call Partca_Company_Sal_Part_API.Update_Weight_Volume.   
--  130718  MaEelk  Removed the method call to Sales_Part_API.Update_Weight_Volume_In_All in Modify__.
--  130108  NaLrlk  Added Is_Lot_Or_Serial_Tracked to check whether a given part is tracked part or not.
--  130730  Awwelk  TIBE-1041, Removed global variables and introduced conditional compilation.
--  130520  NipKlk  Bug 104571, Modified the column comment of the view Part_Catalog to update the length of part_main_group to 20.
--  130516  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120616  MaEelk  Dynamic calls to Company_Invent_Info_API.Get_Uom_For_Volume was replaced with conditional compilation.
--  120615  MaMalk  Replaced Company_Distribution_Info_API.Get_Uom_For_Volume with Company_Invent_Info_API.Get_Uom_For_Volume.
--  120918  RuLiLk  Bug 104581, Modified method Copy. Added weight_net, volume_net, uom_for_weight_net, uom_for_volume_net to attribute string
--  120907  IsSalk  Bug 102558, Modified method Update___ in order to give information messages when setting serial tracking and lot tracking for a particular part.
--  120608  AndDse  ECO-32, Moved ecoman part specific data, eg siteless, to part catalog. Modified Insert___ so that a ecoman_part_info record is created from there. Modified Copy to copy the information.
--  120904  JeLise  Moved STORAGE_WIDTH_REQUIREMENT, STORAGE_HEIGHT_REQUIREMENT, STORAGE_DEPTH_REQUIREMENT, 
--  120904          STORAGE_VOLUME_REQUIREMENT, STORAGE_WEIGHT_REQUIREMENT, MIN_STORAGE_TEMPERATURE, MAX_STORAGE_TEMPERATURE, 
--  120904          MIN_STORAGE_HUMIDITY, MAX_STORAGE_HUMIDITY, UOM_FOR_LENGTH, UOM_FOR_VOLUME, UOM_FOR_WEIGHT, UOM_FOR_TEMPERATURE 
--  120904          and all methods connected to them to Part_Catalog_Invent_Attrib_API.
--  120314  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method at Check_Storage_Capacity_Uom, Check_Temperature_Uom, Check_Temperature_Range and Check_Humidity_Range.
--  120206  NaLrlk  Removed GTIN columns and methods.
--  120127  NaLrlk  Modified the method Create_Part to gtin creation in Part Gtin.
--  120126  NaLrLk  Modified methods Update___ and Check_Delete_Input_Unit_Meas to change the method calls Part_Input_Unit_Meas_API to Part_Gtin_Unit_Meas_API.
--  120126          Removed the method Validate_Gtin___.
--  120117  MaEelk  Corrected model errors.
--  111228  LEPESE  Corrected erroneous merge of bug 99367 in Check_Valid_Serial___.
--  111221  DaZase  Added stop_new_serial_in_rma_db and stop_arrival_issued_serial_db to Copy method.
--  111212  THTHLK  SPJ-956: Added new PROCEDURE Modify. Added description to FUNCTION Get
--  111205  CHINLK  Bug 99367, Modified Check_Valid_Serial___ to move MFGSTD checks to Manuf_Structure_Util_API.Check_Serial_Tracking_Change.
--  111124  DaZase  Added stop_new_serial_in_rma.
--  111121  AndDse  SMA-744, Removed General_SYS.Init from Get_Position_Part_Db since pragma was added in function declaration.
--  111011  MatKse  Added new view PART_CATALOG_ISSUE_SERIAL_LOV.
--  111003  JeLise  Added qty_per_volume to the view and changed flags so that storage_volume_requirement will not be shown in LOV.
--  110928  DaZase  Added extra dynamic calls in Insert___/Update to fetch uom_for_volume defaults 
--  110928          from user default company.
--  110926  ChJalk  Added Function Get_Active_Gtin_No.
--  110818  NaLrlk  Modified the methods Insert___, Update___ and Validate_Gtin___ to validate the GTIN deletion.
--  110515  THIMLK  Merged LCS patch 94616.
--          101209  Maatlk Bug 94616, Modified the method Check_Update_Config_Flag___ to remove the method call Eng_Part_Master_API.Check_Configurable_Change 
--                  to allow configuration for the configured parts. 
--  110514  MaEelk  Added missing assert safe comment to Check_Temperature_Range and Check_Humidity_Range.
--  110420  MatKse  Modified Copy() to include COMPONENT_LOT_RULE_DB,ALLOW_AS_NOT_CONSUMED_DB, WEIGHT_NET and UOM_FOR_WEIGHT_NET
--                  when copying part.
--  110329  LEPESE  Added parameters old_serial_tracking_code and old_rece_iss_serial_track in call to
--  110329          Invent_Part_Serial_Manager_API.Check_Serial_Track_Change from Check_Valid_Serial__.
--  110329  RaKalk  Added warning message in Unpack_Check_Update___ function to when disabling inventory serial tracking.
--  110309  AwWelk  Bug 95798, Modified the method Handle_Description_Change___ to refresh the doc_reference_object_tab with changed description. 
--  110309          Added code to handle discription change in SalesPart and PurchasePart.
--  110307  NaLrlk  Removed the method Update_Gtin_In_Parts___.
--  110308  Rakalk  Added Serial_Trak_Only_Rece_Issue_Db method to access from client
--  110222  NaLrlk  Modified the method Check_Valid_Serial___ to check serial tracked change part connected to kanban circuit.
--  110220  LEPESE  Change in Unpack_Check_Insert___ to always set receipt_issue_serial_track to 'TRUE' if
--  110220          the value of serial_tracking_code is 'SERIAL TRACKING'.
--  110210  NaLrlk  Added the method Serial_Tracked_Only_Rece_Issue.
--  110210          Modified the method Check_Valid_Serial___ to check serial tracked change part connected in production line.
--  110111  JoAnSe  Removed Is_Tracked as it does the same thing as Lot_Or_Serial_Tracked
--  101229  JoAnSe  Added Is_Tracked
--  101105  RaKalk  Added function Get_Rcpt_Issue_Serial_Track_Db
--  101029  LEPESE  Added parameter receipt_issue_serial_track in calls to Invent_Part_Config_Manager_API.Check_Configurable_Change
--  101029          and Invent_Part_Lot_Manager_API.Check_Lot_Track_Change.
--  101028  LEPESE  Added global package constants db_serial_tracking_, db_not_serial_tracking_, db_true_ and db_false_.
--  101028          Replaced usage of hard-coded strings 'SERIAL TRACKING', 'NOT SERIAL TRACKING', 'TRUE' and 'FALSE'
--  101028          throughout the file. Changes in Check_For_Valid_Values___, Check_Valid_Serial___  and 
--  101028          Check_Allow_As_Not_Consumed___ because of new attribute receipt_issue_serial_track.
--  101028          Removed method Tracked_In_Inventory and added Lot_Or_Serial_Tracked instead. 
--  101014  RaKalk   Added public mandatory column RECEIPT_ISSUE_SERIAL_TRACK to PART_CATALOG_TAB
--  110104  DaZase   Added methods Get_Storage_Volume_Req_Oper_Cl and Get_Storage_Volume_Req_Client.
--  101019  ShKolk   Removed updating Inventory Part with the Gtin No in Part Catalog. 
--  101102  DaZase   Inverted volume from Get_Storage_Volume_Requirement. Changed Get_Uom_For_Volume so it checks Storage_Capacity_Req_Group_API for uom.
--  101021  JeLise   Added capacity, condition and capability attributes in Copy.
--  101019  ShKolk   Removed updating Sales Part with the Gtin No in Part Catalog. 
--  101019  NaLrlk   Modified the method Validate_Gtin___.
--  100923  NaLrlk   Changed the method name Is_Gtin_Active to Get_Active_Gtin_Part.
--  100922  JeLise   Moved Incorrect_Temperature_Range and Incorrect_Humidity_Range from Site_Invent_Info_API.
--  100922           Added Check_Temperature_Range and Check_Humidity_Range.
--  100914  JeLise   Added capacity_req_group_id, condition_req_group_id and capability_req_group_id.
--  100909  NaLrlk   Added method Check_Delete_Input_Unit_Meas.
--  100901  ChFolk   Merged Bug 91550, Modified method Validate_Gtin___ by changing a condition to raise the error message AVTIVEGTINEXISTS when        
--  100901           entering a Gtin number from a Gtin active part to another Gtin active part and corrected the error message AVTIVEGTINEXISTS.
--  100901  JeLise   Added Get_Xxx_Source methods.
--  100901  ChFolk   Merged Bug 89246, Removed setting part_gtin_ and part_gtin_series_ unnecessarily in method Modify__ and set 
--  100901           the correct values if the gtin_no is changed while keeping the active_gtin TRUE.
--  100826  JeLise   Adding columns UOM_FOR_LENGTH, UOM_FOR_VOLUME, UOM_FOR_WEIGHT and UOM_FOR_TEMPERATURE.
--  100823  JeLise   Added methods Check_Humidity, Check_Carrying_Requirement and Check_Cubic_Requirement.
--  100818  JeLise   Adding columns STORAGE_WIDTH_REQUIREMENT, STORAGE_HEIGHT_REQUIREMENT, STORAGE_DEPTH_REQUIREMENT, 
--  100818           STORAGE_VOLUME_REQUIREMENT, STORAGE_WEIGHT_REQUIREMENT, MIN_STORAGE_TEMPERATURE, MAX_STORAGE_TEMPERATURE, 
--  100818           MIN_STORAGE_HUMIDITY and MAX_STORAGE_HUMIDITY to PART_CATALOG_TAB. 
--  100715  KiSalk   Added function Get_Multilevel_Tracking_Db.
--  100511  MaNwlk   Modified Unpack_Check_Update___, Update___ methods to move some of the manufacturing specific logics to relavent components.
--  100423  KRPELK  Merge Rose Method Documentation.
--  100421  MaNwlk   Modified Unpack_Check_Update___ to change information message when multilevel check box being selected, when
--  100421           there is a buildable repair structure with consumable material lines.
--  100409  ManWlk   Modified Unpack_Check_Update___. Raised an error preventing multilevel checkbox being changed, when there is a
--  100409           open repair shop order with consumable material lines.
--  100409  ManWlk   Modified Unpack_Check_Update___. Raised an informantion message when multilevel check box being selected and
--  100409           when there is a buildable repair structure with consumable material lines.
--  100126  Asawlk  Bug 88462, Modified Check_For_Valid_Values___() to check whether LU 'ConfigPartCatalog' is installed when part is Configurable.
--  100126          Also added method Raise_ConfigPart_Error___.
--  100120  HimRlk  Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants. 
--  100114  KAYOLK  Replaced the obsolete usages of Shop_Order_Int_API calls to other relevant methods.
--  100110  JENASE  Replaced calls to obsolete Manuf_Part_Attribute_Int_API with Manuf_Part_Attribute_API.
--  100106  MaEelk  Replaced obsolete method calls Shop_Material_Alloc_List_API.Check_Part_Track_Change
--  100106          with Shop_Material_Alloc_List_API.Check_Part_Track_Change in Check_Valid_Lot___ 
--  100106          and Check_Valid_Serial___.
--  100105  JENASE  Replaced calls to obsolete Manuf_Structure_Int_API with calls to other API:s.
--  091217  ChFolk  Modified Check_Update_Config_Flag___ to redirect method call Check_Configurable_Change from Dop_Int_API
--  091217          to Dop_Order_API.
--  090929  MaJalk  Removed unused constants.
--  -------------------------- 13.0.0 ---------------------------------------------
--  100312  NaLrlk      Added parameter auto_created_gtin_ to Create_Part.
--  090714  AmPalk      Bug 83121, Made gtin a varchar2.Hence change the usage of the gtin_no in the file.
--  090611  IrRalk      Bug 82835, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ in order to change the number of 
--  090611              decimal places in WeightNet and VolumeNet coloumns to 4 and 6 respectively.
--  090505  HoInlk      Bug 82240, Modified Handle_Description_Change___ to handle description change in EngRevision.
--  090302  HoInlk      Bug 80753, Modified Delete___ to delete technical object references before calling cascade delete.
--  081218  NWeelk      Bug 78131, Added a procedure Check_Catch_Unit_Enabled___ and modified Unpack_Check_Update___
--  081218              to raise an error message when catch_unit_enabled of a non-inventory part or package part is 
--  081218              changed from FALSE to TRUE.  
--  081103  PraWlk      Bug 78167, Modified Unpack_Check_Update___ by removing code written for turning on 
--  080910              multilevel_tracking when serial or lot tracking is enabled.   
--  081020  HoInlk      Bug 77869, Removed check for technical object references in Check_Delete___.
--  080929  Prawlk      Bug 76816, Added FUNCTION Tracked_In_Inventory. Modified Check_Valid_Lot___, Check_Valid_Serial___ and
--  080929              Unpack_Check_Update___ to raise an error when a non-inventory part is changed from not being tracked 
--  080922              to being tracked.
--  080923  HoInlk      Bug 77144, Modified Check_Delete___ and Delete___ to consider technical object references on delete.
--  080918  SuSalk      Bug 73322, Added attribute allow_as_not_consumed, Added Check_Allow_As_Not_Consumed___ and 
--  080918              Get_Allow_As_Not_Consumed_Db methods. Modified Unpack_Check_Insert___,Unpack_Check_Update___,  
--  080918              Create_Part and Get methods to handle allow_as_not_consumed.
--  080910  NiBalk      Bug 75203, Modifed Create_Part and Unpack_Check_Update___ to turn on 
--  080910              multilevel_tracking when serial or lot tracking is enabled.       
--  090223  KiSalk      Added parameter parameter freight_factor_ to Create_Part.
--  090129  ShKolk      Modified Modify__() by removing company from the function call to Partca_Company_Sal_Part_API.
--  081201  MaJalk      Added method Get_Active_Gtin_Db.
--  081201  MaJalk      At Update_Gtin, added error message INACTPARTCAGTIN.
--  080909  AmPalk      Added Get_Freight_Factor.
--  080905  KiSalk      Added attributes uom_for_volume_net and volume_net, methods Get_Volume_Net, Get_Uom_For_Volume_Net and modified Create_Part with them.
--  080901  AmPalk      Modified Modify__ to update freight info on company and on sales parts. when net weight or its' UoM gets changed.
--  080729  AmPalk      Added Uom_For_Weight_Net and Weight_Net and modified Create_Part with them.
--  080704  AmPalk      Merged APP75 SP2.
--  ---------------------- APP75 SP2 Start ----------------------------------------
--  080521  MaAtlk      Bug 72650, Modified the method Check_Valid_Lot___ to call Shop_Material_Alloc_Int_API.Check_Part_Track_Change.
--  080521              Replaced Is_Part_Allocated with Check_Part_Track_Change in Check_Valid_Serial___.
--  080509  Prawlk      Bug 73471, Deleted call for General_SYS.Init_Method in PROCEDURE Exist_Inv_Purch_Sals_Prts__.
--  080430  NuVelk      Bug 72249, Added attribute stop_arrival_issued_serial and its associated methods.
--  ---------------------- APP75 SP2 Start ----------------------------------------
--  080528  AmPalk      Added Update_Gtin_In_Parts___ and modified Update_Gtin and Modify__ to use it.
--  080527  AmPalk      Added Validate_Gtin___ and modified Update_Gtin as a code cleanup.
--  080425  AmPalk      Modified Modify__ to handle gtin in parts when a gtin gets active and inactive.
--  080424  AmPalk      Added parameter gtin_series_ TO Create_Part.
--  080423  KiSalk      Added attribute gtin_series and method Get_Gtin_Series. Added parameter gtin_series to Update_Gtin.
--  080418  AmPalk      Modified Modify__ to handle GTIN update.
--  080417  AmPalk      Modified Modify__ to update all inventory parts and sales parts if GTIN is modified.
--  080416  AmPalk      Added Update_Gtin.
--  080416  AmPalk      Modified Create_Part to set active gtin state.
--  080414  AmPalk      Modified Create_Part by adding parameter gtin_no_.
--  081412  AmPalk      Modified Is_Gtin_Active to return part no if active gtin_no found.
--  080410  AmPalk      Added Is_Gtin_Active.
--  080408  AmPalk      Set Gtin_No update allowed if null and last Gtin status updated date as sysdate.
--  080407  AmPalk      Added columns GTIN_STATE_MODIFIED, ACTIVE_GTIN, AUTO_CREATED_GTIN and GTIN_NO.
--  080121  HaPulk      Bug 70521, Added copy of the Document Object References in method Copy_Connected_Objects.
--  071203  UdGnlk      Bug 67496, Modified Update___ to call Handle_Enable_Serial_Tracking for serial track for purchase parts.
--  071119  IsAnlk      Bug 69353, Addded MULTILEVEL_TRACKING_DB attribute to the attr_ in procedure Copy.
--  071030  KeFelk      Bug 68753, Added text_id$ to PART_CATALOG, PART_CATALOG_LOV and PART_CATALOG_NOT_POSITION_LOV.
--  070705  RoJalk      Bug 65378, Modified Update___ to call method Handle_Enable_Serial_Tracking in
--  070705              Invent_Part_Serial_Manager_API when part catalog is changed to serial tracked.
--  070525  NaWilk      Added parameters catch_unit_enabled_db_ and multilevel_tracking_db_ into method Create_Part
--  070425  Nibulk      Checked and added mising Assert Safe comments where necessary.
--  061228  DaZase      Removed catch_unit_code from the LU (catch_unit_meas on InventoryPart should be used instead from now on).
--  061222  NaLwlk      Bug 58299, Added ComponentLotRule attribute and associated methods.
--  061110  ShVese      Removed checks for catch_unit_code in Unpack_Check_Update___ and Check_For_Valid_Values___.
--  061106  NiBalk      Bug 60671, Modified the procedure Unpack_Check_Insert___,
--  061106              in order to avoid special characters used by F1.
--  061007  AmPalk      Bug 60257, Removed error message for POSITION PARTS from Modify__ and changed the text of the
--  061007              error message for POSITION PARTS in New__. Removed method Check_Update_Position_Part___ and call to it
--  061007              in Unpack_Check_Update___. Made POSITION_PART attribute non-updatable.
--  060904  RoJalk      Added method Handle_Description_Change___ and called from Update___
--  060904              when description is cahnged.
--  080803  NaWilk      Removed Description from FUNCTION Get.
--  080802  RoJalk      Modified the non-base views to use Part_Catalog_API.Get_Description.
--  060725  RaKalk      Changed description field to private and added the new get description method
--  060725              Which takes the language code as a parameter.
--  060601  MiErlk      Enlarge Identity - Changed view comments Description.
--  060524  WiJalk      Bug 34067, Added Check_Update_Unit_Code___ to decide changing of Unit Code.
--  060501  KeSmus      Bug 54827, Added MultilevelTracking public attribute, public GET method, etc.
--  ------------------------- 12.4.0 ---------------------------------------------
--  060310  MaHplk      Removed check for Clear catch unit code from Unpack_Check_Update___ for reverse the previous correction.
--  060224  MaHplk      Added check for Clear catch unit code when catch unit enabled false if an inventory part not exists in
--                      Unpack_Check_Update___.
--  060123  JaJalk      Added Assert safe annotation.
--  051216  JoEd        Removed Update_Sales_Config___ - it updates an obsolete attribute...
--  051018  MaEelk      Redirected the call Site_API.Check_Vim_Exist to Site_Mfgstd_Info_API.Check_Vim_Mro_Enabled
--  050920  KaDilk      Bug 53377, Added global LU constant inst_EquipmentSerial_ and modified procedure Update___.
--  050916  NaLrlk      Removed Unused variables.
--  050609  RaKalk      Added Method Get_Catch_Unit_Enabled_Db.
--  050120  IsWilk      Modified the PROCEDURE Copy_Connected_Objects.
--  050119  KeFelk      Rewriten the Copy method which makes the code easier to read.
--  041231  RaKalk      Modified Unpack_Check_Update__ to correct the validation of Input_UoM_Group change.
--  041612  KeFelk      Removed default data in Copy and Copy_Connected_Objects Parameters.
--  041213  SaRalk      Modified procedure Copy_Connected_Objects.
--  041211  JaBalk      Modified procedure Copy.
--  041210  SaRalk      Added new procedure Copy_Connected_Objects, Copy.
--  041202  KanGlk      Added COPY_PART_LOV view.
--  041129  IsAnlk      Removed dynamic call to disable catch unit functionality in method Update___.
--  041117  IsAnlk      Added a dynamic call to disable catch unit functionality in method Update___.
--  041103  GeKalk      Moved the previous modification in Unpack_Check_Update___ to Update___ and modify that.
--  041101  GeKalk      Modified Unpack_Check_Update___ to handle catch unit enable check depending on the existing sales parts.
--  041011  IsAnlk      Modifications to validations in Unpack_Check_Update___ for deleting catch_unit_code.
--  041004  SaJjlk      Modifications to validations in Unpack_Check_Update___ for updating catch_unit_code.
--  040927  LoPrlk      Method Exist_Invent_Purch_Sales_Parts was made private Exist_Inv_Purch_Sals_Prts__.
--  040915  KeSmUS      Bug 46969, Removed restriction preventing a serial tracked part from also being order-based lot tracked.
--  040915  SaJjlk      Removed method Check_Catch_Unit___ and modified dynamic call to enable catch unit in method Update___.
--  040913  SaJjlk      Added a dynamic call to enable catch unit functionality in method Update___.
--  040908  SaJjlk      Removed column catch_conv_factor.
--  040907  SaJjlk      Added new coloumns catch_conv_factor, catch_unit_code and catch_unit_enabled.
--                      Added new methods Check_Catch_Unit___ and Get_Enabled_Catch_Unit_Code.
--  040824  LaBolk      Added method Exist_Invent_Purch_Sales_Parts. Added constants inst_PurchasePart_ and inst_SalesPart_. Added UNDEFINE statements.
--  040810  DAYJLK      Removed the code tags added by merge of LCS Patch 43935.
--  040715  FRWAUS      Bug 43935 merge as follows
--          SuDeUs      Bug 43935. Modified Unpack_Check_Insert__ and Unpack_Check_Update__ to
--                      prevent the user from entering Serial Tracking and Order-Based Lot
--                      Tracking combination for a Part.
--  040713  HeWelk      Modify Unpack_Check_Insert___,Unpack_Check_Update___
--                      validate the unit_code and input_unit_meas_group_id.
--  040712  HeWelk      Added column input_unit_meas_group_id to view Part_Catalog.
--  040630  SeJalk      Bug 46337, Added the error message LOTRULECOMBNA in procedure Check_For_Valid_Values___.
--  040630  SeJalk      Bug 45033, Added Warning message UPDATEALLOWCONDCODE in procedure Modify__.
--  040625  KaDilk      Bug 45031, Modified procedures New__, Modify__ and added the error message POSITIONPART.
--  040521  IsWilk      Modified the PROCEDURE Unpack_Check_Update___ to add the
--  040521              Error message to check the SplitManufAcquired flag on.
--  040428  IsWilk      Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040225  LoPrlk      Removed substrb from code. &VIEW was altered.
--  040217  IsWilk      Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040129  LaBolk      Changed view to SITE_PUBLIC in the dynamic calls of methods Update_Mfg_Config___ and Update_Sales_Config___.
--  040119  LaBolk      Changed the dynamic coding in Update_Mfg_Config___ and Update_Sales_Config___ to use EXECUTE IMMEDIATE.
--  040119              Removed call to public cursor get_site_cur in the same methods and used a local cursor instead.
--  040119              Removed the EXCEPTION part in both the above methods.
--  040114  ErSolk      Bug 39502, Modified procedure Check_Valid_Serial___.
--  040102  IsAnlk      Position changed in Check_Valid_Lot___ to avoid the brown code in Design.
--  -------------------------------- 12.3.0 ----------------------------------
--  031210  LaBolk      Changed view comments of lot_tracking_code, serial_rule and serial_tracking_code to modify the length of client value columns.
--  031210              Added block comments in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  031020  AnLaSe      Call Id 107412: Removed attributes amd methods for lot_inspect_period and lot_inspect_rule.
--  031014  LEPESE      Added check for uppercase on part_no in Unpack_Check_Insert___.
--  031013  PrJalk      Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030804  DAYJLK      Performed SP4 Merge.
--  030822  JOHESE      Changed Check_Update_Position_Part___
--  030817  JOHESE      Added function Get_Position_Part_Db and changed Check_Update_Position_Part___
--  030502  JOHESE      Added view PART_CATALOG_LOV
--  030403  JOHESE      Added public attribute Position Part, added new procedure Check_Update_Position_Part___ and modified procedure Create_Part
--  030228  Shvese      Added Procedure Check_Valid_Serial___ for validating serial flags.
--                      Removed Change_Lot_Tracking___ and added Check_Valid_Lot___.
--  030226  Shvese      Changed IN parameters in call to Invent_Part_Config_Manager_API.Check_Configurable_Change.
--  030206  Shvese      Changed the parameters to the method Check_Update_Config_Flag__.
--  030130  Shvese      Reorganised unpack_check_insert and unpack_check_update and moved the common
--                      validations to a new method Check_For_Valid_Values___.
--  ***********************************Take Off Phase 2***********************************************************
--  030124  AnLaSe      Bug 35510, Modified condition for check if part is allocated in method
--                      Unpack_Check_Update___(Check_Valid_Serial___). The check should be performed also when changing
--                      a part TO being serial handled.
--  021127  RoAnse      Bug 34489, Made calls to Sales_Part_API in Procedure Validate_Set_Configurable dynamic.
--  021118  MiKulk      Bug 33748, Modified the Procedure Unpack_Check_Update___ and Procedure Validate_Set_Configurable by adding another parameter to return the result of the validation.
--  021106  MiKulk      Bug 33748, Added the procedure Validate_Set_Configurable to add a check before modifying the configurable property
--  021106              of a sales part that is already connected to a configurable inventory part.
--  021009  Chfolk      Modified Procedure Prepare_Insert___. Added DB values of serial_tracking_code, eng_serial_tracking_code, configurable and condition_code_usage instead of client to the attr.
--  020820  ANLASE      Modified validation for condition_code_usage. Now OK to change from NOT ALLOWED to ALLOWED.
--  020814  ANLASE      Added validation for updating condition_code_usage in Unpack_Check_Update___.
--                      Added global variabel inst_InvPart_.
--  020730  NABEUS      Added validation for condition_code_usage, allow condition code only for
--                      serial tracked and/or lot batch tracked parts.
--  020716  BEHAUS      Merged Lot Batch Tracking Implementation.
--  020611  PEKR        Added Get_Condition_Code_Usage_Db.
--  020606  PEKR        Added Condition_Code_Usage_Db_ parameter to Procedure Create_Part.
--  020527  PEKR        Added Condition_Code_Usage.
--  020522  CHFOLK      Modified the procedure, Unpack_Check_Update___ to extend the length of the parameter, max_serial_no_ in dynamic call to Get_Max_Serial_No.
--  020516  CHFOLK      Increased the length of max_serial_no_ from 15 to 50 in PROCEDURE Unpack_Check_Update___.
--  *********************** AV 2002-3 Baseline ********************************************************
--  010105  ANLASE      Removed trace in Check_Update_Config_Flag___.
--  001221  ANLASE      Added check for QUAMAN in Check_Update_Config_Flag___. Removed check for PROSCH since this
--                      check is handled in Invent_Part_Config_Manager_API.Check_Configurable_Change.
--  001215  ANLASE      Removed call to supp_sched_agreement_api.check_configurable_change in
--                      method Check_Update_Config_Flag___
--  001206  ANLASE      Added check for EQUIP, PCM and CBS in Check_Update_Config_Flag___.
--  001204  ANLASE      Added check for SUPSCH in Check_Update_Config_Flag___.
--  001201  ANLASE      Added check for CFGCHR, MASSCH, MRP, MFGSTD in Check_Update_Config_Flag___.Removed call to make_part_not_configurable, since
--                      this is called in Config_Manager_API.Check_Configurable_Change.
--  001130  ANLASE      Added check for component SHPORD in Check_Update_Config_Flag___, modified check for configurable in method Update___.
--  001129  ANLASE      Added call to CONFIG_MANAGER_API.Make_Part_Not_Configurable in Update___.
--  001129  PaLj        Made calls to Cust_Warranty_API.Exist and Sup_Warranty_API.Exist dynamic.
--  001129  ANLASE      Added checks for components PROSCH, KANBAN, DOP and PURCH in Check_Update_Config_Flag.
--  001127  ANLASE      Added checks for components PDMCOM, PDMPRO, PROJ and ORDER in Check_Update_Config_Flag.
--  001123  ANLASE      Added new functionality for Check_Update_Config_Flag___.
--  001101  PaLj        Added NOCHECK on view comments for cust_warranty_id and sup_warranty_id.
--  001019  PaLj        Added cust_warranty_id and sup_warranty_id.
--  001013  ANLASE      Added validation for shop_order_proposal_flag in Check_Update_Config_Flag___.
--  001003  ANLASE      Added validations in Check_Update_Config_Flag___.
--  000925  JOHESE      Added undefines.
--  000919  JOHESE      Changed inventory_part_location_api calls to inventory_part_in_stock_api
--  000911  ANLASE      Added validations in Check_Update_Config_Flag___ to prevent creating
--                      configured parts with FIFO/LIFO and configured pallet handled parts.
--  000825  ANLASE      Modified check for part recipe in Check_Update_Config_Flag___.
--  000725  FBENSE      Renamed Inventory_Part_Config_API to Part_Configuration_API.
--  000719  GBO         Cleaned move of configurable flag.
--                      Removed unused variables in unpack_check_update___
--                      Corrected end of procedure Update_Mfg_Config___ and added an exception block for closing dynamic
--                      block.
--                      In Get_Configurable_Db and Get_Configurable use table instead of view.
--  000713  GBO         Merged from Chameleon
--                      Added field configurable,  added function Get_Configurable_Db, Check_Update_Config_Flag___,
--                      Update_Mfg_Config___, Update_Sales_Config___
--                      Added parameter configurable_db_ to procedure Create_Part
--  ------------------------------------ 12.00 -----------------------------------------------
--  000619  NISOSE      Made a correction in Unpack_Check_Update___.
--  000602  NISOSE      Added a check in Unpack_Check_Update___ if it is allowed to change the
--                      serial tracking code.
--  000418  NISOSE      Added General_SYS.Init_Method in Create_Part.
--  000321  LEPE        Corrected closing of dynamic cursor in EXCEPTION part of Update___.
--  000306  SHVE        Changed to handle return db values for calls to Get_Lot_Batch_Track_Status
--                      and Get_Serial_Track_Status.
--  990610  FRDI        Added an extra default parameter to Create_Part.
--  990609  FRDI        Done changes in unpack_check_uppdate due to chages in Engeeniering.
--  990608  FRDI        Adding check if Manf is installed.
--  990603  FRDI        Made Not-Eng_serial_tracking_Serial_tracking default on insertion and
--                      make ENG_PART_MASTER_API.Check_Unit_Change_Dyn only when Unit is changed.
--  990603  FRDI        Fixed bug in dymanic call to Eng_Part_Master_API.Check_Change_Serial_Allowed.
--  990521  SHVE        Added validations for serial rule.
--  990414  FRDI        Upgraded to performance optimized template.
--  990317  FRDI        Error is now propagated to the client if it occurrs in Update___.
--  990216  FRDI        Added dynamic call in Update___ to Eng_Part_Master_API.Change_Serial_Type.
--  990216  FRDI        Changed syntax in dynamic calls in Change_Serial_Tracking___.
--  990210  TOBE        Added parameters part_main_group and eng_serial_tracking_code_ in Create_Part
--                      with default values of NULL.
--  990209  TOBE        Changed return type to Number for Change_Eng_Serial_Tracking___ and
--                      Change_Eng_Serial_Tracking___
--  990203  TOBE        Added method Get_Eng_Serial_Tracking_Db and Change_Eng_Serial_Tracking___.
--  990129  LEPE        Added method Get_Serial_Tracking_Code_Db.
--  990128  LEPE        Added method Get_Lot_Tracking_Code_Db.
--  981119  SHVE        SID:7527,7529 Error when trying to change LotTrackingCode.
--  981003  SHVE        Made call to methods in InventoryPartLocation dynamic.
--  981020  SHVE        Added implementation methods  Change_Serial_Tracking___  and
--                      Change_Lot_Tracking___
--  981009  SHVE        Added columns serial_rule,serial_tracking_code and lot_tracking_code.
--  980804  GOPE        Cleanup more design correct.
--  980603  JOHW        Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980424  CLCA        Changed Error Message in Insert___.
--  980330  TOWI        Added view columns lu_name and key_ref.
--  971124  TOOS        Upgrade to F1 2.0
--  970616  NiHe        Description is changed to format uppercase.
--  970603  AnLi        Changed the lenght on info_text in comment on... to 2000
--  970527  JoRo        Modified std_name_id to Mandatory.
--  970526  ANLI        Bugfix in create_part
--  970521  ANLI        Added Function Check_Part_Exists2 and added functionality
--                      to start with default value in std_name.
--  970520  ANLI/NIHE   Changed uom to unit_code, changed std_name_id not to
--                      be mandatory and renamed function get_uom to get_unit_code
--  970515  JoRo        Corrected error in Dynamic call to EngPartMaster in
--                      Unpack_Check_Insert___.
--  970313  NIHE/ANLI   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                  CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

db_serial_tracking_           CONSTANT VARCHAR2(15) := Part_Serial_Tracking_API.db_serial_tracking;

db_not_serial_tracking_       CONSTANT VARCHAR2(19) := Part_Serial_Tracking_API.db_not_serial_tracking;

db_true_                      CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_                     CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;



-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Update_Config_Flag___
--   Verifies if it is possible to update Configurable from NOT CONFIGURED
--   to CONFIGURED or vice versa.
--   Calls are made to various component where validations specific to
--   the components are performed.
PROCEDURE Check_Update_Config_Flag___ (
   newrec_ IN part_catalog_tab%ROWTYPE )
IS
BEGIN
   -- Configurable flag is only used when ConfigPartCatalog is installed
   $IF (Component_Cfgchr_SYS.INSTALLED)$THEN 
      --Each component has its own checks and error messages for update configurable flag

      --CFGCHR
      Config_Manager_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);

      --MFGSTD
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN  
         Manuf_Structure_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 
      --CBS
      $IF (Component_Cbsint_SYS.INSTALLED) $THEN
         Cbs_So_Int_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --INVENT
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Part_Config_Manager_API.Check_Configurable_Change(newrec_.part_no,      
                                          newrec_.configurable,
                                          newrec_.condition_code_usage,
                                          newrec_.lot_tracking_code,
                                          newrec_.serial_tracking_code,
                                                                  newrec_.receipt_issue_serial_track);
      $ELSE 
         NULL;
      $END 

      --EQUIP
      $IF (Component_Equip_SYS.INSTALLED)$THEN 
         Equipment_Object_Spare_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --PCM
      $IF (Component_Wo_SYS.INSTALLED)$THEN 
         Work_Order_Utility_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END

      --MASSCH
      $IF (Component_Massch_SYS.INSTALLED) $THEN 
         Level_1_Part_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --MRP
      $IF (Component_Mrp_SYS.INSTALLED)$THEN
         Spare_Part_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --DOP
      $IF (Component_Dop_SYS.INSTALLED) $THEN 
         Dop_Order_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --SHPORD
      $IF (Component_Shpord_SYS.INSTALLED) $THEN 
         Shop_Ord_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --KANBAN
      $IF (Component_Kanban_SYS.INSTALLED) $THEN
         Kanban_Manager_Int_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --PROJ
      $IF (Component_Proj_SYS.INSTALLED)$THEN
         PROJECT_MISC_PROCUREMENT_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --QUAMAN
      $IF (Component_Quaman_SYS.INSTALLED) $THEN
         Qman_Control_Plan_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --PURCH
      $IF (Component_Purch_SYS.INSTALLED)$THEN
         Purchase_Order_Line_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

      --ORDER
      $IF (Component_Order_SYS.INSTALLED)$THEN 
         Order_Config_Util_API.Check_Configurable_Change(newrec_.part_no, newrec_.configurable);
      $ELSE 
         NULL;
      $END 

   $ELSE
      Raise_ConfigPart_Error___;
   $END 
END Check_Update_Config_Flag___;

-- Update_Mfg_Config___
--   Updates structures when Configurable attribute has changed.
--   CTO End
PROCEDURE Update_Mfg_Config___ (
   part_no_ IN VARCHAR2 )
IS
BEGIN
   -- Convert any manufacturing structures to configuration structures if possible
   -- else raise error.
   $IF (Component_Mfgstd_SYS.INSTALLED)$THEN  
      DECLARE
         CURSOR get_site_cur IS
            SELECT contract
            FROM SITE_PUBLIC;
      BEGIN
         FOR site_rec IN get_site_cur LOOP
            IF Inventory_Part_API.Check_Exist(site_rec.contract, part_no_) THEN
               Manuf_Structure_Util_API.New_Heads(site_rec.contract, part_no_);
            END IF;
         END LOOP;
      END;
   $ELSE
      NULL;
   $END 
END Update_Mfg_Config___;

-- Check_For_Valid_Values___
--   Validates the possible values for certain attributes in part catalog
--   and also checks if certain combinations are allowed.
--   This method is called both from unpack_check_insert and unpack_check_update.
--   The common validations for both methods have been moved to this method.
PROCEDURE Check_For_Valid_Values___ (
   newrec_  IN part_catalog_tab%ROWTYPE)
IS
BEGIN
   -- Validations to enable Condition Code usage
   IF (newrec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
      -- Condition Code handing is enabled
      IF (newrec_.lot_tracking_code = 'NOT LOT TRACKING') THEN
         -- Part is not Lot Tracked
         IF (newrec_.serial_tracking_code = db_not_serial_tracking_) THEN
            -- Part is not SErial Tracked in Inventory
            Error_SYS.Record_General('PartCatalog','NOTALLOWCONDCODE: Condition code can be enabled only in combination with Inventory Serial Tracking and/or Lot/Batch Tracking.');
         END IF;
      ELSE
         -- Part is Lot Tracked
         IF ((newrec_.receipt_issue_serial_track = db_true_) AND
             (newrec_.serial_tracking_code       = db_not_serial_tracking_)) THEN
            -- Part is Receipt and Issue Serial Tracked but not Serial Tracked in Inventory
            Error_SYS.Record_General('PartCatalog','RECISSERCOND: Condition Codes cannot be used on a serial tracked part unless it is serial tracked In Inventory.');
         END IF;
      END IF;
   END IF;

   -- serial tracking combinations
   IF (newrec_.serial_tracking_code = db_serial_tracking_) THEN
      IF (newrec_.eng_serial_tracking_code = db_not_serial_tracking_) THEN
         Error_SYS.Record_General('PartCatalog', 'ININVENTAFTERDEL: Inventory Serial Tracking is only allowed in combination with After Delivery Serial Tracking.');
      END IF;
      IF ((newrec_.receipt_issue_serial_track = db_false_)) THEN
         Error_SYS.Record_General('PartCatalog', 'ISSUERCPTSERIALDIS: Receipt and Issue Serial Tracking must be enabled if the part is serial tracked in inventory.');
      END IF;
   END IF;

   IF ((newrec_.receipt_issue_serial_track = db_true_) AND
       (newrec_.eng_serial_tracking_code   = db_not_serial_tracking_)) THEN
      Error_SYS.Record_General('PartCatalog', 'RECISSAFTERDEL: Receipt And Issue Serial Tracking is only allowed in combination with After Delivery Serial Tracking.');
   END IF;
   -- Lot Batch Mod
   IF (newrec_.position_part = 'POSITION PART') THEN
      IF (newrec_.receipt_issue_serial_track = db_true_) THEN
         Error_SYS.Record_General('PartCatalog', 'PPSERIAL: A Position Part cannot be serial tracked.');
      END IF;
      IF (newrec_.configurable = 'CONFIGURED') THEN
         Error_SYS.Record_General('PartCatalog', 'PPCONFIGURED: A Position Part cannot be configured.');
      END IF;
   END IF;

   IF (newrec_.lot_quantity_rule = 'ONE_LOT' AND newrec_.sub_lot_rule = 'YES_SUBLOTS') THEN
      Error_sys.Record_General('PartCatalog', 'LOTRULECOMBNA: Sub Lots are not allowed when the Lot Quantity Rule is One Lot Per Production Order.');
   END IF;

   IF ((newrec_.lot_tracking_code          = 'NOT LOT TRACKING') AND
       (newrec_.receipt_issue_serial_track = db_false_         )) THEN
      IF (newrec_.multilevel_tracking = 'TRACKING_ON') THEN
         Error_SYS.Record_General('PartCatalog', 'MULTITRACKINGCOMB: The multi-level tracking flag is not allowed unless the part is either serial or lot tracked.');
      END IF;
   END IF;

   IF (newrec_.configurable = 'CONFIGURED')THEN
      $IF NOT (Component_Cfgchr_SYS.INSTALLED)$THEN 
         Raise_ConfigPart_Error___;
      $ELSE 
         NULL;
      $END 
   END IF;

   IF (newrec_.weight_net IS NOT NULL) THEN
      IF (newrec_.weight_net < 0) THEN
          Error_SYS.Record_General('PartCatalog', 'NOMINUSWEIGHT: Negative values are not allowed for Net Weight.');
      END IF;
      IF (newrec_.uom_for_weight_net IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMWEIGT: Field UoM for Weight requires a value.');
      ELSE
         IF ISO_UNIT_TYPE_API.Encode(ISO_UNIT_API.Get_Unit_Type(newrec_.uom_for_weight_net)) != 'WEIGHT' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGTYPE: Field UoM for Weight requires a unit of measure of type Weight.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.volume_net IS NOT NULL) THEN
      IF (newrec_.volume_net < 0) THEN
          Error_SYS.Record_General('PartCatalog', 'NOMINUSVOLUME: Negative values are not allowed for Net Volume.');
      END IF;
      IF (newrec_.uom_for_volume_net IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMVOLUME: Field UoM for Volume requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_volume_net)) != 'VOLUME' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTVOLUMEYPE: Field UoM for Volume requires a unit of measure of type Volume.');
         END IF;
      END IF;
   END IF;
END Check_For_Valid_Values___;


-- Check_Valid_Lot___
--   Validations for lot_tracking_code
--   Checks whether or not it is allowed to change the lot batch tracking flag.
--   It calls the InventPartLotManager for further validations.
PROCEDURE Check_Valid_Lot___ (
   newrec_  IN part_catalog_tab%ROWTYPE,
   old_rec_ IN part_catalog_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Invent_SYS.INSTALLED)$THEN
      Invent_Part_Lot_Manager_API.Check_Lot_Track_Change(newrec_.part_no,
                                                         newrec_.configurable,
                                                         newrec_.condition_code_usage,
                                                         newrec_.lot_tracking_code,
                                                         newrec_.serial_tracking_code,
                                                         newrec_.receipt_issue_serial_track);
   $END 

   -- Check if part is allocated
   $IF (Component_Shpord_SYS.INSTALLED)$THEN 
      Shop_Material_Alloc_List_API.Check_Part_Track_Change(newrec_.part_no, NULL);
   $END 

   IF (old_rec_.lot_tracking_code  = 'NOT LOT TRACKING') AND (newrec_.lot_tracking_code IN ('LOT TRACKING','ORDER BASED')) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN 
         Purchase_Part_API.Check_Enable_Part_Tracking(newrec_.part_no);
      $ELSE 
         NULL;
      $END 

      $IF (Component_Order_SYS.INSTALLED)$THEN 
         Sales_Part_API.Check_Enable_Part_Tracking(newrec_.part_no);
      $ELSE 
         NULL;
      $END 
   END IF;

   Reserved_Lot_Batch_API.Check_Lot_Track_Change(newrec_.part_no);
END Check_Valid_Lot___;


-- Check_Valid_Serial___
--   Validates the possible values for serial tracking code and
--   eng serial tracking code in part catalog and also checks
--   if certain combinations are allowed.
--   This method is called both from unpack_check_update.
PROCEDURE Check_Valid_Serial___ (
   newrec_ IN part_catalog_tab%ROWTYPE,
   oldrec_ IN part_catalog_tab%ROWTYPE )
IS
   exist_mrp_code_ VARCHAR2(10);
   check_result_   NUMBER;
   attr_           VARCHAR2(32000);
BEGIN
   IF ((newrec_.eng_serial_tracking_code   != oldrec_.eng_serial_tracking_code  ) OR 
       (newrec_.receipt_issue_serial_track != oldrec_.receipt_issue_serial_track)) THEN
      IF ((newrec_.eng_serial_tracking_code   = db_serial_tracking_) OR
          (newrec_.receipt_issue_serial_track = db_true_)) THEN
         $IF (Component_Invent_SYS.INSTALLED)$THEN
            exist_mrp_code_ := Inventory_Part_Planning_API.Check_Planning_Method_K_O(newrec_.part_no);
            IF (exist_mrp_code_ = db_true_) THEN
               Error_Sys.Record_General(lu_name_,'EXISTMRPCODE: Serial tracking is not allowed when Mrp codes K or O are used.');
            END IF;
         $ELSE 
            NULL;
         $END 
      END IF;

      $IF (Component_Invent_SYS.INSTALLED)$THEN 
         Serial_No_Reservation_API.Check_Update_Serial_Tracking(newrec_.part_no);
      $END
   END IF;

   IF ((newrec_.serial_tracking_code       != oldrec_.serial_tracking_code      ) OR 
       (newrec_.receipt_issue_serial_track != oldrec_.receipt_issue_serial_track)) THEN
      $IF (Component_Invent_SYS.INSTALLED)$THEN
         Invent_Part_Serial_Manager_API.Check_Serial_Track_Change(newrec_.part_no,
                                                                  newrec_.configurable,
                                                                  newrec_.condition_code_usage,
                                                                  newrec_.lot_tracking_code,
                                                                  oldrec_.serial_tracking_code,
                                                                  oldrec_.receipt_issue_serial_track,
                                                                  newrec_.serial_tracking_code,
                                                                  newrec_.receipt_issue_serial_track);
      $ELSE 
         NULL;
      $END 
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN 
          Production_Line_Part_API.Check_Serial_Track_Change(newrec_.part_no,
                                                             newrec_.serial_tracking_code,
                                                             newrec_.receipt_issue_serial_track);
      $ELSE 
         NULL;
      $END 
      $IF (Component_Kanban_SYS.INSTALLED)$THEN 
         Kanban_Circuit_API.Check_Serial_Track_Change(newrec_.part_no, newrec_.serial_tracking_code);
      $ELSE 
         NULL;
      $END
      IF (newrec_.receipt_issue_serial_track = db_true_) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            Purchase_Part_API.Check_Serial_Track_Change(newrec_.part_no,
                                                        newrec_.serial_tracking_code,
                                                        newrec_.receipt_issue_serial_track);
         $ELSE 
            NULL;
         $END
      END IF;   
      $IF (Component_Order_SYS.INSTALLED)$THEN
         Sales_Part_API.Check_Serial_Track_Change(newrec_.part_no,
                                                  newrec_.serial_tracking_code,
                                                  newrec_.receipt_issue_serial_track);   
      $ELSE 
         NULL;
      $END
      
   END IF;

   IF (newrec_.receipt_issue_serial_track != oldrec_.receipt_issue_serial_track) THEN
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
         Manuf_Structure_Util_API.Check_Serial_Tracking_Change(newrec_.part_no,     
                                                               newrec_.receipt_issue_serial_track);
      $END 
      
      -- Check if part is allocated
      $IF (Component_Shpord_SYS.INSTALLED)$THEN 
         Shop_Material_Alloc_List_API.Check_Part_Track_Change(newrec_.part_no, NULL, newrec_.receipt_issue_serial_track); 
      $END 

      -- Check if part_no exists on a active order line.
      -- Status not in 'Planned', 'Cancelled', 'Closed'
      $IF (Component_Purch_SYS.INSTALLED)$THEN 
         check_result_ := Purchase_Order_Line_Part_API.Part_Exist(newrec_.part_no, NULL);
         Trace_SYS.Message(' serial:Purchase_Order_Line_Part_API.Part_Exist' || check_result_);
         IF (check_result_ = 1) THEN
            Error_SYS.Record_General('PartCatalog', 'NOSERIALTRACKING5: The part exists on a Purchase Order Line');
         END IF;
      $END 

      IF (newrec_.receipt_issue_serial_track = db_true_) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN 
            Purchase_Part_API.Check_Enable_Part_Tracking(newrec_.part_no);
         $ELSE 
            NULL;
         $END
         $IF (Component_Order_SYS.INSTALLED)$THEN
            Sales_Part_API.Check_Enable_Part_Tracking(newrec_.part_no);   
         $ELSE 
            NULL;
         $END     
      END IF;
   END IF;

   IF (newrec_.eng_serial_tracking_code != oldrec_.eng_serial_tracking_code ) THEN
      -- Check if this part has any serial no in part serial catalog
      IF ((Part_Serial_Catalog_API.Part_Has_Serials(newrec_.part_no)) AND
          (newrec_.eng_serial_tracking_code = db_not_serial_tracking_)) THEN
         Error_SYS.Record_General(lu_name_, 'ENG_SERIAL: The part exists in part serial catalog');
      END IF;
      -- Check if

      $IF (Component_Pdmcon_SYS.INSTALLED)$THEN 
         Eng_Part_Master_API.Check_Change_Serial_Allowed(newrec_.part_no, newrec_.unit_code, Part_Serial_Tracking_API.decode(newrec_.eng_serial_tracking_code));
         -- Check_Change_Serial_Allowed makes calls to Error_SYS.Record_General if the check fails.
      $END 
   END IF;

   -- Only for PDM: begin
   IF ((newrec_.unit_code !=  oldrec_.unit_code) AND (newrec_.eng_serial_tracking_code = db_serial_tracking_))  THEN
      $IF (Component_Pdmcon_SYS.INSTALLED)$THEN 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('PART_NO', newrec_.part_no, attr_);
         Client_SYS.Add_To_Attr('UNIT_CODE', newrec_.unit_code, attr_);
         Transaction_SYS.Dynamic_Call('ENG_PART_MASTER_API.Check_Unit_Change_Dyn', attr_);
      $ELSE 
         NULL;
      $END 
   END IF;
   -- Only for PDM: end

   --Check whether serial rule can be changed from MANUAL to AUTOMATIC
   IF ((newrec_.receipt_issue_serial_track = db_true_) AND
       (oldrec_.serial_rule = 'MANUAL')AND
       (newrec_.serial_rule = 'AUTOMATIC')) THEN
      $IF (Component_Invent_SYS.INSTALLED)$THEN 
         IF ((Serial_No_Reservation_API.Has_Alphanumeric_Serial(newrec_.part_no)) OR 
              (Part_Serial_Catalog_API.Has_Alphanumeric_Serial(newrec_.part_no))) THEN
             Error_SYS.Record_General(lu_name_, 'VALIDNUMBER: Alphanumeric serials exist for this part.');   
         END IF;
      $ELSE 
         NULL;
      $END
   END IF;
END Check_Valid_Serial___;


-- Check_Update_Unit_Code___
--   Validates the changing of Unit Code in Part Catalog
PROCEDURE Check_Update_Unit_Code___ (
   newrec_  IN part_catalog_tab%ROWTYPE,
   oldrec_  IN part_catalog_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Pdmcon_SYS.INSTALLED)$THEN
      Eng_Part_Revision_API.Check_Unitcode_Changeable(newrec_.part_no); 
   $ELSE
      NULL; 
   $END 
   $IF (Component_Invent_SYS.INSTALLED) $THEN 
      Inventory_Part_API.Check_Partcat_Unit_Code_Change(newrec_.part_no, oldrec_.unit_code, newrec_.unit_code);
   $ELSE
      NULL;
   $END 
END Check_Update_Unit_Code___;


-- Handle_Description_Change___
--   Handles part catalog description change for InventoryPart and EquipmentSerial.
PROCEDURE Handle_Description_Change___ (
   part_no_ IN VARCHAR2 )
IS
   key_ref_    VARCHAR2(2000);
   objid_      Part_Catalog.objid%TYPE;
   objversion_ Part_Catalog.objversion%TYPE;
BEGIN
   $IF (Component_Equip_SYS.INSTALLED)$THEN 
      Equipment_Serial_API.Handle_Part_Desc_Change(part_no_);
   $ELSE
      NULL;       
   $END 

   $IF (Component_Invent_SYS.INSTALLED) $THEN 
      Inventory_Part_API.Handle_Partca_Desc_Change(part_no_);
   $ELSE
      NULL;       
   $END 

   $IF (Component_Pdmcon_SYS.INSTALLED)$THEN
      Eng_Part_Revision_API.Handle_Part_Desc_Change(part_no_);
   $ELSE
      NULL;      
   $END 

   $IF (Component_Order_SYS.INSTALLED)$THEN
      Sales_Part_API.Handle_Partca_Desc_Change(part_no_);
   $ELSE
      NULL;       
   $END 

   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      Purchase_Part_API.Handle_Partca_Desc_Change(part_no_);
   $ELSE
      NULL;       
   $END 

   $IF (Component_Docman_SYS.INSTALLED)$THEN 
      Get_Id_Version_By_Keys___(objid_, objversion_, part_no_);
      Client_SYS.Get_Key_Reference(key_ref_, lu_name_, objid_);
      Doc_Reference_Object_API.Refresh_Object_Reference_Desc(lu_name_, key_ref_);
   $ELSE
      NULL;       
   $END 
END Handle_Description_Change___;


PROCEDURE Check_Allow_As_Not_Consumed___ (
   newrec_                        IN part_catalog_tab%ROWTYPE,
   updated_allow_as_not_consumed_ IN BOOLEAN)
IS
BEGIN
   IF (newrec_.allow_as_not_consumed = db_true_) THEN
      IF ((newrec_.receipt_issue_serial_track = db_true_) OR
          (newrec_.lot_tracking_code IN ('LOT TRACKING','ORDER BASED')))THEN 
         Client_SYS.Add_Warning(lu_name_, 'ALLWNTCNSUMDINST: Enabling Allow as Not Consumed for Serial and/or lot batch tracking will result in that the part cannot be completly tracked.');
      END IF;
   ELSE
      IF (updated_allow_as_not_consumed_) THEN
         $IF (Component_Invent_SYS.INSTALLED)$THEN 
            Inventory_Part_API.Check_Disallow_As_Not_Consumed(newrec_.part_no);
         $ELSE 
            NULL;
         $END 
         $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
            Manuf_Structure_API.Check_Disallow_As_Not_Consumed(newrec_.part_no);
         $ELSE 
            NULL;
         $END 
      END IF;
   END IF;
END Check_Allow_As_Not_Consumed___;


-- Check_Catch_Unit_Enabled___
--   Validations for Catch_Unit_Enabled
PROCEDURE Check_Catch_Unit_Enabled___ (
   newrec_  IN part_catalog_tab%ROWTYPE,
   old_rec_ IN part_catalog_tab%ROWTYPE )
IS
BEGIN
   IF (old_rec_.catch_unit_enabled = db_false_) AND (newrec_.catch_unit_enabled = db_true_) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN 
         Purchase_Part_API.Check_Enable_Catch_Unit(newrec_.part_no);
      $ELSE 
         NULL;
      $END 

      $IF (Component_Order_SYS.INSTALLED)$THEN 
         Sales_Part_API.Check_Enable_Catch_Unit(newrec_.part_no);
      $ELSE 
         NULL;
      $END 
   END IF;
END Check_Catch_Unit_Enabled___;


PROCEDURE Raise_ConfigPart_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'CONFIGNOTINST: Part cannot be set to configurable since ConfigPartCatalog is not installed.');
END Raise_ConfigPart_Error___;


PROCEDURE Raise_Input_Uom_Error___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'NOTINPUTUOM: The Inventory UoM of Default Input UoM Group must be equal to Unit Code.');
END Raise_Input_Uom_Error___; 

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   --Gives default value for std_name_id = 0. '0' indicates no standard name exists.
   Client_SYS.Add_To_Attr('STD_NAME_ID'                  , 0                                                 , attr_ );
   Client_SYS.Add_To_Attr('LOT_TRACKING_CODE'            , Part_Lot_Tracking_API.Decode ('NOT LOT TRACKING') , attr_ );
   Client_SYS.Add_To_Attr('SERIAL_TRACKING_CODE_DB'      , db_not_serial_tracking_                           , attr_ );
   Client_SYS.Add_To_Attr('SERIAL_RULE'                  , Part_Serial_Rule_API.Decode ('MANUAL')            , attr_ );
   Client_SYS.Add_To_Attr('ENG_SERIAL_TRACKING_CODE_DB'  , db_not_serial_tracking_                           , attr_ );
   Client_SYS.Add_To_Attr('CONFIGURABLE_DB'              , 'NOT CONFIGURED'                                  , attr_ );
   Client_SYS.Add_To_Attr('CONDITION_CODE_USAGE_DB'      , 'NOT_ALLOW_COND_CODE'                             , attr_ );
   Client_SYS.Add_To_Attr('POSITION_PART_DB'             , 'NOT POSITION PART'                               , attr_ );
   Client_SYS.Add_To_Attr('LOT_QUANTITY_RULE'            , Lot_Quantity_Rule_API.Decode('ONE_LOT')           , attr_ );
   Client_SYS.Add_To_Attr('SUB_LOT_RULE'                 , Sub_Lot_Rule_API.Decode('NO_SUBLOTS')             , attr_ );
   Client_SYS.Add_To_Attr('CATCH_UNIT_ENABLED_DB'        , db_false_                                         , attr_ );
   Client_SYS.Add_To_Attr('MULTILEVEL_TRACKING_DB'       , 'TRACKING_OFF'                                    , attr_ );
   Client_SYS.Add_To_Attr('COMPONENT_LOT_RULE'           , Component_Lot_Rule_API.Decode('MANY_LOTS_ALLOWED'), attr_ );
   Client_SYS.Add_To_Attr('STOP_ARRIVAL_ISSUED_SERIAL_DB', db_true_                                          , attr_ );
   Client_SYS.Add_To_Attr('FREIGHT_FACTOR'               , 1                                                 , attr_ );
   Client_SYS.Add_To_Attr('ALLOW_AS_NOT_CONSUMED_DB'     , db_false_                                         , attr_ );
   Client_SYS.Add_To_Attr('RECEIPT_ISSUE_SERIAL_TRACK_DB', db_false_                                         , attr_ );
   Client_SYS.Add_To_Attr('STOP_NEW_SERIAL_IN_RMA_DB'    , db_true_                                          , attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_catalog_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- CTO IF Config Characteristic Module is Installed then Insert ConfigPartCatalog
   $IF (Component_Cfgchr_SYS.INSTALLED)$THEN 
      Config_Part_Catalog_API.New(newrec_.part_no);
   $END 

   -- ECOMAN, IF ecoman module is installed then insert ecoman data
   $IF Component_Ecoman_SYS.INSTALLED $THEN
      Ecoman_Part_Info_API.New(
         newrec_.part_no);
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     part_catalog_tab%ROWTYPE,
   newrec_     IN OUT part_catalog_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   old_eng_serial_track_ VARCHAR2(200);
   number_null_          NUMBER := -9999999;
BEGIN
   old_eng_serial_track_ := Get_Eng_Serial_Tracking_Code(newrec_.part_no);
   
   -- Remove the UoMs when relevant value are null.
   IF (newrec_.weight_net IS NULL) THEN
      newrec_.uom_for_weight_net := NULL;
   END IF;
   IF (newrec_.volume_net IS NULL) THEN
      newrec_.uom_for_volume_net := NULL;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF newrec_.serial_tracking_code != oldrec_.serial_tracking_code AND newrec_.serial_tracking_code = Part_Serial_Tracking_API.DB_SERIAL_TRACKING THEN
      Part_Serial_Catalog_API.Disable_Tracked_In_Inventory(newrec_.part_no);
   END IF;

   $IF (Component_Pdmcon_SYS.INSTALLED)$THEN 
      Eng_Part_Master_API.Change_Serial_Type(newrec_.part_no, old_eng_serial_track_, Part_Serial_Tracking_API.Decode(newrec_.eng_serial_tracking_code));
   $END 
   -- CTO Perform updates related to config flag
   IF  (oldrec_.configurable != newrec_.configurable) THEN
      Part_Catalog_API.Update_Mfg_Config___(newrec_.part_no);
   END IF;
   -- CTO End

   IF Validate_SYS.Is_Changed(oldrec_.technical_drawing_no, newrec_.technical_drawing_no) THEN
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
         Part_Revision_API.Handle_Tech_Drawing_Change(newrec_.part_no, newrec_.technical_drawing_no);
      $ELSE 
         NULL;   
      $END   
      $IF (Component_Pdmcon_SYS.INSTALLED)$THEN
         Eng_Part_Revision_API.Handle_Tech_Drawing_Change(newrec_.part_no, newrec_.technical_drawing_no);
      $ELSE
         NULL; 
      $END
   END IF;
   
   -- Handle validations when enabling catch unit.
   IF ((oldrec_.catch_unit_enabled = db_false_) AND
       (newrec_.catch_unit_enabled = db_true_)) THEN
      --if there are existing sales parts with different price U/M can not enable catch unit.
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Inventory_Part_API.Check_Enable_Catch_Unit(newrec_.part_no); 
         Invent_Catch_Unit_Manager_API.Handle_Enable_Catch(newrec_.part_no);
      $ELSE 
         NULL;
      $END 
   END IF;

   IF ((newrec_.description) != (oldrec_.description))  THEN
      Handle_Description_Change___(newrec_.part_no);
   END IF;

   IF ((newrec_.receipt_issue_serial_track != oldrec_.receipt_issue_serial_track) AND
       (newrec_.receipt_issue_serial_track = db_true_))  THEN
      $IF (Component_Invent_SYS.INSTALLED)$THEN 
         Invent_Part_Serial_Manager_API.Handle_Enable_Serial_Tracking(newrec_.part_no);
      $ELSE 
         NULL;
      $END 
      
      $IF (Component_Purch_SYS.INSTALLED) $THEN 
         Purchase_Part_API.Handle_Enable_Serial_Tracking(newrec_.part_no);
      $ELSE 
         NULL;
      $END
      IF (newrec_.condition_code_usage = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
         Lot_Batch_Master_API.Reset_Condition_Code(newrec_.part_no);
      END IF;   
   END IF;

   IF (newrec_.multilevel_tracking != oldrec_.multilevel_tracking) THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN 
         Shop_Ord_Util_API.Handle_Multilevel_Track_Change(newrec_.part_no, newrec_.multilevel_tracking);
      $ELSE 
         NULL;
      $END 
   END IF;

   IF (oldrec_.input_unit_meas_group_id IS NOT NULL) THEN
      IF (NVL(newrec_.input_unit_meas_group_id, string_null_) != NVL(oldrec_.input_unit_meas_group_id, string_null_)) THEN
         IF (Part_Gtin_Unit_Meas_API.Check_Exist_Any_Unit(newrec_.part_no)) THEN
            Client_SYS.Add_Info(lu_name_, 'GTIN14DELETE: Manually changing or deleting the input unit of measure in the part catalog will remove all connected GTIN 14 for packages.');
            Part_Gtin_Unit_Meas_API.Remove_All_Gtin14(newrec_.part_no);
         END IF;
      END IF;
   END IF;
   
   IF (oldrec_.lot_tracking_code != newrec_.lot_tracking_code) THEN
      IF ((oldrec_.lot_tracking_code= 'NOT LOT TRACKING') OR 
          (newrec_.lot_tracking_code= 'NOT LOT TRACKING')) THEN
         $IF Component_Invent_SYS.INSTALLED $THEN
            Invent_Part_Lot_Manager_API.Handle_Lot_Tracking_Change(newrec_.part_no);
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
   
   IF (NVL(oldrec_.weight_net, number_null_) != NVL(newrec_.weight_net, number_null_)) OR
      (NVL(oldrec_.volume_net, number_null_) != NVL(newrec_.volume_net, number_null_)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Freight_Charge_API.Calculate_Freight_Charges(newrec_.part_no);
      $ELSE
         NULL;
      $END   
   END IF;   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN part_catalog_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(objid_, remrec_);
   key_ := remrec_.part_no||'^';
   Technical_Object_Reference_API.Delete_Reference(lu_name_, key_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_      IN OUT part_catalog_tab%ROWTYPE,
   indrec_      IN OUT Indicator_Rec,
   attr_        IN OUT VARCHAR2,
   from_client_ IN     BOOLEAN DEFAULT TRUE )
IS
   name_            VARCHAR2(30);
   value_           VARCHAR2(4000);
   input_group_uom_ INPUT_UNIT_MEAS_GROUP_TAB.unit_code%TYPE;
BEGIN
   IF NOT(indrec_.std_name_id) THEN
      newrec_.std_name_id := 0;
   END IF;

   IF NOT(indrec_.lot_tracking_code) THEN
      newrec_.lot_tracking_code := 'NOT LOT TRACKING';
   END IF;

   IF NOT(indrec_.serial_tracking_code) THEN
      newrec_.serial_tracking_code := db_not_serial_tracking_;
   END IF;

   IF NOT(indrec_.serial_rule) THEN
      newrec_.serial_rule := 'MANUAL';
   END IF;

   IF NOT(indrec_.eng_serial_tracking_code) THEN
      newrec_.eng_serial_tracking_code := db_not_serial_tracking_;
   END IF;

   IF NOT(indrec_.configurable) THEN
      newrec_.configurable := 'NOT CONFIGURED';
   END IF;

   IF NOT(indrec_.lot_quantity_rule) THEN
      newrec_.lot_quantity_rule := 'ONE_LOT';
   END IF;

   IF NOT(indrec_.sub_lot_rule) THEN
      newrec_.sub_lot_rule := 'NO_SUBLOTS';
   END IF;

   IF NOT(indrec_.position_part) THEN
      newrec_.position_part := 'NOT POSITION PART';
   END IF;

   IF NOT(indrec_.catch_unit_enabled) THEN
      newrec_.catch_unit_enabled := db_false_;
   END IF;

   IF NOT(indrec_.multilevel_tracking) THEN
      newrec_.multilevel_tracking := 'TRACKING_OFF';
   END IF;

   IF NOT(indrec_.component_lot_rule) THEN
      newrec_.component_lot_rule := 'MANY_LOTS_ALLOWED';
   END IF;

   IF NOT(indrec_.stop_arrival_issued_serial) THEN
      newrec_.stop_arrival_issued_serial := db_true_;
   END IF;

   IF NOT(indrec_.allow_as_not_consumed) THEN
      newrec_.allow_as_not_consumed := db_false_;
   END IF;

   IF NOT(indrec_.receipt_issue_serial_track) THEN
      newrec_.receipt_issue_serial_track := db_false_;
   END IF;

   IF NOT(indrec_.stop_new_serial_in_rma) THEN
      newrec_.stop_new_serial_in_rma := db_true_;
   END IF;

   super(newrec_, indrec_, attr_);

   Error_SYS.Check_Valid_Key_String('PART_NO', newrec_.part_no);

   IF (newrec_.serial_tracking_code = db_serial_tracking_) THEN
      newrec_.receipt_issue_serial_track := db_true_;
   END IF;

   Check_For_Valid_Values___(newrec_);

   IF (newrec_.uom_for_weight_net IS NOT NULL) THEN
      IF (newrec_.weight_net IS NULL) THEN
         Error_SYS.Record_General('PartCatalog', 'NONETWEIGHTVAL: Field Net Weight requires a value if a UoM for Net Weight entered.');
      END IF;
   END IF;
   
   IF (newrec_.uom_for_volume_net IS NOT NULL) THEN
      IF (newrec_.volume_net IS NULL) THEN
         Error_SYS.Record_General('PartCatalog', 'NONETVOLUMEVAL: Field Net Volume requires a value if a UoM for Net Volume entered.');
      END IF;
   END IF;

   IF (upper(newrec_.part_no) != newrec_.part_no) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The part number must be entered in upper-case.');
   END IF;

   IF (newrec_.freight_factor IS NULL) THEN
      newrec_.freight_factor := 1;
   ELSE
      IF (newrec_.freight_factor <= 0) THEN
          Error_SYS.Record_General(lu_name_,'INVALFRFACTOR: Freight conversion factor has to be greater than 0.');
      END IF;
   END IF;

   --Check whether the Input UoM is equal to Unit Code
   IF (newrec_.input_unit_meas_group_id IS NOT NULL)  THEN
      input_group_uom_ := Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id);
      IF (input_group_uom_ != newrec_.unit_code ) THEN
         Raise_Input_Uom_Error___;
      END IF;
   END IF;
   
   Check_Allow_As_Not_Consumed___(newrec_, FALSE);

   IF (from_client_  AND newrec_.position_part = 'POSITION PART') THEN
      Error_sys.Record_General('PartCatalog', 'POSITIONPANA: It is not allowed to create Position Parts from the Part Catalog window.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN part_catalog_tab%ROWTYPE )
IS
BEGIN
   IF INSTR(remrec_.part_no, '^') > 0 THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDCHAR: Caret symbol is used in part no :P1. Removal is not permitted.', remrec_.part_no);
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_catalog_tab%ROWTYPE,
   newrec_ IN OUT part_catalog_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                          VARCHAR2(30);
   value_                         VARCHAR2(4000);  
   invpart_exist_                 VARCHAR2(10);
   temp_                          NUMBER :=0;
   input_group_uom_               INPUT_UNIT_MEAS_GROUP_TAB.unit_code%TYPE;
   mclot_exist_                   VARCHAR2(10);
   updated_allow_as_not_consumed_ BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Check_For_Valid_Values___(newrec_);

   --CTO Check whether configurable flag can be changed
   IF (oldrec_.configurable != newrec_.configurable) THEN
      Check_Update_Config_Flag___(newrec_);
   END IF;
   
   $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
      Part_Revision_API.Check_Drawing_No_Changed(newrec_.part_no, oldrec_.technical_drawing_no, newrec_.technical_drawing_no);
   $END
   
   $IF (Component_Pdmcon_SYS.INSTALLED)$THEN
      Eng_Part_Revision_API.Check_Drawing_No_Changed(newrec_.part_no, oldrec_.technical_drawing_no, newrec_.technical_drawing_no);     
   $END
   
   -- Not allowed to change to NOT ALLOWED condition_code_usage if an inventory part exists
   IF ((oldrec_.condition_code_usage = 'ALLOW_COND_CODE') AND (newrec_.condition_code_usage = 'NOT_ALLOW_COND_CODE')) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN 
         invpart_exist_ := Inventory_Part_API.Check_Exist_Anywhere(newrec_.part_no);
            IF (invpart_exist_ = db_true_) THEN
               Error_SYS.Record_General('PartCatalog','NOTCHANGECC: Condition Code usage cannot be disabled if an inventory part exists.');
            END IF;
      $ELSE 
         NULL;
      $END 
   END IF;

   --CTO End
   IF (oldrec_.lot_tracking_code != newrec_.lot_tracking_code)  THEN
       Check_Valid_Lot___(newrec_, oldrec_);
   END IF;

   IF (oldrec_.catch_unit_enabled != newrec_.catch_unit_enabled) THEN
      Check_Catch_Unit_Enabled___(newrec_, oldrec_);
   END IF;

   -- Check whether the Input UoM is equal to Unit Code
   IF (oldrec_.input_unit_meas_group_id != newrec_.input_unit_meas_group_id) OR
      ((oldrec_.input_unit_meas_group_id IS NULL) AND (newrec_.input_unit_meas_group_id IS NOT NULL)) THEN

      input_group_uom_ := Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id);
      IF (input_group_uom_ != newrec_.unit_code ) THEN
         Raise_Input_Uom_Error___;
      END IF;
   END IF;
   -- Check whether Unit Code has changed when Input UoM Group is attached.
   IF (oldrec_.unit_code != newrec_.unit_code) THEN
      IF (newrec_.input_unit_meas_group_id IS NOT NULL)  THEN
         Error_SYS.Record_General(lu_name_,'NOUPDATEUNITCODE: Unit Code can not be changed when an Input UoM Group is connected.');
      END IF;
   END IF;

   IF ((oldrec_.serial_tracking_code       != newrec_.serial_tracking_code      ) OR
       (oldrec_.receipt_issue_serial_track != newrec_.receipt_issue_serial_track) OR
       (oldrec_.eng_serial_tracking_code   != newrec_.eng_serial_tracking_code  ) OR
       (oldrec_.unit_code                  != newrec_.unit_code                 ) OR
       (oldrec_.serial_rule                != newrec_.serial_rule               )) THEN
      Check_Valid_Serial___(newrec_,oldrec_); 
   END IF;

   IF (oldrec_.multilevel_tracking != newrec_.multilevel_tracking) THEN      
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
         Manuf_Structure_Util_API.Check_Multilevel_Track_Change(newrec_.part_no, newrec_.multilevel_tracking);
      $ELSE
         NULL;
      $END 
   END IF;

   IF (newrec_.position_part = 'POSITION PART') THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         temp_ := Inventory_Part_Planning_API.Is_Manuf_Acquir_Split_Part(newrec_.part_no);
               IF ( temp_ = 1 )THEN
                  Error_SYS.Record_General('PartCatalog','ERRPOSPART: Part Cannot be a Position Part, Manufactured/Acquired split exist.');
               END IF;
      $ELSE
         NULL;
      $END 
   END IF;

   IF (oldrec_.unit_code != newrec_.unit_code) THEN
      Check_Update_Unit_Code___(newrec_,oldrec_);
   END IF;

   IF (newrec_.freight_factor IS NULL) THEN
      newrec_.freight_factor := 1;
   ELSE
      IF (newrec_.freight_factor <= 0) THEN
          Error_SYS.Record_General(lu_name_,'INVALFRFACTOR: Freight conversion factor has to be greater than 0.');
      END IF;
   END IF;

   IF (oldrec_.component_lot_rule != newrec_.component_lot_rule) THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN 
         -- Not allowed change to ONE_LOT_ALLOWED for component_lot_rule if there
         --    are any shop orders for the part having multiple component lots
         IF (newrec_.component_lot_rule = 'ONE_LOT_ALLOWED') THEN
            Trace_SYS.Message('Checking for multiple component lots...');
            mclot_exist_ := Shop_Ord_Util_API.Multiple_Component_Lots(newrec_.part_no);     
               IF mclot_exist_ = db_true_ THEN
                  Error_SYS.Record_General('PartCatalog','NOCHANGECLR: Component Lot Rule cannot be set to One Lot Allowed, there are Shop Orders for this part which have multiple component lots either reserved and/or issued.');
               END IF;
         END IF;
      $ELSE 
         NULL;
      $END 
   END IF;
   IF ((newrec_.allow_as_not_consumed       != oldrec_.allow_as_not_consumed     ) OR 
       (newrec_.receipt_issue_serial_track  != oldrec_.receipt_issue_serial_track) OR
       (newrec_.lot_tracking_code           != oldrec_.lot_tracking_code         )) THEN
      IF (newrec_.allow_as_not_consumed != oldrec_.allow_as_not_consumed) THEN
         updated_allow_as_not_consumed_ := TRUE ;
      END IF;
      Check_Allow_As_Not_Consumed___(newrec_, updated_allow_as_not_consumed_);
   END IF;

   IF (newrec_.receipt_issue_serial_track = oldrec_.receipt_issue_serial_track) AND
      (newrec_.receipt_issue_serial_track = 'TRUE')                             AND
      (newrec_.serial_tracking_code      != oldrec_.serial_tracking_code)       AND
      (newrec_.serial_tracking_code       = 'NOT SERIAL TRACKING')              THEN
      Client_SYS.Add_Warning(lu_name_, 'SERIALTRACKDISABLED: It will not be possible to enable Inventory Serial Tracking functionality after it has been disabled if there are quantities in stock or in transit without specified serial numbers.');
   END IF;

   IF ((newrec_.condition_code_usage = 'ALLOW_COND_CODE') AND (Get_Condition_Code_Usage_Db(newrec_.part_no) != 'ALLOW_COND_CODE')) THEN
      Client_SYS.Add_Warning('PartCatalog', 'UPDATEALLOWCONDCODE: It will not be possible to disable the condition code functionality after it has been enabled, if any inventory part records exist. '||
                                                                  'Existing inventory part records will need to be updated with condition codes.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ part_catalog_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Exist(lu_name_, 'INUSE: Part number :P1 is already in use.', rec_.part_no);
   super(rec_);
   --Add post-processing code here
END Raise_Record_Exist___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Exist_Inv_Purch_Sals_Prts__
--   This methos checks if the inventory, purchase and sales parts exist
--   for a particular catalog part, in at least one site allowed for the user.
@UncheckedAccess
PROCEDURE Exist_Inv_Purch_Sals_Prts__ (
   inv_part_exists_   OUT VARCHAR2,
   purch_part_exists_ OUT VARCHAR2,
   sales_part_exists_ OUT VARCHAR2,
   part_no_           IN  VARCHAR2 )
IS
BEGIN
   $IF (Component_Invent_SYS.INSTALLED) $THEN 
      inv_part_exists_ := Inventory_Part_API.Check_Exist_On_User_Site(part_no_);
   $ELSE 
      NULL;
   $END 

   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      purch_part_exists_ := Purchase_Part_API.Check_Exist_On_User_Site(part_no_);
   $ELSE 
      NULL;
   $END 

   $IF (Component_Order_SYS.INSTALLED)$THEN 
      sales_part_exists_ := Sales_Part_API.Check_Exist_On_User_Site(part_no_);
   $ELSE 
      NULL;
   $END 
END Exist_Inv_Purch_Sals_Prts__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Part_Exists
--   Check the existence of a part with return statement of type Boolean.
@UncheckedAccess
FUNCTION Check_Part_Exists (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   --Check the existance of a part.
   IF (Check_Exist___(part_no_)) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Part_Exists;

-- Create_Part
--   Creates a new part in the PartCatalog. Description, UOM and StdNameId is mandatory.
PROCEDURE Create_Part (
   part_no_                       IN VARCHAR2,
   description_                   IN VARCHAR2,
   unit_code_                     IN VARCHAR2,
   std_name_id_                   IN NUMBER,
   info_text_                     IN VARCHAR2,
   part_main_group_               IN VARCHAR2 DEFAULT NULL,
   eng_serial_tracking_code_      IN VARCHAR2 DEFAULT NULL,
   serial_tracking_code_          IN VARCHAR2 DEFAULT NULL,
   configurable_db_               IN VARCHAR2 DEFAULT 'NOT CONFIGURED',
   condition_code_usage_db_       IN VARCHAR2 DEFAULT 'NOT_ALLOW_COND_CODE',
   lot_tracking_code_db_          IN VARCHAR2 DEFAULT 'NOT LOT TRACKING',
   position_part_db_              IN VARCHAR2 DEFAULT 'NOT POSITION PART',
   catch_unit_enabled_db_         IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   multilevel_tracking_db_        IN VARCHAR2 DEFAULT 'TRACKING_OFF',
   gtin_no_                       IN VARCHAR2 DEFAULT NULL,
   gtin_series_db_                IN VARCHAR2 DEFAULT NULL,
   weight_net_                    IN NUMBER   DEFAULT NULL,
   uom_for_weight_net_            IN VARCHAR2 DEFAULT NULL,
   volume_net_                    IN NUMBER   DEFAULT NULL,
   uom_for_volume_net_            IN VARCHAR2 DEFAULT NULL,
   freight_factor_                IN NUMBER   DEFAULT NULL,
   allow_as_not_consumed_db_      IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   auto_created_gtin_             IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   receipt_issue_serial_track_db_ IN VARCHAR2 DEFAULT NULL,
   input_unit_meas_group_id_      IN VARCHAR2 DEFAULT NULL,
   lot_quantity_rule_             IN VARCHAR2 DEFAULT NULL,
   sub_lot_rule_                  IN VARCHAR2 DEFAULT NULL,
   serial_rule_                   IN VARCHAR2 DEFAULT NULL,
   technical_drawing_no_          IN VARCHAR2 DEFAULT NULL )
IS
   indrec_     Indicator_Rec;
   newrec_     part_catalog_tab%ROWTYPE;
   objid_      part_catalog.objid%TYPE;
   objversion_ part_catalog.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   --Create's a new part in the PartCatalog.
   newrec_.part_no     := part_no_;
   newrec_.description := description_;
   newrec_.unit_code   := unit_code_;
   IF (lot_quantity_rule_ IS NOT NULL) THEN
      newrec_.lot_quantity_rule := Lot_Quantity_Rule_API.Encode(lot_quantity_rule_);
   END IF;
   IF (sub_lot_rule_ IS NOT NULL) THEN
      newrec_.sub_lot_rule      := Sub_Lot_Rule_API.Encode(sub_lot_rule_);
   END IF;
   IF (serial_rule_ IS NOT NULL) THEN
      newrec_.serial_rule := Part_Serial_Rule_API.Encode(serial_rule_);
   END IF;
   newrec_.std_name_id     := std_name_id_;
   newrec_.part_main_group := part_main_group_;
   IF (eng_serial_tracking_code_ IS NOT NULL) THEN
      newrec_.eng_serial_tracking_code := Part_Serial_Tracking_API.Encode(eng_serial_tracking_code_);
   END IF;
   IF (serial_tracking_code_ IS NOT NULL) THEN
      newrec_.serial_tracking_code := Part_Serial_Tracking_API.Encode(serial_tracking_code_);
   END IF;
   newrec_.info_text    := info_text_;
-- CTO Add configurable flag
   newrec_.configurable := configurable_db_;
   IF(newrec_.configurable IS NULL) THEN
      newrec_.configurable := Part_Configuration_API.DB_NOT_CONFIGURED;
   END IF;
-- CTO End
   newrec_.condition_code_usage := condition_code_usage_db_;
   IF (newrec_.condition_code_usage IS NULL) THEN
      newrec_.condition_code_usage := Condition_Code_Usage_API.DB_NOT_ALLOW_CONDITION_CODE;
   END IF;
   newrec_.lot_tracking_code := lot_tracking_code_db_;
   IF (newrec_.lot_tracking_code IS NULL) THEN
      newrec_.lot_tracking_code := Part_Lot_Tracking_API.DB_LOT_TRACKING;
   END IF;
   newrec_.position_part := position_part_db_;
   IF (newrec_.position_part IS NULL) THEN
      newrec_.position_part := Position_Part_API.DB_NOT_A_POSITION_PART;
   END IF;
   newrec_.catch_unit_enabled := catch_unit_enabled_db_;
   IF (newrec_.catch_unit_enabled IS NULL) THEN
      newrec_.catch_unit_enabled := Fnd_Boolean_API.DB_FALSE;
   END IF;
   newrec_.receipt_issue_serial_track := receipt_issue_serial_track_db_;
   IF (newrec_.receipt_issue_serial_track IS NULL) THEN
      IF (newrec_.serial_tracking_code = Part_Serial_Tracking_API.DB_SERIAL_TRACKING) THEN
         newrec_.receipt_issue_serial_track := Fnd_Boolean_API.DB_TRUE;
      ELSE
         newrec_.receipt_issue_serial_track := Fnd_Boolean_API.DB_FALSE;
      END IF;
   END IF;
   newrec_.multilevel_tracking := multilevel_tracking_db_;
   IF (newrec_.multilevel_tracking IS NULL) THEN
      IF ((newrec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE) OR
          (newrec_.lot_tracking_code IN (Part_Lot_Tracking_API.DB_LOT_TRACKING, Part_Lot_Tracking_API.DB_ORDER_BASED))) THEN
          newrec_.multilevel_tracking := Multilevel_Tracking_API.DB_TRACKING_ON;
      ELSE
         newrec_.multilevel_tracking := Multilevel_Tracking_API.DB_TRACKING_OFF;
      END IF;
   END IF;
   newrec_.allow_as_not_consumed := allow_as_not_consumed_db_;
   IF (newrec_.allow_as_not_consumed IS NULL) THEN
      newrec_.allow_as_not_consumed := Fnd_Boolean_API.DB_FALSE;
   END IF;
   newrec_.weight_net               := weight_net_;
   newrec_.uom_for_weight_net       := uom_for_weight_net_;
   newrec_.volume_net               := volume_net_;
   newrec_.uom_for_volume_net       := uom_for_volume_net_;
   newrec_.freight_factor           := freight_factor_;
   newrec_.input_unit_meas_group_id := input_unit_meas_group_id_;
   newrec_.technical_drawing_no     := technical_drawing_no_;
   
   Client_SYS.Clear_Attr(attr_);
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_, FALSE);
   Insert___(objid_, objversion_, newrec_, attr_);
   
   IF (gtin_no_ IS NOT NULL OR gtin_series_db_ IS NOT NULL) THEN
      IF (gtin_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'GTINNOREQUIRED: GTIN is required when GTIN Series is entered.');
      END IF;
      IF (gtin_series_db_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'GTINSERIESREQUIRED: GTIN Series is required for the GTIN.');
      END IF;
      Part_Gtin_API.New(part_no_                    => part_no_,
                        gtin_no_                    => gtin_no_,
                        gtin_series_db_             => gtin_series_db_,
                        used_for_identification_db_ => db_true_,
                        auto_created_gtin_db_       => auto_created_gtin_,
                        default_gtin_db_            => db_true_);
   END IF;
END Create_Part;


-- Check_Part_Exists2
--   Check the existence of a part with return statement of type number.
--   Used where method is called from the client.
--   Added, on request from Distribution, to help out with directly
--   call from the client (return value)
@UncheckedAccess
FUNCTION Check_Part_Exists2 (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
  --Check the existance of a part.
   IF (Check_Exist___(part_no_)) THEN
    --Return TRUE
    RETURN 1;
   ELSE
   --Return FALSE
    RETURN 0;
   END IF;
END Check_Part_Exists2;


-- Get_Eng_Serial_Tracking_Db
--   Returns the database value for eng serial tracking code
@UncheckedAccess
FUNCTION Get_Eng_Serial_Tracking_Db (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_catalog_tab.eng_serial_tracking_code%TYPE;
   CURSOR get_attr IS
      SELECT eng_serial_tracking_code
      FROM part_catalog_tab
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Eng_Serial_Tracking_Db;

-- Copy
--   Method creates new instance and copies all editable attributes from old part
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   to_part_desc_             IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     part_catalog_tab%ROWTYPE;
   objid_      part_catalog.objid%TYPE;
   objversion_ part_catalog.objversion%TYPE;
   attr_       VARCHAR2(2000);
   old_rowkey_     part_catalog_tab.rowkey%TYPE;
   exit_procedure_ EXCEPTION;
BEGIN

   IF NOT (Check_Exist___(from_part_no_)) THEN
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, NULL, from_part_no_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (Check_Exist___(to_part_no_)) THEN
      IF (error_when_existing_copy_ = db_true_) THEN
         Error_SYS.Record_Exist(lu_name_, NULL, to_part_no_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   newrec_     := Get_Object_By_Keys___(from_part_no_);
   old_rowkey_ := newrec_.rowkey;

   newrec_.part_no     := to_part_no_;
   newrec_.description := NVL(to_part_desc_, newrec_.description);
   -- rowkey, objversion will regenerate during the insertion hence no need to reset them.
   
   Client_SYS.Clear_Attr(attr_);
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_, FALSE);
   Insert___(objid_, objversion_, newrec_, attr_);

   -- Copy the custom fields
   Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, old_rowkey_, newrec_.rowkey);
   
   $IF Component_Invent_SYS.INSTALLED $THEN
   Part_Catalog_Capability_API.Copy(from_part_no_, to_part_no_);
   $END
   
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy;


-- Copy_Connected_Objects
--   This method will copy documents, approval routing and technical
--   objects of the connected objects. Errors will be rasied according
--   to the values of error flags.
PROCEDURE Copy_Connected_Objects (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   objid_               Part_Catalog.objid%TYPE;
   objversion_          Part_Catalog.objversion%TYPE;
   source_key_ref_      VARCHAR2(2000);
   destination_key_ref_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             to_part_no_);

   source_key_ref_      := Client_SYS.Get_Key_Reference(lu_name_, 'PART_NO', from_part_no_);
   destination_key_ref_ := Client_SYS.Get_Key_Reference(lu_name_, 'PART_NO', to_part_no_);

   $IF (Component_Docman_SYS.INSTALLED)$THEN 
      Doc_Reference_Object_API.Copy(lu_name_,
                                    source_key_ref_,
                                    lu_name_,
                                    destination_key_ref_,
                                    '',
                                    error_when_no_source_,
                                    error_when_existing_copy_);
   $END 

   Technical_Object_Reference_API.Copy(lu_name_,
                                       source_key_ref_,
                                       destination_key_ref_,
                                       error_when_no_source_,
                                       error_when_existing_copy_);
END Copy_Connected_Objects;


-- Get_Description
--   Return the language specific part description
@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Description (
   part_no_       IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   local_language_code_ Part_Catalog_Language_Tab.language_code%TYPE;

   temp_ part_catalog_tab.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM part_catalog_tab
      WHERE part_no = part_no_;
BEGIN
   -- Get the session language if the language code is not specified
   IF (language_code_ IS NULL) THEN
      local_language_code_ := Fnd_Session_API.Get_Language();
   ELSE
      local_language_code_ := language_code_;
   END IF;

   -- Fetch the language specific description
   IF (local_language_code_ IS NOT NULL) THEN
      temp_ := Part_Catalog_Language_API.Get_Description(part_no_, local_language_code_);
   ELSE
      temp_ := NULL;
   END IF;

   -- IF the language specific description is not defined
   -- Get the description from the Part_Catalog_Tab
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;

   RETURN temp_;
END Get_Description;


@UncheckedAccess
FUNCTION Get_Stop_Arr_Issued_Serial_Db (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_catalog_tab.stop_arrival_issued_serial%TYPE;
   CURSOR get_attr IS
      SELECT stop_arrival_issued_serial
      FROM part_catalog_tab
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Stop_Arr_Issued_Serial_Db;


@UncheckedAccess
FUNCTION Lot_Or_Serial_Tracked (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_                   part_catalog_tab%ROWTYPE;
   lot_or_serial_tracked_ BOOLEAN := FALSE;
BEGIN
   rec_ := Get_Object_By_Keys___(part_no_);

   IF ((rec_.receipt_issue_serial_track = db_true_) OR
       (rec_.lot_tracking_code != 'NOT LOT TRACKING')) THEN
      lot_or_serial_tracked_ := TRUE;
   END IF;

   RETURN (lot_or_serial_tracked_);
END Lot_Or_Serial_Tracked;


@UncheckedAccess
FUNCTION Is_Lot_Or_Serial_Tracked (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lot_or_serial_tracked_ VARCHAR2(5):= db_false_;
BEGIN
   IF Lot_Or_Serial_Tracked(part_no_) THEN
      lot_or_serial_tracked_ := db_true_;
   END IF;
   RETURN lot_or_serial_tracked_;
END Is_Lot_Or_Serial_Tracked;


PROCEDURE Check_Delete_Input_Unit_Meas (
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2 )
IS
   CURSOR get_parts IS
      SELECT part_no
      FROM part_catalog_tab
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_;
BEGIN
   FOR rec_ IN get_parts LOOP
      IF (Part_Gtin_Unit_Meas_API.Check_Exist_Unit_Code(rec_.part_no, unit_code_)) THEN
         Error_SYS.Record_General(lu_name_,'PARTUNITMEAS: Input Unit Code :P1 in Input Unit Group :P2 is referenced by Part No :P3 and cannot be removed.', unit_code_, input_unit_meas_group_id_, rec_.part_no);
      END IF;
   END LOOP;
END Check_Delete_Input_Unit_Meas;


@UncheckedAccess
FUNCTION Get_Rcpt_Issue_Serial_Track_Db (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_catalog_tab.receipt_issue_serial_track%TYPE;
   CURSOR get_attr IS
      SELECT receipt_issue_serial_track
      FROM part_catalog_tab
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Rcpt_Issue_Serial_Track_Db;


@UncheckedAccess
FUNCTION Serial_Tracked_In_Inventory (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_                           part_catalog_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(part_no_);
   RETURN (rec_.serial_tracking_code = db_serial_tracking_);
END Serial_Tracked_In_Inventory;

@UncheckedAccess
FUNCTION Is_Serial_Tracked_In_Inventory (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Serial_Tracked_In_Inventory(part_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Serial_Tracked_In_Inventory;


@UncheckedAccess
FUNCTION Rcpt_Issue_Serial_Tracked (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Boolean_API.Evaluate_Db(Get_Rcpt_Issue_Serial_Track_Db(part_no_));
END Rcpt_Issue_Serial_Tracked;


@UncheckedAccess
FUNCTION Serial_Tracked_Only_Rece_Issue (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_                           part_catalog_tab%ROWTYPE;
   serial_tracked_only_rec_issue_ BOOLEAN := FALSE;
BEGIN
   rec_ := Get_Object_By_Keys___(part_no_);

   IF ((rec_.serial_tracking_code       = db_not_serial_tracking_) AND
       (rec_.receipt_issue_serial_track = db_true_)) THEN
      serial_tracked_only_rec_issue_ := TRUE;
   END IF;

   RETURN (serial_tracked_only_rec_issue_);
END Serial_Tracked_Only_Rece_Issue;


@UncheckedAccess
FUNCTION Serial_Trak_Only_Rece_Issue_Db (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Serial_Tracked_Only_Rece_Issue(part_no_) THEN
      RETURN db_true_;
   ELSE
      RETURN db_false_;
   END IF;
END Serial_Trak_Only_Rece_Issue_Db;

PROCEDURE Modify (
   part_no_                       IN VARCHAR2,
   unit_code_                     IN VARCHAR2,
   description_                   IN VARCHAR2,
   std_name_id_                   IN NUMBER,
   part_main_group_               IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   eng_serial_tracking_code_db_   IN VARCHAR2,
   stop_arrival_issued_serial_db_ IN VARCHAR2,
   serial_rule_db_                IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   configurable_db_               IN VARCHAR2,
   multi_level_tracking_db_       IN VARCHAR2,
   technical_drawing_no_          IN VARCHAR2 )
IS
   newrec_     part_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_);

   IF (unit_code_ IS NOT NULL) THEN
      newrec_.unit_code := unit_code_;
   END IF;

   IF (description_ IS NOT NULL) THEN
      newrec_.description := description_;
   END IF;

   IF (std_name_id_ IS NOT NULL) THEN
      newrec_.std_name_id := std_name_id_;
   END IF;

   -- part_main_group_ can have null values.
   newrec_.part_main_group := part_main_group_;

   IF (receipt_issue_serial_track_db_ IS NOT NULL) THEN
      newrec_.receipt_issue_serial_track := receipt_issue_serial_track_db_;
   END IF;

   IF (serial_tracking_code_db_ IS NOT NULL) THEN
      newrec_.serial_tracking_code := serial_tracking_code_db_;
   END IF;

   IF (eng_serial_tracking_code_db_ IS NOT NULL) THEN
      newrec_.eng_serial_tracking_code := eng_serial_tracking_code_db_;
   END IF;

   IF (stop_arrival_issued_serial_db_ IS NOT NULL) THEN
      newrec_.stop_arrival_issued_serial := stop_arrival_issued_serial_db_;
   END IF;

   IF (serial_rule_db_ IS NOT NULL) THEN
      newrec_.serial_rule := serial_rule_db_;
   END IF;

   IF (lot_tracking_code_db_ IS NOT NULL) THEN
      newrec_.lot_tracking_code := lot_tracking_code_db_;
   END IF;
   IF (configurable_db_ IS NOT NULL) THEN
      newrec_.configurable := configurable_db_;
   END IF;
   IF (multi_level_tracking_db_ IS NOT NULL) THEN
      newrec_.multilevel_tracking := multi_level_tracking_db_;
   END IF;
   IF (technical_drawing_no_ IS NOT NULL) THEN
      newrec_.technical_drawing_no := technical_drawing_no_;
   END IF;
   Modify___(newrec_);
END Modify;



