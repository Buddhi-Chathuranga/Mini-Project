-----------------------------------------------------------------------------
--
--  Logical unit: CompanyKeyLuTranslation
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021105  stdafi  Created
--  021120  ovjose  Glob06. Added Insert_Company_Translation__, Remove_Attribute_key__,
--                  Get_Company_Translation__ and Insert_Prog__.
--  021203  Ravilk  Added Procedure Remove_Translations().
--  021210  Ravilk  Added Procedure Get_Tax_Code_text().
--  021220  Ravilk  Remove Procedures Remove_Translations() and Get_Tax_Code_text()
--  181823  Nudilk  Bug 143758, Corrected.
--  190522  Dakplk  Bug 147872, Modified Copy_To_Companies__.
--  220127  Uppalk  Bug 162199, Increased VARCHAR buffer of few variables in Copy_To_Companies_For_Svc method from 2000 to 32000
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Set_Language_Code___ (
   language_code_out_ OUT VARCHAR2,
   language_code_in_  IN  VARCHAR2 )
IS
BEGIN
   language_code_out_ := language_code_in_;
   IF (language_code_in_ IS NULL) THEN
      language_code_out_ := NVL(Fnd_Session_API.Get_Language, 'en');
   END IF;
END Set_Language_Code___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_ VARCHAR2(2000);
BEGIN
   super(attr_);
   Key_Lu_Translation_API.New__(temp_, temp_, temp_, attr_, 'PREPARE');
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT key_lu_translation_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Insert language into the Imp table that holds langauges per template/company
   Key_Lu_Translation_API.Insert_Translation_Lng__(newrec_.key_name, newrec_.key_value, newrec_.language_code);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     key_lu_translation_tab%ROWTYPE,
   newrec_     IN OUT key_lu_translation_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (NVL(newrec_.current_translation, CHR(0)) = NVL(newrec_.installation_translation, CHR(0))) THEN
      newrec_.system_defined := 'TRUE';
   ELSE
      newrec_.system_defined := 'FALSE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED', newrec_.system_defined, attr_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN key_lu_translation_tab%ROWTYPE )
IS   
BEGIN
   super(objid_, remrec_);
   Key_Lu_Translation_API.Remove_Translation_Lng__(remrec_.key_name, remrec_.key_value, remrec_.language_code);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT key_lu_translation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (NOT Company_Key_Lu_Attribute_API.Exists(newrec_.key_name, newrec_.key_value, newrec_.module, newrec_.lu, newrec_.attribute_key)) THEN
      Error_SYS.Appl_General(lu_name_, 'NOPROGATTR: Attribute :P1 does not exist for module :P2 and Logial Unit :P3 for specified Company.', newrec_.attribute_key, newrec_.module, newrec_.lu);
   END IF;   
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     key_lu_translation_tab%ROWTYPE,
   newrec_ IN OUT key_lu_translation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (App_Context_SYS.Find_Value(lu_name_||'.copy_to_company_', 'FALSE') != 'TRUE') THEN
      IF (Company_Basic_Data_Window_API.Check_Copy_From_Company(newrec_.key_value, lu_name_)) THEN
         Error_SYS.Record_General(lu_name_, 'NODIRECTINSERT: A record cannot be entered/modified as :P1 window has been set up for copying data only from source company in Basic Data Synchronization window.', Basic_Data_Window_API.Get_Window(lu_name_));
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN key_lu_translation_tab%ROWTYPE )
IS
BEGIN
   IF (App_Context_Sys.Find_Value(lu_name_||'.copy_to_company_', 'FALSE') != 'TRUE') THEN
      IF (Company_Basic_Data_Window_API.Check_Copy_From_Company(remrec_.key_value, lu_name_)) THEN
         Error_SYS.Record_General(lu_name_, 'NODIRECTREMOVE: A record cannot be removed as :P1 window has been set up for copying data only from source company in Basic Data Synchronization window.', Basic_Data_Window_API.Get_Window(lu_name_));
      END IF;
   END IF;
   super(remrec_);
END Check_Delete___;


