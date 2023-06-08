-----------------------------------------------------------------------------
--
--  Logical unit: FndSetting
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970414  ERFO  Generated from IFS/Design for release 2.0.0.
--  970423  ERFO  Changed LU-name to FndSetting.
--  970825  ERFO  Added new method Get_All_Settings_ (ToDo #1601).
--  971022  MANY  Added process control for parameters DEFJOB_PROCESSES and
--                DEFJOB_INTERVAL.
--  971128  ERFO  Additions and changes according to new model properties and
--                increased size of data storage representation (Bug #1777).
--  971205  ERFO  Changed interface name for Transaction_SYS (ToDo #1712).
--  980223  ERFO  Add validation when changing Event Reg. parameters (ToDo #2143).
--  980318  ERFO  Corrections to call Transaction_SYS.Init_All_Processing.
--                Minor correction in message key for Connectivity-settings.
--  980330  ERFO  Make Connectivity_SYS dependency to be dynamic (ToDo #2298).
--  980826  MANY  Added logic for PDF_PRINTER (ToDo #2442)
--  990922  DAJO  Invader Project - Fix in Set_Value
--  990427  ERFO  Added validation of tablespace names (Bug #2975).
--  990705  ERFO  Applied usage of Language_SYS.Exist (ToDo #3430).
--  990805  ERFO  Removed validation on tablespaces (Bug #3455).
--  000305  TOWR  Added process control for parameter REPLICATE, REPL_INTERVAL
--                and REPL_INTERVAL(Project Marian).
--  000321  HAAR  Added process control for parameter DATA_ARCHIVE
--                and DATA_ARCHIVE_STARTUP (ToDo #3745)
--  000321  ERFO  Added check for parameter SEC_PRES_SETUP (ToDo #3846).
--  010817  ROOD  Added info for parameter EVENT_EXECUTOR and EVENT_SERVER (ToDo#4021).
--  010904  ROOD  Added handling of Monitoring schedules in Update___ (ToDo#3993).
--  011015  ROOD  Removed unnecessary information (ToDo#4021).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021216  HAAR  Removed code for MONITORING_PROCESS' and 'MONITORING_INTERVAL'
--                (ToDo#4191).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030219  HAAR  Added QUERY_HINT parameter (ToDo#4152).
--  030220  ROOD  Changed hardcoded subcomponent name in message (ToDo#4149).
--  030626  ROOD  Handled obsolete parameters SEC_SETUP and SEC_METHOD_CHECK (ToDo#4099).
--  030820  ROOD  Added check for valid parameter values. Added attribute value_type.
--                Updated template (ToDo#4099).
--  030902  ROOD  Improved error handling in Update___. Foundation error messages
--                are raised, other errors are formatted (ToDo#4196).
--  050413  HAAR  Removed parameter SEC_SETUP and SEC_METHOD_CHECK (F1PR489).
--  070712  SUMALK Changed the Get_Value method to return connect for EVENT_EXECUTOR
--  080406  HAAR  Added category to be able to sort on category (Bug#72844)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_SETTING_TAB%ROWTYPE,
   newrec_     IN OUT FND_SETTING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Trace_SYS.Field('Parameter', newrec_.parameter);
   Trace_SYS.Field('Value', newrec_.value);
   --
   -- Actions upon modified Connectivity parameters
   --
   IF newrec_.parameter IN ('CON_INBOX','CON_OUTBOX','CON_IN_INTERVAL','CON_OUT_INTERVAL') THEN
      BEGIN
         Connectivity_SYS.Init_All_Processes__(0);
      EXCEPTION
         WHEN OTHERS THEN
            IF Error_SYS.Is_Foundation_Error(SQLCODE) THEN
               RAISE;
            ELSE
               IF newrec_.parameter IN ('CON_INBOX','CON_OUTBOX') THEN
                  Error_SYS.Appl_General(lu_name_, 'CONNECTINIT: Unable to initiate Connectivity processes (:P1)', sqlerrm);
               ELSE 
                  Error_SYS.Appl_General(lu_name_, 'CONNECTINTERVAL: Unable to set Connectivity interval :P1 (:P2)', newrec_.value, sqlerrm);
               END IF;
            END IF;
      END;
   END IF;
   --
   -- Actions upon modified Replication parameters
   --
   IF newrec_.parameter IN ('REPLICATE','REPL_SND_WARN','REPL_SND_INFO','REPL_RCV_WARN','REPL_RCV_INFO','REPL_INTERVAL') THEN
      BEGIN
         Replication_SYS.Init_All_Processes__(0);
      EXCEPTION
         WHEN OTHERS THEN
            IF Error_SYS.Is_Foundation_Error(SQLCODE) THEN
               RAISE;
            ELSE
               IF newrec_.parameter = 'REPL_INTERVAL' THEN
                  Error_SYS.Appl_General(lu_name_, 'REPLINTERVAL: Unable to set Replication interval :P1 (:P2)', newrec_.value, sqlerrm);
               ELSE
                  Error_SYS.Appl_General(lu_name_, 'REPLINIT: Unable to initiate Replication processes (:P1)', sqlerrm);
               END IF;
            END IF;
      END;
   END IF;
   --
   -- Data Archiving parameters
   --
   IF (newrec_.parameter IN ('DATA_ARCHIVE', 'DATA_ARCHIVE_STARTUP')) THEN
      BEGIN
         Data_Archive_SYS.Init_All_Processes_(0);
      EXCEPTION
         WHEN OTHERS THEN
            IF Error_SYS.Is_Foundation_Error(SQLCODE) THEN
               RAISE;
            ELSE
               IF newrec_.parameter = 'DATA_ARCHIVE_STARTUP' THEN
                  Error_SYS.Appl_General(lu_name_, 'ARCHIVEINTERVAL: Unable to set Data Archive interval :P1 (:P2)', newrec_.value, sqlerrm);
               ELSE
                  Error_SYS.Appl_General(lu_name_, 'ARCHIVEINIT: Unable to initiate Data Archive processes (:P1)', sqlerrm);
               END IF;
            END IF;
      END;
   END IF;
   --
   -- Batch Scheduling parameters
   --
   IF (newrec_.parameter IN ('BATCH_SCHEDULE', 'BATCH_SCHED_STARTUP')) THEN
      BEGIN
         Batch_SYS.Init_All_Processes_(0);
      EXCEPTION
         WHEN OTHERS THEN
            IF Error_SYS.Is_Foundation_Error(SQLCODE) THEN
               RAISE;
            ELSE
               IF newrec_.parameter = 'BATCH_SCHED_STARTUP' THEN
                  Error_SYS.Appl_General(lu_name_, 'BATCHSCHEDINTERVAL: Unable to set Scheduled Tasks interval :P1 (:P2)', newrec_.value, sqlerrm);
               ELSE
                  Error_SYS.Appl_General(lu_name_, 'BATCHSCHEDHINIT: Unable to initiate Scheduled Tasks processes (:P1)', sqlerrm);
               END IF;
            END IF;
      END;
   END IF;
   --
   -- Default file encoding
   --
   IF (newrec_.parameter IN ('DEFAULT_FILEENCODING')) THEN
      Database_SYS.Set_Default_File_Encoding;
   END IF;
   --
   -- Max background processes
   --
   IF (newrec_.parameter IN ('BATCH_PROCESSES')) THEN
      Batch_SYS.Set_Background_Processes__(newrec_.value);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_setting_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF(newrec_.value_type IS NULL) THEN
      newrec_.value_type := 'FIXED STRING';
      Client_SYS.Add_To_Attr('VALUE_TYPE', newrec_.value_type, attr_);
   END IF;
   IF(newrec_.client_read_only IS NULL) THEN
      newrec_.client_read_only := 'FALSE';
      Client_SYS.Add_To_Attr('CLIENT_READ_ONLY', newrec_.client_read_only, attr_);
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     fnd_setting_tab%ROWTYPE,
   newrec_ IN OUT fnd_setting_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   dummy_  VARCHAR2(40);
   dummy2_ NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Checking fixed values
   IF newrec_.value_type IN ('FIXED STRING', 'FIXED NUMBER', 'FIXED DATE') THEN
      IF instr('^'||newrec_.domain, '^'||newrec_.value||'^') <= 0 THEN
         Error_SYS.Record_General(lu_name_, 'ERRNOTKNOWNVALUE: The value ":P1" is not one of the allowed values [:P2] for parameter ":P3".', newrec_.value, replace(rtrim(newrec_.domain, '^'),'^', '/'), newrec_.parameter_desc);
      END IF;
   END IF;
   -- Checking numeric values
   IF newrec_.value_type IN ('FIXED NUMBER', 'CUSTOM NUMBER') THEN
      BEGIN
         dummy2_ := to_number(newrec_.value);
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Appl_General(lu_name_, 'ERRFORMATNUMBER: Invalid number ":P1" for parameter ":P2".', newrec_.value, newrec_.parameter_desc);
      END;
   END IF;
   -- Checking date formats
   IF newrec_.value_type IN ('FIXED DATE', 'CUSTOM DATE') THEN
      BEGIN
         dummy_ := to_char(sysdate, newrec_.value);
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Appl_General(lu_name_, 'ERRFORMATDATE: Invalid date/time format ":P1" for parameter ":P2".', newrec_.value, newrec_.parameter_desc);
      END;
   END IF;
   IF oldrec_.client_read_only = 'TRUE' THEN
      IF NVL(Client_SYS.Get_Item_Value('OVERRIDE', attr_), 'FALSE') = 'FALSE' THEN
         Error_SYS.Record_General(lu_name_, 'ERRNOTEDITABLE: The value ":P1" is not updatable.', newrec_.parameter);
      END IF;
   END IF;
   --
   -- Default language parameters
   --
   IF (newrec_.parameter = 'DEFAULT_LANGUAGE') THEN
      Language_SYS.Exist(newrec_.value);
   END IF;
   --
   -- Query Hints
   --
   IF (newrec_.parameter = 'QUERY_HINTS') THEN
      IF (newrec_.value = 'ON') THEN
         Client_SYS.Add_Info('FndSetting', 'QUERY_HINT: Do not forget to run the background job that generates Query Dialog Hints.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Merge_List_Parameter_Values___ (
   merged_values_  OUT VARCHAR2,
   is_modified_    OUT BOOLEAN,
   old_value_       IN VARCHAR2,
   new_value_       IN VARCHAR2,
   seperator_       IN VARCHAR2 DEFAULT ',')
IS
   index_ BINARY_INTEGER := 0;
   TYPE value_table IS TABLE OF VARCHAR2(200)  INDEX BY BINARY_INTEGER; 
   value_list_ value_table;
BEGIN
   is_modified_ := FALSE;
   merged_values_ := old_value_;
   
   IF new_value_ IS NULL OR new_value_ = '' THEN
      -- Nothing to do, return old_values_
      RETURN;
   END IF;
   
   FOR list_rec_ IN (SELECT trim(regexp_substr(new_value_, '[^'||seperator_||']+', 1, LEVEL)) val FROM dual CONNECT BY LEVEL <= regexp_count(new_value_, seperator_)+1) LOOP
      index_ := index_ + 1;
      value_list_(index_) := UPPER(list_rec_.val);
   END LOOP;
   FOR counter_ IN 1..index_ LOOP
      IF (Instr(UPPER((seperator_||old_value_||seperator_)), (seperator_||value_list_(counter_)||seperator_)) = 0) THEN
         merged_values_ := merged_values_||seperator_||value_list_(counter_);
         is_modified_ := TRUE;
      END IF;
   END LOOP;
   merged_values_ := LTRIM(merged_values_, seperator_);
END Merge_List_Parameter_Values___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Get_All_Settings_ (
   info_msg_ OUT VARCHAR2 )
IS
   msg_ VARCHAR2(32000);

   CURSOR get_all_info IS
      SELECT parameter, value
      FROM FND_SETTING_TAB;
BEGIN
   msg_ := Message_SYS.Construct('FNDBAS.ALL_SETTINGS');
   FOR rec IN get_all_info LOOP
      Message_SYS.Set_Attribute(msg_, rec.parameter, rec.value);
   END LOOP;
   info_msg_ := msg_;
END Get_All_Settings_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Enumerate (
   parameters_ OUT VARCHAR2 )
IS
   list_ VARCHAR2(2000);
   CURSOR get_params IS
      SELECT parameter
      FROM   fnd_setting_tab;
BEGIN
   FOR rec IN get_params LOOP
      list_ := list_||rec.parameter||Client_SYS.field_separator_;
   END LOOP;
   parameters_ := list_;
END Enumerate;


PROCEDURE Set_Value (
   parameter_ IN VARCHAR2,
   value_     IN VARCHAR2 )
IS
   attr_       VARCHAR2(1000);
   indrec_     Indicator_Rec;
   oldrec_     FND_SETTING_TAB%ROWTYPE;
   newrec_     FND_SETTING_TAB%ROWTYPE;
   objid_      FND_SETTING.objid%TYPE;
   objversion_ FND_SETTING.objversion%TYPE;
BEGIN
   --
   -- Check that parameter exist
   --
   Exist(parameter_);
   --
   -- Create small attr string
   --
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   --
   -- Lock record and perform update
   --
   oldrec_ := Lock_By_Keys___(parameter_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
END Set_Value;

PROCEDURE Modify_Parameter (
   parameter_   IN VARCHAR2,
   description_ IN VARCHAR2,
   dynamic_     IN VARCHAR2,
   value_       IN VARCHAR2,
   domain_      IN VARCHAR2,
   domain_desc_ IN VARCHAR2,
   category_    IN VARCHAR2,
   value_type_  IN VARCHAR2 DEFAULT 'FIXED STRING',
   module_      IN VARCHAR2 DEFAULT 'CUSTOM')
IS
   attr_       VARCHAR2(32767);
   indrec_     Indicator_Rec;
   oldrec_     FND_SETTING_TAB%ROWTYPE;
   newrec_     FND_SETTING_TAB%ROWTYPE;
   objid_      FND_SETTING.objid%TYPE;
   objversion_ FND_SETTING.objversion%TYPE;
   
   not_exist   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(not_exist, -20111);
BEGIN
   Exist(parameter_);
   
   -- Do not upgrade Tablespace values
   IF parameter_ NOT IN ('TS_DEFAULT', 'TS_TEMPORARY') THEN
      IF (description_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('PARAMETER_DESC', description_, attr_);
      END IF;
      IF (dynamic_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('DYNAMIC', dynamic_, attr_);
      END IF;
      IF (value_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('VALUE', value_, attr_);
      END IF;
      IF (domain_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('DOMAIN', domain_, attr_);
      END IF;
      IF (domain_desc_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('DOMAIN_DESC', domain_desc_, attr_);
      END IF;
      IF (value_type_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('VALUE_TYPE', value_type_, attr_);
      END IF;
      IF (category_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CATEGORY', category_, attr_);
      END IF;
      IF (module_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      END IF;

      oldrec_ := Lock_By_Keys___(parameter_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Client_SYS.Add_To_Attr('OVERRIDE', 'TRUE', attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END IF;
EXCEPTION
   WHEN not_exist THEN
      NULL;
END Modify_Parameter;

PROCEDURE New_Parameter (
   parameter_   IN VARCHAR2,
   description_ IN VARCHAR2,
   dynamic_     IN VARCHAR2,
   value_       IN VARCHAR2,
   domain_      IN VARCHAR2,
   domain_desc_ IN VARCHAR2,
   category_    IN VARCHAR2,
   value_type_  IN VARCHAR2 DEFAULT 'FIXED STRING',
   module_      IN VARCHAR2 DEFAULT 'CUSTOM',
   client_read_only_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   indrec_        Indicator_Rec;
   newrec_        FND_SETTING_TAB%ROWTYPE;
   attr_          VARCHAR2(32767);
   objid_         FND_SETTING.objid%TYPE;
   objversion_    FND_SETTING.objversion%TYPE;

   duplicate      EXCEPTION;   
   PRAGMA         EXCEPTION_INIT(duplicate, -20112);
BEGIN
   Client_SYS.Add_To_Attr('PARAMETER', parameter_, attr_);
   Client_SYS.Add_To_Attr('PARAMETER_DESC', description_, attr_);
   Client_SYS.Add_To_Attr('DYNAMIC', dynamic_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('DOMAIN', domain_, attr_);
   Client_SYS.Add_To_Attr('DOMAIN_DESC', domain_desc_, attr_);
   Client_SYS.Add_To_Attr('CATEGORY', category_, attr_);
   Client_SYS.Add_To_Attr('VALUE_TYPE', value_type_, attr_);
   Client_SYS.Add_To_Attr('MODULE', module_, attr_);
   Client_SYS.Add_To_Attr('CLIENT_READ_ONLY', client_read_only_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN duplicate THEN
      Modify_Parameter (parameter_,
                        description_,
                        '',
                        '',
                        domain_,
                        domain_desc_,
                        category_,
                        value_type_,
                        module_);
END New_Parameter;

FUNCTION Sort_Allowed_Ext_List_Value (
   value_     IN VARCHAR2) RETURN VARCHAR2
IS
   return_    VARCHAR2(4000);
   seperator_ VARCHAR2(2) := ',';
BEGIN
   SELECT LISTAGG(filelist, seperator_) WITHIN GROUP (ORDER BY filelist) filelist INTO return_
     FROM (SELECT DISTINCT UPPER(TRIM(regexp_substr(filelist, '[^'||seperator_||']+', 1, LEVEL))) filelist 
           FROM (SELECT value_ filelist 
                 FROM dual)
           CONNECT BY instr(filelist, seperator_, 1, LEVEL - 1) > 0);
   RETURN return_;
END Sort_Allowed_Ext_List_Value;

PROCEDURE Create_Or_Modify_List_Param(
   parameter_   IN VARCHAR2,
   description_ IN VARCHAR2,
   dynamic_     IN VARCHAR2,
   value_       IN VARCHAR2,
   domain_      IN VARCHAR2,
   domain_desc_ IN VARCHAR2,
   category_    IN VARCHAR2,
   value_type_  IN VARCHAR2 DEFAULT 'FIXED STRING',
   module_      IN VARCHAR2 DEFAULT 'CUSTOM',
   client_read_only_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   old_value_  VARCHAR2(4000);
   new_value_  VARCHAR2(4000);
   modified_   BOOLEAN := FALSE;
BEGIN
   IF Fnd_Setting_API.Exists(parameter_) THEN
      old_value_  := Get_Value(parameter_);
      IF (old_value_ != value_) THEN
         Merge_List_Parameter_Values___(new_value_, modified_, old_value_, value_, ',');
         
         IF parameter_ = 'ALLOWED_EXTENSION' THEN
            new_value_ := Sort_Allowed_Ext_List_Value(new_value_);
         END IF;
         
         Modify_Parameter(parameter_, description_, dynamic_, new_value_, domain_, domain_desc_, category_, value_type_, module_); 
      ELSE
         Trace_SYS.Message('System Parameter ['||parameter_||'] unchaged.');
      END IF;
   ELSE
      New_Parameter(parameter_, description_, dynamic_, value_, domain_, domain_desc_, category_, value_type_,  module_, client_read_only_);
   END IF;
END Create_Or_Modify_List_Param;

PROCEDURE Remove_Parameter (
   parameter_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM fnd_setting_tab
   WHERE parameter = parameter_;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Remove_Parameter;

FUNCTION Get_Parameter (
   parameter_ IN VARCHAR2 ) RETURN fnd_setting_tab%ROWTYPE
IS
   rec_ fnd_setting_tab%ROWTYPE;
BEGIN
   SELECT *
   INTO rec_
   FROM  fnd_setting_tab
   WHERE parameter = parameter_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      rec_.parameter := 'NONE';
      RETURN rec_;
END Get_Parameter;

PROCEDURE Remove_Parameter_Per_Module(
   module_ IN VARCHAR2)
IS
   CURSOR get_parameters IS
      SELECT parameter
      FROM   fnd_setting_tab
      WHERE  module = module_;
BEGIN
   FOR rec_ IN get_parameters LOOP
      Remove_Parameter(rec_.parameter);
   END LOOP;
END Remove_Parameter_Per_Module;

FUNCTION Get_Value_Description(
   parameter_  IN VARCHAR2) RETURN VARCHAR2
IS
   TYPE value_table IS TABLE OF VARCHAR2(200)  INDEX BY BINARY_INTEGER; 
   setting_rec_   Fnd_Setting_API.Public_Rec;
   index_         NUMBER;
   domain_desc_   value_table;
BEGIN
   setting_rec_ := Get(parameter_);
   index_ := 0;
   FOR rec_ IN (SELECT regexp_substr(setting_rec_.domain_desc ,'[^\^]+', 1, LEVEL) AS rec_ FROM dual CONNECT BY regexp_substr(setting_rec_.domain_desc, '[^\^]+', 1, LEVEL) IS NOT NULL) LOOP
      index_ := index_ + 1;
      Dbms_Output.Put_Line(rec_.rec_);
      domain_desc_(index_) := rec_.rec_;
   END LOOP;
   
   index_ := 0;
   FOR rec_ IN (SELECT regexp_substr(setting_rec_.domain ,'[^\^]+', 1, LEVEL) AS rec_ FROM dual CONNECT BY regexp_substr(setting_rec_.domain, '[^\^]+', 1, LEVEL) IS NOT NULL) LOOP
      index_ := index_ + 1;
      IF setting_rec_.value = rec_.rec_ THEN
         RETURN domain_desc_(index_);
      END IF;
   END LOOP;
   RETURN '';
END Get_Value_Description;

@UncheckedAccess
FUNCTION Get_Value (
   parameter_           IN VARCHAR2,
   skip_module_check_   IN BOOLEAN ) RETURN VARCHAR2
IS
   temp_ fnd_setting_tab.value%TYPE;
BEGIN
   IF parameter_ IS NULL OR NOT skip_module_check_ THEN
      RETURN Get_Value(parameter_);
   END IF;
   SELECT VALUE
      INTO temp_
      FROM fnd_setting_tab
      WHERE parameter = parameter_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(parameter_, 'Get_Value');
END Get_Value;

FUNCTION Get_Tsa_List_Value (
   value_     IN VARCHAR2) RETURN VARCHAR2
IS
   return_    VARCHAR2(4000);
   seperator_ VARCHAR2(2) := ',';
BEGIN
   SELECT LISTAGG(filelist, seperator_) WITHIN GROUP (ORDER BY filelist) filelist INTO return_
     FROM (SELECT DISTINCT (TRIM(regexp_substr(filelist, '[^'||seperator_||']+', 1, LEVEL))) filelist 
           FROM (SELECT value_ filelist 
                 FROM dual)
           CONNECT BY instr(filelist, seperator_, 1, LEVEL - 1) > 0);
   RETURN return_;
END Get_Tsa_List_Value;
