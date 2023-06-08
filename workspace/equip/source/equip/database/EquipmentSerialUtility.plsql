-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentSerialUtility
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990113  RAFA  Create object-serial from customer order (SKY.0616).
--                Added procedure Create_Object.
--  990210  TOWI  Corrected type declarations in method Create_object
--  990318  RAFA  Dynamic call to Cust_Agreement_Object_API.Create_Agreement_Object
--                in  method Create_object.
--  990412  ERJA  Made calls to pcm dynamic.
--  991215 PJONSE Changed template due to performance improvement.
--  000221  MAET  Create_Object: New attributes added to attr2_.
--  000330  MAET  Call Id 32773-- Corrections from Bug 14923 were added.
--  000407  MAET  CallId 37400: Create_Object: oredr_no was added to the attr2_.
--  000522 PJONSE Added PROCEDURE Remove_Object.
--  000608 PJONSE Call Id: 43553 PROCEDURE Remove_Object. Changed get_obj_supsm cursor.
--  000620 PJONSE Call Id: 42708. PROCEDURE Create_Object. Added call to Agreement_Customer_API.Agreement_Customer_Exist,
--                changed dynacmic call from Cust_Agreement_Object_API.Check_Object_Agreement to Cust_Agreement_Object_API.Object_In_Agreement_Exist.
--                and added transaction_description_ and current_position_.
--  000927  ADBR  Bug 16147: Changed Create_Object and Remove_Object to handle structures. Commented code for Create_Agreement_Object.
--  001102  GOPE  Added IID 6423 Warranty Handling 2.12
--  001120 BGADSE Added  part_no_, serial_no_ i SupWarranty and CustWarranty when COPY.
--  001211 RECASE Call 56801. Moved transaction of customer and supplier warranties from procedure Create_Object into serobj.apy, procedure Insert,
--                because the transaction should execute only once - when a new serial object is created.
--  001214 JOHGSE Made Cust_Warranty_API.Copy dynamic becuse the view does not exist in earlier edition of MPCCOM
--  010102 BGADSE Made dynamic call to  Customer_Order_Line_API
--  010115 RECASE Call 56786. Exchanged the old function Customer_Order_Line_API.Get_Warranty for Customer_Order_Line_API.Get_Cust_Warranty_Id.
--                Added customer warranty handling also to top node in PRODEDURE Create Object.
--  010123 RECASE Call 60573. Added definition of bind variable warranty_id_ in PROCEDURE Create Object.
--  010924 JOHGSE Bug Id 23118 Added so when creating object with supp.warranty it gets the supplier of the part.
--  011211 SHAFLK Bug Id: 26797, Internal variables for COMPANY changed to VARCHAR2(20).
--  020304 MIBO   Bug Id: 27500 Created attr4_ in PROCEDURE Create_Object.
-- ************************************* AD 2002-3 BASELINE ********************************************   --                  
--  020517 kamtlk  Modified  serial_no_ length from 20 to 50 in Procedures Create_Object and Remove_. 
--  020523 kamtlk  Modified mch_serial_no length 20 to 50 in Procedures Create_Object and Remove_,
--  020531 CHAMLK  Modified MCH_CODE length from 40 to 100
--  020620 CHCRLK  Modified Create_Object to to take into account new Position 'Contained' in Part Serial Catalog. 
--  -------------------------------AD 2002-3 Beta (Merge of IceAge)-------------------------------------
--  020709 CHATLK Bug Id : 21502 Commented the Cust_Warranty_API.Copy and Sup_Warranty_API.Copy functions and assigned new_warranty_id_ := warranty_id_. 
--  021121 PRIKLK Modified method Create_Object.
--  031016 LABOLK Call 104796: Added parameter operational_status_db in call to Part_Serial_Catalog_API.Move_To_Issued in Remove_Object.
--  030926 PRIKLK Bug 39140, Modified method Create_Object.
--  031103 DIMALK Call ID 105603 - Modified the method Create_Object - Added earlist_valid_from_ and latest_valid_to_ as parameters in method call 
--                Add_Customer_Order_Warranty() for Child objects.
--  031103 NAWILK Call 109789: Added global LU constant "object_party_type_inst_" and modified procedure Create_Object to made dynamic call to OBJECT_PARTY_TYPE_API.   
--  031111 LABOLK Call 109789: Corrected the dynamic calls in Create_Object to OBJECT_PARTY_TYPE_API.
--  230304 DIMALK Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package body.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
--  040213 SHAFLK Bug Id 42701 Changed method Create_Object.
--  040324 JAPALK Merge with SP1
--  040803 NEKOLK Bug Id 45506 Modified method Create_Object. 
--  040816 NIJALK Merged bug 45506. 
--  041028 NAMELK Merged bug 46722.
--  040914 SHAFLK Bug Id 46857 Modified method Remove_Object.
--  041104 Chanlk Merged Bug 46857. 
--  041203 Japalk Remove dynamic calls to ObjectPartyType.
--  041223 GIRALK Bug Id 48065, Modified PROCEDURE Create_Object
--  050103 Chanlk Merged Bug 48065.
--  041206 PRIKLK Bug 48312, Modified method Create_Object.
--  050307 DIAMLK Merged the corrections done for Bug ID:48312. 
--  050221 SHAFLK Bug Id 49584, Modified method Create_Object.
--  050315 Chanlk Merged Bug 49584.
--  050406 NEKOLK Merged- Bug 50157, Modified the method Remove_Object.
--  050425 SESELK Bug 50746, Modified the method Create_Object -  Handled the status changes when the superior object is Functional object. 
--  050518 DiAmlk Merged the corrections done in LCS Bug ID:50746.
--  050411 LOPRLK Bug 50361, Modified the method Create_Object. 
--  050624 NIJALK Merged bug 50361. 
--  050711 RASELK Bug 51518, Modified Remove_Object() to update valid untill date to the RMA date and added a check to stop RMA if customer order has active work orders.  
--  050816 NIJALK Merged bug 51518. 
-----------------------------------------------------------------------------
--  060706 AMDILK MEBR1200: Enlarge Identity - Changed Customer Id length from 10 to 20
--  060713 AMNILK Modified the data type of vendor_no_ from VARCHAR(20) to EQUIPMENT_SERIAL.vendor_no%TYPE in PROCEDURE Create_Object() :MEBR1200-Brazil: Enlarge Identity
--  060817 ILSOLK Modified the daa type of address1 as EQUIPMENT_OBJECT_ADDRESS_TAB.address1%TYPE.
--  070316 MAWILK Merged Bug 63712, Modified the method Create_Object. 
--  -------------------------------------------------------------------------   
-- -----------------------------SP3-----------------------------------
--  080812 ILSOLK Merged Bug 76051,Altered the method Remove_Object. 
--  080911 SHAFLK Bug 76913, Modified the method Create_Object() and Remove_Object().
--  090105 SHAFLK Bug 79198, Modified method Remove_Object. 
--  100907 ILSOLK Bug 92855, Modified Create_Object().
--  101215 ILSOLK Bug 94527, Added new method Moved_To_Issued_Cust_In_Object().
--  090918 SaFalk IID - ME310: Removed unused global variables [object_party_type_inst_,active_separate_inst_]
--  091019 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  110505 NRATLK Bug 96790, Modified Create_Object()to insert address7.
--  091106 SaFalk IID - ME310: Removed bug comment tags.
--  100611 UmDolk EANE-2348: Changed parameters passed to Object_Cust_Warranty_API.Add_Work_Order_Warranty method.
--  110831 ERAALK Bug 98556, Modified Create_Object() to delete address structure 
--  110905 LIAMLK Bug 98556, Modified Create_Object().
--  120119 JAPELK Bug 100822 fixed in Moved_To_Issued_Cust_In_Object.
--------------------------------------------------------------------
-- ------------------------------EAGLE----------------------------------
--  120416 HaRuLK EASTRTM-9528, Remove obsolete code in Create_Object().
--  120423 HaRuLK EASTRTM-9528, Removed agreement_id_.
--------------------------------------------------------------------
--  121231 NEKOLK Bug 107463, Modified Create_Object().Added the check Equipment_Serial_API.Check_Serial_Exist Instead of Equipment_Serial_API.Check_Exist
-- ------------------------------App9------------------------------------
--  131224 SADELK PBSA-3791, Bug 114516, Modified Create_Object().
--  140226 japelk PBSA-3601 fixed (LCS Bug: 113582).
--  140314 HASTSE PBSA-5734, address fixes
--  140804 HASTSE PRSA-2088, fixed unused declarations
--  140813 HASTSE Replaced dynamic code and cleanup
--  150203 HASTSE PRSA-7279, Default handling if no Address_Id not is supplioed with the address
--  150210 NuKuLK PRSA-7365, Modified Remove_Object().
--  150611 CLEKLK Bug 122785, modified Create_Object().
--  150824 SHAFLK RUBY-1650, Modified Create_Object().
--  150903 CLEKLK Bug 124005, Modified Create_Object().
--  160209 CHSLLK Bug 126715, Modified Create_Object(), to fetch the object site and update parties and warranty when no object exists in the current site.
--  160609 DIHELK STRLOC-76, New address fields were added.
--  160620 SHAFLK STRSA-6768,Merged Bug 129460, Modified Create_Object().
--  160816 NEKOLK Bug 130891, Modified Create_Object().
--  161108 JAROLK STRSA-14490, Modified Create_Object View.
--  161214 MADGLK STRSA-15859, Modified Moved_To_Issued_Cust_In_Object().
--  161215 SHAFLK STRSA-16427, Bug 130891, Modified Create_Object().
--  170627 KANILK STRSA-26738, Merged Bug 136527. Fixed in Create_Object() method.
--  171101 HASTSE STRSA-31677, Handling insert of Location address from CO
--  171208 HASTSE STRSA-23852, Adjustment of attributes sent for creating SM Object from CO
--  180117 CLEKLK STRSA-34373, Merged Bug 139636, Modified Create_Object.
--  ------------- Project Spring2020 ----------------------------------------
--  190925  TAJALK  SASPRING20-24, SCA changes
-----------------------------------------------------------------------------
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work .
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Object (
  attr_ IN VARCHAR2 )
