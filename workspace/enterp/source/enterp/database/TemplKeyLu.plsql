-----------------------------------------------------------------------------
--
--  Logical unit: TemplKeyLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  0211XX  stdafi  created.
--  021203  ovjose  Glob06. Added Copy_Company_Trans_To_Templ__, Rename_Templ_Translation__
--                  and Copy_Templ_Translations__.
--  091125  Shsalk  Bug 79846, Removed length limitations for number variables. 
--  130822  Jaralk  Bug 111218 Corrected the third parameter of General_Sys.Init_Method call to method name
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Insert_Key_Lu___ (
   success_    IN OUT VARCHAR2,
   key_name_   IN VARCHAR2,
   key_value_  IN VARCHAR2,
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
   objid_         templ_key_lu.objid%TYPE;
   objversion_    templ_key_lu.objversion%TYPE;
   attr_          VARCHAR2(2000);
   newrec_        key_lu_tab%ROWTYPE;
BEGIN
   success_ := 'FALSE';
   newrec_.key_name       := key_name_;
   newrec_.key_value      := key_value_;
   newrec_.module         := module_;
   newrec_.lu             := lu_;
   IF (Key_Master_API.Exist_Key_Master__(key_name_, key_value_) AND Module_Lu_API.Check_Exist__(module_, lu_)) THEN
      Insert___(objid_, objversion_, newrec_, attr_);
      success_ := 'TRUE';
   END IF;
END Insert_Key_Lu___;


FUNCTION Get_Next_From_Attr___ (
   attr_  IN     VARCHAR2,
   ptr_   IN OUT NUMBER,
   value_ IN OUT VARCHAR2 ) RETURN BOOLEAN
IS
   from_             NUMBER;
   to_               NUMBER;
   index_            NUMBER;
   field_separator_  VARCHAR2(1)    := Client_SYS.field_separator_;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, field_separator_, from_);
   IF (to_ > 0) THEN
      index_ := INSTR(attr_, field_separator_, from_);
      value_ := SUBSTR(attr_, from_, index_ - from_);
      ptr_   := to_ + 1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   temp_     VARCHAR2(2000);
   tmp_attr_ VARCHAR2(32000);
BEGIN
   tmp_attr_ := attr_;
   super(attr_);
   attr_ := tmp_attr_;
   Key_Lu_API.New__(temp_, temp_, temp_, attr_, 'PREPARE');
END Prepare_Insert___;
                  
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Export_Company_Templates__ (
   template_ids_  IN VARCHAR2,
   module_        IN VARCHAR2 DEFAULT NULL )
IS
   id_               NUMBER := 0;
   new_id_           NUMBER := 0;
   old_lu_           VARCHAR2(30);
   path_             VARCHAR2(500);
   template_id_      VARCHAR2(30);
   ptr_              NUMBER;
   value_            VARCHAR2(2000);
   old_module_       VARCHAR2(6);
   old_template_     VARCHAR2(30);
   CURSOR get_template_data IS
      SELECT key_value template_id, attribute_key, module, lu, attribute_text
      FROM   key_lu_attribute_tab
      WHERE  key_name  = 'TemplKeyLu'
      AND    key_value = template_id_
      AND    module    = NVL(module_, module)
      AND    attribute_text IS NOT NULL      
      ORDER BY module,lu;
BEGIN
   WHILE (Get_Next_From_Attr___(template_ids_, ptr_, value_)) LOOP
      template_id_ := value_;
      id_ := 0;
      old_lu_ := NULL;
      old_module_ := NULL;
      old_template_ := NULL;
      FOR template_rec_ IN get_template_data LOOP
         path_ := template_rec_.template_id||'.'||template_rec_.lu;
         template_rec_.attribute_key := REPLACE(template_rec_.attribute_key, '^','~');
         IF (old_lu_ = template_rec_.lu) THEN
            Language_Source_Util_API.Build_Templ_Trans(id_,
                                                       template_rec_.module,
                                                       path_,
                                                       template_rec_.attribute_key,
                                                       'Company Template',
                                                       template_rec_.attribute_text);
            id_ := new_id_;
         ELSE
            id_ := 0;
            old_lu_ := template_rec_.lu;
            Language_Source_Util_API.Build_Templ_Trans(id_,
                                                       template_rec_.module,
                                                       path_,
                                                       template_rec_.attribute_key,
                                                       'Company Template',
                                                       template_rec_.attribute_text);
            new_id_ := id_;
         END IF;
         IF (old_module_ != template_rec_.module OR old_module_ IS NULL) OR (old_template_ != template_rec_.template_id OR old_template_ IS NULL) THEN
            old_module_ := template_rec_.module;
            old_template_ := template_rec_.template_id;
            Language_Source_Util_API.Register_Source(template_rec_.template_id,
                                                     NULL,
                                                     template_rec_.module,
                                                     'TEMPL',
                                                     NULL,
                                                     'B');
         END IF;
      END LOOP;
   END LOOP;
