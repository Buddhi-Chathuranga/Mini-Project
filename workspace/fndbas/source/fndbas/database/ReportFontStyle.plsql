-----------------------------------------------------------------------------
--
--  Logical unit: ReportFontStyle
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

PROCEDURE New_Font_Style(
   objid_          OUT VARCHAR2,
   objversion_     OUT VARCHAR2,
   font_name_      IN  VARCHAR2,
   font_file_name_ IN  VARCHAR2,
   style_          IN  VARCHAR2,
   default_font_   IN  VARCHAR2)
IS
   attr_ VARCHAR2(2000);
   newrec_ report_font_style_tab%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   IF Check_Exist___(font_name_, font_file_name_, style_)  THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, font_name_, font_file_name_, style_);
   ELSE
      Client_SYS.Add_To_Attr('FONT_NAME', font_name_, attr_);
      Client_SYS.Add_To_Attr('FILE_NAME', font_file_name_, attr_);
      Client_SYS.Add_To_Attr('STYLE', style_, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE', default_font_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END New_Font_Style;


@UncheckedAccess
FUNCTION Get_Font_Styles(
   font_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   font_styles_ VARCHAR2(1000);
   font_style_ report_font_style_tab.style%TYPE;
   CURSOR get_font_style IS
      SELECT style
      FROM report_font_style_tab
      WHERE font_name = font_name_;
BEGIN
   -- things happen here 
   OPEN get_font_style;
   LOOP
      FETCH get_font_style INTO font_style_;
      EXIT  WHEN  get_font_style%NOTFOUND;
      font_styles_ :=font_styles_|| font_style_||',';

   END LOOP;
   font_styles_ := RTRIM(font_styles_,',');
   CLOSE get_font_style;
   RETURN font_styles_;
END Get_Font_Styles;

FUNCTION Get_Font_Styles_Info(
   font_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   font_styles_  REPORT_FONT_STYLE_TAB%ROWTYPE;
   font_styles_attr_ VARCHAR2(32000);
   CURSOR rep_font_style_cur   IS
      SELECT * 
      FROM REPORT_FONT_STYLE_TAB
      WHERE font_name = font_name_;      
BEGIN
   OPEN rep_font_style_cur;
   font_styles_attr_ :='';
   LOOP
      FETCH rep_font_style_cur INTO font_styles_;
      EXIT WHEN rep_font_style_cur%NOTFOUND;
      font_styles_attr_:=font_styles_attr_||font_styles_.font_name||
             ','|| font_styles_.file_name||
             ','||font_styles_.style||';';
   END LOOP;          
   CLOSE rep_font_style_cur;
   RETURN font_styles_attr_;
END Get_Font_Styles_Info;

FUNCTION Get_All_Font_Styles_Info(
   font_name_ IN VARCHAR2 ) RETURN CLOB
IS
   report_font_style_ REPORT_FONT_STYLE_TAB%ROWTYPE;
   --temp_font_info_ CLOB;
   temp_font_info_ VARCHAR2(1000);
   report_font_style_clob_  CLOB;
   CURSOR rep_font_style_cur   IS
      SELECT * 
      FROM REPORT_FONT_STYLE_TAB;

BEGIN

   OPEN rep_font_style_cur ;
   --report_font_style_clob_ := '';
   dbms_lob.Createtemporary(report_font_style_clob_,TRUE);
   LOOP
      FETCH rep_font_style_cur INTO report_font_style_;
      EXIT WHEN  rep_font_style_cur%NOTFOUND;
      --temp_font_info_ := TO_CLOB(report_font_style_.font_name||','||report_font_style_.file_name||','||report_font_style_.style||';' );
      --dbms_lob.Append(report_font_style_clob_,temp_font_info_);
      temp_font_info_:=report_font_style_.font_name||','||report_font_style_.file_name||','||report_font_style_.style||';';
      dbms_lob.Writeappend(report_font_style_clob_,length(temp_font_info_),temp_font_info_);

      --report_font_style_clob_:=report_font_style_clob_||font_styles_.font_name||','||font_styles_.file_name||','||font_styles_.style||';';
   END LOOP;
   CLOSE rep_font_style_cur;
   --report_font_style_clob_:=temp_clob_;
   RETURN report_font_style_clob_ ;
END Get_All_Font_Styles_Info;

PROCEDURE Update_Font_Style(
   font_name_   IN VARCHAR2,
   file_name_   IN  VARCHAR2,
   style_       IN  VARCHAR2,
   is_base_     IN VARCHAR2)
IS
   info_         VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(100);
   
BEGIN
   IF (NOT Report_Font_Style_API.Exists(font_name_,file_name_,style_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME',font_name_,attr_);
      Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
      Client_SYS.Add_To_Attr('STYLE',style_,attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE
      IF ((UPPER(is_base_) != 'TRUE')) THEN
         Get_Id_Version_By_Keys___ (objid_,objversion_,font_name_,file_name_,style_);
         Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
         Modify__(info_, objid_, objversion_,attr_, 'DO');
      END IF;
   END IF;      
END Update_Font_Style;

PROCEDURE Update_Sazanami_Gothic_Style
   
IS
   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   font_count_    NUMBER;
   
   CURSOR font_count IS
   SELECT count(font_name)
      INTO font_count_
      FROM report_font_style_tab
      WHERE UPPER(font_name) = UPPER('Sazanami Gothic');    
   
BEGIN

   OPEN font_count;
   FETCH font_count INTO font_count_;
   CLOSE font_count;
   
   IF (font_count_ = 0) THEN
      --Regular
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME','Sazanami Gothic',attr_);
      Client_SYS.Add_To_Attr('FILE_NAME','sazanami-gothic.ttf',attr_);
      Client_SYS.Add_To_Attr('STYLE','Regular',attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      --Bold
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME','Sazanami Gothic',attr_);
      Client_SYS.Add_To_Attr('FILE_NAME','sazanami-gothicbd.ttf',attr_);
      Client_SYS.Add_To_Attr('STYLE','Bold',attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      --Italic
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME','Sazanami Gothic',attr_);
      Client_SYS.Add_To_Attr('FILE_NAME','sazanami-gothicit.ttf',attr_);
      Client_SYS.Add_To_Attr('STYLE','Italic',attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      --Bold Italic
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FONT_NAME','Sazanami Gothic',attr_);
      Client_SYS.Add_To_Attr('FILE_NAME','sazanami-gothicbdit.ttf',attr_);
      Client_SYS.Add_To_Attr('STYLE','Bold Italic',attr_);
      Client_SYS.Add_To_Attr('DEFAULT_STYLE','TRUE',attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
   END IF;
END Update_Sazanami_Gothic_Style;