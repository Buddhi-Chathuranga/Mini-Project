-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentFunctional
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970528  TOWI  Created
--  970609  ERJA  Added Procedure Copy__
--  970618  ERJA  Changed datatypes in Copy__
--  970814  ERJA  Changed obj_level to lowercase
--  970821  ERJA  Changed mch_serial_no to serial_no and added manufacturer_no, vendor_no and type
--  970901  ERJA  Added Ref on manufaturer_no and vendor_no.
--  970902  ERJA  Changed call to Check_tree_Loop__ to Equipment_All_Object_API.Check_Tree_Loop__
--  970902  ERJA  Spelling correction in error messages in PROCEDURE Copy__
--  970903  ERJA  Corrected  Exist control on obj_Level and Type in Unpack_Check_Update
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_tab.
--  970925  ERJA  Removed exist in unpack_check_insert unpack_check_update on obj_level again.
--  970930  ERJA  Changed Do_Exist from equipment_object_API.Do_Exist to Check_Exist___.
--  971001  STSU  Added method Create_Object.
--  971020  ERJA  Changed ref=Supplier to MaintenanceSupplier
--  971027  ERJA  Changed ref=MaintenanceSupplier to PartyTypeSupplier
--                and ref=EquipmentManufacturer to PartyTypeManufacturer.
--  971029  STSU  Added view EQUIPMENT_FUNCTIONAL_UNDEF.
--  971030  STSU  Added procedure Update_Obj_Level__.
--  971114  MNYS  Added key contract and attribute sup_contract.
--  971210  CAJO  Added default contract to SUP_CONTRACT in Prepare_Insert.
--  971210  CAJO  Removed and corrected validations and error messages in Validate_Comb__.
--  971214  TOWI  Corrected view comments in VIEW2
--  971217  ERJA  Removed sup_contract from prepare_insert and changed where-clause in view2
--  980120  ADBR  Added New_Object__.
--  980206  ERJA  Changed exist and IF-statement in Validate_Comb___ concerning sup_mch_code
--  980206  ERJA  Changed unpack_check_insert to remove sup_contract IF sup_mch_code is null
--  980210  ADBR  Added contract in New_Object__.
--  980211  TOWI  Added functionality for cascade delete against base class.
--  980220  ADBR  Added sup_contract_ in Check_Object_Level__.
--  980224  ERJA  removed reference to equipment_object_move in When_New_Mch__
--  980225  ERJA  Corrections due to possibility to have part_no in functionals
--  980315  TOWI  Added deletion of document connection if the object is removed.
--                Changed key_reference in copy document connections.
--  980319  ERJA  Added Procedure Create_Construction_Object.
--  980319  ADBR  Changed Concatenate_Object__ to use system parameter as separator and removed
--                obj_level parameter. Changed Validate_Comb___ to call Concatenate_Object__.
--                Changed New_Object__ to return mch_code.
--  980323  CLCA  Changed length on manufacturer_no and vendor_no
--  980324  ERJA  Changed order of new and move_in_facility in Create_Construction_Object.
--  980326  CLCA  Changed from Get_App_Owner to Get_Fnd_User.
--  980326  ERJA  ID 2027 Correction Create_Construction_object
--  980401  MNYS  Changed order of parameters in call to When_New_Mch__
--  980401  MNYS  Included sup_contract as a member of LOV for view EQUIPMENT_FUNCTIONAL.
--  980403  MNYS  Support Id: 858. Changed the errormessage in Validate_Comb___ when
--                checking object_level.
--  980407  MNYS  Support Id: 308. Added call Equipment_Object_API.Check_Delete__
--                in procedure Check_Delete___.
--  980417  CLCA  Corrected Has_Warranty.
--  980421  MNYS  Support Id: 3897. Added check for Functional Objects in Validate_Comb___.
--  980424  MNYS  Support Id: 1590. Added sup_contract to attr_ in procedures Unpack_Check_Insert___
--                and Unpack_Check_Update___ after check if sup_mch_code IS NULL.
--  980425  TOWI  Changed view2 to both include level_seq 98 and 99
--  980512  ERJA  Removed call to part_serial_catalog in Create_Construction_Object
--  980513  ADBR  Support Id: 4543. Changed mch_code_key_value to Client_SYS call.
--  980615  CLCA  Changed prompt from 'Object Group' to 'Group ID' for group_id.
--  980624  NILA  Modified function Check_Individual_Aware__ to use function
--                Individual_Aware_API.Get_Client_Value(1) instead of string 'Yes'.
--  980817  ERJA  Bug Id 5546: Added Exist on Manufacturer and Supplier
--  980929  MIBO  Added Function Get_Criticality, Function Get_Criticality_Description
--                and added column Criticality in view.
--  981103  MIBO  Added status for the equipment object.
--  981124  MIBO  Changed REF=PartyTypeSupplier to SupplierInfo and Party_Type_Supplier_API
--                to Supplier_Info_API and REF=PartyTypeManufacturer to ManufacturerInfo
--                and Party_Type_Manufacturer_API to Manufacturer_Info_API.
--  981201  CLCA  Added work_order_cost_type_ in Update_Amount.
--  990112  MIBO  SKY.0208 AND SKY.0209 Changed SYSDATE to Site_API.Get_Site_Date(newrec_.contract)
--                and removed all calls to Get_Instance___ in Get-statements
--  990118  MIBO  SKY.0209 Changed Site_API.Get_Site_Date(contract) to
--                Maintenance_Site_Utility_API.Get_Site_Date(contract).
--  990121  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206) and
--                'Amount and Currency format' (SKY.0202) for data format.
--  990202  MAET  Modifications according to SKY.0203. Checking the existance of object_no and
--                cost_center was changed. The new existance check is performed by invoking
--                Maintenance_Accounting_API.Accounting_Codepart_Exist.
--  990224  MIBO  Call Id 8975 Changed the check for sup_mch_code and sup_contract
--                in PROCEDURE Validate_Comb___
--  990225  MIBO  Call Id 8975 Added if sup_mch_code = NULL set sup_contract to NULL
--                in unpack_check_update and unpack_check_insert.
--  990311  ERJA  Added design_object_ in Create_Construction_Object and INSERT__
--  990311  RAFA  Call 10835.Modified validate_comb.It is not possible to add objects belonging to a scrapped object.
--  990318  RAFA  Call 12984.It is possible to unscrap an object that has been set to status scrapped.
--                Modified Finite_State_Machine___ and Finite_State_Events__.
--  990415  MIBO  Template changes due to performance improvement.
--  990519  ERJA  Bug id 9799: Added company in prepare_insert
--  990520  MAET  FUNCTION Check_Exist___: View qualification was added to the cursor.
--  990531  CAPT  Call Id 18344: Added function Active_WO_Exists. Added infomessage in
--                function Scrap__.
--  990617  ERJA  Removed Active_WO_Exists and changed calls to obj_has_wo.
--  990617  CLCA  Added cost_center, mch_loc, and mch_pos in New_Object__
--  990916  MAET  PROCEDURE Insert___: rowversion was added to the last select statement and objversion_
--                was updated based on this value.
--  990917 PJONSE Rock.1093:B PROCEDURE Update_Amount. Added cre_date_ parameter in PROCEDURE Update_Amount
--                 and in call for Equipment_Object_API.Update_Amount.
--  990922  ERJA  Merged changes from Service release into file: (990916  MAET)
--  990927  MIBO  Added security checks 2000B.
--  991001  ERJA  Rock1393:B Added Columns plant_design_id, plant_design_projphase, plant_design_cotproj_projid
--  991006  OSRY  Rock1424:B Changed mch_type from 5 to 20 characters.
--  991008 PJONSE Rock1429:B Changed client_state_list_: UnderConstruction to PlannedForOperation and Active to InOperation and Inactive to OutOfOperation.
--  991110  ERRA  Added Plant_Design_State using Rowstate in cursor for insert AND update.
--  000201  JIJO  Calling new function: OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty
--  000316 PJONSE Call Id: 35518. Added FUNCTION Has_Customer_Warranty.
--  000317 PJONSE Removed the viewcomment for main_position_db.
--  000411  HAST  Call 37955: Added Integration code for Plant design.
--  000417  HAST  Call 37955: Spelling fix on Public method Inactivate
--  000509 RECASE Added key_ref and lu_name (referring to LU EquipmentObject) to the view EQUIPMENT_FUNCTIONAL,
--                as they are keys to Object_Connection.
--  000519 RECASE In functions Copy_Serial__ and Copy_Functional__, exchanged calls on Equipment_Object_Attr_API.Has_Technical_Data
--                for calls on Equipment_Object_API.Has_Technical_Spec_No, exchanged call on Equipment_Object_Attr_API.Copy
--                for call on Technical_Object_Reference_API.Copy. Used LU EquipmentObject.
--  000523 RECASE Changed procedure When_New_Mch__ not to call Create_Attr_Template.
--  001219 RECASE Call ID: 56786. Added functionality to Unpack_Check_Insert__ and Unpack_Check_Update__ of mch_code:
--                Set the characteristics of the object to the characteristics of the object type whenever the object type is changed and has characteristics.
--  010430 NEKOLK Added and Checked General_SYS.Init_Method
--  010928 MIBOSE Some changed in client_state_list_.
--  011002 ANERSE Bug id 21800: Added 'ELSIF name_ = MCH_NAME...' in procedure Create_Construction_Object.
--  011008 UDSULK Bug Id 24980  Modified so that it will update the Demand tab when changing Object Type field in general tab.
--                Also set the Object Type not update after changing the values in demand\technical class\attributes.
--  020211  ANCE  Bug Id 26013 Copy__. Modified call to Equipment_Object_Test_Pnt_API.Has_Test_Point and Equipment_Object_Param_API.Has_Parameter
--                             according to their modified return datatype.
-- ************************************* AD 2002-3 BASELINE ********************************************
--  020523  kamtlk  Modified serial_no length 20 to 50 in view EQUIPMENT_FUNCTIONAL.
--  020531  CHAMLK  Modified MCH_CODE length from 40 to 100
--  020603  CHAMLK  Modified the length of mch_code_key_value in VIEW EQUIPMENT_FUNCTIONAL in order to accomodate
--                  the new MCH_CODE length. Made modifications in procedures Concatenate_Object__ and Scrap__
--  020621  jagrno  Added new validations in Validate_Comb___ for ManufacturerNo:
--                  - if the functional object has a part number, the entered manufacturer must exist in
--                    PartManufacturer.
--  020625  CHCRLK  Added column OPERATIONAL_STATUS. Added methods to set and retrive the value of OPERATIONAL_STATUS.
--  020704  CHCRLK  Modified procedure Set_Operational_Status___.
--  020708  CHCRLK  Changed order of parameters when calling methods in Equipment_Serial_API in Set_Operational_Status___.
--  020729  CHCRLK  Removed state machinery.
--  020729  CHCRLK  Changed call Maintenance_Object_Api.Get_Objstate to Maintenance_Object_Api.Get_Operational_Status_Db.
--  020809  INROLK  Added validation for Manufactured date in Validate_Comb___
--  --------------------------------AD 2002-3 Beta (Merge of IceAge)-------------------------------------
--  020508 NIVIUS/LeSvse Bug Id 27092 : Modifed the error text in Validate_comb___ method when trying to connect functional object
--                under a serial object.
--  020729 SHAFLK Bug Id 29398, Changed error message in Concatenate_Object__.
--  020823 UDSULK Bug Id 32002 Delete reference to the technical data when mach code deletes.
--  021021 CHCRLK Call ID: 90222 - Modified procedure Validate_Comb___.
--  030217 UDSULK Delete the references of documents attached, when functional object deletes.
--  030408 NEKOLK Added value for cost center in  Unpack_Check_Insert___ and Modified  Unpack_Check_Update___
--  030429 SHAFLK Modified Unpack_Check_Update___.
--  030729 CHCRLK Modified procedure Set_Operational_Status___ to handle functionals from plant design.
--  030804 NAMELK Add parameter 'from_plant_design_'  to all set methods.
--  030813 NAMELK Changed the type of the variable 'from_plant_design_' to VARCHAR2.
--  030818 CHATLK B101228 : Changed Procedure Set_Operational_Status___ .
--  030822 NUPELK B101228 : Some corrections done to public methods which set operational status
--  030929 KUHELK B104381 : Validate_Comb___ method's  Production Date Error message changed.
--  030929 LABOLK B104139 : Added LOV view EQUIPMENT_FUNCTIONAL_LOV.
--  030929 KUHELK B104380 : Added a new validation to Purchase Date field in Validate_Comb___ method.
--  031017 NAWILK B104062 : Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___ to validate SUP_MCH_CODE.
--  031018 LABOLK Converted VARCHAR to VARCHAR2.
--  031024 KUHELK LCS Bug 39988, Used Maintenance_Document_Ref_API instead of Doc_Reference_Object_API.
--  031117 ChAmlk Call Id 110763 - Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040128 YaWilk Moved the content of the Delete___ method to Equipment_Object_API.Delete___. called it through a privete
--                method Equipment_Object_API.Do_Delete__.
--  040209 YaWilk Unicode Support. Changes Done with 'SUBSTRB'.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
--  040123 BUNILK Bug 40610  Modified Unpack_Check_Insert___ method.
--  230304 DIMALK Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package --                body.
--  040324 JAPALK Merge with SP1
--  040423 UDSULK Unicode Modification-substr removal-4.
--  040616 ACWALK Bug 44777. Increased the length of object_Id
--  040809 ThWilk Merged 44777.
--  041229 GIRALK Bug Id 48065, Modified PROCEDURE Insert___
--  050103 Chanlk Merged Bug 48065.
--  050107 LOPRLK Bug 48893, Altered the method Validate_Comb___.
--  050113 LOPRLK Bug 48893, Altered the method Insert___.
--  050126 Chanlk Merged Bug 48893.
--  050126 DiAmlk Modified the method Set_Operational_Status___.
--  050117 SHAFLK Bug 48580, Modified view comments for part no.
--  050131 Chanlk Merged Bug 48580
--  050217 DiAmlk Modified the method Set_Operational_Status___ to obsolete PMs only when the
--                object is SCRAPPED.
--  050525  DiAmlk Obsoleted the method Update_Amount and attribute Amount.(Relate to Spec AMEC113 - Cost Follow Up)
--  050615 SHAFLK Bug 51420, Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050718 THWILK Merged LCS Bug 51420 and further modified Unpack_Check_Insert___ and Unpack_Check_Update___ to fix an existing bug.
--  050920 SHAFLK Bug 53377, Modified Update___.
--  050930 NIJALK Merged bug 53377.
--  051013 SHAFLK Bug 53872, Modified Procedure Set_Operational_Status___.
--  051102 AMNILK Merged Bug 53872.Added a new Procedure in pmaction.api and manually modified the Set_Operational_Status___ .
--  060215 NIJALK Bug 134029: Modified Copy__. Added values to parameters error_when_no_source_,error_when_existing_copy_ for method call
--                to Technical_Object_Reference_API.Copy().
--  060218 JAPALK Call ID 134579. Modigied Insert___ method.
--  060218 NEKOLK Call 134571- made changes in view.
--  060220 JAPALk Call ID 134599 Modified Insert___ method.
--  060303 NIJALK Call ID:135919, Modified New_Object__.
--  060306 DiAmlk Bug ID:135659 - Modified the method signature of Validate_Comb___ and Unpack_Check_Update___.
--  060313 NIJALK Call 135919: Modified Unpack_Check_Insert___,Unpack_Check_Update___.
--  060810 ILSOLK Merged Bug Id 59428.
--  070125 AmNilk MTIS907: New Service Contract - Services.Added new columns is_category_object, is_geographic_object to the table.
--  070118 SHAFLK Bug 62863, Modified the method Insert___.
--  070208 AMNILK Merged LCS Bug 62863.
--  070328 AmNilk Modified insert___().
--  070505 AmNilk Call Id: 143154. Modified Unpack_Check_Update___().
--  070528 PRIKLK Bug 65575, Added NOCHECK to view comments of code part fields.
--  070626 AMDILK Merged bug 65575
--  070806 HADALK Bug 66675, Modified Unpack_Check_Update___ AND Update___.
--  070813 ILSOLK Merged Bug Id 66675.
--  070830 ChAmlk Modified Update___ in order to delete Tech Class that came in with a previous object type when a
--                new object type with no Tech Class is connected.
--  071113 LIAMLK Bug 67252, Modified procedures Set_Scrapped, Set_Structure_Scrapped, Set_Operational_Status___.
--  080514 AMNILK Bug Id 73949, Modified Unpack_Check_Update___().
--  090327 nukulk Bug Id 81398, added ifs_assert_safe annotation.
--  -------------------------Project Eagle-----------------------------------
--  090930 Hidilk Task EAST-317, reference added for enumeration package TRANSLATE_BOOLEAN_API
--  091016 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091026 Hidilk Added view comments for lu_name and key_ref fields.
--  091105 SaFalk IID - ME310: Removed bug comment tags.
--  100202 SHAFLK Bug 88411, Modified Set_Scrapped and Set_Structure_Scrapped.
--  100716 NIJALK Bug 87685, Modified New_Object__.
--  101021 NIFRSE Bug 93384, Updated view column prompts to 'Object Site'.
--  110425 NRATLK Bug 96790, Modified Insert___() to insert address7.
--  110127 NeKolk EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_FUNCTIONAL.
--  110221 SaFalk EANE-4424, Added new view EQUIPMENT_FUNCTIONAL_UIV with user_allowed_site filter to be used in the client.
--                Removed user_allowed_site filter from EQUIPMENT_FUNCTIONAL.
--  110602 MADGLK Bug 96937, Modified column comments of EQUIPMENT_FUNCTIONAL ,EQUIPMENT_FUNCTIONAL_UNDEF and EQUIPMENT_FUNCTIONAL_LOV.
--  110725 MAWILK Bug 98185, Modified Validate_Comb___() concerning object status.
--  110803 SanDLK Modified column comments of EQUIPMENT_FUNCTIONAL_UIV while Merging BUG 96937.
--  110817 PRIKLK SADEAGLE-1739, Added user_allowed_site filter to view EQUIPMENT_FUNCTIONAL.
--  110913 MADGLK Bug 98873, Modified Validate_Comb___().
--  111017 MADGLK Bug 99136, Modified the length of address1 of Insert___() to String(35).
--  111227 NRATLK Bug 100413, Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Update___().
--  120201 SAMGLK Bug 100937, Removed some code in Unpack_Check_Update___() and update__() added by Bug 100413.
--  120517 HaRuLK SAPRE-49, Replaced Doc_Reference_Object_API.Refresh_Object_Reference_Desc() with Maintenance_Document_Ref_API.Refresh_Obj_Reference_Desc() in Update___().
--  121008 japelk Bug 105645, fixed in Unpack_Check_Insert___ and Update___ methods.
--  121008 SHAFLK EIGHTSA-230, Added new methods for new structures.
--  121216 HARULK EIGHTSA-483, Added the possibility to create journal entries.
--  130109 SHAFLK EIGHTSA-627, Added new method Remove_Document_Structure() and modified Update_Functional_Object().
--  130118 LoPrlk Task: NINESA-251, Added the attribute item_class_id to the LU.
--  -------------------------Project Black Pearl------------------------------------------------------
--  130508 MAWILK BLACK-66, Removed obsolete method.
--  130613 MADGLK BLACK-65 ,Removed MAINTENANCE_OBJECT_API method calls.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  --------------------------------------------------------------------------------------------------------------------------
--  ---------------------------------------- APPS 9 --------------------------------------------------------------------------
--  130619 heralk Scalability Changes - removed global variables.
--  130821 paskno Bug 111910, added column equipment_main_position_db to view EQUIPMENT_FUNCTIONAL and EQUIPMENT_FUNCTIONAL_UIV,
--                rewrote where in EQUIPMENT_FUNCTIONAL_UIV, EQUIPMENT_FUNCTIONAL_LOV and EQUIPMENT_FUNCTIONAL_UNDEF.
--  131213  NEKOLk  PBSA-1806, Hooks: refactored and split code.
--  131230  NEKOLK  PBSA-3413, Review fix.
--  140219  heralk  PBSA-5000, Fixed in PROCEDURE Validate_Comb___ ().
--  140306  BHKALK  PBSA-4873, Modified the validation for copy Cost_center in Check_Update___.
--  140311  BHKALK  PBSA-3600, Merged LCS patch 112451.
--  130930  SHAFLK  Bug 112451, Modified Set_Operational_Status___().
--  140311  BHKALK  PBSA-3593, Merged LCS patch 112448.
--  131007  SAFALK  Bug 112448, Modified Set_Operational_Status___.
--  140314  HASTSE  PBSA-5733, address fixes
--  140312  heralk  PBSA-3592 , Merged LCS Patch - 112727.
--  140326  HERALK  PBSA-5000, Added override Check_Common___.
--  140407  NiFrSE  PBSA-6184, Added Text_Id$ default value in the Insert___() method.
--  140514  NiFrSE  PBSA-6956, Removed Text_Id$ default value in the Insert___() method.
--  140522  DUHELK  PBSA-7288, Modified Validate_Comb___.
--  140610  MITKLK  PRSA-1265, Removed ifsapp from the cursor at Update_Functional_Object method
--  140804  HASTSE  PRSA-2088, fixed unused declarations
--  140812  HASTSE  Replaced dynamic code
--  141015  SHAFLK  PRSA-4668 Removed Update_Obj_Level__.
--  141027  HASTSE  PRSA-2446, Reference checks dont work autmaticaly for Based on
--  141205  PRIKLK  PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  141216  MAWILK  PRSA-6006, Inherited preferences should be removed when moving functional objects.
--  141217  NuKuLK  PRSA-6051, Modified Check_Common___().
--  150127  chanlk  PRSA-6800, Modified New_Object__ to add parties to objects.
--  150805  chanlk  Bug 123819, Handle Object_References shen deleting.
--  150903  SHAFLK  AFT-3373, Removed Delete__(remrec_) and Replaced all Remove__() with CheckDelete and Delete.
--  150911  INMALK  AFT-4648, Added UncheckedAccess annotation to Do_Exist()
--  151215  KrRaLK  STRSA-1662, Modified to fetch information from Psc_Contr_Product_Scope_API instead of Psc_Contr_Product_Object_API.
-------------------------------------- Candy Crush ---------------------------------------
--  151006  DUHELK  MATP-964, Added Safe_Access_Code, modified Insert___.
--  151230  DUHELK  MATP-1338, Modified Update___ to give a warning when modifying criticality.
--  150106  DUHELK  MATP-1580, Modified Update___().
----------------------------------------------------------------------------------------------------------------------------
--  160201  KrRaLK  STRSA-1884, Modified Insert___() and Update___().
--  160404  LiAmlk  MATP-2108, Modified Update___().
--  160407  NiFrSE  STRSA-3238, Added the method Get_Position_Type().
--  160607  Kanilk  STRSA-2612, Corrected Bug 127112, Modified method Update_Functional_Object.
--  161117  SeRoLk  STRSA-14444, Code cleanup.
--  161129 MDAHSE   STRSA-15865, fix compilation error due to renamed method in EquipmentObject.
--  170726  SHEPLK  STRSA-25562, Modified Update_Functional_Object().
--  171126  HASTSE  STRSA-32829, Equipment inheritance implementation
--  181031  SHEPLK  SAUXXW4-10600, Added Get_Requirements() and Get_Documents()
--  190803  SSILLK  Merge Bug 145867, Modified Update___()
--  200213  chanlk  Bug SAZM-4449 Modified Update_Functional_Object, Removed Remove_from_Serv_Contract___.
--  201111  CLEKLK  AM2020R1-6863, Modified Get_Documents
--  210105  DEEKLK  AM2020R1-7134, Added Validate_New_Obj_Level___() & Check_Ignore_Obj_Lvl_All(). Modified Move_Functional_Object(), Update_Functional_Object(), Check_Update___() & Validate_Comb___().
--  210203  CLEKLK  AM2020R1-7085, Modified Set_Operational_Status___, Set_Structure_Planned_For_Op, Set_Structure_In_Operation, Set_Structure_Out_Of_Operation, Set_Structure_Scrapped
--  210205  SHAGLK  AM2020R1-7260, Modified Delete___()
--  210324  DEEKLK  AM21R2-725, Modified Update___().
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


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
   IF (newrec_.group_id IS NULL AND newrec_.functional_object_seq IS NOT NULL) THEN
      newrec_.group_id := Equipment_Functional_API.Get_Group_Id(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
   END IF;
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
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (Validate_SYS.Is_Changed(oldrec_.part_no, newrec_.part_no)) THEN
         Purchase_Part_API.Check_External_Resource(newrec_.contract, newrec_.part_no);
      END IF;
   $END
END Check_Common___;


PROCEDURE Validate_Comb___ (
   newrec_            IN EQUIPMENT_OBJECT_TAB%ROWTYPE,
   ctrl_flag_         IN VARCHAR2 DEFAULT 'TRUE',
   obj_level_updated_ IN VARCHAR2 DEFAULT 'FALSE',
   current_obj_level_ IN VARCHAR2 DEFAULT NULL)
IS
   rcode_ VARCHAR2(5);
BEGIN
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      IF(EQUIPMENT_OBJECT_API.Get_Is_Category_Object(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'TRUE') THEN
          Error_SYS.Appl_General(lu_name_, 'CATOBJSTR: It is not possible to create structures for category objects.');
      END IF;
   END IF;

   -- Object status control
   IF(ctrl_flag_ = 'TRUE') THEN
      IF (newrec_.functional_object_seq IS NOT NULL) THEN
         IF (EQUIPMENT_OBJECT_API.Get_Operational_Status_Db(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) = 'SCRAPPED') THEN
            Error_SYS.Appl_General(lu_name_, 'NOCONOBJ: It is not possible to add objects belonging to a scrapped object :P1.', Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
         END IF;
      END IF;
   END IF;
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      IF (Get_Obj_Level(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq)) IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'NOTFUNCOBJ1: A functional object cannot be placed under a serial object. Functional object :P1 can therefore not be connected to serial object :P2.', newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
      END IF;
      Equipment_Functional_API.Exist(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
   END IF;
   IF (newrec_.functional_object_seq IS NOT NULL AND ctrl_flag_ = 'TRUE') THEN
      Equipment_Object_API.Check_Tree_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOP: Object :P1 will cause a loop in the equipment structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.location_object_seq IS NOT NULL ) THEN
      Equipment_Object_API.Check_Tree_Loc_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.location_object_seq), Equipment_Object_API.Get_Contract(newrec_.location_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPLOC: Object :P1 will cause a loop in the Location structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.from_object_seq IS NOT NULL) THEN
      Equipment_Object_API.Check_Tree_From_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.from_object_seq), Equipment_Object_API.Get_Contract(newrec_.from_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPFROM: Object :P1 will cause a loop in the From structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.to_object_seq IS NOT NULL) THEN
      Equipment_Object_API.Check_Tree_To_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.to_object_seq), Equipment_Object_API.Get_Contract(newrec_.to_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPTO: Object :P1 will cause a loop in the To structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.process_object_seq IS NOT NULL) THEN
      Equipment_Object_API.Check_Tree_Process_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.process_object_seq), Equipment_Object_API.Get_Contract(newrec_.process_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPPROCESS: Object :P1 will cause a loop in the Process structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.pipe_object_seq IS NOT NULL) THEN
      Equipment_Object_API.Check_Tree_Pipe_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.pipe_object_seq), Equipment_Object_API.Get_Contract(newrec_.pipe_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPPIPE: Object :P1 will cause a loop in the Pipe System structure.', newrec_.mch_code);
      END IF;
   END IF;
   IF (newrec_.circuit_object_seq IS NOT NULL) THEN
      Equipment_Object_API.Check_Tree_Circuit_Loop__(rcode_, newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.circuit_object_seq), Equipment_Object_API.Get_Contract(newrec_.circuit_object_seq));
      IF (rcode_ = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJLOOPCIRCUIT: Object :P1 will cause a loop in the Electrical structure.', newrec_.mch_code);
      END IF;
   END IF;
   -- Warranty Expires
   IF (newrec_.warr_exp IS NOT NULL) THEN
      IF (newrec_.purch_date IS NOT NULL) THEN
         IF (newrec_.purch_date > newrec_.warr_exp) THEN
            Error_SYS.Appl_General(lu_name_, 'PURAFTWARR: Purchase date (:P1) can not be later than warranty expiration date (:P2).', newrec_.purch_date, newrec_.warr_exp);
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
   --  Object Level
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      IF (newrec_.obj_level IS NOT NULL AND newrec_.obj_level != 'PRJDEL') THEN
         --if all sites dont ignore validation
         IF Check_Ignore_Obj_Lvl_All(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), newrec_.contract, newrec_.mch_code) = 'FALSE' THEN
            IF (NVL(obj_level_updated_,'FALSE') = 'TRUE') THEN
               Error_SYS.Appl_General(lu_name_, 'ALLSITESNOIGNR: "Ignore Object Level Validation" checkbox should be checked for all relevant sites');
            END IF;
            IF NOT Check_Object_Level__(newrec_.contract, newrec_.mch_code, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), newrec_.obj_level) THEN
               Error_SYS.Appl_General(lu_name_, 'CHKOBJLEV: Object level must be lower than the object level of the superior object.');
            END IF;
            --check new object level is eligible by comparing maintenance basic data
         ELSIF (NVL(obj_level_updated_,'FALSE') = 'TRUE') THEN
            IF (NOT Validate_New_Obj_Level___(current_obj_level_, newrec_.obj_level)) THEN
               Error_SYS.Appl_General(lu_name_, 'INVLDOBJLEVEL: "Allow Serials" or "Create PM" or "Create WO/Task/Task Step" option(s) are not allowed in Equipment Basic Data for the selected New Object Level. Therefore, this action cannot be continued.');
            END IF;
         END IF;
      END IF;
   END IF;
   -- if part number is entered, make sure that the manufacturer is valid for the part
   IF (newrec_.part_no IS NOT NULL) AND (newrec_.manufacturer_no IS NOT NULL) THEN
      Part_Manufacturer_API.Exist(newrec_.part_no, newrec_.manufacturer_no);
   END IF;
   -- ensure that installation date is always later than manufacture date
   IF (newrec_.manufactured_date IS NOT NULL) AND (newrec_.production_date IS NOT NULL) THEN
      IF (trunc(newrec_.manufactured_date) > trunc(newrec_.production_date)) THEN
         Error_SYS.Record_General(lu_name_, 'MANUFBEFOREPROD: Object (:P1) has an installation date earlier than manufactured date. This is not allowed.', newrec_.mch_code);
      END IF;
   END IF;

