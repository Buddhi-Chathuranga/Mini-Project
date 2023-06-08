-----------------------------------------------------------------------------
--
--  Logical unit: AddressSetup
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160505  ChguLK  STRCLOC-369, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

lfcr_  CONSTANT VARCHAR2(2) := CHR(13)||CHR(10);

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Lines___ (
   max_len_   OUT NUMBER,
   str_       IN  VARCHAR2 )
IS
   len_ NUMBER := 0;
   max_ NUMBER := 0;
   nl_  NUMBER := 0;
BEGIN
   FOR n_ IN 1 .. LENGTH(str_) LOOP
      IF (SUBSTR(str_, n_, 1) = CHR(10)) THEN
         nl_  := n_;
         IF (len_ > max_) THEN
            max_ := len_;
         END IF;
         len_ := 0;
      ELSIF (SUBSTR(str_, n_, 1) != CHR(13)) THEN
         len_ := len_ + 1;
      END IF;
   END LOOP;
   IF (LENGTH(str_) - nl_ > max_) THEN
      max_ := LENGTH(str_) - nl_;
   END IF;
   max_len_   := max_;
END Check_Lines___;


FUNCTION Concat_Addr_Fields___ (
   country_  IN VARCHAR2,
   address1_ IN VARCHAR2,
   address2_ IN VARCHAR2,
   address3_ IN VARCHAR2,
   address4_ IN VARCHAR2,
   address5_ IN VARCHAR2,
   address6_ IN VARCHAR2,
   zip_code_ IN VARCHAR2,
   city_     IN VARCHAR2,
   county_   IN VARCHAR2,
   state_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   address_       VARCHAR2(2000);
   part1_         VARCHAR2(100);
   part2_         VARCHAR2(100);
   part3_         VARCHAR2(100);
   part4_         VARCHAR2(100);
   part5_         VARCHAR2(100);
   part6_         VARCHAR2(100);
   part7_         VARCHAR2(100);
   part8_         VARCHAR2(100);
   part9_         VARCHAR2(100);
BEGIN
   address_pres_ := Address_Presentation_API.Get_Address_Record(country_);
   -- Build the 10 lines of the address.
   FOR line_ IN 1..10 LOOP
      part1_ := NULL;
      part2_ := NULL;
      part3_ := NULL;
      part4_ := NULL;
      part5_ := NULL;
      part6_ := NULL;
      part7_ := NULL;
      part8_ := NULL;
      part9_ := NULL;
      IF (address_pres_.address1_row = line_) THEN
         IF (address_pres_.address1_order = 1) THEN
            part1_ := address1_;
         ELSIF (address_pres_.address1_order = 2) THEN
            part2_ := address1_;
         ELSIF (address_pres_.address1_order = 3) THEN
            part3_ := address1_;
         ELSIF (address_pres_.address1_order = 4) THEN
            part4_ := address1_;
         ELSIF (address_pres_.address1_order = 5) THEN
            part5_ := address1_;
         ELSIF (address_pres_.address1_order = 6) THEN
            part6_ := address1_;
         ELSIF (address_pres_.address1_order = 7) THEN
            part7_ := address1_;
         ELSIF (address_pres_.address1_order = 8) THEN
            part8_ := address1_;
         ELSIF (address_pres_.address1_order = 9) THEN
            part9_ := address1_;
         ELSE
            part1_ := address1_;
         END IF;
      END IF;      
      IF (address_pres_.address2_row = line_) THEN
         IF (address_pres_.address2_order = 1) THEN
            part1_ := address2_;
         ELSIF (address_pres_.address2_order = 2) THEN
            part2_ := address2_;
         ELSIF (address_pres_.address2_order = 3) THEN
            part3_ := address2_;
         ELSIF (address_pres_.address2_order = 4) THEN
            part4_ := address2_;
         ELSIF (address_pres_.address2_order = 5) THEN
            part5_ := address2_;
         ELSIF (address_pres_.address2_order = 6) THEN
            part6_ := address2_;
         ELSIF (address_pres_.address2_order = 7) THEN
            part7_ := address2_;
         ELSIF (address_pres_.address2_order = 8) THEN
            part8_ := address2_;
         ELSIF (address_pres_.address2_order = 9) THEN
            part9_ := address2_;   
         ELSE
            part1_ := address2_;
         END IF;
      END IF; 
      IF (address_pres_.address3_row = line_) THEN
         IF (address_pres_.address3_order = 1) THEN
            part1_ := address3_;
         ELSIF (address_pres_.address3_order = 2) THEN
            part2_ := address3_;
         ELSIF (address_pres_.address3_order = 3) THEN
            part3_ := address3_;
         ELSIF (address_pres_.address3_order = 4) THEN
            part4_ := address3_;
         ELSIF (address_pres_.address3_order = 5) THEN
            part5_ := address3_;
         ELSIF (address_pres_.address3_order = 6) THEN
            part6_ := address3_;
         ELSIF (address_pres_.address3_order = 7) THEN
            part7_ := address3_;
         ELSIF (address_pres_.address3_order = 8) THEN
            part8_ := address3_;
         ELSIF (address_pres_.address3_order = 9) THEN
            part9_ := address3_;   
         ELSE
            part1_ := address3_;
         END IF;
      END IF;
      IF (address_pres_.address4_row = line_) THEN
         IF (address_pres_.address4_order = 1) THEN
            part1_ := address4_;
         ELSIF (address_pres_.address4_order = 2) THEN
            part2_ := address4_;
         ELSIF (address_pres_.address4_order = 3) THEN
            part3_ := address4_;
         ELSIF (address_pres_.address4_order = 4) THEN
            part4_ := address4_;
         ELSIF (address_pres_.address4_order = 5) THEN
            part5_ := address4_;
         ELSIF (address_pres_.address4_order = 6) THEN
            part6_ := address4_;
         ELSIF (address_pres_.address4_order = 7) THEN
            part7_ := address4_;
         ELSIF (address_pres_.address4_order = 8) THEN
            part8_ := address4_;
         ELSIF (address_pres_.address4_order = 9) THEN
            part9_ := address4_;   
         ELSE
            part1_ := address4_;
         END IF;
      END IF;
      IF (address_pres_.address5_row = line_) THEN
         IF (address_pres_.address5_order = 1) THEN
            part1_ := address5_;
         ELSIF (address_pres_.address5_order = 2) THEN
            part2_ := address5_;
         ELSIF (address_pres_.address5_order = 3) THEN
            part3_ := address5_;
         ELSIF (address_pres_.address5_order = 4) THEN
            part4_ := address5_;
         ELSIF (address_pres_.address5_order = 5) THEN
            part5_ := address5_;
         ELSIF (address_pres_.address5_order = 6) THEN
            part6_ := address5_;
         ELSIF (address_pres_.address5_order = 7) THEN
            part7_ := address5_;
         ELSIF (address_pres_.address5_order = 8) THEN
            part8_ := address5_;
         ELSIF (address_pres_.address5_order = 9) THEN
            part9_ := address5_;   
         ELSE
            part1_ := address5_;
         END IF;
      END IF;
      IF (address_pres_.address6_row = line_) THEN
         IF (address_pres_.address6_order = 1) THEN
            part1_ := address6_;
         ELSIF (address_pres_.address6_order = 2) THEN
            part2_ := address6_;
         ELSIF (address_pres_.address6_order = 3) THEN
            part3_ := address6_;
         ELSIF (address_pres_.address6_order = 4) THEN
            part4_ := address6_;
         ELSIF (address_pres_.address6_order = 5) THEN
            part5_ := address6_;
         ELSIF (address_pres_.address6_order = 6) THEN
            part6_ := address6_;
         ELSIF (address_pres_.address6_order = 7) THEN
            part7_ := address6_;
         ELSIF (address_pres_.address6_order = 8) THEN
            part8_ := address6_;
         ELSIF (address_pres_.address6_order = 9) THEN
            part9_ := address6_;   
         ELSE
            part1_ := address6_;
         END IF;
      END IF;
      IF (address_pres_.zip_code_row = line_) THEN
         IF (address_pres_.zip_code_order = 1) THEN
            part1_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 2) THEN
            part2_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 3) THEN
            part3_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 4) THEN
            part4_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 5) THEN
            part5_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 6) THEN
            part6_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 7) THEN
            part7_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 8) THEN
            part8_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 9) THEN
            part9_ := zip_code_;   
         ELSE
            part1_ := zip_code_;
         END IF;
      END IF;      
      IF (address_pres_.city_row = line_) THEN
         IF (address_pres_.city_order = 1) THEN
            part1_ := city_;
         ELSIF (address_pres_.city_order = 2) THEN
            part2_ := city_;
         ELSIF (address_pres_.city_order = 3) THEN
            part3_ := city_;
         ELSIF (address_pres_.city_order = 4) THEN
            part4_ := city_;
         ELSIF (address_pres_.city_order = 5) THEN
            part5_ := city_;
         ELSIF (address_pres_.city_order = 6) THEN
            part6_ := city_;
         ELSIF (address_pres_.city_order = 7) THEN
            part7_ := city_;
         ELSIF (address_pres_.city_order = 8) THEN
            part8_ := city_;
         ELSIF (address_pres_.city_order = 9) THEN
            part9_ := city_;  
         ELSE
            part1_ := city_;
         END IF;
      END IF;      
      IF (address_pres_.county_row = line_) THEN
         IF (address_pres_.county_order = 1) THEN
            part1_ := county_;
         ELSIF (address_pres_.county_order = 2) THEN
            part2_ := county_;
         ELSIF (address_pres_.county_order = 3) THEN
            part3_ := county_;
         ELSIF (address_pres_.county_order = 4) THEN
            part4_ := county_;
         ELSIF (address_pres_.county_order = 5) THEN
            part5_ := county_;
         ELSIF (address_pres_.county_order = 6) THEN
            part6_ := county_;
         ELSIF (address_pres_.county_order = 7) THEN
            part7_ := county_;
         ELSIF (address_pres_.county_order = 8) THEN
            part8_ := county_;
         ELSIF (address_pres_.county_order = 9) THEN
            part9_ := county_;     
         ELSE
            part1_ := county_;
         END IF;
      END IF;      
      IF (address_pres_.state_row = line_) THEN
         IF (address_pres_.state_order = 1) THEN
            part1_ := state_;
         ELSIF (address_pres_.state_order = 2) THEN
            part2_ := state_;
         ELSIF (address_pres_.state_order = 3) THEN
            part3_ := state_;
         ELSIF (address_pres_.state_order = 4) THEN
            part4_ := state_;
         ELSIF (address_pres_.state_order = 5) THEN
            part5_ := state_;
         ELSIF (address_pres_.state_order = 6) THEN
            part6_ := state_;
         ELSIF (address_pres_.state_order = 7) THEN
            part7_ := state_;
         ELSIF (address_pres_.state_order = 8) THEN
            part8_ := state_;
         ELSIF (address_pres_.state_order = 9) THEN
            part9_ := state_;  
         ELSE
            part1_ := state_;
         END IF;
      END IF;      
      IF (line_ = 1) THEN
         address_ := RTRIM(LTRIM(part1_ || ' ' || part2_ || ' ' || part3_ || ' ' || part4_ || ' ' || part5_|| ' ' || part6_|| ' ' || part7_|| ' ' || part8_|| ' ' || part9_));
      ELSE
         address_ := address_ || CHR(13) || CHR(10) || 
                     RTRIM(LTRIM(part1_ || ' ' || part2_ || ' ' || part3_ || ' ' || part4_ || ' ' || part5_|| ' ' || part6_|| ' ' || part7_|| ' ' || part8_|| ' ' || part9_));     
      END IF;
   END LOOP;
   RETURN address_;
