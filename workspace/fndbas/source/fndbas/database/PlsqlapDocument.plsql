-----------------------------------------------------------------------------
--
--  Logical unit: PlsqlapDocument
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180919  JAPASE  Created
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

FORMAT_TIME_STAMP   CONSTANT VARCHAR2(25) := 'FXyyyy-mm-dd"T"hh24:mi:ss';
FORMAT_DATE         CONSTANT VARCHAR2(12) := 'FXyyyy-mm-dd';
FORMAT_TIME         CONSTANT VARCHAR2(12) := 'FXhh24:mi:ss';

-- Simple types
TYPE_TEXT       CONSTANT VARCHAR2(1) := 'S';
TYPE_INTEGER    CONSTANT VARCHAR2(1) := 'I';
TYPE_FLOAT      CONSTANT VARCHAR2(1) := 'F';
TYPE_BOOLEAN    CONSTANT VARCHAR2(1) := 'B';
TYPE_BINARY     CONSTANT VARCHAR2(1) := 'R';
TYPE_DATE       CONSTANT VARCHAR2(1) := 'D';
TYPE_TIME       CONSTANT VARCHAR2(1) := 'T';
TYPE_TIMESTAMP  CONSTANT VARCHAR2(1) := 'M';
TYPE_UNKNOWN    CONSTANT VARCHAR2(1) := 'U'; -- used when parsing XML
-- Compound types
TYPE_COMPOUND   CONSTANT VARCHAR2(1) := 'c'; -- denotes compound attribute (an aggregate or array)
TYPE_DOCUMENT   CONSTANT VARCHAR2(1) := 'd'; -- denotes element of a compound attribute


SUBTYPE Element_Id IS BINARY_INTEGER;

-- Document contains attributes: simple, i.e. with values, and compound.
-- A compound attribute can contain one or more documents. If a compound
-- attribute contains several documents, all have to be of the same type.
-- The compound attribute will be an array then. If a compound attribute
-- contains only one document, it will be an aggregate.
TYPE Document IS RECORD (
   -- Private declarations
   root_id   Element_Id,
   elements  Element_Table,      -- collection with all elements
   xml_attrs Xml_All_Attr_Table  -- optional XML attributes, not used by IFS framework
);

TYPE Child_Table IS TABLE OF Element_Id INDEX BY BINARY_INTEGER;

TYPE Xml_Attribute IS RECORD (  -- record representing single XML attribute
   -- Private declarations
   name   VARCHAR2(200),
   value  VARCHAR2(4000)
);

TYPE Xml_Attr_Table IS TABLE OF Xml_Attribute INDEX BY BINARY_INTEGER;

-- Private declarations

TYPE Xml_All_Attr_Table IS TABLE OF Xml_Attr_Table INDEX BY Element_Id;

TYPE Element IS RECORD (        -- record representing single element
   id         Element_Id,       -- ID of this element
   parent_id  Element_Id,       -- ID of the parent element
   name       VARCHAR2(4000),   -- element name, case sensitive
   namespace  VARCHAR2(200),    -- namespace name, case sensitive
   type       VARCHAR2(1),      -- type marker for attributes
   value      VARCHAR2(32767),  -- value of the simple (not compound) attribute
   clob_val   CLOB,             -- only one of value or clob_val may be filled
   children   Child_Table       -- collection with all children, if compound
);

TYPE Element_Table IS TABLE OF Element INDEX BY Element_Id;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Return element name with namespace, if specified
FUNCTION Full_Name___ (
   element_ Element ) RETURN VARCHAR2
IS
BEGIN
   RETURN CASE WHEN element_.namespace IS NOT NULL THEN element_.namespace || ':' END || element_.name;
END Full_Name___;


-- Create new element and add it to the 'elements' collection
FUNCTION New_Element___ (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   namespace_ IN     VARCHAR2,
   type_      IN     VARCHAR2,
   value_     IN     VARCHAR2 DEFAULT NULL,
   clob_      IN     CLOB     DEFAULT NULL ) RETURN Element_Id
IS
   id_      Element_Id := main_.elements.count + 1;
   element_ Element;
BEGIN
   Check_Name___(name_);
   IF namespace_ IS NOT NULL THEN
      Check_Name___(namespace_);
   END IF;
   element_.id := id_;
   element_.name := name_;
   element_.namespace := namespace_;
   element_.type := type_;
   main_.elements(id_) := element_;
   main_.elements(id_).value := value_;
   main_.elements(id_).clob_val := clob_;
   RETURN id_;
END New_Element___;


-- Add an element as a child to another element
PROCEDURE Add_Child___ (
   main_      IN OUT Document,
   parent_id_ IN     Element_Id,
   child_id_  IN     Element_Id )
IS
   id_   Element_Id := nvl(parent_id_, main_.root_id);
   pos_  BINARY_INTEGER := main_.elements(id_).children.count + 1;

   -- a document cannot contain duplicated attributes (simple or compound)
   -- a compound attribute can contain documents with the same name (an array)
   -- (TODO: do we need to support sub-documents, i.e. documents with other names that inherits from the same document?)
   PROCEDURE Check_Child_Name (parent_ IN Element, child_ IN Element) IS
   BEGIN
      FOR i IN 1..parent_.children.count LOOP
         DECLARE
            name_ VARCHAR2(4000) := main_.elements(parent_.children(i)).name;
            namespace_ VARCHAR2(200);
         BEGIN
            IF child_.type <> TYPE_DOCUMENT AND name_ = child_.name THEN
               Error_SYS.Appl_General(lu_name_, 'PLAPDOCDUPATTR: Attribute [:P1] already exists within document [:P2]', child_.name, Full_Name___(parent_));
            ELSIF child_.type = TYPE_DOCUMENT THEN
               namespace_ := main_.elements(parent_.children(i)).namespace;
               IF name_ <> child_.name OR namespace_ <> child_.namespace OR (namespace_ IS NULL AND child_.namespace IS NOT NULL) OR (namespace_ IS NOT NULL AND child_.namespace IS NULL) THEN
                  Error_SYS.Appl_General(lu_name_, 'PLAPDOCDIFFDOC1: Cannot add document [:P1] to an array [:P2] containing documents with other names', Full_Name___(child_), Full_Name___(parent_));
               END IF;
            END IF;
         END;
      END LOOP;
   END;

BEGIN
   Check_Child_Name(main_.elements(id_), main_.elements(child_id_));
   main_.elements(id_).children(pos_) := child_id_;
   main_.elements(child_id_).parent_id := id_;
END Add_Child___;


-- Check if the document has been initialized
PROCEDURE Check_Document___ (
   main_ IN Document )
IS
BEGIN
   IF main_.root_id IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCNOINIT: Document has not been initialized');
   END IF;
END Check_Document___;


-- Check if the given value is not empty
PROCEDURE Check_Empty___ (
   name_   IN VARCHAR2,
   value_  IN VARCHAR2)
IS
BEGIN
   IF value_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCEMPTY: :P1 must not be empty', name_);
   END IF;
END Check_Empty___;


-- Check if the element name is valid
-- An element name can contain letters, digits, hyphens, underscores, and periods
-- An element name cannot contain spaces
-- An element name must start with a letter or underscore
-- An element name cannot start with 'xml' in any form
PROCEDURE Check_Name___ (
   name_ IN VARCHAR2,
   attr_ IN BOOLEAN DEFAULT FALSE )
IS
  regexp_ VARCHAR2(50) := '^[[:alpha:]_]{1}[[:alnum:]._' || CASE attr_ WHEN TRUE THEN '.:' ELSE '' END || '-]*$';
BEGIN
   IF NOT attr_ AND upper(substr(name_,1,3)) = 'XML' OR instr(name_,' ') <> 0 OR NOT REGEXP_LIKE(name_, regexp_) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCINVNAME: Element/attribute name [:P1] is invalid', name_);
   END IF;
END Check_Name___;


-- Check the type of the parent element and throw error if not as expected
PROCEDURE Check_Parent_Type___ (
   main_          IN Document,
   parent_id_     IN Element_Id,
   expected_type_ IN VARCHAR2)
IS
   id_ Element_Id := nvl(parent_id_, main_.root_id);
BEGIN
   IF main_.elements(id_).type <> expected_type_ THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCTYPNEXP: Expected parent element [:P1] to be :P2, but found :P3', Full_Name___(main_.elements(id_)), Get_Type_Name___(expected_type_), Get_Type_Name___(main_.elements(id_).type));
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCPNOTF: Parent element with ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCPNULL: Parent element ID must not be NULL');
END Check_Parent_Type___;


-- Validate subtype of the NUMBER data type
PROCEDURE Validate_Number_Type___ (
   type_ IN VARCHAR2)
IS
BEGIN
   IF NOT type_ IN (TYPE_INTEGER, TYPE_FLOAT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCNTYPE: Type [:P1] is not of numeric type', Get_Type_Name___(type_));
   END IF;
END Validate_Number_Type___;


PROCEDURE Validate_Value_Type___ (
   value_   IN NUMBER,
   type_    IN VARCHAR2)
IS
BEGIN
   IF (type_ = TYPE_INTEGER AND value_ != trunc(value_)) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCINTYPE: Value [:P1] is not an INTEGER', value_);
   END IF;
END Validate_Value_Type___;


-- Validate subtype of the DATE data type and return correct format mask
FUNCTION Get_Date_Format___ (
   type_ IN VARCHAR2) RETURN VARCHAR2
IS
   format_ VARCHAR2(30);
BEGIN
   CASE type_
      WHEN TYPE_DATE      THEN format_ := FORMAT_DATE;
      WHEN TYPE_TIME      THEN format_ := FORMAT_TIME;
      WHEN TYPE_TIMESTAMP THEN format_ := FORMAT_TIME_STAMP;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'PLAPDOCDTYPE: Type [:P1] is not of date type', Get_Type_Name___(type_));
   END CASE;
   RETURN format_;
END Get_Date_Format___;


-- Convert VARCHAR2 to DATE using format mask for given type.
FUNCTION To_Date___ (
   main_   IN Document,
   id_     IN Element_Id,
   value_  IN VARCHAR2,
   type_   IN VARCHAR2 ) RETURN DATE
IS
   format_mask_ VARCHAR2(25) := Get_Date_Format___(type_);
BEGIN
   BEGIN
      RETURN To_Date(value_, format_mask_);
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'PLAPDOCPNOTDATE: Element [:P1] with value ":P2" is not a :P3', Get_Name(main_, id_), Get_Value(main_, id_), lower(Get_Type_Name___(type_)));
   END;
END To_Date___;


-- Encode BLOB value with Base64
FUNCTION To_Base64___(blob_ BLOB) RETURN CLOB
IS
   clob_ CLOB;
   step_ PLS_INTEGER := 12000; -- must be a multiple of 3 not higher than 24573
BEGIN
   IF blob_ IS NULL OR Dbms_Lob.GetLength(blob_) = 0 THEN
      RETURN NULL;
   END IF;
   FOR i IN 0..trunc((Dbms_Lob.GetLength(blob_) - 1)/step_) LOOP
      clob_ := clob_ || Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Dbms_Lob.Substr(blob_, step_, i * step_ + 1)));
   END LOOP;
   RETURN clob_;
END To_Base64___;


