-----------------------------------------------------------------------------
--
--  Logical unit: Xml
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  991014  MANY  Created
--                Added implementation method Pack_Children___()
--  991015  MANY  Added method Get_Parent().
--                Modified Pack_Children___() to include semantics for empty node_lists.
--  000201  MANY  Completed some major rewriting.
--  000202  MANY  Added method Get_Xml()
--  000203  MANY  Added method Add_Xml()
--  000228  MANY  Removed encoding-information (ToDo #671)
--  000409  MANY  Fixed Decoding and Encoding (Bug #829)
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------Project Tinkerbell------------------------------
--  130425  MaBose  TIBE-41: Remove of package global variables
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE ElementRec IS RECORD (
   parent_id  NUMBER,
   document   VARCHAR2(1000),
   name       VARCHAR2(1000),
   attributes VARCHAR2(32000),
   value      VARCHAR2(32000),
   is_value   BOOLEAN );
TYPE DocTable IS TABLE OF ElementRec INDEX BY BINARY_INTEGER;
SUBTYPE Document IS NUMBER; -- These subtybes must be used in external programs for future compatability
SUBTYPE Element IS NUMBER;  -- These subtybes must be used in external programs for future compatability

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Name___ (
   name_ IN VARCHAR2 )
IS
   invalid_chrs_ VARCHAR2(100) := 
     chr(38)||UNISTR('\00A4\00A3')||' <>!!"#%&/()=@${[]}+?^'',;|'||chr(30)||chr(31)||chr(0)||chr(1)||chr(2)||chr(3)||chr(4)||chr(5)||chr(6)||chr(7)||chr(8)||chr(9)||
     chr(10)||chr(11)||chr(12)||chr(13)||chr(14)||chr(15)||chr(16)||chr(17)||chr(18)||chr(19)||chr(20)||chr(21)||chr(22)||chr(23)||chr(24)||chr(25)||chr(26)||chr(27)||chr(28)||chr(29);
BEGIN
   IF (name_ <> translate(name_, invalid_chrs_, rpad('-', length(invalid_chrs_), '-') )) THEN -- Simplified check for validity :-)
      Error_SYS.Appl_General(service_, 'XMLILLNME: Tagname is invalid [:P1].', name_);
   END IF;
END Check_Name___;


FUNCTION Get_New_Index___ (
   new_index_ IN OUT NUMBER )   RETURN NUMBER
IS
   index_ NUMBER := new_index_;
BEGIN
   new_index_ := new_index_ + 1;
   RETURN (index_);
END Get_New_Index___;


FUNCTION Get_Index___ (
   id_ IN Element ) RETURN NUMBER
IS
BEGIN
   RETURN (id_);
END Get_Index___;


FUNCTION Get_Id___ (
   index_ IN NUMBER ) RETURN Element
IS
BEGIN
   RETURN (index_);
END Get_Id___;


FUNCTION Encode_Value___ (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000) := value_;
BEGIN
   temp_ := replace(temp_, chr(38), chr(38)||'amp;'); -- Must be done first
   temp_ := replace(temp_, '<', chr(38)||'lt;');
   temp_ := replace(temp_, '>', chr(38)||'gt;');
   RETURN (temp_);
END Encode_Value___;


FUNCTION Decode_Value___ (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000) := value_;
BEGIN
   temp_ := replace(temp_, chr(38)||'gt;', '>');
   temp_ := replace(temp_, chr(38)||'lt;', '<');
   temp_ := replace(temp_, chr(38)||'amp;', chr(38)); -- Should be done last
   RETURN (temp_);
END Decode_Value___;


PROCEDURE Purge_Datatype___ (
   p_id_ IN NUMBER,
   document_table_ IN OUT DocTable )
IS
   attr_       VARCHAR2(32000);
   ptr_        NUMBER := NULL;
   attr_name_  VARCHAR2(1000);
   attr_value_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(document_table_(p_id_).attributes, ptr_, attr_name_, attr_value_)) LOOP
      IF (attr_name_ <> 'dt:dt') THEN
         Client_SYS.Add_To_Attr(attr_name_, attr_value_, attr_);
      END IF;
   END LOOP;
   document_table_(p_id_).attributes := attr_;
END Purge_Datatype___;


PROCEDURE New_Element___ (
   element_id_   OUT Element,
   document_table_ IN OUT DocTable,
   new_index_    IN  OUT NUMBER,
   parent_id_    IN  Element,
   name_         IN  VARCHAR2,
   value_        IN  VARCHAR2,
   is_value_     IN  BOOLEAN,
   attr_         IN  VARCHAR2 )
