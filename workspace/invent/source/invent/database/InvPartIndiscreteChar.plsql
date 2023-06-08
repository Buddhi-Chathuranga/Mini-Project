-----------------------------------------------------------------------------
--
--  Logical unit: InvPartIndiscreteChar
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181008  Asawlk  Bug 143980, Removed overridden Prepare_Insert___().
--  160405  Rakalk  MATP-2099, CBS/CBSINT Split Moved code from Scheduling_Int_API to Cbs_So_Int_API.
--  141214  AwWelk  PRSC-1069, Added methods Prepare_Insert___(),Check_Common___(). Removed methods Check_Update___(), Create_Part_Char() and Delete_Char().
--  141214          Moved the common validations in Check_Insert___() and Check_Update___() to Check_Common___().
--  130731  MaIklk  TIBE-860, Removed inst_SchedulingSiteConfig_ global constant and used conditional compilation instead.
--  110518  Cpeilk  Bug 95963, Added unit_meas_ as IN parameter to methods Check_Char_Numeric and Check_Char_Numeric_Interval.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090714  SuThlk  Bug 83313, Did modification in Unpack_Check_Insert___ and Unpack_Check_Update___ to store the values 
--  090714          in between -1 and 1 in 0.xx format.
--  070717  MaJalk  Bug 66496, Modified the error message when ATTR_VALUE is null.
--  070702  MaJalk  Bug 62194, Introduced 2 derived attribute in base view and added code in unpack_check_insert & unpack_check_update.
--  061220  MiErlk  Added Method Create_Part_Type_Char.
--  060901  MalLlk  Bug 59636, Made value assignment to generate exception for invalid attr_value
--  060901          inside the Unpack_Check_Insert___ and Unpack_Check_Update___ procedures.
--  ------------------------------------ 13.4.0 -------------------------------
--  060124  NiDalk  Added Assert safe annotation.
--  060118  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050920  NiDalk  Removed unused variables.
--  050209  KeFelk  Removed Copy in superclass (InventoryPartChar).
--  050202  KeFelk  Renamed Copy_Discrete_Char to Copy and added new logic to it.
--  050126  KanGlk  Added Copy_Indiscrete_Char method.
--  -------------------------------------13.3.0--------------------------------
--  040127  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040128  LaBolk  Changed the view of the cursor in method Add_Template_Characteristics__ to CHARACTERISTIC_TEMPL_CHAR_PUB.
--  040113  LaBolk  Removed call to public cursor get_attributes in Add_Template_Characteristics__ and used a local cursor instead.
--  ------------------------------EDGE PKG GRP 2-------------------------------
--  010813  PHDE    Bug 23523 - Removed code to set default value of ATTR_VALUE to '.' or 0.
--  010618  SAMNLK  Bug fix 22224,Unpack_Check_Insert___,change the initial passing value for newrec_.attr_value.
--  010525  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in Delete_Char, Part_Has_Char, Check_Char_Numeric,
--                  Check_Char_Numeric_Interval, Check_Char_String, Check_Char_String_Interval, Create_Part_Char.
--  010522  SAMNLK  Bug fix 21276, Unpack_Check_Insert___,make newrec_.attr_value:= '0';
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001128  PERK    Switched order of characteristic_code, contract and part_no
--  001101  PERK    Added rowtype to where-condition in check_exist___
--  001015  PERK    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_CHAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      DECLARE
         check_contract_  BOOLEAN;
      BEGIN
         check_contract_ := Scheduling_Site_Config_API.Check_Contract(newrec_.contract);
         IF (check_contract_) THEN
            Cbs_So_Int_API.Create_Part_Char(newrec_.contract, newrec_.part_no, newrec_.characteristic_code, newrec_.attr_value);
         END IF;
      END;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENTORY_PART_CHAR_TAB%ROWTYPE,
   newrec_     IN OUT INVENTORY_PART_CHAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS  
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      DECLARE
         check_contract_  BOOLEAN;
      BEGIN
         check_contract_ := Scheduling_Site_Config_API.Check_Contract(newrec_.contract);
         IF (check_contract_) THEN
               Cbs_So_Int_API.Modify_Part_Char(newrec_.contract, newrec_.part_no, newrec_.characteristic_code, newrec_.attr_value, oldrec_.attr_value);
         END IF;
      END;
  $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN INVENTORY_PART_CHAR_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      DECLARE
         check_contract_  BOOLEAN;
      BEGIN
         check_contract_ := Scheduling_Site_Config_API.Check_Contract(remrec_.contract);
         IF (check_contract_) THEN
               Cbs_So_Int_API.Remove_Part_Char(remrec_.contract, remrec_.part_no, remrec_.characteristic_code, remrec_.attr_value);
         END IF;
      END;
   $END
END Delete___;


@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     inventory_part_char_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_char_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);
   ndummy_  NUMBER;   
   dummy_2_ VARCHAR2(60);
   dummy_3_ VARCHAR2(60);
   counter_ NUMBER := 0;
