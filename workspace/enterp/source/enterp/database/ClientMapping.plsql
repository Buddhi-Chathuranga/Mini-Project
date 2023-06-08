-----------------------------------------------------------------------------
--
--  Logical unit: ClientMapping
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020121  RAFA    IID 10998/10999 Created
--  021023  ovjose  In Get_Link_Translation___ get PROG if translation for active lang is not found.
--  100226  ovjose  Added method Remove_Mapping.
--  111123  Samwlk  Added method Remove_Mapping_Per_Module.
--  131011  Isuklk  CAHOOK-2677 Refactoring in ClientMapping.entity
--  171027  Waudlk  STRFI-10517, Redesign of ISO20022 Payment Address and Institute Information.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Client_Mapping_Pub IS RECORD (
   module           VARCHAR2(6),
   lu               VARCHAR2(30),
   mapping_id       VARCHAR2(30),
   translation_type VARCHAR2(20),
   translation_link VARCHAR2(500),
   client_window    VARCHAR2(100),
   rowversion       DATE );

TYPE Client_Mapping_Detail_Pub IS RECORD (
   module           client_mapping_detail_tab.module%TYPE,
   lu               client_mapping_detail_tab.lu%TYPE,
   mapping_id       client_mapping_detail_tab.mapping_id%TYPE,
   column_id        client_mapping_detail_tab.column_id%TYPE,
   column_type      client_mapping_detail_tab.column_type%TYPE,
   translation_type client_mapping_detail_tab.translation_type%TYPE,
   translation_link client_mapping_detail_tab.translation_link%TYPE,
   lov_reference    client_mapping_detail_tab.lov_reference%TYPE,
   enumerate_method client_mapping_detail_tab.enumerate_method%TYPE,
   edit_flag        client_mapping_detail_tab.edit_flag%TYPE,
   object_title     client_mapping_detail_tab.object_title%TYPE,
   rowversion       client_mapping_detail_tab.rowversion%TYPE );
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Link_Translation___ (
   module_               IN  VARCHAR2,
   lu_                   IN  VARCHAR2,
   translation_type_db_  IN  VARCHAR2,
   translation_link_     IN  VARCHAR2,
   type_                 IN  VARCHAR2 ) RETURN VARCHAR2
IS
   lang_code_   VARCHAR2(4)   :=  NVL(Fnd_Session_API.Get_Language,'PROG');
   translation_ VARCHAR2(150);
BEGIN
   IF (translation_type_db_ = 'SRDPATH') THEN
      translation_ := Language_SYS.Lookup(type_, translation_link_, 'Prompt', lang_code_);
      -- if translation is not found for the langauge then try to get the prog text
      IF (translation_ IS NULL) THEN
         translation_ := Language_SYS.Lookup(type_, translation_link_, 'Prompt', 'PROG');
      END IF;
   ELSIF (translation_type_db_ = 'ATTRIBUTE') THEN
      translation_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_, translation_link_);
      -- if translation is not found for the langauge then try to get the prog text
      IF (translation_ IS NULL) THEN
         translation_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_, translation_link_, 'PROG');
      END IF;
   ELSE
      translation_ := NULL;
   END IF;
   RETURN(translation_);
END Get_Link_Translation___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Mapping_Message (
   msg_        OUT VARCHAR2,
   module_     IN  VARCHAR2,
   lu_         IN  VARCHAR2,
   mapping_id_ IN  VARCHAR2,
   skip_lov_   IN  BOOLEAN,
   skip_enum_  IN  BOOLEAN )
IS
   head_msg_          VARCHAR2(200);
   detail_msg_        VARCHAR2(5000);
   line_msg_          VARCHAR2(3000);
   translation_       VARCHAR2(250);
   i_                 PLS_INTEGER := 1;
   main_rec_          Client_Mapping_API.Public_Rec;
   CURSOR get_mapping_detail IS
      SELECT *
      FROM  client_mapping_detail_tab
      WHERE module = module_
      AND   lu     = lu_
      AND   mapping_id = mapping_id_;