PROCEDURE Copy_To_Companies_For_Svc___ (
   source_company_            IN  VARCHAR2,
   target_company_list_       IN  VARCHAR2,
   module_list_               IN  VARCHAR2,
   lu_list_                   IN  VARCHAR2,
   attribute_key_list_        IN  VARCHAR2,
   language_code_list_        IN  VARCHAR2,
   update_method_list_        IN  VARCHAR2,
   log_id_                    IN  NUMBER,
   attr_                      IN  VARCHAR2 DEFAULT NULL )
IS
   ptr_                    NUMBER;
   ptr1_                   NUMBER;
   ptr2_                   NUMBER;
   i_                      NUMBER;
   update_method_          VARCHAR2(20);
   value_                  VARCHAR2(2000);
   target_company_         VARCHAR2(20);
   TYPE company_key_lu_translation IS TABLE OF key_lu_translation_tab%ROWTYPE INDEX BY BINARY_INTEGER;
   TYPE attr IS TABLE OF VARCHAR2 (32000) INDEX BY BINARY_INTEGER;                              
   ref_company_key_lu_trans_       company_key_lu_translation;
   ref_attr_                       attr;
   attr_value_                     VARCHAR2(32000) := NULL;   
BEGIN
   ptr_  := NULL;
   ptr2_ := NULL;
   ptr1_ := NULL;
   i_    := 0;   
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, module_list_) LOOP
      ref_company_key_lu_trans_(i_).module := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, lu_list_) LOOP
      ref_company_key_lu_trans_(i_).lu := value_;
      i_ := i_ + 1; 
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, attribute_key_list_) LOOP
      ref_company_key_lu_trans_(i_).attribute_key := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, language_code_list_) LOOP
      ref_company_key_lu_trans_(i_).language_code := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, attr_) LOOP
      ref_attr_(i_) := value_;
      i_ := i_ + 1;
   END LOOP;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(target_company_, ptr1_, target_company_list_) LOOP      
      IF (Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(update_method_, ptr2_, update_method_list_)) THEN
         FOR j_ IN ref_company_key_lu_trans_.FIRST..ref_company_key_lu_trans_.LAST LOOP
            IF (ref_attr_.FIRST IS NOT NULL) THEN
               attr_value_ := ref_attr_(j_);
            END IF;            
            Copy_To_Companies__(source_company_, 
                                target_company_,
                                ref_company_key_lu_trans_(j_).module,
                                ref_company_key_lu_trans_(j_).lu,
                                ref_company_key_lu_trans_(j_).attribute_key,
                                ref_company_key_lu_trans_(j_).language_code,
                                update_method_,
                                log_id_,
                                attr_value_);
         END LOOP;
      END IF;
   END LOOP;
END Copy_To_Companies_For_Svc___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Company_Translation__ (
   key_value_           IN VARCHAR2,
   module_              IN VARCHAR2,
   lu_                  IN VARCHAR2,
   attribute_key_       IN VARCHAR2,
   language_code_       IN VARCHAR2 DEFAULT NULL,
   only_chosen_lang_    IN VARCHAR2 DEFAULT 'YES' ) RETURN VARCHAR2 
IS   
   lang_code_           key_lu_translation_tab.language_code%TYPE;  
   rec_                 key_lu_translation_tab%ROWTYPE;   
BEGIN   
   Set_Language_Code___(lang_code_, language_code_);
   rec_ := Get_Object_By_Keys___('CompanyKeyLu', key_value_, module_, lu_, attribute_key_, lang_code_);
   IF (only_chosen_lang_ = 'NO') THEN
      -- when only_chosen_lang_ = 'NO' then text will be returned from Company_Key_Lu_Attribute_API.Get_Attribute_Text as there are not longer
      -- any PROG language in key_lu_translation_tab. 
      -- Interfaces using the flag only_chosen_lang_ = 'NO' should be changed to no longer use that and instead use a NVL with the text from the owning
      -- LUs text field.
      IF (rec_.current_translation IS NULL) THEN
         RETURN Company_Key_Lu_Attribute_API.Get_Attribute_Text('CompanyKeyLu', key_value_, module_, lu_, attribute_key_);
      END IF;
      RETURN rec_.current_translation;
   ELSE
      RETURN rec_.current_translation;
   END IF;
END Get_Company_Translation__;


