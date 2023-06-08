-----------------------------------------------------------------------------
--
--  Logical unit: UpdateOrdAddressUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200610  KiSalk  Bug 154335(SCZ-10322), In Get_Order_Address_Line, increased the length of row1_, row2_, row3_, row4_ and row5_ to 100 from 35
--                  because parameters address3_ to address6_ can have values upto 100 long.
--  160928  TiRalk  STRSC-4204, Modified Get_Cust_Ord_Del_Address, Get_Format_Address to display county correctly.
--  160915  TiRalk  STRSC-3950, Added methods Get_Cust_Ord_Del_Address, Get_Format_Address to get the address according to presentation layout
--  160915          to display addresses properly for customer order and order quotation search domains.
--  160516  Chgulk  STRLOC-80 Added new Address fields.
--  131105  MAHPLK  Renamed CUSTOMER_ORDER_ADDRESS to CUSTOMER_ORDER_ADDRESS_2 ini Get_Addr_For_Country.
--  100603  MoNilk  Modified Ref from 'ApplicationCountry' to 'IsoCountry' in DELNOTE_ADDRESS_CORRECTION.country_code.
--  100513  KRPELK  Merge Rose Method Documentation.
--  090925  MaMalk  Removed unused view ORDER_ADDRESS_CORRECTION.
--  -------------------- 14.0.0 --------------------------------------------- 
--  060517  MiErlk  Enlarge Identity - Changed view comment
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  -------------------- 13.4.0 ---------------------------------------------
--  050920  NaLrlk  Removed unused variables.
--  050318  NaWilk  Bug 46159, Added function Get_All_Order_Address_Lines.
--  040220  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  --------------- Edge Package Group 3 Unicode Changes------------------------
--  020617  AjShlk  Bug 29312, Added county field to Get_Order_Address_Line.
--  020227  CaStse  Removed check against the view ADDRESS_PRESENTATION in Get_Order_Address_Line.
--  010529  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method to procedures Get_Addr_For_Country
--                  and Get_Order_Address_Line.
--  001003  MaGu    Modified Get_Addr_For_Country to not get example address with null value.
--  000920  MaGu    Added check for address presentation data in Get_Order_Address_Line.
--  000912  MaGu    Added view DELNOTE_ADDRESS_CORRECTION. Also added undefine
--                  statements for manual defines.
--  000905  MaGu    Added view ORDER_ADDRESS_CORRECTION.
--  000905  MaGu    Added procedure Get_Addr_For_Country.
--  000830  MaGu    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Order_Address_Line
--   The Get_Order_Address_Line function returns a specified row of the
--   address in the old address format. Used when saving an address, because
--   it is stored in two formats. The old format was five separate fields.
FUNCTION Get_Order_Address_Line (
   address1_ IN VARCHAR2,
   address2_ IN VARCHAR2,
   address3_ IN VARCHAR2,
   address4_ IN VARCHAR2,
   address5_ IN VARCHAR2,
   address6_ IN VARCHAR2,
   zip_code_ IN VARCHAR2,
   city_     IN VARCHAR2,
   state_    IN VARCHAR2,
   county_ IN VARCHAR2,
   country_  IN VARCHAR2,
   line_no_  IN NUMBER ) RETURN VARCHAR2
IS
   address_pres_  ADDRESS_PRESENTATION_API.Public_Rec_Address;
   line_    NUMBER;
   row1_    VARCHAR2(100);
   row2_    VARCHAR2(100);
   row3_    VARCHAR2(100);
   row4_    VARCHAR2(100);
   row5_    VARCHAR2(100);
   
