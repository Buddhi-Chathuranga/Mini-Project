-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectSpare
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960930  TOWI  Recreated from Rose model using Developer's Workbench.
--  961007  ADBR  Changed reference from Maintenance_Part to Maintenance_Spare.
--  961006  TOWI  Generated from Rose-model using Developer's Workbench 1.2.2.
--  961108  ADBR  Changed reference on Spare ID.
--  961121  CAJO  Changed direct Update-statement to Modify__ call in
--                procedure Substitute_Part__.
--  961219  ADBR  Merged with new templates.
--  970108  NILA  Modified procedures Substitute_Part and Substitute_Part__.
--                Changed procedure Unpack_Check_Update__ to allow update of
--                attribute SPARE_ID. This is only used by Substitute_Part__.
--                Changed call to PM_ACTION_SPARE_PART_API.Substitute_Part__
--                to be dynamic.
--  970120  ADBR  Moved spare exist control out of the loop in Unpack_Ckeck_Insert.
--  970402  TOWI  Adjusted to new templates in Foundation 1.2.2c.
--  970409  TOWI  97-0013 Spare_Id is changed to be updateable.
--  970806  ERJA  Ref 97-0047, Changed ref name on spare_id to PurchasePart
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_spare_tab.
--  970923  ERJA  Changed ms_mch_spare_seq to equipment_object_spare_seq
--  971001  STSU  Added methods Check_Exist and Create_Spare_Part
--  971105  MNYS  Changed contract to spare_contract.
--  971119  HAST  Added contract as suplementary key to mch_code.
--  980109  ERJA  Changed exist control on purchase part to be dynamic
--  980213  TOWI  Removed double check on spare part exist. Corrected from contract to
--                spare contract when checkinh spare part. No Check_Not_Null on mch_spare_seq when insert.
--  980218  ERJA  Changed MCH_SPARE to SPARE_ID in Create_Spare_Part
--  980303  ERJA  Added PROCEDURE Remove_Obj_Spare.
--  980408  CLCA  Added check newrec_.qty in Unpack_Check_Insert.
--  980419  MNYS  Support Id: 4149. Added defaultvalue to spare_contract in Prepare_Insert___.
--  980408  CLCA  Added check newrec_.qty in Unpack_Check_Insert.
--  980423  CAJO  Changed Get_App_Owner to Get_Fnd_User.
--  980423  CLCA  Added check newrec_.qty>0 in Unpack_Check_Insert and Unpack_Check_Update.
--  980427  CAJO  Removed default value on contract in prepare_insert.
--  990113  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206)
--  990131  ANCE  Set data type to 'NUMBER' without any fixed number of  characters for quantities.
--  990920  ERRA  Added procedure Exist for integration with Plant Design.
--  991227  ANCE  Changed template due to performance improvement.
--  000425  JIJO  Substitute_Part change part in standard job also.
--  OO0818 PJONSE Call Id: 39169. Removed dynamic call for Purchase_Part_API.Exist and added dynamic call for Purchase_Part_API.Check_Exist
--                and Inventory_Part_API.Part_Exist in Unpack_Check_Update and Unpack_Check_Insert.
--  001204  MIBO  Added Procedure Check_Configurable_Change.
--  010426  SISALK Fixed General_SYS.Init_Method in Check_Configurable_Change, Remove_Obj_Spare.
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604  CHAMLK Modified the length of the MCH_CODE in view EQUIPMENT_OBJECT_SPARE
--  030725  NUPELK Added public methods New and Modify ( Request from Plant Design )
--  230304  DIMALK Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package body.
--  251104  NAMELK LCS Bug merged Bug Id: 47183.
--  211204  NAMELK Changed Check_Exist_Object function to a public function.
--  050929  GIRALK Bug Id 53353 moified view EQUIPMENT_OBJECT_SPARE,Unpack_Check_Insert___,Unpack_Check_Update___.
--                 Added Get_Part_Ownership and Get_Owner 
--  051006  NIJALK Merged bug 53353. 
-----------------------------------------------------------------------------
--  060706  AMDILK MEBR1200: Enlarge Identity - Changed Customer Id length from 10 to 20
--  061215  NAMELK HINKS Task 38283: Modified Create_Spare_Part & Check_Exist.
--  061114  SHAFLK Bug 61446, Introduced handling of 'SUPPLIER LOANED' stock. 
--  070301  ILSOLK Merged Bug ID 61446.
--  070724  IMGULK Added Assert_SYS Assertions.
--  071129  ASSALK Bug 68183 modified Modify() function. 
--  071213  SHAFLK Bug 69824, Modified Unpack_Check_Insert___,Unpack_Check_Update___.
--  101021  NIFRSE Bug 93384, Updated view column prompts to 'Object Site'.
--  -------------------------Project Eagle-----------------------------------
--  110420  GAHALK Bug 96506, Modified Unpack_Check_Insert___() and Unpack_Check_Update___().
--  110622  SHAFLK Bug 97402, Added Substitute_Part_Via_Job() and Substitute_Part_Via_Job_Back(). 
--  091019  LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106  SaFalk IID - ME310: Removed bug comment tags.
--  091207  LIAMLK Changed the key flag to 'P' in VIEW.mch_code (EAST-1280).
--  110129  NEKOLK EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_OBJECT_SPARE.
--  110221  SaFalk EANE-4424, Added new view EQUIPMENT_OBJECT_SPARE_SDV without user_allowed_site filter to be used in Search Domains.
--  120329  KANILK Bug 101826, Modified Prepare_Insert___ method.
--  120925  KrRaLK Bug 105633, Added new column ALLOW_WO_MAT_SITE to base view, modified insert update methods.
--  --------------------------- APPS 9 --------------------------------------
--  130619  heralk  Scalability Changes - removed global variables.
--  130816  Harplk CONV-2232, Modified Unpack_Check_Insert___() and Unpack_Check_Update___().
--  130624  UMDILK  Bug 110664, Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Check_Exist_Object().
--  130806  GaYWLK Bug 111447, Modified methods Unpack_Check_Update___(), Unpack_Check_Insert___().
--  130812  GaYWLK Bug 111447, Modified methods Unpack_Check_Update___(), Unpack_Check_Insert___().
--  131002  MAZPSE Bug 112819, Modified Check_Exist_Object(), modified last two parameters to default null. This caused an issue in Asset Design
--                             where a design object with additional parts could not be set to completed
--  131206  MAWILK  PBSA-1817, Hooks: refactoring and splitting.
--  131217  HASTSE  PBSA-3305, Fix of review findings. Removed Validat_Comb___
--  140219  BHKALK  PBSA-4961, Modified Check_Common___.
--  140225  BHKALK  PBSA-4967, Modified Copy().
--  140226  HERALK  PBSA-3591,  LCS Patch merge - 114427.
--  131218  HARULK Bug 114427, Modified Prepare_Insert___(). 
--  140303  HASTSE PBSA-5582, Fixed annotation problem.
--  140505  HASTSE PBSA-6615, Replaced call to Maintenance_Spare_Api
--  140804  HASTSE PRSA-2088, fixed unused declarations
--  140813  HASTSE Replaced dynamic code and cleanup
--  --------------------------- APPS 10 --------------------------------------
--  161003  SEROLK  STRSA-10473, Modified Substitute_Part().
--  170724  CLEKLK  STRSA-26786, Merged bug 135857, Modified constants to distinguish different messages.
--  171212  LoPrlk  STRSA-29376, Added the method Get_Description.
-----------------------------------------------------------------------------
--  180828  ISHHLK  SAUXXW4-1301, Added the method Get_Condition_Code.
--  180903  ISHHLK  SAUXXW4-1301, Added the method Get_Unit_Of_Measure.
--  180903  ISHHLK  SAUXXW4-1301, Added the method Get_Part_Type. 
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------
layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Seq___ RETURN NUMBER
IS
   CURSOR mch_spare_seq IS
      SELECT equipment_object_spare_seq.nextval
      FROM dual;
   next_row_   NUMBER;
