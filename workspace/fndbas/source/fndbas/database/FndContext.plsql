-----------------------------------------------------------------------------
--
--  Logical unit: FndContext
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE context_arr IS TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(1000);
@ApproveGlobalVariable(2014-06-30,haarse)
context_       context_arr;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Clear_Context___ 
IS
BEGIN
   context_.DELETE;
END Clear_Context___;


FUNCTION Get_Value___ (
   name_ IN VARCHAR2,
   raise_error_ IN BOOLEAN DEFAULT TRUE,
   default_value_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(context_(name_));
EXCEPTION
   WHEN no_data_found THEN 
      IF raise_error_ THEN 
         Error_SYS.Appl_General(service_, 'CONTEXT_NOT_EXISTS: Context [:P1] is not set.', name_);
      ELSE
         RETURN(default_value_);
      END IF;
END Get_Value___;


PROCEDURE Profiler___ (
   mode_ IN VARCHAR2 )
IS
   profiling_     CONSTANT VARCHAR2(3) := Fnd_Setting_API.Get_Value('PROFILING');
--   file_name_     VARCHAR2(1000);
   runid_         NUMBER;
BEGIN
Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Profiling_ : '||profiling_);
Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Mode : '||mode_);
Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Comment : '||Find_Value('PROFILER_COMMENT'));
Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Statement : '||Find_Value('PROFILER_STATEMENT'));
   -- Check if profiling is enabled
   IF (profiling_ = 'ON') THEN
      IF (mode_ = 'START') THEN
/*
         -- Start profiling
         file_name_ := Fnd_Profiler_API.Start_Profiling(file_name_);
         Set_Value('PROFILER', 'FALSE');
         Set_Value('PROFILER_FILENAME', file_name_);
*/
         Performance_Analyze_API.Start_Profiler(runid_, Find_Value('PROFILER_COMMENT'), Find_Value('PROFILER_STATEMENT'));
         Set_Value('PROFILER_RUNID', runid_);
      END IF;
      IF (mode_ = 'STOP') THEN
         -- Stop profiling
         --runid_ := Fnd_Profiler_API.Stop_Profiling(Find_Value('PROFILER_FILENAME'), Find_Value('PROFILER_COMMENT'), Find_Value('PROFILER_STATEMENT'));
         Performance_Analyze_API.Stop_Profiler;
         Performance_Analyze_API.Rollup_Run(Get_Value('PROFILER_RUNID'));
      END IF;
   END IF;
Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Runid : '||Find_Value('PROFILER_RUNID'));
END Profiler___;


PROCEDURE Remote_Debug___ (
   context_ IN VARCHAR2 )
IS
   remote_debugging_     CONSTANT VARCHAR2(3)    := Fnd_Setting_API.Get_Value('REMOTE_DEBUGGING');
   
   host_       VARCHAR2(100);
   port_no_    NUMBER;
BEGIN
   -- Check if remote debugging is enabled
   IF (remote_debugging_ = 'ON') THEN
      IF (context_ IS NOT NULL) THEN
         host_    := Message_SYS.Find_Attribute(context_, 'HOST', '');
         port_no_ := Message_SYS.Find_Attribute(context_, 'PORT', '');
         -- Remote debug
         Remote_Debug_SYS.Remote_Debug_Start(host_, port_no_);
         Set_Value('REMOTE_DEBUG_STOP', Fnd_Boolean_API.DB_TRUE);
      END IF;
   END IF;
END Remote_Debug___;


PROCEDURE Debug___ (
   label_ IN VARCHAR2 )
IS
BEGIN
   -- Check if remote debugging is enabled
   IF (label_ IS NOT NULL) THEN
      Log_SYS.Set_Log_Level_(Log_SYS.Get_Level_(label_));
   ELSE
      Log_SYS.Set_Log_Level_(Log_SYS.Get_Level_(Log_SYS.undefined_));      
   END IF;
END Debug___;


PROCEDURE Set_Value___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 ) 
IS
BEGIN
   context_(name_) := value_;
END Set_Value___;


PROCEDURE Set_Values___ (
   msg_ IN VARCHAR2 ) 
IS
   name_    Message_SYS.name_table;
   value_   Message_SYS.line_table;
   count_   INTEGER;

BEGIN
   -- Clear context
   Clear_Context___;
   IF (msg_ IS NOT NULL) THEN
      -- Get all values from context
      Message_SYS.Get_Attributes (msg_, count_, name_, value_);
      FOR i IN 1..count_ LOOP
         CASE name_(i)
            WHEN 'CLIENT_ID' THEN 
               Fnd_Session_API.Set_Client_Id__(value_(i));
            ELSE
               NULL;
         END CASE;
         Set_Value___(name_(i), value_(i));
      END LOOP;
   END IF;
