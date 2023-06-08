-----------------------------------------------------------------------------
--
--  Logical unit: InventoryLocationGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151016  JeLise  LIM-3893, Removed the override of Check_Insert___ since it was pallet related.
--  130410  Asawlk  EBALL-37, Added new location group 'PART EXCHANGE' and modified the code accordingly. 
--  120525  JeLise  Made description private.
--  120507  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120216  LEPESE  Added method Exist_With_Wildcard.
--  110427  MatKSE  Modified the type of global variable micro_cache_location_group_ to VARCHAR2(20)
--  101221  DaZase  Implemented Micro Cache. Added new mehods Invalidate_Cache___ and Update_Cache___.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  061115  LEPESE  Added method Get_Description in the second package PKG2.
--  061115          moved business logic from Get_Control_Type_Value_Desc to Get_Description.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  050919  NiDalk  Removed unused variables.
--  050322  AnLaSe  SCJP625: Modified VIEW4 to include DELIVERY CONFIRM,
--                  Modified methods Exist, Get_Control_Type_Value_Desc, Get_Inventory_Location_Type_Db.
--  040526  SHVESE  M4/Transibal merge: Modified VIEW4 to Include INT ORDER TRANSIT,
--  040526          Modified methods Exist, Get_Control_Type_Value_Desc, Get_Inventory_Location_Type_Db.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes ---------------------
--  021028  LEPESE  Bug 32465, created new package for methods needed since InventoryLocationGroup
--                  is used as control type C83 in ACCRUL.
--  020215  LEPESE  Added method Get_Control_Type_Value_Desc.
--  000925  JOHESE  Added undefines.
--  000218  LEPE    Added view INVENTORY_LOCATION_GROUP_LOV1.
--  990419  JOHW    General performance improvements.
--  990413  JOHW    Upgraded to performance optimized template.
--  980625  GOPE    Added Get_Inventory_Location_Type_Db to get the db value to be used in checks
--  971127  GOPE    Upgrade to fnd 2.0
--  970509  LEPE    Added function Verify_Group_Type.
--  970402  MAGN    Added controll of locationtype when Pallet handling is off.
--  970319  MAGN   CREATED.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Verify_Group_Type
--   This function is used to verify if a location group is of a certain
--   inventory location type. If it is, then the group will be returned,
--   otherwise NULL is returned.
--   The inventory location attribute to send is the DB value.
@UncheckedAccess
FUNCTION Verify_Group_Type (
   location_group_             IN VARCHAR2,
   inventory_location_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR isVerified IS
      SELECT 1
      FROM INVENTORY_LOCATION_GROUP_TAB
      WHERE location_group = location_group_
      AND inventory_location_type = inventory_location_type_db_;
BEGIN
   OPEN isVerified;
   FETCH isVerified INTO dummy_;
   IF isVerified%FOUND THEN
      CLOSE isVerified;
      RETURN location_group_;
   ELSE
      CLOSE isVerified;
      RETURN NULL;
   END IF;
END Verify_Group_Type;


PROCEDURE Exist_With_Wildcard (
   location_group_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   exist_ BOOLEAN;

   CURSOR exist_control IS
      SELECT 1
        FROM INVENTORY_LOCATION_GROUP_TAB
       WHERE location_group LIKE NVL(location_group_,'%');
BEGIN
   
   IF (INSTR(NVL(location_group_,'%'), '%') = 0) THEN
      --No wildcard
      Exist(location_group_);
   ELSE
      --Wildcard
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      exist_ := exist_control%FOUND;
      CLOSE exist_control;

      IF (NOT exist_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: Search criteria :P1 does not match any Location Group', location_group_);
      END IF;
   END IF;

END Exist_With_Wildcard;

@UncheckedAccess
FUNCTION Get_Description (
   location_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_location_group_tab.description%TYPE;
BEGIN
   IF (location_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'InventoryLocationGroup',
              location_group), description), 1, 35)
      INTO  temp_
      FROM  inventory_location_group_tab
      WHERE location_group = location_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(location_group_, 'Get_Description');
END Get_Description;


