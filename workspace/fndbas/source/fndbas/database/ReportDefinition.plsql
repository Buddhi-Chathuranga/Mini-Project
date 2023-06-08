-----------------------------------------------------------------------------
--
--  Logical unit: ReportDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960412  MANY  Created
--  960420  MANY  Added method Acknowledge_Report_() and fixed bug in
--                Enumerate_Available_ReportS().
--  960526  MANY  Fixed bug concerning the order of report columns (bug in Oracle)
--                when selecting from system view user_col_comments.
--  960626  MANY  Added methods Enumerate_Report_Layout() and
--                Enumerate_Report_Printer().
--  960626  MANY  Added methods Get_Report_Title() and Get_Layout_Title().
--  960801  MANY  Fixed bug in Get_Print_Info_Detail(), concerning the number of
--                sent texts.
--  960810  MANY  Changed column datatype info sent to client when printing/previewing
--                to the actual datatype as defined by user_tab_columns.
--                Added item-control for ReportWindows input items. Now possible
--                to specify name (allows for non-orderby dependencies between
--                input-items)
--  960905  MANY  Changes in Get_Query_Properties_() for IID-references,
--                enumerate-methods, dynamic default value, and to transfer
--                less data back over the net.
--                Splitted package into two, due to size problem.
--  960909  MANY  Fixed column queries in Format_Query_Lists() (bug#788).
--  961008  MANY  Changes in Get_Query_Properties() to support more than 16
--                queries.
--  961011  MANY  Added method Get_Class_Info(), collecting class dependent
--                information for a report.
--  961017  MANY  Added method Get_Report_Translations().
--  961028  MANY  Added new column property STATUS, status line in 'Report Order Dialog'.
--  961211  ERFO  Changes in method Set_Report_Order_Cache to read several
--                package and view lists from Security_SYS.
--  970325  MANY  Modified usage of Dictionary_SYS.Comment_Value_, move code into
--                current package to possibly solve Oracle 7.3 problems.
--  970409  MANY  Modified Enumerate_Available_Reports and Count_Available_Reports to
--                make a full scan when user is application owner, for developing.
--  970414  MANY  Included modification to view's, concerning workaround to bug
--                in Oracle 7.3
--  970806  MANY  Chenges concerning new user concept FndUser
--  970815  MANY  RRose model upgrade, added new public methodsaccordingly. Added method
--                Set_Life(), added functionality for cache on reports.
--  970824  MANY  Added security, only app_owner will get hits.
--  980218  MANY  Fixed bug #2130 in method Get_Navigator_Items(), function calls
--                with NULL parameters not allowed in SQL statements.
--  980325  MANY  Chenges for the forthcoming integration between IFS/Info Services
--                and IFS/ReportGenerator
--  980527  MANY  Added column comments (ToDo #2453).
--  980827  ERFO  Changed cursor in method Get_Ref_Properties___ not to include
--                any Dictionary_SYS-functions (ToDo #2655).
--  980827  MANY  Chencge Get_Ref_Properties___ to better utilize Dictionary cache.
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  981210  ERFO  Reinstalled old code in Get_Ref__Properties___ (Bug #3006).
--  990222  ERFO  Yoshimura: Changes in methods Get_Ref_Properties___ and
--                and Get_Navigator_Items (ToDo #3160).
--  990304  MANY  Fixed order by in Report Combo, now orders by report title only (Bug #3203)
--  990315  ERFO  Changed to order by translated report title (Bug #3203).
--  990323  DOZE  Upgraded to new templates
--  990525  ERFO  Changes in method Enumerate_Report_Layout for Project Orion (ToDo #3375).
--  990806  ERFO  Performance improvements for report LOV-properties.
--                Changes made in Get_Query_Properties_ (ToDo #3462).
--  991123  ERFO  Solved problem regarding report order from web (Bug #3720).
--  010524  ROOD  Rewrote Set_Report_Order_Cache to take into consideration
--                information about all available views (Bug#21983).
--  020528  ROOD  Increased length of attributes texts and layouts (Bug#30434).
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021007  ROOD  Added attributes master and override_method.
--                Rearrangements in attribute order (GLOB12).
--  021009  ROOD  Modifications to remove the need for the saved comment
--                in the report definition. Removed package Report_Definition2_API
--                and unused interface Get_Print_Info_Detail and Get_Print_Info (GLOB12).
--  021009  ROOD  Changes in Set_Report_Order_Cache___ and Enumerate_Available_Reports
--                to not enumerating alternative reports (GLOB12).
--  021009  ROOD  Added validations for master and override_method (GLOB12).
--  021021  ROOD  Added check for pres object in Set_Report_Order_Cache___ (GLOB12).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030219  ROOD  Removed subcomponent name in translatable constants (ToDo#4149).
--  030221  ROOD  Modified a translateble constant that was not found by Localize.
--  030813  HAAR  Changed VARCHAR declarations to VARCHAR2 (ToDo#4278).
--  031008  ROOD  Corrected method Get_Layout_Title (Bug#39279).
--  040113  BAMALK Increased length of Report_Title variable to 100 in Enumerate_Available_Reports and
--                 Get_Translated_Report_Title. (Bug#41845>
--  040213  ROOD   Removed unused method Get_Notes__ (Bug#39376).
--  040223  ROOD   Replaced oracle_role with role everywhere (ToDo#????).
--  040407  HAAR   Unicode bulk changes,
--                 extended 1 define variables length in Enumerate_Available_Reports (F1PR408B).
--  040628  HAAR   Added Report_Definition__ (F1PR419B).
--  040819  HAAR   Changed Get_Query_Properties_, to work compatible with the new router, by addind exception.
--  040823  HAAR   Changed Enumerate_Available_Reports (F1PR419B).
--  040929  BAMALK Corrected user_where_ in Enumerate_Available_Reports. <Bug#46264)
--  041222  JORA   Replaced usage of fullmethod in security_sys_tab with package_name and method_name.
--                 Made some corrections regarding case in search criterias too (Merge Bug#48113).
--  050214  BAMALK Modified report_title column in Report_definition view to show translated report titles(Bug#47455).
--  050408  JORASE Added assertion for dynamic SQL.  (F1PR481)
--  050628  DOZE   Added Enumerate_All_Reports (Bug#49888)
--  060105  UTGULK Annotated Sql injection.
--  060905  RONALK Bug59956-Reports which has a MASTER set don't show in IFS Developer studio
--  060905  UTGULK Modified Count_Available_Reports(),Enumerate_Available_Reports___(),Set_Report_Order_Cache___(),
--                 Is_Report_Available_() to include new report type 'EXCEL1.0'(Bug #59182).
--  060922  ASWILK Modified Enumerate_Available_Reports___ to exclude slave reports for all users (Bug#60690).
--  060927  UTGULK Added method Remove_Definition_ to be used by EXCEL reports.(Bug #60820).
--  070910  UTGULK Extended variable length of translated_text_ in Get_Report_Translations (Bug #67542). 
--  071106  SUMALK Dangling cursor at Count_Available_Reports(Bug #66848).
--  090911  CHAALK Remove the null checks in methods Unpack_Check_Insert___ and Unpack_Check_Update___ for fields METHOD,LAYOUTS,TEXTS and PROMPT (Bug #85643)
--  090925  CHAALK Added a null check in method Unpack_Check_Update___ to check if method is null before doing the method exists check (Bug #85643)
--  091001  HAAR   Changed method Is_Reprot_Available_ to check PO (Bug#86131).
--  101116  LAKRLK Count hits in search of list reports gives error message (Bug#92583)
--  030111  LAKRLK Problems in the view Introduced in bug 92583 (Bug#94898).
--  120215  LAKRLK RDTERUNTIME-1846
--  120904  ASIWLK Custom Field control (TEREPORT-75)
--  130724  NaBaLK Highlighted the places where reconsideration needed for SQL assert (Bug#111361)
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227)
--  131001  CHAALK New method to filer reports according to the report mode (Bug 112226
--  140123  ASIWLK Merged LCS-109673
--  140129  AsiWLK Merged LCS-111925
--  140523  ASIWLK Merged LCS-114359
--  141127  TAORSE   Added Enumerate_All_Reports_Id_Db
--  151116  CHAALK Ability to hide Operational Reports (Bug ID 125636)
--  151119  ASIWLK Translations in Custom fields are not printed on reports
--  160223  CHAALK Bug fix 127452 not added as it will be fixed from the below fix
--  160223  CHAALK Incorrect translation of report title in reports NEW FIX (Bug ID 128271 )
--  160223  MABALK Report Archive entries for reports that have become obsolete show without a report title (Bug ID 143606 )
--  191002  PABNLK  TSMI-6: 'Report_Definition_Modify' wrapper method created.
--  210120  MABALK Report with lots of added XML fields cannot be printed (Bug #157641)
--  210201  NALTLK  Change of "Enabled on Reports" for Custom Fields is activated without Synchronizing (Bug ID 157689)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE REP_ARRAY_TYPE IS TABLE OF VARCHAR2(600) INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_  CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;

group_separator_  CONSTANT VARCHAR2(1) := Client_SYS.group_separator_;

record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;

CURSOR get_report_columns(report_id_ IN VARCHAR2) IS
   SELECT *
   FROM   report_column_definition
   WHERE  report_id = report_id_
   ORDER BY column_id;

CURSOR get_report_texts(report_id_ IN VARCHAR2) IS
   SELECT *
   FROM report_sys_text_tab
   WHERE report_id = report_id_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_To_Comments___ (
   column_name_    IN     VARCHAR2,
   column_value_   IN     VARCHAR2,
   comment_string_ IN OUT VARCHAR2 )
IS
BEGIN
   IF (column_value_ IS NOT NULL) THEN
      comment_string_ := comment_string_ || upper(column_name_) || '=' || column_value_ || '^';
   END IF;
END Add_To_Comments___;


FUNCTION Get_Column_Datatype___ (
   report_id_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   datatype_ VARCHAR2(100);
BEGIN
   SELECT column_type INTO datatype_
      FROM  report_column_definition
      WHERE report_id = report_id_
      AND   column_name = column_name_;
   RETURN (Transform_Datatype___(datatype_));
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'REPCOLNOTEXIST: Reportcolumn [:P1, :P2] does not exist', report_id_, column_name_);
END Get_Column_Datatype___;


FUNCTION Get_Dynamic_Value___ (
   procedure_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_  VARCHAR2(2000);
   value_ VARCHAR2(32000);
BEGIN
   Assert_SYS.Assert_Is_Procedure(procedure_);
   stmt_ := 'BEGIN '||procedure_||'(:value_); END;';
   @ApproveDynamicStatement(2013-11-13,mabose)
   EXECUTE IMMEDIATE stmt_ USING OUT value_;
   RETURN (SUBSTR(value_, 1, 500));
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Dynamic_Value___;


FUNCTION Transform_Datatype___ (
   datatype_       IN  VARCHAR2 ) RETURN VARCHAR2
IS
   from_ NUMBER;
   to_   NUMBER;
   len_  NUMBER;
BEGIN
   IF (datatype_ LIKE 'NUMBER%') THEN
      RETURN ('NUMBER');
   ELSIF (datatype_ LIKE 'DATE%') THEN
      RETURN ('DATE');
   ELSIF (datatype_ LIKE 'STRING%') THEN
      from_ := instr(datatype_, '(');
      to_ := instr(datatype_, ')');
      IF (to_ > from_) THEN
         len_ := to_number(SUBSTR(datatype_, from_ + 1, to_ - from_ - 1));
         IF (len_ > 253) THEN
            RETURN ('LONGVARCHAR2');
         ELSE
            RETURN ('VARCHAR2');
         END IF;
      ELSE
         RETURN ('VARCHAR2');
      END IF;
   ELSE
      RETURN ('VARCHAR2');
   END IF;
END Transform_Datatype___;


FUNCTION Transform_Item___ (
   column_name_    IN  VARCHAR2,
   column_seq_     IN  NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN ('i'||replace(nls_initcap(replace(column_name_, '_', ' ')),' ')||to_char(column_seq_));
END Transform_Item___;


FUNCTION Transform_Title___ (
   column_name_    IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (nls_initcap(replace(column_name_, '_', ' ')));
END Transform_Title___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('LIFE', 0, attr_);
END Prepare_Insert___;


PROCEDURE Enumerate_Available_Reports___ (
   report_id_         OUT Rep_Array_Type,
   report_title_      OUT Rep_Array_Type,
   module_            OUT Rep_Array_Type,
   user_where_        IN  VARCHAR2,
   list_all_          IN BOOLEAN DEFAULT FALSE)
IS
   cursor_stmt_     VARCHAR2(32730);
   var_user_where_  VARCHAR2(32000);
BEGIN
   IF user_where_ IS NOT NULL THEN
     IF Instr(user_where_,'REPORT_TITLE') > 0 THEN
        var_user_where_ := replace (user_where_,'REPORT_TITLE',' Language_Sys.Translate_Report_Title_(lu_name,report_id,report_title,Fnd_Session_API.Get_Language) ');
     ELSE
        var_user_where_ := user_where_ ;
     END IF;
   END IF;

   cursor_stmt_ := 'SELECT report_id, report_title, module'||
                   ' FROM report_definition '||
                   ' WHERE report_mode IN (''PLSQL1.1'',''PLSQL1.2'',''DYN1.2'',''FINREP'',''EXCEL1.0'')';
   IF NOT list_all_ THEN      
      cursor_stmt_ := cursor_stmt_||' AND master IS NULL';
	   IF (Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
         -- For appowner (Centura or Web)
         cursor_stmt_ := cursor_stmt_;
      ELSE
         -- For end-user without own physical session (Web)
         cursor_stmt_ := cursor_stmt_ ||
                      ' AND Report_Definition_API.Is_Report_Available_(report_id) > 0';
      END IF;
   END IF;   
   IF (user_where_ IS NOT NULL) THEN
      cursor_stmt_ := cursor_stmt_ || ' AND ' || var_user_where_;
   END IF;
   cursor_stmt_ := cursor_stmt_ || ' ORDER BY report_title';
   -- ## to be considered for CORE SQL Assert ##
   @ApproveDynamicStatement(2014-10-06,mabose)
   EXECUTE IMMEDIATE cursor_stmt_ BULK COLLECT INTO report_id_, report_title_, module_;
END Enumerate_Available_Reports___;

PROCEDURE Enumerate_Available_Rep_Id___ (
   report_id_         OUT Rep_Array_Type,
   report_title_      OUT Rep_Array_Type,
   module_            OUT Rep_Array_Type,
   user_where_        IN  VARCHAR2,
   list_all_          IN BOOLEAN DEFAULT FALSE)
IS
   cursor_stmt_     VARCHAR2(32730);
   var_user_where_  VARCHAR2(32000);
BEGIN
   IF user_where_ IS NOT NULL THEN
     IF INSTR(user_where_,'REPORT_TITLE') > 0 THEN
        var_user_where_ := replace (user_where_,'REPORT_TITLE',' Language_Sys.Translate_Report_Title_(lu_name,report_id,report_title,Fnd_Session_API.Get_Language) ');
     ELSE
        var_user_where_ := user_where_ ;
     END IF;
   END IF;

   cursor_stmt_ := 'SELECT report_id, Language_SYS.Translate_Report_Title_(lu_name, report_id, report_title) report_title, module'||
                   ' FROM report_definition '||
                   ' WHERE report_mode IN (''PLSQL1.1'',''PLSQL1.2'',''DYN1.2'',''FINREP'',''EXCEL1.0'')';
   IF NOT list_all_ THEN		
      cursor_stmt_ := cursor_stmt_||' AND master IS NULL';
         IF (Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
            cursor_stmt_ := cursor_stmt_;
         ELSE
            cursor_stmt_ := cursor_stmt_ ||
                      ' AND Report_Definition_API.Is_Report_Available_(report_id) > 0';
         END IF;
   END IF;	
   IF (user_where_ IS NOT NULL) THEN
      cursor_stmt_ := cursor_stmt_ || ' AND ' || var_user_where_;
   END IF;
   cursor_stmt_ := cursor_stmt_ || ' ORDER BY report_id';
   -- ## to be considered for CORE SQL Assert ##
   @ApproveDynamicStatement(2014-10-06,mabose)
   EXECUTE IMMEDIATE cursor_stmt_ BULK COLLECT INTO report_id_, report_title_, module_;
END Enumerate_Available_Rep_Id___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT report_sys_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   -- Validate that the report method exist
   Report_SYS.Method_Exist(newrec_.method);
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     report_sys_tab%ROWTYPE,
   newrec_ IN OUT report_sys_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Validate that the report method exist
   IF newrec_.method IS NOT NULL THEN
      Report_SYS.Method_Exist(newrec_.method);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     report_sys_tab%ROWTYPE,
   newrec_ IN OUT report_sys_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Validate that not both master and override_method has been stated, that would be a logical error!
   IF newrec_.master IS NOT NULL AND newrec_.override_method IS NOT NULL THEN
      Error_SYS.Appl_General(lu_name_, 'ILLEGAL_COMB_I: The report :P1 can only have either a master or an override method, not both!', newrec_.report_id);
   END IF;

   -- Validate that the master report exist (is already defined)
   IF newrec_.master IS NOT NULL THEN
      Exist(newrec_.master);
   END IF;

   -- Validate that the override method exist
   IF newrec_.override_method IS NOT NULL THEN
      Report_SYS.Method_Exist(newrec_.override_method);
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
FUNCTION Get__ (
   report_id_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (report_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT report_id, rowid, rowversion, rowkey,
          module, 
          lu_name, 
          method, 
          master, 
          override_method, 
          report_mode, 
          show_in_order_reports, 
          domain_id, 
          category_id
      INTO  temp_
      FROM  report_sys_tab
      WHERE report_id = report_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(report_id_, 'Get__');
END Get__;

@UncheckedAccess
FUNCTION Report_Definition__ RETURN Report_Definition_Reports_Type
IS
   report_id_        Rep_Array_Type;
   report_title_     Rep_Array_Type;
   module_           Rep_Array_Type;
   user_where_       VARCHAR2(1) := NULL;
   report_           Report_Definition_Report_Type; --  := Report_Definition_Report_Type();
   reports_          Report_Definition_Reports_Type := Report_Definition_Reports_Type();
BEGIN
   -- Can not have Security on this function since it is used in a view definition,
   -- PRAGMA did not work either. HAARSE
   Enumerate_Available_Reports___(report_id_, report_title_, module_, user_where_);
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, 0) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         report_ := Report_Definition_Report_Type(report_id_(i),report_title_(i), module_(i));
         reports_.EXTEND;
         reports_(i) := report_;
      END IF;
   END LOOP;
   RETURN reports_;
END Report_Definition__;


@UncheckedAccess
-- ## to be considered for CORE Security ##
FUNCTION Report_Definition_User__ (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
      -- For appowner (Centura or Web)
      RETURN 1;
   ELSE 
      -- For end-user without own physical session (Web)
      IF Report_Definition_API.Is_Report_Available_(report_id_) > 0 THEN
         RETURN 1;
      END IF;            
   END IF;
   RETURN 0;
END Report_Definition_User__;

@UncheckedAccess
PROCEDURE Check_Report_Def_User__ (
   report_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Report_Definition_User__(report_id_) > 0) THEN
      Error_SYS.Appl_General(lu_name_, 'REPSEC: User :P1 is not granted access to the Report :P2', Fnd_Session_API.Get_Fnd_User, report_id_);
   END IF;
END Check_Report_Def_User__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Get_Query_Properties_ (
   query_properties_ OUT VARCHAR2,
   report_id_        IN  VARCHAR2 )
IS
   logical_unit_     VARCHAR2(30);
   query_comments_   VARCHAR2(2000);
   query_attr_       VARCHAR2(32000);
   query_            VARCHAR2(500);
   status_           VARCHAR2(500);
BEGIN
   SELECT lu_name INTO logical_unit_
      FROM  report_definition
      WHERE report_id = report_id_;
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (column_.column_query IS NOT NULL) THEN
         query_comments_ := NULL;
         Add_To_Comments___('COLUMN_NAME', column_.column_name, query_comments_);
         query_ := Language_SYS.Translate_Report_Question_(logical_unit_, report_id_, column_.column_name, column_.column_query);
         Add_To_Comments___('QUERY', NVL(query_,column_.column_query), query_comments_);
         Add_To_Comments___('QFLAGS', NVL(column_.column_qflags, '-CS--'), query_comments_);
         Add_To_Comments___('DATATYPE', NVL(column_.column_dataformat, 'STRING(50)'), query_comments_);
         status_ := Language_SYS.Translate_Report_Col_Status_(logical_unit_, report_id_, column_.column_name, column_.status);
         Add_To_Comments___('STATUS', SUBSTR(status_,1,200), query_comments_);
         IF (SUBSTR(column_.column_value,1,1)=':') THEN
            Add_To_Comments___('QVALUE', Get_Dynamic_Value___(SUBSTR(column_.column_value,2)), query_comments_);
         ELSE
            Add_To_Comments___('QVALUE', column_.column_value, query_comments_);
         END IF;
         IF (column_.column_lov IS NOT NULL) THEN
            Add_To_Comments___('REF', column_.lov_view, query_comments_);
            Add_To_Comments___('ENUMERATE', column_.lov_enum, query_comments_);
         ELSE
            Add_To_Comments___('ENUMERATE', column_.enumerate_method, query_comments_);
         END IF;
         Add_To_Comments___('VALIDATE', column_.validate_method, query_comments_);
         query_attr_ := query_attr_ || query_comments_ || group_separator_;
      END IF;
   END LOOP;
   query_properties_ := query_attr_;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Get_Query_Properties_;


@UncheckedAccess
FUNCTION Is_Report_Available_ (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   --
   -- Check report PresObject
   --
   IF Security_SYS.Is_Projection_Available_(Aurena_Report_Metadata_SYS.Get_Projection_Name__(report_id_)) ='TRUE' THEN
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END Is_Report_Available_;


PROCEDURE Remove_Definition_ (
   report_id_  IN VARCHAR2 )
IS
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   remrec_ REPORT_SYS_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,report_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Definition_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Report_Title (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ REPORT_SYS_TAB.report_title%TYPE;
   CURSOR get_attr IS
      SELECT SUBSTR(language_sys.translate_report_title_(lu_name, report_id,report_title,Language_Sys.Get_Language),1,50)
      FROM   REPORT_SYS_TAB
      WHERE  report_id = report_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Report_Title;

PROCEDURE Get_Report_Title (
   report_title_ OUT VARCHAR2,
   report_id_    IN  VARCHAR2 )
IS
BEGIN
   Exist(report_id_);
   report_title_ := Get_Translated_Report_Title(report_id_);
END Get_Report_Title;

@UncheckedAccess
FUNCTION Get_Prog_Report_Title (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ REPORT_SYS_TAB.report_title%TYPE;
   CURSOR get_attr IS
      SELECT report_title
      FROM   REPORT_SYS_TAB
      WHERE  report_id = report_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prog_Report_Title;

@UncheckedAccess
FUNCTION Get_Life (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Report_User_Settings_API.Get_Life_Recursive(Fnd_Session_API.Get_Fnd_User, report_id_);
END Get_Life;


@UncheckedAccess
FUNCTION Get_Life_Default (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ REPORT_SYS_TAB.life%TYPE;
   CURSOR get_attr IS
      SELECT life
      FROM REPORT_SYS_TAB
      WHERE report_id = report_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Life_Default;


PROCEDURE Set_Life (
   report_id_ IN VARCHAR2,
   life_ IN NUMBER )
IS
BEGIN
   Report_User_Settings_API.Set_Life(Fnd_Session_API.Get_Fnd_User, report_id_, life_);
END Set_Life;


PROCEDURE Enumerate_Available_Reports (
   report_title_list_ OUT VARCHAR2,
   report_id_list_    OUT VARCHAR2,
   user_where_        IN  VARCHAR2 )
IS
   title_list_       VARCHAR2(32730);
   id_list_          VARCHAR2(32730);
   report_id_        Rep_Array_Type;
   module_           Rep_Array_Type;
   report_title_     Rep_Array_Type;
BEGIN
   Enumerate_Available_Reports___(report_id_, report_title_, module_, user_where_);
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         title_list_ := title_list_ || report_title_(i) || field_separator_;
         id_list_    := id_list_ || report_id_(i) || field_separator_;
      END IF;
   END LOOP;
   report_title_list_ := title_list_;
   report_id_list_    := id_list_;
END Enumerate_Available_Reports;


PROCEDURE Enumerate_Available_Reports_Ex (
   report_title_list_ OUT VARCHAR2,
   report_id_list_    OUT VARCHAR2,
   report_mode_       OUT VARCHAR2,
   user_where_        IN  VARCHAR2 )
IS
   title_list_      VARCHAR2(32730);
   id_list_         VARCHAR2(32730);
   mode_list_       VARCHAR2(32730);
   report_id_       Rep_Array_Type;
   module_          Rep_Array_Type;
   report_title_    Rep_Array_Type;
   report_mode2_     Rep_Array_Type;
   cursor_stmt_     VARCHAR2(32730);
   var_user_where_  VARCHAR2(32000);
BEGIN
   -- Do not do this for clients without physical session
   IF user_where_ IS NOT NULL THEN
     IF Instr(user_where_,'REPORT_TITLE') > 0 THEN
        var_user_where_ := replace (user_where_,'REPORT_TITLE',' Language_Sys.Translate_Report_Title_(lu_name,report_id,report_title,Fnd_Session_API.Get_Language) ');
     ELSE
        var_user_where_ := user_where_ ;
     END IF;
   END IF;

   cursor_stmt_ := 'SELECT report_id, Language_SYS.Translate_Report_Title_(lu_name, report_id, report_title) report_title, report_mode, module'||
                   ' FROM report_definition '||
                   ' WHERE report_mode IN (''PLSQL1.1'',''PLSQL1.2'',''DYN1.2'',''FINREP'',''EXCEL1.0'') AND UPPER(show_in_order_reports) = ''TRUE'' AND master IS NULL';
      
   IF (Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
      -- For appowner (Centura or Web)
      cursor_stmt_ := cursor_stmt_;
   ELSE
       -- For end-user without own physical session (Web)
        cursor_stmt_ := cursor_stmt_ ||
      ' AND Report_Definition_API.Is_Report_Available_(report_id) > 0';
   END IF;

   
   IF (user_where_ IS NOT NULL) THEN
      cursor_stmt_ := cursor_stmt_ || ' AND ' || var_user_where_;
   END IF;
   cursor_stmt_ := cursor_stmt_ || ' ORDER BY report_title';
   -- ## to be considered for CORE SQL Assert ##
   @ApproveDynamicStatement(2014-10-06,mabose)
   EXECUTE IMMEDIATE cursor_stmt_ BULK COLLECT INTO report_id_, report_title_, report_mode2_, module_;

   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         title_list_ := title_list_ || report_title_(i) || field_separator_;
         id_list_    := id_list_ || report_id_(i) || field_separator_;
         mode_list_  := mode_list_ || report_mode2_(i) || field_separator_;

      END IF;
   END LOOP;

   report_title_list_ := title_list_;
   report_id_list_    := id_list_;
   report_mode_       := mode_list_;
END Enumerate_Available_Reports_Ex;


FUNCTION Get_Available_Reports RETURN CLOB 
IS
   report_id_        Rep_Array_Type;
   module_           Rep_Array_Type;
   report_title_     Rep_Array_Type;
   msg_              CLOB;
BEGIN
   Enumerate_Available_Reports___(report_id_, report_title_, module_, NULL);
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         msg_ := msg_ || (report_id_(i)||',');
      END IF;
   END LOOP;
   RETURN(msg_);
END Get_Available_Reports;


PROCEDURE Enumerate_All_Reports (
   report_title_list_ OUT VARCHAR2,
   report_id_list_    OUT VARCHAR2,
   user_where_        IN  VARCHAR2 )
IS
   title_list_      VARCHAR2(32730);
   id_list_         VARCHAR2(32730);
   report_id_       Rep_Array_Type;
   module_          Rep_Array_Type;
   report_title_    Rep_Array_Type;
BEGIN
   Enumerate_Available_Reports___(report_id_, report_title_, module_, user_where_, TRUE);
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         title_list_ := title_list_ || report_title_(i) || field_separator_;
         id_list_    := id_list_ || report_id_(i) || field_separator_;
      END IF;
   END LOOP;
   report_title_list_ := title_list_;
   report_id_list_    := id_list_;
END Enumerate_All_Reports;

PROCEDURE Enumerate_All_Reports_Id (
   report_id_list_    OUT VARCHAR2 )
IS
   id_list_         VARCHAR2(32730);
   report_id_        Rep_Array_Type;
   module_           Rep_Array_Type;
   report_title_     Rep_Array_Type;
BEGIN
   Enumerate_Available_Rep_Id___(report_id_, report_title_, module_, NULL, TRUE);      
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         id_list_    := id_list_ || report_id_(i) || field_separator_;
      END IF;
   END LOOP;
   report_id_list_    := id_list_;
END Enumerate_All_Reports_Id;

PROCEDURE Enumerate_All_Reports_Id_Db (
   report_id_list_ OUT VARCHAR2)
IS
   id_list_         VARCHAR2(32730);
   report_id_        Rep_Array_Type;
   module_           Rep_Array_Type;
   report_title_     Rep_Array_Type;
BEGIN
   Enumerate_Available_Rep_Id___(report_id_, report_title_, module_, NULL, TRUE);      
   FOR i IN NVL(report_id_.first, 0)..NVL(report_id_.last, -1) LOOP
      IF (report_title_(i) IS NOT NULL) THEN
         id_list_    := id_list_ || report_id_(i) || field_separator_;
      END IF;
   END LOOP;
   report_id_list_    := id_list_;   
END Enumerate_All_Reports_Id_Db;

PROCEDURE Enumerate_Report_Layout (
   layout_properties_ OUT VARCHAR2,
   report_id_         IN  VARCHAR2 )
IS
BEGIN
   Report_Layout_Definition_API.Enumerate_Layout(layout_properties_, report_id_);
END Enumerate_Report_Layout;


@UncheckedAccess
PROCEDURE Format_Query_Lists (
   parameter_query_list_ OUT VARCHAR2,
   parameter_value_list_ OUT VARCHAR2,
   parameter_attr_       IN  VARCHAR2,
   report_id_            IN  VARCHAR2,
   lang_code_            IN  VARCHAR2 DEFAULT NULL )
IS
   parameter_values_ VARCHAR2(2000);
   parameter_querys_ VARCHAR2(2000);
   logical_unit_     VARCHAR2(30);
   query_            VARCHAR2(50);
BEGIN
   SELECT lu_name INTO logical_unit_
      FROM  report_definition
      WHERE report_id = report_id_;
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (column_.column_query IS NOT NULL) THEN
         query_ := Language_SYS.Translate_Report_Question_(logical_unit_, report_id_, column_.column_name, column_.column_query);
         parameter_querys_ := parameter_querys_ || replace(query_, ',' , ';') || field_separator_;
         parameter_values_ := parameter_values_ ||
         NVL(Client_SYS.Get_Item_Value(column_.column_name, parameter_attr_),
         Language_SYS.Translate_Constant(lu_name_, 'NONE: <None>', lang_code_));
         parameter_values_ := parameter_values_ || field_separator_;
      END IF;
   END LOOP;
   parameter_query_list_ := parameter_querys_;
   parameter_value_list_ := parameter_values_;
END Format_Query_Lists;


@UncheckedAccess
PROCEDURE Get_Base_Label_Attr (
   label_attr_ OUT VARCHAR2,
   lang_code_  IN  VARCHAR2 DEFAULT NULL )
IS
   labels_       VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('EXEC_TIME', Language_SYS.Translate_Constant(lu_name_, 'EXEC_TIME: Execution Time:', lang_code_),labels_); -- 0
   Client_SYS.Add_To_Attr('FROM_USER', Language_SYS.Translate_Constant(lu_name_, 'FROM_USER: Ordered by:', lang_code_),labels_); -- 1
   Client_SYS.Add_To_Attr('JOB_ID', Language_SYS.Translate_Constant(lu_name_, 'JOB_ID: Job Id:', lang_code_),labels_); -- 2
   Client_SYS.Add_To_Attr('JOB_NAME', Language_SYS.Translate_Constant(lu_name_, 'JOB_NAME: Comment:', lang_code_),labels_); -- 3
   Client_SYS.Add_To_Attr('ORDER_TIME', Language_SYS.Translate_Constant(lu_name_, 'ORDER_TIME: Order Time:', lang_code_),labels_); -- 4
   Client_SYS.Add_To_Attr('TITLE', Language_SYS.Translate_Constant(lu_name_, 'TITLE: Report:', lang_code_),labels_); -- 5
   Client_SYS.Add_To_Attr('USER', Language_SYS.Translate_Constant(lu_name_, 'USER: Printed by:', lang_code_),labels_); -- 6
   Client_SYS.Add_To_Attr('CURR_TIME', Language_SYS.Translate_Constant(lu_name_, 'CURR_TIME: Current Time:', lang_code_),labels_); -- 7
   Client_SYS.Add_To_Attr('CURR_DATE', Language_SYS.Translate_Constant(lu_name_, 'CURR_DATE: Current Date:', lang_code_),labels_); -- 8
   Client_SYS.Add_To_Attr('PAGE', Language_SYS.Translate_Constant(lu_name_, 'PAGE: Page', lang_code_),labels_); -- 9
   Client_SYS.Add_To_Attr('REP_END', Language_SYS.Translate_Constant(lu_name_, 'REP_END: End of Report:', lang_code_),labels_); -- 10
   Client_SYS.Add_To_Attr('REP_PARM', Language_SYS.Translate_Constant(lu_name_, 'REP_PARM: Report Conditions:', lang_code_),labels_); -- 11
   Client_SYS.Add_To_Attr('APP_TXT', Language_SYS.Translate_Constant(lu_name_, 'APP_TXT: IFS Cloud', lang_code_),labels_); -- 12
   Client_SYS.Add_To_Attr('CREATED', Language_SYS.Translate_Constant(lu_name_, 'CREATED: Created:', lang_code_),labels_); -- 13
   Client_SYS.Add_To_Attr('NONE', Language_SYS.Translate_Constant(lu_name_, 'NONE: <None>', lang_code_),labels_); -- 14
   Client_SYS.Add_To_Attr('NOTES', Language_SYS.Translate_Constant(lu_name_, 'NOTES: Notes', lang_code_),labels_); -- 15
   Client_SYS.Add_To_Attr('NO_DATA_FOUND', Language_SYS.Translate_Constant(lu_name_, 'NO_DATA_FOUND: No data found', lang_code_),labels_); -- 16
   label_attr_ := labels_;
END Get_Base_Label_Attr;


PROCEDURE Get_Class_Info (
   report_attr_       OUT VARCHAR2,
   column_properties_ OUT CLOB,
   text_properties_   OUT VARCHAR2,
   layout_properties_ OUT VARCHAR2,
   lang_properties_   OUT VARCHAR2,
   report_id_         IN  VARCHAR2 )
IS
   rep_attr_          VARCHAR2(32000);
   col_prop_          CLOB;
   col_count_         NUMBER;
   rep_txt_           VARCHAR2(32000);
   rep_rec_           REPORT_SYS_TAB%ROWTYPE;
BEGIN
   Exist(report_id_);
   rep_rec_ := Get_Object_By_Keys___(report_id_);
   Client_SYS.Add_To_Attr('MODULE', rep_rec_.module, rep_attr_);
   Client_SYS.Add_To_Attr('LU', rep_rec_.lu_name, rep_attr_);
   Client_SYS.Add_To_Attr('TITLE', rep_rec_.report_title, rep_attr_);
   Client_SYS.Add_To_Attr('REPORT_MODE', rep_rec_.report_mode, rep_attr_);
   col_count_ := 0;
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (NVL(column_.item_name, column_.column_title) IS NOT NULL) THEN
         col_prop_ := col_prop_ || column_.column_name || field_separator_ ||
                                   NVL(column_.item_name, Transform_Item___(column_.column_name, col_count_)) || field_separator_ ||
                                   Get_Column_Datatype___(report_id_, column_.column_name) || field_separator_ ||
                                   column_.column_title || field_separator_ ||
                                   column_.column_query || record_separator_;
         col_count_ := col_count_ + 1;
      ELSE
         col_prop_ := col_prop_ || column_.column_name || field_separator_ ||
                                   NULL || field_separator_ ||
                                   Get_Column_Datatype___(report_id_, column_.column_name) || field_separator_ ||
                                   NULL || field_separator_ ||
                                   column_.column_query || record_separator_;
      END IF;
   END LOOP;
   FOR text IN get_report_texts(report_id_) LOOP
      Client_SYS.Add_To_Attr(text.text_name, text.text, rep_txt_);
   END LOOP;
   Client_SYS.Add_To_Attr('LAST_DDL_TIME', Report_SYS.Get_Last_Ddl_Time(report_id_), rep_attr_);
   report_attr_ := rep_attr_;
   column_properties_ := col_prop_;
   text_properties_ := rep_txt_;
   Language_SYS.Enumerate_Report_Languages_(lang_properties_, report_id_);
   Enumerate_Report_Layout(layout_properties_, report_id_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'REPERR1: Report [:P1] does not exist.', report_id_);
END Get_Class_Info;


PROCEDURE Get_Column_Print_Properties (
   col_name_list_  OUT VARCHAR2,
   col_item_list_  OUT VARCHAR2,
   col_type_list_  OUT VARCHAR2,
   col_title_list_ OUT VARCHAR2,
   lang_code_      IN  VARCHAR2,
   report_id_      IN  VARCHAR2 )
IS
   col_names_          VARCHAR2(32000);
   col_items_          VARCHAR2(32000);
   col_types_          VARCHAR2(32000);
   col_titles_         VARCHAR2(32000);
   col_count_          NUMBER;
   title_              VARCHAR2(500);
   logical_unit_       VARCHAR2(30);
BEGIN
   col_count_ := 0;
   logical_unit_ := Get_Lu_Name(report_id_);
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (NVL(column_.item_name, column_.column_title) IS NOT NULL) THEN
         col_names_ := col_names_ || column_.column_name || field_separator_;
         col_items_ := col_items_ || NVL(column_.item_name, Transform_Item___(column_.column_name, col_count_)) || field_separator_;
         col_types_ := col_types_ || Get_Column_Datatype___(report_id_, column_.column_name) || field_separator_;
         title_ := Language_SYS.Translate_Report_Column_(logical_unit_, report_id_, column_.column_name,
                                                                            NVL(column_.column_title,Transform_Title___(column_.column_name)), lang_code_);
         col_titles_ := col_titles_ || title_ ||field_separator_;
         col_count_ := col_count_ + 1;
      END IF;
   END LOOP;
   col_name_list_ := col_names_;
   col_item_list_ := col_items_;
   col_type_list_ := col_types_;
   col_title_list_ := col_titles_;
END Get_Column_Print_Properties;


PROCEDURE Get_Layout_Title (
   layout_title_ OUT VARCHAR2,
   report_id_    IN  VARCHAR2,
   layout_name_  IN  VARCHAR2 )
IS
BEGIN
   Report_Layout_Definition_API.Get_Translated_Layout_Title(layout_title_, report_id_, layout_name_);
END Get_Layout_Title;


PROCEDURE Get_Report_Translations (
   report_attr_      OUT VARCHAR2,
   col_title_attr_   OUT VARCHAR2,
   col_query_attr_   OUT VARCHAR2,
   report_text_attr_ OUT VARCHAR2,
   report_id_        IN  VARCHAR2,
   lang_code_        IN  VARCHAR2 )
IS
   rep_attr_          VARCHAR2(2000);
   col_tit_           VARCHAR2(32000);
   col_que_           VARCHAR2(32000);
   rep_txt_           VARCHAR2(32000);
   title_             VARCHAR2(500);
   query_             VARCHAR2(500);
   translated_text_   VARCHAR2(2000);
   rep_def_           Public_Rec;
BEGIN
   rep_def_ := Get(report_id_);
   Client_SYS.Add_To_Attr('TITLE', Language_SYS.Translate_Report_Title_(rep_def_.lu_name, report_id_, Get_Prog_Report_Title(report_id_), lang_code_), rep_attr_);
   FOR column_ IN get_report_columns(report_id_) LOOP
      IF (NVL(column_.item_name, column_.column_title) IS NOT NULL) THEN
         title_ := Language_SYS.Translate_Report_Column_(rep_def_.lu_name, report_id_, column_.column_name, column_.column_title, lang_code_);
         Client_SYS.Add_To_Attr(column_.column_name, title_, col_tit_);
      END IF;
      IF (column_.column_query IS NOT NULL) THEN
         query_ := Language_SYS.Translate_Report_Question_(rep_def_.lu_name, report_id_, column_.column_name, column_.column_query, lang_code_);
         Client_SYS.Add_To_Attr(column_.column_name, query_, col_que_);
      END IF;
   END LOOP;
   FOR text IN get_report_texts(report_id_) LOOP
      translated_text_ := Language_SYS.Translate_Report_Text(rep_def_.lu_name, report_id_, text.text_name, text.text, lang_code_);
      Client_SYS.Add_To_Attr(text.text_name, translated_text_, rep_txt_);
   END LOOP;
   report_attr_ := rep_attr_;
   col_title_attr_ := col_tit_;
   col_query_attr_ := col_que_;
   report_text_attr_ := rep_txt_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'REPERR1: Report [:P1] does not exist.', report_id_);
END Get_Report_Translations;


@UncheckedAccess
PROCEDURE Get_Result_Key (
   result_key_ OUT NUMBER )
IS
BEGIN
   Report_SYS.Get_Result_Key__(result_key_);
END Get_Result_Key;


@UncheckedAccess
FUNCTION Get_Translated_Report_Title (
   report_id_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   default_value_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   rep_title_    VARCHAR2(50);
   report_title_ VARCHAR2(100);
   logical_unit_ VARCHAR2(50);
   CURSOR get_info IS
      SELECT  lu_name, report_title
      FROM  report_definition
      WHERE report_id = report_id_;
BEGIN
   OPEN get_info;
   FETCH get_info INTO logical_unit_, rep_title_;
   IF (get_info%FOUND) THEN
      report_title_ := Language_SYS.Translate_Report_Title_(logical_unit_, report_id_, rep_title_,lang_code_);  
      CLOSE get_info;
   ELSE
      CLOSE get_info;
      IF(default_value_ IS NULL) THEN
         report_title_ := Language_SYS.Translate_Constant(lu_name_, 'DELETEREPORT: Deleted Report ID :P1',NULL,CHR(39)||report_id_||CHR(39));
      ELSE
         report_title_ := default_value_;
      END IF;
   END IF;
   RETURN (report_title_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN ('<Deleted>');
END Get_Translated_Report_Title;


@UncheckedAccess
PROCEDURE Get_Navigator_Items (
   report_title_  OUT VARCHAR2,
   report_method_ OUT VARCHAR2,
   report_id_     IN  VARCHAR2 )
IS
   lu_name_    VARCHAR2(30);
   temp_title_ VARCHAR2(50);
   CURSOR get_attr IS
      SELECT lu_name, report_title, method
      FROM REPORT_SYS_TAB
      WHERE report_id = report_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO lu_name_, temp_title_, report_method_;
   CLOSE get_attr;
   report_title_ := Language_SYS.Translate_Report_Title_(lu_name_, report_id_, temp_title_, '');
END Get_Navigator_Items;


PROCEDURE Get_Custom_Field_Translations (
   cf_lu_name_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   cf_lu_translations_ OUT VARCHAR2 )
IS
$IF Component_Fndcob_SYS.INSTALLED $THEN
cf_trans_           VARCHAR2(32000);
translated_text_   VARCHAR2(2000);
CURSOR get_custom_field_attributes (lu_name_c_ VARCHAR2) 
   IS
     SELECT
        cfa.column_name,
        cfa.attribute_name,
        cfa.objkey rowkey_ref,
        cfa.prompt,
        cfa.enabled_on_reports_db
     FROM cf_attribute_runtime cfa
     WHERE cfa.lu = lu_name_c_ AND cfa.lu_type = 'CUSTOM_FIELD'
     ORDER BY cfa.objversion; 
$END
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
    FOR the_record IN get_custom_field_attributes (cf_lu_name_) LOOP   
	  IF the_record.enabled_on_reports_db = 'TRUE' THEN
        translated_text_ := custom_field_attributes_api.Get_Prompt_Translation(cf_lu_name_,Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD,
                                                       the_record.column_name,
                                                       the_record.rowkey_ref,
                                                       the_record.prompt,
                                                       lang_code_);
       Client_SYS.Add_To_Attr(the_record.attribute_name, translated_text_, cf_trans_);  
     END IF;      
    END LOOP;  
    cf_lu_translations_ := cf_trans_ ;
$ELSE
    cf_lu_translations_ := NULL;
$END
EXCEPTION
   WHEN others THEN
      Error_SYS.Appl_General(lu_name_, 'CFTRANSE: Get_Report_CustomField_Translations LU = [:P1] .', cf_lu_name_);
END Get_Custom_Field_Translations;

-- Check_Definition_Exist
--   Checks if given report definition exists. If found will return true, if not will return false.
-----------------------------------------------------------------------------

PROCEDURE Check_Definition_Exist (
   report_id_ IN VARCHAR2,
   is_exist_   OUT BOOLEAN)
IS
BEGIN
   is_exist_ := Check_Exist___(report_id_);
END Check_Definition_Exist;


PROCEDURE Report_Definition_Modify (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   attr_       IN VARCHAR2)
IS
   info_             VARCHAR2(2000);
   new_attr_         VARCHAR2(2000);
   new_objversion_   VARCHAR2(100);
BEGIN
   new_attr_ := attr_;
   new_objversion_ := objversion_;
   Modify__(info_, objid_, new_objversion_, new_attr_, 'PREPARE');
   Modify__(info_, objid_, new_objversion_, new_attr_, 'DO');
END Report_Definition_Modify;
