-----------------------------------------------------------------------------
--
--  Logical unit: GtinFactoryUtil
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120130  NaLrlk   Replaced the method call Part_Catalog_API.Get_Active_Gtin_Part_No with Part_Gtin_API.Get_Part_Via_Identified_Gtin.
--  120126  NaLrlk   Modified the method Validate_Gtin_Digits to check the gtin field format.
--  100923  NaLrlk   Added methods Get_Auto_Created_Gtin and Get_Auto_Created_Gtin14.
--  090714  AmPalk   Bug 83121, Made the gtin a varchar2. Hence changed the in parameters of the Validate_Gtin_Digits and Calculate_Check_Digit.
--  080924  MiKulk   Estended the logics for GTIN_14
--  080409  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Validate_Gtin_Digits
--   Check whether the total number of digits on GTIN number exeeds the
--   allowed length for GTIN series and check digit is a valid one.
PROCEDURE Validate_Gtin_Digits (
   gtin_no_        IN VARCHAR2,
   gtin_series_db_ IN VARCHAR2 )
IS
   max_no_of_digits_            NUMBER;
   length_                      NUMBER;
   gtin_no_without_check_digit_ NUMBER;
   check_digit_                 NUMBER;
   temp_                        NUMBER;
BEGIN
   IF gtin_series_db_ <> 'FREE_FORMAT' THEN
      BEGIN      
         temp_ := TO_NUMBER(gtin_no_);
      EXCEPTION
         WHEN VALUE_ERROR THEN
            Error_SYS.Record_General(lu_name_, 'NUMBERERR: Only digits allowed for GTIN with GTIN series :P1.', Gtin_Series_API.Decode(gtin_series_db_));
      END;      
   END IF;

   CASE gtin_series_db_
      WHEN 'GTIN_8' THEN
         max_no_of_digits_ := 8;
      WHEN 'GTIN_12' THEN
         max_no_of_digits_ := 12;
      WHEN 'GTIN_13' THEN
         max_no_of_digits_ := 13;
      ELSE
         --GTIN_14 and FREE_FORMAT
         max_no_of_digits_ := 14;
   END CASE;

   length_ := LENGTH(gtin_no_);
   IF (gtin_series_db_ = Gtin_Series_API.DB_FREE_FORMAT) THEN
      IF (max_no_of_digits_ < length_) THEN
         Error_SYS.Record_General(lu_name_, 'GTINLENINVALID: The total number of digits for GTIN should be less than or equal to :P1 for GTIN series :P2.', max_no_of_digits_, Gtin_Series_API.Decode(gtin_series_db_));
      END IF;
   ELSE
      IF (length_ != max_no_of_digits_) THEN
         Error_SYS.Record_General(lu_name_, 'GTINTOOLONG: The total number of digits for GTIN should be :P1 for GTIN series :P2.', max_no_of_digits_, Gtin_Series_API.Decode(gtin_series_db_));
      END IF;
      -- extract gtin no without check digit from gtin_no_ removing it's last digit
      gtin_no_without_check_digit_ := SUBSTR(gtin_no_, 1, length_-1);

      -- calculate the check digit for company prefix  and gtin series value combination
      check_digit_ := Calculate_Check_Digit(gtin_no_without_check_digit_);

      -- validate last digit against the calculated check_digit_
      IF (SUBSTR(gtin_no_, length_) != check_digit_) THEN
         Error_SYS.Record_General(lu_name_, 'CHECKDIGITERROR: :P1 is an invalid GTIN.', gtin_no_);
      END IF;
   END IF;
END Validate_Gtin_Digits;


-- Validate_Digits_Length
--   Check whether the total number of digits on (company prefix, start, end, next) values
--   exceeds the allowed length for GTIN series.
PROCEDURE Validate_Digits_Length (
   company_prefix_ IN VARCHAR2,
   gtin_series_db_ IN VARCHAR2,
   start_value_    IN NUMBER,
   next_value_     IN NUMBER,
   end_value_      IN NUMBER )
IS
   max_no_of_digits_  NUMBER;
   remaining_length_  NUMBER;
