-----------------------------------------------------------------------------
--
--  Logical unit: ConditionalFieldAction
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
EXPORT_DEF_VERSION      CONSTANT VARCHAR2(5) := '1.0';
XMLTAG_CONDITIONAL_FIELD CONSTANT VARCHAR2(50)  := 'CONDITIONAL_FIELD_ACTION';
XMLTAG_CUST_OBJ_EXP     CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_CUST_OBJ_EXP_DEF_VER CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';

CURSOR get_header(xml_ CLOB) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CONDITIONAL_FIELD_ACTION' passing Xmltype(xml_)
                         COLUMNS
                            EXPORT_DEF_VERSION VARCHAR2(30) path '@EXPORT_DEF_VERSION',
                            ACTION_ID VARCHAR2(100) path 'ACTION_ID',
                            VIEW_NAME VARCHAR2(100) path 'VIEW_NAME',
                            COLUMN_NAME VARCHAR2(100) path 'COLUMN_NAME',
                            LU_NAME VARCHAR2(100) path 'LU_NAME',
                            NAME VARCHAR2(100) path 'NAME',
                            ACTION_TYPE VARCHAR2(100) path 'ACTION_TYPE_DB',
                            ACTION_PROPERTY VARCHAR2(100) path 'ACTION_PROPERTY_DB',
                            ACTION_INDEX NUMBER path 'ACTION_INDEX',
                            ACTION_ENABLED VARCHAR2(100) path 'ACTION_ENABLED_DB',                            
                            ACTION_CRITERIA VARCHAR2(4000) path 'ACTION_CRITERIA',
                            ACTION_VALUE VARCHAR2(4000) path 'ACTION_VALUE',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            EXPORTED_DATE VARCHAR2(50) path 'EXPORT_DATE',
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;

CF_VIEW_SUFFIX       CONSTANT VARCHAR2(4) := '_CFV';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT CONDITIONAL_FIELD_ACTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Set_Server_Mandatory_Values___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

PROCEDURE Validate_Import___ (
   info_          IN OUT App_Config_Util_API.AppConfigItemInfo,
   xml_           IN CLOB,
   dep_objects_   IN App_Config_Util_API.DeploymentObjectArray )
IS
   header_     conditional_field_action_tab%ROWTYPE;
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   
   col_exists_ NUMBER;   
   import_date_ DATE;
   custom_fields_view_name_ VARCHAR2(50);
      
BEGIN
   FOR rec_ IN get_header(xml_) LOOP    
      header_ := Get_Object_By_Keys___(rec_.action_id);
      IF header_.rowkey IS NULL THEN
         info_.exists := 'FALSE';
         info_.last_modified_date   := sysdate;
         info_.name := rec_.name;
         
           
      ELSE
         info_.exists := 'TRUE';
         App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, header_.rowkey);
         info_.name := header_.name;
         info_.current_last_modified_date   := header_.definition_modified_date;
         info_.last_modified_date   := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         info_.current_description := App_Config_Util_API.Get_Item_Description(header_.rowkey, App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION);
         info_.current_published := 'TRUE';
         
         IF (info_.last_modified_date <> header_.definition_modified_date) THEN
            import_date_:= App_Config_Package_API.Get_Imported_Date(info_.current_package_id);  
            IF (import_date_ IS NOT NULL) AND nvl(header_.definition_modified_date,Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten.', Fnd_Session_API.Get_Language), TRUE); 
            END IF;
         END IF;         
      END IF;
      
      $IF Component_Fndcob_SYS.INSTALLED $THEN
        custom_fields_view_name_ := Custom_Obj_SYS.Ensure_Short_Object_Name__('', rec_.view_name, CF_VIEW_SUFFIX);
      $END
      --SOLSETFW
      -- Check lu, view and column
      SELECT count(*) INTO col_exists_
      FROM dictionary_sys_view_column_act
      WHERE lu_name = rec_.lu_name
      AND (view_name = rec_.view_name or view_name = custom_fields_view_name_)
      AND column_name = rec_.column_name;

      IF col_exists_ = 0 THEN
         IF NOT App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_, rec_.view_name ||'.'|| rec_.column_name, '*') AND   
            NOT App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_, custom_fields_view_name_ || '.' || rec_.column_name, '*') THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.STATUS_WARNING);
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'NONEXISTCONDFIELD: Warning: The conditional field action uses a column ":P1" in ":P2" which cannot be found. This action will not be applied.',Fnd_Session_API.Get_Language,rec_.column_name,rec_.lu_name), TRUE);
         END IF;
      END IF;
   
      IF col_exists_ = 1 OR info_.exists = 'TRUE' THEN         
         -- Warn if column required flag is Mandatory and action property is read only. The action will not be applied.
         IF rec_.action_property = 'READ_ONLY' THEN
            IF custom_fields_view_name_ IS NULL THEN
               $IF Component_Fndcob_SYS.INSTALLED $THEN
                  custom_fields_view_name_ := Custom_Obj_SYS.Ensure_Short_Object_Name__('', rec_.view_name, CF_VIEW_SUFFIX);
               $ELSE   
                  NULL;
               $END   
            END IF;
            --SOLSETFW
            SELECT count(*) INTO col_exists_
            FROM dictionary_sys_view_column_act
            WHERE lu_name = rec_.lu_name
            AND (view_name = rec_.view_name or view_name = custom_fields_view_name_)
            AND column_name = rec_.column_name
            AND required_flag = 'M';
            
            IF col_exists_ = 0 THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'ACTIONINCONSISTENT: Warning: The conditional field action property "Read Only" cannot be applied to a mandatory column. This action will not be applied.'), TRUE);
            END IF;
         END IF;
      END IF;
         
   END LOOP;
   
   --Clear_Ctx_Import_Mode___;
