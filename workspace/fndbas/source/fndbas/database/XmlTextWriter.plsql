-----------------------------------------------------------------------------
--
--  Logical unit: XmlTextWriter
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030520  DOZE    Created from a file by DAJO, Functions in
--                  XML_TEXT_WRITER_SYS are copied from MS .Net class
--                  XmlTextWriter
--  040114  DOZE    Added Escape_Xml for escaping special characters
--  070903  UTGULK  Added method Init_Write_Buffer(Bug 67572).
--  110325  KrGuSE  Rewrote Write__ and fixed some buffer overflow problems due
--                  to unicode characters using more than 1 byte
--  140129  AsiWLK   Merged LCS-111925
--  210228  MABALK  General_SYS.Init_Method call cause performance reduction in very large reports(Bug ID 158160)
--  210429  NALTLK  Performance issues in one of the very large reports in the Sub Contracting area.(Bug ID 158802)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

fmt_indented_         CONSTANT NUMBER := 1;
fmt_none_             CONSTANT NUMBER := 0;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-- On the basis of the usage, global variables are safe
@ApproveGlobalVariable(2014-09-29,skumlk)
current_format_            NUMBER := fmt_none_;
current_indent_char_       CONSTANT VARCHAR2(1) := ' '; -- the character to use for indenting

@ApproveGlobalVariable(2014-09-29,skumlk)
current_indent_level_      NUMBER := 0;

@ApproveGlobalVariable(2014-09-29,skumlk)
write_buffer_              VARCHAR2(32767) := '';    -- buffer writes in VARCHAR in order to reduce number of DBMS_LOB.WriteAppenbd

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Flush___ (
   xml_stream_ IN OUT NOCOPY CLOB)
IS
BEGIN
   IF (write_buffer_ IS NOT NULL) THEN
      Dbms_Lob.WriteAppend(xml_stream_, LENGTH(write_buffer_), write_buffer_);
      write_buffer_ := '';
   END IF;
END Flush___;


PROCEDURE Write___ (
   xml_stream_ IN OUT NOCOPY CLOB,
   append_ IN VARCHAR2 )