END Concat_Addr_Fields___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Address_Validation_Data (
   logical_unit_         IN VARCHAR2,
   user_def_line_lenght_ IN NUMBER,
   max_line_lenght_      IN NUMBER,   
   mandatory_addr_line_  IN VARCHAR2 DEFAULT NULL )
IS
   newrec_        address_setup_tab%ROWTYPE;   
   oldrec_        address_setup_tab%ROWTYPE; 
BEGIN
   oldrec_ := Get_Object_By_Keys___(logical_unit_);
   IF (oldrec_.logical_unit IS NULL) THEN
      newrec_.logical_unit             := logical_unit_;
      newrec_.user_defined_line_length := user_def_line_lenght_;
      newrec_.max_line_length          := max_line_lenght_;
      newrec_.mandatory_address_line   := mandatory_addr_line_;
      New___(newrec_);
   END IF;
END Insert_Address_Validation_Data;
   

PROCEDURE Validate_Address_Attributes (
   logical_unit_ IN     VARCHAR2,
   country_      IN     VARCHAR2,
   address1_     IN     VARCHAR2,
   address2_     IN     VARCHAR2,
   address3_     IN     VARCHAR2,
   address4_     IN     VARCHAR2,
   address5_     IN     VARCHAR2,
   address6_     IN     VARCHAR2,
   zip_code_     IN     VARCHAR2,
   city_         IN     VARCHAR2,
   county_       IN     VARCHAR2,
   state_        IN     VARCHAR2 ) 
