-----------------------------------------------------------------------------
--
--  Logical unit: PersonInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date   Sign     History
--  ------ ------   ---------------------------------------------------------
--  981116 Camk     Created
--  990205 Camk     View Person_Info_User added.
--  990415 Camk     New template
--  990820 BmEk     Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for person_id.
--                  Added a control in Insert___ instead, to check if person_id is null. This
--                  because it should be possible to fetch an automatic generated person_id
--                  from LU PartyIdentitySeries. Also added the procedure Get_Identity___.
--  000128 Mnisse   Check on capital letters for ID, bug #30596.
--  000310 Camk     Method Create_H_R_Person added.
--  000502 Camk     Picture Id added to method New and Modify
--  000525 LiSv     Removed call to Check_If_Null___ (this is an old solution).
--  000804 Camk     Bug #15677 Corrected. General_SYS.Init_Method added
--  001219 MAMIPL   Bug #18427 Default language, country removed when "Replace Person Id" used.
--  010504 Inkase   Bug #20229, Added check if entered country or language is 2 characters,
--                  then save it, else encode it. Also set uppercase on country.
--  020122 JOHESE   Added handling for new translation support in Insert___, Delete___, Update___
--                  and a new PROCEDURE Insert_Lu_Data_Rec__.
--  020222 ovjose   Added translation support in get-methods
--  020513 BmEk     Bug #26954. Replaced Client_SYS.Add_To_Attr with Client_SYS.Set_Item_Value
--  020513          in Get_Identity___
--  020712 Brwelk   Bug# 27811.
--  030106 THSRLK   Removed procedure Replace_Person_id
--  030211 Hawalk   Bug 35228, (not directly related to the bug) Solved the problem of wrong names being
--  030211          fetched from the translation tables after replacing the person identity. Added a new
--  030211          DEFAULT parameter replace_ to the procedure Modify.
--  030214 Hawalk   Bug 35228, Removed comments for the correction and aligned parameters of New, Modify
--  030214          and some implementation subroutines.
--  040823 Mnisse   Added a number of Name fields, moved from Pers in HR
--  040913 Mnisse   Added Picture_Thumbnail_Id
--  041004 SAAHLK   LCS Patch Merge, Bug 37877.
--  050919 Hecolk   LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___
--  061129 ThWilk   Merged LCS Bug 51762, Modified 'Modify' procedure to update the picture_id even with a null value.  
--  070404 ToBeSe   Added view PERSON_INFO_ALL.
--  080201 jakalk   Bug 69651, Added new view PERSON_INFO_LOV to show only necessary data for a LOV  
--  070801 Kagalk   Bug 74543, Enable to save person name when using different languages, 
--  070801          Modified PERSON_INFO_ALL view to display name according to the language used.
--  090320 MOHRLK   Bug 79377, Changed the column comment ref of the
--  090320          "user_id" in PERSON_INFO and PERSON_INFO_ALL views to FndUser
--  090320          Also modified Unpack_Check_Insert___ and Unpack_Check_Update___ methods. 
--  100816 Hiralk   Bug 92395, Modified Get_Next_Identity(). If two users try to get next 
--                  identity at the same time one is wait till the other one update it.
--  190522 Basblk   Bug 146766, Modified Insert___, Update___ methods to hide middle name. 
--  190522          added Validate_Parameter, Update_Person_Names and Configure_Middle_Name__ methods.
--  ----------------------- Dexter ------------------------------------------
--  090916 ShWilk   Upgraded Dexter implementations to App7.5 SP4 
--  091005 Rumelk   Modified view PERSON_INFO_LOV.
-----------------------------------------------------------------------------
--  110514 Chhulk   EASTONE-19651, Merged bug 96902
--  110804 Chhulk   FIDEAGLE-1221, Merged bug 98098     
--  110831 Chhulk   EASTTWO-10220, Merged bug 98641
--  120813 Chwilk   Bug 103582, Modified PERSON_INFO_ALL view.
--  120907 DeKolk   Bug 103801, Modified Lov flag of alias, external_display_name, internal_display_name columns in PERSON_INFO view.
--  130529 Pacipl   Bug 108138. New function Get_Id_For_Current_User with microcache implemented.
--  -------------------------Point Break-----------------------------------------
--  130520 MaRalk   PBR-1605, Added public attribtes Customer_Contact, Blocked_For_Use and modified relevant methods.
--  130530 MaRalk   PBR-1624, Added method Exist_Customer_Contacts___ and modified Unpack_Check_Update___ 
--  130530          in order to avoid unselecting Contact check box when person is using as a customer contact. 
--  130611 MaRalk   PBR-1764, Added method Analyze_Name in order to use in Contact_Util_API.Create_Contact method
--  130611          and in Modify, New methods. 
--  130614 DipeLK   TIBE-726, Removed global variable which is used to check the exsistance of PERSON component
--  131008 MaRalk   PBR-1621, Added derived attribute UpdateConBlockForCrmObjs and modified Check_Update___ accordingly.
--  ---------------------CAPTAIN HOOK----------------------------------------
--  131023 Isuklk   CAHOOK-2845 Refactoring in PersonInfo.entity
--  140225 NiDalk   PBSC-7306 Added default parameter customer_contact_ to method New.
--  140725 Hecolk   PRFI-41, Moved code that generates Person Id from Check_Insert___ to Insert___ 
--  141116 AjPelk   PRFI-3262, Merged lcs bug is 119448
--  150410 DipeLK   Bug 121579,Resolved incostancy between employee and person
--  150506 SudJlk   ORA-287, Modified Check_Insert___(), Prepare_Insert___() and New() to set default values to
--  150506          Supplier_Contact and Blocked_For_Use_Supplier.
--  150515 SudJlk   ORA-292, Modified Check_Update___() to restrict updating supplier_contact to FALSE when the person 
--  150515          is already used as a supplier contact. 
--  150604 Wahelk   BLU-749, Added method Get_Person_Id_For_Objid
--  150706 MaIklk   BLU-490, Added Get_Last_Modified().
--  150706 SudJlk   ORA-869, Modified New() to pass value for supplier_contact.
--  150811 Chhulk   Bug 121522, Merged correction to app9. Added method Is_User_Available_Person_Id()
--  150903 SuWjLK   AFT-2799, Added parameter protected_ to PROCEDURES New and Modify.
--  151012 chiblk   STRFI-233  Creating records using New___ method
--  151209 Bhhilk   STRFI-684, Added UncheckedAccess annotation to Check_Access() methord
--  160314 Chwilk   STRFI-1225, Modified Add_Modify_H_R_Person.
--  160929 AmThLK   STRFI-3612, Modified Add_Modify_Person_Details
--  180122 niedlk   Modified Update___ and added new method Log_Column_Changes___ to log CRM related person info changes.
--  -------------------------UXX Waves----------------------------------------
--  170707 MaIklk   SCUXX-312, Added title to Modify().
--  180122 niedlk   Modified Update___ and added new method Log_Column_Changes___ to log CRM related person info changes.
--  180607 thjilk   Added Handle_Crm_Columns and Handle_Srm_Columns methods to handle CRM and SRM related columns in Person.
--  180720  JanWse  SCUXX-3748, Added public version of Pack_Table___ (Pack_Table)
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  190206  ThJilk  Removed check for Fndab1.
--  190515 Dethlk   Merge Bug 146300, Retention of middle name information in Employee window
--  190718  Basblk  Bug 148922, Added Update_Cache_Expose_Mname___, Invalidate_Cache_Mname___ and Is_Middle_Name_Exposed to handle micro cache. made Is_Employee_Connected obsolete.
--  190618 MaIklk   SCUXXW4-21305, Removed title not null check in Modify() whihc was added using SCUXX-312.
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified Write_Person_Image__ method.
--  210720  Diwslk  FI21R2-2216, Added procedure Modify_Full_Name to support new field JobTitle. Old Modify_Full Name will be used from other dependent components.
--  211203  Kavflk  CRM21R2-258 , Added job_title_ into  New PROCEDURE & Modify PROCEDURE.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

