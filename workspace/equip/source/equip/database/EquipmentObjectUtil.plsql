-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectUtil
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961001  ADBR    Created from Rose model using Developer's Workbench.
--  961006  TOWI    Created from Rose model using Developer's Workbench 1.2.2.
--  961211  ADBR    Ref 38: Changed Check_Type_Status to call
--                  EQUIPMENT_OBJECT_ATTR_API.Has_Technical_Data.
--  970402  TOWI    Adjusted to new templates in Foundation 1.2.2c.
--  970604  ERJA    Procedure Check_Type_Status calls Is_Address to handle error
--                  messages concerning frmFunctionalObjectInformation.
--  970930  ERJA    Changed call to equipment_object_API.Modify_ in procedure Complete_Move
--                  to equipment_all_object_API.Modify__.
--  971120  ERJA    Added Contract.
--  980204  CAJO    Changed name on duplicate error message names.
--  980225  ERJA    Added parameters on complete_move
--  980423  MNYS    Support Id: 3962. Added parameters sup_mch_code and sup_contract
--                  in call to Part_Serial_Catalog_API.Move_In_Facility.
--  990112  MIBO    SKY.0208 and SKY.0209 Performance issues in Maintenance 5.4.0.
--  991227  ANCE    Changed template due to performance improvement.
--  000502  JIJO    New Check_Warranties
--  000523  RECASE  Deleted procedure Create_Attr_Template and Remove_Attr_Template__. Deleted calls to these 
--                  from Check_Type_Status and exchanged the call for EQUIPMENT_OBJECT_ATTR_API.Has_Technical_Data
--                  for Equipment_Object_API.Has_Technical_Spec_No.
--  000607  ADBR    Call 39357: Commented update of contract and sup_contract in Complete_Move.
--  001103  GOPE    IID 6423 Warranty Handling required that the CheckWarranty must be 
--                  rewriten.
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604 CHAMLK Modified the length of the key_ref in procedure Check_Type_Status to accomodate the new length of the mch_code.
--  020618 CHCRLK Modified procedure Complete_Move to reflect changes made to Serial States. 
--  041108 GIRALK Bug 47722, Modified Procedure Complete_Move to pass NULL values to PART_SERIAL_CATALOG_API.Modify_Serial_Structure
--  041116 Chanlk Merged Bug 47788.
--  050406 NEKOLK Merged - Bug 50157, Added the method Remove_Structure_Party.
--  050404 LOPRLK Bug 50353, Method Complete_Move was altered.
--  050516 DiAmlk Merged the corrections done in LCS Bug ID:50353.
--  060221 NAMELK Bug 56034, Changed Method Complete_Move.
--  060305 JAPALK Meged bug 56034.
--  060329 DiAmlk Added new methods Remove_Structure_Addr and Addr_To_Structure.
--  071113 LIAMLK Bug 67252, Added procedures Check_Scrap_Allowed, Handle_Scrap_Serial.
--  080623 SHAFLK Bug 74969, Modified Check_Scrap_Allowed.
--  081001 SHAFLK Bug 76904, Modified Complete_Move.
--  090327 nukulk Bug 81398, added ifs_assert_safe annotation.
--  -------------------------Project Eagle-----------------------------------
--  091019 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106 SaFalk IID - ME310: Removed bug comment tags.
--  091110 SHAFLK Bug 87011, Modified Complete_Move
--  100202 SHAFLK Bug 88411, Modified Check_Scrap_Allowed.
--  100429 SHAFLK Bug 90182, Modified Check_Scrap_Allowed.
--  120119 JAPELK Bug 100822 fixed in Remove_Structure_Party.
--  -------------------------Project Black Pearl-------------------------------
--  130508 MAWILK BLACK-66, Removed method calls to EQUIPMENT_ALL_OBJECT_API.
--  130613 MADGLK BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls
--  131122  Nekolk  PBSA-1833:Hooks: Refactored and split code.
--  140314  HASTSE  PBSA-5731, address fixes
--  140312  heralk  PBSA-3592 , Merged LCS Patch - 112727.
--  140605  SamGLK  PRSA-1162, Added methods Transf_Equip_To_CU_Template(),Transf_Equip_Obj_To_CU(),Transf_Equip_Obj_To_Des_Obj().
--  140812  HASTSE  Replaced dynamic code
-- ----------------------------App9--------------------------------------------
--  141003  SADELK  PRSA-4583, Added Get_WOs_By_Assets_Connected() for S&A Lobby
--  141007  NRATLK  PRSA-4635, Added new method Is_Late_Purchase_Order_Line() for Late Purchase Order Lobby element.
--  141009  SHAFLK  PRSA-4657, corrected in Get_WOs_By_Assets_Connected and Is_Late_Purchase_Order_Line.
--  141009  SADELK  PRSA-4663, Changed the method signature parameter order for Get_Wos_By_Assets_Connected() and Is_Late_Purchase_Order_Line()
--  141015  SADELK  PRSA-4700, Removed Get_WOs_By_Assets_Connected() and Added Is_Project_Connected_To_WO()
--  150303  NIFRSE  PRSA-7636, Changed the Database value in Is_Project_Connected_To_WO() method from 'Equipment' to 'EQUIPMENT'.
--  150304  NIFRSE  PRSA-7636, Just a small refactoring of the select statement in the Is_Project_Connected_To_WO() method.
--  150811  ILSOLK  RUBY-1516, Added Get_Customer_Del_Address() method.
--  150824  SHAFLK  RUBY-1650, Modified Get_Customer_Del_Address().
--  151215  KrRaLK  STRSA-1662, Modified to fetch information from Psc_Contr_Product_Scope_API instead of Psc_Contr_Product_Object_API.
--  160108  KANILK  STRSA-1710, Merged Bug 126187, Modified Copy_Serial__ method.
--  160208  BHKALK  STRSA-2196, Merged Bug 126831, Modified Copy_Functional_Object().
--  171126  HASTSE  STRSA-32829, Equipment inheritance implementation
--  ---------------------------App10-----------------------------------------
--  190206  TAJALK  Bug 146656 fixed in Complete_Move
--  190516  LoPrlk  Bug 148121, Added the package variable block_equip_ser_struct_scrap_ and method Set_Struct_Scrappable_Block. Altered the method Handle_Scrap_Serial.
--  210712  SHAFLK  AMZWOP-3914, Modified Check_Scrap_Allowed.
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work .
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
--  220124  NEKOLK  AM21R2-3844: Introduced new method Check_Move_Allowed and moved move serial validation in to Check_Move_Allowed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@ApproveGlobalVariable
block_equip_ser_struct_scrap_ BOOLEAN := TRUE;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- PRSA-1162, Start
FUNCTION Transf_Equip_To_CU_Template (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   equip_site_ EQUIPMENT_OBJECT_TAB.CONTRACT%TYPE;
   equip_obj_  EQUIPMENT_OBJECT_TAB.MCH_CODE%TYPE;
   equip_seq_  EQUIPMENT_OBJECT_TAB.EQUIPMENT_OBJECT_SEQ%TYPE;
   
   source_key_ref_   VARCHAR2(100);
BEGIN
   equip_seq_  := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'EQUIPMENT_OBJECT_SEQ');
   equip_site_ := Equipment_Object_API.Get_Contract(equip_seq_);
   equip_obj_  := Equipment_Object_API.Get_Mch_Code(equip_seq_);
   
   $IF Component_Cmpcfg_SYS.INSTALLED $THEN
        source_key_ref_ := Cmpcfg_Cmp_Unit_Template_Api.Get_CU_Template_to_Equip(equip_site_,equip_obj_);
   $ELSE
        source_key_ref_ := NULL;
   $END

   RETURN source_key_ref_;
