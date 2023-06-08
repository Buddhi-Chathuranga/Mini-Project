-----------------------------------------------------------------------------
--
--  Logical unit: Client
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950412  STLA  Created
--  950421  STLA  Rename from PROTOCOL to Client package
--  950518  STLA  Uses VARCHAR2 as protocol carrier
--  950523  ERFO  Converted to standards and renamed to Client_SYS
--  950529  STLA  Added routines for date and number variables
--  950530  STLA  Renamed some attribute manipulating routines for clarity.
--  950530  STLA  Added standard client/server protocol date format
--  950616  ERFO  Small changes according to EVEREST conventions
--  950912  STLA  Added new separator definitions
--  950925  ERFO  Changed AS to IS to be compatible with Procedure Builder
--  950926  STLA  Added new separator definitions
--  950926  STLA  Corrected separator definitions according to ASCII table
--  950927  ERFO  Re-installed T250-routines for compatible reasons.
--                Change in Get_All_Info to include call to Clear_Info.
--  950928  ERFO  Added method Get_Separator_Info to be used from client.
--  950929  ERFO  Change group_separator_ to record_separator_ in the code.
--  951004  ERFO  Re-installed valid code for T250-compliance.
--  951006  ERFO  Add translation support for info and warnings
--  951220  STLA  Added procedure to copy attribute string contents to
--                DBMS_OUTPUT.Put_Line calls for debugging purposes (Idea #312)
--  960319  ERFO  Removed support for T250-conversions in EVEREST 1.1 (Idea #455).
--  960426  MANY  Added method Get_Item_Value, copied from Report_SYS.
--  960429  ERFO  Added PRAGMA on method Get_Item_Value.
--  960819  ERFO  Added PRAGMA on methods Attr_Value_To_XXX (Idea #748).
--  970729  ERFO  Added global date_format_ for formatting.
--  970801  ERFO  Added method Set_Item_Value (ToDo #1546).
--  970817  MANY  Added pragma restrict_references to most methods.
--  971019  ERFO  Added routines for key reference lists.
--  980227  ERFO  Added overloaded methods Get_Key_Reference (ToDo #2166).
--  981014  TOFU  Correct Client_SYS.Set_Item_Value (Bug #2610).
--  981103  ERFO  Removed invalid EXCEPTIONS from several methods (Bug #2866).
--  010208  ROOD  Restricted current_info_ in Add_Warning and Add_Info (Bug#19875).
--  011126  ROOD  Replaced usage of user_col_comments with fnd_col_comments (Bug#26328).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040407  HAAR  Unicode bulk changes,
--                extended define variable temp_key_ref length in Get_Key_Reference (F1PR408B).
--  040411  JORA  Added assertion for dynamic SQL.  (F1PR481)
--                Changed Get_Key_Reference to use bind variable in dynamic sql.
--  051213  HAAR  Added Get_Trace to remove Get_Mts_Trace_ in General_SYS (F1PR480).
--  060105  UTGULK Annotated Sql injection.
--  070111  SUKMLK Increased the length of line_ in Add_Info and Add_Warning to 1024 (Bug#62873).
--  070516  HAAR  Changed Get_Trace to fetch all lines (Bug#64423).
--  070528  SUKM  Added a call to clean key ref in Get_Key_Reference (Call#145301)
--  090408  HASPLK Modified method Get_Key_Reference to format Date type values (Bug#81852).
--  091229  JHMASE Changed cursor get_key_info to fetch key columns based on key flags (Bug#88063)
--  100324  UsRaLK Changed Get_Key_Reference to use Dictionary_SYS to locate the base view of an LU (Bug#89730).
--  130515  PGANLK Changed Get_Key_Reference to increse the key-value pair parameters to 15 (Bug#109627)
--  140905  ChMuLK Modified Get_Key_Reference to avoid buffer overflow error. (Bug#118620/TEBASE-580)
--- 190510  RAKUSE Added methods Get_Next_From_List, Get_Next_From_Selection, Add_To_List. (TEUXXCC-2163)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

text_separator_     CONSTANT VARCHAR2(1)  := '^';
field_separator_    CONSTANT VARCHAR2(1)  := chr(31);
record_separator_   CONSTANT VARCHAR2(1)  := chr(30);
group_separator_    CONSTANT VARCHAR2(1)  := chr(29);
file_separator_     CONSTANT VARCHAR2(1)  := chr(28);
date_format_        CONSTANT VARCHAR2(30) := 'YYYY-MM-DD-HH24.MI.SS';
timestamp_format_   CONSTANT VARCHAR2(30) := 'YYYY-MM-DD-HH24.MI.SS.FF9';
trunc_date_format_  CONSTANT VARCHAR2(30) := 'YYYY-MM-DD';
trunc_time_format_  CONSTANT VARCHAR2(30) := 'HH24.MI.SS';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Max_Current_Info___ (
   current_info_max_length_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   string_  VARCHAR2(32767) := Substr(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_'), 1, current_info_max_length_);
BEGIN
   string_ := Substr(string_, 1, Instr(string_, record_separator_, -1));
   RETURN(string_);
END Get_Max_Current_Info___;

PROCEDURE Get_Key_Ref_Info___ (
   key_ref_    OUT VARCHAR2,
   sql_column_ OUT VARCHAR2,
   view_       IN  VARCHAR2,
   for_table_  IN  BOOLEAN DEFAULT FALSE,
   use_binary_ci_sort_          IN  BOOLEAN DEFAULT FALSE,
   for_enum_use_table_column_   IN  BOOLEAN DEFAULT FALSE)
IS
   key_ref_field_name_  VARCHAR2(32000);
   key_ref_select_name_ VARCHAR2(32000);
   stmt_str_            VARCHAR2(1000);
   
   TYPE KeyInfoCurTyp   IS REF CURSOR;
   TYPE view_col_type_ IS RECORD (
     column_name        dictionary_sys_view_column_tab.column_name%TYPE,
     column_datatype    dictionary_sys_view_column_tab.column_datatype%TYPE,
     enumeration        dictionary_sys_view_column_tab.enumeration%TYPE,
     table_column_name  dictionary_sys_view_column_tab.table_column_name%TYPE
   );
   view_col_rec_        view_col_type_;
   keys_cursor_         KeyInfoCurTyp;
   
   
BEGIN
   sql_column_ := '''';
   --SOLSETFW
   stmt_str_ := 'SELECT column_name, column_datatype, enumeration,table_column_name
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = :view_
      AND    type_flag IN (''P'',''K'')';
   IF (use_binary_ci_sort_) THEN
      stmt_str_ := stmt_str_ || ' ORDER BY NLSSORT(COLUMN_NAME,''NLS_SORT=BINARY_CI'')';      
   ELSE
      stmt_str_ := stmt_str_ || ' ORDER BY column_name';
   END IF;
   
   @ApproveDynamicStatement(2018-02-19,maddlk);
   OPEN keys_cursor_ FOR stmt_str_ USING view_;
   
   LOOP
      FETCH keys_cursor_ INTO view_col_rec_;
      EXIT WHEN keys_cursor_%NOTFOUND;
   
      key_ref_field_name_ := view_col_rec_.column_name;
      key_ref_select_name_ := view_col_rec_.column_name;
      
      IF view_col_rec_.column_datatype NOT LIKE 'DATE%' THEN
         IF (view_col_rec_.enumeration IS NOT NULL) THEN
            IF(NOT for_enum_use_table_column_)THEN
               key_ref_field_name_  := view_col_rec_.column_name||'_DB';
               key_ref_select_name_ := view_col_rec_.column_name||'_DB';
            END IF;
            IF for_table_ THEN
               key_ref_select_name_ := NVL(view_col_rec_.table_column_name, view_col_rec_.column_name);
            END IF;
         ELSE
            IF for_table_ THEN
               key_ref_select_name_ := NVL(view_col_rec_.table_column_name, view_col_rec_.column_name);
            END IF;
         END IF;
      ELSE
         IF for_table_ THEN
            key_ref_select_name_ := 'to_char('||NVL(view_col_rec_.table_column_name, view_col_rec_.column_name)||','''||date_format_||''')';
         ELSE
            key_ref_select_name_ := 'to_char('||view_col_rec_.column_name||','''||date_format_||''')';
         END IF;
      END IF;
      key_ref_    := key_ref_||key_ref_field_name_||'='||text_separator_;
      sql_column_ := sql_column_ || key_ref_field_name_||'=''||'||key_ref_select_name_||'||'''||text_separator_||'';  
   END LOOP;
   
   CLOSE keys_cursor_;
   
   IF sql_column_ IS NOT NULL THEN
      sql_column_ := sql_column_ || '''';
   END IF;
END Get_Key_Ref_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_System_Info__ RETURN CLOB
IS
   msg_                    CLOB         := Message_SYS.Construct('CLIENT_INFO');
   local_date_format_   CONSTANT VARCHAR2(10) := 'YYYY-MM-DD';
   
   FUNCTION Get_Installed_Components___ RETURN VARCHAR2
   IS
      CURSOR get_installed IS 
         SELECT DISTINCT module, 'TRUE' installed 
         FROM module_tab 
         WHERE Nvl(version, '*') != '*' AND version != '?'
         UNION 
         SELECT DISTINCT dependent_module, 'FALSE' installed 
         FROM module_dependency_tab t 
         WHERE NOT EXISTS (
            SELECT 1 FROM module_tab m 
            WHERE m.module = t.dependent_module 
            AND Nvl(version, '*') NOT IN ('*','?'))
         AND EXISTS (
            SELECT 1 FROM module_tab m 
            WHERE m.module = t.module
            AND version NOT IN ('*','?'))
            ORDER BY 1;
      installed_  VARCHAR2(32000);
   BEGIN
      FOR rec IN get_installed LOOP
         installed_ := installed_ || rec.module || Client_SYS.field_separator_ || rec.installed || Client_SYS.record_separator_;
      END LOOP;
      RETURN(installed_);
   END Get_Installed_Components___;

   FUNCTION Get_Csvs___ RETURN VARCHAR2
   IS
      --SOLSETFW
      CURSOR get_csv IS 
         SELECT c.name, 
                CASE c.implementation_type
                WHEN Implementation_Type_API.DB_CLIENT 
                   THEN Fnd_Boolean_API.DB_TRUE
                WHEN Implementation_Type_API.DB_SERVER 
                   THEN Fnd_Boolean_API.DB_FALSE
                ELSE
                   'ERROR'
                END  is_client,
                transient,
                fnd_data_type
           FROM context_substitution_var_tab c
          WHERE EXISTS (SELECT 1 FROM module_tab m WHERE c.module = m.module AND active = 'TRUE')
          ORDER BY 1;

      csvs_  VARCHAR2(32000);
   BEGIN
      FOR rec IN get_csv LOOP
         csvs_ := csvs_ || rec.name || Client_SYS.field_separator_ || rec.is_client|| Client_SYS.field_separator_ || rec.transient || Client_SYS.field_separator_ || rec.fnd_data_type || Client_SYS.record_separator_;
      END LOOP;
      RETURN(csvs_);
   END Get_Csvs___;

   FUNCTION Get_Fnd_Settings___ RETURN VARCHAR2
   IS
      CURSOR get_settings IS 
         SELECT t.parameter, t.value
         FROM fnd_setting_tab t
         ORDER BY 1;

      settings_  VARCHAR2(32000);
   BEGIN
      FOR rec IN get_settings LOOP
         settings_ := settings_ || rec.parameter || Client_SYS.field_separator_ || rec.value || Client_SYS.record_separator_;
      END LOOP;
      RETURN(settings_);
   END Get_Fnd_Settings___;

   FUNCTION Get_User_Globals___ RETURN VARCHAR2
   IS
      fnd_user_   VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;

      CURSOR get_globals IS
         SELECT entry_code, default_value
         FROM  user_profile_sys_tab
         WHERE user_name = fnd_user_;

      globals_  VARCHAR2(32000);
   BEGIN
      FOR rec IN get_globals LOOP
         globals_ := globals_ || rec.entry_code || Client_SYS.field_separator_ || User_Global_API.Decode(rec.entry_code) || Client_SYS.field_separator_ || rec.default_value || Client_SYS.field_separator_ || User_Profile_SYS.Get_Value_List__(rec.entry_code, fnd_user_) || Client_SYS.record_separator_;
      END LOOP;
      RETURN(globals_);
   END Get_User_Globals___;

BEGIN
   Message_SYS.Add_Attribute(msg_, 'SEPARATORS', Client_SYS.field_separator_||Client_SYS.record_separator_);
   Message_SYS.Add_Attribute(msg_, 'DATE_FORMAT', local_date_format_);
   Message_SYS.Add_Attribute(msg_, 'FIRST_CALENDAR_DATE', To_Char(Database_SYS.Get_First_Calendar_Date, local_date_format_));
   Message_SYS.Add_Attribute(msg_, 'LAST_CALENDAR_DATE', To_Char(Database_SYS.Get_Last_Calendar_Date, local_date_format_));
   Message_SYS.Add_Attribute(msg_, 'LANGUAGE', Fnd_Session_API.Get_Language);
   Message_SYS.Add_Attribute(msg_, 'CONTEXT_SUBSTITUTION_VARIABLES', Get_Csvs___);
   Message_SYS.Add_Attribute(msg_, 'FND_SETTINGS', Get_Fnd_Settings___);
   Message_SYS.Add_Attribute(msg_, 'USER_GLOBALS', Get_User_Globals___);
   Message_SYS.Add_Attribute(msg_, 'SYSTEM_COMPONENTS', Get_Installed_Components___);
   RETURN(msg_);
END Get_System_Info__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
   
-- Clear_Attr
--   Clears a given attribute record (e.g. nullifies it).
--   Must be called before any calls to Add_To_Attr function.
@UncheckedAccess
PROCEDURE Clear_Attr (
   attr_ OUT VARCHAR2 )
IS
BEGIN
   attr_ := NULL;
END Clear_Attr;



-- Add_To_Attr
--   Adds an attribute name and value at the end of a given
--   attribute record.
@UncheckedAccess
PROCEDURE Add_To_Attr (
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   attr_ := attr_||name_||field_separator_||value_||record_separator_;
END Add_To_Attr;



-- Add_To_Attr
--   Adds an attribute name and value at the end of a given
--   attribute record.
@UncheckedAccess
PROCEDURE Add_To_Attr (
   name_  IN     VARCHAR2,
   value_ IN     NUMBER,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_Attr(name_, to_char(value_), attr_);
END Add_To_Attr;



-- Add_To_Attr
--   Adds an attribute name and value at the end of a given
--   attribute record.
@UncheckedAccess
PROCEDURE Add_To_Attr(
   name_  IN     VARCHAR2,
   value_ IN     DATE,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_Attr(name_, to_char(value_, date_format_), attr_);
END Add_To_Attr;



-- Add_To_Attr
--   Adds an attribute name and value at the end of a given
--   attribute record.
@UncheckedAccess
PROCEDURE Add_To_Attr(
   name_  IN     VARCHAR2,
   value_ IN     TIMESTAMP_UNCONSTRAINED,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_Attr(name_, to_char(value_, timestamp_format_), attr_);
END Add_To_Attr;


-- Add_To_Attr_If_Not_Null
--   Adds an attribute name and value at the end of a given
--   attribute record if value is not null.
@UncheckedAccess
PROCEDURE Add_To_Attr_If_Not_Null (
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   IF (value_ IS NOT NULL) THEN 
      Add_To_Attr(name_, value_, attr_);
   END IF;
END Add_To_Attr_If_Not_Null;



-- Add_To_Attr_If_Not_Null
--   Adds an attribute name and value at the end of a given
--   attribute record if value is not null.
@UncheckedAccess
PROCEDURE Add_To_Attr_If_Not_Null (
   name_  IN     VARCHAR2,
   value_ IN     NUMBER,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   IF (value_ IS NOT NULL) THEN 
      Add_To_Attr(name_, value_, attr_);
   END IF;
END Add_To_Attr_If_Not_Null;



-- Add_To_Attr_If_Not_Null
--   Adds an attribute name and value at the end of a given
--   attribute record if value is not null.
@UncheckedAccess
PROCEDURE Add_To_Attr_If_Not_Null(
   name_  IN     VARCHAR2,
   value_ IN     DATE,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   IF (value_ IS NOT NULL) THEN 
      Add_To_Attr(name_, value_, attr_);
   END IF;
END Add_To_Attr_If_Not_Null;



-- Add_To_Attr_If_Not_Null
--   Adds an attribute name and value at the end of a given
--   attribute record if value is not null.
@UncheckedAccess
PROCEDURE Add_To_Attr_If_Not_Null(
   name_  IN     VARCHAR2,
   value_ IN     TIMESTAMP_UNCONSTRAINED,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   IF (value_ IS NOT NULL) THEN 
      Add_To_Attr(name_, value_, attr_);
   END IF;
END Add_To_Attr_If_Not_Null;


@UncheckedAccess
FUNCTION Remove_Attr (
   name_ IN VARCHAR2,
   attr_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   index1_ NUMBER;
   index2_ NUMBER;

BEGIN
   index1_ := instr(record_separator_||attr_, record_separator_||name_||field_separator_);
   IF (index1_ > 0) THEN
      index2_ := instr(record_separator_||attr_, record_separator_, index1_ + 1, 1);           
      RETURN(substr(attr_,1,index1_-1)||substr(attr_,index2_));
   END IF;
   RETURN(attr_);
END Remove_Attr;


-- Set_Item_Value
--   Set the attribute value for a specific attribute name.
--   If a value already exist, it will be replaced.
@UncheckedAccess
PROCEDURE Set_Item_Value (
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   index1_ NUMBER;
   index2_ NUMBER;
BEGIN
   index1_ := instr(record_separator_||attr_, record_separator_||name_||field_separator_);
   IF (index1_ > 0) THEN
      index2_ := instr(record_separator_||attr_, record_separator_, index1_ + 1, 1);
      IF index1_ = 1 THEN
         attr_ := name_||field_separator_||value_||record_separator_|| substr(attr_, index2_, LENGTH(attr_) - index2_ +1 );
      ELSE
         attr_ := REPLACE(attr_, substr(attr_, index1_-1, index2_ - index1_), record_separator_||name_||field_separator_||value_);
      END IF;
   ELSE
      Add_To_Attr(name_, value_, attr_);
   END IF;
END Set_Item_Value;



-- Set_Item_Value
--   Set the attribute value for a specific attribute name.
--   If a value already exist, it will be replaced.
@UncheckedAccess
PROCEDURE Set_Item_Value (
   name_  IN     VARCHAR2,
   value_ IN     NUMBER,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Set_Item_Value(name_, to_char(value_), attr_);
END Set_Item_Value;



-- Set_Item_Value
--   Set the attribute value for a specific attribute name.
--   If a value already exist, it will be replaced.
@UncheckedAccess
PROCEDURE Set_Item_Value (
   name_  IN     VARCHAR2,
   value_ IN     DATE,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Set_Item_Value(name_, to_char(value_, date_format_), attr_);
END Set_Item_Value;


-- Set_Item_Value
--   Set the attribute value for a specific attribute name.
--   If a value already exist, it will be replaced.
@UncheckedAccess
PROCEDURE Set_Item_Value (
   name_  IN     VARCHAR2,
   value_ IN     TIMESTAMP_UNCONSTRAINED,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   Set_Item_Value(name_, to_char(value_, timestamp_format_), attr_);
END Set_Item_Value;


-- Get_Next_From_Attr
--   Fetches the next attribute name and value value from given attribute
--   record. NOTE! Value is always of type VARCHAR2.
@UncheckedAccess
FUNCTION Get_Next_From_Attr (
   attr_  IN     VARCHAR2,
   ptr_   IN OUT NUMBER,
   name_  IN OUT VARCHAR2,
   value_ IN OUT VARCHAR2 ) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
BEGIN
   from_ := nvl(ptr_, 1);
   to_   := instr(attr_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := instr(attr_, field_separator_, from_);
      name_  := substr(attr_, from_, index_-from_);
      value_ := substr(attr_, index_+1, to_-index_-1);
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr;



-- Attr_Value_To_Date
--   Converts a VARCHAR2 value to a DATE value according to client
--   protocol rules.
@UncheckedAccess
FUNCTION Attr_Value_To_Date (
   value_             IN VARCHAR2,
   raise_value_error_ IN BOOLEAN DEFAULT TRUE ) RETURN DATE
IS
BEGIN
   RETURN(to_date(value_, date_format_));
EXCEPTION
   WHEN OTHERS THEN
      IF raise_value_error_ THEN
         RAISE value_error;
      ELSE
         RAISE;
      END IF;
END Attr_Value_To_Date;



-- Attr_Value_To_Date
--   Converts a VARCHAR2 value to a TIMESTAMP value according to client
--   protocol rules.
@UncheckedAccess
FUNCTION Attr_Value_To_Timestamp (
   value_             IN VARCHAR2,
   raise_value_error_ IN BOOLEAN DEFAULT TRUE ) RETURN TIMESTAMP_UNCONSTRAINED
IS
BEGIN
   RETURN(to_timestamp(value_, timestamp_format_));
EXCEPTION
   WHEN OTHERS THEN
      IF raise_value_error_ THEN
         RAISE value_error;
      ELSE
         RAISE;
      END IF;
END Attr_Value_To_Timestamp;

-- Attr_Value_To_Number
--   Converts a VARCHAR2 value to a NUMBER value according to client
--   protocol rules.
@UncheckedAccess
FUNCTION Attr_Value_To_Number (
   value_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN(to_number(value_));
END Attr_Value_To_Number;

-- Attr_Value_To_Integer
--   Converts a VARCHAR2 value to an INTEGER value according to client
--   protocol rules.
@UncheckedAccess
FUNCTION Attr_Value_To_Integer (
   value_ IN VARCHAR2 ) RETURN INTEGER
IS
   num_value_ NUMBER;
BEGIN
   num_value_ := to_number(value_);
   IF(num_value_ != trunc(num_value_)) THEN
      RAISE value_error;
   END IF;
   RETURN num_value_;
END Attr_Value_To_Integer;



@UncheckedAccess
FUNCTION Cut_Item_Value (
   name_ IN     VARCHAR2,
   attr_ IN OUT VARCHAR2 ) RETURN VARCHAR2
IS
   value_   VARCHAR2(32000);
BEGIN
   value_ := Get_Item_Value(name_, attr_);
   attr_ := Remove_Attr(name_, attr_);
   RETURN(value_);
END Cut_Item_Value;



@UncheckedAccess
FUNCTION Get_Item_Value (
   name_ IN VARCHAR2,
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   from_ NUMBER;
   len_  NUMBER;
   to_   NUMBER;
BEGIN
   len_ := length(name_);
   from_ := instr(record_separator_ || attr_, record_separator_ || name_ || field_separator_);
   IF (from_ > 0) THEN
      to_ := instr(attr_, record_separator_, from_ + 1);
      IF (to_ > 0) THEN
         RETURN (substr(attr_, from_ + len_ + 1, to_ - from_ - len_ - 1));
      END IF;
   END IF;
   RETURN (NULL);
END Get_Item_Value;



@UncheckedAccess
FUNCTION Get_Item_Value_To_Date (
   name_      IN VARCHAR2,
   attr_      IN VARCHAR2,
   lu_name_   IN VARCHAR2,
   method_    IN VARCHAR2 DEFAULT NULL) RETURN DATE   
IS
   value_     VARCHAR2(32000);
BEGIN  
   value_ := Get_Item_Value(name_, attr_);
   RETURN(Attr_Value_To_Date(value_));
EXCEPTION
   WHEN value_error THEN
      IF (method_ IS NULL) THEN
         Error_SYS.Item_Format(lu_name_, name_, value_);
      ELSE
         Error_SYS.Item_Format(lu_name_, name_, value_, 'ITEM_VALUE_ERROR: Value error in method :P1 for attribute :P2.', method_, name_);
      END IF;
END Get_Item_Value_To_Date;


@UncheckedAccess
FUNCTION Get_Item_Value_To_Timestamp (
   name_      IN VARCHAR2,
   attr_      IN VARCHAR2,
   lu_name_   IN VARCHAR2,
   method_    IN VARCHAR2 DEFAULT NULL) RETURN TIMESTAMP_UNCONSTRAINED   
IS
   value_     VARCHAR2(32000);
BEGIN  
   value_ := Get_Item_Value(name_, attr_);
   RETURN(Attr_Value_To_Timestamp(value_));
EXCEPTION
   WHEN value_error THEN
      IF (method_ IS NULL) THEN
         Error_SYS.Item_Format(lu_name_, name_, value_);
      ELSE
         Error_SYS.Item_Format(lu_name_, name_, value_, 'ITEM_VALUE_ERROR: Value error in method :P1 for attribute :P2.', method_, name_);
      END IF;
END Get_Item_Value_To_Timestamp;


@UncheckedAccess
FUNCTION Get_Item_Value_To_Number (
   name_      IN VARCHAR2,
   attr_      IN VARCHAR2,
   lu_name_   IN VARCHAR2,
   method_    IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   value_     VARCHAR2(32000);
BEGIN  
   value_ := Get_Item_Value(name_, attr_);
   RETURN(Attr_Value_To_Number(value_));
EXCEPTION
   WHEN value_error THEN
      IF (method_ IS NULL) THEN
         Error_SYS.Item_Format(lu_name_, name_, value_);
      ELSE
         Error_SYS.Item_Format(lu_name_, name_, value_, 'ITEM_VALUE_ERROR: Value error in method :P1 for attribute :P2.', method_, name_);
      END IF;
END Get_Item_Value_To_Number;


@UncheckedAccess
FUNCTION Get_Item_Value_To_Integer (
   name_      IN VARCHAR2,
   attr_      IN VARCHAR2,
   lu_name_   IN VARCHAR2,
   method_    IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   value_     VARCHAR2(32000);
BEGIN  
   value_ := Get_Item_Value(name_, attr_);
   RETURN(Attr_Value_To_Integer(value_));
EXCEPTION
   WHEN value_error THEN
      IF (method_ IS NULL) THEN
         Error_SYS.Item_Format(lu_name_, name_, value_);
      ELSE
         Error_SYS.Item_Format(lu_name_, name_, value_, 'ITEM_VALUE_ERROR: Value error in method :P1 for attribute :P2.', method_, name_);
      END IF;
END Get_Item_Value_To_Integer;


@UncheckedAccess
FUNCTION Item_Exist (
   name_ IN VARCHAR2,
   attr_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   from_ NUMBER;
   len_  NUMBER;
BEGIN
   len_ := length(name_);
   from_ := instr(record_separator_ || attr_, record_separator_ || name_ || field_separator_);
   IF (from_ > 0) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Item_Exist;



-- Attr_To_Dbms_Output
--   Copies attrtibute string contents to DBMS_OUTPUT.PUT_LINE calls
--   so that contents can be investigated for debug purposes.
@UncheckedAccess
PROCEDURE Attr_To_Dbms_Output (
   attr_ IN VARCHAR2 )
IS
   ptr_     NUMBER;
   name_    VARCHAR2(30);
   value_   VARCHAR2(32767);
   len_     NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE Get_Next_From_Attr(attr_, ptr_, name_, value_) LOOP
      len_ := length(name_)+3+length(value_);
      IF (len_ > 255) THEN
         Log_SYS.Fnd_Trace_(Log_SYS.trace_, name_||'='||
            substr(value_,1,250-length(name_))||' ...');
      ELSE
         Log_SYS.Fnd_Trace_(Log_SYS.trace_, name_||'='||value_);
      END IF;
   END LOOP;
END Attr_To_Dbms_Output;


-- Clear_List
--   Clears a given attribute record (e.g. nullifies it).
--   Must be called before any calls to Add_To_Attr function.
@UncheckedAccess
PROCEDURE Clear_List (
   list_ OUT VARCHAR2 )
IS
BEGIN
   list_ := NULL;
END Clear_List;


-- Add_To_List
--   Adds a value at the end of a given list.
@UncheckedAccess
PROCEDURE Add_To_List (
   value_ IN     VARCHAR2,
   list_  IN OUT VARCHAR2 )
IS
BEGIN
   list_ := list_||value_||record_separator_;
END Add_To_List;


-- Add_To_List
--   Adds a value at the end of a given list.
@UncheckedAccess
PROCEDURE Add_To_List (
   value_ IN     NUMBER,
   list_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_List(to_char(value_), list_);
END Add_To_List;


-- Add_To_List
--   Adds a value at the end of a given list.
@UncheckedAccess
PROCEDURE Add_To_List(
   value_ IN     DATE,
   list_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_List(to_char(value_, date_format_), list_);
END Add_To_List;


-- Add_To_List
--   Adds a value at the end of a given list.
@UncheckedAccess
PROCEDURE Add_To_List(
   value_ IN     TIMESTAMP_UNCONSTRAINED,
   list_  IN OUT VARCHAR2 )
IS
BEGIN
   Add_To_List(to_char(value_, timestamp_format_), list_);
END Add_To_List;

-- Get_Next_From_List
--   Fetches the next value from the given list.
--   NOTE! Value is always of type VARCHAR2.
@UncheckedAccess
FUNCTION Get_Next_From_List (
   list_  IN     VARCHAR2,
   ptr_   IN OUT NOCOPY NUMBER,
   value_ IN OUT NOCOPY VARCHAR2 ) RETURN BOOLEAN
IS
   from_ NUMBER := nvl(ptr_, 1);
   to_   NUMBER;
BEGIN
   to_ := instr(list_, record_separator_, from_);
   IF (to_ > 0) THEN
      value_ := substr(list_, from_, to_-from_);
      ptr_   := to_+1;
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Get_Next_From_List;


-- Get_Next_From_Selection
--   Fetches the next key reference from the given selection.
--   NOTE! Use Get_Key_Reference_Value for retrieving the value for a specific key from the given key reference.
@UncheckedAccess
FUNCTION Get_Next_From_Selection (
   selection_ IN     VARCHAR2,
   ptr_       IN OUT NOCOPY NUMBER,
   key_ref_   IN OUT NOCOPY VARCHAR2 ) RETURN BOOLEAN
IS
   from_ NUMBER := nvl(ptr_, 1);
   to_   NUMBER;
BEGIN
   to_ := instr(selection_, ';', from_);
   IF (to_ > 0) THEN
      key_ref_ := substr(selection_, from_, to_-from_);
      ptr_   := to_+1;
      RETURN TRUE;
   ELSIF (length(selection_) > from_) THEN
      key_ref_ := substr(selection_, from_);
      ptr_   := length(selection_);
      RETURN TRUE;
   ELSE
      key_ref_ := NULL;
      RETURN FALSE;
   END IF;   
END Get_Next_From_Selection;


-- Get_Key_Reference
--   Return a formatted "Key Reference" string.
@UncheckedAccess
PROCEDURE Get_Key_Reference (
   key_ref_ OUT VARCHAR2,
   lu_name_ IN VARCHAR2,
   objid_ IN VARCHAR2 DEFAULT NULL )
IS
   c1_           NUMBER;
   ignore_       NUMBER;
   stmt_         VARCHAR2(2000);
   view_         VARCHAR2(30);
   temp_key_ref_ VARCHAR2(32000);
   sql_column_   VARCHAR2(32000);
   --
   -- Cursor to fetch key dictionary information
   --
   --SOLSETFW
   CURSOR get_key_info IS
      SELECT column_name, column_datatype, enumeration
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      AND    type_flag IN ('P', 'K')
      ORDER BY column_name;

BEGIN
   key_ref_ := NULL;
   view_    := Dictionary_SYS.Get_Base_View(lu_name_);
   -- By now we should be having a valid view name
   IF ( view_ IS NOT NULL ) THEN
      --
      -- View found, fetch the keys!
      --
      sql_column_ := '''';
      FOR keyrec IN get_key_info LOOP
         temp_key_ref_ := temp_key_ref_||keyrec.column_name||'='||text_separator_;
         IF keyrec.column_datatype NOT LIKE 'DATE%' THEN
            IF (keyrec.enumeration IS NOT NULL) THEN 
               sql_column_ := sql_column_||keyrec.column_name||'_DB=''||'||keyrec.column_name||'_DB||''^';
            ELSE 
               sql_column_ := sql_column_||keyrec.column_name||'=''||'||keyrec.column_name||'||''^';
            END IF;
         ELSE
            sql_column_   := sql_column_||keyrec.column_name||'=''||to_char('||keyrec.column_name||','''||date_format_||''')||''^';
         END IF;
      END LOOP;
      key_ref_ := temp_key_ref_;
      temp_key_ref_ := NULL;
      IF (objid_ IS NOT NULL) THEN
         --
         -- Fetch instance key information by using dynamic SQL
         -- Return a text separated list of values
               --
         BEGIN
            Assert_SYS.Assert_Is_View(view_);
            stmt_ := 'SELECT '||sql_column_||''' FROM '||view_||' WHERE OBJID = :objid';
            c1_ := dbms_sql.open_cursor;
            @ApproveDynamicStatement(2006-01-05,utgulk)
            dbms_sql.parse(c1_, stmt_, dbms_sql.native);
            dbms_sql.bind_variable(c1_,':objid',objid_);
            dbms_sql.define_column(c1_, 1, temp_key_ref_, 20000);
            ignore_ := dbms_sql.execute(c1_);
            IF (dbms_sql.fetch_rows(c1_) > 0) THEN
               dbms_sql.column_value(c1_, 1, temp_key_ref_);
            END IF;
            dbms_sql.close_cursor(c1_);
         EXCEPTION
            WHEN OTHERS THEN
               IF (dbms_sql.is_open(c1_)) THEN
                  dbms_sql.close_cursor(c1_);
               END IF;
               NULL;
         END;
         IF (temp_key_ref_ IS NOT NULL) THEN
            key_ref_ := temp_key_ref_;
         END IF;
      END IF;
      -- Convert client values to database values
      --key_ref_ := Object_Connection_SYS.Replace_Client_Values ( lu_name_, key_ref_ );
   END IF;
END Get_Key_Reference;

-- Convert_Key_Ref_To_Tab_Keys
--   Convert the Key Reference which is based on the view to a Key Ref based on the table columns.
@UncheckedAccess
FUNCTION Convert_Key_Ref_To_Tab_Keys (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2) RETURN VARCHAR2
IS
   base_view_name_  VARCHAR2(128);
   keys_            Object_Connection_SYS.key_ref;
   key_count_       NUMBER;
   new_key_ref_     VARCHAR2(32000);
   --SOLSETFW
   CURSOR get_columns IS
      SELECT view_name, column_name, enumeration, table_column_name
        FROM dictionary_sys_view_column_act
       WHERE view_name = base_view_name_;
         --AND (type_flag IN ('P','K') OR enumeration IS NOT NULL OR table_column_name IS NOT NULL);
   
   TYPE cols_tab IS TABLE OF get_columns%ROWTYPE;
   col_ get_columns%ROWTYPE;
   cols_ cols_tab;
   
   FUNCTION Find___ (column_name_ IN VARCHAR2, cols_ cols_tab) RETURN get_columns%ROWTYPE
   IS
   BEGIN
      FOR i_ IN 1..cols_.COUNT LOOP
         IF cols_(i_).column_name = column_name_ THEN
            RETURN cols_(i_);
         END IF;
      END LOOP;
      RETURN NULL;
   END;
BEGIN
   base_view_name_  := Dictionary_SYS.Get_Base_View(lu_name_);
   Object_Connection_SYS.Tokenize_Key_Ref__ (key_ref_, keys_, key_count_);
   
   OPEN get_columns;
   FETCH get_columns BULK COLLECT INTO cols_;
   CLOSE get_columns;
   
   FOR i_ IN 1..keys_.COUNT LOOP
      -- Special handling for IID
      col_ := NULL;
      IF keys_(i_).NAME LIKE '%/_DB' ESCAPE '/' THEN
         col_ := Find___(SUBSTR(keys_(i_).NAME, 1, length(keys_(i_).NAME)-3), cols_);
         -- IF NULL then this is a IID
      END IF;
      
      IF col_.column_name IS NULL THEN
         col_ := Find___(keys_(i_).NAME, cols_);
      END IF;
      
      IF col_.column_name IS NOT NULL THEN
         IF keys_(i_).NAME LIKE '%/_DB' ESCAPE '/' AND col_.enumeration IS NOT NULL THEN
            keys_(i_).NAME := SUBSTR(keys_(i_).NAME, 1, length(keys_(i_).NAME)-3);
         ELSIF col_.table_column_name IS NOT NULL THEN
            keys_(i_).NAME := col_.table_column_name;
         END IF;
      END IF;
      new_key_ref_ := new_key_ref_ || keys_(i_).NAME || '=' || keys_(i_).VALUE ||'^';
   END LOOP;
   RETURN new_key_ref_;
END Convert_Key_Ref_To_Tab_Keys;

-- Get_New_Key_Reference
--   Return a newly formatted "Key Reference" string based on the old string. 
--   The old string need to point to the new column names, if columns have been renamed
@UncheckedAccess
FUNCTION Get_New_Key_Reference (
   lu_name_     IN VARCHAR2,
   old_key_ref_ IN VARCHAR2,
   use_binary_ai_sort_        IN BOOLEAN DEFAULT FALSE,
   for_enum_use_table_column_ IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
   base_table_name_     VARCHAR2(128);
   base_view_name_      VARCHAR2(128);
   keys_                Object_Connection_SYS.key_ref;
   --key_cols_          Utility_SYS.STRING_TABLE;
   key_count_           NUMBER;
   new_key_ref_         VARCHAR2(32000);
   sql_col_string_      VARCHAR2(32000);
   tab_key_ref_string_  VARCHAR2(32000);
   tab_key_ref_         Object_Connection_SYS.key_ref;
   tab_key_count_       NUMBER;
   dummy_               NUMBER;
   data_cursor_         NUMBER;
   stmt_                VARCHAR2(32000);   
BEGIN
   base_table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   base_view_name_  := Dictionary_SYS.Get_Base_View(lu_name_);
   
   Object_Connection_SYS.Tokenize_Key_Ref__(old_key_ref_, keys_, key_count_);
   Get_Key_Ref_Info___(new_key_ref_, sql_col_string_, base_view_name_, TRUE,use_binary_ai_sort_,for_enum_use_table_column_);
   
   tab_key_ref_string_ := Convert_Key_Ref_To_Tab_Keys(lu_name_, old_key_ref_);
   Object_Connection_SYS.Tokenize_Key_Ref__(tab_key_ref_string_, tab_key_ref_, tab_key_count_);
   
   BEGIN
      stmt_ := 'SELECT '||sql_col_string_||' FROM '||base_table_name_||' WHERE ';
      
      FOR key_counter_ IN 1..tab_key_count_ LOOP
         Assert_SYS.Assert_Is_Table_Column(base_table_name_ , tab_key_ref_(key_counter_).NAME );
         stmt_ := stmt_ || tab_key_ref_(key_counter_).NAME || ' = :bindvar' || key_counter_; -- NAME = :bindvarX

         IF key_counter_ < tab_key_count_ THEN
            stmt_ := stmt_ || ' AND ';
         END IF;
      END LOOP;
      
      data_cursor_ := dbms_sql.open_cursor;
      --safe due to Assert_SYS.Assert_Is_Table_Column check
      @ApproveDynamicStatement(2017-11-15,chmulk)
      dbms_sql.parse (data_cursor_, stmt_, dbms_sql.native);

      -- Bind variables
      FOR key_counter_ IN 1..tab_key_count_ LOOP
         dbms_sql.bind_variable(data_cursor_, 'bindvar' || key_counter_, tab_key_ref_(key_counter_).VALUE);
      END LOOP;

      dbms_sql.define_column(data_cursor_, 1, new_key_ref_, 3200);
      dummy_ := dbms_sql.execute(data_cursor_);
      dummy_ := dbms_sql.fetch_rows(data_cursor_);

      dbms_sql.column_value(data_cursor_, 1, new_key_ref_);

      -- Close the cursor
      dbms_sql.close_cursor(data_cursor_);
   EXCEPTION
      WHEN OTHERS THEN
         IF (dbms_sql.is_open(data_cursor_)) THEN
            dbms_sql.close_cursor(data_cursor_);
         END IF;
         Log_SYS.App_Trace(Log_SYS.error_, 'Error in generating key ref '||SQLERRM);
   END;
   -- if the relevant referenced record cannot be found will return the old key ref   
   IF dummy_ > 0 THEN
      RETURN new_key_ref_;
   ELSE
      RETURN old_key_ref_;
   END IF;
END Get_New_Key_Reference;

@UncheckedAccess
PROCEDURE Get_Table_Key_Reference (
   key_ref_ OUT VARCHAR2,
   lu_name_ IN VARCHAR2 )
IS
   view_         VARCHAR2(30);
   temp_key_ref_ VARCHAR2(32000);
   CURSOR check_view (view_name_ VARCHAR2) IS
      SELECT view_name
      FROM   user_views
      WHERE  view_name = view_name_;
   --SOLSETFW
   CURSOR get_key_info (view_ VARCHAR2) IS
   SELECT column_name,table_column_name
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      AND    type_flag IN ('P', 'K')
      ORDER BY column_name;
   table_ VARCHAR2(100);
BEGIN
   key_ref_ := NULL;
   --get base table and view
   view_    := Dictionary_SYS.Get_Base_View(lu_name_);
   table_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   IF ( view_ IS NOT NULL ) THEN
      OPEN  check_view (lu_name_);
      FETCH check_view INTO view_;
      CLOSE check_view;
   END IF;

   IF ( view_ IS NOT NULL ) THEN
      FOR keyrec IN get_key_info(view_) LOOP
         --IF a table column name is given for the view column, check if that column exists in the base table first
         IF (keyrec.table_column_name IS NOT NULL AND table_ IS NOT NULL AND Database_SYS.Column_Exist(table_, keyrec.table_column_name)) THEN
            --column exists in base table
            temp_key_ref_ := temp_key_ref_||UPPER(keyrec.table_column_name)||'='||text_separator_;
         ELSE
            temp_key_ref_ := temp_key_ref_||keyrec.column_name||'='||text_separator_;
         END IF;
      END LOOP;
      key_ref_ := temp_key_ref_;
      key_ref_ := Object_Connection_SYS.Replace_Client_Values ( lu_name_, key_ref_ );
   END IF;
END Get_Table_Key_Reference;

@UncheckedAccess
FUNCTION Get_Key_Reference_From_Objkey (
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   c1_           NUMBER;
   ignore_       NUMBER;
   stmt_         VARCHAR2(2000);
   view_         VARCHAR2(30);
   temp_key_ref_ VARCHAR2(32000);
   sql_column_   VARCHAR2(2000);
   --
   -- Cursor to fetch key dictionary information
   --
   --SOLSETFW
   CURSOR get_key_info IS
      SELECT column_name, column_datatype, enumeration
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      AND    type_flag IN ('P', 'K')
      ORDER BY column_name;
   key_ref_ VARCHAR2(32000);
   objkey_col_ VARCHAR2(30);
BEGIN
   key_ref_ := NULL;
   view_    := Dictionary_SYS.Get_Base_View(lu_name_);
   objkey_col_ := NVL(Dictionary_SYS.Get_Objkey_Info(lu_name_, TRUE), 'OBJKEY');
   -- By now we should be having a valid view name
   IF ( view_ IS NOT NULL ) THEN
      --
      -- View found, fetch the keys!
      --
      sql_column_ := '''';
      FOR keyrec IN get_key_info LOOP
         IF keyrec.column_datatype LIKE 'DATE%' THEN
            sql_column_   := sql_column_||keyrec.column_name||'=''||to_char('||keyrec.column_name||','''||date_format_||''')||''^';
            temp_key_ref_ := temp_key_ref_||keyrec.column_name||'='||text_separator_;
         ELSE
            IF (keyrec.enumeration IS NOT NULL) THEN 
               sql_column_ := sql_column_||keyrec.column_name||'_DB=''||'||keyrec.column_name||'_DB||''^';
               temp_key_ref_ := temp_key_ref_||keyrec.column_name||'_DB='||text_separator_;
            ELSE 
               sql_column_ := sql_column_||keyrec.column_name||'=''||'||keyrec.column_name||'||''^';
               temp_key_ref_ := temp_key_ref_||keyrec.column_name||'='||text_separator_;
            END IF;
         END IF;
      END LOOP;
      key_ref_ := temp_key_ref_;
      temp_key_ref_ := NULL;
      IF (objkey_ IS NOT NULL) THEN
         --
         -- Fetch instance key information by using dynamic SQL
         -- Return a text separated list of values
               --
         BEGIN
            Assert_SYS.Assert_Is_View(view_);
            stmt_ := 'SELECT '||sql_column_||''' FROM '||view_||' WHERE '||objkey_col_||' = :objkey';
            c1_ := dbms_sql.open_cursor;
            @ApproveDynamicStatement(2006-01-05,utgulk)
            dbms_sql.parse(c1_, stmt_, dbms_sql.native);
            dbms_sql.bind_variable(c1_,':objkey',objkey_);
            dbms_sql.define_column(c1_, 1, temp_key_ref_, 20000);
            ignore_ := dbms_sql.execute(c1_);
            IF (dbms_sql.fetch_rows(c1_) > 0) THEN
               dbms_sql.column_value(c1_, 1, temp_key_ref_);
            END IF;
            dbms_sql.close_cursor(c1_);
         EXCEPTION
            WHEN OTHERS THEN
               IF (dbms_sql.is_open(c1_)) THEN
                  dbms_sql.close_cursor(c1_);
               END IF;
               NULL;
         END;
         IF (temp_key_ref_ IS NOT NULL) THEN
            key_ref_ := temp_key_ref_;
         END IF;
      END IF;
      -- Convert client values to database values
      --key_ref_ := Object_Connection_SYS.Replace_Client_Values ( lu_name_, key_ref_ );
   END IF;
   RETURN key_ref_;
END Get_Key_Reference_From_Objkey;


-- Get_Key_Reference
--   Return a formatted "Key Reference" string.
@UncheckedAccess
FUNCTION Get_Key_Reference (
   lu_name_ IN VARCHAR2,
   key1_    IN VARCHAR2,
   value1_  IN VARCHAR2,
   key2_    IN VARCHAR2 DEFAULT NULL,
   value2_  IN VARCHAR2 DEFAULT NULL,
   key3_    IN VARCHAR2 DEFAULT NULL,
   value3_  IN VARCHAR2 DEFAULT NULL,
   key4_    IN VARCHAR2 DEFAULT NULL,
   value4_  IN VARCHAR2 DEFAULT NULL,
   key5_    IN VARCHAR2 DEFAULT NULL,
   value5_  IN VARCHAR2 DEFAULT NULL,
   key6_    IN VARCHAR2 DEFAULT NULL,
   value6_  IN VARCHAR2 DEFAULT NULL,
   key7_    IN VARCHAR2 DEFAULT NULL,
   value7_  IN VARCHAR2 DEFAULT NULL,
   key8_    IN VARCHAR2 DEFAULT NULL,
   value8_  IN VARCHAR2 DEFAULT NULL,
   key9_    IN VARCHAR2 DEFAULT NULL,
   value9_  IN VARCHAR2 DEFAULT NULL,
   key10_   IN VARCHAR2 DEFAULT NULL,
   value10_ IN VARCHAR2 DEFAULT NULL,
   key11_   IN VARCHAR2 DEFAULT NULL,
   value11_ IN VARCHAR2 DEFAULT NULL,
   key12_   IN VARCHAR2 DEFAULT NULL,
   value12_ IN VARCHAR2 DEFAULT NULL,
   key13_   IN VARCHAR2 DEFAULT NULL,
   value13_ IN VARCHAR2 DEFAULT NULL,
   key14_   IN VARCHAR2 DEFAULT NULL,
   value14_ IN VARCHAR2 DEFAULT NULL,
   key15_   IN VARCHAR2 DEFAULT NULL,
   value15_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE keytab_type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   keytab_    keytab_type;
   valtab_    keytab_type;
   temp_      VARCHAR2(2000);
   count_     NUMBER;
   temp_key_ref_ VARCHAR2(32000);
BEGIN
   --
   -- Fill parameter values into the table structure
   --
   count_ := 1;
   keytab_(count_) := key1_;
   valtab_(count_) := value1_;
   IF (key2_ IS NOT NULL) THEN
      count_ := 2;
      keytab_(count_) := key2_;
      valtab_(count_) := value2_;
   END IF;
   IF (key3_ IS NOT NULL) THEN
      count_ := 3;
      keytab_(count_) := key3_;
      valtab_(count_) := value3_;
   END IF;
   IF (key4_ IS NOT NULL) THEN
      count_ := 4;
      keytab_(count_) := key4_;
      valtab_(count_) := value4_;
   END IF;
   IF (key5_ IS NOT NULL) THEN
      count_ := 5;
      keytab_(count_) := key5_;
      valtab_(count_) := value5_;
   END IF;
   IF (key6_ IS NOT NULL) THEN
      count_ := 6;
      keytab_(count_) := key6_;
      valtab_(count_) := value6_;
   END IF;
   IF (key7_ IS NOT NULL) THEN
      count_ := 7;
      keytab_(count_) := key7_;
      valtab_(count_) := value7_;
   END IF;
   IF (key8_ IS NOT NULL) THEN
      count_ := 8;
      keytab_(count_) := key8_;
      valtab_(count_) := value8_;
   END IF;
   IF (key9_ IS NOT NULL) THEN
      count_ := 9;
      keytab_(count_) := key9_;
      valtab_(count_) := value9_;
   END IF;
   IF (key10_ IS NOT NULL) THEN
      count_ := 10;
      keytab_(count_) := key10_;
      valtab_(count_) := value10_;
   END IF;
   IF (key11_ IS NOT NULL) THEN
      count_ := 11;
      keytab_(count_) := key11_;
      valtab_(count_) := value11_;
   END IF;
   IF (key12_ IS NOT NULL) THEN
      count_ := 12;
      keytab_(count_) := key12_;
      valtab_(count_) := value12_;
   END IF;
   IF (key13_ IS NOT NULL) THEN
      count_ := 13;
      keytab_(count_) := key13_;
      valtab_(count_) := value13_;
   END IF;
   IF (key14_ IS NOT NULL) THEN
      count_ := 14;
      keytab_(count_) := key14_;
      valtab_(count_) := value14_;
   END IF;
   IF (key15_ IS NOT NULL) THEN
      count_ := 15;
      keytab_(count_) := key15_;
      valtab_(count_) := value15_;
   END IF;
   --
   -- Sort by using 'bubble sort' algorithm
   --
   FOR n IN 1..count_-1 LOOP
      FOR m IN REVERSE n+1..count_ LOOP
         IF (keytab_(m) < keytab_(m-1)) THEN
            temp_ := keytab_(m);
            keytab_(m) := keytab_(m-1);
            keytab_(m-1) := temp_;
            temp_ := valtab_(m);
            valtab_(m) := valtab_(m-1);
            valtab_(m-1) := temp_;
         END IF;
      END LOOP;
   END LOOP;
   --
   -- Create the sorted key reference list
   --
   temp_key_ref_ := NULL;
   FOR n IN 1..count_ LOOP
      temp_key_ref_ := temp_key_ref_||keytab_(n)||'='||valtab_(n)||text_separator_;
   END LOOP;
   RETURN(temp_key_ref_);
END Get_Key_Reference;

FUNCTION Get_Objkey_From_Key_Ref (
   lu_name_   IN VARCHAR2,
   key_ref_   IN VARCHAR2,
   view_name_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   keys_       Utility_SYS.STRING_TABLE;
   key_count_  NUMBER;
   stmt_       VARCHAR2(32000);
   view_       VARCHAR2(128);
   objkey_     VARCHAR2(4000);
   key_column_ VARCHAR2(128);
   value_delimeter_pos_ NUMBER;
   bind_values_ Utility_SYS.STRING_TABLE;
   cursor_     NUMBER;
   ignore_     NUMBER;
   
   TYPE column_data_types IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(128);
   column_data_type_tab_ column_data_types;
BEGIN
   IF NVL(Dictionary_SYS.Get_Objkey_Info(lu_name_), 'GUID') = 'NONE' THEN
      Error_SYS.Appl_General(Client_SYS.lu_name_, 'NO_ROWKEY: Rowkey not available for LU :P1', lu_name_);
   END IF;
   IF view_name_ IS NOT NULL THEN
      view_ := view_name_;
   ELSE
      view_ := Dictionary_SYS.Get_Base_View(lu_name_);
   END IF;
   Assert_SYS.Assert_Is_View(view_);
   
   FOR rec_ IN (SELECT column_name, data_type FROM user_tab_columns WHERE table_name = view_) LOOP
      column_data_type_tab_(rec_.column_name) := rec_.data_type;
   END LOOP;
   stmt_ := 'SELECT OBJKEY FROM '||view_ ||' WHERE ';     
   Utility_SYS.Tokenize(key_ref_, '^', keys_, key_count_);
   
   FOR i_ IN 1..key_count_ LOOP
      value_delimeter_pos_ := INSTR(keys_(i_), '=');
      key_column_ := SUBSTR(keys_(i_), 1, value_delimeter_pos_ -1);
      IF i_ > 1 THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
      bind_values_(i_) := SUBSTR(keys_(i_), value_delimeter_pos_ +1);
      IF column_data_type_tab_(key_column_) = 'DATE' THEN
         stmt_ := stmt_ || key_column_ || ' = TO_DATE(:B'||i_ || ', '''||Client_SYS.date_format_||''') ';
      ELSE
         stmt_ := stmt_ || key_column_ || ' = :B'||i_ || ' ';
      END IF;  
   END LOOP;   
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'STMT='|| stmt_);
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2017-08-23,chmulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.define_column(cursor_, 1, objkey_, 2000);
   FOR i_ IN 1..key_count_ LOOP
      dbms_sql.bind_variable(cursor_, ':B'||i_, bind_values_(i_));
   END LOOP;
   --fetch should return only one row
   ignore_ := dbms_sql.execute_and_fetch(cursor_, TRUE);
   dbms_sql.column_value(cursor_, 1, objkey_);
   dbms_sql.close_cursor(cursor_);
   RETURN objkey_;
EXCEPTION
   WHEN no_data_found THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RETURN NULL;
   WHEN OTHERS THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Get_Objkey_From_Key_Ref;
   
FUNCTION Get_Rowkey_From_Key_Ref (
   lu_name_   IN VARCHAR2,
   key_ref_   IN VARCHAR2) RETURN VARCHAR2
IS
   keys_       Utility_SYS.STRING_TABLE;
   key_count_  NUMBER;
   stmt_       VARCHAR2(32000);
   table_      VARCHAR2(128);
   objkey_     VARCHAR2(4000);
   key_column_ VARCHAR2(128);
   value_delimeter_pos_ NUMBER;
   bind_values_ Utility_SYS.STRING_TABLE;
   cursor_     NUMBER;
   ignore_     NUMBER;
   table_key_ref_ VARCHAR2(32000);
   
   TYPE column_data_types IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(128);
   column_data_type_tab_ column_data_types;
BEGIN
   IF NVL(Dictionary_SYS.Get_Objkey_Info(lu_name_), 'GUID') = 'NONE' THEN
      Error_SYS.Appl_General(Client_SYS.lu_name_, 'NO_ROWKEY: Rowkey not available for LU :P1', lu_name_);
   END IF;
   
   table_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);

   table_key_ref_ := Convert_Key_Ref_To_Tab_Keys(lu_name_, key_ref_);

   FOR rec_ IN (SELECT column_name, data_type FROM user_tab_columns WHERE table_name = table_) LOOP
      column_data_type_tab_(rec_.column_name) := rec_.data_type;
   END LOOP;

   stmt_ := 'SELECT ROWKEY FROM '||table_ ||' WHERE ';     
   Utility_SYS.Tokenize(table_key_ref_, '^', keys_, key_count_);

   FOR i_ IN 1..key_count_ LOOP
      value_delimeter_pos_ := INSTR(keys_(i_), '=');
      key_column_ := SUBSTR(keys_(i_), 1, value_delimeter_pos_ -1);
      IF i_ > 1 THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
      bind_values_(i_) := SUBSTR(keys_(i_), value_delimeter_pos_ +1);
      
      IF column_data_type_tab_(key_column_) = 'DATE' THEN
         stmt_ := stmt_ || key_column_ || ' = TO_DATE(:B'||i_ || ', '''||Client_SYS.date_format_||''') ';
      ELSE
         stmt_ := stmt_ || key_column_ || ' = :B'||i_ || ' ';
      END IF;
      
   END LOOP;   
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'STMT='|| stmt_);
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2017-08-23,chmulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.define_column(cursor_, 1, objkey_, 2000);
   FOR i_ IN 1..key_count_ LOOP
      dbms_sql.bind_variable(cursor_, ':B'||i_, bind_values_(i_));
   END LOOP;
   --fetch should return only one row
   ignore_ := dbms_sql.execute_and_fetch(cursor_, TRUE);
   dbms_sql.column_value(cursor_, 1, objkey_);
   dbms_sql.close_cursor(cursor_);
   RETURN objkey_;
EXCEPTION
   WHEN no_data_found THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RETURN NULL;
   WHEN OTHERS THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Get_Rowkey_From_Key_Ref;   

-- Add_To_Key_Reference
--   Adds a key column with value to the key reference list.
@UncheckedAccess
PROCEDURE Add_To_Key_Reference (
   key_ref_ IN OUT VARCHAR2,
   name_    IN     VARCHAR2,
   value_   IN     VARCHAR2 )
IS
BEGIN
   key_ref_ := key_ref_||name_||'='||value_||text_separator_;
END Add_To_Key_Reference;



-- Add_To_Key_Reference
--   Adds a key column with value to the key reference list.
@UncheckedAccess
PROCEDURE Add_To_Key_Reference (
   key_ref_ IN OUT VARCHAR2,
   name_    IN     VARCHAR2,
   value_   IN     NUMBER )
IS
BEGIN
   Add_To_Key_Reference(key_ref_, name_, to_char(value_));
END Add_To_Key_Reference;



-- Add_To_Key_Reference
--   Adds a key column with value to the key reference list.
@UncheckedAccess
PROCEDURE Add_To_Key_Reference (
   key_ref_ IN OUT VARCHAR2,
   name_    IN     VARCHAR2,
   value_   IN     DATE )
IS
BEGIN
   Add_To_Key_Reference(key_ref_, name_, to_char(value_, date_format_));
END Add_To_Key_Reference;



-- Add_To_Key_Reference
--   Adds a key column with value to the key reference list.
@UncheckedAccess
PROCEDURE Add_To_Key_Reference (
   key_ref_ IN OUT VARCHAR2,
   name_    IN     VARCHAR2,
   value_   IN     TIMESTAMP_UNCONSTRAINED )
IS
BEGIN
   Add_To_Key_Reference(key_ref_, name_, to_char(value_, timestamp_format_));
END Add_To_Key_Reference;



-- Get_Key_Reference_Value
--   Retrieves the key reference value for a specific name or index.
@UncheckedAccess
FUNCTION Get_Key_Reference_Value (
   key_ref_ IN VARCHAR2,
   name_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   first_pos_  NUMBER;
   second_pos_ NUMBER;
BEGIN
   first_pos_  := instr(text_separator_||key_ref_, text_separator_||name_||'=') + length(name_) + 1;
   second_pos_ := instr(text_separator_||key_ref_, text_separator_, first_pos_ + 1);
   IF (first_pos_ = length(name_) + 1) THEN
      -- Not found
      RETURN(NULL);
   ELSE
      RETURN(substr(key_ref_, first_pos_, second_pos_ - first_pos_ - 1));
   END IF;
END Get_Key_Reference_Value;



-- Get_Key_Reference_Value
--   Retrieves the key reference value for a specific name or index.
@UncheckedAccess
FUNCTION Get_Key_Reference_Value (
   key_ref_ IN VARCHAR2,
   index_   IN NUMBER ) RETURN VARCHAR2
IS
   keyval_     VARCHAR2(2000);
   first_pos_  NUMBER;
   second_pos_ NUMBER;
BEGIN
   IF (index_ = 1) THEN
      keyval_ := substr(key_ref_, instr(key_ref_, '=') + 1,
                        instr(key_ref_, text_separator_, index_) - instr(key_ref_, '=') - 1);
   ELSE
      first_pos_  := instr(key_ref_, '=', 1, index_) + 1;
      second_pos_ := instr(key_ref_, text_separator_, 1, index_ );
      keyval_     := substr(key_ref_, first_pos_, second_pos_ - first_pos_);
   END IF;
   RETURN(keyval_);
END Get_Key_Reference_Value;



-- Clear_Info
--   Clears all stacked info and warning messages
@UncheckedAccess
PROCEDURE Clear_Info
IS
BEGIN
   Fnd_Context_SYS.Set_Value('CLIENT_SYS.current_info_', '');
END Clear_Info;



-- Add_Info
--   Adds an info message to the stack.
@UncheckedAccess
PROCEDURE Add_Info (
   lu_name_ IN VARCHAR2,
   text_    IN VARCHAR2,
   p1_      IN VARCHAR2 DEFAULT NULL,
   p2_      IN VARCHAR2 DEFAULT NULL,
   p3_      IN VARCHAR2 DEFAULT NULL )
IS
   line_ VARCHAR2(2048);
   err_msg_  VARCHAR2(2000);
BEGIN
   line_ := Language_SYS.Translate_Msg_(lu_name_, text_);
   line_ := ltrim(substr(line_, instr(line_, ':') + 1));
   line_ := replace(line_,':P1',p1_);
   line_ := replace(line_,':P2',p2_);
   line_ := replace(line_,':P3',p3_);

   Fnd_Context_SYS.Set_Value('CLIENT_SYS.current_info_', Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')||'INFO'||field_separator_||line_||record_separator_);

EXCEPTION
   WHEN OTHERS THEN
      err_msg_ := SUBSTR(SQLERRM, 1, 100);
      IF (lengthb(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')) + lengthb('INFO'||field_separator_||line_||record_separator_)) > 32767
         OR (length(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')) + length('INFO'||field_separator_||line_||record_separator_)) > 32000 THEN
            err_msg_:='Client_Sys.Add_Info : Info '''|| line_ ||''' can not be added. String size exceeds maximum size allowed. '|| err_msg_;
      END IF;
      Trace_SYS.Message(err_msg_);
END Add_Info;



-- Add_Warning
--   Adds a warning message to the stack.
@UncheckedAccess
PROCEDURE Add_Warning (
   lu_name_ IN VARCHAR2,
   text_    IN VARCHAR2,
   p1_      IN VARCHAR2 DEFAULT NULL,
   p2_      IN VARCHAR2 DEFAULT NULL,
   p3_      IN VARCHAR2 DEFAULT NULL )
IS
   line_ VARCHAR2(2048);
   err_msg_ VARCHAR2(3000);
BEGIN
   line_ := Language_SYS.Translate_Msg_(lu_name_, text_);
   line_ := ltrim(substr(line_, instr(line_, ':') + 1));
   line_ := replace(line_,':P1',p1_);
   line_ := replace(line_,':P2',p2_);
   line_ := replace(line_,':P3',p3_);
   
   Fnd_Context_SYS.Set_Value('CLIENT_SYS.current_info_', Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')||'WARNING'||field_separator_||line_||record_separator_);

EXCEPTION
   WHEN OTHERS THEN
      err_msg_ := SUBSTR(SQLERRM, 1, 100);
      IF (lengthb(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')) + lengthb('WARNING'||field_separator_||line_||record_separator_)) > 32767
         OR (length(Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_')) + length('WARNING'||field_separator_||line_||record_separator_)) > 32000 THEN
            err_msg_:='Client_Sys.Add_Warning : Warning '''|| line_ ||''' can not be added. String size exceeds maximum size allowed. '|| err_msg_;
      END IF;
      Trace_SYS.Message(err_msg_);
END Add_Warning;



-- Get_All_Info
--   Fetches all stacked info and warning messages for delivery to client.
@UncheckedAccess
FUNCTION Get_All_Info (
   max_length_  IN NUMBER ) RETURN VARCHAR2
IS
   info_ VARCHAR2(32000);
BEGIN
   info_ := Get_Max_Current_Info___(max_length_);
   Clear_Info ;
   RETURN(info_);
END Get_All_Info;



-- Get_All_Info
--   Fetches all stacked info and warning messages for delivery to client.
@UncheckedAccess
FUNCTION Get_All_Info RETURN VARCHAR2
IS
   info_ VARCHAR2(2000);
BEGIN
   info_ := Get_Max_Current_Info___(2000);
   Clear_Info ;
   RETURN(info_);
END Get_All_Info;



@UncheckedAccess
PROCEDURE Get_Trace(
   text_ IN OUT NOCOPY CLOB ) 
IS
   category_arr_  dbms_utility.lname_array;
BEGIN
   Log_SYS.Get_Trace(text_, category_arr_);
END Get_Trace;


-- Get_Separator_Info
--   Returns information about the different separators used for
--   structure packing routines. The method is meant to be used from
--   client the environment. Globals are available for the server.
@UncheckedAccess
PROCEDURE Get_Separator_Info (
   text_sep_   OUT VARCHAR2,
   field_sep_  OUT VARCHAR2,
   record_sep_ OUT VARCHAR2,
   group_sep_  OUT VARCHAR2,
   file_sep_   OUT VARCHAR2 )
IS
BEGIN
   text_sep_   := text_separator_;
   field_sep_  := field_separator_;
   record_sep_ := record_separator_;
   group_sep_  := group_separator_;
   file_sep_   := file_separator_;
END Get_Separator_Info;



@UncheckedAccess
FUNCTION Append_Info (
   previous_info_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_All_Info(32000) || previous_info_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(service_, 'APPEND: Info message is too long.');
END Append_Info;



@UncheckedAccess
PROCEDURE Merge_Info (
   previous_info_ IN VARCHAR2 ) 
IS
BEGIN
   Fnd_Context_SYS.Set_Value('CLIENT_SYS.current_info_', previous_info_||Fnd_Context_SYS.Find_Value('CLIENT_SYS.current_info_'));
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(service_, 'APPEND: Info message is too long.');
END Merge_Info;



@UncheckedAccess
FUNCTION Sleep (
   seconds_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   Dbms_Lock.Sleep(seconds_);
   RETURN(seconds_);
END Sleep;



