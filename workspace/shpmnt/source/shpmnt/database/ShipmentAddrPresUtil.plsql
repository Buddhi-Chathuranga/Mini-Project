-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentAddrPresUtil
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100513  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  050920  MaEelk   Removed unused variables.
--  040226  IsWilk   Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes----------------------
--  020628  DaMase   Obsolete Check_Address_Presentation because of new ENTERPRISE
--                   handling of Address_Presentation
--  020527  DaMase   Codereview, tried to improve readability.
--  020502  MaGu     Added call to General_SYS.Init_Method in methods Check_Address_Presentation,
--                   Get_Order_Address_Line___ and Get_Formatted_Address.
--  020419  zimolk   Added Get_Order_Address_Line___.
--  020224  zimolk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE formatted_addr_lines  IS RECORD
   (addr_line1 VARCHAR2(100),
    addr_line2 VARCHAR2(100),
    addr_line3 VARCHAR2(100),
    addr_line4 VARCHAR2(100),
    addr_line5 VARCHAR2(100));

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Order_Address_Line___
--   Returns a specified row of the address in the old format. The old format
--   was five separate fields. The difference is that it returns the County as well.
FUNCTION Get_Order_Address_Line___ (
   address1_ IN VARCHAR2,
   address2_ IN VARCHAR2,
   zip_code_ IN VARCHAR2,
   city_     IN VARCHAR2,
   state_    IN VARCHAR2,
   county_   IN VARCHAR2,
   country_  IN VARCHAR2,
   line_no_  IN NUMBER ) RETURN VARCHAR2
IS
   address_pres_  ADDRESS_PRESENTATION_API.Public_Rec_Address;
   line_    NUMBER;
   row1_    VARCHAR2(35);
   row2_    VARCHAR2(35);
   row3_    VARCHAR2(35);
   row4_    VARCHAR2(35);
   row5_    VARCHAR2(35);
