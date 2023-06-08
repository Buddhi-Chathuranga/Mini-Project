--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Invent_InsertMissingBasicDataTranslations.sql
--
--  Module      : INVENT 14.1.0
--
--  Purpose     : Translations were missing for some basic data, in LUs that introduced basic data translation in APP8.
--                This is used to insert the missing basic data translations in 'PROG' language to such LUs.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  140813   ChBnlk  Bug 118250, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_1');
PROMPT Starting POST_Invent_InsertMissingBasicDataTranslations


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_2');
PROMPT Inserting the missing basic data translations for LU SafetyInstruction
DECLARE
   CURSOR get_records IS
      SELECT hazard_code, description
      FROM   safety_instruction_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'SafetyInstruction', rec_.hazard_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'SafetyInstruction', rec_.hazard_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_3');
PROMPT Inserting the missing basic data translations for LU AccountingGroup
DECLARE
   CURSOR get_records IS
      SELECT accounting_group, description
      FROM   accounting_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'AccountingGroup', rec_.accounting_group, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'AccountingGroup', rec_.accounting_group, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_4');
PROMPT Inserting the missing basic data translations for LU InventoryPartStatusPar
DECLARE
   CURSOR get_records IS
      SELECT part_status, description
      FROM   inventory_part_status_par_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InventoryPartStatusPar', rec_.part_status, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InventoryPartStatusPar', rec_.part_status, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_5');
PROMPT Inserting the missing basic data translations for LU CommodityGroup
DECLARE
   CURSOR get_records IS
      SELECT commodity_code, description
      FROM   commodity_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'CommodityGroup', rec_.commodity_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'CommodityGroup', rec_.commodity_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_6');
PROMPT Inserting the missing basic data translations for LU AssetClass
DECLARE
   CURSOR get_records IS
      SELECT asset_class, description
      FROM   asset_class_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'AssetClass', rec_.asset_class, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'AssetClass', rec_.asset_class, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_7');
PROMPT Inserting the missing basic data translations for LU SupplyChainPartGroup
DECLARE
   CURSOR get_records IS
      SELECT supply_chain_part_group, description
      FROM   supply_chain_part_group_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'SupplyChainPartGroup', rec_.supply_chain_part_group, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'SupplyChainPartGroup', rec_.supply_chain_part_group, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_8');
PROMPT Inserting the missing basic data translations for LU PartAvailabilityControl
DECLARE
   CURSOR get_records IS
      SELECT availability_control_id, description
      FROM   part_availability_control_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'PartAvailabilityControl', rec_.availability_control_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'PartAvailabilityControl', rec_.availability_control_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_9');
PROMPT Inserting the missing basic data translations for LU InventValueComparatType
DECLARE
   CURSOR get_records IS
      SELECT company, comparator_type_id, description
      FROM   invent_value_comparat_type_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InventValueComparatType', rec_.company || '^' || rec_.comparator_type_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InventValueComparatType', rec_.company || '^' || rec_.comparator_type_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_10');
PROMPT Inserting the missing basic data translations for LU InventoryProductFamily
DECLARE
   CURSOR get_records IS
      SELECT part_product_family, description
      FROM   inventory_product_family_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InventoryProductFamily', rec_.part_product_family, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InventoryProductFamily', rec_.part_product_family, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_11');
PROMPT Inserting the missing basic data translations for LU InventoryProductCode
DECLARE
   CURSOR get_records IS
      SELECT part_product_code, description
      FROM   inventory_product_code_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InventoryProductCode', rec_.part_product_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InventoryProductCode', rec_.part_product_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_12');
PROMPT Inserting the missing basic data translations for LU InternalDestination
DECLARE
   CURSOR get_records IS
      SELECT contract, destination_id, description
      FROM   internal_destination_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InternalDestination', rec_.contract || '^' || rec_.destination_id, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InternalDestination', rec_.contract || '^' || rec_.destination_id, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Timestamp_13');
PROMPT Inserting the missing basic data translations for LU InspectionRule
DECLARE
   CURSOR get_records IS
      SELECT inspection_code, description
      FROM   inspection_rule_tab;
BEGIN
   FOR rec_ IN get_records LOOP
      IF NOT(Basic_Data_Translation_API.Exist_Translation('INVENT', 'InspectionRule', rec_.inspection_code, 'PROG')) THEN
         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT', 'InspectionRule', rec_.inspection_code, 'PROG', rec_.description);
      END IF;
   END LOOP;
END;
/

PROMPT Finished with POST_Invent_InsertMissingBasicDataTranslations.sql
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertMissingBasicDataTranslations.sql','Done');

