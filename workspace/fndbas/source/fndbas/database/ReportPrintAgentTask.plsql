-----------------------------------------------------------------------------
--
--  Logical unit: ReportPrintAgentTask
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Report_Print_Agent_Tasks IS TABLE OF report_print_agent_task_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     report_print_agent_task_tab%ROWTYPE,
   newrec_ IN OUT report_print_agent_task_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 ) IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Report_Config_API.Encrypt_(newrec_.debug_password, indrec_.debug_password);
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT report_print_agent_task_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Report_Runtime_API.Sync_Print_Agent_Task_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     report_print_agent_task_tab%ROWTYPE,
   newrec_     IN OUT report_print_agent_task_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Report_Runtime_API.Sync_Print_Agent_Task_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN report_print_agent_task_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Report_Runtime_API.Remove_Print_Agent_Task_(remrec_.instance_name);
END Delete___;

PROCEDURE Set_Default_Values___(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('DESCRIPTION','Description of '||instance_name_, attr_);
   Client_SYS.Add_To_Attr('DEBUG_LEVEL_DB','ERROR', attr_);
   Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE','en', attr_);
   Client_SYS.Add_To_Attr('PRINT_LOCALE','en-US', attr_);
   Client_SYS.Add_To_Attr('EXECUTE_AS_DB','System', attr_);
   Client_SYS.Add_To_Attr('LOCALE','en-US', attr_);

END Set_Default_Values___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Setup_Attributes__(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2,
   queue_name_    IN  VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_ ,instance_name_ );
   Client_SYS.Add_To_Attr('INSTANCE_NAME', instance_name_, attr_);
   Client_SYS.Add_To_Attr('QUEUE', queue_name_, attr_);
END Setup_Attributes__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE To_Runtime_Params_ (
   params_ IN OUT Report_Runtime_Params_Type,
   tasks_  IN     Report_Print_Agent_Tasks) IS
BEGIN
   SELECT Report_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'TaskTemplates'                                        group_name,
            instance_name,                                         -- primary key
            'PrintAgent'                                           instance_type,
            queue,                                                 -- parameters
            execute_as,
            locale,
            print_locale,
            default_language,
            debug_level,
            report_formatter_name,
            debug_url,
            debug_password
         FROM
            TABLE(tasks_)
      )
      SELECT *
      FROM client
      UNPIVOT INCLUDE NULLS
      (
         parameter_value
         FOR parameter_name IN
         (
            queue,                                                 -- parameters
            execute_as,
            locale,
            print_locale,
            default_language,
            debug_level,
            report_formatter_name,
            debug_url,
            debug_password
         )
      )
   );
END To_Runtime_Params_;


PROCEDURE Xml_Transformed_Columns_ (
   hidden_columns_  OUT VARCHAR2,
   special_columns_ OUT VARCHAR2) IS
BEGIN
   hidden_columns_ := 'DEBUG_PASSWORD';
END Xml_Transformed_Columns_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