END Transf_Equip_To_CU_Template;

@UncheckedAccess
FUNCTION Get_Customer_Del_Address (
   equipment_object_seq_   IN NUMBER,
   customer_no_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   party_type_         VARCHAR2(20);
   delivery_address_   VARCHAR2(50);
BEGIN
   IF (( equipment_object_seq_ IS NOT  NULL ) AND (customer_no_ IS NOT NULL) ) THEN
      party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
      delivery_address_ := Equipment_Object_Party_API.Get_Delivery_Address(equipment_object_seq_, customer_no_ , party_type_);
   END IF;
   IF (delivery_address_ IS NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN  
         delivery_address_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
      $ELSE
          NULL;
      $END

   END IF; 

   RETURN delivery_address_;
END Get_Customer_Del_Address;

@UncheckedAccess
FUNCTION Get_Customer_Del_Address (
   contract_     IN VARCHAR2,
   mch_code_     IN VARCHAR2,
   customer_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   party_type_         VARCHAR2(20);
   delivery_address_   VARCHAR2(50);
   equipment_object_seq_ equipment_object_tab.equipment_object_seq%TYPE;
BEGIN
   equipment_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   IF (( equipment_object_seq_ IS NOT  NULL ) AND (customer_no_ IS NOT NULL) ) THEN
      party_type_ := Object_Party_Type_API.Decode('CUSTOMER');
      delivery_address_ := Equipment_Object_Party_API.Get_Delivery_Address(equipment_object_seq_, customer_no_ , party_type_);
   END IF;
   IF (delivery_address_ IS NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN  
         delivery_address_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
      $ELSE
          NULL;
      $END

   END IF; 

   RETURN delivery_address_;
END Get_Customer_Del_Address;

FUNCTION Transf_Equip_Obj_To_CU (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   equip_site_ EQUIPMENT_OBJECT_TAB.CONTRACT%TYPE;
   equip_obj_  EQUIPMENT_OBJECT_TAB.MCH_CODE%TYPE;
   equip_seq_  EQUIPMENT_OBJECT_TAB.EQUIPMENT_OBJECT_SEQ%TYPE;
   source_key_ref_   VARCHAR2(100);
BEGIN
   equip_seq_ := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'EQUIPMENT_OBJECT_SEQ');
   equip_site_ := Equipment_Object_API.Get_Contract(equip_seq_);
   equip_obj_ := Equipment_Object_API.Get_Mch_Code(equip_seq_); 
   
   $IF Component_Cmpunt_SYS.INSTALLED $THEN
        source_key_ref_ := Cmpunt_Compatible_Unit_Api.Get_CU_to_Equip(equip_site_,equip_obj_);
   $ELSE
        source_key_ref_ := NULL;
   $END

   RETURN source_key_ref_;
END Transf_Equip_Obj_To_CU;
-- PRSA-1162, End

@UncheckedAccess
FUNCTION Get_Actual_Cost_For_Task (
   task_seq_                IN NUMBER ) RETURN NUMBER
IS
   total_cost_       NUMBER := 0;
   $IF Component_Wo_SYS.INSTALLED $THEN
      wo_no_            jt_task_tab.wo_no%TYPE;
   $END
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      wo_no_ := Jt_Task_API.Get_Wo_No(task_seq_);

      total_cost_  :=   Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'P') +
                        Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'M') +
                        Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'E') +
                        Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'X') +
                        Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'F') +
                        Jt_Task_Cost_Line_Util_API.Get_Sum_Actual_Cost_For_Task(wo_no_, task_seq_, 'T');
   $END
   RETURN NVL(total_cost_, 0);
END Get_Actual_Cost_For_Task;

@UncheckedAccess
FUNCTION Get_Planned_Cost_For_Task (
   task_seq_                IN NUMBER ) RETURN NUMBER
IS
   total_cost_       NUMBER := 0;
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
     total_cost_  :=    Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'P') +
                        Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'M') +
                        Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'E') +
                        Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'X') +
                        Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'F') +
                        Work_Order_Planning_Util_API.Get_Task_Sum_Planned_Cost_Db(task_seq_, 'T');
   $END
   RETURN NVL(total_cost_, 0);
END Get_Planned_Cost_For_Task;

PROCEDURE Check_Type_Status (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   current_mch_type_ IN VARCHAR2,
   new_mch_type_     IN VARCHAR2 )
IS
   key_ref_          VARCHAR2(260);
BEGIN
   -- If no change, no action
   IF ( NVL( current_mch_type_,'X' ) = NVL( new_mch_type_, 'X' ) ) THEN
      Null;
   ELSE
      -- Was changed, not allowed if has technical data
      key_ref_ := Client_SYS.Get_Key_Reference('EquipmentObject','EQUIPMENT_OBJECT_SEQ','equipment_object_seq_');
      IF EQUIPMENT_OBJECT_API.Has_Technical_Spec_No('EquipmentObject', key_ref_ ) = 'TRUE' THEN
         IF EQUIPMENT_FUNCTIONAL_API.Is_Address( contract_, mch_code_ ) = 'TRUE' THEN
            Error_SYS.Appl_General(lu_name_, 'HASDEMANDS: Object :P1 has demand values. Object type cannot be changed.',mch_code_);
         ELSE
            Error_SYS.Appl_General(lu_name_, 'HASTECHDATA: Object :P1 has technical data values. Object type cannot be changed.',mch_code_);
         END IF;
      END IF;
   END IF;   /* end else */
END Check_Type_Status;


PROCEDURE Complete_Move (
   cmnt_     IN VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   from_mch_code_ IN VARCHAR2,
   from_contract_ IN VARCHAR2,
   to_mch_code_ IN VARCHAR2,
   to_contract_ IN VARCHAR2,
   sign_ IN VARCHAR2,
   dest_contract_ IN VARCHAR2 DEFAULT NULL,
   equip_object_seq_ IN NUMBER DEFAULT NULL,
   is_new_pm_rev_    IN BOOLEAN DEFAULT FALSE,
   wo_site_          IN VARCHAR2 DEFAULT NULL,
   org_code_         IN VARCHAR2 DEFAULT NULL)
