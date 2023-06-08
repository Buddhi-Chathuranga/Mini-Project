-----------------------------------------------------------------------------
--
--  Logical unit: ModelDesign
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211006  CHAALK  Aurena Order Report is not translated (OR21R2-401)
-----------------------------------------------------------------------------

layer Foundation1;

@AllowTableOrViewAccess fnd_model_design_tab
@AllowTableOrViewAccess fnd_model_design_data_tab

-------------------- PUBLIC DECLARATIONS ------------------------------------

CLIENT_METADATA        CONSTANT VARCHAR2(50) := 'ClientMetadata';
SERVER_METADATA        CONSTANT VARCHAR2(50) := 'ServerMetadata';

ARTIFACT_PROJECTION    CONSTANT VARCHAR2(10) := 'projection';
ARTIFACT_CLIENT        CONSTANT VARCHAR2(10) := 'client';
ARTIFACT_OUTBOUND      CONSTANT VARCHAR2(10) := 'outbound';
ARTIFACT_APP           CONSTANT VARCHAR2(10) := 'app';

GLOBAL_SCOPE           CONSTANT VARCHAR2(10) := 'global';
DEVELOPER_STUDIO_MODEL CONSTANT VARCHAR2(50) := 'DeveloperStudioModel';
CONFIG_CORE_LAYER      CONSTANT NUMBER       := 1;
CONFIG_PUBLISHED_LAYER CONSTANT NUMBER       := 2;
RUNTIME_MAX_LAYER      CONSTANT NUMBER       := 79;
CONFIG_DRAFT_LAYER     CONSTANT NUMBER       := 90;

TYPE Fnd_Model_Id_Rec IS RECORD (
   kind                  fnd_model_design_tab.kind%TYPE,
   artifact              fnd_model_design_tab.artifact%TYPE,
   name                  fnd_model_design_tab.name%TYPE);

TYPE Fnd_Model_Design_Rec IS RECORD (
   model_id              fnd_model_design_tab.model_id%TYPE,
   description           fnd_model_design_tab.description%TYPE,
   artifact              fnd_model_design_tab.artifact%TYPE,
   name                  fnd_model_design_tab.name%TYPE,
   kind                  fnd_model_design_tab.kind%TYPE,
   reference             fnd_model_design_tab.reference%TYPE,
   profiled              fnd_model_design_tab.profiled%TYPE,
   version               fnd_model_design_tab.version%TYPE
   );

TYPE Fnd_Model_Design_Data_Rec IS RECORD (
   model_id              fnd_model_design_data_tab.model_id%TYPE,
   scope_id              fnd_model_design_data_tab.scope_id%TYPE,
   data_id               fnd_model_design_data_tab.data_id%TYPE,
   artifact              fnd_model_design_data_tab.artifact%TYPE,
   name                  fnd_model_design_data_tab.name%TYPE,
   line_no               fnd_model_design_data_tab.line_no%TYPE,
   layer_no              fnd_model_design_data_tab.layer_no%TYPE,
   content               fnd_model_design_data_tab.content%TYPE,
   content_hash          fnd_model_design_data_tab.content_hash%TYPE,
   based_on_content      fnd_model_design_data_tab.content%TYPE,
   based_on_content_hash fnd_model_design_data_tab.content_hash%TYPE,
   reference             fnd_model_design_data_tab.reference%TYPE,
   visibility            fnd_model_design_data_tab.visibility%TYPE,
   dependencies          fnd_model_design_data_tab.dependencies%TYPE,
   objkey                fnd_model_design_data_tab.rowkey%TYPE
   );
   
TYPE Fnd_Model_Api_Doc_Rec IS RECORD (
   model_id              fnd_model_api_doc_tab.model_id%TYPE,
   description           fnd_model_api_doc_tab.description%TYPE,
   name                  fnd_model_api_doc_tab.name%TYPE,
   version               fnd_model_api_doc_tab.version%TYPE
   );
   
-------------------- PRIVATE DECLARATIONS -----------------------------------

MODEL_CLIENT_METADATA_CLIENT     CONSTANT VARCHAR2(30) := CLIENT_METADATA || '.' || ARTIFACT_CLIENT || ':';
MODEL_CLIENT_METADATA_PROJECTION CONSTANT VARCHAR2(30) := CLIENT_METADATA || '.' || ARTIFACT_PROJECTION || ':';
MODEL_SERVER_METADATA_PROJECTION CONSTANT VARCHAR2(30) := SERVER_METADATA || '.' || ARTIFACT_PROJECTION || ':';

-------------------- DATA LOADING FROM MODELS -------------------------------

FUNCTION Resolve_Model_Id_ (
   model_id_ IN VARCHAR2 ) RETURN Fnd_Model_Id_Rec
IS
   rec_ Fnd_Model_Id_Rec;
   d_   NUMBER := INSTR(model_id_, '.');
   k_   NUMBER := INSTR(model_id_, ':');
BEGIN
   IF ((model_id_ IS NULL) OR (d_ = 0) OR (k_ = 0)) THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_MODELID: Model ID '':P1'' is not valid!', model_id_);
   END IF;
   
   rec_.kind := SUBSTR(model_id_, 1, d_-1);
   IF (rec_.kind NOT IN (CLIENT_METADATA, SERVER_METADATA)) THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_KIND: Model Kind '':P1'' ('':P2'') is not valid!', rec_.kind, model_id_);
   END IF;
   
   rec_.artifact := SUBSTR(model_id_, d_+1, k_-d_-1);
   IF (rec_.artifact NOT IN (ARTIFACT_PROJECTION, ARTIFACT_CLIENT, ARTIFACT_APP, ARTIFACT_OUTBOUND)) THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_ARTIFACT: Model Artifact '':P1'' ('':P2'') is not valid!', rec_.artifact, model_id_);
   END IF;
   
   rec_.name := SUBSTR(model_id_, k_+1);
   RETURN rec_;
END Resolve_Model_Id_;

