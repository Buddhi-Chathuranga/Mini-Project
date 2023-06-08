-----------------------------------------------------------------------------
--
--  Logical unit: FndEvent
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971009  ERFO  Reviewed for Foundation1 Release 2.0.0 (ToDo #1676).
--  971013  ERFO  Made attribute EVENT_ID uppercase.
--  980223  ERFO  Removed Set_Event_Enabled in method Refresh and added
--                validation when setting event enabled (ToDo #2144).
--  980310  ERFO  Set event_enable to FALSE in method Refresh and
--                ensure a correct error message in method Update___.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030214  ROOD  Replaced usage of fnd_event_action_tab with the view (ToDo#4149).
--  060623  RARU  Moved the select statement into a cursor in Update__.
--  070212  HAAR  Added support for Custom Defined Events (Bugg#61780).
--  080101  SUMA  Changed the :new to old when inserting new recs.(Bug#70269).
--  080228  SUMA  Added Create_Trigger_Name function to aviod special chars(Bug#71099)
--  080925  HAAR  Renamed parameters for Custom Defined Events (Bug#77334).
--                New value: NEW:COLUMN_NAME => NEW:IDENTITY
--                Old value: OLD:COLUMN_NAME => OLD:IDENTITY
--  090114  HAAR  Added methods for Export/Import Export__ and Register_Custom_Event (Bug#79673).
--  091109  NABA  Added the check for event_id as a valid identifier (Bug#86681)
--  110727  CHMU  Escaped quotes in event description and custom attributes in events
--                and added COMMIT when exporting to file (Bug#95454). 
--  120926  DUWI  Added new function Check_Custom_Event (Bug#104703)
--  121130  CHMU  Changed global declaration of date,time,datetime format varaibles. (Bug#105120
--  191025  PABNLK PACCS-2255: 'Export_Custom_Event' method implemented.
--  191028  PABNLK PACCS-2255: 'Get_Logical_Unit_Tables' method implemented.
--  191106  PABNLK PACCS-1183: 'Check_Date_Period' method implemented.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Table_Detail_Rec IS RECORD (
   tab_name             VARCHAR2(128)
);

TYPE Table_Detail_Arr IS TABLE OF Table_Detail_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

datetime_format_ CONSTANT VARCHAR2(40) := 'YYYY-MM-DD-HH24.MI.SS';

date_format_     CONSTANT VARCHAR2(40) := 'YYYY-MM-DD';

time_format_     CONSTANT VARCHAR2(40) := 'HH24.MI.SS';

EXPORT_DEF_VERSION      CONSTANT VARCHAR2(5)   := '1.0';
XMLTAG_CUST_EVE_PAR     CONSTANT VARCHAR2(50)  := 'EVENT_PARAMETERS';
XMLTAG_CUST_OBJ_EXP     CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_CUSTOM_EVENT     CONSTANT VARCHAR2(50)  := 'CUSTOM_EVENT';
XMLTAG_CUST_OBJ_EXP_DEF_VER CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';

CURSOR get_event_header(xml_ Xmltype) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_EVENT' passing xml_
                         COLUMNS
                            EXPORT_DEF_VERSION VARCHAR2(30) path 'EXPORT_DEF_VERSION',
                            EVENT_LU_NAME VARCHAR2(25) path 'EVENT_LU_NAME',
                            EVENT_ID VARCHAR2(32) path 'EVENT_ID',
                            EVENT_DESCRIPTION VARCHAR2(256) path 'EVENT_DESCRIPTION',
                            EVENT_ENABLE VARCHAR2(100) path 'EVENT_ENABLE',
                            EVENT_TABLE_NAME VARCHAR2(30) path 'EVENT_TABLE_NAME',
                            MODIFIED_ATTRIBUTES VARCHAR2(4000) path 'MODIFIED_ATTRIBUTES',
                            EVENT_TYPE VARCHAR2(20) path 'EVENT_TYPE_DB', 
                            NEW_ROW VARCHAR2(5) path 'NEW_ROW_DB',
                            MODIFY_ROW VARCHAR2(5) path 'MODIFY_ROW_DB',
                            REMOVE_ROW VARCHAR2(5) path 'REMOVE_ROW_DB',
                            EVENT_TRIGGER_TYPE VARCHAR2(20) path 'EVENT_TRIGGER_TYPE_DB',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            ROWKEY VARCHAR2(100) PATH 'OBJKEY'
                        ) xt1; 

TYPE Table_Event_Param_Arr IS TABLE OF Fnd_Event_Parameter_Tab%ROWTYPE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Import_New___ (
   newrec_ IN OUT fnd_event_tab%ROWTYPE)
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   emptyrec_      fnd_event_tab%ROWTYPE;
BEGIN
   indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Set_Server_Values___(newrec_);
   
   newrec_.rowversion := sysdate;
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   newrec_.event_id := upper(newrec_.event_id);
   INSERT
      INTO fnd_event_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Between_Str(Utility_SYS.Between_Str(sqlerrm, '(', ')'), '.', ')', 'FALSE');
      BEGIN
         IF (constraint_ = 'FND_EVENT_RK') THEN
            Error_SYS.Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSE
            Raise_Record_Exist___(newrec_);
         END IF;
      END;
END Import_New___;
   
PROCEDURE Create_Custom_Trigger___(
   rec_           IN     Fnd_Event_Tab%ROWTYPE,
   trigger_type_  IN     VARCHAR2,
   params_        IN Table_Event_Param_Arr )
   -- this function is invoked within a secondary transaction; uncommitted data in 
   -- the parent transaction is not accessible and must be provided explicitly
IS
   stmt_                 CLOB;
   old_param_prefix_     VARCHAR2(10);
   new_param_prefix_     VARCHAR2(10);
   format_prefix_        VARCHAR2(30);
   format_postfix_       VARCHAR2(30);
   if_stmt_start_        CLOB;
   if_stmt_end_          VARCHAR2(32000);
   indent_               NUMBER;
   trigger_size_exceeded EXCEPTION;
   PRAGMA                EXCEPTION_INIT(trigger_size_exceeded, -20105);
   trigger_name_         VARCHAR2(30) := Get_Trigger_Name___(rec_.event_id, trigger_type_);
   --
   FUNCTION space___ (
      indent_  IN NUMBER ) RETURN VARCHAR2 DETERMINISTIC
   IS
   BEGIN
      RETURN (CHR(13) || CHR(10) || LPAD(' ', indent_ * 3));
   END space___;
   --
   FUNCTION Get_Dml_Event___(
      trigger_type_        IN VARCHAR2 ) RETURN VARCHAR2 DETERMINISTIC
   IS
   BEGIN
      CASE trigger_type_
         WHEN 'NEW' THEN
            RETURN('INSERT');
         WHEN 'MODIFY' THEN
            RETURN('UPDATE');
         WHEN 'REMOVE' THEN
            RETURN('DELETE');
      END CASE;
   END Get_Dml_Event___;
   --
   FUNCTION Get_Columns___ (
      column_list_ IN VARCHAR2 ) RETURN Installation_SYS.ColumnTabType
   IS
      pos_              BINARY_INTEGER       := 1;
      start_            BINARY_INTEGER       := 1;
      tmp_column_list_  VARCHAR2(32000)      := column_list_;
      separator_        CONSTANT VARCHAR2(2) := ';';
      column_name_      VARCHAR2(30);
      columns_          Installation_SYS.ColumnTabType;
   BEGIN
      IF column_list_ IS NULL THEN
         RETURN(columns_);
      END IF;
      pos_ := Instr(tmp_column_list_, separator_, pos_);
      LOOP
         -- Find column name
         column_name_ := Substr(tmp_column_list_, start_, pos_ - start_);
         IF column_name_ IS NOT NULL THEN
            Installation_SYS.Set_Table_Column(columns_, column_name_);
         END IF;
         -- Find new attribute
         start_ := pos_ + 1;
         pos_   := Instr(tmp_column_list_, separator_, start_);
         IF pos_ = 0 THEN
            pos_ := length(tmp_column_list_);
            -- Find column name
            column_name_ := Substr(tmp_column_list_, start_);
            Installation_SYS.Set_Table_Column(columns_, column_name_);
            EXIT;
         END IF;
      END LOOP;
      RETURN(columns_);
   END Get_Columns___;
   --
   FUNCTION Create_If_Stmt___ (
      column_list_ IN VARCHAR2 ) RETURN CLOB
   IS
      found_            BOOLEAN              := FALSE;
      i_                BINARY_INTEGER       := 0;
      pos_              BINARY_INTEGER       := 1;
      start_            BINARY_INTEGER       := 1;
      tmp_column_list_  VARCHAR2(32000)      := column_list_;
      statemnt_         CLOB;
      separator_        CONSTANT VARCHAR2(2) := ';';
      column_name_      VARCHAR2(30);
   BEGIN
      IF column_list_ IS NULL THEN
         RETURN(NULL);
      END IF;
      -- Find all attributes 
      pos_ := Instr(tmp_column_list_, separator_, pos_);
      i_   := i_ + 1;
	  IF (tmp_column_list_ IS NOT NULL) THEN
         statemnt_ := statemnt_ || 'IF ';
      END IF;
      LOOP
         IF (i_ > 1) THEN
            statemnt_ := statemnt_||space___(indent_)||' OR ';
         END IF;
         -- Find column name
         column_name_ := Substr(tmp_column_list_, start_, pos_ - start_);
         IF column_name_ IS NOT NULL THEN
            found_   := TRUE;
            indent_  := indent_ + 1;
            statemnt_ := statemnt_ ||space___(indent_)||'Validate_SYS.Is_Changed(:OLD.'||column_name_||', :NEW.'||column_name_||')';
         END IF;
         -- Find new attribute
         start_ := pos_ + 1;
         pos_   := Instr(tmp_column_list_, separator_, start_);
         i_     := i_ + 1;
         IF pos_ = 0 THEN
            IF (i_ > 1 AND found_) THEN
               statemnt_ := statemnt_||space___(indent_)||' OR ';
            END IF;
            pos_ := length(tmp_column_list_);
            -- Find column name
            column_name_ := Substr(tmp_column_list_, start_);
            indent_  := indent_ + 1;
            statemnt_ := statemnt_ ||space___(indent_)||'Validate_SYS.Is_Changed(:OLD.'||column_name_||', :NEW.'||column_name_||')';
			statemnt_ := statemnt_||space___(indent_)||' THEN ';
            EXIT;
         END IF;
      END LOOP;
      RETURN(statemnt_);
   END Create_If_Stmt___;
   --
   FUNCTION Replace_Parameter___ (
      plsql_method_ IN VARCHAR2,
      params_       IN Table_Event_Param_Arr) RETURN VARCHAR2
   IS
      pos_              BINARY_INTEGER       := 1;
      method_           VARCHAR2(32000)      := plsql_method_;
      param_marker_     CONSTANT VARCHAR2(2) := chr(38);
   BEGIN
      pos_ := Instr(method_, param_marker_);
      IF (pos_ = 0) THEN
         RETURN(method_);
      END IF;
      -- Replace all parameters used as parameters to PL/SQL method
      FOR i IN 1 .. params_.count LOOP
         IF params_(i).current_value = 'TRUE' THEN
            method_ := replace(method_, param_marker_||'OLD:'||params_(i).id, old_param_prefix_||params_(i).id);
         END IF;
         IF params_(i).new_value = 'TRUE' THEN
            method_ := replace(method_, param_marker_||'NEW:'||params_(i).id, new_param_prefix_||params_(i).id);
         END IF;
         pos_ := Instr(method_, param_marker_);
         IF pos_ = 0 THEN
            RETURN(method_);
         END IF;
      END LOOP;
      RETURN(method_);
   END Replace_Parameter___;
BEGIN
--   indent_ := 1;
   CASE trigger_type_
      WHEN 'NEW' THEN
         new_param_prefix_ := ':NEW.';
         old_param_prefix_ := ':OLD.';
      WHEN 'MODIFY' THEN
         new_param_prefix_ := ':NEW.';
         old_param_prefix_ := ':OLD.';
         -- Build IF statement for modify
         indent_ := 1;
         if_stmt_start_ := Create_If_Stmt___(rec_.modified_attributes);
		 IF (if_stmt_start_ IS NOT NULL) THEN
            indent_        := 1;
            if_stmt_end_   := 'END IF; ';
         ELSE
            indent_        := 0;
            if_stmt_end_   := NULL;
         END IF;
         stmt_ := if_stmt_start_;
      WHEN 'REMOVE' THEN
         new_param_prefix_ := ':OLD.';
         old_param_prefix_ := ':OLD.';
   END CASE;
   indent_        := 0;
   -- Build PL/SQL statement
   stmt_ := stmt_ ||space___(indent_)||'DECLARE';
   indent_ := indent_ + 1;
   stmt_ := stmt_ ||space___(indent_)||'msg_  VARCHAR2(32767);';
   indent_ := indent_ - 1;
   stmt_ := stmt_ ||space___(indent_)||'BEGIN ';
   indent_ := indent_ + 1;
   stmt_ := stmt_ ||space___(indent_)||'IF (Event_SYS.Event_Enabled('''||rec_.event_lu_name||''', '''||rec_.event_id||''')) THEN ';
   indent_ := indent_ + 1;
   stmt_ := stmt_ ||space___(indent_)||'msg_ := Message_SYS.Construct('''||rec_.event_id||''');';
   stmt_ := stmt_ ||space___(indent_)||'Message_SYS.Add_Attribute(msg_, ''LU'', '''||rec_.event_lu_name||''');';
   IF (Database_SYS.Column_Exist(rec_.event_table_name, 'ROWKEY')) THEN
      stmt_ := stmt_ ||space___(indent_)||'Message_SYS.Add_Attribute(msg_, ''ROWKEY'', '||new_param_prefix_||'ROWKEY);';
   END IF;
   FOR i IN 1 .. params_.count LOOP
      IF (params_(i).id_type = 'DATETIME') THEN
         format_prefix_  := 'to_char(';
         format_postfix_ := ', '''||datetime_format_||''')';
      ELSIF (params_(i).id_type = 'DATE') THEN
         format_prefix_  := 'to_char(';
         format_postfix_ := ', '''||date_format_||''')';
      ELSIF (params_(i).id_type = 'TIME') THEN
         format_prefix_  := 'to_char(';
         format_postfix_ := ', '''||time_format_||''')';
      ELSE
         format_prefix_  := NULL;
         format_postfix_ := NULL;
      END IF;
      --
      IF params_(i).plsql_method IS NOT NULL THEN
         stmt_ := stmt_ ||space___(indent_)||'Message_SYS.Add_Attribute(msg_, '''||params_(i).id||''', '||
                          format_prefix_||Replace_Parameter___(params_(i).plsql_method, params_)||format_postfix_||');';
      ELSE
         IF params_(i).current_value = 'TRUE' THEN
            stmt_ := stmt_ ||space___(indent_)||'Message_SYS.Add_Attribute(msg_, ''OLD:'||params_(i).id||''', '||format_prefix_||old_param_prefix_||params_(i).id||format_postfix_||');';
         END IF;
         IF params_(i).new_value = 'TRUE' THEN
            stmt_ := stmt_ ||space___(indent_)||'Message_SYS.Add_Attribute(msg_, ''NEW:'||params_(i).id||''', '||format_prefix_||new_param_prefix_||params_(i).id||format_postfix_||');';
         END IF;
      END IF;
   END LOOP;
   stmt_ := stmt_ ||space___(indent_)||'Event_SYS.Event_Execute('''||rec_.event_lu_name||''', '''||rec_.event_id||''', msg_);';
   indent_ := indent_ - 1;
   stmt_ := stmt_ ||space___(indent_)||'END IF; ';
   indent_ := indent_ - 1;
   stmt_ := stmt_ ||space___(indent_)||'END; ';
   indent_ := indent_ - 1;
   stmt_ := stmt_ ||space___(indent_)||if_stmt_end_;
   
   IF DBMS_Lob.Getlength(stmt_)<30000 THEN
      Log_SYS.Fnd_Trace_(Log_SYS.trace_, stmt_);
      Installation_SYS.Create_Trigger (
         Get_Trigger_Name___(rec_.event_id, trigger_type_),
         rec_.event_trigger_type,
         Get_Dml_Event___(trigger_type_),
         Get_Columns___(rec_.modified_attributes),
         rec_.event_table_name,
         NULL,
         stmt_,
         TRUE);
   ELSE
      RAISE trigger_size_exceeded;
   END IF;

   EXCEPTION
   WHEN trigger_size_exceeded THEN
      Error_SYS.Appl_General(lu_name_,'TRIG_MAX_SIZE: [:P1] trigger definition exceeds the 32000 character limit.', trigger_name_);
   WHEN OTHERS THEN
   DECLARE      
      err_msg_        VARCHAR2(200) := SUBSTR(SQLERRM, 1, 200);
      newline_        CONSTANT VARCHAR2(2) := chr(13)||chr(10);
      CURSOR get_error IS
            SELECT SUBSTR(text, 1, 200)
            FROM   user_errors
            WHERE  name = trigger_name_;
   BEGIN          
      OPEN get_error;
      FETCH get_error INTO err_msg_;
      CLOSE get_error;      
      Error_SYS.Appl_General(lu_name_,'TRIGGER_ERR: Cannot Enable Event. Error creating trigger for Event [:P1]. The Event is not deployed correctly. Review the custom attributes to make sure they are specified correct. ' || newline_ || newline_ || err_msg_ , rec_.event_id );
   END;

END Create_Custom_Trigger___;


PROCEDURE Create_Custom_Triggers___(
   rec_    IN Fnd_Event_Tab%ROWTYPE,
   params_ IN Table_Event_Param_Arr )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   -- this function generates a secondary child transaction in which the DDL changes will be made
   -- uncommitted data in the parent transaction is not accessible and must be provided explicitly
BEGIN
   -- Create triggers per type (New, Modify, Remove)
   IF (rec_.new_row = 'TRUE') THEN
      Create_Custom_Trigger___(rec_, 'NEW', params_);
   END IF;
   IF (rec_.modify_row = 'TRUE') THEN
      Create_Custom_Trigger___(rec_, 'MODIFY', params_);
   END IF;
   IF (rec_.remove_row = 'TRUE') THEN
      Create_Custom_Trigger___(rec_, 'REMOVE', params_);
   END IF;
END Create_Custom_Triggers___;


FUNCTION Get_Trigger_Name___(
   event_id_      IN VARCHAR2,
   trigger_type_  IN VARCHAR2 ) RETURN VARCHAR2 DETERMINISTIC 
   -- this function may be invoked within a secondary transaction
IS
BEGIN
   CASE trigger_type_
      WHEN 'NEW' THEN
         RETURN(Upper(Create_Trigger_Name___(event_id_)||'_EVI'));
      WHEN 'MODIFY' THEN
         RETURN(Upper(Create_Trigger_Name___(event_id_)||'_EVU'));
      WHEN 'REMOVE' THEN
         RETURN(Upper(Create_Trigger_Name___(event_id_)||'_EVD'));
   END CASE;
END Get_Trigger_Name___;


PROCEDURE Remove_Custom_Trigger___(
   rec_           IN     Fnd_Event_Tab%ROWTYPE,
   trigger_type_  IN     VARCHAR2 )
   -- this function is invoked within a secondary transaction; uncommitted data in 
   -- the parent transaction is not accessible and must be provided explicitly
IS
   --
BEGIN
   Installation_SYS.Remove_Trigger(Get_Trigger_Name___(rec_.event_id, trigger_type_), TRUE);
END Remove_Custom_Trigger___;


PROCEDURE Remove_Custom_Triggers___(
   rec_ IN Fnd_Event_Tab%ROWTYPE )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   -- this function generates a secondary child transaction in which the DDL changes will be made
   -- uncommitted data in the parent transaction is not accessible and must be provided explicitly
BEGIN
   -- Create triggers per type (New, Modify, Remove)
   IF (rec_.new_row = 'TRUE') THEN
      Remove_Custom_Trigger___(rec_, 'NEW');
   END IF;
   IF (rec_.modify_row = 'TRUE') THEN
      Remove_Custom_Trigger___(rec_, 'MODIFY');
   END IF;
   IF (rec_.remove_row = 'TRUE') THEN
      Remove_Custom_Trigger___(rec_, 'REMOVE');
   END IF;
END Remove_Custom_Triggers___;


FUNCTION Create_Trigger_Name___ (
   event_id_ IN VARCHAR2 ) RETURN VARCHAR2 DETERMINISTIC
   -- this function may be invoked within a secondary transaction
IS
   new_event_id_ VARCHAR2(100);
BEGIN
   new_event_id_ := Replace(event_id_, ' ', '_');
   new_event_id_ := Replace(new_event_id_, '/', '_');
   new_event_id_ := Replace(new_event_id_, '\', '_');
   new_event_id_ := Replace(new_event_id_, '-', '_');
   RETURN new_event_id_;
END Create_Trigger_Name___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('EVENT_TYPE_DB', 'CUSTOM', attr_);
   Client_SYS.Add_To_Attr('EVENT_TYPE', Fnd_Event_Type_API.Decode('CUSTOM'), attr_);
   Client_SYS.Add_To_Attr('NEW_ROW_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('NEW_ROW', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('MODIFY_ROW_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('MODIFY_ROW', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('REMOVE_ROW_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('REMOVE_ROW', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('EVENT_ENABLE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('EVENT_TRIGGER_TYPE_DB', Event_Trigger_Type_API.DB_AFTER, attr_);
   Client_SYS.Add_To_Attr('EVENT_TRIGGER_TYPE', Event_Trigger_Type_API.Decode(Event_Trigger_Type_API.DB_AFTER), attr_);
END Prepare_Insert___;

PROCEDURE Set_Server_Values___ (
   newrec_ IN OUT FND_EVENT_TAB%ROWTYPE )
IS
BEGIN
   newrec_.event_trigger_type := nvl(newrec_.event_trigger_type, Event_Trigger_Type_API.DB_AFTER);
   IF newrec_.definition_modified_date IS NULL THEN
      newrec_.definition_modified_date := sysdate;
   END IF;
END Set_Server_Values___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_EVENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Set_Server_Values___(newrec_);
   --
   IF (nvl(newrec_.event_enable, 'FALSE') = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'ENERR_I: Can not enable event with no actions enabled.');
   END IF;
   --
   
   super(objid_, objversion_, newrec_, attr_);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_EVENT_TAB%ROWTYPE,
   newrec_     IN OUT FND_EVENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   dummy_ NUMBER;
   msg_               VARCHAR2(4000);

   -- copied from Mobile_Client_Sys to avoid circular dependencies
   MOBILE_FW_CONTEXT CONSTANT VARCHAR2(20)          := 'MOBILE_FW_CONTEXT';

   CURSOR get_event_count IS
   SELECT COUNT(*)
     FROM fnd_event_action_tab
     WHERE event_lu_name = newrec_.event_lu_name
     AND   event_id = newrec_.event_id
     AND   action_enable = 'TRUE';
BEGIN
   IF (nvl(oldrec_.event_enable, 'FALSE') = 'FALSE' AND newrec_.event_enable = 'TRUE') THEN
      OPEN  get_event_count;
      FETCH get_event_count INTO dummy_;
      CLOSE get_event_count;
      IF (dummy_ = 0) THEN
         Error_SYS.Appl_General(lu_name_, 'ENERR_I: Can not enable event with no actions enabled.');
      END IF;
   END IF;
   newrec_.event_trigger_type := nvl(newrec_.event_trigger_type, Event_Trigger_Type_API.DB_AFTER);
--
-- throw change event enabled changed
   IF(oldrec_.event_enable IS NULL OR nvl(oldrec_.event_enable, 'FALSE') != newrec_.event_enable) THEN      
      IF (NOT Installation_Sys.Get_Installation_Mode) AND (Fnd_Session_API.Get_Init_Context_(MOBILE_FW_CONTEXT) <> MOBILE_FW_CONTEXT) THEN
         msg_ := Message_SYS.Construct('EVENT_ENABLE_CHANGE' );
         Message_SYS.Add_Attribute(msg_, 'EVENT_LU_NAME', newrec_.event_lu_name );
         Message_SYS.Add_Attribute(msg_, 'EVENT_ID', newrec_.event_id );
         Message_SYS.Add_Attribute(msg_, 'EVENT_ENABLE', newrec_.event_enable );
         Message_SYS.Add_Attribute(msg_, 'ROWVERSION', newrec_.rowversion );
         Message_SYS.Add_Attribute(msg_, 'ROWKEY', newrec_.rowkey );

         Event_SYS.Event_Execute('FndEvent', 'EVENT_ENABLE_CHANGE', msg_);
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
    -- make sure to remove Custom Defined triggers
   IF (newrec_.event_type = 'CUSTOM') THEN
      IF (newrec_.event_enable <> 'TRUE') THEN
         Remove_Custom_Triggers___(oldrec_);
      ELSE
         -- Remove any unused NEW/MODIFY/DELETE trigger
         Refresh_Active_Triggers___ (oldrec_, newrec_);
      END IF;
   END IF;
   -- Update all actions with parameters
   -- This is required when importing new custom event from old event export file.
   Fnd_Event_Action_API.Update_Action(newrec_.event_lu_name, newrec_.event_id, NULL);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_EVENT_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Remove Custom Defined triggers
   IF (remrec_.event_type = 'CUSTOM') THEN
      Remove_Custom_Triggers___(remrec_);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.event_enable := 'FALSE';
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Valid_Identifier('EVENT_ID', newrec_.event_id); 
   newrec_.event_id := Upper(newrec_.event_id);
END Check_Insert___;


PROCEDURE Refresh_Active_Triggers___ (
   oldrec_ fnd_event_tab%ROWTYPE,
   newrec_ fnd_event_tab%ROWTYPE)
IS
BEGIN
   IF newrec_.event_enable = 'TRUE' THEN
      IF newrec_.new_row = 'FALSE' AND oldrec_.new_row = 'TRUE' THEN
         Remove_Custom_Trigger___(newrec_, 'NEW');
      END IF;
      IF newrec_.modify_row = 'FALSE' AND oldrec_.modify_row = 'TRUE' THEN
         Remove_Custom_Trigger___(newrec_, 'MODIFY');
      END IF;
      IF newrec_.remove_row = 'FALSE' AND oldrec_.remove_row = 'TRUE' THEN
         Remove_Custom_Trigger___(newrec_, 'REMOVE');
      END IF;
   END IF;
END Refresh_Active_Triggers___;

FUNCTION Has_Definition_Changed___(
   oldrec_ IN fnd_event_tab%ROWTYPE,
   newrec_ IN fnd_event_tab%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   IF validate_sys.is_different(oldrec_.event_description, newrec_.event_description) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.event_enable, newrec_.event_enable) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.event_table_name, newrec_.event_table_name) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.event_type, newrec_.event_type) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.modified_attributes, newrec_.modified_attributes) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.new_row, newrec_.new_row) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.modify_row, newrec_.modify_row) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.remove_row, newrec_.remove_row) THEN
      RETURN TRUE;
   ELSIF validate_sys.is_different(oldrec_.event_trigger_type, newrec_.event_trigger_type) THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Has_Definition_Changed___;

PROCEDURE Check_Package___ (
   remrec_ IN fnd_event_tab%ROWTYPE )
IS
   package_name_ VARCHAR2(100);
BEGIN
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: The Custom Event ":P1" cannot be deleted, unless removed from the package ":P2".', remrec_.event_id, package_name_);
   END IF;   
END Check_Package___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN fnd_event_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(remrec_);
   Check_Package___(remrec_);
END Check_Delete___;

FUNCTION Validate_Event___ (
   info_          IN OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_   IN OUT App_Config_Util_API.DeploymentObjectArray,
   rec_ fnd_event_tab%ROWTYPE ) RETURN BOOLEAN
IS
   validate_ BOOLEAN := TRUE;
BEGIN
   IF NOT App_Config_Util_API.Table_Exist(rec_.event_table_name, dep_objects_) THEN
      validate_ := FALSE;
      Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'TABLENOTEXIST: Error: Table ":P1" does not exist', Fnd_Session_API.Get_Language, rec_.event_table_name), TRUE);
   END IF;   
   RETURN validate_; 
END Validate_Event___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Export__ (
   string_        OUT CLOB,
   event_lu_name_ IN  VARCHAR2,
   event_id_      IN  VARCHAR2 )
IS
   newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);
   rec_                  FND_EVENT_TAB%ROWTYPE;
   id_                  VARCHAR2(100);
   CURSOR get_param IS
   SELECT id, id_type, plsql_method, current_value, new_value
     FROM fnd_event_parameter_tab
    WHERE event_lu_name = event_lu_name_
      AND event_id = event_id_;
BEGIN
   -- Fetch the event details
   rec_     := Get_Object_By_Keys___(event_lu_name_, event_id_);
   -- Only allowed to export Custom Events
   IF (nvl(rec_.event_type, 'APPLICATION') != 'CUSTOM') THEN
      Error_SYS.Appl_General(lu_name_, 'EXP_TYPE: Only Custom Events are allowed to be exported.');
   END IF;
   --
   -- Create Export file
   --
   string_ :=            '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || '-- Export file for Custom Events ' || rec_.event_id || '.' || newline_;
   string_ := string_ || '-- ' || newline_;
   string_ := string_ || '--  Date    Sign    History' || newline_;
   string_ := string_ || '--  ------  ------  -----------------------------------------------------------' || newline_;
   string_ := string_ || '--  ' || to_char(sysdate, 'YYMMDD') || '  ' || rpad(Fnd_Session_API.Get_Fnd_User, 6, ' ') || '  ' ||
                         'Export file for task ' || rec_.event_id || '.' || newline_;
   string_ := string_ || '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || newline_;
   string_ := string_ || 'SET DEFINE ~' || newline_;
   string_ := string_ || 'PROMPT Register Custom Event "' || rec_.event_id || '"' || newline_;
   string_ := string_ || 'DECLARE' || newline_;
   string_ := string_ || '   event_lu_name_      VARCHAR2(30)    := ''' || event_lu_name_ || ''';' || newline_;
   string_ := string_ || '   event_id_           VARCHAR2(30)    := Database_SYS.Unistr(''' || Database_SYS.Asciistr(event_id_) || ''');' || newline_;
   string_ := string_ || '   id_                 VARCHAR2(100);' || newline_;
   string_ := string_ || '   info_msg_           VARCHAR2(32000) := NULL;' || newline_;
   string_ := string_ || 'BEGIN' || newline_;
   --
   -- Create Main Message
   --
   string_ := string_ || '-- Construct Main Message' || newline_;
   string_ := string_ || '   info_msg_    := Message_SYS.Construct('''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''EVENT_DESCRIPTION'', Database_SYS.Unistr(''' || Database_SYS.Asciistr(Assert_SYS.Encode_Single_Quote_String(rec_.event_description)) || '''));' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''EVENT_ENABLE'', ''FALSE'');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''EVENT_TYPE_DB'', ''' || rec_.event_type || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''EVENT_TABLE_NAME'', ''' || rec_.event_table_name || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''EVENT_TRIGGER_TYPE_DB'', ''' || Nvl(rec_.event_trigger_type, Event_Trigger_Type_API.DB_AFTER) || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''MODIFIED_ATTRIBUTES'', ''' || rec_.modified_attributes || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''NEW_ROW_DB'', ''' || rec_.new_row || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''MODIFY_ROW_DB'', ''' || rec_.modify_row || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''REMOVE_ROW_DB'', ''' || rec_.remove_row || ''');' || newline_;
   string_ := string_ || '-- Register Custom Event' || newline_;
   string_ := string_ || '   Fnd_Event_API.Register_Custom_Event(event_lu_name_, event_id_, info_msg_);' || newline_;
   FOR rec2 IN get_param LOOP
      string_ := string_ || '   -- Register Event Parameter' || newline_;
      string_ := string_ || '      info_msg_ := Message_SYS.Construct('''');' || newline_;
      string_ := string_ || '      id_  := Database_SYS.Unistr(''' || Database_SYS.Asciistr(rec2.id) || ''');' || newline_;
      string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''ID_TYPE'', ''' || rec2.id_type || ''');' || newline_;
      string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''PLSQL_METHOD'', Database_SYS.Unistr(''' || Database_SYS.Asciistr(Assert_SYS.Encode_Single_Quote_String(rec2.plsql_method)) || '''));' || newline_;
      string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''CURRENT_VALUE_DB'', ''' || rec2.current_value || ''');' || newline_;
      string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''NEW_VALUE_DB'', ''' || rec2.new_value || ''');' || newline_;
      string_ := string_ || '      Fnd_Event_Parameter_API.Register(event_lu_name_, event_id_, id_, info_msg_);' || newline_;
   END LOOP;
   string_ := string_ || '   -- Update all actions with parameters' || newline_;
   string_ := string_ || '      Fnd_Event_Action_API.Update_Action(event_lu_name_, event_id_, NULL);' || newline_;
   string_ := string_ || 'END;' || newline_;
   string_ := string_ || '/' || newline_;
   string_ := string_ || 'COMMIT' || newline_;
   string_ := string_ || '/' || newline_;
   string_ := string_ || 'SET DEFINE &' || newline_;
END Export__;

@Override
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_   fnd_event_tab%ROWTYPE;
   newrec_   fnd_event_tab%ROWTYPE;
   indrec_   Indicator_Rec;
   attr2_    VARCHAR2(32000) := attr_;
BEGIN
   -- definition_modified_date must be only updated to sysdate
   -- when changes are done through the client not when importing
   IF action_ = 'DO' THEN
      oldrec_ := Get_Object_By_Id___(objid_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr2_);
      IF Has_Definition_Changed___(oldrec_, newrec_) THEN
         Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
      END IF;
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   
   IF action_ = 'DO' THEN
      Create_Custom_Event_Triggers(newrec_.event_lu_name, newrec_.event_id);
   END IF;
END Modify__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Update_Definition_Mod_Date_(
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_event_tab
   SET definition_modified_date = SYSDATE
   WHERE event_lu_name = event_lu_name_
   AND event_id = event_id_;
END Update_Definition_Mod_Date_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Event_Enable (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
   temp_       NUMBER;
   attr_       VARCHAR2(32000);
   indrec_     Indicator_Rec;
   oldrec_     FND_EVENT_TAB%ROWTYPE;
   newrec_     FND_EVENT_TAB%ROWTYPE;
   objid_      FND_EVENT.objid%TYPE;
   objversion_ FND_EVENT.objversion%TYPE;
BEGIN
   IF (event_id_ <> upper(event_id_)) THEN
      Error_SYS.Appl_General(lu_name_, 'UPPCASE: The event identity ":P1" must be in upper case.', event_id_);
   END IF;
   SELECT COUNT(*)
      INTO temp_
      FROM fnd_event_action
      WHERE event_id = event_id_
      AND   event_lu_name = event_lu_name_
      AND   action_enable = 'TRUE';
   IF (temp_ > 0) THEN
      Client_SYS.Add_To_Attr('EVENT_ENABLE', 'TRUE', attr_);
   ELSE
      Client_SYS.Add_To_Attr('EVENT_ENABLE', 'FALSE', attr_);
   END IF;
   oldrec_ := Get_Object_By_Keys___(event_lu_name_, event_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   BEGIN   
      -- creates a trigger in an autonomous transaction
      Create_Custom_Event_Triggers(event_lu_name_,event_id_);
   EXCEPTION
      WHEN OTHERS THEN
      BEGIN
         -- allowing the failure to raise will implicitly rollback the metadata inserts
         -- because the trigger changes didn't cause the current transaction to commit
         RAISE;
      END; 
   END;
   -- Update_Definition_Mod_Date_(event_lu_name_, event_id_); Enabling an Event should not modify the Definition modified date
END Set_Event_Enable;


PROCEDURE Refresh (
   event_lu_name_       IN VARCHAR2,
   event_id_            IN VARCHAR2,
   event_desc_          IN VARCHAR2,
   event_type_db_       IN VARCHAR2 DEFAULT 'APPLICATION',
   event_table_name_    IN VARCHAR2 DEFAULT NULL,
   modified_attributes_ IN VARCHAR2 DEFAULT NULL,
   new_row_             IN VARCHAR2 DEFAULT 'FALSE',
   modify_row_          IN VARCHAR2 DEFAULT 'FALSE',
   remove_row_          IN VARCHAR2 DEFAULT 'FALSE',
   event_trigger_type_  IN VARCHAR2 DEFAULT 'AFTER')
IS
   temp_ NUMBER;
BEGIN
   IF (event_id_ <> upper(event_id_)) THEN
      Error_SYS.Appl_General(lu_name_, 'UPPCASE: The event identity ":P1" must be in upper case.', event_id_);
   END IF;
   SELECT COUNT(*)
      INTO temp_
      FROM fnd_event_tab
      WHERE event_id = event_id_
      AND event_lu_name = event_lu_name_;
   IF (temp_ = 0) THEN
      INSERT INTO fnd_event_tab
         (event_lu_name, event_id, event_description, event_enable, rowversion,
          event_type, event_table_name, modified_attributes,
          new_row, modify_row, remove_row, event_trigger_type, definition_modified_date)
      VALUES
         (event_lu_name_, event_id_, event_desc_, 'FALSE', SYSDATE,
          event_type_db_, event_table_name_, modified_attributes_,
          new_row_, modify_row_, remove_row_, event_trigger_type_, sysdate);
   ELSE
      UPDATE fnd_event_tab
         SET event_description = event_desc_
         WHERE event_lu_name = event_lu_name_
         AND   event_id = event_id_;
   END IF;
   Update_Definition_Mod_Date_(event_lu_name_, event_id_);   
END Refresh;


PROCEDURE Register_Custom_Event (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   info_msg_      IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(2000);
   rec_ fnd_event_tab%ROWTYPE;
BEGIN
   Client_SYS.Add_To_Attr('EVENT_LU_NAME',       event_lu_name_, attr_);
   Client_SYS.Add_To_Attr('EVENT_ID',            event_id_, attr_);
   Client_SYS.Add_To_Attr('EVENT_DESCRIPTION',   Message_SYS.Find_Attribute(info_msg_, 'EVENT_DESCRIPTION', ''), attr_);
   Client_SYS.Add_To_Attr('EVENT_ENABLE',        Message_SYS.Find_Attribute(info_msg_, 'EVENT_ENABLE', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('EVENT_TABLE_NAME',    Message_SYS.Find_Attribute(info_msg_, 'EVENT_TABLE_NAME', ''), attr_);
   Client_SYS.Add_To_Attr('EVENT_TYPE_DB',       Message_SYS.Find_Attribute(info_msg_, 'EVENT_TYPE_DB', ''), attr_);
   Client_SYS.Add_To_Attr('EVENT_TRIGGER_TYPE_DB', Message_SYS.Find_Attribute(info_msg_, 'EVENT_TRIGGER_TYPE_DB', 'AFTER'), attr_);
   Client_SYS.Add_To_Attr('NEW_ROW_DB',          Message_SYS.Find_Attribute(info_msg_, 'NEW_ROW_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('MODIFY_ROW_DB',       Message_SYS.Find_Attribute(info_msg_, 'MODIFY_ROW_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('REMOVE_ROW_DB',       Message_SYS.Find_Attribute(info_msg_, 'REMOVE_ROW_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('MODIFIED_ATTRIBUTES', Message_SYS.Find_Attribute(info_msg_, 'MODIFIED_ATTRIBUTES', ''), attr_);
   
   rec_ := Get_Object_By_Keys___(event_lu_name_, event_id_);
   
   IF (rec_.event_id IS NOT NULL ) THEN
      -- Remove existing triggers
      IF (rec_.event_type = 'CUSTOM') THEN
         Remove_Custom_Triggers___(rec_);
      END IF;
      DELETE FROM fnd_event_tab WHERE event_lu_name = event_lu_name_ AND event_id = event_id_;
      DELETE FROM fnd_event_parameter_tab WHERE event_lu_name = event_lu_name_ AND event_id = event_id_;
   END IF;
   New__(info_, objid_, objversion_, attr_, 'DO');
   Create_Custom_Event_Triggers(event_lu_name_,event_id_);
END Register_Custom_Event;


PROCEDURE Unfresh (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
   temp_ NUMBER;
BEGIN
   SELECT COUNT(*)
      INTO temp_
      FROM FND_EVENT
      WHERE event_id = event_id_
      AND   event_lu_name = event_lu_name_;
   IF (temp_ > 0) THEN
      DELETE FROM fnd_event_tab
         WHERE event_lu_name = event_lu_name_
         AND   event_id = event_id_;
   END IF;
END Unfresh;


@UncheckedAccess
FUNCTION Check_Custom_Event(
   table_name_ VARCHAR2) RETURN BOOLEAN
IS
  temp_ NUMBER;
  CURSOR get_event IS
     SELECT 1
       FROM FND_EVENT_TAB
      WHERE event_table_name = table_name_ AND
            event_type = 'CUSTOM';
BEGIN
   OPEN get_event;
   FETCH get_event INTO temp_;
   
   IF get_event%FOUND THEN
     CLOSE get_event;
     RETURN TRUE;
   END IF;
   CLOSE get_event;
   RETURN FALSE;
END Check_Custom_Event;

@UncheckedAccess
FUNCTION Has_Event_Actions(
   event_lu_name_ VARCHAR2,
   event_id_      VARCHAR2 ) RETURN VARCHAR2
IS
  temp_ NUMBER;
  CURSOR get_event_actions IS
      SELECT 1
      FROM fnd_event_action_tab
      WHERE event_lu_name = event_lu_name_
      AND   event_id = event_id_;
BEGIN
   OPEN get_event_actions;
   FETCH get_event_actions INTO temp_;
   
   IF get_event_actions%FOUND THEN
     CLOSE get_event_actions;
     RETURN 'TRUE';
   END IF;
   CLOSE get_event_actions;
   RETURN 'FALSE';
END Has_Event_Actions;

PROCEDURE Create_Custom_Event_Triggers(
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
   rec_     Fnd_Event_Tab%ROWTYPE;
   params_  Table_Event_Param_Arr := Table_Event_Param_Arr();
BEGIN
   rec_ := Get_Object_By_Keys___(event_lu_name_, event_id_);
   
   -- collect config data in the open transaction
   SELECT t.*
     BULK COLLECT INTO params_
     FROM fnd_event_parameter_tab t
     WHERE event_lu_name = event_lu_name_
       AND event_id = event_id_;
   
   IF (rec_.event_type = 'CUSTOM') THEN
      IF (rec_.event_enable = 'TRUE') THEN
        Remove_Custom_Triggers___(rec_);
        Create_Custom_Triggers___(rec_, params_);
      ELSE
        Remove_Custom_Triggers___(rec_);
      END IF;                  
   END IF;
END Create_Custom_Event_Triggers;  

FUNCTION Get_Event_Id_By_Rowkey(
   rowkey_ IN VARCHAR2)RETURN VARCHAR2
IS
   name_ FND_EVENT_TAB.event_id%TYPE;
BEGIN
   
   SELECT event_id
   INTO name_
   FROM FND_EVENT_TAB
   WHERE rowkey = rowkey_;

   RETURN name_;
   
END Get_Event_Id_By_Rowkey;

FUNCTION Get_Event_Type_Db_By_Rowkey(
   rowkey_ IN VARCHAR2)RETURN VARCHAR2
IS
   event_type_ FND_EVENT_TAB.event_type%TYPE;
BEGIN
   
   SELECT event_type
   INTO event_type_
   FROM FND_EVENT_TAB
   WHERE rowkey = rowkey_;

   RETURN event_type_;
   
END Get_Event_Type_Db_By_Rowkey;

FUNCTION Get_Description_By_Rowkey(
   rowkey_ IN VARCHAR2)RETURN VARCHAR2
IS
   event_description_ FND_EVENT_TAB.event_description%TYPE;
BEGIN   
   SELECT event_description
   INTO event_description_
   FROM FND_EVENT_TAB
   WHERE rowkey = rowkey_;

   RETURN event_description_;   
END Get_Description_By_Rowkey;

FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ fnd_event_tab.definition_modified_date%TYPE;
BEGIN
   SELECT definition_modified_date INTO definition_modified_date_
   FROM fnd_event_tab
   WHERE rowkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;
   
PROCEDURE Export_XML (
   out_xml_        OUT CLOB,
   event_lu_name_   IN VARCHAR2,
   event_id_        IN VARCHAR2)
IS
   exp_date_format_ VARCHAR2(30) := Client_SYS.date_format_;
   -- 
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                                     e.event_lu_name,
                                     e.event_id,
                                     e.event_description, 
                                     e.event_enable, 
                                     e.event_table_name, 
                                     e.modified_attributes, 
                                     e.event_type_db, 
                                     e.new_row_db, 
                                     e.modify_row_db,
                                     e.remove_row_db,
                                     e.event_trigger_type_db,
                                     to_char(e.definition_modified_date ,'''||exp_date_format_||''') definition_modified_date,
                                     e.objkey,
                                     CURSOR( SELECT 
                                                p.id,
                                                p.id_type,                                                      
                                                p.plsql_method,
                                                p.current_value_db,
                                                p.new_value_db
                                             FROM fnd_event_parameter p
                                             WHERE p.event_id = e.event_id
                                             AND p.event_lu_name = e.event_lu_name
                                       )'||XMLTAG_CUST_EVE_PAR ||'
                              FROM fnd_event e
                              WHERE event_lu_name = '''|| event_lu_name_ ||'''
                              AND event_id = '''||event_id_||'''';   
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_CUSTOM_EVENT;
BEGIN
   
   /*
   IF (nvl(Get_Object_By_Keys___(event_lu_name_, event_id_).event_type, 'APPLICATION') != 'CUSTOM') THEN
      Error_SYS.Appl_General(lu_name_, 'EXP_TYPE: Only Custom Events are allowed to be exported.');
   END IF;
   */
   
   --dbms_output.put_line(stmt_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   objkey_ := Fnd_Event_API.Get_Objkey(event_lu_name_, event_id_);
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: '|| stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_CUSTOM_EVENT);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      App_Config_Util_API.Get_Item_Name(objkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT),
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      App_Config_Item_Type_API.DB_CUSTOM_EVENT,
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      App_Config_Util_API.Get_Item_Description(objkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT),
                                      xpath_);
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
END Export_XML;

PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN CLOB)
IS
   event_ fnd_event_tab%ROWTYPE;
   objkey_ VARCHAR2(100);
   xml_ Xmltype := Xmltype(in_xml_);
   active_action_count_ NUMBER;
   regenerate_trigger_ BOOLEAN;
BEGIN
   identical_ := FALSE;
   regenerate_trigger_ := FALSE;
   
   FOR rec_ IN get_event_header (xml_) LOOP
      objkey_ := Get_Objkey(rec_.event_lu_name, rec_.event_id);
      
      IF objkey_ IS NULL THEN
         Prepare_New___(event_);
         
         event_.event_lu_name := rec_.event_lu_name;
         event_.event_id := rec_.event_id;
         event_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         event_.event_description := Utility_SYS.Set_Windows_New_Line(rec_.event_description);
         event_.event_enable := 'FALSE';
         event_.event_table_name := rec_.event_table_name;
         event_.event_trigger_type := rec_.event_trigger_type;
         event_.event_type := rec_.event_type;
         event_.modified_attributes := rec_.modified_attributes;
         event_.new_row := rec_.new_row;
         event_.modify_row := rec_.modify_row;
         event_.remove_row:= rec_.remove_row;
         event_.rowkey := rec_.rowkey;
         
         Import_New___(event_);
      ELSIF objkey_ <> rec_.rowkey THEN
         App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'EVENTEXIST: Another Event with the same name ":P1: already exists for logical unit ":P2"',Fnd_Session_API.Get_Language, rec_.event_id, rec_.event_lu_name));
         RETURN;
      ELSE
         event_ := Lock_By_Keys_Nowait___(rec_.event_lu_name, rec_.event_id);
         IF (event_.definition_modified_date <> to_date(rec_.definition_modified_date, Client_SYS.date_format_)) THEN
            identical_ := FALSE;
            event_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
            event_.event_description := Utility_SYS.Set_Windows_New_Line(rec_.event_description);
            event_.event_enable := rec_.event_enable;
            
            -- Check if there are any preinstalled Event Actions which are enabled.
            IF event_.event_enable = 'TRUE' THEN  
               SELECT COUNT(*)
               INTO active_action_count_
               FROM fnd_event_action_tab
               WHERE event_id = rec_.event_id
               AND   event_lu_name = rec_.event_lu_name
               AND   action_enable = 'TRUE';
               
               IF active_action_count_ = 0 THEN
                  --TODO: This is how it's implemented for the moment.
                  --      Maybe in the future this logic can take in to account Event Actions which are currently been imported together with this Event
                  App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'MANUALENABLE: Information: No Event Actions which are Enabled were found for the Event in the database. Event will be set to disabled. Manually enable the Event after adding the Event Actions.'));
                  event_.event_enable := 'FALSE';
               END IF;
            END IF;
            
            event_.event_table_name := rec_.event_table_name;
            event_.event_trigger_type := rec_.event_trigger_type;
            event_.event_type := rec_.event_type;
            event_.modified_attributes := rec_.modified_attributes;
            event_.new_row := rec_.new_row;
            event_.modify_row := rec_.modify_row;
            event_.remove_row:= rec_.remove_row;
            Modify___(event_);
            
            IF event_.event_enable = 'TRUE' THEN
               regenerate_trigger_ := TRUE;
            END IF;
         ELSE
            identical_ := TRUE;    
         END IF;
      END IF;         
   END LOOP;
   
   Fnd_Event_Parameter_API.Import(xml_, event_.event_lu_name, event_.event_id);
   
   IF regenerate_trigger_ THEN
      BEGIN
         Create_Custom_Event_Triggers(event_.event_lu_name, event_.event_id);
      EXCEPTION
         WHEN OTHERS THEN
            -- Creating Removing Triggers will implicit cause the transaction to commit
            -- So need to manually reset the enabled flag to FALSE
            App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'EVENTACTERROR: The following Error occured while Enabling the Event. The Event was set to disable. Fix the error and manually re-enable the Event.'));
            App_Config_Util_API.Log_Error( SUBSTR(SQLERRM, 1, 200));
            event_ := Lock_By_Keys_Nowait___(event_.event_lu_name, event_.event_id);
            event_.event_enable := 'FALSE';
            Modify___(event_);
      END;
   END IF;
   
   IF NOT identical_ THEN
      Fnd_Event_Action_API.Update_Action(event_.event_lu_name, event_.event_id, NULL);
   END IF;   
   
   configuration_item_id_ := event_.rowkey;
   name_ := App_Config_Util_API.Get_Item_Name(configuration_item_id_, App_Config_Item_Type_API.DB_CUSTOM_EVENT);
END Import;

PROCEDURE Validate_Existing (
   info_               OUT App_Config_Util_API.AppConfigItemInfo,
   rowkey_             IN app_config_package_item_tab.configuration_item_id%TYPE,
   version_time_stamp_ IN DATE)
IS
   CURSOR get_parameters (event_id_ IN fnd_event_tab.event_id%TYPE) IS
   SELECT * FROM fnd_event_parameter_tab t
   WHERE t.event_id = event_id_;
   
   rec_ fnd_event_tab%ROWTYPE;
   event_ fnd_event_tab%ROWTYPE;
   parameter_rec_ fnd_event_parameter_tab%ROWTYPE;
   dep_objects_ App_Config_Util_API.DeploymentObjectArray;
  
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   active_action_count_ NUMBER;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CUSTOM_EVENT;
   
   Rowkey_Exist(rowkey_);
   
   rec_ := Get_Key_By_Rowkey(rowkey_);
   rec_ := Get_Object_By_Keys___(rec_.event_lu_name, rec_.event_id);

   info_.name := rec_.event_id;     
   info_.last_modified_date := Client_Sys.Attr_Value_To_Date(rec_.definition_modified_date);
   info_.exists := 'TRUE';    
   info_.current_description := rec_.event_description;
   info_.current_published := rec_.event_enable;
   info_.current_last_modified_date := rec_.definition_modified_date;
   event_.event_enable := rec_.event_enable;
   App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, rec_.rowkey);

   -- Check if there are any preinstalled Event Actions which are enabled.
   IF rec_.event_enable = 'TRUE' THEN  
      SELECT COUNT(*)
      INTO active_action_count_
      FROM fnd_event_action_tab
      WHERE event_id = rec_.event_id
      AND   event_lu_name = rec_.event_lu_name
      AND   action_enable = 'TRUE';

      IF active_action_count_ = 0 THEN
         --Need to warn that the event has no active actions but is enabled. and should we disable them?
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'NOENABLEDACTIONS: Information: No Event Actions which are Enabled were found for the Event in the database.'));
      END IF;
   END IF;

   IF NOT Validate_Event___(info_, dep_objects_, rec_) THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
   END IF;

   OPEN get_parameters(rec_.event_id);
   LOOP
      FETCH get_parameters INTO parameter_rec_;
      EXIT WHEN get_parameters%NOTFOUND;
      Fnd_Event_Parameter_API.Validate_Existing(info_, parameter_rec_, rec_.event_table_name);
   END LOOP;
   CLOSE get_parameters;
   
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
   
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
END Validate_Existing;

PROCEDURE Validate_Import (
   info_          OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_   IN OUT App_Config_Util_API.DeploymentObjectArray,
   in_xml_        IN CLOB,
   version_time_stamp_ IN DATE)
IS
   event_ fnd_event_tab%ROWTYPE;
   oldrec_ fnd_event_tab%ROWTYPE;
   xml_ Xmltype := Xmltype(in_xml_);
   objkey_ VARCHAR2(100);
   indrec_ Indicator_Rec;
   
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   attr_ VARCHAR2(32000);
   table_name_ VARCHAR2(30);
   import_date_ DATE;
   active_action_count_ NUMBER;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CUSTOM_EVENT;
   
   FOR rec_ IN get_event_header (xml_) LOOP
      oldrec_ := Get_Object_By_Keys___(rec_.event_lu_name, rec_.event_id);
      objkey_ := oldrec_.rowkey;
      
      info_.name := rec_.event_id;     
      info_.last_modified_date := Client_Sys.Attr_Value_To_Date(rec_.definition_modified_date);
      
      event_.event_lu_name := rec_.event_lu_name;
      event_.event_id := rec_.event_id;
      event_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
      event_.event_description := Utility_SYS.Set_Windows_New_Line(rec_.event_description);
      event_.event_enable := 'FALSE';
      event_.event_table_name := rec_.event_table_name;
      table_name_ := event_.event_table_name;
      event_.event_trigger_type := rec_.event_trigger_type;
      event_.event_type := rec_.event_type;
      event_.modified_attributes := rec_.modified_attributes;
      event_.new_row := rec_.new_row;
      event_.modify_row := rec_.modify_row;
      event_.remove_row:= rec_.remove_row;
      event_.rowkey := rec_.rowkey;
      
      IF objkey_ IS NULL THEN
         info_.exists := 'FALSE';
         info_.current_published := 'FALSE';
         
         indrec_ := Get_Indicator_Rec___(event_);
         Check_Insert___(event_, indrec_, attr_);
         IF NOT Validate_Event___(info_, dep_objects_, event_) THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         END IF;
      ELSIF objkey_ <> rec_.rowkey THEN
         info_.exists := 'TRUE';
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'EVENTEXIST2: Error: Another Event with the same name ":P1" exists on ":P2"', Fnd_Session_API.Get_Language, rec_.event_id, rec_.event_lu_name), TRUE);
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      ELSE
         info_.exists := 'TRUE';    
         info_.current_description := oldrec_.event_description;
         info_.current_published := oldrec_.event_enable;
         info_.current_last_modified_date := oldrec_.definition_modified_date;
         event_.event_enable := rec_.event_enable;
         App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, oldrec_.rowkey);
         
         IF (event_.definition_modified_date <> oldrec_.definition_modified_date) THEN
            import_date_:= App_Config_Package_API.Get_Package_Imported_Date(oldrec_.rowkey); 
            IF import_date_ IS NOT NULL AND nvl(oldrec_.definition_modified_date,Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten',Fnd_Session_API.Get_Language), TRUE); 
            END IF;
         END IF;
         
         -- Check if there are any preinstalled Event Actions which are enabled.
         IF event_.event_enable = 'TRUE' THEN  
            SELECT COUNT(*)
            INTO active_action_count_
            FROM fnd_event_action_tab
            WHERE event_id = rec_.event_id
            AND   event_lu_name = rec_.event_lu_name
            AND   action_enable = 'TRUE';
               
            IF active_action_count_ = 0 THEN
               Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'MANUALENABLE: Information: No Event Actions which are Enabled were found for the Event in the database. Event will be set to disabled. Manually enable the Event after adding the Event Actions.'));
               event_.event_enable := 'FALSE';
            END IF;
         END IF;
         
         IF NOT Validate_Event___(info_, dep_objects_, event_) THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         END IF;
      END IF;         
   END LOOP;
   
   Fnd_Event_Parameter_API.Validate_Import(info_, dep_objects_, xml_, table_name_);
   
   -- If no errors were found, this will set the item to validated
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
   END Validate_Import;
   
PROCEDURE Get_Deployment_Object_Names (
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,   
   in_xml_      IN CLOB)
IS
   count_ NUMBER;
   xml_ Xmltype := Xmltype(in_xml_);
BEGIN
   FOR rec_ IN get_event_header(xml_) LOOP
      count_ := dep_objects_.COUNT + 1;
      dep_objects_(count_).name := UPPER(rec_.event_lu_name||'^'||rec_.event_id);
      dep_objects_(count_).item_type := 'CUSTOM_EVENT';
   END LOOP;
END Get_Deployment_Object_Names;

FUNCTION Export_Custom_Event (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 ) RETURN BLOB
IS
   event_        BLOB;
   string_       CLOB;
BEGIN
   Export__(string_, event_lu_name_, event_id_);
   event_ := Utility_SYS.Clob_To_Blob(string_);
   RETURN event_;
END Export_Custom_Event;

FUNCTION Get_Logical_Unit_Tables (
   lu_name_ IN VARCHAR2) RETURN Table_Detail_Arr PIPELINED
IS
   view_name_        VARCHAR2(10000);
   app_owner_        VARCHAR2(30);
   rec_              Table_Detail_Rec;
   
   CURSOR view_tables(app_owner_ IN VARCHAR2, view_name_ IN VARCHAR2) IS
      SELECT nvl(referenced_name,'') tab_name
         FROM   user_dependencies
         WHERE  referenced_owner = app_owner_
         AND    referenced_type = 'TABLE'
         AND    Name = view_name_
         AND    type = 'VIEW'
         UNION
         SELECT nvl(referenced_name,'') tab_name
         FROM   user_dependencies
         WHERE  referenced_owner = app_owner_
         AND    referenced_type = 'TABLE'
         AND    (Name = view_name_||'_API' OR Name = view_name_||'_CFP' OR Name = view_name_||'_CLP')
         AND    type = 'PACKAGE BODY'
         UNION
         SELECT nvl(table_name,'') tab_name
         FROM user_tables
         WHERE (table_name = view_name_||'_TAB' OR table_name = view_name_||'_CFT' OR table_name = view_name_||'_CLT');
BEGIN
   app_owner_ := Fnd_Session_API.Get_App_Owner;
   view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
   
   FOR t IN view_tables(app_owner_, view_name_) LOOP      
      rec_.tab_name := t.tab_name;
      PIPE ROW(rec_);
   END LOOP;
   RETURN;
END Get_Logical_Unit_Tables;

FUNCTION Check_Date_Period (
   definition_modified_date_ IN DATE) RETURN VARCHAR2 
IS
BEGIN
   IF (trunc(definition_modified_date_) = trunc(sysdate)) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Check_Date_Period;