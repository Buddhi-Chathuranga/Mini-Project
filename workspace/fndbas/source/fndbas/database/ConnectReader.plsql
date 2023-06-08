-----------------------------------------------------------------------------
--
--  Logical unit: ConnectReader
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------
--  2019-11-01  madrse  PACZDATA-1639: Create sync procedure that fills Connect Config runtime tables based on Aurena entities
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Readers IS TABLE OF connect_reader_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Own_Attributes___ (
   instance_type_ IN VARCHAR2) RETURN VARCHAR2
IS
   common_ VARCHAR2(32000);
   own_    VARCHAR2(32000);
BEGIN
   Connect_Reader_Meta_API.Enumerate_Common_Db(common_);
   CASE instance_type_
      WHEN Connector_Instance_Type_API.DB_FILE   THEN Connect_Reader_Meta_API.Enumerate_File_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_FTP    THEN Connect_Reader_Meta_API.Enumerate_Ftp_Db   (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP   THEN Connect_Reader_Meta_API.Enumerate_Sftp_Db  (own_);      
      WHEN Connector_Instance_Type_API.DB_MAIL   THEN Connect_Reader_Meta_API.Enumerate_Mail_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_CUSTOM THEN Connect_Reader_Meta_API.Enumerate_Custom_Db(own_);
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
   Connect_Reader_Meta_API.Enumerate_Common_Mandatory_Db(common_);
   CASE instance_type_
      WHEN Connector_Instance_Type_API.DB_FILE   THEN Connect_Reader_Meta_API.Enumerate_File_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_FTP    THEN Connect_Reader_Meta_API.Enumerate_Ftp_Mandatory_Db  (own_);
      WHEN Connector_Instance_Type_API.DB_SFTP   THEN Connect_Reader_Meta_API.Enumerate_Sftp_Mandatory_Db (own_);
      WHEN Connector_Instance_Type_API.DB_MAIL   THEN Connect_Reader_Meta_API.Enumerate_Mail_Mandatory_Db (own_);      
      WHEN Connector_Instance_Type_API.DB_CUSTOM THEN Connect_Reader_Meta_API.Enumerate_Custom_Mandatory_Db  (own_);
   END CASE;
   own_ := common_ || own_;
   Dbms_Output.Put_Line('Mandatory_Attributes: ' || own_);
   RETURN own_;
END Get_Mandatory_Attributes___;


@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT connect_reader_tab%ROWTYPE,
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
   oldrec_ IN     connect_reader_tab%ROWTYPE,
   newrec_ IN OUT connect_reader_tab%ROWTYPE,
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
   newrec_     IN OUT connect_reader_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Reader_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_reader_tab%ROWTYPE,
   newrec_     IN OUT connect_reader_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE ) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Reader_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_reader_tab%ROWTYPE ) IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Reader_(remrec_.instance_name);
END Delete___;


