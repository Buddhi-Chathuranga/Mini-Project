-----------------------------------------------------------------------------
--
--  Logical unit: CustomObjectProxy
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- CONSTANTS ------------------------------------

------------- CONTROL DATA FETCH AND PROCESSING -------------------

@UncheckedAccess
FUNCTION Route_Callback_Content_ (
   method_ IN VARCHAR2,
   param_  IN VARCHAR2,
   clob_   OUT NOCOPY CLOB) RETURN BOOLEAN
IS
BEGIN
   CASE method_
      ------- SERVER
      WHEN 'SERVER_STRUCTURE_METADATA' THEN
         clob_ := SERVER_STRUCTURE_METADATA(param_);
      WHEN 'SERVER_ENTITYSET_METADATA' THEN
         clob_ := SERVER_ENTITYSET_METADATA(param_);
      WHEN 'SERVER_ENTITY_TYPE_METADATA' THEN
         clob_ := SERVER_ENTITY_TYPE_METADATA(param_);
      WHEN 'SERVER_ENTITY_NAV_METADATA' THEN
         clob_ := SERVER_ENTITY_NAV_METADATA(param_);
      WHEN 'SERVER_ACTION_METADATA' THEN
         clob_ := SERVER_ACTION_METADATA(param_);
      WHEN 'SERVER_VIEW_METADATA' THEN
         clob_ := SERVER_VIEW_METADATA(param_);
      WHEN 'SERVER_ENUMERATION_METADATA' THEN
         clob_ := SERVER_ENUMERATION_METADATA(param_);
      WHEN 'SERVER_ATTRIBUTE_METADATA' THEN
         clob_ := SERVER_ATTRIBUTE_METADATA(param_);
         
      ------- CLIENT
      WHEN 'CLIENT_ENTITYSET_METADATA' THEN
         clob_ := CLIENT_ENTITYSET_METADATA(param_);
      WHEN 'CLIENT_ENTITY_TYPE_METADATA' THEN
         clob_ := CLIENT_ENTITY_TYPE_METADATA(param_);
      WHEN 'CLIENT_ENTITY_NAV_METADATA' THEN
         clob_ := CLIENT_ENTITY_NAV_METADATA(param_);
      WHEN 'CLIENT_ENTITY_ARRAY_METADATA' THEN
         clob_ := CLIENT_ENTITY_ARRAY_METADATA(param_);
      WHEN 'CLIENT_ACTION_METADATA' THEN
         clob_ := CLIENT_ACTION_METADATA(param_);
      WHEN 'CLIENT_ENUMERATION_METADATA' THEN
         clob_ := CLIENT_ENUMERATION_METADATA(param_);
      WHEN 'CLIENT_ATTRIBUTE_METADATA' THEN
         clob_ := CLIENT_ATTRIBUTE_METADATA(param_);
      ELSE
         clob_ := '';         
         RETURN FALSE;
      END CASE;
   
   RETURN TRUE;
 END Route_Callback_Content_;
   
-------------------- SERVER METADATA ---------------------------------

TYPE Metadata_Params IS RECORD (
   has_values      BOOLEAN,
   projection_name VARCHAR2(128),
   view_name       VARCHAR2(4000),
   lu_names        Utility_SYS.STRING_TABLE);


FUNCTION Extract_Metadata_Params___ (
   json_message_ IN VARCHAR2) RETURN Metadata_Params
IS
   params_ Metadata_Params;
   json_object_ JSON_OBJECT_T;
BEGIN
   dbms_output.put_line(json_message_);
   json_object_ := JSON_OBJECT_T(json_message_);
   
   params_.projection_name := json_object_.get_string('Projection');
   params_.view_name := json_object_.get_string('View');
   
   IF params_.view_name IS NULL THEN
      params_.view_name := json_object_.get_string('Viewname');
   END IF;
   
   params_.has_values := TRUE;
   RETURN params_;
EXCEPTION
   WHEN OTHERS THEN
      params_.has_values := FALSE;
      RETURN params_;
END Extract_Metadata_Params___;

FUNCTION Server_View_Metadata (
   params_ IN VARCHAR2 ) RETURN CLOB
IS
   ext_params_ Metadata_Params;
BEGIN   
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_View_Metadata(params_);
   $ELSE
      ext_params_:= Extract_Metadata_Params___(params_);
         
      IF ext_params_.has_values THEN
         RETURN NVL(ext_params_.view_name, params_);
      ELSE
         RETURN params_;
      END IF;
   $END
END Server_View_Metadata;


FUNCTION Server_Attribute_Metadata (
   params_ IN VARCHAR2 ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Attribute_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Attribute_Metadata;

FUNCTION Server_Entity_Type_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Entity_Types(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Entity_Type_Metadata;

FUNCTION Server_Entityset_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL )  RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Entitysets(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Entityset_Metadata;

FUNCTION Server_Enumeration_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Enumeration_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Enumeration_Metadata;

FUNCTION Server_Entity_Nav_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Entity_Nav_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Entity_Nav_Metadata;

FUNCTION Server_Structure_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Structure_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Structure_Metadata;

FUNCTION Server_Action_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Server_Action_Metadata(params_);
   $ELSE
      RETURN empty_clob();
   $END
END Server_Action_Metadata;

-------------------- CLIENT METADATA ---------------------------------

FUNCTION Client_Attribute_Metadata (
   params_ IN VARCHAR2 ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Attribute_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Attribute_Metadata;

FUNCTION Client_Enumeration_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS 
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Enumeration_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Enumeration_Metadata;

FUNCTION Client_Entityset_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Entityset_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Entityset_Metadata;

FUNCTION Client_Entity_Type_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS 
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Entity_Type_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Entity_Type_Metadata;

FUNCTION Client_Entity_Nav_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS 
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Entity_Nav_Metadata(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Entity_Nav_Metadata;

FUNCTION Client_Entity_Array_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Entity_Array_Metadata(params_);
   $ELSE
      RETURN empty_clob();
   $END
END Client_Entity_Array_Metadata;

FUNCTION Client_Action_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Action_Metadata(params_);
   $ELSE
      RETURN empty_clob();
   $END
END Client_Action_Metadata;

FUNCTION Client_Procedure_Metadata (
   params_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Object_Metadata_SYS.Client_Procedure_Metadata(params_);
   $ELSE
      RETURN empty_clob();
   $END
END Client_Procedure_Metadata;

PROCEDURE Cf_Crud (
   lu_name_     IN VARCHAR2,
   lu_type_     IN VARCHAR2,
   info_       OUT VARCHAR2,
   objid_       IN VARCHAR2,
   attr_cf_ IN OUT VARCHAR2,
   attr_        IN VARCHAR2,
   action_      IN VARCHAR2,
   operation_   IN VARCHAR2 DEFAULT 'U')
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Custom_Object_Runtime_SYS.Cf_Cud(lu_name_ ,lu_type_ , info_ , objid_ , attr_cf_ , attr_ , action_, operation_);
   $ELSE   
      NULL;
   $END   
END Cf_Crud;
