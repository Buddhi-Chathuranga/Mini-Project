-----------------------------------------------------------------------------
--
--  Logical unit: AurenaReportMetadata
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190715  RAKUSE  Created. (TEUXXCC-1513)
--  200225  RAKUSE  Business Report projections gets prefixed with 'BR'. (TEAURENAFW-2024)
--  200901  MAABSE  Add proper projection description (TEZAUFW-267)
--  210419  RAKUSE  Added Quick Report projection handling (EXPFWCG-49).
--  211006  CHAALK  Aurena Order Report is not translated (OR21R2-401)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE report_col_def_rec IS RECORD
   (column_index              aurena_report_metadata_map_tab.column_index%TYPE,
    column_name               aurena_report_metadata_map_tab.column_name%TYPE,
    column_query              aurena_report_metadata_map_tab.column_query%TYPE,
    column_value              aurena_report_metadata_map_tab.column_value%TYPE,
    arg_definition            aurena_report_metadata_map_tab.arg_definition%TYPE);

TYPE report_col_def_table IS TABLE OF report_col_def_rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

report_template_name_      CONSTANT VARCHAR2(20) := 'OrderReportTemplate';
report_mode_operation1_    CONSTANT VARCHAR2(8)  := 'PLSQL1.1';
report_mode_operation2_    CONSTANT VARCHAR2(8)  := 'PLSQL1.2';
report_mode_business_      CONSTANT VARCHAR2(8)  := 'EXCEL1.0';
business_report_prefix_    CONSTANT VARCHAR2(2)  := 'BR';

qr_report_template_name_   CONSTANT VARCHAR2(20) := 'QuickReportTemplate';
qr_report_component_       CONSTANT VARCHAR2(6)  := 'CONFIG';
qr_projection_prefix_      CONSTANT VARCHAR2(12) := 'QuickReport';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Template_Initialized___ (
  client_name_           IN VARCHAR2,
  projection_name_       IN VARCHAR2,
  template_version_date_ IN DATE) RETURN BOOLEAN
IS
   version_date_ DATE := Get_Data_Version___(client_name_, projection_name_, FALSE);
BEGIN
   IF version_date_ IS NOT NULL AND
      version_date_ >= template_version_date_ THEN
      RETURN TRUE;   
   END IF;
   RETURN FALSE;
END Is_Template_Initialized___;

FUNCTION Get_Data_Version___(
   client_name_     IN VARCHAR2,
   projection_name_ IN VARCHAR2,
   get_maximum_     IN BOOLEAN) RETURN DATE 
IS
   out_version_date_    DATE;
   version_             VARCHAR2(50);
   version_date_        DATE;
BEGIN
   -- Client
   IF (client_name_ IS NOT NULL) THEN
      version_ := Model_Design_SYS.Get_Data_Version_(Model_Design_SYS.CLIENT_METADATA, Model_Design_SYS.ARTIFACT_CLIENT, client_name_);
      IF (version_ IS NOT NULL) THEN
         out_version_date_ := TO_DATE(version_, Client_SYS.date_format_);
      END IF;
   END IF;

   -- Projection (for client)  
   version_ := Model_Design_SYS.Get_Data_Version_(Model_Design_SYS.CLIENT_METADATA, Model_Design_SYS.ARTIFACT_PROJECTION, projection_name_);
   IF (version_ IS NOT NULL) THEN
      version_date_ := TO_DATE(version_, Client_SYS.date_format_);
      IF(get_maximum_) THEN
         out_version_date_ := GREATEST(NVL(out_version_date_, version_date_), version_date_);
      ELSE
         out_version_date_ := LEAST(NVL(out_version_date_, version_date_), version_date_);
      END IF;
   END IF;
   
   -- Projection (for server)  
   version_ := Model_Design_SYS.Get_Data_Version_(Model_Design_SYS.SERVER_METADATA, Model_Design_SYS.ARTIFACT_PROJECTION, projection_name_);
   IF (version_ IS NOT NULL) THEN
      version_date_ := TO_DATE(version_, Client_SYS.date_format_);      
      IF(get_maximum_) THEN
         out_version_date_ := GREATEST(NVL(out_version_date_, version_date_), version_date_);
      ELSE
         out_version_date_ := LEAST(NVL(out_version_date_, version_date_), version_date_);
      END IF;
   END IF;
   RETURN out_version_date_;   