PROCEDURE Set_Default_Values___(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2,
   instance_type_ IN  VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('DESCRIPTION', 'Description of '|| instance_name_ , attr_);
   Client_SYS.Add_To_Attr('ENABLED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('EXECUTION_MODE_DB', 'InParallel', attr_);
   Client_SYS.Add_To_Attr('CREATE_RESPONSE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('LOG_LEVEL_DB', 'WARNING', attr_);
   Client_SYS.Add_To_Attr('MESSAGE_SELECTOR', '*', attr_);
   Client_SYS.Add_To_Attr('MAX_RETRIES', 5, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_ENCODING', 'UTF-8', attr_);
   Client_SYS.Add_To_Attr('WORK_TIMEOUT', 60, attr_);
   IF (instance_type_ = 'File') THEN
      Client_SYS.Add_To_Attr('IN_DIRECTORY', '\\hostname\inDirectory', attr_);
      Client_SYS.Add_To_Attr('IGNORE_IF_NOT_FOUND', 'TRUE', attr_);   
   END IF;
   IF (instance_type_ = 'Ftp') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PORT', '0', attr_);
      Client_SYS.Add_To_Attr('SECURITY_PROTOCOL_DB', 'SSL', attr_);
      Client_SYS.Add_To_Attr('CONNECT_MODE_DB', 'PASSIVE', attr_);
      Client_SYS.Add_To_Attr('USE_EPS_WITH_IPV4', 'FALSE', attr_);
      Client_SYS.Add_To_Attr('IGNORE_IF_NOT_FOUND', 'TRUE', attr_);
   END IF;
   IF (instance_type_ = 'Sftp') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PORT', '0', attr_);
      Client_SYS.Add_To_Attr('IN_DIRECTORY', '$FNDEXT_HOME/../filerep1/$INSTANCE/in', attr_);
      Client_SYS.Add_To_Attr('IGNORE_IF_NOT_FOUND', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('USERAUTH_METHOD_DB', 'PasswordAuth', attr_);
      Client_SYS.Add_To_Attr('KNOWNHOSTS_FILE', '$FNDEXT_HOME/sftp_knowhosts.txt', attr_);
   END IF;
   IF (instance_type_ = 'Mail') THEN
      Client_SYS.Add_To_Attr('HOST', 'localhost', attr_);
      Client_SYS.Add_To_Attr('PORT', '993', attr_);
      Client_SYS.Add_To_Attr('SECURITY_PROTOCOL_DB', 'TLS', attr_);
      Client_SYS.Add_To_Attr('MAIL_PROTOCOL_DB', 'IMAP', attr_);
      Client_SYS.Add_To_Attr('PARSE_BODY', 'FALSE', attr_);
   END IF;
   IF (instance_type_ = 'JMS') THEN
      Client_SYS.Add_To_Attr('IN_QUEUE', 'IfsConnectInQueue', attr_);
      Client_SYS.Add_To_Attr('CONNECTION_FACTORY', 'IfsConnectConnectionFactory', attr_);
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
   Client_SYS.Add_To_Attr('INSTANCE_TYPE_DB', instance_type_, attr_);
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


PROCEDURE Sync_Custom_Reader__ (
   instance_name_ IN VARCHAR2)
IS
   rec_ connect_reader_tab%ROWTYPE := Lock_By_Keys___(instance_name_);
BEGIN
   Connect_Runtime_API.Sync_Reader_(rec_);
END Sync_Custom_Reader__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Convert client entity columns to runtime config parameter rows
--
PROCEDURE To_Runtime_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   readers_ IN     Connect_Readers) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'ConnectorReaders'      group_name,
            instance_name,          -- primary key
            instance_type,          -- enum corresponding to Aurena form
            create_response,        -- parameters
            default_encoding,
            enabled,
            execution_mode,
            log_level,
            to_char(max_retries)    max_retries, -- convert to VARCHAR2
            message_selector,
            to_char(work_timeout)   work_timeout,
            archive_directory,
            ignore_if_not_found,
            in_directory,
            host,
            password,
            to_char(port)           port,
            user_name,
            security_protocol,
            use_eps_with_ipv4,
            connect_mode,
            knownhosts_file,
            pass_phrase,
            prvkey_file,
            userauth_method,
            connection_factory,
            in_queue,
            mail_protocol,
            parse_body,
            to_char(timeout)       timeout,
            custom_type,
            factory_class
         FROM
            TABLE(readers_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            create_response,
            default_encoding,
            enabled,
            execution_mode,
            log_level,
            max_retries,
            message_selector,
            work_timeout,
            archive_directory,
            ignore_if_not_found,
            in_directory,
            host,
            password,
            port,
            user_name,
            security_protocol,
            use_eps_with_ipv4,
            connect_mode,
            knownhosts_file,
            pass_phrase,
            prvkey_file,
            userauth_method,
            connection_factory,
            in_queue,
            mail_protocol,
            parse_body,
            timeout,
            custom_type,
            factory_class
         )
      )
   );
END To_Runtime_Params_;


PROCEDURE To_Custom_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   readers_ IN     Connect_Readers)
IS
   TYPE REF_CURSOR IS REF CURSOR;
   
   ref_cursor_  REF_CURSOR;
   stmt_        VARCHAR2(4000);
   param_name_  VARCHAR2(50);
   param_value_ VARCHAR2(4000);
BEGIN
   FOR reader_ IN (SELECT instance_name, custom_lu_name
                     FROM TABLE(readers_)
                    WHERE instance_type = 'Custom'
                      AND custom_lu_name IS NOT NULL) LOOP
      
      stmt_ := 'select parameter_name, parameter_value
                 from custom_reader_param_tab 
                where instance_name = :1 ';
      @ApproveDynamicStatement(2019-11-27,japase)
      OPEN  ref_cursor_ FOR stmt_ USING reader_.instance_name;
   LOOP
      FETCH ref_cursor_ INTO param_name_, param_value_;
      EXIT WHEN ref_cursor_%NOTFOUND;
      params_.EXTEND;
      params_(params_.COUNT) := Connect_Runtime_Param_Type('ConnectorReaders', reader_.instance_name, 'Custom', param_name_, param_value_);
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