FUNCTION Check_Exist (
   model_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(model_id_);
END Check_Exist;

FUNCTION Prepare_Design_Data_Load (
   artifact_    IN VARCHAR2,
   name_        IN VARCHAR2,
   kind_        IN VARCHAR2,
   description_ IN VARCHAR2 ) RETURN Fnd_Model_Design_Rec
IS
   header_   Fnd_Model_Design_Rec;
   model_id_ fnd_model_design.model_id%TYPE := Format_Model_Id___(kind_, artifact_, name_);
BEGIN
   BEGIN
      --Fetch any existing model design header
      SELECT *
         INTO  header_
         FROM  fnd_model_design
         WHERE model_id = model_id_
         FOR UPDATE NOWAIT;
      header_.description := description_;
      header_.version     := systimestamp;
      UPDATE fnd_model_design_tab
            SET version = header_.version,
                description = header_.description
            WHERE model_id = model_id_;
   EXCEPTION
   --Insert new if old header does not exist
      WHEN NO_DATA_FOUND THEN 
         BEGIN
            INSERT
               INTO fnd_model_design_tab (
               model_id,
               artifact,
               Name,
               kind,
               description,
               version)
            VALUES (
               model_id_,
               artifact_,
               name_,
               kind_,
               description_,
               systimestamp);
         END;
      
      SELECT *
         INTO  header_
         FROM  fnd_model_design
         WHERE model_id = model_id_;
   END;
   --Delete any existing model design data rows for bottom layer
   DELETE
      FROM fnd_model_design_data_tab
      WHERE model_id = header_.model_id
      AND   layer_no = CONFIG_CORE_LAYER;
   --Return header record
   RETURN header_;
END Prepare_Design_Data_Load ;


FUNCTION Prepare_Doc_Load (
   artifact_    IN VARCHAR2,
   name_        IN VARCHAR2,
   kind_        IN VARCHAR2,
   description_ IN VARCHAR2 ) RETURN Fnd_Model_Api_Doc_Rec
IS
   header_   Fnd_Model_Api_Doc_Rec;
   model_id_ fnd_model_api_doc.model_id%TYPE := Format_Model_Id___(kind_, artifact_, name_);
BEGIN
   BEGIN
      --Fetch any existing model design header
      SELECT *
         INTO  header_
         FROM  fnd_model_api_doc
         WHERE model_id = model_id_
         FOR UPDATE NOWAIT;
      header_.description := description_;
      header_.version     := systimestamp;
      UPDATE fnd_model_api_doc_tab
            SET version = header_.version,
                description = header_.description
            WHERE model_id = model_id_;
   EXCEPTION
   --Insert new if old header does not exist
      WHEN NO_DATA_FOUND THEN 
         BEGIN
            INSERT
               INTO fnd_model_api_doc_tab (
               model_id,
               Name,
               description,
               version)
            VALUES (
               model_id_,
               name_,
               description_,
               systimestamp);
         END;
      
      SELECT *
         INTO  header_
         FROM  fnd_model_api_doc
         WHERE model_id = model_id_;
   END;
   RETURN header_;
END Prepare_Doc_Load;


PROCEDURE Add_Model_Design_Data_Ref (
   header_   IN Fnd_Model_Design_Rec,
   artifact_ IN VARCHAR2,
   name_     IN VARCHAR2,
   kind_     IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET reference = kind_||'.'||artifact_||':'||name_
      WHERE model_id = header_.model_id;
END Add_Model_Design_Data_Ref;

PROCEDURE Append_Model_Design_Data_Ref (
   header_   IN Fnd_Model_Design_Rec,
   artifact_ IN VARCHAR2,
   name_     IN VARCHAR2,
   kind_     IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET reference = reference ||','|| kind_||'.'||artifact_||':'||name_
      WHERE model_id = header_.model_id;
END Append_Model_Design_Data_Ref;


PROCEDURE Add_Model_Design_Template (
   header_      IN Fnd_Model_Design_Rec,
   template_    IN CLOB )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET template = template_
      WHERE model_id = header_.model_id;
END Add_Model_Design_Template;

PROCEDURE Add_Model_Design_Template (
   header_     IN Fnd_Model_Design_Rec,
   template_   IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET template = template_
      WHERE model_id = header_.model_id;
END Add_Model_Design_Template;

PROCEDURE Add_Model_API_Doc_Template (
   header_      IN Fnd_Model_api_Doc_Rec,
   template_    IN CLOB )
IS
BEGIN
   UPDATE fnd_model_api_doc_tab
      SET template = template_
      WHERE model_id = header_.model_id;
END Add_Model_API_Doc_Template;

PROCEDURE Add_Model_API_Doc_Template (
   header_     IN Fnd_Model_Api_Doc_Rec,
   template_   IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_api_doc_tab
      SET template = template_
      WHERE model_id = header_.model_id;
END Add_Model_API_Doc_Template;

FUNCTION Add_Model_Design_Data_Row___ (
   row_ IN OUT NOCOPY fnd_model_design_data_tab%ROWTYPE) RETURN Fnd_Model_Design_Data_Rec
IS
   result_ Fnd_Model_Design_Data_Rec;
BEGIN
   IF (row_.content_hash IS NULL) THEN
      row_.content_hash := Calc_Hash___(row_.content);      
   END IF;
   IF (row_.layer_no > 1 AND row_.based_on_content_hash IS NULL) THEN
      row_.based_on_content_hash := Calc_Hash___(row_.based_on_content);      
   END IF;

   row_.rowversion := sysdate;   
   -- Rowkey and Visibility with defined default values.   
   INSERT 
      INTO fnd_model_design_data_tab 
      VALUES row_ 
      RETURNING rowkey, visibility INTO result_.objkey, result_.visibility;

   -- Table to View conversion.
   result_.model_id              := row_.model_id;
   result_.data_id               := row_.data_id;
   result_.scope_id              := row_.scope_id;
   result_.artifact              := row_.artifact;
   result_.name                  := row_.name;
   result_.layer_no              := row_.layer_no;
   result_.line_no               := row_.line_no;
   result_.reference             := row_.reference;
   result_.content               := row_.content;
   result_.content_hash          := row_.content_hash;
   result_.based_on_content      := row_.based_on_content;
   result_.based_on_content_hash := row_.based_on_content_hash;
   result_.dependencies          := row_.dependencies;
   RETURN result_;       
END Add_Model_Design_Data_Row___;

FUNCTION Add_Model_Design_Data_Row (
   header_     IN Fnd_Model_Design_Rec,
   artifact_   IN VARCHAR2,
   name_       IN VARCHAR2,
   line_no_    IN NUMBER,
   dependency_ IN VARCHAR2,
   content_    IN CLOB,
   scope_id_   IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   layer_no_   IN NUMBER   DEFAULT  1 ) RETURN Fnd_Model_Design_Data_Rec
IS
   data_ fnd_model_design_data_tab%ROWTYPE;
BEGIN
   data_.model_id     := header_.model_id;
   data_.data_id      := artifact_||':'||name_;
   data_.scope_id     := scope_id_;
   data_.artifact     := artifact_;
   data_.name         := name_;
   data_.layer_no     := layer_no_;
   data_.line_no      := line_no_;
   data_.content      := content_;
   data_.dependencies := dependency_;
   data_.visibility   := 'Public';
   RETURN Add_Model_Design_Data_Row___(data_);
END Add_Model_Design_Data_Row;

FUNCTION Add_Model_Design_Data_Row (
   header_     IN Fnd_Model_Design_Rec,
   artifact_   IN VARCHAR2,
   name_       IN VARCHAR2,
   line_no_    IN NUMBER,
   dependency_ IN VARCHAR2,
   content_    IN VARCHAR2,
   scope_id_   IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   layer_no_   IN NUMBER   DEFAULT  1 ) RETURN Fnd_Model_Design_Data_Rec
IS
   data_ fnd_model_design_data_tab%ROWTYPE;
BEGIN
   data_.model_id     := header_.model_id;
   data_.data_id      := artifact_||':'||name_;
   data_.scope_id     := scope_id_;
   data_.artifact     := artifact_;
   data_.name         := name_;
   data_.layer_no     := layer_no_;
   data_.line_no      := line_no_;
   data_.content      := content_;
   data_.dependencies := dependency_;
   data_.visibility   := 'Public';
   RETURN Add_Model_Design_Data_Row___(data_);
END Add_Model_Design_Data_Row;


FUNCTION Add_Model_Design_Data_Row (
   parent_     IN Fnd_Model_Design_Data_Rec,
   artifact_   IN VARCHAR2,
   name_       IN VARCHAR2,
   line_no_    IN NUMBER,
   dependency_ IN VARCHAR2,
   content_    IN CLOB, 
   layer_no_   IN NUMBER   DEFAULT  1 ) RETURN Fnd_Model_Design_Data_Rec
IS
   data_   fnd_model_design_data_tab%ROWTYPE;
BEGIN
   data_.model_id        := parent_.model_id;
   data_.data_id         := artifact_||':'||name_;
   data_.scope_id        := parent_.scope_id||'.'||parent_.data_id;
   data_.artifact        := artifact_;
   data_.name            := name_;
   data_.layer_no        := layer_no_;
   data_.line_no         := line_no_;
   data_.content         := content_;
   data_.dependencies    := dependency_;
   data_.visibility      := 'Public';
   RETURN Add_Model_Design_Data_Row___(data_);
END Add_Model_Design_Data_Row;

FUNCTION Get_Projection_Version_ (
   projection_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Data_Version_(SERVER_METADATA, ARTIFACT_PROJECTION, projection_name_);
END Get_Projection_Version_;

FUNCTION Get_Template_Version_ (
   template_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   template_version_ VARCHAR2(200);
     
   CURSOR get_template_version IS
      SELECT REGEXP_SUBSTR(description, 'Version=(\d)+')
      FROM fnd_model_design_tab
      WHERE (model_id = 'ServerMetadata.projection:' || template_name_);
BEGIN
   OPEN get_template_version;
   FETCH get_template_version INTO template_version_;
   CLOSE get_template_version;
      
   RETURN NVL(template_version_, 'Version=0');
END Get_Template_Version_;
   

FUNCTION Get_Client_Component_(client_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   template_ CLOB;
   CURSOR get_component IS
      SELECT REGEXP_SUBSTR(template, '"component":\s*"[^"]+"')
         FROM fnd_model_design_tab
         WHERE model_id = CLIENT_METADATA || '.client:' || client_name_;
BEGIN
  OPEN  get_component;
  FETCH get_component INTO template_;
  CLOSE get_component;
  
  RETURN replace(substr(template_, 14), '"', '');
END Get_Client_Component_;

PROCEDURE Clone_Template_Into_Model_ (
   template_name_    IN VARCHAR2,
   cloned_name_      IN VARCHAR2,
   cloned_id_        IN VARCHAR2,
   cloned_component_ IN VARCHAR2,
   cloned_condition_ IN VARCHAR2)
IS
   template_version_ VARCHAR2(200) := Get_Template_Version_(template_name_);
BEGIN
   DELETE
      FROM fnd_model_design_tab
      WHERE (model_id = 'ClientMetadata.client:'||cloned_name_
          OR model_id = 'ClientMetadata.projection:'||cloned_name_
          OR model_id = 'ServerMetadata.projection:'||cloned_name_);
          
   DELETE
      FROM fnd_model_design_data_tab
      WHERE (model_id = 'ClientMetadata.client:'||cloned_name_
          OR model_id = 'ClientMetadata.projection:'||cloned_name_
          OR model_id = 'ServerMetadata.projection:'||cloned_name_)
      AND   layer_no = CONFIG_CORE_LAYER;
   
   INSERT
      INTO fnd_model_design_tab(
         model_id,
         description,
         artifact,
         name,
         kind,
         reference,
         profiled,
         version,
         template)
      SELECT 
         replace(model_id, template_name_, cloned_name_),
         'cloned '||cloned_name_||' from '||template_name_||' '||template_version_,
         artifact,
         cloned_name_,
         kind,
         reference,
         profiled,
         systimestamp,
         replace(replace(template, template_name_, cloned_name_), '$CLONED_ID$', cloned_id_)
      FROM fnd_model_design_tab
      WHERE (model_id = 'ClientMetadata.client:'||template_name_
          OR model_id = 'ClientMetadata.projection:'||template_name_
          OR model_id = 'ServerMetadata.projection:'||template_name_);

   -- The component must be updated as the template defines it using 'FNDBAS'.
   IF (NOT UPPER(cloned_component_) = 'FNDBAS') THEN      
      UPDATE fnd_model_design_tab
         SET template = replace(template, ',"component": "FNDBAS","version"', ',"component": "' || UPPER(cloned_component_) || '","version"')
         WHERE model_id = MODEL_CLIENT_METADATA_CLIENT || cloned_name_;
   END IF;      
          
   INSERT
      INTO fnd_model_design_data_tab(
         model_id,
         scope_id,
         data_id,
         artifact,
         name,
         line_no,
         layer_no,
         content,
         content_hash,
         reference,
         visibility,
         dependencies,
         rowversion)
      SELECT 
         replace(model_id, template_name_, cloned_name_),
         scope_id,
         data_id,
         artifact,
         name,
         line_no,
         layer_no,
         replace(replace(replace(content, template_name_, cloned_name_), '$CLONED_ID$', cloned_id_), '''$CLONED_CONDITION$''', cloned_condition_),
         content_hash,
         reference,
         visibility,
         dependencies,
         SYSDATE
      FROM fnd_model_design_data_tab
      -- TODO: Only ClientMetadata.client is possible?!?
      WHERE (model_id = 'ClientMetadata.client:'||template_name_
          OR model_id = 'ClientMetadata.projection:'||template_name_
          OR model_id = 'ServerMetadata.projection:'||template_name_)
      AND   layer_no = CONFIG_CORE_LAYER;

   Revert_Using_Template_Translations___(cloned_name_);
   Calc_Template_Content_Hash___(cloned_name_);
   
END Clone_Template_Into_Model_;

-- Change back the Operational Report translation data to point to the OrderReprotTemplate generic translations
-- which is replaced by the Clone_Template_Into_Model_ which will make translations point to none existing translations 
-- and making translation not work for the cloned dynamic Operational Report parameter pages.
PROCEDURE Revert_Using_Template_Translations___ (
   cloned_name_ IN VARCHAR2)
IS
BEGIN
   UPDATE fnd_model_design_data_tab
      SET content = REGEXP_REPLACE(content, '(\[#\[translatesys:[^:]+:)' || cloned_name_ || '\.', '\1OrderReportTemplate.')
      WHERE model_id = 'ClientMetadata.client:' || cloned_name_
      AND layer_no = CONFIG_CORE_LAYER;
END Revert_Using_Template_Translations___;

PROCEDURE Calc_Template_Content_Hash___ (
   cloned_name_ IN VARCHAR2)
IS
BEGIN
   UPDATE fnd_model_design_data_tab
      SET content_hash = dbms_crypto.Hash(content, dbms_crypto.HASH_SH1)
      WHERE (model_id = 'ClientMetadata.client:' || cloned_name_)
      AND layer_no = CONFIG_CORE_LAYER;
END Calc_Template_Content_Hash___;

-------------------- DATA STAGING --------------------------------------------


PROCEDURE Refresh_Projection_Version (
   projection_name_ IN VARCHAR2 )
IS
BEGIN
   Refresh_Artifact_Type_Version___(ARTIFACT_PROJECTION, projection_name_);
END Refresh_Projection_Version ;

PROCEDURE Refresh_Client_Version (
   client_name_ IN VARCHAR2 )
IS
BEGIN
   Refresh_Artifact_Type_Version___(ARTIFACT_CLIENT, client_name_);
END Refresh_Client_Version ;

PROCEDURE Refresh_Artifact_Type_Version___ (
   artifact_type_ IN VARCHAR2,
   artifact_name_ IN VARCHAR2 )
IS
BEGIN
   IF artifact_name_ = '*' THEN
      UPDATE fnd_model_design_tab
         SET version = SYSTIMESTAMP
         WHERE artifact = artifact_type_;
   ELSE
      UPDATE fnd_model_design_tab
         SET version = SYSTIMESTAMP
         WHERE 
            model_id = 'ServerMetadata.' || artifact_type_ || ':' || artifact_name_
            OR
            model_id = 'ClientMetadata.' || artifact_type_ || ':' || artifact_name_;
   END IF;
END Refresh_Artifact_Type_Version___ ;

FUNCTION Get_Artifact___ (
   model_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   artifact_    fnd_model_design_tab.artifact%TYPE;

   CURSOR get_artifact IS
      SELECT artifact
      FROM   fnd_model_design_tab
      WHERE  model_id = model_id_;
BEGIN
   OPEN get_artifact;
   FETCH get_artifact INTO artifact_;
   CLOSE get_artifact;
   
   RETURN artifact_;
END Get_Artifact___;

PROCEDURE Refresh_Version (
   model_id_ IN VARCHAR2 )
IS
BEGIN
   Refresh_Artifact_Type_Version___(Get_Artifact___(model_id_), SUBSTR(model_id_, INSTR(model_id_, ':') + 1));
END Refresh_Version ;


PROCEDURE Delete_Config_Content (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2, 
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER DEFAULT CONFIG_DRAFT_LAYER )
IS
BEGIN
   Delete_Data_Row___(model_id_, scope_id_, data_id_, layer_no_);
   Refresh_Version(model_id_);
END Delete_Config_Content;

PROCEDURE Delete_Data_Row___ (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2, 
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER)
IS
BEGIN
   DELETE
      FROM fnd_model_design_data_tab
      WHERE model_id = model_id_
      AND   scope_id = scope_id_
      AND   data_id = data_id_
      AND   layer_no = layer_no_;
END Delete_Data_Row___;

PROCEDURE Save_Config_Content (
   model_id_         IN VARCHAR2,
   scope_id_         IN VARCHAR2,
   data_id_          IN VARCHAR2,
   content_          IN CLOB,
   based_on_content_ IN CLOB     DEFAULT NULL,
   row_key_          IN VARCHAR2 DEFAULT sys_guid(),
   layer_no_         IN NUMBER   DEFAULT CONFIG_DRAFT_LAYER,
   visibility_       IN VARCHAR2 DEFAULT 'Draft',
   schema_version_   IN NUMBER   DEFAULT NULL)
IS
   rec_            fnd_model_design_data_tab%ROWTYPE;
   result_         Fnd_Model_Design_Data_Rec;
   debug_layer_no_ fnd_model_design_data_tab.layer_no%TYPE;
   
   CURSOR get_published_global_content IS
      SELECT content, layer_no
         FROM fnd_model_design_data_tab t1
         WHERE model_id = model_id_
         AND   scope_id = GLOBAL_SCOPE
         AND   data_id  = data_id_
         AND   layer_no = (SELECT   MAX(t2.layer_no)
                           FROM  fnd_model_design_data_tab t2
                           WHERE t2.model_id = t1.model_id
                           AND   t2.data_id  = t1.data_id
                           AND   t2.scope_id = t1.scope_id
                           AND   t2.layer_no != CONFIG_DRAFT_LAYER);
                          
   PROCEDURE Trace(text_ IN VARCHAR2)
   IS
   BEGIN
      Trace_SYS.Message('SCC: ' || text_ || '.');
      NULL;
   END Trace;
BEGIN   
   IF (layer_no_ < 2) THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_LAYER_NO: Layer No must be larger than 1.', model_id_, scope_id_, data_id_);
   END IF;
   IF NOT (dbms_lob.getlength(content_) > 0) THEN
      IF (layer_no_ != CONFIG_DRAFT_LAYER OR visibility_ != 'Reverted') THEN
         Error_SYS.Appl_General(lu_name_, 'CONTENT_EMPTY: Content can not be empty for '':P1'', '':P2'', '':P3''.', model_id_, scope_id_, data_id_);
      END IF;
   END IF;

   Trace('Artifact with Scope = ' || scope_id_ || '. Layer = ' || layer_no_);
   IF (Model_Design_Util_API.Try_Get_Data_Row_(model_id_, scope_id_, data_id_, layer_no_, rec_)) THEN
      Trace('Found Scope and Layer');
      Delete_Data_Row___(model_id_, scope_id_, data_id_, layer_no_);
   ELSIF (Model_Design_Util_API.Try_Get_Data_Row_(model_id_, scope_id_, data_id_, CONFIG_CORE_LAYER, rec_)) THEN
      Trace('Found Core');
   ELSE
      Trace('Not found');
      rec_.model_id     := model_id_;
      rec_.scope_id     := scope_id_;
      rec_.data_id      := data_id_;      
      rec_.artifact     := SUBSTR(data_id_, 1,INSTR(data_id_,':')-1); 
      rec_.name         := SUBSTR(data_id_, INSTR(data_id_,':')+1);
      -----------------------------------------------------------            
      rec_.line_no      := 99999; -- Dummy value since the line_no has no meaning
      rec_.reference    := NULL;
      rec_.dependencies := NULL;
   END IF;
     
   rec_.content         := content_;
   rec_.content_hash    := NULL;
   rec_.layer_no        := layer_no_;
   rec_.visibility      := visibility_;
   rec_.schema_version  := schema_version_;
   rec_.rowkey          := row_key_;
   rec_.schema_version  := schema_version_;

   IF (dbms_lob.getlength(based_on_content_) > 0) THEN
      rec_.based_on_content      := based_on_content_;
      rec_.based_on_content_hash := NULL;
      Trace('based_on_content explicitly defined');
   ELSIF (dbms_lob.getlength(rec_.based_on_content) > 0) THEN
      Trace('based_on_content already defined, reuse');
   ELSE
      OPEN get_published_global_content;
      FETCH get_published_global_content INTO rec_.based_on_content, debug_layer_no_;
      CLOSE get_published_global_content;
      rec_.based_on_content_hash := NULL;      
      Trace('based_on_content defined using published global artifact in layer_no = ' || debug_layer_no_);
   END IF;

   result_ := Add_Model_Design_Data_Row___(rec_);
   Refresh_Version(model_id_);
END Save_Config_Content;
                                      
PROCEDURE Use_Profiled_Data (
   model_id_ IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET profiled = 'TRUE'
      WHERE model_id = model_id_;
   Refresh_Version(model_id_);
END Use_Profiled_Data;


PROCEDURE Use_Original_Data (
   model_id_ IN VARCHAR2 )
IS
BEGIN
   UPDATE fnd_model_design_tab
      SET profiled = 'FALSE'
      WHERE model_id = model_id_;
   Refresh_Version(model_id_);
END Use_Original_Data;

-------------------- GENERIC DATA PROVIDER -----------------------------------

FUNCTION Get_Offline_Data_Content_ (
   data_format_ IN VARCHAR2,
   model_type_  IN VARCHAR2,
   model_name_  IN VARCHAR2,
   scope_id_    IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   language_    IN VARCHAR2 DEFAULT NULL,
   max_layer_   IN NUMBER   DEFAULT RUNTIME_MAX_LAYER ) RETURN CLOB
IS
BEGIN
   RETURN Get_Data_Content_(data_format_, model_type_, model_name_, scope_id_, NVL(language_, Fnd_Session_API.Get_Language), 'offline', max_layer_);
END Get_Offline_Data_Content_;


PROCEDURE Metadata_Dynamic_References (
   output_         IN OUT CLOB,
   text_           IN     CLOB,
   start_pos_      IN     INTEGER,
   from_pos_       IN     INTEGER,
   to_pos_         IN OUT INTEGER,
   scope_id_       IN     VARCHAR2 )
IS
   parameter_ VARCHAR2(32000);
BEGIN
   IF (from_pos_ >= start_pos_) THEN
      to_pos_ := Dbms_Lob.instr(text_, ']#]', from_pos_)+3;
      parameter_ := Dbms_Lob.substr(text_, to_pos_-from_pos_-6, from_pos_+3);
      CASE Link_Name___(parameter_)
         WHEN 'jsoncallback' THEN
            Append_Clob___(output_, text_, start_pos_, from_pos_);
            Add_Json_Comma___(output_);
            Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), scope_id_));
            Remove_Json_Comma___(output_);
      END CASE;
   END IF;
END Metadata_Dynamic_References;

FUNCTION Get_Baseline_Content_ (
   model_id_            IN VARCHAR2,
   scope_id_            IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   exclude_projection_  IN BOOLEAN  DEFAULT FALSE) RETURN CLOB
IS
   rec_    Fnd_Model_Id_Rec := Resolve_Model_Id_(model_id_);
   output_ CLOB;
BEGIN
   output_ := Get_Data_Content_Impl___ (
      rec_.kind,
      rec_.artifact,
      rec_.name,
      scope_id_,
      language_            => '',
      post_processing_     => NULL,
      max_layer_           => CONFIG_DRAFT_LAYER,
      include_unpublished_ => TRUE,
      exclude_projection_  => exclude_projection_,
      baseline_            => TRUE);
      
   RETURN output_;      
END Get_Baseline_Content_;

FUNCTION Get_Data_Content_ (
   model_id_                IN VARCHAR2,
   scope_id_                IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   language_                IN VARCHAR2 DEFAULT NULL,
   post_processing_         IN VARCHAR2 DEFAULT NULL,
   max_layer_               IN NUMBER   DEFAULT RUNTIME_MAX_LAYER, 
   include_unpublished_     IN BOOLEAN  DEFAULT FALSE, 
   exclude_projection_      IN BOOLEAN  DEFAULT FALSE) RETURN CLOB
IS
   rec_ Fnd_Model_Id_Rec := Resolve_Model_Id_(model_id_);
BEGIN
   RETURN Get_Data_Content_(rec_.kind, rec_.artifact, rec_.name, scope_id_, language_, post_processing_, max_layer_, include_unpublished_, exclude_projection_);   
END Get_Data_Content_;

FUNCTION Get_Data_Content_ (
   data_format_             IN VARCHAR2,
   model_type_              IN VARCHAR2,
   model_name_              IN VARCHAR2,
   scope_id_                IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   language_                IN VARCHAR2 DEFAULT NULL,
   post_processing_         IN VARCHAR2 DEFAULT NULL,
   max_layer_               IN NUMBER   DEFAULT RUNTIME_MAX_LAYER, 
   include_unpublished_     IN BOOLEAN  DEFAULT FALSE, 
   exclude_projection_      IN BOOLEAN  DEFAULT FALSE) RETURN CLOB
IS
   output_ CLOB;
BEGIN
   output_ := Get_Data_Content_Impl___ (
      data_format_,
      model_type_,
      model_name_,
      scope_id_,
      language_,
      post_processing_,
      max_layer_,
      include_unpublished_,
      exclude_projection_,
      baseline_ => FALSE);
      
   IF (language_ IS NULL) THEN
      RETURN output_;      
   END IF;
   
   RETURN Translate_Data_Content___(output_, language_);   
END Get_Data_Content_;

FUNCTION Get_Doc_Data_Content_ (
   data_format_ IN VARCHAR2,
   model_type_  IN VARCHAR2,
   model_name_  IN VARCHAR2,
   scope_id_    IN VARCHAR2 DEFAULT GLOBAL_SCOPE,
   max_layer_   IN NUMBER   DEFAULT RUNTIME_MAX_LAYER) RETURN CLOB
IS
   template_  CLOB;
   contexts_  JSON_OBJECT_T;
   model_id_  fnd_model_api_doc_tab.model_id%TYPE := data_format_||'.'||model_type_||':'||model_name_;
BEGIN
   IF (scope_id_ LIKE '{"%') THEN
      contexts_ := JSON_OBJECT_T.parse(scope_id_);
   END IF;
   BEGIN
      SELECT template
         INTO template_
         FROM fnd_model_api_doc_tab
         WHERE model_id = model_id_;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         Error_SYS.Appl_General(lu_name_, 'NOMETA: No metadata found for id [:P1] in scope [:P2]', model_id_, scope_id_);
   END;
   RETURN Get_Metadata_Clob___(data_format_,
                              model_type_,
                              model_name_,
                              model_id_,
                              template_,
                              scope_id_,
                              NULL,
                              NULL,
                              max_layer_,
                              FALSE,
                              contexts_,
                              FALSE,
                              FALSE);
END Get_Doc_Data_Content_;

FUNCTION Get_Metadata_Clob___ (
   data_format_         IN     VARCHAR2,
   model_type_          IN     VARCHAR2,
   model_name_          IN     VARCHAR2,
   model_id_            IN     VARCHAR2,
   template_            IN OUT NOCOPY CLOB,
   scope_id_            IN     VARCHAR2,
   language_            IN     VARCHAR2,
   post_processing_     IN     VARCHAR2,
   layer_no_            IN     NUMBER,
   include_unpublished_ IN     BOOLEAN,
   contexts_            IN OUT JSON_OBJECT_T,
   exclude_projection_  IN     BOOLEAN,
   baseline_            IN     BOOLEAN) RETURN CLOB
IS
   output_          CLOB;
   parascope_id_    VARCHAR2(1000) := scope_id_;
   has_selectors_   BOOLEAN := FALSE;
   fetch_baseline_  NUMBER := 0;
   max_layer_       NUMBER := layer_no_;
   
   PROCEDURE Process_Content (
      text_loc_ IN CLOB )
   IS
      text_      CLOB;
      start_pos_ INTEGER := 1;
      from_pos_  INTEGER := 1;
      to_pos_    INTEGER := 1;
      parameter_ VARCHAR2(32000);
      type_      VARCHAR2(100);
      layout_    VARCHAR2(32000);
      
      CURSOR Get_Data (
         model_id_  VARCHAR2,
         scope_id_  VARCHAR2,
         type_name_ VARCHAR2 DEFAULT NULL)
      IS
         SELECT a.name,
                CASE
                   WHEN fetch_baseline_ = 1  THEN DECODE(a.layer_no, CONFIG_CORE_LAYER, a.content, CONFIG_PUBLISHED_LAYER, a.content, a.based_on_content)
                   ELSE a.content
                END AS content,      
                a.artifact
            FROM fnd_model_design_data_tab a
            WHERE (dependencies IS NULL
               -- When an artifact is marked with a dependency it is treated as dynamic
               -- The inclusion here depends on if the dependency module is pressent or not.
               OR dependencies IN (SELECT module
                                   FROM   module_tab
                                   WHERE  nvl(version, '*') NOT IN ('*','?')))
            -- Same artifact (key) is stored for different layers. (core = 1, config published = 2-79, config draft = 90)
            -- Here we determine from which layer the artifact requested should be fetched. 
            AND layer_no = (SELECT max(layer_no)
                            FROM   fnd_model_design_data_tab b
                            WHERE  b.model_id = a.model_id
                            AND    b.scope_id = a.scope_id
                            AND    b.data_id  = a.data_id
                            AND    b.layer_no <= max_layer_
                            AND   (max_layer_ <= RUNTIME_MAX_LAYER
                               OR (scope_id_ = GLOBAL_SCOPE
                                 -- If custom scope and max_layer_ is bigger than RUNTIME_MAX_LAYER
                                 -- Then we need to make sure that fallback to global scope only include published < RUNTIME_MAX_LAYER.
                                 OR b.layer_no <= decode(b.scope_id, scope_id_, max_layer_, RUNTIME_MAX_LAYER))))
            AND   a.model_id = model_id_
            AND   (type_name_ IS NULL OR a.artifact = type_name_)
            -- Determine if global or specific scope should be used for current artifact.
            -- If there exists a version of the artifact for the specific scope in the range of given layers then
            -- we should use the specific scope. If not we fallback to use the global scoped artifact.
            AND   a.scope_id = (SELECT decode(max(decode(c.scope_id,GLOBAL_SCOPE,1,2)),1,GLOBAL_SCOPE,scope_id_)
                                FROM   fnd_model_design_data_tab c
                                WHERE  c.scope_id IN (GLOBAL_SCOPE, scope_id_)
                                AND    c.model_id = a.model_id
                                AND    c.data_id  = a.data_id
                                AND    c.layer_no <= max_layer_
                                AND   (max_layer_ <= RUNTIME_MAX_LAYER
                                   OR (scope_id_ = GLOBAL_SCOPE
                                     -- If custom scope and max_layer_ is bigger than RUNTIME_MAX_LAYER
                                     -- Then we need to make sure that fallback to global scope only include published < RUNTIME_MAX_LAYER.
                                     OR c.layer_no <= decode(c.scope_id, scope_id_, max_layer_, RUNTIME_MAX_LAYER))))
            -- When there is a published artifact and the artifact is deleted in a higher layer
            -- Then an empty artifact is placed to obscure the published, when fetching metadata
            -- this empty artifact should be excluded
            AND   dbms_lob.getlength(a.content) != 0
            ORDER BY artifact, line_no;

      PROCEDURE Commit_And_Find_Next_Entry
      IS
      BEGIN
         start_pos_ := to_pos_;
         from_pos_ := Dbms_Lob.instr(text_, '[#[', start_pos_);
      END Commit_And_Find_Next_Entry;
      
      PROCEDURE Ignore_And_Find_Next_Entry
      IS
      BEGIN
         from_pos_ := Dbms_Lob.instr(text_, '[#[', to_pos_);         
      END Ignore_And_Find_Next_Entry;
     
   BEGIN
      IF (baseline_) THEN
         fetch_baseline_ := 1;           
      END IF;
      
      -- If runtime call max_layer_ = RUNTIME_MAX_LAYER
      -- And model not published(profiled), i.e. should runtime load any configurations
      -- Is_Published here can be confused with published configurations. This is not the same.
      IF(max_layer_ = RUNTIME_MAX_LAYER AND NOT Is_Published_(model_id_, model_type_)) THEN
         max_layer_ := CONFIG_CORE_LAYER;
      END IF;

      Dbms_Lob.CreateTemporary(text_, TRUE, Dbms_Lob.CALL);
      Dbms_Lob.Append(text_, text_loc_);
      Commit_And_Find_Next_Entry;
      IF (from_pos_ = 0) THEN
         Append_Clob___(output_, text_);
      ELSE
         WHILE (from_pos_ >= start_pos_) LOOP
            to_pos_ := Dbms_Lob.instr(text_, ']#]', from_pos_)+3;
            parameter_ := Dbms_Lob.substr(text_, to_pos_ - from_pos_ - 6, from_pos_ + 3);            
            CASE Link_Name___(parameter_)
               WHEN 'jsoncontent' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  FOR data_ IN Get_Data(model_id_, parascope_id_, Link_Value___(Link_Value___(parameter_))) LOOP
                     Add_Json_Comma___(output_);
                     Process_Content(data_.content);
                  END LOOP;
                  Commit_And_Find_Next_Entry;
               WHEN 'jsonnamedcontent' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  FOR data_ IN Get_Data(model_id_, parascope_id_, Link_Value___(Link_Value___(parameter_))) LOOP
                     Add_Json_Comma___(output_);
                     Append_Clob___(output_, '"'||data_.name||'":');
                     Process_Content(data_.content);
                  END LOOP;
                  Commit_And_Find_Next_Entry;
               WHEN 'jsonnamedcontentbydata' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  FOR data_ IN Get_Data(model_id_, parascope_id_) LOOP
                     IF (type_ IS NULL OR NOT(data_.artifact = type_)) THEN
                        IF (type_ IS NULL) THEN
                           layout_ := '"'||data_.artifact||'s": {';
                        ELSIF (NOT(data_.artifact = type_)) THEN
                           IF (type_ = 'selector') THEN
                              has_selectors_ := TRUE;
                              Commit_And_Find_Next_Entry;
                              Metadata_Dynamic_References(output_, text_, start_pos_, from_pos_, to_pos_, parascope_id_);
                           END IF;
                           layout_ := '}, "'||data_.artifact||'s": {';
                        END IF;
                        type_ := data_.artifact;
                        Append_Clob___(output_, layout_);
                     END IF;
                     Add_Json_Comma___(output_);
                     Append_Clob___(output_, '"'||data_.name||'":');
                     Process_Content(data_.content);
                  END LOOP;
                  Append_Clob___(output_, '}');
                  Commit_And_Find_Next_Entry;
               WHEN 'contextcallback' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), contexts_));
                  Commit_And_Find_Next_Entry;
               WHEN 'jsoncontextcallback' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Add_Json_Comma___(output_);
                  Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), contexts_));
                  Remove_Json_Comma___(output_);
                  Commit_And_Find_Next_Entry;
               WHEN 'callback' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), parascope_id_));
                  Commit_And_Find_Next_Entry;
               -- TODO: Obsolete! Will be removed! /Rakuse
               WHEN 'metacallback' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Append_Clob___(output_, Get_Meta_Callback_Content___(Link_Value___(parameter_)));
                  Commit_And_Find_Next_Entry;
               WHEN 'jsoncallback' THEN
                IF NOT has_selectors_ AND Has_Dynamic_Selectors___(parameter_) THEN
                  Add_Json_Comma___(output_);
                  Commit_And_Find_Next_Entry;
                  Append_Clob___(output_, '"selectors": {');
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Add_Json_Comma___(output_);
                  Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), parascope_id_));
                  Remove_Json_Comma___(output_);
                  Append_Clob___(output_, '}');                  
                ELSE
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Add_Json_Comma___(output_);
                  Append_Clob___(output_, Get_Callback_Content___(Link_Value___(parameter_), parascope_id_));
                  Remove_Json_Comma___(output_);
                  Commit_And_Find_Next_Entry;
                END IF;
               WHEN 'generate' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  Append_Clob___(output_, Get_Data_Version_(data_format_, model_type_, model_name_));
                  IF (parascope_id_ != GLOBAL_SCOPE) THEN
                     IF (contexts_ IS NULL) THEN
                        Append_Clob___(output_, '","scope":"'||parascope_id_||'"');                        
                     ELSE
                        Append_Clob___(output_, '","contexts":');
                        Append_Clob___(output_, contexts_.to_clob());
                     END IF;
                     to_pos_ := to_pos_ + 1;
                  END IF;
                  Commit_And_Find_Next_Entry;
               WHEN 'reference' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  -- Performance when client metadata is requested multiple times for same projection data.
                  IF(exclude_projection_ AND Link_Name___(Link_Value___(parameter_)) = 'projection') THEN
                     Append_Clob___(output_, 'null');
                  ELSE
                     Append_Clob___(output_, Get_Data_Content_Impl___(data_format_, Link_Name___(Link_Value___(parameter_)), Link_Value___(Link_Value___(parameter_)), parascope_id_, language_, post_processing_, layer_no_, include_unpublished_, exclude_projection_, baseline_));
                  END IF;
                  Commit_And_Find_Next_Entry; 
               WHEN 'appendcontext' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  IF (parascope_id_ != GLOBAL_SCOPE) THEN
                     Append_Clob___(output_, ':'||parascope_id_);
                  END IF;
                  Commit_And_Find_Next_Entry;
               WHEN 'expression' THEN
                  Append_Clob___(output_, text_, start_pos_, from_pos_);
                  IF (post_processing_ IS NULL OR post_processing_ != 'offline') THEN
                     Append_Clob___(output_, Link_Value___(parameter_));
                  ELSE
                     Append_Clob___(output_, '""');
                  END IF;
                  Commit_And_Find_Next_Entry;                                                           
               ELSE
                  Ignore_And_Find_Next_Entry;
               END CASE;                                 
         END LOOP;
       
         Append_Clob___(output_, text_, start_pos_, dbms_lob.getlength(text_)+1);
      END IF;
   END Process_Content;
