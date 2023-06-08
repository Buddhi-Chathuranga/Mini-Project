-----------------------------------------------------------------------------
--
--  Logical unit: Log
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

not_set_    CONSTANT NUMBER := -1;
undefined_  CONSTANT NUMBER := 0;
error_      CONSTANT NUMBER := 1;
warning_    CONSTANT NUMBER := 2;
info_       CONSTANT NUMBER := 3;
trace_      CONSTANT NUMBER := 4;
debug_      CONSTANT NUMBER := 5;

-------------------- PRIVATE DECLARATIONS -----------------------------------

not_set_txt_   CONSTANT VARCHAR2(12) := '';
undefined_txt_ CONSTANT VARCHAR2(12) := 'UNDEFINED';
error_txt_     CONSTANT VARCHAR2(12) := 'ERROR';
warning_txt_   CONSTANT VARCHAR2(12) := 'WARNING';
info_txt_      CONSTANT VARCHAR2(12) := 'INFORMATION';
trace_txt_     CONSTANT VARCHAR2(12) := 'TRACE';
debug_txt_     CONSTANT VARCHAR2(12) := 'DEBUG';
--
separator_     CONSTANT VARCHAR2(1)   := '^';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Substr_Categories___ (
   line_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
BEGIN
   RETURN(Substr(line_, Instr(line_, '^', 1, 3)+1));
END Substr_Categories___;

FUNCTION Check_Level___ (
   category_db_ IN VARCHAR2,
   level_ IN NUMBER ) RETURN BOOLEAN 
IS 
BEGIN
   IF (level_ <= Fnd_Context_SYS.Find_Number_Value(Get_Category_Ctx___('ALL'), 0)) THEN
      RETURN(TRUE);
   END IF;
   IF (level_ <= Fnd_Context_SYS.Find_Number_Value(Get_Category_Ctx___(category_db_), 0)) THEN
      RETURN(TRUE);
   END IF;  
   RETURN(FALSE);
END Check_Level___;

FUNCTION Get_Category_Ctx___ (
   category_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   CASE category_db_
   WHEN Log_Category_API.DB_ALL THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_ALL);
   WHEN Log_Category_API.DB_CALLSTACK THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_CALLSTACK);
   WHEN Log_Category_API.DB_INSTALLATION THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_INSTALLATION);
   WHEN Log_Category_API.DB_APPLICATION THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_APPLICATION);
   WHEN Log_Category_API.DB_FRAMEWORK THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_FRAMEWORK);
   WHEN Log_Category_API.DB_BOOTSTRAP THEN 
      RETURN('LOG_SYS.'||Log_Category_API.DB_BOOTSTRAP);
   ELSE 
      RETURN(NULL); --Error?
   END CASE;
END Get_Category_Ctx___;

FUNCTION Get_Label___ (
   level_ IN NUMBER ) RETURN VARCHAR2
IS 
   label_   VARCHAR2(30);
BEGIN
   CASE level_
      WHEN not_set_ THEN 
         label_ := not_set_txt_;
      WHEN undefined_ THEN 
         label_ := undefined_txt_;
      WHEN error_ THEN 
         label_ := error_txt_;
      WHEN warning_ THEN 
         label_ := warning_txt_;
      WHEN info_ THEN 
         label_ := info_txt_;
      WHEN trace_ THEN 
         label_ := trace_txt_;
      WHEN debug_ THEN 
         label_ := debug_txt_;
      ELSE
         label_ := undefined_txt_;
         --RAISE no_data_found;
   END CASE;
   RETURN(label_);
END Get_Label___;   


FUNCTION Get_Level___ (
   label_ IN VARCHAR ) RETURN NUMBER
IS 
   level_   NUMBER;