IS
   attr_                          VARCHAR2(2000);
   value_                         VARCHAR2(2000);
   name_                          VARCHAR2(30);
   info_                          VARCHAR2(2000);
   transaction_description_       VARCHAR2(2000);
   current_position_              VARCHAR2(200);
   superior_alternate_contract_   VARCHAR2(5);
   superior_alternate_id_         VARCHAR2(100);
   superior_part_no_              VARCHAR2(25);
   superior_serial_no_            VARCHAR2(50);
   dummy_d_null_                  DATE:= NULL;
   
   curr_objid_                    equipment_object.objid%TYPE;
   curr_objversion_               equipment_object.objversion%TYPE;
   equipment_object_rec_          equipment_object_API.Public_Rec;
     
   CURSOR getrec IS
      SELECT *
      FROM equipment_object_tab
      CONNECT BY functional_object_seq = PRIOR equipment_object_seq
      START WITH functional_object_seq = equip_object_seq_;
      
   CURSOR part_info IS
      SELECT part_no, mch_serial_no
      FROM equipment_object_tab
      WHERE mch_code = superior_alternate_id_
      AND contract = superior_alternate_contract_;   
      
   CURSOR get_curr_values(contract_in_ IN VARCHAR2, mch_code_in_ IN VARCHAR2) IS
      SELECT rowid, to_char(rowversion)   
      FROM   equipment_object_tab
      WHERE contract = contract_in_
      AND mch_code = mch_code_in_;
   
BEGIN
   
   FOR newrec IN getrec LOOP
      Client_SYS.Clear_Attr(attr_);
      IF NOT(dest_contract_ IS NULL AND to_mch_code_ IS NOT NULL) THEN 
         Client_SYS.Add_To_Attr('CONTRACT', dest_contract_, attr_);
         Client_SYS.Add_To_Attr('SKIP_CONTRACT_VALIDATION', 'TRUE', attr_);
         
         IF dest_contract_ != newrec.contract THEN
            $IF Component_Pcmstd_SYS.INSTALLED $THEN
               Client_SYS.Add_To_Attr('APPLIED_PM_PROGRAM_ID', '', attr_);
               Client_SYS.Add_To_Attr('APPLIED_PM_PROGRAM_REV', '', attr_);
               Client_SYS.Add_To_Attr('APPLIED_DATE', dummy_d_null_, attr_);
            $ELSE
               NULL;
            $END
         END IF;
      END IF;

      equipment_object_rec_ := Equipment_Object_API.Get(dest_contract_, mch_code_);
      Client_SYS.Add_To_Attr('MCH_LOC',      equipment_object_rec_.mch_loc,      attr_);
      Client_SYS.Add_To_Attr('MCH_POS',      equipment_object_rec_.mch_pos,      attr_);
      Client_SYS.Add_To_Attr('LOCATION_ID',  equipment_object_rec_.location_id,  attr_);
      Client_SYS.Add_To_Attr('COST_CENTER',  equipment_object_rec_.cost_center,  attr_);
      Client_SYS.Add_To_Attr('GROUP_ID',     equipment_object_rec_.group_id,     attr_);
      Client_SYS.Add_To_Attr('OBJECT_NO',    equipment_object_rec_.object_no,    attr_);
         
      OPEN  get_curr_values(newrec.contract, newrec.mch_code);
      FETCH get_curr_values INTO curr_objid_, curr_objversion_;
      CLOSE get_curr_values;
      
      Equipment_Object_API.Modify__( info_, curr_objid_, curr_objversion_, attr_, 'DO' );
      IF dest_contract_ IS NOT NULL AND dest_contract_ != newrec.contract THEN
         $IF Component_Pm_SYS.INSTALLED $THEN
            Pm_Action_API.Handle_Pm_Action( newrec.equipment_object_seq, dest_contract_, wo_site_, org_code_, is_new_pm_rev_);
         $ELSE
            NULL;
         $END
      END IF;
      
      IF newrec.mch_serial_no IS NOT NULL THEN
         IF newrec.part_no IS NOT NULL THEN
            IF NOT(dest_contract_ IS NULL AND to_mch_code_ IS NOT NULL) THEN 
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'DIRECTMOVE: Moved the object :P1 to site :P2 by user :P3', NULL, mch_code_, to_contract_, sign_);
               
            ELSE 
               transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'MOVEOBJ: In object :P1, Moved to object :P1 from object :P2 by user :P3', NULL, to_mch_code_, from_mch_code_, sign_);
            END IF;
            transaction_description_ := transaction_description_||'. '||'('||cmnt_||')';
            current_position_ := Language_SYS.Translate_Constant(lu_name_, 'CURRPOSTXT: Placed in object :P1 at site :P2.', NULL, to_mch_code_, to_contract_);

            IF (to_mch_code_ IS NOT NULL AND from_mch_code_ IS NOT NULL) THEN
               superior_alternate_contract_ := Equipment_Object_API.Get_Contract(newrec.functional_object_seq);
               superior_alternate_id_       := Equipment_Object_API.Get_Mch_Code(newrec.functional_object_seq);

               OPEN part_info;
               FETCH part_info INTO superior_part_no_, superior_serial_no_;
               CLOSE part_info;

               BEGIN
                  Part_Serial_Catalog_API.Exist(superior_part_no_, superior_serial_no_);
               EXCEPTION
                  WHEN OTHERS THEN
                     superior_part_no_   := NULL;
                     superior_serial_no_ := NULL;
               END;

               transaction_description_ := substr(transaction_description_,1,200);     
               Part_Serial_Catalog_API.Modify_Serial_Structure(newrec.part_no, 
                                                               newrec.mch_serial_no, 
                                                               superior_part_no_, 
                                                               superior_serial_no_, 
                                                               transaction_description_);
            END IF;

         END IF;
      END IF;
   END LOOP;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Complete_Move;


PROCEDURE Check_Warranties
IS
BEGIN
   NULL;
END Check_Warranties;


PROCEDURE Remove_Structure_Party (
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2,
   party_type_ IN VARCHAR2 )
IS
   info_  VARCHAR2(2000);

   CURSOR get_str_parties IS
      SELECT p.rowid objid, p.rowversion objversion
      FROM   EQUIPMENT_OBJECT_PARTY_TAB p, 
             (SELECT equipment_object_seq
              FROM   EQUIPMENT_OBJECT_TAB
              CONNECT BY   functional_object_seq = PRIOR equipment_object_seq
              START   WITH equipment_object_seq = Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_)) op
      WHERE  op.equipment_object_seq = p.equipment_object_seq
      AND    p.party_type = party_type_;

BEGIN

   FOR party_rec_ IN get_str_parties LOOP
      Equipment_Object_Party_API.Remove__(info_, 
                                          party_rec_.objid, 
                                          party_rec_.objversion, 
                                          'DO');
   END LOOP;
END Remove_Structure_Party;

PROCEDURE Check_Scrap_Allowed (
   contract_        IN VARCHAR2,
   mch_code_        IN VARCHAR2,
   check_structure_ IN BOOLEAN DEFAULT FALSE )