END Validate_Comb___;


-- Set_Operational_Status___
--   Set the operational_status for a functional object
--   If update_structure_ = TRUE the method will also set the operational_status
--   for all children of the object if the object is part of a structure.
PROCEDURE Set_Operational_Status___ (
   contract_              IN VARCHAR2,
   mch_code_              IN VARCHAR2,
   operational_status_db_ IN VARCHAR2,
   update_structure_      IN BOOLEAN,
   from_plant_design_     IN VARCHAR2 DEFAULT NULL,
   structure_type_        IN VARCHAR2 DEFAULT NULL)
IS
   -- EQUIPMENT_OBJECT was used to get the operational status of serials
   CURSOR get_all_func_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  sup_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = sup_contract
             AND PRIOR mch_code = sup_mch_code;

   CURSOR get_non_scrapped_func_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  sup_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = sup_contract
             AND PRIOR mch_code = sup_mch_code;
   
   CURSOR get_all_loc_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  location_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = location_contract
             AND PRIOR mch_code = location_mch_code;

   CURSOR get_non_scrapped_loc_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  location_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = location_contract
             AND PRIOR mch_code = location_mch_code;
            
   CURSOR get_all_frm_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  from_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = from_contract
             AND PRIOR mch_code = from_mch_code;

   CURSOR get_non_scrapped_frm_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  from_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = from_contract
             AND PRIOR mch_code = from_mch_code;
             
   CURSOR get_all_to_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  to_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = to_contract
             AND PRIOR mch_code = to_mch_code;

   CURSOR get_non_scrapped_to_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  to_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = to_contract
             AND PRIOR mch_code = to_mch_code;
   
   CURSOR get_all_process_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  process_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = process_contract
             AND PRIOR mch_code = process_mch_code;

   CURSOR get_non_scrapped_process_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  process_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = process_contract
             AND PRIOR mch_code = process_mch_code;
   
   CURSOR get_all_pipe_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  pipe_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = pipe_contract
             AND PRIOR mch_code = pipe_mch_code;

   CURSOR get_non_scrapped_pipe_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  pipe_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = pipe_contract
             AND PRIOR mch_code = pipe_mch_code;
             
   CURSOR get_all_electrical_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  circuit_mch_code IS NOT NULL
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = circuit_contract
             AND PRIOR mch_code = circuit_mch_code;

   CURSOR get_non_scrapped_electrical_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT
      WHERE  circuit_mch_code IS NOT NULL
      AND    operational_status_db <> 'SCRAPPED'
      START WITH contract = contract_
             AND mch_code = mch_code_
      CONNECT BY PRIOR contract   = circuit_contract
             AND PRIOR mch_code = circuit_mch_code;

             
   attr_           VARCHAR2(2000);
   objid_          EQUIPMENT_FUNCTIONAL.objid%TYPE;
   objversion_     EQUIPMENT_FUNCTIONAL.objversion%TYPE;
   oldrec_         EQUIPMENT_OBJECT_TAB%ROWTYPE;
   newrec_         EQUIPMENT_OBJECT_TAB%ROWTYPE;
   is_plant_obj_   VARCHAR2(5);
   info_           VARCHAR2(200);
   oldop_status_   VARCHAR2(100);
   newop_status_   VARCHAR2(100);
   indrec_         Indicator_Rec;
   TYPE equi_tab IS TABLE OF get_all_func_children%ROWTYPE;   
   temp_equipment_object_ equi_tab;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('OPERATIONAL_STATUS_DB', operational_status_db_, attr_);
   oldop_status_ := Get_Operational_Status(contract_,mch_code_);
   -- IF the functional object is from plant design
   -- call the appropriate status changing method in Plant_Object_Util_API
   $IF Component_Plades_SYS.INSTALLED $THEN
      is_plant_obj_ := Plant_Object_API.Object_Id_Exist(mch_code_, contract_);
      IF (is_plant_obj_ = 'True' AND from_plant_design_ IS NULL ) THEN
         IF (operational_status_db_ = 'PLANNED_FOR_OP') THEN
            Plant_Object_Util_API.Set_Planned_For_Operation(info_, mch_code_, attr_, contract_, operational_status_db_);
         ELSIF (operational_status_db_ = 'IN_OPERATION') THEN
            Plant_Object_Util_API.Set_In_Operation(info_, mch_code_, attr_, contract_, operational_status_db_);
         ELSIF (operational_status_db_ = 'OUT_OF_OPERATION') THEN
            Plant_Object_Util_API.Set_Out_Of_Operation(info_, mch_code_, attr_, contract_, operational_status_db_);
         ELSIF (operational_status_db_ = 'SCRAPPED') THEN
            Plant_Object_Util_API.Set_Scrapped(info_, mch_code_, attr_, contract_, operational_status_db_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END

   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, mch_code_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

   $IF Component_Pm_SYS.INSTALLED $THEN
      IF ((operational_status_db_ = 'SCRAPPED')) THEN
         Pm_Action_API.Set_Pm_To_Obsolete(contract_, mch_code_);
      END IF;
   $ELSE
      NULL;
   $END

   IF update_structure_ THEN
      IF (oldrec_.operational_status = 'SCRAPPED') THEN
         -- Update all children of the object.
         IF (structure_type_ = 'F' OR structure_type_ IS NULL OR structure_type_ = '') THEN 
            OPEN get_all_func_children;
            FETCH get_all_func_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_func_children;
         END IF;
         IF (structure_type_ = 'L') THEN 
            OPEN get_all_loc_children;
            FETCH get_all_loc_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_loc_children;
         END IF;
         IF (structure_type_ = 'R') THEN 
            OPEN get_all_frm_children;
            FETCH get_all_frm_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_frm_children;
         END IF;
         IF (structure_type_ = 'T') THEN 
            OPEN get_all_to_children;
            FETCH get_all_to_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_to_children;
         END IF;
         IF (structure_type_ = 'P') THEN 
            OPEN get_all_process_children;
            FETCH get_all_process_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_process_children;
         END IF;
         IF (structure_type_ = 'S') THEN 
            OPEN get_all_pipe_children;
            FETCH get_all_pipe_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_pipe_children;
         END IF;
         IF (structure_type_ = 'E') THEN 
            OPEN get_all_electrical_children;
            FETCH get_all_electrical_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_all_electrical_children;
         END IF;
         IF (temp_equipment_object_.COUNT > 0) THEN
            FOR i IN temp_equipment_object_.FIRST..temp_equipment_object_.LAST LOOP
               IF (temp_equipment_object_(i).obj_level IS NOT NULL) THEN    --functional child objects
                  Set_Operational_Status___(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code, operational_status_db_, FALSE);
               ELSE   --serial child objects
                  IF (operational_status_db_ = 'PLANNED_FOR_OP') THEN
                     Equipment_Serial_API.Set_Structure_Planned_For_Op(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'IN_OPERATION') THEN
                     IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(Equipment_Serial_API.Get_Part_No(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code), Equipment_Serial_API.Get_Serial_No(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code)) = 'OPERATIONAL'  AND Equipment_Object_API.Exist_Non_Operational_Parent(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code) = 'FALSE' THEN
                        Equipment_Serial_API.Set_Structure_In_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                     END IF;
                     Equipment_Serial_API.Set_Structure_In_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'OUT_OF_OPERATION') THEN
                     Equipment_Serial_API.Set_Structure_Out_Of_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'SCRAPPED') THEN
                     Equipment_Serial_API.Set_Structure_Scrapped(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  END IF;
               END IF;
            END LOOP;
         END IF;
      ELSE
         IF (structure_type_ = 'F' OR structure_type_ IS NULL OR structure_type_ = '') THEN 
            OPEN get_non_scrapped_func_children;
            FETCH get_non_scrapped_func_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_func_children;
         END IF;
         IF (structure_type_ = 'L') THEN 
            OPEN get_non_scrapped_loc_children;
            FETCH get_non_scrapped_loc_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_loc_children;
         END IF;
         IF (structure_type_ = 'R') THEN 
            OPEN get_non_scrapped_frm_children;
            FETCH get_non_scrapped_frm_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_frm_children;
         END IF;
         IF (structure_type_ = 'T') THEN 
            OPEN get_non_scrapped_to_children;
            FETCH get_non_scrapped_to_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_to_children;
         END IF;
         IF (structure_type_ = 'P') THEN 
            OPEN get_non_scrapped_process_children;
            FETCH get_non_scrapped_process_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_process_children;
         END IF;
         IF (structure_type_ = 'S') THEN 
            OPEN get_non_scrapped_pipe_children;
            FETCH get_non_scrapped_pipe_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_pipe_children;
         END IF;
         IF (structure_type_ = 'E') THEN 
            OPEN get_non_scrapped_electrical_children;
            FETCH get_non_scrapped_electrical_children BULK COLLECT INTO temp_equipment_object_;
            CLOSE get_non_scrapped_electrical_children;
         END IF;
         IF (temp_equipment_object_.COUNT > 0) THEN
            FOR i IN temp_equipment_object_.FIRST..temp_equipment_object_.LAST LOOP
               IF (temp_equipment_object_(i).obj_level IS NOT NULL) THEN    --functional child objects
                  Set_Operational_Status___(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code, operational_status_db_, FALSE);
               ELSE   --serial child objects
                  IF (operational_status_db_ = 'PLANNED_FOR_OP') THEN
                     Equipment_Serial_API.Set_Structure_Planned_For_Op(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'IN_OPERATION') THEN
                     IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(Equipment_Serial_API.Get_Part_No(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code), Equipment_Serial_API.Get_Serial_No(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code)) = 'OPERATIONAL'  AND Equipment_Object_API.Exist_Non_Operational_Parent(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code) = 'FALSE' THEN
                        Equipment_Serial_API.Set_Structure_In_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                     END IF;
                     Equipment_Serial_API.Set_Structure_In_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'OUT_OF_OPERATION') THEN
                     Equipment_Serial_API.Set_Structure_Out_Of_Operation(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  ELSIF (operational_status_db_ = 'SCRAPPED') THEN
                     Equipment_Serial_API.Set_Structure_Scrapped(temp_equipment_object_(i).contract, temp_equipment_object_(i).mch_code);
                  END IF;
               END IF;
            END LOOP;
         END IF;
      END IF;
   END IF;        
   newop_status_ := Get_Operational_Status(contract_,mch_code_);
   IF (oldop_status_ != 'Planned for Operation') THEN
      EQUIPMENT_OBJECT_JOURNAL_API.Add_Journal_Entry(mch_code_,contract_,oldop_status_,newop_status_,NULL,'STATUS_CHANGE');
   END IF;
END Set_Operational_Status___;


-- Get_Operational_Status___
--   Return the operational status for the specified functional.
FUNCTION Get_Operational_Status___ (
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.operational_status%TYPE;

   CURSOR get_attr IS
      SELECT operational_status
      FROM EQUIPMENT_OBJECT_TAB
      WHERE contract = contract_
      AND   mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Operational_Status___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'COMPANY', Site_API.Get_Company(User_Default_API.Get_Contract), attr_);
   Client_SYS.Add_To_Attr( 'CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr( 'SUP_CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr('IS_CATEGORY_OBJECT', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('IS_GEOGRAPHIC_OBJECT', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SAFE_ACCESS_CODE', Safe_Access_Code_API.Decode('NOT_REQUIRED'), attr_);
   Client_SYS.Add_To_Attr('PM_PROG_APPLICATION_STATUS', 'FALSE', attr_);

END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   design_object_ VARCHAR2(1) :='0';

BEGIN
   SELECT Equipment_Object_Seq.nextval INTO newrec_.Equipment_Object_Seq FROM dual;
   -- Unpack virtual attribute
   design_object_ := NVL(Client_SYS.Get_Item_Value('DESIGN_OBJECT', attr_),design_object_);

   IF (newrec_.operational_status IS NULL) THEN
      IF (design_object_ = '1' OR design_object_ = '4') THEN
         newrec_.operational_status := 'PLANNED_FOR_OP';
      ELSE
         newrec_.operational_status := 'IN_OPERATION';
      END IF;
   END IF;

   IF (newrec_.is_category_object IS NULL) THEN
      newrec_.is_category_object := 'FALSE';
   END IF;
   IF (newrec_.is_geographic_object IS NULL) THEN
      newrec_.is_geographic_object := 'FALSE';
   END IF;
   IF(newrec_.safe_access_code IS NULL) THEN
      newrec_.safe_access_code := 'NOT_REQUIRED';
   END IF;

   -- If location is null, set the parent object location by default.
   IF (newrec_.location_id IS NULL AND newrec_.functional_object_seq IS NOT NULL) THEN
      newrec_.location_id := Equipment_Object_API.Get_Location_Id(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
   END IF;

   super(objid_, objversion_, newrec_, attr_);


   -- Auto add to Service Contract if specified to do so in the parent objects service contracts.
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      $IF Component_Pcmsci_SYS.INSTALLED $THEN
         Psc_Srv_Line_Objects_API.Add_To_Service_Contract(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), newrec_.contract, newrec_.mch_code);
      $ELSE
         NULL;
      $END
   END IF;

   -- Added for inheritance of map positions from location
   IF ( newrec_.location_id IS NOT NULL ) THEN
      Equipment_Object_API.Inherit_Equip_Map_Position(newrec_);
   END IF;

   EQUIPMENT_OBJECT_JOURNAL_API.Add_Journal_Entry(newrec_.mch_code,newrec_.contract,NULL,newrec_.mch_code,NULL,'CREATED');
   Get_Id_Version_By_Keys___(objid_, newrec_.rowversion, newrec_.contract, newrec_.mch_code);

   Client_SYS.Add_To_Attr('OPERATIONAL_STATUS', Serial_Operational_Status_API.Decode(newrec_.operational_status), attr_);

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
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
   key_     VARCHAR2(2000);
   key_ref_ VARCHAR2(500);
   key_value_from_      VARCHAR2(2000);
   key_value_to_        VARCHAR2(2000);
   key_value_new_       VARCHAR2(2000);
   technical_class_     VARCHAR2(2000);
   technical_class_new_ VARCHAR2(2000);
   temp_mch_type_       VARCHAR2(20);
   new_mch_type_        VARCHAR2(20);
   child_attr_          VARCHAR2(2000);
   info_                VARCHAR2(2000);
   child_objid_         EQUIPMENT_FUNCTIONAL.objid%type;
   child_objver_        EQUIPMENT_FUNCTIONAL.objversion%type;
   new_tech_spec_no_    technical_object_reference.technical_spec_no%TYPE;
   indrec_     Indicator_rec;
   disconnect_pm_prog_   VARCHAR2(8);
   disconnect_attr_      VARCHAR2(32000);

      CURSOR get_children (equipment_object_seq_ IN NUMBER, location_id_ VARCHAR2) IS
      SELECT mch_code, contract, sup_mch_code, sup_contract, Equipment_Object_API.Get_Location_Id(sup_contract, sup_mch_code) as sup_location
      FROM equipment_object
      WHERE (location_id IS NULL OR location_id = location_id_)
      START WITH functional_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq order by level;

BEGIN
   Equipment_Object_Util_API.Check_Type_Status(newrec_.contract, newrec_.mch_code, Get_Mch_Type(newrec_.contract, newrec_.mch_code), newrec_.mch_type);
   
   disconnect_pm_prog_ := nvl(Client_SYS.Get_Item_Value('DISCONNECT_PM_PROG', attr_), 'FALSE');
   indrec_             := Get_Indicator_Rec___(oldrec_, newrec_);
   
   IF (indrec_.functional_object_seq) THEN
      IF (newrec_.functional_object_seq IS NOT NULL) THEN
         -- If parent is added, and the location is null, get the new parent's location OR
         -- If parent is changed, and the location is null or same as the previous parent's location, get the new parent's location.         
         IF ((newrec_.location_id IS NULL) OR NOT(indrec_.location_id OR Validate_SYS.Is_Changed(newrec_.location_id, Equipment_Object_API.Get_Location_Id(oldrec_.functional_object_seq)))) THEN
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

   $IF Component_Wo_SYS.INSTALLED AND Component_Mpbint_SYS.INSTALLED $THEN
      IF Mpb_Wo_Int_API.Obj_Has_Mpb_Wo(newrec_.contract, newrec_.mch_code) = 'TRUE' THEN
         IF(newrec_.criticality IS NULL AND oldrec_.criticality IS NOT NULL) OR (newrec_.criticality IS NOT NULL AND oldrec_.criticality IS NULL) OR
         ((newrec_.criticality IS NOT NULL AND oldrec_.criticality IS NOT NULL) AND (newrec_.criticality <> oldrec_.criticality) ) THEN
            Client_SYS.Add_Info('EquipmentFunctional','CHANGECRITICALITY: Changes to criticality will affect on Critical work check box in Work order/PM and it might result in critical order to become tardy. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         END IF;

         IF(newrec_.safe_access_code IS NULL AND oldrec_.safe_access_code IS NOT NULL) OR (newrec_.safe_access_code IS NOT NULL AND oldrec_.safe_access_code IS NULL) OR
         ((newrec_.safe_access_code IS NOT NULL AND oldrec_.safe_access_code IS NOT NULL) AND (newrec_.safe_access_code <> oldrec_.safe_access_code) ) THEN
            Client_SYS.Add_Info('EquipmentFunctional','CHANGESAFEACCESS: Changes to Safe Access Code or Operational Mode Group might result in overlaps with obstructive maintenance schedule. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         END IF;
      END IF;
   $END
   $IF Component_Opplan_SYS.INSTALLED $THEN
      --Remove inherited operational modes when Move Functional Object... is used.
      IF (newrec_.functional_object_seq != oldrec_.functional_object_seq) THEN
         Object_Oper_Mode_Group_API.Remove_Inherited(newrec_.equipment_object_seq);
      END IF;
   $END

   IF (nvl(newrec_.mch_name,'NULL') != nvl(oldrec_.mch_name,'NULL'))  THEN
      key_ := newrec_.equipment_object_seq || '^';
      key_ref_ := Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
      IF Maintenance_Document_Ref_API.Exist_Obj_Reference('EquipmentObject', key_) = 'TRUE' THEN
         Maintenance_Document_Ref_API.Refresh_Obj_Reference_Desc('EquipmentObject', key_ref_);
      END IF;
   END IF;

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

   -- Set the characteristics of the object to the characteristics of the object type
   -- whenever the object type is changed and has characteristics.
   IF ((indrec_.mch_type = TRUE) AND (newrec_.mch_type IS NOT NULL) AND (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObjType', key_value_from_) != -1)) THEN
      key_value_to_     := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
      IF (Technical_Object_Reference_API.Exist_Reference_( 'EquipmentObject', key_value_to_) = -1) THEN
         technical_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key('EquipmentObjType', key_value_from_);
         Technical_Object_Reference_API.Create_Reference_(new_tech_spec_no_, 'EquipmentObject', key_value_to_, technical_class_);
      END IF;
   END IF;

   -- Auto add to Service Contract when parent is changed and if that parent is connnected to a service contract auto add child objs is enabled .
   IF ((indrec_.functional_object_seq = TRUE) AND (newrec_.functional_object_seq IS NOT NULL)) THEN
      $IF Component_Pcmsci_SYS.INSTALLED $THEN
         Psc_Srv_Line_Objects_API.Add_To_Service_Contract(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq), newrec_.contract, newrec_.mch_code, 'TRUE', Equipment_Object_API.Get_Contract(oldrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(oldrec_.functional_object_seq));
      $ELSE
         NULL;
      $END
   END IF;

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
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   company_            VARCHAR2(20);
   key_value_from_     VARCHAR2(2000);
   key_value_to_       VARCHAR2(2000);
   costcent_           equipment_object_tab.cost_center%TYPE;
   design_object_      VARCHAR2(1) :='0';
   technical_class_    technical_object_reference.technical_class%TYPE;
   new_tech_spec_no_   technical_object_reference.technical_spec_no%TYPE;
   site_company_       SITE_TAB.company%TYPE;
BEGIN
   company_ := Client_SYS.Get_Item_Value('COMPANY',attr_);
   design_object_ := Client_SYS.Get_Item_Value('DESIGN_OBJECT',attr_);

   super(newrec_, indrec_, attr_);

--   IF (newrec_.sup_mch_code IS NULL) THEN
--      newrec_.sup_contract := NULL;
--   END IF;

   site_company_ := Site_API.Get_Company(newrec_.contract);
   IF (newrec_.cost_center IS NULL) THEN
      IF (newrec_.functional_object_seq IS NOT NULL AND newrec_.contract IS NOT NULL AND (Site_API.Get_Company(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq)) = site_company_)) THEN
         costcent_ := Equipment_Object_API.Get_Cost_Center(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
         newrec_.cost_center := costcent_;
      END IF;
   END IF;
   IF (newrec_.cost_center IS NOT NULL) THEN
       Maintenance_Accounting_API.Accounting_Codepart_Exist(site_company_,
                                                        'CostCenter', newrec_.cost_center);
   END IF;
   IF (newrec_.object_no IS NOT NULL) THEN
            Maintenance_Accounting_API.Accounting_Codepart_Exist(site_company_,
                                                                 'Object', newrec_.object_no);
   END IF;
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   IF (newrec_.location_object_seq IS NOT NULL) THEN
      Equipment_Functional_API.Exist(newrec_.location_object_seq);
   END IF;
   IF (newrec_.circuit_object_seq IS NOT NULL) THEN
      Equipment_Functional_API.Exist(newrec_.circuit_object_seq);
   END IF;
   Validate_Comb___(newrec_);

   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      IF (Object_Property_API.Get_Value( 'MaintenanceConfiguration', '*', 'INHERIT_OBJECT_ID' ) = 'TRUE') THEN
         Concatenate_Object__(newrec_.mch_code, Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
         Client_SYS.Add_To_Attr( 'MCH_CODE', newrec_.mch_code, attr_);
      END IF;
--   ELSE
--      Client_SYS.Add_To_Attr( 'SUP_CONTRACT', newrec_.sup_contract, attr_);
   END IF;

   Error_SYS.Check_Not_Null(lu_name_, 'MCH_NAME', newrec_.mch_name);
   Error_SYS.Check_Not_Null(lu_name_, 'OBJ_LEVEL', newrec_.obj_level);
   -- Error_SYS.Check_Not_Null(lu_name_, 'OPERATIONAL_STATUS', newrec_.operational_status);

   -- Set the characteristics of the object to the characteristics of the object type
   -- whenever the object type is changed and has characteristics.
   -- Check whether equipment object has a technical number before copy technical object values. Call Id 40610
   IF Equipment_object_api.has_technical_spec_no('EquipmentObject',(Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq))) = 'FALSE' THEN
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

   -- Add virtual attributes to the attr-string for further processing in the Insert___ method
   Client_SYS.Add_To_Attr( 'DESIGN_OBJECT', design_object_, attr_);
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));
   END IF;
   IF (newrec_.location_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.location_object_seq));
   END IF;
   IF (newrec_.from_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.from_object_seq));
   END IF;
   IF (newrec_.to_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.to_object_seq));
   END IF;
   IF (newrec_.process_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.process_object_seq));
   END IF;
   IF (newrec_.pipe_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.pipe_object_seq));
   END IF;
   IF (newrec_.circuit_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.circuit_object_seq));
   END IF;
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
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   key_value_to_   VARCHAR2(2000);
   technical_class_ VARCHAR2(2000);
   technical_spec_  NUMBER;
   total_count_    NUMBER;
   temp_mch_type_     VARCHAR2(20);
   new_mch_type_      VARCHAR2(20);
   yes_               VARCHAR2(10);
   object_id_         VARCHAR2(100);
   site_              VARCHAR2(5);
   costcent_          equipment_object_tab.cost_center%TYPE;
   sup_mch_updated_   VARCHAR2(5) := 'FALSE';
   key_value_new_        VARCHAR2(2000);
   technical_class_new_  VARCHAR2(2000);
   remove_requirements_  VARCHAR2(5);   
   obj_level_updated_    VARCHAR2(5);
   company_              SITE_TAB.company%TYPE;