BEGIN
   CASE label_
      WHEN not_set_txt_ THEN 
         level_ := not_set_;
      WHEN undefined_txt_ THEN 
         level_ := undefined_;
      WHEN error_txt_ THEN 
         level_ := error_;
      WHEN warning_txt_ THEN 
         level_ := warning_;
      WHEN info_txt_ THEN 
         level_ := info_;
      WHEN trace_txt_ THEN 
         level_ := trace_;
      WHEN debug_txt_ THEN 
         level_ := debug_;
      ELSE
         level_ := undefined_;
   END CASE;
   RETURN(level_);
END Get_Level___;   


PROCEDURE Put_Line___ (
   category_   IN VARCHAR2,
   level_      IN NUMBER,
   type_       IN VARCHAR2,
   text_       IN VARCHAR2,
   format_     IN BOOLEAN DEFAULT FALSE )
IS
   indentation_   PLS_INTEGER;
BEGIN
   IF (Check_Level___(category_, level_)) THEN
      indentation_ :=   CASE Installation_SYS.Get_Installation_Mode 
                        WHEN TRUE THEN
                           0
                        ELSE
                           UTL_Call_Stack.Dynamic_Depth 
                        END;
      IF (Fnd_Context_SYS.Find_Boolean_Value('LOG_SYS.Format', format_)) THEN 
         Dbms_Output.Put_Line(Rpad(' ', indentation_*3) || type_ || ': ' || text_);
      ELSE 
         Dbms_Output.Put_Line(to_char(indentation_) || separator_ || to_char(dbms_utility.get_time) || separator_ || category_ || separator_ || Get_Label___(level_) || separator_  || type_ || separator_ || text_);
      END IF;
   END IF;
END Put_Line___;

