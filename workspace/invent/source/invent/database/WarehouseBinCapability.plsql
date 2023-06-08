-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseBinCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191118  SBalLK  Bug 150748 (SCZ-6531), Added Bin_Capability_Rec and Bin_Capability_Tab data types.
--  140509  JeLise  PBSC-9124, Added Check_Insert___ , so that removed is set to FALSE when not already set.
--  120307  LEPESE  Added method Copy__.
--  111121  JeLise  Made changes to Get_Operative_Capabilities to be able to call it from all levels in the navigator.
--  111121          Also added methods Check_And_Delete___ and Clear_Storage_Capabilities__.
--  111107  MaEelk  Removed the user allowed site filter from WH_BIN_OPERATIVE_CAP.
--  111102  MaEelk  Added UIV WH_BIN_OPERATIVE_CAP_UIV.
--  111027  MaEelk  Added user allowed site filter to WH_ROW_OPERATIVE_CAP
--  111027  MaEelk  Added user allowed site filter to WH_TIER_OPERATIVE_CAP
--  110914  JeLise  Added user allowed site filter to WH_BIN_OPERATIVE_CAP.
--  110718  MaEelk  Added user allowed site filter to WAREHOUSE_BIN_CAPABILITY.
--  100812  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Bin_Capability_Rec IS RECORD
  (storage_capability_id          WAREHOUSE_BIN_CAPABILITY_TAB.storage_capability_id%TYPE,
   location_no                    WAREHOUSE_BAY_BIN_TAB.location_no%TYPE);
   
