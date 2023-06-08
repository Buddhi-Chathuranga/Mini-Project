-----------------------------------------------------------------------------
--
--  Logical unit: PersonalDataManUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
--  180620  Piwrpl  LCS 141382, Corrections of the PeDM Configuration
--  180621  Krwipl  Bug 141992, Planned Cleanup of Unauthorized Data
--  191209  thnilk  HCSPRING20-77, Replaced the applicant_general_info_tab with applicant_info_tab.
--  200826  machlk  HCSPRING20-1613, Implement GDPR after removing BENADM.
--  210408  machlk  HCM21R2-81, Implement GDPR for new Applicant implementation.
--  210720  machlk  HCM21R2-81, Remove External Candidate.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE data_subject_rec_ IS RECORD (  data_subject VARCHAR2(20),
                                    key_ref VARCHAR2(100));

TYPE data_subject_array_ IS TABLE OF data_subject_rec_ INDEX BY BINARY_INTEGER;

@UncheckedAccess
FUNCTION Get_Connected_Key_Ref (
   key_ref_               IN VARCHAR2,
   data_subject_          IN VARCHAR2,
   related_subjects_mode_ IN VARCHAR2,
   data_category_         IN VARCHAR2 ) RETURN data_subject_array_
IS
   person_id_  VARCHAR2(40);
   user_id_    person_info_tab.user_id%TYPE;
   i_ NUMBER := 1;
   
   data_subject_elements_ data_subject_array_;
   
   CURSOR get_employees IS
      SELECT company, employee_id
      FROM   company_emp_tab
      WHERE  person_id = person_id_;

   $IF Component_Crm_SYS.INSTALLED $THEN
   lead_id_ VARCHAR2(20);
   contact_id_ VARCHAR2(20);   
   CURSOR get_person_lead_contacts IS
      SELECT lead_id, contact_id
      FROM   business_lead_contact_tab
      WHERE  person_id = person_id_;
    CURSOR get_lead_contacts IS
      SELECT lead_id, contact_id
      FROM   business_lead_contact_tab blc
      WHERE  lead_id = lead_id_
      AND    NOT EXISTS (SELECT 1
                         FROM  data_subject_consent_tab d
                         WHERE d.data_subject = 'BUSINESS_CONTACT'
                         AND   d.key_ref = Data_Subject_Consent_Api.Get_Subject_Key_Ref('BUSINESS_CONTACT', blc.lead_id, blc.contact_id)); 
   $END   
   $IF Component_Person_SYS.INSTALLED $THEN 
   CURSOR get_person_dependents IS
      SELECT ed.person_id, ed.relation_id
      FROM   related_person_tab ed
      WHERE  ed.person_id = person_id_
      AND    NOT EXISTS (SELECT 1
                         FROM  data_subject_consent_tab d
                         WHERE d.data_subject = 'PERSON_DEPENDENT'
                         AND   d.key_ref = Data_Subject_Consent_Api.Get_Subject_Key_Ref('PERSON_DEPENDENT', ed.person_id, to_char(ed.relation_id)));       
   $END
BEGIN

   IF NOT(related_subjects_mode_ IN ('DISPLAY', 'ISVALIDCONSENT', 'CLEANUP')) THEN
      Error_SYS.Appl_General(lu_name_, 'CONNREF: Wrong parameter of Get_Connected_Key_Ref function.');
   END IF;
   
   data_subject_elements_(i_).data_subject := data_subject_;
   data_subject_elements_(i_).key_ref := key_ref_;
   
   IF ((related_subjects_mode_ = 'DISPLAY') OR (data_subject_ = 'CUSTOMER' OR data_subject_= 'SUPPLIER'
      OR data_subject_ = 'APPLICANT' OR data_subject_ = 'PERSON_DEPENDENT')) THEN
      RETURN data_subject_elements_;
   END IF;
   
   IF data_subject_ = 'PERSON' THEN      
      person_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'PERSON_ID');
      
      IF (related_subjects_mode_ = 'ISVALIDCONSENT') THEN
         FOR rec IN get_employees LOOP         
            i_ := i_ + 1;         
            data_subject_elements_(i_).data_subject := 'EMPLOYEE';
            data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('EMPLOYEE', rec.company, rec.employee_id);                  
         END LOOP;
         $IF Component_Crm_SYS.INSTALLED $THEN
            IF data_category_ IS NOT NULL AND (data_category_ = 'PHONE' OR data_category_ = 'EMAIL' 
                     OR data_category_ = 'MOBILE' OR data_category_ = 'FAX'                                      
                     OR data_category_ = 'WWW' OR data_category_ = 'NAME') THEN
         
               FOR rec IN get_person_lead_contacts LOOP             
                  i_ := i_ + 1;         
                  data_subject_elements_(i_).data_subject := 'BUSINESS_CONTACT';
                  data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('BUSINESS_CONTACT', rec.lead_id, rec.contact_id);
               END LOOP;
            
            END IF;
         $END
      END IF;
      
      IF (related_subjects_mode_ = 'CLEANUP') THEN
         user_id_ := Person_Info_API.Get_User_Id(person_id_);
         IF (user_id_ IS NOT NULL) THEN
            i_ := i_ + 1;
            data_subject_elements_(i_).data_subject := 'USER';
            data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('USER', user_id_, NULL);
         END IF;
         $IF Component_Person_SYS.INSTALLED $THEN
            IF (data_category_ = 'DEPENDENT') THEN
               FOR rec IN get_person_dependents LOOP
                  i_ := i_ + 1;
                  data_subject_elements_(i_).data_subject := 'DEPENDENTS';
                  data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('DEPENDENTS', rec.person_id, to_char(rec.relation_id));  
               END LOOP;
            END IF;
         $END
      END IF;
   ELSIF (data_subject_ = 'USER') AND (related_subjects_mode_ = 'ISVALIDCONSENT') THEN
      person_id_ := Person_Info_API.Get_Id_For_User(Client_SYS.Get_Key_Reference_Value(key_ref_,'IDENTITY'));      
      IF person_id_ IS NOT NULL  THEN 
         i_ := i_ + 1;
         data_subject_elements_(i_).data_subject := 'PERSON';
         data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('PERSON', person_id_, NULL);
      END IF;
      
      FOR rec IN get_employees LOOP         
         i_ := i_ + 1;         
         data_subject_elements_(i_).data_subject := 'EMPLOYEE';
         data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('EMPLOYEE', rec.company, rec.employee_id);                  
      END LOOP;
      
   ELSIF data_subject_ = 'EMPLOYEE' THEN
      i_ := i_ + 1;
      person_id_ := Company_Emp_API.Get_Person_Id(Client_SYS.Get_Key_Reference_Value(key_ref_,'COMPANY_ID'),Client_SYS.Get_Key_Reference_Value(key_ref_,'EMPLOYEE_ID'));
      data_subject_elements_(i_).data_subject := 'PERSON';
      data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('PERSON', person_id_, NULL);
      
      IF (related_subjects_mode_ = 'CLEANUP') THEN
         user_id_ := Person_Info_API.Get_User_Id(person_id_);
         IF (user_id_ IS NOT NULL) THEN
            i_ := i_ + 1;
            data_subject_elements_(i_).data_subject := 'USER';
            data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('USER', user_id_, NULL);
         END IF;
         $IF Component_Person_SYS.INSTALLED $THEN
            IF (data_category_ = 'DEPENDENT') THEN
               FOR rec IN get_person_dependents LOOP
                  i_ := i_ + 1;
                  data_subject_elements_(i_).data_subject := 'DEPENDENTS';
                  data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('DEPENDENTS', rec.person_id, to_char(rec.relation_id));  
               END LOOP;
            END IF;
         $END
      END IF;
   
   ELSIF data_subject_ = 'BUSINESS_LEAD' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         lead_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'LEAD_ID');
         IF (related_subjects_mode_ = 'CLEANUP' AND data_category_ = 'CONTACT') THEN
            FOR rec IN get_lead_contacts LOOP
               i_ := i_ + 1;
               data_subject_elements_(i_).data_subject := 'BUSINESS_CONTACTS';
               data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('BUSINESS_CONTACTS', rec.lead_id, rec.contact_id);
            END LOOP;
         END IF;
      $ELSE
         NULL;
      $END
   ELSIF data_subject_ = 'BUSINESS_CONTACT' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         lead_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'LEAD_ID');
         contact_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'CONTACT_ID');     

         IF (NOT(data_category_ = 'ADDRESS') OR data_category_ IS NULL) THEN            
            IF (Business_Lead_Contact_API.Get_New_Person_Db(lead_id_,contact_id_) = 'FALSE') THEN
               person_id_ := Business_Lead_Contact_API.Get_Person_Id(lead_id_,contact_id_);
               IF person_id_ IS NOT NULL  THEN               
                  IF ((related_subjects_mode_ = 'ISVALIDCONSENT') AND data_category_ IS NULL) THEN
                     i_ := i_ + 1;
                  ELSIF data_category_ IS NOT NULL AND NOT(data_category_ = 'PHONE' OR data_category_ = 'EMAIL' 
                     OR data_category_ = 'MOBILE' OR data_category_ = 'FAX'
                     OR data_category_ = 'WWW' OR data_category_ = 'NAME') THEN 
                     i_ := i_ + 1;
                  END IF;               
                  data_subject_elements_(i_).data_subject := 'PERSON';
                  data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('PERSON', person_id_, NULL);                     
               END IF;   
            END IF;
         END IF;
      $ELSE
         NULL;
      $END   
   ELSIF data_subject_ = 'DEPENDENTS' AND related_subjects_mode_ = 'ISVALIDCONSENT' THEN
      $IF Component_Person_SYS.INSTALLED $THEN
         person_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'PERSON_ID');
         data_subject_elements_(i_).data_subject := 'PERSON';
         data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('PERSON', person_id_, NULL);
         FOR rec IN get_employees LOOP
            i_ := i_ + 1; 
            data_subject_elements_(i_).data_subject := 'EMPLOYEE';
            data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('EMPLOYEE', rec.company, rec.employee_id);                  
         END LOOP;
      $ELSE
         NULL;
      $END  
   ELSIF data_subject_ = 'BUSINESS_CONTACTS' AND related_subjects_mode_ = 'ISVALIDCONSENT' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         lead_id_ := Client_SYS.Get_Key_Reference_Value(key_ref_,'LEAD_ID');
         data_subject_elements_(i_).data_subject := 'BUSINESS_LEAD';
         data_subject_elements_(i_).key_ref := Data_Subject_Consent_Api.Get_Subject_Key_Ref('BUSINESS_LEAD', lead_id_, NULL);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN data_subject_elements_;