-- Decode BLOB value from a Base 64 text
FUNCTION From_Base64___(clob_ CLOB) RETURN BLOB
IS
   buf_size_ PLS_INTEGER := 32000; -- must be multiple of 4
   buf_char_ VARCHAR2(32000);
   buf_raw_  RAW(32000);
   b64_data_ CLOB;
   offset_   PLS_INTEGER := 1;
   blob_     BLOB;

   FUNCTION Trim_Clob(in_clob_ CLOB) RETURN CLOB IS
      buf_len_  BINARY_INTEGER := 32767;
      buf_      VARCHAR2(32767);
      start_    PLS_INTEGER := 1;
      clob_len_ PLS_INTEGER := DBMS_LOB.GetLength(in_clob_);
      out_clob_ CLOB;
   BEGIN
      DBMS_LOB.CreateTemporary(out_clob_,TRUE);
      WHILE start_ < clob_len_ LOOP
         DBMS_LOB.Read(in_clob_, buf_len_, start_, buf_);
         IF buf_ IS NOT NULL THEN
            buf_ := replace(replace(buf_, chr(13), ''), chr(10), '');
            DBMS_LOB.WriteAppend(out_clob_, LENGTH(buf_), buf_);
         END IF;
         start_ := start_ + buf_len_;
      END LOOP;
      RETURN out_clob_;
   END;

BEGIN
   IF clob_ IS NULL OR Dbms_Lob.GetLength(clob_) = 0 THEN
      RETURN NULL;
   END IF;
   b64_data_ := Trim_Clob(clob_);
   Dbms_Lob.CreateTemporary(blob_, true);
   FOR i IN 1..ceil(Dbms_Lob.GetLength(b64_data_) / buf_size_) LOOP
      Dbms_Lob.Read(b64_data_, buf_size_, offset_, buf_char_);
      buf_raw_ := Utl_Encode.Base64_Decode(Utl_Raw.Cast_To_Raw(buf_char_));
      Dbms_Lob.WriteAppend(blob_, Utl_Raw.Length(buf_raw_), buf_raw_);
      offset_ := offset_ + buf_size_;
   END LOOP;
   RETURN blob_;
END From_Base64___;


-- Define the value type, VARCHAR2 or CLOB, to be set on the attribute.
-- If it is a CLOB value, but shorter then 32767 characters, an attempt
-- to put it to VARCHAR2 will be made.
PROCEDURE Define_Value___ (
   text_     OUT VARCHAR2,
   clob_     OUT CLOB,
   text_val_ IN  VARCHAR2,
   clob_val_ IN  CLOB )
IS
BEGIN
   -- if CLOB try to put it in into VARCHAR2
   IF clob_val_ IS NOT NULL THEN
      IF Dbms_Lob.GetLength(clob_val_) <= 32767 THEN
         BEGIN
            text_ := clob_val_;
            clob_ := NULL;
         EXCEPTION
             -- a CLOB of length 32767 chars can be larger then 32767 bytes, which is a limit for VARCHAR2
            WHEN value_error THEN
               text_ := NULL;
               clob_ := clob_val_;
         END;
      ELSE
         text_ := NULL;
         clob_ := clob_val_;
      END IF;
   ELSE
      text_ := text_val_;
      clob_ := NULL;
   END IF;
END Define_Value___;


-- Add a simple attribute, i.e. an attribute with value
FUNCTION Add_Simple_Attribute___ (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   namespace_ IN     VARCHAR2,
   text_val_  IN     VARCHAR2,
   type_      IN     VARCHAR2,
   parent_id_ IN     Element_Id,
   clob_val_  IN     CLOB DEFAULT NULL ) RETURN Element_Id
IS
   id_   Element_Id;
   text_ VARCHAR2(32767) := NULL;
   clob_ CLOB := NULL;
BEGIN
   Check_Document___(main_);
   Check_Empty___('Attribute name', name_);
   -- a simple attribute can only be added to a document
   Check_Parent_Type___(main_, parent_id_, TYPE_DOCUMENT);

   -- if CLOB try to put it in into VARCHAR2
   Define_Value___(text_, clob_, text_val_, clob_val_);

   id_ := New_Element___(main_, name_, namespace_, type_, text_, clob_);
   Add_Child___(main_, parent_id_, id_);
   RETURN id_;
END Add_Simple_Attribute___;


-- Add a compound attrubute (an aggregate or array), i.e. an attribute containing document(s)
FUNCTION Add_Compound_Attribute___ (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   namespace_ IN     VARCHAR2,
   parent_id_ IN     Element_Id ) RETURN Element_Id
IS
   id_ Element_Id;
BEGIN
   Check_Document___(main_);
   Check_Empty___('Aggregate name', name_);
   -- a compound attribute can only be added to a document
   Check_Parent_Type___(main_, parent_id_, TYPE_DOCUMENT);
   id_ := New_Element___(main_, name_, namespace_, TYPE_COMPOUND);
   Add_Child___(main_, parent_id_, id_);
   RETURN id_;
END Add_Compound_Attribute___;


-- Add a document to a compound attribute (an aggregate or array)
FUNCTION Add_Document___ (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   namespace_ IN     VARCHAR2,
   parent_id_ IN     Element_Id ) RETURN Element_Id
IS
   id_ Element_Id;
BEGIN
   Check_Document___(main_);
   Check_Empty___('Document name', name_);
   -- a document can only be added to a compound attribute
   Check_Parent_Type___(main_, parent_id_, TYPE_COMPOUND);
   id_ := New_Element___(main_, name_, namespace_, TYPE_DOCUMENT);
   Add_Child___(main_, parent_id_, id_);
   RETURN id_;
END Add_Document___;


-- Set value of an existing simple attribute
PROCEDURE Set_Value___ (
   main_     IN OUT Document,
   id_       IN     Element_Id,
   type_     IN     VARCHAR2,
   text_val_ IN     VARCHAR2,
   clob_val_ IN     CLOB DEFAULT NULL )
IS
   text_ VARCHAR2(32767) := NULL;
   clob_ CLOB := NULL;
BEGIN
   Check_Document___(main_);
   IF main_.elements(id_).type IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCNSIMPL: Can not set value for a compound attribute or document');
   END IF;
   Define_Value___(text_, clob_, text_val_, clob_val_);
   main_.elements(id_).value := text_;
   main_.elements(id_).clob_val := clob_;
   main_.elements(id_).type := type_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Set_Value___;


-- Return descriptive name for the given type marker
FUNCTION Get_Type_Name___ (
   type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE type_
      WHEN TYPE_TEXT      THEN RETURN 'Text';
      WHEN TYPE_INTEGER   THEN RETURN 'Integer';
      WHEN TYPE_FLOAT     THEN RETURN 'Float';
      WHEN TYPE_BOOLEAN   THEN RETURN 'Boolean';
      WHEN TYPE_BINARY    THEN RETURN 'Binary';
      WHEN TYPE_DATE      THEN RETURN 'Date';
      WHEN TYPE_TIME      THEN RETURN 'Time';
      WHEN TYPE_TIMESTAMP THEN RETURN 'Timestamp';
      WHEN TYPE_COMPOUND  THEN RETURN 'Compound';
      WHEN TYPE_DOCUMENT  THEN RETURN 'Document';
      ELSE                     RETURN 'Unknown';
   END CASE;
END Get_Type_Name___;


-- Return type marker for a given type description.
FUNCTION Get_Type_Id___ (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE name_
      WHEN 'Text'        THEN RETURN TYPE_TEXT;
      WHEN 'Long_Text'   THEN RETURN TYPE_TEXT;
      WHEN 'CLOB'        THEN RETURN TYPE_TEXT;
      WHEN 'Alpha'       THEN RETURN TYPE_TEXT;
      WHEN 'Enumeration' THEN RETURN TYPE_TEXT;
      WHEN 'Integer'     THEN RETURN TYPE_INTEGER;
      WHEN 'Float'       THEN RETURN TYPE_FLOAT;
      WHEN 'Decimal'     THEN RETURN TYPE_FLOAT;
      WHEN 'Boolean'     THEN RETURN TYPE_BOOLEAN;
      WHEN 'Binary'      THEN RETURN TYPE_BINARY;
      WHEN 'BLOB'        THEN RETURN TYPE_BINARY;
      WHEN 'Date'        THEN RETURN TYPE_DATE;
      WHEN 'Time'        THEN RETURN TYPE_TIME;
      WHEN 'Timestamp'   THEN RETURN TYPE_TIMESTAMP;
      WHEN 'TimeStamp'   THEN RETURN TYPE_TIMESTAMP;
      WHEN 'Compound'    THEN RETURN TYPE_COMPOUND;
      WHEN 'Document'    THEN RETURN TYPE_DOCUMENT;
      ELSE               RETURN NULL;
   END CASE;
END Get_Type_Id___;


-- Convert a name from IFS XML format (upper case with underscores)
-- to Camel Case format. If 'init_lower_' is TRUE the first
-- character will be in lower case.
FUNCTION To_Camel_Case___ (
   name_       IN VARCHAR2,
   init_upper_ IN BOOLEAN ) RETURN VARCHAR2
IS
   -- IFS XML should only have, letters, numbers and underscores.
   -- Remove other characters that are usually allowed in XML names.
   temp_ VARCHAR2(4000) := ltrim(rtrim(upper(translate(name_, '.-', '__')), '_'), '_');
BEGIN
   temp_ := replace(initcap(temp_),'_','');
   IF init_upper_ THEN
      RETURN temp_;
   ELSE
      RETURN lower(substr(temp_, 1, 1)) || substr(temp_, 2);
   END IF;
END To_Camel_Case___;


-- Convert a name from Camel Case format to
-- IFS XML format (uppercase with undescores).
FUNCTION To_Upper_Case___(
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- Remove any special characters that are allowed in XMLs before converting to IFS XML
   temp_   VARCHAR2(4000) := replace(replace(replace(name_,'_',''),'.',''),'-','');
   ch_     VARCHAR2(1);
   result_ VARCHAR2(4000);
BEGIN
   FOR i IN 1..length(temp_) LOOP
      ch_ := substr(temp_, i, 1);
      IF ch_ = upper(ch_) AND ch_ <> lower(ch_) AND i > 1 THEN
         result_ := result_ || '_';
      END IF;
      result_ := result_ || upper(ch_);
   END LOOP;
   RETURN result_;
END To_Upper_Case___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Document
-- Create a new document with name denoted by the 'name_' argument
-- with optional namespace name specification.
-- If 'array_' is TRUE the document will represent an array of documents
-- rather than a single document.
FUNCTION New_Document (
   name_      IN VARCHAR2,
   array_     IN BOOLEAN  DEFAULT FALSE,
   namespace_ IN VARCHAR2 DEFAULT NULL ) RETURN Document
IS
   main_  Document;
BEGIN
   Check_Empty___('Document name', name_);
   main_.root_id := New_Element___(main_, name_, namespace_, CASE array_ WHEN TRUE THEN TYPE_COMPOUND ELSE TYPE_DOCUMENT END);
   RETURN main_;
END New_Document;


-- New_Document
-- Create a new document
PROCEDURE New_Document (
   main_      OUT Document,
   name_      IN  VARCHAR2,
   array_     IN  BOOLEAN  DEFAULT FALSE,
   namespace_ IN  VARCHAR2 DEFAULT NULL)
IS
BEGIN
   main_ := New_Document(name_, array_, namespace_);
END New_Document;


-- Add_Attribute
-- Add a text attribute
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     VARCHAR2,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, value_, TYPE_TEXT, parent_id_);
END Add_Attribute;


-- Add_Attribute
-- Add a text attribute
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     VARCHAR2,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, namespace_);
END Add_Attribute;


-- Add_Attribute
-- Add a number attribute. Allowed subtypes are TYPE_INTEGER, TYPE_FLOAT
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     NUMBER,
   parent_id_ IN     Element_Id DEFAULT NULL,
   type_      IN     VARCHAR2   DEFAULT TYPE_FLOAT,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   Validate_Number_Type___(type_);
   Validate_Value_Type___(value_, type_);
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, TO_CHAR(value_), type_, parent_id_);
END Add_Attribute;


