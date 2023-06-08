-----------------------------------------------------------------------------
--
--  Logical unit: CountryRegion
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140313  AyAmlk  Bug 115778, Modified Get_Name_Via_Contract() by fetching the Site country
--  140313          instead of Delivery Address Country.
--  100511  KRPELK  Merge Rose Method Documentation.
--  100309  SaWjlk  Bug 88684, Added new LOV view COUNTRY_REGION_ALL_LOV.
--  ------------------------------- Eagle ----------------------------------
--  051003  KeFelk  Moved from Site LU and relocated on the SiteInventInfo.
--  050407  SeJalk  Bug 47761, Moved LU RegionOfOrigin to MPCCOM and renamed to CountryRegion.
--  050321          Renamed view,package and table names and added lov view COUNTRY_OF_REGION_LOV
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Name_Via_Contract
--   Returns region name using contract.
@UncheckedAccess
FUNCTION Get_Name_Via_Contract (
   contract_    IN VARCHAR2,
   region_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   country_code_ VARCHAR2(3);
   temp_         COUNTRY_REGION_TAB.region_name%TYPE;
   CURSOR get_attr IS
      SELECT region_name
      FROM COUNTRY_REGION_TAB
      WHERE country_code = country_code_
      AND   region_code  = region_code_;
BEGIN
   country_code_ := Company_Site_API.Get_Country_Db(contract_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name_Via_Contract;



