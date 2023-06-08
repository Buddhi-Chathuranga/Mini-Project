-----------------------------------------------------------------------------
--
--  Logical unit: ReportFont
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------




FUNCTION Get_Number_From_Booleam (
   val_ IN BOOLEAN ) RETURN NUMBER
IS
BEGIN
   IF (val_) THEN 
     RETURN 1;
   ELSE
     RETURN 0;
   END IF;
END Get_Number_From_Booleam;   
   
PROCEDURE Enumerate_Report_Fonts(
   font_name_list_ OUT VARCHAR2)
IS
   temp_font_name_    Report_font.font_name%TYPE;
   
   CURSOR list_report_fonts_cur IS
      SELECT font_name 
      FROM report_font;
BEGIN
   OPEN list_report_fonts_cur;
   font_name_list_ :='';
   LOOP
      FETCH list_report_fonts_cur INTO temp_font_name_;
      EXIT WHEN list_report_fonts_cur%NOTFOUND;
      font_name_list_ := font_name_list_ || temp_font_name_ || Client_sys.field_separator_;
   END LOOP;
END Enumerate_Report_Fonts;

   
PROCEDURE New_Row(
objid_ OUT VARCHAR2,
objversion_ OUT VARCHAR2,
font_name_ IN VARCHAR2,
encoding_ IN VARCHAR2,
font_styles_ IN VARCHAR2,
deployment_ IN VARCHAR2,
lock_font_ IN VARCHAR2)
IS
   attr_ VARCHAR2(2000);
   newrec_ REPORT_FONT_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('FONT_NAME', font_name_, attr_);
   Client_SYS.Add_To_Attr('ENCODING', Fnd_Boolean_Api.Get_Client_Value(Get_Number_From_Booleam(Fnd_Boolean_Api.Evaluate(encoding_))), attr_);
   Client_SYS.Add_To_Attr('FONT_STYLES', font_styles_, attr_);
   Client_SYS.Add_To_Attr('DEPLOYMENT', deployment_, attr_);
   Client_SYS.Add_To_Attr('LOCK_FONT', Fnd_Boolean_Api.Get_Client_Value(Get_Number_From_Booleam(Fnd_Boolean_Api.Evaluate(lock_font_))), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New_Row;


PROCEDURE Update_Report_Font(
   font_name_   IN VARCHAR2,
   is_base_     IN VARCHAR2)
IS
   font_count_    NUMBER;
   deployment_    VARCHAR2(10);
   lock_font_     VARCHAR2(20);
   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   
   CURSOR font_count IS
   SELECT count(font_name)
      INTO font_count_
      FROM report_font_tab
      WHERE UPPER(font_name) = UPPER(font_name_); 
   
   
BEGIN
   OPEN font_count;
   FETCH font_count INTO font_count_;
   CLOSE font_count;

   IF (font_count_ > 0) THEN
      IF (UPPER(is_base_) != 'TRUE') THEN
         deployment_ := 'Database';
      END IF;
   ELSE
      IF (UPPER(is_base_) = 'TRUE') THEN
         deployment_ := 'Base';
         lock_font_ := 'True';
      ELSE
         deployment_ := 'Database';
         lock_font_ := 'False';
      END IF;      
   END IF;
   
   IF ((font_count_ = 0) OR (UPPER(is_base_) != 'TRUE')) THEN
      IF (NOT Report_Font_API.Exists(font_name_)) THEN
         New__ (info_, objid_, objversion_, attr_, 'PREPARE');
         Client_SYS.Add_To_Attr('FONT_NAME',font_name_,attr_);
         Client_SYS.Add_To_Attr('ENCODING','False',attr_);
         Client_SYS.Add_To_Attr('DEPLOYMENT',deployment_,attr_);
         Client_SYS.Add_To_Attr('LOCK_FONT',lock_font_,attr_);
         New__(info_, objid_, objversion_,attr_, 'DO');
      ELSE
         Get_Id_Version_By_Keys___ (objid_,objversion_,font_name_);
         Client_SYS.Add_To_Attr('DEPLOYMENT',deployment_,attr_);
         Modify__(info_, objid_, objversion_,attr_, 'DO');
      END IF;      
   END IF;
END Update_Report_Font;