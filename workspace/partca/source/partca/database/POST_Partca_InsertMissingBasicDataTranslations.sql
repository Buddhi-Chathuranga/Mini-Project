--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Partca_InsertMissingBasicDataTranslations.sql
--
--  Module      : PARTCA 13.1.0
--
--  Purpose     : Translations were missing for some basic data, in LUs that introduced basic data translation in APP8.
--                This is used to insert the missing basic data translations in 'PROG' language to such LUs.

--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  140813   ChBnlk  Bug 118250, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_InsertMissingBasicDataTranslations.sql','Timestamp_1');
PROMPT Starting POST_Partca_InsertMissingBasicDataTranslations.sql


exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_InsertMissingBasicDataTranslations.sql','Timestamp_2');
PROMPT Inserting the missing basic data translations for LU EngPartMainGroup
DECLARE
   CURSOR get_records IS
      SELECT part_main_group, description
      FROM   eng_part_main_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('PARTCA', 'EngPartMainGroup', rec_.part_main_group, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('PARTCA', 'EngPartMainGroup', rec_.part_main_group, 'PROG', rec_.description);
      END IF;
   END LOOP;

END;
/

PROMPT Finished with POST_Partca_InsertMissingBasicDataTranslations.sql
exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_InsertMissingBasicDataTranslations.sql','Done');
