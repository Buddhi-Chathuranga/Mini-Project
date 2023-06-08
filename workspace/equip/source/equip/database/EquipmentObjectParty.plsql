-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectParty
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971203  PEHA    Created.
--  971208  PEHA    Added VIEW2 with read only
--  971209  MNYS    Moved Party_Type_Identity_API.Exist out of the LOOP
--                  in Unpack_Check_Insert and changed the last parameter to
--                  newrec_.party_type.
--  971210  MNYS    Added Party_Type_Generic_API.Exist.
--  971214  TOWI    Change of where condition in VIEW2.
--  980109  ERJA    Corrected Exist-controls with more than one argument.
--  980120  PEHA    Corected condition in VIEW3.
--  980303  ERJA    Added PROCEDURE Remove_Obj_Test_Pnt.
--  980419  TOWI    Added method Check_Identity
--  980423  PEHA    Changed VIEW3 to select from views.
--  980429  PEHA    'VISIT' changed to 'Visit' in VIEW3.
--  980506  PEHA    Corrected view3.
--  980508  PEHA    Made view 2 and 3 select distinct rows.
--  980508  PEHA    Moved Get_line method calls from client to view3.
--  980513  TOWI    Added default address to view3.
--  980513  ADBR    Added substr to view3.
--  980715  CAJO    Corrected where-statement in VIEW3.
--  980914  ERJA    Added PROCEDURE Set_Party_Structure and Remove_Party_Structure.
--  980929  ERJA    Bug Id 6930: Added Check_Exist___ Set_Party_Structure.
--  980930  ERJA    Removed Domain_id from VIEW3
--  981001  ERJA    Changed OBjVERSION in VIEW3
--  981001  ERJA    Changed Remove_Party_Structure not to remove topnode
--  981130  MIBO    Modify integration against IFS Enterprise.
--  990112  MIBO    SKY.0208 and SKY.0209 Performance issues in Maintenance 5.4.0.
--  990124  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990217  MIBO    Removed Our_Id in view4.
--  990430  TOWI    Changed from equipment_object_address_atb to equipment_object_address in view2.
--  990517  ERJA    Bug ID 10149 Removed def_address from view3
--  990712  MATA    Changed substr to substrb in VIEW definitions
--  000113  ANCE    Changed template due to performance improvement.
--  000127  MABQ    Call Id: 30806 Corrected Decode/Encode Statements in Unpack_Check_Insert/Unpack_Check_Update
--  000128  RECASE  Corrected equipment_object_address to equipment_object_address_tab in view2 selection.
--  000204  MAET    After Sale: New view EQUIPMENT_OBJECT_CUSTOMER_LOV was added.
--  000223  PJONSE  Call Id: 32804 PROCEDURE Unpack_Check_Insert. Changed hardcoded clientvalues to
--                  hardcoded databasevalues.
--  000307  MAET    After Sale: View EQUIPMENT_OBJECT_CUSTOMER_LOV was modified.
--  000524  HAST    Call ID: 41790, Poor Performance in VIEW3, Canged FROM AND WHERE statments.
--  001122 PJONSE   Call Id: 51992. Added FUNCTION Get_Object_Customer.
--  010426  SISALK  Fixed General_SYS.Init_Method in Remove_Obj_Party, Get_Object_Customer.
--  010907  MIBO    Bug Id: 19928 Added LOV EQUIPMENT_OBJ_CUST_NO_SCRAPPED.
--  020207  ANCE    Bug Id: 26013 Added FUNCTION Has_Party.
--  020226  MIBO    Bug Id: 28195 Added where condition (rowstate != 'Scrapped') to EQUIPMENT_OBJECT_PARTY2.
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604  CHAMLK  Modified the length of the MCH_CODE from 40 to 100 in views EQUIPMENT_OBJECT_PARTY, EQUIPMENT_OBJECT_PARTY2,
--                  EQUIPMENT_OBJECT_PARTY3, EQUIPMENT_OBJECT_CUSTOMER_LOV, EQUIPMENT_OBJ_CUST_NO_SCRAPPED
--  020731  Jejalk  Removed State mechinery.
--  021002  Inrolk  Removed Condition "eo.operational_status != 'SCRAPPED'" from view2 since satate machine is moved to Part_Serial_Catalog_API. call ID 88733.
--  031018  LABOLK  Converted VARCHAR to VARCHAR2.
--  031103  NAWILK  Call 109789: Added method Decode_Obj_Party_Type and global LU constant object_party_type_inst_ and modified methods Check_Exist___, Unpack_Check_Insert___,
--  031103          Unpack_Check_Update___, Check_Identity, Get_Name, Set_Party_Structure, Remove_Party_Structure and Get_Object_Customer.
--  031111  LABOLK  Call 109789: Added method Encode_Obj_Party_Type and removed all static calls to Object_Party_Type_API.
--  110204  DIMALK Unicode Support: Changes Done with 'SUBSTRB'.
--  040423  UDSULK Unicode Modification-substr removal-4.
--  041203 Japalk Remove dynamic calls to ObjectPartyType.
--  060125  CHCRLK Modified view EQUIPMENT_OBJECT_PARTY2. [Call ID 131722] 
-----------------------------------------------------------------------------
--  060531  CHODLK Bug 57993,Added new column description to view EQUIPMENT_OBJECT_PARTY2.
--  ------  ----  -----------------------------------------------------------
--  --------------------------Sparx Project Begin----------------------------
--  060629  DiAmlk Merged the corrections done in APP7 SP1.
--  060706  AMDILK MEBR1200: Enlarge Identity - Changed Customer Id length from 10 to 20
--  060817  ILSOLK Changed length of the address1 to 100 characters.
--  070626  AMDILK Modified the view comments for the field "mch_code"
--  080116  LIAMLK Bug 68678, Added column Address7 to VIEW2.
--  080505  SHAFLK Bug 72864, Added new views EQUIPMENT_OBJECT_PARTY5 and EQUIPMENT_OBJECT_PARTY6.
--  080521  CHCRLK Bug 74031, Modified method Remove_Party_Structure. 
--  080620  LIAMLK Bug 74968, Modified column comment of description field in VIEW2.
--  080917  AMNILK Bug Id 74936, Added a new procedure Get_Only_Object_Customer().
--  090602  LIAMLK Bug 82609, Added missing undefine statements.
--  090704  LIAMLK Bug 83022, Modified the where clause of view VIEW2.
--  090825  LIAMLK Bug 84810, Modified field name in VIEW.
--  101021  NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  090923  SaFalk IID - ME310: Remove unused views [EQUIPMENT_OBJECT_CUSTOMER_LOV]
--  091019  LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106  SaFalk IID - ME310: Removed bug comment tags.
--  110524  MADGLK  Bug 97250, Modified Unpack_Check_Update___() and modified column comments of name in EQUIPMENT_OBJECT_PARTY4.
--  100802  ChAmlk Added new party type CONTRACTOR to views EQUIPMENT_OBJECT_PARTY and EQUIPMENT_OBJECT_PARTY4.
--                 Incorperated party type CONTRACTOR to methods Get_Name() and Unpack_Check_Insert___().
--  110127  NEKOLK EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_OBJECT_PARTY,EQUIPMENT_OBJECT_PARTY2.
--  110215  ILSOLK  Bug 94913, Added Object Level view coloumn into EQUIPMENT_OBJECT_PARTY2.
--  110221  SaFalk EANE-4424, Added new view EQUIPMENT_OBJECT_PARTY_UIV with user_allowed_site filter to be used in the client.
--                 Removed user_allowed_site filter from EQUIPMENT_OBJECT_PARTY.
--  110430  NEKOLK  EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_OBJECT_PARTY2
--  110516  MADGLK  Bug 96937, Modified column comments on EQUIPMENT_OBJECT_PARTY,EQUIPMENT_OBJ_CUST_NO_SCRAPPED,EQUIPMENT_OBJECT_PARTY5 and EQUIPMENT_OBJECT_PARTY6.
--  110722  PRIKLK SADEAGLE-1739, Added user_allowed_site filter to view EQUIPMENT_OBJECT_PARTY3
--  110706  LIAMLK  Bug 97644, Modified mch_name in VIEW5, VIEW6.
--  111017  MADGLK  Bug 99136, Modified the length of address1 to String(35).
--  111018  ILSOLK  Bug 99482, Modified where statement in EQUIPMENT_OBJECT_PARTY2 view to increse performence.
--  120119  JAPELK  Bug 100822 fixed by changing the table colum from object_party_type to party_type.
--  120917  KrRaLK  Bug 105128, Modified Reference of Object ID in EQUIPMENT_OBJECT_PARTY.
--  121009  chanlk  Bug 105750, Modified column comments in EQUIPMENT_OBJECT_PARTY.
--  ---------------------------- APPS 9 --------------------------------------
--  130205  MaRalk  PBR-1203, Replaced CUSTOMER_INFO_TAB with CUSTOMER_INFO_CUSTCATEGORY_PUB in EQUIPMENT_OBJECT_PARTY4 view definition and modified selection block.------------------------------- APPS 9 --------------------------------------
--  130619  heralk  Scalability Changes - removed global variables.
--  -------------------------Project Black Pearl---------------------------------------------------------------
--  130510  MAWILK  BLACK-66,  Removed use of EquipmentAllObject.
--  130613  MADGLK  BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls
--  131217  HASTSE  PBSA-3303, Review fixes
--  140708  NRATLK  PRSA-1731, Modified Check_Insert___() and Get_Name() to inculde Asset Manager as a party.
--  140714  NRATLK  PRSA-1732, Added Belongs_To_Asset_Manager() to check if the Asset belongs to the Aset Manager.
--  150120  NIFRSE  PRSA-6531, Modified the Set_Party_Structure method from sending a client value to use a db value instead.
--  150824  SHAFLK  RUBY-1650, Modified Check_Common___().
--  151221  KrRaLK  STRSA-864, Added Has_Customer_Party().
--  161107  KANILK  STRSA-15022, Merged bug 132430 Modified Set_Party_Structure method.
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_party_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF newrec_.party_type = 'CUSTOMER' THEN
       Customer_Info_API.Exist(newrec_.identity);
   ELSIF newrec_.party_type = 'SUPPLIER' THEN
       Supplier_Info_API.Exist(newrec_.identity);
   ELSIF newrec_.party_type = 'CONTRACTOR' THEN
       Supplier_Info_API.Exist(newrec_.identity);
   ELSIF newrec_.party_type = 'MANUFACTURER' THEN
       Manufacturer_Info_API.Exist(newrec_.identity);
   ELSIF newrec_.party_type = 'ASSET_MANAGER' THEN
       Person_Info_API.Exist(newrec_.identity);
   ELSE
       Owner_Info_API.Exist(newrec_.identity);
   END IF;