micro_cache_value_cfu_   person_info_tab.person_id%TYPE;

micro_cache_id_cfu_      person_info_tab.user_id%TYPE;

micro_cache_language_    VARCHAR2(10);

micro_cache_time_lang_   NUMBER := 0;

micro_cache_time_cfu_    NUMBER := 0;

micro_cache_expose_mname_     VARCHAR2(5);

micro_cache_time_mname_       NUMBER := 0;

micro_cache_max_time_mname_   NUMBER := 60;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Next_Party___ (
   newrec_  IN OUT person_info_tab%ROWTYPE )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);   
END Get_Next_Party___;


PROCEDURE Check_Protected___ (
   old_flag_  IN VARCHAR2,
   new_flag_  IN VARCHAR2 )
IS
BEGIN
   IF (new_flag_ NOT IN ('TRUE', 'FALSE')) THEN
      Error_SYS.Item_Format(lu_name_, 'PROTECTED', new_flag_);
   END IF;
   IF (NVL(old_flag_, new_flag_) <> new_flag_) THEN
      IF (Party_Admin_User_API.Check_Exist('DEFAULT', Application_User_API.Get_Current_User) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'USRNAUTH: You are not authorized to change the protected flag.');
      END IF;
   END IF;
END Check_Protected___;


PROCEDURE Update_Cache_Cfu___ (
   current_user_id_ IN VARCHAR2 )
IS
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_ := Database_SYS.Get_Time_Offset;
   -- Calculate if the cached value has expired (assumed that cache could be not older than 60 seconds)
   expired_ := ((time_ - micro_cache_time_cfu_) > 60);
   -- Check if expired and Primary Key is equal to the Cached Key
   IF (NOT expired_ AND (micro_cache_id_cfu_ = current_user_id_)) THEN
      NULL;
   ELSE
      micro_cache_value_cfu_ := Get_Id_For_User(current_user_id_);
      micro_cache_id_cfu_    := current_user_id_;
      micro_cache_time_cfu_  := time_;
   END IF;
END Update_Cache_Cfu___;


PROCEDURE Invalidate_Cache_Cfu___
IS
   null_value_   person_info_tab.person_id%TYPE;
BEGIN
   micro_cache_id_cfu_    := NULL;
   micro_cache_value_cfu_ := null_value_;
END Invalidate_Cache_Cfu___;


PROCEDURE Update_Cache_Language___
IS
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_ := Database_SYS.Get_Time_Offset;
   -- Calculate if the cached value has expired (assumed that cache could be not older than 100 seconds)
   expired_ := ((time_ - micro_cache_time_lang_) > 100);
   IF (NOT expired_ AND micro_cache_language_ IS NOT NULL) THEN
      NULL;
   ELSE
      micro_cache_language_ := Fnd_Session_API.Get_Language; 
      micro_cache_time_lang_ := time_;
   END IF;
END Update_Cache_Language___;


PROCEDURE Update_Cache_Expose_Mname___
IS
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_ := Database_SYS.Get_Time_Offset;
   -- Calculate if the cached values has expired (assumed that cahce could not be older than 60 seconds)
   expired_ := ((time_ - micro_cache_time_mname_) > micro_cache_max_time_mname_);
   IF (NOT expired_ AND micro_cache_expose_mname_ IS NOT NULL) THEN
      NULL;
   ELSE
      micro_cache_expose_mname_ := Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME');
      micro_cache_time_mname_ := time_;
   END IF;
END Update_Cache_Expose_Mname___;


PROCEDURE Invalidate_Cache_Mname___
IS
BEGIN
   micro_cache_expose_mname_ := NULL;
END Invalidate_Cache_Mname___;


FUNCTION Exist_Customer_Contacts___ (
   person_id_ IN VARCHAR2 ) RETURN BOOLEAN 
IS
  found_  NUMBER;
  CURSOR get_customer_contacts IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  person_id = person_id_;
BEGIN
   OPEN get_customer_contacts;
   FETCH get_customer_contacts INTO found_;
   IF (get_customer_contacts%NOTFOUND) THEN
      CLOSE get_customer_contacts;
      RETURN FALSE;
   END IF;
   CLOSE get_customer_contacts;
   RETURN TRUE; 
