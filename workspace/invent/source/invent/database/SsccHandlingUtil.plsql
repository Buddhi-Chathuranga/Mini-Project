-----------------------------------------------------------------------------
--
--  Logical unit: SsccHandlingUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130806  MeAblk  This api is newly created by moving the previous one from the ORDER component
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Validate_Sscc_Digits
--   Check whether the total number of digits on SSCC number exeeds the
--   allowed length for SSCC and check digit is a valid one.
PROCEDURE Validate_Sscc_Digits (
   sscc_ IN VARCHAR2 )
IS
   max_no_of_digits_          NUMBER;
   length_                    NUMBER;
   sscc_without_check_digit_  NUMBER;
   check_digit_               NUMBER;
BEGIN

   length_ := LENGTH(sscc_);
   max_no_of_digits_ := 18;

   IF (length_ != max_no_of_digits_) THEN
      Error_SYS.Record_General(lu_name_,'INVALIDNUMBER: The total number of digits for SSCC should be :P1.', max_no_of_digits_);
   END IF;

   -- Extract sscc without check digit from sscc_ removing it's last digit
   sscc_without_check_digit_ := SUBSTR(sscc_, 1, length_-1);

   -- Calculate the check digit for company prefix  and serial reference value combination
   check_digit_ := Calculate_Check_Digits(sscc_without_check_digit_);

   Trace_Sys.Message('The Calculated check digit is '|| check_digit_);

   -- Validate last digit against the calculated check_digit_
   IF (SUBSTR(sscc_, length_) != check_digit_) THEN
      Error_SYS.Record_General(lu_name_, 'SSCCCHECKDIGITERR: :P1 is an invalid SSCC number.', sscc_);
   END IF;
END Validate_Sscc_Digits;


@UncheckedAccess
FUNCTION Calculate_Check_Digits (
   sscc_ IN VARCHAR2 ) RETURN NUMBER
IS
   odd_sum_         NUMBER := 0;
   even_sum_        NUMBER := 0;
   length_          NUMBER;
   i_               NUMBER;
   check_sum_       NUMBER := 0;
   multiple_of_ten_ NUMBER;
BEGIN
   length_ := LENGTH(sscc_);
   i_       := length_;
   -- Get the sum of the odd digits
   WHILE i_ > 0 LOOP
      odd_sum_ := odd_sum_ + SUBSTR(sscc_,i_, 1);
      i_ := i_ - 2;
   END LOOP;

   --get the sum of even digits
   i_ := length_ - 1;
   WHILE i_ > 0 LOOP
      even_sum_ := even_sum_ + SUBSTR(sscc_,i_, 1);
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
      IF (SUBSTR(check_sum_, length_+ 1) = 0) THEN
         --Last digit is 0; So, check_sum_ is a multiple of ten
         multiple_of_ten_ := check_sum_;
      ELSE
         --the nearest multiple of ten is the first digit of check_sum mutiplied by the nearst poewr of ten.
         multiple_of_ten_ := (SUBSTR(check_sum_, 1, length_) + 1) * 10;
      END IF;
   END IF;

   RETURN (multiple_of_ten_ - check_sum_);
END Calculate_Check_Digits;




