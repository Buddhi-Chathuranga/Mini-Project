-----------------------------------------------------------------------------
--
--  Logical unit: IsoUnit
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220211  DEEKLK  AMZDOC-1372, Modified Set_Unit_Type().
--  180110  MAJOSE  STRMF-16889, Introduced micro-cache-array concept. Turned some private attributes into public
--  180110          Rewrote Convert_Unit_Quantity and Get_Unit_Converted_Quantity to make use of the public get method.
--  131209  jagrno  Corrected error in Check_Common___.
--  131128  jagrno  Hooks: Refactored and split code. Added USED_IN_APPL as attribute since 
--                  this is also in the table and used in the business logic. Reverted template
--                  method Check_Exist___ back to generated code. Added Check_Used_In_Appl___
--                  to check for existence of given unit code that is "Used in Application".
--                  Instead of overtaking Check_Exist___ we need to overtake Exist to be in line
--                  with the other "ISO entities". Replaced current usage of Check_Exist___
--                  with Check_Used_In_Appl___.
--  ---------------------------- APPS 9 -------------------------------------
--  100422  Ajpelk   Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  100419  JeLise   Added check on newrec_.uom_constant in Insert___.
--  100414  JeLise   Added uom_constant.
--  ---------------------- Best Price --------------------------------
--  061026  UtGulk   Added Get_Unit_Converted_Quantity. Closed open cursors in Convert_Unit_Quantity. (Bug 61288).
--  050217  BaMalk   Bug 47030 Get_Present_Factor__ : increased the decimal rounding off up to 8
--  050616  BaMalk   Bug#49808 Check_Exist___ : Added "used in application" to the condition for exist.
--  040611  DaRulk   Added new method Get_Definition_Type.
--  040524  DHSELK   Merged Patched Bug 44623 from LCS
--                   040517  HIPELK   Bug 44623 Modified the Insert_Lu_Data_Rec__ to make "USER_DEFINED" is "FALSE"
--                   040517           for a new installation.
--  040301  ThAblk   Removed substr from views.
--  040224  gacolk   UNICODE: Removed substrb and changed to substr where needed
--  030213  pranlk   Call 94180 Error saving modified description fixed
--  030213           modified  update___
--  030213  pranlk   Call 94183 IsoUnit.ins Error, Insert_Lu_Data_Rec__ modified
--  030213           Iso_Unit_Type_API.Encode not necessary for unit_type
--  030206  pranlk   Call 93790 Get_Description,Set_Description__ modified to get the language code
--  030206           if the description is passed in.
--  030116  pranlk   Insert_Lu_Data_Rec__ method was added to insert data
--  030116           into the LU table according to the new Basic Data Translation
--  030116           guidelines. This method is used in IsoUnit.ins
--  030116           almost all methods were changed to follow the same guidelines.
--  990419  JoEd     Call id 10263: Changed default value for unit type to DB value
--  990419           instead of client value in Set_Unit and Set_Unit__.
--  990304  AnTa     Added new public function Convert_Unit_Quantity.
--  990208  PaLj     Added view VIEW_WEIGHT
--  981214  JoEd     Added unit type.
--  981021  JoEd     Changed the method Get_Present_Factor__ to present the text '*10^'.
--  980327  JaPa     USED_IN_APPL and USER_DEFINED attributes changed to not null.
--  971219  JaPa     Added new public function Check_Exist()
--  970910  JaPa     Added check against AttributeDefinition LU for unit_code
--  970708  JaPa     Fixed bug 97-0001: Not possible to create user defined units
--  970612  JaPa     Only one factor parameter in Set_Unit(). Presentation
--  970612           factor works as multiplication factor while insert.
--  970606  JaPa     New check if the unit to be inserted allready exists but
--  970606           is not activated.
--  970605  JaPa     Added two new public procedures Set_Unit() and
--  970605           Set_Description() for better handling of upgrade old
--  970605           module specific units.
--  970407  JaPa     Created
--  010612  Larelk   Bug 22173, Add General_SYS.Init_Method in  Set_Unit,Set_Description.
--  061030  RaRulk   Modified the Unpack_Check_Insert___ and Unpack_Check_Update__ Bug ID 61417
--  070112  NiWiLK   Modified Insert, update and remove methods to use TABLE%RowTYPE (Bug#62569)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   unit_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Unit code :P1 does not exist or is not enabled for use in the application.', unit_code_);
   super(unit_code_);
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ iso_unit_tab%ROWTYPE )
IS
BEGIN
   IF Check_Not_Activated___(rec_.unit_code) THEN
      Error_SYS.Record_General(lu_name_, 'UNITNACTIV: Unit code [:P1] exists but is not activated.', rec_.unit_code);
   ELSE
      super(rec_);
   END IF;
