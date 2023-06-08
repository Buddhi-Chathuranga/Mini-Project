-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentSerial
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970528  TOWI  Created
--  970528  TOWI  Changed Is_Address to return string value instead of boolean.
--  970827  CAJO  Recreated with the Design tool, F1 1.2.2D.
--                Moved Exist-control of serial_no to Validate_Comb. Changed
--                mch_name in view to description of part_no.
--  970902  CAJO  Added function Get_Part_No.
--  970904  CAJO  Changed where statement to only select serials 'InFacility'.
--                Removed mch_name from Insert and Update.
--  970908  CAJO  Added procedure Move__ from EquipmentObject.
--  970909  CAJO  Moved procedure Copy__ to EquipmentAllObject.
--  970909  ERJA  Added procedure Check_Serial_Reference___ and Remove_serial_Reference___.
--                Changed procedure Concatenate_Object___ to Private.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_tab.
--  970923  TOWI  Added procedure Move_From_Invent_To_Facility.
--  970924  ERJA  Changed where clause in view
--  970926  ERJA  Removed exist control on serial_no in unpack_check_insert.
--  970930  ERJA  Changed Move__ to concern both serial and functional objects.
--  970930  ERJA  Added a call to Check_Individual_Aware__ in Validate_Comb__.
--  971009  ERJA  Added Procedure Move_Contained_To_Fac__.
--  971021  ERJA  Removed Procedure Move_Contained_To_Fac__.
--  971022  TOWI  Updates maintenance cost only when the serial object is in the facilty. Method Update_Amount.
--  971023  ERJA  Made corrections in Move_From_Invent_To_Facility .
--  971023  CAJO  Added parameters to method When_New_Mch for insert in Part_Serial_Catalog.
--  971024  CAJO  Moved columns in view to be fetched from part_serial_catalog instead.
--  971028  ERJA  Adapted when_new_mch__ to part_serial_catalog.
--  971028  STSU  Added procedures Create_Construction_Object and Create_Serial_Object.
--  971030  STSU  Changed When_New_Mch__, create only new Part_Serial_Catalog if not exist.
--  971030  CAJO  Removed REF-flag on serial_no.
--  971111  ERJA  Adapted calls to part_serial_catalog to use of contract.
--  971118  MNYS  Added key contract and attribute sup_contract.
--  971126  ERJA  Added argument in call to Create_Part_Serial_History.
--  971204  ERJA  Added PROCEDURE Move_To_Repair.
--  971210  CAJO  Added default contract to SUP_CONTRACT in Prepare_Insert.
--  971210  CAJO  Removed and corrected validations and error messages in Validate_Comb__.
--  971212  ERJA  Added argument in when_new_mch.
--  971215  ERJA  Added arguments in call to part_serial_catalog_api.update_serial.
--  971217  ERJA  Removed sup_contract in prepare_insert.
--  980108  ERJA  Made changes in unpack_check_insert concerning company.
--  980112  CAJO  Changed part_rev to serial_revision in view.
--  980120  ADBR  Added New_Object__.
--  980129  ERJA  Made changes according to new names in partserialcatalog.
--  980204  CAJO  Corrected order of contract and mch_code in call to
--                Equipment_Object_Util_API.Check_Type_Status.
--  980206  ERJA  Changed unpack_check_insert/update to remove sup_contract IF sup_mch_code is null
--  980206  ERJA  Changed arguments in New_Object__ and calls to add_to_attr
--  980209  ERJA  Removed calls to Part_Serial_Catalog_API.Modify_Current_Position
--  980211  TOWI  Added functionality for cascade delete against base class.
--                Adapted to new interface to PartSerialCatalog.
--  980218  CAJO  Changed sup_contract and sup_mch_code to be not updateable.
--  980220  CLCA  Changed error message says '....individual aware...'
--                to 'Serials are not allowed on this object level'
--  980221  ERJA  Bug corrections in When_New_Mch__ concerning current_position and storage of two
--                SerialObjects with same part_no, serial_no
--  980223  ERJA  Changed parameter order in Create_Attr_Template.
--  980224  ERJA  removed reference to equipment_object_move in When_New_Mch__
--  980315  TOWI  Added deletion of document connection if the object is removed.
--  980317  ERJA  Changed prcedure Move_From_Invent_To_Facility to take part_no and serial_no
--  980319  ADBR  Changed Concatenate_Object__ to use system parameter as separator.
--  980324  ERJA  Changed order of new and move_in_facility in Create_Construction_Object.
--  980326  CLCA  Changed from Get_App_Owner to Get_Fnd_User.
--  980326  ERJA  Changes in in insert___
--  980401  MNYS  Included sup_contract as a member of LOV for view EQUIPMENT_SERIAL.
--  980403  ERJA  Reconstructed Move_From_Invent_To_Facility
--  980405  JOBI  Modified transaction description in Move__ and
--                When_New_Mch__.
--  980406  ERJA  Added Procedure Check_Exist and removed procedure Move_From_Invent_To_Facility
--  980407  MNYS  Support Id: 308. Added call Equipment_Object_API.Check_Delete__
--                in procedure Check_Delete___.
--  980409  JOBI  Added check to see if contract belongs to different companies
--                in Move__. Corrected call to
--                Equipment_Object_Util_API.Check_Type_Status in Update___
--  980417  MNYS  Support Id: 3883. Added call to Part_Serial_Catalog_API.Move_In_Facility
--                in procedure Update___.
--  980417  CLCA  Corrected Has_Warranty.
--  980419  ERJA  Added state InRepairWorkshop in Where-statement in VIEW
--  980221  MNYS  Changed transaction_description_ in Update___.
--  980423  MNYS  Support Id: 3959. Added value for NOTE to attributestring in
--                procedure Move__.
--  980423  MNYS  Support Id: 3962. Added parameters sup_mch_code and sup_contract
--                in call to Part_Serial_Catalog_API.Move_In_Facility
--                Removed call to Part_Serial_Catalog_API.Move_In_Facility in Update___.
--  980424  MNYS  Support Id: 1590. Added sup_contract to attr_ in procedures Unpack_Check_Insert___
--                and Unpack_Check_Update___ after check if sup_mch_code IS NULL.
--  980426  JOBI  Modified transaction description in Move__.
--  980428  CLCA  Added Employee_API.Exist in PROCEDURE Move__.
--  980428  MNYS  Support Id: 4389. Added call to Part_Serial_Catalog_API.Move_In_Facility in Update___.
--                Added conditions for when Part_Serial_Catalog_API.Move_In_Facility in procedure Move__
--                is to be called.
--  980506  CLCA  Added Function Check_Serial_Exist.
--  980510  CAJO  Added mch_loc, mch_pos, group_id and cost_center from superior object if null in
--                Unpack_Check_Insert and Unpack_Check_Update.
--  980512  ERJA  Changed calls to Equipment_All_Object to Equipment_Object in Validate_Comb___
--  980513  ADBR  Support Id: 4543. Changed mch_code_key_value to Client_SYS call.
--  980514  TOWI  If state in part serial catalog is InRepairWorkshop call Move_To_Facility in method move__
--  980615  CLCA  Changed prompt from 'Object Group' to 'Group ID' for group_id.
--  980618  ERJA  Correction in call to check_serial_exist
--  980810  ERJA  Added Function Is_InFacility.
--  980903  ERJA  Bug Id 5913: Added DESIGN_OBJECT to attr_ in Create_Construction_Object to allow
--                Objects 'Under Design' to move in facility
--  981103  MIBO  Added status for the equipment object.
--  981124  MIBO  Changed REF=PartyTypeSupplier to SupplierInfo and Party_Type_Supplier_API
--                to Supplier_Info_API and REF=PartyTypeManufacturer to ManufacturerInfo.
--                and Party_Type_Manufacturer_API to Manufacturer_Info_API.
--  981125  ERJA  SKY.1000 Changed Employee_API.Exist to Company_Emp_API.Exists
--  981201  CLCA  Added work_order_cost_type_ in Update_Amount.
--  981203  ERJA  SKY.1000 Correction in Move_ in Company_Emp_API.Exists
--  990112  MIBO  SKY.0208 AND SKY.0209 Changed SYSDATE to Site_API.Get_Site_Date(newrec_.contract)
--                and removed all calls to Get_Instance___ in Get-statements.
--  990113  RAFA  Create object-serial from customer order(SKY.616). Added method Create_Serial_Object_C_O.
--  990118  MIBO  SKY.0209 Changed Site_API.Get_Site_Date(contract) to
--                Maintenance_Site_Utility_API.Get_Site_Date(contract).
--  990124  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990125  ERJA  SKY.0704 Prepared for new project delivery status.
--  990210  TOWI  Corrected type declarations in method Create_Serial_Object_C_O
--  990211  MIBO  Modifications according to SKY.0203. Checking the existance of object_no and
--                cost_center was changed. The new existance check is performed by invoking
--                Maintenance_Accounting_API.Accounting_Codepart_Exist.
--  990311  ERJA  New initial state for objects from Create_Construction_Object
--  990311  RAFA  Call 10835.Modified validate_comb.It is not possible to add objects belonging to a scrapped object.
--  990408  MIBO  Template changes due to performance improvement.
--  990517  ERJA  Added Create_Maintenance_Aware and changed flow from allser
--                to use obj.apy to make serials maintenance aware.
--  990519  ERJA  Bug id 9799: Added company in prepare_insert
--  990519  MIBO  Call Id 17194 Changed TABLE to VIEW in function get_mch_name.
--  990520  MAET  FUNCTION Check_Exist___: TABLE was changed to VIEW.
--  990521  ERJA  Call 17255: Added setting of rowversion in  Finite_State_Set___
--  990526  MAET  Call 18308. Unpack_Check_Insert___: Company is handled by getting the value of value_.
--  990531  CAPT  Call Id: 18344. Added Function Active_WO_Exists. Added infomessage in Function Scrap__.
--  990615  CLCA  Added Infacility_Or_Workshop.
--  990617  ERJA  Removed Active_WO_Exists and changed calls to obj_has_wo.
--  990617  CLCA  Added cost_center, mch_loc, and mch_pos in New_Object__
--  990917 PJONSE Rock.1093:B PROCEDURE Update_Amount. Added cre_date_ parameter in PROCEDURE Update_Amount
--                and in call for Equipment_Object_API.Update_Amount.
--  990927  MIBO  Added security checks 2000B.
--  991006  OSRY  Rock1424:B Changed mch_type from 5 to 20 characters.
--  991008 PJONSE Rock1429:B Changed Client_state_list: UnderConstruction to PlannedForOperation,
--                Active to InOperation, Inactive to OutOfOperation.
--  991018  ERJA  Rock1059:B enabled status change from state scrapped to Active.
--  991022  MABQ  Call 24197 Added objversion in Proc Insert.
--  991026  JIJO  Call 23347, warranty checked in serial object when NVL on warr_exp in view
--  991108  MABQ  Call 25595 Changed in Proc. Update so that warr_exp dont sets to NULL
--  991116  ERJA  Call 28072: Manufacturer_no, vendor_no and part_rev are beeing saved in Equipment_Object_tab.
--  991124  JIJO  Call 27925: Check sign exists on moving serial object.
--  000201  JIJO  Calling new function: OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty
--  000213  MAET  After Sale: Create_Serial_Object_C_O was modified.
--  000316  JIJO  Creating supplier warranty row in Create_Serial_Object_C_O
--  000407  MAET  Call Id 37400: Create_Serial_Object_C_O was corrected.
--  000411  HAST  Call 37955: Added Integration code for Plant design.
--  000417  HAST  Call 37955: Spelling fix on Public method Inactivate
--  000425  JIJO  Replacing supplier warranty with customer in Create_Serial_Object_C_O
--  000509 RECASE Added Added key_ref and lu_name (referring to LU EquipmentObject) to the view EQUIPMENT_SERIAL,
--                as they are keys to Object_Connection.
--  000523 RECASE Changed procedure When_New_Mch__ not to call Create_Attr_Template.
--  000607 BGADSE Call 42940: Added CRITICALITY to SerialObject view etc
--  000607  ADBR  Call 39357: Changed Move__ to use contract_ with mch_code_ instead of to_contract_.
--                Commented update of contract.
--  000627 PJONSE Call Id: 32767. PROCEDURE When_New_Mch__ - added transaction_description_ so that note wont be overwritten.
--                                Made 'note' NULL in Insert___ and Update___ and added 'IF (newrec_.note IS NOT NULL) THEN in Update___'.
--  001130 JOHGSE Call 52702 Removed a check for Valid_until
--  001208 JIJOSE Create_Construction_Object changed. No Move_To_Falicty if already in that state
--  001211 RECASE Call 56801. Added transaction of customer and supplier warranties into procedure Insert.
--                (The transaction was earlier incorrectly placed in procedure Create_Object in file EquipSerUtility.apy)
--  001217 JOHGSE Function call Part_Serial_Catalog_API.Get_Cust_Warranty_Id and Cust_Warranty_API.Copy  (same for Sup_warranty)
--                changed to dynamic calls,due to backwards compability
--  001219 RECASE Call ID: 56732. Added functionality to Unpack_Check_Insert__ and Unpack_Check_Update__ of mch_code:
--                Set the characteristics of the object to the characteristics of the object type whenever the object type is changed and has characteristics.
--  010108 NEKO   Call ID 50591 Added some changes to unpack_check_insert__
--  010110 JOHGSE Call ID 59840 Wrong information from HAST. removed the check added in previous call.
--  010117 RECASE Call 56786. Deleted automatic insertion of customer warranty (warranty_source = Manual) in procedure Create_Serial_Object_C_O.
--  010119 ANERSE Call Id 60377. Added Function Is_Scrapped.
--  010205 MIBOSE Bug Id: 20433 In Unpack_Check_Insert___ and Unpack_Check_Update___ added a check on serial_status
--                for item purch_price, purch_date, production_date, amount and object_no.
--  010402 JOHGSE Bug Id: 21034  Moved ELSE in the insert__.  If new object then copy warranty from part_serial. Not as before when the copy warranty was after
--                the ELSE statement.
--  010425 UDSULK Bug Id 21448 Changed variable_value so that it is same as bind_variable in procedure Insert__ and Create_Serial_Object_C_O.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Concatenate_Object__.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Update_Amount.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Has_Document.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Get_Objid.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION  Do_Exist.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Activate.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Revise.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Scrap.
--  010426 CHATLK Added the General_SYS.Init_Method to PROCEDURE Inactivate.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION Check_Exist___.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION Check_Serial_Exist.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION Is_Infacility.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION Is_Scrapped.
--  010426 CHATLK Added the General_SYS.Init_Method to FUNCTION Infacility_Or_Workshop.
--  010426 CHATLK Changed the method name in General_SYS.Init_Method of Create_Serial_Object_C_O.
--  010508 JOHGSE Bug ID: 21036 Added a parameter CO_WO that tells us if the object i created from a CO or a WO.
--  010607 JOHGSE Bug Id: 22372, In Create_Serial_Object_C_O, change current position so it uses Sup_Mch_Code instead och Mch_Code
--  010924 JOHGSE Bug Id 23118 Added so when creating object with supp.warranty it gets the supplier of the part.
--  010928 MIBOSE Some changed in client_state_list_.
--  011011 MIBOSE Insert___ some changed to call to ....Get_Supplier_No.
--  011016 UDSULK Bug Id 25301  Modified so that it will update the Technical Data tab when changing Object Type field in general tab.
--                Also set the Object Type not update after changing the values in demand\technical class\attributes.
--  020211 JOHGSE Bug Id 27019 Moved If statement where co_wo dummy is set to wo
--  020306 MIBO   Bug Id 28245 PROCEDURE Create_Serial_Object_C_O changed added current_position_ to transaction_description_.
-- ************************************* AD 2002-3 BASELINE ********************************************
--  020523  kamtlk  Modified serial_no length 20 to 50 in view EQUIPMENT_SERIAL
--                  Modified mch_serial_no length 20 to 50 in procedure Insert___,
--  020531  PEKR    Changed current_position to latest_transaction
--  020604  CHAMLK  Modified the length of MCH_CODE from 40 to 100.
--  020607  ToFjNo  Modified reference for Manufacturer to ManufacturerPart.
--  020617  CHCRLK  Added methods for manipulation of Operational Status.
--  020618  Jejalk  Added field (operational condition) to the Equipment_Serial view.
--  020619  CHCRLK  Modified to use current position 'Contained'.
--  020620  CHCRLK  Modified method Is_Scrapped.
--  020628  Jejalk  Added the General_SYS.Init_Method to Set_Operational,Set_Non_Operational,Set_Structture_Operational
--                  and Set_Structure_Non_Operational Procedures.
--  020628  Jejalk  Added the General_SYS.Init_Method to Activate_Set_Operational and Activate_Set_Non_Operational functions.
--  020701  CHCRLK  Added call to General_SYS.Init_Method and validated input parameters
--                  in procedures that set the value of Operational_Status.
--  020702  CHCRLK  Modified conditions checked in procedures that change the value of Operational_Status and Operational_Condition.
--  020729  CHCRLK  Removed state machinery.
--  020805  CHCRLK  Added NULL parameters to call to Part_Serial_Catalog_API.New_In_Facility.
--  020808  BhRalk  Modified the Procedure Unpack_Check_Insert___ and Unpack_Check_Update___.
--                  Added manufactured_date to view EQUIPMENT_SERIAL.
--  020809  CHCRLK  Added parameter to function When_New_Mch__. Modified the procedure Insert__.
--  020809  BhRalk  Added parameters Purch_cost_, manufactured_date_,production_date_,
--                  and Purchase_date_ to Procedure When_New_Mch__.
--  020816  CHCRLK  Modified procedure Update___. Called Part_Serial_Catalog_API.Move_To_Contained
--                  if the superior object is a functional.
--  020821  CHCRLK  Added check for state 'Contained' in procedures Infacility_Or_Workshop
--                  and Is_InFacility as required in new design of serial states.
--  020823  CHCRLK  Modified procedures Move__ and Update___.
--  020827  CHCRLK  Call ID: 87963 - Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  020829  CHCRLK  Call ID: 87830 - Changed Activate_Scrapped and Set_Scrapped. Now possible
--                  to scrap serials with status 'InRepairWorkshop'.
--  020910  Chamlk  Call Id 88647 - Modified procedure When_New_Mch__, by making the call to Vim_Serial_API.Serial_No_Exist, dynamic.
--  -------------------------------AD 2002-3 Beta (Merge of IceAge)-------------------------------------
--  020619 ANCE   Bug Id 30939 Added the LOV-flag to attribute mch_name and moved its place in view, rigth behind attribute mch_code.
--  020814 UDSULK Bug Id 32002 Delete reference to the technical data when mach code deletes.
--  020822 OSRYSE Bug Id 31704, Added if statment in Unpack_Check_Update to prevent deleting entered Technical Data.
--  021004 BUNILK Bud ID 89134 Modified When_new_mch_ procedure.
--  021015 CHCRLK Call ID 89582 Added parameter operational_status in calls to Move_To_Facility
--                and Move_To_Contained in procedure Create_Serial_Object_C_O
--  030217 UDSULK Delete the references of documents attached, when Serial object deletes.
--  030715 DIMALK Added new parameters owner_ and ownership_ to the method When_New_Mch__ and to the method calls to
--                Part_Serial_Catalog_API.New_In_Facility and Part_Serial_Catalog_API.New_In_Contained.
--  030826 DIMALK Call ID 101062. Minor modification to the view EQUIPMENT_SERIAL.
--  030916 HAARLK Call ID 98298. Changed an error message in PROCEDURE Move_To_Repair.
--  -------------------------------(Merge of Take OFF)-------------------------------------
--  030916 NEKOLK Merge of Take OFF -Bug Id 38917(Modified if statment in Unpack_Check_Update to prevent deleting entered Technical Data.)
--  030917 HAARLK Call Id 98299 : Modified PROCEDURE Move_To_Repair.
--  030929 LABOLK B104139 : Added LOV view EQUIPMENT_SERIAL_LOV.
--  030929 CHCRLK Call Id 104204: Modified Activate_Scrapped and Set_Scrapped. Now possible to scrap serials with status 'InInventory'.
--  030930 KUHELK B104652 : Added a new validation to Purchase Date field and changed the Production Date Error message in Validate_Comb___ method.
--  031003 DIMALK Call ID 101004 - Modified the method Create_Serial_Object_C_O and added a call to update Part_Serial_Catalog_Tab
--  031010 DIMALK Call ID 98605  - Added a new public method Concatenate_Object.
--  031013 DIMALK Call ID 105116 - Modified the method Create_Serial_Object_C_O.
--  031013 Chamlk Modified method Create_Serial_Object_C_O to pass the contract to method call Insert_Obj_To_Wo_From_Co_line.
--  031024 DIMALK Call ID 109194 - Re-Modified the method Create_Serial_Object_C_O and reversed the change made in CALL ID 105116.
--  031024 KUHELK LCS Bug 39988, Used Maintenance_Document_Ref_API instead of Doc_Reference_Object_API.
--  031029 DIMALK Call ID 109194 - Added validations to check for functional objects before calling part_serial_catalog in Create_Serial_Object_C_O
--  031103 DIMALK Call ID 109948 - Added validations to check for functional objects before calling part_serial_catalog in When_New_Mch__()
--  031103 KUHELK Call ID 109924 - Modified Create_Maintenance_Aware method.
--  031103 NAWILK Call ID 109789 - Added global LU constant "object_party_type_inst_" and modified procedure Create_Serial_Object_C_O to made dynamic call to Object_Party_Type_API
--  031106 ChAmlk Call ID 110314 - Modified procedure Update__ in order to set the current position to Contained when a serial is moved within a serial object and set current position
--                                 to InFacility when the serial is moved within a functional object.
--  031106 ChAmlk Call ID 110351 - Modified procedure Move__ in order to set the current position to Contained when a serial is moved within a serial object and set current position
--                                 to InFacility when the serial is moved within a functional object.
--  031107 ChAmlk Modified procedure Move__ to restructure the current position of objects.
--  031111 LaBolk Call ID 109789 - Corrected the dynamic call in Create_Serial_Object_C_O.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
--  040123 BUNILK Bug 40610  Modified Unpack_Check_Insert___ method.
--  040211 JAPALK Bug ID 42646. Modified Move_ method.
--  040225 SHAFLK Bug ID 42990. Modified Create_Maintenance_Aware method.
--  040316 NEKOLK Bug ID 43365. Modified PROCEDURE When_New_Mch__ and PROCEDURE Move__.
--  040128 YaWilk Moved the content of the Delete___ method to Equipment_Object_API.Delete___. called it through a privete
--                method Equipment_Object_API.Do_Delete__.
--  110204 DIMALK Unicode Support: Changes Done with 'SUBSTRB'.
--  040213 YaWilk Bind variable support. Used the 'EXECUTE IMMEDIATE' native dynamic sql
--                method syntax replacing the existing dynamic call syntax inside
--                the methods Create_Serial_Object_C_O, When_New_Mch__ and Insert___.
--  040324 JAPALK Merge with SP1
--  040423  UDSULK Unicode Modification-substr removal-4.
--  040526 PRIKLK Bug 44904, Added Transaction_SYS.Package_Is_Installed in Create_Maintenance_Aware().
--  040623 DIAMLK Merged Patch handling.
--  040713 NEKOLK Bug 45749, Modified procedure Update__.
--  040730 ThWilk Merged Bug 45749.
--  040825 NEKOLK Bug 46202, Modified procedure Move__ and Update__.
--  040924 DIAMLK Merged the LCS Bug ID:46202.
--  041108 GIRALK Bug 47722, Modified Procedure Move__ to pass NULL values to PART_SERIAL_CATALOG_API.Modify_Serial_Structure
--  041116 Chanlk Merged Bug 47788.
--  041203 Japalk Removed dynamic calls to Object_Party_Type.
--  041203 Japalk Removed dynamic calls to MPCCOM.
--  041210 NIJALK Merged bug 47229.
--  041001 SHAFLK Bug 47063, Modified call to Part_Serial_Catalog_API.New_In_Facility.
--  041214 NIJALK Merged 47063.
--  041229 GIRALK BUG ID 48065,Modifed PROCEDURE Insert___
--  050103 Chanlk Merged Bug 48065.
--  050126 DiAmlk Modified the methods Set_Scrapped and Set_Structure_Scrapped.
--  050117 SHAFLK Bug 48580, Modified view comments for part no.
--  050131 Chanlk Merged Bug 48580.
--  050127 SHAFLK Bug 49285, Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050203 Chanlk Merged Bug 49285.
--  050429 LOPRLK Bug 50823, Method Concatenate_Object__ was altered to return existing object.
--  050518 DiAmlk Merged the corrections done in LCS Bug ID:50823.
--  050525 DiAmlk Obsoleted the method Update_Amount and attribute Amount.(Relate to spec AMEC113 - Cost Follow Up)
--  050615 SHAFLK Bug 51420, Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050718 THWILK Merged LCS Bug 51420 and further modified Unpack_Check_Insert___ and Unpack_Check_Update___ to fix an existing bug.
--  050811 SHAFLK Bug 52698, Modified Unpack_Check_Update___ and Update___.
--  050901 NIJALK Merged bug 52698.
--  050912 DiAmlk Modified the method Get.(Relate to LCS Bug ID:52123)
--  050920 SHAFLK Bug 53377, Added Procedure Handle_Part_Desc_Change.
--  050930 NIJALK Mergrd bug 53377.
--  051102 AMNILK Merged Bug 53872.Manually Modified the Set_Structure_Scrapped and Set_Scrapped.
--  051031 NAMELK Bug 54243, Modified view EQUIPMENT_SERIAL for purch_date field.
--  051107 THWILK Merged Bug 54243.
--  060220 JAPALK Call ID 134599. Modified insert_ method.
--  060303 NIJALK Call ID:135919, Modified New_Object__.
--  060221 NAMELK Bug 56034, Modified method Move__ and Update___
--  060305 JAPALK Merged bug 56034.
--  060313 NIJALK Call 135919: Modified Unpack_Check_Insert___,Unpack_Check_Update___.
--  060327 DiAmlk Bug ID:137942 - Modified the method signature of Validate_Comb___ and modified the method
--                Unpack_Check_Update___.
--  060329 DiAmlk Modified the methods Move__,Unpack_Check_Update___ and Validate_Comb___.
--  060425 SHAFLK Bug 57257, Modified view EQUIPMENT_SERIAL.
--  --------------------Sparx Project Begin-----------------------------------------------------
--  060629 DiAmlk Merged the corrections done in APP7 - SP1.
--  060706 AMDILK MEBR1200: Enlarge Identity - Changed Customer Id length from 10 to 20
--  060719 AMDILK MEPR704: Persian Calender - Modified the method Update___() and add a new constant called 'calendar_date_'
--  060810 ILSOLK Merged Bug Id 59428.
--  070118 SHAFLK Bug 62863, Modified the method Insert___.
--  070208 AMNILK Merged LCS Bug 62863.
--  061114 SHAFLK Bug 61446, Modifed view EQUIPMENT_SERIAL.
--  070301 ILSOLK Merged Bug ID 61446.
--  070328 AmNilk Modified insert___().
--  070528 PRIKLK Bug 65575, Added NOCHECK to view comments of code part fields.
--  070626 AMDILK Merged bug 65575
--  070517 LIAMLK Bug 65397, Modified Procedure Create_Maintenance_Aware.
--  070727 Nipalk Merged Bug 65397.
--  070808 IMGULK Added Assert_SYS Assertions.
--  070806 HADALK Bug 66675, Modified Unpack_Check_Update___ AND Update___.
--  070813 ILSOLK Merged Bug Id 66675.
--  070830 ChAmlk Modified Update___ in order to delete Tech Class that came in with a previous object type when a
--                new object type with no Tech Class is connected.
--  071113 LIAMLK Bug 67252, Modified procedures Set_Scrapped, Set_Structure_Scrapped.
--  080408 LIAMLK Bug 69438, Removed General_SYS.Init_Method from Is_Infacility, Is_Scrapped, Infacility_Or_Workshop.
--  080410 NIJALK Bug 72545, Added procedure Check_Move().
--  080702 LoPrlk Bug 75205, Added the parameter mch_code_ to method Create_Maintenance_Aware.
--  080708 LoPrlk Bug 75205, Added the method Get_Obj_Info_By_Part.
--  080819 SHAFLK Bug 75966, Added new view EQUIPMENT_SERIAL_HISTORY.
--  081001 SHAFLK Bug 76904, Modified Move__.
--  090327 nukulk Bug 81398, Added ifs_assert_safe annotation.
--  090429 NUKULK Bug 82307, Modified Create_Serial_Object_C_O.
--  090602 LIAMLK Bug 82609, Added missing undefine statements.
--  090602 SHAFLK Bug 83102, Modified Create_Maintenance_Aware, Unpack_Check_Insert___ and Insert___.
--  -------------------------Project Eagle------------------------------------------------------
--  090826 SHAFLK Bug 85459, Modified Prepare_Insert___.
--  090918 SaFalk IID - ME310: Removed unused global variables [object_party_type_inst_]
--  090930 Hidilk Task EAST-317, reference added for enumeration package TRANSLATE_BOOLEAN_API
--  091019 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106 SaFalk IID - ME310: Removed bug comment tags.
--  100202 SHAFLK Bug 88411, Modified Set_Scrapped and Set_Structure_Scrapped.
--  100531 SHAFLK Bug 90667, Modified Create_Maintenance_Aware.
--  100531 SHAFLK Bug 90985, Modified view EQUIPMENT_SERIAL.
--  100603 NEKOLK Bug 87743, Modified Update___.
--  100611 UmDolk EANE-2348: Changed parameters passed to Object_Cust_Warranty_API.Add_Work_Order_Warranty method.
--  100618 SHAFLK Bug 91326, Modified Create_Maintenance_Aware.
--  100623 SHAFLK Bug 91426, Modified Update___ and Unpack_Check_Update___.
--  100708 NIFRSE Bug 87562, Modified Unpack_Check_Insert___, Unpack_Check_Update___.
--  100709 SHAFLK Bug 90620, Modified Create_Construction_Object().
--  100804 ILSOLK Bug 91054, Modified Move__().
--  100806 SHAFLK Bug 91933, Modified Create_Serial_Object_C_O().
--  100906 SHAFLK Bug 92739, Modified Move__().
--  100907 ILSOLK Bug 92855, Modified Insert___().
--  100908 ILSOLK Bug 92828, Modified Move_To_Repair(),Move__().
--  100914 ILSOLK Bug 92855, Modified Insert___().
--  100918 ILSOLK Bug 92828, Modified Move__().
--  101021 NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  101021 NIFRSE Bug 93384, Updated view column prompts to 'Object Site'.
--  101103 NIFRSE Bug 93352, Modified Move_To_Repair() to set SERIAL_MOVE to TRUE.
--  110129 NEKOLK EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_SERIAL.
--  110221 SaFalk EANE-4424, Added new view EQUIPMENT_SERIAL_UIV with user_allowed_site filter to be used in the client.
--  110422 ILSOLK Bug 96781, Modified Move__().
--                Removed user_allowed_site filter from EQUIPMENT_SERIAL.
--  110425 NRATLK Bug 96790, Modified Insert___() to insert address7.
--  110203 BhKaLK Merged Blackbird Code.
--  110629 MADGLK Bug 97396, Modified Create_Serial_Object_C_O().
--                ---------------------Defcon Below-------------------------------------------------------------
--                101007 IMFELK Defcon-BB10, Modified method Create_Maintenance_Aware() to call Part_Serial_Catalog_API to change the operational condition to operational.
--      ----------------------------------------------------------------------------------------------
--  110427 LoPrlk Issue: EASTONE-16604, Altered the method Create_Serial_Object_C_O.
--  110430 NEKOLK EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_SERIAL_HISTORY
--  110504 MADGLK Bug 96937, Modified views EQUIPMENT_SERIAL and EQUIPMENT_SERIAL_LOV and modified When_new_Mch().
--  110526 DiAmlk Jira Bug ID: EASTONE-18577 - Modified the method Create_Serial_Object_C_O.
--  110606 LoPrlk Issue: EASTONE-18578, Altered the method Create_Construction_Object.
--  110706 LIAMLK Bug 97644, Modified mch_name in VIEW, modified Insert___(), Handle_Part_Desc_Change(), Update___(), added Update_Object_Desc___().
--  110722 PRIKLK SADEAGLE-1739, Added user_allowed_site filter to view EQUIPMENT_SERIAL_HISTORY
--  110826 ILSOLK Bug 98626, Modified Insert___().
--  110728 SanDLK SADEAGLE-1887, When merging 97644 also modified VIEW_UIV.
--  110829 SanDLK Modified EQUIPMENT_SERIAL_UIV while Merging BUG 96937.
--  111017 MADGLK Bug 99136, Modified length of address1 to String(35).
--  111230 NRATLK Bug 100413, Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Update___().
--  120201 SAMGLK Bug 100937, Removed some code in Unpack_Check_Update___()and update__() added by Bug 100413.
--  120319 NEKOLK EASTRTM-5225,Modified Create_Serial_Object_C_O.
--  120517 HaRuLK SAPRE-49, Replaced Doc_Reference_Object_API.Refresh_Object_Reference_Desc() with Maintenance_Document_Ref_API.Refresh_Obj_Reference_Desc() in Handle_Part_Desc_Change().
--  120521 NRATLK Bug 102652, Modified Validate_Comb___().
--  120615 NEKOLK Bug 103435, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ .
--  120917 ReSeLK Bug 105241, Modified Update___().
--  121008 japelk Bug 105645, fixed in Unpack_Check_Insert___ and Update___ methods.
--  121008 SHAFLK EIGHTSA-230, Added new methods for new structures.
--  121218 INMALK Bug 107242, Added a parameter REPORTED_BY_ to Move_To_Repair() and sent in REPORTED_BY to modify note text.
--  130118 LoPrlk Task: NINESA-251, Added the attribute item_class_id to the LU.
--  130515 ChAmlk Bug 110085, Modified Update___().
--  -------------------------Project Black Pearl------------------------------------------------------
--  130508 MAWILK BLACK-66, Removed method calls to EQUIPMENT_ALL_OBJECT_API.
--  130613 MADGLK BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls.
--  300508 MAWILK  BLACK-145, Move_To_Inventory moved to Equipment_Serial_API.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
------------------------------------------------------------------------------------------------
--  ------------------------------------- APPS 9 -----------------------------------------------
--  130619  heralk  Scalability Changes - removed global variables.
--  131001  harplk  CONV-2269,Modified When_New_Mch__.
--  131213  NEKOLk  PBSA-1821, Hooks: refactored and split code.
--  131230  NEKOLK  PBSA-3414, Review fix.
--  140212  BHKALK  PBSA-4860, Removed unnecessary code from Check_Insert___.
--  131224  SADELK  PBSA-3791, Bug 114516, Modified Create_Object().
--  140217  BURALK  PBSA-4986, Fixed
--  140219  japelk  PBSA-4539, fixed.
--  140219  heralk  PBSA-5000, Fixed in PROCEDURE Validate_Comb___ ().
--  140225  heralk  PBSA-4394, Fixed in Check_Update___().
--  140226  japelk  PBSA-3601 fixed (LCS Bug: 113582).
--  140311  BHKALK  PBSA-3600, Merged LCS patch 112451.
--  130930  SHAFLK  Bug 112451, Modified Set_Structure_In_Operation().
--  140314  HASTSE  PBSA-5734, address fixes
--  140326  HERALK  PBSA-5000, Added override Check_Common___.
--  140331  HASTSE  PBSA-6137, Removed wrong defaaulting of production_date to site date, from UEE?
--  140407  NiFrSE  PBSA-6184, Added Text_Id$ default value in the Insert___() method.
--  140417  NIFRSE  PBSA-6150, Changed Error message in the Check_Insert___() method.
--  140430  KANILK  PBSA-6374, Added validations to Check_Insert___ method.
--  140505  HASTSE PBSA-6615, Replaced call to Maintenance_Spare_Api
--  140514  NiFrSE  PBSA-6956, Removed Text_Id$ default value in the Insert___() method.
--  140522  DUHELK  PBSA-7288, Modified Validate_Comb___.
--  140624  chanlk Bug 117516, Modified New_Object__ to send object information
--  140812  HASTSE  Replaced dynamic code
--  140815  SHAFLK  PRSA-2196, Replaced dynamic code in When_New_Mch__.
--  140825  SHAFLK  PRSA-2342, Modified Check_Update___.
--  140904  MAWILK  PRSA-2708, Merged Orbit changes.
--  141027  HASTSE  PRSA-2446, Reference checks dont work autmaticaly for Based on
--  141110  PRIKLK  PRSA-2456, Modified Insert__ and Update__.
--  141116  HASTSE  PRSA-5455, Replaced direct delete of PartSerialCatalog Records with cascade delete for the EquipmentObject record
--  141123  NuKuLK  PRSA-5620, Modified Insert___() and Update___().
--  141205  PRIKLK  PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  141216  chanlk  PRSA-3506, Modified move Serial Object.
--  141223  NEKOLK  PRSA-6078, Modified Create_Serial_Object_C_O
--  141223  MADGLK  PRSA-6193, Reverted changes of PRSA-2456.
--  150126  SHAFLK  PRSA-6517, Modified Set_Structure_In_Operation.
--  150127  chanlk  PRSA-6910, Corrections for Object Availability and exceptions.
--  150127  chanlk  PRSA-6800, Modified New_Object__ to add parties to objects.
--  150208  NuKuLK  PRSA-7335, Modified Do_Delete__().
--  150219  HASTSE  PRSC-6008, Fixed cascade delete handling
--  150220  KANILK  PRSA-7527, Merged Bug 120964, Modified Update___() method.
--  150713  RUMELK  Merged Bug 123155, Modified Check_Delete___, Delete___, Remove__, Check_Insert___. Added New Method Modify_Part_Serial___. Merged Bug 112701 as well.
--  150805  chanlk  Bug 123819, Handle Object_References shen deleting.
--  150903  SHAFLK  AFT-3373, Replaced all Remove__() with CheckDelete and Delete.
--  150903  CLEKLK  Bug 124005 Modified Create_Maintenance_Aware().
--------------------------- Candy Crush --------------------------------------------------
--  151012  DUHELK  MATP-964, Added Safe_Access_Code, modified Insert___.
--  151123  DUHELK  MATP-1265, Modified Move__.
--  151230  DUHELK  MATP-1338, Modified Update___ to give a warning when modifying criticality.
--  150106  DUHELK  MATP-1580, Modified Update___().
------------------------------------------------------------------------------------------------
--  160201  KrRaLK  STRSA-1884, Modified Insert___() and Update___().
--  160526  HARULK  STRSA-5294, Modified Move_To_Repair().
--  160803  HERALK  STRSA-9110, Merged LCS Patch 130373, Modified When_New_Mch__().
--  161117  SeRoLk  STRSA-14444, Code cleanup.
--  161121  jagrno  Merged patch 132587, Added validation in Validate_Comb___ to prevent creation of equipment serial if the serial already exists in VIM.
--                  Removed similar validation from method Create_Maintenance_Aware because this is now taken care of by Validate_Comb___.
--                  Modified error message in When_New_Mch__.
--  161129 MDAHSE   STRSA-15865, fix compilation error due to renamed method in EquipmentObject.
--  170403 CLEKLK   Merged Bug 134793, STRSA-21682, Modified Check_Update___.
--  170530 JAROLK   STRSA-24352, Modified Update___().
--  170503 chanlk   Bug 135658, Modified Validate_Comb___.
--  170622  chanlk  Bug 136498, Change get_cost_center to Equipment_Object_API.Get_Cost_Center.
--  170724  CLEKLK  STRSA-26786, Merged bug 135857, Modified constants to distinguish different messages.
--  171108  KANILK  STRSA-31426, Merged Bug 138320, Modified Check_Delete___ and Delete___ methods.
--  171126  HASTSE  STRSA-32829, Equipment inheritance implementation
--  180503  AMCHLK  Bug 141716, Modified method Move_To_Inventory() to avoid creating an auto task. 
--  180604  CLEKLK  Bug 142108, Modified Update, Move and Move_To_Repair
--  180801  KrRaLK  Bug 142623, Modified Remove__().
--  180927  CLEKLK  Bug 143858, Modified Check_Move() and Move__
--  181024  SHEPLK  SAUXXW4-10600, Added Get_Operational_Condition()
--  181031  SHEPLK  SAUXXW4-10600, Added Get_Technical_Data() and Get_Documents()
--  190516  LoPrlk  Bug 148121, Altered the methods Set_Scrapped and Set_Structure_Scrapped.
--  190803  SSILLK  Merge Bug 145867, Modified Update___()
--  ------------- Project Spring2020 ----------------------------------------
--  190925  TAJALK  SASPRING20-24, SCA changes
--  200128  KrRaLK  Bug 151631, Added Get_Owner_Name().
--  200210  Disklk  Bug 152278, Modified Create_Maintenance_Aware() to insert equipment object party record for order types with PROJECT_DELIVERABLES as well.
--  200427  Tajalk  Bug 153668, Modified When_New_Mch__() added missing parameter
--  201111  CLEKLK  AM2020R1-6863, Modified Get_Documents
--  210205  SHAGLK  AM2020R1-7260, Modified Delete___()
--  210324  DEEKLK  AM21R2-725, Modified Update___().
--  210510  RUSSLK  AM21R2-1464, Modified Insert___().
--  210609  SHAGLK  AM21R2-1493, Removed validation check for existing tool/equipment with part_no and mch_serial_no
--  210625  SHAGLK  AM21R2-1493, Added condition for validating check for record exist in part catalog, modified Check_Move
--  210720  SHAGLK  AM21R2-1493, Added new method Check_Tool_Equip_Connection.
--  210721  SHAGLK  AM21R2-1493, Added Check_Parent_Tool_Equip_Conn and Check_Obj_Tool_Equip_Conn and removed Check_Tool_Equip_Connection
--  210801  puvelk  AM21R2-2432, Created method Check_Serial_History_Exists___() and Modified Check_Insert___()
--  210806  DEEKLK  AMZEAX-691, Modified Handle_Part_Desc_Change().
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work 
--  211207  RUSSLK  AMZEAX-825, Modified Create_Serial_Object_C_O().
--  220124  NEKOLK  AM21R2-3844: Moved move serial validation in to Check_Move_Allowed .
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

