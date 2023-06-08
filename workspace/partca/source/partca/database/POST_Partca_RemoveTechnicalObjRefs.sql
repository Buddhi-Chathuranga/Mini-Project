----------------------------------------------------------------------------------------------
--
--  Filename        : POST_PARTCA_RemoveTechnicalObjRefs.sql
--
--  Module          : PARTCA
--
--  Purpose         : Delete records that do not exist in PART_CATALOG_TAB from TECHNICAL_OBJECT_REFERENCE_TAB
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------------------------
--  150109  Chfose  PRSC-4839, Modified the WHERE-statement to remove the last character from key_value.
--  141224  HAPULK  PRSC-4781, Added TimeStamps
--  110516  HAPULK  EASTONE-18077, Removed SPOOL command since no need to spool the result
--  110316  HAYALK  Created.
----------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_RemoveTechnicalObjRefs.sql','Timestamp_1');
PROMPT Starting POST_PARTCA_V1300_RemoveTechnicalObjRefs.sql

exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_RemoveTechnicalObjRefs.sql','Timestamp_2');
PROMPT Deleting records that do not exist in PART_CATALOG_TAB from TECHNICAL_OBJECT_REFERENCE_TAB
DECLARE
   CURSOR get_tech_obj_ref IS
      SELECT key_value
      FROM   technical_object_reference_tab
      WHERE  lu_name = 'PartCatalog'
      AND NOT EXISTS (SELECT 1 FROM part_catalog_tab WHERE part_no = SUBSTR(key_value, 1, LENGTH(key_value) - 1));
BEGIN
   FOR rec_ IN get_tech_obj_ref LOOP
      Technical_Object_Reference_API.Delete_Reference('PartCatalog', rec_.key_value);
   END LOOP;
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_RemoveTechnicalObjRefs.sql','Timestamp_3');
PROMPT Finished with POST_PARTCA_V1300_RemoveTechnicalObjRefs.sql
exec Database_SYS.Log_Detail_Time_Stamp('PARTCA','POST_Partca_RemoveTechnicalObjRefs.sql','Done');