END Get_Connected_Key_Ref;

@UncheckedAccess
FUNCTION Get_Related_Data_Subjects (
   data_subject_ IN VARCHAR2,
   mode_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (mode_ = 'OBVERSE') THEN
      IF (data_subject_ = 'PERSON') THEN      
         RETURN 'PERSON;USER;DEPENDENTS';
      ELSIF data_subject_ = 'EMPLOYEE' THEN
         RETURN 'EMPLOYEE;PERSON;DEPENDENTS;USER';
      ELSIF data_subject_ = 'BUSINESS_LEAD' THEN
         RETURN 'BUSINESS_LEAD;BUSINESS_CONTACTS';
      END IF; 
   ELSIF (mode_ = 'REVERSE') THEN
      IF data_subject_ = 'PERSON' THEN      
         RETURN 'PERSON;EMPLOYEE';
      ELSIF data_subject_ = 'BUSINESS_CONTACTS' THEN
         RETURN 'BUSINESS_LEAD';
      ELSIF data_subject_ = 'DEPENDENTS' THEN
         RETURN 'PERSON;EMPLOYEE';
      ELSIF data_subject_ = 'USER' THEN
         RETURN 'PERSON;EMPLOYEE';   
      END IF; 
   END IF;
   RETURN data_subject_;
END Get_Related_Data_Subjects;

FUNCTION Is_Valid_Consent (
   key_ref_                   IN VARCHAR2,
   data_subject_              IN VARCHAR2,
   pers_data_management_id_   IN NUMBER,
   consent_date_              IN DATE,
   display_mode_              IN VARCHAR2 ) RETURN VARCHAR2
IS
   valid_consent_ VARCHAR2(5) := 'FALSE';
   data_subject_related_ Personal_Data_Man_Util_API.data_subject_array_;  
   i_ NUMBER := 0;
   temp_key_ref_ VARCHAR2(100);
   temp_data_subject_ VARCHAR2(20);
   temp_ NUMBER;
   data_category_ personal_data_management_tab.data_category%TYPE;
  
   CURSOR get_purposes(data_subject_ VARCHAR2) IS
      SELECT purpose_id
      FROM   pers_data_man_proc_purpose_tab
      WHERE  (pers_data_management_id = pers_data_management_id_ OR pers_data_management_id_ IS NULL)
      AND    data_subject = data_subject_;
      
   CURSOR get_valid_consent(purpose_id_ NUMBER, key_ref_ VARCHAR2) IS
      SELECT 1
      FROM   data_subject_consent_oper_tab a, data_subject_consent_purp_tab b
      WHERE  a.key_ref = key_ref_
      AND    a.key_ref = b.key_ref
      AND    a.operation_date = b.operation_date
      AND    a.action = b.action
      AND    (b.process_purpose_id = purpose_id_)
      AND    consent_date_ BETWEEN NVL(b.effective_on, Database_Sys.Get_First_Calendar_Date()) AND NVL(b.effective_until, Database_Sys.Get_Last_Calendar_Date())
      AND    a.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED
      AND    b.valid = 'TRUE'
      AND    a.operation_date = (SELECT MAX(x.operation_date)
                                   FROM data_subject_consent_oper_tab x
                                   WHERE x.key_ref = a.key_ref                                   
                                   AND   x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED);  
   
BEGIN
   data_category_ := Personal_Data_Management_Api.Get_Data_Category(pers_data_management_id_);   
   data_subject_related_ := Personal_Data_Man_Util_API.Get_Connected_Key_Ref(key_ref_, data_subject_, display_mode_, data_category_);  
   i_ := data_subject_related_.FIRST;   
   
   WHILE i_ IS NOT NULL LOOP
      temp_key_ref_ := data_subject_related_(i_).key_ref;
      temp_data_subject_ := data_subject_related_(i_).data_subject;
      
      IF ((temp_key_ref_ IS NOT NULL) AND (temp_data_subject_ IS NOT NULL)) THEN         
         FOR purp_rec_ IN get_purposes(temp_data_subject_) LOOP
            
            OPEN get_valid_consent(purp_rec_.purpose_id, temp_key_ref_);
            FETCH get_valid_consent INTO temp_;
            IF get_valid_consent%FOUND THEN
               valid_consent_ := 'TRUE';
            END IF;
            CLOSE get_valid_consent;
            
         END LOOP;
      END IF;      
      i_ := data_subject_related_.NEXT(i_);
   END LOOP;
   
   RETURN valid_consent_;
END Is_Valid_Consent;

@UncheckedAccess
FUNCTION Is_Valid_Consent_By_Keys (
   data_subject_ IN VARCHAR2,
   key1_         IN VARCHAR2,
   key2_         IN VARCHAR2,
   consent_date_ IN DATE ) RETURN VARCHAR2
IS
BEGIN
   RETURN Is_Valid_Consent(Data_Subject_Consent_API.Get_Subject_Key_Ref(data_subject_,key1_,key2_),data_subject_, NULL, trunc(consent_date_), 'DISPLAY');
END Is_Valid_Consent_By_Keys;

PROCEDURE Execute_Data_Subject_Cleanup(
   key_ref_        IN VARCHAR2, 
   data_subject_   IN VARCHAR2,
   operation_date_ IN DATE )
IS   
   CURSOR get_personal_data IS
      SELECT   DISTINCT m.pers_data_management_id, m.data_category 
      FROM     personal_data_management_tab m, 
               pers_data_man_proc_purpose_tab p, 
               data_subject_consent_tab ds,
               data_subject_consent_oper_tab dso,
               data_subject_consent_purp_tab dsp
      WHERE    m.pers_data_management_id = p.pers_data_management_id      
      AND      m.data_cleanup = 'TRUE'
      AND      p.data_subject = data_subject_
      AND      p.data_subject = ds.data_subject
      AND      ds.key_ref = key_ref_
      AND      ds.key_ref = dso.key_ref
      AND      ds.key_ref = dsp.key_ref
      AND      dso.operation_date = dsp.operation_date      
      AND      dso.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED
      AND      dsp.process_purpose_id = p.purpose_id
      AND      ((dsp.valid = 'FALSE' AND dso.update_date < operation_date_)
               OR (dsp.valid = 'TRUE' AND (operation_date_ NOT BETWEEN NVL(dsp.effective_on, Database_Sys.Get_First_Calendar_Date()) AND NVL(dsp.effective_until, Database_Sys.Get_Last_Calendar_Date()))))
      AND      dso.operation_date = (SELECT MAX(operation_date) 
                                    FROM    data_subject_consent_oper_tab x
                                    WHERE   x.key_ref = key_ref_
                                    AND     x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED)
      AND      NOT EXISTS (SELECT 1
                           FROM  data_subject_consent_oper_tab t, data_subject_consent_purp_tab w
                           WHERE t.key_ref = key_ref_
                           AND   t.key_ref = w.key_ref
                           AND   t.operation_date = w.operation_date
                           AND   t.action = w.action
                           AND   t.operation_date >= dso.operation_date
                           AND   w.valid = 'TRUE'
                           AND   w.process_purpose_id = dsp.process_purpose_id
                           AND   t.action = Data_Sub_Consent_Action_API.DB_DATA_ERASED)
      UNION
      SELECT DISTINCT m.pers_data_management_id, m.data_category 
      FROM  pers_data_man_proc_purp_all p,
            personal_data_management_tab m
      WHERE m.pers_data_management_id = p.pers_data_management_id      
      AND   m.data_cleanup = 'TRUE'
      AND   p.data_subject = data_subject_
      AND   p.purpose_id = 0;
      
   data_subject_related_ Personal_Data_Man_Util_API.data_subject_array_;  
   i_ NUMBER := 0;
   temp_key_ref_ VARCHAR2(100);
   temp_data_subject_ VARCHAR2(20);
   valid_consent_ VARCHAR2(5) := 'FALSE';
   is_pers_man_success_ BOOLEAN := FALSE;
   cleanup_executed_ BOOLEAN := FALSE;
BEGIN
   
   App_Context_SYS.Set_Value('PERSONAL_DATA_MAN_UTIL_API.EXECUTE_DATA_SUBJECT_CLEANUP','TRUE'); 
   
   FOR rec_ IN get_personal_data LOOP
      data_subject_related_ := Personal_Data_Man_Util_API.Get_Connected_Key_Ref(key_ref_, data_subject_, 'CLEANUP', rec_.data_category);  
      i_ := data_subject_related_.FIRST;      
       
      is_pers_man_success_ := TRUE;
      cleanup_executed_ := FALSE;

      WHILE i_ IS NOT NULL LOOP
         temp_key_ref_ := data_subject_related_(i_).key_ref;       
         temp_data_subject_ := data_subject_related_(i_).data_subject;
         
         valid_consent_ := Is_Valid_Consent(temp_key_ref_, temp_data_subject_, rec_.pers_data_management_id, TRUNC(operation_date_), 'ISVALIDCONSENT');
         IF (valid_consent_ = 'FALSE') THEN
            cleanup_executed_ := TRUE;   
            App_Context_SYS.Set_Value('PERSONAL_DATA_MAN_UTIL_API.PERS_DATA_MANAGEMENT_ID',rec_.pers_data_management_id); 
            Exe_Pers_Man_Cleanup(is_pers_man_success_, key_ref_, temp_key_ref_, temp_data_subject_, rec_.pers_data_management_id, operation_date_);                 
            App_Context_SYS.Set_Value('PERSONAL_DATA_MAN_UTIL_API.PERS_DATA_MANAGEMENT_ID',to_number(NULL)); 
         END IF;
         i_ := data_subject_related_.NEXT(i_);
      END LOOP;
      
      IF is_pers_man_success_ AND cleanup_executed_ THEN
         Personal_Data_Cleanup_Log_Api.New_Log_Entry(key_ref_, operation_date_, Data_Sub_Consent_Action_API.DB_DATA_ERASED, rec_.pers_data_management_id, 'TRUE', NULL);
      END IF; 
   END LOOP;
   
   App_Context_SYS.Set_Value('PERSONAL_DATA_MAN_UTIL_API.EXECUTE_DATA_SUBJECT_CLEANUP','FALSE'); 
   EXCEPTION
      WHEN OTHERS THEN
         App_Context_SYS.Set_Value('PERSONAL_DATA_MAN_UTIL_API.EXECUTE_DATA_SUBJECT_CLEANUP','FALSE'); 
END Execute_Data_Subject_Cleanup;

PROCEDURE Exe_Pers_Man_Cleanup (
   is_pers_man_success_     IN OUT BOOLEAN,
   root_key_reference_      IN VARCHAR2,
   key_reference_           IN VARCHAR2,
   data_subject_            IN VARCHAR2,
   pers_data_management_id_ IN NUMBER,
   operation_date_          IN DATE )
IS
   CURSOR get_pers_data_man IS
      SELECT a.pers_data_management_id, a.seq_no, p.data_cleanup_method
      FROM   personal_data_man_det_tab a, personal_data_management_tab p
      WHERE  p.pers_data_management_id = pers_data_management_id_
      AND    p.pers_data_management_id = a.pers_data_management_id
      AND    data_cleanup = 'TRUE'
      AND    a.data_subject = data_subject_
      AND    exclude_from_cleanup = 'FALSE'
      AND    NOT(p.data_cleanup_method = 'ANONYMIZE' AND a.skip_anonymize = 'TRUE')
      ORDER BY cleanup_order;
  
   det_rec_ Personal_Data_Man_Det_API.Public_Rec;
BEGIN
   FOR rec_ IN get_pers_data_man LOOP      
      det_rec_ := Personal_Data_Man_Det_API.Get(rec_.pers_data_management_id, rec_.seq_no);
      IF (det_rec_.masked_value IS NOT NULL) THEN
         det_rec_.masked_value := Personal_Data_Man_Det_API.Get_Translated_Masked_Value(rec_.pers_data_management_id, rec_.seq_no);
      END IF;
      
      Execute_Single_Item_Cleanup___ (is_pers_man_success_, det_rec_, root_key_reference_, key_reference_, pers_data_management_id_, 
                                     rec_.data_cleanup_method, operation_date_);  
   END LOOP;
END Exe_Pers_Man_Cleanup;

PROCEDURE Execute_History_Log_Cleanup (
   lu_name_      IN VARCHAR2,
   key_val_      IN VARCHAR2,
   storage_type_ IN VARCHAR2,
   field_        IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   
   CURSOR get_history(key_val_ VARCHAR2) IS
   SELECT ha.log_id, ha.column_name, to_char(ha.rowversion,'YYYYMMDDHH24MISS') objversion, ha.rowid objid
   FROM   history_log_tab hl, history_log_attribute_tab ha
   WHERE  hl.log_id = ha.log_id
   AND    hl.keys = key_val_
   AND    hl.lu_name = lu_name_
   AND    ((ha.column_name = field_ AND storage_type_ = 'FIELD') OR (storage_type_ = 'LOGICAL_UNIT'));
BEGIN
   FOR rec_ IN get_history(key_val_) LOOP
      History_Log_Attribute_Api.Remove__(info_, rec_.objid, rec_.objversion, 'DO');
   END LOOP;
END Execute_History_Log_Cleanup;


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Anonymized_Value (
   pers_data_management_id_ IN NUMBER,   
   field_value_             IN VARCHAR2,
   masked_value_            IN VARCHAR2,
   field_type_              IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2(4000);
   anonymize_rec_ Anonymization_Setup_Api.Public_Rec;
   replace_value_ VARCHAR2(200);
BEGIN
   anonymize_rec_ := Personal_Data_Management_Api.Get_Anonymization(pers_data_management_id_);
   
   IF masked_value_ IS NOT NULL THEN
      RETURN masked_value_;
   END IF; 
   
   IF (field_type_ = Cleanup_Data_Type_Api.DB_STRING) THEN
      
      replace_value_ := anonymize_rec_.text_value;      

      IF (replace_value_ IS NOT NULL) THEN
         IF (anonymize_rec_.text_anonymization_mode = Anonymization_Mode_Type_API.DB_FIXED_VALUE) THEN
            result_ := replace_value_;
         ELSIF (anonymize_rec_.text_anonymization_mode = Anonymization_Mode_Type_API.DB_REPLACE_ALL_CHARACTERS) THEN
            result_ := substr(regexp_replace(field_value_, '.', replace_value_), 1, LENGTH(field_value_));
         ELSIF (anonymize_rec_.text_anonymization_mode = Anonymization_Mode_Type_API.DB_LEAVE_FIRST_CHARACTER) THEN
            result_ := substr(field_value_,1,1) || substr(regexp_replace(substr(field_value_,2,LENGTH(field_value_)-1),'.',replace_value_), 1, LENGTH(field_value_)-1);
         END IF;
      ELSE
         result_ := '';
      END IF;
   ELSIF (field_type_ = Cleanup_Data_Type_Api.DB_DATE ) THEN
      result_ := TO_CHAR(anonymize_rec_.date_value, Client_Sys.date_format_);
   ELSIF (field_type_ = Cleanup_Data_Type_Api.DB_NUMBER ) THEN
      result_ := anonymize_rec_.number_value;
   END IF; 
   
   RETURN result_;
END Anonymized_Value;
               
PROCEDURE Execute_Single_Item_Cleanup___ (
   is_pers_man_success_     IN OUT BOOLEAN,
   det_rec_                 IN     Personal_Data_Man_Det_API.Public_Rec,
   root_key_reference_      IN     VARCHAR2,
   key_reference_           IN     VARCHAR2,
   pers_data_management_id_ IN     NUMBER,         
   cleanup_type_            IN     VARCHAR2,
   operation_date_          IN     DATE )
IS
   cleanup_executed_    BOOLEAN := FALSE;
   info_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   attr_                VARCHAR2(32000) := NULL;
   stmt_                VARCHAR2(32000) := NULL;
   where_clause_        VARCHAR2(32000) := NULL;
   table_where_clause_  VARCHAR2(32000) := NULL;
   error_desc_          VARCHAR2(2000) := NULL;
   access_error_        VARCHAR2(5) := 'FALSE';
   
   package_             VARCHAR2(35);
   view_name_           VARCHAR2(35);
   table_name_          VARCHAR2(35);
   
   identity1_           VARCHAR2(200);
   identity2_           VARCHAR2(200);
BEGIN
   Assert_SYS.Assert_Is_Logical_Unit(det_rec_.application_area_id);

   package_    := Dictionary_SYS.Get_Base_Package(det_rec_.application_area_id);
   IF det_rec_.application_area_id = 'PersonInfo' THEN
      view_name_ := 'PERSON_INFO_ALL';
      table_name_ := 'PERSON_INFO_TAB';
   ELSE
      view_name_  := Dictionary_Sys.Get_Base_View(det_rec_.application_area_id);
      table_name_  := Dictionary_Sys.Get_Base_Table_Name(det_rec_.application_area_id);
   END IF;
   
   Assert_SYS.Assert_Is_View(view_name_);
   Assert_SYS.Assert_Is_Package(package_);
   Assert_SYS.Assert_Is_Table(table_name_);
   Assert_Match_By(view_name_, det_rec_.match_by);   
   
   where_clause_ := Get_Cleanup_Where_Clause(det_rec_.data_subject, det_rec_.match_by, det_rec_.storage_type, det_rec_.condition, TRUE);
   table_where_clause_ := Get_Cleanup_Where_Clause(det_rec_.data_subject, det_rec_.match_by, det_rec_.storage_type, det_rec_.table_condition, TRUE);
   stmt_ := '
                 DECLARE
   
                    info_ VARCHAR2(2000);
                    objid_ VARCHAR2(2000);
                    objversion_ VARCHAR2(2000);
                    key_val_ VARCHAR2(32000);
                    attr_                VARCHAR2(32000) := NULL;
                    any_loop_entry_ VARCHAR2(5) := ''FALSE'';
                    tmp_ NUMBER;
                    
                    CURSOR get_data_to_modify IS
                       SELECT objid, objversion ' ;
                       IF (det_rec_.field_name IS NOT NULL) AND (det_rec_.storage_type = 'FIELD') THEN
                          stmt_ := stmt_ || ', ' || det_rec_.field_name || ' ';                           
                       END IF;
                    stmt_ := stmt_ || '   FROM ' || view_name_  || where_clause_ || '
                    
                    CURSOR get_record_count IS
                       SELECT count(*) FROM ' || table_name_  || table_where_clause_ || '                     
                    field_value_      VARCHAR2(200) := :field_value_;
                    pers_data_management_id_ NUMBER :=  :pers_data_management_id_;
                    field_type_        VARCHAR2(20) := :field_type_;                    
                    masked_value_     VARCHAR2(200) := :masked_value_;
                    field_            VARCHAR2(200) := :field_;
                    application_area_id_  VARCHAR2(200) := :application_area_id_;
                    storage_type_     VARCHAR2(200) := :storage_type_;
   
                 BEGIN
                 
                  FOR rec_ IN get_data_to_modify LOOP                    
                     any_loop_entry_ := ''TRUE'';
                 ';
   
   stmt_ := stmt_ || ' key_val_ := History_Setting_Util_API.Get_History_Log_Key_Ref(application_area_id_, rec_.objid);';
                 
   IF ((det_rec_.storage_type = 'LOGICAL_UNIT') AND NOT(cleanup_type_ = 'ANONYMIZE' AND det_rec_.skip_anonymize = 'TRUE') )THEN
      
      stmt_ := stmt_ || ' ' || package_||'.Remove__(info_, rec_.objid, rec_.objversion, ''DO'');';
      cleanup_executed_ := TRUE;
      
   ELSIF det_rec_.storage_type = 'PROPERTY_CODE' THEN
      
      stmt_ := stmt_ || ' ' || package_||'.Remove__(info_, rec_.objid, rec_.objversion, ''DO'');';
      cleanup_executed_ := TRUE;
      
   ELSIF ((cleanup_type_ = 'ANONYMIZE' OR cleanup_type_ = 'REMOVE') AND (det_rec_.reference = 'TRUE') 
      AND (det_rec_.storage_type = 'FIELD') AND (det_rec_.skip_anonymize = 'FALSE')) THEN
   
      Assert_SYS.Assert_Is_View_Column(view_name_, det_rec_.field_name);
      
      stmt_ := stmt_ || '  Client_SYS.Clear_Attr(attr_);                           
                           Client_SYS.Add_To_Attr(field_, masked_value_, attr_); ';
      stmt_ := stmt_ || ' ' || package_||'.Modify__(info_, rec_.objid, rec_.objversion, attr_, ''DO'');';
      cleanup_executed_ := TRUE;
      
   ELSIF ((cleanup_type_ = 'REMOVE') AND NOT(det_rec_.mandatory = 'TRUE') AND (det_rec_.storage_type = 'FIELD')) THEN
      
      Assert_SYS.Assert_Is_View_Column(view_name_, det_rec_.field_name);
      
      stmt_ := stmt_ || '  Client_SYS.Clear_Attr(attr_);
                           Client_SYS.Add_To_Attr(field_, '''', attr_); ';
      stmt_ := stmt_ || ' ' || package_||'.Modify__(info_, rec_.objid, rec_.objversion, attr_, ''DO'');';
      cleanup_executed_ := TRUE;
      
   ELSIF (cleanup_type_ = 'REMOVE' AND det_rec_.mandatory = 'TRUE' AND det_rec_.storage_type = 'FIELD' AND NOT(NVL(det_rec_.skip_anonymize, 'FALSE') = 'TRUE')) THEN   
   
      Assert_SYS.Assert_Is_View_Column(view_name_, det_rec_.field_name);
      
      stmt_ := stmt_ || '  Client_SYS.Clear_Attr(attr_);
                           masked_value_ := Personal_Data_Man_Util_API.Anonymized_Value(pers_data_management_id_, rec_.'|| det_rec_.field_name ||', masked_value_, field_type_);
                           Client_SYS.Add_To_Attr(field_, masked_value_, attr_); ';
      stmt_ := stmt_ || ' ' || package_||'.Modify__(info_, rec_.objid, rec_.objversion, attr_, ''DO'');';
      cleanup_executed_ := TRUE;  

      
   ELSIF ((cleanup_type_ = 'ANONYMIZE') AND (det_rec_.storage_type = 'FIELD') AND NOT(NVL(det_rec_.skip_anonymize, 'FALSE') = 'TRUE')) THEN
      
      Assert_SYS.Assert_Is_View_Column(view_name_, det_rec_.field_name);
      
      stmt_ := stmt_ || '  Client_SYS.Clear_Attr(attr_);
                           masked_value_ := Personal_Data_Man_Util_API.Anonymized_Value(pers_data_management_id_, rec_.'|| det_rec_.field_name ||', masked_value_, field_type_);
                           Client_SYS.Add_To_Attr(field_, masked_value_, attr_); ';
      stmt_ := stmt_ || ' ' || package_||'.Modify__(info_, rec_.objid, rec_.objversion, attr_, ''DO'');';
      cleanup_executed_ := TRUE;
      
   END IF;
      
   stmt_ := stmt_ || ' Personal_Data_Man_Util_API.Execute_History_Log_Cleanup(application_area_id_, key_val_, storage_type_, field_);';
   stmt_ := stmt_ || ' ' || ' END LOOP; ';
   stmt_ := stmt_ ||' IF any_loop_entry_ = ''FALSE'' THEN
                      OPEN get_record_count;
                      FETCH get_record_count INTO tmp_;
                      CLOSE get_record_count;
                      IF tmp_ > 0 THEN     
                         :access_error_ := ''TRUE'';
                      END IF;
                      END IF;
                      END; ';
   
   BEGIN
      
      IF (cleanup_executed_ = TRUE) AND (det_rec_.exclude_from_cleanup = 'FALSE')THEN
         
         identity1_ := Get_Identity_From_Key_Ref(det_rec_.data_subject, key_reference_, 1);
         identity2_ := Get_Identity_From_Key_Ref(det_rec_.data_subject, key_reference_, 2);

         IF (det_rec_.data_subject = 'BUSINESS_CONTACT' OR det_rec_.data_subject = 'BUSINESS_CONTACTS' OR det_rec_.data_subject = 'EMPLOYEE' OR det_rec_.data_subject = 'DEPENDENTS' 
            OR det_rec_.data_subject = 'PERSON_DEPENDENT') AND identity2_ IS NOT NULL AND identity1_ IS NOT NULL THEN
            @ApproveDynamicStatement(2017-11-10,krwipl) 
            EXECUTE IMMEDIATE stmt_ USING IN identity1_, IN identity2_, IN det_rec_.field_value, IN det_rec_.pers_data_management_id, IN det_rec_.field_type,  
            IN det_rec_.masked_value, IN det_rec_.field_name, IN det_rec_.application_area_id, IN det_rec_.storage_type, OUT access_error_;
         ELSIF identity1_ IS NOT NULL THEN
            @ApproveDynamicStatement(2017-11-10,krwipl) 
            EXECUTE IMMEDIATE stmt_ USING IN identity1_, IN det_rec_.field_value, IN det_rec_.pers_data_management_id, IN det_rec_.field_type,  
            IN det_rec_.masked_value, IN det_rec_.field_name, IN det_rec_.application_area_id, IN det_rec_.storage_type, OUT access_error_;
         END IF;
         IF access_error_ = 'TRUE' THEN
            Error_SYS.Record_General(lu_name_, 'ACCESSERR: Insufficient access rights. Cannot modify data in the :P1.', det_rec_.application_area_id);
         END IF;
      ELSE
         is_pers_man_success_ := FALSE;
         error_desc_ := Language_SYS.Translate_Constant(lu_name_, 'CLEANERR: Data related to :P1 is not removed.', NULL, Personal_Data_Management_API.Get_Personal_Data(pers_data_management_id_));
         Personal_Data_Cleanup_Log_Api.New_Log_Entry(root_key_reference_, operation_date_, Data_Sub_Consent_Action_API.DB_DATA_ERASED, pers_data_management_id_, 'FALSE', error_desc_); 
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         is_pers_man_success_ := FALSE;
         error_desc_ := SQLERRM;         
         Personal_Data_Cleanup_Log_Api.New_Log_Entry(root_key_reference_, operation_date_, Data_Sub_Consent_Action_API.DB_DATA_ERASED, pers_data_management_id_, 'FALSE', error_desc_); 
   END;
END Execute_Single_Item_Cleanup___;


   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Column_Nullable (
   logical_unit_ IN VARCHAR2,
   field_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   table_name_ VARCHAR2(50);
   nullable_   VARCHAR2(1);
   result_     VARCHAR2(5);
BEGIN
   table_name_ := Dictionary_Sys.Get_Base_Table_Name(logical_unit_);
   nullable_ :=  Database_Sys.Get_Column_Nullable(table_name_, field_name_);
   
   result_ := CASE nullable_
               WHEN 'Y' THEN 'FALSE'
               WHEN 'N' THEN 'TRUE'
               ELSE 'FALSE'
              END;
   
   RETURN result_;    
END Get_Column_Nullable;

FUNCTION Get_Column_Type (
   logical_unit_ IN VARCHAR2,
   field_name_   IN VARCHAR2 ) RETURN NUMBER
IS
   table_name_ VARCHAR2(50);
   col_type_   VARCHAR2(20);
   result_     NUMBER;
BEGIN
   table_name_ := Dictionary_Sys.Get_Base_Table_Name(logical_unit_);
   col_type_ :=  Database_Sys.Get_Column_Type(table_name_, field_name_);
   
   result_ := CASE col_type_
         WHEN 'VARCHAR2' THEN Cleanup_Data_Type_Api.DB_STRING     
         WHEN 'NUMBER' THEN Cleanup_Data_Type_Api.DB_NUMBER
         WHEN 'DATE' THEN Cleanup_Data_Type_Api.DB_DATE   
         ELSE NULL
      END;
   
   RETURN result_;    
END Get_Column_Type;
   
FUNCTION Get_Reference (
   logical_unit_ IN VARCHAR2,
   field_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   view_       VARCHAR2(30);
   result_     VARCHAR2(5);
   
   CURSOR get_reference(view_ IN VARCHAR2) IS
      SELECT column_reference, enumeration
      FROM   dictionary_sys_view_column
      WHERE  view_name = UPPER(view_)
      AND    column_name = UPPER(field_name_);
   
   ref_rec_ get_reference%ROWTYPE;
BEGIN
   view_ := Dictionary_Sys.Get_Base_View(logical_unit_);
   
   OPEN get_reference(view_);
   FETCH get_reference INTO ref_rec_;
   CLOSE get_reference;
   
   IF ((ref_rec_.column_reference IS NOT NULL) OR (ref_rec_.enumeration IS NOT NULL)) THEN
      result_ := 'TRUE';
   ELSE
      result_ := 'FALSE';
   END IF;
   
   RETURN result_;
END Get_Reference;

FUNCTION Get_Field_Length (
   logical_unit_ IN VARCHAR2,
   field_name_   IN VARCHAR2 ) RETURN NUMBER
IS
   table_name_ VARCHAR2(50);   
   
   CURSOR get_length(table_name_ IN VARCHAR2) IS
      SELECT char_length, data_type
      FROM   user_tab_columns
      WHERE  table_name  = upper(table_name_)
      AND    column_name = upper(field_name_);
   
   length_rec_ get_length%ROWTYPE;
BEGIN
   table_name_ := Dictionary_Sys.Get_Base_Table_Name(logical_unit_);
   
   OPEN get_length(table_name_);
   FETCH get_length INTO length_rec_;
   CLOSE get_length;
   
   IF (length_rec_.data_type = 'VARCHAR2') THEN
      RETURN length_rec_.char_length;
   ELSE
      RETURN NULL;
   END IF;
END Get_Field_Length; 

FUNCTION Get_Cleanup_Where_Clause (
   data_subject_          IN VARCHAR2,
   match_by_              IN VARCHAR2,
   storage_type_          IN VARCHAR2,
   additional_condition_  IN VARCHAR2,
   semicolon_             IN BOOLEAN ) RETURN VARCHAR2
IS   
   where_clause_        VARCHAR2(32000) := NULL;   
BEGIN
   IF (match_by_ IS NOT NULL) THEN
      where_clause_ := ' WHERE ';
      
      IF ((data_subject_ = 'PERSON') OR (data_subject_ = 'APPLICANT') OR (data_subject_ = 'CUSTOMER')
       OR (data_subject_ = 'SUPPLIER') OR (data_subject_ = 'USER') OR (data_subject_ = 'BUSINESS_LEAD'))  THEN
         where_clause_ := where_clause_ || match_by_ || ' = :identity_';
      ELSE
         where_clause_ := where_clause_ || Decode_Attribute(match_by_, 1, ',') || ' = :identity1_ AND ' || Decode_Attribute(match_by_, 2, ',') || ' = :identity2_';
      END IF;

      IF (storage_type_ = 'PROPERTY_CODE') THEN
         where_clause_ := where_clause_ || ' AND property_code = :field_value_';
      END IF;
      
      IF (additional_condition_ IS NOT NULL) THEN      
         where_clause_ := where_clause_ || ' AND ' || additional_condition_;
      END IF;
   ELSIF (additional_condition_ IS NOT NULL) THEN      
      where_clause_ := ' WHERE ' || additional_condition_;
   END IF;
   
   IF semicolon_ THEN
      where_clause_ := where_clause_ ||  ';';
   END IF;
   
   RETURN where_clause_;
END Get_Cleanup_Where_Clause;

FUNCTION Decode_Attribute (
   parameter_  IN VARCHAR2,
   order_      IN NUMBER,
   seper_char_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   be_ NUMBER;
   en_ NUMBER;
   n_ NUMBER;
   param_ VARCHAR2(2000);
BEGIN
   IF order_ < 1 THEN
      RETURN NULL;
   END IF;
   n_ := order_;
   be_ := 1;
   LOOP
      EXIT WHEN n_ <= 1;
      be_ := INSTR(parameter_, seper_char_, be_);
      IF be_ = 0 THEN
        RETURN NULL;
      ELSE
        be_ := be_ + 1;
      END IF;
      n_ := n_ - 1;
   END LOOP;
   en_ := INSTR(parameter_, seper_char_, be_);
   IF en_ > 0 THEN
      param_ := SUBSTR(parameter_, be_, en_ - be_);
      RETURN param_;
   ELSE
      param_ := SUBSTR(parameter_, be_, Length(parameter_) - be_ + 1);
      RETURN param_;
   END IF;
END Decode_Attribute;

PROCEDURE Assert_Match_By (
   view_name_ IN VARCHAR2,
   match_by_  IN VARCHAR2 )
IS
   trimmed_match_by_ VARCHAR2(200) := match_by_;
   column_ VARCHAR2(200);
   i_  NUMBER := 1;
BEGIN
   trimmed_match_by_ := TRIM(LEADING '(' FROM trimmed_match_by_);
   trimmed_match_by_ := TRIM(TRAILING ')' FROM trimmed_match_by_);
  
   LOOP
      column_ := Decode_Attribute(trimmed_match_by_, i_, ',');      
      EXIT WHEN column_ IS NULL;      
      Assert_SYS.Assert_Is_View_Column(view_name_, column_);   
      i_ := i_ + 1;
   END LOOP;
END Assert_Match_By;

@UncheckedAccess
FUNCTION Get_Identity_From_Key_Ref (
   data_subject_  IN VARCHAR2,
   key_reference_ IN VARCHAR2,
   order_         IN NUMBER ) RETURN VARCHAR2
IS
   identity_ VARCHAR2(200);
BEGIN
   -- REPLACE IF by CASE
   IF (data_subject_ = 'PERSON') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'PERSON_ID');
   ELSIF (data_subject_ = 'EMPLOYEE') THEN
      IF (order_ = 1) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'COMPANY_ID');
      ELSIF (order_ = 2) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'EMPLOYEE_ID');
      END IF;
   ELSIF (data_subject_ = 'BUSINESS_LEAD') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'LEAD_ID');
   ELSIF (data_subject_ IN ('BUSINESS_CONTACT','BUSINESS_CONTACTS')) THEN
      IF (order_ = 1) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'LEAD_ID');
      ELSIF (order_ = 2) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'CONTACT_ID');
      END IF;
   ELSIF (data_subject_ = 'APPLICANT') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'APPLICANT_ID');
   ELSIF (data_subject_ = 'CUSTOMER') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'CUSTOMER_ID');
   ELSIF (data_subject_ = 'SUPPLIER') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'SUPPLIER_ID');
   ELSIF (data_subject_ = 'USER') THEN
      identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'IDENTITY');
   ELSIF (data_subject_ IN ('PERSON_DEPENDENT','DEPENDENTS')) THEN
      IF (order_ = 1) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'PERSON_ID');
      ELSIF (order_ = 2) THEN
         identity_ := Client_SYS.Get_Key_Reference_Value(key_reference_,'RELATION_ID');
      END IF;
   END IF;
   RETURN identity_;
END Get_Identity_From_Key_Ref;

FUNCTION Get_Schedule_Method_Flag (
   schedule_metod_ IN VARCHAR2,
   param_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   param_value_ VARCHAR2(2000);
   
   CURSOR get_param_value IS
   SELECT p.value
   FROM   batch_schedule_par_tab p, batch_schedule_tab b
   WHERE  p.schedule_id = b.schedule_id
   AND    b.schedule_method_id = Batch_Schedule_Method_API.Get_Schedule_Method_Id('PERSONAL_DATA_MAN_UTIL_API.REMOVE_WITHOUT_CONSENT_HISTORY')
   AND    p.name = param_name_;
BEGIN
   OPEN get_param_value;
   FETCH get_param_value INTO param_value_;
   CLOSE get_param_value;
   RETURN param_value_;
END Get_Schedule_Method_Flag;

PROCEDURE Remove_Data_Consents_By_Keys (
   data_subject_  IN VARCHAR2,
   key1_          IN VARCHAR2,
   key2_          IN VARCHAR2 )
IS
   info_            VARCHAR2(2000);
   key_ref_         VARCHAR2(100);
   CURSOR get_data_subject_consent_rec IS
      SELECT rowid       objid,
             to_char(rowversion,'YYYYMMDDHH24MISS')  objversion
      FROM   data_subject_consent_tab
      WHERE  key_ref   =  key_ref_;
   CURSOR get_data_subject_cons_oper_rec IS
      SELECT rowid       objid,
             to_char(rowversion,'YYYYMMDDHH24MISS')  objversion
      FROM   data_subject_consent_oper_tab
      WHERE  key_ref   =  key_ref_;
   CURSOR get_data_subject_cons_purp_rec IS
      SELECT rowid       objid,
             to_char(rowversion,'YYYYMMDDHH24MISS')  objversion
      FROM   data_subject_consent_purp_tab
      WHERE  key_ref   =  key_ref_;
   CURSOR get_data_subject_cons_log_rec IS
      SELECT rowid       objid,
             to_char(rowversion,'YYYYMMDDHH24MISS')  objversion
      FROM   personal_data_cleanup_log_tab
      WHERE  key_ref   =  key_ref_;      
BEGIN
   key_ref_ := Data_Subject_Consent_API.Get_Subject_Key_Ref(data_subject_, key1_, key2_);
   FOR rec IN get_data_subject_cons_purp_rec LOOP
      Data_Subject_Consent_Purp_API.Remove__(info_, rec.objid, rec.objversion, 'DO');
   END LOOP;
   FOR rec IN get_data_subject_cons_log_rec LOOP
      Personal_Data_Cleanup_Log_API.Remove__(info_, rec.objid, rec.objversion, 'DO');
   END LOOP;
   FOR rec IN get_data_subject_cons_oper_rec LOOP
      Data_Subject_Consent_Oper_API.Remove__(info_, rec.objid, rec.objversion, 'DO');
   END LOOP;
   FOR rec IN get_data_subject_consent_rec LOOP
      Data_Subject_Consent_API.Remove__(info_, rec.objid, rec.objversion, 'DO');
   END LOOP;         
END Remove_Data_Consents_By_Keys;

PROCEDURE Migrate_Consent (
   key_ref_         IN VARCHAR2,
   data_subject_    IN VARCHAR2,
   operation_date_  IN DATE,
   update_date_     IN DATE,
   remark_          IN VARCHAR2,
   purpose_id_      IN NUMBER,
   effective_on_    IN DATE,
   effective_unitl_ IN DATE )
IS
   temp_operation_date_ DATE;
   CURSOR get_purposes IS
   SELECT purpose_id
   FROM pers_data_man_proc_purpose_tab
   WHERE data_subject = data_subject_
   AND purpose_id != purpose_id_;
BEGIN
   IF NOT Data_Subject_Consent_Oper_API.Exists_Db(key_ref_, operation_date_, Data_Sub_Consent_Action_API.DB_NEW_PURPOSE) THEN
      temp_operation_date_ := operation_date_;
      Data_Subject_Consent_Oper_API.Consent_Action(temp_operation_date_, key_ref_, data_subject_, update_date_, Data_Sub_Consent_Action_API.DB_NEW_PURPOSE, remark_);
      Data_Subject_Consent_Purp_API.Consent_Action_Purpose(key_ref_, temp_operation_date_, Data_Sub_Consent_Action_API.DB_NEW_PURPOSE, purpose_id_, 'TRUE', effective_on_, effective_unitl_);
      FOR rec IN get_purposes LOOP
         Data_Subject_Consent_Purp_API.Consent_Action_Purpose(key_ref_, temp_operation_date_, Data_Sub_Consent_Action_API.DB_NEW_PURPOSE, rec.purpose_id, 'FALSE', NULL, NULL);
      END LOOP;
   ELSE
      Data_Subject_Consent_Purp_API.Consent_Action_Purpose(key_ref_, operation_date_, Data_Sub_Consent_Action_API.DB_NEW_PURPOSE, purpose_id_, 'TRUE', effective_on_, effective_unitl_);
   END IF;
END Migrate_Consent;

PROCEDURE Notify_And_Remove_Not_Valid (
   message_ IN VARCHAR2)
IS
   msgl_                      VARCHAR2(32000);
   count_                     NUMBER;
   name_arr_                  Message_SYS.name_table;
   value_arr_                 Message_SYS.line_table;
   consent_expiring_period_   NUMBER;
   data_cleanup_period_       NUMBER;
   send_notification_         VARCHAR2(10);
   automatic_data_erasure_    VARCHAR2(10);
   unauthorized_data_cleanup_ VARCHAR2(10);
   
   CURSOR get_notify_data IS
   SELECT   DISTINCT ds.key_ref, ds.data_subject, dsp.process_purpose_id, nvl(dsp.effective_until,dso.update_date) effective_until, '1' notification_type
      FROM  data_subject_consent_tab ds,
            data_subject_consent_oper_tab dso,
            data_subject_consent_purp_tab dsp
      WHERE ds.key_ref = dso.key_ref
      AND   ds.key_ref = dsp.key_ref
      AND   dso.operation_date = dsp.operation_date
      AND   dso.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED
      AND   ((dsp.valid = 'FALSE' AND trunc(sysdate) BETWEEN dso.update_date - consent_expiring_period_ AND dso.update_date - data_cleanup_period_-1)
            OR (dsp.valid = 'TRUE' AND dsp.effective_until IS NOT NULL AND trunc(sysdate) BETWEEN dsp.effective_until - consent_expiring_period_ AND dsp.effective_until - data_cleanup_period_-1))
      AND   dso.operation_date = (SELECT MAX(operation_date) 
                                  FROM    data_subject_consent_oper_tab x
                                  WHERE   x.key_ref = ds.key_ref
                                  AND     x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED)
      AND   NOT EXISTS (SELECT 1
                        FROM  data_subject_consent_oper_tab t, data_subject_consent_purp_tab w
                        WHERE t.key_ref = ds.key_ref
                        AND   t.key_ref = w.key_ref
                        AND   t.operation_date = w.operation_date
                        AND   t.action = w.action
                        AND   t.operation_date >= dso.operation_date
                        AND   w.valid = 'TRUE'
                        AND   w.process_purpose_id = dsp.process_purpose_id
                        AND   t.action = Data_Sub_Consent_Action_API.DB_DATA_ERASED)
   UNION ALL
   SELECT   DISTINCT ds.key_ref, ds.data_subject, dsp.process_purpose_id, nvl(dsp.effective_until,dso.update_date) effective_until, '2' notification_type
      FROM  data_subject_consent_tab ds,
            data_subject_consent_oper_tab dso,
            data_subject_consent_purp_tab dsp
      WHERE ds.key_ref = dso.key_ref
      AND   ds.key_ref = dsp.key_ref
      AND   dso.operation_date = dsp.operation_date
      AND   dso.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED
      AND   ((dsp.valid = 'FALSE' AND trunc(sysdate) >= dso.update_date - data_cleanup_period_)
            OR (dsp.valid = 'TRUE' AND dsp.effective_until IS NOT NULL AND trunc(sysdate) >= dsp.effective_until - data_cleanup_period_))
      AND   dso.operation_date = (SELECT MAX(operation_date) 
                                  FROM    data_subject_consent_oper_tab x
                                  WHERE   x.key_ref = ds.key_ref
                                  AND     x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED)
      AND   NOT EXISTS (SELECT 1
                        FROM  data_subject_consent_oper_tab t, data_subject_consent_purp_tab w
                        WHERE t.key_ref = ds.key_ref
                        AND   t.key_ref = w.key_ref
                        AND   t.operation_date = w.operation_date
                        AND   t.action = w.action
                        AND   t.operation_date >= dso.operation_date
                        AND   w.valid = 'TRUE'
                        AND   w.process_purpose_id = dsp.process_purpose_id
                        AND   t.action = Data_Sub_Consent_Action_API.DB_DATA_ERASED);
                        
   CURSOR get_data_to_erase IS
    SELECT  DISTINCT ds.key_ref, dso.update_date
      FROM  data_subject_consent_tab ds,
            data_subject_consent_oper_tab dso,
            data_subject_consent_purp_tab dsp
      WHERE ds.key_ref = dso.key_ref
      AND   ds.key_ref = dsp.key_ref
      AND   dso.operation_date = dsp.operation_date
      AND   dso.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED
      AND   ((dsp.valid = 'FALSE' AND trunc(sysdate) >= dso.update_date)
            OR (dsp.valid = 'TRUE' AND trunc(sysdate) NOT BETWEEN NVL(dsp.effective_on, Database_Sys.Get_First_Calendar_Date()) AND NVL(dsp.effective_until, Database_Sys.Get_Last_Calendar_Date())))
      AND   dso.operation_date = (SELECT MAX(operation_date) 
                                  FROM    data_subject_consent_oper_tab x
                                  WHERE   x.key_ref = ds.key_ref
                                  AND     x.action != Data_Sub_Consent_Action_API.DB_DATA_ERASED)
      AND   NOT EXISTS (SELECT 1
                        FROM  data_subject_consent_oper_tab t, data_subject_consent_purp_tab w
                        WHERE t.key_ref = ds.key_ref
                        AND   t.key_ref = w.key_ref
                        AND   t.operation_date = w.operation_date
                        AND   t.action = w.action
                        AND   t.operation_date >= dso.operation_date
                        AND   w.valid = 'TRUE'
                        AND   w.process_purpose_id = dsp.process_purpose_id
                        AND   t.action = Data_Sub_Consent_Action_API.DB_DATA_ERASED)
   UNION
   SELECT DISTINCT ds.key_ref, trunc(sysdate)
     FROM data_subject_consent_tab ds,
          pers_data_man_proc_purp_all p 
     WHERE ds.data_subject = p.data_subject
     AND  p.purpose_id = 0
     AND  unauthorized_data_cleanup_ = 'TRUE';
BEGIN     
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONSENT_EXPIRING_PERIOD') THEN
         consent_expiring_period_ := NVL(value_arr_(n_), 0);
      ELSIF (name_arr_(n_) = 'DATA_CLEANUP_PERIOD') THEN
         data_cleanup_period_ := NVL(value_arr_(n_), 0);
      ELSIF (name_arr_(n_) = 'SEND_NOTIFICATION') THEN
         send_notification_ := NVL(value_arr_(n_), 'FALSE');
      ELSIF (name_arr_(n_) = 'AUTOMATIC_DATA_ERASURE') THEN
         automatic_data_erasure_ := NVL(value_arr_(n_), 'FALSE');
      ELSIF (name_arr_(n_) = 'UNAUTHORIZED_DATA_CLEANUP') THEN
         unauthorized_data_cleanup_ := NVL(value_arr_(n_), 'FALSE');
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   IF send_notification_ = 'TRUE' THEN
      FOR rec IN get_notify_data LOOP
         IF rec.notification_type = '1' THEN
            IF Event_Sys.Event_Enabled(lu_name_, 'DATA_SUBJECT_CONSENT_EXPIRE') THEN
               msgl_ := Message_Sys.Construct('DATA_SUBJECT_CONSENT_EXPIRE');
               Message_Sys.Add_Attribute(msgl_, 'IDENTITY', Data_Subject_Consent_API.Get_Identity(rec.key_ref,rec.data_subject));
               Message_Sys.Add_Attribute(msgl_, 'DATA_SUBJECT', Data_Subject_API.Decode(rec.data_subject));
               Message_Sys.Add_Attribute(msgl_, 'PURPOSE_NAME', Pers_Data_Process_Purpose_API.Get_Purpose_Name(rec.process_purpose_id));
               Message_Sys.Add_Attribute(msgl_, 'DAYS_TO_EXPIRE', greatest(0,rec.effective_until - trunc(sysdate)));
               Message_Sys.Add_Attribute(msgl_, 'EXPIRE_DATE', rec.effective_until);               
               Event_Sys.Event_Execute(lu_name_, 'DATA_SUBJECT_CONSENT_EXPIRE', msgl_);
            END IF;            
         ELSE
            IF Event_Sys.Event_Enabled(lu_name_, 'DATA_SUBJECT_DATA_ERASE') THEN
               msgl_ := Message_Sys.Construct('DATA_SUBJECT_DATA_ERASE');
               Message_Sys.Add_Attribute(msgl_, 'IDENTITY', Data_Subject_Consent_API.Get_Identity(rec.key_ref,rec.data_subject));
               Message_Sys.Add_Attribute(msgl_, 'DATA_SUBJECT', Data_Subject_API.Decode(rec.data_subject));
               Message_Sys.Add_Attribute(msgl_, 'PURPOSE_NAME', Pers_Data_Process_Purpose_API.Get_Purpose_Name(rec.process_purpose_id));
               Message_Sys.Add_Attribute(msgl_, 'DAYS_TO_REMOVE', greatest(0,rec.effective_until - trunc(sysdate)));
               Message_Sys.Add_Attribute(msgl_, 'REMOVAL_DATE', rec.effective_until);               
               Event_Sys.Event_Execute(lu_name_, 'DATA_SUBJECT_DATA_ERASE', msgl_);
            END IF;            
         END IF;
      END LOOP;
   END IF;
   
   IF automatic_data_erasure_ = 'TRUE' THEN
      FOR rec IN get_data_to_erase LOOP
         Data_Subject_Consent_Oper_API.Erase_Action(rec.key_ref, sysdate, rec.update_date);
      END LOOP;
   END IF;   
END Notify_And_Remove_Not_Valid;

PROCEDURE Remove_Without_Consent_History (
   message_ IN VARCHAR2)
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   person_ds_               VARCHAR2(5);
   customer_ds_             VARCHAR2(5);
   supplier_ds_             VARCHAR2(5);
   applicant_ds_            VARCHAR2(5);
   ext_candidate_ds_        VARCHAR2(5);
   employee_ds_             VARCHAR2(5);
   business_lead_ds_        VARCHAR2(5);
   business_contact_ds_     VARCHAR2(5);
   dependents_ds_           VARCHAR2(5);    
   --person_dependents_ BOOLEAN
   
   CURSOR get_persons IS
   SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('PERSON', person_id, NULL) key_ref
   FROM person_info_tab
   WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('PERSON',person_id, NULL)
                     AND data_subject = 'PERSON');

   CURSOR get_suppliers IS
   SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('SUPPLIER', supplier_id, NULL) key_ref
   FROM supplier_info_tab
   WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('SUPPLIER', supplier_id, NULL)
                     AND data_subject = 'SUPPLIER');
                     
   CURSOR get_customers IS
   SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('CUSTOMER', customer_id, NULL) key_ref
   FROM customer_info_tab
   WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('CUSTOMER', customer_id, NULL)
                     AND data_subject = 'CUSTOMER');
                     
   CURSOR get_employees IS
   SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('EMPLOYEE', company, employee_id) key_ref
   FROM company_emp_tab
   WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('EMPLOYEE', company, employee_id)
                     AND data_subject = 'EMPLOYEE');
   
   
   $IF Component_Rcruit_SYS.INSTALLED $THEN
   CURSOR get_applicants IS
   SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('APPLICANT', applicant_id, NULL) key_ref
   FROM applicant_info_tab
   WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('APPLICANT', applicant_id, NULL)
                     AND data_subject = 'APPLICANT');
   $END
   
   $IF Component_Crm_SYS.INSTALLED $THEN
   CURSOR get_business_lead IS
      SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('BUSINESS_LEAD', lead_id, NULL) key_ref
      FROM   business_lead_tab
      WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('BUSINESS_LEAD', lead_id, NULL)
                     AND data_subject = 'BUSINESS_LEAD');
   CURSOR get_lead_contacts IS
      SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('BUSINESS_CONTACT', lead_id, contact_id) key_ref
      FROM   business_lead_contact_tab
      WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('BUSINESS_CONTACT', lead_id, contact_id)
                     AND data_subject = 'BUSINESS_CONTACT')
      AND Is_Valid_Consent(Data_Subject_Consent_API.Get_Subject_Key_Ref('BUSINESS_LEAD', lead_id, NULL), 'BUSINESS_LEAD', 21, TRUNC(sysdate), 'ISVALIDCONSENT') = 'FALSE';
   $END
   $IF Component_Person_SYS.INSTALLED $THEN
   CURSOR get_person_dependents IS
      SELECT Data_Subject_Consent_API.Get_Subject_Key_Ref('PERSON_DEPENDENT', person_id, to_char(relation_id)) key_ref
      FROM   related_person_tab
      WHERE NOT EXISTS (SELECT 1 
                     FROM data_subject_consent_tab
                     WHERE key_ref = Data_Subject_Consent_API.Get_Subject_Key_Ref('PERSON_DEPENDENT', person_id, to_char(relation_id))
                     AND data_subject = 'PERSON_DEPENDENT')
      AND Is_Valid_Consent(Data_Subject_Consent_API.Get_Subject_Key_Ref('PERSON', person_id, NULL), 'PERSON', 22, TRUNC(sysdate), 'ISVALIDCONSENT') = 'FALSE';
   $END
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'PERSON') THEN
         person_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'CUSTOMER') THEN
         customer_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'SUPPLIER') THEN
         supplier_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'EMPLOYEE') THEN
         employee_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'APPLICANT') THEN
         applicant_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'BUSINESS_LEAD') THEN
         business_lead_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'BUSINESS_CONTACT') THEN
         business_contact_ds_ := nvl(value_arr_(n_),'FALSE');
      ELSIF (name_arr_(n_) = 'DEPENDENTS') THEN
         dependents_ds_ := nvl(value_arr_(n_),'FALSE'); 
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   
   IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('PERSON') = 'TRUE' THEN
      IF person_ds_ = 'TRUE' THEN
         FOR rec IN get_persons LOOP
            Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'PERSON', trunc(sysdate), null);
         END LOOP;
      END IF;
      Data_Subject_API.Clear_Clean_Up_Flag('PERSON');
   END IF;
   
   IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('SUPPLIER') = 'TRUE' THEN
      IF supplier_ds_ = 'TRUE' THEN
         FOR rec IN get_suppliers LOOP
            Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'SUPPLIER', trunc(sysdate), null);
         END LOOP;
      END IF;
      Data_Subject_API.Clear_Clean_Up_Flag('SUPPLIER');
   END IF;
   
   IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('CUSTOMER') = 'TRUE' THEN
      IF customer_ds_ = 'TRUE' THEN
         FOR rec IN get_customers LOOP
            Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'CUSTOMER', trunc(sysdate), null);
         END LOOP;
      END IF;
      Data_Subject_API.Clear_Clean_Up_Flag('CUSTOMER');
   END IF;
   
   IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('EMPLOYEE') = 'TRUE' THEN
      IF employee_ds_ = 'TRUE' THEN
         FOR rec IN get_employees LOOP
            Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'EMPLOYEE', trunc(sysdate), null);
         END LOOP;
      END IF;
      Data_Subject_API.Clear_Clean_Up_Flag('EMPLOYEE');
   END IF;
   
   $IF Component_Rcruit_SYS.INSTALLED $THEN
      IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('APPLICANT') = 'TRUE' THEN
         IF applicant_ds_ = 'TRUE' THEN
            FOR rec IN get_applicants LOOP
               Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'APPLICANT', trunc(sysdate), null);
            END LOOP;
         END IF;
         Data_Subject_API.Clear_Clean_Up_Flag('APPLICANT');
      END IF;
   $END
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('BUSINESS_LEAD') = 'TRUE' THEN
         IF business_lead_ds_ = 'TRUE' THEN
            FOR rec IN get_business_lead LOOP
               Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'BUSINESS_LEAD', trunc(sysdate), null);
            END LOOP;
         END IF;
         Data_Subject_API.Clear_Clean_Up_Flag('BUSINESS_LEAD');
      END IF;
      IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('BUSINESS_CONTACT') = 'TRUE' THEN
         IF business_contact_ds_ = 'TRUE' THEN
            FOR rec IN get_lead_contacts LOOP
               Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'BUSINESS_CONTACT', trunc(sysdate), null);
            END LOOP;
         END IF;
         Data_Subject_API.Clear_Clean_Up_Flag('BUSINESS_CONTACT');
      END IF;
   $END
   $IF Component_Person_SYS.INSTALLED $THEN
      IF Data_Subject_API.Get_No_History_Data_Cleanup_Db('PERSON_DEPENDENT') = 'TRUE' THEN
         IF dependents_ds_ = 'TRUE' THEN 
            FOR rec IN get_person_dependents LOOP
               Data_Subject_Consent_Oper_API.No_Consent_With_Erase_Action(rec.key_ref, 'PERSON_DEPENDENT', trunc(sysdate), null);
            END LOOP;
         END IF;
         Data_Subject_API.Clear_Clean_Up_Flag('PERSON_DEPENDENT');
      END IF;
   $END
END Remove_Without_Consent_History;