calendar_date_               CONSTANT DATE := to_date('46131231','YYYYMMDD','NLS_CALENDAR=GREGORIAN');


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Production Date
   IF (newrec_.purch_date = oldrec_.purch_date AND newrec_.production_date = oldrec_.production_date) THEN
      NULL;
   ELSE
      IF (newrec_.production_date IS NOT NULL) THEN
         IF (newrec_.purch_date IS NOT NULL) THEN
            IF (newrec_.purch_date > newrec_.production_date) THEN
               Client_SYS.Add_Warning(lu_name_, 'INSDBEFPUR: Installation date (:P1) is earlier than purchase date (:P2). Still want to save this record?', newrec_.production_date, newrec_.purch_date);
            END IF;
         END IF;
      END IF;
   END IF;
END Check_Common___;


PROCEDURE Validate_Comb___ (
   newrec_      IN     EQUIPMENT_OBJECT_TAB%ROWTYPE,
   ctrl_flag_   IN     VARCHAR2 DEFAULT 'TRUE',
   from_serial_ IN     VARCHAR2 DEFAULT 'FALSE' )

IS
   rcode_             VARCHAR2(5);
   serial_exist_      VARCHAR2(5);
BEGIN
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
         IF(EQUIPMENT_OBJECT_API.Get_Is_Category_Object(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
            Error_SYS.Appl_General(lu_name_, 'CATOBJSTR: It is not possible to create structures for category objects.');
         END IF;
   END IF;

   -- Object status control
   IF (ctrl_flag_ = 'TRUE' AND newrec_.functional_object_seq IS NOT NULL) THEN
      IF (EQUIPMENT_OBJECT_API.Get_Operational_Status_Db(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'SCRAPPED') THEN
         Error_SYS.Appl_General(lu_name_, 'NOCONOBJ: It is not possible to add objects belonging to a scrapped object :P1.', Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
   END IF;
   -- Object loop control
   IF (newrec_.functional_object_seq IS NOT NULL AND ctrl_flag_ = 'TRUE') THEN
      Equipment_Object_API.Check_Tree_Loop__(rcode_,  newrec_.contract, newrec_.mch_code,Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), 'TRUE');
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOP: Object :P1 will cause a loop in the equipment structure.', Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
   END IF;

   -- Warranty Expires
   IF (newrec_.warr_exp IS NOT NULL) THEN
      IF (newrec_.purch_date IS NOT NULL) THEN
         IF (newrec_.purch_date > newrec_.warr_exp) THEN
            Error_SYS.Appl_General(lu_name_, 'PURAFTWARR: Purchase Date (:P1) can not be later than warranty expiration date (:P2).', newrec_.purch_date, newrec_.warr_exp);
         END IF;
      END IF;
   END IF;

   -- Purchase Date
   IF (newrec_.purch_date IS NOT NULL) THEN
      IF (newrec_.manufactured_date IS NOT NULL) THEN
         IF (newrec_.manufactured_date > newrec_.purch_date) THEN
            Error_SYS.Appl_General(lu_name_, 'PURDBEFMAN: Purchase date (:P1) can not be earlier than manufacture date (:P2).', newrec_.purch_date, newrec_.manufactured_date);
         END IF;
      END IF;
   END IF;

   -- IF functional object check that object_level is individual aware
   IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
      IF NOT Equipment_Functional_API.Check_Individual_Aware__(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) THEN
         Error_SYS.Appl_General(lu_name_, 'INDAWARE: Serials are not allowed on this object level.', Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
   END IF;
   -- For new records, ensure that the same serial does not already exist as a serial in VIM
   IF (newrec_.rowversion IS NULL) THEN
      $IF Component_Vim_SYS.INSTALLED $THEN
         serial_exist_ := Vim_Serial_API.Serial_No_Exist(newrec_.part_no, newrec_.mch_serial_no);
      $ELSE
         serial_exist_ := 'FALSE';
      $END
      -- Raise error if serial already exists in VIM
      IF (serial_exist_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'VIMSEREXIST: The serial :P1 already exist as a serial object in Fleet and Asset Management.', newrec_.part_no || ',' || newrec_.mch_serial_no);
      END IF;
   END IF;
   
   -- check if object or parents of the object is connected to tool/equipment
   IF (Check_Obj_Tool_Equip_Conn(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
      IF (Check_Obj_Tool_Equip_Conn(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN  
         Error_SYS.Appl_General(lu_name_, 'OBJCONNEXIST: Cannot set a Tool/Equipment connected Serial Object as Belongs To Object.');
      END IF;
      IF (Check_Parent_Tool_Equip_Conn(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'PARENTOBJCONNEXIST: Cannot set child Serial objects of Tool/Equipment connected Serial Object as Belongs To Object.');
      END IF;
   END IF;

END Validate_Comb___;


PROCEDURE Modify_Part_Serial___ (
   remrec_ IN EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
   latest_transaction_       EQUIPMENT_SERIAL.latest_transaction%TYPE;
   transaction_description_  VARCHAR2(2000);
   part_serial_catalog_rec_  Part_Serial_Catalog_API.Public_Rec;
BEGIN
   part_serial_catalog_rec_ := Part_Serial_Catalog_API.Get(remrec_.part_no, remrec_.mch_serial_no);
 
   latest_transaction_ := part_serial_catalog_rec_.latest_transaction;
   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'DELETEDOBJ: Equipment Object deleted, Object ID: :P1, Object Site: :P2 by user :P3', NULL, remrec_.mch_code, remrec_.contract, Fnd_Session_API.Get_Fnd_User);

   --If the serial part is in InFacility, then we change its state to issued
   IF (Part_Serial_Catalog_API.Get_Objstate(remrec_.part_no, remrec_.mch_serial_no) = 'InFacility') THEN
      Part_Serial_Catalog_API.Move_To_Issued(remrec_.part_no, remrec_.mch_serial_no, latest_transaction_, transaction_description_, 'OUT_OF_OPERATION', NULL, NULL, NULL, NULL, NULL);
   ELSE
      Part_Serial_History_API.New(remrec_.part_no, remrec_.mch_serial_no, 'CHG_CURRENT_POSITION', transaction_description_, NULL, NULL, NULL, NULL, NULL, NULL);
   END IF;
END Modify_Part_Serial___;



PROCEDURE Check_Serial_Reference___ (
   remrec_ IN     EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
   dummy_ NUMBER;

   CURSOR check_serial_catalog IS
      SELECT 1
      FROM   part_serial_catalog
      WHERE  part_no = remrec_.part_no AND serial_no = remrec_.mch_serial_no AND (objstate='InFacility' OR objstate='Contained');
   CURSOR check_serial_history IS
      SELECT COUNT(*)
      FROM   part_serial_history
      WHERE  part_no = remrec_.part_no AND serial_no = remrec_.mch_serial_no;
BEGIN
   OPEN check_serial_catalog;
   FETCH check_serial_catalog INTO dummy_;
   IF (dummy_ = 1) THEN
      CLOSE check_serial_catalog;
      OPEN check_serial_history;
      FETCH check_serial_history INTO dummy_;
      IF (dummy_ > 1) THEN
         CLOSE check_serial_history;
         Error_SYS.Record_General('EquipmentSerial', 'NOREMHISTROW: Record cannot be removed due to historical row');
      ELSE
         CLOSE check_serial_history;
      END IF;
   ELSE
      Error_SYS.Record_General('EquipmentSerial', 'NOREMILLSTATE: Record cannot be removed due to wrong state');
      CLOSE check_serial_catalog;
   END IF;

END Check_Serial_Reference___;

FUNCTION Check_Serial_History_Exists___(
   newrec_ IN equipment_object_tab%ROWTYPE) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_serial_history IS
      SELECT 1
      FROM   part_serial_history
      WHERE  part_no = newrec_.part_no 
      AND serial_no = newrec_.mch_serial_no;
BEGIN
   OPEN check_serial_history;
   FETCH check_serial_history INTO dummy_;
   IF (check_serial_history%FOUND) THEN
      CLOSE check_serial_history;
      RETURN TRUE;
   ELSE
      CLOSE check_serial_history;
      RETURN FALSE;
   END IF;
END Check_Serial_History_Exists___;

/*
PROCEDURE Remove_Serial_Reference___ (
remrec_ IN EQUIPMENT_OBJECT_TAB%ROWTYPE )
IS

BEGIN

DELETE
FROM  part_serial_history_tab
WHERE part_no = remrec_.part_no AND serial_no = remrec_.mch_serial_no;
DELETE
FROM  part_serial_catalog_tab
WHERE part_no = remrec_.part_no AND serial_no = remrec_.mch_serial_no AND (rowstate='InFacility' OR rowstate='Contained');

END Remove_Serial_Reference___;
*/

PROCEDURE Update_Object_Desc___ (
   part_no_ IN     VARCHAR2 )
IS
   mch_name_    VARCHAR2(200);
   newrec_      EQUIPMENT_OBJECT_TAB%ROWTYPE;
   
   CURSOR get_serial_objs IS
      SELECT contract, mch_code
      FROM EQUIPMENT_SERIAL
      WHERE part_no = part_no_;
BEGIN
   --XY a non existing lang code
   mch_name_ := Part_Catalog_API.Get_Description(part_no_, 'XY');

   FOR each_ IN get_serial_objs LOOP
      newrec_ := Get_Object_By_Keys___(each_.contract, each_.mch_code);
      newrec_.mch_name := mch_name_;
      Modify___(newrec_);
   END LOOP;
END Update_Object_Desc___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'COMPANY', Site_API.Get_Company(User_Default_API.Get_Contract), attr_);
   Client_SYS.Add_To_Attr( 'CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr( 'SUP_CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr( 'OWNERSHIP', Ownership_API.Decode('COMPANY OWNED'), attr_);
   Client_SYS.Add_To_Attr('SAFE_ACCESS_CODE', Safe_Access_Code_API.Decode('NOT_REQUIRED'), attr_);
   Client_SYS.Add_To_Attr('PM_PROG_APPLICATION_STATUS', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   operational_status_db_ VARCHAR2(20);
   latest_transaction_  EQUIPMENT_SERIAL.latest_transaction%TYPE;

   earlist_valid_from_       DATE;
   latest_valid_to_          DATE;
   warr_part_no_             VARCHAR2(25);
   warr_serial_no_           VARCHAR2(50);
   warr_id_                  NUMBER;

   warranty_id_              NUMBER;
   new_warranty_id_          NUMBER;
   transaction_description_  VARCHAR2(2000);
   design_object_            VARCHAR2(1) :='0';

   CURSOR warranty_dates IS
      SELECT min(valid_from), max(valid_to)
      FROM  SERIAL_WARRANTY_DATES_TAB
      WHERE part_no = warr_part_no_
      AND   serial_no = warr_serial_no_
      AND   warranty_id = warr_id_;

BEGIN
   SELECT Equipment_Object_Seq.nextval INTO newrec_.Equipment_Object_Seq FROM dual;
   
   design_object_ := NVL(Client_SYS.Get_Item_Value('DESIGN_OBJECT', attr_),design_object_);
   IF (newrec_.is_category_object IS NULL) THEN
      newrec_.is_category_object := 'FALSE';
   END IF;
   IF (newrec_.is_geographic_object IS NULL) THEN
      newrec_.is_geographic_object := 'FALSE';
   END IF;
   IF(newrec_.safe_access_code IS NULL) THEN
      newrec_.safe_access_code := 'NOT_REQUIRED';
   END IF;

   --pass non existing lang code XY to get default base description.
   newrec_.mch_name := Part_Catalog_API.Get_Description(newrec_.part_no, 'XY');
   
   IF (newrec_.functional_object_seq IS NULL) THEN
      IF(newrec_.location_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.location_object_seq;
      ELSIF (newrec_.from_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.from_object_seq;
      ELSIF (newrec_.to_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.to_object_seq;
      ELSIF (newrec_.process_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.process_object_seq;
      ELSIF (newrec_.pipe_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.pipe_object_seq;
      ELSIF (newrec_.circuit_object_seq IS NOT NULL) THEN
         newrec_.functional_object_seq := newrec_.circuit_object_seq;
      END IF;
   END IF;

   newrec_.location_object_seq :=  newrec_.functional_object_seq;
   newrec_.from_object_seq :=  newrec_.functional_object_seq;
   newrec_.to_object_seq     :=  newrec_.functional_object_seq;
   newrec_.process_object_seq     :=  newrec_.functional_object_seq;
   newrec_.pipe_object_seq       :=  newrec_.functional_object_seq;
   newrec_.circuit_object_seq       :=  newrec_.functional_object_seq;
   

   -- If location is null, set the parent object location by default.
   IF (newrec_.location_id IS NULL AND newrec_.functional_object_seq IS NOT NULL) THEN
      newrec_.location_id := Equipment_Object_API.Get_Location_Id(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
   END IF;   
   
   $IF Component_Wo_SYS.INSTALLED $THEN
   newrec_.item_class_id :=  nvl(newrec_.item_class_id, Maintenance_Inv_Part_API.Get_Item_Class_Id(newrec_.contract, newrec_.part_no));
   $END 

   super(objid_, objversion_, newrec_, attr_);


   IF (design_object_ = '1') THEN
      -- Selection from Equipment_Object due to objstate = 'Issued', 'InInventory', 'UnderDesign' -> not in VIEW
      operational_status_db_ := 'DESIGNED';
   ELSIF (design_object_ = '2') THEN
      -- Selection from Equipment_Object due to objstate = 'InFacility' -> not in VIEW
      operational_status_db_ := 'IN_OPERATION';
   ELSIF (design_object_ = '4') THEN
      -- Object Created from Plant Design
      operational_status_db_ := 'PLANNED_FOR_OP';
   ELSE
      operational_status_db_ := 'IN_OPERATION';
   END IF;

   IF (Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no) IS NULL) THEN
      -- New Object to place InFacility or Contained
      When_New_Mch__(newrec_.note,
      newrec_.contract,
      newrec_.mch_code,
      Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq),
      Equipment_Object_API.Get_Contract(newrec_.functional_object_seq),
      newrec_.part_no,
      newrec_.mch_serial_no,
      newrec_.warr_exp,
      newrec_.manufacturer_no,
      newrec_.vendor_no,
      newrec_.part_rev,
      operational_status_db_,
      newrec_.purch_price ,
      newrec_.production_date ,
      newrec_.manufactured_date ,
      newrec_.purch_date,
      newrec_.ownership,
      newrec_.owner);

   ELSE
      -- Add Customer Warranty from Serial Part
      IF Client_SYS.Get_Item_Value('CO_WO', attr_) = 'WO' THEN
         warranty_id_ := NULL;
         warranty_id_ := Part_Serial_Catalog_API.Get_Cust_Warranty_Id(newrec_.part_no,newrec_.mch_serial_no);

         IF warranty_id_ IS NOT NULL THEN
            -- There exist a warranty that shall be added to the serial object


            Cust_Warranty_API.Copy(new_warranty_id_, warranty_id_,newrec_.part_no,newrec_.mch_serial_no);


            IF (new_warranty_id_ IS NOT NULL) THEN

               warr_part_no_   := newrec_.part_no;
               warr_serial_no_ := newrec_.mch_serial_no;
               warr_id_        := new_warranty_id_;

               OPEN warranty_dates;
               FETCH warranty_dates INTO earlist_valid_from_, latest_valid_to_;
               CLOSE warranty_dates;

               Object_Cust_Warranty_API.Add_Work_Order_Warranty(newrec_.equipment_object_seq,
               NULL,
               NULL,
               new_warranty_id_,
               NULL,
               earlist_valid_from_,
               Warranty_Symptom_Status_API.Get_Client_Value(0),
               NULL,
               latest_valid_to_);
            END IF;

         END IF;


         -- Supplier Warranty from Serial Part

         warranty_id_ := NULL;


         warranty_id_ := Part_Serial_Catalog_API.Get_Sup_Warranty_Id(newrec_.part_no, newrec_.mch_serial_no);

         IF warranty_id_ IS NOT NULL THEN
            -- There exist a warranty that shall be added to the serial object


            Sup_Warranty_API.Copy(new_warranty_id_,warranty_id_,newrec_.part_no,newrec_.mch_serial_no);


            newrec_.vendor_no :=Part_serial_catalog_api.Get_Supplier_No (newrec_.part_no, newrec_.mch_serial_no);

            IF (new_warranty_id_ IS NOT NULL) THEN

               warr_part_no_   := newrec_.part_no;
               warr_serial_no_ := newrec_.mch_serial_no;
               warr_id_        := new_warranty_id_;

               OPEN warranty_dates;
               FETCH warranty_dates INTO earlist_valid_from_, latest_valid_to_;
               CLOSE warranty_dates;

               Object_Supplier_Warranty_API.Add_Work_Order_Warranty(newrec_.equipment_object_seq,
               NULL,
               newrec_.vendor_no,
               NULL,
               new_warranty_id_,
               Gen_Yes_No_API.Get_Client_Value(0),
               earlist_valid_from_,
               Warranty_Symptom_Status_API.Get_Client_VAlue(0),
               NULL,
               latest_valid_to_);
            END IF;

         END IF;
      END IF;

   END IF;
   IF Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no) = 'Issued' AND  Client_SYS.Get_Item_Value('MOVE_FAC', attr_) = 'TRUE' THEN
      transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVETOFACNEW: Object moved to facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
      latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTXTISS: Moved object :P1 to facility', NULL, newrec_.mch_code);
      Part_Serial_Catalog_API.Move_To_Facility(newrec_.part_no, newrec_.mch_serial_no, latest_transaction_, transaction_description_,'IN_OPERATION');
   END IF;

   Client_SYS.Add_To_Attr('SERIAL_STATE', Part_Serial_Catalog_API.Get_State(newrec_.part_no, newrec_.mch_serial_no), attr_);
   Client_SYS.Add_To_Attr('LATEST_TRANSACTION', Part_Serial_Catalog_API.Get_Latest_Transaction(newrec_.part_no, newrec_.mch_serial_no) , attr_);

   -- Auto add to Service Contract if specified to do so in the parent objects service contracts.
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      $IF Component_Pcmsci_SYS.INSTALLED $THEN
         Psc_Srv_Line_Objects_API.Add_To_Service_Contract(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), newrec_.contract, newrec_.mch_code);
      $ELSE
         NULL;
      $END
   END IF;

   Update_Availabilities(newrec_);

   -- Added for inheritance of map positions from location
   IF ( newrec_.location_id IS NOT NULL ) THEN
      Equipment_Object_API.Inherit_Equip_Map_Position(newrec_);
   END IF;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.contract, newrec_.mch_code);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);   
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EQUIPMENT_OBJECT_TAB%ROWTYPE,
   newrec_     IN OUT EQUIPMENT_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   description_              VARCHAR2(200);
   latest_transaction_       part_serial_catalog.latest_transaction%TYPE;
   transaction_description_  VARCHAR2(2000);
   tmp_attr_                 VARCHAR2(32000);
   object_curr_pos_          VARCHAR2(30);
   rep_woshop_curr_pos_      VARCHAR2(30);
   part_trans_               part_serial_catalog.latest_transaction%TYPE;
   key_value_from_           VARCHAR2(2000);
   key_value_to_             VARCHAR2(2000);
   key_value_new_            VARCHAR2(2000);
   technical_class_new_      VARCHAR2(2000);
   temp_mch_type_            VARCHAR2(20);
   new_mch_type_             VARCHAR2(20);
   child_attr_               VARCHAR2(2000);
   info_                     VARCHAR2(2000);
   child_objid_              EQUIPMENT_SERIAL.objid%type;
   child_objver_             EQUIPMENT_SERIAL.objversion%type;
   technical_class_          technical_object_reference.technical_class%TYPE;
   new_tech_spec_no_         technical_object_reference.technical_spec_no%TYPE;
   obj_info_                 VARCHAR2(200);
   manf_updated_             VARCHAR2(5) := 'FALSE';
   vendor_updated_           VARCHAR2(5) := 'FALSE';
   pur_price_updated_        VARCHAR2(5) := 'FALSE';
   dummy_inst_date_          DATE;
   indrec_                   Indicator_rec;
   cmnt_                     VARCHAR2(2000);
   disconnect_pm_prog_       VARCHAR2(8);
   disconnect_attr_          VARCHAR2(32000);
   sup_mch_code_             VARCHAR2(100);
   sup_contract_             VARCHAR2(5);
   part_serial_catalog_rec_  Part_Serial_Catalog_API.Public_Rec;
   sup_serial_no_            equipment_object_tab.mch_serial_no%TYPE;
   sup_part_no_              equipment_object_tab.part_no%TYPE;
   
      CURSOR get_children (equipment_object_seq_ IN NUMBER, location_id_ VARCHAR2) IS
      SELECT mch_code, contract, sup_mch_code, sup_contract, Equipment_Object_API.Get_Location_Id(sup_contract, sup_mch_code) as sup_location
      FROM equipment_object
      WHERE (location_id IS NULL OR location_id = location_id_)
      START WITH functional_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq order by level;
      
BEGIN
   sup_mch_code_ := Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq);
   sup_contract_ := Equipment_Object_API.Get_Contract(newrec_.functional_object_seq);
   -- Unpack virtual attributes.
   manf_updated_       := NVL(Client_SYS.Get_Item_Value('MANUFACTURER_UPDATED', attr_),manf_updated_);
   vendor_updated_     := NVL(Client_SYS.Get_Item_Value('VENDOR_UPDATED', attr_),vendor_updated_);
   pur_price_updated_  := NVL(Client_SYS.Get_Item_Value('PUR_PRICE_UPDATED', attr_),manf_updated_);
   disconnect_pm_prog_ := NVL(Client_SYS.Get_Item_Value('DISCONNECT_PM_PROG', attr_), 'FALSE');
   Equipment_Object_Util_API.Check_Type_Status(newrec_.contract, newrec_.mch_code, oldrec_.mch_type, newrec_.mch_type);
   part_trans_ := Part_Serial_Catalog_api.Get_Latest_Transaction(newrec_.part_no, newrec_.mch_serial_no);
   newrec_.location_object_seq :=  newrec_.functional_object_seq;
   newrec_.from_object_seq :=  newrec_.functional_object_seq;
   newrec_.to_object_seq     :=  newrec_.functional_object_seq;
   newrec_.process_object_seq     :=  newrec_.functional_object_seq;
   newrec_.pipe_object_seq       :=  newrec_.functional_object_seq;
   newrec_.circuit_object_seq       :=  newrec_.functional_object_seq;

   indrec_                   := Get_Indicator_Rec___(oldrec_, newrec_);
   
   IF (indrec_.functional_object_seq) THEN
      IF (newrec_.functional_object_seq IS NOT NULL) THEN
         -- If parent is added, and the location is null, get the new parent's location OR
         -- If parent is changed, and the location is null or same as the previous parent's location, get the new parent's location.         
         IF ((newrec_.location_id IS NULL) OR NOT(indrec_.location_id OR Validate_SYS.Is_Changed(newrec_.location_id, Equipment_Object_API.Get_Location_Id(Equipment_Object_API.Get_Contract(oldrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(oldrec_.functional_object_seq))))) THEN
            newrec_.location_id := Equipment_Object_API.Get_Location_Id(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
            indrec_.location_id := TRUE;
         END IF; 
         -- If parent is removed, and the location is same as the previous parent's location, remove it.
      ELSIF NOT(indrec_.location_id OR Validate_SYS.Is_Changed(newrec_.location_id, Equipment_Object_API.Get_Location_Id(Equipment_Object_API.Get_Contract(oldrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(oldrec_.functional_object_seq)))) THEN
         newrec_.location_id := NULL;
         indrec_.location_id := TRUE;
      END IF;      
   END IF;
   
   -- Inherit the parent's new location down the structure for objects that has the parent's old location or no location.
   IF (indrec_.location_id) THEN
      FOR child_ IN get_children(newrec_.equipment_object_seq, oldrec_.location_id) LOOP
         IF ((child_.sup_location IS NULL) OR (child_.sup_location IS NOT NULL AND child_.sup_location = oldrec_.location_id)) THEN
            Client_SYS.Clear_Attr(child_attr_);
            Client_SYS.Add_To_Attr( 'LOCATION_ID', newrec_.location_id, child_attr_);
            Equipment_Object_API.Get_Id_Version_By_Keys__ (child_objid_, child_objver_, child_.contract, child_.mch_code);
            Equipment_Object_API.Modify__(info_, child_objid_, child_objver_, child_attr_,'DO');
         END IF;
      END LOOP;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);


   Client_SYS.Clear_Attr(tmp_attr_);
   Client_SYS.Add_To_Attr('WARRANTY_EXPIRES', newrec_.warr_exp , tmp_attr_);
   IF (oldrec_.note IS NULL AND newrec_.note IS NOT NULL) OR (oldrec_.note IS NOT NULL AND newrec_.note IS NULL) OR (oldrec_.note IS NOT NULL AND newrec_.note IS NOT NULL AND oldrec_.note != newrec_.note) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', newrec_.note , tmp_attr_);
   END IF;

   IF (manf_updated_ = 'TRUE' ) THEN
      manf_updated_ := 'FALSE';
      Client_SYS.Add_To_Attr('MANUFACTURER_NO', newrec_.manufacturer_no , tmp_attr_);
   END IF;
   IF (vendor_updated_ = 'TRUE' ) THEN
      vendor_updated_ := 'FALSE';
      Client_SYS.Add_To_Attr('SUPPLIER_NO', newrec_.vendor_no , tmp_attr_);
   END IF;
   dummy_inst_date_ := Part_Serial_Catalog_API.Get_Installation_Date(newrec_.part_no, newrec_.mch_serial_no);

   IF (dummy_inst_date_ IS NULL AND newrec_.production_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INSTALLATION_DATE', newrec_.production_date, tmp_attr_);
   END IF;
   Client_SYS.Add_To_Attr('SERIAL_REVISION', newrec_.part_rev , tmp_attr_);
   IF (pur_price_updated_ = 'TRUE' ) THEN
      pur_price_updated_ := 'FALSE';
      Client_SYS.Add_To_Attr('ACQUISITION_COST', newrec_.purch_price, tmp_attr_);
   END IF;

   IF ( nvl(oldrec_.purch_date, calendar_date_) != nvl(newrec_.purch_date, calendar_date_) ) THEN
      Client_SYS.Add_To_Attr('PURCHASED_DATE', newrec_.purch_date, tmp_attr_);
   END IF;


   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      Equipment_Object_Util_API.Get_Part_Info(sup_part_no_, sup_serial_no_, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      Client_SYS.Add_To_Attr('SUPERIOR_PART_NO', sup_part_no_, tmp_attr_);
      Client_SYS.Add_To_Attr('SUPERIOR_SERIAL_NO', sup_serial_no_, tmp_attr_);    
      IF (oldrec_.functional_object_seq IS NULL) THEN
         rep_woshop_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
         IF NOT (rep_woshop_curr_pos_ = 'InRepairWorkshop') THEN
            description_ := Equipment_Object_Api.Get_Mch_Name(sup_contract_, sup_mch_code_);
            obj_info_ := TO_CHAR(sup_mch_code_|| ', ' || description_ );
            latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2. ' ,NULL , obj_info_, sup_contract_);
         END IF;

         Client_SYS.Add_To_Attr('LATEST_TRANSACTION', latest_transaction_, tmp_attr_);
         transaction_description_ := latest_transaction_;

         object_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);

         IF (part_trans_ = Equipment_Obj_Move_Status_API.Decode('NEW')) THEN
            IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  Part_Serial_Catalog_API.Move_To_Facility(newrec_.part_no, newrec_.mch_serial_no, 
                  transaction_description_, transaction_description_);
               ELSE
                  Part_Serial_History_API.New(newrec_.part_no, newrec_.mch_serial_no, 'CHG_CURRENT_POSITION', transaction_description_, NULL, NULL, NULL, NULL, NULL, NULL);
               END IF;
            ELSIF (Equipment_Serial_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'Contained') THEN
                  Part_Serial_Catalog_API.Move_To_Contained(newrec_.part_no, newrec_.mch_serial_no, transaction_description_, transaction_description_);
               ELSE
                  Part_Serial_History_API.New(newrec_.part_no, newrec_.mch_serial_no, 'CHG_CURRENT_POSITION', transaction_description_, NULL, NULL, NULL, NULL, NULL, NULL);
               END IF;
            END IF;
         END IF;

         Trace_SYS.Message('state = '||Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no));
      END IF;
      Update_Availabilities(newrec_);
      IF (oldrec_.functional_object_seq IS NULL AND NOT indrec_.functional_object_seq) THEN
         Move__(cmnt_, newrec_.contract, newrec_.mch_code, NULL, NULL, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), NULL);
      END IF ;
      -- Auto add to Service Contract when parent is changed and if that parent is connnected to a service contract auto add child objs is enabled .
      IF ((indrec_.functional_object_seq = TRUE) AND (newrec_.functional_object_seq IS NOT NULL)) THEN
         $IF Component_Pcmsci_SYS.INSTALLED $THEN
            Psc_Srv_Line_Objects_API.Add_To_Service_Contract(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), newrec_.contract, newrec_.mch_code, 'TRUE', Equipment_Object_API.Get_Contract(oldrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(oldrec_.functional_object_seq));
         $ELSE
            NULL;
         $END
      END IF;
      
      IF (Client_SYS.Item_Exist('INSERT_SRV', attr_)) THEN
         $IF Component_Pcmsci_SYS.INSTALLED $THEN
            Psc_Srv_Line_Objects_API.Update_Srv_Con_Connection(sup_contract_, sup_mch_code_, newrec_.contract, newrec_.mch_code, Client_SYS.Get_Item_Value('INSERT_SRV', attr_));
         $ELSE
            NULL;
         $END
      END IF;
   ELSE
      IF (oldrec_.functional_object_seq IS NOT NULL) THEN
         Part_Serial_Catalog_API.Remove_Superior_Info(newrec_.part_no, newrec_.mch_serial_no, 'InFacility', transaction_description_);
      ELSE
         part_serial_catalog_rec_ := Part_Serial_Catalog_API.Get(newrec_.part_no, newrec_.mch_serial_no);
         Client_SYS.Add_To_Attr('SUPERIOR_PART_NO', part_serial_catalog_rec_.superior_part_no, tmp_attr_);
         Client_SYS.Add_To_Attr('SUPERIOR_SERIAL_NO', part_serial_catalog_rec_.superior_serial_no, tmp_attr_);
      END IF;        
   END IF;

   Part_Serial_Catalog_API.Modify( tmp_attr_, newrec_.part_no, newrec_.mch_serial_no);

   key_value_to_     := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
   technical_class_  := TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObject',key_value_to_);
   new_mch_type_     := newrec_.mch_type;
   temp_mch_type_    := oldrec_.mch_type ;
   key_value_from_   := newrec_.mch_type || '^';

   IF (new_mch_type_ IS NOT NULL) THEN
      key_value_new_     := CLIENT_SYS.Get_Key_Reference('EquipmentObjType', 'MCH_TYPE', new_mch_type_);
      IF (key_value_new_ IS NOT NULL) THEN
         technical_class_new_ :=TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObjType',key_value_new_);
      END IF;
   END IF;

   IF (Client_sys.Get_Item_Value('REMOVE_REQUIREMENTS', attr_) = 'TRUE') THEN
      IF (new_mch_type_ IS NOT NULL) THEN
         IF (((technical_class_new_ IS NOT NULL) AND (technical_class_ IS NOT NULL)) OR (technical_class_ IS NOT NULL AND technical_class_new_ IS NULL)) THEN
            TECHNICAL_OBJECT_REFERENCE_API.Delete_Reference ('EquipmentObject',key_value_to_);
         END IF;
      ELSE
         IF (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObject', key_value_to_) != -1) THEN
            TECHNICAL_OBJECT_REFERENCE_API.Delete_Reference ('EquipmentObject',key_value_to_);
         END IF;
      END IF;
   END IF;

   $IF Component_Wo_SYS.INSTALLED AND Component_Mpbint_SYS.INSTALLED $THEN
      IF Mpb_Wo_Int_API.Obj_Has_Mpb_Wo(newrec_.contract, newrec_.mch_code) = 'TRUE' THEN
         IF(newrec_.criticality IS NULL AND oldrec_.criticality IS NOT NULL) OR (newrec_.criticality IS NOT NULL AND oldrec_.criticality IS NULL) OR
         ((newrec_.criticality IS NOT NULL AND oldrec_.criticality IS NOT NULL) AND (newrec_.criticality <> oldrec_.criticality) ) THEN
            Client_SYS.Add_Info('EquipmentSerial','CHANGECRITICALITY: Changes to criticality will affect on Critical work check box in Work order/PM and it might result in critical order to become tardy. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         END IF;

         IF(newrec_.safe_access_code IS NULL AND oldrec_.safe_access_code IS NOT NULL) OR (newrec_.safe_access_code IS NOT NULL AND oldrec_.safe_access_code IS NULL) OR
         ((newrec_.safe_access_code IS NOT NULL AND oldrec_.safe_access_code IS NOT NULL) AND (newrec_.safe_access_code <> oldrec_.safe_access_code) ) THEN
            Client_SYS.Add_Info('EquipmentSerial','CHANGESAFEACCESS: Changes to Safe Access Code or Operational Mode Group might result in overlaps with obstructive maintenance schedule. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         END IF;
      END IF;
   $END

   -- Set the characteristics of the object to the characteristics of the object type
   -- whenever the object type is changed and has characteristics.

   IF ((indrec_.mch_type = TRUE) AND (newrec_.mch_type IS NOT NULL) AND (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObjType', key_value_from_) != -1)) THEN

      key_value_to_     := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);

      IF (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObject', key_value_to_) = -1) THEN
         technical_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key('EquipmentObjType', key_value_from_);
         Technical_Object_Reference_API.Create_Reference_(new_tech_spec_no_, 'EquipmentObject', key_value_to_, technical_class_);
      END IF;
   END IF;
   vendor_updated_ := 'FALSE';
   pur_price_updated_ := 'FALSE';

--   IF ((oldrec_.location_id != newrec_.location_id) OR (oldrec_.location_id IS NULL AND newrec_.location_id IS NOT NULL)) THEN
   IF ( Validate_SYS.Is_Changed(oldrec_.location_id, newrec_.location_id) ) THEN
      -- Added for inheritance of map positions from location
      Equipment_Object_API.Inherit_Equip_Map_Position(newrec_);
   END IF;
   
   $IF Component_Pcmstd_SYS.INSTALLED $THEN
      IF (disconnect_pm_prog_ = 'TRUE') THEN
         Client_SYS.Clear_Attr(disconnect_attr_);
         Client_SYS.Add_To_Attr('PM_PROGRAM_ID', newrec_.applied_pm_program_id, disconnect_attr_);
         Client_SYS.Add_To_Attr('PM_PROGRAM_REV', newrec_.applied_pm_program_rev, disconnect_attr_);
         Client_SYS.Add_To_Attr('SET_PM_TO_OBSOLETE', '0', disconnect_attr_);
         Client_SYS.Add_To_Attr('MCH_CODE', newrec_.mch_code, disconnect_attr_);
         Client_SYS.Add_To_Attr('MCH_CONTRACT', newrec_.contract, disconnect_attr_);
         Client_SYS.Add_To_Attr('CONNECTION_TYPE_DB', 'EQUIPMENT', disconnect_attr_);
         Client_SYS.Add_To_Attr('OBJECT_COUNT', '1', disconnect_attr_);
         Pm_Program_API.Disconnect_Pm_Program(disconnect_attr_);
      END IF;
   $END

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   key_value_from_       VARCHAR2(2000);
   key_value_to_         VARCHAR2(2000);
   serial_state_         part_serial_catalog.objstate%TYPE;
   co_wo_dummy_          VARCHAR2(2);
   move_fac_             VARCHAR2(5);
   code_parts_added_     VARCHAR2(5)  := 'FALSE';
   technical_class_      technical_object_reference.technical_class%TYPE;
   new_tech_spec_no_     technical_object_reference.technical_spec_no%TYPE;
   design_object_        VARCHAR2(1) :='0';
   equipment_serial_rec_ Equipment_Serial_API.Public_Rec;
   company_              SITE_TAB.company%TYPE;
   equip_conn_           BOOLEAN;
   history_exist_        BOOLEAN := FALSE;
BEGIN
   move_fac_      := Client_SYS.Get_Item_Value('MOVE_FAC',attr_);
   design_object_ := nvl(Client_SYS.Get_Item_Value('DESIGN_OBJECT', attr_),'0');
   co_wo_dummy_   := Client_SYS.Get_Item_Value('CO_WO',attr_);
   history_exist_ := Check_Serial_History_Exists___(newrec_);
   
   IF history_exist_ = TRUE THEN 
      Client_SYS.Add_Warning('EquipmentSerial', 'HISTORYEXIST: A transaction history of creation and deletion of the serial object with same Serial No :P1 of Part No :P2 already exists. If you create the same serial object again it will not be possible to delete it. Do you still want to save this record?', newrec_.mch_serial_no, newrec_.part_no);
   END IF;

   IF (newrec_.mch_code IS NULL) THEN
      Concatenate_Object__(newrec_.mch_code, newrec_.part_no, newrec_.mch_serial_no);
   END IF;
   
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   --NOTE,Test and move the code
--   IF (newrec_.sup_mch_code IS NULL) THEN
--      newrec_.sup_contract := NULL;
--   ELSE
--      IF newrec_.sup_contract IS NULL THEN
--         newrec_.sup_contract := newrec_.contract;
--      END IF;
--   END IF;


   Validate_Comb___(newrec_);
   -- Exist control

   -- check for tool/equipment connection
   equip_conn_ := Resource_Tool_Equip_API.Check_Exist_Part_And_Serial(newrec_.part_no, newrec_.mch_serial_no);
   
   --  DESIGN_OBJECT is used by project delivery and after sales from customer order to allow creation of objects thus they exist in part_serial_catalog
   IF ((Part_Serial_Catalog_API.Check_Exist(newrec_.part_no, newrec_.mch_serial_no)='TRUE') AND (design_object_< '1') AND equip_conn_ = FALSE) THEN
      Error_SYS.Appl_General(lu_name_, 'USEMAINAWARE: The Serial No :P1 is already in use for Part No :P2. Use Serial Maintenance Aware to connect Part Serial.', newrec_.mch_serial_no, newrec_.part_no);
   END IF;

   IF (newrec_.functional_object_seq IS NOT NULL) THEN

      IF (PART_SERIAL_CATALOG_API.Is_In_Inventory(newrec_.part_no, newrec_.mch_serial_no) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'CHILDCURRENT: Object with a current position "In Inventory" is not allowed to have a superior object.');
      END IF;

      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));
      
      equipment_serial_rec_ := Equipment_Serial_API.Get(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      IF (PART_SERIAL_CATALOG_API.Is_In_Inventory(equipment_serial_rec_.part_no, equipment_serial_rec_.mch_serial_no) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'PARENTCURRENT: Object with a current position "In Inventory" cannot be added as a parent object.');
      END IF;
   END IF;
   --

   IF (newrec_.production_date IS NOT NULL) THEN
      serial_state_ := PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
      IF (NOT serial_state_ IN ('InFacility', 'InRepairWorkshop', 'Contained')) THEN
         Error_SYS.Appl_General(lu_name_, 'PRODASERIALSTATE: Production Date (:P1) can not be changed because Serial Status is not "In Facility", "Contained" or "In RepairWorkshop".', newrec_.production_date);
      END IF;
   END IF;
   --NOTE,Test and move the code,end

   --  Add mch_loc, mch_pos, group_id and cost_center from superior object if null.
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (newrec_.functional_object_seq IS NOT NULL AND (newrec_.contract IS NOT NULL) AND (Site_API.Get_Company(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq)) = company_)) THEN
      IF (newrec_.mch_loc IS NULL) THEN
         newrec_.mch_loc := Get_Mch_Loc(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
      IF (newrec_.mch_pos IS NULL) THEN
         newrec_.mch_pos := Get_Mch_Pos(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
      IF (newrec_.cost_center IS NULL) THEN
         newrec_.cost_center := Equipment_Object_API.Get_Cost_Center(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)); 
      END IF;
   END IF;

   IF code_parts_added_ = 'TRUE'  AND PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no) = 'InInventory' THEN
      Client_Sys.Add_Warning(lu_name_,'NOCODEPARTSCOPY: The code parts will not be inherited to a work order as long as the serial is located inside the Inventory. The work order needs to be accounted manually.');
   END IF;

   IF (newrec_.cost_center IS NOT NULL) THEN
      Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
      'CostCenter', newrec_.cost_center);
      code_parts_added_ := 'TRUE';
   END IF;
   IF (newrec_.object_no IS NOT NULL) THEN
      Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
      'Object', newrec_.object_no);
      serial_state_ := PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
      IF (NOT serial_state_ IN ('InFacility', 'InRepairWorkshop', 'Contained', 'InInventory')) THEN
         Error_SYS.Appl_General(lu_name_, 'OBJNOSERIALSTATE: Financial Object No (:P1) can not be change because Serial Status is not in "In Facility", "Contained", "In RepairWorkshop" or "In Inventory".', newrec_.object_no);
      END IF;
      code_parts_added_ := 'TRUE';
   END IF;

   IF (co_wo_dummy_ IS NULL) THEN
      co_wo_dummy_ := 'WO';
   END IF;

   Client_SYS.Add_To_Attr( 'CONTRACT', newrec_.contract, attr_ );
   Client_SYS.Add_To_Attr( 'MCH_CODE', newrec_.mch_code, attr_ );
   Client_SYS.Add_To_Attr( 'CO_WO' , co_wo_dummy_, attr_);
   Client_SYS.Add_To_Attr( 'OWNER', newrec_.owner , attr_);
   -- Set the characteristics of the object to the characteristics of the object type
   -- whenever the object type is changed and has characteristics.
   -- Check whether equipment object has a technical number before copy technical object values.
   IF Equipment_object_api.has_technical_spec_no('EquipmentObject', CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq)) = 'FALSE' THEN
      key_value_from_ := newrec_.mch_type || '^';
      IF ((newrec_.mch_type IS NOT NULL) AND (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObjType', key_value_from_) != -1)) THEN
         key_value_to_     := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
         IF (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObject', key_value_to_) != -1) THEN
            Technical_Object_Reference_API.Copy_Values(key_value_from_, key_value_to_, NULL, NULL,'EquipmentObjType', 'EquipmentObject');
         ELSE
            technical_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key('EquipmentObjType', key_value_from_);
            Technical_Object_Reference_API.Create_Reference_(new_tech_spec_no_, 'EquipmentObject', key_value_to_, technical_class_);
         END IF;
      END IF;
   END IF;

--   IF (newrec_.functional_object_seq IS NULL) THEN
--      Client_SYS.Add_To_Attr( 'FUNCTIONAL_OBJECT_SEQ', newrec_.functional_object_seq, attr_ );
--   END IF;
   Client_SYS.Add_To_Attr( 'MOVE_FAC' , move_fac_, attr_);


   -- Add virtual attributes to the attr-string for further processing in the Insert___ method
   Client_SYS.Add_To_Attr( 'DESIGN_OBJECT', design_object_, attr_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     equipment_object_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   serial_state_        part_serial_catalog.objstate%TYPE;
   key_value_to_        VARCHAR2(2000);
   technical_class_     VARCHAR2(2000);
   technical_spec_      NUMBER;
   total_count_         NUMBER;
   temp_mch_type_       VARCHAR2(20);
   new_mch_type_        VARCHAR2(20);
   equip_serial_rec_    Equipment_Serial_API.Public_Rec;
   sup_mch_updated_     VARCHAR2(5) := 'FALSE';
   serial_move_         VARCHAR2(5) := 'FALSE';
   key_value_new_       VARCHAR2(2000);
   technical_class_new_ VARCHAR2(2000);
   code_parts_added_    VARCHAR2(5)  := 'FALSE';
   remove_requirements_ VARCHAR2(5);
   manf_updated_        VARCHAR2(5) := 'FALSE';
   vendor_updated_      VARCHAR2(5) := 'FALSE';
   pur_price_updated_   VARCHAR2(5) := 'FALSE';
   company_             SITE_TAB.company%TYPE;
BEGIN
   serial_move_ := Client_SYS.Get_Item_Value('SERIAL_MOVE',attr_);
   remove_requirements_ := Client_SYS.Get_Item_Value('REMOVE_REQUIREMENTS',attr_);

   IF indrec_.functional_object_seq = TRUE THEN
      sup_mch_updated_ := 'TRUE';
   END IF;
   IF indrec_.MANUFACTURER_NO = TRUE THEN
      manf_updated_ := 'TRUE';
   END IF;
   IF indrec_.PURCH_PRICE = TRUE THEN
      pur_price_updated_ := 'TRUE';
   END IF;
   IF indrec_.VENDOR_NO = TRUE THEN
      vendor_updated_ := 'TRUE';
   END IF;
   
   IF NOT (Client_SYS.Item_Exist('SKIP_CONTRACT_VALIDATION', attr_)) THEN
      Validate_SYS.Item_Update(lu_name_, 'CONTRACT', indrec_.contract);
   END IF; 
   --move serial validations
   IF ( Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract) ) THEN
      Equipment_Object_Util_API.Check_Move_Allowed(newrec_.equipment_object_seq, newrec_.contract);
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
 
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (newrec_.cost_center IS NOT NULL) THEN
      Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
      'CostCenter', newrec_.cost_center);
      code_parts_added_ := 'TRUE';
   END IF;
   IF (indrec_.object_no = TRUE) THEN
      serial_state_ := PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
      IF (NOT serial_state_ IN ('InFacility', 'InRepairWorkshop', 'Contained', 'InInventory')) THEN
         Error_SYS.Appl_General(lu_name_, 'OBJNOSERIALSTATE: Financial Object No (:P1) can not be change because Serial Status is not in "In Facility", "Contained", "In RepairWorkshop" or "In Inventory".', newrec_.object_no);
      ELSIF( newrec_.object_no IS NOT NULL) THEN
         Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
         'Object', newrec_.object_no);

      code_parts_added_ := 'TRUE';
      END IF;
   END IF;

   IF (newrec_.functional_object_seq IS NOT NULL) AND sup_mch_updated_ = 'TRUE' THEN

      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));

      equip_serial_rec_ := Equipment_Serial_API.Get(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      IF (PART_SERIAL_CATALOG_API.Is_In_Inventory(equip_serial_rec_.part_no, equip_serial_rec_.mch_serial_no) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'PARENTCURRENT: Object with a current position "In Inventory" cannot be added as a parent object.');
      END IF;

      equip_serial_rec_ := Equipment_Serial_API.Get(newrec_.contract, newrec_.mch_code);
      IF (PART_SERIAL_CATALOG_API.Is_In_Inventory(equip_serial_rec_.part_no, equip_serial_rec_.mch_serial_no) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'CHILDCURRENT: Object with a current position "In Inventory" is not allowed to have a superior object.');
      END IF;
   END IF;

   IF indrec_.PURCH_DATE = TRUE THEN
      serial_state_ := PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
      IF (NOT serial_state_ IN ('InFacility', 'InRepairWorkshop', 'Contained')) THEN
         Error_SYS.Appl_General(lu_name_, 'PURDASERIALSTATE: Purchase Date (:P1) can not be change because Serial Status is not in "In Facility", "Contained" or "In RepairWorkshop".', Client_SYS.Attr_Value_To_Date(newrec_.purch_date));
      END IF;
   END IF;

   IF indrec_.PRODUCTION_DATE = TRUE THEN
      serial_state_ := PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no);
      IF (NOT serial_state_ IN ('InFacility', 'InRepairWorkshop', 'Contained')) THEN
         Error_SYS.Appl_General(lu_name_, 'PRODASERIALSTATE: Production Date (:P1) can not be changed because Serial Status is not "In Facility", "Contained" or "In RepairWorkshop".', Client_SYS.Attr_Value_To_Date(value_));
      END IF;
   END IF;

   key_value_to_      := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
   technical_class_   := TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObject',key_value_to_);
   technical_spec_    := TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Spec_No('EquipmentObject',key_value_to_);
   total_count_       := TECHNICAL_OBJECT_REFERENCE_API.Get_Defined_Count(technical_spec_,technical_class_);
   new_mch_type_      := newrec_.mch_type;
   temp_mch_type_     := Get_Mch_Type(newrec_.contract ,newrec_.mch_code );

   IF (new_mch_type_ IS NOT NULL) THEN
      key_value_new_     := CLIENT_SYS.Get_Key_Reference('EquipmentObjType', 'MCH_TYPE', new_mch_type_);
      IF (key_value_new_ IS NOT NULL) THEN
         technical_class_new_ :=TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObjType',key_value_new_);
      END IF;
   END IF;

   Validate_Comb___(newrec_,sup_mch_updated_,serial_move_);

   --  Add mch_loc, mch_pos, group_id and cost_center from superior object if null.
   IF (newrec_.functional_object_seq IS NOT NULL AND (newrec_.contract IS NOT NULL) AND (Site_API.Get_Company(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq)) = Site_API.Get_Company(newrec_.contract))) THEN
      IF (newrec_.mch_loc IS NULL) THEN
         newrec_.mch_loc := Get_Mch_Loc(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
      IF (newrec_.mch_pos IS NULL) THEN
         newrec_.mch_pos := Get_Mch_Pos(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
      IF (newrec_.cost_center IS NULL) THEN
         newrec_.cost_center := Equipment_Object_API.Get_Cost_Center(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));    
      END IF;
   END IF;

   IF code_parts_added_ = 'TRUE'  AND PART_SERIAL_CATALOG_API.Get_Objstate(newrec_.part_no, newrec_.mch_serial_no) = 'InInventory' THEN
      Client_Sys.Add_Warning(lu_name_,'NOCODEPARTSCOPY: The code parts will not be inherited to a work order as long as the serial is located inside the Inventory. The work order needs to be accounted manually.');
   END IF;
   
   $IF Component_Pcmstd_SYS.INSTALLED $THEN
      IF ((indrec_.process_class_id OR indrec_.item_class_id) AND newrec_.applied_pm_program_id IS NOT NULL) THEN
         IF (Pm_Program_Class_API.Check_Itm_Prcs_Cls_Comb(newrec_.applied_pm_program_id, newrec_.applied_pm_program_rev, newrec_.process_class_id, newrec_.item_class_id) = 'FALSE') THEN
            Client_SYS.Add_Warning(lu_name_, 'CANOTREMPROCITEM: A PM Program has been applied on this Object and if you change the value for process class or item class, the connection between the Object and the PM Program will also be removed.');
            Client_SYS.Add_To_Attr('DISCONNECT_PM_PROG', 'TRUE', attr_);            
         END IF;   
      END IF;   
   $END 

   Client_SYS.Add_To_Attr( 'REMOVE_REQUIREMENTS', remove_requirements_, attr_);
   -- Add virtual attributes to the attr-string for further processing in the Update___ method
   Client_SYS.Add_To_Attr( 'MANUFACTURER_UPDATED', manf_updated_, attr_);
   Client_SYS.Add_To_Attr( 'VENDOR_UPDATED', vendor_updated_, attr_);
   Client_SYS.Add_To_Attr( 'PUR_PRICE_UPDATED', pur_price_updated_, attr_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
--Note: check functionality
PROCEDURE Check_Delete___ (
   remrec_ IN     equipment_object_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
   objstate_ VARCHAR2(20);   
   is_scrap_ VARCHAR2(5);
   no_of_conn_  NUMBER;
   contract_const_ VARCHAR2(5);
   mch_code_const_ VARCHAR2(100);    
BEGIN
   IF (Check_Serial_Exist(remrec_.part_no, remrec_.mch_serial_no) = 'FALSE') THEN
      RETURN;
   END IF;
   
   super(remrec_);
   key_ := remrec_.equipment_object_seq||'^';
   objstate_ := Part_Serial_Catalog_API.Get_Objstate(remrec_.part_no, remrec_.mch_serial_no);
   is_scrap_ := Equipment_Object_Api.Is_Scrapped(remrec_.contract, remrec_.mch_code);
   Equipment_Object_Conn_Api.Count_connections(no_of_conn_, contract_const_, mch_code_const_, remrec_.contract, remrec_.mch_code);
      
   IF NOT( objstate_='Unlocated' AND is_scrap_ = 'TRUE' AND no_of_conn_ > 0) THEN       
      Reference_SYS.Check_Restricted_Delete('EquipmentObject', key_);         
      IF( objstate_!= 'InInventory' AND objstate_!= 'Unlocated') THEN
         Check_Serial_Reference___(remrec_);
      END IF;
   END IF;
END Check_Delete___;

@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     equipment_object_tab%ROWTYPE )
IS
   key_            VARCHAR2(2000);
   objstate_       VARCHAR2(20);   
   is_scrap_       VARCHAR2(5);
   no_of_conn_     NUMBER;
   contract_const_ VARCHAR2(5);
   mch_code_const_ VARCHAR2(100);
   key_ref_        VARCHAR2(4000);
BEGIN
   key_      := remrec_.equipment_object_seq||'^';
   key_ref_  := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', remrec_.equipment_object_seq);
   objstate_ := Part_Serial_Catalog_API.Get_Objstate(remrec_.part_no, remrec_.mch_serial_no);
   is_scrap_ := Equipment_Object_Api.Is_Scrapped(remrec_.contract, remrec_.mch_code);
   Equipment_Object_Conn_Api.Count_connections(no_of_conn_, contract_const_, mch_code_const_, remrec_.contract, remrec_.mch_code);
   
   IF ( objstate_='Unlocated' AND is_scrap_ = 'TRUE' AND no_of_conn_ > 0) THEN       
       Equipment_Object_Conn_Api.Remove_Obj_Conn(remrec_.contract, remrec_.mch_code);
       Reference_SYS.Check_Restricted_Delete('EquipmentObject', key_);       
   END IF;
   Equipment_Object_API.Remove_Object_References(key_ref_);
   Map_Position_API.Remove_Position_For_Object('EquipmentObject', key_ref_);
   Modify_Part_Serial___(remrec_);
   super(objid_, remrec_);
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Concatenate_Object__ (
   mch_code_  IN OUT VARCHAR2,
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 )
IS
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      IF (serial_no_ IS NOT NULL) THEN
         mch_code_ := part_no_||Object_Property_API.Get_Value( 'MaintenanceConfiguration', '*', 'OBJ_LEVEL_SEPARATOR' )||serial_no_;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'SERIALNONULL: Serial No must have a value.');
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'PARTNONULL: Part No must have a value.');
   END IF;
END Concatenate_Object__;


PROCEDURE When_New_Mch__ (
   note_                  IN OUT VARCHAR2,
   contract_              IN     VARCHAR2,
   mch_code_              IN     VARCHAR2,
   sup_mch_code_          IN     VARCHAR2,
   sup_contract_          IN     VARCHAR2,
   part_no_               IN     VARCHAR2,
   serial_no_             IN     VARCHAR2,
   warr_exp_              IN     DATE,
   manufacturer_no_       IN     VARCHAR2,
   vendor_no_             IN     VARCHAR2,
   part_rev_              IN     VARCHAR2,
   operational_status_db_ IN     VARCHAR2   DEFAULT 'IN_OPERATION',
   acquisition_cost_      IN     NUMBER     DEFAULT NULL,
   installation_date_     IN     DATE       DEFAULT NULL,
   manufactured_date_     IN     DATE       DEFAULT NULL,
   purchase_date_         IN     DATE       DEFAULT NULL,
   ownership_db_          IN     VARCHAR2   DEFAULT NULL,
   owner_                 IN     VARCHAR2   DEFAULT NULL )
IS
   cmnt_                      VARCHAR2(2000);
   placed_in_obj_             VARCHAR2(100) :=NULL;
   placed_in_contract_        VARCHAR2(5) :=NULL;
   description_               VARCHAR2(200);
   alternate_id_              VARCHAR2(100) := NULL;
   latest_transaction_          part_serial_catalog.latest_transaction%TYPE;
   transaction_description_   part_serial_history.transaction_description%TYPE;
   superior_part_no_          VARCHAR2(25);
   superior_serial_no_        VARCHAR2(50);

   serial_exist_           VARCHAR2(5);
   obj_info_               VARCHAR2(200);
   owning_customer_        VARCHAR2(30);
   owning_vendor_no_       VARCHAR2(30);
   installed_date_         DATE := installation_date_;

   CURSOR part_info IS
   SELECT part_no, serial_no
   FROM EQUIPMENT_SERIAL
   WHERE mch_code = sup_mch_code_
   AND contract = sup_contract_;
BEGIN
   -- Create a new serial in Part_Serial_Catalog if not exist
   IF Part_Serial_Catalog_API.Check_Exist(part_no_, serial_no_)= 'FALSE' THEN
      $IF Component_Pm_SYS.INSTALLED $THEN
         Pm_Action_API.Set_Pm_To_Obsolete(contract_, mch_code_);
      $ELSE
         NULL;
      $END

      $IF Component_Vim_SYS.INSTALLED $THEN
         serial_exist_ := Vim_Serial_API.Serial_No_Exist( part_no_, serial_no_ );
      $ELSE
         serial_exist_ := 'FALSE';
      $END

      IF (serial_exist_ = 'FALSE') THEN
         cmnt_ := Equipment_Obj_Move_Status_API.Decode('NEW');
         latest_transaction_ := cmnt_;
         transaction_description_ := cmnt_;

         IF (ownership_db_ IN ('SUPPLIER LOANED','SUPPLIER RENTED')) THEN
            owning_vendor_no_ :=  owner_ ;
         END IF;
         IF(ownership_db_ IN ('CUSTOMER OWNED')) THEN
            owning_customer_ :=  owner_ ;
         END IF;
         IF (sup_mch_code_ IS NOT NULL) AND (Equipment_Functional_Api.Get_Obj_Level(sup_contract_, sup_mch_code_) IS NULL) THEN
            description_        := Equipment_Object_API.Get_Mch_Name(sup_contract_, sup_mch_code_ );
            obj_info_ := TO_CHAR(sup_mch_code_|| ', ' || description_ );
            latest_transaction_   := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.' ,NULL , obj_info_, sup_contract_);
            transaction_description_ :=  latest_transaction_||'('||cmnt_||')';
            OPEN Part_Info;
            FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
            Part_Serial_Catalog_API.New_In_Contained(  part_no_, serial_no_, latest_transaction_, transaction_description_, superior_part_no_,
            superior_serial_no_, part_rev_, note_, warr_exp_, vendor_no_, manufacturer_no_, operational_status_db_,
            acquisition_cost_  ,installation_date_ , manufactured_date_ , purchase_date_,  ownership_db_, owning_customer_,owning_vendor_no_ );
            CLOSE Part_Info;

            --for Functional Objects
         ELSIF (sup_mch_code_ IS NOT NULL) AND (Equipment_Functional_Api.Get_Obj_Level(sup_contract_, sup_mch_code_) IS NOT NULL) THEN
            description_        := Equipment_Object_API.Get_Mch_Name(sup_contract_, sup_mch_code_ );
            obj_info_ := TO_CHAR(sup_mch_code_|| ', ' || description_ );
            latest_transaction_   := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.' ,NULL , obj_info_, sup_contract_);
            transaction_description_ :=  latest_transaction_||'('||cmnt_||')';
            Part_Serial_Catalog_API.New_In_Facility( part_no_, serial_no_, latest_transaction_, transaction_description_, NULL, note_, warr_exp_, vendor_no_, manufacturer_no_, NULL, NULL, operational_status_db_,
            acquisition_cost_  ,installation_date_ , manufactured_date_ , purchase_date_, 'OPERATIONAL',  ownership_db_, owner_,part_rev_, owning_vendor_no_ );


         ELSE
            IF (installed_date_ IS NULL AND operational_status_db_ = 'IN_OPERATION') THEN
               installed_date_ := Maintenance_Site_Utility_API.Get_Site_Date(contract_);
            END IF;

            Part_Serial_Catalog_API.New_In_Facility( part_no_, serial_no_, latest_transaction_, transaction_description_, NULL, note_, warr_exp_, vendor_no_, manufacturer_no_, NULL, NULL, operational_status_db_,
            acquisition_cost_, installed_date_, manufactured_date_, purchase_date_, 'OPERATIONAL',  ownership_db_, owning_customer_,part_rev_ ,owning_vendor_no_);
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'VIMSEREXIST: The serial :P1 already exist as a serial object in Fleet and Asset Management.', part_no_ || ',' || serial_no_);
      END IF;
   ELSE

      IF (Part_Serial_Catalog_API.Is_Designed(part_no_, serial_no_) !='TRUE') THEN
         Equipment_Object_Util_API.Get_Object_Info(placed_in_contract_, placed_in_obj_, part_no_, serial_no_); 
         alternate_id_ := part_no_||'-'||serial_no_;
         Error_SYS.Appl_General(lu_name_, 'OBJEXIST: Part no :P1 already exist as :P2 at Site :P3 .'
         , alternate_id_, placed_in_obj_, placed_in_contract_);
      END IF;
   END IF;
END When_New_Mch__;

-- TODO: Try to replace this method with direct_move__
PROCEDURE Move__ (
   cmnt_          IN OUT VARCHAR2,
   contract_      IN     VARCHAR2,
   mch_code_      IN     VARCHAR2,
   from_mch_code_ IN     VARCHAR2,
   from_contract_ IN     VARCHAR2,
   to_mch_code_   IN     VARCHAR2,
   to_contract_   IN     VARCHAR2,
   sign_          IN     VARCHAR2 )
IS
   rcode_              VARCHAR2(5);
   ex_is_address       EXCEPTION;
   ex_has_connection   EXCEPTION;
   different_companies EXCEPTION;
   no_move_obj         EXCEPTION;
   mch_loop            EXCEPTION;
   attr_               VARCHAR2(32000);
   value_              VARCHAR2(2000);
   name_               VARCHAR2(30);
   lu_rec_             EQUIPMENT_OBJECT_TAB%ROWTYPE;
   newrec_             EQUIPMENT_OBJECT_TAB%ROWTYPE;
   oldrec_             EQUIPMENT_OBJECT_TAB%ROWTYPE;
   objversion_         VARCHAR2(2000);
   transaction_description_   VARCHAR2(2000);
   transaction_description1_  VARCHAR2(2000);
   latest_transaction_          VARCHAR2(2000);
   superior_alternate_contract_ VARCHAR2(5);
   superior_alternate_id_       VARCHAR2(100);
   operational_status_db_       VARCHAR2(20);
   superior_part_no_             VARCHAR2(25);
   superior_serial_no_           VARCHAR2(50);
   object_curr_pos_              VARCHAR2(30);
   user_                         VARCHAR2(30);
   rep_woshop_curr_pos_          VARCHAR2(30);
   cmnt1_                        VARCHAR2(2000);
   obj_note_                     EQUIPMENT_OBJECT_TAB.note%TYPE;
   indrec_        Indicator_Rec;
   functional_object_seq_   NUMBER;

   CURSOR part_info IS
      SELECT part_no, mch_serial_no
      FROM EQUIPMENT_OBJECT_TAB
      WHERE mch_code = superior_alternate_id_
      AND contract = superior_alternate_contract_;
BEGIN
   -- IF current object is an adress, move is not allowed.
   IF Equipment_Object_API.Is_Address__(contract_, mch_code_) THEN
      RAISE ex_is_address;
   END IF;
   -- IF current object has any connections, move is not allowed.
   IF Equipment_Object_Conn_API.Has_Connection(contract_, mch_code_) = 'TRUE' THEN
      RAISE ex_has_connection;
   END IF;
   -- IF contract belongs to different companies, move is not allowed
   IF Site_API.Get_Company(from_contract_) != Site_API.Get_Company(to_contract_) THEN
      RAISE different_companies;
   END IF;
   rcode_ := NULL;
   Equipment_Object_API.Check_Tree_Loop__(rcode_,  contract_, mch_code_, to_mch_code_, to_contract_);
   IF (rcode_ = 'TRUE') THEN
      RAISE mch_loop;
   END IF;
   IF NOT sign_ IS NULL THEN
      Company_Emp_API.Exist(Site_API.Get_Company(contract_),
      Company_Emp_API.Get_Max_Employee_Id (Site_API.Get_Company(contract_),sign_));
   END IF;
   
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      IF (Psc_Contr_Product_Util_API.Check_Srv_Line_Usage_All_Obj(contract_, mch_code_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJECTUSED: Object is already used in a Pm Action or Work Order.');
      END IF;
   $END

   lu_rec_ := Get_Object_By_Keys___(contract_, mch_code_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', to_mch_code_, attr_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', to_contract_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_MOVE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('MCH_LOC', Get_Mch_Loc(to_contract_, to_mch_code_), attr_);
   Client_SYS.Add_To_Attr('MCH_POS', Get_Mch_Pos(to_contract_, to_mch_code_), attr_);
   Client_SYS.Add_To_Attr('COST_CENTER', Equipment_Object_API.Get_Cost_Center(to_contract_, to_mch_code_), attr_);      

   obj_note_ := Equipment_Object_API.Get_Note(contract_,mch_code_);
   IF cmnt_ IS NOT NULL THEN
      IF obj_note_ IS NOT NULL THEN
         cmnt1_ :=  SUBSTR((Equipment_Object_API.Get_Note(contract_,mch_code_)|| chr(13)||chr(10) ||cmnt_), 1,2000);
      ELSE
         cmnt1_ :=  SUBSTR(cmnt_, 1,2000);
      END IF;
   ELSE
      cmnt1_ :=  SUBSTR((Equipment_Object_API.Get_Note(contract_,mch_code_)), 1,2000);
   END IF;
   Client_SYS.Add_To_Attr('NOTE', cmnt1_, attr_);

   oldrec_ := Lock_By_Keys___ (lu_rec_.equipment_object_seq);
   IF (oldrec_.functional_object_seq <> functional_object_seq_) THEN
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
   rep_woshop_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(lu_rec_.part_no, lu_rec_.mch_serial_no);
   IF lu_rec_.mch_serial_no IS NOT NULL THEN
      IF lu_rec_.part_no IS NOT NULL THEN
         IF to_mch_code_ IS NULL THEN
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVETOBJNULL: Moved to top level from object :P1 site :P2  by user :P3', NULL, from_mch_code_, from_contract_, sign_);
         ELSIF from_mch_code_ IS NULL THEN
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEFOBJNULL: In object :P1, Moved to object :P1 site :P2 from top level by user :P3', NULL, to_mch_code_, to_contract_, sign_);
         ELSIF (to_mch_code_ IS NOT NULL AND rep_woshop_curr_pos_ = 'InRepairWorkshop') THEN
            user_ := Fnd_Session_API.Get_Fnd_User;
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJINVTOFACT: In object :P1, Moved into object :P1 at site :P2 from repair workshop by user :P3', NULL, to_mch_code_, to_contract_, user_);
         ELSE
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJ: In object :P1, Moved to object :P1 site :P2 ', NULL, to_mch_code_, to_contract_);
            transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJ1: from object :P1 site :P2 by user :P3', NULL, from_mch_code_, from_contract_, sign_);
            transaction_description_ := transaction_description_||transaction_description1_;
         END IF;
         transaction_description_ := substr(transaction_description_||'. '||'('||cmnt_||')',1,2000);

         latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, to_mch_code_, to_contract_);
         transaction_description_ := substr(transaction_description_,1,200);

         IF (to_mch_code_ IS NULL) THEN
            superior_alternate_contract_ := NULL;
            superior_alternate_id_ := NULL;
         ELSE
            superior_alternate_contract_ := to_contract_;
            superior_alternate_id_ := to_mch_code_;
         END IF;
         object_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(lu_rec_.part_no, lu_rec_.mch_serial_no);

         IF (from_mch_code_ IS NOT NULL AND to_mch_code_ IS NOT NULL) THEN
            operational_status_db_ := Part_Serial_Catalog_API.Get_Operational_Status_Db(lu_rec_.part_no, lu_rec_.mch_serial_no);
            IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.to_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  IF (Equipment_Serial_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.from_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.from_object_seq)) = 'TRUE') THEN
                     Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                     transaction_description_, transaction_description_,operational_status_db_);
                  ELSE
                     Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                     latest_transaction_, transaction_description_,operational_status_db_);
                  END IF;
               ELSE
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, NULL,NULL, transaction_description_);
               END IF;
            ELSIF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.to_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq)) != 'TRUE') THEN
               ---Move to seral
               IF (object_curr_pos_ != 'Contained') THEN
                  IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.from_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.from_object_seq)) != 'TRUE') THEN
                     Part_Serial_Catalog_API.Move_To_Contained(lu_rec_.part_no, lu_rec_.mch_serial_no, transaction_description_, transaction_description_,operational_status_db_);
                  ELSE
                     OPEN Part_Info;
                     FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
                     Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
                     CLOSE Part_Info;
                  END IF;
               ELSE
                  OPEN Part_Info;
                  FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
                  CLOSE Part_Info;
               END IF;
            END IF;
         ELSIF (from_mch_code_ IS NULL AND to_mch_code_ IS NOT NULL) THEN
            --Individual move
            IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.to_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                  latest_transaction_, transaction_description_,operational_status_db_);
               END IF;
            ELSIF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.to_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq)) != 'TRUE') THEN
               IF (object_curr_pos_ != 'Contained') THEN
                  Part_Serial_Catalog_API.Move_To_Contained(lu_rec_.part_no, lu_rec_.mch_serial_no,
                  transaction_description_, transaction_description_,operational_status_db_);
               END IF;
            END IF;

            OPEN Part_Info;
            FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
            Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
            CLOSE Part_Info;

         ELSIF NOT (from_mch_code_ IS NULL AND to_mch_code_ IS NOT NULL) THEN
            IF (to_mch_code_ IS NOT NULL) THEN
               OPEN Part_Info;
               FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
               IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(newrec_.to_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq)) != 'TRUE') THEN
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
               END IF;
               CLOSE Part_Info;
            ELSE
               IF (from_mch_code_ IS NOT NULL) THEN
                  Part_Serial_Catalog_API.Remove_Superior_Info(lu_rec_.part_no, lu_rec_.mch_serial_no, 'InFacility', transaction_description_);
               ELSE
                  Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, latest_transaction_, transaction_description_,operational_status_db_);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   IF Equipment_Object_API.Has_Structure(contract_, mch_code_) = 'TRUE' THEN
      Equipment_Object_Util_API.Complete_Move(cmnt_, contract_, mch_code_, from_mch_code_, from_contract_, to_mch_code_, to_contract_, sign_);
   END IF;
   $IF Component_Opplan_SYS.INSTALLED $THEN
	  --TODO: Replace this method after passing sequence number as a parameter to the move__
      Object_Oper_Mode_Group_API.Remove_Inherited(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
   $END

EXCEPTION
   WHEN ex_is_address THEN
      Error_SYS.Appl_General(lu_name_, 'OBJISADDR: Object :P1 is a functional object. Move is not allowed.', mch_code_);
   WHEN ex_has_connection THEN
      Error_SYS.Appl_General(lu_name_, 'OBJHASCONN: Object :P1 has connections. Move is not allowed.', mch_code_);
   WHEN different_companies THEN
      Error_SYS.Appl_General(lu_name_, 'SITEDIFFSUPCOMP: The new Belongs To object (:P1) should be in the same Company as the old Belongs To object (:P2)', to_mch_code_||','||to_contract_, from_mch_code_||','||from_contract_);
   WHEN no_move_obj THEN
      Error_SYS.Appl_General(lu_name_, 'NOOBJMOVE: Object :P1 was not possible to move.', mch_code_);
   WHEN mch_loop THEN
      Error_SYS.Appl_General(lu_name_, 'MOVEOBJLOOP: Moving object :P1 will cause a loop in the equipment structure. Move is not allowed.', mch_code_);
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);   
END Move__;