END Get_Data_Version___;    


PROCEDURE Initialize_Template___ (
	report_id_ IN VARCHAR2)
IS
   cloned_name_      VARCHAR2(200);
   report_component_ VARCHAR2(10);
   report_title_     VARCHAR2(200);
   condition_        VARCHAR2(2000);
BEGIN
   Trace_SYS.Field('Aurena_Report_Metadata_SYS.Initialize_Template___. ReportId', report_id_);
   cloned_name_      := Get_Projection_Name__(report_id_);
   report_component_ := Report_Definition_API.Get_Module(report_id_);
   report_title_     := Report_Definition_API.Get_Report_Title(report_id_);
   
   Create_Arg_Definitions___(condition_, report_id_);

--   Trace_SYS.Field('cloned_name_', cloned_name_);
   --Clone projection and client template into new report   
   Model_Design_SYS.Clone_Template_Into_Model_(report_template_name_, cloned_name_, report_id_, report_component_, condition_);
   --Register created projection   
   Fnd_Projection_API.Create_Or_Replace(cloned_name_, description_ => 'Report - ' || report_title_, categories_ => 'Users', component_ => report_component_, plsql_package_ => 'ORDER_REPORT_TEMPLATE_SVC', layer_  => 'Core', api_class_ => 'Standard', deprecated_ => 'FALSE');
   Fnd_Proj_Entity_API.Create_Or_Replace(cloned_name_, 'ReportDefinition', 'R', 'REPORT_DEFINITION', 'ReportDefinition', 'Main', 'FALSE');
   Fnd_Proj_Entity_API.Create_Or_Replace(cloned_name_, 'VirtualOrderReport', 'CU', '', 'VirtualOrderReport', 'Main', 'FALSE');
   Fnd_Proj_Entity_API.Create_Or_Replace(cloned_name_, 'ReportLayoutDefinition', 'R', 'REPORT_LAYOUT_DEFINITION', 'ReportLayoutDefinition', 'Main', 'FALSE');
   Fnd_Proj_Entity_API.Create_Or_Replace(cloned_name_, 'LanguageCode', 'R', 'LANGUAGE_CODE', 'LanguageCode', 'Main', 'FALSE');
   Fnd_Proj_Entity_API.Create_Or_Replace(cloned_name_, 'LogicalPrinter', 'R', 'LOGICAL_PRINTER', 'LogicalPrinter', 'Main', 'FALSE');

   Fnd_Proj_Ent_Action_API.Create_Or_Replace(cloned_name_, 'VirtualOrderReport', 'OrderReport');
   Fnd_Proj_Ent_Action_API.Create_Or_Replace(cloned_name_, 'VirtualOrderReport', 'ScheduleReport');

   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_DistributionUsersQuery','Query','DistributionUsersQuery');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_DistributionGroupQuery','Query','DistributionGroupQuery');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_VirtualOrderReport','Virtual','VirtualOrderReport');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_ReportLayoutDefinition','Entity','ReportLayoutDefinition');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_LanguageCode','Entity','LanguageCode');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_ReportDefinition','Entity','ReportDefinition');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'Reference_LogicalPrinter','Entity','LogicalPrinter');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'DistUserSet','Query','DistributionUsersQuery');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'DistGroupSet','Query','DistributionGroupQuery');
   Fnd_Proj_Entityset_API.Create_Or_Replace(cloned_name_, 'VirtualOrderReports','Virtual','VirtualOrderReport');
     
   Fnd_Proj_Query_API.Create_Or_Replace(cloned_name_, 'DistributionUsersQuery', 'FND_USER', NULL, 'Main', 'FALSE');
   Fnd_Proj_Query_API.Create_Or_Replace(cloned_name_, 'DistributionGroupQuery', 'DISTRIBUTION_GROUP', NULL, 'Main', 'FALSE');
   --Tell client framework that metadata is new
   Dictionary_SYS.Refresh_Odata_Client_Cache(cloned_name_);
   Dictionary_SYS.Refresh_Odata_Projection_Cache(cloned_name_);
   Fnd_Projection_Usage_API.Create_Or_Replace(cloned_name_, cloned_name_, 'OrderReport',    'assistant', 'Order Report - ' || report_title_);  
   Fnd_Projection_Usage_API.Create_Or_Replace(cloned_name_, cloned_name_, 'ScheduleReport', 'assistant', 'Schedule Report - ' || report_title_);
   
   Trace_SYS.Message('Aurena_Report_Metadata_SYS.Initialize_Template___ Done!');