END Set_Values___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Init_Request_ (
   f1_context_msg_ IN VARCHAR2,
   app_context_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'FND_CONTEXT_SYS', 'Init_Request_');
   -- Set F1 context
   Set_Values___(f1_context_msg_);
   -- Set Application context
   App_Context_SYS.Set_Values(app_context_msg_);
   -- React upon F1 context variables
   -- Client Id
   IF (Exist('CLIENT_ID') = TRUE) THEN 
      Fnd_Session_API.Set_Client_Id__(Get_Value('CLIENT_ID'));
   END IF;
   -- Debug Trace
   IF (Find_Value('DEBUG') IS NOT NULL ) THEN
      Debug___(Message_SYS.Find_Attribute(Find_Value('DEBUG'), 'DB_ACCESS', ''));
   END IF;
   -- Profiling
   IF (Find_Value('PROFILER', Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE ) THEN
      Profiler___('START');
   END IF;
   -- Os user
   --IF (Find_Value('OS_USER_NAME') IS NOT NULL) THEN
   --   Fnd_Session_API.Set_Os_User_Name__(Get_Value('OS_USER_NAME'));
   --END IF;
   -- Machine
   --IF (Find_Value('MACHINE') IS NOT NULL) THEN
   --   Fnd_Session_API.Set_Machine__(Get_Value('MACHINE'));
   --END IF;
   --IF (Find_Value('PROGRAM') IS NOT NULL) THEN
   --   Fnd_Session_API.Set_Program__(Get_Value('PROGRAM'));
   --END IF;
   -- Remote debug
   IF (Find_Value('REMOTE_DEBUG') IS NOT NULL) THEN
      Remote_Debug___(Find_Value('REMOTE_DEBUG'));
   END IF;
   -- Sql trace
   IF (Find_Value('SQL_TRACE') IS NOT NULL) THEN
      Database_SYS.Set_Sql_Trace__('TRUE', Find_Value('SQL_TRACE'));
   END IF;
END Init_Request_;


PROCEDURE End_Request_ (
   transaction_id_ OUT VARCHAR2,
   trace_ OUT CLOB,
   error_msg_ OUT CLOB )
IS
BEGIN
   General_SYS.Check_Security(service_, 'FND_CONTEXT_SYS', 'End_Request_');
   -- Check F1 contexts
   -- Profiling
   IF (Find_Value('PROFILER', Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE ) THEN
      Profiler___('STOP');
   END IF;
   -- Remote debug
   IF (Find_Value('REMOTE_DEBUG_STOP') = Fnd_Boolean_API.DB_TRUE) THEN
      Remote_Debug_SYS.Remote_Debug_Stop;
   END IF;
   -- Sql trace
   IF (Find_Value('SQL_TRACE') IS NOT NULL) THEN
      Database_SYS.Set_Sql_Trace__('FALSE');
   END IF;
   -- Debug trace
   IF (Find_Value('DEBUG') IS NULL) THEN
      Debug___(Find_Value('DEBUG'));
      -- Get trace information
      Client_SYS.Get_Trace(trace_);
   END IF;
   -- Error Message
   IF (Find_Value('EXCEPTION', Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) THEN
      error_msg_ := Message_SYS.Construct('ERROR_MESSAGE');
      Message_SYS.Add_Attribute(error_msg_, 'ERROR_CALL_STACK', Find_Value('ERROR_CALL_STACK'));
      Message_SYS.Add_Attribute(error_msg_, 'ERROR_KEY_MESSAGE', Find_Value('ERROR_KEY_MESSAGE'));
      Message_SYS.Add_Attribute(error_msg_, 'ERROR_FORMATTED_KEY', Find_Value('ERROR_FORMATTED_KEY'));
--      Log_SYS.Fnd_Trace_(Log_SYS.Info_, error_msg_);  
   END IF;
   -- Reset global variables
   Dbms_Session.Modify_Package_State(Dbms_Session.Reinitialize);
   -- Return transaction_id if transaction is started
   transaction_id_ := Dbms_Transaction.Local_Transaction_Id(FALSE);
END End_Request_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Value (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Value___(name_, TRUE));
END Get_Value;



@UncheckedAccess
FUNCTION Get_Date_Value (
   name_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN(To_Date(Get_Value___(name_, TRUE), Client_SYS.date_format_));
END Get_Date_Value;



@UncheckedAccess
FUNCTION Get_Number_Value (
   name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN(To_Number(Get_Value___(name_, TRUE)));
END Get_Number_Value;



@UncheckedAccess
FUNCTION Get_Boolean_Value (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Value___(name_, TRUE) = Fnd_Boolean_API.DB_TRUE) THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Boolean_Value;



@UncheckedAccess
FUNCTION Find_Value (
   name_ IN VARCHAR2,
   default_value_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Value___(name_, FALSE, default_value_));
END Find_Value;



@UncheckedAccess
FUNCTION Find_Date_Value (
   name_ IN VARCHAR2,
   default_value_ IN DATE DEFAULT NULL ) RETURN DATE
IS
BEGIN
   RETURN(To_Date(Get_Value___(name_, FALSE, default_value_), Client_SYS.date_format_));
END Find_Date_Value;



@UncheckedAccess
FUNCTION Find_Number_Value (
   name_ IN VARCHAR2,
   default_value_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
BEGIN
   RETURN(To_Number(Get_Value___(name_, FALSE, default_value_)));
END Find_Number_Value;



@UncheckedAccess
FUNCTION Find_Boolean_Value (
   name_ IN VARCHAR2,
   default_value_ IN BOOLEAN DEFAULT TRUE ) RETURN BOOLEAN
IS
   new_default_value_ VARCHAR2(10);
BEGIN
   IF (default_value_ = TRUE) THEN 
      new_default_value_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      new_default_value_ := Fnd_Boolean_API.DB_FALSE;
   END IF;      
   IF (Get_Value___(name_, FALSE, new_default_value_) = Fnd_Boolean_API.DB_TRUE) THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Find_Boolean_Value;



@UncheckedAccess
FUNCTION Exist (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(context_.exists(name_));
END Exist;



@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN NUMBER )
IS
BEGIN
   Set_Value___(name_, to_number(value_));
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN DATE )
IS
BEGIN
   Set_Value___(name_, to_char(value_, Client_SYS.date_format_));
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Set_Value___(name_, value_);
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN BOOLEAN )
IS
BEGIN
   IF (value_ = TRUE) THEN
      Set_Value___(name_, Fnd_Boolean_API.DB_TRUE);
   ELSE
      Set_Value___(name_, Fnd_Boolean_API.DB_FALSE);
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Values (
   msg_ IN VARCHAR2 )
IS
BEGIN
   Set_Values___(msg_);
END Set_Values;