PROCEDURE New_Object__ (
   contract_     IN OUT VARCHAR2,
   mch_code_     IN OUT VARCHAR2,
   part_no_      IN     VARCHAR2,
   serial_no_    IN     VARCHAR2,
   mch_type_     IN     VARCHAR2,
   group_id_     IN     VARCHAR2,
   type_         IN     VARCHAR2,
   sup_contract_ IN     VARCHAR2,
   sup_mch_code_ IN     VARCHAR2,
   cost_center_  IN     VARCHAR2,
   mch_loc_      IN     VARCHAR2,
   mch_pos_      IN     VARCHAR2 ,
   owner_        IN     VARCHAR2 ,
   ownership_    IN     VARCHAR2)
IS
   info_            VARCHAR2(2000);
   objid_           VARCHAR2(20);
   objversion_      VARCHAR2(2000);
   attr_            VARCHAR2(32000);
   attr2_           VARCHAR2(32000);
   party_type_      VARCHAR2(20);
   equipment_object_seq_ NUMBER;

BEGIN



   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('MCH_CODE', mch_code_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('MCH_TYPE', mch_type_ , attr_);
   Client_SYS.Add_To_Attr('GROUP_ID', group_id_ , attr_);
   Client_SYS.Add_To_Attr('TYPE', type_ , attr_);
   Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_), attr_);
   Client_SYS.Add_To_Attr('MCH_LOC', mch_loc_, attr_);
   Client_SYS.Add_To_Attr('MCH_POS', mch_pos_, attr_);
   Client_SYS.Add_To_Attr('OWNER', owner_, attr_);
   Client_SYS.Add_To_Attr('OWNERSHIP', Ownership_API.Decode(ownership_), attr_);
   IF (contract_ IS NOT NULL AND sup_contract_ IS NOT NULL AND (Site_API.Get_Company(contract_) =Site_API.Get_Company(sup_contract_))) THEN
      Client_SYS.Add_To_Attr('COST_CENTER', cost_center_, attr_);
   END IF;
   Equipment_Serial_API.New__(info_, objid_, objversion_, attr_, 'DO');
   equipment_object_seq_ := Client_SYS.Get_Item_Value('EQUIPMENT_OBJECT_SEQ', attr_);
   IF (owner_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr2_);
      Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', equipment_object_seq_,  attr2_);
      party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
      Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,  attr2_);
      Client_SYS.Add_To_Attr('IDENTITY', owner_,  attr2_);
      EQUIPMENT_OBJECT_PARTY_API.New__(info_, objid_, objversion_, attr2_, 'DO');
   END IF;
