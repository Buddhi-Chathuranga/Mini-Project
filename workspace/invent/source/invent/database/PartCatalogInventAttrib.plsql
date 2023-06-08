-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalogInventAttrib
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180629  ShPrlk  Bug 142280, Modified Update___ to convert storage_volume_requirement value to the correct UOM that is passed from 
--  150828  UdGnlk  LIM-3593, Modified Check_Insert___() to assign database values to cold_sensitive and marine_pollutant columns.  
--  120904  JeLise  Moved STORAGE_WIDTH_REQUIREMENT, STORAGE_HEIGHT_REQUIREMENT, STORAGE_DEPTH_REQUIREMENT, 
--  120904          STORAGE_VOLUME_REQUIREMENT, STORAGE_WEIGHT_REQUIREMENT, MIN_STORAGE_TEMPERATURE, MAX_STORAGE_TEMPERATURE, 
--  120904          MIN_STORAGE_HUMIDITY, MAX_STORAGE_HUMIDITY, UOM_FOR_LENGTH, UOM_FOR_VOLUME, UOM_FOR_WEIGHT, UOM_FOR_TEMPERATURE 
--  120904          and all methods connected to them from Part_Catalog_API.
--  120208  HaPulk  Removed unused CONSTANTS and make dynamic calls to INVENT as static
--  120130  MaEelk  Corrected view comments of IMDG_SUBSIDIARY_RISK_1_ID, IMDG_SUBSIDIARY_RISK_2_ID, ADR_SUBSIDIARY_RISK_1_ID, ADR_SUBSIDIARY_RISK_2_ID,
--  120130          IATA_SUBSIDIARY_RISK_1_ID and IATA_SUBSIDIARY_RISK_2_ID
--  110731  Dobese  Changed chemmate receiver to HSE receiver
--  100505  KRPELK  Merge Rose Method Documentation.
--  091207  PraWlk  Bug 87023, Modified Delete___(), Insert___() and Update___() to check the availability
--  091207          of message reciever CHEMMATE before inserting, updating or deleting a record. 
--  090929  KiSalk  Called Partca_Dangerous_Substance_API.Copy in Copy method.
--  090604  KiSalk  Added Copy_From_Template, and modified Copy using newlly added method Set_Attributes___.
--  090528  KiSalk  Added attributes proper_shipping_name_id, packaging_group_id, tunnel_code, packaging_material_id, 
--  090528          additional_ship_desc_id, modified_date, note_id, imdg_special_provision, adr_special_provision, template_part, 
--  090528          iata_special_provision, n_o_s, adr_environmental_hazard, iata_environmental_hazard, segregation_code, imdg_comment_id,
--  090528          imdg_class_id, imdg_limited_quantity, adr_comment_id, imdg_subsidiary_risk_1_id, imdg_subsidiary_risk_2_id, 
--  090528          adr_limited_quantity, iata_limited_quantity, iata_comment_id, adr_subsidiary_risk_1_id, adr_rid_class_id, 
--  090528          adr_subsidiary_risk_2_id, iata_subsidiary_risk_2_id, iata_subsidiary_risk_1_id and, iata_dgr_class_id.
--  ----------------------------- MF022 Paint & Inc Extension End ----------
--  090522  JoAnSe  Corrected check for Pack_And_Post_Message in Update___
--  ----------------------------- MF022 Paint & Inc Extension Begin ---------
--  041211  JaBalk  Added copy method.
--  040315  RoJalk  Bug 42813, Changed the UN_NO from NUMBER to VARCHAR2(4).
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  040211  Dobese  Bug 42697 - Added check if inv part exist before sending delete message.
--  030930  Dobese  Added delete message when removing hse_contract.
--  030623  Dobese  Modified Chemmate check in procedure Update.
--  020603  HECESE  Bug 27861. Removed check for hse_contract with null value in Update___.
--  010504  JSAnse  Changed 'YYYYYYYYYY' to 'XXXXXXXXXX' in right hand side of
--                  the if-statement in procedure Update.
--  001103  JOHESE  Added calls to Inventory_Part_API.Pack_And_Post_Message__
--  001031  JOHESE  Renamed column contract to hse_contract
--  001027  JOHESE  Added column contract
--  001026  JOHESE  Removed column transfer_to_hse_system
--  001020  JOHESE  Added column transfer_to_hse_system
--  000925  JOHESE  Added undefines.
--  990413  ANHO  Upgraded to performance optimized template.
--  980323  FRDI  SID 756: Improvmeny of layout, adding marine pollutant checkbox
--  980210  LEPE  Changed the cold sensitive attribute validate against an IID LU
--                called PartColdSensitive.
--  980203  FRDI  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                  CONSTANT VARCHAR2(15) := Database_SYS.string_null_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Set_Attributes___
--   Set some of the Attributes from copy_rec_ to parameter attr_.
PROCEDURE Set_Attributes___ (
   attr_     IN OUT VARCHAR2,
   copy_rec_ IN     PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE )
