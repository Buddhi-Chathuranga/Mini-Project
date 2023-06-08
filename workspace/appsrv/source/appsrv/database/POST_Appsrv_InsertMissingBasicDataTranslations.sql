--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Appsrv_InsertMissingBasicDataTranslations.sql
--
--  Module      : APPSRV
--
--  Purpose     : After introducing basic data translation support for a couple of LUs,
--                existing basic data records needs to be added as translatable.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  150309   JENASE  MIN-94, created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_InsertMissingBasicDataTranslations.sql','Timestamp_1');
PROMPT Starting POST_Appsrv_InsertMissingBasicDataTranslations


EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_InsertMissingBasicDataTranslations.sql','Timestamp_2');
PROMPT Inserting the missing basic data translations for LU QuaDispositionCode
DECLARE   
   CURSOR get_records IS
      SELECT disposition_code, disposition_description 
      FROM   qua_disposition_code_tab;       
BEGIN
   FOR rec_ IN get_records LOOP      
	 IF NOT(Basic_Data_Translation_API.Exist_Translation('APPSRV', 'QuaDispositionCode', rec_.disposition_code, 'PROG')) THEN
		Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'QuaDispositionCode', rec_.disposition_code, 'PROG', rec_.disposition_description);          
	 END IF;       
  END LOOP;    
END;
/


EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_InsertMissingBasicDataTranslations.sql','Timestamp_3');
PROMPT Inserting the missing basic data translations for LU QuaNonConformance
DECLARE   
   CURSOR get_records IS
      SELECT nonconformance_code, nonconformance_description 
      FROM   qua_non_conformance_tab;       
BEGIN
   FOR rec_ IN get_records LOOP      
	 IF NOT(Basic_Data_Translation_API.Exist_Translation('APPSRV', 'QuaNonConformance', rec_.nonconformance_code, 'PROG')) THEN
		Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'QuaNonConformance', rec_.nonconformance_code, 'PROG', rec_.nonconformance_description);          
	 END IF;       
  END LOOP;    
END;
/

PROMPT Finished with POST_Appsrv_InsertMissingBasicDataTranslations.sql
EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_InsertMissingBasicDataTranslations.sql','Done');