BEGIN
   newrec_.rowstate := Client_SYS.Get_Item_Value('PLANT_DESIGN_STATE',attr_);
   remove_requirements_ := Client_SYS.Get_Item_Value('REMOVE_REQUIREMENTS',attr_);
   IF indrec_.functional_object_seq = TRUE THEN
      sup_mch_updated_     := 'TRUE';
      IF indrec_.OBJ_LEVEL = TRUE THEN
         obj_level_updated_ := 'TRUE';
      END IF;
   END IF;
   
   IF NOT (Client_SYS.Item_Exist('SKIP_CONTRACT_VALIDATION', attr_)) THEN
      Validate_SYS.Item_Update(lu_name_, 'CONTRACT', indrec_.contract);
   END IF; 
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
   company_ := Site_API.Get_Company(newrec_.contract);
   IF(Get_Cost_Center(newrec_.contract,newrec_.mch_code) IS NULL AND newrec_.cost_center IS NULL AND newrec_.functional_object_seq IS NOT NULL AND (Site_API.Get_Company(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq)) = company_)) THEN
      newrec_.cost_center := Get_Cost_Center(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
   END IF;
   key_value_to_     := CLIENT_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
   technical_class_  := TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObject',key_value_to_);
   technical_spec_   := TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Spec_No('EquipmentObject',key_value_to_);
   total_count_      := TECHNICAL_OBJECT_REFERENCE_API.Get_Defined_Count(technical_spec_,technical_class_);
   new_mch_type_     := newrec_.mch_type;
      /*IF new_mch_type_ IS NULL THEN
              new_mch_type_ :=' ' ;
      END IF; */
   temp_mch_type_    := Get_Mch_Type (newrec_.contract ,newrec_.mch_code );
   IF (new_mch_type_ IS NOT NULL) THEN
      key_value_new_     := CLIENT_SYS.Get_Key_Reference('EquipmentObjType', 'MCH_TYPE', new_mch_type_);
      IF (key_value_new_ IS NOT NULL) THEN
         technical_class_new_ :=TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Class_With_Key('EquipmentObjType',key_value_new_);
      END IF;
   END IF;
--
--   IF (newrec_.sup_mch_code IS NULL) THEN
--      newrec_.sup_contract := NULL;
--   END IF;

   object_id_ :=  newrec_.mch_code;
   site_ :=  newrec_.contract;

  IF( Equipment_Object_API.Get_Contract(newrec_.functional_object_seq) <> Get_Sup_Contract(newrec_.contract, newrec_.mch_code )) THEN
     IF (newrec_.cost_center IS NULL) THEN
      IF (newrec_.functional_object_seq IS NOT NULL AND newrec_.contract IS NOT NULL AND (Site_API.Get_Company(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq)) = company_)) THEN
           costcent_ := Equipment_Object_API.Get_Cost_Center(Equipment_Object_API.Get_Contract(newrec_.functional_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.functional_object_seq));
           newrec_.cost_center := costcent_;
      END IF;
     END IF;
  END IF;
  $IF Component_Pcmsci_SYS.INSTALLED $THEN
     IF (newrec_.is_geographic_object = 'FALSE' ) THEN
        yes_ := Psc_Contr_Product_Scope_API.Geo_Object_In_Use(object_id_, site_);
           IF (yes_ = 'True') THEN
              Error_SYS.Appl_General(lu_name_, 'FUNCOBJGEOOBJINUSE: Cannot set the object :P1 Non-Geographical due to the object is already used in one or more Service Lines in Service Contracts.', newrec_.mch_code);
           END IF;
     END IF;
  $ELSE
     NULL;
  $END

  Validate_Comb___(newrec_, sup_mch_updated_, obj_level_updated_, oldrec_.obj_level);

