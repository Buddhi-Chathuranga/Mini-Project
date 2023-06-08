-----------------------------------------------------------------------------
--
--  Logical unit: CompanyAddressType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980930  ANHO    Created.
--  981019  Camk    Public method New() and Remove() added.
--  990412  Maruse  New template
--  990415  Maruse  Some minor changes.
--  990428  Maruse  minur templfixes.
--  990920  LiSv    Client_SYS.Add_To_Attr in prepare_insert moved to unpack_check_insert. This is
--                  done for minimizing db calls from client.
--  000306  Mnisse  Call #34257, default address
--  010313  Lmco    Bug #18484 Def_Address value = 'TRUE'
--                  (990920 LiSv  unmarked in Prepare_Insert___)
--  030203  PrJalk  Added Public function Get_Company_Address_Id.
--  050202  Saahlk  LCS Patch Merge, Bug 44226.
--  060828  Maselk  FIPL615, Added Document_Address_Exist().
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___()
--  141122          Added Check_Insert___ to validate default_address_type 
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  181130  thjilk  Modified Insert___,Update___,Check_Common___,Check_Delete___ to validate address_type_code
--  210127  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods New
--  210303  Smallk  FISPRING20-8769, Merged LCS Bug 157213.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Def_Address___ (
   company_            IN company_address_type_tab.company%TYPE,
   address_type_code_  IN company_address_type_tab.address_type_code%TYPE,
   def_address_        IN company_address_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   dummy_   company_address_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion) AS objversion
      FROM   company_address_tab a, company_address_type_tab b
      WHERE  a.company           = b.company
      AND    a.address_id        = b.address_id
      AND    b.company           = company_   
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
         UPDATE company_address_type_tab
         SET    def_address = 'FALSE'
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


PROCEDURE Get_Company_Party___ (
   newrec_ IN OUT company_address_type_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Company_API.Get_Party(newrec_.company);
      Client_SYS.Add_To_Attr('PARTY', newrec_.party, attr_);
   END IF;
END Get_Company_Party___;


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
   newrec_     IN OUT company_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Company_Address_API.Public_Rec;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);   
BEGIN
   Get_Company_Party___(newrec_, attr_);
   super(objid_, objversion_, newrec_, attr_);
   address_rec_ := Company_Address_API.Get(newrec_.company, newrec_.address_id);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.company, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.company, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
END Insert___;


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


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_address_type_tab%ROWTYPE,
   newrec_ IN OUT company_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     company_address_type_tab%ROWTYPE,
   newrec_ IN OUT company_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   address_rec_             Company_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);   
   is_invalid_address_      BOOLEAN;   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_rec_         := Company_Address_API.Get(newrec_.company, newrec_.address_id);
   address_type_code_   := Address_Type_Code_API.Decode(newrec_.address_type_code);
   is_invalid_address_  := INSTR(Address_Type_Code_API.Get_Addr_Typs_For_Party_Type(Party_Type_API.DB_COMPANY), newrec_.address_type_code) = 0;
   IF (is_invalid_address_) THEN
      Error_SYS.Record_General(lu_name_, 'ADDRTYPINV: Address type :P1 is invalid for :P2.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_COMPANY));
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.company, newrec_.address_id, newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.company, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_COMPANY), newrec_.company);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN company_address_type_tab%ROWTYPE )
IS
   address_rec_             Company_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (company_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   company_address_type
      WHERE  company = company_
      AND    address_id = address_id_;
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(remrec_.address_type_code);
   address_rec_ := Company_Address_API.Get(remrec_.company,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.company, remrec_.address_id, remrec_.address_type_code);
   OPEN get_count(remrec_.company, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.company, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_COMPANY), remrec_.company);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of :P2 :P3. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, Party_Type_API.Decode(Party_Type_API.DB_COMPANY), remrec_.company);
   END IF;     
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Raise_Record_Not_Exist___ (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DEFADDTYPECHECK: The Address Type :P1 does not exist for the Address Identity.', Address_Type_Code_API.Decode(address_type_code_));
   super(company_, address_id_, address_type_code_);
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_address_type_tab%ROWTYPE,
   newrec_     IN OUT company_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Company_Address_API.Public_Rec;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);   
BEGIN
   address_rec_ := Company_Address_API.Get(newrec_.company, newrec_.address_id);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.company, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.company, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Def_Address_Exist(
   validation_result_    OUT VARCHAR2,
   validation_flag_      OUT VARCHAR2,
   company_              IN  company_address_type_tab.company%TYPE,                      
   def_address_          IN  company_address_type_tab.def_address%TYPE,
   address_type_code_    IN  company_address_type_tab.address_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
   CURSOR def_addr_exist IS
      SELECT 1
      FROM   company_address_tab a, company_address_type_tab b
      WHERE  a.company           = b.company
      AND    a.address_id        = b.address_id
      AND    b.company           = company_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_Sys.Get_First_Calendar_Date())<=NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())<NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_Sys.Get_First_Calendar_Date()))));
   CURSOR get_def IS
      SELECT b.def_address
      FROM   company_address_type_tab b
      WHERE  b.company             = company_
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
   company_           IN company_address_type_tab.company%TYPE,
   address_type_code_ IN company_address_type_tab.address_type_code%TYPE,
   def_address_       IN company_address_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS
BEGIN
   Check_Def_Address___(company_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


@UncheckedAccess
FUNCTION Is_Default (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   company_address_type_tab
      WHERE  company = company_
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
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF (Check_Exist___(company_, address_id_, Address_Type_Code_API.Encode(address_type_code_)))
   THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   newrec_      company_address_type_tab%ROWTYPE;
BEGIN
   newrec_.company            := company_;
   newrec_.address_id         := address_id_;
   newrec_.address_type_code  := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address        := 'TRUE';
   newrec_.default_domain     := 'TRUE';
   New___(newrec_);
END New;


-- This method is to be used by Aurena
PROCEDURE New (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_      company_address_type_tab%ROWTYPE;
BEGIN
   newrec_.company            := company_;
   newrec_.address_id         := address_id_;
   newrec_.address_type_code  := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address        := def_address_;
   newrec_.default_domain     := 'FALSE';
   New___(newrec_);
END New;


PROCEDURE Remove (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   remrec_      company_address_type_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   remrec_ := Lock_By_Keys___(company_, address_id_, address_type_code_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


FUNCTION Default_Exist (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT 1
      FROM   company_address_type_tab a, company_address_tab b
      WHERE  a.company = company_
      AND    a.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    a.company = b.company
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
FUNCTION Get_Company_Address_Id (
   company_           IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_type_code_db_ company_address_type_tab.address_type_code%TYPE;
   address_id_           company_address_type_tab.address_id%TYPE;
   CURSOR get_def_addr_id IS
      SELECT a.address_id
      FROM   company_address_type_tab a, company_address_tab b
      WHERE  a.company = company_
      AND    a.address_type_code =address_type_code_db_
      AND    a.company = b.company
      AND    a.address_id = b.address_id
      AND    a.def_address = def_address_
      AND    ((TRUNC(current_date_) >= NVL(b.VALID_FROM,Database_Sys.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.VALID_TO,Database_Sys.Get_Last_Calendar_Date())));
BEGIN
   address_type_code_db_:=Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_def_addr_id ;
   FETCH get_def_addr_id INTO address_id_;
   CLOSE get_def_addr_id ;
   RETURN address_id_;
END Get_Company_Address_Id;


@UncheckedAccess
FUNCTION Get_Document_Address (
   company_      IN VARCHAR2,
   current_date_ IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_id_ company_address_type_tab.address_id%TYPE;
   CURSOR get_default IS
      SELECT a.address_id
      FROM   company_address_type_tab a, company_address_tab b
      WHERE  a.company = company_
      AND    a.address_type_code = 'INVOICE'
      AND    a.company = b.company
      AND    a.address_id = b.address_id
      AND    a.def_address = 'TRUE'
      AND    ((TRUNC(current_date_) >= NVL(b.VALID_FROM,Database_Sys.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.VALID_TO,Database_Sys.Get_Last_Calendar_Date())));
   CURSOR get_address IS
      SELECT MIN(address_id)
	   FROM   company_address_type_tab
      WHERE  company = company_
      AND    address_type_code = 'INVOICE';
BEGIN
   OPEN get_default;
   FETCH get_default INTO address_id_;
   IF (get_default%FOUND) THEN
      CLOSE get_default;
      RETURN address_id_;
   END IF;
   CLOSE get_default;
   OPEN get_address;
   FETCH get_address INTO address_id_;
   IF (get_address%NOTFOUND) THEN
      CLOSE get_address;
      RETURN NULL;
   ELSE
      CLOSE get_address;
      RETURN address_id_;
   END IF;
END Get_Document_Address;


@UncheckedAccess
FUNCTION Document_Address_Exist (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_doc_add_exist IS
      SELECT 1 
      FROM   company_address_type_tab t
      WHERE  t.company = company_
      AND    t.address_id = address_id_
      AND    t.address_type_code = 'INVOICE';
   temp_ VARCHAR2(5);
BEGIN
   OPEN get_doc_add_exist;
   FETCH get_doc_add_exist INTO temp_;
   IF (get_doc_add_exist%FOUND) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
   CLOSE get_doc_add_exist;   
END Document_Address_Exist;


--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);  
   addr_types_       VARCHAR2(1000);
   addr_types_table_ DBMS_UTILITY.UNCL_ARRAY;
   addr_types_count_ BINARY_INTEGER;
BEGIN
   addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('COMPANY');
   IF (addr_types_ IS NOT NULL) THEN
      DBMS_UTILITY.COMMA_TO_TABLE(addr_types_, addr_types_count_, addr_types_table_);
      FOR addr_type_ IN 1 .. addr_types_count_ LOOP
         def_exist_ := Default_Exist(company_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))));
         IF (def_exist_ = 'TRUE') THEN
            def_address_ := 'FALSE';
         ELSE
            def_address_ := 'TRUE';
         END IF;
         New(company_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))), def_address_);
      END LOOP;
   END IF;
END Add_Default_Address_Types;