IS
   equipment_object_seq_   equipment_object_tab.equipment_object_seq%TYPE := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   
   CURSOR get_all_children IS
      SELECT contract, mch_code
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  functional_object_seq IS NOT NULL
            START WITH equipment_object_seq = equipment_object_seq_
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq;
BEGIN
   IF check_structure_ THEN
     FOR next_child_ IN get_all_children LOOP
          IF EQUIPMENT_OBJECT_API.Get_Operational_Status_Db( next_child_.contract, next_child_.mch_code) != 'SCRAPPED' AND (next_child_.mch_code != mch_code_ OR next_child_.contract != contract_) THEN
              Error_Sys.Appl_General(lu_name_, 'CHILDNOTSCR: All child objects in the structure must be scrapped before scrapping the parent.');
          END IF;
     END LOOP;
   END IF;
   
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      IF NOT (check_structure_) THEN
         IF (Psc_Contr_Product_API.Obj_Struc_Has_Srv_Line(mch_code_, contract_) = 'TRUE') THEN
            Error_Sys.Appl_General(lu_name_, 'SCLINESFOROBJSTRUC: There are valid service lines connected to equipment object structure.');
         END IF;
      ELSE
         IF (Psc_Contr_Product_Scope_API.Obj_Has_Srv_Line(mch_code_, contract_) = 'TRUE') THEN
            Error_Sys.Appl_General(lu_name_, 'SCLINESFOROBJ: There are valid service lines connected to equipment object.');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
   
    $IF Component_Wo_SYS.INSTALLED $THEN
      IF NOT (check_structure_) THEN
         IF (Active_Work_Order_API.Obj_Struc_Has_Wo( contract_, mch_code_) = 'TRUE') THEN
            Error_Sys.Appl_General(lu_name_, 'WOSFOROBJSTRUC: There are active work orders/tasks/task steps connected to equipment object structure, Need to move to Work Done/Done state to allow this operation.');
         END IF;
      ELSE
         IF (Active_Work_Order_API.Obj_Has_Wo( contract_, mch_code_) = 'TRUE') THEN
            Error_Sys.Appl_General(lu_name_, 'WOSFOROBJ: There are active work orders/tasks/task steps connected to equipment object, Need to move to Work Done/Done state to allow this operation.');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END

END Check_Scrap_Allowed;


PROCEDURE Set_Struct_Scrappable_Block (
   value_ IN BOOLEAN )
IS
BEGIN
   block_equip_ser_struct_scrap_ := value_;
END Set_Struct_Scrappable_Block;

PROCEDURE Copy_Functional_Object (
   destination_contract_ IN OUT VARCHAR2,
   destination_object_ IN OUT VARCHAR2,
   destination_object_name_ IN VARCHAR2,
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   dest_belongs_to_contract_ IN VARCHAR2 DEFAULT NULL,
   dest_belongs_to_object_ IN VARCHAR2 DEFAULT NULL,
   object_spare_ IN NUMBER DEFAULT 0,
   object_attr_ IN NUMBER DEFAULT 0,
   object_parameter_ IN NUMBER DEFAULT 0,
   object_test_pnt_ IN NUMBER DEFAULT 0,
   object_document_ IN NUMBER DEFAULT 0,
   object_pm_plan_ IN NUMBER DEFAULT 0,
   object_party_ IN NUMBER DEFAULT 0)
IS
   newrec_ EQUIPMENT_OBJECT_TAB%ROWTYPE;
   obj_exist          EXCEPTION;
   no_such_obj        EXCEPTION;
   has_spare          EXCEPTION;
   has_tech_data      EXCEPTION;
   has_parameter      EXCEPTION;
   has_test_pnt       EXCEPTION;
   has_party          EXCEPTION;
   no_pm              EXCEPTION;
   rcode_             VARCHAR2(5);   
   source_key_ref_         VARCHAR2(260);
   destination_key_ref_    VARCHAR2(260);
   sparepart_         VARCHAR2(5);
   test_pnt_          VARCHAR2(5);
   param_             VARCHAR2(5);
   party_             VARCHAR2(5);
   attr_              VARCHAR2(32000);
   objid_             VARCHAR2(20);
   objversion_        VARCHAR2(2000);
   info_              VARCHAR2(2000);
   mch_code_          EQUIPMENT_OBJECT_TAB.MCH_CODE%TYPE;
   client_main_pos_   VARCHAR2(20);
   source_equip_seq_  EQUIPMENT_OBJECT_TAB.EQUIPMENT_OBJECT_SEQ%TYPE;           
   des_equip_seq_     EQUIPMENT_OBJECT_TAB.EQUIPMENT_OBJECT_SEQ%TYPE;  
   
   CURSOR source IS
      SELECT *
      FROM   EQUIPMENT_OBJECT_TAB
      WHERE  contract = source_contract_
      AND    mch_code = source_object_;
      
   FUNCTION Check_Exist(
      contract_ IN VARCHAR2,
      mch_code_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
      CURSOR exist_control IS
         SELECT 1
         FROM   EQUIPMENT_OBJECT_TAB
         WHERE  contract = contract_
         AND    mch_code = mch_code_
         AND    obj_level IS NOT NULL;
   BEGIN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         RETURN(TRUE);
      END IF;
      CLOSE exist_control;
      RETURN(FALSE);   
   END Check_Exist;
   
   BEGIN
   
   source_equip_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(source_contract_, source_object_);
   des_equip_seq_    := Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_);
   
   IF ((dest_belongs_to_object_ IS NOT NULL) AND (dest_belongs_to_contract_ IS NOT NULL)) THEN
      IF (Check_Exist(dest_belongs_to_contract_, dest_belongs_to_object_) = FALSE) THEN
         RAISE no_such_obj;
      END IF;
   END IF;
   
   --Make sure the MCH_CODE is return...
   mch_code_ := Client_SYS.Get_Item_Value('MCH_CODE', attr_);
   IF (mch_code_ IS NOT NULL) THEN
      destination_object_ := mch_code_;
   END IF;
   
   IF (object_spare_ = 1) THEN
      sparepart_ := Equipment_Object_Spare_API.Has_Spare_Part (source_contract_, source_object_);

      IF Equipment_Object_Spare_API.Has_Spare_Part (destination_contract_, destination_object_) = 'TRUE' THEN
         RAISE has_spare;
      END IF;
   END IF;

   IF ((object_attr_ = 1) OR (object_document_ = 1)) THEN
      source_key_ref_ := Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', source_equip_seq_);
      destination_key_ref_ := Client_SYS.Get_Key_Reference('EquipmentObject', 'EQUIPMENT_OBJECT_SEQ', des_equip_seq_);
   END IF;

   IF (object_attr_ = 1 ) THEN