END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_party_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY equipment_object_party_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS   
BEGIN   
   $IF Component_Order_SYS.INSTALLED $THEN
      IF newrec_.party_type = 'CUSTOMER' THEN
         IF ( newrec_.delivery_address IS NOT NULL ) THEN
            IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.identity, newrec_.delivery_address) = 0) THEN
                  Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
            END IF;
         END IF;
      END IF;
   $END
   
   super(oldrec_,newrec_,indrec_,attr_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Obj_Party (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2)
IS
   info_ VARCHAR2(200);
   CURSOR getrec IS
      SELECT obj_party.*
      FROM   EQUIPMENT_OBJECT_PARTY obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
      FOR lurec_ IN getrec LOOP
      Remove__( info_, lurec_.objid, lurec_.objversion, 'DO');
   END LOOP;
END Remove_Obj_Party;


PROCEDURE Copy (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_ IN VARCHAR2 )
IS
   dummy_       NUMBER;
   newrec_      equipment_object_party_tab%ROWTYPE;
            equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
   CURSOR source IS
      SELECT obj_party.*
      FROM   EQUIPMENT_OBJECT_PARTY obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq;
   CURSOR destination_exist IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARTY obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = destination_contract_
      AND    equ_obj.mch_code = destination_object_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
   OPEN destination_exist;
   FETCH destination_exist INTO dummy_;
   IF destination_exist%FOUND THEN
      CLOSE destination_exist;
      RETURN;
   END IF;
   FOR instance IN source LOOP
      newrec_ := NULL;
      OPEN get_equ_seq(destination_contract_, destination_object_);
      FETCH get_equ_seq INTO equ_seq_;
      CLOSE get_equ_seq;
      newrec_.equipment_object_seq      := equ_seq_;
      newrec_.identity   := instance.identity;
      newrec_.party_type := Object_Party_Type_API.Encode(instance.party_type);
      New___(newrec_);
   END LOOP;
END Copy;


@UncheckedAccess
FUNCTION Check_Identity (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   identity_ IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   party_type_db_ VARCHAR2(37);
   CURSOR get_identity IS
      SELECT 1
      FROM EQUIPMENT_OBJECT_PARTY_TAB obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
      AND   obj_party.identity = identity_
      AND   obj_party.party_type = party_type_db_;
BEGIN
   party_type_db_ := Encode_Obj_Party_Type(party_type_);

   OPEN get_identity;
   FETCH get_identity INTO temp_;
   IF get_identity%FOUND THEN
      CLOSE get_identity;
      RETURN 'TRUE';
   ELSE
      CLOSE get_identity;
      RETURN 'FALSE';
   END IF;
END Check_Identity;


@UncheckedAccess
FUNCTION Get_Name (
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  name_     VARCHAR2(100);
BEGIN
   IF party_type_ =Decode_Obj_Party_Type('CUSTOMER') THEN
       name_ := Customer_Info_API.Get_Name(identity_);
   ELSIF party_type_ =Decode_Obj_Party_Type('SUPPLIER') THEN
       name_ := Supplier_Info_API.Get_Name(identity_);
   ELSIF party_type_ =Decode_Obj_Party_Type('CONTRACTOR') THEN
       name_ := Supplier_Info_API.Get_Name(identity_);
   ELSIF party_type_ =Decode_Obj_Party_Type('MANUFACTURER') THEN
       name_ := Manufacturer_Info_API.Get_Name(identity_);
   ELSIF party_type_ =Decode_Obj_Party_Type('OWNER') THEN
       name_ := Owner_Info_API.Get_Name(identity_);
   ELSIF party_type_ =Decode_Obj_Party_Type('ASSET_MANAGER') THEN
       name_ := Person_Info_API.Get_Name(identity_);
   END IF;
   RETURN name_;
END Get_Name;


PROCEDURE Set_Party_Structure (
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2,
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2 )
IS
   instance_       EQUIPMENT_OBJECT_PARTY%ROWTYPE;
   party_type_db_  VARCHAR2(37);
   rec_            EQUIPMENT_OBJECT_PARTY_TAB%ROWTYPE;
   
   equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
   
   CURSOR source IS
      SELECT obj_party.*
      FROM   EQUIPMENT_OBJECT_PARTY obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
      AND   obj_party.identity = identity_
      AND   obj_party.party_type_db = party_type_db_;

   CURSOR getrec(equipment_object_seq_ IN NUMBER) IS
      SELECT *
      FROM   EQUIPMENT_OBJECT
      CONNECT BY functional_object_seq = PRIOR equipment_object_seq
      START WITH   functional_object_seq = equipment_object_seq_;
BEGIN
   party_type_db_ := Encode_Obj_Party_Type(party_type_);
   OPEN  source ;
   FETCH source INTO instance_;
   CLOSE source;
   
      OPEN get_equ_seq(contract_, mch_code_);
      FETCH get_equ_seq INTO equ_seq_;
      CLOSE get_equ_seq;
   
   FOR newrec IN getrec(equ_seq_) LOOP
      IF NOT Check_Exist___ (newrec.equipment_object_seq, instance_.identity, instance_.party_type_db ) THEN
         rec_ := NULL;
         rec_.equipment_object_seq  := newrec.equipment_object_seq;
         rec_.contract              := newrec.contract;
         rec_.mch_code              := newrec.mch_code;
         rec_.identity              := instance_.identity;
         rec_.party_type            := Object_Party_Type_API.Encode(instance_.party_type);
         rec_.delivery_address      := instance_.delivery_address;        
         New___(rec_);
      END IF;
   END LOOP;
END Set_Party_Structure;


PROCEDURE Remove_Party_Structure (
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2,
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2 )
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);
   party_type_db_ VARCHAR2(37);
   equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
   
   CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
      
   CURSOR getrec(equipment_object_seq_ IN NUMBER) IS
      SELECT *
      FROM   EQUIPMENT_OBJECT
      CONNECT BY functional_object_seq = PRIOR equipment_object_seq
      START WITH   functional_object_seq = equipment_object_seq_;

   CURSOR get_version(equipment_object_seq_ IN NUMBER, party_type_db_ IN VARCHAR2 ) IS
      SELECT rowid, TO_CHAR(rowversion)
      FROM   EQUIPMENT_OBJECT_PARTY_TAB
      WHERE  equipment_object_seq = equipment_object_seq_
      AND    identity = identity_
      AND    party_type = party_type_db_;
BEGIN
    party_type_db_ := Encode_Obj_Party_Type(party_type_);
   
   OPEN get_equ_seq(contract_, mch_code_);
   FETCH get_equ_seq INTO equ_seq_;
   CLOSE get_equ_seq;

   FOR newrec IN getrec(equ_seq_) LOOP
      OPEN get_version(newrec.equipment_object_seq, party_type_db_);
      FETCH get_version INTO objid_, objversion_;
      IF (get_version%FOUND) THEN
         Remove__(info_, objid_, objversion_,'DO');
      END IF;
      CLOSE get_version;
   END LOOP;
END Remove_Party_Structure;


FUNCTION Get_Object_Customer (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2

IS
   --party_type_db_ VARCHAR2(20) := Object_Party_Type_API.Get_Db_Value(0);
   identity_     EQUIPMENT_OBJECT_PARTY_TAB.Identity%TYPE;

   CURSOR get_customer IS
      SELECT obj_party.identity
      FROM   EQUIPMENT_OBJECT_PARTY obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_party.party_type_db = 'CUSTOMER';

BEGIN
      OPEN  get_customer;
   FETCH get_customer INTO identity_;
   CLOSE get_customer;
   RETURN identity_;
END Get_Object_Customer;


@UncheckedAccess
FUNCTION Has_Party (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_party_ NUMBER;
   CURSOR object_exist IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARTY_TAB obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq;
BEGIN
   OPEN object_exist;
   FETCH object_exist INTO has_party_;
   CLOSE object_exist;
   IF (has_party_ = 1) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Has_Party;


@UncheckedAccess
FUNCTION Decode_Obj_Party_Type (
   obj_party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   object_party_type_ VARCHAR2(20);
BEGIN
   
   object_party_type_ := Object_Party_Type_API.Decode(obj_party_type_); 
   RETURN object_party_type_;
END Decode_Obj_Party_Type;


@UncheckedAccess
FUNCTION Encode_Obj_Party_Type (
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   party_type_db_ VARCHAR2(20);
BEGIN
   party_type_db_ := Object_Party_Type_API.Encode(party_type_);
   RETURN party_type_db_;
END Encode_Obj_Party_Type;


@UncheckedAccess
PROCEDURE Get_Only_Object_Customer (
   one_cust_   OUT VARCHAR2,
   identity_   OUT VARCHAR2,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 )

IS
   party_type_db_    VARCHAR2(20) := Object_Party_Type_API.Get_Db_Value(0);
   index_            NUMBER := 0;

   CURSOR get_customer IS
      SELECT obj_party.identity
      FROM   EQUIPMENT_OBJECT_PARTY_TAB obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_party.party_type = party_type_db_;

BEGIN
   
   FOR customer IN get_customer LOOP
      index_ := index_ + 1;
      identity_ := customer.identity;
   END LOOP;
   IF (index_ = 1) THEN
      one_cust_ := 'TRUE';
   ELSE
      one_cust_ := 'FALSE';
   END IF;

END Get_Only_Object_Customer;

FUNCTION Get_Delivery_Address (
   contract_   IN VARCHAR2,
   mch_code_   IN VARCHAR2,
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Delivery_Address(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), identity_, party_type_);
END Get_Delivery_Address;


FUNCTION Belongs_To_Asset_Manager (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   asset_manager_  IN VARCHAR2) RETURN VARCHAR2
IS
      equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
  
   BEGIN
            OPEN get_equ_seq(contract_, mch_code_);
      FETCH get_equ_seq INTO equ_seq_;
      CLOSE get_equ_seq;
    IF Check_Exist___(equ_seq_, asset_manager_, 'ASSET_MANAGER') THEN
       RETURN 'TRUE';
    ELSE 
       RETURN 'FALSE';
    END IF ;
 END Belongs_To_Asset_Manager;
 
 
 @UncheckedAccess
FUNCTION Has_Customer_Party (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_party_ NUMBER;
   party_type_db_    VARCHAR2(20) := Object_Party_Type_API.Get_Db_Value(0);
   CURSOR object_exist IS
      SELECT 1
      FROM   Equipment_Object_Party_Tab obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_party.party_type = party_type_db_;
BEGIN
   OPEN object_exist;
   FETCH object_exist INTO has_party_;
   CLOSE object_exist;
   IF (has_party_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_Customer_Party;

@UncheckedAccess
FUNCTION Has_User_Contractor (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_party_ NUMBER;
   user_contractor_  VARCHAR2(20):=B2b_User_Util_API.Get_User_Default_Supplier;
   CURSOR object_exist IS
      SELECT 1
      FROM   Equipment_Object_Party_Tab obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
         AND obj_party.party_type = 'CONTRACTOR'
         AND obj_party.identity = user_contractor_;
BEGIN
   OPEN object_exist;
   FETCH object_exist INTO has_party_;
   CLOSE object_exist;
   IF (has_party_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_User_Contractor;

@UncheckedAccess
FUNCTION Has_User_Customer (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   has_party_ NUMBER;
   user_customer_  VARCHAR2(20):=B2b_User_Util_API.Get_User_Default_Customer;
   CURSOR object_exist IS
      SELECT 1
      FROM   Equipment_Object_Party_Tab obj_party, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND obj_party.equipment_object_seq = equ_obj.equipment_object_seq
         AND obj_party.party_type = 'CUSTOMER'
         AND obj_party.identity = user_customer_;
BEGIN
   OPEN object_exist;
   FETCH object_exist INTO has_party_;
   CLOSE object_exist;
   IF (has_party_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_User_Customer;
