-----------------------------------------------------------------------------
--  Module        : APPSRV
--
--  File          : POST_Appsrv_DeleteTechnicalObjectRefofPartca.sql
--
--  Purpose       : To delete the references that remains in the Technical reference object tab even after the part_catalog entry is deleted.
--                  If performance issues are encountered a direct SQL delete should be implemented. 
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180307   shprlk  STRSA-36814 merge of Bug 140625, Added the conditional compilation as PARTCA is dynamic to APPSRV,
--  180201   shprlk  created for STRSC-16920, merge of 140011.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_DeleteTechnicalObjectRefofPartca.sql','Timestamp_1');
PROMPT Deleting TechnicalObjectReferences which has no reference within lu PARTCA

DECLARE
   $IF Component_Partca_SYS.INSTALLED $THEN
      CURSOR get_records IS 
         SELECT tor.key_value
         FROM   technical_object_reference_tab tor
         WHERE  tor.lu_name = 'PartCatalog'
         AND NOT EXISTS (SELECT 1
                         FROM   part_catalog_pub pcp
                         WHERE  pcp.part_no  = substr(tor.key_value, 0, length(tor.key_value) - 1));   
   $END
BEGIN   
   $IF Component_Partca_SYS.INSTALLED $THEN
      FOR rec_ IN get_records LOOP      
         Technical_Object_Reference_API.Delete_Reference('PartCatalog', rec_.key_value);
      END LOOP; 
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_DeleteTechnicalObjectRefofPartca.sql','Done');
PROMPT Finished with POST_Appsrv_DeleteTechnicalObjectRefofPartca.SQL
