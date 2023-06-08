-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObject
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950717  SLKO    Recreated. Concatenated .PKG and .APY files.
--                  For the previous history trace look into MSMCH.PKY
--                  and MSMCH.APY files from the STD_0100ALPHA2 release.
--  950717  SLKO    Changed exception names in the Move procedure, because of
--                  having the same name as other procedures.
--  950724  SLKO    Changes according to the new standard of the LU definition.
--  950810  NILA    Commented IF-statement in function Get_Description
--                  which caused error 'ORA-01002: fetch out of sequence' in
--                  SQLWindows client.
--  950822  NILA    Moved creation of view from script into package. Added
--                  comments of view.
--  950824  NILA    Added Decode/Encode function calls in view and procedures
--                  Unpack_Check_Insert___ and Unpack_Check_Update___ for
--                  column MAIN_POS.
--  950829  NILA    Added procedure Validate_Column___.
--  950830  NILA    Added procedure Validate_Comb___.
--  950831  NILA    Added EXIT at end of file and modified procedure Exist not
--                  to validate NULL values.
--  950906  NILA    Moved Encode-statements from Unpack_Check_Insert___ and
--                  Unpack_Check_Update___ to procedures Insert___ and
--                  Update___.
--  950912  NILA    Added functions Has_Structure and Has_Connection. Added
--                  columns HAS_STRUCTURE and HAS_CONNECTION with function
--                  calls in view. Added call to MSLANG.DEF which is used to
--                  define YES_NO_SHORT_0 and YES_NO_SHORT_1 used in
--                  Has_Structure and Has_Connection functions.
--  951004  NILA    Added procedure Has_Warranty and function Has_Warranty.
--  951018  NILA    Recreated using Base Table to Logical Unit Generator 1.0.
--  951024  OYME    Changed functions Has_Structure and Has_Connection to
--                  the strings TRUE/FALSE instead of YES_NO-values. Also
--                  Changed the view to use Translate_Boolean not Yes_No_API
--                  on the columns calling Has_Connection and Has_Structure.
--  951027  NILA    Changed function Has_Warranty to return string
--                  'TRUE'/'FALSE' instead of YES_NO-values. Modified view
--                  comments on column MCH_CODE to /UPPERCASE. Removed call to
--                  language file. (mslang.def)
--  951030  NILA    Added column HAS_WARRANTY. Added view comments for columns
--                  using function calls.
--  951031  NILA    Corrected reference parameter to column MCH_TYPE in view
--                  comments.
--  951102  JOSC    Added procedure Get_Obj_Level. Added Has_Document procedure
--                  to handle connection toward MS_DOCREF_API package.
--  951106  NILA    Added calls to procedures Check_Type_Status and
--                  Mch_Type_Exchange in procedure Update___.
--  951116  NILA    Added function Get_Group.
--  951213  NILA    Added column MAIN_POS in list of values.
--  951220  NILA    Added procedure Get_Client_Object_Level.
--  960124  TOWI    Added reference and exist control to accounting codeparts.
--  960131  ADBR    Changed Check_Type_Status with NVL on comparing mch_type.
--  960215  NILA    Ref 96-0023: Moved Exist check of columns COST_CENTER and
--                  OBJECT_NO to procedure Validate_Comb___ due to parent key.
--  960219  JOAN    Added procedure Report_Structure.
--  960229  STOL    Added procedure Copy__.
--  960307  STOL    Added function Has_Spare_Part.
--                  Added column HAS_SPARE_PART in view.
--  960325  ADBR    Ref 96-0076 Added column db_obj_level.
--  960325  JOAN    Added procedure Report_Detail.
--  960425  ADBR    Ref 96-0076 Added procedure Get_Db_Object_Level.
--  960520  JOSC    Added INIT procedure.
--  960521  JOSC    Removed SYS4 dependencies and added call to Init_Method.
--  960614  JOSC    Replaced start statements with define statements.
--  960617  STOL    Added 'COMPANY' to attr_ in proc. Copy__.
--  960902  NILA    Ref 96-0171: Removed where-statement procedure
--                  Get_Superior_Defaults.
--                  Changed parameter name in message in procedure
--                  Get_Superior_Defaults to sup_mch_code_.
--  960930  ADBR    Recreated from Rose model using Developer's Workbench.
--  961017  ADBR    Added columns Has_Structure and Has_Connection.
--  961023  ADBR    Added columns Mch_Code_Key_Value and Type_Key_Value used by Doc.
--  961029  CAJO    Changed procedure Move__ according to changes in dialog Move Individual.
--  961114  ADBR    Changed company to insertable.
--  961114  ADBR    Changed equipment_object_level to obj_level and changed Has_Documents.
--  961204  ADBR    Added dynamic call to PM_ACTION_API.COPY.
--  961215  NILA    Added function Do_Exist.
--  961219  ADBR    Removed company from Maintenance_Supplier_API.Exist.
--  961219  ADBR    Merged with new templates.
--  970107  ADBR    Moved validation of cost_center and object_no.
--  970224  ADBR    Added Site_LOV view.
--  970224  JOSC    Made dynamic calls against ACCRUL API.
--  970401  TOWI    Adjusted to new templates in Foundation1 1.2.2c.
--  970411  TOWI    For more flexibel security settings, is now the procedure Update_Amount
--                  responsible for its own update and no call is made to Modify__.
--  970415  TOWI    Prefix &PKG is taken away from the New___ call in method Copy__.
--  970527  TOWI    Changed Obj_Level column from IID-column to a normal column.
--                  Removed column Obj_Level_Db.
--  970606  JOSC    Ref 97-0002: Amount is not added when copying equipment object.
--  970606  JOSC    Ref 97-0026: Improved concatenate_object__ cursor check.
--  970613  JOSC    Ref 97-0040: Removed commas in messages.
--  970815  ERJA    Changed mch_serial_no to serial_no in view.
--  970826  STSU    Changed procedures When_New_Mch__/Move__, new serial history creation.
--  970902  CAJO    Added part_no in procedures When_New_Mch__ and Move__.
--  970904  CAJO    Changed view to union between Equipment_Functional and Equipment_Serial.
--  970908  CAJO    Moved procedure Move__ to EquipmentSerial.
--  970910  CAJO    Removed procedure Copy_.
--  970919  CAJO    Converted to F1 2.0. Changed table name to equipment_object_tab.
--  970923  ERJA    Changed view back to equipment_object_tab.
--  970925  TOWI    Added function Get_Sup_Mch_Name and changed Get_Mch_Name.
--  970929  ERJA    Added VIEW UNKNOWN_LOV.
--  971027  ERJA    Changed ref=MaintenanceSupplier to PartyTypeSupplier and
--                  ref=EquipmentManufacturer to PartyTypeManufacturer.
--  971111  ERJA    Adapted calls to part_serial_catalog to use of contract.
--  971112  MNYS    Added key contract and attribute sup_contract.
--  971126  ERJA    Added argument in call to Create_Part_Serial_History
--  971214  TOWI    Added procedure Delete__.
--  980129  ERJA    Made changes according to new names in partserialcatalog.
--  980224  ERJA    removed reference to equipment_object_move in When_New_Mch__
--  980302  ERJA    Added Remove_Object_Structure.
--  980303  NILA    Added procedures Check_Warr_Exp__ Check_Warr_Exp_Shell__.
--  980304  NILA    Completed procedure Check_Warr_Exp__. Added event load info.
--  980312  ERJA    Added function Has_Structure and changed do_exist.
--  980319  ADBR    Removed Concatenate_Object__.
--  980323  CLCA    Changed length on manufacturer_no and vendor_no.
--  980325  TOWI    Changed call to obj_has_wo to dynamic call.
--  980326  CLCA    Changed from Get_App_Owner to Get_Fnd_User.
--  980401  MNYS    Included sup_contract as a member of LOV for view EQUIPMENT_OBJECT.
--  980407  ERJA    Added procedure Move_From_Invent_To_Facility
--  980407  MNYS    Support Id: 308. Added a new private procedure Check_Delete__.
--  980416  MNYS    Support Id: 3705. Added mch_loc, mch_pos, cost_center and group_id in
--                  Move_From_Invent_To_Facility.
--  980417  ERJA    Added call to Part_Serial_Catalog_API.Is_Issued in Move_From_Invent_To_Facility
--  980420  ERJA    Added bindvariable in call to Active_Work_Order_API.obj_has_wo
--  980421  ERJA    Corrections in call to Active_Work_Order_API.obj_has_wo.
--  980426  CAJO    Changed to sup_contract when validating sup_mch_code.
--  980429  TOWI    Only not null check on mch_name when functional object
--  980515  ERJA    Added mch_loc, mch_pos, cost_center and group_id in Move_From_Invent_To_Facility
--                  for serial structures.
--  980515  ERJA    Added PROCEDURE Remove_Superior_Info.
--  980516  ERJA    Correction in building of attribute string in Move_From_Invent_To_Facility
--  980615  CLCA    Changed prompt from 'Object Group' to 'Group ID' for group_id.
--  980802  NILA    Ref 5518: Added trunc-statements in cursor for procedure
--                  Check_Warr_Exp__.
--  980922  ERJA    Bug Id 6647: Added DESIGN_OBJECT to attr_ in Move_From_Invent_To_Facility.
--  980930  ADBR    Bug Id 6987: Added call to Equipment_Serial in Has_Warranty__.
--  981103  MIBO    Added status for the equipment object.
--  981124  MIBO    Changed REF=PartyTypeSupplier to SupplierInfo and REF=PartyTypeManufacturer
--                  to ManufacturerInfo.
--  981201  CLCA    Added work_order_cost_type_ in Update_Amount.
--  990107  MIBO    SKY.0702 Added FUNCTION Is_Scrapped.
--  990113  MIBO    SKY.0208 AND SKY.0209 Changed SYSDATE to (contract)
--                  and removed all calls to Get_Instance___ in Get-statements.
--  990118  MIBO    SKY.0209 Changed Site_API.Get_Site_Date(contract) to
--  981230  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206) and
--                  'Amount and Currency format' (SKY.0202) for data format.
--  990202  MAET    Modifications according to SKY.0203. Checking the existance of object_no and
--                  cost_center was changed. The new existance check is performed by invoking
--                  Maintenance_Accounting_API.Accounting_Codepart_Exist.
--  990331  MIBO    Call Id 12485 Added a check to see if state is "in repair workshop" in
--                  PROCEDURE Move_From_Invent_To_Facility.
--  990413  MIBO    Template changes due to performance improvement.
--  990503  CAPT    Added function Get_Manufacturer_No.
--  990517  ERJA    Moved Check_Serial_Exist from allser.api to obj.api
--  990518  ERJA    Bug Id 9647: Changed stringlength from 10 to 30 for user in PROCEDURE Move_From_Invent_To_Facility
--  990518  ERJA    Bug Id 9809: Changed Has_Document to use Get_Key_Reference.
--  990519  TOWI    No check that the object exist in Move_From_Invent_To_Facility when
--                  status is "In repair workshop"
--  990531  ERJA    Call id 18529: Added Call to Part_Serial_Catalog_API.Is_InFacility
--                  and Finite_state_init__ in  Move_From_Invent_To_Facility.
--  990613  SULO    Call id 19892. Oldrec was not read befor calculation of amount.
--  990617  ERJA    Changed call to Transaction_SYS.Deferred_Call to be language independent.
--  990917  PJONSE  Rock.1093:B PROCEDURE Update_Amount. Added cre_date_ parameter in PROCEDURE Update_Amount
--                  and in call for Equipment_Object_Cost_API.Update_Amount__.
--  991005  OSRY    Changed mch_type from 5 to 20 characters
--  991007  JIJO    When new object in Move_From_Invent_To_Facility. Set state to Active.
--  991008  PJONSE  Rock1429:B Changed client_state_list_: UnderConstruction to PlannedForOperation and Active to InOperation and Inactive to OutOfOperation.
--  991013  ERJA    Rock1059:B Added procedures Scrap_Structure__ Activate_Structure__ Inactivate_Structure__
--                  Construction_Structure__ Design_Structure__ in order to change status n objects structure.
--  991021  MABQ    Call 23926 Changed in view to NVL(mch_name, substr(Part_Catalog_API.Get_Description(part_no), 1, 45)) instead of mch_name
--  000201  JIJO    Calling new function: OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty
--  000411  HAST    Call 37955: Added Integration code for Plant design.
--  000417  HAST    Call 37955: Spelling fix on Public method Inactivate
--  000523  RECASE  Added function Has_Technical_Spec_No. Changed procedure When_New_Mch__ not to call Create_Attr_Template.
--  000531  MAGN    Call id 42914: Modify method Remove__ to handle delete differently for serial and functional object.
--  000615  JIJO    Remove Warranty Expires Event
--  000707  JIJO    Return Warranty Expires Event
--                  Modifiy event trigger. Procedure Check_Warr_Exp__
--  010426  SISALK  Fixed General_SYS.Init_Method in Check_External_Object__, Set_External_Status__, Get_Objid, Activate, Revise, Scrap, Inactivate & Check_Warr_Exp_Shell__.
--  010508  NIVIUS  Bug Id 19806: Changed the error test 'Moved into ... from inventory to facility ... ' to 'Moved into ... from Repair WorkShop ... '
--  010928  MIBOSE  Some changed in client_state_list_.
--  020311  JOHGSE  Added function Has_Cust_Warranty__ (Has_Warranty__ only check for supp warr)
-- ************************************* AD 2002-3 BASELINE ********************************************
--  020517  kamtlk  Modified sup_serial_no_ length 20 to 50 in Procedure Move_From_Invent_To_Facility.
--  020523  kamtlk  Modified serial_no length 20 to 50 in view EQUIPMENT_OBJECT.
--  020603  CHAMLK  Modified procedures Set_External_Status__ and Remove_Object_Structure, to change the mch_code length from 40 to 100
--  020604  CHAMLK  Modified the procedure Remove_Object_Structure and incresed the length of the bindinpar2_ from 40 to 100
--  020620  CHCRLK  Modified procedure Move_From_Invent_To_Facility to take into account new Position 'Contained'.
--  020624  MIBO    Site Independent Objects Added function Get_Contract.
--  020705  Jejalk  Modified view EQUIPMENT_OBJECT by adding Opeartional Status.
--  020729  CHCRLK  Removed state machinery.
--  020808  BhRalk  Added attributr manufactured_date.
--  020827  CHCRLK  Call ID: 88077 - Modified procedure Move_From_Invent_To_Facility.
--  020903  CHCRLK  Call ID: 88077 - Modified procedure Move_From_Invent_To_Facility. Added call to Move_To_Contained.
--  021014  INROLK  Changed function Get_Contract to fetch User allowed Sites only. Call Id 89656
-- ************************************* Take Off ********************************************
--  030919  KUHELK  Added Fetch_Object_Details Method.
--  031023  PRIKLK  CID 105976, Removed Part_Serial_Catalog_API.Move_To_Contained from Move_From_Invent_To_Facility
--                  as it is internally called by Part_Serial_Catalog_API.Modify().
--  031031  Chamlk  Modified procedure Move_From_Invent_To_Facility to create a new Equipment object only if a corresponding Vim serial does not exist.
--  031104  ChAmlk  Modified procedure Move_From_Invent_To_Facility to display error message when trying to place vim serials in equipment structure.
--  031107  ChAmlk  Modified procedure Move_From_Invent_To_Facility to set curr pos of serial objects to InFacility when placed under a functional object and set
--                  curr pos to Contained to when placed under a serial object.
--  040128  YaWilk  Moved the content of of the procedures EQUIPMENT_FUNCTIONAL_API.Delete___ and EQUIPMENT_SERIAL_API.Delete___ (they are identical) to
--                  EQUIPMENT_OBJECT_API.Delete___. Added the method Do_Delete__. The method will be called from EQUIPMENT_FUNCTIONAL_API.Delete___ and
--                  EQUIPMENT_SERIAL_API.Delete___.
--  040209 YaWilk   Unicode Support. Changes Done with 'SUBSTRB'.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
 -----------------------------2004-1 Product ---------------------------------
 --  031231 NEKOLK  Bug 41711, Removed unnecessary code from PROCEDURE Move_From_Invent_To_Facility.
 --  031231 BUNILK  Bug 40727, Modified Move_From_Invent_To_Facility so that to get corect states in Equipment Structure after moving a issued serial.
