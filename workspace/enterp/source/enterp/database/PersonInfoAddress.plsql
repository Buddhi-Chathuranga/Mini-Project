-----------------------------------------------------------------------------
--
--  Logical unit: PersonInfoAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981125  Camk    Created
--  981126  Camk    Method Check_If_Null added
--  990415  Camk    New template
--  990907  BmEk    Bug #11396. Added check in Unpack_Check_Insert and Unpack_Check_Update
--                  if valid to date is earlier then valid from date
--  991228  LiSv    Corrected bug #13129, changed substr_b to substr in function
--                  Get_Line.
--  000209  Mnisse  FIN243, new address fields.
--  000118  Camk    Address not mandatory
--  000227  Mnisse  New_Address, Modify_Address added.
--  000229  Mnisse  Bug #32920, uppercase for Zip_Code 
--  000302  Mnisse  Update also old address field.
--  000303  Mnisse  Public New and Modify shall update new address fields.
--  000410  Camk    Raise a warning to the user that the address format might not 
--                  correctly stored.
--  000518  LeKa    Bug # 13701 corrected.Removed +1.
--  000524  LiSv    Corrected call #41740, removed call to Check_If_Null___ (this is an old solution).
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001024  Camk    County added
--  010314  Cand    Bug #18479, Added procedure Cascade_Delete_Comm_Method__ 
--  011121  Chablk  Bug #19216 fixed, Created PERSON_INFO_ADDRESS1 view
--  020226  PPer    Bug #27788 fixed, Modified PERSON_INFO_ADDRESS1 view where clause
--  020712  Brwelk  Bug #27811. Removed Ref Cascade from View1.
--  020909  Ovjose  Bug #32697 Corrected. Additional correction of 27811. 
--                  Removed some comments from Bug 27811 that causes error.
--  020918  ARAMLK  Merged with the 2002-3 AV.
--  030919  PPer    Merge TakeOff
--  030916  Gepelk  IID ARFI124N. Add procedure Validate_Address  
--  040324  mgutse  Merge of 2004-1 SP1.
--  040628  Jeguse  Bug 45629, Added functions Get_Address_Form, Get_Address_Rec, Get_All_Address_Lines and Get_Address_Line 
--  060502  Sacalk  Bug 56972, Added function Sync_Addr, Modified New_ and Modify_ methods  
--  060712  Kagalk  FIPL610A - Added columns Street, House_No, Flat_No, Community, District.
--  060726  CsAmlk  Persian Calendar Modifications.
--  061227  Paralk  LCS Bug 58176 Merged ,Where clause of the PERSON_INFO_ADDRESS1 is modified to get the F1 user.  
--  070327  Kagalk  B141497, Enable to save address1 by combining of street, house_no, flat_no.
--  070508  Kagalk  B143397, Further corrections to 141497. 
--  070627  Kagalk  LCS Merge 65828, Fixed address presentation in Get_Address_Form.
--  080813  Jakalk  Bug 49697, Modified public get methods, so that the protected data is not shown to unauthorized users.
--  080910  Hiralk  Bug 76755, Added restriction to PERSON_INFO_ADDRESS1 view.
--  080910          Added this restriction to methods which are considering Protected person functionality.
--  090224  Shdilk  Bug 80642, Modified variable length of 'name' in Get_Address_Form.
--  090430  Chhulk  Bug 79336, Modified Cascade_Delete_Comm_Method__
--  090521  AsHelk  Bug 80221, Adding Transaction Statement Approved Annotation.
--  090603  Chhulk  Bug 83404, Modified Remove()
--  090807  MoMalk  Bug 84839, Added column address_lov to the view PERSON_INFO_ADDRESS, 
--  090807          in order to make the data of the column address info in single line.
--  090922  Nsillk  Issue Id EAFH-127 Removed unnecessary COMMIT statements
--  100622  Samblk  Bug 90960, Modified Validate_Address to support given test case
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  110720  Mohrlk  FIDEAGLE-179, Replaced User with Fnd_Session_API.Get_Fnd_User
--  110722  Shdilk  Bug 97796, Added column address_lov to the view PERSON_INFO_ADDRESS1, 
--  110722          in order to make the data of the column address info in single line.
--  121114  Nirplk  Bug 106346, Added a new method Get_Default_Contact_Info().
--  131111  Isuklk  PBFI-2196 Refactoring and Split PersonInfoAddress.entity
--  150220  Dihelk  PRFI-4712, Removed the Concat_Addr_Fields___() and corrected the address handling to tally with customer's and supplier's
--  150429  Chhulk  Bug 121510, Modified Check_Access___() to add a new parameter and a new condition.
--  150521  MaIklk  BLU-666, Added Get_Next_Address_Id().
--  150813  MaRalk  BLU-1182, Added method Get_Www in order to use in Customer/Contact tab. 
--  150811  Chhulk  Bug 121522, Merged correction to app9. Modified Check_Access___(), Get_Db_Types(), Get_Id_By_Type(), Get_Default_Address()
--                  and added Check_Access().
--  150824          Modified Get_Default_Contact_Info to fetch the value for www.
--  151103  THPELK  STRFI-307 - Removed Reset_Valid_From(),Reset_Valid_To(), New, Modify, Split_Address___.
--  151209  Bhhilk  STRFI-684, Added UncheckedAccess annotation to Check_Access() methord
--  160106	Chwtlk  STRFI-962, Merge of LCS Bug 126573, Modified Cascade_Delete_Comm_Method__()
--  160307  DipeLK  STRLOC-247,Removed Validate_Address() method.
--  160413  reanpl  STRLOC-108, Added handling of new attributes address3, address4, address5, address6
--  160505  ChguLK  STRCLOC-369, Renamed the package name to Address_Setup_API.
--  160922  NiAslk  STRSC-4100, Added Get_Phone method.
--  160923  NiAslk  STRSC-4100, Removed Get_Phone method.
--  180122  niedlk  Modified Update___ and added new method Log_Column_Changes___ to log CRM related addrees changes.
--  180531  MaRalk  FIUXXW2-285, Added method Modify_Address_Info.
--  180530  thjilk  FIUXXW2-123 Added changes to Check_Delete___ method to handle Delete in Person Address
--  180531  thjilk  FIUXXW2-123 Added method Modify_Detailed_Address
--  180720  JanWse  SCUXX-3748, Added public version of Pack_Table___ (Pack_Table)
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  181130  thjilk  Modified Check_Delete___ to validate Address Types
--  200908  thmulk  HCSPRING20-6855, Modified Update___ to add payroll integration logic in HCM.
--  201012  pabnlk  HCSPRING20-7357, Removed 'Check_Exist_Any_Request' method and it's references.
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New, Modify_Address,
--                  Close_Address, Modify_Address_Info and Modify_Detailed_Address.
--  210709  Smallk  FI21R2-875, Modified Insert___, removed usage of oboslete address_types_for_person view.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Access___ (
   person_id_    IN VARCHAR2,
   address_id_   IN VARCHAR2,
   user_id_      IN VARCHAR2 DEFAULT NULL,
   protected_    IN VARCHAR2 DEFAULT NULL,
   session_user_ IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS 
BEGIN
   IF (Person_Info_API.Check_Access(person_id_, user_id_, protected_, session_user_) = 'TRUE') THEN
      RETURN TRUE;
   ELSE
      IF (address_id_ IS NOT NULL) THEN
         IF (Person_Info_Address_Type_API.Is_Work_Default(person_id_, address_id_) = 'TRUE') THEN
            RETURN TRUE;
         END IF;
      END IF;
   END IF;   
   RETURN FALSE;
END Check_Access___;


PROCEDURE Get_Person_Party___ (
   newrec_ IN OUT person_info_address_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Person_Info_API.Get_Party(newrec_.person_id);      
   END IF;
END Get_Person_Party___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     person_info_address_tab%ROWTYPE,
   newrec_ IN OUT person_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(person_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.person_id, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   person_info_address_type_tab t
      WHERE  t.person_id = person_id_
      AND    t.address_id = address_id_;      
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.valid_from > newrec_.valid_to) THEN
      Error_SYS.Appl_General(lu_name_, 'WRONGINTERVAL: Valid From date is later than Valid To date');
   END IF;
   Address_Setup_API.Check_Nullable_Address_Fields(lu_name_, newrec_.address1, newrec_.address2, newrec_.address3, newrec_.address4, newrec_.address5, newrec_.address6);
   Address_Setup_API.Validate_Address(newrec_.country, newrec_.state, newrec_.county, newrec_.city); 
   IF (newrec_.state = '*') THEN
      newrec_.state := NULL;
   END IF;
   IF (newrec_.county = '*') THEN
      newrec_.county := NULL;
   END IF;
   IF (newrec_.city = '*') THEN
      newrec_.city := NULL;
   END IF;
   Address_Setup_API.Validate_Address_Attributes(lu_name_, 
                                                 newrec_.country, 
                                                 newrec_.address1, 
                                                 newrec_.address2, 
                                                 newrec_.address3, 
                                                 newrec_.address4, 
                                                 newrec_.address5, 
                                                 newrec_.address6, 
                                                 newrec_.zip_code, 
                                                 newrec_.city, 
                                                 newrec_.county, 
                                                 newrec_.state);
   newrec_.address := Address_Presentation_API.Format_Address(newrec_.country,
                                                              newrec_.address1,
                                                              newrec_.address2,
                                                              newrec_.address3, 
                                                              newrec_.address4, 
                                                              newrec_.address5, 
                                                              newrec_.address6, 
                                                              newrec_.city, 
                                                              newrec_.county,
                                                              newrec_.state,
                                                              newrec_.zip_code,
                                                              Iso_Country_API.Decode(newrec_.country));
   -- Check if connected address types still are valid according to modified date periods.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.person_id, newrec_.address_id) LOOP
         Person_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                              validation_flag_, 
                                                              c1.person_id, 
                                                              c1.def_address, 
                                                              c1.address_type_code, 
                                                              c1.rowid, 
                                                              newrec_.valid_from, 
                                                              newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', c1.address_type_code);
         END IF;
      END LOOP;
   END IF;
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('PERSON'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT person_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   def_exist_        VARCHAR2(5);
   def_address_      VARCHAR2(5);
   is_protected_     VARCHAR2(5);
   check_access_     VARCHAR2(5);
   source_           VARCHAR2(100);
   addr_types_       VARCHAR2(2000);
BEGIN
   Get_Person_Party___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
   source_ := Client_SYS.Get_Item_Value('SOURCE_WINDOW', attr_);
   IF (source_ = 'PERSON_INFO') THEN
      is_protected_ := Person_Info_API.Is_Protected(newrec_.person_id);
      check_access_ := Person_Info_API.Check_Access_To_Protected(newrec_.person_id);
      IF ((check_access_ = 'FALSE') AND (is_protected_ = 'TRUE')) THEN
         addr_types_ := Address_Type_Code_API.Get_Addr_Typs_For_Party_Type('PERSON');
         IF (INSTR(addr_types_, Address_Type_Code_API.DB_WORK) > 0) THEN
            def_exist_ := Person_Info_Address_Type_API.Default_Exist(newrec_.person_id, newrec_.address_id, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_WORK));
            IF (def_exist_ = 'TRUE') THEN
               def_address_ := 'FALSE';
            ELSE
               def_address_ := 'TRUE';
            END IF;
            Person_Info_Address_Type_API.New(newrec_.person_id, newrec_.address_id, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_WORK), def_address_);  
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOWORKADDRTYPE: User :P1 does not have access to protected persons. Addresses can only be added when the :P2 address type exist for Party type :P3.', Fnd_Session_API.Get_Fnd_User, Address_Type_Code_API.DB_WORK, Party_Type_API.Decode(Party_Type_API.DB_PERSON));
         END IF;
      ELSIF ((check_access_ = 'TRUE') AND (is_protected_ = 'TRUE')) THEN
         Person_Info_Address_Type_API.Add_Default_Address_Types(newrec_.person_id, newrec_.address_id);
      END IF; 
   END IF;
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (Business_Lead_Contact_API.Exist_Contact(newrec_.person_id) OR Person_Info_API.Get_Customer_Contact_Db(newrec_.person_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Log_Column_Changes___(newrec_ => newrec_);
      END IF;
   $END
END Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     person_info_address_tab%ROWTYPE,
   newrec_ IN OUT person_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   detailed_address_ enterp_address_country_tab.detailed_address%TYPE;
   address1_         person_info_address_tab.address1%TYPE;    
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   detailed_address_ := Enterp_Address_Country_API.Get_Detailed_Address(newrec_.country);
   IF (detailed_address_ = 'TRUE') THEN      
      IF (NVL(oldrec_.street, 'DUMMY')   <> NVL(newrec_.street, 'DUMMY') OR 
          NVL(oldrec_.house_no, 'DUMMY') <> NVL(newrec_.house_no, 'DUMMY') OR 
          NVL(oldrec_.flat_no, 'DUMMY')  <> NVL(newrec_.flat_no, 'DUMMY')) THEN
         IF (newrec_.flat_no IS NOT NULL) THEN
            address1_ := SUBSTR((newrec_.street || ' ' || newrec_.house_no || ' / ' || newrec_.flat_no),0,35);
         ELSE 
            address1_ := SUBSTR((newrec_.street || ' ' || newrec_.house_no),0,35);
         END IF;
         newrec_.address1 := address1_; 
      END IF;
   END IF;
END Check_Update___;

 
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN person_info_address_tab%ROWTYPE )
IS
   addr_type_code_list_     VARCHAR2(2000);
   addr_type_count_         NUMBER;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   counter_                 NUMBER := 1;
   info_str_                VARCHAR2(2000);
   CURSOR get_address_types (person_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT *
      FROM   person_info_address_type
      WHERE  person_id = person_id_
      AND    address_id = address_id_;
   CURSOR get_def_address_types_count (person_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*)
      FROM   person_info_address_type
      WHERE  person_id = person_id_
      AND    address_id = address_id_
      AND    def_address = 'TRUE';
BEGIN 
   OPEN get_def_address_types_count(remrec_.person_id, remrec_.address_id);
   FETCH get_def_address_types_count INTO addr_type_count_;
   CLOSE get_def_address_types_count;
   FOR rec_ IN get_address_types(remrec_.person_id, remrec_.address_id) LOOP
      Person_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, validation_flag_, rec_.person_id, rec_.def_address, rec_.address_type_code_db, rec_.objid, remrec_.valid_from, remrec_.valid_to);
      IF ((validation_result_ = 'TRUE') AND (rec_.def_address = 'TRUE')) THEN
         IF ((counter_ = 1)  AND (addr_type_count_ > 1)) THEN
            addr_type_code_list_ := CONCAT(rec_.address_type_code, ',');
         ELSIF (counter_ = addr_type_count_) THEN
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ''));
         ELSE
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ','));
         END IF;
      counter_ := counter_ + 1;
      END IF;   
   END LOOP;
   IF (addr_type_code_list_ IS NOT NULL) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRWITHDEFADDRTYPES: This is the default :P1 Address Type(s) for Person :P2. If removed, there will be no default address for this Address Type(s).', addr_type_code_list_, remrec_.person_id, remrec_.address_id);
   END IF;
   info_str_ := Client_SYS.Get_All_Info();
   super(remrec_);
   Client_SYS.Clear_Info();
   Client_SYS.Merge_Info(info_str_);     
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN person_info_address_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $ELSE
      NULL;
   $END