BEGIN
   OPEN mch_spare_seq;
   FETCH mch_spare_seq INTO next_row_;
   CLOSE mch_spare_seq;
   RETURN next_row_;
END Get_Next_Seq___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_    equipment_object_tab.Contract%TYPE;
BEGIN
   super(attr_);
   contract_  := User_Default_API.Get_Contract;
   Client_SYS.Add_To_Attr( 'SPARE_CONTRACT', contract_, attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_SPARE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Next sequence number for column MCH_SPARE_SEQ is fetched
   newrec_.mch_spare_seq := Get_Next_Seq___;
   Client_SYS.Add_To_Attr( 'MCH_SPARE_SEQ', newrec_.mch_spare_seq, attr_ );
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_spare_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.spare_contract IS NULL THEN
      newrec_.spare_contract := User_Default_API.Get_Contract();
   END IF;
   indrec_.mch_spare_seq := FALSE;   
   indrec_.spare_id := FALSE;
   indrec_.owner := FALSE;
   indrec_.condition_code := FALSE;
   indrec_.equipment_object_seq := FALSE;
   
   super(newrec_, indrec_, attr_);
      
   IF (Check_Exist_Object (Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.equipment_object_seq), newrec_.spare_id , newrec_.spare_contract, newrec_.drawing_no, newrec_.drawing_pos, newrec_.mch_part, newrec_.note, 'Insert', NULL) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_,'SPAREOBJECTEXIST: The spare part has been defined for this object. Two spare parts can have the same Spare Id as long as their Object Part, Drawing No, Drawing Position, or Note field information differs.');
   END IF;

