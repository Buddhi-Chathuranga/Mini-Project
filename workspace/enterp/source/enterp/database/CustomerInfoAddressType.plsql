-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoAddressType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110731  Dobese  Changed Chemmate receiver to HSE receiver
--  981117  Camk    Created
--  990416  Maruse  New template
--  990920  LiSv    Client_SYS.Add_To_Attr in Prepare_Insert moved to Unpack_Check_Insert.
--                  This is done for minimizing db calls from client.
--  000306  Mnisse  Call #34257, default address
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001025  Camk    Added procedure Pack_And_Post_Message__. Procedure will send
--                  a message to IFS Connectivity on update action.
--  001130  Camk    Bug #18471 Wrong customer name in Chemmate transfer corrected
--  001221  Camk    Bug #18821 CHEMMATE message does not exist in Connectivity
--  010313  Lmco    Bug #18484 Def_Address value = 'TRUE'
--                  (990920 LiSv  unmarked in Prepare_Insert___)
--  010425  DIFELK  Bug # 21452 corrected. Deleted the unnecessary cursors with count(*) and
--                  wrote new cursors instead.
--  010430  DIFELK  Bug # 21452. Removed DISTICT from the select statements in cursors.
--  010627  Gawilk  Fixed bug # 15677. Checked General_SYS.Init_Method.
--  011003  Uma     Corrected Bug# 20132.
--  040324  mgutse  Merge of 2004-1 SP1.
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___()
--  100531  Shsalk  Bug 71103 Corrected, Increased rowversion in PROCEDURE Check_Def_Address___.
--  120425  Chgulk  EASTRTM-10402, Merged LCS patch 102270.
--  130304  Nudilk  Bug 108677,Removed General_SYS and Added Pragma from Get_Default_Address_Id,Exist_Primary,Exist_Secondary.
--  121114  Maiklk  Added Modify_Def_Address().
--  130121  SALIDE  EDEL-1995, Added New_One_Time_Addr_Type() and modified Copy_Customer()
--  121116  MaRalk  Modified method Unpack_Check_Update___ to restrict modify address type from Delivery when end customer relationship exists.
--  131017  Isuklk  CAHOOK-2770 Refactoring in CustomerInfoAddressType.entity
--  140710  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  141115  AmThLK  PRFI-3181, Merged Bug 119330, Added validation for default address type in Check_insert___
--  141122  MaIklk  PRSC-1485, Handled to check whether the address is connected as end customer address when updating or deleting delivery address type.
--  150708  Wahelk  BLU-956, Added new method Copy_Customer_Def_Address
--  150713  Wahelk  BLU-959, Modified method Copy_Customer_Def_Address
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150812  Wahelk  BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_
--  150813  Wahelk  BLU-1192,Modified Copy_Customer method to use newly created address id if same exist
--  150818  Wahelk  BLU-1192,Modified Copy_Customer method 
--  161228  ChJalk  Bug 132992, Modified the method Copy_Customer to avoid the party type being copied from the template customer.
--  170214  Hasplk  STRMF-9630, Merged lcs patch 132521.
--  170626  Bhhilk  STRFI-6919, Merged Bug 136450, Introduced PROCEDURE Check_Del_Tax_Info_Exist__ and Check_Doc_Tax_Info_Exist__.
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  181203  thjilk  Modified Insert___,Update___,Check_Common___,Check_Delete___ to validate address_type_code
--  200824  JICESE  Changed HSE integration to post message to receiver as BizAPIs are obsoleted
--  200907  ILSOLK  SM2020R1-4115,Modified Insert___ to create new location when register visit address.
--  201009  Shdilk  FISPRING20-7619,Modified Insert___ to create new location when register visit address only for the customers of customer caterogy 'CUSTOMER'.
--  210202  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods New, Modify_Def_Address and New_One_Time_Addr_Type
--  210303  Smallk  FISPRING20-8769, Merged LCS Bug 157213.
--  210517  NiFrse  SM21R2-1178, changed dynamic call from Mscom to Loc in Insert___().
--  211207  AKDELK  SM21R2-3481, Modified Insert___
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DEFADDTYPECHECK: The Address Type :P1 does not exist for the Address Identity.', Address_Type_Code_API.Decode(address_type_code_));
   super(customer_id_, address_id_, address_type_code_);  
