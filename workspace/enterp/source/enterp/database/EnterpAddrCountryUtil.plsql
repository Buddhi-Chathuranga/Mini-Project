-----------------------------------------------------------------------------
--
--  Logical unit: EnterpAddrCountryUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110218  Chgulk  Created, Bug 98884
--  111025  Chgulk  Bug 99562, Change the LU name. modified the code which has added from bug 98884 according to the coding standards.
--  111202  Chgulk  SFI-700, Merged Bug 99562.
--  120214  Umdolk  SFI-2071, Modified Get_Caller_Details___ to get values for project.
--  120426  Shdilk  SFI-2607, Modified Sync_Addr_Countries to use '*' when no state is used.
--  121023  Waudlk  Bug 106065, Added assert safe comment
--  211222  Kavflk  CRM21R2-425,Added BUSINESS_LEAD in Get_Caller_Details___.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Caller_Details___(
   package_name_   OUT VARCHAR2,
   table_name_     OUT VARCHAR2,
   party_type_     IN  VARCHAR2 )
IS
BEGIN
    IF (party_type_ = 'COMPANY') THEN
       package_name_ :=  'COMPANY_ADDRESS_API'; 
       table_name_   :=  'COMPANY_ADDRESS_TAB';
    ELSIF (party_type_ = 'CUSTOMER') THEN
       package_name_ :=  'CUSTOMER_INFO_ADDRESS_API'; 
       table_name_   :=  'CUSTOMER_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'CUSTOMS') THEN
       package_name_ := 'CUSTOMS_INFO_ADDRESS_API';
       table_name_   := 'CUSTOMS_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'SUPPLIER') THEN
       package_name_ := 'SUPPLIER_INFO_ADDRESS_API';
       table_name_   := 'SUPPLIER_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'FORWARDER') THEN
       package_name_ := 'FORWARDER_INFO_ADDRESS_API';
       table_name_   := 'FORWARDER_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'MANUFACTURER' ) THEN
       package_name_ := 'MANUFACTURER_INFO_ADDRESS_API';
       table_name_   := 'MANUFACTURER_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'OWNER') THEN
       package_name_ := 'OWNER_INFO_ADDRESS_API';
       table_name_   := 'OWNER_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'PERSON') THEN
       package_name_ := 'PERSON_INFO_ADDRESS_API';
       table_name_   := 'PERSON_INFO_ADDRESS_TAB';
    ELSIF (party_type_ = 'PROJECT') THEN
       package_name_ := 'PROJECT_ADDRESS_API';
       table_name_   := 'PROJECT_ADDRESS_TAB';
    ELSIF (party_type_ = 'BUSINESS_LEAD') THEN
       package_name_ := 'BUSINESS_LEAD_ADDRESS_API';
       table_name_   := 'BUSINESS_LEAD_ADDRESS_TAB';
    END IF;
END Get_Caller_Details___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Sync_Addr_Countries (
   country_code_          IN VARCHAR2,
   state_presentation_    IN VARCHAR2,
   county_presentation_   IN VARCHAR2,
   city_presentation_     IN VARCHAR2,
   party_type_            IN VARCHAR2,
   state_changed_         IN BOOLEAN,
   county_changed_        IN BOOLEAN,
   city_changed_          IN BOOLEAN )
IS
   state_code_flag_         BOOLEAN;
   county_code_flag_        NUMBER;
   TYPE ref_cursor IS REF CURSOR;
   get_country_records_ ref_cursor;
   cur2_                    VARCHAR2(1000);
   TYPE temp_state_ IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   TYPE temp_county_ IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   TYPE temp_city_ IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   TYPE temp_objid_ IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   ref_state_tab_           temp_state_;
   ref_county_tab_          temp_county_;
   ref_city_tab_            temp_city_ ;
   ref_objid_tab_           temp_objid_ ;
   ref_temp_state_tab_      temp_state_;
   ref_temp_county_tab_     temp_county_;
   ref_temp_city_tab_       temp_city_ ;
   bulk_limit_              CONSTANT NUMBER := 10000;
   table_name_              VARCHAR2(100);
   temp_lu_name_            VARCHAR2(100);
   stmt_                    VARCHAR2(200);
   state_code_for_county_   VARCHAR2(100);
   state_code_for_city_     VARCHAR2(100);
