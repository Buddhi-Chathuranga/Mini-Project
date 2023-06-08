-----------------------------------------------------------------------------
--  Module : INVENT
--
--  File   : Post_INVENT_G2C_Data_Transfer.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  ------------------------------------------------------------
--  220201   NiRalk  SC21R2-7479 , Modified the query to select values from record which has max tax_part_id.
--  220127   NiRalk  SC21R2-7434 , Modified the fiscal_part_type as 1 in Data migrating from tax_part_tab table to inventory_part_tab table query.
--  211217   NiRalk  SC21R2-5531 , Data transfer POST SQL file created.
---------------------------------------------------------------------------------
SET SERVEROUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_INVENT_G2C_Data_Transfer.sql','Timestamp_1');
PROMPT Starting Post_INVENT_G2C_Data_Transfer.sql

-- gelr:brazilian_specific_attributes, begin
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_INVENT_G2C_Data_Transfer.sql','Timestamp_2');
PROMPT Data migrating FROM TABLE tax_part_tab TO TABLE inventory_part_tab.
DECLARE                       
   stmt_     VARCHAR2(2000); 
BEGIN
   stmt_     := 'UPDATE inventory_part_tab i
                     SET (acquisition_reason_id, 
                          acquisition_origin, 
                          statistical_code) =
                         (SELECT t.destination, 
                                 t.acquisition_origin, 
                                 t.nbm_id
                              FROM tax_part_tab t
                                 WHERE t.fiscal_part_type = ''1''
                                  AND (t.destination          IS NOT NULL OR 
                                       t.acquisition_origin   IS NOT NULL OR
                                       t.nbm_id               IS NOT NULL)
                                  AND  i.contract              = t.contract
                                  AND  i.part_no               = t.part_no
                                  ORDER BY t.tax_part_id DESC
                                  FETCH FIRST 1 ROW ONLY)
                     WHERE EXISTS (
                           SELECT t.destination, 
                                  t.acquisition_origin, 
                                  t.nbm_id
                              FROM tax_part_tab t
                                 WHERE t.fiscal_part_type = ''1''   AND
                                      (t.destination        IS NOT NULL OR 
                                       t.acquisition_origin IS NOT NULL OR
                                       t.nbm_id             IS NOT NULL)
                                   AND i.contract           = t.contract
                                   AND i.part_no            = t.part_no
                                   ORDER BY t.tax_part_id DESC
                                   FETCH FIRST 1 ROW ONLY)';
   
   -- Check only for the table exixt condition since destination,acquisition_origin,nbm_id,fiscal_part_type,contract and part_no introduced when the initial table creation.                                                  
   IF Database_SYS.Table_Exist('TAX_PART_TAB') AND Database_SYS.Table_Exist('INVENTORY_PART_TAB') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;  
   END IF;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_INVENT_G2C_Data_Transfer.sql','Timestamp_3');
PROMPT Data migrating FROM TABLE DESTINATION_TAB TO TABLE ACQUISITION_REASON_TAB.
DECLARE                       
   stmt_    VARCHAR2(2000); 
BEGIN
   stmt_    := 'INSERT INTO ACQUISITION_REASON_TAB  
                     (company,
                      acquisition_reason_id,
                      description,
                      external_use_type,
                      rowversion)
                      SELECT c.company,
                      d.destination_id,
                      d.description,
                      ''notApplicable'',
                      SYSDATE
               FROM company_tab c
                  CROSS JOIN DESTINATION_TAB d
                  WHERE c.localization_country = ''BR''
                     AND NOT EXISTS ( 
                        SELECT 1
                           FROM ACQUISITION_REASON_TAB a
                           WHERE c.company        = a.company AND 
                                 d.destination_id = a.acquisition_reason_id )';
                                                     
   IF Database_SYS.Table_Exist('DESTINATION_TAB') AND Database_SYS.Table_Exist('ACQUISITION_REASON_TAB') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;  
   END IF;
END;
/
-- gelr:brazilian_specific_attributes, end

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_INVENT_G2C_Data_Transfer.sql','Done');
PROMPT Finished with Post_INVENT_G2C_Data_Transfer.SQL
