-----------------------------------------------------------------------------
--
--  Logical unit: TemplKeyLuTranslation
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021105  stdafi  Created
--  040722  anpelk  FIPR338 Added view TEMPL_KEY_LU_TRANSLATION_EXP to support unicod
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_      VARCHAR2(2000);
   temp_attr_ VARCHAR2(32000);
BEGIN
   temp_attr_ := attr_;
   super(attr_);
   attr_ := temp_attr_;
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
      newrec_.system_defined:= 'TRUE';
   ELSE
      newrec_.system_defined:= 'FALSE';
   END IF;   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED', newrec_.system_defined, attr_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN key_lu_translation_tab%ROWTYPE )
IS   
BEGIN
   -- Check that the user is allowed to change the template
   IF (Create_Company_Tem_API.Change_Template_Allowed(remrec_.key_value) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove translations on a template that is created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
   super(remrec_);
END Check_Delete___;


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
   IF (NOT Templ_Key_Lu_Attribute_API.Exists(newrec_.key_name, newrec_.key_value, newrec_.module, newrec_.lu, newrec_.attribute_key)) THEN   
      Error_SYS.Appl_General(lu_name_, 'NOPROGATTR: Attribute :P1 does not exist for module :P2 and Logial Unit :P3 for specified Template.', newrec_.attribute_key, newrec_.module, newrec_.lu );
   END IF;   
   super(newrec_, indrec_, attr_);
   -- Check that the user is allowed to change the template
   IF (Create_Company_Tem_API.Change_Template_Allowed(newrec_.key_value) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'INSNOTALLOWED: Not allowed to insert translations on a template that is created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     key_lu_translation_tab%ROWTYPE,
   newrec_ IN OUT key_lu_translation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   -- Check that the user is allowed to change the template
   IF (Create_Company_Tem_API.Change_Template_Allowed(newrec_.key_value) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'MODNOTALLOWED: Not allowed to change translations on a template that is created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


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

PROCEDURE Insert_Translation__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2,
   translation_   IN VARCHAR2 )
IS
   objid_         templ_key_lu_translation.objid%TYPE;
   objversion_    templ_key_lu_translation.objversion%TYPE;
   attr_          VARCHAR2(2000);
   oldrec_        key_lu_translation_tab%ROWTYPE;
   newrec_        key_lu_translation_tab%ROWTYPE;
   exist_         BOOLEAN;
BEGIN   
   exist_ := Templ_Key_Lu_Attribute_API.Exists('TemplKeyLu', key_value_, module_, lu_, attribute_key_);   
   IF (exist_) THEN
      oldrec_ := Get_Object_By_Keys___('TemplKeyLu', key_value_, module_, lu_, attribute_key_, language_code_);
      IF (oldrec_.key_name IS NOT NULL) THEN
         newrec_ := oldrec_;
         IF NVL(oldrec_.current_translation, CHR(0)) = NVL(oldrec_.installation_translation, CHR(0)) THEN
            newrec_.current_translation := RTRIM(translation_);
         END IF;
         newrec_.installation_translation := RTRIM(translation_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      ELSE
         newrec_.key_name                 := 'TemplKeyLu';
         newrec_.key_value                := key_value_;
         newrec_.module                   := module_;
         newrec_.lu                       := lu_;
         newrec_.attribute_key            := attribute_key_;
         newrec_.language_code            := NVL(language_code_, Fnd_Session_API.Get_Language);
         newrec_.current_translation      := RTRIM(translation_);
         newrec_.installation_translation := RTRIM(translation_);
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
 

@UncheckedAccess
FUNCTION Get_Template_Translation__ (
   key_value_           IN VARCHAR2,
   module_              IN VARCHAR2,
   lu_                  IN VARCHAR2,
   attribute_key_       IN VARCHAR2,
   language_code_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS      
   lang_code_           key_lu_translation_tab.language_code%TYPE;
   rec_                 key_lu_translation_tab%ROWTYPE;
BEGIN
   Set_Language_Code___(lang_code_, language_code_);
   rec_ := Get_Object_By_Keys___('TemplKeyLu', key_value_, module_, lu_, attribute_key_, lang_code_);
   RETURN rec_.current_translation;
END Get_Template_Translation__;
                                                                  
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


