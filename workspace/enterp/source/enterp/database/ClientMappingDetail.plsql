-----------------------------------------------------------------------------
--
--  Logical unit: ClientMappingDetail
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020121  RAFA    IID 10998/10999 Created
--  131014  Isuklk  CAHOOK-2678 Refactoring in ClientMappingDetail.entity
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Object_Title_From_View___ (
   view_name_       IN VARCHAR2,
   column_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   text_    VARCHAR2(4000);
   CURSOR get_prompt_text IS
      SELECT Dictionary_SYS.Comment_Value_('PROMPT', comments)  prompt
      FROM   fnd_col_comments
      WHERE  table_name = view_name_
      AND    column_name = column_name_;
BEGIN
   OPEN get_prompt_text;
   FETCH get_prompt_text INTO text_;
   CLOSE get_prompt_text;
   -- the object_title column only handles varchar2(50)
   RETURN SUBSTR(text_, 1, 50);
END Get_Object_Title_From_View___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Mapping_Detail (
   public_rec_ IN Client_Mapping_API.Client_Mapping_Detail_Pub )
IS
   objid_         client_mapping_detail.objid%TYPE;
   objversion_    client_mapping_detail.objversion%TYPE;
   attr_          VARCHAR2(100);
   newrec_        client_mapping_detail_tab%ROWTYPE;
   client_window_ VARCHAR2(100);
   view_          VARCHAR2(500);
   column_id_     VARCHAR2(30);
   index_         NUMBER;
   lov_view_      VARCHAR2(30);
   CURSOR get_client_window IS
      SELECT client_window
      FROM   client_mapping_tab
      WHERE  module = newrec_.module
      AND    lu = newrec_.lu
      AND    mapping_id = newrec_.mapping_id;
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'MODULE', public_rec_.module);
   Error_SYS.Check_Not_Null(lu_name_, 'LU', public_rec_.lu);
   Error_SYS.Check_Not_Null(lu_name_, 'MAPPING_ID', public_rec_.mapping_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COLUMN_ID', public_rec_.column_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COLUMN_TYPE', public_rec_.column_type);
   Error_SYS.Check_Not_Null(lu_name_, 'TRANSLATION_TYPE', public_rec_.translation_type);
   Error_SYS.Check_Not_Null(lu_name_, 'TRANSLATION_LINK', public_rec_.translation_link);
   newrec_.module           := public_rec_.module;
   newrec_.lu               := public_rec_.lu;
   newrec_.mapping_id       := public_rec_.mapping_id;
   newrec_.translation_type := public_rec_.translation_type;
   newrec_.translation_link := public_rec_.translation_link;
   newrec_.column_id        := public_rec_.column_id;
   newrec_.column_type      := public_rec_.column_type;
   newrec_.lov_reference    := public_rec_.lov_reference;
   newrec_.enumerate_method := public_rec_.enumerate_method;
   newrec_.edit_flag        := public_rec_.edit_flag;
   newrec_.object_title     := public_rec_.object_title;
   newrec_.rowversion       := public_rec_.rowversion;
   Client_Mapping_API.Exist(newrec_.module, newrec_.lu, newrec_.mapping_id);
   Translation_Type_API.Exist_Db(newrec_.translation_type);
   Mapping_Column_Type_API.Exist_Db(newrec_.column_type);
   IF (newrec_.object_title IS NULL) THEN
      -- Try to get the object title of the column
      IF (newrec_.translation_type = 'SRDPATH') THEN
         index_ := Instr(newrec_.translation_link,'.');
         view_ := SUBSTR(newrec_.translation_link, 1, index_-1);
         column_id_ := SUBSTR(newrec_.translation_link, index_ +1, 30);
         IF (view_ IS NOT NULL) THEN
            newrec_.object_title := Get_Object_Title_From_View___(view_, column_id_);
         END IF;
      END IF;
   END IF;
   IF (Check_Exist___(newrec_.module, newrec_.lu, newrec_.mapping_id, newrec_.column_id)) THEN
      UPDATE client_mapping_detail_tab
         SET translation_type = newrec_.translation_type,
             translation_link = newrec_.translation_link,
             column_type = newrec_.column_type,
             lov_reference = newrec_.lov_reference,
             enumerate_method = newrec_.enumerate_method,
             edit_flag  = newrec_.edit_flag,
             object_title = newrec_.object_title
         WHERE module = newrec_.module
         AND   lu = newrec_.lu
         AND   mapping_id = newrec_.mapping_id
         AND   column_id = newrec_.column_id;
   ELSE
      Insert___(objid_, objversion_, newrec_,  attr_);
   END IF;
   IF (newrec_.enumerate_method IS NOT NULL OR newrec_.lov_reference IS NOT NULL) THEN
      OPEN get_client_window;
      FETCH get_client_window INTO client_window_;
      CLOSE get_client_window;
   END IF;
   IF (newrec_.enumerate_method IS NOT NULL) THEN
      -- Register the method as a Presentation Object. To enable full access for this presentation object.
      Pres_Object_Util_API.New_Pres_Object_Sec(client_window_, newrec_.enumerate_method, 'METHOD', '6', 'Manual');
   END IF;
   IF (newrec_.lov_reference IS NOT NULL) THEN
      -- Register the view as a Presentation Object. To enable full access for this presentation object.
      -- Extract the view part of the variable. IF the lov reference looks like USER_FINANCE(COMPANY) only USER_FINANCE should be passed to Pres Object Sec.
      -- No validation that the view exists since the interface might be called from a component that has dynamic dependency to another 
      -- component that is not yet installed.
      index_ := Instr(newrec_.lov_reference, '(');
      IF (index_ > 0 ) THEN
         lov_view_ := SUBSTR(newrec_.lov_reference, 1, index_ - 1);
      ELSE
         lov_view_ := newrec_.lov_reference;
      END IF;
      Pres_Object_Util_API.New_Pres_Object_Sec(client_window_, lov_view_, 'VIEW', '5', 'Manual');
   END IF;
END Insert_Mapping_Detail;