END Initialize_Template___;


PROCEDURE Create_Arg_Definitions___ (
   condition_ OUT VARCHAR2,
   report_id_ IN VARCHAR2)
IS
   editable_       VARCHAR2(10) := CASE Is_Custom_Defined__(report_id_) WHEN 'TRUE' THEN 'FALSE' ELSE 'TRUE' END;
   arg_definition_ VARCHAR2(4000);   
   arg_cond_       VARCHAR2(100);
   mandatory_      BOOLEAN;
   index_          NUMBER := 0;
         
   CURSOR params IS      
      SELECT report_id, column_name, column_query, column_value, column_qflags, column_dataformat, comments, column_lov, lov_view, lov_enum, enumerate_method
         FROM REPORT_COLUMN_DEFINITION
         WHERE report_id = report_id_
         AND column_query IS NOT NULL
         ORDER BY column_id;
BEGIN      
   
   DELETE
      FROM aurena_report_metadata_map_tab
      WHERE report_id = report_id_;
      
   FOR param IN params LOOP      
      index_ := index_ + 1;

      Construct_Arg_Definition___(
         arg_definition_,
         mandatory_,
         report_id_,
         param.column_name,
         param.column_query,
         param.column_qflags,
         param.column_dataformat,
         param.column_lov,
         param.lov_view,
         param.lov_enum,
         param.enumerate_method,
         index_,
         editable_,
         REPLACE(REPLACE(param.comments, CHR(10), ''), '^   ', ''));        -- Fix bad comments by removing tabs and rowbreaks  
         
      INSERT
         INTO aurena_report_metadata_map_tab (
         report_id,
         column_index,
         column_name,
         column_query,
         column_value,
         arg_definition)
      VALUES (
         param.report_id,
         index_,
         param.column_name,
         param.column_query,
         param.column_value,         
         arg_definition_);         

      IF (mandatory_) THEN
         -- Mandatory arguments are being added to the condition_ parameter, which is later used by the cpi!
         -- EXAMPLE: 
         -- record.ParamVersion != null
         arg_cond_ := 'record.Param' || replace(initcap(param.column_name),'_','') || ' != null';
         IF (condition_ IS NULL) THEN
            condition_ := arg_cond_;
         ELSE
            condition_ := condition_ || ' && ' || arg_cond_;
         END IF;
      END IF;      
   END LOOP;
   
   IF (condition_ IS NULL) THEN
      condition_ := 'true';
   END IF;                                               
--EXCEPTION
--   WHEN OTHERS THEN
--       Error_SYS.Appl_General(lu_name_, 'ERROR_OCCURED: Error during template generation for '':P1''.', report_id_);
END Create_Arg_Definitions___;


PROCEDURE Remove_Quick_Report_Template___ (
	quick_report_id_ IN VARCHAR2)
IS
   projection_name_ VARCHAR2(200);