END Raise_Record_Not_Exist___;


PROCEDURE Check_Def_Address___ (
   customer_id_        IN customer_info_address_type_tab.customer_id%TYPE,
   address_type_code_  IN customer_info_address_type_tab.address_type_code%TYPE,
   def_address_        IN customer_info_address_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   dummy_   customer_info_address_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion) AS objversion
      FROM   customer_info_address_tab a, customer_info_address_type_tab b
      WHERE  a.customer_id       =  b.customer_id
      AND    a.address_id        =  b.address_id
      AND    b.customer_id       = customer_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_Sys.Get_First_Calendar_Date())<=NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())<NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_Sys.Get_First_Calendar_Date()))));
BEGIN
   IF (def_address_  = 'TRUE') THEN
      FOR d IN def_addr LOOP
         dummy_ := Lock_By_Id___(d.ROWID, d.objversion);
         UPDATE customer_info_address_type_tab
         SET    def_address = 'FALSE',
                rowversion  = rowversion +1
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


PROCEDURE Get_Customer_Party___ (
   newrec_ IN OUT customer_info_address_type_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Customer_Info_API.Get_Party(newrec_.customer_id);
      Client_SYS.Add_To_Attr('PARTY', newrec_.party, attr_);
   END IF;
END Get_Customer_Party___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEF_ADDRESS', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Customer_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   customer_category_       customer_info_tab.customer_category%TYPE;
BEGIN
   Get_Customer_Party___(newrec_, attr_);
   super(objid_, objversion_, newrec_, attr_);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Customer_Info_Address_API.Get(newrec_.customer_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.customer_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.customer_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   -- Create Location,when create customer visit address
   $IF (Component_Loc_SYS.INSTALLED) $THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_id);
      IF (newrec_.address_type_code IN ( Address_Type_Code_API.DB_VISIT, Address_Type_Code_API.DB_DELIVERY ) AND customer_category_ = 'CUSTOMER') THEN
         Location_API.Handle_Party_Location(Location_Category_API.DB_CUSTOMER, newrec_.customer_id, newrec_.address_id);
      END IF;
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_address_type_tab%ROWTYPE,
   newrec_     IN OUT customer_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Customer_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Customer_Info_Address_API.Get(newrec_.customer_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.customer_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.customer_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Pack_And_Post_Message__(newrec_, 'ADDEDIT');
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_info_address_type_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS    
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);   
   -- Check there is an end customer connected for this customer, then changing of delivery address type is not allowed.
   IF ((oldrec_.address_type_code != newrec_.address_type_code AND oldrec_.address_type_code = Address_Type_Code_API.DB_DELIVERY) AND
       Customer_Info_Address_API.Get_End_Customer_Id(newrec_.customer_id, newrec_.address_id) IS NOT NULL) THEN  
      Error_SYS.Record_General(lu_name_, 'ONLYDELADDRALLOWED: An end customer has been connected and you cannot change the delivery address type.');   
   END IF;
   -- Check whehter this customer has been connected to another customer as an end customer, then changing of delivery address type is not allowed.
   IF ((oldrec_.address_type_code != newrec_.address_type_code AND oldrec_.address_type_code = Address_Type_Code_API.DB_DELIVERY) AND  
      Customer_Info_Address_API.Exist_End_Customer(newrec_.customer_id, newrec_.address_id)) THEN      
      Error_SYS.Record_General(lu_name_, 'UPDENDUCSTEXIST: Cannot change the delivery address type when the address has been connected as an end customer address.');   
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_address_type_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
   address_rec_             Customer_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   is_invalid_address_      BOOLEAN;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_type_code_   := Address_Type_Code_API.Decode(newrec_.address_type_code);
   is_invalid_address_  := INSTR(Address_Type_Code_API.Get_Addr_Typs_For_Party_Type(Party_Type_API.DB_CUSTOMER), newrec_.address_type_code) = 0;
   IF (is_invalid_address_  ) THEN
      Error_SYS.Record_General(lu_name_, 'ADDRTYPINV: Address type :P1 is invalid for :P2.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));
   END IF;
   address_rec_ := Customer_Info_Address_API.Get(newrec_.customer_id, newrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.customer_id, newrec_.address_id, newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.customer_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), newrec_.customer_id);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN customer_info_address_type_tab%ROWTYPE )