-- Add_Attribute
-- Add a number attribute. Allowed subtypes are TYPE_INTEGER, TYPE_FLOAT
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     NUMBER,
   parent_id_ IN     Element_Id DEFAULT NULL,
   type_      IN     VARCHAR2   DEFAULT TYPE_FLOAT,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, type_, namespace_);
END Add_Attribute;


-- Add_Attribute
-- Add a boolean attribute. Note that NULL is treated as FALSE.
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     BOOLEAN,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, CASE nvl(value_, FALSE) WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END, TYPE_BOOLEAN, parent_id_);
END Add_Attribute;


-- Add_Attribute
-- Add a boolean attribute. Note that NULL is treated as FALSE.
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     BOOLEAN,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;  
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, namespace_);
END Add_Attribute;


-- Add_Attribute
-- Add a date attribute. Allowed subtypes are: TYPE_DATE, TYPE_TIME and TYPE_TIMESTAMP.
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     DATE,
   parent_id_ IN     Element_Id DEFAULT NULL,
   type_      IN     VARCHAR2   DEFAULT TYPE_TIMESTAMP,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, TO_CHAR(value_, Get_Date_Format___(type_)), type_, parent_id_);
END Add_Attribute;


-- Add_Attribute
-- Add a date attribute. Allowed subtypes are: TYPE_DATE, TYPE_TIME and TYPE_TIMESTAMP.
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     DATE,
   parent_id_ IN     Element_Id DEFAULT NULL,
   type_      IN     VARCHAR2   DEFAULT TYPE_TIMESTAMP,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, type_, namespace_);
END Add_Attribute;


-- Add_Attribute
-- Add a large text (CLOB) attribute. If the text is shorter than 32767
-- bytes it will be stored as VARCHAR2.
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     CLOB,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, NULL, TYPE_TEXT, parent_id_, value_);
END Add_Attribute;


-- Add_Attribute
-- Add a large text (CLOB) attribute. If the text is shorter than 32767
-- bytes it will be stored as VARCHAR2.
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     CLOB,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, namespace_);
END Add_Attribute;


-- Add_Attribute
-- Add a binary (BLOB) attribute. The value will be encoded to Base64 text.
-- If the resulting text is shorter than 32767 bytes, it will be stored as VARCHAR2.
FUNCTION Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     BLOB,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Simple_Attribute___(main_, name_, namespace_, NULL, TYPE_BINARY, parent_id_, To_Base64___(value_));
END Add_Attribute;


-- Add_Attribute
-- Add a binary (BLOB) attribute. The value will be encoded to Base64 text.
-- If the resulting text is shorter than 32767 bytes, it will be stored as VARCHAR2.
PROCEDURE Add_Attribute (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   value_     IN     BLOB,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL )
IS
   dummy_ Element_Id;
BEGIN
   dummy_ := Add_Attribute(main_, name_, value_, parent_id_, namespace_);
END Add_Attribute;


