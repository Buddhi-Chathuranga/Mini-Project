-----------------------------------------------------------------------------
--
--  Logical unit: FreightZoneDetails
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190102  ChJalk   SCUXXW4-9200, Overriden the method Insert___ to get the value of item_no before inserting.
--  130910  ErFelk   Bug 111147, Modified Get_Next_Item_No() by removing zone_id condition and moving the return statement to the end of the fucntion.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090225  ChJalk   Bug 80723, Added the IN parameter zone_definition_id_ to the method Validate_Zip_Code___.
--  090123  ShKolk   Added Validate_Zip_Code___() to validate overlapping Zip Code ranges.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080912  MaHplk   Modified view comments of zone_definition_id and zone_id.
--  080825  MaHplk   Added new method Validate_Discrete_Value___ and modified Unpack_Check_Insert___
--                   and Unpack_Check_Update___.
--  080815  MaHplk   Added new method Get_Value_Description.
--  080804  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Discrete_Value___ (
   freight_map_id_ IN VARCHAR2,
   zone_id_        IN VARCHAR2,
   discrete_value_ IN VARCHAR2,
   base_country_   IN VARCHAR2,
   zone_basis_     IN VARCHAR2)
IS
   value_        VARCHAR2(100);

   CURSOR check_state IS
      SELECT 1 
      FROM STATE_CODES_TAB
      WHERE country_code = base_country_
      AND state_code = discrete_value_;

   CURSOR check_county IS
      SELECT 1 
      FROM COUNTY_CODE_TAB
      WHERE country_code = base_country_
      AND county_code = discrete_value_;

   CURSOR check_city IS
      SELECT 1 
      FROM CITY_CODE_TAB
      WHERE country_code = base_country_
      AND city_code = discrete_value_;
BEGIN
   IF zone_basis_ = 'COUNTRY' THEN
      value_ := Iso_Country_API.Get_Description(discrete_value_);
      IF value_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCOUNTRY: :P1 is invalid country. Please enter valid country or select from list of values',discrete_value_);
      END IF;
   ELSIF zone_basis_ = 'STATE' THEN
      OPEN check_state;
      FETCH check_state INTO value_;
      IF check_state%NOTFOUND THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDSTATE: :P1 is invalid state. Please enter valid state or select from list of values',discrete_value_);
      END IF;
      CLOSE check_state;
   ELSIF zone_basis_ = 'COUNTY' THEN
      OPEN check_county;
      FETCH check_county INTO value_;
      IF check_county%NOTFOUND THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCOUNTY: :P1 is invalid county. Please enter valid county or select from list of values',discrete_value_);
      END IF;
      CLOSE check_county;
   ELSIF zone_basis_ = 'CITY' THEN
      OPEN check_city;
      FETCH check_city INTO value_;
      IF check_city%NOTFOUND THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCITY: :P1 is invalid city. Please enter valid city or select from list of values',discrete_value_);
      END IF;
      CLOSE check_city;
   END IF;
END Validate_Discrete_Value___;


PROCEDURE Validate_Zip_Code___(
   freight_map_id_ IN VARCHAR2,
   country_code_   IN VARCHAR2,
   from_zip_code_  IN NUMBER,
   to_zip_code_    IN NUMBER,
   objid_          IN VARCHAR2)
IS
   overlapping_exist_ NUMBER;
   CURSOR get_overlapping_rec IS
      SELECT 1 
      FROM  freight_zone_tab z, FREIGHT_ZONE_DETAILS_TAB d
      WHERE z.freight_zone_basis = 'ZIP_CODE'
      AND   z.freight_map_id = freight_map_id_
      AND   z.base_country = country_code_
      AND   z.freight_map_id = d.freight_map_id
      AND   z.zone_id = d.zone_id
      AND   (d.ROWID != objid_ OR objid_ IS NULL)
      AND   ((d.from_zip_code <= from_zip_code_ AND d.to_zip_code >= from_zip_code_)
      OR    (d.from_zip_code <= to_zip_code_ AND d.to_zip_code >= to_zip_code_)
      OR    (d.from_zip_code >= from_zip_code_ AND d.to_zip_code <= to_zip_code_));