IS
   address_rec_             Customer_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (customer_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   customer_info_address_type
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_; 
BEGIN
   IF (remrec_.address_type_code = Address_Type_Code_API.DB_DELIVERY AND Customer_Info_Address_API.Exist_End_Customer(remrec_.customer_id, remrec_.address_id)) THEN
       Error_SYS.Record_General(lu_name_, 'DELENDUCSTEXIST: Cannot delete the delivery address type when the address has been connected as an end customer address.');
   END IF;   
   address_type_code_ := Address_Type_Code_API.Decode(remrec_.address_type_code);
   address_rec_ := Customer_Info_Address_API.Get(remrec_.customer_id,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.customer_id, remrec_.address_id, remrec_.address_type_code);
   OPEN get_count(remrec_.customer_id, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.customer_id, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), remrec_.customer_id);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of :P2 :P3. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), remrec_.customer_id);
   END IF;     
   super(remrec_);
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF (action_ != 'PREPARE') THEN
      Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   END IF;   
   super(info_, objid_, objversion_, attr_, action_);   
END New__;


PROCEDURE Pack_And_Post_Message__ (
   rec_    IN customer_info_address_type_tab%ROWTYPE,
   action_ IN VARCHAR2 )
IS
   def_addr_id_               VARCHAR2(50);
   object_property_value_     VARCHAR2(1000);
   address_rec_               Customer_Info_Address_API.public_rec;
   hse_address_param_rec_     Plsqlap_Record_API.Type_Record_;
   xml_                       CLOB;
BEGIN
   object_property_value_ := Object_Property_API.Get_Value('CustomerInfoAddress', 'CUSTOMER', 'HSE'); 
   IF (NVL(object_property_value_,'FALSE') <> 'FALSE') THEN      
      address_rec_ := Customer_Info_Address_API.Get(rec_.customer_id, rec_.address_id);
      def_addr_id_ := Customer_Info_Address_API.Get_Id_By_Type(rec_.customer_id, Address_Type_Code_API.Decode('INVOICE'));
      def_addr_id_ := NVL(def_addr_id_, '*');
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         IF (rec_.address_id = def_addr_id_) THEN
            hse_address_param_rec_ := Plsqlap_Record_API.New_Record('HSE_CUSTOMER_ADDRESS_PARAMS');
            Plsqlap_Record_API.Set_Value(hse_address_param_rec_, 'CUSTOMER_ID', rec_.customer_id);
            Plsqlap_Record_API.Set_Value(hse_address_param_rec_, 'ADDRESS_ID', def_addr_id_);
            IF (action_ = 'ADDEDIT') THEN
               Plsqlap_Record_API.To_Xml(xml_, hse_address_param_rec_);
               Plsqlap_Server_API.Post_Outbound_Message(xml_      => xml_,
                                                        sender_   => Fnd_Session_API.Get_Fnd_User,
                                                        receiver_ => 'HSECustomerAddress');
            END IF;            
         END IF;
      $ELSE
         NULL;
      $END
   END IF; 
END Pack_And_Post_Message__;


