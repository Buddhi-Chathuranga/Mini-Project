-----------------------------------------------------------------------------
--
--  Logical unit: CommMethod
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090428  Chhulk  Created
--  090603  Chhulk  Bug 83404, Modified Get_Default_Value_Person()
--  090608  Chhulk  Bug 83404, Made the procedure Get_Default_Value_Person() a function. This was a requirement by HR team 
--                             and procedure Get_Default_Value___() with function Get_Default_Distinct_Value___()
--  091111  Yothlk  Bug 86911, Modified ViewComments ref part by adding parameters
--  091120  Chhulk  Bug 87203, Modified CUST_CONTACT_LOV and SUPP_CONTACT_LOV
--  091203  Kanslk  Reverse Engineering, removed reference to PartyTypeAddress from address_id and removed call to Exist() from Unpack_Check_Insert___() and Unpack_Check_Update___().
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  100429  Kagalk  EAFH-2783, Remove Obsolete View Person_Info_Comm_Method_Visit.
--  100713  Chhulk  Bug 90710, Modified Copy_Identity_Info().
--  100913  Chhulk  Bug 91401, Modified Delete___()
--  101011  Chhulk  Bug 93499, Modified Set_Value()
--  110217  Umdolk  EANE-4175, Added new custom delete methods.
--  110519  AsHelk  EASTONE-19202, Corrected Invalid References in view CUSTOMER_INFO_COMM_METHOD.
--  110720  Mohrlk  FIDEAGLE-179, Replaced User with Fnd_Session_API.Get_Fnd_User
--  110905  Umdolk  EASTTWO-11586, Corrected view comments in SUP_VIEW2 and CUSTMR_VIEW2 views.
--  111125  Janblk  EDEL-209, Added new view cust_contact_lov3 and Get_Comm_Id_From_Name
--  111205  Samblk  SFI-1580, merged bug 100194, Added new view only to be used with Solution manager this will bypass  
--                  company person company security for users with Administrator privilege
--  120125  Paralk  SFI-1378, Added Get_Value_For_Sd, to use only in Person Search Domain.
--  120314  Shdilk  EASTRTM-4762, Modified Copy_Identity_Info to copy comm methods which has no address id. With the existing cursor it does not fetch the comm methods witch address id is null.
--  120713  Shdilk  Added Get_Valid_From, Get_Valid_Comm_Id_From_Name.
--  120822  Hiralk  EDEL-1323, Added SUP_LOV_VIEW2.
--  120829  JuKoDE  EDEL-1532, Added General_SYS.Init_Method in Get_Comm_Id_From_Name(), Get_Valid_Comm_Id_From_Name()
--  120912  Swralk  EDEL-1618, Added FUNCTION Get_Comm_Method.
--  120920  Chwilk  Bug 104273, Modified Check_Default.
--  130829  Pkurlk  Bug 111969, Added FUNCTION Comm_Id_Exist.
--  130614  DipeLK  TIBE-726, Removed global variable which used to check the exsistance of PERSON component.
--  130902  Machlk  Bug 111816, Added new method Check_Default with different parameters.
--  131014  Isuklk  CAHOOK-2691 Refactoring in CommMethod.entity
--  140710  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_identity_info().
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from copy_identity_info method.
--  150519  MaIklk  BLU-666, Added Get_Identity_By_Email(), Get_Latest_Modified_Date().
--  150813  MaRalk  BLU-1176, Added method Get_Default_Www in order to use in Customer Contact 360 window header.
--  150803  Chhulk  Bug 122354. Merged correction to App9. Modified Get_Default_Distinct_Value___()
--  150811  Chhulk  Bug 121522, Merged correction to app9. Modified Get_Default_Value() and Get_Default_Distinct_Value___(). Removed Check_Person_Ok___(), 
--                  Is_Protected_Person___() and Check_Work_Only___()
--  160226  DilMlk  Bug 126583, Added new methods Get_Address_Id, Get_Default_Address_Id, Get_Address_Id_By_Method to fetch a distinct 'phone' number
--                  when there are several 'WORK' address types defined for a Person.
--  161110  MaIklk  SCUXX-1031, Added Add_Default_Method().
--  180716  ImBaLK  Bug 143006, Added Get_Default_Selected_Value().
--  180212  Thrplk  Added Get_Default_Email for UXx()
--  180723  KrRaLK  Bug 143126, Added Get_Default_Comm_Id().
--  180624  JanWse  SCUXX-3748, Added public version of Pack_Table___ (Pack_Table)
--  180716  MaIklk  SCUXX-3823, Fixed to use a cursor for loop in Add_Default_Method().
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  190206  ThJilk  Removed check for Fndab1.
--  200608  kusplk  GESPRING20-4690, Added Check_Email_Exist method to support it_xml_invoice.
--  201012  pabnlk  HCSPRING20-7357, Removed 'Check_Exist_Any_Request' method and it's references.
--  210125  MaIklk  CRMZSPPT-118, Used table instead of view in select stmt of Get_Identity_By_Email().
--  210126  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Set_Value, New and Modify   
--  210303  MaIklk  CRM2020R1-1181, Used identity in where clause of Get_Comm_Id_By_Method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_New_Comm_Id___ (
   newrec_ IN OUT comm_method_tab%ROWTYPE )
IS
   CURSOR get_id is
      SELECT NVL(MAX(comm_id), 0) + 1
      FROM   comm_method_tab
      WHERE  party_type = newrec_.party_type
      AND    identity = newrec_.identity;
BEGIN
   OPEN get_id;
   FETCH get_id INTO newrec_.comm_id;
   CLOSE get_id;
END Get_New_Comm_Id___;


PROCEDURE Check_Comm_Method___ (
   newrec_ IN comm_method_tab%ROWTYPE,
   objid_  IN VARCHAR2 )
IS
   dummy1_  VARCHAR2(50);
   dummy2_  VARCHAR2(50);
   -- for both cases - when adress_id is null and not null
   CURSOR check_exist_record IS
      SELECT ROWID, address_id
      FROM   comm_method_tab
      WHERE  name = newrec_.name
      AND    (newrec_.address_id IS NULL AND address_id IS NULL OR address_id = newrec_.address_id)
      AND    value = newrec_.value
      AND    method_id = newrec_.method_id
      AND    party_type = newrec_.party_type
      AND    identity = newrec_.identity;
BEGIN
   OPEN check_exist_record ;
   FETCH check_exist_record INTO dummy1_ , dummy2_;
   IF (check_exist_record%FOUND) THEN
      -- check for a insert and modify
      IF (objid_ IS NULL ) OR ( objid_ IS NOT NULL AND dummy1_ <> objid_) THEN
         -- check for when address_id null and not null
         IF (newrec_.address_id IS NULL AND dummy2_ IS NULL ) OR ( newrec_.address_id = dummy2_) THEN
            CLOSE check_exist_record;
               Error_SYS.Record_General(lu_name_, 'METHODEX: Communication method :P1 with this value already exists for this name and address ID.', newrec_.method_id);
         ELSE
            CLOSE check_exist_record;
         END IF;
      ELSE
         CLOSE check_exist_record;
      END IF;
   ELSE
      CLOSE check_exist_record;
   END IF;
END Check_Comm_Method___;


PROCEDURE Check_Default_Set___ (
   party_type_       IN VARCHAR2,
   identity_         IN VARCHAR2,
   method_id_        IN VARCHAR2,
   address_id_       IN VARCHAR2, 
   valid_from_       IN DATE,    
   valid_to_         IN DATE,    
   method_default_   IN VARCHAR2,
   address_default_  IN VARCHAR2,
   rowid_            IN VARCHAR2 )
IS
   db_value_         comm_method_tab.method_id%TYPE;
   dummy_            NUMBER;
   CURSOR method_default IS 
      SELECT 1
      FROM   comm_method_tab 
      WHERE  party_type   = party_type_
      AND    identity       = identity_
      AND    method_id      = db_value_
      AND    method_default = 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_, Database_SYS.Get_Last_Calendar_Date()) >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()))
      AND    ROWID||'' <> NVL(rowid_,CHR(0));
   CURSOR address_default IS 
      SELECT 1
      FROM   comm_method_tab 
      WHERE  party_type   = party_type_
      AND    identity       = identity_
      AND    method_id      = db_value_
      AND    address_id     = address_id_
      AND    address_default = 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_, Database_SYS.Get_Last_Calendar_Date()) >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()))
      AND    ROWID||'' <> NVL(rowid_,CHR(0));
