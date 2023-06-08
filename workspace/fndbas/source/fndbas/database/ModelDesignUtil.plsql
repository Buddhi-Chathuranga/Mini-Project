-----------------------------------------------------------------------------
--
--  Logical unit: ModelDesignUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

@AllowTableOrViewAccess fnd_model_design_tab
@AllowTableOrViewAccess fnd_model_design_data_tab


-------------------- PUBLIC DECLARATIONS ------------------------------------
--Export_Web_Page_Bundle
EXPORT_DEF_VERSION      CONSTANT VARCHAR2(5) := '1.0';

XMLTAG_WEB_PAGE_BUNDLE       CONSTANT VARCHAR2(50)  := 'WEB_PAGE_BUNDLE';

XMLTAG_CUST_OBJ_EXP     CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';

CURSOR get_page_bundle_header(xml_ Xmltype) IS
   SELECT xtwpb.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/WEB_PAGE_BUNDLE' passing xml_
                         COLUMNS
                            MODEL_ID VARCHAR2(2000) path 'MODEL_ID',
                            ARTIFACT VARCHAR2(2000) path 'ARTIFACT',
                            NAME VARCHAR2(2000) path 'NAME' ,
                            REFERENCE VARCHAR2(2000) PATH 'REFERENCE',
                            KIND VARCHAR2(2000) PATH 'KIND',
                            DESCRIPTION VARCHAR2(2000) PATH 'DESCRIPTION',
                            VERSION VARCHAR2(2000) PATH 'VERSION',
                            TEMPLATE CLOB PATH 'TEMPLATE'
                        ) xtwpb;
                        
                        
CURSOR get_page_bundle_artifacts(xml_ Xmltype) IS
   SELECT xtwpbd.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/WEB_PAGE_BUNDLE/DATA/DATA_ROW' passing xml_
                         COLUMNS
                            ROWKEY VARCHAR2(100) PATH 'OBJKEY',
                            SCOPE_ID VARCHAR2(2000) path 'SCOPE_ID',
                            ARTIFACT VARCHAR2(2000) path 'ARTIFACT',
                            DATA_ID VARCHAR2(2000) path 'DATA_ID',
                            NAME VARCHAR2(2000) path 'NAME',
                            LINE_NO VARCHAR2(2000) path 'LINE_NO',
                            LAYER_NO VARCHAR2(2000) path 'LAYER_NO',
                            VISIBILITY VARCHAR2(2000) path 'VISIBILITY',
                            REFERENCE VARCHAR2(2000) path 'REFERENCE',
                            DEPENDENCIES VARCHAR2(2000) path 'DEPENDENCIES',
                            CONTENT CLOB PATH 'CONTENT'
                        ) xtwpbd;