BEGIN
   IF (start_value_ > next_value_) THEN
      Error_SYS.Record_General(lu_name_, 'STARTVALERRONE: Start value cannot be greater then the next value.');
   END IF;
   IF (start_value_ > end_value_) THEN
      Error_SYS.Record_General(lu_name_, 'STARTVALERRTWO: Start value cannot be greater then the end value.');
   END IF;
   IF (end_value_ < next_value_) THEN
      Error_SYS.Record_General(lu_name_, 'NEXTVALERROR: Next value cannot be greater then the end value.');
   END IF;

   CASE gtin_series_db_
      WHEN 'GTIN_8' THEN
         max_no_of_digits_ := 7;
      WHEN 'GTIN_12' THEN
         max_no_of_digits_ := 11;
      WHEN 'GTIN_13' THEN
         max_no_of_digits_ := 12;
      WHEN 'GTIN_14' THEN
         -- Reserve one digit for package indicator.
         max_no_of_digits_ := 12;
   END CASE;

   remaining_length_:= max_no_of_digits_ - LENGTH(company_prefix_);

   IF (LENGTH(start_value_) > remaining_length_) THEN
      Error_SYS.Record_General(lu_name_, 'STARTTOOLONG: The total number of digits on (company prefix + start value) should be less than :P1.', max_no_of_digits_);
   ELSIF (LENGTH(next_value_) > remaining_length_) THEN
      Error_SYS.Record_General(lu_name_, 'NEXTTOOLONG: The total number of digits on (company prefix + next value) should be less than :P1.', max_no_of_digits_);
   ELSIF (LENGTH(end_value_) > remaining_length_) THEN
      Error_SYS.Record_General(lu_name_, 'ENDTOOLONG: The total number of digits on (company prefix + end value) should be less than :P1.', max_no_of_digits_);
   END IF;
END Validate_Digits_Length;


