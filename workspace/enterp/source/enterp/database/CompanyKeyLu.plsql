-----------------------------------------------------------------------------
--
--  Logical unit: CompanyKeyLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021105  stdafi  Created
--  021120  ovjose  Glob06. Added Insert_Company_Translation__, Remove_Attribute_key__,
--                  Get_Company_Translation__ and Insert_Prog__.
--  021203  ovjose  Glob06. Added Copy_Translation__ and Copy_Finrep_Translation__
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                     
-------------------- PRIVATE DECLARATIONS -----------------------------------
                     
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Insert_Key_Lu___ (
   success_    IN OUT VARCHAR2,
   key_name_   IN     VARCHAR2,
   key_value_  IN     VARCHAR2,
   module_     IN     VARCHAR2,
   lu_         IN     VARCHAR2 )
IS
   objid_         company_key_lu.objid%TYPE;
   objversion_    company_key_lu.objversion%TYPE;
   attr_          VARCHAR2(2000);
   newrec_        key_lu_tab%ROWTYPE;
BEGIN
   success_ := 'FALSE';
   newrec_.key_name       := key_name_;
   newrec_.key_value      := key_value_;
   newrec_.module         := module_;
   newrec_.lu             := lu_;
   IF (Key_Master_API.Exist_Key_Master__(key_name_, key_value_) AND Module_Lu_API.Check_Exist__(module_, lu_)) THEN
      Insert___(objid_, objversion_, newrec_,  attr_);
      success_ := 'TRUE';
   END IF;
END Insert_Key_Lu___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_ VARCHAR2(2000);
BEGIN
   super(attr_);
   Key_Lu_API.New__(temp_, temp_, temp_, attr_, 'PREPARE');
END Prepare_Insert___;
               
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
BEGIN
   RETURN Company_Key_Lu_Translation_API.Get_Company_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, only_chosen_lang_);
END Get_Company_Translation__;


PROCEDURE Insert_Company_Translation__ (
   key_value_     IN VARCHAR2, 
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2,
   translation_   IN VARCHAR2 )
IS
   success_       VARCHAR2(5) := 'TRUE';
BEGIN
   IF (NOT Enterp_Comp_Connect_V170_API.Check_Exist_Module_Lu(module_, lu_)) THEN
      Enterp_Comp_Connect_V170_API.Add_Module_Detail(module_, lu_);
   END IF;
   IF (NOT Key_Master_API.Exist_Key_Master__('CompanyKeyLu', key_value_)) THEN
      Key_Master_API.Insert_Key_Master__('CompanyKeyLu', key_value_);
   END IF;
   IF (Check_Exist___('CompanyKeyLu', key_value_, module_, lu_)) THEN
      Company_Key_Lu_Attribute_API.Insert_Company_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);      
   ELSE
      Insert_Key_Lu___(success_, 'CompanyKeyLu', key_value_, module_, lu_);
      IF (success_ = 'TRUE') THEN
         Company_Key_Lu_Attribute_API.Insert_Company_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);         
      END IF;
   END IF;
END Insert_Company_Translation__;


PROCEDURE Remove_Attribute_Key__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN
   Company_Key_Lu_Attribute_API.Remove_Attribute_Key__(key_value_, module_, lu_, attribute_key_);   
END Remove_Attribute_Key__;


PROCEDURE Insert_Prog__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   success_       VARCHAR2(5) := 'TRUE';
BEGIN
   IF (NOT Enterp_Comp_Connect_V170_API.Check_Exist_Module_Lu(module_, lu_)) THEN
      Enterp_Comp_Connect_V170_API.Add_Module_Detail(module_, lu_);
   END IF;
   IF (NOT Key_Master_API.Exist_Key_Master__('CompanyKeyLu', key_value_)) THEN
      Key_Master_API.Insert_Key_Master__('CompanyKeyLu', key_value_);
   END IF;
   IF (Check_Exist___('CompanyKeyLu', key_value_, module_, lu_)) THEN
      Company_Key_Lu_Attribute_API.Insert_Prog__(key_value_, module_, lu_, attribute_key_, text_);      
   ELSE
      Insert_Key_Lu___(success_, 'CompanyKeyLu', key_value_,module_, lu_);
      IF (success_ = 'TRUE') THEN
         Company_Key_Lu_Attribute_API.Insert_Prog__(key_value_, module_, lu_, attribute_key_, text_);         
      END IF;
   END IF;
END Insert_Prog__;


PROCEDURE Insert_Translation__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2,
   translation_   IN VARCHAR2 )
IS
   exist_         BOOLEAN;
BEGIN
   exist_ := Check_Exist___('CompanyKeyLu', key_value_, module_, lu_);
   IF (exist_) THEN
      Company_Key_Lu_Translation_API.Insert_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);
   END IF;
END Insert_Translation__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Exist_Company_Lu_Trans (
   key_name_ IN VARCHAR2,
   key_value_ IN VARCHAR2,
   module_ IN VARCHAR2,
   lu_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Company_Key_Lu_Translation_API.Check_Exist_Company_Lu_Trans__(key_name_, key_value_, module_, lu_);
END Check_Exist_Company_Lu_Trans;


--This method is to be used by Aurena
FUNCTION Get_Existing_Languages (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
   languages_  VARCHAR2(2000):=NULL;
   CURSOR get_lang IS
      SELECT language_code
      FROM   company_translation_lng
      WHERE  key_name = 'CompanyKeyLu'
      AND    key_value = company_
      GROUP BY language_code;
BEGIN
   FOR c1 IN get_lang LOOP
      languages_ := languages_||c1.language_code||CHR(31);
   END LOOP;
   RETURN languages_; 
END Get_Existing_Languages;    


