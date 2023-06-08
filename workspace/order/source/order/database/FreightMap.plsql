-----------------------------------------------------------------------------
--
--  Logical unit: FreightMap
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  110425  NaLrlk   Added method Get_Freight_Map_For_Supp_Zone.
--  100811  MaHplk   Added new method Get_Freight_Map_Id.
--  100423  JeLise   Renamed from FreightZoneDefinition to FreightMap.
--  090525  KiSalk   Added basic data translation.
--  080926  MaJalk   Added method Get_Zone_Definition_Id.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080912  MaHplk   Modified view comment of zone_definition_id.
--  080814  MaHplk   Modified Insert and update methods to add owning site as valid site.
--  080806  RoJalk   Change the scope of the description attribute to be public.
--  080804  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FREIGHT_MAP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   target_info_       VARCHAR2(2000);
   target_attr_       VARCHAR2(2000);
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   IF newrec_.owning_site IS NOT NULL AND newrec_.freight_map_id IS NOT NULL THEN
      Client_SYS.Add_To_Attr('CONTRACT', newrec_.owning_site, target_attr_);
      Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', newrec_.freight_map_id, target_attr_);
      Freight_Zone_Valid_Site_API.New(target_info_, target_attr_);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FREIGHT_MAP_TAB%ROWTYPE,
   newrec_     IN OUT FREIGHT_MAP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   target_info_       VARCHAR2(2000);
   target_attr_       VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF newrec_.owning_site IS NOT NULL AND newrec_.owning_site != oldrec_.owning_site AND 
      NOT(Freight_Zone_Valid_Site_API.Check_Exist(newrec_.owning_site, newrec_.freight_map_id)) THEN
      Client_SYS.Add_To_Attr('CONTRACT', newrec_.owning_site, target_attr_);
      Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', newrec_.freight_map_id, target_attr_);
      Freight_Zone_Valid_Site_API.New(target_info_, target_attr_);
   END IF;
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   freight_map_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ freight_map_tab.description%TYPE;
BEGIN
   IF (freight_map_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'FreightMap',
      freight_map_id_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   freight_map_tab
   WHERE  freight_map_id = freight_map_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(freight_map_id_, 'Get_Description');
END Get_Description;

-- Get_Freight_Map_Id
--   This will return freight_map_id for given ship_via_code, contract and zone_id.
@UncheckedAccess
FUNCTION Get_Freight_Map_Id (
   ship_via_code_ IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FREIGHT_MAP_TAB.freight_map_id%TYPE;
   CURSOR get_attr IS
      SELECT fzt.freight_map_id
      FROM  FREIGHT_MAP_TAB fzt, freight_zone_valid_site_tab vst
      WHERE fzt.freight_map_id = vst.freight_map_id
      AND   fzt.ship_via_code = ship_via_code_
      AND   vst.contract = contract_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Freight_Map_Id;


-- Get_Freight_Map_Id
--   This will return freight_map_id for given ship_via_code, contract and zone_id.
@UncheckedAccess
FUNCTION Get_Freight_Map_Id (
   ship_via_code_ IN VARCHAR2,
   contract_      IN VARCHAR2,
   zone_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FREIGHT_MAP_TAB.freight_map_id%TYPE;
   CURSOR get_freight_map_id IS
      SELECT fm.freight_map_id                 
      FROM   freight_zone_tab fz, freight_map_tab fm, freight_zone_valid_site_tab fzvs
         WHERE fz.freight_map_id = fm.freight_map_id
         AND   fm.freight_map_id = fzvs.freight_map_id 
         AND   fm.ship_via_code = ship_via_code_
         AND   fz.zone_id = zone_id_
         AND   fzvs.contract = contract_;
BEGIN
   OPEN get_freight_map_id;
   FETCH get_freight_map_id INTO temp_;
   CLOSE get_freight_map_id;
   RETURN temp_;
END Get_Freight_Map_Id;


-- Get_Freight_Map_For_Supp_Zone
--   This will return freight_map_id for given ship_via_code,
--   supplier_id and zone_id.
@UncheckedAccess
FUNCTION Get_Freight_Map_For_Supp_Zone (
   ship_via_code_ IN VARCHAR2,
   supplier_id_   IN VARCHAR2,
   zone_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FREIGHT_MAP_TAB.freight_map_id%TYPE;
   CURSOR get_freight_map_id IS
      SELECT fm.freight_map_id                 
      FROM   freight_zone_tab fz, freight_map_tab fm, freight_zone_valid_supp_tab fzvs
      WHERE fz.freight_map_id = fm.freight_map_id
      AND   fm.freight_map_id = fzvs.freight_map_id 
      AND   fm.ship_via_code = ship_via_code_
      AND   fz.zone_id = zone_id_
      AND   fzvs.supplier_id = supplier_id_;
BEGIN
   OPEN get_freight_map_id;
   FETCH get_freight_map_id INTO temp_;
   CLOSE get_freight_map_id;
   RETURN temp_;
END Get_Freight_Map_For_Supp_Zone;