IS
   p_id_ NUMBER := Get_Index___(parent_id_);
   e_id_ NUMBER;
BEGIN
   Check_Name___(name_);
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   IF (NOT document_table_(p_id_).is_value OR document_table_(p_id_).is_value IS NULL) THEN
      document_table_(p_id_).is_value := FALSE;
      Purge_Datatype___(p_id_, document_table_);
      e_id_ := Get_New_Index___(new_index_);
      document_table_(e_id_) := NULL;
      document_table_(e_id_).parent_id := p_id_;
      document_table_(e_id_).name := name_;
      document_table_(e_id_).attributes := attr_;
      document_table_(e_id_).value := value_;
      document_table_(e_id_).is_value := is_value_;
      element_id_ := Get_Id___(e_id_);
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLELM: Adding element to node with value is illegal.');
   END IF;
END New_Element___;


FUNCTION Pack_Attr___(
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   text_     VARCHAR2(32000);
   ptr_      NUMBER;
   name_     VARCHAR2(1000);
   value_    VARCHAR2(32000);
   delim_    VARCHAR2(1) := NULL;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      text_ := text_ || delim_ || name_ || '="' || value_ || '"';
      delim_ := ' ';
   END LOOP;
   RETURN (text_);
END Pack_Attr___;


FUNCTION Pack_Children___ (
   parent_id_    IN Element, 
   flush_memory_ IN BOOLEAN,
   document_table_ IN OUT DocTable,
   new_index_    IN NUMBER ) RETURN VARCHAR2
IS
   doc_text_ VARCHAR2(32000) := NULL;
   value_    VARCHAR2(32000) := NULL;
   attr_     VARCHAR2(32000) := NULL;
   p_id_     NUMBER := Get_Index___(parent_id_);
BEGIN
   -- Algorithm take O[n^2] complexity (n = [1..new_index_]), but since few documents will be generated this way it should work out in practice.
   -- The package may need rewriting if heavily used to use a more search-efficient datastructure.
   FOR loop_ IN p_id_ + 1 .. new_index_ - 1 LOOP -- Loop for the rest of the elements *** Note Performance !!! *** 
                                   -- new_index_ points one element past last entry
      IF (document_table_(loop_).parent_id = p_id_) THEN -- Skip nodes that are not part of this sub-tree
         attr_ := Pack_Attr___(document_table_(loop_).attributes);
         IF (attr_ IS NOT NULL) THEN
            attr_ := ' ' || attr_;
         END IF;
         IF (document_table_(loop_).is_value) THEN -- Add value node, can not have children
            doc_text_ := doc_text_ || '<' || document_table_(loop_).name || attr_ || '>' || document_table_(loop_).value || '</' || document_table_(loop_).name || '>';
         ELSE                                                -- Add child elements, can not have value
            value_ := Pack_Children___(loop_, flush_memory_, document_table_, new_index_);
            IF (value_ IS NULL) THEN
               doc_text_ := doc_text_ || '<' || document_table_(loop_).name || attr_ || '/>';
            ELSE
               doc_text_ := doc_text_ || '<' || document_table_(loop_).name || attr_ || '>' || value_ || '</' || document_table_(loop_).name || '>';
            END IF;
         END IF;
         IF (flush_memory_) THEN
            document_table_(loop_) := NULL; -- Release memory
         END IF;
      END IF;
   END LOOP;
   RETURN (doc_text_);
END Pack_Children___;


FUNCTION Left_Trim___ (
   value_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000) := ltrim(value_);
BEGIN
   WHILE (substr(temp_, 1, 1 ) IN (chr(8), chr(10), chr(13))) LOOP
      temp_ := ltrim(substr(temp_, 2));
   END LOOP;
   RETURN (temp_);
END Left_Trim___;


PROCEDURE Get_Attr___ (
   attr_ OUT VARCHAR2,
   list_ IN  VARCHAR2 )
IS
   name_       VARCHAR2(1000);
   value_      VARCHAR2(32000);
   pos_        NUMBER;
   attributes_ VARCHAR2(32000) := ltrim(rtrim(list_));
   error_      BOOLEAN;
   tmp_attr_   VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(tmp_attr_);
   WHILE (attributes_ IS NOT NULL) LOOP
      pos_ := instr(attributes_, '=');
      error_ := TRUE; -- assume error
      IF (pos_ > 0) THEN
         name_ := rtrim(substr(attributes_, 1, pos_ - 1));
         attributes_ := ltrim(substr(attributes_, pos_ + 1));
         IF (substr(attributes_, 1, 1) = '"') THEN
            pos_ := instr(attributes_, '"', 2);
            IF (pos_ > 0) THEN
               value_ := substr(attributes_, 2, pos_ - 2);
               attributes_ := ltrim(substr(attributes_, pos_ + 1));
               error_ := FALSE; -- Nope! All ok
               Client_SYS.Add_To_Attr(name_, value_, tmp_attr_);
            END IF;
         END IF;
      END IF;
      IF (error_) THEN
         Error_SYS.Appl_General(service_, 'XMLATTRIB: Invalid attribute for node [:P1] in attribute list [:P2]', name_, list_);
      END IF;
   END LOOP;
   attr_ := tmp_attr_;
END Get_Attr___;


FUNCTION Get_Value___ (
   value_   OUT    VARCHAR2,
   xml_io_  IN OUT VARCHAR2 ) RETURN BOOLEAN
IS
   pos1_ NUMBER;
   pos2_ NUMBER;
BEGIN
   pos1_ := instr(xml_io_, '<');
   pos2_ := instr(xml_io_, '</');
   IF (pos1_ > 0 AND pos2_ > 0 AND pos1_ = pos2_) THEN
      value_ := substr(xml_io_, 1, pos1_ - 1 );
      xml_io_ := substr(xml_io_, pos1_);
      RETURN (TRUE);
   END IF;
   RETURN (FALSE);
END Get_Value___;


PROCEDURE Set_Value___ (
   document_table_ IN OUT DocTable,
   element_id_   IN Element,
   value_        IN VARCHAR2 )
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   IF (document_table_(e_id_).is_value OR document_table_(e_id_).is_value IS NULL) THEN
      document_table_(e_id_).value := value_;
      document_table_(e_id_).is_value := TRUE;
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLVAL: Parent node [:P1] can not have a value', document_table_(e_id_).name);
   END IF;
END Set_Value___;


FUNCTION Get_Tag___ (
   name_    OUT    VARCHAR2,
   attr_    OUT    VARCHAR2,
   type_    OUT    VARCHAR2,
   xml_io_  IN OUT VARCHAR2 ) RETURN BOOLEAN
IS
   to_         NUMBER;
   xml_        VARCHAR2(32000) := Left_Trim___(xml_io_);
   work_tag_   VARCHAR2(32000);
BEGIN
   IF (substr(xml_, 1, 2) = '</') THEN -- Possible end-tag
      to_ := instr(xml_, '>');
      IF (to_ > 0) THEN
         work_tag_ := substr(xml_, 3, to_ - 3);
         xml_io_ := substr(xml_, to_ + 1);
         name_ := work_tag_;
         attr_ := NULL;
         type_ := 'END';
         RETURN (TRUE);
      END IF;
   ELSIF (substr(xml_, 1, 1) = '<') THEN -- Possible start-tag or selfterminating tag
      to_ := instr(xml_, '>');
      IF (to_ > 0) THEN
         work_tag_ := substr(xml_, 2, to_ - 2);
         xml_io_ := substr(xml_, to_ + 1);
         IF (substr(work_tag_, -1, 1) = '/') THEN
            type_ := 'TERM';
            work_tag_ := substr(work_tag_, 1, length(work_tag_) - 1);
         ELSE
            type_ := 'START';
         END IF;
         to_ := instr(work_tag_, ' ');
         IF (to_ > 0) THEN -- Attributes
            name_ := substr(work_tag_, 1, to_ - 1);
            attr_ := substr(work_tag_, to_ + 1);
         ELSE
            name_ := work_tag_;
            attr_ := NULL;
         END IF;
         RETURN (TRUE);
      END IF;
   END IF;
   RETURN (FALSE);
END Get_Tag___;


PROCEDURE Check_End___ (
   parent_id_ IN  Element,
   name_      IN  VARCHAR2,
   document_table_ IN DocTable )
IS
BEGIN
   IF (document_table_(parent_id_).name <> name_) THEN
      Error_SYS.Appl_General(service_, 'INVENDTAG: End tag [:P1] does not match [:P2].', '<'||name_||'>', '<'||document_table_(parent_id_).name||'>');
   END IF;
END Check_End___;


PROCEDURE Add_Tags___ (
   parent_id_ IN     Element,
   document_table_ IN OUT DocTable,
   new_index_ IN OUT NUMBER, 
   xml_       IN OUT VARCHAR2 )
IS
   value_      VARCHAR2(32000);
   name_       VARCHAR2(1000);
   attr_       VARCHAR2(32000);
   type_       VARCHAR2(10);
   element_id_ Element;
BEGIN
   IF (Get_Value___(value_, xml_)) THEN
      attr_ := Get_attributes(parent_id_, document_table_);
      Set_Value___(document_table_, parent_id_, value_);
      Add_Attributes(document_table_, parent_id_, attr_);
      IF (Get_Tag___(name_, attr_, type_, xml_)) THEN
         Check_Name___(name_);
         IF (type_ = 'END') THEN
            Check_End___(parent_id_, name_, document_table_); -- Match the end-tag towards the parent before returning ok
            RETURN; -- Terminate this level
         END IF;
      END IF;
   ELSE
      WHILE (Get_Tag___(name_, attr_, type_, xml_)) LOOP
         Check_Name___(name_);
         IF (type_ = 'START') THEN
            Add_Element(element_id_, document_table_, new_index_, parent_id_, name_);
            Add_Attributes(document_table_, element_id_, attr_ );
            Add_Tags___(element_id_, document_table_, new_index_, xml_);
         ELSIF (type_ = 'END') THEN
            Check_End___(parent_id_, name_, document_table_); -- Match the end-tag towards the parent before returning ok
            RETURN; -- Terminate this level
         ELSIF (type_ = 'TERM') THEN
            Add_Element(element_id_, document_table_, new_index_, parent_id_, name_); -- No value
            Add_Attributes(document_table_, element_id_, attr_ );
         ELSE
            Error_SYS.Appl_General(service_, 'INVTAGFORMAT: Illegal tag format [:P1].', xml_);
         END IF;
      END LOOP;
   END IF;
   Error_SYS.Appl_General(service_, 'INVDOCFORMAT: Document subsection is not well formed [:P1].', xml_);
END Add_Tags___;


PROCEDURE Get_Header___ (
   attr_    OUT    VARCHAR2,
   xml_io_  IN OUT VARCHAR2 )
IS
   to_  NUMBER;
   xml_ VARCHAR2(32000) := Left_Trim___(xml_io_);
BEGIN
   IF (substr(xml_, 1, 6) = '<?xml ') THEN
      to_ := instr(xml_, '?>');
      IF (to_ > 0) THEN
         attr_ := substr(xml_, 7, to_ - 8);
         xml_io_ := substr(xml_, to_ + 2);
      ELSE
         Error_SYS.Appl_General(service_, 'INVHEADFMT: Illegal header tag format [:P1].', xml_io_);
      END IF;
   END IF;
END Get_Header___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Load_Document (
   document_id_ OUT Document,
   document_table_ OUT DocTable,
   new_index_   IN OUT NUMBER,
   document_    IN  VARCHAR2 )
IS
   xml_        VARCHAR2(32000) := document_;
   xml_attr_   VARCHAR2(32000);
   name_       VARCHAR2(1000);
   type_       VARCHAR2(1000);
   attr_       VARCHAR2(32000);
   element_id_ Element;
BEGIN
   Get_Header___(xml_attr_, xml_);
   IF (Get_Tag___(name_, attr_, type_, xml_)) THEN
      IF (type_ = 'START') THEN
         Create_Document(element_id_, document_table_, new_index_, name_, xml_attr_);
         Add_Attributes(document_table_, element_id_, attr_ );
         Add_Tags___(element_id_, document_table_, new_index_, xml_);
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            Error_SYS.Appl_General(service_, 'INVDOCFMT: Invalid document format [:P1]', xml_);
         END IF;
      ELSIF (type_ = 'TERM') THEN --Empty documents is OK
         Create_Document(element_id_, document_table_, new_index_, name_, xml_attr_);
         Add_Attributes(document_table_, element_id_, attr_ );
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            Error_SYS.Appl_General(service_, 'INVDOCUFORMAT: Invalid document format');
         END IF;
      ELSIF (type_ = 'END') THEN
         Error_SYS.Appl_General(service_, 'INVDOCEND: End-tag found at the root.');
      ELSE
         Error_SYS.Appl_General(service_, 'INVDOCROOT: Document must have a single root-element.');
      END IF;
   ELSE
      Error_SYS.Appl_General(service_, 'INVDOCROOTMISS: Document must have a root-element.');
   END IF;
   document_id_ := Get_Id___(element_id_);
END Load_Document;


@UncheckedAccess
FUNCTION Read_Document (
   document_id_ OUT Document,
   error_       OUT VARCHAR2,
   document_table_ IN OUT DocTable,
   new_index_   IN OUT NUMBER,
   document_    IN  VARCHAR2 ) RETURN BOOLEAN
IS
   xml_        VARCHAR2(32000) := document_;
   xml_attr_   VARCHAR2(32000);
   name_       VARCHAR2(1000);
   type_       VARCHAR2(1000);
   attr_       VARCHAR2(32000);
   element_id_ Element;
BEGIN
   Get_Header___(xml_attr_, xml_);
   IF (Get_Tag___(name_, attr_, type_, xml_)) THEN
      IF (type_ = 'START') THEN
         Create_Document(element_id_, document_table_, new_index_, name_, xml_attr_);
         Add_Attributes(document_table_, element_id_, attr_ );
         Add_Tags___(element_id_, document_table_, new_index_, xml_);
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            error_ := Language_SYS.Translate_Constant(service_, 'INVDOCFMT: Invalid document format [:P1]', xml_);
            RETURN (FALSE);
         END IF;
      ELSIF (type_ = 'TERM') THEN --Empty documents is OK
         Create_Document(element_id_, document_table_, new_index_, name_, xml_attr_);
         Add_Attributes(document_table_, element_id_, attr_ );
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            error_ := Language_SYS.Translate_Constant(service_, 'INVDOCUFORMAT: Invalid document format');
            RETURN (FALSE);
         END IF;
      ELSIF (type_ = 'END') THEN
         error_ := Language_SYS.Translate_Constant(service_, 'INVDOCEND: End-tag found at the root.');
         RETURN (FALSE);
      ELSE
         error_ := Language_SYS.Translate_Constant(service_, 'INVDOCROOT: Document must have a single root-element.');
         RETURN (FALSE);
      END IF;
   ELSE
      error_ := Language_SYS.Translate_Constant(service_, 'INVDOCROOTMISS: Document must have a root-element.');
      RETURN (FALSE);
   END IF;
   document_id_ := Get_Id___(element_id_);
   RETURN (TRUE);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (FALSE);
END Read_Document;


@UncheckedAccess
PROCEDURE Create_Document (
   document_id_ OUT Document,
   document_table_  OUT DocTable,
   new_index_   IN OUT NUMBER, 
   root_name_   IN  VARCHAR2,
   header_      IN  VARCHAR2 DEFAULT NULL,
   attr_        IN  VARCHAR2 DEFAULT NULL ) 
IS
   d_id_         NUMBER := Get_New_Index___(new_index_);
   msdtdt_       VARCHAR2(8) := 'xmlns:dt';
   msdtdt_value_ VARCHAR2(35) := 'urn:schemas-microsoft-com:datatypes';
   version_text_ VARCHAR2(8) := 'version';
   version_      VARCHAR2(8) := '1.0';
BEGIN
-- Create a document node with one root element according to guidelines
   Check_Name___(root_name_);
   document_table_(d_id_).parent_id := NULL; -- This is the top node
   document_table_(d_id_).name := root_name_; -- The name of the root elemet

   Client_SYS.Clear_Attr(document_table_(d_id_).document);
   Get_Attr___(document_table_(d_id_).document, header_); 
   Client_SYS.Set_Item_Value( version_text_, version_, document_table_(d_id_).document);

   Client_SYS.Clear_Attr(document_table_(d_id_).attributes);
   Get_Attr___(document_table_(d_id_).attributes, attr_);
   Client_SYS.Set_Item_Value( msdtdt_, msdtdt_value_, document_table_(d_id_).attributes); -- Attributes for the root element

   document_table_(d_id_).value := NULL; -- Value, normally NULL
   document_table_(d_id_).is_value := NULL; -- IsValue, normally NULL
   document_id_ := Get_Id___(d_id_);
END Create_Document;


@UncheckedAccess
PROCEDURE Add_Element (
   element_id_   OUT    Element,
   document_table_ IN OUT DocTable,
   new_index_    IN OUT NUMBER,
   parent_id_    IN     Element,
   name_         IN     VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   Client_SYS.Clear_Attr(attr_); -- Clear attributes
   New_Element___(element_id_, document_table_, new_index_, parent_id_, name_, NULL, NULL, attr_);
END Add_Element;


@UncheckedAccess
PROCEDURE Add_Element (
   element_id_   OUT    Element,
   document_table_ IN OUT DocTable,
   new_index_    IN OUT NUMBER,
   parent_id_    IN     Element,
   name_         IN     VARCHAR2,
   value_        IN     VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_); -- Clear attributes
   Client_SYS.Add_To_Attr('dt:dt', 'string', attr_); -- String format
   New_Element___(element_id_, document_table_, new_index_, parent_id_, name_, Encode_Value___(value_), TRUE, attr_);
END Add_Element;


@UncheckedAccess
PROCEDURE Add_Element (
   element_id_   OUT    Element,
   document_table_ IN OUT DocTable,
   new_index_    IN OUT NUMBER,
   parent_id_    IN     Element,
   name_         IN     VARCHAR2,
   value_        IN     NUMBER )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_); -- Clear attributes
   Client_SYS.Add_To_Attr('dt:dt', 'number', attr_); -- Number format
   New_Element___(element_id_, document_table_, new_index_, parent_id_, name_, Encode_Value___(to_char(value_)), TRUE, attr_);
END Add_Element;


@UncheckedAccess
PROCEDURE Add_Element (
   element_id_   OUT    Element,
   document_table_ IN OUT DocTable,
   new_index_    IN OUT NUMBER,
   parent_id_    IN     Element,
   name_         IN     VARCHAR2,
   value_        IN     DATE )
IS
   attr_ VARCHAR2(32000);
   date_ VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(attr_); -- Clear attributes
   Client_SYS.Add_To_Attr('dt:dt', 'dateTime.tz', attr_); -- Date format
   IF (value_ IS NOT NULL) THEN
      date_ := to_char(value_, 'YYYY-MM-DD')||'T'||to_char(value_, 'HH24:MI:SS')||'+00:00';
   ELSE
      date_ := NULL;
   END IF;
   New_Element___(element_id_, document_table_, new_index_, parent_id_, name_, Encode_Value___(date_), TRUE, attr_); -- Timezone to be complemented. 00:00 = GMT
END Add_Element;


@UncheckedAccess
PROCEDURE Add_Xml (
   element_id_ OUT Element,
   document_table_ IN OUT DocTable, 
   new_index_  IN OUT NUMBER,
   parent_id_  IN  Element,
   xml_in_     IN  VARCHAR2 )
IS
   xml_   VARCHAR2(32000) := xml_in_;
   name_  VARCHAR2(1000);
   type_  VARCHAR2(1000);
   attr_  VARCHAR2(32000);
   root_  Element;
BEGIN
   IF (Get_Tag___(name_, attr_, type_, xml_)) THEN
      IF (type_ = 'START') THEN
         Add_Element(root_, document_table_, new_index_, parent_id_, name_);
         Add_Attributes(document_table_, root_, attr_ );
         Add_Tags___(root_, document_table_, new_index_, xml_);
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            Error_SYS.Appl_General(service_, 'INVXMLFMT: Invalid xml [:P1]', xml_);
         END IF;
      ELSIF (type_ = 'TERM') THEN --Empty xml is OK
         Add_Element(root_, document_table_, new_index_, parent_id_, name_);
         Add_Attributes(document_table_, root_, attr_ );
         IF (Left_Trim___(xml_) IS NOT NULL) THEN
            Error_SYS.Appl_General(service_, 'INVXMLFMT: Invalid xml [:P1]', xml_);
         END IF;
      ELSIF (type_ = 'END') THEN
         Error_SYS.Appl_General(service_, 'INVDOCEND: End-tag found at the root.');
      ELSE
         Error_SYS.Appl_General(service_, 'INVXMLROOT: Xml must have a single root-element.');
      END IF;
   ELSE
      Error_SYS.Appl_General(service_, 'INVXMLROOTMISS: Xml must have a root-element [:P1].', xml_);
   END IF;
   element_id_ := Get_Id___(root_);
END Add_Xml;


@UncheckedAccess
PROCEDURE Set_Value (
   document_table_ IN OUT DocTable,
   element_id_   IN Element,
   value_        IN VARCHAR2 )
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   IF (document_table_(e_id_).is_value OR document_table_(e_id_).is_value IS NULL) THEN
      Add_Attribute(document_table_, element_id_, 'dt:dt', 'string');
      document_table_(e_id_).value := Encode_Value___(value_);
      document_table_(e_id_).is_value := TRUE;
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLVAL: Parent node [:P1] can not have a value', document_table_(e_id_).name);
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   document_table_ IN OUT DocTable,
   element_id_   IN Element,
   value_        IN NUMBER )
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   IF (document_table_(e_id_).is_value OR document_table_(e_id_).is_value IS NULL) THEN
      Add_Attribute(document_table_, element_id_, 'dt:dt', 'number');
      document_table_(e_id_).value := Encode_Value___(to_number(value_));
      document_table_(e_id_).is_value := TRUE;
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLVAL: Parent node [:P1] can not have a value', document_table_(e_id_).name);
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   document_table_ IN OUT DocTable,
   element_id_   IN Element,
   value_        IN DATE )
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   -- An element with a value other than NULL is considered a leaf-node which cannot have children
   IF (document_table_(e_id_).is_value OR document_table_(e_id_).is_value IS NULL) THEN
      Add_Attribute(document_table_, element_id_, 'dt:dt', 'dateTime.tz');
      IF (value_ IS NOT NULL) THEN
         document_table_(e_id_).value := Encode_Value___(to_char(value_, 'YYYY-MM-DD')||' '||to_char(value_, 'HH24:MI:SS')||'+00:00');
      ELSE
         document_table_(e_id_).value := NULL;
      END IF;
      document_table_(e_id_).is_value := TRUE;
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLVAL: Parent node [:P1] can not have a value', document_table_(e_id_).name);
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Add_Attribute (
   document_table_ IN OUT DocTable,
   element_id_   IN  Element,
   name_         IN  VARCHAR2,
   value_        IN  VARCHAR2 )
