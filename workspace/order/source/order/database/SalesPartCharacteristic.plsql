-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartCharacteristic
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210113  MaEelk  SC2020R1-12091, Modified Copy and New_Characteristics. Replaced Unpack___, Check_Insert___ and Insert___ with New___
--  151023  LaThlk  Bug 121554, Modified the Procedure Check_Update___() to assign 'ATTR_VALUE_NUMERIC' and 'ATTR_VALUE_ALPHA' to 'ATTR_VALUE' correctly.
--  130118  NipKlk  Bug 107760, Added the Procedure  Check_Delete_Charac_Code_Value() to restrict the basic data deletion if they are used in Sales_Part_Characteristic.
--  120210  PraWlk  Bug 100868, Modified Unpack_Check_Insert___() and Unpack_Check_Update___() by adding IF conditions to do 
--  120210          the assignment for attr_value only if the value is not null or dfferent from the old value. 
--  110131  Nekolk  EANE-3744  added where clause to View SALES_PART_CHARACTERISTIC
--  100830  MoNilk  Modified flags of attr_value_numeric and attr_value_alpha in view comments SALES_PART_CHARACTERISTIC.
--  100514  KRPELK  Merge Rose Method Documentation.
--  100510  AmPalk  Bug 89662, Added new columns characteristic_value_numeric and characteristic_value_alpha.
--  091001  MaMalk  Removed unused code in Unpack_Check_Insert___.
--  ------------------------- 14.0.0 -----------------------------------------
--  090714  SuThlk  Bug 83313, Did modification in Unpack_Check_Insert___ and Unpack_Check_Update___ to store the values 
--  090714          in between -1 and 1 in 0.xx format.
--  080916  HoInlk  Bug 76612, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to display correct attr_value for format exception.
--  070417  NuVelk  Added validations for Unpack_Check_Insert___ and Unpack_Check_Update___, 
--  070417          when entering characteristics manually. 
--  060307  IsWilk  Added the FUNCTION Check_Characteristic_Code and modified 
--  060307          the PROCEDURE Unpack_Check_Insert___, and Unpack_Check_Update___
--  060307          to add the error message ENGATTR.
--  060112  IsWilk  Modified the PROCEDURE Insert__ according to template 2.3.
--  050921  NaLrlk  Removed unused variables.
--  050208  KeFelk  Added Copy public method for Copy Part functionality.
--  010813  PhDe    Bug 23523 - Removed default value of '.' for ATTR_VALUE in prepare_insert___.
--  000913  FBen    Added UNDEFINED.
--  991007  JoEd    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990201  JakH    Call id 5796: Enhance sale part characteristics.
--  981130  JoEd    Call id 4320: Rebuilt Check_Char_String and Check_Char_String_Interval.
--  971125  RaKu    Changed to FND200 Templates.
--  970908  MAJE    Changed unit of measure references to 10 character, mixed case, IsoUnit ref
--  970603  JoEd    Added method Remove_Characteristics.
--  970312  RaKu    Changed table name.
--  970218  JoEd    Changed objversion.
--  960226  SVLO    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_characteristic_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   charrec_  Characteristic_API.public_rec;
   eng_attr_ VARCHAR2(5);  
   value_    VARCHAR2(4000);
