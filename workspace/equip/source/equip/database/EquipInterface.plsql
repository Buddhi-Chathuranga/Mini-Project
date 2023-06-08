-----------------------------------------------------------------------------
--
--  Logical unit: EquipInterface
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971023  STSU    Created
--  971111  MNYS    Changed contract to spare_contract.
--  971112  ERJA    Adapted calls to part_serial_catalog to use of contract.
--  971208  TOWI    Changed record reference on some columns in CreateSerialPart.
--  091012  CAJO    Changed PART_REV to SERIAL_REVISION for PartSerialCatalog.
--  980112  CAJO    Changed call to Create_Serial_Part_Construct to Create_Serial_Part_Design.
--  980129  ERJA    Made changes according to new names in partserialcatalog.
--  980209  ERJA    Made changes according to current_position
--  980213  ERJA    Changes according to contract
--  980219  ERJA    New changes according to partserialcatalog and adaption of to contract.
--  980227  ERJA    Corrections due to part_no in Equipment_Functional
--  980302  ERJA    Added Remove_Object_Structure and Check_Exist_In_Structure.
--  980312  ERJA    Changed Remove_Object_Structure not to remove topobject
--  980319  ERJA    Chande call to Create_Construction_Object
--  980327  ERJA    Moved call to Modify_Alternate_Id
--  980402  ERJA    Changed IF-statement EQUIPMENT_OBJECT_CONN_API.Check_Exist to equal 1
--  980512  ERJA    Changed transfer of objects with part_no and tag_no to create both functional
--                  and serial objects
--  980512  ERJA    Changed call to Part_Serial_Catalog_API.Move_To_Design in
--                  Remove_Object_Structure not to execute for functional objects
--  981127  MIBO    Changed PARTY_TYPE_MANUFACTURER to MANUFACTURER_INFO and PARTY_TYPE_SUPPLIER to
--                  SUPPLIER_INFO.
--  990225  ERJA    Removed use of OUR_ID
--  990310  ERJA    Adaptions to new flow with parts in state issued
--  990614  ERJA    Removed commas in errormesages.
--  991215  PJONSE  Changed template due to performance improvement.
--  010426  CHATLK  Added the General_SYS.Init_Method to PROCEDURE Create_Serial_Part__.
--  011002  ANERSE  Bug Id 21800: Changes in procedure Create_Object; if item has a tag_no fetch MCH_NAME by 
--                  PROJECT_TAG_API.Get_Description.
--  011004  ANERSE  Bug Id 24462: Changes in procedure Create_Object; if item has a function_no assign MCH_NAME function_desc_.
--  011004  ANERSE  Bug Id 21800: Changed invoke to PROJECT_TAG_API.Get_Description in procedure 
--                  Create_Object to a dynamic invoke.
--  020517  kamtlk  Modified  serial_mch_code_ length from 40 to 75 in Procedure Create_Object.
--  020604  PEKR    Changed current_position to latest_transaction.
--  020618  CHCRLK  Modified procedure Create_Serial_Part__ to reflect changes made to Serial States in Part Serial catalog.
--  031222  SHAFLK  Bug Id 41313, Changed Create_Object method.
--  050525  DiAmlk  Obsoleted the attribute Amount.(Relate to spec AMEC113 - Cost Follow Up)
--  060308  tofjno  Modified Create_Object to always create a Note for the objects.
--  060309  tofjno  Modified Create_Object to add space between existing note info and the new info.
--  -------------------------Project Eagle-----------------------------------
--  091016  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  091105  SaFalk  IID - ME310: Removed bug comment tags.
--  110606  LoPrlk  Issue: EASTONE-18578, Altered the method Remove_Object_Structure
--  140812  HASTSE  Replaced dynamic code
--  141020  SHAFLK  PRSA-3709,Removed EQUIPMENT_ALL_OBJECT.
--  150422  VISRLK  Bug 122155 Create_Object, Modified Create_Object();
--  210422  KETKLK PJ21R2-448, Removed PDMPRO references from Create_Serial_Part__ and Create_Object .
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign-PARTCA changes : alternate_id obsolete work.
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Serial_Part__ (
   attr_ IN VARCHAR2 )