--    demand_ := Equipment_Object_API.Has_Technical_Spec_No ('EquipmentObject', source_key_ref_);

      IF Equipment_Object_API.Has_Technical_Spec_No ('EquipmentObject', destination_key_ref_) = 'TRUE' THEN
         RAISE has_tech_data;
      END IF;
   END IF;
   IF (object_test_pnt_ = 1) THEN
      test_pnt_ := Equipment_Object_Test_Pnt_API.Has_Test_Point (source_contract_, source_object_);

      IF Equipment_Object_Test_Pnt_API.Has_Test_Point (destination_contract_, destination_object_) = 'TRUE' THEN
         RAISE has_test_pnt;
      END IF;
   END IF;
   IF (object_parameter_ = 1) THEN
      param_ := Equipment_Object_Param_API.Has_Parameter (source_contract_, source_object_);
      
      IF Equipment_Object_Param_API.Has_Parameter (destination_contract_, destination_object_) = 'TRUE' THEN
        RAISE has_parameter;
      END IF;
   END IF;
   IF (object_document_ = 1) THEN
      Equipment_functional_API.Has_Document(rcode_, source_contract_, source_object_);
   END IF;
   IF (object_party_ = 1) THEN
      party_ := Equipment_Object_Party_API.Has_Party(source_contract_, source_object_);

      IF Equipment_Object_Party_API.Has_Party (destination_contract_, destination_object_) = 'TRUE' THEN
         RAISE has_party;
      END IF;
   END IF;
   IF (object_pm_plan_ = 1) THEN
      IF (object_parameter_ = 0) OR (object_test_pnt_ = 0) THEN
         RAISE no_pm;
      END IF;
   END IF;
   
   IF (Check_Exist(destination_contract_, destination_object_) = FALSE)THEN
      OPEN source;
      FETCH source INTO newrec_;
      CLOSE source;

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', destination_contract_, attr_);
      -- Here it shall be destination_object_, the new__ method makes the concatenation
      Client_SYS.Add_To_Attr('MCH_CODE', destination_object_, attr_);
      Client_SYS.Add_To_Attr('MCH_NAME', destination_object_name_ , attr_);
      Client_SYS.Add_To_Attr('GROUP_ID', newrec_.group_id, attr_);
      Client_SYS.Add_To_Attr('SUP_MCH_CODE', dest_belongs_to_object_, attr_);
      Client_SYS.Add_To_Attr('SUP_CONTRACT', dest_belongs_to_contract_, attr_);
      Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(dest_belongs_to_contract_, dest_belongs_to_object_), attr_);
      Client_SYS.Add_To_Attr('MCH_LOC', newrec_.mch_loc, attr_);
      Client_SYS.Add_To_Attr('MCH_POS', newrec_.mch_pos, attr_);
      Client_SYS.Add_To_Attr('MCH_DOC', newrec_.mch_doc, attr_);
      Client_SYS.Add_To_Attr('MANUFACTURER_NO', newrec_.manufacturer_no, attr_);
      Client_SYS.Add_To_Attr('VENDOR_NO', newrec_.vendor_no, attr_);
      Client_SYS.Add_To_Attr('TYPE', newrec_.type, attr_);
      Client_SYS.Add_To_Attr('PART_NO', newrec_.part_no, attr_);
      Client_SYS.Add_To_Attr('CRITICALITY', newrec_.criticality, attr_);
      Client_SYS.Add_To_Attr('WARR_EXP', newrec_.warr_exp, attr_);
      Client_SYS.Add_To_Attr('MCH_TYPE', newrec_.mch_type, attr_);
      Client_SYS.Add_To_Attr('COST_CENTER', newrec_.cost_center, attr_);
      Client_SYS.Add_To_Attr('OBJECT_NO', newrec_.object_no, attr_);
      Client_SYS.Add_To_Attr('NOTE', newrec_.note, attr_);
      Client_SYS.Add_To_Attr('CATEGORY_ID', newrec_.category_id, attr_);
      IF(newrec_.main_pos IS NOT NULL) THEN
          client_main_pos_ := Equipment_Main_Position_API.Decode(newrec_.main_pos);
      END IF;
      Client_SYS.Add_To_Attr('EQUIPMENT_MAIN_POSITION', client_main_pos_, attr_);
      Client_SYS.Add_To_Attr('PRODUCTION_DATE', newrec_.production_date, attr_);
      Client_SYS.Add_To_Attr('OBJ_LEVEL', newrec_.obj_level, attr_);
      Client_SYS.Add_To_Attr('INFO', newrec_.info, attr_);
      Client_SYS.Add_To_Attr('DATA', newrec_.data, attr_);
      Client_SYS.Add_To_Attr('IS_CATEGORY_OBJECT', newrec_.is_category_object, attr_);
      Client_SYS.Add_To_Attr('IS_GEOGRAPHIC_OBJECT', newrec_.is_geographic_object, attr_);
      Client_SYS.Add_To_Attr('LOCATION_OBJECT_SEQ', newrec_.location_object_seq, attr_);
      Client_SYS.Add_To_Attr('FROM_OBJECT_SEQ', newrec_.from_object_seq, attr_);
      Client_SYS.Add_To_Attr('TO_OBJECT_SEQ', newrec_.to_object_seq, attr_);
      Client_SYS.Add_To_Attr('PROCESS_OBJECT_SEQ', newrec_.process_object_seq, attr_);
      Client_SYS.Add_To_Attr('PIPE_OBJECT_SEQ', newrec_.pipe_object_seq, attr_);
      Client_SYS.Add_To_Attr('CIRCUIT_OBJECT_SEQ', newrec_.circuit_object_seq, attr_);
      Client_SYS.Add_To_Attr('ITEM_CLASS_ID', newrec_.item_class_id, attr_);
      Client_SYS.Add_To_Attr('PROCESS_CLASS_ID', newrec_.process_class_id, attr_);
    
      -- Client_SYS.Add_To_Attr('PURCH_PRICE', newrec_.purch_price, attr_);
      -- Client_SYS.Add_To_Attr('PURCH_DATE', newrec_.purch_date, attr_);      
      
      EQUIPMENT_FUNCTIONAL_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   
   des_equip_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_);
   destination_key_ref_ := 'EQUIPMENT_OBJECT_SEQ='||des_equip_seq_||'^';
   
   -- Start Copy Extra Data to the Destination Object
   IF object_attr_ = 1 THEN
      -- If demands exist, they have already been copied by now.
      -- Check whether equipment object has a technical number before copy technical object values.
      IF Equipment_object_api.has_technical_spec_no('EquipmentObject',(Client_SYS.Get_Key_Reference('EquipmentObject',  'EQUIPMENT_OBJECT_SEQ', source_equip_seq_))) = 'TRUE' THEN
         Technical_Object_Reference_API.Copy ( 'EquipmentObject', source_key_ref_, destination_key_ref_,'TRUE','TRUE');
      END IF;
      null;
   END IF;

   IF object_spare_ = 1 AND sparepart_ = 'TRUE' THEN
      Equipment_Object_Spare_API.Copy (source_contract_, source_object_, destination_contract_, destination_object_);
   END IF;
   IF object_test_pnt_ = 1 AND test_pnt_ = 'TRUE' THEN
      Equipment_Object_Test_Pnt_API.Copy (source_contract_, source_object_, destination_contract_, destination_object_);
   END IF;
   IF object_parameter_ = 1 AND param_ = 'TRUE' THEN
      Equipment_Object_Param_API.Copy (source_contract_, source_object_, destination_contract_, destination_object_);
   END IF;
   IF object_document_ = 1 AND rcode_ = 'TRUE' THEN
      Maintenance_Document_Ref_API.Copy( 'EquipmentObject', source_key_ref_, 'EquipmentObject', destination_key_ref_ );
   END IF;
   IF object_party_ = 1 AND party_ = 'TRUE' THEN
      Equipment_Object_Party_API.Copy (source_contract_, source_object_, destination_contract_, destination_object_);
   END IF;
   $IF Component_Pm_SYS.INSTALLED $THEN
      IF object_pm_plan_ = 1 THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('SOURCE',                 source_object_,        attr_);
         Client_SYS.Add_To_Attr('DESTINATION',            destination_object_,   attr_);
         Client_SYS.Add_To_Attr('DESTINATION_CONTRACT',   destination_contract_, attr_);
         Client_SYS.Add_To_Attr('SOURCE_CONTRACT',        source_contract_,      attr_);
         Client_SYS.Add_To_Attr('DESTINATION_OBJECT_SEQ', des_equip_seq_,        attr_);
         PM_ACTION_API.COPY(attr_);
      END IF;
   $END
