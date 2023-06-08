-----------------------------------------------------------------------------
--
--  Logical unit: RoutingAddress
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------
--  2019-11-15  madrse  PACZDATA-1583: Create sync procedure for synchronization of Routing runtime entities
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Routing_Addresses IS TABLE OF routing_address_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Mandatory_Attributes___ (
   transport_connector_ IN VARCHAR2) RETURN VARCHAR2
IS
   common_ VARCHAR2(32000);
   own_    VARCHAR2(32000);
BEGIN
   Routing_Address_Meta_API.Enumerate_Common_Mandatory_Db(common_);
   CASE transport_connector_
      WHEN Connector_Instance_Type_API.DB_FILE       THEN Routing_Address_Meta_API.Enumerate_File_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_FTP        THEN Routing_Address_Meta_API.Enumerate_Ftp_Mandatory_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP       THEN Routing_Address_Meta_API.Enumerate_Sftp_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_REST       THEN Routing_Address_Meta_API.Enumerate_Rest_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_HTTP       THEN Routing_Address_Meta_API.Enumerate_Http_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_MAIL       THEN Routing_Address_Meta_API.Enumerate_Mail_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_CUSTOM     THEN Routing_Address_Meta_API.Enumerate_Custom_Mandatory_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_PLSQL      THEN Routing_Address_Meta_API.Enumerate_Plsql_Mandaory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_PROJECTION THEN Routing_Address_Meta_API.Enumerate_Projection_Mand_Db (own_);
   END CASE;
   own_ := common_ || own_;
   Dbms_Output.Put_Line('Mandatory_Attributes: ' || own_);
   RETURN own_;
END Get_Mandatory_Attributes___;


FUNCTION Get_Own_Attributes___ (
   transport_connector_ IN VARCHAR2) RETURN VARCHAR2
IS
   common_ VARCHAR2(32000);
   own_    VARCHAR2(32000);