IS
   newrec_                       PART_SERIAL_CATALOG%ROWTYPE;
   newrec_2_                     PART_SERIAL_HISTORY%ROWTYPE;
   manrec_                       MANUFACTURER_INFO%ROWTYPE;
   suprec_                       SUPPLIER_INFO%ROWTYPE;
   
   ptr_                          NUMBER;
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(2000);
   source_                       VARCHAR2(6);
   transaction_description_      VARCHAR2(2000);
   superior_part_no_             VARCHAR2(25);
   superior_serial_no_           VARCHAR2(50);
   sup_mch_code_                 equipment_object.sup_mch_code%TYPE := NULL; 
   sup_contract_                 equipment_object.sup_contract%TYPE := NULL;   
  
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SOURCE') THEN
         source_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         newrec_.part_no := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         newrec_.serial_no := value_;
      ELSIF (name_ = 'LATEST_TRANSACTION') THEN
         newrec_.latest_transaction := value_;
      ELSIF (name_ = 'SERIAL_REVISION') THEN
         newrec_.serial_revision := value_;
      ELSIF (name_ = 'NOTE') THEN
         newrec_.note_text := value_;
      ELSIF (name_ = 'ORDER_NO') THEN
         newrec_2_.order_no := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         newrec_2_.line_no := value_;
      ELSIF (name_ = 'RELEASE_NO') THEN
         newrec_2_.release_no := value_;
      ELSIF (name_ = 'WARRANTY_EXPIRES') THEN
         newrec_.warranty_expires := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'MANUFACTURER_NO') THEN
         newrec_.manufacturer_no := value_;
       ELSIF (name_ = 'SUPPLIER_NO') THEN
         newrec_.supplier_no := value_;
      ELSIF (name_ = 'SUPERIOR_PART_NO') THEN
         newrec_.superior_part_no := value_;
      ELSIF (name_ = 'SUPERIOR_SERIAL_NO') THEN
         newrec_.superior_serial_no := value_;
-- ManufacturerInfo   (Old PartyTypeManufacturer)
      ELSIF (name_ = 'MANUFACTURER_NAME') THEN
         manrec_.name := value_;
      ELSIF (name_ = 'MANUF_ASSOCIATION_NO') THEN
         manrec_.association_no := value_;
--      ELSIF (name_ = 'MANUF_OUR_ID') THEN
--         manrec_.our_id := value_;
      ELSIF (name_ = 'MANUF_COUNTRY') THEN
         manrec_.country := value_;
      ELSIF (name_ = 'MANUF_DEFAULT_LANGUAGE') THEN
         manrec_.default_language := value_;
-- SupplierInfo    (Old PartyTypeSupplier)
      ELSIF (name_ = 'SUPPLIER_NAME') THEN
         suprec_.name := value_;
      ELSIF (name_ = 'SUPPL_ASSOCIATION_NO') THEN
         suprec_.association_no := value_;