CURSOR get_configurations(modelid_ VARCHAR2, layer_no_ NUMBER) IS
   SELECT t.model_id, t.Data_Id, t.scope_id, t.layer_no
   FROM FND_MODEL_DESIGN_DATA_TAB t
   WHERE t.model_id = modelid_ AND t.layer_no = layer_no_;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Try_Get_Data_Row___ (
   model_id_ IN  VARCHAR2,
   scope_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   layer_no_ IN  NUMBER,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS   
BEGIN
   IF (model_id_ IS NULL OR scope_id_ IS NULL OR data_id_ IS NULL OR layer_no_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT *
      INTO  row_
      FROM  fnd_model_design_data_tab   
      WHERE model_id = model_id_
      AND   scope_id = scope_id_
      AND   data_id  = data_id_
      AND   layer_no = layer_no_;   
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(lu_name_, NULL, 'Try_Get_Data_Row___');         
END Try_Get_Data_Row___;

PROCEDURE Delete_Model_Design_Data___(
  model_name_  IN VARCHAR2,
  kind_        IN VARCHAR2 DEFAULT 'ClientMetadata',
  model_type_  IN VARCHAR2 DEFAULT 'client')
IS
BEGIN   
   DELETE
     FROM fnd_model_design_data_tab
    WHERE model_id = kind_||'.'||model_type_||':'||model_name_;
END Delete_Model_Design_Data___;

PROCEDURE Delete_Model_Design___(
  model_name_  IN VARCHAR2,
  kind_        IN VARCHAR2 DEFAULT 'ClientMetadata',
  model_type_  IN VARCHAR2 DEFAULT 'client') 
IS
BEGIN
   DELETE
     FROM fnd_model_design_tab 
    WHERE model_id = kind_||'.'||model_type_||':'||model_name_;
END Delete_Model_Design___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess   
FUNCTION Try_Get_Data_Row_ (
   model_id_ IN  VARCHAR2,
   scope_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   layer_no_ IN  NUMBER,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS   
BEGIN
   RETURN Try_Get_Data_Row___(model_id_, scope_id_, data_id_, layer_no_, row_);
END Try_Get_Data_Row_;

@UncheckedAccess
FUNCTION Try_Get_Core_Data_Row_ (
   model_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS   
BEGIN
   RETURN Try_Get_Data_Row___(model_id_, 'global', data_id_, 1, row_);
END Try_Get_Core_Data_Row_;

@UncheckedAccess
FUNCTION Try_Get_Draft_Data_Row_ (
   model_id_ IN  VARCHAR2,
   scope_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS   
BEGIN
   RETURN Try_Get_Data_Row___(model_id_, scope_id_, data_id_, 90, row_);
END Try_Get_Draft_Data_Row_;

@UncheckedAccess
FUNCTION Try_Get_Published_Data_Row_ (
   model_id_ IN  VARCHAR2,
   scope_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS   
BEGIN
   RETURN Try_Get_Data_Row___(model_id_, scope_id_, data_id_, 2, row_);
END Try_Get_Published_Data_Row_;

@UncheckedAccess
FUNCTION Try_Max_Published_Data_Row_ (
   model_id_ IN  VARCHAR2,
   scope_id_ IN  VARCHAR2,
   data_id_  IN  VARCHAR2,
   row_      OUT fnd_model_design_data_tab%ROWTYPE) RETURN BOOLEAN
IS
BEGIN
   IF (model_id_ IS NULL OR scope_id_ IS NULL OR data_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT *
      INTO  row_
      FROM fnd_model_design_data_tab t1
      WHERE model_id = model_id_
      AND   scope_id = scope_id_
      AND   data_id  = data_id_
      AND   layer_no = (SELECT MAX(t2.layer_no)
                        FROM fnd_model_design_data_tab t2
                        WHERE  t2.model_id = t1.model_id
                        AND    t2.data_id  = t1.data_id
                        AND    t2.scope_id = t1.scope_id
                        AND    t2.layer_no != Model_Design_SYS.RUNTIME_MAX_LAYER);
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(lu_name_, NULL, 'Try_Max_Published_Data_Row_'); 
END Try_Max_Published_Data_Row_;


PROCEDURE Delete_Model_Design_(
  model_name_   IN VARCHAR2,
  kind_         IN VARCHAR2 DEFAULT 'ClientMetadata',
  model_type_   IN VARCHAR2 DEFAULT 'client')
IS
BEGIN
   Delete_Model_Design_Data___(model_name_,kind_,model_type_);
   Delete_Model_Design___(model_name_,kind_,model_type_);   
END Delete_Model_Design_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- To check if a given record's matadata is in a conflict with current core metadata
-- Conflicts can occour during an update or in a instance where a user modifying core metadata under the global scope
-- If the layer_no_ not provided, logic will fall back to check published artifact is in sync
-- If based_on_content_hash_ is not provided, logic will try to fetch the hash (performance vice not optimal)
@UncheckedAccess
FUNCTION Is_Artifact_Baseline_In_Sync(
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER DEFAULT 2,
   based_on_hash_ IN VARCHAR2 DEFAULT NULL)RETURN VARCHAR2
IS
   
   core_articaft_ fnd_model_design_data_tab%ROWTYPE;
   configured_artifact_ fnd_model_design_data_tab%ROWTYPE;
   based_on_content_hash_ VARCHAR2(40);
   result_ BOOLEAN;
BEGIN
   
   based_on_content_hash_ := based_on_hash_;
   
   -- fetch based on hash if not provided as a parameter value
   IF based_on_content_hash_ IS NULL THEN
      result_ := Try_Get_Data_Row_(model_id_, scope_id_, data_id_, layer_no_, configured_artifact_);
      based_on_content_hash_ := configured_artifact_.based_on_content_hash;
      result_ := FALSE; -- we do not need to handle this
   END IF;
   
   -- If artifact is in global scope, we need to consider core layer, otherwise we first need to consider published global layer
   IF (scope_id_ <> 'global') THEN
      result_ := Try_Get_Published_Data_Row_(model_id_, 'global', data_id_, core_articaft_);
   END IF;
   IF result_ = FALSE OR result_ IS NULL THEN -- We do not have/need published global to compare, lets get core
      result_ := Try_Get_Core_Data_Row_(model_id_, data_id_, core_articaft_);
   END IF;
   
   IF based_on_content_hash_ <> core_articaft_.content_hash THEN
      RETURN 'FALSE';
   END IF;
   
   -- Will return TRUE in all other cases. Including cases where there is no baseline to compare with
   -- i.e. in the cases of global entries with layer = 1 (core) etc.
   RETURN 'TRUE';
END Is_Artifact_Baseline_In_Sync;


-- To check if any of the artifacts belonging to the model under the given scope is in a conflict
@UncheckedAccess
FUNCTION Is_Baseline_In_Sync(
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2)RETURN VARCHAR2
IS
   
   sync_state_ VARCHAR2(10);
   
   -- cusros to get local scoped artifact records including drafts
   CURSOR get_configured_artifacts IS
      SELECT *
        FROM fnd_model_design_data_tab
       WHERE layer_no <= 90 
         AND scope_id = scope_id_
         AND model_id = model_id_;
   
BEGIN
   sync_state_ := 'TRUE';
   FOR configured_artifact IN get_configured_artifacts
   LOOP
      sync_state_ := Is_Artifact_Baseline_In_Sync(
         model_id_, scope_id_, 
         configured_artifact.data_id, 
         configured_artifact.layer_no,
         configured_artifact.based_on_content_hash);
      EXIT WHEN sync_state_ = 'FALSE';
   END LOOP;
   RETURN sync_state_;
END Is_Baseline_In_Sync;

-------------------- LU  NEW METHODS -------------------------------------
PROCEDURE Export_XML_Update_Analyzer (
      out_xml_        OUT CLOB,
      model_id_       IN VARCHAR2)
IS
   date_format_ VARCHAR2(100) := Client_SYS.date_format_;
   stmt_ VARCHAR2(32000):='SELECT 
                           h.model_id,
                           h.description,
                           h.artifact,
                           h.Name,
                           h.kind,
                           h.reference as projection_reference,
                           h.profiled,
                           to_char(h.version, '''||date_format_||''') version,
                           CURSOR(SELECT  d.objkey,
                                          d.scope_id, 
                                          d.data_id, 
                                          d.artifact, 
                                          d.Name, 
                                          d.line_no, 
                                          d.layer_no, 
                                          d.visibility, 
                                          d.reference, 
                                          d.dependencies, 
                                          d.content 
                                 FROM FND_MODEL_DESIGN_DATA d
                                 WHERE d.layer_no = 2 AND h.model_id=d.model_id ) DATA
                           FROM FND_MODEL_DESIGN h
                           WHERE h.model_id = '''||model_id_||'''';


   ctx_    dbms_xmlgen.ctxHandle;
   xml_    XMLType;
   root_xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_WEB_PAGE_BUNDLE;

BEGIN
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_WEB_PAGE_BUNDLE);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);

   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME',model_id_, root_xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE',XMLTAG_WEB_PAGE_BUNDLE,root_xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION','DESCRIPTION value', root_xpath_);

   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);

END Export_XML_Update_Analyzer;
   
FUNCTION Get_Object_By_Keys___ (
   model_id_ IN VARCHAR2 ) RETURN FND_MODEL_DESIGN_TAB%ROWTYPE
IS
   lu_rec_ FND_MODEL_DESIGN_TAB%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  FND_MODEL_DESIGN_TAB
      WHERE  model_id = model_id_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(Model_Design_SYS.lu_name_, NULL, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;

FUNCTION Get_Model_Desing_Draft_Data_By_Keys___ (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_ IN VARCHAR2 ) RETURN FND_MODEL_DESIGN_DATA_TAB%ROWTYPE
IS
   data_rec_ FND_MODEL_DESIGN_DATA_TAB%ROWTYPE;
BEGIN
   SELECT *
      INTO  data_rec_
      FROM  FND_MODEL_DESIGN_DATA_TAB
      WHERE  MODEL_ID = model_id_ AND SCOPE_ID = scope_id_ AND DATA_ID = data_id_ AND LAYER_NO = 90;
   RETURN data_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN data_rec_;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(Model_Design_SYS.lu_name_, NULL, 'Get_Model_Desing_Draft_Data_By_Keys___');
END Get_Model_Desing_Draft_Data_By_Keys___;
   
PROCEDURE Get_Deployment_Object_Names (
   dep_objects_ IN OUT NOCOPY App_Config_Util_API.DeploymentObjectArray,   
   in_xml_      IN     CLOB)
IS
      count_ NUMBER;
      xml_ Xmltype := Xmltype(in_xml_);
   BEGIN
      FOR rec_ IN get_page_bundle_header(xml_) LOOP
         count_ := dep_objects_.COUNT + 1;
         dep_objects_(count_).name := UPPER(rec_.MODEL_ID);
         dep_objects_(count_).item_type := 'PAGE_BUNDLE';
      END LOOP;
      
END Get_Deployment_Object_Names;   

PROCEDURE Validate_Import (
   info_               OUT    App_Config_Util_API.AppConfigItemInfo2,
   dep_objects_        IN OUT NOCOPY App_Config_Util_API.DeploymentObjectArray,
   in_xml_             IN     CLOB,
   version_time_stamp_ IN     DATE)
IS 
   xml_                    Xmltype := Xmltype(in_xml_);
   import_rec_             FND_MODEL_DESIGN_TAB%ROWTYPE;
   oldrec_                 FND_MODEL_DESIGN_TAB%ROWTYPE;
   model_id_               FND_MODEL_DESIGN_TAB.model_id%TYPE;
   datarec_                FND_MODEL_DESIGN_DATA_TAB%ROWTYPE;
   in_package_             BOOLEAN;
   import_date_            DATE;
   auth_                   VARCHAR2(1000);
   locked_                 VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   datarec_rowkey_         FND_MODEL_DESIGN_DATA_TAB.rowkey%TYPE;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP;
   info_.exists := 'TRUE';
   App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Validated);
   
   FOR rec_ IN get_page_bundle_header(xml_) LOOP
      import_rec_.model_id := rec_.model_id;
      oldrec_ := Get_Object_By_Keys___(import_rec_.model_id);
      info_.name := rec_.NAME;    
      info_.last_modified_date := Client_Sys.Attr_Value_To_Date(rec_.VERSION);
         
      IF oldrec_.model_id IS NULL THEN
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_, 
            'NO_MODEL: Aurena Page Group not found ":P1"', 
            Fnd_Session_API.Get_Language, import_rec_.model_id), 
            TRUE);
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      ELSE
         
         IF (info_.last_modified_date <> oldrec_.Version) THEN
            import_date_:= App_Config_Package_API.Get_Package_Imported_Date(rec_.model_id); 
            IF import_date_ IS NOT NULL AND nvl(oldrec_.Version, Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: Local changes for Aurena Clinet Model ":P1" will be overwritten', Fnd_Session_API.Get_Language, rec_.model_id), TRUE); 
            END IF;
         END IF;
         
         model_id_ := oldrec_.model_id;
      END IF;
   END LOOP;   
   
   --2. Check for the Exising Layer 2 objects and make a summery. 
   --2.1 Imports.
   FOR rec_ IN get_page_bundle_artifacts(xml_) LOOP
      datarec_ :=  Get_Model_Desing_Draft_Data_By_Keys___(model_id_, rec_.SCOPE_ID ,rec_.DATA_ID );          
      IF datarec_.model_id IS NULL THEN
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_, 
            'CONFIG_NEW: Information: New Aurena Page Configuration Element will be imported, Model :":P1" Element :":P2" Config Context: ":P3"', 
            Fnd_Session_API.Get_Language,model_id_,  rec_.DATA_ID, rec_.SCOPE_ID), 
            TRUE);
      ELSE
         IF INSTR(datarec_.rowkey, ':IMPORTED:') = 1 THEN
            datarec_rowkey_ := SUBSTR(datarec_.rowkey, 11);
         ELSE 
            datarec_rowkey_ := datarec_.rowkey;
         END IF;
         
         IF datarec_rowkey_ <> rec_.ROWKEY THEN
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_, 
            'NCONFIG_EXISTS: Warning: Another version of Aurena Page Configuration Element exist, this version will be replaced, Model :":P1" Element :":P2" Config Context: ":P3"', 
            Fnd_Session_API.Get_Language,model_id_,  rec_.DATA_ID, rec_.SCOPE_ID), 
            TRUE);
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
         ELSE
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_, 
            'ICONFIG_EXISTS: Information: Same Aurena Page Configuration Element found, current version will be updated, Model, Model :":P1" Element :":P2" Config Context: ":P3"', 
            Fnd_Session_API.Get_Language,model_id_,  rec_.DATA_ID, rec_.SCOPE_ID), 
            TRUE);
         END IF;
         App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, datarec_.model_id);
      END IF;
   END LOOP;
   
   --2.2 Info about other layer >=2 artifacts on the same model
 
   FOR db_rec_ IN get_configurations(model_id_, 2) LOOP
      in_package_ := FALSE;
      IF db_rec_.model_id IS NOT NULL THEN
         
         FOR xml_rec_ IN get_page_bundle_artifacts(xml_) LOOP
            IF db_rec_.Data_Id = xml_rec_.DATA_ID AND db_rec_.scope_id = xml_rec_.SCOPE_ID AND db_rec_.layer_no = xml_rec_.LAYER_NO THEN
               in_package_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
         
         IF NOT in_package_ THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_, 
            'OCONFIG_EXISTS: Warning: Other Published local Aurena Page Configuration found these will be removed when publishing the current ACP, Model :":P1" Element :":P2" Config Context: ":P3"', 
            Fnd_Session_API.Get_Language, model_id_,  db_rec_.DATA_ID, db_rec_.SCOPE_ID), 
            TRUE);
         END IF;

      END IF;
   END LOOP;
   
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
   
PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN  CLOB)
IS
   xml_ Xmltype := Xmltype(in_xml_);
   artifact_rowkey_ FND_MODEL_DESIGN_DATA_TAB.rowkey%TYPE;
   modelid_ FND_MODEL_DESIGN_TAB.model_id%type;
   dummy_ NUMBER;
   
   CURSOR current_published(model_id_ VARCHAR2) IS
      SELECT t.model_id, t.scope_id, t.data_id
      FROM fnd_model_design_data_tab t
      WHERE layer_no = 2 AND model_id = model_id_;
   
   CURSOR current_drafts(model_id_ IN VARCHAR2, scope_id_ IN VARCHAR2, data_id_ IN VARCHAR2) IS
      SELECT 1
      FROM fnd_model_design_data_tab
      WHERE layer_no = 90
      AND model_id = model_id_ AND scope_id = scope_id_ 
      AND data_id = data_id_ AND layer_no = 90;
         
BEGIN
   identical_ := FALSE;
   FOR model_rec_ IN get_page_bundle_header(xml_) LOOP
      
      modelid_:= Get_Model_Id___(model_rec_.model_id, model_rec_.reference, model_rec_.kind);
      
      
      IF modelid_ IS NULL THEN
         -- add the model header
         Add_Model_Design___ (
                     model_rec_.model_id,
                     model_rec_.description,
                     model_rec_.artifact,
                     model_rec_.name,
                     model_rec_.kind,
                     model_rec_.reference,
                     model_rec_.version,
                     model_rec_.template);
      END IF;  

      --Initial check of the atrifacts
      FOR data_rec_ IN get_page_bundle_artifacts(xml_) LOOP
         artifact_rowkey_ := Get_Artifact_Objkey(model_rec_.MODEL_ID, data_rec_.SCOPE_ID, data_rec_.DATA_ID);
         IF artifact_rowkey_ IS NULL THEN
            App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_
                                                                          ,'CONFIG_ADDED_IMPORT: Information: Configuration added , Model :":P1" Element :":P2" Config Context: ":P3" '
                                                                          , Fnd_Session_API.Get_Language, model_rec_.model_id, data_rec_.DATA_ID, data_rec_.SCOPE_ID));
         ELSIF artifact_rowkey_ <> data_rec_.ROWKEY THEN
            App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(Model_Design_SYS.lu_name_
                                                                          ,'CONFIG_EXISTS_IMPORT: Warning: Import: Existing Configuration replaced , Model :":P1" Element :":P2" Config Context: ":P3" '
                                                                          , Fnd_Session_API.Get_Language, model_rec_.model_id, data_rec_.DATA_ID, data_rec_.SCOPE_ID));
         END IF;
      END LOOP;
      
      --Remove all existing drafts for this model
      FOR db_rec_ IN get_configurations(modelid_, 90) LOOP
         model_design_sys.delete_config_content(db_rec_.model_id,
                                                db_rec_.scope_id,
                                                db_rec_.data_id,
                                                db_rec_.layer_no);
      END LOOP;
      
      -- Import : We have to assume that all metadata Dependencies are included. and old definitions should be replaced. warnings are given in the validation.
      FOR data_rec_ IN get_page_bundle_artifacts(xml_) LOOP
         Model_Design_SYS.Save_Config_Content(model_rec_.MODEL_ID, data_rec_.SCOPE_ID, data_rec_.DATA_ID, data_rec_.CONTENT, ':IMPORTED:'||data_rec_.ROWKEY, layer_no_=> 90, visibility_=> 'Draft');
      END LOOP;
      
      -- Import post step: Masking the none ACP included, but Already Published as 
      FOR cpublished_ IN current_published(modelid_) LOOP
            OPEN current_Drafts(cpublished_.model_id, cpublished_.scope_id, cpublished_.data_id);
            FETCH current_Drafts INTO dummy_;
            IF current_Drafts%NOTFOUND THEN
               model_design_util_api.revert_draft_configuration(cpublished_.model_id,
                                                   cpublished_.scope_id,
                                                   cpublished_.data_id);
            END IF;
            CLOSE current_Drafts;
      END LOOP;
      
      configuration_item_id_ :=model_rec_.MODEL_ID;
   END LOOP;
