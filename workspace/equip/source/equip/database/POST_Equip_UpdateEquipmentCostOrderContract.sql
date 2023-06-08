-------------------------------------------------------------------------------
--
--  Filename      : POST_Equip_UpdateEquipmentCostOrderContract.sql
--
--  Module        : EQUIP 7.0.0
--
--  Purpose       : Modifying ORDER_CONTRACT IN Equipment_Structure_Cost_TAB
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  121212  SHAFLK  Bug 107335, Created.
--  ----------------------------------APPS 9-------------------------------------
--  130826  bhkalk Scalability Changes - Removed global variables.
---------------------------------------------------------------------------------
--  170222  nifrse STRSA-18222, renamed order_no to source_ref1
--  181205  MAZPSE Bug 144442, Improved performance in the script.
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpdateEquipmentCostOrderContract.sql','Timestamp_1');
PROMPT Modifying ORDER_CONTRACT IN Equipment_Structure_Cost_TAB 

DECLARE
   TYPE equip_structure IS RECORD
   (seq_no NUMBER,
    contract VARCHAR2(5));

   TYPE equip_structure_t IS TABLE OF equip_structure
    INDEX BY BINARY_INTEGER;

   equip_struc_collection_ equip_structure_t;
   
   $IF Component_WO_SYS.INSTALLED $THEN
      CURSOR get_wo_rec IS
      SELECT a.seq_no, b.contract
           FROM equipment_structure_cost_tab a, work_order_table b
          WHERE a.source_ref1 = b.wo_no
            AND a.cost_source = 'WO'
            AND a.order_contract IS NULL;
   $END

   $IF Component_ORDER_SYS.INSTALLED $THEN
      CURSOR get_order_rec IS
         SELECT a.seq_no, b.contract
           FROM equipment_structure_cost_tab a, customer_order_tab b
          WHERE a.source_ref1 = b.order_no
            AND a.cost_source = 'CO'
            AND a.order_contract IS NULL;
   $END
BEGIN
   $IF Component_WO_SYS.INSTALLED $THEN
      OPEN get_wo_rec;
      LOOP
         FETCH get_wo_rec BULK COLLECT INTO equip_struc_collection_ LIMIT 100;
         EXIT WHEN equip_struc_collection_.COUNT = 0;

         FORALL i IN equip_struc_collection_.FIRST..equip_struc_collection_.LAST
            UPDATE equipment_structure_cost_tab
               SET order_contract = equip_struc_collection_(i).contract
             WHERE seq_no    = equip_struc_collection_(i).seq_no;
         COMMIT;
      END LOOP;
      CLOSE get_wo_rec;
   $ELSE
      NULL;
   $END

   $IF Component_ORDER_SYS.INSTALLED $THEN
      OPEN get_order_rec;
      LOOP
         FETCH get_order_rec BULK COLLECT INTO equip_struc_collection_ LIMIT 100;
         EXIT WHEN equip_struc_collection_.COUNT = 0;

         FORALL i IN equip_struc_collection_.FIRST..equip_struc_collection_.LAST
            UPDATE equipment_structure_cost_tab
               SET order_contract = equip_struc_collection_(i).contract
             WHERE seq_no    = equip_struc_collection_(i).seq_no;
         COMMIT;
      END LOOP;
      CLOSE get_order_rec;
   $ELSE
      NULL;
   $END
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpdateEquipmentCostOrderContract.sql','Done');