BEGIN
   projection_name_ := Quick_Report_API.Get_Projection_Name(quick_report_id_);   
   Fnd_Projection_API.Remove_Projection(projection_name_, FALSE, FALSE);       -- Do not remove package!!!
   Model_Design_SYS.Refresh_Projection_Version(qr_report_template_name_);
   Refresh_Template_Version___;
END Remove_Quick_Report_Template___;

PROCEDURE Initialize_Quick_Report_Template___ (
	quick_report_id_ IN VARCHAR2)
IS
   projection_  VARCHAR2(200) := Get_Projection_Name__(quick_report_id_, 'SQL');
   description_ VARCHAR2(200) := Quick_Report_API.Get_Description(quick_report_id_); 
BEGIN   
   -- Clone projection and client template into new report
   Model_Design_SYS.Clone_Template_Into_Model_(qr_report_template_name_, projection_, quick_report_id_, qr_report_component_, '');   
   -- Register generated projection
   Fnd_Projection_API.Create_Or_Replace(projection_, description_ => 'Quick Report - ' || description_, categories_ => 'Users', component_ => qr_report_component_, layer_  => 'Core', plsql_package_ => 'QUICK_REPORT_TEMPLATE_SVC', api_class_ => 'Standard', deprecated_ => 'FALSE');
   Fnd_Proj_Large_Attr_Supp_Api.Set_Lob_Max_Size_Modifiable(projection_, false);
   Refresh_Template_Version___;   
END Initialize_Quick_Report_Template___;


PROCEDURE Refresh_Template_Version___
IS
BEGIN
   -- Update the QR template version, always being the projection with the highest timestamp among all Quick Report projections.
   -- An alternative to this could be skipping the update and instead select the highext (max) projection version for all QR projections.
   -- However, that would result in a slower fetch since we would need to run a regexp_like operation on the model_design_tab. /Rakuse 
   Model_Design_SYS.Refresh_Projection_Version(qr_report_template_name_);
END Refresh_Template_Version___;


PROCEDURE Construct_Arg_Definition___ (
   definition_ OUT VARCHAR2,
   mandatory_ OUT BOOLEAN,
   report_id_ IN VARCHAR2,
   column_name_ IN VARCHAR2,
   column_query_ IN VARCHAR2,
   column_qflags_ IN VARCHAR2,
   column_dataformat_ IN VARCHAR2,
   column_lov_ IN VARCHAR2,
   lov_view_ IN VARCHAR2,
   lov_enum_ IN VARCHAR2,
   enumerate_method_ IN VARCHAR2,
   column_index_ IN NUMBER,
   editable_ IN VARCHAR2,
   comment_ IN VARCHAR2)
IS 
   qtype_     VARCHAR2(100);
   
   PROCEDURE Add___(
      definition_ IN OUT VARCHAR2,
      name_ IN VARCHAR2,
      value_ IN VARCHAR2,
      optional_ IN BOOLEAN DEFAULT FALSE)
   IS
   BEGIN
      IF (optional_ AND value_ IS NULL) THEN
         RETURN;
      END IF;
      definition_ := definition_ || name_ || '=' || value_ || '^';      
   END Add___;   
BEGIN
   IF (comment_ IS NULL) THEN
      qtype_ := column_dataformat_;
   ELSE
      qtype_ := Client_SYS.Get_Key_Reference_Value(comment_, 'DATATYPE');
   END IF;         
   IF (qtype_ IS NULL) THEN
      qtype_ := 'STRING(50)';
   END IF;
   IF (INSTR(qtype_, 'VARCHAR2') > 0) THEN
      -- Legacy: There are columns defined using VARCHAR2, which therefore gets mapped to STRING here.
      qtype_ := REPLACE(qtype_, 'VARCHAR2', 'STRING');
   END IF;                
   mandatory_ := SUBSTR(column_qflags_, 1, 1) = 'M';
   
   -- Required
   Add___(definition_, 'ENTITY', 'VirtualOrderReport');
   Add___(definition_, 'DATATYPE', 'STRING');
   Add___(definition_, 'COLUMN', 'PARAM$' || column_name_);
   Add___(definition_, 'FETCH', 'Parameter' || column_index_);
   Add___(definition_, 'EDITABLE', editable_);
   Add___(definition_, 'QTYPE', qtype_);
   Add___(definition_, 'QFLAGS', column_qflags_);
   -- Optional   
   IF (column_lov_ IS NULL) THEN
      Add___(definition_, 'ENUMERATE', enumerate_method_, true);
   ELSE
      Add___(definition_, 'REF', lov_view_, true);
      Add___(definition_, 'ENUMERATE', lov_enum_, true);
   END IF;
   IF (Report_Definition_API.Get_Report_Mode(report_id_) = report_mode_business_) THEN
      -- Businedd Reports are using a custom prefix, for why the Service needs to be adjusted to match that. 
      Add___(definition_, 'SERVICE', Get_Projection_Name__(report_id_));
   END IF;

   Add___(definition_, 'TITLE', column_query_); 