END New_Object__;

@Override
PROCEDURE Remove__(
   info_       OUT VARCHAR2,
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   action_     IN VARCHAR2)
IS
   remrec_             equipment_object_tab%ROWTYPE;
   is_in_facility_     VARCHAR2(5) := 'FALSE';
   is_contained_       VARCHAR2(5) := 'FALSE';
   is_top_in_facility_ NUMBER;

   CURSOR get_top_mch_code(mch_code_ IN VARCHAR2, contract_ IN VARCHAR2) IS
      SELECT 1
        FROM EQUIPMENT_SERIAL
       where serial_state =
             Part_Serial_Catalog_Api.Finite_State_Decode__('InFacility')
       START WITH mch_code = mch_code_
              AND contract = contract_
      CONNECT BY mch_code = PRIOR sup_mch_code;

BEGIN
   remrec_         := Get_Object_By_Id___(objid_);
   is_in_facility_ := Part_Serial_Catalog_Api.Is_In_Facility(remrec_.part_no, remrec_.mch_serial_no);
   is_contained_   := Part_Serial_Catalog_Api.Is_Contained(remrec_.part_no, remrec_.mch_serial_no);

   OPEN get_top_mch_code(remrec_.mch_code, remrec_.contract);
   FETCH get_top_mch_code
      INTO is_top_in_facility_;
   CLOSE get_top_mch_code;

   IF (action_ = 'CHECK') THEN
      IF (is_in_facility_ = 'FALSE' AND is_top_in_facility_ IS NULL) THEN
         Client_Sys.Add_Warning(lu_name_,
                                'ONLYSERIALOBJECTDELETE: Serial Object will be deleted. Part Serial will not be deleted.');
      END IF;
      super(info_, objid_, objversion_, action_);
   ELSIF (action_ = 'DO') THEN
      IF (is_in_facility_ = 'TRUE' OR
         (is_contained_ = 'TRUE' AND is_top_in_facility_ = 1)) THEN
         Part_Serial_Catalog_Api.Remove(remrec_.part_no,
                                        remrec_.mch_serial_no);
      ELSE
         super(info_, objid_, objversion_, action_);
      END IF;
   END IF;
