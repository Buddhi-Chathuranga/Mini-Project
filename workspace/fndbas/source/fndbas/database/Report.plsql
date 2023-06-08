-----------------------------------------------------------------------------
--
--  Logical unit: Report
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960220  MANY  Created.
--                Public methods: Run_Report, Parse_Column_Where, Parse_Where
--  960418  ERFO  Added global variables for standard system services.
--  960423  MANY  Fixed som typing errors in Enumerate_% methods.
--  960424  MANY  Fixed missing information problem with reports, using extra
--                attribute strings for report-level information (in Run_Report
--                and others).
--  960426  MANY  Moved method Get_Item_Value to system service Client_SYS.
--  960429  ERFO  Removed global service_ from package Report2_SYS.
--                Re-arrangments when calling General_SYS.Init_method and
--                call to Report_SYS.
--  960507  MANY  Fixed bug in ParseColumnWhere() with wildcards.
--  960509  MANY  Fixed bug in Get_Report_Text(), now returns translation.
--                Fixed missing identifiers for Error_SYS.Appl_General errors.
--  960526  MANY  Fixed bug concerning the order for report columns (bug in Oracle)
--                for system view user_col_comments.
--                Added some traces when executing reports.
--  960626  MANY  Fixed bug in Get_Layout_Title(), when using several layouts.
--  960726  MANY  Modified Parse_Where_Expression_() to return a WHERE-expression
--                and rerouted report where-parsing to the new method
--                Parse_Report_Where_Expression_().
--                Modified Get_Layout_Title() and Enumerate_Report_Layouts_() to
--                conform to new syntax.
--  960814  MANY  Modified all Get_Report methods to return PROG-values.
--  960816  MANY  Added method Method_Exist(), check if method actually exist
--                in database before using dynamic sql.
--                Added improved exception handling for reports.
--                Added method Ora_Error() to imrove the presentation of raised
--                exceptions.
--                Moved Run_1_1___() and Run_1_2___() to package Report3_SYS
--                due to package size problem.
--  960824  MANY  Added method Get_Result_Key__() and modified method Run_Report()
--                to accept MODE=LOG.
--  960911  ERFO  Added timestamp information to trace messages (Idea #586).
--  961029  MANY  Added new method Run_Group()
--  961102  MANY  Added methods Define_Group() and Define_Group_Column()
--  961103  MANY  Added methods Parse_Parameter() [overloading DATE,NUMBER,VARCHAR2]
--                for advanced wherestatement-parsing in PLSQL cursors.
--  961106  MANY  Added method Get_Logical_Unit_Groups(), for Localization and
--                future Security.
--                Changes to accommodate for report groups.
--  961111  MANY  Added method Get_Last_Ddl_Time(), used in conjunction with
--                cache'ing to refresh report cache when needed.
--  961114  MANY  Added method Enumerate_Report_Groups_()
--  970403  ERFO  Removed third parameter in method Comment_Value_.
--  970806  MANY  Fixed bugg #1513 in method Run_Plsql concerning calling procedures
--                with no parameters.
--                Implementation of new public method Get_Translated_Text()
--  970809  MANY  Implementation of new methods Refresh_Active_List__(0) and
--                Refresh_(report_id_), cache handling for reports.
--  970824  MANY  Modified refresh_ methos to only update if user is app_owner.
--  970824  MANY  Added meaningfull error messages to Refresh_ methods, to simplify
--                debugging.
--  971009  MANY  Changes to Delet_From_Table___(), avoiding possibility for infinite loop
--                if report has invalid comments. ToDo #1693.
--  971021  MANY  Added public versions of Run_PLSQL__(), Parse_Column_Where_(),
--                Parse_Where_Expression_() and Parse_Report_Where_Expression_().
--  971023  MANY  Removed unreleased bug in Enumerate_Report_Layouts_() due to new
--                cache handling.
--  971124  MANY  Improved error messages for method Refresh_.
--  980204  MANY  Fixed bug #2074, Report_SYS.Refresh_ is case sensitive
--                (should be uppercase) when refreshing cache.
--  980304  MANY  Rewrote Refresh_() to avoid Oracle bug.
--  980325  MANY  Rearrangements in Run_Report(), Remove_Report() and Refresh_()
--                for the integration between IFS/Info Services and
--                IFS/ReportGenerator, ToDo #2282.
--  980527  MANY  Changes tocache tables, added column COMMENTS (ToDo #2453).
--  980724  MANY  Fixes in Delete_From_Table___() concerning illegalusage of
--                INSTR to keep track of already visited tables (Bug #2457).
--  980728  ERFO  Review of English texts by US (ToDo #2497).
--  990525  MANY  Changes in method Refresh_ and Enumerate_Report_Layouts_
--                to include layout information for Project Orion (ToDo #3375).
--  990630  TOFU  Add correct where statement to Define_Group_Column (Bug #3454).
--  990928  ERFO  Changed cursor get_report_columns to solve problem in
--                public method Parse_Report_Where_Expression (Bug #3600).
--  991102  ERFO  Performance issue in Method_Exist (Bug #3679).
--  000509  ROOD  Performance improvement in Delete_From_Table___ (Bug #16093).
--  000821  ROOD  Solved lowercase problem in Get_Table_Comment___ (Bug #16699).
--  001121  MANY  Fixed bug #18387, Case sensitive deletion in Report_SYS.Delete_From_Table__
--  001205  BVLI  Received Orion II + Changed exception in Refresh_Layouts (ToDo #3951).
--  001211  ERFO  Get use of new view FND_TAB_COMMENTS (Bug #18169).
--  010618  ROOD  Modified dynamic PL/SQL to use EXECUTE IMMEDIATE.
--                Removed method Run_Finrep___. Removed PKG2 and PKG3. (ToDo#3992).
--  011126  ROOD  Get use of new view FND_COL_COMMENTS to improve performance.
--                Modified Refresh_Active_List__ to only refresh when necessary (Bug#26328).
--  011205  ROOD  Modified Refresh_Layout_ to handle paper format. Modified
--                Enumerate_Report_Layouts to consider users default paper format (ToDo#4056).
--                Updated template and reorganised.
--  020117  ROOD  Improved error message in Refresh_ (ToDo#4056).
--  020205  ROOD  Added removal of data from report cache for reports not longer used (ToDo#4076).
--  020211  ROOD  Changes to ensure the correct enumerate order of report layouts and
--                to increase the possible length of filename to 50 characters (ToDo#4056).
--  020219  ROOD  Changed concept for enumeration order (ToDo#4056).
--  020528  ROOD  Increased length of layouts and texts (Bug#30434).
--  020610  ROOD  Modifications in Enumerate_Report_Layouts_. This method is only used
--                by Localize and should not contain paper format information (Bug#29955).
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021007  ROOD  Added methods Define_Report_ and Define_Report_Layout_. Modifications
--                in Define_Report_Text_. Added method Definition_Exist___ (GLOB12).
--  021009  ROOD  Added validations for master and override_method (GLOB12).
--  021010  ROOD  Rewrote method Refresh to handle parallel report definition concepts.
--                Affected many other methods too (GLOB12).
--  021018  ROOD  Modified validation in Define_Report_Text_. This interface has to
--                handle both the report definition concepts since it existed before (GLOB12).
--  021111  ROOD  Added default handling of report_mode to simplify for applications (GLOB12).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030616  DOZE  Added layout_type to layouts (ToDo#4274).
--  030925  DOZE  Hardcoded REPORT as user to be used in Request_Formatting
--  030925  MAOL  Changed hardcoded value from REPORT to IFS_PRINT_AGENT
--  031009  ROOD  Added parameters for prompt and status to Enumerate_Report_Columns_.
--                Modified cursor get_report_columns to avoid result_key and row_no's
--  031209  DOZE  Added parameter to Get_Default_Paper_Format to be used from Print Agent
--  030205  DOZE  Changed request_formatting to use XML instead of buffer
--  040305  DOZE  Changed Define_Report_Layout to skip uppercase and call Create_Default method (Bug#42823)
--  040316  ROOD  Added interfaces for Quick Report creation (Bug#42002).
--  040317  MAOL  Altered the layout registration mechanism to preserve the
--                in use flag. We should change this implementation from its
--                current "rename approach" to a insert, update and delete
--                old removed layouts (Bug#43396).
--  040331  HAAR  Unicode bulk changes, extended 1 bind variable length 10 times (F1PR408B).
--  040401  MAOL  Changed implementation of the above bug fix. Report Layout
--                registration (Bug#43999).
--  040602  ROOD  Removed limitation that only appowner can do refresh (F1PR413).
--  040702  ROOD  Added insertion and removal of data in report_in_progress_tmp (Bug#44975).
--  040914  ASWI  Changed methods Should_Generate_Result_Set and Should_Generate_Xml
--                to check for DB values (Bug#44205).
--  040917  MAOL  Added optional In_Use_ parameter to Define_Report_Layout_ (F1PR469).
--  041011  ROOD  Removed unused code in Define_Report_.
--  041015  MAOL  Made sure that only old NONE design time layouts are reomved
--                by the Refresh_ method (Bug#47438)
--  041101  DOZE  Changed Request_Formatting to use printgateway instead of PLSQLAP
--  050408  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050610  ASWI  In Refresh_Active_List__ When considering the last refresh time, only the design
--                time layouts should be taken into account.Modified Refresh_Layout_.(Bug#45279)
--  051110  DOZE  Changed user IFS_PRINT_AGENT to IFSPRINT
--  051129  DOZE  Check layout name for mixed case
--  060105  UTGULK Annotated Sql injection.
--  060214  UTGULK Moved Check_Layout___ method to Report_Layout_Definition.
--  060313  ASWILK Added method Refresh_Rpv_View (Bug#53256).
--  060313  CHAA   Emailing Report Designer type reports
--  060428  NiWi  Modified Parse_Parameter(for number) (Bug#56400).
--  060516  HENJSE  Asserted Run_Plsql__ (Bug#57108).
--  060621  HAAR  Added support for Persian calendar (Bug#58601).
--  060712  HENJSE  Minor changes made to obstruct SQL-injections. (Bug#58228)
--  060901  UsRaLK Modified Should_Generate_Xml and Should_Generate_Result_Set to consider IN USE flag.
--  060904  UTGULK  Added Define_Report_Column_ to be used by Excel reports.Modified Refresh_ and Refresh_Active_List__ 
--                 to stop deleting data related to excel reports.Included  'EXCEL1.0' in Run_Report() (Bug #59182).
--  060927  UTGULK Added method Remove_Report_Definition to be used by EXCEL reports.(Bug #60820).
--  061212  pemase Limit PLSQL_BUFFER_TMP resource utilization. (Bug #61975)
--  070213  pemase Security and quality corrections F1PR447 (Bug #63518).
--  070427  HAAR   Refresh_Rpv_View removes view comments (Bug#65056).
--  070525  SUMA   Changed Assert_SYS.Assert_Match_Regexp in Run_Report method(Bug#64697)
--  070718  UTGULK Extended length of variables params_,param_ and layout_cmd_ in Refresh_Layout_ (Bug#66686).
--  080208  HAARSE Added update of Cache Management when refreshing the cache (Bug#71136).
--  080403  PEMASE Added more secure version of Parse_Where_Expression (Bug#72069)
--  080730  SUBSLK Modified Email_Pdf_File___() to send the attachment name in <report_title>_<resultKey>.pdf format(Bug#74489>
--  080911  HASPLK Modified Get_Ref_Properties__() method to remove delete options from reference.
--  090423  JHMASE Reports not purged from report archive (Bug #82352).
--  091028  DASVSE External RF conncetstring added (Bug #86485).
--  110512  CHAALK Missing layout definitions after removing the definitions from RDF (EASTONE-19174)
--  110926  STDAFI RDTERUNTIME-1112 Performance improvement when building Report cache. 
--                 Removed check on report_sys_layout_tab in Refresh_Active_List__
--  120215  LAKRLK RDTERUNTIME-1846
--  120702  HaMaLK REPORT_SYS.Email_Pdf_File__ variable too short(Bug#103782). 
--  130123  ASIWLK LCS 107984 - Adding and removing Report_Result_Gen_Config on new report definition and removal.
--  130719  NaBaLK Certified assert safe for dynamic SQLs (Bug#111361)
--  130819  MABALK QA script cleanup - Call to General_SYS.Init_Method in procedure (Bug #111927)
--  130930  DASVSE Archive item now created before the RDF call and instead updated in Attach_Report.
--  140129  AsiWLK Merged LCS-111925
--  140207  NaBaLK Modified method Run_Report to use Init_Archive_Item (PBTE-1278)
--  140523  ASIWLK Merged LCS-114359
--  140525  CHAALK Report Life Time set through Solution Manager is always removed when the RDF is redeployed (LCS Merge Bug#116426)
--  151026  MADILK The function Parse_Parameter is changed to accept NULL check (!%) in SQL Quick Report queries
--  151116  CHAALK Ability to hide Operational Reports (Bug ID 125636)
--  170530  CHAALK TEREPORT-2565 Remove ERF
--  180808  CHAALK Garbage data in database for manually obsoleted reports (Bug ID 143438)
--  180918  CHAALK REPORT_SYS.PARSE_PARAMETER function not supporting multiple not equal parameters (Bug ID 143921)
--  190823  MABALK Add domain and category in Aurena for Operational Reports and Quick Reports (TEREPORT-3119)
--  190829  RAKUSE Added Init_Reports_Metadata__, Init_Report_Metadata__ and Register_Custom_Report__ (TEUXXCC-1513)
--  190919  RAKUSE Added Add_To_Args, Arg_Exist & Get_Arg_Value (TEUXXCC-1513)
--  191219  RAKUSE Added mode_ argument to Init_Reports_Metadata (TEAURENAFW-1312)
--  191219  MABALK DUXZREP-307:G2146217-100:Report_SYS.Parse_Parameter not removing spaces like the client does
--  200601  RAKUSE Extended Refresh_ making call to Initialize_Report__ (TEAURENAFW-3026)
--  200913  MABALK Report Projections don't get removed automatically (TEREPORT-3312)
--  210109  MABALK Reports are emailed when clicking "Preview" in Aurena (OR20R1-190)
--  210617  MABALK Scan translatable code show error buffer to small (DUXZREP-562)
--  190821  MABALK  RRE Set Default Property is not working on Aurena
-----------------------------------------------------------------------------
--
--  Dependencies: Error_SYS
--                Dictionary_SYS
--                Client_SYS
--                General_SYS
--                Aurena_Report_Metadata_SYS
--
--  Contents:     Public methods for report processing suppor
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

text_separator_   CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
field_separator_  CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;
group_separator_  CONSTANT VARCHAR2(1) := Client_SYS.group_separator_;

arg_value_separator_      CONSTANT VARCHAR2(1)  := '=';
arg_value_separator_repl_ CONSTANT VARCHAR2(3)  := '~@~';
arg_separator_            CONSTANT VARCHAR2(1)  := ';';
arg_separator_repl_       CONSTANT VARCHAR2(3)  := '~$~';

date_format_ CONSTANT VARCHAR2(20) := 'YYYY-MM-DD';
time_format_ CONSTANT VARCHAR2(20) := 'HH24:MI:SS';
datetime_format_ CONSTANT VARCHAR2(22) := 'YYYY-MM-DD HH24:MI:SS';

TYPE BIGCHAR_ARRAY IS TABLE OF VARCHAR2(32760) INDEX BY BINARY_INTEGER;
TYPE VARCHAR2_ARRAY IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
TYPE NUMBER_ARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE report_coulmn_rec IS RECORD
   (report_id report_sys_column_tab.report_id%TYPE,
    column_name report_sys_column_tab.column_name%TYPE,
    column_id report_sys_column_tab.column_id%TYPE,
    column_title report_sys_column_tab.column_title%TYPE,
    column_prompt report_sys_column_tab.column_prompt%TYPE,
    column_query report_sys_column_tab.column_query%TYPE,
    column_value report_sys_column_tab.column_value%TYPE,
    column_lov report_sys_column_tab.column_lov%TYPE,
    column_flags report_sys_column_tab.column_flags%TYPE,
    column_dataformat report_sys_column_tab.column_dataformat%TYPE,
    column_qflags report_sys_column_tab.column_qflags%TYPE,
    item_name report_sys_column_tab.item_name%TYPE,
    enumerate_method report_sys_column_tab.enumerate_method%TYPE,
    validate_method report_sys_column_tab.validate_method%TYPE,
    status report_sys_column_tab.status%TYPE,
    column_type report_sys_column_tab.column_type%TYPE,
    lov_view report_sys_column_tab.lov_view%TYPE,
    lov_enum report_sys_column_tab.lov_enum%TYPE,
    comments report_sys_column_tab.comments%TYPE);

-------------------- PRIVATE DECLARATIONS -----------------------------------

CURSOR get_reports IS
   SELECT *
   FROM   report_sys_tab;
CURSOR get_report_columns(report_id_ IN VARCHAR2) IS
   SELECT *
   FROM   report_sys_column_tab
   WHERE  report_id = report_id_
   AND    column_name NOT IN ('RESULT_KEY','ROW_NO','PARENT_ROW_NO')
   AND EXISTS (
     SELECT column_name
     FROM   user_tab_cols
     WHERE  user_tab_cols.table_name = report_id_ AND
            user_tab_cols.column_name = report_sys_column_tab.column_name
   )
   ORDER BY column_id;
CURSOR get_lu_reports(lu_name_ IN VARCHAR2) IS
   SELECT report_title,
          lu_name,
          module,
          report_id
   FROM   report_sys_tab
   WHERE  lu_name = lu_name_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Definition_Exist___ (
   report_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   report_sys_tab
      WHERE report_id = report_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist(service_, NULL, report_id_);
   END IF;
   CLOSE exist_control;
END Definition_Exist___;


FUNCTION Get_Report_Definition___ (
   report_id_ IN VARCHAR2 ) RETURN report_sys_tab%ROWTYPE
IS
   report_definition_ report_sys_tab%ROWTYPE;
   CURSOR get_rep_def IS
      SELECT *
      FROM report_sys_tab
      WHERE report_id = report_id_;
BEGIN
   OPEN get_rep_def;
   FETCH get_rep_def INTO report_definition_;
   CLOSE get_rep_def;
   RETURN (report_definition_);
END Get_Report_Definition___;


FUNCTION Get_Datatype___ (
   comment_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   datatype_    VARCHAR2(30);
BEGIN
   datatype_ := nvl(Dictionary_SYS.Comment_Value_('DATATYPE', comment_), 'STRING');
   IF (datatype_ LIKE 'STRING%' OR datatype_ LIKE 'CHAR%' ) THEN
      RETURN ('S');
   ELSIF (datatype_ LIKE 'NUMBER%' ) THEN
      RETURN ('N');
   ELSIF (datatype_ LIKE 'DATE%' ) THEN
      RETURN ('D');
   ELSIF (datatype_ LIKE 'LONG%' ) THEN
      RETURN ('L');
   ELSIF (datatype_ LIKE 'RAW%' ) THEN
      RETURN ('R');
   ELSE
      RETURN (NULL);
   END IF;
END Get_Datatype___;


PROCEDURE Get_Table_Comment___ (
   comment_    OUT VARCHAR2,
   table_name_ IN  VARCHAR2 )
IS
   CURSOR get_comments IS
   SELECT comments
      FROM  user_tab_comments
      WHERE table_name = upper(table_name_);
BEGIN
   OPEN get_comments;
   FETCH get_comments INTO comment_;
   CLOSE get_comments;
END Get_Table_Comment___;


PROCEDURE Extract_Column_Info___ (
   column_no_       OUT NUMBER,
   column_name_     OUT VARCHAR2,
   column_datatype_ OUT VARCHAR2,
   column_flags_    OUT VARCHAR2,
   column_          IN  VARCHAR2 )
IS
   from_                NUMBER;
   to_                  NUMBER;
   col_name_            VARCHAR2(61);
BEGIN
   to_ := instr(column_, field_separator_);
   column_no_ := to_number(substr(column_, 1, to_ - 1));
   from_ := to_ + 1;
   to_ := instr(column_, field_separator_, from_);
   col_name_ := substr(column_, from_, to_ - from_);
   IF (instr(col_name_, '.') > 0) THEN
      column_name_ := substr(col_name_, instr(col_name_, '.') + 1);
   ELSE
      column_name_ := col_name_;
   END IF;
   from_ := to_ + 1;
   to_ := instr(column_, field_separator_, from_);
   column_datatype_ := substr(column_, from_, to_ - from_);
   from_ := to_ + 1;
   column_flags_ := substr(column_, from_);
END Extract_Column_Info___;


PROCEDURE Get_Column_Value___ (
   column_hdr_      OUT VARCHAR2,
   column_value_    OUT VARCHAR2,
   column_name_     IN  VARCHAR2,
   string_value_    IN  VARCHAR2,
   column_datatype_ IN  VARCHAR2 )
IS
BEGIN
   IF (instr(string_value_, '%') > 0) THEN
      Error_SYS.Appl_General(service_, 'COLOPERERR1: Illegal use of matching "%" operator for column [:P1].', column_name_);
   ELSIF (instr(string_value_, '_') > 0) THEN
      Error_SYS.Appl_General(service_, 'COLOPERERR2: Illegal use of matching "_" operator for column [:P1].', column_name_);
   ELSIF (instr(string_value_, '..') > 0) THEN
      Error_SYS.Appl_General(service_, 'COLOPERERR3: Illegal use of beetween ".." operator for column [:P1].', column_name_);
   END IF;
   IF (string_value_ IS NOT NULL) THEN
      IF (column_datatype_ LIKE 'STRING%') THEN
         column_value_ := Assert_SYS.Encode_Single_Quote_String( string_value_, TRUE ); 
         column_hdr_ := column_name_;
      ELSIF (column_datatype_ LIKE 'NUMBER%') THEN
         BEGIN
            column_value_ := to_number(string_value_); -- check if it is a valid number and convert back..
            column_hdr_ := column_name_;
         EXCEPTION
            WHEN OTHERS THEN
               Error_SYS.Appl_General(service_, 'COLNUMERR: Illegal number format for column [:P1].', column_name_);
         END;
      ELSIF (column_datatype_ LIKE 'DATE%') THEN
         IF (column_datatype_ LIKE '%/DATE' OR column_datatype_ = 'DATE') THEN
            BEGIN
               column_value_ := '''' || to_char(to_date(string_value_, Report_SYS.date_format_), Report_SYS.date_format_) || ''''; -- check if it is a valid date and then convert back, rely on nls_date_format..
               column_hdr_ := 'to_char('||column_name_||', '||''''||Report_SYS.date_format_||''')';
            EXCEPTION
               WHEN OTHERS THEN
                  Error_SYS.Appl_General(service_, 'COLDATEERR: Illegal date format for column [:P1].', column_name_);
            END;
         ELSIF (column_datatype_ LIKE '%/TIME') THEN
            BEGIN
               column_value_ := '''' || to_char(to_date(string_value_, Report_SYS.time_format_), Report_SYS.time_format_) || ''''; -- check if it is a valid date and then convert back, rely on nls_date_format..
               column_hdr_ := 'to_char('||column_name_||', '||''''||Report_SYS.time_format_||''')';
            EXCEPTION
               WHEN OTHERS THEN
                  Error_SYS.Appl_General(service_, 'COLDATEERR: Illegal date format for column [:P1].', column_name_);
            END;
         ELSIF (column_datatype_ LIKE '%/DATETIME') THEN
            BEGIN
               column_value_ := '''' || to_char(to_date(string_value_, Report_SYS.datetime_format_), Report_SYS.datetime_format_) || ''''; -- check if it is a valid date and then convert back, rely on nls_date_format..
               column_hdr_ := 'to_char('||column_name_||', '||''''||Report_SYS.datetime_format_||''')';
            EXCEPTION
               WHEN OTHERS THEN
                  Error_SYS.Appl_General(service_, 'COLDATEERR: Illegal date format for column [:P1].', column_name_);
            END;
         END IF;
      ELSE
         Error_SYS.Appl_General(service_, 'COLTYPEERR2: Datatype [:P1] not recognized [:P1].', column_name_, column_datatype_);
      END IF;
   ELSE
      Error_SYS.Appl_General(service_, 'COLDATAERR: Value expected for column [:P1].', column_name_);
   END IF;
END Get_Column_Value___;


FUNCTION Extract_Column_Value___ (
   column_hdr_      OUT VARCHAR2,
   column_value_    OUT VARCHAR2,
   column_name_     IN  VARCHAR2,
   operation_       IN  VARCHAR2,
   sub_expr_        IN  VARCHAR2,
   column_datatype_ IN  VARCHAR2 ) RETURN BOOLEAN
IS
   col_val_             VARCHAR2(500);
BEGIN
   IF (substr(sub_expr_, 1, length(operation_)) = operation_) THEN
      Get_Column_Value___(column_hdr_, col_val_, column_name_, ltrim(substr(sub_expr_, 1 + length(operation_))), column_datatype_);
      column_value_ := col_val_;
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Extract_Column_Value___;


FUNCTION Extract_Between___ (
   column_hdr_        OUT VARCHAR2,
   column_from_value_ OUT VARCHAR2,
   column_to_value_   OUT VARCHAR2,
   column_name_       IN  VARCHAR2,
   expression_        IN  VARCHAR2,
   column_datatype_   IN  VARCHAR2 ) RETURN BOOLEAN
IS
   pos_                  NUMBER;
   col_hdr_1_            VARCHAR2(500);
   col_hdr_2_            VARCHAR2(500);
BEGIN
   pos_ := instr(expression_, '..');
   IF (pos_ > 0) THEN
      Get_Column_Value___(col_hdr_1_, column_from_value_, column_name_, rtrim(substr(expression_, 1, pos_ - 1)), column_datatype_);
      Get_Column_Value___(col_hdr_2_, column_to_value_, column_name_, ltrim(substr(expression_, pos_ + 2)), column_datatype_);
      column_hdr_ := col_hdr_1_;
      RETURN (TRUE);
   ELSE
      RETURN (FALSE);
   END IF;
END Extract_Between___;


PROCEDURE Delete_From_Table___ (
   table_name_ IN VARCHAR2,
   result_key_ IN NUMBER )
IS
   comments_    VARCHAR2(2000);
   children_    VARCHAR2(500);
   from_        NUMBER;
   to_          NUMBER;
   sql_stmt_    VARCHAR2(100);
   dummy_trail_ VARCHAR2(32000) := NULL;
   PROCEDURE Delete_Recursive___ (
      table_name_ IN     VARCHAR2,
      result_key_ IN     NUMBER,
      trail_      IN OUT VARCHAR2 )
   IS
      child_   VARCHAR2(100);
   BEGIN
      trail_ := trail_ || upper(table_name_) || field_separator_;
      Get_Table_Comment___(comments_, table_name_);
      children_ := Dictionary_SYS.Comment_Value_('CHILDREN', comments_);
      IF (children_ IS NOT NULL) THEN
         from_ := 1;
         to_ := instr(children_, ',');
         WHILE (to_ > 0) LOOP
            child_ := upper(substr(children_, from_, to_ - from_));
            IF (instr(field_separator_||trail_, field_separator_||child_) > 0) THEN
               NULL;
            ELSE
               Delete_Recursive___(child_, result_key_, trail_);
            END IF;
            from_ := to_ + 1;
            to_ := instr(children_, ',', from_);
         END LOOP;
         child_ := upper(substr(children_, from_));
         IF (instr(field_separator_||trail_, field_separator_||child_) > 0) THEN
            NULL;
         ELSE
            Delete_Recursive___(child_, result_key_, trail_);
         END IF;
      END IF;
      IF (table_name_ IS NOT NULL) THEN
         sql_stmt_ := 'DELETE FROM ' || table_name_ || ' WHERE RESULT_KEY = :result_key';
         Put_Trace___('STMT= '||sql_stmt_);
         Assert_SYS.Assert_Is_Table(table_name_);
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE sql_stmt_ USING result_key_;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(service_, 'CLRREPTBLERR: Error creating SQL delete statement [:P1]', sql_stmt_);
      END Delete_Recursive___;
BEGIN
   Delete_Recursive___(upper(table_name_), result_key_, dummy_trail_);
END Delete_From_Table___;


PROCEDURE Build_Setup___ (
   select_cursor_  IN OUT NUMBER_ARRAY,
   insert_cursor_  IN OUT NUMBER_ARRAY,
   columns_        IN OUT VARCHAR2_ARRAY,
   link_           IN OUT VARCHAR2_ARRAY,
   report_id_      IN VARCHAR2,
   table_name_     IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 )
IS
   last_             NUMBER;
BEGIN
   Assert_SYS.Assert_Match_Regexp( parameter_attr_, '^[^'']*$' );
   last_ := Build_Setup_All___(select_cursor_, insert_cursor_, columns_, link_ , report_id_, table_name_,
                               report_attr_, parameter_attr_, 1, NULL, NULL, NULL);
END Build_Setup___;


FUNCTION Build_Setup_All___ (
   select_cursor_  IN OUT NUMBER_ARRAY,
   insert_cursor_  IN OUT NUMBER_ARRAY,
   columns_        IN OUT VARCHAR2_ARRAY,
   link_           IN OUT VARCHAR2_ARRAY,
   report_id_      IN VARCHAR2,
   table_name_     IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2,
   self_           IN NUMBER,
   parent_         IN NUMBER,
   my_siblings_    IN VARCHAR2,
   parent_keys_    IN VARCHAR2 ) RETURN NUMBER
IS
   -- globals..
   first_child_       NUMBER;
   sibling_           NUMBER;
   last_              NUMBER;
   first_table_       VARCHAR2(30);
   rest_table_        VARCHAR2(30);
   -- the rest..
   children_          VARCHAR2(500);
   sources_           VARCHAR2(500);
   user_where_        VARCHAR2(2000);
   table_comment_     VARCHAR2(2000);
   select_columns_    VARCHAR2(2000);
   insert_columns_    VARCHAR2(2000);
   key_columns_       VARCHAR2(2000);
   report_where_      VARCHAR2(2000);
   report_order_by_   VARCHAR2(2000);
   report_group_by_   VARCHAR2(2000);
   to_                NUMBER;
BEGIN
   Assert_SYS.Assert_Match_Regexp( parameter_attr_, '^[^'']*$' );
   Get_Table_Comment___(table_comment_, table_name_);
   Build_Columns___(columns_(self_), select_columns_, insert_columns_, key_columns_, table_name_);
   report_where_ := Dictionary_SYS.Comment_Value_('WHERE', table_comment_);
   sources_ := Dictionary_SYS.Comment_Value_('SOURCE', table_comment_);
   user_where_ := Parse_Report_Where_Expression_(report_id_, report_attr_, parameter_attr_, sources_);
   report_order_by_ := Dictionary_SYS.Comment_Value_('ORDER_BY', table_comment_);
   report_group_by_ := Dictionary_SYS.Comment_Value_('GROUP_BY', table_comment_);
   select_cursor_(self_) := Open_Select_Cursor___(sources_, columns_(self_), select_columns_, parent_keys_,
                                                report_where_, user_where_, report_order_by_, report_group_by_);
   insert_cursor_(self_) := Open_Insert_Cursor___(table_name_, insert_columns_);
   link_(self_) := NULL; -- set any value temporarily ..
   children_ := Dictionary_SYS.Comment_Value_('CHILDREN', table_comment_);
   IF (children_ IS NOT NULL) THEN
      to_ := instr(children_, ';', 1);
      IF (to_ > 0) THEN
         first_table_ := substr(children_, 1, to_ - 1);
         rest_table_ := substr(children_, to_ + 1);
      ELSE
         first_table_ := children_;
         rest_table_ := NULL;
      END IF;
      first_child_ := self_ + 1;
      last_ := Build_Setup_All___(select_cursor_, insert_cursor_, columns_, link_, report_id_, first_table_,
                                  NULL, NULL, first_child_, self_, rest_table_, parent_keys_||key_columns_);
   ELSE
      last_ := self_;
   END IF;
   IF (my_siblings_ IS NOT NULL) THEN
      to_ := instr(my_siblings_, ';', 1);
      IF (to_ > 0) THEN
         first_table_ := substr(my_siblings_, 1, to_ - 1);
         rest_table_ := substr(my_siblings_, to_ + 1);
      ELSE
         first_table_ := my_siblings_;
         rest_table_ := NULL;
      END IF;
      sibling_ := last_ + 1;
      last_ := Build_Setup_All___(select_cursor_, insert_cursor_, columns_, link_, report_id_, first_table_,
                                  NULL, NULL, sibling_, parent_, rest_table_, parent_keys_);
   END IF;
   link_(self_) := parent_ || field_separator_ || first_child_ || field_separator_||
                              sibling_;
   RETURN (last_);
END Build_Setup_All___;


PROCEDURE Build_Columns___ (
   columns_         OUT VARCHAR2,
   select_columns_  OUT VARCHAR2,
   insert_columns_  OUT VARCHAR2,
   key_columns_     OUT VARCHAR2,
   table_name_      IN  VARCHAR2 )
IS
   selects_             VARCHAR2(2000);
   inserts_             VARCHAR2(2000);
   cols_                VARCHAR2(2000);
   keys_                VARCHAR2(2000);
   select_              VARCHAR2(100);
   datatype_            VARCHAR2(1);
   flags_               VARCHAR2(5);
   select_no_           NUMBER;

   CURSOR get_columns IS
      SELECT column_name, comments
      FROM   user_col_comments
      WHERE  table_name = table_name_;
BEGIN
   select_no_ := 1;
   FOR column_ IN get_columns LOOP
      select_ := nvl(Dictionary_SYS.Comment_Value_('SELECT', column_.comments), column_.column_name);
      datatype_ := Get_Datatype___(column_.comments);
      flags_ := nvl(Dictionary_SYS.Comment_Value_('FLAGS', column_.comments), 'M');
      IF (select_ IS NOT NULL) THEN
         selects_ := selects_ || select_ || field_separator_;
         cols_ := cols_ || select_no_ || field_separator_ || column_.column_name || field_separator_ ||
                           datatype_ || field_separator_ || substr(flags_, 1, 1) || record_separator_;
         select_no_ := select_no_ + 1;
      ELSE
         cols_ := cols_ || NULL || field_separator_ || column_.column_name || field_separator_ ||
                           datatype_ || field_separator_ || substr(flags_, 1, 1) || record_separator_;
      END IF;
      inserts_ := inserts_ || column_.column_name || field_separator_;
      IF (substr(flags_, 1, 1) = 'K') THEN
         keys_ := keys_ || column_.column_name || field_separator_;
      END IF;
   END LOOP;
   columns_ := cols_;
   select_columns_ := selects_;
   insert_columns_ := inserts_;
   key_columns_ := keys_;
END Build_Columns___;


FUNCTION Open_Select_Cursor___ (
   source_          IN VARCHAR2,
   columns_         IN VARCHAR2,
   select_columns_  IN VARCHAR2,
   parent_keys_     IN VARCHAR2,
   where_           IN VARCHAR2,
   user_where_      IN VARCHAR2,
   report_order_by_ IN VARCHAR2,
   report_group_by_ IN VARCHAR2 ) RETURN NUMBER
IS
   select_             VARCHAR2(2000);
   cur_id_             NUMBER;
   date_               DATE;
   number_             NUMBER;
   varchar2_           VARCHAR2(2000);
   column_             VARCHAR2(120);
   column_name_        VARCHAR2(100);
   column_number_      NUMBER;
   column_datatype_    VARCHAR2(1);
   column_flags_       VARCHAR2(5);
   delim_              VARCHAR2(30);
   from_               NUMBER;
   to_                 NUMBER;
   qualifier_          VARCHAR2(100);
   long_               VARCHAR2(32760);
   raw_                RAW(32760);
BEGIN
   to_ := instr(source_, ',');
   IF (to_ > 0 ) THEN
      qualifier_ := substr(source_, 1, to_ - 1);
   ELSE
      qualifier_ := source_;
   END IF;
   select_ := 'SELECT '||replace(rtrim(select_columns_,field_separator_),field_separator_,', ')||' FROM '||source_;
   delim_ := ' WHERE ';
   IF (parent_keys_ IS NOT NULL) THEN
      from_ := 1;
      to_ := instr(parent_keys_, field_separator_, from_);
      WHILE (to_ > 0) LOOP
         column_name_ := substr(parent_keys_, from_, to_ - from_);
         select_ := select_ || delim_ || qualifier_ || '.' || column_name_ || ' = :' || column_name_;
         delim_ := ' AND ';
         from_ := to_ + 1;
         to_ := instr(parent_keys_, field_separator_, from_);
      END LOOP;
      delim_ := ' AND ';
   END IF;
   IF (where_ IS NOT NULL) THEN
      select_ := select_ || delim_ || '(' || where_||')';
      delim_ := ' AND ';
   END IF;
   IF (user_where_ IS NOT NULL) THEN
      select_ := select_ || delim_ || '(' || user_where_ || ')';
   END IF;
   IF (report_order_by_ IS NOT NULL) THEN
      select_ := select_ || ' ORDER BY ' || report_order_by_;
   END IF;
   IF (report_group_by_ IS NOT NULL) THEN
      select_ := select_ || ' GROUP BY ' || report_group_by_;
   END IF;
   cur_id_ := dbms_sql.open_cursor;
   Put_Trace___('SELECT= '||select_);
   -- Safe due to the values concatenated into select_ are validated
   @ApproveDynamicStatement(2013-07-19,NaBaLK)
   dbms_sql.parse(cur_id_, select_, dbms_sql.native);
   from_ := 1;
   to_ := instr(columns_, record_separator_, from_);
   WHILE (to_ > 0) LOOP
      column_ := substr(columns_, from_, to_ - from_);
      Extract_Column_Info___(column_number_, column_name_, column_datatype_, column_flags_, column_);
      IF (column_number_ IS NOT NULL) THEN
         IF (column_datatype_ = 'D') THEN
            dbms_sql.define_column(cur_id_, column_number_, date_);
         ELSIF (column_datatype_ = 'N') THEN
            dbms_sql.define_column(cur_id_, column_number_, number_);
         ELSIF (column_datatype_ = 'S') THEN
            dbms_sql.define_column(cur_id_, column_number_, varchar2_, 32760);
         ELSIF (column_datatype_ = 'L') THEN
            dbms_sql.define_column(cur_id_, column_number_, long_, 32760);
         ELSIF (column_datatype_ = 'R') THEN
            dbms_sql.define_column(cur_id_, column_number_, raw_, 32760);
         ELSE
            Error_SYS.Appl_General(service_,'TYPEERR: Illegal datatype [:P1].', column_datatype_);
         END IF;
      END IF;
      from_ := to_ + 1;
      to_ := instr(columns_, record_separator_, from_);
   END LOOP;
   RETURN (cur_id_);
EXCEPTION
   -- If any errors, just raise
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cur_id_)) THEN
         dbms_sql.close_cursor(cur_id_);
      END IF;
      Error_SYS.Appl_General(service_, 'OPSELCUR: Design time error. Illegal SELECT statement [:P1].', select_);
END Open_Select_Cursor___;


FUNCTION Open_Insert_Cursor___ (
   table_name_     IN VARCHAR2,
   insert_columns_ IN VARCHAR2 ) RETURN NUMBER
IS
   cur_id_            NUMBER;
   insert_            VARCHAR2(2000);
BEGIN
   Assert_SYS.Assert_Is_Table(table_name_);
   insert_ := 'INSERT INTO '||table_name_||' VALUES(:'||
                              replace(rtrim(insert_columns_,field_separator_),field_separator_,', :')||')';
   Put_Trace___('INSERT= '||insert_);
   cur_id_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cur_id_, insert_, dbms_sql.native);
   RETURN (cur_id_);
EXCEPTION
   -- If any errors, just raise
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cur_id_)) THEN
         dbms_sql.close_cursor(cur_id_);
      END IF;
      Error_SYS.Appl_General(service_, 'OPINSCUR: Design time error. Illegal INSERT statement [:P1].', insert_);
END Open_Insert_Cursor___;


PROCEDURE Put_Trace___ (
   text_ IN VARCHAR2 )
IS
   from_    NUMBER;
   pos_     NUMBER;
   header_  VARCHAR2(50);
   line_    VARCHAR2(32000);
BEGIN
   pos_ := nvl(instr(text_, '='), 0);
   header_ := 'REPORT' || Log_SYS.Get_Separator || ' '||substr(text_, 1, pos_)||' ';
   from_ := 1;
   line_ := '''' || ltrim(substr(text_, pos_ + 1)) || '''';
   WHILE (from_ <= length(line_)) LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.Info_, substr(header_, 1, 50) || substr(line_, from_, 75)||'('||to_char(dbms_utility.get_time)||')');
      header_ := 'REPORT' || Log_SYS.Get_Separator || '+ ';
      from_ := from_ + 75;
   END LOOP;
END Put_Trace___;


PROCEDURE Get_Ref_Properties___ (
   reference_ IN  VARCHAR2,
   view_      OUT VARCHAR2,
   enum_      OUT VARCHAR2 )
IS
   logical_unit_ VARCHAR2(30);
   pos_          NUMBER;
   ref_key_      VARCHAR2(100);
   view_name_    VARCHAR2(30);
   package_      VARCHAR2(30);
   search_name_  VARCHAR2(60);
   object_name_  VARCHAR2(30);
   CURSOR get_view_by_comment IS
      SELECT MIN(table_name)
      FROM   fnd_tab_comments
      WHERE  ('^'||comments LIKE '%^LU='||logical_unit_||'^%'
      AND    substr(table_name,-4) <> '_REP');
   CURSOR get_view IS
      SELECT view_name
      FROM   user_views
      WHERE  view_name = search_name_;
   CURSOR get_package IS
      SELECT substr(object_name,1,30)
      FROM   user_objects uo
      WHERE  object_name = object_name_
      AND    object_type = 'PACKAGE'
      AND    EXISTS
      (SELECT 1
       FROM   user_procedures
       WHERE  object_name = uo.object_name
       AND    procedure_name = 'ENUMERATE');
BEGIN
   pos_ := instr(reference_, '(');
   IF (pos_ > 0) THEN
      logical_unit_ := substr(reference_, 1, pos_ - 1 );
      ref_key_ := substr(reference_, pos_);
      ref_key_ := regexp_replace(ref_key_, '/.*', '');
   ELSE
      logical_unit_ := reference_;
      logical_unit_ := regexp_replace(logical_unit_, '/.*', '');
      ref_key_ := NULL;
   END IF;
   IF (logical_unit_ = upper(logical_unit_) OR instr(logical_unit_,'_') > 0) THEN
      view_ := upper(logical_unit_||ref_key_);
   ELSE
      search_name_ := Dictionary_SYS.ClientNameToDbName_(logical_unit_);
      OPEN get_view;
      FETCH get_view INTO view_name_;
      CLOSE get_view;
      IF (view_name_ IS NULL AND ref_key_ IS NULL) THEN
         object_name_ := search_name_||'_API';
         OPEN get_package;
         FETCH get_package INTO package_;
         CLOSE get_package;
         IF (package_ IS NOT NULL) THEN
            enum_ := package_||'.Enumerate';
         END IF;
      END IF;
      IF (view_name_ IS NULL AND enum_ IS NULL) THEN
         OPEN get_view_by_comment;
         FETCH get_view_by_comment INTO view_name_;
         CLOSE get_view_by_comment;
      END IF;
      view_ := view_name_||ref_key_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(service_, 'REFPROPERROR: Designtime error. Illegal reference [:P1]. Reported error is [:P2]', reference_, SQLERRM);
END Get_Ref_Properties___;


PROCEDURE Run_Report_Method___ (
   result_key_     IN NUMBER,
   report_method_  IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 )
IS
   report_parm_ VARCHAR2(32000);
   stmt_        VARCHAR2(200);
BEGIN
   report_parm_ := report_attr_;
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, report_parm_);
   Put_Trace___('METHOD = '||report_method_);
   Put_Trace___('REPORT_ATTR = '||report_parm_);
   Put_Trace___('PARAMETER_ATTR = '||parameter_attr_);
   Assert_SYS.Assert_Is_Package_Method(report_method_);
   stmt_ := 'begin '||report_method_||'(:report_parm_,:parameter_attr_); end;';
   Put_Trace___('STMT = '||stmt_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE stmt_ USING report_parm_, parameter_attr_;
EXCEPTION
   WHEN OTHERS THEN
      IF (Error_SYS.Is_Foundation_Error(SQLCODE)) THEN
         RAISE;
      ELSIF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      ELSE
         Error_SYS.Appl_General(service_, 'REPRUNERR: Error [:P1] in report method [:P2]', Ora_Error(SQLERRM), report_method_);
      END IF;
END Run_Report_Method___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Populate_Parent_Child__ (
   result_key_     IN NUMBER,
   table_name_     IN VARCHAR2,
   report_id_      IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 )
IS
   -- temporary placeholders..
   string_              VARCHAR2(2000);
   number_              NUMBER;
   date_                DATE;
   long_                VARCHAR2(32760);
   raw_                 RAW(32760);
   mlslabel_            MLSLABEL;
   from_                NUMBER;
   to_                  NUMBER;
   col_from_            NUMBER;
   col_to_              NUMBER;
   keys_                VARCHAR2(2000);
   self_                NUMBER(2);
   next_                NUMBER(2);
   column_name_         VARCHAR2(30);
   select_number_       NUMBER(2);
   column_datatype_     VARCHAR2(1);
   column_flags_        VARCHAR2(1);
   column_              VARCHAR2(100);
   column_value_        VARCHAR2(2000);
   -- level dependent locals, self_ changing..
   parent_keys_         VARCHAR2(2000); -- just to be safe
   parent_row_no_       NUMBER;
   saved_parent_keys_   Report_SYS.VARCHAR2_ARRAY;
   saved_parent_row_no_ Report_SYS.NUMBER_ARRAY;
   -- .. and self_ constant..
   select_cursor_       Report_SYS.NUMBER_ARRAY;
   insert_cursor_       Report_SYS.NUMBER_ARRAY;
   columns_             Report_SYS.VARCHAR2_ARRAY;
   link_                Report_SYS.VARCHAR2_ARRAY;
   -- level independent globals..
   row_no_              NUMBER; -- changing..
   level_               NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Populate_Parent_Child__');
   Put_Trace___('REPORT_ATTR= '||report_attr_);
   Put_Trace___('PARAMETER_ATTR= '||parameter_attr_);
   Build_Setup___(select_cursor_, insert_cursor_, columns_, link_, report_id_, table_name_,
                  report_attr_, parameter_attr_);
   self_ := 1;
   row_no_ := 1;
   level_ := 1;
   parent_row_no_ := 0;
   number_ := dbms_sql.execute(select_cursor_(self_));
   Assert_SYS.Assert_Match_Regexp( parameter_attr_, '^[^'']*$' );
   WHILE (self_ IS NOT NULL) LOOP
      IF (FALSE) THEN -- <method_requested(self_)>
         -- <method_execute(self_)>;
         NULL; -- for now..
      ELSE
         WHILE (dbms_sql.fetch_rows(select_cursor_(self_)) > 0) LOOP
            keys_ := parent_keys_;
            col_from_ := 1;
            col_to_ := instr(columns_(self_), record_separator_, col_from_);
            WHILE (col_to_ > 0) LOOP
               column_ := substr(columns_(self_), col_from_, col_to_ - col_from_);
               to_ := instr(column_, field_separator_, 1);
               select_number_ := substr(column_, 1, to_ - 1);
               from_ := to_ + 1;
               to_ := instr(column_, field_separator_, from_);
               column_name_ := substr(column_, from_, to_ - from_);
               from_ := to_ + 1;
               to_ := instr(column_, field_separator_, from_);
               column_datatype_ := substr(column_, from_, to_ - from_);
               from_ := to_ + 1;
               column_flags_ := substr(column_, from_);
               IF (column_flags_ = 'M') THEN
                  -- mandatory columns..
                  IF (column_name_ = 'RESULT_KEY') THEN
                     dbms_sql.bind_variable(insert_cursor_(self_), column_name_, result_key_);
                  ELSIF (column_name_ = 'ROW_NO') THEN
                     dbms_sql.bind_variable(insert_cursor_(self_), column_name_, row_no_);
                  ELSIF (column_name_ = 'PARENT_ROW_NO') THEN
                     dbms_sql.bind_variable(insert_cursor_(self_), column_name_, parent_row_no_);
                  ELSE
                     Error_SYS.Appl_General(service_, 'MANDCOLERR: Mandatory key column [:P1] not recognized.', column_name_);
                  END IF;
               ELSIF (column_datatype_ = 'S') THEN
                  -- string column..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, string_);
                  dbms_sql.bind_variable(insert_cursor_(self_), column_name_, string_);
                  column_value_ := string_;
               ELSIF (column_datatype_ = 'N') THEN
                  -- number column..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, number_);
                  dbms_sql.bind_variable(insert_cursor_(self_), column_name_, number_);
                  column_value_ := number_;
               ELSIF (column_datatype_ = 'D') THEN
                  -- date column..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, date_);
                  dbms_sql.bind_variable(insert_cursor_(self_), column_name_, date_);
                  column_value_ := ''''||date_||'''';
               ELSIF (column_datatype_ = 'L') THEN
                  -- long column ~= varchar2(32760)..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, long_);
                  dbms_sql.bind_variable(insert_cursor_(self_), column_name_, long_);
                  column_value_ := NULL;
               ELSIF (column_datatype_ = 'R') THEN
                  -- raw column..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, raw_);
                  dbms_sql.bind_variable_raw(insert_cursor_(self_), column_name_, raw_);
                  column_value_ := NULL;
               ELSIF (column_datatype_ = 'M') THEN
                  -- mlslabel column..
                  dbms_sql.column_value(select_cursor_(self_), select_number_, mlslabel_);
                  dbms_sql.bind_variable(insert_cursor_(self_), column_name_, mlslabel_);
                  column_value_ := NULL;
               ELSE
                  Error_SYS.Appl_General(service_, 'COLTYPEERR: Column type not recognized [:P1].', column_datatype_);
               END IF;
               IF (column_flags_ = 'K') THEN
                  keys_ := keys_ || column_name_ || field_separator_ || column_datatype_ || field_separator_ ||
                                    column_value_ || record_separator_;
               END IF;
               col_from_ := col_to_ + 1;
               col_to_ := instr(columns_(self_), record_separator_, col_from_);
            END LOOP;
            number_ := dbms_sql.execute(insert_cursor_(self_)); -- use number_ temporarily..
            from_ := instr(link_(self_), field_separator_, 1) + 1;
            to_ := instr(link_(self_), field_separator_, from_);
            next_ := substr(link_(self_), from_, to_ - from_ ); -- next_ := first_child_;
            IF (next_ IS NOT NULL) THEN
               IF (FALSE) THEN -- <method_requested(self_)>
                  -- <method_execute(self_)>;
                  NULL; -- for now..
               ELSE
                  -- put_down old values and compute new parent values..
                  saved_parent_keys_(level_) := parent_keys_;
                  saved_parent_row_no_(level_) := parent_row_no_;
                  level_ := level_ + 1;
                  parent_keys_ := keys_;
                  parent_row_no_ := row_no_;
                  self_ := next_;
                  -- bind parent_keys_ to select_cursor_
                  col_from_ := 1;
                  col_to_ := instr(parent_keys_, record_separator_, col_from_);
                  WHILE (col_to_ > 0) LOOP
                     column_ := substr(parent_keys_, col_from_, col_to_ - col_from_);
                     to_ := instr(column_, field_separator_, 1);
                     column_name_ := substr(column_, 1, to_ - 1);
                     from_ := to_ + 1;
                     to_ := instr(column_, field_separator_, from_);
                     column_datatype_ := substr(column_, from_, to_ - from_);
                     from_ := to_ + 1;
                     column_value_ := substr(column_, from_);
                     IF (column_datatype_ = 'S') THEN
                        string_ := column_value_;
                        dbms_sql.bind_variable(select_cursor_(self_), column_name_, string_);
                     ELSIF (column_datatype_ = 'N') THEN
                        number_ := column_value_;
                        dbms_sql.bind_variable(select_cursor_(self_), column_name_, number_);
                     ELSIF (column_datatype_ = 'D') THEN
                        date_ := column_value_;
                        dbms_sql.bind_variable(select_cursor_(self_), column_name_, date_);
                     ELSE
                        Error_SYS.Appl_General(service_, 'COLTYPEERR: Column type not recognized [:P1].', column_datatype_);
                     END IF;
                     col_from_ := col_to_ + 1;
                     col_to_ := instr(parent_keys_, record_separator_, col_from_);
                  END LOOP;
                  number_ := dbms_sql.execute(select_cursor_(self_));
               END IF;
            END IF;
            row_no_ := row_no_ + 1;
         END LOOP;
      END IF;
      from_ := instr(link_(self_),field_separator_, 1, 2);
      next_ := substr(link_(self_), from_ + 1);  -- next_ := sibling_;
      IF (next_ IS NOT NULL) THEN
         self_ := next_;
         -- bind parent_keys_ to select_cursor_
         col_from_ := 1;
         col_to_ := instr(parent_keys_, record_separator_, col_from_);
         WHILE (col_to_ > 0) LOOP
            column_ := substr(parent_keys_, col_from_, col_to_ - col_from_);
            to_ := instr(column_,field_separator_, 1);
            column_name_ := substr(column_, 1, to_ - 1);
            from_ := to_ + 1;
            to_ := instr(column_,field_separator_, from_);
            column_datatype_ := substr(column_, from_, to_ - from_);
            from_ := to_ + 1;
            column_value_ := substr(column_, from_);
            IF (column_datatype_ = 'S' OR column_datatype_ = 'C') THEN
               string_ := column_value_;
               dbms_sql.bind_variable(select_cursor_(self_), column_name_, string_);
            ELSIF (column_datatype_ = 'N') THEN
               number_ := column_value_;
               dbms_sql.bind_variable(select_cursor_(self_), column_name_, number_);
            ELSIF (column_datatype_ = 'D') THEN
               date_ := column_value_;
               dbms_sql.bind_variable(select_cursor_(self_), column_name_, date_);
            END IF;
            col_from_ := col_to_ + 1;
            col_to_ := instr(parent_keys_, record_separator_, col_from_);
         END LOOP;
         number_ := dbms_sql.execute(select_cursor_(self_));
      ELSE
         to_ := instr(link_(self_),field_separator_, 1);
         self_ := substr(link_(self_), 1, to_ - 1 );  -- self_ := parent_;
         IF (self_ IS NOT NULL) THEN -- make sure level does not reach zero..
            level_ := level_ - 1;
            parent_keys_ := saved_parent_keys_(level_);
            parent_row_no_ := saved_parent_row_no_(level_);
         END IF;
      END IF;
   END LOOP;
   BEGIN
      self_ := 1;
      LOOP
         dbms_sql.close_cursor(select_cursor_(self_));
         dbms_sql.close_cursor(insert_cursor_(self_));
         self_ := self_ + 1;
      END LOOP;
   EXCEPTION
      WHEN no_data_found THEN
         NULL;
   END;
EXCEPTION
   WHEN OTHERS THEN
      BEGIN
         self_ := 1;
         LOOP
            dbms_sql.close_cursor(select_cursor_(self_));
            dbms_sql.close_cursor(insert_cursor_(self_));
            self_ := self_ + 1;
         END LOOP;
      EXCEPTION
         WHEN no_data_found THEN
            NULL;
      END;
      RAISE;
END Populate_Parent_Child__;


PROCEDURE Run_Plsql__ (
   proc_name_  IN VARCHAR2,
   bind_list_  IN VARCHAR2,
   value_list_ IN VARCHAR2,
   type_list_  IN VARCHAR2 )
IS
   cursor_     INTEGER;
   count_      INTEGER;
   plsql_      VARCHAR2(2000);
   bind_from_  INTEGER;
   bind_to_    INTEGER;
   bind_item_  VARCHAR2(30);
   value_from_ INTEGER;
   value_to_   INTEGER;
   value_item_ VARCHAR2(500);
   type_from_  INTEGER;
   type_to_    INTEGER;
   type_item_  VARCHAR2(1);
   bl_tmp_     VARCHAR2(2000);
   parse_error EXCEPTION;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Run_Plsql__');
   bind_from_ :=1;
   value_from_:=1;
   type_from_ :=1;
   bind_to_ := instr(bind_list_,field_separator_,bind_from_);
   value_to_:= instr(value_list_,field_separator_,value_from_);
   type_to_ := instr(type_list_,field_separator_,type_from_);
   IF (bind_to_>0 AND value_to_>0 AND type_to_>0) THEN
      Assert_SYS.Assert_Is_Procedure(proc_name_);
      bl_tmp_ := substr(replace(bind_list_,field_separator_,','),1,length(bind_list_)-1);
      Assert_SYS.Assert_Match_Regexp( bl_tmp_, '^[:][a-zA-Z0-9_]+(,[:][a-zA-Z0-9_]+)*$' );
      plsql_:='BEGIN '||proc_name_||'('|| bl_tmp_ ||'); END;';
      Put_Trace___('PARSE= '||plsql_);
      cursor_ := dbms_sql.open_cursor;
      @ApproveDynamicStatement(2006-01-05,utgulk)
      dbms_sql.parse(cursor_, plsql_, dbms_sql.native );
      WHILE (bind_to_>0 AND value_to_>0 AND type_to_>0) LOOP
         IF substr(bind_list_,bind_from_,1)<>':' THEN
            RAISE parse_error;
         END IF;
         bind_item_:=substr(bind_list_,bind_from_+1,bind_to_-bind_from_-1);
         value_item_:=substr(value_list_,value_from_,value_to_-value_from_);
         type_item_:=substr(type_list_,type_from_,type_to_-type_from_);
         IF type_item_='N' THEN
            dbms_sql.bind_variable(cursor_, bind_item_, to_number(value_item_));
         ELSIF type_item_='D' THEN
            dbms_sql.bind_variable(cursor_, bind_item_, to_date(value_item_, Report_SYS.datetime_format_));
         ELSIF type_item_='S' THEN
            dbms_sql.bind_variable(cursor_, bind_item_, value_item_);
         ELSE
            RAISE parse_error;
         END IF;
         bind_from_:=bind_to_+1;
         value_from_:=value_to_+1;
         type_from_:=type_to_+1;
         bind_to_:=instr(bind_list_,field_separator_,bind_from_);
         value_to_:=instr(value_list_,field_separator_,value_from_);
         type_to_:=instr(type_list_,field_separator_,type_from_);
      END LOOP;
      IF (bind_to_<>0 OR value_to_<>0 OR type_to_<>0) THEN
         RAISE parse_error;
      END IF;
   ELSE
      Assert_SYS.Assert_Is_Procedure(proc_name_);
      plsql_:='BEGIN '||proc_name_||'; END;';
      Put_Trace___('PARSE= '||plsql_);
      cursor_ := dbms_sql.open_cursor;
      @ApproveDynamicStatement(2006-01-05,utgulk)
      dbms_sql.parse(cursor_, plsql_, dbms_sql.native );
   END IF;
   IF (substr(bind_list_,bind_from_) <> '' OR
       substr(value_list_,value_from_) <> '' OR
       substr(type_list_,type_from_) <> '') THEN
       RAISE parse_error;
   END IF;
   count_ := dbms_sql.execute(cursor_);
   dbms_sql.close_cursor(cursor_);
EXCEPTION
   WHEN parse_error THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      Error_SYS.Appl_General(service_, 'REPPARSE: Parse Error [:P1]', plsql_);
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      IF (Error_SYS.Is_Foundation_Error(SQLCODE)) THEN
         RAISE;
      ELSE
         Error_SYS.Appl_General(service_, 'REPRUNERR: Error [:P1] in report method [:P2]', Ora_Error(SQLERRM), proc_name_);
      END IF;
END Run_Plsql__;


PROCEDURE Refresh_Active_List__ (
   dummy_        IN NUMBER,
   full_refresh_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   count_ NUMBER := 0;
   CURSOR all_reports IS
   SELECT report_id
      FROM   report_sys_tab
      WHERE  substr(report_id ,-4) = '_REP'
   UNION
   SELECT group_name report_id
      FROM   report_sys_group_tab
      WHERE  SUBSTR(group_name,-4) = '_GRP';

   FUNCTION Get_Last_Refresh_Time (
      report_id_ IN VARCHAR2 ) RETURN DATE
   IS
      min_time_ DATE;
      old_time_ DATE := Database_SYS.Get_First_Calendar_Date;

      CURSOR get_min_refresh_time IS
      SELECT nvl(MIN(rowversion), old_time_) column_time
      FROM report_sys_column_tab
      WHERE report_id = report_id_;
   BEGIN
      FOR min_time IN get_min_refresh_time LOOP
         min_time_ := min_time.column_time;
      END LOOP;
      RETURN min_time_;
   END Get_Last_Refresh_Time;

BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Refresh_Active_List__');   
   --
   -- Remove all items not longer used.
   --
   DELETE
      FROM  report_sys_tab
      WHERE report_id NOT IN (SELECT table_name
            FROM   fnd_tab_comments
            WHERE  substr(table_name ,-4) = '_REP'
            AND    table_type = 'VIEW'
         UNION
         SELECT group_name report_id
            FROM   report_sys_group_tab
            WHERE  substr(group_name,-4) = '_GRP')
     AND report_mode !='EXCEL1.0';
   DELETE
      FROM  report_sys_column_tab
      WHERE report_id NOT IN (SELECT table_name
            FROM   fnd_tab_comments
            WHERE  substr(table_name ,-4) = '_REP'
            AND    table_type = 'VIEW'
         UNION
         SELECT group_name report_id
            FROM   report_sys_group_tab
            WHERE  substr(group_name,-4) = '_GRP')
      AND report_id NOT IN (SELECT report_id 
                            FROM report_sys_tab
                            WHERE report_mode ='EXCEL1.0');
   DELETE
      FROM  report_sys_layout_tab
      WHERE report_id NOT IN (SELECT table_name
            FROM   fnd_tab_comments
            WHERE  substr(table_name ,-4) = '_REP'
            AND    table_type = 'VIEW'
         UNION
         SELECT group_name report_id
            FROM   report_sys_group_tab
            WHERE  substr(group_name,-4) = '_GRP')
      AND report_id NOT IN (SELECT report_id 
                            FROM report_sys_tab
                            WHERE report_mode ='EXCEL1.0');
@ApproveTransactionStatement(2014-04-02,mabose)
   COMMIT;
   
   --
   -- Find all reports and loop over them
   --
   FOR rec_ IN all_reports LOOP
      IF full_refresh_ = 'TRUE' THEN
         --
         -- Refresh the report
         --
         Refresh_(rec_.report_id);
         count_ := count_ + 1;
      ELSIF full_refresh_ = 'FALSE' THEN
         --
         -- Refresh only if the report needs refresh.
         IF Check_Reference_Storage_(rec_.report_id) = 1 THEN 
            Refresh_(rec_.report_id);
            count_ := count_ + 1;
         END IF;
      ELSE
         Error_SYS.Appl_General(service_, 'ILLEGAL_PARAM_REFR: The parameter full_refresh_ has got an invalid value :P1. Possible string values are TRUE or FALSE.', full_refresh_);
      END IF;
      --
      -- Commit each report directly after refresh of it to minimize usage of rollback segment
      --
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.error_,    'Report Cache was updated for '||count_||' report(s)');

   Cache_Management_API.Refresh_Cache('Report');   
END Refresh_Active_List__;


@UncheckedAccess
PROCEDURE Get_Result_Key__ (
   result_key_ OUT NUMBER )
IS
BEGIN
   SELECT report_sys_seq.Nextval
      INTO  result_key_
      FROM  dual;
END Get_Result_Key__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Parse_Column_Where_ (
   parsed_column_   OUT VARCHAR2,
   column_name_     IN  VARCHAR2,
   expression_      IN  VARCHAR2,
   flags_           IN  VARCHAR2,
   column_datatype_ IN  VARCHAR2 )
IS
   expr_                VARCHAR2(2000);
   where_               VARCHAR2(2000);
   pos_                 NUMBER := 1;
   to_                  NUMBER;
   delim_               VARCHAR2(10);
   not_expr_            VARCHAR2(5);
   sub_expr_            VARCHAR2(500);
   column_hdr_          VARCHAR2(500);
   column_value_        VARCHAR2(500);
   column_from_value_   VARCHAR2(500);
   column_to_value_     VARCHAR2(500);
   column_expr_         VARCHAR2(500);
   hit_all_             BOOLEAN;
   hit_null_            BOOLEAN;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Column_Where_');
   expr_ := ltrim(rtrim(expression_)); -- trim off spaces..
   IF (expr_ IS NOT NULL) THEN
      expr_ := expr_ || ';';
      delim_ := NULL;
      to_ := instr(expr_, ';', pos_);
      WHILE ( to_ > 0) LOOP
         sub_expr_ := rtrim(ltrim(substr(expr_, pos_, to_ - pos_))); -- trim off spaces..
         IF (sub_expr_ = '%') THEN
            hit_all_ := TRUE;
         ELSE
            IF (substr(sub_expr_, 1, 1) = '!') THEN
               sub_expr_ := ltrim(substr(sub_expr_, 2));
               not_expr_ := 'NOT ';
            ELSE
               not_expr_ := NULL;
            END IF;
            -- The following statements are order dependent, longer operations before shorter ones (unless special cases) et c..
            IF (sub_expr_ IS NULL) THEN
               IF (not_expr_ IS NULL) THEN
                  Error_SYS.Appl_General(service_, 'COLVALERR: Value expected for column [:P1]', column_name_);
               ELSE
                  column_expr_ := column_name_ || ' IS NULL';
                  not_expr_ := NULL;
                  hit_null_ := TRUE;
               END IF;
            ELSIF ( Extract_Column_Value___(column_hdr_, column_value_, column_name_, '<=', sub_expr_, column_datatype_) ) THEN
               IF (not_expr_ IS NOT NULL) THEN
                  Error_SYS.Appl_General(service_, 'COLNOTERR: Illegal use of not operator "!" for column [:P1]', column_name_);
               END IF;
               column_expr_ := column_hdr_ || ' <= ' || column_value_;
            ELSIF ( Extract_Column_Value___(column_hdr_, column_value_, column_name_, '>=', sub_expr_, column_datatype_) ) THEN
               IF (not_expr_ IS NOT NULL) THEN
                  Error_SYS.Appl_General(service_, 'COLNOTERR: Illegal use of not operator "!" for column [:P1]', column_name_);
               END IF;
               column_expr_ := column_hdr_ || ' >= ' || column_value_;
            ELSIF ( Extract_Column_Value___(column_hdr_, column_value_, column_name_, '<', sub_expr_, column_datatype_) ) THEN
               column_expr_ := column_hdr_ || ' < ' || column_value_;
            ELSIF ( Extract_Column_Value___(column_hdr_, column_value_, column_name_, '>', sub_expr_, column_datatype_) ) THEN
               column_expr_ := column_hdr_ || ' > ' || column_value_;
            ELSIF ( Extract_Column_Value___(column_hdr_, column_value_, column_name_, '=', sub_expr_, column_datatype_)) THEN
               column_expr_ := column_hdr_ || ' = ' || column_value_;
            ELSIF ( Extract_Between___(column_hdr_, column_from_value_, column_to_value_, column_name_, sub_expr_, column_datatype_)) THEN
               column_expr_ := column_hdr_ || ' BETWEEN ' || column_from_value_ || ' AND ' || column_to_value_;
            ELSIF (instr(sub_expr_, '%') > 0 OR instr(sub_expr_, '_') > 0) THEN
               column_expr_ := column_name_ || ' LIKE ' || Assert_SYS.Encode_Single_Quote_String( sub_expr_, TRUE ); 
            ELSE
               Get_Column_Value___(column_hdr_, column_value_, column_name_, sub_expr_, column_datatype_);
               column_expr_ := column_hdr_ || ' = ' || column_value_;
            END IF;
         END IF;
         where_ := where_ || delim_ || not_expr_ || column_expr_;
         delim_ := ' OR ';
         pos_ := to_ + 1;
         to_ := instr(expr_, ';', pos_);
      END LOOP;
   ELSE
      IF (flags_ LIKE 'M%') THEN
         Error_SYS.Appl_General(service_, 'COLVALERR: Value expected for column [:P1]', column_name_);
      END IF;
   END IF;
   IF (hit_all_) THEN
      IF (hit_null_) THEN
         parsed_column_ := NULL; -- both NULL and NOT NULL => no selection at all..
      ELSE
         parsed_column_ := column_name_ ||' IS NOT NULL';
      END IF;
   ELSE
      parsed_column_ := where_;
   END IF;
END Parse_Column_Where_;


@UncheckedAccess
PROCEDURE Enumerate_Lu_Reports_ (
   report_id_list_     OUT VARCHAR2,
   report_title_list_  OUT VARCHAR2,
   lu_name_            IN  VARCHAR2 )
IS
   rep_id_list_     VARCHAR2(32000);
   rep_title_list_  VARCHAR2(32000);
BEGIN
   FOR report IN get_lu_reports(lu_name_) LOOP
      rep_id_list_ := rep_id_list_ || report.report_id || field_separator_;
      rep_title_list_ := rep_title_list_ || report.report_title || field_separator_;
   END LOOP;
   report_id_list_ := rep_id_list_;
   report_title_list_ := rep_title_list_;
END Enumerate_Lu_Reports_;



@UncheckedAccess
PROCEDURE Enumerate_Report_Columns_ (
   column_name_list_   OUT VARCHAR2,
   column_prompt_list_ OUT VARCHAR2,
   column_title_list_  OUT VARCHAR2,
   column_query_list_  OUT VARCHAR2,
   column_status_list_ OUT VARCHAR2,
   report_id_          IN  VARCHAR2 )
IS
   col_name_list_   VARCHAR2(32000);
   col_prompt_list_ VARCHAR2(32000);
   col_title_list_  VARCHAR2(32000);
   col_query_list_  VARCHAR2(32000);
   col_status_list_ VARCHAR2(32000);
BEGIN
   FOR report_column IN get_report_columns(report_id_) LOOP
      col_name_list_ := col_name_list_ || report_column.column_name || field_separator_;
      col_prompt_list_ := col_prompt_list_ || report_column.column_prompt || field_separator_;
      col_title_list_ := col_title_list_ || report_column.column_title || field_separator_;
      col_query_list_ := col_query_list_ || report_column.column_query || field_separator_;
      col_status_list_ := col_status_list_ || report_column.status || field_separator_;
   END LOOP;
   column_name_list_ := col_name_list_;
   column_prompt_list_ := col_prompt_list_;
   column_title_list_ := col_title_list_;
   column_query_list_ := col_query_list_;
   column_status_list_ := col_status_list_;
END Enumerate_Report_Columns_;



@UncheckedAccess
PROCEDURE Enumerate_Report_Layouts_ (
   layout_name_list_   OUT VARCHAR2,
   layout_title_list_  OUT VARCHAR2,
   report_id_          IN  VARCHAR2 )
IS
   lay_name_list_      VARCHAR2(2000);
   lay_title_list_     VARCHAR2(2000);

   CURSOR get_layouts IS
      SELECT *
      FROM report_sys_layout_tab
      WHERE report_id = report_id_;

BEGIN
   FOR rec_ IN get_layouts LOOP
      lay_name_list_ := lay_name_list_ || rec_.layout_name || field_separator_;
      lay_title_list_ := lay_title_list_ || rec_.layout_title || field_separator_;
   END LOOP;
   layout_name_list_ := lay_name_list_;
   layout_title_list_ := lay_title_list_;
END Enumerate_Report_Layouts_;



@UncheckedAccess
PROCEDURE Enumerate_Report_Texts_ (
   text_name_list_     OUT VARCHAR2,
   text_list_          OUT VARCHAR2,
   report_id_          IN  VARCHAR2 )
IS
   text_names_         VARCHAR2(4000);
   texts_              VARCHAR2(32000);
   CURSOR get_report_texts(report_id_ IN VARCHAR2) IS
      SELECT text_name,
             text
      FROM   report_sys_text_tab
      WHERE  report_id = report_id_;
BEGIN
   FOR text IN get_report_texts(report_id_) LOOP
      text_names_ := text_names_ || text.text_name || field_separator_;
      texts_ := texts_ || text.text || field_separator_;
   END LOOP;
   text_name_list_ := text_names_;
   text_list_ := texts_;
END Enumerate_Report_Texts_;



@UncheckedAccess
PROCEDURE Enumerate_Report_Groups_ (
   group_name_list_    OUT VARCHAR2 )
IS
   tmp_ VARCHAR2(32000);
   CURSOR get_groups IS
      SELECT group_name
      FROM   report_sys_group_tab
      WHERE  substr(group_name, -4) = '_GRP';
BEGIN
   FOR grp IN get_groups LOOP
      tmp_ := tmp_ || grp.group_name || field_separator_;
   END LOOP;
   group_name_list_ := tmp_;
END Enumerate_Report_Groups_;



-- Define_Report_
--   Only to be called from rdf-files.
--   Inserts a report definition.
--   Only to be called from rdf-files.
--   Clear the previous report definition including layouts and texts
--   and then inserts the report definition.
--   A call to this method is to be followed by calls to the methods below.
PROCEDURE Define_Report_ (
   report_id_             IN VARCHAR2,
   module_                IN VARCHAR2,
   lu_name_               IN VARCHAR2,
   report_title_          IN VARCHAR2,
   table_name_            IN VARCHAR2,
   report_method_         IN VARCHAR2,
   life_                  IN NUMBER,
   master_                IN VARCHAR2 DEFAULT NULL,
   override_method_       IN VARCHAR2 DEFAULT NULL,
   remove_method_         IN VARCHAR2 DEFAULT NULL,
   report_mode_           IN VARCHAR2 DEFAULT 'PLSQL1.2',
   show_in_order_reports_ IN VARCHAR2 DEFAULT 'TRUE',
   domain_                IN VARCHAR2 DEFAULT NULL,
   category_              IN VARCHAR2 DEFAULT NULL)
IS
   overwrite_report_life_ BOOLEAN := Fnd_Setting_API.Get_Value('OVERWRITE_REP_LIFE') = 'YES';
   report_life_           NUMBER := life_;
   domain_id_             NUMBER := NULL;
   category_id_           NUMBER := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Report_');
   -- Validate that not both master and override_method has been stated, that would be a logical error!
   IF master_ IS NOT NULL AND override_method_ IS NOT NULL THEN
      Error_SYS.Appl_General(service_, 'ILLEGAL_COMBINATION: Design time error in report :P1. A report can only have either a master or a override method, not both!', report_id_);
   END IF;
   -- Validate that the supposed master exists (is already defined)
   IF master_ IS NOT NULL THEN
      Definition_Exist___(master_);
   END IF;
   
   -- Check if to prevent overwrite of report life when RDF is deployed
   IF (overwrite_report_life_) THEN
      report_life_ := Get_Lifetime(upper(report_id_));
   END IF;
   
   -- Validation that method and override_method exists is not possible here, they have not been created yet...
   -- Delete previous definitions (refresh)
   DELETE FROM report_sys_tab
      WHERE upper(report_id) = upper(report_id_);
   --
   -- Instead deleting the old layouts, we keep them to be able to
   -- preserve the in_use values.
   -- Define_Report_Layout will try to insert a new layout. If this
   -- generates a dup_val_on_index error (the layout is already defined),
   -- we'll do an update instead, without modifying the attributes
   -- mentioned above.
   --
   -- In order for this to work as intended it's essential that the RDF
   -- makes a call to Define_Report_ first, then any number of calls to
   -- Define_Report_Layout_ and finally calls the Refresh_ method.
   --

   domain_id_ := Report_Domain_API.Get_By_Description(domain_);
   category_id_ := Report_Category_API.Get_By_Description(category_);

   DELETE FROM report_sys_text_tab
      WHERE upper(report_id) = upper(report_id_);
   INSERT INTO report_sys_tab (
            report_id, module, lu_name,
            report_title, table_name, method,
            life, domain_id, category_id, master, override_method,
            remove, report_mode, layouts,
            texts, comments, prompt, show_in_order_reports, rowversion )
      VALUES (
         upper(report_id_), upper(module_), lu_name_,
         report_title_, table_name_, report_method_,
         report_life_, domain_id_, category_id_, master_, override_method_,
         remove_method_, report_mode_, NULL,
         NULL, NULL, NULL, show_in_order_reports_, SYSDATE );
		 
   -- New Result set gen config  entry.
   Report_Result_Gen_Config_API.Create_Default(report_id_);
END Define_Report_;


-- Define_Report_Layout_
--   Only to be called from rdf-files.
--   Inserts a layout definition for a report.
--   Several layouts can be defined for one report.
--   Only to be called from rdf-files.
--   Inserts a layout definition for a report.
--   Several layouts can be defined for one report.
--   Similar method to Report_Layout_Definition_API.Add_Layout but since this
--   one is only used in design-time, the parameters <design_time>, <in_use_>,
--   are set to default values and are
--   not available in this interface.
PROCEDURE Define_Report_Layout_ (
   report_id_       IN VARCHAR2,
   layout_name_     IN VARCHAR2,
   layout_title_    IN VARCHAR2,
   paper_format_db_ IN VARCHAR2 DEFAULT 'A4',
   order_by_ IN VARCHAR2 DEFAULT NULL,
   layout_type_db_ IN VARCHAR2 DEFAULT 'BUILDER',
   in_use_          IN BOOLEAN DEFAULT TRUE )
IS
   next_enumerate_order_ NUMBER;
   in_use_temp_string_   VARCHAR2(5);

   CURSOR get_enumerate_order IS
      SELECT nvl(max(enumerate_order), 0) + 1
      FROM report_sys_layout_tab
      WHERE upper(report_id) = upper(report_id_);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Report_Layout_');
   -- Validate that the report definition and the paper format exist
   Definition_Exist___(report_id_);
   Paper_Format_API.Exist_Db(paper_format_db_);
   Report_Layout_Type_API.Exist_Db(layout_type_db_);

   OPEN get_enumerate_order;
   FETCH get_enumerate_order INTO next_enumerate_order_;
   CLOSE get_enumerate_order;

   IF (in_use_) THEN
      in_use_temp_string_ := 'TRUE';
   ELSE
      in_use_temp_string_ := 'FALSE';
   END IF;

   INSERT INTO report_sys_layout_tab (
      report_id, layout_name, layout_title,
      paper_format, order_by, enumerate_order,
      design_time, in_use,layout_type, rowversion )
   VALUES (
      upper(report_id_), layout_name_, layout_title_,
      paper_format_db_, order_by_, next_enumerate_order_,
           'TRUE', in_use_temp_string_, layout_type_db_, SYSDATE );
   IF (layout_type_db_ = 'DESIGNER') THEN
      Report_Result_Gen_Config_API.Create_Default(report_id_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE report_sys_layout_tab
         SET layout_title = layout_title_,
             paper_format = paper_format_db_,
             order_by = order_by_,
             enumerate_order = next_enumerate_order_,
             design_time = 'TRUE',
             layout_type = layout_type_db_,
             rowversion = SYSDATE
         WHERE report_id = report_id_
         AND   layout_name = layout_name_;
END Define_Report_Layout_;


-- Define_Report_Text_
--   Only to be called from rdf-files.
--   Inserts a text definition for a report.
--   Several texts can be defined for one report.
--   Only to be called from rdf-files.
--   Inserts a text definition for a report.
--   Several texts can be defined for one report.
PROCEDURE Define_Report_Text_ (
   report_id_  IN VARCHAR2,
   text_name_  IN VARCHAR2,
   text_       IN VARCHAR2 )
IS
   rep_def_ report_sys_tab%ROWTYPE;
   old_     BOOLEAN;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Report_Text_');
   rep_def_ := Get_Report_Definition___(report_id_);

   -- three different cases
   -- 1) Fresh installation using the old concept
   --    (or erroneous use of old concept, but this can not be validated here)
   -- 2) Upgrade using the old concept
   -- 3) Fresh install or upgrade using the new concept.
   --
   -- Case 1 and 2 are eventually to be removed when migrating to new concept is done.
   -- Also an additional validation of report definition exist could be added to Case 3 then.

   IF (rep_def_.report_id IS NULL) OR ((rep_def_.report_id IS NOT NULL) AND (rep_def_.comments IS NOT NULL)) THEN
      -- 1) and 2)
      old_ := TRUE;
   ELSE
      -- 3)
      old_ := FALSE;
   END IF;

   INSERT INTO report_sys_text_tab(report_id, text_name, text)
      VALUES   (upper(report_id_), text_name_, text_);
EXCEPTION
   WHEN dup_val_on_index THEN
      IF old_ THEN
         UPDATE report_sys_text_tab
            SET   text = text_
            WHERE report_id = upper(report_id_)
            AND   text_name = text_name_;
      ELSE
         Error_SYS.Record_Exist(service_, 'REPTEXTEXIST: Design-time error! Report Text :P1 is already defined for Report :P2', text_name_, report_id_);
      END IF;
END Define_Report_Text_;


-- Define_Report_Column_
--   Only to be called for EXCEL repors from rdf-files .Use refresh_ for other report types.
--   Inserts a column definition for a report.
--   Several columns can be defined for one report
PROCEDURE Define_Report_Column_ (
   newrec_ IN report_coulmn_rec )
IS
   rep_def_ report_sys_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Report_Column_');
   Definition_Exist___(newrec_.report_id);
   rep_def_ := Get_Report_Definition___(newrec_.report_id);
   IF (rep_def_.report_mode != 'EXCEL1.0' ) THEN
      Error_SYS.Record_General(service_, 'INVALIDREPUSE: Invalid method usage. Use report refresh method to update report data.');
   END IF;

   INSERT INTO report_sys_column_tab (
      report_id, column_name, column_id, column_title, column_prompt, column_query, column_value, column_lov, column_flags, column_dataformat, column_qflags,
      item_name, enumerate_method, validate_method, status, column_type, lov_view, lov_enum, comments, rowversion )
   VALUES (
      newrec_.report_id,
      newrec_.column_name,
      newrec_.column_id,
      newrec_.column_title,
      newrec_.column_prompt,
      newrec_.column_query,
      newrec_.column_value,
      newrec_.column_lov,
      newrec_.column_flags,
      nvl(newrec_.column_dataformat, 'STRING'),
      nvl(newrec_.column_qflags,'OW-BL'),
      newrec_.item_name,
      newrec_.enumerate_method,
      newrec_.validate_method,
      newrec_.status,
      newrec_.column_type,
      newrec_.lov_view,
      newrec_.lov_enum,
      newrec_.comments,
      sysdate );
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE report_sys_column_tab
         SET column_id = newrec_.column_id,
             column_title = newrec_.column_title,
             column_prompt = newrec_.column_prompt,
             column_query = newrec_.column_query,
             column_value = newrec_.column_value,
             column_lov = newrec_.column_lov,
             column_flags = newrec_.column_flags,
             column_dataformat = nvl(newrec_.column_dataformat, 'STRING'),
             column_qflags = nvl(newrec_.column_qflags,'OW-BL'),
             item_name = newrec_.item_name,
             enumerate_method = newrec_.enumerate_method,
             validate_method = newrec_.validate_method,
             status = newrec_.status,
             column_type = newrec_.column_type,
             lov_view = newrec_.lov_view,
             lov_enum = newrec_.lov_enum,
             comments = newrec_.comments,
             rowversion = SYSDATE
         WHERE report_id = newrec_.report_id
         AND   column_name = newrec_.column_name;
END Define_Report_Column_;


-- Define_Quick_Report_
--   Only to be called from installation scripts.
--   Inserts a quick report and in the case the category does not already
--   exist also the quick report category is inserted.
--   Only to be called from installation scripts.
--   Inserts a quick report and in the case the category does not already
--   exist also the quick report category is inserted.
PROCEDURE Define_Quick_Report_ (
   quick_report_id_      OUT NUMBER,
   po_id_                OUT VARCHAR2,
   description_          IN  VARCHAR2,
   category_description_ IN  VARCHAR2,
   qr_type_db_           IN  VARCHAR2,
   sql_expression_       IN  VARCHAR2,
   file_name_            IN  VARCHAR2,
   comments_             IN  VARCHAR2 )
IS
   info_        VARCHAR2(2000);
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
   category_id_ NUMBER;
   report_exist EXCEPTION;
   PRAGMA       exception_init(report_exist, -20112);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Quick_Report_');
   -- Prepare for insertion and extract information to be returned
   Quick_Report_API.New__(info_, objid_, objversion_, attr_, 'PREPARE');
   quick_report_id_ := Client_SYS.Get_Item_Value('QUICK_REPORT_ID', attr_);
   -- Find appropriate category, or create it if it does not exist
   category_id_ := Report_Category_API.Get_By_Description(category_description_);
   -- Add attributes
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('CATEGORY_ID', category_id_, attr_);
   Client_SYS.Add_To_Attr('QR_TYPE_DB', qr_type_db_, attr_);
   IF sql_expression_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('SQL_EXPRESSION', sql_expression_, attr_);
   END IF;
   IF file_name_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('FILE_NAME', file_name_, attr_);
   END IF;
   IF comments_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('COMMENTS', comments_, attr_);
   END IF;
   -- Create the quick report and extract information to be returned
   BEGIN
      Quick_Report_API.New__(info_, objid_, objversion_, attr_, 'DO');
      po_id_ := Client_SYS.Get_Item_Value('PO_ID', attr_);
      -- Trace information to installer
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Quick Report '|| description_ || ' has been created in category '||category_description_||'!');
   EXCEPTION
      WHEN report_exist THEN
         -- Suppress errors, only trace the information to installer.
         -- This is to make installation scripts be possible to rerun.
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Quick Report '|| description_ || ' already existed in category '||category_description_||' and was not recreated!');
         quick_report_id_ := NULL;
   END;
END Define_Quick_Report_;


FUNCTION Parse_Report_Where_Expression_ (
   report_id_      IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2,
   sources_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   where_            VARCHAR2(32000);
   split_            NUMBER;
   qualifier_        VARCHAR2(31);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Report_Where_Expression_');
   split_ := instr(sources_, ',');
   IF (split_ > 0) THEN
      qualifier_ := substr(sources_, 1, split_ - 1) || '.';
   ELSE
      qualifier_ := NULL;
   END IF;
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (column_.column_query IS NOT NULL) THEN
         where_ := where_ || qualifier_ || column_.column_name || field_separator_ ||
                              Client_SYS.Get_Item_Value(column_.column_name, parameter_attr_) || field_separator_ ||
                              column_.column_dataformat || field_separator_ ||
                              column_.column_qflags || record_separator_;
      END IF;
   END LOOP;
   RETURN (Parse_Where_Expression_(where_));
END Parse_Report_Where_Expression_;


FUNCTION Parse_Where_Expression_ (
   parameter_string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   where_        VARCHAR2(32000);
   delim_        VARCHAR2(30);
   column_where_ VARCHAR2(2000);
   pos_          NUMBER;
   from_         NUMBER;
   to_           NUMBER;
   item_         VARCHAR2(2000);
   column_name_  VARCHAR2(61);
   column_value_ VARCHAR2(2000);
   column_type_  VARCHAR2(100);
   column_flags_ VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Where_Expression_');
   from_ := 1;
   to_ := instr(parameter_string_, record_separator_, from_);
   WHILE (to_ > 0) LOOP
      item_ := substr(parameter_string_, from_, to_ - from_);
      pos_  := instr(item_, field_separator_);
      column_name_  := substr(item_, 1, pos_ - 1);
      item_ := substr(item_, pos_ + 1);
      pos_  := instr(item_, field_separator_);
      IF (pos_ > 0) THEN
         column_value_ := substr(item_, 1, pos_ - 1);
         item_ := substr(item_, pos_ + 1);
      ELSE
         column_value_ := item_;
         item_ := NULL;
      END IF;
      pos_  := instr(item_, field_separator_);
      IF (pos_ > 0) THEN
         column_type_ := substr(item_, 1, pos_ - 1);
         item_ := substr(item_, pos_ + 1);
      ELSE
         column_type_ := item_;
         item_ := NULL;
      END IF;
      pos_  := instr(item_, field_separator_);
      IF (pos_ > 0) THEN
         column_flags_ := substr(item_, 1, pos_ - 1);
         item_ := substr(item_, pos_ + 1);
      ELSE
         column_flags_ := item_;
         item_ := NULL;
      END IF;
      Parse_Column_Where_(column_where_, column_name_, column_value_, nvl(column_flags_, 'OW-BL'), nvl(column_type_, 'STRING') );
      IF column_where_ IS NOT NULL THEN
         where_ := where_ || delim_ || '(' || column_where_ || ')';
         delim_ := ' AND ';
      END IF;
      from_ := to_ + 1;
      to_ := instr( parameter_string_, record_separator_, from_);
   END LOOP;
   RETURN (where_);
END Parse_Where_Expression_;


FUNCTION Parse_Where_Expression_ (
   table_view_       IN VARCHAR2, 
   parameter_string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pos_          NUMBER;
   from_         NUMBER;
   to_           NUMBER;
   item_         VARCHAR2(2000);
   column_name_  VARCHAR2(61);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Where_Expression_');
   -- Loop through record,
   from_ := 1;
   to_ := instr(parameter_string_, record_separator_, from_);
   WHILE (to_ > 0) LOOP
      item_ := substr(parameter_string_, from_, to_ - from_);
      pos_  := instr(item_, field_separator_);
      column_name_  := substr(item_, 1, pos_ - 1);
      
      -- Assert each column name
      Assert_Sys.Assert_Is_Table_Column( table_view_, column_name_ );
      
      from_ := to_ + 1;
      to_ := instr( parameter_string_, record_separator_, from_);
   END LOOP;
   RETURN Parse_Where_Expression_( parameter_string_ );
END Parse_Where_Expression_;


PROCEDURE Refresh_ (
   report_id_ IN VARCHAR2 )
IS
   rep_rec_                report_sys_tab%ROWTYPE;
   col_rec_                report_sys_column_tab%ROWTYPE;
   existing_rep_def_       report_sys_tab%ROWTYPE;
   master_                 VARCHAR2(30);
   already_defined_        BOOLEAN := FALSE;
   id_                     NUMBER;
   invalid_alternative_col EXCEPTION;

   CURSOR get_views(report_id_ IN VARCHAR2) IS
   SELECT table_name report_id, comments
      FROM   fnd_tab_comments
      WHERE  table_name = upper(report_id_)
      AND    substr(table_name, -4) = '_REP'
   UNION
   SELECT group_name report_id, comments
      FROM   report_sys_group_tab
      WHERE  group_name = upper(report_id_)
      AND    substr(group_name,-4) = '_GRP';

   CURSOR get_columns(report_id_ IN VARCHAR2, id_ IN NUMBER) IS
   SELECT A.column_name, B.column_id, A.comments, decode(B.data_type,'NUMBER','NUMBER','DATE','DATE','LONG','STRING(2000)','STRING'||'('||B.data_length||')') datatype
      FROM  fnd_col_comments A, user_tab_columns B
      WHERE A.table_name = B.table_name
      AND   A.column_name = B.column_name
      AND   A.table_name = report_id_
   UNION
   SELECT column_name, nvl(id_, ROWNUM) column_id, comments, NULL datatype
      FROM  report_sys_group_column_tab
      WHERE substr(group_name,-4) = '_GRP'
      AND   group_name = report_id_;

   CURSOR get_master_column(master_report_id_ IN VARCHAR2, column_name_ IN VARCHAR2) IS
      SELECT *
      FROM report_sys_column_tab
      WHERE report_id = master_report_id_
      AND   column_name = column_name_;

BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Refresh_');
   --
   -- Remove all layouts not updated/inserted after the report it self was defined.
   -- First Define_Report_ is called, then Define_Report_Layout_ and finally Refresh_.
   -- Define_Report_ no longer removes all layouts, instead all layouts not inserted
   -- or updated by a Define_Report_Layout_ calls should be removed. These layouts have
   -- obviously been removed from the RDF
   --
   -- Removing deletion code as this is no longer needed in Apps8 onwards as layouts definition are not defined in RDF but added from the installer
   --DELETE FROM report_sys_layout_tab
   --   WHERE    report_id = report_id_
   --   AND      design_time = 'TRUE'
   --   AND      rowversion < (SELECT rowversion from report_sys_tab WHERE report_id = report_id_);
   --
   -- This routine handles extraction from comments on view and columns.
   -- If the report is instead defined using interfaces Define_Report_ and Define_Layout_
   -- it should not be refreshed in this routine, except for the report columns that still
   -- use column comments to define necessary information (Query-properties, input items, etc.)
   --
   -- The goal is that all reports eventually should use the interfaces rather than comments
   -- and when this is the case, this refresh routine could be very much simplified.
   --

   existing_rep_def_ := Get_Report_Definition___(report_id_);

   IF (existing_rep_def_.report_id IS NOT NULL) AND (existing_rep_def_.comments IS NULL) THEN
      already_defined_ := TRUE;
   ELSE
      already_defined_ := FALSE;
   END IF;

   IF NOT already_defined_ THEN

      -- Remove current item
      DELETE
         FROM  report_sys_tab
         WHERE report_id = upper(report_id_)
         AND report_mode !='EXCEL1.0';

      -- Process current item view, i.e. LOOP once or not at all
      FOR view_ IN get_views(report_id_) LOOP
         rep_rec_.module := substr(Dictionary_SYS.Comment_Value_( 'MODULE', view_.comments),1,6);
         rep_rec_.lu_name := substr(Dictionary_SYS.Comment_Value_( 'LU', view_.comments),1,25);
         rep_rec_.report_title := NVL(substr(Dictionary_SYS.Comment_Value_( 'TITLE', view_.comments),1,50), report_id_);
         rep_rec_.prompt := substr(Dictionary_SYS.Comment_Value_( 'PROMPT', view_.comments),1,50);
         rep_rec_.report_mode := nvl(substr(Dictionary_SYS.Comment_Value_( 'MODE', view_.comments),1,20),'PLSQL1.2');
         rep_rec_.table_name := substr(Dictionary_SYS.Comment_Value_( 'TABLE', view_.comments),1,30);
         rep_rec_.method := substr(Dictionary_SYS.Comment_Value_( 'METHOD', view_.comments),1,61);
         rep_rec_.layouts := substr(Dictionary_SYS.Comment_Value_( 'LAYOUTS', view_.comments),1,2000);
         rep_rec_.texts := substr(Dictionary_SYS.Comment_Value_( 'TEXTS', view_.comments),1,2000);
         rep_rec_.life := nvl(to_number(Dictionary_SYS.Comment_Value_( 'LIFE', view_.comments)),0);
         rep_rec_.remove := substr(Dictionary_SYS.Comment_Value_( 'REMOVE', view_.comments),1,61);
         INSERT INTO report_sys_tab (
            report_id, module, lu_name,
            report_title, prompt,
            report_mode, table_name,
            method, layouts,
            texts, life,
            remove, comments, rowversion )
         VALUES (
            report_id_, rep_rec_.module, rep_rec_.lu_name,
            rep_rec_.report_title, rep_rec_.prompt,
            rep_rec_.report_mode, rep_rec_.table_name,
            rep_rec_.method, rep_rec_.layouts,
            rep_rec_.texts, rep_rec_.life,
            rep_rec_.remove, view_.comments, sysdate );

         -- Special handling for report groups and their columns?
         id_ := to_number(Dictionary_SYS.Comment_Value_( 'ID', view_.comments));

      END LOOP;

   END IF;

   -- Find master report if defined through definition interfaces
   IF already_defined_ THEN
      master_ := existing_rep_def_.master;
   ELSE
      master_ := NULL;
   END IF;

   existing_rep_def_ := Get_Report_Definition___(report_id_);
   IF existing_rep_def_.report_mode !='EXCEL1.0' THEN
   -- Process current item columns (Columns should always be handled)
      DELETE FROM  report_sys_column_tab
         WHERE report_id = report_id_;
      FOR columns_ IN get_columns(report_id_, id_) LOOP
         BEGIN
            IF columns_.comments IS NULL AND master_ IS NOT NULL THEN
               -- Copy from master report instead if exist
               -- Meaning that this column does not have any explicit comments
               -- for this alternative report, only the master has got it.
               -- Alternative reports can have some columns with comments on
               -- and for these extraction if comment information have to be handled correctly.

               -- Note that some columns do not have comments in normal cases (typically result_key)
               -- And then no copy should take place. Thus the double check with the variable master_
               -- (no hit in the cursor will NOT reset the record...)
               OPEN get_master_column(master_, columns_.column_name);
               FETCH get_master_column INTO col_rec_;
               CLOSE get_master_column;
            ELSE
               col_rec_.column_title := substr(Dictionary_SYS.Comment_Value_( 'TITLE', columns_.comments),1,50);
               col_rec_.column_prompt := substr(Dictionary_SYS.Comment_Value_( 'PROMPT', columns_.comments),1,50);
               col_rec_.column_query := substr(Dictionary_SYS.Comment_Value_( 'QUERY', columns_.comments),1,50);
               col_rec_.column_value := substr(Dictionary_SYS.Comment_Value_( 'QVALUE', columns_.comments),1,500);
               col_rec_.column_lov := substr(Dictionary_SYS.Comment_Value_( 'REF', columns_.comments),1,100);
               col_rec_.column_flags := substr(Dictionary_SYS.Comment_Value_( 'FLAGS', columns_.comments),1,5);
               col_rec_.column_dataformat := substr(Dictionary_SYS.Comment_Value_( 'DATATYPE', columns_.comments),1,30);
               col_rec_.column_qflags := substr(Dictionary_SYS.Comment_Value_( 'QFLAGS', columns_.comments),1,5);
               col_rec_.item_name := substr(Dictionary_SYS.Comment_Value_( 'ITEM_NAME', columns_.comments),1,30);
               col_rec_.enumerate_method := substr(Dictionary_SYS.Comment_Value_( 'ENUMERATE', columns_.comments),1,61);
               col_rec_.validate_method := substr(Dictionary_SYS.Comment_Value_( 'VALIDATE', columns_.comments),1,61);
               col_rec_.status := substr(Dictionary_SYS.Comment_Value_( 'STATUS', columns_.comments),1,100);
               -- New columns in cache
               IF (col_rec_.column_lov IS NOT NULL) THEN
                  Get_Ref_Properties___(col_rec_.column_lov, col_rec_.lov_view, col_rec_.lov_enum);
               ELSE
                  col_rec_.lov_view := NULL;
                  col_rec_.lov_enum := NULL;
               END IF;

               -- Error control to avoid developers trying to create query possibilities
               -- for an alternative report since that is not possible...
               IF master_ IS NOT NULL THEN
                  IF (col_rec_.column_query IS NOT NULL) OR
                     (col_rec_.column_value IS NOT NULL) OR
                     (col_rec_.column_lov IS NOT NULL) OR
                     (col_rec_.column_qflags IS NOT NULL) OR
                     (col_rec_.enumerate_method IS NOT NULL) OR
                     (col_rec_.validate_method IS NOT NULL) OR
                     (col_rec_.status IS NOT NULL) THEN

                     RAISE invalid_alternative_col;

                  END IF;
               END IF;
            END IF;

            INSERT INTO report_sys_column_tab (
               report_id, column_name, column_id, column_title, column_prompt, column_query, column_value, column_lov, column_flags, column_dataformat, column_qflags,
               item_name, enumerate_method, validate_method, status, column_type, lov_view, lov_enum, comments, rowversion )
            VALUES (
               report_id_, columns_.column_name, columns_.column_id,
               col_rec_.column_title, col_rec_.column_prompt,
               col_rec_.column_query, col_rec_.column_value,
               col_rec_.column_lov, col_rec_.column_flags,
               nvl(col_rec_.column_dataformat, 'STRING'), nvl(col_rec_.column_qflags,'OW-BL'),
               col_rec_.item_name, col_rec_.enumerate_method,
               col_rec_.validate_method, col_rec_.status,
               columns_.datatype, col_rec_.lov_view, col_rec_.lov_enum, columns_.comments, sysdate );
         EXCEPTION
            WHEN invalid_alternative_col THEN
               Error_SYS.Appl_General(service_, 'ALTREPCOLERR: Report column comments are invalid for column [:P1]! Only TITLE, PROMPT, FLAGS and ITEM_NAME are allowed for columns in an alternative report!', columns_.column_name);
            WHEN OTHERS THEN
               Error_SYS.Appl_General(service_, 'REPCACHECOLERR: Report column [:P1] or comments are invalid. Error [:P2] raised', report_id_||'.'||columns_.column_name, SQLERRM );
         END;
      END LOOP;
   END IF;
   @ApproveDynamicStatement(2021-01-12,mabalk)
   EXECUTE IMMEDIATE 'GRANT SELECT ON ' || report_id_ || ' TO IFSPRINT WITH GRANT OPTION';
   Aurena_Report_Metadata_SYS.Initialize_Report__(report_id_);

EXCEPTION
   WHEN OTHERS THEN
      IF (NOT Error_SYS.Is_Foundation_Error(SQLCODE)) THEN
         Error_SYS.Appl_General(service_, 'REPCACHEERR: Report view [:P1] or comments are invalid. Error [:P2] raised', report_id_, SQLERRM );
      ELSE
         RAISE;
      END IF;
END Refresh_;

-- Check_Reference_Storage_
--   Check whether a rebuild of the internal report storage is
--   needed or not. Returns a boolean value (number) as an answer.
@UncheckedAccess
PROCEDURE Check_Reference_Storage_ (
   rebuild_needed_ OUT NUMBER,
   report_id_      IN VARCHAR2 DEFAULT NULL )
IS
   dummy_       NUMBER;
   CURSOR get_report_columns IS
      SELECT 1
      FROM fnd_col_comments fc, report_sys_tab r
      WHERE fc.comments IS NOT NULL
      AND   fc.table_name=r.report_id
      AND   r.report_id = NVL(report_id_, r.report_id)
      AND NOT EXISTS
      (SELECT 1
       FROM report_sys_column_tab r
       WHERE fc.table_name=r.report_id
       AND fc.column_name=r.column_name
       AND fc.comments=r.comments)
      UNION
      SELECT 1
      FROM  report_sys_group_column_tab g
      WHERE SUBSTR(g.group_name,-4) = '_GRP'
      AND NOT EXISTS
      (SELECT 1
       FROM report_sys_column_tab rc
       WHERE rc.report_id=g.group_name
       AND   rc.column_name=g.column_name
       AND   rc.comments=g.comments)
      UNION
      SELECT 1
      FROM fnd_col_comments fc, report_sys_tab r
      WHERE fc.comments IS NULL
      AND   fc.table_name=r.report_id
      AND   r.report_id = NVL(report_id_, r.report_id)
      AND EXISTS
      (SELECT 1
       FROM report_sys_column_tab rsc, report_sys_tab rs, fnd_col_comments fcc
       WHERE fc.table_name=rs.report_id
       AND rsc.report_id = rs.master
       AND fc.column_name=rsc.column_name
       AND fcc.table_name=rsc.report_id
       AND fcc.column_name=fc.column_name
       AND fcc.comments!=rsc.comments);
BEGIN
   OPEN get_report_columns;
   FETCH get_report_columns INTO dummy_;
   IF (get_report_columns%NOTFOUND) THEN
      CLOSE get_report_columns;
      rebuild_needed_ := 0;            -- Return FALSE
   ELSE
      CLOSE get_report_columns;
      rebuild_needed_ := 1;            -- Return TRUE
   END IF;
END Check_Reference_Storage_;

@UncheckedAccess
FUNCTION Check_Reference_Storage_ (
   report_id_      IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   rebuild_needed_       NUMBER;
BEGIN
   Check_Reference_Storage_(rebuild_needed_, report_id_);
   RETURN rebuild_needed_;
END Check_Reference_Storage_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Run_Plsql (
   proc_name_  IN VARCHAR2,
   bind_list_  IN VARCHAR2,
   value_list_ IN VARCHAR2,
   type_list_  IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Run_Plsql');
   Run_Plsql__(proc_name_, bind_list_, value_list_, type_list_);
END Run_Plsql;


@UncheckedAccess
FUNCTION Get_Translated_Text (
   report_id_ IN VARCHAR2,
   text_name_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   text_         VARCHAR2(2000);
   logical_unit_ VARCHAR2(2000);
BEGIN
   SELECT lu_name INTO logical_unit_
      FROM report_sys_tab
      WHERE report_id = report_id_;
   SELECT text INTO text_
      FROM  report_sys_text_tab
      WHERE report_id = report_id_
      AND   text_name = text_name_;
   RETURN (Language_SYS.Translate_Report_Text_(logical_unit_, report_id_, text_name_, text_, nvl(lang_code_, Language_SYS.Get_Print_Language)));
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Translated_Text;



PROCEDURE Parse_Column_Where (
   parsed_column_   OUT VARCHAR2,
   column_name_     IN  VARCHAR2,
   expression_      IN  VARCHAR2,
   flags_           IN  VARCHAR2,
   column_datatype_ IN  VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Column_Where');
   Parse_Column_Where_(parsed_column_, column_name_, expression_, flags_, column_datatype_);
END Parse_Column_Where;


FUNCTION Parse_Report_Where_Expression (
   report_id_      IN VARCHAR2,
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2,
   sources_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Report_Where_Expression');
   Assert_SYS.Assert_Match_Regexp( parameter_attr_, '^[^'']*$' );
   RETURN (Parse_Report_Where_Expression_(report_id_, report_attr_, parameter_attr_, sources_));
END Parse_Report_Where_Expression;


FUNCTION Parse_Where_Expression (
   parameter_string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Where_Expression');
   RETURN (Parse_Where_Expression_(parameter_string_));
END Parse_Where_Expression;


FUNCTION Parse_Where_Expression (
   table_view_       IN VARCHAR2, 
   parameter_string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Parse_Where_Expression');
   RETURN (Parse_Where_Expression_(table_view_, parameter_string_));
END Parse_Where_Expression;


PROCEDURE Method_Exist (
   method_ IN VARCHAR2 )
IS
   pkg_   VARCHAR2(40);
   meth_  VARCHAR2(40);
   pos_   NUMBER;
   dummy_ NUMBER;

   CURSOR get_meth IS
   SELECT 1
   FROM user_source
   WHERE name = pkg_
   AND   type = 'PACKAGE'
   AND   (upper(replace(text,'_','-')) LIKE '%FUNCTION %'||meth_||'%(%' OR
          upper(replace(text,'_','-')) LIKE '%PROCEDURE %'||meth_||'%(%');
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Method_Exist');
   pos_ := instr(method_, '.');
   IF (pos_ > 0) THEN
      pkg_ := upper(substr(method_, 1, pos_ - 1));
      meth_ := upper(replace(substr(method_, pos_ + 1),'_','-'));
      OPEN get_meth;
      FETCH get_meth INTO dummy_;
      IF get_meth%FOUND THEN
         CLOSE get_meth;
         RETURN;
      ELSE
         CLOSE get_meth;
      END IF;
   END IF;
   Error_SYS.Appl_General(service_, 'METHEXIST: Method [:P1] does not exist', method_);
END Method_Exist;


@UncheckedAccess
FUNCTION Ora_Error (
   ora_error_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (replace(ora_error_, 'ORA-', 'Oracle Error '));
END Ora_Error;



PROCEDURE Run_Group (
   group_attr_        IN VARCHAR2,
   parameter_attr_    IN VARCHAR2 )
IS
   mode_      VARCHAR2(30);
   report_id_ VARCHAR2(30);
   comments_  VARCHAR2(2000);
   method_    VARCHAR2(100);
   stmt_      VARCHAR2(2000);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Run_Group');
   report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', group_attr_);
   Group_Exist(report_id_);
   Get_Group_Comments(comments_, report_id_);
   method_ := Dictionary_SYS.Comment_Value_('METHOD', comments_);
   Method_Exist(method_);
   mode_ := Dictionary_SYS.Comment_Value_('MODE', comments_);
   IF (mode_ = 'PLSQL1.2') THEN
      Assert_SYS.Assert_Is_Package_Method(method_);
      stmt_ := 'begin '||method_||'(:group_attr_, :parameter_attr_); end;';
      Put_Trace___('STATEMENT= '||stmt_);
      Put_Trace___('METHOD= '||method_);
      Put_Trace___('GROUP_ATTR= '||group_attr_);
      Put_Trace___('PARAMETER_ATTR= '||parameter_attr_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE stmt_ USING group_attr_, parameter_attr_;
   ELSE
      Error_SYS.Appl_General('Report', 'MODEERR: Illegal report mode [:P1] for report [:P2]', mode_, report_id_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (Error_SYS.Is_Foundation_Error(SQLCODE)) THEN
         RAISE;
      ELSE
         Error_SYS.Appl_General(service_, 'REPRUNERR: Error [:P1] in report method [:P2]', Ora_Error(SQLERRM), method_);
      END IF;
END Run_Group;


PROCEDURE Group_Exist (
   group_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Group_Exist');
   SELECT 1
      INTO dummy_
      FROM report_sys_group_tab
      WHERE group_name = group_id_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(service_, 'GRPEXISTERR: Report group [:P1] does not exist', group_id_);
   WHEN OTHERS THEN
      Error_SYS.Appl_General(service_, 'GRPUNEXPERR: Unexpected error for report group [:P1]', group_id_);
END Group_Exist;


@UncheckedAccess
PROCEDURE Get_Group_Comments (
   comments_ OUT VARCHAR2,
   group_id_ IN  VARCHAR2 )
IS
BEGIN
   SELECT comments
      INTO comments_
      FROM report_sys_group_tab
      WHERE group_name = group_id_;
END Get_Group_Comments;



PROCEDURE Define_Group (
   group_name_  IN VARCHAR2,
   comments_    IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Group');
   DELETE FROM report_sys_group_tab
      WHERE group_name = upper(group_name_);
   DELETE FROM report_sys_group_column_tab
      WHERE group_name = upper(group_name_);
   INSERT INTO report_sys_group_tab (
      group_name,
      comments )
   VALUES (
      upper(group_name_),
      comments_ );
END Define_Group;


PROCEDURE Define_Group_Column (
   group_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   comments_    IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Define_Group_Column');
   UPDATE report_sys_group_column_tab
      SET   comments = comments_
      WHERE group_name = upper(group_name_)
      AND   column_name = upper(column_name_);
   IF (SQL%NOTFOUND) THEN
      INSERT INTO report_sys_group_column_tab (
         group_name, column_name, comments )
      VALUES (
         upper(group_name_), upper(column_name_), comments_ );
   END IF;
END Define_Group_Column;


@UncheckedAccess
FUNCTION Parse_Parameter (
   column_    IN VARCHAR2,
   parameter_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   from_             NUMBER;
   to_               NUMBER;
   pos_              NUMBER;
   value_            VARCHAR2(500);
   from_value_       VARCHAR2(500);
   to_value_         VARCHAR2(500);
   parm_list_        VARCHAR2(32000);
BEGIN
   IF (parameter_ IS NULL) THEN
      RETURN ('TRUE');
   ELSE
      parm_list_ := parameter_ || ';';
   END IF;
   from_ := 1;
   to_ := instr(parm_list_, ';', from_);
   WHILE (to_ > 0) LOOP
      value_ := ltrim(rtrim(substr(parm_list_, from_, to_ - from_)));
      pos_ := instr(value_, '..');
      IF (pos_ > 0) THEN
-- Handle between values
         IF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
            RETURN ('ERROR');
         ELSE
            from_value_ := rtrim(substr(value_, 1, pos_ - 1));
            to_value_ := ltrim(substr(value_, pos_ + 2));
            IF (from_value_ <= to_value_) THEN
               IF (column_ BETWEEN from_value_ AND to_value_) THEN
                  RETURN ('TRUE');
               END IF;
            ELSE
               IF (column_ BETWEEN to_value_ AND from_value_) THEN
                  RETURN ('TRUE');
               END IF;
            END IF;
         END IF;
-- Handle wildcards
      ELSIF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
         IF (instr(value_, '..') > 0) THEN
            RETURN ('ERROR');
         ELSIF (substr(value_, 1, 2) = '<>') THEN  
            IF (column_ NOT LIKE ltrim(substr(value_,3))) THEN
               RETURN ('TRUE');
            END IF;
         ELSIF (value_ = '!%') THEN 
            IF (column_ IS NULL) THEN 
               RETURN 'TRUE'; 
            END IF; 
         ELSIF(column_ LIKE value_) THEN 
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '<=') THEN
         IF (column_ <= ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '>=') THEN
         IF (column_ >= ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '!=') THEN
         IF (column_ <> ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
	   ELSIF (substr(value_, 1, 2) = '<>') THEN 
         IF ((instr(parm_list_, column_||';')=0)) THEN
            RETURN ('TRUE');
        END IF;   
      ELSIF (substr(value_, 1, 1) = '<') THEN
         IF (column_ < ltrim(substr(value_,2))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 1) = '>') THEN
         IF (column_ > ltrim(substr(value_,2))) THEN
            RETURN ('TRUE');
         END IF;
      ELSE
         IF ((column_ = value_) AND (substr(trim(parm_list_), 1, 2) != '<>')) THEN
            RETURN ('TRUE');
         END IF;
      END IF;
      from_ := to_ + 1;
      to_ := instr(parm_list_, ';', from_);
   END LOOP;
   RETURN ('FALSE');
EXCEPTION
   WHEN OTHERS THEN
      RETURN ('ERROR');
END Parse_Parameter;



@UncheckedAccess
FUNCTION Parse_Parameter (
   column_    IN NUMBER,
   parameter_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   from_              NUMBER;
   to_                NUMBER;
   pos_               NUMBER;
   value_             VARCHAR2(500);
   from_value_        VARCHAR2(500);
   to_value_          VARCHAR2(500);
   parm_list_         VARCHAR2(32000);
BEGIN
   IF (parameter_ IS NULL) THEN
      RETURN ('TRUE');
   ELSE
      parm_list_ := parameter_ || ';';
   END IF;
   from_ := 1;
   to_ := instr(parm_list_, ';', from_);
   WHILE (to_ > 0) LOOP
      value_ := ltrim(rtrim(substr(parm_list_, from_, to_ - from_)));
      pos_ := instr(value_, '..');
      value_ := replace(value_,',','.');
      IF (pos_ > 0) THEN
-- Handle between values
         IF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
            RETURN ('ERROR');
         ELSE
            from_value_ := rtrim(substr(value_, 1, pos_ - 1));
            to_value_ := ltrim(substr(value_, pos_ + 2));
            IF (to_number(from_value_) <= to_number(to_value_)) THEN
               IF (column_ BETWEEN to_number(from_value_) AND to_number(to_value_)) THEN
                  RETURN ('TRUE');
               END IF;
            ELSE
               IF (column_ BETWEEN to_number(to_value_) AND to_number(from_value_)) THEN
                  RETURN ('TRUE');
               END IF;
            END IF;
         END IF;
-- Handle wildcards
      ELSIF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
         IF (instr(value_, '..') > 0) THEN
            RETURN ('ERROR');
         ELSIF (substr(value_, 1, 2) = '<>') THEN   
            IF (column_ NOT LIKE ltrim(substr(value_,3))) THEN
               RETURN ('TRUE');
            END IF;  
         ELSIF (value_ = '!%') THEN 
            IF (column_ IS NULL) THEN 
               RETURN 'TRUE'; 
            END IF; 
         ELSIF(column_ LIKE value_) THEN 
            RETURN ('TRUE');
         END IF;     
      ELSIF (substr(value_, 1, 2) = '<=') THEN
         IF (column_ <= to_number(ltrim(substr(value_,3)))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '>=') THEN
         IF (column_ >= to_number(ltrim(substr(value_,3)))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '!=') THEN
         IF (column_ <> to_number(ltrim(substr(value_,3)))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '<>') THEN 
         IF ((instr(parm_list_, column_||';')=0)) THEN
            RETURN ('TRUE');
         END IF;  	 
      ELSIF (substr(value_, 1, 1) = '<') THEN
         IF (column_ < to_number(ltrim(substr(value_,2)))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 1) = '>') THEN
         IF (column_ > to_number(ltrim(substr(value_,2)))) THEN
            RETURN ('TRUE');
         END IF;
      ELSE
         IF ((column_ = to_number(value_)) AND (substr(trim(parm_list_), 1, 2) != '<>')) THEN
            RETURN ('TRUE');
         END IF;
      END IF;
      from_ := to_ + 1;
      to_ := instr(parm_list_, ';', from_);
   END LOOP;
   RETURN ('FALSE');
EXCEPTION
   WHEN OTHERS THEN
      RETURN ('ERROR');
END Parse_Parameter;



@UncheckedAccess
FUNCTION Parse_Parameter (
   column_    IN DATE,
   parameter_ IN VARCHAR2,
   format_    IN VARCHAR2 DEFAULT 'DATE' ) RETURN VARCHAR2
IS
   from_             NUMBER;
   to_               NUMBER;
   pos_              NUMBER;
   value_            VARCHAR2(500);
   from_value_       VARCHAR2(500);
   to_value_         VARCHAR2(500);
   parm_list_        VARCHAR2(32000);
   fmt_              VARCHAR2(22);
BEGIN
   IF (parameter_ IS NULL) THEN
      RETURN ('TRUE');
   ELSE
      parm_list_ := parameter_ || ';';
   END IF;
   IF (format_ = 'DATETIME') THEN
      fmt_ := Report_SYS.datetime_format_;
   ELSIF (format_ = 'TIME') THEN
      fmt_ := Report_SYS.time_format_;
   ELSE
      fmt_ := Report_SYS.date_format_;
   END IF;
   from_ := 1;
   to_ := instr(parm_list_, ';', from_);
   WHILE (to_ > 0) LOOP
      value_ := ltrim(rtrim(substr(parm_list_, from_, to_ - from_)));
      pos_ := instr(value_, '..');
      IF (pos_ > 0) THEN
-- Handle between values
         IF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
            RETURN ('ERROR');
         ELSE
            from_value_ := rtrim(substr(value_, 1, pos_ - 1));
            to_value_ := ltrim(substr(value_, pos_ + 2));
            IF (from_value_ <= to_value_) THEN
               IF (to_char(column_, fmt_) BETWEEN from_value_ AND to_value_) THEN
                  RETURN ('TRUE');
               END IF;
            ELSE
               IF (to_char(column_, fmt_) BETWEEN to_value_ AND from_value_) THEN
                  RETURN ('TRUE');
               END IF;
            END IF;
         END IF;
-- Handle wildcards
      ELSIF (instr(value_, '%') > 0 OR instr(value_, '_') > 0 ) THEN
         IF (instr(value_, '..') > 0) THEN
            RETURN ('ERROR');
         ELSIF (substr(value_, 1, 2) = '<>') THEN   
            IF(to_char(column_, fmt_) NOT LIKE ltrim(substr(value_,3))) THEN
               RETURN ('TRUE');
            END IF;            
         ELSIF (value_ = '!%') THEN 
            IF (column_ IS NULL) THEN 
               RETURN 'TRUE'; 
            END IF; 
         ELSIF(to_char(column_, fmt_) LIKE value_) THEN 
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '<=') THEN
         IF (to_char(column_, fmt_) <= ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '>=') THEN
         IF (to_char(column_, fmt_) >= ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '!=') THEN
         IF (to_char(column_, fmt_) <> ltrim(substr(value_,3))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 2) = '<>') THEN
         IF ((instr(parm_list_, to_char(column_, fmt_)||';')=0)) THEN
            RETURN ('TRUE');
      END IF;
      ELSIF (substr(value_, 1, 1) = '<') THEN
         IF (to_char(column_, fmt_) < ltrim(substr(value_,2))) THEN
            RETURN ('TRUE');
         END IF;
      ELSIF (substr(value_, 1, 1) = '>') THEN
         IF (to_char(column_, fmt_) > ltrim(substr(value_,2))) THEN
            RETURN ('TRUE');
         END IF;
      ELSE
         IF ((to_char(column_, fmt_) = value_) AND (substr(trim(parm_list_), 1, 2) != '<>')) THEN
            RETURN ('TRUE');
         END IF;
      END IF;
      from_ := to_ + 1;
      to_ := instr(parm_list_, ';', from_);
   END LOOP;
   RETURN ('FALSE');
EXCEPTION
   WHEN OTHERS THEN
      RETURN ('ERROR');
END Parse_Parameter;



PROCEDURE Run_Report (
   result_key_     OUT NUMBER,
   report_attr_    IN  VARCHAR2,
   parameter_attr_ IN  VARCHAR2 )
IS
   report_id_     VARCHAR2(30);
   res_key_       NUMBER;
   report_def_    report_sys_tab%ROWTYPE;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Run_Report');
   Assert_SYS.Assert_Match_Regexp( parameter_attr_, '^[^'']*');
   report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
   Report_Definition_API.Check_Report_Def_User__(report_id_);
   Get_Result_Key__(res_key_);
   Archive_API.Init_Archive_item(res_key_, report_id_, SYSDATE, Fnd_Session_API.Get_Fnd_User);
   Fnd_Context_SYS.Set_Value('REPORT_SYS.Report_In_Progress', res_key_);
   Error_SYS.Check_Not_Null(service_, 'REPORT_ID', report_id_);
   report_def_ := Get_Report_Definition___(report_id_);
   Put_Trace___('MODE= '||report_def_.report_mode);
   IF (report_def_.report_mode IN ( 'PLSQL1.2','FINREP','EXCEL1.0') ) OR  (report_def_.report_mode IS NULL) THEN
      Method_Exist(report_def_.method);
      Run_Report_Method___(res_key_, report_def_.method, report_attr_, parameter_attr_);
   ELSIF (report_def_.report_mode = 'DYN1.2') THEN
      Populate_Parent_Child__(res_key_, report_def_.table_name, report_id_, report_attr_, parameter_attr_);
   ELSIF (report_def_.report_mode = 'LOG') THEN
      Error_SYS.Appl_General(service_, 'RUNMODELOG: Design time error, unable to run report with mode [:P1]', report_def_.report_mode);
   ELSE
      Error_SYS.Appl_General(service_, 'RUNMODEERR: Design time error, illegal mode [:P1]', report_def_.report_mode);
   END IF;
   Fnd_Context_SYS.Set_Value('REPORT_SYS.Report_In_Progress', TO_NUMBER(NULL));
   result_key_ := res_key_;
END Run_Report;


@UncheckedAccess
FUNCTION Get_Lu_Name (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   report_definition_ report_sys_tab%ROWTYPE;
BEGIN
   report_definition_ := Get_Report_Definition___(report_id_);
   RETURN (report_definition_.lu_name);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Lu_Name;



@UncheckedAccess
FUNCTION Get_Report_Title (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   report_definition_ report_sys_tab%ROWTYPE;
BEGIN
   report_definition_ := Get_Report_Definition___(report_id_);
   RETURN (report_definition_.report_title);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Report_Title;



@UncheckedAccess
PROCEDURE Enumerate_Reports (
   report_id_list_ OUT VARCHAR2 )
IS
   view_list_ VARCHAR2(32000);
BEGIN
   FOR report IN get_reports LOOP
      view_list_ := view_list_ || report.report_id || field_separator_;
   END LOOP;
   report_id_list_ := view_list_;
END Enumerate_Reports;



@UncheckedAccess
FUNCTION Get_Default_Paper_Format(
   user_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   paper_format_ VARCHAR2(20);
   fnd_user_ VARCHAR2(20) := user_;
BEGIN
   IF (fnd_user_ IS NULL) THEN
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   paper_format_ := Fnd_User_API.Get_Property(fnd_user_, 'DEFAULT_PAPER_FORMAT');
   IF paper_format_ = 'SYSTEM-DEFINED' THEN
      paper_format_ := Fnd_Setting_API.Get_Value('DEFAULT_PAPER_FORMAT');
   END IF;
   RETURN nvl(paper_format_, 'A4');
END Get_Default_Paper_Format;



@UncheckedAccess
-- ## to be considered for CORE Security ##
PROCEDURE Get_Description (
   report_title_ OUT VARCHAR2,
   lu_name_      OUT VARCHAR2,
   module_       OUT VARCHAR2,
   report_id_    IN  VARCHAR2 )
IS
BEGIN
   SELECT report_title, lu_name, module
      INTO  report_title_, lu_name_, module_
      FROM  report_sys_tab
      WHERE report_id = report_id_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(service_, 'REPERR: Report [:P1] does not exist', report_id_);
END Get_Description;


@UncheckedAccess
FUNCTION Get_Lifetime (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   report_definition_ report_sys_tab%ROWTYPE;
BEGIN
   report_definition_ := Get_Report_Definition___(report_id_);
   RETURN (nvl(report_definition_.life, 0));
EXCEPTION
   WHEN OTHERS THEN
      RETURN (0);
END Get_Lifetime;



@UncheckedAccess
FUNCTION Get_Layouts (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   report_definition_ report_sys_tab%ROWTYPE;
BEGIN
   report_definition_ := Get_Report_Definition___(report_id_);
   RETURN (report_definition_.layouts);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Layouts;



@UncheckedAccess
FUNCTION Get_Column_Title (
   report_id_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   column_title_ VARCHAR2(100);
BEGIN
   SELECT column_title
         INTO  column_title_
         FROM  report_sys_column_tab
         WHERE report_id = report_id_
         AND   column_name = column_name_;
   RETURN (column_title_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Column_Title;



@UncheckedAccess
FUNCTION Get_Column_Query (
   report_id_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   column_query_ VARCHAR2(50);
BEGIN
   SELECT column_query
      INTO  column_query_
      FROM  report_sys_column_tab
      WHERE report_id = report_id_
      AND   column_name = column_name_;
   RETURN (column_query_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Column_Query;



@UncheckedAccess
-- ## to be considered for CORE Security ##
FUNCTION Get_Report_Text (
   report_id_   IN VARCHAR2,
   text_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   report_text_ VARCHAR2(500);
BEGIN
   SELECT text
      INTO  report_text_
      FROM  report_sys_text_tab
      WHERE report_id = report_id_
      AND   text_name = text_name_;
   RETURN (report_text_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(service_, 'REPTXTERR: Free text [:P1] not defined for report [:P2].', text_name_, report_id_);
END Get_Report_Text;


@UncheckedAccess
-- ## to be considered for CORE Security ##
FUNCTION Get_Layout_Title (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   layout_title_ VARCHAR2(100);
   layouts_      VARCHAR2(2000);
   from_         NUMBER;
   to_           NUMBER;
   start_        NUMBER;
BEGIN
   layouts_ := Get_Layouts(report_id_) || ',';
   from_ := instr(layouts_, layout_name_ || '=');
   IF (from_ > 0) THEN
      start_ := from_ + length(layout_name_) + 1;
      to_ := instr(layouts_, ',', start_);
      IF (to_ > 0) THEN
         layout_title_ := substr(layouts_, start_, to_ - start_);
         to_ :=instr(layout_title_, '/');
         IF (to_ > 0) THEN
            layout_title_ := substr(layout_title_, 1, to_ - 1);
         END IF;
         RETURN (layout_title_);
      END IF;
   END IF;
   Error_SYS.Appl_General(service_, 'LAYTITLEERR: Design time error. Illegal layout definition [:P1] for report [:P2].', layouts_, report_id_);
END Get_Layout_Title;


PROCEDURE Remove_Instance (
   report_id_  IN VARCHAR2,
   result_key_ IN NUMBER )
IS
   report_def_ report_sys_tab%ROWTYPE;
   remove_     VARCHAR2(61);
   stmt_       VARCHAR2(200);
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Remove_Instance');
   report_def_ := Get_Report_Definition___(report_id_);
   remove_ := report_def_.remove;
   IF (remove_ IS NULL) THEN
      Delete_From_Table___(report_def_.table_name, result_key_);
   ELSE
      Assert_SYS.Assert_Is_Procedure(remove_);
      stmt_ := 'begin '||remove_||'(:result_key_); end;';
      Put_Trace___(stmt_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE stmt_ USING result_key_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(service_, 'DELINSTERR: Unable to remove instance for report [:P1]', report_id_);
END Remove_Instance;


PROCEDURE Set_Report_Trace (
   trace_value_ IN NUMBER )
IS
BEGIN
   NULL; -- Use Log_SYS instead
END Set_Report_Trace;


@UncheckedAccess
PROCEDURE Get_Logical_Unit_Groups (
   lu_name_        IN  VARCHAR2,
   view_list_      OUT VARCHAR2,
   package_list_   OUT VARCHAR2 )
IS
   temp1_    VARCHAR2(32000);
   temp2_    VARCHAR2(32000);
   method_   VARCHAR2(1000);
   pos_      NUMBER;
   CURSOR groups IS
      SELECT group_name,comments
      FROM   report_sys_group_tab
      WHERE  comments LIKE '%LU='||lu_name_||'^%'
      AND    substr(group_name,-4) = '_GRP';
BEGIN
   -- Fetch all groups that are associated with a specified logical unit
   FOR cmt IN groups LOOP
      temp1_ := temp1_||cmt.group_name||field_separator_;
      method_ := Dictionary_SYS.Comment_Value_('METHOD', cmt.comments);
      pos_ := instr(method_, '.');
      IF (pos_ > 0) THEN
         temp2_ := temp2_||substr(method_, 1, pos_ - 1)||field_separator_;
      END IF;
   END LOOP;
   view_list_ := temp1_;
   package_list_ := temp2_;
END Get_Logical_Unit_Groups;



@UncheckedAccess
FUNCTION Get_Last_Ddl_Time (
   report_id_ IN VARCHAR2 ) RETURN DATE
IS
   ddl_time_ DATE;
BEGIN
   SELECT last_ddl_time
      INTO  ddl_time_
      FROM  user_objects
      WHERE object_name = report_id_
      AND   object_type = 'VIEW';
   RETURN (ddl_time_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Last_Ddl_Time;



@UncheckedAccess
FUNCTION Should_Generate_Result_Set (
   report_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   result_gen_config_    REPORT_RESULT_GEN_CONFIG_API.Public_Rec;
BEGIN
   result_gen_config_ := Report_Result_Gen_Config_API.Get(report_id_);
   IF result_gen_config_.create_result_set IS NULL THEN
      RETURN TRUE;
   ELSIF result_gen_config_.in_use = 'FALSE' THEN
      RETURN TRUE;
   ELSE
      RETURN result_gen_config_.create_result_set = 'TRUE';
   END IF;
END Should_Generate_Result_Set;


@UncheckedAccess
FUNCTION Should_Generate_Xml (
   report_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   result_gen_config_    REPORT_RESULT_GEN_CONFIG_API.Public_Rec;
BEGIN
   result_gen_config_ := Report_Result_Gen_Config_API.Get(report_id_);
   IF result_gen_config_.generate_xml IS NULL THEN
      RETURN TRUE;
   ELSIF result_gen_config_.in_use = 'FALSE' THEN
      RETURN TRUE;
   ELSE
      RETURN result_gen_config_.generate_xml = 'TRUE';
   END IF;
END Should_Generate_Xml;


PROCEDURE Finish_Xml_Report (
   report_id_  IN VARCHAR2,
   result_key_ IN NUMBER,
   xml_stream_ IN OUT NOCOPY CLOB )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Finish_Xml_Report');
   Xml_Text_Writer_API.Write_End_Document(xml_stream_);
   Xml_Report_Data_API.Insert_Data(result_key_, report_id_, xml_stream_);
   DBMS_LOB.freetemporary(xml_stream_);
END Finish_Xml_Report;


@UncheckedAccess
-- ## to be considered for CORE Security ##
PROCEDURE Request_Formatting (
   rendered_output_id_ OUT VARCHAR2,
   result_key_         IN NUMBER,
   format_request_     IN VARCHAR2,
   lang_code_          IN VARCHAR2 DEFAULT NULL )
IS
   newformat_   VARCHAR2(2000);
   layout_name_ VARCHAR2(2000);
BEGIN
   IF (format_request_ IS NULL) THEN
      Client_SYS.Clear_Attr(newformat_);
      Client_SYS.Add_To_Attr('USER', Fnd_Session_API.Get_Fnd_User, newformat_);
      newformat_ := replace(newformat_, chr(31), '=');
      newformat_ := replace(newformat_, chr(30), '^');
   ELSE
      newformat_ := format_request_;
      layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', format_request_);
      IF (Client_SYS.Get_Item_Value('USER', format_request_) IS NULL) THEN
         Client_SYS.Add_To_Attr('USER', Fnd_Session_API.Get_Fnd_User, newformat_);
      END IF;
      IF (layout_name_ IS NOT NULL) THEN
         REPORT_LAYOUT_DEFINITION_API.Check_Layout(layout_name_);
      END IF;
      IF (layout_name_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('LAYOUT_NAME', layout_name_, newformat_);
      END IF;
      newformat_ := replace(newformat_, chr(31), '=');
      newformat_ := replace(newformat_, chr(30), '^');
   END IF;
   Request_Formatting_Async(rendered_output_id_, result_key_, newformat_);
EXCEPTION WHEN OTHERS THEN
   RAISE; -- Keeps original exception behavior prior to Bug #61975 patch

END Request_Formatting;

PROCEDURE Request_Formatting_Async (
   rendered_output_id_ OUT VARCHAR2,
   result_key_         IN NUMBER,
   format_request_     IN VARCHAR2 )
IS
   print_job_id_ NUMBER;
BEGIN
   Request_Formatting_Async(print_job_id_, rendered_output_id_, result_key_, format_request_,true);
END Request_Formatting_Async;
   
PROCEDURE Request_Formatting_Async (
   print_job_id_       OUT NUMBER,
   rendered_output_id_ OUT VARCHAR2,
   result_key_         IN NUMBER,
   format_request_     IN VARCHAR2,
   wait_               IN BOOLEAN DEFAULT FALSE)
IS

   attr_               VARCHAR2(2000);
   pdf_info_           VARCHAR2(2000);   
   layout_name_        VARCHAR2(2000);
   lang_code_          VARCHAR2(3);
   locale_lang_        VARCHAR2(3);
   locale_country_     VARCHAR2(3);
   timeout_            NUMBER;
   elapsed_time_       NUMBER;
   start_time_         DATE;
   status_             VARCHAR2(200);
   max_timeout_        NUMBER := 3600*4;
BEGIN

   IF (format_request_ IS NULL) THEN
      layout_name_:= Archive_API.Get_Layout_Name(result_key_);
   ELSE
      layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', format_request_);
      lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', format_request_);
      locale_lang_ := Client_SYS.Get_Item_Value('LOCALE_LANGUAGE', format_request_);
      locale_country_ := Client_SYS.Get_Item_Value('LOCALE_COUNTRY', format_request_);
      
   -- request formatting validation
      IF (layout_name_ IS NOT NULL) THEN
         REPORT_LAYOUT_DEFINITION_API.Check_Layout(layout_name_);
      END IF;

   END IF;
   
   --1.new printjob
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', 'NO_PRINTOUT', attr_);
   pdf_info_ := Message_SYS.Construct('PDF');
   Message_SYS.Add_Attribute(pdf_info_, 'PREVIEW', 'TRUE');
   Message_SYS.Add_Attribute(pdf_info_, 'FLAG_CHECK', 'TRUE');
   Client_SYS.Add_To_Attr('SETTINGS', pdf_info_, attr_);   
   Print_Job_API.New(print_job_id_, attr_);

   --2.new printjob contents
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
   Client_SYS.Add_To_Attr('LAYOUT_NAME', layout_name_, attr_);
   
   IF(lang_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, attr_);
   END IF;
   
   IF(locale_lang_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOCALE_LANGUAGE', locale_lang_, attr_);
   END IF;
   
   IF(locale_country_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOCALE_COUNTRY', locale_country_, attr_);
   END IF;
   Print_Job_Contents_API.New_Instance(attr_);
   
   --3.execute the printjob
   Print_job_api.Print(print_job_id_);
   @ApproveTransactionStatement(2017-12-14,asiwlk)
   COMMIT;
   
   --4.wait for the print job
   start_time_ := SYSDATE;
   elapsed_time_ := 0;
   IF(wait_) THEN
      timeout_ := max_timeout_;
   ELSE 
      BEGIN
         timeout_:= Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('REP_PREV_TIME_LMT'));
         IF(timeout_ IS NULL OR timeout_= 0 )THEN
            timeout_ := 30;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
         timeout_ := 30;
      END;
   END IF;
   status_            := Print_Job_API.Get_Status_Db(print_job_id_);
   WHILE(status_ NOT IN ('ERROR', 'ABORT', 'COMPLETE') AND (elapsed_time_ < timeout_/(24*3600) )) LOOP
     Dbms_Lock.Sleep(1);                     
     status_          := Print_Job_API.Get_Status_Db(print_job_id_);
     elapsed_time_    := SYSDATE - start_time_;
   END LOOP;
   IF (status_ = 'ERROR') THEN
      Error_SYS.Appl_General(lu_name_, 'PRINTJOBERR: Error occured while running the Report. Refer to Print Manager/Print Key :P1', print_job_id_);
   ELSIF (status_ = 'ABORT') THEN
      Error_SYS.Appl_General(lu_name_, 'PRINTJOBABRT: Preview was aborted. Refer to Print Manager/Print Key :P1', print_job_id_);
   END IF;
   rendered_output_id_:= Pdf_Archive_API.Get_Id(result_key_, print_job_id_);   
EXCEPTION WHEN OTHERS THEN
   RAISE;
END Request_Formatting_Async;

PROCEDURE Refresh_Rpv_View (
   rpv_view_   IN VARCHAR2,
   table_name_ IN VARCHAR2 )
IS
   stmt_    VARCHAR2(300);
   comment_ User_Tab_Comments.Comments%TYPE;
   CURSOR get_comment IS
   SELECT comments
     FROM user_tab_comments
    WHERE table_name = rpv_view_;
BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Refresh_Rpv_View');
   -- Fetch and save comment
   OPEN  get_comment;
   FETCH get_comment INTO comment_;
   CLOSE get_comment;
   -- 
   Assert_SYS.Assert_Is_View(rpv_view_);
   Assert_SYS.Assert_Is_Table(table_name_, FALSE);
   --
   stmt_ := 'CREATE OR REPLACE VIEW ' || rpv_view_ ||
            ' AS SELECT * FROM ' || table_name_ || ' t' ||
            ' WHERE EXISTS (SELECT 1 FROM allowed_report a WHERE a.result_key = t.result_key)' ||
            ' WITH read only';
   @ApproveDynamicStatement(2007-04-27,haarse)
   EXECUTE IMMEDIATE stmt_;
   -- Replace comment
   stmt_ := 'COMMENT ON TABLE ' || rpv_view_ ||' IS ''' || comment_ || '''';
   @ApproveDynamicStatement(2007-04-27,haarse)
   EXECUTE IMMEDIATE stmt_; 
END Refresh_Rpv_View;


PROCEDURE Remove_Report_Definition (
   report_id_  IN VARCHAR2 )
IS
   definition_exist_ BOOLEAN := TRUE;
   
   CURSOR  get_report_layout IS
     SELECT layout_name 
    FROM report_layout_tab
    WHERE report_id = report_id_; 

   CURSOR get_layouts IS 
    SELECT layout_name 
     FROM report_sys_layout_tab
    WHERE report_id = report_id_; 
   
   CURSOR get_pres_objs IS
     SELECT po_id
     FROM pres_object_tab
     WHERE po_id = 'rep'||report_id_;
   
   CURSOR get_schedule_rpts IS
     SELECT schedule_id
     FROM batch_schedule_tab
     WHERE external_id = report_id_;

BEGIN
   General_SYS.Check_Security(service_, 'REPORT_SYS', 'Remove_Report_Definition');
   FOR rep_layout_ IN get_report_layout LOOP
      Report_Layout_API.Remove_Layout_(report_id_,rep_layout_.layout_name);
   END LOOP;

   FOR layout_ IN get_layouts LOOP
      Report_Layout_Definition_API.Remove_Layout(report_id_,layout_.layout_name );
   END LOOP;
      
   FOR rec_ IN get_pres_objs LOOP
      pres_object_util_api.Remove_Pres_Object(rec_.po_id);
   END LOOP; 
   
   FOR rec_ IN get_schedule_rpts LOOP
      batch_schedule_api.Remove_(rec_.schedule_id);
   END LOOP;
  
   DELETE FROM report_sys_text_tab 
      WHERE  report_id = report_id_;

   Database_SYS.Remove_Client(Aurena_Report_Metadata_SYS.Get_Projection_Name__(report_id_), TRUE);

   Database_SYS.Remove_Projection(Aurena_Report_Metadata_SYS.Get_Projection_Name__(report_id_), TRUE);

   Report_Definition_API.Check_Definition_Exist(report_id_,definition_exist_);
   IF (definition_exist_) THEN
      Report_Definition_API.Remove_Definition_(report_id_);
   ELSE
      -- Support for scripts that has manually removed part of report data and now using this remove method
      -- Cascade deleting other remaining report data even if the report definition is manually removed
      Reference_SYS.Do_Cascade_Delete('ReportDefinition', report_id_||'^'); 
      dbms_output.put_line('INFO: Could not remove the report definition for report ID '||report_id_||' as it does not exists in the database. Other report data removed.');
   END IF;
   
   Report_Result_Gen_Config_Api.Remove_Result_Gen_Config_(report_id_);
END Remove_Report_Definition;

PROCEDURE Remove_Reports_Per_Module (
   module_ IN VARCHAR2)
IS
   CURSOR get_reports IS
      SELECT report_id
      FROM   report_sys_tab
      WHERE  module = module_;
BEGIN
   FOR rec_ IN get_reports LOOP
      Remove_Report_Definition(rec_.report_id);
   END LOOP;
END Remove_Reports_Per_Module;

PROCEDURE Init_Reports_Metadata (
   component_ IN VARCHAR2 DEFAULT '',
   mode_      IN VARCHAR2 DEFAULT '')
IS
BEGIN
   Aurena_Report_Metadata_SYS.Initialize_Reports__(component_, mode_);
END Init_Reports_Metadata;

PROCEDURE Init_Report_Metadata (
	report_id_ IN VARCHAR2)
IS
BEGIN   

   Aurena_Report_Metadata_SYS.Initialize_Report__(report_id_);
END Init_Report_Metadata;

PROCEDURE Register_Custom_Report (
   report_id_ IN VARCHAR2,
   custom_page_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN

   Aurena_Report_Metadata_SYS.Register_Custom_Report__(report_id_, custom_page_);
END Register_Custom_Report;

PROCEDURE Add_To_Args (
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2,
   args_  IN OUT NOCOPY VARCHAR2 )
IS
   value2_ VARCHAR2(2000) := value_;
BEGIN
   IF (instr(value2_, arg_value_separator_) > 0) THEN
      value2_ := REPLACE(value2_, arg_value_separator_, arg_value_separator_repl_);
   END IF;
   IF (instr(value2_, arg_separator_) > 0) THEN
      value2_ := REPLACE(value2_, arg_separator_, arg_separator_repl_);
   END IF;
   args_ := args_ || name_ || arg_value_separator_ || value2_ || arg_separator_;
END Add_To_Args;

PROCEDURE Add_To_Args (
   name_  IN     VARCHAR2,
   value_ IN     NUMBER,
   args_  IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   Add_To_Args(name_, to_char(value_), args_);
END Add_To_Args;

PROCEDURE Add_To_Args(
   name_      IN     VARCHAR2,
   value_     IN     DATE,
   args_      IN OUT NOCOPY VARCHAR2,
   incl_time_ IN     BOOLEAN DEFAULT FALSE)
IS
BEGIN
   IF (incl_time_) THEN
      Add_To_Args(name_, to_char(value_, datetime_format_), args_);
   ELSE
      Add_To_Args(name_, to_char(value_, date_format_), args_);      
   END IF;
END Add_To_Args;

FUNCTION Arg_Exist (
   name_ IN VARCHAR2,
   args_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (instr(arg_separator_ || args_, arg_separator_ || name_ || arg_value_separator_) > 0);
END Arg_Exist;

FUNCTION Get_Arg_Value (
   name_ IN VARCHAR2,
   args_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   len_   NUMBER;
   from_  NUMBER;
   to_    NUMBER;
   value_ VARCHAR2(2000);
BEGIN
   len_ := length(name_);
   from_ := instr(arg_separator_ || args_, arg_separator_ || name_ || arg_value_separator_);
   IF (from_ > 0) THEN
      to_ := instr(args_, arg_separator_, from_ + 1);
      IF (to_ > 0) THEN
         value_ := substr(args_, from_ + len_ + 1, to_ - from_ - len_ - 1);
         IF (instr(value_, arg_separator_repl_) > 0) THEN
            value_ := REPLACE(value_, arg_separator_repl_, arg_separator_);
         END IF;
         IF (instr(value_, arg_value_separator_repl_) > 0) THEN
            value_ := REPLACE(value_, arg_value_separator_repl_, arg_value_separator_);
         END IF;
         RETURN value_;            
      END IF;
   END IF;
   RETURN (NULL);
END Get_Arg_Value;

FUNCTION Check_Component_Exists (
   component_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   ret_   BOOLEAN;
   stm_   VARCHAR2(100);
BEGIN
   IF ((upper(component_) = 'CRYSTL') OR (upper(component_) = 'SSRSOR') OR (upper(component_) = 'BACLI')) THEN
      stm_ := 'BEGIN :ret_ := Component_'||component_||'_SYS.INSTALLED; END;';
      @ApproveDynamicStatement(2020-10-14,chaalk)
      EXECUTE IMMEDIATE stm_ USING OUT ret_;
      IF (ret_) THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END IF;
   RETURN 'FALSE';
END Check_Component_Exists;

FUNCTION Report_Format_Request(
   result_key_        IN NUMBER,
   layout_name_       IN VARCHAR2,
   language_code_     IN VARCHAR2,
   number_formatting_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rendered_output_id_   VARCHAR2(1000);
   print_job_id_         NUMBER;
   format_request_       VARCHAR2(2000);
   lang_code_            VARCHAR2(3);
   country_code_         VARCHAR2(3);
BEGIN
   Client_SYS.Clear_Attr(format_request_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, format_request_);   
   Client_SYS.Add_To_Attr('LAYOUT_NAME', layout_name_, format_request_);
   Client_SYS.Add_To_Attr('LANG_CODE', language_code_, format_request_);
   IF number_formatting_ IS NOT NULL THEN         
         lang_code_ := SUBSTR(number_formatting_,1,2);
         country_code_ := SUBSTR(number_formatting_,4,2);
         Client_SYS.Add_To_Attr('LOCALE_LANGUAGE',lang_code_, format_request_);
         Client_SYS.Add_To_Attr('LOCALE_COUNTRY',country_code_ , format_request_);        
   END IF;
   Report_SYS.Request_Formatting_Async(print_job_id_, rendered_output_id_, result_key_, format_request_);
   RETURN rendered_output_id_;
END Report_Format_Request;