--      ELSIF (name_ = 'SUPPL_OUR_ID') THEN
--         suprec_.our_id := value_;
      ELSIF (name_ = 'SUPPL_COUNTRY') THEN
         suprec_.country := value_;
      ELSIF (name_ = 'SUPPL_DEFAULT_LANGUAGE') THEN
         suprec_.default_language := value_;
      END IF;
   END LOOP;
   IF newrec_.manufacturer_no IS NOT NULL THEN
      IF Manufacturer_Info_API.Check_Exist(newrec_.manufacturer_no)='FALSE' THEN
         IF manrec_.country IS NOT NULL THEN
            Iso_Country_API.Activate_Code(manrec_.country);
         END IF;
         IF manrec_.default_language IS NOT NULL THEN
               ISo_Country_API.Activate_Code(manrec_.country);
         END IF;
         Manufacturer_Info_API.New(newrec_.manufacturer_no, manrec_.name,
         manrec_.association_no, manrec_.country, manrec_.default_language);
       END IF;
    END IF;

   IF newrec_.supplier_no IS NOT NULL THEN
      IF Supplier_Info_API.Check_Exist(newrec_.supplier_no)='FALSE' THEN
         IF suprec_.country IS NOT NULL THEN
               ISo_Country_API.Activate_Code(suprec_.country);
         END IF;
         IF suprec_.default_language IS NOT NULL THEN
               ISo_Country_API.Activate_Code(suprec_.country);
         END IF;
         Supplier_info_API.New(newrec_.supplier_no, suprec_.name, suprec_.association_no);
       END IF;
    END IF;

   IF source_ = 'EQUIP' THEN
      Equipment_Object_Util_API.Get_Object_Info(sup_contract_, sup_mch_code_, newrec_.part_no, newrec_.serial_no);
      IF (sup_mch_code_ IS NULL) THEN
         Part_Serial_Catalog_API.New_In_Facility(newrec_.part_no, newrec_.serial_no, newrec_.latest_transaction,
             transaction_description_, newrec_.serial_revision, 
            newrec_.note_text, newrec_.warranty_expires, newrec_.supplier_no, newrec_.manufacturer_no);
      ELSE
         Equipment_Object_Util_API.Get_Part_Info(superior_part_no_, superior_serial_no_, sup_contract_, sup_mch_code_);
         
         Part_Serial_Catalog_API.New_In_Contained(newrec_.part_no, newrec_.serial_no, newrec_.latest_transaction, 
             transaction_description_, superior_part_no_, superior_serial_no_, newrec_.serial_revision, 
            newrec_.note_text, newrec_.warranty_expires, newrec_.supplier_no, newrec_.manufacturer_no);
              
      END IF;        
   ELSE
      Error_SYS.Appl_General(lu_name_, 'SOURCEUNDEF: Undefined source for data');
   END IF;
END Create_Serial_Part__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Object (
   attr_ IN VARCHAR2 )
IS
   newrec_                       EQUIPMENT_OBJECT%ROWTYPE;
   grouprec_                     EQUIPMENT_OBJ_GROUP%ROWTYPE;
   partrec_                      PART_CATALOG%ROWTYPE;
   mch_type_description_         VARCHAR2(60);
   type_design_description_      VARCHAR2(60);
   part_unit_code_description_   VARCHAR2(50);
   group_unit_code_description_  VARCHAR2(50);
   in_mch_type_                  VARCHAR2(5);
   category_description_         VARCHAR2(25);
   individual_aware_             VARCHAR2(20);
   level_seq_                    NUMBER;
   std_name_                     VARCHAR2(35);
   ptr_                          NUMBER;
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(2000);
   document_category_            VARCHAR2(1);
   seq_no_                       NUMBER;
   tag_no_                       VARCHAR2(20);
   project_id_                    VARCHAR2(10);
   attr2_                        VARCHAR2(32000);
   attr3_                        VARCHAR2(32000);
   source_                       VARCHAR2(6);
   function_no_                  VARCHAR2(25);
   function_desc_                VARCHAR2(35);