BEGIN

   address_pres_ := ADDRESS_PRESENTATION_API.Get_Address_Record(country_);
   line_ := line_no_;
   -- If line_no_ = 0 then return the last line.
   --    Set line_no_ to the highest row in the definition
   IF ( line_ = 0 ) THEN
      line_ := address_pres_.address1_row;
      IF ( address_pres_.address2_row > line_ ) THEN
         line_ := address_pres_.address2_row;
      END IF;
      IF ( address_pres_.address3_row > line_ ) THEN
         line_ := address_pres_.address3_row;
      END IF;
      IF ( address_pres_.address4_row > line_ ) THEN
         line_ := address_pres_.address4_row;
      END IF;
      IF ( address_pres_.address5_row > line_ ) THEN
         line_ := address_pres_.address5_row;
      END IF;
      IF ( address_pres_.address6_row > line_ ) THEN
         line_ := address_pres_.address6_row;
      END IF;
      IF ( address_pres_.zip_code_row > line_ ) THEN
         line_ := address_pres_.zip_code_row;
      END IF;
      IF ( address_pres_.city_row > line_ ) THEN
         line_ := address_pres_.city_row;
      END IF;
      IF ( address_pres_.state_row > line_ ) THEN
         line_ := address_pres_.state_row;
      END IF;
      IF ( address_pres_.county_row > line_ ) THEN
         line_ := address_pres_.county_row;
      END IF;
   END IF;

   -- Check the different address fields for the correct line number.
   -- Put the value in the right order.

   IF ( address_pres_.address1_row = line_ ) THEN
      IF ( address_pres_.address1_order = 1) THEN
         row1_ := address1_;
      ELSIF ( address_pres_.address1_order = 2 ) THEN
         row2_ := address1_;
      ELSIF ( address_pres_.address1_order = 3 ) THEN
         row3_ := address1_;
      ELSIF ( address_pres_.address1_order = 4 ) THEN
         row4_ := address1_;
      ELSIF ( address_pres_.address1_order = 5 ) THEN
         row5_ := address1_;
      ELSE
         row1_ := address1_;
      END IF;
   END IF;

   IF ( address_pres_.address2_row = line_ ) THEN
      IF ( address_pres_.address2_order = 1) THEN
         row1_ := address2_;
      ELSIF ( address_pres_.address2_order = 2 ) THEN
         row2_ := address2_;
      ELSIF ( address_pres_.address2_order = 3 ) THEN
         row3_ := address2_;
      ELSIF ( address_pres_.address2_order = 4 ) THEN
         row4_ := address2_;
      ELSIF ( address_pres_.address2_order = 5 ) THEN
         row5_ := address2_;
      ELSE
         row1_ := address2_;
      END IF;
   END IF;
   
   IF ( address_pres_.address3_row = line_ ) THEN
      IF ( address_pres_.address3_order = 1) THEN
         row1_ := address3_;
      ELSIF ( address_pres_.address3_order = 2 ) THEN
         row2_ := address3_;
      ELSIF ( address_pres_.address3_order = 3 ) THEN
         row3_ := address3_;
      ELSIF ( address_pres_.address3_order = 4 ) THEN
         row4_ := address3_;
      ELSIF ( address_pres_.address4_order = 5 ) THEN
         row5_ := address4_;
      ELSE
         row1_ := address3_;
      END IF;
   END IF;
   
   IF ( address_pres_.address4_row = line_ ) THEN
      IF ( address_pres_.address4_order = 1) THEN
         row1_ := address4_;
      ELSIF ( address_pres_.address4_order = 2 ) THEN
         row2_ := address4_;
      ELSIF ( address_pres_.address4_order = 3 ) THEN
         row3_ := address4_;
      ELSIF ( address_pres_.address4_order = 4 ) THEN
         row4_ := address4_;
      ELSIF ( address_pres_.address4_order = 5 ) THEN
         row5_ := address4_;
      ELSE
         row1_ := address4_;
      END IF;
   END IF;
   
   IF ( address_pres_.address5_row = line_ ) THEN
      IF ( address_pres_.address5_order = 1) THEN
         row1_ := address5_;
      ELSIF ( address_pres_.address5_order = 2 ) THEN
         row2_ := address5_;
      ELSIF ( address_pres_.address5_order = 3 ) THEN
         row3_ := address5_;
      ELSIF ( address_pres_.address5_order = 4 ) THEN
         row4_ := address5_;
      ELSIF ( address_pres_.address5_order = 5 ) THEN
         row5_ := address5_;
      ELSE
         row1_ := address5_;
      END IF;
   END IF;
   
   IF ( address_pres_.address6_row = line_ ) THEN
      IF ( address_pres_.address6_order = 1) THEN
         row1_ := address6_;
      ELSIF ( address_pres_.address6_order = 2 ) THEN
         row2_ := address6_;
      ELSIF ( address_pres_.address6_order = 3 ) THEN
         row3_ := address6_;
      ELSIF ( address_pres_.address6_order = 4 ) THEN
         row4_ := address6_;
      ELSIF ( address_pres_.address6_order = 5 ) THEN
         row5_ := address6_;
      ELSE
         row1_ := address6_;
      END IF;
   END IF;
   
   
   IF ( address_pres_.zip_code_row = line_ ) THEN
      IF ( address_pres_.zip_code_order = 1) THEN
         row1_ := zip_code_;
      ELSIF ( address_pres_.zip_code_order = 2 ) THEN
         row2_ := zip_code_;
      ELSIF ( address_pres_.zip_code_order = 3 ) THEN
         row3_ := zip_code_;
      ELSIF ( address_pres_.zip_code_order = 4 ) THEN
         row4_ := zip_code_;
      ELSIF ( address_pres_.zip_code_order = 5 ) THEN
         row5_ := zip_code_;
      ELSE
         row1_ := zip_code_;
      END IF;
   END IF;

   IF ( address_pres_.city_row = line_ ) THEN
      IF ( address_pres_.city_order = 1) THEN
         row1_ := city_;
      ELSIF ( address_pres_.city_order = 2 ) THEN
         row2_ := city_;
      ELSIF ( address_pres_.city_order = 3 ) THEN
         row3_ := city_;
      ELSIF ( address_pres_.city_order = 4 ) THEN
         row4_ := city_;
      ELSIF ( address_pres_.city_order = 5 ) THEN
         row5_ := city_;
      ELSE
         row1_ := city_;
      END IF;
   END IF;

   IF ( address_pres_.state_row = line_ ) THEN
      IF ( address_pres_.state_order = 1) THEN
         row1_ := state_;
      ELSIF ( address_pres_.state_order = 2 ) THEN
         row2_ := state_;
      ELSIF ( address_pres_.state_order = 3 ) THEN
         row3_ := state_;
      ELSIF ( address_pres_.state_order = 4 ) THEN
         row4_ := state_;
      ELSIF ( address_pres_.state_order = 5 ) THEN
         row5_ := state_;
      ELSE
         row1_ := state_;
      END IF;
   END IF;
   IF ( address_pres_.county_row = line_ ) THEN
      IF ( address_pres_.county_order = 1) THEN
         row1_ := county_;
      ELSIF ( address_pres_.county_order = 2 ) THEN
         row2_ := county_;
      ELSIF ( address_pres_.county_order = 3 ) THEN
         row3_ := county_;
      ELSIF ( address_pres_.county_order = 4 ) THEN
         row4_ := county_;
      ELSIF ( address_pres_.county_order = 5 ) THEN
         row5_ := county_;
      ELSE
         row1_ := county_;
      END IF;
   END IF;
   --Concatenate the different parts.
   RETURN RTRIM(LTRIM( row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_ ));