--   IF (newrec_.sup_mch_code IS NULL) THEN
--      Client_SYS.Add_To_Attr( 'SUP_CONTRACT', newrec_.sup_contract, attr_);
--   END IF;
   Client_SYS.Add_To_Attr( 'REMOVE_REQUIREMENTS', remove_requirements_, attr_);

   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
   Error_SYS.Check_Not_Null(lu_name_, 'MCH_CODE', newrec_.mch_code);
   Error_SYS.Check_Not_Null(lu_name_, 'MCH_NAME', newrec_.mch_name);
   Error_SYS.Check_Not_Null(lu_name_, 'OBJ_LEVEL', newrec_.obj_level);
   /*
   Error_SYS.Check_Not_Null(lu_name_, 'OPERATIONAL_STATUS', newrec_.operational_status);
   */
   IF (newrec_.cost_center IS NOT NULL) THEN
       Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
                                                            'CostCenter', newrec_.cost_center);
   END IF;
   IF (newrec_.object_no IS NOT NULL) THEN
            Maintenance_Accounting_API.Accounting_Codepart_Exist(company_,
                                                                 'Object', newrec_.object_no);
   END IF;
   IF (newrec_.functional_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.functional_object_seq));
   END IF;
   IF (newrec_.location_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.location_object_seq));
   END IF;
   IF (newrec_.from_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.from_object_seq));
   END IF;
   IF (newrec_.to_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.to_object_seq));
   END IF;
   IF (newrec_.process_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.process_object_seq));
   END IF;
   IF (newrec_.pipe_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.pipe_object_seq));
   END IF;
   IF (newrec_.circuit_object_seq IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.circuit_object_seq));
   END IF;
   
   $IF Component_Pcmstd_SYS.INSTALLED $THEN
      IF ((indrec_.process_class_id OR indrec_.item_class_id) AND newrec_.applied_pm_program_id IS NOT NULL) THEN
         IF (Pm_Program_Class_API.Check_Itm_Prcs_Cls_Comb(newrec_.applied_pm_program_id, newrec_.applied_pm_program_rev, newrec_.process_class_id, newrec_.item_class_id) = 'FALSE') THEN
            Client_SYS.Add_Warning(lu_name_, 'CANOTREMPROCITEM: A PM Program has been applied on this Object and if you change the value for process class or item class, the connection between the Object and the PM Program will also be removed.');
            Client_SYS.Add_To_Attr('DISCONNECT_PM_PROG', 'TRUE', attr_);            
         END IF;   
      END IF;   
   $END 

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN equipment_object_tab%ROWTYPE )
IS
   key_ref_ VARCHAR2(4000);
