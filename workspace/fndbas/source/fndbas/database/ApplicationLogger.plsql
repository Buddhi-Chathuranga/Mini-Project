-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationLogger
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-----------------------------------------------------------------------------
-- How it works
-----------------------------------------------------------------------------
-- All information is stored in the Fnd Context
-- Each application or functionality which uses the logger gets a seperate
-- storage area and a marker which points to the current location the log information
-- is written to.
-- E.g. ContextName  = Value
--      
--      ApplicationLogger.MARKER.TestApplication = 2
--      ApplicationLogger.STORAGE.TestApplication1 = ....log info...     
--      ApplicationLogger.STORAGE.TestApplication2 = ....log info...
--
-- The Log information only lives for the duration of the Session

-------------------- PUBLIC DECLARATIONS ------------------------------------

CATEGORY_INFO     CONSTANT VARCHAR2(12) := 'INFORMATION';
CATEGORY_WARNING  CONSTANT VARCHAR2(12) := 'WARNING';
CATEGORY_ERROR    CONSTANT VARCHAR2(12) := 'ERROR';

-------------------- PRIVATE DECLARATIONS -----------------------------------

LOG_MARKER        CONSTANT VARCHAR2(100) := lu_name_||'.MARKER'; 
LOG_STORAGE       CONSTANT VARCHAR2(100) := lu_name_||'.STORAGE';

LINE_MARKER           CONSTANT VARCHAR2(2) := chr(30)||chr(31);
CATEGORY_MARKER_END   CONSTANT VARCHAR2(2) := chr(31) || '^';

