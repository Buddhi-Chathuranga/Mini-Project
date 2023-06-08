-----------------------------------------------------------------------------
--
--  Logical unit: DefPackInstructShipment
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140521  MeAblk  Modified Check_Valid_Key_Combination___ to check whether the site is user allowed when record contains contract. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Valid_Key_Combination___ (
     contract_              IN VARCHAR2,
     part_no_               IN VARCHAR2,
     customer_no_           IN VARCHAR2,
     ship_addr_no_          IN VARCHAR2,
     capacity_req_group_id_ IN VARCHAR2 )
IS
BEGIN

   IF (contract_ IS NULL) THEN
      IF (customer_no_ IS NOT NULL AND capacity_req_group_id_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CONTRACTCUSTOMERCAPREQGROUP: Capacity Requirement Group ID cannot be entered in combination with Site, Part No, Customer No or Shipping Address.');   
      ELSE
         IF (customer_no_ IS NOT NULL AND part_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'CUSTOMERPART: Customer Number cannot be entered without Part No.');
         END IF;   
      END IF;
   ELSE
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
      
      IF (part_no_ IS NULL AND capacity_req_group_id_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CONTRACTCUSTOMERCAPREQGROUP: Capacity Requirement Group ID cannot be entered in combination with Site, Part No, Customer No or Shipping Address.');   
      ELSE   
         IF (part_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'SITEPARTNO: Site cannot be entered without Part No.');
         END IF;
      END IF;    
   END IF;

   IF (ship_addr_no_ IS NOT NULL) THEN
      IF (customer_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTOMERNOADDRESS: Shipping Address ID cannot be entered without Customer No.');
      END IF;
   END IF;

   IF (capacity_req_group_id_ IS NULL) THEN
      IF (part_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CAPREQGROUPPARTNO: Either Capacity Requirement Group ID or Part No must be entered.');
      END IF;
   ELSE
      IF ((contract_     IS NOT NULL) OR
          (part_no_      IS NOT NULL) OR
          (customer_no_  IS NOT NULL) OR
          (ship_addr_no_ IS NOT NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'CAPREQGROUPOTHERS: Capacity Requirement Group ID cannot be entered in combination with Site, Part No Customer No or Shipping Address ID.');
      END IF;
   END IF;
END Check_Valid_Key_Combination___;   


PROCEDURE Check_Redundant_Record___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   customer_no_                IN VARCHAR2,
   ship_addr_no_               IN VARCHAR2,
   new_packing_instruction_id_ IN VARCHAR2 )
IS
   fallback_packing_instruct_id_ DEF_PACK_INSTRUCT_SHIPMENT_TAB.packing_instruction_id%TYPE;
BEGIN

   fallback_packing_instruct_id_ := Get_Packing_Instruction_Id(contract_, part_no_, customer_no_, ship_addr_no_, get_fallback_ => TRUE);

   IF (new_packing_instruction_id_ = fallback_packing_instruct_id_) THEN
      Error_SYS.Record_General(lu_name_, 'REDUNDANTRECORD: Configuring Package Instruction :P1 for this combination is redundant.', new_packing_instruction_id_);
   END IF;
END Check_Redundant_Record___;


PROCEDURE Check_Record_Exists___ (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   customer_no_           IN VARCHAR2,
   ship_addr_no_          IN VARCHAR2,
   capacity_req_group_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR check_record IS
      SELECT 1
      FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
      WHERE NVL(contract, Database_SYS.string_null_)               =  NVL(contract_, Database_SYS.string_null_)
      AND   NVL(part_no, Database_SYS.string_null_)                =  NVL(part_no_, Database_SYS.string_null_)
      AND   NVL(customer_no, Database_SYS.string_null_)            =  NVL(customer_no_, Database_SYS.string_null_) 
      AND   NVL(ship_addr_no, Database_SYS.string_null_)           =  NVL(ship_addr_no_, Database_SYS.string_null_) 
      AND   NVL(capacity_req_group_id, Database_SYS.string_null_)  =  NVL(capacity_req_group_id_, Database_SYS.string_null_);       
BEGIN
   
   OPEN check_record;
   FETCH check_record INTO dummy_;
   IF (check_record%FOUND) THEN
      CLOSE check_record; 
      Error_SYS.Record_Exist(lu_name_, 'RECORDEXIST: The Default Packing Instruction object already exist.');    
   END IF;   
   CLOSE check_record;
END Check_Record_Exists___;   


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DEF_PACK_INSTRUCT_SHIPMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_seq IS
   SELECT def_pack_instruct_id_seq.nextval
   FROM DUAL;
BEGIN
   OPEN  get_next_seq ;
   FETCH get_next_seq INTO newrec_.def_pack_instruct_id;
   CLOSE get_next_seq;
   Client_SYS.Add_To_Attr('DEF_PACK_INSTRUCT_ID', newrec_.def_pack_instruct_id, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT def_pack_instruct_shipment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Check_Valid_Key_Combination___(newrec_.contract,
                                  newrec_.part_no,
                                  newrec_.customer_no,
                                  newrec_.ship_addr_no,
                                  newrec_.capacity_req_group_id);

   super(newrec_, indrec_, attr_);
   Check_Record_Exists___(newrec_.contract, newrec_.part_no, newrec_.customer_no, newrec_.ship_addr_no, newrec_.capacity_req_group_id);
   Check_Redundant_Record___(newrec_.contract, newrec_.part_no, newrec_.customer_no, newrec_.ship_addr_no, newrec_.packing_instruction_id);
   IF (newrec_.part_no IS NOT NULL AND newrec_.contract IS NOT NULL) THEN
      Sales_Part_API.Exist(newrec_.contract, newrec_.part_no);   
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     def_pack_instruct_shipment_tab%ROWTYPE,
   newrec_ IN OUT def_pack_instruct_shipment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.packing_instruction_id != oldrec_.packing_instruction_id) THEN
      Check_Redundant_Record___(newrec_.contract, newrec_.part_no, newrec_.customer_no, newrec_.ship_addr_no, newrec_.packing_instruction_id);   
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Packing_Instruction_Id (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   customer_no_  IN VARCHAR2,
   ship_addr_no_ IN VARCHAR2,
   get_fallback_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   packing_instruction_id_ VARCHAR2(50);
   capacity_req_group_id_ DEF_PACK_INSTRUCT_SHIPMENT_TAB.capacity_req_group_id%TYPE;
   local_get_fallback_     BOOLEAN;

   CURSOR get_ship_addr_rec IS
      SELECT packing_instruction_id
        FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
       WHERE part_no      = part_no_
         AND contract     = contract_
         AND customer_no  = customer_no_
         AND ship_addr_no = ship_addr_no_;

   CURSOR get_customer_rec IS
      SELECT packing_instruction_id
        FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
       WHERE part_no      = part_no_
         AND contract     = contract_
         AND customer_no  = customer_no_
         AND ship_addr_no IS NULL;
   
   CURSOR get_part_cust_rec IS
      SELECT packing_instruction_id
      FROM   DEF_PACK_INSTRUCT_SHIPMENT_TAB
      WHERE  part_no      = part_no_
      AND    customer_no  = customer_no_
      AND    contract     IS NULL
      AND    ship_addr_no IS NULL; 
      
   CURSOR get_part_cust_addr_rec IS
      SELECT packing_instruction_id
      FROM   DEF_PACK_INSTRUCT_SHIPMENT_TAB
      WHERE  part_no      = part_no_
      AND    customer_no  = customer_no_
      AND    ship_addr_no = ship_addr_no_
      AND    contract     IS NULL;
          
   CURSOR get_site_part_rec IS
      SELECT packing_instruction_id
        FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
       WHERE part_no      = part_no_
         AND contract     = contract_
         AND customer_no  IS NULL
         AND ship_addr_no IS NULL;

   CURSOR get_part_rec IS
      SELECT packing_instruction_id
        FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
       WHERE part_no      = part_no_
         AND contract     IS NULL
         AND customer_no  IS NULL
         AND ship_addr_no IS NULL;

   CURSOR get_capacity_req_group_rec IS
      SELECT packing_instruction_id
        FROM DEF_PACK_INSTRUCT_SHIPMENT_TAB
       WHERE capacity_req_group_id = capacity_req_group_id_;
BEGIN
   local_get_fallback_ := get_fallback_;
   
   IF (ship_addr_no_ IS NOT NULL) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE
         OPEN  get_ship_addr_rec;
         FETCH get_ship_addr_rec INTO packing_instruction_id_;
         CLOSE get_ship_addr_rec;
      END IF;   
   END IF;
   
   IF ((part_no_ IS NOT NULL) AND  (ship_addr_no_ IS NOT NULL) AND (packing_instruction_id_ IS NULL)) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE
         OPEN  get_part_cust_addr_rec;
         FETCH get_part_cust_addr_rec INTO packing_instruction_id_;
         CLOSE get_part_cust_addr_rec;
      END IF;
   END IF;  
   
   IF ((customer_no_ IS NOT NULL) AND (packing_instruction_id_ IS NULL)) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE
         OPEN  get_customer_rec;
         FETCH get_customer_rec INTO packing_instruction_id_;
         CLOSE get_customer_rec;
      END IF;   
   END IF; 
   
   IF ((customer_no_ IS NOT NULL) AND  (part_no_ IS NOT NULL) AND (packing_instruction_id_ IS NULL)) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE
         OPEN  get_part_cust_rec;
         FETCH get_part_cust_rec INTO packing_instruction_id_;
         CLOSE get_part_cust_rec;
      END IF;
   END IF; 

   IF ((contract_ IS NOT NULL) AND (packing_instruction_id_ IS NULL)) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE   
         OPEN  get_site_part_rec;
         FETCH get_site_part_rec INTO packing_instruction_id_;
         CLOSE get_site_part_rec;
      END IF;
   END IF;

   IF ((part_no_ IS NOT NULL) AND (packing_instruction_id_ IS NULL)) THEN
      IF (local_get_fallback_) THEN
         local_get_fallback_ := FALSE;
      ELSE
         OPEN  get_part_rec;
         FETCH get_part_rec INTO packing_instruction_id_;
         CLOSE get_part_rec;
      END IF;   

      IF (packing_instruction_id_ IS NULL) THEN
         capacity_req_group_id_  := Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_);

         OPEN  get_capacity_req_group_rec;
         FETCH get_capacity_req_group_rec INTO packing_instruction_id_;
         CLOSE get_capacity_req_group_rec;
      END IF;
   END IF;

   RETURN (packing_instruction_id_);
END Get_Packing_Instruction_Id;



