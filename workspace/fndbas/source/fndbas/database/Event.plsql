-----------------------------------------------------------------------------
--
--  Logical unit: Event
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971009  ERFO  Reviewed for Foundation1 Release 2.0.0 (ToDo #1676).
--  971015  DAJO  Reviewed trace messages for client console
--  971127  ERFO  Solved problem with changes in parameters (Bug #1833).
--  971203  ERFO  Added trace/console functionality (ToDo #1832).
--  980119  ERFO  Changed call to Evaluate_Condition_Num to include
--                functionality for value-lists (ToDo #2016).
--  980223  ERFO  Regarrangements in method Event_Execute (ToDo #2143).
--  980303  ERFO  Improved action condition evaluation (ToDo #2185).
--  980414  ERFO  Fixed problem with conditions between two event params
--                of datatypes DATETIME, DATE or TIME (Bug #2351).
--  010703  ROOD  Added methods for handling of subscriptions of events (ToDo#4016).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  070212  HAAR  Added support for Custom Defined Events (Bugg#61780).
--  080305  SUMA  Changed the variable length of condition_type_ and condition_value_(Bug #72181)
--  081015  HASPLK Modified method Event_Execute() to validate event parameter conditions. (Bug#76991)
--  100429  UsRaLK Modified Get_Evaluated_Cond_Value___ to support Context Substitution Variables. (Bug#83992)
--  100809  NaBaLK Modified the method Event_Execute() to support when no
--                 attributes selected in the event (Bug#92136)
--  120808  AsWiLk Called the method Fnd_Workflow_Connection_API.Complete_Tasks within Event_Execute
--                 to completed the tasks created by Human Task event action
--  141124  UsRaLK Modified [Event_Execute] to support NEW: and OLD: prefixes for APPLICATION defined events. (Bug#119868)
--  150906  AsBaLK Changed the variable length of value_str_ in Event_Execute from 2000 to 32000. (Bug#122008)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Put_Trace___ (
   text_ IN VARCHAR2 )
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'EVENT' || Log_SYS.Get_Separator || ' '||substr(text_, 1, 235)||'('||to_char(dbms_utility.get_time)||')');
END Put_Trace___;


FUNCTION Get_Evaluated_Cond_Value___ (
   cond_values_msg_ IN VARCHAR2,
   parameter_       IN VARCHAR2,
   parameter_type_  IN VARCHAR2,
   event_data_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_         VARCHAR2(32000);
   old_val_      VARCHAR2(32000);
   sysdate_expr_ VARCHAR2(1000):= 'SYSDATE|NEXT_DAY|LAST_DAY|TRUNC|ROUND|ADD_MONTHS';
   name_         VARCHAR2(32000);
   stmt_         VARCHAR2(32000);
   temp_date_    DATE;
   ampersand_    VARCHAR2(1) := chr(38);  -- Define character '&'
   datetime_format_ VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_DATETIME');
   date_format_     VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_DATE');
   time_format_     VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_TIME');
BEGIN
   Message_SYS.Get_Attribute(cond_values_msg_ , parameter_, temp_);
   IF (temp_ LIKE ampersand_||'%') THEN
      name_ := substr(temp_, 2);
      IF (parameter_type_ = 'STRING') THEN
         Message_SYS.Get_Attribute(event_data_, name_, temp_);
      ELSIF (parameter_type_ = 'NUMBER') THEN
         Message_SYS.Get_Attribute(event_data_, name_, temp_);
      ELSIF (parameter_type_ = 'DATETIME') THEN
         Message_SYS.Get_Attribute(event_data_, name_, temp_date_);
         temp_ := to_char(temp_date_, datetime_format_);
      ELSIF (parameter_type_ = 'DATE') THEN
         Message_SYS.Get_Attribute(event_data_, name_, temp_date_);
         temp_ := to_char(temp_date_, date_format_);
      ELSIF (parameter_type_ = 'TIME') THEN
         Message_SYS.Get_Attribute(event_data_, name_, temp_date_);
         temp_ := to_char(temp_date_, time_format_);
      END IF;
   END IF;
   
   -- Extra validation to support Context Substitution Variables
   IF ( parameter_type_ IN ('DATETIME', 'DATE', 'TIME') ) THEN
      -- First try to see if this is safe to be executed as a SQL
      Assert_SYS.Assert_Is_Sysdate_Expression(Context_Substitution_Var_API.Replace_Variables__(temp_));
      old_val_ := temp_;--to verify if any CSV were substituted
      -- SQL String for dates
      temp_ := Context_Substitution_Var_API.Replace_Variables__(temp_, TRUE);
      IF old_val_ != temp_ OR REGEXP_INSTR(temp_,sysdate_expr_) > 0 THEN -- execute only when CSV or user entered SYSDATE expressions are involved
         stmt_ := 'SELECT (' || temp_ || ') FROM dual';
         
         @ApproveDynamicStatement(2010-04-29,usralk)
         EXECUTE IMMEDIATE stmt_ INTO temp_date_;
         
         IF (parameter_type_ = 'DATETIME') THEN
            temp_ := to_char(temp_date_, datetime_format_);
         ELSIF (parameter_type_ = 'DATE') THEN
            temp_ := to_char(temp_date_, date_format_);
         ELSIF (parameter_type_ = 'TIME') THEN
            temp_ := to_char(temp_date_, time_format_);
         END IF;
      END IF;
   ELSE
      -- Normal mode for all other types
      temp_ := Context_Substitution_Var_API.Replace_Variables__(temp_);
   END IF;
   
   RETURN(temp_);
END Get_Evaluated_Cond_Value___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Next_Attr__ (
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
END Get_Next_Attr__;



@UncheckedAccess
FUNCTION Find_First_Attr__ (
   attr_ IN VARCHAR2 ) RETURN NUMBER
IS
   from_  NUMBER;
   to_    NUMBER;
   separator_ VARCHAR2(5);
BEGIN
   separator_ :=  '$';
   from_ := nvl(NULL, 1);
   to_   := instr(attr_, separator_ , from_);
   IF (to_ > 0) THEN
      RETURN to_ + 1;
   ELSE
      RETURN 0;
   END IF;
END Find_First_Attr__;



@UncheckedAccess
PROCEDURE Time_To_Num__ (
   time_   IN  VARCHAR2,
   hour_   OUT NUMBER,
   minute_ OUT NUMBER,
   second_ OUT NUMBER )
IS
   separator_ VARCHAR2(1);
   from_ NUMBER;
   to_ NUMBER;
   mid_ NUMBER;
BEGIN
   separator_ := ':';
   from_ := 1;
   mid_   := instr(time_, separator_, from_);
   to_ :=  instr(time_, separator_, mid_);
   hour_  := to_number(substr(time_, from_, mid_));
   minute_ := to_number(substr(time_, mid_+1, to_));
   second_ := to_number(substr(time_, to_+1, length(time_)));
END Time_To_Num__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Event_Enabled (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   value_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Event_Enabled');
   value_ := Fnd_Event_API.Get_Event_Enable(event_lu_name_, event_id_);
   Put_Trace___('Event_SYS.Event_Enabled returned '||value_||' for event '||event_lu_name_||'/'||event_id_);
   RETURN(value_ = 'TRUE');
END Event_Enabled;


PROCEDURE Event_Execute (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   event_data_    IN VARCHAR2 )
IS
   CURSOR get_actions IS
      SELECT action_enable,
             action_number
      FROM fnd_event_action
      WHERE event_id = event_id_
      AND   event_lu_name = event_lu_name_;
   CURSOR get_params IS
      SELECT id, id_type
      FROM fnd_event_parameter_special
      WHERE event_id = event_id_
      AND   event_lu_name = event_lu_name_
      AND   id_type IN ('DATETIME', 'DATE', 'TIME');
   
   CURSOR get_event_type IS
      SELECT event_type
      FROM fnd_event_tab
      WHERE event_lu_name = event_lu_name_
      AND event_id = event_id_;
   
   ptr_              NUMBER;
   formatted_data_   VARCHAR2(32000);
   execute_          VARCHAR2(2000);
   cond_par_         VARCHAR2(2000);
   cond_par_type_    VARCHAR2(2000);
   event_type_db_    Fnd_Event_Tab.event_type%TYPE;
   condition_types_  Fnd_Event_Action_Tab.condition_type%TYPE;
   condition_values_ Fnd_Event_Action_Tab.condition_value%TYPE;
   cond_type_        VARCHAR2(2000);
   cond_str_         VARCHAR2(2000);
   value_str_        VARCHAR2(32000);
   value_num_        NUMBER;
   value_date_       DATE;
   param_col_name_   VARCHAR2(100);
   datetime_format_  VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_DATETIME', Installation_SYS.Get_Installation_Mode);
   date_format_      VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_DATE', Installation_SYS.Get_Installation_Mode);
   time_format_      VARCHAR2(40) := Fnd_Setting_API.Get_Value('EVENT_REG_TIME', Installation_SYS.Get_Installation_Mode);
   
   FUNCTION Get_Param_Name___ (
      cond_para_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      IF INSTR(cond_para_, 'OLD:') > 0 THEN
         RETURN SUBSTR(cond_para_, (INSTR(cond_para_, ':')+ 1));
      ELSIF INSTR(cond_para_, 'NEW:') > 0 THEN
         RETURN SUBSTR(cond_para_, (INSTR(cond_para_, ':')+ 1));
      ELSE
         RETURN cond_para_;
      END IF;
   END Get_Param_Name___;
   
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Event_Execute');
   Put_Trace___('Event_SYS.Event_Execute for event '||event_lu_name_||'/'||event_id_);
   
   -- Event Type Fetch: CUSTOM or APPLICATION
   OPEN  get_event_type;
   FETCH get_event_type INTO event_type_db_;
   CLOSE get_event_type;
   
   -- Check if any tasks to complete or workflow to resume
   Fnd_Workflow_Connection_API.Event_Executed(event_lu_name_, event_id_, event_data_);
   
   --
   -- Check for possible events (may be several)
   --
   FOR my_rec_ IN get_actions LOOP
      --
      -- Check if event enabled globally
      --
      IF (my_rec_.action_enable = 'TRUE') THEN
         --
         -- Check if the conditions enable the action
         --
         condition_types_ := Fnd_Event_Action_API.Get_Condition_Type(event_lu_name_, event_id_, my_rec_.action_number);
         condition_values_ := Fnd_Event_Action_API.Get_Condition_Value(event_lu_name_, event_id_, my_rec_.action_number);
         execute_ := 'TRUE';
         ptr_ := Find_First_Attr__(condition_types_);
         IF (ptr_ > 0) THEN
            WHILE (Get_Next_Attr__(condition_types_, ptr_, cond_par_, cond_type_) = 'TRUE') LOOP
               IF (cond_type_ != '  ') THEN
                  -- For APPLICATION defined events attribute name is exactly what we get
                  IF (event_type_db_ = 'APPLICATION') THEN
                     param_col_name_ := cond_par_;
                  ELSE
                     param_col_name_ := Get_Param_Name___(cond_par_);
                  END IF;
                  cond_par_type_ := Fnd_Event_Parameter_API.Get_Id_Type(event_lu_name_, event_id_, param_col_name_);
                  IF cond_par_type_ IS NULL THEN
                     execute_ := 'FALSE';
                  END IF;
                  IF upper(cond_par_type_) = 'STRING'  THEN
                     Message_SYS.Get_Attribute(event_data_ , cond_par_ , value_str_);
                     cond_str_ := Get_Evaluated_Cond_Value___(condition_values_ , cond_par_ , cond_par_type_, event_data_);
                     IF Fnd_Event_Action_API.Evaluate_Condition( value_str_ , cond_type_ , cond_str_ ) = 'FALSE' THEN
                        execute_ := 'FALSE';
                        EXIT;
                     END IF;
                  ELSIF upper(cond_par_type_) = 'NUMBER'   THEN
                     Message_SYS.Get_Attribute(event_data_ , cond_par_ , value_num_);
                     cond_str_ := Get_Evaluated_Cond_Value___(condition_values_ , cond_par_ , cond_par_type_, event_data_);
                     IF Fnd_Event_Action_API.Evaluate_Condition_Num( value_num_, cond_type_ , cond_str_ ) = 'FALSE' THEN
                        execute_ := 'FALSE';
                        EXIT;
                     END IF;
                  ELSIF upper(cond_par_type_) = 'DATETIME' THEN
                     Message_SYS.Get_Attribute(event_data_ , cond_par_ , value_date_);
                     cond_str_ := Get_Evaluated_Cond_Value___(condition_values_ , cond_par_ , cond_par_type_, event_data_);
                     value_str_ := to_char(value_date_, 'YYYY-MM-DD-HH24.MI.SS');
                     cond_str_  := to_char(to_date(cond_str_, datetime_format_), 'YYYY-MM-DD-HH24.MI.SS') ;
                     IF Fnd_Event_Action_API.Evaluate_Condition(value_str_, cond_type_ , cond_str_ ) = 'FALSE' THEN
                        execute_ := 'FALSE';
                        EXIT;
                     END IF;
                  ELSIF upper(cond_par_type_) = 'DATE' THEN
                     Message_SYS.Get_Attribute(event_data_ , cond_par_ , value_date_);
                     cond_str_ := Get_Evaluated_Cond_Value___(condition_values_ , cond_par_ , cond_par_type_, event_data_);
                     value_str_ := to_char(value_date_, 'YYYY-MM-DD');
                     cond_str_  := to_char(to_date(cond_str_, date_format_), 'YYYY-MM-DD') ;
                     IF Fnd_Event_Action_API.Evaluate_Condition(value_str_, cond_type_ , cond_str_ ) = 'FALSE' THEN
                        execute_ := 'FALSE';
                        EXIT;
                     END IF;
                  ELSIF upper(cond_par_type_) = 'TIME' THEN
                     Message_SYS.Get_Attribute(event_data_ , cond_par_ , value_date_);
                     cond_str_ := Get_Evaluated_Cond_Value___(condition_values_ , cond_par_ , cond_par_type_, event_data_);
                     value_str_ := to_char(value_date_, 'HH24.MI.SS');
                     cond_str_  := to_char(to_date(cond_str_, time_format_), 'HH24.MI.SS') ;
                     IF Fnd_Event_Action_API.Evaluate_Condition(value_str_, cond_type_ , cond_str_ ) = 'FALSE' THEN
                        execute_ := 'FALSE';
                        EXIT;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;
         --
         -- Do action part of the event
         --
         Put_Trace___('Event_SYS.Event_Execute returned '||execute_||' for action type '||
                      Fnd_Event_Action_API.Get_Fnd_Event_Action_Type(event_lu_name_, event_id_, my_rec_.action_number)||
                      ' and action id '||event_lu_name_||'/'||event_id_||'('||my_rec_.action_number||')');
         IF execute_ = 'TRUE' THEN
            --
            -- Format date event data according to configuration
            --
            formatted_data_ := event_data_;
            FOR rec IN get_params LOOP
               Message_SYS.Get_Attribute(formatted_data_, rec.id, value_str_);
               IF (rec.id_type = 'DATETIME') THEN
                  Message_SYS.Set_Attribute(formatted_data_, rec.id, to_char(to_date(value_str_, 'YYYY-MM-DD-HH24.MI.SS'), datetime_format_));
               ELSIF (rec.id_type = 'DATE') THEN
                  Message_SYS.Set_Attribute(formatted_data_, rec.id, to_char(to_date(value_str_, 'YYYY-MM-DD-HH24.MI.SS'), date_format_));
               ELSIF (rec.id_type = 'TIME') THEN
                  Message_SYS.Set_Attribute(formatted_data_, rec.id, to_char(to_date(value_str_, 'YYYY-MM-DD-HH24.MI.SS'), time_format_));
               END IF;
            END LOOP;
            Fnd_Event_Action_API.Activate_Action(event_lu_name_, event_id_, my_rec_.action_number, formatted_data_);
         END IF;
      END IF;
   END LOOP;
END Event_Execute;


PROCEDURE Enable_Event (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   event_desc_    IN VARCHAR2,
   event_param_   IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Enable_Event');
   Fnd_Event_API.Refresh(event_lu_name_, event_id_, event_desc_);
   Fnd_Event_Parameter_API.Create_Param(event_lu_name_, event_id_, event_param_);
   Fnd_Event_Action_API.Update_Action(event_lu_name_, event_id_, event_param_);
END Enable_Event;

PROCEDURE Create_Attachment_Parameter (
   event_lu_name_  IN VARCHAR2,
   event_id_       IN VARCHAR2,
   parameter_      IN VARCHAR2,
   parameter_type_ IN VARCHAR2,
   description_    IN VARCHAR2,
   filename_       IN VARCHAR2,
   attach_method_  IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Create_Attachment_Parameter');
   Fnd_Event_Parameter_API.Create_Attachment_Parameter(event_lu_name_, event_id_, parameter_, parameter_type_, description_, filename_, attach_method_);
END Create_Attachment_Parameter;

PROCEDURE Disable_Event (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Disable_Event');
   Fnd_Event_API.Unfresh(event_lu_name_, event_id_);
   Fnd_Event_Parameter_API.Delete_Param(event_lu_name_, event_id_);
   Fnd_Event_Action_API.Delete_Action(event_lu_name_, event_id_);
END Disable_Event;


PROCEDURE Set_Event_Trace (
   trace_value_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Set_Event_Trace');
   NULL;
END Set_Event_Trace;


PROCEDURE Subscribe_Event_Action (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Subscribe_Event_Action');
   Fnd_Event_Action_Subscribe_API.Subscribe(event_lu_name_, event_id_, action_number_, Fnd_Session_API.Get_Fnd_User);
END Subscribe_Event_Action;


PROCEDURE Unsubscribe_Event_Action (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'EVENT_SYS', 'Unsubscribe_Event_Action');
   Fnd_Event_Action_Subscribe_API.Unsubscribe(event_lu_name_, event_id_, action_number_, Fnd_Session_API.Get_Fnd_User);
END Unsubscribe_Event_Action;

PROCEDURE Remove_Events_Per_Module(
   module_ IN VARCHAR2)
IS   
   CURSOR get_events IS
      SELECT f.event_lu_name, f.event_id
      FROM   fnd_event_tab f, dictionary_sys_tab d
      WHERE f.event_lu_name = d.lu_name
      AND   d.module = module_;
BEGIN
   FOR rec_ IN get_events LOOP
      Disable_Event(rec_.event_lu_name, rec_.event_id);
   END LOOP;
END Remove_Events_Per_Module;

