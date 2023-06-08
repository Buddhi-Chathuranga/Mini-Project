-----------------------------------------------------------------------------
--
--  Logical unit: KeyLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  xxxxxx  xxxx    Created.
--  030131  ovjose  Glob08. Modifications to copy method.
--  130614  DipeLK  TIBE-726, Removed global variable which used to check the exsistance of ACCRUL component
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_From_Attr___ (
   attr_             IN     VARCHAR2,
   ptr_              IN OUT NUMBER,
   value_            IN OUT VARCHAR2,
   record_separator_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
BEGIN
   from_ := NVL(ptr_, 1);
   to_   := INSTR(attr_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := INSTR(attr_, record_separator_, from_);
      value_ := SUBSTR(attr_, from_, index_-from_);
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_From_Attr___;


PROCEDURE Update_Translations___(
   stmt_                  IN VARCHAR2,
   target_value_          IN VARCHAR2, 
   module_                IN VARCHAR2, 
   source_lu_             IN VARCHAR2,
   bind_v_count_          IN NUMBER,
   source_value_          IN VARCHAR2,
   source_key_name_       IN VARCHAR2,
   target_key_name_       IN VARCHAR2,
   source_attribute_key_  IN VARCHAR2,
   target_attribute_key_  IN VARCHAR2,
   language_codes_        IN VARCHAR2)
IS
   TYPE RecordType      IS REF CURSOR;
   get_data_            RecordType;
   newrec_              key_lu_translation_tab%ROWTYPE;
BEGIN
   IF (bind_v_count_ = 9) THEN
      @ApproveDynamicStatement(2005-11-10,ovjose)
      OPEN get_data_ FOR stmt_ USING source_key_name_, source_value_, module_, source_lu_, language_codes_, target_key_name_, target_value_, target_key_name_, target_value_;
      FETCH get_data_ INTO newrec_;
      WHILE get_data_%FOUND LOOP
         Company_Key_Lu_API.Insert_Translation__(target_value_,
                                                 module_,
                                                 source_lu_,
                                                 newrec_.attribute_key,
                                                 newrec_.language_code,
                                                 NVL(newrec_.current_translation, newrec_.installation_translation));         
         FETCH get_data_ INTO newrec_;
      END LOOP;
   ELSIF (bind_v_count_ = 10) THEN
      @ApproveDynamicStatement(2005-11-10,ovjose)
      OPEN get_data_ FOR stmt_ USING source_key_name_, source_value_, module_, source_lu_,language_codes_, target_key_name_, target_value_, target_key_name_, target_value_, target_attribute_key_;
      FETCH get_data_ INTO newrec_;
      WHILE get_data_%FOUND LOOP
         Company_Key_Lu_API.Insert_Translation__(target_value_,
                                                 module_,
                                                 source_lu_,
                                                 newrec_.attribute_key,
                                                 newrec_.language_code,
                                                 NVL(newrec_.current_translation, newrec_.installation_translation));            
         FETCH get_data_ INTO newrec_;
      END LOOP;
   ELSIF (bind_v_count_ = 11) THEN
      @ApproveDynamicStatement(2005-11-10,ovjose)
      OPEN get_data_ FOR stmt_ USING source_key_name_, source_value_, module_, source_lu_, source_attribute_key_, language_codes_, target_key_name_, target_value_, target_key_name_, target_value_, target_attribute_key_;
      FETCH get_data_ INTO newrec_;
      WHILE get_data_%FOUND LOOP
         Company_Key_Lu_API.Insert_Translation__(target_value_,
                                                 module_,
                                                 source_lu_,
                                                 newrec_.attribute_key,
                                                 newrec_.language_code,
                                                 NVL(newrec_.current_translation, newrec_.installation_translation));            
         FETCH get_data_ INTO newrec_;
      END LOOP;
   END IF;
END Update_Translations___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN key_lu_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Refresh the Imp table that holds langauges per template/company
   Key_Lu_Translation_API.Refresh_Translation_Imp__(remrec_.key_name, remrec_.key_value);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Translations__ (
   source_value_           IN VARCHAR2,
   target_value_           IN VARCHAR2,
   module_                 IN VARCHAR2,
   source_lu_              IN VARCHAR2,
   target_lu_              IN VARCHAR2,
   source_key_name_        IN VARCHAR2,
   target_key_name_        IN VARCHAR2,
   source_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   target_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   language_codes_         IN VARCHAR2 DEFAULT 'ALL',
   option_                 IN VARCHAR2 DEFAULT 'COPY' )
IS
   translation_type_    key_lu_translation_tab.ROWTYPE%TYPE;
   lang_codes_          VARCHAR2(2000);
   lang_code_           VARCHAR2(5);
   text_separator_      VARCHAR2(1) := Client_SYS.text_separator_;
   value_               VARCHAR2(2000);
   ptr_                 NUMBER;
BEGIN
   IF (language_codes_ IS NULL ) THEN      
      lang_codes_ := NULL;      
   ELSIF (language_codes_ = 'ALL') THEN
      lang_codes_ := 'ALL';
   ELSE
      lang_codes_ := language_codes_;
   END IF;
   IF (target_key_name_ = 'CompanyKeyLu') THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         Company_Finance_API.Exist(target_value_);
      $ELSE
         NULL;
      $END
      translation_type_ := 'CompanyKeyLuTranslation';
   ELSE
      translation_type_ := 'TemplKeyLuTranslation';
   END IF;
   IF (target_value_ IS NULL OR target_key_name_ IS NULL) THEN
      NULL;
   ELSIF (source_value_ IS NULL) OR (source_lu_ IS NULL) OR (module_ IS NULL) OR (target_lu_ IS NULL) THEN
      NULL;
   ELSE
      IF (option_ = 'UPDATE TRANSLATION') THEN
         Update_Translations__(source_value_,
                               target_value_,
                               module_,
                               source_lu_,
                               target_lu_,
                               source_key_name_,
                               target_key_name_,
                               source_attribute_key_,
                               target_attribute_key_,
                               language_codes_);
      ELSE
         IF (NOT Enterp_Comp_Connect_V170_API.Check_Exist_Module_Lu(module_, target_lu_)) THEN
            Enterp_Comp_Connect_V170_API.Add_Module_Detail(module_, target_lu_);
         END IF;
         -- Copy data in key_lu_tab
         INSERT
            INTO key_lu_tab (
               key_name,
               key_value,
               module,
               lu,
               rowversion,
               ROWTYPE)
            SELECT
               target_key_name_,
               target_value_,
               module_,
               target_lu_,
               SYSDATE,
               target_key_name_
            FROM key_lu_tab
            WHERE key_name = source_key_name_
            AND key_value = source_value_
            AND module = module_
            AND lu = source_lu_
            AND NOT EXISTS (SELECT 1
                            FROM key_lu_tab
                            WHERE key_name = target_key_name_
                            AND key_value = target_value_
                            AND module = module_
                            AND lu = target_lu_);
         -- Copy translations in key_lu_translation_tab
         IF (source_attribute_key_ IS NULL OR target_attribute_key_ IS NULL) THEN
            -- Copy data in key_lu_attribute_tab
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
                  target_key_name_,
                  target_value_,
                  module_,
                  target_lu_,
                  attribute_key,
                  attribute_text,
                  first_reg_text,
                  SYSDATE,
                  DECODE(target_key_name_, 'CompanyKeyLu', 'CompanyKeyLuAttribute', 'TemplKeyLuAttribute')
               FROM key_lu_attribute_tab dest
               WHERE key_name = source_key_name_
               AND key_value = source_value_
               AND module = module_
               AND lu = source_lu_
               AND NOT EXISTS (SELECT 1
                               FROM key_lu_attribute_tab src
                               WHERE src.key_name = target_key_name_
                               AND src.key_value = target_value_
                               AND src.module = module_
                               AND src.lu = target_lu_
                               AND src.attribute_key = dest.attribute_key);
            IF (lang_codes_ IS NULL) THEN
               NULL;
            ELSIF (lang_codes_ != 'ALL') THEN
               ptr_ := NULL;
               WHILE Get_Next_From_Attr___(lang_codes_, ptr_, value_, text_separator_) LOOP
                  lang_code_ := value_;
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
                        target_key_name_,
                        target_value_,
                        module_,
                        target_lu_,
                        attribute_key,
                        language_code,
                        current_translation,
                        installation_translation,
                        system_defined,
                        SYSDATE,
                        translation_type_
                     FROM key_lu_translation_tab dest
                     WHERE key_name = source_key_name_
                     AND key_value = source_value_
                     AND module = module_
                     AND lu = source_lu_
                     AND language_code = lang_code_
                     AND NOT EXISTS (SELECT 1
                                     FROM key_lu_translation_tab src
                                     WHERE src.key_name = target_key_name_
                                     AND src.key_value = target_value_
                                     AND src.module = module_
                                     AND src.lu = target_lu_
                                     AND src.attribute_key = dest.attribute_key
                                     AND src.language_code = lang_code_);
                  -- Refresh the Imp table that holds langauges per template/company
                  Key_Lu_Translation_API.Refresh_Translation_Imp__(target_key_name_, target_value_, lang_code_);
               END LOOP;
            ELSE
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
                     target_key_name_,
                     target_value_,
                     module_,
                     target_lu_,
                     attribute_key,
                     language_code,
                     current_translation,
                     installation_translation,
                     system_defined,
                     SYSDATE,
                     translation_type_
                  FROM key_lu_translation_tab dest
                  WHERE key_name = source_key_name_
                  AND key_value = source_value_
                  AND module = module_
                  AND lu = source_lu_
                  AND NOT EXISTS (SELECT 1
                                  FROM key_lu_translation_tab src
                                  WHERE src.key_name = target_key_name_
                                  AND src.key_value = target_value_
                                  AND src.module = module_
                                  AND src.lu = target_lu_
                                  AND src.attribute_key = dest.attribute_key
                                  AND src.language_code = dest.language_code);
               -- Refresh the Imp table that holds langauges per template/company
               Key_Lu_Translation_API.Refresh_Translation_Imp__(target_key_name_, target_value_);
            END IF;
         ELSE
            -- Copy data in key_lu_attribute_tab
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
                  target_key_name_,
                  target_value_,
                  module_,
                  target_lu_,
                  attribute_key,
                  attribute_text,
                  first_reg_text,
                  SYSDATE,
                  DECODE(target_key_name_, 'CompanyKeyLu', 'CompanyKeyLuAttribute', 'TemplKeyLuAttribute')
               FROM key_lu_attribute_tab dest
               WHERE key_name = source_key_name_
               AND key_value = source_value_
               AND module = module_
               AND lu = source_lu_
               AND attribute_key = source_attribute_key_
               AND NOT EXISTS (SELECT 1
                               FROM key_lu_attribute_tab src
                               WHERE src.key_name = target_key_name_
                               AND src.key_value = target_value_
                               AND src.module = module_
                               AND src.lu = target_lu_
                               AND src.attribute_key = target_attribute_key_);
            IF (lang_codes_ IS NULL) THEN
               NULL;
            ELSIF (lang_codes_ != 'ALL') THEN
               ptr_ := NULL;
               WHILE Get_Next_From_Attr___(lang_codes_, ptr_, value_, text_separator_) LOOP
                  lang_code_ := value_;
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
                        target_key_name_,
                        target_value_,
                        module_,
                        target_lu_,
                        target_attribute_key_,
                        language_code,
                        current_translation,
                        installation_translation,
                        system_defined,
                        SYSDATE,
                        translation_type_
                     FROM key_lu_translation_tab dest
                     WHERE key_name = source_key_name_
                     AND key_value = source_value_
                     AND module = module_
                     AND lu = source_lu_
                     AND attribute_key = source_attribute_key_
                     AND language_code = lang_code_
                     AND NOT EXISTS (SELECT 1
                                     FROM key_lu_translation_tab src
                                     WHERE src.key_name = target_key_name_
                                     AND src.key_value = target_value_
                                     AND src.module = module_
                                     AND src.lu = source_lu_
                                     AND src.attribute_key = target_attribute_key_
                                     AND src.language_code = lang_code_);
                  -- Refresh the Imp table that holds langauges per template/company
                  Key_Lu_Translation_API.Refresh_Translation_Imp__(target_key_name_, target_value_, lang_code_);
               END LOOP;
            ELSE
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
                     target_key_name_,
                     target_value_,
                     module_,
                     source_lu_,
                     target_attribute_key_,
                     language_code,
                     current_translation,
                     installation_translation,
                     system_defined,
                     SYSDATE,
                     translation_type_
                  FROM key_lu_translation_tab dest
                  WHERE key_name = source_key_name_
                  AND key_value = source_value_
                  AND module = module_
                  AND lu = source_lu_
                  AND attribute_key = source_attribute_key_
                  AND NOT EXISTS (SELECT 1
                                  FROM key_lu_translation_tab src
                                  WHERE src.key_name = target_key_name_
                                  AND src.key_value = target_value_
                                  AND src.module = module_
                                  AND src.lu = source_lu_
                                  AND src.attribute_key = target_attribute_key_
                                  AND src.language_code = dest.language_code);
               -- Refresh the Imp table that holds langauges per template/company
               Key_Lu_Translation_API.Refresh_Translation_Imp__(target_key_name_, target_value_);
            END IF;
         END IF;
      END IF;
   END IF;
END Copy_Translations__;


PROCEDURE Update_Translations__ (
   source_value_           IN VARCHAR2,
   target_value_           IN VARCHAR2,
   module_                 IN VARCHAR2,
   source_lu_              IN VARCHAR2,
   target_lu_              IN VARCHAR2,
   source_key_name_        IN VARCHAR2,
   target_key_name_        IN VARCHAR2,
   source_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   target_attribute_key_   IN VARCHAR2 DEFAULT NULL,
   language_codes_         IN VARCHAR2 DEFAULT 'ALL' )
IS   
   lang_codes_          VARCHAR2(2000);
   lang_code_           VARCHAR2(5);
   text_separator_      VARCHAR2(1)    := Client_SYS.text_separator_;
   value_               VARCHAR2(2000);
   ptr_                 NUMBER;
   stmt_                VARCHAR2(2000);
   stmt1_               VARCHAR2(2000);
   stmt2_               VARCHAR2(2000);
   stmt3_               VARCHAR2(2000);
   stmt4_               VARCHAR2(2000);
   stmt5_               VARCHAR2(2000);
   stmt6_               VARCHAR2(2000);
   stmt7_               VARCHAR2(2000);
   stmt8_               VARCHAR2(2000);
   stmt9_               VARCHAR2(2000);
   stmt10_              VARCHAR2(2000);
   stmt11_              VARCHAR2(2000);
   CURSOR get_source_langs IS
      SELECT language_code
      FROM   key_lu_translation_imp_tab
      WHERE  key_name = source_key_name_
      AND    key_value = source_value_;      
BEGIN
   Assert_SYS.Assert_Is_Logical_Unit(source_lu_);
   -- Set some predefined statements to be concatenated into one complete depending what should be done.
   stmt1_ := 'SELECT * ' ||
             'FROM key_lu_translation_tab t '||
             ' WHERE key_name = :source_key_name_ '||
             ' AND key_value = :source_value_ '||
             ' AND module = :module_ '||
             ' AND lu = :source_lu_ ';
   stmt2_ := ' AND language_code = ';
   stmt3_ := ' AND NOT EXISTS (SELECT 1 '||
             ' FROM key_lu_translation_tab c '||
             ' WHERE key_name = :target_key_name_ '||
             ' AND key_value = :target_value_ '||
             ' AND t.module = c.module '||
             ' AND t.lu = c.lu '||
             ' AND t.attribute_key = c.attribute_key '||
             ' AND t.language_code = c.language_code ';
   stmt4_ := ' AND t.installation_translation = c.installation_translation ';   
   stmt5_ := ' AND EXISTS (SELECT 1  '||
             ' FROM key_lu_translation_tab d '||
             ' WHERE key_name = :target_key_name_ '||
             ' AND key_value = :target_value_ '||
             ' AND t.module = d.module '||
             ' AND t.lu = d.lu ';   
   stmt6_ := ' AND EXISTS (SELECT 1  '||
             ' FROM key_lu_attribute_tab d '||
             ' WHERE key_name = :target_key_name_ '||
             ' AND key_value = :target_value_ '||
             ' AND t.module = d.module '||
             ' AND t.lu = d.lu ';      
   stmt7_ := ' AND t.attribute_key = d.attribute_key ';      
   stmt8_ := ' AND d.attribute_key = :target_attribute_key_ ';
   stmt9_ := ' AND t.language_code = d.language_code ';   
   stmt10_:= ' ) ';
   stmt11_:= ' AND attribute_key = :source_attribute_key_ ';
   IF (language_codes_ IS NULL) THEN      
      lang_codes_ := NULL;
      -- the ^ sign is used for the get_next_from_attr to work ok.
   ELSIF (language_codes_ = 'ALL') THEN
      lang_codes_ := 'ALL';
   ELSE
      lang_codes_ := language_codes_;
   END IF;
   IF (target_key_name_ = 'CompanyKeyLu') THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         Company_Finance_API.Exist(target_value_);
      $ELSE
         NULL;
      $END
   END IF;
   IF (target_value_ IS NULL OR target_key_name_ IS NULL) THEN
      NULL;
   ELSIF (source_value_ IS NULL) OR (source_lu_ IS NULL) OR (module_ IS NULL) THEN
      NULL;
   ELSE
      -- Copy rows in key_lu_tab
      INSERT
         INTO key_lu_tab (
            key_name,
            key_value,
            module,
            lu,
            rowversion,
            ROWTYPE)
         SELECT
            target_key_name_,
            target_value_,
            module_,
            source_lu_,
            SYSDATE,
            target_key_name_
         FROM key_lu_tab
         WHERE key_name = source_key_name_
         AND key_value = source_value_
         AND module = module_
         AND lu = source_lu_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_tab
                         WHERE key_name = target_key_name_
                         AND key_value = target_value_
                         AND module = module_
                         AND lu = source_lu_);
      -- Copy translations in key_lu_translation_tab
      IF (source_attribute_key_ IS NULL OR target_attribute_key_ IS NULL) THEN
         -- Copy data in key_lu_attribute_tab
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
               target_key_name_,
               target_value_,
               module_,
               target_lu_,
               attribute_key,
               attribute_text,
               first_reg_text,
               SYSDATE,
               DECODE(target_key_name_, 'CompanyKeyLu', 'CompanyKeyLuAttribute', 'TemplKeyLuAttribute')
            FROM key_lu_attribute_tab dest
            WHERE key_name = source_key_name_
            AND key_value = source_value_
            AND module = module_
            AND lu = source_lu_
            AND NOT EXISTS (SELECT 1
                            FROM key_lu_attribute_tab src
                            WHERE src.key_name = target_key_name_
                            AND src.key_value = target_value_
                            AND src.module = module_
                            AND src.lu = target_lu_
                            AND src.attribute_key = dest.attribute_key);
         
         IF (lang_codes_ IS NULL) THEN
            NULL;
         ELSIF (lang_codes_ != 'ALL') THEN
            ptr_ := NULL;
            WHILE Get_Next_From_Attr___(lang_codes_, ptr_, value_, text_separator_) LOOP
               lang_code_ := value_;
               -- for translations not in company
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ || stmt10_ || 
                        stmt6_ || stmt7_ || stmt10_;                                       
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 9, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
               -- for rows with changed translation
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ ||stmt4_ || 
                        stmt10_ || stmt5_ || stmt7_ || stmt9_ || stmt10_;                                       
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 9, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
            END LOOP;
         ELSE
            FOR l_ IN get_source_langs LOOP
               lang_code_ := l_.language_code;
               -- for translations not in company
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ || stmt10_ || 
                        stmt6_ || stmt7_ || stmt10_;               
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 9, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
               -- for rows with changed translation
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ ||stmt4_ || 
                        stmt10_ || stmt5_ || stmt7_ || stmt9_ || stmt10_;
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 9, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, language_codes_);
            END LOOP;
         END IF;
      ELSE
         -- Copy data in key_lu_attribute_tab
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
               target_key_name_,
               target_value_,
               module_,
               target_lu_,
               attribute_key,
               attribute_text,
               first_reg_text,
               SYSDATE,
               DECODE(target_key_name_, 'CompanyKeyLu', 'CompanyKeyLuAttribute', 'TemplKeyLuAttribute')
            FROM key_lu_attribute_tab dest
            WHERE key_name = source_key_name_
            AND key_value = source_value_
            AND module = module_
            AND lu = source_lu_
            AND attribute_key = source_attribute_key_
            AND NOT EXISTS (SELECT 1
                            FROM key_lu_attribute_tab src
                            WHERE src.key_name = target_key_name_
                            AND src.key_value = target_value_
                            AND src.module = module_
                            AND src.lu = target_lu_
                            AND src.attribute_key = target_attribute_key_);                                           
         
         IF (lang_codes_ IS NULL) THEN
            NULL;         
         ELSIF (lang_codes_ != 'ALL') THEN
            ptr_ := NULL;
            WHILE Get_Next_From_Attr___(lang_codes_, ptr_, value_, text_separator_) LOOP
               lang_code_ := value_;
               -- for translations not in company
               stmt_ := stmt1_ || stmt11_ || stmt2_ ||':lang_code_ ' || stmt3_ ||
                        stmt10_ || stmt6_ || stmt8_ || stmt10_;               
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 11, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
               -- for rows with changed translation
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ || stmt4_ ||
                        stmt10_ || stmt5_ || stmt7_ || stmt8_ || stmt9_ || stmt10_;               
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 10, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
            END LOOP;
         ELSE
            FOR l_ IN get_source_langs LOOP
               lang_code_ := l_.language_code;
               -- for translations not in company
               stmt_ := stmt1_ || stmt11_ || stmt2_ ||':lang_code_ ' || stmt3_ ||
                        stmt10_ || stmt6_ || stmt8_ || stmt10_;               
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 11, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
               -- for rows with changed translation
               stmt_ := stmt1_ || stmt2_ ||':lang_code_ ' || stmt3_ || stmt4_ ||
                        stmt10_ || stmt5_ || stmt7_ || stmt8_ || stmt9_ || stmt10_;               
               Update_Translations___(stmt_, target_value_, module_, source_lu_, 10, source_value_, source_key_name_,
                                      target_key_name_, source_attribute_key_, target_attribute_key_, lang_code_);
            END LOOP;
         END IF;
      END IF;
      -- Refresh the Imp table that holds langauges per template/company
      Key_Lu_Translation_API.Refresh_Translation_Imp__(target_key_name_, target_value_);
   END IF;
END Update_Translations__;
                                                                         
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