IS
BEGIN  
   -- write data to temporary buffer (to avoid slow DBMS_LOB.WriteAppend
   write_buffer_ := write_buffer_ || append_;
EXCEPTION
   WHEN VALUE_ERROR THEN
      --if the buffer for some reason can't handle the append_, flush and write using DBMS_LOB anyway
      Flush___(xml_stream_);
      write_buffer_ := append_;
END Write___;


PROCEDURE Write_Indent___ (
   xml_stream_ IN OUT NOCOPY CLOB)
IS
BEGIN
   IF (current_format_ = fmt_indented_) THEN
      FOR i_ IN 1..current_indent_level_ LOOP
         Write___(xml_stream_, current_indent_char_);
      END LOOP;
   END IF;
END Write_Indent___;


PROCEDURE Write_Line_Feed___ (
   xml_stream_ IN OUT NOCOPY CLOB)
IS
BEGIN
   IF (current_format_ = fmt_indented_) THEN
      Write___(xml_stream_, CHR(10));
   END IF;
END Write_Line_Feed___;


PROCEDURE Indent___
IS
BEGIN
   current_indent_level_ := current_indent_level_ + 1;
END Indent___;


PROCEDURE Outdent___
IS
BEGIN
   current_indent_level_ := current_indent_level_ - 1;
END Outdent___;


FUNCTION Escape_Xml___ (
   text_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   newtext_ VARCHAR2(32767);
BEGIN
   newtext_ := replace(text_, '&', chr(38) || 'amp;');
   newtext_ := replace(newtext_, '<', chr(38) || 'lt;');
   newtext_ := replace(newtext_, '>', chr(38) || 'gt;');
   newtext_ := replace(newtext_, '"', chr(38) || 'quot;');
   newtext_ := replace(newtext_, '''', chr(38) || 'apos;');
   RETURN newtext_;
END Escape_Xml___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Set_Format (
   format_ IN NUMBER )
IS
BEGIN
   current_format_ := format_;
END Set_Format;

@UncheckedAccess
PROCEDURE Write_Start_Document (
   xml_stream_ OUT CLOB )
IS
BEGIN
   Dbms_Lob.CreateTemporary(xml_stream_, TRUE);
   Set_Format(fmt_none_); -- revert back to default format for new document
END Write_Start_Document;

@UncheckedAccess
PROCEDURE Write_End_Document (
   xml_stream_ IN OUT NOCOPY CLOB)
IS
BEGIN
   Flush___(xml_stream_);
END Write_End_Document;

@UncheckedAccess
PROCEDURE Write_Start_Element (
   xml_stream_ IN OUT NOCOPY CLOB,
   prefix_ IN VARCHAR2 DEFAULT NULL,
   local_name_ IN VARCHAR2,
   ns_ IN VARCHAR2 DEFAULT NULL,
   attr_name1_ IN VARCHAR2 DEFAULT NULL,
   attr_value1_ IN VARCHAR2 DEFAULT NULL,
   attr_name2_ IN VARCHAR2 DEFAULT NULL,
   attr_value2_ IN VARCHAR2 DEFAULT NULL,
   attr_name3_ IN VARCHAR2 DEFAULT NULL,
   attr_value3_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Write_Indent___(xml_stream_);
   Write___(xml_stream_, '<');
   IF NOT (prefix_ IS NULL) THEN
      Write___(xml_stream_, prefix_ || ':' );
   END IF;
   Write___(xml_stream_, local_name_);
   IF NOT (ns_ IS NULL) THEN
      Write___(xml_stream_, ' xmlns="' || ns_ || '"');
   END IF;
   IF NOT (attr_name1_ IS NULL) THEN
      Write___(xml_stream_, ' ' || attr_name1_ || '="' || attr_value1_ || '"');
   END IF;
   IF NOT (attr_name2_ IS NULL) THEN
      Write___(xml_stream_, ' ' || attr_name2_ || '="' || attr_value2_ || '"');
   END IF;
   IF NOT (attr_name3_ IS NULL) THEN
      Write___(xml_stream_, ' ' || attr_name3_ || '="' || attr_value3_ || '"');
   END IF;
   Write___(xml_stream_, '>');
   Write_Line_Feed___(xml_stream_);
   Indent___;
END Write_Start_Element;

@UncheckedAccess
PROCEDURE Write_End_Element (
   xml_stream_ IN OUT NOCOPY CLOB,
   local_name_ IN VARCHAR2 )
IS
BEGIN
   Outdent___;
   Write_Indent___(xml_stream_);
   Write___(xml_stream_, '</' || local_name_ || '>');
   Write_Line_Feed___(xml_stream_);
END Write_End_Element;

@UncheckedAccess
PROCEDURE Write_Simple_Element (
   xml_stream_ IN OUT NOCOPY CLOB,
   local_name_ IN VARCHAR2,
   text_ IN VARCHAR2,
   attr_name_ IN VARCHAR2 DEFAULT NULL,
   attr_value_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Write_Indent___(xml_stream_);
   Write___(xml_stream_, '<' || local_name_);
   IF NOT (attr_name_ IS NULL) THEN
      Write___(xml_stream_, ' ' || attr_name_ || '="' || attr_value_ || '"');
   END IF;
   IF (text_ IS NULL) THEN
      Write___(xml_stream_, ' ' || 'xsi:nil="1"/>');
   ELSE
     Write___(xml_stream_, '>');
     Write___(xml_stream_, Escape_Xml___(text_));
     Write___(xml_stream_, '</');
     Write___(xml_stream_, local_name_);
     Write___(xml_stream_, '>');
   END IF;
   Write_Line_Feed___(xml_stream_);
END Write_Simple_Element;

@UncheckedAccess
PROCEDURE Write_String (
   xml_stream_ IN OUT NOCOPY CLOB,
   text_ IN VARCHAR2 )
IS
BEGIN
   Write___(xml_stream_, Escape_Xml___(text_));
END Write_String;

@UncheckedAccess
PROCEDURE Init_Write_Buffer
IS
BEGIN
   write_buffer_ := '';
END Init_Write_Buffer;



