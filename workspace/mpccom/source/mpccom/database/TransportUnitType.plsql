-----------------------------------------------------------------------------
--
--  Logical unit: TransportUnitType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130603  MaMalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Weight_And_Volume___ (
   rec_ IN TRANSPORT_UNIT_TYPE_TAB%ROWTYPE )
IS
BEGIN   
   IF (rec_.weight_capacity IS NULL) AND (rec_.volume_capacity IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'WEIGHT_VOLUME_NOT_DEFINED: Any of the fields Weight Capacity or Volume Capacity requires a value.'); 
   ELSE
      IF (NVL(rec_.weight_capacity , 1) <= 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_WEIGHT_CAPACITY: Weight capacity must be greater than zero.');
      END IF;
   
      IF (NVL(rec_.volume_capacity , 1) <= 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_VOLUME_CAPACITY: Volume capacity must be greater than zero.');
      END IF; 
   END IF;

   IF (rec_.weight_capacity IS NOT NULL) THEN
      IF (rec_.uom_for_weight IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMFORWEIGHT: Field UoM for Weight requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(rec_.uom_for_weight )) != 'WEIGHT' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGHTTYPE: Field UoM for Weight requires a unit of measure of type Weight.');
         END IF;
      END IF;
   ELSIF (rec_.uom_for_weight IS NOT NULL) THEN
      Error_SYS.Record_General('HandlingUnitType', 'NOWEIGHTVAL: Field Weight Capacity requires a value if a UoM for Weight is entered.');
   END IF;
      
   IF (rec_.volume_capacity IS NOT NULL) THEN
      IF (rec_.uom_for_volume IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMVOLUME: Field UoM for Volume requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(rec_.uom_for_volume)) != 'VOLUME' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTVOLUMETYPE: Field UoM for Volume requires a unit of measure of type Volume.');
         END IF;
      END IF;
   ELSIF (rec_.uom_for_volume IS NOT NULL) THEN
      Error_SYS.Record_General('HandlingUnitType', 'NOVOLUMEVAL: Filed Volume Capacity requires a value if a UoM for Volume is entered.');
   END IF;  
END Check_Weight_And_Volume___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT transport_unit_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   Check_Weight_And_Volume___(newrec_);  
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     transport_unit_type_tab%ROWTYPE,
   newrec_ IN OUT transport_unit_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Check_Weight_And_Volume___(newrec_);  
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   transport_unit_type_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ transport_unit_type_tab.description%TYPE;
BEGIN
   IF (transport_unit_type_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      transport_unit_type_id_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  transport_unit_type_tab
      WHERE transport_unit_type_id = transport_unit_type_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(transport_unit_type_id_, 'Get_Description');
END Get_Description;