END Get_Order_Address_Line;
-- Get_Addr_For_Country
--   Fetch an example address record with a specific country code to
--   show the old address format. Used when updating to the new address
PROCEDURE Get_Addr_For_Country (
   address1_ OUT VARCHAR2,
   address2_ OUT VARCHAR2,
   address3_ OUT VARCHAR2,
   address4_ OUT VARCHAR2,
   address5_ OUT VARCHAR2,
   country_ IN VARCHAR2 )
IS
 -- Only fetch addr_2 to addr_6. addr_1 only contains address name and shall not be updated.
   CURSOR get_example IS
      SELECT addr_2, addr_3, addr_4, addr_5, addr_6
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE country_code = country_
      AND ((addr_2 IS NOT NULL) OR (addr_3 IS NOT NULL) OR (addr_4 IS NOT NULL) OR (addr_5 IS NOT NULL) OR (addr_6 IS NOT NULL));
BEGIN
   OPEN get_example;
   FETCH get_example INTO address1_, address2_, address3_, address4_, address5_;
   CLOSE get_example;
END Get_Addr_For_Country;


-- Get_All_Order_Address_Lines
--   Returns a string containing address according to the address
--   presentation format.
FUNCTION Get_All_Order_Address_Lines (
   country_code_ IN VARCHAR2,
   address1_     IN VARCHAR2 DEFAULT NULL,
   address2_     IN VARCHAR2 DEFAULT NULL,
   zip_code_     IN VARCHAR2 DEFAULT NULL,
   city_         IN VARCHAR2 DEFAULT NULL,
   state_        IN VARCHAR2 DEFAULT NULL,
   county_       IN VARCHAR2 DEFAULT NULL,
   country_      IN VARCHAR2 DEFAULT NULL,
   address3_     IN VARCHAR2 DEFAULT NULL,
   address4_     IN VARCHAR2 DEFAULT NULL,
   address5_     IN VARCHAR2 DEFAULT NULL,
   address6_     IN VARCHAR2 DEFAULT NULL) RETURN Address_Presentation_API.Address_Rec_Type