BEGIN
   key_ref_ := Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', remrec_.equipment_object_seq);
   Equipment_Object_API.Remove_Object_References(key_ref_);
   
   Map_Position_API.Remove_Position_For_Object('EquipmentObject', key_ref_);
   
   super(objid_, remrec_);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Concatenate_Object__ (
   mch_code_ IN OUT VARCHAR2,
   sup_mch_code_ IN VARCHAR2 )
IS

code_exist_          NUMBER;
obj_level_separator_ VARCHAR2(3) := Object_Property_API.Get_Value( 'MaintenanceConfiguration', '*', 'OBJ_LEVEL_SEPARATOR' );

CURSOR sup_mch_code_exist IS
   SELECT 1
   FROM   dual
   WHERE  sup_mch_code_||obj_level_separator_ =
      substr(mch_code_,1,length(sup_mch_code_)+length(obj_level_separator_));

BEGIN
   -- Check whether the superior object code already exist in
   -- the object code.
   OPEN sup_mch_code_exist;
   FETCH sup_mch_code_exist INTO code_exist_;
   IF (sup_mch_code_exist%NOTFOUND) THEN
      -- Change the mch_code value and add the superior object code to it.
      IF ( length(mch_code_) + length(sup_mch_code_) > 99 ) THEN
         Error_SYS.Appl_General(lu_name_, 'CODETRUNCED: The concatenated object id is exceeding 99 characters, hence the equipment object cannot be created');
      END IF;
      mch_code_ := sup_mch_code_||obj_level_separator_||mch_code_;
   END IF;
   CLOSE sup_mch_code_exist;
