-----------------------------------------------------------------------------
--
--  Logical unit: Message
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960731  MADR    Created for IFS Foundation (Idea #758).
--  960827  MADR    Added comments.
--  960916  ERFO    Added global service_.
--  960930  MADR    New variants of Add, Get and Find methods
--  961023  MADR    New Get-method for retrieving multi-line attributes
--  970612  MADR    Added methods for modifying messages
--  970729  ERFO    Change global date_format_ to reference Client_SYS.
--  970730  MADR    Added new method Get_Name
--  970821  MADR    Remove trailing new-lines in Find_Attribute___
--                  Get_Attributes and Remove_Attribute
--  021023  HAAR    Added function Is_Message (needed in ToDo#4146).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030527  ROOD    Changed date conversion in Set_Attribute (Bug#37414).
--  101102  HAAR    Added Add_Attribute for CLOB.
--  200303  RAKUSE  Added Get_Attr_From_Message (TEAURENAFW-264).
-----------------------------------------------------------------------------
--
--  Dependencies: Error_SYS
--                Client_SYS
--
--  Contents:     Methods for creating new messages and for retrieving
--                information from existing messages
--
-----------------------------------------------------------------------------
--
--  Description:  A message contains a header (message name) and a set of attributes.
--                An attribute has a name (uppercase identifier, max 30 characters)
--                and a string value (one or many lines of visible characters).
--                A value can contain another message, so messages can be nested.
--                The length of a message is limited to 32K.
--
--  Example:      DECLARE
--                   msg_ VARCHAR2(200);
--                BEGIN
--                   msg_ := Message_SYS.Construct('TEXTMESSAGE');
--                   Message_SYS.Add_Attribute( msg_, 'TEXT', 'Some text' );
--                   Command_SYS.Socket_Message( 'MADR,DAJO', msg_ );
--                END
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE name_table IS TABLE OF VARCHAR2(1000)  INDEX BY BINARY_INTEGER;
TYPE line_table IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE name_table_clob IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE line_table_clob IS TABLE OF CLOB INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

new_line_            CONSTANT VARCHAR2(1)  := CHR(10);
head_marker_         CONSTANT VARCHAR2(1)  := '!';
segment_marker_      CONSTANT VARCHAR2(1)  := '#';
attribute_marker_    CONSTANT VARCHAR2(1)  := '$';
value_marker_        CONSTANT VARCHAR2(1)  := '=';
continuation_marker_ CONSTANT VARCHAR2(1)  := '-';
auto_head_name_      CONSTANT VARCHAR2(4)  := 'AUTO';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Attribute_Not_Found___ (
   message_  IN VARCHAR2,
   name_     IN VARCHAR2 )
IS
   msg_ VARCHAR2(100);
   len_ CONSTANT INTEGER := 40;
BEGIN
   IF length(message_)<=len_ THEN
      msg_ := message_;
   ELSE
      msg_ := substr(message_,1,len_-3) || '...';
   END IF;
   Error_SYS.Appl_General(service_, 'ATTRNOTFOUND: ' ||
      'Attribute ":P1" does not exist in message ":P2"', name_, msg_);
END Attribute_Not_Found___;


FUNCTION Find_Attribute___ (
   message_       IN  VARCHAR2,
   name_          IN  VARCHAR2,
   value_         OUT VARCHAR2 ) RETURN BOOLEAN
IS
   p1_  NUMBER;
   p2_  NUMBER;
   p3_  NUMBER;
   msg_ VARCHAR2(32000) := replace(message_, chr(13));
BEGIN
   p1_ := instr(msg_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ >= 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := instr(msg_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := length(msg_);
         IF substr(msg_, p3_, 1) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         value_ := replace(rtrim(substr(msg_, p2_, p3_-p2_+1),new_line_),
                           new_line_||continuation_marker_,
                           new_line_);
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Find_Attribute___;


FUNCTION Find_Attribute___ (
   message_       IN         CLOB,
   name_          IN         VARCHAR2,
   value_         OUT NOCOPY VARCHAR2 ) RETURN BOOLEAN
IS
   p1_  NUMBER;
   p2_  NUMBER;
   p3_  NUMBER;
   msg_ CLOB;
BEGIN
   IF (Dbms_Lob.Instr(message_, chr(13)) > 0) THEN
      msg_ := replace(message_, chr(13));
   ELSE
      msg_ := message_;
   END IF;
   p1_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ >= 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := Dbms_Lob.Getlength(msg_);
         IF Dbms_Lob.Substr(msg_, 1, p3_) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         value_ := replace(rtrim(Dbms_Lob.Substr(msg_, p3_-p2_+1, p2_),new_line_),
                           new_line_||continuation_marker_,
                           new_line_);
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Find_Attribute___;


FUNCTION Find_Attribute___ (
   message_       IN         CLOB,
   name_          IN         VARCHAR2,
   value_         OUT NOCOPY CLOB ) RETURN BOOLEAN
IS
   p1_  NUMBER;
   p2_  NUMBER;
   p3_  NUMBER;
   msg_ CLOB;
BEGIN
   IF (Dbms_Lob.Instr(message_, chr(13)) > 0) THEN
      msg_ := replace(message_, chr(13));
   ELSE
      msg_ := message_;
   END IF;
   p1_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ >= 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := Dbms_Lob.Getlength(msg_);
         IF Dbms_Lob.Substr(msg_, 1, p3_) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         value_ := replace(rtrim(substr(msg_, p2_, p3_-p2_+1),new_line_),
                           new_line_||continuation_marker_,
                           new_line_);
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Find_Attribute___;

FUNCTION Message_Clob_To_Json___(
   msg_  IN CLOB,
   include_header_ IN BOOLEAN) RETURN CLOB
IS
   count_  NUMBER;
   names_  name_table_clob;
   values_ line_table_clob;
   
   json_msg_          JSON_OBJECT_T;
   json_msg_w_header_ JSON_OBJECT_T;
   json_array_        JSON_ARRAY_T;
   temp_json_object_  JSON_OBJECT_T;
   
   temp_string_val_ CLOB;
   value_           CLOB;
   value_is_json_   BOOLEAN := FALSE;
   header_          VARCHAR2(32000);
BEGIN
   Get_Clob_Attributes(msg_, count_, names_, values_);
   header_ := Get_Name(msg_);
   
   json_msg_ := JSON_OBJECT_T('{}');
   
   FOR i_ IN 1..count_ LOOP
      IF Is_Message(values_(i_)) THEN
         value_is_json_ := TRUE;
         value_ := Message_Clob_To_Json___(values_(i_), include_header_);
      ELSE
         value_is_json_ := FALSE;
         value_ := values_(i_);
      END IF;
      
      IF json_msg_.has(names_(i_)) THEN
         IF json_msg_.get_Type(names_(i_)) = 'SCALAR' THEN
            temp_string_val_ := json_msg_.get_clob(names_(i_));
            json_array_ := JSON_ARRAY_T('[]');
            json_array_.append(temp_string_val_);
         ELSIF json_msg_.get_Type(names_(i_)) = 'ARRAY' THEN
            json_array_ := json_msg_.get_array(names_(i_));
         ELSIF json_msg_.get_Type(names_(i_)) = 'OBJECT' THEN
            temp_json_object_ := json_msg_.get_object(names_(i_));
            json_array_ := JSON_ARRAY_T('[]');
            json_array_.append(temp_json_object_);       
         ELSE
            Error_SYS.Appl_General(lu_name_, 'UNEXP_STRUCT: Error in converting IFS Message to JSON. Value of :P1 is not as expected.', names_(i_));
         END IF;
         
         IF value_is_json_ THEN
            json_array_.append(JSON_OBJECT_T(value_));
         ELSE
            json_array_.append(value_);
         END IF;
         json_msg_.put(names_(i_), json_array_);
      ELSE
         IF value_is_json_ THEN
            json_msg_.put(names_(i_), JSON_OBJECT_T(value_));
         ELSE
            json_msg_.put(names_(i_), value_);
         END IF;
      END IF;
   END LOOP;
   
   IF include_header_ AND header_ IS NOT NULL THEN
      json_msg_w_header_ := JSON_OBJECT_T('{}');
      json_msg_w_header_.put(header_, json_msg_);
      RETURN json_msg_w_header_.to_Clob;
   ELSE
      RETURN json_msg_.to_Clob;
   END IF;
END Message_Clob_To_Json___;

FUNCTION Message_Varchar2_To_Json___(
   msg_            IN VARCHAR2,
   include_header_ IN BOOLEAN ) RETURN CLOB
IS
   count_  NUMBER;
   names_  name_table;
   values_ line_table;
   
   json_msg_          JSON_OBJECT_T;
   json_msg_w_header_ JSON_OBJECT_T;
   json_array_        JSON_ARRAY_T;
   temp_json_object_  JSON_OBJECT_T;
   
   temp_string_val_ VARCHAR2(32767);
   value_           VARCHAR2(32767);
   value_is_json_   BOOLEAN := FALSE;
   header_          VARCHAR2(32000);
BEGIN
   Get_Attributes(msg_, count_, names_, values_);
   header_ := Get_Name(msg_);
   
   json_msg_ := JSON_OBJECT_T('{}');
   
   FOR i_ IN 1..count_ LOOP
      IF Is_Message(values_(i_)) THEN
         value_is_json_ := TRUE;
         value_ := Message_Varchar2_To_Json___(values_(i_), include_header_);
      ELSE
         value_is_json_ := FALSE;
         value_ := values_(i_);
      END IF;
      
      IF json_msg_.has(names_(i_)) THEN
         IF json_msg_.get_Type(names_(i_)) = 'SCALAR' THEN
            temp_string_val_ := json_msg_.get_string(names_(i_));
            json_array_ := JSON_ARRAY_T('[]');
            json_array_.append(temp_string_val_);
         ELSIF json_msg_.get_Type(names_(i_)) = 'ARRAY' THEN
            json_array_ := json_msg_.get_array(names_(i_));
         ELSIF json_msg_.get_Type(names_(i_)) = 'OBJECT' THEN
            temp_json_object_ := json_msg_.get_object(names_(i_));
            json_array_ := JSON_ARRAY_T('[]');
            json_array_.append(temp_json_object_);    
         ELSE
            Error_SYS.Appl_General(lu_name_, 'UNEXP_STRUCT: Error in converting IFS Message to JSON. Value of :P1 is not as expected.', names_(i_));
         END IF;
         
         IF value_is_json_ THEN
            json_array_.append(JSON_OBJECT_T(value_));
         ELSE
            json_array_.append(value_);
         END IF;
         json_msg_.put(names_(i_), json_array_);
      ELSE
         IF value_is_json_ THEN
            json_msg_.put(names_(i_), JSON_OBJECT_T(value_));
         ELSE
            json_msg_.put(names_(i_), value_);
         END IF;
      END IF;
   END LOOP;
   
   IF include_header_ AND header_ IS NOT NULL THEN
      json_msg_w_header_ := JSON_OBJECT_T('{}');
      json_msg_w_header_.put(header_, json_msg_);
      RETURN json_msg_w_header_.stringify;
   ELSE
      RETURN json_msg_.stringify;
   END IF;
END Message_Varchar2_To_Json___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Construct
--   Create a new message with a specified header
@UncheckedAccess
FUNCTION Construct (
   message_name_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN head_marker_||message_name_||new_line_;
END Construct;

@UncheckedAccess
FUNCTION Construct_Clob_Message (
   message_name_ IN     VARCHAR2 ) RETURN CLOB
IS
BEGIN
   RETURN to_clob(Construct(message_name_));
END Construct_Clob_Message;



@UncheckedAccess
PROCEDURE Add_Clob_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     CLOB )
IS
BEGIN
   IF (message_ IS NULL OR message_ = empty_clob OR Dbms_Lob.Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct_Clob_Message(auto_head_name_), message_);
   END IF;
   message_ := message_          ||
       to_clob(attribute_marker_ ||
               name_             ||
               value_marker_     ||
               replace(value_, new_line_, new_line_||continuation_marker_)||new_line_);
END Add_Clob_Attribute;


-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     DATE )
IS
BEGIN
   Add_Attribute(message_, name_, to_char(value_, Client_SYS.date_format_));
END Add_Attribute;



-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     NUMBER )
IS
BEGIN
   Add_Attribute(message_, name_, to_char(value_)); 
END Add_Attribute;



-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     VARCHAR2 )
IS
BEGIN
   IF (message_ IS NULL OR message_ = empty_clob OR Dbms_Lob.Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct_Clob_Message(auto_head_name_), message_);
   END IF;
   Dbms_Lob.WriteAppend(message_,LENGTH(attribute_marker_ ||name_||value_marker_||replace(value_, new_line_, new_line_||continuation_marker_)||new_line_), attribute_marker_ ||name_||value_marker_||replace(value_, new_line_, new_line_||continuation_marker_)||new_line_);
END Add_Attribute;



-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     VARCHAR2 )
IS
BEGIN
   IF (message_ IS NULL OR Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct(auto_head_name_), message_);
   END IF;
   message_ := message_          ||
               attribute_marker_ ||
               name_             ||
               value_marker_     ||
               replace(value_, new_line_, new_line_||continuation_marker_)||
			   new_line_;
