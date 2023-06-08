-----------------------------------------------------------------------------
--
--  Logical unit: HistorySettingUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980128  ERFO    Fixed problem concerning too long trigger name (Bug #2060).
--  980128  ERFO    Fixed problem concerning too long trigger text (Bug #2061).
--  980505  DOZE    Fixed update null/not null problem (Bug #2417)
--  980610  DOZE    Fixed illegal trigger problem (Bug #2437)
--  980908  ToFu    Send HistoryType Db value to New_Entry (Bug #2553)
--  990701  RaKu    Recreated with new templates.
--                  Renamed view access from HISTORY_SETTING to
--                  HISTORY_SETTING_ATTRIBUTE (ToDo #3313).
--  000830  ROOD    Added method Get_Logical_Unit_Tables__ and Compile_Trigger___.
--                  Modified Generate_Triggers__(ToDo #3919).
--  020626  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040624  NIPE    Error when enabling History Setting (Bug#45548).
--  050426  UTGU    Added methods Export__,Pack_Array__,Format___(F1PR480).
--  050608  ASWI    Use rowtype column instead of lu_name in the HISTORY_LOG_API.New_Entry
--                  method call for the tables where rowtype exists.
--                  When creating triggers, added validation to see if the rowtype actually
--                  contains a LU name. (#47493)
--  050829  ASWI    The check to see if the rowtype actually contains a LU name
--                  should be done using OLD values for delete trigger (BUg#52566).
--  060516  HENJSE  Asserted Get_Logical_Unit_Tables__ (Bug#57108).
--  060619  SUKM    Added new methods Generate_Triggers_For_Module, and Check_Exist_Exact_Match_Lu___ (Bug#58007)
--  061201  SUKM    Removed checking for column count for perfectly matching lu's in Get_Logical_Unit_Tables___ (Bug#62176)
--  070104  SUKM    Revoked Bug#62176. (Bug#62755)
--  070123  UTGULK  Added check View_Is_Installed for tables with column 'rowtype' in Generate_Triggers__ (Bug#62391). 
--  070523  HAAR    Changed Get_Logical_Unit_Tables__ to handle keys with '$' (Bug#65547).
--  070813  SUMALK  Change substrb to Substr and instrb to instr.(Call 147296)
--  100719  ChMu    Certified the assert safe for dynamic SQLs (Bug#84970)
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
-----------------------------------------------------------------------------
--  130805  MADD    Modified Generate_Triggers__ to avoid buffer overflow.(Bug#110625
--  210630  CHAH    Modified Generate_Triggers__ to handle table suffixes: _CFT/_CLT.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Generate_Key_List___ (
   view_key_list_     IN VARCHAR2,
   table_key_list_     IN VARCHAR2,
   prefix_       IN VARCHAR2,
   table_name_   IN VARCHAR2,
   lu_name_      IN VARCHAR2,
   trigger_type_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Generate_Key_List_Impl___(view_key_list_, table_key_list_, prefix_, table_name_, lu_name_, trigger_type_, FALSE);
END Generate_Key_List___;

FUNCTION Generate_Key_List_Impl___ (
   view_key_list_    IN VARCHAR2,
   table_key_list_   IN VARCHAR2,
   prefix_           IN VARCHAR2,
   table_name_       IN VARCHAR2,
   lu_name_          IN VARCHAR2,
   trigger_type_     IN VARCHAR2,
   gen_table_keys_   IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS

   out_list_         VARCHAR2(2000);
   view_identifier_  VARCHAR2(35);
   table_identifier_ VARCHAR2(35);
   identifier_       VARCHAR2(35);
   ptr_view_         NUMBER;
   ptr_table_        NUMBER;
   start_ptr_view_   NUMBER := 1;
   start_ptr_table_  NUMBER := 1;
   counter_          NUMBER := 0;
   datatype_         VARCHAR2(35);

   CURSOR get_datatype is
    SELECT data_type
      FROM user_tab_columns
      WHERE table_name = upper(table_name_)
      AND column_name = table_identifier_;
     
   rowkey_col_ VARCHAR2(30);
BEGIN
   IF table_name_ LIKE '%/_CFT' ESCAPE '/' THEN
      rowkey_col_ := NVL(Dictionary_SYS.Get_Objkey_Info(lu_name_, TRUE), 'ROWKEY');
      IF trigger_type_ = 'D' THEN
         -- Special handing to get Keys from LU table for DELETE trigger
         -- This is to avoid mutating error when reading the LU table
         RETURN Generate_Key_List_Cust_AT___(prefix_, lu_name_, rowkey_col_);
      ELSE
         RETURN Generate_Key_List_Cust___(prefix_, lu_name_, rowkey_col_);
      END IF;
   ELSIF table_name_ LIKE '%/_CLT' ESCAPE '/' THEN
      rowkey_col_ := NVL(Dictionary_SYS.Get_Objkey_Info(lu_name_, TRUE), 'ROWKEY');
      RETURN '''OBJKEY=''||'||prefix_||rowkey_col_||'||''^''';
   END IF;
   
   out_list_ := '''';
   LOOP
      counter_ := counter_ + 1;
      
      ptr_view_ := instr(view_key_list_, '^', 1, counter_);
      view_identifier_ := substr(view_key_list_, start_ptr_view_, ptr_view_-start_ptr_view_-1);
      
      ptr_table_ := instr(table_key_list_, '^', 1, counter_);
      table_identifier_ := substr(table_key_list_, start_ptr_table_, ptr_table_-start_ptr_table_-1);
      
      OPEN get_datatype;
      FETCH get_datatype INTO datatype_;
      CLOSE get_datatype;
      
      IF gen_table_keys_ THEN
         identifier_ := table_identifier_;
      ELSE
         identifier_ := view_identifier_;
      END IF;
      IF datatype_ = 'DATE' THEN
         out_list_ := out_list_||identifier_||'=''||to_char('||prefix_||table_identifier_||', ''YYYY-MM-DD-HH24.MI.SS'')||''^';
      ELSIF datatype_ = 'NUMBER' THEN
            out_list_ := out_list_||view_identifier_||'=''||regexp_replace('||prefix_||table_identifier_||', ''^(-?)([.,])'', ''\10\2'')||''^';
      ELSE
         out_list_ := out_list_||identifier_||'=''||'||prefix_||table_identifier_||'||''^';
      END IF;
      start_ptr_view_ := ptr_view_ + 1;
      start_ptr_table_ := ptr_table_ + 1;
      IF gen_table_keys_ THEN
         EXIT WHEN start_ptr_table_ >= length(table_key_list_);
      ELSE
         EXIT WHEN start_ptr_view_ >= length(view_key_list_);
      END IF;
   END LOOP;
   out_list_ := out_list_||'''';
   RETURN out_list_;
END Generate_Key_List_Impl___;

FUNCTION Generate_Key_List_Cust___ (
   prefix_     IN VARCHAR2,
   lu_name_    IN VARCHAR2,
   rowkey_col_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN 'History_Log_Util_API.Get_Key_Ref_From_Objkey('''||lu_name_||''', '||prefix_ ||rowkey_col_||')';
END Generate_Key_List_Cust___;

FUNCTION Generate_Key_List_Cust_AT___ (
   prefix_     IN VARCHAR2,
   lu_name_    IN VARCHAR2,
   rowkey_col_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN 'History_Log_Util_API.Get_Key_Ref_From_Objkey_AT('''||lu_name_||''', '||prefix_ ||rowkey_col_||')';
END Generate_Key_List_Cust_AT___;

PROCEDURE Compile_Trigger___ (
   stmt_        IN VARCHAR2,
   name_        IN VARCHAR2,
   error_names_ IN OUT VARCHAR2 )
IS
   cid_            NUMBER;
   compile_error_  EXCEPTION;
   PRAGMA          exception_init(compile_error_, -24344);
BEGIN
   cid_ := dbms_sql.open_cursor;
   --Safe due to check in Generate_Triggers__
   @ApproveDynamicStatement(2010-07-19,chmulk)
   dbms_sql.parse(cid_, stmt_, dbms_sql.native);
   dbms_sql.close_cursor(cid_);
EXCEPTION
   WHEN compile_error_ THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      IF error_names_ IS NULL THEN
         error_names_ := name_;
      ELSE
         error_names_ := error_names_||', '||name_;
      END IF;
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;
END Compile_Trigger___;


FUNCTION Format___ (
   value_  IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(''''||Replace(value_, '''', '''''')||'''');
END Format___;


FUNCTION Check_Exist_Exact_Match_Lu___ (
   exact_match_lu_ OUT VARCHAR2,
   table_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   lu_name_ VARCHAR2(200);
   temp_    VARCHAR2(200);
   retval_  VARCHAR2(5);   

BEGIN
   retval_ := 'FALSE';
   exact_match_lu_ := NULL;

   temp_ := substr (table_name_, 1, length(table_name_) - 4); -- SOME_LU_TAB becomes SOME_LU
   lu_name_ := Dictionary_Sys.Dbnametoclientname_ ( temp_ );   
   --SOLSETFW
   IF Dictionary_Sys.Logical_Unit_Is_Active (lu_name_) THEN
      retval_ := 'TRUE';
      exact_match_lu_ := lu_name_;
   END IF;

   RETURN retval_;
END Check_Exist_Exact_Match_Lu___;

FUNCTION Get_Custom_Ref_Field_Method___ (
   lu_name_     IN VARCHAR2,
   column_name_ IN VARCHAR2,
   prefix_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   expression_  VARCHAR2(1000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT expression INTO expression_
   FROM custom_field_attributes
   WHERE lu = lu_name_
   AND column_name = column_name_
   AND data_type_db = Custom_Field_Data_Types_Api.DB_REFERENCE;
   expression_ := UPPER(expression_);
$END
   RETURN REPLACE(expression_, 'T.', prefix_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Custom_Ref_Field_Method___;
   
FUNCTION Get_Column_Bind_Name____ (
   prefix_      IN VARCHAR2,
   column_name_ IN VARCHAR2,
   lu_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   bind_name_ VARCHAR2(2000);
BEGIN
   IF column_name_ LIKE 'CF$/_%' ESCAPE '/' THEN
      bind_name_ := Get_Custom_Ref_Field_Method___(lu_name_, column_name_, prefix_);           
   END IF;
   
   IF bind_name_ IS NULL THEN
      -- Not a reference
      bind_name_ := prefix_||column_name_;
   END IF;
   RETURN bind_name_;
END Get_Column_Bind_Name____;
   
FUNCTION Generate_Table_Key_List___ (
   table_key_list_   IN VARCHAR2,
   prefix_           IN VARCHAR2,
   table_name_       IN VARCHAR2,
   lu_name_          IN VARCHAR2,
   trigger_type_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Generate_Key_List_Impl___(NULL, table_key_list_, prefix_, table_name_, lu_name_, trigger_type_, TRUE);
END Generate_Table_Key_List___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Generate_Triggers__ (
   module_name_ IN VARCHAR2,
   lu_name_     IN VARCHAR2,
   table_name_  IN VARCHAR2 )
IS
   temp_           VARCHAR2(32000);
   temp1_          VARCHAR2(32000);
   temp2_          VARCHAR2(32000);
   temp3_          VARCHAR2(32000);
   temp4_          VARCHAR2(32000);
   temp5_          VARCHAR2(32000);
   
   start1_         VARCHAR2(32000);
   start2_         VARCHAR2(32000);
   start3_         VARCHAR2(32000);
   start4_         VARCHAR2(32000);
   start5_         VARCHAR2(32000);
   start_part_two_ VARCHAR2(32000);
   
   column_list1_   VARCHAR2(32000);
   column_list2_   VARCHAR2(32000);
   column_list3_   VARCHAR2(32000);
   column_list4_   VARCHAR2(32000);
   column_list5_   VARCHAR2(32000);
   temp_col_       VARCHAR2(32000);
   
   droup_trigger_  VARCHAR2(32000);
   
   update_trigger_1_enable_ BOOLEAN := FALSE;
   update_trigger_2_enable_ BOOLEAN := FALSE;
   update_trigger_3_enable_ BOOLEAN := FALSE;
   update_trigger_4_enable_ BOOLEAN := FALSE;
   update_trigger_5_enable_ BOOLEAN := FALSE;
   
   first_col1_    BOOLEAN := TRUE;
   first_col2_    BOOLEAN := TRUE;
   first_col3_    BOOLEAN := TRUE;
   first_col4_    BOOLEAN := TRUE;
   first_col5_    BOOLEAN := TRUE;
   
   end_                 VARCHAR2(32000);
   name_list_table_     VARCHAR2(2000);
   dummy_               VARCHAR2(10);
   remove_trigger_      BOOLEAN;
   insert_trigger_      VARCHAR2(32000);
   delete_trigger_      VARCHAR2(32000);
   update_trigger_      VARCHAR2(32000);
   tab_short_name_      VARCHAR2(2000) := REGEXP_REPLACE(table_name_, '_TAB|_CFT|_CLT', '');
   trigger_hash_val_    NUMBER;
   error_triggers_      VARCHAR2(100);
   lu_exists_stmt_      VARCHAR2(1000) := NULL;
   lu_exists_stmt_old_  VARCHAR2(1000) := NULL;
   if_lu_exist_stmt_    VARCHAR2(1000) := NULL;
   temp_len_            NUMBER;
   indent_              VARCHAR2(3) := '   ';
   table_lu_name_       VARCHAR2(30) := Dictionary_SYS.Get_Logical_Unit(tab_short_name_, 'VIEW');
   
   CURSOR insert_cols_ IS
      SELECT column_name
      FROM   HISTORY_SETTING_ATTRIBUTE
      WHERE  log_insert = '1'
      AND    table_name = table_name_;
      
   CURSOR update_cols_ IS
      SELECT column_name
      FROM   HISTORY_SETTING_ATTRIBUTE
      WHERE  log_update = '1'
      AND    table_name = table_name_;
      
   CURSOR delete_cols_ IS
      SELECT column_name
      FROM   HISTORY_SETTING_ATTRIBUTE
      WHERE  log_delete = '1'
      AND    table_name = table_name_;
      
   CURSOR check_trigger(name_ IN VARCHAR2) IS
      SELECT 'x'
      FROM   user_triggers
      WHERE  trigger_name = name_;
      
BEGIN
   
   IF table_name_ LIKE '%/_CFT' ESCAPE '/' OR table_name_ LIKE '%/_CLT' ESCAPE '/' THEN
      IF length(table_name_) > 24 THEN
         SELECT ora_hash(table_name_, 4294967295) INTO trigger_hash_val_ FROM dual;
         tab_short_name_ := substr(table_name_,1,14)||trigger_hash_val_;
      ELSE
         tab_short_name_ := table_name_; -- include CFT part
      END IF;
   ELSE      
      tab_short_name_ := REPLACE(table_name_, '_TAB', '');
   END IF;
   
   Assert_Sys.Assert_Is_Logical_Unit(lu_name_);
   Assert_Sys.Assert_Is_Table(table_name_);

   IF (Installation_SYS.Column_Exist(table_name_, 'ROWTYPE')) THEN
     --SOLSETFW 
     lu_exists_stmt_  := chr(10)||indent_||indent_||'IF (Dictionary_SYS.Logical_Unit_Is_Active(:NEW.ROWTYPE) AND Dictionary_SYS.View_Is_Active(Dictionary_SYS.ClientNameToDbName_(:NEW.ROWTYPE ))) THEN '||chr(10)||
         indent_||indent_||indent_||'row_lu_name_ := :NEW.ROWTYPE; '||chr(10)||indent_||indent_||'END IF;';
     lu_exists_stmt_old_  := chr(10)||indent_||indent_||'IF (Dictionary_SYS.Logical_Unit_Is_Active(:OLD.ROWTYPE) AND Dictionary_SYS.View_Is_Active(Dictionary_SYS.ClientNameToDbName_(:OLD.ROWTYPE ))) THEN '||chr(10)||
         indent_||indent_||indent_||'row_lu_name_ := :OLD.ROWTYPE; '||chr(10)||indent_||indent_||'END IF;';
     if_lu_exist_stmt_ := chr(10)||chr(10)||indent_||indent_||'IF (NVL(log_id_, 0) = 0) THEN'||     
                          chr(10)||indent_||indent_||indent_||'RETURN;'||
                          chr(10)||indent_||indent_||'END IF;'||chr(10);
   END IF;
   --
   -- Insert trigger
   --
   start1_ := 'CREATE OR REPLACE TRIGGER '||
          tab_short_name_||'_I '||chr(10)||indent_||'AFTER INSERT ON '||table_name_||chr(10)||indent_||
          'FOR EACH ROW '||chr(10)||'DECLARE'||chr(10)||'   log_id_ number; '||chr(10)||'   row_lu_name_ VARCHAR2(30) := '''||lu_name_||'''; '||chr(10)||'BEGIN '||chr(10)||
          indent_||'IF History_Setting_Util_API.Is_Enabled THEN ';
   temp_ := '';
   end_ := '';
   remove_trigger_ := TRUE;
   FOR col_ IN insert_cols_ LOOP
      temp_ := temp_||chr(10)||indent_||indent_||
               'HISTORY_LOG_ATTRIBUTE_API.New_Entry(log_id_, '''||
               col_.column_name||''', null, ' || Get_Column_Bind_Name____(':NEW.', col_.column_name, lu_name_)||');';
      remove_trigger_ := FALSE;
   END LOOP;
   
   IF temp_ IS NOT NULL THEN
      temp_ := temp_||lu_exists_stmt_;
   END IF;

   IF remove_trigger_ THEN
      OPEN check_trigger(tab_short_name_||'_I');
      FETCH check_trigger INTO dummy_;
      IF check_trigger%NOTFOUND THEN
         start1_ := '';
      ELSE
         start1_ := 'DROP TRIGGER '||tab_short_name_||'_I';
      END IF;
      CLOSE check_trigger;
   ELSE
      Client_SYS.Get_Table_Key_Reference(name_list_table_, table_lu_name_);
      end_ := chr(10)||indent_||indent_||'HISTORY_LOG_API.New_Entry(log_id_, '''||module_name_||
        ''', row_lu_name_, '''||table_name_||''', 
        History_Setting_Util_API.Replace_Table_Key_List__('||Generate_Table_Key_List___(name_list_table_, ':NEW.', table_name_, lu_name_, 'I')||','''||table_name_||''',
        row_lu_name_), ''1'');'||chr(10)||indent_||'END IF;'||chr(10)||'END;';
   END IF;

   insert_trigger_ :=  start1_||temp_||end_;
   IF insert_trigger_ IS NOT NULL THEN
      Compile_Trigger___(insert_trigger_, tab_short_name_||'_I', error_triggers_);
      -- Format statement for output
      insert_trigger_ := insert_trigger_||chr(10)||'/';
   END IF;

   ---
   --- Delete trigger
   ---
   start1_ := 'CREATE OR REPLACE TRIGGER '||
          tab_short_name_||'_D '||chr(10)||indent_||'AFTER DELETE ON '||table_name_||chr(10)||indent_||
          'FOR EACH ROW '||chr(10)||'DECLARE'||chr(10)||'   log_id_ number; '||chr(10)||'   row_lu_name_ VARCHAR2(30) := '''||lu_name_||'''; '||chr(10)||'BEGIN '||chr(10)||
          indent_||'IF History_Setting_Util_API.Is_Enabled THEN ';
   temp_ := '';
   end_ := '';
   remove_trigger_ := TRUE;
   FOR col_ IN delete_cols_ LOOP
      temp_ := temp_||chr(10)||indent_||indent_||
               'HISTORY_LOG_ATTRIBUTE_API.New_Entry(log_id_, '''||
               col_.column_name||''', '|| Get_Column_Bind_Name____(':OLD.', col_.column_name, lu_name_)||', null);';
      remove_trigger_ := FALSE;
   END LOOP;

   IF temp_ IS NOT NULL THEN
      temp_ := temp_||lu_exists_stmt_old_;
   END IF;

   IF remove_trigger_ THEN
      OPEN check_trigger(tab_short_name_||'_D');
      FETCH check_trigger INTO dummy_;
      IF check_trigger%NOTFOUND THEN
         start1_ := '';
      ELSE
         start1_ := 'DROP TRIGGER '||tab_short_name_||'_D';
      END IF;
      CLOSE check_trigger;
   ELSE
      Client_SYS.Get_Table_Key_Reference(name_list_table_, table_lu_name_);
      end_ := chr(10)||indent_||indent_||'HISTORY_LOG_API.New_Entry(log_id_, '''||
              module_name_||''', row_lu_name_, '''||table_name_||''', 
        History_Setting_Util_API.Replace_Table_Key_List__('||Generate_Table_Key_List___(name_list_table_, ':OLD.', table_name_, lu_name_, 'D')||','''||table_name_||''',
        row_lu_name_), ''3'');'||chr(10)||indent_||'END IF;'||chr(10)||'END;';
   END IF;
   delete_trigger_ :=  start1_||temp_||end_;
   IF delete_trigger_ IS NOT NULL THEN
      Compile_Trigger___(delete_trigger_, tab_short_name_||'_D', error_triggers_);
      delete_trigger_ := delete_trigger_||chr(10)||'/';
   END IF;
   
   -- max trigger length can only be 30
   IF Length(tab_short_name_) > 27 THEN
      tab_short_name_ := substr(tab_short_name_,1,27);
   END IF;
   
   ---
   --- Update triggers
   ---
    
   start1_ := 'CREATE OR REPLACE TRIGGER '||tab_short_name_||'_U '||chr(10)||indent_||'AFTER UPDATE OF ';
   start2_ := 'CREATE OR REPLACE TRIGGER '||tab_short_name_||'1_U '||chr(10)||indent_||'AFTER UPDATE OF ';
   start3_ := 'CREATE OR REPLACE TRIGGER '||tab_short_name_||'2_U '||chr(10)||indent_||'AFTER UPDATE OF ';
   start4_ := 'CREATE OR REPLACE TRIGGER '||tab_short_name_||'3_U '||chr(10)||indent_||'AFTER UPDATE OF ';
   start5_ := 'CREATE OR REPLACE TRIGGER '||tab_short_name_||'4_U '||chr(10)||indent_||'AFTER UPDATE OF ';
   start_part_two_ := chr(10)||indent_|| 'ON '||table_name_||
                      chr(10)||indent_||'FOR EACH ROW '||
                      chr(10)||'DECLARE'||
                      chr(10)||indent_||'log_id_ number; '||
                      chr(10)||indent_||'row_lu_name_ VARCHAR2(30) := '''||lu_name_||'''; '||
                      chr(10)||'BEGIN '||
                      chr(10)||indent_||'IF History_Setting_Util_API.Is_Enabled THEN ';       
   
   temp_  := '';
   temp2_ := '';
   temp3_ := '';
   temp4_ := '';
   temp5_ := '';
   
   end_ := '';
   
   -- Remove all update trigers.
   -- There could be update triggers left alone when columns are deselected from History logging.
   -- To make sure there are no unwanted triggers left, first all existing update triggers are removed.

   OPEN check_trigger(tab_short_name_||'_U');
   FETCH check_trigger INTO dummy_;
   IF check_trigger%FOUND THEN
      droup_trigger_ := 'DROP TRIGGER '||tab_short_name_||'_U';
      Compile_Trigger___(droup_trigger_, tab_short_name_||'_U', error_triggers_);
   END IF;
   CLOSE check_trigger;
   
   OPEN check_trigger(tab_short_name_||'1_U');
   FETCH check_trigger INTO dummy_;
   IF check_trigger%FOUND THEN
      droup_trigger_ := 'DROP TRIGGER '||tab_short_name_||'1_U';
      Compile_Trigger___(droup_trigger_, tab_short_name_||'1_U', error_triggers_);
   END IF;
   CLOSE check_trigger;
   
   OPEN check_trigger(tab_short_name_||'2_U');
   FETCH check_trigger INTO dummy_;
   IF check_trigger%FOUND THEN
      droup_trigger_ := 'DROP TRIGGER '||tab_short_name_||'2_U';
      Compile_Trigger___(droup_trigger_, tab_short_name_||'2_U', error_triggers_);
   END IF;
   CLOSE check_trigger;
   
   OPEN check_trigger(tab_short_name_||'3_U');
   FETCH check_trigger INTO dummy_;
   IF check_trigger%FOUND THEN
      droup_trigger_ := 'DROP TRIGGER '||tab_short_name_||'3_U';
      Compile_Trigger___(droup_trigger_, tab_short_name_||'3_U', error_triggers_);
   END IF;
   CLOSE check_trigger;
   
   OPEN check_trigger(tab_short_name_||'4_U');
   FETCH check_trigger INTO dummy_;
   IF check_trigger%FOUND THEN
      droup_trigger_ := 'DROP TRIGGER '||tab_short_name_||'4_U';
      Compile_Trigger___(droup_trigger_, tab_short_name_||'4_U', error_triggers_);
   END IF;
   CLOSE check_trigger;
   
   --   
   Client_SYS.Get_Table_Key_Reference(name_list_table_, table_lu_name_);
   end_ := chr(10)||indent_||indent_||'IF (log_id_ != 0) THEN'||chr(10)||
           indent_||indent_||indent_||'HISTORY_LOG_API.New_Entry(log_id_, '''||module_name_||
           ''', row_lu_name_, '''||table_name_||''', 
           History_Setting_Util_API.Replace_Table_Key_List__('||Generate_Table_Key_List___(name_list_table_, ':OLD.', table_name_, lu_name_, 'U')||','''||table_name_||''',
           row_lu_name_), ''2'');'||chr(10)||indent_||indent_||
           'END IF;'||chr(10)||indent_||'END IF;'||chr(10)||'END;';
   temp_len_ := Length(start1_) + Length(start_part_two_) + Length(NVL(if_lu_exist_stmt_,'0')) + Length(NVL(lu_exists_stmt_,'0')) + Length(end_) + 4;
   
   FOR col_ IN update_cols_ LOOP
      temp1_ := '';
      temp_col_ := '';
      -- Custom Fields: For reference Custom Fields do not compare actual values
      --                Only compare Reference ROWKEYs. But log the actual value
      temp1_ := indent_||indent_||'IF Validate_SYS.Is_Changed('||
         Get_Column_Bind_Name____(':OLD.', col_.column_name, lu_name_)||', '|| Get_Column_Bind_Name____(':NEW.', col_.column_name, lu_name_) ||') THEN'||
         chr(10)||indent_||indent_||indent_||'HISTORY_LOG_ATTRIBUTE_API.New_Entry(log_id_, '''||col_.column_name||''', '|| 
         Get_Column_Bind_Name____(':OLD.', col_.column_name, lu_name_)||', '|| Get_Column_Bind_Name____(':NEW.', col_.column_name, lu_name_) ||');'||chr(10)||
         indent_||indent_||'END IF;'; 
      temp_col_ := col_.column_name;   
            
      IF ((Length(NVL(temp_,'0'))+ Length(NVL(column_list1_,'0'))+ Length(temp1_) + temp_len_) < 32000) THEN
         update_trigger_1_enable_ := TRUE;
         temp_ := temp_||chr(10)|| temp1_;
         IF first_col1_ THEN
            column_list1_ := chr(10)||indent_||indent_||temp_col_;
            first_col1_ := FALSE;
         ELSE   
            column_list1_ := column_list1_||','||chr(10)||indent_||indent_||temp_col_;
         END IF;
      ELSIF (Length(NVL(temp2_,'0'))+ Length(NVL(column_list2_,'0'))+ Length(temp1_) + temp_len_) < 32000 THEN
         temp2_ := temp2_||chr(10)|| temp1_;
         IF first_col2_ THEN
            column_list2_ := chr(10)||indent_||indent_||temp_col_;
            first_col2_ := FALSE;
         ELSE   
            column_list2_ := column_list2_||','||chr(10)||indent_||indent_||temp_col_;
         END IF;
         update_trigger_2_enable_ := TRUE;
      ELSIF (Length(NVL(temp3_,'0'))+ Length(NVL(column_list3_,'0'))+ Length(temp1_) + temp_len_) < 32000 THEN
         temp3_ := temp3_||chr(10)|| temp1_;
         IF first_col3_ THEN
            column_list3_ := chr(10)||indent_||indent_||temp_col_;
            first_col3_ := FALSE;
         ELSE   
            column_list3_ := column_list3_||','||chr(10)||indent_||indent_||temp_col_;
         END IF;
         update_trigger_3_enable_ := TRUE;
      ELSIF (Length(NVL(temp4_,'0'))+ Length(NVL(column_list4_,'0'))+ Length(temp1_) + temp_len_) < 32000 THEN
         temp4_ := temp4_||chr(10)|| temp1_;
         IF first_col4_ THEN
            column_list4_ := chr(10)||indent_||indent_||temp_col_;
            first_col4_ := FALSE;
         ELSE   
            column_list4_ := column_list4_||','||chr(10)||indent_||indent_||temp_col_;
         END IF;
         update_trigger_4_enable_ := TRUE;
      ELSIF (Length(NVL(temp5_,'0'))+ Length(NVL(column_list5_,'0'))+ Length(temp1_) + temp_len_) < 32000 THEN
         temp5_ := temp5_||chr(10)|| temp1_;
         IF first_col5_ THEN
            column_list5_ := chr(10)||indent_||indent_||temp_col_;
            first_col5_ := FALSE;
         ELSE   
            column_list5_ := column_list5_||','||chr(10)||indent_||indent_||temp_col_;
         END IF;
         update_trigger_5_enable_ := TRUE;
      END IF;
   END LOOP;

   IF update_trigger_1_enable_ THEN
      update_trigger_ :=  start1_||column_list1_||start_part_two_||temp_||if_lu_exist_stmt_||lu_exists_stmt_||end_;
      Compile_Trigger___(update_trigger_, tab_short_name_||'_U', error_triggers_);
      update_trigger_ := update_trigger_||chr(10)||'/';
   END IF;
   IF error_triggers_ IS NOT NULL THEN
      Error_SYS.Record_General('HistorySettingUtil', 'COMPILE_ERRORS: Compilation errors for triggers :P1', error_triggers_);
   END IF;
   
   IF update_trigger_2_enable_ THEN
      update_trigger_ :=  start2_||column_list2_||start_part_two_||temp2_||if_lu_exist_stmt_||lu_exists_stmt_||end_;
      Compile_Trigger___(update_trigger_, tab_short_name_||'1_U', error_triggers_);
      update_trigger_ := update_trigger_||chr(10)||'/';
   END IF;
   IF error_triggers_ IS NOT NULL THEN
      Error_SYS.Record_General('HistorySettingUtil', 'COMPILE_ERRORS: Compilation errors for triggers :P1', error_triggers_);
   END IF;

   IF update_trigger_3_enable_ THEN
      update_trigger_ :=  start3_||column_list3_||start_part_two_||temp3_||if_lu_exist_stmt_||lu_exists_stmt_||end_;
      Compile_Trigger___(update_trigger_, tab_short_name_||'2_U', error_triggers_);
      update_trigger_ := update_trigger_||chr(10)||'/';
   END IF;
   IF error_triggers_ IS NOT NULL THEN
      Error_SYS.Record_General('HistorySettingUtil', 'COMPILE_ERRORS: Compilation errors for triggers :P1', error_triggers_);
   END IF;

   IF update_trigger_4_enable_ THEN
      update_trigger_ :=  start4_||column_list4_||start_part_two_||temp4_||if_lu_exist_stmt_||lu_exists_stmt_||end_;
      Compile_Trigger___(update_trigger_, tab_short_name_||'3_U', error_triggers_);
      update_trigger_ := update_trigger_||chr(10)||'/';
   END IF;
   IF error_triggers_ IS NOT NULL THEN
      Error_SYS.Record_General('HistorySettingUtil', 'COMPILE_ERRORS: Compilation errors for triggers :P1', error_triggers_);
   END IF;

   IF update_trigger_5_enable_ THEN
      update_trigger_ :=  start5_||column_list5_||start_part_two_||temp5_||if_lu_exist_stmt_||lu_exists_stmt_||end_;
      Compile_Trigger___(update_trigger_, tab_short_name_||'4_U', error_triggers_);
      update_trigger_ := update_trigger_||chr(10)||'/';
   END IF;
   IF error_triggers_ IS NOT NULL THEN
      Error_SYS.Record_General('HistorySettingUtil', 'COMPILE_ERRORS: Compilation errors for triggers :P1', error_triggers_);
   END IF;
END Generate_Triggers__;
FUNCTION Replace_Table_Key_List__ (
   table_key_value_list_   IN VARCHAR2,
   table_name_             IN VARCHAR2,
   lu_name_                IN VARCHAR2) RETURN VARCHAR2
IS

   out_list_         VARCHAR2(2000);
   view_identifier_  VARCHAR2(35);
   table_identifier_ VARCHAR2(35);
   view_key_list_    VARCHAR2(2000);
   table_key_list_   VARCHAR2(2000);
   table_key_values_ VARCHAR2(2000) := NULL;
   temp_key_values_  VARCHAR2(2000);
   ptr_view_         NUMBER;
   ptr_table_        NUMBER;
   start_ptr_view_   NUMBER := 1;
   start_ptr_table_  NUMBER := 1;
   counter_          NUMBER := 0;

BEGIN
   IF (table_name_ LIKE '%/_CFT' ESCAPE '/') OR (table_name_ LIKE '%/_CLT' ESCAPE '/') THEN
      RETURN table_key_value_list_;
   END IF;
   
   Client_SYS.Get_Key_Reference(view_key_list_, lu_name_);
   Client_SYS.Get_Table_Key_Reference(table_key_list_, lu_name_);
   
   out_list_ := '''';
   LOOP
      counter_ := counter_ + 1;
      
      ptr_view_ := INSTR(view_key_list_, '^', 1, counter_);
      view_identifier_ := SUBSTR(view_key_list_, start_ptr_view_, ptr_view_-start_ptr_view_-1);
      
      ptr_table_ := INSTR(table_key_list_, '^', 1, counter_);
      table_identifier_ := SUBSTR(table_key_list_, start_ptr_table_, ptr_table_-start_ptr_table_-1);
      
      
      start_ptr_view_ := ptr_view_ + 1;
      start_ptr_table_ := ptr_table_ + 1;

      temp_key_values_ := SUBSTR(table_key_value_list_, INSTR(table_key_value_list_, table_identifier_));
      temp_key_values_ := SUBSTR(temp_key_values_, 1, INSTR(temp_key_values_, '^', 1, 1));
      
      temp_key_values_ := REPLACE (temp_key_values_, table_identifier_, view_identifier_);
      table_key_values_ := table_key_values_||temp_key_values_;
      EXIT WHEN start_ptr_view_ >= length(view_key_list_);
   END LOOP;
   RETURN table_key_values_;
END Replace_Table_Key_List__;

PROCEDURE Get_Logical_Unit_Tables__ (
   table_list_ OUT VARCHAR2,
   lu_name_    IN  VARCHAR2 )
IS
   key_list_              VARCHAR2(2000);
   temp_table_list_       VARCHAR2(2000);
   text_separator_        VARCHAR2(1) := Client_SYS.text_separator_;
   field_separator_       VARCHAR2(1) := Client_SYS.field_separator_;
   temp_table_name_       VARCHAR2(30);
   table_from_            NUMBER := 1;
   key_count_             NUMBER;
   table_count_           NUMBER;
   matching_column_count_ NUMBER;
   cursor_                NUMBER;
   ignore_                NUMBER;
   stmt_                  VARCHAR2(4000);
   exact_match_lu_        VARCHAR2(200);
   base_table_name_ VARCHAR2(50);
   --SOLSETFW
   CURSOR get_table IS
      SELECT table_name
      FROM dictionary_sys_active
      WHERE lu_name = lu_name_;
BEGIN
   OPEN get_table;
   FETCH get_table INTO base_table_name_;
   CLOSE get_table;
   --base_table_name_ := Dictionary_Sys.Get_Base_Table_Name(lu_name_);
   -- Find all tables referenced by this LU
   Dictionary_SYS.Get_Logical_Unit_Tables_(table_list_, lu_name_);
   -- Find the keys for this LU
   Client_SYS.Get_Table_Key_Reference(key_list_, lu_name_);
   IF key_list_ IS NULL OR table_list_ IS NULL THEN
      table_list_ := NULL;
      RETURN;
   END IF;
   -- Format the list and count keys and tables
   key_list_ := replace(key_list_, '='||text_separator_, ',');
   key_count_ := length(key_list_) - length(replace(key_list_, ','));
   table_count_ := length(table_list_) - length(replace(table_list_, field_separator_));
   -- Build statement for dynamic SQL to find columns in the tables
   key_list_ := rtrim(key_list_, ',');
   ASSERT_SYS.Assert_Match_Regexp( key_list_, '^[a-zA-Z0-9_,]+\$?$' );
   key_list_ := ''''||replace(key_list_, ',', ''''||','||'''')||'''';
   stmt_ := 'SELECT count(*)';
   stmt_ := stmt_ || ' FROM user_tab_columns';
   stmt_ := stmt_ || ' WHERE table_name = :table_name';
   stmt_ := stmt_ || ' AND column_name IN (';
   stmt_ := stmt_ || key_list_ || ')';
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2006-05-16,henjse)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   -- Loop over all the possible tables and find the ones with columns matching the keys in the LU
   FOR c1 IN 1..table_count_ LOOP
      temp_table_name_ := substr(table_list_, table_from_, (instr(table_list_, field_separator_, table_from_) - table_from_));
      table_from_ := instr(table_list_, field_separator_, table_from_) + length(field_separator_);

      dbms_sql.define_column(cursor_, 1, matching_column_count_);
      dbms_sql.bind_variable(cursor_, 'table_name', temp_table_name_);
      ignore_ := dbms_sql.execute(cursor_);
      ignore_ := dbms_sql.fetch_rows(cursor_);
      dbms_sql.column_value(cursor_,1, matching_column_count_);

      --Check if this is the base table of that logical unit.
      IF base_table_name_ IS NOT NULL AND temp_table_name_ = base_table_name_ THEN
         IF matching_column_count_ = key_count_ THEN
            -- Build the list for the accepted tables
            temp_table_list_ := temp_table_list_||temp_table_name_||field_separator_;            
         END IF;         
         -- Check to see if this table has an lu which matches it directly. Ie an LU DocIssue matches a table Doc_Issue_Tab directly.
      ELSIF Check_Exist_Exact_Match_Lu___ ( exact_match_lu_, temp_table_name_ ) = 'TRUE' THEN
         IF lu_name_ = exact_match_lu_ THEN -- Is the current LU the one that matches exactly then add the table to the list.            
            IF matching_column_count_ = key_count_ THEN
               -- Build the list for the accepted tables
               temp_table_list_ := temp_table_list_||temp_table_name_||field_separator_;            
            ELSE
               Trace_SYS.Message('Table '||temp_table_name_||' key column count and LU key list count do not match');
            END IF;
         ELSE
            Trace_SYS.Message('Table '|| temp_table_name_ || ' does not belong to ' || lu_name_ || ' but belongs to '|| exact_match_lu_);
         END IF;
      ELSE -- There is no lu that matches the current table exactly, take the chance and add the table to the list.
         IF matching_column_count_ = key_count_ THEN
            -- Build the list for the accepted tables
            temp_table_list_ := temp_table_list_||temp_table_name_||field_separator_;
         END IF;
      END IF;
   END LOOP;
   dbms_sql.close_cursor(cursor_);
   
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF Custom_Fields_API.Get_Published_Db(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD) = Fnd_Boolean_API.DB_TRUE THEN
      temp_table_name_ := Custom_Fields_API.Get_Table_Name(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD);
      IF temp_table_name_ IS NOT NULL THEN
         temp_table_list_ := temp_table_list_||temp_table_name_||field_separator_;
      END IF;
   END IF;
   
   IF Custom_Lus_API.Get_Published_Db(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU) = Fnd_Boolean_API.DB_TRUE THEN
      temp_table_name_ := Custom_Lus_API.Get_Table_Name(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU);
      IF temp_table_name_ IS NOT NULL THEN
         temp_table_list_ := temp_table_list_||temp_table_name_||field_separator_;
      END IF;
   END IF;   
$END
   table_list_ := temp_table_list_;
EXCEPTION
   WHEN OTHERS THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Get_Logical_Unit_Tables__;


PROCEDURE Export__ (
   string_           OUT VARCHAR2,
   count_            OUT NUMBER,
   requested_string_ IN NUMBER,
   module_           IN VARCHAR2 )
IS
   TYPE Info_Array_Type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;
   string_array_     Info_Array_Type;
   i_                BINARY_INTEGER := 0;
   table_name_       History_Setting_Tab.table_name%TYPE;
   table_list_       VARCHAR2(2000);
   temp_table_list_  VARCHAR2(2000);
   field_separator_  VARCHAR2(1) := Client_SYS.field_separator_;
   positon_          NUMBER :=-1;
   TYPE tabname_type IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   table_names_      tabname_type;
   table_found_      BOOLEAN;
   table_count_      NUMBER := 0;
   attr_found_       BOOLEAN;
   data_found_       BOOLEAN;
   history_rec_      History_Setting_Tab%ROWTYPE;
   --SOLSETFW
   CURSOR get_units IS
      SELECT lu_name
      FROM   dictionary_sys_active
      WHERE  module = module_
      AND lu_type = 'L'
      ORDER BY lu_name;
   CURSOR get_history_setting(table_ VARCHAR2) IS
      SELECT *
      FROM   history_setting_tab
      WHERE  table_name = table_ ;
   CURSOR get_history_setting_attr(table_ VARCHAR2) IS
      SELECT *
      FROM   history_setting_attribute_tab
      WHERE  table_name = table_ ;
   
   PROCEDURE Pack_Array___ (
      count_ OUT NUMBER,
      index_ IN  BINARY_INTEGER )
   IS
      tmp_  VARCHAR2(32000);
      j_     BINARY_INTEGER := 0;
   BEGIN
      FOR i IN 1..index_ LOOP
         BEGIN
            tmp_ := tmp_ || string_array_(i) || newline_;
            string_array_(i) := NULL;
         EXCEPTION
            WHEN value_error THEN
               j_ := j_ + 1;
               string_array_(j_) := tmp_;
               tmp_ := NULL;
               tmp_ := string_array_(i) || newline_;
         END;
      END LOOP;
      IF (tmp_ IS NOT NULL) THEN
         j_ := j_ + 1;
         string_array_(j_) := tmp_;
      END IF;
      count_ := j_;
   END Pack_Array___;
BEGIN
   IF (requested_string_ = 1) THEN
      data_found_ := FALSE;
      i_ := i_ + 1;
      string_array_(i_) := 'DECLARE' || newline_;
      string_array_(i_) := string_array_(i_) || '   info_msg_   VARCHAR2(32000);' || newline_;
      string_array_(i_) := string_array_(i_) || '   PROCEDURE Import_History_Setting (' || newline_;
      string_array_(i_) := string_array_(i_) || '      table_name_               IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      activate_cleanup_         IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      days_to_keep_             IN NUMBER )' || newline_;
      string_array_(i_) := string_array_(i_) || '   IS' || newline_;
      string_array_(i_) := string_array_(i_) || '   BEGIN' || newline_;
      string_array_(i_) := string_array_(i_) || '      info_msg_ := NULL;' || newline_;
      string_array_(i_) := string_array_(i_) || '      info_msg_ := Message_SYS.Construct(''HISTORY_SETTING_TAB'');' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''TABLE_NAME'', table_name_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''ACTIVATE_CLEANUP'', activate_cleanup_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''DAYS_TO_KEEP'', days_to_keep_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      History_Setting_API.Register(table_name_, info_msg_);' || newline_;
      string_array_(i_) := string_array_(i_) || '   END;' || newline_;
      string_array_(i_) := string_array_(i_) || '   PROCEDURE Import_History_Setting_Attr (' || newline_;
      string_array_(i_) := string_array_(i_) || '      table_name_               IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      column_name_              IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      log_insert_               IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      log_update_               IN VARCHAR2,' || newline_;
      string_array_(i_) := string_array_(i_) || '      log_delete_               IN VARCHAR2 )' || newline_;
      string_array_(i_) := string_array_(i_) || '   IS' || newline_;
      string_array_(i_) := string_array_(i_) || '   BEGIN' || newline_;
      string_array_(i_) := string_array_(i_) || '      info_msg_ := NULL;' || newline_;
      string_array_(i_) := string_array_(i_) || '      info_msg_ := Message_SYS.Construct(''HISTORY_SETTING_ATTRIBUTE_TAB'');' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''TABLE_NAME'', table_name_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''COLUMN_NAME'', column_name_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''LOG_INSERT'', log_insert_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''LOG_UPDATE'', log_update_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      Message_SYS.Add_Attribute(info_msg_, ''LOG_DELETE'', log_delete_);' || newline_;
      string_array_(i_) := string_array_(i_) || '      History_Setting_Attribute_API.Register(table_name_, column_name_,info_msg_);' || newline_;
      string_array_(i_) := string_array_(i_) || '   END;' || newline_;
      string_array_(i_) := string_array_(i_) || 'BEGIN';

      FOR units_ IN get_units LOOP
         Get_Logical_Unit_Tables__(table_list_,units_.lu_name);
         temp_table_list_ := table_list_;
         WHILE temp_table_list_ IS NOT NULL LOOP
            positon_ := instr(temp_table_list_,field_separator_);
            table_name_ := substr(temp_table_list_,1,positon_ -1);
            temp_table_list_ := substr(temp_table_list_,positon_ +1); 
            IF table_name_ IS NOT NULL THEN
               table_found_ := FALSE;
               FOR n IN 1..table_count_ LOOP
                  IF  table_names_(n)= table_name_ THEN
                     table_found_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;

               IF NOT table_found_ THEN
                  table_count_ :=  table_count_ +1;
                  table_names_(table_count_):= table_name_;

                  OPEN get_history_setting(table_name_);
                  FETCH get_history_setting INTO history_rec_;
                  IF (get_history_setting%FOUND) THEN
                     i_ := i_ + 1;
                     string_array_(i_) := '   DELETE FROM  history_setting_tab WHERE table_name = '''|| table_name_ ||''';';
                     i_ := i_ + 1;
                     string_array_(i_) := '   Import_History_Setting( ' || Format___(table_name_) || ',' || Format___(history_rec_.activate_cleanup) || ', '||
                                               history_rec_.days_to_keep  || ');';
                     CLOSE get_history_setting;
                     data_found_ := TRUE;
                  ELSE
                     CLOSE get_history_setting;
                  END IF;


                  attr_found_ := TRUE ;
                  FOR hist_attr_ IN get_history_setting_attr(table_name_) LOOP
                     IF attr_found_ THEN
                        i_ := i_ + 1;
                        string_array_(i_) := '   DELETE FROM  history_setting_attribute_tab WHERE table_name = '''|| table_name_  || ''';';
                        attr_found_ :=  FALSE;
                     END IF;
                     i_ := i_ + 1;
                     string_array_(i_) := '   Import_History_Setting_Attr( ' || Format___(table_name_) || ',' || Format___(hist_attr_.column_name) || ', '||
                                              Format___(hist_attr_.log_insert) || ', ' || Format___(hist_attr_.log_update) || ', ' || 
                                              Format___(hist_attr_.log_delete) ||');';
                     data_found_ := TRUE;
                  END LOOP;
               END IF;

            END IF;
         END LOOP;
      END LOOP;
      IF NOT data_found_ THEN
         i_ := i_ + 1;
         string_array_(i_) := '   NULL;';
      END IF;
      i_ := i_ + 1;
      string_array_(i_) :=  'END;' || newline_;
      string_array_(i_) := string_array_(i_) || '/' || newline_;
      string_array_(i_) := string_array_(i_) || 'COMMIT' || newline_ || '/' || newline_;
      Pack_Array___(count_, i_);
      string_ := string_array_(1);
   ELSE
      string_ := string_array_(requested_string_);
   END IF;
END Export__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enable
IS
BEGIN
   Fnd_Context_SYS.Set_Value('History_Setting_Util_API.history_enabled_', TRUE);
END Enable;


PROCEDURE Disable
IS
BEGIN
   Fnd_Context_SYS.Set_Value('History_Setting_Util_API.history_enabled_', FALSE);
END Disable;


@UncheckedAccess
FUNCTION Is_Enabled RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Context_SYS.Find_Boolean_Value('History_Setting_Util_API.history_enabled_', TRUE));
END Is_Enabled;


PROCEDURE Generate_Triggers_For_Module ( 
   module_name_ IN VARCHAR2 )
IS
   lu_list_          VARCHAR2(32000);
   table_list_       VARCHAR2(32000);

   num_lu_           NUMBER;
   num_tables_       NUMBER;     

   logical_units_    Utility_SYS.STRING_TABLE;
   tables_           Utility_SYS.STRING_TABLE;

   field_separator_       VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN

   Trace_SYS.Message('Generating triggers for module: ' || module_name_);

   Dictionary_SYS.Enum_Module_Logical_Units_ ( lu_list_, module_name_ );
   Utility_Sys.Tokenize(lu_list_, field_separator_, logical_units_, num_lu_ );

   FOR lu_counter_ IN 1..num_lu_ LOOP
      Get_Logical_Unit_Tables__( table_list_, logical_units_ ( lu_counter_ ) );
      Utility_Sys.Tokenize(table_list_, field_separator_, tables_, num_tables_ );
      
      FOR table_counter_ IN 1..num_tables_ LOOP
         Generate_Triggers__ ( module_name_, 
                               logical_units_ ( lu_counter_ ),
                               tables_ ( table_counter_ ) );
      END LOOP; -- Per table
   END LOOP; -- Per Lu
END Generate_Triggers_For_Module;

PROCEDURE Regenerate_Triggers (
   module_name_ IN VARCHAR2,
   lu_name_     IN VARCHAR2,
   table_name_  IN VARCHAR2 )
IS
   temp_ NUMBER;
BEGIN
   SELECT 1 INTO temp_
   FROM dual
   WHERE EXISTS (SELECT 1 FROM history_setting_attribute_tab where table_name = table_name_
                 AND (log_update= '1' OR log_insert = '1' OR log_delete = '1'));

   IF temp_ = '1' THEN
      Generate_Triggers__(module_name_, lu_name_, table_name_);
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Regenerate_Triggers;

PROCEDURE Remove_Dropped_Columns (
   table_name_  IN VARCHAR2 )
IS
BEGIN
   DELETE FROM history_setting_attribute_tab a
   WHERE table_name = table_name_
   AND NOT EXISTS (SELECT 1 FROM user_tab_cols WHERE a.table_name = table_name AND a.column_name = column_name);
END Remove_Dropped_Columns;

PROCEDURE Refresh_Settings(
   module_name_ IN VARCHAR2,
   lu_name_     IN VARCHAR2,
   table_name_  IN VARCHAR2 )
IS
BEGIN
   Remove_Dropped_Columns(table_name_);
   Regenerate_Triggers(module_name_, lu_name_, table_name_);
END Refresh_Settings;

PROCEDURE Get_History_Log_Triggers (
   result_ OUT CLOB,
   table_name_ IN VARCHAR2)
IS
   stmt_ VARCHAR2(32000) := 'SELECT column_name,log_insert, log_update, log_delete
                               FROM History_Setting_Attribute_TAB
                              WHERE table_name ='''||table_name_||'''' ;
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   XMLTAG_HISTORY_LOG  CONSTANT VARCHAR2(50)  := 'HISTORY_LOG';
   XMLTAG_COL_SETTING  CONSTANT VARCHAR2(50)  := 'COLUMN_SETTING';
   xpath_   CONSTANT VARCHAR2(100):= '/'||XMLTAG_HISTORY_LOG||'/'||XMLTAG_COL_SETTING||'[1]';
BEGIN
   Assert_Sys.Assert_Is_Table(table_name_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_HISTORY_LOG);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_COL_SETTING);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TABLE_NAME', table_name_ , xpath_);
   Utility_SYS.XmlType_To_CLOB(result_, xml_);
END Get_History_Log_Triggers;

-- History Log's Key Ref is a bit different to the normal Key Ref
-- Use this method when generating a key ref to compared to a History Log Key Ref entry
FUNCTION Get_History_Log_Key_Ref(
   lu_name_       IN VARCHAR2,
   rowid_         IN VARCHAR2,
   in_table_name_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   name_list_view_  VARCHAR2(32000);
   name_list_table_ VARCHAR2(32000);
   key_ref_sql_     VARCHAR2(32000);
   key_ref_         VARCHAR2(32000);
   table_name_      VARCHAR2(128);
   stmt_            VARCHAR2(32000);
   cursor_     NUMBER;
   ignore_     NUMBER;
BEGIN
   IF in_table_name_ IS NOT NULL THEN
      Assert_SYS.Assert_Is_Table(in_table_name_);
      table_name_ := in_table_name_;
   ELSE
      table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   END IF;
   Client_SYS.Get_Key_Reference(name_list_view_, lu_name_);
   Client_SYS.Get_Table_Key_Reference(name_list_table_, lu_name_);
   
   key_ref_sql_ := Generate_Key_List___(name_list_view_, name_list_table_, NULL, table_name_, lu_name_, 'I');
   stmt_ := 'SELECT '||key_ref_sql_||' FROM '||table_name_||' WHERE ROWID = :rowid_';
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2018-01-12,chmulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.define_column(cursor_, 1, key_ref_, 32000);
   dbms_sql.bind_variable(cursor_, 'rowid_', rowid_);
   --fetch should return only one row
   ignore_ := dbms_sql.execute_and_fetch(cursor_, TRUE);
   dbms_sql.column_value(cursor_, 1, key_ref_);
   dbms_sql.close_cursor(cursor_);
   
   RETURN key_ref_;
END Get_History_Log_Key_Ref;