END Delete___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     person_info_address_tab%ROWTYPE,
   newrec_     IN OUT person_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(person_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.person_id, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   person_info_address_type_tab t
      WHERE  t.person_id = person_id_
      AND    t.address_id = address_id_;      
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (Business_Lead_Contact_API.Exist_Contact(newrec_.person_id) OR Person_Info_API.Get_Customer_Contact_Db(newrec_.person_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Log_Column_Changes___(oldrec_, newrec_);
      END IF;
   $END
   -- Logic to remove address default flag on other address IDs if time period overlaps.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.person_id, newrec_.address_id) LOOP
         Person_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                              validation_flag_, 
                                                              c1.person_id, 
                                                              c1.def_address, 
                                                              c1.address_type_code, 
                                                              c1.rowid, 
                                                              newrec_.valid_from, 
                                                              newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Person_Info_Address_Type_API.Check_Def_Addr_Temp(c1.person_id, 
                                                             c1.address_type_code, 
                                                             c1.def_address,
                                                             c1.rowid, 
                                                             newrec_.valid_from, 
                                                             newrec_.valid_to);
         END IF;
      END LOOP;
   END IF;
   $IF Component_Person_SYS.INSTALLED $THEN
      Cloud_Pay_Employee_Util_API.Send_Modified_Address(lu_name_, objid_, oldrec_, newrec_, 'ADDRESS');
   $END
END Update___;


PROCEDURE Log_Column_Changes___ (
   oldrec_ IN person_info_address_tab%ROWTYPE DEFAULT NULL,
   newrec_ IN person_info_address_tab%ROWTYPE )
IS
   old_attr_  VARCHAR2(32000):= Pack_Table___(oldrec_);
   new_attr_  VARCHAR2(32000):= Pack_Table___(newrec_);
   name_      VARCHAR2(50);
   new_value_ VARCHAR2(4000);
   old_value_ VARCHAR2(4000);
   ptr_       NUMBER;
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN
      WHILE (Client_SYS.Get_Next_From_Attr(new_attr_, ptr_, name_, new_value_)) LOOP
         IF (Business_Object_Columns_API.Exists_Person_Info_Db(name_)) THEN
            old_value_ := Client_SYS.Get_Item_Value(name_, old_attr_);
            IF (Validate_SYS.Is_Different(old_value_, new_value_)) THEN
               Crm_Person_Info_History_API.Log_History(oldrec_, newrec_, name_, old_value_, new_value_);  
            END IF;
         END IF;
      END LOOP;  
   $ELSE
      NULL;
   $END
END Log_Column_Changes___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN person_info_address_tab%ROWTYPE )
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
   rec_  IN person_info_address_tab%ROWTYPE )
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
   rec_  IN person_info_address_tab%ROWTYPE )
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
   rec_  IN     person_info_address_tab%ROWTYPE )
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

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ person_info_address_tab%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Cascade_Delete_Comm_Method__(remrec_.person_id, remrec_.address_id);   
   END IF;   
   super(info_, objid_, objversion_, action_);