IS
   company_                  VARCHAR2(20);
   customer_no_              Equipment_Serial.Owner%TYPE;  
   contract_                 VARCHAR2(5);
   creation_date_            DATE;
   base_sale_unit_price_     NUMBER;
   vendor_no_                EQUIPMENT_SERIAL.vendor_no%TYPE;
   address_name_             VARCHAR2(100);
   address1_                 VARCHAR2(50);
   address2_                 VARCHAR2(50);
   zip_code_                 VARCHAR2(50);
   city_                     VARCHAR2(50);
   state_                    VARCHAR2(50);
   county_                   VARCHAR2(50);
   country_code_             VARCHAR2(2);
   address3_                 VARCHAR2(100);
   address4_                 VARCHAR2(100);
   address5_                 VARCHAR2(100);
   address6_                 VARCHAR2(100);
   warr_exp_                 EQUIPMENT_OBJECT.warr_exp%TYPE;
   note_                     EQUIPMENT_OBJECT.note%TYPE;
   mch_code_                 EQUIPMENT_OBJECT.mch_code%TYPE;
   top_mch_code_             EQUIPMENT_OBJECT.mch_code%TYPE;
   catalog_no_               VARCHAR2(25);
   wanted_delivery_date_     DATE;
   warranty_                 NUMBER;
   part_no_                  VARCHAR2(25);
   serial_no_                VARCHAR2(50);  --kamtlk
   order_no_                 VARCHAR2(12);
   line_no_                  VARCHAR2(4);
   rel_no_                   VARCHAR2(4);
   line_item_no_             NUMBER;
   sup_contract_             VARCHAR2(5);
   sup_mch_code_             VARCHAR2(100);
   note_desc_                VARCHAR2(2000);
   info_                     VARCHAR2(2000);
   ptr_                      NUMBER;
   name_                     VARCHAR2(30);
   value_                    VARCHAR2(2000);
   attr2_                    VARCHAR2(32000);
   attr3_                    VARCHAR2(32000);
   party_type_               VARCHAR2(200);
   objid_                    VARCHAR2(80);
   objversion_               VARCHAR2(2000);
   transaction_description_  VARCHAR2(2000);
   current_position_         VARCHAR2(2000);
   warranty_id_              NUMBER;
   new_warranty_id_          NUMBER;
   attr4_                    VARCHAR2(2000);
   info4_                    VARCHAR2(2000);
   modify_objid_             VARCHAR2(200);
   modify_objversion_        VARCHAR2(200);
   earlist_valid_from_       DATE;
   latest_valid_to_          DATE;
   warr_part_no_             VARCHAR2(25);
   warr_serial_no_           VARCHAR2(50);
   warr_id_                  NUMBER;
   location_id_              VARCHAR2(30);
   ship_addr_no_             VARCHAR2(50);
   child_mch_code_           EQUIPMENT_OBJECT.mch_code%TYPE;

   addr_mch_code_            EQUIPMENT_OBJECT.mch_code%TYPE;
   addr_contract_            EQUIPMENT_OBJECT.contract%TYPE;
   serial_obj_contract_      EQUIPMENT_OBJECT.mch_code%TYPE;
   serial_obj_rec_           Equipment_Serial_API.Public_Rec;
   save_contract_            EQUIPMENT_OBJECT.contract%TYPE;
   op_condition_             VARCHAR2(20);
   superior_object_          EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   top_equip_object_seq_     equipment_object_tab.equipment_object_seq%TYPE;

   CURSOR get_part_struc IS
      SELECT  part_no, serial_no, objstate ,superior_part_no,superior_serial_no
      FROM    PART_SERIAL_CATALOG
      WHERE   superior_part_no IS NOT NULL
      CONNECT BY PRIOR part_no   = superior_part_no
      AND        PRIOR serial_no = superior_serial_no
      START WITH part_no   = part_no_
      AND        serial_no = serial_no_;

   CURSOR get_obj_struc IS
      SELECT  contract, mch_code, equipment_object_seq
      FROM    EQUIPMENT_OBJECT_TAB
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq
      START WITH equipment_object_seq = top_equip_object_seq_;
   
   CURSOR get_obj_supsm_child(c_part_no_ VARCHAR2, c_serial_no_ VARCHAR2) IS
      SELECT objid, objversion
      FROM EQUIPMENT_SERIAL
      WHERE part_no = c_part_no_
      AND serial_no = c_serial_no_;
   
   CURSOR get_obj_supsm IS
      SELECT objid, objversion, contract, mch_code
      FROM   EQUIPMENT_SERIAL
      WHERE  part_no = part_no_
      AND    serial_no = serial_no_;
   
   CURSOR warranty_dates IS
      SELECT min(valid_from), max(valid_to)
      FROM  SERIAL_WARRANTY_DATES_TAB
      WHERE part_no = warr_part_no_
      AND   serial_no = warr_serial_no_
      AND   warranty_id = warr_id_;

   CURSOR get_object(c_part_no_ VARCHAR2, c_serial_no_ VARCHAR2) IS
      SELECT mch_code
      FROM EQUIPMENT_SERIAL
      WHERE part_no = c_part_no_
      AND serial_no = c_serial_no_;

   CURSOR get_contract IS
      SELECT contract
      FROM   EQUIPMENT_SERIAL
      WHERE  part_no = part_no_
      AND    serial_no = serial_no_;
