-----------------------------------------------------------------------------
--
--  Logical unit: DataSubjectConsent
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
--  191209  thnilk  HCSPRING20-77, Replaced the Applicant_General_Info_API with Applicant_Info_API.
--  200826  machlk  HCSPRING20-1613, Implement GDPR after removing BENADM.
--  210408  machlk  HCM21R2-81, Implement GDPR for new Applicant implementation.
--  210720  machlk  HCM21R2-81, Remove External Candidate.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cascade_Delete_Person__ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('PERSON', substr(identity_,1,instr(identity_,'^',1,1)-1), NULL);
END Cascade_Delete_Person__;

PROCEDURE Cascade_Delete_Customer__ (
   identity_ IN VARCHAR2 )
IS 
BEGIN
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('CUSTOMER', substr(identity_,1,instr(identity_,'^',1,1)-1), NULL);
END Cascade_Delete_Customer__;

PROCEDURE Cascade_Delete_Supplier__ (
   identity_ IN VARCHAR2 )
IS 
BEGIN
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('SUPPLIER', substr(identity_,1,instr(identity_,'^',1,1)-1), NULL);
END Cascade_Delete_Supplier__;

PROCEDURE Cascade_Delete_Employee__ (
   identity_ IN VARCHAR2 )
IS
   key1_ VARCHAR2(100);
   key2_ VARCHAR2(100);
BEGIN
   key1_ := substr(identity_,1,instr(identity_,'^',1,1)-1);
   key2_ := substr(identity_,instr(identity_,'^',1,1)+1,instr(identity_,'^',1,2)-instr(identity_,'^',1,1)-1);
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('EMPLOYEE', key1_, key2_);
END Cascade_Delete_Employee__;

PROCEDURE Cascade_Delete_Applicant__ (
   identity_ IN VARCHAR2 )
IS 
BEGIN
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('APPLICANT', substr(identity_,1,instr(identity_,'^',1,1)-1), NULL);
END Cascade_Delete_Applicant__;


PROCEDURE Cascade_Delete_Business_Lead__ (
   identity_ IN VARCHAR2 )
IS 
BEGIN
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('BUSINESS_LEAD', substr(identity_,1,instr(identity_,'^',1,1)-1), NULL);
END Cascade_Delete_Business_Lead__;

PROCEDURE Cascade_Delete_Business_Cont__ (
   identity_ IN VARCHAR2 )
IS
   key1_ VARCHAR2(100);
   key2_ VARCHAR2(100);
BEGIN
   key1_ := substr(identity_,1,instr(identity_,'^',1,1)-1);
   key2_ := substr(identity_,instr(identity_,'^',1,1)+1,instr(identity_,'^',1,2)-instr(identity_,'^',1,1)-1);
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('BUSINESS_CONTACT', key1_, key2_);
END Cascade_Delete_Business_Cont__;

PROCEDURE Cascade_Delete_Dependent__ (
   identity_ IN VARCHAR2 )
IS
   key1_ VARCHAR2(100);
   key2_ VARCHAR2(100);
BEGIN
   key1_ := substr(identity_,1,instr(identity_,'^',1,1)-1);
   key2_ := substr(identity_,instr(identity_,'^',1,1)+1,instr(identity_,'^',1,2)-instr(identity_,'^',1,1)-1);
   Personal_Data_Man_Util_API.Remove_Data_Consents_By_Keys('PERSON_DEPENDENT', key1_, key2_);
END Cascade_Delete_Dependent__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   key_ref_      IN VARCHAR2,
   data_subject_ IN VARCHAR2 )
IS
   newrec_       DATA_SUBJECT_CONSENT_TAB%ROWTYPE;
BEGIN
   newrec_.key_ref := key_ref_;
   newrec_.data_subject := data_subject_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Subject_Key_Ref (
   data_subject_ IN VARCHAR2,
   key1_         IN VARCHAR2,
   key2_         IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ VARCHAR2(100);
BEGIN
   IF data_subject_ = 'PERSON' THEN
      temp_ := 'PERSON_ID='||key1_||'^';
   ELSIF data_subject_ = 'EMPLOYEE' THEN
      temp_ := 'COMPANY_ID='||key1_||'^EMPLOYEE_ID='||key2_||'^';
   ELSIF data_subject_ = 'APPLICANT' THEN
      temp_ := 'APPLICANT_ID='||key1_||'^';
   ELSIF data_subject_ = 'BUSINESS_LEAD' THEN
      temp_ := 'LEAD_ID='||key1_||'^';
   ELSIF data_subject_ IN ('BUSINESS_CONTACT','BUSINESS_CONTACTS') THEN
      temp_ := 'LEAD_ID='||key1_||'^CONTACT_ID='||key2_||'^';
   ELSIF data_subject_ = 'SUPPLIER' THEN
      temp_ := 'SUPPLIER_ID='||key1_||'^';
   ELSIF data_subject_ = 'CUSTOMER' THEN
      temp_ := 'CUSTOMER_ID='||key1_||'^';   
   ELSIF data_subject_ = 'USER' THEN
      temp_ := 'IDENTITY='||key1_||'^';
   ELSIF data_subject_ IN ('DEPENDENTS','PERSON_DEPENDENT') THEN
      temp_ := 'PERSON_ID='||key1_||'^RELATION_ID='||key2_||'^';
   END IF;
   RETURN temp_;
END Get_Subject_Key_Ref;

@UncheckedAccess
FUNCTION Data_Subject_Consent_Exists (
   data_subject_ IN VARCHAR2,
   key1_         IN VARCHAR2,
   key2_         IN VARCHAR2) RETURN VARCHAR2
IS
   key_ref_ data_subject_consent_tab.key_ref%TYPE;
   dummy_ NUMBER;
BEGIN
   key_ref_ := Data_Subject_Consent_API.Get_Subject_Key_Ref(data_subject_,key1_,key2_);
   SELECT 1
      INTO  dummy_
      FROM  data_subject_consent_tab
      WHERE key_ref = key_ref_;
   RETURN 'TRUE';
   EXCEPTION
      WHEN no_data_found THEN
         RETURN 'FALSE';
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(key_ref_, 'Data_Subject_Consent_Exists');
END Data_Subject_Consent_Exists;

@UncheckedAccess
FUNCTION Get_Identity (
   key_ref_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Identity(key_ref_, Get_Data_Subject_Db(key_ref_));   
END Get_Identity;

@UncheckedAccess
FUNCTION Get_Identity (
   key_ref_      IN VARCHAR2,
   data_subject_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF data_subject_ = 'PERSON' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'PERSON_ID');
   ELSIF data_subject_ = 'EMPLOYEE' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'COMPANY_ID')||'-'||Client_SYS.Get_Key_Reference_Value(key_ref_,'EMPLOYEE_ID');
   ELSIF data_subject_ = 'APPLICANT' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'APPLICANT_ID');
   ELSIF data_subject_ = 'BUSINESS_LEAD' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'LEAD_ID');
   ELSIF data_subject_ = 'BUSINESS_CONTACT' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'LEAD_ID')||'-'||Client_SYS.Get_Key_Reference_Value(key_ref_,'CONTACT_ID');
   ELSIF data_subject_ = 'CUSTOMER' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'CUSTOMER_ID');
   ELSIF data_subject_ = 'SUPPLIER' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'SUPPLIER_ID');
   ELSIF data_subject_ = 'PERSON_DEPENDENT' THEN
      RETURN Client_SYS.Get_Key_Reference_Value(key_ref_,'PERSON_ID')||'-'||Client_SYS.Get_Key_Reference_Value(key_ref_,'RELATION_ID');
   ELSE
      RETURN NULL;
   END IF;