-- Add_Aggregate
-- Add an aggregate (compound attribute) with name 'name_' containing
-- document 'doc_name_'. If 'name_' is null, 'doc_name_' will be used
-- as aggregate name.
FUNCTION Add_Aggregate (
   main_          IN OUT Document,
   name_          IN     VARCHAR2,
   doc_name_      IN     VARCHAR2,
   parent_id_     IN     Element_Id DEFAULT NULL,
   namespace_     IN     VARCHAR2   DEFAULT NULL,
   doc_namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
   aggr_id_ Element_Id;
BEGIN
   aggr_id_ := Add_Compound_Attribute___(main_, nvl(name_, doc_name_), namespace_, parent_id_);
   RETURN Add_Document___(main_, doc_name_, doc_namespace_, aggr_id_);
END Add_Aggregate;


-- Add_Aggregate
-- Add an aggregate (compound attribute) containing document 'doc_name_'.
-- Aggregate name will be same as document name.
FUNCTION Add_Aggregate (
   main_          IN OUT Document,
   doc_name_      IN     VARCHAR2,
   parent_id_     IN     Element_Id DEFAULT NULL,
   namespace_     IN     VARCHAR2   DEFAULT NULL,
   doc_namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Aggregate(main_, NULL, doc_name_, parent_id_, namespace_, doc_namespace_);
END Add_Aggregate;


-- Add_Array
-- Add an array (compound attribute) with name 'name_'.
FUNCTION Add_Array (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   parent_id_ IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL ) RETURN Element_Id
IS
BEGIN
   RETURN Add_Compound_Attribute___(main_, name_, namespace_, parent_id_);
END Add_Array;


-- Add_Document
-- Add a document to an array (compound attribute).
-- If 'array_id_' is NULL the document will be added to the top
-- level array, i.e. PLAP Document created with 'array_' TRUE.
FUNCTION Add_Document (
   main_      IN OUT Document,
   name_      IN     VARCHAR2,
   array_id_  IN     Element_Id DEFAULT NULL,
   namespace_ IN     VARCHAR2   DEFAULT NULL) RETURN Element_Id
IS
BEGIN
   RETURN Add_Document___(main_, name_, namespace_, nvl(array_id_, main_.root_id));
END Add_Document;


-- Add_Xml_Attribute
-- Add an optional XML attribute to an element.
-- Note that XML attributes are not used by the IFS framework.
PROCEDURE Add_Xml_Attribute (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2 )
IS
   xml_attr_ Xml_Attribute;
   pos_      BINARY_INTEGER;
BEGIN
   Check_Document___(main_);
   Check_Empty___('XML attribute name', name_);
   Check_Name___(name_, TRUE);
   IF NOT main_.elements.exists(id_) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   END IF;

   xml_attr_.name := name_;
   xml_attr_.value := value_;
   IF main_.xml_attrs.exists(id_) THEN
      FOR i IN 1..main_.xml_attrs(id_).COUNT LOOP
         IF main_.xml_attrs(id_)(i).name = name_ THEN
            Error_SYS.Appl_General(lu_name_, 'PLAPDOCDUPXATTR: XML attribute [:P1] already exists within element [:P2]', name_, Get_Name(main_, id_));
         END IF;
      END LOOP;
      pos_ := main_.xml_attrs(id_).count + 1;
   ELSE
      DECLARE
         attr_table_ Xml_Attr_Table;
      BEGIN
         main_.xml_attrs(id_) := attr_table_;
         pos_ := 1;
      END;
   END IF;
   main_.xml_attrs(id_)(pos_) := xml_attr_;
END Add_Xml_Attribute;


-- Add_Xml_Attribute
-- Add an optional XML attribute to the root element.
-- Note that XML attributes are not used by the IFS framework.
PROCEDURE Add_Xml_Attribute (
   main_  IN OUT Document,
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2 )
IS
BEGIN
   Add_Xml_Attribute(main_, main_.root_id, name_, value_);
END Add_Xml_Attribute;


-- Get_Root_Id
-- Return ID of the root element.
FUNCTION Get_Root_Id (
   main_ IN Document ) RETURN Element_Id
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.root_id;
END Get_Root_Id;


-- Get_Element_Count
-- Return the total number of elements within the document.
FUNCTION Get_Element_Count (
   main_ IN Document ) RETURN BINARY_INTEGER
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements.count;
END Get_Element_Count;


-- Find_Element_Id
-- Find an ID of an element denoted by its path. Path can be just a child element name
-- or a sequence of nested element names separated by slashes '/'.
-- Searching starts from given parent element.
-- The parent document name should not be included.
-- This method will return NULL if element is not found or parent ID is NULL.
FUNCTION Find_Element_Id (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN Element_Id
IS
   p1_   INTEGER := 1;
   p2_   INTEGER;
   len_  INTEGER := length(path_);
   name_ VARCHAR2(4000);
   id_   Element_Id := parent_id_;
   cnt_  INTEGER;
BEGIN
   Check_Document___(main_);
   Check_Empty___('Element path', path_);
   IF parent_id_ IS NULL THEN
      RETURN NULL;
   END IF;
   WHILE p1_ <= len_ LOOP
      p2_ := instr(path_, '/', p1_);
      IF p2_ = 0 THEN
         p2_ := len_ + 1;
      END IF;
      name_ := substr(path_, p1_, p2_ - p1_);
      cnt_ := main_.elements(id_).children.count;
      IF cnt_ = 0 THEN
         RETURN NULL;
      END IF;
      FOR i IN 1..cnt_ LOOP
         IF main_.elements(main_.elements(id_).children(i)).name = name_ THEN
            id_ := main_.elements(id_).children(i);
            EXIT;
         END IF;
         IF i = cnt_ THEN
            RETURN NULL;
         END IF;
      END LOOP;
      p1_ := p2_ + 1;
   END LOOP;
   RETURN id_;
END Find_Element_Id;


-- Find_Element_Id
-- Find an ID of an element denoted by its path. Path can be just a child element name
-- or a sequence of nested element names separated by slashes '/'.
-- Searching starts from root.
-- The document name should not be included.
-- This method will return NULL if element is not found.
FUNCTION Find_Element_Id (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN Element_Id
IS
BEGIN
   RETURN Find_Element_Id(main_, path_, main_.root_id);
END Find_Element_Id;


-- Get_Element_Id
-- Return an element ID denoted by its path. Path can be just a child element name
-- or a sequence of nested element names separated by slashes '/'.
-- Searching starts from given parent element.
-- The parent document name should not be included.
FUNCTION Get_Element_Id (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN Element_Id
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   IF id_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCNOELEM: Element denoted by path [:P1] not found', path_);
   END IF;
   RETURN id_;
END Get_Element_Id;


-- Get_Element_Id
-- Return an element ID denoted by its path. Path can be just a child element name
-- or a sequence of nested element names separated by slashes '/'.
-- Searching starts from root.
-- The document name should not be included.
FUNCTION Get_Element_Id (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN Element_Id
IS
BEGIN
   RETURN Get_Element_Id(main_, path_, main_.root_id);
END Get_Element_Id;


-- Get_Value
-- Get attribute value as text
FUNCTION Get_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN VARCHAR2
IS
BEGIN
   Check_Document___(main_);
   IF main_.elements(id_).type IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCCOMP: Can not retrieve value for a compound attribute or document');
   END IF;
   IF main_.elements(id_).clob_val IS NOT NULL THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCCLOB: Value too large to be contained in VARCHAR2');
   END IF;
   RETURN main_.elements(id_).value;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Value;


-- Get_Value
-- Get value of an attribute denoted by its path as text
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN VARCHAR2
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Value(main_, id_) END;
END Get_Value;


-- Get_Value
-- Get value of an attribute denoted by its path as text
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Value(main_, path_, main_.root_id);
END Get_Value;


-- Get_Number_Value
-- Get attribute value as number
FUNCTION Get_Number_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN NUMBER
IS
BEGIN
   RETURN To_Number(Get_Value(main_, id_));
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCPNOTNUM: Element [:P1] with value ":P2" is not a number', Get_Name(main_, id_), Get_Value(main_, id_));
END Get_Number_Value;


-- Get_Number_Value
-- Get value of an attribute denoted by its path as number
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Number_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN NUMBER
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Number_Value(main_, id_) END;
END Get_Number_Value;


-- Get_Number_Value
-- Get value of an attribute denoted by its path as number
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Number_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Number_Value(main_, path_, main_.root_id);
END Get_Number_Value;


-- Get_Boolean_Value
-- Get attribute value as boolean
FUNCTION Get_Boolean_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BOOLEAN
IS
   value_ VARCHAR2(5) := Get_Value(main_, id_);
BEGIN
   RETURN CASE upper(nvl(value_,'FALSE')) WHEN 'TRUE' THEN TRUE ELSE FALSE END;
END Get_Boolean_Value;


-- Get_Boolean_Value
-- Get value of an attribute denoted by its path as boolean
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Boolean_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN BOOLEAN
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Boolean_Value(main_, id_) END;
END Get_Boolean_Value;


-- Get_Boolean_Value
-- Get value of an attribute denoted by its path as boolean
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Boolean_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Get_Boolean_Value(main_, path_, main_.root_id);
END Get_Boolean_Value;


-- Get_Date_Value
-- Get attribute value as date
FUNCTION Get_Date_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN DATE
IS
BEGIN
   RETURN To_Date___(main_, id_, Get_Value(main_, id_), TYPE_DATE);
END Get_Date_Value;


-- Get_Date_Value
-- Get value of an attribute denoted by its path as date
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Date_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN DATE
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Date_Value(main_, id_) END;
END Get_Date_Value;


-- Get_Date_Value
-- Get value of an attribute denoted by its path as date
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Date_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Date_Value(main_, path_, main_.root_id);
END Get_Date_Value;


-- Get_Time_Value
-- Get attribute value as time
FUNCTION Get_Time_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN DATE
IS
BEGIN
   RETURN To_Date___(main_, id_, Get_Value(main_, id_), TYPE_TIME);
END Get_Time_Value;


-- Get_Time_Value
-- Get value of an attribute denoted by its path as time
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Time_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN DATE
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Time_Value(main_, id_) END;
END Get_Time_Value;


-- Get_Time_Value
-- Get value of an attribute denoted by its path as time
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Time_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Time_Value(main_, path_, main_.root_id);
END Get_Time_Value;


-- Get_Timestamp_Value
-- Get attribute value as timestamp
FUNCTION Get_Timestamp_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN DATE
IS
BEGIN
   RETURN To_Date___(main_, id_, Get_Value(main_, id_), TYPE_TIMESTAMP);
END Get_Timestamp_Value;


-- Get_Timestamp_Value
-- Get value of an attribute denoted by its path as timestamp
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Timestamp_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN DATE
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Timestamp_Value(main_, id_) END;
END Get_Timestamp_Value;


-- Get_Timestamp_Value
-- Get value of an attribute denoted by its path as timestamp
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Timestamp_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Timestamp_Value(main_, path_, main_.root_id);
END Get_Timestamp_Value;


-- Get_Clob_Value
-- Get attribute value as large text (CLOB)
FUNCTION Get_Clob_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN CLOB
IS
BEGIN
   Check_Document___(main_);
   IF main_.elements(id_).type IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCCOMP: Can not retrieve value for a compound attribute or document');
   END IF;
   IF main_.elements(id_).value IS NOT NULL THEN
      RETURN main_.elements(id_).value;
   ELSE
      RETURN main_.elements(id_).clob_val;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Clob_Value;


-- Get_Clob_Value
-- Get value of an attribute denoted by its path as large text (CLOB)
-- starting from given parent element.
-- Return NULL if element is not found.
FUNCTION Get_Clob_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN CLOB
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Clob_Value(main_, id_) END;
END Get_Clob_Value;


-- Get_Clob_Value
-- Get value of an attribute denoted by its path as large text (CLOB)
-- starting from root.
-- Return NULL if element is not found.
FUNCTION Get_Clob_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN CLOB
IS
BEGIN
   RETURN Get_Clob_Value(main_, path_, main_.root_id);
END Get_Clob_Value;


-- Get_Blob_Value
-- Get attribute value as binary (BLOB). Value is supposed
-- to be stored as Base64 encoded text.
FUNCTION Get_Blob_Value (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BLOB
IS
BEGIN
   RETURN From_Base64___(Get_Clob_Value(main_, id_));
END Get_Blob_Value;


-- Get_Blob_Value
-- Get value of an attribute denoted by its path as binary (BLOB)
-- starting from given parent element.
-- Value is supposed to be stored as Base64 encoded text.
-- Return NULL if element is not found.
FUNCTION Get_Blob_Value (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN BLOB
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Blob_Value(main_, id_) END;
END Get_Blob_Value;


-- Get_Blob_Value
-- Get value of an attribute denoted by its path as binary (BLOB)
-- starting from root.
-- Value is supposed to be stored as Base64 encoded text.
-- Return NULL if element is not found.
FUNCTION Get_Blob_Value (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN BLOB
IS
BEGIN
   RETURN Get_Blob_Value(main_, path_, main_.root_id);
END Get_Blob_Value;


-- Get_Xml_Attribute
-- Get value of an optional XML attribute or NULL if doesn't exist.
FUNCTION Get_Xml_Attribute (
   main_ IN Document,
   id_   IN Element_Id,
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF main_.xml_attrs.exists(id_) THEN
      FOR i IN 1..main_.xml_attrs(id_).COUNT LOOP
         IF main_.xml_attrs(id_)(i).name = name_ THEN
            RETURN main_.xml_attrs(id_)(i).value;
         END IF;
      END LOOP;
   END IF;
   RETURN NULL;
END Get_Xml_Attribute;


-- Get_Xml_Attribute
-- Get value of an optional XML attribute or NULL if doesn't exist.
FUNCTION Get_Xml_Attribute (
   main_ IN Document,
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Xml_Attribute(main_, main_.root_id, name_);
END Get_Xml_Attribute;


-- Get_Xml_Attributes
-- Return collection with all XML attributes for the given element.
FUNCTION Get_Xml_Attributes (
   main_ IN Document,
   id_   IN Element_Id ) RETURN Xml_Attr_Table
IS
BEGIN
   IF main_.xml_attrs.exists(id_) THEN
      RETURN main_.xml_attrs(id_);
   END IF;
   RETURN CAST(NULL AS Xml_Attr_Table);
END Get_Xml_Attributes;


-- Get_Xml_Attributes
-- Return collection with all XML attributes for the given element.
FUNCTION Get_Xml_Attributes (
   main_ IN Document ) RETURN Xml_Attr_Table
IS
BEGIN
   RETURN Get_Xml_Attributes(main_, main_.root_id);
END Get_Xml_Attributes;


-- Is_Initialized
-- Return TRUE if the document has been initialized
FUNCTION Is_Initialized (
   main_ IN Document ) RETURN BOOLEAN
IS
BEGIN
   RETURN main_.root_id IS NOT NULL;
END Is_Initialized;


-- Is_Simple
-- Return TRUE if the element denoted by it's ID is a simple attribute.
FUNCTION Is_Simple (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BOOLEAN
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).type NOT IN (TYPE_COMPOUND, TYPE_DOCUMENT);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Is_Simple;


-- Is_Compound
-- Return TRUE if the element denoted by it's ID is a compound attribute, i.e. an array or aggregate
FUNCTION Is_Compound (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BOOLEAN
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).type = TYPE_COMPOUND;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Is_Compound;


-- Is_Document
-- Return TRUE if the element denoted by it's ID is a document.
FUNCTION Is_Document (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BOOLEAN
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).type = TYPE_DOCUMENT;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Is_Document;


-- Is_Null
-- Return TRUE if element value is NULL.
FUNCTION Is_Null (
   main_  IN Document,
   id_    IN Element_Id ) RETURN BOOLEAN
IS
BEGIN
   Check_Document___(main_);
   IF main_.elements(id_).type IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCCOMP: Can not retrieve value for a compound attribute or document');
   END IF;
   RETURN main_.elements(id_).value IS NULL AND main_.elements(id_).clob_val IS NULL;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Is_Null;


-- Get_Name
-- Return element name
FUNCTION Get_Name (
   main_  IN Document,
   id_    IN Element_Id) RETURN VARCHAR2
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).name;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Name;


-- Get_Namespace
-- Return element namespace
FUNCTION Get_Namespace (
   main_  IN Document,
   id_    IN Element_Id) RETURN VARCHAR2
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).namespace;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Namespace;


-- Get_Document_Name
-- Return the document name
FUNCTION Get_Document_Name (
   main_ IN Document ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Name(main_, main_.root_id);
END Get_Document_Name;


-- Get_Type
-- Return type name for the given element.
FUNCTION Get_Type (
   main_  IN Document,
   id_    IN Element_Id ) RETURN VARCHAR2
IS
BEGIN
   Check_Document___(main_);
   RETURN Get_Type_Name___(main_.elements(id_).type);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Type;


-- Get_Child_Elements
-- Return collection with all child elements for the given element.
FUNCTION Get_Child_Elements (
   main_  IN Document,
   id_    IN Element_Id ) RETURN Child_Table
IS
BEGIN
   Check_Document___(main_);
   RETURN main_.elements(id_).children;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Get_Child_Elements;


-- Get_Child_Elements
-- Return collection with all child elements for the root element.
FUNCTION Get_Child_Elements (
   main_ IN Document ) RETURN Child_Table
IS
BEGIN
   RETURN Get_Child_Elements(main_, main_.root_id);
END Get_Child_Elements;


-- Get_Child_Elements
-- Return collection with all child elements for an element denoted by its path
-- starting from given parent element.
-- Return NULL (empty table) if element is not found.
FUNCTION Get_Child_Elements (
   main_      IN Document,
   path_      IN VARCHAR2,
   parent_id_ IN Element_Id ) RETURN Child_Table
IS
   id_ Element_Id := Find_Element_Id(main_, path_, parent_id_);
BEGIN
   RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Get_Child_Elements(main_, id_) END;
END Get_Child_Elements;


-- Get_Child_Elements
-- Return collection with all child elements for an element denoted by its path
-- starting from root.
-- Return NULL (empty table) if element is not found.
FUNCTION Get_Child_Elements (
   main_ IN Document,
   path_ IN VARCHAR2 ) RETURN Child_Table
IS
BEGIN
   RETURN Get_Child_Elements(main_, path_, main_.root_id);
END Get_Child_Elements;


-- Set_Value
-- Set a text value of a simple attribute.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     VARCHAR2 )
IS
BEGIN
   Set_Value___(main_, id_, TYPE_TEXT, value_);
END Set_Value;


-- Set_Value
-- Set a number value of a simple attribute.
-- Allowed subtypes are TYPE_INTEGER, TYPE_FLOAT.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     NUMBER,
   type_  IN     VARCHAR2 DEFAULT TYPE_FLOAT )
IS
BEGIN
   Validate_Number_Type___(type_);
   Set_Value___(main_, id_, type_, TO_CHAR(value_));
END Set_Value;


-- Set_Value
-- Set a boolean value of a simple attribute.
-- Note that NULL is treated as FALSE.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     BOOLEAN )
IS
BEGIN
   Set_Value___(main_, id_, TYPE_BOOLEAN, CASE nvl(value_, FALSE) WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END);
END Set_Value;


-- Set_Value
-- Set a date value of a simple attribute.
-- Allowed subtypes are: TYPE_DATE, TYPE_TIME and TYPE_TIMESTAMP.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     DATE,
   type_  IN     VARCHAR2 DEFAULT TYPE_TIMESTAMP )
IS
BEGIN
   Set_Value___(main_, id_, type_, TO_CHAR(value_, Get_Date_Format___(type_)));
END Set_Value;


-- Set_Value
-- Set a large text (CLOB) value of a simple attribute.
-- If the text is shorter than 32767 bytes, it will be stored as VARCHAR2.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     CLOB )
IS
BEGIN
   Set_Value___(main_, id_, TYPE_TEXT, NULL, value_);
END Set_Value;


-- Set_Value
-- Set a binary (BLOB) value of a simple attribute.
-- The value will be encoded to Base64 text.
-- If the resulting text is shorter than 32767 bytes, it will be stored as VARCHAR2.
PROCEDURE Set_Value (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   value_ IN     BLOB )
IS
BEGIN
   Set_Value___(main_, id_, TYPE_BINARY, NULL, To_Base64___(value_));
END Set_Value;


-- Set_Xml_Attribute
PROCEDURE Set_Xml_Attribute (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2 )
IS
BEGIN
   Check_Document___(main_);
   IF NOT main_.elements.exists(id_) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   END IF;

   IF main_.xml_attrs.exists(id_) THEN
      FOR i IN 1..main_.xml_attrs(id_).count LOOP
         IF main_.xml_attrs(id_)(i).name = name_ THEN
            main_.xml_attrs(id_)(i).value := value_;
            RETURN;
         END IF;
      END LOOP;
   END IF;
   Error_SYS.Appl_General(lu_name_, 'PLAPDOCXATTRNEX: XML attribute [:P1] does not exist within element [:P2]', name_, Get_Name(main_, id_));
END Set_Xml_Attribute;


-- Set_Xml_Attribute
PROCEDURE Set_Xml_Attribute (
   main_  IN OUT Document,
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2 )
IS
BEGIN
   Set_Xml_Attribute(main_, main_.root_id, name_, value_);
END Set_Xml_Attribute;


-- Rename
-- Change the name of an existing element denoted by it's ID.
PROCEDURE Rename (
   main_  IN OUT Document,
   id_    IN     Element_Id,
   name_  IN     VARCHAR2 )
IS
BEGIN
   Check_Document___(main_);
   Check_Empty___('Attribute name', name_);
   Check_Name___(name_);
   main_.elements(id_).name := name_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENOTF: Element ID [:P1] not found', id_);
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCENULL: Element ID must not be NULL');
END Rename;


-- Rename
-- Rename all elements with name defined in 'from_' to 'to_'.
-- Limit the process to category/categories defined by the
-- boolean parameters:
-- if 'simple_' is TRUE rename simple attributes,
-- if 'compound_' is TRUE rename compound attributes,
-- if 'document_' is TRUE rename documents.
PROCEDURE Rename (
   main_     IN OUT Document,
   from_     IN     VARCHAR2,
   to_       IN     VARCHAR2,
   simple_   IN     BOOLEAN DEFAULT FALSE,
   compound_ IN     BOOLEAN DEFAULT FALSE,
   document_ IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Document___(main_);
   Check_Empty___('From name', from_);
   Check_Empty___('To name', to_);
   Check_Name___(to_);
   FOR i IN 1..main_.elements.count LOOP
      IF main_.elements(i).name = from_ THEN
         IF document_ AND main_.elements(i).type = TYPE_DOCUMENT OR
            compound_ AND main_.elements(i).type = TYPE_COMPOUND OR
            simple_   AND main_.elements(i).type NOT IN (TYPE_DOCUMENT, TYPE_COMPOUND)
         THEN
            main_.elements(i).name := to_;
         END IF;
      END IF;
   END LOOP;
END Rename;


-- Remove_Namespaces
-- Remove namespaces from the entire document.
PROCEDURE Remove_Namespaces (
   main_ IN OUT Document)
IS
   attr_name_ VARCHAR2(200);
BEGIN
   FOR i IN 1..main_.elements.count LOOP
      main_.elements(i).namespace := NULL;

      IF main_.xml_attrs.exists(main_.elements(i).id) THEN
         FOR j IN REVERSE 1..main_.xml_attrs(main_.elements(i).id).count LOOP
            attr_name_ := LOWER(main_.xml_attrs(main_.elements(i).id)(j).name);
            IF attr_name_ = 'xmlns' OR attr_name_ LIKE 'xmlns:%' THEN
               main_.xml_attrs(main_.elements(i).id).delete(j);
            END IF;
         END LOOP;
         IF main_.xml_attrs(main_.elements(i).id).count = 0 THEN
            main_.xml_attrs.delete(main_.elements(i).id);
         END IF;
      END IF;
   END LOOP;
END Remove_Namespaces;


-- To_Camel_Case
-- Convert all element names in the document from IFS XML
-- format (upper case with underscores) to Camel Case format.
-- If 'init_lower_' is TRUE the first character will be in lower case.
PROCEDURE To_Camel_Case (
   main_       IN OUT Document,
   init_upper_ IN     BOOLEAN DEFAULT TRUE,
   namespace_  IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Document___(main_);
   FOR i IN 1..main_.elements.count LOOP
      main_.elements(i).name := To_Camel_Case___(main_.elements(i).name, init_upper_);
   END LOOP;

   IF namespace_ THEN
      FOR i IN 1..main_.elements.count LOOP
         IF main_.elements(i).namespace IS NOT NULL THEN
            main_.elements(i).namespace := To_Camel_Case___(main_.elements(i).namespace, init_upper_);
         END IF;
      END LOOP;
   END IF;
END To_Camel_Case;


-- To_Upper_Case
-- Convert all element names in the document from Camel Case
-- format to IFS XML format (uppercase with undescores).
PROCEDURE To_Upper_Case (
   main_      IN OUT Document,
   namespace_ IN     BOOLEAN DEFAULT FALSE)
IS
BEGIN
   Check_Document___(main_);
   FOR i IN 1..main_.elements.count LOOP
      main_.elements(i).name := To_Upper_Case___(main_.elements(i).name);
   END LOOP;

   IF namespace_ THEN
      FOR i IN 1..main_.elements.count LOOP
         IF main_.elements(i).namespace IS NOT NULL THEN
            main_.elements(i).namespace := To_Upper_Case___(main_.elements(i).namespace);
         END IF;
      END LOOP;
   END IF;
END To_Upper_Case;


-- To_Json
-- Format document to a JSON structure-
-- 'indent_' defines indentation and line breaks. If NULL the JSON will be generated in
-- a single line. May not be negative.
-- If 'use_crlf_' is TRUE the CRLF sequence will be used instead of LF for new line.
PROCEDURE To_Json (
   json_     OUT CLOB,
   main_     IN  Document,
   indent_   IN  NUMBER  DEFAULT NULL,
   use_crlf_ IN  BOOLEAN DEFAULT FALSE )
IS
   nl_   VARCHAR2(2);
   buf_  VARCHAR2(32767);

   PROCEDURE Append(str_ VARCHAR2) IS
   BEGIN
      buf_ := buf_ || str_;
   EXCEPTION
      WHEN value_error THEN
         Dbms_Lob.WriteAppend(json_, length(buf_), buf_);
         buf_ := str_;
   END;

   FUNCTION Encode_Clob_Value (value_ IN CLOB) RETURN CLOB IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(replace(replace(value_,chr(8),'\b'),chr(9),'\t'),chr(10),'\n'),chr(12),'\f'),chr(13),'\r'),chr(34),'\"'),chr(92),'\\');
   END;

   FUNCTION Encode_Text_Value (value_ IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(replace(replace(value_,chr(8),'\b'),chr(9),'\t'),chr(10),'\n'),chr(12),'\f'),chr(13),'\r'),'\','\\'),chr(34),'\"');
   END;

   PROCEDURE Append_Element (element_ IN Element, level_ IN NUMBER) IS
      cnt_  BINARY_INTEGER := element_.children.count;
      name_ VARCHAR2(4000) := element_.name;
      quot_ VARCHAR2(1);

      PROCEDURE Append_Clob_Value (value_ CLOB) IS
      BEGIN
         Append(rpad(' ', level_)||'"'||name_||'":'||quot_);
         Dbms_Lob.WriteAppend(json_, length(buf_), buf_);
         Dbms_Lob.Append(json_, CASE element_.type = TYPE_BINARY WHEN TRUE THEN value_ ELSE Encode_Clob_Value(value_) END);
         buf_ := quot_;
      END;

   BEGIN
      IF element_.type NOT IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN -- simple attribute
         IF element_.type IN (TYPE_INTEGER, TYPE_FLOAT, TYPE_BOOLEAN) THEN
            quot_ := '';
         ELSE
            quot_ := '"';
         END IF;
         IF element_.type = TYPE_BOOLEAN THEN
            Append(rpad(' ', level_)||'"'||name_||'":'||lower(element_.value));
         ELSE
            IF element_.value IS NOT NULL THEN
               BEGIN
                  Append(rpad(' ', level_)||'"'||name_||'":'||quot_||CASE element_.type = TYPE_BINARY WHEN TRUE THEN element_.value ELSE Encode_Text_Value(element_.value) END||quot_);
               EXCEPTION
                  WHEN value_error THEN
                     Append_Clob_Value(element_.value);
               END;
            ELSIF element_.clob_val IS NOT NULL THEN
               Append_Clob_Value(element_.clob_val);
            ELSE
               Append(rpad(' ', level_)||'"'||name_||'":null');
            END IF;
         END IF;
      ELSE -- compound attribute or document
         IF element_.type = TYPE_DOCUMENT THEN
            Append(rpad(' ', level_)||'{"'||name_||'":{'||nl_);
         ELSIF element_.type = TYPE_COMPOUND THEN
            IF(level_ = 0) THEN
                Append(rpad(' ', level_)||'{"'||name_||'":['||nl_);
            ELSE
                Append(rpad(' ', level_)||'"'||name_||'":['||nl_);
            END IF;
         END IF;
         FOR ix_ IN 1..cnt_ LOOP
            Append_Element(main_.elements(element_.children(ix_)), level_+indent_);
            IF ix_ < cnt_ THEN
               Append(','||nl_);
            ELSE
               Append(nl_);
            END IF;
         END LOOP;
         IF element_.type = TYPE_DOCUMENT THEN
            Append(rpad(' ', level_)||'}}');
         ELSIF element_.type = TYPE_COMPOUND THEN
             IF(level_ = 0) THEN
                 Append(rpad(' ', level_)||']}');
             ELSE
                Append(rpad(' ', level_)||']');
             END IF;
         END IF;
      END IF;
   END;

BEGIN
   IF indent_ IS NOT NULL THEN
      IF indent_ < 0 THEN
         Error_SYS.Appl_General(lu_name_, 'PLAPDOCIND: Indent [:P1] may not be less than zero', indent_);
      END IF;
      nl_ := CASE use_crlf_ WHEN TRUE THEN chr(13)||chr(10) ELSE chr(10) END;
   END IF;

   Dbms_Lob.CreateTemporary(json_, TRUE, Dbms_Lob.CALL);
   Dbms_Lob.Open(json_, Dbms_Lob.LOB_READWRITE);

   Check_Document___(main_);
   Append_Element(main_.elements(main_.root_id), 0);
   Dbms_Lob.WriteAppend(json_, length(buf_), buf_);
   Dbms_Lob.Close(json_);
END To_Json;


-- To_Xml
-- Format document to an XML document. If 'agg_level_' is FALSE additional
-- levels for aggregates and arrays (compound attributes) will be omitted,
-- i.e. aggregate and array names.
-- If 'xml_attrs_' is TRUE optional XML attributes will be added.
-- If 'id_' is given only the part corresponding to the given element will be generated.
-- If 'elem_type_' is TRUE 'type' XML attribute with type specification will be added;
-- note that 'xml_attrs_' is then ignored.
-- If 'add_header_' is TRUE an XML header will be added.
-- 'indent_' defines indentation and line breaks. If NULL the XML will be generated in
-- a single line. May not be negative.
-- If 'use_crlf_' is TRUE the CRLF sequence will be used instead of LF for new line.
PROCEDURE To_Xml (
   xml_        OUT CLOB,
   main_       IN  Document,
   agg_level_  IN  BOOLEAN    DEFAULT TRUE,
   xml_attrs_  IN  BOOLEAN    DEFAULT FALSE,
   id_         IN  Element_Id DEFAULT NULL,
   elem_type_  IN  BOOLEAN    DEFAULT FALSE,
   add_header_ IN  BOOLEAN    DEFAULT FALSE,
   indent_     IN  NUMBER     DEFAULT NULL,
   use_crlf_   IN  BOOLEAN    DEFAULT FALSE,
   namespaces_ IN  BOOLEAN    DEFAULT FALSE )
IS
   nl_  VARCHAR2(2);
   buf_ VARCHAR2(32767);

   PROCEDURE Append(str_ VARCHAR2) IS
   BEGIN
      buf_ := buf_ || str_;
   EXCEPTION
      WHEN value_error THEN
         Dbms_Lob.WriteAppend(xml_, length(buf_), buf_);
         buf_ := str_;
   END;

   FUNCTION Encode_Clob_Value (value_ IN CLOB) RETURN CLOB IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(value_,chr(38),chr(38)||'amp;'),'<',chr(38)||'lt;'),'>',chr(38)||'gt;'),'"',chr(38)||'quot;'),'''',chr(38)||'apos;');
   END;

   FUNCTION Encode_Text_Value (value_ IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(value_,chr(38),chr(38)||'amp;'),'<',chr(38)||'lt;'),'>',chr(38)||'gt;'),'"',chr(38)||'quot;'),'''',chr(38)||'apos;');
   END;

   PROCEDURE Append_Element (element_ IN Element, level_ IN NUMBER) IS
      cnt_       BINARY_INTEGER := element_.children.count;
      name_      VARCHAR2(4000) := CASE WHEN namespaces_ THEN Full_Name___(element_) ELSE element_.name END;
      add_attrs_ BOOLEAN        := elem_type_ OR xml_attrs_;

      FUNCTION Name_With_Xml_Attrs RETURN VARCHAR2 IS
      BEGIN
         IF elem_type_ THEN
            RETURN name_||' type="'||Get_Type_Name___(element_.type)||'"';
         ELSIF xml_attrs_ AND main_.xml_attrs.count > 0 AND main_.xml_attrs.exists(element_.id) AND main_.xml_attrs(element_.id).count > 0 THEN
            DECLARE
               name_buf_  VARCHAR2(32767) := name_;
               xml_attr_  Xml_Attribute;
            BEGIN
               FOR i IN 1..main_.xml_attrs(element_.id).count LOOP
                  xml_attr_ := main_.xml_attrs(element_.id)(i);
                  name_buf_ := name_buf_||' '||xml_attr_.name||'="'||Encode_Text_Value(xml_attr_.value)||'"';
               END LOOP;
               RETURN name_buf_;
            END;
         ELSE
            RETURN name_;
         END IF;
      END;

      PROCEDURE Append_Clob_Value (value_ CLOB) IS
      BEGIN
         Append(rpad(' ', level_)||'<'||CASE add_attrs_ WHEN TRUE THEN Name_With_Xml_Attrs ELSE name_ END||'>');
         Dbms_Lob.WriteAppend(xml_, length(buf_), buf_);
         Dbms_Lob.Append(xml_, CASE element_.type = TYPE_BINARY WHEN TRUE THEN value_ ELSE Encode_Clob_Value(value_) END);
         buf_ := '</'||name_||'>'||nl_;
      END;

   BEGIN
      IF element_.type NOT IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN -- simple attribute
         IF element_.value IS NOT NULL THEN
            BEGIN
               Append(rpad(' ', level_)||'<'||CASE add_attrs_ WHEN TRUE THEN Name_With_Xml_Attrs ELSE name_ END||'>'||CASE element_.type = TYPE_BINARY WHEN TRUE THEN element_.value ELSE Encode_Text_Value(element_.value) END||'</'||name_||'>'||nl_);
            EXCEPTION
               WHEN value_error THEN
                  Append_Clob_Value(element_.value);
            END;
         ELSIF element_.clob_val IS NOT NULL THEN
            Append_Clob_Value(element_.clob_val);
         ELSE
            Append(rpad(' ', level_)||'<'||CASE add_attrs_ WHEN TRUE THEN Name_With_Xml_Attrs ELSE name_ END||'/>'||nl_);
         END IF;
      ELSE -- compound attribute or document
         IF cnt_ > 0 THEN
            IF agg_level_ OR element_.type = TYPE_DOCUMENT THEN
               Append(rpad(' ', level_)||'<'||CASE add_attrs_ WHEN TRUE THEN Name_With_Xml_Attrs ELSE name_ END||'>'||nl_);
            END IF;
            FOR ix_ IN 1..cnt_ LOOP
               Append_Element(main_.elements(element_.children(ix_)), CASE WHEN agg_level_ OR element_.type = TYPE_DOCUMENT THEN level_+indent_ ELSE level_ END);
            END LOOP;
            IF agg_level_ OR element_.type = TYPE_DOCUMENT THEN
               Append(rpad(' ', level_)||'</'||name_||'>'||nl_);
            END IF;
         ELSE
            IF agg_level_ OR element_.type = TYPE_DOCUMENT THEN
               Append(rpad(' ', level_)||'<'||CASE add_attrs_ WHEN TRUE THEN Name_With_Xml_Attrs ELSE name_ END||'/>'||nl_);
            END IF;
         END IF;
      END IF;
   END;