END Concatenate_Object__;


FUNCTION Check_Object_Level__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   sup_contract_ IN VARCHAR2,
   sup_mch_code_ IN VARCHAR2,
   obj_level_ IN VARCHAR2 ) RETURN BOOLEAN
IS
 sup_obj_level_      EQUIPMENT_OBJECT_TAB.obj_level%TYPE;
 sup_obj_seq_        NUMBER;
 obj_seq_            NUMBER;
BEGIN
   IF (sup_mch_code_ IS NULL) THEN
      RETURN (TRUE);
   ELSE
      sup_obj_level_ := Get_Obj_Level(sup_contract_, sup_mch_code_);
      sup_obj_seq_ := EQUIPMENT_OBJECT_LEVEL_API.Get_Level_Seq(sup_obj_level_);
      obj_seq_ := EQUIPMENT_OBJECT_LEVEL_API.Get_Level_Seq(obj_level_);
      IF (obj_seq_ <= sup_obj_seq_) THEN
         RETURN (FALSE);
      ELSE
         RETURN (TRUE);
      END IF;
   END IF;
END Check_Object_Level__;

PROCEDURE Copy__ (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_ IN VARCHAR2,
   destination_object_name_ IN VARCHAR2,
   destination_belongs_to_contr_ IN VARCHAR2,
   destination_belongs_to_object_ IN VARCHAR2,
   object_spare_ IN NUMBER,
   object_attr_ IN NUMBER,
   object_parameter_ IN NUMBER,
   object_test_pnt_ IN NUMBER,
   object_document_ IN NUMBER,
   object_pm_plan_ IN NUMBER,
   object_party_ IN NUMBER DEFAULT 0)
IS
   dest_contract_ EQUIPMENT_OBJECT_TAB.CONTRACT%TYPE;
   dest_object_ EQUIPMENT_OBJECT_TAB.MCH_CODE%TYPE;
BEGIN
   dest_contract_ := destination_contract_;
   dest_object_ := destination_object_;

   EQUIPMENT_OBJECT_UTIL_API.Copy_Functional_Object(dest_contract_,
                                                    dest_object_,
                                                    destination_object_name_,
                                                    source_contract_,
                                                    source_object_,
                                                    destination_belongs_to_contr_,
                                                    destination_belongs_to_object_,
                                                    object_spare_,
                                                    object_attr_,
                                                    object_parameter_,
                                                    object_test_pnt_,
                                                    object_document_,
                                                    object_pm_plan_,
                                                    object_party_);

END Copy__;


FUNCTION Check_Individual_Aware__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
obj_level_ EQUIPMENT_OBJECT_TAB.obj_level%TYPE;
BEGIN
   obj_level_ := Get_Obj_Level(contract_, mch_code_);
   IF (Equipment_Object_Level_API.Get_Individual_Aware(obj_level_) = Individual_Aware_API.Get_Client_Value(1) )THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Check_Individual_Aware__;


PROCEDURE New_Object__ (
   mch_code_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_name_ IN VARCHAR2,
   obj_level_ IN VARCHAR2,
   mch_type_ IN VARCHAR2,
   group_id_ IN VARCHAR2,
   type_ IN VARCHAR2,
   sup_contract_ IN VARCHAR2,
   sup_mch_code_ IN VARCHAR2,
   cost_center_ IN VARCHAR2,
   mch_loc_ IN VARCHAR2,
   mch_pos_ IN VARCHAR2,
   structure_type_   IN    VARCHAR2 DEFAULT NULL,
   owner_            IN    VARCHAR2 DEFAULT NULL)
