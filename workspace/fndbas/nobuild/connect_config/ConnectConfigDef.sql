-----------------------------------------------------------------------------
-- File    : ConnectConfigDef.sql
--
-- Purpose : SQL script generating INS file for IFS Connect Config DEF tables
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON FORMAT WRAPPED LINESIZE 2500 VERIFY OFF TAB OFF TRIM ON FEEDBACK OFF DEFINE ON TRIMSPOOL ON

DEFINE COMPONENT = FNDBAS
DEFINE INSFILE = ConnectConfigDef.ins

spool ../../source/fndbas/database/&INSFILE

BEGIN
   Connect_Config_API.Export_Connect_Config_Def ('&COMPONENT', '&INSFILE', debug_ => FALSE);
END;
/

spool off

