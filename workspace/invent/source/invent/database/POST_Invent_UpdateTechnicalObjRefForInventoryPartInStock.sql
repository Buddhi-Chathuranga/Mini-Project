----------------------------------------------------------------------------------------------------------
--  Module :   INVENT
--
--  File   :   POST_Invent_UpdateTechnicalObjRefForInventoryPartInStock.sql
--
--  Purpose:   Update the key_ref and key_value of TECHNICAL_OBJECT_REFERENCE_TAB for InventoryPartInStock LU.
--
----------------------------------------------------------------------------------------------------------
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------------------------------------
--  160808  SWiclk  Bug 129437, Created.
----------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_UpdateTechnicalObjRefForInventoryPartInStock.sql','Timestamp_1');
PROMPT UPDATE TECHNICAL_OBJECT_REFERENCE_TAB WITH NEW key_ref AND key_value FOR LU InventoryPartInStock.
DECLARE

   new_key_ref_ Technical_Object_Reference_Tab.Key_Ref%TYPE;
   key_value_   Technical_Object_Reference_Tab.Key_Value%TYPE;
   lu_name_     Technical_Object_Reference_Tab.Lu_Name%TYPE := 'InventoryPartInStock';
   dummy_       NUMBER;

   CURSOR get_tech_class_ref IS
      SELECT key_ref, ROWID
      FROM   technical_object_reference_tab
      WHERE  lu_name = lu_name_
      AND    (key_ref LIKE 'CONFIGURATION_ID%');

   CURSOR check_tech_obj_ref_exist(key_ref_ VARCHAR2)  IS
      SELECT 1
      FROM   technical_object_reference_tab
      WHERE  lu_name   = lu_name_
      AND    key_ref   = key_ref_;


   FUNCTION Repair_Key_Ref(invalid_key_ref_ VARCHAR2) RETURN VARCHAR2
      IS
         -- LU keys
         part_no_           VARCHAR2(25);
         contract_          VARCHAR2(5);
         configuration_id_  VARCHAR2(50);
         location_no_       VARCHAR2(35);
         lot_batch_no_      VARCHAR2(20);
         serial_no_         VARCHAR2(50);
         eng_chg_level_     VARCHAR2(6);
         wdr_no_            VARCHAR2(15);
         handling_unit_id_  NUMBER;

      BEGIN
         -- Read Key Values from the invalid_key_ref_
         part_no_          := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'PART_NO');
         contract_         := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'CONTRACT');
         configuration_id_ := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'CONFIGURATION_ID');
         location_no_      := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'LOCATION_NO');
         lot_batch_no_     := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'LOT_BATCH_NO');
         serial_no_        := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'SERIAL_NO');
         eng_chg_level_    := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'ENG_CHG_LEVEL');
         wdr_no_           := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'WAIV_DEV_REJ_NO');
         handling_unit_id_ := Client_SYS.Get_Key_Reference_Value(invalid_key_ref_, 'HANDLING_UNIT_ID');


         -- Build up the new KeyRef String
         RETURN Client_SYS.Get_Key_Reference(lu_name_, 'ACTIVITY_SEQ', 0,
                                                       'CONFIGURATION_ID', configuration_id_,
                                                       'CONTRACT', contract_,
                                                       'ENG_CHG_LEVEL', eng_chg_level_,
                                                       'HANDLING_UNIT_ID', handling_unit_id_,
                                                       'LOCATION_NO', location_no_,
                                                       'LOT_BATCH_NO', lot_batch_no_,
                                                       'PART_NO', part_no_,
                                                       'SERIAL_NO', serial_no_,
                                                       'WAIV_DEV_REJ_NO', wdr_no_);
   END Repair_Key_Ref;

BEGIN
   FOR rec_ IN get_tech_class_ref LOOP
      new_key_ref_ := Repair_Key_Ref(rec_.key_ref);
      key_value_   := Object_Connection_SYS.Convert_To_Key_Value(lu_name_, new_key_ref_);

      -- Check if there exists a record for the new key reference.
      OPEN  check_tech_obj_ref_exist(new_key_ref_);
      FETCH check_tech_obj_ref_exist INTO dummy_;

      IF (check_tech_obj_ref_exist%FOUND) THEN
         -- if a duplicate record exists delete the incorrect record
         DELETE FROM technical_object_reference_tab
         WHERE ROWID = rec_.ROWID;
      ELSE
         -- if no duplicate record exists we can directly update the incorrect record
         UPDATE technical_object_reference_tab
            SET key_ref    = new_key_ref_,
                key_value  = key_value_,
                rowversion = SYSDATE
          WHERE ROWID      = rec_.ROWID;
      END IF;
      CLOSE check_tech_obj_ref_exist;
   END LOOP;
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_UpdateTechnicalObjRefForInventoryPartInStock.sql','Done');
