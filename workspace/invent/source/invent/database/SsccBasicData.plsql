-----------------------------------------------------------------------------
--
--  Logical unit: SsccBasicData
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170719  ErFelk  Bug 136752, Modified Get_Auto_Created_Sscc() by removing a condition which was placed to check remaining_length_.
--  130520  MeAblk  Restructured the method Get_Auto_Created_Sscc according to the new approach of generating SSCC.
--  130517  Maeelk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Digit_Lengths___
--   Check whether the total number of digits on (company prefix + (start/ end/ next) value)
--   exeeds the allowed length for (company prefix + serial ref) in SSCC.
PROCEDURE Validate_Digit_Lengths___ (
   newrec_ IN OUT SSCC_BASIC_DATA_TAB%ROWTYPE )
IS
   length_remain_      NUMBER;
   max_no_of_digits_   NUMBER := 16;
BEGIN
   IF (newrec_.start_value > newrec_.next_value) THEN
      Error_SYS.Record_General(lu_name_, 'STARTVALERROR1: The start value cannot be greater then the next value.');
   END IF;
   IF (newrec_.start_value > newrec_.end_value) THEN
      Error_SYS.Record_General(lu_name_, 'STARTVALERROR2: The start value cannot be greater then the end value.');
   END IF;
   IF (newrec_.end_value < newrec_.next_value) THEN
      Error_SYS.Record_General(lu_name_, 'NEXTVALERROR: The next value cannot be greater then the end value.');
   END IF;

   length_remain_:= max_no_of_digits_- length(newrec_.company_prefix);

   IF (length(newrec_.start_value) > length_remain_) THEN
      Error_SYS.Record_General(lu_name_, 'STARTTOOLONGERR: The total number of digits of the company prefix plus the start value should be less than or equal to :P1.', max_no_of_digits_);
   ELSIF (length(newrec_.next_value) > length_remain_) THEN
      Error_SYS.Record_General(lu_name_, 'NEXTTOOLONGERR: The total number of digits of the company prefix plus the next value should be less than or equal to :P1.', max_no_of_digits_);
   ELSIF (length(newrec_.end_value) > length_remain_) THEN
      Error_SYS.Record_General(lu_name_, 'ENDTOOLONGERR: The total number of digits of the company prefix plus the end value should be less than or equal to :P1.', max_no_of_digits_);
   END IF;
END Validate_Digit_Lengths___;


-- Is_Number___
--   Method checkes whether the passes string is a numeric value.
--   Returns TRUE if it is a numeric value, FALSE otherwise.
FUNCTION Is_Number___ (
   string_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   c_    NUMBER;
BEGIN
   FOR i_ IN 1..LENGTH( string_ ) LOOP
      c_ := ASCII( SUBSTR( string_, i_, 1 ) );
      IF ( c_ < ASCII( '0' ) OR c_ > ASCII( '9' ) ) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Number___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sscc_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF NOT Is_Number___(newrec_.company_prefix) THEN
      Error_SYS.Record_General(lu_name_, 'COMPPREFIXNOTNUM: The company prefix must be a numeric value.');
   END IF;            
   
   Validate_Digit_Lengths___(newrec_);   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sscc_basic_data_tab%ROWTYPE,
   newrec_ IN OUT sscc_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Validate_Digit_Lengths___(newrec_);     
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Auto_Created_Sscc
--   Return the next SSCC Number relevant to a given company prefix
--   and update the next value.
PROCEDURE Get_Auto_Created_Sscc (
   sscc_                  OUT VARCHAR2,
   company_               IN  VARCHAR2,
   handling_unit_type_id_ IN  VARCHAR2 ) 
IS
   sscc_company_prefix_       SSCC_BASIC_DATA_TAB.company_prefix%TYPE;
   objid_                     SSCC_BASIC_DATA.objid%TYPE;
   objversion_                SSCC_BASIC_DATA.objversion%TYPE;
   oldrec_                    SSCC_BASIC_DATA_TAB%ROWTYPE;
   newrec_                    SSCC_BASIC_DATA_TAB%ROWTYPE;
   attr_                      VARCHAR2(2000);
   zero_digits_               VARCHAR2(18);
   extension_digit_           NUMBER;
   max_no_of_digits_          NUMBER;
   check_digit_               NUMBER;
   remaining_length_          NUMBER;
   sscc_exist_                BOOLEAN := TRUE;

BEGIN

   sscc_company_prefix_ := Company_Distribution_Info_API.Get_Sscc_Company_Prefix(company_);

   IF (sscc_company_prefix_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SSCCCOMPPREFIXNULL: The SSCC company prefix must be entered in the company :P1''s general data for distribution.', company_);
   END IF;
   
   extension_digit_ := Sscc_Handling_Unit_Type_API.Get_Extension_Digit(sscc_company_prefix_, handling_unit_type_id_);
   IF (extension_digit_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'EXTHANDLUNITDIGNOTDEFINE: The extension digit for handling unit type :P1 has not been defined in the SSCC company prefix :P2.', handling_unit_type_id_, sscc_company_prefix_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(sscc_company_prefix_);
   newrec_ := oldrec_;

   -- Note:- max_no_of_digits means => (company prefix + serial ref)
   max_no_of_digits_ := 16;

   WHILE (sscc_exist_) LOOP
      remaining_length_ := max_no_of_digits_ - length(sscc_company_prefix_) - length(newrec_.next_value);

      IF (newrec_.next_value > newrec_.end_value) THEN
         Error_SYS.Record_General(lu_name_, 'SSCCVALFINISH: All the SSCC numbers for the SSCC company prefix :P1 have been used.', sscc_company_prefix_);
      END IF;

      -- Apending '0's before next value
      zero_digits_ := NULL;
      FOR i_ IN 1..remaining_length_ LOOP
         zero_digits_ := zero_digits_ || '0';
      END LOOP;

      --  The auto create SSCC value without check digit
      sscc_ := extension_digit_ || sscc_company_prefix_ || zero_digits_ || newrec_.next_value;
      
      -- Calculate check digit
      check_digit_ := Sscc_Handling_Util_API.Calculate_Check_Digits(sscc_);
        
      -- The Auto create SSCC value
      sscc_ := sscc_ || check_digit_;

      --Increase the next value by one and update the record
      newrec_.next_value := newrec_.next_value + 1;
      
      IF (Handling_Unit_API.Sscc_Exist(sscc_) = 'FALSE') THEN
         sscc_exist_ := FALSE;
      END IF;
   END LOOP;

   Validate_Digit_Lengths___(newrec_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Get_Auto_Created_Sscc;



