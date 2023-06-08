-----------------------------------------------------------------------------
--
--  Logical unit: QuickReport
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971204  MANY  Created
--  980116  MANY  Fixed problem with default category, NULL values not accepted.
--  980206  MANY  Fixed problem with Oracle 8, illegal semantics. Bug #2096
--  980311  MANY  Fixed problem with Quick Report Administrator, setting category_id,
--                bug #2231.
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990301  DAJO  Added type (reference to QuickReportType) and file name
--                attributes for Project Invader (ToDo #3177).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021119  ROOD  Added Presentation Objects for Quick Reports (GLOB11).
--  021205  ROOD  Corrections in Unpack_Check_Insert___ and Set_Category_Id (GLOB11).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Changed hardcoded FNDINF to FNDBAS (ToDo#4149).
--  031015  ROOD  Improved method Create_Presentation_Object___.
--  040223  ROOD  Replaced oracle_role with role everywhere (ToDo#????).
--  040316  ROOD  Removed some trace calls in the code (Bug#42002).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040929  ASWI  In Create_Presentation_Object___ replaced the AO and APPOWNER with
--                actual application owner (Bug#44949).
--  041020  ROOD  Added setting of info_type for Presentation Objects.
--                Removed the NOCHECK for reference to PresObject (Bug#44954).
--  050727  ASWI  Added method Get_Datatypes__ (Bug#50495).
--  051219  HAAR  Changed Is_Available__ to use System Privilege (Call 129949).
--  060526  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--                Annotated Sql injection.
--  060816 RARULK Changed the parameter of method Get_Datatypes__from quick_report_id_ to Statement (Bug#59922).
--  061004  NiWi   Added new dummy method Run_Local_ for PO security control puposes.
--  070703 SUMALK Added the Get_Po_id and Changed the Update___ method(Bug#65122)
--  070731 DUWILK DUWILK Changed data lengths in Create_Presentation_Object___, 
--                Unpack_Check_Insert___,Unpack_Check_Update___(Bug#64671).
--  071220 SUMALK Changed the Dbms_Sql.Describe_Columns to Dbms_Sql.Describe_Columns2
--                to aviod errors for long SQL reports.(Bug#69208).  
--  080110 SuMa   Changed  Get_Po_id  return type(Bug# 70467)
--  080114 SUMALK Added the Quick Report Prefix to Press Obj Desc(Bug#70546)
--  080902 HAAR   Changed bad error message when accessing non existing db objects (Bug#76742).
--  120224 DUWI   Dropped decimals when generating Quick report PO Id (RDTERUNTIME-1931).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.


--  100614  HAAR  Expandable parameters (Bug#90379).
--  100914 GADALK Added new view QUICK_REPORT_NON_BI (Bug#93000)
--  100916 SJayLK Modified Check_Type_dependant_Attr___ for MS_REPORT, DASHBOARD, WEB_REPORT report types
--  101007 VoHelk Modified QUICK_REPORT_NON_BI view
--  130325 JHMASE SQL Expression is wrong error when using Extract function (Bug #109139
--  131202 NIWESE Changed Check_Type_Dependant_Attr___ for Query report type.
--  140129  AsiWLK   Merged LCS-111925
--  140312 NIWESE Changed SqlExpression to CLOB, removed check for mandatory because of that.
--  140425 NaBaLK Added a seperate method to validate SQL expression (TEREPORT-1197)
--  150506 NaBaLK IAL object security when publishing (Bug#121752) 
--  150507 MaDrSE LCS-120857: Accept Sql expression starting with WITH as SELECT statement
--  160509 MaDiLK Merging LCS-128281 through TEREPORT-2071
--  160805 MABALK Extract LU name from DICTIONARY_SYS_VIEW_COLUMN.column_reference(Bug#130741).
--  TEUXX-3077 sawelk Refresh dynamic projection at insert update and delete.
--  170524 MaBaLK Presentation Object Grants for Custom Objects (Bug#135999)
--  180504 CHAALK Error when saving SQLQuick Reports with XMLAGG and EXTRACT Oracle functions (Bug#140799)
--  180914 CHAALK Quick Reports Insufficient Privileges to view but can export to excel (Bug#143842)
--  190130 LAKRLK SQL Quick Report error when viewed in Aurena client (Bug#146389)
--  190624 DDESLK Internal Error for LOV in Query Builder Reports (Bug#148404)
--  191219 DINDLK Query Builder - Quick Report parameters are not translated (Bug#151431)
--  110920 DIDSLK Error viewing the Crystal reports in Aurena client (DUXZREP-378)
--  081020 MABALK Changes related to containerization metadata cache refresh (TEREPORT-3205)
--  280621 NALTLK Unable to save quick reports with aliases more than 32 characters (OR21R2-240)
--  211029 MABALK Aurena Quick Reports: DateTime, Timestamp and Numeric columns not formatted properly (Bug#161434)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

expandable_par_ CONSTANT VARCHAR2(2) := Chr(91) || Chr(38);

EXPORT_DEF_VERSION          CONSTANT VARCHAR2(5)   := '1.0';
XMLTAG_CUST_OBJ_EXP         CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_CUSTOM_EVENT         CONSTANT VARCHAR2(50)  := 'QUICK_REPORT';
XMLTAG_CUST_OBJ_EXP_DEF_VER CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';
AMPERSAND                   CONSTANT VARCHAR2(10)  := CHR(38);

CURSOR get_quick_report_header(xml_ Xmltype) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/QUICK_REPORT' passing xml_
                         COLUMNS
                            EXPORT_DEF_VERSION VARCHAR2(30) path 'EXPORT_DEF_VERSION',
                            QUICK_REPORT_ID NUMBER path 'QUICK_REPORT_ID',
                            DESCRIPTION VARCHAR2(50) path 'DESCRIPTION',
                            SQL_EXPRESSION CLOB path 'SQL_EXPRESSION',
                            COMMENTS VARCHAR2(2000) path 'COMMENTS',
                            CATEGORY_ID NUMBER path 'CATEGORY_ID',
                            CATEGORY_DESCRIPTION VARCHAR2(50) path 'CATEGORY_DESCRIPTION',
                            FILE_NAME VARCHAR2(2000) path 'FILE_NAME', 
                            QR_TYPE VARCHAR2(15) path 'QR_TYPE',
                            PO_ID VARCHAR2(200) path 'PO_ID',
                            QUERY CLOB path 'QUERY',
                            ROW_TYPE VARCHAR2(100) path 'ROW_TYPE',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            ROWKEY VARCHAR2(100) PATH 'OBJKEY'
                        ) xt1; 

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Type_Dependant_Attr___ (
   qr_type_        IN VARCHAR2,
   file_name_      IN VARCHAR2)
IS
BEGIN
    IF ( qr_type_ = 'SQL' ) THEN
        IF ( file_name_ IS NOT NULL ) THEN
            Error_SYS.Item_General(lu_name_, 'FILE_NAME',      'NOVALUE: :P1 may not have a value when type is set to :P2', 'Report Reference', 'SQL Statement');
        END IF;
      
    ELSIF ( qr_type_ = 'QUERY' ) THEN
        IF ( file_name_ IS NOT NULL ) THEN
            Error_SYS.Item_General(lu_name_, 'FILE_NAME',      'NOVALUE: :P1 may not have a value when type is set to :P2', 'Report Reference', 'Query Builder');
        END IF;

    ELSIF ( qr_type_ IN ('CR', 'MS_REPORT', 'DASHBOARD', 'WEB_REPORT' ) ) THEN
        IF (file_name_ IS NULL ) THEN
            Error_SYS.Item_General(lu_name_, 
                             'FILE_NAME', 
                             'VALUEMANDATORY: :P1 must have a value when type is set to :P2',
                             'Report Reference',
                             Quick_Report_Type_API.Decode(qr_type_));
        END IF;
    END IF;
END Check_Type_Dependant_Attr___;


FUNCTION Substitute_Owner_Prefix___(
   sql_expression_ IN CLOB ) RETURN VARCHAR2
IS
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   ial_prefix_     VARCHAR2(31)   := Fnd_Setting_API.Get_Value('IAL_USER')||'.';
   stmt_           CLOB           := sql_expression_;
BEGIN
   -- Look for appowner prefixing function calls and views
   -- Replace AO and APPOWNER with actual appowner
   -- Note! Important to do the test in this order
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.\.', ial_prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.', ial_prefix_,1,0,'i');
   RETURN(stmt_);
END Substitute_Owner_Prefix___;



-- Create_Presentation_Object___
--   Evaluates Quick Report and its sql expression and creates a corresponding
--   Presentation Object.
FUNCTION Create_Presentation_Object___ (
   quick_report_id_       IN NUMBER,
   description_           IN VARCHAR2,
   sql_expression_        IN CLOB,
   recreate_              IN BOOLEAN DEFAULT FALSE,
   is_import_validation_  IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   po_id_          VARCHAR2(200)  := 'repQUICK_REPORT'||quick_report_id_;
   po_description_ VARCHAR2(70)   := 'Quick Report - '||description_;
   stmt_           CLOB           := sql_expression_;
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   pos_            NUMBER;
   to_pos_         NUMBER;
   char_number_    NUMBER;
   db_object_      VARCHAR2(2000);
   object_type_    VARCHAR2(6);
   sub_type_       VARCHAR2(1);
   status_text_    VARCHAR2(200);
   sql_status_     VARCHAR2(20);

BEGIN

   IF recreate_ THEN
      Pres_Object_Util_API.Remove_Pres_Object(po_id_);
   END IF;

   Pres_Object_Util_API.New_Pres_Object(po_id_, 'FNDBAS', 'REP', po_description_, 'Manual');

   IF stmt_ IS NOT NULL THEN
      -- Partially validated SQLs are accepted(when importing through an ACP) to allow import of quick reports with SQLs, referencing objects in the ACP (Ex. _CFPs).

      status_text_:= Validate_SQL_Expression___(sql_status_,stmt_,is_import_validation_);
      IF sql_status_ = 'INVALID' THEN
         Error_SYS.Appl_General(lu_name_, status_text_);
      END IF;
      
      stmt_ := UPPER(Substitute_Owner_Prefix___(stmt_));
      --
      pos_ := instr(stmt_, prefix_);
      WHILE pos_ > 0 LOOP
         pos_ := pos_ + length(prefix_);
         to_pos_ := pos_;

         -- Look for the end of the db-object (characters in db-objects are ascii: 46, 48..57, 65..90, 95)
         char_number_ := ascii(substr(stmt_, to_pos_, 1));
         WHILE char_number_ = 46 OR (char_number_ BETWEEN 48 AND 57) OR (char_number_ between 65 and 90) OR char_number_ = 95 LOOP
            to_pos_ := to_pos_ + 1;
            char_number_ := ascii(substr(stmt_, to_pos_, 1));
         END LOOP;

         -- Extract the db-object
         db_object_ := substr(stmt_, pos_, to_pos_ - pos_);

         -- Validate the db-object and insert it
         IF db_object_ IS NOT NULL THEN
            -- Define type
            IF instr(db_object_, '_API.') > 0 OR instr(db_object_, '_SYS.') > 0 OR instr(db_object_, '_RPI.') > 0 OR instr(db_object_, '_CFP.') > 0 OR instr(db_object_, '_CLP.') > 0 THEN
               db_object_   := upper(substr(db_object_, 1, instr(db_object_, '.') - 1))||InitCap(substr(db_object_, instr(db_object_, '.')));
               object_type_ := 'METHOD';
               sub_type_    := '2';
            ELSE
               object_type_ := 'VIEW';
               sub_type_    := '4';
            END IF;
            -- Avoid incorrect objects
            IF object_type_ = 'VIEW' AND instr(db_object_, '.') > 0 THEN
               -- Discovered column prefixed with view, removing column name
               db_object_ := substr(db_object_, 1, instr(db_object_, '.') - 1 );
            END IF;
            -- Check lengths and if correct insert
            IF object_type_ = 'VIEW' AND length(db_object_) > 30 THEN
               -- Ignore if too long view name
               NULL;
            ELSIF object_type_ = 'METHOD' AND length(db_object_) > 61 THEN
               -- Ignore if too long method name
               NULL;
            ELSE
               Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, db_object_, object_type_, sub_type_, 'Manual');
            END IF;
         END IF;
         -- Reinitiate variables
         db_object_ := NULL;
         -- Find next occurance of prefix, start from end of last occurance
         pos_ := instr(stmt_, prefix_, pos_);
      END LOOP;
   END IF;

   -- Transfer the Presentation Object to the repository
--   Pres_Object_Util_API.Transfer_Build_Storage('FNDBAS', po_id_);

   -- Set the info type to manual to prevent the data from being deleted in an upgrade etc.
--   Pres_Object_Util_API.Set_Info_Type_(po_id_, 'Manual', TRUE);

   RETURN po_id_;

END Create_Presentation_Object___;

PROCEDURE Find_Used_Ials___(
   ial_list_       OUT VARCHAR2,
   sql_expression_ IN  CLOB)
IS    
   i_          NUMBER          := 0;
   stmt_       CLOB            := sql_expression_;
   prefix_     VARCHAR2(31)    := UPPER(Fnd_Session_API.Get_App_Owner)||'.';
   ial_prefix_ VARCHAR2(31)    := UPPER(Fnd_Setting_API.Get_Value('IAL_USER'))||'.';
   regex_      VARCHAR2(48)    := '(' || ial_prefix_ || ')([A-Za-z_0-9]+)';
   ial_name_   VARCHAR2(50);
   dummy_      NUMBER;
      
   CURSOR check_ial_exists IS
      SELECT 1
        FROM ial_object_tab
       WHERE name = ial_name_;
BEGIN      
   stmt_ := REPLACE(stmt_, chr(38)||'AO..',       prefix_);
   stmt_ := REPLACE(stmt_, chr(38)||'APPOWNER..', prefix_);
   stmt_ := REPLACE(stmt_, chr(38)||'IAL..',      ial_prefix_);
   stmt_ := REPLACE(stmt_, chr(38)||'AO.',        prefix_);
   stmt_ := REPLACE(stmt_, chr(38)||'APPOWNER.',  prefix_);
   stmt_ := REPLACE(stmt_, chr(38)||'IAL.',       ial_prefix_);
      
   LOOP
      i_ := i_ + 1;
         
      ial_name_ := UPPER(REGEXP_SUBSTR(stmt_, regex_, occurrence => i_, modifier => 'i', subexpression => 2));
         
      EXIT WHEN ial_name_ IS NULL;
         
      IF (LENGTH(ial_name_) <= 30) THEN
         OPEN check_ial_exists;
         FETCH check_ial_exists INTO dummy_;            
         IF ( check_ial_exists%FOUND ) THEN
            CLOSE check_ial_exists;
               
            IF ( NOT ';' || ial_list_ LIKE '%;' || ial_name_ || ';%' ) THEN
               ial_list_ := ial_list_ || ial_name_ || ';';
            END IF;
         ELSE
            CLOSE check_ial_exists;
         END IF;
      END IF;
   END LOOP;
END Find_Used_Ials___;

   
FUNCTION Get_Ial_Grant_Info___ (
   ial_list_ IN VARCHAR2,
   role_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   start_     NUMBER := 1;
   end_       NUMBER;
   ial_owner_ VARCHAR2(30) := UPPER(Fnd_Setting_API.Get_Value('IAL_USER'));
   ial_name_  VARCHAR2(30);
   dummy_     NUMBER;
      
   CURSOR check_ial_granted IS
      SELECT 1
        FROM all_tab_privs_made
       WHERE privilege = 'SELECT'
         AND owner = ial_owner_
         AND grantee = role_
         AND table_name = ial_name_;
BEGIN
   IF ( ial_list_ IS NULL ) THEN
      RETURN 'GRANTED';
   END IF;
      
   LOOP
      end_ := NVL(INSTR(ial_list_, ';', start_),0);
         
      EXIT WHEN end_ < 1;
         
      ial_name_ := SUBSTR(ial_list_, start_, end_ - start_);
         
      OPEN check_ial_granted; 
      FETCH check_ial_granted INTO dummy_;
      IF (check_ial_granted%NOTFOUND) THEN
         CLOSE check_ial_granted;
         RETURN 'NOT FULLY GRANTED';
      ELSE
         CLOSE check_ial_granted;
      END IF;
         
      start_ := end_ + 1;
   END LOOP;
      
   RETURN 'GRANTED';
END Get_Ial_Grant_Info___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   quick_report_id_ NUMBER;
BEGIN
   quick_report_id_ := Client_SYS.Get_Item_Value('QUICK_REPORT_ID', attr_);
   super(attr_);
   WHILE (quick_report_id_ IS NULL OR Check_Exist___(quick_report_id_)) LOOP
      SELECT trunc(mod((extract(second from systimestamp)+extract(minute from systimestamp)*60)*1000, 1000000))
      INTO quick_report_id_
      FROM dual;
   END LOOP;
   Client_SYS.Add_To_Attr('QUICK_REPORT_ID', quick_report_id_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT QUICK_REPORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   newrec_.po_id := Create_Presentation_Object___(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression);
   Client_SYS.Add_To_Attr('PO_ID', newrec_.po_id, attr_);
   super(objid_, objversion_, newrec_, attr_);

   Init_Report_Metadata(newrec_.quick_report_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     QUICK_REPORT_TAB%ROWTYPE,
   newrec_     IN OUT QUICK_REPORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   po_id_  VARCHAR2(100);
   press_object_desc_  VARCHAR2(200);
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);

   IF nvl(oldrec_.sql_expression, ' ') != nvl(newrec_.sql_expression, ' ') THEN
      -- The presentation object information will have to be recreated in this case.
      newrec_.po_id := Create_Presentation_Object___(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression, TRUE);
   ELSIF (oldrec_.description != newrec_.description)  THEN
     -- Get the Po_id from quick_report_id.
      -- Update the Description from the Po_id
      press_object_desc_ := 'Quick Report - '||newrec_.description;
      po_id_ := Get_Po_Id(newrec_.quick_report_id);
      Pres_Object_Description_Api.Modify_Description(po_id_,'en',press_object_desc_);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
  
   Init_Report_Metadata(newrec_.quick_report_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN QUICK_REPORT_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Remove the corresponding Presentation Object too
   Pres_Object_Util_API.Remove_Pres_Object(remrec_.po_id);   
   Init_Report_Metadata(remrec_.quick_report_id, true);
END Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     quick_report_tab%ROWTYPE,
   newrec_ IN OUT quick_report_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(4000);
   category_description_ QUICK_REPORT.category_description%TYPE;
BEGIN
   category_description_ := Client_SYS.Get_Item_Value('CATEGORY_DESCRIPTION', attr_);
   IF (category_description_ IS NOT NULL) THEN
      newrec_.category_id := Report_Category_API.Get_By_Description(category_description_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('CATEGORY_ID', newrec_.category_id, attr_);
   Client_SYS.Add_To_Attr('CATEGORY_DESCRIPTION', category_description_, attr_);
   Check_Type_Dependant_Attr___(newrec_.qr_type, newrec_.file_name);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;

FUNCTION Get_Query_Value___(qr_type_ IN VARCHAR2, 
                            query_   IN CLOB) RETURN CLOB                            
IS
BEGIN
   IF qr_type_ = 'QUERY' THEN
      RETURN query_;
   ELSE
      RETURN NULL;
   END IF;    
END Get_Query_Value___; 

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Is_Available__
--   Return 'TRUE' if the Presentation Object for this report is granted to
--   the current user. 'Else it returns FALSE'. This method is intended to be
--   used in the view for this LU and is custom made for this purpose.
--   Note that the parameter is the po_id, not the report_id.
--   If the presentation object does not exist, 'TRUE' will be returned.

@UncheckedAccess
@Deprecated
FUNCTION Is_Available__ (
   po_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- NOTE! Function is to be replaced with Is_Report_Available__!
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User) THEN
      RETURN 'TRUE';
   ELSIF Security_SYS.Is_Pres_Object_Available(po_id_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Available__;

@UncheckedAccess
FUNCTION Is_Report_Available__ (
   quick_report_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User) THEN
     RETURN 1;
   ELSIF Security_SYS.Is_Projection_Available(Get_Projection_Name(quick_report_id_)) THEN
     RETURN 1;
   END IF;
   
   RETURN 0;
END Is_Report_Available__;


-- Publish__
--   Enable this report to all roles that have sufficient grants in the database.
--   This is done using the Presentation Object Security concept.
PROCEDURE Publish__ (
   quick_report_id_ IN NUMBER )
IS
   rec_ QUICK_REPORT_TAB%ROWTYPE;
   ial_list_ VARCHAR2(4000);

   CURSOR get_roles IS
      SELECT role
      FROM fnd_role_tab
      WHERE role NOT IN ('FND_WEBRUNTIME');
BEGIN
   rec_ := Get_Object_By_Keys___(quick_report_id_);
   Find_Used_Ials___(ial_list_, rec_.sql_expression);
   FOR roles IN get_roles LOOP
      Fnd_Projection_Grant_API.Grant_Query(Get_Projection_Name(quick_report_id_), roles.role, 'FALSE');
      -- First enable the Presentation Object
      Pres_Object_Grant_API.New_Grant(rec_.po_id, roles.role);      
      -- Now use the utility method to investigate the grant info
      IF Pres_Object_Util_API.Get_Grant_Info(rec_.po_id, roles.role) != 'GRANTED' THEN
         -- IF it is not fully granted, then disable the Presentation Object again
         Pres_Object_Grant_API.Remove_Grant(rec_.po_id, roles.role);
      END IF;
      -- Check whether IALs are granted
      IF (Get_Ial_Grant_Info___(ial_list_, roles.role) != 'GRANTED') THEN
         -- If it is not fully granted, then disable the Presentation Object again
         Pres_Object_Grant_API.Remove_Grant(rec_.po_id, roles.role);
      END IF;
   END LOOP;
END Publish__;


FUNCTION Get_Datatypes__ (
   statement_ IN CLOB ) RETURN CLOB
IS
   c_             NUMBER;
   col_cnt_       INTEGER;
   col_num_       INTEGER;
   rec_tab_       Dbms_Sql.Desc_Tab2;
   msg_           CLOB := Message_SYS.Construct('QUICK_REPORT');
   stmt_          VARCHAR2(32000) := statement_;
   datatype_      VARCHAR2(30);

BEGIN

   IF stmt_ IS NULL THEN
      RETURN(NULL);
   END IF;
   
   -- Replace Appowner and IAL owner
   stmt_ := Substitute_Owner_Prefix___(stmt_);

   c_ := Dbms_Sql.Open_Cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering SQL statement
   @ApproveDynamicStatement(2006-05-26,haarse)
   Dbms_Sql.Parse(c_, stmt_, dbms_sql.native);
   Dbms_Sql.Describe_Columns2(c_, col_cnt_, rec_tab_);
   col_num_ := rec_tab_.first;

   WHILE (col_num_ IS NOT NULL) LOOP
      datatype_ := CASE rec_tab_(col_num_).col_type
                       WHEN '1'  THEN
                          'STRING'
                       WHEN '9'  THEN
                          'STRING'
                       WHEN '96' THEN
                          'STRING'
                       WHEN '2' THEN
                          'NUMBER'
                       WHEN '3' THEN
                          'NUMBER'
                       WHEN '12' THEN
                          'DATE'
                       WHEN '11' THEN
                          'ROWID'
                       WHEN '69' THEN
                          'ROWID'
                       WHEN '112' THEN
                          'CLOB'
                       WHEN '113' THEN
                          'BLOB'
                       WHEN '8' THEN
                          'LONG'
                       WHEN '180' THEN
                          'TIMESTAMP'
                       WHEN '181' THEN
                          'TIMESTAMP'
                       ELSE
                          'OTHER'
                       END;
      -- TEIEEFW-14459: Need to manually handle columns containing '=' (e.g. aliases) due to the message class not able to cover for these. /Rakuse
      Message_SYS.Add_Attribute(msg_, REPLACE(rec_tab_(col_num_).col_name, '=', '@@~##'), datatype_);
      col_num_ := rec_tab_.next(col_num_);
   END LOOP ;
   Dbms_Sql.Close_Cursor(c_);
   RETURN(msg_);
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Sql.Close_Cursor(c_);
      RAISE;
END Get_Datatypes__;


PROCEDURE Get_Parameter_Info__(
   columns_    IN         VARCHAR2, 
   info_       OUT NOCOPY VARCHAR2)
IS 
   count_       INTEGER;
   pos_         INTEGER;

   split_str_   VARCHAR2(32000);
   delimiter_   VARCHAR2(1);
   items_       Utility_SYS.STRING_TABLE;

   view_name_   VARCHAR2(30);
   column_name_ VARCHAR2(30);
   prompt_      VARCHAR2(100);
   datatype_    VARCHAR2(100);
   enumeration_ VARCHAR2(100);
   reference_   VARCHAR2(100);
   reference_with_params_ VARCHAR2(100);
   lu_name_     VARCHAR2(200);
   
BEGIN
   delimiter_ := '^';

   info_ := Message_SYS.Construct( 'ParameterInfo' );

   split_str_ := LTRIM(columns_, delimiter_);
   Utility_SYS.Tokenize(split_str_, delimiter_, items_, count_);

   FOR i_ IN 1..items_.COUNT LOOP
      pos_ := instr(items_(i_), '.');       
      IF ( pos_ >= 2 ) THEN
         view_name_ := substr( items_(i_), 1, pos_ - 1 );
         column_name_ := substr( items_(i_), pos_ + 1 );
         -- Handle db value columns as client value columns.
         IF ( substr(column_name_, length(column_name_) - 2) = '_DB' ) THEN
            column_name_ := substr(column_name_, 1, length(column_name_) - 3);
         END IF;

         IF ( column_name_ = 'STATE' OR column_name_ = 'OBJSTATE' ) THEN
             -- This information is not available in the dictionary,
             -- so we provide it manually instead.
             prompt_ := 'State';
             datatype_ := 'STRING(100)';
             enumeration_ := Dictionary_SYS.Get_State_Enumerate_Method__(view_name_);
             reference_ := '';
         ELSE
             -- Get column properties
            
            -- If the view is a Custom fields view but the column is not a Custom field
            -- then query the standard view instead, because it contains reference information used for LOVs.
            IF ( length(view_name_) > 4 AND substr(view_name_, length(view_name_) - 3, 4) = '_CFV' AND substr(column_name_, 1, 4) <> 'CF$_') THEN
               view_name_ := substr(view_name_, 1, length(view_name_) - 4);
            END IF;
            --SOLSETFW
            SELECT column_datatype,  c.enumeration, c.column_reference 
              INTO datatype_, enumeration_, reference_
              FROM dictionary_sys_view_column_act c
            WHERE column_name = column_name_
                AND view_name = view_name_;
            --SOLSETFW          
            SELECT DISTINCT lu_name
               INTO lu_name_
               FROM dictionary_sys_view_column_act
            WHERE view_name = view_name_;

            prompt_ := Language_Sys.Translate_Item_Prompt(lu_name_, column_name_,Fnd_Session_API.Get_Language());  
               
                              
            IF instr(reference_, '(') > 0 THEN
               -- Remove anything behind (, e.g. InventoryPart(contract)/NOCHECK
               pos_ := instr(reference_, '(');
               IF pos_ >= 2 THEN
                  reference_with_params_ := substr( reference_, pos_ , LENGTH(reference_) );
                  reference_ := substr( reference_, 1, pos_ - 1 );
               END IF;
            ELSIF instr(reference_, '/') > 0 THEN
               -- Remove anything behind /, e.g. CustomerInfo/NO_CHECK
               pos_ := instr(reference_, '/');
               IF pos_ >= 2 THEN
                  reference_with_params_ := NULL;
                  reference_ := substr( reference_, 1, pos_ - 1 );
               END IF;
            ELSE
               reference_with_params_ := NULL;
            END IF;

             IF LENGTH(reference_) > 0 AND UPPER(reference_) <> reference_ THEN
                -- Get Base view from Lu name
                reference_ := dictionary_sys.get_base_view( reference_ );
             END IF;

             IF LENGTH(enumeration_) > 0 AND UPPER(enumeration_) <> enumeration_ THEN
                -- Get Base package from Lu name
                enumeration_ := dictionary_sys.get_base_package(enumeration_) || '.Enumerate';
             END IF;
             
             IF LENGTH(reference_with_params_) > 0 AND UPPER(reference_with_params_) <> reference_with_params_ THEN
               reference_with_params_ := reference_ || UPPER(reference_with_params_);
             END IF;
             
         END IF;

         -- Add to message as prompt^datatype^enumeration^reference^  
         Message_SYS.Add_Attribute( 
            info_, 
            items_(i_), 
            prompt_ || delimiter_ || datatype_  || delimiter_ || enumeration_ || delimiter_ || reference_ || delimiter_ || reference_with_params_ || delimiter_ );
      END IF;

   END LOOP;

END Get_Parameter_Info__;


PROCEDURE Check_SQL_Expression__ (
   stmt_ IN CLOB )
IS
   cursor_        NUMBER;
   statement_     CLOB;
BEGIN
   IF stmt_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'SQL_EXPR_NULL: SQL Expression cannot be null for SQL Quick Reports.');
   ELSE
      statement_ := Substitute_Owner_Prefix___(stmt_);
      BEGIN
         cursor_ := dbms_sql.open_cursor;
         --
         -- IF a statement includes a expandable substitution variable that look like this '["ampersand"name]' we can not parse the statement
         --
         IF (Instr(statement_, expandable_par_) = 0) THEN
            -- Safe due to system privilege DEFINE SQL is needed for entering SQL statement
            @ApproveDynamicStatement(2014-04-25,NaBaLK)
            dbms_sql.parse(cursor_, statement_, dbms_sql.native);
         END IF;
         dbms_sql.close_cursor(cursor_);
      EXCEPTION
         WHEN OTHERS THEN
         dbms_sql.close_cursor(cursor_);
         Error_SYS.Appl_General(lu_name_, 'SQL_EXPRESSION: Sql Expression is wrong [:P1].', substr(statement_,1,2000));
      END;
   END IF;
END Check_SQL_Expression__;

@Override
PROCEDURE Write_Sql_Expression__ (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     CLOB )
IS
   newrec_ quick_report_tab%ROWTYPE;
BEGIN
   --Add pre-processing code here
   super(objversion_, rowid_, lob_loc_);
   newrec_ := Get_Object_By_Id___(rowid_);
   newrec_.po_id := Create_Presentation_Object___(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression, TRUE);
   Modify___(newrec_);
END Write_Sql_Expression__;

PROCEDURE Check_Package___ (
   remrec_ IN     quick_report_tab%ROWTYPE)
IS
   package_name_ VARCHAR2(100);
BEGIN
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: The Quick Report ":P1" cannot be deleted, unless removed from the package ":P2".', remrec_.quick_report_id, package_name_);
   END IF;   
END Check_Package___; 

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN quick_report_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(remrec_);
   Check_Package___(remrec_);
END Check_Delete___;

FUNCTION Validate_SQL_Expression___ (
   validate_status_       OUT VARCHAR2,   
   stmt_                  IN  CLOB,
   is_import_validation_  IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
   cursor_         NUMBER;
	statement_      CLOB; 
	invalid_identifier_ex EXCEPTION;
   column_count_ INTEGER;
   msg_ VARCHAR2(4000);
   column_tab_ Dbms_Sql.Desc_Tab2;
   columns_ VARCHAR2(32767) := '^';
   PRAGMA EXCEPTION_INIT(invalid_identifier_ex, -904); 
BEGIN
   IF stmt_ IS NULL THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'SQL_EXPR_NULL: SQL Expression cannot be null for SQL Quick Reports.');
   END IF;
   --
   -- Check only SELECT statement is provided. Before checking this we remove any leading line feeds and carriage returns
   -- In the return message only the first 100 characters of the SQL query is shown as the text to hold the full error message 
   -- in the variable defined in the Language_SYS package is limited. This is becasue the stmt is a CLOB and the variable to shown the message is a VARCHAR
   -- and it showns the mesesage and the SQL query
   --
   IF (regexp_instr(upper(trim (CHR(10) from (trim (CHR(13) from stmt_)))), ' *(SELECT|WITH) *') != 1) THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'SQL_SELECT: Sql Expression must be a SELECT statement [:P1].',Fnd_Session_API.Get_Language, substr(stmt_,1,100)); 
   END IF; 
   --
   -- Check that it is a valid statement
   --
   statement_ := Substitute_Owner_Prefix___(stmt_);

   cursor_ := dbms_sql.open_cursor;
   --
   -- IF a statement includes a expandable substitution variable that look like this '["ampersand"name]' we can not parse the statement
   --
   IF (Instr(statement_, expandable_par_) = 0) THEN
      -- Safe due to system privilege DEFINE SQL is needed for entering SQL statement
      @ApproveDynamicStatement(2018-09-12,pganlk)
      dbms_sql.parse(cursor_, statement_, dbms_sql.native);
      Dbms_Sql.Describe_Columns2(cursor_, column_count_, column_tab_);
      FOR i IN 1..column_count_ LOOP
        IF (INSTR(columns_, '^' || column_tab_(i).col_name || '^') > 0) THEN
          validate_status_ := 'INVALID';
          msg_ := msg_ || ',' || column_tab_(i).col_name;
        ELSE
          columns_ := columns_ || column_tab_(i).col_name || '^';
        END IF;
     END LOOP;
     IF(msg_ IS NOT NULL)THEN
         msg_  := substr(msg_,2,LENGTH(msg_));
         RETURN Language_SYS.Translate_Constant(lu_name_, 'DUPNAME: Error:Can not create this report. Column(s) :P1 exist(s) multiple times.',  p1_ => msg_);
      END IF;
   END IF;
   dbms_sql.close_cursor(cursor_);
	validate_status_ := 'VALID';
   RETURN Language_SYS.Translate_Constant(lu_name_, 'SQL_VALID: The Select Statement syntax was validated successfully.',Fnd_Session_API.Get_Language); 
EXCEPTION
   WHEN invalid_identifier_ex THEN  
      DECLARE
         count_ NUMBER;
      BEGIN
         dbms_sql.close_cursor(cursor_);
         IF is_import_validation_ THEN
            --If expressions contains custom CFP references, ignore the validation error and return a warning message 
            count_ := REGEXP_COUNT(statement_,'_CFP',1,'i');
            IF count_ > 0 THEN
               validate_status_ := 'PARTIALLY_VALID';
               RETURN Language_SYS.Translate_Constant(lu_name_,'SQL_PARTIALLY_VALID: Warning: The select statement contains references to custom objects. The quick report will not run until related custom object are published.',Fnd_Session_API.Get_Language);    
            END IF;
         END IF;
			validate_status_ := 'INVALID';
         -- In return message only the first 100 characters of the SQL query is shown as the text to hold the full error message 
         -- in the variable defined in the Language_SYS package is limited. This is becasue the stmt is a CLOB and the variable to shown the message is a VARCHAR
         -- and it showns the mesesage and the SQL query
         RETURN Language_SYS.Translate_Constant(lu_name_,'SQL_INVALID: Error: Sql Expression is wrong [:P1].',Fnd_Session_API.Get_Language, substr(stmt_,1,100));  
       END;
   WHEN OTHERS THEN
      dbms_sql.close_cursor(cursor_);
	   validate_status_ := 'INVALID';
      -- In the return message only the first 100 characters of the SQL query is shown as the text to hold the full error message 
      -- in the variable defined in the Language_SYS package is limited. This is becasue the stmt is a CLOB and the variable to shown the message is a VARCHAR
      -- and it showns the mesesage and the SQL query
      RETURN Language_SYS.Translate_Constant(lu_name_,'SQL_INVALID: Error: Sql Expression is wrong [:P1].',Fnd_Session_API.Get_Language, substr(stmt_,1,100));  
END Validate_SQL_Expression___;

FUNCTION Generate_FileName_For_Export__(
   selection_ IN VARCHAR2) RETURN VARCHAR2
IS
   selected_recs_true_              VARCHAR2(4000);
   i_                               NUMBER; 
   is_loop_                         BOOLEAN;
   quick_report_id_                 NUMBER;
   description_                     Quick_report_tab.description%TYPE;
   file_name_ VARCHAR2(100);
BEGIN
   IF selection_ IS NULL THEN
      file_name_ := NULL;
   ELSE
      selected_recs_true_ := selection_ || ';TRUE=1^';
      i_ := 1;
      is_loop_ := TRUE;  
      WHILE is_loop_ LOOP
         quick_report_id_ :=  Regexp_Substr(selection_,'[^(^;|^)QUICK_REPORT_ID=](\d*)[^(^;|^)]',1,i_);

         IF i_ = 1 THEN
            description_ := Quick_Report_API.Get(quick_report_id_).description;
            file_name_ := 'QuickReports_' || description_ || '.xml';
         END IF;
         IF quick_report_id_ IS NULL THEN
            IF i_ != 2 THEN
               file_name_ := 'QuickReports_' || to_char(sysdate, 'YYYY-MM-DD') || '.xml';
            END IF;
            is_loop_ := FALSE;
            EXIT;
         END IF;
         i_ := i_ + 1;      
      END LOOP;
   END IF;
   RETURN file_name_;
END Generate_FileName_For_Export__;

FUNCTION Generate_XML__ (
	selection_ IN VARCHAR2) RETURN BLOB
IS
   selected_recs_true_              VARCHAR2(4000);
   i_                               NUMBER; 
   is_loop_                         BOOLEAN;
   quick_report_id_                 NUMBER;
   report_rec_                      Quick_Report_API.Public_Rec;
   category_rec_                    Report_Category_API.Public_Rec;
   xml_type_                        XMLTYPE;
   file_data_                       BLOB;
BEGIN
   IF selection_ IS NULL THEN
      file_data_ := NULL;
   ELSE
      selected_recs_true_ := selection_ || ';TRUE=1^';
      i_ := 1;
      is_loop_ := TRUE;  
      WHILE is_loop_ LOOP
         quick_report_id_ :=  Regexp_Substr(selection_,'[^(^;|^)QUICK_REPORT_ID=](\d*)[^(^;|^)]',1,i_);
         report_rec_ := Quick_Report_API.Get(quick_report_id_);

         IF quick_report_id_ IS NULL THEN
            is_loop_ := FALSE;
            EXIT;
         END IF;

         category_rec_ := Report_Category_Api.Get(report_rec_.category_id);

         SELECT xmlconcat(xml_type_ , xmlelement("QUICK_REPORT", 
                                          xmlattributes('queried' as "state",  
                                               report_rec_."rowid" as "OBJ_ID",  
                                               report_rec_.rowversion as "OBJ_VERSION"),
                                          xmlconcat(   
                                              xmlelement("QUICK_REPORT_ID",      xmlattributes('Number' as "datatype"), quick_report_id_),
                                              xmlelement("DESCRIPTION",          xmlattributes('Text'   as "datatype"), report_rec_.description),
                                              xmlelement("SQL_EXPRESSION",       xmlattributes('Text'   as "datatype"), report_rec_.sql_expression),
                                              xmlelement("COMMENTS",             xmlattributes('Text'   as "datatype"), report_rec_.comments),
                                              xmlelement("DOMAIN_ID",            xmlattributes('Number' as "datatype"), report_rec_.domain_id),
                                              xmlelement("DOMAIN_DESCRIPTION",   xmlattributes('Text'   as "datatype")),
                                              xmlelement("CATEGORY_ID",          xmlattributes('Number' as "datatype"), report_rec_.category_id),
                                              xmlelement("CATEGORY_DESCRIPTION", xmlattributes('Text'   as "datatype"), category_rec_.description),
                                              xmlelement("FILE_NAME",            xmlattributes('Text'   as "datatype"), report_rec_.file_name),
                                              xmlelement("QR_TYPE",              xmlattributes('Enum'   as "datatype"), Quick_Report_Type_API.Get_Xml_Value(Quick_Report_Api.Get_Qr_Type(report_rec_.quick_report_id))),
                                              xmlelement("PO_ID",                xmlattributes('Text'   as "datatype")),
                                              xmlelement("QUERY",                xmlattributes('Text'   as "datatype"), report_rec_.query),   
                                              xmlelement("ROW_TYPE",             xmlattributes('Text'   as "datatype"), report_rec_.row_type),
                                              xmlelement("APP_CONFIG_PACKAGE",   xmlattributes('Text'   as "datatype"), report_rec_.row_type),
                                              xmlelement("QUICK_REPORT_CATEGORY", 
                                                                                 xmlattributes('Aggregate' as "datatype"), 
                                                                                 xmlelement("REPORT_CATEGORY", 
                                                                                                               xmlattributes(
                                                                                                                  'queried'                as "state",
                                                                                                                  category_rec_."rowid"    as "OBJ_ID",
                                                                                                                  category_rec_.rowversion as "OBJ_VERSION"
                                                                                                                ), 
                                                                                                                xmlconcat(
                                                                                                                     xmlelement("CATEGORY_ID", xmlattributes('Number' as "datatype"), report_rec_.category_id),
                                                                                                                     xmlelement("DESCRIPTION", xmlattributes('Text'   as "datatype"), category_rec_.description)
                                                                                                                )
                                                                                 )
                                             )
                                          )
                          )
               )
         INTO xml_type_
         FROM dual;

         i_ := i_ + 1;      
      END LOOP;

      SELECT xmlelement("QUICK_REPORT_LIST", xml_type_)
      INTO xml_type_
      FROM dual;

      file_data_ := xml_type_.getBlobVal(873);
   END IF;
   RETURN file_data_;
END Generate_XML__;

PROCEDURE Import_Reports__(
   in_xml_                IN  BLOB)
IS
   xml_                    XMLTYPE;
   objkey_                 VARCHAR2(100);
   import_rec_             quick_report_tab%ROWTYPE;
   CURSOR get_quick_report_header(xml_ Xmltype) IS
    SELECT xt.*
     FROM dual,
          xmltable('/QUICK_REPORT_LIST/QUICK_REPORT'
                     passing xml_
                     columns 
                       QUICK_REPORT_ID       NUMBER         path 'QUICK_REPORT_ID',
                       DESCRIPTION           VARCHAR2(50)   path 'DESCRIPTION',
                       SQL_EXPRESSION        CLOB           path 'SQL_EXPRESSION',
                       COMMENTS              VARCHAR2(2000) path 'COMMENTS',
                       CATEGORY_ID           NUMBER         path 'CATEGORY_ID',
                       CATEGORY_DESCRIPTION  VARCHAR2(50)   path 'CATEGORY_DESCRIPTION',
                       FILE_NAME             VARCHAR2(2000) path 'FILE_NAME', 
                       QR_TYPE               VARCHAR2(15)   path 'QR_TYPE',
                       PO_ID                 VARCHAR2(200)  path 'PO_ID',
                       QUERY                 CLOB           path 'QUERY'
                    ) xt;
   
   FUNCTION Include_Carriage_Return___ (in_clob_ IN CLOB) RETURN CLOB
   IS 
   BEGIN  
      RETURN REPLACE(in_clob_,chr(10), chr(13)||chr(10));
   END Include_Carriage_Return___;
   
   FUNCTION Format___ (xml_ IN CLOB) RETURN CLOB
   IS 
   BEGIN
      RETURN REGEXP_REPLACE(REGEXP_REPLACE(xml_, '(\s?)xmlns(.*)[^\A]',' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'), 'ifsrecord:');
   END Format___;
BEGIN 
   xml_ := XMLTYPE(Format___(Utility_SYS.Blob_To_Clob(in_xml_)));
   FOR rec_ IN get_quick_report_header(xml_) LOOP
      IF objkey_ IS NULL THEN
         import_rec_ := NULL;
         Prepare_New___(import_rec_);
         import_rec_.quick_report_id := rec_.QUICK_REPORT_ID;
         import_rec_.description := rec_.DESCRIPTION;
         import_rec_.comments := Include_Carriage_Return___(rec_.COMMENTS);
         import_rec_.file_name := rec_.FILE_NAME;
         import_rec_.qr_type := Quick_Report_Type_API.Get_Db_Value(Quick_Report_Type_API.Get_Index_Of_Xml_Value(rec_.QR_TYPE));
         import_rec_.sql_expression :=  CASE WHEN import_rec_.qr_type = 'SQL' THEN Include_Carriage_Return___(rec_.SQL_EXPRESSION) 
                                             ELSE NULL END;
         import_rec_.query := Get_Query_Value___(import_rec_.qr_type, rec_.QUERY);
         Import_New___(import_rec_, rec_.CATEGORY_DESCRIPTION);
      ELSE
         import_rec_ := Lock_By_Keys_Nowait___(rec_.QUICK_REPORT_ID);
         import_rec_.quick_report_id := rec_.QUICK_REPORT_ID;
         import_rec_.description := rec_.DESCRIPTION;
         import_rec_.comments := Include_Carriage_Return___(rec_.COMMENTS);
         import_rec_.category_id := rec_.CATEGORY_ID;
         import_rec_.file_name := rec_.FILE_NAME;
         import_rec_.qr_type := Quick_Report_Type_API.Decode(rec_.QR_TYPE);
         import_rec_.sql_expression :=  CASE WHEN import_rec_.qr_type = 'SQL' THEN 
                                                  Include_Carriage_Return___(rec_.SQL_EXPRESSION) 
                                             ELSE NULL 
                                             END;
         import_rec_.query := Get_Query_Value___(import_rec_.qr_type, rec_.QUERY);
         Import_Modify___(import_rec_);
      END IF;   
   END LOOP;
END Import_Reports__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Category_Id (
   quick_report_id_ IN NUMBER,
   category_id_     IN NUMBER )
IS
   newrec_               QUICK_REPORT_TAB%ROWTYPE;
   oldrec_               QUICK_REPORT_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000);
   objid_                QUICK_REPORT.objid%TYPE;
   objversion_           QUICK_REPORT.objversion%TYPE;
   category_description_ QUICK_REPORT.category_description%TYPE;
   indrec_               Indicator_Rec;   
BEGIN
   oldrec_ := Lock_By_Keys___(quick_report_id_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   category_description_ := Report_Category_API.Get_Description(category_id_);
   Client_SYS.Add_To_Attr('CATEGORY_DESCRIPTION', category_description_, attr_);   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Category_Id;


PROCEDURE Set_Category_By_Description (
   quick_report_id_ IN NUMBER,
   description_ IN VARCHAR2 )
IS
BEGIN
   Set_Category_Id(quick_report_id_, Report_Category_API.Get_By_Description(description_));
END Set_Category_By_Description;


PROCEDURE Export_XML (
   out_xml_         OUT CLOB,
   quick_report_id_ IN  NUMBER)
IS
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                              q.quick_report_id,
                                     q.description,
                                     q.sql_expression,
                                     q.comments,
                                     q.category_id,
                                     q.category_description,
                                     q.file_name,
                                     Quick_Report_Type_API.Encode(q.qr_type) qr_type,
                                     q.po_id,
                                     q.query,
                                     q.row_type,
                                     q.objkey,
                                     q.objversion,
                                     to_char(q.definition_modified_date ,'''||Client_SYS.date_format_||''') definition_modified_date
                              FROM quick_report q
                              WHERE q.quick_report_id = '''|| quick_report_id_ ||'''';
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_CUSTOM_EVENT;
BEGIN
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   objkey_ := Quick_Report_API.Get_Objkey(quick_report_id_);
   
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_CUSTOM_EVENT);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      App_Config_Util_API.Get_Item_Name(objkey_, App_Config_Item_Type_API.DB_QUICK_REPORT),
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      App_Config_Item_Type_API.DB_QUICK_REPORT,
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      App_Config_Util_API.Get_Item_Description(objkey_, App_Config_Item_Type_API.DB_QUICK_REPORT),
                                      xpath_);
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
END Export_XML;

PROCEDURE Validate_Import (
   info_               OUT    App_Config_Util_API.AppConfigItemInfo,
   dep_objects_        IN OUT App_Config_Util_API.DeploymentObjectArray,
   in_xml_             IN     CLOB,
   version_time_stamp_ IN     DATE)
IS
   attr_                   VARCHAR2(32000);
   import_date_            DATE;
   auth_                   VARCHAR2(1000);
   locked_                 VARCHAR2(100);
   status_text_            VARCHAR2(200);
   sql_status_             VARCHAR2(20);
   pkg_version_time_stamp_ DATE;
   
   xml_ Xmltype := Xmltype(in_xml_);
   import_rec_ quick_report_tab%ROWTYPE;
   oldrec_     quick_report_tab%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_QUICK_REPORT;
   
   FOR rec_ IN get_quick_report_header(xml_) LOOP
      IF Is_ACP_Supported_Type(rec_.QR_TYPE) != 'TRUE' THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,Language_SYS.Translate_Constant(lu_name_,'INVALID_SQL_REPORT_TYPE: Error: Quick reports of Type SQL are allowed',Fnd_Session_API.Get_Language,rec_.qr_type),Fnd_Session_API.Get_Language,rec_.qr_type), TRUE); 
         CONTINUE;
      END IF;
         
      status_text_:= Validate_SQL_Expression___(sql_status_,rec_.SQL_EXPRESSION,TRUE);
      IF sql_status_ = 'INVALID' THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details,status_text_, TRUE);
      ELSIF sql_status_ = 'PARTIALLY_VALID' THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
         Utility_SYS.Append_Text_Line(info_.validation_details,status_text_, TRUE);
      END IF;  
      
      import_rec_ := NULL;
      import_rec_.quick_report_id := rec_.QUICK_REPORT_ID;
      import_rec_.description := rec_.DESCRIPTION;
      import_rec_.sql_expression := rec_.SQL_EXPRESSION;
      import_rec_.comments := rec_.COMMENTS;
      import_rec_.category_id := rec_.CATEGORY_ID;
      import_rec_.file_name := rec_.FILE_NAME;
      import_rec_.qr_type := rec_.QR_TYPE;
      --import_rec_.po_id := rec_.PO_ID;
      import_rec_.query := rec_.QUERY;
      import_rec_.row_type := rec_.ROW_TYPE;
      import_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
      import_rec_.rowkey := rec_.ROWKEY;
      
      oldrec_ := Get_Object_By_Keys___(import_rec_.quick_report_id);
      
      IF oldrec_.rowkey IS NULL THEN
         --Item Exists
         info_.exists := 'FALSE';
         info_.current_published := 'FALSE';
         indrec_ := Get_Indicator_Rec___(import_rec_);
         -- Category ID doesn't need to be validated. If missing, category will be created when inserting
         indrec_.category_id := FALSE;
         Check_Insert___(import_rec_, indrec_, attr_);
         
      ELSIF oldrec_.rowkey <> import_rec_.rowkey THEN
         --Another quick report exists with the same name but different rowkey
         info_.exists := 'TRUE';
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'QUICKREPORTEXIST: Error: Another Quick report with the same name ":P1" exists', Fnd_Session_API.Get_Language, oldrec_.quick_report_id), TRUE);
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      ELSE
         --Same quick report exists
         info_.exists := 'TRUE';
         info_.current_description := oldrec_.description;
         info_.current_last_modified_date := oldrec_.definition_modified_date;
         info_.last_modified_date   := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         
         App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, oldrec_.rowkey);
         
         IF (import_rec_.definition_modified_date <> oldrec_.definition_modified_date) THEN
            import_date_:= App_Config_Package_API.Get_Package_Imported_Date(oldrec_.rowkey); 
            IF import_date_ IS NOT NULL AND nvl(oldrec_.definition_modified_date,Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten',Fnd_Session_API.Get_Language), TRUE); 
            END IF;
         END IF;
      END IF;
   END LOOP;
   
   -- If no errors were found, this will set the item to validated
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
END Validate_Import;


PROCEDURE Get_Deployment_Object_Names (
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,   
   in_xml_      IN     CLOB)
IS
   count_ NUMBER;
   xml_ Xmltype := Xmltype(in_xml_);
BEGIN
   FOR rec_ IN get_quick_report_header(xml_) LOOP
      count_ := dep_objects_.COUNT + 1;
      dep_objects_(count_).name := UPPER(rec_.QUICK_REPORT_ID);
      dep_objects_(count_).item_type := 'QUICK_REPORT';
      dep_objects_(count_).object_name := rec_.PO_ID;
      dep_objects_(count_).object_type := 'PRES_OBJECT'; 
   END LOOP;
END Get_Deployment_Object_Names;

FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ quick_report_tab.definition_modified_date%TYPE;
BEGIN
   SELECT definition_modified_date INTO definition_modified_date_
   FROM quick_report_tab
   WHERE rowkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;


PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN  CLOB)
IS
   import_rec_ quick_report_tab%ROWTYPE;
   objkey_ VARCHAR2(100);
   xml_ Xmltype := Xmltype(in_xml_);
   
   -- adds the carriage return (CHR(13)) dropped during CLOB to XML conversion
   FUNCTION Include_Carriage_Return___ (in_clob_ IN CLOB) RETURN CLOB
   IS 
   BEGIN
      RETURN REPLACE(in_clob_,chr(10), chr(13)||chr(10));
   END Include_Carriage_Return___;
BEGIN
   identical_ := FALSE;
   
   FOR rec_ IN get_quick_report_header(xml_) LOOP
      IF Is_ACP_Supported_Type(rec_.QR_TYPE) != 'TRUE' THEN
         Error_SYS.System_General(Language_SYS.Translate_Constant(lu_name_,'INVALID_REPORT_TYPE: Error: Quick reports of type :P1 are not allowed',Fnd_Session_API.Get_Language, rec_.QR_TYPE));
      END IF;
      
      objkey_ := Get_Objkey(rec_.QUICK_REPORT_ID);
      IF objkey_ IS NULL THEN
         import_rec_ := NULL;
         Prepare_New___(import_rec_);
         import_rec_.quick_report_id := rec_.QUICK_REPORT_ID;
         import_rec_.description := rec_.DESCRIPTION;
         import_rec_.sql_expression := Include_Carriage_Return___(rec_.SQL_EXPRESSION);
         import_rec_.comments := Include_Carriage_Return___(rec_.COMMENTS);
         import_rec_.file_name := rec_.FILE_NAME;
         import_rec_.qr_type := rec_.QR_TYPE;
         import_rec_.query := Get_Query_Value___(import_rec_.qr_type, rec_.QUERY);
         import_rec_.row_type := rec_.ROW_TYPE;
         import_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         import_rec_.rowkey := rec_.ROWKEY;
         
         Import_New___(import_rec_, rec_.CATEGORY_DESCRIPTION);
      ELSIF objkey_ <> rec_.rowkey THEN
         App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'QUICKREPORTEXIST: Error: Another Quick report with the same name ":P1" exists', Fnd_Session_API.Get_Language, rec_.quick_report_id));
         RETURN;
      ELSE
         import_rec_ := Lock_By_Keys_Nowait___(rec_.QUICK_REPORT_ID);
         IF (import_rec_.definition_modified_date <> to_date(rec_.definition_modified_date, Client_SYS.date_format_)) THEN
            identical_ := FALSE;
            import_rec_.quick_report_id := rec_.QUICK_REPORT_ID;
            import_rec_.description := rec_.DESCRIPTION;
            import_rec_.sql_expression := Include_Carriage_Return___(rec_.SQL_EXPRESSION);
            import_rec_.comments := Include_Carriage_Return___(rec_.COMMENTS);
            import_rec_.category_id := rec_.CATEGORY_ID;
            import_rec_.file_name := rec_.FILE_NAME;
            import_rec_.qr_type := rec_.QR_TYPE;
            import_rec_.query := Get_Query_Value___(import_rec_.qr_type, rec_.QUERY);
            import_rec_.row_type := rec_.ROW_TYPE;
            import_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
            import_rec_.rowkey := rec_.ROWKEY;
            Import_Modify___(import_rec_);            
         ELSE
            identical_ := TRUE;    
         END IF;
      END IF;         
      
   END LOOP;
   
   configuration_item_id_ := import_rec_.rowkey;
   name_ := App_Config_Util_API.Get_Item_Name(configuration_item_id_, App_Config_Item_Type_API.DB_QUICK_REPORT);
END Import;

PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT VARCHAR2,
   in_xml_                IN  CLOB)
IS
   is_identical_             BOOLEAN;
BEGIN
   Import(configuration_item_id_,name_,is_identical_,in_xml_);
   IF (is_identical_) THEN
      identical_ := 'TRUE';
   ELSE
      identical_ := 'FALSE';
   END IF;
END Import;

PROCEDURE Import_New___ (
   newrec_ IN OUT quick_report_tab%ROWTYPE,
   category_description_ VARCHAR2)
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   emptyrec_      quick_report_tab%ROWTYPE;
BEGIN
   indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
   
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   newrec_.po_id := Create_Presentation_Object___(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression,FALSE,TRUE);
   Client_SYS.Add_To_Attr('PO_ID', newrec_.po_id, attr_);
   
   -- Check common will handle the category using the description
   Client_SYS.Add_To_Attr('CATEGORY_DESCRIPTION', category_description_, attr_);
   
   Check_Insert___(newrec_, indrec_, attr_);
   Set_Server_Values___(newrec_);
   
   newrec_.rowversion := sysdate;
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO quick_report_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   Init_Report_Metadata(newrec_.quick_report_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Between_Str(Utility_SYS.Between_Str(sqlerrm, '(', ')'), '.', ')', 'FALSE');
      BEGIN
         IF (constraint_ = 'QUICK_REPORT_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'QUICK_REPORT_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
END Import_New___;

PROCEDURE Import_Modify___(
   newrec_   IN OUT NOCOPY quick_report_tab%ROWTYPE)
IS
   objversion_         VARCHAR2(100);
   po_id_              VARCHAR2(100);
   press_object_desc_  VARCHAR2(200);
   attr_               VARCHAR2(32000);
   indrec_             Indicator_rec;
   oldrec_             quick_report_tab%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(newrec_.quick_report_id);
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);

   IF nvl(oldrec_.sql_expression, ' ') != nvl(newrec_.sql_expression, ' ') THEN
      -- The presentation object information will have to be recreated in this case.
      newrec_.po_id := Create_Presentation_Object___(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression, TRUE,TRUE);
   ELSIF (oldrec_.description != newrec_.description)  THEN
      -- Get the Po_id from quick_report_id.
      -- Update the Description from the Po_id
      press_object_desc_ := 'Quick Report - '||newrec_.description;
      po_id_ := Get_Po_Id(newrec_.quick_report_id);
      Pres_Object_Description_Api.Modify_Description(po_id_,'en',press_object_desc_);
   END IF;
   
   UPDATE quick_report_tab
      SET ROW = newrec_
    WHERE quick_report_id = newrec_.quick_report_id;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   Init_Report_Metadata(newrec_.quick_report_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Between_Str(Utility_SYS.Between_Str(sqlerrm, '(', ')'), '.', ')', 'FALSE');
      BEGIN
         IF (constraint_ = 'QUICK_REPORT_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Quick_Report_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'QUICK_REPORT_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
END Import_Modify___;
   
PROCEDURE Set_Server_Values___ (
   newrec_ IN OUT quick_report_tab%ROWTYPE )
IS
BEGIN
   IF newrec_.definition_modified_date IS NULL THEN
      newrec_.definition_modified_date := sysdate;
   END IF;
END Set_Server_Values___;

@Override
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   -- definition_modified_date must be only updated to sysdate
   -- when changes are done through the client not when importing
   IF action_ = 'DO' THEN
      Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);

END Modify__;


FUNCTION Get_Projection_Version__ RETURN VARCHAR2
IS
BEGIN
   RETURN Aurena_Report_Metadata_SYS.Get_Projection_Version__;
END Get_Projection_Version__;

FUNCTION Is_ACP_Supported_Type(
   qr_type_ VARCHAR2
   ) RETURN VARCHAR2
IS
BEGIN
   IF qr_type_ IN ('SQL','QUERY') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
   
END Is_ACP_Supported_Type;

PROCEDURE Validate_Existing(
   info_               OUT App_Config_Util_API.AppConfigItemInfo,
   rowkey_             IN  app_config_package_item_tab.configuration_item_id%TYPE,
   version_time_stamp_ IN  DATE)  
IS
   rec_ quick_report_tab%ROWTYPE;
BEGIN
   Rowkey_Exist(rowkey_);
      
   rec_ := Get_Key_By_Rowkey(rowkey_);
   rec_ := Get_Object_By_Keys___(rec_.quick_report_id);     
   
   info_.name                 := rec_.description;
   info_.item_type            := App_Config_Item_Type_API.DB_QUICK_REPORT;
   info_.validation_result    := App_Config_Util_API.Status_Unknown; 
   info_.validation_details   := NULL; 
   info_.current_package      := App_Config_Package_API.Get_Item_Package_Name(rec_.rowkey);
   info_.last_modified_date   := rec_.definition_modified_date;
   info_.current_published    := 'TRUE';
   
   IF Is_ACP_Supported_Type(rec_.QR_TYPE) != 'TRUE' THEN
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,Language_SYS.Translate_Constant(lu_name_,'INVALID_SQL_REPORT_TYPE: Error: Quick reports of Type SQL are allowed',Fnd_Session_API.Get_Language,rec_.qr_type),Fnd_Session_API.Get_Language,rec_.qr_type), TRUE); 
   END IF;
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
   END Validate_Existing;
   
FUNCTION Is_Qr_Po_Granted_For_User(
   quick_report_id_         IN NUMBER,
   identity_                IN VARCHAR2) RETURN VARCHAR2
IS
   fnd_user_ Fnd_User_API.Public_Rec;
   identity_forweb_ VARCHAR2(2000);
BEGIN
   --check if CRYSTL component is installed
   IF ((Quick_Report_API.Get_Qr_Type_Db(quick_report_id_) = 'CR') AND (Component_CRYSTL_SYS.INSTALLED != TRUE)) THEN
         RETURN ('FALSE');
   END IF;   
   --get fnd user by identity
   fnd_user_ := Fnd_User_API.Get(identity_);
   
   -- if user exist use it, otherwise get the identity by passing web user 
   IF (fnd_user_.identity IS NOT NULL) THEN
      RETURN Security_SYS.Is_Pres_Object_Granted_User(Quick_Report_API.Get_Po_Id(quick_report_id_), identity_);
   ELSE 
      identity_forweb_ := Fnd_User_API.Get_Web_User_Identity_(identity_);
      RETURN Security_SYS.Is_Pres_Object_Granted_User(Quick_Report_API.Get_Po_Id(quick_report_id_), identity_forweb_);
   END IF;
   
END Is_Qr_Po_Granted_For_User;

FUNCTION Get_Url(   
   quick_report_id_  IN NUMBER) RETURN VARCHAR2
IS
   ssrs_command_  VARCHAR2(50) := AMPERSAND || 'rs:Command=Render' || AMPERSAND || 'rs:Embed=true';
   rec_           quick_report_tab%ROWTYPE := Get_Object_By_Keys___(quick_report_id_);
   base_url_      VARCHAR2(500) := Fnd_Setting_API.Get_Value('URL_SSRS_SERVER');
BEGIN
   IF(base_url_ NOT LIKE '%/') THEN
      base_url_ := base_url_ || '/';
   END IF;
   IF((rec_.qr_type = Quick_Report_Type_API.DB_MS_REPORT AND
       rec_.file_name NOT LIKE '/%') OR      
      (rec_.qr_type = Quick_Report_Type_API.DB_DASHBOARD AND
       UPPER(base_url_) NOT LIKE 'HTTP://' AND
       UPPER(base_url_) NOT LIKE 'HTTPS://' AND
       rec_.file_name NOT LIKE '/%')) THEN
      rec_.file_name := '/' || rec_.file_name;
   END IF;
   IF(rec_.qr_type = Quick_Report_Type_API.DB_MS_REPORT) THEN
      RETURN base_url_ ||'ReportServer/Pages/ReportViewer.aspx?/Published Reports' || rec_.file_name || ssrs_command_;
   ELSIF(rec_.qr_type = Quick_Report_Type_API.DB_DASHBOARD) THEN
      IF(UPPER(base_url_) LIKE 'HTTP://' OR
         UPPER(base_url_) LIKE 'HTTPS://') THEN
         RETURN rec_.file_name;
      ELSE
         RETURN base_url_ ||'ReportServer/Pages/ReportViewer.aspx?/Dashboards' || rec_.file_name || ssrs_command_;
      END IF;
   ELSE
      RETURN rec_.file_name;
   END IF;
END Get_Url;

FUNCTION Get_Projection_Name(
  quick_report_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Aurena_Report_Metadata_SYS.Get_Projection_Name__(quick_report_id_, 'SQL');
END Get_Projection_Name;

PROCEDURE Init_Reports_Metadata(
   mode_ IN VARCHAR2 DEFAULT '')
IS
BEGIN
   Aurena_Report_Metadata_SYS.Initialize_Quick_Reports__(mode_);
END Init_Reports_Metadata;

PROCEDURE Init_Report_Metadata(
   quick_report_id_ IN VARCHAR2,
   remove_          IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   Aurena_Report_Metadata_SYS.Initialize_Quick_Report__(quick_report_id_, remove_);
END Init_Report_Metadata;
