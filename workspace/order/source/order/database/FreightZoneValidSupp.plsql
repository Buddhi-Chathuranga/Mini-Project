-----------------------------------------------------------------------------
--
--  Logical unit: FreightZoneValidSupp
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110913  NaLrlk   Added a method Check_Exist.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080917  MaHplk   Added new public function Check_Supp_Exist_For_Ship_Via and modified Unpack_Check_Insert___.
--  080912  MaHplk   Modified view comments of zone_definition_id and supplier_id.
--  080812  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Supp_Exist_For_Ship_Via
--   This function will check whether there are any freight map is defined for
--   same supplier and ship via code combination for given supplier and freight map Id.
@UncheckedAccess
FUNCTION Check_Supp_Exist_For_Ship_Via (
   freight_map_id_ IN VARCHAR2,
   supplier_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_   VARCHAR2(3);
   dummy_           NUMBER;
   
   CURSOR exist_control(supplier_id_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS
      SELECT 1
      FROM   freight_map_tab fm, freight_zone_valid_supp_tab fzvs
      WHERE  fm.freight_map_id = fzvs.freight_map_id
      AND    fzvs.supplier_id = supplier_id_
      AND    fm.ship_via_code = ship_via_code_;
BEGIN
   ship_via_code_ := Freight_Map_API.Get_Ship_Via_Code(freight_map_id_);
   OPEN exist_control(supplier_id_, ship_via_code_);
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';  
END Check_Supp_Exist_For_Ship_Via;


-- Check_Exist
--   Returns TRUE if a record exist for the given freight_map_id and supplier_id.
@UncheckedAccess
FUNCTION Check_Exist (
   freight_map_id_ IN VARCHAR2,
   supplier_id_    IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(freight_map_id_, supplier_id_);
END Check_Exist;



