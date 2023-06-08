-----------------------------------------------------------------------------
--
--  Logical unit: FndEventAction
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971009  ERFO  Reviewed for Foundation1 Release 2.0.0 (ToDo #1676).
--  971015  DAJO  Reviewed trace messages for client console.
--                Removed lots of calls to General_SYS.Init_Method for
--                better performance.
--  971127  ERFO  Added method Update_Action to synchronize
--                actions when parameters are changed (Bug #1833).
--                Simplified code in method Delete_Action.
--  971203  ERFO  Added new attribute DESCRIPTION (ToDo #1717).
--  971203  ERFO  Removed dirty trace output (ToDo #1832).
--  980119  ERFO  Changed method Evaluate_Condition_Num to include
--                functionality for value-lists by adding new
--                implementation method Equals_Eq_Num___ (ToDo #2016).
--  980119  ERFO  Optimizing cursor handling in Activate_Action and solved
--                parameter name independency in Make_Message (Bug #2021).
--  980121  ERFO  Added method Action_Sms_Message (ToDo #2036).
--  980223  ERFO  Skip SMS-message when no SMS-host is configured.
--  980223  ERFO  Add format validation when defining new conditions (ToDo #2143).
--  980223  ERFO  Correction in refreshing method Update_Action (Bug #2145).
--  980303  ERFO  Changed validation of conditions when extended condition
--                evalutation is used (ToDo #2185).
--  990318  ERFO  Changed many local variables of size 2000 to 32000 (Bug #3233).
--  991026  ERFO  Solved parameter restrictions and reorganized method
--                parameters in this package (Bug #3373).
--  000208  ERFO  Corrected variable allocation in Set_Parameter (Bug #14789).
--  000821  ROOD  Replaced '=>' with '>=' in Evaluate_Condition_Num (Bug #15865).
--  000926  HAET  Added method Action_Executeonlinesql, Execute_Dynamic_Sql___ (ToDo #3942).
--  001007  ROOD  Upgraded template version.
--  010702  ROOD  Added attributes, methods and view for subscription and message
--                saving functionality (ToDo#4016).
--  010817  ROOD  Removed obsolete method Execute_Dynamic_Sql (ToDo#4021).
--  010820  ROOD  Corrected installation dependencies in cursors (ToDo#4016).
--  011015  ROOD  Modifications of view fnd_event_action_subscribable (ToDo#4016).
--  011015  ROOD  Added FROM as a parameter in Action_Mail. Added condition upon receiver
--                in Activate_Action to allow event actions especially for subscription.
--                Removed annoying info message for oracle_role (ToDo#4015).
--  011016  ROOD  Added more conditions upon fnd_event_action_subscribable.
--                Added check that event action is subscribable in Activate_Action (ToDo#4016).
--  011023  ROOD  Added validation for oracle_role (ToDo#4016).
--  020129  ROOD  Added method Action_Application_Message (ToDo#4069).
--  020321  ROOD  Made description mandatory (Bug#28803).
--  030107  ROOD  Corrected Action_Sms_Message (Bug#34372).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030214  ROOD  Replaced usage of tables from other LU's with their views (ToDo#4149).
--  030219  ROOD  Removed hardcoded subcomponent names in messages (ToDo#4149).
--  030224  ROOD  Used fnd_user_role_runtime in the subscribable view (Bug#35414).
--  030307  ROOD  Removed interfaces for Event Server action types "Execute SQL",
--                "Submit from File" and "Connect and Execute SQL" (ToDo#4149).
--  030403  ROOD  Added default value for action_enable (ToDo#4160).
--  030903  ROOD  Made identity uppercase in Action_Personal_Message (Bug#39253).
--  030910  ROOD  Replaced usage of sys.dba_roles with new view fnd_role (ToDo#4160).
--  040223  ROOD  Replaced oracle_role with role everywhere (F1PR413).
--  040329  ROOD  Removed Check_Role___ and used Fnd_Role_API.Exist instead (F1PR413).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050503  UTGULK  Added methods Export__,Pack_Array__,Format___,Register(F1PR480).
--  060428  NiWi  Modified Make_Message. New notation(prefix ampersandampersand) for 'URL parameters' in the
--                e-mail text. Event param with prefix ampersandampersand will not be replaced by parameter value,
--                instead just the prefix will be changed from ampersandampersand to ampersand(Bug#55976).
--  060623  RaRu  Added an error message to prevent disabling all the actions when the event is enabled(Bug#58535)
--  060928  RaRuLk  Changed the FND_EVENT to FND_EVENT_TAB in Update___ (Bug#60852)
--  070212  HAAR  Added support for Custom Defined Events (Bugg#61780).
--  070509  NiWi  Modified Set_Event_Parameters.(Bug#64615)
--  070519  SuMa  Modified the Unpack Insert and Update value_ to 32k and addded a Exception too_long(Bug#65181)
--  070621  SuMa  Modified Action_Mail and Action_Winpopup to accomodate long lists for TO variable.(Bug#65960)
--  070621  SuMa  Modified Action_Mail to accomocate Fnduser if FROM is null(Bug#70093)
--  080909  DuWi  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to check
--                  system privilages when define SQL that is run dynamically (Bug#75566)
--  090331  DuWi  Added functionality to log the event action failure(Bug#77864).
--  090810  NABA  Certified the assert safe for dynamic SQLs in Action_Executeonlinesql (Bug#84218)
--  100419  UsRa  Modified [Check_Condition_Format___] to support context substitution variables. (Bug#83992)
--  100901  DUWI  Removed Action_Socketmessage (EACS-986).
--  110728  ChMu  Modified Check_Condition_Format___ to support expressions with NEW:/OLD: values (Bug#96259)
--  110831  UsRa  Changed Action_Personal_Message to use correct interface when accessing FndEventMyMessages. (Bug#98551)
--  110831  NaBa  Applied changes to support hyphens after a line break in attribute data (Bug#98663)
--  120705  MaBose  Conditional compiliation improvements - Bug 103910
--  120715  ChMu  Modified Action_Personal_Message to use new method in FndEventMyMessages to avoid
--                attribute strings inside attribute strings (Bug#102250).
--  120816  UsRa  Converted the field ACTION_PARAMETERS to a clob (Bug#103298).
--   120716   AsWiLk   Implemented 'Human Task' event action.   
--  130226  MADD  Rewrote the logic to prevent exporting too long strings to a single line (Bug#108260)
--  140224  TMadLK  Rewrote the logic to prevent exporting too long strings to a single line (Bug#115340).
--  140225  TMadLK  Modified length of two variables in Update_Action procedure (Bug#115549).
--  140822  MaBose  Removed Action_Netmessage (TEBASE-231).
--  140828  MaBose  Removed Action_Personal_Message (TEBASE-231).
--  161122  NaBaLK  Added a null check to SQL statement when enabling event action (TEBASE-1812)
--  170306  NaBaLK  Set default value for system_defined when update (TEBASE-1974) 
--  170214	UdLeLK	Users need to change MAIL_SENDER in email event actions (Bug#134162)
--  191112  DaZwCA  Added Event handling functionality for BPA Actions (TEWF-31)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

newline_                      CONSTANT VARCHAR2(2) := chr(13)||chr(10);

event_log_category_           CONSTANT  VARCHAR2(100) := 'Event Errors';

EXPORT_DEF_VERSION      CONSTANT VARCHAR2(5)   := '2.0';
XMLTAG_CUST_OBJ_EXP     CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_CUSTOM_EVENT_ACTION     CONSTANT VARCHAR2(50)  := 'CUSTOM_EVENT_ACTION';
XMLTAG_CUST_OBJ_EXP_DEF_VER    CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';

CURSOR get_event_action(xml_ Xmltype) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_EVENT_ACTION' passing xml_
                         COLUMNS
                            EXPORT_DEF_VERSION NUMBER path '@EXPORT_DEF_VERSION',
                            EVENT_LU_NAME VARCHAR2(25) path 'EVENT_LU_NAME',
                            EVENT_ID VARCHAR2(32) path 'EVENT_ID',
                            ACTION_NUMBER NUMBER path 'ACTION_NUMBER',
                            ACTION_ENABLE VARCHAR2(10) path 'ACTION_ENABLE',
                            CONDITION_TYPE VARCHAR2(4000) path 'CONDITION_TYPE',
                            CONDITION_VALUE VARCHAR2(4000) path 'CONDITION_VALUE',
                            FND_EVENT_ACTION_TYPE VARCHAR2(20) path 'FND_EVENT_ACTION_TYPE_DB',
                            DESCRIPTION VARCHAR2(200) path 'DESCRIPTION',
                            SUBSCRIBABLE VARCHAR2(20) path 'SUBSCRIBABLE',
                            SYSTEM_DEFINED VARCHAR2(5) path 'SYSTEM_DEFINED',
                            ROLE VARCHAR2(30) path 'ROLE',
                            ACTION_PARAMETERS CLOB path 'ACTION_PARAMETERS',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            ROWKEY VARCHAR2(100) PATH 'OBJKEY'
                        ) xt1; 

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Bigger_Than___ (
   val1_ IN VARCHAR2,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF val1_ > val2_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Bigger_Than___;


FUNCTION Less_Than___ (
   val1_ IN VARCHAR2,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF val1_ < val2_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Less_Than___;


FUNCTION Bigger_Than_Num___ (
   val1_ IN NUMBER,
   val2_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF val1_ > val2_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Bigger_Than_Num___;


FUNCTION Equals___ (
   val1_ IN VARCHAR2,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Report_SYS.Parse_Parameter(val1_, val2_);
END Equals___;


FUNCTION Less_Than_Num___ (
   val1_ IN NUMBER,
   val2_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF val1_ < val2_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Less_Than_Num___;


FUNCTION Equals_Eq_Num___ (
   val1_ IN NUMBER,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Report_SYS.Parse_Parameter(val1_, val2_);
END Equals_Eq_Num___;


FUNCTION Equals_Num___ (
   val1_ IN NUMBER,
   val2_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF val1_ = val2_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Equals_Num___;


FUNCTION Get_Next_Attr___ (
   attr_  IN     VARCHAR2,
   ptr_   IN OUT NUMBER,
   name_  IN OUT VARCHAR2,
   value_ IN OUT VARCHAR2 ) RETURN VARCHAR2
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
   record_separator_ VARCHAR2(5) := chr(10);
   field_separator_  VARCHAR2(5) := '=';
BEGIN
   from_ := nvl(ptr_, 1);
   to_   := instr(attr_, record_separator_, from_);
   IF (to_ = 0) THEN
      to_ := length(attr_) + 1;
   END IF;
   IF (from_ <= length(attr_)) THEN
      index_ := instr(attr_, field_separator_, from_);
      name_  := substr(attr_, from_, index_-from_);
      value_ := substr(attr_, index_+1, to_-index_-1);
      ptr_   := to_+2;
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Get_Next_Attr___;


FUNCTION Find_First_Attr___ (
   attr_ IN VARCHAR2 ) RETURN NUMBER
IS
   from_      NUMBER;
   to_        NUMBER;
   separator_ VARCHAR2(5) := '$';
BEGIN
   from_ := nvl(NULL, 1);
   to_   := instr(attr_, separator_ , from_);
   IF (to_ > 0) THEN
      RETURN to_ + 1;
   ELSE
      RETURN 0;
   END IF;
END Find_First_Attr___;


PROCEDURE Check_Condition_Format___ (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   cond_type_     IN VARCHAR2,
   cond_value_    IN VARCHAR2 )
IS
--   cond_err   EXCEPTION;
--   PRAGMA     exception_init(cond_err, -20105);
   date_err   EXCEPTION;
   PRAGMA     exception_init(date_err, -01841);
   litrl_err  EXCEPTION;
   PRAGMA     exception_init(litrl_err, -01861);
   inv_month  EXCEPTION;
   PRAGMA     exception_init(inv_month, -01843);
   inv_day    EXCEPTION;
   PRAGMA     exception_init(inv_day, -01839);
   image_err  EXCEPTION;
   PRAGMA     exception_init(image_err, -01830);

   dummy_     VARCHAR2(4000);
   cond_operator_     VARCHAR2(4000);
   temp_      VARCHAR2(4000);
   type_      VARCHAR2(2000);
   cond_data_type_ VARCHAR2(2000);
   format_    VARCHAR2(2000);
   ampersand_ VARCHAR2(1) := chr(38);
   stmt_      VARCHAR2(32000);
   temp_date_ DATE;
   sysdate_expr_ VARCHAR2(1000):= 'SYSDATE|NEXT_DAY|LAST_DAY|TRUNC|ROUND|ADD_MONTHS';

   CURSOR get_params IS
      SELECT id, id_type
      FROM fnd_event_parameter_special
      WHERE event_id = event_id_
      AND   event_lu_name = event_lu_name_
      AND   id_type NOT IN ('CLOB', 'BLOB');
BEGIN
   FOR rec IN get_params LOOP
      Message_SYS.Get_Attribute(cond_value_, rec.id, dummy_);
      Message_SYS.Get_Attribute(cond_type_, rec.id, cond_operator_);
      temp_ := dummy_;
      dummy_ := Context_Substitution_Var_API.Replace_Variables__(dummy_);
      IF (dummy_ IS NOT NULL) THEN
         IF (dummy_ LIKE ampersand_||'%') THEN
            cond_data_type_ := Fnd_Event_Parameter_API.Get_Parameter_Id_Type(event_lu_name_, event_id_, substr(dummy_, 2));
            IF (cond_data_type_ IS NULL) THEN
               Error_SYS.Appl_General(lu_name_, 'NOPARAM: Parameter :P1 is not available.', substr(dummy_, 2));
            ELSIF (cond_data_type_ <> rec.id_type) THEN
               Error_SYS.Appl_General(lu_name_, 'BADTYPE: Datatype mismatch between :P1 and :P2.',
                                      substr(dummy_, 2)||'('||cond_data_type_||')', rec.id||'('||rec.id_type||')');
            END IF;
         ELSIF rec.id_type IN ('DATETIME','DATE','TIME') THEN
            type_ := rec.id_type;
            -- first check if the statement is safe
            Assert_SYS.Assert_Is_Sysdate_Expression(Context_Substitution_Var_API.Replace_Variables__(temp_));
            dummy_ := Context_Substitution_Var_API.Replace_Variables__(temp_, TRUE);--get string in SQL format
            IF dummy_ != temp_ OR REGEXP_INSTR(temp_,sysdate_expr_) > 0 THEN
               -- execute and validate when CSV or user entered SYSDATE expressions are involved
               stmt_ := 'SELECT (' || dummy_ || ') FROM dual';

               @ApproveDynamicStatement(2011-03-08,chmulk)
               EXECUTE IMMEDIATE stmt_ INTO temp_date_;

               IF (type_ = 'DATETIME') THEN
                  dummy_ := to_char(temp_date_, 'YYYY-MM-DD-HH24.MI.SS');
               ELSIF (type_ = 'DATE') THEN
                  dummy_ := to_char(temp_date_, 'YYYY-MM-DD');
               ELSIF (type_ = 'TIME') THEN
                  dummy_ := to_char(temp_date_, 'HH24.MI.SS');
               END IF;
            ELSE
               -- Others validate normally
               IF (rec.id_type = 'DATETIME') THEN
                  format_ := Fnd_Setting_API.Get_Value('EVENT_REG_DATETIME');
                  dummy_ := to_char(to_date(dummy_, format_), 'YYYY-MM-DD-HH24.MI.SS');
               ELSIF (rec.id_type = 'DATE') THEN
                  format_ := Fnd_Setting_API.Get_Value('EVENT_REG_DATE');
                  dummy_ := to_char(to_date(dummy_, format_), 'YYYY-MM-DD');
               ELSIF (rec.id_type = 'TIME') THEN
                  format_ := Fnd_Setting_API.Get_Value('EVENT_REG_TIME');
                  dummy_ := to_char(to_date(dummy_, format_), 'HH24.MI.SS');
               END IF;
            END IF;
         ELSIF (rec.id_type = 'NUMBER') THEN
            IF cond_operator_ = 'LIKE' THEN
               IF NOT REGEXP_LIKE(dummy_, '[0-9_%.]{'|| nvl(LENGTH(dummy_),0) ||'}') THEN
                  Error_SYS.Appl_General(lu_name_, 'INVNUMEXP: :P1 is not a valid expression for a number.');
               END IF;
            ELSE
               Assert_SYS.Assert_Is_Number(dummy_);
            END IF;
         END IF;
      END IF;
   END LOOP;
EXCEPTION
   WHEN date_err THEN
      -- One last check, may be it is a SYSDATE expression.
      Assert_SYS.Assert_Is_Sysdate_Expression(dummy_);
   WHEN inv_month THEN
      Error_SYS.Appl_General(lu_name_, 'INVMONTH: The month specified in :P1 value ":P2" is invalid.',type_, dummy_);
   WHEN inv_day THEN
      Error_SYS.Appl_General(lu_name_, 'INVDAY: The day of the month specified in :P1 value ":P2" is invalid for the given month.',type_, dummy_);
   WHEN litrl_err OR image_err THEN
      -- input is not in the correct format
      Error_SYS.Appl_General(lu_name_, 'INVFORMAT: Invalid :P1 format for value ":P2" according to configuration ":P3".',type_, dummy_, format_);
--   WHEN cond_err THEN
--      RAISE;
--   WHEN OTHERS THEN
--      Error_SYS.Appl_General(lu_name_, 'INVFORMAT: Invalid :P1 format for value ":P2" according to configuration ":P3".',
--                             type_, dummy_, format_);
END Check_Condition_Format___;


FUNCTION Format___ (
   value_  IN  CLOB ) RETURN VARCHAR2
IS
   fmt_value_           CLOB;
   fmt_value_new_       CLOB;
   fmt_value_length_    NUMBER;
   quote_pos_           NUMBER;       --the position of last single quote of the extracted chunk of text
   cursor_              NUMBER :=1;
   len_upper_limit_     NUMBER :=90;  --maximum length of a line to be expoted is 120.( 29 should be deducted due to allignment(25) and string concatenation(4))
   alignment_           VARCHAR2(100) := '                         ';--25 spaces for alignment
   fmt_temp_            VARCHAR2(32000);
   str_too_long_        EXCEPTION;
   
BEGIN
   
   IF LENGTH(value_) > 32000 THEN      
      RAISE str_too_long_;
   END IF;
   fmt_value_ := Replace(value_, '''', '''''');
   fmt_value_ := REPLACE (REPLACE (fmt_value_,'&','''||CHR(38)||'''), chr(10), '''||CHR(10)||''');
   fmt_value_length_ := length(fmt_value_);
   
   -- if the lenght of the formatted string longer than the upper limit, loop it though to get expected length of blocks
   IF(fmt_value_length_ > len_upper_limit_) THEN
      WHILE ( fmt_value_length_ >= cursor_ + len_upper_limit_) LOOP
        fmt_temp_ := SUBSTR(fmt_value_ ,cursor_,len_upper_limit_);
        --if the number of single qhotes are multipliers of 2 or 0, chunk the string from upper limit
         IF ((LENGTH(fmt_temp_) - LENGTH(REPLACE(fmt_temp_,''''))) MOD 2 = 0) THEN
            fmt_value_new_ := fmt_value_new_ || fmt_temp_ ||'''||'||newline_|| alignment_||'''';
            cursor_        := cursor_ + len_upper_limit_;
        --otherwise find the position of last single quote of the extracted text and chunk from that position to make the number of 
        --single quotes are that of multipliers of 2 or 0
        ELSE
          quote_pos_ := instr(fmt_temp_, '''', -1) - 1;
          fmt_value_new_ := fmt_value_new_ || SUBSTR(fmt_value_ , cursor_ , quote_pos_) ||'''||'||newline_|| alignment_||'''';
          cursor_        := cursor_ + quote_pos_;
        END IF;
      END LOOP;
   END IF;
   
   --concatenate last line   
      fmt_value_new_ := ('''' || fmt_value_new_|| SUBSTR(fmt_value_ ,cursor_) || '''');
   -- ASCIISTR function does not support morethan 32000 chars 
   IF LENGTH(fmt_value_new_) > 32000 THEN
      RAISE str_too_long_;
   END IF;
   --Handle invalid charachters in export 
      fmt_value_new_ :=  'Database_SYS.Unistr(' || Database_SYS.Asciistr(fmt_value_new_) || ')';
   
   IF LENGTH(fmt_value_new_) > 32000 THEN
      RAISE str_too_long_;
   END IF;
   RETURN  fmt_value_new_;
   
EXCEPTION 
   WHEN str_too_long_ THEN
      Error_SYS.Appl_General(lu_name_, 'TOOLONG: Event Action is too large to be exported as a SQL file. Use Application Configuration Package to export the Event Action.');
   
END Format___;


FUNCTION Set_Event_Parameters___ (
   text_      IN CLOB,
   msg_       IN CLOB,
   action_type_       IN VARCHAR2 ) RETURN CLOB
IS
   temp_      CLOB;
   name_arr_  Message_SYS.name_table_clob;
   value_arr_ Message_SYS.line_table_clob;
   total_     NUMBER;
   count_     NUMBER;
   maxlen_    NUMBER;
   data_new_line_ VARCHAR2(2) := CHR(10);
BEGIN

   Message_SYS.Get_Clob_Attributes(msg_, total_, name_arr_, value_arr_);
   temp_ := replace(text_, '&'||'&', 'URL_PARAM');

   maxlen_ := 1;
   FOR n IN 1..total_ LOOP
      --
      -- Find the maximum length of parameter name
      --
      IF (length(name_arr_(n)) > maxlen_) THEN
         maxlen_ := length(name_arr_(n));
      END IF;
      --
      -- Insert continuation markers for multi line values
      --
      value_arr_(n) := REPLACE(value_arr_(n), data_new_line_, data_new_line_||'-');
      --
      -- handle quotes in parameter values
      --
      IF action_type_ = 'EXECUTEONLINESQL' THEN
         value_arr_(n) := replace(value_arr_(n),'''', '''''');
      END IF;
   END LOOP;
   --
   -- Start from this length and down to 1.
   -- Stop when all parameters are replaced
   --
   count_ := 0;
   FOR len IN REVERSE 1..maxlen_ LOOP
      FOR i IN 1..total_ LOOP
         IF (length(name_arr_(i)) = len) THEN
            temp_ := Replace(temp_, '&'||upper(name_arr_(i)), value_arr_(i));
            count_ := count_ + 1;
         END IF;
      END LOOP;
      EXIT WHEN count_ = total_;
   END LOOP;
   RETURN(replace(temp_, 'URL_PARAM', '&'));
END Set_Event_Parameters___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTION_ENABLE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SUBSCRIBABLE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED', 'FALSE', attr_);
END Prepare_Insert___;

FUNCTION Get_Next_Action_No___ (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2) RETURN NUMBER
IS
   action_no_ NUMBER;
BEGIN
   SELECT max(action_number) + 1 INTO action_no_
   FROM FND_EVENT_ACTION_TAB
   WHERE event_lu_name = event_lu_name_
   AND event_id = event_id_;
   
   RETURN action_no_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 0;
END Get_Next_Action_No___;

FUNCTION Get_Max_Action_No__ (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2) RETURN NUMBER
IS
   action_no_ NUMBER;
BEGIN
   SELECT max(action_number) INTO action_no_
   FROM FND_EVENT_ACTION_TAB
   WHERE event_lu_name = event_lu_name_
   AND event_id = event_id_;
   
   RETURN action_no_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 0;
END Get_Max_Action_No__;

FUNCTION Get_Rest_Auth_Params__ (
   action_param_clob_ IN CLOB,
   auth_param_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   auth_options_ VARCHAR2(3000) := Message_SYS.Find_Attribute(action_param_clob_,'AUTH_OPTIONS',' ');
   temp_ VARCHAR2(3000);
BEGIN
   IF(auth_param_ ='BASE_LOGIN') THEN
      temp_ := SUBSTR(auth_options_,INSTR(auth_options_,'Basic')+6);   
      temp_ := Ins_Util_API.From_Base64(temp_);
      temp_ := SUBSTR(temp_,0,INSTR(temp_,':')-1);
   ELSIF(auth_param_ ='BASE_PASSWORD') THEN
      temp_ := SUBSTR(auth_options_,INSTR(auth_options_,'Basic')+6);   
      temp_ := Ins_Util_API.From_Base64(temp_);
      temp_ := SUBSTR(temp_,INSTR(temp_,':')+1);
   ELSIF(auth_param_ ='AUTH_API_KEY') THEN
      temp_ := SUBSTR(auth_options_,INSTR(auth_options_,'Bearer')+7);   
   ELSIF(auth_param_ ='AUTH_AZURE_API_KEY') THEN
      temp_ := SUBSTR(auth_options_,INSTR(auth_options_,'Key')+4); 
   ELSIF(auth_param_ ='CLIENT_ID') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'client_id:')+10,INSTR(auth_options_,'client_secret:')-INSTR(auth_options_,'client_id:')-11);
   ELSIF(auth_param_ ='CLIENT_SECRET') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'client_secret:')+14,INSTR(auth_options_,'endpoint:')-INSTR(auth_options_,'client_secret:')-15);
   ELSIF(auth_param_ ='TOKEN_END_POINT') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'endpoint:')+9,INSTR(auth_options_,'resource:')-INSTR(auth_options_,'endpoint:')-10);
   ELSIF(auth_param_ ='REST_RESOURCE') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'resource:')+9);
   ELSIF(auth_param_ ='USER_ID') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'user_id:')+8,INSTR(auth_options_,'password:')-INSTR(auth_options_,'user_id:')-9);
   ELSIF(auth_param_ ='ROPC_PASSWORD') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'password:')+9,INSTR(auth_options_,'endpoint:')-INSTR(auth_options_,'password:')-10);
   ELSIF(auth_param_ ='ROPC_TOKEN_END_POINT') THEN
      temp_ :=SUBSTR(auth_options_,INSTR(auth_options_,'endpoint:')+9);      
   END IF;
   RETURN temp_ ;
END Get_Rest_Auth_Params__;
      
FUNCTION Get_Rest_Attachments__ (
   action_param_clob_ IN CLOB,
   attachment_param_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   blob_info_ VARCHAR2(3000) := Message_SYS.Find_Attribute(action_param_clob_,'BLOB_INFO',' ');
   temp_ VARCHAR2(3000);
BEGIN
   IF attachment_param_ = 'TABLE_NAME' THEN
      temp_ := substr(blob_info_,0,instr(blob_info_,',',1,1)-1);
   ELSIF attachment_param_ = 'BLOB_COLOUM' THEN
       temp_ := substr(blob_info_,instr(blob_info_,',',1,1)+1,instr(blob_info_,',',1,2)-instr(blob_info_,',',1,1)-1);
   ELSIF attachment_param_ = 'ROW_KEY' THEN
       temp_ := substr(blob_info_,instr(blob_info_,',',1,3)+1);
   END IF;  
   RETURN temp_ ;
   END Get_Rest_Attachments__;
   
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_EVENT_ACTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   max_action_number_ NUMBER;
   msg_               VARCHAR2(4000);
BEGIN
   
   IF (newrec_.action_number IS NULL) THEN 
      max_action_number_ := Get_Next_Action_No___(newrec_.event_lu_name, newrec_.event_id);
      newrec_.action_number := nvl(max_action_number_, 0);
   END IF;
   newrec_.system_defined := nvl(newrec_.system_defined, Fnd_Boolean_API.DB_FALSE);   
   Check_Condition_Format___(newrec_.event_lu_name, newrec_.event_id, newrec_.condition_type ,newrec_.condition_value);
   IF newrec_.definition_modified_date IS NULL THEN
      newrec_.definition_modified_date := sysdate;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   -- creates a trigger in an autonomous transaction
   Fnd_Event_API.Set_Event_Enable(newrec_.event_lu_name, newrec_.event_id);
   
   Client_SYS.Add_To_Attr('ACTION_NUMBER', newrec_.action_number, attr_);
   
   IF (NOT Installation_Sys.Get_Installation_Mode)
       AND (newrec_.fnd_event_action_type = 'BPA') THEN
      msg_ := Message_SYS.Construct('EVENT_ACTION_BPA_CHANGE' );
      Message_SYS.Add_Attribute(msg_, 'EVENT_LU_NAME', newrec_.event_lu_name );
      Message_SYS.Add_Attribute(msg_, 'EVENT_ID', newrec_.event_id );
      Message_SYS.Add_Attribute(msg_, 'ACTION_NUMBER', newrec_.action_number );
      Message_SYS.Add_Attribute(msg_, 'ACTION_ENABLE', newrec_.action_enable );
      Message_SYS.Add_Attribute(msg_, 'ROWVERSION', newrec_.rowversion );
      Message_SYS.Add_Attribute(msg_, 'ROWKEY', newrec_.rowkey );
      -- fnd_event_action_type is included to avoid code changes to the ODP
      -- this should be refactored in the future
      Message_SYS.Add_Attribute(msg_, 'FND_EVENT_ACTION_TYPE_DB', newrec_.fnd_event_action_type );
      Message_SYS.Add_Attribute(msg_, 'SYSTEM_DEFINED', newrec_.system_defined );
      -- all other attributes are too large to fit into a msg
      
      Event_SYS.Event_Execute('FndEventAction', 'EVENT_ACTION_BPA_CHANGE', msg_);
   END IF;
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_EVENT_ACTION_TAB%ROWTYPE,
   newrec_     IN OUT FND_EVENT_ACTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   msg_               VARCHAR2(4000);
BEGIN
   newrec_.system_defined := nvl(newrec_.system_defined, Fnd_Boolean_API.DB_FALSE);
   Check_Condition_Format___(newrec_.event_lu_name, newrec_.event_id, newrec_.condition_type, newrec_.condition_value);
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (NOT Installation_Sys.Get_Installation_Mode)
       AND (oldrec_.fnd_event_action_type = 'BPA' OR newrec_.fnd_event_action_type = 'BPA') THEN
      msg_ := Message_SYS.Construct('EVENT_ACTION_BPA_CHANGE' );
      Message_SYS.Add_Attribute(msg_, 'EVENT_LU_NAME', newrec_.event_lu_name );
      Message_SYS.Add_Attribute(msg_, 'EVENT_ID', newrec_.event_id );
      Message_SYS.Add_Attribute(msg_, 'ACTION_NUMBER', newrec_.action_number );
      Message_SYS.Add_Attribute(msg_, 'ACTION_ENABLE', newrec_.action_enable );
      Message_SYS.Add_Attribute(msg_, 'ROWVERSION', newrec_.rowversion );
      Message_SYS.Add_Attribute(msg_, 'ROWKEY', newrec_.rowkey );
      -- fnd_event_action_type is included to avoid code changes to the ODP
      -- this should be refactored in the future
      Message_SYS.Add_Attribute(msg_, 'FND_EVENT_ACTION_TYPE_DB', newrec_.fnd_event_action_type );
      Message_SYS.Add_Attribute(msg_, 'SYSTEM_DEFINED', newrec_.system_defined );
      -- all other attributes are too large to fit into a msg
      
      Event_SYS.Event_Execute('FndEventAction', 'EVENT_ACTION_BPA_CHANGE', msg_);
   END IF;
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ fnd_event_action_tab%ROWTYPE;
   oldrec_   fnd_event_action_tab%ROWTYPE;
BEGIN
   IF action_ = 'DO' THEN
      Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
      oldrec_ := Get_Object_By_Id___(objid_);
   END IF;

    super(info_, objid_, objversion_, attr_, action_);

   -- Moved From Update___
   IF action_ = 'DO' THEN
      newrec_ := Get_Object_By_Id___(objid_);      
      IF oldrec_.action_enable <> newrec_.action_enable THEN
         -- creates a trigger in an autonomous transaction
         Fnd_Event_API.Set_Event_Enable(newrec_.event_lu_name, newrec_.event_id);
      END IF;
   END IF;  

END Modify__;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_EVENT_ACTION_TAB%ROWTYPE )
IS
BEGIN
   
   super(objid_, remrec_);
   -- creates a trigger in an autonomous transaction
   Fnd_Event_API.Set_Event_Enable(remrec_.event_lu_name, remrec_.event_id);
END Delete___;


FUNCTION Replace_CF_Variables___ (
   string_ IN CLOB,
   msg_    IN VARCHAR2 ) RETURN CLOB 
IS
   tmp_           CLOB;
   column_name_   VARCHAR2(30);
   value_         VARCHAR2(4000);
   prefix_        VARCHAR2(10) := '<CF>';
   postfix_       VARCHAR2(10) := '<\CF>';
   i_             BINARY_INTEGER := 0;
   FUNCTION Get_Variable___ (
      string_ IN CLOB ) RETURN CLOB 
   IS
   BEGIN
      RETURN(Utility_SYS.Between_Clob(string_, prefix_, postfix_, 'FALSE'));
   END Get_Variable___;
BEGIN
   -- Replaces occurences in string_ of <CF>column_name<CF\> with the corresponding Custom Fields value and return the new string
   tmp_ := string_;
   -- Get variable
   column_name_ := Get_Variable___(tmp_);
   i_ := i_ + 1;
   WHILE (column_name_ IS NOT NULL AND i_ <= 50) LOOP
      $IF Component_Fndcob_SYS.INSTALLED $THEN
         -- Fetch value from Custom Fields
         value_ := Custom_Fields_SYS.Get_Formatted_String_Value(Message_SYS.Find_Attribute(msg_, 'LU', ''), Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD, column_name_, Message_SYS.Find_Attribute(msg_, 'ROWKEY', ''));
      $END
      -- Replace value
      tmp_ := Replace(tmp_, prefix_ || column_name_ || postfix_, value_);
      -- Get variable
      column_name_ := Get_Variable___(tmp_);
      i_ := i_ + 1;
   END LOOP;
   RETURN(tmp_);
END Replace_CF_Variables___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_event_action_tab%ROWTYPE,
   newrec_ IN OUT fnd_event_action_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   too_long EXCEPTION;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF newrec_.fnd_event_action_type  IN ('EXECUTEONLINESQL') THEN
      Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   END IF;
   IF length(newrec_.condition_value) > 4000 THEN
      name_ := 'CONDITION_VALUE';
      RAISE too_long;
   END IF;
   IF length(newrec_.condition_type) > 4000 THEN
      name_ := 'CONDITION_TYPE';
      RAISE too_long;
   END IF;
   IF newrec_.subscribable = 'TRUE' AND newrec_.fnd_event_action_type NOT IN ('MAIL', 'SMSMESSAGE') THEN
      Error_SYS.Record_General(lu_name_, 'UNSUBSCRIBABLEEV_I: An event action of the type :P1 is not possible to make subscribable', Fnd_Event_Action_Type_API.Decode(newrec_.fnd_event_action_type));
   END IF;

EXCEPTION
   WHEN too_long THEN
      Error_SYS.Record_General(lu_name_, 'TOOLONGVAR: The attribute :P1 is too long and exceeds 2000, please reduce the attributes in Event Action',name_);
END Check_Common___;

PROCEDURE Check_Package___ (
   remrec_ IN fnd_event_action_tab%ROWTYPE )
IS
   package_name_ VARCHAR2(100);
BEGIN
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: The Event Action cannot be deleted, unless removed from the package ":P1".', package_name_);
   END IF;   
END Check_Package___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN fnd_event_action_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   IF (remrec_.system_defined = Fnd_Boolean_API.DB_TRUE) THEN
      Error_SYS.Appl_General(lu_name_, 'DEL_SYSTEM_DEFINED: You are not allowed to remove system defined event actions.');
   END IF;
   super(remrec_);
   Check_Package___(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     fnd_event_action_tab%ROWTYPE,
   newrec_ IN OUT fnd_event_action_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   
   IF (newrec_.system_defined = Fnd_Boolean_API.DB_TRUE) THEN
      --Should only be possible to modify subscriptions and action enabling from the client if it is system defined Event
      IF (indrec_.fnd_event_action_type OR indrec_.condition_type OR indrec_.condition_value OR indrec_.description ) THEN
         Error_SYS.Appl_General(lu_name_, 'SYSTEM_DEFINED: You are not allowed to change system defined event actions.');
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


FUNCTION Get_Object_By_Rowkey___ (
   rowkey_ IN VARCHAR2 ) RETURN fnd_event_action_tab%ROWTYPE
IS
   lu_rec_ fnd_event_action_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  fnd_event_action_tab
      WHERE rowkey = rowkey_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rowkey_, NULL, NULL, 'Get_Object_By_Rowkey___');
END Get_Object_By_Rowkey___;

FUNCTION Import_Impl___ (
   rec_ IN fnd_event_action_tab%ROWTYPE,
   info_ OUT VARCHAR2,
   exp_def_version_ IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
   action_parameters_ CLOB;
   action_            fnd_event_action_tab%ROWTYPE;
   valid_rec_         fnd_event_action_tab%ROWTYPE;
   attachment_        CLOB;
   attach_removed_    BOOLEAN:=FALSE;
   identical_         BOOLEAN:=TRUE;

   PROCEDURE Import_Modify___ (
      newrec_         IN OUT NOCOPY fnd_event_action_tab%ROWTYPE,
      lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
   IS
      objid_      VARCHAR2(20);
      objversion_ VARCHAR2(100);
      attr_       VARCHAR2(32000);
      --indrec_     Indicator_rec;
      oldrec_     fnd_event_action_tab%ROWTYPE;
   BEGIN
      IF (lock_mode_wait_) THEN
         oldrec_ := Lock_By_Keys___(newrec_.event_lu_name, newrec_.event_id, newrec_.action_number);
      ELSE
         oldrec_ := Lock_By_Keys_Nowait___(newrec_.event_lu_name, newrec_.event_id, newrec_.action_number);
      END IF;
      --indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      --Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.event_lu_name, newrec_.event_id, newrec_.action_number);
      Write_Action_Parameters__(objversion_, objid_, action_parameters_);
   END Import_Modify___;

   PROCEDURE Import_New___ (
      newrec_ IN OUT NOCOPY fnd_event_action_tab%ROWTYPE )
   IS
      objid_         VARCHAR2(20);
      objversion_    VARCHAR2(100);
      attr_          VARCHAR2(32000);
      rowkey_        VARCHAR2(50) := newrec_.rowkey;
      --indrec_        Indicator_Rec;
      emptyrec_      fnd_event_action_tab%ROWTYPE;
   BEGIN
      --indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
      --Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      IF (rowkey_ IS NOT NULL) THEN 
         -- Set rowkey to the imported value
         newrec_.rowkey := rowkey_;
         Update___(objid_, emptyrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
      Write_Action_Parameters__(objversion_, objid_, action_parameters_);
   END Import_New___;

   FUNCTION Check_Exist_Rowkey___ (
      rowkey_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      --dummy_ NUMBER;
      event_lu_name_ VARCHAR2(30);
      event_id_      VARCHAR2(50);
      action_number_ NUMBER;
   BEGIN
      SELECT event_lu_name, event_id, action_number
         INTO  event_lu_name_, event_id_, action_number_
         FROM  fnd_event_action_tab
         WHERE rowkey = rowkey_;
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(event_lu_name_, event_id_, action_number_, 'Check_Exist_Rowkey___');
   END Check_Exist_Rowkey___;
   --
   FUNCTION Insert_Import___ RETURN BOOLEAN 
   IS
         BEGIN
      -- New
      action_.event_id := valid_rec_.event_id;
      action_.event_lu_name := valid_rec_.event_lu_name;
      action_.action_number := valid_rec_.action_number;

      IF Check_Exist___(action_.event_lu_name, action_.event_id, action_.action_number) THEN
         -- An Action with the same number exists, But it's not the same thing
         -- So we create a new action number
         action_.action_number := Get_Next_Action_No___(action_.event_lu_name, action_.event_id);
         --App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'NEW_ACT_NO: A new Action Number was Created for the Event Action));
         -- ELSE
         -- we use the same Action No
      END IF;

      action_.action_enable := valid_rec_.action_enable;
      action_.action_parameters := valid_rec_.action_parameters;
      action_.condition_type := valid_rec_.condition_type;
      action_.condition_value := valid_rec_.condition_value;
      action_.definition_modified_date := valid_rec_.definition_modified_date;
      action_.description := Utility_SYS.Set_Windows_New_Line(valid_rec_.description);
      action_.fnd_event_action_type := valid_rec_.fnd_event_action_type;
      -- Set subscribable to FALSE if system-defined is TRUE
      IF (valid_rec_.system_defined = Fnd_Boolean_API.DB_FALSE) THEN
         action_.role := valid_rec_.role;
         action_.subscribable := valid_rec_.subscribable;
      ELSE
         action_.role := NULL;
         action_.subscribable := Fnd_Boolean_API.DB_FALSE;
      END IF;
      action_.system_defined := valid_rec_.system_defined;
      action_.rowkey := valid_rec_.rowkey;
      Import_New___(action_);
      RETURN(FALSE);
   END Insert_Import___;
   
   FUNCTION Modify_Import___  RETURN BOOLEAN
   IS
   BEGIN
      -- Action Exits, we ignore the Action No in the XML and take the Action_No in this DB
      action_ := Get_Object_By_Rowkey___(valid_rec_.rowkey);
      IF (action_.definition_modified_date <> Nvl(valid_rec_.definition_modified_date, sysdate) OR
             NVL(valid_rec_.system_defined,'FALSE') = Fnd_Boolean_API.DB_TRUE OR
             action_.system_defined = Fnd_Boolean_API.DB_TRUE) THEN
         --Skipped action enabling when importing
         action_.action_parameters := valid_rec_.action_parameters;
         action_.condition_type := valid_rec_.condition_type;
         action_.condition_value := valid_rec_.condition_value;
         action_.definition_modified_date := valid_rec_.definition_modified_date;
         action_.description := Utility_SYS.Set_Windows_New_Line(valid_rec_.description);
         action_.fnd_event_action_type := valid_rec_.fnd_event_action_type;
         IF (valid_rec_.system_defined = Fnd_Boolean_API.DB_FALSE) THEN
         	action_.role := valid_rec_.role;
         	action_.subscribable := valid_rec_.subscribable;
         END IF;
         action_.system_defined := valid_rec_.system_defined;
         Import_Modify___(action_);
         RETURN(FALSE);
      ELSE
         RETURN(TRUE); 
      END IF;
   END Modify_Import___;

   PROCEDURE Remove_old_attachments___
   IS
   BEGIN
      Message_SYS.Set_Clob_Attribute(valid_rec_.action_parameters,'ATTACH','');
      attach_removed_ := TRUE;
   END Remove_old_attachments___;
   
BEGIN
   info_ := NULL;
   valid_rec_ := rec_;
   attachment_ := Message_SYS.Find_Clob_Attribute(valid_rec_.action_parameters,'ATTACH','');
   --Removing old type attachments
   IF (exp_def_version_ = 1 AND
         valid_rec_.fnd_event_action_type = Fnd_Event_Action_Type_API.DB_E_MAIL AND
         DBMS_LOB.Getlength(attachment_)>0) THEN
      -- Imported from .xml (ACP)
      Remove_old_attachments___;
   ELSIF (exp_def_version_ IS NULL AND
         valid_rec_.fnd_event_action_type = Fnd_Event_Action_Type_API.DB_E_MAIL AND
         DBMS_LOB.Getlength(attachment_)>0) THEN
      -- Imported from .ins
      IF Message_SYS.Find_Clob_Attribute(attachment_,'ATTACHMENT','') IS NULL THEN
         Remove_old_attachments___;
      END IF;
   END IF;
   action_parameters_ := valid_rec_.action_parameters;
   -- First check if the Action Exists using the ROWKEY. (we cannot rely on the Action_No)
   --   action_key_ := Get_Key_By_Rowkey(rec_.rowkey);
   --   
   IF (Check_Exist_Rowkey___(valid_rec_.rowkey)) THEN  -- Check if record exists
      identical_ := Modify_Import___;
   ELSE 
      identical_ := Insert_Import___;
   END IF;
   IF attach_removed_ THEN
      info_ := Language_SYS.Translate_Constant(lu_name_,'ATTACH_REMOVED: ":P1" imported by removing attachments. Please reconfigure attachments manually from the application.', Fnd_Session_API.Get_Language,
                                               App_Config_Util_API.Get_Item_Name(valid_rec_.rowkey, App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION));
   END IF;
   RETURN identical_;
END Import_Impl___;
   
FUNCTION Is_Valid_User___ (
   username_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   IF username_ LIKE '&%' THEN
      RETURN TRUE;
   ELSIF username_ LIKE '#%#' THEN
      RETURN TRUE;
   ELSE   
      RETURN Fnd_User_API.Exists(UPPER(username_));
   END IF;
END Is_Valid_User___;

PROCEDURE Validate_Action_App_Message___ (      
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   action_      IN     fnd_event_action_tab%ROWTYPE)
IS
   connector_        VARCHAR2(2000);
   address_data_     VARCHAR2(2000);
   envelope_         VARCHAR2(2000);
   transformer_      VARCHAR2(2000);
   str_null_ VARCHAR2(1) := NULL;
BEGIN
   connector_    := Message_SYS.Find_Attribute(action_.action_parameters, 'CONNECTOR', str_null_);
   address_data_ := Message_SYS.Find_Attribute(action_.action_parameters, 'ADDRESS_DATA', str_null_);
   envelope_     := Message_SYS.Find_Attribute(action_.action_parameters, 'ENVELOPE', str_null_);
   transformer_  := Message_SYS.Find_Attribute(action_.action_parameters, 'TRANSFORMER', str_null_);

   -- Logic taken from Command_SYS.Event_Application_Message_
   IF connector_ IS NOT NULL OR address_data_ IS NOT NULL THEN
      IF NOT (connector_ IS NOT NULL AND address_data_ IS NOT NULL) THEN
         Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_INV_APP1:  Warning: The Application Message Event Action configuration is invalid. Both values for Connector and Address Data must be specified if any of them are specified.')));
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
      END IF;
   ELSIF envelope_ IS NOT NULL OR transformer_ IS NOT NULL THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_INV_APP2:  Warning: The Application Message Event Action configuration is invalid. Envelope and Transformer cannot be stated unless both Connector and Address Data are specified')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   END IF;
END Validate_Action_App_Message___;

PROCEDURE Validate_Action_Email___ (      
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   action_      IN     fnd_event_action_tab%ROWTYPE)
IS
   value_ VARCHAR2(32000);
   str_null_ VARCHAR2(1) := NULL;
   name_table_ Command_SYS.name_table;
   email_count_ NUMBER;
   non_exist_users_ VARCHAR2(32000);
BEGIN
   value_ := Message_SYS.Find_Attribute(action_.action_parameters, 'TO', str_null_);

   IF value_ IS NULL OR value_ = '' THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_NO_TO:  Warning: The E-mail Event Action does not contain any value for the "To" Address Field.')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   ELSE
      Command_SYS.Tokenize(name_table_, email_count_, value_);
      FOR i_ IN 1..email_count_ LOOP
         -- Can't validate Emails, only Fnd Users
         IF INSTR(name_table_(i_), '@') = 0 THEN
            IF NOT Is_Valid_User___(name_table_(i_)) THEN
               non_exist_users_ := non_exist_users_ || ', ' || name_table_(i_);
            END IF;
         END IF;
      END LOOP;

      IF non_exist_users_ IS NOT NULL THEN
         non_exist_users_ := LTRIM(non_exist_users_, ', ');
         Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_TO_NOUSER:  Warning: The following user(s) does not exists in the application and will not receive the generated Event Action E-mail [:P1].', Fnd_Session_API.Get_Language, non_exist_users_)));
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
      END IF;
   END IF;

   value_ := Message_SYS.Find_Attribute(action_.action_parameters, 'SUBJECT', str_null_);

   IF value_ IS NULL OR value_ = '' THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_NO_SUBJECT:  Warning: The E-mail Event Action does not contain any value for the "Subject" Field.')), TRUE);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   END IF;
END Validate_Action_Email___;

PROCEDURE Validate_Action_Task___ (      
  info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
  action_      IN     fnd_event_action_tab%ROWTYPE)
IS
   value_ VARCHAR2(32000);
   str_null_ VARCHAR2(1) := NULL;
   name_table_ Command_SYS.name_table;
   user_count_ NUMBER;
   non_exist_users_ VARCHAR2(32000);
BEGIN
   value_ := Message_SYS.Find_Attribute(action_.action_parameters, 'RECEIVER', str_null_);

   IF value_ IS NULL OR value_ = '' THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_TASK_NO_TO:  Warning: The Task Event Action does not contain any value for the "Receiver" Field.')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   ELSE
      Command_SYS.Tokenize(name_table_, user_count_, value_);
      FOR i_ IN 1..user_count_ LOOP
         IF NOT Is_Valid_User___(name_table_(i_)) THEN
            non_exist_users_ := non_exist_users_ || ', ' || name_table_(i_);
         END IF;
      END LOOP;

      IF non_exist_users_ IS NOT NULL THEN
         non_exist_users_ := LTRIM(non_exist_users_, ', ');
         Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_REC_NOUSER:  Warning: The following user(s) does not exists in the application and will not receive the Event Action Task [:P1].', Fnd_Session_API.Get_Language, non_exist_users_)));
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
      END IF;
   END IF;
END Validate_Action_Task___;

PROCEDURE Validate_Action_Streams___ (      
  info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
  action_      IN     fnd_event_action_tab%ROWTYPE)
IS
   users_ VARCHAR2(32000);
   str_null_ VARCHAR2(1) := NULL;
   to_user_list_ Utility_SYS.STRING_TABLE;
   to_user_count_ NUMBER;
   non_exist_users_ VARCHAR2(32000);
BEGIN
   users_ := Message_SYS.Find_Attribute(action_.action_parameters, 'TO', str_null_);

   IF users_ IS NULL OR users_ = '' THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_STREAMS_NO_TO: Warning: The Streams Message Event Action does not contain any value for the "To" Field.')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   ELSE
      Utility_SYS.Tokenize (users_,',',to_user_list_,to_user_count_);
      FOR i_ IN 1..to_user_count_ LOOP
         IF NOT Is_Valid_User___(to_user_list_(i_)) THEN
            non_exist_users_ := non_exist_users_ || ', ' || to_user_list_(i_);
         END IF;
      END LOOP;

      IF non_exist_users_ IS NOT NULL THEN
         non_exist_users_ := LTRIM(non_exist_users_, ', ');
         Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_STR_NOUSER:  Warning: The following user(s) does not exists in the application and will not receive the Event Action Stream [:P1].', Fnd_Session_API.Get_Language, non_exist_users_)));
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
      END IF;
   END IF;
END Validate_Action_Streams___;

FUNCTION Parse_Sql___ (
   sql_errm_    OUT VARCHAR2,
   sql_errcode_ OUT NUMBER,
   stmt_        IN  VARCHAR2) RETURN BOOLEAN
IS
   cursor_ NUMBER;
   sql_    VARCHAR2(32000);
BEGIN
   sql_ := REGEXP_REPLACE(stmt_ ,chr(38)||'AO', Fnd_Session_API.Get_App_Owner);
   sql_ := REGEXP_REPLACE(sql_ ,'&\w+\s*:?\s*\w+', 'null');
   sql_ := Context_Substitution_Var_API.Replace_Stmt_value(sql_);
   cursor_ := dbms_sql.open_cursor;   
   @ApproveDynamicStatement(2016-04-07,nabalk)
   dbms_sql.parse(cursor_, sql_, dbms_sql.native);
   dbms_sql.close_cursor(cursor_);
   RETURN TRUE;
EXCEPTION
   WHEN OTHERS THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
END IF;
      sql_errm_ := utl_call_stack.error_msg(1);
      sql_errcode_ := SQLCODE;
      RETURN FALSE;
END Parse_Sql___;

FUNCTION Is_Included_In_Pkg____ (
   errm_        IN VARCHAR2,
   dep_objects_ IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
   output_table_ utility_sys.string_table;
   token_count_ NUMBER;
BEGIN
   Utility_sys.Tokenize(errm_, '''', output_table_, token_count_);

   FOR i_ IN 1..token_count_ LOOP
      IF instr(upper(output_table_(i_)), '_CFP') > 0 OR instr(upper(output_table_(i_)), '_CLP') > 0 THEN
         IF App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_, output_table_(i_), 'PACKAGE') THEN
            RETURN TRUE;
         ELSIF App_Config_Util_API.Method_Exist(output_table_(i_), dep_objects_) THEN
            RETURN TRUE;
         END IF;
      END IF;
   END LOOP;
   RETURN FALSE;
END Is_Included_In_Pkg____;   

PROCEDURE Validate_Action_SQL___ (
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,
   action_      IN     fnd_event_action_tab%ROWTYPE)
IS
   sql_ VARCHAR2(32000);
   str_null_ VARCHAR2(1) := NULL;

   sql_errm_ VARCHAR2(32000);
   sql_errcode_ NUMBER;
   warn_name_ VARCHAR2(100) := 'EVE_ACT_INV_SQL';
BEGIN
   IF NOT Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User, FALSE) THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_NO_DEFSQL: Error: You must have "DEFINE SQL" System Privilege to import Event Actions of type Execute Online SQL.')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      RETURN;
   END IF;
   sql_ := Message_SYS.Find_Attribute(action_.action_parameters, 'SQL', str_null_);
   
   IF sql_ IS NULL OR sql_ = '' THEN
      Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACT_NO_SQL:  Warning: The Execute Online SQL Event Action does not contain any code to Execute.')));
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
   ELSE
      -- We can't do much validation on the SQL at the moment.
      -- So we parse the SQL and see if it throws any errors
      IF NOT Parse_Sql___(sql_errm_, sql_errcode_, sql_) THEN
         -- Check if the Identifier mentioned is in the package
         -- If not just show a warning message saying that there's a possible error.
         IF NOT Is_Included_In_Pkg____(sql_errm_, dep_objects_)THEN
            -- Could be a possible error
            IF (length(sql_)<100)
            THEN
               Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,warn_name_||': Warning: Possible error in Event Action SQL. Error: :P1 ', Fnd_Session_API.Get_Language, newline_ || sql_ || sql_errm_ )));
            ELSE
               Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,warn_name_||': Warning: Possible errors in Event Action SQL.', Fnd_Session_API.Get_Language)));
            END IF;            
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
         END IF;
      END IF;
   END IF;
END Validate_Action_SQL___;

PROCEDURE Validate_Action___ (
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,
   action_      IN     fnd_event_action_tab%ROWTYPE)
IS
BEGIN
   CASE action_.fnd_event_action_type
      WHEN Fnd_Event_Action_Type_API.DB_APPLICATION_MESSAGE THEN
         Validate_Action_App_Message___(info_, action_);
      WHEN Fnd_Event_Action_Type_API.DB_E_MAIL THEN
         Validate_Action_Email___(info_, action_);
      WHEN Fnd_Event_Action_Type_API.DB_TASK THEN
         Validate_Action_Task___(info_, action_);
      WHEN Fnd_Event_Action_Type_API.DB_STREAMS_MESSAGE THEN
         Validate_Action_Streams___(info_, action_);
      WHEN Fnd_Event_Action_Type_API.DB_EXECUTE_ONLINE_SQL THEN
         Validate_Action_SQL___(info_, dep_objects_, action_);   
      ELSE
         NULL;
   END CASE;
END Validate_Action___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Export__ (
   string_           OUT CLOB,
   event_lu_name_    IN  VARCHAR2,
   event_id_         IN  VARCHAR2,
   action_number_    IN  NUMBER)
IS
   exp_string_    CLOB;
   event_rec_        fnd_event_action_tab%ROWTYPE;
   CURSOR get_event_actions IS
      SELECT *
      FROM   fnd_event_action_tab
      WHERE  event_lu_name = event_lu_name_
      AND event_id = event_id_
      AND action_number = action_number_;
   
BEGIN
          
      exp_string_ := 'SET DEFINE OFF' || newline_ || newline_
      || 'DECLARE' || newline_
      || '   info_msg_   CLOB;' || newline_
      || '   PROCEDURE Import_Event_Actions (' || newline_
      || '      event_lu_name_          IN VARCHAR2,' || newline_
      || '      event_id_               IN VARCHAR2,' || newline_
      || '      action_number_          IN NUMBER,'   || newline_
      || '      action_enable_          IN VARCHAR2,' || newline_
      || '      action_parameters_      IN CLOB,' || newline_
      || '      condition_type_         IN VARCHAR2,' || newline_
      || '      condition_value_        IN VARCHAR2,' || newline_
      || '      definition_modified_date_  IN DATE,' || newline_
      || '      fnd_event_action_type_  IN VARCHAR2,' || newline_
      || '      description_            IN VARCHAR2,' || newline_
      || '      subscribable_           IN VARCHAR2,' || newline_
      || '      system_defined_         IN VARCHAR2,' || newline_
      || '      role_                   IN VARCHAR2,' || newline_
      || '      rowkey_                 IN VARCHAR2 )' || newline_
      || '   IS' || newline_
      || '   BEGIN' || newline_
      || '      info_msg_ := NULL;' || newline_
      || '      info_msg_ := Message_SYS.Construct(''FND_EVENT_ACTION_TAB'');' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''EVENT_LU_NAME'', event_lu_name_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''EVENT_ID'', event_id_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''ACTION_NUMBER'', action_number_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''ACTION_ENABLE'', action_enable_);' || newline_
      || '      Message_SYS.Add_Clob_Attribute(info_msg_, ''ACTION_PARAMETERS'', to_char(action_parameters_));' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''CONDITION_TYPE'', condition_type_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''CONDITION_VALUE'', condition_value_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''DEFINITION_MODIFIED_DATE'', definition_modified_date_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''FND_EVENT_ACTION_TYPE'', fnd_event_action_type_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', description_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''SUBSCRIBABLE'', subscribable_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''SYSTEM_DEFINED'', system_defined_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''ROLE'', role_);' || newline_
      || '      Message_SYS.Add_Attribute(info_msg_, ''ROWKEY'', rowkey_);' || newline_
      || '      Fnd_Event_Action_API.Register(info_msg_);' || newline_
      || '   END;' || newline_
      || 'BEGIN' || newline_;
      OPEN get_event_actions;
      FETCH get_event_actions INTO event_rec_;
       IF  (get_event_actions%FOUND) THEN
               exp_string_ := exp_string_ || '   Import_Event_Actions( ' || Format___(event_lu_name_) || ',' || newline_ ||
               '                         ' || Format___(event_id_) || ', ' || newline_ ||
               '                         ' || Format___(TO_CHAR(action_number_)) || ',' || newline_ ||
               '                         ' || Format___(event_rec_.action_enable) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.action_parameters) || ',' || newline_ ||
               '                         ' || Format___(event_rec_.condition_type) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.condition_value) || ',' || newline_ ||
               '                         ' || 'To_Date('||Format___(to_char(event_rec_.definition_modified_date, Client_SYS.Date_Format_))|| ', ''' || Client_SYS.Date_Format_ || '''),' || newline_ ||      
               '                         ' || Format___(event_rec_.fnd_event_action_type) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.description) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.subscribable) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.system_defined) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.role) || ', ' || newline_ ||
               '                         ' || Format___(event_rec_.rowkey) || ');' ;
 
      ELSE         
         exp_string_ := exp_string_ || '   NULL;';
      END IF;
      CLOSE get_event_actions;      
      exp_string_ := exp_string_ || newline_ ||  'END;' || newline_ || '/' || newline_ || 'COMMIT' || newline_ || '/' || newline_ || 'SET DEFINE ON' || newline_ || newline_;

      string_ := exp_string_;
END Export__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Activate_Action (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER,
   msg_           IN CLOB )
IS
   task_msg_      VARCHAR2(2000);
   log_value_           NUMBER;
   action_parameters_   CLOB;
   message_             CLOB := msg_;
   task_action_params_  CLOB;

   fnd_event_action_type_  FND_EVENT_ACTION.fnd_event_action_type_db%TYPE;
   fnd_event_action_desc_  FND_EVENT_ACTION.description%TYPE;
   rowkey_                 FND_EVENT_ACTION_TAB.rowkey%TYPE;
   subscribable_           fnd_event_action_tab.subscribable%TYPE;
   CURSOR get_props IS
   SELECT action_parameters, fnd_event_action_type, description, rowkey
     FROM fnd_event_action_tab
    WHERE event_lu_name = event_lu_name_
      AND event_id = event_id_
      AND action_number = action_number_;

   CURSOR get_subscribers(subscribe_ IN VARCHAR2) IS
   SELECT identity
     FROM fnd_event_action_subscribe
    WHERE event_lu_name = event_lu_name_
      AND event_id = event_id_
      AND action_number = action_number_
      AND subscribe_ = 'TRUE';
BEGIN
   OPEN get_props;
   FETCH get_props INTO action_parameters_, fnd_event_action_type_, fnd_event_action_desc_, rowkey_;
   CLOSE get_props;

   --
   Message_SYS.Add_Attribute(message_, 'EVENT_ACTION_ROWKEY', rowkey_);
   subscribable_ := Fnd_Event_Action_API.Get_Subscribable(event_lu_name_, event_id_, action_number_);
   --
   IF fnd_event_action_type_ = 'MAIL' THEN
      -- Send first mail only if receiver has been stated
      IF Message_SYS.Find_Attribute(action_parameters_, 'TO', to_char(NULL)) IS NOT NULL THEN
         Message_SYS.Add_Attribute(message_, 'SENDER', event_id_);
         Action_Mail(action_parameters_, message_);
      ELSE
         log_value_ := Server_Log_API.Log_Autonomous(NULL,event_log_category_, '['|| event_lu_name_ || ': '|| event_id_ ||'] Action: '||fnd_event_action_type_, 'Reciever is not specified');
      END IF;
      FOR subscriber IN get_subscribers(subscribable_) LOOP
         -- Modify the receiving address to send this to all subscribers too.
         Message_SYS.Set_Attribute(action_parameters_, 'TO', Fnd_User_API.Get_Property(subscriber.identity, 'SMTP_MAIL_ADDRESS'));
         Action_Mail(action_parameters_, message_);
      END LOOP;
      -- TO mailadress
   ELSIF fnd_event_action_type_ = 'EXECUTEONLINESQL' THEN
      Action_Executeonlinesql(action_parameters_, message_);
   ELSIF fnd_event_action_type_ = 'APPLICATIONMESSAGE' THEN
      Action_Application_Message(action_parameters_, message_);
   ELSIF fnd_event_action_type_ = 'TASK' THEN
      task_msg_ := msg_; 	
      Message_SYS.Add_Attribute(task_msg_, 'BUSINESS_OBJECT', event_lu_name_);	
      -- Use a copy of action_parameters_ to avoid locking errors when value is edited
      DBMS_LOB.createtemporary(task_action_params_, FALSE, DBMS_LOB.Call);
      DBMS_LOB.copy(task_action_params_, action_parameters_, DBMS_LOB.getlength(action_parameters_));
      Message_SYS.Add_Attribute(task_action_params_, 'BUSINESS_OBJECT', event_lu_name_);
      Action_Task(task_action_params_, task_msg_);
      DBMS_LOB.freetemporary(task_action_params_);
   ELSIF fnd_event_action_type_ = 'STREAMSMESSAGE' THEN
      Action_Streams_Message(action_parameters_, message_);
   ELSIF fnd_event_action_type_ = 'RESTCALL' THEN
      Action_Rest(action_parameters_, message_);
   ELSIF fnd_event_action_type_ = 'BPA' THEN
      Action_Bpa(action_parameters_, message_);
   ELSE
      Error_SYS.Appl_General(lu_name_,'NOSUIT: Unhandled action type ":P1" in action handler.',
                             fnd_event_action_type_);
   END IF;
EXCEPTION 
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061 , -4065 , -4068) OR ( SQLCODE <= -20000) THEN
            RAISE;
      ELSIF ( SQLCODE > -20000 ) THEN
            Error_SYS.Appl_General(lu_name_,'EVENT_ACTION_ERROR: The Event Action ":P1" on ":P2" has failed. Please contact your System Administrator to manage the Event Actions. :P3', Fnd_Event_Action_Type_API.Decode(fnd_event_action_type_), event_id_, SUBSTR(SQLERRM, 1 , 200));
      END IF;
END Activate_Action;


PROCEDURE Action_Mail (
   mail_data_ IN CLOB,
   msg_       IN CLOB )
IS
   sender_     VARCHAR2(2000);
   from_name_  VARCHAR2(2000);
   to_name_    VARCHAR2(32000);
   text_       CLOB;
   subject_    VARCHAR2(4000);
   attach_     CLOB;
   cc_         VARCHAR2(4000);
   bcc_        VARCHAR2(4000);
   mail_       CLOB;
   mail_sender_ VARCHAR2(2000);
   log_value_  NUMBER;
   rowkey_     VARCHAR2(50);
BEGIN
   rowkey_    := Message_SYS.Find_Attribute(msg_, 'EVENT_ACTION_ROWKEY', '');
   mail_      := Make_Message(mail_data_, msg_);
   sender_    := Message_SYS.Find_Attribute(msg_, 'SENDER', to_char(NULL));
   -- FROM is not mandatory. Use Appowner if not stated.
   -- NVL is added since Find Attribute will return NULL if mail_ contains $FROM=NULL part.
   from_name_ := NVL(Message_SYS.Find_Attribute(mail_, 'FROM', Fnd_Session_API.Get_App_Owner),Fnd_Session_API.Get_App_Owner);
   cc_        := Message_SYS.Find_Attribute(mail_, 'CC','');
   bcc_       := Message_SYS.Find_Attribute(mail_, 'BCC','');

   to_name_ := Message_SYS.Find_Attribute(mail_, 'TO', '');
   text_    := Message_SYS.Find_Clob_Attribute(mail_, 'MESSAGE', '');
   subject_ := Message_SYS.Find_Attribute(mail_, 'SUBJECT', '');
   attach_  := Message_SYS.Find_Clob_Attribute(mail_, 'ATTACH', '');
   mail_sender_ := Message_SYS.Find_Attribute(mail_, 'SENDER', '');
   Command_SYS.Mail(sender_, from_name_,  to_name_,  cc_, bcc_, subject_, text_, attach_, rowkey_, mail_sender_ => mail_sender_);
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[MAIL] TO: '||to_name_||' SUBJECT: '|| subject_  , SQLCODE ||': '||SQLERRM );
      RAISE;
END Action_Mail;


PROCEDURE Action_Executeonlinesql (
   sql_data_ IN VARCHAR2,
   msg_      IN VARCHAR2 )
IS
   statement_ VARCHAR2(32000);
   log_value_ NUMBER;
BEGIN
   Message_SYS.Get_Attribute(Make_Message(sql_data_, msg_, 'EXECUTEONLINESQL'), 'SQL', statement_);
   -- Safe due to the value of statement_ is derived
   @ApproveDynamicStatement(2009-08-10,nabalk)
   EXECUTE IMMEDIATE statement_;
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[EXECUTE ONLINE] STATEMENT: '|| SUBSTR(statement_, 1, 3970), SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Executeonlinesql;


PROCEDURE Action_Application_Message (
   message_data_ IN VARCHAR2,
   msg_          IN VARCHAR2 )
IS
   application_data_ VARCHAR2(32000) := Make_Message(message_data_, msg_);
   connector_        VARCHAR2(2000);
   address_data_     VARCHAR2(2000);
   envelope_         VARCHAR2(2000);
   transformer_      VARCHAR2(2000);
   log_value_        NUMBER;
BEGIN
   connector_    := Set_Parameter(application_data_, 'CONNECTOR');
   address_data_ := Set_Parameter(application_data_, 'ADDRESS_DATA');
   envelope_     := Set_Parameter(application_data_, 'ENVELOPE');
   transformer_  := Set_Parameter(application_data_, 'TRANSFORMER');
   Command_SYS.Event_Application_Message_(connector_, address_data_, envelope_, transformer_, msg_);
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[APPLICATION MESSAGE] DATA: '|| message_data_, SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Application_Message;


PROCEDURE Action_Task (
   message_data_ IN VARCHAR2,
   msg_          IN VARCHAR2 )
IS
   application_data_ VARCHAR2(32000) := Make_Message(message_data_, msg_);
   attr_             VARCHAR2(2000);
   log_value_        NUMBER;
   task_id_          VARCHAR2(200);
   complete_event_   VARCHAR2(200);
   object_key_       VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'URL', Set_Parameter(application_data_, 'URL'), attr_ );
   Client_SYS.Add_To_Attr( 'RECEIVER', Set_Parameter(application_data_, 'RECEIVER'), attr_ );
   Client_SYS.Add_To_Attr( 'BUSINESS_OBJECT', Set_Parameter(application_data_, 'BUSINESS_OBJECT'), attr_ );
   Client_SYS.Add_To_Attr( 'SUBJECT', Set_Parameter(application_data_, 'SUBJECT'), attr_ );
   Client_SYS.Add_To_Attr( 'PRIORITY', Set_Parameter(application_data_, 'PRIORITY'), attr_ );
   Client_SYS.Add_To_Attr( 'MESSAGE', Set_Parameter(application_data_, 'MESSAGE'), attr_ );

   Fnd_workflow_Task_Util_API.Create_Human_Task(task_id_, attr_);

   Message_SYS.Get_Attribute(message_data_,'COMPLETE_EVENT',complete_event_);
   IF (complete_event_ IS NOT NULL) THEN
      -- If task created should be completed by another event a workflow connection is created
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'ITEM_ID', task_id_, attr_ );
      Client_SYS.Add_To_Attr( 'EVENT_LU_NAME', Set_Parameter(application_data_, 'BUSINESS_OBJECT'), attr_ );
      Client_SYS.Add_To_Attr( 'EVENT_ID', Set_Parameter(message_data_, 'COMPLETE_EVENT'), attr_ );

      --Get object key , event parameter can be both ROWKEY and OBJKEY depending on the Event type
    object_key_ := Message_Sys.Find_Attribute(msg_, 'OBJKEY','_no_object_key_');

      IF (object_key_ IS NOT NULL AND object_key_  <> '_no_object_key_') THEN
         Client_SYS.Add_To_Attr( 'OBJECT_KEY', object_key_, attr_ );
      ELSE
       object_key_ := Message_Sys.Find_Attribute(msg_, 'ROWKEY','_no_object_key_');
         IF (object_key_ IS NOT NULL AND object_key_  <> '_no_object_key_') THEN
            Client_SYS.Add_To_Attr( 'OBJECT_KEY',object_key_, attr_ );
         END IF;
      END IF;

      IF (object_key_ IS NOT NULL AND object_key_  <> '_no_object_key_') THEN
         Fnd_Workflow_Connection_API.New_Connection(attr_);
      ELSE  
         log_value_ :=  Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[CREATE TASK] Task will have to be manually completed since the Event ' || complete_event_ || ' do not provide OBJKEY attribute. Make sure Rowkey is enabled for this logical unit',NULL);
      END IF;     
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[CREATE TASK] DATA: '|| message_data_, SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Task;

PROCEDURE Action_Streams_Message (
   action_param_  IN VARCHAR2,
   event_message_ IN VARCHAR2)
IS
   log_value_  NUMBER;
   stream_message_ VARCHAR2(32000);
   to_names_ VARCHAR2(2000);
   header_ VARCHAR2(2000);
   text_ VARCHAR2(32000);
   url_  VARCHAR2(2000);
   from_ VARCHAR2(100);
BEGIN
   stream_message_ := Make_Message(action_param_,event_message_);
   Message_SYS.Get_Attribute(stream_message_,'FROM',from_);
   Message_SYS.Get_Attribute(stream_message_,'TO',to_names_);
   Message_SYS.Get_Attribute(stream_message_,'HEADER',header_);
   Message_SYS.Get_Attribute(stream_message_,'BODY',text_);
   url_ := Message_SYS.Find_Attribute(stream_message_,'URL','');
   Fnd_Stream_API.Create_Event_Action_Streams(from_,to_names_,header_,text_,url_);
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[STREAMSMESSAGE] DATA: '|| stream_message_, SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Streams_Message;

PROCEDURE Action_Rest(
   message_data_ IN VARCHAR2,
   msg_          IN VARCHAR2 )
IS
   rest_data_     VARCHAR2(32000) := Make_Message(message_data_, msg_);
   log_value_     NUMBER;
   rest_sender_   VARCHAR2(2000);
   end_point_     VARCHAR2(32000);
   auth_method_   VARCHAR2(2000);
   url_params_    VARCHAR2(32000);
   http_method_   VARCHAR2(50);
   query_params_  VARCHAR2(32000);
   header_params_ VARCHAR2(32000);
   blob_info_     VARCHAR2(32000);
   login_info_    VARCHAR2(32000);
   message_       CLOB;
   attach_        CLOB;
BEGIN
   dbms_output.Put_Line('rest_data_ '||rest_data_);
   rest_sender_   := Message_SYS.Find_Attribute(rest_data_,'SENDER','');
   end_point_     := Message_SYS.Find_Attribute(rest_data_,'END_POINT','');
   auth_method_   := Message_SYS.Find_Attribute(rest_data_,'AUTH_METHOD','');
   http_method_   := Message_SYS.Find_Attribute(rest_data_,'HTTP_METHOD','');
   --Message_SYS.Find_Attribute(rest_data_,'URL_PARAM',url_params_);
   query_params_  := Message_SYS.Find_Attribute(rest_data_,'QUERY_PARAMS','');
   blob_info_     := Message_SYS.Find_Attribute(rest_data_,'BLOB_INFO','');
   header_params_ := Message_SYS.Find_Attribute(rest_data_,'ADDITIONAL_HEADER_PARAM','');
   login_info_    := Message_SYS.Find_Attribute(rest_data_,'AUTH_OPTIONS','');
   attach_        := Message_SYS.Find_Clob_Attribute(rest_data_, 'ATTACH', '');
   message_       := Message_SYS.Find_Clob_Attribute(rest_data_, 'REST_MESSAGE', '');

   Command_SYS.Send_Rest_Message(message_,end_point_,auth_method_,login_info_,rest_sender_,header_params_,url_params_,http_method_,blob_info_,query_params_,attach_);
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[RESTMESSAGE] DATA: '|| message_data_, SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Rest;
   
PROCEDURE Action_Bpa(
   bpa_params_ IN VARCHAR2,
   msg_          IN VARCHAR2 )
IS
   log_value_        NUMBER;
   event_rowkey_     VARCHAR2(100);

   event_lu_name_    FND_EVENT_ACTION_TAB.EVENT_LU_NAME%TYPE;
   event_id_         FND_EVENT_ACTION_TAB.EVENT_ID%TYPE;
   action_number_    FND_EVENT_ACTION_TAB.ACTION_NUMBER%TYPE;

   object_key_       VARCHAR2(100);

   CURSOR get_props(event_rowkey_ VARCHAR2) IS
   SELECT ta.event_lu_name, ta.event_id, ta.action_number
     FROM fnd_event_action_tab ta
    WHERE ta.rowkey = event_rowkey_;

BEGIN
   event_rowkey_ := Message_SYS.Find_Attribute(msg_, 'EVENT_ACTION_ROWKEY', '');

   BEGIN
     OPEN get_props(event_rowkey_);
       FETCH get_props INTO event_lu_name_, event_id_, action_number_;
     CLOSE get_props;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[BPA] BPA for rowkey : '|| event_rowkey_ || 'could not load metadata', SQLCODE ||': '||SQLERRM);
   END;

   --Get object key , event parameter can be both ROWKEY and OBJKEY depending on the Event type
   object_key_ := Message_Sys.Find_Attribute(msg_, 'OBJKEY','_no_object_key_');
   IF (object_key_ IS NULL OR object_key_  = '_no_object_key_') THEN
    object_key_ := Message_Sys.Find_Attribute(msg_, 'ROWKEY','_no_object_key_');
   END IF;

   IF (object_key_ IS NULL OR object_key_  = '_no_object_key_') THEN
     log_value_ :=  Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[BPA] BPA will have to be manually completed since the Event ' || event_lu_name_ || '.' || event_id_ || ' do not provide OBJKEY attribute. Make sure Rowkey is enabled for this logical unit',NULL);
   END IF;

   -- we will not validate the payload to determine whether it has enough data because it cannot be determined without an intimate knowledge of the BPA
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      Bpa_SYS.Append_Event(event_id_      => event_id_,
                           event_lu_name_ => event_lu_name_,
                           action_number_ => action_number_,
                           key_           => object_key_,
                           bpa_meta_      => bpa_params_,
                           attr_          => msg_);
   $END
EXCEPTION
   WHEN OTHERS THEN
      log_value_ := Server_Log_API.Log_Autonomous(NULL, event_log_category_, '[BPAMESSAGE] DATA: '|| bpa_params_ || ' EVENT_ROWKEY: ' || event_rowkey_, SQLCODE ||': '||SQLERRM);
      RAISE;
END Action_Bpa;

FUNCTION Make_Message (
   text_        IN CLOB,
   msg_         IN CLOB,
   action_type_ IN VARCHAR2 DEFAULT '') RETURN CLOB
IS
   tmp_ CLOB;
BEGIN
   tmp_ := Set_Event_Parameters___(text_, msg_, action_type_);
   IF action_type_ = 'EXECUTEONLINESQL' THEN
      tmp_ := Context_Substitution_Var_API.Replace_Variables__(tmp_, FALSE, TRUE);
   ELSE
      tmp_ := Context_Substitution_Var_API.Replace_Variables__(tmp_);
   END IF;
   tmp_ := Replace_CF_Variables___(tmp_, msg_);
   tmp_ := Encode_Url_Values_(tmp_);
   RETURN(tmp_);
END Make_Message;


FUNCTION Evaluate_Condition (
   val1_ IN VARCHAR2,
   type_ IN VARCHAR2,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF type_ LIKE '> ' OR type_ LIKE '>' THEN
      RETURN Bigger_Than___(val1_, val2_);
   ELSIF type_ LIKE '< ' OR type_ LIKE '<' THEN
      RETURN Less_Than___(val1_, val2_);
   ELSIF type_ LIKE '= ' OR type_ LIKE '=' THEN
      RETURN Equals___(val1_, val2_);
   ELSIF type_ LIKE '!=' THEN
      IF Equals___(val1_, val2_) = 'TRUE' THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF type_ LIKE '>=' THEN
      IF Less_Than___(val1_, val2_) = 'FALSE' THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   ELSIF type_ LIKE '<=' THEN
   IF Bigger_Than___(val1_, val2_) = 'TRUE' THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
ELSIF type_ LIKE 'LIKE' THEN
   IF val1_ LIKE val2_ ESCAPE '\' THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
ELSIF type_ = 'IS NULL' THEN
      IF val1_ IS NULL THEN 
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
ELSE
   RETURN 'TRUE';
END IF;
END Evaluate_Condition;


FUNCTION Evaluate_Condition_Num (
   val1_ IN NUMBER,
   type_ IN VARCHAR2,
   val2_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
IF type_ LIKE '>' OR type_ LIKE '> ' THEN
   RETURN Bigger_Than_Num___(val1_, to_number(val2_));
   ELSIF type_ = '<' OR type_ LIKE '< ' THEN
      RETURN Less_Than_Num___(val1_, to_number(val2_));
   ELSIF type_ = '=' OR type_ LIKE '= ' THEN
      -- Special case to handle number lists (ToDo #2006)
      RETURN Equals_Eq_Num___(val1_, val2_);
   ELSIF type_ = '!=' THEN
      IF Equals_Num___(val1_, to_number(val2_)) = 'TRUE' THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   ELSIF type_ = '>=' THEN
      IF Less_Than_Num___(val1_, to_number(val2_)) = 'FALSE' THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   ELSIF type_ = '<=' THEN
      IF Bigger_Than_Num___(val1_, to_number(val2_)) = 'TRUE' THEN
         RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
ELSIF type_ LIKE 'LIKE' THEN
   IF val1_ LIKE val2_ THEN -- Not converted to number because val2_ can contain wildcard characters while using LIKE operator
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
ELSIF type_ = 'IS NULL' THEN
   IF val1_ IS NULL THEN 
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
ELSE
   RETURN 'TRUE';
END IF;
END Evaluate_Condition_Num;

FUNCTION Set_Action_Enable (
   objid_ IN VARCHAR2,
   objversion_ IN VARCHAR2,
   action_enable_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   oldrec_           fnd_event_action_tab%ROWTYPE;
   newrec_           fnd_event_action_tab%ROWTYPE;
   attr_             VARCHAR2(1000);
   new_objversion_   VARCHAR2(1000);
   sql_              CLOB;
BEGIN
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   IF (newrec_.fnd_event_action_type = Fnd_Event_Action_Type_API.DB_EXECUTE_ONLINE_SQL
       AND action_enable_ = 'TRUE') THEN
      sql_ := Message_SYS.Find_Clob_Attribute(newrec_.action_parameters, 'SQL', NULL);
      IF sql_ IS NULL THEN
         Error_SYS.Appl_General(lu_name_, 'SQLSTMTNULL: SQL Statement cannot be null.');
      END IF;
   END IF;
   IF (action_enable_ = oldrec_.action_enable) THEN
      Error_SYS.Appl_General(lu_name_, 'SET_ACTION_ENABLE: Can''t change enable to same value as it already is set to.');
   END IF;
   newrec_.action_enable := action_enable_;
   
   -- creates a trigger in an autonomous transaction
   Fnd_Event_API.Set_Event_Enable(newrec_.event_lu_name, newrec_.event_id);
   
   Update___(objid_, oldrec_, newrec_, attr_, new_objversion_);
   RETURN(new_objversion_);
END Set_Action_Enable;

FUNCTION Set_Parameter (
   data_ IN VARCHAR2,
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000);
BEGIN
   Message_SYS.Get_Attribute(data_, upper(attr_), temp_);
   RETURN(temp_);
END Set_Parameter;

@IgnoreUnitTest DMLOperation
PROCEDURE Delete_Action (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER DEFAULT NULL)
IS
BEGIN
   IF action_number_ IS NOT NULL THEN
      DELETE FROM fnd_event_action_tab
         WHERE event_lu_name = event_lu_name_
         AND   event_id = event_id_
         AND   action_number = action_number_;
   ELSE
      DELETE FROM fnd_event_action_tab
         WHERE event_lu_name = event_lu_name_
         AND   event_id = event_id_;
   END IF;
END Delete_Action;


PROCEDURE Update_Action (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   event_param_   IN VARCHAR2 )
IS
   cond_type_msg_  VARCHAR2(4000);
   cond_value_msg_ VARCHAR2(4000);
   CURSOR event_actions IS
   SELECT action_number, condition_type, condition_value
   FROM FND_EVENT_ACTION_TAB
   WHERE event_lu_name = event_lu_name_
   AND   event_id = event_id_;
   CURSOR event_params IS
   SELECT id
   FROM fnd_event_parameter_special
   WHERE event_lu_name = event_lu_name_
   AND   event_id = event_id_;
BEGIN
   --
   -- For each action, check all parameters and update the corresponding condition
   --
   FOR action IN event_actions LOOP
      cond_type_msg_  := Message_SYS.Construct('EVENT_ACTION_COND_TYPE');
      cond_value_msg_ := Message_SYS.Construct('EVENT_ACTION_COND_VALUE');
      FOR param IN event_params LOOP
         Message_SYS.Add_Attribute(cond_type_msg_, param.id, Message_SYS.Find_Attribute(action.condition_type, param.id, ''));
         Message_SYS.Add_Attribute(cond_value_msg_, param.id, Message_SYS.Find_Attribute(action.condition_value, param.id, ''));
      END LOOP;
      -- Definition modifed date should not be set here, because the it's not a direct
      -- update to the Action, rather an update to the Event which causes the Action condition meta data
      -- to be updated
   UPDATE fnd_event_action_tab
      SET condition_type = cond_type_msg_,
          condition_value = cond_value_msg_
      WHERE event_lu_name = event_lu_name_
      AND   event_id = event_id_
      AND   action_number = action.action_number;
   END LOOP;
END Update_Action;


PROCEDURE Register (
   info_msg_ IN CLOB )
IS
   objrec_     FND_EVENT_ACTION_TAB%ROWTYPE;
   msg_        CLOB;
   result_     BOOLEAN;
   info_       VARCHAR2(4000);
BEGIN
   msg_ := replace(info_msg_,'||CHR(38)||','&');

   objrec_.event_lu_name := Message_SYS.Find_Attribute(msg_, 'EVENT_LU_NAME', '');
   objrec_.event_id := Message_SYS.Find_Attribute(msg_, 'EVENT_ID', '');
   objrec_.action_number := Message_SYS.Find_Attribute(msg_, 'ACTION_NUMBER', '' );
   objrec_.action_enable := Message_SYS.Find_Attribute(msg_, 'ACTION_ENABLE', '' );
   objrec_.condition_type := Message_SYS.Find_Attribute(msg_, 'CONDITION_TYPE', '');
   objrec_.condition_value := Message_SYS.Find_Attribute(msg_, 'CONDITION_VALUE', '' );
   objrec_.fnd_event_action_type := Message_SYS.Find_Attribute(msg_, 'FND_EVENT_ACTION_TYPE', '' );
   objrec_.description := Message_SYS.Find_Attribute(msg_, 'DESCRIPTION', '');
   objrec_.subscribable := Message_SYS.Find_Attribute(msg_, 'SUBSCRIBABLE', '' );
   objrec_.role := Message_SYS.Find_Attribute(msg_, 'ROLE', '' );
   objrec_.system_defined := Message_SYS.Find_Attribute(msg_, 'SYSTEM_DEFINED', 'FALSE' );
   objrec_.definition_modified_date := Message_SYS.Find_Attribute(msg_, 'DEFINITION_MODIFIED_DATE', to_date(NULL) );
   objrec_.rowkey := Message_SYS.Find_Attribute(msg_, 'ROWKEY', '' );
   objrec_.action_parameters := Message_SYS.Find_Clob_Attribute(msg_, 'ACTION_PARAMETERS', '');
   Fnd_Event_API.Exist(objrec_.event_lu_name, objrec_.event_id);
   result_ := Import_Impl___(objrec_, info_);
END Register;

FUNCTION Get_Name_By_Rowkey(
   rowkey_ IN VARCHAR2)RETURN VARCHAR2
IS
   name_ VARCHAR2(100);
   CURSOR get_name IS 
      SELECT to_char(action_number) ||'^'|| event_id ||'^'|| event_lu_name
      FROM FND_EVENT_ACTION_TAB
      WHERE rowkey = rowkey_;
   
BEGIN
   OPEN  get_name;
   FETCH get_name INTO name_;
   CLOSE get_name;
   RETURN name_;
END Get_Name_By_Rowkey;

FUNCTION Get_Description_By_Rowkey(
   rowkey_ IN VARCHAR2)RETURN VARCHAR2
IS
   action_desription_ fnd_event_action_tab.description%TYPE;
BEGIN  
   SELECT description
   INTO action_desription_
   FROM FND_EVENT_ACTION_TAB
   WHERE rowkey = rowkey_;
   
   RETURN action_desription_;
END Get_Description_By_Rowkey;

FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ fnd_event_action_tab.definition_modified_date%TYPE;
BEGIN
SELECT definition_modified_date INTO definition_modified_date_
FROM fnd_event_action_tab
WHERE rowkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;

PROCEDURE Export_XML (
   out_xml_       OUT CLOB,
   event_lu_name_ IN  VARCHAR2,
   event_id_      IN  VARCHAR2,
   action_number_ IN  VARCHAR2)
IS
   -- 
   exp_date_format_ VARCHAR2(30) := Client_SYS.date_format_;
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                                  e.event_lu_name,
                                  e.event_id,
                                  e.action_number, 
                                  e.action_enable, 
                                  e.action_parameters, 
                                  e.fnd_event_action_type_db, 
                                  e.condition_type, 
                                  e.condition_value, 
                                  e.description,
                                  e.subscribable,
                                  e.system_defined,
                                  e.role,
                                  to_char(e.definition_modified_date ,'''||exp_date_format_||''') definition_modified_date,
                                  e.objkey
                           FROM fnd_event_action e
                           WHERE event_lu_name = '''|| event_lu_name_ ||'''
                           AND event_id = '''||event_id_||'''
                           AND action_number = '''||action_number_||'''';   
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_CUSTOM_EVENT_ACTION;
BEGIN

   --dbms_output.put_line(stmt_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   objkey_ := Fnd_Event_Action_API.Get_Objkey(event_lu_name_, event_id_, action_number_);

   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: '|| stmt_);

   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_CUSTOM_EVENT_ACTION);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      App_Config_Util_API.Get_Item_Name(objkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION),
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION,
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      App_Config_Util_API.Get_Item_Description(objkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION),
                                      xpath_);
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
END Export_XML;

PROCEDURE Validate_Import (
   info_               OUT    App_Config_Util_API.AppConfigItemInfo,
   dep_objects_        IN OUT App_Config_Util_API.DeploymentObjectArray,
   in_xml_             IN     CLOB,
   version_time_stamp_ IN     DATE)
IS
   action_ fnd_event_action_tab%ROWTYPE;
   oldrec_ fnd_event_action_tab%ROWTYPE;
   indrec_ Indicator_Rec;
   attr_   VARCHAR2(32767);
   xml_    Xmltype := Xmltype(in_xml_);
   action_key_ fnd_event_action_tab%ROWTYPE;
   exp_def_version_ NUMBER := 1;

   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   import_date_ DATE;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION;

   FOR rec_ IN get_event_action (xml_) LOOP        

      action_.event_id := rec_.event_id;
      action_.event_lu_name := rec_.event_lu_name;
      action_.action_number := rec_.action_number;
      action_.action_enable := rec_.action_enable;
      action_.action_parameters := rec_.action_parameters;
      action_.condition_type := rec_.condition_type;
      action_.condition_value := rec_.condition_value;
      action_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
      action_.description := Utility_SYS.Set_Windows_New_Line(rec_.description);
      action_.fnd_event_action_type := rec_.fnd_event_action_type;
      action_.role := rec_.role;
      action_.subscribable := rec_.subscribable;
      action_.rowkey := rec_.rowkey;
      exp_def_version_ := rec_.export_def_version;

      info_.last_modified_date := action_.definition_modified_date;
      info_.name := to_char(action_.action_number) ||'^'|| action_.event_id ||'^'|| action_.event_lu_name;

      -- First check if the Action Exists using the ROWKEY. (we cannot rely on the Action_No)
      action_key_ := Get_Key_By_Rowkey(rec_.rowkey);

      IF (exp_def_version_ = 1 AND
         action_.fnd_event_action_type = Fnd_Event_Action_Type_API.DB_E_MAIL AND
         DBMS_LOB.Getlength(Message_SYS.Find_Clob_Attribute(action_.action_parameters,'ATTACH',''))>0) THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'OLD_ATTACH: Error: This event action cannot be imported as it contains old type attachments',Fnd_Session_API.Get_Language), TRUE);
      ELSE
         IF action_key_.event_id IS NULL THEN
            -- New
            info_.exists := 'FALSE';
            info_.current_published := 'FALSE';
            indrec_ := Get_Indicator_Rec___(action_);
   
            BEGIN
               -- Do event Validation now
               Fnd_Event_API.Exist(action_.event_lu_name, action_.event_id);
            EXCEPTION
               WHEN Error_SYS.Err_Record_Not_Exist THEN
                  IF NOT App_Config_Util_API.Is_Deployment_Item_Included(dep_objects_, UPPER(action_.event_lu_name||'^'||action_.event_id), 'CUSTOM_EVENT') THEN
                     Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_NOTEXISTS: Error: The Event [:P1] on LU [:P2] does not exist.', Fnd_Session_API.Get_Language, action_.event_id, action_.event_lu_name)));
                     App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
                  END IF;
            END;
            -- Bypass event_id validation in Check_Insert___ we have already done it.
            indrec_.event_id := FALSE;
            indrec_.event_lu_name := FALSE;
   
            Check_Insert___(action_, indrec_, attr_);
            Validate_Action___(info_, dep_objects_, action_);
   
            IF action_.action_enable = 'TRUE' AND Fnd_Event_API.Get_Event_Enable(action_.event_lu_name, action_.event_id) = 'TRUE' THEN
               Utility_SYS.Append_Text_Line(info_.validation_details, ( Language_SYS.Translate_Constant(lu_name_,'EVE_ACTIVE: This event action will become active once imported.')));
            END IF;   
   
         ELSE         
            oldrec_ := Get_Object_By_Keys___(action_key_.event_lu_name, action_key_.event_id, action_key_.action_number);
            info_.exists := 'TRUE';
            info_.current_published := action_.action_enable;
            info_.current_description := oldrec_.description;
            info_.current_last_modified_date := oldrec_.definition_modified_date;
   
            action_.action_enable := rec_.action_enable;
            action_.action_parameters := rec_.action_parameters;
            action_.condition_type := rec_.condition_type;
            action_.condition_value := rec_.condition_value;
            action_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
            action_.description := Utility_SYS.Set_Windows_New_Line(rec_.description);
            action_.fnd_event_action_type := rec_.fnd_event_action_type;
            action_.role := rec_.role;
            action_.subscribable := rec_.subscribable;
            Check_Update___(oldrec_, action_, indrec_, attr_);
            Validate_Action___(info_, dep_objects_, action_);
   
            IF (action_.definition_modified_date <> oldrec_.definition_modified_date) THEN
               import_date_:= App_Config_Package_API.Get_Package_Imported_Date(oldrec_.rowkey); 
               IF import_date_ IS NOT NULL AND nvl(oldrec_.definition_modified_date,Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
                  App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
                  Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten',Fnd_Session_API.Get_Language), TRUE); 
               END IF;
            END IF;
   
            App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, oldrec_.rowkey);
         END IF;
      END IF;
   END LOOP;

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

PROCEDURE Validate_Existing(
   info_               OUT    App_Config_Util_API.AppConfigItemInfo,
   rowkey_             IN     app_config_package_item_tab.configuration_item_id%TYPE,
   version_time_stamp_ IN     DATE)
IS
   action_ fnd_event_action_tab%ROWTYPE;
   auth_   VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   dep_objects_ App_Config_Util_API.DeploymentObjectArray;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION;
   
   Rowkey_Exist(rowkey_);
   
   action_ := Get_Object_By_Rowkey___(rowkey_);
   info_.last_modified_date := action_.definition_modified_date;
   info_.name := to_char(action_.action_number) ||'^'|| action_.event_id ||'^'|| action_.event_lu_name;
   info_.exists := 'TRUE';
   info_.current_published := action_.action_enable;
   info_.current_description := action_.description;
   info_.current_last_modified_date := action_.definition_modified_date;

   Validate_Action___(info_, dep_objects_, action_);

   App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, action_.rowkey);

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

PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN  CLOB,
   info_                  OUT VARCHAR2 )
IS
   xml_ Xmltype := Xmltype(in_xml_);
   rec_ Fnd_Event_Action_Tab%ROWTYPE;
   exp_def_version_ NUMBER := 1;
      
   FUNCTION Convert_Xml_Record___ (
      xml_ get_event_action%ROWTYPE) RETURN Fnd_Event_Action_Tab%ROWTYPE
   IS
      rec_local_ Fnd_Event_Action_Tab%ROWTYPE;
   BEGIN
      --rec_.export_def_version := xml_.export_def_version;
      rec_local_.event_id := xml_.event_id;
      rec_local_.event_lu_name := xml_.event_lu_name;
      rec_local_.action_number := xml_.action_number;
      rec_local_.action_enable := xml_.action_enable;
      rec_local_.condition_type := xml_.condition_type;
      rec_local_.condition_value := xml_.condition_value;
      rec_local_.fnd_event_action_type := xml_.fnd_event_action_type;
      rec_local_.description := xml_.description;
      rec_local_.subscribable := xml_.subscribable;
      rec_local_.system_defined := xml_.system_defined;
      rec_local_.role := xml_.role;
      rec_local_.action_parameters := xml_.action_parameters;
      rec_local_.definition_modified_date := to_date(xml_.definition_modified_date, Client_SYS.date_format_);
      rec_local_.rowkey := xml_.rowkey;
      RETURN(rec_local_);
   END Convert_Xml_Record___;
      
BEGIN  
   FOR rec_xml_ IN get_event_action (xml_) LOOP
      rec_ := Convert_Xml_Record___(rec_xml_);
      exp_def_version_ := rec_xml_.export_def_version;
      identical_ := Import_Impl___(rec_, info_, exp_def_version_);
   END LOOP;  
   configuration_item_id_ := rec_.rowkey;
   name_ := App_Config_Util_API.Get_Item_Name(configuration_item_id_, App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION);  
END Import;

PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN  CLOB )
IS
   info_   VARCHAR2(4000);
BEGIN
   Import(configuration_item_id_, name_, identical_, in_xml_, info_ );
END Import;

FUNCTION Encode_Url_Values_ (
   message_ IN CLOB ) RETURN CLOB
IS
   encoded_message_  CLOB;
   encode_start_     CONSTANT VARCHAR2(20) := '<VALUE_URL_ENCODE>';
   encode_end_       CONSTANT VARCHAR2(20) := '</VALUE_URL_ENCODE>';
   param_start_      INTEGER;
   param_length_     INTEGER;
   param_            VARCHAR2(32000);
   new_param_        VARCHAR2(32000);
BEGIN
   encoded_message_ := message_;
   param_start_ := 0;
   LOOP
      param_start_ := INSTR(message_,encode_start_,param_start_+1);
      param_length_ := INSTR(message_,encode_end_,param_start_)+LENGTH(encode_start_)-param_start_;

      IF NVL(param_start_, 0) = 0 OR NVL(param_length_,0) = 0  THEN
         EXIT;
      END IF;

      param_ := SUBSTR(message_,param_start_,param_length_+1);
      new_param_:= REPLACE(param_,encode_start_);
      new_param_ := REPLACE(new_param_,encode_end_);
      new_param_ := REPLACE(new_param_,'&','\&');
      new_param_ := REPLACE(new_param_,'=','\=');
      new_param_ := Utl_Url.Escape(new_param_,TRUE,'UTF-8');
      new_param_ := Utl_Url.Escape(new_param_,TRUE,'UTF-8');
      encoded_message_ := REPLACE(encoded_message_,param_,new_param_);

   END LOOP;
   RETURN encoded_message_;
END Encode_Url_Values_;

PROCEDURE WRITE_SQL_STATEMENT__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     CLOB )
IS
   action_param_ VARCHAR2(1000) := NULL;
   
   
   PROCEDURE Add_Sql_Parameters(
      action_param_ IN OUT CLOB, 
      lob_loc_ IN CLOB) 
   IS
      
   BEGIN
      Message_SYS.Add_Clob_Attribute(action_param_,'SQL',lob_loc_) ;
   END Add_Sql_Parameters;

BEGIN
      
   Add_Sql_Parameters(action_param_,lob_loc_);
   Fnd_Event_Action_API.Write_Action_Parameters__(objversion_, rowid_, action_param_);

END WRITE_SQL_STATEMENT__;

@UncheckedAccess
FUNCTION Get_Attachment_Names(
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER) RETURN VARCHAR2 
IS
   CURSOR get_action_param IS 
      SELECT action_parameters
      FROM   fnd_event_action_tab
      WHERE  event_lu_name = event_lu_name_
      AND event_id = event_id_
      AND action_number = action_number_;
   action_param_ CLOB;
   attachments_ CLOB;
   attachment_ CLOB;
   attachment_names_ VARCHAR2(32000);   
BEGIN
   OPEN get_action_param;
   FETCH get_action_param INTO action_param_;
   CLOSE get_action_param;
   attachments_ := Message_SYS.Find_Clob_Attribute(action_param_,'ATTACH','');
   attachment_ := Message_SYS.Find_Clob_Attribute(attachments_,'ATTACHMENT',NULL);
   WHILE Message_SYS.Find_Clob_Attribute(attachments_,'ATTACHMENT',NULL) IS NOT NULL
   LOOP
      attachment_ := Message_SYS.Find_Clob_Attribute(attachments_,'ATTACHMENT',NULL);  
      IF  Message_SYS.Get_Name(attachment_) = 'FILE' OR Message_SYS.Get_Name(attachment_) = 'TEXT'
      THEN
         attachment_names_ := attachment_names_ || Message_SYS.Find_Clob_Attribute(attachment_,'FILENAME',NULL) ||',';
      END IF;
      Message_SYS.Remove_Attribute(attachments_,'ATTACHMENT');     
   END LOOP;
   RETURN substr(attachment_names_,1,INSTR(attachment_names_, ',', -1, 1)-1);
END Get_Attachment_Names;