END Raise_Record_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   base_unit_     ISO_UNIT.base_unit%TYPE;
   unit_type_     ISO_UNIT.unit_type%TYPE;
BEGIN
   base_unit_ := Client_SYS.Get_Item_Value('BASE_UNIT', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('PRESENT_FACTOR', '1', attr_);
   IF (base_unit_ IS NOT NULL) THEN
      unit_type_ := Get_Unit_Type(base_unit_);
   ELSE
      unit_type_ := Iso_Unit_Type_API.Decode('NOTUSED');
   END IF;
   Client_SYS.Add_To_Attr('UNIT_TYPE', unit_type_, attr_);
   Client_SYS.Add_To_Attr('UOM_CONSTANT', '0', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ISO_UNIT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.used_in_appl := nvl(newrec_.used_in_appl, 'TRUE');
   Client_SYS.Add_To_Attr('USED_IN_APPL', newrec_.used_in_appl, attr_);
   newrec_.user_defined := nvl(newrec_.user_defined, 'TRUE');
   Client_SYS.Add_To_Attr('USER_DEFINED', newrec_.user_defined, attr_);
   -- server defaults related to base units
   IF (nvl(newrec_.base_unit, newrec_.unit_code) = newrec_.unit_code) THEN
      IF (newrec_.base_unit IS NULL) THEN
         newrec_.base_unit := newrec_.unit_code;
         Client_SYS.Add_To_Attr('BASE_UNIT', newrec_.base_unit, attr_);
      END IF;
      IF (newrec_.multi_factor <> 1) THEN
         newrec_.multi_factor := 1;
         Client_SYS.Add_To_Attr('MULTI_FACTOR', newrec_.multi_factor, attr_);
      END IF;
      IF (newrec_.div_factor <> 1) THEN
         newrec_.div_factor := 1;
         Client_SYS.Add_To_Attr('DIV_FACTOR', newrec_.div_factor, attr_);
      END IF;
      IF (newrec_.ten_power <> 0) THEN
         newrec_.ten_power := 0;
         Client_SYS.Add_To_Attr('TEN_POWER', newrec_.ten_power, attr_);
      END IF;
      IF (newrec_.uom_constant <> 0) THEN
         newrec_.uom_constant := 0;
         Client_SYS.Add_To_Attr('UOM_CONSTANT', newrec_.uom_constant, attr_);
      END IF;
   END IF;
   --
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('PRESENT_FACTOR', SUBSTR(Get_Present_Factor__(newrec_.unit_code), 1, 20), attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ISO_UNIT_TAB%ROWTYPE,
   newrec_     IN OUT ISO_UNIT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   curr_user_lang_   VARCHAR2(10);
BEGIN
   -- server defaults
   IF ((newrec_.used_in_appl = 'TRUE') OR (newrec_.user_defined = 'TRUE')) THEN
      newrec_.used_in_appl := 'TRUE';
   ELSE
      newrec_.used_in_appl := 'FALSE';
   END IF;
   Client_SYS.Add_To_Attr('USED_IN_APPL', newrec_.used_in_appl, attr_);
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   curr_user_lang_ := Fnd_Session_API.Get_Language;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoUnit',
      newrec_.unit_code,
      curr_user_lang_, newrec_.description, oldrec_.description);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ISO_UNIT_TAB%ROWTYPE )
IS
BEGIN
   IF (nvl(remrec_.user_defined, 'FALSE') <> 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ISODELERR: Cannot remove ISO-unit.');
   ELSIF (remrec_.unit_code = remrec_.base_unit) THEN
      -- dirty solution due to bug in FND
      @ApproveTransactionStatement(2014-08-25,nifrse)
      SAVEPOINT check_delete_base_iso_code;
      UPDATE   ISO_UNIT_TAB
         SET   base_unit = '*'
         WHERE unit_code = remrec_.unit_code;
   END IF;
   --
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT NOCOPY iso_unit_tab%ROWTYPE,
   indrec_   IN OUT NOCOPY Indicator_Rec,
   attr_     IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (newrec_.multi_factor IS NULL) THEN
      newrec_.multi_factor := 1;
   END IF;
   IF (newrec_.div_factor IS NULL) THEN
      newrec_.div_factor := 1;
   END IF;
   IF (newrec_.ten_power IS NULL) THEN
      newrec_.ten_power := 0;
   END IF;
   super(newrec_, indrec_, attr_);
END Unpack___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     iso_unit_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY iso_unit_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   lang_           VARCHAR2(10);
   unit_type_      ISO_UNIT_DEF.unit_type%TYPE;
   present_factor_ ISO_UNIT_TAB.multi_factor%TYPE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Peform validations for NEW records
   IF (newrec_.rowversion IS NULL) THEN
      -- Check attribute definitions for UNIT_CODE
      Attribute_Definition_API.Check_Value(newrec_.unit_code, lu_name_, 'UNIT_CODE');
      -- Get unit type from base unit
      IF (newrec_.base_unit IS NOT NULL) THEN
         -- Validate BASE_UNIT
         Iso_Unit_API.Check_Base(newrec_.base_unit);
         --
         unit_type_ := Iso_Unit_Type_API.Encode(Get_Unit_Type(newrec_.base_unit));
         IF (nvl(unit_type_, newrec_.unit_type) <> newrec_.unit_type) THEN
            newrec_.unit_type := unit_type_;
            Client_SYS.Add_To_Attr('UNIT_TYPE', unit_type_, attr_);
            Client_SYS.Add_Info(lu_name_, 'DERIVED_UNIT_TYPE: Unit type has been set to :P1. Derived from the base unit.', unit_type_);
         END IF;
      END IF;
   -- Peform validations for MODIFIED records
   ELSIF (newrec_.rowversion IS NOT NULL) THEN
      -- Validate USED_IN_APPL
      IF (indrec_.used_in_appl) THEN
         IF (nvl(newrec_.user_defined, 'FALSE') = 'TRUE') THEN
            Error_SYS.Item_Update(lu_name_, 'USED_IN_APPL', 'ERRUPDUSED: The field [:P1] is not valid for update for user defined codes.', 'USED_IN_APPL');
         END IF;
      END IF;
   END IF;
   -- Validate DESCRIPTION
   IF (indrec_.description) THEN
      lang_ := Language_SYS.Get_Language;
      IF (lang_ = 'PROG') THEN
         lang_ := 'en';
      ELSE
         Iso_Language_API.Exist(lang_);
      END IF;
   END IF;
   -- Handle derived attribute PRESENT_FACTOR
   present_factor_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PRESENT_FACTOR', attr_));
   IF (present_factor_ IS NOT NULL) THEN
      IF (newrec_.rowversion IS NULL) THEN
         -- For NEW records, assign value to MULTI_FACTOR
         newrec_.multi_factor := present_factor_;
      ELSE
         -- For MODIFIED records, raise error
         Error_SYS.Item_Update(lu_name_, 'PRESENT_FACTOR');
      END IF;
   END IF;
END Check_Common___;


-- Check_Not_Activated___
--   Checks if the unit code is used in the application.
FUNCTION Check_Not_Activated___ (
   unit_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM ISO_UNIT_DEF
      WHERE unit_code = unit_code_
      AND NVL(used_in_appl, 'FALSE') = 'FALSE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   ELSE
      CLOSE exist_control;
      RETURN FALSE;
   END IF;
END Check_Not_Activated___;


-- Check_Used_In_Appl___
--   Checks if the given unit code exists and marked as "Used in Application".
--   Basically same as Check_Exist___ with modified WHERE-condition.
FUNCTION Check_Used_In_Appl___ (
   unit_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   found_ BOOLEAN := FALSE;
   CURSOR exist_control IS
      SELECT 1
      FROM   ISO_UNIT_TAB
      WHERE  unit_code = unit_code_
      AND    used_in_appl = 'TRUE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   found_ := exist_control%FOUND;
   CLOSE exist_control;
   --
   RETURN(found_);
END Check_Used_In_Appl___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Application_Use__
--   A private routine that controls marked codes on module update.
@UncheckedAccess
FUNCTION Check_Application_Use__ (
   used_in_appl_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (UPPER(used_in_appl_) LIKE 'T%') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Application_Use__;


-- Set_Unit__
--   A private procedure that creates or modifies ISO-units.
--   Input parameters:
--   Description - unit description in language DbLangCode
--   MultiFactor - multiplication factor
--   DivFactor - divisions factor
--   TenPower - power of ten for convert factor
--   BaseUnit - code for base unit for the actual unit
--   DbLangCode - language code for the description. Server language if NULL
PROCEDURE Set_Unit__ (
   unit_code_    IN VARCHAR2,
   description_  IN VARCHAR2,
   multi_factor_ IN NUMBER DEFAULT 1,
   div_factor_   IN NUMBER DEFAULT 1,
   ten_power_    IN NUMBER DEFAULT 0,
   base_unit_    IN VARCHAR2 DEFAULT NULL,
   db_lang_code_ IN VARCHAR2 DEFAULT NULL,
   uom_constant_ IN NUMBER DEFAULT 0 )
IS
BEGIN
   INSERT
      INTO ISO_UNIT_TAB (
         unit_code,
         description,
         base_unit,
         multi_factor,
         div_factor,
         ten_power,
         user_defined,
         unit_type,
         used_in_appl,
         uom_constant,
         rowversion)
      VALUES (
         unit_code_,
         description_,
         NVL(base_unit_, unit_code_),
         multi_factor_,
         div_factor_,
         ten_power_,
         'FALSE',
         'NOTUSED',
         'FALSE',
         uom_constant_,
         1);
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE ISO_UNIT_TAB
         SET description  = description_,
             base_unit = NVL(base_unit_, unit_code_),
             multi_factor = multi_factor_,
             div_factor = div_factor_,
             ten_power = ten_power_,
             user_defined = 'FALSE',
             used_in_appl = Check_Application_Use__(used_in_appl),
             rowversion = rowversion+1
         WHERE unit_code = unit_code_;
END Set_Unit__;


-- Set_Description__
--   Creates a unit description in additional language or modifies the existing one.
--   If DbLangCode is NULL the actual language from server is taken (Language_SYS.Get_Language).
PROCEDURE Set_Description__ (
   unit_code_    IN VARCHAR2,
   description_  IN VARCHAR2,
   db_lang_code_ IN VARCHAR2 DEFAULT NULL )
IS
   lang_ VARCHAR2(2);
BEGIN
   IF NVL(LENGTH(db_lang_code_),0) = 2 THEN
      lang_ := db_lang_code_;
   ELSE
      lang_ := Iso_Language_API.Encode(db_lang_code_);
   END IF;

   UPDATE ISO_UNIT_TAB
      SET description  = SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV',
                                                                          'IsoUnit',
                                                                          unit_code_,
                                                                          lang_ ),1,50),
          used_in_appl = Check_Application_Use__(used_in_appl),
          rowversion = rowversion+1
      WHERE unit_code = unit_code_;
END Set_Description__;


-- Get_Present_Factor__
--   A private method (used in the view) that shows convert factor in the 'user friendly' manner.
@UncheckedAccess
FUNCTION Get_Present_Factor__ (
   unit_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   factor_ NUMBER;
   multi_  NUMBER;
   power_  NUMBER;

   FUNCTION Trim_Dec___(
      num_ IN NUMBER ) RETURN VARCHAR2
   IS
      nls_mask_ VARCHAR2(81) := LPAD(RPAD('D', 31, '9'), 62, '9');
      nls_fmt_  VARCHAR2(30) := 'NLS_NUMERIC_CHARACTERS=''.,''';
   BEGIN
      RETURN RTRIM(RTRIM(TO_CHAR(num_, nls_mask_, nls_fmt_), '0'), '.');
   END Trim_Dec___;

   FUNCTION Fix_Num___ (
      num_ IN NUMBER,
      dec_ IN NUMBER,
      pow_ IN NUMBER ) RETURN VARCHAR2
   IS
      notation_  VARCHAR2(15);
      max_power_ NUMBER;
   BEGIN
      notation_ := NVL(Object_Property_API.Get_Value('IsoUnit', '*', 'NOTATION'), 'DEFAULT');
      max_power_ := TO_NUMBER(NVL(Object_Property_API.Get_Value('IsoUnit', '*', 'MAX_POWER'), '2'));
      IF (notation_ = 'SCIENTIFIC') THEN
         notation_ := ' E ';
      ELSE
         notation_ := '*10^';
      END IF;
      IF (pow_ BETWEEN 0 AND max_power_) THEN
         RETURN LPAD(Trim_Dec___(ROUND(num_ * POWER(10, pow_), dec_)), dec_ + 2) || '       ';
      ELSIF (pow_ BETWEEN -1 * (max_power_ - 1) AND -1) THEN
         RETURN LPAD('0' || Trim_Dec___(ROUND(num_ * POWER(10, pow_), dec_)), dec_ + 2) || '       ';
      ELSE
         RETURN LPAD(Trim_Dec___(ROUND(num_, dec_)), dec_ + 2) || notation_ || RPAD(TO_CHAR(power_), 3);
      END IF;
   END Fix_Num___;
BEGIN
   SELECT div_factor, multi_factor, ten_power
   INTO factor_, multi_, power_
   FROM ISO_UNIT_DEF
   WHERE unit_code = unit_code_;

   IF (factor_ = 0) THEN
      RETURN NULL;
   ELSE
      factor_ := multi_ / factor_;
      LOOP
         IF (factor_ >= 10) THEN
            factor_ := factor_ / 10;
            power_ := power_ + 1;
         ELSIF (factor_ < 1) THEN
            factor_ := factor_ * 10;
            power_ := power_ - 1;
         ELSE
            RETURN Fix_Num___(factor_, 8, power_);
         END IF;
      END LOOP;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Present_Factor__;


-- Insert_Lu_Data_Rec__
--   Inserts data into it's LU and to the Language_Sys_Tab.
--   Basically used in IsoUnit.ins.
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_  IN ISO_UNIT_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM ISO_UNIT_TAB
      WHERE unit_code = newrec_.unit_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      CLOSE Exist;
      INSERT
         INTO ISO_UNIT_TAB (
            unit_code,
            description,
            base_unit,
            multi_factor,
            div_factor,
            ten_power,
            user_defined,
            unit_type,
            used_in_appl,
            uom_constant,
            rowversion)
         VALUES (
            newrec_.unit_code,
            newrec_.description,
            newrec_.base_unit,
            newrec_.multi_factor,
            newrec_.div_factor,
            newrec_.ten_power,
            'FALSE',
            newrec_.unit_type,
            'TRUE',
            newrec_.uom_constant,
            1);
      Basic_Data_Translation_API.Insert_Prog_Translation( 'APPSRV',
                                                         'IsoUnit',newrec_.unit_code,
                                                         newrec_.description);
   ELSE
      CLOSE Exist;
      Basic_Data_Translation_API.Insert_Prog_Translation( 'APPSRV',
                                                         'IsoUnit',newrec_.unit_code,
                                                         newrec_.description);
      UPDATE ISO_UNIT_TAB
         SET description = newrec_.description
         WHERE unit_code = newrec_.unit_code;
   END IF;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Overtaken because we need to check against a subset of ISO units
-- Only units used by the application should be considered.
@Overtake Base
@UncheckedAccess
PROCEDURE Exist (
   unit_code_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Used_In_Appl___(unit_code_)) THEN
      Raise_Record_Not_Exist___(unit_code_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Description (
   unit_code_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   desc_ ISO_UNIT_TAB.description%TYPE;
   lang_ VARCHAR2(2);
   CURSOR get_attr IS
      SELECT description
      FROM ISO_UNIT_TAB
      WHERE unit_code = unit_code_
      AND used_in_appl = 'TRUE';
BEGIN
   IF NVL(LENGTH(language_code_),0) = 2 THEN
      lang_ := language_code_;
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;

   desc_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV', 'IsoUnit', unit_code_,lang_ ),1,50);
   IF desc_ IS NOT NULL THEN
      RETURN desc_;
   ELSE
      OPEN get_attr;
      FETCH get_attr INTO desc_;
      IF (get_attr%NOTFOUND) THEN
         CLOSE get_attr;
         RETURN NULL;
      ELSE
         CLOSE get_attr;
         RETURN desc_;
      END IF;
   END IF;
END Get_Description;


-- Activate_Code
--   Activate the code to use it in the current installation of IFS APPLICATIONS.
--   The only input parameter is just the code.
PROCEDURE Activate_Code (
   unit_code_ IN VARCHAR2 )
IS
BEGIN
   UPDATE ISO_UNIT_TAB
      SET used_in_appl = 'TRUE',
          rowversion = rowversion+1
      WHERE unit_code = unit_code_
      AND NVL(used_in_appl, 'FALSE') <> 'TRUE';
END Activate_Code;


-- Get_Factor
--   Returns convert factor for the unit in relation to the base unit.
--   The factor is calculated as:
--   ( MultiFactor / DivFactor ) * power(10, TenPower)
@UncheckedAccess
FUNCTION Get_Factor (
   unit_code_ IN VARCHAR2 ) RETURN NUMBER
IS
   rec_  Public_Rec;
BEGIN
   rec_ := Get(unit_code_);
   IF (rec_.div_factor = 0) THEN
      RETURN NULL;
   ELSE
      RETURN POWER(10, rec_.ten_power) * rec_.multi_factor / rec_.div_factor;
   END IF;
END Get_Factor;


-- Convert_Unit_Quantity
--   Returns a quantity converted from one unit of measure to another where
--   both have the same base unit.
--   The factor is calculated as:
--   ( MultiFactor / DivFactor ) * power(10, TenPower)
FUNCTION Convert_Unit_Quantity (
   from_quantity_  IN NUMBER,
   from_unit_code_ IN VARCHAR2,
   to_unit_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   from_factor_      NUMBER;
   to_factor_        NUMBER;
   to_quantity_      NUMBER;
   from_rec_         Public_Rec;
   to_rec_           Public_Rec;
   base_quantity_    NUMBER;
   unit_not_found    EXCEPTION;
   div_factor_zero   EXCEPTION;
   to_factor_zero    EXCEPTION;
   base_units_differ EXCEPTION;

BEGIN
   -- Get information about from_unit_code_
   from_rec_ := Get(from_unit_code_);
   IF (from_rec_.div_factor IS NULL) THEN
      RAISE unit_not_found;
   ELSIF (from_rec_.div_factor = 0) THEN
      RAISE div_factor_zero;
   END IF;
   -- The following calculation should exactly match the one in Get_Factor.
   -- It is here for performance reasons
   from_factor_ := POWER(10, from_rec_.ten_power) * from_rec_.multi_factor / from_rec_.div_factor;

   -- Get information about to_unit_code_
   to_rec_ := Get(to_unit_code_);
   IF (to_rec_.div_factor IS NULL) THEN
      RAISE unit_not_found;
   ELSIF (to_rec_.div_factor = 0) THEN
      RAISE div_factor_zero;
   END IF;
   -- The following calculation should exactly match the one in Get_Factor.
   -- It is here for performance reasons
   to_factor_ := POWER(10, to_rec_.ten_power) * to_rec_.multi_factor / to_rec_.div_factor;
   IF (to_factor_ = 0) THEN
      RAISE to_factor_zero;
   END IF;

   -- Check to see if both units of measure have same base unit. IF so convert, else return an error message
   IF (to_rec_.base_unit = from_rec_.base_unit) THEN
      IF from_rec_.uom_constant != 0 OR to_rec_.uom_constant != 0 THEN
         base_quantity_ := 1/from_factor_ * (from_quantity_ - from_rec_.uom_constant);
         to_quantity_   := to_factor_ * base_quantity_ + to_rec_.uom_constant;
      ELSE
         to_quantity_ := from_quantity_ * from_factor_ / to_factor_;
      END IF;
   ELSE
      RAISE base_units_differ;
   END IF;

   RETURN to_quantity_;
EXCEPTION
   WHEN unit_not_found THEN
      Error_SYS.Record_General(lu_name_, 'UNIT_NOT_FOUND: Unit code does not exist.');
   WHEN div_factor_zero THEN
      Error_SYS.Record_General(lu_name_, 'DIV_FACTOR_0: The division factor on one of the unit codes is zero.');
   WHEN to_factor_zero THEN
      Error_SYS.Record_General(lu_name_, 'TO_FACTOR_0: The factor on the convert to unit code :P1 is zero.', to_unit_code_);
   WHEN base_units_differ THEN
      Error_SYS.Record_General(lu_name_, 'BASE_DIFFER: The base units of :P1 and :P2 differ. Conversion cannot be done.', from_unit_code_, to_unit_code_ );
END Convert_Unit_Quantity;


-- Get_Unit_Converted_Quantity
--   Returns a quantity converted from one unit of measure to another where
--   both have the same base unit.
--   The factor is calculated as:
--   ( MultiFactor / DivFactor ) * power(10, TenPower)
@UncheckedAccess
FUNCTION Get_Unit_Converted_Quantity (
   from_quantity_  IN NUMBER,
   from_unit_code_ IN VARCHAR2,
   to_unit_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   from_factor_      NUMBER;
   to_factor_        NUMBER;
   to_quantity_      NUMBER;
   base_quantity_    NUMBER;
   from_rec_         Public_Rec;
   to_rec_           Public_Rec;
   
BEGIN
   -- Get information about from_unit_code_
   from_rec_ := Get(from_unit_code_);
   IF (from_rec_.div_factor IS NULL) THEN
      RETURN NULL;
   ELSIF (from_rec_.div_factor = 0) THEN
      RETURN NULL;
   END IF;
   -- The following calculation should exactly match the one in Get_Factor.
   -- It is here for performance reasons
   from_factor_ := POWER(10, from_rec_.ten_power) * from_rec_.multi_factor / from_rec_.div_factor;

   -- Get information about to_unit_code_
   to_rec_ := Get(to_unit_code_);
   IF (to_rec_.div_factor IS NULL) THEN
      RETURN NULL;
   ELSIF (to_rec_.div_factor = 0) THEN
      RETURN NULL;
   END IF;
   
   -- The following calculation should exactly match the one in Get_Factor.
   -- It is here for performance reasons
   to_factor_ := POWER(10, to_rec_.ten_power) * to_rec_.multi_factor / to_rec_.div_factor;
   IF (to_factor_ = 0) THEN
      RETURN NULL;
   END IF;
   
   -- Check to see if both units of measure have same base unit. IF so convert, else return null
   IF (to_rec_.base_unit = from_rec_.base_unit) THEN
      IF from_rec_.uom_constant != 0 OR to_rec_.uom_constant != 0 THEN
         base_quantity_ := 1/from_factor_ * (from_quantity_ - from_rec_.uom_constant);
         to_quantity_   := to_factor_ * base_quantity_ + to_rec_.uom_constant;
      ELSE
         to_quantity_ := from_quantity_ * from_factor_ / to_factor_;
      END IF;
   ELSE
      RETURN NULL;
   END IF;
   RETURN to_quantity_;
END Get_Unit_Converted_Quantity;


-- Set_Unit
--   A public method to create user or module specific units.
--   Such units will be marked as 'user defined'.
--   Input parameters:
--   Description - unit description in language DbLangCode
--   Factor - convert factor
--   BaseUnit - code for base unit for the actual unit
--   DbLangCode - language code for the description. Server language if NULL.
PROCEDURE Set_Unit (
   unit_code_    IN VARCHAR2,
   description_  IN VARCHAR2,
   factor_       IN NUMBER DEFAULT 1,
   base_unit_    IN VARCHAR2 DEFAULT NULL,
   db_lang_code_ IN VARCHAR2 DEFAULT NULL,
   uom_constant_ IN NUMBER DEFAULT 0 )
IS
BEGIN
   INSERT
      INTO ISO_UNIT_TAB (
         unit_code,
         description,
         base_unit,
         multi_factor,
         div_factor,
         ten_power,
         user_defined,
         unit_type,
         used_in_appl,
         uom_constant,
         rowversion)
      VALUES (
         unit_code_,
         description_,
         NVL(base_unit_, unit_code_),
         DECODE(NVL(base_unit_,unit_code_), unit_code_, 1, factor_),
         1,
         0,
         'TRUE',
         'NOTUSED',
         'TRUE',
         uom_constant_,
         1);
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE ISO_UNIT_TAB
         SET description  = description_,
             base_unit = NVL(base_unit_, unit_code_),
             multi_factor = DECODE(NVL(base_unit_, unit_code_), unit_code_, 1, factor_),
             div_factor = 1,
             ten_power = 0,
             used_in_appl = 'TRUE',
             rowversion = rowversion+1
         WHERE unit_code    = unit_code_
         AND   user_defined = 'TRUE';
END Set_Unit;


-- Set_Description
--   Creates a unit description in additional language or modifies the existing one.
--   If DbLangCode is NULL the actual language from server is taken
PROCEDURE Set_Description (
   unit_code_    IN VARCHAR2,
   description_  IN VARCHAR2,
   db_lang_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Description__(unit_code_, description_, db_lang_code_);
END Set_Description;


@UncheckedAccess
FUNCTION Check_Exist (
   unit_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Used_In_Appl___(unit_code_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Set_Unit_Type
--   Sets the base unit's unit type and updates all units using the same
--   base unit. If it's not the base unit an error is displayed.
PROCEDURE Set_Unit_Type (
   base_unit_ IN VARCHAR2,
   unit_type_ IN VARCHAR2 )
IS
   dummy_  NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM ISO_UNIT_TAB
      WHERE unit_code = base_unit_
      AND base_unit = base_unit_;

   CURSOR get_record IS
      SELECT *
      FROM ISO_UNIT_TAB
      WHERE base_unit = base_unit_;

   newrec_     ISO_UNIT_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(2000);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'NOT_BASE: :P1 is not a base unit!', base_unit_);
   ELSE
      CLOSE exist_control;
      FOR oldrec_ IN get_record LOOP
         Client_SYS.Clear_Attr(attr_);
         -- skip Unpack_Check_Update___ since unit type is not updateable
         newrec_ := oldrec_;
         newrec_.unit_type := Iso_Unit_Type_API.Encode(unit_type_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END LOOP;
   END IF;
END Set_Unit_Type;


-- Check_Base
--   Checks and gives an error if the input unit code is not the base unit.
PROCEDURE Check_Base (
   unit_code_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   ISO_UNIT_BASE
      WHERE  unit_code = unit_code_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
   ELSE
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist('Base Unit');
   END IF;
END Check_Base;


-- Get_Definition_Type
--   This returns "USER_DEFINED" if the given ISO unit is
--   an user defined unit. If the given unit is an SYSTEM DEFINED unit
--   it returns 'SYSTEM_DEFINED' . Returns null otherwise.
@UncheckedAccess
FUNCTION Get_Definition_Type (
   unit_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ ISO_UNIT.user_defined%TYPE;
   CURSOR get_attr IS
      SELECT user_defined
      FROM ISO_UNIT
      WHERE unit_code = unit_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF temp_ = 'TRUE' THEN
      RETURN 'USER_DEFINED';
   ELSIF temp_ = 'FALSE' THEN
      RETURN 'SYSTEM_DEFINED';
   END IF;

   -- if entererd unit_code does not exist
   IF temp_ IS NULL THEN
      RETURN NULL;
   END IF;
END Get_Definition_Type;