END Add_Attribute;



-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     NUMBER )
IS
BEGIN
   Add_Attribute(message_, name_, to_char(value_)); 
END Add_Attribute;



-- Add_Attribute
--   Add a new string/number/date attribute to a message
@UncheckedAccess
PROCEDURE Add_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     DATE )
IS
BEGIN
   Add_Attribute(message_, name_, to_char(value_, Client_SYS.date_format_));
END Add_Attribute;



-- Append_Attribute
--   Append a text line to an existing attribute in a message
@UncheckedAccess
PROCEDURE Append_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     VARCHAR2 )
IS
BEGIN
   IF (message_ IS NULL OR Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct(auto_head_name_), message_);
   END IF;
   message_ := message_      ||
               value_marker_ ||
               replace(value_, new_line_, new_line_||continuation_marker_)||new_line_;
END Append_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN VARCHAR2,
   name_          IN VARCHAR2,
   default_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN value_;
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN VARCHAR2,
   name_          IN VARCHAR2,
   default_value_ IN NUMBER ) RETURN NUMBER
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN to_number(value_);
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN VARCHAR2,
   name_          IN VARCHAR2,
   default_value_ IN DATE ) RETURN DATE
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN to_date(value_, Client_SYS.date_format_);
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN CLOB,
   name_          IN VARCHAR2,
   default_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN value_;
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN CLOB,
   name_          IN VARCHAR2,
   default_value_ IN NUMBER ) RETURN NUMBER
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN to_number(value_);
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;