BEGIN
   Routing_Address_Meta_API.Enumerate_Common_Db(common_);
   CASE transport_connector_
      WHEN Connector_Instance_Type_API.DB_FILE       THEN Routing_Address_Meta_API.Enumerate_File_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_FTP        THEN Routing_Address_Meta_API.Enumerate_Ftp_Db   (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP       THEN Routing_Address_Meta_API.Enumerate_Sftp_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_REST       THEN Routing_Address_Meta_API.Enumerate_Rest_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_HTTP       THEN Routing_Address_Meta_API.Enumerate_Http_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_MAIL       THEN Routing_Address_Meta_API.Enumerate_Mail_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_CUSTOM     THEN Routing_Address_Meta_API.Enumerate_Custom_Db(own_);
      WHEN Connector_Instance_Type_API.DB_PLSQL      THEN Routing_Address_Meta_API.Enumerate_Plsql_Db (own_);
      WHEN Connector_Instance_Type_API.DB_PROJECTION THEN Routing_Address_Meta_API.Enumerate_Projection_Db(own_);
   END CASE;
   own_ := common_ || own_;
   Dbms_Output.Put_Line('Own_Attributes: ' || own_);
   RETURN own_;
END Get_Own_Attributes___;

FUNCTION Get_Transformer__(
   address_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_transformer IS
   SELECT transformer
   FROM routing_address_tab
   WHERE address_name = address_name_;
   temp_ VARCHAR2(500);
BEGIN
   OPEN get_transformer;
   FETCH get_transformer INTO temp_;
   CLOSE get_transformer;
RETURN temp_;
END Get_Transformer__;

FUNCTION Get_Respose_Transformer__(
   address_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_response_transformer IS
   SELECT response_transformer
   FROM routing_address_tab
   WHERE address_name = address_name_;
   temp_ VARCHAR2(500);
BEGIN
   OPEN get_response_transformer;
   FETCH get_response_transformer INTO temp_;
   CLOSE get_response_transformer;
RETURN temp_;
END Get_Respose_Transformer__;

@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT routing_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   transport_connector_ VARCHAR2(100) := NVL(newrec_.transport_connector, Connector_Instance_Type_API.Get_Db_Value_From_Attr('TRANSPORT_CONNECTOR', attr_));
   not_own_attr_        VARCHAR2(32000);
BEGIN
   Connect_Config_API.Move_Not_Own_Attributes_(attr_, not_own_attr_, Get_Own_Attributes___(transport_connector_));
   Dbms_Output.Put_Line('Not_Own_Attributes: ' || not_own_attr_);
   super(newrec_, indrec_, attr_);
   Connect_Config_API.Copy_Attributes_(not_own_attr_, attr_);
END Unpack___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     routing_address_tab%ROWTYPE,
   newrec_ IN OUT routing_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   new_attr_ VARCHAR2(32000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Connect_Config_API.Encrypt_(newrec_.password, indrec_.password);
   Connect_Config_API.Encrypt_(newrec_.client_secret, indrec_.client_secret);
   new_attr_ := Pack_Table___(newrec_);
   Connect_Config_API.Validate_Mandatory_Attributes_(lu_name_, new_attr_, Get_Mandatory_Attributes___(newrec_.transport_connector));
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT routing_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.customized := 1;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     routing_address_tab%ROWTYPE,
   newrec_ IN OUT routing_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.customized := 1;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT routing_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2) IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Address_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     routing_address_tab%ROWTYPE,
   newrec_     IN OUT routing_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Address_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN routing_address_tab%ROWTYPE) IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Address_(remrec_.address_name);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Setup_Attributes__(
   attr_ OUT VARCHAR2,
   address_name_ IN VARCHAR2,
   transport_connector_ IN VARCHAR2,
   sender_instance_ IN VARCHAR2,
   envelope_ IN VARCHAR2,
   encoding_ IN VARCHAR2,
   sender_ IN VARCHAR2,
   sender_organization_ IN VARCHAR2,
   receiver_ IN VARCHAR2,
   receiver_organization_ IN VARCHAR2,
   transformer_ IN VARCHAR2,
   response_transformer_ IN VARCHAR2,
   zip_ IN BOOLEAN,
   envelope_response_ IN BOOLEAN,
   customized_ IN BOOLEAN,
   custom_address_data_ IN VARCHAR2,
   additional_headers_ IN VARCHAR2,
   user_id_ IN VARCHAR2,
   password_ IN VARCHAR2,
   directory_ IN VARCHAR2,
   output_file_ IN VARCHAR2,
   plsql_method_ IN VARCHAR2,
   destination_ IN VARCHAR2,
   url_ IN VARCHAR2,
   soap_action_ IN VARCHAR2,
   send_to_ IN VARCHAR2,
   cc_ IN VARCHAR2,
   subject_ IN VARCHAR2,
   attachment_name_ IN VARCHAR2,
   rest_root_end_point_ IN VARCHAR2,
   authentication_method_ IN VARCHAR2,
   api_key_ IN VARCHAR2,
   client_id_ IN VARCHAR2,
   client_secret_ IN VARCHAR2,
   token_endpoint_ IN VARCHAR2,
   protected_resource_ IN VARCHAR2,
   projection_method_ IN VARCHAR2,
   projection_resource_ IN VARCHAR2,
   token_endpoint_parameters_ IN VARCHAR2,
   rest_http_method_ IN VARCHAR2   
   )
IS
   zip_num_ NUMBER;
   env_response_num_ NUMBER;
   customized_num_ NUMBER;
BEGIN
   IF zip_ = TRUE THEN
      zip_num_ := 1;
   ELSE
      zip_num_ := 0;
   END IF;

   IF envelope_response_ = TRUE THEN
      env_response_num_ := 1;
   ELSE
      env_response_num_ := 0;
   END IF;

   IF customized_ = TRUE THEN
      customized_num_ := 1;
   ELSE
      customized_num_ := 0;
   END IF;

   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('ADDRESS_NAME', address_name_, attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_CONNECTOR_DB', transport_connector_, attr_);
   Client_SYS.Add_To_Attr('SENDER_INSTANCE', sender_instance_, attr_);
   Client_SYS.Add_To_Attr('ENVELOPE', envelope_, attr_);
   Client_SYS.Add_To_Attr('ENCODING', encoding_, attr_);
   Client_SYS.Add_To_Attr('SENDER', sender_, attr_);
   Client_SYS.Add_To_Attr('SENDER_ORGANIZATION', sender_organization_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER', receiver_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ORGANIZATION', receiver_organization_, attr_);
   Client_SYS.Add_To_Attr('TRANSFORMER', transformer_, attr_);
   Client_SYS.Add_To_Attr('RESPONSE_TRANSFORMER', response_transformer_, attr_);
   Client_SYS.Add_To_Attr('ZIP', zip_num_, attr_);
   Client_SYS.Add_To_Attr('ENVELOPE_RESPONSE', env_response_num_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMIZED', customized_num_, attr_);
   Client_SYS.Add_To_Attr('CUSTOM_ADDRESS_DATA', custom_address_data_, attr_);
   Client_SYS.Add_To_Attr('ADDITIONAL_HEADERS', additional_headers_, attr_);
   Client_SYS.Add_To_Attr('USER_ID', user_id_, attr_);
   Client_SYS.Add_To_Attr('PASSWORD', password_, attr_);
   Client_SYS.Add_To_Attr('DIRECTORY', directory_, attr_);
   Client_SYS.Add_To_Attr('OUTPUT_FILE', output_file_, attr_);
   Client_SYS.Add_To_Attr('PLSQL_METHOD', plsql_method_, attr_);
   Client_SYS.Add_To_Attr('DESTINATION', destination_, attr_);
   Client_SYS.Add_To_Attr('URL', url_, attr_);
   Client_SYS.Add_To_Attr('SOAP_ACTION', soap_action_, attr_);
   Client_SYS.Add_To_Attr('SEND_TO', send_to_, attr_);
   Client_SYS.Add_To_Attr('CC', cc_, attr_);
   Client_SYS.Add_To_Attr('SUBJECT', subject_, attr_);
   Client_SYS.Add_To_Attr('ATTACHMENT_NAME', attachment_name_, attr_);
   Client_SYS.Add_To_Attr('REST_ROOT_END_POINT', rest_root_end_point_, attr_);
   Client_SYS.Add_To_Attr('AUTHENTICATION_METHOD_DB', authentication_method_, attr_);
   Client_SYS.Add_To_Attr('API_KEY', api_key_, attr_);
   Client_SYS.Add_To_Attr('CLIENT_ID', client_id_, attr_);
   Client_SYS.Add_To_Attr('CLIENT_SECRET', client_secret_, attr_);
   Client_SYS.Add_To_Attr('TOKEN_ENDPOINT', token_endpoint_, attr_);
   Client_SYS.Add_To_Attr('PROTECTED_RESOURCE', protected_resource_, attr_);
   Client_SYS.Add_To_Attr('PROJECTION_METHOD_DB', projection_method_, attr_);
   Client_SYS.Add_To_Attr('PROJECTION_RESOURCE', projection_resource_, attr_);
   Client_SYS.Add_To_Attr('TOKEN_ENDPOINT_PARAMETERS', token_endpoint_parameters_, attr_);
   Client_SYS.Add_To_Attr('REST_HTTP_METHOD_DB', rest_http_method_, attr_);
END Setup_Attributes__;


PROCEDURE Sync_Custom_Address__ (
   address_name_ IN VARCHAR2)
IS
   rec_ routing_address_tab%ROWTYPE := Lock_By_Keys___(address_name_);
BEGIN
   Connect_Runtime_API.Sync_Address_(rec_);
END Sync_Custom_Address__;


@UncheckedAccess
FUNCTION Transformer_List__ (
   transformers_      IN VARCHAR2,
   resp_transformers_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   FUNCTION Trim___ (str_ VARCHAR2 ) RETURN VARCHAR2
   IS
      trimmed_ VARCHAR2(4000);
   BEGIN
      trimmed_ := replace(str_,     ' '     );
      trimmed_ := replace(trimmed_, chr(9)  );
      trimmed_ := replace(trimmed_, chr(13) );
      trimmed_ := replace(trimmed_, chr(10) );
      trimmed_ := replace(trimmed_, ';',    ',' );
      RETURN trimmed_;
   END Trim___;

BEGIN
   RETURN ','|| Trim___(transformers_) ||','|| Trim___(resp_transformers_) ||',';
END Transformer_List__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Format_Http_Options_ (
   auth_key_           IN VARCHAR2,
   auth_value_         IN VARCHAR2,
   additional_headers_ IN VARCHAR2) RETURN VARCHAR2
IS
   options_ VARCHAR2(2000);
BEGIN
   IF auth_value_ IS NULL THEN
      RETURN additional_headers_;
   END IF;
   options_ := 'Authorization=' || auth_key_ || ' ' || auth_value_ || CASE additional_headers_ IS NULL WHEN TRUE THEN '' ELSE CHR(10) || additional_headers_ END;
   RETURN Connect_Config_API.Cannonize_Options_(options_);
END Format_Http_Options_;

FUNCTION Format_None_Auth_Value_ (   
   rest_http_method_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN   
   RETURN ' authentication_mode:None'  || ' http_method:'  || rest_http_method_;
END Format_None_Auth_Value_;

FUNCTION Format_Basic_Auth_Value_ (
   user_id_  IN VARCHAR2,
   password_ IN VARCHAR2,
   rest_http_method_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF user_id_ IS NULL THEN
      RETURN NULL;
   END IF;
   RETURN Ins_Util_API.To_Base64(user_id_ || ':' || Connect_Config_API.Decrypt_(password_)) ||
         ' http_method:'  || rest_http_method_;
END Format_Basic_Auth_Value_;

FUNCTION Format_Http_Basic_Auth_Value_ (
   user_id_  IN VARCHAR2,
    password_ IN VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
    IF user_id_ IS NULL THEN
       RETURN NULL;
    END IF;
    RETURN Ins_Util_API.To_Base64(user_id_ || ':' || Connect_Config_API.Decrypt_(password_));
END Format_Http_Basic_Auth_Value_;

FUNCTION Format_Bearer_Auth_Value_ (
   api_key_          IN VARCHAR2,   
   rest_http_method_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF api_key_ IS NULL THEN
      RETURN NULL;
   END IF;
   RETURN  api_key_ ||          
          ' http_method:'     || rest_http_method_;
END Format_Bearer_Auth_Value_;

FUNCTION Format_Azure_Auth_Value_ (
   api_key_          IN VARCHAR2,   
   rest_http_method_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF api_key_ IS NULL THEN
      RETURN NULL;
   END IF;
   RETURN  api_key_ ||          
          ' http_method:'     || rest_http_method_;
END Format_Azure_Auth_Value_;


FUNCTION Format_Client_Auth_Value_ (
   client_id_          IN VARCHAR2,
   client_secret_      IN VARCHAR2,
   token_endpoint_     IN VARCHAR2,
   protected_resource_ IN VARCHAR2,
   token_endpoint_parameters_ IN VARCHAR2,
   rest_http_method_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF client_id_ IS NULL THEN
      RETURN NULL;
   END IF;
   RETURN  'client_id:'     || client_id_ ||
          ' client_secret:' || replace(replace(Ins_Util_API.To_Base64(Connect_Config_API.Decrypt_(client_secret_)),chr(10),''),chr(13),'') ||
          ' endpoint:'      || token_endpoint_ ||
          ' resource:'      || protected_resource_ ||
          ' endpoint_token_parameters:'      || token_endpoint_parameters_ ||
          ' http_method:'     || rest_http_method_;
END Format_Client_Auth_Value_;


FUNCTION Format_Ropc_Auth_Value_ (
   user_id_        IN VARCHAR2,
   password_       IN VARCHAR2,
   token_endpoint_ IN VARCHAR2,
   token_endpoint_parameters_ IN VARCHAR2,
   rest_http_method_ IN VARCHAR2,
   client_id_        IN VARCHAR2,
   client_secret_    IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF user_id_ IS NULL THEN
      RETURN NULL;
   END IF;
   RETURN  'user_id:'  || user_id_ ||
          ' password:' || Ins_Util_API.To_Base64(Connect_Config_API.Decrypt_(password_)) ||
          ' client_id:'     || client_id_ ||
          ' client_secret:' || replace(replace(Ins_Util_API.To_Base64(Connect_Config_API.Decrypt_(client_secret_)),chr(10),''),chr(13),'') ||
          ' endpoint:' || token_endpoint_ ||
          ' endpoint_token_parameters:'      || token_endpoint_parameters_ ||
          ' http_method:'     || rest_http_method_;
END Format_Ropc_Auth_Value_;


FUNCTION Format_Mail_Options_ (
   file_name_ IN VARCHAR2,
   subject_   IN VARCHAR2) RETURN VARCHAR2
IS
   options_ VARCHAR2(2000);
BEGIN
   IF file_name_ IS NOT NULL THEN
      options_ := 'FILE_NAME=' || file_name_;
   END IF;
   IF subject_ IS NOT NULL THEN
      IF options_ IS NOT NULL THEN
         options_ := options_ || CHR(10);
      END IF;
      options_ := options_ || 'SUBJECT=' || subject_;
   END IF;
   RETURN options_;
END Format_Mail_Options_;


--
-- Convert client address columns to runtime address columns
--
PROCEDURE To_Runtime_Addresses_ (
   runtime_addresses_ IN OUT Connect_Runtime_Addresses_Type,
   client_addresses_  IN     Routing_Addresses) IS
   BEGIN
   SELECT Connect_Runtime_Address_Type(address_name,
                                       transport_connector,
                                       sender_instance,
                                       address_data,
                                       address_data_2,
                                       options,
                                       envelope,
                                       encoding,
                                       sender,
                                       sender_organization,
                                       receiver,
                                       receiver_organization,
                                       transformer,
                                       response_transformer,
                                       zip,
                                       envelope_response)
   BULK COLLECT INTO runtime_addresses_
   FROM
   (
      SELECT
         address_name,
         transport_connector,
         sender_instance,
         CASE transport_connector
            WHEN 'REST'   THEN rest_root_end_point
            WHEN 'Ftp'    THEN output_file
            WHEN 'Sftp'   THEN output_file
            WHEN 'File'   THEN output_file
            WHEN 'PL/SQL' THEN plsql_method
            WHEN 'JMS'    THEN destination
            WHEN 'Http'   THEN url
            WHEN 'Mail'   THEN send_to
            WHEN 'Projection' THEN projection_resource
            WHEN 'Custom' THEN custom_address_data
         END address_data,
         CASE transport_connector
            WHEN 'REST' THEN authentication_method
            WHEN 'Ftp'  THEN directory
            WHEN 'Sftp' THEN directory
            WHEN 'Http' THEN soap_action
            WHEN 'Mail' THEN cc
            WHEN 'Projection' THEN projection_method
         END address_data_2,
         CASE transport_connector
            WHEN 'REST' THEN
               Format_Http_Options_(CASE authentication_method
                                       WHEN 'OAuth2.0 Client Credentials' THEN 'ClientCredentials'
                                       WHEN 'OAuth2.0 ROPC'               THEN 'ROPC'
                                       ELSE authentication_method
                                    END,
                                    CASE authentication_method
                                       WHEN 'None'                        THEN Format_None_Auth_Value_(rest_http_method)
                                       WHEN 'Basic'                       THEN Format_Basic_Auth_Value_(user_id, password, rest_http_method)
                                       WHEN 'Bearer'                      THEN Format_Bearer_Auth_Value_(api_key, rest_http_method)
                                       WHEN 'Azure Shared Key'            THEN Format_Azure_Auth_Value_(api_key, rest_http_method)
                                       WHEN 'OAuth2.0 Client Credentials' THEN Format_Client_Auth_Value_(client_id, client_secret, token_endpoint, protected_resource, token_endpoint_parameters, rest_http_method)
                                       WHEN 'OAuth2.0 ROPC'               THEN Format_Ropc_Auth_Value_(user_id, password, token_endpoint, token_endpoint_parameters, rest_http_method, client_id, client_secret)
                                    END,
                                    additional_headers)
            WHEN 'Mail' THEN Format_Mail_Options_(attachment_name, subject)
            WHEN 'Http' THEN Format_Http_Options_('Basic', Routing_Address_API.Format_Http_Basic_Auth_Value_(user_id, password), additional_headers)
         END options,
         envelope,
         encoding,
         sender,
         sender_organization,
         receiver,
         receiver_organization,
         transformer,
         response_transformer,
         zip,
         envelope_response
      FROM
         TABLE(client_addresses_)
   );
END To_Runtime_Addresses_;


PROCEDURE Xml_Transformed_Columns_ (
   hidden_columns_  OUT VARCHAR2,
   special_columns_ OUT VARCHAR2) IS
BEGIN
   hidden_columns_ := 'PASSWORD';
END Xml_Transformed_Columns_;


PROCEDURE Set_Customized_ (
   address_name_ IN VARCHAR2,
   customized_   IN BOOLEAN)
IS
   rec_  routing_address_tab%ROWTYPE := Lock_By_Keys_Nowait___(address_name_);
   flag_ NUMBER := CASE customized_ WHEN TRUE THEN 1 ELSE 0 END;
BEGIN
   UPDATE routing_address_tab
      SET customized = flag_, rowversion = rec_.rowversion + 1
    WHERE address_name = address_name_;
END Set_Customized_;

FUNCTION Check_Customizability_(address_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   enabled_  BOOLEAN;
   temp_ NUMBER;
   CURSOR check_cuztomizability
IS
   SELECT customized
   FROM routing_address_tab
   WHERE address_name = address_name_;
BEGIN
   OPEN check_cuztomizability;
   FETCH check_cuztomizability INTO temp_;
   CLOSE check_cuztomizability;
   IF (temp_ = 1) THEN
      enabled_ := TRUE;
   ELSE
      enabled_ := FALSE;
   END IF;
   RETURN enabled_;
END Check_Customizability_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