BEGIN
   ptr_ := NULL;
   Client_SYS.Clear_Attr(attr2_);
   Client_SYS.Clear_Attr(attr3_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SOURCE') THEN
         source_ := value_;
      ELSIF (name_ = 'OBJECT_ID') THEN
         newrec_.mch_code := value_;
      ELSIF (name_ = 'OBJECT_NAME') THEN
         newrec_.mch_name := value_;
      ELSIF (name_ = 'PARENT_OBJECT_ID') THEN
         newrec_.sup_mch_code := value_;
      ELSIF (name_ = 'GROUP_ID') THEN
         newrec_.group_id := value_;
      ELSIF (name_ = 'GROUP_DESCRIPTION') THEN
         grouprec_.description := value_;
      ELSIF (name_ = 'GROUP_UNIT_CODE') THEN
         grouprec_.unit_code := value_;
      ELSIF (name_ = 'GROUP_UNIT_CODE_DESCRIPTION') THEN
         group_unit_code_description_ := value_;
      ELSIF (name_ = 'GROUP_NOM_RUNTIME') THEN
         grouprec_.nom_runtime := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PART_NO') THEN
         newrec_.part_no := value_;
      ELSIF (name_ = 'PART_STD_NAME') THEN
         std_name_ := value_;
      ELSIF (name_ = 'PART_UNIT_CODE') THEN
         partrec_.unit_code := value_;
      ELSIF (name_ = 'PART_UNIT_CODE_DESCRIPTION') THEN
         part_unit_code_description_ := value_;
      ELSIF (name_ = 'PART_INFO_TEXT') THEN
         partrec_.info_text := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         newrec_.serial_no := value_;
      ELSIF (name_ = 'PART_REV') THEN
         newrec_.part_rev := value_;
      ELSIF (name_ = 'LOCATION') THEN
         newrec_.mch_loc := substr(value_,1,10);
      ELSIF (name_ = 'POSITION') THEN
         newrec_.mch_pos := SUBSTR(value_,1,15);
      ELSIF (name_ = 'MCH_DOC') THEN
         newrec_.mch_doc := value_;
      ELSIF (name_ = 'TYPE') THEN
         newrec_.type := value_;
      ELSIF (name_ = 'TYPE_DESIGN_DESCRIPTION') THEN
         type_design_description_ := value_;
      ELSIF (name_ = 'MCH_TYPE') THEN
         newrec_.mch_type := value_;
      ELSIF (name_ = 'MCH_TYPE_DESCRIPTION') THEN
         mch_type_description_ := value_;
      ELSIF (name_ = 'IN_MCH_TYPE') THEN
         in_mch_type_ := value_;
      ELSIF (name_ = 'COST_CENTER') THEN
         newrec_.cost_center := NULL;
      ELSIF (name_ = 'OBJECT_NO') THEN
         newrec_.object_no := NULL;
      ELSIF (name_ = 'NOTE') THEN
         newrec_.note := value_;
      ELSIF (name_ = 'CATEGORY_ID') THEN
         newrec_.category_id := value_;
      ELSIF (name_ = 'CATEGORY_DESCRIPTION') THEN
         category_description_ := value_;
      ELSIF (name_ = 'MAIN_POS') THEN
         newrec_.equipment_main_position := value_;
      ELSIF (name_ = 'PRODUCTION_DATE') THEN
         newrec_.production_date := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'PURCH_DATE') THEN
         newrec_.purch_date := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'PURCH_PRICE') THEN
         newrec_.purch_price := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'WARRANTY_EXPIRES') THEN
         newrec_.warr_exp := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'MANUFACTURER_NO') THEN
         newrec_.manufacturer_no := value_;
       ELSIF (name_ = 'SUPPLIER_NO') THEN
         newrec_.vendor_no := value_;
      ELSIF (name_ = 'OBJ_LEVEL') THEN
         newrec_.obj_level := value_;
      ELSIF (name_ = 'INDIVIDUAL_AWARE') THEN
         individual_aware_ := value_;
      ELSIF (name_ = 'LEVEL_SEQ') THEN
         level_seq_ := value_;
      ELSIF (name_ = 'DOCUMENT_CATEGORY') THEN
         document_category_ := value_;
      ELSIF (name_ = 'SEQ_NO') THEN
         seq_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'TAG_NO') THEN
         tag_no_ := value_;
      ELSIF (name_ = 'PROJECT_ID') THEN
         project_id_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         newrec_.contract := value_;
      ELSIF (name_ = 'FUNCTION_NO') THEN
         function_no_ := value_;
      ELSIF (name_ = 'FUNCTION_DESC') THEN
         function_desc_ := value_;
      END IF;
   END LOOP;