BEGIN
   Dbms_Lob.CreateTemporary(output_, TRUE, Dbms_Lob.CALL);
   Process_Content(template_);
   RETURN output_;
END Get_Metadata_Clob___;
   
   
FUNCTION Get_Data_Content_Impl___ (
   data_format_             IN VARCHAR2,
   model_type_              IN VARCHAR2,
   model_name_              IN VARCHAR2,
   scope_id_                IN VARCHAR2,
   language_                IN VARCHAR2,
   post_processing_         IN VARCHAR2,
   max_layer_               IN NUMBER, 
   include_unpublished_     IN BOOLEAN, 
   exclude_projection_      IN BOOLEAN,
   baseline_                IN BOOLEAN) RETURN CLOB
IS
   output_          CLOB;
   template_loc_    CLOB;
   parascope_id_    VARCHAR2(1000) := scope_id_;
   layer_no_        NUMBER := max_layer_;
   contexts_        JSON_OBJECT_T;
   model_id_        fnd_model_design_tab.model_id%TYPE := data_format_||'.'||model_type_||':'||model_name_;
   actual_model_id_ VARCHAR2(32000);
BEGIN
   IF (NOT(include_unpublished_)) THEN 
      BEGIN
         IF model_type_ = 'app' THEN
            SELECT reference
               INTO actual_model_id_
               FROM fnd_model_design_tab
               WHERE model_id = model_id_;
         ELSE
            actual_model_id_ := model_id_;
         END IF;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         actual_model_id_ := model_id_;
      END;
      IF (NOT(Is_Published_(actual_model_id_, model_type_))) THEN
         parascope_id_ := GLOBAL_SCOPE;
         layer_no_ := CONFIG_CORE_LAYER;
      ELSE
         BEGIN
            SELECT c.scope_id
               INTO parascope_id_
               FROM   fnd_model_design_data_tab c
               WHERE c.model_id = actual_model_id_
               AND   c.scope_id = scope_id_;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
               parascope_id_ := GLOBAL_SCOPE;
            WHEN TOO_MANY_ROWS THEN
               parascope_id_ := scope_id_;
         END;
      END IF;
   END IF;
   IF (Service_Scope___(model_name_) IS NOT NULL) THEN
      RETURN Get_Data_Content_Impl___(data_format_, model_type_, Service_Name___(model_name_), Service_Scope___(model_name_), language_, post_processing_, layer_no_, include_unpublished_, exclude_projection_, baseline_);
   END IF;
   IF (parascope_id_ LIKE '{"%') THEN
      contexts_ := JSON_OBJECT_T.parse(parascope_id_);
   END IF;
   BEGIN
      SELECT template
         INTO template_loc_
         FROM fnd_model_design_tab
         WHERE model_id = model_id_;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         Error_SYS.Appl_General(lu_name_, 'NOMETA: No metadata found for id [:P1] in scope [:P2]', model_id_, parascope_id_);
   END;
   output_ := Get_Metadata_Clob___(data_format_,
                                    model_type_,
                                    model_name_,
                                    model_id_,
                                    template_loc_,
                                    scope_id_,
                                    language_,
                                    post_processing_,
                                    layer_no_,
                                    include_unpublished_,
                                    contexts_,
                                    exclude_projection_,
                                    baseline_);
   RETURN output_;
