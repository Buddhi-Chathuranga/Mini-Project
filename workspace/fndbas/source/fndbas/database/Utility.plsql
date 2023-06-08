-----------------------------------------------------------------------------
--
--  Logical unit: Utility
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961031  ERFO    Created for IFS Foundation 1.2.2 (Idea #854).
--  970701  ERFO    Mapped package initialization to Fnd_Session_API.
--  980116  ERFO    Correction in mapping to Fnd_Session_API (Bug #2012).
--  980325  ERFO    Correction to support background jobs (Bug #2284).
--  980326  MANY    Utility_SYS.Set_User does not change FndUser. (Bug #2284)
--  020701  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  060518  SUKM    Added method Tokenize.
--  060630  DUWILK  Add new method Describe_Sql_Statement (Bug#56183).
--  060705  SUKM    Made a minor fix with but not related to Bug#58997.
--  070724  PEMASE  Added Assert_SYS and annotation to Describe_Sql_Statement,
--                  and only close open cursors upon exception (Bug #66828).
--  071210  SUMALK  Changed the Dbms_Sql.Describe_Columns to Dbms_Sql.Describe_Columns2
--                  to aviod errors for long SQL reports.(Bug#69208).  
--  080312  HAAR    Implement Fnd_Session properties as a context (Bug#68143).
--  081015  HAAR    Deprecate methods Get_Owner, Get_User and Set_User (Bug#77768).
--  081113  HAAR    Revoke Bug#77768 methods Get_Owner, Get_User (Bug#78445).
--  090308  HAAR    Added methods for Rising and 7/11 project (Bug#81205).
--  160831  CSArlk  Added Convert_Blob_To_Base64
--  191107  KoDelk Added Get_Constraint_From_Error_Msg()
--  191126  RAKUSE  Added Add_To_String_List, Add_To_Sorted_String_List,
--                  Remove_From_String_List, Remove_From_Sorted_String_List (TEAURENAFW-1155).
-----------------------------------------------------------------------------
--
--  Dependencies: None!
--
--  Contents:     Public methods for user security task
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE STRING_TABLE IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;
TYPE NUMBER_TABLE IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Between_Clob (
   string_    IN CLOB,
   start_in_  IN INTEGER,
   end_in_    IN INTEGER,
   inclusive_ IN BOOLEAN := TRUE ) RETURN CLOB 
IS
   start_      INTEGER := start_in_;
   numchars_   INTEGER := Abs(end_in_) - Abs(start_in_) + 1;
BEGIN
   IF (string_ IS NULL OR
       Nvl(start_in_, 0) = 0 OR
       (start_in_ < 0 AND end_in_ > 0) OR
       (start_in_ > 0 AND end_in_ < 0) OR
       (start_in_ < 0 AND end_in_ > start_in_) OR
       (start_in_ > 0 AND end_in_ < start_in_)) THEN
   -- replaced with above four lines. Abs(start_in_) > Abs(end_in_)
      RETURN NULL;
   ELSE
      IF start_ < 0 THEN
         start_ := end_in_;
      ELSE
         start_ := start_in_;
      END IF;

      IF NOT Nvl(inclusive_, FALSE) THEN
         start_    := start_ + 1;
         numchars_ := numchars_ - 2;
      END IF;

      IF (start_ > end_in_ OR numchars_ < 1) THEN
         RETURN(NULL);
      ELSE
         RETURN(Substr(string_, start_, numchars_));
      END IF;
   END IF;
END Between_Clob;


@UncheckedAccess
FUNCTION Between_Str (
   string_    IN VARCHAR2,
   start_in_  IN INTEGER,
   end_in_    IN INTEGER,
   inclusive_ IN BOOLEAN := TRUE ) RETURN VARCHAR2
IS
   start_      INTEGER := start_in_;
   numchars_   INTEGER := Abs(end_in_) - Abs(start_in_) + 1;
BEGIN
   IF (string_ IS NULL OR
       Nvl(start_in_, 0) = 0 OR
       (start_in_ < 0 AND end_in_ > 0) OR
       (start_in_ > 0 AND end_in_ < 0) OR
       (start_in_ < 0 AND end_in_ > start_in_) OR
       (start_in_ > 0 AND end_in_ < start_in_)) THEN
   -- replaced with above four lines. Abs(start_in_) > Abs(end_in_)
      RETURN NULL;
   ELSE
      IF start_ < 0 THEN
         start_ := end_in_;
      ELSE
         start_ := start_in_;
      END IF;

      IF NOT Nvl(inclusive_, FALSE) THEN
         start_    := start_ + 1;
         numchars_ := numchars_ - 2;
      END IF;

      IF (start_ > end_in_ OR numchars_ < 1) THEN
         RETURN(NULL);
      ELSE
         RETURN(Substr(string_, start_, numchars_));
      END IF;
   END IF;
END Between_Str;


@UncheckedAccess
FUNCTION Between_Clob (
    string_       IN CLOB,
    start_in_     IN VARCHAR2,
    end_in_       IN VARCHAR2 := NULL,
    startnth_in_  IN INTEGER := 1,
    endnth_in_    IN INTEGER := 1,
    inclusive_    IN BOOLEAN := TRUE,
    gotoend_      IN BOOLEAN := FALSE ) RETURN CLOB
IS
   start_   BINARY_INTEGER;
   end_     BINARY_INTEGER;
BEGIN
   IF (string_ IS NULL OR start_in_ IS NULL OR end_in_ IS NULL OR startnth_in_ < 0 OR endnth_in_ < 1) THEN
      RETURN NULL;
   ELSE
      IF startnth_in_ = 0 THEN
         start_ := 1;
         end_ := Instr(string_, Nvl(end_in_, start_in_), 1, endnth_in_);
      ELSE
         start_ := Instr(string_, start_in_, 1, startnth_in_);
         end_   := Instr(string_, Nvl(end_in_, start_in_), start_ + 1, endnth_in_);
      END IF;

      IF start_ = 0   /* No starting text found, so nothing to return. */ THEN
         RETURN NULL;
      ELSE
         IF NOT inclusive_ THEN
            IF startnth_in_ > 0
            THEN
               start_ := start_ + Length(start_in_);
            END IF;
            end_ := end_ - 1;
         ELSE
            end_ := end_ + Length(end_in_) - 1;
         END IF;

         IF (start_ = 0 OR
             (start_ > end_ AND end_ > 0) OR
             (end_ <= 0 AND NOT Nvl(gotoend_, FALSE))) THEN
            RETURN NULL;
         ELSE
            IF end_ <= 0 THEN
               end_ := Length(string_);
            END IF;
            RETURN Between_Clob(string_, start_, end_);
         END IF;
      END IF;
   END IF;
END Between_Clob;


@UncheckedAccess
FUNCTION Between_Str (
    string_       IN VARCHAR2,
    start_in_     IN VARCHAR2,
    end_in_       IN VARCHAR2 := NULL,
    startnth_in_  IN INTEGER := 1,
    endnth_in_    IN INTEGER := 1,
    inclusive_    IN BOOLEAN := TRUE,
    gotoend_      IN BOOLEAN := FALSE ) RETURN VARCHAR2
IS
   start_   BINARY_INTEGER;
   end_     BINARY_INTEGER;
BEGIN
   IF (string_ IS NULL OR start_in_ IS NULL OR end_in_ IS NULL OR startnth_in_ < 0 OR endnth_in_ < 1) THEN
      RETURN NULL;
   ELSE
      IF startnth_in_ = 0 THEN
         start_ := 1;
         end_ := Instr(string_, Nvl(end_in_, start_in_), 1, endnth_in_);
      ELSE
         start_ := Instr(string_, start_in_, 1, startnth_in_);
         end_   := Instr(string_, Nvl(end_in_, start_in_), start_ + 1, endnth_in_);
      END IF;

      IF start_ = 0   /* No starting text found, so nothing to return. */ THEN
         RETURN NULL;
      ELSE
         IF NOT inclusive_ THEN
            IF startnth_in_ > 0
            THEN
               start_ := start_ + Length(start_in_);
            END IF;
            end_ := end_ - 1;
         ELSE
            end_ := end_ + Length(end_in_) - 1;
         END IF;

         IF (start_ = 0 OR
             (start_ > end_ AND end_ > 0) OR
             (end_ <= 0 AND NOT Nvl(gotoend_, FALSE))) THEN
            RETURN NULL;
         ELSE
            IF end_ <= 0 THEN
               end_ := Length(string_);
            END IF;
            RETURN Between_Str(string_, start_, end_);
         END IF;
      END IF;
   END IF;
END Between_Str;


@UncheckedAccess
FUNCTION Between_Clob (
    string_       IN CLOB,
    start_in_     IN VARCHAR2,
    end_in_       IN VARCHAR2,
    inclusive_    IN VARCHAR2 ) RETURN CLOB
IS
   inc_   BOOLEAN;
BEGIN
   IF (inclusive_ = 'TRUE') THEN 
      inc_ := TRUE;
   ELSE
      inc_ := FALSE;
   END IF;
   RETURN(Between_Clob(string_, start_in_, end_in_, inclusive_ => inc_));
END Between_Clob;


@UncheckedAccess
FUNCTION Between_Str (
    string_       IN VARCHAR2,
    start_in_     IN VARCHAR2,
    end_in_       IN VARCHAR2,
    inclusive_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   inc_   BOOLEAN;
BEGIN
   IF (inclusive_ = 'TRUE') THEN 
      inc_ := TRUE;
   ELSE
      inc_ := FALSE;
   END IF;
   RETURN(Between_Str(string_, start_in_, end_in_, inclusive_ => inc_));
END Between_Str;


-- Get_Owner
--   Retrieve the Oracle owner of the Foundation instance
@UncheckedAccess
FUNCTION Get_Owner RETURN VARCHAR2
IS
BEGIN
   RETURN(Fnd_Session_API.Get_App_Owner);
END Get_Owner;


@UncheckedAccess
PROCEDURE Debug_Call_Stack (
   method_name_   IN VARCHAR2 DEFAULT NULL )
IS 
   depth_ PLS_INTEGER;
   PROCEDURE Print_Headers___ IS
   BEGIN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, '------------------------------');
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Method :'||nvl(method_name_, 'Unknown'));
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, '------------------------------');
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Lexical   Depth   Line    Name');
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Depth             Number      ');
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, '-------   -----   ----    ----');
   END Print_Headers___;
   PROCEDURE Print_Debug___ IS
   BEGIN
      FOR j IN REVERSE 1 .. depth_+1 LOOP
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, rpad(nvl(utl_call_stack.lexical_depth(j),0), 10) || rpad(j, 7) || rpad(To_Char(UTL_Call_Stack.Unit_Line(j), '99'), 9) ||
                                            Utl_Call_Stack.Concatenate_Subprogram(Utl_Call_Stack.Subprogram(j)));
      END LOOP;
   END Print_Debug___;
BEGIN
   depth_ := UTL_Call_Stack.Dynamic_Depth;
   Print_Headers___;
   Print_Debug___;
END Debug_Call_Stack;

-- Get_User
--   Retrieve the intended current Oracle user
@UncheckedAccess
FUNCTION Get_User RETURN VARCHAR2
IS
BEGIN
   RETURN(Fnd_Session_API.Get_Fnd_User);
END Get_User;


-- Set_User
--   Set the intended current Oracle user
@UncheckedAccess
PROCEDURE Set_User (
   user_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General( service_, 'SET_USER: This is a deprecated method, use Fnd_Session_API.Impersonate_Fnd_User instead.' );
END Set_User;


@UncheckedAccess
FUNCTION String_To_Number (
   string_ VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN TO_NUMBER(string_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN to_number(NULL);
END String_To_Number;

@UncheckedAccess
FUNCTION String_To_Boolean (
   string_ VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN
      CASE UPPER (string_)
        WHEN 'TRUE' THEN TRUE
        WHEN 'FALSE' THEN FALSE
        ELSE NULL
      END;
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END String_To_Boolean;

@UncheckedAccess
PROCEDURE Tokenize (
   string_       IN  VARCHAR2,
   delimiter_    IN  VARCHAR2,
   output_table_ OUT STRING_TABLE,
   token_count_  OUT NUMBER)
IS
   pos_              NUMBER;
   start_            NUMBER;
   length_           NUMBER;
   delimiter_length_ NUMBER;
BEGIN
   token_count_ := 0;

   IF (string_ IS NULL) THEN
      RETURN;
   END IF;

   length_ := LENGTH(string_);

   delimiter_length_ := NVL(LENGTH(delimiter_),0);
   start_  := 1;
   LOOP
      pos_ := NVL(INSTR(string_, delimiter_, start_),0);

      IF (pos_ = 0) THEN
         pos_ := length_ + 1;
      END IF;

      IF (start_ <> pos_) THEN
         token_count_ := token_count_ + 1;
         output_table_(token_count_) := SUBSTR(string_, start_, pos_-start_);
      END IF;

      start_ := pos_ + delimiter_length_;

      EXIT WHEN start_ > length_;
   END LOOP;
END Tokenize;

@UncheckedAccess
PROCEDURE Tokenize (
   string_       IN  CLOB,
   delimiter_    IN  VARCHAR2,
   output_table_ OUT STRING_TABLE,
   token_count_  OUT NUMBER )
IS
   pos_              NUMBER;
   start_            NUMBER;
   length_           NUMBER;
   delimiter_length_ NUMBER;
BEGIN
   token_count_ := 0;

   IF (string_ IS NULL OR string_ = empty_clob()) THEN
      RETURN;
   END IF;

   length_ := Dbms_Lob.GetLength(string_);

   IF (length_ <= 32767) THEN
      Tokenize(TO_CHAR(string_), delimiter_, output_table_, token_count_);
   ELSE
      delimiter_length_ := NVL(LENGTH(delimiter_),0);
      start_ := 1;
      LOOP
         pos_ := NVL(Dbms_Lob.Instr(string_, delimiter_, start_),0);

         IF (pos_ = 0) THEN
            pos_ := length_ + 1;
         END IF;

         IF (start_ <> pos_) THEN
            token_count_ := token_count_ + 1;
            output_table_(token_count_) := Dbms_Lob.Substr(string_, pos_-start_, start_);
         END IF;

         start_ := pos_ + delimiter_length_;

         EXIT WHEN start_ > length_;
      END LOOP;
   END IF;
END Tokenize;

@UncheckedAccess
PROCEDURE Tokenize (
   string_       IN  VARCHAR2,
   delimiter_    IN  VARCHAR2,
   output_table_ OUT NUMBER_TABLE,
   token_count_  OUT NUMBER )
IS
   pos_              NUMBER;
   start_            NUMBER;
   length_           NUMBER;
   delimiter_length_ NUMBER;
BEGIN
   token_count_ := 0;

   IF (string_ IS NULL) THEN
      RETURN;
   END IF;

   length_ := LENGTH(string_);

   delimiter_length_ := NVL(LENGTH(delimiter_),0);
   start_  := 1;
   LOOP
      pos_ := NVL(INSTR(string_, delimiter_, start_),0);

      IF (pos_ = 0) THEN
         pos_ := length_ + 1;
      END IF;

      IF (start_ <> pos_) THEN
         token_count_ := token_count_ + 1;
         output_table_(token_count_) := TO_NUMBER(SUBSTR(string_, start_, pos_-start_));
      END IF;

      start_ := pos_ + delimiter_length_;

      EXIT WHEN start_ > length_;
   END LOOP;
END Tokenize;

@UncheckedAccess
PROCEDURE Tokenize (
   string_       IN  CLOB,
   delimiter_    IN  VARCHAR2,
   output_table_ OUT NUMBER_TABLE,
   token_count_  OUT NUMBER )
IS
   pos_              NUMBER;
   start_            NUMBER;
   length_           NUMBER;
   delimiter_length_ NUMBER;
BEGIN
   token_count_ := 0;

   IF (string_ IS NULL OR string_ = empty_clob()) THEN
      RETURN;
   END IF;

   length_ := Dbms_Lob.GetLength(string_);

   IF (length_ <= 32767) THEN
      Tokenize(TO_CHAR(string_), delimiter_, output_table_, token_count_);
   ELSE
      delimiter_length_ := NVL(LENGTH(delimiter_),0);
      start_  := 1;
      LOOP
         pos_ := NVL(Dbms_Lob.Instr(string_, delimiter_, start_),0);

         IF (pos_ = 0) THEN
            pos_ := length_ + 1;
         END IF;

         IF (start_ <> pos_) THEN
            token_count_ := token_count_ + 1;
            output_table_(token_count_) := TO_NUMBER(Dbms_Lob.Substr(string_, pos_-start_, start_));
         END IF;

         start_ := pos_ + delimiter_length_;

         EXIT WHEN start_ > length_;
      END LOOP;
   END IF;
END Tokenize;

FUNCTION Describe_Sql_Statement (
   sql_stmnt_ IN VARCHAR2) RETURN VARCHAR2
IS
   c_             NUMBER;
   col_cnt_       INTEGER;
   col_num_       INTEGER;
   rec_tab_       Dbms_Sql.Desc_Tab2;
   msg_           VARCHAR2(32000) := Message_SYS.Construct('UTILITY_SYS');
   stmt_          VARCHAR2(32000) := sql_stmnt_;
   datatype_      VARCHAR2(30);
   app_owner_     VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;

BEGIN
   General_SYS.Check_Security(service_, 'UTILITY_SYS', 'Describe_Sql_Statement');
   IF stmt_ IS NULL THEN
      RETURN(NULL);
   ELSE
      -- Replace Appowner and IAL owner
      stmt_ := REPLACE(Upper(stmt_), chr(38)||'AO.',       app_owner_);
      stmt_ := REPLACE(Upper(stmt_), chr(38)||'APPOWNER.', app_owner_);
      stmt_ := REPLACE(Upper(stmt_), chr(38)||'IAL.',      Fnd_Setting_API.Get_Value('IAL_USER'));
   END IF;

   Assert_SYS.Assert_Match_Regexp( UPPER(stmt_), '^SELECT(\s'||'|'||chr(13)||'|'||chr(10)||').*' );

   c_ := Dbms_Sql.Open_Cursor;

   -- Statement is never executed, hence any DML is safe, DDL is unsafe.
   -- Secured using Match_Regexp which only allows SELECT DML. 
   @ApproveDynamicStatement(2007-07-24,pemase)
   Dbms_Sql.Parse(c_, stmt_, dbms_sql.native);

   Dbms_Sql.Describe_Columns2(c_, col_cnt_, rec_tab_);
   col_num_ := rec_tab_.first;

   WHILE (col_num_ IS NOT NULL) LOOP
      IF (rec_tab_(col_num_).col_type IN ('1', '9', '96')) THEN
         datatype_ := 'STRING';
      ELSIF (rec_tab_(col_num_).col_type IN ('2', '3')) THEN
         datatype_ := 'NUMBER';
      ELSIF (rec_tab_(col_num_).col_type IN ('12')) THEN
         datatype_ := 'DATE';
      ELSIF (rec_tab_(col_num_).col_type IN ('11', '69')) THEN
         datatype_ := 'ROWID';
      ELSIF (rec_tab_(col_num_).col_type IN ('112')) THEN
         datatype_ := 'CLOB';
      ELSIF (rec_tab_(col_num_).col_type IN ('113')) THEN
         datatype_ := 'BLOB';
      ELSIF (rec_tab_(col_num_).col_type IN ('8')) THEN
         datatype_ := 'LONG';
      ELSE
         datatype_ := 'OTHER';
      END IF;
      Message_SYS.Add_Attribute(msg_, rec_tab_(col_num_).col_name, datatype_);
      col_num_ := rec_tab_.next(col_num_);
   END LOOP ;
   Dbms_Sql.Close_Cursor(c_);
   RETURN(msg_);
EXCEPTION
   WHEN OTHERS THEN
      IF Dbms_Sql.Is_Open(c_) THEN
         Dbms_Sql.Close_Cursor(c_);
      END IF;
      RAISE;   
END Describe_Sql_Statement;

@UncheckedAccess
FUNCTION Get_Min_Date RETURN DATE
IS
BEGIN
   RETURN to_date(1,'J');
END Get_Min_Date;
PROCEDURE Append_Text_Line(
   text_             IN OUT VARCHAR2,
   text_line_        IN VARCHAR2,
   extra_line_break_ IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   IF (text_ IS NULL) THEN
      text_ := text_line_;
   ELSIF extra_line_break_ THEN
      text_ := text_ || chr(13) || chr(10) || chr(13)|| chr(10) || text_line_;
   ELSE
      text_ := text_ || chr(13) || chr(10) || text_line_;
   END IF;
END Append_Text_Line;



@UncheckedAccess
FUNCTION Get_Max_Date RETURN DATE
IS
BEGIN
   RETURN to_date('9999','yyyy');
END Get_Max_Date;
PROCEDURE Append_Text_Line(
   text_             IN OUT NOCOPY CLOB,
   text_line_        IN VARCHAR2,
   extra_line_break_ IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   IF (text_ IS NULL) THEN
      text_ := to_clob(text_line_);
   ELSIF extra_line_break_ THEN
      dbms_lob.append(text_, to_clob(chr(13) || chr(10) || chr(13)|| chr(10) || text_line_));
   ELSE
      dbms_lob.append(text_, to_clob(chr(13) || chr(10) || text_line_));
   END IF;
END Append_Text_Line; 

FUNCTION Set_Windows_New_Line (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_       VARCHAR2(32000);
   cnt_        NUMBER := 0;
   in_char_    CHAR(1);
   in_length_  NUMBER;
BEGIN
  in_length_ := length(value_);
  WHILE (cnt_ < in_length_)
  LOOP
    cnt_ := cnt_ + 1;
    in_char_ := substr(value_, cnt_, 1);
    IF in_char_ = chr(10) AND substr(value_, cnt_-1, 1) <> chr(13) THEN   -- single occurence of chr(10)     
      temp_ :=  temp_ ||  chr(13) || chr(10);   
    ELSE
      temp_ := temp_ || in_char_;
    END IF;       
 END LOOP;
 RETURN temp_;
END Set_Windows_New_Line;

PROCEDURE Add_XML_Element_Before(
   xml_      IN OUT xmltype,
   xmlelement_ IN XMLType,
   add_before_xpath_ IN VARCHAR2)
IS
   expression_ CLOB;
BEGIN
   expression_ := 'copy $tmp := . modify insert node $new before $tmp'||add_before_xpath_||' return $tmp';
   --Log_SYS.App_Trace(Log_SYS.debug_, expression_);
   SELECT XMLQuery(expression_  PASSING xml_ , xmlelement_ as "new"  RETURNING CONTENT)
   INTO xml_
   FROM dual;
END Add_XML_Element_Before;

PROCEDURE Add_XML_Element_Before(
   xml_      IN OUT xmltype,
   element_name_ IN VARCHAR2,
   element_data_ IN VARCHAR2,
   add_before_xpath_ IN VARCHAR2)
IS
   xmlelement_ XMLType;
BEGIN
   SELECT xmlelement(EVALNAME(element_name_), element_data_)
   INTO xmlelement_
   FROM dual;
   Add_XML_Element_Before(xml_, xmlelement_, add_before_xpath_);
END Add_XML_Element_Before;

PROCEDURE Add_XML_Element_After(
   xml_      IN OUT xmltype,
   xmlelement_ IN XMLType,
   add_after_xpath_ IN VARCHAR2)
IS
   expression_ CLOB;
BEGIN
   expression_ := 'copy $tmp := . modify insert node $new after $tmp'||add_after_xpath_||' return $tmp';
   --Log_SYS.App_Trace(Log_SYS.debug_, expression_);
   --Log_SYS.App_Trace(Log_SYS.debug_, xml_.getStringval());
   SELECT XMLQuery(expression_  PASSING xml_ , xmlelement_ as "new"  RETURNING CONTENT)
   INTO xml_
   FROM dual;
END Add_XML_Element_After;

PROCEDURE Add_XML_Element_Into(
   xml_      IN OUT xmltype,
   xmlelement_ IN XMLType,
   add_after_xpath_ IN VARCHAR2)
IS
   expression_ CLOB;
BEGIN
   expression_ := 'copy $tmp := . modify insert node $new into $tmp'||add_after_xpath_||' return $tmp';
   --Log_SYS.App_Trace(Log_SYS.debug_, expression_);
   --Log_SYS.App_Trace(Log_SYS.debug_, xml_.getStringval());
   SELECT XMLQuery(expression_  PASSING xml_ , xmlelement_ as "new"  RETURNING CONTENT)
   INTO xml_
   FROM dual;
END Add_XML_Element_Into;

PROCEDURE Add_XML_Element_After(
   xml_      IN OUT xmltype,
   element_name_ IN VARCHAR2,
   element_data_ IN VARCHAR2,
   add_after_xpath_ IN VARCHAR2)
IS
   xmlelement_ XMLType;
BEGIN
   SELECT xmlelement(EVALNAME(element_name_), element_data_)
   INTO xmlelement_
   FROM dual;
   Add_XML_Element_After(xml_, xmlelement_, add_after_xpath_);
END Add_XML_Element_After;

PROCEDURE XMLType_To_CLOB(
   out_xml_  OUT CLOB,
   xml_      xmltype )
IS
BEGIN
   SELECT XMLSERIALIZE(CONTENT xml_ version '1.0' indent) INTO out_xml_
   FROM dual;
   out_xml_ := REPLACE(out_xml_,chr(10), chr(13)||chr(10));
END XMLType_To_CLOB;


PROCEDURE Convert_Blob_To_Base64(
   clob_result_  IN OUT NOCOPY CLOB,
   blob_val_     IN BLOB)
IS
   l_length_ NUMBER;
   l_buffer_ CLOB;
   l_step_   NUMBER := 3*1024;
   l_converted_text_ VARCHAR2(32767);
BEGIN
   IF (blob_val_ IS NULL OR NVL(Dbms_Lob.GetLength(blob_val_),0) = 0) THEN
      clob_result_ := empty_clob();
      RETURN;
   END IF;      
   l_length_ := Dbms_lob.getlength(blob_val_);
   dbms_lob.createtemporary(l_buffer_, TRUE, dbms_lob.call); 

   FOR i_ IN 0 .. (trunc((l_length_ - 1 )/l_step_)) LOOP
     l_converted_text_ := utl_raw.cast_to_varchar2(utl_encode.base64_encode(dbms_lob.substr(blob_val_, l_step_, i_ * l_step_ + 1)));
     dbms_lob.writeappend(l_buffer_, length(l_converted_text_), l_converted_text_);
   END LOOP; 
   
   IF clob_result_ IS NULL THEN
      dbms_lob.createtemporary(clob_result_, TRUE, dbms_lob.call); 
   END IF;
   dbms_lob.append(clob_result_, l_buffer_);
   dbms_lob.freetemporary(l_buffer_);         
END Convert_Blob_To_Base64;

FUNCTION Pascal_To_Underscore (
   string_ IN VARCHAR2) RETURN VARCHAR2 
IS
   pascal_pattern_ VARCHAR2(20) := '([^_])([A-Z])';
   replacement_string_ VARCHAR2(20) := '\1_\2';
BEGIN 
   IF string_ IS NULL THEN
      RETURN NULL;
   ELSE
      -- replace using the same pattern twice to make sure adjacent capital letters will have underscore between.
      RETURN REGEXP_REPLACE(REGEXP_REPLACE(string_,pascal_pattern_,replacement_string_),pascal_pattern_,replacement_string_);
   END IF;
END Pascal_To_Underscore;

FUNCTION Clob_To_Blob(
   clob_ CLOB) RETURN BLOB
IS
   blob_ BLOB;
   dest_offset_ NUMBER;
   src_offset_ NUMBER;
   lang_context_ NUMBER;
   warning_ NUMBER; 
BEGIN
   dest_offset_ := 1;
   src_offset_ := 1;
   lang_context_ := 0;
   dbms_lob.createtemporary(blob_, TRUE);
   dbms_lob.convertToBlob(blob_, clob_, dbms_lob.getlength(clob_), dest_offset_, src_offset_, 0, lang_context_, warning_);
   RETURN blob_;
END Clob_To_Blob;

FUNCTION Blob_To_Clob(
   blob_ IN BLOB) RETURN CLOB
IS
  clob_    CLOB;
  varchar_ VARCHAR2(32767);
  start_   PLS_INTEGER := 1;
  buffer_  PLS_INTEGER := 32767; 
   
BEGIN
   DBMS_LOB.CREATETEMPORARY(clob_, TRUE);

   FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(blob_) / buffer_) LOOP
      varchar_ := UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(blob_, buffer_, start_));
      DBMS_LOB.WRITEAPPEND(clob_, LENGTH(varchar_), varchar_);
      start_ := start_ + buffer_;
   END LOOP;
   RETURN clob_;
END Blob_To_Clob;

FUNCTION Convert_Base64_Clob_To_Blob(
   clob_value_ IN CLOB) RETURN BLOB
IS
  blob_value_ BLOB;
  raw_        RAW(32767);
  buffer_  PLS_INTEGER := 32767;
  start_   PLS_INTEGER := 1;
BEGIN
   DBMS_LOB.createtemporary (blob_value_, FALSE, DBMS_LOB.CALL);

   FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(clob_value_) / buffer_) LOOP
      raw_    := UTL_ENCODE.base64_decode(UTL_RAW.cast_to_raw(DBMS_LOB.SUBSTR(clob_value_, buffer_, start_)));
      DBMS_LOB.append (blob_value_, TO_BLOB(raw_));
      start_ := start_ + buffer_;
   END LOOP;
  RETURN blob_value_;
END Convert_Base64_Clob_To_Blob;

@UncheckedAccess
FUNCTION Get_Constraint_From_Error_Msg (
    error_msg_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   start_ NUMBER;
BEGIN
   start_ := instr(error_msg_, Fnd_Session_API.Get_App_Owner) + Length(Fnd_Session_API.Get_App_Owner);
   RETURN Between_Str(error_msg_, start_,  instr(error_msg_, ')', start_), FALSE);
END Get_Constraint_From_Error_Msg;

@UncheckedAccess
FUNCTION Add_To_String_List (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Add_To_String_List___(list_, text_, separator_, FALSE);
END Add_To_String_List;

@UncheckedAccess
FUNCTION Add_To_Sorted_String_List (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Add_To_String_List___(list_, text_, separator_, TRUE);
END Add_To_Sorted_String_List;

FUNCTION Add_To_String_List___ (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2,
   sorted_    IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
   pattern_ VARCHAR2(200) := '[^' || separator_ || ']+';
   temp_    VARCHAR2(4000) := list_ || text_ || separator_;

   result_  VARCHAR2(4000);
   table_   STRING_TABLE;
   ind_     PLS_INTEGER;
   
   CURSOR tokens IS     
      SELECT DISTINCT regexp_substr(temp_, pattern_, 1, level) FROM DUAL
      CONNECT BY regexp_substr(temp_, pattern_, 1, level) IS NOT NULL;
      
   CURSOR sorted_tokens IS
      SELECT DISTINCT regexp_substr(temp_, pattern_, 1, level) FROM DUAL
      CONNECT BY regexp_substr(temp_, pattern_, 1, level) IS NOT NULL
      ORDER BY 1;      
BEGIN
   IF (sorted_) THEN
      OPEN sorted_tokens;
      FETCH sorted_tokens BULK COLLECT INTO table_;
      CLOSE sorted_tokens;      
   ELSE
      OPEN tokens;
      FETCH tokens BULK COLLECT INTO table_;
      CLOSE tokens;      
   END IF;
   
   ind_  := table_.FIRST;
   WHILE (ind_ IS NOT NULL) LOOP
--      DBMS_OUTPUT.Put_Line(table_(ind_));
      result_ := result_ || table_(ind_) || separator_;
      ind_ := table_.NEXT(ind_);      
   END LOOP;
      
   RETURN result_;
END Add_To_String_List___;

@UncheckedAccess
FUNCTION Remove_From_String_List (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
  RETURN Remove_From_String_List___(list_, text_, separator_, FALSE);
END Remove_From_String_List;

@UncheckedAccess
FUNCTION Remove_From_Sorted_String_List (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
  RETURN Remove_From_String_List___(list_, text_, separator_, TRUE);
END Remove_From_Sorted_String_List;

FUNCTION Remove_From_String_List___ (
   list_      IN VARCHAR2,
   text_      IN VARCHAR2,
   separator_ IN VARCHAR2,
   sorted_    IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
   pattern_ VARCHAR2(200) := '[^' || separator_ || ']+';

   result_ VARCHAR2(4000);
   table_  STRING_TABLE;
   ind_    PLS_INTEGER;
   
   CURSOR tokens IS     
      SELECT DISTINCT regexp_substr(list_, pattern_, 1, level) FROM DUAL
      CONNECT BY regexp_substr(list_, pattern_, 1, level) IS NOT NULL;
      
   CURSOR sorted_tokens IS
      SELECT DISTINCT regexp_substr(list_, pattern_, 1, level) FROM DUAL
      CONNECT BY regexp_substr(list_, pattern_, 1, level) IS NOT NULL
      ORDER BY 1;
BEGIN
   IF (sorted_) THEN
      OPEN sorted_tokens;
      FETCH sorted_tokens BULK COLLECT INTO table_;
      CLOSE sorted_tokens;      
   ELSE
      OPEN tokens;
      FETCH tokens BULK COLLECT INTO table_;
      CLOSE tokens;      
   END IF;
   
   ind_  := table_.FIRST;
   WHILE (ind_ IS NOT NULL) LOOP
--      DBMS_OUTPUT.Put_Line(table_(indx));
      IF (table_(ind_) != text_) THEN
         result_ := result_ || table_(ind_) || separator_;         
      END IF;      
      ind_ := table_.NEXT(ind_);      
   END LOOP;
      
   RETURN result_;
END Remove_From_String_List___;