-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartChar
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  141214  AwWelk  PRSC-1069, Made the InventoryPartChar entity as an abstract entity. Added methods Get_Object_By_Id___(), New__() and Modify__().
--  141214          Removed methods Insert___(), Update___(), Delete___(), Check_Insert___(), Check_Update___(), Add_Template_Characteristics__(),
--  141214          Delete_Char() and Create_Part_Char().
--  130801  UdGnlk  TIBE-874, Removed the dynamic code and modify to conditional compilation.
--  130506  Cpeilk  Bug 109105, Modified Remove__() by redirecting the Remove call to the correct LU.
--  120827  MalLlk  Bug 104312, Removed the condition for rowtype in INVENTORY_PART_CHAR view. 
--  120210  PraWlk  Bug 100868, Modified Unpack_Check_Insert___() and Unpack_Check_Update___() by adding IF conditions to do 
--  120210          the assignment for attr_value only if the value is not null or dfferent from the old value.
--  110518  Cpeilk  Bug 95963, Added unit_meas_ as IN parameter to methods Check_Char_Numeric and Check_Char_Numeric_Interval.
--  110302  ChJalk  Added function Get_Attr_Value.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100902  GayDLK  Bug 92479, Moved the code which is used to validate the characteristic type from Insert___() to  
--  100902          Unpack_Check_Insert___(). Made the length of rowtype_ to VARCHAR2(30) instead of &TABLE..ROWTYPE%TYPE 
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100902          in Unpack_Check_Insert___().
--  090722  MaEelk  Bug 83313, Did modification in Unpack_Check_Insert___ and Unpack_Check_Update___ to store the values 
--  090722          in between -1 and 1 in 0.xx format
--  081022  NWeelk  Bug 77695, Modified Unpack_Check_Update___ to validate when entering values
--  081022          for the Discrete characteristics in Inventory Part.
--  081016  NWeelk  Bug 77695, Modified Unpack_Check_Insert__ to validate when entering values 
--  081016          for the Discrete characteristics in Inventory Part. 
--  070717  MaJalk  Bug 66496, Modified the error message when ATTR_VALUE is null.
--  060702  MaJalk  Bug 62194, Introduced columns  attr_value_numeric, attr_value_alpha to the base view 
--  060702          and added code in unpack_check_insert and Unpack_check_update.
--  070417  NuVelk  Added validations for Unpack_Check_Insert___ and Unpack_Check_Update___, when entering characteristics manually. 
--  070307  NuVelk  Modified the Insert___ method to fetch the rowtype correctly.
--  060124  NiDalk  Added Assert safe annotation. 
--  050921  NiDalk  Removed unused variables.
--  050209  KeFelk  Removed Copy(). Moved all the content of this method to Copy_Characteristics() in InventoryPart.
--  050202  KeFelk  Added copy method and removed Is_Characteristic_Exist function.
--  050126  KanGlk  Removed copy method and added Is_Characteristic_Exist function.
--  050119  KeFelk  Rewriten the Copy method which makes the code easier to read.
--  041216  JaBalk  Removed default TRUE parameter from copy method.
--  041214  JaBalk  Added copy method.
--  040129  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040113  LaBolk  Removed call to public cursor get_attributes in Add_Template_Characteristics__ and used a local cursor instead.
--  ------------------------------EDGE PKG GRP 2-----------------------------
--  010410 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001108  PERK  Added NOCHECK to comment on part_no in INVENTORY_PART_CHAR_ALL
--  001031  PERK  Added NOCHECK to comment on characteristic_code in INVENTORY_PART_CHAR_ALL
--  001020  PERK  Added condition to view and a view without conditions
--  000925  JOHESE  Added undefines.
--  990427  LEPE  Correction of small error in dynamic PL call.
--  990423  LEPE  Added dynamic PL calls to SchedulingSiteConfig in all base methods.
--  990422  JOHW  General performance improvements.
--  990409  JOHW  Upgraded to performance optimized template.
--  971201  GOPE  Upgrade to fnd 2.0
--  971021  LEPE  Added check that makes it impossible to add a characteristic to an
--                inventory part that has no characteristic template. Added CASCADE option to
--                reference against InventoryPart in the view comments.
--  970908  NABE  Changed references of UnitOfMeasure to IsoUnit LU.
--  970618  MAGN  Removed procedure Create_Template_Characteristics and modified Create_Part_Char.
--  970616  MAGN  Added new procedure Add_Template_Characteristics__.
--  970530  LEPE  Additions in unpack_check_ methods to make value_error message better for attr_value.
--  970509  PEKR  Added contract as primary key.
--  970313  MAGN  Changed tablename from mpc_part_characteristics to inventory_part_char_tab.
--  970220  JOKE  Uses column rowversion as objversion (timestamp).
--  970128  JOKE  Added Cascade on Part_No^Ref='PartLedger/CASCADE^.
--  970110  JOKE  Added procedure Create_Template_Characteristic.
--  961213  AnAr  Modified file for new template standard.
--  961111  JICE  Modified for Rational Rose / Workbench.
--  960912  JICE  Added functions Check_Char_String, Check_Char_String_Interval,
--                Check_Char_Numeric and Check_Char_Numeric_Interval,
--                fix in Insert_New_Char to skip NULL unit_meas and insert 0
--                rather than '.' for numeric values.
--  960910  JICE  Check for non-numeric values on numeric attributes added.
--  960903  LEPE  Removed trash characters from end of file.
--  969830  CAJO  Ref. 96-0247: Changed format on column 'Unit' to uppercase,
--                added exist check on unit.
--  960307  JICE  Renamed from PartCharacteristics
--  951108  JOBR  Base Table to Logical Unit Generator 1.0A
--  951108  JOBR  Added functionality for V10.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--
-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN inventory_part_char_tab%ROWTYPE
IS
   lu_rec_ inventory_part_char_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  inventory_part_char_tab
      WHERE rowid = objid_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Record_Removed(lu_name_);
   WHEN too_many_rows THEN
      Error_SYS.Too_Many_Rows(Inventory_Part_Char_API.lu_name_, NULL, 'Get_Object_By_Id___');
