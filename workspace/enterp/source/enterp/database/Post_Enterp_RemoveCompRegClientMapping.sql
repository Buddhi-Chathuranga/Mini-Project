-------------------------------------------------------------------------------
--
--  Filename      : Post_Enterp_RemoveCompRegClientMapping.sql
--
--  Module        : ENTERP
--
--  Purpose       : To remove invalid company registration and client mapping entries which used in
--  company creation process
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  140522  Dipelk  Created
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCompRegClientMapping.sql','Timestamp_1');
PROMPT Post_Enterp_RemoveCompRegClientMapping.SQL

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCompRegClientMapping.sql','Timestamp_2');
PROMPT Removing client mapping and company registration details of Footer_Field_API

DECLARE
   module_     VARCHAR2(20) := 'ACCRUL';
   lu_         VARCHAR2(20) := 'FooterField';
   mapping_id_ VARCHAR2(20) := 'CCD_FOOTERFIELD';
   dummy       NUMBER;
   CURSOR mapping_found_ IS
      SELECT 1
      FROM   client_mapping_tab t
      WHERE  t.module     = module_
      AND    t.lu         = lu_
      AND    t.mapping_id = mapping_id_ ;
BEGIN
   Enterp_Comp_Connect_V170_API.Reg_Remove_Component_Detail(module_, lu_);
   OPEN mapping_found_;
   FETCH mapping_found_ INTO dummy;
   IF (mapping_found_%FOUND) THEN
      Client_Mapping_API.Remove_Mapping(module_, lu_, mapping_id_);
   END IF;
   CLOSE mapping_found_;
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RemoveCompRegClientMapping.sql','Done');
SET SERVEROUTPUT OFF