END Remove__;

PROCEDURE Check_Delete__ (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2)
IS
   remrec_    equipment_object_tab%ROWTYPE;
   contract_  equipment_object_tab.contract%TYPE;
   mch_code_  equipment_object_tab.mch_code%TYPE;
BEGIN

   Get_Obj_Info_By_Part ( contract_, mch_code_, part_no_, serial_no_ );
   IF mch_code_ IS NOT NULL THEN
      remrec_ := Get_Object_By_Keys___(contract_, mch_code_);
      Check_Delete___(remrec_);
   END IF;

END Check_Delete__;

PROCEDURE Do_Delete__ (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2)
IS
   remrec_    equipment_object_tab%ROWTYPE;
   contract_  equipment_object_tab.contract%TYPE;
   mch_code_  equipment_object_tab.mch_code%TYPE;
BEGIN
   Get_Obj_Info_By_Part ( contract_, mch_code_, part_no_, serial_no_ );
--   IF (Do_Exist(contract_, mch_code_) = 'TRUE') THEN
   IF mch_code_ IS NOT NULL THEN
      remrec_ := Get_Object_By_Keys___(contract_, mch_code_);
      Remove___(remrec_);
   END IF;
END Do_Delete__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Accounting_Code_Part_B (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.cost_center%TYPE;
   CURSOR get_attr IS
   SELECT cost_center
   FROM EQUIPMENT_OBJECT_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Accounting_Code_Part_B;


@UncheckedAccess
FUNCTION Get_Accounting_Code_Part_E (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.object_no%TYPE;
   CURSOR get_attr IS
   SELECT object_no
   FROM EQUIPMENT_OBJECT_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Accounting_Code_Part_E;

FUNCTION Get_Operational_Condition(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_     part_serial_catalog.operational_condition_db%TYPE;  
BEGIN
   SELECT operational_condition
   INTO temp_
   FROM EQUIPMENT_SERIAL_UIV 
   WHERE contract = contract_ AND mch_code = mch_code_;   
   RETURN temp_;
END Get_Operational_Condition;

@UncheckedAccess
FUNCTION Get_Obj_Transaction (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   mch_code_detail_      VARCHAR2(500);
   obj_level_            VARCHAR2(100);
BEGIN
   mch_code_detail_:= mch_code_||', ';
   obj_level_ := Equipment_Object_API.Get_Obj_Level(contract_,mch_code_);
   IF (obj_level_ IS NULL)THEN
      mch_code_detail_:= mch_code_detail_||Get_Mch_Name (contract_,mch_code_);
   ELSE
      mch_code_detail_:= mch_code_detail_||Equipment_Functional_API.Get_Mch_Name(contract_,mch_code_);
   END IF;

   RETURN Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, mch_code_detail_, contract_);

END Get_Obj_Transaction;

@UncheckedAccess
FUNCTION Get_Obj_Transaction (
   equipment_object_seq_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Obj_Transaction(Equipment_Object_API.Get_Contract(equipment_object_seq_), Equipment_Object_API.Get_Mch_Code(equipment_object_seq_));
END Get_Obj_Transaction;

PROCEDURE Has_Document (
   rcode_       OUT VARCHAR2,
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 )
IS
BEGIN
   Equipment_Object_API.Has_Document(rcode_, contract_, mch_code_);
END Has_Document;

@UncheckedAccess
FUNCTION Get_Technical_Data (
   lu_name_  IN VARCHAR2,
   from_lu_  IN VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mch_code_key_value_ VARCHAR2(4000);
   type_key_value_     VARCHAR2(4000);
   CURSOR get_attr IS
   SELECT mch_code_key_value, type_key_value
   INTO mch_code_key_value_, type_key_value_
   FROM EQUIPMENT_SERIAL_UIV 
   WHERE contract = contract_ AND mch_code = mch_code_;   
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO mch_code_key_value_, type_key_value_;
   CLOSE get_attr;
   IF (from_lu_ = 'TRUE') THEN
      RETURN Equipment_Object_API.Has_Technical_Spec_No(lu_name_, mch_code_key_value_);
   ELSE
      RETURN Equipment_Object_API.Has_Technical_Spec_No(lu_name_, type_key_value_);
   END IF;
END Get_Technical_Data;

@UncheckedAccess
FUNCTION Get_Documents (
   lu_name_  IN VARCHAR2,
   from_lu_  IN VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mch_code_key_value_ VARCHAR2(4000);
   type_key_value_     VARCHAR2(4000);
   CURSOR get_attr IS
   SELECT mch_code_key_value, type_key_value
   INTO mch_code_key_value_, type_key_value_
   FROM EQUIPMENT_SERIAL_UIV 
   WHERE contract = contract_ AND mch_code = mch_code_;   
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO mch_code_key_value_, type_key_value_;
   CLOSE get_attr;
   IF (from_lu_ = 'TRUE' AND mch_code_key_value_ IS NOT NULL) THEN
      RETURN Maintenance_Document_Ref_API.Exist_Obj_Reference(lu_name_, mch_code_key_value_);
   ELSIF (type_key_value_ IS NOT NULL) THEN
      RETURN Maintenance_Document_Ref_API.Exist_Obj_Reference(lu_name_, type_key_value_);
   ELSE 
      RETURN('FALSE');
   END IF;
END Get_Documents;


PROCEDURE Get_Objid (
   objid_       OUT VARCHAR2,
   mch_name_    OUT VARCHAR2,
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 )
IS
BEGIN
   Equipment_Object_API.Get_Objid(objid_, mch_name_, contract_, mch_code_);
END Get_Objid;


FUNCTION Do_Exist (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Equipment_Object_API.Do_Exist(contract_, mch_code_);
END Do_Exist;


@UncheckedAccess
FUNCTION Has_Structure (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT
   WHERE  sup_contract = contract_
   AND    sup_mch_code = mch_code_;

   dummy_ NUMBER;

BEGIN
   dummy_ := 0;
   OPEN mch;
   FETCH mch INTO dummy_;
   CLOSE mch;
   IF (dummy_ = 0) THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Has_Structure;


@UncheckedAccess
FUNCTION Is_Address (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR mch IS
   SELECT 1
   FROM   equipment_object_tab
   WHERE  contract = contract_
   AND    mch_code = mch_code_
   AND    obj_level IS NOT NULL;

   dummy_ NUMBER;

BEGIN
   OPEN mch;
   FETCH mch INTO dummy_;
   IF (mch%NOTFOUND) THEN
      CLOSE mch;
      RETURN 'FALSE';
   ELSE
      CLOSE mch;
      RETURN 'TRUE';
   END IF;
END Is_Address;


@UncheckedAccess
FUNCTION Has_Warranty (
   equipment_object_seq_ IN NUMBER) RETURN VARCHAR2
IS
   temp_date_ DATE := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_));
BEGIN
   RETURN OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
END Has_Warranty;


PROCEDURE Create_Construction_Object (
   attr_ IN OUT VARCHAR2 )
IS
   info_          VARCHAR2(2000);
   objid_         ROWID;
   objversion_    VARCHAR2(2000);
   newrec_        EQUIPMENT_OBJECT_TAB%ROWTYPE;
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
   transaction_description_   VARCHAR2(2000);
   latest_transaction_ VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         newrec_.contract := value_;
      ELSIF (name_ = 'MCH_CODE') THEN
         newrec_.mch_code := value_;
      ELSIF (name_ = 'PART_NO') THEN
         newrec_.part_no := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         newrec_.mch_serial_no := value_;
      ELSIF (name_ = 'FUNCTIONAL_OBJECT_SEQ') THEN
         newrec_.functional_object_seq := value_;
      END IF;
   END LOOP;
   --  DESIGN_OBJECT is used in Unpack_Check_Insert to allow creation of objects thus they exist in part_serial_catalog
   Client_SYS.Add_To_Attr('DESIGN_OBJECT', '1', attr_);

   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVECONSTOBJ: Object moved from construction to facility by user :P1.', NULL, Fnd_Session_API.Get_Fnd_User);
   latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));

   New__ (info_, objid_, objversion_, attr_, 'DO');
   IF NOT (Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no,newrec_.mch_serial_no) = 'InFacility' OR Part_Serial_Catalog_API.Get_Objstate(newrec_.part_no,newrec_.mch_serial_no) = 'Contained') THEN
      IF (newrec_.functional_object_seq IS NULL) THEN
         Part_Serial_Catalog_API.Move_To_Facility(newrec_.part_no, newrec_.mch_serial_no, latest_transaction_, transaction_description_, 'IN_OPERATION', 'OPERATIONAL');
      ELSE
         Part_Serial_Catalog_API.Move_To_Contained(newrec_.part_no, newrec_.mch_serial_no, latest_transaction_, transaction_description_, 'IN_OPERATION', 'OPERATIONAL');
      END IF;
   END IF;
END Create_Construction_Object;


PROCEDURE Create_Maintenance_Aware (
   part_no_       IN     VARCHAR2,
   serial_no_     IN     VARCHAR2,
   contract_      IN     VARCHAR2,
   mch_code_      IN     VARCHAR2 DEFAULT NULL,
   move_facility_ IN     VARCHAR2 DEFAULT 'FALSE')
IS
   info_          VARCHAR2(2000);
   objid_         ROWID;
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
   alternate_id_  VARCHAR2(100):= NULL;
   equip_exist_   VARCHAR2(5):= 'FALSE';
   party_type_    VARCHAR2(20);
   transaction_description_  VARCHAR2(2000);
   latest_transaction_ part_serial_catalog.latest_transaction%TYPE;
   temp_contract_      equipment_object_tab.mch_code%TYPE;
   
   CURSOR get_order_number IS
      SELECT order_no, line_no, release_no, order_type
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND serial_no = serial_no_
      AND order_type IN ('CUST ORDER','PROJECT_DELIVERABLES' );
            
   order_rec_ get_order_number%ROWTYPE;
     
   CURSOR get_all_children IS
      SELECT part_no, serial_no, operational_condition, LEVEL
      FROM   PART_SERIAL_CATALOG_PUB
      WHERE  superior_part_no IS NOT NULL
      START WITH part_no   = part_no_
             AND serial_no = serial_no_
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no
      ORDER BY LEVEL DESC;

   customer_no_ EQUIPMENT_OBJECT_PARTY_TAB.identity%TYPE;
   objid2_      VARCHAR2(80);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('MCH_CODE', mch_code_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   --  DESIGN_OBJECT is used in Unpack_Check_Insert to allow creation of objects thus they exist in part_serial_catalog
   Client_SYS.Add_To_Attr('DESIGN_OBJECT', '3', attr_);
   Client_SYS.Add_To_Attr('MOVE_FAC', move_facility_, attr_);
   --
   equip_exist_ := Check_Serial_Exist(part_no_, serial_no_);
   IF equip_exist_ = 'TRUE' THEN
      Error_SYS.Appl_General(lu_name_, 'SEREXIST: The Serial No :P1 is already in use for Part No :P2.', serial_no_, part_no_);
   END IF;

   FOR next_child_ IN get_all_children LOOP
      IF next_child_.operational_condition = 'NOT_APPLICABLE' THEN
         Part_Serial_Catalog_API.Set_Operational(next_child_.part_no, next_child_.serial_no, FALSE);
      END IF;
   END LOOP;
   IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(part_no_, serial_no_) = 'NOT_APPLICABLE' THEN
      Part_Serial_Catalog_API.Set_Operational(part_no_, serial_no_, FALSE);
   END IF;

   latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTMAINTAWARE: Created with make maintenance aware');
   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'CREATEDBYMAINTAWARE: Object is created with make maintenance aware ');

   Part_Serial_Catalog_API.Modify_Latest_Transaction(part_no_, serial_no_, latest_transaction_, transaction_description_,
                             history_purpose_db_ => 'CHG_CURRENT_POSITION',
                             order_type_         => NULL,
                             order_no_           => NULL,
                             line_no_            => NULL,
                             release_no_         => NULL,
                             line_item_no_       => NULL,
                             inv_transaction_id_ => NULL);


   New__ (info_, objid_, objversion_, attr_, 'DO');

   OPEN get_order_number;
   FETCH get_order_number INTO order_rec_;
   CLOSE get_order_number;

   IF (order_rec_.order_no IS NOT NULL ) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
      IF order_rec_.order_type = 'CUST ORDER' THEN
         customer_no_ := Customer_Order_API.Get_Customer_No(order_rec_.order_no );
      END IF;
      $END
      $IF Component_Prjdel_SYS.INSTALLED $THEN
      IF (order_rec_.order_type = 'PROJECT_DELIVERABLES') THEN
         customer_no_ := Planning_Shipment_API.Get_Customer_Id(order_rec_.order_no, order_rec_.line_no, order_rec_.release_no);
      END IF;
      $END
      Equipment_Object_Util_API.Get_Object_Info(temp_contract_, alternate_id_, part_no_, serial_no_); 
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT',   contract_,     attr_);
      Client_SYS.Add_To_Attr('MCH_CODE',   alternate_id_, attr_);
      party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
      Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,    attr_);
      Client_SYS.Add_To_Attr('IDENTITY',   customer_no_,  attr_);
      Equipment_Object_Party_API.New__(info_, objid2_, objversion_, attr_, 'DO');
   END IF;
END Create_Maintenance_Aware;


PROCEDURE Create_Serial_Object (
   attr_ IN OUT VARCHAR2 )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
   newrec_       EQUIPMENT_OBJECT_TAB%ROWTYPE;
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
   transaction_description_  VARCHAR2(2000);
   latest_transaction_  VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         newrec_.contract := value_;
      ELSIF (name_ = 'MCH_CODE') THEN
         newrec_.mch_code := value_;
      ELSIF (name_ = 'PART_NO') THEN
         newrec_.part_no := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         newrec_.mch_serial_no := value_;
      ELSIF (name_ = 'FUNCTIONAL_OBJECT_SEQ') THEN
         newrec_.functional_object_seq := value_;
      END IF;
   END LOOP;

   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOTHFAC: Object moved from another facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
   latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));
   IF (newrec_.functional_object_seq IS NULL) THEN
      Part_Serial_Catalog_API.Move_To_Facility(newrec_.part_no, newrec_.mch_serial_no, latest_transaction_, transaction_description_);
   ELSE
      Part_Serial_Catalog_API.Move_To_Contained(newrec_.part_no, newrec_.mch_serial_no, latest_transaction_, transaction_description_);
   END IF;
   New__ (info_, objid_, objversion_, attr_, 'DO');
END Create_Serial_Object;


PROCEDURE Move_To_Repair (
   contract_    IN     VARCHAR2,
   mch_code_    IN     VARCHAR2,
   to_contract_ IN     VARCHAR2,
   to_mch_code_ IN     VARCHAR2,
   reported_by_ IN     VARCHAR2,
   cmnt_        IN     VARCHAR2)
IS
   ex_is_address     EXCEPTION;
   ex_diff_comp      EXCEPTION;
   attr_             VARCHAR2(32000);
   lu_rec_           EQUIPMENT_OBJECT_TAB%ROWTYPE;
   oldrec_           EQUIPMENT_OBJECT_TAB%ROWTYPE;
   newrec_           EQUIPMENT_OBJECT_TAB%ROWTYPE;
   objversion_       VARCHAR2(2000);
   transaction_description_  VARCHAR2(2000);
   latest_transaction_ VARCHAR2(2000);
   part_no_          VARCHAR2(25);
   indrec_        Indicator_Rec;
   --STRSA-5294, Start
   ex_serial_Obj      EXCEPTION;
   ex_func_Obj      EXCEPTION;
   to_mch_code_obj_level_   VARCHAR2(2000);
   mch_code_obj_level_      VARCHAR2(2000);
   --STRSA-5294, End
   cmnts_                      VARCHAR2(2000);
BEGIN

   --STRSA-5294, start
   IF ( Check_Exist(contract_,mch_code_)= 'FALSE' OR ((to_contract_ IS NOT NULL AND to_mch_code_ IS NOT NULL) 
      AND (Check_Exist(to_contract_,to_mch_code_) = 'FALSE' )))THEN
      Error_SYS.Appl_General(lu_name_, 'OBJNOEXIST: The Equipment Object does not exist.');
   END IF;
   to_mch_code_obj_level_:= Equipment_Functional_Api.Get_Obj_Level(to_contract_, to_mch_code_);
   mch_code_obj_level_ := Equipment_Functional_Api.Get_Obj_Level(contract_, mch_code_);
   IF  mch_code_ IS NOT NULL AND mch_code_obj_level_ IS  NOT NULL THEN
      RAISE ex_func_Obj;
   END IF;
   IF  to_mch_code_ IS NOT NULL AND to_mch_code_obj_level_ IS NULL THEN
      RAISE ex_serial_Obj;
   END IF;
   --STRSA-5294, end
   -- IF current object is an adress, move is not allowed.
   lu_rec_ := Get_Object_By_Keys___(contract_, mch_code_);
   IF Equipment_Object_API.Is_Address__(contract_, mch_code_) THEN
      RAISE ex_is_address;
   END IF;

   IF Site_API.Get_Company(contract_) != Site_API.Get_Company(to_contract_) THEN
      RAISE ex_diff_comp;
   END IF;

   Set_Structure_Out_Of_Operation(contract_,mch_code_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', to_contract_, attr_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', to_mch_code_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_MOVE', 'TRUE', attr_);
   oldrec_ := Lock_By_Keys___ (lu_rec_.equipment_object_seq);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);

   IF lu_rec_.mch_serial_no IS NOT NULL THEN
      part_no_ := Equipment_Serial_API.Get_Part_No(contract_, mch_code_);
      IF part_no_ IS NOT NULL THEN
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEREPAIR: Moved to repair workshop :P2', NULL, to_mch_code_);
         transaction_description_:= SUBSTR(transaction_description_||'. '||'('||cmnt_||')',1,2000);
         latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, to_mch_code_, to_contract_);
         IF to_mch_code_ IS NULL AND  to_contract_ IS NULL THEN 
            Move__(cmnts_, contract_, mch_code_, NULL, NULL, to_mch_code_, to_contract_, NULL);
            latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTXTREP: Placed in Repair Workshop.');
         END IF;
         Part_Serial_Catalog_API.Move_To_Workshop (part_no_, lu_rec_.mch_serial_no, latest_transaction_, transaction_description_);
         --pj
         Part_Serial_Catalog_API.Modify_Note_Text(part_no_, lu_rec_.mch_serial_no, reported_by_, cmnt_);

      END IF;
   END IF;