BEGIN
   -- Define name of main (output) message
   msg_ := Message_SYS.Construct('SINGLEMAPPING');
   -- Get mapping header info and find translation
   main_rec_ := Get(module_, lu_, mapping_id_);
   translation_ := Get_Link_Translation___(module_, lu_, main_rec_.translation_type, main_rec_.translation_link, 'Logical Unit');
   -- Define name=HEADER for header message
   head_msg_ := Message_SYS.Construct('HEADER');
   -- Add attribute TRANS
   Message_SYS.Add_Attribute(head_msg_, 'TRANS', translation_);
   -- Add header message to main message
   Message_SYS.Add_Attribute(msg_, 'HEADER', head_msg_);
   -- Each detail line is represented by the message LINE containing the attributes
   -- NAME, TRANS, LOV and ENUM
   -- All sub messages are added to the message named DETAILS, where each sub message
   -- has the attributes '1', '2' etc
   detail_msg_ := Message_SYS.Construct('DETAILS');
   FOR rec_ IN get_mapping_detail LOOP
      line_msg_ := NULL;
      line_msg_ := Message_SYS.Construct('LINE' );
      translation_ := Get_Link_Translation___(module_, lu_, rec_.translation_type, rec_.translation_link, 'Column');
      Message_SYS.Add_Attribute(line_msg_, 'NAME', rec_.column_id);
      -- get object_title if translation is null
      IF (translation_ IS NULL) THEN
         translation_ := rec_.object_title;
      END IF;
      Message_SYS.Add_Attribute(line_msg_, 'TRANS', translation_);
      IF NOT (skip_lov_) THEN
         Message_SYS.Add_Attribute(line_msg_, 'LOV', rec_.lov_reference);
      END IF;
      IF NOT (skip_enum_) THEN
         Message_SYS.Add_Attribute(line_msg_, 'ENUM', rec_.enumerate_method);
      END IF;
      Message_SYS.Add_Attribute(line_msg_, 'EDIT', rec_.edit_flag);
      Message_SYS.Add_Attribute(detail_msg_, TO_CHAR(i_) , line_msg_);
      i_ := i_ + 1;
   END LOOP;
   -- now add the detail message to the out message
   Message_SYS.Add_Attribute(msg_, 'DETAILS', detail_msg_);
END Get_Mapping_Message;


PROCEDURE Insert_Mapping (
   public_rec_ IN client_mapping_pub )
IS
   objid_        client_mapping.objid%TYPE;
   objversion_   client_mapping.objversion%TYPE;
   attr_         VARCHAR2(100);
   newrec_       client_mapping_tab%ROWTYPE;   
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'MODULE', public_rec_.module);
   Error_SYS.Check_Not_Null(lu_name_, 'LU', public_rec_.lu);
   Error_SYS.Check_Not_Null(lu_name_, 'MAPPING_ID', public_rec_.mapping_id);
   newrec_.module           := public_rec_.module;
   newrec_.lu               := public_rec_.lu;
   newrec_.mapping_id       := public_rec_.mapping_id;
   newrec_.translation_type := public_rec_.translation_type;
   newrec_.translation_link := public_rec_.translation_link;
   newrec_.client_window    := public_rec_.client_window;
   newrec_.rowversion       := public_rec_.rowversion;
   IF (newrec_.translation_type IS NOT NULL) THEN
      Translation_Type_API.Exist_Db(newrec_.translation_type);
   END IF;
   -- IF client_window is frmCreateCompanyTemDetail then remove all child data
   IF (newrec_.client_window = 'frmCreateCompanyTemDetail') THEN
      DELETE FROM client_mapping_detail_tab
         WHERE module = newrec_.module
         AND lu = newrec_.lu
         AND mapping_id = newrec_.mapping_id;
   END IF;
   IF (Check_Exist___(newrec_.module, newrec_.lu, newrec_.mapping_id)) THEN
      UPDATE client_mapping_tab
         SET translation_type = newrec_.translation_type,
             translation_link = newrec_.translation_link
         WHERE module = newrec_.module
         AND   lu = newrec_.lu
         AND   mapping_id = newrec_.mapping_id;
   ELSE
      Insert___(objid_, objversion_, newrec_,  attr_);
   END IF;
END Insert_Mapping;


PROCEDURE Insert_Mapping_Detail (
   public_rec_ IN client_mapping_detail_pub )
IS
BEGIN
   Client_Mapping_Detail_API.Insert_Mapping_Detail(public_rec_);
END Insert_Mapping_Detail;


PROCEDURE Remove_Mapping (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2,
   mapping_id_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      client_mapping.objid%TYPE;
   objversion_ client_mapping.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, module_, lu_, mapping_id_);
   Remove__(info_, objid_, objversion_, 'DO');
END Remove_Mapping;


PROCEDURE Remove_Mapping_Per_Module (
   module_     IN VARCHAR2)
IS
   CURSOR get_mappings IS
      SELECT lu,mapping_id
      FROM   client_mapping_tab
      WHERE  module = module_;
BEGIN
   FOR rec_ IN get_mappings LOOP
      Client_Mapping_API.Remove_Mapping(module_, rec_.lu, rec_.mapping_id);
   END LOOP;   
END Remove_Mapping_Per_Module;         


PROCEDURE Remove_Mapping_Per_Lu (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
   CURSOR get_mappings IS
      SELECT lu, mapping_id
      FROM   client_mapping_tab
      WHERE  module = module_
      AND    lu = lu_;
BEGIN
   FOR rec_ IN get_mappings LOOP
      Remove_Mapping(module_, rec_.lu, rec_.mapping_id);
   END LOOP;   
END Remove_Mapping_Per_Lu;  