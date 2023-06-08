
-----------------------------------------------------------------------------------------
--
--  File:     POST_EQUIP_ToolEquipmentUpgradeToGenres.sql
--
--  Date      Sign      History
--  ------   ------    ------------------------------------------------------------------
--  170109   SEROLK    STRSA-17213: Created, Tool Equipment data upgrade to resource.
--  170304   PRIKLK    STRSA-19790: added data upgrade to test point and parameter tables.
-----------------------------------------------------------------------------------------


SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_EQUIP_ToolEquipmentUpgradeToGenres.sql','Timestamp_1');
PROMPT Starting POST_EQUIP_ToolEquipmentUpgradeToGenres.sql


EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_EQUIP_ToolEquipmentUpgradeToGenres.sql','Timestamp_2');
PROMPT Upgrade data TO EQUIPMENT_OBJECT_MEAS_TAB

DECLARE
   stmt_ VARCHAR2(2000);
BEGIN
   IF (Database_SYS.Column_Exist('EQUIPMENT_OBJECT_MEAS_TAB','TOOL_EQUIPMENT_SEQ')) THEN
      stmt_ := 'DECLARE
                 CURSOR get_all_equipment IS
                  SELECT values_seq, tool_equipment_seq
                    FROM EQUIPMENT_OBJECT_MEAS_TAB 
                    WHERE tool_equipment_seq > 0;  
                 resource_seq_ NUMBER;

               BEGIN
                 -- Equipment Objects upgrade
                 FOR tool_rec_ IN get_all_equipment LOOP
                   resource_seq_ :=  Mscom_Upgrade_Util_API.Get_Resource_Seq_By_Tooleq_Seq(tool_rec_.tool_equipment_seq);
                     UPDATE EQUIPMENT_OBJECT_MEAS_TAB 
                     SET resource_seq = resource_seq_
                     WHERE values_seq = tool_rec_.values_seq;    
                 END LOOP;  
                 COMMIT;
               END;';
            EXECUTE IMMEDIATE stmt_;       
   END IF;
   IF (Database_SYS.Column_Exist('EQUIPMENT_OBJECT_TEST_PNT_TAB','TOOL_EQUIPMENT_SEQ')) THEN
      stmt_ := 'DECLARE
                 CURSOR get_all_equipment IS
                  SELECT test_pnt_seq, tool_equipment_seq
                    FROM EQUIPMENT_OBJECT_TEST_PNT_TAB 
                    WHERE tool_equipment_seq > 0;  
                 resource_seq_ NUMBER;

               BEGIN
                 -- Equipment Objects upgrade
                 FOR tool_rec_ IN get_all_equipment LOOP
                   resource_seq_ :=  Mscom_Upgrade_Util_API.Get_Resource_Seq_By_Tooleq_Seq(tool_rec_.tool_equipment_seq);
                     UPDATE EQUIPMENT_OBJECT_TEST_PNT_TAB 
                     SET resource_seq = resource_seq_
                     WHERE test_pnt_seq = tool_rec_.test_pnt_seq;    
                 END LOOP;  
                 COMMIT;
               END;';
            EXECUTE IMMEDIATE stmt_;       
   END IF;
   IF (Database_SYS.Column_Exist('EQUIPMENT_OBJECT_PARAM_TAB','TOOL_EQUIPMENT_SEQ')) THEN
      stmt_ := 'DECLARE
                 CURSOR get_all_equipment IS
                  SELECT test_pnt_seq, parameter_code, tool_equipment_seq
                    FROM EQUIPMENT_OBJECT_PARAM_TAB 
                    WHERE tool_equipment_seq > 0;  
                 resource_seq_ NUMBER;

               BEGIN
                 -- Equipment Objects upgrade
                 FOR tool_rec_ IN get_all_equipment LOOP
                   resource_seq_ :=  Mscom_Upgrade_Util_API.Get_Resource_Seq_By_Tooleq_Seq(tool_rec_.tool_equipment_seq);
                     UPDATE EQUIPMENT_OBJECT_PARAM_TAB 
                     SET resource_seq = resource_seq_
                     WHERE test_pnt_seq = tool_rec_.test_pnt_seq
                     AND parameter_code = tool_rec_.parameter_code;    
                 END LOOP;  
                 COMMIT;
               END;';
            EXECUTE IMMEDIATE stmt_;       
   END IF;
END;
/
PROMPT Finished POST_EQUIP_ToolEquipmentUpgradeToGenres.sql

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_EQUIP_ToolEquipmentUpgradeToGenres.sql','Done');