END Export_Company_Templates__;


PROCEDURE Insert_Prog__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   exist_         BOOLEAN;
   success_       VARCHAR2(5) := 'TRUE';
BEGIN
   exist_ := Check_Exist___('TemplKeyLu', key_value_, module_, lu_);
   IF (NOT exist_) THEN
      Insert_Key_Lu___(success_, 'TemplKeyLu', key_value_, module_, lu_);
   END IF;
   IF (success_ = 'TRUE') THEN
      Templ_Key_Lu_Attribute_API.Insert_Prog__(key_value_, module_, lu_, attribute_key_, text_);      
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
   exist_ := Check_Exist___('TemplKeyLu', key_value_, module_, lu_);
   IF (exist_) THEN
      Templ_Key_Lu_Translation_API.Insert_Translation__(key_value_, module_, lu_, attribute_key_, language_code_, translation_);
   END IF;
END Insert_Translation__;


PROCEDURE Remove_Attribute_Key__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN
   Templ_Key_Lu_Attribute_API.Remove_Attribute_Key__(key_value_, module_, lu_, attribute_key_);   
END Remove_Attribute_Key__;


PROCEDURE Remove_Templ_Key_Lu__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2 )
IS
BEGIN
   DELETE FROM key_lu_attribute_tab
      WHERE key_name = 'TemplKeyLu'
      AND   key_value = key_value_
      AND   module = module_;
   DELETE FROM key_lu_tab
      WHERE key_name = 'TemplKeyLu'
      AND   key_value = key_value_
      AND   module = module_
      AND   NOT EXISTS (SELECT *
                        FROM key_lu_attribute_tab
                        WHERE key_name = 'TemplKeyLu'
                        AND key_value = key_value_
                        AND module = module_);
   Key_Lu_Translation_API.Refresh_Translation_Imp__('TemplKeyLu', key_value_);
END Remove_Templ_Key_Lu__;


PROCEDURE Copy_Templ_Translations__ (
   old_template_id_     IN VARCHAR2,
   new_template_id_     IN VARCHAR2 )
IS
BEGIN
   IF (old_template_id_ = new_template_id_) THEN
      NULL;
   ELSE
      Enterp_Comp_Connect_V170_API.Template_Exist(new_template_id_);
      -- Copy translations in key_lu_tab
      INSERT
         INTO key_lu_tab (
            key_name,
            key_value,
            module,
            lu,
            rowversion,
            ROWTYPE)
         SELECT
            'TemplKeyLu',
            new_template_id_,
            module,
            lu,
            SYSDATE,
            'TemplKeyLu'
         FROM key_lu_tab src
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_tab dest
                         WHERE key_name = 'TemplKeyLu'
                         AND key_value = new_template_id_
                         AND src.module = dest.module
                         AND src.lu = dest.lu);
      -- Copy translations in key_lu_translation_tab
      INSERT
         INTO key_lu_attribute_tab (
            key_name,
            key_value,
            module,
            lu,
            attribute_key,
            attribute_text,
            first_reg_text,
            rowversion,
            ROWTYPE)
         SELECT
            'TemplKeyLu',
            new_template_id_,
            module,
            lu,
            attribute_key,
            attribute_text,
            first_reg_text,
            SYSDATE,
            'TemplKeyLuAttribute'
         FROM key_lu_attribute_tab dest
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_attribute_tab src
                         WHERE src.key_name = 'TemplKeyLu'
                         AND key_value = new_template_id_
                         AND src.module = dest.module
                         AND src.lu = dest.lu
                         AND src.attribute_key = dest.attribute_key);
      -- Copy translations in key_lu_translation_tab
      INSERT
         INTO key_lu_translation_tab (
            key_name,
            key_value,
            module,
            lu,
            attribute_key,
            language_code,
            current_translation,
            installation_translation,
            system_defined,
            rowversion,
            ROWTYPE)
         SELECT
            'TemplKeyLu',
            new_template_id_,
            module,
            lu,
            attribute_key,
            language_code,
            current_translation,
            installation_translation,
            system_defined,
            SYSDATE,
            'TemplKeyLuTranslation'
         FROM key_lu_translation_tab dest
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_translation_tab src
                         WHERE src.key_name = 'TemplKeyLu'
                         AND key_value = new_template_id_
                         AND src.module = dest.module
                         AND src.lu = dest.lu
                         AND src.attribute_key = dest.attribute_key
                         AND src.language_code = dest.language_code);
      Key_Lu_Translation_API.Refresh_Translation_Imp__('TemplKeyLu', new_template_id_);
   END IF;
END Copy_Templ_Translations__;


PROCEDURE Export_Company_Templates_Lng__ (
   template_ids_  IN VARCHAR2,
   languages_     IN VARCHAR2,
   module_        IN VARCHAR2 DEFAULT NULL )
