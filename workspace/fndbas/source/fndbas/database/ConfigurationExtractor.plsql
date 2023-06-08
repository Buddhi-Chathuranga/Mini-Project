-----------------------------------------------------------------------------
--
--  Logical unit: ConfigurationExtractor
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Format_CustomObj_Msg___ (
   result_ CLOB) RETURN CLOB
IS
   name_          Message_SYS.name_table;
   value_         Message_SYS.line_table;
   count_         INTEGER;
   output_        CLOB;
   default_value_ CLOB;
   out_           CLOB;
BEGIN
   dbms_lob.createtemporary(output_, true);
   Message_SYS.Get_Attributes(result_, count_, name_, value_);
   FOR c_ IN 1..count_ LOOP
      out_ := Message_SYS.Find_Clob_Attribute(value_(c_), 'CODE', default_value_);
      dbms_lob.append(output_,To_Clob(out_||chr(10)));
   END LOOP;
   RETURN output_;
END Format_CustomObj_Msg___;

FUNCTION Get_Acp_Enum_Type___ (
   extract_config_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE extract_config_type_db_
   WHEN Extract_Configuration_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      RETURN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION;   
   WHEN Extract_Configuration_Type_API.DB_CUSTOM_EVENT THEN
      RETURN App_Config_Item_Type_API.DB_CUSTOM_EVENT;   
   ELSE
      RETURN extract_config_type_db_;
   END CASE;
END Get_Acp_Enum_Type___;

FUNCTION Get_Item_Configuration___ (
   type_   IN VARCHAR2,
   rowkey_  IN VARCHAR2) RETURN CLOB
IS
   result_ CLOB;
   lu_name_ VARCHAR2(100);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF type_ = Extract_Configuration_Type_API.DB_CUSTOM_FIELD THEN
      lu_name_ := Custom_Fields_API.Get_Key_By_Rowkey(rowkey_).lu;
      result_ := Custom_Fields_API.Get_Generated_Code(Custom_Fields_API.Get_Key_By_Rowkey(rowkey_).lu);
   ELSIF type_ = Extract_Configuration_Type_API.DB_CUSTOM_LU THEN
      lu_name_ := Custom_Lus_API.Get_Key_By_Rowkey(rowkey_).lu;
      result_ := Custom_Lus_API.Get_Generated_Code(Custom_Lus_API.Get_Key_By_Rowkey(rowkey_).lu);
   ELSIF type_ = Extract_Configuration_Type_API.DB_AURENA_PAGE_CONFIGURATION THEN
      Model_Design_Util_API.Export_XML_Update_Analyzer(result_, rowkey_);
   ELSIF type_ = Extract_Configuration_Type_API.DB_PROJECTION_CONFIGURATION THEN
      Projection_Config_API.Export_XML(result_, rowkey_);
   END IF;
$END
   IF type_ = Extract_Configuration_Type_API.DB_CUSTOM_EVENT_ACTION OR type_ = Extract_Configuration_Type_API.DB_CUSTOM_EVENT THEN
      App_Config_Package_Item_API.Export_Configuration_Item(result_, NULL, rowkey_, Get_Acp_Enum_Type___(type_), NULL);   
   ELSIF type_ = Extract_Configuration_Type_API.DB_SQL_QUICK_REPORT OR type_ = Extract_Configuration_Type_API.DB_QUERY_BUILDER_QUICK_REPORT THEN
      result_ := Quick_Report_API.Get_Sql_Expression(Quick_Report_API.Get_Key_By_Rowkey(rowkey_).quick_report_id);
   ELSIF type_ = Extract_Configuration_Type_API.DB_REPORT_RULE THEN
      Report_Rule_Definition_API.Export_Rule_Definition_Ins(result_, '"' ||Report_Rule_Definition_API.Get_Key_By_Rowkey(rowkey_).rule_id || '"');
   ELSIF type_ = Extract_Configuration_Type_API.DB_LOBBY_DATASOURCE THEN 
      Composite_Page_Data_Source_API.Get_Datasource_Config(result_, rowkey_);
   ELSIF type_ = Extract_Configuration_Type_API.DB_HISTORY_LOG THEN
      History_Setting_Util_API.Get_History_Log_Triggers(result_, History_Setting_API.Get_Key_By_Rowkey(rowkey_).table_name);
   END IF;

   IF type_ = Extract_Configuration_Type_API.DB_CUSTOM_FIELD OR type_ = Extract_Configuration_Type_API.DB_CUSTOM_LU THEN
      RETURN Format_CustomObj_Msg___(result_);
   ELSE
      RETURN result_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF type_ = Extract_Configuration_Type_API.DB_CUSTOM_FIELD OR type_ = Extract_Configuration_Type_API.DB_CUSTOM_LU OR type_ = Extract_Configuration_Type_API.DB_INFO_CARD THEN
         Error_SYS.Appl_General(lu_name_, 'EXTRACT_FAIL: Cannot Extract :P1 check [:P2] Logical Unit.', Extract_Configuration_Type_API.Decode(type_), lu_name_, NULL, NULL);
      ELSE
         Error_SYS.Appl_General(lu_name_, 'EXTRACT_FAIL2: Cannot Extract :P1.', Extract_Configuration_Type_API.Decode(type_), NULL, NULL, NULL);
      END IF;
END Get_Item_Configuration___;
   
FUNCTION Get_File_Path___ (
   type_ IN VARCHAR2,
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   file_path_ VARCHAR2(1000);
BEGIN
   CASE type_
      WHEN 'CUSTOM_FIELD' THEN file_path_ := 'CustomFields/' || 'CustomField-' || name_ || '.sql';
      WHEN 'CUSTOM_LU' THEN file_path_ := 'CustomEntities/' || 'CustomEntity-' || name_ || '.sql';
      WHEN 'CUSTOM_EVENT' THEN file_path_ := 'CustomEvents/' || 'CustomEvent-' || name_ || '.xml';
      WHEN 'CUSTOM_EVENT_ACTION' THEN file_path_ := 'CustomEvents/' || 'CustomEventAction-' || name_ || '.xml';
      WHEN 'SQL_QUICK_REPORT' THEN file_path_ := 'QuickReports/' || 'SQLQuickReport-' || name_ || '.sql';
      WHEN 'QUERY_BUILDER_QUICK_REPORT' THEN file_path_ := 'QuickReports/' || 'QueryBuilderQuickReport-' || name_ || '.sql';
      WHEN 'LOBBY_DATASOURCE' THEN file_path_ := 'LobbyDatasources/' || 'LobbyDatasource-' || name_ || '.xml';
      WHEN 'REPORT_RULE' THEN file_path_ := 'ReportRules/' || 'ReportRule-' || name_ || '.sql';
      WHEN 'HISTORY_LOG' THEN file_path_ := 'HistoryLogs/' || 'HistoryLog-' || name_ || '.xml';
      WHEN 'AURENA_PAGE_CONFIGURATION' THEN file_path_ := 'AurenaPageConfigurations/' || 'AurenaPageConfiguration-' || name_ || '.xml';
      WHEN 'PROJECTION_CONFIGURATION' THEN file_path_ := 'ProjectionConfigurations/' || 'ProjectionConfiguration-' || name_ || '.xml';
      ELSE file_path_ := 'Other/' || type_ || '-' || name_ || '.xml';
   END CASE;
  
   RETURN file_path_;
END Get_File_Path___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Configurations_(
   extract_summary_ OUT VARCHAR2 ) RETURN BLOB 
IS  
   zip_ BLOB;
   log_ CLOB := NULL;
   log_message_ VARCHAR2(1000) := NULL;
   file_list_ FND_ZIP_OBJECT_TAB := FND_ZIP_OBJECT_TAB();
      
   CURSOR conf_cursor IS
   SELECT type, name, rowkey
   FROM extractable_configuration;

BEGIN
   Dbms_lob.Createtemporary(zip_, FALSE);

   FOR rec IN conf_cursor LOOP
      BEGIN
         file_list_.extend(1);
         file_list_(file_list_.last) := FND_ZIP_OBJECT_REC(Get_File_Path___(rec.type, rec.name),Utility_SYS.Clob_To_Blob(Get_Item_Configuration___(rec.type, rec.rowkey)));
         log_message_ := 'Extracting /Configurations/' || Get_File_Path___(rec.type, rec.name);
         Utility_SYS.Append_Text_Line(log_, log_message_);
            
         EXCEPTION 
            WHEN OTHERS THEN
               log_message_ := 'ERROR: Error occurred while extracting /Configurations/' || Get_File_Path___(rec.type, rec.name) || ':' || REGEXP_SUBSTR(SQLERRM, '[^:]+$');
               Utility_SYS.Append_Text_Line(log_, log_message_);
               
               IF extract_summary_ IS NULL THEN
                  Utility_SYS.Append_Text_Line(extract_summary_,'');
                  Utility_SYS.Append_Text_Line(extract_summary_,'Extracting completed with errors' || chr(10) || 'Failed to extract the following configurations due to error.  Please check if the configurations are configured properly.' );   
                  Utility_SYS.Append_Text_Line(extract_summary_,TRIM (REGEXP_SUBSTR ( Get_File_Path___(rec.type, rec.name)  , '\/(.*?)\.',1,1,null,1)));
               ELSE
                  Utility_SYS.Append_Text_Line(extract_summary_,TRIM (REGEXP_SUBSTR ( Get_File_Path___(rec.type, rec.name)  , '\/(.*?)\.',1,1,null,1)));
               END IF;
      END;      
   END LOOP;
   
   IF extract_summary_ IS NULL THEN
      Utility_SYS.Append_Text_Line(extract_summary_,'');
      Utility_SYS.Append_Text_Line(extract_summary_,'Extracting completed');
   END IF;
   
   Utility_SYS.Append_Text_Line(log_,'');
   Utility_SYS.Append_Text_Line(log_,extract_summary_);
         
   file_list_.extend;
   file_list_(file_list_.last) := FND_ZIP_OBJECT_REC('log.txt',Utility_SYS.Clob_To_Blob(log_));

   Fnd_Zip_Util_API.Zip_Files(zip_, file_list_);
      
   RETURN zip_;
      
END Get_Configurations_;