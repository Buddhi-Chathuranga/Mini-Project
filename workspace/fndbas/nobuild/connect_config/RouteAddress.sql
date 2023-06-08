-----------------------------------------------------------------------------
-- File    : RouteAddress.sql
--
-- Purpose : SQL script generating INS file for routing addresses
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON FORMAT WRAPPED LINESIZE 2500 VERIFY OFF TAB OFF TRIM ON FEEDBACK OFF DEFINE ON TRIMSPOOL ON

DEFINE COMPONENT = FNDBAS
DEFINE INSFILE = RouteAddress.ins

spool ../../source/fndbas/database/&INSFILE

BEGIN
   Connect_Config_API.Export_Route_Address
     ('&COMPONENT',
      '&INSFILE',
      Ins_Util_API.List
        ('Example: To a JMS queue or topic',
         'Example: To a file',
         'Example: GetTestOrder',
         'Load Connectivity Inbox',
         'Example: Mail to someone',
         'Example: ReceiveTestOrder',
         'Start Workflow',
         'Workflow Callback'),
      debug_ => FALSE);
END;
/

spool off