BEGIN
   dummy_2_ := Client_SYS.Get_Item_Value('ATTR_VALUE_NUMERIC', attr_);
   dummy_3_ := Client_SYS.Get_Item_Value('ATTR_VALUE_ALPHA', attr_);
   IF ((newrec_.attr_value IS NOT NULL AND newrec_.rowversion IS NULL) OR 
       (newrec_.attr_value IS NOT NULL AND indrec_.attr_value)) THEN
      counter_ := counter_ + 1;
   END IF;
   IF (dummy_2_ IS NOT NULL) THEN
      counter_ := counter_ + 1;
      newrec_.attr_value := Client_SYS.Attr_Value_To_Number(dummy_2_);
   END IF;
   IF (dummy_3_ IS NOT NULL) THEN
      counter_ := counter_ + 1;
      newrec_.attr_value := dummy_3_;
   END IF;
   IF (counter_ > 1) THEN
      Error_SYS.Record_General(lu_name_,'CHARINDATTRVALINSERT: You can give a value to only one column from attr_value, alptha_value and numeric_value at a time.');   
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.attr_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INDISATTRREQ: An alpha/numeric attribute value is required for Variable Characteristics.');
   ELSE
      Discrete_Charac_Value_API.Check_Characteristic_Value(newrec_.attr_value, Characteristic_API.Get_Search_Type_Db(newrec_.characteristic_code));
   END IF;

   /* To generate exception for invalid numbers */
   IF Characteristic_API.Get_Search_Type(newrec_.characteristic_code) = Alpha_Numeric_API.Decode('N') THEN
      name_   := 'ATTR_VALUE';
      value_  := newrec_.attr_value;
      -- Assignment will raise an exception for invalid attr_value.
      ndummy_ := TO_NUMBER(newrec_.attr_value);
      newrec_.attr_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,newrec_.attr_value);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;
   

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_char_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   IF (Inventory_Part_API.Get_Eng_Attribute(newrec_.contract, newrec_.part_no) IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'CHARTEMPLREQ: A characteristic template is required on the inventory part');
   END IF;
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Part_Has_Char (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Inventory_Part_Char_API.Part_Has_Char(contract_, part_no_);
END Part_Has_Char;


FUNCTION Check_Char_Numeric (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_Char_API.Check_Char_Numeric(contract_, part_no_, unit_meas_, characteristic_code_, search_number_);
END Check_Char_Numeric;


FUNCTION Check_Char_Numeric_Interval (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_from_  IN VARCHAR2,
   search_number_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_Char_API.Check_Char_Numeric_Interval(contract_, part_no_, unit_meas_, characteristic_code_, search_number_from_, search_number_to_);
END Check_Char_Numeric_Interval;


FUNCTION Check_Char_String (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_Char_API.Check_Char_String(contract_, part_no_, characteristic_code_, search_string_);
END Check_Char_String;


FUNCTION Check_Char_String_Interval (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_from_  IN VARCHAR2,
   search_string_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_Char_API.Check_Char_String_Interval(contract_, part_no_, characteristic_code_, search_string_from_, search_string_to_);
END Check_Char_String_Interval;


-- Copy
--   Method creates new instance and copies all attributes from old part.
PROCEDURE Copy (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_        INVENTORY_PART_CHAR_TAB%ROWTYPE;
   objid_         INV_PART_INDISCRETE_CHAR.objid%TYPE;
   objversion_    INV_PART_INDISCRETE_CHAR.objversion%TYPE;
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;

   CURSOR    get_indiscretechar_rec IS
      SELECT *
        FROM INVENTORY_PART_CHAR_TAB
       WHERE part_no  = from_part_no_
         AND contract = from_contract_
         AND rowtype like '%InvPartIndiscreteChar';
BEGIN

   FOR oldrec_ IN get_indiscretechar_rec LOOP
      IF (Check_Exist___(to_contract_, to_part_no_, oldrec_.characteristic_code)) THEN
         IF (error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'IPCHAREXIST: Characteristic :P1 does already exist for part :P2 on site :P3.', oldrec_.characteristic_code, to_part_no_, to_contract_);
         END IF;
      ELSE
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;

         Client_SYS.Add_To_Attr('CONTRACT'            , to_contract_                , attr_);
         Client_SYS.Add_To_Attr('PART_NO'             , to_part_no_                 , attr_);
         Client_SYS.Add_To_Attr('CHARACTERISTIC_CODE' , oldrec_.characteristic_code , attr_);
         Client_SYS.Add_To_Attr('UNIT_MEAS'           , oldrec_.unit_meas           , attr_);
         Client_SYS.Add_To_Attr('ATTR_VALUE'          , oldrec_.attr_value          , attr_);

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;
END Copy;


PROCEDURE Create_Part_Type_Char (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   attrvalue_           IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      INVENTORY_PART_CHAR.objid%TYPE;
   objversion_ INVENTORY_PART_CHAR.objversion%TYPE;
   newrec_     INVENTORY_PART_CHAR_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('CHARACTERISTIC_CODE', characteristic_code_, attr_);
   IF unit_meas_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('UNIT_MEAS', unit_meas_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('ATTR_VALUE', attrvalue_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___ (objid_, objversion_, newrec_, attr_);
END Create_Part_Type_Char;



