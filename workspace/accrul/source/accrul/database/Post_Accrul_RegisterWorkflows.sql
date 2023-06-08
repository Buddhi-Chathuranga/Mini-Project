-----------------------------------------------------------------------------
--  Module : ACCRUL
--
--  File   : POST_Accrul_RegisterWorkflow.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220520   Nudilk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_1');
PROMPT START POST_Accrul_RegisterWorkflow.SQL


-- Workflow: finCurrencyTypeUpdate.
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_2');
PROMPT Adding finCurrencyTypeUpdate to workflows.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      Bpmn_Process_API.Add_Deployment_Process('finCurrencyTypeUpdate', 'IFS_system_install');
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_3');
PROMPT Adding Projection Actions FOR CurrencyRateTypesHandling.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      IF (Database_SYS.Component_Active('ACCRUL')) THEN
         Bpmn_Projection_API.Register_Projection_Action('finCurrencyTypeUpdate', 'CurrencyRateTypesHandling', 'UpdateCurrencyRatesFromWorkFlow(Company,CurrencyType):Void', NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'PROCESS_ENRICHMENT', 'BEFORE');
      END IF;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_4');
PROMPT Adding Projection Actions FOR CurrencyRatesHandling.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      IF (Database_SYS.Component_Active('ACCRUL')) THEN
         Bpmn_Projection_API.Register_Projection_Action('finCurrencyTypeUpdate', 'CurrencyRatesHandling', 'UpdateCurrencyRatesFromWorkFlow(Company,CurrencyType):Void', NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'PROCESS_ENRICHMENT', 'BEFORE');
      END IF;
   $ELSE
      NULL;
   $END
END;
/

-- Workflow: finUpdateCurrencyRatesForCurrencyTask.
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_5');
PROMPT Adding finUpdateCurrencyRatesForCurrencyTask to workflows.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      Bpmn_Process_API.Add_Deployment_Process('finUpdateCurrencyRatesForCurrencyTask', 'IFS_system_install');
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_6');
PROMPT Adding Projection Actions FOR TasksForCurrencyUpdatesHandling.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      IF (Database_SYS.Component_Active('ACCRUL')) THEN
         Bpmn_Projection_API.Register_Projection_Action('finUpdateCurrencyRatesForCurrencyTask', 'TasksForCurrencyUpdatesHandling', 'UpdateCurrencyRatesFromWorkFlow(TaskId):Void', NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'PROCESS_ENRICHMENT', 'BEFORE');
      END IF;
   $ELSE
      NULL;
   $END
END;
/



-- Workflow: finCentralCurrencyHandling.
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_7');
PROMPT Adding finCentralCurrencyHandling to workflows.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      Bpmn_Process_API.Add_Deployment_Process('finCentralCurrencyHandling', 'IFS_system_install');
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Timestamp_8');
PROMPT Adding Projection Actions FOR finCentralCurrencyHandling.

BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN
      IF (Database_SYS.Component_Active('ACCRUL')) THEN
         Bpmn_Projection_API.Register_Projection_Action('finCentralCurrencyHandling', 'CentralizedCurrencyRateHandling', 'UpdateCurrencyRatesFromWorkFlow(SourceCompany,SourceCurrRateType):Void', NULL, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'PROCESS_ENRICHMENT', 'BEFORE');
      END IF;
   $ELSE
      NULL;
   $END
END;
/

COMMIT;
exec Database_SYS.Log_Detail_Time_Stamp('ACCRUL','Post_Accrul_RegisterWorkflows.sql','Done');