END Construct_Arg_Definition___;

FUNCTION Trans_Arg_Definition___(
  report_id_      IN VARCHAR2,
  column_name_    IN VARCHAR2,
  column_query_   IN VARCHAR2,
  arg_definition_ IN VARCHAR2) RETURN VARCHAR2
IS
   key_         VARCHAR2(5) := 'TITLE';
   prog_title_  VARCHAR2(1000);
   trans_titel_ VARCHAR2(1000);   
BEGIN
   prog_title_  := key_ || '=' || Client_SYS.Get_Key_Reference_Value(arg_definition_, key_) || '^';
   trans_titel_ := key_ || '=' || REPLACE(Language_SYS.Translate_Report_Question_(Report_Definition_API.Get_Lu_Name(report_id_), report_id_, column_name_, column_query_),':','') || '^';
   RETURN REPLACE(arg_definition_, prog_title_, trans_titel_);      
END Trans_Arg_Definition___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Register_Custom_Report__ (
   report_id_ IN VARCHAR2,
   custom_page_ IN VARCHAR2 DEFAULT NULL)
IS        
BEGIN   
   DELETE
      FROM aurena_report_metadata_tab
      WHERE report_id = report_id_;
      
   IF (custom_page_ IS NOT NULL) THEN
      INSERT
         INTO aurena_report_metadata_tab (
            report_id,
            custom_page)
         VALUES (
            report_id_,
            custom_page_);
   END IF;
   
   Initialize_Report__(report_id_);
END Register_Custom_Report__;


PROCEDURE Initialize_Report__ (
   report_id_ IN VARCHAR2)
IS
   rec_ Report_Definition_API.Public_Rec := Report_Definition_API.Get(report_id_);
BEGIN   
   IF (rec_.report_mode = report_mode_operation1_ OR
       rec_.report_mode = report_mode_operation2_ OR
       rec_.report_mode = report_mode_business_) THEN
      Initialize_Template___(report_id_);     
   END IF;
END Initialize_Report__;


PROCEDURE Initialize_Reports__ (
   component_ IN VARCHAR2 DEFAULT '',
   mode_      IN VARCHAR2 DEFAULT '')
IS   
   count_            NUMBER := 0;
   projection_name_  VARCHAR2(200);
   version_date_     DATE;
   
   CURSOR get_operational_reports IS
      SELECT report_id, NVL(Module_API.Get_Active(module), 'FALSE') active_module
      FROM   report_sys_tab
      WHERE  module = (NVL(component_, module))
      AND    report_mode IN (report_mode_operation1_, report_mode_operation2_, report_mode_business_);