END Validate_Import___;

PROCEDURE Set_Server_Mandatory_Values___ (
   newrec_ IN OUT conditional_field_action_tab%ROWTYPE)
IS
BEGIN
   IF newrec_.definition_modified_date IS NULL THEN
      newrec_.definition_modified_date := sysdate;
   END IF;   
END Set_Server_Mandatory_Values___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF action_ = 'DO' THEN
      Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
END Modify__;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN conditional_field_action_tab%ROWTYPE)
IS
BEGIN
   Check_Package___(remrec_);
   super(remrec_);
END Check_Delete___;

/*
* Throws an exception if action is connected to an ACP.
*/
PROCEDURE Check_Package___ (
   remrec_ IN     conditional_field_action_tab%ROWTYPE )
IS
   package_name_ VARCHAR2(100);
BEGIN
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: The action ":P1" cannot be deleted, unless removed from the package ":P2".', remrec_.action_id, package_name_);
   END IF;   
END Check_Package___;  

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Export_XML (
   out_xml_      OUT CLOB,
   action_id_    IN VARCHAR2)
IS
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_CONDITIONAL_FIELD;
   item_type_  VARCHAR2(50);
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                                    ''COND_FIELD_ACTION'' type,
                                    h.action_id, 
                                    h.view_name,
                                    h.column_name,
                                    h.lu_name,
                                    h.name,
                                    h.action_type_db,
                                    h.action_property_db,
                                    h.action_index,
                                    h.action_enabled_db,
                                    h.action_criteria,
                                    h.action_value,
                                    to_char(definition_modified_date,'''||Client_SYS.date_format_||''') definition_modified_date,
                                    to_char(sysdate, '''||Client_SYS.date_format_||''') export_date,
                                    h.objkey rowkey
                             FROM CONDITIONAL_FIELD_ACTION h
                             WHERE action_id= '''||action_id_||'''';
   
BEGIN
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: '|| stmt_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_CONDITIONAL_FIELD);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   
   objkey_ := Conditional_Field_Action_API.Get_Objkey(action_id_);
   item_type_   := App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION;
      
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      Get_Name_By_Rowkey(objkey_),
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      item_type_,
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      Get_Description_By_Rowkey(objkey_),
                                      xpath_);
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
END Export_XML;

FUNCTION Get_Name_By_Rowkey(
   row_key_ IN VARCHAR2) RETURN VARCHAR2 
IS
   name_ Conditional_Field_Action_TAB.name%TYPE;   
BEGIN
   SELECT name 
   INTO name_
   FROM conditional_field_action
   WHERE objkey = row_key_;

   RETURN name_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Name_By_Rowkey;

FUNCTION Get_Description_By_Rowkey(
   row_key_ IN VARCHAR2) RETURN VARCHAR2 
IS
   description_ VARCHAR2(200);   
BEGIN
   SELECT action_type||' - '||action_property 
   INTO description_
   FROM conditional_field_action
   WHERE objkey = row_key_;

   RETURN description_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Description_By_Rowkey; 
   
FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ conditional_field_action_tab.definition_modified_date%TYPE;
BEGIN
   --SOLSETFW
   SELECT definition_modified_date INTO definition_modified_date_
   FROM conditional_field_action
   WHERE objkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;
   
