-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoAddressType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981123  Camk    Created
--  990416  Maruse  New template
--  990920  LiSv    Client_SYS.Add_To_Attr in Prepare_Insert moved to Unpack_Check_Insert.
--                  This is done for minimizing db calls from client.
--  000306  Mnisse  Call #34257, default address
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  010313  Lmco    Bug #18484 Def_address value = TRUE
--                  (990920 LiSv  unmarked in Prepare_Insert__)
--  030506  Nithlk  Added Get_Default_Address_Id.
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___().
--  100531  Shsalk  Bug 71103 Corrected, Increased rowversion in PROCEDURE Check_Def_Address___.
--  120417  ChFolk  Modified Get_Default_Address_Id to remove General_Sys and added pragma.
--  130125  SALIDE  EDEL-1996, Added New_One_Time_Addr_Type() and modified Copy_Supplier()
--  130304  Nudilk  Bug 108677,Removed General_SYS and Added Pragma from Default_Exist
--  141122  AmThLK  Modified Check_Insert___ to validate default_address_type 
--  150609  Rojalk  ORA-496, Replaced the usage of Supplier_Info_API with Supplier_Info_General_API.
--  151012  chiblk  STRFI-233  Creating records using New___ method
--  170616  Bhhilk  STRFI-6919, Merged Bug 136450, Introduced PROCEDURE Check_Doc_Tax_Info_Exist__, Check_Del_Tax_Info_Exist__.
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  181201  thjilk  Modified Insert___,Update___,Check_Common___,Check_Delete___ to validate address_type_code
--  210303  Smallk  FISPRING20-8769, Merged LCS Bug 157213.
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New methods.
--  210721  NaLrlk  PR21R2-401, Added Modify() to update a record.
--  210817  NaLrlk  PR21R2-589, Removed NOCOPY from IN OUT parameters in Modify().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Def_Address___ (
   supplier_id_        IN supplier_info_address_type_tab.supplier_id%TYPE,
   address_type_code_  IN supplier_info_address_type_tab.address_type_code%TYPE,
   def_address_        IN supplier_info_address_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   dummy_   supplier_info_address_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion) AS objversion
      FROM   supplier_info_address_tab a, supplier_info_address_type_tab b
      WHERE  a.supplier_id       = b.supplier_id
      AND    a.address_id        = b.address_id
      AND    b.supplier_id       = supplier_id_   
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
         dummy_ := Lock_by_Id___(d.ROWID, d.objversion);
         UPDATE supplier_info_address_type_tab
         SET    def_address = 'FALSE',
                rowversion  = rowversion +1
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEF_ADDRESS', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT supplier_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   newrec_.default_domain := 'TRUE';    
   newrec_.party := NVL(newrec_.party, Supplier_Info_General_API.Get_Party(newrec_.supplier_id));   
   super(newrec_, indrec_, attr_);        
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supplier_info_address_type_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   address_rec_             Supplier_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   is_invalid_address_      BOOLEAN;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_type_code_   := Address_Type_Code_API.Decode(newrec_.address_type_code);
   is_invalid_address_  := INSTR(Address_Type_Code_API.Get_Addr_Typs_For_Party_Type(Party_Type_API.DB_SUPPLIER), newrec_.address_type_code) = 0;
   IF (is_invalid_address_) THEN
      Error_SYS.Record_General(lu_name_, 'ADDRTYPINV: Address type :P1 is invalid for :P2.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_SUPPLIER));
   END IF;
   address_rec_ := Supplier_Info_Address_API.Get(newrec_.supplier_id, newrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.supplier_id, newrec_.address_id, newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.supplier_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_SUPPLIER), newrec_.supplier_id);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN supplier_info_address_type_tab%ROWTYPE )