TYPE Bin_Capability_Tab IS TABLE OF Bin_Capability_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('REMOVED', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


PROCEDURE Check_And_Delete___ (
   remrec_ IN WAREHOUSE_BIN_CAPABILITY_TAB%ROWTYPE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   
   Get_Id_Version_By_Keys___(objid_, 
                             objversion_,
                             remrec_.contract,
                             remrec_.warehouse_id,
                             remrec_.bay_id,
                             remrec_.tier_id,
                             remrec_.row_id,
                             remrec_.bin_id,
                             remrec_.storage_capability_id);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Check_And_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_bin_capability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.removed IS NULL)THEN  
      newrec_.removed := Fnd_Boolean_API.DB_FALSE; 
   END IF;   
   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Removed_Line__ (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   bay_id_                IN VARCHAR2,
   tier_id_               IN VARCHAR2,
   row_id_                IN VARCHAR2,
   bin_id_                IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2 )
IS
   attr_          VARCHAR2(32000);
   objid_         WAREHOUSE_BIN_CAPABILITY.objid%TYPE;
   objversion_    WAREHOUSE_BIN_CAPABILITY.objversion%TYPE;
   newrec_        WAREHOUSE_BIN_CAPABILITY_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
BEGIN

   IF (Check_Exist___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, storage_capability_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'WHBINCAPLINEEXIST: You cannot remove this capability because it already exists on this level, please remove the capability on this level first');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID', warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('BAY_ID', bay_id_, attr_);
   Client_SYS.Add_To_Attr('TIER_ID', tier_id_, attr_);
   Client_SYS.Add_To_Attr('ROW_ID', row_id_, attr_);
   Client_SYS.Add_To_Attr('BIN_ID', bin_id_, attr_);
   Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', storage_capability_id_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB', 'TRUE', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Removed_Line__;


PROCEDURE Clear_Storage_Capabilities__ (
   contract_            IN VARCHAR2,
   warehouse_id_        IN VARCHAR2,
   bay_id_              IN VARCHAR2,
   tier_id_             IN VARCHAR2,
   row_id_              IN VARCHAR2,
   bin_id_              IN VARCHAR2,
   all_capabilities_db_ IN BOOLEAN,
   capability_tab_      IN Storage_Capability_API.Capability_Tab )
IS
   remrec_ WAREHOUSE_BIN_CAPABILITY_TAB%ROWTYPE;
   
   CURSOR get_all_capabilities IS
      SELECT *
      FROM WAREHOUSE_BIN_CAPABILITY_TAB
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   tier_id      = tier_id_
      AND   row_id       = row_id_
      AND   bin_id       = bin_id_
      FOR UPDATE;
BEGIN
   
   IF (all_capabilities_db_) THEN
      FOR rec_ IN get_all_capabilities LOOP 
         Check_And_Delete___(rec_);
      END LOOP;
   ELSE
      IF (capability_tab_.COUNT > 0) THEN
         FOR i IN capability_tab_.FIRST..capability_tab_.LAST LOOP
            IF Check_Exist___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, capability_tab_(i).storage_capability_id) THEN
               remrec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_, capability_tab_(i).storage_capability_id);
               IF remrec_.removed = Fnd_Boolean_API.db_false THEN
                  Check_And_Delete___(remrec_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;
END Clear_Storage_Capabilities__;


PROCEDURE Copy__ (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   bay_id_                IN VARCHAR2,
   tier_id_               IN VARCHAR2,
   row_id_                IN VARCHAR2,
   bin_id_                IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_warehouse_id_       IN VARCHAR2,
   to_bay_id_             IN VARCHAR2,
   to_tier_id_            IN VARCHAR2,
   to_row_id_             IN VARCHAR2,
   to_bin_id_             IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      WAREHOUSE_BIN_CAPABILITY.objid%TYPE;
   objversion_ WAREHOUSE_BIN_CAPABILITY.objversion%TYPE;
   oldrec_     WAREHOUSE_BIN_CAPABILITY_TAB%ROWTYPE;
   newrec_     WAREHOUSE_BIN_CAPABILITY_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Get_Object_By_Keys___(contract_,
                                    warehouse_id_,
                                    bay_id_,
                                    tier_id_,
                                    row_id_,
                                    bin_id_,
                                    storage_capability_id_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT'             , to_contract_          , attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID'         , to_warehouse_id_      , attr_);
   Client_SYS.Add_To_Attr('BAY_ID'               , to_bay_id_            , attr_);
   Client_SYS.Add_To_Attr('TIER_ID'              , to_tier_id_           , attr_);
   Client_SYS.Add_To_Attr('ROW_ID'               , to_row_id_            , attr_);
   Client_SYS.Add_To_Attr('BIN_ID'               , to_bin_id_            , attr_);
   Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', storage_capability_id_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB'           , oldrec_.removed       , attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Operative_Capabilities (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 ) RETURN Storage_Capability_API.Capability_Tab
IS
   capability_tab_      Storage_Capability_API.Capability_Tab;
   rows_                PLS_INTEGER := 1;

   CURSOR get_bin_capabilities IS
      SELECT storage_capability_id
      FROM WH_BIN_OPERATIVE_CAP
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   tier_id      = tier_id_
      AND   row_id       = row_id_
      AND   bin_id       = bin_id_;

   CURSOR get_row_capabilities IS
      SELECT storage_capability_id
      FROM WH_ROW_OPERATIVE_CAP
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   row_id       = row_id_;

   CURSOR get_tier_capabilities IS
      SELECT storage_capability_id
      FROM WH_TIER_OPERATIVE_CAP
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   tier_id      = tier_id_;

   CURSOR get_bay_capabilities IS
      SELECT storage_capability_id
      FROM WH_BAY_OPERATIVE_CAP
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_;

   CURSOR get_warehouse_capabilities IS
      SELECT storage_capability_id
      FROM WAREHOUSE_OPERATIVE_CAP
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_;
BEGIN
   IF (bin_id_ IS NULL) THEN
      IF (row_id_ IS NULL) THEN
         IF (tier_id_ IS NULL) THEN
            IF (bay_id_ IS NULL) THEN
               IF (warehouse_id_ IS NULL) THEN
                  capability_tab_ := Site_Storage_Capability_API.Get_Capabilities(contract_);
               ELSE
                  OPEN get_warehouse_capabilities;
                  FETCH get_warehouse_capabilities BULK COLLECT INTO capability_tab_;
                  CLOSE get_warehouse_capabilities;
               END IF;
            ELSE
               OPEN get_bay_capabilities;
               FETCH get_bay_capabilities BULK COLLECT INTO capability_tab_;
               CLOSE get_bay_capabilities;
            END IF;
         ELSE
            OPEN get_tier_capabilities;
            FETCH get_tier_capabilities BULK COLLECT INTO capability_tab_;
            CLOSE get_tier_capabilities;
         END IF;
      ELSE
         IF (tier_id_ IS NULL) THEN
            OPEN get_row_capabilities;
            FETCH get_row_capabilities BULK COLLECT INTO capability_tab_;
            CLOSE get_row_capabilities;
         ELSE
            OPEN get_tier_capabilities;
            FETCH get_tier_capabilities BULK COLLECT INTO capability_tab_;
            CLOSE get_tier_capabilities;
            
            rows_ := capability_tab_.COUNT;
            
            FOR rec_ IN get_row_capabilities LOOP 
               rows_ := rows_ + 1;
               capability_tab_(rows_).storage_capability_id := rec_.storage_capability_id;
            END LOOP;
         END IF;
      END IF;
   ELSE
      OPEN get_bin_capabilities;
      FETCH get_bin_capabilities BULK COLLECT INTO capability_tab_;
      CLOSE get_bin_capabilities;
   END IF;

   RETURN (capability_tab_);
END Get_Operative_Capabilities;