-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory attribute
@UncheckedAccess
FUNCTION Find_Attribute (
   message_       IN CLOB,
   name_          IN VARCHAR2,
   default_value_ IN DATE ) RETURN DATE
IS
   value_ VARCHAR2(32000);
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN to_date(value_, Client_SYS.date_format_);
   ELSE
      RETURN default_value_;
   END IF;
END Find_Attribute;




-- Find_Attribute
--   Return the string/number/date value for a specified non-mandatory CLOB attribute
@UncheckedAccess
FUNCTION Find_Clob_Attribute (
   message_       IN CLOB,
   name_          IN VARCHAR2,
   default_value_ IN CLOB) RETURN CLOB
IS
   value_ CLOB;
BEGIN
   IF Find_Attribute___(message_, name_, value_) THEN
      RETURN value_;
   ELSE
      RETURN default_value_;
   END IF;
END Find_Clob_Attribute;



-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  VARCHAR2,
   name_          IN  VARCHAR2,
   value_         OUT VARCHAR2 )
IS
BEGIN
   IF NOT Find_Attribute___(message_, name_, value_) THEN
      Attribute_Not_Found___(message_, name_);
   END IF;
END Get_Attribute;


-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  VARCHAR2,
   name_          IN  VARCHAR2,
   value_         OUT NUMBER )