IS
   user_defined_length_     NUMBER;
   max_length_              NUMBER;
   concat_address_          VARCHAR2(2000);
   CURSOR get_attr IS
      SELECT user_defined_line_length
      FROM   address_setup_tab
      WHERE  logical_unit = logical_unit_;
BEGIN
   concat_address_ := Concat_Addr_Fields___(country_, address1_, address2_, address3_, address4_, address5_, address6_, zip_code_, city_, county_, state_);
   IF (concat_address_ IS NOT NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO user_defined_length_;
      CLOSE get_attr;
      Check_Lines___(max_length_, concat_address_);
      IF (max_length_ > user_defined_length_) THEN
         Error_SYS.Appl_General(logical_unit_, 'VALUE_TOO_LONG: Number of characters entered for address row(s) has exceeded the ''User Defined Row Length'' specified in the Address set-up.');
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Trace_SYS.Message('No data found'); 
END Validate_Address_Attributes;   
   

PROCEDURE Validate_Address (
   country_code_ IN VARCHAR2,
   state_code_   IN VARCHAR2,
   county_code_  IN VARCHAR2,
   city_code_    IN VARCHAR2 )
IS
   address_info_           Enterp_Address_Country_API.Public_Rec;
   state_presentation_     VARCHAR2(20);
   county_presentation_    VARCHAR2(20);
   city_presentation_      VARCHAR2(20);
   tstate_code_            VARCHAR2(35);
   tcounty_code_           VARCHAR2(35);
   tcity_code_             VARCHAR2(35);
   validate_state_code_    VARCHAR2(5);
   validate_county_code_   VARCHAR2(5);
   validate_city_code_     VARCHAR2(5);
   CURSOR get_state IS
      SELECT state_code
      FROM   state_codes_tab
      WHERE  country_code = country_code_
      AND    state_name   = tstate_code_;
   CURSOR get_county IS
      SELECT county_code
      FROM   county_code_tab
      WHERE  country_code = country_code_
      AND    state_code   = tstate_code_
      AND    county_name  = county_code_;
   CURSOR get_city IS
      SELECT city_code
      FROM   city_code_tab
      WHERE  country_code = country_code_
      AND    state_code   = tstate_code_
      AND    county_code  = tcounty_code_
      AND    city_name    = city_code_;
BEGIN
   address_info_         := Enterp_Address_Country_API.Get(country_code_);
   validate_state_code_  := address_info_.validate_state_code;
   validate_county_code_ := address_info_.validate_county_code;
   validate_city_code_   := address_info_.validate_city_code;
   tstate_code_          := state_code_;
   tcounty_code_         := county_code_;
   tcity_code_           := city_code_;
   state_presentation_   := Enterp_Address_Country_API.Get_State_Presentation_Db(country_code_);
   county_presentation_  := Enterp_Address_Country_API.Get_County_Presentation_Db(country_code_);
   city_presentation_    := Enterp_Address_Country_API.Get_City_Presentation_Db(country_code_);
   IF (tcounty_code_ IS NOT NULL) AND (tstate_code_ IS NULL) THEN
      tstate_code_ := '*';
   END IF;
   IF (tcity_code_ IS NOT NULL) THEN
      tstate_code_  := NVL(tstate_code_,'*');
      tcounty_code_ := NVL(tcounty_code_,'*');
   END IF;
   IF (state_presentation_ = 'NAMES') THEN
      OPEN  get_state;
      FETCH get_state INTO tstate_code_;
      CLOSE get_state;
      IF (tstate_code_ IS NULL) THEN
         tstate_code_  := state_code_;
      END IF;
   END IF;
   IF (county_presentation_ = 'NAMES') THEN
      OPEN  get_county;
      FETCH get_county INTO tcounty_code_;
      CLOSE get_county;
      IF (tcounty_code_ IS NULL) THEN
         tcounty_code_  := county_code_;
      END IF;
   END IF;
   IF (city_presentation_ = 'NAMES') THEN
      OPEN  get_city;
      FETCH get_city INTO tcity_code_;
      CLOSE get_city;
      IF (tcity_code_ IS NULL) THEN
         tcity_code_  := city_code_;
      END IF;
   END IF;
   -- Validate State Codes
   IF (validate_state_code_ = 'TRUE') THEN
      IF (tstate_code_ IS NOT NULL) THEN
         State_Codes_API.Exist(country_code_, tstate_code_);
      END IF;
   END IF;
   -- Validate County Codes
   IF (validate_county_code_ = 'TRUE') THEN
      IF (tcounty_code_ IS NOT NULL) THEN
         County_Code_API.Exist(country_code_, tstate_code_, tcounty_code_);
      END IF;
   END IF;
   -- Validate City Codes
   IF (validate_city_code_ = 'TRUE') THEN
      IF (tcity_code_ IS NOT NULL) THEN
         City_Code_API.Exist(country_code_, tstate_code_, tcounty_code_, tcity_code_);
      END IF;
   END IF;
END Validate_Address;


PROCEDURE Check_Nullable_Address_Fields (
   logical_unit_ IN VARCHAR2,
   address1_     IN VARCHAR2,
   address2_     IN VARCHAR2,
   address3_     IN VARCHAR2,
   address4_     IN VARCHAR2,
   address5_     IN VARCHAR2,
   address6_     IN VARCHAR2 )
IS
   mandatory_address_ VARCHAR2(20);
   CURSOR get_mand_addr IS
      SELECT mandatory_address_line
      FROM   address_setup_tab
      WHERE  logical_unit = logical_unit_;
BEGIN
   OPEN  get_mand_addr;
   FETCH get_mand_addr INTO mandatory_address_;
   CLOSE get_mand_addr;
   IF (mandatory_address_ = 'ADDRESS1') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS1', address1_);
   ELSIF (mandatory_address_ ='ADDRESS2') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS2', address2_);
   ELSIF (mandatory_address_ ='ADDRESS3') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS3', address3_);
   ELSIF (mandatory_address_ ='ADDRESS4') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS4', address4_);
   ELSIF (mandatory_address_ ='ADDRESS5') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS5', address5_);
   ELSIF (mandatory_address_ ='ADDRESS6') THEN
      Error_SYS.Check_Not_Null(logical_unit_, 'ADDRESS6', address6_);
   END IF;  
END Check_Nullable_Address_Fields;