--
   IF newrec_.sup_mch_code IS NOT NULL THEN
      Equipment_Object_API.Exist(newrec_.contract, newrec_.sup_mch_code);
   END IF;
--
   IF newrec_.part_no IS NOT NULL THEN
      IF Part_Catalog_API.Check_Part_Exists2(newrec_.part_no)=0 THEN
         IF Standard_Names_API.Get_Standard_Name_Id(std_name_)=0 THEN
--            Standard_Names_API.Create_Std_Name(std_name_);
              NULL;
         END IF;
         partrec_.std_name_id := Standard_Names_API.Get_Standard_Name_Id(std_name_);
         IF Iso_Unit_API.Check_Exist(partrec_.unit_code)='FALSE' THEN
            IF part_unit_code_description_ IS NULL THEN
               part_unit_code_description_ := partrec_.unit_code;
            END IF;
            Iso_Unit_API.Set_Unit(partrec_.unit_code, part_unit_code_description_, NULL, NULL, NULL);
         ELSE
            Iso_Unit_API.Activate_Code(partrec_.unit_code);
         END IF;
         Part_Catalog_API.Create_Part(newrec_.part_no, newrec_.mch_name, partrec_.unit_code, partrec_.std_name_id, partrec_.info_text);
      END IF;
      IF ( (Part_Serial_Catalog_API.Check_Exist(newrec_.part_no, newrec_.serial_no)= 'FALSE') AND (newrec_.serial_no IS NOT NULL)) THEN
         Create_Serial_Part__(attr_);
      END IF;
   END IF;
   IF newrec_.group_id IS NOT NULL THEN
      IF Equipment_Obj_Group_API.Check_Exist(newrec_.group_id)= 'FALSE' THEN
         IF Iso_Unit_API.Check_Exist(grouprec_.unit_code)= 'FALSE' THEN
            IF group_unit_code_description_ IS NULL THEN
               group_unit_code_description_ := grouprec_.unit_code;
            END IF;
            Iso_Unit_API.Set_Unit(grouprec_.unit_code, group_unit_code_description_, NULL, NULL, NULL);
         ELSE
            Iso_Unit_API.Activate_Code(grouprec_.unit_code);
         END IF;
         Equipment_Obj_Group_API.Create_Obj_Group(newrec_.group_id, grouprec_.description, grouprec_.unit_code, grouprec_.nom_runtime);
      END IF;
      Client_SYS.Add_To_Attr('GROUP_ID', newrec_.group_id, attr2_);
   END IF;
   Client_SYS.Add_To_Attr('MCH_POS', newrec_.mch_pos, attr2_);
   Client_SYS.Add_To_Attr('MCH_LOC', newrec_.mch_loc, attr2_);
   IF newrec_.mch_type IS NOT NULL THEN
      IF Equipment_Obj_Type_API.Check_Exist(newrec_.mch_type)= 'FALSE' THEN
         IF mch_type_description_ IS NULL THEN
            mch_type_description_ := newrec_.mch_type;
         END IF;
         IF Equipment_Obj_Type_API.Check_Exist(in_mch_type_)= 'FALSE' THEN
            Equipment_Obj_Type_API.Create_Obj_Type(newrec_.mch_type, mch_type_description_, NULL);
         ELSE
            Equipment_Obj_Type_API.Create_Obj_Type(newrec_.mch_type, mch_type_description_, in_mch_type_);
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('MCH_TYPE', newrec_.mch_type, attr2_);
   END IF;
   IF newrec_.type IS NOT NULL THEN
      IF Type_Designation_API.Check_Exist(newrec_.type)= 'FALSE' THEN
         IF type_design_description_ IS NULL THEN
            type_design_description_ := newrec_.type;
         END IF;
         Type_Designation_API.Create_Type_Designation(newrec_.type, type_design_description_, newrec_.mch_type);
      END IF;
      Client_SYS.Add_To_Attr('TYPE', newrec_.type, attr2_);
   END IF;
   IF newrec_.category_id IS NOT NULL THEN
      IF Equipment_Obj_Category_API.Check_Exist(newrec_.category_id)= 'FALSE' THEN
         IF category_description_ IS NULL THEN
            category_description_ := newrec_.category_id;
         END IF;
         Equipment_Obj_Category_API.Create_Category_id(newrec_.category_id, category_description_);
      END IF;
      Client_SYS.Add_To_Attr('CATEGORY_ID', newrec_.category_id, attr2_);
   END IF;
   Client_SYS.Add_To_Attr('PRODUCTION_DATE', newrec_.production_date, attr2_);
   IF EQUIPMENT_OBJECT_API.Do_Exist(newrec_.contract, newrec_.mch_code)= 'FALSE'  THEN
      IF source_ = 'EQUIP' THEN
         IF newrec_.obj_level IS NOT NULL THEN
            IF Equipment_Object_Level_API.Check_Exist(newrec_.obj_level)= 'FALSE' THEN
               Equipment_Object_Level_API.Create_Obj_Level(newrec_.obj_level, level_seq_, individual_aware_);
            END IF;
         END IF;
         Client_SYS.Add_To_Attr('NOTE', newrec_.note, attr2_);
         IF  (newrec_.obj_level IS NULL) THEN
            Client_SYS.Add_To_Attr('MCH_CODE', newrec_.mch_code, attr2_);
            --Client_SYS.Add_To_Attr('SUP_MCH_CODE', newrec_.sup_mch_code, attr2_);
            Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', newrec_.functional_object_seq, attr2_);
            Client_SYS.Add_To_Attr('PART_NO', newrec_.part_no, attr2_);
            Client_SYS.Add_To_Attr('SERIAL_NO', newrec_.serial_no, attr2_);
            EQUIPMENT_SERIAL_API.Create_Serial_Object(attr2_);
         ELSE
            Client_SYS.Add_To_Attr('MCH_CODE', newrec_.mch_code, attr2_);
            --Client_SYS.Add_To_Attr('SUP_MCH_CODE', newrec_.sup_mch_code, attr2_);
            Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', newrec_.functional_object_seq, attr2_);
            Client_SYS.Add_To_Attr('MCH_NAME', newrec_.mch_name, attr2_);
            Client_SYS.Add_To_Attr('EQUIPMENT_MAIN_POSITION', newrec_.equipment_main_position, attr2_);
            Client_SYS.Add_To_Attr('OBJ_LEVEL', newrec_.obj_level, attr2_);
            Client_SYS.Add_To_Attr('PURCH_DATE', newrec_.purch_date, attr2_);
            Client_SYS.Add_To_Attr('PURCH_PRICE', newrec_.purch_price, attr2_);
            Client_SYS.Add_To_Attr('WARR_EXP', newrec_.warr_exp, attr2_);
            Client_SYS.Add_To_Attr('MANUFACTURER_NO', newrec_.manufacturer_no, attr2_);
            Client_SYS.Add_To_Attr('VENDOR_NO', newrec_.vendor_no, attr2_);
            EQUIPMENT_FUNCTIONAL_API.Create_Object(attr2_);
         END IF;
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'OBJEXIST: Object :P1 already exist in facility. Transfer cancelled.', newrec_.mch_code);
   END IF;