IS
   string_value_ VARCHAR2(32000);
BEGIN
   IF NOT Find_Attribute___(message_, name_, string_value_) THEN
      Attribute_Not_Found___(message_, name_);
   END IF;
   value_ := to_number(string_value_);
END Get_Attribute;


-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  VARCHAR2,
   name_          IN  VARCHAR2,
   value_         OUT DATE )
IS
   string_value_ VARCHAR2(32000);
BEGIN
   IF NOT Find_Attribute___(message_, name_, string_value_) THEN
      Attribute_Not_Found___(message_, name_);
   END IF;
   value_ := to_date(string_value_, Client_SYS.date_format_);
END Get_Attribute;


-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  CLOB,
   name_          IN  VARCHAR2,
   value_         OUT VARCHAR2 )
IS
BEGIN
   IF NOT Find_Attribute___(message_, name_, value_) THEN
      Attribute_Not_Found___(Dbms_Lob.Substr(message_, 50, 1), name_);
   END IF;
END Get_Attribute;


-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  CLOB,
   name_          IN  VARCHAR2,
   value_         OUT NUMBER )
IS
   string_value_ VARCHAR2(32000);
BEGIN
   IF NOT Find_Attribute___(message_, name_, string_value_) THEN
      Attribute_Not_Found___(Dbms_Lob.Substr(message_, 50, 1), name_);
   END IF;
   value_ := to_number(string_value_);