EXCEPTION
   WHEN no_such_obj THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFONOSUPOBJ: The Belongs to Object does not exist.');
   WHEN has_spare THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOHASSPARE: The destination object already has spare parts.');
   WHEN has_tech_data THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOHASTECHDATA: The destination object already has demands.');
   WHEN has_parameter THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOHASPARAM: The destination object already has parameters.');
   WHEN has_test_pnt THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOHASTSTPNT: The destination object already has testpoints.');
   WHEN has_party THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOHASPARTY: The destination object already has parties.');
   WHEN no_pm THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFONOPM: Parameter and testpoint must be copied together with the PM plan.');
   WHEN obj_exist THEN
      Error_SYS.Record_General('EquipmentObjectUtil', 'CFOOBJEXIST: This object already exists.');
 END Copy_Functional_Object;

 
FUNCTION Is_Project_Connected_To_WO (
   contract_       IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   project_id_      IN VARCHAR2,
   asset_manager_ IN VARCHAR2) RETURN VARCHAR2
IS
      $IF Component_Wo_SYS.INSTALLED $THEN
      temp_ number;
         CURSOR get_WOs IS
            select (1)
               from WORK_ORDER where 
               contract = contract_
               AND project_no = project_id_
               AND  ((connection_type_db = 'EQUIPMENT' AND 
                     (mch_code LIKE nvl(mch_code_, '%') OR (mch_code,mch_code_contract) IN (SELECT MCH_CODE,CONTRACT
                                                                                             FROM EQUIPMENT_OBJECT_UIV
                                                                                             START WITH SUP_MCH_CODE = mch_code_
                                                                                             AND SUP_CONTRACT = contract_
                                                                                             CONNECT BY PRIOR MCH_CODE = SUP_MCH_CODE
                                                                                             AND PRIOR CONTRACT = SUP_CONTRACT))
                     AND Equipment_Object_Party_API.Belongs_To_Asset_Manager(contract, mch_code, asset_manager_) =  'TRUE' )
                  OR (connection_type_db != 'EQUIPMENT' AND mch_code LIKE nvl(mch_code_, '%')));
        $END       
        
      BEGIN
        $IF Component_Wo_SYS.INSTALLED $THEN              
           OPEN get_WOs;
           FETCH get_WOs INTO temp_;
           CLOSE get_WOs;    
      
           IF temp_ >0 THEN
             RETURN 'TRUE';
           ELSE
             RETURN 'FALSE';
           END IF;
        $END
        RETURN NULL;
   
END Is_Project_Connected_To_WO; 
     
@UncheckedAccess
FUNCTION Get_Symptom_Count_Per_Object (
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2) RETURN NUMBER
IS
   count_  NUMBER := 0;
   CURSOR get_symptom_count IS
      SELECT count(err_symptom)
      FROM EQUIPMENT_OBJECT_SYMPTOMS
      WHERE mch_code = mch_code_
      AND contract = contract_;
BEGIN
   OPEN get_symptom_count;
   FETCH get_symptom_count INTO count_;
   CLOSE get_symptom_count;

   RETURN count_;
END Get_Symptom_Count_Per_Object;

-- Modify_Positions_For_Location
--    finds all Equipment Objects with the given Location Id
--    and replaces the Map Position, if possition is NULL existing Map Positions is removed
PROCEDURE Modify_Positions_For_Location (
   location_id_   IN VARCHAR2,
   longitude_     IN NUMBER,
   latitude_      IN NUMBER,
   altitude_      IN NUMBER )
IS
   key_ref_     VARCHAR2(200);

   CURSOR get_objects IS
      SELECT *
        FROM EQUIPMENT_OBJECT_TAB 
       WHERE location_id = location_id_;
BEGIN
   FOR rec_ IN get_objects LOOP
      key_ref_  := Client_SYS.Get_Key_Reference('EquipmentObject',  'EQUIPMENT_OBJECT_SEQ', rec_.equipment_object_seq);
      IF ( longitude_ IS NOT NULL ) THEN
         Map_Position_API.Create_And_Replace('EquipmentObject', key_ref_, longitude_, latitude_, altitude_);
      ELSE
         Map_Position_API.Remove_Position_For_Object('EquipmentObject', key_ref_);
      END IF;
   END LOOP;
END Modify_Positions_For_Location;

@IgnoreUnitTest NoOutParams
PROCEDURE Handle_Moved_To_Invent (   
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2)
   
 IS
   mch_code_          equipment_object_tab.mch_code%TYPE;
   contract_          equipment_object_tab.contract%TYPE;
   found_             BOOLEAN;
   CURSOR get_object_info IS
      SELECT contract, mch_code
        FROM equipment_object_tab 
       WHERE part_no       = part_no_
         AND mch_serial_no = serial_no_;        
BEGIN
   OPEN get_object_info;
   FETCH get_object_info INTO contract_, mch_code_;   
   found_ := get_object_info%FOUND;   
   CLOSE get_object_info;
  
   IF (found_) THEN
      Equipment_Object_API.Remove_Superior_Info(contract_, mch_code_);
      Equipment_Serial_API.Set_Structure_Out_Of_Operation(contract_, mch_code_);
   END IF;  
END Handle_Moved_To_Invent;

@IgnoreUnitTest NoOutParams
PROCEDURE Handle_Scrap_Serial_Object (
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2 )
IS
   mch_code_          equipment_object_tab.mch_code%TYPE; 
   contract_          equipment_object_tab.contract%TYPE;
   found_             BOOLEAN;
   CURSOR get_object_info IS
      SELECT contract, mch_code
        FROM equipment_object_tab
       WHERE part_no       = part_no_
         AND mch_serial_no = serial_no_;        
