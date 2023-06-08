-----------------------------------------------------------------------------
--
--  Logical unit: StorageCapacityReqGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160221  HaPulk   STRSC-6333, Removal of DYNAMIC relationship to ACCRUL from INVENT.   
--  141210  RILASE   Removed Check_Values___.
--  130829  JeLise   Removed globals that was no longer used and checks that Invent is installed.
--  130516  IsSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120904  JeLise   Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120904  JeLise   Moved from Partca to Invent.
--  120814  JeLise   Added LOV view, to show Qty per Volume instead of Volume.
--  120616  MaEelk   Dynamic calls to Company_Invent_Info_API.Get_Uom_For_Volume was replaced with conditional compilation.
--  120615  MaMalk   Replaced Company_Distribution_Info_API.Get_Uom_For_Volume with Company_Invent_Info_API.Get_Uom_For_Volume.
--  120525  JeLise   Made description private.
--  110927  DaZase   Added extra dynamic calls in unpack methods to fetch uom_for_volume defaults 
--  110927           from user default company and also made sure values that was fetched/set 
--  110927           in server code are returned in the attribute string. Moved some code from 
--  110927           Insert___/Update to unpack methods.
--  100906  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@UncheckedAccess
FUNCTION Get_Description (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ storage_capacity_req_group_tab.description%TYPE;
BEGIN
   IF (capacity_req_group_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      capacity_req_group_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  storage_capacity_req_group_tab
      WHERE capacity_req_group_id = capacity_req_group_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(capacity_req_group_id_, 'Get_Description');
END Get_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT STORAGE_CAPACITY_REQ_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   Client_SYS.Add_To_Attr('UOM_FOR_VOLUME', newrec_.uom_for_volume, attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_LENGTH', newrec_.uom_for_length, attr_);
   Client_SYS.Add_To_Attr('WIDTH', newrec_.width, attr_);
   Client_SYS.Add_To_Attr('HEIGHT', newrec_.height, attr_);
   Client_SYS.Add_To_Attr('DEPTH', newrec_.depth, attr_);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     STORAGE_CAPACITY_REQ_GROUP_TAB%ROWTYPE,
   newrec_     IN OUT STORAGE_CAPACITY_REQ_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   Client_SYS.Add_To_Attr('UOM_FOR_VOLUME', newrec_.uom_for_volume, attr_);
   Client_SYS.Add_To_Attr('UOM_FOR_LENGTH', newrec_.uom_for_length, attr_);
   Client_SYS.Add_To_Attr('WIDTH', newrec_.width, attr_);
   Client_SYS.Add_To_Attr('HEIGHT', newrec_.height, attr_);
   Client_SYS.Add_To_Attr('DEPTH', newrec_.depth, attr_);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT storage_capacity_req_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.volume IS NOT NULL AND newrec_.uom_for_volume IS NULL) THEN      
      newrec_.uom_for_volume := Company_Invent_Info_API.Get_Uom_For_Volume(User_Finance_API.Get_Default_Company_Func);      
   END IF;

   IF newrec_.volume IS NOT NULL THEN
      IF newrec_.uom_for_length IS NULL THEN
         newrec_.uom_for_length := RTRIM(newrec_.uom_for_volume, '3');
      END IF;
      newrec_.width  := NVL(newrec_.width, 0);
      newrec_.height := NVL(newrec_.height, 0);
      newrec_.depth  := NVL(newrec_.depth, 0);
   END IF;

   Part_Catalog_Invent_Attrib_API.Check_Storage_Capacity_Uom(newrec_.width, newrec_.height, newrec_.depth, newrec_.uom_for_length,
                                                           newrec_.weight, newrec_.uom_for_weight);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.height);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.width);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.depth);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.weight);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     storage_capacity_req_group_tab%ROWTYPE,
   newrec_ IN OUT storage_capacity_req_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_        VARCHAR2(30);
   value_       VARCHAR2(4000);
   number_null_ NUMBER := -9999999;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.volume IS NOT NULL AND newrec_.uom_for_volume IS NULL) THEN      
      newrec_.uom_for_volume := Company_Invent_Info_API.Get_Uom_For_Volume(User_Finance_API.Get_Default_Company_Func);
   END IF;

   IF newrec_.volume IS NOT NULL THEN
      IF newrec_.uom_for_length IS NULL THEN
         newrec_.uom_for_length := RTRIM(newrec_.uom_for_volume, '3');
      END IF;
      newrec_.width  := NVL(newrec_.width, 0);
      newrec_.height := NVL(newrec_.height, 0);
      newrec_.depth  := NVL(newrec_.depth, 0);
   END IF;

   IF ((NVL(newrec_.width, number_null_) != NVL(oldrec_.width, number_null_)) OR
      (NVL(newrec_.height, number_null_) != NVL(oldrec_.height, number_null_)) OR
      (NVL(newrec_.depth, number_null_) != NVL(oldrec_.depth, number_null_)) OR
      (NVL(newrec_.uom_for_length, Database_Sys.string_null_) != NVL(oldrec_.uom_for_length, Database_Sys.string_null_)) OR
      (NVL(newrec_.weight, number_null_) != NVL(oldrec_.weight, number_null_)) OR
      (NVL(newrec_.uom_for_weight, Database_Sys.string_null_) != NVL(oldrec_.uom_for_weight, Database_Sys.string_null_))) THEN
      Part_Catalog_Invent_Attrib_API.Check_Storage_Capacity_Uom(newrec_.width, newrec_.height, newrec_.depth, newrec_.uom_for_length,
				                                                newrec_.weight, newrec_.uom_for_weight);
   END IF;

   IF (NVL(newrec_.width, number_null_) != NVL(oldrec_.width, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.width);
   END IF;
   IF (NVL(newrec_.height, number_null_) != NVL(oldrec_.height, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.height);
   END IF;
   IF (NVL(newrec_.depth, number_null_) != NVL(oldrec_.depth, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.depth);
   END IF;
   IF (NVL(newrec_.weight, number_null_) != NVL(oldrec_.weight, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.weight);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Storage_Width_Req_Source (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   width_source_ VARCHAR2(200);
   temp_         STORAGE_CAPACITY_REQ_GROUP_TAB.width%TYPE;

   CURSOR get_attr IS
      SELECT width
      FROM STORAGE_CAPACITY_REQ_GROUP_TAB
      WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      width_source_ := NULL;
   ELSE
      width_source_ := Part_Structure_Level_API.Decode('CAPACITY_GROUP');
   END IF;
   RETURN (width_source_);
END Get_Storage_Width_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Height_Req_Source (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   height_source_ VARCHAR2(200);
   temp_          STORAGE_CAPACITY_REQ_GROUP_TAB.height%TYPE;

   CURSOR get_attr IS
      SELECT height
      FROM STORAGE_CAPACITY_REQ_GROUP_TAB
      WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      height_source_ := NULL;
   ELSE
      height_source_ := Part_Structure_Level_API.Decode('CAPACITY_GROUP');
   END IF;
   RETURN (height_source_);
END Get_Storage_Height_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Depth_Req_Source (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   depth_source_ VARCHAR2(200);
   temp_         STORAGE_CAPACITY_REQ_GROUP_TAB.depth%TYPE;

   CURSOR get_attr IS
      SELECT depth
      FROM STORAGE_CAPACITY_REQ_GROUP_TAB
      WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      depth_source_ := NULL;
   ELSE
      depth_source_ := Part_Structure_Level_API.Decode('CAPACITY_GROUP');
   END IF;
   RETURN (depth_source_);
END Get_Storage_Depth_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Source (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   volume_source_ VARCHAR2(200);
   temp_          STORAGE_CAPACITY_REQ_GROUP_TAB.volume%TYPE;

   CURSOR get_attr IS
      SELECT volume
      FROM STORAGE_CAPACITY_REQ_GROUP_TAB
      WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      volume_source_ := NULL;
   ELSE
      volume_source_ := Part_Structure_Level_API.Decode('CAPACITY_GROUP');
   END IF;
   RETURN (volume_source_);
END Get_Storage_Volume_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Weight_Req_Source (
   capacity_req_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   weight_source_ VARCHAR2(200);
   temp_          STORAGE_CAPACITY_REQ_GROUP_TAB.weight%TYPE;

   CURSOR get_attr IS
      SELECT weight
      FROM STORAGE_CAPACITY_REQ_GROUP_TAB
      WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ IS NULL) THEN
      weight_source_ := NULL;
   ELSE
      weight_source_ := Part_Structure_Level_API.Decode('CAPACITY_GROUP');
   END IF;
   RETURN (weight_source_);
END Get_Storage_Weight_Req_Source;