END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_spare_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_spare_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   is_inventory_part_ NUMBER;
   dummy1_            VARCHAR2(5); 

BEGIN
   IF (newrec_.part_ownership IS NULL) THEN
      newrec_.part_ownership := PART_OWNERSHIP_API.Get_Db_Value(0);
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.spare_contract);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
   IF newrec_.qty = 0 THEN
      Error_SYS.Appl_General(lu_name_, 'QTYNOTNULL: Quantity cannot have the numerical value 0.');
   END IF;

-- Check of combination of spare_id and object part is correct.
   IF (newrec_.mch_part IS NULL AND (newrec_.spare_id IS NULL OR newrec_.spare_contract IS NULL)) THEN
      Error_SYS.Appl_General(lu_name_, 'ENTERDATA: Object part or spare part must be entered.');
   END IF;

   IF (newrec_.qty<0) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTNEG: Quantity cannot be less than 0.');
   END IF;
   
   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.spare_id) = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      ELSE
         Condition_Code_API.Exist(newrec_.condition_code);
      END IF;
   END IF;

   IF (newrec_.spare_id IS NOT NULL) THEN
      Check_Spare_Id_Ref___(newrec_);
      
      $IF Component_Invent_SYS.INSTALLED $THEN   
         is_inventory_part_ := Inventory_Part_API.Part_Exist(newrec_.spare_contract, newrec_.spare_id);
      $END   
      IF (is_inventory_part_ = 1) THEN
      --MAINT_MATERIAL_REQ_LINE_API.Check_Part_Status_Demand_Flag will raise the error msg.   
      --Since it's a function, 'dummy_' variable is used to hold the return value of that function.
         $IF Component_Wo_SYS.INSTALLED $THEN   
            dummy1_ := MAINT_MATERIAL_REQ_LINE_API.Check_Part_Status_Demand_Flag(newrec_.spare_contract, newrec_.spare_id);
         $ELSE
            NULL;
         $END   
      END IF;
   END IF;

   IF (newrec_.part_ownership IS NOT NULL) THEN
      IF (newrec_.part_ownership NOT IN ('CUSTOMER OWNED', 'COMPANY OWNED','SUPPLIER LOANED','SUPPLIER RENTED','COMPANY RENTAL ASSET')) THEN
         Error_SYS.Appl_General(lu_name_, 'MATLINEWRONGOWNERSHIP: Ownership type :P1 is not allowed in Materials for Work Orders', Part_Ownership_API.Decode(newrec_.part_ownership));
      END IF;
   END IF;

   IF (newrec_.owner IS NOT NULL) THEN
      IF (newrec_.part_ownership = 'CUSTOMER OWNED') THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Cust_Ord_Customer_API.Exist(newrec_.owner);
         $ELSE
            Error_SYS.Record_General(lu_name_, 'BLOCKCUSTOMER: A Customer may not be specified as Owner when Customer Orders is not installed.');
         $END
      ELSIF (newrec_.part_ownership = 'SUPPLIER LOANED') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
             Purchase_Part_Supplier_API.Exist(newrec_.spare_contract, newrec_.spare_id, newrec_.owner);   
         $ELSE
             Error_SYS.Record_General(lu_name_, 'BLOCKSUPPLIER: A Supplier may not be specified as Owner when Purchasing is not installed.');        
         $END
      ELSIF (newrec_.part_ownership = 'COMPANY OWNED') THEN
         Error_SYS.Record_General(lu_name_, 'BLOCKOWNER: Owner should not be specified for :P1 Stock.', Part_Ownership_API.Decode(newrec_.part_ownership) );
      END IF;
   ELSE
      IF (newrec_.part_ownership IN ( 'CUSTOMER OWNED', 'SUPPLIER LOANED')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDOWNER: Owner should be specified for :P1 stock.', Part_Ownership_API.Decode(newrec_.part_ownership));
      END IF;
   END IF;
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (Validate_SYS.Is_Changed(oldrec_.spare_id, newrec_.spare_id)) THEN
         Purchase_Part_API.Check_External_Resource(newrec_.spare_contract, newrec_.spare_id);
      END IF;
   $END   
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     equipment_object_spare_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_spare_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS

   objid_      EQUIPMENT_OBJECT_SPARE.objid%TYPE;
   objversion_ EQUIPMENT_OBJECT_SPARE.objversion%TYPE;
   
BEGIN
   indrec_.spare_id := FALSE;
   indrec_.owner := FALSE;
   indrec_.condition_code := FALSE;
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.note OR indrec_.mch_part OR indrec_.drawing_no OR indrec_.drawing_pos) THEN
      IF (Check_Exist_Object (Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq), Equipment_Object_API.Get_Mch_Code(newrec_.equipment_object_seq), newrec_.spare_id , newrec_.spare_contract, newrec_.drawing_no, newrec_.drawing_pos, newrec_.mch_part, newrec_.note, 'Update', objid_) = 'TRUE') THEN
         Get_Id_Version_By_Keys___(objid_,objversion_,newrec_.mch_spare_seq,newrec_.contract);
         Error_SYS.Record_General(lu_name_,'SPAREOBJECTEXIST: The spare part has been defined for this object. Two spare parts can have the same Spare Id as long as their Object Part, Drawing No, Drawing Position, or Note field information differs.');
      END IF;
   END IF;
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (Validate_SYS.Is_Changed(oldrec_.spare_id, newrec_.spare_id)) THEN
         Purchase_Part_API.Check_External_Resource(newrec_.spare_contract, newrec_.spare_id);
      END IF;
   $END
