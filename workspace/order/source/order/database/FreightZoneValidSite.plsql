-----------------------------------------------------------------------------
--
--  Logical unit: FreightZoneValidSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111026  ChJalk   Added User Allowed Site filter to the view FREIGHT_ZONE_VALID_SITE.
--  110419  NaLrlk   Modified the error message CONTRACTEXIST in method Unpack_Check_Insert___.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080917  MaHplk   Added new public function Check_Site_Exist_For_Ship_Via and modified Unpack_Check_Insert___.
--  080912  MaHplk   Modified view comment of zone_definition_id.
--  080814  MaHplk   Added public method 'New'.
--  080805  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT freight_zone_valid_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF Check_Site_Exist_For_Ship_Via(newrec_.contract, newrec_.freight_map_id) = Fnd_Boolean_API.db_true THEN
      Error_SYS.Record_General(lu_name_, 'CONTRACTEXIST: Same Site and Ship via Code combination exist in another Freight Map.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   contract_       IN VARCHAR2,
   freight_map_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, freight_map_id_);
END Check_Exist;


-- New
--   Public interface for create new valid sites.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     FREIGHT_ZONE_VALID_SITE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   -- Retrieve the default attribute values.
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', Client_SYS.Get_Item_Value('FREIGHT_MAP_ID', attr_), new_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', Client_SYS.Get_Item_Value('CONTRACT', attr_), new_attr_);
   
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Check_Site_Exist_For_Ship_Via
--   This function will check whether there are any freight map is defined for
--   same contract and ship via code combination for given contract and freight map Id.
@UncheckedAccess
FUNCTION Check_Site_Exist_For_Ship_Via (
   contract_       IN VARCHAR2,
   freight_map_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_   VARCHAR2(3);
   dummy_           NUMBER;
   
   CURSOR exist_control(contract_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS
      SELECT 1
      FROM   freight_map_tab fm, freight_zone_valid_site_tab fzvs
      WHERE  fm.freight_map_id = fzvs.freight_map_id
      AND    fzvs.contract = contract_
      AND    fm.ship_via_code = ship_via_code_;
BEGIN
   ship_via_code_ := Freight_Map_API.Get_Ship_Via_Code(freight_map_id_);
   OPEN exist_control(contract_, ship_via_code_);
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';  
END Check_Site_Exist_For_Ship_Via;



