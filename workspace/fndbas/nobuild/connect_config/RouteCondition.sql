-----------------------------------------------------------------------------
-- File    : RouteCondition.sql
--
-- Purpose : SQL script generating INS file for routing conditions
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON FORMAT WRAPPED LINESIZE 2500 VERIFY OFF TAB OFF TRIM ON FEEDBACK OFF DEFINE ON TRIMSPOOL ON

DEFINE COMPONENT = FNDBAS
DEFINE INSFILE = RouteCondition.ins

spool ../../source/fndbas/database/&INSFILE

BEGIN
   Connect_Config_API.Export_Route_Condition
     ('&COMPONENT',
      '&INSFILE',
      Ins_Util_API.List
        ('Example: SOAP_IFS Get Test Order',
         'Example: SOAP_IFS Receive Test Order',
         'Example: Outbound Send Test Order',
         'Start Workflow',
         'Workflow Callback',
         'Connect Reader response'),
      debug_ => FALSE);
END;
/

spool off