EXCEPTION
   WHEN ex_is_address THEN
      Error_SYS.Appl_General(lu_name_, 'OBJISADDR: Object :P1 is a functional object. Move is not allowed.', mch_code_);
   WHEN ex_diff_comp THEN
      Error_SYS.Appl_General(lu_name_, 'SITEDIFFCOMP: Site :P1 belongs to another company. Move is not allowed.', to_contract_);
   WHEN ex_serial_Obj THEN
      Error_SYS.Appl_General(lu_name_, 'OBJISSER: Functional Object should be defined as the Repair Workshop.');
   WHEN ex_func_Obj THEN
      Error_SYS.Appl_General(lu_name_, 'OBJISFUNC: Repair Object should be a Serial Object.');   
END Move_To_Repair;


FUNCTION Check_Exist (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  contract = contract_
      AND    mch_code = mch_code_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Exist;


FUNCTION Check_Serial_Exist (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  part_no = part_no_
      AND    mch_serial_no = serial_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Serial_Exist;


@UncheckedAccess
FUNCTION Is_Infacility (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Part_Serial_Catalog_API.Get_Objstate(part_no_, serial_no_);
   -- Added check for state_ "Contained" as in new design.
   IF (state_ = 'InFacility') OR (state_ = 'Contained') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Infacility;


@UncheckedAccess
FUNCTION Is_Scrapped (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Part_Serial_Catalog_API.Is_Scrapped (part_no_, serial_no_) = 'TRUE') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Scrapped;


@UncheckedAccess
FUNCTION Infacility_Or_Workshop (
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Part_Serial_Catalog_API.Get_Objstate(part_no_, serial_no_);
   -- Added check for state_ "Contained" as in new design.
   IF (state_ = 'InFacility') OR (state_ = 'Contained') OR (state_ = 'InRepairWorkshop') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Infacility_Or_Workshop;


PROCEDURE Create_Serial_Object_C_O (
   attr_ IN OUT VARCHAR2 )
IS
   customer_no_     EQUIPMENT_OBJECT_TAB.Owner%TYPE;
   contract_        EQUIPMENT_OBJECT_TAB.contract%TYPE;
   sup_contract_    EQUIPMENT_OBJECT_TAB.contract%TYPE;
   purch_price_     EQUIPMENT_OBJECT_TAB.purch_price%TYPE;
   purch_date_      EQUIPMENT_OBJECT_TAB.purch_date%TYPE;
   part_no_         EQUIPMENT_OBJECT_TAB.part_no%TYPE;
   serial_no_       EQUIPMENT_OBJECT_TAB.mch_serial_no%TYPE;
   warr_exp_        EQUIPMENT_OBJECT_TAB.warr_exp%TYPE;
   note_            EQUIPMENT_OBJECT_TAB.note%TYPE;
   mch_code_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   sup_mch_code_    EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   supplier_no_     EQUIPMENT_OBJECT_TAB.vendor_no%TYPE;
   cust_order_no_             VARCHAR2(12);
   cust_order_line_no_        VARCHAR2(4);
   cust_order_rel_no_         VARCHAR2(4);
   cust_order_line_item_no_   NUMBER;
   party_type_                VARCHAR2(20);
   location_id_               VARCHAR2(50);
   equipment_object_seq_      NUMBER;
   
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
   attr2_ VARCHAR2(32000);
   transaction_description_  VARCHAR2(2000);
   latest_transaction_  VARCHAR2(2000);
   purch_date_dummy_ DATE;
   attr3_   VARCHAR2(3200);
   dummy_inst_date_ DATE;
   functional_object_seq_ NUMBER;
   
   CURSOR Check_Purch_Date (part_no_   EQUIPMENT_OBJECT_TAB.part_no%TYPE,
                            serial_no_ EQUIPMENT_OBJECT_TAB.mch_serial_no%TYPE) IS
      SELECT PURCHASED_DATE,INSTALLATION_DATE
      FROM Part_Serial_Catalog_Tab
      WHERE Part_no = part_no_
      AND Serial_no = serial_no_;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PURCH_PRICE') THEN
         purch_price_:= Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PURCH_DATE') THEN
         purch_date_:= Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'SUPPLIER_NO') THEN
         supplier_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'WARRANTY_EXPIRES') THEN
         warr_exp_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'NOTE') THEN
         note_:= value_;
      ELSIF (name_ = 'MCH_CODE') THEN
         mch_code_ := value_;
      ELSIF (name_ = 'SUP_CONTRACT') THEN
         sup_contract_ := value_;
      ELSIF (name_ = 'SUP_MCH_CODE') THEN
         sup_mch_code_ := value_;
      ELSIF (name_ = 'ORDER_NO') THEN
         cust_order_no_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         cust_order_line_no_ := value_;
      ELSIF (name_ = 'REL_NO') THEN
         cust_order_rel_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         cust_order_line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'LOCATION_ID') THEN
         location_id_ := value_;
      ELSIF (name_ = 'FUNCTIONAL_OBJECT_SEQ') THEN
         functional_object_seq_ := value_;
      END IF;
   END LOOP;
   
   Client_SYS.Clear_Attr(attr2_);
   
   Client_SYS.Add_To_Attr('CONTRACT', contract_,  attr2_);
   Client_SYS.Add_To_Attr('PURCH_PRICE', purch_price_,  attr2_);
   Client_SYS.Add_To_Attr('PURCH_DATE', purch_date_,  attr2_);
   Client_SYS.Add_To_Attr('VENDOR_NO', supplier_no_,  attr2_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_,  attr2_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_,  attr2_);
   Client_SYS.Add_To_Attr('NOTE', note_,  attr2_);
   Client_SYS.Add_To_Attr('MCH_CODE', mch_code_,  attr2_);
   Client_SYS.Add_To_Attr('WARR_EXP', warr_exp_,  attr2_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', sup_contract_,  attr2_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', sup_mch_code_,  attr2_);
   Client_SYS.Add_To_Attr('DESIGN_OBJECT', '2',  attr2_);
   Client_SYS.Add_To_Attr('CO_WO', 'CO',  attr2_);
   Client_SYS.Add_To_Attr('LOCATION_ID', location_id_,  attr2_);
   Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', functional_object_seq_,  attr2_);
   
   New__ (info_, objid_, objversion_, attr2_, 'DO');
   
   Client_SYS.Clear_Attr(attr3_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', note_,  attr3_);
   
   -- Dimalk, Call 101004 - Start
   /* This block of code can be removed if the PURCHASED_DATE and the ACQUISITION_COST
   ** updation problem in Part Serial Catalog is fixed from the Distribution side.
   */
   OPEN Check_Purch_Date(part_no_, serial_no_);
   FETCH Check_Purch_Date INTO purch_date_dummy_,dummy_inst_date_ ;
   CLOSE Check_Purch_Date;
   IF (dummy_inst_date_ IS NULL AND purch_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INSTALLATION_DATE', purch_date_,  attr3_);
   END IF;
   
   IF ((sup_contract_ IS NOT NULL) AND (sup_mch_code_ IS NOT NULL)) THEN
      Client_SYS.Add_To_Attr('SUPERIOR_PART_NO', Equipment_Serial_API.Get_Part_No(sup_contract_,sup_mch_code_),  attr3_);
      Client_SYS.Add_To_Attr('SUPERIOR_SERIAL_NO', Equipment_Serial_API.Get_Serial_No(sup_contract_,sup_mch_code_),  attr3_);
   END IF;
   
   Part_Serial_Catalog_API.Modify(attr3_, part_no_, serial_no_);
   -- Move serial from inventory to facility
   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVETOFAC: Object moved from inventory to facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
   IF sup_mch_code_ IS NOT NULL THEN
      latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, sup_mch_code_, sup_contract_);
   ELSE
      latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, mch_code_, contract_);
   END IF;
   transaction_description_ := transaction_description_||' ' || latest_transaction_;
   IF (sup_mch_code_ IS NOT NULL) AND (Equipment_Functional_API.Get_Obj_Level(sup_contract_, sup_mch_code_) IS NULL) THEN
      Part_Serial_Catalog_API.Move_To_Contained (part_no_, serial_no_, latest_transaction_, transaction_description_,'IN_OPERATION','OPERATIONAL');
   ELSE
      Part_Serial_Catalog_API.Move_To_Facility (part_no_, serial_no_, latest_transaction_, transaction_description_,'IN_OPERATION','OPERATIONAL');
   END IF;
   
   -- Set serial object status to InActivate
   -- Inactivate__ (info_, objid_ , objversion_, attr_ ,'DO' );
   -- Insert mch_code in the WOs created from CO lines and create new party for the object.
   IF ((cust_order_no_ IS NOT NULL) AND (cust_order_line_no_ IS NOT NULL) AND
       (cust_order_rel_no_ IS NOT NULL) AND (cust_order_line_item_no_ IS NOT NULL)) THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         Active_Separate_API.Insert_Obj_To_Wo_From_Co_line(cust_order_no_,
                                                           cust_order_line_no_,
                                                           cust_order_rel_no_,
                                                           cust_order_line_item_no_,
                                                           mch_code_,
                                                           contract_);
      $ELSE
         NULL;
      $END
      $IF Component_Order_SYS.INSTALLED $THEN
         customer_no_ := Customer_Order_API.Get_Customer_No(cust_order_no_);
      $ELSE
         NULL;
      $END
      IF (customer_no_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(attr2_);
         equipment_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
         Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', equipment_object_seq_,  attr2_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_,  attr2_);
         Client_SYS.Add_To_Attr('MCH_CODE', mch_code_,  attr2_);
         party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
         Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,  attr2_);
         Client_SYS.Add_To_Attr('IDENTITY', customer_no_,  attr2_);
         Equipment_Object_Party_API.New__(info_, objid_, objversion_, attr2_, 'DO');
      END IF;
   END IF;
   
END Create_Serial_Object_C_O;


PROCEDURE Create_Object (
   attr_ IN OUT VARCHAR2 )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
BEGIN
   New__ (info_, objid_, objversion_, attr_, 'DO');
END Create_Object;


PROCEDURE Handle_Part_Desc_Change (
   part_no_ IN     VARCHAR2)