END Get_Object_By_Id___;
      
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
 
PROCEDURE New__ (
   info_          OUT VARCHAR2,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   characteristic_code_ INVENTORY_PART_CHAR_TAB.characteristic_code%TYPE;
   rowtype_             VARCHAR2(30);
BEGIN
   characteristic_code_ := Client_SYS.Get_Item_Value('CHARACTERISTIC_CODE', attr_);
   rowtype_             := Characteristic_API.Get_Row_Type(characteristic_code_);
   
   IF (rowtype_ = 'DiscreteCharacteristic') THEN
      Inv_Part_Discrete_Char_API.New__(info_, objid_, objversion_, attr_, action_);
   ELSE
      Inv_Part_Indiscrete_Char_API.New__(info_, objid_, objversion_, attr_, action_);
   END IF;
END New__;

   
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_   inventory_part_char_tab%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Id___(objid_);
   IF (oldrec_.rowtype = 'InvPartDiscreteChar') THEN
      Inv_Part_Discrete_Char_API.Modify__(info_, objid_, objversion_, attr_, action_);
   ELSE
      Inv_Part_Indiscrete_Char_API.Modify__(info_, objid_, objversion_, attr_, action_);
   END IF;
END Modify__;

   
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ INVENTORY_PART_CHAR_TAB%ROWTYPE;
BEGIN
   -- Calling private interfaces from server side was done below intentionally to maintain referential integrity.
   remrec_ := Get_Object_By_Id___(objid_);
   IF (remrec_.rowtype = 'InvPartDiscreteChar') THEN
      Inv_Part_Discrete_Char_API.Remove__(info_, objid_, objversion_, action_);
   ELSE
      Inv_Part_Indiscrete_Char_API.Remove__(info_, objid_, objversion_, action_);
   END IF;
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Part_Has_Char
--   Returns TRUE if part has characteristics, otherwise FALSE.
@UncheckedAccess
FUNCTION Part_Has_Char (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR check_exist IS
      SELECT 'X'
        FROM INVENTORY_PART_CHAR_TAB
       WHERE contract = contract_
         AND part_no = part_no_;
   --
   dummy_ VARCHAR2(1);
   --
BEGIN
   OPEN  check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      RETURN TRUE;
   END IF;
   CLOSE check_exist;
   RETURN FALSE;
END Part_Has_Char;


-- Check_Char_Numeric
--   Checks for match between given numeric value and characteristic.
@UncheckedAccess
FUNCTION Check_Char_Numeric (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_              INVENTORY_PART_CHAR_TAB.part_no%TYPE;
   value_               INVENTORY_PART_CHAR_TAB.attr_value%TYPE;
   search_type_db_      VARCHAR2(20);


   CURSOR char_cur IS
    SELECT part_no, attr_value
      FROM INVENTORY_PART_CHAR_TAB
     WHERE contract = contract_
       AND part_no = part_no_
       AND (unit_meas = unit_meas_ OR unit_meas_ IS NULL)
       AND characteristic_code = characteristic_code_
       AND search_type_db_ = 'N'
       AND attr_value != '.';  /* Default value for insert in Forms3 */

BEGIN
   search_type_db_ := Alpha_Numeric_API.Encode(Characteristic_API.Get_Search_Type(characteristic_code_));

   OPEN  char_cur;
   FETCH char_cur INTO return_, value_;
      IF char_cur%NOTFOUND THEN
         return_ := NULL;
      ELSIF To_Number(value_) != To_Number(search_number_) THEN
         return_ := NULL;
      END IF;
   CLOSE char_cur;
   RETURN return_;
END Check_Char_Numeric;


-- Check_Char_Numeric_Interval
--   Checks if characteristic is between given numeric values.
@UncheckedAccess
FUNCTION Check_Char_Numeric_Interval (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   unit_meas_           IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_number_from_  IN VARCHAR2,
   search_number_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_              INVENTORY_PART_CHAR_TAB.PART_NO%TYPE;
   value_               INVENTORY_PART_CHAR_TAB.ATTR_VALUE%TYPE;
   search_type_db_      VARCHAR2(20);

   CURSOR char_cur IS
      SELECT part_no, attr_value
        FROM INVENTORY_PART_CHAR_TAB
       WHERE contract = contract_
         AND part_no = part_no_
         AND (unit_meas = unit_meas_ OR unit_meas_ IS NULL)
         AND characteristic_code = characteristic_code_
         AND search_type_db_ = 'N'
         AND attr_value != '.';

BEGIN
   search_type_db_ := Alpha_Numeric_API.Encode(Characteristic_API.Get_Search_Type(characteristic_code_));
   OPEN  char_cur;
   FETCH char_cur INTO return_, value_;
      IF char_cur%NOTFOUND THEN
         return_ := NULL;
      ELSIF To_Number(value_) NOT BETWEEN To_Number(search_number_from_) AND To_Number(search_number_to_) THEN
         return_ := NULL;
      END IF;
   CLOSE char_cur;
   RETURN return_;
   END Check_Char_Numeric_Interval;
   

-- Check_Char_String
--   Checks for match between given alphanumeric value and characteristic.
@UncheckedAccess
FUNCTION Check_Char_String (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_              INVENTORY_PART_CHAR_TAB.PART_NO%TYPE;

   CURSOR char_cur IS
      SELECT part_no
        FROM INVENTORY_PART_CHAR_TAB
       WHERE attr_value LIKE search_string_
         AND contract = contract_
         AND characteristic_code = characteristic_code_
         AND part_no = part_no_;
BEGIN
   OPEN  char_cur;
   FETCH char_cur INTO return_;
      IF char_cur%NOTFOUND THEN
         return_ := NULL;
      END IF;
   CLOSE char_cur;
   RETURN return_;
END Check_Char_String;


-- Check_Char_String_Interval
--   Checks if characteristic is between given alphanumeric values.
@UncheckedAccess
FUNCTION Check_Char_String_Interval (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2,
   search_string_from_  IN VARCHAR2,
   search_string_to_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_              INVENTORY_PART_CHAR_TAB.PART_NO%TYPE;

   CURSOR char_cur IS
      SELECT part_no
        FROM INVENTORY_PART_CHAR_TAB
       WHERE contract = contract_
         AND part_no  = part_no_
         AND characteristic_code = characteristic_code_
         AND attr_value BETWEEN search_string_from_ AND search_string_to_;

BEGIN
   OPEN  char_cur;
   FETCH char_cur INTO return_;
      IF char_cur%NOTFOUND THEN
         return_ := NULL;
      END IF;
   CLOSE char_cur; 
   RETURN return_;
END Check_Char_String_Interval;


@UncheckedAccess
FUNCTION Get_Attr_Value (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   characteristic_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_value_ INVENTORY_PART_CHAR_TAB.attr_value%TYPE;

   CURSOR get_attr_value IS
      SELECT attr_value
        FROM INVENTORY_PART_CHAR_TAB
       WHERE contract = contract_
         AND part_no = part_no_
         AND characteristic_code = characteristic_code_;
BEGIN
   OPEN  get_attr_value;
   FETCH get_attr_value INTO attr_value_;
   CLOSE get_attr_value;  
   RETURN(attr_value_);
END Get_Attr_Value;



