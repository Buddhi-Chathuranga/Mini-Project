-----------------------------------------------------------------------------
--
--  Logical unit: PersonInfoAddressType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981125  Camk    Created
--  990415  Camk    New template
--  990920  LiSv    Client_SYS.Add_To_Attr in Prepare_Insert moved to Unpack_Check_Insert.
--                  This is done for minimizing db calls from client.
--  000306  Mnisse  Call #34257, default address
--  010313  Lmco    Bug #18484 Def_Address value = 'TRUE'
--                  (990920 LiSv  unmarked in Prepare_Insert___)
--  061121  Kagalk  B139464, Modified New, to set def_address as TRUE when the first address
--  061122          is entered.
--  080813  Jakalk  Bug 49697, Modified public get methods, so that the protected data is not shown to unauthorized users.
--  080826  Shdilk  Bug 74737, Added New, Modify methods.
--  091117  Chgulk  bug 85354, Modify Check_Def_Address___(), and Add new Procedure's Check_Def_Address_Exist__()/
--  091117          Check_Def_Addr_Temp__(), to set the Default address by Checking the Valid Address ID periods.
--  091117          Remove procedure call Check_Def_Address___() from Insert___()/Update___() 
--  110720  Mohrlk  FIDEAGLE-179, Replaced User with Fnd_Session_API.Get_Fnd_User
--  140416  Pkurlk  PBFI-6528, Merged bug 116101.
--  141122  AmThlk  Modified Check_Insert___ to validate default_address_type 
--	 160104	Chwtlk  STRFI-948, Merge of LCS Bug 126544, Modified Check_Update___().
--  180222  AmThLK  STRFI-11475, Merged Bug 139801
--  180518  thjilk  FIUXXW2-123 Added Client_SYS warnings to Check_Common___ and Check_Delete___
--  180606  thjilk  FIUXXW2-123 Added conditions to check for Fnd_Session_API.Is_Odp_Session to Check_Common___ and Check_Delete___
--  200908  thmulk  HCSPRING20-6855, Modified Insert___ to add payroll integration logic in HCM.
--  201012  pabnlk  HCSPRING20-7357, Removed 'Check_Exist_Any_Request' method and it's references.
--  210303  Smallk  FISPRING20-8769, Merged LCS Bug 157213. 
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New and Modify methods.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Access___ (
   person_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS 
BEGIN
   IF ((Party_Admin_User_API.Exist_Current_User) OR 
      (Person_Info_API.Is_Protected(person_id_) = 'FALSE') OR
      (Fnd_Session_API.Get_Fnd_User = Person_Info_API.Get_User_Id(person_id_))) THEN
      RETURN TRUE;
   END IF;   
   RETURN FALSE;
END Check_Access___;


PROCEDURE Check_Def_Address___ (
   person_id_          IN person_info_address_type_tab.person_id%TYPE,
   address_type_code_  IN person_info_address_type_tab.address_type_code%TYPE,
   def_address_        IN person_info_address_type_tab.def_address%TYPE,
   objid_              IN VARCHAR2,
   valid_from_         IN DATE,
   valid_to_           IN DATE )
IS
   dummy_   person_info_address_type_tab%ROWTYPE;
   CURSOR def_addr IS
      SELECT b.ROWID, TO_CHAR(b.rowversion) AS objversion
      FROM   person_info_address_tab a, person_info_address_type_tab b
      WHERE  a.person_id         = b.person_id
      AND    a.address_id        = b.address_id
      AND    b.person_id         = person_id_   
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
         UPDATE person_info_address_type_tab
         SET    def_address = 'FALSE'
         WHERE  ROWID       = d.ROWID;
      END LOOP;
   END IF;
END Check_Def_Address___;


PROCEDURE Get_Person_Party___ (
   newrec_ IN OUT person_info_address_type_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Person_Info_API.Get_Party(newrec_.person_id);      
   END IF;
END Get_Person_Party___;


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
   newrec_     IN OUT person_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   address_rec_             Person_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   Get_Person_Party___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Person_Info_Address_API.Get(newrec_.person_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.person_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.person_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;   
   $IF Component_Person_SYS.INSTALLED $THEN
      Cloud_Pay_Employee_Util_API.Send_New_Address(lu_name_, objid_, newrec_, 'ADDRESS');
   $END
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT person_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.default_domain := 'TRUE';
   super(newrec_, indrec_, attr_);      
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     person_info_address_type_tab%ROWTYPE,
   newrec_ IN OUT person_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   address_rec_             Person_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   is_invalid_address_      BOOLEAN;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   address_type_code_   := Address_Type_Code_API.Decode(newrec_.address_type_code);
   is_invalid_address_  := INSTR(Address_Type_Code_API.Get_Addr_Typs_For_Party_Type(Party_Type_API.DB_PERSON), newrec_.address_type_code) = 0;
   IF (is_invalid_address_) THEN
      Error_SYS.Record_General(lu_name_, 'ADDRTYPINV: Address type :P1 is invalid for :P2.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_PERSON));
   END IF;
   address_rec_ := Person_Info_Address_API.Get(newrec_.person_id, newrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.person_id, newrec_.address_id, newrec_.address_type_code);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.person_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', address_type_code_);
   END IF;
   IF (newrec_.def_address = 'FALSE' AND (validation_flag_ = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_PERSON), newrec_.person_id);
   END IF; 
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     person_info_address_type_tab%ROWTYPE,
   newrec_ IN OUT person_info_address_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);   
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN person_info_address_type_tab%ROWTYPE )
IS
   address_rec_             Person_Info_Address_API.Public_Rec;
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   address_type_code_       VARCHAR2(20);
   add_type_count_          NUMBER;
   CURSOR get_count (person_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*) 
      FROM   person_info_address_type
      WHERE  person_id = person_id_
      AND    address_id = address_id_; 
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(remrec_.address_type_code);
   address_rec_ := Person_Info_Address_API.Get(remrec_.person_id,  remrec_.address_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.person_id, remrec_.address_id, remrec_.address_type_code);
   OPEN get_count(remrec_.person_id, remrec_.address_id);
   FETCH get_count INTO add_type_count_;
   CLOSE get_count;
   IF (remrec_.def_address = 'TRUE') THEN
      Check_Def_Address_Exist(validation_result_, validation_flag_, remrec_.person_id, remrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
      IF (validation_result_ = 'TRUE') THEN
         Client_SYS.Clear_Info();
         Client_SYS.Add_Warning(lu_name_, 'REMOVEADDTYPE: This is the default :P1 Address Type for :P2 :P3. If removed, there will be no default address for this Address Type.', address_type_code_, Party_Type_API.Decode(Party_Type_API.DB_PERSON), remrec_.person_id);
      END IF;
   END IF;
   IF (add_type_count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVELASTADDTYPE: This is the last address type for address identity :P1 of :P2 :P3. If removed, there will not be any address type(s) for this address ID.', remrec_.address_id, Party_Type_API.Decode(Party_Type_API.DB_PERSON), remrec_.person_id);
   END IF;     
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     person_info_address_type_tab%ROWTYPE,
   newrec_     IN OUT person_info_address_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   address_rec_             Person_Info_Address_API.Public_Rec;
   address_type_code_       VARCHAR2(20);
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
BEGIN
   address_type_code_ := Address_Type_Code_API.Decode(newrec_.address_type_code);
   address_rec_ := Person_Info_Address_API.Get(newrec_.person_id, newrec_.address_id);
   Check_Def_Address_Exist(validation_result_, validation_flag_, newrec_.person_id, newrec_.def_address, address_type_code_, objid_, address_rec_.valid_from, address_rec_.valid_to);
   IF (newrec_.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
      Check_Def_Addr_Temp(newrec_.person_id, address_type_code_, newrec_.def_address, objid_, address_rec_.valid_from, address_rec_.valid_to);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Def_Address_Exist (
   validation_result_    OUT VARCHAR2,
   validation_flag_      OUT VARCHAR2,
   person_id_            IN  person_info_address_type_tab.person_id%TYPE,                   
   def_address_          IN  person_info_address_type_tab.def_address%TYPE,
   address_type_code_    IN  person_info_address_type_tab.address_type_code%TYPE,
   objid_                IN  VARCHAR2,
   valid_from_           IN  DATE,
   valid_to_             IN  DATE )
IS
   CURSOR def_addr_exist IS
      SELECT 1
      FROM   person_info_address_tab a, person_info_address_type_tab b
      WHERE  a.person_id         = b.person_id
      AND    a.address_id        = b.address_id
      AND    b.person_id         = person_id_   
      AND    b.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    b.def_address       = 'TRUE'
      AND    b.ROWID||''         <> NVL(objid_,CHR(0))
      AND    (((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>= NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date())) 
                AND (NVL(a.valid_from,Database_Sys.Get_First_Calendar_Date())<=NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))) 
                OR((NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())<NVL(valid_to_,Database_Sys.Get_Last_Calendar_Date()))
                AND(NVL(a.valid_to,Database_Sys.Get_Last_Calendar_Date())>=NVL(valid_from_,Database_Sys.Get_First_Calendar_Date()))));
   CURSOR get_def IS
      SELECT b.def_address
      FROM   person_info_address_type_tab b
      WHERE  b.person_id           = person_id_
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
   person_id_         IN person_info_address_type_tab.person_id%TYPE,
   address_type_code_ IN person_info_address_type_tab.address_type_code%TYPE,
   def_address_       IN person_info_address_type_tab.def_address%TYPE,
   objid_             IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS
BEGIN
   Check_Def_Address___(person_id_, address_type_code_, def_address_, objid_, valid_from_, valid_to_);  
END Check_Def_Addr_Temp;


@Override
@UncheckedAccess
FUNCTION Get_Party (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_)) THEN      
      RETURN super(person_id_, address_id_, address_type_code_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Party;   


@UncheckedAccess
FUNCTION Is_Default (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_     VARCHAR2(20);
   def_address_  VARCHAR2(5);
   CURSOR get_default IS
      SELECT NVL(def_address,'FALSE')
      FROM   person_info_address_type_tab
      WHERE  person_id = person_id_
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
FUNCTION Is_Work_Default (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT address_type_code
      FROM   person_info_address_type_tab
      WHERE  person_id = person_id_
      AND    address_id = address_id_;
   count_ NUMBER := 0;
   check_ VARCHAR2(5) := 'FALSE';
BEGIN
   FOR t IN get_default LOOP
      IF (count_ > 0) THEN
         RETURN 'FALSE';
      ELSIF (t.address_type_code = 'WORK') THEN
         check_ := 'TRUE';
      END IF;
      count_ := count_ + 1;
   END LOOP;
   RETURN check_;
END Is_Work_Default;


@UncheckedAccess
FUNCTION Check_Exist (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(person_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_))) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   newrec_              person_info_address_type_tab%ROWTYPE;
   count_               NUMBER;
   CURSOR get_address_count IS
      SELECT COUNT(*)
      FROM   person_info_address_type_tab
      WHERE  person_id = person_id_
      AND    address_type_code = Address_Type_Code_API.Encode(address_type_code_);
BEGIN
   newrec_.person_id         := person_id_;
   newrec_.address_id        := address_id_;
   newrec_.address_type_code := Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_address_count;
   FETCH get_address_count INTO count_;
   CLOSE get_address_count;
   IF (count_ = 0) THEN
      newrec_.def_address := 'TRUE';
   ELSE
      newrec_.def_address := 'FALSE';
   END IF;
   newrec_.default_domain := 'TRUE';
   New___(newrec_);
END New;


PROCEDURE New (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_              person_info_address_type_tab%ROWTYPE;
BEGIN
  newrec_.person_id         := person_id_;
  newrec_.address_id        := address_id_;
  newrec_.address_type_code := Address_Type_Code_API.Encode(address_type_code_);
  newrec_.def_address       := def_address_;
  New___(newrec_);
END New;   


PROCEDURE Modify (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   newrec_              person_info_address_type_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(person_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   newrec_.def_address := def_address_;
   Modify___(newrec_);
END Modify;


FUNCTION Default_Exist (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   current_date_      IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_default IS
      SELECT 1
      FROM   person_info_address_type_tab a, person_info_address_tab b
      WHERE  a.person_id = person_id_
      AND    a.address_type_code = Address_Type_Code_API.Encode(address_type_code_)
      AND    a.person_id = b.person_id
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


PROCEDURE Set_Default (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   def_address_       IN VARCHAR2 )
IS
   oldrec_       person_info_address_type_tab%ROWTYPE;
   newrec_       person_info_address_type_tab%ROWTYPE;
   attr_         VARCHAR2(2000);
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_, address_id_, address_type_code_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.def_address := def_address_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Default;

PROCEDURE Modify (
   person_id_         VARCHAR2,
   address_id_        VARCHAR2,
   address_type_code_ VARCHAR2,
   seq_no_            NUMBER,
   attr_              VARCHAR2 )
IS
   info_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   modify_attr_       VARCHAR2(4000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_, address_id_, address_type_code_);
   modify_attr_ := attr_;
   Modify__(info_, objid_, objversion_, modify_attr_, 'DO');
END Modify;


PROCEDURE Remove (
   person_id_         IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2 )
IS
   remrec_      person_info_address_type_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   remrec_ := Lock_By_Keys___(person_id_, address_id_, Address_Type_Code_API.Encode(address_type_code_));
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


FUNCTION Get_Address_Types (
   person_id_    IN VARCHAR2,
   address_id_   IN VARCHAR2,
   default_flag_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   types_   VARCHAR2(2000) := '';
   CURSOR types IS
      SELECT a.*
      FROM   person_info_address_type_tab a, person_info_tab b
      WHERE  a.person_id = person_id_
      AND    address_id  = address_id_
      AND    a.person_id = b.person_id
      AND    Person_Info_Address_API.Check_Access(person_id_, a.address_id, b.user_id, b.protected) = 'TRUE';
BEGIN
   FOR t IN types LOOP 
      IF (Is_Default(t.person_id, t.address_id, Address_Type_Code_API.Decode(t.address_type_code)) = default_flag_) THEN
         types_ := types_ || Address_Type_Code_API.Decode(t.address_type_code) || ', ';
      END IF;
   END LOOP;
   RETURN RTRIM(types_, ', '); 
END Get_Address_Types;

   
--This method is to be used in Aurena
PROCEDURE Add_Default_Address_Types (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);  
   addr_types_       VARCHAR2(1000);
   addr_types_table_ DBMS_UTILITY.UNCL_ARRAY;
   addr_types_count_ BINARY_INTEGER;
BEGIN
   addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('PERSON');
   IF (addr_types_ IS NOT NULL) THEN
      DBMS_UTILITY.COMMA_TO_TABLE(addr_types_, addr_types_count_, addr_types_table_);
      FOR addr_type_ IN 1 .. addr_types_count_ LOOP
         def_exist_ := Default_Exist(person_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))));
         IF (def_exist_ = 'TRUE') THEN
            def_address_ := 'FALSE';
         ELSE
            def_address_ := 'TRUE';
         END IF;
         New(person_id_, address_id_, Address_Type_Code_API.Decode(TRIM(addr_types_table_(addr_type_))), def_address_);
      END LOOP;
   END IF;
END Add_Default_Address_Types;