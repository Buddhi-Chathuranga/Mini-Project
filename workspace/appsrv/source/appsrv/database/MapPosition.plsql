-----------------------------------------------------------------------------
--
--  Logical unit: MapPosition
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210816  puvelk  AM21R2-2566, Added Check_Valid_Map_positions___() Method and Check_Common___() Method
--  210629  AwWelk  AM21R2-2066, Added UncheckAccess annotation to Get_Default_Latitude(), Get_Default_Longitude().
--  210621  AwWelk  SC21R2-1464, Added methods Get_Default_Latitude(), Get_Default_Longitude() for Demand Planner related functionality. 
--  210615  DEEKLK  AM21R2-1812, Modifed Retrieve_Map_Position_Callback().
--  201105  CLEKLK  Added Prepare_Call___ and Get_License_Geocode_Usage, modified Retrieve_Map_Position and Retrieve_Map_Position_Callback
--  200903  LoPrlk  AM2020R1-5116, Added the methods Retrieve_Map_Position and Retrieve_Map_Position_Callback to enable geocoding in HERE maps.
--  180122  MDAHSE  APPUXX-12780, Add Get_Def_Position_Long_Lat_Alt to support the map plugin in Aurena
--  171126  HASTSE  STRSA-32829, Equipment inheritance implementation
--  170503  MDAHSE  STRSA-15472: Better handling of default position at insert.
--  170316  MDAHSE  STRSA-15472: Remove code that synced from MapPosition to VrtMapPosition. Change logic for DefaultPosition.
--  170207  CLHASE  STRSA-18547, Removed method Register_Scheduling_Update___.
--  161118  MDAHSE  Created. Copied all code from VirtMapPosition.plsql. Also add validation methods.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

DEFAULT_POSITION_TRUE  CONSTANT NUMBER(1) := 1;
DEFAULT_POSITION_FALSE CONSTANT NUMBER(1) := 0;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MAP_POSITION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   SELECT map_position_seq.nextval INTO newrec_.position_id FROM dual;

   newrec_.created_by := Fnd_Session_API.Get_Fnd_User();
   newrec_.created_date := SYSDATE;

   IF Map_Position_Exist_For_Object (newrec_.lu_name, newrec_.key_ref) = 'FALSE' THEN
      newrec_.default_position := DEFAULT_POSITION_TRUE;
      Client_SYS.Add_To_Attr('DEFAULT_POSITION', DEFAULT_POSITION_TRUE, attr_);
   ELSE

      -- If the client wants the position to be the default, obey...

      IF (newrec_.default_position = DEFAULT_POSITION_TRUE) THEN
         Unset_Old_Default_Position___ (newrec_.lu_name, newrec_.key_ref);
      END IF;

   END IF;

   super(objid_, objversion_, newrec_, attr_);

   Client_SYS.Add_To_Attr('POSITION_ID', newrec_.position_id, attr_);

   Validate_New_Map_Pos___(newrec_);

END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     map_position_tab%ROWTYPE,
   newrec_     IN OUT map_position_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User();
   newrec_.modified_date := SYSDATE;
   IF (Validate_SYS.Is_Changed (oldrec_.default_position, newrec_.default_position) AND newrec_.default_position = DEFAULT_POSITION_TRUE) THEN
      Unset_Old_Default_Position___ (newrec_.lu_name, newrec_.key_ref);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Validate_Modify_Map_Pos___(oldrec_, newrec_);
END Update___;

-- Set_New_Default___
--   Set the last added position on an object as the new
--   default position if there is one.

PROCEDURE Set_New_Default___  (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2)
IS
   CURSOR positions_ IS
     SELECT *
     FROM map_position_tab
     WHERE key_ref = key_ref_
     AND   lu_name = lu_name_
     ORDER BY rowversion DESC;
BEGIN
   FOR pos_rec_ IN positions_ LOOP
      Set_Default_Position___ (pos_rec_.position_id, DEFAULT_POSITION_TRUE);
      EXIT;
   END LOOP;
END Set_New_Default___;

PROCEDURE Set_New_Default (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2)
IS
   
BEGIN
   Set_New_Default___ (lu_name_, key_ref_);
END Set_New_Default;