BEGIN
   IF indent_ IS NOT NULL THEN
      IF indent_ < 0 THEN
         Error_SYS.Appl_General(lu_name_, 'PLAPDOCIND: Indent [:P1] may not be less than zero', indent_);
      END IF;
      nl_ := CASE use_crlf_ WHEN TRUE THEN chr(13)||chr(10) ELSE chr(10) END;
   END IF;

   Dbms_Lob.CreateTemporary(xml_, TRUE, Dbms_Lob.CALL);
   Dbms_Lob.Open(xml_, Dbms_Lob.LOB_READWRITE);

   Check_Document___(main_);
   IF id_ IS NOT NULL AND main_.elements(id_).type NOT IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
      Error_SYS.Appl_General(lu_name_, 'PLAPDOCNCOMP2: Element [:P1] is not compound', Full_Name___(main_.elements(id_)));
   END IF;
   IF add_header_ THEN
      Append('<?xml version=''1.0'' encoding=''UTF-8''?>'||nl_);
   END IF;
   Append_Element(main_.elements(nvl(id_, main_.root_id)), 0);
   Dbms_Lob.WriteAppend(xml_, length(buf_), buf_);
   Dbms_Lob.Close(xml_);
END To_Xml;


-- To_Ifs_Xml
-- Format document to an IFS XML document.
-- If 'id_' is given only the part corresponding to the given element will be generated.
-- If 'add_type_' is TRUE, 'type' XML attribute with type specification will be added.
-- If 'add_header_' is TRUE an XML header will be added.
-- 'indent_' defines indentation and line breaks. If NULL the XML will be generated in
-- a single line. May not be negative.
-- If 'use_crlf_' is TRUE the CRLF sequence will be used instead of LF for new line.
PROCEDURE To_Ifs_Xml (
   xml_        OUT CLOB,
   main_       IN  Document,
   id_         IN  Element_Id DEFAULT NULL,
   add_type_   IN  BOOLEAN    DEFAULT FALSE,
   add_header_ IN  BOOLEAN    DEFAULT FALSE,
   indent_     IN  NUMBER     DEFAULT NULL,
   use_crlf_   IN  BOOLEAN    DEFAULT FALSE )