END Remove__;


PROCEDURE Cascade_Delete_Comm_Method__ (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   CURSOR comm_method_ IS
      SELECT ROWID, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') AS rowversion
      FROM   comm_method_tab
      WHERE  party_type = 'PERSON'
      AND    identity   = person_id_
      AND    address_id = address_id_;
BEGIN
   FOR item_ IN comm_method_ LOOP
      Comm_Method_API.Remove__(info_, item_.ROWID, item_.rowversion, 'DO');
   END LOOP;
END Cascade_Delete_Comm_Method__;
 
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Address (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address;


@Override
@UncheckedAccess
FUNCTION Get_Valid_From (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN DATE
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Valid_From;


@Override
@UncheckedAccess
FUNCTION Get_Valid_To (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN DATE
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Valid_To;


@Override
@UncheckedAccess
FUNCTION Get_Party (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Party;


@Override
@UncheckedAccess
FUNCTION Get_Country (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Country;


@Override
@UncheckedAccess
FUNCTION Get_Party_Type (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Party_Type;


@Override
@UncheckedAccess
FUNCTION Get_Address1 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address1;


@Override
@UncheckedAccess
FUNCTION Get_Address2 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address2;


@Override
@UncheckedAccess
FUNCTION Get_Address3 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address3;


@Override
@UncheckedAccess
FUNCTION Get_Address4 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address4;


@Override
@UncheckedAccess
FUNCTION Get_Address5 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address5;


@Override
@UncheckedAccess
FUNCTION Get_Address6 (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address6;


@Override
@UncheckedAccess
FUNCTION Get_Zip_Code (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Zip_Code;


@Override
@UncheckedAccess
FUNCTION Get_City (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_City;


@Override
@UncheckedAccess
FUNCTION Get_County (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_County;


@Override
@UncheckedAccess
FUNCTION Get_State (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_State;


@Override
@UncheckedAccess
FUNCTION Get_Street (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Street;


@Override
@UncheckedAccess
FUNCTION Get_House_No (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_House_No;


@Override
@UncheckedAccess
FUNCTION Get_Flat_No (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Flat_No;


@Override
@UncheckedAccess
FUNCTION Get_Community (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Community;


@Override
@UncheckedAccess
FUNCTION Get_District (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_District;


@UncheckedAccess
FUNCTION Get_Line (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   line_no_    IN NUMBER DEFAULT 1 ) RETURN VARCHAR2
IS
   country_      person_info_address.country%TYPE;
   address_pres_ Address_Presentation_API.Public_Rec_Address;
   line_         NUMBER;
   row1_         VARCHAR2(100);
   row2_         VARCHAR2(100);
   row3_         VARCHAR2(100);
   row4_         VARCHAR2(100);
   row5_         VARCHAR2(100);
BEGIN
   country_ := Get_Country(person_id_, address_id_);
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   line_ := line_no_;
   -- IF line_no_ = 0 then return the last line.
   --    Set line_no_ to the highest row in the definition
   IF (line_ = 0 ) THEN
      line_ := address_pres_.address1_row;
      IF (address_pres_.address2_row > line_) THEN
         line_ := address_pres_.address2_row;
      END IF;
      IF (address_pres_.address3_row > line_) THEN
         line_ := address_pres_.address3_row;
      END IF;
      IF (address_pres_.address4_row > line_) THEN
         line_ := address_pres_.address4_row;
      END IF;
      IF (address_pres_.address5_row > line_) THEN
         line_ := address_pres_.address5_row;
      END IF;
      IF (address_pres_.address6_row > line_) THEN
         line_ := address_pres_.address6_row;
      END IF;
      IF (address_pres_.zip_code_row > line_ ) THEN
         line_ := address_pres_.zip_code_row;
      END IF;
      IF (address_pres_.city_row > line_) THEN
         line_ := address_pres_.city_row;
      END IF;
      IF (address_pres_.county_row > line_) THEN
         line_ := address_pres_.county_row;
      END IF;
      IF (address_pres_.state_row > line_) THEN
         line_ := address_pres_.state_row;
      END IF;      
   END IF;
   -- Check the different address fields for the correct line number.
   -- Put the value in the right order.
   IF (address_pres_.address1_row = line_) THEN   
      IF (address_pres_.address1_order = 1) THEN
         row1_ := Get_Address1(person_id_, address_id_);
      ELSIF (address_pres_.address1_order = 2) THEN
         row2_ := Get_Address1(person_id_, address_id_);
      ELSIF (address_pres_.address1_order = 3) THEN
         row3_ := Get_Address1(person_id_, address_id_);
      ELSIF (address_pres_.address1_order = 4) THEN
         row4_ := Get_Address1(person_id_, address_id_);
      ELSIF (address_pres_.address1_order = 5) THEN
         row5_ := Get_Address1(person_id_, address_id_);
      ELSE
         row1_ := Get_Address1(person_id_, address_id_);
      END IF;
   END IF;   
   IF (address_pres_.address2_row = line_) THEN   
      IF (address_pres_.address2_order = 1) THEN
         row1_ := Get_Address2(person_id_, address_id_);
      ELSIF (address_pres_.address2_order = 2) THEN
         row2_ := Get_Address2(person_id_, address_id_);
      ELSIF (address_pres_.address2_order = 3) THEN
         row3_ := Get_Address2(person_id_, address_id_);
      ELSIF (address_pres_.address2_order = 4) THEN
         row4_ := Get_Address2(person_id_, address_id_);
      ELSIF (address_pres_.address2_order = 5) THEN
         row5_ := Get_Address2(person_id_, address_id_);
      ELSE
         row1_ := Get_Address2(person_id_, address_id_);
      END IF;
   END IF;   
   IF (address_pres_.address3_row = line_) THEN
      IF (address_pres_.address3_order = 1) THEN
         row1_ := Get_Address3(person_id_, address_id_);
      ELSIF (address_pres_.address3_order = 2) THEN
         row2_ := Get_Address3(person_id_, address_id_);
      ELSIF (address_pres_.address3_order = 3) THEN
         row3_ := Get_Address3(person_id_, address_id_);
      ELSIF (address_pres_.address3_order = 4) THEN
         row4_ := Get_Address3(person_id_, address_id_);
      ELSIF (address_pres_.address3_order = 5) THEN
         row5_ := Get_Address3(person_id_, address_id_);
      ELSE
         row1_ := Get_Address3(person_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address4_row = line_) THEN
      IF (address_pres_.address4_order = 1) THEN
         row1_ := Get_Address4(person_id_, address_id_);
      ELSIF (address_pres_.address4_order = 2) THEN
         row2_ := Get_Address4(person_id_, address_id_);
      ELSIF (address_pres_.address4_order = 3) THEN
         row3_ := Get_Address4(person_id_, address_id_);
      ELSIF (address_pres_.address4_order = 4) THEN
         row4_ := Get_Address4(person_id_, address_id_);
      ELSIF (address_pres_.address4_order = 5) THEN
         row5_ := Get_Address4(person_id_, address_id_);
      ELSE
         row1_ := Get_Address4(person_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address5_row = line_) THEN
      IF (address_pres_.address5_order = 1) THEN
         row1_ := Get_Address5(person_id_, address_id_);
      ELSIF (address_pres_.address5_order = 2) THEN
         row2_ := Get_Address5(person_id_, address_id_);
      ELSIF (address_pres_.address5_order = 3) THEN
         row3_ := Get_Address5(person_id_, address_id_);
      ELSIF (address_pres_.address5_order = 4) THEN
         row4_ := Get_Address5(person_id_, address_id_);
      ELSIF (address_pres_.address5_order = 5) THEN
         row5_ := Get_Address5(person_id_, address_id_);
      ELSE
         row1_ := Get_Address5(person_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address6_row = line_) THEN
      IF (address_pres_.address6_order = 1) THEN
         row1_ := Get_Address6(person_id_, address_id_);
      ELSIF (address_pres_.address6_order = 2) THEN
         row2_ := Get_Address6(person_id_, address_id_);
      ELSIF (address_pres_.address6_order = 3) THEN
         row3_ := Get_Address6(person_id_, address_id_);
      ELSIF (address_pres_.address6_order = 4) THEN
         row4_ := Get_Address6(person_id_, address_id_);
      ELSIF (address_pres_.address6_order = 5) THEN
         row5_ := Get_Address6(person_id_, address_id_);
      ELSE
         row1_ := Get_Address6(person_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.zip_code_row = line_) THEN   
      IF (address_pres_.zip_code_order = 1) THEN
         row1_ := Get_Zip_Code(person_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 2) THEN
         row2_ := Get_Zip_Code(person_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 3) THEN
         row3_ := Get_Zip_Code(person_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 4) THEN
         row4_ := Get_Zip_Code(person_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 5) THEN
         row5_ := Get_Zip_Code(person_id_, address_id_);
      ELSE
         row1_ := Get_Zip_Code(person_id_, address_id_);
      END IF;
   END IF;   
   IF (address_pres_.city_row = line_) THEN   
      IF (address_pres_.city_order = 1) THEN
         row1_ := Get_City(person_id_, address_id_);
      ELSIF (address_pres_.city_order = 2) THEN
         row2_ := Get_City(person_id_, address_id_);
      ELSIF (address_pres_.city_order = 3) THEN
         row3_ := Get_City(person_id_, address_id_);
      ELSIF (address_pres_.city_order = 4) THEN
         row4_ := Get_City(person_id_, address_id_);
      ELSIF (address_pres_.city_order = 5) THEN
         row5_ := Get_City(person_id_, address_id_);
      ELSE
         row1_ := Get_City(person_id_, address_id_);
      END IF;
   END IF;   
   IF (address_pres_.county_row = line_) THEN   
      IF (address_pres_.county_order = 1) THEN
         row1_ := Get_County(person_id_, address_id_);
      ELSIF (address_pres_.county_order = 2) THEN
         row2_ := Get_County(person_id_, address_id_);
      ELSIF (address_pres_.county_order = 3) THEN
         row3_ := Get_County(person_id_, address_id_);
      ELSIF (address_pres_.county_order = 4) THEN
         row4_ := Get_County(person_id_, address_id_);
      ELSIF (address_pres_.county_order = 5) THEN
         row5_ := Get_County(person_id_, address_id_);
      ELSE
         row1_ := Get_County(person_id_, address_id_);
      END IF;
   END IF;   
   IF (address_pres_.state_row = line_) THEN   
      IF (address_pres_.state_order = 1) THEN
         row1_ := Get_State(person_id_, address_id_);
      ELSIF (address_pres_.state_order = 2) THEN
         row2_ := Get_State(person_id_, address_id_);
      ELSIF (address_pres_.state_order = 3) THEN
         row3_ := Get_State(person_id_, address_id_);
      ELSIF (address_pres_.state_order = 4) THEN
         row4_ := Get_State(person_id_, address_id_);
      ELSIF (address_pres_.state_order = 5) THEN
         row5_ := Get_State(person_id_, address_id_);
      ELSE
         row1_ := Get_State(person_id_, address_id_);
      END IF;
   END IF;   
   --Concatenate the different parts.
   RETURN RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
END Get_Line;


@UncheckedAccess
FUNCTION Get_Lines_Count (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   addr_  VARCHAR2(2000);
   ptr_   NUMBER;
   cnt_   NUMBER := 1;
BEGIN
   addr_ := RTRIM(REPLACE(Get_Address(person_id_,address_id_), CHR(13), ''), CHR(10));
   LOOP
      ptr_ := INSTR(addr_, CHR(10));
      IF (ptr_ > 0 AND ptr_ < LENGTH(addr_)) THEN
         cnt_ := cnt_ + 1;
         addr_ := SUBSTR(addr_, ptr_+1);
      ELSE
         EXIT;
      END IF;
   END LOOP;
   RETURN cnt_;
END Get_Lines_Count;


@UncheckedAccess
FUNCTION Get_Db_Types (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   types_   VARCHAR2(2000) := Client_SYS.text_separator_;
   CURSOR types IS
      SELECT address_type_code
      FROM   person_info_address_type_tab a, person_info_tab b
      WHERE  a.person_id = person_id_
      AND    address_id  = address_id_
      AND    a.person_id = b.person_id
      AND    'TRUE' = (SELECT Check_Access(person_id_, a.address_id, b.user_id, b.protected) FROM dual);
BEGIN
   FOR t IN types LOOP
      types_ := types_ || t.address_type_code || Client_SYS.text_separator_;
   END LOOP;
   RETURN types_;   
END Get_Db_Types;


@UncheckedAccess
FUNCTION Get_Id_By_Type (
   person_id_         IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20);
   addr_id_  VARCHAR2(50);
   CURSOR get_id_by IS
      SELECT a.address_id
      FROM   person_info_address_tab a, person_info_address_type_tab t, person_info_tab b
      WHERE  a.person_id = person_id_
      AND    t.person_id = a.person_id
      AND    t.address_id = a.address_id
      AND    t.def_address = 'TRUE'
      AND    t.address_type_code = db_value_
      AND    TRUNC(curr_date_) BETWEEN NVL(a.valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(a.valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    a.person_id = b.person_id
      AND    'TRUE' = (SELECT Check_Access(person_id_, a.address_id, b.user_id, b.protected) FROM dual);
BEGIN
   db_value_ := Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_id_by;
   FETCH get_id_by INTO addr_id_;
   IF (get_id_by%NOTFOUND) THEN
      CLOSE get_id_by;
      RETURN NULL;
   END IF;
   CLOSE get_id_by;
   RETURN addr_id_;   
END Get_Id_By_Type;


@UncheckedAccess
FUNCTION Is_Valid (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   curr_date_  IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   is_valid_    NUMBER;
   CURSOR valid_data IS
      SELECT 1
      FROM   person_info_address_tab
      WHERE  person_id = person_id_
      AND    address_id = address_id_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date());
BEGIN
   OPEN valid_data;
   FETCH valid_data INTO is_valid_;
   IF (valid_data%NOTFOUND) THEN
      CLOSE valid_data;
      RETURN 'FALSE';
   ELSE
      CLOSE valid_data;
      RETURN 'TRUE';
   END IF;
END Is_Valid;


PROCEDURE Remove (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   remrec_      person_info_address_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_, address_id_);
   remrec_ := Lock_By_Keys___(person_id_, address_id_);
   Cascade_Delete_Comm_Method__(remrec_.person_id, remrec_.address_id);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Get_Default_Address (
   person_id_         IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_def_address IS
      SELECT address_id
      FROM   person_info_address_tab a, person_info_tab b
      WHERE  a.person_id = person_id_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date())
      AND    a.person_id = b.person_id
      AND    'TRUE' = (SELECT Check_Access(person_id_, a.address_id, b.user_id, b.protected) FROM dual);
BEGIN
   FOR t IN get_def_address LOOP
      IF (Person_Info_Address_Type_API.Is_Default(person_id_, t.address_id, address_type_code_) = 'TRUE') THEN
         RETURN t.address_id;
      END IF;
   END LOOP;
   RETURN NULL;   
END Get_Default_Address;


PROCEDURE New_Address (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   address1_   IN VARCHAR2 DEFAULT NULL,
   address2_   IN VARCHAR2 DEFAULT NULL,
   zip_code_   IN VARCHAR2 DEFAULT NULL,
   city_       IN VARCHAR2 DEFAULT NULL,
   state_      IN VARCHAR2 DEFAULT NULL,
   country_    IN VARCHAR2,
   valid_from_ IN DATE     DEFAULT NULL,
   valid_to_   IN DATE     DEFAULT NULL,
   county_     IN VARCHAR2 DEFAULT NULL,
   street_     IN VARCHAR2 DEFAULT NULL,
   house_no_   IN VARCHAR2 DEFAULT NULL,
   flat_no_    IN VARCHAR2 DEFAULT NULL,
   community_  IN VARCHAR2 DEFAULT NULL,
   district_   IN VARCHAR2 DEFAULT NULL,
   address3_   IN VARCHAR2 DEFAULT NULL,
   address4_   IN VARCHAR2 DEFAULT NULL,
   address5_   IN VARCHAR2 DEFAULT NULL,
   address6_   IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       person_info_address_tab%ROWTYPE;
BEGIN
   newrec_.person_id    := person_id_;
   newrec_.address_id   := address_id_;
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.county       := county_;
   newrec_.state        := state_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.party_type   := 'PERSON';
   newrec_.default_domain  := 'TRUE';
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   newrec_.street       := street_;
   newrec_.house_no     := house_no_ ;
   newrec_.flat_no      := flat_no_ ;
   newrec_.community    := community_ ;
   newrec_.district     := district_;
   New___(newrec_);
END New_Address;


PROCEDURE Modify_Address (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   address1_   IN VARCHAR2 DEFAULT NULL,
   address2_   IN VARCHAR2 DEFAULT NULL,
   zip_code_   IN VARCHAR2 DEFAULT NULL,
   city_       IN VARCHAR2 DEFAULT NULL,
   state_      IN VARCHAR2 DEFAULT NULL,
   country_    IN VARCHAR2 DEFAULT NULL,
   valid_from_ IN DATE     DEFAULT NULL,
   valid_to_   IN DATE     DEFAULT NULL,
   county_     IN VARCHAR2 DEFAULT NULL,
   street_     IN VARCHAR2 DEFAULT NULL,
   house_no_   IN VARCHAR2 DEFAULT NULL,
   flat_no_    IN VARCHAR2 DEFAULT NULL,
   community_  IN VARCHAR2 DEFAULT NULL,
   district_   IN VARCHAR2 DEFAULT NULL,
   address3_   IN VARCHAR2 DEFAULT NULL,
   address4_   IN VARCHAR2 DEFAULT NULL,
   address5_   IN VARCHAR2 DEFAULT NULL,
   address6_   IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       person_info_address_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(person_id_, address_id_);
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.county       := county_;
   newrec_.state        := state_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   newrec_.street       := street_;
   newrec_.house_no     := house_no_ ;
   newrec_.flat_no      := flat_no_ ;
   newrec_.community    := community_ ;
   newrec_.district     := district_;
   Modify___(newrec_);
END Modify_Address;


PROCEDURE Close_Address (
   person_id_   IN VARCHAR2,
   address_id_  IN VARCHAR2,
   close_date_  IN DATE, 
   at_begining_ IN VARCHAR2 )
IS
   newrec_       person_info_address_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(person_id_, address_id_);
   IF (at_begining_ = 'TRUE') THEN
      newrec_.valid_from := close_date_;
   ELSE
      newrec_.valid_to := close_date_;
   END IF;
   Modify___(newrec_);
END Close_Address;


@Override
@UncheckedAccess
FUNCTION Get (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN Public_Rec
IS   
BEGIN
   IF (Check_Access___(person_id_, address_id_)) THEN      
      RETURN super(person_id_, address_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get;


FUNCTION Get_Address_Form (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   fetch_name_   IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE',
   separator_    IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   address_         VARCHAR2(2000);
   country_         VARCHAR2(35);
   name_            person_info_tab.name%TYPE;
   address_record_  Public_Rec;
BEGIN
   address_record_ := Get (identity_, address_id_);
   address_ := Address_Presentation_API.Format_Address(address_record_.country,
                                                       address_record_.address1,
                                                       address_record_.address2,
                                                       address_record_.address3, 
                                                       address_record_.address4, 
                                                       address_record_.address5, 
                                                       address_record_.address6, 
                                                       address_record_.city,
                                                       address_record_.county,
                                                       address_record_.state,
                                                       address_record_.zip_code,
                                                       country_);
   IF (fetch_name_ = 'TRUE') THEN
      name_    := Person_Info_API.Get_Name(identity_);
      address_ := name_ || Address_Presentation_API.lfcr_ || address_;
   END IF;                            
   IF (separator_ IS NOT NULL) THEN
      address_ := REPLACE(address_,Address_Presentation_API.lfcr_,separator_);                                                        
   END IF;
   RETURN address_;
END Get_Address_Form;


FUNCTION Get_Address_Rec (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   fetch_name_   IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN Address_Presentation_API.Address_Rec_Type
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_         VARCHAR2(2000);
BEGIN
   address_ := Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_);
   address_rec_ := Address_Presentation_API.Format_To_Line(address_);
   RETURN address_rec_;
END Get_Address_Rec;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
END Get_All_Address_Lines;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   address_7_    IN OUT VARCHAR2,
   address_8_    IN OUT VARCHAR2,
   address_9_    IN OUT VARCHAR2,
   address_10_   IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
   address_7_   := address_rec_.address7;
   address_8_   := address_rec_.address8;
   address_9_   := address_rec_.address9;
   address_10_  := address_rec_.address10;
END Get_All_Address_Lines;


FUNCTION Get_Address_Line (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   line_no_      IN NUMBER DEFAULT 1,
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_line_    VARCHAR2(2000);
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, 'FALSE', remove_empty_);
   address_line_ := CASE line_no_
                       WHEN 1 THEN address_rec_.address1
                       WHEN 2 THEN address_rec_.address2
                       WHEN 3 THEN address_rec_.address3
                       WHEN 4 THEN address_rec_.address4
                       WHEN 5 THEN address_rec_.address5
                       WHEN 6 THEN address_rec_.address6
                       WHEN 7 THEN address_rec_.address7
                       WHEN 8 THEN address_rec_.address8
                       WHEN 9 THEN address_rec_.address9
                       WHEN 10 THEN address_rec_.address10
                    END;
   RETURN address_line_;
END Get_Address_Line;


PROCEDURE Sync_Addr (
   country_code_   IN VARCHAR2 )
IS
   address_        person_info_address_tab.address%TYPE;
   country_        iso_country_tab.description%TYPE;
   CURSOR get_records IS
      SELECT country, 
             address1,
             address2, 
             address3, 
             address4, 
             address5, 
             address6, 
             city, 
             county, 
             state, 
             zip_code,
             address,  
             ROWID objid
      FROM   person_info_address_tab
      WHERE  country = country_code_
      FOR UPDATE;   
BEGIN
   country_:= Iso_Country_API.Decode(country_code_);   
   FOR rec_ IN get_records LOOP
      address_ := Address_Presentation_API.Format_Address(rec_.country, 
                                                          rec_.address1, 
                                                          rec_.address2, 
                                                          rec_.address3, 
                                                          rec_.address4, 
                                                          rec_.address5, 
                                                          rec_.address6, 
                                                          rec_.city,
                                                          rec_.county, 
                                                          rec_.state, 
                                                          rec_.zip_code, 
                                                          country_); 
      IF (address_ != rec_.address) THEN
         UPDATE person_info_address_tab
            SET address = address_       
          WHERE ROWID = rec_.objid;       
      END IF;                            
   END LOOP; 
END Sync_Addr;


PROCEDURE Get_Default_Contact_Info (
   phone_      OUT VARCHAR2,
   mobile_     OUT VARCHAR2,
   email_      OUT VARCHAR2,
   fax_        OUT VARCHAR2,
   pager_      OUT VARCHAR2,
   intercom_   OUT VARCHAR2,
   www_        OUT VARCHAR2,
   person_id_  IN  VARCHAR2,
   address_id_ IN  VARCHAR2,
   curr_date_  IN  DATE DEFAULT SYSDATE )
IS
BEGIN
   phone_    := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('PHONE'), 1, address_id_, curr_date_);
   mobile_   := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('MOBILE'), 1, address_id_, curr_date_);
   email_    := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('E_MAIL'), 1, address_id_, curr_date_);
   fax_      := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('FAX'), 1, address_id_, curr_date_);
   pager_    := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('PAGER'), 1, address_id_, curr_date_);
   intercom_ := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('INTERCOM'), 1, address_id_, curr_date_);
   www_      := Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('WWW'), 1, address_id_, curr_date_);
END Get_Default_Contact_Info;


@UncheckedAccess
FUNCTION Check_Access (
   person_id_    IN VARCHAR2,
   address_id_   IN VARCHAR2,
   user_id_      IN VARCHAR2 DEFAULT NULL,
   protected_    IN VARCHAR2 DEFAULT NULL,
   session_user_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS 
BEGIN
   IF (Check_Access___(person_id_, address_id_, user_id_, protected_, session_user_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Access;


FUNCTION Get_Next_Address_Id (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   temp_       NUMBER;
   CURSOR get_next IS
      SELECT MAX(TO_NUMBER(address_id)) 
      FROM   person_info_address_tab 
      WHERE  regexp_like(address_id,'^[0-9]+$')
      AND    person_id = person_id_;      
BEGIN
   OPEN  get_next;
   FETCH get_next INTO temp_;
   CLOSE get_next;
   RETURN GREATEST(NVL(temp_, 0)) + 1;  
END Get_Next_Address_Id;


-- This method is to be used by Aurena
PROCEDURE Modify_Detailed_Address (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   street_     IN VARCHAR2,
   house_no_   IN VARCHAR2,
   flat_no_    IN VARCHAR2,
   community_  IN VARCHAR2,
   district_   IN VARCHAR2 )
IS
   newrec_       person_info_address_tab%ROWTYPE;
   new_address1_ VARCHAR2(2000); 
BEGIN
   IF (flat_no_ IS NOT NULL) THEN
      new_address1_ := CONCAT(street_, CONCAT(' ', CONCAT(house_no_, CONCAT(' / ', flat_no_))));
   ELSE
      new_address1_ := CONCAT(street_, CONCAT(' ', house_no_));
   END IF;
   newrec_ := Get_Object_By_Keys___(person_id_, address_id_);
   newrec_.address1     := new_address1_;
   newrec_.street       := street_;
   newrec_.house_no     := house_no_ ;
   newrec_.flat_no      := flat_no_ ;
   newrec_.community    := community_ ;
   newrec_.district     := district_;
   Modify___(newrec_);
END Modify_Detailed_Address;


-- This method is to be used by Aurena
PROCEDURE Modify_Address_Info (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   address1_   IN VARCHAR2,
   address2_   IN VARCHAR2,
   address3_   IN VARCHAR2,
   address4_   IN VARCHAR2,
   address5_   IN VARCHAR2,
   address6_   IN VARCHAR2,
   zip_code_   IN VARCHAR2,
   city_       IN VARCHAR2,
   state_      IN VARCHAR2,
   county_     IN VARCHAR2,
   country_    IN VARCHAR2,   
   valid_from_ IN DATE,
   valid_to_   IN DATE )
IS
   newrec_       person_info_address_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(person_id_, address_id_);
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.county       := county_;
   newrec_.state        := state_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   Modify___(newrec_);
END Modify_Address_Info;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN person_info_address_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END 
END Pack_Table;