END Import;

PROCEDURE Publish_Draft_Configurations (
      model_id_ IN VARCHAR2,
      scope_id_ IN VARCHAR2 ) 
IS
      CURSOR Get_Drafts (model_id_ VARCHAR2) IS      
         SELECT t.* from FND_MODEL_DESIGN_DATA_TAB t
         WHERE t.model_id = model_id_ AND t.layer_no = 90 AND scope_id = scope_id_ AND t.visibility = 'Draft';
      
      CURSOR Get_Pending_Deletes (model_id_ VARCHAR2) IS      
         SELECT t.model_id,
          t.scope_id,
          t.data_id,
          t.layer_no from FND_MODEL_DESIGN_DATA_TAB t
         WHERE t.model_id = model_id_ AND t.layer_no = 90 AND scope_id = scope_id_ AND t.visibility = 'Reverted';
   
BEGIN
      FOR data_ IN Get_Pending_Deletes(model_id_) LOOP
         -- Removed Deleted published artifacts
         Model_Design_SYS.Delete_config_content(data_.model_id, nvl(data_.scope_id,'global'), data_.data_id, 2);
         -- Removed Revereted Drafts
         Model_Design_SYS.Delete_config_content(data_.model_id, nvl(data_.scope_id,'global'), data_.data_id, 90);
      END LOOP;
      
      FOR data_ IN Get_Drafts(model_id_) LOOP
         Model_Design_SYS.Save_Config_Content(data_.model_id, nvl(data_.scope_id,'global'), data_.data_id, data_.content, layer_no_=> 2, visibility_=> 'Public');
         Model_Design_SYS.Toggle_Visibility(data_.model_id, nvl(data_.scope_id,'global'), data_.data_id, 90, 'Public');
      END LOOP;
      
      Model_Design_SYS.Use_Profiled_Data(model_id_);
      