END Get_Data_Content_Impl___;

FUNCTION Is_Published_ (
   actual_model_id_ IN VARCHAR2,
   model_type_      IN VARCHAR2) RETURN BOOLEAN
IS
   is_profiled_     VARCHAR2(10) := 'FALSE';
   model_list_      Utility_SYS.STRING_TABLE;
   model_count_     NUMBER;
   published_count_ NUMBER;
BEGIN
   IF model_type_ = 'app' THEN
      Utility_SYS.Tokenize (actual_model_id_,',',model_list_,model_count_);
      SELECT COUNT(*) INTO published_count_ FROM fnd_model_design_tab where model_id IN (SELECT * FROM TABLE(model_list_)) AND profiled = 'TRUE';
      RETURN published_count_ > 0;
   END IF;
   
   SELECT profiled
      INTO is_profiled_
      FROM fnd_model_design_tab
      WHERE model_id = actual_model_id_;
   IF(is_profiled_ = 'TRUE') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
   
EXCEPTION WHEN NO_DATA_FOUND THEN
   RETURN FALSE;
END Is_Published_;

FUNCTION Has_Data_Content_ (
   data_format_ IN VARCHAR2,
   model_type_  IN VARCHAR2,
   model_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER := 0;
BEGIN
   SELECT 1
      INTO dummy_
      FROM fnd_model_design_tab
      WHERE model_id = data_format_||'.'||model_type_||':'||model_name_;
   RETURN TRUE;
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN FALSE; 
END Has_Data_Content_;
   
FUNCTION Format_Model_Id___ (
    rec_ IN Fnd_Model_Id_Rec) RETURN VARCHAR2
IS
BEGIN
   RETURN Format_Model_Id___(rec_.kind, rec_.artifact, rec_.name);   
END Format_Model_Id___;

FUNCTION Format_Model_Id___ (
   kind_     IN VARCHAR2,
   artifact_ IN VARCHAR2,
   name_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN kind_ || '.' || artifact_ || ':' || name_;
END Format_Model_Id___;

FUNCTION Check_Exist___ (
   model_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS   
   dummy_ NUMBER;
BEGIN
   IF (model_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  fnd_model_design_tab
      WHERE model_id = model_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(lu_name_, NULL, 'Check_Exist___');
END Check_Exist___;

FUNCTION Calc_Hash___(
   clob_ IN CLOB) RETURN VARCHAR2
IS
BEGIN
   IF (dbms_lob.getlength(clob_) > 0) THEN
      RETURN dbms_crypto.Hash(clob_, dbms_crypto.HASH_SH1);
   END IF;
   
   RETURN NULL;   
END Calc_Hash___;

FUNCTION Service_Name___ (
   service_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN substr(service_, 1, instr(service_,'-')-1);
END Service_Name___;


FUNCTION Service_Scope___ (
   service_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   scope_ VARCHAR2(1000);
   amp_   VARCHAR2(1) := chr(38);
BEGIN
   IF (instr(service_,'-') > 0) THEN
      scope_ := substr(service_, instr(service_,'-')+1);
      scope_ := replace(scope_, amp_||'quot;', '"');
      scope_ := replace(scope_, amp_||'#x3a;', ':');
      scope_ := replace(scope_, amp_||'#x7b;', '{');
      scope_ := replace(scope_, amp_||'#x7d;', '}');
      --from OData provider ...
      scope_ := replace(scope_, '(Sanitized)', '');
      RETURN trim(scope_);
   ELSE
      RETURN NULL;
   END IF;
END Service_Scope___;


FUNCTION Has_Dynamic_Selectors___ (
   parameter_ IN VARCHAR2) RETURN BOOLEAN
IS
   has_value_ BOOLEAN := FALSE;
   package_   VARCHAR2(32000);
   method_    VARCHAR2(32000);
BEGIN
   has_value_ := Split_Full_Method_Name___(Link_Value___(parameter_), package_, method_);      
   RETURN (Link_Name___(method_) = 'GET_SELECTORS_METADATA_');
END Has_Dynamic_Selectors___;

FUNCTION Link_Name___ (
   link_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN substr(link_, 1, instr(link_,':')-1);
END Link_Name___;


FUNCTION Link_Value___ (
   link_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN substr(link_, instr(link_,':')+1);
END Link_Value___;

FUNCTION Link_Name_And_Value___ (
   link_  IN VARCHAR2,
   name_  OUT NOCOPY VARCHAR2,
   value_ OUT NOCOPY VARCHAR2) RETURN BOOLEAN
IS
   index_ NUMBER := instr(link_,':');
BEGIN
   IF (index_ = 0) THEN
      RETURN FALSE;
   ELSE
      name_  := substr(link_, 1, index_-1);
      value_ := substr(link_, index_+1);
      RETURN TRUE;      
   END IF;
END Link_Name_And_Value___;

FUNCTION Split_Full_Method_Name___ (
   method_full_name_ IN VARCHAR2,
   package_          OUT NOCOPY VARCHAR2,
   method_           OUT NOCOPY VARCHAR2) RETURN BOOLEAN
IS
   index_ NUMBER := instr(method_full_name_,'.');
BEGIN
   IF (index_ = 0) THEN
      RETURN FALSE;
   ELSE
      package_ := UPPER(substr(method_full_name_, 1, index_-1));
      method_  := UPPER(substr(method_full_name_, index_+1));
      RETURN TRUE;      
   END IF;
END Split_Full_Method_Name___;


FUNCTION Get_Callback_Content___ (
   method_name_ IN VARCHAR2,
   scope_id_    IN VARCHAR2 ) RETURN CLOB
IS
   method_full_name_ VARCHAR2(200);
   param_            VARCHAR2(32000);
   package_          VARCHAR2(100);
   method_           VARCHAR2(100);
   clob_             CLOB;
BEGIN
   IF (NOT Link_Name_And_Value___(method_name_, method_full_name_, param_)) THEN
      method_full_name_ := method_name_;
      param_ := scope_id_;      
   END IF;
   
   IF (NOT Split_Full_Method_Name___(method_full_name_, package_, method_)) THEN
      RETURN '';
   END IF;
   
   -- Prioritized, try route to use a direct access by calling recognized methods directly.
   CASE package_
      WHEN 'OBJECT_CONNECTION_METADATA_SYS' THEN
         IF Object_Connection_Metadata_SYS.Route_Callback_Content_(method_, param_, clob_) THEN            
            RETURN clob_;
         END IF;
      WHEN 'CUSTOM_OBJECT_PROXY_SYS' THEN
         IF Custom_Object_Proxy_SYS.Route_Callback_Content_(method_, param_, clob_) THEN            
            RETURN clob_;
         END IF;
      WHEN 'LOOKUP_ENUM_METADATA_SYS' THEN
         IF Lookup_Enum_Metadata_SYS.Route_Callback_Content_(method_, param_, clob_) THEN
            RETURN clob_;
         END IF;
      WHEN 'DYNAMIC_REFERENCE_METADATA_API' THEN
         IF Dynamic_Reference_Metadata_API.Route_Callback_Content_(method_, param_, clob_) THEN
            RETURN clob_;
         END IF;         
      WHEN 'FND_PROJ_CHECKPOINT_UTIL_API' THEN
         IF Fnd_Proj_Checkpoint_Util_API.Route_Callback_Content_(method_, param_, clob_) THEN
            RETURN clob_;
         END IF;         
      ELSE
         NULL;
      END CASE;
            
      -- But when not known, do a "slow" access, by checking the method existence and call the method dynamically.  
      Assert_SYS.Assert_Is_Package_Method(method_full_name_);
      @ApproveDynamicStatement(2019-12-06,rakuse)
      EXECUTE IMMEDIATE 'BEGIN :clob_:=' || method_full_name_ || '(:context_); END;'
         USING OUT clob_, param_;
      RETURN clob_;      
END Get_Callback_Content___;
               
               
FUNCTION Get_Callback_Content___ (
   signature_ IN     VARCHAR2,
   contexts_  IN OUT JSON_OBJECT_T ) RETURN CLOB
IS
   clob_          CLOB;
   method_name_   VARCHAR2(500);
   param_name1_   VARCHAR2(500);
   param_name2_   VARCHAR2(500);
   param_name3_   VARCHAR2(500);
   string_value1_ VARCHAR2(1000);
   string_value2_ VARCHAR2(1000);
   string_value3_ VARCHAR2(1000);
BEGIN
   --Split signature into method name and parameter names
   method_name_ := signature_;  
   IF (Link_Name___(method_name_) IS NOT NULL) THEN
      param_name1_ := Link_Value___(method_name_);
      method_name_ := Link_Name___(method_name_);  
      IF (Link_Name___(param_name1_) IS NOT NULL) THEN
         param_name2_ := Link_Value___(param_name1_);  
         param_name1_ := Link_Name___(param_name1_);  
         IF (Link_Name___(param_name2_) IS NOT NULL) THEN
            param_name3_ := Link_Value___(param_name2_);  
            param_name2_ := Link_Name___(param_name2_);  
         END IF;
      END IF;
   END IF;
   --Assert that method name really is a valid function
   Assert_SYS.Assert_Is_Package_Method(method_name_);
   --Fetch values from context data
   --NOTE: Only VARCHAR2 parameters are currently supported
   IF (contexts_ IS NOT NULL AND contexts_.has(param_name1_)) THEN
      string_value1_ := contexts_.get_String(param_name1_);
   END IF;
   IF (contexts_ IS NOT NULL AND contexts_.has(param_name2_)) THEN
      string_value2_ := contexts_.get_String(param_name2_);
   END IF;
   IF (contexts_ IS NOT NULL AND contexts_.has(param_name3_)) THEN
      string_value3_ := contexts_.get_String(param_name3_);
   END IF;
   --Call the function with correct number of parameters
   IF (param_name3_ IS NOT NULL) THEN
      @ApproveDynamicStatement(2018-05-18,stlase)
      EXECUTE IMMEDIATE 'BEGIN :clob_:=' || method_name_ || '(:param1_, :param2_, :param3_); END;'
         USING OUT clob_, string_value1_, string_value2_, string_value3_;
   ELSIF (param_name2_ IS NOT NULL) THEN
      @ApproveDynamicStatement(2018-05-18,stlase)
      EXECUTE IMMEDIATE 'BEGIN :clob_:=' || method_name_ || '(:param1_, :param2_); END;'
         USING OUT clob_, string_value1_, string_value2_;
   ELSIF (param_name1_ IS NOT NULL) THEN
      @ApproveDynamicStatement(2018-05-18,stlase)
      EXECUTE IMMEDIATE 'BEGIN :clob_:=' || method_name_ || '(:param1_); END;'
         USING OUT clob_, string_value1_;
   ELSE
      @ApproveDynamicStatement(2018-05-18,stlase)
      EXECUTE IMMEDIATE 'BEGIN :clob_:=' || method_name_ || '; END;'
         USING OUT clob_;
   END IF;   
   RETURN clob_;
END Get_Callback_Content___;

-- TODO: Obsolete! Will be removed! /Rakuse
FUNCTION Get_Meta_Callback_Content___ (
   method_name_ IN VARCHAR2 ) RETURN CLOB
IS
   method_full_name_ VARCHAR2(200);
   param_            VARCHAR2(32000);
   package_          VARCHAR2(100);
   method_           VARCHAR2(100);
   clob_             CLOB;   
BEGIN   
   IF (NOT Link_Name_And_Value___(method_name_, method_full_name_, param_)) THEN
      method_full_name_ := method_name_;
      param_ := '';      
   END IF;
   
   IF (NOT Split_Full_Method_Name___(method_full_name_, package_, method_)) THEN
      RETURN '';
   END IF;
   
   CASE package_
   -- Obsolete!!! Will get removed.
      WHEN 'DYNAMIC_REFERENCE_METADATA_API' THEN
         IF Object_Connection_Metadata_SYS.Route_Callback_Content_(method_, param_, clob_) THEN            
            RETURN clob_;
         END IF;
--      WHEN 'OBJECT_CONNECTION_METADATA_SYS' THEN
--         IF Object_Connection_Metadata_SYS.Route_Callback_Content_(method_, param_, clob_) THEN            
--            RETURN clob_;
--         END IF;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'UNSUPPORTED_META_CALLBACK: Argument [:P1] is not supported', package_);
      END CASE;   
     
   RETURN clob_;      
   
END Get_Meta_Callback_Content___;

FUNCTION Get_Data_Version_ (
   data_format_ IN VARCHAR2,
   model_type_  IN VARCHAR2,
   model_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   version_     DATE;
BEGIN
   SELECT max(version)
      INTO version_
      FROM fnd_model_design_tab
      WHERE model_id = data_format_||'.'||model_type_||':'||model_name_;
      
   RETURN to_char(version_, Client_SYS.date_format_);
END Get_Data_Version_;

FUNCTION Get_Data_Version_Timestamp_ (
   data_format_ IN VARCHAR2,
   model_type_  IN VARCHAR2,
   model_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   version_     TIMESTAMP;
BEGIN
   SELECT max(version)
      INTO version_
      FROM fnd_model_design_tab
      WHERE model_id = data_format_||'.'||model_type_||':'||model_name_;
      
   RETURN version_;
END Get_Data_Version_Timestamp_;

-------------------- TRANSLATIONS --------------------------------------------

FUNCTION Translate___ (
   parameter_ IN VARCHAR2,
   language_  IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR Translated_Text (id_ VARCHAR2, language_ VARCHAR2) IS
      SELECT nvl(t.text, a.prog_text) text
      FROM  language_attribute a,
            language_context c,
            language_translation t
      WHERE a.context_id = c.context_id
      AND   a.attribute_id = t.attribute_id(+)
      AND   c.path = id_
      AND   language_ = t.lang_code(+);
   
   rec_ Translated_Text%ROWTYPE;
BEGIN
   OPEN Translated_Text(Link_Name___(parameter_), language_);
   FETCH Translated_Text INTO rec_;
   IF (Translated_Text%FOUND) THEN
      CLOSE Translated_Text;
      RETURN rec_.text;
   ELSE
      CLOSE Translated_Text;
      RETURN Link_Value___(parameter_);
   END IF;
END Translate___;

FUNCTION Translate_Sys___ (
   parameter_  IN VARCHAR2,
   language_   IN VARCHAR2) RETURN VARCHAR2
IS
   type_       language_sys_tab.type%TYPE;
   path_       language_sys_tab.path%TYPE;
   main_type_  language_sys_tab.main_type%TYPE;
   trans_text_ language_sys_tab.text%TYPE;
   name_       VARCHAR2(32000);
   value_      VARCHAR2(32000);
   value2_     VARCHAR2(32000);
   value3_     VARCHAR2(32000);
   value4_     VARCHAR2(32000);
BEGIN
   IF (Link_Name_And_Value___(parameter_, type_, value_)) THEN
      IF (Link_Name_And_Value___(value_, path_, value2_)) THEN
         IF (Link_Name_And_Value___(value2_, name_, value3_)) THEN
            IF (Link_Name_And_Value___(value3_, main_type_, value4_)) THEN
               trans_text_ := Language_SYS.Field_Lookup(type_, path_, language_, main_type_);
               IF (trans_text_ IS NULL) THEN                     
                  trans_text_ := value4_;
               END IF;                
            END IF;
         END IF;
      END IF;
   END IF;
   
   trans_text_ := REPLACE(REPLACE(trans_text_, '\"', chr(34)), '\\', chr(92));
   RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(trans_text_, chr(92), '\\'), chr(10), '\n'), chr(13), '\r'), chr(34), '\"'), chr(9), '\t');   
END Translate_Sys___;


FUNCTION Translate_Enum___ (
   parameter_ IN VARCHAR2) RETURN VARCHAR2
IS
   text_ VARCHAR2(2000);
   stmt_ VARCHAR2(200);
BEGIN
   stmt_ := 'BEGIN :translated_text_:=' || Link_Name___(parameter_) || '; END;';
   @ApproveDynamicStatement(2018-03-26,shaalk)
   EXECUTE IMMEDIATE stmt_ USING OUT text_;
   IF (text_ IS NULL) THEN
      text_ := Link_Value___(parameter_);
   END IF;
   text_ := REPLACE(REPLACE(text_, '\"', chr(34)), '\\', chr(92));
   RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(text_, chr(92), '\\'), chr(10), '\n'), chr(13), '\r'), chr(34), '\"'), chr(9), '\t');
END Translate_Enum___;


FUNCTION Translate_Data_Content___ (
   text_     IN CLOB,
   language_ IN VARCHAR2 ) RETURN CLOB
IS
   output_     CLOB;
   start_pos_  INTEGER := 1;
   from_pos_   INTEGER := 1;
   to_pos_     INTEGER := 1;
   parameter_  VARCHAR2(32000);
   trans_text_ VARCHAR2(32000);
   
   TYPE Translation_Type IS TABLE OF VARCHAR2(32000) INDEX BY VARCHAR2(32000);
   cache_ Translation_Type;   
BEGIN
   from_pos_ := Dbms_Lob.instr(text_, '[#[', start_pos_);
   IF (from_pos_ = 0) THEN
      RETURN text_;
   ELSE
      Dbms_Lob.CreateTemporary(output_, TRUE, Dbms_Lob.CALL);
      WHILE (from_pos_ > start_pos_) LOOP
         to_pos_ := Dbms_Lob.instr(text_, ']#]', from_pos_)+3;
         Append_Clob___(output_, text_, start_pos_, from_pos_);
         parameter_ := Dbms_Lob.substr(text_, to_pos_-from_pos_-6, from_pos_+3);         
         IF (cache_.EXISTS(parameter_)) THEN
            trans_text_ := cache_(parameter_);
         ELSE
            trans_text_ := Translate_Impl___(Link_Name___(parameter_), Link_Value___(parameter_), language_);
            cache_(parameter_) := trans_text_;
         END IF;  
         IF (trans_text_ IS NULL) THEN 
            Append_Clob___(output_, text_, from_pos_, to_pos_);
         ELSE
            Append_Clob___(output_, trans_text_);
         END IF;
         start_pos_ := to_pos_;
         from_pos_ := Dbms_Lob.instr(text_, '[#[', start_pos_);
      END LOOP;
      Append_Clob___(output_, text_, start_pos_, dbms_lob.getlength(text_)+1);
   END IF;
   
   RETURN output_;
END Translate_Data_Content___;

FUNCTION Translate_Impl___(
   type_     IN VARCHAR2,
   data_     IN VARCHAR2,
   language_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE type_
      WHEN 'translatesys' THEN
         RETURN Translate_Sys___(data_, language_);
      WHEN 'translateEnum' THEN
         RETURN Translate_Enum___(data_);
      WHEN 'translate' THEN
         RETURN Translate___(data_, language_);
      ELSE
         Trace_SYS.Message('Unknown context type: ' || type_);
   END CASE;
   RETURN '';
END Translate_Impl___;
   
-------------------- NAVIGATOR SUPPORT ---------------------------------------

FUNCTION Get_Client_Translated_Text_ (
   text_     IN VARCHAR2,
   language_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   from_pos_  INTEGER := 1;
   to_pos_    INTEGER := 1;
   parameter_ VARCHAR2(32000);
BEGIN
   from_pos_ := instr(text_, '[#[', 1);
   IF (from_pos_ = 0) THEN
      RETURN text_;
   END IF;
   to_pos_ := instr(text_, ']#]', from_pos_);
   IF (to_pos_ = 0) THEN
      Trace_SYS.Message('Translation syntax error! Missing end marker: ' || text_);
      RETURN text_;
   END IF;
   parameter_ := substr(text_, from_pos_ + 3, to_pos_ - from_pos_ - 3);
   RETURN Translate_Impl___(Link_Name___(parameter_), Link_Value___(parameter_), NVL(language_, Fnd_Session_API.Get_Language));      
END Get_Client_Translated_Text_;

-------------------- CLOB HELPER METHODS -------------------------------------

PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            VARCHAR2 )
IS
BEGIN
   IF (text_ IS NOT NULL) THEN
      Dbms_Lob.WriteAppend(clob_, length(text_), text_);
   END IF;
END Append_Clob___;


PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            CLOB )
IS
BEGIN
   IF (text_ IS NOT NULL AND dbms_lob.getlength(text_) > 0) THEN
      Dbms_Lob.Append(clob_, text_);
   END IF;
END Append_Clob___;


PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            CLOB,
   from_ IN            INTEGER,
   to_   IN            INTEGER )
IS
BEGIN
   IF (text_ IS NOT NULL AND dbms_lob.getlength(text_) > 0 AND to_ > from_) THEN
      Dbms_Lob.Copy(clob_, text_, to_-from_, dbms_lob.getlength(clob_)+1, from_);
   END IF;
END Append_Clob___;

-------------------- JSON HELPER METHODS -------------------------------------

PROCEDURE Add_Json_Comma___ (
   clob_ IN OUT NOCOPY CLOB )
IS
   length_ NUMBER := dbms_lob.getlength(clob_);
BEGIN
   IF (length_ > 1 AND Dbms_Lob.substr(clob_, 1, length_) NOT IN ('{','[',':',' ')) THEN
      Dbms_Lob.Writeappend(clob_, 1, ',');
   END IF;
END Add_Json_Comma___;


PROCEDURE Remove_Json_Comma___ (
   clob_ IN OUT NOCOPY CLOB )
IS
   length_ NUMBER := dbms_lob.getlength(clob_);
BEGIN
   IF (length_ > 1 AND Dbms_Lob.substr(clob_, 1, length_) = ',') THEN
      Dbms_Lob.Trim(clob_, length_-1);
   END IF;
END Remove_Json_Comma___;

-------------------- METADATA REMOVE METHODS -------------------------------------

PROCEDURE Remove_Component_Metadata_ (
   component_     IN VARCHAR2,
   show_info_     IN BOOLEAN DEFAULT FALSE,
   simulate_only_ IN BOOLEAN DEFAULT FALSE) 
IS
   count_apps_        NUMBER := 0;
   count_clients_     NUMBER := 0;
   count_projections_ NUMBER := 0;
   count_outbounds_   NUMBER := 0;
   apps_              Utility_SYS.STRING_TABLE;
   
   CURSOR get_clients_for_component IS
      SELECT name
         FROM fnd_model_design_tab
         WHERE artifact = 'client'
         AND kind = 'ClientMetadata'
         AND model_id LIKE 'ClientMetadata.client:%'
         AND dbms_lob.instr(template, '"component": "' || component_ || '"') > 0;
         
   CURSOR get_projections_for_component IS
      SELECT projection_name
         FROM fnd_projection_tab
         WHERE component = component_;
   
   CURSOR get_outbounds_for_component IS
      SELECT name
         FROM fnd_model_design_tab
         WHERE artifact = 'outbound'
         AND kind = 'ServerMetadata'
         AND model_id LIKE 'ServerMetadata.outbound:%'
         AND dbms_lob.instr(template, '"component": "' || component_ || '"') > 0;
                     
   PROCEDURE Show_Info(text_ IN VARCHAR2)
   IS
   BEGIN
      IF (simulate_only_) THEN
         Dbms_Output.Put_Line('(Simulation) ' || text_);     
      ELSIF (show_info_) THEN
         Dbms_Output.Put_Line(text_);     
      END IF;
   END Show_Info;
   
   PROCEDURE Clear_Client(
     client_name_ IN VARCHAR2,
     show_info_ IN BOOLEAN)
   IS
   BEGIN
      -- Client Metadata is removed from within method below
      Database_SYS.Remove_Client(client_name_ => client_name_, show_info_ => show_info_);      
      @ApproveTransactionStatement(2020-09-15,rakuse)
      COMMIT;      
   END Clear_Client;
   
   PROCEDURE Clear_Projection(
     projection_name_ IN VARCHAR2,
     show_info_ IN BOOLEAN)
   IS
   BEGIN
      -- Projection Metadata is removed from within method below
      Database_SYS.Remove_Projection(projection_name_ => projection_name_, show_info_ => show_info_);      
      @ApproveTransactionStatement(2020-09-15,rakuse)
      COMMIT;      
   END Clear_Projection;
   
   PROCEDURE Clear_Outbound(
     outbound_name_ IN VARCHAR2,
     show_info_ IN BOOLEAN)
   IS
   BEGIN
      -- Outbound Metadata is removed from within method below
      Database_SYS.Remove_Outbound(outbound_name_ => outbound_name_, show_info_ => show_info_);
      @ApproveTransactionStatement(2021-12-01,rankse)
      COMMIT;      
   END Clear_Outbound;

BEGIN   
   Show_Info('-------- START REMOVING METADATA FOR ' || component_ || ' --------');
   
   -- Clear Apps
   Show_Info('Removing Apps...');
   count_apps_ := Mobile_Client_Proxy_SYS.Remove_Component_Metadata_(component_, show_info_, simulate_only_ );

   -- Clear Clients
   Show_Info('Removing Clients...');
   FOR client IN get_clients_for_component LOOP
      count_clients_ := count_clients_ + 1;      

      Show_Info(count_clients_ || '. Removing client ' || client.name);
      IF (NOT simulate_only_) THEN
         Clear_Client(client.name, show_info_);  
      END IF;       
   END LOOP;

   -- Clear Projections
   Show_Info('Removing Projections...');
   FOR projection IN get_projections_for_component LOOP
      count_projections_ := count_projections_ + 1;
      
      Show_Info(count_projections_ || '. Removing projection ' || projection.projection_name);
      IF (NOT simulate_only_) THEN
         Clear_Projection(projection.projection_name, show_info_);
      END IF;      
   END LOOP;

   -- Clear Outbounds
   Show_Info('Removing Outbounds...');
   FOR outbound IN get_outbounds_for_component LOOP
      count_outbounds_ := count_outbounds_ + 1;
      
      Show_Info(count_outbounds_ || '. Removing outbound ' || outbound.name);
      IF (NOT simulate_only_) THEN
         Clear_Outbound(outbound.name, show_info_);
      END IF;      
   END LOOP;

   -- Calculate new runtime Navigator
   Show_Info('Calculating new runtime Navigator...');
   IF (NOT simulate_only_) THEN
      Navigator_SYS.Insert_Navigator_Entries();
      @ApproveTransactionStatement(2020-09-15,rakuse)
      COMMIT;      
   END IF;
   
   Show_Info('--------------------------------------------');
   Show_Info('Removed ' || component_ || ' apps: '        || count_apps_);
   Show_Info('Removed ' || component_ || ' clients: '     || count_clients_);
   Show_Info('Removed ' || component_ || ' projections: ' || count_projections_);
   Show_Info('Removed ' || component_ || ' outbounds: '   || count_outbounds_);
   Show_Info('------- END REMOVING METADATA FOR ' || component_ || ' --------');

END Remove_Component_Metadata_;

PROCEDURE Remove_App_Metadata (
   app_name_ IN VARCHAR2 )
IS
BEGIN
   Remove_Metadata___(app_name_, ARTIFACT_APP);
END Remove_App_Metadata;

PROCEDURE Remove_Projection_Metadata (
   projection_name_ IN VARCHAR2 )
IS
BEGIN
   Remove_Metadata___(projection_name_, ARTIFACT_PROJECTION);
   Remove_Doc_Metadata___(projection_name_, ARTIFACT_PROJECTION);
END Remove_Projection_Metadata;

PROCEDURE Remove_Client_Metadata (
   client_name_ IN VARCHAR2 )
IS
BEGIN
   Remove_Metadata___(client_name_, ARTIFACT_CLIENT);
END Remove_Client_Metadata;

PROCEDURE Remove_Outbound_Metadata (
   outbound_name_ IN VARCHAR2 )
IS
BEGIN
   Remove_Metadata___(outbound_name_, ARTIFACT_OUTBOUND);
   Remove_Doc_Metadata___(outbound_name_, ARTIFACT_OUTBOUND);
END Remove_Outbound_Metadata;

PROCEDURE Remove_Metadata___ (
   name_     IN VARCHAR2,
   artifact_ IN VARCHAR2)
IS
   model_id_ fnd_model_design_tab.model_id%TYPE := 'ClientMetadata.' || artifact_ || ':' || name_;   
BEGIN      
   --Delete any existing model design data rows for the named artifact
   DELETE
      FROM fnd_model_design_data_tab t
      WHERE t.model_id = model_id_;
   
   --Delete any existing model design rows for the named artifact
   DELETE
      FROM fnd_model_design_tab t
      WHERE t.name = name_
      AND t.artifact = artifact_;
END Remove_Metadata___;

PROCEDURE Remove_Doc_Metadata___ (
   name_     IN VARCHAR2,
   artifact_ IN VARCHAR2)
IS
   model_id_ fnd_model_design_tab.model_id%TYPE := 'ServerMetadata.' || artifact_ || ':' || name_;
BEGIN      
   --Delete any existing API Documentation rows for the given model
   DELETE
      FROM fnd_model_api_doc_tab t
      WHERE t.model_id = model_id_;
END Remove_Doc_Metadata___;

PROCEDURE Toggle_Layer(
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER,
   new_layer_no_ IN NUMBER)
IS
BEGIN
   IF layer_no_ != CONFIG_CORE_LAYER AND new_layer_no_ != CONFIG_CORE_LAYER THEN
      UPDATE fnd_model_design_data_tab
         SET layer_no = new_layer_no_
         WHERE  model_id = model_id_
            AND    scope_id = scope_id_
            AND    data_id  = data_id_
            AND    layer_no = layer_no_;
   END IF;
END Toggle_Layer;

PROCEDURE Toggle_Visibility(
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2,
   data_id_  IN VARCHAR2,
   layer_no_ IN NUMBER DEFAULT CONFIG_DRAFT_LAYER,
   visibility_   IN VARCHAR2)
IS
BEGIN
   UPDATE fnd_model_design_data_tab
      SET visibility = visibility_
      WHERE  model_id = model_id_
         AND    scope_id = scope_id_
         AND    data_id  = data_id_
         AND    layer_no = layer_no_;
END Toggle_Visibility;