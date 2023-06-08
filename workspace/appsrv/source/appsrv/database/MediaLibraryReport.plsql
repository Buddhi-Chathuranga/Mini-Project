-----------------------------------------------------------------------------
--
--  Logical unit: MediaLibraryReport
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  -------------------------- APPS 9 ---------------------------------------
--  131122  paskno  Hooks: refactoring and splitting.
--  110310  MAANLK  Bug 95974, Modified column comments for library_id and library_item_id to make them parent keys.
--  091215  JICE    Changed view reference to use Cascade delete.
--  091209  Hasplk  Added SQL placeholders for hardcoded view names.
--  091116  PAWELK  Modified the cursor get_basic_reports in Insert_Initial_Data().
--  091109  PAWELK  Added Get_Report_Title().
--  091029  PAWELK  Renamed LU InfoObjectRepOverride to MediaLibraryReport. Changed the code accordingly.
--  091029          Modified the module by setting module name from partca to appsrv.
--  091020  PAWELK  Removed view INFO_OBJ_REP_OVERRIDE_CLASS and modified view
--  091020  PAWELK  INFO_OBJECT_REP_OVERRIDE. Removed Get_As_Attachment() and Report_Class_Exists().
--  090909  PAWELK  Added Check_Exist().
--  090831  PAWELK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Report_Title (
   report_id_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_name_    VARCHAR2(30);
   report_title_ VARCHAR2(50);
   rep_title_    VARCHAR2(2000);
BEGIN
   lu_name_ := Report_SYS.Get_Lu_Name(report_id_);
   report_title_ := Report_SYS.Get_Report_Title(report_id_);
   rep_title_ := Language_SYS.Lookup('REPORT', lu_name_||'.'||report_title_, 'Title', Language_SYS.Get_Language, 'LU');
   RETURN(nvl(rep_title_, report_title_));
END Get_Report_Title;


PROCEDURE Override_Library_Item_Report (
   library_id_         IN VARCHAR2,
   library_item_id_    IN NUMBER,
   report_id_          IN VARCHAR2,
   media_print_option_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(20);
   info_       VARCHAR2(200);
BEGIN

   Client_SYS.Add_To_Attr('LIBRARY_ID',library_id_, attr_);
   Client_SYS.Add_To_Attr('LIBRARY_ITEM_ID',library_item_id_, attr_);
   Client_SYS.Add_To_Attr('REPORT_ID',report_id_, attr_);
   Client_SYS.Add_To_Attr('MEDIA_PRINT_OPTION',media_print_option_, attr_);

   IF NOT (Check_Exist___(library_id_, library_item_id_, report_id_)) THEN
      New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Override_Library_Item_Report;


PROCEDURE Insert_Initial_Data (
   insert_ OUT VARCHAR2,
   library_id_        IN VARCHAR2,
   library_item_id_ IN NUMBER )
IS
   media_print_option_ VARCHAR2(20);

   CURSOR get_basic_reports IS
      SELECT r.report_id
      FROM media_report_tab r
      WHERE r.report_id NOT IN (SELECT o.report_id
                              FROM media_library_report_tab o
                              WHERE o.library_id = library_id_
                              AND o.library_item_id = library_item_id_);
BEGIN

   insert_ := 'FALSE';
   media_print_option_ := Media_Library_Item_API.Get_Media_Print_Option(library_id_, library_item_id_);

   FOR basic_report IN get_basic_reports LOOP
       Override_Library_Item_Report(library_id_, library_item_id_, basic_report.report_id, media_print_option_);
       insert_ := 'TRUE';
   END LOOP;
END Insert_Initial_Data;


PROCEDURE Remove_Data (
   library_id_      IN VARCHAR2,
   library_item_id_ IN NUMBER )
IS
   info_       VARCHAR2(200);

   CURSOR get_rec IS
      SELECT objid, objversion
      FROM MEDIA_LIBRARY_REPORT
      WHERE library_id = library_id_
      AND library_item_id = library_item_id_;
BEGIN
   FOR remove_rec IN get_rec LOOP
      Remove__(info_, remove_rec.objid, remove_rec.objversion, 'DO');
   END LOOP;
END Remove_Data;


@UncheckedAccess
FUNCTION Check_Exist (
   library_id_      IN VARCHAR2,
   library_item_id_ IN NUMBER,
   report_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   MEDIA_LIBRARY_REPORT_TAB
      WHERE library_id = library_id_
      AND   library_item_id = library_item_id_
      AND   report_id = report_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN ('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN ('FALSE');
END Check_Exist;