PROCEDURE Check_Del_Tax_Info_Exist__ (
   customer_id_   IN  customer_info_address_type_tab.customer_id%TYPE,  
   address_id_    IN  VARCHAR2 )
IS
   temp_ VARCHAR2(1);
   $IF (Component_Invoic_SYS.INSTALLED) $THEN
   CURSOR get_rec IS
      SELECT 1
      FROM   customer_tax_info_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;      
   $END
BEGIN
   $IF (Component_Invoic_SYS.INSTALLED) $THEN
      OPEN get_rec;
      FETCH get_rec INTO temp_;
      IF (get_rec%FOUND) THEN
         CLOSE get_rec;
         Error_SYS.Record_General(lu_name_, 'DELTAXEXISTS: The Address Type cannot be deleted as there are connections with Delivery Tax Information.');
      END IF;
      CLOSE get_rec;
   $ELSE
      NULL;
   $END
END Check_Del_Tax_Info_Exist__;


PROCEDURE Check_Doc_Tax_Info_Exist__ (
   customer_id_   IN  customer_info_address_type_tab.customer_id%TYPE,  
   address_id_    IN  VARCHAR2 )
IS
   temp_ VARCHAR2(1);
   $IF (Component_Invoic_SYS.INSTALLED) $THEN
   CURSOR get_rec IS
      SELECT 1
      FROM   customer_document_tax_info_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;             
   $END
BEGIN
   $IF (Component_Invoic_SYS.INSTALLED) $THEN
      OPEN get_rec;
      FETCH get_rec INTO temp_;
      IF (get_rec%FOUND) THEN
         CLOSE get_rec;
         Error_SYS.Record_General(lu_name_, 'DOCTAXEXISTS: The Address Type cannot be deleted as there are connections with Document Tax Information.');
      END IF;
      CLOSE get_rec;
   $ELSE
      NULL;
   $END
END Check_Doc_Tax_Info_Exist__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Def_Address_Exist (
   validation_result_    OUT VARCHAR2,
   validation_flag_      OUT VARCHAR2,
   customer_id_          IN  customer_info_address_type_tab.customer_id%TYPE,                   
   def_address_          IN  customer_info_address_type_tab.def_address%TYPE,
   address_type_code_    IN  customer_info_address_type_tab.address_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
   CURSOR def_addr_exist IS
      SELECT 1
      FROM   customer_info_address_tab a,customer_info_address_type_tab b
      WHERE  a.customer_id       = b.customer_id
      AND    a.address_id        = b.address_id
      AND    b.customer_id       = customer_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_Sys.Get_First_Calendar_Date())<=NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())<NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_Sys.Get_First_Calendar_Date()))));
   CURSOR get_def IS
      SELECT b.def_address
      FROM   customer_info_address_type_tab b
      WHERE  b.customer_id         = customer_id_
      AND    b.address_type_code   = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.ROWID||''           = NVL(objid_,CHR(0));
    dummy_    VARCHAR2(20);
BEGIN
   validation_result_ := 'TRUE';
   validation_flag_   := 'TRUE';
   FOR d IN def_addr_exist LOOP      
      IF (def_address_ = 'TRUE') THEN
         validation_result_ := 'FALSE';
      ELSE
         validation_flag_ := 'FALSE';
      END IF;
   END LOOP;
   IF (validation_flag_ = 'TRUE') THEN
      OPEN get_def;
      FETCH get_def INTO dummy_;
      IF (dummy_ = 'FALSE') THEN
         validation_flag_ := 'FALSE';
      END IF;
      CLOSE get_def; 
   END IF;
END Check_Def_Address_Exist;