END Get_Attribute;


-- Get_Attribute
--   Retrieve the string/number/date value for a specified mandatory attribute
@UncheckedAccess
PROCEDURE Get_Attribute (
   message_       IN  CLOB,
   name_          IN  VARCHAR2,
   value_         OUT DATE )
IS
   string_value_ VARCHAR2(32000);
BEGIN
   IF NOT Find_Attribute___(message_, name_, string_value_) THEN
      Attribute_Not_Found___(message_, name_);
   END IF;
   value_ := to_date(string_value_, Client_SYS.date_format_);
END Get_Attribute;


-- Get_List_Attribute
--   Retrieve a multi-line mandatory attribute and format it as
--   a Client_SYS.field_separator_-separated list
@UncheckedAccess
PROCEDURE Get_List_Attribute (
   message_       IN  VARCHAR2,
   name_          IN  VARCHAR2,
   list_          OUT VARCHAR2 )
IS
   tmp_list_ VARCHAR2(32000);
BEGIN
   Get_Attribute(message_, name_, tmp_list_);
   list_ := replace(tmp_list_||new_line_, new_line_, Client_SYS.field_separator_);
END Get_List_Attribute;


-- Get_List_Attribute
--   Retrieve a multi-line mandatory attribute and format it as
--   a Client_SYS.field_separator_-separated list
@UncheckedAccess
PROCEDURE Get_List_Attribute (
   message_       IN  CLOB,
   name_          IN  VARCHAR2,
   list_          OUT VARCHAR2 )
IS
   tmp_list_ VARCHAR2(32000);
BEGIN
   Get_Attribute(message_, name_, tmp_list_);
   list_ := replace(tmp_list_||new_line_, new_line_, Client_SYS.field_separator_);
END Get_List_Attribute;


-- Get_Attributes
--   Retrieve all attribute names and (short) string values from a message
@UncheckedAccess
PROCEDURE Get_Attributes (
   message_ IN  VARCHAR2,
   count_   OUT INTEGER,
   name_    OUT name_table,
   value_   OUT line_table )
IS
   p1_  NUMBER := 1;
   p2_  NUMBER;
   p3_  NUMBER;
   p4_  NUMBER;
   msg_ VARCHAR2(32000) := replace(message_,CHR(13));
   num_ INTEGER := 0;
BEGIN
   LOOP
      p1_ := instr(msg_, new_line_||attribute_marker_, p1_);
      EXIT WHEN p1_ IS NULL OR p1_ = 0;
      p2_ := p1_ + 2;
      p3_ := instr(msg_, value_marker_, p2_);
      p4_ := instr(msg_, new_line_||attribute_marker_, p3_);
      IF p4_ = 0 THEN
         p4_ := length(msg_);
         IF substr(msg_,p4_,1) = new_line_ THEN
            p4_ := p4_ - 1;
         END IF;
      ELSE
         p4_ := p4_ - 1;
      END IF;
      IF p3_ > 0 AND p4_ > 0 THEN
         num_ := num_ + 1;
         name_(num_)  := substr(msg_, p2_, p3_-p2_ );
         value_(num_) := replace(rtrim(substr(msg_, p3_+1, p4_-p3_),new_line_),
                                 new_line_||continuation_marker_,
                                 new_line_);
      END IF;
      p1_ := p4_;
   END LOOP;
   count_ := num_;
END Get_Attributes;



-- Get_Attributes
--   Retrieve all attribute names and (short) string values from a message
@UncheckedAccess
PROCEDURE Get_Attributes (
   message_ IN  CLOB,
   count_   OUT INTEGER,
   name_    OUT name_table,
   value_   OUT line_table )
IS
   p1_  NUMBER := 1;
   p2_  NUMBER;
   p3_  NUMBER;
   p4_  NUMBER;
   msg_ CLOB;
   num_ INTEGER := 0;
