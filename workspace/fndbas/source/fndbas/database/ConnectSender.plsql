-----------------------------------------------------------------------------
--
--  Logical unit: ConnectSender
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Senders IS TABLE OF connect_sender_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Own_Attributes___ (
   instance_type_ IN VARCHAR2) RETURN VARCHAR2
IS
   common_ VARCHAR2(32000);
   own_    VARCHAR2(32000);
BEGIN
   Connect_Sender_Meta_API.Enumerate_Common_Db(common_);
   CASE instance_type_
      WHEN Connector_Instance_Type_API.DB_FILE   THEN Connect_Sender_Meta_API.Enumerate_File_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_FTP    THEN Connect_Sender_Meta_API.Enumerate_Ftp_Db   (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP   THEN Connect_Sender_Meta_API.Enumerate_Sftp_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_HTTP   THEN Connect_Sender_Meta_API.Enumerate_Http_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_REST   THEN Connect_Sender_Meta_API.Enumerate_Rest_Db  (own_);      
      WHEN Connector_Instance_Type_API.DB_MAIL   THEN Connect_Sender_Meta_API.Enumerate_Mail_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_CUSTOM THEN Connect_Sender_Meta_API.Enumerate_Custom_Db(own_);
   END CASE;
   own_ := common_ || own_;
   Dbms_Output.Put_Line('Own_Attributes: ' || own_);
   RETURN own_;
END Get_Own_Attributes___;


FUNCTION Get_Mandatory_Attributes___ (
   instance_type_ IN VARCHAR2) RETURN VARCHAR2
IS
   common_ VARCHAR2(32000);
   own_    VARCHAR2(32000);
BEGIN
   Connect_Sender_Meta_API.Enumerate_Common_Mandatory_Db(common_);
   CASE instance_type_
      WHEN Connector_Instance_Type_API.DB_FILE   THEN Connect_Sender_Meta_API.Enumerate_File_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_FTP    THEN Connect_Sender_Meta_API.Enumerate_Ftp_Mandatory_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP   THEN Connect_Sender_Meta_API.Enumerate_Sftp_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_HTTP   THEN NULL;
      WHEN Connector_Instance_Type_API.DB_REST   THEN NULL;
      WHEN Connector_Instance_Type_API.DB_MAIL   THEN Connect_Sender_Meta_API.Enumerate_Mail_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_CUSTOM THEN Connect_Sender_Meta_API.Enumerate_Custom_Mandatory_Db  (own_);
   END CASE;
   own_ := common_ || own_;
   Dbms_Output.Put_Line('Mandatory_Attributes: ' || own_);
   RETURN own_;
END Get_Mandatory_Attributes___;


@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT connect_sender_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   instance_type_ VARCHAR2(100) := NVL(newrec_.instance_type, Connector_Instance_Type_API.Get_Db_Value_From_Attr('INSTANCE_TYPE', attr_));
   not_own_attr_  VARCHAR2(32000);
BEGIN
   Connect_Config_API.Move_Not_Own_Attributes_(attr_, not_own_attr_, Get_Own_Attributes___(instance_type_));
   super(newrec_, indrec_, attr_);
   Connect_Config_API.Copy_Attributes_(not_own_attr_, attr_);
END Unpack___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     connect_sender_tab%ROWTYPE,
   newrec_ IN OUT connect_sender_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   new_attr_ VARCHAR2(32000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Connect_Config_API.Encrypt_(newrec_.password, indrec_.password);
   Connect_Config_API.Encrypt_(newrec_.pass_phrase, indrec_.pass_phrase);
   new_attr_ := Pack_Table___(newrec_);
   Connect_Config_API.Validate_Mandatory_Attributes_(lu_name_, new_attr_, Get_Mandatory_Attributes___(newrec_.instance_type));
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_sender_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Sender_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_sender_tab%ROWTYPE,
   newrec_     IN OUT connect_sender_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE ) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Sender_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_sender_tab%ROWTYPE ) IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Sender_(remrec_.instance_name);
END Delete___;