PROCEDURE Check_Def_Addr_Temp (
   customer_id_       IN customer_info_address_type_tab.customer_id%TYPE,
   address_type_code_ IN customer_info_address_type_tab.address_type_code%TYPE,
   def_address_       IN customer_info_address_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS

BEGIN
   Check_Def_Address___(customer_id_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


@UncheckedAccess
FUNCTION Is_Default (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   customer_info_address_type_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_
      AND    address_type_code = db_value_;
BEGIN
   db_value_ := Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_default;
   FETCH get_default INTO def_address_;
   IF (get_default%NOTFOUND) THEN
      CLOSE get_default;
      RETURN 'FALSE';
   END IF;
   CLOSE get_default;
   RETURN def_address_;
END Is_Default;


@UncheckedAccess
FUNCTION Check_Exist (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF Check_Exist___(customer_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_)) THEN
      RETURN 'TRUE';
  ELSE
      RETURN 'FALSE';
  END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Exist_Primary (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT 1
      FROM   customer_info_address_type_tab
      WHERE  customer_id = customer_id_
      AND    address_type_code = 'PRIMARY';

BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   IF (get_count%FOUND) THEN
      CLOSE get_count;
      RETURN 'TRUE';
   ELSE
      CLOSE get_count;
      RETURN 'FALSE';
   END IF;
END Exist_Primary;


@UncheckedAccess
FUNCTION Exist_Secondary (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT 1
      FROM   customer_info_address_type_tab
      WHERE  customer_id = customer_id_
      AND    address_type_code = 'SECONDARY';
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   IF (get_count%FOUND) THEN
     CLOSE get_count;
     RETURN 'TRUE';
   ELSE
      CLOSE get_count;
      RETURN 'FALSE';
   END IF;
END Exist_Secondary;


PROCEDURE New (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 DEFAULT 'TRUE' )
IS
   newrec_  customer_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_.customer_id        := customer_id_;
   newrec_.address_id         := address_id_;
   newrec_.address_type_code  := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address        := def_address_;
   newrec_.default_domain     := 'TRUE';
   New___(newrec_);
END New;


PROCEDURE Remove (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   remrec_      customer_info_address_type_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   remrec_ := Lock_By_Keys___(customer_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


PROCEDURE Modify_Def_Address (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )

IS
   newrec_     customer_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_  := Get_Object_By_Keys___(customer_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   newrec_.def_address := def_address_;
   Modify___(newrec_);
END Modify_Def_Address;


PROCEDURE Copy_Customer (
   customer_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN  Customer_Info_API.Copy_Param_Info )
IS   
   newrec_        customer_info_address_type_tab%ROWTYPE;
   oldrec_        customer_info_address_type_tab%ROWTYPE;
   address_rec_   Customer_Info_Address_API.Public_Rec;
   CURSOR get_attr IS
      SELECT *
      FROM   customer_info_address_type_tab
      WHERE  customer_id = customer_id_;
   CURSOR get_def_attr IS
      SELECT *
      FROM   customer_info_address_type_tab t
      WHERE  customer_id = customer_id_
      AND    address_id = copy_info_.temp_del_addr;
BEGIN  
   -- if transfer address data is checked in CONVERT , copy address type information from default delivery template
   -- when new customer has no default delivery address define
   IF (Customer_Info_API.Get_One_Time_Db(customer_id_) = 'FALSE') THEN 
      IF (copy_info_.copy_convert_option = 'CONVERT') THEN
         IF (copy_info_.temp_del_addr IS NOT NULL AND copy_info_.new_del_address IS NULL) THEN
            address_rec_ := Customer_Info_Address_API.Get(customer_id_, copy_info_.temp_del_addr);
            FOR def_ IN get_def_attr LOOP
               --Remove defaults    
               Check_Def_Addr_Temp(new_id_, Address_Type_Code_API.Decode(def_.address_type_code), def_.def_address, NULL, address_rec_.valid_from, address_rec_.valid_to);        
               oldrec_ := Lock_By_Keys___(customer_id_, def_.address_id, def_.address_type_code);   
               newrec_ := oldrec_; 
               newrec_.customer_id := new_id_;
               newrec_.address_id := NVL(copy_info_.new_address_id, copy_info_.temp_del_addr);
               newrec_.party := NULL;
               newrec_.default_domain := 'TRUE';         
               New___(newrec_);
            END LOOP;  
         END IF;
      ELSE
         FOR rec_ IN get_attr LOOP
            oldrec_ := Lock_By_Keys___(customer_id_, rec_.address_id, rec_.address_type_code);   
            newrec_ := oldrec_ ;
            newrec_.customer_id := new_id_;
            newrec_.party := NULL;
            newrec_.default_domain := 'TRUE';         
            New___(newrec_);
         END LOOP;
      END IF;
   END IF;
END Copy_Customer;


@UncheckedAccess
FUNCTION Default_Exist (
   customer_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT 1
      FROM   customer_info_address_type_tab a, customer_info_address_tab b
      WHERE  a.customer_id = customer_id_
      AND    a.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    a.customer_id = b.customer_id
      AND    a.address_id = b.address_id
      AND    a.def_address = 'TRUE'
      AND    ((TRUNC(current_date_) >= NVL(b.valid_from,Database_Sys.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.valid_to,Database_Sys.Get_Last_Calendar_Date())));
   temp_   VARCHAR2(20);
BEGIN
   OPEN get_default;
   FETCH get_default INTO temp_;
   IF (get_default%NOTFOUND) THEN
      CLOSE get_default;
      RETURN 'FALSE';
   END IF;
   CLOSE get_default;
   RETURN 'TRUE';
END Default_Exist;


@UncheckedAccess
FUNCTION Get_Default_Address_Id (
   customer_id_       IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT a.address_id
      FROM   customer_info_address_type_tab a, customer_info_address_tab b
      WHERE  a.customer_id       = customer_id_
      AND    a.address_type_code = address_type_code_
      AND    a.customer_id       = b.customer_id
      AND    a.address_id        = b.address_id
      AND    def_address         = 'TRUE'
      AND    ((TRUNC(current_date_) >= NVL(b.valid_from,Database_Sys.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.valid_to,Database_Sys.Get_Last_Calendar_Date())));
   address_id_   VARCHAR2(50);
BEGIN 
   OPEN  get_default;
   FETCH get_default INTO address_id_;
   IF (get_default%NOTFOUND) THEN
      address_id_ := NULL;
   END IF;
   CLOSE get_default;
   RETURN address_id_;
END Get_Default_Address_Id;


PROCEDURE New_One_Time_Addr_Type (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   default_     IN VARCHAR2 DEFAULT 'FALSE' )
IS
   common_rec_ customer_info_address_type_tab%ROWTYPE;
   newrec_     customer_info_address_type_tab%ROWTYPE;
BEGIN
   common_rec_.customer_id    := customer_id_;
   common_rec_.address_id     := address_id_;
   common_rec_.def_address    := default_;
   common_rec_.default_domain := 'TRUE';
   -- Delivery
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_DELIVERY;
   New___(newrec_);
   -- Invoice
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_DOCUMENT;
   New___(newrec_);
   -- Visit
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_VISIT;
   New___(newrec_);   
   -- Payment
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_PAY;
   New___(newrec_);
END New_One_Time_Addr_Type;


--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   customer_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);  
   addr_types_       VARCHAR2(1000);
   addr_types_table_ DBMS_UTILITY.UNCL_ARRAY;
   addr_types_count_ BINARY_INTEGER;
BEGIN
   addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('CUSTOMER');
   IF (addr_types_ IS NOT NULL) THEN
      DBMS_UTILITY.COMMA_TO_TABLE(addr_types_, addr_types_count_, addr_types_table_);
      FOR addr_type_ IN 1 .. addr_types_count_ LOOP
         def_exist_ := Default_Exist(customer_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))));
         IF (def_exist_ = 'TRUE') THEN
            def_address_ := 'FALSE';
         ELSE
            def_address_ := 'TRUE';
         END IF;
         New(customer_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))), def_address_);
      END LOOP;
   END IF;
END Add_Default_Address_Types;

