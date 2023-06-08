-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartDefLoc
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190729  ChFolk  SCUXXW4-23311, Addedn method Check_If_Location_Default_Db to be used in Aurena client.
--  151020  Chfose  LIM-3893, Removed pallet location type specific code and refactored code in Check_Insert___ and Check_Update___ into Check_Common___.
--  120827  AyAmlk  Bug 104632, Added Get_Location_No() to get the location no for a part at a site when location type is Picking, Floor Stock or Manufacturing.
--  120313  JeLise  Added check in method Copy to see if the copying of part is within the same site, if not we will not copy default locations.
--  111024  MaEelk  Added UAS Filter to INVENTORY_PART_DEF_LOC.
--  110926  MaEelk  Change the prompt of INVENTORY_PART_DEF_LOC to Inventory Part Default Location
--  110314  DaZase  Changed calls to Inventory_Part_Pallet_API.Check_Exist so it uses Inventory_Part_API.Pallet_Handled instead.
--  100510  KRPELK  Merge Rose Method Documentation.
--  100218  PraWlk  Bug 87698, Added public function Get_Picking_Location_No(). 
--  ------------------------------- Eagle ----------------------------------
--  100421  JeLise  Added check on Receipts Blocked in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  -------------------------- Best Price -------------------------------------
--  090528  SaWjlk  Bug 83173, Removed the prog text duplications.
--  080710  SuSalk  Bug 75024, Modified Unpack_Check_Insert___ to handle location_type 
--  080710          when it's null.
--  050919  NiDalk  Removed unused variables.
--  050119  KeFelk  Rewriten the Copy method which makes the code easier to read.
--  041216  JaBalk  Removed default TRUE parameter from copy method.
--  041214  JaBalk  Added copy method.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes ---------------------
--  020312  HECESE  Bug 27591, Added check for supply type DOP and Default Location Pallet Delivery
--                  in Unpack_Check_Update___ and Unpack_Check_Insert___.
--  010103  JOHW    Corrected Modify_Default_Location.
--  000925  JOHESE  Added undefines.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990422  ANHO    General performance improvements and removed Delete_Default_Location.
--  990412  ANHO    Upgraded to performance optimized template.
--  990305  SHVE    Changed error messages for default locations.
--  990215  DAZA    Changed DEFAULT value to NULL in Check_Default_Location and
--                  added variable location_group_ to handle this default setting instead.
--  980720  FRDI    Reconstruction of inventory location key
--  980605  SHVE    IID 813: Added column location_type and required functionality.
--  980223  GOPE    Added call to CreateDefaultLocation in ModifyDefaultLocation
--                  if no default location exist.
--  971127  GOPE    Upgrade to fnd 2.0
--  970424  CHAN    Added restriction for what locations can be used as default.
--  970312  CHAN    Changed table name: mpc_partloc_characteristics is
--                  replaced by inventory_part_def_loc_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970113  MAOR    Added fetch of contract before loop in Unpack_Check_Insert___.
--  961213  LEPE    Modified for new template standard.
--  961120  MAOR    Added reference to Inventory_Part and cascade delete.
--  961114  MAOR    Changed to new Workbench.
--  961105  MAOR    Modified file to Rational Rose Model-standard.
--  961008  MAOR    Removed check if notfound in procedure Get_Default_Location.
--  960607  JOBE    Added functionality to CONTRACT.
--  960307  JICE    Renamed from InvDefaultPartLocation
--  951208  STOL    Added procedure/function Get_Default_Location.
--                  Used by Inv_Part_Location.Get_Default_Location__.
--                  (FIX! The functionality is probably already provided by
--                  existing public services, check when time.)
--  951113  LEPE    Added public function Check_If_Location_Default
--  951031  SHVE    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN            inventory_part_def_loc_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY inventory_part_def_loc_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   Warehouse_Bay_Bin_API.Check_Receipts_Blocked(newrec_.contract, newrec_.location_no);

   IF (newrec_.location_type IN (Inventory_Location_Type_API.DB_PICKING,
                                 Inventory_Location_Type_API.DB_FLOOR_STOCK,
                                 Inventory_Location_Type_API.DB_PRODUCTION_LINE)) THEN
      IF (Get_Location_No(newrec_.contract, newrec_.part_no) IS NOT NULL) AND 
         (NOT Check_Exist___(newrec_.contract, newrec_.part_no, newrec_.location_type)) THEN
         Error_SYS.Record_General('InventoryPartDefLoc', 'ONE_STOCK_TYPE: Only one default location of the types :P1, :P2 or :P3 can be entered.',
                                  Inventory_Location_Type_API.Decode(Inventory_Location_Type_API.DB_PICKING),
                                  Inventory_Location_Type_API.Decode(Inventory_Location_Type_API.DB_FLOOR_STOCK),
                                  Inventory_Location_Type_API.Decode(Inventory_Location_Type_API.DB_PRODUCTION_LINE));
      END IF;
   ELSIF (newrec_.location_type NOT IN (Inventory_Location_Type_API.DB_ARRIVAL,
                                        Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) THEN
      Error_SYS.Record_General('InventoryPartDefLoc', 'NOT_VALID_DEF_LOC: A location of type :P1 is not valid as default location.',
                               Inventory_Location_Type_API.Decode(newrec_.location_type));
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_def_loc_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF ((newrec_.location_type IS NULL) AND (newrec_.contract IS NOT NULL) AND (newrec_.location_no IS NOT NULL))THEN
      newrec_.location_type := Inventory_Location_API.Get_Location_Type_Db(newrec_.contract,
                                                                           newrec_.location_no);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Location_No
--   Fetches the location no for a part at a site for location type Picking,
--   F or Manufacturing
--   Fetches the location no for a part at a site for location type Picking,
--   Floor Stock or Manufacturing
@UncheckedAccess
FUNCTION Get_Location_No (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ INVENTORY_PART_DEF_LOC_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   location_type IN ('PICKING','F','MANUFACTURING');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Location_No;


-- Get_Location_No
--   Fetches the location no for a part at a site for location type Picking,
--   F or Manufacturing
--   Fetches the location no for a part at a site for location type Picking,
--   Floor Stock or Manufacturing
@UncheckedAccess
FUNCTION Get_Location_No (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   location_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ INVENTORY_PART_DEF_LOC_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM   INVENTORY_PART_DEF_LOC_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    location_type IN ('PICKING','F','MANUFACTURING')
      AND    location_type = NVL(location_type_db_, location_type);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Location_No;


-- Get_Arrival_Location_No
--   Fetches the location no for a part at a site for location type Arrival
@UncheckedAccess
FUNCTION Get_Arrival_Location_No (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ INVENTORY_PART_DEF_LOC_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   location_type IN ('ARRIVAL');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Arrival_Location_No;


-- Get_Qa_Location_No
--   Fetches the location no for a part at a site for location type QA
@UncheckedAccess
FUNCTION Get_Qa_Location_No (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ INVENTORY_PART_DEF_LOC_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   location_type IN ('QA');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Qa_Location_No;


-- Check_Default_Location
--   Returns TRUE if default location exists for this part, otherwise FALSE.
@UncheckedAccess
FUNCTION Check_Default_Location (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_group_type_ IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   location_type_        INVENTORY_PART_DEF_LOC.location_type%TYPE;
   location_group_       VARCHAR2(200);
   location_type_db_     INVENTORY_PART_DEF_LOC_TAB.location_type%TYPE;
BEGIN
   location_group_ := NVL(location_group_type_,'STOCK_TYPE');
   IF location_group_ = 'STOCK_TYPE' THEN
     location_type_ := INVENTORY_LOCATION_API.Get_Location_Type(contract_,Get_Location_No(contract_,part_no_));
   ELSIF location_group_ = 'ARRIVAL_TYPE' THEN
     location_type_ := INVENTORY_LOCATION_API.Get_Location_Type(contract_,Get_Arrival_Location_No(contract_,part_no_));
   ELSIF location_group_ = 'QA_TYPE' THEN
     location_type_ := INVENTORY_LOCATION_API.Get_Location_Type(contract_,Get_QA_Location_No(contract_,part_no_));
   END IF;
   location_type_db_ := Inventory_Location_Type_API.Encode(location_type_);
   RETURN (Check_Exist___(contract_, part_no_, location_type_db_));
END Check_Default_Location;


-- Check_If_Location_Default
--   Checks if the given location is default for the part, returns
--   DefaultInventoryLocation(0) if exists, otherwise DefaultInventoryLocation(1)
@UncheckedAccess
FUNCTION Check_If_Location_Default (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   counter_        NUMBER;
   CURSOR get_def_loc IS
      SELECT 1
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE part_no     = part_no_
      AND   contract    = contract_
      AND   location_type IN ('PICKING','F','MANUFACTURING')
      AND   location_no = location_no_;
BEGIN
   OPEN  get_def_loc;
   FETCH get_def_loc INTO counter_;
   IF (get_def_loc%FOUND) THEN
      CLOSE get_def_loc;
      RETURN(Default_Inventory_Location_API.Decode('Y'));
   END IF;
   CLOSE get_def_loc;
   RETURN(Default_Inventory_Location_API.Decode('N'));
END Check_If_Location_Default;

@UncheckedAccess
FUNCTION Check_If_Location_Default_Db (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   counter_        NUMBER;
   CURSOR get_def_loc IS
      SELECT 1
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE part_no     = part_no_
      AND   contract    = contract_
      AND   location_type IN ('PICKING','F','MANUFACTURING')
      AND   location_no = location_no_;
BEGIN
   OPEN  get_def_loc;
   FETCH get_def_loc INTO counter_;
   IF (get_def_loc%FOUND) THEN
      CLOSE get_def_loc;
      RETURN Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE get_def_loc;
   RETURN Fnd_Boolean_API.DB_FALSE;
END Check_If_Location_Default_Db;


-- Create_Default_Location
--   Sets the given location as default for the part.
PROCEDURE Create_Default_Location (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS
   attr_             VARCHAR2(32000);
   objid_            ROWID;
   objversion_       VARCHAR2(2000);
   newrec_           INVENTORY_PART_DEF_LOC_TAB%ROWTYPE;
   location_type_    INVENTORY_PART_DEF_LOC.location_type%TYPE;
   indrec_           Indicator_Rec;
BEGIN
   location_type_ := INVENTORY_LOCATION_API.Get_Location_Type(contract_,location_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('LOCATION_TYPE', location_type_, attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Default_Location;


-- Modify_Default_Location
--   Changes the default location for the given part. If no default location
--   exists the one will be created using the CreateDefaultLocation method.
PROCEDURE Modify_Default_Location (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 )
IS
   attr_                 VARCHAR2(32000);
   lu_rec_               INVENTORY_PART_DEF_LOC_TAB%ROWTYPE;
   oldrec_               INVENTORY_PART_DEF_LOC_TAB%ROWTYPE;
   newrec_               INVENTORY_PART_DEF_LOC_TAB%ROWTYPE;
   location_type_        INVENTORY_PART_DEF_LOC_TAB.location_type%TYPE;
   location_type_db_     INVENTORY_PART_DEF_LOC_TAB.location_type%TYPE;
   objid_                INVENTORY_PART_DEF_LOC.objid%TYPE;
   objversion_           INVENTORY_PART_DEF_LOC.objversion%TYPE;
   indrec_               Indicator_Rec;

BEGIN
   Trace_SYS.Message(contract_||' - '||part_no_||' - '||location_no_);
   location_type_    := INVENTORY_LOCATION_API.Get_Location_Type(contract_,location_no_);
   location_type_db_ := Inventory_Location_Type_API.Encode(location_type_);
   lu_rec_           := Get_Object_By_Keys___(contract_, part_no_, location_type_db_);
   IF lu_rec_.location_no IS NULL THEN
      Create_Default_Location(contract_, part_no_,location_no_);
   ELSE
      oldrec_ := Lock_By_Keys___(contract_, part_no_, location_type_db_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   END IF;
END Modify_Default_Location;


-- Copy
--   Method creates new instance and copies all attributes from old part's
--   default location.
PROCEDURE Copy (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_        INVENTORY_PART_DEF_LOC_TAB%ROWTYPE;
   objid_         INVENTORY_PART_DEF_LOC.objid%TYPE;
   objversion_    INVENTORY_PART_DEF_LOC.objversion%TYPE;
   attr_          VARCHAR2(32000);
   oldrec_found_  BOOLEAN := FALSE;
   indrec_        Indicator_Rec;
   
   CURSOR get_def_location_rec IS
      SELECT *
        FROM INVENTORY_PART_DEF_LOC_TAB
       WHERE part_no  = from_part_no_
         AND contract = from_contract_;
BEGIN
   
   IF from_contract_ = to_contract_ THEN 
      FOR oldrec_ IN get_def_location_rec LOOP
         IF (Check_Exist___(to_contract_, to_part_no_, oldrec_.location_type)) THEN
            IF (error_when_existing_copy_ = 'TRUE') THEN
               Error_SYS.Record_Exist(lu_name_, 'DEFLOCEXIST: A default location of type :P1 does already exist for part :P2 on site :P3.', Inventory_Location_Type_API.Decode(oldrec_.location_type), to_part_no_, to_contract_);
            END IF;
         ELSE      
            Client_SYS.Clear_Attr(attr_);
            newrec_     := NULL;
            objid_      := NULL;
            objversion_ := NULL;

            Client_SYS.Add_To_Attr('CONTRACT'        , to_contract_         , attr_);
            Client_SYS.Add_To_Attr('PART_NO'         , to_part_no_          , attr_);
            Client_SYS.Add_To_Attr('LOCATION_TYPE_DB', oldrec_.location_type, attr_);
            Client_SYS.Add_To_Attr('LOCATION_NO'     , oldrec_.location_no  , attr_);

            Unpack___(newrec_, indrec_, attr_);
            Check_Insert___(newrec_, indrec_, attr_);
            Insert___(objid_, objversion_, newrec_, attr_);      
         END IF;
         oldrec_found_ := TRUE;
      END LOOP;

      IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'LOCATIONNOTEXIST: Default Locations do not exist for Part :P1 on Site :P2', from_part_no_, from_contract_);
      END IF;
   END IF;
END Copy;


@UncheckedAccess
FUNCTION Get_Picking_Location_No  (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ INVENTORY_PART_DEF_LOC_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM INVENTORY_PART_DEF_LOC_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   location_type = 'PICKING';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Picking_Location_No;