BEGIN
   OPEN get_object_info;
   FETCH get_object_info INTO contract_, mch_code_;   
   found_ := get_object_info%FOUND;   
   CLOSE get_object_info;

   IF (found_) THEN 
      Check_Scrap_Allowed(contract_, mch_code_, block_equip_ser_struct_scrap_);
      
      $IF Component_Pm_SYS.INSTALLED $THEN
         Pm_Action_API.Set_Pm_To_Obsolete(contract_, mch_code_);
      $ELSE
         NULL;
      $END
   END IF;
END Handle_Scrap_Serial_Object;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Object_Info (
   contract_   OUT VARCHAR2,
   mch_code_   OUT VARCHAR2,
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2 )
IS
   CURSOR get_object IS
      SELECT mch_code, contract
      FROM equipment_object_tab 
      WHERE part_no = part_no_
      AND mch_serial_no = serial_no_;
      
BEGIN
   OPEN get_object;
   FETCH get_object INTO mch_code_, contract_;
   CLOSE get_object;
END Get_Object_Info;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Part_Info (
   part_no_     OUT VARCHAR2,
   serial_no_   OUT VARCHAR2,
   contract_    IN VARCHAR2,
   mch_code_    IN VARCHAR2 )
IS
   CURSOR get_part IS
      SELECT part_no, mch_serial_no
        FROM equipment_object_tab 
       WHERE contract = contract_
         AND mch_code = mch_code_;
 
BEGIN
   OPEN get_part;
   FETCH get_part INTO part_no_, serial_no_;
   CLOSE get_part; 
END Get_Part_Info;

