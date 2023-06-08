-----------------------------------------------------------------------------
--
--  Logical unit: TaxOfficeAddrType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030128  Machlk  Created.
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___(
--  141122  AmThlk  Modified Check_Insert___ to validate default_address_type 
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  181129  thjilk  Modified Insert___,Update___,Check_Common___,Check_Delete___ to validate address_type_code
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New method
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Def_Address___ (
   tax_office_id_      IN tax_office_addr_type_tab.tax_office_id%TYPE,
   address_type_code_  IN tax_office_addr_type_tab.tax_office_addr_type_code%TYPE,
   def_address_        IN tax_office_addr_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   dummy_   tax_office_addr_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion,'YYYYMMDDHH24MISS') AS objversion
      FROM   tax_office_info_address_tab a, tax_office_addr_type_tab b
      WHERE  a.tax_office_id             = b.tax_office_id
      AND    a.address_id                = b.address_id
      AND    b.tax_office_id             = tax_office_id_   
      AND    b.tax_office_addr_type_code = UPPER(address_type_code_)
      AND    b.def_address               = 'TRUE'
      AND    b.ROWID||''                 <>  NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_SYS.Get_First_Calendar_Date())<=NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))) 
                OR ((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())<NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))
                AND (NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_SYS.Get_First_Calendar_Date()))));
BEGIN
   IF (def_address_  = 'TRUE') THEN
      FOR d IN def_addr LOOP
         dummy_ := Lock_By_Id___(d.ROWID, d.objversion);
         UPDATE tax_office_addr_type_tab
         SET    def_address = 'FALSE'
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT tax_office_addr_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN   
   newrec_.default_domain := 'TRUE';   
   super(newrec_, indrec_, attr_);  
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     tax_office_addr_type_tab%ROWTYPE,
   newrec_ IN OUT tax_office_addr_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   address_rec_             Tax_Office_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(newrec_.tax_office_addr_type_code);
   address_rec_ := Tax_Office_Info_Address_API.Get(newrec_.tax_office_id, newrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.tax_office_id, newrec_.address_id, newrec_.tax_office_addr_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.tax_office_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for Tax Office :P2. If removed, there will be no default address for this Address Type.', address_type_code_, newrec_.tax_office_id);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN tax_office_addr_type_tab%ROWTYPE )
IS
   address_rec_             Tax_Office_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (tax_office_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   tax_office_addr_type
      WHERE  tax_office_id = tax_office_id_
      AND    address_id = address_id_; 
BEGIN  
   address_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(remrec_.tax_office_addr_type_code);
   address_rec_ := Tax_Office_Info_Address_API.Get(remrec_.tax_office_id,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.tax_office_id, remrec_.address_id, remrec_.tax_office_addr_type_code);
   OPEN get_count(remrec_.tax_office_id, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.tax_office_id, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRTYPE: This is the default :P1 Address Type for Tax Office :P2. If removed, there will be no default address for this Address Type.', address_type_code_, remrec_.tax_office_id);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of Tax Office :P2. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, remrec_.tax_office_id);
   END IF;     
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT tax_office_addr_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Tax_Office_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   address_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(newrec_.tax_office_addr_type_code);
   address_rec_ := Tax_Office_Info_Address_API.Get(newrec_.tax_office_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.tax_office_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.tax_office_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     tax_office_addr_type_tab%ROWTYPE,
   newrec_     IN OUT tax_office_addr_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Tax_Office_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   address_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(newrec_.tax_office_addr_type_code);
   address_rec_ := Tax_Office_Info_Address_API.Get(newrec_.tax_office_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.tax_office_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.tax_office_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Def_Address_Exist (
   validation_result_    OUT VARCHAR2,
   validation_flag_      OUT VARCHAR2,
   tax_office_id_        IN  tax_office_addr_type_tab.tax_office_id%TYPE,                   
   def_address_          IN  tax_office_addr_type_tab.def_address%TYPE,
   address_type_code_    IN  tax_office_addr_type_tab.tax_office_addr_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
    CURSOR def_addr_exist IS
      SELECT 1
      FROM   tax_office_info_address_tab a, tax_office_addr_type_tab b
      WHERE  a.tax_office_id             =  b.tax_office_id
      AND    a.address_id                =  b.address_id
      AND    b.tax_office_id             =  tax_office_id_   
      AND    b.tax_office_addr_type_code =  UPPER(address_type_code_)
      AND    b.def_address               =  'TRUE'
      AND    b.ROWID||''                 <>  NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_SYS.Get_First_Calendar_Date())<=NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))) 
                OR ((NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())<NVL(valid_to_,Database_SYS.Get_Last_Calendar_Date()))
                AND (NVL(a.valid_to,Database_SYS.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_SYS.Get_First_Calendar_Date()))));
    CURSOR get_def IS
       SELECT b.def_address
       FROM   tax_office_addr_type_tab b
       WHERE  b.tax_office_id               = tax_office_id_
       AND    b.tax_office_addr_type_code   = UPPER(address_type_code_)
       AND    b.ROWID||''                   = NVL(objid_,CHR(0));
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
   tax_office_id_     IN tax_office_addr_type_tab.tax_office_id%TYPE,
   address_type_code_ IN tax_office_addr_type_tab.tax_office_addr_type_code%TYPE,
   def_address_       IN tax_office_addr_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS

