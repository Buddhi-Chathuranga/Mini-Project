-----------------------------------------------------------------------------
--
--  Logical unit: LanguageFontMapping
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050614  DOZE    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Get_Lang_Code_Desc_Mapping(
      lang_code_desc_map_list_ OUT VARCHAR2)
      IS
         temp_lang_code_ report_font_mapping_lang_code.lang_code %TYPE;
         temp_desc_code_ report_font_mapping_lang_code.description%TYPE;
         CURSOR lang_code_desc_map_cur
         IS
            SELECT lang_code,description
            FROM report_font_mapping_lang_code;
         
      BEGIN
         OPEN lang_code_desc_map_cur;
         lang_code_desc_map_list_ :='';
         LOOP
            FETCH lang_code_desc_map_cur INTO temp_lang_code_, temp_desc_code_;
            EXIT WHEN lang_code_desc_map_cur%NOTFOUND;
            lang_code_desc_map_list_ := lang_code_desc_map_list_||temp_lang_code_||'='||temp_desc_code_||',';
            
         END LOOP;
         CLOSE lang_code_desc_map_cur;
END Get_Lang_Code_Desc_Mapping;




PROCEDURE Modify_Font_Mapping (
   font_name_         IN VARCHAR2,
   language_code_     IN VARCHAR2,
   mapping_font_name_ IN VARCHAR2,
   font_size_change_  IN NUMBER)
IS
   attr_       VARCHAR2(32767);
   oldrec_     LANGUAGE_FONT_MAPPING_TAB%ROWTYPE;
   newrec_     LANGUAGE_FONT_MAPPING_TAB%ROWTYPE;
   objid_      LANGUAGE_FONT_MAPPING.objid%TYPE;
   objversion_ LANGUAGE_FONT_MAPPING.objversion%TYPE;
   indrec_     Indicator_Rec;
   
   not_exist   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(not_exist, -20111);
BEGIN
   Exist(font_name_,language_code_);
   
   IF (mapping_font_name_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAPPING_FONT_NAME', mapping_font_name_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('FONT_SIZE_CHANGE', font_size_change_, attr_);

   oldrec_ := Lock_By_Keys___(font_name_,language_code_);
   newrec_ := oldrec_;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);  
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
EXCEPTION
   WHEN not_exist THEN
      NULL;
END Modify_Font_Mapping;

PROCEDURE New_Font_Mapping (
   font_name_         IN VARCHAR2,
   language_code_     IN VARCHAR2,
   mapping_font_name_ IN VARCHAR2,
   font_size_change_  IN NUMBER)
   
IS
   newrec_        LANGUAGE_FONT_MAPPING_TAB%ROWTYPE;
   attr_          VARCHAR2(32767);
   objid_         LANGUAGE_FONT_MAPPING.objid%TYPE;
   objversion_    LANGUAGE_FONT_MAPPING.objversion%TYPE;
   indrec_     Indicator_Rec;
   
   duplicate      EXCEPTION;   
   PRAGMA         EXCEPTION_INIT(duplicate, -20112);
BEGIN
   Client_SYS.Add_To_Attr('FONT_NAME', font_name_, attr_);
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', language_code_, attr_);
   Client_SYS.Add_To_Attr('MAPPING_FONT_NAME', mapping_font_name_, attr_);
   Client_SYS.Add_To_Attr('FONT_SIZE_CHANGE', font_size_change_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_); 
   Insert___(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN duplicate THEN
      Modify_Font_Mapping (font_name_,
                           language_code_,
                           mapping_font_name_,
                           font_size_change_);
END New_Font_Mapping;
   
PROCEDURE Remove_Font_Mapping (
   font_name_         IN VARCHAR2,
   language_code_     IN VARCHAR2)
IS
BEGIN
   DELETE FROM language_font_mapping_tab
   WHERE font_name = font_name_ AND
   language_code = language_code_;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Remove_Font_Mapping;

FUNCTION Get_Font_Mapping (
   font_name_         IN VARCHAR2,
   language_code_     IN VARCHAR2) RETURN language_font_mapping_tab%ROWTYPE
IS
   rec_ language_font_mapping_tab%ROWTYPE;
BEGIN
   SELECT *
   INTO rec_
   FROM  language_font_mapping_tab
   WHERE font_name = font_name_ AND
   language_code = language_code_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      rec_.font_name := 'NONE';
      rec_.language_code := 'NONE';
   RETURN rec_;
END Get_Font_Mapping; 

