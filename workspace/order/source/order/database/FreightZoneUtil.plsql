-----------------------------------------------------------------------------
--
--  Logical unit: FreightZoneUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210604  KiSalk   Bug 158857(SCZ-14416), In To_Number___, made number conversion done after removing spaces in value.
--  210329  KiSalk   Bug 158583(SCZ-14156), Added missing base country check  for zip code check to cursor get_zone_info in Find_Zone_Cust_Info___.
--  201013  MaEelk   SCZ-11439, Removed un-used parameter zip_code_ from Find_Freight_Zone_Info___.
--  200909  KiSalk   Bug 155525(SCZ-11103), Modified cursor get_zone_info of Find_Zone_Cust_Info___ and Find_Zone_Supp_Info___ by joining freight_zone_details_tab to reduce result set.
--  200909           Moved zip_code checking from Find_Freight_Zone_Info___ to above 2 methods to improve performance.
--  150212  Hairlk   Bug id PRSC-5843 App9 RTM. 
--  130710  ErFelk   Bug 111142, Corrected the method name in General_SYS.Init_Method of Find_Zone_For_Cust_Addr___().
--  120314  DaZase   Removed last TRUE parameter in Init_Method call inside Assign_Freight_Zone__.
--  110602  MiKulk   Modified the method Assign_Zone_To_Supp_Chain___ to support % for the vendor_no and contract
--  110503  MaRalk   Modified desc_ in Assign_Freight_Zone method.
--  100816  MAHPLk   Added new procedure Find_Zone_For_Site___ and modified Assign_Zone_To_Supp_Chain___. 
--  100722  ChFolk   Added new procedure Fetch_Zone_For_Cust_Addr.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090629  HimRlk   Merged Bug 82146, Added DUMMY field to Assign_Freight_Zone__.
--  090311  ChJalk   Bug 81153, Modified the datatype of IN parameter zip_code_ to VARCHAR2 from NUMBER in the methods
--  090311           Find_Zone_Cust_Info___, Find_Zone_Supp_Info___, Find_Freight_Zone_Info___ and Fetch_Zone_For_Single_Occ_Addr.
--  090305  ShKolk   Changed method Fetch_Zone_For_Single_Occ_Addr to Fetch_Zone_For_Addr_Details.
--  081230  MaHplk   Modified methods Assign_Zone_To_Supp_Chain___ and Find_Zone_For_Supp_Addr___ 
--                   to fetch the address id from external cutomer.
--  081103  MiKulk   Modified the methods Find_Zone_For_Cust_Addr___ and Find_Zone_For_Supp_Addr___ by modifying the 
--  081103           exception handling section to report the error text in background, when zip code is alphanumeric. 
--  081022  MiKulk   Added coding to handle the exception VALUE_ERROR to avoid the errors due
--  081022           to NON numeric zip codes.
--  081022  MaHplk   Modified Find_Zone_Cust_Info___ and Find_Zone_Supp_Info___.
--  080916  MaHplk   Modified get_cust_info and get_supp_info cursors in Assign_Zone_To_Supp_Chain___.
--  080915  MaHplk   Added Find_Zone_For_Supp_Addr___, Find_Zone_Cust_Info___,Find_Zone_Supp_Info___
---                  and modified Find_Freight_Zone_Info___ and Assign_Zone_To_Supp_Chain___.   
--    080912   MaJalk   Added method Fetch_Zone_For_Single_Occ_Addr.
--  080904  MaHplk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Assign_Zone_To_Supp_Chain___ (
   contract_      IN VARCHAR2,
   vendor_no_     IN VARCHAR2,
   ship_via_code_ IN VARCHAR2 )