IS
BEGIN
   To_Xml(xml_, main_, id_ => id_, elem_type_ => add_type_, add_header_ => add_header_, indent_ => indent_, use_crlf_ => use_crlf_);
END To_Ifs_Xml;


-- From_Xml
-- Create new document by parsing an XML document. If 'agg_level_' is FALSE,
-- the parser doesn't expect the additional level for compound attributes
-- to be present in the parsed XML document. The compound attribute will be
-- automatically created using the actual document (tag) name suffixed with
-- the value taken from the 'agg_suffix_' parameter.
-- This method parses also the optional XML attributes.
-- If 'add_type_' is TRUE, element type will be set according to specification
-- in the 'type' XML attribute.
PROCEDURE From_Xml (
   main_       OUT Document,
   xml_        IN  CLOB,
   agg_level_  IN  BOOLEAN  DEFAULT TRUE,
   add_type_   IN  BOOLEAN  DEFAULT FALSE,
   agg_suffix_ IN  VARCHAR2 DEFAULT '_AGG',
   expected_root_name_  IN  VARCHAR2 DEFAULT NULL)
IS
   parser_         Dbms_XmlParser.Parser := Dbms_XmlParser.NewParser;
   dom_doc_        Dbms_XmlDom.DomDocument;
   root_elem_      Dbms_XmlDom.DomElement;
   root_node_      Dbms_XmlDom.DomNode;
   root_name_      VARCHAR2(4000);
   root_namespace_ VARCHAR2(200);
   dom_node_list_  Dbms_XmlDom.DomNodeList;
   type_fixed_     BOOLEAN := FALSE;

   PROCEDURE debug(line_ VARCHAR2) IS
   BEGIN
      --Dbms_Output.Put_Line(line_);
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, line_);
   END;

   PROCEDURE Parse_Attributes(indent_ VARCHAR2, node_ Dbms_XmlDom.DomNode, id_ Element_Id) IS
      attrs_ Dbms_XmlDom.DomNamedNodeMap:= Dbms_XmlDom.GetAttributes(node_);
      attr_  Dbms_XmlDom.DomNode;
      name_  VARCHAR2(200);
      value_ VARCHAR2(4000);
   BEGIN
      FOR i IN 0..Dbms_XmlDom.GetLength(attrs_)-1 LOOP
         attr_ := Dbms_XmlDom.Item(attrs_, i);
         name_ := Dbms_XmlDom.GetNodeName(attr_);
         value_ := Dbms_XmlDom.GetNodeValue(attr_);
         debug(indent_||'   attribute #'||i||': ['||name_||'='||value_||']');
         IF add_type_ AND name_ = 'type' AND nvl(main_.elements(id_).type, TYPE_UNKNOWN) = TYPE_UNKNOWN THEN
            main_.elements(id_).type := Get_Type_Id___(value_);
            debug(indent_||'   - setting type ['||Get_Type_Id___(value_)||'] for element ['||id_||']');
         ELSE
            Add_Xml_Attribute(main_, id_, name_, value_);
         END IF;
      END LOOP;
   END;

   PROCEDURE Parse_Children(indent_ VARCHAR2, list_ Dbms_XmlDom.DomNodeList, parent_id_ Element_Id) IS
      node_      Dbms_XmlDom.DomNode;
      name_      VARCHAR2(4000);
      namespace_ VARCHAR2(200);
      child_     Dbms_XmlDom.DomNode;
      type_      NUMBER;
      ch_type_   NUMBER;
      value_     VARCHAR2(32767);
      clob_val_  CLOB;
      id_        Element_Id;

      PROCEDURE Check_Doc_Type (compound_ BOOLEAN DEFAULT FALSE) IS
      BEGIN
         IF NOT type_fixed_ THEN
            IF main_.elements(parent_id_).type = TYPE_COMPOUND AND main_.elements(parent_id_).parent_id = main_.root_id THEN
               main_.elements(main_.root_id).type := TYPE_COMPOUND;
               main_.elements(parent_id_).type := TYPE_DOCUMENT;
            END IF;
            IF NOT compound_ OR parent_id_ <> main_.root_id THEN
               type_fixed_ := TRUE;
            END IF;
         END IF;
      END;

   BEGIN
      FOR i IN 0..Dbms_XmlDom.GetLength(list_)-1 LOOP
         node_  := Dbms_XmlDom.Item(list_, i);
         Dbms_XmlDom.GetLocalName(node_, name_);
         type_  := Dbms_XmlDom.GetNodeType(node_);

         IF type_ <> Dbms_XmlDom.ELEMENT_NODE THEN
            debug(indent_||'ELEMENT['||type_||'] '||name_||' is not ELEMENT_NODE; skipping...');
            CONTINUE;
         END IF;

         child_ := Dbms_XmlDom.GetFirstChild(node_);
         LOOP
            ch_type_ := NULL;
            EXIT WHEN Dbms_XmlDom.IsNull(child_);

            ch_type_ := Dbms_XmlDom.GetNodeType(child_);
            EXIT WHEN ch_type_ IN (Dbms_XmlDom.TEXT_NODE, Dbms_XmlDom.CDATA_SECTION_NODE, Dbms_XmlDom.ELEMENT_NODE);

            child_ := Dbms_XmlDom.GetNextSibling(child_);
         END LOOP;

         namespace_ := Dbms_XmlDom.GetPrefix(node_);

         IF Dbms_XmlDom.IsNull(child_) THEN
            debug(indent_||'ELEMENT['||type_||'] '||name_||' has no children');
            Check_Doc_Type;
            IF main_.elements(parent_id_).type = TYPE_COMPOUND THEN
               id_ := Add_Document___(main_, name_, namespace_, parent_id_);
            ELSE
               id_ := Add_Simple_Attribute___(main_, name_, namespace_, NULL, TYPE_UNKNOWN, parent_id_);
            END IF;
         ELSE
            IF ch_type_ IN (Dbms_XmlDom.TEXT_NODE, Dbms_XmlDom.CDATA_SECTION_NODE) THEN
               BEGIN
                  value_    := Dbms_XmlDom.GetNodeValue(child_);
                  clob_val_ := NULL;
               EXCEPTION
                  WHEN value_error THEN
                     value_    := NULL;
                     clob_val_ := NULL;
                     Dbms_Lob.CreateTemporary(clob_val_, TRUE, Dbms_Lob.CALL);
                     Dbms_XmlDom.WriteToClob(child_, clob_val_);
               END;
               debug(indent_||'ELEMENT['||type_||'/'||ch_type_||']: '||name_||'='||NVL(value_, '<CLOB>'));
               Check_Doc_Type;
               id_ := Add_Simple_Attribute___(main_, name_, namespace_, value_, TYPE_UNKNOWN, parent_id_, clob_val_);
            ELSIF ch_type_ = Dbms_XmlDom.ELEMENT_NODE THEN
               debug(indent_||'ELEMENT['||type_||'/'||ch_type_||']: '||name_||' (compound)');
               IF agg_level_ AND main_.elements(parent_id_).type = TYPE_DOCUMENT THEN
                  Check_Doc_Type(TRUE);
                  id_ := Add_Compound_Attribute___(main_, name_, namespace_, parent_id_);
               ELSIF main_.elements(parent_id_).type = TYPE_DOCUMENT THEN
                  id_ := Find_Element_Id(main_, name_||agg_suffix_, parent_id_);
                  IF id_ IS NULL THEN
                     Check_Doc_Type(TRUE);
                     id_ := Add_Compound_Attribute___(main_, name_||agg_suffix_, NULL, parent_id_);
                  END IF;
                  id_ := Add_Document___(main_, name_, namespace_, id_);
               ELSE
                  id_ := Add_Document___(main_, name_, namespace_, parent_id_);
               END IF;
               Parse_Children(indent_||'  ', Dbms_XmlDom.GetChildNodes(node_), id_);
            END IF;
         END IF;
         Parse_Attributes(indent_, node_, id_);
      END LOOP;
   END;

