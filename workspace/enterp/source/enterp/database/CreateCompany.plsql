-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  000810  CAMK     Created
--  000810  MiJo     Added method New_Company__ and Create_Company__.
--  001130  LiSv     Changed method New_Company__ and Create_Company__.
--  001205  LiSv     Added method Rem_From_Attr___.
--  010123  LiSv     Added views to support active ISO codes, ACTIVE_ISO_CODES_ECT and ACTIVE_ISO_CODES_PCT.
--                   Added procedures Make_Company, Import___ and Export___.
--  010619  LiSv     Added procedures Pack_Date___, Split_Date___, Get_Increment___, Calc_New_Date___.
--  010619  Gawilk   Fixed bug # 15677. Checked General_SYS.Init_Method.
--  010820  OVJOSE   Added Create Company translation method Create_Company_Translations___
--  011206  OVJOSE   Enhancement of update company. Added Get_Crecomp_Rec___
--  020208  ovjose   Changed calls from create_company_reg_api to crecomp_component_api
--  020212  Thsrlk   Add Procedure Consistency_check, Remove_Consistency_check & add view VIEWCRECOMP
--  020302  Mnisse   exec_id_ is assigned from sequence.
--  020530  ovjose   Bug #29599 Corrected. Added condition when import template translations from Localization
--  021121  ovjose   Glob01. added Get_Navigator_Entry_Trans.
--  021127  stdafi   Glob06. Moved Export_Company_Templates__ to
--                   Temp_Key_Lu_Translation and removed Import_Company_Templates__.
--  030131  ovjose   Glob08. Changed method Create_New_Company__.
--  051221  Chlilk   Added General_SYS.Init_Method in Is_Template_Super_User. 
--  060106  Chlilk   Remove General_SYS.Init_Method in Is_Template_Super_User and added pragma.
--  060209  TsYolk   In Consistency_Check method char_length is used instead of data_length. Modified exec_id_.
--  100204  cldase   Modified Create_New_Company__ to handle input for a user defined calendar.
--  100226  ovjose   Added method Remove_Company_Templ_Comp.
--  101111  ovjose   Changes in Create_New_Company__ to pass all company creation parameters to all called LUs
--  110519  Hiralk   EASTONE-20104, Added missing assert safe annotation.
--  111123  Samwlk   Added method Remove_Company_Templs_Per_Comp
--  120824  Kagalk   Bug 104803, Added Move_User_Def_Co_Templ_Comp
--  130429  Chhulk   Bug 109773, Modified Get_Column_Mapping()  
--  130822  Jaralk   Bug 111218 Corrected the third parameter of General_SYS.Init_Method call to method name.
--  130614  DipeLK   TIBE-726, Removed global variable which check the exsistance of ACCRUL component.
--  121122  Charlk   DANU-137, Parallel currency implementation
--  140123  ovjose   Removed methods Remove_Consistency_Check and Consistency_Check, obsolete functionality
--  200203  Thpelk   Corrected in Create_New_Company__().
--  210202  Alwolk   FISPRING20-8691 ,Merged Bug 157233 - Corrected in Create_New_Company__().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE PkgNameTab IS TABLE OF VARCHAR2(30)
      INDEX BY BINARY_INTEGER;
TYPE ModuleNameTab IS TABLE OF VARCHAR2(30)
      INDEX BY BINARY_INTEGER;
TYPE MarkTab IS TABLE OF VARCHAR2(30)
      INDEX BY BINARY_INTEGER;

TYPE CompanyTemplateExpRec IS RECORD (
   file_name         VARCHAR2(250),
   component         VARCHAR2(6),
   file_content      VARCHAR2(20),
   output_file       BLOB);   
   
TYPE CompanyTemplateExpList IS TABLE OF CompanyTemplateExpRec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

ampersand_                 CONSTANT VARCHAR2(1) := CHR(38);
template_file_extension_   CONSTANT VARCHAR2(4) := '.ins';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Call_Company___ (
   pkg_name_   IN VARCHAR2,
   proc_name_  IN VARCHAR2,
   attr_       IN VARCHAR2 )
IS
   stmt_      VARCHAR2(300);
   bindinpar_ VARCHAR2(2000) := attr_;
BEGIN
   Assert_SYS.Assert_Is_Package_Method(pkg_name_,proc_name_);
   stmt_ := 'BEGIN ' || pkg_name_ || '.' || proc_name_ || '(:bindinpar_); END;';
   @ApproveDynamicStatement(2005-11-10,ovjose)
   EXECUTE IMMEDIATE stmt_ USING bindinpar_;
END Call_Company___;


PROCEDURE Get_Component___ (
   component_  OUT VARCHAR2,
   pkg_name_   IN  VARCHAR2 )
