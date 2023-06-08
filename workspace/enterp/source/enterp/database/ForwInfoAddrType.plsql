-----------------------------------------------------------------------------
--
--  Logical unit: ForwInfoAddrType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981124  Camk    Created
--  990920  LiSv    Client_SYS.Add_To_Attr in Prepare_Insert moved to Unpack_Check_Insert.
--                  This is done for minimizing db calls from client.
--  000306  Mnisse  Call #34257, default address
--  010313  Lmco    Bug #18484 Def_Address value = 'TRUE'
--                  (990920 LiSv  unmarked in Prepare_Insert___)
--  030205  UdGnlk  Added Public function Get_Forwarder_Address_Id.
--  030702  ChFolk  Modified function Get_Forwarder_Address_Id. Modified the length of the variable address_id_ to VARCHAR2(50).
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___().
--  131108  Isuklk  PBFI-2162 Refactoring and Split ForwInfoAddrType.entit
--  141122  AmThlk  Modified Check_Insert___ to validate default_address_type 
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  181129  thjilk  Modified Insert___,Update___,Check_Common___,Check_Delete___ to validate address_type_code
--  210205  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in New methods
--  210303  Smallk  FISPRING20-8769, Merged LCS Bug 157213. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Def_Address___ (
   forwarder_id_       IN forw_info_addr_type_tab.forwarder_id%TYPE,
   address_type_code_  IN forw_info_addr_type_tab.address_type_code%TYPE,
   def_address_        IN forw_info_addr_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   oldrec_ forw_info_addr_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion) AS objversion 
      FROM   forwarder_info_address_tab a,forw_info_addr_type_tab b
      WHERE  a.forwarder_id      = b.forwarder_id
      AND    a.address_id        = b.address_id
      AND    b.forwarder_id      = forwarder_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_SYS.Get_First_Calendar_Date())<=NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())<NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_SYS.Get_First_Calendar_Date()))));
BEGIN
   IF (def_address_  = 'TRUE') THEN
      FOR d IN def_addr LOOP         
         oldrec_ := Lock_By_Id___(d.ROWID, d.objversion);
         UPDATE forw_info_addr_type_tab
         SET    def_address = 'FALSE'
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


PROCEDURE Get_Forwarder_Party___ (
   newrec_ IN OUT forw_info_addr_type_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Forwarder_Info_API.Get_Party(newrec_.forwarder_id);      
   END IF;
END Get_Forwarder_Party___;


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
   newrec_     IN OUT forw_info_addr_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Forwarder_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   Get_Forwarder_Party___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Forwarder_Info_Address_API.Get(newrec_.forwarder_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.forwarder_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.forwarder_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     forw_info_addr_type_tab%ROWTYPE,
   newrec_     IN OUT forw_info_addr_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Forwarder_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Forwarder_Info_Address_API.Get(newrec_.forwarder_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.forwarder_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.forwarder_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT forw_info_addr_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.default_domain := 'TRUE';
   super(newrec_, indrec_, attr_);        
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     forw_info_addr_type_tab%ROWTYPE,
   newrec_ IN OUT forw_info_addr_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   address_rec_             Forwarder_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   is_invalid_address_      BOOLEAN;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_type_code_   := Address_Type_Code_API.Decode(newrec_.address_type_code);
   is_invalid_address_  := INSTR(Address_Type_Code_API.Get_Addr_Typs_For_Party_Type(Party_Type_API.DB_FORWARDING_AGENT), newrec_.address_type_code) = 0;
   IF (is_invalid_address_) THEN
      Error_SYS.Record_General(lu_name_, 'ADDRTYPINV: Address type :P1 is invalid for :P2.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_FORWARDING_AGENT));
   END IF;
   address_rec_ := Forwarder_Info_Address_API.Get(newrec_.forwarder_id, newrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.forwarder_id, newrec_.address_id, newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.forwarder_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_FORWARDING_AGENT), newrec_.forwarder_id);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     forw_info_addr_type_tab%ROWTYPE,
   newrec_ IN OUT forw_info_addr_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN forw_info_addr_type_tab%ROWTYPE )
IS
   address_rec_             Forwarder_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (forwarder_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   forw_info_addr_type
      WHERE  forwarder_id = forwarder_id_
      AND    address_id = address_id_; 
BEGIN  
   address_type_code_ := Address_Type_Code_API.Decode(remrec_.address_type_code);
   address_rec_ := Forwarder_Info_Address_API.Get(remrec_.forwarder_id,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.forwarder_id, remrec_.address_id, remrec_.address_type_code);
   OPEN get_count(remrec_.forwarder_id, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.forwarder_id, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_FORWARDING_AGENT), remrec_.forwarder_id);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of :P2 :P3. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, Party_Type_API.Decode(Party_Type_API.DB_FORWARDING_AGENT), remrec_.forwarder_id);
   END IF;     
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Def_Address_Exist (
   validation_result_    OUT VARCHAR2,
   validation_flag_      OUT VARCHAR2,
   forwarder_id_         IN  forw_info_addr_type_tab.forwarder_id%TYPE,                   
   def_address_          IN  forw_info_addr_type_tab.def_address%TYPE,
   address_type_code_    IN  forw_info_addr_type_tab.address_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
   CURSOR def_addr_exist IS
      SELECT 1
      FROM   forwarder_info_address_tab a, forw_info_addr_type_tab b
      WHERE  a.forwarder_id      = b.forwarder_id
      AND    a.address_id        = b.address_id
      AND    b.forwarder_id      = forwarder_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_SYS.Get_First_Calendar_Date())<=NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())<NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_SYS.Get_First_Calendar_Date()))));
   CURSOR get_def IS
      SELECT b.def_address
      FROM   forw_info_addr_type_tab b
      WHERE  b.forwarder_id        = forwarder_id_
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
   forwarder_id_      IN forw_info_addr_type_tab.forwarder_id%TYPE,
   address_type_code_ IN forw_info_addr_type_tab.address_type_code%TYPE,
   def_address_       IN forw_info_addr_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS

BEGIN
   Check_Def_Address___(forwarder_id_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


@UncheckedAccess
FUNCTION Is_Default (
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   forw_info_addr_type
      WHERE  forwarder_id = forwarder_id_
      AND    address_id = address_id_
      AND    address_type_code_db = db_value_;
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
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(forwarder_id_, address_id_, address_type_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   newrec_     forw_info_addr_type_tab%ROWTYPE;
BEGIN
   newrec_.forwarder_id       := forwarder_id_;
   newrec_.address_id         := address_id_;
   newrec_.address_type_code  := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address        := 'TRUE';
   newrec_.default_domain     := 'TRUE';
   New___(newrec_);   
END New;


PROCEDURE Remove (
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   remrec_     forw_info_addr_type_tab%ROWTYPE;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, forwarder_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


FUNCTION Default_Exist (
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT 1
      FROM   forw_info_addr_type_tab a, forwarder_info_address_tab b
      WHERE  a.forwarder_id = forwarder_id_
      AND    a.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    a.forwarder_id = b.forwarder_id
      AND    a.address_id = b.address_id
      AND    a.def_address = 'TRUE'
      AND    ((TRUNC(current_date_) >= NVL(b.valid_from,Database_SYS.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.valid_to,Database_SYS.Get_Last_Calendar_Date())));
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


-- Get_Forwarder_Address_Id
--   Returns the AddressId for a given forwarder
--   Returns the AddressId for a given forwarder
FUNCTION Get_Forwarder_Address_Id (
   forwarder_id_      IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_type_code_db_  VARCHAR2(20);
   address_id_            VARCHAR2(50);
   CURSOR get_def_addr_id IS
      SELECT a.address_id 
      FROM   forw_info_addr_type_tab a, forwarder_info_address_tab b 
      WHERE  a.forwarder_id = forwarder_id_
      AND    a.address_type_code = address_type_code_db_
      AND    a.forwarder_id = b.forwarder_id
      AND    a.address_id = b.address_id
      AND    a.def_address = def_address_
      AND    ((TRUNC(current_date_) >= NVL(b.VALID_FROM,Database_SYS.Get_First_Calendar_Date())) AND (TRUNC(current_date_) <= NVL(b.VALID_TO,Database_SYS.Get_Last_Calendar_Date())));
BEGIN
   address_type_code_db_:=Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_def_addr_id ;
   FETCH get_def_addr_id INTO address_id_;
   CLOSE get_def_addr_id ;
   RETURN address_id_;
END Get_Forwarder_Address_Id;


--This method is to be used in Aurena
PROCEDURE New (
   forwarder_id_      IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_     forw_info_addr_type_tab%ROWTYPE;
BEGIN
   newrec_.forwarder_id       := forwarder_id_;
   newrec_.address_id         := address_id_;
   newrec_.address_type_code  := Address_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address        := def_address_;
   newrec_.default_domain     := 'TRUE';
   New___(newrec_);   
END New;


--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   forwarder_id_  IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);  
   addr_types_       VARCHAR2(1000);
   addr_types_table_ DBMS_UTILITY.UNCL_ARRAY;
   addr_types_count_ BINARY_INTEGER;
BEGIN
   addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('FORWARDER');
   IF (addr_types_ IS NOT NULL) THEN
      DBMS_UTILITY.COMMA_TO_TABLE(addr_types_, addr_types_count_, addr_types_table_);
      FOR addr_type_ IN 1 .. addr_types_count_ LOOP
         def_exist_ := Default_Exist(forwarder_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))));
         IF (def_exist_ = 'TRUE') THEN
            def_address_ := 'FALSE';
         ELSE
            def_address_ := 'TRUE';
         END IF;
         New(forwarder_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))), def_address_);
      END LOOP;
   END IF;
END Add_Default_Address_Types;

