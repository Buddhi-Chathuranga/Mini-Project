-----------------------------------------------------------------------------
--
--  Logical unit: DiscreteCharacValue
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160405  Rakalk   MATP-2099, CBS/CBSINT split.
--  151222  JoAnse   STRMF-2175, Added Modify_Char_Value_Desc called when replicating description from Configuration Characteristic Option Value.
--  130812  MaIklk   TIBE-930, Removed inst_WorkCenterSetupMatrix_ global variable and used conditional compilation instead.
--  130118  NipKlk   Bug 107760, Added dynamic calls to Check_Delete_Charac_Code_Value method in PURCH and ORDER from Check_Delete__ to
--  130118           restrict the value deletion if they are used in Purchase Part Char and Sales Part Characteristic.
--  130102  NiDalk   Bug 107052, Added new LOV view DISCRETE_CHARAC_NUMERIC_VALUE to reference numeric characteristic value from the client.
--  110527  MaEelk   Modified Check_Exist___ and Check_Characteristic_Value to support numeric values.
--  100519  MoNilk   Added REF DiscreteCharacteristic in column comment on DISCRETE_CHARAC_VALUE.characteristic_code.
--  100429  Ajpelk   Merge rose method documentation.
--  100120  MaMalk   Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120           in the business logic.
--  100429  Asawlk   Bug 89662, Added new derived columns characteristic_value_numeric and characteristic_value_alpha
--  100429           to the view DISCRETE_CHARAC_VALUE. Modified the Unpack_Check_Insert() and Unpack_Check_Update() to
--  100429           to handle newly added columns. Modified Check_Characteristic_Value() to raise more appropriate error msg.
--  100429           Also modified Check_Exist___() to facilitate characteristic types alpha and numeric.
--  ------------------------------- 14.0.0 ----------------------------------
--  090714  SuThlk   Bug 83313, Did modification in Unpack_Check_Insert___ and Exist to store 
--  090714           and validate the values in between -1 and 1 in 0.xx format.
--  060310  MaHplk   Added Genaral_SYS.Init_Method for procedure Check_Characteristic_Value.
--  060131  MarSlk   Bug 55573, Added procedure Check_Characteristic_Value and 
--  060131           moved some repeating codes into the method.
--  060123  JaJalk   Added Assert safe annotation.
--  060111  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111           and added UNDEFINE according to the new template.
--  ------------------------------- 13.3.0 ----------------------------------
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  001128  PERK    Changed order of characteristic_value and characteristic_code
--  001124  PERK    Added method New
--  001015  PERK    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
FUNCTION Check_Exist___ (
   characteristic_code_ IN VARCHAR2,
   characteristic_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   -- This cursor will facilitate numeric characteristic values including Exponential form of numbers.
   CURSOR exist_control_numeric IS
      SELECT 1
      FROM   DISCRETE_CHARAC_VALUE_TAB
      WHERE characteristic_code = characteristic_code_
      AND   TO_CHAR(TO_NUMBER(characteristic_value)) = TO_CHAR(TO_NUMBER(characteristic_value_));
BEGIN
   IF (Characteristic_API.Get_Search_Type_Db(characteristic_code_) = 'N') THEN
      OPEN exist_control_numeric;
      FETCH exist_control_numeric INTO dummy_;
      IF (exist_control_numeric%FOUND) THEN
         CLOSE exist_control_numeric;
         RETURN(TRUE);
      END IF;
      CLOSE exist_control_numeric;
      RETURN(FALSE);
   ELSE
      RETURN super(characteristic_code_, characteristic_value_);
   END IF;
END Check_Exist___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DISCRETE_CHARAC_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      Work_Center_Setup_Matrix_API.Add_To_Setup_Matrix (newrec_.characteristic_code , newrec_.characteristic_value); 
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN DISCRETE_CHARAC_VALUE_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   $IF Component_Purch_SYS.INSTALLED $THEN 
      Purchase_Part_Char_API.Check_Delete_Charac_Code_Value(remrec_.characteristic_code, remrec_.characteristic_value);             
   $END

   $IF Component_Order_SYS.INSTALLED $THEN 
      Sales_Part_Characteristic_API.Check_Delete_Charac_Code_Value(remrec_.characteristic_code, remrec_.characteristic_value);             
   $END
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN DISCRETE_CHARAC_VALUE_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      Work_Center_Setup_Matrix_API.Remove_Value_From_Matrix (remrec_.characteristic_code , remrec_.characteristic_value); 
   $END
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT discrete_charac_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   search_type_db_   VARCHAR2(1);
   item_counter_     NUMBER := 0;
BEGIN
   IF (indrec_.characteristic_value) THEN 
      item_counter_ := item_counter_ + 1;
   END IF;
   IF (Client_SYS.Item_Exist('CHARACTERISTIC_VALUE_ALPHA', attr_)) THEN
      newrec_.characteristic_value := Client_SYS.Get_Item_Value('CHARACTERISTIC_VALUE_ALPHA', attr_);
      item_counter_ := item_counter_ + 1;
   END IF;
   IF (Client_SYS.Item_Exist('CHARACTERISTIC_VALUE_NUMERIC', attr_)) THEN
      newrec_.characteristic_value := Client_SYS.Get_Item_Value('CHARACTERISTIC_VALUE_NUMERIC', attr_);
      item_counter_ := item_counter_ + 1;
   END IF;
   super(newrec_, indrec_, attr_);

   -- Just to make sure no insertions are done using more than one attribute at a time.
   IF (item_counter_ > 1) THEN
      Error_SYS.Record_General(lu_name_,'MULTIPLE_CHAR_VAL: You can give a value to only one column from Characteristic Value, Characteristic Value Alpha and Characteristic Value Numeric at a time.');
   END IF;
   IF (newrec_.characteristic_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DIS_CHAR_VAL_REQ: An alpha/numeric characteristic value is required for Discrete Characteristics.');
   END IF;

   search_type_db_ := Characteristic_API.Get_Search_Type_Db(newrec_.characteristic_code);
   Check_Characteristic_Value(newrec_.characteristic_value, search_type_db_);
   newrec_.characteristic_value := Characteristic_API.Get_Formatted_Char_Value(newrec_.characteristic_code,
                                                                               newrec_.characteristic_value);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     discrete_charac_value_tab%ROWTYPE,
   newrec_ IN OUT discrete_charac_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   search_type_db_   VARCHAR2(1);
BEGIN
   IF (Client_SYS.Item_Exist('CHARACTERISTIC_VALUE_ALPHA', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CHARACTERISTIC_VALUE_ALPHA');
   END IF;
   IF (Client_SYS.Item_Exist('CHARACTERISTIC_VALUE_NUMERIC', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CHARACTERISTIC_VALUE_NUMERIC');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   search_type_db_ := Characteristic_API.Get_Search_Type_Db(newrec_.characteristic_code);
   Check_Characteristic_Value(newrec_.characteristic_value, search_type_db_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
PROCEDURE Exist (
   characteristic_code_ IN VARCHAR2,
   characteristic_value_ IN VARCHAR2 )
IS
   value_   VARCHAR2(60);
BEGIN
   value_ := Characteristic_API.Get_Formatted_Char_Value(characteristic_code_,characteristic_value_);
   super(characteristic_code_, value_);
END Exist;


-- New
--   Creates a new discrete characteristic value.
PROCEDURE New (
   characteristic_code_ IN VARCHAR2,
   characteristic_value_ IN VARCHAR2,
   characteristic_value_desc_ IN VARCHAR2 )
IS

   newrec_       DISCRETE_CHARAC_VALUE_TAB%ROWTYPE;
   objid_        DISCRETE_CHARAC_VALUE.objid%TYPE;
   objversion_   DISCRETE_CHARAC_VALUE.objversion%TYPE;
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;

BEGIN


   IF NOT (Check_Exist___(characteristic_code_, characteristic_value_)) THEN

      Prepare_Insert___(attr_);

      IF (characteristic_code_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('CHARACTERISTIC_CODE', characteristic_code_, attr_);
      END IF;

      IF (characteristic_value_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE', characteristic_value_, attr_);
      END IF;

      IF (characteristic_value_desc_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE_DESC', characteristic_value_desc_, attr_);
      END IF;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

   END IF;

END New;


-- Check_Characteristic_Value
--   Raises an exception when trying to modify the search type from alpha
--   to numeric if nonumeric data exists.
PROCEDURE Check_Characteristic_Value (
   characteristic_value_ IN VARCHAR2,
   search_type_db_       IN VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(60);
   ndummy_   NUMBER;
BEGIN

   -- Generate an exception for invalid numbers 
   IF (search_type_db_ = 'N') THEN
      name_   := 'CHARACTERISTIC_VALUE_ALPHA';
      value_  := characteristic_value_;
      ndummy_ := TO_NUMBER(characteristic_value_);
      IF (LENGTH(characteristic_value_) > 29) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDNUMERIC: Characteristic Value :P1 exceeds 29 digits. The extra digits must be removed before the Characteristic Code is swapped into a numeric ',characteristic_value_ );
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Characteristic_Value;


-- Modify_Char_Value_Desc
--   Modifies the description for an existing characteristic option value.
PROCEDURE Modify_Char_Value_Desc (
   characteristic_code_  IN VARCHAR2,
   characteristic_value_ IN VARCHAR2,
   description_          IN VARCHAR2 )
IS
   newrec_  discrete_charac_value_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___(characteristic_code_, characteristic_value_)) THEN
      newrec_ := Get_Object_By_Keys___(characteristic_code_, characteristic_value_);   
      newrec_.characteristic_value_desc := description_;
      Modify___(newrec_);  
   END IF;
END Modify_Char_Value_Desc;

