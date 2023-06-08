-----------------------------------------------------------------------------
-- File    : ConnectConfig.sql
--
-- Purpose : SQL script generating INS file for IFS Connect configuration
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON FORMAT WRAPPED LINESIZE 2500 VERIFY OFF TAB OFF TRIM ON FEEDBACK OFF DEFINE ON TRIMSPOOL ON

DEFINE COMPONENT = FNDBAS
DEFINE INSFILE = ConnectConfig.ins

spool ../../source/fndbas/database/&INSFILE

DECLARE
   cond_ VARCHAR2(4000);
BEGIN
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'ConnectorReaders', Ins_Util_API.List('FILE_READER1', 'FTP_READER1', 'JMS_READER1', 'MAIL_READER1', 'SFTP_READER1'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'ConnectorSenders', Ins_Util_API.List('FILE_SENDER1', 'FTP_SENDER1', 'HTTP_SENDER1', 'JMS_SENDER1', 'MAIL_SENDER1', 'SFTP_SENDER1'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'Envelopes'       , Ins_Util_API.List('SOAP_IFS', 'SOAP_SIMPLE'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'MessageQueues'   , Ins_Util_API.List('BATCH1', 'BATCH2', 'DEFAULT', 'ERROR', 'IN1', 'NOTIFICATIONS', 'OUT1', 'TRASHCAN', 'READER_RESPONSE'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'Routing'         , Ins_Util_API.List('INBOUND', 'OUTBOUND'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'Servers'         , Ins_Util_API.List('J2EE_SERVER'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'Transformers'    , Ins_Util_API.List('TO_IFSXML', 'TO_LOWER', 'TO_MIXED_CASE', 'REMOVE_NAMESPACE'), multiline_ => FALSE);
   Connect_Config_API.Add_Config_Instance_Condition (cond_, 'TaskTemplates'   , Ins_Util_API.List('PROCESSING_PRINT_JOBS'), multiline_ => FALSE);
   Connect_Config_API.Export_Connect_Config ('&COMPONENT', '&INSFILE', cond_, debug_ => FALSE);
END;
/

spool off