IS
   address_      VARCHAR2(2000);
   address_rec_  Address_Presentation_API.Address_Rec_Type;

BEGIN
   address_ := Address_Presentation_API.Format_Address(country_code_,
                                                       address1_,
                                                       address2_,
                                                       address3_,
                                                       address4_,
                                                       address5_,
                                                       address6_,
                                                       city_,
                                                       county_,
                                                       state_,
                                                       zip_code_,
                                                       country_);
   address_rec_ := Address_Presentation_API.Format_To_Line(address_);

   RETURN address_rec_;               
END Get_All_Order_Address_Lines;

-- Get_Cust_Ord_Del_Address
--   This method is used to display CO delivery address correctly in Customer Order search domain.
--   This will pass the all information we have and get the address according to the presentation layout.
--   This has been done because we store all the information and as we are not clearing any field upon 
--   changing the address in customer order address tab. So it is needed to get the proper address according
--   to the address presentation layout.
FUNCTION Get_Cust_Ord_Del_Address (
   order_no_         IN VARCHAR2,
   delivery_address_ IN VARCHAR2 ) RETURN VARCHAR2
IS    
   address1_      CUSTOMER_ORDER_ADDRESS_2.address1%TYPE;
   address2_      CUSTOMER_ORDER_ADDRESS_2.address2%TYPE;
   address3_      CUSTOMER_ORDER_ADDRESS_2.address3%TYPE;
   address4_      CUSTOMER_ORDER_ADDRESS_2.address4%TYPE;
   address5_      CUSTOMER_ORDER_ADDRESS_2.address5%TYPE;
   address6_      CUSTOMER_ORDER_ADDRESS_2.address6%TYPE;
   zip_code_      CUSTOMER_ORDER_ADDRESS_2.zip_code%TYPE;
   city_          CUSTOMER_ORDER_ADDRESS_2.city%TYPE;
   state_         CUSTOMER_ORDER_ADDRESS_2.state%TYPE;
   county_        CUSTOMER_ORDER_ADDRESS_2.county%TYPE;   
   country_code_  CUSTOMER_ORDER_ADDRESS_2.country_code%TYPE;
   address_       VARCHAR2(2000);
   
   CURSOR get_address IS
      SELECT address1, address2, address3, address4, address5, address6,
             zip_code, city, state, county, country_code
      FROM   CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_
      AND    ship_addr_no = delivery_address_;
BEGIN
   OPEN  get_address;
   FETCH get_address INTO address1_, address2_, address3_, address4_, address5_, address6_, 
                          zip_code_, city_, state_, county_, country_code_;
   CLOSE get_address;   
                                                
   address_ := Get_Format_Address(country_code_,
                                  address1_,
                                  address2_,
                                  address3_,
                                  address4_,
                                  address5_,
                                  address6_,
                                  city_,
                                  county_,
                                  state_,
                                  zip_code_,
                                  Iso_Country_API.Decode(country_code_));
                                                
   RETURN address_;
END Get_Cust_Ord_Del_Address;

-- Get_Format_Address
--   This method returns the full address according to the address presentation layout.
FUNCTION Get_Format_Address (
   country_code_ IN VARCHAR2,
   address1_     IN VARCHAR2 DEFAULT NULL,
   address2_     IN VARCHAR2 DEFAULT NULL,
   address3_     IN VARCHAR2 DEFAULT NULL,
   address4_     IN VARCHAR2 DEFAULT NULL,
   address5_     IN VARCHAR2 DEFAULT NULL,
   address6_     IN VARCHAR2 DEFAULT NULL,   
   city_         IN VARCHAR2 DEFAULT NULL,   
   county_       IN VARCHAR2 DEFAULT NULL,
   state_        IN VARCHAR2 DEFAULT NULL,
   zip_code_     IN VARCHAR2 DEFAULT NULL,
   country_      IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   address_       VARCHAR2(2000);
BEGIN    
   address_ := Address_Presentation_API.Format_Address(country_code_,
                                                       address1_,
                                                       address2_,
                                                       address3_,
                                                       address4_,
                                                       address5_,
                                                       address6_,
                                                       city_,
                                                       county_,
                                                       state_,
                                                       zip_code_,
                                                       country_);
   RETURN address_;   
END Get_Format_Address;