BEGIN
   trace_sys.field('attrib', attr_);
   Client_SYS.Clear_Attr(attr2_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
     IF (name_ = 'COMPANY') THEN
        company_:= value_;
     ELSIF (name_ = 'CUSTOMER_NO') THEN
       customer_no_ := value_;  
     ELSIF (name_ = 'CONTRACT') THEN
        contract_ := value_;
     ELSIF (name_ = 'BASE_SALE_UNIT_PRICE') THEN
       base_sale_unit_price_ := Client_SYS.Attr_Value_To_Number(value_);
     ELSIF (name_ = 'DELIVERY_DATE') THEN
       wanted_delivery_date_ := Client_SYS.Attr_Value_To_Date(value_);
     ELSIF (name_ = 'SUPPLIER') THEN
       vendor_no_ := value_;
     ELSIF (name_ = 'ADDRESS_NAME') THEN
        address_name_ := value_;
     ELSIF (name_ = 'ADDRESS1') THEN
        address1_ := value_;
     ELSIF (name_ = 'ADDRESS2') THEN
        address2_ := value_;
     ELSIF (name_ = 'ZIP_CODE') THEN
        zip_code_ := value_;
     ELSIF (name_ = 'CITY') THEN
        city_ := value_;
     ELSIF (name_ = 'STATE') THEN
        state_ := value_;
     ELSIF (name_ = 'COUNTY') THEN
        county_ := value_;
     ELSIF (name_ = 'COUNTRY_CODE') THEN
        country_code_ := value_;
     ELSIF (name_ = 'ADDRESS3') THEN
        address3_ := value_;
     ELSIF (name_ = 'ADDRESS4') THEN
        address4_ := value_;
     ELSIF (name_ = 'ADDRESS5') THEN
        address5_ := value_;
     ELSIF (name_ = 'ADDRESS6') THEN
        address6_ := value_;
     ELSIF (name_ = 'CATALOG_NO') THEN
        catalog_no_ := value_;
     ELSIF (name_ = 'PART_NO') THEN
        part_no_ := value_;
     ELSIF (name_ = 'SERIAL_NO') THEN
        serial_no_ := value_;
     ELSIF (name_ = 'WARRANTY') THEN
        warranty_ := Client_SYS.Attr_Value_To_Number(value_);
     ELSIF (name_ = 'ORDER_NO') THEN
        order_no_ := value_;
     ELSIF (name_ = 'LINE_NO') THEN
        line_no_ := value_;
     ELSIF (name_ = 'REL_NO') THEN
        rel_no_ := value_;
     ELSIF (name_ = 'LINE_ITEM_NO') THEN
        line_item_no_ := value_;
     ELSIF (name_ = 'SUP_SM_CONTRACT') THEN
        sup_contract_ := value_;
     ELSIF (name_ = 'SUP_SM_OBJECT') THEN
        sup_mch_code_ := value_;
     END IF;
   END LOOP;
   
   Client_SYS.Add_To_Attr('CONTRACT',     contract_,              attr2_);
   Client_SYS.Add_To_Attr('PURCH_PRICE',  base_sale_unit_price_,  attr2_);
   Client_SYS.Add_To_Attr('PURCH_DATE',   wanted_delivery_date_,  attr2_);
   Client_SYS.Add_To_Attr('SUPPLIER_NO',  vendor_no_,             attr2_);
   Client_SYS.Add_To_Attr('PART_NO',      part_no_,               attr2_);
   Client_SYS.Add_To_Attr('SERIAL_NO',    serial_no_,             attr2_);
   Client_SYS.Add_To_Attr('ORDER_NO',     order_no_,              attr2_);
   Client_SYS.Add_To_Attr('LINE_NO',      line_no_,               attr2_);
   Client_SYS.Add_To_Attr('REL_NO',       rel_no_,                attr2_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_,          attr2_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', sup_contract_,          attr2_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', sup_mch_code_,          attr2_);
   Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_), attr2_);

   -- Start Get Location Id for customer delivery address
   ship_addr_no_ := NULL;
   $IF Component_Order_SYS.INSTALLED $THEN
      IF ( customer_no_ IS NOT NULL ) THEN 
         IF  ( Customer_Order_Line_API.Get_Default_Addr_Flag_Db(order_no_, line_no_, rel_no_, line_item_no_) = Gen_Yes_No_Api.DB_NO ) THEN
            IF  ( Customer_Order_Line_API.Get_Addr_Flag_Db(order_no_, line_no_, rel_no_, line_item_no_) = Gen_Yes_No_Api.DB_NO ) THEN
               ship_addr_no_  := Customer_Order_Line_API.Get_Ship_Addr_No(order_no_, line_no_, rel_no_, line_item_no_);
            END IF;
         ELSE
            IF  ( Customer_Order_API.Get_Addr_Flag_Db(order_no_) = Gen_Yes_No_Api.DB_NO ) THEN
               ship_addr_no_  := Customer_Order_API.Get_Ship_Addr_No(order_no_);
            END IF;
         END IF;
         
         location_id_   := Location_Party_Address_API.Get_Location_For_Address(customer_no_, ship_addr_no_, NULL, NULL, NULL);
         IF (location_id_ IS NOT NULL) THEN 
            Client_SYS.Add_To_Attr('LOCATION_ID', location_id_,  attr2_);
         ELSE 
            -- Create a new location and connect the customer delivery address as a visit address to it.
            Location_Party_Address_API.Create_Customer_Location ( location_id_,
                                                                  customer_no_,
                                                                  ship_addr_no_,
                                                                  address_name_,
                                                                  address1_,
                                                                  address2_,
                                                                  zip_code_,
                                                                  city_,
                                                                  state_,
                                                                  county_,
                                                                  country_code_,
                                                                  address3_,
                                                                  address4_,
                                                                  address5_,
                                                                  address6_);
            Client_SYS.Add_To_Attr('LOCATION_ID', location_id_,  attr2_);
         END IF;
      END IF;
   $END
   -- End Get Location Id for customer delivery address

   creation_date_ := Maintenance_Site_Utility_API.Get_Site_Date(contract_);
   warr_exp_      := creation_date_ + warranty_;
   Client_SYS.Add_To_Attr('WARRANTY_EXPIRES', warr_exp_,  attr2_);

   note_desc_     := Language_SYS.Translate_Constant(lu_name_, 'NOTEFIELDONO: Order No :P1 ', NULL, order_no_);
   note_desc_     := note_desc_ || ' ' || Language_SYS.Translate_Constant(lu_name_, 'NOTEFIELDCNO: Sales Part :P1 ', NULL, catalog_no_);
   note_          := note_desc_;
   Client_SYS.Add_To_Attr('NOTE', note_,  attr2_);

   Equipment_Serial_API.Concatenate_Object__(mch_code_, part_no_, serial_no_);
   top_mch_code_  := mch_code_;

   Client_SYS.Add_To_Attr('MCH_CODE', mch_code_,  attr2_);
   trace_sys.field('attrib2', attr2_);


   -- Create top node
   IF (Equipment_Serial_API.Check_Serial_Exist(part_no_, serial_no_) = 'TRUE') THEN
      -- Move serial from inventory to facility
  
      transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTMOVETOFAC: Object moved from inventory to facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
      current_position_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTCURRPOSTXT: Placed in object :P1 at site :P2', NULL, mch_code_, contract_);
  
      
      IF (sup_mch_code_ IS NULL OR Equipment_Functional_API.Do_Exist(sup_contract_, sup_mch_code_) = 'TRUE') THEN                  
         op_condition_:= Part_Serial_Catalog_Api.Get_Operational_Condition_Db(part_no_, serial_no_);
         IF (op_condition_ = 'OPERATIONAL') THEN
            Part_Serial_Catalog_API.Move_To_Facility (part_no_, serial_no_, current_position_, transaction_description_, 'IN_OPERATION');                  
            END IF;
         IF (op_condition_ = 'NON_OPERATIONAL') THEN   
            Part_Serial_Catalog_API.Move_To_Facility (part_no_, serial_no_, current_position_, transaction_description_, 'OUT_OF_OPERATION');                  
         END IF;              
      ELSE
         Part_Serial_Catalog_API.Move_To_Contained (part_no_, serial_no_, current_position_, transaction_description_,NULL);
         Part_Serial_Catalog_API.Set_In_Operation (part_no_, serial_no_, FALSE);
      END IF;
      
      
      Client_SYS.Clear_Attr(attr4_);
      IF vendor_no_ IS NOT NULL THEN 
         Client_SYS.Add_To_Attr('VENDOR_NO', vendor_no_,  attr4_);
      END IF;
      Client_SYS.Add_To_Attr('SUP_CONTRACT', sup_contract_,  attr4_);
      Client_SYS.Add_To_Attr('SUP_MCH_CODE', sup_mch_code_,  attr4_);
      IF (sup_mch_code_ IS NOT NULL AND sup_contract_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('LOCATION_ID', Equipment_Object_API.Get_Location_Id(sup_contract_, sup_mch_code_),  attr4_);
      ELSE
         Client_SYS.Add_To_Attr('LOCATION_ID', location_id_,  attr4_);
      END IF;

      IF Part_Serial_Catalog_API.Get_Installation_Date(part_no_, serial_no_) IS NULL THEN
         Client_SYS.Add_To_Attr('PRODUCTION_DATE', creation_date_, attr4_);
      END IF;

      OPEN get_obj_supsm;
      FETCH get_obj_supsm INTO modify_objid_, modify_objversion_, addr_contract_, addr_mch_code_;
      IF ( get_obj_supsm%NOTFOUND ) THEN
         CLOSE get_obj_supsm;
      ELSE
         
         serial_obj_rec_ := Equipment_Serial_API.Get(contract_, mch_code_);
         IF (Equipment_Serial_API.Check_Exist(contract_,mch_code_)= 'TRUE' AND serial_obj_rec_.part_no = part_no_ AND serial_obj_rec_.mch_serial_no = serial_no_) THEN
            serial_obj_contract_ := contract_;
         ELSE
            OPEN get_contract;
            FETCH get_contract INTO serial_obj_contract_;
            CLOSE get_contract;  
         END IF;
         
         IF (serial_obj_contract_ IS NULL) THEN
            serial_obj_contract_ := contract_;
         END IF;
         
         Equipment_Serial_API.Modify__(info4_, modify_objid_, modify_objversion_, attr4_, 'DO' );
         
                  
         IF ((order_no_ IS NOT NULL) AND (line_no_ IS NOT NULL) AND (rel_no_ IS NOT NULL) AND (line_item_no_ IS NOT NULL)) THEN
            $IF Component_Wo_SYS.INSTALLED $THEN
               Active_Separate_API.Insert_Obj_To_Wo_From_Co_line(order_no_, line_no_, rel_no_, line_item_no_, mch_code_, serial_obj_contract_);
            $ELSE
               NULL;
            $END
         END IF; 

         CLOSE get_obj_supsm;
      END IF;
   ELSE
      -- Create new serial object.
      Equipment_Serial_API.Create_Serial_Object_C_O(attr2_);
      serial_obj_contract_ := contract_;
   END IF;

   --  Customer Warranty from Part Serial Catalog
   --  to top node
   warr_id_ := Part_Serial_Catalog_API.Get_Cust_Warranty_Id(part_no_, serial_no_);

   IF warr_id_ IS NOT NULL THEN
      -- There exist a warranty that shall be added 
      -- to the top node serial object

      new_warranty_id_ := warr_id_; 

      warr_part_no_   := part_no_;
      warr_serial_no_ := serial_no_;

      OPEN warranty_dates;
      FETCH warranty_dates INTO earlist_valid_from_, latest_valid_to_;
      CLOSE warranty_dates;
      
      Object_Cust_Warranty_API.Add_Customer_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(serial_obj_contract_, mch_code_),
                                                          NULL,
                                                          order_no_,
                                                          line_no_,
                                                          rel_no_,
                                                          new_warranty_id_,
                                                          NULL,
                                                          earlist_valid_from_,
                                                          Warranty_Symptom_Status_API.Get_Client_VAlue(0),
                                                          NULL,
                                                          latest_valid_to_);
   END IF;

 -- Supplier Warranty ----

   warranty_id_ := NULL;
   warr_id_ := NULL;
   warranty_id_ := Part_Serial_Catalog_API.Get_Sup_Warranty_Id(part_no_, serial_no_);


   IF warranty_id_ IS NOT NULL THEN 
   -- There exist a warranty that shall be added to the serial object

      new_warranty_id_ := warranty_id_;

      warr_part_no_   := part_no_;
      warr_serial_no_ := serial_no_;
      warr_id_        := warranty_id_;

      OPEN warranty_dates;
      FETCH warranty_dates INTO earlist_valid_from_, latest_valid_to_;
      CLOSE warranty_dates;

      vendor_no_ :=Part_serial_catalog_api.Get_Supplier_No (part_no_, serial_no_);

      IF (new_warranty_id_ IS NOT NULL) THEN
         Object_Supplier_Warranty_API.Add_Customer_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(serial_obj_contract_, mch_code_),
                                                                  NULL,
                                                                  vendor_no_,
                                                                  order_no_,
                                                                  line_no_,
                                                                  NULL,
                                                                  new_warranty_id_,
                                                                  Gen_Yes_No_API.Get_Client_Value(0),
                                                                  earlist_valid_from_,
                                                                  Warranty_Symptom_Status_API.Get_Client_VAlue(0),
                                                                  NULL,
                                                                  latest_valid_to_);
      END IF;

    END IF;
   

