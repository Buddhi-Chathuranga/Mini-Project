-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentSpareStructure
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960321  STOL    Base Table to Logical Unit Generator 1.0A
--  960403  STOL    Added EXIT at end of file.
--  960430  STOL    Added method Copy__ and Check_Exist_Part_Str___.
--  960502  STOL    Added method Validate_Comb___.
--  960515  STOL    Added method Substitute_Part_.
--  960604  STOL    Upgraded to IFS Foundation 1.2.1
--  961014  TOWI    Recreated from Rose model using Developer's Workbench.
--  961029  TOWI    Get's the default contract from method i LU MaintenanceSpare
--  961106  ADBR    Upgraded to 1.2.2.
--  961121  CAJO    Changed direct Update-statement to Modify__ call in
--                  procedure Substitute_Part__.
--  961219  ADBR    Merged with new templates.
--  970108  NILA    Modified procedure Substitute_Part__.
--                  Added procedure and procedure calls to Validate_Comb___
--  970109  CAJO    Moved Maintenance_Spare_API.Exist from Unpack_Check_Insert
--                  to Validate_Comb___ for spare_id and contract.
--  970110  NILA    Added function Has_Spare_Structure_Boolean. Modified
--                  atribute COMPONENT_SPARE_ID to be updateable.
--  970114  NILA    Removed procedure Get_Objid.
--  970117  NILA    Added public procedure Has_Parent.
--  970124  ADBR    Added public procedure Get_Parent.
--  970124  ADBR    Added EQUIPMENT_SPARE_STRUCTURE_DISTINCT view.
--  970127  ADBR    Added public function Get_Objid.
--  970403  TOWI    Adjusted to new templates in Foundation 1.2.2c.
--  970409  TOWI    97-0016 Added parameter destination contract to procedure copy__.
--  970806  ERJA    Ref 97-0047, Changed ref name on component_spare_id, spare_id and
--                  EQUIPMENT_SPARE_STRUC_DISTINCT.spare_id to PurchasePart
--  971107  MNYS    Changed contract to spare_contract.
--  971118  HAST    Added contract as suplementary key to mch_code.
--  980220  ADBR    Added component_spare_contract.
--  980324  CLCA    Added component_spare_contract in Copy__.
--  980326  CLCA    Added exist control on spare_contract in Unpack_Check_Insert__.
--  980409  CAJO    Removed spare_contract from Prepare_Insert. Moved all exist controls
--                  for spare parts to Validate_Comb__.
--  980424  CAJO    Replaced Get_App_Owner with Get_Fnd_User.
--  980817  ERJA    Bug Id 2374: Corrected qty and component_spare_contract to be mandatory.
--  990113  MIBO    SKY.0208 AND SKY.0209 Removed all calls to Get_Instance___
--                  in Get-statements.
--  990124  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990131  ANCE    Set data type to 'NUMBER' without any fixed number of characters for quantities.
--  990324  MIBO    Bug Id 8030: Added spare_id_controll in PROCEDURE Validate_Comb___
--  991227  ANCE    Changed template due to performance improvement.
--  000608  PRKU    Added Pm_Action_Spare_Part_API.Description_For_Part in PROCEDURE Validate_Comb___.
--  000615  PRKU    Added Dynamic Sql to get description in Validate_Comb___.
--  000713  NAJA    Added code to unpack_check_update and unpack_check_insert to give an error msg when 
--                  entering negative values to quantity. 
--  000818  PJONSE  Call Id: 39169. Changed size for desc_ in call for Pm_Action_Spare_Part_API.Description_For_Part in Validate_Comb___.  
--  000823  PJONSE  Call Id: 40184. Removed call for Maintenance_Spare_API.Exist and added dynamic call for Inventory_Part_API.Exist in Validate_Comb___. 
--  001213  CHATLK  Call Id: 57648. Modified the Error message NOTINVORPURPART in PROCEDURE Validate_Comb___. 
--  010104  PRKU    Call id 55945. Added function Exist_Comp_Part_Str. Changed call for Inventory_Part_API.Exist 
--                  to Purchase_Part_API.Exist in Validate_Comb___.
--  010426  CHATLK  Added the General_SYS.Init_Method to PROCEDURE Has_Parent.  
--  010426  CHATLK  Added the General_SYS.Init_Method to PROCEDURE Get_Parent.   
--  230304  DIMALK  Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package body. 
--  040414  JAPELK  Bug ID: 114022 (:- In Validate_Comb___ wrong in params for the method PURCHASE_PART_API.Exist) 
--  040423  UDSULK  Unicode Modification-substr removal-4.
--  040531  SHAFLK  Bug Id 44879,Added dynamic view MAINT_PUR_PART. 
--  040603  SHAFLK  Bug Id 44879,Modified method Validate_Comb___.
--  040621  SHAFLK  Bug Id 45579,Calls to INVENTORY_FLAG_API.DECODE in method Validate_Comb___ made dynamic.  
--  040622  DIAMLK  Merged Patch Handling.
--  040914  SHAFLK  Bug Id 46972,Modified method Validate_Comb___ and removed dynamic view MAINT_PUR_PART. 
--  040927  DIAMLK  Merged LCS Bug ID:46972.
--  041220  HADALK  Bug Id 47948 Modified the views and the relevant methods  due to the change of the primary key of the table
--  041229  Chanlk  Mreged Bug 47948.
--  051028  SHAFLK  Bug Id 54203 moified view EQUIPMENT_SPARE_STRUCTURE, Unpack_Check_Insert___, Unpack_Check_Update___
--                  Update___ and Insert___. 
--  051103  NIJALK  Merged bug 54203. 
--  060227  JAPALK  Call ID 135672. Modified Copy__ method.
--  060304  ranflk  Call ID 136328 . Modified Unpack_Check_Update
--  060305  ASSALK  Call ID 135662. Modified Prepare_Insert___
-----------------------------------------------------------------------------
--  060706  AMDILK  MEBR1200: Enlarge Identity - Changed Customer Id length from 10 to 20
--  070227  SHAFLK  Bug 63723, Added View EQUIP_INV_PUR_PART and Function Get_Invent_Purch_Part_Objid and modified Validate_Comb___.
--  070307  ILSOLK  Merged Bug Id 63723.
--  070321  SHAFLK  Bug 64065, Modified View EQUIP_INV_PUR_PART.
--  070409  AMDILK  Merged bug id 64065
--  070515  AMDILK  Call Id 144026: Increase the length of the variable "desc" in ValidateComb__()
--  070605  LIAMLK  Bug 65163, Added Procedure Check_Part_No__.
--  070612  LIAMLK  Bug 65163, Modified Procedure Check_Part_No__.
--  070820  AMDILK  Merged bug 65163
--  070823  AMDILK  Modified method Check_Part_No__(), included a new server call
--  070829  IMGULK  Added Assert_SYS Assertions. 
--  081031  PRIKLK  Bug 76610, Added new column allow_detached_wo_mat_site to base view and default insert/update methods. Added new method Has_Spare_Struc_For_Site.
--  090423  NUKULK  Bug 82312, Modified Check_Part_No__. Set Var size to DB size.
--  090518  NUKULK  Bug 82400, Modified create view EQUIP_INV_PUR_PART.
--  090602  LIAMLK  Bug 82609, Added missing undefine statements.
--  -------------------------Project Eagle-----------------------------------
--  090930  Hidilk  Task EAST-317, reference added for enumeration package TRANSLATE_BOOLEAN_API
--  091015  SHAFLK  Bug 86302, Modified View EQUIP_INV_PUR_PART.
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  091106  SaFalk  IID - ME310: Removed bug comment tags.
--  110420  GAHALK  Bug 96506, Modified Unpack_Check_Insert___() and Unpack_Check_Update___().
--  110107  HARPLK  Bug 97780,Added a comment for VIEW3.
--  110129  NEKOLK  EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_SPARE_STRUCTURE,EQUIPMENT_SPARE_STRUC_DISTINCT.
--                  and included where clause for component_spare_contract too.
--  110221  SaFalk  EANE-4424, Modified Copy__ and Substitute_Part__ to use TABLE.
--  110429  NeKolk  EASTONE-16875, Modified Copy__ .Changed PART_OWNERSHIP to PART_OWNERSHIP_DB since data query Viev has changed to the Table by EANE-4424.
--  110514  LoPrlk  Issue: EASTONE-19610, Minor modifications on the block to create VIEW3.
--  110829  PRIKLK  SADEAGLE-1739, Replaced EQUIP_INV_PUR_PART view usages with the respective PUB views 
--  ------------------------------------------APPS 9 ------------------------------------------------
--  130621  heralk  Scalability Changes - removed global variables.
--  130605  KrRaLK  Bug 109632, Added Get_Number_Of_Parents().
--  130617  UMDILK  Bug 110664, Modified Unpack_Check_Update___().
--  130624  UMDILK  Bug 110664, Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Check_Exist_Object().
--  130816  Harplk  CONV-2232, Modified Unpack_Check_Insert___() and Unpack_Check_Update___().
--  131209  CLHASE  PBSA-1822, Refactored and splitted.
--  140225  japelk  PBSA-5003, fixed in method Copy__().
--  140813  HASTSE  Replaced dynamic code and cleanup.
--  151102  RUMELK  Merged Bug 124443, Modified copy, Check_Part_No__, Check_Insert___.
--  160113  LoPrlk  STRSA-423, Altered the method Copy__.
--  160602  DMalLK  STRSA-6096, Modified Validate_Comb___.
-----------------------------------------------------------------------------
--  180509  ISHHLK  SAUXXW4-9658,  Added method Get_Unit_Of_Measure
-----------------------------------------------------------------------------
layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist_Part_Str___ (
   spare_id_ IN VARCHAR2,
   spare_contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  spare_id = spare_id_
      AND    spare_contract = spare_contract_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist_Part_Str___;


PROCEDURE Validate_Comb___ (
   newrec_ IN EQUIPMENT_SPARE_STRUCTURE_TAB%ROWTYPE )
IS
   dummy_ NUMBER;
   desc_  VARCHAR2(200);
   
   outpar_           NUMBER := 0;
   
   CURSOR spare_id_control IS
      select 1 from dual
      where newrec_.component_spare_id  NOT IN
      (select SPARE_ID from Equipment_Spare_Structure
      connect by prior SPARE_ID = COMPONENT_SPARE_ID
      start with COMPONENT_SPARE_ID = newrec_.spare_id);
BEGIN
   OPEN spare_id_control;
   FETCH spare_id_control INTO dummy_;
   IF (spare_id_control%NOTFOUND) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTSAMESPAREID: Component Spare ID cannot be the same as Spare ID in previous levels.');
      CLOSE spare_id_control;
   END IF;
   CLOSE spare_id_control;

   IF (newrec_.spare_id IS NOT NULL) THEN
      IF (newrec_.component_spare_id IS NOT NULL) THEN
         IF (newrec_.spare_id = newrec_.component_spare_id) THEN
            Error_SYS.Appl_General(lu_name_, 'NOTSAMEPART: Component Spare ID cannot be the same as Spare ID.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.spare_id IS NOT NULL) THEN
      $IF Component_Invent_SYS.INSTALLED $THEN
         outpar_ := INVENTORY_PART_API.Part_Exist(newrec_.spare_contract, newrec_.spare_id);
         IF ( outpar_ = 1 ) THEN
            INVENTORY_PART_API.Exist(newrec_.spare_contract, newrec_.spare_id);
         END IF;
      $ELSE
         NULL;
      $END
      
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (outpar_ = 0 ) THEN
            Purchase_Part_API.Exist(newrec_.spare_contract, newrec_.spare_id);
         END IF;
      $ELSE
         NULL;
      $END
     
   END IF;

   IF (newrec_.component_spare_id IS NOT NULL) THEN
      IF (newrec_.component_spare_contract IS NOT NULL) THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            Maint_Material_Req_Line_API.Description_For_Part (newrec_.component_spare_id, newrec_.component_spare_contract, desc_);
         $ELSE
            desc_ := NULL;
         $END
         IF (desc_ IS NULL) THEN
            Error_SYS.Appl_General(lu_name_, 'NOTINVORPURPART: Part :P1 does not exist as Inventory Part or Purchase Part at site :P2.', newrec_.component_spare_id, newrec_.component_spare_contract);  
         END IF;
      END IF;
   END IF;
END Validate_Comb___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PART_OWNERSHIP', Part_Ownership_API.Decode('COMPANY OWNED'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_SPARE_STRUCTURE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT spare_seq.nextval
      INTO newrec_.spare_seq
      FROM dual;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_spare_structure_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy1_ VARCHAR2(2000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (indrec_.spare_contract) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.spare_contract);
   END IF;
   Check_Part_No__(dummy1_, dummy1_, dummy1_, dummy1_, newrec_.component_spare_id, newrec_.component_spare_contract); 
   IF (Transaction_SYS.Package_Is_Active('PLANT_OBJECT_API')) THEN
      IF (Check_Exist_Object(newrec_.spare_contract, newrec_.spare_id, newrec_.component_spare_id , newrec_.component_spare_contract, newrec_.drawing_no, newrec_.drawing_pos, newrec_.mch_part, newrec_.note, 'Insert', NULL) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_,'SPAREOBJECTEXIST: The spare part has been defined for this object. Two spare parts can have the same Spare Id as long as their Object Part, Drawing No, Drawing Position , or Note field information differs.');
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     equipment_spare_structure_tab%ROWTYPE,
   newrec_ IN OUT equipment_spare_structure_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Transaction_SYS.Package_Is_Active('PLANT_OBJECT_API')) THEN
      IF (indrec_.component_spare_id OR indrec_.drawing_no OR indrec_.drawing_pos OR indrec_.mch_part OR indrec_.note OR indrec_.component_spare_contract) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.spare_seq, newrec_.spare_contract, newrec_.spare_id, newrec_.component_spare_id, newrec_.component_spare_contract);
         IF (Check_Exist_Object(newrec_.spare_contract, newrec_.spare_id, newrec_.component_spare_id , newrec_.component_spare_contract, newrec_.drawing_no, newrec_.drawing_pos, newrec_.mch_part, newrec_.note, 'Update', objid_) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_,'SPAREOBJECTEXIST: The spare part has been defined for this object. Two spare parts can have the same Spare Id as long as their Object Part, Drawing No, Drawing Position , or Note field information differs.');
         END IF;
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_spare_structure_tab%ROWTYPE,
   newrec_ IN OUT equipment_spare_structure_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   is_inventory_part_ NUMBER;
   dummy_             VARCHAR2(5);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.qty < 0) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTNEGQTY: Quantity cannot be less than 0.');
   END IF;
   
   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.component_spare_id) = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'CONDNOTALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      END IF;
   END IF;
   
   IF (newrec_.part_ownership IS NOT NULL) THEN
      IF (newrec_.part_ownership NOT IN ('CUSTOMER OWNED', 'COMPANY OWNED','SUPPLIER RENTED','COMPANY RENTAL ASSET')) THEN
         Error_SYS.Appl_General(lu_name_, 'MATLINEWRONGOWNERSHIP: Ownership type :P1 is not allowed in Materials for Work Orders', newrec_.part_ownership);
      END IF;
   ELSE
      IF (newrec_.owner IS NOT NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'NOVALOWNER1: Owner cannot have a value when there is no Ownership type');
      END IF;
   END IF;
   
   IF (newrec_.owner IS NOT NULL) THEN
      IF (newrec_.part_ownership = 'CUSTOMER OWNED') THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Cust_Ord_Customer_API.Exist(newrec_.owner);
         $ELSE
            Error_SYS.Record_General(lu_name_, 'BLOCKCUSTOMER: A Customer may not be specified as Owner when Customer Orders is not installed.');
         $END
      END IF;
      IF (newrec_.part_ownership = 'COMPANY OWNED') THEN
         Error_SYS.Record_General(lu_name_, 'BLOCKOWNER: Owner should not be specified for :P1 Stock.', Part_Ownership_API.Decode(newrec_.part_ownership) );
      END IF;
      IF (newrec_.part_ownership IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOOWNERNEEDED: Owner can only be specified for :P1 stock.', Part_Ownership_API.Get_Client_Value(2));
      END IF;
   ELSE
      IF (newrec_.part_ownership = 'CUSTOMER OWNED') THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDOWNER: Owner should be specified for :P1 stock.', Part_Ownership_API.Decode(newrec_.part_ownership));
      END IF;
   END IF;
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (Validate_SYS.Is_Changed(oldrec_.component_spare_id, newrec_.component_spare_id)) THEN
         Purchase_Part_API.Check_External_Resource(newrec_.spare_contract, newrec_.component_spare_id);
      END IF;
   $END   
   
   $IF Component_Invent_SYS.INSTALLED $THEN
      is_inventory_part_ := Inventory_Part_API.Part_Exist(newrec_.component_spare_contract, newrec_.component_spare_id);
   $ELSE
      NULL;
   $END
   
   $IF Component_Wo_SYS.INSTALLED $THEN
      dummy_ := MAINT_MATERIAL_REQ_LINE_API.Check_Part_Status_Demand_Flag(newrec_.component_spare_id, newrec_.component_spare_contract);
   $ELSE
      NULL;
   $END

   IF (newrec_.part_ownership IS NULL) THEN
      newrec_.part_ownership := PART_OWNERSHIP_API.Get_Db_Value(0);
   END IF;
   
   Validate_Comb___(newrec_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   source_spare_id_      IN VARCHAR2,
   source_contract_      IN VARCHAR2,
   destination_spare_id_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2 )
IS
   newrec_  EQUIPMENT_SPARE_STRUCTURE_TAB%ROWTYPE;
   
   CURSOR source IS
      SELECT  DISTINCT
              CASE LEVEL
                   WHEN 1 THEN destination_spare_id_
                   ELSE        spare_id
              END spare_id,
              component_spare_id, qty, drawing_no, drawing_pos, mch_part, note, condition_code, 
              part_ownership, owner, allow_detached_wo_mat_site
      FROM    equipment_spare_structure_tab
      START   WITH spare_contract = source_contract_
              AND  spare_id       = source_spare_id_
      CONNECT BY   spare_contract = PRIOR component_spare_contract
              AND  spare_id       = PRIOR component_spare_id
      MINUS
      SELECT spare_id, component_spare_id, qty, drawing_no, drawing_pos, mch_part, note, condition_code,
             part_ownership, owner, allow_detached_wo_mat_site
      FROM   equipment_spare_structure_tab
      WHERE  spare_contract           = destination_contract_
      AND    component_spare_contract = destination_contract_;
BEGIN
   IF NOT Check_Exist_Part_Str___(source_spare_id_, source_contract_) THEN
      Error_SYS.Record_General('EquipmentSpareStructure', 'NO_SUCH_SOURCE: The source detached part list does not exist.');
   END IF;
   
   IF Check_Exist_Part_Str___(destination_spare_id_, destination_contract_) THEN
      Error_SYS.Record_General('EquipmentSpareStructure', 'DESTINATION_EXIST: The destination detached part list already exist.');
   END IF;
   
   FOR rec IN source LOOP
      newrec_ := NULL;
      newrec_.spare_contract              := destination_contract_;
      newrec_.spare_id                    := rec.spare_id;
      newrec_.component_spare_contract    := destination_contract_;
      newrec_.component_spare_id          := rec.component_spare_id;
      newrec_.qty                         := rec.qty;
      newrec_.drawing_no                  := rec.drawing_no;
      newrec_.drawing_pos                 := rec.drawing_pos;
      newrec_.mch_part                    := rec.mch_part;
      newrec_.note                        := rec.note;
      newrec_.part_ownership              := rec.part_ownership;
      newrec_.condition_code              := rec.condition_code;
      newrec_.owner                       := rec.owner;
      newrec_.allow_detached_wo_mat_site  := rec.allow_detached_wo_mat_site;
      New___(newrec_);
   END LOOP;      
END Copy__;


PROCEDURE Substitute_Part__ (
   spare_id_     IN VARCHAR2,
   spare_contract_     IN VARCHAR2,
   new_spare_id_ IN VARCHAR2 )
IS
   CURSOR part IS
      SELECT *
      FROM EQUIPMENT_SPARE_STRUCTURE_TAB t
      WHERE (component_spare_id = spare_id_)
      AND   (spare_contract = spare_contract_);

   newrec_  EQUIPMENT_SPARE_STRUCTURE_TAB%ROWTYPE;
BEGIN
   FOR instance IN part LOOP
      newrec_ := Get_Object_By_Keys___(instance.spare_seq, instance.spare_contract, instance.spare_id, instance.component_spare_id, instance.component_spare_contract);
      newrec_.component_spare_id := new_spare_id_;
      Modify___(newrec_);
   END LOOP;
END Substitute_Part__;


PROCEDURE Check_Part_No__ (
   msg_text_    OUT VARCHAR2,
   description_ IN OUT VARCHAR2,
   supply_code_ IN OUT VARCHAR2,
   unit_meas_   IN OUT VARCHAR2,
   part_no_     IN VARCHAR2,
   contract_    IN VARCHAR2 )
IS
   new_unit_meas_    VARCHAR2(10);
   supplier_         VARCHAR2(20);
   is_part_in_site_  NUMBER; 

   $IF Component_Invent_SYS.INSTALLED $THEN
      part_status_    VARCHAR2(60);
      part_rec_       Inventory_Part_API.public_rec;
      supply_code_db_ Inventory_Part.supply_code_db%TYPE;
   $END
   
BEGIN
   msg_text_ := NULL;
   $IF Component_Invent_SYS.INSTALLED $THEN

      $IF Component_Purch_SYS.INSTALLED $THEN
         supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
      $ELSE
         supplier_ := NULL;
      $END
         
      IF (Inventory_Part_API.Check_Stored(contract_, part_no_)) THEN
         part_status_ := Inventory_Part_API.Get_Part_Status(contract_, part_no_);
         IF (Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(part_status_) = Inventory_Part_Demand_Flag_API.DB_DEMANDS_NOT_ALLOWED ) THEN
            Error_SYS.Record_General('EquipmentSpareStructure', 'NOTDEMAND: Inventory part :P1 has part status :P2 which does not allow demands',
                                     part_no_,
                                     Inventory_Part_Status_Par_API.Get_Description(part_status_));
         END IF;
         part_rec_       := Inventory_Part_API.Get(contract_, part_no_);
         description_    := Inventory_Part_API.Get_Description(contract_, part_no_);
         new_unit_meas_  := part_rec_.unit_meas;
         supply_code_db_ := part_rec_.supply_code;

      ELSE
         $IF Component_Purch_SYS.INSTALLED $THEN

            is_part_in_site_ := Purchase_Part_API.Check_Exist(contract_, part_no_); 
            IF (is_part_in_site_ = 0) THEN
               Error_SYS.Record_General('EquipmentSpareStructure', 'NO_PART_EXIST: Part :P1 at Site :P2 does not exist.',part_no_,contract_);
            END IF;

            IF (supplier_ IS NULL) THEN
               new_unit_meas_ := Purchase_Part_API.Get_Default_Buy_Unit_Meas(contract_, part_no_);
            ELSE
               new_unit_meas_ := Purchase_Part_Supplier_API.Get_buy_unit_meas(contract_, part_no_, supplier_);
            END IF;

            supply_code_db_ := Material_Requis_Supply_API.DB_PURCHASE_ORDER;

         $ELSE
            Error_SYS.Record_General('EquipmentSpareStructure', 'NO_PURPART_LU: The module IFS/Purchase is not installed. Only inventory parts can be registered');
         $END

      END IF;
      
      supply_code_ := Material_Requis_Supply_API.Decode( supply_code_db_ );
      
      IF (supplier_ IS NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'NO_SUPPLIER: The part :P1 is not connected to a supplier', part_no_);
         msg_text_ := Client_SYS.Get_All_Info;
      END IF;
   
   $ELSE
      NULL;
   $END
   
   unit_meas_ := NVL(new_unit_meas_, unit_meas_);
END Check_Part_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Component_Spare_Contract (
   spare_seq_ IN NUMBER,
   spare_contract_ IN VARCHAR2,
   spare_id_ IN VARCHAR2,
   component_spare_id_ IN VARCHAR2,
   component_spare_contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_SPARE_STRUCTURE_TAB.component_spare_contract%TYPE;
   CURSOR get_attr IS
      SELECT component_spare_contract
      FROM EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE spare_seq = spare_seq_
      AND   spare_contract = spare_contract_
      AND   spare_id = spare_id_
      AND   component_spare_id = component_spare_id_
      AND   component_spare_contract = component_spare_contract_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Component_Spare_Contract;


@UncheckedAccess
FUNCTION Get_Component_Spare_Id (
   spare_seq_ IN NUMBER,
   spare_contract_ IN VARCHAR2,
   spare_id_ IN VARCHAR2,
   component_spare_id_ IN VARCHAR2,
   component_spare_contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_SPARE_STRUCTURE_TAB.component_spare_id%TYPE;
CURSOR get_attr IS
   SELECT component_spare_id
   FROM EQUIPMENT_SPARE_STRUCTURE_TAB
   WHERE spare_seq = spare_seq_
   AND   spare_contract = spare_contract_
   AND spare_id = spare_id_
   AND component_spare_id = component_spare_id_
   AND component_spare_contract = component_spare_contract_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Component_Spare_Id;


@UncheckedAccess
FUNCTION Has_Spare_Structure (
   spare_id_ IN VARCHAR2,
   spare_contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR partstr IS
      SELECT 1
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  spare_id  = spare_id_
      AND    spare_contract = spare_contract_;
BEGIN
   OPEN partstr;
   FETCH partstr INTO dummy_;
   IF partstr%NOTFOUND THEN
      CLOSE partstr;
      RETURN 'FALSE';
   END IF;
   CLOSE partstr;
   RETURN 'TRUE';
END Has_Spare_Structure;


@UncheckedAccess
FUNCTION Has_Spare_Structure_Boolean (
   spare_id_ IN VARCHAR2,
   spare_contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Translate_Boolean_API.Decode(Has_Spare_Structure(spare_id_, spare_contract_));
END Has_Spare_Structure_Boolean;


@UncheckedAccess
FUNCTION Has_Spare_Struc_For_Site (
   spare_contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR partstr IS
      SELECT 1
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  spare_contract = spare_contract_; 
BEGIN
   OPEN partstr;
   FETCH partstr INTO dummy_;
   IF partstr%NOTFOUND THEN
      CLOSE partstr;
      RETURN 'FALSE';
   END IF;
   CLOSE partstr;
   RETURN 'TRUE';
END Has_Spare_Struc_For_Site;

@UncheckedAccess
PROCEDURE Get_Parent (
   parent_spare_id_ OUT VARCHAR2,
   parent_spare_contract_ OUT VARCHAR2,
   spare_id_ IN VARCHAR2,
   spare_contract_ IN VARCHAR2 )
IS
   CURSOR partstr IS
      SELECT spare_id, spare_contract
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  component_spare_id  = spare_id_
      AND    spare_contract = spare_contract_;
BEGIN
   OPEN partstr;
   FETCH partstr INTO parent_spare_id_, parent_spare_contract_;
   CLOSE partstr;
END Get_Parent;


PROCEDURE Has_Parent (
   rcode_    OUT VARCHAR2,
   spare_id_ IN  VARCHAR2,
   spare_contract_ IN  VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR partstr IS
      SELECT 1
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  component_spare_id  = spare_id_
      AND    spare_contract = spare_contract_;
BEGIN
   OPEN partstr;
   FETCH partstr INTO dummy_;
   CLOSE partstr;
   IF (dummy_ = 1) THEN
      rcode_ := 'TRUE';
   ELSE
      rcode_ := 'FALSE';
   END IF;
END Has_Parent;


@UncheckedAccess
FUNCTION Get_Objid (
   spare_contract_ IN VARCHAR2,
   spare_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_instance IS
      SELECT *
      FROM   EQUIPMENT_SPARE_STRUC_DISTINCT
      WHERE  spare_id  = spare_id_
      AND    spare_contract = spare_contract_;
BEGIN
   FOR instance IN get_instance LOOP
      RETURN instance.objid;
   END LOOP;
END Get_Objid;


@UncheckedAccess
FUNCTION Exist_Comp_Part_Str (
   component_spare_contract_ IN VARCHAR2,
   component_spare_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE  component_spare_id = component_spare_id_
      AND    component_spare_contract = component_spare_contract_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Exist_Comp_Part_Str;

FUNCTION Get_Invent_Purch_Part_Objid (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_         VARCHAR2(31);
BEGIN
   temp_ := NULL;
                 
   $IF Component_Invent_SYS.INSTALLED $THEN
      IF ( Inventory_Part_Api.Exists(contract_, part_no_) AND Inventory_Part_Api.Get_Type_Code_Db(contract_, part_no_) = Inventory_Part_Type_API.DB_MANUFACTURED ) THEN
         temp_ := contract_ || '^' || part_no_;
      ELSE
         $IF Component_Purch_SYS.INSTALLED $THEN
            IF Purchase_Part_Api.Exists(contract_, part_no_) THEN
               temp_ := contract_ || '^' || part_no_;
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
   $ELSE
      NULL;
   $END
   RETURN temp_;
END Get_Invent_Purch_Part_Objid;

@UncheckedAccess
FUNCTION Get_Number_Of_Parents (
   spare_id_ IN VARCHAR2,
   spare_contract_ IN VARCHAR2) RETURN NUMBER
IS
   counter_ NUMBER;
   CURSOR count_parents IS
     SELECT COUNT(*)
       FROM (SELECT spare_id, spare_contract
               FROM EQUIPMENT_SPARE_STRUCTURE_TAB
              WHERE component_spare_id = spare_id_
                AND spare_contract = spare_contract_
              GROUP BY spare_id, spare_contract);
BEGIN
   OPEN count_parents;
   FETCH count_parents INTO counter_;
   IF (count_parents%FOUND) THEN
      CLOSE count_parents;
      RETURN(counter_);
   ELSE
      CLOSE count_parents;
      RETURN 0;
   END IF;
END Get_Number_Of_Parents;


@UncheckedAccess
FUNCTION Check_Exist_Object (
   spare_contract_ IN VARCHAR2,
   spare_id_ IN VARCHAR2,
   component_spare_id_ IN VARCHAR2,
   component_spare_contract_ IN VARCHAR2,
   drawing_no_ IN VARCHAR2,
   drawing_pos_ IN VARCHAR2,
   mch_part_ IN VARCHAR2,
   note_ IN VARCHAR2,
   method_from_ IN VARCHAR2,
   objid_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   s_return_   VARCHAR2(10);

   CURSOR get_spare_object IS
      SELECT drawing_no,drawing_pos,mch_part,note
      FROM  EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE spare_contract = spare_contract_
      AND spare_id = spare_id_
      AND component_spare_id = component_spare_id_
      AND component_spare_contract = component_spare_contract_;
   
   CURSOR get_spare_object_for_update IS
      SELECT drawing_no,drawing_pos,mch_part,note
      FROM  EQUIPMENT_SPARE_STRUCTURE_TAB
      WHERE spare_contract = spare_contract_
      AND spare_id = spare_id_
      AND component_spare_id = component_spare_id_
      AND component_spare_contract = component_spare_contract_
      AND NOT rowid = objid_;
BEGIN
   s_return_ := 'FALSE';
   
   IF method_from_ = 'Update' THEN
      FOR rec_ IN get_spare_object_for_update LOOP
          --This check has to be done because these fields are not keys.
          --Have to compare with a value which wouldn't be usually entered by a user. Hopefully no one will enter 'NULL9753124680'.
          IF (nvl(rec_.drawing_no,'NULL9753124680') = nvl(drawing_no_,'NULL9753124680') AND nvl(rec_.drawing_pos,'NULL9753124680') = nvl(drawing_pos_,'NULL9753124680') AND nvl(rec_.mch_part,'NULL9753124680') = nvl(mch_part_,'NULL9753124680') AND nvl(rec_.note,'NULL9753124680') = nvl(note_,'NULL9753124680')) THEN
             s_return_ := 'TRUE';
             EXIT;
          END IF;
      END LOOP;
   ELSE
      FOR rec_ IN get_spare_object LOOP
          --This check has to be done because these fields are not keys.
          --Have to compare with a value which wouldn't be usually entered by a user. Hopefully no one will enter 'NULL9753124680'.
          IF (nvl(rec_.drawing_no,'NULL9753124680') = nvl(drawing_no_,'NULL9753124680') AND nvl(rec_.drawing_pos,'NULL9753124680') = nvl(drawing_pos_,'NULL9753124680') AND nvl(rec_.mch_part,'NULL9753124680') = nvl(mch_part_,'NULL9753124680') AND nvl(rec_.note,'NULL9753124680') = nvl(note_,'NULL9753124680')) THEN
             s_return_ := 'TRUE';
             EXIT;
          END IF;
      END LOOP;
  END IF;
  RETURN s_return_;
END Check_Exist_Object;

FUNCTION Get_Unit_Of_Measure (
   unit_meas_   IN VARCHAR2,
   part_no_     IN VARCHAR2,
   contract_    IN VARCHAR2 ) RETURN VARCHAR2
IS
      new_unit_meas_    VARCHAR2(10);
      out_unit_meas_    VARCHAR2(20);
      supplier_         VARCHAR2(20);
      is_part_in_site_  NUMBER; 
   
      $IF Component_Invent_SYS.INSTALLED $THEN
         part_rec_       Inventory_Part_API.public_rec;
      $END    
   BEGIN  
       $IF Component_Invent_SYS.INSTALLED $THEN
       
         $IF Component_Purch_SYS.INSTALLED $THEN
            supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
         $ELSE
            supplier_ := NULL;
         $END        
         IF (Inventory_Part_API.Check_Stored(contract_, part_no_)) THEN
            part_rec_       := Inventory_Part_API.Get(contract_, part_no_);
            new_unit_meas_  := part_rec_.unit_meas;
         ELSE
            $IF Component_Purch_SYS.INSTALLED $THEN
               is_part_in_site_ := Purchase_Part_API.Check_Exist(contract_, part_no_); 
               IF (is_part_in_site_ = 0) THEN
                  Error_SYS.Record_General('EquipmentSpareStructure', 'NO_PART_EXIST: Part :P1 at Site :P2 does not exist.',part_no_,contract_);
               END IF;
               IF (supplier_ IS NULL) THEN
                  new_unit_meas_ := Purchase_Part_API.Get_Default_Buy_Unit_Meas(contract_, part_no_);
               ELSE
                  new_unit_meas_ := Purchase_Part_Supplier_API.Get_buy_unit_meas(contract_, part_no_, supplier_);
               END IF;              
            $ELSE
               Error_SYS.Record_General('EquipmentSpareStructure', 'NO_PURPART_LU: The module IFS/Purchase is not installed. Only inventory parts can be registered');
            $END
         END IF;    
      $ELSE
         NULL;
      $END
      out_unit_meas_ := NVL(new_unit_meas_, unit_meas_);
       
      RETURN out_unit_meas_;

   END Get_Unit_Of_Measure;