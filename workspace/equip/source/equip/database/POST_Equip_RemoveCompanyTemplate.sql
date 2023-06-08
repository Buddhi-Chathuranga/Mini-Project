-----------------------------------------------------------------------------
--  Module : EQUIP
--
--  File   : POST_Equip_RemoveCompanyTemplate.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220113   deeklk  AM21R2-3800: Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RemoveCompanyTemplate.sql','Timestamp_1');
PROMPT Removing Company Templates for EQUIP

BEGIN
   Create_Company_API.Remove_Company_Templs_Per_Comp('EQUIP');
   COMMIT;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RemoveCompanyTemplate.sql','Timestamp_2');
PROMPT Removing EQUIP from crecomp_component_tab

BEGIN
   Crecomp_Component_API.Remove_Crecomp_Component('EQUIP');
   COMMIT;
END;
/

PROMPT Finished POST_Equip_RemoveCompanyTemplate.sql

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_RemoveCompanyTemplate.sql','Done');