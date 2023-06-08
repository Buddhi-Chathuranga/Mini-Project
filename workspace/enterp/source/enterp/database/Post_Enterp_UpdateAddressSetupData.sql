---------------------------------------------------------------------------------
--
--  Module:       ENTERP
--
--  File:         Post_Enterp_UpdateAddressSetupData.sql
--  -----------------------------------------------------------------------------
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  160505  ChguLK  STRLOC-369,Updating Address set up data from attribute_definition_tab
---------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateAddressSetupData.sql','Timestamp_1');
PROMPT Post_Enterp_UpdateAddressSetupData.SQL

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateAddressSetupData.sql','Timestamp_2');
PROMPT Updating columns in address_setup_tab

BEGIN
   UPDATE address_setup_tab t
   SET t.user_defined_line_length = CASE
                                       WHEN t.logical_unit = 'SupplierInfoAddress'  THEN
                                          (NVL((SELECT length FROM attribute_definition_tab ad
                                                WHERE  ad.base_lu        = 'SupplierInfoAddress'
                                                AND    ad.attribute_name = 'ADDRESS'
                                                AND    ad.parameter_name = '*' ),t.user_defined_line_length))
                                       WHEN t.logical_unit = 'CustomerInfoAddress'  THEN
                                          (NVL((SELECT length FROM attribute_definition_tab ad
                                                WHERE  ad.base_lu        = 'CustomerInfoAddress'
                                                AND    ad.attribute_name = 'ADDRESS'
                                                AND    ad.parameter_name = '*' ),t.user_defined_line_length))
                                    END,
       t.mandatory_address_line   = CASE
                                       WHEN t.logical_unit = 'SupplierInfoAddress'  THEN
                                          (NVL((SELECT 'ADDRESS1' FROM object_property_tab op
                                                WHERE  op.object_lu      = 'PartyType'
                                                AND    op.object_key     = 'SUPPLIER'
                                                AND    op.property_name  = 'ADDR_MAND'
                                                AND    op.property_value = 'TRUE'),t.mandatory_address_line))
                                       WHEN t.logical_unit = 'CustomerInfoAddress'  THEN
                                          (NVL((SELECT 'ADDRESS1' FROM object_property_tab op
                                                WHERE  op.object_lu      = 'PartyType'
                                                AND    op.object_key     = 'CUSTOMER'
                                                AND    op.property_name  = 'ADDR_MAND'
                                                AND    op.property_value = 'TRUE' ),t.mandatory_address_line))
                                    END
		WHERE t.logical_unit IN ('SupplierInfoAddress','CustomerInfoAddress');
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateAddressSetupData.sql','Timestamp_3');
PROMPT Removing unnecessary data from attribute_definition_tab

BEGIN
   DELETE
   FROM  attribute_definition_tab ad
   WHERE ad.base_lu IN ('SupplierInfoAddress','CustomerInfoAddress')
   AND   ad.attribute_name = 'ADDRESS'
   AND   ad.parameter_name = '*';
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateAddressSetupData.sql','Timestamp_4');
PROMPT Removing unnecessary data from object_property_tab

   BEGIN
   DELETE
   FROM  object_property_tab op
   WHERE op.object_lu     =  'PartyType'
   AND   op.property_name = 'ADDR_MAND'
   AND   op.object_key IN ('CUSTOMER','SUPPLIER');
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateAddressSetupData.sql','Done');
