-----------------------------------------------------------------------------
--
--  Logical unit: FreightZone
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150214  NaLrlk   PRSC-5568, Removed Exist() method since it is no usage furthermore.
--  150114  ChJalk   PRSC-5079, Modified Check_Common___ to change the error message tag NULLBASECOUNTRY to NONNULLBASECOUNTRY.
--  110425  NaLrlk   Added Lov view FREIGHT_ZONE_SUPP_LOV.
--  100614  NWeelk   Bug 90108, Introduced new view FREIGHT_ZONE_JOIN. 
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--    100112   ShKolk    Added error message ZONE_DEF_NULL.
--  081023  MaHplk   Modified FREIGHT_ZONE view.
--  081022  MaHplk   Added private attribute zone_basis_priority.
--  081008  AmPalk   Modified Unpack_Check_Update___ by allwing description to get updated any time.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080916  MaHplk   Added new function Check_Lines_Exist, and modified Unpack_Check_Insert___, Unpack_Check_Update___.
--  080912  MaHplk   Modified view comments of zone_definition_id and zone_id.
--  080901  KiSalk   Returned FREIGHT_ZONE_BASIS_DB and BASE_COUNTRY_DB to client after Update and Insert.
--  080806  RoJalk   Change the scope of the description attribute to be public.
--  080804  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_zip_code_                  CONSTANT VARCHAR2(8) := Freight_Zone_Basis_API.db_zip_code;

db_city_                      CONSTANT VARCHAR2(4) := Freight_Zone_Basis_API.db_city;

db_county_                    CONSTANT VARCHAR2(6) := Freight_Zone_Basis_API.db_county;

db_state_                     CONSTANT VARCHAR2(5) := Freight_Zone_Basis_API.db_state;

db_country_                   CONSTANT VARCHAR2(7) := Freight_Zone_Basis_API.db_country;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
    
@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     freight_zone_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY freight_zone_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (NVL(oldrec_.base_country, CHR(32)) != NVL(newrec_.base_country, CHR(32))) OR (newrec_.freight_zone_basis != oldrec_.freight_zone_basis ) THEN
      IF (Check_Lines_Exist(newrec_.freight_map_id, newrec_.zone_id) = Fnd_Boolean_API.db_true) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTMODIFY: Can not modify the Base Country or Zone Defined By, since detail lines are exist.');
      END IF;
   END IF; 
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     freight_zone_tab%ROWTYPE,
   newrec_ IN OUT freight_zone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- Added 'Zone Basis Prioriy' based on freight zone basis. 
   IF (newrec_.freight_zone_basis = db_zip_code_) THEN
      newrec_.zone_basis_priority := 1;
   ELSIF (newrec_.freight_zone_basis = db_city_) THEN
      newrec_.zone_basis_priority := 2;
   ELSIF (newrec_.freight_zone_basis = db_county_) THEN
      newrec_.zone_basis_priority := 3;
   ELSIF (newrec_.freight_zone_basis = db_state_) THEN
      newrec_.zone_basis_priority := 4;
   ELSIF (newrec_.freight_zone_basis = db_country_) THEN
      newrec_.zone_basis_priority := 5;
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'ZONE_BASIS_PRIORITY', newrec_.zone_basis_priority);

   -- Return FREIGHT_ZONE_BASIS_DB and BASE_COUNTRY to client.
   Client_SYS.Set_Item_Value('FREIGHT_ZONE_BASIS_DB', newrec_.freight_zone_basis, attr_);
   Client_SYS.Set_Item_Value('BASE_COUNTRY', newrec_.base_country, attr_);

   IF (newrec_.freight_zone_basis = db_country_) AND (newrec_.base_country IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NONULLBASECOUNTRY: The Base Country field has to be blank when the Zone Defined By field has been set to Country.');
   END IF;
   
   IF  (newrec_.freight_zone_basis != db_country_) AND (newrec_.base_country IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULLBASECOUNTRY: The Base Country should have a value.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Lines_Exist (
   freight_map_id_ IN VARCHAR2,
   zone_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_  NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM   FREIGHT_ZONE_DETAILS_TAB
      WHERE  freight_map_id = freight_map_id_
      AND    zone_id = zone_id_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      RETURN 'TRUE';
   END IF;
   CLOSE check_exist;
   RETURN 'FALSE';
END Check_Lines_Exist;



