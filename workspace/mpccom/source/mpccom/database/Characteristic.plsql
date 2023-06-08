-----------------------------------------------------------------------------
--
--  Logical unit: Characteristic
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160107  JoAnSe STRMF-2316, Override added for Get_Description to retrieve translated value.
--  140807  Matkse PRSC-318, Removed overtake of Insert___. CRUD operations for client is instead now blocked through codegen property 
--                 DbClientInterface "read-only" on model.
--  131113  UdGnlk PBSC-357, Modified base view to align with model file errors. 
--  100426  Ajpelk Merge rose method documentation
--  100908  GayDLK Bug 92479, Added code to make sure rowtype is either Discrete or Indiscrete in 
--  100908  GayDLK Check_Exist___().    
--  100902  GayDLK Bug 92479, Added code to prevent creating records of type Characteristic.
--  091001  PraWlk Bug 85778, Added function Get_Row_Type_Translated to get the translated
--  091001         value of Row Type.
--  090714  SuThlk Bug 83313, Added method Get_Formatted_Char_Value.
--  070921  NuVelk Removed methods Get_Transfer_To_Cbs and Get_Transfer_To_Cbs_Db.
--  070312  NuVelk Added methods Get_Transfer_To_Cbs and Get_Transfer_To_Cbs_Db.
--  061227  MiErlk Added method Get_Row_Type.
--  060111  SeNslk Modified modified the PROCEDURE Insert___ according to the new template.
--  040519  IsAnlk Bug 44467, Added function Get_Search_Type_Db.
--  040223  SaNalk Removed SUBSTRB.
--  --------------------- 13.3.0 --------------------------------------------
--  001015  PERK  Added condition to view
--  000925  JOHESE  Added undefines.
--  990422  JOHW  General performance improvements.
--  990415  JOHW  Upgraded to performance optimized template.
--  971124  JOKE  Converted to Foundation1 2.0.0 (32-bit).
--  970313  CHAN  Changed table name: mpc_characteristics is replace by
--                characteristic_tab
--  970221  JOKE  Uses column rowversion as objversion (timestamp).
--  961213  JOKE  Modified with new workbench default templates.
--  961030  JOKE  Changed for compatibility with Workbench.
--  961024  JOBE  Removed procedure Get_Search_Type.
--  960412  SHVE  Added procedure Get_Search_Type from old track.
--  960307  JICE  Renamed from Characteristics
--  951109  JOBR  Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Row_Type (
   characteristic_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_type_  CHARACTERISTIC_TAB.rowtype%TYPE;
   CURSOR get_rowtype IS
      SELECT rowtype
      FROM   CHARACTERISTIC_TAB
      WHERE  Characteristic_Code = Characteristic_Code_ ;
BEGIN
   OPEN get_rowtype;
   FETCH get_rowtype  INTO row_type_ ;
   CLOSE get_rowtype;
   RETURN row_type_ ;
END Get_Row_Type;


@UncheckedAccess
FUNCTION Get_Formatted_Char_Value (
   characteristic_code_  IN VARCHAR2,
   characteristic_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_char_value_    VARCHAR2(60);
   numeric_value_as_number_ NUMBER;
BEGIN
   IF (Characteristic_API.Get_Search_Type_Db(characteristic_code_) = 'N') THEN
      numeric_value_as_number_ := TO_NUMBER(characteristic_value_);
      IF ((numeric_value_as_number_ > 0) AND (numeric_value_as_number_ < 1)) THEN
         formatted_char_value_ := '0'||numeric_value_as_number_;
      ELSIF ((numeric_value_as_number_ > -1) AND (numeric_value_as_number_ < 0)) THEN
         formatted_char_value_ := '-0'||numeric_value_as_number_ * -1;
      ELSE
         formatted_char_value_ := characteristic_value_;
      END IF;
      RETURN (formatted_char_value_);
   ELSE
      RETURN (characteristic_value_);
   END IF;
END Get_Formatted_Char_Value;


-- Get_Row_Type_Translated
--   This method gives the translated value of Row Type.
@UncheckedAccess
FUNCTION Get_Row_Type_Translated (
   characteristic_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN                        
   RETURN Characteristic_Row_Type_API.Decode(Get_Row_Type(characteristic_code_));
END Get_Row_Type_Translated;

-- Get_Description
--    Overriden to retrieve translated description from the sub class LU:s
@Override
FUNCTION Get_Description (
   characteristic_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_type_  CHARACTERISTIC_TAB.rowtype%TYPE;
BEGIN
   row_type_ := Get_Row_Type(characteristic_code_);   
   IF (row_type_ = Characteristic_Row_Type_API.DB_DISCRETE_CHARACTERISTIC) THEN
      RETURN Discrete_Characteristic_API.Get_Description(characteristic_code_);
   ELSE
      RETURN Indiscrete_Characteristic_API.Get_Description(characteristic_code_);
   END IF;
   RETURN super(characteristic_code_);
END Get_Description;