END Publish_Draft_Configurations;
   
PROCEDURE Revert_Draft_Configuration (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2 )
IS
   core_row_key_  VARCHAR2(50) := NULL;
   core_content_  CLOB;
   layer_two_key_ VARCHAR2(50) := NULL;   
BEGIN
   
   SELECT rowkey 
   INTO layer_two_key_
   FROM FND_MODEL_DESIGN_DATA_TAB t
   WHERE t.model_id = model_id_ AND t.scope_id = scope_id_ AND t.data_id = data_id_ AND t.layer_no = 2;
   
      BEGIN
         SELECT rowkey, content 
         INTO core_row_key_, core_content_
         FROM FND_MODEL_DESIGN_DATA_TAB t
         WHERE t.model_id = model_id_ AND t.scope_id = scope_id_ AND t.data_id = data_id_ AND t.layer_no = 1;

         IF core_row_key_ IS NOT NULL THEN
            --shadow it from a core content
            Model_Design_SYS.Save_Config_Content(model_id_, nvl(scope_id_,'global'), data_id_, core_content_, layer_no_=> 90, visibility_=> 'Reverted');
         END IF;   
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
               BEGIN
                  -- No core element. try to shadow with an empty  
                  Model_Design_SYS.Save_Config_Content(model_id_, nvl(scope_id_,'global'), data_id_, empty_clob(), layer_no_=> 90, visibility_=> 'Reverted');
               END;
      END;   
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         BEGIN
            Model_Design_SYS.Delete_config_content(model_id_, scope_id_, data_id_, 90);
         END;