BEGIN
   Dbms_XmlParser.ParseClob(parser_, xml_);
   dom_doc_ := Dbms_XmlParser.GetDocument(parser_);
   Dbms_XmlParser.Freeparser(parser_);

   root_elem_ := Dbms_XmlDom.GetDocumentElement(dom_doc_);
   root_name_ := Dbms_XmlDom.GetLocalName(root_elem_);
   root_node_ := Dbms_XmlDom.MakeNode(root_elem_);
   root_namespace_ := Dbms_XmlDom.GetPrefix(root_node_);
   debug('ROOT: '||root_name_);
   IF (expected_root_name_ IS NOT NULL AND expected_root_name_ <> root_name_) THEN
      Error_SYS.Record_General(lu_name_, 'INV_FILE: Invalid XML! Root should be ":P1" but was ":P2".', expected_root_name_, root_name_);
   END IF;
   main_ := New_Document(root_name_, namespace_ => root_namespace_);
   Parse_Attributes('  ', root_node_, main_.root_id);

   dom_node_list_ := Dbms_XmlDom.GetChildNodes(root_node_);
   Parse_Children('  ', dom_node_list_, main_.root_id);
   Dbms_XmlDom.FreeDocument(dom_doc_);
END From_Xml;


-- From_Ifs_Xml
-- Create new document by parsing IFS XML document.
PROCEDURE From_Ifs_Xml (
   main_ OUT Document,
   xml_  IN  CLOB,
   expected_root_name_  IN  VARCHAR2 DEFAULT NULL)
