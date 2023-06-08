
-----------------------------------------------------------------------------------------
--
--  Module:       FNDBAS
--
--  File:         POST_FNDBAS_FixModuleBasicDataTranslations.sql
--
--  Purpose:      Changing module name values with 'Temporary Description' and '<module> name' to correct values
-----------------------------------------------------------------------------------------
--  Date    Sign      History
--  ------  ------    -------------------------------------------------------------------
--  170120  NaBaLK    Created.
-----------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_FixModuleBasicDataTranslations.sql','Started');
PROMPT Fix "TemporaryDescription" and "<module> name" description in basic data translations for modules

SET SERVEROUTPUT ON

DECLARE
  CURSOR get_temp_desc IS
    SELECT substr(path, instr(l.path, '.') + 1) module, m.name
      FROM language_sys_tab l, module_tab m
     WHERE substr(path, instr(l.path, '.') + 1) = m.module(+)
       AND l.module = 'FNDBAS'
       AND l.path LIKE 'Module_FNDBAS.%'
       AND (l.installation_text IN ('TemporaryDescription', m.module || ' name') OR
            l.text IN ('TemporaryDescription', m.module || ' name'));
BEGIN
  FOR rec_ IN get_temp_desc LOOP
    Basic_Data_Translation_API.Remove_Basic_Data_Translation('FNDBAS', 'Module', rec_.module);
    IF (rec_.name IS NOT NULL) THEN
      Basic_Data_Translation_API.Insert_Basic_Data_Translation('FNDBAS', 'Module', rec_.module, NULL, rec_.name);
    END IF;
  END LOOP;

  COMMIT;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_FixModuleBasicDataTranslations.sql','Done');

