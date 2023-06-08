-----------------------------------------------------------------------------
--
--  Logical unit: Language
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950530  ERFO  Created.
--  950607  ERFO  Added procedure Translate_ for language translation.
--  950616  ERFO  Removed optional parameter product_code_ from Translate_.
--                Return value changed to general standard (see below).
--  950622  ERFO  Return LU-information in uppercase.
--  950905  ERFO  Added method Translate_Iid_ and Translate_Msg_.
--  950911  ERFO  Added method Translate_Prompt_.
--  950912  ERFO  Implemented general help function Lookup___  and
--                added documentation headers and examples.
--  950914  ERFO  Changes in name conventions towards run-time database.
--  950928  ERFO  Change name from Translate_Prompt_ to Translate_Item_Prompt_.
--                Added method Translate_Lu_Prompt_ for LU-prompts.
--  950929  ERFO  Added logic to method Translate_Item_Prompt_ through package
--                Dictionary_SYS to solve the problem with full item names.
--  951005  STLA  Modified Translate_Item_Prompt to send full item name to
--                Dictionary_SYS if no translation found.
--  951006  ERFO  Changes in Translate_Lu_Prompt_ for ORACLE 7.2-compliance.
--  951027  ERFO  Added PRAGMA to method Translate_Item_Prompt_ due to
--                dependencies in system service Document_SYS.
--  951030  ERFO  Added methods to support translation of reports.
--                Supported items are: Report titles, column labels and
--                parameter question.
--  951031  ERFO  Changes in Translate_Item_Prompt_ for ORACLE 7.2-compliance.
--  951031  ERFO  Added PRAGMA to method Translate_Iid_ for 7.2-compliance
--                with IID-domains.
--  951101  ERFO  Changed type-representation for report columns from
--                'Column' to 'Report Column'.
--  951115  ERFO  Added methods to support translation of new report attributes.
--                New supported items are: Report layout titles, report texts
--                and module texts.
--  951218  ERFO  Added PRAGMA to all translate-methods in the package (Bug #304).
--                Changed allocation of global language code to a static  value 5.
--                Changed method Translate_Item_Prompt_ to return the attribute
--                prompt in PROG when no translation is found (Bug #302).
--  960109  ERFO  Changes in method Set_Language to support a shared translation
--                environment between IFS Foundation and SYSTEM4 System.
--                Added method Set_Sys4_Language___ that calls method
--                S4_Common.Set_Language by using dynamic PL/SQL (Idea #323).
--  960111  ERFO  Changes in method Set_Language according to support
--                language setting changes on the fly by adding call to
--                Dictionary_SYS.Activate_Language_Refresh_ (Idea #326).
--  960205  ERFO  Changed TYPE-declaration for optimal performance (Idea #386).
--  960321  ERFO  Added method Change_Language to support language setting
--                changes on the fly (Idea #448).
--  960426  ERFO  Changed examples for report translation texts.
--  960430  STLA  Added translation of finite state names (Idea #536).
--  960509  ERFO  Changed parameter in method Translate_Report_Question.
--  960517  ERFO  Changed type 'Question' to 'Report Column' for method
--                Translate_Report_Question (Bug #598). Use the language PROG
--                when a NULL-value is send to Set_Language (Bug #599).
--                Column TEXT extended in theory from 500 to 2000.
--  960724  ERFO  Added method Translate_Constant to support translation of
--                language independant server constants (Idea #688).
--  960724  ERFO  Added default parameter lang_code_ in three methods to support
--                translation of message without relying on general language
--                settings in Language_SYS (Idea #689).
--  960814  MANY  Added Enumerate_Available/Report_Languages and modified all report
--                translation methods to take a default language_code (Idea #747).
--  960821  MANY  Modified Enumerate_Report_Languages to apply to changes in
--                Info Services.
--  960826  MANY  Added default  parameter lang_code_ to Translate_Iid_() and
--                Translate_State_()
--  960903  MANY  Fixed Enumerate_Report_Languages() to handle the case that
--                no free texts exists (Bug #781).
--  960916  ERFO  If any mismatch in number of elements for a translated domain
--                is found during translation, the PROG text will be returned
--                to avoid any problems in the application (Bug #389).
--  960930  MANY  Improved Enumerate_Report_Languages() to return a list of both
--                LANG_CODE and DESCRIPTION (ISO_LANGUAGE_API.Get_Description()).
--  961031  ERFO  Removed dependencies to logical unit Iso_Language_API.
--  961101  MANY  Added Translate_Report_Column_Status().
--  961117  ERFO  Removed unnecessary check of package S4_COMMON for SYS4.
--  970604  ERFO  Changed implementation of Set/Get_Language.
--                Removed support for IFS SYSTEM4 System.
--  970722  ERFO  Removed unused Translate_Module_Text and made the methods
--                Translate_Report_* and Enumerate_* protected (ToDo #1512).
--  970729  ERFO  Reinstall Translate_Report_Text as public interface.
--  970806  MANY  Implementation of new concept, PrintLanguage - methods
--                Set_Print_Language_() and Get_Print_Language.
--  971210  ERFO  Changes concerning usage of NVL-function in the methods
--                Get_Lu_Prompt_ and Get_Item_Prompt_ (Todo #1869).
--  980306  ERFO  Changes concerning new language configuration (ToDo #2212).
--  980316  MANY  Implemented Todo #2176, Include PROG in report languages for
--                testing purposes.
--  990615  ERFO  Added view LANGUAGE_CODE_DISTINCT and method Exist to
--                validate the corresponding language code (ToDo #3430).
--  990615  RaKu  Added comment on view LANGUAGE_CODE_DISTINCT (ToDo #3430).
--                Added in Exist so NULL and % are not validated.
--  000126  bugP  Added new methods for output services translation support (re. OS_Changes)
--  020115  ROOD  Added public method Lookup (ToDo#4073)
--  020128  ROOD  Removed obsolete code originally added for Output Services.
--  020312  ROOD  Modified method Exist for better performance. Will still be slow for the
--                case when exception is raised (full table scan is performed) (Bug#28505).
--  020409  ROOD  Changed language_code_tab to language_sys_tab in correction (Bug#28505).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021016  OVJOSE Glob01. Added Cleanup and Insert_Translation.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030931  HAAR  Obsoleted method Change_Language (ToDo#4305).
--  031013  ROOD  Simplified the method Enumerate_Report_Languages_ for performance reasons.
--  040227  HAAR  Added hint in procedure Cleanup due to performance problems (Bug#43529).
--  040419  STDA  Added call to Database_SYS.Unistr to support unicode (F1PR408B).
--  040630  ROOD  Changed view comments LU -> SERVICE (F1PR413).
--  040707  ROOD  Modifications in Translate_Item_Prompt_ (F1PR413).
--  040907  ROOD  Changed calls to dictionary method in Translate_Item_Prompt_ (F1PR413).
--  040923  ROOD  Changes due to modified interface in Dictionary (F1PR413).
--  041119  HAAR  Changed to use Fnd_Session_API.Set_Language (F1PR413E).
--  050607  HAAR  Added Language_Installed_ and Language_Uninstalled_ (F1PR413).
--  051005  TOBE  Added methods for Get_Basic_Text (F1PR844).
--  051208  TOBE  Added method Get_Full_Name (F1PR844).
--  060108  STDA  Added modification of status_db in Language_Installed_ and
--                Language_Uninstalled_ (Call:130920).
--  060214  ovjose Added Cleanup_Basic_Data_Imp.
--  060517  HAAR  Changed Change_Language_Code so it does not validate NLS data (Bug#57096).
--  060919  NiWi  Modified Enumerate_Available_Languages_ (Bug#60600).
--  060928  STDA  Translation Simplification (BUG#58618).
--  061120  SRSO  Export Lng/Trs files(BUG#61459).
--  061229  SRSO  Improve performance in exporting Lng/Trs(BUG#61459).
--  070103  STDA  Language file import - Performance improvements (BUG#62613).
--  070124  STDA  Added model reference in bulk import/export of lng and 
--                support of main_type RWC in refresh of language dictionary (BUG#61395).
--  070228  HAAR  Added Get_Display_Name (Bug#63688).
--  070614  STDA  Removed truncate of language_file_import_tab in Bulk_Import_Def_Call_.
--  070712  UTGULK  Corrected the varible component_ sent in call to Basic_Data_translation_API in method Cleanup___ (Bug66606).
--  070724  PEMASE Added Assert annotations to Refresh_Language_Dictionary_ / Refresh_Language_Dict_ (Bug 66828).
--  070806  SUMALK  Corrected the performance issue in LANGUAGE_CODE_DISTINCT view(Bug#65826).
--  071028  HAAR   Changed how position is set for FORALL statement (Bug#67485).
--  071130  SRSO  Changed auto population strategy for some configuration list windows(Bug#68993).
--  070904  LALI  Added refresh support for main type 'BI'
--  070905  LALI  Added new implementation methods and rewritten old GEt methods to
--                be able to reuse code. BUT why use methods that returns info from CLOBS?
--                NAd what about ascii/unicode .
--  071120 UTGULK Merged the BI changes. (Bug#69111).
--  071220 Sumalk Changed duplicate translate constant LANGERR to LNGCODEERROR in Exist()(Bug#69887).
--  080917 HASPLK Changed variable length of a_text_ in Bulk_Import_Trs_ method.(Bug#75330).
--  081216  HAAR  Changed to use Autonomous transaction for logging in background jobs (IID#80009).
--  090116 HASPLK Changed variable length of msgkey_ in Translate_Msg_ method.(Bug#79847).
--  091030 STDAFI No dots at the end of context menu. Added logic for termtrans/RWC (Bug#86758).
--  091126 JOWISE Using display name as fallback to en. (Bug#87051).
--  100330 PKULLK Modified Refresh_Language_Dictionary_ to show prog-text values when translated values are empty
--                in IID's (Bug#89797).
--  100819 VIVILK Modified the type of c_name_, c_path_, c_path_tmp_ variables to increase the size of variable (Bug#92505)
-----------------------------------------------------------------------------
--  100827  SRSO  Export TT files(Falcon - next core)
--  110429 JOWISE Added handling for line breaks for RWC clients (Bug#94201)
--  110510 STDAFI Added call to analyze some defined tables in Bulk_Import_Def_Call_ to speed up refresh of languages.
--                Needed in fresh installation (Oracle11).
--  110922 SRSOLK Removed Rich Web client and Windows client[SO] from Refresh language cache
--  111108 JOWISE Added FUNCTION Translate_Searchdomain_
--  120405 JOWISE Added call to Domain_SYS.Refresh_Language_
--  120924 JOWISE Added Bulk_Export_TT_CBS_ (Bug#105412)
--  120928 VOHELK Bug 105221, Modified Bulk_Export_Trs_(), Filtered out main_type BI from .trs file 
--  130313 LIRISE Bug 108902 The gb language does not show up in the Print Dialog language combobox even if it is installed. 
--  130419 LIRISE Bug 109520, 'gb' language should not require translations, but is has to be installed. (supplementary bug for 108902)
--  130828 JOWISE Bug 112178, Adding RFC3066 language code to TRS file header
-----------------------------------------------------------------------------
--
--  Dependencies: Language_SYS base table
--                Dictionary_SYS
--
--  Contents:     Implementation methods for general tasks
--                Protected run-time translation methods
--                Public language setup methods
--
-----------------------------------------------------------------------------
--
--  Table:   CREATE TABLE LANGUAGE_SYS_TAB (
--              TYPE      VARCHAR2(50)     NOT NULL,
--              PATH      VARCHAR2(500)    NOT NULL,
--              ATTRIBUTE VARCHAR2(50)     NOT NULL,
--              LANG_CODE VARCHAR2(5)      NOT NULL,
--              MODULE    VARCHAR2(50)     NOT NULL,
--              TEXT      VARCHAR2(2000))
--
--  Example: INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Message', 'Employee.NODEFROLE', 'Text', 'sv',
--               'INVENTORY', 'No default role for this employee.');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Message', 'Error_SYS.UPDATE', 'Text', 'sv',
--               'Error_SYS', '[:NAME] inte uppdaterbart.');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Logical Unit', 'OrderPriority', 'Prompt', 'sv',
--               'INVENTORY', 'Orderprioritet');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Logical Unit', 'OrderPriority', 'Client Values', 'sv',
--               'INVENTORY', 'en^fem^sju^');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Column', 'PAY_CODE.DESCRIPTION', 'Prompt', 'sv',
--               'ACCOUNTING', 'Beskrivning');
--
------------------------- New examples for 1.2 -------------------------- 1.1.0
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Report', 'Customer.CUSTOMER_OVERVIEW_REP',
--               'Title', 'sv', 'ACCOUNTING', 'Kunder - kostnadslista');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Report Column', 'Customer.CUSTOMER_OVERVIEW_REP.CUSTOMER_NO',
--               'Title', 'sv', 'ACCOUNTING', 'Kundnr');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Question', 'Customer.CUSTOMER_OVERVIEW_REP.CUSTOMER_NO',
--               'Prompt', 'sv', 'ACCOUNTING', 'Ange kundnr (% ger alla):');
--
------------------------- New examples for 1.2 -------------------------- 1.1.1
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Report Layout', 'Customer.CUSTOMER_OVERVIEW_REP.DETAIL',
--               'Title', 'sv', 'WO', 'Detalj');
--
--           INSERT INTO LANGUAGE_SYS_TAB VALUES
--              ('Report Data', 'Customer.CUSTOMER_OVERVIEW_REP.Report Constants',
--               'SUMARIZE', 'sv', 'WO', 'Summering')
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE a200_array IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
TYPE a2000_array IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
TYPE a4000_array IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
TYPE number_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Lookup___ (
   type_      IN VARCHAR2,
   path_      IN VARCHAR2,
   attribute_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   main_type_ IN VARCHAR2 DEFAULT 'LU' ) RETURN VARCHAR2
IS
   var_main_type_    language_sys_tab.main_type%TYPE;
   text_ VARCHAR2(2000);
   CURSOR get_trans IS
      SELECT /*+ INDEX(language_sys_tab language_sys_ix)*/ text
      FROM   language_sys_tab
      WHERE  main_type = var_main_type_
      AND    type = type_
      AND    path = path_
      AND    attribute = attribute_
      AND    lang_code = lang_code_;
BEGIN
   IF (main_type_ = 'SVC' AND type_ = 'Message') THEN
      var_main_type_ := 'LU';
   ELSE
      var_main_type_ := main_type_;
   END IF;
   
   OPEN get_trans;
   FETCH get_trans INTO text_;
   CLOSE get_trans;
   RETURN(text_);
END Lookup___;

PROCEDURE Change_Language_Code___ (
   lang_code_    IN VARCHAR2,
   installed_db_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   info_       VARCHAR2(1000);
   attr_       VARCHAR2(1000);
   CURSOR get_lang IS
      SELECT objid, objversion
      FROM   language_code
      WHERE  lang_code = lang_code_;

   status_db_ language_code_tab.status%TYPE := 'A';
BEGIN
   Client_SYS.Add_To_Attr('VALIDATE_NLS', 'FALSE', attr_); -- Don't validate nls_data from here
   Client_SYS.Add_To_Attr('INSTALLED_DB', installed_db_, attr_);
   OPEN  get_lang;
   FETCH get_lang INTO objid_, objversion_;
   CLOSE get_lang;
   IF (installed_db_ = 'FALSE' OR objid_ IS NULL) THEN
	   status_db_ := 'P';
   END IF;
   Client_SYS.Add_To_Attr('STATUS_DB', status_db_, attr_);
   Client_SYS.Add_To_Attr('DICTIONARY_UPDATE', sysdate, attr_);
   IF objid_ IS NULL THEN
      Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', lang_code_, attr_);
      Client_SYS.Add_To_Attr('LANG_CODE_RFC3066', Lower(lang_code_)||'-'||Upper(lang_code_), attr_);
      Client_SYS.Add_To_Attr('NLS_LANGUAGE', 'AMERICAN', attr_);
      Client_SYS.Add_To_Attr('NLS_TERRITORY', 'AMERICA', attr_);
      Client_SYS.Add_To_Attr('ENABLED_FOR_LOGIN_DB',installed_db_ , attr_);
      Language_Code_API.New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Language_Code_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Change_Language_Code___;

PROCEDURE Bulk_Export_Add_Header___(
   file_        IN OUT CLOB,
   component_   IN  VARCHAR2,
   layer_       IN VARCHAR2,
   main_type_   IN VARCHAR2, 
   sub_type_    IN VARCHAR2,
   content_     IN VARCHAR2)
 IS

   layer_key_            VARCHAR2(10) := 'Layer';
   main_type_key_        VARCHAR2(10) := 'Main Type';
   sub_type_key_         VARCHAR2(10) := 'Sub Type';
   content_key_          VARCHAR2(20) := 'Content';
   file_type_key_        VARCHAR2(9)  := 'File Type';
   version_key_          VARCHAR2(12) := 'Type version';
   module_key_           VARCHAR2(6)  := 'Module';
   file_type_            VARCHAR2(28) := 'IFS Foundation Language File';
   delimeter_key_        VARCHAR2(1)  := ':';
   delimeter_space_      VARCHAR2(1) := ' ';
   version_1000_         VARCHAR2(5)  := '10.00';
   file_header_          CLOB;
   header_line_          VARCHAR2(200) := '-------------------------------------------------------';
   
  BEGIN

  file_header_ := header_line_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||file_type_key_||delimeter_key_||delimeter_space_||file_type_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||version_key_ ||delimeter_key_||delimeter_space_||version_1000_||CHR(13)||CHR(10);
  file_header_ := file_header_||layer_key_||delimeter_key_||delimeter_space_||layer_||CHR(13)||CHR(10);
  file_header_ := file_header_||main_type_key_||delimeter_key_||delimeter_space_||main_type_||CHR(13)||CHR(10);
  file_header_ := file_header_||sub_type_key_||delimeter_key_||delimeter_space_||sub_type_||CHR(13)||CHR(10);
  file_header_ := file_header_||content_key_||delimeter_key_||delimeter_space_||content_||CHR(13)||CHR(10);
  file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||module_key_||delimeter_key_||delimeter_space_||component_||CHR(13)||CHR(10);
  file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);
  dbms_lob.append(file_header_,file_);
  file_ := file_header_;
  
 END Bulk_Export_Add_Header___;

FUNCTION Bulk_Export_Initialize___(
   component_   IN  VARCHAR2,
   layer_       IN VARCHAR2,
   main_type_   IN VARCHAR2, 
   sub_type_    IN VARCHAR2,
   content_     IN VARCHAR2) RETURN VARCHAR2
 IS

   layer_key_            VARCHAR2(10) := 'Layer';
   main_type_key_        VARCHAR2(10) := 'Main Type';
   sub_type_key_         VARCHAR2(10) := 'Sub Type';
   content_key_          VARCHAR2(20) := 'Content';
   file_type_key_        VARCHAR2(9)  := 'File Type';
   version_key_          VARCHAR2(12) := 'Type version';
   module_key_           VARCHAR2(6)  := 'Module';
   file_type_            VARCHAR2(28) := 'IFS Foundation Language File';
   delimeter_key_        VARCHAR2(1)  := ':';
   delimeter_space_      VARCHAR2(1) := ' ';
   version_1000_         VARCHAR2(5)  := '10.00';
   file_header_          VARCHAR2(1000);
   header_line_          VARCHAR2(200) := '-------------------------------------------------------';
   
  BEGIN

  file_header_ := header_line_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||file_type_key_||delimeter_key_||delimeter_space_||file_type_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||version_key_ ||delimeter_key_||delimeter_space_||version_1000_||CHR(13)||CHR(10);
  file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);
  file_header_ := file_header_||module_key_||delimeter_key_||delimeter_space_||component_||CHR(13)||CHR(10);
  file_header_ := file_header_||layer_key_||delimeter_key_||delimeter_space_||layer_||CHR(13)||CHR(10);
  file_header_ := file_header_||main_type_key_||delimeter_key_||delimeter_space_||main_type_||CHR(13)||CHR(10);
  file_header_ := file_header_||sub_type_key_||delimeter_key_||delimeter_space_||sub_type_||CHR(13)||CHR(10);
  file_header_ := file_header_||content_key_||delimeter_key_||delimeter_space_||content_||CHR(13)||CHR(10);
  file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);
 RETURN file_header_;
 
 END Bulk_Export_Initialize___;


FUNCTION Code___(
   line_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  RETURN replace(replace(line_,chr(10), '\'||chr(38)||'10\' ), chr(13), '\'||chr(38)||'13\');
END Code___;


FUNCTION Bulk_Export_Trs_Initialize___ (
   component_       IN  VARCHAR2,
   trs_language_    IN VARCHAR2,
   layer_           IN VARCHAR2,
   main_type_       IN VARCHAR2, 
   sub_type_        IN VARCHAR2,
   content_         IN VARCHAR2) RETURN VARCHAR2
IS

   file_type_key_        VARCHAR2(9)  := 'File Type';
   version_key_          VARCHAR2(12) := 'Type version';
   module_key_           VARCHAR2(6)  := 'Module';
   file_type_            VARCHAR2(40) := 'IFS Foundation Translation File';
   language_key_         VARCHAR2(8)  :=  'Language';
   culture_key_          VARCHAR2(7)  :=  'Culture';
   layer_key_            VARCHAR2(10)  := 'Layer';
   main_type_key_        VARCHAR2(10)  := 'Main Type';
   sub_type_key_         VARCHAR2(10)  := 'Sub Type';
   content_key_          VARCHAR2(20)  := 'Content';
   delimeter_key_        VARCHAR2(1)  := ':';
   delimeter_space_      VARCHAR2(1) := ' ';
   version_1000_         VARCHAR2(5)  := '10.00';
   file_header_          VARCHAR2(1000);
   header_line_          VARCHAR2(200) := '-------------------------------------------------------';
   culture_              VARCHAR2(12);
BEGIN
   culture_ := language_code_api.get_lang_code_rfc3066(trs_language_);

   file_header_ := header_line_ ||CHR(13)||CHR(10);
   file_header_ := file_header_||file_type_key_||delimeter_key_||delimeter_space_||file_type_ ||CHR(13)||CHR(10);
   file_header_ := file_header_||version_key_ ||delimeter_key_||delimeter_space_||version_1000_||CHR(13)||CHR(10);
   file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);
   file_header_ := file_header_||module_key_||delimeter_key_||delimeter_space_||component_||CHR(13)||CHR(10);
   file_header_ := file_header_||language_key_ ||delimeter_key_||delimeter_space_||trs_language_||CHR(13)||CHR(10);
   file_header_ := file_header_||culture_key_ ||delimeter_key_||delimeter_space_||culture_||CHR(13)||CHR(10);     
   file_header_ := file_header_||layer_key_||delimeter_key_||delimeter_space_||layer_||CHR(13)||CHR(10);
   file_header_ := file_header_||main_type_key_||delimeter_key_||delimeter_space_||main_type_||CHR(13)||CHR(10);
   file_header_ := file_header_||sub_type_key_||delimeter_key_||delimeter_space_||sub_type_||CHR(13)||CHR(10);
   file_header_ := file_header_||content_key_||delimeter_key_||delimeter_space_||content_||CHR(13)||CHR(10);
   file_header_ := file_header_||header_line_ ||CHR(13)||CHR(10);

   RETURN file_header_;
 
END Bulk_Export_Trs_Initialize___;

FUNCTION Clob_To_V2___(
   clob_   IN CLOB) RETURN VARCHAR2
IS
   max_length_   PLS_INTEGER := 32000;
   l_            PLS_INTEGER;
   offset_       PLS_INTEGER := 1;
BEGIN
    l_ := NVL(DBMS_LOB.GETLENGTH(clob_),0);
    IF (l_ = 0) THEN
       RETURN NULL;
    END IF;
    l_ := LEAST(l_, max_length_);
    RETURN(DBMS_LOB.SUBSTR(clob_, l_, offset_));
END Clob_To_V2___;

FUNCTION Remove_Brackets_Word___(
   report_title_ IN VARCHAR2 ) RETURN VARCHAR2
IS
    loop_              BOOLEAN;
    start_             NUMBER;
    end_               NUMBER;
    temp_report_title_ VARCHAR2(3000);
    bracket_str_       VARCHAR2(3000);

BEGIN
   start_ :=-1;
   loop_ := TRUE;
   temp_report_title_ := report_title_;

   WHILE loop_
   LOOP
      
      start_ := instr(temp_report_title_,'(');
      IF start_ >= 1 THEN
         end_ := instr(temp_report_title_,')');
         bracket_str_ := substr(temp_report_title_,start_,end_ - start_);
         temp_report_title_ := REPLACE (temp_report_title_, bracket_str_);
      END IF;
      
      IF instr(temp_report_title_,'(') >= 1 THEN
         temp_report_title_ := Remove_Brackets_Word___(temp_report_title_);
      ELSE
         loop_ := FALSE;
      END IF;

   END LOOP;
   
   RETURN temp_report_title_;

END Remove_Brackets_Word___;


FUNCTION Remove_Characters___(
   report_title_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_report_title_ VARCHAR2(3000);
BEGIN
   temp_report_title_ := Remove_Brackets_Word___(report_title_);
   temp_report_title_ := REPLACE (temp_report_title_,'/');
   temp_report_title_ := REPLACE (temp_report_title_,'-');
   temp_report_title_ := REPLACE (temp_report_title_,'_');
   RETURN temp_report_title_;
END Remove_Characters___;


FUNCTION Check_Special_Report___(
   layout_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_layout_name_ VARCHAR2(3000);
BEGIN

   temp_layout_name_ := layout_name_;

   IF instr(layout_name_,'_jp') >= 1 THEN
      temp_layout_name_ := REPLACE (layout_name_,'_JP');
   END IF;

   IF instr(layout_name_,'_LTR') >= 1 THEN
      temp_layout_name_ := REPLACE (layout_name_,'Rep_LTR','_LTR');
   END IF;

   RETURN temp_layout_name_;

END Check_Special_Report___;

PROCEDURE Cleanup___ (
   main_type_   IN VARCHAR2,
   lang_code_   IN VARCHAR2,
   component_   IN VARCHAR2,
   parent_path_ IN VARCHAR2 DEFAULT '%')
IS
   path_param_ VARCHAR2(2000);
BEGIN 
   
   path_param_:= parent_path_;
  
   IF parent_path_ IS NOT NULL THEN
      DELETE
      FROM  language_sys_tab
      WHERE main_type = main_type_
      AND   lang_code = lang_code_
      AND   module    = component_
      AND   path LIKE  path_param_
      AND   type <> 'Basic Data';
   ELSE  
      DELETE
      FROM  language_sys_tab
      WHERE main_type = main_type_
      AND   lang_code = lang_code_
      AND   module    = component_
      AND   type <> 'Basic Data';
   END IF;
   IF (main_type_ = 'LU') THEN
      Basic_Data_translation_API.Cleanup(component_, lang_code_);
   END IF;      
END Cleanup___;

PROCEDURE Insert_Translation___ (
   error_messages_         IN OUT VARCHAR2,
   type_                   IN a200_array,
   path_                   IN a2000_array,
   attribute_              IN a200_array,
   lang_code_              IN VARCHAR2,
   component_              IN a200_array,
   translation_            IN a4000_array,
   main_type_              IN VARCHAR2,
   bulk_                   IN number_array,
   layer_                  IN a200_array )
IS
   position_ NUMBER;
   -- create an exception handler for ORA-24381
   errors_ NUMBER;
   dml_errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(dml_errors, -24381);

BEGIN
   BEGIN
      FORALL i IN type_.FIRST..type_.LAST SAVE EXCEPTIONS
         INSERT
            INTO language_sys_tab (
               type,
               path,
               attribute,
               lang_code,
               main_type,
               module,
               text,
               installation_text,
               bulk,
               system_defined,
               rowversion,
               layer)
            VALUES (
               type_(i),
               path_(i),
               attribute_(i),
               lang_code_,
               CASE
                  WHEN main_type_ = 'SVC' AND type_(i) = 'Message' THEN
                     'LU'
                  ELSE
                     main_type_
                  END,
               component_(i),
               translation_(i),
               translation_(i),
               bulk_(i),
               'TRUE',
               SYSDATE,
               layer_(i));
   EXCEPTION
      WHEN dml_errors THEN -- Now we figure out what failed and why.
         errors_ := SQL%BULK_EXCEPTIONS.COUNT;
         FOR i IN 1..errors_ LOOP
            position_ :=  SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
            IF (SQL%BULK_EXCEPTIONS(i).ERROR_CODE = 1)THEN -- dup_val_on_index
               UPDATE language_sys_tab
               SET   type = type_(position_),
                     module = component_(position_),
                     text = translation_(position_),
                     installation_text = translation_(position_),
                     bulk = bulk_(position_),
                     system_defined = 'TRUE'
               WHERE path = path_(position_)
               AND   attribute = attribute_(position_)
               AND   lang_code = lang_code_
               AND   main_type = main_type_;
            ELSE
               IF (error_messages_ IS NULL) THEN
                  error_messages_ := component_(position_);
               ELSIF (INSTR(error_messages_,component_(position_)) < 1) THEN
                  error_messages_ := error_messages_||','||component_(position_);
               END IF;
            END IF;
         END LOOP;
   END;
END Insert_Translation___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Translate_Message_
-- Error message for a logical unit, system service or projection.
@UncheckedAccess
FUNCTION Translate_Message_ (
   name_      IN VARCHAR2,
   type_      IN VARCHAR2,
   err_text_  IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   msgkey_ VARCHAR2(120);
   text_   VARCHAR2(2000);
BEGIN
   msgkey_ := rtrim(substr(err_text_, 1, instr(err_text_, ':')-1));
   text_ := Lookup___('Message', name_||'.'||msgkey_, 'Text', nvl(lang_code_, Get_Language), type_);
   IF (text_ IS NULL) THEN
      RETURN(err_text_);
   END IF;
   RETURN(msgkey_||': '||text_);
END Translate_Message_;

-- Translate_Msg_
--   Error message for a logical unit or system service (This will be deprecated).
@UncheckedAccess
FUNCTION Translate_Msg_ (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   msgkey_ VARCHAR2(120);
   text_   VARCHAR2(2000);
BEGIN
   msgkey_ := rtrim(substr(err_text_, 1, instr(err_text_, ':')-1));
   text_ := Lookup___('Message', lu_name_||'.'||msgkey_, 'Text', nvl(lang_code_, Get_Language), 'LU');
   IF (text_ IS NULL) THEN
      RETURN(err_text_);
   END IF;
   RETURN(msgkey_||': '||text_);
END Translate_Msg_;



-- Translate_Iid_
--   IID client value list for a logical unit.
@UncheckedAccess
FUNCTION Translate_Iid_ (
   lu_name_     IN VARCHAR2,
   client_list_ IN VARCHAR2,
   lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_   VARCHAR2(2000);
   count_  NUMBER := 1;
   count2_ NUMBER := 1;
   str_arr_ Utility_SYS.STRING_TABLE;
BEGIN
   text_ := Lookup___('Logical Unit', lu_name_, 'Client Values', nvl(lang_code_, Get_Language), 'LU');
   IF (text_ IS NOT NULL) THEN
      Utility_SYS.Tokenize(client_list_, Client_SYS.text_separator_, str_arr_, count_);
      Utility_SYS.Tokenize(text_, Client_SYS.text_separator_, str_arr_, count2_);
      IF (count_ = count2_) THEN
         RETURN(text_);
      END IF;
   END IF;
   RETURN(client_list_);
END Translate_Iid_;

-- Translate_State_
--   State name client value list for a logical unit.
@UncheckedAccess
FUNCTION Translate_State_ (
   lu_name_     IN VARCHAR2,
   client_list_ IN VARCHAR2,
   lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Logical Unit', lu_name_, 'State Values', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, client_list_));
END Translate_State_;



-- Translate_Lu_Prompt_
--   Prompt for a logical unit.
@UncheckedAccess
FUNCTION Translate_Lu_Prompt_ (
   lu_name_   IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Logical Unit', lu_name_, 'Prompt', nvl(lang_code_, Get_Language), 'LU');
   IF (text_ IS NULL) THEN
      text_ := Dictionary_SYS.Get_Lu_Prompt_(lu_name_);
   END IF;
   RETURN(text_);
END Translate_Lu_Prompt_;



@UncheckedAccess
FUNCTION Translate_Searchdomain_ (
   searchdomain_   IN VARCHAR2,
   module_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
   path_ VARCHAR2(2000);
BEGIN
   path_ := 'SEARCHDOMAIN.' || module_ || '.' || searchdomain_;
   text_ := Lookup___('Search Domain', path_, 'Prompt', nvl(lang_code_, Get_Language), 'LU');
   
   IF (text_ IS NULL) THEN
      text_ := searchdomain_;
   END IF;
   RETURN(text_);
END Translate_Searchdomain_;



-- Translate_Item_Prompt_
--   Attribute prompt for a logical unit and viewitem (attribute).
--   This function  is overloaded to be used with or without LU.
--   The first is used from Reference_SYS and the second is used
--   from Error_SYS.
@UncheckedAccess
FUNCTION Translate_Item_Prompt_ (
   full_item_   IN VARCHAR2,
   item_prompt_ IN VARCHAR2,
   dummy_       IN NUMBER,
   lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_   VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Column', full_item_, 'Prompt', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, item_prompt_));
END Translate_Item_Prompt_;



-- Translate_Item_Prompt_
--   Attribute prompt for a logical unit and viewitem (attribute).
--   This function  is overloaded to be used with or without LU.
--   The first is used from Reference_SYS and the second is used
--   from Error_SYS.
@UncheckedAccess
FUNCTION Translate_Item_Prompt_ (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_      VARCHAR2(2000);
   view_      VARCHAR2(30);
BEGIN
   view_ := Dictionary_SYS.Get_Base_View(lu_name_);
   text_ := Lookup___('Column', view_||'.'||item_, 'Prompt', nvl(lang_code_, Get_Language), 'LU');
   IF (text_ IS NULL) THEN
      text_ := Dictionary_SYS.Get_Item_Prompt_(lu_name_, view_, item_);
   END IF;
   RETURN(text_);
END Translate_Item_Prompt_;



-- Translate_Report_Title_
--   Titles for report definitions from logical unit Report.
@UncheckedAccess
FUNCTION Translate_Report_Title_ (
   lu_name_      IN VARCHAR2,
   report_id_    IN VARCHAR2,
   report_title_ IN VARCHAR2,
   lang_code_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Report', lu_name_||'.'||report_id_, 'Title', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, report_title_));
END Translate_Report_Title_;



-- Translate_Report_Column_
--   Column headers in report layout from logical unit ReportColumn.
@UncheckedAccess
FUNCTION Translate_Report_Column_ (
   lu_name_   IN VARCHAR2,
   report_id_ IN VARCHAR2,
   col_name_  IN VARCHAR2,
   col_title_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Report Column', lu_name_||'.'||report_id_||'.'||col_name_,
                      'Title', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, col_title_));
END Translate_Report_Column_;



-- Translate_Report_Question_
--   Report parameter questions from logical unit ReportParameter.
@UncheckedAccess
FUNCTION Translate_Report_Question_ (
   lu_name_         IN VARCHAR2,
   report_id_       IN VARCHAR2,
   parameter_name_  IN VARCHAR2,
   question_prompt_ IN VARCHAR2,
   lang_code_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Report Column', lu_name_||'.'||report_id_||'.'||parameter_name_,
                      'Query', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, question_prompt_));
END Translate_Report_Question_;



-- Translate_Report_Layout_
--   Titles for report layout definitions from logical unit ReportLayout.
@UncheckedAccess
FUNCTION Translate_Report_Layout_ (
   lu_name_      IN VARCHAR2,
   report_id_    IN VARCHAR2,
   layout_name_  IN VARCHAR2,
   layout_title_ IN VARCHAR2,
   lang_code_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
   report_title_ VARCHAR2(3000);
   layout_name2_ VARCHAR2(3000);
BEGIN

   text_ := Lookup___('Report Layout', lu_name_||'.'||report_id_||'.'||layout_name_,
                      'Title', nvl(lang_code_, Get_Language), 'LU');

   IF (text_ IS NULL) THEN
      -- most of the _jp, _gr, _jp, _ar, _de, _us and _th and other _<some name>will be solved by this becasue the layout name hasn't chnaged
      text_ := Lookup___('Report Layout', lu_name_||'.'||report_id_||'.'|| REPLACE (layout_name_,'.rdl','.xsl'),
                         'Title', nvl(lang_code_, Get_Language), 'LU');
      IF (text_ IS NULL) THEN
         report_title_ := REPLACE (Report_sys.Get_Report_Title(report_id_),' ');
         text_ := Lookup___('Report Layout', lu_name_||'.'||report_id_||'.'|| report_title_ || 'Rep.xsl',
                            'Title', nvl(lang_code_, Get_Language), 'LU');
         IF (text_ IS NULL) THEN
              report_title_ := Remove_Characters___(report_title_);
              text_ := Lookup___('Report Layout', lu_name_||'.'||report_id_||'.'|| report_title_ || 'Rep.xsl',
                            'Title', nvl(lang_code_, Get_Language), 'LU');
              IF (text_ IS NULL) THEN
                 layout_name2_ := Check_Special_Report___(layout_name_);
                 text_ := Lookup___('Report Layout', lu_name_||'.'||report_id_||'.'|| REPLACE (layout_name_,'.rdl','.xsl'),
                                    'Title', nvl(lang_code_, Get_Language), 'LU');
                 IF (text_ IS NULL) THEN
                    RETURN(nvl(text_, layout_title_));
                 ELSE
                    RETURN(text_);
                 END IF;
              ELSE
                 RETURN(text_);
              END IF;
         ELSE
              RETURN(text_);
         END IF;
      ELSE
         RETURN(text_);
      END IF;
   ELSE
      RETURN(text_);
   END IF;

END Translate_Report_Layout_;



@UncheckedAccess
FUNCTION Translate_Report_Col_Status_ (
   lu_name_     IN VARCHAR2,
   report_id_   IN VARCHAR2,
   col_name_    IN VARCHAR2,
   status_text_ IN VARCHAR2,
   lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Report Column', lu_name_||'.'||report_id_||'.'||col_name_,
                      'Status Text', nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, status_text_));
END Translate_Report_Col_Status_;



@UncheckedAccess
PROCEDURE Enumerate_Available_Languages_ (
   lang_codes_ OUT VARCHAR2 )
IS
   lang_list_ VARCHAR2(2000);
   CURSOR get_lang IS
      SELECT lang_code
      FROM   language_code_distinct;
BEGIN
   FOR lang IN get_lang LOOP
      IF UPPER(lang.lang_code) <> 'PROG' THEN
         lang_list_ := lang_list_ || lang.lang_code || Client_SYS.field_separator_;
      END IF;
   END LOOP;
   lang_codes_ := lang_list_;
END Enumerate_Available_Languages_;



@UncheckedAccess
PROCEDURE Enumerate_Report_Languages_ (
   lang_attr_  OUT VARCHAR2,
   report_id_  IN  VARCHAR2 )
IS
   tmp_attr_     VARCHAR2(32000);

   CURSOR get_lang(type_ IN VARCHAR2, path_ IN VARCHAR2, attribute_ IN VARCHAR2) IS
      SELECT DISTINCT lang_code
      FROM   language_sys_tab
      WHERE  main_type = 'LU'
      AND    type = type_
      AND    path LIKE path_
      AND    attribute = attribute_
      UNION
      SELECT 'en' FROM DUAL
      UNION
      SELECT 'gb' FROM language_code_tab WHERE lang_code='gb' AND installed='TRUE';
BEGIN
   -----------------------------------------------------------------------------
   -- Consider a report translated if the report title is translated.
   -----------------------------------------------------------------------------
   FOR lang IN get_lang('Report', '%.'||report_id_, 'Title') LOOP
      Client_SYS.Add_To_Attr(lang.lang_code, lang.lang_code, tmp_attr_);
   END LOOP;
   lang_attr_ := tmp_attr_;
END Enumerate_Report_Languages_;



PROCEDURE Language_Installed_ (
   lang_code_    IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Language_Installed_');
   Change_Language_Code___(lang_code_, 'TRUE');
END Language_Installed_;


PROCEDURE Language_Uninstalled_ (
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Language_Uninstalled_');
   Change_Language_Code___(lang_code_, 'FALSE');
END Language_Uninstalled_;


@UncheckedAccess
PROCEDURE Set_Print_Language_ (
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Set_Print_Language_;


@UncheckedAccess
FUNCTION Translate_Report_Text_ (
   lu_name_       IN VARCHAR2,
   report_id_     IN VARCHAR2,
   variable_name_ IN VARCHAR2,
   variable_text_ IN VARCHAR2,
   lang_code_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Lookup___('Report Data', lu_name_||'.'||report_id_||'.'||'Report Constants',
                      variable_name_, nvl(lang_code_, Get_Language), 'LU');
   RETURN(nvl(text_, variable_text_));
END Translate_Report_Text_;



PROCEDURE Refresh_Language_Dictionary_ (
   lang_code_             IN VARCHAR2 DEFAULT NULL,
   component_             IN VARCHAR2 DEFAULT NULL,
   auto_transaction_      IN VARCHAR2 DEFAULT 'TRUE',
   refresh_domain_        IN VARCHAR2 DEFAULT 'TRUE',
   refresh_main_type_     IN VARCHAR2 DEFAULT NULL,
   refresh_type_          IN VARCHAR2 DEFAULT NULL,
   path_                  IN VARCHAR2 DEFAULT '%', 
   handle_db_transaction_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   TYPE a10_array IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
   lang_code_arr_ a10_array;
   component_arr_ a10_array;
   warning_       BOOLEAN := FALSE;

   CURSOR get_lang_code (lang_code_ VARCHAR2) IS
      SELECT lang_code
      FROM   language_code_tab
      WHERE  lang_code = decode(lang_code_,null,lang_code,lang_code_)
      AND    status = 'A'
      UNION
      SELECT decode(lang_code_,null,'en',lang_code_) FROM dual;

   CURSOR get_component (component_ VARCHAR2) IS
      SELECT module
      FROM   module_tab
      WHERE  module = decode(component_,NULL,module,component_)
      AND    NVL(version, '*') != '*'
      ORDER BY module;

   PROCEDURE Refresh_Language_Dict_ (
      lang_code_         IN VARCHAR2,
      component_         IN VARCHAR2,
      refresh_main_type_ IN VARCHAR2 DEFAULT NULL,
      refresh_type_      IN VARCHAR2 DEFAULT NULL,
      path_              IN VARCHAR2 DEFAULT '%')
   IS

      CURSOR check_mainType___ (component_ VARCHAR2, main_type_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT 1
         FROM   language_context_tab ctx
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = main_type_
         AND    ctx.path LIKE (path_);

      CURSOR generate_notIID___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module,
                ctx.path, 
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id, 
                atr.prog_text,
                atr.name, 
                NVL(ctx.bulk,0)
          FROM  language_context_tab ctx,
                language_attribute_tab atr,
                fnd_layer_tab lyr
          WHERE  ctx.layer=lyr.layer_id
          AND    ctx.module = component_
          AND    ctx.obsolete <> 'Y'
          AND    ctx.main_type = 'LU'
          AND    ctx.sub_type <> 'Iid Element'
          AND    ctx.sub_type <> 'State'
   	    AND    ctx.sub_type <> 'Company Template'
          AND    ctx.context_id = atr.context_id
          AND    ctx.path LIKE (path_)
          AND    atr.obsolete <> 'Y'
          ORDER BY ctx.path,lyr.ordinal ASC;

      CURSOR generate_IID___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module,
                substr(ctx.path, 0,INSTR(ctx.path,'.') -1) lu,
                ctx.path,
                ctx.sub_type,
                atr.attribute_id, 
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr,
                fnd_layer_tab lyr
         WHERE  ctx.layer=lyr.layer_id
         AND    ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'LU'
         AND   (ctx.sub_type = 'Iid Element' OR ctx.sub_type = 'State')
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y'
         ORDER BY lu,
                  TO_NUMBER(Language_Property_API.Get_Value( ctx.context_id, 'Position')),ctx.path,lyr.ordinal ASC;

      CURSOR generate_Templates___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path, 
                ctx.sub_type,
                atr.attribute_id, 
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'LU'
         AND    ctx.sub_type  = 'Company Template'
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y'
         ORDER BY nlssort(ctx.path, 'nls_sort = binary');

      CURSOR generate_Java___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.name, 
                ctx.sub_type,
                ctx.layer,
                MAX(atr.attribute_id), 
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'JAVA'
         AND    ctx.path LIKE (path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y'
         GROUP BY ctx.module, 
                  ctx.name, 
                  ctx.sub_type,
                  ctx.layer,
                  atr.prog_text, 
                  atr.name, 
                  NVL(ctx.bulk,0);

      CURSOR generate_BI___(component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module,                       
                ctx.path, 
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id, 
                atr.prog_text,
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'BI'
         AND    ctx.path LIKE (path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y';
         
      CURSOR generate_Webfw___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path, 
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'WEBFW'
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y';   
         
      CURSOR generate_Web___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'WEB'
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y'; 
         
      CURSOR generate_DBIDP___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'DBIDP'
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y';

      CURSOR generate_SVCFW___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%' ) IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'SVCFW'
         AND    ctx.path LIKE (path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y';
         
      CURSOR generate_BPA___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%' ) IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'SP-BPA'
         AND    ctx.path LIKE (path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y';   
	  
	   CURSOR generate_SVC___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'SVC'
         AND    ctx.context_id = atr.context_id
         AND    ctx.path LIKE (path_)
         AND    atr.obsolete <> 'Y';
         
      CURSOR generate_MOBILE___ (component_ VARCHAR2,path_ VARCHAR2 DEFAULT '%') IS
         SELECT ctx.module, 
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text, 
                atr.name, 
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = 'MOBILE'
         AND    ctx.path LIKE (path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y';
      
      main_type_                    language_sys_tab.main_type%TYPE;
      db_values_                    VARCHAR2(2000);
      client_values_                VARCHAR2(2000);
      previous_lu_                  VARCHAR2(200);
      previous_path_                language_context_tab.path%TYPE;
      previous_sub_type_            language_context_tab.sub_type%TYPE;
      attrib_type_                  language_context_tab.sub_type%TYPE;
      dummy_                        NUMBER;
      basic_data_                   BOOLEAN;

      component_array_              a200_array;
      lu_array_                     a200_array;
      path_array_                   a2000_array;
      sub_type_array_               a200_array;
      layer_array_                  a200_array;
      attribute_id_array_           number_array;
      prog_text_array_              a4000_array;
      attribute_name_array_         a200_array;
      translation_array_            a4000_array;
      bulk_array_                   number_array;

      ins_                          NUMBER;
      ins_component_                a200_array;
      ins_path_                     a2000_array;
      ins_sub_type_                 a200_array;
      ins_layer_                    a200_array;
      ins_attribute_name_           a200_array;
      ins_translation_              a4000_array;
      ins_bulk_                     number_array;
      error_messages_               VARCHAR2(4000);

      fetch_limit_                  NUMBER := 2000;

      -- Template
      template_id_                  VARCHAR2(100);
      delimeter_path_               VARCHAR2(1)   := '.';
      delimeter_path_loc_           NUMBER;
      path_tmp_                     language_context_tab.path%TYPE;
      template_data_                BOOLEAN;

      stmt_refresh_templ_trans_     VARCHAR2(100) := 'BEGIN Enterp_Comp_Connect_V170_API.Refresh_Templ_Trans(:key_value_,:module_,:language_code_); END;';
      stmt_init_templ_trans_        VARCHAR2(100) := 'BEGIN Enterp_Comp_Connect_V170_API.Init_Templ_Trans(:key_value_,:module_,:language_code_); END;';
      stmt_insert_transl_exp_       VARCHAR2(100) := 'BEGIN Enterp_Comp_Connect_V170_API.Insert_Translation_Exp(:msg_); END;';
      
   BEGIN
   
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'LU') THEN
         -- Logical Units
         main_type_ := 'LU';
         basic_data_ := FALSE;
         template_data_ := FALSE;

         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;

         OPEN check_mainType___(component_, main_type_,path_);
         FETCH check_mainType___ INTO dummy_;
         IF (check_mainType___%FOUND) THEN

            IF (refresh_type_ IS NULL OR refresh_type_ = 'notIID') THEN
               -- notIID
               OPEN generate_notIID___(component_,path_);
               LOOP

                 FETCH generate_notIID___ BULK COLLECT
                     INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                        bulk_array_ LIMIT fetch_limit_;
                  IF path_array_.count > 0 THEN
                    -- clear arrays
                    ins_component_.DELETE;
                    ins_translation_.DELETE;
                    ins_path_.DELETE;
                    ins_sub_type_.DELETE;
                    ins_attribute_name_.DELETE;
                    ins_bulk_.DELETE;
                    ins_layer_.DELETE;
                    ins_ := 1;

                    FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                       -- Translation from Localize.
                       translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                       -- If no english translation exist, and type is Basic Data, put prog text as translation.
                       IF ((lang_code_ = 'en') AND (sub_type_array_(rec_) = 'Basic Data') AND (translation_array_(rec_) IS NULL)) THEN
                          translation_array_(rec_) := prog_text_array_(rec_);
                       END IF;
                       IF (translation_array_(rec_) IS NOT NULL) THEN
                          IF ((sub_type_array_(rec_) = 'Column') OR (sub_type_array_(rec_) = 'View'))THEN
                             path_array_(rec_) := Rtrim(Substr(path_array_(rec_),Instr(path_array_(rec_),'.')+1));
                          END IF;
                          IF (sub_type_array_(rec_) = 'Basic Data') THEN
                             Basic_Data_Translation_API.Set_System_Translation(component_array_(rec_), path_array_(rec_), lang_code_, translation_array_(rec_));
                             basic_data_ := TRUE;
                          ELSE
                             ins_component_(ins_)              := component_array_(rec_);
                             IF (sub_type_array_(rec_) = 'Report Message') THEN
                                 ins_sub_type_(ins_)           := 'Message';
                             ELSE
                                 ins_sub_type_(ins_)               := sub_type_array_(rec_);
                             END IF;
                             ins_path_(ins_)                   := path_array_(rec_);
                             ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                             ins_translation_(ins_)            := translation_array_(rec_);
                             ins_bulk_(ins_)                   := bulk_array_(rec_);
                             ins_layer_(ins_)             := layer_array_(rec_);
                             ins_ := ins_+1;
                          END IF;
                       END IF;
                    END LOOP;
                    IF (ins_ > 1) THEN
                       Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                             lang_code_, ins_component_, ins_translation_, main_type_,
                                             ins_bulk_,ins_layer_);
                    END IF;
                 END IF;
                 EXIT WHEN generate_notIID___%NOTFOUND;
               END LOOP;
               CLOSE generate_notIID___;
               -- notIID
            END IF;
            
            IF (refresh_type_ IS NULL OR refresh_type_ = 'IID') THEN
               -- IID
               OPEN generate_IID___(component_,path_);
               LOOP
                 -- clear arrays
                 ins_component_.DELETE;
                 ins_translation_.DELETE;
                 ins_path_.DELETE;
                 ins_sub_type_.DELETE;
                 ins_attribute_name_.DELETE;
                 ins_bulk_.DELETE;
                 ins_layer_.DELETE;
                 ins_ := 1;

                 FETCH generate_IID___ BULK COLLECT
                    INTO component_array_,lu_array_,path_array_, sub_type_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                         bulk_array_ LIMIT fetch_limit_;
                 IF path_array_.count > 0 THEN
                    previous_lu_  := NULL;
                    FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                       -- Translation from Localize.
                       translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                       IF translation_array_(rec_) IS NULL THEN
                          translation_array_(rec_) := prog_text_array_(rec_);
                       END IF;
                       IF (translation_array_(rec_) IS NOT NULL) THEN
                          IF ((lu_array_(rec_) != previous_lu_) AND (previous_lu_ IS NOT NULL)) THEN
                             previous_path_ := Ltrim(Substr(previous_path_,0, Instr(previous_path_,'.')-1));
                             IF (previous_sub_type_ = 'State') THEN
                                attrib_type_ := 'State Values';
                             ELSE
                                attrib_type_ := 'Client Values';
                             END IF;
                             ins_component_(ins_)              := component_array_(rec_);
                             ins_sub_type_(ins_)               := 'Logical Unit';
                             ins_path_(ins_)                   := previous_path_;
                             ins_attribute_name_(ins_)         := attrib_type_;
                             ins_translation_(ins_)            := client_values_;
                             ins_bulk_(ins_)                   := 0;
                             ins_layer_(ins_)                  := NULL;
                             ins_ := ins_+1;

                             db_values_         := NULL;
                             client_values_     := NULL;
                          END IF;
                          ins_component_(ins_) := component_array_(rec_);
                          previous_lu_         := lu_array_(rec_);
                          db_values_           := db_values_||attribute_name_array_(rec_)||'^';
                          client_values_       := client_values_||translation_array_(rec_)||'^';
                          previous_path_       := path_array_(rec_);
                          previous_sub_type_   := sub_type_array_(rec_);
                       END IF;
                    END LOOP;
                    IF (client_values_ IS NOT NULL) THEN
                       previous_path_ := Ltrim(Substr(previous_path_,0, Instr(previous_path_,'.')-1));
                       IF (previous_sub_type_ = 'State') THEN
                          attrib_type_ := 'State Values';
                       ELSE
                          attrib_type_ := 'Client Values';
                       END IF;
                       ins_sub_type_(ins_)               := 'Logical Unit';
                       ins_path_(ins_)                   := previous_path_;
                       ins_attribute_name_(ins_)         := attrib_type_;
                       ins_translation_(ins_)            := client_values_;
                       ins_bulk_(ins_)                   := 0;
                       ins_layer_(ins_)                  := NULL;
                       ins_ := ins_+1;

                       db_values_         := NULL;
                       client_values_     := NULL;
                    END IF;
                    IF (ins_ > 1) THEN
                       Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                            lang_code_, ins_component_, ins_translation_, main_type_,
                                            ins_bulk_,ins_layer_);
                    END IF;
                 END IF;
                 EXIT WHEN generate_IID___%NOTFOUND;
               END LOOP;
               CLOSE generate_IID___;
               -- IID
            END IF;
            
            IF (refresh_type_ IS NULL OR refresh_type_ = 'Templates') THEN
               -- Templates
               IF (Database_Sys.Package_Exist('Enterp_Comp_Connect_V170_API')) THEN
                  OPEN generate_Templates___(component_,path_);
                  LOOP

                    FETCH generate_Templates___ BULK COLLECT
                     INTO component_array_, path_array_, sub_type_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                               bulk_array_ LIMIT fetch_limit_;

                    IF path_array_.count > 0 THEN
                       -- clear arrays
                       ins_component_.DELETE;
                       ins_translation_.DELETE;
                       ins_path_.DELETE;
                       ins_sub_type_.DELETE;
                       ins_attribute_name_.DELETE;
                       ins_bulk_.DELETE;
                       ins_ := 1;

                       FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                          delimeter_path_loc_ := instr(path_array_(rec_), delimeter_path_);
                          path_tmp_ := substr(path_array_(rec_),delimeter_path_loc_+1);
                          IF (template_id_ IS NULL OR template_id_ != substr(path_array_(rec_),1,delimeter_path_loc_-1)) THEN

                             IF (template_id_ IS NOT NULL) THEN
                                @ApproveDynamicStatement(2007-07-24,pemase)
                                EXECUTE IMMEDIATE stmt_refresh_templ_trans_ USING IN template_id_, IN component_array_(rec_), IN lang_code_;
                             END IF;

                             template_id_ := substr(path_array_(rec_),1,delimeter_path_loc_-1);
                             @ApproveDynamicStatement(2007-07-24,pemase)
                             EXECUTE IMMEDIATE stmt_init_templ_trans_ USING IN template_id_, IN component_array_(rec_), IN lang_code_;
                             template_data_ := TRUE;
                          END IF;
                          -- Translation from Localize.
                          translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                          -- If no english translation exist, put prog text as translation.
                          IF ((lang_code_ = 'en') AND (translation_array_(rec_) IS NULL)) THEN
                             translation_array_(rec_) := prog_text_array_(rec_);
                          END IF;
                          IF (translation_array_(rec_) IS NOT NULL) THEN
                             @ApproveDynamicStatement(2007-07-24,pemase)
                             EXECUTE IMMEDIATE stmt_insert_transl_exp_
                                USING IN template_id_||'^'||component_array_(rec_)||'^'||substr(path_tmp_,1,instr(path_tmp_,'_')-1)||'^'||
                                         substr(path_tmp_,instr(path_tmp_,delimeter_path_)+1)||'^'||lang_code_||'^'||translation_array_(rec_);
                          END IF;
                       END LOOP;
                    END IF;
                    EXIT WHEN generate_Templates___%NOTFOUND;
                  END LOOP;
                  IF (template_data_) THEN
                      @ApproveDynamicStatement(2007-07-24,pemase)
                      EXECUTE IMMEDIATE stmt_refresh_templ_trans_ USING IN template_id_, IN component_, IN lang_code_;
                  END IF;
                  CLOSE generate_Templates___;
               END IF;
               -- Templates
            END IF;
            
            
            IF (basic_data_) THEN
              Language_Sys.Cleanup_Basic_Data_Imp(component_,lang_code_);
              basic_data_ := FALSE;
            END IF;

         END IF;
         CLOSE check_mainType___;
      END IF;

      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'JAVA') THEN
         -- Web client
         main_type_ := 'JAVA';

         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;

         OPEN generate_Java___(component_,path_);

         LOOP
            FETCH generate_Java___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_Java___%NOTFOUND;
         END LOOP;
         CLOSE generate_Java___;
      END IF;
      
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'JAVA') THEN
         -- Business Intelligence
         main_type_  := 'BI';
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;         

         OPEN generate_BI___(component_,path_);

         LOOP
           FETCH generate_BI___ BULK COLLECT
              INTO component_array_, 
                   path_array_, 
                   sub_type_array_,
                   layer_array_,
                   attribute_id_array_, 
                   prog_text_array_, 
                   attribute_name_array_,
                   bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN NVL(path_array_.first, 0)..NVL(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), 
                                                                                   lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                 Insert_Translation___(error_messages_, 
                                       ins_sub_type_,
                                       ins_path_,
                                       ins_attribute_name_,
                                       lang_code_, 
                                       ins_component_, 
                                       ins_translation_, 
                                       main_type_,
                                       ins_bulk_,
                                       ins_layer_);
              END IF;
            END IF;   
            EXIT WHEN generate_BI___%NOTFOUND;
         END LOOP;

         CLOSE generate_BI___;
      END IF;

      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'WEBFW') THEN
         -- Web Framework
         main_type_ := 'WEBFW';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_Webfw___(component_,path_);

         LOOP
            FETCH generate_Webfw___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_Webfw___%NOTFOUND;
         END LOOP;
         CLOSE generate_Webfw___;         
                           
      END IF;
      
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'WEB') THEN
         -- Web Client
         main_type_ := 'WEB';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_Web___(component_,path_);

         LOOP
            FETCH generate_Web___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_Web___%NOTFOUND;
         END LOOP;
         CLOSE generate_Web___;         
                           
      END IF;
      
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'DBIDP') THEN
         -- Database Identity Provider
         main_type_ := 'DBIDP';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_ , path_);
         END IF;
         
         OPEN generate_DBIDP___(component_,path_);

         LOOP
            FETCH generate_DBIDP___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_DBIDP___%NOTFOUND;
         END LOOP;
         CLOSE generate_DBIDP___;         
                           
      END IF;
      
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'SVCFW') THEN
         -- Service Framework (ODATA Provider)
         main_type_ := 'SVCFW';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_SVCFW___(component_,path_);

         LOOP
            FETCH generate_SVCFW___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_SVCFW___%NOTFOUND;
         END LOOP;
         CLOSE generate_SVCFW___;         
                           
      END IF;
      
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'SP-BPA') THEN
         -- BPA 
         main_type_ := 'SP-BPA';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_BPA___(component_,path_);

         LOOP
            FETCH generate_BPA___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_BPA___%NOTFOUND;
         END LOOP;
         CLOSE generate_BPA___;         
                           
      END IF; 
      
	  IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'SVC') THEN
         -- Service (Projections)
         main_type_ := 'SVC';
         
      IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_SVC___(component_,path_);

         LOOP
            FETCH generate_SVC___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_SVC___%NOTFOUND;
         END LOOP;
         CLOSE generate_SVC___;         
                           
      END IF;
	   
      IF (refresh_main_type_ IS NULL OR refresh_main_type_ = 'MOBILE') THEN
         -- Mobile
         main_type_ := 'MOBILE';
         
         IF (refresh_type_ IS NULL) THEN
            Cleanup___(main_type_, lang_code_, component_,path_);
         END IF;
         
         OPEN generate_MOBILE___(component_,path_);

         LOOP
            FETCH generate_MOBILE___ BULK COLLECT
               INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                    bulk_array_ LIMIT fetch_limit_;
            IF path_array_.count > 0 THEN
              -- clear arrays
              ins_component_.DELETE;
              ins_translation_.DELETE;
              ins_path_.DELETE;
              ins_sub_type_.DELETE;
              ins_attribute_name_.DELETE;
              ins_bulk_.DELETE;
              ins_layer_.DELETE;
              ins_ := 1;

              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                 -- Translation from Localize.
                 translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 IF (translation_array_(rec_) IS NOT NULL) THEN
                    ins_component_(ins_)              := component_array_(rec_);
                    ins_sub_type_(ins_)               := sub_type_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                    ins_translation_(ins_)            := translation_array_(rec_);
                    ins_bulk_(ins_)                   := bulk_array_(rec_);
                    ins_path_(ins_)                   := path_array_(rec_);
                    ins_layer_(ins_)                  := layer_array_(rec_);
                    ins_ := ins_+1;
                 END IF;
              END LOOP;
              IF (ins_ > 1) THEN
                Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                     lang_code_, ins_component_, ins_translation_, main_type_,
                                     ins_bulk_,ins_layer_);
              END IF;
            END IF;
            EXIT WHEN generate_MOBILE___%NOTFOUND;
         END LOOP;
         CLOSE generate_MOBILE___;         
                           
      END IF;
      -- Activate the language as installed.
      Language_Installed_(lang_code_);

      IF (error_messages_ IS NOT NULL) THEN
         Error_SYS.Appl_General(service_, 'LANGREFRESHERROR: Error when refreshing component :P1 !', error_messages_);
      END IF;

   END Refresh_Language_Dict_;

   PROCEDURE Refresh_Language_Dict_AT_ (
   lang_code_         IN VARCHAR2,
   component_         IN VARCHAR2,
   refresh_main_type_ IN VARCHAR2 DEFAULT NULL,
   refresh_type_      IN VARCHAR2 DEFAULT NULL,
   path_              IN VARCHAR2 DEFAULT NULL)
   IS          
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      Refresh_Language_Dict_(lang_code_, component_, refresh_main_type_, refresh_type_,path_);
      @ApproveTransactionStatement(2013-11-14,haarse)
      COMMIT;
   END Refresh_Language_Dict_AT_; 

BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Refresh_Language_Dictionary_');
   -- If no lang_code given as input, run update for all records on all active languages.
   OPEN get_lang_code(lang_code_);
   FETCH get_lang_code BULK COLLECT INTO lang_code_arr_;
   CLOSE get_lang_code;

   -- If no component given as input, run update for all records on defined language code.
   OPEN get_component(component_);
   FETCH get_component BULK COLLECT INTO component_arr_;
   CLOSE get_component;
  
   FOR i IN Nvl(lang_code_arr_.FIRST,1)..Nvl(lang_code_arr_.LAST,-1) LOOP
      FOR j IN Nvl(component_arr_.FIRST,1)..Nvl(component_arr_.LAST,-1) LOOP
            IF (auto_transaction_ = 'TRUE') THEN
               Refresh_Language_Dict_AT_(lang_code_arr_(i), component_arr_(j), refresh_main_type_, refresh_type_,path_);
            ELSE
               BEGIN
                  IF (handle_db_transaction_ != 'TRUE') THEN
                     @ApproveTransactionStatement(2021-11-23,asbalk)
                     SAVEPOINT hdt_iteration_;
                  END IF;
                  
                  IF (refresh_main_type_ IS NULL) THEN
                     Transaction_SYS.Log_Progress_Info('Refreshing language ['||lang_code_arr_(i)||'] for component '||component_arr_(j));
                  END IF;
                  Refresh_Language_Dict_(lang_code_arr_(i), component_arr_(j), refresh_main_type_, refresh_type_,path_);
                  
                  IF (handle_db_transaction_ = 'TRUE') THEN
                     @ApproveTransactionStatement(2013-11-14,haarse)
                     COMMIT;
                  END IF;
                  IF (refresh_main_type_ IS NULL) THEN
                     Transaction_SYS.Log_Status_Info('Runtime repository for component '||component_arr_(j)||' language code ['||lang_code_arr_(i)||'] refreshed '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
                  END IF;
               EXCEPTION
               -- In case of unexpected error, continue with next file.
                  WHEN OTHERS THEN
                     IF (handle_db_transaction_ = 'TRUE') THEN
                        @ApproveTransactionStatement(2013-11-14,haarse)
                        ROLLBACK;
                     ELSIF (handle_db_transaction_ != 'TRUE') THEN
                        @ApproveTransactionStatement(2021-11-23,asbalk)
                        ROLLBACK TO SAVEPOINT hdt_iteration_;
                     END IF;
                     Transaction_SYS.Log_Status_Info('Unexpected error when refreshing component '||component_arr_(j)||' language code ['||lang_code_arr_(i)||'] Error: '||sqlerrm, 'WARNING');
                     warning_ := TRUE;
               END;
            END IF;

            IF (refresh_main_type_ IS NULL OR refresh_main_type_ IN ('CONFIGLU','CONFIGCLIENT')) THEN
               Refresh_Custom_Obj_Lang_Dict_(component_arr_(j),lang_code_arr_(i),NULL, auto_transaction_, handle_db_transaction_);
            END IF;
      END LOOP;
   END LOOP;
   IF (auto_transaction_ != 'TRUE') THEN
      IF (warning_) THEN
         Transaction_SYS.Log_Progress_Info('Unexpected error when refreshing languages, check detail log' );
      END IF;
   END IF;
   
   -- Added call to Domain_SYS to changed IIDs updated
   -- No need to refresh when importing a Term
   IF refresh_domain_ = 'TRUE' THEN
      IF component_ IS NOT NULL THEN
         Domain_SYS.Refresh_Component_Language_ (component_);
         Transaction_SYS.Log_Status_Info('Refreshed IID and State values of '||component_||' '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
      ELSE
         -- Refresh All
         Domain_SYS.Refresh_Language_;
         Transaction_SYS.Log_Status_Info('Refreshed all IID and State values '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
      END IF;
   END IF;
END Refresh_Language_Dictionary_;

PROCEDURE Refresh_Custom_Obj_Lang_Dict_ (
   component_             IN VARCHAR2,
   lang_code_             IN VARCHAR2 DEFAULT NULL,
   parent_path_           IN VARCHAR2 DEFAULT NULL,
   auto_transaction_      IN VARCHAR2 DEFAULT 'TRUE',
   handle_db_transaction_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   TYPE a10_array IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
   lang_code_arr_ a10_array;   
   warning_       BOOLEAN := FALSE;
   
   CURSOR get_lang_code (lang_code_ VARCHAR2) IS
      SELECT lang_code
      FROM   language_code_tab
      WHERE  lang_code = decode(lang_code_,null,lang_code,lang_code_)
      AND    status = 'A'
      UNION
      SELECT decode(lang_code_,null,'en',lang_code_) FROM dual;
           
   PROCEDURE Refresh_Language_Dict__(
      component_        IN VARCHAR2,
      lang_code_        IN VARCHAR2,
      main_type_        IN VARCHAR2,
      parent_path_      IN VARCHAR2 DEFAULT NULL)
   IS
      
      dummy_                        NUMBER;
      
      component_array_              a200_array;
      path_array_                   a2000_array;
      sub_type_array_               a200_array;
      layer_array_                  a200_array;
      attribute_id_array_           number_array;
      prog_text_array_              a4000_array;
      attribute_name_array_         a200_array;
      translation_array_            a4000_array;
      bulk_array_                   number_array;
   
      ins_                          NUMBER;
      ins_component_                a200_array;
      ins_path_                     a2000_array;
      ins_sub_type_                 a200_array;
      ins_layer_                    a200_array;
      ins_attribute_name_           a200_array;   
      ins_translation_              a4000_array;
      ins_bulk_                     number_array;
      error_messages_               VARCHAR2(4000);
   
      fetch_limit_                  NUMBER := 2000;
      path_param_                   VARCHAR2(2000);
      views_array_                  Utility_SYS.STRING_TABLE;
      view_list_                    VARCHAR2(4000);
      count_                        NUMBER;

      CURSOR check_mainType___ (component_ VARCHAR2, main_type_ VARCHAR2) IS
         SELECT 1
         FROM   language_context_tab ctx
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = main_type_;
   
      CURSOR generate_custom_object___(component_ VARCHAR2,main_type_ VARCHAR2) IS
         SELECT ctx.module,
                ctx.path, 
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id, 
                atr.prog_text,
                atr.name,
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = main_type_
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y'
         ORDER BY ctx.path ASC;
      
      CURSOR generate_cust_obj_by_parent___(component_ VARCHAR2,main_type_ VARCHAR2,path_param_ VARCHAR2) IS
         SELECT ctx.module,
                ctx.path,
                ctx.sub_type,
                ctx.layer,
                atr.attribute_id,
                atr.prog_text,
                atr.name,
                NVL(ctx.bulk,0)
         FROM   language_context_tab ctx,
                language_attribute_tab atr
         WHERE  ctx.module = component_
         AND    ctx.obsolete <> 'Y'
         AND    ctx.main_type = main_type_
         AND    (ctx.path like path_param_ OR ctx.path = parent_path_)
         AND    ctx.context_id = atr.context_id
         AND    atr.obsolete <> 'Y'
         ORDER BY ctx.path ASC;
   BEGIN
      path_param_:=concat(parent_path_,'.%');

      IF (main_type_ = 'CONFIGLU') THEN
         Dictionary_SYS.Get_Logical_Unit_Views__(parent_path_, view_list_);
         Utility_SYS.Tokenize(view_list_, Client_SYS.field_separator_, views_array_, count_);
      END IF;
      
      -- Cleanup will be done for configclient only, configlu cleanup performs when running Refresh_Language_Dictionary_
      IF (main_type_ = 'CONFIGCLIENT') THEN
         Cleanup___(main_type_, lang_code_, component_, parent_path_);
      END IF;
   
      OPEN check_mainType___(component_, main_type_);
      FETCH check_mainType___ INTO dummy_;
      IF (check_mainType___%FOUND) THEN
         IF parent_path_ IS NOT NULL THEN
            OPEN generate_cust_obj_by_parent___(component_,main_type_,path_param_);
         ELSE
            OPEN generate_custom_object___(component_,main_type_);
         END IF;
         LOOP
            IF parent_path_ IS NOT NULL THEN
               FETCH generate_cust_obj_by_parent___ BULK COLLECT
                  INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                       bulk_array_ LIMIT fetch_limit_;
            ELSE
               FETCH generate_custom_object___ BULK COLLECT
                  INTO component_array_, path_array_, sub_type_array_,layer_array_, attribute_id_array_, prog_text_array_, attribute_name_array_,
                       bulk_array_ LIMIT fetch_limit_;
            END IF;
            IF path_array_.count > 0 THEN
               -- clear arrays
               ins_component_.DELETE;
               ins_translation_.DELETE;
               ins_path_.DELETE;
               ins_sub_type_.DELETE;
               ins_attribute_name_.DELETE;
               ins_bulk_.DELETE;
               ins_layer_.DELETE;
               ins_ := 1;
               FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP
                  -- Translation from Localize.
                  translation_array_(rec_) := Language_Translation_API.Get_Text(attribute_id_array_(rec_), lang_code_);
                 -- Here remove the LuName from path.
                  IF ((sub_type_array_(rec_) = 'Column') OR (sub_type_array_(rec_) = 'View'))THEN
                     path_array_(rec_) := Rtrim(Substr(path_array_(rec_),Instr(path_array_(rec_),'.', -1)+1));
                  END IF;
            
                  IF (translation_array_(rec_) IS NOT NULL) THEN
                     -- Iterate over all views for LU and create one translation row for each view.
                     IF ((views_array_.count > 0) AND (sub_type_array_(rec_) <> 'Logical Unit')) THEN 
                        FOR i IN Nvl(views_array_.First, 0)..Nvl(views_array_.Last, -1) LOOP
                           ins_component_(ins_)              := component_array_(rec_);
                           ins_sub_type_(ins_)               := sub_type_array_(rec_);
                           --ins_path_(ins_)                   := path_array_(rec_);
                           ins_path_(ins_)                   := views_array_(i)||'.'||path_array_(rec_);
                           ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                           ins_translation_(ins_)            := translation_array_(rec_);
                           ins_bulk_(ins_)                   := bulk_array_(rec_);
                           ins_layer_(ins_)                  := layer_array_(rec_);
                           ins_ := ins_+1; 
                        END LOOP;
                     ELSE
                        ins_component_(ins_)              := component_array_(rec_);
                        ins_sub_type_(ins_)               := sub_type_array_(rec_);
                        ins_path_(ins_)                   := path_array_(rec_);
                        ins_attribute_name_(ins_)         := attribute_name_array_(rec_);
                        ins_translation_(ins_)            := translation_array_(rec_);
                        ins_bulk_(ins_)                   := bulk_array_(rec_);
                        ins_layer_(ins_)                  := layer_array_(rec_);
                        ins_ := ins_+1; 
                     END IF;
                  END IF;
               END LOOP;
               IF (ins_ > 1) THEN
                  -- Translations with main_type CONFIGLU should have maintype LU in language_sys_tab, by doing that
                  -- the server framework will work also for config.
                  IF main_type_ = 'CONFIGLU' THEN
                     Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                           lang_code_, ins_component_, ins_translation_, 'LU',
                                           ins_bulk_,ins_layer_);
                  ELSE
                     Insert_Translation___(error_messages_, ins_sub_type_,ins_path_,ins_attribute_name_,
                                        lang_code_, ins_component_, ins_translation_, main_type_,
                                        ins_bulk_,ins_layer_);
                     
                  END IF;
               END IF;
            END IF;
            IF parent_path_ IS NOT NULL THEN
               EXIT WHEN generate_cust_obj_by_parent___%NOTFOUND;
            ELSE
               EXIT WHEN generate_custom_object___%NOTFOUND;
            END IF; 
         END LOOP;  
         IF parent_path_ IS NOT NULL THEN
            CLOSE generate_cust_obj_by_parent___;
         ELSE
            CLOSE generate_custom_object___;
         END IF;
      
      END IF;
      IF (error_messages_ IS NOT NULL) THEN
         Error_SYS.Appl_General(service_, 'LANGREFRESHERROR: Error when refreshing component :P1 !', error_messages_);
      END IF;  
   END Refresh_Language_Dict__; 
   
   PROCEDURE Refresh_Language_Dict_(
      component_        IN VARCHAR2,
      lang_code_        IN VARCHAR2,
      parent_path_      IN VARCHAR2 DEFAULT NULL)
   IS
      main_type_   language_sys_tab.main_type%TYPE;
   
      CURSOR get_lu IS
      SELECT distinct(path) path
      FROM   language_context_tab
      WHERE  module = component_
      AND    obsolete <> 'Y'
      AND    main_type = main_type_
      and    sub_type = 'Logical Unit'
      ORDER BY path ASC;
   BEGIN
      -- ConfigLu
      main_type_:='CONFIGLU';
      IF parent_path_ IS NULL THEN 
         FOR rec_lu_ IN get_lu LOOP
            Refresh_Language_Dict__(component_,lang_code_,main_type_, rec_lu_.path);
         END LOOP;
      ELSE
         Refresh_Language_Dict__(component_,lang_code_,main_type_, parent_path_);
      END IF;
      
      -- ConfigClient
      main_type_:='CONFIGCLIENT';
      Refresh_Language_Dict__(component_,lang_code_,main_type_, parent_path_);
      
   END Refresh_Language_Dict_;
      
   PROCEDURE Refresh_Language_Dict_AT_ (
      component_   IN VARCHAR2,
      lang_code_   IN VARCHAR2,    
      parent_path_ IN VARCHAR2 DEFAULT NULL)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      Refresh_Language_Dict_(component_, lang_code_, parent_path_);
      @ApproveTransactionStatement(2014-11-07,pganlk)
      COMMIT;
   END Refresh_Language_Dict_AT_;

BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Refresh_Custom_Obj_Lang_Dict_');
   -- If no lang_code given as input, run update for all records on all active languages.
   OPEN get_lang_code(lang_code_);
   FETCH get_lang_code BULK COLLECT INTO lang_code_arr_;
   CLOSE get_lang_code;

   FOR i IN Nvl(lang_code_arr_.FIRST,1)..Nvl(lang_code_arr_.LAST,-1) LOOP
      IF (auto_transaction_ = 'TRUE') THEN
            Refresh_Language_Dict_AT_(component_,lang_code_arr_(i), parent_path_);
      ELSE
         BEGIN
            IF (handle_db_transaction_ != 'TRUE') THEN
               @ApproveTransactionStatement(2021-11-23,asbalk)
               SAVEPOINT hdt_iteration_;
            END IF;
            
            Refresh_Language_Dict_(component_,lang_code_arr_(i));
            
            IF (handle_db_transaction_ = 'TRUE') THEN
               @ApproveTransactionStatement(2014-11-07,pganlk)
               COMMIT;
            END IF;
         EXCEPTION
         -- In case of unexpected error, continue with next file.
            WHEN OTHERS THEN
               IF (handle_db_transaction_ = 'TRUE') THEN
                  @ApproveTransactionStatement(2014-11-07,pganlk)
                  ROLLBACK;
               ELSIF (handle_db_transaction_ != 'TRUE') THEN
                  @ApproveTransactionStatement(2021-11-23,asbalk)
                  ROLLBACK TO SAVEPOINT hdt_iteration_;
               END IF;
               Transaction_SYS.Log_Status_Info('Unexpected error when refreshing component '||component_||' language code ['||lang_code_arr_(i)||'] Error: '||sqlerrm, 'WARNING');
               warning_ := TRUE;
         END;
      END IF;
   END LOOP;
   
   IF (auto_transaction_ != 'TRUE') THEN
      IF (warning_) THEN
         Transaction_SYS.Log_Progress_Info('Unexpected error when refreshing languages, check detail log' );
      END IF;
   END IF;
END Refresh_Custom_Obj_Lang_Dict_;

PROCEDURE Bulk_Import_Batch_ (
   task_id_   IN  VARCHAR2,
   refresh_   IN  VARCHAR2 DEFAULT 'FALSE' )
IS
   attr_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Batch_');
   Client_SYS.Add_To_Attr('TASK_ID', task_id_, attr_);
   Client_SYS.Add_To_Attr('REFRESH', refresh_, attr_);
   Transaction_SYS.Deferred_Call('Language_SYS.Bulk_Import_Def_Call_', attr_, 'Bulk Import of Language Files');
--   Language_SYS.Bulk_Import_Def_Call_(attr_);
END Bulk_Import_Batch_;

PROCEDURE Bulk_Import_Batch_With_Job_Id_ (
   job_id_    OUT NUMBER,                         
   task_id_   IN  VARCHAR2,
   refresh_   IN  VARCHAR2 DEFAULT 'FALSE' )
IS
   attr_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Batch_With_Job_Id_');
   Client_SYS.Add_To_Attr('TASK_ID', task_id_, attr_);
   Client_SYS.Add_To_Attr('REFRESH', refresh_, attr_);
   Transaction_SYS.Deferred_Call( job_id_,'Language_SYS.Bulk_Import_Def_Call_', 'ATTRIBUTE',attr_,'Bulk Import of Language Files',sysdate,'FALSE',NULL); 
   
END Bulk_Import_Batch_With_Job_Id_;

PROCEDURE Bulk_Import_Def_Call_ (
   attr_ IN VARCHAR2 )
IS
   task_id_   VARCHAR2(100);
   refresh_   VARCHAR2(5);

   component_ VARCHAR2(10);
   lang_code_ language_code_tab.lang_code%TYPE;
   main_type_ language_context_tab.main_type%TYPE;
   sub_type_  language_context_tab.sub_type%TYPE;
   layer_     language_context_tab.layer%TYPE;
   version_      VARCHAR2(5)  := '';
   version_100_  VARCHAR2(5)  := '1.00';
   version_1000_ VARCHAR2(5)  := '10.00';
   context_   NUMBER;
   attribute_ NUMBER;

   ptr_       NUMBER;
   name_      VARCHAR2(30);
   value_     VARCHAR2(2000);

   TYPE a400_array IS TABLE OF VARCHAR2(400) INDEX BY BINARY_INTEGER;
   TYPE date_array IS TABLE OF DATE INDEX BY BINARY_INTEGER;

   TYPE comp_lang_list IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(10);
   comp_lang_list_ comp_lang_list;
   TYPE comp_list IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(10);
   comp_list_ comp_list;
   TYPE comp_iid_list IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(10);
   comp_iid_list_ comp_iid_list;
   
   file_names_     a400_array;
   file_dates_     date_array;
   file_ids_       a400_array;
   import_file_   CLOB;

   lang_list_     VARCHAR2(1000);
   complang_      VARCHAR2(1000);
   warning_       BOOLEAN := FALSE;

   temp_files_    NUMBER;
   count_files_   NUMBER:=0;
   
   dummy_         NUMBER;
   first_install_ VARCHAR2(5) := 'FALSE';
   trans_exist_   NUMBER:=0;

   skip_main_types_ VARCHAR2(100) := 'VC^VB^MOBILE^';
   
   CURSOR Count_File_ (task_id_ VARCHAR2, type_ VARCHAR2, processed_ NUMBER) IS
      SELECT count(*)
      FROM   language_file_import_tab
      WHERE  task_id = task_id_
      AND    processed = processed_
      AND    substr(file_name,length(file_name)-3) = decode(type_,NULL,substr(file_name,length(file_name)-3),type_);
   
   CURSOR Count_Component IS
      SELECT count(*)
      FROM   module_tab
      WHERE NVL(version, '*') != '*';
   
   CURSOR Get_File_ (task_id_ VARCHAR2, type_ VARCHAR2, processed_ NUMBER) IS
      SELECT file_name, file_date, file_id
      FROM   language_file_import_tab
      WHERE  task_id = task_id_
      AND    processed = decode(processed_, NULL, processed, processed_)
      AND    substr(file_name,length(file_name)-3) = decode(type_,NULL,substr(file_name,length(file_name)-3),type_)
      ORDER BY upper(file_name);

--   CURSOR Get_File_Date_ (component_ VARCHAR2, name_ VARCHAR2, main_type_ VARCHAR2) IS
--      SELECT file_date
--      FROM  language_source_tab
--      WHERE module = component_
--      AND   upper(name) = upper(name_)
--      AND   main_type = main_type_;

   CURSOR Get_Languages IS
      SELECT lang_code
      FROM   language_code_tab
      WHERE  installed='TRUE'
      UNION
      SELECT 'en' FROM DUAL;

   CURSOR Check_If_Fresh_ IS
      SELECT 0
      FROM   language_context_tab
      WHERE  rownum = 1;

   CURSOR Check_If_Trans_Exist_ (component_ VARCHAR2, layer_ VARCHAR2, main_type_ VARCHAR2) IS
      SELECT count(*)
      FROM   language_context_tab c,
             language_attribute_tab a,
             language_translation_tab t
      WHERE  c.context_id = a.context_id
      AND    c.module = component_
      AND    c.layer = layer_
      AND    c.main_type = main_type_
      AND    a.attribute_id = t.attribute_id
      AND    t.lang_code = 'en'
      AND    rownum = 1;

   PROCEDURE Get_Keys_ (
      clob_    IN CLOB,
      row_amt_ IN NUMBER,
      file_ext_ IN VARCHAR2 )
   IS
      pos_              NUMBER;
      line_             VARCHAR2(32000);
      row_no_           NUMBER;
      start_pos_        NUMBER := 1;
      separator_        VARCHAR2(2) :=chr(13)||chr(10);
      delimeter_key_    VARCHAR2(1) := ':';
   BEGIN
      component_ := NULL;
      lang_code_ := NULL;
      main_type_ := NULL;
      -- Find correct separator
      pos_ := nvl(dbms_lob.instr(clob_,separator_,start_pos_),0);
      IF (pos_ = 0) THEN
         separator_ := chr(10);
         pos_ := nvl(dbms_lob.instr(clob_,separator_,start_pos_),0);
      END IF;
      row_no_ := 1;
      -- Find correct row
      WHILE (pos_ > 0 AND row_no_ <= row_amt_) LOOP
         start_pos_ := pos_+length(separator_);
         pos_ := dbms_lob.instr(clob_,separator_,start_pos_);
         IF (row_no_ = 2) THEN
            -- Analyze row for version
            line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
            IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Type version') THEN
               version_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
            END IF;
         END IF;
         IF (row_no_ = 4) THEN
            -- Analyze row for component name
            line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
            IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Module') THEN
               component_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
            END IF;
         END IF;
         IF (file_ext_ = 'TRS') THEN
            IF (row_no_ = 5) THEN
               -- Analyze row for language_code name
               line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
               IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Language') THEN
                  lang_code_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
               END IF;
            END IF;
            IF ((version_ = version_100_ AND row_no_ = 9) OR (version_ = version_1000_ AND row_no_ = 8)) THEN
               -- Analyze row for main type
               line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
               IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Main Type') THEN
                  main_type_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
               END IF;
            END IF; 
         END IF;
         IF (file_ext_ = 'LNG' AND version_ = version_1000_) THEN
            IF (row_no_ = 5) THEN
               -- Analyze row for layer
               line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
               IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Layer') THEN
                  layer_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
               END IF;
            END IF;            
            IF (row_no_ = 6) THEN
               -- Analyze row for main type
               line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
               IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Main Type') THEN
                  main_type_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
               END IF;
            END IF;
            IF (row_no_ = 7) THEN
               -- Analyze row for sub type
               line_ := ltrim(dbms_lob.substr(clob_,pos_-start_pos_,start_pos_),chr(9));
               IF (substr(line_, 1, instr(line_, delimeter_key_)-1) = 'Sub Type') THEN
                  sub_type_ := ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
               END IF;
            END IF;
         END IF;
         row_no_ := row_no_ + 1;
      END LOOP;
   END Get_Keys_;

BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Def_Call_');

   OPEN Check_If_Fresh_;
   FETCH Check_If_Fresh_ INTO dummy_;
   IF (Check_If_Fresh_%FOUND) THEN
      first_install_ := 'FALSE';
   ELSE
      first_install_ := 'TRUE';
   END IF;
   CLOSE Check_If_Fresh_;
   -- CleanUp table for already processed rows, if previous job failed.
   DELETE
   FROM  language_file_import_tab
   WHERE processed = 2;
   -- CleanUp table for failed jobs where the header is deleted.
   DELETE
   FROM language_file_import_tab l
   WHERE NOT EXISTS (
   SELECT 1
   FROM transaction_sys_local_tab
   WHERE procedure_name = 'Language_Sys.Bulk_Import_Def_Call_'
   AND INSTR(arguments_string, l.task_id) > 0);

   ptr_       := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TASK_ID') THEN
         task_id_ := value_;
      ELSIF (name_ = 'REFRESH') THEN
         refresh_ := value_;
      END IF;
   END LOOP;

   IF (task_id_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'EMPTYTASK: EMPTY task id !');
   END IF;

   IF (first_install_ = 'TRUE') THEN
      count_files_ := 1; -- 1 because the analyze of tables
   END IF;
   OPEN Count_File_(task_id_, '.lng', 0);
   FETCH Count_File_ INTO temp_files_;
   CLOSE Count_File_;
   count_files_ := count_files_ + temp_files_;
   OPEN Count_File_(task_id_, '.trs', 0);
   FETCH Count_File_ INTO temp_files_;
   CLOSE Count_File_;
   count_files_ := count_files_ + temp_files_;
   IF (upper(refresh_) = 'TRUE') THEN
      OPEN Get_File_(task_id_, '.trs' , 0);
      FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
      CLOSE Get_File_;

      FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
         BEGIN
            SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
            component_ := NULL;
            lang_code_ := NULL;
            main_type_ := NULL;
            Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 9, 'TRS');
            IF (component_ IS NOT NULL AND lang_code_ IS NOT NULL) THEN
               IF (instr(skip_main_types_, upper(main_type_||'^')) < 1) THEN
--                  file_date_ := NULL;
--                  OPEN Get_File_Date_(component_, file_names_(i), 'TF');
--                  FETCH Get_File_Date_ INTO file_date_;
--                  CLOSE Get_File_Date_;
--                  IF (file_date_ IS NULL OR file_date_ < file_dates_(i))THEN
                     comp_lang_list_(lang_code_||'^'||component_) := 'TRUE';                     
                     comp_list_(component_) := 'TRUE';
--                  END IF;
               END IF;
            END IF;
         END;
      END LOOP;

      -- 1)
      -- When English translations exist for specific component, main_type, sub_type, then 'English' has to be refreshed. 
      -- Scenario can be that PROG text is changed in LNG which results in that the existing English translation will be removed.
      -- Therefore the runtime table has to be refreshed, to ensure correct data.

      -- 2)
      -- If the imported lng files main_type is 'LU' and Sub Type is 'Basic Data' or 'Company Template' then the component should
      -- be refreshed for language 'English'. If translations doesn't exist, the PROG text should be set at English translation.
      -- This logic maybe will be changed, the insert of PROG will also always insert a post of 'English' as default.
      -- If that is the case, then only 1) scenario will remain, and this logic can be removed.
      OPEN Get_File_(task_id_, '.lng' , 0);
      FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
      CLOSE Get_File_;

      FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
         BEGIN
            SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
            component_ := NULL;
            layer_ := NULL;
            main_type_ := NULL;
            sub_type_ := NULL;
            Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 9, 'LNG');
            IF (component_ IS NOT NULL AND main_type_ IS NOT NULL AND version_ = version_1000_) THEN
               IF (instr(skip_main_types_, upper(main_type_||'^')) < 1) THEN
--                  file_date_ := NULL;
--                  OPEN Get_File_Date_(component_, file_names_(i), 'LF');
--                  FETCH Get_File_Date_ INTO file_date_;
--                  CLOSE Get_File_Date_;
--                  IF (file_date_ IS NULL OR file_date_ < file_dates_(i))THEN
                     IF (main_type_ = 'LU' AND sub_type_ IN ('Basic Data','Company Template')) THEN
                        comp_lang_list_('en^'||component_) := 'TRUE';                     
                        comp_list_(component_) := 'TRUE';
                     ELSIF (main_type_ = 'LU' AND sub_type_ = 'Logical Unit') THEN
                        comp_list_(component_) := 'TRUE';
                        comp_iid_list_(component_) := 'TRUE';
                     END IF;
                     IF NOT comp_lang_list_.EXISTS('en^'||component_) THEN
                        trans_exist_ := 0;
                        OPEN Check_If_Trans_Exist_(component_, layer_, main_type_);
                        FETCH Check_If_Trans_Exist_ INTO trans_exist_;
                        CLOSE Check_If_Trans_Exist_;
                        IF (trans_exist_ = 1) THEN
                           comp_lang_list_('en^'||component_) := 'TRUE';                     
                           comp_list_(component_) := 'TRUE';
                        END IF;
                     END IF;
--                  END IF;
               END IF;
            END IF;
         END;
      END LOOP;

      count_files_ := count_files_ + comp_lang_list_.COUNT + comp_list_.COUNT;

   ELSIF (upper(refresh_) = 'ALL') THEN
      count_files_ := count_files_ + 1; -- Domain_SYS.Refresh_Language_
      FOR lang IN Get_Languages LOOP
         lang_list_ := lang_list_ || lang.lang_code||',';
      END LOOP;

      OPEN Get_File_(task_id_, '.trs' , NULL);
      FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
      CLOSE Get_File_;

      FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
         BEGIN
            SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
            component_ := NULL;
            lang_code_ := NULL;
            main_type_ := NULL;
            Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 9, 'TRS');
            IF (component_ IS NOT NULL AND instr(skip_main_types_, upper(main_type_||'^')) < 1) THEN
--               file_date_ := NULL;
--               OPEN Get_File_Date_(component_, file_names_(i), 'TF');
--               FETCH Get_File_Date_ INTO file_date_;
--               CLOSE Get_File_Date_;
--               IF (file_date_ IS NULL OR file_date_ < file_dates_(i))THEN
                  IF (lang_code_ IS NOT NULL AND instr(lang_list_,lang_code_||',') < 1) THEN
                     lang_list_ := lang_list_ || lang_code_||',';
                  END IF;
--               END IF;
            END IF;
         END;
      END LOOP;
      OPEN Count_Component;
      FETCH Count_Component INTO temp_files_;
      CLOSE Count_Component;
      count_files_ := count_files_ + ((LENGTH(lang_list_) - LENGTH(REPLACE(lang_list_, ','))) * temp_files_);
   END IF;
   Transaction_SYS.Update_Total_Work(Transaction_SYS.Get_Current_Job_Id, count_files_);
   @ApproveTransactionStatement(2013-11-14,haarse)
   COMMIT;

   OPEN Get_File_(task_id_, '.lng', 0);
   FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
   CLOSE Get_File_;

   FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
      BEGIN
         SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
         component_ := NULL;
         Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 4, 'LNG');
         IF (component_ IS NOT NULL) THEN
--            file_date_ := NULL;
--            OPEN Get_File_Date_(component_, file_names_(i), 'LF');
--            FETCH Get_File_Date_ INTO file_date_;
--            CLOSE Get_File_Date_;
--            IF (file_date_ IS NULL OR file_date_ < file_dates_(i))THEN
               Transaction_SYS.Log_Progress_Info('Processing file '||file_names_(i));
               Bulk_Import_Lng_ (context_, attribute_, import_file_, file_names_(i), file_dates_(i));
               UPDATE language_file_import_tab
                SET   processed=1
                WHERE file_id=file_ids_(i);
               Transaction_SYS.Log_Status_Info('File '||file_names_(i)||' processed. Context: '||context_||' Attribute: '||attribute_||'. '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
--            ELSE
--               --
--               Transaction_SYS.Log_Progress_Longop;
--               UPDATE language_file_import_tab
--               SET   processed=2
--               WHERE file_id=file_ids_(i);
--               Transaction_SYS.Log_Status_Info('Skipped '||file_names_(i)||'. Older file date.', 'INFO');
--            END IF;
            @ApproveTransactionStatement(2013-11-14,haarse)
            COMMIT;
         END IF;
      EXCEPTION
      -- In case of unexpected error, continue with next file.
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2013-11-14,haarse)
            ROLLBACK;
            Transaction_SYS.Log_Status_Info('Unexpected error when processing file '||file_names_(i)||'. Error: '||sqlerrm, 'WARNING');
            warning_ := TRUE;
      END;
   END LOOP;

   OPEN Get_File_(task_id_, '.trs', 0);
   FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
   CLOSE Get_File_;

   FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
      BEGIN
         SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
         component_ := NULL;
         lang_code_ := NULL;
         Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 5, 'TRS');
         IF (component_ IS NOT NULL) THEN
--            file_date_ := NULL;
--            OPEN Get_File_Date_(component_, file_names_(i), 'TF');
--            FETCH Get_File_Date_ INTO file_date_;
--            CLOSE Get_File_Date_;
--            IF (file_date_ IS NULL OR file_date_ < file_dates_(i))THEN
               Transaction_SYS.Log_Progress_Info('Processing file '||file_names_(i));
               Bulk_Import_Trs_ (context_, attribute_, import_file_, file_names_(i), file_dates_(i));
               UPDATE language_file_import_tab
                SET   processed=1
                WHERE file_id=file_ids_(i);
               Transaction_SYS.Log_Status_Info('File '||file_names_(i)||' processed. Context: '||context_||' Attribute: '||attribute_||'. '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
--            ELSE
--               Transaction_SYS.Log_Progress_Longop;
--               UPDATE language_file_import_tab
--                SET   processed=2
--                WHERE file_id=file_ids_(i);
--               Transaction_SYS.Log_Status_Info('Skipped '||file_names_(i)||'. Older file date.', 'INFO');
--            END IF;
            @ApproveTransactionStatement(2013-11-14,haarse)
            COMMIT;
         END IF;
      EXCEPTION
      -- In case of unexpected error, continue with next file.
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2013-11-14,haarse)
            ROLLBACK;
            Transaction_SYS.Log_Status_Info('Unexpected error when processing file '||file_names_(i)||'. Error: '||sqlerrm, 'WARNING');
            warning_ := TRUE;
      END;
   END LOOP;

   IF (first_install_ = 'TRUE') THEN
      Transaction_SYS.Log_Progress_Info('Analyzing language tables');
      -- Refresh table to speed up the process, needed in fresh installation. 
      BEGIN
         -- Localize tables
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'LANGUAGE_CONTEXT_TAB', cascade_ => 'TRUE');
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'LANGUAGE_ATTRIBUTE_TAB', cascade_ => 'TRUE');
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'LANGUAGE_TRANSLATION_TAB', cascade_ => 'TRUE');
         -- Basic data
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'LANGUAGE_SYS_IMP_TAB', cascade_ => 'TRUE');
         -- Runtime language table
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'LANGUAGE_SYS_TAB', cascade_ => 'TRUE');
         -- Company template PROG data
         Database_Sys.Analyze_Object(schema_ => Fnd_Session_API.Get_App_Owner, object_name_ => 'KEY_LU_TRANSLATION_TAB', cascade_ => 'TRUE');
      EXCEPTION
         WHEN OTHERS THEN
            Transaction_SYS.Log_Status_Info('Unexpected error when gathering statistics.'||' Error: '||sqlerrm, 'WARNING');
            warning_ := TRUE;
      END;

      Transaction_SYS.Log_Status_Info('Analyzing language tables. '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
   END IF;
   
   IF (upper(refresh_) = 'TRUE') THEN
      OPEN Get_File_(task_id_, NULL , 1);
      FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
      CLOSE Get_File_;

      FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
         UPDATE language_file_import_tab
             SET   processed=2
             WHERE file_id=file_ids_(i);
      END LOOP;
      
      complang_  := NULL;
      lang_code_ := NULL;
      component_ := NULL;
      IF (comp_lang_list_.COUNT > 0) THEN
         complang_ := comp_lang_list_.FIRST;
         WHILE complang_ IS NOT NULL LOOP
            lang_code_ := substr(complang_,1, instr(complang_,'^')-1);
            component_ := substr(complang_,instr(complang_,'^')+1);
            Refresh_Language_Dictionary_ (lang_code_, component_, 'FALSE', 'FALSE');
            @ApproveTransactionStatement(2013-11-14,haarse)
            COMMIT;
            complang_ := comp_lang_list_.NEXT(complang_);
         END LOOP;
      END IF;
      IF (comp_list_.COUNT > 0) THEN
         component_ := comp_list_.FIRST;
         WHILE component_ IS NOT NULL LOOP
            Transaction_SYS.Log_Progress_Info('Refreshing IID and State values of '||component_);
            IF comp_iid_list_.EXISTS(component_) THEN
               FOR lang IN Get_Languages LOOP
                  IF NOT comp_lang_list_.EXISTS(lang.lang_code||'^'||component_) THEN
                     Refresh_Language_Dictionary_ (lang.lang_code, component_, 'FALSE', 'FALSE','LU','IID');
                  END IF;
               END LOOP;               
            END IF;
            Domain_SYS.Refresh_Component_Language_ (component_);
            Transaction_SYS.Log_Status_Info('Refreshed IID and State values of '||component_||' '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
            component_ := comp_list_.NEXT(component_);
         END LOOP;
      END IF;      
   END IF;

   IF (upper(refresh_) = 'ALL') THEN
      lang_list_ := NULL;
      FOR lang IN Get_Languages LOOP
         lang_list_ := lang_list_ || lang.lang_code||',';
      END LOOP;

      OPEN Get_File_(task_id_, '.trs' , 1);
      FETCH Get_File_ BULK COLLECT INTO file_names_, file_dates_, file_ids_;
      CLOSE Get_File_;

      FOR i IN Nvl(file_names_.FIRST,1)..Nvl(file_names_.LAST,-1) LOOP
         BEGIN
            SELECT import_file INTO import_file_ FROM language_file_import_tab WHERE file_id=file_ids_(i);
            component_ := NULL;
            lang_code_ := NULL;
            main_type_ := NULL;
            Get_Keys_(dbms_lob.substr(import_file_,1200, 1), 9, 'TRS');
            IF (component_ IS NOT NULL AND instr(skip_main_types_, upper(main_type_||'^')) < 1) THEN
               IF (lang_code_ IS NOT NULL AND instr(lang_list_,lang_code_||',') < 1) THEN
                  lang_list_ := lang_list_ || lang_code_||',';
               END IF;
            END IF;
         END;
         UPDATE language_file_import_tab
         SET   processed=2
         WHERE file_id=file_ids_(i);
      END LOOP;

      lang_code_ := NULL;
      WHILE (length(lang_list_) IS NOT NULL) LOOP
         lang_code_ := substr(lang_list_,1,instr(lang_list_,',')-1);
         lang_list_  := substr(lang_list_,instr(lang_list_,',')+1);
         Refresh_Language_Dictionary_ (lang_code_, NULL, 'FALSE', 'FALSE');
         @ApproveTransactionStatement(2013-11-14,haarse)
         COMMIT;
      END LOOP;
      Transaction_SYS.Log_Progress_Info('Refreshing domain languages');
      Domain_SYS.Refresh_Language_;
      Transaction_SYS.Log_Status_Info('Refreshing domain languages. '||to_char(SYSDATE, 'HH24:MI:SS'), 'INFO');
   END IF;

   DELETE
      FROM language_file_import_tab
      WHERE task_id = task_id_;

   -- Update translations for object_connectivity_sys_tab records.
   Object_Connection_SYS.Refresh_Active_List__(5);
   
   IF (warning_) THEN
      Transaction_SYS.Log_Progress_Info('Unexpected error when processing file(s), check detail log' );
   ELSE
      Transaction_SYS.Log_Progress_Info(NULL);
   END IF;

END Bulk_Import_Def_Call_;


PROCEDURE Bulk_Import_Lng_ (
   context_   OUT NUMBER,
   attribute_ OUT NUMBER,
   file_id_   IN  VARCHAR2 )
IS
   import_file_   CLOB;
   file_name_     VARCHAR2(400);
   file_date_     DATE;

   CURSOR get_clob (file_id_ VARCHAR2) IS
      SELECT import_file, file_name, file_date
      FROM   language_file_import_tab
      WHERE  file_id = file_id_;
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Lng_');
   IF (file_id_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'EMPTYID: EMPTY file id !');
   END IF;

   OPEN  get_clob(file_id_);
   FETCH get_clob INTO import_file_, file_name_, file_date_;
   CLOSE get_clob;

   Bulk_Import_Lng_ (context_, attribute_, import_file_, file_name_, file_date_);
   DELETE
      FROM language_file_import_tab
      WHERE file_id = file_id_;

END Bulk_Import_Lng_;


PROCEDURE Bulk_Import_Lng_ (
   context_   OUT NUMBER,
   attribute_ OUT NUMBER,
   file_      IN  CLOB,
   file_name_ IN  VARCHAR2,
   file_date_ IN  DATE )
IS

   line_data_        VARCHAR2(32000);
   start_pos_data_   NUMBER := 1;
   amount_data_      NUMBER;
   
   pos_              NUMBER;
   line_             VARCHAR2(32000);
   key_              VARCHAR2(1000);
   row_no_           NUMBER;
   start_pos_        NUMBER := 1;
   separator_        VARCHAR2(2) :=chr(13)||chr(10);

   context_start_    VARCHAR2(2) := 'CS';
   context_end_      VARCHAR2(2) := 'CE';
   property_         VARCHAR2(1) := 'P';
   attrib_           VARCHAR2(1) := 'A';
   field_desc_       VARCHAR2(1) := 'D';
   delimeter_key_    VARCHAR2(1) := ':';
   delimeter_pack_   VARCHAR2(1) := '^';
   delimeter_path_   VARCHAR2(1)   := '.';

   header_ok_           BOOLEAN := FALSE;

   file_type_key_       VARCHAR2(9)  := 'File Type';
   version_key_         VARCHAR2(12) := 'Type version';
   layer_key_           VARCHAR2(10) := 'Layer';
   main_type_key_       VARCHAR2(10) := 'Main Type';
   sub_type_key_        VARCHAR2(10) := 'Sub Type';
   content_key_         VARCHAR2(20) := 'Content';
   module_key_          VARCHAR2(6)  := 'Module';
   file_type_           VARCHAR2(28) := 'IFS Foundation Language File';
   file_type_ok_        VARCHAR2(200);
   version_100_         VARCHAR2(4)  := '1.00';
   version_1000_        VARCHAR2(5)  := '10.00';
   version_ok_          VARCHAR2(200);
   layer_               VARCHAR2(100);
   main_type_           VARCHAR2(50);
   sub_type_            VARCHAR2(50);
   content_             VARCHAR2(50);
   component_           VARCHAR2(10);

   fnd_layer_rec_   Fnd_Layer_TAB%ROWTYPE;
   max_ordinal_     NUMBER;

   -- Context Data
   c_id_                       language_context_tab.context_id%TYPE := 0;
   c_name_                     VARCHAR2(2000);
   c_parent_                   language_context_tab.parent%TYPE := 0;
   c_main_type_                language_context_tab.main_type%TYPE;
   c_sub_type_                 language_context_tab.sub_type%TYPE;
   c_parent_sub_type_tmp_      language_context_tab.sub_type%TYPE;
   c_path_                     VARCHAR2(2000);
   c_bulk_                     language_context_tab.bulk%TYPE := 0;
   c_level_                    NUMBER := 0;
   c_path_tmp_                 VARCHAR2(2000);
   c_id_tmp_                   VARCHAR2(1000);
   c_parent_bulk_              language_context_tab.bulk%TYPE := 0;

   -- Attribute Data
   a_id_                         language_attribute_tab.attribute_id%TYPE := 0;
   a_name_                       language_attribute_tab.name%TYPE;
   a_prog_text_                  language_attribute_tab.prog_text%TYPE;
   a_long_prog_text_             VARCHAR2(32000);
   -- Property Data
   p_name_                 language_property_tab.name%TYPE;
   p_value_             language_property_tab.value%TYPE;

   FUNCTION Fetch_text_ (
      line_        IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
   END Fetch_text_;

   FUNCTION Fetch_key_ (
      line_        IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN substr(line_, 1, instr(line_, delimeter_key_)-1);
   END Fetch_key_;

   FUNCTION Get_Token_(
      line_  IN VARCHAR2,
      token_ IN NUMBER ) RETURN VARCHAR2
   IS
      from_pos_ NUMBER := 1;
      to_pos_   NUMBER;
   BEGIN
      IF (token_ = 0) THEN
         to_pos_ := instr(line_,delimeter_pack_)-1;
      ELSE
         from_pos_ := instr(line_,delimeter_pack_,1,token_)+1;
         to_pos_   := instr(line_,delimeter_pack_,1,token_+1) - from_pos_;
      END IF;
      IF (to_pos_ < 0) THEN
         IF (from_pos_ > 1) THEN
            RETURN substr(line_, from_pos_);
         ELSE
            RETURN '';
         END IF;
      ELSE
         RETURN substr(line_, from_pos_,to_pos_);
      END IF;
   END Get_Token_;

   FUNCTION UnCode_(
      line_  IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN replace(replace(line_,'\'||chr(38)||'10\', chr(10)),'\'||chr(38)||'13\',chr(13));
   END UnCode_;

   FUNCTION Validate_header_ (
      line_no_ IN NUMBER,
      line_    IN VARCHAR2 ) RETURN BOOLEAN
   IS
      key_value_              VARCHAR2(1000);
   BEGIN
      key_value_ := Fetch_key_(line_);
      IF (key_value_ = file_type_key_) THEN
         file_type_ok_ := Fetch_text_(line_);
      ELSIF (key_value_ = version_key_) THEN
         version_ok_ := Fetch_text_(line_);
      ELSIF (key_value_ = layer_key_) THEN
         layer_ := Fetch_text_(line_);
      ELSIF (key_value_ = main_type_key_) THEN
         main_type_ := Fetch_text_(line_);
      ELSIF (key_value_ = sub_type_key_) THEN
         sub_type_ := Fetch_text_(line_);
      ELSIF (key_value_ = content_key_) THEN
         content_ := Fetch_text_(line_);
      ELSIF (key_value_ = module_key_) THEN
         component_ := Fetch_text_(line_);
      ELSIF (Substr(Fetch_text_(line_),1,3) ='---' AND
          file_type_ok_ = file_type_ AND
          (version_ok_ = version_100_ OR version_ok_ = version_1000_ )AND
          component_ IS NOT NULL AND
          layer_ IS NOT NULL AND
          main_type_ IS NOT NULL AND
          sub_type_ IS NOT NULL) THEN
            RETURN TRUE;
      END IF;
      RETURN FALSE;
   END Validate_header_;
   
   FUNCTION LayerExists_(layer_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
   BEGIN
      IF FND_LAYER_API.Exists(layer_) THEN
         RETURN TRUE;
      END IF;
      RETURN FALSE;
   END LayerExists_;

   PROCEDURE Unpack_Context_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      c_name_        := Get_Token_(line_,0);
      c_main_type_   := Get_Token_(line_,1);
      c_sub_type_    := Get_Token_(line_,2);
      c_bulk_        := Get_Token_(line_,5);
   END Unpack_Context_;

   PROCEDURE Unpack_Attribute_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      a_name_                       := Get_Token_(line_,0);
      a_prog_text_                  := Get_Token_(line_,1);

   END Unpack_Attribute_;
   
   PROCEDURE Unpack_Field_Desc_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      a_name_                       := Get_Token_(line_,0);
      a_long_prog_text_             := Get_Token_(line_,1);

   END Unpack_Field_Desc_;   

   PROCEDURE Unpack_Property_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      p_name_        := Get_Token_(line_,0);
      p_value_       := Get_Token_(line_,1);
   END Unpack_Property_;
   
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Lng_');
    -- Should be removed after lng split - Start
    layer_     := 'Core';
    main_type_ := '%';
    sub_type_  := '%';
    -- Should be removed after lng split - End
    
   -- initiate return values
   context_ := 0;
   attribute_ :=0;

   -- amount_data_ has to be of size that will cover whole header section!!
   -- also be aware of how many character can be saved in string (unicode).
   amount_data_ := 5000;   

   line_data_ := dbms_lob.substr(file_,amount_data_, start_pos_data_);
   pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
   
   IF (pos_ = 0) THEN
      separator_ := chr(10);
      pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
   END IF;
   row_no_ := 1;

   -- Run Validate_header_ for all rows in header
   WHILE (pos_ > 0 AND NOT header_ok_ AND row_no_ <= 12) LOOP
      line_ := ltrim(substr(line_data_,start_pos_, pos_-start_pos_),chr(9));
      header_ok_ := Validate_header_(row_no_, line_);

      start_pos_ := pos_+length(separator_);
      pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
      row_no_ := row_no_ + 1;
   END LOOP;
      
   IF (header_ok_) THEN
      -- Insert FndLayer information if layer does not exist
      IF NOT LayerExists_(layer_)  THEN
         max_ordinal_:= FND_LAYER_API.Get_Max_Ordinal;
         fnd_layer_rec_.layer_id:=layer_;
         fnd_layer_rec_.description:=layer_;
         fnd_layer_rec_.ordinal:=max_ordinal_+1;
         fnd_layer_api.New(fnd_layer_rec_);
      END IF; 
      -- Will create a dummy row for module, if not exist.
      Module_API.Pre_Register(component_, component_||' name');
      -- Run Make_Obsolete for all context and attributes belonging to this component.
      IF sub_type_ = 'All' THEN
         sub_type_ := '%';
      END IF;

      IF (version_ok_ = version_1000_) THEN
         IF (content_ IS NOT NULL AND content_ = 'FieldDescription') THEN
            Language_Module_API.Make_Usage_Obsolete__(component_, layer_, main_type_, sub_type_);
         ELSE
            Language_Module_API.Make_Obsolete__(component_, layer_, main_type_, sub_type_);
         END IF;
      ELSE
         Language_Module_API.Make_Obsolete__(component_, layer_, main_type_, sub_type_);
      END IF;
   END IF;

   WHILE (start_pos_data_ > 0 AND header_ok_) LOOP
      WHILE (pos_ > 0 AND header_ok_) LOOP
         line_ := ltrim(substr(line_data_,start_pos_, pos_-start_pos_),chr(9));
         key_ := trim(Fetch_key_(line_));
   
         -- If end of context reverse to previous keys.
         IF (key_ = context_end_) THEN
            IF (c_level_ > 1) THEN
               c_path_tmp_ := substr(c_path_tmp_,1,instr(c_path_tmp_,delimeter_pack_,1,c_level_-1)-1);
               c_path_ := translate(c_path_tmp_,delimeter_pack_,delimeter_path_);
               c_id_   := substr(c_id_tmp_,instr(c_id_tmp_,delimeter_pack_,1,c_level_-1)+1);
               c_id_tmp_ := substr(c_id_tmp_,1,instr(c_id_tmp_,delimeter_pack_,1,c_level_-1)-1);
            END IF;
            c_level_ := c_level_ - 1;
         -- Start of next context
         ELSIF (key_ = context_start_) THEN
            Unpack_Context_(Fetch_text_(line_));
   
            IF (c_level_ = 0) THEN
               IF (c_main_type_ = 'CONFIGLU') THEN
                  IF instr(c_name_, 'InformationCard') > 0 THEN 
                     c_path_ := substr(c_name_, 0, instr(c_name_, 'InformationCard')-1);
                     c_path_tmp_ := substr(c_name_, 0, instr(c_name_, 'InformationCard')-1);
                  ELSIF instr(c_name_, 'CustomField') > 0 THEN
                     c_path_ := substr(c_name_, 0, instr(c_name_, 'CustomField')-1);
                     c_path_tmp_ := substr(c_name_, 0, instr(c_name_, 'CustomField')-1);
                  ELSE 
                     c_path_               := c_name_;
                     c_path_tmp_           := c_name_;
                  END IF;
               ELSE
                  c_path_               := c_name_;
                  c_path_tmp_           := c_name_;
               END IF;
               
               c_parent_             := 0;
               c_parent_bulk_        := c_bulk_;
               c_parent_sub_type_tmp_:= c_sub_type_;
            ELSE
               IF c_parent_sub_type_tmp_='Search Domain' AND (c_sub_type_='Attribute' OR c_sub_type_='Aggregate' OR c_sub_type_='Entity') THEN
                  c_path_     := c_name_;
                  c_path_tmp_ := c_name_;
               ELSE
                  c_path_     := c_path_||delimeter_path_||c_name_;
                  c_path_tmp_ := c_path_tmp_||delimeter_pack_||c_name_; 
               END IF;
               c_parent_   := c_id_;
               IF (c_parent_bulk_ = '1') THEN
                  c_bulk_ := c_parent_bulk_;
               END IF;
            END IF;
            Language_Context_API.Refresh_(c_id_, NULL, c_name_, c_parent_, c_main_type_, c_sub_type_, component_, c_path_, layer_, c_bulk_);
            IF (c_level_ = 0) THEN
               c_id_tmp_ := c_parent_;
            ELSE
               c_id_tmp_   := c_id_tmp_||delimeter_pack_||c_parent_;
            END IF;
            c_level_ := c_level_ + 1;
            context_ := context_ + 1;
         -- Attribute
         ELSIF (key_ = attrib_) THEN
            Unpack_Attribute_(Fetch_text_(line_));
            Language_Attribute_API.Refresh_(a_id_, c_id_, a_name_, UnCode_(replace(a_prog_text_, 'ChR94', '^')));
            attribute_ := attribute_ + 1;
         -- Field Description
         ELSIF (key_ = field_desc_) THEN
            Unpack_Field_Desc_(Fetch_text_(line_));
            Language_Attribute_API.Refresh_Usage_(a_id_, c_id_, a_name_, UnCode_(replace(a_long_prog_text_, 'ChR94', '^')));
            attribute_ := attribute_ + 1;            
         -- Property
         ELSIF (key_ = property_) THEN
            Unpack_Property_(Fetch_text_(line_));
            Language_Property_API.Refresh_(c_id_, p_name_, p_value_);
         END IF;
         start_pos_ := pos_+length(separator_);
         pos_ := instr(line_data_,separator_,start_pos_);
         row_no_ := row_no_ + 1;
      END LOOP;

      line_data_ := substr(line_data_,start_pos_,length(line_data_))||dbms_lob.substr(file_,amount_data_, start_pos_data_+amount_data_);
      start_pos_data_ := start_pos_data_ + amount_data_;
      IF (NOT length(line_data_) > 0 OR (line_data_ IS NULL)) THEN
         start_pos_data_ := 0; 
      END IF;  

      start_pos_ := 1;
      pos_ := instr(line_data_,separator_,start_pos_);

   END LOOP;

   IF (header_ok_) THEN
      Language_Source_API.Register__ (file_name_, NULL, component_, 'LF', NULL, 'B', file_date_);
   END IF;

END Bulk_Import_Lng_;


PROCEDURE Bulk_Import_Trs_ (
   context_   OUT NUMBER,
   attribute_ OUT NUMBER,
   file_id_   IN  VARCHAR2 )
IS
   import_file_   CLOB;
   file_name_     VARCHAR2(400);
   file_date_     DATE;

   CURSOR get_clob (file_id_ VARCHAR2) IS
      SELECT import_file, file_name, file_date
      FROM   language_file_import_tab
      WHERE  file_id = file_id_;
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Trs_');

   IF (file_id_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'EMPTYID: EMPTY file id !');
   END IF;

   OPEN  get_clob(file_id_);
   FETCH get_clob INTO import_file_, file_name_, file_date_;
   CLOSE get_clob;

   Bulk_Import_Trs_ (context_, attribute_, import_file_, file_name_, file_date_);
   DELETE
      FROM language_file_import_tab
      WHERE file_id = file_id_;

END Bulk_Import_Trs_;


PROCEDURE Bulk_Import_Trs_ (
   context_   OUT NUMBER,
   attribute_ OUT NUMBER,
   file_      IN  CLOB,
   file_name_ IN  VARCHAR2,
   file_date_ IN  DATE )
IS
   
   line_data_        VARCHAR2(32000);
   start_pos_data_   NUMBER := 1;
   amount_data_      NUMBER;
   
   pos_              NUMBER;
   line_             VARCHAR2(32000);
   key_              VARCHAR2(1000);
   row_no_           NUMBER;
   start_pos_        NUMBER := 1;
   separator_        VARCHAR2(2) :=chr(13)||chr(10);

   context_start_    VARCHAR2(2) := 'CS';
   context_end_      VARCHAR2(2) := 'CE';
   attrib_           VARCHAR2(1) := 'A';
   field_desc_       VARCHAR2(1) := 'D';
   prog_             VARCHAR2(1) := 'P';
   delimeter_key_    VARCHAR2(1) := ':';
   delimeter_pack_   VARCHAR2(1) := '^';

   header_ok_        BOOLEAN := FALSE;

   file_type_key_    VARCHAR2(9)  := 'File Type';
   version_key_      VARCHAR2(12) := 'Type version';
   module_key_       VARCHAR2(6)  := 'Module';
   language_key_     VARCHAR2(8)  := 'Language';
   layer_key_        VARCHAR2(10) := 'Layer';
   main_type_key_    VARCHAR2(10) := 'Main Type';
   sub_type_key_     VARCHAR2(10) := 'Sub Type';
   content_key_      VARCHAR2(20) := 'Content';
   file_type_        VARCHAR2(31) := 'IFS Foundation Translation File';
   file_type_ok_     VARCHAR2(200);
   version_100_      VARCHAR2(4)  := '1.00';
   version_1000_     VARCHAR2(5)  := '10.00';
   version_ok_       VARCHAR2(200);
   component_        VARCHAR2(10);
   language_         VARCHAR2(2);
   layer_            VARCHAR2(100);
   main_type_        VARCHAR2(50);
   sub_type_         VARCHAR2(50);
   content_          VARCHAR2(50);

   fnd_layer_rec_   Fnd_Layer_TAB%ROWTYPE;
   max_ordinal_     NUMBER;

   -- Context Data
   c_id_             language_context_tab.context_id%TYPE := 0;
   c_id_prog_        language_context_tab.context_id%TYPE := 0;
   c_name_           VARCHAR2(2000);
   c_parent_         language_context_tab.parent%TYPE := 0;
   c_main_type_      language_context_tab.main_type%TYPE;
   c_level_          NUMBER := 0;
   c_id_tmp_         VARCHAR2(1000);

   -- Attribute Data
   a_id_             language_attribute_tab.attribute_id%TYPE := 0;
   a_name_           language_attribute_tab.name%TYPE;
   a_text_           VARCHAR2(8000);
   a_text_prog_      VARCHAR2(8000);   
   a_long_text_      VARCHAR2(32000);
   c_id_check_       language_context_tab.context_id%TYPE := 0;

   existing_translation_    LANGUAGE_TRANSLATION_TAB.text%TYPE; 
   new_translation_         LANGUAGE_TRANSLATION_TAB.text%TYPE;
   attr_id_array_           number_array;
   text_array_              a4000_array;
   
   FUNCTION Fetch_text_ (
      line_        IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN ltrim(rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_))));
   END Fetch_text_;

   FUNCTION Fetch_Prog_text_ (
      line_        IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN rtrim(substr(line_, instr(line_, delimeter_key_) +1, length(line_)));
   END Fetch_Prog_text_;

   FUNCTION Fetch_key_ (
      line_        IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN substr(line_, 1, instr(line_, delimeter_key_)-1);
   END Fetch_key_;

   FUNCTION Get_Token_(
      line_  IN VARCHAR2,
      token_ IN NUMBER ) RETURN VARCHAR2
   IS
      from_pos_ NUMBER := 1;
      to_pos_   NUMBER;
   BEGIN
      IF (token_ = 0) THEN
         to_pos_ := instr(line_,delimeter_pack_)-1;
      ELSE
         from_pos_ := instr(line_,delimeter_pack_,1,token_)+1;
         to_pos_   := instr(line_,delimeter_pack_,1,token_+1) - from_pos_;
      END IF;
      IF (to_pos_ < 0) THEN
         IF (from_pos_ > 1) THEN
            RETURN substr(line_, from_pos_);
         ELSE
            RETURN '';
         END IF;
      ELSE
         RETURN substr(line_, from_pos_,to_pos_);
      END IF;
   END Get_Token_;

   FUNCTION UnCode_(
      line_  IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN replace(replace(line_,'\'||chr(38)||'10\', chr(10)),'\'||chr(38)||'13\',chr(13));
   END UnCode_;

   FUNCTION Validate_header_ (
      line_no_ IN NUMBER,
      line_    IN VARCHAR2 ) RETURN BOOLEAN
   IS
      key_value_              VARCHAR2(1000);
   BEGIN
      key_value_ := Fetch_key_(line_);
      IF (key_value_ = file_type_key_) THEN
         file_type_ok_ := Fetch_text_(line_);
      ELSIF (key_value_ = version_key_) THEN
         version_ok_ := Fetch_text_(line_);
      ELSIF (key_value_ = module_key_) THEN
         component_ := Fetch_text_(line_);
      ELSIF (key_value_ = layer_key_) THEN
         layer_ := Fetch_text_(line_);
      ELSIF (key_value_ = main_type_key_) THEN
         main_type_ := Fetch_text_(line_);
      ELSIF (key_value_ = sub_type_key_) THEN
         sub_type_ := Fetch_text_(line_);         
      ELSIF (key_value_ = content_key_) THEN
         content_ := Fetch_text_(line_);         
      ELSIF (key_value_ = language_key_) THEN
         language_ := Fetch_text_(line_);
         IF (language_ != lower(language_)) THEN
            language_ := NULL;
         END IF;
      ELSIF (Substr(Fetch_text_(line_),1,3) ='---' AND
          file_type_ok_ = file_type_ AND
          (version_ok_ = version_100_ OR version_ok_ = version_1000_) AND
          component_ IS NOT NULL AND
          language_ IS NOT NULL AND         
          layer_ IS NOT NULL AND
          main_type_ IS NOT NULL AND
          sub_type_ IS NOT NULL) THEN
            RETURN TRUE;
      END IF;
      RETURN FALSE;
   END Validate_header_;

   FUNCTION LayerExists_(layer_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
   BEGIN
      IF FND_LAYER_API.Exists(layer_) THEN
         RETURN TRUE;
      END IF;
      RETURN FALSE;
   END LayerExists_;

   PROCEDURE Context_Unpack_Translation_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      c_name_        := Get_Token_(line_,0);
      c_main_type_   := Get_Token_(line_,1);
   END Context_Unpack_Translation_;

   PROCEDURE Attribute_Unpack_Prog_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      a_text_prog_ := Get_Token_(line_,0);
   END Attribute_Unpack_Prog_;
   
   PROCEDURE Attribute_Unpack_Translation_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      a_name_      := Get_Token_(line_,0);
      a_text_      := Get_Token_(line_,1);
   END Attribute_Unpack_Translation_;
   
   PROCEDURE Field_Desc_Unpack_Translation_ (
      line_ IN VARCHAR2 )
   IS
   BEGIN
      a_name_      := Get_Token_(line_,0);
      a_long_text_ := Get_Token_(line_,1);
   END Field_Desc_Unpack_Translation_;   

   PROCEDURE Activate_Language_Code_ (
      lang_code_    IN VARCHAR2 )
   IS
      objid_      VARCHAR2(100);
      objversion_ VARCHAR2(100);
      info_       VARCHAR2(1000);
      attr_       VARCHAR2(1000);

   CURSOR get_lang IS
      SELECT objid, objversion
      FROM   language_code
      WHERE  lang_code = lang_code_;

   BEGIN
      OPEN  get_lang;
      FETCH get_lang INTO objid_, objversion_;
      CLOSE get_lang;

      Client_SYS.Add_To_Attr('VALIDATE_NLS', 'FALSE', attr_); -- Don't validate nls_data from here
      Client_SYS.Add_To_Attr('STATUS_DB', 'A', attr_);
      IF objid_ IS NULL THEN
         Error_SYS.Appl_General(service_, 'LANGCODENOTEXIST: Language code [:P1] does not exist !', lang_code_);
      ELSE
         Language_Code_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   END Activate_Language_Code_;

BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Bulk_Import_Trs_');
   -- initiate return values
   context_ := 0;
   attribute_ :=0;
   
    -- Should be removed after lng split - Start
    layer_     := 'Core';
    main_type_ := '%';
    sub_type_  := '%';
    -- Should be removed after lng split - End

   -- amount_data_ has to be of size that will cover whole header section!!
   -- also be aware of how many character can be saved in string (unicode).
   amount_data_ := 5000;   

   line_data_ := dbms_lob.substr(file_,amount_data_, start_pos_data_);
   pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
   
   IF (pos_ = 0) THEN
      separator_ := chr(10);
      pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
   END IF;

   row_no_ := 1;

   -- Run Validate_header_ for all rows in header
   WHILE (pos_ > 0 AND NOT header_ok_ AND row_no_ <= 12) LOOP
      line_ := ltrim(substr(line_data_,start_pos_, pos_-start_pos_),chr(9));
      header_ok_ := Validate_header_(row_no_, line_);

      start_pos_ := pos_+length(separator_);
      pos_ := nvl(instr(line_data_,separator_,start_pos_),0);
      row_no_ := row_no_ + 1;
   END LOOP;

   IF (header_ok_) THEN
      -- Insert FndLayer information if layer does not exist
      IF NOT LayerExists_(layer_)  THEN
         max_ordinal_:= FND_LAYER_API.Get_Max_Ordinal;
         fnd_layer_rec_.layer_id:=layer_;
         fnd_layer_rec_.description:=layer_;
         fnd_layer_rec_.ordinal:=max_ordinal_+1;
         fnd_layer_api.New(fnd_layer_rec_);
      END IF;
      -- Remove 'en' language.
      IF (language_ = 'en' AND version_ok_ = version_1000_ AND (content_ IS NULL OR content_ != 'FieldDescription')) THEN
         -- Fetching existing english translations before remove
         SELECT t.attribute_id, t.text BULK COLLECT INTO attr_id_array_, text_array_ 
         FROM language_context_tab c, language_attribute_tab a, language_translation_tab t 
         WHERE lang_code = 'en' AND c.context_id = a.context_id AND  c.module = component_
         AND c.layer = layer_ AND c.main_type = main_type_ AND a.attribute_id = t.attribute_id;
  
         IF sub_type_ = 'All' THEN
            sub_type_  := '%';
         END IF;
         IF main_type_ = 'LU' AND sub_type_ = 'Logical Unit' THEN
            Language_Context_API.Remove_Module_Language_(component_, layer_, main_type_, 'Column', language_, content_);
            Language_Context_API.Remove_Module_Language_(component_, layer_, main_type_, 'Logical Unit', language_, content_);
         ELSE
            Language_Context_API.Remove_Module_Language_(component_, layer_, main_type_, sub_type_, language_, content_);
         END IF;
      END IF;
   END IF;

   WHILE (start_pos_data_ > 0 AND header_ok_) LOOP
      WHILE (pos_ > 0 AND header_ok_) LOOP
         line_ := ltrim(substr(line_data_,start_pos_, pos_-start_pos_),chr(9));
         key_ := trim(Fetch_key_(line_));
         
         -- If end of context reverse to previous keys.
         IF (key_ = context_end_) THEN
            IF (c_level_ > 1) THEN
               c_id_   := substr(c_id_tmp_,instr(c_id_tmp_,delimeter_pack_,1,c_level_-1)+1);
               c_id_tmp_ := substr(c_id_tmp_,1,instr(c_id_tmp_,delimeter_pack_,1,c_level_-1)-1);
            END IF;
            c_level_ := c_level_ - 1;
         -- Start of next context
         ELSIF (key_ = context_start_) THEN
            Context_Unpack_Translation_(Fetch_text_(line_));
   
            IF (c_level_ = 0) THEN
               c_parent_      := 0;
            ELSE
               c_parent_   := c_id_;
            END IF;
   
            c_id_ := Language_Context_API.Get_Id_( c_parent_, c_name_, c_main_type_, layer_);
            IF (c_level_ = 0) THEN
               c_id_tmp_ := c_parent_;
            ELSE
               c_id_tmp_   := c_id_tmp_||delimeter_pack_||c_parent_;
            END IF;
            c_level_ := c_level_ + 1;
         -- Prog
         ELSIF (key_ = prog_ AND c_id_ !=0) THEN
            Attribute_Unpack_Prog_(Fetch_Prog_text_(line_));
            c_id_prog_ := c_id_;
         -- Attribute
         ELSIF (key_ = attrib_ AND c_id_ !=0) THEN
            Attribute_Unpack_Translation_(Fetch_text_(line_));
            Language_Attribute_API.Get_Id__( a_id_, c_id_, a_name_ );
            IF (c_id_prog_ != c_id_) THEN
               a_text_prog_ := '';
            END IF;
            Language_Translation_API.Refresh_(a_id_, language_, UnCode_(replace(a_text_, 'ChR94', '^')), 'O',a_text_prog_); 
            -- Changing status to 'Changed' if english translation has changed
            IF (language_ = 'en') THEN 
               FOR rec_ IN 1..attr_id_array_.count LOOP
                  IF (a_id_ = attr_id_array_(rec_))THEN
                     existing_translation_ := text_array_(rec_);
                     EXIT;
                  END IF;
               END LOOP;
               new_translation_ := UnCode_(replace(a_text_, 'ChR94', '^'));
               IF (existing_translation_ != new_translation_) THEN
                  Language_Translation_API.Set_Status_To_Changed_(a_id_);
               END IF;   
            END IF;
            a_text_prog_ := '';            
            IF (c_id_check_ != c_id_) THEN
               c_id_check_ := c_id_;
               context_ := context_ + 1;
            END IF;
            attribute_ := attribute_ + 1;
         -- Field Description
         ELSIF (key_ = field_desc_ AND c_id_ !=0) THEN
            Field_Desc_Unpack_Translation_(Fetch_text_(line_));
            Language_Attribute_API.Get_Id__( a_id_, c_id_, a_name_ );
            Language_Translation_API.Refresh_Usage_(a_id_, language_, UnCode_(replace(a_long_text_, 'ChR94', '^'))); 
            IF (c_id_check_ != c_id_) THEN
               c_id_check_ := c_id_;
               context_ := context_ + 1;
            END IF;
            attribute_ := attribute_ + 1;            
         END IF;
   
         start_pos_ := pos_+length(separator_);
         pos_ := instr(line_data_,separator_,start_pos_);
         row_no_ := row_no_ + 1;
      END LOOP;

      line_data_ := substr(line_data_,start_pos_,length(line_data_))||dbms_lob.substr(file_,amount_data_, start_pos_data_+amount_data_);
      start_pos_data_ := start_pos_data_ + amount_data_;
      IF (NOT length(line_data_) > 0 OR (line_data_ IS NULL)) THEN
         start_pos_data_ := 0; 
      END IF;

      start_pos_ := 1;
      pos_ := instr(line_data_,separator_,start_pos_);

   END LOOP;

   IF (attribute_ > 0) THEN
      Activate_Language_Code_(language_);
   END IF;

   IF (header_ok_) THEN
      -- Update the file types for this component.
      Language_Source_API.Register__ (file_name_, NULL, component_, 'TF', NULL, 'L', file_date_);
   END IF;

END Bulk_Import_Trs_;

--PROCEDURE Refresh_Lang_Dic_Batch_ (
--   lang_code_ IN VARCHAR2 DEFAULT NULL,
--  component_ IN VARCHAR2 DEFAULT NULL,
--   term_id_ IN VARCHAR2 DEFAULT NULL,
--   auto_transaction_ IN VARCHAR2 DEFAULT 'TRUE' )
--IS
--BEGIN
--   -- Obsolete.
--   -- Should be removed to release
--   NULL;
--END Refresh_Lang_Dic_Batch_;

PROCEDURE Refresh_Lang_Dic_Batch_ (
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   component_ IN VARCHAR2 DEFAULT NULL,
   auto_transaction_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   attr_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Refresh_Lang_Dic_Batch_');
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
   Client_SYS.Add_To_Attr('COMPONENT', component_, attr_);
   Client_SYS.Add_To_Attr('AUTO_TRANSACTION', auto_transaction_, attr_);
   Transaction_SYS.Deferred_Call('Language_SYS.Refresh_Lang_Dic_Def_Call_', attr_, 'Refresh of Language Dictionary');
--   Language_SYS.Refresh_Lang_Dic_Def_Call_(attr_);
END Refresh_Lang_Dic_Batch_;


PROCEDURE Refresh_Lang_Dic_Batch_ (
   job_id_ OUT NUMBER ,
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   component_ IN VARCHAR2 DEFAULT NULL,
   auto_transaction_ IN VARCHAR2 DEFAULT 'TRUE'
  )
IS
   attr_ VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Refresh_Lang_Dic_Batch_');
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
   Client_SYS.Add_To_Attr('COMPONENT', component_, attr_);
   Client_SYS.Add_To_Attr('AUTO_TRANSACTION', auto_transaction_, attr_);

   Transaction_SYS.Deferred_Call( job_id_,'Language_SYS.Refresh_Lang_Dic_Def_Call_', 'ATTRIBUTE',attr_,'Refresh of Language Dictionary',sysdate,'FALSE',NULL); 
                             
END Refresh_Lang_Dic_Batch_;


PROCEDURE Refresh_Lang_Dic_Def_Call_ (
   attr_ IN VARCHAR2 )
IS
   lang_code_        language_code_tab.lang_code%TYPE;
   component_        module_tab.module%TYPE;
   auto_transaction_ VARCHAR2(5);

   ptr_       NUMBER;
   name_      VARCHAR2(30);
   value_     VARCHAR2(2000);

BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Refresh_Lang_Dic_Def_Call_');

   ptr_       := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LANG_CODE') THEN
         lang_code_ := value_;
      ELSIF (name_ = 'COMPONENT') THEN
         component_ := value_;
      ELSIF (name_ = 'AUTO_TRANSACTION') THEN
         auto_transaction_ := value_;
      END IF;
   END LOOP;

   Refresh_Language_Dictionary_ (lang_code_, component_, auto_transaction_);

END Refresh_Lang_Dic_Def_Call_;

@UncheckedAccess
PROCEDURE Bulk_Export_Lng_ (
   file_id_       IN VARCHAR2,
   component_     IN VARCHAR2,
   layer_         IN VARCHAR2,
   in_main_type_  IN VARCHAR2,
   in_sub_type_   IN VARCHAR2,
   in_content_    IN VARCHAR2 DEFAULT '')

IS
   file_content_ CLOB;
BEGIN
   Bulk_Export_Lng_ (file_content_, FALSE, file_id_, component_, layer_, in_main_type_, in_sub_type_, in_content_ );
END Bulk_Export_Lng_;

@UncheckedAccess
PROCEDURE Bulk_Export_Lng_ (
   file_content_  OUT CLOB,
   return_clob_   IN BOOLEAN,
   file_id_       IN VARCHAR2,
   component_     IN VARCHAR2,
   layer_         IN VARCHAR2,
   in_main_type_  IN VARCHAR2,
   in_sub_type_   IN VARCHAR2,
   in_content_    IN VARCHAR2 DEFAULT '')

  IS
      TYPE contexts IS RECORD(
      c_id_                language_context_tab.context_id%TYPE,
      c_name_              VARCHAR2(2000),
      c_parent_            language_context_tab.parent%TYPE, 
      c_main_type_         language_context_tab.main_type%TYPE,
      c_sub_type_          language_context_tab.sub_type%TYPE,
      c_path_              VARCHAR2(2000),
      c_bulk_              language_context_tab.bulk%TYPE,
      c_write_protect_     language_context_tab.write_protect%TYPE,
      c_obsolete_          language_context_tab.obsolete%TYPE); 
      
      sub_type_get_        language_context_tab.sub_type%TYPE;
      sub_type_reg_        language_context_tab.sub_type%TYPE;
      context_written_     BOOLEAN := FALSE;
      
      CURSOR  get_contexts IS
      SELECT  context_id,
              name, parent, main_type, sub_type, module,
              path, write_protect, obsolete, bulk
      FROM    language_context_tab t
      WHERE   module = component_ and parent = 0 and obsolete = 'N'
      and     layer = layer_
      and     main_type = in_main_type_
      and     sub_type like sub_type_get_
      ORDER BY nlssort(path, 'nls_sort = binary'),main_type;  
      
      contexts_ contexts;
      export_file_   CLOB;
      str_export_file_ VARCHAR2(5000);
      context_found_ BOOLEAN := FALSE;
          
      PROCEDURE Append_File__ (data_ IN VARCHAR2)
      IS
      BEGIN
         IF (length(str_export_file_||data_) > 5000)  THEN
            dbms_lob.append(export_file_, str_export_file_||data_);
            str_export_file_ := NULL;
            context_written_ := TRUE;
         ELSE
            str_export_file_ := str_export_file_||data_;
         END IF;
      END Append_File__;

      PROCEDURE Bulk_Export_Lng2_(contexts_ IN  contexts,
                                 sub_context_count_ IN  NUMBER,
                                 property_count_ IN  NUMBER,
                                 attribute_count_ IN  NUMBER,
                                 n_level_ IN NUMBER,
                                 n_handle_ IN NUMBER)
                                
      IS
              CURSOR   get_propery IS
              SELECT   context_id, name, value 
              FROM     language_property_tab
              WHERE    context_id = contexts_.c_id_
              ORDER BY nlssort(name, 'nls_sort = binary');
              
              CURSOR   get_attribute IS
              SELECT   a.attribute_id, a.context_id, a.name, 
                       prog_text, a.changed, a.method, a.ref_attr, a.obsolete,
                       usage, substr(long_prog_text,1,4000) long_prog_text
              FROM     language_attribute_tab a
              WHERE    a.context_id =contexts_.c_id_ and a.obsolete = 'N'
              ORDER BY nlssort(a.name, 'nls_sort = binary');
              
              CURSOR   get_subcontext IS
              SELECT   context_id, name, parent, main_type, sub_type, module,Database_SYS.Asciistr(path) path, write_protect, obsolete,              
                       bulk
              FROM     language_context_tab
              WHERE    parent = contexts_.c_id_ and obsolete = 'N'
              ORDER BY nlssort(path, 'nls_sort = binary');

              CURSOR check_long_subcontext (context_ IN NUMBER)IS
              SELECT sum(decode(a.usage,'TRUE',1,0)) 
              FROM   language_context_tab c,  language_attribute_tab a
              WHERE  c.obsolete = 'N' 
              AND    c.context_id = a.context_id(+) 
              and    a.obsolete(+) = 'N'
              AND    a.usage(+) = 'TRUE' 
              START WITH c.context_id = context_
              CONNECT BY PRIOR c.context_id = parent;
              
              child_contexts_ contexts;
              indent_           VARCHAR2(20) :='';
              indent_child_     VARCHAR2(20):='';
              ncounter_         NUMBER :=0;
              context_start_    VARCHAR2(2) := 'CS';
              context_end_      VARCHAR2(2) := 'CE';
              property_         VARCHAR2(1) := 'P';
              attrib_           VARCHAR2(1) := 'A';
              field_desc_       VARCHAR2(1) := 'D';
              delimeter_key_    VARCHAR2(1) := ':';
              delimeter_pack_   VARCHAR2(1) := '^';
              count_subcontext_ NUMBER :=0;
              count_property_   NUMBER :=0;
              in_field_desc_found_   NUMBER :=0;

                                   
      BEGIN
      WHILE (ncounter_ < n_level_) LOOP
      indent_ := indent_ || CHR(9);
      ncounter_ := ncounter_ + 1;
      END LOOP;
      indent_child_ := indent_ ||CHR(9);

      IF (in_content_ = 'FieldDescription') THEN 
         OPEN check_long_subcontext(contexts_.c_id_);
         FETCH check_long_subcontext INTO in_field_desc_found_;
         CLOSE check_long_subcontext;

         IF (in_field_desc_found_ = 0) THEN
            RETURN;
         END IF;

      END IF;  

      
      -- Write context start
      Append_File__(indent_||context_start_||delimeter_key_||Database_SYS.Asciistr(contexts_.c_name_)||delimeter_pack_|| contexts_.c_main_type_||delimeter_pack_|| contexts_.c_sub_type_||delimeter_pack_||'N'||delimeter_pack_||contexts_.c_obsolete_);
      IF(contexts_.c_bulk_ = 1) THEN
         Append_File__(delimeter_pack_||to_char(contexts_.c_bulk_));
      END IF;
      Append_File__(CHR(13)||CHR(10));

      -- Write properties 
      IF ( property_count_ > 0 AND (in_content_ IS NULL OR in_content_ != 'FieldDescription')) THEN
         FOR rec_ IN get_propery LOOP
         Append_File__(indent_child_||property_||delimeter_key_||rec_.name||delimeter_pack_|| rec_.value||delimeter_pack_||CHR(13)||CHR(10));
         END LOOP;
      END IF;

      --Write attributes
      IF  (attribute_count_ > 0) THEN
         FOR rec_ IN get_attribute LOOP
            IF (in_content_ = 'FieldDescription') THEN
               IF (rec_.usage = 'TRUE') THEN
                  Append_File__(indent_child_||field_desc_||delimeter_key_||rec_.name||delimeter_pack_||Code___(Database_SYS.Asciistr(replace(rec_.long_prog_text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
               END IF;
            ELSE
               Append_File__(indent_child_||attrib_||delimeter_key_||rec_.name||delimeter_pack_||Code___(Database_SYS.Asciistr(Replace(rec_.prog_text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
            END IF;
         END LOOP;
      END IF;

      -- Recursively call this procedure to write all sub-contexts
      IF  (sub_context_count_ > 0) THEN
         FOR rec_ IN get_subcontext LOOP
            IF (n_handle_ = 6) THEN
               EXIT;
            END IF;
            child_contexts_.c_id_ := rec_.context_id;               
            child_contexts_.c_name_ :=rec_.name;            
            child_contexts_.c_parent_  := rec_.parent;         
            child_contexts_.c_main_type_ :=rec_.main_type;
            child_contexts_.c_sub_type_   :=rec_.sub_type;       
            child_contexts_.c_path_       := rec_.path;      
            child_contexts_.c_bulk_ :=rec_.bulk;              
            child_contexts_.c_write_protect_  :=rec_.write_protect;
            child_contexts_.c_obsolete_ :=rec_.obsolete;
            IF(contexts_.c_bulk_ = 1) THEN
               child_contexts_.c_bulk_ := 0;  
            END IF; 
            count_subcontext_ := to_number(to_char(Language_Context_API.Count_Sub_Contexts_(rec_.context_id)));
            count_property_   := to_number(to_char(Language_Context_API.Count_Properties_(rec_.context_id)));
            Bulk_Export_Lng2_(child_contexts_,count_subcontext_,count_property_,1,n_level_+1,n_handle_+1); 
         END LOOP;
      END IF;

      -- Write context end
      Append_File__(indent_||context_end_||delimeter_key_||CHR(13)||CHR(10));
      END Bulk_Export_Lng2_;
     
  PROCEDURE Register_Destination_ (
   name_             IN VARCHAR2,
   module_           IN VARCHAR2,
   main_type_        IN VARCHAR2,
   export_method_    IN VARCHAR2,
   reg_sub_type_     IN VARCHAR2,
   reg_in_content_   IN VARCHAR2)
   
   IS

   PRAGMA AUTONOMOUS_TRANSACTION;

   strproper_   VARCHAR2(1); 
   file_name_   VARCHAR2(500);
   
   BEGIN    
     file_name_ := name_; 
     strproper_  := UPPER(substr(file_name_,0,1));
     file_name_ :=  LOWER(substr(file_name_,2,length(file_name_)));
     file_name_:= strproper_||file_name_||reg_sub_type_||reg_in_content_||layer_||'.lng';
     language_destination_api.Register__(file_name_,null,module_,main_type_,null,export_method_);
     @ApproveTransactionStatement(2017-01-25,stdafi)
     COMMIT;
 END Register_Destination_;

BEGIN       
   IF in_main_type_ = 'LU' THEN
    sub_type_get_ := in_sub_type_;
    sub_type_reg_ := in_sub_type_;
   ELSE
    sub_type_get_ := '%';
    sub_type_reg_ := 'All';
   END IF;  

   IF sub_type_get_ = 'All' THEN
    sub_type_get_ := '%';
   END IF;
    
   export_file_ := Bulk_Export_Initialize___(component_, layer_, in_main_type_, sub_type_reg_, in_content_);

   FOR rec_ IN get_contexts LOOP
    context_found_ := TRUE;
    contexts_.c_id_ := rec_.context_id;               
    contexts_.c_name_ :=rec_.name;            
    contexts_.c_parent_  := rec_.parent;         
    contexts_.c_main_type_ :=rec_.main_type;
    contexts_.c_sub_type_   :=rec_.sub_type;       
    contexts_.c_path_       := rec_.path;      
    contexts_.c_bulk_ :=rec_.bulk;              
    contexts_.c_write_protect_  :=rec_.write_protect;
    contexts_.c_obsolete_ :=rec_.obsolete;
    Bulk_Export_Lng2_(contexts_,1,1,1,0,0); 
   END LOOP;
   IF ((length(str_export_file_) > 0) OR (str_export_file_ IS NOT NULL))  THEN        
        dbms_lob.append(export_file_, str_export_file_);
        str_export_file_ := NULL;
        context_written_ := TRUE;
   END IF;     

   IF context_written_ THEN
      IF (return_clob_) THEN
         file_content_ := export_file_;
      ELSE
        INSERT INTO LANGUAGE_FILE_EXPORT_TAB(rowversion,created_by,created_date,file_id,component,language_code,exported_file) 
        VALUES(1,NULL,NULL,file_id_,component_,'en',export_file_);
      END IF;
      
      --log the exporting lng files
      sub_type_reg_ := replace(sub_type_reg_, ' ', '') ;
      Register_Destination_(component_||in_main_type_,component_,'LF','G', sub_type_reg_, in_content_);
   END IF;
    
END Bulk_Export_Lng_;

FUNCTION Bulk_Export_Clob_Lng_ (
   component_     IN VARCHAR2,
   layer_         IN VARCHAR2,
   in_main_type_  IN VARCHAR2,
   in_sub_type_   IN VARCHAR2,
   in_content_    IN VARCHAR2 DEFAULT '') RETURN CLOB
IS
   file_    CLOB;
BEGIN 
   Bulk_Export_Lng_ (file_, TRUE, '', component_, layer_, in_main_type_, in_sub_type_, in_content_ );
   RETURN file_;
END Bulk_Export_Clob_Lng_;
  
@UncheckedAccess
PROCEDURE Bulk_Export_Trs_ (
   file_id_         IN VARCHAR2,
   component_       IN VARCHAR2,
   trs_lang_        IN VARCHAR2,
   layer_           IN VARCHAR2,
   in_main_type_    IN VARCHAR2,
   in_sub_type_     IN VARCHAR2,
   in_content_      IN VARCHAR2 DEFAULT '')

IS
   file_content_ CLOB;
BEGIN
   Bulk_Export_Trs_ (file_content_, FALSE, file_id_, component_, trs_lang_, layer_, in_main_type_, in_sub_type_, in_content_ );
END Bulk_Export_Trs_;

@UncheckedAccess
PROCEDURE Bulk_Export_Trs_ (
   file_content_    OUT CLOB,
   return_clob_     IN BOOLEAN,
   file_id_         IN VARCHAR2,
   component_       IN VARCHAR2,
   trs_lang_        IN VARCHAR2,
   layer_           IN VARCHAR2,
   in_main_type_    IN VARCHAR2,
   in_sub_type_     IN VARCHAR2,
   in_content_      IN VARCHAR2 DEFAULT '')
   
  IS
     TYPE contexts IS RECORD(
      c_id_                language_context_tab.context_id%TYPE,
      c_name_              VARCHAR2(2000),
      c_parent_            language_context_tab.parent%TYPE, 
      c_main_type_         language_context_tab.main_type%TYPE,
      c_sub_type_          language_context_tab.sub_type%TYPE,
      c_bulk_              language_context_tab.bulk%TYPE,
      c_write_protect_     language_context_tab.write_protect%TYPE,
      c_obsolete_          language_context_tab.obsolete%TYPE);
      
    sub_type_get_        language_context_tab.sub_type%TYPE;
    sub_type_reg_        language_context_tab.sub_type%TYPE;
    context_found_       BOOLEAN := FALSE;
    context_written_     BOOLEAN := FALSE;
       
    CURSOR get_contexts IS
    SELECT context_id, name, parent, main_type, sub_type, module,
           path, 
           write_protect,obsolete
    FROM language_context_tab
    WHERE module = component_ and parent = 0 and obsolete = 'N'
        AND layer = layer_
        AND main_type = in_main_type_
        AND sub_type like sub_type_get_
        AND sub_type NOT IN ('Iid Element','State')
	ORDER BY nlssort(path, 'nls_sort = binary'),main_type;  

    CURSOR get_contexts_enumerations IS
    SELECT DISTINCT context_id, name, parent, main_type, sub_type, module,
           path, 
           write_protect,obsolete
    FROM language_context_tab
    WHERE parent = 0
    START WITH context_id IN (
      SELECT parent
      FROM language_context_tab
      WHERE module = component_ and obsolete = 'N'
        AND layer = layer_
        AND main_type = in_main_type_
        AND sub_type in ('Iid Element','State'))
    CONNECT BY PRIOR parent = context_id
	ORDER BY nlssort(path, 'nls_sort = binary'),main_type; 
   
    contexts_ contexts;
    export_trs_file_   CLOB;
    str_export_file_ VARCHAR2(5000);

    PROCEDURE Append_File__ (data_ IN VARCHAR2)
    IS
    BEGIN
       IF (length(str_export_file_||data_) > 5000)  THEN
          dbms_lob.append(export_trs_file_, str_export_file_||data_);
          str_export_file_ := NULL;
          context_written_ := TRUE;
       ELSE
          str_export_file_ := str_export_file_||data_;
       END IF;
    END Append_File__;
    
    PROCEDURE Bulk_Export_Trs2_(contexts_ IN  contexts,
                               trs_language_ IN VARCHAR2,
                               sub_context_count_ IN  NUMBER,
                               attribute_id_ IN  NUMBER,
                               property_count_ IN NUMBER,
                               trans_exist_ IN NUMBER,
                               n_level_ IN NUMBER,
                               n_handle_ IN NUMBER)
                          
    IS

        
        CURSOR get_attribute IS
           SELECT a.attribute_id,
                  a.context_id,
                  a.name,
                  a.prog_text prog_text,
                  a.changed,
                  a.method,
                  a.ref_attr,
                  a.obsolete,
                  t.text,
                  a.usage,
                  substr(t.long_text,1,16000) long_text
             FROM language_attribute_tab a, language_translation_tab t
            WHERE a.context_id = contexts_.c_id_ and a.obsolete = 'N'
              AND a.attribute_id = t.attribute_id AND t.lang_code = trs_language_
            ORDER BY nlssort(a.name, 'nls_sort = binary');
        
        CURSOR get_subcontext IS
           SELECT distinct c.context_id, 
                  c.name,
                  c.parent,
                  c.main_type,
                  c.sub_type,
                  c.module,
                  path,
                  c.write_protect,
                  c.obsolete, 
                  a.context_id nAttributeContextIdTmp,
                  a.usage,
                  decode(in_content_,'FieldDescription',
                                     decode(a.usage, 'FALSE', 0, CASE WHEN length(t.long_text)IS NULL THEN 0 ELSE 1 END),
									 decode(t.attribute_id,NULL,0,1)) transExist
             FROM language_context_tab c, language_attribute_tab a, language_translation_tab t
            WHERE c.parent = contexts_.c_id_ and c.obsolete = 'N' 
              AND c.context_id = a.context_id(+) and a.obsolete(+) = 'N'
              AND a.attribute_id = t.attribute_id(+)
              AND t.lang_code(+) = trs_language_
            ORDER BY nlssort(path, 'nls_sort = binary');
        
        CURSOR check_long_subcontext (context_ IN NUMBER)IS
           SELECT Sum(CASE WHEN length(t.long_text) IS NULL THEN 0 ELSE 1 END)
             FROM language_context_tab c, language_attribute_tab a, language_translation_tab t
            WHERE c.obsolete = 'N' 
              AND c.context_id = a.context_id(+) 
              AND a.obsolete(+) = 'N'
              AND a.usage(+) = 'TRUE'
              AND a.attribute_id = t.attribute_id(+)
              AND t.lang_code(+) = trs_language_        
              AND t.long_text(+) IS NOT NULL
            START WITH c.context_id = context_
          CONNECT BY PRIOR c.context_id = parent;
        
        CURSOR check_contexts_enum (context_ IN NUMBER) IS
           SELECT Sum(decode(t.text, NULL, 0, 1))
            FROM language_context_tab c, language_attribute_tab a, language_translation_tab t
           WHERE c.obsolete = 'N'
             AND c.sub_type in ('Iid Element','State')
             AND c.context_id = a.context_id(+) 
             AND a.obsolete(+) = 'N'
             AND a.attribute_id = t.attribute_id(+)
             AND t.lang_code(+) = trs_language_        
             AND t.text(+) IS NOT NULL
           START WITH c.context_id = context_
         CONNECT BY PRIOR c.context_id = parent;
        
        CURSOR check_contexts (context_ IN NUMBER) IS
           SELECT Sum(decode(t.text, NULL, 0, 1))
             FROM language_context_tab c, language_attribute_tab a, language_translation_tab t
            WHERE c.obsolete = 'N'
              AND ((c.main_type <> 'SVC' AND c.sub_type NOT IN ('Iid Element','State')) OR main_type = 'SVC')
              AND c.context_id = a.context_id(+) 
              AND a.obsolete(+) = 'N'
              AND a.attribute_id = t.attribute_id(+)
              AND t.lang_code(+) = trs_language_        
              AND t.text(+) IS NOT NULL
            START WITH c.context_id = context_
          CONNECT BY PRIOR c.context_id = parent;
        
        child_contexts_ contexts;
        indent_           VARCHAR2(20) := '';
        indent_child_     VARCHAR2(20) := '';
        ncounter_         NUMBER :=0;
        context_start_    VARCHAR2(2) := 'CS';
        context_end_      VARCHAR2(2) := 'CE';
        attrib_           VARCHAR2(1) := 'A';
        field_desc_       VARCHAR2(1) := 'D';
        prog_             VARCHAR2(1) := 'P';
        delimeter_key_    VARCHAR2(1) := ':';
        delimeter_pack_   VARCHAR2(1) := '^';
        count_subcontext_ NUMBER :=0;
        count_property_   NUMBER :=0;
        trans_found_      NUMBER :=0;
                                 
    BEGIN
    WHILE (ncounter_ < n_level_) LOOP
    indent_ := indent_ || CHR(9);
    ncounter_ := ncounter_ + 1;
    END LOOP;
    indent_child_ := indent_ ||CHR(9);
    
    IF (contexts_.c_parent_ = 0) THEN
       IF (in_content_ = 'FieldDescription') THEN 
         OPEN check_long_subcontext(contexts_.c_id_);
         FETCH check_long_subcontext INTO trans_found_;
         CLOSE check_long_subcontext;
         IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
            RETURN;
         END IF;
       ELSIF (in_content_ = 'Enumeration') THEN          
         OPEN check_contexts_enum(contexts_.c_id_);
         FETCH check_contexts_enum INTO trans_found_;
         CLOSE check_contexts_enum;
         IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
            RETURN;
         END IF;
       ELSE
         OPEN check_contexts(contexts_.c_id_);
         FETCH check_contexts INTO trans_found_;
         CLOSE check_contexts;
         IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
            RETURN;
         END IF;
       END IF;
    END IF;
     
    IF (sub_context_count_ > 0 OR trans_exist_ > 0  OR property_count_ > 0) THEN
      -- Write context start
      Append_File__(indent_||context_start_||delimeter_key_||Database_SYS.Asciistr(contexts_.c_name_)||delimeter_pack_|| contexts_.c_main_type_||CHR(13)||CHR(10));

      --Write attributes
      IF  (attribute_id_ > 0) THEN
         FOR rec_ IN get_attribute LOOP
            IF (in_content_ = 'FieldDescription') THEN
               IF (rec_.usage = 'TRUE' AND rec_.long_text IS NOT NULL) THEN
                  Append_File__(indent_child_||field_desc_||delimeter_key_||rec_.name||delimeter_pack_|| Code___(Database_SYS.Asciistr(replace(rec_.long_text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
               END IF;   
            ELSE
               IF (in_content_ = 'Enumeration') THEN
                  --Only IID and State if Enumeration selected.
                  IF (contexts_.c_main_type_ = 'LU' AND (contexts_.c_sub_type_ = 'Iid Element' OR contexts_.c_sub_type_ = 'State')) THEN
                     Append_File__(indent_child_||prog_||delimeter_key_||Code___(Database_SYS.Asciistr(replace(rec_.prog_text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
                     Append_File__(indent_child_||attrib_||delimeter_key_||rec_.name||delimeter_pack_||Code___(Database_SYS.Asciistr(replace(rec_.text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));                  
                  END IF;
               ELSE
                  Append_File__(indent_child_||prog_||delimeter_key_||Code___(Database_SYS.Asciistr(replace(rec_.prog_text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
                  Append_File__(indent_child_||attrib_||delimeter_key_||rec_.name||delimeter_pack_||Code___(Database_SYS.Asciistr(replace(rec_.text, '^', 'ChR94')))||delimeter_pack_||CHR(13)||CHR(10));
               END IF;
            END IF;            
         END LOOP;
      END IF;
    
      -- Recursively call this procedure to write all sub-contexts
      IF (sub_context_count_ > 0) THEN
         FOR rec_ IN get_subcontext LOOP
            IF (in_content_ = 'Enumeration') THEN
                  IF (rec_.sub_type != 'Iid Element' AND rec_.sub_type != 'State' OR rec_.transExist = 0) THEN
                  trans_found_ := 0;
                  OPEN check_contexts_enum(rec_.context_id);
                  FETCH check_contexts_enum INTO trans_found_;
                  CLOSE check_contexts_enum;
                  IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
                     CONTINUE;
                  END IF;
               END IF;
            ELSIF (in_content_ = 'FieldDescription' AND contexts_.c_parent_ = 0) THEN 
               trans_found_ := 0;
               OPEN check_long_subcontext(contexts_.c_id_);
               FETCH check_long_subcontext INTO trans_found_;
               CLOSE check_long_subcontext;
               IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
                  CONTINUE;
               END IF;
            ELSE
               trans_found_ := 0;
               OPEN check_contexts(rec_.context_id);
               FETCH check_contexts INTO trans_found_;
               CLOSE check_contexts;
               IF (trans_found_ IS NULL OR trans_found_ = 0) THEN
                  CONTINUE;
               END IF;
            END IF;
            IF (rec_.sub_type in ('Iid Element','State')
               AND (in_content_ IS NULL OR in_content_ != 'Enumeration')
               AND NOT (rec_.main_type = 'SVC' AND rec_.sub_type = 'Iid Element')) THEN
               CONTINUE;
            END IF;            
            count_subcontext_ := to_number(to_char(Language_Context_API.Count_Sub_Contexts_(rec_.context_id)));
            count_property_   := to_number(to_char(Language_Context_API.Count_Properties_(rec_.context_id)));

            IF (count_subcontext_ > 0 OR count_property_ > 0 OR rec_.nAttributeContextIdTmp > 0) THEN
               child_contexts_.c_id_ := rec_.context_id;
               child_contexts_.c_name_ :=rec_.name;
               child_contexts_.c_parent_  := rec_.parent;
               child_contexts_.c_main_type_ :=rec_.main_type;
               child_contexts_.c_sub_type_   :=rec_.sub_type;
               child_contexts_.c_write_protect_  :=rec_.write_protect;
               child_contexts_.c_obsolete_ :=rec_.obsolete;
               Bulk_Export_Trs2_(child_contexts_,trs_language_,count_subcontext_,rec_.nAttributeContextIdTmp,count_property_,rec_.transExist,n_level_+1,n_handle_+1);
            END IF;
         END LOOP;
      END IF;
    
    -- Write context end
      Append_File__(indent_||context_end_||delimeter_key_||CHR(13)||CHR(10));
    END IF;      
    END Bulk_Export_Trs2_; 
    

 PROCEDURE Register_Destination_ (
   name_             IN VARCHAR2,
   module_           IN VARCHAR2,
   main_type_        IN VARCHAR2,
   export_method_    IN VARCHAR2,
   reg_sub_type_     IN VARCHAR2,
   reg_in_content_   IN VARCHAR2)
   
   IS

   PRAGMA AUTONOMOUS_TRANSACTION;

   strproper_ VARCHAR2(1);
   file_name_   VARCHAR2(500);
   
   BEGIN
     file_name_ := name_; 
     strproper_  := UPPER(substr(file_name_,0,1));
     file_name_ :=  LOWER(substr(file_name_,2,length(file_name_)));
     file_name_:= strproper_||file_name_||reg_sub_type_||reg_in_content_||layer_||'.trs';
     language_destination_api.Register__(file_name_,null,module_,main_type_,null,export_method_);
     @ApproveTransactionStatement(2017-01-25,stdafi)
     COMMIT;
   END Register_Destination_;

 BEGIN
    IF in_main_type_ = 'LU' THEN
       sub_type_get_ := in_sub_type_;
       sub_type_reg_ := in_sub_type_;
    ELSE
       sub_type_get_ := '%';
       sub_type_reg_ := 'All';
    END IF;  
    
    IF sub_type_get_ = 'All' THEN
       sub_type_get_ := '%';
    END IF; 

    export_trs_file_ := Bulk_Export_Trs_Initialize___(component_,trs_lang_,layer_, in_main_type_, sub_type_reg_, in_content_);
    IF (in_content_ = 'Enumeration') THEN
       FOR rec_ IN get_contexts_enumerations LOOP
         context_found_ := TRUE;
         contexts_.c_id_ := rec_.context_id;               
         contexts_.c_name_ :=rec_.name;            
         contexts_.c_parent_  := rec_.parent;         
         contexts_.c_main_type_ :=rec_.main_type;
         contexts_.c_sub_type_   :=rec_.sub_type;       
         contexts_.c_write_protect_  :=rec_.write_protect;
         contexts_.c_obsolete_ :=rec_.obsolete;
         Bulk_Export_Trs2_(contexts_,trs_lang_,1,1,1,1,0,0);
       END LOOP;
    ELSE
       FOR rec_ IN get_contexts LOOP
         IF (rec_.sub_type in ('Iid Element','State') AND (in_content_ IS NULL OR in_content_ != 'Enumeration')) THEN
            CONTINUE;
         END IF;
         context_found_ := TRUE;
         contexts_.c_id_ := rec_.context_id;               
         contexts_.c_name_ :=rec_.name;            
         contexts_.c_parent_  := rec_.parent;         
         contexts_.c_main_type_ :=rec_.main_type;
         contexts_.c_sub_type_   :=rec_.sub_type;       
         contexts_.c_write_protect_  :=rec_.write_protect;
         contexts_.c_obsolete_ :=rec_.obsolete;
         Bulk_Export_Trs2_(contexts_,trs_lang_,1,1,1,1,0,0);
      END LOOP; 
    END IF;
   IF ((length(str_export_file_) > 0) OR (str_export_file_ IS NOT NULL))  THEN
        dbms_lob.append(export_trs_file_, str_export_file_);
        str_export_file_ := NULL;
        context_written_ := TRUE;
   END IF;
   
   --IF context_found_ THEN
   IF context_written_ THEN
      IF (return_clob_) THEN
         file_content_ := export_trs_file_;
      ELSE
         INSERT INTO LANGUAGE_FILE_EXPORT_TAB(rowversion,created_by,created_date,file_id,component,language_code,exported_file) 
         VALUES(1,NULL,NULL,file_id_,component_,trs_lang_,export_trs_file_);
      END IF;

      --log the exporting trs files
      Register_Destination_(component_||trs_lang_||in_main_type_,component_,'TF','G',sub_type_reg_,in_content_);
   END IF;
   
END Bulk_Export_Trs_;

FUNCTION Bulk_Export_Clob_Trs_ (
   component_       IN VARCHAR2,
   trs_lang_        IN VARCHAR2,
   layer_           IN VARCHAR2,
   in_main_type_    IN VARCHAR2,
   in_sub_type_     IN VARCHAR2,
   in_content_      IN VARCHAR2 DEFAULT '') RETURN CLOB
   
IS
   file_     CLOB;
BEGIN 
   Bulk_Export_Trs_ (file_, TRUE, '', component_, trs_lang_, layer_, in_main_type_, in_sub_type_, in_content_ );
   RETURN file_;
END Bulk_Export_Clob_Trs_;
  
@UncheckedAccess
PROCEDURE Bulk_Export_TT_ (
   file_id_     IN VARCHAR2,
   component_   IN VARCHAR2,
   trs_lang_    IN VARCHAR2,
   type_        IN VARCHAR2, 
   layer_       IN VARCHAR2)

IS
   file_content_ CLOB;
BEGIN
   Bulk_Export_TT_ (file_content_, FALSE, file_id_, component_, trs_lang_, type_, layer_);
END Bulk_Export_TT_;

@UncheckedAccess
PROCEDURE Bulk_Export_TT_ (
   file_content_  OUT CLOB,
   return_clob_   IN BOOLEAN,
   file_id_       IN VARCHAR2,
   component_     IN VARCHAR2,
   trs_lang_      IN VARCHAR2,
   type_          IN VARCHAR2, 
   layer_         IN VARCHAR2)
 IS
     TYPE contexts IS RECORD(
      c_id_                language_context_tab.context_id%TYPE,
      c_name_              language_context_tab.name%TYPE,
      c_parent_            language_context_tab.parent%TYPE,
      c_main_type_         language_context_tab.main_type%TYPE,
      c_sub_type_          language_context_tab.sub_type%TYPE,
      c_path_              language_context_tab.path%TYPE,
      c_write_protect_     language_context_tab.write_protect%TYPE,
      c_obsolete_          language_context_tab.obsolete%TYPE);

      CURSOR  get_contexts IS
      SELECT context_id, Database_SYS.Asciistr(name) name, parent, main_type, sub_type, module, path, write_protect, obsolete
        FROM language_context_tab
        WHERE module = component_ and main_type = type_ and parent = 0 and obsolete = 'N'
        AND layer = layer_;
      
      contexts_ contexts;
      export_file_   CLOB ;
      export_file_name_  VARCHAR2(200);
      str_export_file_ xmldom.DOMDocument;
      main_node_ xmldom.DOMNode;
      root_node_ xmldom.DOMNode;
      root_elmt_ xmldom.DOMElement;
      context_node_ xmldom.DOMNode;
     
   PROCEDURE Bulk_Export_TT_Initialize___(component_ IN  VARCHAR2,trs_language_ IN VARCHAR2,type_ IN VARCHAR2, layer_ IN VARCHAR2) 
   IS
      
    BEGIN
       
        str_export_file_ := xmldom.newDOMDocument;
        xmldom.setVersion(str_export_file_, '1.0');
        xmldom.setCharset(str_export_file_ , 'UTF-8');
        main_node_ := xmldom.makeNode(str_export_file_);
        root_elmt_ := xmldom.createElement(str_export_file_,'TextTranslation');
        xmldom.setAttribute( root_elmt_, 'version' ,'1.0');
        xmldom.setAttribute( root_elmt_, 'language' ,trs_language_);
        xmldom.setAttribute( root_elmt_, 'module' ,component_);
        xmldom.setAttribute( root_elmt_, 'type' ,type_);
        xmldom.setAttribute( root_elmt_, 'layer' ,layer_);
        root_node_ := xmldom.appendChild(main_node_, xmldom.makeNode(root_elmt_));


    END Bulk_Export_TT_Initialize___;
    
    
    PROCEDURE XML_Context___(doc_ xmldom.DOMDocument,context_node2_ xmldom.DOMNode,tag_ IN  VARCHAR2,attr_value_ IN  VARCHAR2)
     IS
     
      item_elmt_ xmldom.DOMElement;
       
     BEGIN
      
       IF attr_value_ IS NOT NULL THEN
          item_elmt_ := xmldom.createElement(doc_,tag_);
          xmldom.setAttribute(item_elmt_,'name' ,attr_value_); 
          IF xmldom.isNull(context_node2_)  THEN
             context_node_ := xmldom.appendChild(root_node_, xmldom.makeNode(item_elmt_));
          ELSE
           context_node_ := xmldom.appendChild(context_node2_, xmldom.makeNode(item_elmt_));
          END IF;
       END IF;
         
     END XML_Context___;
     
     PROCEDURE XML_Property___(doc_ xmldom.DOMDocument, context_node_ xmldom.DOMNode,tag_ IN  VARCHAR2,attr_value_ IN  VARCHAR2,value_ IN VARCHAR2)
     IS
     
      item_elmt_ xmldom.DOMElement;
      item_text_ xmldom.DOMText;
      item_node_ xmldom.DOMNode;
      attribute_node_ xmldom.DOMNode;
     
      BEGIN
     
      IF attr_value_ IS NOT NULL THEN
          item_elmt_ := xmldom.createElement(doc_,tag_);
          xmldom.setAttribute(item_elmt_,'name' ,attr_value_); 
          attribute_node_ := xmldom.appendChild(context_node_, xmldom.makeNode(item_elmt_));
          item_text_ := xmldom.createTextNode(doc_,value_);
          item_node_ := xmldom.appendChild( attribute_node_ , xmldom.makeNode(item_text_) );
    
      END IF;
     
     END XML_Property___;
     
           
     PROCEDURE XML_Attribute___(doc_ xmldom.DOMDocument,context_node_ xmldom.DOMNode,tag_ IN  VARCHAR2,attr_value_ IN  VARCHAR2,value_ IN VARCHAR2)
     IS
    
      item_elmt_ xmldom.DOMElement;
      attribute_node_ xmldom.DOMNode;
      item_text_ xmldom.DOMText;
      item_node_ xmldom.DOMNode;
    
     BEGIN
     
      IF attr_value_ IS NOT NULL THEN
          item_elmt_ := xmldom.createElement(doc_,tag_);
          xmldom.setAttribute(item_elmt_,'name' ,attr_value_);
          attribute_node_ := xmldom.appendChild(context_node_, xmldom.makeNode(item_elmt_));
          item_elmt_ := xmldom.createElement(doc_,'Text');
          item_node_ := xmldom.appendChild(attribute_node_, xmldom.makeNode(item_elmt_));
          item_text_ := xmldom.createTextNode(doc_,value_);
          item_node_ := xmldom.appendChild( item_node_ , xmldom.makeNode(item_text_) );
     
      END IF;
    
     END XML_Attribute___;
      
      PROCEDURE Bulk_Export_TT2_(contexts_ IN  contexts,
                                 context_node2_ xmldom.DOMNode,
                                 sub_context_count_ IN  NUMBER,
                                 property_count_ IN  NUMBER,
                                 attribute_count_ IN  NUMBER,
                                 trs_language_ IN VARCHAR2)

      IS
              CURSOR   get_propery IS           
              SELECT context_id, name, value
		         	FROM language_property_tab a
		          WHERE context_id = contexts_.c_id_;

              CURSOR   get_attribute IS
              SELECT a.attribute_id, a.context_id, a.name, a.prog_text, a.changed, a.method, a.ref_attr, a.obsolete, t.text, t.status
		          FROM language_attribute_tab a, 
		               language_translation_tab t
		          WHERE a.context_id = contexts_.c_id_ and a.obsolete = 'N'
		          AND a.attribute_id = t.attribute_id (+)
		          AND ( t.lang_code = trs_language_  OR t.lang_code IS NULL );


              CURSOR  get_subcontext IS           
              SELECT context_id, a.name, parent, main_type, sub_type, module, path, write_protect, obsolete
		          FROM language_context_tab a
		          WHERE parent = contexts_.c_id_ and obsolete = 'N' ;

              child_contexts_               contexts;
              property_count_value_         NUMBER;
              attribute_count_value_        NUMBER;
              child_context_node_           xmldom.DOMNode;
  

      BEGIN
      
        property_count_value_  :=  property_count_ ;
        attribute_count_value_ :=  attribute_count_;
        
        IF NOT (contexts_.c_parent_ = 0) THEN
           XML_Context___( str_export_file_,context_node2_,'Context',contexts_.c_name_);
           child_context_node_ := context_node_;
        ELSE
            property_count_value_  :=0;
            attribute_count_value_ :=0;
        END IF;
      
      -- Write properties
      IF ( property_count_value_ > 0) THEN
         FOR rec_ IN get_propery LOOP
               XML_Property___( str_export_file_,child_context_node_,'Property',Database_SYS.Asciistr(rec_.name),Database_SYS.Asciistr(rec_.value));
          END LOOP;
      END IF;

      --Write attributes
      IF  (attribute_count_value_ > 0) THEN
          FOR rec_ IN get_attribute LOOP         
              XML_Attribute___(str_export_file_,child_context_node_,'Attribute',Database_SYS.Asciistr(rec_.name),rec_.text);
          END LOOP;
      END IF;

      -- Recursively call this procedure to write all sub-contexts
      
      IF  (sub_context_count_ > 0) THEN
          FOR rec_ IN get_subcontext LOOP
             DECLARE
               count_subcontext_ NUMBER := TO_NUMBER(TO_CHAR(Language_Context_API.Count_Sub_Contexts_(rec_.context_id)));
				   count_property_   NUMBER := TO_NUMBER(TO_CHAR(Language_Context_API.Count_Properties_(rec_.context_id)));
             BEGIN		  
 			      child_contexts_.c_id_            := rec_.context_id;
 			      child_contexts_.c_name_          := Database_SYS.Asciistr(rec_.name);
  			      child_contexts_.c_parent_        := rec_.parent;
	  		      child_contexts_.c_main_type_     := rec_.main_type;
		  	      child_contexts_.c_sub_type_      := rec_.sub_type;
			      child_contexts_.c_path_          := rec_.path;
			      child_contexts_.c_write_protect_ := rec_.write_protect;
			      child_contexts_.c_obsolete_      := rec_.obsolete;
			    Bulk_Export_TT2_(child_contexts_, child_context_node_, count_subcontext_, count_property_, 1, trs_language_);
		     END;
       END LOOP;
      END IF;

    END Bulk_Export_TT2_;

    PROCEDURE Bulk_Export_TT_CBS_(contexts_ IN  contexts,
                                 context_node2_ xmldom.DOMNode,
                                 sub_context_count_ IN  NUMBER,
                                 property_count_ IN  NUMBER,
                                 attribute_count_ IN  NUMBER,
                                 trs_language_ IN VARCHAR2)

      IS
              CURSOR   get_propery IS           
              SELECT context_id, name, value
		          FROM language_property_tab a
		          WHERE context_id = contexts_.c_id_;

              CURSOR   get_attribute IS
              SELECT a.attribute_id, a.context_id, a.name, a.prog_text, a.changed, a.method, a.ref_attr, a.obsolete, nvl(t.text, a.prog_text) text, t.status
		          FROM language_attribute_tab a, 
		               language_translation_tab t
		          WHERE a.context_id = contexts_.c_id_ and a.obsolete = 'N'
		          AND a.attribute_id = t.attribute_id (+)
		          AND t.lang_code (+) = trs_language_;


              CURSOR  get_subcontext IS           
              SELECT context_id, name, parent, main_type, sub_type, module, path, write_protect, obsolete
		          FROM language_context_tab a
		          WHERE parent = contexts_.c_id_ and obsolete = 'N';

              child_contexts_               contexts;
              property_count_value_         NUMBER;
              attribute_count_value_        NUMBER;
              child_context_node_           xmldom.DOMNode;
              
              count_subcontext_             NUMBER;
              count_property_               NUMBER;
              count_attributes_             NUMBER;

      BEGIN
      
        property_count_value_  :=  property_count_ ;
        attribute_count_value_ :=  attribute_count_;
        
        IF NOT (contexts_.c_parent_ = 0) THEN
           XML_Context___( str_export_file_,context_node2_,'Context',contexts_.c_name_);
           child_context_node_ := context_node_;
        ELSE
            property_count_value_  :=0;
            attribute_count_value_ :=0;
        END IF;
      
      -- Write properties
      IF ( property_count_value_ > 0) THEN
         FOR rec_ IN get_propery LOOP
               XML_Property___( str_export_file_,child_context_node_,'Property',Database_SYS.Asciistr(rec_.name),Database_SYS.Asciistr(rec_.value));
          END LOOP;
      END IF;

      --Write attributes
      IF  (attribute_count_value_ > 0) THEN
          FOR rec_ IN get_attribute LOOP         
              XML_Attribute___(str_export_file_,child_context_node_,'Attribute',Database_SYS.Asciistr(rec_.name),rec_.text);
          END LOOP;
      END IF;

      -- Recursively call this procedure to write all sub-contexts
      
      IF  (sub_context_count_ > 0) THEN
         FOR rec_ IN get_subcontext LOOP
            child_contexts_.c_id_ := rec_.context_id;
            child_contexts_.c_name_ :=Database_SYS.Asciistr(rec_.name);
            child_contexts_.c_parent_  := rec_.parent;
            child_contexts_.c_main_type_ :=rec_.main_type;
            child_contexts_.c_sub_type_   :=rec_.sub_type;
            child_contexts_.c_path_       := rec_.path;
            child_contexts_.c_write_protect_  :=rec_.write_protect;
            child_contexts_.c_obsolete_ :=rec_.obsolete;
            count_subcontext_ := to_number( to_char(Language_Context_API.Count_Sub_Contexts_( rec_.context_id ) ) );
            count_property_   :=  to_number( to_char(Language_Context_API.Count_Properties_( rec_.context_id ) ) );
            count_attributes_ := to_number( to_char(Language_Context_API.Count_Attributes_( rec_.context_id ) ) );
            Bulk_Export_TT_CBS_(child_contexts_,child_context_node_,count_subcontext_,count_property_,1,trs_language_);
         END LOOP;
      END IF;

    END Bulk_Export_TT_CBS_;

BEGIN
   FOR rec_ IN get_contexts LOOP
       Bulk_Export_TT_Initialize___(component_,trs_lang_,type_, layer_);       
       contexts_.c_id_ := rec_.context_id;
       contexts_.c_name_ :=rec_.name;
       contexts_.c_parent_  := rec_.parent;
       contexts_.c_main_type_ :=rec_.main_type;
       contexts_.c_sub_type_   :=rec_.sub_type;
       contexts_.c_path_       := rec_.path;
       contexts_.c_write_protect_  :=rec_.write_protect;
       contexts_.c_obsolete_ :=rec_.obsolete;

       IF (component_ = 'CBS' AND type_ = 'VC') THEN
         Bulk_Export_TT_CBS_(contexts_,root_node_,1,1,1,trs_lang_);
       ELSE
         Bulk_Export_TT2_(contexts_,root_node_,1,1,1,trs_lang_);
       END IF;
        
       export_file_ :=' ';
       export_file_name_ := contexts_.c_name_ ;
       xmldom.writeToClob( str_export_file_,export_file_,'UTF-8');
       IF (return_clob_) THEN
         file_content_ := file_content_||'FileName:'||export_file_name_||CHR(13)||CHR(10)||export_file_;
       ELSE
          INSERT INTO LANGUAGE_FILE_EXPORT_TAB(rowversion,created_by,created_date,file_id,component,language_code,exported_file)
          VALUES(1,null,NULL,export_file_name_,component_,trs_lang_,export_file_);
       END IF;
       xmldom.freeDocument(str_export_file_);

   END LOOP;

   --log the exporting trs files
   --Register_Destination_(component_||trs_lang_,component_,'TF','G');


END Bulk_Export_TT_;

FUNCTION Bulk_Export_Clob_TT_ (
   component_   IN VARCHAR2,
   trs_lang_    IN VARCHAR2,
   type_        IN VARCHAR2, 
   layer_       IN VARCHAR2) RETURN CLOB
   
IS
   file_             CLOB;
BEGIN
   Bulk_Export_TT_ (file_, TRUE, '',component_, trs_lang_, type_, layer_);
   RETURN file_;
END Bulk_Export_Clob_TT_;   
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Translate_Item_Prompt (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Translate_Item_Prompt_(lu_name_, item_, lang_code_));
END Translate_Item_Prompt;

-- Translate_Constant
--   Server constant definitions made in packages. To be used when
--   a language independent constant should be defined.
@UncheckedAccess
FUNCTION Translate_Constant (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   msgkey_ VARCHAR2(40);
   text_   VARCHAR2(2000);
BEGIN
   msgkey_ := rtrim(substr(err_text_, 1, instr(err_text_, ':')-1));
   text_ := Lookup___('Message', lu_name_||'.'||msgkey_, 'Text', nvl(lang_code_,Get_Language), 'LU');
   text_ := nvl(text_, ltrim(substr(err_text_, instr(err_text_, ':')+1)));
   text_ := replace(text_, ':P1', p1_);
   text_ := replace(text_, ':P2', p2_);
   text_ := replace(text_, ':P3', p3_);
   RETURN(text_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(service_, 'LABEL_ERR: The label [:P1] is too long, it can only be 40 characters long.', rtrim(substr(err_text_, 1, instr(err_text_, ':')-1)));      
END Translate_Constant;



-- Translate_Report_Text
--   Report text constants from logical unit ReportText.
@UncheckedAccess
FUNCTION Translate_Report_Text (
   lu_name_       IN VARCHAR2,
   report_id_     IN VARCHAR2,
   variable_name_ IN VARCHAR2,
   variable_text_ IN VARCHAR2,
   lang_code_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Translate_Report_Text_(lu_name_, report_id_, variable_name_, variable_text_, lang_code_));
END Translate_Report_Text;



-- Set_Language
--   Set current language (used from client).
PROCEDURE Set_Language (
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Set_Language');
   IF (lang_code_ IS NOT NULL) THEN
      Fnd_Session_API.Set_Language(lang_code_);
   END IF;
END Set_Language;


PROCEDURE Cleanup (
   module_                 IN VARCHAR2,
   lang_code_              IN VARCHAR2,
   path_                   IN VARCHAR2 DEFAULT NULL,
   type_                   IN VARCHAR2 DEFAULT NULL )
IS
   wildcard_path_     VARCHAR2(500);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Cleanup');
   wildcard_path_ := path_||'.%';
   IF (type_ IS NOT NULL AND path_ IS NOT NULL AND lang_code_ IS NOT NULL AND module_ IS NOT NULL) THEN
      DELETE FROM LANGUAGE_SYS_TAB
         WHERE ( PATH LIKE wildcard_path_ )
           AND LANG_CODE = lang_code_
           AND TYPE = type_
           AND MAIN_TYPE = 'LU';
   ELSIF (type_ IS NULL AND path_ IS NOT NULL AND lang_code_ IS NOT NULL) THEN
      DELETE /*+ INDEX (LANGUAGE_SYS_TAB LANGUAGE_SYS_IX) */
         FROM LANGUAGE_SYS_TAB
         WHERE ( PATH LIKE wildcard_path_ OR PATH = path_ )
         AND LANG_CODE = lang_code_
         AND type <> 'Basic Data'
         AND MAIN_TYPE='LU';
   ELSIF (type_ IS NULL AND path_ IS NULL AND lang_code_ IS NOT NULL AND module_ IS NOT NULL) THEN
      DELETE FROM LANGUAGE_SYS_TAB
         WHERE MODULE = module_
         AND LANG_CODE = lang_code_
         AND type <> 'Basic Data'
         AND MAIN_TYPE='LU';
      Basic_Data_Translation_API.Cleanup(module_, lang_code_);
   END IF;
END Cleanup;


PROCEDURE Remove_Module_ (
   module_     IN VARCHAR2 )
IS
BEGIN
   DELETE FROM LANGUAGE_SYS_TAB
      WHERE module = module_; 
END Remove_Module_;

-- Get_Language
--   Return current language (used from server).
@UncheckedAccess
FUNCTION Get_Language RETURN VARCHAR2
IS
BEGIN
   RETURN(Fnd_Session_API.Get_Language);
END Get_Language;



@UncheckedAccess
FUNCTION Get_Print_Language RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Language;
END Get_Print_Language;



PROCEDURE Insert_Translation (
   type_                   IN VARCHAR2,
   path_                   IN VARCHAR2,
   attribute_              IN VARCHAR2,
   lang_code_              IN VARCHAR2,
   module_                 IN VARCHAR2,
   text_                   IN VARCHAR2 )
IS
   text_unicode_ language_sys_tab.text%TYPE := Database_Sys.Unistr(text_);
   path_unicode_ language_sys_tab.path%TYPE := Database_Sys.Unistr(path_);
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Insert_Translation');
   IF (type_ = 'Basic Data' OR type_ = 'Component Translation') THEN
      Basic_Data_Translation_API.Set_System_Translation(module_, path_unicode_, lang_code_, text_unicode_);
   ELSE
      INSERT
         INTO language_sys_tab (
            main_type,
            type,
            path,
            attribute,
            lang_code,
            module,
            text,
            installation_text,
            system_defined,
            bulk,
            rowversion)
         VALUES (
            'LU',
            type_,
            path_unicode_,
            attribute_,
            lang_code_,
            module_,
            text_unicode_,
            text_unicode_,
            'TRUE',
            '0',
            SYSDATE);
   END IF;
END Insert_Translation;


@UncheckedAccess
PROCEDURE Exist (
   lang_code_ IN VARCHAR2 )
IS
   dummy_ VARCHAR2(10);
   CURSOR check_lang IS
      SELECT 1
      FROM language_sys_tab
      WHERE lang_code = lang_code_;
BEGIN
   IF (lang_code_ IS NOT NULL) AND (lang_code_ != '%') THEN
      OPEN check_lang;
      FETCH check_lang INTO dummy_;
      IF (check_lang%NOTFOUND) THEN
         CLOSE check_lang;
         Error_SYS.Appl_General(service_, 'LNGCODEERROR: The language code ":P1" does not exist in the translation database.', lang_code_);
      END IF;
      CLOSE check_lang;
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Lookup (
   type_      IN VARCHAR2,
   path_      IN VARCHAR2,
   attribute_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   main_type_ IN VARCHAR2 DEFAULT 'LU' ) RETURN VARCHAR2
IS
BEGIN
   RETURN Lookup___(type_, path_, attribute_, lang_code_, main_type_);
END Lookup;

@UncheckedAccess
FUNCTION Field_Lookup (
   type_      IN VARCHAR2,
   path_      IN VARCHAR2,   
   lang_code_ IN VARCHAR2,
   main_type_ IN VARCHAR2) RETURN VARCHAR2
IS
   var_main_type_    language_sys_tab.main_type%TYPE;
   text_             VARCHAR2(2000);
   CURSOR get_trans IS
      SELECT  text /*+ INDEX(language_sys_tab language_sys_ix2)*/ 
        FROM  language_sys_tab
       WHERE  main_type = var_main_type_
         AND  type = type_
         AND  path = path_
         AND  lang_code = lang_code_;
BEGIN
   IF (main_type_ = 'SVC' AND type_ = 'Message') THEN
      var_main_type_ := 'LU';
   ELSE
      var_main_type_ := main_type_;
   END IF;
   OPEN get_trans;
   FETCH get_trans INTO text_;
   CLOSE get_trans;
   RETURN(text_);
END Field_Lookup;

@UncheckedAccess
FUNCTION Field_Description_Lookup(
   path_   IN VARCHAR2,
   language_code_ IN VARCHAR2, 
   main_type_ IN VARCHAR2 DEFAULT 'WEB') RETURN VARCHAR2
IS
   text_ VARCHAR2 (32000);
   CURSOR get_field_trans IS
      SELECT field_desc_trans
        FROM field_description_translation
       WHERE main_type = main_type_
         AND path = path_
         AND lang_code = language_code_;
BEGIN 
   OPEN get_field_trans;
   FETCH get_field_trans INTO text_;
   CLOSE get_field_trans;
   RETURN(text_);
END Field_Description_Lookup;

@UncheckedAccess
FUNCTION Get_Display_Name_By_Handl_Id (
   version_handling_id_ IN VARCHAR2,
   display_type_        IN VARCHAR2,
   lang_code_           IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
BEGIN
   -- Obsolete.
   -- Should be removed to release
   RETURN NULL; 
END Get_Display_Name_By_Handl_Id;

PROCEDURE Cleanup_Basic_Data_Imp (
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'LANGUAGE_SYS', 'Cleanup_Basic_Data_Imp');
   Basic_Data_Translation_API.Cleanup_Basic_Data_Imp__(module_,
                                                       language_code_);
END Cleanup_Basic_Data_Imp;