BEGIN
   IF (Dbms_Lob.Instr(message_, chr(13)) > 0) THEN
      msg_ := replace(message_, chr(13));
   ELSE
      msg_ := message_;
   END IF;
   LOOP
      p1_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p1_);
      EXIT WHEN p1_ IS NULL OR p1_ = 0;
      p2_ := p1_ + 2;
      p3_ := Dbms_Lob.Instr(msg_, value_marker_, p2_);
      p4_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p3_);
      IF p4_ = 0 THEN
         p4_ := Dbms_Lob.Getlength(msg_);
         IF Dbms_Lob.Substr(msg_,1,p4_) = new_line_ THEN
            p4_ := p4_ - 1;
         END IF;
      ELSE
         p4_ := p4_ - 1;
      END IF;
      IF p3_ > 0 AND p4_ > 0 THEN
         num_ := num_ + 1;
         name_(num_)  := Dbms_Lob.Substr(msg_, p3_-p2_,p2_ );
         value_(num_) := replace(rtrim(Dbms_Lob.Substr(msg_, p4_-p3_, p3_+1),new_line_),
                                 new_line_||continuation_marker_,
                                 new_line_);
      END IF;
      p1_ := p4_;
   END LOOP;
   count_ := num_;
END Get_Attributes;

-- Get_Attributes
--   Retrieve all attribute names and (short) string values from a message
@UncheckedAccess
PROCEDURE Get_Clob_Attributes (
   message_ IN  CLOB,
   count_   OUT INTEGER,
   name_    OUT name_table_clob,
   value_   OUT line_table_clob )
IS
   p1_  NUMBER := 1;
   p2_  NUMBER;
   p3_  NUMBER;
   p4_  NUMBER;
   msg_ CLOB;
   num_ INTEGER := 0;
BEGIN
   IF (Dbms_Lob.Instr(message_, chr(13)) > 0) THEN
      msg_ := replace(message_, chr(13));
   ELSE
      msg_ := message_;
   END IF;
   LOOP
      p1_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p1_);
      EXIT WHEN p1_ IS NULL OR p1_ = 0;
      p2_ := p1_ + 2;
      p3_ := Dbms_Lob.Instr(msg_, value_marker_, p2_);
      p4_ := Dbms_Lob.Instr(msg_, new_line_||attribute_marker_, p3_);
      IF p4_ = 0 THEN
         p4_ := Dbms_Lob.Getlength(msg_);
         IF Dbms_Lob.Substr(msg_,1,p4_) = new_line_ THEN
            p4_ := p4_ - 1;
         END IF;
      ELSE
         p4_ := p4_ - 1;
      END IF;
      IF p3_ > 0 AND p4_ > 0 THEN
         num_ := num_ + 1;
         name_(num_)  := Dbms_Lob.Substr(msg_, p3_-p2_, p2_);
         value_(num_) := replace(rtrim(Substr(msg_, p3_+1, p4_-p3_),new_line_),
                                 new_line_||continuation_marker_,
                                 new_line_);
--         value_(num_) := replace(rtrim(Dbms_Lob.Substr(msg_, , ),new_line_),
--                                 new_line_||continuation_marker_,
--                                 new_line_);
      END IF;
      p1_ := p4_;
   END LOOP;
   count_ := num_;
END Get_Clob_Attributes;

FUNCTION Message_To_Json(
   msg_            IN CLOB,
   include_header_ IN BOOLEAN DEFAULT TRUE) RETURN CLOB
IS
   use_clob_   BOOLEAN := FALSE;
   size_limit_ NUMBER := 30000;
BEGIN
   -- if it's a small json we can use VARCHAR2 in processing
   -- if value is larger than size_limit_ then we have a chance that
   -- the resulting json will not fit it a VARCHAR2 variable.
   -- Hence we will use CLOB instead
   IF dbms_lob.Getlength(msg_) > size_limit_ THEN
      use_clob_ := TRUE;
      dbms_output.put_line('Using Clob');
   END IF;
   
   IF use_clob_ THEN
      RETURN Message_Clob_To_Json___(msg_, include_header_);
   ELSE
      RETURN Message_Varchar2_To_Json___(msg_, include_header_);
   END IF;
END Message_To_Json;