BEGIN
   db_value_ := NVL(Comm_Method_Code_API.Encode(method_id_), method_id_);
   IF (method_default_ = 'TRUE') THEN
      OPEN method_default;
      FETCH method_default INTO dummy_;
      IF (method_default%FOUND) THEN
         CLOSE method_default;
         Error_SYS.Record_General(lu_name_, 'METHDEFEXIST: There is a value already registered as Default per Method for this time interval.');
      END IF;
      CLOSE method_default;
   END IF;
   IF (address_default_ = 'TRUE') THEN
      IF (address_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ADDDEFIDNULL: Default per Method and Address can only be selected if the row is connected to an Address ID.');   
      ELSE
         OPEN address_default;
         FETCH address_default INTO dummy_;
         IF (address_default%FOUND) THEN
            CLOSE address_default;
            Error_SYS.Record_General(lu_name_, 'ADDDEFEXIST: There is a value already registered as Default per Method and Address for this address and time interval.');
         END IF;
         CLOSE address_default; 
      END IF; 
   END IF;
END Check_Default_Set___;


FUNCTION Check_Meth_Def_Not_Set___ (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   valid_from_ IN DATE,    
   valid_to_   IN DATE,    
   rowid_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_         comm_method_tab.method_id%TYPE;
   dummy_            NUMBER;
   CURSOR no_method_default IS 
      SELECT 1
      FROM   comm_method_tab 
      WHERE  party_type   = party_type_
      AND    identity       = identity_
      AND    method_id      = db_value_
      AND    method_default != 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_, Database_SYS.Get_Last_Calendar_Date()) >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()))
      AND    ROWID||'' <> NVL(rowid_,CHR(0));
BEGIN
   db_value_ := NVL(Comm_Method_Code_API.Encode(method_id_), method_id_);
   OPEN no_method_default;
   FETCH no_method_default INTO dummy_;
   IF (no_method_default%FOUND) THEN
      CLOSE no_method_default;
      RETURN TRUE;
   END IF;
   CLOSE no_method_default;
   RETURN FALSE;
END  Check_Meth_Def_Not_Set___;


FUNCTION Check_Add_Def_Not_Set___ (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   valid_from_ IN DATE,    
   valid_to_   IN DATE,    
   rowid_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_         comm_method_tab.method_id%TYPE;
   dummy_            NUMBER;
   CURSOR address_default IS 
      SELECT 1
      FROM   comm_method_tab 
      WHERE  party_type   = party_type_
      AND    identity       = identity_
      AND    method_id      = db_value_
      AND    address_id     = address_id_
      AND    address_default != 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_, Database_SYS.Get_Last_Calendar_Date()) >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()))
      AND    ROWID||'' <> NVL(rowid_,CHR(0));
BEGIN
   db_value_ := NVL(Comm_Method_Code_API.Encode(method_id_), method_id_);
   OPEN address_default;
   FETCH address_default INTO dummy_;
   IF (address_default%FOUND) THEN
      CLOSE address_default;
      RETURN TRUE;
   END IF;
   CLOSE address_default;
   RETURN FALSE;
END  Check_Add_Def_Not_Set___;


FUNCTION Get_Default_Distinct_Value___ (
   party_type_    IN VARCHAR2,
   identity_      IN VARCHAR2,
   method_id_     IN VARCHAR2,
   address_id_    IN VARCHAR2 DEFAULT NULL,
   date_          IN DATE DEFAULT SYSDATE,
   name_          IN VARCHAR2 DEFAULT NULL )RETURN VARCHAR2
IS
   CURSOR get_method_def IS
      SELECT t.value, t.address_id
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity     = identity_
      AND    t.method_id    = method_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    t.method_default = 'TRUE';
   CURSOR get_address_def IS
      SELECT t.value
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity     = identity_
      AND    t.method_id    = method_id_
      AND    t.address_id   = address_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    t.address_default = 'TRUE';
   CURSOR get_value_with_addr IS
      SELECT t.value
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity     = identity_
      AND    t.method_id    = method_id_
      AND    t.address_id   = address_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date());
   CURSOR get_value_no_addr is
      SELECT t.value
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity     = identity_
      AND    t.method_id    = method_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date());
   retn_value_      comm_method_tab.value%TYPE := NULL; 
   distinct_hit_    VARCHAR2(5) := 'TRUE'; 
   count_           NUMBER;
   temp_addr_       VARCHAR2(50);
BEGIN
   -- Checking permission for person.
   IF (party_type_ = 'PERSON') THEN
      IF ((NOT Person_Info_API.Check_Access(identity_) = 'TRUE') AND (NOT Person_Info_Address_Type_API.Is_Work_Default(identity_, address_id_) = 'TRUE') ) THEN         
         retn_value_   := NULL;
         distinct_hit_ := NULL;
         RETURN NULL;
      END IF;
   END IF;
   IF (address_id_ IS NOT NULL) THEN
      OPEN get_address_def;
      FETCH get_address_def INTO retn_value_;
      IF (get_address_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise check for a row with method_default TRUE.
         count_   := 0;
         FOR row_ IN get_value_with_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            retn_value_ := row_.value;
            count_ := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            retn_value_   := NULL;
            distinct_hit_ := 'FALSE';
            OPEN get_method_def;
            FETCH get_method_def INTO retn_value_, temp_addr_;
            CLOSE get_method_def;
            IF (retn_value_ IS NOT NULL AND temp_addr_ = address_id_ ) THEN
               distinct_hit_ := 'TRUE';
            END IF;
         END IF;
      END IF;
      CLOSE get_address_def;
   ELSE
      OPEN get_method_def;
      FETCH get_method_def INTO retn_value_, temp_addr_;
      IF (get_method_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise null is returned.
         count_   := 0;
         FOR row_ IN get_value_no_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            retn_value_ := row_.value;
            count_ := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            retn_value_   := NULL;
            distinct_hit_ := 'FALSE';
         END IF;
      END IF;
      CLOSE get_method_def;
   END IF;
   IF (distinct_hit_ = 'TRUE') THEN
      RETURN retn_value_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Default_Distinct_Value___;


PROCEDURE Do_Cascade___ (
   identity_      IN VARCHAR2,
   party_type_db_ IN VARCHAR2,
   action_        IN VARCHAR2 )
IS
   info_            VARCHAR2(2000);
   in_identity_     VARCHAR2(20);
   CURSOR get_records IS
      SELECT ROWID       objid,
             TO_CHAR(rowversion,'YYYYMMDDHH24MISS')  objversion
      FROM   comm_method_tab
      WHERE  identity   = in_identity_
      AND    party_type = party_type_db_;
BEGIN
   in_identity_ := SUBSTR(identity_,1,INSTR(identity_,'^',1,1)-1);
   FOR comp_ IN get_records LOOP
      Remove__(info_, comp_.objid, comp_.objversion, action_);
   END LOOP;         
END Do_Cascade___;


PROCEDURE Validate_Default___ (
   def_method_exist_       OUT VARCHAR2,
   def_method_addr_exist_  OUT VARCHAR2,
   identity_               IN  VARCHAR2,
   party_type_db_          IN  VARCHAR2,
   row_id_                 IN  VARCHAR2,
   method_id_              IN  VARCHAR2,
   address_id_             IN  VARCHAR2,
   method_default_         IN  VARCHAR2, 
   address_default_        IN  VARCHAR2, 
   valid_from_             IN  DATE, 
   valid_to_               IN  DATE,
   action_                 IN  VARCHAR2 )
IS
   dummy_               NUMBER;
   method_count_        NUMBER;
   addr_count_          NUMBER;
   CURSOR get_method_default_value IS
      SELECT 1
      FROM   comm_method_tab
      WHERE  party_type     = party_type_db_
      AND    identity       = identity_
      AND    method_id      = method_id_
      AND    method_default = 'TRUE'
      AND    ROWID         != row_id_
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_,   Database_SYS.Get_Last_Calendar_Date())  >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()));
   CURSOR get_method_count IS
      SELECT COUNT(*)
      FROM   comm_method_tab
      WHERE  party_type      = party_type_db_
      AND    identity        = identity_
      AND    method_id       = method_id_
      AND    method_default != 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_,   Database_SYS.Get_Last_Calendar_Date())  >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()));
   CURSOR get_address_default_value IS
      SELECT 1
      FROM   comm_method_tab
      WHERE  party_type      = party_type_db_
      AND    identity        = identity_
      AND    method_id       = method_id_
      AND    address_id      = address_id_
      AND    address_default = 'TRUE'
      AND    ROWID          != row_id_
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_,   Database_SYS.Get_Last_Calendar_Date())  >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()));
   CURSOR get_address_count IS
      SELECT COUNT(*)
      FROM   comm_method_tab
      WHERE  party_type       = party_type_db_
      AND    identity         = identity_
      AND    method_id        = method_id_
      AND    address_id       = address_id_
      AND    address_default != 'TRUE'
      AND    (NVL(valid_from_, Database_SYS.Get_First_Calendar_Date()) <= NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date()) AND
             NVL(valid_to_,   Database_SYS.Get_Last_Calendar_Date())  >= NVL(valid_from, Database_SYS.Get_First_Calendar_Date()));