NEW_LINE          CONSTANT VARCHAR2(10) := chr(10);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Marker_Context_Name___ (
   application_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN LOG_MARKER||'.'||application_name_;
END Get_Marker_Context_Name___;

FUNCTION Get_Storage_Context_Name___ (
   application_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN LOG_STORAGE||'.'||application_name_;
END Get_Storage_Context_Name___;
   
FUNCTION Get_Current_Log_Marker___ (
   application_name_ IN VARCHAR2 ) RETURN BINARY_INTEGER
IS
BEGIN
   RETURN Fnd_Context_SYS.Find_Number_Value(Get_Marker_Context_Name___(application_name_), 1);
END Get_Current_Log_Marker___;

PROCEDURE Set_Current_Log_Marker___ (
   application_name_ IN VARCHAR2,
   value_            IN BINARY_INTEGER)
IS
BEGIN
   Fnd_Context_SYS.Set_Value(Get_Marker_Context_Name___(application_name_), value_);
END Set_Current_Log_Marker___;
   
PROCEDURE Inc_Current_Log_Marker___ (
   application_name_ IN VARCHAR2 )
IS
   current_ BINARY_INTEGER;
BEGIN
   current_ := Get_Current_Log_Marker___(application_name_);
   current_ := current_ + 1;
   Set_Current_Log_Marker___(application_name_, current_);
END Inc_Current_Log_Marker___;

FUNCTION Get_Log_Storage_Name___ (
   application_name_ IN VARCHAR2,
   marker_value_     IN BINARY_INTEGER) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Storage_Context_Name___(application_name_) || marker_value_;
END Get_Log_Storage_Name___;
   
FUNCTION Get_Current_Log_Storage___ (
   application_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   RETURN Get_Log_Storage_Name___(application_name_, Get_Current_Log_Marker___(application_name_));
END Get_Current_Log_Storage___;

PROCEDURE Log___ (
   application_name_ IN VARCHAR2,
   text_             IN VARCHAR2)
IS
BEGIN
   Fnd_Context_SYS.Set_Value(Get_Current_Log_Storage___(application_name_), text_);
END Log___;

FUNCTION Get_Current_Storage_Text___ (
   application_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Context_SYS.Find_Value(Get_Current_Log_Storage___(application_name_));
END Get_Current_Storage_Text___;

FUNCTION Get_Storage_Text___ (
   application_name_ IN VARCHAR2,
   marker_           IN BINARY_INTEGER) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Context_SYS.Find_Value(Get_Log_Storage_Name___(application_name_, marker_));
END Get_Storage_Text___;

PROCEDURE Clear_Storage_Text___ (
   application_name_ IN VARCHAR2,
   marker_           IN BINARY_INTEGER)
IS
   str_null_ VARCHAR2(1) := NULL;
BEGIN
   Fnd_Context_SYS.Set_Value(Get_Log_Storage_Name___(application_name_, marker_), str_null_);
END Clear_Storage_Text___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Recommended Usage
----------------------------------------------------------------------------
-- Rather than using this method directly, define your own set of procedures
-- which interns calls these methods
-- The Log information only lives for the duration of the Session
-- See get Get_All method
PROCEDURE Log (
   application_name_ IN VARCHAR2,
   category_         IN VARCHAR2,
   in_text_             IN VARCHAR2,
   indent_on_call_depth_ IN BOOLEAN DEFAULT FALSE,
   indent_offset_        IN BINARY_INTEGER DEFAULT 3)
   -- indent_offset_ used to specify how much intedentation should be ignored
   -- Default = 3 since, the call is by default 3 subprocedures down. (Calling_method->Log->Log.Core) 
IS
   current_text_ VARCHAR2(32767);
   text_         VARCHAR2(32767);
   buffer_too_small EXCEPTION;
   PRAGMA exception_init(buffer_too_small, -06502);
   indent_ NUMBER;
BEGIN
   current_text_ := Get_Current_Storage_Text___(application_name_);
   
   IF indent_on_call_depth_ THEN
      indent_ := (UTL_Call_Stack.Dynamic_Depth-indent_offset_)*3;
      IF indent_ < 0 THEN
         Log_SYS.App_Trace(Log_SYS.warning_, 'ApplicationLogger: Incorrect indentation found at '|| dbms_utility.format_call_stack);
         indent_ := 0;
      END IF;
      text_ := Rpad(' ', indent_ )|| in_text_;
   ELSE
      text_ := in_text_;
   END IF;
   current_text_ := current_text_ || category_ || CATEGORY_MARKER_END || text_ || LINE_MARKER ;
   Log___(application_name_, current_text_);
EXCEPTION
   WHEN buffer_too_small THEN
      Inc_Current_Log_Marker___(application_name_);
      text_ :=  category_ || CATEGORY_MARKER_END || text_ || LINE_MARKER ;
      Log___(application_name_, text_);
END Log;

-- The Log information only lives for the duration of the Session
-- So when every call is done, Call method Get_All to return everything
-- Back to the the client, or store it in someplace
PROCEDURE Get_All (
   output_ IN OUT CLOB,
   application_name_ IN VARCHAR2,
   mark_info_    IN BOOLEAN DEFAULT FALSE,
   mark_warning_ IN BOOLEAN DEFAULT FALSE,
   mark_error_   IN BOOLEAN DEFAULT FALSE)
IS
   current_marker_ NUMBER;
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
   category_ VARCHAR2(12);
   temp_value_ VARCHAR2(32767);
   text_ VARCHAR2(32767);
BEGIN
   current_marker_ := Get_Current_Log_Marker___(application_name_);

   FOR i_ IN 1..current_marker_ LOOP
      text_ := Get_Storage_Text___(application_name_, i_);
      from_ := 1;
      to_   := instr(text_, LINE_MARKER, from_);
        
      WHILE (to_ > 0) LOOP
         index_  := instr(text_, CATEGORY_MARKER_END, from_);               
         category_ := substr(text_, from_, index_-from_);
         temp_value_ := substr(text_, index_+2, to_-index_-2);
         IF (mark_info_ AND category_ = CATEGORY_INFO) 
            OR (mark_warning_ AND category_ = CATEGORY_WARNING) 
            OR (mark_error_   AND category_ = CATEGORY_ERROR) THEN
            temp_value_ := '<'||category_||'>'||temp_value_||'</'||category_||'>';
         END IF;
         temp_value_ := temp_value_|| NEW_LINE;
         dbms_lob.writeappend(output_, length(temp_value_), temp_value_);
         from_ := to_+2;
         to_   := instr(text_, LINE_MARKER, from_);
      END LOOP;
      Clear_Storage_Text___(application_name_, i_);
   END LOOP;
   Set_Current_Log_Marker___(application_name_, 1);
   EXCEPTION
   WHEN others THEN
      Log_SYS.App_Trace(Log_SYS.debug_, ' Exception generating log: ' || SQLERRM); 
END Get_All;

PROCEDURE Clear_All (
   application_name_ IN VARCHAR2)
IS
   current_marker_ NUMBER;
BEGIN
   current_marker_ := Get_Current_Log_Marker___(application_name_);

   FOR i_ IN 1..current_marker_ LOOP
      Clear_Storage_Text___(application_name_, i_);
   END LOOP;

   Set_Current_Log_Marker___(application_name_, 1);
END Clear_All;
