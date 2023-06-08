-----------------------------------------------------------------------------------
--
--  File: POST_Equip_SpareStructureTree.sql
--
--  Date: 2016-11-17
--
--  Date    Sign     History
--  ------  ----     --------------------------------------------------------------
--  161117  RUMELK   APPUXX-6039, Created. EQUIPMENT_SPARE_STRUCTURE_TREE view is used in UXX to show order spare parts list.
--  170518  RUMELK   STRSA-24779, Checked PURCH and INVENT is installed.
 
-----------------------------------------------------------------------------------

SET SERVEROUTPUT ON 

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_SpareStructureTree.sql','Timestamp_1');
PROMPT Creating EQUIPMENT_SPARE_STRUCTURE_TREE view

DECLARE
   stmt_    VARCHAR2(32000);
BEGIN
   IF Transaction_SYS.Package_Is_Active('Purchase_Part_API') THEN
      stmt_ := 'CREATE OR REPLACE VIEW EQUIPMENT_SPARE_STRUCTURE_TREE AS
SELECT DISTINCT
       spare_seq                      spare_seq,
       spare_contract                 spare_contract,
       spare_id                       spare_id,
       component_spare_id             component_spare_id,
       component_spare_contract       component_spare_contract,
       Translate_Boolean_API.Decode(Equipment_Spare_Structure_API.Has_Spare_Structure(component_spare_id, spare_contract)) has_structure,
       qty                            qty,
       drawing_no                     drawing_no,
       drawing_pos                    drawing_pos,
       mch_part                       mch_part,
       note                           note,
       Part_Ownership_API.Decode(part_ownership) part_ownership,
       part_ownership                 part_ownership_db,
       condition_code                 condition_code,
       owner                          owner,
       allow_detached_wo_mat_site     allow_detached_wo_mat_site,
       rowkey                         objkey,
       to_char(rowversion)            objversion,
       rowid                          objid
FROM   equipment_spare_structure_tab
WHERE  EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE equipment_spare_structure_tab.spare_contract = site)
AND    EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE equipment_spare_structure_tab.component_spare_contract = site)
connect by  spare_id = prior component_spare_id

UNION

SELECT  
       null                      spare_seq,
       spare_contract                 spare_contract,
       NVL2(spare_id, ''-'', null)                       spare_id,
       spare_id             component_spare_id,
       spare_contract       component_spare_contract,
       Translate_Boolean_API.Decode(Equipment_Spare_Structure_API.Has_Spare_Structure(spare_id, spare_contract)) has_structure,
       null                            qty,
       null                     drawing_no,
       null                    drawing_pos,
       null                       mch_part,
       null                           note,
       null                            part_ownership,
       null                            part_ownership_db,
       null                            condition_code,
       null                          owner,
       null                           allow_detached_wo_mat_site,
       null                         objkey,
       null                         objversion,
       null                          objid
from EQUIP_INV_PUR_PART
where NOT EXISTS (SELECT 1 FROM equipment_spare_structure_tab est WHERE est.component_spare_id =  spare_id AND est.component_spare_contract = spare_contract)
WITH   READ ONLY';
       
      EXECUTE IMMEDIATE stmt_;
      
	  stmt_ := 'COMMENT ON TABLE EQUIPMENT_SPARE_STRUCTURE_TREE
   IS ''LU=EquipmentSpareStructure^PROMPT=Equipment Spare Structure Tree^MODULE=EQUIP^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.spare_seq
   IS ''FLAGS=K----^DATATYPE=NUMBER^PROMPT=Spare Seq^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.spare_contract
   IS ''FLAGS=KMI--^DATATYPE=STRING(5)/UPPERCASE^PROMPT=Spare Contract^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.spare_id
   IS ''FLAGS=KMI-L^DATATYPE=STRING(25)/UPPERCASE^PROMPT=Spare ID^REF=PurchasePart(spare_contract)/NOCHECK^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.component_spare_id
   IS ''FLAGS=KMIUL^DATATYPE=STRING(25)/UPPERCASE^PROMPT=Component Spare ID^REF=PurchasePart(spare_contract)/NOCHECK^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.component_spare_contract
   IS ''FLAGS=KMIU-^DATATYPE=STRING(5)/UPPERCASE^PROMPT=Component Spare Contract^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.has_structure
   IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Has Structure^COLUMN=Translate_Boolean_API.Decode(Equipment_Spare_Structure_API.Has_Spare_Structure(component_spare_id, spare_contract))^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.qty
   IS ''FLAGS=AMIU-^DATATYPE=NUMBER^PROMPT=Quantity^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.drawing_no
   IS ''FLAGS=A-IU-^DATATYPE=STRING(16)/UPPERCASE^PROMPT=Drawing No^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.drawing_pos
   IS ''FLAGS=A-IU-^DATATYPE=STRING(6)/UPPERCASE^PROMPT=Drawing Position^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.mch_part
   IS ''FLAGS=A-IU-^DATATYPE=STRING(4)/UPPERCASE^PROMPT=Object Part^''';
      EXECUTE IMMEDIATE stmt_;
	  
	  stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.note
   IS ''FLAGS=A-IU-^DATATYPE=STRING(2000)^PROMPT=Note^''';
     EXECUTE IMMEDIATE stmt_;
    
     stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.part_ownership
   IS ''FLAGS=AMIUL^DATATYPE=STRING(200)^ENUMERATION=PartOwnership^PROMPT=Part Ownership^''';
     EXECUTE IMMEDIATE stmt_;
     stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.part_ownership_db
   IS ''FLAGS=A----^DATATYPE=STRING(20)^PROMPT=Part Ownership^''';
     EXECUTE IMMEDIATE stmt_;
     stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.condition_code
   IS ''FLAGS=A-IU-^DATATYPE=STRING(10)^PROMPT=Condition Code^''';
     EXECUTE IMMEDIATE stmt_;
     stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.owner
   IS ''FLAGS=A-IU-^DATATYPE=STRING(20)/UPPERCASE^PROMPT=Owner^REF=CustOrdCustomer/NOCHECK^''';
     EXECUTE IMMEDIATE stmt_;
     stmt_ := 'COMMENT ON COLUMN EQUIPMENT_SPARE_STRUCTURE_TREE.allow_detached_wo_mat_site
   IS ''FLAGS=A-IU-^DATATYPE=STRING(1)^PROMPT=Allow Detached Wo Mat Site^''';
     EXECUTE IMMEDIATE stmt_;
     
   END IF;
END;
/ 

COMMIT;
/
EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_SpareStructureTree.sql','Done');