BEGIN
   value_ := Client_Sys.Get_Item_Value('ATTR_VALUE_NUMERIC', attr_);
   IF (value_ IS NOT NULL) THEN
      newrec_.attr_value := Client_SYS.Attr_Value_To_Number(value_);
      IF Characteristic_API.Get_Row_Type(newrec_.characteristic_code) = 'DiscreteCharacteristic' THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);         
      END IF;
   END IF;
   
   value_ := Client_Sys.Get_Item_Value('ATTR_VALUE_ALPHA', attr_);
   IF (value_ IS NOT NULL) THEN
      newrec_.attr_value := value_;
      IF Characteristic_API.Get_Row_Type(newrec_.characteristic_code) = 'DiscreteCharacteristic' THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);         
      END IF;
   END IF;
   
   /* To generate exception for invalid numbers */
   charrec_ := Characteristic_API.Get(newrec_.characteristic_code);
   IF charrec_.search_type = 'N' THEN
      newrec_.attr_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,newrec_.attr_value);
   END IF;
  
   super(newrec_, indrec_, attr_);
  
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   eng_attr_ := Sales_Part_API.Get_Eng_Attribute(newrec_.contract, newrec_.catalog_no);
   IF (eng_attr_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ENGATTR: The characteristics template must be entered first');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_characteristic_tab%ROWTYPE,
   newrec_ IN OUT sales_part_characteristic_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   ndummy_   NUMBER;
   charrec_  Characteristic_API.public_rec;
   eng_attr_ VARCHAR2(5);
BEGIN
   IF (indrec_.attr_value = FALSE) THEN
      newrec_.attr_value := oldrec_.attr_value;
   END IF;   
   
   IF (Client_Sys.Item_Exist('ATTR_VALUE_NUMERIC', attr_)) THEN
      newrec_.attr_value := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ATTR_VALUE_NUMERIC', attr_));
      IF Characteristic_API.Get_Row_Type(newrec_.characteristic_code) = 'DiscreteCharacteristic' THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);         
      END IF;
   END IF;
   
   IF (Client_Sys.Item_Exist('ATTR_VALUE_ALPHA', attr_)) THEN
      newrec_.attr_value := Client_SYS.Get_Item_Value('ATTR_VALUE_ALPHA', attr_);
      IF Characteristic_API.Get_Row_Type(newrec_.characteristic_code) = 'DiscreteCharacteristic' THEN
         Discrete_Charac_Value_API.Exist(newrec_.characteristic_code, newrec_.attr_value);         
      END IF;
   END IF;
   
    /* To generate exception for invalid numbers */
   charrec_ := Characteristic_API.Get(newrec_.characteristic_code);
   IF charrec_.search_type = 'N' THEN
      ndummy_ := To_Number(newrec_.attr_value);
      newrec_.attr_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,newrec_.attr_value);
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   eng_attr_ := Sales_Part_API.Get_Eng_Attribute(newrec_.contract, newrec_.catalog_no);
   IF (eng_attr_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ENGATTR: The characteristics template must be entered first');
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist_Characteristic
--   Same as Exist, but returns TRUE or FALSE whether or not instance was
@UncheckedAccess
FUNCTION Exist_Characteristic (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, catalog_no_, characteristic_code_);
END Exist_Characteristic;


-- New_Characteristics
--   Creates a new record.
PROCEDURE New_Characteristics (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   attr_value_          IN VARCHAR2 )
IS
   newrec_     SALES_PART_CHARACTERISTIC_TAB%ROWTYPE;
BEGIN
   newrec_.contract := contract_;
   newrec_.catalog_no := catalog_no_;
   newrec_.characteristic_code := characteristic_code_;
   newrec_.unit_meas := unit_meas_;
   newrec_.attr_value := attr_value_;
   New___(newrec_);
END New_Characteristics;


-- Exist_Catalog
--   Returns a error message if any row found with bypassed sales part.
PROCEDURE Exist_Catalog (
   catalog_no_ IN VARCHAR2 )
IS
   catalog_ SALES_PART_CHARACTERISTIC_TAB.catalog_no%TYPE;

   CURSOR get_catalog IS
     SELECT distinct 1
       FROM SALES_PART_CHARACTERISTIC_TAB
       WHERE catalog_no = catalog_no_;
BEGIN

   OPEN get_catalog;
   FETCH get_catalog INTO catalog_;
   IF get_catalog%FOUND THEN
      CLOSE get_catalog;
      Error_SYS.Record_General(lu_name_, 'CATALOG_EXIST: Characteristic codes should be deleted before characteristic template is removed');
   END IF;
   CLOSE get_catalog;
END Exist_Catalog;


-- Check_Char_String
--   Checks existance of a sales part with a specified attr_value.
--   Returns bypassed sales part if found, otherwise NULL.
@UncheckedAccess
FUNCTION Check_Char_String (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   found_  SALES_PART_CHARACTERISTIC_TAB.catalog_no%TYPE;

   CURSOR exist_control IS
     SELECT  catalog_no
       FROM  SALES_PART_CHARACTERISTIC_TAB
       WHERE contract = contract_
       AND   catalog_no = catalog_no_
       AND   characteristic_code = characteristic_code_
       AND   attr_value LIKE search_string_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := NULL;
   END IF;
   CLOSE exist_control;

   RETURN found_;
END Check_Char_String;


-- Check_Char_String_Interval
--   Checks existance of bypassed sales part with a attr_value within a
--   specified character interval.
--   Returns bypassed sales part if found, otherwise NULL.
@UncheckedAccess
FUNCTION Check_Char_String_Interval (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_from_  IN VARCHAR2,
   search_string_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   found_  SALES_PART_CHARACTERISTIC_TAB.catalog_no%TYPE;

   CURSOR exist_control IS
      SELECT catalog_no
      FROM   SALES_PART_CHARACTERISTIC_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   characteristic_code = characteristic_code_
      AND   attr_value BETWEEN search_string_from_ AND search_string_to_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := NULL;
   END IF;
   CLOSE exist_control;

   RETURN found_;
END Check_Char_String_Interval;


-- Check_Char_Numeric
--   Checks existance of a sales part with a specified numeric attr_value.
@UncheckedAccess
FUNCTION Check_Char_Numeric (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_     SALES_PART_CHARACTERISTIC_TAB.catalog_no%TYPE := NULL;
   attr_value_ SALES_PART_CHARACTERISTIC_TAB.attr_value%TYPE;
   charrec_    Characteristic_API.public_rec;

   CURSOR get_value IS
     SELECT attr_value
       FROM SALES_PART_CHARACTERISTIC_TAB
       WHERE contract = contract_
       AND   catalog_no = catalog_no_
       AND   characteristic_code = characteristic_code_
       AND   attr_value != '.' ; -- Default value FOR INSERT IN Forms3
BEGIN
   charrec_ := Characteristic_API.Get(characteristic_code_);
   IF charrec_.search_type != 'N' THEN
      RETURN return_;
   END IF;

   return_ := catalog_no_;

   OPEN get_value;
   FETCH get_value INTO attr_value_;

   IF get_value%NOTFOUND THEN
      return_ := NULL;
   ELSIF TO_NUMBER(attr_value_) != TO_NUMBER(search_number_) THEN
      return_ := NULL;
   END IF;

   CLOSE get_value;
   RETURN return_;
END Check_Char_Numeric;


-- Check_Char_Numeric_Interval
--   Checks existance of bypassed sales part with a attr_value within a
--   specified numeric interval.
@UncheckedAccess
FUNCTION Check_Char_Numeric_Interval (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_from_  IN VARCHAR2,
   search_number_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_     SALES_PART_CHARACTERISTIC_TAB.catalog_no%TYPE := NULL;
   attr_value_ SALES_PART_CHARACTERISTIC_TAB.attr_value%TYPE;
   charrec_    Characteristic_API.public_rec;

   CURSOR get_value IS
      SELECT attr_value
      FROM   SALES_PART_CHARACTERISTIC_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   characteristic_code = characteristic_code_
      AND    attr_value != '.';
BEGIN
   charrec_ := Characteristic_API.Get(characteristic_code_);
   IF charrec_.search_type != 'N' THEN
      RETURN return_;
   END IF;

   return_ := catalog_no_;

   OPEN get_value;
   FETCH get_value INTO attr_value_;

   IF get_value%NOTFOUND THEN
      return_ := NULL;
   ELSIF TO_NUMBER(attr_value_) NOT BETWEEN
      TO_NUMBER(search_number_from_) AND TO_NUMBER(search_number_to_) THEN
      return_ := NULL;
   END IF;

   CLOSE get_value;
   RETURN return_;
END Check_Char_Numeric_Interval;


-- Remove_Characteristics
--   Deletes all characteristics for a catalog number
PROCEDURE Remove_Characteristics (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 )
IS
   rec_   SALES_PART_CHARACTERISTIC_TAB%ROWTYPE;

   CURSOR get_attr IS
      SELECT rowid
      FROM   SALES_PART_CHARACTERISTIC_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN
   FOR rem_ IN get_attr LOOP
      Delete___(rem_.rowid, rec_);
   END LOOP;
END Remove_Characteristics;


-- Copy
--   Method creates new instance and copy characteristic template details
--   of old part.
PROCEDURE Copy (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_        SALES_PART_CHARACTERISTIC_TAB%ROWTYPE;
   oldrec_found_  BOOLEAN := FALSE;

   CURSOR    get_partchar_rec IS
      SELECT *
        FROM SALES_PART_CHARACTERISTIC_TAB
       WHERE catalog_no = from_part_no_
         AND contract = from_contract_;
BEGIN

   FOR oldrec_ IN get_partchar_rec LOOP
      oldrec_found_ := TRUE;
      IF (Check_Exist___(to_contract_, to_part_no_, oldrec_.characteristic_code)) THEN
         IF (error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'SPCHAREXIST: Characteristic :P1 does already exist for part :P2 on site :P3.', oldrec_.characteristic_code, to_part_no_, to_contract_);
         END IF;
      ELSE
         newrec_     := NULL;
         newrec_.contract :=  to_contract_;
         newrec_.catalog_no := to_part_no_;
         newrec_.characteristic_code := oldrec_.characteristic_code;
         newrec_.unit_meas := oldrec_.unit_meas;
         newrec_.attr_value := oldrec_.attr_value;

         New___(newrec_);
      END IF;
   END LOOP;

   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'SPCHARNOTEXIST: Characteristics do not exist for Part :P1 on Site :P2', from_part_no_, from_contract_);
   END IF;
END Copy;


-- Check_Characteristic_Code
--   This function check if there exist any characteristic code for the
--   given catalog no and contract. And this will return 1 if there exist
--   any characteristic code.
@UncheckedAccess
FUNCTION Check_Characteristic_Code (
   catalog_no_ IN VARCHAR2,
   contract_   IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER:=0;

   CURSOR check_char_code IS
      SELECT 1
      FROM   SALES_PART_CHARACTERISTIC_TAB
      WHERE  catalog_no = catalog_no_
      AND    contract   = contract_;
BEGIN
   OPEN check_char_code;
   FETCH check_char_code INTO temp_;
   CLOSE check_char_code;
   RETURN temp_;
END Check_Characteristic_Code;


-- Check_Delete_Charac_Code_Value
--   Checks if the given code,value combination exists in the table when
--   This is called when basic data is being deleted from Part Charactoristic
--   to restrict the deletion if those basic data is used in Sale Part Char
PROCEDURE Check_Delete_Charac_Code_Value (
   characteristic_code_  IN VARCHAR2,
   attr_value_           IN VARCHAR2 )
IS
   count_             NUMBER:=0;

   CURSOR check_code_value_count IS
      SELECT count(*) 
      FROM  SALES_PART_CHARACTERISTIC_TAB
      WHERE characteristic_code = characteristic_code_
      AND   attr_value = attr_value_;
BEGIN
   OPEN check_code_value_count;
   FETCH check_code_value_count INTO count_;
   IF (count_ > 0) THEN
      CLOSE check_code_value_count;
      Error_SYS.Record_General(lu_name_, 'CODVALEXIST: The Discrete Charac Value ":P1" is used '||
                             'by :P2 rows in another object (Sales Part Characteristic)', attr_value_, count_ );

   END IF;
   CLOSE check_code_value_count;
END Check_Delete_Charac_Code_Value;