BEGIN
   IF (from_zip_code_ < 0 OR to_zip_code_ < 0) THEN
      Error_SYS.Record_General(lu_name_, 'ZIPCODENEGATIVE: Zip Code value cannot be negative.');
   ELSIF (from_zip_code_ > to_zip_code_) THEN
      Error_SYS.Record_General(lu_name_, 'ZIPCODEFROMTO: From value should be less than the To value.');
   END IF;

   OPEN get_overlapping_rec;
   FETCH get_overlapping_rec INTO overlapping_exist_;
   IF get_overlapping_rec%FOUND THEN
      CLOSE get_overlapping_rec;
      Error_SYS.Record_General(lu_name_, 'ZIPCODEEXIST: Zip Code values already exists for the country.');
   END IF;
   CLOSE get_overlapping_rec;   

END Validate_Zip_Code___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     freight_zone_details_tab%ROWTYPE,
   newrec_ IN OUT freight_zone_details_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   base_country_ VARCHAR2(50);
   zone_basis_   VARCHAR2(50);
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   base_country_ := Freight_Zone_API.Get_Base_Country(newrec_.freight_map_id, newrec_.zone_id);
   zone_basis_   := Freight_Zone_Basis_API.Encode(Freight_Zone_API.Get_Freight_Zone_Basis(newrec_.freight_map_id, newrec_.zone_id));
   
   IF zone_basis_ = 'ZIP_CODE' THEN
      IF (newrec_.from_zip_code IS NULL) OR (newrec_.to_zip_code IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOTNULLFROMTO: Both From and To should have values.');
      ELSE
         Validate_Zip_Code___(newrec_.freight_map_id,
                              base_country_, 
                              newrec_.from_zip_code, 
                              newrec_.to_zip_code,
                              NULL);
      END IF;
   ELSE 
      IF newrec_.discrete_value IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOTNULLDISCVALUE: Discrete Value can not be empty.');
      ELSE
         Validate_Discrete_Value___(newrec_.freight_map_id,
                                    newrec_.zone_id, 
                                    newrec_.discrete_value,
                                    base_country_,
                                    zone_basis_);
      END IF;
   END IF;
END Check_Common___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY freight_zone_details_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   newrec_.item_no := Freight_Zone_Details_API.Get_Next_Item_No(newrec_.freight_map_id, newrec_.zone_id); 
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Next_Item_No (
   freight_map_id_ IN VARCHAR2,
   zone_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_item_no IS
      SELECT to_char(max(to_number(item_no)))
      FROM   FREIGHT_ZONE_DETAILS_TAB 
      WHERE  freight_map_id = freight_map_id_
      AND    zone_id = zone_id_;

   item_  VARCHAR2(4);
BEGIN
   
   OPEN get_item_no;
   FETCH get_item_no INTO item_;
   CLOSE get_item_no;

   IF (item_ IS NOT NULL) THEN
      item_ := to_char(to_number(item_) + 1);
   ELSE
      item_  := '1';         
   END IF;  
   
   RETURN item_;
END Get_Next_Item_No;


@UncheckedAccess
FUNCTION Get_Value_Description (
   freight_map_id_ IN VARCHAR2,
   zone_id_        IN VARCHAR2,
   discrete_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   base_country_ VARCHAR2(50);
   zone_basis_   VARCHAR2(50);
   value_desc_   VARCHAR2(100);
   
   CURSOR get_state_name IS
      SELECT state_name
      FROM STATE_CODES_TAB 
      WHERE country_code = base_country_
      AND state_code = discrete_value_;
      
   CURSOR get_county_name IS
      SELECT county_name
      FROM COUNTY_CODE_TAB  
      WHERE country_code = base_country_
      AND county_code = discrete_value_;
      
   CURSOR get_city_name IS
      SELECT city_name
      FROM CITY_CODE_TAB 
      WHERE country_code = base_country_
      AND city_code = discrete_value_;
BEGIN
   base_country_ := Freight_Zone_API.Get_Base_Country(freight_map_id_, zone_id_);
   zone_basis_   := Freight_Zone_Basis_API.Encode(Freight_Zone_API.Get_Freight_Zone_Basis(freight_map_id_, zone_id_));
   
   IF zone_basis_ = 'COUNTRY' THEN
      value_desc_ := Iso_Country_API.Get_Description(discrete_value_);
   ELSIF zone_basis_ = 'STATE' THEN
      OPEN get_state_name;
      FETCH get_state_name INTO value_desc_;
      CLOSE get_state_name;
   ELSIF zone_basis_ = 'COUNTY' THEN
      OPEN get_county_name;
      FETCH get_county_name INTO value_desc_;
      CLOSE get_county_name;
   ELSIF zone_basis_ = 'CITY' THEN
      OPEN get_city_name;
      FETCH get_city_name INTO value_desc_;
      CLOSE get_city_name;
   END IF;
   RETURN value_desc_;
END Get_Value_Description;