END Check_Update___;

-- Check_Spare_Id_Ref___
--   Perform validation on the SpareIdRef reference.
PROCEDURE Check_Spare_Id_Ref___ (
   newrec_ IN OUT equipment_object_spare_tab%ROWTYPE)
IS 
   part_exist_        NUMBER;
   purchflag_         NUMBER;
BEGIN
   IF (newrec_.spare_id IS NOT NULL) THEN      
      part_exist_  := 1;
      purchflag_   := 1;

      $IF Component_Invent_SYS.INSTALLED $THEN   
         part_exist_ := Inventory_Part_API.Part_Exist(newrec_.spare_contract, newrec_.spare_id);
      $END

      $IF Component_Purch_SYS.INSTALLED $THEN   
          purchflag_ := Purchase_Part_API.Check_Exist(newrec_.spare_contract, newrec_.spare_id);
      $END

      IF ((part_exist_ = 0) AND (purchflag_ = 0)) THEN
         Error_SYS.Appl_General(lu_name_, 'OBJNOINVNOPUPART: The part :P1 is not an inventory or a purchase part and cannot be planned', newrec_.spare_id);
      END IF;
   END IF;
END Check_Spare_Id_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Substitute_Part__ (
   spare_id_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   new_spare_id_   IN VARCHAR2 )
IS
   CURSOR part IS
      SELECT mch_spare_seq, contract
      FROM  EQUIPMENT_OBJECT_SPARE_TAB t
      WHERE  (spare_id = spare_id_)
         AND (spare_contract = spare_contract_);

   newrec_  equipment_object_spare_tab%ROWTYPE;
BEGIN
   FOR instance IN part LOOP
      newrec_ := Get_Object_By_Keys___(instance.mch_spare_seq, instance.contract);
      newrec_.spare_id := new_spare_id_;
      Modify___(newrec_);
   END LOOP;
END Substitute_Part__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   info_       OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   objid_      varchar2(100);
   objversion_ varchar2(2000);
BEGIN
   New__(info_,objid_,objversion_,attr_,action_);
END New;


PROCEDURE Modify (
   info_       OUT    VARCHAR2,
   mch_spare_seq_ IN NUMBER,
   contract_   IN VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   objid_     varchar2(100);
   objversion_ varchar2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,mch_spare_seq_,contract_);
   Modify__(info_,objid_,objversion_,attr_,action_);
END Modify;


