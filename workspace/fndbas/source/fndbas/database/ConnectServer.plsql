-----------------------------------------------------------------------------
--
--  Logical unit: ConnectServer
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Servers IS TABLE OF connect_server_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_server_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )  IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Server_(newrec_);
END Insert___;


@Override
PROCEDURE Update___(
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_server_tab%ROWTYPE,
   newrec_     IN OUT connect_server_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE ) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Server_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_server_tab%ROWTYPE ) IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Server_(remrec_.instance_name);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Setup_Attributes__(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_, instance_name_);
   Client_SYS.Add_To_Attr('INSTANCE_NAME_DB', instance_name_, attr_);
END Setup_Attributes__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE To_Runtime_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   servers_ IN     Connect_Servers) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'Servers'                         group_name,
            instance_name,                    -- primary key
            'J2EEServer'                      instance_type,
            cbr_on_error,                     -- parameters
            to_char(cbr_on_error_max_size)    cbr_on_error_max_size,
            to_char(default_work_timeout)     default_work_timeout,
            to_char(plsql_max_retries)        plsql_max_retries,
            to_char(plsql_retry_interval)     plsql_retry_interval
         FROM
            TABLE(servers_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            cbr_on_error,           -- parameters
            cbr_on_error_max_size,
            default_work_timeout,
            plsql_max_retries,
            plsql_retry_interval
         )
      )
   );
END To_Runtime_Params_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------



-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Set_Default_Values___(
   attr_          OUT VARCHAR2,
   instance_name_  IN  VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('DESCRIPTION', 'Description of '|| instance_name_, attr_);
   Client_SYS.Add_To_Attr('CBR_ON_ERROR', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CBR_ON_ERROR_MAX_SIZE', 10, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_WORK_TIMEOUT', 600, attr_);
   Client_SYS.Add_To_Attr('PLSQL_MAX_RETRIES', 10, attr_);
   Client_SYS.Add_To_Attr('PLSQL_RETRY_INTERVAL', 10, attr_);
END Set_Default_Values___;