-- Get_Name
--   Return the name (header) of a specified message
@UncheckedAccess
FUNCTION Get_Name (
   message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   p1_  NUMBER;
   p2_  NUMBER;
   msg_ VARCHAR2(32000) := replace(message_, chr(13));
BEGIN
   p1_ := instr(msg_, head_marker_);
   IF p1_ = 0 THEN
      RETURN NULL;
   END IF;
   p2_ := instr(msg_, new_line_, p1_);
   IF p2_ = 0 THEN
      RETURN substr(msg_,p1_+1);
   ELSE
      RETURN substr(msg_,p1_+1,p2_-p1_-1);
   END IF;
END Get_Name;



-- Get_Name
--   Return the name (header) of a specified message
@UncheckedAccess
FUNCTION Get_Name (
   message_ IN CLOB ) RETURN VARCHAR2
IS
   p1_  NUMBER;
   p2_  NUMBER;
   msg_ CLOB;
BEGIN
   IF (Dbms_Lob.Instr(message_, chr(13)) > 0) THEN
      msg_ := replace(message_, chr(13));
   ELSE
      msg_ := message_;
   END IF;
   p1_ := Dbms_Lob.Instr(msg_, head_marker_);
   IF p1_ = 0 THEN
      RETURN NULL;
   END IF;
   p2_ := Dbms_Lob.Instr(msg_, new_line_, p1_);
   IF p2_ = 0 THEN
      RETURN Dbms_Lob.Substr(msg_, Dbms_Lob.GetLength(msg_)-p1_, p1_+1);
   ELSE
      RETURN Dbms_Lob.Substr(msg_, p2_-p1_-1, p1_+1);
   END IF;
END Get_Name;



-- Is_Message
--   Returns TRUE if the string is a message (with at least a header, one name and a value),
--   otherwise it returns FALSE
@UncheckedAccess
FUNCTION Is_Message (
   message_ IN  VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF message_ LIKE '%'||new_line_||'%'||attribute_marker_||'%'||value_marker_||'%' THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;   
END Is_Message;


-- Is_Message
--   Returns TRUE if the string is a message (with at least a header, one name and a value),
--   otherwise it returns FALSE
@UncheckedAccess
FUNCTION Is_Message (
   message_ IN  CLOB ) RETURN BOOLEAN
IS
BEGIN
   IF message_ LIKE '%'||new_line_||'%'||attribute_marker_||'%'||value_marker_||'%' THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;   
END Is_Message;


-- Set_Attribute
--   Modify the value of an existing string/number/date attribute or create
--   a new attribute if it does not exist
@UncheckedAccess
PROCEDURE Set_Clob_Attribute (
   message_       IN OUT CLOB,
   name_          IN     VARCHAR2,
   value_         IN     CLOB )
IS
   p1_ NUMBER;
   p2_ NUMBER;
   p3_ NUMBER;
BEGIN
   IF (message_ IS NULL OR message_ = empty_clob OR Dbms_Lob.Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct_Clob_Message(auto_head_name_), message_);
   END IF;
   p1_ := dbms_lob.instr(message_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ > 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := dbms_lob.instr(message_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := length(message_);
         IF dbms_lob.substr(message_, offset => p3_, amount => 1) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         message_ := dbms_lob.substr(message_, offset => 1, amount => p2_-1) ||
                     replace(value_, new_line_, new_line_||continuation_marker_) ||
                     dbms_lob.substr(message_, offset => p3_+1);
         RETURN;
      END IF;
   END IF;
   Add_Clob_Attribute(message_, name_, value_);
END Set_Clob_Attribute;


@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     VARCHAR2 )
IS
   p1_ NUMBER;
   p2_ NUMBER;
   p3_ NUMBER;
BEGIN
   IF (Instr(message_, head_marker_, 1, 1)<0 OR message_ IS NULL) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct(auto_head_name_), message_);
   END IF;
   p1_ := instr(message_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ > 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := instr(message_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := length(message_);
         IF substr(message_, p3_, 1) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         message_ := substr(message_,1,p2_-1) ||
                     replace(value_, new_line_, new_line_||continuation_marker_) ||
                     substr(message_,p3_+1);
         RETURN;
      END IF;
   END IF;
   Add_Attribute(message_, name_, value_);
END Set_Attribute;

@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     VARCHAR2 )
IS
   p1_ NUMBER;
   p2_ NUMBER;
   p3_ NUMBER;
BEGIN
   IF (message_ IS NULL OR message_ = empty_clob OR Dbms_Lob.Instr(message_, head_marker_) = 0) THEN -- If no header exists in the messa then add an autogenerated header
      message_ := Concat(Construct_Clob_Message(auto_head_name_), message_);
   END IF;
   p1_ := dbms_lob.instr(message_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ > 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := dbms_lob.instr(message_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := length(message_);
         IF dbms_lob.substr(message_, offset => p3_, amount => 1) = new_line_ THEN
            p3_ := p3_ - 1;
         END IF;
      ELSE
         p3_ := p3_ - 1;
      END IF;
      IF p3_ > 0 THEN
         message_ := dbms_lob.substr(message_, offset => 1, amount => p2_-1) ||
                     replace(value_, new_line_, new_line_||continuation_marker_) ||
                     dbms_lob.substr(message_, offset => p3_+1);
         RETURN;
      END IF;
   END IF;
   Add_Attribute(message_, name_, value_);
END Set_Attribute;

@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     DATE )
IS
BEGIN
   Set_Attribute(message_,name_,to_char(value_, Client_SYS.date_format_));
END Set_Attribute;



-- Set_Attribute
--   Modify the value of an existing string/number/date attribute or create
--   a new attribute if it does not exist
@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT NOCOPY CLOB,
   name_          IN     VARCHAR2,
   value_         IN     NUMBER )
IS
BEGIN
   Set_Attribute(message_,name_,to_char(value_));
END Set_Attribute;

-- Set_Attribute
--   Modify the value of an existing string/number/date attribute or create
--   a new attribute if it does not exist
@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     DATE )
IS
BEGIN
   Set_Attribute(message_,name_,to_char(value_, Client_SYS.date_format_));
END Set_Attribute;



-- Set_Attribute
--   Modify the value of an existing string/number/date attribute or create
--   a new attribute if it does not exist
@UncheckedAccess
PROCEDURE Set_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2,
   value_         IN     NUMBER )
IS
BEGIN
   Set_Attribute(message_,name_,to_char(value_));
END Set_Attribute;



-- Remove_Attribute
--   Remove an existing attribute, do nothing if it does not exist
@UncheckedAccess
PROCEDURE Remove_Attribute (
   message_       IN OUT VARCHAR2,
   name_          IN     VARCHAR2 )
IS
   p1_ NUMBER;
   p2_ NUMBER;
   p3_ NUMBER;
BEGIN
   message_ := replace(message_, chr(13));
   p1_ := instr(message_, new_line_||attribute_marker_||name_||value_marker_);
   IF p1_ > 1 THEN
      p2_ := p1_+length(name_)+3;
      p3_ := instr(message_, new_line_||attribute_marker_, p2_);
      IF p3_ = 0 THEN
         p3_ := length(message_)+1;
      END IF;
      IF p3_ > 0 THEN
         message_ := substr(message_,1,p1_-1) || substr(message_,p3_);
      END IF;
   END IF;
END Remove_Attribute;



-- Get_Message_From_Attr
--   Converts an attribute string to a message
@UncheckedAccess
FUNCTION Get_Message_From_Attr (
   attr_         IN VARCHAR2,
   message_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);
BEGIN
   ptr_ := NULL;
   msg_ := Construct(message_name_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Add_Attribute(msg_, name_, value_);
   END LOOP;
   RETURN msg_;
END Get_Message_From_Attr;



-- Get_Attr_From_Message
--   Converts a message to an attribute string
@UncheckedAccess
FUNCTION Get_Attr_From_Message (
   msg_ IN VARCHAR2) RETURN VARCHAR2
IS 
   count_ NUMBER;
   name_  name_table;
   value_ line_table;
   
   attr_  VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Attributes(msg_, count_, name_, value_);
   FOR i IN 1..count_ LOOP
      Client_SYS.Add_To_Attr(name_(i), value_(i), attr_);
   END LOOP;
   RETURN attr_; 
END Get_Attr_From_Message;



FUNCTION Message_2_Message (
   msg_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   message_ VARCHAR2(32000);
   name_    name_table;
   value_   line_table;
   count_   NUMBER;
BEGIN
   message_ := Construct(Get_Name(msg_));
   Get_Attributes(msg_, count_, name_, value_);
   FOR i IN 1..count_ LOOP
      Add_Attribute(message_, name_(i), value_(i));
   END LOOP;
   RETURN message_;    
END Message_2_Message;

 