END Revert_Draft_Configuration;

FUNCTION Get_Artifact_Objkey (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER DEFAULT 2) RETURN VARCHAR2
IS
   rowkey_ FND_MODEL_DESIGN_DATA_TAB.rowkey%TYPE;
BEGIN
   SELECT rowkey
      INTO  rowkey_
      FROM  FND_MODEL_DESIGN_DATA_TAB
      WHERE model_id = model_id_
      AND   scope_id = scope_id_
      AND   data_id = data_id_
      AND   layer_no = layer_no_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___('ModelDesignUtil', 'Get_Artifact_Objkey');
END Get_Artifact_Objkey;

PROCEDURE Raise_Too_Many_Rows___ (
   lu_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(lu_),Formatted_Key___(lu_));
   Error_SYS.Fnd_Too_Many_Rows(Model_Design_SYS.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


FUNCTION Key_Message___ (
   lu_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'LU', lu_);
   RETURN msg_;
END Key_Message___;


FUNCTION Formatted_Key___ (
   lu_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'LU', Fnd_Session_API.Get_Language) || ': ' || lu_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

FUNCTION Get_Data_Version (
   model_id_ IN VARCHAR2 ) RETURN DATE
IS
   version_     DATE;
BEGIN
   SELECT max(version)
   INTO version_
   FROM fnd_model_design_tab
   WHERE model_id = model_id_;
   RETURN version_;
END Get_Data_Version;

FUNCTION Get_Model_Description (
   model_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_     fnd_model_design_tab.description%type;
BEGIN
   SELECT description
   INTO description_
   FROM fnd_model_design_tab
   WHERE model_id = model_id_;
   RETURN description_;
END Get_Model_Description;


FUNCTION Get_Model_Name (
   model_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_     fnd_model_design_tab.name%type;
BEGIN
   SELECT name
   INTO name_
   FROM fnd_model_design_tab
   WHERE model_id = model_id_;
   RETURN name_;
END Get_Model_Name;


FUNCTION Get_Model_Design_Data_Ref (
   model_id_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   reference_ FND_MODEL_DESIGN_TAB.reference%type;
BEGIN
   SELECT t.reference INTO reference_
   FROM FND_MODEL_DESIGN_TAB t
   WHERE t.model_id = model_id_;
   RETURN model_id_;
EXCEPTION 
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Model_Design_Data_Ref;


FUNCTION Get_Model_Id___ (
   model_id_ IN VARCHAR2,
   reference_ IN VARCHAR2,
   kind_ IN VARCHAR2)  RETURN VARCHAR2
IS
   modelid_ FND_MODEL_DESIGN_TAB.model_id%type;
   
BEGIN
   
   SELECT model_id INTO modelid_
   FROM FND_MODEL_DESIGN_TAB
   WHERE model_id = model_id_
   AND   reference = reference_
   AND   kind = kind_;
   
   RETURN modelid_;

EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Model_Id___;


PROCEDURE Add_Model_Design___ (
   model_id_ IN VARCHAR2,
   description_ IN VARCHAR2,
   artifact_ IN VARCHAR2,
   name_ IN VARCHAR2,
   kind_ IN VARCHAR2,
   reference_ IN VARCHAR2,
   version_ IN VARCHAR2,
   template_ IN CLOB) 
IS
   rec_ FND_MODEL_DESIGN_TAB%ROWTYPE;
   
BEGIN
   
   rec_.model_id := model_id_;
   rec_.description := description_;
   rec_.artifact := artifact_;
   rec_.name := name_;
   rec_.kind := kind_;
   rec_.reference := reference_;
   rec_.profiled := 'FALSE';
   rec_.version := to_date(version_, Client_SYS.date_format_);
   rec_.template := template_;
   
   INSERT 
   INTO FND_MODEL_DESIGN_TAB
   VALUES rec_;
   
END Add_Model_Design___;