IS
BEGIN
   Client_SYS.Add_To_Attr('UN_NO',                        copy_rec_.un_no,                      attr_);
   Client_SYS.Add_To_Attr('FLASH_POINT',                  copy_rec_.flash_point,                attr_);
   Client_SYS.Add_To_Attr('COLD_SENSITIVE_DB',            copy_rec_.cold_sensitive,             attr_);
   Client_SYS.Add_To_Attr('EM_S_NO',                      copy_rec_.em_s_no,                    attr_);
   Client_SYS.Add_To_Attr('MARINE_POLLUTANT_DB',          copy_rec_.marine_pollutant,           attr_);
   Client_SYS.Add_To_Attr('ITEM_NO',                      copy_rec_.item_no,                    attr_);
   Client_SYS.Add_To_Attr('HSE_CONTRACT',                 copy_rec_.hse_contract,               attr_);
   Client_SYS.Add_To_Attr('PROPER_SHIPPING_NAME_ID',      copy_rec_.proper_shipping_name_id,    attr_);
   Client_SYS.Add_To_Attr('PACKAGING_GROUP_ID',           copy_rec_.packaging_group_id,         attr_);
   Client_SYS.Add_To_Attr('TUNNEL_CODE',                  copy_rec_.tunnel_code,                attr_);
   Client_SYS.Add_To_Attr('PACKAGING_MATERIAL_ID',        copy_rec_.packaging_material_id,      attr_);
   Client_SYS.Add_To_Attr('ADDITIONAL_SHIP_DESC_ID',      copy_rec_.additional_ship_desc_id,    attr_);
   Client_SYS.Add_To_Attr('IMDG_SPECIAL_PROVISION',       copy_rec_.imdg_special_provision,     attr_);
   Client_SYS.Add_To_Attr('ADR_SPECIAL_PROVISION',        copy_rec_.adr_special_provision,      attr_);
   Client_SYS.Add_To_Attr('IATA_SPECIAL_PROVISION',       copy_rec_.iata_special_provision,     attr_);
   Client_SYS.Add_To_Attr('N_O_S_DB',                     copy_rec_.n_o_s,                      attr_);
   Client_SYS.Add_To_Attr('ADR_ENVIRONMENTAL_HAZARD_DB',  copy_rec_.adr_environmental_hazard,   attr_);
   Client_SYS.Add_To_Attr('IATA_ENVIRONMENTAL_HAZARD_DB', copy_rec_.iata_environmental_hazard,  attr_);
   Client_SYS.Add_To_Attr('IMDG_COMMENT_ID',              copy_rec_.imdg_comment_id,            attr_);
   Client_SYS.Add_To_Attr('IMDG_CLASS_ID',                copy_rec_.imdg_class_id,              attr_);
   Client_SYS.Add_To_Attr('IMDG_LIMITED_QUANTITY',        copy_rec_.imdg_limited_quantity,      attr_);
   Client_SYS.Add_To_Attr('ADR_COMMENT_ID',               copy_rec_.adr_comment_id,             attr_);
   Client_SYS.Add_To_Attr('IMDG_SUBSIDIARY_RISK_1_ID',    copy_rec_.imdg_subsidiary_risk_1_id,  attr_);
   Client_SYS.Add_To_Attr('IMDG_SUBSIDIARY_RISK_2_ID',    copy_rec_.imdg_subsidiary_risk_2_id,  attr_);
   Client_SYS.Add_To_Attr('ADR_LIMITED_QUANTITY',         copy_rec_.adr_limited_quantity,       attr_);
   Client_SYS.Add_To_Attr('IATA_LIMITED_QUANTITY',        copy_rec_.iata_limited_quantity,      attr_);
   Client_SYS.Add_To_Attr('IATA_COMMENT_ID',              copy_rec_.iata_comment_id,            attr_);
   Client_SYS.Add_To_Attr('ADR_SUBSIDIARY_RISK_1_ID',     copy_rec_.adr_subsidiary_risk_1_id,   attr_);
   Client_SYS.Add_To_Attr('ADR_RID_CLASS_ID',             copy_rec_.adr_rid_class_id,           attr_);
   Client_SYS.Add_To_Attr('ADR_SUBSIDIARY_RISK_2_ID',     copy_rec_.adr_subsidiary_risk_2_id,   attr_);
   Client_SYS.Add_To_Attr('IATA_SUBSIDIARY_RISK_2_ID',    copy_rec_.iata_subsidiary_risk_2_id,  attr_);
   Client_SYS.Add_To_Attr('IATA_SUBSIDIARY_RISK_1_ID',    copy_rec_.iata_subsidiary_risk_1_id,  attr_);
   Client_SYS.Add_To_Attr('IATA_DGR_CLASS_ID',            copy_rec_.iata_dgr_class_id,          attr_);
   Client_SYS.Add_To_Attr('SEGREGATION_CODE',             copy_rec_.segregation_code,           attr_);
   Client_SYS.Add_To_Attr('STORAGE_WIDTH_REQUIREMENT',    copy_rec_.storage_width_requirement,  attr_);
   Client_SYS.Add_To_Attr('STORAGE_HEIGHT_REQUIREMENT',   copy_rec_.storage_height_requirement, attr_);
   Client_SYS.Add_To_Attr('STORAGE_DEPTH_REQUIREMENT',    copy_rec_.storage_depth_requirement,  attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_LENGTH',               copy_rec_.uom_for_length,             attr_);
   Client_SYS.Add_To_Attr('STORAGE_VOLUME_REQUIREMENT',   copy_rec_.storage_volume_requirement, attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_VOLUME',               copy_rec_.uom_for_volume,             attr_);
   Client_SYS.Add_To_Attr('STORAGE_WEIGHT_REQUIREMENT',   copy_rec_.storage_weight_requirement, attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_WEIGHT',               copy_rec_.uom_for_weight,             attr_);
   Client_SYS.Add_To_Attr('MIN_STORAGE_TEMPERATURE',      copy_rec_.min_storage_temperature,    attr_);
   Client_SYS.Add_To_Attr('MAX_STORAGE_TEMPERATURE',      copy_rec_.max_storage_temperature,    attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_TEMPERATURE',          copy_rec_.uom_for_temperature,        attr_);
   Client_SYS.Add_To_Attr('MIN_STORAGE_HUMIDITY',         copy_rec_.min_storage_humidity,       attr_);
   Client_SYS.Add_To_Attr('MAX_STORAGE_HUMIDITY',         copy_rec_.max_storage_humidity,       attr_);
   Client_SYS.Add_To_Attr('CAPACITY_REQ_GROUP_ID',        copy_rec_.capacity_req_group_id,      attr_);
   Client_SYS.Add_To_Attr('CONDITION_REQ_GROUP_ID',       copy_rec_.condition_req_group_id,     attr_);
   Client_SYS.Add_To_Attr('CAPABILITY_REQ_GROUP_ID',      copy_rec_.capability_req_group_id,    attr_);

END Set_Attributes___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COLD_SENSITIVE', Part_Cold_Sensitive_API.Decode('NOT COLD SENSITIVE'), attr_);
   Client_SYS.Add_To_Attr('MARINE_POLLUTANT', Part_Marine_Pollutant_API.Decode('NOT MARINE POLLUTANT'), attr_);   
   Client_SYS.Add_To_Attr('ADR_ENVIRONMENTAL_HAZARD_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('IATA_ENVIRONMENTAL_HAZARD_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('N_O_S_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_PART_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   newrec_.note_id       := Document_Text_API.Get_Next_Note_Id;
   newrec_.modified_date := TRUNC(SYSDATE);

   IF (newrec_.storage_volume_requirement IS NOT NULL AND newrec_.uom_for_volume IS NULL) THEN
      newrec_.uom_for_volume := Company_Invent_Info_API.Get_Uom_For_Volume(User_Finance_API.Get_Default_Company_Func);
   END IF;

   IF newrec_.storage_volume_requirement IS NOT NULL THEN
      IF newrec_.uom_for_length IS NULL THEN
         newrec_.uom_for_length := RTRIM(newrec_.uom_for_volume, '3');
      END IF;
      newrec_.storage_width_requirement  := NVL(newrec_.storage_width_requirement, 0);
      newrec_.storage_height_requirement := NVL(newrec_.storage_height_requirement, 0);
      newrec_.storage_depth_requirement  := NVL(newrec_.storage_depth_requirement, 0);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   -- Update Chemmate
   IF (Message_Receiver_API.Check_Exist_String('HSE') ='TRUE') THEN
      IF (Inventory_Part_API.Check_Exist(newrec_.hse_contract, newrec_.part_no)) THEN
         Inventory_Part_API.Pack_And_Post_Message__('ADDEDIT', newrec_.part_no);
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   
   -- These checks needs to be performed after storing the record
   -- because they are using the method for fetching the operative
   -- values which read the database.
   Check_Temperature_Range(newrec_.part_no);
   Check_Humidity_Range(newrec_.part_no);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE,
   newrec_     IN OUT PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
   default_company_volume_uom_ PART_CATALOG_INVENT_ATTRIB_TAB.UOM_FOR_VOLUME%TYPE;
BEGIN
   newrec_.modified_date := TRUNC(SYSDATE);

   IF (newrec_.storage_volume_requirement IS NOT NULL) THEN
      default_company_volume_uom_ := Company_Invent_Info_API.Get_Uom_For_Volume(User_Finance_API.Get_Default_Company_Func);         

      -- conversion to the user's default company volume uom from the uom that was fetched during definition of storage volume requirements.
      IF (newrec_.uom_for_volume IS NOT NULL ) THEN 
         IF (newrec_.uom_for_volume != default_company_volume_uom_) THEN
            newrec_.storage_volume_requirement := Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.storage_volume_requirement,
                                                                                           newrec_.uom_for_volume,
                                                                                           default_company_volume_uom_);
         END IF;
      END IF; 

      -- Assigning default company's volume uom as part catalog is site and companyless.
      newrec_.uom_for_volume := default_company_volume_uom_; 
      
      IF Storage_Capacity_Req_Group_API.Get_Uom_For_Length(newrec_.capacity_req_group_id) IS NULL AND
         newrec_.uom_for_length IS NULL THEN
         newrec_.uom_for_length := RTRIM(newrec_.uom_for_volume, '3');
      END IF;
      IF Storage_Capacity_Req_Group_API.Get_Width(newrec_.capacity_req_group_id) IS NULL AND
         newrec_.storage_width_requirement IS NULL THEN
         newrec_.storage_width_requirement := 0;
      END IF;
      IF Storage_Capacity_Req_Group_API.Get_Height(newrec_.capacity_req_group_id) IS NULL AND
         newrec_.storage_height_requirement IS NULL THEN
         newrec_.storage_height_requirement := 0;
      END IF;
      IF Storage_Capacity_Req_Group_API.Get_Depth(newrec_.capacity_req_group_id) IS NULL AND
         newrec_.storage_depth_requirement IS NULL THEN
         newrec_.storage_depth_requirement := 0;
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Update Chemmate
   IF (Message_Receiver_API.Check_Exist_String('HSE') ='TRUE') THEN
      IF (newrec_.hse_contract IS NOT NULL) THEN
         IF (Inventory_Part_API.Check_Exist(newrec_.hse_contract, newrec_.part_no)) THEN
            Inventory_Part_API.Pack_And_Post_Message__('ADDEDIT', newrec_.part_no);
         END IF;
      ELSIF (newrec_.hse_contract IS NULL) AND (oldrec_.hse_contract IS NOT NULL) THEN
         IF (Inventory_Part_API.Check_Exist(newrec_.hse_contract, newrec_.part_no)) THEN
            Inventory_Part_API.Pack_And_Post_Message__('DELETE', newrec_.part_no);
         END IF;
      END IF;
   ELSIF (newrec_.hse_contract IS NULL) AND (oldrec_.hse_contract IS NOT NULL) THEN
      -- MF022 replaced newrec_.hse_contract with oldrec_.hse_contract
      IF (Inventory_Part_API.Check_Exist(oldrec_.hse_contract, newrec_.part_no)) THEN
         Inventory_Part_API.Pack_And_Post_Message__('DELETE', newrec_.part_no);
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);

   IF ((NVL(newrec_.min_storage_temperature, number_null_) != NVL(oldrec_.min_storage_temperature, number_null_)) OR
       (NVL(newrec_.max_storage_temperature, number_null_) != NVL(oldrec_.max_storage_temperature, number_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Storage_Temperature and Get_Max_Storage_Temperature which reads the database.
      Check_Temperature_Range(newrec_.part_no);
   END IF;

   IF ((NVL(newrec_.min_storage_humidity, number_null_) != NVL(oldrec_.min_storage_humidity, number_null_)) OR
       (NVL(newrec_.max_storage_humidity, number_null_) != NVL(oldrec_.max_storage_humidity, number_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Storage_Humidity and Get_Max_Storage_Humidity which reads the database.
      Check_Humidity_Range(newrec_.part_no);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   -- Update Chemmate
   IF (Message_Receiver_API.Check_Exist_String('HSE') ='TRUE') THEN
      Inventory_Part_API.Pack_And_Post_Message__('DELETE', remrec_.part_no);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_catalog_invent_attrib_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
   ndummy_ INTEGER;
BEGIN
   IF NOT (indrec_.cold_sensitive) THEN 
      newrec_.cold_sensitive            := 'NOT COLD SENSITIVE';
   END IF;
   IF NOT (indrec_.marine_pollutant) THEN 
      newrec_.marine_pollutant          := 'NOT MARINE POLLUTANT';
   END IF;
   IF NOT (indrec_.adr_environmental_hazard) THEN 
      newrec_.adr_environmental_hazard  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.iata_environmental_hazard) THEN 
      newrec_.iata_environmental_hazard := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.n_o_s) THEN 
      newrec_.n_o_s                     := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.template_part) THEN 
      newrec_.template_part             := Fnd_Boolean_API.db_false;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   IF(newrec_.hse_contract IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.hse_contract);
   END IF;
   
   IF (newrec_.un_no IS NOT NULL) THEN
      name_   := 'UN_NO';
      value_  := newrec_.un_no;
      ndummy_ := TO_NUMBER(newrec_.un_no);
      IF (LENGTH(ndummy_) < 4) THEN
         IF ((SUBSTR(newrec_.un_no,1,1) != '0') AND (LENGTH(ndummy_) = 3) OR
            (SUBSTR(newrec_.un_no,1,2) != '00') AND (LENGTH(ndummy_) = 2) OR
            (SUBSTR(newrec_.un_no,1,3) != '000') AND (LENGTH(ndummy_) = 1) OR
            (LENGTH(newrec_.un_no) < 4)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDUN: UN Number :P1 must be a four digit integer value.', newrec_.un_no);
         END IF;
      END IF;
   END IF;
   
   -- Check capacities and conditions
   Check_Cubic_Capacity(newrec_.storage_width_requirement);
   Check_Cubic_Capacity(newrec_.storage_height_requirement);
   Check_Cubic_Capacity(newrec_.storage_depth_requirement);
   Check_Carrying_Capacity(newrec_.storage_weight_requirement);
   Check_Humidity(newrec_.min_storage_humidity);
   Check_Humidity(newrec_.max_storage_humidity);
   Check_Storage_Capacity_Uom(newrec_.storage_width_requirement, newrec_.storage_height_requirement, newrec_.storage_depth_requirement, newrec_.uom_for_length,
                              newrec_.storage_weight_requirement, newrec_.uom_for_weight);
   Check_Temperature_Uom(newrec_.min_storage_temperature, newrec_.max_storage_temperature, newrec_.uom_for_temperature);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_catalog_invent_attrib_tab%ROWTYPE,
   newrec_ IN OUT part_catalog_invent_attrib_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   ndummy_               INTEGER;
   number_null_          NUMBER := -9999999;
   group_uom_for_length_ PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_length%TYPE;
   group_uom_for_weight_ PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_weight%TYPE;
   group_uom_for_temp_   PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_temperature%TYPE;
   uom_for_length_       PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_length%TYPE;
   uom_for_temperature_  PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_temperature%TYPE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF(newrec_.hse_contract IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.hse_contract);
   END IF;
   
   IF (newrec_.un_no IS NOT NULL) THEN
      name_   := 'UN_NO';
      value_  := newrec_.un_no;
      ndummy_ := TO_NUMBER(newrec_.un_no);
      IF (LENGTH(ndummy_) < 4) THEN
         IF ((SUBSTR(newrec_.un_no,1,1) != '0') AND (LENGTH(ndummy_) = 3) OR
            (SUBSTR(newrec_.un_no,1,2) != '00') AND (LENGTH(ndummy_) = 2) OR
            (SUBSTR(newrec_.un_no,1,3) != '000') AND (LENGTH(ndummy_) = 1) OR
            (LENGTH(newrec_.un_no) < 4)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDUN: UN Number :P1 must be a four digit integer value.', newrec_.un_no);
         END IF;
      END IF;
   END IF;
   
   -- Check Capacities and Conditions
   IF (NVL(newrec_.storage_width_requirement, number_null_) != NVL(oldrec_.storage_width_requirement, number_null_)) THEN
      Check_Cubic_Capacity(newrec_.storage_width_requirement);
   END IF;
   IF (NVL(newrec_.storage_height_requirement, number_null_) != NVL(oldrec_.storage_height_requirement, number_null_)) THEN
      Check_Cubic_Capacity(newrec_.storage_height_requirement);
   END IF;
   IF (NVL(newrec_.storage_depth_requirement,  number_null_) != NVL(oldrec_.storage_depth_requirement, number_null_)) THEN
      Check_Cubic_Capacity(newrec_.storage_depth_requirement);
   END IF;
   IF (NVL(newrec_.storage_weight_requirement, number_null_) != NVL(oldrec_.storage_weight_requirement, number_null_)) THEN
      Check_Carrying_Capacity(newrec_.storage_weight_requirement);
   END IF;
   IF (NVL(newrec_.min_storage_humidity, number_null_) != NVL(oldrec_.min_storage_humidity, number_null_)) THEN
      Check_Humidity(newrec_.min_storage_humidity);
   END IF;
   IF (NVL(newrec_.max_storage_humidity, number_null_) != NVL(oldrec_.max_storage_humidity, number_null_)) THEN
      Check_Humidity(newrec_.max_storage_humidity);
   END IF;

   -- IF all length values are set to null the UoM for length should also be null
   IF (newrec_.storage_width_requirement IS NULL AND newrec_.storage_height_requirement IS NULL AND newrec_.storage_depth_requirement IS NULL) THEN
      newrec_.uom_for_length := NULL;
   END IF;
   IF newrec_.storage_weight_requirement IS NULL THEN
      newrec_.uom_for_weight := NULL;
   END IF;
   IF (newrec_.min_storage_temperature IS NULL AND newrec_.max_storage_temperature IS NULL) THEN
      newrec_.uom_for_temperature := NULL;
   END IF;

   IF ((NVL(newrec_.storage_width_requirement, number_null_) != NVL(oldrec_.storage_width_requirement, number_null_)) OR
      (NVL(newrec_.storage_height_requirement, number_null_) != NVL(oldrec_.storage_height_requirement, number_null_)) OR
      (NVL(newrec_.storage_depth_requirement, number_null_)  != NVL(oldrec_.storage_depth_requirement, number_null_)) OR
      (NVL(newrec_.uom_for_length, string_null_)             != NVL(oldrec_.uom_for_length, string_null_)) OR
      (NVL(newrec_.storage_weight_requirement, number_null_) != NVL(oldrec_.storage_weight_requirement, number_null_)) OR
      (NVL(newrec_.uom_for_weight, string_null_)             != NVL(oldrec_.uom_for_weight, string_null_))) THEN
      Check_Storage_Capacity_Uom(newrec_.storage_width_requirement, newrec_.storage_height_requirement, newrec_.storage_depth_requirement, newrec_.uom_for_length,
                                 newrec_.storage_weight_requirement, newrec_.uom_for_weight);
   END IF;

   IF ((NVL(newrec_.min_storage_temperature, number_null_) != NVL(oldrec_.min_storage_temperature, number_null_)) OR
      (NVL(newrec_.max_storage_temperature, number_null_)  != NVL(oldrec_.max_storage_temperature, number_null_)) OR
      (NVL(newrec_.uom_for_temperature, string_null_)      != NVL(oldrec_.uom_for_temperature, string_null_))) THEN
      Check_Temperature_Uom(newrec_.min_storage_temperature, newrec_.max_storage_temperature, newrec_.uom_for_temperature);
   END IF;

   -- IF Capacities have been added earlier and a Capacity Requirement Group is being added or changed,
   -- and the UoM are not the same. Then the UoM from the Group should be used and the values have to be converted.
   IF (newrec_.capacity_req_group_id IS NOT NULL AND
      (newrec_.capacity_req_group_id != NVL(oldrec_.capacity_req_group_id, string_null_))) THEN
      group_uom_for_length_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Length(newrec_.capacity_req_group_id);
      IF (group_uom_for_length_ != NVL(newrec_.uom_for_length, string_null_)) THEN
         uom_for_length_ := newrec_.uom_for_length;
         IF newrec_.storage_width_requirement IS NOT NULL THEN
            newrec_.storage_width_requirement := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.storage_width_requirement,
                                                                                                uom_for_length_,
                                                                                                group_uom_for_length_), 4);
            newrec_.uom_for_length := group_uom_for_length_;
         END IF;
         IF newrec_.storage_height_requirement IS NOT NULL THEN
            newrec_.storage_height_requirement := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.storage_height_requirement,
                                                                                                 uom_for_length_,
                                                                                                 group_uom_for_length_), 4);
            newrec_.uom_for_length := group_uom_for_length_;
         END IF;
         IF newrec_.storage_depth_requirement IS NOT NULL THEN
            newrec_.storage_depth_requirement := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.storage_depth_requirement,
                                                                                                uom_for_length_,
                                                                                                group_uom_for_length_), 4);
            newrec_.uom_for_length := group_uom_for_length_;
         END IF;
      END IF;

      group_uom_for_weight_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Weight(newrec_.capacity_req_group_id);
      IF (group_uom_for_weight_ != NVL(newrec_.uom_for_weight, string_null_)) THEN
         IF newrec_.storage_weight_requirement IS NOT NULL THEN
            newrec_.storage_weight_requirement := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.storage_weight_requirement,
                                                                                                 newrec_.uom_for_weight,
                                                                                                 group_uom_for_weight_), 4);
            newrec_.uom_for_weight := group_uom_for_weight_;
         END IF;
      END IF;
   END IF;

   -- IF Conditions have been added earlier and a Condition Requirement Group is being added or changed,
   -- and the UoM are not the same. Then the UoM from the Group should be used and the values have to be converted.
   IF (newrec_.condition_req_group_id IS NOT NULL AND
      (newrec_.condition_req_group_id != NVL(oldrec_.condition_req_group_id, string_null_))) THEN
      group_uom_for_temp_ := Storage_Cond_Req_Group_API.Get_Uom_For_Temperature(newrec_.condition_req_group_id);
      IF (group_uom_for_temp_ != NVL(newrec_.uom_for_temperature, string_null_)) THEN
         uom_for_temperature_ := newrec_.uom_for_temperature;
         IF newrec_.min_storage_temperature IS NOT NULL THEN
            newrec_.min_storage_temperature := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.min_storage_temperature,
                                                                                              uom_for_temperature_,
                                                                                              group_uom_for_temp_), 4);
            newrec_.uom_for_temperature := group_uom_for_temp_;
         END IF;
         IF newrec_.max_storage_temperature IS NOT NULL THEN
            newrec_.max_storage_temperature := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(newrec_.max_storage_temperature,
                                                                                              uom_for_temperature_,
                                                                                              group_uom_for_temp_), 4);
            newrec_.uom_for_temperature := group_uom_for_temp_;
         END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Storage_Width_Requirement (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_width_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_width_requirement%TYPE;
   capacity_req_group_id_     PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT storage_width_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_width_requirement_, capacity_req_group_id_;
   CLOSE get_attr;
   
   IF storage_width_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         storage_width_requirement_ := Storage_Capacity_Req_Group_API.Get_Width(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN storage_width_requirement_;
END Get_Storage_Width_Requirement;


@UncheckedAccess
FUNCTION Get_Storage_Height_Requirement (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_height_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_height_requirement%TYPE;
   capacity_req_group_id_      PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT storage_height_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_height_requirement_, capacity_req_group_id_;
   CLOSE get_attr;
   
   IF storage_height_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         storage_height_requirement_ := Storage_Capacity_Req_Group_API.Get_Height(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN storage_height_requirement_;
END Get_Storage_Height_Requirement;


@UncheckedAccess
FUNCTION Get_Storage_Depth_Requirement (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_depth_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_depth_requirement%TYPE;
   capacity_req_group_id_     PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT storage_depth_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_depth_requirement_, capacity_req_group_id_;
   CLOSE get_attr;

   IF storage_depth_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         storage_depth_requirement_ := Storage_Capacity_Req_Group_API.Get_Depth(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN storage_depth_requirement_;
END Get_Storage_Depth_Requirement;


@UncheckedAccess
FUNCTION Get_Uom_For_Length (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   uom_for_length_        PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_length%TYPE;
   capacity_req_group_id_ PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT capacity_req_group_id, uom_for_length
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO capacity_req_group_id_, uom_for_length_;
   CLOSE get_attr;

   IF uom_for_length_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         uom_for_length_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Length(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN uom_for_length_;
END Get_Uom_For_Length;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Requirement (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_volume_requirement%TYPE;
   capacity_req_group_id_      PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   
   CURSOR get_attr IS
      SELECT storage_volume_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_volume_requirement_, capacity_req_group_id_;
   CLOSE get_attr;

   IF storage_volume_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         storage_volume_requirement_ := Storage_Capacity_Req_Group_API.Get_Volume(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN storage_volume_requirement_;
END Get_Storage_Volume_Requirement;


@UncheckedAccess
FUNCTION Get_Uom_For_Volume (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   uom_for_volume_             PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_volume%TYPE;
   storage_volume_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_volume_requirement%TYPE;
   capacity_req_group_id_      PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT storage_volume_requirement, capacity_req_group_id, uom_for_volume
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_volume_requirement_, capacity_req_group_id_, uom_for_volume_;
   CLOSE get_attr;

   IF storage_volume_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         uom_for_volume_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Volume(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN uom_for_volume_;
END Get_Uom_For_Volume;


@UncheckedAccess
FUNCTION Get_Storage_Weight_Requirement (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_weight_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_weight_requirement%TYPE;
   capacity_req_group_id_      PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT storage_weight_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_weight_requirement_, capacity_req_group_id_;
   CLOSE get_attr;

   IF storage_weight_requirement_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         storage_weight_requirement_ := Storage_Capacity_Req_Group_API.Get_Weight(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN storage_weight_requirement_;
END Get_Storage_Weight_Requirement;


@UncheckedAccess
FUNCTION Get_Uom_For_Weight (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   uom_for_weight_        PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_weight%TYPE;
   capacity_req_group_id_ PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT capacity_req_group_id, uom_for_weight
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO capacity_req_group_id_, uom_for_weight_;
   CLOSE get_attr;

   IF uom_for_weight_ IS NULL THEN
      IF capacity_req_group_id_ IS NOT NULL THEN
         uom_for_weight_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Weight(capacity_req_group_id_);
      END IF;
   END IF;
   RETURN uom_for_weight_;
END Get_Uom_For_Weight;


@UncheckedAccess
FUNCTION Get_Min_Storage_Temperature (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   min_storage_temperature_ PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_temperature%TYPE;
   condition_req_group_id_  PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT min_storage_temperature, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO min_storage_temperature_, condition_req_group_id_;
   CLOSE get_attr;
   
   IF min_storage_temperature_ IS NULL THEN
      IF condition_req_group_id_ IS NOT NULL THEN
         min_storage_temperature_ := Storage_Cond_Req_Group_API.Get_Min_Temperature(condition_req_group_id_);
      END IF;
   END IF;
   RETURN min_storage_temperature_;
END Get_Min_Storage_Temperature;


@UncheckedAccess
FUNCTION Get_Max_Storage_Temperature (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   max_storage_temperature_ PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_temperature%TYPE;
   condition_req_group_id_  PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   
   CURSOR get_attr IS
      SELECT max_storage_temperature, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO max_storage_temperature_, condition_req_group_id_;
   CLOSE get_attr;
   
   IF max_storage_temperature_ IS NULL THEN
      IF condition_req_group_id_ IS NOT NULL THEN
         max_storage_temperature_ := Storage_Cond_Req_Group_API.Get_Max_Temperature(condition_req_group_id_);
      END IF;
   END IF;
   RETURN max_storage_temperature_;
END Get_Max_Storage_Temperature;


@UncheckedAccess
FUNCTION Get_Uom_For_Temperature (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   uom_for_temperature_    PART_CATALOG_INVENT_ATTRIB_TAB.uom_for_temperature%TYPE;
   condition_req_group_id_ PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;

   CURSOR get_attr IS
      SELECT condition_req_group_id, uom_for_temperature
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO condition_req_group_id_, uom_for_temperature_;
   CLOSE get_attr;

   IF uom_for_temperature_ IS NULL THEN
      IF condition_req_group_id_ IS NOT NULL THEN
         uom_for_temperature_ := Storage_Cond_Req_Group_API.Get_Uom_For_Temperature(condition_req_group_id_);
      END IF;
   END IF;
   RETURN uom_for_temperature_;
END Get_Uom_For_Temperature;


@UncheckedAccess
FUNCTION Get_Min_Storage_Humidity (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   min_storage_humidity_   PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_humidity%TYPE;
   condition_req_group_id_ PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   
   CURSOR get_attr IS
      SELECT min_storage_humidity, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO min_storage_humidity_, condition_req_group_id_;
   CLOSE get_attr;
   
   IF min_storage_humidity_ IS NULL THEN
      IF condition_req_group_id_ IS NOT NULL THEN
         min_storage_humidity_ := Storage_Cond_Req_Group_API.Get_Min_Humidity(condition_req_group_id_);
      END IF;
   END IF;
   RETURN min_storage_humidity_;
END Get_Min_Storage_Humidity;


@UncheckedAccess
FUNCTION Get_Max_Storage_Humidity (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   max_storage_humidity_   PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_humidity%TYPE;
   condition_req_group_id_ PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   
   CURSOR get_attr IS
      SELECT max_storage_humidity, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO max_storage_humidity_, condition_req_group_id_;
   CLOSE get_attr;
   
   IF max_storage_humidity_ IS NULL THEN
      IF condition_req_group_id_ IS NOT NULL THEN
         max_storage_humidity_ := Storage_Cond_Req_Group_API.Get_Max_Humidity(condition_req_group_id_);
      END IF;
   END IF;
   RETURN max_storage_humidity_;
END Get_Max_Storage_Humidity;


PROCEDURE Check_Humidity (
   humidity_ IN NUMBER )
IS
BEGIN

   IF (NVL(humidity_,0) NOT BETWEEN 0 AND 100) THEN
      Error_SYS.Record_General(lu_name_, 'HUMIDITY: Humidity must be between 0 and 100 %.');
   END IF;
END Check_Humidity;


PROCEDURE Check_Carrying_Capacity (
   carrying_capacity_ IN NUMBER )
IS
BEGIN

   IF (NVL(carrying_capacity_,1) <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'CARRYCAP: Carrying Capacity must be greater than zero.');
   END IF;
END Check_Carrying_Capacity;


PROCEDURE Check_Cubic_Capacity (
   cubic_capacity_ IN NUMBER )
IS
BEGIN

   IF (NVL(cubic_capacity_,1) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CUBICCAP: Dimension cannot be negative.');
   END IF;
END Check_Cubic_Capacity;


PROCEDURE Check_Storage_Capacity_Uom (
   storage_width_requirement_  IN NUMBER,
   storage_height_requirement_ IN NUMBER,
   storage_depth_requirement_  IN NUMBER,
   uom_for_length_             IN VARCHAR2,
   storage_weight_requirement_ IN NUMBER,
   uom_for_weight_             IN VARCHAR2 )
IS
BEGIN
   -- Checks on Width, Height, Depth and UoM for Length
   IF (uom_for_length_ IS NOT NULL) THEN
      IF Iso_Unit_Type_API.Encode(ISO_UNIT_API.Get_Unit_Type(uom_for_length_)) != 'LENGTH' THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTLENTYPE: Field UoM for Length requires a unit of measure of type Length.');
      END IF;
   END IF;

   IF ((storage_width_requirement_ IS NOT NULL) OR (storage_height_requirement_ IS NOT NULL) OR (storage_depth_requirement_ IS NOT NULL)) THEN
      IF (uom_for_length_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMLENGTH: Field UoM for Length requires a value.');
      END IF;
   END IF;

   IF (uom_for_length_ IS NOT NULL) THEN
      IF (storage_width_requirement_ IS NULL) THEN
         IF (storage_height_requirement_ IS NULL) THEN
            IF (storage_depth_requirement_ IS NULL) THEN
               Error_SYS.Record_General('PartCatalogInventAttrib', 'NOLENGTHVAL: Any of the fields Width, Height or Depth requires a value if a UoM for Length is entered.');
            END IF;
         END IF;
      END IF;
   END IF;

   -- Checks on Weight and UoM for Weight
   IF (storage_weight_requirement_ IS NOT NULL) THEN
      IF (uom_for_weight_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMWEIGHT: Field UoM for Weight requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(uom_for_weight_)) != 'WEIGHT' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGHTTYPE: Field UoM for Weight requires a unit of measure of type Weight.');
         END IF;
      END IF;
   END IF;

   IF (uom_for_weight_ IS NOT NULL) THEN
      IF (storage_weight_requirement_ IS NULL) THEN
          Error_SYS.Record_General('PartCatalogInventAttrib', 'NONETWEIGHTVAL: Field Weight requires a value if a UoM for Weight is entered.');
      END IF;
   END IF;
END Check_Storage_Capacity_Uom;


PROCEDURE Check_Temperature_Uom (
   min_storage_temperature_ IN NUMBER,
   max_storage_temperature_ IN NUMBER,
   uom_for_temperature_     IN VARCHAR2 )
IS
BEGIN

   IF (uom_for_temperature_ IS NOT NULL) THEN
      IF ISO_UNIT_TYPE_API.Encode(ISO_UNIT_API.Get_Unit_Type(uom_for_temperature_)) != 'TEMPERAT' THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTTEMPTYPE: Field UoM for Temperature requires a unit of measure of type Temperature.');
      END IF;
   END IF;

   IF ((min_storage_temperature_ IS NOT NULL) OR (max_storage_temperature_ IS NOT NULL)) THEN
      IF (uom_for_temperature_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMTEMP: Field UoM for Temperature requires a value.');
      END IF;
   END IF;

   IF (uom_for_temperature_ IS NOT NULL) THEN
      IF (min_storage_temperature_ IS NULL) THEN
         IF (max_storage_temperature_ IS NULL) THEN
            Error_SYS.Record_General('PartCatalogInventAttrib', 'NOTEMPVAL: Field Temperature requires a value if a UoM for Temperature is entered.');
         END IF;
      END IF;
   END IF;
END Check_Temperature_Uom;


@UncheckedAccess
FUNCTION Incorrect_Temperature_Range (
   min_storage_temperature_ IN NUMBER,
   max_storage_temperature_ IN NUMBER ) RETURN BOOLEAN
IS
   incorrect_temperature_range_ BOOLEAN := FALSE;
BEGIN
   IF (NVL(min_storage_temperature_, -99999) > NVL(max_storage_temperature_, 99999)) THEN
      incorrect_temperature_range_ := TRUE;
   END IF;

   RETURN (incorrect_temperature_range_);
END Incorrect_Temperature_Range;


@UncheckedAccess
FUNCTION Incorrect_Humidity_Range (
   min_storage_humidity_ IN NUMBER,
   max_storage_humidity_ IN NUMBER ) RETURN BOOLEAN
IS
   incorrect_humidity_range_ BOOLEAN := FALSE;
BEGIN
   IF (NVL(min_storage_humidity_, -99999) > NVL(max_storage_humidity_, 99999)) THEN
      incorrect_humidity_range_ := TRUE;
   END IF;

   RETURN (incorrect_humidity_range_);
END Incorrect_Humidity_Range;


PROCEDURE Check_Temperature_Range (
   part_no_ IN VARCHAR2 )
IS
   min_storage_temperature_ PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_temperature%TYPE;
   max_storage_temperature_ PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_temperature%TYPE;
BEGIN

   min_storage_temperature_ := Get_Min_Storage_Temperature(part_no_);
   max_storage_temperature_ := Get_Max_Storage_Temperature(part_no_);
   
   IF (Incorrect_Temperature_Range(min_storage_temperature_, max_storage_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range in Part Catalog :P1.', part_no_);
   END IF;

   Inventory_Part_API.Check_Temperature_Range(part_no_);
END Check_Temperature_Range;


PROCEDURE Check_Humidity_Range (
   part_no_ IN VARCHAR2 )
IS
   min_storage_humidity_ PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_humidity%TYPE;
   max_storage_humidity_ PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_humidity%TYPE;
BEGIN

   min_storage_humidity_ := Get_Min_Storage_Humidity(part_no_);
   max_storage_humidity_ := Get_Max_Storage_Humidity(part_no_);

   IF (Incorrect_Humidity_Range(min_storage_humidity_, max_storage_humidity_ )) THEN
      Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range in Part Catalog :P1.', part_no_);
   END IF;

   Inventory_Part_API.Check_Humidity_Range(part_no_);
END Check_Humidity_Range;


@UncheckedAccess
FUNCTION Get_Storage_Width_Req_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                     PART_CATALOG_INVENT_ATTRIB_TAB.storage_width_requirement%TYPE;
   capacity_req_group_id_    PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   storage_width_req_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT storage_width_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, capacity_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      storage_width_req_source_ := Storage_Capacity_Req_Group_API.Get_Storage_Width_Req_Source(capacity_req_group_id_);
   ELSE
      storage_width_req_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (storage_width_req_source_);
END Get_Storage_Width_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Height_Req_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                      PART_CATALOG_INVENT_ATTRIB_TAB.storage_height_requirement%TYPE;
   capacity_req_group_id_     PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   storage_height_req_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT storage_height_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, capacity_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      storage_height_req_source_ := Storage_Capacity_Req_Group_API.Get_Storage_Height_Req_Source(capacity_req_group_id_);
   ELSE
      storage_height_req_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (storage_height_req_source_);
END Get_Storage_Height_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Depth_Req_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                     PART_CATALOG_INVENT_ATTRIB_TAB.storage_depth_requirement%TYPE;
   capacity_req_group_id_    PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   storage_depth_req_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT storage_depth_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, capacity_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      storage_depth_req_source_ := Storage_Capacity_Req_Group_API.Get_Storage_Depth_Req_Source(capacity_req_group_id_);
   ELSE
      storage_depth_req_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (storage_depth_req_source_);
END Get_Storage_Depth_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                      PART_CATALOG_INVENT_ATTRIB_TAB.storage_volume_requirement%TYPE;
   capacity_req_group_id_     PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   storage_volume_req_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT storage_volume_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, capacity_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      storage_volume_req_source_ := Storage_Capacity_Req_Group_API.Get_Storage_Volume_Req_Source(capacity_req_group_id_);
   ELSE
      storage_volume_req_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (storage_volume_req_source_);
END Get_Storage_Volume_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Oper_Cl (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_volume_requirement%TYPE;
BEGIN
   storage_volume_requirement_ := Get_Storage_Volume_Requirement(part_no_);
   IF (storage_volume_requirement_ > 0) THEN
      storage_volume_requirement_ := 1 / storage_volume_requirement_;
   ELSE
      storage_volume_requirement_ := NULL;
   END IF;

   RETURN storage_volume_requirement_;
END Get_Storage_Volume_Req_Oper_Cl;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Client (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ PART_CATALOG_INVENT_ATTRIB_TAB.storage_volume_requirement%TYPE;
   CURSOR get_attr IS
      SELECT storage_volume_requirement
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO storage_volume_requirement_;
   CLOSE get_attr;
   IF (storage_volume_requirement_ > 0) THEN
      storage_volume_requirement_ := 1 / storage_volume_requirement_;
   ELSE
      storage_volume_requirement_ := NULL;
   END IF;

   RETURN storage_volume_requirement_;
END Get_Storage_Volume_Req_Client;


@UncheckedAccess
FUNCTION Get_Storage_Weight_Req_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                      PART_CATALOG_INVENT_ATTRIB_TAB.storage_weight_requirement%TYPE;
   capacity_req_group_id_     PART_CATALOG_INVENT_ATTRIB_TAB.capacity_req_group_id%TYPE;
   storage_weight_req_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT storage_weight_requirement, capacity_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, capacity_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      storage_weight_req_source_ := Storage_Capacity_Req_Group_API.Get_Storage_Weight_Req_Source(capacity_req_group_id_);
   ELSE
      storage_weight_req_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (storage_weight_req_source_);
END Get_Storage_Weight_Req_Source;


@UncheckedAccess
FUNCTION Get_Min_Storage_Temp_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                    PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_temperature%TYPE;
   condition_req_group_id_  PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   min_storage_temp_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT min_storage_temperature, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, condition_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      min_storage_temp_source_ := Storage_Cond_Req_Group_API.Get_Min_Storage_Temp_Source(condition_req_group_id_);
   ELSE
      min_storage_temp_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (min_storage_temp_source_ );
END Get_Min_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Temp_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                    PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_temperature%TYPE;
   condition_req_group_id_  PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   max_storage_temp_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT max_storage_temperature, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, condition_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      max_storage_temp_source_ := Storage_Cond_Req_Group_API.Get_Max_Storage_Temp_Source(condition_req_group_id_);
   ELSE
      max_storage_temp_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (max_storage_temp_source_);
END Get_Max_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Min_Storage_Humid_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                     PART_CATALOG_INVENT_ATTRIB_TAB.min_storage_humidity%TYPE;
   condition_req_group_id_   PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   min_storage_humid_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT min_storage_humidity, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, condition_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      min_storage_humid_source_ := Storage_Cond_Req_Group_API.Get_Min_Storage_Humid_Source(condition_req_group_id_);
   ELSE
      min_storage_humid_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (min_storage_humid_source_);
END Get_Min_Storage_Humid_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Humid_Source (
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                        PART_CATALOG_INVENT_ATTRIB_TAB.max_storage_humidity%TYPE;
   condition_req_group_id_      PART_CATALOG_INVENT_ATTRIB_TAB.condition_req_group_id%TYPE;
   max_storage_humidity_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT max_storage_humidity, condition_req_group_id
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_, condition_req_group_id_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      max_storage_humidity_source_ := Storage_Cond_Req_Group_API.Get_Max_Storage_Humid_Source(condition_req_group_id_);
   ELSE
      max_storage_humidity_source_ := Part_Structure_Level_API.Decode('PART_CATALOG');
   END IF;
   RETURN (max_storage_humidity_source_ );
END Get_Max_Storage_Humid_Source;


-- Copy
--   This method is used to copy transport data.
PROCEDURE Copy (
   from_part_no_             IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_     PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE;
   oldrec_     PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE;
   objid_      PART_CATALOG_INVENT_ATTRIB.objid%TYPE;
   objversion_ PART_CATALOG_INVENT_ATTRIB.objversion%TYPE;
   attr_       VARCHAR2(32000);   
   indrec_     Indicator_Rec;  

   CURSOR get_transport_rec IS
      SELECT *
      FROM PART_CATALOG_INVENT_ATTRIB_TAB
      WHERE part_no = from_part_no_;
BEGIN

   OPEN get_transport_rec;
   FETCH get_transport_rec INTO oldrec_;

   IF (get_transport_rec%FOUND) THEN
      CLOSE get_transport_rec;
      IF (Check_Exist___(to_part_no_)) THEN
         IF(error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Not_Exist(lu_name_, 'TRANSPORTEXIST: Transportation exist for Part :P1', to_part_no_);
         END IF;
      ELSE
         Client_SYS.Add_To_Attr('PART_NO',          to_part_no_,           attr_);
         Client_SYS.Add_To_Attr('TEMPLATE_PART_DB', oldrec_.template_part, attr_);
         Set_Attributes___(attr_, oldrec_);

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
         
         Partca_Dangerous_Substance_API.Copy(from_part_no_, to_part_no_);
      END IF;
   ELSIF (error_when_no_source_ = 'TRUE') THEN
      CLOSE get_transport_rec;
      Error_SYS.Record_Not_Exist(lu_name_, 'TRANSPORTNOTEXIST: Transportation does not exist for Part :P1', from_part_no_);
   END IF;
END Copy;


-- Copy_From_Template
--   Modify or create a rcord of to_part_no with attributes from to_part_no_.
PROCEDURE Copy_From_Template (
   from_part_no_ IN VARCHAR2,
   to_parts_     IN VARCHAR2 )
IS
   newrec_       PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE;
   oldrec_       PART_CATALOG_INVENT_ATTRIB_TAB%ROWTYPE;
   objid_        PART_CATALOG_INVENT_ATTRIB.objid%TYPE;
   objversion_   PART_CATALOG_INVENT_ATTRIB.objversion%TYPE;
   copy_attr_    VARCHAR2(32000);
   attr_         VARCHAR2(32000);
   to_part_no_   PART_CATALOG_INVENT_ATTRIB_TAB.part_no%TYPE;
   count_        NUMBER;   
   name_arr_     Message_SYS.name_table;
   value_arr_    Message_SYS.line_table;
   indrec_       Indicator_Rec;
BEGIN

   Exist(from_part_no_);
   oldrec_ := Get_Object_By_Keys___(from_part_no_);
   Set_Attributes___( copy_attr_, oldrec_);
   Client_SYS.Add_To_Attr('TEMPLATE_PART_DB', 'FALSE', copy_attr_);

   Message_SYS.Get_Attributes(to_parts_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'PART_NO') THEN
         to_part_no_ := value_arr_(n_);
         attr_       := copy_attr_;
         IF (to_part_no_ != from_part_no_) THEN
         -- No need of trying to copy from same part
            IF (Check_Exist___(to_part_no_)) THEN
               oldrec_ := Lock_By_Keys___(to_part_no_);
               newrec_ := oldrec_;
               Unpack___(newrec_, indrec_, attr_);
               Check_Update___(oldrec_, newrec_, indrec_, attr_);
               Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By Keys.
               Unpack___(newrec_, indrec_, attr_);
               Check_Update___(oldrec_, newrec_, indrec_, attr_);
            ELSE
               Client_SYS.Add_To_Attr('PART_NO', to_part_no_, attr_);
               Unpack___(newrec_, indrec_, attr_);
               Check_Insert___(newrec_, indrec_, attr_);
               Insert___(objid_, objversion_, newrec_, attr_);
            END IF;
            Partca_Dangerous_Substance_API.Copy(from_part_no_, to_part_no_);
         END IF;
      END IF;
   END LOOP;
END Copy_From_Template;