@UncheckedAccess
FUNCTION Calculate_Check_Digit (
   gtin_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   odd_sum_   NUMBER := 0;
   even_sum_  NUMBER := 0;
   length_    NUMBER;
   i_         NUMBER;
   check_sum_ NUMBER := 0;
   multiple_of_ten_ NUMBER;
BEGIN
   length_ := LENGTH(gtin_no_);
   i_       := length_;
   -- Get the sum of the odd digits
   WHILE i_ > 0 LOOP
      odd_sum_ := odd_sum_ + SUBSTR(gtin_no_,i_, 1);
      i_ := i_ - 2;
   END LOOP;

   --get the sum of even digits
   i_ := length_ - 1;
   WHILE i_ > 0 LOOP
      even_sum_ := even_sum_ + SUBSTR(gtin_no_,i_, 1);
      i_ := i_ - 2;
   END LOOP;

   -- Add the sum of odd digits multiplied by 3 and the sum of the even digits
   check_sum_ := (odd_sum_ * 3) +  even_sum_;

   -- Now we need to calculate the nearest multiple of ten of the check_sum_
   -- first get the length of the check_sum -1
   length_    := LENGTH(check_sum_) - 1;
   IF (length_ = 0) THEN
      multiple_of_ten_ := 10;
   ELSE
      IF (SUBSTR(check_sum_, length_+1) = 0) THEN
         --Last digit is 0; So, check_sum_ is a multiple of ten
         multiple_of_ten_ := check_sum_;
      ELSE
         --the nearest multiple of ten is the first digit of check_sum mutiplied by the nearst poewr of ten.
         multiple_of_ten_ := (SUBSTR(check_sum_,1,length_) + 1) * 10;
      END IF;
   END IF;

   RETURN (multiple_of_ten_ - check_sum_);
END Calculate_Check_Digit;



-- Get_Auto_Created_Gtin
--   Create the GTIN number for a given company prefix / gtin series
--   and return the created gtin no and next value.
PROCEDURE Get_Auto_Created_Gtin (
   gtin_no_        OUT    VARCHAR2,
   next_value_     IN OUT NUMBER,
   company_prefix_ IN     VARCHAR2,
   gtin_series_db_ IN     VARCHAR2 )
IS
   remaining_length_    NUMBER;
   max_no_of_digits_    NUMBER;
   part_no_             VARCHAR2(25);
   package_indicator_   VARCHAR2(1) := NULL;
   filler_zero_digits_  VARCHAR2(13);
BEGIN

   CASE gtin_series_db_
      WHEN 'GTIN_8' THEN
         max_no_of_digits_ := 8;
      WHEN 'GTIN_12' THEN
         max_no_of_digits_ := 12;
      WHEN 'GTIN_13' THEN
         max_no_of_digits_ := 13;
      WHEN 'GTIN_14' THEN
         max_no_of_digits_ := 14;
   END CASE;

   -- Initial value for passing through the loop first time
   part_no_ := 'INIT_VAL'; 
   WHILE (part_no_ IS NOT NULL) LOOP
      IF (gtin_series_db_ = Gtin_Series_API.DB_GTIN14) THEN
         -- For the Gtin 14, the pkg indicator value to be zero.
         package_indicator_ := '0';
         remaining_length_ := max_no_of_digits_ - LENGTH(package_indicator_) - LENGTH(company_prefix_) - LENGTH(next_value_);
      ELSE
         remaining_length_ := max_no_of_digits_ - LENGTH(company_prefix_) - LENGTH(next_value_);
      END IF;

      IF (remaining_length_ < 1) THEN
         Error_SYS.Record_General(lu_name_, 'GTINFINISH: All the GTINs from GTIN series :P1 for the company prefix :P2 have been used.', Gtin_Series_API.Decode(gtin_series_db_), company_prefix_);
      END IF;

      -- Apending '0's before next value
      filler_zero_digits_ := NULL;
      IF (remaining_length_ > 1) THEN
         FOR i_ IN 1 .. (remaining_length_ - 1) LOOP
            filler_zero_digits_ := filler_zero_digits_ || '0';
         END LOOP;
      END IF;

      gtin_no_ := (company_prefix_ || filler_zero_digits_ || next_value_);

      IF (gtin_series_db_ = Gtin_Series_API.DB_GTIN14) THEN
         gtin_no_ := package_indicator_ || gtin_no_;
      END IF;
      gtin_no_ := gtin_no_ || Calculate_Check_Digit(gtin_no_);

      --Increase the next value by one and update the record
      next_value_ := next_value_ + 1;

      -- part_no_ will be null if GTIN is not identified by part catalog
      part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_);
   END LOOP;
END Get_Auto_Created_Gtin;


-- Get_Auto_Created_Gtin14
--   Create the GTIN 14 number for package to the given GTIN 13, 12 or 8
--   and package indicator.
@UncheckedAccess
FUNCTION Get_Auto_Created_Gtin14 (
   pkg_indicator_  IN  NUMBER,
   gtin_no_        IN  VARCHAR2 ) RETURN VARCHAR2
IS
   max_no_of_digits_            NUMBER;
   remaining_length_            NUMBER;
   gtin14_                      VARCHAR2(14);
   gtin_no_without_check_digit_ VARCHAR2(13);
   filler_zero_digits_          VARCHAR2(13);
BEGIN
   max_no_of_digits_ := LENGTH(gtin_no_);
   
   -- Extract gtin no without check digit from gtin_no_ removing it's last digit
   gtin_no_without_check_digit_ := SUBSTR(gtin_no_, 1, max_no_of_digits_- 1);

   remaining_length_ := 14 - LENGTH(gtin_no_without_check_digit_) - LENGTH(pkg_indicator_) ;

   -- Apending '0's next to package indicator
   filler_zero_digits_ := NULL;
   IF (remaining_length_ > 1) THEN
      FOR i_ IN 1 .. (remaining_length_ - 1) LOOP
         filler_zero_digits_ := filler_zero_digits_ || '0';
      END LOOP;
   END IF;
   -- GTIN 14 forms by Package Indicator + Filler Zeros + GTIN number except Check Digit + Reclaculated Check Digit
   gtin14_ := (pkg_indicator_ || filler_zero_digits_ || gtin_no_without_check_digit_);
   gtin14_ := gtin14_ || Calculate_Check_Digit(gtin14_);
   RETURN gtin14_;
END Get_Auto_Created_Gtin14;