-- The whole structure status was already changed with the top node
-- Now it's time to create the equipment structure based upon the part serial structure

   FOR child in get_part_struc LOOP
      trace_sys.field('------------PART connections:', child.part_no);
      IF (child.objstate = 'Issued') THEN
         OPEN get_object(child.part_no, child.serial_no);
         FETCH get_object INTO child_mch_code_;
         CLOSE get_object;
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTMOVETOFAC: Object moved from inventory to facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
         current_position_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTCURRPOSTXT: Placed in object :P1 at site :P2', NULL, child_mch_code_, contract_);        
         Part_Serial_Catalog_API.Move_To_Contained(child.part_no, child.serial_no, current_position_, transaction_description_,NULL);
         Part_Serial_Catalog_API.Set_In_Operation (child.part_no, child.serial_no, FALSE);
      END IF;
      Equipment_Object_Util_API.Get_Object_Info(contract_, superior_object_, Part_Serial_Catalog_API.Get_Superior_Part_No(child.part_no, child.serial_no), Part_Serial_Catalog_API.Get_Superior_Serial_No(child.part_no, child.serial_no));
     
      Equipment_Object_Util_API.Get_Object_Info(save_contract_, mch_code_, child.part_no, child.serial_no);
     
      Equipment_Serial_API.Concatenate_Object__(mch_code_, child.part_no, child.serial_no);

      transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTMOVETOFAC: Object moved from inventory to facility by user :P1', NULL, Fnd_Session_API.Get_Fnd_User);
      current_position_ := Language_SYS.Translate_Constant(lu_name_, 'EQSERUTCURRPOSTXT: Placed in object :P1 at site :P2', NULL, mch_code_, contract_);

      Client_SYS.Clear_Attr(attr2_);

      IF NOT (Equipment_Serial_API.Check_Exist(save_contract_, mch_code_) = 'TRUE') THEN
         Client_SYS.Add_To_Attr('MCH_CODE', mch_code_,  attr2_);
         Client_SYS.Add_To_Attr('CONTRACT', save_contract_,  attr2_);
         Client_SYS.Add_To_Attr('PART_NO', child.part_no,  attr2_);
         Client_SYS.Add_To_Attr('SERIAL_NO', child.serial_no,  attr2_);
         Client_SYS.Add_To_Attr('DESIGN_OBJECT', '2',  attr2_);
      END IF;
      Client_SYS.Add_To_Attr('SUP_MCH_CODE', superior_object_ , attr2_);
      Client_SYS.Add_To_Attr('SUP_CONTRACT', contract_, attr2_);
      Client_SYS.Add_To_Attr('FUNCTIONAL_OBJECT_SEQ', Equipment_Object_API.Get_Equipment_Object_Seq(contract_, superior_object_), attr2_);
              
      IF NOT (Equipment_Serial_API.Check_Exist(save_contract_, mch_code_) = 'TRUE') THEN

         -- Create new serial object.

         Equipment_Serial_API.New__ (info_, objid_, objversion_, attr2_, 'DO');
        
      ELSE
         Client_SYS.Add_To_Attr('SERIAL_MOVE', 'TRUE',  attr2_);
         OPEN  get_obj_supsm_child(child.part_no, child.serial_no);
         FETCH get_obj_supsm_child INTO modify_objid_, modify_objversion_;

         IF ( get_obj_supsm_child%NOTFOUND ) THEN
            CLOSE get_obj_supsm_child;
         ELSE
            CLOSE get_obj_supsm_child;
            Equipment_Serial_API.Modify__(info_, modify_objid_, modify_objversion_, attr2_, 'DO' );
         END IF;
         
      END IF;
      
      -- Customer Warranty from Part Serial Catalog
      warranty_id_ := Part_Serial_Catalog_API.Get_Cust_Warranty_Id(child.superior_part_no,child.superior_serial_no);

      IF ((warranty_id_ IS NOT NULL) AND NOT(Object_Cust_Warranty_API.Is_Warranty_Exist(Equipment_Object_API.Get_Equipment_Object_Seq(save_contract_, mch_code_),warranty_id_)))  THEN -- There exist a warranty that shall be added to the serial object
         

        Object_Cust_Warranty_API.Add_Customer_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(save_contract_, mch_code_),
                                                              NULL,
                                                              order_no_,
                                                              line_no_,
                                                              rel_no_,
                                                              warranty_id_,
                                                              NULL,
                                                              earlist_valid_from_,
                                                              Warranty_Symptom_Status_API.Get_Client_VAlue(0),
                                                              NULL,
                                                              latest_valid_to_);
      END IF;

      -- Supplier Warranty ----
      --   warranty_id_ := Part_Serial_Catalog_API.Get_Sup_Warranty_Id(newrec_.part_no,
      --                                                               newrec_.mch_serial_no);
      warranty_id_ := Part_Serial_Catalog_API.Get_Sup_Warranty_Id(child.superior_part_no,child.superior_serial_no);

      -- There exist a warranty that shall be added to the serial object

         vendor_no_ := Part_serial_catalog_api.Get_Supplier_No (part_no_,serial_no_);
   
      IF ((warranty_id_ IS NOT NULL) AND NOT(Object_Supplier_Warranty_API.Is_Warranty_Exist(Equipment_Object_API.Get_Equipment_Object_Seq(save_contract_, mch_code_), warranty_id_))) THEN
            Object_Supplier_Warranty_API.Add_Customer_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(save_contract_, mch_code_),
                                                                     NULL,
                                                                     vendor_no_,
                                                                     order_no_,
                                                                     line_no_,
                                                                     NULL,
                                                                     warranty_id_,
                                                                     Gen_Yes_No_API.Get_Client_Value(0),
                                                                     NULL,
                                                                     Warranty_Symptom_Status_API.Get_Client_VAlue(0),
                                                                     NULL,
                                                                     NULL);
         END IF;
      



   END LOOP;

   top_equip_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(serial_obj_contract_, top_mch_code_);
   -- Update SM info on the whole equipment structure
   FOR node in get_obj_struc LOOP
      
      -- Remove old customer or supplier.
      Equipment_Object_Party_API.Remove_Obj_Party(node.contract, node.mch_code);
      -- Connect customer to object
      Client_SYS.Clear_Attr(attr3_);
      Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', node.equipment_object_seq,  attr3_);
      Client_SYS.Add_To_Attr('CONTRACT',             node.contract,              attr3_);
      Client_SYS.Add_To_Attr('MCH_CODE',             node.mch_code,              attr3_);
      Client_SYS.Add_To_Attr('IDENTITY',             customer_no_,               attr3_);
      
      party_type_ := OBJECT_PARTY_TYPE_API.decode('CUSTOMER');
      Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,  attr3_);
      $IF Component_Order_SYS.INSTALLED $THEN
         Client_SYS.Add_To_Attr('DELIVERY_ADDRESS', Customer_Order_Api.Get_Ship_Addr_No(order_no_),  attr3_);
      $END
      Equipment_Object_Party_API.New__ (info_, objid_, objversion_, attr3_, 'DO');
      -- Connect supplier to object
      IF vendor_no_  IS NOT NULL THEN
         Client_SYS.Clear_Attr(attr3_);
         Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', node.equipment_object_seq,  attr3_);
         Client_SYS.Add_To_Attr('CONTRACT',             node.contract,              attr3_);
         Client_SYS.Add_To_Attr('MCH_CODE',             node.mch_code,              attr3_);
         Client_SYS.Add_To_Attr('IDENTITY',             vendor_no_,                 attr3_);
         party_type_ := OBJECT_PARTY_TYPE_API.decode('SUPPLIER');
            
         Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_,  attr3_);
      
         Equipment_Object_Party_API.New__ (info_, objid_, objversion_, attr3_, 'DO');

      END IF;
   END LOOP;     

