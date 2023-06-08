-----------------------------------------------------------------------------
--
--  Logical unit: ReportFontDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060110  DOZE  Added Enumerate_Font
--  180907  ddeslk  Added freeDocument() for each DOMDocument instance (BUG ID:143824)
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Load_File__ (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   font_name_      IN  VARCHAR2,
   font_file_name_ IN VARCHAR2)
IS
   -- font_name_  report_font_definition.font_name;
   
BEGIN
   --SELECT font_name INTO font_name_ from report_font_definition_tab where file_name = name_ ; 
   
    
     
   IF Check_Exist___(font_name_,font_file_name_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_,font_name_, font_file_name_);
   ELSE
      -- there is a error in this , how ever check if Load_File__ method is still in use
      INSERT
         INTO report_font_definition_tab (
            font_name,
            file_name,
            data,
            rowversion)
         VALUES (
            font_name_,
            font_file_name_,
            null,
            sysdate)
         RETURNING rowid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) INTO objid_, objversion_;
   END IF;
END Load_File__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------





PROCEDURE Load_File (
   objid_          OUT VARCHAR2,
   objversion_     OUT VARCHAR2,
   font_name_      IN  VARCHAR2,
   font_file_name_ IN VARCHAR2)
IS
BEGIN
   Load_File__ (   objid_ ,objversion_ ,   font_name_,font_file_name_  );
END Load_File;

   
   
@UncheckedAccess
-- ## to be considered for CORE Security ##
PROCEDURE Enumerate_Fonts (
   font_list_ IN OUT VARCHAR2 )
IS
   b_               BLOB;
   i_               INTEGER;
   l_               NUMBER;
   buffer_          RAW(32000);
   xmlstr_          VARCHAR2(32000);
   parser_          xmlparser.Parser;
   confxml_         xmldom.DOMDocument;
   response_        xmldom.DOMNodeList;
   curnode_         xmldom.DOMNode;
   element_         xmldom.DOMElement;
   node_count_      INTEGER;
   ret_             VARCHAR2(32000);
   font_name_       VARCHAR2(200);
   field_separator_ VARCHAR2(1) := Client_SYS.field_separator_;

   CURSOR fontxml IS
      SELECT data
      FROM report_font_definition_tab
      WHERE file_name = 'userconfig.xml';
BEGIN
   OPEN fontxml;
   FETCH fontxml INTO b_;
   IF fontxml%FOUND THEN
      CLOSE fontxml;
      l_ := dbms_lob.getlength(b_);
      dbms_lob.read(b_, l_, 1, buffer_);
      xmlstr_ := utl_raw.cast_to_varchar2(buffer_);
      parser_  := xmlparser.newParser;
      xmlparser.parseBuffer(parser_, xmlstr_);
      confxml_ := xmlparser.getDocument(parser_);
      xmlparser.freeParser(parser_);
      curnode_ := xmldom.makeNode(confxml_);
      curnode_ := xslprocessor.selectSingleNode(curnode_,'//configuration/fonts');
      response_ := xslprocessor.selectNodes(curnode_,'font/font-triplet');
      node_count_ := xmldom.getLength(response_);
      i_ := 0;
      WHILE i_ < node_count_ LOOP
         curnode_ := xmldom.item(response_, i_);
         element_ := xmldom.makeElement(curnode_);
         font_name_ := xmldom.getAttribute(element_, 'name');
         IF ((ret_ IS NULL) OR (instr(ret_, font_name_ || field_separator_) = 0)) THEN
            ret_ := ret_ || font_name_ || field_separator_;
         END IF;
         i_ := i_ + 1;
     END LOOP;
   ELSE
      CLOSE fontxml;
   END IF;
   font_list_ := ret_;
   xmldom.freeDocument ( confxml_ );
END Enumerate_Fonts;

PROCEDURE Update_Font_Definition(
   font_name_    IN  VARCHAR2,
   file_name_    IN  VARCHAR2,
   font_         IN  BLOB,
   is_base_      IN  VARCHAR2,
   is_new_font_  OUT VARCHAR2) 
IS
   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   
BEGIN
   IF (NOT Report_Font_Definition_API.Exists(font_name_, file_name_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME',font_name_,attr_);
      Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      Write_Data__(objversion_, objid_, font_);
      is_new_font_ := 'TRUE';
   ELSE
      IF (UPPER(is_base_) = 'FALSE') THEN
         Get_Id_Version_By_Keys___ (objid_,objversion_,font_name_, file_name_);
         Modify__(info_, objid_, objversion_,attr_, 'DO');
         Write_Data__(objversion_, objid_, font_);
      END IF;
      is_new_font_ := 'FALSE';
   END IF;      
END Update_Font_Definition;