IS
   key_ref_ VARCHAR2(500);

   CURSOR all_objects IS
      SELECT equipment_object_seq
      FROM EQUIPMENT_OBJECT_TAB
      WHERE Part_no = part_no_;
BEGIN
   FOR objects IN all_objects LOOP
      key_ref_ := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', objects.equipment_object_seq);
      IF Maintenance_Document_Ref_API.Exist_Obj_Reference('EquipmentObject', key_ref_) = 'TRUE' THEN
         Maintenance_Document_Ref_API.Refresh_Obj_Reference_Desc('EquipmentObject',key_ref_);
      END IF;
   END LOOP;

   Update_Object_Desc___(part_no_);

END Handle_Part_Desc_Change;

PROCEDURE Check_Move (
   to_contract_   IN     VARCHAR2,
   to_mch_code_   IN     VARCHAR2,
   from_mch_code_ IN     VARCHAR2,
   from_contract_ IN     VARCHAR2,
   contract_      IN     VARCHAR2,
   mch_code_      IN     VARCHAR2,
   sign_          IN     VARCHAR2,
   dest_contract_ IN     VARCHAR2 DEFAULT NULL,
   to_company_  IN     VARCHAR2 DEFAULT NULL )
IS
   sup_part_no_        EQUIPMENT_SERIAL.part_no%TYPE;
   sup_serial_no_      EQUIPMENT_SERIAL.serial_no%TYPE;    