BEGIN
   version_date_ := Get_Data_Version___(report_template_name_, report_template_name_, TRUE);
   FOR op_report IN get_operational_reports LOOP
      projection_name_ := Get_Projection_Name__(op_report.report_id);
      IF (Fnd_Projection_API.Exists(projection_name_)) AND 
         (op_report.active_module != 'TRUE') THEN
         Database_SYS.Remove_Client(projection_name_);
         Database_SYS.Remove_Projection(projection_name_);
      END IF;
      IF (mode_ = 'COMPUTE') AND Is_Template_Initialized___(projection_name_, projection_name_, version_date_) THEN
         CONTINUE;   -- COMPUTE mode -> Skip re-creting reports that are already created and up-to-date.
      END IF;
      IF(op_report.active_module = 'TRUE') THEN
         count_ := count_ + 1;
         Initialize_Template___(op_report.report_id);
      END IF;
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, count_||' report(s) were initialized');
END Initialize_Reports__;

FUNCTION Find_Column_Index__ (
   report_id_ IN VARCHAR2,
   column_name_ IN VARCHAR2) RETURN NUMBER
IS
   columne_index_ aurena_report_metadata_map_tab.column_index%TYPE;   
   
   CURSOR get_index IS
      SELECT column_index
      FROM  aurena_report_metadata_map_tab
      WHERE report_id = report_id_
      AND column_name = column_name_;
BEGIN
   OPEN get_index;
   FETCH get_index INTO columne_index_;
   IF (get_index%NOTFOUND) THEN
      CLOSE get_index;
      Trace_SYS.Field('Find_Attribute_Seq___. ', column_name_ || ' is not being defined as report argument!');
      RETURN 0;
   END IF;
   CLOSE get_index;
   
   RETURN columne_index_;
END Find_Column_Index__;


FUNCTION Is_Custom_Defined__ (
   report_id_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Custom_Page__(report_id_) IS NULL) THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Is_Custom_Defined__;