IS
   path_             VARCHAR2(500);
   template_id_      VARCHAR2(30);
   ptr_              NUMBER;
   value_            VARCHAR2(2000);
   ptr2_             NUMBER;
   value2_           VARCHAR2(2000);
   language_         VARCHAR2(4);
   old_module_       VARCHAR2(6);
   old_template_     VARCHAR2(30);
   CURSOR get_template_data IS
      SELECT key_value template_id, attribute_key, module, lu, current_translation
      FROM   key_lu_translation_tab
      WHERE  key_name = 'TemplKeyLu'
      AND    key_value = template_id_
      AND    module    = NVL(module_, module)
      AND    language_code = language_      
      AND    current_translation IS NOT NULL
      ORDER BY module,lu;
BEGIN
   WHILE (Get_Next_From_Attr___(template_ids_, ptr_, value_)) LOOP
      template_id_ := value_;
      old_template_ := NULL;
      old_module_ := NULL;
      ptr2_ := NULL;
      WHILE (Get_Next_From_Attr___(languages_, ptr2_, value2_)) LOOP
         language_ := value2_;
         FOR template_rec_ IN get_template_data LOOP
            path_ := template_rec_.template_id||'.'||template_rec_.lu||'_'||
                     template_rec_.module||'.'||REPLACE(template_rec_.attribute_key, '^','~') ;
            Language_Source_Util_API.Load_Company_Templ_Translation(template_rec_.module,
                                                                    language_,
                                                                    path_,
                                                                    template_rec_.current_translation);
            IF (old_module_ != template_rec_.module OR old_module_ IS NULL) OR (old_template_ != template_rec_.template_id OR old_template_ IS NULL) THEN
               old_module_ := template_rec_.module;
               old_template_ := template_rec_.template_id;
               Language_Source_Util_API.Register_Source(template_rec_.template_id,
                                                        NULL,
                                                        template_rec_.module,
                                                        'TEMPT',
                                                        NULL,
                                                        'L');
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;
END Export_Company_Templates_Lng__;


PROCEDURE Init_Templ_Trans__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
   system_templ_  VARCHAR2(5) := Create_Company_Tem_API.Is_System_Template(key_value_);
BEGIN
   -- Special handling for english ('en'). This since the application is normally not translated into english since the installed texts/descriptions in 
   -- the application (in this case a system template) are already in english. But if there are translations in english (better english words, spelling etc)
   -- then those translations will be updated during refresh of languages (when Insert_Translation__ is used).
   -- TODO: Investigate an alternative where the en-lines are deleted and then after the en-translation have been inserted, which might be just a few lines
   -- since the default texts for a system template is already in english and therefore it probably is just a few lines that is translated to english,
   -- en-lines are created from the attribute first_reg_text in templ_key_lu_attribute.
   IF (language_code_ = 'en' AND system_templ_ = 'TRUE') THEN      
      NULL;
   ELSE      
      DELETE FROM key_lu_translation_tab
         WHERE key_name = 'TemplKeyLu'
         AND key_value = key_value_
         AND module = module_
         AND language_code = language_code_
         AND system_defined = 'TRUE';
   END IF;
END Init_Templ_Trans__;


PROCEDURE Refresh_Templ_Trans__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN   
   DELETE FROM key_lu_translation_tab src
      WHERE key_name = 'TemplKeyLu'
      AND key_value = key_value_
      AND module = module_
      AND language_code = language_code_
      AND NOT EXISTS (SELECT 1
                      FROM key_lu_attribute_tab dest
                      WHERE key_name = 'TemplKeyLu'
                      AND key_value = key_value_
                      AND module = module_
                      AND src.lu = dest.lu
                      AND src.attribute_key = dest.attribute_key);                                            
   Key_Lu_Translation_API.Refresh_Translation_Imp__('TemplKeyLu', key_value_, language_code_);
END Refresh_Templ_Trans__;


PROCEDURE Rename_Templ_Translation__ (
   old_template_id_ IN VARCHAR2,
   new_template_id_ IN VARCHAR2 )
IS
BEGIN
   IF (old_template_id_ = new_template_id_) THEN
      NULL;
   ELSE
      Enterp_Comp_Connect_V170_API.Template_Exist(new_template_id_);
      UPDATE key_master_tab
         SET key_value = new_template_id_
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_;
      UPDATE key_lu_tab
         SET key_value = new_template_id_
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_;
      UPDATE key_lu_translation_tab
         SET key_value = new_template_id_
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_;         
      UPDATE key_lu_attribute_tab
         SET key_value = new_template_id_
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_;         
      -- Update the imp table
      UPDATE key_lu_translation_imp_tab
         SET key_value = new_template_id_
         WHERE key_name = 'TemplKeyLu'
         AND key_value = old_template_id_;
   END IF;
END Rename_Templ_Translation__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Translations (
   template_id_ IN VARCHAR2,
   module_      IN VARCHAR2,
   lu_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM   key_lu_tab
      WHERE  key_name  = 'TemplKeyLu'
      AND    key_value = template_id_
      AND    module    = NVL(module_,module)
      AND    lu        = NVL(lu_,lu);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Translations;