END Create_Object;


PROCEDURE Remove_Object (
  attr_ IN VARCHAR2 )
IS
   part_no_                 VARCHAR2(25);
   serial_no_               VARCHAR2(50);       --kamtlk
   contract_                VARCHAR2(5);
   mch_code_                EQUIPMENT_OBJECT.mch_code%TYPE; 
   top_mch_code_            EQUIPMENT_OBJECT.mch_code%TYPE; 
   catalog_no_              VARCHAR2(25); 
   warranty_                NUMBER;
   attr2_                   VARCHAR2(2000);
   info_                    VARCHAR2(2000);
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   sup_objid_               VARCHAR2(200);
   sup_objversion_          VARCHAR2(200);
   transaction_description_ VARCHAR2(2000);
   current_position_        VARCHAR2(200);
   sup_contract_            VARCHAR2(5);
   sup_mch_code_            VARCHAR2(100);
   order_no_                VARCHAR2(12);
   site_date_               DATE;
   top_equip_object_seq_    equipment_object_tab.equipment_object_seq%TYPE;

   CURSOR get_obj_supsm IS
      SELECT objid, objversion
      FROM   EQUIPMENT_SERIAL
      WHERE  contract = contract_
      AND    mch_code = mch_code_;


   CURSOR get_obj_custwarr( contract_ VARCHAR2, mch_code_ VARCHAR2 ) IS
      SELECT objid, objversion,valid_until
      FROM   OBJECT_CUST_WARRANTY
      WHERE  contract = contract_
      AND    mch_code = mch_code_;

   CURSOR get_obj_struc IS
      SELECT  contract, mch_code, part_no, mch_serial_no
      FROM    EQUIPMENT_OBJECT_TAB
      CONNECT BY PRIOR equipment_object_seq = functional_object_seq
      START WITH equipment_object_seq = top_equip_object_seq_;
