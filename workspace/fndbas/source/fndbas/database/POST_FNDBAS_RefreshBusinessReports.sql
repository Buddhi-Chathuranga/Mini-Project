-----------------------------------------------------------------------------
--  Module : FNDBAS
--
--  File   : POST_FNDBAS_RefreshBusinessReports
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200227   RAKUSE  Created. (TEAURENAFW-2024)
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','200227_TEAURENAFW-2024_fndbas.cdb','Started');

PROMPT Removing obsolete Business Report projections, re-generating them using proper names.

DECLARE
   projection_name_  VARCHAR2(100);
   
   CURSOR published_br_reports IS
      SELECT REPORT_ID 
      FROM   REPORT_SYS_TAB t
      WHERE  REPORT_MODE = 'EXCEL1.0';
BEGIN
   FOR rec_ IN published_br_reports LOOP
      IF (REGEXP_SUBSTR(rec_.report_id, '^[A-Z]') IS NULL) THEN
         -- Projection and client metadata using names that starts with a number needs to be removed
         -- and re-generated using a proper name that begins with an alpha character.
         projection_name_ := Dictionary_SYS.Dbnametoclientname_(rec_.report_id);
         if (Fnd_Projection_API.Exists(projection_name_)) THEN
            Fnd_Projection_API.Remove_Projection(projection_name_, show_info_ => true, remove_plsql_package_ => false);
            Model_Design_Sys.Remove_Client_Metadata(projection_name_);
         END IF;
      END IF;
      Report_SYS.Init_Report_Metadata(rec_.report_id);     
   END LOOP;
   COMMIT;
   
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/
EXEC Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','200227_TEAURENAFW-2024_fndbas.cdb','Done');

SET SERVEROUTPUT OFF