END Create_Object;


PROCEDURE Connect_Object (
   connection_type_     IN VARCHAR2,
   connected_contract_  IN VARCHAR2,
   connected_object_id_ IN VARCHAR2,
   child_contract_      IN VARCHAR2,
   child_object_id_     IN VARCHAR2)
IS
BEGIN
      Equipment_Object_API.Exist(connected_contract_, connected_object_id_);
      Equipment_Object_API.Exist(child_contract_, child_object_id_);
      IF EQUIPMENT_OBJECT_CONN_API.Check_Exist(connected_contract_, connected_object_id_, child_contract_, child_object_id_, connection_type_)=1 THEN
         EQUIPMENT_OBJECT_CONN_API.Create_Connection(connected_contract_, connected_object_id_, child_contract_, child_object_id_, connection_type_);
      END IF;
END Connect_Object;


PROCEDURE Create_Spare_Part_List (
   object_id_       IN VARCHAR2,
   part_no_         IN VARCHAR2,
   spare_contract_  IN VARCHAR2,
   qty_             IN NUMBER,
   note_            IN VARCHAR2 )
IS
BEGIN
   IF EQUIPMENT_OBJECT_SPARE_API.Check_Exist(object_id_, spare_contract_, part_no_, spare_contract_)=0 THEN
      EQUIPMENT_OBJECT_SPARE_API.Create_Spare_Part(object_id_, part_no_, spare_contract_, qty_, note_, null, spare_contract_);
   END IF;