FUNCTION Get_Custom_Page__ (
   report_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   -- Example:
   -- assistant/CustomerStatementOfAccount/CustomerStatementOfAccountAssistant
   custom_page_ aurena_report_metadata_tab.custom_page%TYPE;   
   
   CURSOR get_custom IS
      SELECT custom_page
      FROM  aurena_report_metadata_tab
      WHERE report_id = report_id_;
BEGIN
   OPEN get_custom;
   FETCH get_custom INTO custom_page_;
   IF (get_custom%NOTFOUND) THEN
      CLOSE get_custom;
      RETURN NULL;
   END IF;
   CLOSE get_custom;
   
   RETURN custom_page_;
END Get_Custom_Page__;


FUNCTION Get_Arg_Definitions__ (
   report_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   attr_  VARCHAR2(32000);
   CURSOR get_arg_definitions IS
      SELECT column_name, column_query, arg_definition
      FROM  aurena_report_metadata_map_tab
      WHERE report_id = report_id_
      ORDER BY column_index;
      
BEGIN   
   Client_SYS.Clear_Attr(attr_);
   FOR definition IN get_arg_definitions LOOP                                
      Client_SYS.Add_To_Attr('Param'||replace(initcap(definition.column_name),'_',''), Format_Arg_Definition___(Trans_Arg_Definition___(report_id_, definition.column_name, definition.column_query, definition.arg_definition)), attr_);
   END LOOP;   
   RETURN attr_;
END Get_Arg_Definitions__;

FUNCTION Format_Arg_Definition___(
   arg_definition_ IN VARCHAR2) RETURN VARCHAR2
IS
   custom_arg_definition_ VARCHAR2(2000);
BEGIN
   -- 2020-03-13 /Rakuse
   -- Currently, Argument Fields do NOT support DATE types with having the Format defined as TIME or DATETIME.
   -- The only supported Format is DATE, for why we hardcode all unsupported formats to DATE.
   -- This "hardcoding" will be removed once the Argument Fields get extended format support.
   -- Note also that this limitation is pratice only used within Business Reports but we hardcode this for all reports (incl Operational Reports).
   --IF (Report_Definition_API.Get_Report_Mode(report_id_) = report_mode_business_) THEN
      custom_arg_definition_ := REPLACE(arg_definition_, 'QTYPE=DATE/TIME^', 'QTYPE=DATE/DATE^');
      RETURN REPLACE(custom_arg_definition_, 'QTYPE=DATE/DATETIME^', 'QTYPE=DATE/DATE^');
   --END IF;
   RETURN arg_definition_;
END Format_Arg_Definition___;

FUNCTION Get_Attribute_Mapping__ (
   report_id_ IN VARCHAR2) RETURN report_col_def_table
IS 
   temp_ report_col_def_table;
    
   CURSOR get_attributes IS   
      SELECT column_index, column_name, column_query, column_value, arg_definition
      FROM aurena_report_metadata_map_tab
      WHERE report_id = report_id_
      ORDER BY column_index;
      
BEGIN      
   OPEN  get_attributes;
   FETCH get_attributes BULK COLLECT INTO temp_;
   CLOSE get_attributes;
   FOR i IN 1 .. temp_.COUNT LOOP
      temp_(i).arg_definition := Trans_Arg_Definition___(report_id_, temp_(i).column_name, temp_(i).column_query, temp_(i).arg_definition);      
   END LOOP;   
   RETURN temp_;
END Get_Attribute_Mapping__;

PROCEDURE Initialize_Quick_Reports__ (
   mode_      IN VARCHAR2 DEFAULT '')
IS   
   count_        NUMBER := 0;
   version_date_ DATE;
   
   CURSOR get_quick_reports IS
      SELECT quick_report_id
      FROM   quick_report_tab;
BEGIN
   version_date_ := Get_Data_Version___(NULL, qr_report_template_name_, TRUE);
   FOR qr_report IN get_quick_reports LOOP
      IF (mode_ = 'COMPUTE') AND Is_Template_Initialized___(NULL, Quick_Report_API.Get_Projection_Name(qr_report.quick_report_id), version_date_) THEN
         CONTINUE;   -- COMPUTE mode -> Skip re-creting quick reports that are already created and up-to-date.
      END IF;
      count_ := count_ + 1;
      Initialize_Quick_Report_Template___(qr_report.quick_report_id);
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, count_||' quick report(s) were initialized');
END Initialize_Quick_Reports__;

PROCEDURE Initialize_Quick_Report__ (
   quick_report_id_ IN VARCHAR2,
   remove_          IN BOOLEAN DEFAULT FALSE)   
IS
   rec_ Quick_Report_API.Public_Rec := Quick_Report_API.Get(quick_report_id_);
BEGIN   
   IF (remove_ OR rec_.quick_report_id IS NULL) THEN
      -- Having rec_.quick_report_id is NULL means that the QR is not defined, for why we then remove the "non valid" projection. 
      Remove_Quick_Report_Template___(quick_report_id_);
   ELSE
      Initialize_Quick_Report_Template___(quick_report_id_);
   END IF;
END Initialize_Quick_Report__;

FUNCTION Get_Projection_Name__ (
   id_          IN VARCHAR2,
   report_type_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   -- Depending on which report type that's being asked for, using either report_id or quick_report_id, we need to route the query. 
   IF (report_type_ = 'SQL') THEN
      -- Quick Reports
      RETURN qr_projection_prefix_ || id_;
   END IF;
   
   -- Other reports
   RETURN Get_Projection_Name__(id_);
END Get_Projection_Name__;

FUNCTION Get_Projection_Name__ (
   report_id_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (Report_Definition_API.Get_Report_Mode(report_id_) = report_mode_business_) THEN
      -- Business reports are prefixed with 'BR' due to being possible to be named starting with numerical characters.
      -- Ex: Report named '1Abc' will become 'BR1Abc'
      RETURN business_report_prefix_ || Dictionary_SYS.Dbnametoclientname_(report_id_);
   END IF;
   
   RETURN Dictionary_SYS.Dbnametoclientname_(report_id_);
END Get_Projection_Name__;

FUNCTION Get_Projection_Version__ RETURN VARCHAR2
IS
BEGIN
    RETURN Model_Design_SYS.Get_Projection_Version_(qr_report_template_name_);
END Get_Projection_Version__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU NEW METHODS -------------------------------------