END Get_Identity;

@UncheckedAccess
FUNCTION Get_Connected_Key_Ref (
   key_ref_      IN VARCHAR2,
   data_subject_ IN VARCHAR2) RETURN VARCHAR2
IS
  data_subject_elements_ Personal_Data_Man_Util_API.data_subject_array_;  
  i_ NUMBER := 0;
  key_ref_list_ VARCHAR2(4000);
BEGIN
  data_subject_elements_ := Personal_Data_Man_Util_API.Get_Connected_Key_Ref(key_ref_, data_subject_, 'DISPLAY', NULL);
  i_ := data_subject_elements_.FIRST;
   WHILE i_ IS NOT NULL LOOP
     IF key_ref_list_ IS NULL THEN
        key_ref_list_ := ''''||data_subject_elements_(i_).key_ref||'''';
     ELSE        
        key_ref_list_ := key_ref_list_ || ','''||data_subject_elements_(i_).key_ref||'''';
     END IF;
     i_ := data_subject_elements_.NEXT(i_);
  END LOOP;
  RETURN key_ref_list_;
END Get_Connected_Key_Ref;

PROCEDURE Get_Data_Subject_Analysis_Data (
   data_subject_name_             OUT VARCHAR2,
   personal_data_consent_history_ OUT VARCHAR2,
   valid_personal_data_consent_   OUT VARCHAR2,
   data_subject_db_               IN VARCHAR2,
   data_subject_key1_             IN VARCHAR2,
   data_subject_key2_             IN VARCHAR2)
IS
BEGIN
   personal_data_consent_history_ := Data_Subject_Consent_Api.Data_Subject_Consent_Exists(data_subject_db_, data_subject_key1_, data_subject_key2_);
   valid_personal_data_consent_ := Personal_Data_Man_Util_Api.Is_Valid_Consent_By_Keys(data_subject_db_, data_subject_key1_, data_subject_key2_, trunc(SYSDATE));
   IF data_subject_db_ = 'PERSON' THEN
      data_subject_name_ := Person_Info_API.Get_Name(data_subject_key1_);
   ELSIF data_subject_db_ = 'EMPLOYEE' THEN
      data_subject_name_ := Person_Info_API.Get_Name(Company_Emp_API.Get_Person_Id(data_subject_key1_, data_subject_key2_));
   ELSIF data_subject_db_ = 'CUSTOMER' THEN
      data_subject_name_ := Customer_Info_API.Get_Name(data_subject_key1_);
   ELSIF data_subject_db_ = 'SUPPLIER' THEN
      data_subject_name_ := Supplier_Info_API.Get_Name(data_subject_key1_);   
   ELSIF data_subject_db_ = 'BUSINESS_LEAD' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         data_subject_name_ := Business_Lead_API.Get_Name(data_subject_key1_);
      $ELSE
         data_subject_name_ := NULL;
      $END
   ELSIF data_subject_db_ = 'BUSINESS_CONTACT' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         data_subject_name_ := Business_Lead_Contact_API.Get_Name(data_subject_key1_, data_subject_key2_);
      $ELSE
         data_subject_name_ := NULL;
      $END
   ELSIF data_subject_db_ = 'APPLICANT' THEN
      $IF Component_Rcruit_SYS.INSTALLED $THEN
         data_subject_name_ := Applicant_Info_API.Get_Name(data_subject_key1_);
      $ELSE
         data_subject_name_ := NULL;
      $END   
   ELSIF data_subject_db_ = 'PERSON_DEPENDENT' THEN
      $IF Component_Person_SYS.INSTALLED $THEN
         data_subject_name_ := Related_Person_API.Get_Name(data_subject_key1_, data_subject_key2_);
      $ELSE
         data_subject_name_ := NULL;
      $END  
   END IF;
END Get_Data_Subject_Analysis_Data;