-----------------------------------------------------------------------------
--
--  Logical unit: CompanyKeyLuAttribute
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
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

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Company_Translation__ (
   key_value_        IN VARCHAR2,
   module_           IN VARCHAR2,
   lu_               IN VARCHAR2,
   attribute_key_    IN VARCHAR2,
   language_code_    IN VARCHAR2,
   translation_      IN VARCHAR2 )
IS
   oldrec_              key_lu_attribute_tab%ROWTYPE;   
   newrec_              key_lu_attribute_tab%ROWTYPE;
   attr_                VARCHAR2(2000);
   objid_               company_key_lu_attribute.objid%TYPE;
   objversion_          company_key_lu_attribute.objversion%TYPE;
   lang_code_           key_lu_translation_tab.language_code%TYPE;
   l_depth_             PLS_INTEGER;
   method_              VARCHAR2(200);
   make_company_        BOOLEAN := FALSE;
   cnt_                 PLS_INTEGER;
   cre_com_option_      VARCHAR2(5);
BEGIN
   oldrec_ := Get_Object_By_Keys___('CompanyKeyLu', key_value_, module_, lu_, attribute_key_);
   -- if no row exist then register the description for the current language.
   IF (oldrec_.key_name IS NULL) THEN
      newrec_.key_name                 := 'CompanyKeyLu';
      newrec_.key_value                := key_value_;
      newrec_.module                   := module_;
      newrec_.lu                       := lu_;
      newrec_.attribute_key            := attribute_key_;
      newrec_.attribute_text           := translation_;
      newrec_.first_reg_text           := translation_;      
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_NAME', newrec_.key_name);
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_VALUE', newrec_.key_value);
      Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
      Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
      Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', newrec_.attribute_key);
      Insert___(objid_, objversion_, newrec_, attr_);      
      l_depth_ := UTL_CALL_STACK.dynamic_depth;
      cnt_ := 0;
      -- Do not add a row in Company_Key_Lu_Translation if the process is started from Create/Update Company. Translations
      -- will be copied from a template or company depending on the source.
      FOR i IN REVERSE 2..l_depth_ LOOP
         cnt_ := cnt_ + 1;
         method_ := UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(i));
         IF (method_ LIKE '%CREATE_COMPANY_API.CREATE_NEW_COMPANY__%') THEN            
            make_company_ := TRUE;
            EXIT;
            -- This code will never be reached it is just used so that a check in user_dependencies will find that there is code against 
            -- Create_Company_API (the like statment above).
            Create_Company_API.Init;
         END IF;
         -- if the process is started from create/update company then the method_ should have been found by the first 5 rows (usually second row).
         -- If not found by fifth row then assume (to avoid performance issue) not started from create/update company and insert a translation row
         IF (cnt_ = 5) THEN            
            EXIT;
         END IF;            
      END LOOP; 
      cre_com_option_ := App_Context_SYS.Find_Value('CREATE_COM_PARAM', 'FALSE');
      -- if record not created from Create/Update Company process then create translation row
      IF (NOT make_company_ OR cre_com_option_ = 'TRUE') THEN         
         Set_Language_Code___(lang_code_, language_code_);
         Company_Key_Lu_Translation_API.Insert_Company_Translation__(key_value_, module_, lu_, attribute_key_, lang_code_, translation_);         
      END IF;            
   ELSE
      -- to always reflect the latest change in the owning LU the attribute_text is updated
      -- first_reg_desc is not updated to be able to find first registered description (if needed).
      newrec_ := oldrec_;
      newrec_.attribute_text := translation_;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);      
      -- create/update translation with the text (translation_)
      Set_Language_Code___(lang_code_, language_code_);
      Company_Key_Lu_Translation_API.Insert_Company_Translation__(key_value_, module_, lu_, attribute_key_, lang_code_, translation_);
   END IF;   
END Insert_Company_Translation__;


PROCEDURE Remove_Attribute_Key__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN   
   DELETE FROM key_lu_translation_tab
      WHERE key_name = 'CompanyKeyLu'
      AND   key_value = key_value_
      AND   module = module_
      AND   lu = lu_
      AND   attribute_key = attribute_key_;   
   DELETE FROM key_lu_attribute_tab
      WHERE key_name = 'CompanyKeyLu'
      AND   key_value = key_value_
      AND   module = module_
      AND   lu = lu_
      AND   attribute_key = attribute_key_;
   Key_Lu_Translation_API.Refresh_Translation_Imp__('TemplKeyLu', key_value_);
END Remove_Attribute_Key__;


PROCEDURE Insert_Prog__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   oldrec_              key_lu_attribute_tab%ROWTYPE;
   newrec_              key_lu_attribute_tab%ROWTYPE;
   attr_                VARCHAR2(2000);
   objid_               company_key_lu_attribute.objid%TYPE;
   objversion_          company_key_lu_attribute.objversion%TYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___('CompanyKeyLu', key_value_, module_, lu_, attribute_key_);
   IF (oldrec_.key_name IS NULL) THEN
      newrec_.key_name                 := 'CompanyKeyLu';
      newrec_.key_value                := key_value_;
      newrec_.module                   := module_;
      newrec_.lu                       := lu_;
      newrec_.attribute_key            := attribute_key_;
      newrec_.attribute_text           := text_;
      newrec_.first_reg_text           := text_;      
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_NAME', newrec_.key_name);
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_VALUE', newrec_.key_value);
      Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
      Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
      Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', newrec_.attribute_key);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      newrec_ := oldrec_;
      newrec_.attribute_text := text_;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;   
END Insert_Prog__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