BEGIN

   address_pres_ := Address_Presentation_API.Get_Address_Record(country_);

   line_ := line_no_;

   -- If line_no_ = 0 then return the last line.
   --    Set line_no_ to the highest row in the definition
   IF (line_ = 0) THEN
      line_ := address_pres_.address1_row;
      IF (address_pres_.address2_row > line_) THEN
         line_ := address_pres_.address2_row;
      END IF;
      IF (address_pres_.zip_code_row > line_) THEN
         line_ := address_pres_.zip_code_row;
      END IF;
      IF (address_pres_.city_row > line_) THEN
         line_ := address_pres_.city_row;
      END IF;
      IF (address_pres_.state_row > line_) THEN
         line_ := address_pres_.state_row;
      END IF;
   END IF;
   -- Check the different address fields for the correct line number.
   -- Put the value in the right order.
   IF (address_pres_.address1_row = line_) THEN
      IF (address_pres_.address1_order = 1) THEN
         row1_ := address1_;
      ELSIF (address_pres_.address1_order = 2) THEN
         row2_ := address1_;
      ELSIF (address_pres_.address1_order = 3) THEN
         row3_ := address1_;
      ELSIF (address_pres_.address1_order = 4) THEN
         row4_ := address1_;
      ELSIF (address_pres_.address1_order = 5) THEN
         row5_ := address1_;
      ELSE
         row1_ := address1_;
      END IF;
   END IF;
   IF (address_pres_.address2_row = line_) THEN
      IF (address_pres_.address2_order = 1) THEN
         row1_ := address2_;
      ELSIF (address_pres_.address2_order = 2) THEN
         row2_ := address2_;
      ELSIF (address_pres_.address2_order = 3) THEN
         row3_ := address2_;
      ELSIF (address_pres_.address2_order = 4) THEN
         row4_ := address2_;
      ELSIF (address_pres_.address2_order = 5) THEN
         row5_ := address2_;
      ELSE
         row1_ := address2_;
      END IF;
   END IF;
   IF (address_pres_.zip_code_row = line_) THEN
      IF (address_pres_.zip_code_order = 1) THEN
         row1_ := zip_code_;
      ELSIF (address_pres_.zip_code_order = 2) THEN
         row2_ := zip_code_;
      ELSIF (address_pres_.zip_code_order = 3) THEN
         row3_ := zip_code_;
      ELSIF (address_pres_.zip_code_order = 4) THEN
         row4_ := zip_code_;
      ELSIF (address_pres_.zip_code_order = 5) THEN
         row5_ := zip_code_;
      ELSE
         row1_ := zip_code_;
      END IF;
   END IF;
   IF (address_pres_.city_row = line_) THEN
      IF (address_pres_.city_order = 1) THEN
         row1_ := city_;
      ELSIF (address_pres_.city_order = 2) THEN
         row2_ := city_;
      ELSIF (address_pres_.city_order = 3) THEN
         row3_ := city_;
      ELSIF (address_pres_.city_order = 4) THEN
         row4_ := city_;
      ELSIF (address_pres_.city_order = 5) THEN
         row5_ := city_;
      ELSE
         row1_ := city_;
      END IF;
   END IF;
   IF (address_pres_.state_row = line_) THEN
      IF (address_pres_.state_order = 1) THEN
         row1_ := state_;
      ELSIF (address_pres_.state_order = 2) THEN
         row2_ := state_;
      ELSIF (address_pres_.state_order = 3) THEN
         row3_ := state_;
      ELSIF (address_pres_.state_order = 4) THEN
         row4_ := state_;
      ELSIF (address_pres_.state_order = 5) THEN
         row5_ := state_;
      ELSE
         row1_ := state_;
      END IF;
   END IF;
   IF (address_pres_.county_row = line_) THEN
      IF (address_pres_.county_order = 1) THEN
         row1_ := county_;
      ELSIF (address_pres_.county_order = 2) THEN
         row2_ := county_;
      ELSIF (address_pres_.county_order = 3) THEN
         row3_ := county_;
      ELSIF (address_pres_.county_order = 4) THEN
         row4_ := county_;
      ELSIF (address_pres_.county_order = 5) THEN
         row5_ := county_;
      ELSE
         row1_ := county_;
      END IF;
   END IF;

   --Concatenate the different parts.
   RETURN rtrim(ltrim(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
END Get_Order_Address_Line___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Formatted_Address
--   Public method to return the formatted address.
FUNCTION Get_Formatted_Address (
   address1_ IN VARCHAR2,
   address2_ IN VARCHAR2,
   zip_code_ IN VARCHAR2,
   city_     IN VARCHAR2,
   state_    IN VARCHAR2,
   county_   IN VARCHAR2,
   country_  IN VARCHAR2 ) RETURN formatted_addr_lines
IS
   addr_line_  VARCHAR2(1000);
   addr_rec_   Formatted_Addr_Lines;
BEGIN
   
    -- Convert the ship address to the address presentation format.
   FOR i in 1..5 LOOP
      addr_line_ := Get_Order_Address_Line___(address1_,
                                              address2_,
                                              zip_code_,
                                              city_,
                                              state_,
                                              county_,
                                              country_,
                                              i);
      IF (i = 1) THEN
         addr_rec_.addr_line1 := SUBSTR(addr_line_, 1, 100);
      ELSIF (i = 2) THEN
         addr_rec_.addr_line2 := SUBSTR(addr_line_, 1, 100);
      ELSIF (i = 3) THEN
         addr_rec_.addr_line3 := SUBSTR(addr_line_, 1, 100);
      ELSIF (i = 4) THEN
         addr_rec_.addr_line4 := SUBSTR(addr_line_, 1, 100);
      ELSIF (i = 5) THEN
         addr_rec_.addr_line5 := SUBSTR(addr_line_, 1, 100);
      END IF;
   END LOOP;

   RETURN addr_rec_;
END Get_Formatted_Address;