IS
   -- stack with compound element names and ID's
   -- a compound element can be a document or a compound attribute
   TYPE Element_Desc IS RECORD (
      name  VARCHAR2(4000),
      id    Element_Id
   );
   TYPE Element_Stack IS TABLE OF Element_Desc INDEX BY BINARY_INTEGER;

   START_TAG  CONSTANT NUMBER := 0;
   END_TAG    CONSTANT NUMBER := 1;
   NULL_TAG   CONSTANT NUMBER := 2;

   stack_  Element_Stack;
   buf_    VARCHAR2(32767);
   pos_    INTEGER; -- position of the current buffer (VARCHAR2) in the XML document (CLOB)
   start_  INTEGER; -- start position of the current tag in the current buffer

   FUNCTION Decode_Text_Value (value_ IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(value_,chr(38)||'apos;',''''),chr(38)||'quot;','"'),chr(38)||'gt;','>'),chr(38)||'lt;','<'),chr(38)||'amp;',chr(38));
   END;

   FUNCTION Decode_Clob_Value (value_ IN CLOB) RETURN CLOB IS
   BEGIN
      RETURN replace(replace(replace(replace(replace(value_,chr(38)||'apos;',''''),chr(38)||'quot;','"'),chr(38)||'gt;','>'),chr(38)||'lt;','<'),chr(38)||'amp;',chr(38));
   END;

   -- extract element name from xml tag on form <ns:name attr="val"> or </...> or <.../>
   -- return:
   --   START_TAG for regular tags, e.g. <name>
   --   END_TAG   for end tags, e.g. </name>
   --   NULL_TAG  for empty tags, e.g. <name/>
   FUNCTION Parse_Tag(str_ IN VARCHAR2, name_ OUT VARCHAR2) RETURN INTEGER IS
      p1_  INTEGER := instr(str_, ':'); -- used for extract name if ns is present
      p2_  INTEGER := instr(str_, ' '); -- may occur is there are attributes
      p3_  INTEGER := instr(str_, '/'); -- may occur in end or empty tag
   BEGIN
      IF p2_ > 0 AND p1_ > p2_ THEN -- colon in attribute name; ignore it
         p1_ := 0;
      END IF;
      IF p3_ <> 1 AND p3_ <> length(str_) THEN -- not '</' or '/>'
         p3_ := 0;
      END IF;
      IF p1_ = 0 AND p2_ = 0 AND p3_ = 0 THEN -- regular tag on form <name>
         name_ := str_;
         RETURN START_TAG;
      ELSIF p3_ = 0 THEN -- regular tag on form <ns:name attrdef>
         name_ := substr(str_, p1_+1, CASE p2_ WHEN 0 THEN length(str_) ELSE p2_-1 END - p1_);
         RETURN START_TAG;
      ELSIF p3_ = 1 THEN -- end tag on form </ns:name>
         p1_ := CASE p1_ WHEN 0 THEN 2 ELSE p1_ + 1 END;
         name_ := substr(str_, p1_,   CASE p2_ WHEN 0 THEN length(str_) ELSE p2_-1 END - p1_+1);
         RETURN END_TAG;
      ELSE -- i.e. p3_ = length(str_), null tag on form <ns:name attrdef/>
         name_ := substr(str_, p1_+1, CASE p2_ WHEN 0 THEN length(str_) ELSE p2_ END - p1_ - 1);
         RETURN NULL_TAG;
      END IF;
   END;

   -- extract portion of the input document (CLOB) to a VARCHAR2 buffer (performance)
   -- the buffer can contain max 32767 bytes, which doesn't necessarily
   -- correspond to the same amount of characters if there are UTF8 characters
   PROCEDURE New_Buffer IS
   BEGIN
      start_ := 1;
      buf_ := Dbms_Lob.Substr(xml_, 27000, pos_); -- 80%
   EXCEPTION
      WHEN value_error THEN
         BEGIN
            buf_ := Dbms_Lob.Substr(xml_, 16000, pos_); -- 50%
         EXCEPTION
            WHEN value_error THEN
               buf_ := Dbms_Lob.Substr(xml_, 5400, pos_); -- 16% i.e. each char occupies 6 bytes
         END;
   END;

BEGIN
   -- first find start of document after XML header, if any
   pos_ := instr(xml_, '<', instr(Dbms_Lob.Substr(xml_, 200, 1),'?>') + 1);
   New_Buffer; -- extract the first portion of characters from CLOB to the VARCHAR2 buffer

   /* NOTE!!! NOTE!!! NOTE!!!
      XML parsing is written as a single loop in the main function. The stack is used for
      denoting level within the document. This is because of performance reasons.

      A subroutine changing content of a variable, independently if declared in a scope
      of the main function or passed as an IN OUT NOCOPY parameter does not perform well.
      Only IN parameters should be passed to subroutines. An implementation with more
      or less the same code, but based on solution using a subroutine with recursion
      performs about 15 - 20 times slower!

      TODO: This function has a number of limitation related to the Document structure.
      The top level element can be a document with attributes or an array (compound attribute)
      with documents. But this is not know before starting the parsing.
      So the logic makes a couple of assumptions. If the top element name ends with '_LIST' it
      will assume the top element is an array. Otherwise the top element will be assumed to
      be a document, but it can be changed during parsing of the two top most levels or on
      first simple attribute.
      But there can be situations when it is not possible to decide the type without
      going deeper in the structure. In some situations it would be enough to introduce yet
      another parameter to the procedure that would force the logic to use one of the two types.
      But in many cases it will not be possible. If necessary the logic could catch some of the
      exceptions and re-start the parsing by using the much slower From_Xml procedure, which would
      probably also need to be improved. The From_Xml procedure uses DOM, so is should be possible to
      first read the entire XML document, then find a simple attribute and fix the element types
      starting from the found attribute.
   */
   DECLARE
      end_          INTEGER;
      type_         INTEGER;
      name_         VARCHAR2(4000);
      parent_id_    Element_Id;
      simple_attr_  Element_Id; -- last simple attribute, if any
      next_buf_     BOOLEAN;
      from_         INTEGER;
      len_          INTEGER;
      type_fixed_   BOOLEAN := FALSE; -- denotes if we already know the type of document or not

      -- the top level element can be a document (TYPE_DOCUMENT) or an array (TYPE_COMPOUND),
      -- but when starting parsing we don't know yet which type of Document we have, so
      -- until that the type_fixed_ is FALSE and we can change the type of the top level
      -- element and the next level element
      -- the assumption is that we can decide the type on the second level,
      -- which requires we have non-empty simple attributes on the third level
      -- with other words the structure will be fixed on the first simple attribute
      -- or compound element on third level.
      PROCEDURE Check_Doc_Type (compound_ BOOLEAN DEFAULT FALSE) IS
      BEGIN
         IF NOT type_fixed_ THEN
            IF main_.elements(parent_id_).type = TYPE_COMPOUND AND main_.elements(parent_id_).parent_id = main_.root_id THEN
               main_.elements(main_.root_id).type := TYPE_COMPOUND;
               main_.elements(parent_id_).type := TYPE_DOCUMENT;
            END IF;
            IF NOT compound_ OR parent_id_ <> main_.root_id THEN
               type_fixed_ := TRUE;
            END IF;
         END IF;
      END;

   BEGIN
      -- loop through the XML document and parse one tag in each iteration
      LOOP
         -- first find the parent ID
         parent_id_ := CASE stack_.count WHEN 0 THEN NULL ELSE stack_(stack_.count).id END;

         -- find the end of the current tag; if not found it means it is not present in
         -- the actual buffer (the portion of the XML document) and we have to read next
         -- portion from CLOB to the VARCHAR2 buffer
         end_ := instr(buf_, '>', start_+1);
         IF end_ = 0 THEN
            pos_   := start_ + pos_ - 1;
            New_Buffer;
            end_   := instr(buf_, '>', start_+1);
         END IF;

         -- extract current tag name and find out the type of the tag
         type_ := Parse_Tag(substr(buf_, start_+1, end_-start_-1), name_);
         --Dbms_Output.Put_Line('name_='||name_||', type_='||type_);

         -- find position of the next tag
         start_ := instr(buf_, '<', end_+1);
         IF start_ = 0 OR start_ = length(buf_) THEN
            -- next tag doesn't fit in the current buffer; extract next portion from the CLOB
            from_     := end_ + pos_;
            pos_      := instr(xml_, '<', from_);
            New_Buffer;
            len_      := pos_ - from_;
            next_buf_ := TRUE;
         ELSE
            from_     := end_ + 1;
            len_      := start_ - end_ - 1;
            next_buf_ := FALSE;
         END IF;

         -- check the type of the current tag; start_ is now pointing to the next tag
         IF type_ = START_TAG THEN -- regular tag, e.g. <name>
            -- compound attribute or document, i.e. next tag is not </...>
            IF NOT substr(buf_, start_+1, 1) = '/' THEN
               IF parent_id_ IS NULL THEN -- the very first compound element; create top level document
                  IF (expected_root_name_ IS NOT NULL AND expected_root_name_ <> name_) THEN
                     Error_SYS.Record_General(lu_name_, 'INV_FILE: Invalid XML! Root should be ":P1" but was ":P2".', expected_root_name_, name_);
                  END IF;
                  -- we assume that if the main element ends with '_LIST' it will be a top level array
                  main_ := New_Document(name_, name_ LIKE '%\_LIST' ESCAPE '\');
                  parent_id_ := main_.root_id;
               ELSIF main_.elements(parent_id_).type = TYPE_DOCUMENT THEN
                  Check_Doc_Type(TRUE); -- decide if the top level is a document with attributes or an array with documents
                  parent_id_ := Add_Compound_Attribute___(main_, name_, NULL, parent_id_);
               ELSE
                  parent_id_ := Add_Document___(main_, name_, NULL, parent_id_);
               END IF;

               -- add the current compound element (compound attribute or document) to the stack
               DECLARE
                  element_ Element_Desc;
               BEGIN
                  element_.name := name_;
                  element_.id := parent_id_;
                  stack_(stack_.count+1) := element_;
               END;
            -- next tag is the end tag, i.e. on form </...>
            -- which means this is a simple attribute with value (which can be empty) or an empty document
            ELSE
               IF main_.root_id IS NULL THEN -- empty top level document; nothing more to do
                  main_ := New_Document(name_);
                  EXIT;
               ELSIF main_.elements(parent_id_).type = TYPE_COMPOUND AND len_ = 0 THEN -- empty nested document
                  -- we're assuming this is an empty nested document if the parent is a compound attribute
                  -- and there is no value for this element, but it can also be an empty single attribute
                  -- if the top level element is an array but it is not known yet at this point,
                  -- i.e. type_fixed_ is still FALSE and the parent can be changes to TYPE_DOCUMENT later on
                  -- the second case is not supported
                  --Dbms_Output.Put_Line('  -- '||name_||' is empty document');
                  DECLARE
                     dummy_ Element_ID;
                  BEGIN
                     dummy_ := Add_Document___(main_, name_, NULL, parent_id_);
                  END;
               ELSE -- simple attribute
                  DECLARE
                     value_     VARCHAR2(32767);
                     clob_val_  CLOB;
                     id_        Element_Id;
                  BEGIN
                     IF next_buf_ THEN -- value don't fit in the current buffer; read it directly from the CLOB
                        clob_val_ := Decode_Clob_Value(substr(xml_, from_, len_));
                        IF len_ <= 32767 THEN -- if the value doesn't contain any UTF8 characters it will fit in VARCHAR2
                           BEGIN
                              value_    := clob_val_;
                              clob_val_ := NULL;
                           EXCEPTION
                              WHEN value_error THEN
                                 value_ := NULL;
                           END;
                        END IF;
                     ELSE
                        value_ := Decode_Text_Value(substr(buf_, from_, len_));
                     END IF;
                     Check_Doc_Type; -- decide if it is a top level document with attributes or an array with documents
                     IF main_.elements(parent_id_).type = TYPE_COMPOUND AND value_ IS NULL AND clob_val_ IS NULL THEN
                        id_ := Add_Document___(main_, name_, NULL, parent_id_);
                     ELSE
                        simple_attr_ := Add_Simple_Attribute___(main_, name_, NULL, value_, TYPE_UNKNOWN, parent_id_, clob_val_);
                     END IF;
                  END;
               END IF;
            END IF;
         -- end tag
         ELSIF type_ = END_TAG THEN
            IF name_ = stack_(stack_.count).name AND simple_attr_ IS NULL THEN -- delete only compound elements
               stack_.delete(stack_.count);
            END IF;
            simple_attr_ := NULL; -- resetting last simple attribute
            IF stack_.count = 0 THEN
               EXIT;
            END IF;
         -- empty tag
         -- TODO: we do not currently support NULL_TAG, i.e. <.../>, as an empty document on nested level
         ELSIF type_ = NULL_TAG THEN -- null tag, i.e. simple attribute with null value or empty top level document
            IF parent_id_ IS NULL THEN -- empty top level document
               main_ := New_Document(name_);
               EXIT;
            ELSE -- simple attribute with null value
               Check_Doc_Type;
               DECLARE
                  id_ Element_Id;
               BEGIN
                  IF main_.elements(parent_id_).type = TYPE_COMPOUND THEN
                     id_ := Add_Document___(main_, name_, NULL, parent_id_);
                  ELSE
                     id_ := Add_Simple_Attribute___(main_, name_, NULL, NULL, TYPE_UNKNOWN, parent_id_);
                  END IF;
               END;
            END IF;
         END IF;
      END LOOP;
   END;
END From_Ifs_Xml;


-- Clear
-- Clear the document. Normally it is not necessary to clear a document.
PROCEDURE Clear (
   main_ IN OUT Document )
IS
   empty_ Document;
BEGIN
   main_ := empty_;
END Clear;


-- Debug
-- Debug the document. Each element will be shown in separate line
-- according to the syntax:
-- [name/ID,parent_ID/type:<list_of_child_element_ids>]='value'
-- <list_of_child_element_ids> is only shown for compound elements
-- 'value' is only shown for simple elements and only first 50 characters
PROCEDURE Debug (
   main_ IN Document )
IS
   buf_ CLOB;
BEGIN
   Debug___(buf_, main_, FALSE);
END Debug;


-- Debug
-- Put debug output to an out CLOB variable rather then using Login_SYS
PROCEDURE Debug (
   buf_  OUT CLOB,
   main_ IN  Document )
IS
BEGIN
   Debug___(buf_, main_, TRUE);
END Debug;


PROCEDURE Debug___  (
   buf_    OUT CLOB,
   main_   IN  Document,
   to_buf_ IN BOOLEAN)
IS
   TYPE Levels IS TABLE OF BINARY_INTEGER INDEX BY Element_Id;
   levels_ Levels;

   PROCEDURE Put_Line (line_ VARCHAR2) IS
   BEGIN
      IF to_buf_ THEN
         buf_ := buf_||'DEBUG: '||line_||chr(10);
      ELSE
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, line_);
      END IF;
   END;

   PROCEDURE Debug_Element (elem_ Element) IS
      local_buf_ VARCHAR2(32767);
      level_     BINARY_INTEGER := 1;
   BEGIN
      IF levels_.exists(elem_.parent_id) THEN
         level_ := levels_(elem_.parent_id);
      ELSE
         DECLARE
            id_   Element_Id := elem_.parent_id;
            prev_ Element_Id := NULL;
         BEGIN
            WHILE id_ IS NOT NULL LOOP
               level_ := level_ + 1;
               prev_ := id_;
               id_ := main_.elements(id_).parent_id;
            END LOOP;
            IF elem_.parent_id IS NOT NULL THEN
               levels_(elem_.parent_id) := level_;
            END IF;
         END;
      END IF;
      local_buf_ := '  '||lpad('[',level_,'.')||elem_.name||'/'||elem_.id||','||nvl(to_char(elem_.parent_id),'-')||'/'||elem_.type;
      IF elem_.type IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
         local_buf_ := local_buf_||':<';
         FOR i IN 1..elem_.children.count LOOP
            IF i > 1 THEN
               local_buf_ := local_buf_||',';
            END IF;
            local_buf_ := local_buf_||elem_.children(i);
         END LOOP;
         local_buf_ := local_buf_||'>';
      END IF;
      local_buf_ := local_buf_||']';
      IF elem_.type NOT IN (TYPE_COMPOUND, TYPE_DOCUMENT) THEN
         local_buf_ := local_buf_||'='''||substr(nvl(elem_.clob_val, elem_.value), 1, 50)||'''';
      END IF;
      Put_Line(local_buf_);
   END;

BEGIN
   Put_Line('PLSQLAP Document:');
   IF NOT Is_Initialized(main_) THEN
      Put_Line('  Document has not been initialized');
   ELSE
      FOR i IN 1..main_.elements.count LOOP
         Debug_Element(main_.elements(i));
      END LOOP;
   END IF;
END Debug___;

-------------------- LU  NEW METHODS -------------------------------------

