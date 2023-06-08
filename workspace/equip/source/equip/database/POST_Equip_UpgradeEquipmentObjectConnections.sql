-----------------------------------------------------------------------------
--  Module : EQUIP
--
--  File   : POST_Equip_UpgradeEquipmentObjectConnections.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose: Update object connections information for Equip LUs.
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211016   KrRaLK  AM21R2-2950, Modified the object reference records to inline with the 
--                    key in EQUIPMENT_OBJECT_TAB.   
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_1');
PROMPT Starting Updating Object connections attached to equipment_object_tab

DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_equ_objects IS
					  SELECT *
					  FROM equipment_object_tab;
				   
				   lu_name_                    VARCHAR2(30);
				   old_key_ref_                VARCHAR2(500);
				   new_key_ref_                VARCHAR2(500);
   				old_key_value_              VARCHAR2(500);
				   new_key_value_              VARCHAR2(500);
					 
				BEGIN  
                 FOR rec_ IN get_equ_objects LOOP     
                    old_key_ref_   := ''CONTRACT=''||rec_.contract||''^''||''MCH_CODE=''||rec_.mch_code||''^'';
                    new_key_ref_   := ''EQUIPMENT_OBJECT_SEQ=''||rec_.equipment_object_seq||''^'';
                    old_key_value_ := rec_.contract||''^''||rec_.mch_code||''^'';
                    new_key_value_ := rec_.equipment_object_seq||''^'';
                    
                    lu_name_ := ''EquipmentObject'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_, old_key_value_, new_key_value_);
                    
                    lu_name_ := ''EquipmentFunctional'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_, old_key_value_, new_key_value_); 

                    lu_name_ := ''EquipmentSerial'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_, old_key_value_, new_key_value_); 
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('EQUIPMENT_OBJECT_UTIL_API') AND Database_SYS.Get_Constraint_Columns('EQUIPMENT_OBJECT_TAB','EQUIPMENT_OBJECT_PK') = 'EQUIPMENT_OBJECT_SEQ') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/



EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_2');
PROMPT Starting Updating Object connections attached to Equipment_Object_Journal_TAB

DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_equ_journal IS
					  SELECT *
					  FROM Equipment_Object_Journal_TAB;
				   
				   lu_name_                    VARCHAR2(30);
				   old_key_ref_                VARCHAR2(500);
				   new_key_ref_                VARCHAR2(500);
					 
				BEGIN  
                 FOR rec_ IN get_equ_journal LOOP     
                    lu_name_ := ''EquipmentObjectJournal'';
                    old_key_ref_ := ''CONTRACT=''||rec_.contract||''^''||''MCH_CODE=''||rec_.mch_code||''^''||''LINE_NO=''||rec_.line_no||''^'';
                    new_key_ref_ := ''EQUIPMENT_OBJECT_SEQ=''||rec_.equipment_object_seq||''^''||''LINE_NO=''||rec_.line_no||''^'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_);                 
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('EQUIPMENT_OBJECT_UTIL_API') AND Database_SYS.Get_Constraint_Columns('EQUIPMENT_OBJECT_JOURNAL_TAB','EQUIPMENT_OBJECT_JOURNAL_PK') = 'EQUIPMENT_OBJECT_SEQ, LINE_NO') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_3');
PROMPT Starting Updating Object connections attached to OBJECT_SUPPLIER_WARRANTY_TAB

DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_equ_sup_warranty IS
					  SELECT *
					  FROM object_supplier_warranty_tab;
				   
				   lu_name_                    VARCHAR2(30);
				   old_key_ref_                VARCHAR2(500);
				   new_key_ref_                VARCHAR2(500);
					 
				BEGIN  
                 FOR rec_ IN get_equ_sup_warranty LOOP     
                    lu_name_ := ''ObjectSupplierWarranty'';
                    old_key_ref_ := ''MCH_CODE=''||rec_.mch_code||''^''||''CONTRACT=''||rec_.contract||''^''||''ROW_NO=''||rec_.row_no||''^'';
                    new_key_ref_ := ''EQUIPMENT_OBJECT_SEQ=''||rec_.equipment_object_seq||''^''||''ROW_NO=''||rec_.row_no||''^'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_);                 
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('EQUIPMENT_OBJECT_UTIL_API') AND Database_SYS.Get_Constraint_Columns('OBJECT_SUPPLIER_WARRANTY_TAB','OBJECT_SUPPLIER_WARRANTY_PK') = 'EQUIPMENT_OBJECT_SEQ, ROW_NO') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_4');
PROMPT Starting Updating Object connections attached to EQUIPMENT_OBJECT_PARTY_TAB

DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_equ_party IS
					  SELECT *
					  FROM equipment_object_party_tab;
				   
				   lu_name_                    VARCHAR2(30);
				   old_key_ref_                VARCHAR2(500);
				   new_key_ref_                VARCHAR2(500);
					 
				BEGIN  
                 FOR rec_ IN get_equ_party LOOP     
                    lu_name_ := ''EquipmentObjectParty'';
                    old_key_ref_ := ''MCH_CODE=''||rec_.mch_code||''^''||''CONTRACT=''||rec_.contract||''^''||''PARTY_TYPE=''||rec_.party_type||''^''||''IDENTITY=''||rec_.identity||''^'';
                    new_key_ref_ := ''EQUIPMENT_OBJECT_SEQ=''||rec_.equipment_object_seq||''^''||''PARTY_TYPE=''||rec_.party_type||''^''||''IDENTITY=''||rec_.identity||''^'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_);                 
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('EQUIPMENT_OBJECT_UTIL_API') AND Database_SYS.Get_Constraint_Columns('EQUIPMENT_OBJECT_PARTY_TAB','EQUIPMENT_OBJECT_PARTY_PK') = 'EQUIPMENT_OBJECT_SEQ, PARTY_TYPE, IDENTITY') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_6');
PROMPT Starting Updating Object connections attached to OBJECT_CUST_WARRANTY_TAB

DECLARE
   stmt_			VARCHAR2(32000);
BEGIN
   stmt_	:=	'DECLARE
				   CURSOR get_equ_cust_warranty IS
					  SELECT *
					  FROM object_cust_warranty_tab;
				   
				   lu_name_                    VARCHAR2(30);
				   old_key_ref_                VARCHAR2(500);
				   new_key_ref_                VARCHAR2(500);
					 
				BEGIN  
                 FOR rec_ IN get_equ_cust_warranty LOOP     
                    lu_name_ := ''ObjectCustWarranty'';
                    old_key_ref_ := ''MCH_CODE=''||rec_.mch_code||''^''||''CONTRACT=''||rec_.contract||''^''||''ROW_NO=''||rec_.row_no||''^'';
                    new_key_ref_ := ''EQUIPMENT_OBJECT_SEQ=''||rec_.equipment_object_seq||''^''||''ROW_NO=''||rec_.row_no||''^'';
                    Equipment_Object_Util_API.Copy_Object_Connections(lu_name_, old_key_ref_, new_key_ref_);                 
                 END LOOP;     
            END;';
   
   IF  (Database_SYS.Package_Active('EQUIPMENT_OBJECT_UTIL_API') AND Database_SYS.Get_Constraint_Columns('OBJECT_CUST_WARRANTY_TAB','OBJECT_CUST_WARRANTY_PK') = 'EQUIPMENT_OBJECT_SEQ, ROW_NO') THEN
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/


EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeEquipmentObjectConnections.sql','Timestamp_5');



PROMPT Finished POST_Equip_UpgradeObjectConnections.sql

EXEC Database_SYS.Log_Detail_Time_Stamp('EQUIP','POST_Equip_UpgradeObjectConnections.sql','Done');

