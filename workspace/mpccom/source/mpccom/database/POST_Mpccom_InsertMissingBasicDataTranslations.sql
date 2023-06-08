--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Mpccom_InsertMissingBasicDataTranslations.sql
--
--  Module      : MPCCOM 14.0.0
--
--  Purpose     : Translations were missing for some basic data, in LUs that introduced basic data translation in APP8.
--                This is used to insert the missing basic data translations in 'PROG' language to such LUs.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  190918   WaSalk  Bug 148290 (SCZ-5013), Added PROMPT to insert missing basic data translations in 'PROG' language to DiscreteCharacValue.
--  140813   TiRalk  Bug 118250, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_InsertMissingBasicDataTranslations.sql','Timestamp_1');
PROMPT Starting POST_Mpccom_InsertMissingBasicDataTranslations


exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_InsertMissingBasicDataTranslations.sql','Timestamp_2');
PROMPT Inserting the missing basic data translations for LU CustOrdPrintControl
DECLARE
   CURSOR get_records IS
      SELECT print_control_code, description
      FROM   cust_ord_print_control_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('MPCCOM', 'CustOrdPrintControl', rec_.print_control_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('MPCCOM', 'CustOrdPrintControl', rec_.print_control_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_InsertMissingBasicDataTranslations.sql','Timestamp_3');
PROMPT Inserting the missing basic data translations for LU DiscreteCharacValue
DECLARE   
   CURSOR get_records IS
      SELECT characteristic_value, characteristic_value_desc 
      FROM   discrete_charac_value;       
BEGIN
   FOR rec_ IN get_records LOOP      
      IF NOT(Basic_Data_Translation_API.Exist_Translation('MPCCOM', 'DiscreteCharacValue', rec_.characteristic_value, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('MPCCOM', 'DiscreteCharacValue', rec_.characteristic_value, 'PROG', rec_.characteristic_value_desc);          
      END IF;       
   END LOOP;
END;
/
PROMPT Finished with POST_Mpccom_InsertMissingBasicDataTranslations.sql
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_InsertMissingBasicDataTranslations.sql','Done');