@UncheckedAccess
FUNCTION Get_Part_Latest_Transaction (
   contract_     IN VARCHAR2,
   mch_code_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_              equipment_serial.part_no%TYPE;
   serial_no_            equipment_serial.serial_no%TYPE;
   found_                BOOLEAN;
   latest_transaction_   part_serial_catalog_tab.latest_transaction%TYPE := NULL;
   
   CURSOR part_info IS
      SELECT part_no, serial_no
        FROM equipment_serial
       WHERE mch_code = mch_code_
         AND contract = contract_;
BEGIN
   OPEN part_info;
   FETCH part_info INTO part_no_, serial_no_;   
   found_ := part_info%FOUND;   
   CLOSE part_info;
   
   IF (found_) THEN
      latest_transaction_:= part_serial_catalog_api.Get_Latest_Transaction(part_no_,serial_no_);
   END IF;   
   RETURN latest_transaction_;
END Get_Part_Latest_Transaction;

PROCEDURE Copy_Object_Connections(
   lu_name_ IN VARCHAR2,
   old_key_ IN VARCHAR2,
   new_key_ IN VARCHAR2,
   old_key_value_ IN VARCHAR2 DEFAULT NULL,
   new_key_value_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   $IF Component_Docman_SYS.INSTALLED $THEN
         UPDATE APPROVAL_ROUTING_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
      UPDATE  TECHNICAL_OBJECT_REFERENCE_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   
   $IF Component_Docman_SYS.INSTALLED $THEN
         UPDATE DOC_REFERENCE_OBJECT_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   IF (old_key_value_ IS NOT NULL AND new_key_value_ IS NOT NULL) THEN
      UPDATE  TECHNICAL_OBJECT_REFERENCE_TAB
         SET key_value = new_key_value_
         WHERE lu_name = lu_name_
         AND key_value = old_key_value_;
         
      $IF Component_Docman_SYS.INSTALLED $THEN
         UPDATE DOC_REFERENCE_OBJECT_TAB
            SET key_value = new_key_value_
            WHERE lu_name = lu_name_
            AND key_value = old_key_value_;
      $ELSE
         NULL;
      $END
   END IF;
   
   $IF Component_Docman_SYS.INSTALLED $THEN
         UPDATE DOC_REQUIREMENT_OBJECT_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Pdmcon_SYS.INSTALLED $THEN
         UPDATE ECR_OBJECT_CONN_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Pdmcon_SYS.INSTALLED $THEN
         UPDATE ECO_ACTION_OBJECT_CONN_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Gisint_SYS.INSTALLED $THEN
         UPDATE GISINT_CONNECTIONS_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Linast_SYS.INSTALLED $THEN
         UPDATE LINAST_ELEMENT_OBJECT_CONN_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Natstd_SYS.INSTALLED $THEN
         UPDATE NATO_COMM_GOV_REF_OBJ_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Callc_SYS.INSTALLED $THEN
         UPDATE CC_CASE_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Osha_SYS.INSTALLED $THEN
         UPDATE RISK_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
      UPDATE MAP_POSITION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   
      UPDATE  MEDIA_LIBRARY_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   
   $IF Component_Osha_SYS.INSTALLED $THEN
            UPDATE  INCIDENT_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Quaaud_SYS.INSTALLED $THEN
            UPDATE  AUDIT_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Quancr_SYS.INSTALLED $THEN
            UPDATE  NCR_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
   
   $IF Component_Iotctr_SYS.INSTALLED $THEN
         UPDATE IOT_OBJECT_CONNECTION_TAB
         SET key_ref = new_key_
         WHERE lu_name = lu_name_
         AND key_ref = old_key_;
   $ELSE
      NULL;
   $END
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Error occured during moving object from ' || lu_name_ || ' ' || old_key_ || ' To ' || lu_name_ || ' ' || new_key_);
END Copy_Object_Connections;


-- below 3 methods are added as a temporary workaround for updating parent object seq in aurena.
-- there is a bug in aurena fw which copy option doesnt work for based on entities. - deeklk
PROCEDURE Add_Parent_Seq_To_Attr (
   attr_ IN OUT VARCHAR2,
   equipment_object_seq_ IN NUMBER DEFAULT NULL)
IS
BEGIN
   -- functional parent
   Append_To_Attr___(attr_, 'SUP_MCH_CODE',      'SUP_CONTRACT',    'FUNCTIONAL_OBJECT_SEQ', equipment_object_seq_);
   -- location parent
   Append_To_Attr___(attr_, 'LOCATION_MCH_CODE', 'LOCATION_CONTRACT', 'LOCATION_OBJECT_SEQ', equipment_object_seq_);
   -- from parent
   Append_To_Attr___(attr_, 'FROM_MCH_CODE',     'FROM_CONTRACT',         'FROM_OBJECT_SEQ', equipment_object_seq_);
   -- to parent
   Append_To_Attr___(attr_, 'TO_MCH_CODE',       'TO_CONTRACT',             'TO_OBJECT_SEQ', equipment_object_seq_);
   -- process parent
   Append_To_Attr___(attr_, 'PROCESS_MCH_CODE',  'PROCESS_CONTRACT',   'PROCESS_OBJECT_SEQ', equipment_object_seq_);
   -- pipe parent
   Append_To_Attr___(attr_, 'PIPE_MCH_CODE',     'PIPE_CONTRACT',         'PIPE_OBJECT_SEQ', equipment_object_seq_);
   -- circuit parent
   Append_To_Attr___(attr_, 'CIRCUIT_MCH_CODE',  'CIRCUIT_CONTRACT',   'CIRCUIT_OBJECT_SEQ', equipment_object_seq_);
END Add_Parent_Seq_To_Attr;

PROCEDURE Append_To_Attr___ (
   attr_                 IN OUT VARCHAR2,
   mch_attrb_name_       IN     VARCHAR2,
   contract_attrb_name_  IN     VARCHAR2,
   seq_attrb_name_       IN     VARCHAR2,
   equipment_object_seq_ IN     NUMBER )
IS
   rec_  Equipment_Object_API.Public_Rec;
BEGIN
   IF Client_SYS.Item_Exist(mch_attrb_name_, attr_) THEN
      -- crud create scenario
      IF equipment_object_seq_ IS NULL THEN
         rec_.mch_code := Client_SYS.Get_Item_Value(mch_attrb_name_, attr_);
         rec_.contract := Client_SYS.Get_Item_Value(contract_attrb_name_, attr_);
         -- crud update scenario
      ELSE
         rec_ := Equipment_Object_API.Get(equipment_object_seq_);
         Handle_All_Structs_For_Update___(rec_, contract_attrb_name_, mch_attrb_name_, attr_);
      END IF;
      rec_.equipment_object_seq := Equipment_Object_API.Get_Equipment_Object_Seq(rec_.contract, rec_.mch_code);
      Client_SYS.Add_To_Attr(seq_attrb_name_, rec_.equipment_object_seq, attr_); 
   END IF;
END Append_To_Attr___;

PROCEDURE Handle_All_Structs_For_Update___ (
   rec_                 IN OUT Equipment_Object_API.Public_Rec,
   contract_attrb_name_ IN     VARCHAR2,
   mch_attrb_name_      IN     VARCHAR2,
   attr_                IN     VARCHAR2 )
IS
   seq_  equipment_object_tab.equipment_object_seq%TYPE;
BEGIN
   IF mch_attrb_name_ = 'SUP_MCH_CODE' THEN
      seq_ := rec_.functional_object_seq;
   ELSIF mch_attrb_name_ = 'LOCATION_MCH_CODE' THEN
      seq_ := rec_.location_object_seq;
   ELSIF mch_attrb_name_ = 'FROM_MCH_CODE' THEN
      seq_ := rec_.from_object_seq;
   ELSIF mch_attrb_name_ = 'TO_MCH_CODE' THEN
      seq_ := rec_.to_object_seq;
   ELSIF mch_attrb_name_ = 'PROCESS_MCH_CODE' THEN
      seq_ := rec_.process_object_seq;
   ELSIF mch_attrb_name_ = 'PIPE_MCH_CODE' THEN
      seq_ := rec_.pipe_object_seq;
   ELSIF mch_attrb_name_ = 'CIRCUIT_MCH_CODE' THEN
      seq_ := rec_.circuit_object_seq;
   END IF;
   
   rec_.contract := nvl(Client_SYS.Get_Item_Value(contract_attrb_name_, attr_ ), Equipment_Object_API.Get_Contract(seq_));   
   rec_.mch_code := Client_SYS.Get_Item_Value(mch_attrb_name_, attr_);
END Handle_All_Structs_For_Update___; 

PROCEDURE Check_Move_Allowed (
   equipment_object_seq_  IN NUMBER,
   dest_contract_         IN VARCHAR2 )
IS
   mch_code_   equipment_object_tab.mch_code%TYPE := Equipment_Object_API.Get_mch_code(equipment_object_seq_);
   contract_   equipment_object_tab.contract%TYPE := Equipment_Object_API.Get_Contract(equipment_object_seq_);
   part_no_    equipment_object_tab.part_no%TYPE := Equipment_Object_API.Get_Part_No(equipment_object_seq_);
BEGIN
   
   IF Equipment_Object_Api.Is_Scrapped(contract_, mch_code_) = 'TRUE' THEN 
      Error_SYS.Appl_General(lu_name_, 'OBJECTSCRAPPED: Part :P1 is scrapped. Move is not allowed', part_no_); 
   END IF;
   IF Equipment_Object_API.Check_Exist(dest_contract_, mch_code_) = 'TRUE' THEN
      Error_SYS.Appl_General(lu_name_, 'OBJNOTINCONTRACT: Object :P1 already exist in Site :P2. Move is not allowed.', mch_code_, dest_contract_);
   END IF;   
   $IF Component_Pcmsci_SYS.INSTALLED $THEN
      IF Psc_Contr_Product_Scope_API.Object_Exist_In_Srv_Line(equipment_object_seq_) = 'TRUE' THEN
         Error_SYS.Appl_General(lu_name_, 'VALIDSCEXIST: Object :P1 has Service or/and Request Contracts. Move is not allowed', mch_code_);  
      END IF;
   $END
   $IF Component_Invent_SYS.INSTALLED $THEN  
      IF Inventory_Part_API.Part_Exist(dest_contract_, part_no_) = 0 THEN
         Error_SYS.Appl_General(lu_name_, 'OBJNOINVNOPUPART: The part :P1 is not an inventory part in Site :P2. Move is not allowed', part_no_, dest_contract_);   
      END IF;
   $END
   $IF Component_Wo_SYS.INSTALLED $THEN
      IF (Active_Work_Order_API.Obj_Has_Wo( contract_, mch_code_) = 'TRUE' ) THEN
         Error_SYS.Appl_General(lu_name_, 'MOBEOBJHASWO: Object :P1 at :P2 has ongoing work. Move is not allowed.', mch_code_, contract_);
      END IF;
      IF (Wo_Srv_Quo_API.Check_Quo_Usage_For_Obj(equipment_object_seq_) = 'TRUE' ) THEN
         Error_SYS.Appl_General(lu_name_, 'SRVQUOEXIST: Object :P1 at :P2 has service quotations and can not be moved.', mch_code_, contract_);
      END IF;  
      IF Jt_Task_Srv_Quo_Util_API.Check_Srv_Quo_For_Obj(Equipment_Object_API.lu_name_, Equipment_Object_API.Get_Objkey(equipment_object_seq_)) THEN
         Error_SYS.Appl_General(lu_name_, 'WOQUOLINEEXIST: Object :P1 has service quotation task lines. Move is not allowed.', mch_code_); 
      END IF;
   $END
   $IF Component_Metinv_SYS.INSTALLED $THEN  
      IF (Metering_Object_Line_API.Check_Obj_Line_Exist(equipment_object_seq_))  THEN
         Error_SYS.Appl_General(lu_name_, 'METINVLINEEXIST: Object :P1 has metering invoice lines. Move is not allowed.', mch_code_); 
      END IF;
   $END 
   $IF Component_Reqmgt_SYS.INSTALLED $THEN  
      IF (Request_Utility_API.Check_Req_Line_For_Obj(Equipment_Object_API.lu_name_, Equipment_Object_API.Get_Objkey(equipment_object_seq_))) THEN
         Error_SYS.Appl_General(lu_name_, 'REUESTSCOPEXIST: Object :P1 has request scope lines. Move is not allowed.', mch_code_);   
      END IF;
   $END        
END Check_Move_Allowed;
