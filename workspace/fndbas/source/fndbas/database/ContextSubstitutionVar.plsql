-----------------------------------------------------------------------------
--
--  Logical unit: ContextSubstitutionVar
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  061102  HENJSE  Register new ContextSubstitutionVariables fix (Bug#61587).
--  061113  HAAR    Possible to use Module_API.Exist again during Insert (Bug#61809).
--  061218  HAAR    Remove check against Module_API.Exist again during Insert (Bug#61809).
--  061127  HAAR    Possible to use Module_API.Exist again during Insert (Bug#62523).
--  070205  HAAR    Added Replace_Variables__ (Bug#63423).
--  070209  ASWILK  Added method Get_Client_Value__ (Bug#63423).
--  070718  SUMALK  Added init_context_variable to initialise context variables.
--  071130  SUMALK  Added Get_Date_Format_String (Bug#68683)
--  080327  UTGULK  Added new variable 'NOW'. (Bug#71360).
--  081013  DUWILK  Changed Replace_Variables__ (Bug#77744).
--  081219  HASPLK  Added method Replace_Variable (Bug#79243).
--  091006  NABALK  Improved the fucntionality of Replace_Variables__ method (Bug#86091)
--  100710  DUWILK  Introduced new variables to get numeric vlaues for months and years (Bug#90723).
--  120218  DUWILK  Renamed the variable in Get_Server_Value__(RDTERUNTIME-1398).
--  130121  MADDLK  Corrected the logic for some variables in Get_Server_Value__ method(Bug#107938)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);

TYPE CSV_ARRAY_TAB IS TABLE OF VARCHAR2(500) INDEX BY VARCHAR2(30);


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Function___ (
   name_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   server_method_          context_substitution_var_tab.server_method%TYPE;
   --SOLSETFW
   CURSOR get_row IS
      SELECT server_method
        FROM context_substitution_var_tab c
       WHERE name = name_
         AND EXISTS (SELECT 1 FROM module_tab m 
                      WHERE c.module = m.module AND m.active = 'TRUE');
   server_method_is_null   EXCEPTION;
BEGIN
   OPEN  get_row;
   FETCH get_row INTO server_method_;
   IF get_row%NOTFOUND THEN
      RAISE no_data_found;
   END IF;
   CLOSE get_row;
   IF (server_method_ IS NULL) THEN
      RAISE server_method_is_null;
   END IF;
   RETURN(server_method_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Record_General(lu_name_, 'NO_PARAMETER: Parameter [:P1] does not exist.', name_);
   WHEN server_method_is_null THEN
      Error_SYS.Record_General(lu_name_, 'NO_FUNCTION: Parameter [:P1] can not find any implementation.', name_);
END Get_Function___;


PROCEDURE Replace_CSV_Variables___ (
   stmt_           OUT VARCHAR2,
   bind_variables_ OUT VARCHAR2,
   string_          IN VARCHAR2,
   type_            IN VARCHAR2 DEFAULT 'VALUE',
   sql_string_      IN BOOLEAN  DEFAULT FALSE,
   bind_prefix_     IN VARCHAR2 DEFAULT NULL )
IS
   msg_               VARCHAR2(30000);
   replace_val_       VARCHAR2(4000);
   var_               VARCHAR2(20000);
   datatype_          VARCHAR2(20000);
   max_no_vars_       NUMBER := 50;
   context_sub_array_ VARCHAR2(32000);
   occurrence_        PLS_INTEGER := 1;
   i_                 PLS_INTEGER := 0;
BEGIN
   -- Replaces occurences in string_ of #<var># with the corresponding context substitution variable and return the new string
   context_sub_array_:= Init_Context_Variables__;
   stmt_ := string_;
   WHILE (i_ < max_no_vars_) LOOP                                     -- (Exit when no more occurences of # )
      i_ := i_ + 1;
      IF nvl(instr(stmt_, '#', 1, 2*occurrence_), 0)  = 0 THEN
        EXIT;
      END IF;
      var_           := Regexp_Substr(stmt_, '#[^# '||CHR(10)||']+#', occurrence => occurrence_);        -- get variable #<VarName>#
      var_           := Substr(var_, 2, Length(var_)-2);                  -- get name without pre and post character '#'  <VarName>
      IF Client_Sys.Get_Item_Value(var_,context_sub_array_) IS NOT NULL THEN  -- Check whether var_ is a context Substitute variable
         -- Type_ can have the following values VALUE, FUNCTION, BIND
         CASE type_
            WHEN 'VALUE' THEN
               msg_           := Get_String__(var_);                               -- get value for <VarName>
               datatype_      := Message_SYS.Find_Attribute(msg_, 'DATATYPE', '');
               replace_val_   := Message_SYS.Find_Attribute(msg_, 'VALUE', '');
               IF (sql_string_) THEN
                  CASE datatype_
                     WHEN 'String' THEN
                        replace_val_ := '''' || replace_val_ || '''';
                     WHEN 'Number' THEN
                        replace_val_ := replace_val_;
                     WHEN 'Date' THEN
   --                 replace_val_ := 'to_date(''' || replace_val_ || ''', '''||Language_Code_API.Get_Nls_Date_Format(Fnd_Session_Api.Get_Language)||''')';
                        replace_val_ := 'to_date(''' || replace_val_ || ''', '''||Client_SYS.Date_Format_||''')';
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            WHEN 'FUNCTION' THEN
               replace_val_ := Get_Function___(var_);
            WHEN 'BIND' THEN
               replace_val_    := ':'||bind_prefix_||to_char(i_);
               msg_            := Get_String__(var_);                               -- get value for <VarName>
               Message_SYS.Add_Attribute (bind_variables_, 'BIND'||to_char(i_), msg_);
            ELSE
               NULL;
         END CASE;
         -- Replace the statement
         stmt_ := Replace(stmt_, '#'||var_||'#', replace_val_);                   -- replace #<VarName># with value
      ELSE
         occurrence_ := occurrence_ + 1;
      END IF;
   END LOOP;
END Replace_CSV_Variables___;


FUNCTION Init_Csv_Arr___ RETURN CSV_ARRAY_TAB
IS
   --SOLSETFW
   CURSOR get_name IS
      SELECT name, server_method
        FROM context_substitution_var_tab c
       WHERE EXISTS (SELECT 1 FROM module_tab m 
                      WHERE c.module = m.module AND m.active = 'TRUE');
   csv_arr_  CSV_ARRAY_TAB;
BEGIN
   FOR rec_ IN get_name LOOP
      csv_arr_(rec_.name) := rec_.server_method;
   END LOOP;
   RETURN(csv_arr_);
END Init_Csv_Arr___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE,
   newrec_     IN OUT CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   super(objid_, remrec_);
END Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Client_Value__ (
   name_ IN VARCHAR2 ) RETURN DATE
IS
   temp_             VARCHAR2(200);
   return_date_      DATE;

BEGIN
   --
   -- Day
   --
   IF name_ = 'TODAY' THEN
      temp_ := 'TRUNC(SYSDATE)';
   ELSIF name_ = 'NOW' THEN
      temp_ := 'SYSDATE';
   ELSIF name_ = 'TOMORROW' THEN
      temp_ := 'TRUNC(SYSDATE)+1';
   ELSIF name_ = 'YESTERDAY' THEN
      temp_ := 'TRUNC(SYSDATE)-1';
   --
   -- Start of Week
   --
   ELSIF name_ = 'START_OF_THIS_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1';
   ELSIF name_ = 'START_OF_NEXT_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1+7';
   ELSIF name_ = 'START_OF_LAST_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1-7';
   --
   -- Start of Month
   --
   ELSIF name_ = 'START_OF_THIS_MONTH' THEN
      temp_ := 'TRUNC(SYSDATE, ''MONTH'')';
   ELSIF name_ = 'START_OF_NEXT_MONTH' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''MONTH''),1)';
   ELSIF name_ = 'START_OF_LAST_MONTH' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''MONTH''),-1)';
   --
   -- Start of Year
   --
   ELSIF name_ = 'START_OF_THIS_YEAR' THEN
      temp_ := 'TRUNC(SYSDATE, ''YEAR'')';
   ELSIF name_ = 'START_OF_NEXT_YEAR' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''YEAR''),12)';
   ELSIF name_ = 'START_OF_LAST_YEAR' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''YEAR''),-12)';
   --
   -- End of Week
   --
   ELSIF name_ = 'END_OF_THIS_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1+7-1/(60*60*24)';
   ELSIF name_ = 'END_OF_NEXT_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1+14-1/(60*60*24)';
   ELSIF name_ = 'END_OF_LAST_WEEK' THEN
      temp_ := 'TRUNC(SYSDATE)-TO_NUMBER(TO_CHAR(SYSDATE, ''D''))+1-1/(60*60*24)';
   --
   -- End of Month
   --
   ELSIF name_ = 'END_OF_THIS_MONTH' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''MONTH''),1) - 1/ ( 60*60*24 )';
   ELSIF name_ = 'END_OF_NEXT_MONTH' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''MONTH''),2) - 1/ ( 60*60*24 )';
   ELSIF name_ = 'END_OF_LAST_MONTH' THEN
      temp_ := 'TRUNC(SYSDATE, ''MONTH'') - 1/ ( 60*60*24 )';
   --
   -- End of Year
   --
   ELSIF name_ = 'END_OF_THIS_YEAR' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''YEAR''),12) - 1/ ( 60*60*24 )';
   ELSIF name_ = 'END_OF_NEXT_YEAR' THEN
      temp_ := 'ADD_MONTHS(TRUNC(SYSDATE, ''YEAR''),24) - 1/ ( 60*60*24 )';
   ELSIF name_ = 'END_OF_LAST_YEAR' THEN
      temp_ := 'TRUNC(SYSDATE, ''YEAR'') - 1/ ( 60*60*24 )';
   END IF;

   IF temp_ IS NOT NULL THEN
      @ApproveDynamicStatement(2007-02-12,haarse)
      EXECUTE IMMEDIATE 'BEGIN :return := '||temp_||'; END;' USING OUT return_date_;
   END IF;

   RETURN return_date_;
END Get_Client_Value__;


FUNCTION Get_Server_Value__ (
   name_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_             VARCHAR2(200);
   return_number_    NUMBER;

BEGIN
   --
   -- Context Substitution Variables which returns Numeric Values
   --
   -- Months numeric variables
   --
   IF name_ = 'NUMBER_OF_LAST_MONTH' THEN
      temp_ := 'EXTRACT( MONTH FROM ADD_MONTHS(SYSDATE, -1))';
   ELSIF name_ = 'NUMBER_OF_THIS_MONTH' THEN
      temp_ := 'EXTRACT( MONTH FROM SYSDATE)';
   ELSIF name_ = 'NUMBER_OF_NEXT_MONTH' THEN
      temp_ := 'EXTRACT( MONTH FROM ADD_MONTHS(SYSDATE, 1))';
   --
   -- Year numeric Variables
   --
   ELSIF name_ = 'NUMBER_OF_LAST_YEAR' THEN
      temp_ := 'EXTRACT( YEAR FROM SYSDATE) - 1';
   ELSIF name_ = 'NUMBER_OF_THIS_YEAR' THEN
      temp_ := 'EXTRACT( YEAR FROM SYSDATE)';
   ELSIF name_ = 'NUMBER_OF_NEXT_YEAR' THEN
      temp_ := 'EXTRACT( YEAR FROM SYSDATE) + 1';
   END IF;

   IF temp_ IS NOT NULL THEN
      @ApproveDynamicStatement(2010-07-30,duwilk)
      EXECUTE IMMEDIATE 'BEGIN :return := '||temp_||'; END;' USING OUT return_number_;
   END IF;

   RETURN return_number_;
END Get_Server_Value__;


PROCEDURE Get_Value__ (
   value_         OUT VARCHAR2,
   name_          IN VARCHAR2 )
IS
   function_      CONTEXT_SUBSTITUTION_VAR_TAB.server_method%TYPE;
BEGIN
   function_ := Get_Function___(name_);
   function_ := Replace_Variables__(function_, TRUE);
   IF function_ IS NOT NULL THEN
      @ApproveDynamicStatement(2007-02-12,haarse)
      EXECUTE IMMEDIATE 'BEGIN :result := ' || function_ || '; END;' USING OUT value_;
   END IF;
END Get_Value__;


PROCEDURE Get_Value__ (
   value_         OUT NUMBER,
   name_          IN VARCHAR2 )
IS
   function_      CONTEXT_SUBSTITUTION_VAR_TAB.server_method%TYPE;
BEGIN
   function_ := Get_Function___(name_);
   function_ := Replace_Variables__(function_, TRUE);
   IF function_ IS NOT NULL THEN
      @ApproveDynamicStatement(2007-02-12,haarse)
      EXECUTE IMMEDIATE 'BEGIN :value := ' || function_ || '; END;' USING OUT value_;
   END IF;
END Get_Value__;


PROCEDURE Get_Value__ (
   value_         OUT DATE,
   name_          IN VARCHAR2 )
IS
   function_      CONTEXT_SUBSTITUTION_VAR_TAB.server_method%TYPE;
BEGIN
   function_ := Get_Function___(name_);
   function_ := Replace_Variables__(function_, TRUE);
   IF function_ IS NOT NULL THEN
      @ApproveDynamicStatement(2007-02-12,haarse)
      EXECUTE IMMEDIATE 'BEGIN :value := ' || function_ || '; END;' USING OUT value_;
   END IF;
END Get_Value__;


FUNCTION Get_String__ (
   name_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(300);
   string_  VARCHAR2(200);
   date_    DATE;
   number_  NUMBER;
   row_     context_substitution_var_tab%ROWTYPE;

   --SOLSETFW
   CURSOR get_row IS
      SELECT *
        FROM context_substitution_var_tab c
       WHERE name = name_
         AND EXISTS (SELECT 1 FROM module_tab m 
                      WHERE c.module = m.module AND m.active = 'TRUE');
BEGIN
   message_ := Message_SYS.Construct('');
   OPEN  get_row;
   FETCH get_row INTO row_;
   CLOSE get_row;
   IF row_.fnd_data_type = 'STRING' THEN
      Get_Value__(string_, name_);
      Message_SYS.Add_Attribute(message_, 'DATATYPE', 'String');
   ELSIF row_.fnd_data_type = 'DATE' THEN
      Get_Value__(date_, name_);
      string_ := Get_Date_Format_String(date_,name_);
      Message_SYS.Add_Attribute(message_, 'DATATYPE', 'Date');
   ELSIF row_.fnd_data_type = 'NUMBER' THEN
      Get_Value__(number_, name_);
      string_ := To_Char(number_);
      Message_SYS.Add_Attribute(message_, 'DATATYPE', 'Number');
   END IF;
   Message_SYS.Add_Attribute(message_, 'VALUE', string_);
   RETURN(message_);
END Get_String__;


PROCEDURE Export__ (
   message_ OUT VARCHAR2,
   name_ IN VARCHAR2 )

IS
   rec_                  CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE;
BEGIN
   rec_     := Get_Object_By_Keys___(name_);
   --
   -- Create Export file
   --
   message_ :=            '-------------------------------------------------------------------------------------------- ' || newline_;
   message_ := message_ || '-- Export file for variable ' || rec_.name || '.' || newline_;
   message_ := message_ || '-- ' || newline_;
   message_ := message_ || '--  Date    Sign    History' || newline_;
   message_ := message_ || '--  ------  ------  -----------------------------------------------------------' || newline_;
   message_ := message_ || '--  ' || to_char(sysdate, 'YYMMDD') || '  ' || rpad(Fnd_Session_API.Get_Fnd_User, 6, ' ') || '  ' ||
                         'Export file for variable ' || rec_.name || '.' || newline_;
   message_ := message_ || '-------------------------------------------------------------------------------------------- ' || newline_;
   message_ := message_ || newline_;
   message_ := message_ || 'PROMPT Register Context Substitution Variable "' || rec_.name || '"' || newline_;
   message_ := message_ || 'DECLARE' || newline_;
   message_ := message_ || '   variable_name_      VARCHAR2(120)   := NULL;' || newline_;
   message_ := message_ || '   info_msg_           VARCHAR2(32000) := NULL;' || newline_;
   message_ := message_ || 'BEGIN' || newline_;
   --
   -- Create Main Message
   --
   message_ := message_ || '   variable_name_ := '''||rec_.name||''';' || newline_;
   message_ := message_ || '   info_msg_    := Message_SYS.Construct('''');' || newline_;
   message_ := message_ || '   Message_SYS.Add_Attribute(info_msg_, ''SERVER_METHOD'', ''' || replace(rec_.server_method, '''','''''') || ''');' || newline_;
   message_ := message_ || '   Message_SYS.Add_Attribute(info_msg_, ''IMPLEMENTATION_TYPE_DB'', ''' || rec_.implementation_type || ''');' || newline_;
   message_ := message_ || '   Message_SYS.Add_Attribute(info_msg_, ''FND_DATA_TYPE_DB'', ''' || rec_.fnd_data_type || ''');' || newline_;
   message_ := message_ || '   Message_SYS.Add_Attribute(info_msg_, ''TRANSIENT_DB'', ''' || rec_.transient || ''');' || newline_;
   message_ := message_ || '   Message_SYS.Add_Attribute(info_msg_, ''MODULE'', ''' || rec_.module || ''');' || newline_;
   message_ := message_ || '-- Register Context Substitution Variable' || newline_;
   message_ := message_ || '   Context_Substitution_Var_API.Register__(variable_name_, info_msg_);' || newline_;
END Export__;


PROCEDURE Register__ (
   name_       IN OUT VARCHAR2,
   info_msg_   IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     CONTEXT_SUBSTITUTION_VAR_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.name:= name_;
   Client_SYS.Add_To_Attr('SERVER_METHOD',         Message_SYS.Find_Attribute(info_msg_, 'SERVER_METHOD', ''), attr_);
   Client_SYS.Add_To_Attr('IMPLEMENTATION_TYPE_DB', Message_SYS.Find_Attribute(info_msg_, 'IMPLEMENTATION_TYPE_DB', ''), attr_);
   Client_SYS.Add_To_Attr('FND_DATA_TYPE_DB',    Message_SYS.Find_Attribute(info_msg_, 'FND_DATA_TYPE_DB', ''), attr_);
   Client_SYS.Add_To_Attr('TRANSIENT_DB',   Message_SYS.Find_Attribute(info_msg_, 'TRANSIENT_DB', ''), attr_);
   Client_SYS.Add_To_Attr('MODULE',   Message_SYS.Find_Attribute(info_msg_, 'MODULE', ''), attr_);
   --Client_SYS.Add_To_Attr('ROWVERSION',   To_Char(SYSDATE, Client_SYS.date_format_);, ''), attr_);
   --
   -- Check if method already exists in table
   --
   IF Check_Exist___ (objrec_.name) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, objrec_.name);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Client_SYS.Add_To_Attr('NAME', name_, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Register__;

-- FUNCTION Replace_Variables__
--  sql_string_ - if the string is an SQL statement (such as a SELECT statement)
--  plsql_string_ - if the string is a PLSQL block
FUNCTION Replace_Variables__ (
   string_       IN VARCHAR2,
   sql_string_   IN BOOLEAN DEFAULT FALSE, 
   plsql_string_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   tmp_               CLOB;
   msg_               VARCHAR2(4000);
   val_               VARCHAR2(4000);
   var_               VARCHAR2(4000);
   datatype_          VARCHAR2(200);
   max_no_vars_       NUMBER := 50;
   context_sub_array_ VARCHAR2(32000);
   occurrence_        PLS_INTEGER := 1;
BEGIN
   -- Replaces occurences in string_ of #<var># with the corresponding context substitution variable and return the new string
   context_sub_array_:= Init_Context_Variables__;
   tmp_ := string_;
   FOR i IN 1..max_no_vars_ LOOP                                     -- (Exit when no more occurences of # )
      IF instr(tmp_, '#', NTH => 2*occurrence_)  = 0 THEN
        EXIT;
      END IF;
      var_      := Regexp_Substr(tmp_, '#[^# '||CHR(10)||']+#', occurrence => occurrence_);        -- get variable #<VarName>#
      var_      := Substr(var_, 2, Length(var_)-2);                  -- get name without pre and post character '#'  <VarName>
      msg_      := Get_String__(var_);                               -- get value for <VarName>
      val_      := Message_SYS.Find_Attribute(msg_, 'VALUE', '');
      datatype_ := Message_SYS.Find_Attribute(msg_, 'DATATYPE', '');
--      CASE datatype_
--         WHEN 'Date' THEN
--            val_ := Database_SYS.Get_Formatted_Date(to_date(val_, Client_SYS.Date_Format_));
--         ELSE
--            NULL;
--      END CASE;
      -- Escape single quotes only if the string is an SQL statement or a PLSQL block
      IF (sql_string_ OR plsql_string_) THEN
         IF (datatype_='String') THEN
            val_ := replace(val_,'''', '''''');
         END IF;
      END IF;
      IF (sql_string_) THEN
         CASE datatype_
            WHEN 'String' THEN
               val_ := '''' || val_ || '''';
            WHEN 'Number' THEN
               val_ := val_;
            WHEN 'Date' THEN
--               val_ := 'to_date(''' || val_ || ''', '''||Language_Code_API.Get_Nls_Date_Format(Fnd_Session_Api.Get_Language)||''')';
               val_ := 'to_date(''' || val_ || ''', '''||Client_SYS.Date_Format_||''')';
            ELSE
               NULL;
         END CASE;
      END IF;
      IF Client_Sys.Get_Item_Value(var_,context_sub_array_) IS NOT NULL THEN  -- Check whether var_ is a context Substitute variable
         tmp_ := Replace(tmp_, '#'||var_||'#', val_);                   -- replace #<VarName># with value
      ELSE
         occurrence_ := occurrence_ + 1;                                 
      END IF;
   END LOOP;
   RETURN(tmp_);
END Replace_Variables__;


FUNCTION Replace_Variables__ (
   string_     IN CLOB,
   sql_string_ IN BOOLEAN DEFAULT FALSE ) RETURN CLOB 
IS
   tmp_               CLOB;
   msg_               VARCHAR2(4000);
   val_               VARCHAR2(4000);
   var_               VARCHAR2(4000);
   datatype_          VARCHAR2(200);
   max_no_vars_       NUMBER := 50;
   context_sub_array_ VARCHAR2(32000);
   occurrence_        PLS_INTEGER := 1;
BEGIN
   -- Replaces occurences in string_ of #<var># with the corresponding context substitution variable and return the new string
   context_sub_array_:= Init_Context_Variables__;
   tmp_ := string_;
   FOR i IN 1..max_no_vars_ LOOP                                     -- (Exit when no more occurences of # )
      IF instr(tmp_, '#', NTH => 2*occurrence_)  = 0 THEN
        EXIT;
      END IF;
      var_      := Regexp_Substr(tmp_, '#[^# '||CHR(10)||']+#', occurrence => occurrence_);        -- get variable #<VarName>#
      var_      := Substr(var_, 2, Length(var_)-2);                  -- get name without pre and post character '#'  <VarName>
      msg_      := Get_String__(var_);                               -- get value for <VarName>
      val_      := Message_SYS.Find_Attribute(msg_, 'VALUE', '');
      datatype_ := Message_SYS.Find_Attribute(msg_, 'DATATYPE', '');
      IF (sql_string_) THEN
         CASE datatype_
            WHEN 'String' THEN
               val_ := '''' || val_ || '''';
            WHEN 'Number' THEN
               val_ := val_;
            WHEN 'Date' THEN
               val_ := 'to_date(''' || val_ || ''', '''||Client_SYS.Date_Format_||''')';
            ELSE
               NULL;
         END CASE;
      END IF;
      IF Client_Sys.Get_Item_Value(var_,context_sub_array_) IS NOT NULL THEN  -- Check whether var_ is a context Substitute variable
         tmp_ := Replace(tmp_, '#'||var_||'#', val_);                   -- replace #<VarName># with value
      ELSE
         occurrence_ := occurrence_ + 1;                                 
      END IF;
   END LOOP;
   RETURN(tmp_);
END Replace_Variables__;


FUNCTION Replace_Expanded_Variables__ (
   string_       IN VARCHAR2,
   sql_string_   IN BOOLEAN DEFAULT FALSE, 
   plsql_string_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   tmp_          VARCHAR2(4000);
BEGIN
   IF (NOT sql_string_) THEN
      tmp_ := REGEXP_REPLACE(string_, '#((THIS|NEXT|LAST)_(WEEK|MONTH|YEAR))#', '#START_OF_\1#..#END_OF_\1#');
   ELSE
      tmp_ := string_;
   END IF;   
   RETURN Replace_Variables__(tmp_,sql_string_,plsql_string_);   
END Replace_Expanded_Variables__;


@UncheckedAccess
FUNCTION Init_Context_Variables__ RETURN VARCHAR2
IS
   --SOLSETFW
   CURSOR get_name IS
      SELECT name, server_method
        FROM context_substitution_var_tab c
       WHERE EXISTS (SELECT 1 FROM module_tab m 
                      WHERE c.module = m.module AND m.active = 'TRUE');
   context_sub_array_ VARCHAR2(32000);
BEGIN
   FOR rec_ IN get_name LOOP
      Client_Sys.Add_To_Attr(rec_.name, rec_.server_method, context_sub_array_);
   END LOOP;
   RETURN  context_sub_array_;
END Init_Context_Variables__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Contains_Csv (
   string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   csv_arr_    CSV_ARRAY_TAB  := Init_Csv_Arr___;
   occurrence_ PLS_INTEGER := 1;
   var_        VARCHAR2(1000);
   method_     VARCHAR2(1000);
BEGIN
   var_ := Regexp_Substr(string_, '#[^# '||CHR(10)||']+#', occurrence => occurrence_);        -- get variable #<VarName>#
   var_ := Utility_SYS.Between_Str(var_, '#', '#', inclusive_ => FALSE);
   WHILE (var_ IS NOT NULL) LOOP
      BEGIN
         occurrence_ := occurrence_ + 1;
         method_ := csv_arr_(var_);
         RETURN('TRUE');
      EXCEPTION
         WHEN no_data_found THEN -- Read the next CSV if found
            var_ := Regexp_Substr(string_, '#[^# '||CHR(10)||']+#', occurrence => occurrence_);        -- get variable #<VarName>#
            var_ := Utility_SYS.Between_Str(var_, '#', '#', inclusive_ => FALSE);
      END;
   END LOOP;
   RETURN('FALSE');
END Contains_Csv;


@UncheckedAccess
FUNCTION Replace_Variable (
   name_       IN VARCHAR2,
   sql_string_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
BEGIN
   IF UPPER(sql_string_) = 'TRUE' THEN
      RETURN Replace_Variables__(name_, TRUE);
   ELSE
      RETURN Replace_Variables__(name_, FALSE);
   END IF;
END Replace_Variable;


@UncheckedAccess
FUNCTION Replace_Expanded_Variable (
   name_       IN VARCHAR2,
   sql_string_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
BEGIN
   IF UPPER(sql_string_) = 'TRUE' THEN
      RETURN Replace_Expanded_Variables__(name_, TRUE);
   ELSE
      RETURN Replace_Expanded_Variables__(name_, FALSE);
   END IF;
END Replace_Expanded_Variable;


@UncheckedAccess
FUNCTION Replace_Stmt_Function (
   stmt_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   statement_     VARCHAR2(32767);
   bind_values_   VARCHAR2(32767);
BEGIN
   Replace_CSV_Variables___ (statement_, bind_values_, stmt_, 'FUNCTION');
   RETURN(statement_);
END Replace_Stmt_Function;


@UncheckedAccess
FUNCTION Replace_Stmt_Value (
   stmt_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   statement_     VARCHAR2(32767);
   bind_values_   VARCHAR2(32767);
BEGIN
   Replace_CSV_Variables___(statement_, bind_values_, stmt_, 'VALUE', TRUE);
   RETURN(statement_);
END Replace_Stmt_Value;


@UncheckedAccess
PROCEDURE Replace_Stmt_Bind_Variable (
   stmt_        IN OUT VARCHAR2,
   bind_values_    OUT VARCHAR2,
   bind_prefix_ IN     VARCHAR2 DEFAULT 'CSV' )
IS
BEGIN
   Replace_CSV_Variables___(stmt_, bind_values_, stmt_, 'BIND', TRUE, bind_prefix_);--, bind_values_);
END Replace_Stmt_Bind_Variable;


@UncheckedAccess
FUNCTION Get_Date_Format_String(
   date_ IN DATE,
   name_ IN VARCHAR2 ) RETURN   VARCHAR2
IS
   date_format_ VARCHAR2(30) := 'YYYY-MM-DD';
   string_      VARCHAR2(200);
BEGIN

   IF name_ IN ('TODAY','TOMORROW','YESTERDAY','START_OF_THIS_WEEK',
                'START_OF_NEXT_WEEK','START_OF_LAST_WEEK','START_OF_THIS_MONTH',
                'START_OF_NEXT_MONTH','START_OF_LAST_MONTH','START_OF_THIS_YEAR',
                'START_OF_NEXT_YEAR','START_OF_LAST_YEAR') THEN
      string_ := To_Char(date_,date_format_);
   ELSE
      string_ := To_Char(date_, Client_SYS.date_format_);
   END IF;
   RETURN string_;
END Get_Date_Format_String;