IS
   info_            VARCHAR2(2000);
   objid_           VARCHAR2(20);
   objversion_      VARCHAR2(2000);
   lu_rec_          EQUIPMENT_OBJECT_TAB%ROWTYPE;
   attr2_           VARCHAR2(32000);
   party_type_      VARCHAR2(20);
   equipment_object_seq_ NUMBER;

BEGIN
   lu_rec_.contract  := contract_;
   lu_rec_.mch_code  := mch_code_;
   lu_rec_.mch_name  := mch_name_;
   lu_rec_.obj_level := obj_level_;
   lu_rec_.mch_type  := mch_type_;
   lu_rec_.group_id  := group_id_;
   lu_rec_.type      := type_;
   lu_rec_.mch_loc   := mch_loc_;
   lu_rec_.mch_pos   := mch_pos_;
   equipment_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_);

   IF(structure_type_ = 'L') THEN
      lu_rec_.location_object_seq := equipment_object_seq_;
   END IF;
   IF(structure_type_ = 'R')THEN
      lu_rec_.from_object_seq := equipment_object_seq_;
   END IF;
   IF(structure_type_ = 'T')THEN
      lu_rec_.to_object_seq := equipment_object_seq_;
   END IF;
   IF(structure_type_ = 'P')THEN
      lu_rec_.process_object_seq := equipment_object_seq_;
   END IF;
   IF(structure_type_ = 'S')THEN
      lu_rec_.pipe_object_seq := equipment_object_seq_;
   END IF;
   IF(structure_type_ = 'E')THEN
      lu_rec_.circuit_object_seq := equipment_object_seq_;
   END IF;
   IF (structure_type_ IS NULL OR structure_type_ = 'F') THEN
      lu_rec_.functional_object_seq := equipment_object_seq_;
   END IF;


   IF (contract_ IS NOT NULL AND Equipment_Object_API.Get_Contract(equipment_object_seq_) IS NOT NULL AND (Site_API.Get_Company(contract_) =Site_API.Get_Company(Equipment_Object_API.Get_Contract(equipment_object_seq_)))) THEN
      lu_rec_.cost_center := cost_center_;
   END IF;
   New___(lu_rec_);
   equipment_object_seq_ := lu_rec_.equipment_object_seq;
   IF (owner_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr2_);
      Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', equipment_object_seq_,  attr2_);
      party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
      Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,  attr2_);
      Client_SYS.Add_To_Attr('IDENTITY', owner_,  attr2_);
      EQUIPMENT_OBJECT_PARTY_API.New__(info_, objid_, objversion_, attr2_, 'DO');
   END IF;
END New_Object__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Operational_Status_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Operational_Status___(contract_, mch_code_);
END Get_Operational_Status_Db;