IS
   CURSOR get_module IS
      SELECT SUBSTR(text, INSTR(text,'''')+1, INSTR(text,'''',INSTR(text,'''')+1)-INSTR(text,'''')-1) module_name
      FROM   user_source
      WHERE  type = 'PACKAGE'
      AND    text LIKE '%module_%:=%''%''%'
      AND    line BETWEEN 2 AND 5
      AND    name = pkg_name_;
BEGIN
   OPEN  get_module;
   FETCH get_module INTO component_;
   CLOSE get_module;
END Get_Component___;


PROCEDURE Export___ (
   crecomp_rec_ IN Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec )
IS
   pub_rec_        Create_Company_Tem_API.Public_Rec_Templ;
   i_              NUMBER := 1;
   CURSOR get_data IS
      SELECT *
      FROM   active_iso_codes_pct;
BEGIN
   FOR pctrec_ IN get_data LOOP
      pub_rec_.template_id := crecomp_rec_.template_id;
      pub_rec_.component := 'ENTERP';
      pub_rec_.version  := crecomp_rec_.version;
      pub_rec_.lu := lu_name_;
      pub_rec_.item_id := i_;
      pub_rec_.c1 := pctrec_.active_code;
      Create_company_Tem_API.Insert_Detail_Data(pub_rec_);
      i_ := i_ + 1;
   END LOOP;
END Export___;


PROCEDURE Import___ (
   crecomp_rec_ IN Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec )
IS
   CURSOR get_data IS
      SELECT c1
      FROM   create_company_template_pub
      WHERE  component = 'ENTERP'
      AND    lu = lu_name_
      AND    template_id = crecomp_rec_.template_id
      AND    version     = crecomp_rec_.version;
   stmt_       VARCHAR2(300);
   msg_        VARCHAR2(2000);
   i_          NUMBER := 0;
   value_      VARCHAR2(100);
   pkg_method_ VARCHAR2(61);
   ptr_        NUMBER;
BEGIN
   FOR rec_ IN get_data LOOP
      i_ := i_ + 1;
      BEGIN
         pkg_method_ := SUBSTR(rec_.c1,1,INSTR(rec_.c1,'(')-1);
         ptr_ := INSTR(rec_.c1,'''');
         value_ := SUBSTR(rec_.c1,ptr_+1,(INSTR(rec_.c1,'''',1,2)-1)-ptr_);
         Assert_SYS.Assert_Is_Package_Method(pkg_method_);
         stmt_ := 'BEGIN ' || pkg_method_ || '(:value); END;';
         @ApproveDynamicStatement(2005-11-10,ovjose)
         EXECUTE IMMEDIATE stmt_ USING value_;
      EXCEPTION
         WHEN OTHERS THEN
            msg_ := SQLERRM;
            Create_Company_Log_API.Logging(crecomp_rec_.company, module_, 'CREATE_COMPANY_API', 'Error', msg_);
       END;
   END LOOP;
   IF (i_ = 0) THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'NODATAFOUND: No Data Found');
      Create_Company_Log_API.Logging(crecomp_rec_.company, module_, 'CREATE_COMPANY_API', 'CreatedSuccessfully', msg_);
   END IF;
   IF (msg_ IS NULL) THEN
      Create_Company_Log_API.Logging(crecomp_rec_.company, module_, 'CREATE_COMPANY_API', 'CreatedSuccessfully');
   ELSE
      Create_Company_Log_API.Logging(crecomp_rec_.company, module_, 'CREATE_COMPANY_API', 'CreatedWithErrors');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      msg_ := SQLERRM;
      Create_Company_Log_API.Logging(crecomp_rec_.company, module_, 'CREATE_COMPANY_API', 'Error', msg_);
END Import___;


PROCEDURE Pack_Date___ (
   date_           OUT DATE,
   year_           IN  NUMBER,
   month_          IN  NUMBER,
   day_            IN  NUMBER )
IS
BEGIN
   date_ := TO_DATE(LTRIM(TO_CHAR(year_,'0000')) || '-' ||
                    LTRIM(TO_CHAR(month_,'00'))  || '-' ||
                    LTRIM(TO_CHAR(day_,'00')),'YYYY-MM-DD');
END Pack_Date___;


PROCEDURE Split_Date___ (
   year_             OUT NUMBER,
   month_            OUT NUMBER,
   day_              OUT NUMBER,
   date_             IN  DATE )
IS
BEGIN
   year_    := TO_NUMBER(SUBSTR(TO_CHAR(date_,'yyyy-mm-dd'),1,4));
   month_   := TO_NUMBER(SUBSTR(TO_CHAR(date_,'yyyy-mm-dd'),6,2));
   day_     := TO_NUMBER(SUBSTR(TO_CHAR(date_,'yyyy-mm-dd'),9,2));
END Split_Date___;


PROCEDURE Get_Increment___ (
   nyear_       OUT NUMBER,
   nmonth_      OUT NUMBER,
   nday_        OUT NUMBER,
   first_date_  IN  DATE,
   cur_date_    IN  DATE )
IS
   year_first_     NUMBER;
   month_first_    NUMBER;
   day_first_      NUMBER;
   year_cur_       NUMBER;
   month_cur_      NUMBER;
   day_cur_        NUMBER;
BEGIN
   Split_Date___(year_first_, month_first_, day_first_, first_date_);
   Split_Date___(year_cur_,   month_cur_,   day_cur_,   cur_date_);
   nyear_   := year_cur_ - year_first_;
   nmonth_  := month_cur_ - month_first_;
   IF (nmonth_ < 0) THEN
      nyear_   := nyear_ - 1;
      nmonth_  := 12-(month_first_) + month_cur_;
   END IF;
   -- note that this can lead to negative number of days
   nday_    := day_cur_ - day_first_;
END Get_Increment___;


PROCEDURE Calc_New_Date___ (
   new_date_   OUT DATE,
   ref_date_   IN  DATE,
   first_date_ IN  DATE,
   cur_date_   IN  DATE )
IS
   year_ref_     NUMBER;
   month_ref_    NUMBER;
   day_ref_      NUMBER;
   year_new_     NUMBER;
   month_new_    NUMBER;
   day_new_      NUMBER;
   year_cur_     NUMBER;
   month_cur_    NUMBER;
   day_cur_      NUMBER;
   nyear_        NUMBER;
   nmonth_       NUMBER;
   nday_         NUMBER;
   date_         DATE;
BEGIN
   IF (TRUNC(first_date_) = TRUNC(cur_date_)) THEN
      new_date_ := TRUNC(ref_date_);
   ELSE
   -- split reference date
      Split_Date___(year_ref_, month_ref_, day_ref_, ref_date_);
   -- get increment between first and current valid from date
      Get_Increment___(nyear_, nmonth_, nday_, first_date_, cur_date_);
   -- split current date
      Split_Date___(year_cur_, month_cur_, day_cur_, cur_date_);
      year_new_   := year_ref_ + nyear_;
      month_new_  := month_ref_ + nmonth_;
      IF (month_new_ > 12) THEN
         year_new_  := year_new_ + 1;
         month_new_ := month_new_ - 12;
      END IF;
      -- 1:st or last day as current date
      IF (day_cur_ = 1 OR TRUNC(cur_date_) = LAST_DAY(cur_date_)) THEN
         day_new_ := day_cur_;
         IF (day_cur_ <> 1) THEN
            Pack_Date___(date_, year_new_, month_new_, 1);
           Split_Date___(year_new_, month_new_, day_new_, LAST_DAY(date_));
         END IF;
         Pack_Date___(new_date_, year_new_, month_new_, day_new_);
      ELSE
         date_ :=  ADD_MONTHS(ref_date_, nyear_ * 12 + nmonth_);
         new_date_ := date_ + nday_;
      END IF;
   END IF;
END Calc_New_Date___;


FUNCTION Get_Next_From_Attr___ (
   attr_             IN     VARCHAR2,
   ptr_              IN OUT NUMBER,
   value_            IN OUT VARCHAR2,
   record_separator_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := INSTR(attr_, record_separator_, from_);
      value_ := SUBSTR(attr_, from_, index_-from_);
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr___;  


PROCEDURE Write_Close_Translate_File___ (
   file_stream_     IN OUT CLOB,
   file_buffer_     IN OUT VARCHAR2,
   begin_           IN OUT BOOLEAN,
   component_       IN     VARCHAR2,
   language_code_   IN     VARCHAR2 )
IS
BEGIN
   IF (begin_) THEN
      Write_Line___(file_stream_, file_buffer_, 'END;');
      Write_Line___(file_stream_, file_buffer_, '/');
      begin_ := FALSE;
   END IF;
   Write_Line___(file_stream_, file_buffer_, '-----------------------------------------------------------------------------');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'PROMPT Refreshing template '||ampersand_||'TEMPLATE_ID, module ' || component_ || ' and language ' || language_code_);
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'BEGIN');
   Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Refresh_Templ_Trans('''||ampersand_||'TEMPLATE_ID'',''' ||component_ || ''',''' || language_code_ || ''');');
   Write_Line___(file_stream_, file_buffer_, 'END;');
   Write_Line___(file_stream_, file_buffer_, '/');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'PROMPT Commit of transactions');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'COMMIT;');
END Write_Close_Translate_File___;


PROCEDURE Write_Translate_File_Head___ (
   file_name_           OUT    VARCHAR2,
   file_stream_         IN OUT CLOB,
   file_buffer_         IN OUT VARCHAR2,
   template_id_         IN     VARCHAR2,
   component_           IN     VARCHAR2,
   language_code_       IN     VARCHAR2,
   file_per_component_  IN     BOOLEAN DEFAULT TRUE )
IS
BEGIN
   IF (file_per_component_) THEN
      file_name_ := component_ || '_CompanyTemplate_' || template_id_ || '_' || language_code_ || template_file_extension_;
   ELSE
      file_name_ := 'CompanyTemplate_' || template_id_ || '_' || language_code_ || template_file_extension_;
   END IF;
   Write_Line___(file_stream_, file_buffer_, '-----------------------------------------------------------------------------');
   Write_Line___(file_stream_, file_buffer_, '-- Translation file for Company Templates');
   Write_Translate_Head___(file_stream_, file_buffer_, template_id_, component_, language_code_);     
END Write_Translate_File_Head___;   


PROCEDURE Write_Translate_Head___ (
   file_stream_     IN OUT CLOB,
   file_buffer_     IN OUT VARCHAR2,
   template_id_     IN     VARCHAR2,
   component_       IN     VARCHAR2,
   language_code_   IN     VARCHAR2 )
IS   
BEGIN   
   Write_Line___(file_stream_, file_buffer_, '-----------------------------------------------------------------------------');
   Write_Line___(file_stream_, file_buffer_, '-- Component: ' || component_);
   Write_Line___(file_stream_, file_buffer_, '-- Language: ' || language_code_);
   Write_Line___(file_stream_, file_buffer_, '-----------------------------------------------------------------------------');
   Write_Line___(file_stream_, file_buffer_, 'DEFINE TEMPLATE_ID = ' || template_id_);
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'PROMPT Initialization of template '||ampersand_||'TEMPLATE_ID, module ' || component_ || ' and language ' || language_code_);
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'BEGIN');
   Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Init_Templ_Trans('''||ampersand_||'TEMPLATE_ID'',''' || component_ || ''',''' || language_code_ || ''');');
   Write_Line___(file_stream_, file_buffer_, 'END;');
   Write_Line___(file_stream_, file_buffer_, '/');
   Write_Line___(file_stream_, file_buffer_, '-----------------------------------------------------------------------------');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'PROMPT Inserting translations for template '||ampersand_||'TEMPLATE_ID, module ' || component_ || ' and language ' || language_code_);
   Write_Line___(file_stream_, file_buffer_, '');   
END Write_Translate_Head___;  


PROCEDURE Write_Template_Translations___ (
   file_stream_     IN OUT CLOB,
   file_buffer_     IN OUT VARCHAR2,
   begin_           IN OUT BOOLEAN,
   template_id_     IN     VARCHAR2,
   component_       IN     VARCHAR2,
   language_code_   IN     VARCHAR2 )
IS
   max_line_length_        PLS_INTEGER := 2000;
   splitted_               BOOLEAN := FALSE;   
   n_inserts_              PLS_INTEGER := 0;
   parts_                  PLS_INTEGER;
   counter_                PLS_INTEGER;
   token_count_            PLS_INTEGER;
   current_trans_          VARCHAR2(4000);
   current_attribute_key_  VARCHAR2(2000);
   current_trans_lu_       VARCHAR2(30);
   text_parts_             Utility_SYS.STRING_TABLE;
   empty_text_parts_       Utility_SYS.STRING_TABLE;
   text_part_              VARCHAR2(2000);
   CURSOR get_translations IS
      SELECT lu, attribute_key, current_translation       
		FROM   templ_key_lu_translation_exp 
		WHERE  key_name = 'TemplKeyLu'
		AND    key_value = template_id_
		AND    module = component_
		AND    language_code = language_code_
		ORDER BY lu,attribute_key;    
BEGIN      
   -- Define max line length when writing to the file. The final length can sometime become larger due to line change handling
   -- As it seems SQL Plus (Oracle 10.2 client) can handle line lengths up to 2499      
   FOR rec_ IN get_translations LOOP
      splitted_ := FALSE;
      parts_ := 1;
      counter_ := 1;            
      -- set current attribute key
      current_attribute_key_ := rec_.attribute_key;
      -- set current translation lu
      current_trans_lu_ := rec_.lu;
      -- Swap dangerous characters for non-printables. Replace combination of Chr(13) || Chr(10) with constant representing the two characters     
      current_trans_ := REPLACE(rec_.current_translation, CHR(13)||CHR(10), '''CHR(13)||CHR(10)||''');            
      -- Split text into multiple lines if needed      
      IF (LENGTH(current_trans_) > max_line_length_) THEN
         -- reset variable
         text_parts_ := empty_text_parts_;
         token_count_ := 0;
         WHILE (LENGTH(current_trans_) > max_line_length_) LOOP
            text_part_ := SUBSTR(current_trans_, 1, 2000);
            token_count_ := token_count_ + 1;
            text_parts_(token_count_) := text_part_;
            current_trans_ := SUBSTR(current_trans_, 2001);
         END LOOP;                       
         token_count_ := token_count_ + 1;
         text_parts_(token_count_) := current_trans_;         
         -- Concatenate the parts
         WHILE (counter_ < token_count_) LOOP
            IF (counter_ = 0) THEN
               current_trans_ := text_parts_(counter_);
            ELSE
               current_trans_ := current_trans_ || '''CHR(13)||CHR(10)''' || text_parts_(counter_);               
            END IF;
            counter_ := counter_ + 1;
         END LOOP;
      END IF;
      --Replace special characters      
      current_trans_ := REPLACE(current_trans_, '^', '~');
      current_attribute_key_ := REPLACE(current_trans_, '^', '~');
      IF ( LENGTH('   Enterp_Comp_Connect_V170_API.Insert_Translation_Exp('''||ampersand_||'TEMPLATE_ID^' || component_ || '^' || current_trans_lu_ || '^' || current_attribute_key_ || '^' || language_code_ || '^' || current_trans_ || ''');') > max_line_length_) THEN
         splitted_ := TRUE;
      END IF;
      -- Complete statement      
      IF (NOT (begin_)) THEN
         Write_Line___(file_stream_, file_buffer_, 'BEGIN');
         begin_ := TRUE;         
      END IF;
      IF (splitted_) THEN
         Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Insert_Translation_Exp('''||ampersand_||'TEMPLATE_ID^' || component_ || '^' || current_trans_lu_ || '^' || current_attribute_key_ || '^' || language_code_ || '^''');
         Write_Line___(file_stream_, file_buffer_, '   ''' || current_trans_ || ''');');
      ELSE
         Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Insert_Translation_Exp('''||ampersand_||'TEMPLATE_ID^' || component_ || '^' || current_trans_lu_ || '^' || current_attribute_key_ || '^' || language_code_ || '^' || current_trans_ ||''');');
      END IF;
      n_inserts_ := n_inserts_ + 1;
      IF (n_inserts_ > 500) THEN
         Write_Line___(file_stream_, file_buffer_, 'END');
         Write_Line___(file_stream_, file_buffer_, '/');
         begin_ := FALSE;
         n_inserts_ := 0;
      END IF;      
   END LOOP;
END Write_Template_Translations___;


PROCEDURE Write_Template_File_Head___ (
   file_stream_   IN OUT CLOB,
   file_buffer_   IN OUT VARCHAR2,
   templ_rec_     IN     create_company_tem_tab%ROWTYPE,
   comp_rec_      IN     create_company_tem_comp_tab%ROWTYPE,
   create_header_ IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN   
   Write_Line___(file_stream_, file_buffer_, '--<<START>>');
   Write_Line___(file_stream_, file_buffer_, 'BEGIN');
   Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Initiate_Template_Log;');
   Write_Line___(file_stream_, file_buffer_, 'END;');
   Write_Line___(file_stream_, file_buffer_, '/');
   Write_Line___(file_stream_, file_buffer_, 'DEFINE TEMPLATE_ID = ' || templ_rec_.template_id);
   IF (create_header_) THEN
      Write_Template_Head___(file_stream_, file_buffer_, templ_rec_, comp_rec_);
   END IF;   
END Write_Template_File_Head___;   
   

PROCEDURE Write_Template_Head___ (
   file_stream_   IN OUT CLOB,
   file_buffer_   IN OUT VARCHAR2,
   templ_rec_     IN     create_company_tem_tab%ROWTYPE,
   comp_rec_      IN     create_company_tem_comp_tab%ROWTYPE )
IS
BEGIN   
   Write_Line___(file_stream_, file_buffer_, 'DEFINE COMPONENT = ' || comp_rec_.component);
   Write_Line___(file_stream_, file_buffer_, 'DEFINE VERSION = ' || comp_rec_.version);
   Write_Line___(file_stream_, file_buffer_, 'DECLARE');
   Write_Line___(file_stream_, file_buffer_, '   headrec_ Enterp_Comp_Connect_V190_API.Tem_Public_Rec;');
   Write_Line___(file_stream_, file_buffer_, 'BEGIN');
   Write_Line___(file_stream_, file_buffer_, '   headrec_.TEMPLATE_ID := '''||ampersand_||'TEMPLATE_ID''; headrec_.DESCRIPTION := ''' || templ_rec_.description ||''';');
   Write_Line___(file_stream_, file_buffer_, '   headrec_.VALID := ' || '''TRUE''' ||'; ');
   Write_Line___(file_stream_, file_buffer_, '   headrec_.COMPONENT := ''' || comp_rec_.component || '''; headrec_.VERSION := ''' || comp_rec_.version || '''; ');
   Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V190_API.Tem_Insert_Data_Exp(headrec_);');
   Write_Line___(file_stream_, file_buffer_, 'END;');
   Write_Line___(file_stream_, file_buffer_, '/');   
END Write_Template_Head___;


PROCEDURE Tokenize___ (
   output_table_   OUT Utility_SYS.STRING_TABLE,
   token_count_    OUT NUMBER,
   string_         IN  VARCHAR2,
   delimiter_      IN  VARCHAR2 )
IS
   last_pos_         NUMBER;
   delimiter_count_  NUMBER;
   pos_              NUMBER;
   token_            VARCHAR2(32000);
   temp_string_      VARCHAR2(32000);
   delimiter_pos_    Utility_SYS.NUMBER_TABLE;
BEGIN
   IF (string_ IS NULL) THEN
      token_count_   := 0;
      RETURN;
   END IF;     
   token_count_      := 1;
   last_pos_         := 1;
   delimiter_count_  := 0;
   temp_string_ := string_ || delimiter_;
   LOOP
      pos_ := INSTR(temp_string_, delimiter_, 1, delimiter_count_ + 1);
      IF NOT (pos_ = 0) THEN
         delimiter_count_ := delimiter_count_ + 1;
         delimiter_pos_(delimiter_count_) := pos_;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   token_count_ := 0;
   FOR counter_ IN 1..delimiter_count_ LOOP
      token_ := SUBSTR(temp_string_, last_pos_, delimiter_pos_(counter_) - last_pos_);
      last_pos_ := delimiter_pos_ ( counter_ ) + LENGTH(delimiter_);
      token_count_ := token_count_ + 1;
      output_table_ ( token_count_ ) := token_;      
   END LOOP;
END Tokenize___;


PROCEDURE Write_Template_Values___ (
   file_stream_    IN OUT CLOB,
   file_buffer_    IN OUT VARCHAR2,
   templ_rec_      IN     create_company_tem_tab%ROWTYPE,
   comp_rec_       IN     create_company_tem_comp_tab%ROWTYPE,
   lu_             IN     VARCHAR2 )
IS   
   lu_found_               BOOLEAN := FALSE;
   item_id_                NUMBER := 0;   
   col_table_              Utility_SYS.STRING_TABLE;
   col_value_table_        Utility_SYS.STRING_TABLE;
   col_count_              PLS_INTEGER := 0;
   col_value_count_        PLS_INTEGER := 0;   
   current_col_            VARCHAR2(2000);
   current_col_value_      VARCHAR2(2000);
   value_str_length_       NUMBER := 0;
   col_str_length_         NUMBER := 0;
   max_line_length_        CONSTANT NUMBER := 256;
   max_attribute_length_   CONSTANT NUMBER := 2000;
   file_string_            VARCHAR2(4000);
   large_line_cnt_         NUMBER := 0;   
   str_char_cnt_           NUMBER := 0;
   current_str_length_     NUMBER := 0;
   first_large_line_       BOOLEAN := TRUE;
   large_line_text_        VARCHAR2(32000);
   start_next_line_str_    VARCHAR2(1);
   start_next_line_strlen_ NUMBER := 0;
   temp_substring_         VARCHAR2(32000);
   next_quotation_pos_     NUMBER := 0;   
   large_line_text_temp_   VARCHAR2(32000);   
   temp_str_length_        NUMBER := 0;
   temp_str_unquoted_      VARCHAR2(4000) := NULL;
   temp_current_col_value_ VARCHAR2(4000) := NULL;
   temp_char_              VARCHAR2(4000) := NULL;   
   temp_counter_           NUMBER := 1;
   single_quotation_char_  CONSTANT VARCHAR2(1):= CHR(39);   
   temp_pos1_              NUMBER := -1;
   temp_pos2_              NUMBER := -1;
   temp_pos3_              NUMBER := -1;   
   block_cnt_              PLS_INTEGER := 0;
   CURSOR get_column_value IS
      SELECT column_list, column_values 
      FROM   export_company_template
      WHERE  template_id =  templ_rec_.template_id
      AND    component = comp_rec_.component
      AND    lu =  lu_
      ORDER BY item_id;
   FUNCTION Empty_String___ (
      test_string_      IN VARCHAR2,
      in_str_length_    IN NUMBER) RETURN BOOLEAN
   IS
      ret_           BOOLEAN := FALSE;      
      str1_          VARCHAR2(1);
      str2_          VARCHAR2(1);
   BEGIN       
      IF (in_str_length_ = 2) THEN
         str1_ := SUBSTR(test_string_, 1, 1);
         str2_ := SUBSTR(test_string_, 2, 1);
         IF (str1_ = single_quotation_char_ AND str2_ = single_quotation_char_) THEN
            ret_ := TRUE;
         END IF;         
      END IF;
      RETURN ret_;
   END Empty_String___;
BEGIN   
   lu_found_ := FALSE;
   item_id_ := 0;
   block_cnt_ := 0;   
   FOR rec_ IN get_column_value LOOP
      lu_found_ := TRUE;      
      -- Following commented code is to create larger pl-blocks with 100 records in the block
      /*
      block_cnt_ := block_cnt_ + 1;      
      IF block_cnt_ = 1 THEN
         Write_Line___(file_stream_, file_buffer_, 'DECLARE');
         Write_Line___(file_stream_, file_buffer_, '   rec_ Enterp_Comp_Connect_V190_API.Tem_Public_Rec;');
         Write_Line___(file_stream_, file_buffer_, 'BEGIN');               
      END IF;
      Write_Line___(file_stream_, file_buffer_, '   rec_.TEMPLATE_ID := '''||ampersand_||'TEMPLATE_ID''; rec_.COMPONENT := '''||ampersand_||'COMPONENT''; rec_.VERSION := '''||ampersand_||'VERSION''; rec_.LU := '''||lu_||'''; rec_.ITEM_ID := ' || To_Char(item_id_ + 1) ||';');                  
      */
      Write_Line___(file_stream_, file_buffer_, 'DECLARE');
      Write_Line___(file_stream_, file_buffer_, '   rec_ Enterp_Comp_Connect_V190_API.Tem_Public_Rec;');
      Write_Line___(file_stream_, file_buffer_, 'BEGIN');      
      Write_Line___(file_stream_, file_buffer_, '   rec_.TEMPLATE_ID := '''||ampersand_||'TEMPLATE_ID''; rec_.COMPONENT := '''||ampersand_||'COMPONENT''; rec_.VERSION := '''||ampersand_||'VERSION''; rec_.LU := '''||lu_||'''; rec_.ITEM_ID := ' || To_Char(item_id_ + 1) ||';');
      Tokenize___(col_table_, col_count_, rec_.column_list, ',');
      Tokenize___(col_value_table_, col_value_count_, rec_.column_values, CHR(30));      
      FOR i_ IN 1..col_count_ LOOP
         current_col_ := col_table_(i_);
         current_col_value_ := col_value_table_(i_);         
         current_col_value_ := REPLACE(current_col_value_, CHR(13)||CHR(10), '''||CHR(13)||CHR(10)||''');                  
         -- code to ensure that the generated file does not get any strings that are not quoted and gives installation errors
         IF ((INSTR(current_col_value_, single_quotation_char_) = 1) AND (INSTR(SUBSTR(current_col_value_, -1, 1), single_quotation_char_) > 0) AND INSTR(current_col_value_, 'CHR(39)') = 0 AND INSTR(current_col_value_, single_quotation_char_||'||') = 0) THEN
            temp_str_length_ := 0;            
            temp_str_unquoted_ := NULL;            
            temp_current_col_value_ := NULL;
            temp_char_ := NULL;
            temp_char_ := NULL;
            temp_str_length_ := LENGTH(current_col_value_);
            -- Substr to start after the first character, which is (').
            temp_str_unquoted_ := SUBSTR(current_col_value_, 2, temp_str_length_ - 2);
            IF (temp_str_length_ != 0 AND temp_str_unquoted_ IS NOT NULL) THEN
               temp_counter_ := 1;  
               temp_pos1_ := -1;
               temp_pos2_ := -1;
               temp_pos3_ := -1;
               WHILE (temp_counter_ < temp_str_length_ - 1) LOOP 
                  -- Scan whether current char is a single quotation mark
                  temp_pos1_ := INSTR(SUBSTR(temp_str_unquoted_, temp_counter_, 1), single_quotation_char_);
                  -- Scan whether next char is a single quotation mark
                  temp_pos2_ := INSTR(SUBSTR(temp_str_unquoted_, temp_counter_+1, 1), single_quotation_char_);
                  -- Scan whether previous char is a single quotation mark
                  temp_pos3_ := INSTR(SUBSTR(temp_str_unquoted_, temp_counter_-1, 1), single_quotation_char_);
                  -- Extract charcter by character
                  temp_char_ := SUBSTR(temp_str_unquoted_, temp_counter_, 1);
                  -- Quotation is replaced by CHR(39) whose next and previous characters must not be a quotation
                  IF (temp_pos1_ != 0 AND temp_pos2_ = 0 AND temp_pos3_ = 0) THEN
                     temp_current_col_value_ := temp_current_col_value_ || single_quotation_char_ || '||CHR(39)||' || single_quotation_char_;
                  ELSE
                     temp_current_col_value_ := temp_current_col_value_ || temp_char_;
                  END IF;
                  temp_counter_ := temp_counter_ + 1;
               END LOOP;               
               current_col_value_ := single_quotation_char_ || temp_current_col_value_ || single_quotation_char_;
            END IF;
         END IF;
         -- Replace special character CHR(38) with function that will give the same character when installing
         current_col_value_ := REPLACE(current_col_value_, ampersand_, '''||CHR(38)||''');
         IF (current_col_value_ IS NOT NULL) THEN
            value_str_length_ := LENGTH(current_col_value_);
            col_str_length_ := LENGTH(current_col_);
            IF (NOT Empty_String___(current_col_value_, value_str_length_)) THEN            
               IF ((col_str_length_ + value_str_length_) > max_attribute_length_) THEN
                  IF (file_string_ IS NOT NULL) THEN
                     Write_Line___(file_stream_, file_buffer_, '   ' || file_string_);
                     file_string_ := NULL;
                  END IF;
                  large_line_cnt_ := 1;
                  str_char_cnt_ := 0;
                  current_str_length_ := 0;
                  first_large_line_ := TRUE;
                  large_line_text_ := NULL;
                  start_next_line_str_ := NULL;                  
                  WHILE (large_line_cnt_ < value_str_length_) LOOP 
                     large_line_text_temp_ := SUBSTR(current_col_value_, large_line_cnt_, 1);
                     IF (large_line_text_temp_ = single_quotation_char_) THEN
                        str_char_cnt_ := str_char_cnt_ + 1;
                     END IF;
                     large_line_text_ := large_line_text_ || large_line_text_temp_;
                     large_line_cnt_ := large_line_cnt_ + 1;
                     current_str_length_ := current_str_length_ + 1;
                     IF (current_str_length_ = max_attribute_length_) THEN
                        -- If it is not an even set of (') characters then add one followed by to pipes and set that first line should start with a (') character
                        IF (MOD(str_char_cnt_, 2) != 0) THEN
                           large_line_text_ := large_line_text_ || single_quotation_char_ || '||'; 
                           start_next_line_str_ := single_quotation_char_;
                           start_next_line_strlen_ := 1;
                        ELSE
                           -- In the middle of a non string, to simplify the code a bit find next (') character and handle the it like the above if statement
                           temp_substring_ := SUBSTR(current_col_value_, large_line_cnt_, value_str_length_ - large_line_cnt_);
                           next_quotation_pos_ := INSTR(temp_substring_, single_quotation_char_);
                           -- Check that there is a (') character in the rest of the string. If not then just add what is left
                           IF (next_quotation_pos_ > 0) THEN
                              temp_substring_ := SUBSTR(current_col_value_, large_line_cnt_, next_quotation_pos_ + 1);
                              large_line_cnt_ := large_line_cnt_ + next_quotation_pos_ + 1;
                              large_line_text_ := large_line_text_ || temp_substring_ || single_quotation_char_ || '||';
                              start_next_line_str_ := single_quotation_char_;
                              start_next_line_strlen_ := 1;
                           ELSE
                              large_line_cnt_ := large_line_cnt_ + Length(temp_substring_);
                              large_line_text_ := large_line_text_ || temp_substring_;
                              start_next_line_str_ := NULL;
                              start_next_line_strlen_ := 0;
                           END IF;
                        END IF;
                        -- If it is the first new line out of the large line then add the record variable e.g rec_.C1, rec_.N2 etc.
                        IF (first_large_line_) THEN
                           file_string_ := ' rec_.' || current_col_ || ' := ' || large_line_text_;
                           first_large_line_ := FALSE;                        
                        ELSE
                           file_string_ := ' ' || large_line_text_;
                        END IF;
                        -- If the line end when nCurrentStrLength = nMaxAttributeLength then we need to add ';" when writing the line
                        IF (large_line_cnt_ = (value_str_length_ + 1)) THEN                        
                           file_string_ := file_string_ || ';';
                        END IF;      
                        Write_Line___(file_stream_, file_buffer_, '  ' || file_string_);
                        file_string_ := NULL;
                        large_line_text_ := NULL;
                        str_char_cnt_ := 0;
                        IF (start_next_line_str_ IS NOT NULL)  THEN                        
                           large_line_text_ := start_next_line_str_;
                           str_char_cnt_ := start_next_line_strlen_;
                           start_next_line_str_ := NULL;
                        END IF;
                        current_str_length_ := 0;                        
                     END IF;                                                               
                  END LOOP;
                  -- If anything left, then write to file
                  IF (large_line_text_ IS NOT NULL) THEN                  
                     file_string_ := ' ' || large_line_text_ || ';';
                     Write_Line___(file_stream_, file_buffer_, '  ' || file_string_);
                     file_string_ := NULL;
                     large_line_text_ := NULL;                              
                  END IF;
               ELSE                  
                  IF ((Length(file_string_) + col_str_length_ + value_str_length_) > max_line_length_) THEN                  
                     Write_Line___(file_stream_, file_buffer_, '  ' || file_string_);
                     file_string_ := NULL;
                     IF (current_col_value_ IS NULL AND (INSTR(current_col_, 'N') > 0) ) THEN                     
                        file_string_ := file_string_ || ' rec_.' || current_col_ || ' := ' || 'NULL' || ';';                     
                     ELSE                      
                        file_string_ := file_string_ || ' rec_.' || current_col_ || ' := ' || current_col_value_ || ';';
                     END IF;                  
                  ELSE                  
                     IF (current_col_value_ IS NULL AND (Instr(current_col_, 'N') > 0)) THEN                     
                        file_string_ := file_string_ || ' rec_.' || current_col_ || ' := ' || 'NULL' || ';';                     
                     ELSE                      
                        file_string_ := file_string_ || ' rec_.' || current_col_ || ' := ' || current_col_value_ || ';';
                     END IF;
                  END IF;                                                                                       
               END IF;           
            END IF;
         END IF;          
      END LOOP;
      IF (file_string_ IS NOT NULL) THEN
         Write_Line___(file_stream_, file_buffer_, '  ' || file_string_);         
      END IF;      
      file_string_ := NULL;      
      -- Following commented code is to create larger pl-blocks with 100 records in the block
      /*
      IF block_cnt_ = 100 THEN
         Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V190_API.Tem_Insert_Detail_Data_Exp(rec_);');         
         Write_Line___(file_stream_, file_buffer_, 'END;');         
         Write_Line___(file_stream_, file_buffer_, '/');                  
         block_cnt_ := 0;
      ELSE         
         Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V190_API.Tem_Insert_Detail_Data_Exp(rec_);');         
         Write_Line___(file_stream_, file_buffer_, '   rec_ := NULL;');
         Write_Line___(file_stream_, file_buffer_, '');
      END IF;
      */
      Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V190_API.Tem_Insert_Detail_Data_Exp(rec_);');         
      Write_Line___(file_stream_, file_buffer_, 'END;');         
      Write_Line___(file_stream_, file_buffer_, '/');         
      item_id_ := item_id_ + 1;
   END LOOP;      
   -- Following commented code is to create larger pl-blocks with 100 records in the block
   /*
   IF block_cnt_ <= 100 THEN
      Write_Line___(file_stream_, file_buffer_, 'END;');         
      Write_Line___(file_stream_, file_buffer_, '/');               
   END IF;
   */
   IF (NOT lu_found_) THEN
      Write_Line___(file_stream_, file_buffer_, 'DECLARE');
      Write_Line___(file_stream_, file_buffer_, '   rec_ Enterp_Comp_Connect_V190_API.Tem_Public_Rec;');
      Write_Line___(file_stream_, file_buffer_, 'BEGIN');
      Write_Line___(file_stream_, file_buffer_, '   rec_.TEMPLATE_ID := '''||ampersand_||'TEMPLATE_ID''; rec_.COMPONENT := '''||ampersand_||'COMPONENT''; rec_.VERSION := '''||ampersand_||'VERSION''; rec_.LU := '''||lu_||'''; ');
      Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V190_API.Tem_Insert_Detail_Data_Exp(rec_);');
      Write_Line___(file_stream_, file_buffer_, 'END;');
      Write_Line___(file_stream_, file_buffer_, '/');      
   END IF;   
END Write_Template_Values___;


PROCEDURE Write_Template_Close___ (
   file_stream_   IN OUT CLOB,
   file_buffer_   IN OUT VARCHAR2 )
IS
BEGIN   
   Write_Line___(file_stream_, file_buffer_, 'BEGIN');
   Write_Line___(file_stream_, file_buffer_, '   Enterp_Comp_Connect_V170_API.Reset_Template_Log;');
   Write_Line___(file_stream_, file_buffer_, 'END;');
   Write_Line___(file_stream_, file_buffer_, '/');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'COMMIT;');
   Write_Line___(file_stream_, file_buffer_, '');
   Write_Line___(file_stream_, file_buffer_, 'UNDEFINE COMPONENT');
   Write_Line___(file_stream_, file_buffer_, 'UNDEFINE VERSION');
   Write_Line___(file_stream_, file_buffer_, '--<<END>>');   
END Write_Template_Close___;     


PROCEDURE Write_Line___ (
   file_stream_   IN OUT CLOB,
   file_buffer_   IN OUT VARCHAR2,
   string_        IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Enterp_Lob_Writer_API.Write_Line_String(file_stream_, file_buffer_, string_);   
END Write_Line___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_New_Company__ (
   error_         OUT VARCHAR2,
   company_       IN  VARCHAR2,
   component_     IN  VARCHAR2,
   package_       IN  VARCHAR2,
   attr_          IN  VARCHAR2,
   languages_     IN  VARCHAR2 DEFAULT NULL )
IS
   ptr_                    NUMBER;
   msg_                    VARCHAR2(2000);
   active_                 VARCHAR2(5);
   pkg_tab_                Crecomp_Component_API.PackageTab;
   active_list_            Crecomp_Component_API.ActiveTab;
   lu_list_                Crecomp_Component_API.LuTab;
   lu_                     VARCHAR2(30);
   i_                      NUMBER;
   pkg_                    VARCHAR2(100);
   use_make_comp_          VARCHAR2(5);
   valid_                  VARCHAR2(5);
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   crecomp_rec_            Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec;
   update_from_template_   VARCHAR2(30);
   fnd_user_               VARCHAR2(30);
   key_master_created_     BOOLEAN := FALSE;
   copy_company_           BOOLEAN := FALSE;
   lang_codes_             VARCHAR2(200);
   field_separator_        VARCHAR2(1) := Client_SYS.field_separator_;
   text_separator_         VARCHAR2(1) := Client_SYS.text_separator_;
   value2_                 VARCHAR2(2000);
   ptr2_                   NUMBER;
   special_lu_             BOOLEAN;
   dummy_                  NUMBER;
   from_update_trans_      BOOLEAN := FALSE;
   from_update_company_    BOOLEAN := FALSE;
   from_create_company_    BOOLEAN := FALSE;
   from_window_            VARCHAR2(30);
   update_by_key_          BOOLEAN := FALSE;
   update_id_              VARCHAR2(30);
   make_comp_attr_         VARCHAR2(2000); -- attribute passed to all make_company methods.
   CURSOR get_special_lu IS
      SELECT 1
      FROM   crecomp_special_lu_tab
      WHERE  lu = lu_
      AND    TYPE = 'TRANSLATION';
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'NEW_COMPANY') THEN
         crecomp_rec_.company := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'VALID_FROM') THEN
         crecomp_rec_.valid_from := Client_SYS.Attr_Value_To_Date(value_);
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'TEMPLATE_ID') THEN
         crecomp_rec_.template_id := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'DUPL_COMPANY') THEN
         crecomp_rec_.old_company := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'ACTION') THEN
         crecomp_rec_.action := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'MAKE_COMPANY') THEN
         crecomp_rec_.make_company := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'UPDATE_ACC_REL_DATA') THEN
         crecomp_rec_.update_acc_rel_data := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'UPDATE_NON_ACC_DATA') THEN
         crecomp_rec_.update_non_acc_data := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'UPDATE_FROM_TEMPLATE') THEN
         update_from_template_ := value_;
      ELSIF (name_ = 'FROM_WINDOW') THEN
         -- to know from which client the call was made.
         from_window_ := value_;
      ELSIF (name_ = 'UPDATE_ID') THEN
         update_id_ := value_;
      ELSIF (name_ = 'USER_DEFINED') THEN
         crecomp_rec_.user_defined := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'START_YEAR') THEN
         crecomp_rec_.cal_start_year := Client_SYS.Attr_Value_To_Number(value_);
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'START_MONTH') THEN
         crecomp_rec_.cal_start_month := Client_SYS.Attr_Value_To_Number(value_);
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'NUMBER_OF_YEARS') THEN
         crecomp_rec_.number_of_years := Client_SYS.Attr_Value_To_Number(value_);
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'ACC_YEAR') THEN
         crecomp_rec_.acc_year := Client_SYS.Attr_Value_To_Number(value_);
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      -- added missing creation parameters set in the create company wizard
      ELSIF (name_ = 'CURRENCY_CODE') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'PARALLEL_ACC_CURRENCY') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'PAR_ACC_CURR_VALID_FROM') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'USE_VOU_NO_PERIOD') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'NAME') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'DEFAULT_LANGUAGE_DB') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'COUNTRY_DB') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'TEMPLATE_COMPANY') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'LANGUAGES') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'MAIN_PROCESS') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'PARALLEL_CURR_BASE') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'MASTER_COMPANY_DB') THEN
         crecomp_rec_.master_company := value_;
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);
      ELSIF (name_ = 'CURR_BAL_CODE_PART') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);         
      ELSIF (name_ = 'CURR_BAL_CODE_PART_DESC') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);         
      ELSIF (name_ = 'LOGICAL_ACC_TYPES') THEN
         Client_SYS.Add_To_Attr(name_, value_, make_comp_attr_);         
      END IF;
   END LOOP;
   IF (from_window_ = 'UPDATE_TRANSLATION') THEN
      from_update_trans_ := TRUE;
   ELSIF (from_window_ = 'UPDATE_COMPANY') THEN
      from_update_company_ := TRUE;
   ELSIF (from_window_ = 'CREATE_COMPANY') THEN
      from_create_company_ := TRUE;
   ELSE
      -- default
      from_create_company_ := TRUE;
   END IF;
   IF (from_update_company_ OR from_update_trans_) THEN
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      -- If Accrul exist and company exists in CompanyFinance then perform check 
      -- that the user is allowed to the company
      -- In reality all installations that creates companies has Accrul installed.
      $IF Component_Accrul_SYS.INSTALLED $THEN
         IF (Company_Finance_API.Check_Exist(crecomp_rec_.company)) THEN
            User_Finance_API.Exist(crecomp_rec_.company, fnd_user_);
         END IF;
      $ELSE
         NULL;
      $END   
   END IF;
   IF (update_from_template_ IS NOT NULL) THEN
      crecomp_rec_.template_id := update_from_template_;
      Create_Company_Tem_API.Exist(crecomp_rec_.template_id);
      Client_SYS.Set_Item_Value('TEMPLATE_ID', crecomp_rec_.template_id, make_comp_attr_);
      crecomp_rec_.action := 'NEW';
      Client_SYS.Set_Item_Value('ACTION', crecomp_rec_.action, make_comp_attr_);
   END IF;
   active_ := Crecomp_Component_API.Get_Active(component_);
   IF (crecomp_rec_.action = 'NEW') THEN
      IF (crecomp_rec_.template_id IS NOT NULL) THEN
         valid_ := Create_Company_Tem_API.Get_Valid(crecomp_rec_.template_id);
         IF (valid_ = 'FALSE') THEN
            Error_SYS.Appl_General(lu_name_, 'TEMPLATENOTVALID: Template Id is not valid');
         END IF;
      END IF;
   END IF;
   IF (crecomp_rec_.action = 'DUPLICATE') THEN
      copy_company_ := TRUE;
   END IF;
   -- If component is not active then do not do anything for the component.
   IF ((active_ = 'TRUE') AND Database_SYS.Component_Active(component_)) THEN
      use_make_comp_ := Crecomp_Component_API.Get_Use_Make_Company(component_);
      IF (NOT key_master_created_) THEN
         Enterp_Comp_Connect_V170_API.Insert_Key_Master__('CompanyKeyLu', company_);
         key_master_created_ := TRUE;
      END IF;
      IF (use_make_comp_ = 'TRUE') THEN
         Crecomp_Component_API.Get_Comp_Detail_List_Lu__(active_list_, pkg_tab_, lu_list_, i_, component_, update_id_);
         WHILE Get_Next_From_Attr___(languages_, ptr2_, value2_, field_separator_) LOOP
            lang_codes_ := lang_codes_ || value2_ || text_separator_;
         END LOOP;
         -- The TRANSLATION attribute should be replaced by MAIN_PROCESS in the future.
         -- It defines what process is performed.
         -- TRANSLATION is currently (2010-10-27) used in CreditAnalystUser.apy
         -- TransferTemplate.apy and TransferTemplateDetail.apy
         IF (from_update_company_) THEN
            Create_Company_Log_API.Initiate_Update_Company_Log__(company_, component_);
            Client_SYS.Add_To_Attr('TRANSLATION', 'UPDATE COMPANY', make_comp_attr_);
         ELSIF (from_update_trans_ ) THEN
            --disable log
            Create_Company_Log_API.Disable_Log(1);
            Client_SYS.Add_To_Attr('TRANSLATION', 'UPDATE TRANSLATION', make_comp_attr_);
         ELSE
            Client_SYS.Add_To_Attr('TRANSLATION', 'CREATE COMPANY', make_comp_attr_);
         END IF;
         IF (Client_SYS.Get_Item_Value('MAIN_PROCESS', make_comp_attr_) IS NULL) THEN
            Client_SYS.Add_To_Attr('MAIN_PROCESS', Client_SYS.Get_Item_Value('TRANSLATION', make_comp_attr_), make_comp_attr_);
         END IF;
         IF (NOT from_update_company_) THEN
            IF (NOT Client_SYS.Item_Exist('LANGUAGES', make_comp_attr_) ) THEN
               Client_SYS.Set_Item_Value('LANGUAGES', lang_codes_, make_comp_attr_);
            END IF;
         END IF;
         FOR t_ IN 1..i_ LOOP
            IF (active_list_(t_) = 'TRUE') THEN
               pkg_ := pkg_tab_(t_);
               lu_ := lu_list_(t_);
               IF (NOT from_update_trans_) THEN
                  Create_Company_Log_API.Logging(company_, component_, pkg_tab_(t_), 'CreateStarted');
               END IF;
               -- Dynamic call to each <package>.Make_Company method.
               BEGIN
                  -- check if LU need special handling
                  OPEN get_special_lu;
                  FETCH get_special_lu INTO dummy_;
                  IF (get_special_lu%FOUND) THEN
                     special_lu_ := TRUE;
                  ELSE
                     special_lu_ := FALSE;
                  END IF;
                  CLOSE get_special_lu;
                  IF (NOT from_update_trans_) THEN
                     IF (crecomp_rec_.action = 'NEW') THEN
                        App_Context_SYS.Set_Value('CreateCompany_Valid_From', crecomp_rec_.valid_from);
                     END IF;
                     Call_Company___(pkg_, 'MAKE_COMPANY', make_comp_attr_);
                  ELSIF (from_update_trans_ AND special_lu_) THEN
                     Call_Company___(pkg_, 'MAKE_COMPANY', make_comp_attr_);
                  END IF;
                  IF NOT (special_lu_) THEN
                     IF (from_update_company_) THEN
                        -- check if update by keys should be used.
                        IF (Enterp_Comp_Connect_V170_API.Use_Keys(component_, lu_, crecomp_rec_) OR NOT Enterp_Comp_Connect_V170_API.Check_Exist_Company_Lu_Trans(company_, component_, lu_)) THEN
                           update_by_key_ := TRUE;
                        ELSE
                           update_by_key_ := FALSE;
                        END IF;
                     END IF;
                     IF (copy_company_) THEN
                        IF (from_update_trans_) THEN
                           Enterp_Comp_Connect_V170_API.Copy_Comp_To_Comp_Trans(crecomp_rec_.old_company,
                                                                                company_,
                                                                                component_,
                                                                                lu_,
                                                                                lu_,
                                                                                NULL,
                                                                                NULL,
                                                                                lang_codes_,
                                                                                'UPDATE TRANSLATION');
                        ELSIF (from_create_company_ OR (update_by_key_ AND from_update_company_)) THEN
                           IF (from_update_company_) THEN
                              lang_codes_ := NULL;
                           END IF;
                           Enterp_Comp_Connect_V170_API.Copy_Comp_To_Comp_Trans(crecomp_rec_.old_company,
                                                                                company_,
                                                                                component_,
                                                                                lu_,
                                                                                lu_,
                                                                                NULL,
                                                                                NULL,
                                                                                lang_codes_);                                                                                
                        ELSE
                           NULL;
                        END IF;
                     ELSE
                        IF (from_update_trans_) THEN
                           Enterp_Comp_Connect_V170_API.Copy_Templ_To_Comp_Trans(crecomp_rec_.template_id,
                                                                                 company_,
                                                                                 component_,
                                                                                 lu_,
                                                                                 lu_,
                                                                                 NULL,
                                                                                 NULL,
                                                                                 lang_codes_,
                                                                                 'UPDATE TRANSLATION');
                        ELSIF (from_create_company_ OR (update_by_key_ AND from_update_company_)) THEN
                           IF (from_update_company_) THEN
                              lang_codes_ := NULL;
                           END IF;
                           Enterp_Comp_Connect_V170_API.Copy_Templ_To_Comp_Trans(crecomp_rec_.template_id,
                                                                                 company_,
                                                                                 component_,
                                                                                 lu_,
                                                                                 lu_,
                                                                                 NULL,
                                                                                 NULL,
                                                                                 lang_codes_);                                                                                 
                        ELSE
                           NULL;
                        END IF;
                     END IF;
                  END IF;
               EXCEPTION
                    WHEN OTHERS THEN
                       msg_ := SQLERRM;
                       Create_Company_Log_API.Logging(company_, component_, pkg_, 'Error', msg_);
                       Create_Company_Log_API.Logging(company_, component_, pkg_, 'CreatedWithErrors');
               END;
            ELSE
               NULL;
            END IF;
         END LOOP;
         IF (from_update_company_ OR from_update_trans_) THEN
            Create_Company_Log_API.Reset_Log__;
         END IF;
      END IF;
   ELSE
      NULL;
   END IF;
   IF (NOT from_update_trans_) THEN
      error_ := Create_Company_Log_API.Exist_Error(company_);
   END IF;
END Create_New_Company__;


PROCEDURE New_Company__ (
   attr_    IN OUT VARCHAR2 )
IS
   company_          company.company%TYPE;
   pkg_tab_          Crecomp_Component_API.PackageTab;
   component_tab_    Crecomp_Component_API.ComponentTab;
   active_list_      Crecomp_Component_API.ActiveTab;
   n_                NUMBER := 0;
   exec_plan_        VARCHAR2(10);
   ptr_              NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(200);
   tempnum_          NUMBER;
   i_                NUMBER;
   update_id_        VARCHAR2(30);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'NEW_COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'PROCESS') THEN
         exec_plan_ := value_;
      ELSIF (name_ = 'UPDATE_ID') THEN
         update_id_ := value_;
      END IF;
   END LOOP;
   tempnum_ := INSTR(company_, '%',1,1) + INSTR(company_, '_',1,1);
   IF (tempnum_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOWILDCARDS: Wildcards cannot be included in company id');
   END IF;
   IF (exec_plan_ = 'ASAP') THEN
      NULL;
   ELSIF (exec_plan_ = 'ONLINE') THEN
      -- Fetch the module and package Create_Company from the user_source view
      Crecomp_Component_API.Get_Use_Make_Company_List(component_tab_, active_list_, i_, update_id_);
      n_ := i_;
      FOR b_ IN 1..i_ LOOP
         -- Just add the component to the pkg_tab since pkg_tab has to have a value when
         -- returned to the client. The pkg were used by old create company concept.
         pkg_tab_(b_) := component_tab_(b_);
      END LOOP;
      FOR t_ IN 1..n_ LOOP
         -- If component is not active then do not do anything for the component.      
         IF ((active_list_(t_) = 'TRUE' ) AND Database_SYS.Component_Active(component_tab_(t_))) THEN
            Client_SYS.Add_To_Attr('MODULE',component_tab_(t_), attr_);
            Client_SYS.Add_To_Attr('PACKAGE',pkg_tab_(t_), attr_);
         END IF;
      END LOOP;
   END IF;
END New_Company__;


PROCEDURE Create_Company_Reg__ (
   execution_order_   IN OUT NUMBER,
   create_and_export_ IN     BOOLEAN  DEFAULT TRUE,
   active_            IN     BOOLEAN  DEFAULT TRUE,
   account_related_   IN     BOOLEAN  DEFAULT FALSE,
   standard_table_    IN     BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   Enterp_Comp_Connect_V170_API.Reg_Add_Component_Detail(
         module_, lu_name_, 'CREATE_COMPANY_API',
         CASE create_and_export_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END,
         execution_order_,
         CASE active_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END,
         CASE account_related_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END,
         'CCD_CREATECOMPANY', 'C1');
   execution_order_ := execution_order_+1;
END Create_Company_Reg__;


PROCEDURE Create_Client_Mapping__ (
   client_window_ IN VARCHAR2 DEFAULT 'frmCreateCompanyTemDetail' )
IS
   clmapprec_    Client_Mapping_API.Client_Mapping_Pub;
   clmappdetrec_ Client_Mapping_API.Client_Mapping_Detail_Pub;
BEGIN
    clmapprec_.module := module_;
    clmapprec_.lu := lu_name_;
    clmapprec_.mapping_id := 'CCD_CREATECOMPANY';
    clmapprec_.client_window := client_window_;
    clmapprec_.rowversion := SYSDATE;
    Client_Mapping_API.Insert_Mapping(clmapprec_);
    clmappdetrec_.module := module_;
    clmappdetrec_.lu := lu_name_;
    clmappdetrec_.mapping_id :=  'CCD_CREATECOMPANY';
    clmappdetrec_.column_type := 'NORMAL';
    clmappdetrec_.translation_type := 'SRDPATH';
    clmappdetrec_.rowversion := SYSDATE;
    clmappdetrec_.column_id := 'C1' ;
    clmappdetrec_.translation_link := 'ACTIVE_ISO_CODES_PCT.ACTIVE_CODE';
    Client_Mapping_API.Insert_Mapping_Detail(clmappdetrec_);
END Create_Client_Mapping__;


-- Generate_Template_Files__
--   Function that returns a list of records with file_name, component, file_content and output_file
--   Parameter "components_" is a colon separated list of components e.g. 'ENTERP,INVOIC'
--   Parameter "language_list_" is a ^ separated list of languages e.g. 'no^sv'
--   output_file is a generate company template installation file
FUNCTION Generate_Template_Files__ (
   template_id_         IN VARCHAR2,
   components_          IN VARCHAR2,
   translation_         IN VARCHAR2 DEFAULT 'FALSE',
   file_per_component_  IN VARCHAR2 DEFAULT 'TRUE',
   language_list_       IN VARCHAR2 DEFAULT NULL ) RETURN CompanyTemplateExpList 
IS 
   file_stream_                  CLOB;
   file_buffer_                  VARCHAR2(32000);   
   clob_final_                   CLOB;   
   templ_rec_                    create_company_tem_tab%ROWTYPE;
   comp_rec_                     create_company_tem_comp_tab%ROWTYPE;
   prev_component_               VARCHAR2(6);
   dummy_component_              VARCHAR2(6) := 'XYZ123';
   curr_component_               VARCHAR2(6);
   curr_language_                VARCHAR2(10);
   begin_                        BOOLEAN := FALSE;
   file_head_created_            BOOLEAN := FALSE;
   file_template_head_created_   BOOLEAN := FALSE;
   file_templated_closed_        BOOLEAN := FALSE;
   trans_head_created_           BOOLEAN := FALSE;   
   create_translation_file_      VARCHAR2(5) := NVL(translation_, 'FALSE');
   use_file_per_component_file_  BOOLEAN := FALSE;
   file_name_                    VARCHAR2(500);
   prev_curr_component_          VARCHAR2(6);      
   blob_                         BLOB;   
   blob_cnt_                     NUMBER := 0;   
   blob_table_                   CompanyTemplateExpList;
   component_table_              Utility_SYS.STRING_TABLE;
   component_cnt_                PLS_INTEGER := 0;   
   language_table_               Utility_SYS.STRING_TABLE;
   language_cnt_                 PLS_INTEGER := 0;   
   CURSOR get_head IS
      SELECT *
      FROM   create_company_tem_tab
      WHERE  template_id = template_id_;
   CURSOR get_comp IS
      WITH data AS (
         SELECT 
            TRIM(SUBSTR(txt,
                        INSTR(txt, ',', 1, level ) + 1,
                        INSTR(txt, ',', 1, level+1) - INSTR(txt, ',', 1, level) -1 ) 
                ) AS token
         FROM (SELECT ','||components_||',' txt
               FROM DUAL)
         CONNECT BY level <= LENGTH(components_)-LENGTH(REPLACE(components_,',',''))+1
         )
      SELECT *
      FROM   create_company_tem_comp_tab
      WHERE  template_id = template_id_
      AND    component IN (SELECT * FROM data)
      ORDER BY component;      
   CURSOR get_comp_lu (module_ IN VARCHAR2) IS
      SELECT module, version, lu, package, export_view 
      FROM   crecomp_component_process      
      WHERE  module = module_
      AND    export_view = 'TRUE'
      ORDER BY module, lu;          
   FUNCTION Convert_Clob_To_Blob___ (
      in_clob_   CLOB ) RETURN BLOB
   IS 
      temp_blob_        BLOB;
      lob_amount_char_  NUMBER := DBMS_LOB.lobmaxsize;
      lob_dest_offset_  NUMBER := 1;
      lob_src_offset_   NUMBER := 1;
      blob_csid_        NUMBER := DBMS_LOB.default_csid;
      lang_context_     NUMBER := DBMS_LOB.default_lang_ctx;
      lob_warning_      NUMBER := 1;      
   BEGIN
      DBMS_LOB.createtemporary(temp_blob_, FALSE, 10);
      DBMS_LOB.converttoblob(temp_blob_, in_clob_, lob_amount_char_, lob_dest_offset_, lob_src_offset_, blob_csid_, lang_context_, lob_warning_);         
      RETURN temp_blob_;
   END Convert_Clob_To_Blob___;
   PROCEDURE Free_Temporary_Blob___ (
      temp_blob_   IN OUT BLOB )
   IS
   BEGIN
      IF (DBMS_LOB.istemporary(temp_blob_) = 1) THEN
         DBMS_LOB.freetemporary(temp_blob_);
      END IF;              
   END Free_Temporary_Blob___;
BEGIN   
   OPEN get_head;
   FETCH get_head INTO templ_rec_;
   CLOSE get_head;
   OPEN get_comp;
   FETCH get_comp INTO comp_rec_;
   CLOSE get_comp;   
   DBMS_LOB.createtemporary(blob_, FALSE, 10);    
   prev_component_ := dummy_component_;
   FOR rec_ IN get_comp LOOP      
      curr_component_ := rec_.component;
      IF (prev_component_ != rec_.component) THEN  
         IF NOT (file_head_created_) THEN            
            Enterp_Lob_Writer_API.Write_Initiate(file_stream_, file_buffer_);
            Write_Template_File_Head___(file_stream_, file_buffer_, templ_rec_, rec_, false);
            file_head_created_ := TRUE;
         END IF;                      
         IF (file_per_component_ = 'TRUE') THEN
            IF (file_template_head_created_) THEN               
               Write_Template_Close___(file_stream_, file_buffer_);
               Enterp_Lob_Writer_API.Write_Finalize(clob_final_, file_stream_, file_buffer_);               
               blob_ := Convert_Clob_To_Blob___(clob_final_);
               blob_cnt_ := blob_cnt_ + 1;
               blob_table_(blob_cnt_).file_name := prev_component_ || '_CompanyTemplate_' || templ_rec_.template_id || template_file_extension_;
               blob_table_(blob_cnt_).component := prev_component_;
               blob_table_(blob_cnt_).file_content := 'TEMPLATE';
               blob_table_(blob_cnt_).output_file := blob_;
               file_template_head_created_ := FALSE;
               file_templated_closed_ := TRUE;
               file_head_created_ := FALSE;               
            END IF;              
            IF (file_templated_closed_) THEN
               IF NOT (file_head_created_) THEN                  
                  Enterp_Lob_Writer_API.Write_Initiate(file_stream_, file_buffer_);
                  Write_Template_File_Head___(file_stream_, file_buffer_, templ_rec_, rec_, false);
                  file_head_created_ := TRUE;                  
               END IF;                      
               file_templated_closed_ := FALSE;
            END IF;
         ELSE
            IF (file_template_head_created_) THEN
               Write_Line___(file_stream_, file_buffer_, 'UNDEFINE COMPONENT');
               Write_Line___(file_stream_, file_buffer_, 'UNDEFINE VERSION');
               Write_Line___(file_stream_, file_buffer_, '--<<END>>');
               Write_Line___(file_stream_, file_buffer_, '--<<START>>');
            END IF;
         END IF;                           
         Write_Template_Head___(file_stream_, file_buffer_, templ_rec_, rec_);         
         file_template_head_created_ := TRUE;         
         prev_component_ := rec_.component;
      END IF;            
      FOR comp_lu_rec_ IN get_comp_lu(rec_.component) LOOP
         Write_Template_Values___(file_stream_, file_buffer_, templ_rec_, rec_, comp_lu_rec_.lu);
      END LOOP;
   END LOOP;
   IF (file_template_head_created_) THEN
      Write_Template_Close___(file_stream_, file_buffer_);
      Enterp_Lob_Writer_API.Write_Finalize(clob_final_, file_stream_, file_buffer_);      
      file_head_created_ := FALSE;
   END IF;   
   blob_ := Convert_Clob_To_Blob___(clob_final_);
   blob_cnt_ := blob_cnt_ + 1;
   IF (file_per_component_ = 'TRUE') THEN
      blob_table_(blob_cnt_).file_name := curr_component_ || '_CompanyTemplate_' || templ_rec_.template_id || template_file_extension_;
      blob_table_(blob_cnt_).component := curr_component_;
   ELSE 
      blob_table_(blob_cnt_).file_name := 'CompanyTemplate_' || templ_rec_.template_id || template_file_extension_;
      blob_table_(blob_cnt_).component := 'ALL';
   END IF;
   blob_table_(blob_cnt_).file_content := 'TEMPLATE';   
   blob_table_(blob_cnt_).output_file := blob_; 
   Free_Temporary_Blob___(blob_);
   Tokenize___(language_table_, language_cnt_, language_list_, '^');
   Tokenize___(component_table_, component_cnt_, components_, ',');
   use_file_per_component_file_ := CASE file_per_component_ WHEN 'TRUE' THEN TRUE ELSE FALSE END;
   IF (create_translation_file_ = 'TRUE') THEN   
      IF (component_cnt_ > 0) THEN
         FOR i_ IN 1..language_cnt_ LOOP
            curr_language_ := language_table_(i_);
            prev_curr_component_ := dummy_component_;
            FOR j_ IN 1..component_cnt_ LOOP 
               curr_component_ := component_table_(j_);
               IF (trans_head_created_) THEN 
                  IF (file_per_component_ = 'TRUE') THEN                  
                     Write_Close_Translate_File___(file_stream_, file_buffer_, begin_, prev_curr_component_, curr_language_);
                     Enterp_Lob_Writer_API.Write_Finalize(clob_final_, file_stream_, file_buffer_);
                     blob_ := Convert_Clob_To_Blob___(clob_final_);
                     IF (use_file_per_component_file_) THEN
                        file_name_ := prev_curr_component_ || '_CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
                     ELSE
                        file_name_ := 'CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
                     END IF;                                   
                     blob_cnt_ := blob_cnt_ + 1;
                     blob_table_(blob_cnt_).file_name := file_name_;
                     blob_table_(blob_cnt_).component := prev_curr_component_;   
                     blob_table_(blob_cnt_).file_content := 'TRANSLATION';                            
                     blob_table_(blob_cnt_).output_file := blob_;                             
                     Enterp_Lob_Writer_API.Write_Initiate(file_stream_, file_buffer_);
                     Write_Translate_File_Head___(file_name_, file_stream_, file_buffer_, templ_rec_.template_id, curr_component_, curr_language_, use_file_per_component_file_);    
                     trans_head_created_ := TRUE;
                  ELSE                  
                     Write_Close_Translate_File___(file_stream_, file_buffer_, begin_, prev_curr_component_, curr_language_);
                     Write_Translate_Head___(file_stream_, file_buffer_, templ_rec_.template_id, curr_component_, curr_language_);                  
                  END IF;
               END IF;
               IF NOT (trans_head_created_) THEN                
                  Enterp_Lob_Writer_API.Write_Initiate(file_stream_, file_buffer_);
                  Write_Translate_File_Head___(file_name_, file_stream_, file_buffer_, templ_rec_.template_id, curr_component_, curr_language_, use_file_per_component_file_);             
                  trans_head_created_ := TRUE;               
               END IF;               
               Write_Template_Translations___(file_stream_, file_buffer_, begin_, templ_rec_.template_id, curr_component_, curr_language_);
               prev_curr_component_ := curr_component_;
            END LOOP;
            Write_Close_Translate_File___(file_stream_, file_buffer_, begin_, curr_component_, curr_language_);
            Enterp_Lob_Writer_API.Write_Finalize(clob_final_, file_stream_, file_buffer_);
            trans_head_created_ := FALSE;
            blob_ := Convert_Clob_To_Blob___(clob_final_);
            blob_cnt_ := blob_cnt_ + 1;
            IF (use_file_per_component_file_) THEN
               file_name_ := curr_component_ || '_CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
               blob_table_(blob_cnt_).component := curr_component_;   
            ELSE
               file_name_ := 'CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
               blob_table_(blob_cnt_).component := 'ALL';   
            END IF;            
            blob_table_(blob_cnt_).file_name := file_name_;
            blob_table_(blob_cnt_).file_content := 'TRANSLATION';         
            blob_table_(blob_cnt_).output_file := blob_;
         END LOOP;
         IF (trans_head_created_) THEN
            Enterp_Lob_Writer_API.Write_Finalize(clob_final_, file_stream_, file_buffer_);
            trans_head_created_ := FALSE;
            blob_ := Convert_Clob_To_Blob___(clob_final_);
            blob_cnt_ := blob_cnt_ + 1;
            IF (use_file_per_component_file_) THEN
               file_name_ := curr_component_ || '_CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
               blob_table_(blob_cnt_).component := curr_component_;
            ELSE
               file_name_ := 'CompanyTemplate_' || templ_rec_.template_id || '_' || curr_language_ || template_file_extension_;
               blob_table_(blob_cnt_).component := 'ALL';
            END IF;
            blob_table_(blob_cnt_).file_name := file_name_;
            blob_table_(blob_cnt_).file_content := 'TRANSLATION';
            blob_table_(blob_cnt_).output_file := blob_;
            Free_Temporary_Blob___(blob_);
         END IF;
      END IF;   
   END IF;
   RETURN blob_table_;
END Generate_Template_Files__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Navigator_Entry_Trans (
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2,
   navigator_entry_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   text_       VARCHAR2(2000);
BEGIN
   text_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_, 'NavigatorEntry');
   RETURN text_;   
   IF (text_ IS NOT NULL) THEN
      RETURN text_;
   ELSE
      RETURN Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_, 'NavigatorEntry', 'PROG');
   END IF;   
END Get_Navigator_Entry_Trans;


PROCEDURE Make_Company (
   attr_         IN VARCHAR2 )
IS
   rec_        Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec;
BEGIN
   rec_ := Enterp_Comp_Connect_V170_API.Get_Crecomp_Lu_Rec('ENTERP', attr_);
   IF (rec_.make_company = 'EXPORT') THEN
      Export___( rec_);
   ELSIF (rec_.make_company = 'IMPORT') THEN
      IF (rec_.action = 'NEW') THEN
         Import___(rec_);
      ELSE
         Create_Company_Log_API.Logging(rec_.company, module_, 'CREATE_COMPANY_API', 'CreatedSuccessfully');
      END IF;
   END IF;
END Make_Company;


PROCEDURE Get_Component (
   component_  OUT VARCHAR2,
   pkg_name_   IN  VARCHAR2 )
IS
BEGIN
   Get_Component___(component_, pkg_name_);
END Get_Component;


PROCEDURE Calc_New_Date (
   new_date_   OUT DATE,
   ref_date_   IN  DATE,
   first_date_ IN  DATE,
   cur_date_   IN  DATE )
IS
BEGIN
   Calc_New_Date___(new_date_, ref_date_, first_date_, cur_date_);
END Calc_New_Date;

   
PROCEDURE Exist_Illegal_Character (
   in_string_ IN VARCHAR2 )
IS
   dummy1_  NUMBER;
BEGIN
   dummy1_ := INSTR(in_string_, '&');
   IF (dummy1_ > 0 ) THEN
      Error_SYS.Appl_General(lu_name_, 'ILLEGALCHAR2: Character ''&'' are not allowed');
   END IF;
END Exist_Illegal_Character;


PROCEDURE Exist_Wildcard (
   in_string_ IN VARCHAR2 )
IS
   dummy1_  NUMBER;
   dummy2_  NUMBER;
BEGIN
   dummy1_ := INSTR(in_string_, '%');
   dummy2_ := INSTR(in_string_, '_');
   IF (dummy1_ > 0 OR dummy2_ > 0) THEN
      Error_SYS.Appl_General(lu_name_, 'ILLEGALCHAR: Wildcards ''%'' and ''_'' are not allowed');
   END IF;
END Exist_Wildcard;


PROCEDURE Get_Column_Mapping (
   msg_       OUT VARCHAR2,
   module_    IN  VARCHAR2,
   lu_        IN  VARCHAR2 )
IS
   mapping_id_        Client_Mapping.mapping_id%TYPE;
   new_msg_           VARCHAR2(8000) := NULL;
BEGIN
   -- Get Mapping Id for Component and Lu
   mapping_id_ := Crecomp_Component_Lu_API.Get_Mapping_Id(module_, lu_);
   IF (mapping_id_ IS NOT NULL) THEN
      Client_Mapping_API.Get_Mapping_Message(new_msg_, module_, lu_, mapping_id_, TRUE, TRUE);
   END IF;
   msg_ := new_msg_;
END Get_Column_Mapping;


PROCEDURE Enumerate_System_Templates(
   template_ids_     OUT VARCHAR2 )
IS
BEGIN
   System_Company_Template_API.Enumerate_System_Templates__(template_ids_);
END Enumerate_System_Templates;


FUNCTION Is_System_Company_Template(
   template_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (System_Company_Template_API.Is_System_Company_Template__(template_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_System_Company_Template;


@UncheckedAccess
FUNCTION Is_Template_Super_User RETURN VARCHAR2
IS
BEGIN
   IF (Comp_Template_Super_User_API.Is_Template_Super_User__) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Template_Super_User;


PROCEDURE Remove_Company_Templ_Comp (
   template_id_   VARCHAR2,
   component_     VARCHAR2 )
IS
BEGIN
   Create_Company_Tem_API.Remove_Company_Templ_Comp__(template_id_, component_);
END Remove_Company_Templ_Comp;


PROCEDURE Remove_Company_Templs_Per_Comp (
   component_     VARCHAR2 )
IS
   CURSOR get_template_ids IS
      SELECT template_id
      FROM   system_company_template_tab;
             
BEGIN
   FOR rec_ IN get_template_ids LOOP
      Create_Company_API.Remove_Company_Templ_Comp(rec_.template_id, component_);
   END LOOP;
END Remove_Company_Templs_Per_Comp;


PROCEDURE Move_User_Def_Co_Templ_Comp (
   old_component_   VARCHAR2,
   new_component_   VARCHAR2 )
IS
   CURSOR get_template_ids IS
      SELECT c.template_id
      FROM   create_company_tem c, create_company_tem_comp_tab cc
      WHERE  c.template_id = cc.template_id
      AND    cc.component = old_component_
      AND    c.system_template = 'FALSE';
BEGIN
   FOR  rec_ IN get_template_ids LOOP
      Create_Company_Tem_API.Move_User_Def_Co_Templ_Comp__(rec_.template_id, old_component_, new_component_);
   END LOOP;
END Move_User_Def_Co_Templ_Comp; 


--This method is to be used by Aurena
PROCEDURE Update_Company_Deferred__ (
   company_            IN VARCHAR2,
   valid_from_         IN DATE,
   source_company_     IN VARCHAR2,
   source_template_id_ IN VARCHAR2,
   non_acc_rel_data_   IN VARCHAR2,
   acc_rel_data_       IN VARCHAR2,
   template_as_source_ IN VARCHAR2,
   update_template_id_ IN VARCHAR2,
   update_id_          IN VARCHAR2,
   run_in_background_  IN VARCHAR2 )   
IS
   error_created_  VARCHAR2(2000);
BEGIN
   Create_Company_API.Update_Company__(error_created_,
                                       company_,
                                       valid_from_,
                                       source_company_,
                                       source_template_id_,
                                       non_acc_rel_data_,
                                       acc_rel_data_,
                                       template_as_source_,
                                       update_template_id_,
                                       update_id_,
                                       run_in_background_);   
END Update_Company_Deferred__;


--This method is to be used by Aurena
PROCEDURE Update_Company__ (
   error_created_      OUT VARCHAR2,
   company_            IN  VARCHAR2,
   valid_from_         IN  DATE,
   source_company_     IN  VARCHAR2,
   source_template_id_ IN  VARCHAR2,
   non_acc_rel_data_   IN  VARCHAR2,
   acc_rel_data_       IN  VARCHAR2,
   template_as_source_ IN  VARCHAR2,
   update_template_id_ IN  VARCHAR2,
   update_id_          IN  VARCHAR2,
   run_in_background_  IN  VARCHAR2 )   
IS 
   description_    VARCHAR2(200);
   languages_      VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   module_list_    VARCHAR2(32000);
   module_         VARCHAR2(100);
   ptr_            NUMBER;
   name_           VARCHAR2(30);
   value_          VARCHAR2(200);   
BEGIN 
   IF (run_in_background_ = 'TRUE') THEN 
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('COMPANY_', company_, attr_);
      Client_SYS.Add_To_Attr('VALID_FROM_', valid_from_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_COMPANY_', source_company_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_TEMPLATE_ID_', source_template_id_, attr_);
      Client_SYS.Add_To_Attr('NON_ACC_REL_DATA_', non_acc_rel_data_, attr_);
      Client_SYS.Add_To_Attr('ACC_REL_DATA_', acc_rel_data_, attr_);
      Client_SYS.Add_To_Attr('TEMPLATE_AS_SOURCE_', template_as_source_, attr_);
      Client_SYS.Add_To_Attr('UPDATE_TEMPLATE_ID_', update_template_id_, attr_);
      Client_SYS.Add_To_Attr('UPDATE_ID_', update_id_, attr_);
      Client_SYS.Add_To_Attr('RUN_IN_BACKGROUND_', 'FALSE', attr_);
      description_ := Language_SYS.Translate_Constant(lu_name_, 'UPDATECOMPANY: Update Company');
      Transaction_SYS.Deferred_Call('Create_Company_API.Update_Company_Deferred__', 'PARAMETER', attr_, description_);
      error_created_ := 'FALSE';
   ELSE       
      IF (template_as_source_ = 'TRUE' AND update_template_id_ IS NOT NULL) THEN 
         IF NOT (Create_Company_Tem_API.Exists(update_template_id_)) THEN 
            Error_SYS.Record_Exist(lu_name_, 'COMPANYTEMPLATENOTEXIST: Template Id :P1 does not exist and cannot be used as template.', update_template_id_);
         END IF;
      END IF;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('NEW_COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('PROCESS', 'ONLINE', attr_);
      Create_Company_API.New_Company__(attr_);
      module_list_ := attr_;      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('NEW_COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('VALID_FROM', valid_from_, attr_);
      Client_SYS.Add_To_Attr('TEMPLATE_ID', source_template_id_, attr_);
      Client_SYS.Add_To_Attr('DUPL_COMPANY', source_company_, attr_);
      IF (source_template_id_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('ACTION', 'NEW', attr_);
      END IF;
      IF (source_company_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('ACTION', 'DUPLICATE', attr_);
      END IF;
      Client_SYS.Add_To_Attr('MAKE_COMPANY', 'IMPORT', attr_);
      Client_SYS.Add_To_Attr('UPDATE_ACC_REL_DATA', acc_rel_data_, attr_);
      Client_SYS.Add_To_Attr('UPDATE_NON_ACC_DATA', non_acc_rel_data_, attr_);
      IF (template_as_source_ = 'TRUE') THEN
         Client_SYS.Add_To_Attr('UPDATE_FROM_TEMPLATE', update_template_id_, attr_);
      END IF;
      Client_SYS.Add_To_Attr('FROM_WINDOW', 'UPDATE_COMPANY', attr_); 
      Client_SYS.Add_To_Attr('MAIN_PROCESS', 'UPDATE COMPANY', attr_);
      Client_SYS.Add_To_Attr('UPDATE_ID', update_id_, attr_);
      languages_ := Company_Key_Lu_API.Get_Existing_Languages(company_);
      WHILE (Client_SYS.Get_Next_From_Attr(module_list_, ptr_, name_, value_)) LOOP
         IF (name_ = 'MODULE') THEN
            module_ := value_;
         END IF;
         IF (module_ IS NOT NULL) THEN 
            Create_Company_API.Create_New_Company__(error_created_,
                                                    company_,
                                                    module_,
                                                    module_, --package should have the same value as module
                                                    attr_,
                                                    languages_);
            $IF Component_Accrul_SYS.INSTALLED $THEN
               IF (module_ = 'ACCRUL') THEN 
                  Company_Finance_API.Set_Creation_Finished(company_);
               END IF;
            $END            
         END IF;
         module_ := NULL;   
      END LOOP;      
      --Update info to implementation table create_company_log_imp_tab
      Create_Company_Log_API.Add_To_Imp_Table__(company_);
      Create_Company_Log_API.Update_Log_Tab_To_Comments__(company_);
   END IF;
END Update_Company__;


FUNCTION Get_Field_Enabled (
   template_id_ IN VARCHAR2,
   module_      IN VARCHAR2,
   lu_          IN VARCHAR2 ) RETURN VARCHAR2 
IS
   enabled_list_ VARCHAR2(32000):=NULL;
   CURSOR get_enabled IS
      SELECT column_id, 
             MIN(object_title) object_title,
             MIN(TO_NUMBER(sort_col)) sort_col
      FROM (SELECT c.column_id                      column_id,
                   c.object_title                   object_title,
                   '999'                            sort_col
            FROM   create_company_tem_lu_tab a, crecomp_component_lu_tab b, client_mapping_detail_tab c
            WHERE  a.component = b.module
            AND    a.lu = b.lu
            AND    b.module = c.module
            AND    b.lu = c.lu
            AND    b.mapping_id = c.mapping_id
            AND    a.template_id = template_id_ 
            AND    a.component = module_ 
            AND    a.lu = lu_
            UNION
            SELECT t.column_id , 
                   '' object_title,
                   t.sort_col
            FROM list_mapping_columns t)
      GROUP BY column_id
      ORDER BY 3;   
BEGIN
   FOR c1 IN get_enabled LOOP
      CASE  
         WHEN c1.object_title IS NOT NULL THEN enabled_list_ := enabled_list_||'Y';
         ELSE enabled_list_ := enabled_list_||'N';
      END CASE;   
   END LOOP;
   RETURN enabled_list_;
END Get_Field_Enabled;


@UncheckedAccess
FUNCTION Get_Field_Labels (
   template_id_ IN VARCHAR2, 
   module_      IN VARCHAR2,
   lu_          IN VARCHAR2 ) RETURN VARCHAR2 
IS
   label_list_  VARCHAR2(32000):=NULL;
   CURSOR get_labels IS 
      SELECT c.column_id                      column_id,
             DECODE(c.translation_type, 
                      'SRDPATH', Language_SYS.Lookup('Column', c.translation_link, 'Prompt', Fnd_Session_API.Get_Language),
                      'ATTRIBUTE', Basic_Data_Translation_API.Get_Basic_Data_Translation(c.module, c.lu, c.translation_link), NULL) translation,
             DECODE(c.translation_type,
                      'SRDPATH', Language_SYS.Lookup('Column', c.translation_link, 'Prompt', 'PROG'),
                      'ATTRIBUTE', Basic_Data_Translation_API.Get_Basic_Data_Translation(c.module, c.lu, c.translation_link, 'PROG'), NULL) translation_prog,
             c.object_title                   object_title
      FROM   create_company_tem_lu_tab a, crecomp_component_lu_tab b, client_mapping_detail_tab c
      WHERE  a.component = b.module
      AND    a.lu = b.lu
      AND    b.module = c.module
      AND    b.lu = c.lu
      AND    b.mapping_id = c.mapping_id
      AND    a.template_id = template_id_ 
      AND    a.component = module_ 
      AND    a.lu = lu_;
BEGIN
   FOR c1 IN get_labels LOOP
      label_list_ := label_list_||c1.column_id||CHR(31)||NVL(NVL(c1.translation, c1.translation_prog), c1.object_title)||CHR(30);
   END LOOP;
   RETURN label_list_;
END Get_Field_Labels;