BEGIN
   Check_Def_Address___(tax_office_id_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


FUNCTION Is_Default (
   tax_office_id_             IN VARCHAR2,
   address_id_                IN VARCHAR2,
   tax_office_addr_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   tax_office_addr_type
      WHERE  tax_office_id = tax_office_id_
      AND    address_id = address_id_
      AND    tax_office_addr_type_code_db = db_value_;
BEGIN
   db_value_ := Address_Type_Code_API.Encode(tax_office_addr_type_code_);
   OPEN get_default;
   FETCH get_default INTO def_address_;
   IF (get_default%NOTFOUND) THEN
      CLOSE get_default;
      RETURN 'FALSE';
   END IF;
   CLOSE get_default;
   RETURN def_address_;
END Is_Default;


FUNCTION Default_Exist (
   tax_office_id_             IN VARCHAR2,
   address_id_                IN VARCHAR2,
   tax_office_addr_type_code_ IN VARCHAR2,
   current_date_              IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
  CURSOR get_default IS
      SELECT 1
      FROM   tax_office_addr_type_tab a,tax_office_info_address_tab b
      WHERE  a.tax_office_id             = tax_office_id_
      AND    a.tax_office_addr_type_code = UPPER(tax_office_addr_type_code_)
      AND    a.tax_office_id             = b.tax_office_id
      AND    a.address_id                = b.address_id
      AND    a.def_address               = 'TRUE'
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


@UncheckedAccess
FUNCTION Get_Tax_Office_Addr_Type_Code (
   tax_office_id_             IN VARCHAR2,
   address_id_                IN VARCHAR2,
   tax_office_addr_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ tax_office_addr_type_tab.tax_office_addr_type_code%TYPE;
   CURSOR get_attr IS
      SELECT tax_office_addr_type_code
      FROM   tax_office_addr_type_tab
      WHERE  tax_office_id             = tax_office_id_
      AND    address_id                = address_id_
      AND    tax_office_addr_type_code = Tax_Office_Addr_Type_Code_API.Encode(tax_office_addr_type_code_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Tax_Office_Addr_Type_Code_API.Decode(temp_);
END Get_Tax_Office_Addr_Type_Code;


-- This method is to be used by Aurena
PROCEDURE New (
   tax_office_id_     IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_      tax_office_addr_type_tab%ROWTYPE;
BEGIN
   newrec_.tax_office_id             := tax_office_id_;
   newrec_.address_id                := address_id_;
   newrec_.tax_office_addr_type_code := Tax_Office_Addr_Type_Code_API.Encode(address_type_code_);
   newrec_.def_address               := def_address_;
   New___(newrec_);
END New;


--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   tax_office_id_     IN VARCHAR2,
   address_id_        IN VARCHAR2 )
IS
   def_exist_      VARCHAR2(5);
   def_address_    VARCHAR2(5);
   addr_type_code_ VARCHAR2(200);
BEGIN
   FOR counter_ IN 1..2 LOOP
      IF (counter_ = 1) THEN
         addr_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(Tax_Office_Addr_Type_Code_API.DB_DOCUMENT);
      ELSIF (counter_ = 2) THEN
         addr_type_code_ := Tax_Office_Addr_Type_Code_API.Decode(Tax_Office_Addr_Type_Code_API.DB_VISIT);
      END IF;
      def_exist_ := Default_Exist(tax_office_id_, address_id_, addr_type_code_);
      IF (def_exist_ = 'TRUE') THEN
         def_address_ := 'FALSE';
      ELSE
         def_address_ := 'TRUE';
      END IF;
      New(tax_office_id_, address_id_, addr_type_code_, def_address_);
   END LOOP;
END Add_Default_Address_Types;