BEGIN
   IF (action_ = 'MODIFY') THEN
      IF (address_default_ = 'TRUE' AND address_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ADDDEFIDNULL: Default per Method and Address can only be selected if the row is connected to an Address ID.');
      END IF;
      OPEN  get_method_default_value;
      FETCH get_method_default_value INTO dummy_;
      IF (get_method_default_value%FOUND) THEN
         IF (method_default_ = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'METHDEFEXIST: There is a value already registered as Default per Method for this time interval.');
         END IF;
      ELSE
         OPEN  get_method_count;
         FETCH get_method_count INTO method_count_;
         IF (method_count_ >= 1 AND method_default_ = 'FALSE') THEN
            def_method_exist_ := 'FALSE';
         END IF; 
         CLOSE get_method_count;
      END IF;
      CLOSE get_method_default_value;  
      OPEN  get_address_default_value;
      FETCH get_address_default_value INTO dummy_;
      IF (get_address_default_value%FOUND) THEN
         IF (address_default_ = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'ADDDEFEXIST: There is a value already registered as Default per Method and Address for this address and time interval.');
         END IF;
      ELSE
         OPEN  get_address_count;
         FETCH get_address_count INTO addr_count_;
         IF (addr_count_ >= 1 AND address_default_ = 'FALSE') THEN
            def_method_addr_exist_ := 'FALSE';
         END IF;
         CLOSE get_address_count;
      END IF;
      CLOSE get_address_default_value; 
   END IF;
   IF (action_ = 'DELETE') THEN
      IF (method_default_ = 'TRUE') THEN
         OPEN  get_method_count;
         FETCH get_method_count INTO method_count_;
         IF (method_count_ > 1) THEN
            def_method_exist_ := 'FALSE';
         END IF;
         CLOSE get_method_count;
      END IF;
      IF (address_default_ = 'TRUE') THEN
         OPEN  get_address_count;
         FETCH get_address_count INTO addr_count_;
         IF (addr_count_ > 1) THEN
            def_method_addr_exist_ := 'FALSE';
         END IF;
         CLOSE get_address_count;
      END IF;
   END IF;
END Validate_Default___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     comm_method_tab%ROWTYPE,
   newrec_ IN OUT comm_method_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (indrec_.party_type = TRUE) THEN       
      IF (newrec_.party_type IN ('CUSTOMS', 'TAX')) THEN         
         indrec_.party_type := FALSE;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.address_id IS NOT NULL) THEN
      Party_Type_Address_API.Exist(newrec_.party_type, newrec_.identity, newrec_.address_id );
   END IF;
   IF (newrec_.valid_from IS NOT NULL AND newrec_.valid_to IS NOT NULL) THEN
      IF (newrec_.valid_from > newrec_.valid_to) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDATE: Valid From date must be earlier than Valid To date.');
      END IF;
   END IF;
   IF (newrec_.method_default IS NULL) THEN
      newrec_.method_default := 'FALSE';
   END IF;
   IF (newrec_.address_default IS NULL) THEN
      newrec_.address_default := 'FALSE';
   END IF;   
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN comm_method_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT comm_method_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_New_Comm_Id___(newrec_);
   Check_Comm_Method___(newrec_, NULL);
   super(objid_, objversion_, newrec_, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Insert(lu_name_, Pack___(newrec_));
   $END
   Client_SYS.Add_To_Attr('COMM_ID', newrec_.comm_id, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     comm_method_tab%ROWTYPE,
   newrec_     IN OUT comm_method_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN    
   Check_Comm_Method___(newrec_, objid_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (Business_Lead_Contact_API.Exist_Contact(newrec_.identity) OR Person_Info_API.Get_Customer_Contact_Db(newrec_.identity) = Fnd_Boolean_API.DB_TRUE) THEN
         Log_Column_Changes___(oldrec_, newrec_);
      END IF;
   $END          
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Update(lu_name_, Pack___(oldrec_), Pack___(newrec_));
   $END
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN comm_method_tab%ROWTYPE )
IS   
BEGIN
   super(objid_, remrec_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Delete(lu_name_, Pack___(remrec_));
   $END
   IF (remrec_.party_type = 'PERSON') THEN
      $IF Component_Person_SYS.INSTALLED $THEN
         IF (Pers_Comms_Work_API.Exist2(remrec_.identity, remrec_.comm_id) = 'TRUE') THEN
            Pers_Comms_Work_API.Remove(remrec_.identity, remrec_.comm_id);
         END IF;
      $ELSE
         NULL; 
      $END
   END IF;
END Delete___;


PROCEDURE Log_Column_Changes___ (
   oldrec_ IN comm_method_tab%ROWTYPE,
   newrec_ IN comm_method_tab%ROWTYPE )
IS
   old_attr_  VARCHAR2(32000):= Pack_Table___(oldrec_);
   new_attr_  VARCHAR2(32000):= Pack_Table___(newrec_);
   name_      VARCHAR2(50);
   new_value_ VARCHAR2(4000);
   old_value_ VARCHAR2(4000);
BEGIN   
   $IF Component_Crm_SYS.INSTALLED $THEN 
      IF (Client_SYS.Item_Exist('VALUE', new_attr_)) THEN
         name_ := Comm_Method_Code_API.Decode(newrec_.method_id);
         new_value_ := Client_SYS.Get_Item_Value('VALUE', new_attr_);
         IF (Business_Object_Columns_API.Exists_Person_Info_Db(newrec_.method_id)) THEN
            old_value_ := Client_SYS.Get_Item_Value('VALUE', old_attr_);
            IF (Validate_SYS.Is_Different(old_value_, new_value_)) THEN
               Crm_Person_Info_History_API.Log_History(oldrec_, newrec_, newrec_.method_id, old_value_, new_value_);  
            END IF;
         END IF;
      END IF; 
   $ELSE
      NULL;
   $END
END Log_Column_Changes___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN comm_method_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Insert(lu_name_, attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN comm_method_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Update___;


PROCEDURE Rm_Dup_Delete___ (
   rec_  IN comm_method_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Delete(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;


PROCEDURE Rm_Dup_Check_For_Duplicate___ (
   attr_ IN OUT VARCHAR2,
   rec_  IN     comm_method_tab%ROWTYPE )
IS
   dup_attr_   VARCHAR2(32000);
   dup_action_ VARCHAR2(50) := 'DUPLICATE_ACTION';
   dup_keys_   VARCHAR2(50) := 'DUPLICATE_KEYS';
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      dup_attr_ := Pack_Table___(rec_);
      Rm_Dup_Util_API.Check_For_Duplicate(dup_attr_, lu_name_);
      IF (Client_SYS.Item_Exist(dup_action_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_action_, Client_SYS.Get_Item_Value(dup_action_, dup_attr_), attr_);
      END IF;
      IF (Client_SYS.Item_Exist(dup_keys_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_keys_, Client_SYS.Get_Item_Value(dup_keys_, dup_attr_), attr_);
      END IF;
   $ELSE
      NULL;
   $END
END Rm_Dup_Check_For_Duplicate___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cascade_Check_Customer__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'CUSTOMER';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Customer__;


PROCEDURE Cascade_Check_Supplier__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'SUPPLIER';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Supplier__;


PROCEDURE Cascade_Check_Person__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'PERSON';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Person__;


PROCEDURE Cascade_Check_Company__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'COMPANY';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Company__;


PROCEDURE Cascade_Check_Customs__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'CUSTOMS';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Customs__;


PROCEDURE Cascade_Check_Forwarder__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'FORWARDER';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Forwarder__;


PROCEDURE Cascade_Check_Manufacturer__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'MANUFACTURER';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Manufacturer__;


PROCEDURE Cascade_Check_Owner__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'OWNER';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Owner__;


PROCEDURE Cascade_Check_Tax__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'TAX';
   Do_Cascade___(identity_, party_type_db_, 'CHECK'); 
END Cascade_Check_Tax__;


PROCEDURE Cascade_Delete_Customer__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'CUSTOMER';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Customer__;


PROCEDURE Cascade_Delete_Supplier__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'SUPPLIER';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Supplier__;


PROCEDURE Cascade_Delete_Person__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'PERSON';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Person__;


PROCEDURE Cascade_Delete_Company__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'COMPANY';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Company__;


PROCEDURE Cascade_Delete_Customs__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'CUSTOMS';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Customs__;


PROCEDURE Cascade_Delete_Forwarder__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'FORWARDER';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Forwarder__;


PROCEDURE Cascade_Delete_Manufacturer__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'MANUFACTURER';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Manufacturer__;


PROCEDURE Cascade_Delete_Owner__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'OWNER';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Owner__;


PROCEDURE Cascade_Delete_Tax__ (
   identity_ IN VARCHAR2 )
IS 
   party_type_db_   VARCHAR2(20);
BEGIN
   party_type_db_  := 'TAX';
   Do_Cascade___(identity_, party_type_db_, 'DO'); 
END Cascade_Delete_Tax__;


-- This method is to be used by Aurena
FUNCTION Get_Objid_From_Etag__ (
   etag_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   delim_pos_ INTEGER := INSTR(etag_, ':');
BEGIN
   RETURN SUBSTR(etag_, 4, delim_pos_-4);
END Get_Objid_From_Etag__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Public method that returns value for comm method without checking permission for person.
-- For person this method should only be used in exceptional cases.  
@UncheckedAccess
FUNCTION Get_Comm_Method (
   party_type_    IN VARCHAR2,
   identity_      IN VARCHAR2,
   method_id_     IN VARCHAR2,
   date_          IN DATE ) RETURN VARCHAR2
IS
   CURSOR get_method_def IS
     SELECT t.value
     FROM   comm_method_tab t
     WHERE  t.party_type = party_type_
     AND    t.identity     = identity_
     AND    t.method_id    = method_id_
     AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date())
     AND    t.method_default = 'TRUE';
   CURSOR get_method is
     SELECT t.value
     FROM   comm_method_tab t
     WHERE  t.party_type = party_type_
     AND    t.identity     = identity_
     AND    t.method_id    = method_id_
     AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date());
   retn_value_      comm_method_tab.value%TYPE := NULL;
   distinct_hit_    VARCHAR2(5) := 'TRUE';
   count_           NUMBER;
BEGIN
   OPEN get_method_def;
   FETCH get_method_def INTO retn_value_;
   IF (get_method_def%NOTFOUND) THEN
      count_   := 0;
      FOR row_ IN get_method LOOP
         IF (count_ = 2) THEN
            EXIT;
         END IF;
         retn_value_ := row_.value;
         count_ := count_ + 1;
      END LOOP;
      IF (count_ != 1) THEN
         retn_value_   := NULL;
         distinct_hit_ := 'FALSE';
      END IF;
   END IF;
   CLOSE get_method_def;
   IF (distinct_hit_ = 'TRUE') THEN
      RETURN retn_value_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Comm_Method;


PROCEDURE Check_Default (
   no_method_def_set_    OUT VARCHAR2,
   no_addrss_def_set_    OUT VARCHAR2,
   party_type_           IN  VARCHAR2,
   identity_             IN  VARCHAR2 )
IS
   CURSOR check_default_set IS
      SELECT t.method_id , t.address_id, t.valid_from, t.valid_to, t.method_default, t.address_default, t.ROWID
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_ ;
   -- Curosrs for Checking for more than one rows with no Method Default checked
   CURSOR dist_methods_with_no_def IS
      SELECT DISTINCT t.method_id  
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id NOT IN (SELECT DISTINCT w.method_id 
                                 FROM   comm_method_tab w
                                 WHERE  w.party_type = party_type_
                                 AND    w.identity = identity_
                                 AND    w.method_default = 'TRUE');
   CURSOR methods_with_no_def (method_id_ VARCHAR2) IS
      SELECT t.ROWID, t.valid_from, t.valid_to  
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_;
   -- Curosrs for Checking for more than one rows with no Address Default checked
   CURSOR all_add_list IS
      SELECT DISTINCT t.method_id 
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_;
   CURSOR dist_address_with_no_def (method_id_ VARCHAR2) IS
      SELECT DISTINCT t.address_id 
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    t.address_id IS NOT NULL 
      AND    t.address_id NOT IN (SELECT DISTINCT w.address_id 
                                  FROM   comm_method_tab w
                                  WHERE  w.party_type = party_type_
                                  AND    w.identity = identity_
                                  AND    w.method_id = method_id_
                                  AND    w.address_id IS NOT NULL 
                                  AND    w.address_default = 'TRUE')
      GROUP BY t.method_id, t.address_id;
   CURSOR address_with_no_def (method_id_ VARCHAR2, add_id_ VARCHAR2) IS
      SELECT t.ROWID, t.valid_from, t.valid_to  
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    address_id = add_id_ ;
BEGIN
   -- Checking for more than one rows with defailts checked
   FOR rec_ IN check_default_set LOOP
      Check_Default_Set___(party_type_, identity_, rec_.method_id , rec_.address_id, rec_.valid_from, rec_.valid_to, rec_.method_default, rec_.address_default, rec_.ROWID);
   END LOOP;
   -- Checking for more than one rows with no Method Default checked
   FOR rec1_ IN dist_methods_with_no_def  LOOP
      FOR rec2_ IN methods_with_no_def(rec1_.method_id) LOOP
         IF (Check_Meth_Def_Not_Set___(party_type_, identity_, rec1_.method_id, rec2_.valid_from, rec2_.valid_to, rec2_.ROWID)) THEN
            no_method_def_set_ := no_method_def_set_||rec1_.method_id||Client_SYS.field_separator_;
            EXIT;
         END IF;
      END LOOP;
   END LOOP;
   -- Checking for more than one rows with no Address Default checked
   FOR rec0_ IN all_add_list LOOP
      FOR rec1_ IN dist_address_with_no_def(rec0_.method_id)  LOOP
         FOR rec2_ IN address_with_no_def(rec0_.method_id, rec1_.address_id) LOOP
            IF (Check_Add_Def_Not_Set___(party_type_, identity_, rec0_.method_id, rec1_.address_id, rec2_.valid_from, rec2_.valid_to, rec2_.ROWID)) THEN
               no_addrss_def_set_ := no_addrss_def_set_||rec0_.method_id||Client_SYS.field_separator_||rec1_.address_id||Client_SYS.record_separator_;
               EXIT;
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;
END Check_Default;


PROCEDURE Check_Default (
   methods_              OUT VARCHAR2,
   methods_and_addrs_    OUT VARCHAR2,
   attr_                 IN  VARCHAR2,
   party_type_db_        IN  VARCHAR2,
   identity_             IN  VARCHAR2 )
IS
   value_                  VARCHAR2(2000);
   row_id_                 VARCHAR2(200);
   addr_id_                VARCHAR2(200);
   prev_addr_id_           VARCHAR2(200);
   address_id_             VARCHAR2(200);
   name_                   VARCHAR2(30);
   method_id_              VARCHAR2(20);
   def_method_exist_       VARCHAR2(5);
   def_method_addr_exist_  VARCHAR2(5);
   ptr_                    NUMBER;
   rec_                    comm_method_tab%ROWTYPE;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ROW_ID') THEN
         row_id_ := value_;
      ELSIF (name_ = 'METHOD_ID') THEN
         rec_.method_id := value_;
         method_id_ := Comm_Method_Code_API.Encode(rec_.method_id);
      ELSIF (name_ = 'ADDRESS_ID') THEN
         rec_.address_id := value_;
      ELSIF (name_ = 'PREV_ADDRESS_ID') THEN
         prev_addr_id_ := value_;
      ELSIF (name_ = 'METHOD_DEFAULT') THEN
         rec_.method_default := NVL(value_, 'FALSE');
      ELSIF (name_ = 'ADDRESS_DEFAULT') THEN
         rec_.address_default := NVL(value_, 'FALSE');
      ELSIF (name_ = 'VALID_FROM') THEN
         rec_.valid_from := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'VALID_TO') THEN
         rec_.valid_to := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'END_MODIFY') THEN
         def_method_exist_      := NULL;
         def_method_addr_exist_ := NULL;
         IF (rec_.address_id IS NULL AND prev_addr_id_ IS NOT NULL) THEN
            address_id_ :=  prev_addr_id_;
         ELSE
            address_id_ :=  rec_.address_id;
         END IF;
         Validate_Default___(def_method_exist_, def_method_addr_exist_, identity_, party_type_db_, row_id_, method_id_, rec_.address_id, rec_.method_default, rec_.address_default, rec_.valid_from, rec_.valid_to, 'MODIFY');
         IF (def_method_exist_ = 'FALSE' AND (methods_ IS NULL OR INSTR(methods_, rec_.method_id) <= 0)) THEN
            methods_ := methods_||rec_.method_id||Client_SYS.field_separator_;
         END IF;
         IF (def_method_addr_exist_ = 'FALSE') THEN
            addr_id_ := rec_.method_id||Client_SYS.field_separator_||address_id_;
            IF (methods_and_addrs_ IS NULL OR INSTR(methods_and_addrs_, addr_id_) <= 0) THEN
               methods_and_addrs_ := methods_and_addrs_||addr_id_||Client_SYS.record_separator_;
            END IF;
         END IF;
      ELSIF (name_ = 'END_DELETE') THEN
         def_method_exist_      := NULL;
         def_method_addr_exist_ := NULL;
         Validate_Default___(def_method_exist_, def_method_addr_exist_, identity_, party_type_db_, row_id_, method_id_, rec_.address_id, rec_.method_default, rec_.address_default, rec_.valid_from, rec_.valid_to, 'DELETE');
         IF (def_method_exist_ = 'FALSE' AND (methods_ IS NULL OR INSTR(methods_, rec_.method_id) <= 0)) THEN
            methods_ := methods_||rec_.method_id||Client_SYS.field_separator_;
         END IF;
         IF (def_method_addr_exist_ = 'FALSE') THEN
            addr_id_ := rec_.method_id||Client_SYS.field_separator_||rec_.address_id;
            IF (methods_and_addrs_ IS NULL OR INSTR(methods_and_addrs_, addr_id_) <= 0) THEN
               methods_and_addrs_ := methods_and_addrs_||addr_id_||Client_SYS.record_separator_;
            END IF;
         END IF;
      END IF;
   END LOOP;
END Check_Default ;


-- Public method that returns value for comm method without checking permission for person.
-- For person this method should only be used in exceptional cases.  
@UncheckedAccess
FUNCTION Get_Valid_Value (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   comm_id_    IN NUMBER ) RETURN VARCHAR2
IS
   value_ comm_method_tab.value%TYPE;
   CURSOR get_valid_value IS
      SELECT value
      FROM   comm_method_tab
      WHERE  identity = identity_
      AND    comm_id = comm_id_
      AND    party_type = Party_Type_API.Encode(party_type_)
      AND    TRUNC(SYSDATE) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   OPEN get_valid_value;
   FETCH get_valid_value INTO value_;
   CLOSE get_valid_value;
   RETURN value_;
END Get_Valid_Value;


@UncheckedAccess
FUNCTION Get_Default_Value (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 DEFAULT NULL,
   date_       IN DATE DEFAULT SYSDATE,
   name_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   CURSOR get_method_def IS
      SELECT t.value, t.address_id
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    t.method_default = 'TRUE';
   CURSOR get_address_def IS
      SELECT t.value
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    t.address_id = address_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    t.address_default = 'TRUE';
   CURSOR get_value_with_addr IS
      SELECT t.value
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    t.address_id = address_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date());
   CURSOR get_value_no_addr is
      SELECT t.value, t.address_id
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_
      AND    t.identity = identity_
      AND    t.method_id = method_id_
      AND    DECODE(name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to, Database_SYS.Get_Last_Calendar_Date());
   retn_value_      comm_method_tab.value%TYPE := NULL;
   add_id_          comm_method_tab.address_id%TYPE;
   count_           NUMBER;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      OPEN get_address_def;
      FETCH get_address_def INTO retn_value_;
      IF (get_address_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise check for a row with method_default TRUE.
         count_   := 0;
         FOR row_ IN get_value_with_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            retn_value_ := row_.value;
            add_id_ := address_id_;
            count_ := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            retn_value_ := NULL;
            OPEN get_method_def;
            FETCH get_method_def INTO retn_value_, add_id_;
            CLOSE get_method_def;
         END IF;
      ELSE
         add_id_ := address_id_;
      END IF;
      CLOSE get_address_def;
   ELSE
      OPEN get_method_def;
      FETCH get_method_def INTO retn_value_, add_id_;
      IF (get_method_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise null is returned.
         count_   := 0;
         FOR row_ IN get_value_no_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            retn_value_ := row_.value;
            add_id_ := row_.address_id;
            count_ := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            retn_value_ := NULL;
         END IF;
      END IF;
      CLOSE get_method_def;
   END IF;
   -- Checking permission for person.
   IF (party_type_ = 'PERSON') THEN
      IF NOT (Person_Info_API.Check_Access(identity_) = 'TRUE') THEN
         IF (Person_Info_Address_Type_API.Is_Work_Default(identity_, add_id_) = 'TRUE') THEN 
            RETURN retn_value_;
         END IF;
         RETURN NULL;
      END IF;
   END IF;
   RETURN retn_value_;
END Get_Default_Value;


@UncheckedAccess
FUNCTION Get_Default_Value_Add_Type (
   party_type_db_ IN VARCHAR2,
   identity_      IN VARCHAR2,
   method_id_     IN VARCHAR2,
   address_type_  IN VARCHAR2,
   date_          IN DATE DEFAULT SYSDATE) RETURN VARCHAR2
IS 
   address_id_       comm_method_tab.address_id%TYPE ;
BEGIN
   IF (address_type_ IS NOT NULL) THEN
      -- Finds the defualt address id for the address_type
      address_id_ := Party_Type_Generic_API.Get_Default_Address(party_type_db_, identity_, address_type_ , NVL(date_, SYSDATE));
   END IF; 
   RETURN Get_Default_Value(party_type_db_, identity_, method_id_, address_id_, date_);
END Get_Default_Value_Add_Type;


-- Public method that returns value for comm method without checking permission for person.
-- For person this method should only be used in exceptional cases.  
@UncheckedAccess
FUNCTION Get_Value_From_Name (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   name_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ comm_method_tab.value%TYPE;
   CURSOR get_attr IS
      SELECT value
      FROM   comm_method_tab
      WHERE  party_type = party_type_
      AND    identity   = identity_
      AND    name       = name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Value_From_Name;


@UncheckedAccess
FUNCTION Get_Default_Value_Person (
   person_id_        IN VARCHAR2,
   method_id_        IN VARCHAR2,
   address_id_       IN VARCHAR2 DEFAULT NULL,
   address_type_     IN VARCHAR2 DEFAULT NULL,
   date_             IN DATE     DEFAULT SYSDATE )RETURN VARCHAR2
IS
   dist_hit_        VARCHAR2(5) := 'TRUE'; 
   address_type_db_ VARCHAR2(20);
   def_address_id_  comm_method_tab.address_id%TYPE := NULL;
   temp_address_id_ comm_method_tab.address_id%TYPE := NULL;
   ret_value_       comm_method_tab.value%TYPE := NULL;
   count_           NUMBER;
   CURSOR def_address_id IS
      SELECT t.address_id 
      FROM   person_info_address_type_tab t
      WHERE  t.person_id = person_id_
      AND    t.address_type_code = address_type_db_
      AND    t.def_address = 'TRUE';
   CURSOR get_address_id IS
      SELECT t.address_id 
      FROM   person_info_address_type_tab t
      WHERE  t.person_id = person_id_
      AND    t.address_type_code = address_type_db_;
BEGIN
   IF (address_id_ IS NULL AND address_type_ IS NOT NULL) THEN
      -- Find the default address_id_ to the given address_type_
      address_type_db_ := Address_Type_Code_API.Encode(address_type_);
      OPEN def_address_id;
      FETCH def_address_id INTO def_address_id_;
      IF (def_address_id%NOTFOUND) THEN
         count_ := 0;
         FOR row_ IN get_address_id LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            def_address_id_ := row_.address_id;
            count_ := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            dist_hit_ := 'FALSE';
            def_address_id_ := NULL;
         END IF;
      END IF;
      CLOSE def_address_id;
   END IF;
   IF (address_id_ IS NOT NULL) THEN
      temp_address_id_ := address_id_;
   ELSIF (def_address_id_ IS NOT NULL) THEN
      temp_address_id_ := def_address_id_;
   END IF;
   ret_value_:= Get_Default_Distinct_Value___('PERSON', person_id_, method_id_, temp_address_id_, date_);
   IF (dist_hit_ = 'TRUE') THEN
      RETURN ret_value_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Default_Value_Person;


-- Public method that returns address id only when default per method is 'TRUE'. 
@UncheckedAccess
FUNCTION Get_Address_Id_By_Method (
   person_id_        IN VARCHAR2,
   method_id_        IN VARCHAR2,
   party_type_       IN VARCHAR2,
   address_type_     IN VARCHAR2,
   date_             IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_type_db_  VARCHAR2(20);
   address_id_       comm_method_tab.address_id%TYPE := NULL;
   CURSOR get_def_method IS
      SELECT c.address_id
      FROM   comm_method_tab c, person_info_address_type_tab t     
      WHERE  c.identity = person_id_
      AND    c.party_type = party_type_
      AND    c.method_id = method_id_
      AND    c.identity = t.person_id
      AND    c.address_id = t.address_id 
      AND    t.address_type_code = address_type_db_
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(c.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(c.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    c.method_default = 'TRUE';
BEGIN
   address_type_db_ := Address_Type_Code_API.Encode(address_type_);
   OPEN get_def_method;
   FETCH get_def_method INTO address_id_;   
   CLOSE get_def_method;
   RETURN address_id_; 
END Get_Address_Id_By_Method;


-- Public method which provides address id count.
-- This method also provides address id, if there is only one address id available for a given address type and comm method. 
PROCEDURE Get_Address_Id (
   address_id_      OUT VARCHAR2,
   count_           OUT NUMBER,
   person_id_       IN  VARCHAR2,
   method_id_       IN  VARCHAR2,
   party_type_      IN  VARCHAR2,
   address_type_    IN  VARCHAR2,
   date_            IN  DATE DEFAULT SYSDATE )
IS
   address_type_db_  VARCHAR2(20);
   CURSOR get_address_id IS
      SELECT c.address_id
      FROM   comm_method_tab c, person_info_address_type_tab t        
      WHERE  c.identity = person_id_
      AND    c.party_type = party_type_
      AND    c.method_id = method_id_
      AND    c.identity = t.person_id
      AND    c.address_id = t.address_id
      AND    t.address_type_code = address_type_db_
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(c.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(c.valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   address_type_db_ := Address_Type_Code_API.Encode(address_type_);
   count_ := 0;
   FOR row_ IN get_address_id LOOP
      count_ := count_ + 1;
      IF (count_ > 1) THEN
         address_id_ := NULL;
         EXIT;
      ELSE
         address_id_ := row_.address_id;
      END IF;
   END LOOP; 
END Get_Address_Id;


-- Public method that returns address id only when there is a single address id with default address is set TRUE for a given comm method. 
@UncheckedAccess
FUNCTION Get_Default_Address_Id (
   person_id_        IN VARCHAR2,
   method_id_        IN VARCHAR2,
   party_type_       IN VARCHAR2,
   address_type_     IN VARCHAR2,
   date_             IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_type_db_  VARCHAR2(20);
   address_id_       comm_method_tab.address_id%TYPE := NULL;
   count_            NUMBER :=0;
   CURSOR get_def_address_id IS
      SELECT c.address_id
      FROM   comm_method_tab c, person_info_address_type_tab t        
      WHERE  c.identity = person_id_
      AND    c.party_type = party_type_
      AND    c.method_id = method_id_
      AND    c.identity = t.person_id
      AND    c.address_id = t.address_id
      AND    t.address_type_code = address_type_db_
      AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(c.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(c.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    t.def_address = 'TRUE';
BEGIN
   address_type_db_ := Address_Type_Code_API.Encode(address_type_);
   FOR id_ IN get_def_address_id LOOP
      count_ := count_ + 1;
      IF (count_ > 1) THEN
         address_id_ := NULL;
         EXIT;
      ELSE
         address_id_ := id_.address_id;
      END IF;
   END LOOP;
   RETURN address_id_;
END Get_Default_Address_Id;


PROCEDURE New (
   comm_id_          OUT NUMBER,
   party_type_       IN VARCHAR2,
   identity_         IN VARCHAR2,
   value_            IN VARCHAR2,
   description_      IN VARCHAR2 DEFAULT NULL,
   valid_from_       IN DATE DEFAULT NULL,    
   valid_to_         IN DATE DEFAULT NULL,    
   method_default_   IN VARCHAR2 DEFAULT NULL,
   address_default_  IN VARCHAR2 DEFAULT NULL,
   name_             IN VARCHAR2 DEFAULT NULL,
   method_id_        IN VARCHAR2 DEFAULT NULL,
   address_id_       IN VARCHAR2 DEFAULT NULL )
IS
   newrec_      comm_method_tab%ROWTYPE;
BEGIN
   newrec_.party_type  := party_type_;
   newrec_.identity    := identity_;
   newrec_.method_id   := Comm_Method_Code_API.Encode(method_id_);
   newrec_.value       := value_;
   newrec_.method_default  := NVL(method_default_, 'FALSE');
   newrec_.address_default := NVL(address_default_,'FALSE');
   newrec_.description := description_;
   newrec_.address_id  := address_id_;
   newrec_.valid_from  := valid_from_;
   newrec_.valid_to    := valid_to_;
   newrec_.name        := name_;
   New___(newrec_);
   comm_id_ := newrec_.comm_id; 
END New;


PROCEDURE Modify (
   party_type_       IN VARCHAR2,
   identity_         IN VARCHAR2,
   comm_id_          IN NUMBER,
   value_            IN VARCHAR2,
   method_default_   IN VARCHAR2 DEFAULT NULL,
   address_default_  IN VARCHAR2 DEFAULT NULL,
   description_      IN VARCHAR2 DEFAULT NULL,
   address_id_       IN VARCHAR2 DEFAULT NULL,
   valid_from_       IN DATE DEFAULT NULL,
   valid_to_         IN DATE DEFAULT NULL,
   name_             IN VARCHAR2 DEFAULT NULL,
   method_id_        IN VARCHAR2 DEFAULT NULL )
IS
   newrec_      comm_method_tab%ROWTYPE;
BEGIN
   newrec_                 := Get_Object_By_Keys___(party_type_, identity_, comm_id_);
   newrec_.value           := value_;
   newrec_.method_default  := NVL(method_default_, 'FALSE');
   newrec_.address_default := NVL(address_default_,'FALSE');
   newrec_.description     := description_;
   newrec_.address_id      := address_id_;
   newrec_.valid_from      := valid_from_;
   newrec_.valid_to        := valid_to_;
   newrec_.name            := name_;   
   IF (method_id_ IS NOT NULL) THEN 
      newrec_.method_id   := Comm_Method_Code_API.Encode(method_id_);
   END IF;
   Modify___(newrec_);
END Modify;


PROCEDURE Remove (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   comm_id_    IN NUMBER )
IS
   remrec_      comm_method_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, party_type_, identity_, comm_id_);
   remrec_ := Lock_By_Keys___(party_type_, identity_, comm_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


PROCEDURE Copy_Identity_Info (
   party_type_       IN VARCHAR2,
   identity_         IN VARCHAR2,
   new_id_           IN VARCHAR2,
   address_id_       IN VARCHAR2 DEFAULT NULL,
   new_addr_id_      IN VARCHAR2 DEFAULT NULL )
IS   
   newrec_ comm_method_tab%ROWTYPE;
   oldrec_ comm_method_tab%ROWTYPE;
   CURSOR get_address_attr IS
      SELECT *
      FROM   comm_method_tab
      WHERE  party_type  = party_type_
      AND    identity    = identity_ 
      AND    address_id  = address_id_;
   CURSOR get_attr IS
      SELECT *
      FROM   comm_method_tab
      WHERE  party_type  = party_type_
      AND    identity    = identity_;
BEGIN
   IF (address_id_ IS NULL) THEN      
      FOR rec_ IN get_attr LOOP
         oldrec_ := Lock_By_Keys___(party_type_, identity_, rec_.comm_id);   
         newrec_ := oldrec_ ;
         newrec_.identity := new_id_;
         newrec_.address_id := NVL(new_addr_id_, rec_.address_id); 
         New___(newrec_);
      END LOOP;
   ELSE
      FOR rec_ IN get_address_attr LOOP
         oldrec_ := Lock_By_Keys___(party_type_, identity_, rec_.comm_id);   
         newrec_ := oldrec_ ;
         newrec_.identity := new_id_;
         newrec_.address_id := NVL(new_addr_id_, rec_.address_id); 
         New___(newrec_);
      END LOOP;
   END IF;
END Copy_Identity_Info;


@UncheckedAccess
FUNCTION Get_Name_Value (
   party_type_  IN VARCHAR2,
   identity_    IN VARCHAR2,
   method_id_   IN VARCHAR2,
   name_        IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL,
   curr_date_   IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS 
BEGIN
   IF (name_ IS NOT NULL) THEN
      RETURN Get_Default_Value (party_type_, identity_, method_id_, address_id_, curr_date_, name_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Name_Value;


PROCEDURE Get_Comm_Id_From_Name (
   comm_id_        OUT NUMBER,
   count_          OUT NUMBER,                     
   party_type_db_  IN VARCHAR2,
   identity_       IN VARCHAR2,
   name_           IN VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT comm_id
      FROM   comm_method_tab
      WHERE  identity = identity_
      AND    LOWER(name) = LOWER(name_)
      AND    party_type = party_type_db_;
   temp_        comm_method_tab.comm_id%TYPE;   
   count1_      NUMBER := 0 ;   
BEGIN
   OPEN get_attr;
   WHILE (TRUE) LOOP
      FETCH get_attr INTO temp_;
      EXIT WHEN get_attr%NOTFOUND;
      count1_ := count1_ +1;
   END LOOP;
   CLOSE get_attr;
   comm_id_ := temp_;
   count_   := count1_;
END Get_Comm_Id_From_Name; 


PROCEDURE Get_Valid_Comm_Id_From_Name (
   comm_id_        OUT NUMBER,
   count_          OUT NUMBER,                     
   party_type_db_  IN  VARCHAR2,
   identity_       IN  VARCHAR2,
   name_           IN  VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT comm_id
      FROM   comm_method_tab
      WHERE  identity = identity_
      AND    LOWER(name) = LOWER(name_)
      AND    party_type = party_type_db_
      AND    TRUNC(SYSDATE) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
   temp_        comm_method_tab.comm_id%TYPE;   
   count1_      NUMBER := 0 ;   
BEGIN
   OPEN get_attr;
   WHILE (TRUE) LOOP
      FETCH get_attr INTO temp_;
      EXIT WHEN get_attr%NOTFOUND;
      count1_ := count1_ +1;
   END LOOP;
   CLOSE get_attr;
   comm_id_ := temp_;
   count_   := count1_;
END Get_Valid_Comm_Id_From_Name;


@UncheckedAccess
FUNCTION Get_Value_For_Sd (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_   comm_method_tab.value%TYPE;
   CURSOR get_data IS
      SELECT value
      FROM   person_info_comm_method2
      WHERE  identity = identity_;
BEGIN
    OPEN  get_data;
    FETCH get_data INTO  value_;
    CLOSE get_data;
    RETURN  value_;
END Get_Value_For_Sd;


@UncheckedAccess
FUNCTION Comm_Id_Exist (
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2,
   comm_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_       VARCHAR2(5);
BEGIN
   $IF Component_Payled_SYS.INSTALLED $THEN
      temp_ := Identity_Pay_Info_API.Comm_Id_Exist(identity_, party_type_, comm_id_);               
      RETURN temp_;
   $ELSE
      RETURN NULL;
   $END
END Comm_Id_Exist;


@UncheckedAccess
FUNCTION Get_Value (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   seq_no_     IN NUMBER DEFAULT 1,
   address_id_ IN VARCHAR2 DEFAULT 'CHR(0)',
   curr_date_  IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20);
BEGIN
   db_value_ := Comm_Method_Code_API.Encode(method_id_);
   RETURN Get_Default_Value(party_type_, identity_, db_value_ , address_id_, curr_date_);
END Get_Value;


@UncheckedAccess
FUNCTION Get_Name_Db (
   party_type_db_ IN VARCHAR2,
   identity_      IN VARCHAR2,
   comm_id_       IN NUMBER ) RETURN VARCHAR2
IS
   temp_ comm_method_tab.name%TYPE;
   CURSOR get_attr IS
      SELECT name     
      FROM   comm_method_tab
      WHERE  party_type = party_type_db_
      AND    identity = identity_
      AND    comm_id = comm_id_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;   
   RETURN temp_;
END Get_Name_Db;


@UncheckedAccess
FUNCTION Get_Identity_By_Email (
   email_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   identity_ comm_method_tab.identity%TYPE;
   CURSOR get_identity IS
      SELECT DISTINCT identity      
      FROM   comm_method_tab
      WHERE  party_type = 'PERSON'
      AND    method_id = 'E_MAIL'
      AND    LOWER(value) = LOWER(email_);
BEGIN
   OPEN get_identity;
   FETCH get_identity INTO identity_;
   CLOSE get_identity;
   RETURN identity_;
END Get_Identity_By_Email;
   

@UncheckedAccess
FUNCTION Get_Comm_Id_By_Method (
   identity_      IN    VARCHAR2,
   method_id_db_  IN    VARCHAR2,
   value_         IN    VARCHAR2) RETURN VARCHAR2
IS
   comm_id_ comm_method_tab.comm_id%TYPE;
   CURSOR get_comm_id IS
      SELECT comm_id
      FROM   person_info_comm_method2
      WHERE  identity = identity_
      AND    method_id_db = method_id_db_
      AND    value = value_;
BEGIN
   OPEN get_comm_id;
   FETCH get_comm_id INTO comm_id_;
   CLOSE get_comm_id;
   RETURN comm_id_; 
END Get_Comm_Id_By_Method;
   

@UncheckedAccess   
FUNCTION Get_Latest_Modified_Date (         
   identity_      IN    VARCHAR2) RETURN DATE
IS
   last_modified_ DATE;
   CURSOR get_date IS
      SELECT MAX(rowversion)    
      FROM   comm_method_tab
      WHERE  party_type = 'PERSON'
      AND    identity = identity_;
BEGIN   
   OPEN get_date;
   FETCH get_date INTO last_modified_;
   CLOSE get_date;
   RETURN last_modified_;
END Get_Latest_Modified_Date;


@UncheckedAccess  
FUNCTION Get_Default_Selected_Value (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 DEFAULT NULL,
   date_       IN DATE     DEFAULT SYSDATE,
   name_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR get_method_def IS
     SELECT t.value, t.address_id
     FROM   comm_method_tab t
     WHERE  t.party_type = party_type_
     AND    t.identity = identity_
     AND    t.method_id = method_id_
     AND    decode ( name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
     AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to,   Database_SYS.Get_Last_Calendar_Date())
     AND    t.method_default = 'TRUE';
   CURSOR get_address_def IS
     SELECT t.value
     FROM   comm_method_tab t
     WHERE  t.party_type = party_type_
     AND    t.identity = identity_
     AND    t.method_id = method_id_
     AND    t.address_id = address_id_
     AND    decode ( name_, NULL, CHR(0), t.name)= NVL(name_, CHR(0))
     AND    TRUNC(NVL(date_,SYSDATE)) BETWEEN NVL(t.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(t.valid_to,   Database_SYS.Get_Last_Calendar_Date())
     AND    t.address_default = 'TRUE';
   retn_value_      comm_method_tab.value%TYPE := NULL;
   add_id_          comm_method_tab.address_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      OPEN get_address_def;
      FETCH get_address_def INTO retn_value_;
      CLOSE get_address_def;
   ELSE
      OPEN get_method_def;
      FETCH get_method_def INTO retn_value_, add_id_;
      CLOSE get_method_def;
   END IF;
   -- Checking permission for person.
   IF (party_type_ = 'PERSON') THEN
      IF NOT (Person_Info_API.Check_Access(identity_) = 'TRUE') THEN               
         IF (Person_Info_Address_Type_API.Is_Work_Default(identity_, add_id_) = 'TRUE') THEN 
            RETURN retn_value_;
         END IF;
         RETURN NULL;
      END IF;
   END IF;
   RETURN retn_value_;
END Get_Default_Selected_Value;


@UncheckedAccess
FUNCTION Get_Default_Comm_Id (
   party_type_db_ IN VARCHAR2,
   identity_      IN VARCHAR2,
   method_id_     IN VARCHAR2,
   address_id_    IN VARCHAR2 DEFAULT NULL,
   date_          IN DATE     DEFAULT SYSDATE ) RETURN NUMBER
IS
   CURSOR get_method_def IS
      SELECT comm_id, address_id
      FROM   comm_method_tab
      WHERE  party_type = party_type_db_
      AND    identity = identity_
      AND    method_id = method_id_
      AND    TRUNC(NVL(date_, SYSDATE)) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    method_default = 'TRUE';
   CURSOR get_address_def IS
      SELECT comm_id
      FROM   comm_method_tab
      WHERE  party_type = party_type_db_
      AND    identity = identity_
      AND    method_id = method_id_
      AND    address_id = address_id_
      AND    TRUNC(NVL(date_, SYSDATE)) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    address_default = 'TRUE';
   CURSOR get_comm_id_with_addr IS
      SELECT comm_id
      FROM   comm_method_tab
      WHERE  party_type = party_type_db_
      AND    identity = identity_
      AND    method_id = method_id_
      AND    TRUNC(NVL(date_, SYSDATE)) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    address_id = address_id_;
   CURSOR get_comm_id_no_addr is
      SELECT comm_id, address_id
      FROM   comm_method_tab
      WHERE  party_type = party_type_db_
      AND    identity = identity_
      AND    TRUNC(NVL(date_, SYSDATE)) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    method_id = method_id_;
   comm_id_ comm_method_tab.comm_id%TYPE := NULL;
   add_id_  comm_method_tab.address_id%TYPE;
   count_   NUMBER;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      OPEN get_address_def;
      FETCH get_address_def INTO comm_id_;
      IF (get_address_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise check for a row with method_default TRUE.
         count_ := 0;
         FOR row_ IN get_comm_id_with_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            comm_id_ := row_.comm_id;
            add_id_  := address_id_;
            count_   := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            comm_id_ := NULL;
            OPEN get_method_def;
            FETCH get_method_def INTO comm_id_, add_id_;
            CLOSE get_method_def;
         END IF;
      ELSE
         add_id_ := address_id_;
      END IF;
      CLOSE get_address_def;
   ELSE
      OPEN get_method_def;
      FETCH get_method_def INTO comm_id_, add_id_;
      IF (get_method_def%NOTFOUND) THEN
         -- IF only one row exists it is returned. Otherwise null is returned.
         count_ := 0;
         FOR row_ IN get_comm_id_no_addr LOOP
            IF (count_ = 2) THEN
               EXIT;
            END IF;
            comm_id_ := row_.comm_id;
            add_id_  := row_.address_id;
            count_   := count_ + 1;
         END LOOP;
         IF (count_ != 1) THEN
            comm_id_ := NULL;
         END IF;
      END IF;
      CLOSE get_method_def;
   END IF;
   -- Checking permission for person.
   IF (party_type_db_ = 'PERSON') THEN
      IF NOT (Person_Info_API.Check_Access(identity_) = 'TRUE') THEN
         IF (Person_Info_Address_Type_API.Is_Work_Default(identity_, add_id_) = 'TRUE') THEN
            RETURN comm_id_;
         END IF;
         RETURN NULL;
      END IF;
   END IF;
   RETURN comm_id_;
END Get_Default_Comm_Id;


-- This method is to be used by Aurena
PROCEDURE Add_Default_Method (    
   party_type_db_    IN VARCHAR2,
   identity_         IN VARCHAR2,
   method_id_db_     IN VARCHAR2,
   value_            IN VARCHAR2 )
IS
   newrec_      comm_method_tab%ROWTYPE;  
   oldrec_      comm_method_tab%ROWTYPE;   
   objid_       VARCHAR2(20);
   objversion_  VARCHAR2(100);
   attr_        VARCHAR2(32000);
   indrec_      Indicator_rec;  
   CURSOR get_method_def IS
      SELECT t.comm_id
      FROM   comm_method_tab t
      WHERE  t.party_type = party_type_db_
      AND    t.identity = identity_
      AND    t.method_id = method_id_db_  
      AND    t.method_default = 'TRUE';
BEGIN
   -- Remove default method check for existing defaults for this method id
   FOR rec_ IN get_method_def LOOP      
      oldrec_ := Lock_By_Keys___(party_type_db_, identity_, rec_.comm_id); 
      Get_Id_Version_By_Keys___(objid_, objversion_, party_type_db_, identity_, rec_.comm_id);            
      newrec_ := oldrec_;
      newrec_.method_default := Fnd_Boolean_API.DB_FALSE;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);       
   END LOOP;
   -- Create the new record with method_default set as true
   newrec_ := NULL;
   newrec_.party_type      := party_type_db_;
   newrec_.identity        := identity_;
   newrec_.method_id       := method_id_db_;
   newrec_.value           := value_;
   newrec_.method_default  := Fnd_Boolean_API.DB_TRUE;  
   New___(newrec_);  
END Add_Default_Method;


-- This method is to be used by Aurena
@UncheckedAccess
FUNCTION Get_Default_Email (
   identity_ VARCHAR2 ) RETURN VARCHAR2
IS
   rec_ VARCHAR2(100);
   CURSOR def_email IS
      SELECT value
      FROM   comm_method
      WHERE  party_type_db = 'PERSON' 
      AND    identity = identity_
      AND    method_id_db = 'E_MAIL'
      AND    method_default = 'TRUE'
      AND    ((SYSDATE BETWEEN valid_from AND valid_to) OR (valid_from IS NULL AND valid_to IS NULL));
BEGIN
   OPEN def_email;
   FETCH def_email INTO rec_;
   IF (def_email%FOUND) THEN
      CLOSE def_email;
      RETURN rec_;
   END IF;
   CLOSE def_email;
   RETURN NULL;
END Get_Default_Email;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN comm_method_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END 
END Pack_Table;


-- gelr:it_xml_invoice, begin
@UncheckedAccess
PROCEDURE Check_Comm_Method_Exist (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   method_id_  IN VARCHAR2,
   value_      IN VARCHAR2,
   date_       IN DATE )
IS
   temp_           NUMBER;
   methodnotexist_ EXCEPTION;
   CURSOR connected_comm_methods IS
      SELECT 1
      FROM   comm_method_tab
      WHERE  party_type = party_type_
      AND    identity = identity_
      AND    method_id = method_id_
      AND    TRUNC(NVL(date_, SYSDATE)) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    value = value_;     
BEGIN
   OPEN connected_comm_methods;
   FETCH connected_comm_methods INTO temp_;
   IF (connected_comm_methods%NOTFOUND) THEN
      CLOSE connected_comm_methods;
      RAISE methodnotexist_;
   END IF;
   CLOSE connected_comm_methods;
EXCEPTION
   WHEN methodnotexist_ THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDEMAILADDR: Not a valid communication method for :P1.', identity_);
END Check_Comm_Method_Exist;
-- gelr:it_xml_invoice, end      