BEGIN
   IF contract_ = dest_contract_ THEN 
      Error_SYS.Appl_General(lu_name_, 'SAMESITE: New Site cannot be same as the current site.'); 
   END IF;
   
   IF (Check_Obj_Tool_Equip_Conn(contract_,mch_code_) = 'TRUE') THEN 
      IF (Check_Obj_Tool_Equip_Conn(to_contract_,to_mch_code_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'CONNEXIST: Cannot set a Tool/Equipment connected Serial Object as Object ID.'); 
      END IF;
      IF (Check_Parent_Tool_Equip_Conn(to_contract_,to_mch_code_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'PARENTCONNEXIST: Cannot set child Serial objects of Tool/Equipment connected Serial Object as Object ID.');
      END IF;
   END IF;
   
   -- Does Site exist
   IF to_contract_ IS NOT NULL THEN 
      Site_API.Exist(to_contract_);
   END IF;
   IF dest_contract_ IS NOT NULL THEN 
      Site_API.Exist(dest_contract_);
   END IF;

   -- IF contract belongs to different companies, move is not allowed
--   IF Site_API.Get_Company(from_contract_) != Site_API.Get_Company(to_contract_) THEN
--      Error_SYS.Appl_General(lu_name_, 'SITEDIFFSUPCOMP: The new Belongs To object (:P1) should be in the same Company as the old Belongs To object (:P2)', to_mch_code_||','||to_contract_, from_mch_code_||','||from_contract_);
--   END IF;

   -- Does parent object exist
   IF (to_mch_code_ IS NOT NULL AND check_Exist(to_contract_, to_mch_code_) != 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'OBJNOTINCONTRACT: Object :P1 does not exist in Site :P2. Move is not allowed.', to_mch_code_, to_contract_);
   END IF;

   -- IF Parent object is in inventory, Move is not allowed
   sup_part_no_ := Equipment_Serial_API.Get_Part_No(to_contract_, to_mch_code_);
   sup_serial_no_ := Equipment_Serial_API.Get_Serial_No(to_contract_, to_mch_code_);
   IF (Part_Serial_Catalog_API.Is_In_Inventory(sup_part_no_, sup_serial_no_) = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'PARENTCURRENT: Object with a current position "In Inventory" cannot be added as a parent object.');
   END IF;

   -- IF Employee not exist, move is not allowed
   
   
   IF (sign_ IS NOT NULL) THEN
      Company_Emp_API.Exist(Site_API.Get_Company(to_contract_), Company_Emp_API.Get_Max_Employee_Id (Site_API.Get_Company(to_contract_),sign_));
   END IF;
END Check_Move;

-- Set_Planned_For_Operation
--   Set the operational_status for a serial to 'Planned for Operation'.
PROCEDURE Set_Planned_For_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Planned_For_Operation (part_no_, serial_no_, FALSE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Planned_For_Operation;


-- Set_In_Operation
--   Set the operational_status for a serial to 'In Operation'.
PROCEDURE Set_In_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'TRUE') AND ( (Part_Serial_Catalog_API.Is_Contained(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Facility(part_no_, serial_no_) = 'TRUE'))  THEN
         Part_Serial_Catalog_API.Set_In_Operation(part_no_, serial_no_, FALSE);
      END IF;
   ELSE
      CLOSE part_info;
   END IF;
END Set_In_Operation;


-- Set_Out_Of_Operation
--   Set the operational_status for a serial to 'Out of Operation'.
PROCEDURE Set_Out_Of_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Out_Of_Operation(part_no_, serial_no_, FALSE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Out_Of_Operation;


-- Set_Scrapped
--   Set the operational_status for a serial to 'Scrapped'.
PROCEDURE Set_Scrapped (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;

   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'FALSE') AND ( (Part_Serial_Catalog_API.Is_Contained(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Facility(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Repair_Workshop(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Inventory(part_no_, serial_no_) = 'TRUE') )  THEN
         Part_Serial_Catalog_API.Set_Scrapped(part_no_, serial_no_, FALSE);
      END IF;
   ELSE
      CLOSE part_info;
   END IF;
   --Setting All PMs, connected with the object to the State Obsolete...
$IF Component_Pm_SYS.INSTALLED $THEN
   Pm_Action_API.Set_Pm_To_Obsolete(contract_, mch_code_);
$ELSE
   NULL;
$END

END Set_Scrapped;


-- Set_Structure_Planned_For_Op
--   Set the operational_status for a serial to 'Planned for Operation'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_Planned_For_Op (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Planned_For_Operation (part_no_, serial_no_, TRUE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Structure_Planned_For_Op;


-- Set_Structure_In_Operation
--   Set the operational_status for a serial to 'In Operation'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_In_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS

   CURSOR get_all_children IS
      SELECT part_no, serial_no, mch_code, contract
      FROM   EQUIPMENT_SERIAL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = sup_contract
             AND PRIOR mch_code = sup_mch_code;

BEGIN
   FOR next_child_ IN get_all_children LOOP
      IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(next_child_.part_no, next_child_.serial_no) = 'OPERATIONAL' AND Equipment_Object_API.Exist_Non_Operational_Parent(next_child_.contract, next_child_.mch_code) = 'FALSE' THEN
         Part_Serial_Catalog_API.Set_In_Operation(next_child_.part_no, next_child_.serial_no, FALSE);
      END IF;
   END LOOP;
END Set_Structure_In_Operation;


-- Set_Structure_Out_Of_Operation
--   Set the operational_status for a serial to 'Out of Operation'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_Out_Of_Operation (
   equipment_object_seq_ IN NUMBER )
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE equipment_object_seq = equipment_object_seq_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Out_Of_Operation(part_no_, serial_no_, TRUE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Structure_Out_Of_Operation;

PROCEDURE Set_Structure_Out_Of_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
BEGIN
   Set_Structure_Out_Of_Operation(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Set_Structure_Out_Of_Operation;

-- Set_Structure_Scrapped
--   Set the operational_status for a serial to 'Scrapped'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_Scrapped (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_       EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_     EQUIPMENT_SERIAL.serial_no%TYPE;

   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;

   CURSOR get_structure IS
      SELECT contract, mch_code
      FROM   EQUIPMENT_SERIAL
      WHERE  sup_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = sup_contract
             AND PRIOR mch_code = sup_mch_code;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      BEGIN
         -- Equipment_Object_Util_API.Set_Struct_Scrappable_Block => Set the package variable to allow scrapping a structure.
         Equipment_Object_Util_API.Set_Struct_Scrappable_Block(FALSE);
         Part_Serial_Catalog_API.Set_Scrapped(part_no_, serial_no_, TRUE);
         Equipment_Object_Util_API.Set_Struct_Scrappable_Block(TRUE);
      EXCEPTION
         WHEN OTHERS THEN
            Equipment_Object_Util_API.Set_Struct_Scrappable_Block(TRUE);
            RAISE;
      END;
   ELSE
      CLOSE part_info;
   END IF;
   
   --Setting All The PMs, connected with the Objects in the structure to Obsolete...
$IF Component_Pm_SYS.INSTALLED $THEN
   FOR x IN get_structure LOOP
      Pm_Action_API.Set_Pm_To_Obsolete(x.contract, x.mch_code);
   END LOOP;
$ELSE
   NULL;
$END

END Set_Structure_Scrapped;


-- Activate_Planned_For_Operation
--   Return the string value 'TRUE' if transition to operational status
--   'Planned for Operation' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Planned_For_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN 'FALSE';
END Activate_Planned_For_Operation;


-- Activate_In_Operation
--   Return the string value 'TRUE' if transition to operational status
--   'In Operation' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_In_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'TRUE') AND ( (Part_Serial_Catalog_API.Is_Contained(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Facility(part_no_, serial_no_) = 'TRUE'))  THEN
      IF (Part_Serial_Catalog_API.Is_Planned_For_Operation(part_no_, serial_no_) = 'TRUE' OR Part_Serial_Catalog_API.Is_Out_Of_Operation(part_no_, serial_no_) = 'TRUE') THEN
         CLOSE part_info;
         RETURN 'TRUE';
      ELSE
         CLOSE part_info;
         RETURN 'FALSE';
      END IF;
   ELSE
      CLOSE part_info;
      RETURN 'FALSE';
   END IF;
END Activate_In_Operation;


-- Activate_Out_Of_Operation
--   Return the string value 'TRUE' if transition to operational status
--   'Out of Operation' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Out_Of_Operation (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (Part_Serial_Catalog_API.Is_In_Operation(part_no_, serial_no_) = 'TRUE' OR Part_Serial_Catalog_API.Is_Scrapped(part_no_, serial_no_) = 'TRUE') THEN
      CLOSE part_info;
      RETURN 'TRUE';
   ELSE
      CLOSE part_info;
      RETURN 'FALSE';
   END IF;
END Activate_Out_Of_Operation;


-- Activate_Scrapped
--   Return the string value 'TRUE' if transition to operational status
--   'Scrapped' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Scrapped (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'FALSE') AND ( (Part_Serial_Catalog_API.Is_Contained(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Facility(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Repair_Workshop(part_no_, serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Inventory(part_no_, serial_no_) = 'TRUE') )  THEN
      IF (Part_Serial_Catalog_API.Is_Out_Of_Operation(part_no_, serial_no_) = 'TRUE') THEN
         CLOSE part_info;
         RETURN 'TRUE';
      ELSE
         CLOSE part_info;
         RETURN 'FALSE';
      END IF;
   ELSE
      CLOSE part_info;
      RETURN 'FALSE';
   END IF;
END Activate_Scrapped;


-- Set_Operational
--   Set operational_condition to 'Operational'
PROCEDURE Set_Operational (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_                EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_              EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN

   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'FALSE') AND (Part_Serial_Catalog_API.Is_Scrapped(part_no_, serial_no_) = 'FALSE')  THEN
         Part_Serial_Catalog_API.Set_Operational(part_no_, serial_no_, FALSE);
      END IF;
   ELSE
      CLOSE part_info;
   END IF;
END Set_Operational;


-- Set_Non_Operational
--   Set operational condition to 'Non Operational'
PROCEDURE Set_Non_Operational (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_                EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_              EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN

   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'TRUE') AND (Part_Serial_Catalog_API.Is_In_Operation(part_no_, serial_no_) = 'FALSE')  THEN
         Part_Serial_Catalog_API.Set_Non_Operational(part_no_, serial_no_, FALSE);
      END IF;
   ELSE
      CLOSE part_info;
   END IF;
END Set_Non_Operational;


-- Set_Structure_Operational
--   Set operational_condition to 'Operational'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_Operational(
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN

   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Operational(part_no_, serial_no_, TRUE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Structure_Operational;


-- Set_Structure_Non_Operational
--   Set operational condition to 'Non Operational'
--   All the children of the serial will also be updated.
PROCEDURE Set_Structure_Non_Operational(
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2)
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN

   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (part_info%FOUND) THEN
      CLOSE part_info;
      Part_Serial_Catalog_API.Set_Non_Operational(part_no_, serial_no_, TRUE);
   ELSE
      CLOSE part_info;
   END IF;
END Set_Structure_Non_Operational;


-- Activate_Set_Operational
--   Return the string value 'TRUE' if operational condition for the specified
--   serial part = 'Non Operational'and operational status 'Not Scrapped',
--   if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Set_Operational (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'FALSE') AND (Part_Serial_Catalog_API.Is_Scrapped(part_no_, serial_no_) = 'FALSE')  THEN
      CLOSE part_info;
      RETURN 'TRUE';
   ELSE
      CLOSE part_info;
      RETURN 'FALSE';
   END IF;
END Activate_Set_Operational;


-- Activate_Set_Non_Operational
--   Return the string value 'TRUE' if operational condition for the specified
--   serial part = 'Operational' and operational status is not "In Operation',
--   if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Set_Non_Operational (
   contract_ IN     VARCHAR2,
   mch_code_ IN     VARCHAR2) RETURN VARCHAR2
IS
   part_no_    EQUIPMENT_SERIAL.part_no%TYPE;
   serial_no_  EQUIPMENT_SERIAL.serial_no%TYPE;
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_SERIAL
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;
   IF (Part_Serial_Catalog_API.Is_Operational(part_no_, serial_no_) = 'TRUE') AND (Part_Serial_Catalog_API.Is_In_Operation(part_no_, serial_no_) = 'FALSE')  THEN
      CLOSE part_info;
      RETURN 'TRUE';
   ELSE
      CLOSE part_info;
      RETURN 'FALSE';
   END IF;
END Activate_Set_Non_Operational;


PROCEDURE Concatenate_Object (
   mch_code_  IN OUT VARCHAR2,
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 )
IS
BEGIN
   Concatenate_Object__(mch_code_, part_no_, serial_no_);
END Concatenate_Object;


PROCEDURE Get_Obj_Info_By_Part (
   contract_  IN OUT VARCHAR2,
   mch_code_  IN OUT VARCHAR2,
   part_no_   IN     VARCHAR2,
   serial_no_ IN     VARCHAR2 )
IS
   CURSOR get_info IS
      SELECT contract, mch_code
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  part_no       = part_no_
      AND    mch_serial_no = serial_no_;

   contract_temp_    EQUIPMENT_OBJECT_TAB.contract%TYPE;
   mch_code_temp_    EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
BEGIN

   OPEN  get_info;
   FETCH get_info INTO contract_temp_, mch_code_temp_;
   CLOSE get_info;

   contract_ := contract_temp_;
   mch_code_ := mch_code_temp_;
END Get_Obj_Info_By_Part;


PROCEDURE Move_To_Inventory(
   wo_no_           OUT NUMBER,
   mch_code_     IN     VARCHAR2,
   mch_contract_ IN     VARCHAR2,
   wo_contract_  IN     VARCHAR2,
   wo_maint_org_ IN     VARCHAR2,
   wo_directive_ IN     VARCHAR2)

IS
   $IF Component_Wo_SYS.INSTALLED $THEN
      task_seq_               Jt_Task_Tab.task_seq%TYPE;
      jt_task_return_rec_     jt_task_return_tab%ROWTYPE;
   $END
   equip_rec_              Equipment_Object_API.Public_Rec;
   part_no_                VARCHAR2(25);
   attr_                   VARCHAR2(32000);   
   sup_mch_code_           VARCHAR2(400);
   sup_contract_           VARCHAR2(400);
   serial_no_              VARCHAR2(200);
   part_exist_             VARCHAR2(10);
   functional_object_seq_  NUMBER;
BEGIN
   
$IF Component_Wo_SYS.INSTALLED $THEN
   part_no_                := equipment_serial_api.get_part_no(mch_contract_,mch_code_);
   functional_object_seq_  := Get_Functional_Object_Seq(Equipment_Object_API.Get_Equipment_Object_Seq(mch_contract_, mch_code_));
   
   sup_mch_code_ := Equipment_Object_API.Get_Mch_Code(functional_object_seq_);
   sup_contract_ := Equipment_Object_API.Get_Contract(functional_object_seq_);
   serial_no_    := Get_Serial_No(mch_contract_,mch_code_);

   part_exist_ := 'FALSE';
$IF (Component_Invent_SYS.INSTALLED) $THEN
   IF Inventory_Part_API.Part_Exist(wo_contract_, part_no_) = 1 THEN
      part_exist_ := 'TRUE';
   END IF;
$END
   IF part_exist_ = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'EQPALOBJINVPARTEXIST: Inventory Part :P1 does not exist in Site :P2', part_no_, wo_contract_);
   END IF;
      
   Client_SYS.Add_To_Attr('MCH_CODE',              sup_mch_code_,                                                 attr_);
   Client_SYS.Add_To_Attr('MCH_CODE_CONTRACT',     sup_contract_,                                                 attr_);
   Client_SYS.Add_To_Attr('CONTRACT',              wo_contract_,                                                  attr_);
   Client_SYS.Add_To_Attr('REG_DATE',              sysdate,                                                       attr_);
   Client_SYS.Add_To_Attr('ORG_CODE',              wo_maint_org_,                                                 attr_);
   Client_SYS.Add_To_Attr('ERR_DESCR',             wo_directive_,                                                 attr_);
   Client_SYS.Add_To_Attr('REPORTED_BY',           Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User), attr_);
   Client_SYS.Add_To_Attr('MOVE_TO_INVENTORY',     'TRUE',                                                        attr_);

   ACTIVE_SEPARATE_API.New(attr_);
   wo_no_ := Client_SYS.Get_Item_Value('WO_NO',attr_);

   equip_rec_ := Equipment_Object_API.Get(sup_contract_, sup_mch_code_);
   
   Jt_Task_API.New_Task(task_seq_                => task_seq_, 
                        description_             => wo_directive_, 
                        long_description_        => null, 
                        planned_start_           => null, 
                        planned_finish_          => null, 
                        duration_                => null, 
                        wo_no_                   => wo_no_, 
                        site_                    => wo_contract_, 
                        organization_site_       => wo_contract_, 
                        organization_id_         => wo_maint_org_, 
                        source_connection_lu_name_db_  => null, 
                        source_connection_rowkey_      => null, 
                        reported_connection_type_db_   => Maint_Connection_Type_API.DB_EQUIPMENT, 
                        reported_obj_conn_lu_name_db_  => Jt_Connected_Object_API.DB_EQUIPMENT_OBJECT, 
                        reported_obj_conn_rowkey_      => equip_rec_.rowkey, 
                        actual_connection_type_db_     => Maint_Connection_Type_API.DB_EQUIPMENT, 
                        actual_obj_conn_lu_name_db_    => Jt_Connected_Object_API.DB_EQUIPMENT_OBJECT, 
                        actual_obj_conn_rowkey_        => equip_rec_.rowkey);
   
   jt_task_return_rec_.task_seq := task_seq_;   
   jt_task_return_rec_.part_no := part_no_;   
   jt_task_return_rec_.qty_to_return := 1;   
   jt_task_return_rec_.site := wo_contract_;   
   IF part_catalog_api.Get_Serial_Tracking_Code_Db(part_no_) = 'SERIAL TRACKING' THEN
      jt_task_return_rec_.serial_no := serial_no_;      
   END IF;

   JT_TASK_RETURN_API.New(jt_task_return_rec_);
$ELSE
   Error_SYS.Appl_General(lu_name_, 'WONOTINST: Function not possible as Work Order not is installed.');
$END

END Move_To_Inventory;

PROCEDURE Update_Availabilities (
           newrec_     IN EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
BEGIN
$IF Component_Svcsch_SYS.INSTALLED $THEN
      --set availability
      Svcsch_Object_Availability_API.Update_Obj_Availability(newrec_.equipment_object_seq, newrec_.functional_object_seq);
      --set preference
      Svcsch_Object_Preference_API.Update_Obj_Preferences(newrec_.equipment_object_seq, newrec_.functional_object_seq);
$ELSE
   NULL;
$END
END Update_Availabilities;

PROCEDURE Spread_Safe_Access_code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   safe_access_  IN VARCHAR2)
IS
   attr_             VARCHAR2(2000);
   objid_            ROWID;
   objversion_       VARCHAR2(2000);
   oldrec_           EQUIPMENT_OBJECT_TAB%ROWTYPE;
   newrec_           EQUIPMENT_OBJECT_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, mch_code_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.safe_access_code := safe_access_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Spread_Safe_Access_code;

@UncheckedAccess
FUNCTION Get_Owner_Name (
   identity_ IN VARCHAR2,
   type_     IN VARCHAR2 ) RETURN VARCHAR2
IS
  name_     VARCHAR2(100);
BEGIN
   IF type_ =  Ownership_API.Decode('CUSTOMER OWNED') THEN
       name_ := Customer_Info_API.Get_Name(identity_);
   ELSIF type_ = Ownership_API.Decode('SUPPLIER LOANED') OR type_ = Ownership_API.Decode('SUPPLIER RENTED') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
       name_ := Supplier_API.Get_Vendor_Name(identity_);
      $ELSE
         NULL;
      $END
   END IF;
   
   RETURN name_;
END Get_Owner_Name;

@UncheckedAccess
FUNCTION Check_Obj_Tool_Equip_Conn(
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2) RETURN VARCHAR2
IS      
   has_connection_   VARCHAR2(5);
BEGIN
   -- check if object has a tool/equipment connection
   has_connection_ := Resource_Tool_Equip_API.Has_Equipment(contract_, mch_code_);
   IF has_connection_ = 'TRUE' THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Obj_Tool_Equip_Conn;

@UncheckedAccess
FUNCTION Check_Parent_Tool_Equip_Conn(
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR check_object_parent IS
   SELECT 1
   FROM   equipment_object p
   WHERE  EXISTS (SELECT 1
           FROM   resource_tool_equip r
           WHERE  p.mch_code = r.mch_code
           AND    p.contract = r.mch_code_contract)
   CONNECT BY p.mch_code = PRIOR p.sup_mch_code
       AND    p.contract = PRIOR p.sup_contract
   START  WITH p.mch_code = mch_code_
       AND    p.contract  = contract_;
       
   dummy_            NUMBER;
BEGIN
   -- check if parent objects are connected to tool/equipment
   OPEN check_object_parent;
   FETCH check_object_parent INTO dummy_;
   IF (check_object_parent%FOUND) THEN 
      CLOSE check_object_parent;
      RETURN 'TRUE';
   ELSE
      CLOSE check_object_parent;
      RETURN 'FALSE';
   END IF;
END Check_Parent_Tool_Equip_Conn;

-- Start: Methods to facilitate the references using CONTRACT, MCH_CODE business key

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'CONTRACT', contract_);
   Message_SYS.Add_Attribute(msg_, 'MCH_CODE', mch_code_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'CONTRACT', Fnd_Session_API.Get_Language) || ': ' || contract_ || ', ' ||
                                    Language_SYS.Translate_Item_Prompt_(lu_name_, 'MCH_CODE', Fnd_Session_API.Get_Language) || ': ' || mch_code_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, mch_code_),
                            Formatted_Key___(contract_, mch_code_));
   Error_SYS.Fnd_Too_Many_Rows(Equipment_Serial_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, mch_code_),
                            Formatted_Key___(contract_, mch_code_));
   Error_SYS.Fnd_Record_Not_Exist(Equipment_Serial_API.lu_name_);
END Raise_Record_Not_Exist___;

-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, mch_code_),
                            Formatted_Key___(contract_, mch_code_));
   Error_SYS.Fnd_Record_Locked(Equipment_Serial_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, mch_code_),
                            Formatted_Key___(contract_, mch_code_));
   Error_SYS.Fnd_Record_Removed(Equipment_Serial_API.lu_name_);
END Raise_Record_Removed___;


-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab%ROWTYPE
IS
BEGIN
   RETURN Get_Object_By_Keys___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Check_Exist___;

-- Get_Version_By_Keys___
--    Fetched the objversion for a database row based on the primary key.
PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Id_Version_By_Keys___;

-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Exists;

-- Get_Mch_Name
--   Fetches the MchName attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Name (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Name(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Name;


-- Get_Mch_Loc
--   Fetches the MchLoc attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Loc (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Loc(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Loc;


-- Get_Mch_Pos
--   Fetches the MchPos attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Pos (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Pos(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Pos;


-- Get_Equipment_Main_Position
--   Fetches the EquipmentMainPosition attribute for a record.
@UncheckedAccess
FUNCTION Get_Equipment_Main_Position (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Equipment_Main_Position(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Equipment_Main_Position;


-- Get_Equipment_Main_Position_Db
--   Fetches the DB value of EquipmentMainPosition attribute for a record.
@UncheckedAccess
FUNCTION Get_Equipment_Main_Position_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab.main_pos%TYPE
IS
BEGIN
   RETURN Get_Equipment_Main_Position_Db(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Equipment_Main_Position_Db;


-- Get_Group_Id
--   Fetches the GroupId attribute for a record.
@UncheckedAccess
FUNCTION Get_Group_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Group_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Group_Id;


-- Get_Mch_Type
--   Fetches the MchType attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Type (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Type(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Type;


-- Get_Cost_Center
--   Fetches the CostCenter attribute for a record.
@UncheckedAccess
FUNCTION Get_Cost_Center (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Cost_Center(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Cost_Center;


-- Get_Object_No
--   Fetches the ObjectNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Object_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Object_No(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Object_No;


-- Get_Category_Id
--   Fetches the CategoryId attribute for a record.
@UncheckedAccess
FUNCTION Get_Category_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Category_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Category_Id;


-- Get_Sup_Mch_Code
--   Fetches the SupMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Sup_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sup_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Sup_Mch_Code;


-- Get_Serial_No
--   Fetches the SerialNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Serial_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Serial_No(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Serial_No;


-- Get_Type
--   Fetches the Type attribute for a record.
@UncheckedAccess
FUNCTION Get_Type (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Type(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Type;


-- Get_Sup_Contract
--   Fetches the SupContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Sup_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sup_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Sup_Contract;


-- Get_Part_No
--   Fetches the PartNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Part_No(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Part_No;


-- Get_Is_Category_Object
--   Fetches the IsCategoryObject attribute for a record.
@UncheckedAccess
FUNCTION Get_Is_Category_Object (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Is_Category_Object(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Is_Category_Object;


-- Get_Is_Geographic_Object
--   Fetches the IsGeographicObject attribute for a record.
@UncheckedAccess
FUNCTION Get_Is_Geographic_Object (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Is_Geographic_Object(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Is_Geographic_Object;


-- Get_Location_Mch_Code
--   Fetches the LocationMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Mch_Code;


-- Get_Location_Contract
--   Fetches the LocationContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Contract;


-- Get_From_Mch_Code
--   Fetches the FromMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_From_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_From_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_From_Mch_Code;


-- Get_From_Contract
--   Fetches the FromContract attribute for a record.
@UncheckedAccess
FUNCTION Get_From_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_From_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_From_Contract;


-- Get_To_Mch_Code
--   Fetches the ToMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_To_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_To_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_To_Mch_Code;


-- Get_To_Contract
--   Fetches the ToContract attribute for a record.
@UncheckedAccess
FUNCTION Get_To_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_To_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_To_Contract;


-- Get_Process_Mch_Code
--   Fetches the ProcessMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Mch_Code;


-- Get_Process_Contract
--   Fetches the ProcessContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Contract;


-- Get_Pipe_Mch_Code
--   Fetches the PipeMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Pipe_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pipe_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pipe_Mch_Code;


-- Get_Pipe_Contract
--   Fetches the PipeContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Pipe_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pipe_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pipe_Contract;


-- Get_Circuit_Mch_Code
--   Fetches the CircuitMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Circuit_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Circuit_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Circuit_Mch_Code;


-- Get_Circuit_Contract
--   Fetches the CircuitContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Circuit_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Circuit_Contract(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Circuit_Contract;


-- Get_Criticality
--   Fetches the Criticality attribute for a record.
@UncheckedAccess
FUNCTION Get_Criticality (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Criticality(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Criticality;


-- Get_Item_Class_Id
--   Fetches the ItemClassId attribute for a record.
@UncheckedAccess
FUNCTION Get_Item_Class_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Item_Class_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Item_Class_Id;


-- Get_Location_Id
--   Fetches the LocationId attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Id;


-- Get_Applied_Pm_Program_Id
--   Fetches the AppliedPmProgramId attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Pm_Program_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Applied_Pm_Program_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Pm_Program_Id;


-- Get_Applied_Pm_Program_Rev
--   Fetches the AppliedPmProgramRev attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Pm_Program_Rev (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Applied_Pm_Program_Rev(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Pm_Program_Rev;


-- Get_Applied_Date
--   Fetches the AppliedDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Date (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Applied_Date(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Date;


-- Get_Pm_Prog_Application_Status
--   Fetches the PmProgApplicationStatus attribute for a record.
@UncheckedAccess
FUNCTION Get_Pm_Prog_Application_Status (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pm_Prog_Application_Status(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pm_Prog_Application_Status;


-- Get_Not_Applicable_Reason
--   Fetches the NotApplicableReason attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Reason (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Not_Applicable_Reason(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Reason;


-- Get_Not_Applicable_Set_User
--   Fetches the NotApplicableSetUser attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Set_User (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Not_Applicable_Set_User(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Set_User;


-- Get_Not_Applicable_Set_Date
--   Fetches the NotApplicableSetDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Set_Date (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Not_Applicable_Set_Date(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Set_Date;


-- Get_Safe_Access_Code
--   Fetches the SafeAccessCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Safe_Access_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Safe_Access_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Safe_Access_Code;


-- Get_Safe_Access_Code_Db
--   Fetches the DB value of SafeAccessCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Safe_Access_Code_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab.safe_access_code%TYPE
IS
BEGIN
   RETURN Get_Safe_Access_Code_Db(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Safe_Access_Code_Db;


-- Get_Process_Class_Id
--   Fetches the ProcessClassId attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Class_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Class_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Class_Id;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN Public_Rec
IS
BEGIN
   RETURN Get(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Objkey(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Objkey;

--TODO: Try to get rid of logical keys
PROCEDURE Direct_Move__ (
   cmnt_                      IN OUT VARCHAR2,
   contract_                  IN     VARCHAR2,
   mch_code_                  IN     VARCHAR2,
   equipment_object_seq_      IN     NUMBER,
   sup_mch_code_              IN     VARCHAR2,
   sup_contract_              IN     VARCHAR2,
   to_sup_mch_code_           IN     VARCHAR2,
   to_sup_contract_           IN     VARCHAR2,
   to_sup_equip_object_seq_   IN     NUMBER,
   to_contract_               IN     VARCHAR2,
   to_company_                IN     VARCHAR2,
   sign_                      IN     VARCHAR2,
   is_new_pm_rev_             IN     BOOLEAN,
   wo_site_                   IN     VARCHAR2 DEFAULT NULL,
   org_code_                  IN     VARCHAR2 DEFAULT NULL,
   from_serial_place_         IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   rcode_                        VARCHAR2(5);
   ex_is_address                 EXCEPTION;
   ex_has_connection             EXCEPTION;
   no_move_obj                   EXCEPTION;
   mch_loop                      EXCEPTION;
   different_companies           EXCEPTION;
   value_                        VARCHAR2(2000);
   name_                         VARCHAR2(30);
   lu_rec_                       EQUIPMENT_OBJECT_TAB%ROWTYPE;
   transaction_description_      VARCHAR2(2000);
   transaction_description1_     VARCHAR2(2000);
   transaction_description2_     VARCHAR2(2000);
   latest_transaction_           VARCHAR2(2000);
   superior_alternate_contract_  VARCHAR2(5);
   superior_alternate_id_        VARCHAR2(100);
   operational_status_db_        VARCHAR2(20);
   superior_part_no_             VARCHAR2(25);
   superior_serial_no_           VARCHAR2(50);
   object_curr_pos_              VARCHAR2(30);
   user_                         VARCHAR2(30);
   cmnt1_                        VARCHAR2(2000);
   obj_note_                     EQUIPMENT_OBJECT_TAB.note%TYPE;
   company_                      VARCHAR2(20):= Site_API.Get_Company(contract_);
   attr_                         VARCHAR2(32000);
   objid_                        ROWID;
   objversion_                   VARCHAR2(2000);
   info_                         VARCHAR2(2000);  
   
   CURSOR part_info IS
      SELECT part_no, mch_serial_no
      FROM EQUIPMENT_OBJECT_TAB
      WHERE mch_code = superior_alternate_id_
      AND contract = superior_alternate_contract_;
BEGIN
   -- IF current object is an adress, move is not allowed.
   IF Equipment_Object_API.Is_Address__(contract_, mch_code_) THEN
      RAISE ex_is_address;
   END IF;
   -- IF current object has any connections, move is not allowed.
   IF Equipment_Object_Conn_API.Has_Connection(contract_, mch_code_) = 'TRUE' THEN
      RAISE ex_has_connection;
   END IF;
    --IF contract belongs to different companies, move is not allowed
   IF sup_mch_code_ IS NOT NULL AND to_contract_ IS NULL AND to_sup_mch_code_ IS NOT NULL THEN 
      IF Site_API.Get_Company(to_sup_contract_) != Site_API.Get_Company(contract_) THEN
         RAISE different_companies;
      END IF;
   END IF;
   
   IF to_sup_mch_code_ IS NOT NULL THEN 
      Equipment_Object_API.Check_Tree_Loop__(rcode_,  contract_, mch_code_, to_sup_mch_code_, to_sup_contract_);
      
      IF (rcode_ = 'TRUE') THEN
         RAISE mch_loop;
      END IF;
   END IF;
   
   -- for site move from place serial structure, the correct company employee check is inside Equipment_Serial_API.Check_Move().
   IF sign_ IS NOT NULL AND from_serial_place_ = 'FALSE' THEN
      Company_Emp_API.Exist(company_, Company_Emp_API.Get_Max_Employee_Id (company_,sign_));
   END IF;

   lu_rec_ := Get_Object_By_Keys___(equipment_object_seq_);

   obj_note_ := Equipment_Object_API.Get_Note(contract_,mch_code_);
   IF cmnt_ IS NOT NULL THEN
      IF obj_note_ IS NOT NULL THEN
         cmnt1_ :=  SUBSTR((obj_note_|| chr(13)||chr(10) ||cmnt_), 1,2000);
      ELSE
         cmnt1_ :=  SUBSTR(cmnt_, 1,2000);
      END IF;
   ELSE
      cmnt1_ :=  SUBSTR(obj_note_, 1,2000);
   END IF;
   lu_rec_.note := cmnt1_;
   

   IF to_contract_ IS NOT NULL THEN 
      Client_SYS.Add_To_Attr('CONTRACT', to_contract_, attr_);
      Client_SYS.Add_To_Attr('SKIP_CONTRACT_VALIDATION', 'TRUE', attr_);
   END IF;
   IF to_sup_mch_code_ IS NOT NULL THEN 
      Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', to_sup_equip_object_seq_,                        attr_);
      
      IF to_contract_ IS NOT NULL AND to_contract_ != to_sup_contract_ THEN
         Client_SYS.Add_To_Attr('MCH_LOC', '',     attr_);
         Client_SYS.Add_To_Attr('MCH_POS', '',     attr_);
         Client_SYS.Add_To_Attr('LOCATION_ID', '', attr_);
      ELSE 
         Client_SYS.Add_To_Attr('MCH_LOC',               Get_Mch_Loc(to_sup_contract_, to_sup_mch_code_),      attr_);
         Client_SYS.Add_To_Attr('MCH_POS',               Get_Mch_Pos(to_sup_contract_, to_sup_mch_code_),      attr_);
         Client_SYS.Add_To_Attr('LOCATION_ID',           Get_Location_Id(to_sup_contract_, to_sup_mch_code_),  attr_);
      END IF;
      
      IF to_contract_ IS NOT NULL AND to_company_ != Site_API.Get_Company(to_sup_contract_) THEN 
         Client_SYS.Add_To_Attr('COST_CENTER', '', attr_);  
         Client_SYS.Add_To_Attr('OBJECT_NO',   '', attr_);
      ELSE  
         Client_SYS.Add_To_Attr('COST_CENTER', Equipment_Object_API.Get_Cost_Center(to_sup_contract_, to_sup_mch_code_), attr_);
         Client_SYS.Add_To_Attr('OBJECT_NO',   Equipment_Object_API.Get_Object_No(to_sup_contract_, to_sup_mch_code_),   attr_);
      END IF;
   ELSE 
      Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', '', attr_);
      Client_SYS.Add_To_Attr('MCH_LOC', '', attr_);
      Client_SYS.Add_To_Attr('MCH_POS', '', attr_);
      Client_SYS.Add_To_Attr('LOCATION_ID', '', attr_);
      IF to_company_ != company_ THEN 
         Client_SYS.Add_To_Attr('COST_CENTER', '', attr_);
         Client_SYS.Add_To_Attr('OBJECT_NO',   '', attr_);
      END IF;
   END IF;
   
   
   
   Get_Id_Version_By_Keys___(objid_, objversion_, equipment_object_seq_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   
   object_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(lu_rec_.part_no, lu_rec_.mch_serial_no);
   IF (to_sup_mch_code_ IS NULL) THEN
      superior_alternate_contract_ := NULL;
      superior_alternate_id_ := NULL;
   ELSE
      superior_alternate_contract_ := to_sup_contract_;
      superior_alternate_id_ := to_sup_mch_code_;
   END IF;
   
   IF lu_rec_.mch_serial_no IS NOT NULL AND lu_rec_.part_no IS NOT NULL THEN
      IF sup_mch_code_ IS NULL THEN 
         IF to_sup_mch_code_ IS NOT NULL THEN
            IF to_contract_ IS NOT NULL AND to_contract_ != contract_ THEN
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJFROMNULL1: Moved to Site :P1, Company :P2 from Site :P3, ', NULL, to_contract_, to_company_, contract_);
               transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJFROMNULL11: company :P1. Current parent object - :P2, site :P3 ', NULL,company_, to_sup_mch_code_, to_sup_contract_);
               transaction_description2_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJFROMNULL111: by User :P1', NULL, sign_);
               transaction_description_ := transaction_description_||transaction_description1_||transaction_description2_;
            ELSE
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJFROMNULL2: Placed in object :P1 in site :P2 by user :P3', NULL, to_sup_mch_code_, to_sup_contract_, sign_);
            END IF;
            
            IF cmnt_ IS NOT NULL THEN
               transaction_description_ := substr(transaction_description_||'. '||'('||cmnt_||')',1,2000);
            ELSE
               transaction_description_ := substr(transaction_description_,1,2000);
            END IF;
            
            IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(to_sup_equip_object_seq_), Equipment_Object_API.Get_Mch_Code(to_sup_equip_object_seq_)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                  latest_transaction_, transaction_description_,operational_status_db_);
               END IF;
            ELSIF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(to_sup_equip_object_seq_), Equipment_Object_API.Get_Mch_Code(to_sup_equip_object_seq_)) != 'TRUE') THEN
               IF (object_curr_pos_ != 'Contained') THEN
                  Part_Serial_Catalog_API.Move_To_Contained(lu_rec_.part_no, lu_rec_.mch_serial_no,
                  transaction_description_, transaction_description_,operational_status_db_);
               END IF;
            END IF;
            
            OPEN Part_Info;
            FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
            Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_,superior_serial_no_, transaction_description_);
            CLOSE Part_Info;
         ELSE 
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE1: Moved to site :P1, Company :P2 from Site :P3,', NULL, to_contract_, to_company_, contract_);
            transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE11: Company :P1 by user :P2', NULL, company_, sign_);
            transaction_description_ := transaction_description_||transaction_description1_;
            
            IF cmnt_ IS NOT NULL THEN
               transaction_description_ := substr(transaction_description_||'. '||'('||cmnt_||')',1,2000);
            ELSE
               transaction_description_ := substr(transaction_description_,1,2000);
            END IF;
            
            Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, NULL,NULL, transaction_description_);
         END IF;
      ELSIF to_sup_mch_code_ IS NULL THEN 
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE2: Moved to site :P1, Company :P2 from site :P3,', NULL, to_contract_, to_company_, contract_);
         transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE22: Company :P1. Old parent object :P2, site :P3 ', NULL, company_, sup_mch_code_, sup_contract_);
         transaction_description2_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE222: by user :P1', NULL, sign_);
         transaction_description_ := transaction_description_||transaction_description1_||transaction_description2_;
         
         IF cmnt_ IS NOT NULL THEN
            transaction_description_ := substr(transaction_description_||'. '||'('||cmnt_||')',1,2000);
         ELSE
            transaction_description_ := substr(transaction_description_,1,2000);
         END IF;
         
         Part_Serial_Catalog_API.Remove_Superior_Info(lu_rec_.part_no, lu_rec_.mch_serial_no, 'InFacility', transaction_description_);
         Equipment_Object_API.Remove_Superior_Info(to_contract_, mch_code_);
      ELSE
         IF to_sup_mch_code_ IS NULL THEN
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVETOBJNULL: Moved to top level from object :P1 site :P2  by user :P3', NULL, sup_mch_code_, sup_contract_, sign_);
         ELSIF sup_mch_code_ IS NULL AND Equipment_Object_API.Has_Structure(contract_, mch_code_) = 'TRUE' THEN
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEFOBJNULL: In object :P1, Moved to object :P1 site :P2 from top level by user :P3', NULL, to_sup_mch_code_, to_sup_contract_, sign_);
         ELSIF (object_curr_pos_ = 'InRepairWorkshop') THEN
            user_ := Fnd_Session_API.Get_Fnd_User;
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJINVTOFACT: In object :P1, Moved into object :P1 at site :P2 from repair workshop by user :P3', NULL, to_sup_mch_code_, to_sup_contract_, user_);
         ELSE
            IF to_contract_ IS NOT NULL AND to_contract_ != contract_ THEN
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJWITHSITE1: Moved to Site :P1, Company :P2 from site :P3, ', NULL, to_contract_, to_company_, contract_);
               transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJWITHSITE11: company :P1. Current parent object - :P2, site :P3 : ', NULL, company_, to_sup_mch_code_, to_sup_contract_);
               transaction_description2_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJWITHSITE111: Old parent object :P1, site :P2 by :P3', NULL, sup_mch_code_, sup_contract_, sign_);
               transaction_description_ := transaction_description_||transaction_description1_||transaction_description2_;
            ELSE
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJECT: moved to Current parent object - :P1, site :P2 : Old Parent object :P3, ', NULL, to_sup_mch_code_, to_sup_contract_, sup_mch_code_);
               transaction_description1_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJECT1: site :P1 by :P2', NULL, sup_contract_, sign_);
               transaction_description_ := transaction_description_||transaction_description1_;
            END IF;
         END IF;
         
         IF cmnt_ IS NOT NULL THEN
            transaction_description_ := substr(transaction_description_||'. '||'('||cmnt_||')',1,2000);
         ELSE
            transaction_description_ := substr(transaction_description_,1,2000);
         END IF;
         
         latest_transaction_ := Language_SYS.Translate_Constant(lu_name_, 'NEWOBJ: Placed in object :P1 at site :P2.', NULL, to_sup_mch_code_, to_sup_contract_);

         IF  (sup_mch_code_ IS NOT NULL AND to_sup_mch_code_ IS NOT NULL) THEN
            operational_status_db_ := Part_Serial_Catalog_API.Get_Operational_Status_Db(lu_rec_.part_no, lu_rec_.mch_serial_no);
            IF (Equipment_Functional_API.Do_Exist(Equipment_Object_API.Get_Contract(to_sup_equip_object_seq_), Equipment_Object_API.Get_Mch_Code(to_sup_equip_object_seq_)) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  IF (Equipment_Serial_API.Do_Exist(sup_contract_, sup_mch_code_) = 'TRUE') THEN
                     Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                     transaction_description_, transaction_description_, NULL);
                  ELSE
                     Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                     latest_transaction_, transaction_description_, NULL);
                  END IF;
               ELSE
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, NULL,NULL, transaction_description_);
               END IF;
            ELSIF (Equipment_Functional_API.Do_Exist(to_sup_contract_, to_sup_mch_code_) != 'TRUE') THEN
               
               IF (object_curr_pos_ != 'Contained') THEN
                  IF (Equipment_Functional_API.Do_Exist(sup_contract_, sup_mch_code_) != 'TRUE') THEN
                     Part_Serial_Catalog_API.Move_To_Contained(lu_rec_.part_no, lu_rec_.mch_serial_no, transaction_description_, transaction_description_, NULL);
                  ELSE
                     OPEN Part_Info;
                     FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
                     Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
                     CLOSE Part_Info;
                  END IF;
               ELSE
                  OPEN Part_Info;
                  FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
                  CLOSE Part_Info;
               END IF;
            END IF;
         ELSIF (sup_mch_code_ IS NULL AND to_sup_mch_code_ IS NOT NULL) THEN
            --Individual move
            IF (Equipment_Functional_API.Do_Exist(to_sup_contract_, to_sup_mch_code_) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, 
                  latest_transaction_, transaction_description_,operational_status_db_);
               END IF;
            ELSIF (Equipment_Functional_API.Do_Exist(to_sup_contract_, to_sup_mch_code_) != 'TRUE') THEN
               IF (object_curr_pos_ != 'Contained') THEN
                  Part_Serial_Catalog_API.Move_To_Contained(lu_rec_.part_no, lu_rec_.mch_serial_no,
                  transaction_description_, transaction_description_,operational_status_db_);
               END IF;
            END IF;

            OPEN Part_Info;
            FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
            Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
            CLOSE Part_Info;

         ELSIF NOT (sup_mch_code_ IS NULL AND to_sup_mch_code_ IS NOT NULL) THEN
            IF (to_sup_mch_code_ IS NOT NULL) THEN
               OPEN Part_Info;
               FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
               IF (Equipment_Functional_API.Do_Exist(to_sup_contract_, to_sup_mch_code_) != 'TRUE') THEN
                  Part_Serial_Catalog_API.Modify_Serial_Structure(lu_rec_.part_no, lu_rec_.mch_serial_no, superior_part_no_, superior_serial_no_, transaction_description_);
               END IF;
               CLOSE Part_Info;
            ELSE
               IF (sup_mch_code_ IS NOT NULL) THEN
                  Part_Serial_Catalog_API.Remove_Superior_Info(lu_rec_.part_no, lu_rec_.mch_serial_no, 'InFacility', transaction_description_);
               ELSE
                  Part_Serial_Catalog_API.Move_To_Facility(lu_rec_.part_no, lu_rec_.mch_serial_no, latest_transaction_, transaction_description_,operational_status_db_);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   IF Equipment_Object_API.Has_Structure(equipment_object_seq_) = 'TRUE' THEN
      Equipment_Object_Util_API.Complete_Move(cmnt_, contract_, mch_code_, sup_mch_code_, sup_contract_, to_sup_mch_code_, to_sup_contract_, sign_, to_contract_, equipment_object_seq_, is_new_pm_rev_, wo_site_, org_code_);
   END IF;
   $IF Component_Opplan_SYS.INSTALLED $THEN
      Object_Oper_Mode_Group_API.Remove_Inherited(equipment_object_seq_);
   $END
   
   --Handle connected PMs when moving to different site. Consider move this to run as background for better performance 
   IF to_contract_ IS NOT NULL AND to_contract_ != contract_ THEN
      $IF Component_Pm_SYS.INSTALLED $THEN
         Pm_Action_API.Handle_Pm_Action( equipment_object_seq_, to_contract_, wo_site_, org_code_, is_new_pm_rev_);
      $ELSE
         NULL;
      $END
      
      $IF Component_Pcmstd_SYS.INSTALLED $THEN
         Equipment_Object_API.Update_Pm_Program_Info(equipment_object_seq_, NULL, NULL, FALSE); 
      $ELSE
         NULL;
      $END
   END IF;
   
EXCEPTION
   WHEN ex_is_address THEN
      Error_SYS.Appl_General(lu_name_, 'OBJISADDR: Object :P1 is a functional object. Move is not allowed.', mch_code_);
   WHEN ex_has_connection THEN
      Error_SYS.Appl_General(lu_name_, 'OBJHASCONN: Object :P1 has connections. Move is not allowed.', mch_code_);
   WHEN different_companies THEN
      Error_SYS.Appl_General(lu_name_, 'SITEDIFFSUPCOMP: The new Belongs To object (:P1) should be in the same Company as the old Belongs To object (:P2)', to_sup_mch_code_||','||to_sup_contract_, sup_contract_||','||sup_contract_);
   WHEN no_move_obj THEN
      Error_SYS.Appl_General(lu_name_, 'NOOBJMOVE: Object :P1 was not possible to move.', mch_code_);
   WHEN mch_loop THEN
      Error_SYS.Appl_General(lu_name_, 'MOVEOBJLOOP: Moving object :P1 will cause a loop in the equipment structure. Move is not allowed.', mch_code_);
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);   
END Direct_Move__;

-- End: Methods to facilitate the references using CONTRACT, MCH_CODE business key