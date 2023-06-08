-----------------------------------------------------------------------------
--
--  Logical unit: StorageCondReqGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120904  JeLise   Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120904  JeLise   Moved from Partca to Invent.
--  120525  JeLise   Made description private.
--  100907  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Temperature_Range___ (
   min_temperature_ IN NUMBER,
   max_temperature_ IN NUMBER )
IS
BEGIN

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(min_temperature_, max_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Temperature Range.');
   END IF;
END Check_Temperature_Range___;


PROCEDURE Check_Humidity_Range___ (
   min_humidity_ IN NUMBER,
   max_humidity_ IN NUMBER )
IS
BEGIN

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(min_humidity_, max_humidity_)) THEN
      Error_SYS.Record_General(lu_name_, 'HUMIDRANGE: Incorrect Humidity Range.');
   END IF;
END Check_Humidity_Range___;


PROCEDURE Check_Values___ (
   newrec_  IN STORAGE_COND_REQ_GROUP_TAB%ROWTYPE )
IS
BEGIN

   IF (newrec_.min_temperature IS NULL AND newrec_.max_temperature IS NULL AND
       newrec_.uom_for_temperature IS NULL AND newrec_.min_humidity IS NULL AND
       newrec_.max_humidity IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOVALUES: At least one of the columns must have a value');
   END IF;
END Check_Values___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT storage_cond_req_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   Check_Values___(newrec_);

   Part_Catalog_Invent_Attrib_API.Check_Temperature_Uom(newrec_.min_temperature, newrec_.max_temperature, newrec_.uom_for_temperature);
   Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.min_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.max_humidity);

   Check_Temperature_Range___(newrec_.min_temperature, newrec_.max_temperature);
   Check_Humidity_Range___(newrec_.min_humidity, newrec_.max_humidity);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     storage_cond_req_group_tab%ROWTYPE,
   newrec_ IN OUT storage_cond_req_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_        VARCHAR2(30);
   value_       VARCHAR2(4000);   
   number_null_ NUMBER := -9999999;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Check_Values___(newrec_);

   IF ((NVL(newrec_.min_temperature, number_null_) != NVL(oldrec_.min_temperature, number_null_)) OR
      (NVL(newrec_.max_temperature, number_null_) != NVL(oldrec_.max_temperature, number_null_)) OR
      (NVL(newrec_.uom_for_temperature, Database_Sys.string_null_) != NVL(oldrec_.uom_for_temperature, Database_Sys.string_null_))) THEN
      Part_Catalog_Invent_Attrib_API.Check_Temperature_Uom(newrec_.min_temperature, newrec_.max_temperature, newrec_.uom_for_temperature);
   END IF;

   IF (NVL(newrec_.min_humidity, number_null_) != NVL(oldrec_.min_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.min_humidity);
   END IF;

   IF (NVL(newrec_.max_humidity, number_null_) != NVL(oldrec_.max_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.max_humidity);
   END IF;

   Check_Temperature_Range___(newrec_.min_temperature, newrec_.max_temperature);
   Check_Humidity_Range___(newrec_.min_humidity, newrec_.max_humidity);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Min_Storage_Temp_Source (
   condition_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                    STORAGE_COND_REQ_GROUP_TAB.min_temperature%TYPE;
   min_storage_temp_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT min_temperature
      FROM STORAGE_COND_REQ_GROUP_TAB
      WHERE condition_req_group_id = condition_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      min_storage_temp_source_ := NULL;
   ELSE
      min_storage_temp_source_ := Part_Structure_Level_API.Decode('CONDITION_GROUP');
   END IF;
   RETURN (min_storage_temp_source_);
END Get_Min_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Temp_Source (
   condition_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                    STORAGE_COND_REQ_GROUP_TAB.max_temperature%TYPE;
   max_storage_temp_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT max_temperature
      FROM STORAGE_COND_REQ_GROUP_TAB
      WHERE condition_req_group_id = condition_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      max_storage_temp_source_ := NULL;
   ELSE
      max_storage_temp_source_ := Part_Structure_Level_API.Decode('CONDITION_GROUP');
   END IF;
   RETURN (max_storage_temp_source_);
END Get_Max_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Min_Storage_Humid_Source (
   condition_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                     STORAGE_COND_REQ_GROUP_TAB.min_humidity%TYPE;
   min_storage_humid_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT min_humidity
      FROM STORAGE_COND_REQ_GROUP_TAB
      WHERE condition_req_group_id = condition_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      min_storage_humid_source_ := NULL;
   ELSE
      min_storage_humid_source_ := Part_Structure_Level_API.Decode('CONDITION_GROUP');
   END IF;
   RETURN (min_storage_humid_source_);
END Get_Min_Storage_Humid_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Humid_Source (
   condition_req_group_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_                     STORAGE_COND_REQ_GROUP_TAB.max_humidity%TYPE;
   max_storage_humid_source_ VARCHAR2(200);

   CURSOR get_attr IS
      SELECT max_humidity
      FROM STORAGE_COND_REQ_GROUP_TAB
      WHERE condition_req_group_id = condition_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      max_storage_humid_source_ := NULL;
   ELSE
      max_storage_humid_source_ := Part_Structure_Level_API.Decode('CONDITION_GROUP');
   END IF;
   RETURN (max_storage_humid_source_);
END Get_Max_Storage_Humid_Source;

@UncheckedAccess
FUNCTION Get_Description (
   condition_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ storage_cond_req_group_tab.description%TYPE;
BEGIN
   IF (condition_req_group_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'StorageCondReqGroup',
              condition_req_group_id), description), 1, 200)
      INTO  temp_
      FROM  storage_cond_req_group_tab
      WHERE condition_req_group_id = condition_req_group_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_req_group_id_, 'Get_Description');
END Get_Description;