-- Get_Operational_Status
--   Return the value for operational status for the specified functional.
@UncheckedAccess
FUNCTION Get_Operational_Status (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.operational_status%TYPE;
   CURSOR get_attr IS
      SELECT operational_status
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  contract = contract_
      AND   mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Serial_Operational_Status_API.Decode(temp_);
END Get_Operational_Status;

@UncheckedAccess
FUNCTION Get_Requirements (
   lu_name_  IN VARCHAR2,
   from_lu_  IN VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   mch_code_key_value_ VARCHAR2(4000);
   type_key_value_     VARCHAR2(4000);
   CURSOR get_attr IS
   SELECT mch_code_key_value, type_key_value
   INTO mch_code_key_value_, type_key_value_
   FROM EQUIPMENT_FUNCTIONAL_UIV 
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
END Get_Requirements;

@UncheckedAccess
FUNCTION Get_Documents (
   lu_name_  IN VARCHAR2,
   from_lu_  IN VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   mch_code_key_value_ VARCHAR2(4000);
   type_key_value_     VARCHAR2(4000);
   CURSOR get_attr IS
   SELECT mch_code_key_value, type_key_value
   INTO mch_code_key_value_, type_key_value_
   FROM EQUIPMENT_FUNCTIONAL_UIV 
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

PROCEDURE Remove_Document_Structure(
   contract_ VARCHAR2,
   mch_code_ VARCHAR2)
IS
   key_ VARCHAR2(2000);
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_all_children IS
      SELECT contract, mch_code
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  functional_object_seq IS NOT NULL
      START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;

BEGIN

   FOR next_child_ IN get_all_children LOOP
      key_ := next_child_.contract || '^' || next_child_.mch_code || '^';
      IF Maintenance_Document_Ref_API.Exist_Obj_Reference('EquipmentObject', key_) = 'TRUE' THEN
         Maintenance_Document_Ref_API.Delete_Obj_Reference('EquipmentObject', key_);
      END IF;
   END LOOP;

END Remove_Document_Structure;


PROCEDURE Get_Objid (
   objid_ OUT VARCHAR2,
   mch_name_ OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   temp_objid_ ROWID;
   temp_mch_name_ EQUIPMENT_OBJECT_TAB.mch_name%TYPE;
CURSOR get_attr IS
   SELECT rowid, mch_name
   FROM EQUIPMENT_OBJECT_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_objid_, temp_mch_name_;
   CLOSE get_attr;
   objid_ := temp_objid_;
   mch_name_ := temp_mch_name_;
END Get_Objid;

@UncheckedAccess
FUNCTION Do_Exist (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF ( Check_Exist___(contract_, mch_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Do_Exist;


@UncheckedAccess
FUNCTION Has_Structure (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
CURSOR mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  functional_object_seq = Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

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


FUNCTION Is_Address (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Equipment_Object_API.Is_Address__(contract_, mch_code_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Address;


@UncheckedAccess
FUNCTION Has_Warranty (
   equipment_object_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_date_   DATE := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_));
BEGIN
   RETURN OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
END Has_Warranty;

@UncheckedAccess
FUNCTION Has_Warranty (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_date_   DATE := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(contract_));
BEGIN
   RETURN OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), temp_date_);
END Has_Warranty;

@UncheckedAccess
FUNCTION Has_Customer_Warranty (
   equipment_object_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_date_   DATE := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_));
BEGIN
   RETURN OBJECT_CUST_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
END Has_Customer_Warranty;

@UncheckedAccess
FUNCTION Has_Customer_Warranty (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_date_   DATE := Maintenance_Site_Utility_API.Get_Site_Date(contract_);
BEGIN
   RETURN OBJECT_CUST_WARRANTY_API.Has_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), temp_date_);
END Has_Customer_Warranty;

PROCEDURE Create_Object (
   attr_ IN OUT VARCHAR2 )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
BEGIN
   New__ (info_, objid_, objversion_, attr_, 'DO');
   Client_SYS.Add_To_Attr('OBJID', objid_, attr_);
   Client_SYS.Add_To_Attr('OBJVERSION', objversion_, attr_);
END Create_Object;

PROCEDURE Modify_Object (
   attr_ IN OUT VARCHAR2,
   objversion_  IN OUT VARCHAR2,
   objid_   IN VARCHAR2 )
IS
   info_         VARCHAR2(2000);
BEGIN
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Modify_Object;


PROCEDURE Create_Construction_Object (
   attr_ IN OUT VARCHAR2)
IS
   info_          VARCHAR2(2000);
   objid_         ROWID;
   objversion_    VARCHAR2(2000);
   newrec_        EQUIPMENT_OBJECT_TAB%ROWTYPE;
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         newrec_.contract := value_;
      ELSIF (name_ = 'MCH_CODE') THEN
         newrec_.mch_code := value_;
      ELSIF (name_ = 'MCH_NAME') THEN
         newrec_.mch_name := value_;
      ELSIF (name_ = 'PART_NO') THEN
         newrec_.part_no := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         newrec_.mch_serial_no := value_;
      ELSIF (name_ = 'FUNCTIONAL_OBJECT_SEQ') THEN
         newrec_.functional_object_seq := value_;
      END IF;
   END LOOP;
   Client_SYS.Add_To_Attr('DESIGN_OBJECT', '1', attr_);
   New__ (info_, objid_, objversion_, attr_, 'DO');
END Create_Construction_Object;


@UncheckedAccess
FUNCTION Get_Criticality_Description (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
criticality_ EQUIPMENT_OBJECT_TAB.criticality%TYPE;
BEGIN
   criticality_ := Get_Criticality(contract_,mch_code_);
   RETURN EQUIPMENT_CRITICALITY_API.Get_Description(criticality_);
END Get_Criticality_Description;


-- Set_Planned_For_Operation
--   Set the operational_status for a functional to 'Planned for Operation'
PROCEDURE Set_Planned_For_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'PLANNED_FOR_OP', FALSE,from_plant_design_);
END Set_Planned_For_Operation;


-- Set_In_Operation
--   Set the operational_status for a functional to 'In Operation'
PROCEDURE Set_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'IN_OPERATION', FALSE,from_plant_design_);
END Set_In_Operation;


-- Set_Out_Of_Operation
--   Set the operational_status for a functional to 'Out of Operation'
PROCEDURE Set_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'OUT_OF_OPERATION', FALSE,from_plant_design_);
END Set_Out_Of_Operation;


-- Set_Scrapped
--   Set the operational_status for a functional to 'Scrapped'
PROCEDURE Set_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF (contract_ IS NOT NULL AND mch_code_ IS NOT NULL) THEN
      Equipment_Object_Util_API.Check_Scrap_Allowed(contract_, mch_code_, TRUE);
   END IF;
   Set_Operational_Status___(contract_, mch_code_, 'SCRAPPED', FALSE,from_plant_design_);
END Set_Scrapped;


-- Is_Planned_For_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   functional = 'Planned for Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Planned_For_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(contract_, mch_code_) = 'PLANNED_FOR_OP') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Planned_For_Operation;


-- Is_In_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   functional = 'In Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(contract_, mch_code_) = 'IN_OPERATION') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_In_Operation;


-- Is_Out_Of_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   functional = 'Out of Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(contract_, mch_code_) = 'OUT_OF_OPERATION') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Out_Of_Operation;


-- Is_Scrapped
--   Return the string value 'TRUE' if operational status for the specified
--   functional = 'Scrapped', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(contract_, mch_code_) = 'SCRAPPED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Scrapped;


PROCEDURE Has_Document (
   rcode_ OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Equipment_Object_API.Has_Document(rcode_, contract_, mch_code_);
END Has_Document;


-- Set_Structure_Planned_For_Op
--   Set the operational_status for a functional to 'Planned for Operation'
--   All the children of the functional will also be updated.
PROCEDURE Set_Structure_Planned_For_Op (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL, 
   structure_type_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'PLANNED_FOR_OP', TRUE, NULL, structure_type_);
END Set_Structure_Planned_For_Op;


-- Set_Structure_In_Operation
--   Set the operational_status for a functional to 'In Operation'
--   All the children of the functional will also be updated.
PROCEDURE Set_Structure_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL, 
   structure_type_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'IN_OPERATION', TRUE, NULL, structure_type_);
END Set_Structure_In_Operation;


-- Set_Structure_Out_Of_Operation
--   Set the operational_status for a functional to 'Out of Operation'
--   All the children of the functional will also be updated.
PROCEDURE Set_Structure_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL, 
   structure_type_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Set_Operational_Status___(contract_, mch_code_, 'OUT_OF_OPERATION', TRUE, NULL, structure_type_);
END Set_Structure_Out_Of_Operation;


-- Set_Structure_Scrapped
--   Set the operational_status for a functional to 'Scrapped'
--   All the children of the functional will also be updated.
PROCEDURE Set_Structure_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_plant_design_ IN VARCHAR2 DEFAULT NULL, 
   structure_type_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (contract_ IS NOT NULL AND mch_code_ IS NOT NULL) THEN
      Equipment_Object_Util_API.Check_Scrap_Allowed(contract_, mch_code_, FALSE);
   END IF;
   Set_Operational_Status___(contract_, mch_code_, 'SCRAPPED', TRUE, NULL, structure_type_);
END Set_Structure_Scrapped;


PROCEDURE Update_Functional_Object(
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   mch_name_         IN VARCHAR2,
   action_           IN VARCHAR2,
   inherit_          IN VARCHAR2,
   from_contract_    IN VARCHAR2,
   from_mch_         IN VARCHAR2,
   to_contract_      IN VARCHAR2,
   to_mch_           IN VARCHAR2,
   remove_doc_str_   IN VARCHAR2 DEFAULT 'FALSE',
   new_object_level_ IN VARCHAR2 DEFAULT NULL)

IS
   objid_            EQUIPMENT_FUNCTIONAL.objid%type;
   objversion_       EQUIPMENT_FUNCTIONAL.objversion%type;
   attr_             VARCHAR2(2000);
   childs_attr_      VARCHAR2(2000);
   info_             VARCHAR2(2000);
   
   cost_center_      EQUIPMENT_OBJECT_TAB.cost_center%TYPE;
   sup_company_      site.company%TYPE;

   CURSOR get_all_children IS
      SELECT objid, objversion,contract, mch_code, obj_level, equipment_object_seq
        FROM Equipment_Object
       WHERE ((mch_code,contract)
               IN (SELECT mch_code,contract
                     FROM Equipment_Object
                       START WITH   sup_mch_code = mch_code_ AND sup_contract = contract_
                       CONNECT BY PRIOR mch_code = sup_mch_code AND PRIOR contract = sup_contract));

BEGIN
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      IF (Psc_Contr_Product_Util_API.Check_Srv_Line_Usage_All_Obj(contract_, mch_code_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'OBJECTUSED: Object is already used in a Pm Action or Work Order.');
      END IF;
   $END
   $IF Component_Svcsch_SYS.INSTALLED $THEN
      Svcsch_Object_Preference_API.Remove_Structure_Preferences(contract_, mch_code_,to_contract_,to_mch_);
   $END
   Get_Id_Version_By_Keys___(objid_,objversion_,contract_,mch_code_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MCH_NAME'    , mch_name_,    attr_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', to_mch_,      attr_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', to_contract_, attr_);
   Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(to_contract_, to_mch_), attr_);
   
   --if both object level & to_mch is sent from client, then added to attr. This will be validated later inside Modify__
   IF to_mch_ IS NOT NULL AND new_object_level_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('OBJ_LEVEL', new_object_level_, attr_);
   END IF;   
   
   cost_center_    := Equipment_Object_API.get_Cost_Center( to_contract_, to_mch_ );
   sup_company_    := Site_API.Get_Company(to_contract_);

   IF inherit_= 'TRUE' THEN

      IF Site_API.Get_Company(contract_) = sup_company_ THEN
         client_sys.Add_To_Attr('COST_CENTER', cost_center_, attr_);
      END IF;
   END IF;
   
   Modify__(info_,objid_,objversion_, attr_,'DO');

   Client_SYS.Clear_Attr(childs_attr_);
   Client_SYS.Add_To_Attr('COST_CENTER', cost_center_, childs_attr_);
   FOR next_child_ IN get_all_children LOOP
      IF Site_API.Get_Company(next_child_.contract) = sup_company_
         AND (inherit_= 'TRUE' OR inherit_= 'FALSE' AND Get_Cost_Center(next_child_.contract,next_child_.mch_code) IS NULL )THEN
         attr_ := childs_attr_;
         IF next_child_.obj_level IS NULL THEN 
            objid_ := next_child_.objid;
            objversion_ := next_child_.objversion;           
         ELSE
            Get_Id_Version_By_Keys___(objid_,objversion_,next_child_.contract,next_child_.mch_code);
         END IF;
         Equipment_Object_API.Modify__(info_,objid_,objversion_,attr_,'DO');
      END IF;
      
      $IF Component_Svcsch_SYS.INSTALLED $THEN
         Svcsch_Object_Availability_API.Remove_Inherited_Obj_Avail(next_child_.equipment_object_seq);
      $END
   END LOOP;


   IF remove_doc_str_ = 'TRUE' THEN
      Remove_Document_Structure(contract_, mch_code_);
   END IF;

   $IF Component_Svcsch_SYS.INSTALLED $THEN
      Svcsch_Object_Availability_API.Remove_Inherited_Obj_Avail(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
   $ELSE
     NULL;
   $END

   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      Psc_Srv_Line_Objects_API.Remove_From_Structure(contract_, mch_code_);
      Psc_Srv_Line_Objects_API.Add_Obj_Struc_To_Ser_Contract(to_contract_, to_mch_, contract_, mch_code_);
   $ELSE
      NULL;
   $END
END Update_Functional_Object;

FUNCTION Get_Position_Type (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   mch_type_ equipment_object_tab.mch_type%TYPE;
BEGIN
   mch_type_ := Equipment_Functional_API.Get_Mch_Type(contract_, mch_code_);
   RETURN Equipment_Obj_Type_API.Get_Position_Type(mch_type_);
END Get_Position_Type;

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

PROCEDURE Move_Functional_Object(
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   mch_name_         IN VARCHAR2,
   action_           IN VARCHAR2,
   inherit_cost_ctr_ IN VARCHAR2,
   from_contract_    IN VARCHAR2,
   from_mch_         IN VARCHAR2,
   to_contract_      IN VARCHAR2,
   to_mch_           IN VARCHAR2,
   remove_doc_conn_  IN VARCHAR2,
   comment_          IN VARCHAR2,
   new_obj_level_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN 
   Update_Functional_Object(contract_, mch_code_, mch_name_, action_, inherit_cost_ctr_, from_contract_, from_mch_, to_contract_, to_mch_, remove_doc_conn_, new_obj_level_);
   Equipment_Object_Journal_API.Move_Func_obj(mch_code_, contract_, to_mch_, to_contract_, from_mch_, from_contract_, comment_);
END Move_Functional_Object;

@UncheckedAccess
FUNCTION Check_Ignore_Obj_Lvl_All (
   new_parent_contract_ IN VARCHAR2,
   moving_mch_contract_ IN VARCHAR2, 
   moving_mch_code_     IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_all_children IS
      SELECT DISTINCT contract
      FROM   EQUIPMENT_OBJECT
      WHERE  sup_mch_code IS NOT NULL
      START WITH contract = moving_mch_contract_
             AND mch_code = moving_mch_code_
      CONNECT BY PRIOR contract   = sup_contract
             AND PRIOR mch_code = sup_mch_code;
BEGIN
   IF (NVL(Site_Mscom_Info_API.Get_Ignore_Obj_Lvl_Vld_Db(new_parent_contract_),Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN 'FALSE';
   END IF;
   IF (NVL(Site_Mscom_Info_API.Get_Ignore_Obj_Lvl_Vld_Db(moving_mch_contract_),Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN 'FALSE';
   END IF;
   FOR next_child_ IN get_all_children LOOP
      IF (NVL(Site_Mscom_Info_API.Get_Ignore_Obj_Lvl_Vld_Db(next_child_.contract),Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_FALSE) THEN
         RETURN 'FALSE';
      END IF;
   END LOOP;
   RETURN 'TRUE';
END Check_Ignore_Obj_Lvl_All; 

--below method to check create pm, create wo, serails allowed, validity of new object level
FUNCTION Validate_New_Obj_Level___ (
   current_obj_level_ IN VARCHAR2,
   new_obj_level_     IN VARCHAR2) RETURN BOOLEAN
IS
   CURSOR validate_obj_level(obj_level_ VARCHAR2) IS
      SELECT rowstate, individual_aware, create_pm, create_wo
      FROM equipment_object_level_tab 
      WHERE OBJ_LEVEL = obj_level_;
   
   new_level_rec_     validate_obj_level%ROWTYPE;
   current_level_rec_ validate_obj_level%ROWTYPE; 
BEGIN
   OPEN validate_obj_level(new_obj_level_);
   FETCH validate_obj_level INTO new_level_rec_;
   CLOSE validate_obj_level;
   
   IF new_level_rec_.rowstate NOT IN ('Blocked') THEN 
      OPEN validate_obj_level(current_obj_level_);
      FETCH validate_obj_level INTO current_level_rec_;
      CLOSE validate_obj_level;
      
      IF new_level_rec_.individual_aware = '1' AND current_level_rec_.individual_aware = '2' THEN
         RETURN FALSE;
      END IF;
      IF new_level_rec_.create_pm = 'FALSE' AND current_level_rec_.create_pm = 'TRUE' THEN
         RETURN FALSE;
      END IF;
      IF new_level_rec_.create_wo = 'FALSE' AND current_level_rec_.create_wo = 'TRUE' THEN
         RETURN FALSE;
      END IF;
   ELSE
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Validate_New_Obj_Level___; 


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
   Error_SYS.Fnd_Too_Many_Rows(Equipment_Functional_API.lu_name_, NULL, methodname_);
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
   Error_SYS.Fnd_Record_Not_Exist(Equipment_Functional_API.lu_name_);
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
   Error_SYS.Fnd_Record_Locked(Equipment_Functional_API.lu_name_);
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
   Error_SYS.Fnd_Record_Removed(Equipment_Functional_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Keys___
--    Locks a database row based on the primary key values.
--    Waits until record released if locked by another session.
FUNCTION Lock_By_Keys___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN equipment_object_tab%ROWTYPE
IS
   rec_        equipment_object_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  equipment_object_tab
         WHERE contract = contract_
         AND   mch_code = mch_code_
         AND   rowtype LIKE '%EquipmentFunctional'
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(contract_, mch_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(contract_, mch_code_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN equipment_object_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        equipment_object_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  equipment_object_tab
         WHERE contract = contract_
         AND   mch_code = mch_code_
         AND   rowtype LIKE '%EquipmentFunctional'
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(contract_, mch_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(contract_, mch_code_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(contract_, mch_code_);
   END;
END Lock_By_Keys_Nowait___;

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
   RETURN Get_Location_Mch_Code(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
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


-- Get_Obj_Level
--   Fetches the ObjLevel attribute for a record.
@UncheckedAccess
FUNCTION Get_Obj_Level (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Obj_Level(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Obj_Level;

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

-- End: Methods to facilitate the references using CONTRACT, MCH_CODE business key