PROCEDURE Set_Default_Values___(
   attr_          OUT VARCHAR2,
   instance_name_  IN  VARCHAR2,
   instance_type_ IN  VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('DESCRIPTION','Description of '|| instance_name_ , attr_);
   Client_SYS.Add_To_Attr('MAX_RETRIES',10, attr_);
   Client_SYS.Add_To_Attr('RETRY_INTERVAL', 10, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_INSTANCE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('STATIC_CONFIG', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('WORK_TIMEOUT', 60, attr_);
   IF (instance_type_ = 'File') THEN
      Client_SYS.Add_To_Attr('WRITE_MODE_DB', 'CREATE_NEW', attr_);
      Client_SYS.Add_To_Attr('OUT_DIRECTORY', '\\hostname\outDirectory', attr_);
      Client_SYS.Add_To_Attr('WRITE_TO_DESTINATION', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('CREATE_LOCK_FILE', 'FALSE', attr_);
   END IF;
   IF (instance_type_ = 'Ftp') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PORT', '0', attr_);
      Client_SYS.Add_To_Attr('CONNECT_MODE_DB', 'PASSIVE', attr_);
      Client_SYS.Add_To_Attr('FTP_SECURITY_PROTOCOL_DB', 'TLS', attr_);
      Client_SYS.Add_To_Attr('USE_EPS_WITH_IPV4', 'FALSE', attr_);
   END IF;
   IF (instance_type_ = 'Sftp') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PORT', '0', attr_);
      Client_SYS.Add_To_Attr('USERAUTH_METHOD_DB', 'PasswordAuth', attr_);
      Client_SYS.Add_To_Attr('KNOWNHOSTS_FILE', 'C:\IFS\sftp_knowhosts', attr_);
   END IF;
   IF (instance_type_ = 'REST') THEN
      Client_SYS.Add_To_Attr('DEFAULT_RESP_ENCODING', 'UTF-8', attr_);
   END IF;
    IF (instance_type_ = 'Http') THEN
      Client_SYS.Add_To_Attr('DEFAULT_RESP_ENCODING', 'UTF-8', attr_);
   END IF;
   IF (instance_type_ = 'Mail') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PERFORM_AUTH', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('OVERRIDE_MAIL_SENDER', 'FALSE', attr_);
      Client_SYS.Add_To_Attr('CONTENT_TYPE_DB', 'text/plain', attr_);
      Client_SYS.Add_To_Attr('PORT', '465', attr_);
      Client_SYS.Add_To_Attr('MAIL_SECURITY_PROTOCOL_DB', 'TLS', attr_);
      Client_SYS.Add_To_Attr('DEFAULT_MAIL_SENDER', 'connect@localhost', attr_);
      Client_SYS.Add_To_Attr('TIMEOUT', 60, attr_);
   END IF;
     IF (instance_type_ = 'JMS') THEN
      Client_SYS.Add_To_Attr('CONNECTION_FACTORY', 'IfsConnectConnectionFactory', attr_);
      Client_SYS.Add_To_Attr('SEND_TEXT_MESSAGE', 'FALSE', attr_);
   END IF;

END Set_Default_Values___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Setup_Attributes__(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2,
   instance_type_ IN  VARCHAR2,
   user_name_     IN  VARCHAR2,
   password_      IN  VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_,instance_name_, instance_type_);
   Client_SYS.Add_To_Attr('INSTANCE_NAME', instance_name_, attr_);
   Client_SYS.Add_To_Attr('INSTANCE_TYPE_DB',instance_type_, attr_);
   IF (instance_type_ = 'File') THEN
      Client_SYS.Add_To_Attr('USER_NAME', user_name_, attr_);
      Client_SYS.Add_To_Attr('PASSWORD', password_, attr_);
   END IF;
END Setup_Attributes__;

PROCEDURE Setup_Attributes__(
   attr_           OUT VARCHAR2,
   custom_lu_name_ IN  VARCHAR2,
   custom_type_    IN  VARCHAR2,
   factory_class_  IN  VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_,custom_lu_name_, 'Custom');
   Client_SYS.Add_To_Attr('INSTANCE_NAME', custom_lu_name_, attr_);
   Client_SYS.Add_To_Attr('INSTANCE_TYPE_DB', 'Custom', attr_);
   Client_SYS.Add_To_Attr('CUSTOM_LU_NAME', custom_lu_name_, attr_);
   Client_SYS.Add_To_Attr('CUSTOM_TYPE', custom_type_, attr_);
   Client_SYS.Add_To_Attr('FACTORY_CLASS', factory_class_, attr_);
END Setup_Attributes__;


PROCEDURE Sync_Custom_Sender__ (
   instance_name_ IN VARCHAR2)
IS
   rec_ connect_sender_tab%ROWTYPE := Lock_By_Keys___(instance_name_);
BEGIN
   Connect_Runtime_API.Sync_Sender_(rec_);
END Sync_Custom_Sender__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
--
-- Convert client entity columns to runtime config parameter rows
--
PROCEDURE To_Runtime_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   senders_ IN     Connect_Senders) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'ConnectorSenders'      group_name,
            instance_name,          -- primary key
            instance_type,          -- enum corresponding to Aurena form
            to_char(max_retries)    max_retries, -- convert to VARCHAR2
            to_char(retry_interval) retry_interval,
            default_instance,
            to_char(work_timeout)   work_timeout,
            write_mode,
            out_directory,
            write_to_destination,
            create_lock_file,
            temp_directory,
            decode(instance_type, 'Ftp', ftp_security_protocol, 'Mail', mail_security_protocol, NULL) security_protocol,
            connect_mode,
            use_eps_with_ipv4,
            host,
            to_char(port)           port,
            user_name,
            password,
            knownhosts_file,
            userauth_method,
            prvkey_file,
            pass_phrase,
            accepted_codes,
            default_resp_encoding,
            trace_path,
            connection_factory,
            send_text_message,
            to_char(timeout)        timeout,
            perform_auth,
            default_mail_sender,
            override_mail_sender,
            content_type,
            custom_type,
            factory_class
         FROM
            TABLE(senders_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            max_retries,
            retry_interval,
            default_instance,
            work_timeout,
            write_mode,
            out_directory,
            write_to_destination,
            create_lock_file,
            temp_directory,
            security_protocol,
            connect_mode,
            use_eps_with_ipv4,
            host,
            port,
            user_name,
            password,
            knownhosts_file,
            userauth_method,
            prvkey_file,
            pass_phrase,
            accepted_codes,
            default_resp_encoding,
            trace_path,
            connection_factory,
            send_text_message,
            timeout,
            perform_auth,
            default_mail_sender,
            override_mail_sender,
            content_type,
            custom_type,
            factory_class
         )
      )
   );
END To_Runtime_Params_;


PROCEDURE To_Custom_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   senders_ IN     Connect_Senders)
IS
   TYPE REF_CURSOR IS REF CURSOR;

   ref_cursor_  REF_CURSOR;
   stmt_        VARCHAR2(4000);
   param_name_  VARCHAR2(50);
   param_value_ VARCHAR2(4000);
BEGIN
   FOR sender_ IN (SELECT instance_name, custom_lu_name
                     FROM TABLE(senders_)
                    WHERE instance_type = 'Custom'
                      AND custom_lu_name IS NOT NULL) LOOP

      stmt_ := 'select parameter_name, parameter_value
                 from custom_sender_param_tab 
                where instance_name = :1 ';
      @ApproveDynamicStatement(2019-11-27,japase)
      OPEN  ref_cursor_ FOR stmt_ USING sender_.instance_name;
      LOOP
         FETCH ref_cursor_ INTO param_name_, param_value_;
         EXIT WHEN ref_cursor_%NOTFOUND;
         params_.EXTEND;
         params_(params_.COUNT) := Connect_Runtime_Param_Type('ConnectorSenders', sender_.instance_name, 'Custom', param_name_, param_value_);
      END LOOP;
      CLOSE ref_cursor_;

   END LOOP;
END To_Custom_Params_;


PROCEDURE Xml_Transformed_Columns_ (
   hidden_columns_  OUT VARCHAR2,
   special_columns_ OUT VARCHAR2) IS
BEGIN
   hidden_columns_ := 'PASSWORD, PASS_PHRASE';
END Xml_Transformed_Columns_;



-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