END Create_Spare_Part_List;


PROCEDURE Create_Connection_Type (
   connection_type_    IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
BEGIN

   IF EQUIPMENT_OBJ_CONN_TYPE_API.Check_Exist(connection_type_)=0 THEN
      EQUIPMENT_OBJ_CONN_TYPE_API.Create_Connection_Type(connection_type_, description_);
   END IF;
END  Create_Connection_Type;


PROCEDURE Remove_Object_Structure (
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2)
IS 
BEGIN
   Remove_Object_Structure(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Remove_Object_Structure;

PROCEDURE Remove_Object_Structure (
   equipment_object_seq_ IN NUMBER )
IS
   transaction_description_ VARCHAR2(2000);
   latest_transaction_  VARCHAR2(200);
   
   CURSOR getrec IS
      SELECT *
      FROM   EQUIPMENT_OBJECT_TAB
      CONNECT BY functional_object_seq = PRIOR equipment_object_seq
      START WITH functional_object_seq = equipment_object_seq_;
BEGIN
   FOR newrec IN getrec LOOP
      Equipment_object_API.Remove_Object_Structure(newrec.contract, newrec.mch_code);
      IF (Part_Serial_Catalog_API.Check_Exist(newrec.part_no, newrec.mch_serial_no) = 'TRUE' AND newrec.obj_level IS NULL ) THEN
         latest_transaction_:= Language_SYS.Translate_Constant(lu_name_, 'REMOVSTRCURR: Under Design,' );
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'REMOVSTRTRNS: Moved from :P1 at :P2 to design', newrec.mch_code, newrec.contract );
         Part_Serial_Catalog_API.Move_To_Issued (newrec.part_no, newrec.mch_serial_no, latest_transaction_, transaction_description_, 'OUT_OF_OPERATION');
      END IF;
   END LOOP;
END Remove_Object_Structure;


FUNCTION Check_Exist_In_Structure(
   sup_contract_ IN VARCHAR2,
   sup_mch_code_ IN VARCHAR2,
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2) RETURN VARCHAR2
IS

BEGIN
   RETURN Check_Exist_In_Structure(Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_),Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_));
END Check_Exist_In_Structure;

FUNCTION Check_Exist_In_Structure(
   functional_object_seq_ IN NUMBER,
   equipment_object_seq_  IN NUMBER) RETURN VARCHAR2
IS
dummy_   NUMBER;

CURSOR getrec IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_TAB
   WHERE equipment_object_seq = equipment_object_seq_
   CONNECT BY functional_object_seq = PRIOR equipment_object_seq
   START WITH   equipment_object_seq = functional_object_seq_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%FOUND) THEN
      CLOSE getrec;
      RETURN 'TRUE';
   ELSE
      CLOSE getrec;
      RETURN 'FALSE';
   END IF;
END Check_Exist_In_Structure;