PROCEDURE Insert_Company_Translation__ (
   key_value_        IN VARCHAR2,
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2,
   attribute_key_    IN VARCHAR2,
   language_code_    IN VARCHAR2,
   translation_      IN VARCHAR2 )
IS
   lang_code_           key_lu_translation_tab.language_code%TYPE;
   oldrec_              key_lu_translation_tab%ROWTYPE;   
   newrec_              key_lu_translation_tab%ROWTYPE;
   attr_                VARCHAR2(2000);
   objid_               company_key_lu_translation.objid%TYPE;
   objversion_          company_key_lu_translation.objversion%TYPE;
BEGIN
   IF (Company_Key_Lu_Attribute_API.Exists('CompanyKeyLu', key_value_, module_, lu_, attribute_key_)) THEN   
      Set_Language_Code___(lang_code_, language_code_);      
      oldrec_ := Get_Object_By_Keys___('CompanyKeyLu', key_value_, module_, lu_, attribute_key_, lang_code_);
      -- if no row exist then add row to the table for the current language
      IF (oldrec_.key_name IS NULL) THEN
         newrec_.key_name                 := 'CompanyKeyLu';
         newrec_.key_value                := key_value_;
         newrec_.module                   := module_;
         newrec_.lu                       := lu_;
         newrec_.attribute_key            := attribute_key_;
         newrec_.language_code            := lang_code_;
         newrec_.current_translation      := translation_;
         newrec_.installation_translation := translation_;
         newrec_.system_defined           := 'FALSE';
         Error_SYS.Check_Not_Null(lu_name_, 'KEY_NAME', newrec_.key_name);
         Error_SYS.Check_Not_Null(lu_name_, 'KEY_VALUE', newrec_.key_value);
         Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
         Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
         Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', newrec_.attribute_key);
         Error_SYS.Check_Not_Null(lu_name_, 'SYSTEM_DEFINED', newrec_.system_defined);
         Error_SYS.Check_Not_Null(lu_name_, 'LANGUAGE_CODE', newrec_.language_code);
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSE
         newrec_ := oldrec_;
         newrec_.current_translation := translation_;
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;
END Insert_Company_Translation__;

                                 
PROCEDURE Insert_Translation__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2,
   translation_   IN VARCHAR2 )
IS
   objid_         company_key_lu_translation.objid%TYPE;
   objversion_    company_key_lu_translation.objversion%TYPE;
   attr_          VARCHAR2(2000);
   oldrec_        key_lu_translation_tab%ROWTYPE;
   newrec_        key_lu_translation_tab%ROWTYPE;
   exist_         BOOLEAN;
BEGIN   
   exist_ := Company_Key_Lu_Attribute_API.Exists('CompanyKeyLu', key_value_, module_, lu_, attribute_key_);
   IF (exist_) THEN
      oldrec_ := Get_Object_By_Keys___('CompanyKeyLu', key_value_, module_, lu_, attribute_key_, language_code_);
      IF (oldrec_.key_name IS NOT NULL) THEN
         newrec_ := oldrec_;
         IF (NVL(oldrec_.current_translation, CHR(0)) = NVL(oldrec_.installation_translation, CHR(0))) THEN
            newrec_.current_translation := translation_;
         END IF;
         newrec_.installation_translation := translation_;
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      ELSE
         newrec_.key_name                 := 'CompanyKeyLu';
         newrec_.key_value                := key_value_;
         newrec_.module                   := module_;
         newrec_.lu                       := lu_;
         newrec_.attribute_key            := attribute_key_;
         newrec_.language_code            := language_code_;
         newrec_.current_translation      := translation_;
         newrec_.installation_translation := translation_;
         newrec_.system_defined           := 'TRUE';
         Error_SYS.Check_Not_Null(lu_name_, 'KEY_NAME', newrec_.key_name);
         Error_SYS.Check_Not_Null(lu_name_, 'KEY_VALUE', newrec_.key_value);
         Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
         Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
         Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', newrec_.attribute_key);
         Error_SYS.Check_Not_Null(lu_name_, 'SYSTEM_DEFINED', newrec_.system_defined);
         Error_SYS.Check_Not_Null(lu_name_, 'LANGUAGE_CODE', newrec_.language_code);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END IF;