PROCEDURE Validate_Import (
   info_          OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_   IN OUT App_Config_Util_API.DeploymentObjectArray,
   xml_           IN CLOB,
   type_          IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION;
   info_.validation_result    := App_Config_Util_API.Status_Unknown; 
   info_.validation_details   := NULL;
   Validate_Import___(info_, xml_, dep_objects_);
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
   
   
PROCEDURE Validate_Existing(
   info_          OUT App_Config_Util_API.AppConfigItemInfo,
   rowkey_        IN app_config_package_item_tab.configuration_item_id%TYPE,
   type_          IN VARCHAR2 DEFAULT NULL)
IS
   rec_ conditional_field_action_tab%ROWTYPE;
   
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   
   col_exists_ NUMBER;
   custom_fields_view_name_ VARCHAR2(50);
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION;
   info_.validation_result    := App_Config_Util_API.Status_Unknown; 
   info_.validation_details   := NULL;
   
   Rowkey_Exist(rowkey_);
   
   rec_ := Get_Key_By_Rowkey(rowkey_);
   rec_ := Get_Object_By_Keys___(rec_.action_id);

   --Validation Start
   info_.exists := 'TRUE';
   App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, rec_.rowkey);
   info_.name := rec_.name;
   info_.current_last_modified_date   := rec_.definition_modified_date;
   info_.last_modified_date   := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
   info_.current_description := App_Config_Util_API.Get_Item_Description(rec_.rowkey, App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION);
   info_.current_published := 'TRUE';

   $IF Component_Fndcob_SYS.INSTALLED $THEN
     custom_fields_view_name_ := Custom_Obj_SYS.Ensure_Short_Object_Name__('', rec_.view_name, CF_VIEW_SUFFIX);
   $END
   --SOLSETFW
   -- Check lu, view and column
   SELECT count(*) INTO col_exists_
   FROM dictionary_sys_view_column_act
   WHERE lu_name = rec_.lu_name
   AND (view_name = rec_.view_name or view_name = custom_fields_view_name_)
   AND column_name = rec_.column_name;

   IF col_exists_ = 0 THEN
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.STATUS_WARNING);
      Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'NONEXISTCONDFIELD: Warning: The conditional field action uses a column ":P1" in ":P2" which cannot be found. This action will not be applied.',Fnd_Session_API.Get_Language,rec_.column_name,rec_.lu_name), TRUE);
   END IF;

   IF col_exists_ = 1 OR info_.exists = 'TRUE' THEN         
      -- Warn if column required flag is Mandatory and action property is read only. The action will not be applied.
      IF rec_.action_property = 'READ_ONLY' THEN
         IF custom_fields_view_name_ IS NULL THEN
            $IF Component_Fndcob_SYS.INSTALLED $THEN
               custom_fields_view_name_ := Custom_Obj_SYS.Ensure_Short_Object_Name__('', rec_.view_name, CF_VIEW_SUFFIX);
            $ELSE   
               NULL;
            $END   
         END IF;
         --SOLSETFW
         SELECT count(*) INTO col_exists_
         FROM dictionary_sys_view_column_act
         WHERE lu_name = rec_.lu_name
         AND (view_name = rec_.view_name or view_name = custom_fields_view_name_)
         AND column_name = rec_.column_name
         AND required_flag = 'M';

         IF col_exists_ = 0 THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'ACTIONINCONSISTENT: Warning: The conditional field action property "Read Only" cannot be applied to a mandatory column. This action will not be applied.'), TRUE);
         END IF;
      END IF;
   END IF;

   --Validation End
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
   
      
PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   xml_                   IN CLOB,
   type_                  IN VARCHAR2 DEFAULT NULL)
IS
   header_ conditional_field_action_tab%ROWTYPE;
   
BEGIN
   identical_ := FALSE;
   FOR rec_ IN get_header(xml_) LOOP
      header_ := Get_Object_By_Keys___(rec_.action_id);
      IF header_.rowkey IS NULL THEN
         Prepare_New___(header_);
         header_.action_id := rec_.action_id;
         header_.view_name := rec_.view_name;
         header_.column_name := rec_.column_name;
         header_.lu_name := rec_.lu_name;
         header_.name := rec_.name;
         header_.action_type := rec_.action_type;
         header_.action_property := rec_.action_property;
         header_.action_index := rec_.action_index;
         header_.action_enabled := rec_.action_enabled;
         header_.action_criteria := rec_.action_criteria;
         header_.action_value := rec_.action_value;
         header_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         header_.rowkey := rec_.objkey;
         New___(header_);
      ELSE
         header_ := Lock_By_Keys_Nowait___(rec_.action_id);
         IF (header_.definition_modified_date <> to_date(rec_.definition_modified_date, Client_SYS.date_format_)) THEN 
            header_.name := rec_.name;
            header_.action_type := rec_.action_type;
            header_.action_property := rec_.action_property;
            header_.action_index := rec_.action_index;
            header_.action_enabled := rec_.action_enabled;
            header_.action_criteria := rec_.action_criteria;
            header_.action_value := rec_.action_value;
            header_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
            Modify___(header_);
         ELSE
            identical_ := TRUE;
         END IF;   
      END IF;
   END LOOP;
   
   configuration_item_id_  := header_.rowkey;
   name_                   := header_.name; 
END Import;
      