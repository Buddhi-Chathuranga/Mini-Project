-----------------------------------------------------------------------------
--  Module : EQUIP
--
--  File   : POST_Equip_UpgradeObjectConnections.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose: Update object connections information for Equip LUs.
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200114   KrRaLK  Bug 151593, Modified the object reference records to inline with the 
--                    key in EQUIPMENT_OBJECT_TEST_PNT_TAB(TEST_PNT_SEQ).   
--  191216   KrRaLK  Bug 151436, Update object connections information for EQUIPMENT_OBJECT_TEST_PNT_TAB. 
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeObjectConnections.sql','Timestamp_1');
PROMPT Starting POST_Equip_UpgradeObjectConnections.sql


DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_test_points IS
					  SELECT *
					  FROM equipment_object_test_pnt_tab ;
				   
				   old_lu_name_                   VARCHAR2(30);
				   old_key_ref_                   VARCHAR2(500);
				   new_lu_name_                   VARCHAR2(30);
				   new_key_ref_                   VARCHAR2(500);
					 
				BEGIN
               --  Updating Object connections attached to equipment_object_test_pnt_tab   
                 FOR rec_ IN get_test_points LOOP     
                    old_lu_name_ := ''EquipmentObjectTestPnt'';
                    old_key_ref_ := ''CONTRACT=''||rec_.contract||''^''||''MCH_CODE=''||rec_.mch_code||''^''||''TEST_POINT_ID=''||rec_.test_point_id||''^'';
                    new_lu_name_ := ''EquipmentObjectTestPnt'';
                    new_key_ref_ := ''TEST_PNT_SEQ=''||rec_.test_pnt_seq||''^'';
                    Wo_Upgrade200_Util_API.Copy_Object_Connections(old_lu_name_, old_key_ref_, new_lu_name_, new_key_ref_);
                    
                    old_lu_name_ := NULL;
                    old_key_ref_ := NULL;
                    new_lu_name_ := NULL;
                    new_key_ref_ := NULL;
                    old_lu_name_ := ''EquipmentObjectTestPnt'';
                    old_key_ref_ := ''TEST_PNT_SEQ=''||rec_.test_pnt_seq||''^''||''TEST_POINT_ID=''||rec_.test_point_id||''^'';
                    new_lu_name_ := ''EquipmentObjectTestPnt'';
                    new_key_ref_ := ''TEST_PNT_SEQ=''||rec_.test_pnt_seq||''^'';
                    Wo_Upgrade200_Util_API.Copy_Object_Connections(old_lu_name_, old_key_ref_, new_lu_name_, new_key_ref_);                    
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('WO_UPGRADE200_UTIL_API') AND Database_SYS.Column_Exist('EQUIPMENT_OBJECT_TEST_PNT_TAB','TEST_PNT_SEQ')) THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeObjectConnections.sql','Done');
PROMPT Finished POST_Equip_UpgradeObjectConnections.sql