IS
   freight_map_id_   VARCHAR2(15);
   zone_id_          VARCHAR2(15);
   zone_info_exist_  VARCHAR2(5):='FALSE';

   CURSOR get_cust_info(contract_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS
      SELECT customer_no, addr_no, ship_via_code, contract
      FROM   customer_address_leadtime_tab
      WHERE  contract LIKE contract_
      AND    ship_via_code LIKE ship_via_code_
      AND    manually_assigned_zone != 'TRUE';

    CURSOR get_cust_exp_info(customer_no_ IN VARCHAR2, addr_no_ IN VARCHAR2, contract_ IN VARCHAR2) IS
      SELECT ship_via_code, supply_chain_part_group
      FROM   cust_addr_part_leadtime_tab
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    contract = contract_
      AND    manually_assigned_zone != 'TRUE';

    CURSOR get_supp_info(vendor_no_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS   
      SELECT customer_no, addr_no, vendor_no, supplier_address, ship_via_code
      FROM   supp_to_cust_leadtime_tab 
      WHERE  vendor_no LIKE vendor_no_
      AND    ship_via_code LIKE ship_via_code_
      AND    manually_assigned_zone != 'TRUE';
      
   CURSOR get_supp_exp_info (customer_no_ IN VARCHAR2, addr_no_ IN VARCHAR2, 
                             vendor_no_ IN VARCHAR2, supplier_address_ IN VARCHAR2) IS   
      SELECT ship_via_code, supply_chain_part_group
      FROM   supp_to_cust_part_leadtime_tab 
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    vendor_no = vendor_no_
      AND    supplier_address = supplier_address_
      AND    manually_assigned_zone != 'TRUE';

   CURSOR get_site_info(contract_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS
      SELECT sts.demand_site, sts.supply_site, sts.ship_via_code  
      FROM   site_to_site_leadtime_tab sts, cust_ord_customer_tab coc
      WHERE  sts.demand_site = coc.acquisition_site
      AND    coc.category = 'I'
      AND    sts.supply_site LIKE contract_
      AND    sts.ship_via_code LIKE ship_via_code_
      AND    sts.manually_assigned_zone != 'TRUE';
      
   CURSOR get_site_exp_info(contract_ IN VARCHAR2, ship_via_code_ IN VARCHAR2) IS
      SELECT stsp.demand_site, stsp.supply_site, stsp.ship_via_code, stsp.supply_chain_part_group  
      FROM   site_to_site_part_leadtime_tab stsp, cust_ord_customer_tab coc
      WHERE  stsp.demand_site = coc.acquisition_site
      AND    coc.category = 'I'
      AND    stsp.supply_site LIKE contract_
      AND    stsp.ship_via_code LIKE ship_via_code_
      AND    stsp.manually_assigned_zone != 'TRUE';

BEGIN
   -- Find zone information and update the site to customer supply chain parameters.
   IF contract_ IS NOT NULL THEN
      FOR cust_rec_ IN get_cust_info(contract_, ship_via_code_) LOOP
         freight_map_id_     := NULL;
         zone_id_            := NULL;
         zone_info_exist_    := 'FALSE';
         Find_Zone_For_Cust_Addr___(freight_map_id_
                                  ,zone_id_
                                  ,zone_info_exist_
                                  ,cust_rec_.customer_no
                                  ,cust_rec_.addr_no
                                  ,cust_rec_.contract
                                  ,cust_rec_.ship_via_code);
   
         IF (zone_info_exist_ = 'TRUE') THEN
            Customer_Address_Leadtime_API.Modify_Zone_Info(cust_rec_.customer_no,
                                                           cust_rec_.addr_no,
                                                           cust_rec_.ship_via_code,
                                                           cust_rec_.contract,
                                                           freight_map_id_,
                                                           zone_id_,
                                                           'FALSE');
         END IF;
         -- Find zone information for supply chain part group.
         FOR excep_rec_ IN get_cust_exp_info(cust_rec_.customer_no,cust_rec_.addr_no,cust_rec_.contract) LOOP
            freight_map_id_     := NULL;
            zone_id_            := NULL;
            zone_info_exist_    := 'FALSE';
            Find_Zone_For_Cust_Addr___( freight_map_id_
                                     ,zone_id_
                                     ,zone_info_exist_
                                     ,cust_rec_.customer_no
                                     ,cust_rec_.addr_no
                                     ,cust_rec_.contract
                                     ,excep_rec_.ship_via_code );
            IF (zone_info_exist_ = 'TRUE') THEN
               Cust_Addr_Part_Leadtime_API.Modify_Zone_Info(cust_rec_.customer_no,
                                                        cust_rec_.addr_no,
                                                        excep_rec_.supply_chain_part_group,
                                                        cust_rec_.contract,
                                                        excep_rec_.ship_via_code,
                                                        freight_map_id_,
                                                        zone_id_,
                                                        'FALSE');
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   -- Find zone information and update the site to site supply chain parameters.
   IF contract_ IS NOT NULL THEN
      FOR site_rec_ IN get_site_info(contract_, ship_via_code_) LOOP
         freight_map_id_     := NULL;
         zone_id_            := NULL;
         zone_info_exist_    := 'FALSE';
         Find_Zone_For_Site___(freight_map_id_
                               ,zone_id_
                               ,zone_info_exist_
                               ,site_rec_.demand_site
                               ,site_rec_.supply_site
                               ,site_rec_.ship_via_code);

         IF (zone_info_exist_ = 'TRUE') THEN
            Site_To_Site_Leadtime_API.Modify_Zone_Info(site_rec_.demand_site,
                                                       site_rec_.supply_site,
                                                       site_rec_.ship_via_code,
                                                       freight_map_id_,
                                                       zone_id_,
                                                       'FALSE');
         END IF;
         -- Find zone information for supply chain part group.
         FOR site_excep_rec_ IN get_site_exp_info(site_rec_.demand_site, site_rec_.ship_via_code) LOOP
            freight_map_id_     := NULL;
            zone_id_            := NULL;
            zone_info_exist_    := 'FALSE';
            Find_Zone_For_Site___(freight_map_id_
                                  ,zone_id_
                                  ,zone_info_exist_
                                  ,site_rec_.demand_site
                                  ,site_rec_.supply_site
                                  ,site_rec_.ship_via_code);

            IF (zone_info_exist_ = 'TRUE') THEN
               Site_To_Site_Part_Leadtime_API.Modify_Zone_Info(site_excep_rec_.demand_site,
                                                               site_excep_rec_.supply_site,
                                                               site_excep_rec_.ship_via_code,
                                                               site_excep_rec_.supply_chain_part_group,
                                                               freight_map_id_,
                                                               zone_id_,
                                                               'FALSE');
            END IF;
         END LOOP;
      END LOOP;
   END IF;
   
   -- Find zone information and update the supplier to customer supply chain parameters.
   IF vendor_no_ IS NOT NULL THEN
      FOR supp_rec_ IN get_supp_info(vendor_no_, ship_via_code_) LOOP
         freight_map_id_     := NULL;
         zone_id_            := NULL;
         zone_info_exist_    := 'FALSE';
         Find_Zone_For_Supp_Addr___(freight_map_id_
                                  ,zone_id_
                                  ,zone_info_exist_
                                  ,supp_rec_.customer_no
                                  ,supp_rec_.vendor_no
                                  ,supp_rec_.addr_no
                                  ,supp_rec_.ship_via_code );
   
         IF (zone_info_exist_ = 'TRUE') THEN
            Supp_To_Cust_Leadtime_API.Modify_Zone_Info(supp_rec_.customer_no,
                                                       supp_rec_.addr_no,
                                                       supp_rec_.vendor_no,
                                                       supp_rec_.supplier_address,
                                                       supp_rec_.ship_via_code,
                                                       freight_map_id_,
                                                       zone_id_,
                                                       'FALSE');
         END IF;
         -- Find zone information for supply chain part group.
         FOR excep_rec_ IN get_supp_exp_info(supp_rec_.customer_no, supp_rec_.addr_no,
                                             supp_rec_.vendor_no, supp_rec_.supplier_address) LOOP
            freight_map_id_     := NULL;
            zone_id_            := NULL;
            zone_info_exist_    := 'FALSE';
            Find_Zone_For_Supp_Addr___(freight_map_id_
                                      ,zone_id_
                                      ,zone_info_exist_
                                      ,supp_rec_.customer_no
                                      ,supp_rec_.vendor_no
                                      ,supp_rec_.addr_no
                                      ,excep_rec_.ship_via_code );
            IF (zone_info_exist_ = 'TRUE') THEN
               Supp_To_Cust_Part_Leadtime_API.Modify_Zone_Info(supp_rec_.customer_no,
                                                               supp_rec_.addr_no,
                                                               excep_rec_.supply_chain_part_group,
                                                               supp_rec_.vendor_no,
                                                               supp_rec_.supplier_address,
                                                               excep_rec_.ship_via_code,
                                                               freight_map_id_,
                                                               zone_id_,
                                                               'FALSE');
            END IF;
         END LOOP;
      END LOOP;
   END IF;      
END Assign_Zone_To_Supp_Chain___;


-- Find_Zone_For_Cust_Addr___
--   This method is used to retrieve the zone details when the customer's address
--   id is known.
PROCEDURE Find_Zone_For_Cust_Addr___ (
   freight_map_id_   OUT    VARCHAR2,
   zone_id_          OUT    VARCHAR2,
   zone_info_exist_  IN OUT VARCHAR2,
   customer_no_      IN     VARCHAR2,
   addr_no_          IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   ship_via_code_    IN     VARCHAR2 )
IS
   zip_code_             VARCHAR2(35);
   city_                 VARCHAR2(35);
   county_               VARCHAR2(35);
   state_                VARCHAR2(35);
   country_              VARCHAR2(2);
   
   CURSOR get_cust_addr_info(customer_no_ IN VARCHAR2, addr_no_ IN VARCHAR2) IS
      SELECT zip_code, city, county, state, country
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_no_
      AND    address_id = addr_no_;

BEGIN
   OPEN get_cust_addr_info(customer_no_, addr_no_);
   FETCH get_cust_addr_info INTO zip_code_, city_, county_, state_, country_;
   CLOSE get_cust_addr_info;

   Find_Zone_Cust_Info___ (freight_map_id_, zone_id_, zone_info_exist_,
                           contract_, ship_via_code_, zip_code_, city_,
                           county_, state_, country_);

END Find_Zone_For_Cust_Addr___;


-- Find_Zone_For_Supp_Addr___
--   This method is used to retrieve the zone details when the supplier's address
--   id is known.
PROCEDURE Find_Zone_For_Supp_Addr___ (
   freight_map_id_   OUT    VARCHAR2,
   zone_id_          OUT    VARCHAR2,
   zone_info_exist_  IN OUT VARCHAR2,
   customer_no_      IN     VARCHAR2,
   vendor_no_        IN     VARCHAR2,
   addr_no_          IN     VARCHAR2,
   ship_via_code_    IN     VARCHAR2 )
IS
   zip_code_             VARCHAR2(35);
   city_                 VARCHAR2(35);
   county_               VARCHAR2(35);      
   state_                VARCHAR2(35);
   country_              VARCHAR2(2);
   
   -- Fetch external customer info.
   CURSOR get_cust_addr_info(customer_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT zip_code, city, county, state, country
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;

BEGIN
   OPEN get_cust_addr_info(customer_no_, addr_no_);
   FETCH get_cust_addr_info INTO zip_code_, city_, county_, state_, country_;
   CLOSE get_cust_addr_info;

   Find_Zone_Supp_Info___ (freight_map_id_, zone_id_, zone_info_exist_,
                           vendor_no_, ship_via_code_, zip_code_, city_,
                           county_, state_, country_);

END Find_Zone_For_Supp_Addr___;

-- To_Number___
--  Returns number converted string value in_value_ removing spaces if possible; returns 0 otherwise.
FUNCTION To_Number___(in_value_ IN VARCHAR2) RETURN NUMBER IS
   new_num_ NUMBER;
BEGIN
      -- In some countries, the number type Zip code contains spaces in between So, need to remove them and convert to number.
      new_num_ := TO_NUMBER(REPLACE(in_value_,' '));

   RETURN new_num_;
EXCEPTION
   WHEN value_error THEN
      RETURN 0;
END To_Number___;


-- Find_Zone_Cust_Info___
--   This method is used to retrieve the zone details when the customer's address
--   line information, ship via code and site is known.
PROCEDURE Find_Zone_Cust_Info___ (
   freight_map_id_   IN OUT VARCHAR2,
   zone_id_          IN OUT VARCHAR2,
   zone_info_exist_  IN OUT VARCHAR2,
   contract_         IN     VARCHAR2,
   ship_via_code_    IN     VARCHAR2,
   zip_code_         IN     VARCHAR2,
   city_             IN     VARCHAR2,
   county_           IN     VARCHAR2,
   state_            IN     VARCHAR2,
   country_          IN     VARCHAR2)
IS
   previous_entrep_addr_rec_  ENTERP_ADDRESS_COUNTRY_API.Public_Rec;
   entrep_addr_rec_           ENTERP_ADDRESS_COUNTRY_API.Public_Rec;
   base_country_              freight_zone_tab.base_country%TYPE;
   
   -- Added parameter zip_code_num_ and joined freight_zone_details_tab to reduce result set
   CURSOR get_zone_info(contract_ IN VARCHAR2, ship_via_code_ IN VARCHAR2, zip_code_num_ NUMBER) IS
      SELECT fzvs.freight_map_id, fz.zone_id, fz.base_country, fz.freight_zone_basis
      FROM   freight_map_tab fm, freight_zone_valid_site_tab fzvs,
             freight_zone_tab fz
      WHERE  fm.freight_map_id = fzvs.freight_map_id
      AND    fz.freight_map_id = fm.freight_map_id
      AND    fzvs.contract = contract_
      AND    fm.ship_via_code = ship_via_code_
      AND    EXISTS (SELECT 1
                     FROM   freight_zone_details_tab fzd
                     WHERE  fzd.freight_map_id = fm.freight_map_id
                     AND    fzd.zone_id = fz.zone_id
                     AND    (CASE
                               WHEN (fz.freight_zone_basis = 'ZIP_CODE' AND ((fzd.from_zip_code <= zip_code_num_ AND fzd.to_zip_code >= zip_code_num_) AND fz.base_country = country_)) THEN
                                'TRUE'
                               WHEN (fz.freight_zone_basis = 'ZIP_CODE') THEN
                                'FALSE'
                               ELSE
                                'TRUE'
                            END) = 'TRUE')
      ORDER BY  fz.zone_basis_priority;
BEGIN
   FOR zone_rec_ IN get_zone_info(contract_, ship_via_code_, To_Number___(zip_code_)) LOOP
      IF zone_rec_.freight_zone_basis = 'ZIP_CODE' THEN
         -- Zip Code validation done in the cursor get_zone_info itself
         zone_info_exist_ := 'TRUE';
      ELSE      
         IF (NVL(base_country_, Database_SYS.string_null_) != NVL(zone_rec_.base_country, Database_SYS.string_null_)) THEN
            IF (zone_rec_.base_country IS NOT NULL) THEN
               base_country_ := zone_rec_.base_country;
               -- Fetch address presentation information of the given company to determine whether its use CODE or DESCRIPTION.
               previous_entrep_addr_rec_ := Enterp_Address_Country_API.Get(base_country_);
               entrep_addr_rec_ := previous_entrep_addr_rec_;
            ELSE
               entrep_addr_rec_ := NULL;
            END IF;
         END IF;

         Find_Freight_Zone_Info___(zone_rec_.freight_map_id,
                                   zone_rec_.zone_id,
                                   zone_info_exist_,
                                   zone_rec_.freight_zone_basis,
                                   zone_rec_.base_country,
                                   city_,
                                   county_,
                                   state_,
                                   country_,
                                   entrep_addr_rec_);
      END IF;
      IF (zone_info_exist_ = 'TRUE') THEN
         freight_map_id_ := zone_rec_.freight_map_id;
         zone_id_        := zone_rec_.zone_id;
      END IF;
      EXIT WHEN (zone_info_exist_ = 'TRUE');
   END LOOP;
END Find_Zone_Cust_Info___;


-- Find_Zone_Supp_Info___
--   This method is used to retrieve the zone details when the supplier's address
--   line information, supplier ID and ship via code is known.
PROCEDURE Find_Zone_Supp_Info___ (
   freight_map_id_   IN OUT VARCHAR2,
   zone_id_          IN OUT VARCHAR2,
   zone_info_exist_  IN OUT VARCHAR2,
   vendor_no_        IN     VARCHAR2,
   ship_via_code_    IN     VARCHAR2,
   zip_code_         IN     VARCHAR2,
   city_             IN     VARCHAR2,
   county_           IN     VARCHAR2,
   state_            IN     VARCHAR2,
   country_          IN     VARCHAR2)
IS
   previous_entrep_addr_rec_  ENTERP_ADDRESS_COUNTRY_API.Public_Rec;
   entrep_addr_rec_           ENTERP_ADDRESS_COUNTRY_API.Public_Rec;
   base_country_              freight_zone_tab.base_country%TYPE;

   -- Added parameter zip_code_num_ and joined freight_zone_details_tab to reduce result set
   CURSOR get_zone_info(vendor_no_ IN VARCHAR2, ship_via_code_ IN VARCHAR2, zip_code_num_ NUMBER) IS
      SELECT fzvs.freight_map_id, fz.zone_id, fz.base_country, fz.freight_zone_basis
      FROM   freight_map_tab fm, freight_zone_valid_supp_tab fzvs,
             freight_zone_tab fz
      WHERE  fm.freight_map_id = fzvs.freight_map_id
      AND    fz.freight_map_id = fm.freight_map_id
      AND    fzvs.supplier_id = vendor_no_
      AND    fm.ship_via_code = ship_via_code_
      AND    EXISTS (SELECT 1
                     FROM   freight_zone_details_tab fzd
                     WHERE  fzd.freight_map_id = fm.freight_map_id
                     AND    fzd.zone_id = fz.zone_id
                     AND    (CASE
                               WHEN (fz.freight_zone_basis = 'ZIP_CODE' AND ((fzd.from_zip_code <= zip_code_num_ AND fzd.to_zip_code >= zip_code_num_))) THEN
                                'TRUE'
                               WHEN (fz.freight_zone_basis = 'ZIP_CODE') THEN
                                'FALSE'
                               ELSE
                                'TRUE'
                            END) = 'TRUE')
      ORDER BY  fz.zone_basis_priority;
BEGIN
   FOR zone_rec_ IN get_zone_info(vendor_no_, ship_via_code_, To_Number___(zip_code_)) LOOP
      IF zone_rec_.freight_zone_basis = 'ZIP_CODE' THEN
         -- Zip Code validation done in the cursor get_zone_info itself
         zone_info_exist_ := 'TRUE';
      ELSE
         IF (NVL(base_country_, Database_SYS.string_null_) != NVL(zone_rec_.base_country, Database_SYS.string_null_)) THEN
            IF (zone_rec_.base_country IS NOT NULL) THEN
               base_country_ := zone_rec_.base_country;
               -- Fetch address presentation information of the given company to determine whether its use CODE or DESCRIPTION.
               previous_entrep_addr_rec_ := Enterp_Address_Country_API.Get(base_country_);
               entrep_addr_rec_ := previous_entrep_addr_rec_;
            ELSE
               entrep_addr_rec_ := NULL;
            END IF;
         END IF;

         Find_Freight_Zone_Info___(zone_rec_.freight_map_id,
                                   zone_rec_.zone_id,
                                   zone_info_exist_,
                                   zone_rec_.freight_zone_basis,
                                   zone_rec_.base_country,
                                   city_,
                                   county_,
                                   state_,
                                   country_,
                                   entrep_addr_rec_);
      END IF;
      
      IF (zone_info_exist_ = 'TRUE') THEN
         freight_map_id_ := zone_rec_.freight_map_id;
         zone_id_        := zone_rec_.zone_id;
      END IF;
      EXIT WHEN (zone_info_exist_ = 'TRUE');
   END LOOP;
END Find_Zone_Supp_Info___;

-- Added entrep_addr_rec_ without fetching inside as this method is called in Loops
-- Find_Freight_Zone_Info___
--   This method will return the valid freight map and the zone id,
--   when zone base country, zone basis and the adress details (except zip_code) like,
--   city, county, state and country is given
PROCEDURE Find_Freight_Zone_Info___ (
   freight_map_id_      IN OUT VARCHAR2,
   zone_id_             IN OUT VARCHAR2,
   zone_info_exist_      IN OUT VARCHAR2,
   freight_zone_basis_  IN     VARCHAR2,
   base_country_        IN     VARCHAR2,
   city_                IN     VARCHAR2,
   county_              IN     VARCHAR2,
   state_               IN     VARCHAR2,
   country_             IN     VARCHAR2,
   entrep_addr_rec_     IN     Enterp_Address_Country_API.Public_Rec)
IS
   dummy_                VARCHAR2(35);
   dummy_desc_           VARCHAR2(50);

   CURSOR get_discrete_values(freight_map_id_ IN VARCHAR2, zone_id_ IN VARCHAR2) IS
      SELECT discrete_value
      FROM   freight_zone_details_tab
      WHERE  freight_map_id = freight_map_id_
      AND    zone_id = zone_id_;

    CURSOR check_discrete_values(freight_map_id_ IN VARCHAR2, zone_id_ IN VARCHAR2, discrete_value_ IN VARCHAR2) IS
      SELECT 1
      FROM  freight_zone_details_tab
      WHERE freight_map_id = freight_map_id_
      AND   zone_id = zone_id_
      AND   discrete_value = discrete_value_;
BEGIN
   
   -- If the address line uses CODE, It will check with zone discrete value and address line code.
   -- If it uses DESCRIPTION, It will check zone discrete value description and address line description.
   -- e.g.:
   --    If it is stored the CITY name in the database according to the address presentation,
   --    it will compare CITY name and discrete value description. Otherwise it compares with CODES.
   --    *** There should be a valid CIYT name in customer address line for correct validation.
   IF freight_zone_basis_ = 'CITY' THEN
      IF (city_ IS NOT NULL) AND (base_country_ = country_) THEN
         IF entrep_addr_rec_.city_presentation = 'NAMES' THEN
            FOR rec_ IN get_discrete_values(freight_map_id_, zone_id_) LOOP
               dummy_desc_ := Freight_Zone_Details_API.Get_Value_Description(freight_map_id_,
                                                                             zone_id_,
                                                                             rec_.discrete_value);
               IF (dummy_desc_ = city_) THEN
                  zone_info_exist_ := 'TRUE';
               END IF;
            END LOOP;
         ELSE
            OPEN check_discrete_values(freight_map_id_, zone_id_, city_);
            FETCH check_discrete_values INTO dummy_;
            IF (check_discrete_values%FOUND) THEN
               zone_info_exist_ := 'TRUE';
            END IF;
            CLOSE check_discrete_values;
         END IF;
      END IF;
   ELSIF freight_zone_basis_ = 'COUNTY' THEN
      IF (county_ IS NOT NULL) AND (base_country_ = country_) THEN
         IF entrep_addr_rec_.county_presentation = 'NAMES' THEN
            FOR rec_ IN get_discrete_values(freight_map_id_, zone_id_) LOOP
               dummy_desc_ := Freight_Zone_Details_API.Get_Value_Description(freight_map_id_,
                                                                             zone_id_,
                                                                             rec_.discrete_value);
               IF (dummy_desc_ = county_) THEN
                  zone_info_exist_ := 'TRUE';
               END IF;
            END LOOP;
         ELSE
            OPEN check_discrete_values(freight_map_id_, zone_id_, county_);
            FETCH check_discrete_values INTO dummy_;
            IF (check_discrete_values%FOUND) THEN
               zone_info_exist_ := 'TRUE';
            END IF;
            CLOSE check_discrete_values;
         END IF;
      END IF;
   ELSIF freight_zone_basis_ = 'STATE' THEN
      IF (state_ IS NOT NULL) AND (base_country_ = country_) THEN
         IF entrep_addr_rec_.state_presentation = 'NAMES' THEN
            FOR rec_ IN get_discrete_values(freight_map_id_, zone_id_) LOOP
               dummy_desc_ := Freight_Zone_Details_API.Get_Value_Description(freight_map_id_,
                                                                             zone_id_,
                                                                             rec_.discrete_value);
               IF (dummy_desc_ = state_) THEN
                  zone_info_exist_ := 'TRUE';
               END IF;
            END LOOP;
         ELSE
            OPEN check_discrete_values(freight_map_id_, zone_id_, state_);
            FETCH check_discrete_values INTO dummy_;
            IF (check_discrete_values%FOUND) THEN
               zone_info_exist_ := 'TRUE';
            END IF;
            CLOSE check_discrete_values;
         END IF;
      END IF;
   ELSIF freight_zone_basis_ = 'COUNTRY' THEN
      IF country_ IS NOT NULL THEN
         OPEN check_discrete_values(freight_map_id_, zone_id_, country_);
         FETCH check_discrete_values INTO dummy_;
         IF (check_discrete_values%FOUND) THEN
            zone_info_exist_ := 'TRUE';
         END IF;
         CLOSE check_discrete_values;
      END IF;
   END IF;
END Find_Freight_Zone_Info___;


-- Find_Zone_For_Site___
--   This method is used to retrieve the zone details when the supply site is known.
PROCEDURE Find_Zone_For_Site___ (
   freight_map_id_   OUT    VARCHAR2,
   zone_id_          OUT    VARCHAR2,
   zone_info_exist_  IN OUT VARCHAR2,
   demand_site_      IN     VARCHAR2,
   supply_site_      IN     VARCHAR2,
   ship_via_code_    IN     VARCHAR2 )
IS
   zip_code_             VARCHAR2(35);
   city_                 VARCHAR2(35);
   county_               VARCHAR2(35);
   state_                VARCHAR2(35);
   country_              VARCHAR2(2);

   CURSOR get_site_addr_info(contract_ IN VARCHAR2) IS
      SELECT ca.zip_code, ca.city, ca.county, ca.state, ca.country
      FROM   site_tab s, company_address_tab ca
      WHERE  ca.company = s.company
      AND    ca.address_id =s.delivery_address
      AND    s.contract = contract_;

BEGIN
   OPEN get_site_addr_info(demand_site_);
   FETCH get_site_addr_info INTO zip_code_, city_, county_, state_, country_;
   CLOSE get_site_addr_info;

   -- Return Zone details for demand site of site to site supply chain parameter. 
   Find_Zone_Cust_Info___ (freight_map_id_, zone_id_, zone_info_exist_,
                           supply_site_, ship_via_code_, zip_code_, city_,
                           county_, state_, country_);

END Find_Zone_For_Site___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Assign_Freight_Zone__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   site_cluster_id_         VARCHAR2(50);
   site_cluster_node_id_    VARCHAR2(50);
   contract_                VARCHAR2(5);
   ship_via_code_           VARCHAR2(5);
   vendor_no_               VARCHAR2(20);
   site_tab_                Site_Cluster_Node_API.site_table;
BEGIN
   -- In parameters are:  Site_Cluster_Id
   --                     Site_Cluster_Node_Id - Should have value if Site_Cluster is not null.
   --                     Contract
   --                     Ship_Via_Code - not null
   -- Unpack the in parameters
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SITE_CLUSTER_ID') THEN
         site_cluster_id_ := value_;
      ELSIF (name_ = 'SITE_CLUSTER_NODE_ID') THEN
         site_cluster_node_id_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'VENDOR_NO') THEN
         vendor_no_ := value_;
      ELSIF (name_ = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := NVL(value_,'%');
      ELSIF (name_ = 'DUMMY') THEN
         NULL;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   -- For site to customer matrix.
   IF (contract_ IS NOT NULL) THEN
      Assign_Zone_To_Supp_Chain___(contract_, NULL, ship_via_code_);
   ELSIF ((site_cluster_id_ IS NOT NULL) AND (site_cluster_node_id_ IS NOT NULL)) THEN
      -- Find all sites connected to the site cluster.
      site_tab_ := Site_Cluster_Node_API.Get_Connected_Sites(site_cluster_id_,site_cluster_node_id_);
      IF site_tab_.COUNT >0 THEN
         FOR i IN site_tab_.FIRST..site_tab_.LAST LOOP
            Assign_Zone_To_Supp_Chain___(site_tab_(i).contract, NULL, ship_via_code_);
         END LOOP;
      END IF;
   END IF;
   -- For supplier to customer matrix.
   IF vendor_no_ IS NOT NULL THEN
      Assign_Zone_To_Supp_Chain___( NULL, vendor_no_, ship_via_code_);
   END IF;
END Assign_Freight_Zone__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Assign_Freight_Zone (
   attr_ IN VARCHAR2 )
IS
   desc_ VARCHAR2(100);
BEGIN
   desc_ := Language_SYS.Translate_Constant(lu_name_, 'ASSIGNZONE: Assign Freight Zones');
   Transaction_SYS.Deferred_Call('FREIGHT_ZONE_UTIL_API.Assign_Freight_Zone__', attr_, desc_);
END Assign_Freight_Zone;


PROCEDURE Validate_Params (
   attr_ IN VARCHAR2 )
IS
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   site_cluster_id_      VARCHAR2(50);
   site_cluster_node_id_ VARCHAR2(50);
   contract_             VARCHAR2(5);
   ship_via_code_        VARCHAR2(5);
   vendor_no_            VARCHAR2(20);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SITE_CLUSTER_ID') THEN
         site_cluster_id_ := value_;
      ELSIF (name_ = 'SITE_CLUSTER_NODE_ID') THEN
         site_cluster_node_id_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'VENDOR_NO') THEN
         vendor_no_ := value_;
      ELSIF (name_ = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   IF contract_ IS NOT NULL THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,contract_);
   END IF;
   IF site_cluster_id_ IS NOT NULL THEN
      Site_Cluster_API.Exist(site_cluster_id_);
   END IF;
   IF (site_cluster_node_id_ IS NOT NULL) AND (site_cluster_id_ IS NOT NULL) THEN
      Site_Cluster_Node_API.Exist(site_cluster_id_, site_cluster_node_id_);
   END IF;
END Validate_Params;


-- Fetch_Zone_For_Addr_Details
--   This method will be called to find the valid zone details for given address information.
PROCEDURE Fetch_Zone_For_Addr_Details (
	freight_map_id_  OUT    VARCHAR2,
   zone_id_         OUT    VARCHAR2,
   zone_info_exist_ IN OUT VARCHAR2,
   contract_        IN     VARCHAR2,
   ship_via_code_   IN     VARCHAR2,
   zip_code_        IN     VARCHAR2,
   city_            IN     VARCHAR2,
   county_          IN     VARCHAR2,
   state_           IN     VARCHAR2,
   country_         IN     VARCHAR2 )
IS
BEGIN
   Find_Zone_Cust_Info___ (freight_map_id_, zone_id_, zone_info_exist_,
                           contract_, ship_via_code_, zip_code_, city_,
                           county_, state_, country_);  
END Fetch_Zone_For_Addr_Details;


PROCEDURE Fetch_Zone_For_Cust_Addr (
   freight_map_id_      OUT VARCHAR2,
   zone_id_             OUT VARCHAR2,
   customer_no_         IN  VARCHAR2,
   ship_addr_no_        IN  VARCHAR2,
   contract_            IN  VARCHAR2,
   ship_via_code_       IN  VARCHAR2 )
IS
   zone_info_exist_  VARCHAR2(5):='FALSE';
BEGIN
   Find_Zone_For_Cust_Addr___(freight_map_id_,
                              zone_id_,
                              zone_info_exist_,
                              customer_no_,
                              ship_addr_no_,
                              contract_,
                              ship_via_code_);
END Fetch_Zone_For_Cust_Addr;