END Exist_Customer_Contacts___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('PROTECTED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('PERSON'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_CONTACT_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_CONTACT_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_SUPPLIER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT person_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   from_hr_      VARCHAR2(5) := 'FALSE'; 
BEGIN
   IF (Client_SYS.Item_Exist('FROM_HR', attr_)) THEN
      from_hr_ := Client_SYS.Cut_Item_Value('FROM_HR', attr_);
   END IF;
   IF (newrec_.person_id IS NULL) THEN
      newrec_.person_id := Get_Next_Identity();
      IF (newrec_.person_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'PERS_ERROR: Error while retrieving the next free identity. Check the identity series for person');
      END IF;
      Party_Identity_Series_API.Update_Next_Value(newrec_.person_id + 1, newrec_.party_type);
      Client_SYS.Set_Item_Value('PERSON_ID', newrec_.person_id, attr_);
   END IF;      
   Get_Next_Party___(newrec_);
   Check_Protected___(NULL, newrec_.protected);
   IF (Object_Property_API.Exists(lu_name_, '*', 'EXPOSE_MIDDLE_NAME')) THEN
      IF (Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME') = 'FALSE') THEN
         newrec_.name := Get_Constructed_Full_Name___(newrec_.first_name, NULL, newrec_.last_name);
      END IF;
   END IF;
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
   IF (from_hr_ = 'FALSE') THEN
      Add_Modify_H_R_Person(newrec_.person_id, newrec_.first_name, newrec_.last_name, newrec_.middle_name, newrec_.prefix, newrec_.birth_name, newrec_.initials, newrec_.title);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     person_info_tab%ROWTYPE,
   newrec_     IN OUT person_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   from_hr_                   VARCHAR2(5) := 'FALSE';
   hr_data_changed_           VARCHAR2(5) := 'FALSE';
   resource_seq_              NUMBER;
   called_from_pers_data_man_ VARCHAR2(5) := 'FALSE';
   full_name_                 person_info_tab.name%TYPE;
BEGIN
   IF (Client_SYS.Item_Exist('FROM_HR', attr_)) THEN
      from_hr_ := Client_SYS.Cut_Item_Value('FROM_HR', attr_);
   END IF;
   IF (Client_SYS.Item_Exist('HR_DATA_CHANGED', attr_)) THEN
      hr_data_changed_ := Client_SYS.Cut_Item_Value('HR_DATA_CHANGED', attr_);
   END IF;
   Check_Protected___(oldrec_.protected, newrec_.protected);
   called_from_pers_data_man_ := App_Context_SYS.Find_Value('PERSONAL_DATA_MAN_UTIL_API.EXECUTE_DATA_SUBJECT_CLEANUP', 'FALSE');   
   IF (called_from_pers_data_man_ = 'TRUE') THEN
      IF (Object_Property_API.Exists(lu_name_, '*', 'EXPOSE_MIDDLE_NAME')) THEN
        IF (Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME') = 'FALSE') THEN
           full_name_ := Get_Constructed_Full_Name___(newrec_.first_name, NULL, newrec_.last_name);
        ELSE
           full_name_ := Get_Constructed_Full_Name___(newrec_.first_name, newrec_.middle_name, newrec_.last_name);
        END IF;
      ELSE
         full_name_ := Get_Constructed_Full_Name___(newrec_.first_name, newrec_.middle_name, newrec_.last_name);
      END IF;
      IF (oldrec_.name != full_name_) THEN
         newrec_.name := full_name_;
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Mxcore_SYS.INSTALLED $THEN 
      Mx_User_Util_API.Perform_Update(lu_name_, Pack___(oldrec_), Pack___(newrec_));
   $END
   IF (oldrec_.user_id = micro_cache_id_cfu_) AND (oldrec_.user_id <> newrec_.user_id OR oldrec_.person_id <> newrec_.person_id) THEN
      Invalidate_Cache_Cfu___;
   END IF;
   IF (from_hr_ = 'FALSE') AND (called_from_pers_data_man_ = 'FALSE') AND (hr_data_changed_ = 'TRUE') THEN
      Add_Modify_H_R_Person(newrec_.person_id, newrec_.first_name, newrec_.last_name, newrec_.middle_name, newrec_.prefix, newrec_.birth_name, newrec_.initials, newrec_.title);
   END IF;
   $IF Component_Genres_SYS.INSTALLED $THEN
      resource_seq_ := Resource_Util_API.Get_Resource_Seq(newrec_.person_id, Resource_Types_API.DB_PERSON);
      IF ((newrec_.name != oldrec_.name) AND (resource_seq_ IS NOT NULL)) THEN
         Resource_API.Modify_Description(resource_seq_   => resource_seq_,
                                         description_    => newrec_.name);
      END IF;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF (Business_Lead_Contact_API.Exist_Contact(newrec_.person_id) OR newrec_.customer_contact = Fnd_Boolean_API.DB_TRUE) THEN 
         Log_Column_Changes___(oldrec_, newrec_);
      END IF;
   $END           
   IF (newrec_.picture_id IS NULL AND NVL(oldrec_.picture_id,oldrec_.picture_id) != 0) THEN
      IF (Binary_Object_API.Exists(oldrec_.picture_id)) THEN
         Binary_Object_API.Do_Delete(oldrec_.picture_id);
      END IF;
   END IF;
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN person_info_tab%ROWTYPE )
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
   -- Delete any referenced binary object
   IF (NOT remrec_.picture_id IS NULL) AND (remrec_.picture_id != 0) THEN
      Binary_Object_API.Do_Delete(remrec_.picture_id);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT person_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT(indrec_.customer_contact = TRUE) THEN   
      newrec_.customer_contact :=  Fnd_Boolean_API.DB_FALSE; 
   END IF;   
   IF NOT(indrec_.blocked_for_use = TRUE) THEN    
      newrec_.blocked_for_use :=  Fnd_Boolean_API.DB_FALSE; 
   END IF;
   IF NOT(indrec_.supplier_contact = TRUE) THEN   
      newrec_.supplier_contact :=  Fnd_Boolean_API.DB_FALSE; 
   END IF;   
   IF NOT(indrec_.blocked_for_use_supplier = TRUE) THEN    
      newrec_.blocked_for_use_supplier :=  Fnd_Boolean_API.DB_FALSE; 
   END IF;
   IF (indrec_.person_id = TRUE) THEN      
      IF (UPPER(newrec_.person_id) != newrec_.person_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
      END IF;
   END IF;        
   super(newrec_, indrec_, attr_); 
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     person_info_tab%ROWTYPE,
   newrec_ IN OUT person_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   update_con_block_for_crm_objs_ BOOLEAN := FALSE;
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
   IF ((oldrec_.customer_contact = Fnd_Boolean_API.DB_TRUE) AND (newrec_.customer_contact = Fnd_Boolean_API.DB_FALSE)) THEN
      IF (Exist_Customer_Contacts___(newrec_.person_id)) THEN
         Error_SYS.Record_General(lu_name_, 'PERSONISUSEDASCONTACT: Person :P1 has been used as a contact by customer objects.', newrec_.person_id);           
      END IF;   
   END IF;   
   IF (Client_SYS.Get_Item_Value('UPDATE_CON_BLOCK_FOR_CRM_OBJS', attr_) = 'TRUE') THEN
      update_con_block_for_crm_objs_ := TRUE;
   END IF;
   IF ((oldrec_.blocked_for_use = Fnd_Boolean_API.DB_FALSE) AND (newrec_.blocked_for_use = Fnd_Boolean_API.DB_TRUE) AND (update_con_block_for_crm_objs_)) THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         IF (Business_Object_Contact_API.Exist_Contact(newrec_.person_id) OR Business_Lead_Contact_API.Exist_Contact(newrec_.person_id)) THEN
            Client_SYS.Add_Info(lu_name_, 'PERSONUSEDASBUSINESSCONTACT: Person :P1 which you are blocking is used as a contact by CRM objects. Please consider replacing the contact on these objects.', newrec_.person_id); 
         END IF;
      $ELSE
          NULL;
      $END        
   END IF;
   IF ((oldrec_.blocked_for_use != newrec_.blocked_for_use) AND update_con_block_for_crm_objs_) THEN
      Customer_Info_Contact_API.Modify_Blocked_For_Crm_Objects(newrec_.person_id, newrec_.blocked_for_use);
   END IF;
   IF ((oldrec_.supplier_contact = Fnd_Boolean_API.DB_TRUE) AND (newrec_.supplier_contact = Fnd_Boolean_API.DB_FALSE)) THEN
      IF (Supplier_Info_Contact_API.Is_Supplier_Contact(newrec_.person_id) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'USEDASSUPPCONTACT: The person :P1 has been used as a contact by supplier objects.', newrec_.person_id);           
      END IF;   
   END IF;
   IF (indrec_.person_id OR indrec_.first_name OR indrec_.last_name OR indrec_.middle_name OR indrec_.prefix OR indrec_.birth_name OR indrec_.initials OR indrec_.title) THEN
      Client_SYS.Add_To_Attr('HR_DATA_CHANGED', 'TRUE', attr_);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN person_info_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Genres_SYS.INSTALLED $THEN
      IF (Resource_API.Check_Exist_Id (remrec_.person_id, 'PERSON')) THEN
         Error_SYS.Record_General(lu_name_, 'REMOVEWHENRESOURCE: Cannot remove person ":P1" when used as Resource.', remrec_.person_id);     
      END IF;
   $END
   super(remrec_);
END Check_Delete___;


FUNCTION Check_Access___ (
   person_id_    IN VARCHAR2,
   user_id_      IN VARCHAR2 DEFAULT NULL,
   protected_    IN VARCHAR2 DEFAULT NULL,
   session_user_ IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS 
BEGIN
   IF (Person_Company_Access_API.Check_Person_Access(Fnd_Session_API.Get_Fnd_User, person_id_) = 'TRUE') THEN
      IF ((Party_Admin_User_API.Exist_Current_User AND person_id_ = Is_User_Available_Person_Id___(person_id_)) OR 
         (NVL(protected_, Is_Protected(person_id_)) = 'FALSE') OR
         (NVL(session_user_, Fnd_Session_API.Get_Fnd_User) = NVL(user_id_, Get_User_Id(person_id_)))) THEN
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Check_Access___;    


-- This function checks the session user's accessibility to the person by calling an HR method.
-- If the user has correct access to the Person, it returns the person_id itself, otherwise null
-- If PERSON component is not installed, or the person is not protected it returns the person_id itself.
FUNCTION Is_User_Available_Person_Id___ (
   person_id_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN
   $IF Component_Person_SYS.INSTALLED $THEN
      IF (Is_Protected(person_id_) = 'TRUE') THEN
         RETURN User_Access_API.Is_User_Available_Person_Id(person_id_);
      ELSE
         RETURN person_id_;
      END IF;   
   $ELSE
      RETURN person_id_;
   $END
END Is_User_Available_Person_Id___;


PROCEDURE Log_Column_Changes___ (
   oldrec_ IN person_info_tab%ROWTYPE,
   newrec_ IN person_info_tab%ROWTYPE )
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
   rec_  IN person_info_tab%ROWTYPE )
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
   rec_  IN person_info_tab%ROWTYPE )
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
   rec_  IN person_info_tab%ROWTYPE )
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
   rec_  IN     person_info_tab%ROWTYPE )
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


FUNCTION Get_Constructed_Full_Name___ (
   first_name_  IN VARCHAR2,
   middle_name_ IN VARCHAR2,
   last_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS  
   full_name_ person_info_tab.name%TYPE; 
BEGIN   
   IF (middle_name_ IS NULL) THEN
      full_name_ := TRIM(first_name_ ||' '||last_name_);
   ELSE
      full_name_ := TRIM(first_name_ ||' '||middle_name_||' '||last_name_);
   END IF;     
   RETURN full_name_;   
END Get_Constructed_Full_Name___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_        IN person_info_tab%ROWTYPE )
IS
   dummy_      VARCHAR2(1);
   ins_rec_    person_info_tab%ROWTYPE;
   CURSOR Exist IS
      SELECT 'X'
      FROM   person_info_tab
      WHERE  person_id = newrec_.person_id;
BEGIN
   ins_rec_        := newrec_;
   ins_rec_.rowkey := NVL(ins_rec_.rowkey, sys_guid());
   ins_rec_.rowstate := 'Active';
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
      INTO person_info_tab
      VALUES ins_rec_;
   ELSE
      UPDATE person_info_tab
         SET name        = ins_rec_.name,
             first_name  = ins_rec_.first_name,
             middle_name = ins_rec_.middle_name,
             last_name   = ins_rec_.last_name
         WHERE person_id = ins_rec_.person_id;
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;


-- Note: This method added for perfomence reasons only. Try to avoid calling this method in normal senarios.   
FUNCTION Get_Language__  RETURN VARCHAR2 
IS
BEGIN
   Update_Cache_Language___;
   RETURN micro_cache_language_;   
END Get_Language__;


-- This method is to be used by Aurena
PROCEDURE Write_Person_Image__ (
   objversion_      IN VARCHAR2,
   objid_           IN VARCHAR2,
   person_image##   IN BLOB )
IS  
   rec_            person_info_tab%ROWTYPE;
   picture_id_     person_info_tab.picture_id%TYPE;
   pic_objversion_ binary_object_data_block.objversion%TYPE;
   pic_objid_      binary_object_data_block.objid%TYPE;
   person_id_      person_info_tab.person_id%TYPE;
BEGIN
   rec_        := Lock_By_Id___(objid_, objversion_);  
   person_id_  := rec_.person_id;
   picture_id_ := Get_Picture_Id(person_id_);
   IF (person_image## IS NOT NULL) THEN
      Binary_Object_API.Create_Or_Replace(picture_id_, person_id_ , '' , '' , 'FALSE' , 0 , 'PICTURE' , '' );
      Binary_Object_Data_Block_API.New__(pic_objversion_, pic_objid_, picture_id_, NULL);
      Binary_Object_Data_Block_API.Write_Data__(pic_objversion_, pic_objid_, person_image##); 
   ELSE
      Binary_Object_API.Do_Delete(picture_id_);
      picture_id_ := NULL;
   END IF;
   rec_.picture_id := picture_id_;
   Modify___(rec_);
END Write_Person_Image__;


-- Note: This method will be execute as a background job, as well as a online job.
PROCEDURE Configure_Middle_Name__
IS
   newrec_   person_info_tab%ROWTYPE;
   CURSOR get_person IS
      SELECT person_id, name, first_name, middle_name, last_name
      FROM   person_info_tab;
BEGIN
   FOR rec_ IN get_person LOOP
      IF (rec_.first_name IS NOT NULL OR rec_.middle_name IS NOT NULL OR rec_.last_name IS NOT NULL) THEN
         newrec_ := Get_Object_By_Keys___(rec_.person_id);
         IF (Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME') = 'TRUE') THEN
            newrec_.name := Get_Constructed_Full_Name___(rec_.first_name, rec_.middle_name, rec_.last_name);
         ELSE
            -- Check if only middle name is present
            IF (rec_.first_name IS NULL AND rec_.last_name IS NULL AND rec_.middle_name IS NOT NULL) THEN
              newrec_.name := rec_.middle_name;
            ELSE
               newrec_.name := Get_Constructed_Full_Name___(rec_.first_name, NULL, rec_.last_name);
            END IF;
         END IF;
         Modify___(newrec_);
      END IF;
   END LOOP;
END Configure_Middle_Name__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT person_id||'-'||name description
      FROM   person_info_tab
      WHERE  person_id = person_id_;
BEGIN
   OPEN get_obj_description;
   FETCH get_obj_description INTO obj_description_;
   IF (get_obj_description%NOTFOUND) THEN
      CLOSE get_obj_description;
      RETURN Language_SYS.Translate_Constant(lu_name_, 'NODOCDESC: No description available');
   END IF;
   CLOSE get_obj_description;
   RETURN obj_description_;
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Check_Exist (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(person_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   person_id_              IN VARCHAR2,
   name_                   IN VARCHAR2,
   country_db_             IN VARCHAR2 DEFAULT NULL,
   default_language_db_    IN VARCHAR2 DEFAULT NULL,
   user_id_                IN VARCHAR2 DEFAULT NULL,
   picture_id_             IN NUMBER   DEFAULT NULL,
   customer_contact_db_    IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   title_                  IN VARCHAR2 DEFAULT NULL,
   supplier_contact_db_    IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   protected_              IN VARCHAR2 DEFAULT NULL,
   alias_                  IN VARCHAR2 DEFAULT NULL,
   job_title_              IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       person_info_tab%ROWTYPE;
   first_name_   person_info_tab.first_name%TYPE;
   middle_name_  person_info_tab.middle_name%TYPE;   
   last_name_    person_info_tab.last_name%TYPE;  
BEGIN
   newrec_.person_id := person_id_;
   IF (name_ IS NOT NULL) THEN
      Analyze_Name(first_name_, middle_name_, last_name_, name_);   
      newrec_.name         := name_;
      newrec_.first_name   := first_name_;
      newrec_.middle_name  := middle_name_;
      newrec_.last_name    := last_name_;
   END IF;
   newrec_.creation_date            := TRUNC(SYSDATE);
   newrec_.protected                := NVL(protected_, 'FALSE');
   newrec_.party_type               := 'PERSON';
   newrec_.default_domain           := 'TRUE';
   newrec_.country                  := country_db_;
   newrec_.default_language         := default_language_db_;
   newrec_.user_id                  := user_id_;
   newrec_.picture_id               := picture_id_;
   newrec_.customer_contact         := customer_contact_db_;
   newrec_.blocked_for_use          := Fnd_Boolean_API.DB_FALSE;
   newrec_.title                    := title_;
   newrec_.alias                    := alias_;
   newrec_.job_title                := job_title_;
   newrec_.supplier_contact         := supplier_contact_db_;
   newrec_.blocked_for_use_supplier := Fnd_Boolean_API.DB_FALSE;
   New___(newrec_);
END New;


PROCEDURE Modify (
   person_id_           IN VARCHAR2,
   name_                IN VARCHAR2 DEFAULT NULL,
   country_db_          IN VARCHAR2 DEFAULT NULL,
   default_language_db_ IN VARCHAR2 DEFAULT NULL,
   picture_id_          IN NUMBER   DEFAULT NULL,
   replace_             IN VARCHAR2 DEFAULT NULL,
   protected_           IN VARCHAR2 DEFAULT NULL,
   alias_               IN VARCHAR2 DEFAULT NULL )
IS  
BEGIN
   Modify(person_id_, name_, country_db_, default_language_db_, picture_id_, replace_, protected_, alias_, NULL,'FALSE', NULL);
END Modify;


PROCEDURE Modify (
   person_id_           IN VARCHAR2,
   name_                IN VARCHAR2 DEFAULT NULL,
   country_db_          IN VARCHAR2 DEFAULT NULL,
   default_language_db_ IN VARCHAR2 DEFAULT NULL,
   picture_id_          IN NUMBER   DEFAULT NULL,
   replace_             IN VARCHAR2 DEFAULT NULL,
   protected_           IN VARCHAR2 DEFAULT NULL,
   alias_               IN VARCHAR2 DEFAULT NULL,
   job_title_           IN VARCHAR2 DEFAULT NULL,
   change_title_        IN VARCHAR2 DEFAULT NULL,
   title_               IN VARCHAR )
IS
   oldrec_       person_info_tab%ROWTYPE;
   newrec_       person_info_tab%ROWTYPE;
   attr_         VARCHAR2(2000);
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   indrec_       Indicator_Rec;
   first_name_   person_info_tab.first_name%TYPE;
   middle_name_  person_info_tab.middle_name%TYPE;   
   last_name_    person_info_tab.last_name%TYPE;   
BEGIN
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := Lock_By_Keys___(person_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_);
   IF ((name_ IS NOT NULL) AND (oldrec_.name != name_)) THEN
      Analyze_Name(first_name_, middle_name_, last_name_, name_);   
      Client_SYS.Add_To_Attr('NAME',                 name_,                attr_);
      Client_SYS.Add_To_Attr('FIRST_NAME',           first_name_,          attr_);
      Client_SYS.Add_To_Attr('MIDDLE_NAME',          middle_name_,         attr_);
      Client_SYS.Add_To_Attr('LAST_NAME',            last_name_,           attr_);      
   END IF;
   IF (country_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_DB',           country_db_,          attr_);
   END IF;
   IF (default_language_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE_DB',  default_language_db_, attr_);
   END IF;
   IF (picture_id_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PICTURE_ID',           picture_id_,          attr_);  
   END IF;
   IF (protected_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PROTECTED',            protected_,           attr_);
   END IF;    
   IF (change_title_ = 'TRUE') THEN            
      Client_SYS.Add_To_Attr('TITLE',                title_,               attr_);           
   END IF; 
   IF (alias_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ALIAS',                alias_,               attr_);
   END IF;
   IF (job_title_ IS NOT NULL) THEN            
      Client_SYS.Add_To_Attr('JOB_TITLE',            job_title_,           attr_);           
   END IF; 
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   IF (replace_ = 'TRUE') THEN      
      oldrec_.name := newrec_.name;
   END IF;   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify;


PROCEDURE Remove (
   person_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      person_info_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Is_Protected (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ person_info_tab.protected%TYPE;
   CURSOR get_attr IS
      SELECT protected
      FROM   person_info_tab
      WHERE  person_id = person_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN NVL(temp_,'FALSE');
END Is_Protected;


PROCEDURE Set_Protected (
   person_id_ IN VARCHAR2,
   protected_ IN VARCHAR2 )
IS
   dummy_     person_info_tab%ROWTYPE;
BEGIN
   Check_Protected___('*', protected_);
   dummy_ := Lock_By_Keys___(person_id_);
   UPDATE person_info_tab
      SET protected = protected_,
          rowversion = SYSDATE
      WHERE person_id = person_id_;
END Set_Protected;


@UncheckedAccess
FUNCTION Is_Blocked (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN    
   IF ((Check_Validity___(person_id_) = 'BLOCKED')) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Blocked;


@UncheckedAccess
FUNCTION Is_User_Auth (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT protected
      FROM   person_info_tab
      WHERE  person_id = person_id_;
BEGIN
   FOR p IN get_attr LOOP
      IF (p.protected = 'FALSE') THEN
         RETURN 'TRUE';
      ELSIF (Party_Admin_User_API.Check_Exist('DEFAULT', Application_User_API.Get_Current_User) = 'FALSE') THEN
         RETURN 'FALSE';
      ELSE
         RETURN 'TRUE';
      END IF;
   END LOOP;
   RETURN 'FALSE';
END Is_User_Auth;


@UncheckedAccess
FUNCTION Get_Id_For_User (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   id_ person_info_tab.person_id%TYPE;
   CURSOR get_id IS
      SELECT person_id
      FROM   person_info_tab
      WHERE  user_id = user_id_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO id_;
   CLOSE get_id;
   RETURN id_;
END Get_Id_For_User;


@UncheckedAccess
FUNCTION Get_Not_Blocked_Id_For_User (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   id_ person_info_tab.person_id%TYPE;
   CURSOR get_id IS
      SELECT person_id
      FROM   person_info_tab
      WHERE  user_id = user_id_
      AND    rowstate != 'Blocked';
BEGIN
   OPEN get_id;
   FETCH get_id INTO id_;
   CLOSE get_id;
   RETURN id_;
END Get_Not_Blocked_Id_For_User;


@UncheckedAccess
FUNCTION Get_Id_For_Current_User
   RETURN VARCHAR2
IS
BEGIN
   Update_Cache_Cfu___(Fnd_Session_API.Get_Fnd_User);
   RETURN micro_cache_value_cfu_;
END Get_Id_For_Current_User;


@UncheckedAccess
FUNCTION Get_Name_For_User (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_      person_info_tab.name%TYPE;
   person_id_ person_info_tab.person_id%TYPE;
   CURSOR get_name IS
      SELECT name, person_id
      FROM   person_info_tab
      WHERE  user_id = user_id_;
BEGIN
   OPEN get_name;
   FETCH get_name INTO name_, person_id_;
   CLOSE get_name;
   RETURN name_;
END Get_Name_For_User;


PROCEDURE Add_Modify_H_R_Person (
   person_id_   IN VARCHAR2,
   first_name_  IN VARCHAR2,
   last_name_   IN VARCHAR2,
   middle_name_ IN VARCHAR2,
   prefix_      IN VARCHAR2,
   birth_name_  IN VARCHAR2,
   initials_    IN VARCHAR2,
   title_       IN VARCHAR2)
IS
BEGIN
   $IF Component_Person_SYS.INSTALLED $THEN
      Pers_API.Add_Modify_Person_Details(person_id_, first_name_, last_name_, middle_name_, prefix_, birth_name_, initials_, title_);
   $ELSE
      NULL;
   $END 
END Add_Modify_H_R_Person;


-- Analyze_Name
--   This method takes the person name value as input parameter and return
--   First, Middle, Last names extracting from it.
--   First name will be the first most element in the name and the last name will be the last most one.
--   The whole texts in between will be suggested as the middle name.
PROCEDURE Analyze_Name (
   first_name_       OUT VARCHAR2,
   middle_name_      OUT VARCHAR2,
   last_name_        OUT VARCHAR2,   
   full_name_        IN  VARCHAR2)
IS
   name_elements_      Utility_SYS.STRING_TABLE;
   name_element_count_ NUMBER;
   counter_            NUMBER;
BEGIN
   Utility_SYS.Tokenize(full_name_, ' ', name_elements_, name_element_count_);
   first_name_ := name_elements_(1);
   -- Setting the Middle Name
   IF (name_element_count_ > 2) THEN
      middle_name_ := NULL;
      counter_ := 2;
      WHILE(counter_ < (name_element_count_)) LOOP
         middle_name_ := CONCAT(middle_name_, CONCAT(name_elements_(counter_), ' '));   
         counter_ := counter_ + 1;
      END LOOP;   
      middle_name_:= SUBSTR(middle_name_, 0, (LENGTH(middle_name_) - 1));
   END IF;   
   IF (NOT(name_element_count_ = 1)) THEN
      last_name_ :=  name_elements_(name_element_count_); 
   END IF;                  
END Analyze_Name;   


FUNCTION Get_Next_Identity  RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       person_info_tab.party_type%TYPE := 'PERSON';
   update_next_value_   BOOLEAN := FALSE;    
BEGIN
   Party_Identity_Series_API.Get_Next_Value(next_id_, party_type_db_);  
   WHILE Check_Exist___(next_id_) LOOP
      next_id_ := next_id_ + 1;
      update_next_value_ := TRUE; 
   END LOOP;
   IF (update_next_value_) THEN
      Party_Identity_Series_API.Update_Next_Value(next_id_, party_type_db_);         
   END IF;  
   RETURN next_id_; 
END Get_Next_Identity;


FUNCTION Is_Valid_User (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   user_id_   VARCHAR2(30);
BEGIN
   user_id_ := Get_User_Id(person_id_);
   IF (user_id_ IS NULL) THEN
      RETURN 'TRUE';
   ELSE
      Fnd_User_API.Check_Active(user_id_);
   END IF;
   RETURN 'TRUE';
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'FALSE';
END Is_Valid_User;


PROCEDURE Add_Modify_Person_Details (
   person_id_   IN VARCHAR2,
   first_name_  IN VARCHAR2,
   last_name_   IN VARCHAR2,
   middle_name_ IN VARCHAR2,
   prefix_      IN VARCHAR2,
   birth_name_  IN VARCHAR2,
   initials_    IN VARCHAR2,
   title_       IN VARCHAR2,
   picture_id_  IN NUMBER,
   protected_   IN VARCHAR2,
   alias_       IN VARCHAR2 )
IS 
   newrec_        person_info_tab%ROWTYPE;   
   oldrec_        person_info_tab%ROWTYPE;   
   attr_          VARCHAR2(2000);
   indrec_        Indicator_Rec;
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FROM_HR', 'TRUE', attr_);
   IF (Check_Exist___(person_id_)) THEN
      oldrec_ := Lock_By_Keys_Nowait___(person_id_);
      newrec_ := oldrec_;
      IF (Object_Property_API.Exists(lu_name_, '*', 'EXPOSE_MIDDLE_NAME')) THEN
         IF (Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME') = 'FALSE') THEN
            newrec_.name := Get_Constructed_Full_Name___(first_name_, NULL, last_name_); 
         ELSE
            newrec_.name := Get_Constructed_Full_Name___(first_name_, middle_name_, last_name_); 
         END IF;
      ELSE
         newrec_.name := Get_Constructed_Full_Name___(first_name_, middle_name_, last_name_); 
      END IF;
      newrec_.first_name  := first_name_;
      newrec_.last_name   := last_name_;
      newrec_.middle_name := middle_name_;
      newrec_.prefix      := prefix_;
      newrec_.birth_name  := birth_name_;
      newrec_.initials    := initials_;
      newrec_.title       := title_;
      newrec_.picture_id  := picture_id_;
      newrec_.alias       := alias_;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      IF (protected_ IS NOT NULL) THEN
         Set_Protected(person_id_, protected_);
      END IF; 
   ELSE
      newrec_.person_id   := person_id_;
      IF (Object_Property_API.Exists(lu_name_, '*', 'EXPOSE_MIDDLE_NAME')) THEN
         IF (Object_Property_API.Get_Value(lu_name_, '*', 'EXPOSE_MIDDLE_NAME') = 'FALSE') THEN
            newrec_.name := Get_Constructed_Full_Name___(first_name_, NULL, last_name_); 
         ELSE
            newrec_.name := Get_Constructed_Full_Name___(first_name_, middle_name_, last_name_); 
         END IF;
      ELSE
         newrec_.name := Get_Constructed_Full_Name___(first_name_, middle_name_, last_name_); 
      END IF;
      newrec_.first_name       := first_name_;
      newrec_.last_name        := last_name_;
      newrec_.middle_name      := middle_name_;
      newrec_.prefix           := prefix_;
      newrec_.birth_name       := birth_name_;
      newrec_.initials         := initials_;
      newrec_.title            := title_;
      newrec_.picture_id       := picture_id_;
      newrec_.creation_date    := TRUNC(SYSDATE);
      newrec_.protected        := protected_;
      newrec_.party_type       := 'PERSON';
      newrec_.default_domain   := 'TRUE';
      newrec_.alias            := alias_;
      newrec_.customer_contact := Fnd_Boolean_API.DB_FALSE;
      newrec_.blocked_for_use  := Fnd_Boolean_API.DB_FALSE;
      New___(newrec_);
   END IF;
END Add_Modify_Person_Details;


@UncheckedAccess
FUNCTION Check_Access (
   person_id_    IN VARCHAR2,
   user_id_      IN VARCHAR2 DEFAULT NULL,
   protected_    IN VARCHAR2 DEFAULT NULL,
   session_user_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS 
BEGIN
   IF (Check_Access___(person_id_,  user_id_, protected_, session_user_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Access;


@UncheckedAccess
FUNCTION Get_Objid (   
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objid_  VARCHAR2(200);
   CURSOR get_objid IS
      SELECT ROWID      
      FROM   person_info_tab
      WHERE  person_id = person_id_;
BEGIN
   IF (person_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   OPEN get_objid;
   FETCH get_objid INTO objid_;
   CLOSE get_objid;
   RETURN objid_; 
END Get_Objid;
   

FUNCTION Get_Person_Id_For_Objid (
   objid_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   person_id_  person_info_tab.person_id%TYPE;
   CURSOR get_person_id IS
      SELECT person_id
      FROM   person_info_tab
      WHERE  ROWID = objid_;
BEGIN
   OPEN get_person_id;
   FETCH get_person_id INTO person_id_;
   CLOSE get_person_id;
   RETURN person_id_;
END Get_Person_Id_For_Objid;
 

-- This will be used to fetch the rowversion
-- in CCTI integration.
@UncheckedAccess
FUNCTION Get_Last_Modified (
   person_id_ IN   VARCHAR2 ) RETURN DATE
IS
   last_modified_    DATE;
   CURSOR get_last_modified IS
      SELECT rowversion
      FROM   person_info_tab
      WHERE  person_id = person_id_;
BEGIN
   OPEN get_last_modified;
   FETCH get_last_modified INTO last_modified_;
   CLOSE get_last_modified;   
   RETURN last_modified_; 
END Get_Last_Modified;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN person_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;


--This method to be used in Aurena
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Full_Name (
   person_id_   IN VARCHAR2,
   name_        IN VARCHAR2,
   first_name_  IN VARCHAR2,
   middle_name_ IN VARCHAR2,
   last_name_   IN VARCHAR2,
   title_       IN VARCHAR2,
   job_title_   IN VARCHAR2,
   initials_    IN VARCHAR2 )
IS
   attr_        VARCHAR2(32000);
   oldrec_      person_info_tab%ROWTYPE;
   newrec_      person_info_tab%ROWTYPE;
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   indrec_      Indicator_Rec;
   rec_         Public_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_    := Get(person_id_);
   oldrec_ := Lock_By_Keys___(person_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, person_id_);
   IF ((rec_.name != name_) OR (rec_.name IS NULL) OR (name_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('NAME', name_, attr_);
   END IF;
   IF ((rec_.first_name != first_name_) OR (rec_.first_name IS NULL) OR (first_name_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('FIRST_NAME', first_name_, attr_);
   END IF;
   IF ((rec_.middle_name != middle_name_) OR (rec_.middle_name IS NULL) OR (middle_name_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('MIDDLE_NAME', middle_name_, attr_);
   END IF;
   IF ((rec_.last_name != last_name_) OR (rec_.last_name IS NULL) OR (last_name_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('LAST_NAME', last_name_, attr_);
   END IF;
   IF ((rec_.title != title_) OR (rec_.title IS NULL) OR (title_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('TITLE', title_, attr_);
   END IF;
   IF ((rec_.job_title != job_title_) OR (rec_.job_title IS NULL) OR (job_title_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('JOB_TITLE', job_title_, attr_);
   END IF;
   IF ((rec_.initials != initials_) OR (rec_.initials IS NULL) OR (initials_ IS NULL)) THEN
      Client_SYS.Add_To_Attr('INITIALS', initials_, attr_);
   END IF;
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_); 
END Modify_Full_Name;


--This method is to be used in Aurena
FUNCTION Check_Access_To_Protected (
   person_id_    IN VARCHAR2,
   user_id_      IN VARCHAR2 DEFAULT NULL,
   protected_    IN VARCHAR2 DEFAULT NULL,
   session_user_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS 
BEGIN
   IF (Person_Company_Access_API.Check_Person_Access(Fnd_Session_API.Get_Fnd_User, person_id_) = 'TRUE') THEN
      IF ((Party_Admin_User_API.Exist_Current_User) AND 
         (NVL(protected_, Is_Protected(person_id_)) = 'TRUE') AND
         (NVL(session_user_, Fnd_Session_API.Get_Fnd_User) = NVL(user_id_, Get_User_Id(person_id_)))) THEN
         RETURN 'TRUE';
      END IF;
   END IF;            
   RETURN 'FALSE';
END Check_Access_To_Protected;


@UncheckedAccess
FUNCTION Is_Middle_Name_Exposed RETURN VARCHAR2
IS
BEGIN
   Update_Cache_Expose_Mname___();
   RETURN micro_cache_expose_mname_;
END Is_Middle_Name_Exposed;


-- This will be used to validate parameter in System Defenitions
@UncheckedAccess
PROCEDURE Validate_Parameter (
   object_lu_        IN VARCHAR2,
   object_key_       IN VARCHAR2,
   property_name_    IN VARCHAR2,
   property_value_   IN VARCHAR2 )
IS 
BEGIN
   IF (object_lu_ = 'PersonInfo') THEN
      IF (object_key_ = '*') THEN
         IF (property_name_ = 'EXPOSE_MIDDLE_NAME') THEN
            IF (NVL(property_value_, ' ') NOT IN ('TRUE', 'FALSE')) THEN
               Error_SYS.Record_General(lu_name_, 'NOTVALIDEVENT: Valid values for property (:P1) are (:P2).', object_lu_ ||','||object_key_||','||property_name_, 'TRUE/FALSE');
            END IF;
            Invalidate_Cache_Mname___();
         END IF;
      END IF;
   END IF;
END Validate_Parameter;


PROCEDURE Update_Person_Names (
   execute_bg_ IN VARCHAR2 )
IS
   desc_ VARCHAR2(2000);
BEGIN
   IF (execute_bg_ = 'TRUE') THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'UPDPERNAME: Update Person Names');
      Transaction_SYS.Deferred_Call('Person_Info_API.Configure_Middle_Name__', NULL, desc_);
   ELSE
      Configure_Middle_Name__();
   END IF;
END Update_Person_Names;

