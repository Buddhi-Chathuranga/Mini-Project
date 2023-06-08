-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitAccessory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130823  MaEelk   Made a call to Accessory_On_Handling_Unit_API.Calculate_Shipment_Charges if a change is done to weight or volume from Update___
--  130809  MaEelk   Named the base table HANDLE_UNIT_ACCESSORY_TAB instead of the generated name HANDLING_UNIT_ACCESSSORY_TAB.
--  130809           This was done deliberately to avoid some functional issues which may arise  since this table had earlier been introduced in 1330.upg at ORDER component.
--  130809           It was decided to still use the old LU name since the name goes well with the attributes of the LU.  
--  120821  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Weight___ (
   weight_ IN NUMBER )
IS
BEGIN

   IF (weight_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'WEIGHT: Weight must be greater than zero.');
   END IF;
END Check_Weight___;


PROCEDURE Check_Volume___ (
   volume_          IN NUMBER,
   additive_volume_ IN VARCHAR2 )
IS
BEGIN

   IF (additive_volume_ = Fnd_Boolean_API.DB_TRUE AND volume_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOVOLUME: Outer volume must have a value for handling units that has additive volume.');
   END IF;
   IF (volume_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'VOLUME: Volume must be greater than zero.');
   END IF;
END Check_Volume___;


PROCEDURE Check_Uom___ (
   uom_for_weight_ IN VARCHAR2,
   volume_         IN NUMBER,
   uom_for_volume_ IN VARCHAR2 )
IS
BEGIN
   -- Check on UoM for Weight
   IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(uom_for_weight_)) != 'WEIGHT' THEN
      Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGHTTYPE: Field UoM for Weight requires a unit of measure of type Weight.');
   END IF;

   -- Check on UoM for Volume
   IF (volume_ IS NOT NULL) THEN
      IF (uom_for_volume_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMVOLUME: Field UoM for Volume requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(uom_for_volume_)) != 'VOLUME' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTVOLUMETYPE: Field UoM for Volume requires a unit of measure of type Volume.');
         END IF;
      END IF;
   END IF;
END Check_Uom___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   default_company_ VARCHAR2(30);
BEGIN
   default_company_ := User_Finance_API.Get_Default_Company_Func;
   
   super(attr_);
   Client_SYS.Add_To_Attr('ADDITIVE_VOLUME_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_WEIGHT', Company_Invent_Info_API.Get_Uom_For_Weight(default_company_), attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_VOLUME', Company_Invent_Info_API.Get_Uom_For_Volume(default_company_), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     HANDLE_UNIT_ACCESSORY_TAB%ROWTYPE,
   newrec_     IN OUT HANDLE_UNIT_ACCESSORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_    NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (NVL(oldrec_.weight, number_null_) != NVL(newrec_.weight, number_null_)) OR
      (NVL(oldrec_.volume, number_null_) != NVL(newrec_.volume, number_null_)) THEN
      Accessory_On_Handling_Unit_API.Calculate_Shipment_Charges(newrec_.handling_unit_accessory_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT handle_unit_accessory_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_            VARCHAR2(30);
   value_           VARCHAR2(2000);
   default_company_ VARCHAR2(30);
BEGIN
   default_company_        := User_Finance_API.Get_Default_Company_Func;
   IF NOT (indrec_.additive_volume) THEN 
      newrec_.additive_volume := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.uom_for_weight) THEN 
      newrec_.uom_for_weight  := Company_Invent_Info_API.Get_Uom_For_Weight(default_company_);
   END IF;
   IF NOT (indrec_.uom_for_volume) THEN 
      newrec_.uom_for_volume  := Company_Invent_Info_API.Get_Uom_For_Volume(default_company_);
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   Check_Weight___(newrec_.weight);
   Check_Volume___(newrec_.volume, newrec_.additive_volume);
   
   IF (newrec_.volume IS NULL) THEN 
      newrec_.uom_for_volume := NULL;
   END IF;
   
   Check_Uom___(newrec_.uom_for_weight,
                newrec_.volume,
                newrec_.uom_for_volume);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     handle_unit_accessory_tab%ROWTYPE,
   newrec_ IN OUT handle_unit_accessory_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   number_null_ NUMBER := -9999999;
   string_null_ VARCHAR2(15) := Database_SYS.string_null_;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.weight != oldrec_.weight) THEN
      Check_Weight___(newrec_.weight);
   END IF;
   
   IF ((NVL(newrec_.volume, number_null_) != NVL(oldrec_.volume, number_null_)) OR 
      (newrec_.additive_volume != oldrec_.additive_volume)) THEN
      Check_Volume___(newrec_.volume, newrec_.additive_volume);
   END IF;
   IF (newrec_.volume IS NULL) THEN 
      newrec_.uom_for_volume := NULL;
   END IF;
   IF ((newrec_.uom_for_weight != oldrec_.uom_for_weight) OR 
      (NVL(newrec_.volume, number_null_) != NVL(oldrec_.volume, number_null_)) OR 
      (NVL(newrec_.uom_for_volume, string_null_) != (NVL(oldrec_.uom_for_volume, string_null_)))) THEN
      Check_Uom___(newrec_.uom_for_weight,
                   newrec_.volume,
                   newrec_.uom_for_volume);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   handling_unit_accessory_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ handle_unit_accessory_tab.description%TYPE;
BEGIN
   IF (handling_unit_accessory_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      handling_unit_accessory_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  handle_unit_accessory_tab
      WHERE handling_unit_accessory_id = handling_unit_accessory_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(handling_unit_accessory_id_, 'Get_Description');
END Get_Description;