BEGIN
   trace_sys.field('attrib', attr_);
   Client_SYS.Clear_Attr(attr2_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
     IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
     ELSIF (name_ = 'CATALOG_NO') THEN
        catalog_no_ := value_;
     ELSIF (name_ = 'PART_NO') THEN
        part_no_ := value_;
     ELSIF (name_ = 'SERIAL_NO') THEN
        serial_no_ := value_;
     ELSIF (name_ = 'WARRANTY') THEN
        warranty_ := Client_SYS.Attr_Value_To_Number(value_);
     ELSIF (name_ = 'ORDER_NO') THEN
        order_no_ := value_;
     ELSIF (name_ = 'SUP_SM_CONTRACT') THEN
        sup_contract_ := value_;
     ELSIF (name_ = 'SUP_SM_OBJECT') THEN
        sup_mch_code_ := value_;
     END IF;
   END LOOP;
 

   -- Get mch_code
   Equipment_Serial_API.Concatenate_Object__(mch_code_, part_no_, serial_no_);
   top_mch_code_ := mch_code_;
   top_equip_object_seq_ := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, top_mch_code_);
   site_date_:= site_api.get_site_date(contract_);

   -- Remove sup_mch_code and sup_contract for top node

   Client_SYS.Clear_Attr(attr2_);
   Client_SYS.Add_To_Attr('SUP_CONTRACT', '',  attr2_);
   Client_SYS.Add_To_Attr('SUP_MCH_CODE', '',  attr2_);
 
   OPEN get_obj_supsm;
   FETCH get_obj_supsm INTO sup_objid_, sup_objversion_;
   IF ( get_obj_supsm%NOTFOUND ) THEN
      CLOSE get_obj_supsm;
   ELSE
      Equipment_Serial_API.Modify__(info_, sup_objid_, sup_objversion_, attr2_, 'DO' ); 
      CLOSE get_obj_supsm;
   END IF;
 
   Equipment_Object_Util_API.Remove_Structure_Party(contract_, mch_code_, 'CUSTOMER'); 

   -- Get current_position and transaction_description
   current_position_:= Language_SYS.Translate_Constant(lu_name_, 'CURRPOSRETFRCUST: Return from Customer' );
   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'TRANSDESCRETFRCUST: Return from customer order:P1 ', order_no_ );
 
   -- Move_To_Issued for the whole equipment structure
   FOR node in get_obj_struc LOOP
     

      -- Remove customer warranty
      IF (Equipment_Object_API.Has_Cust_Warranty__(node.contract, node.mch_code) = 'TRUE') THEN
         FOR cus_warranty in get_obj_custwarr(node.contract, node.mch_code) LOOP
            IF ((cus_warranty.valid_until IS NULL) OR (cus_warranty.valid_until > site_date_))  THEN
               client_sys.Clear_Attr(attr2_);
               client_sys.Add_To_Attr('VALID_UNTIL',site_date_,attr2_);
               Object_Cust_Warranty_API.Modify__(info_,cus_warranty.objid,cus_warranty.objversion,attr2_,'DO'); 
            END IF; 
         END LOOP;
      END IF;

      -- Move serial to issued
      IF (Equipment_Serial_API.Check_Exist(node.contract, node.mch_code) = 'TRUE') THEN
         IF node.mch_code = top_mch_code_ AND node.contract = contract_ THEN
            --If the top part is selected, move it to Issued.
            IF (Equipment_Serial_API.Is_Infacility(part_no_, serial_no_) = 'TRUE') THEN
               Part_Serial_Catalog_API.Move_To_Issued(node.part_no, 
                                                      node.mch_serial_no, 
                                                      current_position_, 
                                                      transaction_description_, 
                                                      'OUT_OF_OPERATION');
            END IF;
         ELSE
            Part_Serial_Catalog_API.Modify_Latest_Transaction(node.part_no, 
                                                              node.mch_serial_no, 
                                                              current_position_, 
                                                              transaction_description_, 
                                                              'CHG_CURRENT_POSITION', 
                                                              order_type_           => NULL, 
                                                              order_no_             => NULL, 
                                                              line_no_              => NULL, 
                                                              release_no_           => NULL, 
                                                              line_item_no_         => NULL, 
                                                              inv_transaction_id_   => NULL);
         END IF;
      END IF;
   
   END LOOP;