END Insert_Translation__;


FUNCTION Check_Exist_Company_Lu_Trans__ (
   key_name_  IN VARCHAR2,
   key_value_ IN VARCHAR2,
   module_    IN VARCHAR2,
   lu_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_lu_trans IS
      SELECT 1
      FROM   key_lu_translation_tab
      WHERE  key_name = 'CompanyKeyLu'
      AND    key_value = key_value_
      AND    module = module_
      AND    lu = lu_;
BEGIN
   OPEN get_lu_trans;
   FETCH get_lu_trans INTO dummy_;
   IF (get_lu_trans%FOUND) THEN
      CLOSE get_lu_trans;
      RETURN TRUE;
   ELSE
      CLOSE get_lu_trans;
      RETURN FALSE;
   END IF;
END Check_Exist_Company_Lu_Trans__;


PROCEDURE Copy_To_Companies__ (
   source_company_      IN VARCHAR2,
   target_company_      IN VARCHAR2,
   module_              IN VARCHAR2,
   lu_                  IN VARCHAR2,
   attribute_key_       IN VARCHAR2,
   language_code_       IN VARCHAR2,
   update_method_       IN VARCHAR2,
   log_id_              IN NUMBER,
   attr_                IN VARCHAR2 DEFAULT NULL )
IS
   source_rec_              key_lu_translation_tab%ROWTYPE;
   target_rec_              key_lu_translation_tab%ROWTYPE;
   old_target_rec_          key_lu_translation_tab%ROWTYPE;
   log_key_                 VARCHAR2(2000);
   log_detail_status_       VARCHAR2(10); 
BEGIN
   source_rec_ := Get_Object_By_Keys___('CompanyKeyLu', source_company_, module_, lu_, attribute_key_, language_code_);
   target_rec_ := source_rec_;
   target_rec_.key_value := target_company_;
   App_Context_SYS.Set_Value(lu_name_||'.copy_to_company_', 'TRUE');
   old_target_rec_ := Get_Object_By_Keys___('CompanyKeyLu', target_company_, module_, lu_, attribute_key_, language_code_);
   log_key_ := module_||'^'||lu_||'^'||attribute_key_||'^'||language_code_;
   IF (source_rec_.rowversion IS NOT NULL AND old_target_rec_.rowversion IS NULL) THEN
      -- Source creates a new record which does not exist in the target company
      New___(target_rec_);
      log_detail_status_ := 'CREATED';
   ELSIF (source_rec_.rowversion IS NOT NULL AND old_target_rec_.rowversion IS NOT NULL AND update_method_ = 'UPDATE_ALL') THEN
      -- Source company adds or modifies a record, the same exists in the target company and the user wants to update the entire record in the target
      target_rec_.rowkey := old_target_rec_.rowkey;
      Modify___(target_rec_);
      log_detail_status_ := 'MODIFIED';     
   ELSIF (source_rec_.rowversion IS NULL AND old_target_rec_.rowversion IS NOT NULL) THEN
      -- Source removes a record, the same record is removed in the target company
      Remove___(old_target_rec_);      
      log_detail_status_ := 'REMOVED';      
   ELSIF (source_rec_.rowversion IS NULL AND old_target_rec_.rowversion IS NULL) THEN
      -- Source removes a record, the same record does not exist in the target company to be removed
      Raise_Record_Not_Exist___('CompanyKeyLu', target_company_, module_, lu_, attribute_key_, language_code_);
   ELSIF (source_rec_.rowversion IS NOT NULL AND old_target_rec_.rowversion IS NOT NULL AND update_method_ = 'NO_UPDATE') THEN
      -- Source company adds or modifies a record, the same exists in the target company and the user does not wan to update records in the target
      Raise_Record_Exist___(target_rec_);
   END IF;
   IF (Company_Basic_Data_Window_API.Check_Copy_From_Source_Company(target_company_, source_company_, lu_name_)) THEN
      IF (log_detail_status_ IN ('CREATED','MODIFIED')) THEN
         Error_SYS.Record_General(lu_name_, 'NODIRECTINSERT: A record cannot be entered/modified as :P1 window has been set up for copying data only from source company in Basic Data Synchronization window.', Basic_Data_Window_API.Get_Window(lu_name_));
      ELSIF (log_detail_status_ = 'REMOVED') THEN
         Error_SYS.Record_General(lu_name_, 'NODIRECTREMOVE: A record cannot be removed as :P1 window has been set up for copying data only from source company in Basic Data Synchronization window.', Basic_Data_Window_API.Get_Window(lu_name_));
      END IF;
   END IF;
   App_Context_SYS.Set_Value(lu_name_||'.copy_to_company_', 'FALSE');
   Copy_Basic_Data_Log_Detail_API.Create_New_Record(log_id_, target_company_, log_key_, log_detail_status_);
EXCEPTION
   WHEN OTHERS THEN
      log_detail_status_ := 'ERROR';
      Copy_Basic_Data_Log_Detail_API.Create_New_Record(log_id_, target_company_, log_key_, log_detail_status_, SQLERRM);     
END Copy_To_Companies__;
   
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
   
PROCEDURE Copy_To_Companies_ (
   attr_ IN  VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(200);
   value_                     VARCHAR2(32000);
   source_company_            VARCHAR2(100);
   target_company_list_       VARCHAR2(32000);
   module_list_               VARCHAR2(32000);
   lu_list_                   VARCHAR2(32000);
   attribute_key_list_        VARCHAR2(32000);
   language_code_list_        VARCHAR2(32000);
   update_method_list_        VARCHAR2(32000);
   copy_type_                 VARCHAR2(100);
   attr1_                     VARCHAR2(32000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SOURCE_COMPANY') THEN
         source_company_ := value_;
      ELSIF (name_ = 'TARGET_COMPANY_LIST') THEN
         target_company_list_ := value_;
      ELSIF (name_ = 'MODULE_LIST') THEN
         module_list_ := value_;
      ELSIF (name_ = 'LU_LIST') THEN
         lu_list_ := value_;
      ELSIF (name_ = 'ATTRIBUTE_KEY_LIST') THEN
         attribute_key_list_ := value_; 
      ELSIF (name_ = 'LANGUAGE_CODE_LIST') THEN
         language_code_list_ := value_;  
      ELSIF (name_ = 'UPDATE_METHOD_LIST') THEN
         update_method_list_ := value_;
      ELSIF (name_ = 'COPY_TYPE') THEN
         copy_type_ := value_;
      ELSIF (name_ = 'ATTR') THEN
         attr1_ := value_||CHR(30)||SUBSTR(attr_, ptr_, LENGTH(attr_)-1);
      END IF;
   END LOOP;
   Copy_To_Companies_(source_company_, target_company_list_, module_list_, lu_list_, attribute_key_list_, language_code_list_, update_method_list_, copy_type_, attr1_);
END Copy_To_Companies_;


PROCEDURE Copy_To_Companies_ (
   source_company_            IN  VARCHAR2,
   target_company_list_       IN  VARCHAR2,
   module_list_               IN  VARCHAR2,
   lu_list_                   IN  VARCHAR2,
   attribute_key_list_        IN  VARCHAR2,
   language_code_list_        IN  VARCHAR2,
   update_method_list_        IN  VARCHAR2,
   copy_type_                 IN  VARCHAR2,
   attr_                      IN  VARCHAR2 DEFAULT NULL )
IS
   ptr_                    NUMBER;
   ptr1_                   NUMBER;
   ptr2_                   NUMBER;
   i_                      NUMBER;
   update_method_          VARCHAR2(20);
   value_                  VARCHAR2(2000);
   target_company_         VARCHAR2(20);
   TYPE company_key_lu_translation IS TABLE OF key_lu_translation_tab%ROWTYPE INDEX BY BINARY_INTEGER;
   TYPE attr IS TABLE OF VARCHAR2 (32000) INDEX BY BINARY_INTEGER;                              
   ref_company_key_lu_trans_       company_key_lu_translation;
   ref_attr_                       attr;
   log_id_                         NUMBER;
   attr_value_                     VARCHAR2(32000) := NULL;   
BEGIN
   ptr_  := NULL;
   ptr2_ := NULL;
   ptr1_ := NULL;
   i_    := 0;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, module_list_) LOOP
      ref_company_key_lu_trans_(i_).module := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, lu_list_) LOOP
      ref_company_key_lu_trans_(i_).lu := value_;
      i_ := i_ + 1; 
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, attribute_key_list_) LOOP
      ref_company_key_lu_trans_(i_).attribute_key := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, language_code_list_) LOOP
      ref_company_key_lu_trans_(i_).language_code := value_;
      i_ := i_ + 1;
   END LOOP;
   i_    := 0;
   ptr_  := NULL;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(value_, ptr_, attr_) LOOP
      ref_attr_(i_) := value_;
      i_ := i_ + 1;
   END LOOP;
   IF (target_company_list_ IS NOT NULL) THEN
      Copy_Basic_Data_Log_API.Create_New_Record(log_id_, source_company_, copy_type_, lu_name_);
   END IF;
   WHILE Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(target_company_, ptr1_, target_company_list_) LOOP      
      IF (Copy_To_Company_Util_API.Get_Next_Record_Sep_Val(update_method_, ptr2_, update_method_list_)) THEN
         FOR j_ IN ref_company_key_lu_trans_.FIRST..ref_company_key_lu_trans_.LAST LOOP
            IF (ref_attr_.FIRST IS NOT NULL) THEN
               attr_value_ := ref_attr_(j_);
            END IF;            
            Copy_To_Companies__(source_company_, 
                                target_company_,
                                ref_company_key_lu_trans_(j_).module,
                                ref_company_key_lu_trans_(j_).lu,
                                ref_company_key_lu_trans_(j_).attribute_key,
                                ref_company_key_lu_trans_(j_).language_code,
                                update_method_,
                                log_id_,
                                attr_value_);
         END LOOP;
      END IF;
   END LOOP;
   IF (target_company_list_ IS NOT NULL) THEN
      Copy_Basic_Data_Log_API.Update_Status(log_id_);
   END IF;