IS
   e_id_       NUMBER := Get_Index___(element_id_);
BEGIN
   Check_Name___(name_);
   Client_SYS.Set_Item_value(name_, value_, document_table_(e_id_).attributes);
END Add_Attribute;


@UncheckedAccess
PROCEDURE Add_Attributes (
   document_table_ IN OUT DocTable,
   element_id_   IN  Element,
   list_         IN  VARCHAR2 )
IS
   attr_    VARCHAR2(32000);
   ptr_     NUMBER := NULL;
   name_    VARCHAR2(1000);
   value_   VARCHAR2(32000);
BEGIN
   Get_Attr___(attr_, list_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Add_Attribute(document_table_, element_id_, name_, value_);
   END LOOP;
END Add_Attributes;


@UncheckedAccess
PROCEDURE Get_First_Child (
   element_id_   OUT Element,
   document_table_ IN DocTable,
   new_index_    IN NUMBER,
   parent_id_    IN  Element )
IS
   p_id_ NUMBER := Get_Index___(parent_id_);
BEGIN
   FOR loop_ IN p_id_ + 1 .. new_index_ - 1 LOOP
      IF (document_table_(loop_).parent_id = p_id_) THEN
         element_id_ := Get_Id___(loop_);
         RETURN;
      END IF;
   END LOOP;
   element_id_ := Get_Id___(NULL);
END Get_First_Child;


@UncheckedAccess
PROCEDURE Get_Next_Child (
   element_id_   OUT Element,
   document_table_ IN DocTable,
   new_index_    IN NUMBER,
   sibling_id_   IN  Element)
IS
   s_id_ NUMBER := Get_Index___(sibling_id_);
   p_id_ NUMBER := Get_Index___(Get_Parent(sibling_id_, document_table_, new_index_));
BEGIN
   FOR loop_ IN s_id_ + 1 .. new_index_ - 1 LOOP
      IF (document_table_(loop_).parent_id = p_id_) THEN
         element_id_ := Get_Id___(loop_);
         RETURN;
      END IF;
   END LOOP;
   element_id_ := Get_Id___(NULL);
END Get_Next_Child;


@UncheckedAccess
FUNCTION Get_Name (
   element_id_   IN  Element,
   document_table_ IN DocTable ) RETURN VARCHAR2
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
-- No datatype checking...
   RETURN (document_table_(e_id_).name);
END Get_Name;


@UncheckedAccess
FUNCTION Get_Value (
   element_id_   IN  Element,
   document_table_ IN DocTable ) RETURN VARCHAR2
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
-- No datatype checking...
   RETURN (Encode_Value___(document_table_(e_id_).value));
END Get_Value;


@UncheckedAccess
FUNCTION Get_Xml (
   element_id_   IN  Element,
   document_table_ IN OUT DocTable,
   new_index_    IN NUMBER ) RETURN VARCHAR2
IS
   e_id_  NUMBER := Get_Index___(element_id_);
   text_  VARCHAR2(32000);
   value_ VARCHAR2(32000);
   attr_  VARCHAR2(32000);
BEGIN
-- No datatype checking...
   attr_ := Pack_Attr___(document_table_(e_id_).attributes);
   IF (attr_ IS NOT NULL) THEN
      attr_ := ' ' || attr_;
   END IF;
   IF (document_table_(e_id_).is_value) THEN
      RETURN ('<' || document_table_(e_id_).name || attr_ || '>' || value_ ||  '</' || document_table_(e_id_).name || '>');
   ELSIF (document_table_(e_id_).is_value IS NULL) THEN
      RETURN ('<' || document_table_(e_id_).name || attr_ || '/>');
   ELSE
      value_ := Pack_Children___(e_id_, FALSE, document_table_, new_index_);
      IF (value_ IS NOT NULL) THEN
         text_ := '<' || document_table_(e_id_).name || attr_ || '>' || value_ ||  '</' || document_table_(e_id_).name || '>';
      ELSE
         text_ := '<' || document_table_(e_id_).name || attr_ || '/>';
      END IF;
      RETURN (text_);
   END IF;
END Get_Xml;


@UncheckedAccess
FUNCTION Get_Attribute (
   element_id_ IN  Element,
   document_table_ IN DocTable,
   name_       IN  VARCHAR2 ) RETURN VARCHAR2
IS
   e_id_       NUMBER := Get_Index___(element_id_);
BEGIN
   RETURN (Client_SYS.Get_Item_Value(name_, document_table_(e_id_).attributes));
END Get_Attribute;


@UncheckedAccess
FUNCTION Get_Attributes (
   element_id_ IN  Element,
   document_table_ IN DocTable ) RETURN VARCHAR2
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   RETURN (Pack_Attr___(document_table_(e_id_).attributes));
END Get_Attributes;


@UncheckedAccess
FUNCTION Get_Parent (
   element_id_ IN Element,
   document_table_ IN DocTable,
   new_index_  IN NUMBER ) RETURN Element
IS
   e_id_ NUMBER := Get_Index___(element_id_);
BEGIN
   IF (document_table_(e_id_).document IS NOT NULL) THEN -- Document has no parent
      Error_SYS.Appl_General(service_, 'XMLDOCPAR: A document can have no parent element.');
   ELSIF (NOT Is_Element(document_table_(e_id_).parent_id, new_index_)) THEN
      Error_SYS.Appl_General(service_, 'XMLELMPAR: Element [:P1] has no parent element.', e_id_);
   ELSE
      RETURN (Get_Id___(document_table_(e_id_).parent_id));
   END IF;
END Get_Parent;


@UncheckedAccess
FUNCTION Get_Root (
   document_id_ IN Document ) RETURN Element
IS
BEGIN
   RETURN (document_id_);
END Get_Root;


@UncheckedAccess
FUNCTION Get_Document (
   document_id_  IN Document,
   document_table_ IN OUT DocTable,
   new_index_    IN NUMBER,
   flush_memory_ IN BOOLEAN DEFAULT TRUE ) RETURN VARCHAR2
IS
   document_  VARCHAR2(32000);
   head_attr_ VARCHAR2(32000);
   attr_      VARCHAR2(32000);
   d_id_ NUMBER := Get_Index___(document_id_);
BEGIN
   IF (document_table_(d_id_).document IS NOT NULL ) THEN
      head_attr_ := Pack_Attr___(document_table_(d_id_).document);
      IF (head_attr_ IS NOT NULL) THEN
         head_attr_ := ' ' || head_attr_;
      END IF;
      attr_ := Pack_Attr___(document_table_(d_id_).attributes);
      IF (attr_ IS NOT NULL) THEN
         attr_ := ' ' || attr_;
      END IF;
      IF (document_table_(d_id_).value IS NULL) THEN
         document_ := '<?xml' || head_attr_ || ' ?>' || chr(10) || 
                      '<' || document_table_(d_id_).name || attr_ || '>' ||
                             Pack_Children___(d_id_, flush_memory_, document_table_, new_index_) ||  '</' || document_table_(d_id_).name || '>';
      ELSE
         document_ := '<?xml' || head_attr_ || ' ?>' || chr(10) || 
                      '<' || document_table_(d_id_).name || attr_ ||'>' ||
                             document_table_(d_id_).value || '</' || document_table_(d_id_).name || '>';
      END IF;
      IF (flush_memory_) THEN
         document_table_(d_id_) := NULL; -- Release memory
      END IF;
      RETURN (document_);
   ELSE
      Error_SYS.Appl_General(service_, 'XMLILLDOC: Refered document [:P1] is not valid.', d_id_);
   END IF;
END Get_Document;


@UncheckedAccess
FUNCTION Is_Element (
   element_id_ IN Element,
   new_index_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Index___(element_id_) IS NOT NULL AND Get_Index___(element_id_) >= 1 AND Get_Index___(element_id_) < new_index_) THEN
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Is_Element;


@UncheckedAccess
FUNCTION Is_Parent (
   element_id_ IN Element,
   document_table_ IN DocTable ) RETURN BOOLEAN
IS
BEGIN
   RETURN (NOT document_table_(Get_Id___(element_id_)).is_value);
END Is_Parent;