--  230304  DIMALK  Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package --                 body.
--  040324  JAPALK  Merge with SP1
--  040414  JAPELK  Call ID: 113986 (:- In Move_From_Invent_To_Facility method operational_status_db_ is incorrectly set to NULL)
--  040423  UDSULK  Unicode Modification-substr removal-4.
--  040408  HIWELK  Bug 43848 Modified Move_From_Invent_To_Facility to set state for repair shop objects.
--  040622  DIAMLK  Merged Bug corrections.
--  040729  SHAFLK  Bug 46187, Modified Move_From_Invent_To_Facility
--  040816  NIJALK  Merged bug 46187.
--  041111  PRIKLK  Bug 47832, Modified procedure Move_From_Invent_To_Facility.
--  041122  Chanlk  Merged bug 47832.
--  201204  Namelk  Removed Checks for SUP_WARRANTY_API Installed.
--  041215  GIRALK  BUG Id 48065, Modified Procedure Check_Tree_Loop
--  041229  GIRALK  Bug Id 48065, Modified Procedure Check_Tree_Loop
--  050103  Chanlk  Merged bug 48065.
--  050525  DiAmlk  Obsoleted the method Update_Amount and attribute Amount.(AMEC113 - Cost Follow Up)
--  050506  PRIKLK  Bug 49978, Removed commented code Set_External_Status__().
--  050531  DiAmlk  Merged the corrections done for the LCS Bug ID:49978.
--  050519  SHAFLK  Bug 51306, Added function Has_Any_Warranty.
--  050617  NIJALK  Merged bug 51306.
--  050912  DiAmlk  Modified the method Get.(Relate to LCS Bug ID:52123)
--  051118  SHAFLK  Bug 54415, Added Function Get_Def_Contract().
--  051206  NIJALK  Merged bug 54415.
--  060218  JAPALK  Call ID 134579 Modified Check_Tree_Loop__ method.
--  060218  JAPALk  Call ID 134599 Modified Check_Tree_Loop__ method.
--  060221  JAPALK  Call ID 134325. Modified Move_From_Invent_To_Facility method.
--  060221  NAMELK  Bug 56034, Modified method Move_From_Invent_To_Facility
--  060305  JAPALK  Merged bug 56034.
--  060309  JAPALK  Call ID 134325.Modified Trnslate tag in Move_From_Invent_To_Facility method.
--  060329  DiAmlk  Modified the method Check_Tree_Loop__.
--  061130  NIJALK  Bug 61616, Added new function Exist_AnyWhere().
--  070105  ILSOLK  Merged Bug Id 61616.
--  070323  AmNilk  MTIS907: New Service Contract - Services.Added new columns is_category_object, is_geographic_object to the view.
--  070605  AMDILK  Call Id 145321: Inserted function Get_Sup_Objects()
--  070417  HADALK  Bug 63877, Modified PROCEDURE Check_Delete___.
--  070625  AMDILK  Mergerd bug 63877
--  070528  PRIKLK  Bug 65575, Modified view comments of object no in view EQUIPMENT_OBJECT.
--  070626  AMDILK  Merged bug 65575
--  070724  IMGULK  Added Assert_SYS Assertions.
--  070830  AMNILK  Set Contract column LOV visible at view EQUIPMENT_OBJECT.
--  070831  CHODLK  Modified the view EQUIPMENT_OBJECT.
--  070925  CHODLK  added text_id$ to all the views.
--  080619  SHAFLK  Bug 74997, Modified PROCEDURE Move_From_Invent_To_Facility.
--  080702  LoPrlk  Bug 75205, Altered the method Move_From_Invent_To_Facility.
--  080805  CHCRLK  Bug 75788, Modified Delete___ to remove inherited object addresses.
--  090225  NIFRSE  Bug 80778, Added Get_Design_Status method
--  090324  SHAFLK  Bug 81370, Modified PROCEDURE Move_From_Invent_To_Facility.
--  090327  nukulk  Bug Id 81398, added ifs_assert_safe annotation.
--  090529  SHAFLK  Bug 82975, Modified Remove_Superior_Info.
--  090811  LIAMLK  Bug 84810, Added field owner to VIEW.
--  100706  LIAMLK  Bug 90609, Moved in MAINTENANCE_OBJECT_LOV, MAINT_OBJECT2_LOV from MaintenanceObject LU.
--  100726  CHODLK  Bug 91960, Added new columns connection_type, connection_type_db to view MAINTENANCE_OBJECT_LOV.
--  100907  ILSOLK  Bug 92855, Modified Do_Delete__().
--  101021  NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  110302  MAWILK  Bug 93720, Merged. Altered Check_Tree_Loop__() to apply the address to the object structure
--  091105  SaFalk  IID - ME310: Removed bug comment tags.
--  110425  NRATLK  Bug 96790, Modified Check_Tree_Loop__()to insert address7.
--  091109  SaFalk  IID - ME310: Commit rollback - Moved the event registration to Event.ins.
--  091216  LIAMLK  Added missing references to VIEW (EAST-1280).
--  110429  SHAFLK  Bug 96849, Modified Move_From_Invent_To_Facility().
--  110221  SaFalk  EANE-4424, Added new view EQUIPMENT_OBJECT_UIV with user_allowed_site filter to be used in the client.
--  110516  MADGLK  Bug 96937, Modified column conmments in EQUIPMENT_OBJECT ,SITE_LOV , UNKNOWN_LOV ,MAINT_OBJECT2_LOV and MAINTENANCE_OBJECT_LOV.
--  110706  LIAMLK  Bug 97644, Modified mch_name in VIEW, VIEW1, VIEW2.
--  110715  NEKOLK  SADEAGLE-1053: Modified Move_From_Invent_To_Facility().
--  110727  SanDLK  SADEAGLE-1887, When merging 97644 also modified VIEW_UIV.
--  110803  SanDLK  Modified column comments of EQUIPMENT_OBJECT_UIV while Merging BUG 96937.
--  111003  NIFRSE  LCS Merged Bug 98228, Modified added operational_status_db to EQUIPMENT_OBJECT view. Added Get_Design_Status_Db method.
--  111017  MADGLK  Bug 99136, Modified length of address1 to String(35).
--  111028  MADGLK  Bug 99652, Modified Get_Design_Status() and Get_Design_Status_Db().
--  120223  SHAFLK  Bug 101405, Modified Check_Warr_Exp_Shell__().
--  120319  NEKOLK  EASTRTM-4614 :Modified Move_From_Invent_To_Facility.
--  120418  ILSOLK  Bug 102067, Modified Has_Warranty__(),Has_Cust_Warranty__(),Has_Any_Warranty().
--  120521  NRATLK  Bug 102652, Modified Validate_Comb___().
--  120621  GAHALK  Bug 102950, Modified Check_Delete___(), Merged from 75 by SAMGLK.
--  120917  KrRaLK  Bug 105128, Modified Check_Delete___(), removed unwanted Reference_SYS.Check_Restricted_Delete('MaintenanceObject', key_) check.
--  121008  SHAFLK  EIGHTSA-230, Added new methods for new structures.
--  121008  SHAFLK  EIGHTSA-266, Added new methods for new structures to prevent tree loops.
--  121109  SHAFLK  EIGHTSA-309, Modified view EQUIPMENT_OBJECT_UIV.
--  121112  INMALK  Bug 106656, Modified Get_Design_Status() and Get_Design_Status_Db(), to have an equal sign rather than a 'like" in the select statement
--  130118  LoPrlk  Task: NINESA-251, Added the attribute item_class_id to the LU.
--  130123  LoPrlk  Task: NINESA-302, Made the attribute part_no public.
--  130517  SHAFLK  Bug 109663, Added criticality and part_rev fields.
--  -------------------------Project Black Pearl------------------------------------------------------
--  130508  MAWILK  BLACK-66, Moved methods and views from EquipmentAllObject.
--  130613  MADGLK  BLACK-65, Moved methods and views from MaintenaneceObject and Removed MAINTENANCE_OBJECT_API method calls.
--  300508  MAWILK  BLACK-145, Move_To_Inventory moved to Equipment_Serial_API.
--  130805  CLHASE  BLACK-438, Moved method Get_Eon_Counts from EquipmentAllObject.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
-------------------------------------------------------------------------------
--  130819  NiFrSE  Bug 111935, Modified Delete___(), moved the cascade delete call, to after deleting the technical_object_reference and doc_reference_object lines.
--  131213  NEKOLk  PBSA-1809, Hooks: refactored and split code.
--  131230  NEKOLK  PBSA-3412, Review fix.
--  140219  heralk  PBSA-5000, Fixed in PROCEDURE Modify__ ().
--  140226  japelk  PBSA-3601 fixed (LCS Bug: 113582).
--  140311  BHKALK  PBSA-3600, Merged LCS patch 112451.
--  130930  SHAFLK  112451, Added new method Exist_Warning and Exist_Non_Operational_Parent.
--  140314  HASTSE  PBSA-5731, address fixes
--  140312  heralk  PBSA-3592 , Merged LCS Patch - 112727.
--  140414  HASTSE  PBSA-4605, Preacounting fix for WO
--  140702  NRATLK  Added new method Get_Incident_Count() to get the number of incidents per object.
--  140707  NRATLK  PRSA-1294, Added new method Get_Risk_Assessment_Count() to get the count of Risk Assessments per object.
--  140714  NRATLK  PRSA-1732, Modified Get_Incident_Count() and Get_Risk_Assessment_Count() to add asset_manager parameter.
--  140812  HASTSE  Replaced dynamic code
--  140815  SHAFLK  PRSA-2196 Modified Move_From_Invent_To_Facility.
--  140909  NRATLK  PRSA-3284 Removed Get_Risk_Assessment_Count() and added Get_Avg_Risk_Potential()
--  141015  SHAFLK  PRSA-4668 Removed Convert_Functional_Object__.
--  141020  SHAFLK  PRSA-3709,Removed EQUIPMENT_ALL_OBJECT.
--  141116  HASTSE  PRSA-5455, Replaced direct delete of PartSerialCatalog Records with cascade delete for the EquipmentObject record
--  141205  PRIKLK  PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  150723  NuKuLK  RUBY-1306, Modified method Get_Avg_Risk_Potential()
--  150723  NuKuLK  RUBY-1295, Modified method Get_Incident_Count()
--  150805  chanlk  Bug 123819, Added procedure Remove_Object_References
--  151215  KrRaLK  STRSA-1662, Modified to fetch information from Psc_Contr_Product_Scope_API instead of Psc_Contr_Product_Object_API.
--  151231  KANILK  STRSA-1710, Bug Merged Bug 126187, Modified Copy_Serial__ method.
----------------------------Project Candy Crush ------------------------------------
--  151006  DUHELK  MATP-964, Added Safe_Access_Code.
--  151112  DUHELK  MATP-984, Added Distribute_Operational_Groups(), Get_Child_Objects().
--  151203  DUHELK  MATP-1279, Modified Get_Child_Objects(), added Spread_Safe_Access_code().
--  151221  LiAmlk  MATP-1270, Modified Get_Child_Objects(), Spread_Safe_Access_code(), Distribute_Operational_Groups().
--  150106  DUHELK  MATP-1580, Added Get_Resched_Req_Warning().
------------------------------------------------------------------------------------
--  160106  NRatLK  STRSA-1685, Removed unwanted conditional compilation for PARTCA component.
--  160128  KrRaLK  STRSA-1884, Added Inherit_Vrt_Map_Position().
--  151029  NRatLK  RPT-79,  Added Update_Pm_Program_Info().
--  151223  NRatLK  RPT-113, Modified Update_Pm_Program_Info() to support disconnecting object from PM program.
--  160112  JAroLK  RPT-507, Added Change_Pm_Application_Status().
--  160229  JAroLK  RPT-864, Modified Update_Pm_Program_Info().
--  160419  LiAmlk  STRSA-4004, Code review.
--  160621  NEKOLK  Bug 129968, Modified Copy_Serial__.
--  160830  SHAFLK  STRSA-9926, Merged Bug 131036, Modified Move_From_Invent_To_Facility.
--  160902  CLEKLK  STRSA 9982, Merged Bug 130571, Modified Get_Eon_Counts
-----------------------------------------------------------------------------
-------------------------------------------- RCM Enhancements ---------------
--  151221  SeRoLK  RCM-23: Added the attribute process_class_id to the LU.
--  160218  SeRoLK  RCM-59: Added method Is_ProcesCls_ItmCls_Com_Exist()
--  160323  SEROLK  RCM-87, Removed methods Insert() and Update()
--  161128  MDAHSE  STRSA-15472, Change VirtMapPosition to MapPosition.
--  170113  NIFRSE  STRSA-17100, Added new method Transf_Equip_Object_To_Task().
--  170201  NIFRSE  STRSA-18695, Added new method Transf_Eq_Obj_To_Task_Step().
--  170907  INROLK  STRSA-2094, Changed EquipmentObject readonly.
--  171009  NIFRSE  STRSA-25684, Added additional Error Handling in Get_Key_By_Rowkey().
--  171126  HASTSE  STRSA-32829, Equipment inheritance implementation
--  171211  NIFRSE  STRSA-10764, Remove the own defined method Get_Key_By_Rowkey().
--  180412  CLEKLK  Bug 141271, Modified Remove_Superior_Info.
--  180514  CLEKLK  Bug 141784, Modified Move_From_Invent_To_Facility
--  180622  SHAFLK  Bug 142521, Modified Get_Eon_Counts.
--  180625  CLEKLK  Bug 142108, Modified Move_From_Invent_To_Facility
--  180801  KrRaLK  Bug 143160, Modified Move_From_Invent_To_Facility().
--  180801  KrRaLK  Bug 142623, Modified Delete__() and Remove__().
--  180815  CLEKLK  SAUXXW4-1580, Added Hide_Object_No, Hide_Cost_Center, Get_Object_No_View, Get_Object_No, Get_Cost_Center_View and Get_Cost_Center
--  181026  CLEKLK  SAUXXW4-9912, Added Get_Code_Part_Cost_Center_Val, Get_Code_Part_For_Objct_Values, Get_Code_Part, Get_Code_Part_View, Hide_Code_Part and removed Hide_Object_No, Hide_Cost_Center, Get_Object_No_View, Get_Object_No, Get_Cost_Center_View and Get_Cost_Center
--  181003  SHEPLK  Bug 144539, Modified Get_Contract().
--  190111  NUEKLK  SAUXXW4-730, Introduced new Procedure Include_On_Contact_Line.
--  190709  SSILLK  Bug SAZM-2340,Removed Get_Objs_Per_Location and added Has_Objs_For_Location
--  191219  NEKOLK  SAZM-3958,Bug 151287, Modified Get_Eon_Counts.
--  201029  DEEKLK  AM2020R1-6341, Modified Dictionary_Sys methods for Solution Set support. 
--  210121  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  210721  SHAGLK  AM21R2-1493, Added condition to check tool/equip connection in Move_From_Invent_To_Facility
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work .
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
-------------------- PRIVATE DECLARATIONS -----------------------------------
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Maint_Obj_Exist___  (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  contract = contract_
      AND    mch_code = mch_code_
      AND    contract IN (SELECT contract FROM User_Allowed_Site_Lov);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Maint_Obj_Exist___ ;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   objid2_ rowid;
   objversion2_ VARCHAR2(2000);

BEGIN

   -- when one or more record are copied and pasted on another similar form always takes the defalut site rather than the originally copied site.
   -- as the Prepare_Insert___ always returns the default site.
   -- The code below does similar to Prepare_Insert___ when the value of the CONTACT is missing.
   IF ((action_ != 'PREPARE')AND(Client_SYS.Get_Item_Value('CONTRACT',attr_) IS NULL)) THEN
     Client_SYS.Add_To_Attr( 'CONTRACT', User_Default_API.Get_Contract, attr_);
   END IF;

   IF (Client_SYS.Get_Item_Value('OBJ_LEVEL',attr_) IS NULL) THEN
            EQUIPMENT_SERIAL_API.New__(info_, objid2_, objversion2_, attr_,action_);
            objid_ := objid2_;
            objversion_ := objversion2_;
      ELSE
            EQUIPMENT_FUNCTIONAL_API.New__(info_, objid2_, objversion2_, attr_,action_);
            objid_ := objid2_;
            objversion_ := objversion2_;
     END IF;

END New__;



PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ EQUIPMENT_OBJECT_TAB%ROWTYPE;
BEGIN

   rec_ := Get_Object_By_Id___(objid_);
   IF rec_.obj_level IS NULL THEN
      EQUIPMENT_SERIAL_API.Modify__(info_, objid_, objversion_, attr_, action_);
   ELSE
      EQUIPMENT_FUNCTIONAL_API.Modify__(info_, objid_, objversion_, attr_, action_);
   END IF;
END Modify__;

PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ EQUIPMENT_OBJECT_TAB%ROWTYPE;
BEGIN

   remrec_ := Get_Object_By_Id___(objid_);
   IF remrec_.obj_level IS NULL THEN
      EQUIPMENT_SERIAL_API.Remove__(info_, objid_, objversion_, action_);
   ELSE
      EQUIPMENT_FUNCTIONAL_API.Remove__(info_, objid_, objversion_, action_);
   END IF;
END Remove__;


PROCEDURE Check_Tree_Loop__ (
   rcode_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   sup_mch_code_ IN VARCHAR2,
   sup_contract_ IN VARCHAR2,
   from_serial_  IN VARCHAR2 DEFAULT 'FALSE' )
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_                   NUMBER;
functional_object_seq_  NUMBER;
testdata_               key_type;
sup_contr_              EQUIPMENT_OBJECT_TAB.contract%TYPE := sup_contract_;
sup_mch_                EQUIPMENT_OBJECT_TAB.mch_code%TYPE := sup_mch_code_;
mch_loop                EXCEPTION;
no_sup_contract         EXCEPTION;
no_sup_mch              EXCEPTION;

CURSOR get_sup_data_ IS
   SELECT functional_object_seq
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  contract = sup_contr_
   AND    mch_code = sup_mch_;

BEGIN
   test_  := 0;

   IF (sup_mch_ IS NULL) THEN
      RAISE no_sup_mch;
   END IF;
   IF (sup_contr_ IS NULL) THEN
      RAISE no_sup_contract;
   END IF;
   IF ((contract_ = sup_contr_) AND
       (mch_code_ = sup_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      OPEN get_sup_data_;
      FETCH get_sup_data_ INTO functional_object_seq_;
      
      testdata_.mch_code := Equipment_Object_API.Get_Mch_Code(functional_object_seq_);
      testdata_.contract := Equipment_Object_API.Get_Contract(functional_object_seq_);

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         sup_contr_ := testdata_.contract;
         sup_mch_ := testdata_.mch_code;
      END IF;
      CLOSE get_sup_data_;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_sup_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_sup_mch THEN
      rcode_ := 'FALSE';
   WHEN no_sup_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_Loop__;


PROCEDURE Check_Tree_Loc_Loop__ (
   rcode_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   location_mch_code_ IN VARCHAR2,
   location_contract_ IN VARCHAR2)

IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
location_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := location_contract_;
location_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := location_mch_code_;
mch_loop             EXCEPTION;
no_location_contract EXCEPTION;
no_location_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (location_mch_ IS NULL) THEN
      RAISE no_location_mch;
   END IF;
   IF (location_contr_ IS NULL) THEN
      RAISE no_location_contract;
   END IF;
   IF ((contract_ = location_contr_) AND
       (mch_code_ = location_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT location_contract, location_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = location_contr_
      AND    mch_code = location_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         location_contr_ := testdata_.contract;
         location_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_location_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_location_mch THEN
      rcode_ := 'FALSE';
   WHEN no_location_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_Loc_Loop__;


PROCEDURE Check_Tree_From_Loop__ (
   rcode_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_mch_code_ IN VARCHAR2,
   from_contract_ IN VARCHAR2)
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
from_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := from_contract_;
from_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := from_mch_code_;
mch_loop             EXCEPTION;
no_from_contract EXCEPTION;
no_from_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (from_mch_ IS NULL) THEN
      RAISE no_from_mch;
   END IF;
   IF (from_contr_ IS NULL) THEN
      RAISE no_from_contract;
   END IF;
   IF ((contract_ = from_contr_) AND
       (mch_code_ = from_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT from_contract, from_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = from_contr_
      AND    mch_code = from_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         from_contr_ := testdata_.contract;
         from_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_from_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_from_mch THEN
      rcode_ := 'FALSE';
   WHEN no_from_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_From_Loop__;


PROCEDURE Check_Tree_To_Loop__ (
    rcode_ IN OUT VARCHAR2,
    contract_ IN VARCHAR2,
    mch_code_ IN VARCHAR2,
    to_mch_code_ IN VARCHAR2,
    to_contract_ IN VARCHAR2)
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
to_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := to_contract_;
to_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := to_mch_code_;
mch_loop             EXCEPTION;
no_to_contract EXCEPTION;
no_to_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (to_mch_ IS NULL) THEN
      RAISE no_to_mch;
   END IF;
   IF (to_contr_ IS NULL) THEN
      RAISE no_to_contract;
   END IF;
   IF ((contract_ = to_contr_) AND
       (mch_code_ = to_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT to_contract, to_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = to_contr_
      AND    mch_code = to_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         to_contr_ := testdata_.contract;
         to_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_to_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_to_mch THEN
      rcode_ := 'FALSE';
   WHEN no_to_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_To_Loop__;


PROCEDURE Check_Tree_Process_Loop__ (
    rcode_ IN OUT VARCHAR2,
    contract_ IN VARCHAR2,
    mch_code_ IN VARCHAR2,
    process_mch_code_ IN VARCHAR2,
    process_contract_ IN VARCHAR2)
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
process_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := process_contract_;
process_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := process_mch_code_;
mch_loop             EXCEPTION;
no_process_contract EXCEPTION;
no_process_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (process_mch_ IS NULL) THEN
      RAISE no_process_mch;
   END IF;
   IF (process_contr_ IS NULL) THEN
      RAISE no_process_contract;
   END IF;
   IF ((contract_ = process_contr_) AND
       (mch_code_ = process_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT process_contract, process_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = process_contr_
      AND    mch_code = process_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         process_contr_ := testdata_.contract;
         process_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_process_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_process_mch THEN
      rcode_ := 'FALSE';
   WHEN no_process_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_Process_Loop__;


PROCEDURE Check_Tree_Pipe_Loop__ (
    rcode_ IN OUT VARCHAR2,
    contract_ IN VARCHAR2,
    mch_code_ IN VARCHAR2,
    pipe_mch_code_ IN VARCHAR2,
    pipe_contract_ IN VARCHAR2)
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
pipe_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := pipe_contract_;
pipe_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := pipe_mch_code_;
mch_loop             EXCEPTION;
no_pipe_contract EXCEPTION;
no_pipe_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (pipe_mch_ IS NULL) THEN
      RAISE no_pipe_mch;
   END IF;
   IF (pipe_contr_ IS NULL) THEN
      RAISE no_pipe_contract;
   END IF;
   IF ((contract_ = pipe_contr_) AND
       (mch_code_ = pipe_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT pipe_contract, pipe_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = pipe_contr_
      AND    mch_code = pipe_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         pipe_contr_ := testdata_.contract;
         pipe_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_pipe_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_pipe_mch THEN
      rcode_ := 'FALSE';
   WHEN no_pipe_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_Pipe_Loop__;


PROCEDURE Check_Tree_Circuit_Loop__ (
    rcode_ IN OUT VARCHAR2,
    contract_ IN VARCHAR2,
    mch_code_ IN VARCHAR2,
    circuit_mch_code_ IN VARCHAR2,
    circuit_contract_ IN VARCHAR2)
IS

TYPE key_type IS
   RECORD(contract EQUIPMENT_OBJECT_TAB.contract%TYPE, mch_code EQUIPMENT_OBJECT_TAB.mch_code%TYPE);

test_           NUMBER;
testdata_       key_type;
circuit_contr_      EQUIPMENT_OBJECT_TAB.contract%TYPE := circuit_contract_;
circuit_mch_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE := circuit_mch_code_;
mch_loop             EXCEPTION;
no_circuit_contract EXCEPTION;
no_circuit_mch      EXCEPTION;

BEGIN
   test_  := 0;
   IF (circuit_mch_ IS NULL) THEN
      RAISE no_circuit_mch;
   END IF;
   IF (circuit_contr_ IS NULL) THEN
      RAISE no_circuit_contract;
   END IF;
   IF ((contract_ = circuit_contr_) AND
       (mch_code_ = circuit_mch_)) THEN
      RAISE mch_loop;
   END IF;
   WHILE (test_ = 0) LOOP
      SELECT circuit_contract, circuit_mch_code INTO testdata_
      FROM   EQUIPMENT_OBJECT
      WHERE  contract = circuit_contr_
      AND    mch_code = circuit_mch_;

      IF (testdata_.mch_code IS NULL) THEN
         test_ := 1;
      ELSIF ((testdata_.contract = contract_) AND (testdata_.mch_code = mch_code_)) THEN
         test_ := 2;
      END IF;
      IF (test_ = 0) THEN
         circuit_contr_ := testdata_.contract;
         circuit_mch_ := testdata_.mch_code;
      END IF;
   END LOOP;
   IF (test_ = 1) THEN
      RAISE no_circuit_mch;
   END IF;
   IF (test_ = 2) THEN
      RAISE mch_loop;
   END IF;
EXCEPTION
   WHEN no_circuit_mch THEN
      rcode_ := 'FALSE';
   WHEN no_circuit_contract THEN
      rcode_ := 'FALSE';
   WHEN mch_loop THEN
      rcode_ := 'TRUE';
END Check_Tree_Circuit_Loop__;


PROCEDURE Check_External_Object__ (
   external_lu_name_ IN OUT VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   old_attr_ VARCHAR2(2000);
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   value_ := Client_SYS.Get_Item_Value('STATUS_REQUESTER', attr_);
   IF value_ IS NULL THEN
      external_lu_name_ := 'FALSE';
   ELSE
      external_lu_name_ := value_;
      old_attr_ := attr_;
      Client_SYS.Clear_Attr(attr_);
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(old_attr_, ptr_, name_, value_)) LOOP
         IF (name_ <> 'STATUS_REQUESTER') THEN
            Client_SYS.Add_To_Attr(name_, value_, attr_);
         END IF;
      END LOOP;
   END IF;
END Check_External_Object__;


PROCEDURE When_New_Mch__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   value_      VARCHAR2(2000);
   name_       VARCHAR2(30);
   lu_rec_     EQUIPMENT_OBJECT_TAB%ROWTYPE;
   note_       VARCHAR2(2000);
   part_no_    VARCHAR2(25);
BEGIN

   lu_rec_ := Get_Object_By_Keys___(contract_, mch_code_);
      IF lu_rec_.mch_serial_no IS NOT NULL THEN
      part_no_ := Equipment_Serial_API.Get_Part_No(contract_, mch_code_);
      IF part_no_ IS NOT NULL THEN
         note_ := Language_SYS.Translate_Constant(lu_name_, 'CREOBJ: Created by :P1', NULL, Fnd_Session_API.Get_Fnd_User);
         Part_Serial_History_API.New(part_no_, lu_rec_.mch_serial_no, NULL, note_, transaction_date_ => Maintenance_Site_Utility_API.Get_Site_Date(contract_));
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END When_New_Mch__;


@UncheckedAccess
FUNCTION Has_Structure__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
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
END Has_Structure__;


@UncheckedAccess
FUNCTION Is_Address__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
CURSOR mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  contract = contract_
   AND    mch_code = mch_code_
   AND    obj_level IS NOT NULL;

dummy_ NUMBER;

BEGIN
   OPEN mch;
   FETCH mch INTO dummy_;
   IF (mch%NOTFOUND) THEN
      CLOSE mch;
      RETURN FALSE;
   ELSE
      CLOSE mch;
      RETURN TRUE;
   END IF;
END Is_Address__;


@UncheckedAccess
FUNCTION Has_Warranty__ (
   equipment_object_seq_ IN NUMBER) RETURN VARCHAR2
IS
   temp_date_ DATE := trunc(Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_)));
BEGIN
   RETURN OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
END Has_Warranty__;

@UncheckedAccess
FUNCTION Has_Warranty__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Has_Cust_Warranty__(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Has_Warranty__;

@UncheckedAccess
FUNCTION Has_Cust_Warranty__ (
   equipment_object_seq_ IN NUMBER) RETURN VARCHAR2
IS
   temp_date_ DATE := trunc(Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_)));
BEGIN
   RETURN OBJECT_Cust_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
END Has_Cust_Warranty__;

@UncheckedAccess
FUNCTION Has_Cust_Warranty (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_date_   DATE := trunc(Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(contract_)));
BEGIN
   RETURN OBJECT_CUST_WARRANTY_API.Has_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), temp_date_);
END Has_Cust_Warranty;

PROCEDURE Delete__ (
   info_     OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2, 
   action_   IN VARCHAR2)
IS
   objid_            ROWID;
   objversion_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys__(objid_, objversion_, contract_, mch_code_);
   Remove__( info_, objid_, objversion_, action_);
END Delete__;


PROCEDURE Check_Warr_Exp__ (
   attrib_ IN VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   days_ahead_ NUMBER;
   msg_        VARCHAR2(32000);
   fnd_user_   VARCHAR2(2000);
   -- new handling of warranties.
   CURSOR warranty_expires IS
   SELECT Equipment_Object_API.Get_Mch_Code(eo.equipment_object_seq) mch_code, EO.mch_name, Equipment_Object_API.Get_Contract(eo.equipment_object_seq) contract, EO.cost_center, EO.vendor_no, OSW.valid_until, EO.rowkey
   FROM   EQUIPMENT_OBJECT_TAB EO,
          OBJECT_SUPPLIER_WARRANTY_TAB OSW
   WHERE  EO.equipment_object_seq = OSW.equipment_object_seq
   AND    OSW.valid_until is not null;
BEGIN

   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'DAYS_AHEAD') THEN
         days_ahead_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   FOR rec_ IN warranty_expires LOOP
      IF trunc(rec_.valid_until) = trunc(Maintenance_Site_Utility_API.Get_Site_Date(rec_.contract) + days_ahead_) THEN
         IF (Event_SYS.Event_Enabled( lu_name_, 'EQUIP_OBJECT_WARRANTY' )) THEN
            msg_ := Message_SYS.Construct('EQUIP_OBJECT_WARRANTY');
            --
            -- Standard event parameters
            fnd_user_ := Fnd_Session_API.Get_Fnd_User;
            Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Maintenance_Site_Utility_API.Get_Site_Date(rec_.contract) );
            Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_ );
            Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION',Fnd_User_API.Get_Description(fnd_user_) );
            Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS',Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS') );
            Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE') );
            --
            -- Specific Event information
            Message_Sys.Add_Attribute( msg_, 'OBJKEY', rec_.rowkey);
            Message_SYS.Add_Attribute( msg_, 'OBJECT_ID', rec_.mch_code );
            Message_SYS.Add_Attribute( msg_, 'OBJECT_DESCRIPTION', rec_.mch_name );
            Message_SYS.Add_Attribute( msg_, 'CONTRACT', rec_.contract );
            Message_SYS.Add_Attribute( msg_, 'WARRANTY_EXPIRES', rec_.valid_until );
            Message_SYS.Add_Attribute( msg_, 'COST_CENTER', rec_.cost_center);
            Message_SYS.Add_Attribute( msg_, 'SUPPLIER_CODE', rec_.vendor_no );
            Event_SYS.Event_Execute( lu_name_,'EQUIP_OBJECT_WARRANTY', msg_ );
         END IF;
      END IF;
   END LOOP;
END Check_Warr_Exp__;


PROCEDURE Check_Warr_Exp_Shell__ (
   days_ahead_ IN NUMBER )
IS
   attrib_ VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('DAYS_AHEAD', days_ahead_, attrib_);

   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Check_Warr_Exp__(attrib_);
   ELSE
      Transaction_SYS.Deferred_Call('Equipment_Object_API.Check_Warr_Exp__', attrib_, NULL, SYSDATE, 'TRUE');
   END IF;

END Check_Warr_Exp_Shell__;

PROCEDURE Do_Delete__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Delete__(info_, contract_, mch_code_, 'DO');
   -- Remove objects from the service line obj structure
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      Psc_Srv_Line_Objects_API.Remove_From_Structure( contract_, mch_code_);
   $ELSE
      NULL;
   $END

END Do_Delete__;


PROCEDURE Copy_Serial__ (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_ IN OUT VARCHAR2,
   serial_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   part_rev_ IN VARCHAR2,
   dest_belongs_to_object_ IN VARCHAR2,
   object_spare_ IN NUMBER,
   object_attr_ IN NUMBER,
   object_parameter_ IN NUMBER,
   object_test_pnt_ IN NUMBER,
   object_document_ IN NUMBER,
   object_pm_plan_ IN NUMBER,
   object_party_ IN NUMBER,
   dest_belongs_to_contract_ IN VARCHAR2 )
IS
   obj_exist          EXCEPTION;
   no_such_obj        EXCEPTION;
   has_spare          EXCEPTION;
   has_tech_data      EXCEPTION;
   has_parameter      EXCEPTION;
   has_test_pnt       EXCEPTION;
   has_party          EXCEPTION;
   no_pm              EXCEPTION;
   dest_object_       VARCHAR2(100);
   rcode_             VARCHAR2(5);
   attr_              VARCHAR2(32000);
   objid_             rowid;
   objversion_        VARCHAR2(2000);
   info_              VARCHAR2(2000);
   newrec_            EQUIPMENT_OBJECT_TAB%ROWTYPE;
   source_key_ref_         VARCHAR2(260);
   destination_key_ref_    VARCHAR2(260);
   sparepart_         VARCHAR2(5);
   test_pnt_          VARCHAR2(5);
   param_             VARCHAR2(5);
   party_             VARCHAR2(5);
   part_catalog_rec_  Part_Serial_Catalog_API.Public_Rec;
   dest_object_seq_   equipment_object_tab.equipment_object_seq%TYPE;
   
   CURSOR source IS
      SELECT *
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  contract = source_contract_
      AND     mch_code = source_object_
      AND obj_level IS NULL;

   CURSOR get_position IS
      SELECT mch_loc,mch_pos
      FROM EQUIPMENT_OBJECT_TAB
      WHERE  mch_code = dest_belongs_to_object_
      AND    contract =  dest_belongs_to_contract_;
   current_pos_  EQUIPMENT_OBJECT.mch_pos%TYPE;
   current_loc_  EQUIPMENT_OBJECT.mch_loc%TYPE;


BEGIN
   -- IF new object id (destination_object_) is not given it will be concatenated of part no and serial no

   IF (destination_object_ IS NULL) THEN
      Equipment_Serial_API.Concatenate_Object__(dest_object_, part_no_, serial_no_ );
      destination_object_ := dest_object_;
   ELSE
      dest_object_ := destination_object_;
   END IF;
   IF ((dest_belongs_to_object_ IS NOT NULL) AND (dest_belongs_to_contract_ IS NOT NULL)) THEN
      IF NOT Check_Exist___ (dest_belongs_to_contract_, dest_belongs_to_object_) THEN
         RAISE no_such_obj;
      END IF;
   END IF;


   IF (object_spare_ = 1) THEN
      sparepart_ := Equipment_Object_Spare_API.Has_Spare_Part (source_contract_, source_object_);

      IF Equipment_Object_Spare_API.Has_Spare_Part (destination_contract_, dest_object_) = 'TRUE' THEN
         RAISE has_spare;
      END IF;
   END IF;

   IF ((object_document_ = 1) OR (object_attr_ = 1)) THEN
      source_key_ref_      := Client_SYS.Get_Key_Reference(lu_name_, 'EQUIPMENT_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(source_contract_,    source_object_));
      destination_key_ref_ := Client_SYS.Get_Key_Reference(lu_name_, 'EQUIPMENT_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, dest_object_));
   END IF;

   IF (object_attr_ = 1 ) THEN
      IF Equipment_Object_API.Has_Technical_Spec_No ('EquipmentObject', destination_key_ref_) = 'TRUE' THEN
         RAISE has_tech_data;
      END IF;
   END IF;
   IF (object_test_pnt_ = 1) THEN
      test_pnt_ := Equipment_Object_Test_Pnt_API.Has_Test_Point (source_contract_, source_object_);

      IF Equipment_Object_Test_Pnt_API.Has_Test_Point (destination_contract_, dest_object_) = 'TRUE' THEN
         RAISE has_test_pnt;
      END IF;
   END IF;
   IF (object_parameter_ = 1) THEN
      param_ := Equipment_Object_Param_API.Has_Parameter (source_contract_, source_object_);

      IF Equipment_Object_Param_API.Has_Parameter (destination_contract_, dest_object_) = 'TRUE' THEN
        RAISE has_parameter;
      END IF;
   END IF;
   IF (object_document_ = 1) THEN
      Equipment_functional_API.Has_Document(rcode_, source_contract_, source_object_);
   END IF;
   IF (object_party_ = 1) THEN
      party_ := Equipment_Object_Party_API.Has_Party(source_contract_, source_object_);

      IF Equipment_Object_Party_API.Has_Party (destination_contract_, dest_object_) = 'TRUE' THEN
         RAISE has_party;
      END IF;
   END IF;

   IF (object_pm_plan_ = 1) THEN
      IF (object_parameter_ = 0) OR (object_test_pnt_ = 0) THEN
         RAISE no_pm;
      END IF;
   END IF;

   --Change calling location of following block call id 40610

   IF (Equipment_Serial_API.Check_Serial_Exist(part_no_, serial_no_) = 'TRUE') THEN
      Error_SYS.Record_General(Equipment_Serial_API.lu_name_, 'SRIINUSEPRT: Serial No. :P1 is already in used for part :P2', serial_no_, part_no_);
   END IF;

   IF Check_Exist___ (destination_contract_, dest_object_) THEN
      Error_SYS.Record_Exist(Equipment_Serial_API.lu_name_ , NULL, dest_object_);
   ELSE
      OPEN source;
      FETCH source INTO newrec_;
      CLOSE source;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', destination_contract_, attr_);
      Client_SYS.Add_To_Attr('MCH_CODE', dest_object_, attr_);
      Client_SYS.Add_To_Attr('GROUP_ID', newrec_.group_id, attr_);
      Client_SYS.Add_To_Attr('SUP_MCH_CODE', dest_belongs_to_object_, attr_);
      Client_SYS.Add_To_Attr('SUP_CONTRACT', dest_belongs_to_contract_, attr_);
      Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(dest_belongs_to_contract_, dest_belongs_to_object_), attr_);
      Client_SYS.Add_To_Attr('VENDOR_NO', newrec_.vendor_no, attr_);
      Client_SYS.Add_To_Attr('TYPE', newrec_.type, attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('MANUFACTURER_NO', newrec_.manufacturer_no, attr_);
      Client_SYS.Add_To_Attr('PART_REV', part_rev_, attr_);
      Client_SYS.Add_To_Attr('OWNERSHIP', Ownership_API.Decode(newrec_.ownership), attr_);
      Client_SYS.Add_To_Attr('OWNER',  newrec_.owner, attr_);
      IF (newrec_.ownership IS NULL) THEN
         part_catalog_rec_ := Part_Serial_Catalog_API.Get(newrec_.part_no,newrec_.mch_serial_no);
         Client_SYS.Add_To_Attr('OWNERSHIP', Part_Ownership_API.Decode(part_catalog_rec_.part_ownership), attr_);
         Client_SYS.Add_To_Attr('OWNER',  part_catalog_rec_.owning_customer_no, attr_);
      END IF;

      IF (newrec_.functional_object_seq != Equipment_Object_API.Get_Equipment_Object_Seq(dest_belongs_to_contract_, dest_belongs_to_object_) ) THEN

         OPEN get_position;
         FETCH get_position INTO current_loc_,current_pos_;
         CLOSE get_position;
         Client_SYS.Add_To_Attr('MCH_LOC', current_loc_, attr_);
         Client_SYS.Add_To_Attr('MCH_POS', current_pos_, attr_);
      ELSE
        Client_SYS.Add_To_Attr('MCH_LOC', newrec_.mch_loc, attr_);
        Client_SYS.Add_To_Attr('MCH_POS', newrec_.mch_pos, attr_);
      END IF;

      Client_SYS.Add_To_Attr('MCH_DOC', newrec_.mch_doc, attr_);
      Client_SYS.Add_To_Attr('WARR_EXP', newrec_.warr_exp, attr_);
      Client_SYS.Add_To_Attr('MCH_TYPE', newrec_.mch_type, attr_);
      Client_SYS.Add_To_Attr('COST_CENTER', newrec_.cost_center, attr_);
      Client_SYS.Add_To_Attr('OBJECT_NO', newrec_.object_no, attr_);
      Client_SYS.Add_To_Attr('NOTE', newrec_.note, attr_);
      Client_SYS.Add_To_Attr('CATEGORY_ID', newrec_.category_id, attr_);
      Client_SYS.Add_To_Attr('PRODUCTION_DATE', newrec_.production_date, attr_);
      Client_SYS.Add_To_Attr('INFO', newrec_.info, attr_);
      Client_SYS.Add_To_Attr('DATA', newrec_.data, attr_);
      Client_SYS.Add_To_Attr('CRITICALITY', newrec_.criticality, attr_);
      Client_SYS.Add_To_Attr('ITEM_CLASS_ID', newrec_.item_class_id, attr_);
      Client_SYS.Add_To_Attr('PROCESS_CLASS_ID', newrec_.process_class_id, attr_);

      New__(info_, objid_, objversion_, attr_, 'DO');


   END IF;
   
   destination_key_ref_ := 'EQUIPMENT_OBJECT_SEQ='||Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_)||'^';
   
      IF object_attr_ = 1 THEN
      -- IF technical data exist, it has already been copied by now.
      -- Check whether equipment object has a technical number before copy technical object values.
      IF Equipment_object_api.has_technical_spec_no('EquipmentObject',(source_key_ref_)) = 'TRUE' THEN
         Technical_Object_Reference_API.Copy ( 'EquipmentObject', source_key_ref_, destination_key_ref_,'TRUE','TRUE');
      END IF;
      null;
   END IF;

   IF object_spare_ = 1 AND sparepart_ = 'TRUE' THEN
      Equipment_Object_Spare_API.Copy (source_contract_, source_object_, destination_contract_, dest_object_);
   END IF;
   IF object_test_pnt_ = 1 AND test_pnt_ = 'TRUE' THEN
      Equipment_Object_Test_Pnt_API.Copy (source_contract_, source_object_, destination_contract_, dest_object_);
   END IF;
   IF object_parameter_ = 1 AND param_ = 'TRUE' THEN
      Equipment_Object_Param_API.Copy (source_contract_, source_object_, destination_contract_, dest_object_);
   END IF;
   IF object_document_ = 1 AND rcode_ = 'TRUE' THEN
      Maintenance_Document_Ref_API.Copy( 'EquipmentObject', source_key_ref_, 'EquipmentObject', destination_key_ref_ );
   END IF;
   IF object_party_ = 1 AND party_ = 'TRUE' THEN
      Equipment_Object_Party_API.Copy (source_contract_, source_object_, destination_contract_, dest_object_);
   END IF;
   IF object_pm_plan_ = 1 THEN
      dest_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_);
        IF Transaction_SYS.Package_Is_Active('PM_ACTION_API') THEN
           Client_SYS.Clear_Attr(attr_);
           Client_SYS.Add_To_Attr('SOURCE',                 source_object_,        attr_);
           Client_SYS.Add_To_Attr('DESTINATION',            dest_object_,          attr_);
           Client_SYS.Add_To_Attr('DESTINATION_CONTRACT',   destination_contract_, attr_);
           Client_SYS.Add_To_Attr('SOURCE_CONTRACT',        source_contract_,      attr_);
           Client_SYS.Add_To_Attr('DESTINATION_OBJECT_SEQ', dest_object_seq_,      attr_);
           Transaction_SYS.Dynamic_Call('PM_ACTION_API.COPY', attr_);
        END IF;
   END IF;
EXCEPTION
   WHEN no_such_obj THEN
      Error_SYS.Record_General('EquipmentObject', 'NOSUPOBJ: The Belongs to Object does not exist.');
   WHEN has_spare THEN
      Error_SYS.Record_General('EquipmentObject', 'HASSPARE: The destination object already has spare parts.');
   WHEN has_tech_data THEN
      Error_SYS.Record_General('EquipmentObject', 'HASTECHDATA: The destination object already has demands.');
   WHEN has_parameter THEN
      Error_SYS.Record_General('EquipmentObject', 'HASPARAM: The destination object already has parameters.');
   WHEN has_test_pnt THEN
      Error_SYS.Record_General('EquipmentObject', 'HASTSTPNT: The destination object already has testpoints.');
   WHEN has_party THEN
      Error_SYS.Record_General('EquipmentObject', 'HASPARTY: The destination object already has parties.');
   WHEN no_pm THEN
      Error_SYS.Record_General('EquipmentObject', 'NOPM: Parameter and testpoint must be copied together with the PM plan.');
   WHEN obj_exist THEN
      Error_SYS.Record_General('EquipmentObject', 'OBJEXIST: This object already exists.');
END Copy_Serial__;


PROCEDURE Copy_Functional__ (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_object_ IN VARCHAR2,
   destination_object_name_ IN VARCHAR2,
   dest_belongs_to_object_ IN VARCHAR2,
   object_spare_ IN NUMBER,
   object_attr_ IN NUMBER,
   object_parameter_ IN NUMBER,
   object_test_pnt_ IN NUMBER,
   object_document_ IN NUMBER,
   object_pm_plan_ IN NUMBER,
   object_party_ IN NUMBER,
   destination_contract_ IN VARCHAR2,
   dest_belongs_to_contract_ IN VARCHAR2 )
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
                                                    dest_belongs_to_contract_,
                                                    dest_belongs_to_object_,
                                                    object_spare_,
                                                    object_attr_,
                                                    object_parameter_,
                                                    object_test_pnt_,
                                                    object_document_,
                                                    object_pm_plan_,
                                                    object_party_);
END Copy_Functional__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_ProcesCls_ItmCls_Com_Exist (
   process_class_id_ IN VARCHAR2,
   item_class_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_combination IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  process_class_id = process_class_id_
      AND    item_class_id = item_class_id_;
BEGIN
   OPEN exist_combination;
   FETCH exist_combination INTO dummy_;
   IF (exist_combination%FOUND) THEN
      CLOSE exist_combination;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_combination;
   RETURN 'FALSE';
END Is_ProcesCls_ItmCls_Com_Exist;

@UncheckedAccess
FUNCTION Has_Any_Warranty (
   equipment_object_seq_ IN NUMBER) RETURN VARCHAR2
IS
   temp_date_ DATE := trunc(Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_)));
   sup_war_   VARCHAR2(5);
   cust_war_  VARCHAR2(5);
BEGIN
   sup_war_ := OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
   cust_war_ :=OBJECT_Cust_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
   IF (sup_war_ ='TRUE' OR cust_war_ ='TRUE'  ) THEN
       RETURN 'TRUE';
   ELSE
       RETURN 'FALSE';
   END IF;
END Has_Any_Warranty;

@UncheckedAccess
FUNCTION Has_Any_Warranty (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_date_ DATE := trunc(Maintenance_Site_Utility_API.Get_Site_Date(contract_));
   sup_war_   VARCHAR2(5);
   cust_war_  VARCHAR2(5);
   equipment_object_seq_ EQUIPMENT_OBJECT_TAB.equipment_object_seq%TYPE;
BEGIN
   equipment_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   sup_war_ := OBJECT_SUPPLIER_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
   cust_war_ :=OBJECT_Cust_WARRANTY_API.Has_Warranty(equipment_object_seq_, temp_date_);
   IF (sup_war_ ='TRUE' OR cust_war_ ='TRUE'  ) THEN
       RETURN 'TRUE';
   ELSE
       RETURN 'FALSE';
   END IF;
END Has_Any_Warranty;


@UncheckedAccess
FUNCTION Get_Obj_Level (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.obj_level%TYPE;
CURSOR get_attr IS
   SELECT obj_level
   FROM EQUIPMENT_OBJECT_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Obj_Level;

@UncheckedAccess
FUNCTION Get_Obj_Level (
   equipment_object_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.obj_level%TYPE;
CURSOR get_attr IS
   SELECT obj_level
   FROM EQUIPMENT_OBJECT_TAB
   WHERE equipment_object_seq = equipment_object_seq_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Obj_Level;


PROCEDURE Has_Document (
   rcode_    OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   key_ref_ VARCHAR2(2000);
BEGIN
   key_ref_ := Client_SYS.Get_Key_Reference(lu_name_, 'EQUIPMENT_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
   IF MAINTENANCE_DOCUMENT_REF_API.Exist_Obj_Reference(lu_name_, key_ref_) = 'TRUE' THEN
      rcode_ := 'TRUE';
   ELSE
      rcode_ := 'FALSE';
   END IF;
END Has_Document;


@UncheckedAccess
FUNCTION Has_Technical_Spec_No (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- accepts both key_value and key_ref
BEGIN
   IF TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Spec_No (lu_name_, key_value_ ) = '-1' THEN
      RETURN ('FALSE');
   ELSE
      RETURN ('TRUE');
   END IF;
END Has_Technical_Spec_No;

@UncheckedAccess
PROCEDURE Has_Design_Object(
    exist_    OUT VARCHAR2,
    mch_code_ IN VARCHAR2,
    contract_ IN VARCHAR2 )
IS
   temp_ VARCHAR2(10):= 'FALSE';

BEGIN
   $IF Component_Plades_SYS.INSTALLED $THEN
      IF(mch_code_ IS NOT NULL AND contract_ IS NOT NULL) THEN
         IF (PLANT_OBJECT_API.Object_Id_Exist(mch_code_,contract_) = 'True') THEN
            temp_ := 'TRUE';
         ELSE
            temp_ := 'FALSE';
         END IF;
       END IF;
   $END
   exist_ := temp_;
END Has_Design_Object;


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
END Do_Exist;


@UncheckedAccess
FUNCTION Get_Sup_Mch_Name (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mch_name_ EQUIPMENT_OBJECT_TAB.mch_name%TYPE;
   sup_mch_code_ EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   sup_contract_ EQUIPMENT_OBJECT_TAB.contract%TYPE;
CURSOR get_attr IS
   SELECT mch_name
   FROM EQUIPMENT_OBJECT
   WHERE contract = sup_contract_
   AND mch_code = sup_mch_code_;
BEGIN
   sup_contract_ := Get_Sup_Contract(contract_, mch_code_);
   sup_mch_code_ := Get_Sup_Mch_Code(contract_, mch_code_);
 
   OPEN get_attr;
   FETCH get_attr INTO mch_name_;
   CLOSE get_attr;
   RETURN mch_name_;
 
END Get_Sup_Mch_Name;


PROCEDURE Remove_Object_Structure (
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2)
IS
   objid_        ROWID;
   objversion_   VARCHAR2(2000);
   true_false_    VARCHAR2(5);
   info_          VARCHAR2(32000);
BEGIN

   $IF Component_Wo_SYS.INSTALLED $THEN
      true_false_ := Active_Work_Order_API.Obj_Has_Wo( contract_, mch_code_);
   $ELSE
      true_false_ := 'FALSE';
   $END

   IF ( true_false_ = 'FALSE') THEN
      --  Check following LU and then remove
      Equipment_Object_Test_Pnt_API.Remove_Obj_Test_Pnt(contract_, mch_code_);
      Equipment_Structure_Cost_API.Remove_Obj_Cost(contract_, mch_code_);
      Equipment_Object_Party_API.Remove_Obj_Party(contract_, mch_code_);
      --  Remove from  following LU without checking
      Equipment_Object_Conn_API.Remove_Obj_Conn(contract_, mch_code_);
      Equipment_Object_Spare_API.Remove_Obj_Spare(contract_, mch_code_);
      Get_Id_Version_By_Keys__(objid_, objversion_, contract_, mch_code_);
      Remove__( info_, objid_, objversion_, 'DO' );
   ELSE
      Error_SYS.Appl_General(lu_name_, 'REMOBJHASWO: Object :P1 at :P2 Has Work Orders and can not be removed.', mch_code_, contract_);
   END IF;
END Remove_Object_Structure;


@UncheckedAccess
FUNCTION Has_Structure (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Has_Structure(Get_Equipment_Object_Seq(contract_, mch_code_));
END Has_Structure;

@UncheckedAccess
FUNCTION Has_Structure (
   equipment_object_seq_ IN NUMBER ) RETURN VARCHAR2
IS

CURSOR mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  functional_object_seq = equipment_object_seq_;

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


PROCEDURE Move_From_Invent_To_Facility (
   contract_          IN VARCHAR2,
   mch_code_          IN VARCHAR2,
   replace_part_no_   IN VARCHAR2,
   replace_serial_no_ IN VARCHAR2,
   replace_mch_code_  IN VARCHAR2 DEFAULT NULL )
IS
   attr_                         VARCHAR2 (2000);
   info_                         VARCHAR2(32000);
   objid_                        ROWID;
   objversion_                   VARCHAR2(2000);
   modify_objid_                 ROWID;
   modify_objversion_            VARCHAR2(2000);
   current_position_             VARCHAR2(2000);
   transaction_description_      VARCHAR2(2000);
   user_                         VARCHAR2(30);
   alternate_id_                 VARCHAR2(100);
   alternate_contract_           VARCHAR2(5);
   sup_serial_no_                VARCHAR2(50);
   sup_part_no_                  VARCHAR2(25);
   operational_status_db_        VARCHAR2(20);
   vim_serial_exist_             VARCHAR2(5):= 'FALSE';
   object_curr_pos_              VARCHAR2(30);
   superior_alternate_contract_  VARCHAR2(5);
   superior_alternate_id_        VARCHAR2(100);
   superior_part_no_             VARCHAR2(25);
   superior_serial_no_           VARCHAR2(50);
   attr2_                        VARCHAR2 (2000);
   object_                       VARCHAR2(100);
   site_                         VARCHAR2(5);
   pur_transaction_code_         VARCHAR2(10) := 'PURSHIP';
   max_transaction_code_         VARCHAR2(10);
   shop_transaction_code_        VARCHAR2(10) := 'SOISS';
   transaction_id_               NUMBER;
   sup_contract_                 VARCHAR2(25);
   part_serial_catalog_rec_      Part_Serial_Catalog_API.Public_Rec;
   sup_mch_code_                 equipment_object.sup_mch_code%TYPE := NULL;
   cmnt_                         VARCHAR2 (2000);
   
   CURSOR part_info IS
      SELECT part_no, serial_no
      FROM EQUIPMENT_OBJECT
      WHERE mch_code = superior_alternate_id_
      AND contract = superior_alternate_contract_;

   CURSOR get_part_struc IS
      SELECT  part_no, serial_no
      FROM    PART_SERIAL_CATALOG
      WHERE   superior_part_no IS NOT NULL
      CONNECT BY PRIOR part_no   = superior_part_no
      AND        PRIOR serial_no = superior_serial_no
      START WITH part_no   = replace_part_no_
      AND        serial_no = replace_serial_no_;


   CURSOR get_part(part_no_ VARCHAR2, mch_serial_no_ IN VARCHAR2) IS
      SELECT contract, mch_code
      FROM equipment_object_tab
      WHERE part_no = part_no_
      AND mch_serial_no = mch_serial_no_;

BEGIN
   user_ := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Clear_Attr(attr_);

   $IF Component_Invent_SYS.INSTALLED $THEN
      SELECT MAX(TRANSACTION_ID) INTO transaction_id_
        FROM INVENTORY_TRANSACTION_HIST
       WHERE PART_NO   = replace_part_no_
         AND SERIAL_NO = replace_serial_no_
         AND CONTRACT  = contract_;
      max_transaction_code_ := INVENTORY_TRANSACTION_HIST_API.Get_Transaction_Code(transaction_id_);
   $ELSE
      NULL;
   $END
   IF (Equipment_Serial_API.Check_Obj_Tool_Equip_Conn(contract_,replace_mch_code_) = 'TRUE') THEN 
      IF (Equipment_Serial_API.Check_Obj_Tool_Equip_Conn(contract_,mch_code_) = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'CONNEXISTFOROBJ: Cannot set a Tool/Equipment connected Serial Object as Object ID.');
      END IF; 
      IF (Equipment_Serial_API.Check_Parent_Tool_Equip_Conn(contract_,mch_code_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'CONNFORPARENTOBJ: Cannot set child Serial objects of Tool/Equipment connected Serial Object as Object ID.');
      END IF;
   END IF;
     
   IF (Part_Serial_Catalog_API.Is_Issued(replace_part_no_, replace_serial_no_) = 'TRUE') AND max_transaction_code_ = pur_transaction_code_ THEN
      Error_SYS.Appl_General(lu_name_, 'ISSTOSUPP: Part :P1 - :P2 is issued to a supplier and can not be moved.', replace_part_no_, replace_serial_no_);
   ELSIF (Part_Serial_Catalog_API.Is_Issued(replace_part_no_, replace_serial_no_) = 'TRUE') AND max_transaction_code_ = shop_transaction_code_ THEN
      Error_SYS.Appl_General(lu_name_, 'ISSTOSHOP: Part :P1 - :P2 is issued to a Shop Order, cannot moved from the Work Order.', replace_part_no_, replace_serial_no_);
   ELSIF ((Part_Serial_Catalog_API.Is_Issued(replace_part_no_, replace_serial_no_) = 'FALSE'))THEN
      IF (Part_Serial_Catalog_API.Is_In_Repair_Workshop(replace_part_no_, replace_serial_no_) = 'TRUE') THEN
         Error_SYS.Appl_General(lu_name_, 'NOTISSINREP: Part :P1 - :P2 is in repair workshop and can not be moved.', replace_part_no_, replace_serial_no_);
      ELSE
         Error_SYS.Appl_General(lu_name_, 'NOTISSNOTINRE: Part :P1 - :P2 is not issued and can not be moved.', replace_part_no_, replace_serial_no_);
      END IF;
   ELSE
      Equipment_Object_Util_API.Get_Object_Info(alternate_contract_, alternate_id_, replace_part_no_, replace_serial_no_);
      IF (Part_Serial_Catalog_API.Is_In_Repair_Workshop(replace_part_no_, replace_serial_no_) = 'FALSE') THEN
         IF ((Part_Serial_Catalog_API.Is_In_Facility(replace_part_no_, replace_serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_Contained(replace_part_no_, replace_serial_no_) = 'TRUE')) THEN
            Error_SYS.Appl_General(lu_name_, 'OBJINFAC: Object already exist as :P1 at :P2 .', alternate_id_, alternate_contract_);
         END IF;
      END IF;

      IF (Part_Serial_Catalog_API.Is_Issued(replace_part_no_, replace_serial_no_) = 'TRUE') OR (Part_Serial_Catalog_API.Is_In_Repair_Workshop(replace_part_no_, replace_serial_no_) = 'TRUE') THEN
         operational_status_db_ := 'IN_OPERATION';
      ELSE
         operational_status_db_ := NULL;
      END IF;

      IF Check_Exist___(alternate_contract_, alternate_id_) THEN
         Get_Id_Version_By_Keys__(modify_objid_, modify_objversion_, alternate_contract_, alternate_id_);
           
         Equipment_Object_Util_API.Get_Part_Info(sup_part_no_, sup_serial_no_, contract_, mch_code_);
         current_position_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTXT: Placed in object :P1 at site :P2.', NULL, mch_code_, contract_);
         IF operational_status_db_ = 'OUT_OF_OPERATION' THEN
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJINVTOFACT10: Moved into object :P1 at site :P2 from Repairshop by user :P3', NULL, mch_code_, contract_, user_);
         ELSE
            transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJINVTOFACT1: Moved into object :P1 at site :P2 from inventory by user :P3', NULL, mch_code_, contract_, user_);
         END IF;

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('SUPERIOR_PART_NO', sup_part_no_, attr_);
         Client_SYS.Add_To_Attr('SUPERIOR_SERIAL_NO', sup_serial_no_, attr_);

         Client_SYS.Add_To_Attr('OPERATIONAL_STATUS_DB', operational_status_db_, attr_);
         IF (operational_status_db_ = 'IN_OPERATION' AND Part_Serial_Catalog_API.Get_Installation_Date(replace_part_no_, replace_serial_no_) IS NULL) THEN
            Client_SYS.Add_To_Attr('INSTALLATION_DATE', Maintenance_Site_Utility_API.Get_Site_Date(alternate_contract_), attr_);
         END IF;

         IF (mch_code_ IS NULL)THEN
            Part_Serial_Catalog_API.Move_To_Facility (replace_part_no_, replace_serial_no_, current_position_, transaction_description_, operational_status_db_);
         ELSE
            superior_alternate_contract_ := contract_;
            superior_alternate_id_ := mch_code_;
            object_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(replace_part_no_, replace_serial_no_);
            IF (Equipment_Functional_API.Do_Exist(contract_, mch_code_) = 'TRUE') THEN
               IF (object_curr_pos_ != 'InFacility') THEN
                  Part_Serial_Catalog_API.Move_To_Facility (replace_part_no_, replace_serial_no_, current_position_, transaction_description_, operational_status_db_);
               END IF;
            ELSIF (Equipment_Serial_API.Do_Exist(contract_, mch_code_) = 'TRUE') THEN
               IF (object_curr_pos_ != 'Contained') THEN
                  Part_Serial_Catalog_API.Move_To_Contained(replace_part_no_, replace_serial_no_, current_position_, transaction_description_,operational_status_db_);
               END IF;
            END IF;

            OPEN Part_Info;
            FETCH Part_Info INTO superior_part_no_, superior_serial_no_;
            IF (Equipment_Functional_API.Do_Exist(contract_, mch_code_) != 'TRUE') THEN
            transaction_description_ := substr(transaction_description_,1,200);
               Part_Serial_Catalog_API.Modify_Serial_Structure(replace_part_no_, replace_serial_no_, superior_part_no_, superior_serial_no_, transaction_description_);
            END IF;
            CLOSE Part_Info;
         END IF;

         Part_Serial_Catalog_API.Modify( attr_, replace_part_no_, replace_serial_no_);


         IF (contract_ = alternate_contract_) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('SUP_MCH_CODE', mch_code_, attr_);
            Client_SYS.Add_To_Attr('SUP_CONTRACT', contract_, attr_);
            Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('MCH_LOC', Get_Mch_Loc(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('MCH_POS', Get_Mch_Pos(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('COST_CENTER', Get_Cost_Center(contract_, mch_code_), attr_);

            Equipment_Serial_API.Modify__( info_, modify_objid_, modify_objversion_, attr_, 'DO' );
         ELSE
            Equipment_Serial_API.Check_Move(contract_, mch_code_, Get_Sup_Mch_Code(alternate_contract_, alternate_id_), Get_Sup_Contract(alternate_contract_, alternate_id_), alternate_contract_, alternate_id_, Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User), contract_, Site_API.Get_Company(contract_ ));
            Equipment_Serial_API.Direct_Move__(cmnt_, alternate_contract_, alternate_id_, Get_Equipment_Object_Seq(alternate_contract_, alternate_id_), Get_Sup_Mch_Code(alternate_contract_, alternate_id_), Get_Sup_Contract(alternate_contract_, alternate_id_), mch_code_, contract_, Get_Equipment_Object_Seq(contract_, mch_code_), contract_, Site_API.Get_Company(contract_ ), Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User), FALSE, NULL, NULL, 'TRUE');
         END IF;


      ELSE
         $IF Component_Vim_SYS.INSTALLED $THEN
            vim_serial_exist_ := VIM_SERIAL_API.Serial_No_Exist( replace_part_no_, replace_serial_no_);
         $ELSE
            NULL;
         $END

         IF (vim_serial_exist_ = 'FALSE') THEN
            alternate_id_ := NVL(replace_mch_code_, alternate_id_);

            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('PART_NO', replace_part_no_, attr_);
            Client_SYS.Add_To_Attr('SERIAL_NO', replace_serial_no_, attr_);
            Client_SYS.Add_To_Attr('MCH_CODE', alternate_id_, attr_);
            Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
            Client_SYS.Add_To_Attr('SUP_MCH_CODE', mch_code_, attr_);
            Client_SYS.Add_To_Attr('SUP_CONTRACT', contract_, attr_);
            Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('MCH_LOC', Get_Mch_Loc(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('MCH_POS', Get_Mch_Pos(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('COST_CENTER', Get_Cost_Center(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('GROUP_ID', Get_Group_Id(contract_, mch_code_), attr_);
            Client_SYS.Add_To_Attr('DESIGN_OBJECT', '1', attr_);
            Equipment_Serial_API.New__( info_, objid_, objversion_, attr_, 'DO' );
         ELSE
            Error_SYS.Appl_General(lu_name_, 'CANNOTMOVEVIM: Cannot Place Vim Serials in Equipment Structure.');
         END IF;
         Client_SYS.Clear_Attr(attr_);
         --Activate__ ( info_,  objid_,  objversion_, attr_, 'DO');
         --Client_SYS.Clear_Attr(attr_);

         Equipment_Object_Util_API.Get_Part_Info(sup_part_no_, sup_serial_no_, contract_, mch_code_);

         Client_SYS.Add_To_Attr('SUPERIOR_PART_NO', sup_part_no_, attr_);
         Client_SYS.Add_To_Attr('SUPERIOR_SERIAL_NO', sup_serial_no_, attr_);

         Client_SYS.Add_To_Attr('OPERATIONAL_STATUS_DB', operational_status_db_, attr_);


         current_position_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTXT: Placed in object :P1 at site :P2.', NULL, mch_code_, contract_);
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJINVTOFACT1: Moved into object :P1 at site :P2 from inventory by user :P3', NULL, mch_code_, contract_, user_);
         object_curr_pos_ := Part_Serial_Catalog_API.Get_Objstate(replace_part_no_, replace_serial_no_);

         IF (Equipment_Functional_API.Do_Exist(contract_, mch_code_) = 'TRUE') THEN
            IF (object_curr_pos_ != 'InFacility') THEN
               Part_Serial_Catalog_API.Move_To_Facility (replace_part_no_, replace_serial_no_, current_position_, transaction_description_, operational_status_db_,'OPERATIONAL');
            END IF;
         ELSIF (Equipment_Serial_API.Do_Exist(contract_, mch_code_) = 'TRUE') THEN
            IF (object_curr_pos_ != 'Contained') THEN
               Part_Serial_Catalog_API.Move_To_Contained(replace_part_no_, replace_serial_no_, current_position_, transaction_description_,operational_status_db_,'OPERATIONAL');
            END IF;
         END IF;


         IF (mch_code_ IS NULL)THEN
            Part_Serial_Catalog_API.Move_To_Facility (replace_part_no_, replace_serial_no_, current_position_, transaction_description_, operational_status_db_,'OPERATIONAL');
         END IF;

         Part_Serial_Catalog_API.Modify( attr_, replace_part_no_, replace_serial_no_);
      END IF;
            object_ := mch_code_;
      site_ := contract_;
      FOR child in get_part_struc LOOP
         Equipment_Serial_API.Concatenate_Object__(object_, child.part_no, child.serial_no);
         
         part_serial_catalog_rec_ := Part_Serial_Catalog_API.Get(child.part_no, child.serial_no);
         OPEN get_part(part_serial_catalog_rec_.superior_part_no, part_serial_catalog_rec_.superior_serial_no);
         FETCH get_part INTO sup_contract_, sup_mch_code_;
         CLOSE get_part;

         Client_SYS.Clear_Attr(attr2_);
         Client_SYS.Add_To_Attr('MCH_CODE', object_,  attr2_);
         Client_SYS.Add_To_Attr('CONTRACT', sup_contract_,  attr2_);
         Client_SYS.Add_To_Attr('PART_NO', child.part_no,  attr2_);
         Client_SYS.Add_To_Attr('SERIAL_NO', child.serial_no,  attr2_);
         Client_SYS.Add_To_Attr('SUP_MCH_CODE', sup_mch_code_, attr2_);
         Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_), attr2_);
         Client_SYS.Add_To_Attr('SUP_CONTRACT', sup_contract_, attr2_);
         Client_SYS.Add_To_Attr('DESIGN_OBJECT', '2',  attr2_);

         IF NOT (Equipment_Serial_API.Check_Serial_Exist(child.part_no, child.serial_no) = 'TRUE') THEN
            Equipment_Serial_API.New__ (info_, objid_, objversion_, attr2_, 'DO');
         END IF;
      END LOOP;
   END IF;
END Move_From_Invent_To_Facility;

--This method should only be called from state events in part serial.
PROCEDURE Remove_Superior_Info (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   attr_       VARCHAR2 (2000);
   info_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ VARCHAR2(2000);
--   lu_rec_     EQUIPMENT_OBJECT%ROWTYPE;
   dummy_null_ VARCHAR2(5) := NULL;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Equipment_Object_Conn_API.Remove_Obj_Conn(contract_, mch_code_);
--   lu_rec_ := Get_Instance___(contract_, mch_code_);
   Get_Id_Version_By_Keys__(objid_, objversion_, contract_, mch_code_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE',          dummy_null_, attr_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT',          dummy_null_, attr_);
   Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', dummy_null_, attr_);
   Modify__( info_, objid_, objversion_, attr_, 'DO' );

END Remove_Superior_Info;

PROCEDURE Include_On_Contact_Line (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   include_line_ IN VARCHAR2)
IS
   attr_       VARCHAR2 (2000);
   info_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys__(objid_, objversion_, contract_, mch_code_);
   Client_SYS.Add_To_Attr('INSERT_SRV', include_line_, attr_);

   Modify__(info_, objid_, objversion_, attr_, 'DO' );

END Include_On_Contact_Line;

@UncheckedAccess
FUNCTION Is_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
op_status_ EQUIPMENT_OBJECT.operational_status%TYPE;
CURSOR get_state IS
   SELECT operational_status
   FROM   EQUIPMENT_OBJECT
   WHERE  contract = contract_
   AND    mch_code = mch_code_;

BEGIN
   OPEN get_state;
   FETCH get_state INTO op_status_;
   IF (serial_operational_status_api.encode(op_status_) = 'SCRAPPED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
   CLOSE get_state;
END Is_Scrapped;


@UncheckedAccess
FUNCTION Check_Serial_Exist (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
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


PROCEDURE Fetch_Object_Details (
   part_no_ OUT VARCHAR2,
   serial_no_ OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
CURSOR get_attr IS
   SELECT part_no, mch_serial_no
   FROM EQUIPMENT_OBJECT_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO part_no_, serial_no_;
   CLOSE get_attr;
END Fetch_Object_Details;

PROCEDURE Fetch_Serial_Part_Details (
   contract_  OUT VARCHAR2,
   mch_code_  OUT VARCHAR2,
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT contract, mch_code
      FROM EQUIPMENT_OBJECT_TAB
      WHERE part_no = part_no_
      AND mch_serial_no = serial_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO contract_, mch_code_;
   CLOSE get_attr;
END Fetch_Serial_Part_Details;

@UncheckedAccess
FUNCTION Get_Design_Status (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Plades_SYS.INSTALLED $THEN
      temp_ plant_object.state%TYPE;
      CURSOR get_attr IS
         SELECT state
            FROM  plant_object
            WHERE site = upper(contract_)
            AND   keya = upper(mch_code_);
   $END
BEGIN
   IF (contract_ IS NULL OR mch_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   $IF Component_Plades_SYS.INSTALLED $THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;
   $ELSE
      RETURN NULL;
   $END
END Get_Design_Status;

@UncheckedAccess
FUNCTION Get_Design_Status_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Plades_SYS.INSTALLED $THEN
      temp_ plant_object.objstate%TYPE;
      CURSOR get_attr IS
         SELECT objstate
            FROM  plant_object
            WHERE site = upper(contract_)
            AND   keya = upper(mch_code_);
   $END
BEGIN
   IF (contract_ IS NULL OR mch_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   $IF Component_Plades_SYS.INSTALLED $THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;
   $ELSE
      RETURN NULL;
   $END
END Get_Design_Status_Db;


FUNCTION Get_Contract (
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Equipment_Object_API.Get_Def_Contract(mch_code_);
END Get_Contract;

@UncheckedAccess
FUNCTION Get_Def_Contract(
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_TAB.contract%TYPE;
   count_ NUMBER;
   contract_ EQUIPMENT_OBJECT_TAB.contract%TYPE;
   dummy_ NUMBER;

CURSOR get_attr IS
   SELECT contract
   FROM EQUIPMENT_OBJECT_TAB
   WHERE mch_code = mch_code_
   AND contract = User_Allowed_Site_API.Authorized(CONTRACT);

CURSOR get_count IS
   SELECT COUNT(*)
   FROM EQUIPMENT_OBJECT_TAB
   WHERE mch_code = mch_code_
   AND contract = User_Allowed_Site_API.Authorized(CONTRACT);

CURSOR exist_control(contract_ IN VARCHAR2)IS
    SELECT 1
    FROM   EQUIPMENT_OBJECT_TAB
   WHERE mch_code = mch_code_
   AND contract = contract_ ;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;

   contract_ := User_default_API.Get_Contract;

   IF count_ >1 THEN
     OPEN exist_control(contract_);
     FETCH exist_control INTO dummy_;
     IF (exist_control%FOUND) THEN
      temp_ := contract_;
     ELSE
      temp_ := NULL;
     END IF;
     CLOSE exist_control;
   END IF;

   RETURN temp_;
END Get_Def_Contract;


@UncheckedAccess
FUNCTION Exist_AnyWhere (
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  mch_code = mch_code_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Exist_AnyWhere;


@UncheckedAccess
FUNCTION Get_Sup_Objects (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   sup_obj_list_           VARCHAR2(10000);
   counter_                NUMBER;
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_superior_objects IS
      SELECT sup_mch_code
      FROM EQUIPMENT_OBJECT
      WHERE functional_object_seq IS NOT NULL AND contract = contract_
      START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY equipment_object_seq = PRIOR functional_object_seq;

BEGIN

   sup_obj_list_ := '' ;
   counter_      := 0;


   FOR sup_object_ IN get_superior_objects LOOP
      IF ( counter_ > 0 ) THEN
         sup_obj_list_ := sup_obj_list_ || ',' ;
      END IF;

      sup_obj_list_ := sup_obj_list_ || '''' || sup_object_.sup_mch_code || '''' ;
      counter_      := counter_ + 1;
   END LOOP;

   RETURN sup_obj_list_ ;

END Get_Sup_Objects;

@UncheckedAccess
FUNCTION Has_Structure_Type (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   structure_type_ IN VARCHAR2   ) RETURN VARCHAR2
IS
BEGIN
   RETURN Has_Structure_Type(Get_Equipment_Object_Seq(contract_, mch_code_), structure_type_);
END Has_Structure_Type;

@UncheckedAccess
FUNCTION Has_Structure_Type (
   equipment_object_seq_   IN NUMBER,
   structure_type_         IN VARCHAR2 ) RETURN VARCHAR2
IS

CURSOR f_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  functional_object_seq = equipment_object_seq_;

CURSOR l_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  location_object_seq = equipment_object_seq_;

CURSOR r_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  from_object_seq = equipment_object_seq_;

CURSOR t_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  to_object_seq  = equipment_object_seq_;

CURSOR p_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  process_object_seq  = equipment_object_seq_;

CURSOR s_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  pipe_object_seq  = equipment_object_seq_;

CURSOR e_mch IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE  circuit_object_seq = equipment_object_seq_;


dummy_ NUMBER;

BEGIN
   dummy_ := 0;

   IF structure_type_ = 'F' THEN
      OPEN f_mch;
      FETCH f_mch INTO dummy_;
      CLOSE f_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'L' THEN
      OPEN l_mch;
      FETCH l_mch INTO dummy_;
      CLOSE l_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'R' THEN
      OPEN r_mch;
      FETCH r_mch INTO dummy_;
      CLOSE r_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'T' THEN
      OPEN t_mch;
      FETCH t_mch INTO dummy_;
      CLOSE t_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'P' THEN
      OPEN p_mch;
      FETCH p_mch INTO dummy_;
      CLOSE p_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'S' THEN
      OPEN s_mch;
      FETCH s_mch INTO dummy_;
      CLOSE s_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF structure_type_ = 'E' THEN
      OPEN e_mch;
      FETCH e_mch INTO dummy_;
      CLOSE e_mch;
      IF (dummy_ = 0) THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSE
      RETURN 'FALSE';
   END IF;

END Has_Structure_Type;

@UncheckedAccess
FUNCTION Get_Tooltip_Text (
   key_ref_ IN VARCHAR2) RETURN VARCHAR2
IS
   tooltip_text_        CLOB;
   contract_            Equipment_Object.contract%TYPE;
   mch_code_            Equipment_Object.mch_code%TYPE;
   equip_obj_record_    Equipment_Object_APi.Public_Rec;
BEGIN
   contract_ := Equipment_Object_API.Get_Contract(to_number(Client_Sys.Get_Key_Reference_Value(key_ref_, 'EQUIPMENT_OBJECT_SEQ')));
   mch_code_ := Equipment_Object_API.Get_Mch_Code(to_number(Client_Sys.Get_Key_Reference_Value(key_ref_, 'EQUIPMENT_OBJECT_SEQ')));
   equip_obj_record_ := Equipment_Object_API.Get(contract_,mch_code_);
   tooltip_text_ := '<table width="100%" ><tr><td nowrap><b>'||Language_Sys.Translate_Item_Prompt_('EQUIPMENT_OBJECT.MCH_CODE',Dictionary_Sys.Get_Item_Prompt_Active(lu_name_, 'EQUIPMENT_OBJECT', 'MCH_CODE'), 0)|| ': </b></td><td>'|| mch_code_ ||'</td></tr>' ||
                    '<tr><td nowrap><b>'||Language_Sys.Translate_Item_Prompt_('EQUIPMENT_OBJECT.CONTRACT',Dictionary_Sys.Get_Item_Prompt_Active(lu_name_, 'EQUIPMENT_OBJECT', 'CONTRACT'), 0)|| ': </b></td><td>'|| contract_ || ' - ' || Site_Api.Get_Description(contract_)|| '</td></tr>' ||
                    '<tr><td nowrap><b>'||Language_Sys.Translate_Item_Prompt_('EQUIPMENT_OBJECT.OBJ_LEVEL',Dictionary_Sys.Get_Item_Prompt_Active(lu_name_, 'EQUIPMENT_OBJECT', 'OBJ_LEVEL'), 0)|| ': </b></td><td>'|| Get_Obj_Level(contract_, mch_code_) || '</td></tr>' ||
                    '<tr><td nowrap><b>'||Language_Sys.Translate_Item_Prompt_('EQUIPMENT_OBJECT.OPERATIONAL_STATUS',Dictionary_Sys.Get_Item_Prompt_Active(lu_name_, 'EQUIPMENT_OBJECT', 'OPERATIONAL_STATUS'), 0)|| ': </b></td><td>'|| Equipment_Functional_Api.Get_Operational_Status(contract_, mch_code_) || '</td></tr></table>';

   RETURN tooltip_text_;
END Get_Tooltip_Text;

@UncheckedAccess
FUNCTION Get_Note (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT.note%TYPE;
   CURSOR get_attr IS
      SELECT note
      FROM EQUIPMENT_OBJECT
      WHERE contract = contract_
      AND   mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Note;


@UncheckedAccess
FUNCTION Has_Notes (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
CURSOR note IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT
   WHERE  contract = contract_
   AND    mch_code = mch_code_
   AND    NOTE IS NOT NULL;

dummy_   NUMBER;
result_  VARCHAR2(5);

BEGIN
   OPEN note;
   FETCH note INTO dummy_;
   IF (note%NOTFOUND) THEN
       result_ := 'FALSE';
   ELSE
       result_ := 'TRUE';
   END IF;
   CLOSE note;
   RETURN result_;
END Has_Notes;


-- Set_In_Operation
--   Set the operational_status for functional and serial objects to 'In Operation'
PROCEDURE Set_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_, mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_In_Operation(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_In_Operation(contract_, mch_code_);
   END IF;
END Set_In_Operation;


-- Set_Out_Of_Operation
--   Set the operational_status for functional and serial objects to 'Out of Operation'
PROCEDURE Set_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_, mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Out_Of_Operation(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_Out_Of_Operation(contract_, mch_code_);
   END IF;
END Set_Out_Of_Operation;


-- Set_Scrapped
--   Set the operational_status for functional and serial objects to 'Scrapped'
PROCEDURE Set_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Scrapped(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_Scrapped(contract_, mch_code_);
   END IF;
END Set_Scrapped;


-- Set_Structure_Planned_For_Op
--   Set the operational_status for a functional/serial to 'Planned for Operation'
--   All the children of the functional/serial will also be updated.
PROCEDURE Set_Structure_Planned_For_Op (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Structure_Planned_For_Op(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_Structure_Planned_For_Op(contract_, mch_code_);
   END IF;
END Set_Structure_Planned_For_Op;


-- Set_Structure_In_Operation
--   Set the operational_status for a functional/serial to 'In Operation'
--   All the children of the functional/serial will also be updated.
PROCEDURE Set_Structure_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Structure_In_Operation(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_Structure_In_Operation(contract_, mch_code_);
   END IF;
END Set_Structure_In_Operation;


-- Set_Structure_Out_Of_Operation
--   Set the operational_status for a functional/serial to 'Out of Operation'
--   All the children of the functional/serial will also be updated.
PROCEDURE Set_Structure_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Structure_Out_Of_Operation(contract_, mch_code_);
   ELSE
      Equipment_Serial_API.Set_Structure_Out_Of_Operation(contract_, mch_code_);
   END IF;
END Set_Structure_Out_Of_Operation;


-- Set_Structure_Scrapped
--   Set the operational_status for a functional/serial to 'Scrapped'
--   All the children of the functional/serial will also be updated.
PROCEDURE Set_Structure_Scrapped (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2, 
   structure_type_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      Equipment_Functional_API.Set_Structure_Scrapped(contract_, mch_code_, NULL, structure_type_);
   ELSE
      Equipment_Serial_API.Set_Structure_Scrapped(contract_, mch_code_);
   END IF;
END Set_Structure_Scrapped;


-- Activate_In_Operation
--   Return the string value 'TRUE' if transition to operational status
--   'In Operation' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_In_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      IF (Equipment_Functional_API.Is_Planned_For_Operation(contract_, mch_code_)='TRUE' OR Equipment_Functional_API.Is_Out_Of_Operation(contract_, mch_code_)='TRUE') THEN
        RETURN 'TRUE';
      ELSE
        RETURN 'FALSE';
      END IF;
   ELSE
      IF (Equipment_Serial_API.Activate_In_Operation(contract_, mch_code_) ='TRUE') THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END IF;
END Activate_In_Operation;


-- Activate_Out_Of_Operation
--   Return the string value 'TRUE' if transition to operational status
--   'Out of Operation' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Out_Of_Operation (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      IF (Equipment_Functional_API.Is_In_Operation(contract_, mch_code_)='TRUE' OR Equipment_Functional_API.Is_Scrapped(contract_, mch_code_)='TRUE') THEN
        RETURN 'TRUE';
      ELSE
        RETURN 'FALSE';
      END IF;
   ELSE
      IF (Equipment_Serial_API.Activate_Out_Of_Operation(contract_, mch_code_) ='TRUE') THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END IF;
END Activate_Out_Of_Operation;


-- Activate_Scrapped
--   Return the string value 'TRUE' if transition to operational status
--   'Scrapped' is valid, if not return 'FALSE'.
@UncheckedAccess
FUNCTION Activate_Scrapped (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Obj_Level(contract_,mch_code_) IS NOT NULL) THEN
      IF (Equipment_Functional_API.Is_Out_Of_Operation(contract_, mch_code_)='TRUE') THEN
        RETURN 'TRUE';
      ELSE
        RETURN 'FALSE';
      END IF;
   ELSE
      IF (Equipment_Serial_API.Activate_Scrapped(contract_, mch_code_) ='TRUE') THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END IF;
END Activate_Scrapped;


@UncheckedAccess
FUNCTION Get_Operational_Status (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ MAINTENANCE_OBJECT.operational_status%TYPE;
   CURSOR get_attr IS
      SELECT operational_status
      FROM EQUIPMENT_OBJECT
      WHERE contract = contract_
      AND   mch_code = mch_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Operational_Status;


@UncheckedAccess
FUNCTION Get_Operational_Status_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Operational_Status_Db(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Operational_Status_Db;

@UncheckedAccess
FUNCTION Get_Operational_Status_Db (
   equipment_object_seq_ IN NUMBER) RETURN VARCHAR2
IS
   temp_ MAINTENANCE_OBJECT.operational_status_db%TYPE;
   CURSOR get_attr IS
      SELECT operational_status_db
      FROM EQUIPMENT_OBJECT
      WHERE equipment_object_seq = equipment_object_seq_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Operational_Status_Db;


FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
   IF (Check_Maint_Obj_Exist___(contract_, mch_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;

PROCEDURE Get_Id_Version_By_Keys__ (
   objid_       IN OUT NOCOPY VARCHAR2,
   objversion_  IN OUT NOCOPY VARCHAR2,
   contract_    IN VARCHAR2,
   mch_code_    IN VARCHAR2)
IS
BEGIN
   SELECT rowid, to_char(rowversion)
      INTO  objid_, objversion_
      FROM  equipment_object_tab
      WHERE contract = contract_
      AND   mch_code = mch_code_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
END Get_Id_Version_By_Keys__;

@UncheckedAccess
FUNCTION Decode_Maint_Conn (
   db_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN

   $IF Component_Wo_SYS.INSTALLED $THEN
      RETURN Maint_Connection_Type_API.Decode(db_value_);
   $ELSE
      RETURN NULL;
   $END

END Decode_Maint_Conn;

@UncheckedAccess
PROCEDURE Get_Eon_Counts (
   structure_              IN  VARCHAR2,
   mch_code_               IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   manit_plan_count_       OUT NUMBER,
   pm_count_               OUT NUMBER,
   all_pm_count_           OUT NUMBER,
   active_wo_count_        OUT NUMBER,
   all_active_wo_count_    OUT NUMBER,
   histrocal_wo_count_     OUT NUMBER,
   task_count_             OUT NUMBER,
   all_task_count_         OUT NUMBER,
   sevice_line_count_      OUT NUMBER,
   all_sevice_line_count_  OUT NUMBER,
   serial_obj_count_       OUT NUMBER,
   measurement_count_      OUT NUMBER,
   obj_count_              OUT NUMBER,
   all_obj_count_          OUT NUMBER,
   conn_obj_count_         OUT NUMBER,
   object_address_count_   OUT NUMBER,
   hist_task_count_        OUT NUMBER,
   task_step_count_        OUT NUMBER,
   all_task_step_count_    OUT NUMBER,
   hist_task_step_count_   OUT NUMBER)
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   
   CURSOR get_ser_count IS
      SELECT count(*)
      FROM   equipment_object_tab a, part_serial_catalog_pub b
      WHERE  a.part_no = b.part_no
      AND    a.mch_serial_no = b.serial_no
      AND    a.obj_level IS NULL
      AND    contract = User_Allowed_Site_API.Authorized(contract_)
      AND    mch_code = mch_code_;

   CURSOR get_meas_count IS
      SELECT count(*)
      FROM   EQUIPMENT_OBJECT_MEAS_TAB
      WHERE  contract = User_Allowed_Site_API.Authorized(contract_)
      AND    mch_code = mch_code_;

   CURSOR get_obj_count IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE  contract = User_Allowed_Site_API.Authorized(contract)
      AND    functional_object_seq = equipment_object_seq_;

   CURSOR get_all_obj_count IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE  contract = User_Allowed_Site_API.Authorized(contract)
      START WITH functional_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;

   CURSOR get_obj_conn_count IS
      SELECT count(*)
      FROM   EQUIPMENT_OBJECT_CONN_TAB
      WHERE  contract = User_Allowed_Site_API.Authorized(contract_)
      AND    mch_code = mch_code_
      AND   (SELECT operational_status_db
               FROM   Maintenance_object
               WHERE contract = contract_
               AND   mch_code = mch_code_) != 'SCRAPPED'
      AND    (SELECT operational_status_db
               FROM   Maintenance_object
               WHERE contract = contract_consist
               AND   mch_code = mch_code_consist) != 'SCRAPPED';

   CURSOR get_obj_count_l IS
      SELECT count(*)
      FROM   equipment_object
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      AND location_mch_code = mch_code_
      AND location_contract = contract_;

   CURSOR get_all_obj_count_l IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      START WITH location_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = location_object_seq ;

   CURSOR get_obj_count_r IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      AND from_object_seq  = equipment_object_seq_;

   CURSOR get_all_obj_count_r IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      START WITH from_object_seq  = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = from_object_seq;

   CURSOR get_obj_count_t IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      AND to_object_seq  = equipment_object_seq_;

   CURSOR get_all_obj_count_t IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      START WITH to_object_seq  = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = to_object_seq;

   CURSOR get_obj_count_s IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      AND pipe_object_seq  = equipment_object_seq_;

   CURSOR get_all_obj_count_s IS
      SELECT count(*)
      FROM equipment_object_tab
      WHERE contract = User_Allowed_Site_API.Authorized(contract)
      START WITH pipe_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = pipe_object_seq;

   CURSOR get_obj_count_p IS
      SELECT count(*)
      FROM equipment_object_tab
      WHERE contract = User_Allowed_Site_API.Authorized(contract)
      AND process_object_seq  = equipment_object_seq_;

   CURSOR get_all_obj_count_p IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      START WITH process_object_seq  = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = process_object_seq;

   CURSOR get_obj_count_e IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      AND circuit_object_seq = equipment_object_seq_;

   CURSOR get_all_obj_count_e IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE   contract = User_Allowed_Site_API.Authorized(contract)
      START WITH circuit_object_seq  = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = circuit_object_seq;

BEGIN

   OPEN get_ser_count;
   FETCH get_ser_count INTO serial_obj_count_;
   CLOSE get_ser_count;
   OPEN get_meas_count;
   FETCH get_meas_count INTO measurement_count_;
   CLOSE get_meas_count;
   OPEN get_obj_count;
   FETCH get_obj_count INTO obj_count_;
   CLOSE get_obj_count;
   OPEN get_all_obj_count;
   FETCH get_all_obj_count INTO all_obj_count_;
   CLOSE get_all_obj_count;
   OPEN get_obj_conn_count;
   FETCH get_obj_conn_count INTO conn_obj_count_;
   CLOSE get_obj_conn_count;
   CASE structure_
     WHEN  'F' THEN
         OPEN get_obj_count;
         FETCH get_obj_count INTO obj_count_;
         CLOSE get_obj_count;
         OPEN get_all_obj_count;
         FETCH get_all_obj_count INTO all_obj_count_;
         CLOSE get_all_obj_count;
     WHEN 'L' THEN
         OPEN get_obj_count_l;
         FETCH get_obj_count_l INTO obj_count_;
         CLOSE get_obj_count_l;
         OPEN get_all_obj_count_l;
         FETCH get_all_obj_count_l INTO all_obj_count_;
         CLOSE get_all_obj_count_l;
     WHEN 'R' THEN
         OPEN get_obj_count_r;
         FETCH get_obj_count_r INTO obj_count_;
         CLOSE get_obj_count_r;
         OPEN get_all_obj_count_r;
         FETCH get_all_obj_count_r INTO all_obj_count_;
         CLOSE get_all_obj_count_r;
     WHEN 'T' THEN
         OPEN get_obj_count_t;
         FETCH get_obj_count_t INTO obj_count_;
         CLOSE get_obj_count_t;
         OPEN get_all_obj_count_t;
         FETCH get_all_obj_count_t INTO all_obj_count_;
         CLOSE get_all_obj_count_t;
     WHEN 'S' THEN
         OPEN get_obj_count_s;
         FETCH get_obj_count_s INTO obj_count_;
         CLOSE get_obj_count_s;
         OPEN get_all_obj_count_s;
         FETCH get_all_obj_count_s INTO all_obj_count_;
         CLOSE get_all_obj_count_s;
     WHEN 'P' THEN
         OPEN get_obj_count_p;
         FETCH get_obj_count_p INTO obj_count_;
         CLOSE get_obj_count_p;
         OPEN get_all_obj_count_p;
         FETCH get_all_obj_count_p INTO all_obj_count_;
         CLOSE get_all_obj_count_p;
     WHEN 'E' THEN
         OPEN get_obj_count_e;
         FETCH get_obj_count_e INTO obj_count_;
         CLOSE get_obj_count_e;
         OPEN get_all_obj_count_e;
         FETCH get_all_obj_count_e INTO all_obj_count_;
         CLOSE get_all_obj_count_e;
         OPEN get_all_obj_count_e;
     ELSE NULL;
   END CASE;
   $IF Component_Pm_SYS.INSTALLED $THEN
      PM_ACTION_API.Get_Eon_Pm_Counts(manit_plan_count_, pm_count_, all_pm_count_, contract_, mch_code_);
   $ELSE
      NULL;
   $END

   $IF Component_Wo_SYS.INSTALLED $THEN
      ACTIVE_SEPARATE_API.Get_Eon_Wo_Counts(active_wo_count_, all_active_wo_count_, contract_, mch_code_);
   $ELSE
      NULL;
   $END

   $IF Component_Wo_SYS.INSTALLED $THEN
      HISTORICAL_WORK_ORDER_API.Get_Eon_Hist_Wo_Counts(histrocal_wo_count_, contract_, mch_code_);
   $ELSE
      NULL;
   $END

   $IF Component_Wo_SYS.INSTALLED $THEN
      JT_TASK_API.Get_Eon_Task_Counts(task_count_, all_task_count_, hist_task_count_,contract_, mch_code_);
   $ELSE
      NULL;
   $END
   $IF Component_Wo_SYS.INSTALLED $THEN
      JT_TASK_STEP_API.Get_Eon_Task_Step_Counts(task_step_count_, all_task_step_count_, hist_task_step_count_,contract_, mch_code_);
   $ELSE
      NULL;
   $END

   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      Psc_Contr_Product_Scope_API.Get_Eon_Sc_Counts(sevice_line_count_, all_sevice_line_count_, contract_, mch_code_);
   $ELSE
      NULL;
   $END
END Get_Eon_Counts;


--This function will return if there exist atleast one serial object in the structure that is not in operational condition
@UncheckedAccess
FUNCTION Exist_Warning (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_all_children IS
      SELECT contract, mch_code, obj_level
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  functional_object_seq IS NOT NULL
      START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;

      warning_ VARCHAR2(5) := 'FALSE';
BEGIN
   FOR next_child_ IN get_all_children LOOP
     IF (next_child_.obj_level IS NULL) THEN
       IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(Equipment_Serial_API.Get_Part_No(next_child_.contract, next_child_.mch_code), Equipment_Serial_API.Get_Serial_No(next_child_.contract, next_child_.mch_code)) != 'OPERATIONAL' THEN
          warning_ :='TRUE';
          EXIT;
       END IF;
     END IF;
   END LOOP;
   RETURN warning_;
END Exist_Warning;

--To see it's a child of a non operational parent
FUNCTION Exist_Non_Operational_Parent (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(5) := 'FALSE';
   sup_mch_code_ EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   sup_contract_ EQUIPMENT_OBJECT_TAB.contract%TYPE;

BEGIN
   sup_contract_ := Get_Sup_Contract(contract_, mch_code_);
   sup_mch_code_ := Get_Sup_Mch_Code(contract_, mch_code_);

   WHILE (exist_ = 'FALSE' AND sup_mch_code_ IS NOT NULL) LOOP
      IF Get_Obj_Level(sup_contract_,sup_mch_code_) IS NULL THEN
         IF Part_Serial_Catalog_API.Get_Operational_Condition_Db(Equipment_Serial_API.Get_Part_No(sup_contract_,sup_mch_code_), Equipment_Serial_API.Get_Serial_No(sup_contract_,sup_mch_code_))  != 'OPERATIONAL' THEN
            exist_ := 'TRUE';
         END IF;
      END IF;
      sup_contract_ := Get_Sup_Contract(sup_contract_, sup_mch_code_);
      sup_mch_code_ := Get_Sup_Mch_Code(sup_contract_, sup_mch_code_);

   END LOOP;
   RETURN exist_;
END Exist_Non_Operational_Parent;

FUNCTION Add_To_Pre_Accounting (
   pre_accounting_rec_ IN OUT Pre_Accounting_API.Public_Rec,
   company_            IN VARCHAR2,
   mch_code_contract_  IN VARCHAR2,
   mch_code_           IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_         public_Rec;
   insert_done_ BOOLEAN;
   code_part_                  VARCHAR2(10);
   view_name_                  VARCHAR2(30);
   pkg_name_                   VARCHAR2(30);
   internal_name_              VARCHAR2(30);
   logical_code_part_          VARCHAR2(100);

BEGIN

   IF mch_code_contract_ IS NULL OR mch_code_ IS NULL THEN
      RETURN FALSE;
   END IF;

   IF Site_API.Get_Company(mch_code_contract_) != company_ THEN
      RETURN FALSE;
   END IF;

   rec_ := Get(mch_code_contract_, mch_code_);

   IF (NOT Is_Address__(mch_code_contract_, mch_code_ )) THEN

      IF ( NOT ((Part_Serial_Catalog_API.Is_In_Repair_Workshop( rec_.part_no, rec_.mch_serial_no )  = 'TRUE') OR
                (Part_Serial_Catalog_API.Is_In_Facility( rec_.part_no, rec_.mch_serial_no )  = 'TRUE') OR
                (Part_Serial_Catalog_API.Is_Contained( rec_.part_no, rec_.mch_serial_no )  = 'TRUE')) ) THEN
         -- Serial object not in facility, repshop or contained
         RETURN FALSE;
      END IF;
   END IF;

   IF rec_.cost_center IS NULL AND rec_.object_no IS NULL THEN
      RETURN FALSE;
   END IF;

   insert_done_ := FALSE;

   IF rec_.cost_center IS NOT NULL THEN
      logical_code_part_ := 'CostCenter';
      Maintenance_Accounting_API.Check_Object_Used(code_part_,view_name_,pkg_name_,internal_name_,company_,logical_code_part_);
      IF code_part_ IS NOT NULL THEN
         insert_done_ := TRUE;
         IF code_part_ = 'B' THEN
            pre_accounting_rec_.codeno_b := rec_.cost_center;
         ELSIF code_part_ = 'C' THEN
            pre_accounting_rec_.codeno_c := rec_.cost_center;
         ELSIF code_part_ = 'D' THEN
            pre_accounting_rec_.codeno_d := rec_.cost_center;
         ELSIF code_part_ = 'E' THEN
            pre_accounting_rec_.codeno_e := rec_.cost_center;
         ELSIF code_part_ = 'F' THEN
            pre_accounting_rec_.codeno_f := rec_.cost_center;
         ELSIF code_part_ = 'G' THEN
            pre_accounting_rec_.codeno_g := rec_.cost_center;
         ELSIF code_part_ = 'H' THEN
            pre_accounting_rec_.codeno_h := rec_.cost_center;
         ELSIF code_part_ = 'I' THEN
            pre_accounting_rec_.codeno_i := rec_.cost_center;
         ELSIF code_part_ = 'J' THEN
            pre_accounting_rec_.codeno_j := rec_.cost_center;
         END IF;
      END IF;
   END IF;

   IF rec_.object_no IS NOT NULL THEN
      logical_code_part_ := 'Object';
      Maintenance_Accounting_API.Check_Object_Used(code_part_,view_name_,pkg_name_,internal_name_,company_,logical_code_part_);
      IF code_part_ IS NOT NULL THEN
         insert_done_ := TRUE;
         IF code_part_ = 'B' THEN
            pre_accounting_rec_.codeno_b := rec_.object_no;
         ELSIF code_part_ = 'C' THEN
            pre_accounting_rec_.codeno_c := rec_.object_no;
         ELSIF code_part_ = 'D' THEN
            pre_accounting_rec_.codeno_d := rec_.object_no;
         ELSIF code_part_ = 'E' THEN
            pre_accounting_rec_.codeno_e := rec_.object_no;
         ELSIF code_part_ = 'F' THEN
            pre_accounting_rec_.codeno_f := rec_.object_no;
         ELSIF code_part_ = 'G' THEN
            pre_accounting_rec_.codeno_g := rec_.object_no;
         ELSIF code_part_ = 'H' THEN
            pre_accounting_rec_.codeno_h := rec_.object_no;
         ELSIF code_part_ = 'I' THEN
            pre_accounting_rec_.codeno_i := rec_.object_no;
         ELSIF code_part_ = 'J' THEN
            pre_accounting_rec_.codeno_j := rec_.object_no;
         END IF;
      END IF;
   END IF;

   IF insert_done_ THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;

END Add_To_Pre_Accounting;


FUNCTION Get_Incident_Count (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   asset_manager_  IN VARCHAR2,
   incident_month_ IN VARCHAR2) RETURN NUMBER
IS
   temp_  NUMBER := 0;
   
   $IF Component_Osha_SYS.INSTALLED $THEN
      CURSOR get_incidents_no IS
         SELECT count(distinct incident_reference_no)
         FROM EQUIPMENT_INCIDENT ei
         WHERE incident_month = incident_month_
         AND contract = contract_
         AND (((object_id LIKE nvl(mch_code_, '%'))
                AND ((lu_name = 'EquipmentObject'
                     AND EXISTS(SELECT 1 FROM equipment_object_party WHERE contract = ei.contract AND mch_code = object_id AND identity = asset_manager_ AND party_type_db = 'ASSET_MANAGER') ) OR lu_name != 'EquipmentObject'))
                OR (lu_name = 'EquipmentObject'
                   AND object_id IN (SELECT MCH_CODE
                                     FROM EQUIPMENT_OBJECT_UIV
                                     START WITH SUP_MCH_CODE = UPPER(mch_code_)
                                     AND SUP_CONTRACT = UPPER(contract_)
                                     CONNECT BY PRIOR MCH_CODE = SUP_MCH_CODE
                                     AND PRIOR CONTRACT = SUP_CONTRACT)
          AND EXISTS(SELECT 1 FROM equipment_object_party WHERE contract = ei.contract AND mch_code = object_id AND identity = asset_manager_ AND party_type_db = 'ASSET_MANAGER')));

   $END

BEGIN
   $IF Component_Osha_SYS.INSTALLED $THEN
      OPEN get_incidents_no;
      FETCH get_incidents_no INTO temp_;
      CLOSE get_incidents_no;
   $ELSE
      NULL;
   $END

   RETURN temp_;
END Get_Incident_Count;


FUNCTION Get_Avg_Risk_Potential(
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   asset_manager_  IN VARCHAR2,
   incident_month_ IN VARCHAR2) RETURN NUMBER
IS
   temp_     NUMBER := 0;
   count_    NUMBER := 0;
   avg_risk_ NUMBER := 0;

   $IF Component_Osha_SYS.INSTALLED $THEN
      CURSOR get_risk_potential IS
         SELECT risk_potential
         FROM ASSET_RISK_ASSESSMENT ara
         WHERE to_char(plan_date, 'YYYY-MM') = incident_month_
         AND contract = contract_
         AND (((object_id LIKE nvl(mch_code_, '%'))
                AND ((lu_name = 'EquipmentObject'
                     AND EXISTS(SELECT 1 FROM equipment_object_party WHERE contract = ara.contract AND mch_code = object_id AND identity = asset_manager_ AND party_type_db = 'ASSET_MANAGER') ) OR lu_name != 'EquipmentObject'))
                OR (lu_name = 'EquipmentObject'
                   AND object_id IN (SELECT MCH_CODE
                                     FROM EQUIPMENT_OBJECT_UIV
                                     START WITH SUP_MCH_CODE = mch_code_
                                     AND SUP_CONTRACT = contract_
                                     CONNECT BY PRIOR MCH_CODE = SUP_MCH_CODE
                                     AND PRIOR CONTRACT = SUP_CONTRACT)
          AND EXISTS(SELECT 1 FROM equipment_object_party WHERE contract = ara.contract AND mch_code = object_id AND identity = asset_manager_ AND party_type_db = 'ASSET_MANAGER')))
       GROUP BY risk_assessment_no, risk_potential;
   $END

BEGIN
   $IF Component_Osha_SYS.INSTALLED $THEN
      FOR rec_ IN get_risk_potential LOOP
         IF rec_.risk_potential IS NOT NULL THEN
            count_ := count_ +1;
            temp_ := temp_ + rec_.risk_potential;
         END IF;
      END LOOP;

      IF(count_ != 0) THEN
         avg_risk_ := temp_ / count_;
      END IF;

   $ELSE
      NULL;
   $END

   RETURN avg_risk_;
END Get_Avg_Risk_Potential;

PROCEDURE Remove_Object_References (
        key_ IN VARCHAR2)
IS
BEGIN
   TECHNICAL_OBJECT_REFERENCE_API.Delete_Reference ('EquipmentObject',key_);
   IF Maintenance_Document_Ref_API.Exist_Obj_Reference('EquipmentObject', key_) = 'TRUE' THEN
      Maintenance_Document_Ref_API.Delete_Obj_Reference('EquipmentObject', key_);
   END IF;
END Remove_Object_References;


PROCEDURE Set_Location_Structure (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   location_id_    IN VARCHAR2)
IS
   objid_                  ROWID;
   objversion_             VARCHAR2(2000);
   info_                   VARCHAR2(2000);
   attr_                   VARCHAR2(2000);
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_data IS
      SELECT contract, mch_code
      FROM  EQUIPMENT_OBJECT_TAB
      WHERE contract||mch_code != contract_||mch_code_
      START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;
BEGIN
   FOR get_data_ IN get_data LOOP
      Get_Id_Version_By_Keys__(objid_, objversion_, get_data_.contract, get_data_.mch_code);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOCATION_ID', location_id_, attr_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Set_Location_Structure;


PROCEDURE Reset_Location_Structure (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2)
IS
   location_id_            Equipment_Object_Tab.location_id%TYPE;
   objid_                  ROWID;
   objversion_             VARCHAR2(2000);
   info_                   VARCHAR2(2000);
   attr_                   VARCHAR2(2000);
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_data IS
      SELECT contract, mch_code
      FROM  EQUIPMENT_OBJECT_TAB
      WHERE contract||mch_code != contract_||mch_code_
      START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;
BEGIN
   FOR get_data_ IN get_data LOOP
      Get_Id_Version_By_Keys__(objid_, objversion_, get_data_.contract, get_data_.mch_code);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOCATION_ID', location_id_, attr_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Reset_Location_Structure;


FUNCTION Is_obj_Exist_On_More_Sites (
   object_id_          IN VARCHAR2,
        connection_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   object_site_ Equipment_Object_TAB.contract%TYPE;

   /*This Function is used by JtObjectConnUtility to fetch the site for the Object ID.*/

      CURSOR is_obj_exist_on_default_site IS
         SELECT 1
              FROM Equipment_Object_TAB
             where CONTRACT = USER_ALLOWED_SITE_API.Get_Default_Site()
               AND MCH_CODE = object_id_
               AND decode(is_category_object, 'TRUE', 'CATEGORY', 'EQUIPMENT') = connection_type_db_
               AND (OPERATIONAL_STATUS != 'SCRAPPED' OR
                    OPERATIONAL_STATUS IS NULL)
               AND (OBJ_LEVEL IS NULL OR (OBJ_LEVEL IS NOT NULL AND Equipment_Object_Level_API.Get_Create_Wo(OBJ_LEVEL) =
                    'TRUE'));

       CURSOR is_obj_exist_on_more_sites IS
            SELECT CONTRACT
              FROM (select COUNT(*) OVER() cnt, CONTRACT
                      FROM Equipment_Object_TAB
                     where User_Allowed_Site_API.Is_Authorized(CONTRACT) = 1
                       AND MCH_CODE = object_id_
                       AND decode(is_category_object, 'TRUE', 'CATEGORY', 'EQUIPMENT') = connection_type_db_
                       AND (OPERATIONAL_STATUS != 'SCRAPPED' OR
                            OPERATIONAL_STATUS IS NULL)
                       AND (OBJ_LEVEL IS NULL OR (OBJ_LEVEL IS NOT NULL AND Equipment_Object_Level_API.Get_Create_Wo(OBJ_LEVEL) =
                            'TRUE'))
                     GROUP BY CONTRACT)
             WHERE cnt = 1;

BEGIN

   OPEN  is_obj_exist_on_default_site;
   FETCH is_obj_exist_on_default_site INTO object_site_;
   CLOSE is_obj_exist_on_default_site;

   IF (object_site_ = 1) THEN
      RETURN USER_ALLOWED_SITE_API.Get_Default_Site();
   ELSE
      OPEN is_obj_exist_on_more_sites;
      FETCH is_obj_exist_on_more_sites INTO object_site_;
      CLOSE is_obj_exist_on_more_sites;
      IF (object_site_ IS NOT NULL) THEN
         RETURN object_site_;
      ELSE
         Error_SYS.Record_General(lu_name_, 'OBJIDNOTVALID: The Equipment Object does not exist.');
      END IF;
   END IF;

END Is_obj_Exist_On_More_Sites;


PROCEDURE Distribute_Operational_Groups (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   op_group_list_ IN VARCHAR2,
   copy_to_serial_ IN VARCHAR2 )
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);

   CURSOR get_child_objects IS
      SELECT equipment_object_seq, mch_code, contract, rowtype
      FROM EQUIPMENT_OBJECT_TAB t
      WHERE functional_object_seq IS NOT NULL
      START WITH (t.equipment_object_seq = equipment_object_seq_)
      CONNECT BY (PRIOR equipment_object_seq = functional_object_seq);

   count_ NUMBER := 0;
   group_id_   VARCHAR2(20);
   attr_       VARCHAR2(2000);
   dummy_      VARCHAR2(2000);

BEGIN
   $IF Component_Opplan_SYS.INSTALLED $THEN
      WHILE (Client_SYS.Item_Exist(count_, op_group_list_)) LOOP
         group_id_ := Client_SYS.Get_Item_Value(count_,op_group_list_ );
         FOR child_object_ IN get_child_objects LOOP

            IF(copy_to_serial_ = 'TRUE' OR (copy_to_serial_ = 'FALSE' AND child_object_.rowtype != 'EquipmentSerial')) AND (Object_Oper_Mode_Group_API.Exists(child_object_.equipment_object_seq, group_id_) = FALSE) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', child_object_.equipment_object_seq, attr_); 
               Client_SYS.Add_To_Attr('CONTRACT', child_object_.contract, attr_); 
               Client_SYS.Add_To_Attr('MCH_CODE', child_object_.mch_code, attr_); 
               Client_SYS.Add_To_Attr('OPER_MODE_GROUP_ID', group_id_, attr_);
               Client_SYS.Add_To_Attr('INHERITED', 'TRUE', attr_);
               Object_Oper_Mode_Group_API.New__(dummy_,dummy_,dummy_, attr_, 'DO');
            END IF;

         END LOOP;
         count_ := count_ + 1;
      END LOOP;
   $ELSE
      NULL;
   $END
END Distribute_Operational_Groups;


PROCEDURE Spread_Safe_Access_code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   safe_access_            VARCHAR2(20);
   
   CURSOR get_child_objects IS
      SELECT mch_code, contract, obj_level
      FROM EQUIPMENT_OBJECT_TAB t
      WHERE functional_object_seq IS NOT NULL
      START WITH (t.equipment_object_seq = equipment_object_seq_)
      CONNECT BY (PRIOR equipment_object_seq = functional_object_seq);
BEGIN
   safe_access_ := Get_Safe_Access_Code_Db(contract_, mch_code_);
   FOR rec_ IN get_child_objects LOOP
      IF rec_.obj_level IS NULL THEN
         Equipment_Serial_API.Spread_Safe_Access_code(rec_.contract, rec_.mch_code, safe_access_);
      ELSE
         Equipment_Functional_API.Spread_Safe_Access_code(rec_.contract, rec_.mch_code, safe_access_);
      END IF;
   END LOOP;
END Spread_Safe_Access_code;


PROCEDURE Get_Resched_Req_Warning(
   warning_    OUT VARCHAR2,
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2,
   condition_  IN VARCHAR2 )
IS
   wo_exists_        VARCHAR2(5) := 'FALSE';
BEGIN
   $IF Component_Wo_SYS.INSTALLED AND Component_Mpbint_SYS.INSTALLED $THEN
      wo_exists_ := Mpb_Wo_Int_API.Obj_Has_Mpb_Wo(contract_, mch_code_);
      IF (wo_exists_ = 'TRUE') THEN
         IF (condition_ = 'CRITICALITY') THEN
            Client_SYS.Add_Warning('EquipmentObject','CHANGECRITICALITY: Changes to criticality will affect on Critical work check box in Work order/PM and it might result in critical order to become tardy. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         ELSIF (condition_ = 'SAFEACCESS' OR condition_ = 'OPMODEGROUP') THEN
            Client_SYS.Add_Warning('EquipmentObject','CHANGESAFEACCESS: Changes to Safe Access Code or Operational Mode Group might result in overlaps with obstructive maintenance schedule. Rescheduling Work Orders/PM using Maintenance Planning Board might be required to resolve such overlaps.');
         END IF;
      END IF;
      warning_ := Client_SYS.Get_All_Info;
   $ELSE
      NULL;
   $END
END Get_Resched_Req_Warning;


@UncheckedAccess
FUNCTION Get_Child_Objects (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE; 

   CURSOR get_child_objects IS
      SELECT COUNT(*)
      FROM EQUIPMENT_OBJECT_TAB t
      WHERE t.functional_object_seq IS NOT NULL
      START WITH (t.functional_object_seq = equipment_object_seq_)
      CONNECT BY PRIOR t.equipment_object_seq = t.functional_object_seq;

   count_    NUMBER;
BEGIN
   equipment_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   
   OPEN get_child_objects;
   FETCH get_child_objects INTO count_;
   CLOSE get_child_objects;
   RETURN count_;
END Get_Child_Objects;

/*
PROCEDURE Inherit_Map_Position(
   newrec_     IN EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
   keyref_loc_     VARCHAR2(512);
   keyref_eo_      VARCHAR2(512);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(20);
   objversion_     VARCHAR2(2000);
   info_           VARCHAR2(2000);

   luname_loc_     map_position.lu_name%TYPE  := 'Location';
   luname_eo_      map_position.lu_name%TYPE  := 'EquipmentObject';
   eo_position_    map_position%ROWTYPE;
   loc_position_   map_position%ROWTYPE;
   CURSOR getPositionFromKeyRef(luname_ IN VARCHAR2, keyref_ IN VARCHAR2) IS
     SELECT *
     FROM map_position
     WHERE Lu_name = luname_
     AND   key_ref = keyref_;

BEGIN
   IF (newrec_.location_id IS NOT NULL) THEN
      Client_SYS.Clear_Attr(keyref_loc_);
      Client_SYS.Add_To_Key_Reference(keyref_loc_, 'LOCATION_ID', newrec_.location_id);
      Client_SYS.Clear_Attr(keyref_eo_);
      Client_SYS.Add_To_Key_Reference( keyref_eo_, 'CONTRACT', newrec_.contract);
      Client_SYS.Add_To_Key_Reference(keyref_eo_, 'MCH_CODE', newrec_.mch_code);

      -- Look for PositionFrom Location
      OPEN getPositionFromKeyRef(luname_loc_, keyref_loc_);
      FETCH getPositionFromKeyRef INTO loc_position_;

      IF (getPositionFromKeyRef%FOUND) THEN
         -- Found PositionFrom Location
         CLOSE getPositionFromKeyRef;

         Client_SYS.Clear_Attr(attr_);

         -- Look for PositionFrom Equipment Object
         OPEN getPositionFromKeyRef(luname_eo_, keyref_eo_);
         FETCH getPositionFromKeyRef INTO eo_position_;

         IF getPositionFromKeyRef%FOUND THEN
            -- Found PositionFrom Equipment Object, Update it with Location coordinates
            Client_SYS.Add_To_Attr('LONGITUDE', loc_position_.longitude, attr_);
            Client_SYS.Add_To_Attr('LATITUDE', loc_position_.latitude, attr_);
            Map_Position_API.Modify__(info_, eo_position_.objid, eo_position_.objversion, attr_, 'DO');
         ELSE
            -- Not found PositionFrom Equipment Object, Create new with Location coordinates
            Client_SYS.Add_To_Attr('LU_NAME', luname_eo_  , attr_);
            Client_SYS.Add_To_Attr('KEY_REF', keyref_eo_, attr_);
            Client_SYS.Add_To_Attr('LONGITUDE', loc_position_.longitude, attr_);
            Client_SYS.Add_To_Attr('LATITUDE', loc_position_.latitude, attr_);
            Map_Position_API.New__(info_, objid_, objversion_, attr_, 'DO');
         END IF;
         CLOSE getPositionFromKeyRef;

      ELSE
         -- Not found PositionFrom Location, Remove existing positions for Equipment Object
         CLOSE getPositionFromKeyRef;
         FOR rec_ IN getPositionFromKeyRef(luname_eo_, keyref_eo_) LOOP
            Map_Position_API.Remove__(info_, rec_.objid, rec_.objversion, 'DO');
         END LOOP;
      END IF;
   END IF;
END Inherit_Map_Position;
*/

--  this method is now used only in upgrade scenarios. Avoid touching this for other changes.
PROCEDURE Inherit_Map_Position(
   newrec_ IN EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
   keyref_loc_     VARCHAR2(512);
   keyref_eo_      VARCHAR2(512);
   
   luname_loc_     map_position.lu_name%TYPE  := 'Location';
   luname_eo_      map_position.lu_name%TYPE  := 'EquipmentObject';
   
   position_attr_ VARCHAR2(32000);
   longitude_          NUMBER;
   latitude_           NUMBER;
   altitude_           NUMBER;
   
BEGIN
   IF (newrec_.location_id IS NOT NULL) THEN
      Client_SYS.Clear_Attr(keyref_loc_);
      Client_SYS.Add_To_Key_Reference(keyref_loc_, 'LOCATION_ID', newrec_.location_id);
      
      position_attr_     := Map_Position_API.Get_Def_Position_For_Object(luname_loc_, keyref_loc_);
      
      longitude_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LONGITUDE',         position_attr_));
      latitude_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LATITUDE',          position_attr_));
      altitude_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ALTITUDE',          position_attr_));
      
      IF ( longitude_ IS NOT NULL ) THEN
         Client_SYS.Clear_Attr(keyref_eo_);
         Client_SYS.Add_To_Key_Reference(keyref_eo_, 'CONTRACT', newrec_.contract);
         Client_SYS.Add_To_Key_Reference(keyref_eo_, 'MCH_CODE', newrec_.mch_code);
         Map_Position_API.Create_And_Replace(luname_eo_, keyref_eo_, longitude_, latitude_, altitude_);
      END IF;
   ELSE
      Client_SYS.Clear_Attr(keyref_eo_);
      Client_SYS.Add_To_Key_Reference(keyref_eo_, 'CONTRACT', newrec_.contract);
      Client_SYS.Add_To_Key_Reference(keyref_eo_, 'MCH_CODE', newrec_.mch_code);
      Map_Position_API.Remove_Position_For_Object( 'EquipmentObject', keyref_eo_ );
   END IF;
END Inherit_Map_Position;


PROCEDURE Inherit_Equip_Map_Position(
   newrec_     IN EQUIPMENT_OBJECT_TAB%ROWTYPE)
IS
   keyref_loc_     VARCHAR2(512);
   keyref_eo_      VARCHAR2(512);

   luname_loc_     map_position.lu_name%TYPE  := 'Location';
   luname_eo_      map_position.lu_name%TYPE  := 'EquipmentObject';

   position_attr_ VARCHAR2(32000);
   longitude_          NUMBER;
   latitude_           NUMBER;
   altitude_           NUMBER;

BEGIN
   IF (newrec_.location_id IS NOT NULL) THEN
      Client_SYS.Clear_Attr(keyref_loc_);
      Client_SYS.Add_To_Key_Reference(keyref_loc_, 'LOCATION_ID', newrec_.location_id);

      position_attr_     := Map_Position_API.Get_Def_Position_For_Object(luname_loc_, keyref_loc_);

      longitude_         := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LONGITUDE',         position_attr_));
      latitude_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LATITUDE',          position_attr_));
      altitude_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ALTITUDE',          position_attr_));

      IF ( longitude_ IS NOT NULL ) THEN
         Client_SYS.Clear_Attr(keyref_eo_);
         Client_SYS.Add_To_Key_Reference(keyref_eo_, 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
         Map_Position_API.Create_And_Replace(luname_eo_, keyref_eo_, longitude_, latitude_, altitude_);
      END IF;
   ELSE
      Map_Position_API.Remove_Position_For_Object('EquipmentObject', Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq));
   END IF;
END Inherit_Equip_Map_Position;

PROCEDURE Update_Pm_Program_Info (
   mch_code_       IN VARCHAR2,
   contract_       IN VARCHAR2,
   pm_program_id_  IN VARCHAR2,
   pm_program_rev_ IN VARCHAR2,
   add_to_journal_ IN BOOLEAN DEFAULT TRUE)
IS
BEGIN
   Update_Pm_Program_Info(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), pm_program_id_, pm_program_rev_, add_to_journal_);
END Update_Pm_Program_Info;


PROCEDURE Update_Pm_Program_Info (
   equipment_object_seq_ IN NUMBER,
   pm_program_id_        IN VARCHAR2,
   pm_program_rev_       IN VARCHAR2,
   add_to_journal_       IN BOOLEAN DEFAULT TRUE)
IS
   attr_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ VARCHAR2(2000);
   oldrec_     EQUIPMENT_OBJECT_TAB%ROWTYPE;
   journal_note_ VARCHAR2(100);
   pm_prog_      VARCHAR2(120);
   info_         VARCHAR2(2000);
   dummy_d_null_  DATE:= NULL;
BEGIN
   oldrec_ := Get_Object_By_Keys___(equipment_object_seq_);
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('APPLIED_PM_PROGRAM_ID',    pm_program_id_,   attr_);
   Client_SYS.Add_To_Attr('APPLIED_PM_PROGRAM_REV',   pm_program_rev_,  attr_);
   Get_Id_Version_By_Keys__(objid_, objversion_, oldrec_.contract, oldrec_.mch_code);
   
   IF(pm_program_id_ IS NULL)THEN
      Client_SYS.Add_To_Attr('APPLIED_DATE', dummy_d_null_, attr_);
      pm_prog_ := oldrec_.applied_pm_program_id || ':' || oldrec_.applied_pm_program_rev;
      Modify__(info_, objid_, objversion_, attr_, 'DO');
      IF (add_to_journal_) THEN
         journal_note_ := Language_SYS.Translate_Constant(lu_name_,'EUIPCONNECTPROG: PM Program :P1 disconnected.', p1_ => pm_prog_);
         Equipment_Object_Journal_API.Add_Journal_Entry(oldrec_.mch_code, oldrec_.contract, pm_prog_, NULL,  journal_note_, 'MODIFIED');
      END IF;
   ELSE
      Client_SYS.Add_To_Attr('APPLIED_DATE', sysdate, attr_);
      pm_prog_ := pm_program_id_ || ':' || pm_program_rev_;
      Modify__(info_, objid_, objversion_, attr_, 'DO');
      IF (add_to_journal_) THEN
         journal_note_ := Language_SYS.Translate_Constant(lu_name_,'EUIPDISCONNECTPROG: PM Program :P1 applied.', p1_ => pm_prog_);
         Equipment_Object_Journal_API.Add_Journal_Entry(oldrec_.mch_code, oldrec_.contract, NULL , pm_prog_,  journal_note_, 'MODIFIED');
      END IF;
   END IF;
END Update_Pm_Program_Info;


PROCEDURE Change_Pm_Application_Status (
   contract_               IN VARCHAR2,
   mch_code_               IN VARCHAR2,
   pm_application_status_   IN VARCHAR2,
   not_applicable_reason_   IN VARCHAR2 DEFAULT NULL
   )
IS
   oldrec_        EQUIPMENT_OBJECT_TAB%ROWTYPE;
   newrec_        EQUIPMENT_OBJECT_TAB%ROWTYPE;
   objid_         ROWID;
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
   info_         VARCHAR2(2000);
   dummy_null_ VARCHAR2(5) := NULL;
   dummy_d_null_  DATE:= NULL;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   --Get_Objid(objid_, mch_name_ , contract_,mch_code_);
   Get_Id_Version_By_Keys__(objid_, objversion_, contract_,mch_code_);
   oldrec_ := Get_Object_By_Keys___(contract_, mch_code_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('PM_PROG_APPLICATION_STATUS', pm_application_status_, attr_);
   Client_SYS.Add_To_Attr('NOT_APPLICABLE_REASON', not_applicable_reason_, attr_);
   IF pm_application_status_ = 'TRUE' THEN
       Client_SYS.Add_To_Attr('NOT_APPLICABLE_SET_USER', Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User), attr_);
       Client_SYS.Add_To_Attr('NOT_APPLICABLE_SET_DATE', sysdate, attr_);
   ELSE
      Client_SYS.Add_To_Attr('NOT_APPLICABLE_SET_USER', dummy_null_, attr_);
      Client_SYS.Add_To_Attr('NOT_APPLICABLE_SET_DATE', dummy_d_null_, attr_);
   END IF;
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Change_Pm_Application_Status;

@UncheckedAccess
FUNCTION Check_Service_lines (
   contract_id_   IN VARCHAR2,
   line_no_       IN NUMBER,
   mch_code_      IN VARCHAR2,
   mch_contract_  IN VARCHAR2) RETURN VARCHAR2
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(mch_contract_, mch_code_);

   CURSOR get_all_objects IS
      SELECT *
      FROM EQUIPMENT_OBJECT_TAB t
      START WITH functional_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;

   result_ VARCHAR2(5) := 'FALSE';


BEGIN
FOR rec_ IN get_all_objects LOOP
  $IF (Component_Pcmsci_SYS.INSTALLED) $THEN
   IF (Psc_Contr_Product_Api.Check_Lines_For_Objects__(contract_id_,line_no_,rec_.mch_code,rec_.contract)='TRUE' ) THEN
      result_ := 'TRUE';
   END IF;
  $ELSE
   NULL;
  $END
END LOOP;
   RETURN result_;
END Check_Service_lines;

@UncheckedAccess
FUNCTION Transf_Equip_Object_To_Task (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Wo_SYS.INSTALLED $THEN
      task_seq_             NUMBER;
      task_rec_             Jt_Task_API.PUBLIC_REC;
   $END
   eqobj_rec_            Equipment_Object_Tab%ROWTYPE;
   source_key_ref_       VARCHAR2(32000);
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      task_seq_ := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'TASK_SEQ');
      task_rec_ := Jt_Task_API.Get(task_seq_);

      IF (task_rec_.actual_obj_conn_lu_name = Equipment_Object_API.lu_name_ AND task_rec_.actual_obj_conn_rowkey IS NOT NULL) THEN

         eqobj_rec_ := Get_Key_By_Rowkey(task_rec_.actual_obj_conn_rowkey);
         IF (eqobj_rec_.equipment_object_seq IS NOT NULL) THEN
            source_key_ref_ := 'EQUIPMENT_OBJECT_SEQ=' || eqobj_rec_.equipment_object_seq || '^';
         END IF;
      END IF;
   $END
   RETURN source_key_ref_;
END Transf_Equip_Object_To_Task;

@UncheckedAccess
FUNCTION Transf_Eq_Obj_To_Task_Step (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   $IF Component_Wo_SYS.INSTALLED $THEN
      task_seq_             NUMBER;
      task_step_seq_        NUMBER;
      taskstep_rec_         Jt_Task_Step_API.PUBLIC_REC;
   $END
   eqobj_rec_            Equipment_Object_Tab%ROWTYPE;
   source_key_ref_       VARCHAR2(32000);
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      task_seq_      := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'TASK_SEQ');
      task_step_seq_ := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'TASK_STEP_SEQ');
      taskstep_rec_  := Jt_Task_Step_API.Get(task_seq_, task_step_seq_);

      IF (taskstep_rec_.object_connection_lu_name = Equipment_Object_API.lu_name_ AND taskstep_rec_.object_connection_rowkey IS NOT NULL) THEN
         eqobj_rec_ := Get_Key_By_Rowkey(taskstep_rec_.object_connection_rowkey);
         IF (eqobj_rec_.equipment_object_seq IS NOT NULL) THEN
            source_key_ref_ := 'EQUIPMENT_OBJECT_SEQ=' || eqobj_rec_.equipment_object_seq || '^';
         END IF;
      END IF;
   $END
   RETURN source_key_ref_;
END Transf_Eq_Obj_To_Task_Step;


FUNCTION Is_Pm_Program_Appied (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   pm_prog_id_  equipment_object_tab.applied_pm_program_id%TYPE;
BEGIN
   pm_prog_id_ := Equipment_Object_API.Get_Applied_Pm_Program_Id(contract_, mch_code_);

   IF (pm_prog_id_ IS NOT NULL) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Pm_Program_Appied;

FUNCTION Get_Code_Part(contract_ IN VARCHAR2, 
   code_part_type_ IN VARCHAR2)
   RETURN VARCHAR2
IS
   company_                   VARCHAR2(20);
   temp_code_part_            VARCHAR2(50);
   view_name_                 VARCHAR2(50);
   pkg_name_                  VARCHAR2(20);
   inter_name_                VARCHAR2(20);
   temp_ok_code_              VARCHAR2(5);
   code_part_name_           VARCHAR2(25);
   contract_temp_             VARCHAR2(5);
BEGIN
   contract_temp_ := contract_;
   IF (contract_temp_ IS NULL) THEN 
      contract_temp_ := User_Default_API.Get_Contract;
   END IF;
  company_ := Site_API.Get_Company(contract_temp_);
  Maintenance_Accounting_API.Get_Log_Code_Part( temp_code_part_, view_name_, pkg_name_, inter_name_, company_, code_part_type_);
  temp_ok_code_ := Accounting_Code_Parts_API.Is_Code_Used( company_, temp_code_part_); 
  
  IF (temp_ok_code_ = 'TRUE' AND code_part_type_ = 'CostCenter') THEN 
   code_part_name_ := Trim(inter_name_);
  ELSIF (code_part_type_ = 'Object') THEN 
   code_part_name_ := Trim(inter_name_);
  END IF;
  
  RETURN code_part_name_;
END Get_Code_Part;

FUNCTION Get_Code_Part_View(contract_ IN VARCHAR2,
   code_part_type_ IN VARCHAR2)
   RETURN VARCHAR2
IS
   company_                   VARCHAR2(20);
   temp_code_part_            VARCHAR2(50);
   view_name_                 VARCHAR2(50);
   pkg_name_                  VARCHAR2(20);
   inter_name_                VARCHAR2(20);
   contract_temp_             VARCHAR2(5);
BEGIN
  contract_temp_ := contract_;
   IF (contract_temp_ IS NULL) THEN 
      contract_temp_ := User_Default_API.Get_Contract;
   END IF;
  company_ := Site_API.Get_Company(contract_temp_);
  Maintenance_Accounting_API.Get_Log_Code_Part( temp_code_part_, view_name_, pkg_name_, inter_name_, company_, code_part_type_);
  RETURN view_name_;
END Get_Code_Part_View;

FUNCTION Hide_Code_Part(contract_ IN VARCHAR2,
   code_part_type_ IN VARCHAR2)
   RETURN VARCHAR2
IS
   company_                   VARCHAR2(20);
   temp_code_part_            VARCHAR2(50);
   view_name_                 VARCHAR2(50);
   pkg_name_                  VARCHAR2(20);
   inter_name_                VARCHAR2(20);
   log_code_used_cost_center_ VARCHAR2(10);
   contract_temp_             VARCHAR2(5);
BEGIN
   log_code_used_cost_center_ := 'FALSE';
 
  contract_temp_ := contract_;
   IF (contract_temp_ IS NULL) THEN 
      contract_temp_ := User_Default_API.Get_Contract;
   END IF;
  company_ := Site_API.Get_Company(contract_temp_); 
  IF (code_part_type_ = 'CostCenter') THEN 
      log_code_used_cost_center_ := Maintenance_Accounting_API.Log_Code_Part_Used(company_, code_part_type_); 
  ELSIF (code_part_type_ = 'Object') THEN
      Maintenance_Accounting_API.Get_Log_Code_Part( temp_code_part_, view_name_, pkg_name_, inter_name_, company_, code_part_type_);
      log_code_used_cost_center_ := Accounting_Code_Parts_API.Is_Code_Used(company_, temp_code_part_);
  END IF;
  
  RETURN log_code_used_cost_center_;
END Hide_Code_Part;

PROCEDURE Get_Code_Part_For_Objct_Values(
   contract_ IN VARCHAR2,
   object_no_  IN OUT VARCHAR2,
   object_view_name_  IN OUT VARCHAR2,
   hide_object_ IN OUT VARCHAR2)
IS
  fun_logical_code_part_     VARCHAR2(20);
  func_code_part_            VARCHAR2(50);
  pkg_name_                  VARCHAR2(20);
  inter_name_                VARCHAR2(20);
  company_                   VARCHAR2(20);
  contract_temp_             VARCHAR2(5);
BEGIN
  
   contract_temp_ := contract_;
   IF (contract_temp_ IS NULL) THEN 
      contract_temp_ := User_Default_API.Get_Contract;
   END IF;
   company_ := Site_API.Get_Company(contract_temp_);
   fun_logical_code_part_ := 'Object';
   Maintenance_Accounting_API.Check_Object_Used(func_code_part_, object_view_name_ , pkg_name_, inter_name_, company_, fun_logical_code_part_ );
   hide_object_ := Accounting_Code_Parts_API.Is_Code_Used(company_, func_code_part_);
   object_no_ := Trim(inter_name_);
END Get_Code_Part_For_Objct_Values;

PROCEDURE Get_Code_Part_Cost_Center_Val
   (contract_ IN VARCHAR2, 
   code_part_name_  IN OUT VARCHAR2,
   view_name_  IN OUT VARCHAR2,
   hide_cost_center_ IN OUT VARCHAR2)

IS
   company_                   VARCHAR2(20);
   logical_code_part_         VARCHAR2(20);
   temp_code_part_            VARCHAR2(50);
   pkg_name_                  VARCHAR2(20);
   inter_name_                VARCHAR2(20);
   temp_ok_code_              VARCHAR2(5);
   contract_temp_             VARCHAR2(5);
   log_code_used_cost_center_ VARCHAR2(10);
BEGIN
   logical_code_part_ := 'CostCenter';
   log_code_used_cost_center_ := 'FALSE';
   contract_temp_ := contract_;
   IF (contract_temp_ IS NULL) THEN 
      contract_temp_ := User_Default_API.Get_Contract;
   END IF;
  company_ := Site_API.Get_Company(contract_temp_);
  Maintenance_Accounting_API.Get_Log_Code_Part( temp_code_part_, view_name_, pkg_name_, inter_name_, company_, logical_code_part_);
  temp_ok_code_ := Accounting_Code_Parts_API.Is_Code_Used( company_, temp_code_part_); 
  IF ( temp_ok_code_ = 'TRUE') THEN 
   code_part_name_ := Trim(inter_name_);
   view_name_ := view_name_;
   log_code_used_cost_center_ := Maintenance_Accounting_API.Log_Code_Part_Used(company_, logical_code_part_); 
   hide_cost_center_ := log_code_used_cost_center_;
  END IF;
END Get_Code_Part_Cost_Center_Val;

@UncheckedAccess
FUNCTION Get_Obj_Count(
   equipment_object_seq_   IN NUMBER,
   structure_              IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   obj_count_ NUMBER;
   
   CURSOR get_obj_count IS
      SELECT count(*)
        FROM equipment_object
       WHERE (((structure_ IS NULL OR structure_ = 'F') AND
             functional_object_seq = equipment_object_seq_) OR
             (structure_ = 'L' AND location_object_seq = equipment_object_seq_) OR
             (structure_ = 'R' AND from_object_seq = equipment_object_seq_) OR
             (structure_ = 'T' AND to_object_seq = equipment_object_seq_) OR
             (structure_ = 'P' AND process_object_seq = equipment_object_seq_) OR
             (structure_ = 'S' AND pipe_object_seq = equipment_object_seq_) OR
             (structure_ = 'E' AND circuit_object_seq = equipment_object_seq_));
BEGIN
   OPEN get_obj_count;
   FETCH get_obj_count
      INTO obj_count_;
   CLOSE get_obj_count;
   RETURN TO_CHAR(obj_count_);
END Get_Obj_Count;

@UncheckedAccess
FUNCTION Get_All_Obj_Count(
   equipment_object_seq_  IN NUMBER,
   structure_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   obj_count_ NUMBER;
   
   CURSOR get_function_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH functional_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;

   CURSOR get_location_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH location_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = location_object_seq;

   CURSOR get_from_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH from_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = from_object_seq;

   CURSOR get_to_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH to_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = to_object_seq;

   CURSOR get_process_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH process_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = process_object_seq;

   CURSOR get_pipe_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH pipe_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = pipe_object_seq;

   CURSOR get_circuit_obj_count IS
      SELECT count(*)
      FROM equipment_object
      START WITH circuit_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = circuit_object_seq;

BEGIN
   IF (structure_ = 'F' OR structure_ IS NULL) THEN
      OPEN get_function_obj_count;
      FETCH get_function_obj_count
         INTO obj_count_;
      CLOSE get_function_obj_count;
   
   ELSIF (structure_ = 'L') THEN
      OPEN get_location_obj_count;
      FETCH get_location_obj_count
         INTO obj_count_;
      CLOSE get_location_obj_count;
   ELSIF (structure_ = 'R') THEN
      OPEN get_from_obj_count;
      FETCH get_from_obj_count
         INTO obj_count_;
      CLOSE get_from_obj_count;
   
   ELSIF (structure_ = 'T') THEN
      OPEN get_to_obj_count;
      FETCH get_to_obj_count
         INTO obj_count_;
      CLOSE get_to_obj_count;
   
   ELSIF (structure_ = 'P') THEN
      OPEN get_process_obj_count;
      FETCH get_process_obj_count
         INTO obj_count_;
      CLOSE get_process_obj_count;
   
   ELSIF (structure_ = 'S') THEN
      OPEN get_pipe_obj_count;
      FETCH get_pipe_obj_count
         INTO obj_count_;
      CLOSE get_pipe_obj_count;
   
   ELSIF (structure_ = 'E') THEN
      OPEN get_circuit_obj_count;
      FETCH get_circuit_obj_count
         INTO obj_count_;
      CLOSE get_circuit_obj_count;
   END IF;

   RETURN TO_CHAR(obj_count_);
END Get_All_Obj_Count;

FUNCTION Has_Objs_For_Location (
   location_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
   objects_exist_ VARCHAR2(5):= 'FALSE';
   obj_count_ NUMBER;
   CURSOR get_objs_count IS
      SELECT count(*)
      FROM   equipment_object_tab
      WHERE  location_id = location_id_;
BEGIN 
   OPEN  get_objs_count;
   FETCH get_objs_count INTO obj_count_;
   CLOSE get_objs_count;
   IF obj_count_ > 0 THEN 
      objects_exist_ := 'TRUE';
      RETURN objects_exist_;
   ELSE 
      RETURN objects_exist_;
   END IF;  
END Has_Objs_For_Location;

FUNCTION Get_Navigation_Url(
   mch_code_          IN VARCHAR2,
   contract_          IN VARCHAR2,
   navigating_form_   IN VARCHAR2,
   type_of_obj_       IN VARCHAR2,
   structure_in_tree_ IN VARCHAR2) RETURN VARCHAR2
IS
   first_iter_     NUMBER;
   navigation_url_ VARCHAR2(32000);

   CURSOR get_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE sup_mch_code = mch_code_
         AND sup_contract = contract_
       ORDER BY mch_code;
       
          CURSOR get_location_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE location_mch_code = mch_code_
         AND location_contract = contract_
       ORDER BY mch_code;
       
                 CURSOR get_from_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE from_mch_code = mch_code_
         AND from_contract = contract_
       ORDER BY mch_code;
       
                 CURSOR get_to_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE to_mch_code = mch_code_
         AND to_contract = contract_
       ORDER BY mch_code;
       
                 CURSOR get_process_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE process_mch_code = mch_code_
         AND process_contract = contract_
       ORDER BY mch_code;
       
                 CURSOR get_pipe_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE pipe_mch_code = mch_code_
         AND pipe_contract = contract_
       ORDER BY mch_code;
       
                 CURSOR get_circuit_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       WHERE circuit_mch_code = mch_code_
         AND circuit_contract = contract_
       ORDER BY mch_code;

   CURSOR get_all_pipe_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH pipe_mch_code = mch_code_
              AND pipe_contract = contract_
      CONNECT BY PRIOR mch_code = pipe_mch_code
             AND PRIOR contract = pipe_contract
       ORDER BY mch_code;

   CURSOR get_all_function_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH sup_mch_code = mch_code_
              AND sup_contract = contract_
      CONNECT BY PRIOR mch_code = sup_mch_code
             AND PRIOR contract = sup_contract
       ORDER BY mch_code;

   CURSOR get_all_location_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH location_mch_code = mch_code_
              AND location_contract = contract_
      CONNECT BY PRIOR mch_code = location_mch_code
             AND PRIOR contract = location_contract
       ORDER BY mch_code;

   CURSOR get_all_from_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH from_mch_code = mch_code_
              AND from_contract = contract_
      CONNECT BY PRIOR mch_code = from_mch_code
             AND PRIOR contract = from_contract
       ORDER BY mch_code;

   CURSOR get_all_to_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH to_mch_code = mch_code_
              AND to_contract = contract_
      CONNECT BY PRIOR mch_code = to_mch_code
             AND PRIOR contract = to_contract
       ORDER BY mch_code;

   CURSOR get_all_process_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH process_mch_code = mch_code_
              AND process_contract = contract_
      CONNECT BY PRIOR mch_code = process_mch_code
             AND PRIOR contract = process_contract
       ORDER BY mch_code;

   CURSOR get_all_circuit_obj IS
      SELECT mch_code, contract
        FROM EQUIPMENT_OBJECT_UIV
       START WITH circuit_mch_code = mch_code_
              AND circuit_contract = contract_
      CONNECT BY PRIOR mch_code = circuit_mch_code
             AND PRIOR contract = circuit_contract
       ORDER BY mch_code;

   $IF Component_Pm_SYS.INSTALLED $THEN
      CURSOR get_all_function_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH sup_mch_code = mch_code_
                           AND sup_contract = contract_
                   CONNECT BY PRIOR mch_code = sup_mch_code
                          AND PRIOR contract = sup_contract)));

      CURSOR get_all_location_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH location_mch_code = mch_code_
                           AND location_contract = contract_
                   CONNECT BY PRIOR mch_code = location_mch_code
                          AND PRIOR contract = location_contract)));

      CURSOR get_all_from_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH from_mch_code = mch_code_
                           AND from_contract = contract_
                   CONNECT BY PRIOR mch_code = from_mch_code
                          AND PRIOR contract = from_contract)));

      CURSOR get_all_to_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH to_mch_code = mch_code_
                           AND to_contract = contract_
                   CONNECT BY PRIOR mch_code = to_mch_code
                          AND PRIOR contract = to_contract)));

      CURSOR get_all_process_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH process_mch_code = mch_code_
                           AND process_contract = contract_
                   CONNECT BY PRIOR mch_code = process_mch_code
                          AND PRIOR contract = process_contract)));

      CURSOR get_all_pipe_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH pipe_mch_code = mch_code_
                           AND pipe_contract = contract_
                   CONNECT BY PRIOR mch_code = pipe_mch_code
                          AND PRIOR contract = pipe_contract)));

      CURSOR get_all_circuit_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            and ((mch_code = mch_code_ AND mch_code_contract = contract_) or
                ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                     FROM Equipment_All_Object_UIV
                    START WITH circuit_mch_code = mch_code_
                           AND circuit_contract = contract_
                   CONNECT BY PRIOR mch_code = circuit_mch_code
                          AND PRIOR contract = circuit_contract)));

      CURSOR get_std_pm IS
         SELECT pm.pm_no, pm.pm_revision
           FROM Pm_Action_UIV pm
          WHERE objstate IN ('Active', 'Preliminary')
            AND (mch_code = mch_code_ AND mch_code_contract = contract_);

      CURSOR get_maint_plan IS
         SELECT pm.pm_no, pm.pm_revision
           FROM PM_ACTION_CAL_PLAN pm
          WHERE mch_code = mch_code_
            AND contract = contract_
          ORDER BY planned_date;
   $END
   $IF Component_Wo_SYS.INSTALLED $THEN
      CURSOR get_active_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE mch_code = mch_code_
            AND contract = contract_;

      CURSOR get_all_active_function_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = sup_mch_code
                         AND PRIOR contract = sup_contract));

      CURSOR get_all_active_location_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = location_mch_code
                         AND PRIOR contract = location_contract));

      CURSOR get_all_active_from_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = from_mch_code
                         AND PRIOR contract = from_contract));

      CURSOR get_all_active_to_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = to_mch_code
                         AND PRIOR contract = to_contract));

      CURSOR get_all_active_process_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = process_mch_code
                         AND PRIOR contract = process_contract));

      CURSOR get_all_active_pipe_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = pipe_mch_code
                         AND PRIOR contract = pipe_contract));

      CURSOR get_all_active_circuit_wo IS
         SELECT wo.wo_no
           FROM ACTIVE_SEPARATE_OVERVIEW wo
          WHERE ((mch_code, mch_code_contract) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = circuit_mch_code
                         AND PRIOR contract = circuit_contract));

      CURSOR get_all_hist_wo IS
         SELECT wo.wo_no
           FROM HISTORICAL_SEPARATE_OVERVIEW wo
          WHERE (MCH_CODE = mch_code_ AND MCH_CODE_CONTRACT = contract_);

      CURSOR get_active_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (actual_object_id = mch_code_ AND
                actual_object_site = contract_ AND
                objstate NOT IN ('FINISHED', 'CANCELLED'));

      CURSOR get_all_active_function_work_task IS
         SELECT t.task_seq
           FROM JT_TASK_TAB t
          WHERE t.actual_obj_conn_lu_name =
                Jt_Connected_Object_API.DB_EQUIPMENT_OBJECT
            AND rowstate NOT IN ('FINISHED', 'CANCELLED')
            AND (t.duplicate_type = 'MASTER' OR t.duplicate_type IS NULL)
            AND t.actual_obj_conn_rowkey IN
                (SELECT e.objkey
                   FROM EQUIPMENT_OBJECT e
                  START WITH e.mch_code = mch_code_
                         AND e.contract = contract_
                 CONNECT BY PRIOR e.mch_code = e.sup_mch_code
                        AND PRIOR e.contract = e.sup_contract);

      CURSOR get_all_active_location_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = location_mch_code
                         AND PRIOR contract = location_contract));

      CURSOR get_all_active_from_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = from_mch_code
                         AND PRIOR contract = from_contract));

      CURSOR get_all_active_to_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = to_mch_code
                         AND PRIOR contract = to_contract));

      CURSOR get_all_active_pipe_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = pipe_mch_code
                         AND PRIOR contract = pipe_contract));

      CURSOR get_all_active_process_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = process_mch_code
                         AND PRIOR contract = process_contract));

      CURSOR get_all_active_circuit_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (objstate NOT IN ('FINISHED', 'CANCELLED') AND
                (actual_object_id, actual_object_site) IN
                (SELECT mch_code, contract
                    FROM EQUIPMENT_OBJECT_UIV
                   START WITH mch_code = mch_code_
                          AND contract = contract_
                  CONNECT BY PRIOR mch_code = circuit_mch_code
                         AND PRIOR contract = circuit_contract));

      CURSOR get_all_hist_work_task IS
         SELECT jt.task_seq
           FROM JT_TASK_UIV jt
          WHERE (actual_object_id = mch_code_ AND
                actual_object_site = contract_ AND
                objstate IN ('FINISHED', 'CANCELLED'));
   $END
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      CURSOR get_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS (SELECT 1
                           FROM PSC_SRV_LINE_OBJECTS t
                          WHERE t.contract_id = cp.contract_id
                            AND t.line_no = cp.line_no
                            AND t.mch_code = mch_code_
                            AND t.mch_contract = contract_))
          ORDER BY contract_id, line_no;

      CURSOR get_all_function_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = sup_mch_code
                                 AND PRIOR contract = sup_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_location_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = location_mch_code
                                 AND PRIOR contract = location_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_from_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = from_mch_code
                                 AND PRIOR contract = from_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_to_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = to_mch_code
                                 AND PRIOR contract = to_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_process_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = process_mch_code
                                 AND PRIOR contract = process_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_pipe_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = pipe_mch_code
                                 AND PRIOR contract = pipe_contract)))
          ORDER BY contract_id, line_no;

      CURSOR get_all_circuit_service_lines IS
         SELECT cp.contract_id, cp.line_no
           FROM PSC_CONTR_PRODUCT_UIV cp
          WHERE connection_type_db IN ('EQUIPMENT', 'CATEGORY', 'PART')
            AND (EXISTS
                 (SELECT 1
                    FROM PSC_SRV_LINE_OBJECTS t
                   WHERE t.contract_id = cp.CONTRACT_ID
                     AND t.line_no = cp.LINE_NO
                     AND (t.mch_code, t.mch_contract) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM Equipment_All_Object_Uiv
                           START WITH mch_code = mch_code_
                                  AND contract = contract_
                          CONNECT BY PRIOR mch_code = circuit_mch_code
                                 AND PRIOR contract = circuit_contract)))
          ORDER BY contract_id, line_no;
   $END
BEGIN
   first_iter_ := 0;
   IF navigating_form_ = '1EquipmentObject' THEN
      navigation_url_ := 'page/EquipmentAllObjects/List?$filter=';

            IF structure_in_tree_ = 'L' THEN
      FOR rec_ IN get_location_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      
      ELSIF structure_in_tree_ = 'R' THEN
      FOR rec_ IN get_from_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      ELSIF structure_in_tree_ = 'T' THEN
      FOR rec_ IN get_to_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      
      ELSIF structure_in_tree_ = 'P' THEN
      FOR rec_ IN get_process_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      
      ELSIF structure_in_tree_ = 'S' THEN
      FOR rec_ IN get_pipe_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      
      ELSIF structure_in_tree_ = 'E' THEN
      FOR rec_ IN get_circuit_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      ELSE
      FOR rec_ IN get_obj LOOP
         IF first_iter_ = 0 THEN
            navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         ELSE
            navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                               rec_.mch_code || ''' and Contract eq ''' ||
                               rec_.contract || '''';
         END IF;
         first_iter_ := 1;
      END LOOP;
      END IF;
   END IF;
   IF navigating_form_ = '2EquipmentObject' THEN
      navigation_url_ := 'page/EquipmentAllObjects/List?$filter=';
   
      IF structure_in_tree_ = 'L' THEN
         FOR rec_ IN get_all_location_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      
      ELSIF structure_in_tree_ = 'R' THEN
         FOR rec_ IN get_all_from_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      ELSIF structure_in_tree_ = 'T' THEN
         FOR rec_ IN get_all_to_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      
      ELSIF structure_in_tree_ = 'P' THEN
         FOR rec_ IN get_all_process_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      
      ELSIF structure_in_tree_ = 'S' THEN
         FOR rec_ IN get_all_pipe_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      
      ELSIF structure_in_tree_ = 'E' THEN
         FOR rec_ IN get_all_circuit_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      ELSE
         FOR rec_ IN get_all_function_obj LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or MchCode eq ''' ||
                                  rec_.mch_code || ''' and Contract eq ''' ||
                                  rec_.contract || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      END IF;
   END IF;
   IF navigating_form_ = '2PmAction' THEN
      $IF Component_Pm_SYS.INSTALLED $THEN
         IF type_of_obj_ = 'Single' THEN
            navigation_url_ := 'page/PmActions/List?$filter=';
            FOR rec_ IN get_std_pm LOOP
               IF first_iter_ = 0 THEN
                  navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                     rec_.pm_no || ' and PmRevision eq ''' ||
                                     rec_.pm_revision || '''';
               ELSE
                  navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                     rec_.pm_no || ' and PmRevision eq ''' ||
                                     rec_.pm_revision || '''';
               END IF;
               first_iter_ := 1;
            END LOOP;
         ELSE
            navigation_url_ := 'page/PmActions/List?$filter=';

            IF structure_in_tree_ = 'L' THEN
               FOR rec_ IN get_all_location_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'R' THEN
               FOR rec_ IN get_all_from_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            ELSIF structure_in_tree_ = 'T' THEN
               FOR rec_ IN get_all_to_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'P' THEN
               FOR rec_ IN get_all_process_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'S' THEN
               FOR rec_ IN get_all_pipe_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'E' THEN
               FOR rec_ IN get_all_circuit_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSE
               FOR rec_ IN get_all_function_pm LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  ELSE
                     navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                        rec_.pm_no || ' and PmRevision eq ''' ||
                                        rec_.pm_revision || '''';
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            END IF;

         END IF;
      $ELSE
         navigation_url_ := '';
      $END
   END IF;
   IF navigating_form_ = '3PmAction' THEN
      $IF Component_Pm_SYS.INSTALLED $THEN
         navigation_url_ := 'page/MaintenancePlanAnalysis/List?$filter=';
         FOR rec_ IN get_maint_plan LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'PmNo eq ' || rec_.pm_no ||
                                  ' and PmRevision eq ''' || rec_.pm_revision || '''';
            ELSE
               navigation_url_ := navigation_url_ || ' or PmNo eq ' ||
                                  rec_.pm_no || ' and PmRevision eq ''' ||
                                  rec_.pm_revision || '''';
            END IF;
            first_iter_ := 1;
         END LOOP;
      $ELSE
         navigation_url_ := '';
      $END
   END IF;
   IF navigating_form_ = '5WorkOrder' THEN
      IF type_of_obj_ = 'Single' THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            navigation_url_ := 'page/ActiveWorkOrders/List?$filter=';
            FOR rec_ IN get_active_wo LOOP
               IF first_iter_ = 0 THEN
                  navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                     rec_.wo_no;
               ELSE
                  navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                     rec_.wo_no;
               END IF;
               first_iter_ := 1;
            END LOOP;
         $ELSE
            navigation_url_ := '';
         $END
      ELSE
         $IF Component_Wo_SYS.INSTALLED $THEN
            navigation_url_ := 'page/ActiveWorkOrders/List?$filter=';

            IF structure_in_tree_ = 'L' THEN
               FOR rec_ IN get_all_active_location_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'R' THEN
               FOR rec_ IN get_all_active_from_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            ELSIF structure_in_tree_ = 'T' THEN
               FOR rec_ IN get_all_active_to_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'P' THEN
               FOR rec_ IN get_all_active_process_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'S' THEN
               FOR rec_ IN get_all_active_pipe_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'E' THEN
               FOR rec_ IN get_all_active_circuit_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSE
               FOR rec_ IN get_all_active_function_wo LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'WoNo eq ' ||
                                        rec_.wo_no;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                        rec_.wo_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            END IF;
      
         $ELSE
            navigation_url_ := '';
         $END
      END IF;
   END IF;
   IF navigating_form_ = '6WorkOrder' THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         navigation_url_ := 'page/HistoricalWorkOrders/List?$filter=';
         FOR rec_ IN get_all_hist_wo LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'WoNo eq ' || rec_.wo_no;
            ELSE
               navigation_url_ := navigation_url_ || ' or WoNo eq ' ||
                                  rec_.wo_no;
            END IF;
            first_iter_ := 1;
         END LOOP;
      $ELSE
         navigation_url_ := '';
      $END
   END IF;
   IF navigating_form_ = '7JtTask' THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         navigation_url_ := 'page/WorkTasks/List?$filter=';
         FOR rec_ IN get_active_work_task LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                  rec_.task_seq;
            ELSE
               navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                  rec_.task_seq;
            END IF;
            first_iter_ := 1;
         END LOOP;
      $ELSE
         navigation_url_ := '';
      $END
   END IF;
   IF navigating_form_ = '8JtTask' THEN
      IF type_of_obj_ = 'Single' THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            navigation_url_ := 'page/WorkTasks/List?$filter=';
            FOR rec_ IN get_active_work_task LOOP
               IF first_iter_ = 0 THEN
                  navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                     rec_.task_seq;
               ELSE
                  navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                     rec_.task_seq;
               END IF;
               first_iter_ := 1;
            END LOOP;
         $ELSE
            navigation_url_ := '';
         $END
      ELSE
         $IF Component_Wo_SYS.INSTALLED $THEN
            navigation_url_ := 'page/WorkTasks/List?$filter=';

            IF structure_in_tree_ = 'L' THEN
               FOR rec_ IN get_all_active_location_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'R' THEN
               FOR rec_ IN get_all_active_from_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            ELSIF structure_in_tree_ = 'T' THEN
               FOR rec_ IN get_all_active_to_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'P' THEN
               FOR rec_ IN get_all_active_process_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'S' THEN
               FOR rec_ IN get_all_active_pipe_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'E' THEN
               FOR rec_ IN get_all_active_circuit_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSE
               FOR rec_ IN get_all_active_function_work_task LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                        rec_.task_seq;
                  ELSE
                     navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                        rec_.task_seq;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            END IF;
      
         $ELSE
            navigation_url_ := '';
         $END
      END IF;
   END IF;
   IF navigating_form_ = '90JtTask' THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         navigation_url_ := 'page/WorkTasks/List?$filter=';
         FOR rec_ IN get_all_hist_work_task LOOP
            IF first_iter_ = 0 THEN
               navigation_url_ := navigation_url_ || 'TaskSeq eq ' ||
                                  rec_.task_seq;
            ELSE
               navigation_url_ := navigation_url_ || ' or TaskSeq eq ' ||
                                  rec_.task_seq;
            END IF;
            first_iter_ := 1;
         END LOOP;
      $ELSE
         navigation_url_ := '';
      $END
   END IF;
   IF navigating_form_ = '92WorkOrder' THEN
      IF type_of_obj_ = 'Single' THEN
         $IF Component_Pcmsci_SYS.INSTALLED $THEN
            navigation_url_ := 'page/EquipmentObjectNavigator/PscServicesList?$filter=';
            FOR rec_ IN get_service_lines LOOP
               IF first_iter_ = 0 THEN
                  navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                     rec_.contract_id || ''' and LineNo eq ' ||
                                     rec_.line_no;
               ELSE
                  navigation_url_ := navigation_url_ || ' or ContractId eq ''' ||
                                     rec_.contract_id || ''' and LineNo eq ' ||
                                     rec_.line_no;
               END IF;
               first_iter_ := 1;
            END LOOP;
         $ELSE
            navigation_url_ := '';
         $END
      ELSE
         $IF Component_Pcmsci_SYS.INSTALLED $THEN
            navigation_url_ := 'page/EquipmentObjectNavigator/PscServicesList?$filter=';

            IF structure_in_tree_ = 'L' THEN
               FOR rec_ IN get_all_location_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'R' THEN
               FOR rec_ IN get_all_from_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            ELSIF structure_in_tree_ = 'T' THEN
               FOR rec_ IN get_all_to_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'P' THEN
               FOR rec_ IN get_all_process_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'S' THEN
               FOR rec_ IN get_all_pipe_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSIF structure_in_tree_ = 'E' THEN
               FOR rec_ IN get_all_circuit_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;

            ELSE
               FOR rec_ IN get_all_function_service_lines LOOP
                  IF first_iter_ = 0 THEN
                     navigation_url_ := navigation_url_ || 'ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  ELSE
                     navigation_url_ := navigation_url_ ||
                                        ' or ContractId eq ''' ||
                                        rec_.contract_id ||
                                        ''' and LineNo eq ' || rec_.line_no;
                  END IF;
                  first_iter_ := 1;
               END LOOP;
            END IF;
     
         $ELSE
            navigation_url_ := '';
         $END
      END IF;
   END IF;
   RETURN navigation_url_;
END Get_Navigation_Url;

--For Equipment Object Navigater in UXx
@UncheckedAccess
FUNCTION Get_Sc_Count_Service_Object(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   sc_count_ NUMBER := 0;
   $IF Component_Pcmsci_SYS.INSTALLED AND Component_Srvcon_SYS.INSTALLED $THEN
      CURSOR get_sc_count IS
         SELECT COUNT(contr_line.contract_id)
         FROM   psc_contr_product contr_line
         WHERE  contr_line.contract_id IN (SELECT contract_id
                                           FROM   sc_service_contract)
         AND    (connection_type_db = 'REQUEST')
         AND    (EXISTS (SELECT 1
                         FROM   psc_srv_line_objects obj_lines
                         WHERE  obj_lines.contract_id = contr_line.contract_id
                         AND    obj_lines.line_no = contr_line.line_no
                         AND    obj_lines.equipment_object_seq = equipment_object_seq_));
   $END

BEGIN
   $IF Component_Pcmsci_SYS.INSTALLED AND Component_Srvcon_SYS.INSTALLED $THEN
      OPEN get_sc_count;
      FETCH get_sc_count INTO sc_count_;
      CLOSE get_sc_count;
   $END
   RETURN sc_count_;
END Get_Sc_Count_Service_Object;



@UncheckedAccess
FUNCTION Get_Sc_Count_Object_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   sc_count_ NUMBER := 0;
   $IF Component_Pcmsci_SYS.INSTALLED AND Component_Srvcon_SYS.INSTALLED $THEN
   CURSOR get_sc_count IS
      SELECT COUNT(contr_line.contract_id)
      FROM   psc_contr_product contr_line
      WHERE  contr_line.contract_id IN (SELECT contract_id
                                        FROM   sc_service_contract)
      AND    (connection_type_db = 'REQUEST')
      AND    (EXISTS (SELECT 1
                      FROM   psc_srv_line_objects obj_lines
                      WHERE  obj_lines.contract_id = contr_line.contract_id
                      AND    obj_lines.line_no = contr_line.line_no
                      AND (obj_lines.equipment_object_seq) IN
                            (SELECT equipment_object_seq
                               FROM EQUIPMENT_OBJECT
                              START WITH equipment_object_seq = equipment_object_seq_
                             CONNECT BY PRIOR equipment_object_seq = functional_object_seq)));
   $END

BEGIN
   $IF Component_Pcmsci_SYS.INSTALLED AND Component_Srvcon_SYS.INSTALLED $THEN
      OPEN get_sc_count;
      FETCH get_sc_count INTO sc_count_;
      CLOSE get_sc_count;
   $END
   RETURN sc_count_;
END Get_Sc_Count_Object_Str;

--For Equipment Object Navigater in UXx
@UncheckedAccess
FUNCTION Get_Recp_Count_Service_Object(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   recp_count_ NUMBER := 0;
   $IF Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_recp_count IS
      SELECT COUNT(rec_ser.rec_program_id)
         FROM   Recurring_Service_Program_TAB rec_ser,  Equipment_Object_Tab equ_obj
         WHERE  (rec_ser.obj_conn_lu_name = 'EquipmentObject'
         AND    equ_obj.equipment_object_seq = equipment_object_seq_
         AND    equ_obj.rowkey =  rec_ser.obj_conn_rowkey)
         OR (EXISTS (SELECT 1 FROM Rec_Program_Scope_Schedule rec_sch, Recurring_Service_Scope rec_scp
                      WHERE rec_ser.rec_program_id = rec_sch.rec_program_id
                      AND rec_ser.rec_program_revision = rec_sch.rec_program_revision
                      AND rec_ser.rec_program_id = rec_scp.rec_program_id
                      AND rec_ser.rec_program_revision = rec_scp.rec_program_revision
                      AND rec_sch.rec_scope_id = rec_scp.rec_scope_id
                      AND rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                      AND equ_obj.equipment_object_seq = equipment_object_seq_
                      AND rec_scp.obj_conn_rowkey = equ_obj.rowkey));
   $END

BEGIN
   $IF Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_recp_count;
      FETCH get_recp_count INTO recp_count_;
      CLOSE get_recp_count;
   $END
   RETURN recp_count_;
END Get_Recp_Count_Service_Object;

@UncheckedAccess
FUNCTION Get_Recp_Count_Object_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   recp_count_ NUMBER := 0;
   $IF Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_recp_count IS
      SELECT COUNT(rec_ser.rec_program_id)
                  FROM   Recurring_Service_Program_TAB rec_ser
                  WHERE  (rec_ser.obj_conn_lu_name = 'EquipmentObject'
                  AND    rec_ser.obj_conn_rowkey IN
                                  (SELECT ROWKEY
                                     FROM EQUIPMENT_OBJECT_TAB
                                    START WITH equipment_object_seq = equipment_object_seq_
                                   CONNECT BY PRIOR equipment_object_seq = functional_object_seq))
                  OR (EXISTS (SELECT 1 FROM Rec_Program_Scope_Schedule rec_sch, Recurring_Service_Scope rec_scp
                      WHERE rec_ser.rec_program_id = rec_sch.rec_program_id
                      AND rec_ser.rec_program_revision = rec_sch.rec_program_revision
                      AND rec_ser.rec_program_id = rec_scp.rec_program_id
                      AND rec_ser.rec_program_revision = rec_scp.rec_program_revision
                      AND rec_sch.rec_scope_id = rec_scp.rec_scope_id
                      AND rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                      AND ((rec_scp.obj_conn_rowkey) IN
                         (SELECT ROWKEY
                            FROM EQUIPMENT_OBJECT_TAB
                           START WITH equipment_object_seq = equipment_object_seq_
                          CONNECT BY PRIOR equipment_object_seq = functional_object_seq))));
   $END

BEGIN
   $IF Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_recp_count;
      FETCH get_recp_count INTO recp_count_;
      CLOSE get_recp_count;
   $END
   RETURN recp_count_;
END Get_Recp_Count_Object_Str;

@UncheckedAccess
FUNCTION Get_Active_Req_Count(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   req_count_ NUMBER := 0;
   mch_code_         equipment_object_tab.mch_code%TYPE := Equipment_Object_API.Get_Mch_Code(equipment_object_seq_);
   contract_         equipment_object_tab.contract%TYPE := Equipment_Object_API.Get_Contract(equipment_object_seq_);
   
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_req_count IS
      SELECT COUNT(req.req_id)
      FROM   srv_request req
      WHERE  req.objstate NOT IN ('Closed', 'Completed', 'Cancelled')
      AND    (req.req_id IN (SELECT srv_req.req_id
                             FROM   srv_request_scope_all srv_req
                             WHERE  srv_req.req_id = req.req_id
                             AND    req.source_db = 'MANUAL'
                             AND    srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
                             AND    srv_req.actual_object_site = contract_
                             AND    srv_req.actual_object_id = mch_code_)
                           OR req.req_id IN (SELECT srv_req.req_id
                                           FROM   srv_request_scope_all      srv_req,
                                                  recurring_service_scope    rec_scp,
                                                  rec_program_scope_schedule rec_sch,
                                                  equipment_object_tab       equ_obj
                                           WHERE  srv_req.req_id = req.req_id
                                           AND    req.source_db = 'RECURRING_SERVICE'
                                           AND    rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                                           AND    rec_sch.rec_program_id = rec_scp.rec_program_id
                                           AND    rec_sch.rec_program_revision = rec_scp.rec_program_revision
                                           AND    rec_sch.rec_scope_id = rec_scp.rec_scope_id
                                           AND    rec_sch.srv_request_scope_id = srv_req.srv_request_scope_id
                                           AND    equ_obj.equipment_object_seq = equipment_object_seq_
                                           AND    rec_scp.obj_conn_rowkey = equ_obj.rowkey));    
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_req_count;
      FETCH get_req_count INTO req_count_;
      CLOSE get_req_count;
   $END
   RETURN req_count_;
END Get_Active_Req_Count;


@UncheckedAccess
FUNCTION Get_Active_Req_Count_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   req_count_ NUMBER := 0;
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_req_count IS
      SELECT COUNT(req.req_id)
      FROM   srv_request req
      WHERE  req.objstate NOT IN ('Closed', 'Completed', 'Cancelled')
      AND    (req.req_id IN (SELECT srv_req.req_id
                             FROM   srv_request_scope_all srv_req
                             WHERE  srv_req.req_id = req.req_id
                             AND    req.source_db = 'MANUAL'
                             AND    srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
                             AND (srv_req.actual_object_id, srv_req.actual_object_site) IN
                                  (SELECT MCH_CODE, CONTRACT
                                     FROM EQUIPMENT_OBJECT
                                    START WITH equipment_object_seq = equipment_object_seq_
                                   CONNECT BY PRIOR equipment_object_seq = functional_object_seq))
                           OR req.req_id IN (SELECT srv_req.req_id
                                           FROM   srv_request_scope_all      srv_req,
                                                  recurring_service_scope    rec_scp,
                                                  rec_program_scope_schedule rec_sch
                                           WHERE  srv_req.req_id = req.req_id
                                           AND    req.source_db = 'RECURRING_SERVICE'
                                           AND    rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                                           AND    rec_sch.rec_program_id = rec_scp.rec_program_id
                                           AND    rec_sch.rec_program_revision = rec_scp.rec_program_revision
                                           AND    rec_sch.rec_scope_id = rec_scp.rec_scope_id
                                           AND    rec_sch.srv_request_scope_id = srv_req.srv_request_scope_id
                                           AND ((rec_scp.obj_conn_rowkey) IN
                                                 (SELECT ROWKEY
                                                    FROM EQUIPMENT_OBJECT_TAB
                                                   START WITH equipment_object_seq = equipment_object_seq_
                                                  CONNECT BY PRIOR equipment_object_seq = functional_object_seq))));    
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_req_count;
      FETCH get_req_count INTO req_count_;
      CLOSE get_req_count;
   $END
   RETURN req_count_;
END Get_Active_Req_Count_Str;

@UncheckedAccess
FUNCTION Get_Active_Task_Count(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   task_count_ NUMBER := 0;
   mch_code_         equipment_object_tab.mch_code%TYPE := Equipment_Object_API.Get_Mch_Code(equipment_object_seq_);
   contract_         equipment_object_tab.contract%TYPE := Equipment_Object_API.Get_Contract(equipment_object_seq_);
   
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
   CURSOR get_active_task_count IS
      SELECT COUNT(UNIQUE(task_scope.task_seq))
      FROM   srv_request_scope_all srv_req, Task_Request_Scope task_scope, jt_task_tab task_rec
      WHERE  srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
      AND    srv_req.actual_object_site = contract_
      AND    srv_req.actual_object_id = mch_code_
      AND srv_req.Srv_Request_Scope_Id = task_scope.Srv_Request_Scope_Id
      AND task_rec.task_seq = task_scope.task_seq
      AND task_rec.rowstate NOT IN ('FINISHED', 'CANCELLED', 'WORKDONE');
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
      OPEN get_active_task_count;
      FETCH get_active_task_count INTO task_count_;
      CLOSE get_active_task_count;
   $END
   RETURN task_count_;
END Get_Active_Task_Count;


@UncheckedAccess
FUNCTION Get_Active_Task_Count_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   task_count_ NUMBER := 0;
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
   CURSOR get_active_task_count IS
      SELECT COUNT(UNIQUE(task_scope.task_seq))
      FROM   srv_request_scope_all srv_req, Task_Request_Scope task_scope, jt_task_tab task_rec
      WHERE  srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
      AND srv_req.Srv_Request_Scope_Id = task_scope.Srv_Request_Scope_Id
      AND task_rec.task_seq = task_scope.task_seq
      AND task_rec.rowstate NOT IN ('FINISHED', 'CANCELLED', 'WORKDONE')
      AND (srv_req.actual_object_id, srv_req.actual_object_site) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM EQUIPMENT_OBJECT
                           START WITH equipment_object_seq = equipment_object_seq_
                          CONNECT BY PRIOR equipment_object_seq = functional_object_seq);
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
      OPEN get_active_task_count;
      FETCH get_active_task_count INTO task_count_;
      CLOSE get_active_task_count;
   $END
   RETURN task_count_;
END Get_Active_Task_Count_Str;

@UncheckedAccess
FUNCTION Get_Finished_Req_Count(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   req_count_ NUMBER := 0;
   mch_code_         equipment_object_tab.mch_code%TYPE := Equipment_Object_API.Get_Mch_Code(equipment_object_seq_);
   contract_         equipment_object_tab.contract%TYPE := Equipment_Object_API.Get_Contract(equipment_object_seq_);
   
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_fin_req_count IS
      SELECT COUNT(req.req_id)
      FROM   srv_request req
      WHERE  req.objstate IN ('Closed', 'Completed')
      AND    (req.req_id IN (SELECT srv_req.req_id
                             FROM   srv_request_scope_all srv_req
                             WHERE  srv_req.req_id = req.req_id
                             AND    req.source_db = 'MANUAL'
                             AND    srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
                             AND    srv_req.actual_object_site = contract_
                             AND    srv_req.actual_object_id = mch_code_)
                           OR req.req_id IN (SELECT srv_req.req_id
                                           FROM   srv_request_scope_all      srv_req,
                                                  recurring_service_scope    rec_scp,
                                                  rec_program_scope_schedule rec_sch,
                                                  equipment_object_tab       equ_obj
                                           WHERE  srv_req.req_id = req.req_id
                                           AND    req.source_db = 'RECURRING_SERVICE'
                                           AND    rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                                           AND    rec_sch.rec_program_id = rec_scp.rec_program_id
                                           AND    rec_sch.rec_program_revision = rec_scp.rec_program_revision
                                           AND    rec_sch.rec_scope_id = rec_scp.rec_scope_id
                                           AND    rec_sch.srv_request_scope_id = srv_req.srv_request_scope_id
                                           AND    equ_obj.equipment_object_seq = equipment_object_seq_
                                           AND    rec_scp.obj_conn_rowkey = equ_obj.rowkey));    
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_fin_req_count;
      FETCH get_fin_req_count INTO req_count_;
      CLOSE get_fin_req_count;
   $END
   RETURN req_count_;
END Get_Finished_Req_Count;


@UncheckedAccess
FUNCTION Get_Finished_Req_Count_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   req_count_ NUMBER := 0;
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
   CURSOR get_fin_req_count IS
      SELECT COUNT(req.req_id)
      FROM   srv_request req
      WHERE  req.objstate IN ('Closed', 'Completed')
      AND    (req.req_id IN (SELECT srv_req.req_id
                             FROM   srv_request_scope_all srv_req
                             WHERE  srv_req.req_id = req.req_id
                             AND    req.source_db = 'MANUAL'
                             AND    srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
                             AND (srv_req.actual_object_id, srv_req.actual_object_site) IN
                                  (SELECT MCH_CODE, CONTRACT
                                     FROM EQUIPMENT_OBJECT
                                    START WITH equipment_object_seq = equipment_object_seq_
                                   CONNECT BY PRIOR mch_code = sup_mch_code
                                          AND PRIOR contract = sup_contract))
                           OR req.req_id IN (SELECT srv_req.req_id
                                           FROM   srv_request_scope_all      srv_req,
                                                  recurring_service_scope    rec_scp,
                                                  rec_program_scope_schedule rec_sch
                                           WHERE  srv_req.req_id = req.req_id
                                           AND    req.source_db = 'RECURRING_SERVICE'
                                           AND    rec_scp.obj_conn_lu_name_db = 'EquipmentObject'
                                           AND    rec_sch.rec_program_id = rec_scp.rec_program_id
                                           AND    rec_sch.rec_program_revision = rec_scp.rec_program_revision
                                           AND    rec_sch.rec_scope_id = rec_scp.rec_scope_id
                                           AND    rec_sch.srv_request_scope_id = srv_req.srv_request_scope_id
                                           AND ((rec_scp.obj_conn_rowkey) IN
                                                 (SELECT ROWKEY
                                                    FROM EQUIPMENT_OBJECT_TAB
                                                   START WITH equipment_object_seq = equipment_object_seq_
                                                  CONNECT BY PRIOR equipment_object_seq = functional_object_seq))));    
   $END
BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Recsrv_SYS.INSTALLED $THEN
      OPEN get_fin_req_count;
      FETCH get_fin_req_count INTO req_count_;
      CLOSE get_fin_req_count;
   $END
   RETURN req_count_;
END Get_Finished_Req_Count_Str;

@UncheckedAccess
FUNCTION Get_Finished_Task_Count(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   task_count_ NUMBER := 0;
   mch_code_         equipment_object_tab.mch_code%TYPE := Equipment_Object_API.Get_Mch_Code(equipment_object_seq_);
   contract_         equipment_object_tab.contract%TYPE := Equipment_Object_API.Get_Contract(equipment_object_seq_);
   
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
   CURSOR get_fin_task_count IS
      SELECT COUNT(UNIQUE(task_scope.task_seq))
      FROM   srv_request_scope_all srv_req, Task_Request_Scope task_scope, jt_task_tab task_rec
      WHERE  srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
      AND    srv_req.actual_object_site = contract_
      AND    srv_req.actual_object_id = mch_code_
      AND srv_req.Srv_Request_Scope_Id = task_scope.Srv_Request_Scope_Id
      AND task_rec.task_seq = task_scope.task_seq
      AND task_rec.rowstate IN ('FINISHED', 'WORKDONE');
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
      OPEN get_fin_task_count;
      FETCH get_fin_task_count INTO task_count_;
      CLOSE get_fin_task_count;
   $END
   RETURN task_count_;
END Get_Finished_Task_Count;


@UncheckedAccess
FUNCTION Get_Finished_Task_Count_Str(
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   task_count_ NUMBER := 0;
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
   CURSOR get_fin_task_count IS
      SELECT COUNT(UNIQUE(task_scope.task_seq))
      FROM   srv_request_scope_all srv_req, Task_Request_Scope task_scope, jt_task_tab task_rec
      WHERE  srv_req.actual_obj_conn_lu_name_db = 'EquipmentObject'
      AND srv_req.Srv_Request_Scope_Id = task_scope.Srv_Request_Scope_Id
      AND task_rec.task_seq = task_scope.task_seq
      AND task_rec.rowstate IN ('FINISHED', 'WORKDONE')
      AND (srv_req.actual_object_id, srv_req.actual_object_site) IN
                         (SELECT MCH_CODE, CONTRACT
                            FROM EQUIPMENT_OBJECT
                           START WITH equipment_object_seq = equipment_object_seq_
                          CONNECT BY PRIOR equipment_object_seq = functional_object_seq);
   $END

BEGIN
   $IF Component_Reqmgt_SYS.INSTALLED AND Component_Wo_SYS.INSTALLED $THEN
      OPEN get_fin_task_count;
      FETCH get_fin_task_count INTO task_count_;
      CLOSE get_fin_task_count;
   $END
   RETURN task_count_;
END Get_Finished_Task_Count_Str;

@UncheckedAccess
FUNCTION Get_Equipment_Object_Seq (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN NUMBER
IS
   equipment_object_seq_ equipment_object_tab.equipment_object_seq%TYPE;
   CURSOR get_sq IS 
   SELECT equipment_object_seq
      FROM  equipment_object_tab
      WHERE contract = contract_
      AND   mch_code = mch_code_;
BEGIN
   OPEN get_sq;
   FETCH get_sq INTO equipment_object_seq_;
   CLOSE get_sq;
   RETURN equipment_object_seq_;
END Get_Equipment_Object_Seq;

@UncheckedAccess
FUNCTION Get_Contract_From_Key_Ref (
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_ equipment_object_tab.contract%TYPE;
   CURSOR get_contract_ IS 
   SELECT contract
      FROM  equipment_object_tab
      WHERE equipment_object_seq = Client_SYS.Get_Key_Reference_Value(key_ref_, 'EQUIPMENT_OBJECT_SEQ');
BEGIN
   OPEN get_contract_;
   FETCH get_contract_ INTO contract_;
   CLOSE get_contract_;
   RETURN contract_;
END Get_Contract_From_Key_Ref;

@UncheckedAccess
FUNCTION Get_Mch_Code_From_Key_Ref (
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   mch_code_ equipment_object_tab.mch_code%TYPE;
   CURSOR get_mch_code_ IS 
   SELECT mch_code
      FROM  equipment_object_tab
      WHERE equipment_object_seq = Client_SYS.Get_Key_Reference_Value(key_ref_, 'EQUIPMENT_OBJECT_SEQ');
BEGIN
   OPEN get_mch_code_;
   FETCH get_mch_code_ INTO mch_code_;
   CLOSE get_mch_code_;
   RETURN mch_code_;
END Get_Mch_Code_From_Key_Ref;

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
   Error_SYS.Fnd_Too_Many_Rows(Equipment_Object_API.lu_name_, NULL, methodname_);
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
   Error_SYS.Fnd_Record_Not_Exist(Equipment_Object_API.lu_name_);
END Raise_Record_Not_Exist___;

@UncheckedAccess
FUNCTION Has_Cust_Warranty__ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Has_Cust_Warranty__(Get_Equipment_Object_Seq(contract_, mch_code_));
END Has_Cust_Warranty__;

-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab%ROWTYPE
IS
BEGIN
   RETURN Get_Object_By_Keys___(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(Get_Equipment_Object_Seq(contract_, mch_code_));
END Check_Exist___;

-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(Get_Equipment_Object_Seq(contract_, mch_code_));
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, mch_code_);
END Exists;

-- Get_Mch_Name
--   Fetches the MchName attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Name (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Name(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Name;


-- Get_Mch_Loc
--   Fetches the MchLoc attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Loc (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Loc(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Loc;


-- Get_Mch_Pos
--   Fetches the MchPos attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Pos (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Pos(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Pos;


-- Get_Equipment_Main_Position
--   Fetches the EquipmentMainPosition attribute for a record.
@UncheckedAccess
FUNCTION Get_Equipment_Main_Position (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Equipment_Main_Position(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Equipment_Main_Position;


-- Get_Equipment_Main_Position_Db
--   Fetches the DB value of EquipmentMainPosition attribute for a record.
@UncheckedAccess
FUNCTION Get_Equipment_Main_Position_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab.main_pos%TYPE
IS
BEGIN
   RETURN Get_Equipment_Main_Position_Db(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Equipment_Main_Position_Db;


-- Get_Group_Id
--   Fetches the GroupId attribute for a record.
@UncheckedAccess
FUNCTION Get_Group_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Group_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Group_Id;


-- Get_Mch_Type
--   Fetches the MchType attribute for a record.
@UncheckedAccess
FUNCTION Get_Mch_Type (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Mch_Type(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Mch_Type;


-- Get_Cost_Center
--   Fetches the CostCenter attribute for a record.
@UncheckedAccess
FUNCTION Get_Cost_Center (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Cost_Center(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Cost_Center;


-- Get_Object_No
--   Fetches the ObjectNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Object_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Object_No(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Object_No;


-- Get_Category_Id
--   Fetches the CategoryId attribute for a record.
@UncheckedAccess
FUNCTION Get_Category_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Category_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Category_Id;


-- Get_Sup_Mch_Code
--   Fetches the SupMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Sup_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sup_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Sup_Mch_Code;


-- Get_Manufacturer_No
--   Fetches the ManufacturerNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Manufacturer_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Manufacturer_No(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Manufacturer_No;


-- Get_Serial_No
--   Fetches the SerialNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Serial_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Serial_No(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Serial_No;


-- Get_Type
--   Fetches the Type attribute for a record.
@UncheckedAccess
FUNCTION Get_Type (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Type(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Type;


-- Get_Sup_Contract
--   Fetches the SupContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Sup_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sup_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Sup_Contract;


-- Get_Part_No
--   Fetches the PartNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_No (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Part_No(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Part_No;


-- Get_Is_Category_Object
--   Fetches the IsCategoryObject attribute for a record.
@UncheckedAccess
FUNCTION Get_Is_Category_Object (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Is_Category_Object(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Is_Category_Object;


-- Get_Is_Geographic_Object
--   Fetches the IsGeographicObject attribute for a record.
@UncheckedAccess
FUNCTION Get_Is_Geographic_Object (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Is_Geographic_Object(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Is_Geographic_Object;


-- Get_Location_Mch_Code
--   Fetches the LocationMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Mch_Code;


-- Get_Location_Contract
--   Fetches the LocationContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Contract;


-- Get_From_Mch_Code
--   Fetches the FromMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_From_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_From_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_From_Mch_Code;


-- Get_From_Contract
--   Fetches the FromContract attribute for a record.
@UncheckedAccess
FUNCTION Get_From_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_From_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_From_Contract;


-- Get_To_Mch_Code
--   Fetches the ToMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_To_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_To_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_To_Mch_Code;


-- Get_To_Contract
--   Fetches the ToContract attribute for a record.
@UncheckedAccess
FUNCTION Get_To_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_To_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_To_Contract;


-- Get_Process_Mch_Code
--   Fetches the ProcessMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Mch_Code;


-- Get_Process_Contract
--   Fetches the ProcessContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Contract;


-- Get_Pipe_Mch_Code
--   Fetches the PipeMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Pipe_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pipe_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pipe_Mch_Code;


-- Get_Pipe_Contract
--   Fetches the PipeContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Pipe_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pipe_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pipe_Contract;


-- Get_Circuit_Mch_Code
--   Fetches the CircuitMchCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Circuit_Mch_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Circuit_Mch_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Circuit_Mch_Code;


-- Get_Circuit_Contract
--   Fetches the CircuitContract attribute for a record.
@UncheckedAccess
FUNCTION Get_Circuit_Contract (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Circuit_Contract(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Circuit_Contract;


-- Get_Criticality
--   Fetches the Criticality attribute for a record.
@UncheckedAccess
FUNCTION Get_Criticality (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Criticality(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Criticality;


-- Get_Item_Class_Id
--   Fetches the ItemClassId attribute for a record.
@UncheckedAccess
FUNCTION Get_Item_Class_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Item_Class_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Item_Class_Id;


-- Get_Location_Id
--   Fetches the LocationId attribute for a record.
@UncheckedAccess
FUNCTION Get_Location_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Location_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Location_Id;


-- Get_Applied_Pm_Program_Id
--   Fetches the AppliedPmProgramId attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Pm_Program_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Applied_Pm_Program_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Pm_Program_Id;


-- Get_Applied_Pm_Program_Rev
--   Fetches the AppliedPmProgramRev attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Pm_Program_Rev (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Applied_Pm_Program_Rev(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Pm_Program_Rev;


-- Get_Applied_Date
--   Fetches the AppliedDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Applied_Date (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Applied_Date(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Applied_Date;


-- Get_Pm_Prog_Application_Status
--   Fetches the PmProgApplicationStatus attribute for a record.
@UncheckedAccess
FUNCTION Get_Pm_Prog_Application_Status (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Pm_Prog_Application_Status(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Pm_Prog_Application_Status;


-- Get_Not_Applicable_Reason
--   Fetches the NotApplicableReason attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Reason (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Not_Applicable_Reason(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Reason;


-- Get_Not_Applicable_Set_User
--   Fetches the NotApplicableSetUser attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Set_User (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Not_Applicable_Set_User(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Set_User;


-- Get_Not_Applicable_Set_Date
--   Fetches the NotApplicableSetDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Not_Applicable_Set_Date (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Not_Applicable_Set_Date(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Not_Applicable_Set_Date;


-- Get_Safe_Access_Code
--   Fetches the SafeAccessCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Safe_Access_Code (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Safe_Access_Code(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Safe_Access_Code;


-- Get_Safe_Access_Code_Db
--   Fetches the DB value of SafeAccessCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Safe_Access_Code_Db (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN equipment_object_tab.safe_access_code%TYPE
IS
BEGIN
   RETURN Get_Safe_Access_Code_Db(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Safe_Access_Code_Db;


-- Get_Process_Class_Id
--   Fetches the ProcessClassId attribute for a record.
@UncheckedAccess
FUNCTION Get_Process_Class_Id (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Process_Class_Id(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Process_Class_Id;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN Public_Rec
IS
BEGIN
   RETURN Get(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get;

FUNCTION Get_Objkey (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Objkey(Get_Equipment_Object_Seq(contract_, mch_code_));
END Get_Objkey;


-- End: Methods to facilitate the references using CONTRACT, MCH_CODE business key