IS
   address_rec_             Supplier_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (supplier_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   supplier_info_address_type
      WHERE  supplier_id = supplier_id_
      AND    address_id = address_id_; 
BEGIN  
   address_type_code_ := Address_Type_Code_API.Decode(remrec_.address_type_code);
   address_rec_ := Supplier_Info_Address_API.Get(remrec_.supplier_id,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.supplier_id, remrec_.address_id, remrec_.address_type_code);
   OPEN get_count(remrec_.supplier_id, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.supplier_id, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_SUPPLIER), remrec_.supplier_id);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of :P2 :P3. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, Party_Type_API.Decode(Party_Type_API.DB_SUPPLIER), remrec_.supplier_id);
   END IF;     
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT supplier_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Supplier_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Supplier_Info_Address_API.Get(newrec_.supplier_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.supplier_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.supplier_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     supplier_info_address_type_tab%ROWTYPE,
   newrec_     IN OUT supplier_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Supplier_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Supplier_Info_Address_API.Get(newrec_.supplier_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.supplier_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.supplier_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override 
PROCEDURE Raise_Record_Not_Exist___ (
   supplier_id_        IN VARCHAR2, 
   address_id_         IN VARCHAR2, 
   address_type_code_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DEFADDTYPECHECK: The Address Type :P1 does not exist for the Address Identity.', Address_Type_Code_API.Decode(address_type_code_));
   super(supplier_id_, address_id_, address_type_code_); 
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Check_Del_Tax_Info_Exist__ (
   supplier_id_   IN  supplier_info_address_type_tab.supplier_id%TYPE,  
   address_id_    IN  VARCHAR2 )
IS
   temp_ VARCHAR2(1);
   $IF (Component_Accrul_SYS.INSTALLED) $THEN
      CURSOR get_rec IS
         SELECT 1
         FROM   supplier_tax_info_tab
         WHERE  supplier_id = supplier_id_
         AND    address_id = address_id_;      
   $END
BEGIN
   $IF (Component_Accrul_SYS.INSTALLED) $THEN
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
   supplier_id_   IN  supplier_info_address_type_tab.supplier_id%TYPE,  
   address_id_    IN  VARCHAR2 )
IS
   temp_ VARCHAR2(1);
   $IF (Component_Invoic_SYS.INSTALLED) $THEN
      CURSOR get_rec IS
         SELECT 1
         FROM   supplier_document_tax_info_tab
         WHERE  supplier_id = supplier_id_
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
   supplier_id_          IN  supplier_info_address_type_tab.supplier_id%TYPE,                   
   def_address_          IN  supplier_info_address_type_tab.def_address%TYPE,
   address_type_code_    IN  supplier_info_address_type_tab.address_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
   CURSOR def_addr_exist IS
      SELECT 1
      FROM   supplier_info_address_tab a, supplier_info_address_type_tab b
      WHERE  a.supplier_id       = b.supplier_id
      AND    a.address_id        = b.address_id
      AND    b.supplier_id       = supplier_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_Sys.Get_First_Calendar_Date())<=NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())<NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_Sys.Get_First_Calendar_Date()))));
   CURSOR get_def IS
      SELECT b.def_address
      FROM   supplier_info_address_type_tab b
      WHERE  b.supplier_id         = supplier_id_
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
   supplier_id_       IN supplier_info_address_type_tab.supplier_id%TYPE,
   address_type_code_ IN supplier_info_address_type_tab.address_type_code%TYPE,
   def_address_       IN supplier_info_address_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS
BEGIN
   Check_Def_Address___(supplier_id_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


@UncheckedAccess
FUNCTION Is_Default (
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   supplier_info_address_type_tab
      WHERE  supplier_id = supplier_id_
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
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF Check_Exist___(supplier_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   newrec_      supplier_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_.supplier_id       := supplier_id_;
   newrec_.address_id        := address_id_;
   newrec_.address_type_code := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address       := 'TRUE';
   newrec_.default_domain    := 'TRUE';
   New___(newrec_);
END New;


PROCEDURE Remove (
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   remrec_      supplier_info_address_type_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, supplier_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   remrec_ := Lock_By_Keys___(supplier_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )
IS   
   newrec_ supplier_info_address_type_tab%ROWTYPE;
   oldrec_ supplier_info_address_type_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM   supplier_info_address_type_tab
      WHERE  supplier_id = supplier_id_;
BEGIN   
   IF (Supplier_Info_General_API.Get_One_Time_Db(supplier_id_) = 'FALSE') THEN      
      FOR rec_ IN get_attr LOOP
         oldrec_ := Lock_By_Keys___(supplier_id_, rec_.address_id, rec_.address_type_code);   
         newrec_ := oldrec_ ;
         newrec_.supplier_id := new_id_;         
         newrec_.default_domain := 'TRUE';
         New___(newrec_);
      END LOOP; 
   END IF;
END Copy_Supplier;


@UncheckedAccess
FUNCTION Default_Exist (
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT 1
      FROM   supplier_info_address_type_tab a, supplier_info_address_tab b
      WHERE  a.supplier_id = supplier_id_
      AND    a.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    a.supplier_id = b.supplier_id
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
   supplier_id_       IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT a.address_id
      FROM   supplier_info_address_type_tab a, supplier_info_address_tab b
      WHERE  a.supplier_id       = supplier_id_
      AND    a.address_type_code = address_type_code_
      AND    a.supplier_id       = b.supplier_id
      AND    a.address_id        = b.address_id
      AND    def_address         = 'TRUE'
      AND    ((TRUNC(current_date_) >= NVL(b.VALID_FROM,Database_Sys.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.VALID_TO,Database_Sys.Get_Last_Calendar_Date())));
   address_id_   VARCHAR2(50);
BEGIN
   OPEN get_default;
   FETCH get_default INTO address_id_;
   IF (get_default%NOTFOUND) THEN
      address_id_ := NULL;
   END IF;
   CLOSE get_default;
   RETURN address_id_;
END Get_Default_Address_Id;


PROCEDURE New_One_Time_Addr_Type (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   default_     IN VARCHAR2 DEFAULT 'FALSE' )
IS
   newrec_       supplier_info_address_type_tab%ROWTYPE;
   common_rec_   supplier_info_address_type_tab%ROWTYPE;
BEGIN
   common_rec_.supplier_id        := supplier_id_;
   common_rec_.address_id         := address_id_;
   common_rec_.def_address        := default_;
   common_rec_.default_domain     := 'TRUE';
   -- delivery
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_DELIVERY;
   New___(newrec_);
   -- invoice
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_DOCUMENT;
   New___(newrec_);
   -- visit
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_VISIT;
   New___(newrec_);
   -- payment
   newrec_ := common_rec_;
   newrec_.address_type_code  := Address_Type_Code_API.DB_PAY;
   New___(newrec_);
END New_One_Time_Addr_Type;


--This method to be used in Aurena
PROCEDURE New (
   supplier_id_       IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_      supplier_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_.supplier_id       := supplier_id_;
   newrec_.address_id        := address_id_;
   newrec_.address_type_code := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address       := def_address_;
   newrec_.default_domain    := 'TRUE';
   New___(newrec_);
END New;


--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   supplier_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);  
   addr_types_       VARCHAR2(1000);
   addr_types_table_ DBMS_UTILITY.UNCL_ARRAY;
   addr_types_count_ BINARY_INTEGER;
BEGIN
   addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('SUPPLIER');
   IF (addr_types_ IS NOT NULL) THEN
      DBMS_UTILITY.COMMA_TO_TABLE(addr_types_, addr_types_count_, addr_types_table_);
      FOR addr_type_ IN 1 .. addr_types_count_ LOOP
         def_exist_ := Default_Exist(supplier_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))));
         IF (def_exist_ = 'TRUE') THEN
            def_address_ := 'FALSE';
         ELSE
            def_address_ := 'TRUE';
         END IF;
         New(supplier_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))), def_address_);
      END LOOP;
   END IF;
END Add_Default_Address_Types;


-- Modify
--   Public interface to modify a record by sending changed values in an attr_.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify (
   attr_              IN OUT VARCHAR2,
   supplier_id_       IN     VARCHAR2,
   address_id_        IN     VARCHAR2,
   address_type_code_ IN     VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     supplier_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(supplier_id_, address_id_, address_type_code_);
   Unpack___(newrec_, indrec_, attr_);
   Modify___(newrec_);
END Modify;