PROCEDURE Set_Log_Level___ (
   category_   IN VARCHAR2,
   level_      IN NUMBER,
   format_     IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF Installation_SYS.Get_Installation_Mode = FALSE THEN
      IF (nvl(level_, not_set_) <= undefined_) THEN 
         Dbms_Output.Disable;
      ELSE 
         Dbms_Output.Enable(NULL);
      END IF;
   END IF;
   Fnd_Context_SYS.Set_Value(Get_Category_Ctx___(category_), nvl(level_, not_set_));
   Set_Format(format_);
END Set_Log_Level___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Label_ (
   level_   IN NUMBER ) RETURN VARCHAR2 
IS
BEGIN
   RETURN(Get_Label___(level_));
END Get_Label_;


@UncheckedAccess
FUNCTION Get_Level_ (
   label_   IN VARCHAR2 ) RETURN NUMBER 
IS
BEGIN
   RETURN(Get_Level___(label_));
END Get_Level_;


@UncheckedAccess
PROCEDURE Set_Log_Level_ (
   level_   IN NUMBER,
   format_  IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Log_Level___('ALL', level_, format_);
END Set_Log_Level_;

PROCEDURE Set_Log_Level_ (
   level_      IN NUMBER,
   category_   IN VARCHAR2,
   format_     IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Log_Level___(category_, level_, format_);   
END Set_Log_Level_;


@UncheckedAccess
FUNCTION Get_Log_Level_ RETURN NUMBER 
IS
BEGIN
   RETURN(Fnd_Context_SYS.Find_Number_Value('LOG_SYS.'||Log_Category_API.DB_ALL, not_set_));
END Get_Log_Level_;

@UncheckedAccess
FUNCTION Get_Log_Level_ (
   category_db_   IN VARCHAR2 ) RETURN NUMBER 
IS
BEGIN
   RETURN(Fnd_Context_SYS.Find_Number_Value('LOG_SYS.'||category_db_, not_set_));
END Get_Log_Level_;


@UncheckedAccess
PROCEDURE Fnd_Trace_ (
   level_   IN NUMBER,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_FRAMEWORK, level_, Log_Category_API.Decode(Log_Category_API.DB_FRAMEWORK), text_);
END Fnd_Trace_;


@UncheckedAccess
PROCEDURE Fnd_Trace_ (
   level_   IN NUMBER,
   type_    IN VARCHAR2,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_FRAMEWORK, level_, type_, text_);
END Fnd_Trace_;


@UncheckedAccess
PROCEDURE Init_Trace_ (
   level_   IN NUMBER,
   type_    IN VARCHAR2,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_BOOTSTRAP, level_, type_, text_);
END Init_Trace_;


@UncheckedAccess
PROCEDURE Init_Trace_ (
   level_   IN NUMBER,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_BOOTSTRAP, level_, Log_Category_API.Decode(Log_Category_API.DB_BOOTSTRAP), text_);
END Init_Trace_;


@UncheckedAccess
PROCEDURE Stack_Trace_ (
   level_   IN NUMBER,
   type_    IN VARCHAR2,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_CALLSTACK, level_, type_, text_);
END Stack_Trace_;


@UncheckedAccess
PROCEDURE Stack_Trace_ (
   level_   IN NUMBER,
   text_    IN VARCHAR2 )
IS
BEGIN
--   Put_Line___(Log_Category_API.DB_CALLSTACK, level_, Log_Category_API.Decode(Log_Category_API.DB_CALLSTACK), text_);
   Put_Line___(Log_Category_API.DB_CALLSTACK, level_, Null, text_);
END Stack_Trace_;


@UncheckedAccess
PROCEDURE Installation_Trace_ (
   type_    IN VARCHAR2,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_INSTALLATION, info_, type_, text_, TRUE);
END Installation_Trace_;


@UncheckedAccess
PROCEDURE Installation_Trace_ (
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_INSTALLATION, info_, Log_Category_API.Decode(Log_Category_API.DB_INSTALLATION), text_, TRUE);
END Installation_Trace_;

@UncheckedAccess
PROCEDURE Init_Debug_Session_ (
   lang_code_     IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_API.Set_Language(lang_code_);
END Init_Debug_Session_;

@UncheckedAccess
PROCEDURE Init_Odp_Debug_Session_(
   fnd_user_      IN VARCHAR2, 
   lang_code_     IN VARCHAR2 ) 
IS
BEGIN
   Fnd_Session_Util_API.Set_Fnd_User_(fnd_user_);
   Fnd_Session_API.Set_Property('ODP_SESSION', 'TRUE');
   Fnd_Session_API.Set_Language(lang_code_);
END Init_Odp_Debug_Session_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE App_Trace (
   level_   IN NUMBER,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_APPLICATION, level_, Log_Category_API.Decode(Log_Category_API.DB_APPLICATION), text_);
END App_Trace;


@UncheckedAccess
PROCEDURE App_Trace (
   level_   IN NUMBER,
   type_    IN VARCHAR2,
   text_    IN VARCHAR2 )
IS
BEGIN
   Put_Line___(Log_Category_API.DB_APPLICATION, level_, type_, text_);
END App_Trace;


@UncheckedAccess
FUNCTION Check_Category (
   trace_line_ IN VARCHAR2,
   category_arr_ IN dbms_utility.lname_array ) RETURN BOOLEAN 
IS
BEGIN
   IF (category_arr_.count < 1) THEN
      RETURN(TRUE);
   END IF;
   FOR i IN category_arr_.first..category_arr_.last LOOP
      IF (instr(trace_line_, category_arr_(i)||'^') > 0) THEN 
         RETURN(TRUE);
      END IF;
   END LOOP;
   RETURN(FALSE);
END Check_Category;


@UncheckedAccess
PROCEDURE Set_Format (
   format_ IN BOOLEAN DEFAULT FALSE ) 
IS
BEGIN
   Fnd_Context_SYS.Set_Value('LOG_SYS.Format', format_);
END Set_Format;

@UncheckedAccess
FUNCTION Get_Separator RETURN VARCHAR2 
IS
BEGIN
   RETURN(separator_);
END Get_Separator;

@UncheckedAccess
PROCEDURE Get_Trace (
   text_ IN OUT NOCOPY CLOB,
   category_arr_ IN dbms_utility.lname_array,
   substr_categories_ IN BOOLEAN DEFAULT FALSE ) 
IS
   lines_         Dbms_Output.chararr;
   get_lines_     CONSTANT BINARY_INTEGER := 1000;
   fetched_lines_ BINARY_INTEGER;
   
BEGIN
   fetched_lines_ := get_lines_;
   Dbms_Output.get_lines(lines_, fetched_lines_);
   WHILE (fetched_lines_ <= get_lines_) LOOP
      FOR i IN 1..fetched_lines_ LOOP
         IF (Log_SYS.Check_Category(lines_(i), category_arr_)) THEN 
            IF (substr_categories_) THEN 
               text_ := text_ || (Log_SYS.Substr_Categories___(REPLACE(lines_(i), chr(10), ' '))||chr(10));
            ELSE 
               text_ := text_ || (REPLACE(lines_(i), chr(10), ' ')||chr(10));
            END IF;
         END IF;
      END LOOP;
      IF (fetched_lines_ != get_lines_) THEN
         EXIT;
      ELSE
         fetched_lines_ := get_lines_;
         Dbms_Output.get_lines(lines_, fetched_lines_);
      END IF;
   END LOOP;
END Get_Trace;


@UncheckedAccess
FUNCTION Get_Trace_Line (
   category_arr_ IN dbms_utility.lname_array,
   substr_categories_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2 
IS
   line_          VARCHAR2(32767);
   status_        BINARY_INTEGER;
BEGIN
   Dbms_Output.Get_Line(line_, status_);
   IF (status_ = 0) THEN
      IF (Log_SYS.Check_Category(line_, category_arr_)) THEN 
         IF (substr_categories_) THEN 
            RETURN(Log_SYS.Substr_Categories___(line_));
         ELSE 
            RETURN(line_);
         END IF;
      END IF;
   END IF;
   RETURN(NULL);
END Get_Trace_Line;



@UncheckedAccess
FUNCTION Get_Trace_Line RETURN VARCHAR2 
IS
   line_          VARCHAR2(32767);
   status_        BINARY_INTEGER;
BEGIN
   Dbms_Output.Get_Line(line_, status_);
   IF (status_ = 0) THEN
      RETURN(line_);
   ELSE 
      RETURN(NULL);
   END IF;
END Get_Trace_Line;

@UncheckedAccess
FUNCTION Is_Log_Set (
   category_db_ IN VARCHAR2) RETURN BOOLEAN 
IS
BEGIN
   Log_Category_API.Exist_Db(category_db_);
   IF (Get_Log_Level_(category_db_) > not_set_) THEN 
      RETURN(TRUE);
   ELSE 
      RETURN(FALSE);
   END IF;
END Is_Log_Set;

/*
@UncheckedAccess
FUNCTION Is_Log_Set (
   category_db_ IN VARCHAR2) RETURN VARCHAR2 
IS
BEGIN
   IF Is_Log_Set(category_db_) THEN 
      RETURN('TRUE');
   ELSE 
      RETURN('FALSE');
   END IF;
END Is_Log_Set;
*/

@UncheckedAccess
FUNCTION Is_Log_Level_Set (
   level_ IN VARCHAR2, 
   category_db_ IN VARCHAR2 DEFAULT Log_Category_API.DB_ALL) RETURN BOOLEAN 
IS
BEGIN
   IF (Check_Level___(category_db_, level_)) THEN
      RETURN TRUE;
   ELSE 
      RETURN FALSE;
   END IF;
END Is_Log_Level_Set;

@UncheckedAccess
PROCEDURE Set_Category (
   category_arr_ IN OUT NOCOPY dbms_utility.lname_array, 
   category_   IN VARCHAR2 )
IS
BEGIN
   category_arr_(nvl(category_arr_.Last+1, 1)) := category_;
END Set_Category;

@UncheckedAccess
PROCEDURE Init_Method (
   package_     IN VARCHAR2,
   method_      IN VARCHAR2 )
IS
BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, package_||'.'||method_ || ' entered.');
   Dbms_Application_Info.Set_Module(package_, method_); 
END Init_Method;