END Remove_Object;


PROCEDURE Moved_To_Issued_Cust_In_Object (
   rma_customer_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS

   mch_code_        EQUIPMENT_OBJECT_TAB.mch_code%TYPE;
   mch_contract_    EQUIPMENT_OBJECT_TAB.contract%TYPE;
   temp_            NUMBER;
   is_customer_     VARCHAR2(10);
   attr_            VARCHAR2(1000);
   CURSOR is_customer_in_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARTY_TAB
      WHERE  equipment_object_seq = Equipment_Object_API.Get_Equipment_Object_Seq(mch_contract_, mch_code_)
      AND    identity          = rma_customer_ 
      AND    party_type = 'CUSTOMER';

BEGIN

   Equipment_Serial_Api.Get_Obj_Info_By_Part(mch_contract_,mch_code_,part_no_,serial_no_);
   IF(mch_code_  IS  NOT NULL AND mch_contract_ IS NOT NULL) THEN
      OPEN is_customer_in_object;
      FETCH is_customer_in_object INTO temp_;
      IF (is_customer_in_object%FOUND) THEN
         CLOSE is_customer_in_object;
         is_customer_ := 'TRUE';
      ELSE
         CLOSE is_customer_in_object;
         is_customer_ := 'FALSE';
      END IF;

      IF (is_customer_ = 'TRUE') THEN
         Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
         Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO', rma_customer_, attr_);
         Client_SYS.Add_To_Attr('CONTRACT', mch_contract_, attr_);

         Equipment_Serial_Utility_API.Remove_Object(attr_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'CUSTNOTINOBJECT: Customer :P1 is not available in the Parties tab for the Serial Object.',rma_customer_);
      END IF;
   END IF;
END Moved_To_Issued_Cust_In_Object;