BEGIN
   state_code_flag_ := FALSE;
   county_code_flag_ := 0;
   Get_Caller_Details___(temp_lu_name_, table_name_, party_type_);
   cur2_ := NULL;
   cur2_ := 'SELECT state, county, city, ROWID objid FROM '||table_name_||' WHERE country = :country_code_ FOR UPDATE';
   @ApproveDynamicStatement(2012-10-23,waudlk)
   OPEN get_country_records_ FOR cur2_ USING country_code_;
   LOOP
      FETCH get_country_records_ BULK COLLECT INTO ref_state_tab_, ref_county_tab_, ref_city_tab_, ref_objid_tab_ LIMIT bulk_limit_;
         IF (ref_objid_tab_.count > 0) THEN
            FOR i_ IN ref_state_tab_.FIRST..ref_state_tab_.LAST LOOP
               ref_temp_state_tab_(i_) := ref_state_tab_(i_);
               ref_temp_county_tab_(i_) := ref_county_tab_(i_);
               ref_temp_city_tab_(i_) := ref_city_tab_(i_);
               IF (state_presentation_ = 'CODES') THEN
                  IF (state_changed_) THEN
                     ref_temp_state_tab_(i_) := NVL(State_Codes_API.Get_State_Code(country_code_, ref_state_tab_(i_)), ref_state_tab_(i_));
                  END IF;
                  state_code_flag_ := TRUE;
               ELSIF (state_presentation_ = 'NAMES') THEN
                  IF (state_changed_) THEN
                     ref_temp_state_tab_(i_) := NVL(State_Codes_API.Get_State_Name(country_code_, ref_state_tab_(i_)), ref_state_tab_(i_));
                  END IF;
                  state_code_flag_ := FALSE;
               ELSIF (state_presentation_ = 'NOTUSED') THEN
                  ref_temp_state_tab_(i_) := ref_state_tab_(i_);
                  state_code_flag_ := FALSE;
               END IF;
               IF (county_presentation_ = 'CODES') THEN
                  IF (state_code_flag_ ) THEN
                     IF (county_changed_) THEN
                        ref_temp_county_tab_(i_) := NVL(County_Code_API.Get_County_Code(country_code_, ref_temp_state_tab_(i_), ref_county_tab_(i_) ), ref_county_tab_(i_));
                     END IF;
                     county_code_flag_ := 1;
                  ELSE
                     IF (county_changed_) THEN
                        state_code_for_county_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_county_tab_(i_) := NVL(County_Code_API.Get_County_Code(country_code_, state_code_for_county_, ref_county_tab_(i_)), ref_county_tab_(i_));
                     END IF;
                     county_code_flag_ := 2;
                  END IF;
               ELSIF (county_presentation_ = 'NAMES') THEN
                  IF (state_code_flag_ ) THEN
                     IF (county_changed_) THEN
                        ref_temp_county_tab_(i_) := NVL(County_Code_API.Get_County_Name(country_code_, ref_temp_state_tab_(i_), ref_county_tab_(i_)), ref_county_tab_(i_));
                     END IF;
                     county_code_flag_ := 3;
                  ELSE
                     IF (county_changed_) THEN
                        state_code_for_county_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_county_tab_(i_) := NVL(County_Code_API.Get_County_Name(country_code_, state_code_for_county_, ref_county_tab_(i_) ), ref_county_tab_(i_));
                     END IF;
                     county_code_flag_ := 4;
                  END IF;
               ELSIF (county_presentation_ = 'NOTUSED') THEN
                  ref_temp_county_tab_(i_) := ref_county_tab_(i_);
                  county_code_flag_ := 2;
               END IF;
               IF (city_presentation_ = 'CODES') THEN
                  IF (county_code_flag_ = 1) THEN
                     IF (city_changed_) THEN
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Code(country_code_, ref_temp_state_tab_(i_), ref_temp_county_tab_(i_), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 2) THEN
                     IF (city_changed_) THEN
                        state_code_for_city_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Code(country_code_, state_code_for_city_, ref_temp_county_tab_(i_), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 3) THEN
                     IF (city_changed_) THEN
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Code(country_code_, ref_temp_state_tab_(i_), County_Code_API.Get_County_Code(country_code_, ref_temp_state_tab_(i_), ref_temp_county_tab_(i_)), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 4) THEN
                     IF (city_changed_) THEN
                        state_code_for_city_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Code(country_code_, state_code_for_city_, County_Code_API.Get_County_Code(country_code_, state_code_for_city_, ref_temp_county_tab_(i_)), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  END IF;
               ELSIF (city_presentation_ = 'NAMES') THEN
                  IF (county_code_flag_ = 1) THEN
                     IF (city_changed_) THEN
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Name(country_code_, ref_temp_state_tab_(i_), ref_temp_county_tab_(i_), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 2) THEN
                     IF (city_changed_) THEN
                        state_code_for_city_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Name(country_code_, state_code_for_city_, ref_temp_county_tab_(i_), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 3) THEN
                     IF (city_changed_) THEN
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Name(country_code_, ref_temp_state_tab_(i_), County_Code_API.Get_County_Code(country_code_, ref_temp_state_tab_(i_), ref_temp_county_tab_(i_)), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  ELSIF (county_code_flag_ = 4) THEN
                     IF (city_changed_) THEN
                        state_code_for_city_  := NVL(State_Codes_API.Get_State_Code(country_code_, ref_temp_state_tab_(i_)), '*'); 
                        ref_temp_city_tab_(i_) := NVL(City_Code_API.Get_City_Name(country_code_, state_code_for_city_, County_Code_API.Get_County_Code(country_code_, state_code_for_city_, ref_temp_county_tab_(i_)), ref_city_tab_(i_)), ref_city_tab_(i_));
                     END IF;
                  END IF;
               ELSIF (city_presentation_ = 'NOTUSED') THEN
                  ref_temp_city_tab_(i_) := ref_city_tab_(i_);
               END IF;
            END LOOP;
            FORALL j_ IN ref_state_tab_.FIRST..ref_state_tab_.LAST
               @ApproveDynamicStatement(2011-10-04,chgulk)
               EXECUTE IMMEDIATE
               'UPDATE '||table_name_||' SET state =:1, county =:2, city =:3 WHERE ROWID =:4'
               USING ref_temp_state_tab_(j_), ref_temp_county_tab_(j_), ref_temp_city_tab_(j_), ref_objid_tab_(j_);
            stmt_ := 'BEGIN '||temp_lu_name_||'.Sync_Addr(:country_code_); END;';
            @ApproveDynamicStatement(2011-10-04,chgulk)
            EXECUTE IMMEDIATE stmt_ USING country_code_;
         END IF;
         EXIT WHEN get_country_records_%NOTFOUND;
     END LOOP;
     CLOSE get_country_records_;
END Sync_Addr_Countries;