END Copy_To_Companies_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
   
PROCEDURE Copy_To_Companies_For_Svc (
   attr_              IN  VARCHAR2,
   run_in_background_ IN  BOOLEAN,
   log_id_            IN  NUMBER DEFAULT NULL )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(200);
   value_                     VARCHAR2(32000);
   source_company_            VARCHAR2(100);
   target_company_list_       VARCHAR2(32000);
   module_list_               VARCHAR2(32000);
   lu_list_                   VARCHAR2(32000);
   attribute_key_list_        VARCHAR2(32000);
   language_code_list_        VARCHAR2(32000);
   update_method_list_        VARCHAR2(32000);
   attr1_                     VARCHAR2(32000);
   run_in_background_attr_    VARCHAR2(32000);
BEGIN
   IF (run_in_background_) THEN
      run_in_background_attr_ := attr_;
      Transaction_SYS.Deferred_Call('Company_Key_Lu_Translation_API.Copy_To_Companies_', run_in_background_attr_, Language_SYS.Translate_Constant(lu_name_, 'COPYDATA: Copy Basic Data')); 
   ELSE
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'SOURCE_COMPANY') THEN
            source_company_ := value_;
         ELSIF (name_ = 'TARGET_COMPANY_LIST') THEN
            target_company_list_ := value_;
         ELSIF (name_ = 'MODULE_LIST') THEN
            module_list_ := value_;
         ELSIF (name_ = 'LU_LIST') THEN
            lu_list_ := value_;
         ELSIF (name_ = 'ATTRIBUTE_KEY_LIST') THEN
            attribute_key_list_ := value_; 
         ELSIF (name_ = 'LANGUAGE_CODE_LIST') THEN
            language_code_list_ := value_;  
         ELSIF (name_ = 'UPDATE_METHOD_LIST') THEN
            update_method_list_ := value_;
         ELSIF (name_ = 'ATTR') THEN
            attr1_ := value_||CHR(30)||SUBSTR(attr_, ptr_, LENGTH(attr_)-1);
         END IF;
      END LOOP;
      Copy_To_Companies_For_Svc___(source_company_,
                                  target_company_list_,
                                  module_list_,
                                  lu_list_,
                                  attribute_key_list_,
                                  language_code_list_,
                                  update_method_list_,
                                  log_id_,
                                  attr1_);
   END IF;
END Copy_To_Companies_For_Svc;
