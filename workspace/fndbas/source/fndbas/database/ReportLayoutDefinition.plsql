-----------------------------------------------------------------------------
--
--  Logical unit: ReportLayoutDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980901  MANY  Created
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990525  MANY  Changes in method Enumerate_Layout for Project Orion (ToDo #3375).
--  001025  BVLI  Added Layout options and procedure enumerate_layout_options.
--                Orion II (ToDo #3951)
--  001205  ROOD  Added attribute paper_format. Modified method Enumerate_Layout
--                to consider users default paper format. Updated template (ToDo#4056).
--  020217  ROOD  Added method Get_Default_Layout (ToDo#4056).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020628  ROOD  Added insertion of not null columns in Add_Layout (Bug#31343).
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020829  ROOD  Added more parameters in Add_Layout (Bug#32301).
--  020925  ROOD  Increased length of local variable in Enumerate_Layout (Bug#31844).
--  021014  ROOD  Modifications in Enumerate_Layout (GLOB12).
--                Corrected cursor in Enumerate_Layout_Options.
--  021020  ROOD  Added enumerate_order (GLOB12).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030404  ROOD  Corrected where-statement in Enumerate_Layout_Options (Bug#32656).
--  030506  ROOD  Added a default order_by in Enumerate_Layout to handle possible
--                sort order problems with Oracle Cost Based Optimizer (Bug#37050).
--  030704  RAKU  Added check so design time layouts can't have its layout_type modifyed (ToDo#4276).
--  030815  RAKU  Corrected cursor in Get_Layout_Type.
--  031008  ROOD  Added method Get_Translated_Layout_Title (Bug#39279).
--  040205  RAKU  Added check for default_layout_type in Get_Default_Layout and Enumerate_Layout. (Bug#41529)
--- 040209  RAKU  Modifyed Get_Default_Layout. (Bug#41529)
--  040311  MAOL  Modified Get_Default_Layout to only include layout that are set to in use. (Bug#43277)
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040924  DOZE  Changed Enumerate_Layout to take result_key parameter. (Bug#46731)
--  041216  DOZE  Changed Enumerate_Layout (Bug#48201)
--  050328  NiWi  Added new default parameter(layout_type_) to Add_Layout
--  050506  Bamalk Modified method Get_Default_Layout <Bug#48266>
--  060214  UTGULK Moved Check_Layout___ from Archive, print_job_contents and Report_sys LUs.
--  060717  RaRu   Checked create_result_set = 'TRUE' instead of cheking whether data available in the report 
--                 table in Enumerate_Layout() (Bug55053).
--  070718  UTGULK Extended length of attribute order_by (Bug#66686).
--  080305  JOWISE Added column Prevent_Overwrite to be able to lock layout
--  120117  CHAALK Added Get_Layout_Type_Encode method (Bug ID 100492)
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  120215  LAKRLK RDTERUNTIME-1846
-- --------------------------------------------------------------------------
-- 130509   CHAALK Feature to change the layout order of a report (Bug ID 109681
--  140129  AsiWLK   Merged LCS-111925
--  191002  PABNLK  TSMI-6: 'Report_Layout_Def_Modify' wrapper method created.
--  191003  pabnlk  TSMI-6: 'Add_Report_Layout_Definition' wrapper method created.
--  191014  pabnlk  TSMI-38 Fixed a bug in 'Add_Report_Layout_Definition' and 'Report_Layout_Def_Modify'.
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1):= Client_SYS.field_separator_;

record_separator_ CONSTANT VARCHAR2(1):= Client_SYS.record_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Enumerate_Order___
--   Returns the next enumerate order for a report. To be used internally in
--   methods that are inserting new report layouts.
FUNCTION Get_Next_Enumerate_Order___ (
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   next_enumerate_order_ NUMBER;
   CURSOR get_next IS
      SELECT nvl(MAX(enumerate_order), 0) + 1
      FROM REPORT_SYS_LAYOUT_TAB
      WHERE report_id = report_id_;
BEGIN
   OPEN get_next;
   FETCH get_next INTO next_enumerate_order_;
   CLOSE get_next;
   RETURN next_enumerate_order_;
END Get_Next_Enumerate_Order___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DESIGN_TIME', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('IN_USE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('LAYOUT_TYPE', Report_Layout_Type_API.Decode('BUILDER'), attr_);
   Client_SYS.Add_To_Attr('PREVENT_OVERWRITE', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPORT_SYS_LAYOUT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.enumerate_order := Get_Next_Enumerate_Order___(newrec_.report_id);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN REPORT_SYS_LAYOUT_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.design_time = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'DESIGNDEL: Designtime layouts can only be disabled, not deleted');
   END IF;
   super(remrec_);
END Check_Delete___;



@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     report_sys_layout_tab%ROWTYPE,
   newrec_ IN OUT report_sys_layout_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF ( ( newrec_.design_time = 'TRUE' ) AND (oldrec_.layout_type IS NOT NULL) AND ( oldrec_.layout_type != newrec_.layout_type ) ) THEN
      Error_SYS.Record_General(lu_name_, 'LAYOUT_TYPE_ERR: The Layout Type can not be changed for layouts supplied with the report.' );
   END IF;
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     report_sys_layout_tab%ROWTYPE,
   newrec_ IN OUT report_sys_layout_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.design_time NOT IN ('TRUE', 'FALSE')) THEN
      Error_SYS.Item_Format(lu_name_, 'DESIGN_TIME', newrec_.design_time);
   END IF;
   IF (newrec_.in_use NOT IN ('TRUE', 'FALSE')) THEN
      Error_SYS.Item_Format(lu_name_, 'IN_USE', newrec_.in_use);
   END IF;
   IF (newrec_.prevent_overwrite NOT IN ('TRUE', 'FALSE')) THEN
      Error_SYS.Item_Format(lu_name_, 'PREVENT_OVERWRITE', newrec_.prevent_overwrite);
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Generate_FileName_For_Export__(
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   file_name_ VARCHAR2(100);
BEGIN
   IF report_id_ IS NULL THEN
      file_name_ := NULL;
   ELSE
      file_name_ := report_id_ || '.xml';
   END IF;
   RETURN file_name_;
END Generate_FileName_For_Export__;

FUNCTION Generate_XML__ (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2) RETURN BLOB
IS
   report_layout_rec_               Report_Layout_Definition_API.Public_Rec;
   xml_type_                        XMLTYPE;
   file_data_                       BLOB;
   layout_title_                    VARCHAR2(50);
BEGIN
   Report_Layout_Definition_API.Get_Layout_Title(report_id_,layout_name_,layout_title_);
   IF report_id_ IS NULL THEN
      file_data_ := NULL; 
   ELSE  
      report_layout_rec_ := Report_Layout_Definition_API.Get(report_id_,layout_name_);
         

         SELECT xmlconcat(xml_type_ , xmlelement("REPORT_LAYOUT_DEFINITION", 
                                          xmlattributes('queried' as "state",  
                                               report_layout_rec_."rowid" as "OBJ_ID",  
                                               report_layout_rec_.rowversion as "OBJ_VERSION"),
                                          xmlconcat(   
                                              xmlelement("REPORT_ID",            xmlattributes('Text'   as "datatype"), report_id_),
                                              xmlelement("LAYOUT_NAME",          xmlattributes('Text'   as "datatype"), layout_name_),
                                              xmlelement("LAYOUT_TITLE",         xmlattributes('Text'   as "datatype"), layout_title_),
                                              xmlelement("PAPER_FORMAT",         xmlattributes('Enum'   as "datatype"), report_layout_rec_.paper_format),
                                              xmlelement("LAYOUT_TYPE",          xmlattributes('Enum'   as "datatype"), Report_Layout_Definition_API.Get_Layout_Type(report_id_,layout_name_)),
                                              xmlelement("PREVENT_OVERWRITE",    xmlattributes('Text'   as "datatype"), Report_Layout_Definition_API.Get_Prevent_Overwrite(report_id_, layout_name_))
                                          )
                          )
               )
         INTO xml_type_
         FROM dual;

      SELECT xmlelement("REPORT_LAYOUT_DEFINITION_LIST", xml_type_)
      INTO xml_type_
      FROM dual;

      file_data_ := xml_type_.getBlobVal(873);
   END IF;
   RETURN file_data_;
END Generate_XML__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Layout_Type (
   report_id_ IN VARCHAR2,
   layout_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- The value in layout_name can be in mixed case why this
   -- workaround making UPPER in the cursor is made to avoid
   -- 'no records found' errors.
   temp_ REPORT_SYS_LAYOUT_TAB.layout_type%TYPE;
   CURSOR get_attr IS
      SELECT layout_type
      FROM   REPORT_SYS_LAYOUT_TAB
      WHERE  report_id = report_id_
       AND   UPPER(layout_name) = UPPER(layout_name_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Report_Layout_Type_API.Decode(temp_);
END Get_Layout_Type;


@UncheckedAccess
FUNCTION Get_Layout_Type_Encode (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- The value in layout_name can be in mixed case why this
   -- workaround making UPPER in the cursor is made to avoid
   -- 'no records found' errors.
   temp_ REPORT_SYS_LAYOUT_TAB.layout_type%TYPE;
   CURSOR get_attr IS
      SELECT layout_type
      FROM REPORT_SYS_LAYOUT_TAB
      WHERE report_id = report_id_
      AND   UPPER(layout_name) = UPPER(layout_name_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Layout_Type_Encode;

@UncheckedAccess
FUNCTION Check_Definition_Exist (
   report_id_ IN VARCHAR2,
   layout_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(report_id_,layout_name_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Definition_Exist;

PROCEDURE Add_Layout (
   report_id_      IN VARCHAR2,
   layout_name_    IN VARCHAR2,
   layout_title_   IN VARCHAR2 DEFAULT NULL,
   order_by_       IN VARCHAR2 DEFAULT NULL,
   paper_format_   IN VARCHAR2 DEFAULT 'A4',
   in_use_         IN VARCHAR2 DEFAULT 'TRUE',
   layout_type_    IN VARCHAR2 DEFAULT 'BUILDER',
   design_time_    IN VARCHAR2 DEFAULT 'FALSE')
IS
   next_enumerate_order_ NUMBER := Get_Next_Enumerate_Order___(report_id_);
BEGIN
   Report_Definition_API.Exist(report_id_);

   INSERT INTO REPORT_SYS_LAYOUT_TAB (
      report_id,
      layout_name,
      layout_title,
      order_by,
      enumerate_order,
      design_time,
      in_use,
      layout_type,
      paper_format,
      prevent_overwrite,
      rowversion
      ) VALUES (
      report_id_,
      layout_name_,
      layout_title_,
      order_by_,
      next_enumerate_order_,
      design_time_,
      in_use_,
      layout_type_,
      paper_format_,
      'FALSE',
      sysdate );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Add_Layout;


PROCEDURE Remove_Layout (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM REPORT_SYS_LAYOUT_TAB
      WHERE report_id = report_id_
      AND   layout_name = layout_name_;
END Remove_Layout;


PROCEDURE Enumerate_Layout (
   list_      OUT VARCHAR2,
   report_id_ IN  VARCHAR2,
   result_key_ IN NUMBER DEFAULT NULL )
IS
   temp_                 VARCHAR2(32000);
   logical_unit_         VARCHAR2(30);
   default_paper_format_ VARCHAR2(20) := Report_SYS.Get_Default_Paper_Format;
   report_rec_           Report_Result_Gen_Config_API.Public_Rec := Report_Result_Gen_Config_API.Get(report_id_);
   xml_data_             NUMBER;
   rb_data_              NUMBER;
   output_extension_     VARCHAR2(5);

   CURSOR get_default_all IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   (paper_format_db = default_paper_format_ OR
             default_paper_format_ = '*')
      ORDER BY enumerate_order;

   CURSOR get_default_defined IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   (paper_format_db = default_paper_format_ OR
             default_paper_format_ = '*')
      AND   layout_type_db = report_rec_.default_layout_type
      ORDER BY enumerate_order;

   CURSOR get_default_defined_rest IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   (paper_format_db = default_paper_format_ OR
             default_paper_format_ = '*')
      AND   layout_type_db != report_rec_.default_layout_type
      ORDER BY enumerate_order;

   CURSOR get_non_default_all IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   paper_format_db != default_paper_format_
      AND   default_paper_format_ != '*'
      ORDER BY enumerate_order;

   CURSOR get_non_default_defined IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   paper_format_db != default_paper_format_
      AND   default_paper_format_ != '*'
      AND   layout_type_db = report_rec_.default_layout_type
      ORDER BY enumerate_order;

   CURSOR get_non_default_rest IS
      SELECT layout_name, layout_title, paper_format, nvl(order_by, 'ROW_NO') order_by, layout_type_db
      FROM REPORT_LAYOUT_DEFINITION
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND   paper_format_db != default_paper_format_
      AND   default_paper_format_ != '*'
      AND   layout_type_db != report_rec_.default_layout_type
      ORDER BY enumerate_order;

      CURSOR check_xml_data IS
        SELECT COUNT(*)
        FROM XML_REPORT_DATA
        WHERE result_key = result_key_;

      FUNCTION Get_Extension___(
                  report_id_ IN VARCHAR2,
                  layout_name_ IN VARCHAR2) RETURN VARCHAR2
      IS
         extension_ VARCHAR2(5);
         error_parsing_xml EXCEPTION;
         PRAGMA EXCEPTION_INIT(error_parsing_xml, -31011);
         
         CURSOR get_extension IS
            SELECT extractvalue(XMLType(t.layout,871),'report-layout/properties/output-extension')
            FROM report_layout_tab t, report_sys_layout_tab s
            where t.report_id = report_id_
            and t.layout_name = layout_name_
            and t.report_id = s.report_id
            and t.layout_name = s.layout_name
            and s.layout_type = 'OTHER';
      BEGIN
         OPEN get_extension;
         FETCH get_extension INTO extension_;
         CLOSE get_extension;
         IF extension_ IS NULL THEN
            extension_ := 'pdf';
         END IF;
         RETURN extension_;
      EXCEPTION
         WHEN error_parsing_xml THEN
             Error_SYS.Appl_General(lu_name_,
                                    'XML_PARSE_ERROR: The Plugin layout :P1 of the report :P2 is not a properly formatted XML document.',
                                    layout_name_,
                                    report_id_);
      END Get_Extension___;
      
      PROCEDURE Add_Layout_To_List___ (
         logical_unit_ IN VARCHAR2,
         report_id_ IN VARCHAR2,
         layout_def_ IN get_default_all%ROWTYPE,
         report_list_ IN OUT VARCHAR2)
      IS
         layout_title_         VARCHAR2(255); 
      BEGIN
         layout_title_ := substr(Language_SYS.Translate_Report_Layout_(logical_unit_, report_id_, layout_def_.layout_name, layout_def_.layout_title)||' ('||layout_def_.paper_format||')', 1, 255);
         
         output_extension_ := Get_Extension___(report_id_,layout_def_.layout_name);
         
         report_list_ := report_list_ || layout_def_.layout_name || field_separator_ || layout_title_ || field_separator_ || layout_def_.order_by || field_separator_ || layout_def_.layout_type_db || field_separator_ || output_extension_ || record_separator_;
      END Add_Layout_To_List___;
      
BEGIN
   Report_Definition_API.Exist(report_id_);
   logical_unit_ := Report_Definition_API.Get_Lu_Name(report_id_);

   IF (result_key_ IS NOT NULL) THEN
      OPEN check_xml_data;
      FETCH check_xml_data INTO xml_data_;
      CLOSE check_xml_data;

      IF NVL(report_rec_.create_result_set,'TRUE') = 'TRUE' THEN
        rb_data_ :=1;
      END IF;

   ELSE
      xml_data_ := 1;
      rb_data_ := 1;
   END IF;

   IF (xml_data_ = 0) AND (rb_data_ = 0) THEN
      xml_data_ := 1;
      rb_data_ := 1;
   END IF;

   IF report_rec_.default_layout_type IS NULL THEN
      -- No default layout type is defined. Fetch all with default paper format first.
      FOR rec_ IN get_default_all LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

      -- Then add the layouts with other paper formats to the list
      FOR rec_ IN get_non_default_all LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

   ELSE
      -- A default layout type is defined.

      -- 1. Fetch all with default paper format and the default layout type.
      FOR rec_ IN get_default_defined LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

      -- 2. Fetch all with default paper format and the remaining layout types.
      FOR rec_ IN get_default_defined_rest LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

      -- 3. Then add the layouts with other paper formats and the default layout type.
      FOR rec_ IN get_non_default_defined LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

      -- 4. Then add the layouts with other paper formats and the remaining layout types.
      FOR rec_ IN get_non_default_rest LOOP
         IF (NOT ((xml_data_ = 0) AND (rec_.layout_type_db = 'DESIGNER'))) AND
             (NOT ((rb_data_ =0) AND (rec_.layout_type_db = 'BUILDER'))) THEN
            Add_Layout_To_List___(logical_unit_, report_id_, rec_, temp_);
         END IF;
      END LOOP;

   END IF;

   -- Return the resulting list
   list_ := temp_;
END Enumerate_Layout;


-- Get_Default_Layout
--   Returns the default layout for a report id. What layout is choosen
--   depends on the paper format settings for the Foundation1 user aswell
--   as the order of the layouts programmed for this report.
@UncheckedAccess
FUNCTION Get_Default_Layout (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   default_paper_format_ VARCHAR2(20) := Report_SYS.Get_Default_Paper_Format;
   rec_                  Report_Result_Gen_Config_API.Public_Rec := Report_Result_Gen_Config_API.Get(report_id_);
   temp_                 VARCHAR2(50);

   CURSOR get_default IS
      SELECT layout_name
      FROM report_sys_layout_tab
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND (paper_format = default_paper_format_ OR
           default_paper_format_ = '*')
      AND layout_type = rec_.default_layout_type
      ORDER BY enumerate_order;

   CURSOR get_default2 IS
      SELECT layout_name
      FROM report_sys_layout_tab
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
      AND (paper_format = default_paper_format_ OR
           default_paper_format_ = '*')
      ORDER BY enumerate_order;

   CURSOR get_default3 IS
      SELECT layout_name
      FROM report_sys_layout_tab
      WHERE report_id = report_id_
      AND   in_use = 'TRUE'
	   ORDER BY enumerate_order;

BEGIN
   -- Fetch default using the default layout type (if defined) first
   IF rec_.default_layout_type IS NOT NULL THEN
      OPEN get_default;
      FETCH get_default INTO temp_;
      CLOSE get_default;
   END IF;

   -- IF the default layout type was not defined or no layout was found, get the first available layout
   -- with the correct paper format.
   IF temp_ IS NULL THEN
      OPEN get_default2;
      FETCH get_default2 INTO temp_;
      CLOSE get_default2;
   END IF;

   -- IF the default layout type was not defined or no layout was found and layout for the correct
   -- paper type is not 'In Use' then return the first available layout with 'in use' flag.

   IF temp_ IS NULL THEN
      OPEN get_default3;
      FETCH get_default3 INTO temp_;
      CLOSE get_default3;
   END IF;

   RETURN temp_;
END Get_Default_Layout;


PROCEDURE Get_Translated_Layout_Title (
   layout_title_ OUT VARCHAR2,
   report_id_    IN  VARCHAR2,
   layout_name_  IN  VARCHAR2 )
IS
   -- The value in layout_name can be in mixed case why this
   -- workaround making UPPER in the cursor is made to avoid
   -- 'no records found' errors.
   prog_title_   REPORT_SYS_LAYOUT_TAB.layout_title%TYPE;
   logical_unit_ VARCHAR2(50);
   CURSOR get_prog_title IS
      SELECT layout_title
      FROM REPORT_SYS_LAYOUT_TAB
      WHERE report_id = report_id_
      AND   upper(layout_name) = upper(layout_name_);
BEGIN
   OPEN get_prog_title;
   FETCH get_prog_title INTO prog_title_;
   IF get_prog_title%NOTFOUND THEN
      CLOSE get_prog_title;
      Error_SYS.Appl_General(lu_name_, 'LAYERR: Layout [:P1] does not exist.', layout_name_);
   ELSE
      CLOSE get_prog_title;
      logical_unit_ := Report_Definition_API.Get_Lu_Name(report_id_);
      layout_title_ := Language_SYS.Translate_Report_Layout_(logical_unit_, report_id_, layout_name_, prog_title_);
   END IF;
END Get_Translated_Layout_Title;


@UncheckedAccess
PROCEDURE Enumerate_Layout_Options (
   options_     OUT VARCHAR2,
   report_id_   IN  VARCHAR2,
   layout_name_ IN  VARCHAR2 )
IS
   
BEGIN
   Error_SYS.Appl_General(lu_name_, 'DEPENUMLAYOPT: Deprecated Enumeration! Layout options are no longer supported');
END Enumerate_Layout_Options;


@UncheckedAccess
PROCEDURE Check_Layout (
   layout_name_ IN OUT VARCHAR2 ) 
IS
   new_layout_ VARCHAR2(2000);
   CURSOR chklayout IS
      SELECT layout_name 
      FROM report_sys_layout_tab
      WHERE layout_name = layout_name_;
   CURSOR newlayout IS
      SELECT layout_name 
      FROM report_sys_layout_tab
      WHERE UPPER(layout_name) = UPPER(layout_name_);
BEGIN
   OPEN chklayout;
   FETCH chklayout INTO new_layout_;
   IF chklayout%NOTFOUND THEN
      OPEN newlayout;
      FETCH newlayout INTO new_layout_;
      IF newlayout%FOUND THEN
         layout_name_ := new_layout_;
      END IF;
      CLOSE newlayout;
   END IF;
   CLOSE chklayout;
END Check_Layout;

PROCEDURE Report_Layout_Def_Modify (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   attr_       IN VARCHAR2)
IS
   info_             VARCHAR2(2000);
   new_attr_         VARCHAR2(2000);
   new_objversion_   VARCHAR2(100);
BEGIN
   new_attr_       := attr_;
   new_objversion_ := objversion_;
   Modify__(info_, objid_, new_objversion_, new_attr_, 'DO');
END Report_Layout_Def_Modify;


PROCEDURE Add_Report_Layout_Definition (
   attr_ IN VARCHAR2)
IS
   info_         VARCHAR2(100);
   objversion_   VARCHAR2(100);
   objid_        VARCHAR2(100);
   new_attr_     VARCHAR2(32000);
BEGIN
   new_attr_       := attr_;
   New__(info_, objid_, objversion_, new_attr_, 'DO');
END Add_Report_Layout_Definition;

PROCEDURE Get_Layout_Title (
   report_id_     IN VARCHAR2,
   layout_name_   IN VARCHAR2,
   layout_title_  OUT VARCHAR2)
IS 
   layout_count_  NUMBER;
   
   CURSOR layout_count IS
   SELECT count(layout_name)
      INTO layout_count_
      FROM report_sys_layout_tab
      WHERE UPPER(layout_name) = UPPER(layout_name_);   
   
   CURSOR layout_title IS
      SELECT layout_title 
      FROM report_sys_layout_tab
      WHERE UPPER(layout_name) = UPPER(layout_name_)
      AND UPPER(report_id) = UPPER(report_id_);
      
   CURSOR layout_title_from_name IS
      SELECT layout_title 
      FROM report_sys_layout_tab
      WHERE UPPER(layout_name) = UPPER(layout_name_);

BEGIN
   IF (report_id_ IS NOT NULL) THEN
      OPEN layout_title;
      FETCH layout_title INTO layout_title_;
      CLOSE layout_title;
   ELSE
      OPEN layout_count;
      FETCH layout_count INTO layout_count_;
      CLOSE layout_count;
      IF (layout_count_ = 1) THEN
         OPEN layout_title_from_name;
         FETCH layout_title_from_name INTO layout_title_;
         CLOSE layout_title_from_name;
      ELSE
         layout_title_ := NULL;
      END IF;
   END IF;
END Get_Layout_Title;

PROCEDURE Modify_Layout_Definition (
   report_id_         IN VARCHAR2,
   layout_name_       IN VARCHAR2,
   layout_title_      IN VARCHAR2,
   paper_format_      IN VARCHAR2,
   ret_value_         OUT VARCHAR2,
   paper_format_db_   IN VARCHAR2 DEFAULT NULL) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   
BEGIN
   
   IF (Report_Layout_Definition_API.Exists(report_id_,layout_name_)) THEN
      IF (UPPER(Get_Prevent_Overwrite(report_id_, layout_name_)) = 'TRUE') THEN
         ret_value_ := 'OVERWRITE';
      ELSE
         IF (layout_title_ IS NOT NULL) THEN
            Get_Id_Version_By_Keys___ (objid_,objversion_,report_id_,layout_name_);
            Client_SYS.Add_To_Attr('LAYOUT_TITLE',layout_title_,attr_);
            IF (paper_format_db_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr('PAPER_FORMAT_DB',paper_format_db_,attr_);
            ELSE   
               Client_SYS.Add_To_Attr('PAPER_FORMAT',paper_format_,attr_);
            END IF;
            Modify__(info_, objid_, objversion_,attr_, 'DO');
            ret_value_ := 'UPDATED';
         ELSE
            ret_value_ := 'LAYOUTNULL';
         END IF;
      END IF;
   ELSE
      ret_value_ := 'NOT_FOUND';
   END IF;  
END Modify_Layout_Definition;

FUNCTION Get_Prevent_Overwrite(
   report_id_      IN VARCHAR2,
   layout_name_    IN VARCHAR2) RETURN VARCHAR2
IS
   overwrite_ VARCHAR2(10) := 'FALSE';
BEGIN
   SELECT prevent_overwrite
      INTO overwrite_
      FROM report_sys_layout_tab
      WHERE UPPER(layout_name) = UPPER(layout_name_)
      AND   UPPER(report_id) = UPPER(report_id_);
   RETURN UPPER(overwrite_); 
END Get_Prevent_Overwrite;