@UncheckedAccess
FUNCTION Has_Spare_Part (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_spare_ NUMBER;
   CURSOR mch_spare IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
   OPEN mch_spare;
   FETCH mch_spare INTO has_spare_;
   CLOSE mch_spare;
   IF (has_spare_ = 1) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Has_Spare_Part;


PROCEDURE Copy (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_ IN VARCHAR2 )
IS
   dummy_       NUMBER;
   newrec_     equipment_object_spare_tab%ROWTYPE;
      equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
   CURSOR source IS
      SELECT obj_spare.*
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq;
   CURSOR destination_exist IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = destination_contract_
      AND    equ_obj.mch_code = destination_object_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
   OPEN destination_exist;
   FETCH destination_exist INTO dummy_;
   IF destination_exist%FOUND THEN
      CLOSE destination_exist;
      RETURN;
   END IF;
   FOR instance IN source LOOP
      newrec_ := NULL;
      newrec_.contract           := destination_contract_;
      OPEN get_equ_seq(destination_contract_, destination_object_);
      FETCH get_equ_seq INTO equ_seq_;
      CLOSE get_equ_seq;
      newrec_.equipment_object_seq           := equ_seq_;
      newrec_.spare_id           := instance.spare_id;
      newrec_.spare_contract     := instance.spare_contract;
      newrec_.qty                := instance.qty;
      newrec_.note               := instance.note;
      newrec_.mch_part           := instance.mch_part;
      newrec_.drawing_no         := instance.drawing_no;
      newrec_.drawing_pos        := instance.drawing_pos;
      newrec_.allow_wo_mat_site  := instance.allow_wo_mat_site;
      New___(newrec_);
   END LOOP;
END Copy;


PROCEDURE Substitute_Part (
   spare_id_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   new_spare_id_   IN VARCHAR2,
   part_list_      IN VARCHAR2,
   structure_      IN VARCHAR2,
   pm_part_list_   IN VARCHAR2,
   sep_spare_part_ IN VARCHAR2)
IS
   attr_            VARCHAR2(32000);

BEGIN
   IF part_list_ = 'Y' THEN
      Substitute_Part__(spare_id_, spare_contract_, new_spare_id_);
   END IF;
   IF structure_ = 'Y' THEN
      Equipment_Spare_Structure_API.Substitute_Part__(spare_id_, spare_contract_, new_spare_id_);
   END IF;
   IF pm_part_list_ = 'Y' THEN
     IF Transaction_SYS.Package_Is_Active('PM_ACTION_SPARE_PART_API') THEN
        Client_SYS.Clear_Attr(attr_);
        Client_SYS.Add_To_Attr('SPARE_ID', spare_id_, attr_);
        Client_SYS.Add_To_Attr('SPARE_CONTRACT', spare_contract_, attr_);
        Client_SYS.Add_To_Attr('NEW_SPARE_ID', new_spare_id_, attr_);
        Transaction_SYS.Dynamic_Call('PM_ACTION_SPARE_PART_API.SUBSTITUTE_PART__', attr_);
     END IF;
   END IF;
   IF sep_spare_part_ = 'Y' THEN
     IF Transaction_SYS.Package_Is_Active('TASK_TEMP_SPARE_UTILITY_API') THEN
        Client_SYS.Clear_Attr(attr_);
        Client_SYS.Add_To_Attr('SPARE_ID', spare_id_, attr_);
        Client_SYS.Add_To_Attr('SPARE_CONTRACT', spare_contract_, attr_);
        Client_SYS.Add_To_Attr('NEW_SPARE_ID', new_spare_id_, attr_);
        Client_SYS.Add_To_Attr('SEP_SPARE_PART', sep_spare_part_, attr_);
        Transaction_SYS.Dynamic_Call('TASK_TEMP_SPARE_UTILITY_API.SUBSTITUTE_PART', attr_);
     END IF;
   END IF;
END Substitute_Part;


FUNCTION Check_Exist (
   mch_code_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   spare_id_       IN VARCHAR2,
   mch_contract_   IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
dummy_ NUMBER;
   CURSOR get_spare_part IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_spare.spare_contract = spare_contract_
      AND    obj_spare.spare_id       = spare_id_;

   CURSOR get_spare_part2 IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = mch_contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_spare.spare_contract = spare_contract_
      AND    obj_spare.spare_id       = spare_id_;
   --
BEGIN
   dummy_ := 0;
   IF mch_contract_ IS NULL THEN
      OPEN get_spare_part;
      FETCH get_spare_part INTO dummy_;
      CLOSE get_spare_part;
   ELSE
      OPEN get_spare_part2;
      FETCH get_spare_part2 INTO dummy_;
      CLOSE get_spare_part2;
   END IF;
   
   IF dummy_ = 0 THEN
      RETURN (0);
   ELSE
      RETURN (1);
   END IF;
END Check_Exist;


PROCEDURE Create_Spare_Part (
   mch_code_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   qty_            IN NUMBER,
   note_           IN VARCHAR2,
   object_part_    IN VARCHAR2 DEFAULT NULL,
   mch_contract_   IN VARCHAR2 DEFAULT NULL )
IS
   mch_spare_seq_ EQUIPMENT_OBJECT_SPARE_TAB.mch_spare_seq%TYPE;
   default_site_  EQUIPMENT_OBJECT_SPARE_TAB.spare_contract%TYPE;
   newrec_        EQUIPMENT_OBJECT_SPARE_TAB%ROWTYPE;
         equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
BEGIN
   mch_spare_seq_        := Get_Next_Seq___;
   newrec_.mch_spare_seq := mch_spare_seq_;
   
   newrec_.spare_id      := part_no_;
         OPEN get_equ_seq(mch_contract_, mch_code_);
      FETCH get_equ_seq INTO equ_seq_;
      CLOSE get_equ_seq;
      newrec_.equipment_object_seq      := equ_seq_;
   IF (spare_contract_ IS NULL) THEN
      default_site_          := User_Default_API.Get_Contract();
      newrec_.spare_contract := default_site_;
      newrec_.contract       := default_site_;
   ELSE
      newrec_.spare_contract := spare_contract_;
      newrec_.contract       := mch_contract_;
   END IF;
   newrec_.qty      := qty_;
   newrec_.note     := note_;
   newrec_.mch_part := object_part_;
   
   New___(newrec_);
END Create_Spare_Part;


PROCEDURE Remove_Obj_Spare (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2)
IS
   CURSOR getrec IS
      SELECT obj_spare.*
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
   FOR lurec_ IN getrec LOOP
   DELETE
      FROM EQUIPMENT_OBJECT_SPARE_TAB
      WHERE mch_spare_seq = lurec_.mch_spare_seq
      AND   contract = lurec_.contract;
   END LOOP;
END Remove_Obj_Spare;


PROCEDURE Check_Configurable_Change (
   part_no_         IN VARCHAR2,
   configurable_db_ IN VARCHAR2)
IS
BEGIN
   NULL;
END Check_Configurable_Change;


@UncheckedAccess
FUNCTION Check_Exist_Object (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   spare_id_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   drawing_no_     IN VARCHAR2,
   drawing_pos_    IN VARCHAR2,
   mch_part_       IN VARCHAR2,
   note_           IN VARCHAR2,
   method_from_    IN VARCHAR2 DEFAULT NULL,
   objid_          IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   s_return_   VARCHAR2(10);

   CURSOR get_spare_object IS
   SELECT obj_spare.drawing_no,obj_spare.drawing_pos,obj_spare.mch_part,obj_spare.note
   FROM  equipment_object_spare_tab obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq
   AND obj_spare.spare_id = spare_id_
   AND obj_spare.spare_contract = spare_contract_;

   CURSOR get_spare_object_For_Update IS
   SELECT obj_spare.drawing_no,obj_spare.drawing_pos,obj_spare.mch_part,obj_spare.note
   FROM  equipment_object_spare_tab obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq
   AND obj_spare.spare_id = spare_id_
   AND obj_spare.spare_contract = spare_contract_
   AND NOT obj_spare.rowid = objid_;
   
BEGIN
   s_return_ := 'FALSE';
   IF method_from_ = 'Update' THEN
      FOR rec_ IN get_spare_object_For_Update  LOOP
      --This check has to be done because these fields are not keys.
      --Have to compare with a value which wouldn't be usually entered by a user. Hopefully no one will enter 'NULL9753124680'.
             IF (nvl(rec_.drawing_no,'NULL9753124680') = nvl(drawing_no_,'NULL9753124680') AND nvl(rec_.drawing_pos,'NULL9753124680') = nvl(drawing_pos_,'NULL9753124680') AND nvl(rec_.mch_part,'NULL9753124680') = nvl(mch_part_,'NULL9753124680') AND nvl(rec_.note,'NULL9753124680') = nvl(note_,'NULL9753124680')) THEN
                s_return_ := 'TRUE';
                EXIT;
             END IF;
      END LOOP;
   ELSE
      FOR rec_ IN get_spare_object  LOOP
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

PROCEDURE Check_Part_Info (
   description_ IN OUT VARCHAR2,
   supply_code_ IN OUT VARCHAR2,
   unit_meas_   IN OUT VARCHAR2,
   part_no_     IN     VARCHAR2,
   contract_    IN     VARCHAR2 )
IS
   
   $IF Component_Invent_SYS.INSTALLED $THEN
       new_unit_meas_    MATERIAL_REQUIS_LINE.unit_meas%TYPE;
       supplier_         VARCHAR2(10);
       part_status_      VARCHAR2(1);
       part_stat_desc_   VARCHAR2(35);
       part_rec_         Inventory_Part_API.public_rec;
   $END
                   
BEGIN
   $IF Component_Invent_SYS.INSTALLED $THEN
       IF Inventory_Part_API.Check_Stored( contract_, part_no_ ) THEN
          part_status_ := Inventory_Part_API.Get_Part_Status( contract_, part_no_);
          IF (Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(part_status_) = 'N') THEN
             part_stat_desc_ := Inventory_Part_Status_Par_API.Get_Description(part_status_);
             Error_SYS.Record_General('EquipmentObjectSpare', 'NOTDEMAND: Inventory part :P1 has part status :P2 which does not allow demands', part_no_ , part_stat_desc_);
          END IF;
          part_rec_      := Inventory_Part_API.Get( contract_, part_no_);
          description_   := Inventory_Part_API.Get_Description( contract_, part_no_);
          new_unit_meas_ := part_rec_.unit_meas;
          supply_code_   := Material_Requis_Supply_API.Decode(part_rec_.supply_code);
       ELSE
          $IF Component_Purch_SYS.INSTALLED $THEN
             description_ := Purchase_Part_API.Get_Description( contract_, part_no_ );
             IF description_ IS NULL THEN
                Error_SYS.Record_General('EquipmentObjectSpare', 'NO_INVENTORY_PART: Part :P1 at Site :P2 does not exist.', part_no_, contract_);
             END IF;

             supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No( contract_, part_no_ );
             IF supplier_ IS NOT NULL THEN
                 new_unit_meas_ := Purchase_Part_Supplier_API.Get_buy_unit_meas( contract_, part_no_, supplier_ );
             END IF;
             supply_code_ := Material_Requis_Supply_API.Decode('PO');
          $ELSE
             Error_SYS.Record_General('EquipmentObjectSpare', 'NO_PURPART_LU: The module IFS/Purchase is not installed. Only inventory parts can be registered');
          $END
       END IF;
       unit_meas_ := NVL(new_unit_meas_, unit_meas_);
   $ELSE
      NULL;
   $END
END Check_Part_Info;

  
PROCEDURE Substitute_Part_Via_Job (
   spare_id_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   new_spare_id_   IN VARCHAR2,
   part_list_      IN VARCHAR2,
   structure_      IN VARCHAR2,
   pm_part_list_   IN VARCHAR2,
   std_spare_part_ IN VARCHAR2 )
IS
   attrib_        VARCHAR2(32000);
   description_   VARCHAR2(200);

BEGIN

   Client_SYS.Clear_Attr(attrib_);

   Client_SYS.Add_To_Attr('SPARE_ID', spare_id_, attrib_);
   Client_SYS.Add_To_Attr('SPARE_CONTRACT', spare_contract_, attrib_);
   Client_SYS.Add_To_Attr('NEW_PARE_ID', new_spare_id_, attrib_);
   Client_SYS.Add_To_Attr('PART_LIST', part_list_, attrib_);
   Client_SYS.Add_To_Attr('STRUCTURE', structure_, attrib_);
   Client_SYS.Add_To_Attr('PM_PART_LIST', pm_part_list_, attrib_);
   Client_SYS.Add_To_Attr('STD_SPARE_PART', std_spare_part_, attrib_);
   
   description_ := Language_SYS.Translate_Constant(lu_name_, 'REPLACE_PART: Replace Part');
   Transaction_SYS.Deferred_Call('EQUIPMENT_OBJECT_SPARE_API.Substitute_Part_Via_Job_Back',attrib_, description_);
   
END Substitute_Part_Via_Job;


PROCEDURE Substitute_Part_Via_Job_Back (
   attrib_ IN VARCHAR2 )
IS

   ptr_                             NUMBER;
   name_                            VARCHAR2(30);
   value_                           VARCHAR2(2000);
   spare_id_                        VARCHAR2(50);
   new_spare_id_                    VARCHAR2(50);
   spare_contract_                  VARCHAR2(5);
   part_list_                       VARCHAR2(1);
   structure_                       VARCHAR2(1);
   pm_part_list_                    VARCHAR2(1);
   std_spare_part_                  VARCHAR2(1);
   pm_error_agrs_                   VARCHAR2(2000) := NULL;
   pm_std_error_agrs_               VARCHAR2(2000) := NULL;
   std_error_agrs_                  VARCHAR2(2000) := NULL;
   info_                            VARCHAR2(2000);
   std_conn_                        VARCHAR2(5) := 'FALSE';
BEGIN

   ptr_ := NULL;

   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SPARE_ID') THEN
         spare_id_ := value_;
      ELSIF (name_ = 'SPARE_CONTRACT') THEN
         spare_contract_ := value_;
      ELSIF (name_ = 'NEW_PARE_ID') THEN
         new_spare_id_ := value_;
      ELSIF (name_ = 'PART_LIST') THEN
         part_list_ := value_;
      ELSIF (name_ = 'STRUCTURE') THEN
         structure_ := value_;
      ELSIF (name_ = 'PM_PART_LIST') THEN
         pm_part_list_ := value_;
      ELSIF (name_ = 'STD_SPARE_PART') THEN
         std_spare_part_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;


   IF part_list_ = 'Y' THEN
      Substitute_Part__(spare_id_, spare_contract_, new_spare_id_);
   END IF;
   IF structure_ = 'Y' THEN
      Equipment_Spare_Structure_API.Substitute_Part__(spare_id_, spare_contract_, new_spare_id_);
   END IF;
   
   $IF Component_Pm_SYS.INSTALLED $THEN
      IF pm_part_list_ = 'Y' THEN
         PM_ACTION_SPARE_PART_API.SUBSTITUTE_PART_VIA_JOB( pm_error_agrs_, spare_id_, new_spare_id_, spare_contract_, std_conn_);
      END IF;
   
      IF std_spare_part_ = 'Y' THEN
        std_conn_ := 'TRUE';
        $IF Component_Pcmstd_SYS.INSTALLED $THEN
           PM_ACTION_SPARE_PART_API.SUBSTITUTE_PART_VIA_JOB( pm_std_error_agrs_, spare_id_, new_spare_id_, spare_contract_, std_conn_);
           TASK_TEMP_SPARE_UTILITY_API.SUBSTITUTE_PART_VIA_JOB( std_error_agrs_, spare_id_, new_spare_id_, spare_contract_);
        $ELSE
           NULL;
        $END
      END IF;
   $ELSE
      NULL;
   $END
   
   IF pm_error_agrs_ IS NOT NULL THEN
      info_ := substr(Language_SYS.Translate_Constant(lu_name_, 'ERRORPMS: Following PM(s) :P1 not replaced - Revision not numeric and the revision has to be updated manually.',NULL, pm_error_agrs_),1,2000);
      Transaction_SYS.Log_Status_Info (info_);
   END IF;

   IF pm_std_error_agrs_ IS NOT NULL THEN
      info_ := substr(Language_SYS.Translate_Constant(lu_name_, 'ERRORSTDPMS: Following PM(s) :P1 which connected to Standard jobs not replaced - Revision not numeric and the revision has to be updated manually.',NULL, pm_std_error_agrs_),1,2000);
      Transaction_SYS.Log_Status_Info (info_);
   END IF;

   IF std_error_agrs_ IS NOT NULL THEN
      info_ := substr(Language_SYS.Translate_Constant(lu_name_, 'ERRORSTD: Following Standard Jobs(s) :P1 not replaced - Revision not numeric and the revision has to be updated manually.',NULL, std_error_agrs_),1,2000);
      Transaction_SYS.Log_Status_Info (info_);
   END IF;
END Substitute_Part_Via_Job_Back;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   spare_contract_ IN VARCHAR2,
   spare_id_       IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_SPARE_TAB obj_spare, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_spare.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_spare.spare_contract = spare_contract_
      AND    obj_spare.spare_id       = spare_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
   ELSE
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Description (
   spare_contract_ IN VARCHAR2,
   spare_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
	$IF Component_Purch_SYS.INSTALLED $THEN
      RETURN Purchase_Part_API.Get_Description(spare_contract_, spare_id_);
   $ELSE
      RETURN NULL;
   $END
END Get_Description;

@UncheckedAccess
FUNCTION Get_Condition_Code(
   spare_id_       IN VARCHAR2,
   condition_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   ls_condition_code_     VARCHAR2(50);
   condition_code_in_use_ VARCHAR2(20);
BEGIN
   condition_code_in_use_ := PART_CATALOG_API.Get_Condition_Code_Usage_Db(spare_id_);
      IF (condition_code_in_use_ = 'ALLOW_COND_CODE' AND condition_code_ IS NULL) THEN 
         ls_condition_code_ := Condition_Code_API.Get_Default_Condition_Code;          
      ELSE 
         RETURN NULL;
      END IF;
         RETURN ls_condition_code_;
END Get_Condition_Code;
   
    
FUNCTION Get_Part_Type(
      spare_id_          IN VARCHAR2,
      spare_contract_    IN VARCHAR2) RETURN VARCHAR2
IS
      purchase_flag_     VARCHAR2 (20);
      inventory_flag_    VARCHAR2 (20);
      type_              VARCHAR2 (20);
      output_            VARCHAR2 (20);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      purchase_flag_ := Purchase_Part_API.Get_Inventory_Flag_Db(spare_contract_,spare_id_);
   $ELSE
      Error_SYS.Record_General('EquipmentObjectSpare', 'NO_PURPART_LU: The module IFS/Purchase is not installed. Only inventory parts can be registered');
   $END
   $IF Component_Invent_SYS.INSTALLED $THEN
      inventory_flag_ := Inventory_Flag_API.Get_Db_Value(0);
   $ELSE
      NULL;
   $END   
   IF(purchase_flag_ IS NULL )THEN 
      type_ :=  inventory_flag_;
   ELSE 
      type_ := purchase_flag_;
   END IF; 
   IF(type_ = 'Y')THEN 
      output_ := 'Inventory Part';
   END IF;
    IF(type_ = 'N')THEN 
      output_ := 'Non Inventory Part';
   END IF;
      RETURN output_;
END Get_Part_Type;