@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     map_position_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Validate_Remove_Map_Pos___(remrec_);
   IF remrec_.default_position = DEFAULT_POSITION_TRUE THEN
      Set_New_Default___ (remrec_.lu_name, remrec_.key_ref);
   END IF;
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     map_position_tab%ROWTYPE,
   newrec_ IN OUT map_position_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT Check_Valid_Map_positions___(newrec_.latitude, newrec_.longitude) THEN
      Error_SYS.Record_General(Map_Position_API.lu_name_, 'INVALIDMAPPOSITIONS: Invalid Map Position.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-- method to validate MapPositions in general 
FUNCTION Check_Valid_Map_positions___(
   latitude_  IN NUMBER,
   longitude_ IN NUMBER ) RETURN BOOLEAN 
IS
   is_valid_ BOOLEAN := FALSE;
BEGIN
   
   IF (latitude_ BETWEEN -90 AND 90) AND (longitude_ BETWEEN -180 AND 180) THEN 
      is_valid_ := TRUE;
   END IF;
   
   RETURN is_valid_;
END Check_Valid_Map_positions___;

--Validate_New_Map_Pos___
-- This method provides an interface for the objects that use map
-- positions to validate when a map position is inserted. Such objects
-- should implement this method to include its business logic.

PROCEDURE Validate_New_Map_Pos___(
   rec_       IN  map_position_tab%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   attr_            VARCHAR2(32000);
BEGIN
   package_name_ := Object_Connection_SYS.Get_Package_Name(rec_.lu_name);
   attr_  := Pack___(rec_);
   Client_SYS.Set_Item_Value('ROWKEY', rec_.rowkey, attr_);
   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_New_Map_Pos')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_New_Map_Pos(:key_ref_, :attr_);
                END;';
      @ApproveDynamicStatement(2016-11-18,mdahse)
      EXECUTE IMMEDIATE stmt_ USING IN  rec_.key_ref, IN attr_;
   END IF;
END Validate_New_Map_Pos___;


--Validate_Modify_Map_Pos___
-- This method provides an interface for the objects that use map
-- positions to validate when a map position is modified. Such objects
-- should implement this method to include its business logic.

PROCEDURE Validate_Modify_Map_Pos___(
   oldrec_    IN  map_position_tab%ROWTYPE,
   newrec_    IN  map_position_tab%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   old_attr_        VARCHAR2(32000);
   new_attr_        VARCHAR2(32000);
BEGIN
   package_name_ := Object_Connection_SYS.Get_Package_Name(newrec_.lu_name);
   old_attr_ := Pack___(oldrec_);
   Client_SYS.Set_Item_Value('ROWKEY', oldrec_.rowkey, old_attr_);
   new_attr_ := Pack___(newrec_);
   Client_SYS.Set_Item_Value('ROWKEY', newrec_.rowkey, new_attr_);

   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_Modify_Map_Pos')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_Modify_Map_Pos(:key_ref_, :old_attr_, :new_attr_);
                END;';
      @ApproveDynamicStatement(2015-07-02,nasalk)
      EXECUTE IMMEDIATE stmt_ USING IN  newrec_.key_ref, IN old_attr_, IN new_attr_;
   END IF;
END Validate_Modify_Map_Pos___;

--Validate_Remove_Map_Pos___
-- This method provides an interface for the objects that use map
-- positions to validate when a map position is removed. Such objects
-- should implement this method to include its business logic.

PROCEDURE Validate_Remove_Map_Pos___(
   rec_       IN  map_position_tab%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   attr_            VARCHAR2(32000);
BEGIN
   package_name_ := Object_Connection_SYS.Get_Package_Name(rec_.lu_name);
   attr_  := Pack___(rec_);
   Client_SYS.Set_Item_Value('ROWKEY', rec_.rowkey, attr_);

   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_Remove_Map_Pos')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_Remove_Map_Pos(:key_ref_, :attr_);
                END;';
      @ApproveDynamicStatement(2015-07-02,nasalk)
      EXECUTE IMMEDIATE stmt_ USING IN rec_.key_ref, IN attr_;
   END IF;
END Validate_Remove_Map_Pos___;


FUNCTION Prepare_Call___ (
   key_value_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Ins_Util_API.From_Base64(key_value_);
END Prepare_Call___;

PROCEDURE Set_Default_Position___ (position_id_      IN NUMBER,
                                   default_position_ IN NUMBER)
IS
   rec_ map_position_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___ (position_id_);
   rec_.default_position := default_position_;
   Modify___(rec_);
END Set_Default_Position___;


PROCEDURE Unset_Old_Default_Position___ (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2)
IS
   CURSOR Get_Positions IS
     SELECT *
     FROM map_position_tab
     WHERE lu_name = lu_name_
     AND key_ref = key_ref_
     AND default_position = DEFAULT_POSITION_TRUE;
BEGIN
   FOR pos_ IN Get_Positions LOOP
      Set_Default_Position___ (pos_.position_id, DEFAULT_POSITION_FALSE);
   END LOOP;
END Unset_Old_Default_Position___;

PROCEDURE Unset_Old_Default_Position (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2)
IS
   
BEGIN
   Unset_Old_Default_Position___(lu_name_, key_ref_);
END Unset_Old_Default_Position;

@UncheckedAccess
PROCEDURE Unset_Old_Default_Position (
   position_id_ IN NUMBER)
IS
   remrec_ map_position_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___ (position_id_);
   Unset_Old_Default_Position___(remrec_.lu_name, remrec_.key_ref);
END Unset_Old_Default_Position;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Column_Names (
   view_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   all_names_ VARCHAR2(4000);
   one_column_ user_tab_columns.column_name%TYPE;
   CURSOR column_names_ IS
      SELECT column_name
        FROM user_tab_columns
       WHERE table_name = view_name_;
BEGIN
   all_names_ := '';
   OPEN column_names_;
   FETCH column_names_ INTO one_column_;
   WHILE column_names_%FOUND LOOP
      all_names_ := all_names_ || one_column_ || ';';
      FETCH column_names_ INTO one_column_;
   END LOOP;
   CLOSE column_names_;
   RETURN all_names_;
END Get_Column_Names;


PROCEDURE Update_LU_Name (
   source_lu_name_ IN VARCHAR2,
   target_lu_name_ IN VARCHAR2,
   key_ref_        IN VARCHAR2 )
IS
BEGIN
   UPDATE map_position_tab
      SET LU_NAME = target_lu_name_
      WHERE lu_name = source_lu_name_
      AND   key_ref = key_ref_;
END Update_LU_Name;


PROCEDURE Create_New_Map_Position(
   lu_name_   IN VARCHAR2,
   key_ref_   IN VARCHAR2,
   longitude_ IN NUMBER,
   latitude_  IN NUMBER)
IS
   info_   VARCHAR2(2000);
   objid_   VARCHAR2(100);
   objversion_  VARCHAR2(2000);
   attr_ VARCHAR2(10000);

BEGIN
   IF(lu_name_ IS NOT NULL AND key_ref_ IS NOT NULL)THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LU_NAME', lu_name_, attr_);
      Client_SYS.Add_To_Attr('KEY_REF', key_ref_, attr_);
      Client_SYS.Add_To_Attr('LONGITUDE', longitude_, attr_);
      Client_SYS.Add_To_Attr('LATITUDE', latitude_, attr_);
      Map_Position_Api.New__(info_, objid_,objversion_,attr_,'DO');
   END IF;
END Create_New_Map_Position;


PROCEDURE Delete_Map_Position(
   position_id_ IN NUMBER)
IS
   remrec_ map_position_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___ (position_id_);
   Remove___(remrec_);
END Delete_Map_Position;


PROCEDURE Set_Default_Map_Position(
   position_id_ IN NUMBER)
IS
   CURSOR Get_Positions IS
     SELECT *
     FROM map_position_tab
     WHERE (lu_name, key_ref) =
       (SELECT lu_name, key_ref
        FROM map_position_tab
        WHERE position_id = position_id_);
BEGIN
   FOR pos_ IN Get_Positions LOOP
      IF pos_.default_position = DEFAULT_POSITION_TRUE AND pos_.position_id != position_id_ THEN
         Set_Default_Position___ (pos_.position_id, DEFAULT_POSITION_FALSE);
      ELSIF NVL(pos_.default_position, DEFAULT_POSITION_FALSE) = DEFAULT_POSITION_FALSE AND pos_.position_id = position_id_ THEN
         Set_Default_Position___ (pos_.position_id, DEFAULT_POSITION_TRUE);
      END IF;
   END LOOP;
END Set_Default_Map_Position;


PROCEDURE Save_Notes(
   position_id_ IN NUMBER,
   notes_       IN VARCHAR2)
IS
   rec_ map_position_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___ (position_id_);
   rec_.notes := notes_;
   Modify___(rec_);
END Save_Notes;


PROCEDURE Copy (
   source_lu_name_      IN VARCHAR2,
   source_key_ref_      IN VARCHAR2,
   destination_lu_name_ IN VARCHAR2,
   destination_key_ref_ IN VARCHAR2 )
IS
   newrec_              MAP_POSITION_TAB%ROWTYPE;
   --
   CURSOR copy_object (
      lu_name_ VARCHAR2,
      key_ref_ VARCHAR2) IS
      SELECT *
      FROM  MAP_POSITION_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN copy_object(source_lu_name_, source_key_ref_) LOOP
      newrec_ := NULL;
      newrec_.latitude := rec_.latitude;
      newrec_.longitude := rec_.longitude;
      newrec_.lu_name := destination_lu_name_;
      newrec_.key_ref := destination_key_ref_;
      --
      New___(newrec_);
      --
   END LOOP;
END Copy;


PROCEDURE Move (
   source_lu_name_      IN VARCHAR2,
   source_key_ref_      IN VARCHAR2,
   destination_lu_name_ IN VARCHAR2,
   destination_key_ref_ IN VARCHAR2 )
IS
   newrec_              MAP_POSITION_TAB%ROWTYPE;
   remrec_              MAP_POSITION_TAB%ROWTYPE;
   --
   CURSOR copy_object (
      lu_name_ VARCHAR2,
      key_ref_ VARCHAR2) IS
      SELECT *
      FROM  MAP_POSITION_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN copy_object(source_lu_name_, source_key_ref_) LOOP
      remrec_ := rec_;
      newrec_ := NULL;
      newrec_.latitude := rec_.latitude;
      newrec_.longitude := rec_.longitude;
      newrec_.lu_name := destination_lu_name_;
      newrec_.key_ref := destination_key_ref_;
      --
      New___(newrec_);
      Remove___(remrec_);
      --
   END LOOP;
END Move;


-- Get_Positions_For_Map
--   Return all coordinates, as a JSON string, for a certain object.
--   Used in frmObjectPositioning.

FUNCTION Get_Positions_For_Map (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2) RETURN VARCHAR2
IS
   pos_data_ VARCHAR2(4000);
   CURSOR get_pos_data (
        lu_name_ VARCHAR2,
        key_ref_ VARCHAR2) IS
     SELECT '{"PositionId": '       || position_id      || ', ' ||
             '"Notes": '            || '"' || notes || '", ' ||
             '"DefaultPosition": '  || DECODE(default_position, DEFAULT_POSITION_TRUE, 'true', 'false') || ', ' ||
             '"Longitude":'         || TRIM(TO_CHAR(longitude, '0999.99999999999999999999')) || ', ' ||
             '"Latitude":'          || TRIM(TO_CHAR(latitude, '099.99999999999999999999'))   || '}' || ',' coord
      FROM  map_position_tab
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN get_pos_data(lu_name_, key_ref_) LOOP
      pos_data_ := pos_data_ || rec_.coord;
   END LOOP;

   pos_data_ := SUBSTR(pos_data_, 1, LENGTH (pos_data_) - 1);

   pos_data_ := '[' || pos_data_  || ']';

   RETURN pos_data_;
END Get_Positions_For_Map;

-- Get_Object_Info_As_JSON
--   Given an LU, a list of column names and a list of values,
--   return JSON to be used from frmObjectPositioning.

FUNCTION Get_Object_Info_As_JSON(
   lu_      IN VARCHAR2,
   columns_ IN VARCHAR2,
   values_  IN VARCHAR2) RETURN VARCHAR2
IS

   columns_array_  Utility_SYS.STRING_TABLE;
   values_array_   Utility_SYS.STRING_TABLE;

   column_count_ NUMBER;
   value_count_  NUMBER;
   record_count_ NUMBER := 1;

   key_ref_      VARCHAR2(32000);
   keys_         VARCHAR2(32000);
   description_  VARCHAR2(32000);

   json_         VARCHAR2(32000);

   -- These helper functions, v_ and n_, either returns NULL or the value
   -- or name, respectively, of data sent in. The reason it is needed is
   -- that we cannot get a NULL value from columns_array_ or values_array_,
   -- if there is no value there, for a certain position.

   FUNCTION v_ (rec_ IN NUMBER, num_ IN NUMBER) RETURN VARCHAR2
   IS
      value_ VARCHAR2(4000);
      array_pos_ NUMBER;
   BEGIN
      array_pos_ := num_ + ((rec_ - 1) * column_count_);
      IF array_pos_ <= value_count_ AND num_ <= record_count_ THEN
         value_ := values_array_ (array_pos_);
      END IF;
      DBMS_OUTPUT.Put_Line ('array_pos_ ' || LPAD(array_pos_, 2) || ' value_ ' || value_);
      RETURN value_;
   END v_;

   FUNCTION n_ (num_ IN NUMBER) RETURN VARCHAR2
   IS
      name_ VARCHAR2(30);
   BEGIN
      IF num_ <= column_count_ THEN
         name_ := columns_array_ (num_);
      END IF;
      RETURN name_;
   END n_;

BEGIN

   Utility_SYS.Tokenize(columns_, Client_SYS.record_separator_, columns_array_, column_count_);
   Utility_SYS.Tokenize(values_,  Client_SYS.record_separator_, values_array_,  value_count_);

   -- It is possible to send in more than one record/object, for the same
   -- LU. The check below is used to determine how many records are being
   -- sent in.

   IF column_count_ != value_count_ THEN
      record_count_ := value_count_ / column_count_;
   END IF;

   json_ := '[';

   FOR rec_ in 1..record_count_ LOOP

      key_ref_ := Client_SYS.Get_Key_Reference (lu_, n_(1), v_(rec_, 1), n_(2), v_(rec_, 2), n_(3), v_(rec_, 3), n_(4), v_(rec_, 4), n_(5), v_(rec_, 5), n_(6), v_(rec_, 6), n_(7), v_(rec_, 7), n_(8), v_(rec_, 8), n_(9), v_(rec_, 9), n_(10), v_(rec_, 10), n_(11), v_(rec_, 11), n_(12), v_(rec_, 12), n_(13), v_(rec_, 13), n_(14), v_(rec_, 14), n_(15), v_(rec_, 15));

      keys_ := Object_Connection_SYS.Get_Instance_Description(lu_, NULL, key_ref_);
      Object_Connection_SYS.Get_Connection_Description(description_, lu_, key_ref_);

      IF rec_ > 1 THEN
         json_ := json_ || ', ';
      END IF;

      json_ := json_ || '{"LuName": ' || '"' || lu_ || '"' || ', "KeyRef": ' || '"' || key_ref_ || '"' || ', "Keys": ' || '"' || keys_  || '"' || ', "Description": ' || '"' || description_ || '"}';

   END LOOP;

   json_ := json_ || ']';

   RETURN json_;

END Get_Object_Info_As_JSON;

FUNCTION Get_Geocoding_Licensing_Metric RETURN NUMBER
IS
   transactions_ NUMBER;
   CURSOR get_transaction_amount IS
      SELECT count(*) 
      FROM map_position_tab 
      WHERE geocoded = 'TRUE'
      AND trunc(created_date) >= trunc(sysdate-30);
BEGIN
   OPEN get_transaction_amount;
   FETCH get_transaction_amount INTO transactions_;
   CLOSE get_transaction_amount;
   RETURN NVL(transactions_,0);
END Get_Geocoding_Licensing_Metric;

-- Map_Position_Exist_For_Object
--   Return the string TRUE if there exists at least one position for the
--   object represented with the LU name and keyref sent in. Otherwise return
--   the string FALSE.

FUNCTION Map_Position_Exist_For_Object (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
     INTO  dummy_
     FROM  map_position_tab
   WHERE lu_name = lu_name_
   AND   key_ref = key_ref_;
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
     RETURN 'FALSE';
   WHEN too_many_rows THEN
     RETURN 'TRUE';
END Map_Position_Exist_For_Object;


-- Create_And_Replace
--   Removes all existing positions for an object and creates a new one
--   An efect of thei is that the new position will become defult position
PROCEDURE Create_And_Replace (
   lu_name_   IN VARCHAR2,
   key_ref_   IN VARCHAR2,
   longitude_ IN NUMBER,
   latitude_  IN NUMBER,
   altitude_  IN NUMBER )
IS
   newrec_              MAP_POSITION_TAB%ROWTYPE;
BEGIN

   Remove_Position_For_Object(lu_name_, key_ref_);

   newrec_           := NULL;
   newrec_.latitude  := latitude_;
   newrec_.longitude := longitude_;
   newrec_.altitude  := altitude_;
   newrec_.lu_name   := lu_name_;
   newrec_.key_ref   := key_ref_;
   New___(newrec_);
END Create_And_Replace;

--create a new position and make it the default position without removing other positions.
PROCEDURE Create_And_Replace_position (
   lu_name_   IN VARCHAR2,
   key_ref_   IN VARCHAR2,
   longitude_ IN NUMBER,
   latitude_  IN NUMBER )
IS
   newrec_              MAP_POSITION_TAB%ROWTYPE;
BEGIN

   newrec_                 := NULL;
   newrec_.latitude        := latitude_;
   newrec_.longitude       := longitude_;
   newrec_.lu_name         := lu_name_;
   newrec_.key_ref         := key_ref_;
   newrec_.default_position:= DEFAULT_POSITION_TRUE;
   New___(newrec_);
END Create_And_Replace_position;

--  Get_Def_Position_For_Object
--    Returns the default position for an object in an attribute string
@UncheckedAccess
FUNCTION Get_Def_Position_For_Object (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
   CURSOR get_rec IS
      SELECT *
        FROM map_position_tab
       WHERE lu_name          = lu_name_
         AND key_ref          = key_ref_
         AND default_position = 1;
BEGIN
   FOR rec_ IN get_rec LOOP

      Client_SYS.Clear_Attr(attr_);

      RETURN Pack___(rec_);

   END LOOP;

   RETURN null;

END Get_Def_Position_For_Object;

--  Get_Def_Position_For_Object
--    Returns the default position for an object as longitude, latitude and 
--    altitude values, separated by semicolons.
@UncheckedAccess
FUNCTION Get_Def_Position_Long_Lat_Alt (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_rec IS
      SELECT *
        FROM map_position_tab
       WHERE lu_name          = lu_name_
         AND key_ref          = key_ref_
         AND default_position = 1;
BEGIN
   FOR rec_ IN get_rec LOOP
      RETURN rec_.longitude || ';' || rec_.latitude || ';' || rec_.altitude;
   END LOOP;

   RETURN null;

END Get_Def_Position_Long_Lat_Alt;

--  Remove_Position_For_Object
--    Removes all positions for an object
PROCEDURE Remove_Position_For_Object (
   lu_name_      IN VARCHAR2,
   key_ref_      IN VARCHAR2)
IS
   remrec_              MAP_POSITION_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT *
        FROM map_position_tab
       WHERE lu_name   = lu_name_
         AND key_ref   = key_ref_;
BEGIN
   FOR rec_ IN get_rec LOOP
      remrec_ := rec_;
      Remove___(remrec_);
   END LOOP;

END Remove_Position_For_Object;


PROCEDURE Retrieve_Map_Position (
   address_  IN VARCHAR2,
   lu_name_  IN VARCHAR2,
   key_ref_  IN VARCHAR2 )
IS
   url_params_             Plsqlap_Document_API.Document;
   query_params_           Plsqlap_Document_API.Document;
   addr_param_             VARCHAR2(4000);
   lu_name_and_key_ref_    VARCHAR2(1000) := '';
BEGIN
   IF lu_name_ IS NULL OR key_ref_ IS NULL THEN
      Error_SYS.Record_General(Map_Position_API.lu_name_, 'MPPSNLUKEYNULL: Lu Name and Key Reference must have values.');
   END IF;
   
   url_params_   := Plsqlap_Document_API.New_Document('url_params');
   Plsqlap_Document_API.Add_Attribute(url_params_, 'Param1', '');
   
   query_params_ := Plsqlap_Document_API.New_Document('query_parameters');
   addr_param_   := Utl_URL.Escape(address_, TRUE, NULL);
   Plsqlap_Document_API.Add_Attribute(query_params_, 'q',      addr_param_);
   Plsqlap_Document_API.Add_Attribute(query_params_, 'limit',  '1');
   Plsqlap_Document_API.Add_Attribute(query_params_, 'apiKey', Prepare_Call___('Wk9ZWDRySmNFQjJTT0VMdUUxbzBfOVliWjJjdDhrNlBPYlBOV3ZlVm5JVQ=='));
   
   lu_name_and_key_ref_ := key_ref_;
   Client_SYS.Add_To_Key_Reference(lu_name_and_key_ref_, 'PARAM_LU_NAME', lu_name_);

   Plsql_Rest_Sender_API.Call_Rest_EndPoint_Empty_Body2(rest_service_        => 'GEOCODING_SERVICE',
                                                        url_params_          =>  url_params_,
                                                        callback_func_       =>  'Map_Position_API.Retrieve_Map_Position_Callback',
                                                        http_method_         =>  'GET',
                                                        query_parameters_    =>  query_params_,
                                                        incld_resp_info_     =>  TRUE,
                                                        fnd_user_            =>  Fnd_Session_API.Get_Fnd_User,
                                                        key_ref_             =>  lu_name_and_key_ref_ );
END Retrieve_Map_Position;


PROCEDURE Retrieve_Map_Position_Callback (
   response_         IN CLOB,
   app_msg_id_       IN VARCHAR2,
   fnd_user_         IN VARCHAR2,
   key_ref_          IN VARCHAR2,
   response_code_    IN VARCHAR2 DEFAULT NULL,
   headers_          IN VARCHAR2 DEFAULT NULL )
IS
   newrec_              map_position_tab%ROWTYPE;
      
   json_str_            CLOB;
   start_               NUMBER;
   end_                 NUMBER;
   json_obj_            JSON_OBJECT_T;
   json_ary_            JSON_ARRAY_T;
   
   longitude_           NUMBER;
   latitude_            NUMBER;
   
   lu_name_             VARCHAR2(30);
   lu_name_and_key_ref_ VARCHAR2(1000);
   param_key_ref_       VARCHAR2(1000);
   temp_key_ref_        VARCHAR2(100);
BEGIN
   BEGIN
      start_     := instr(response_, '{');
      end_       := instr(response_, '}', -1);
      json_str_  := substr(response_, start_, end_ - start_ + 1);

      json_obj_  := JSON_OBJECT_T.Parse(json_str_);
      json_ary_  := json_obj_.get_array('items');
      json_obj_  := TREAT(json_ary_.get(0) AS JSON_OBJECT_T);
      json_obj_  := json_obj_.get_object('position');

      longitude_ := json_obj_.get_number('lng');
      latitude_  := json_obj_.get_number('lat');
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Record_General(Map_Position_API.lu_name_, 'MPPSNNOTFUND: Map positions not found by the geocoder.');
   END;
   
   IF key_ref_ IS NOT NULL THEN
      lu_name_and_key_ref_ := Utl_I18n.Unescape_Reference(key_ref_);
      lu_name_             := Client_SYS.Get_Key_Reference_Value(lu_name_and_key_ref_, 'PARAM_LU_NAME');
      
      -- Remove the lu_name_ part from lu_name_and_key_ref_.
      Client_SYS.Add_To_Key_Reference(temp_key_ref_, 'PARAM_LU_NAME', lu_name_);
      param_key_ref_       := REPLACE(lu_name_and_key_ref_, temp_key_ref_);
      
      newrec_.lu_name         := lu_name_;
      newrec_.key_ref         := param_key_ref_;
      newrec_.longitude       := longitude_;
      newrec_.latitude        := latitude_;
      newrec_.created_by      := fnd_user_;
      newrec_.created_date    := sysdate;
      newrec_.modified_by     := fnd_user_;
      newrec_.modified_date   := sysdate;
      newrec_.geocoded        := 'TRUE';
      
      New___(newrec_);
   END IF;
END Retrieve_Map_Position_Callback;

@UncheckedAccess
FUNCTION Get_Default_Latitude (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN NUMBER
IS
   latitude_ map_position_tab.latitude%TYPE;
BEGIN
   IF (lu_name_ IS NULL OR key_ref_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT latitude
     INTO latitude_
     FROM map_position_tab
    WHERE lu_name = lu_name_
      AND key_ref = key_ref_
      AND default_position = DEFAULT_POSITION_TRUE;
   RETURN latitude_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Error_SYS.Record_General(lu_name_, 'TOOMANYDEFPOSFOUND: Too many default position records found for :P1.', key_ref_);
END Get_Default_Latitude;

@UncheckedAccess
FUNCTION Get_Default_Longitude (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN NUMBER
IS
   longitude_ map_position_tab.longitude%TYPE;
BEGIN
   IF (lu_name_ IS NULL OR key_ref_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT longitude
     INTO longitude_
     FROM map_position_tab
    WHERE lu_name = lu_name_
      AND key_ref = key_ref_
      AND default_position = DEFAULT_POSITION_TRUE;
   RETURN longitude_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Error_SYS.Record_General(lu_name_, 'TOOMANYDEFPOSFOUND: Too many default position records found for :P1.', key_ref_);
END Get_Default_Longitude;
-------------------- LU  NEW METHODS -------------------------------------
