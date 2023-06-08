-----------------------------------------------------------------------------
--
--  Logical unit: LanguageSysImp
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160107  UTGULK  Created.(Bug62335)
--  120707  UTGULK  Modified Insert_Into_Imp_Tab_ to update use_translation flag for existing data.(Bug66606
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Translations_Exist___ (
   module_ IN VARCHAR2,
   lu_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   path_  VARCHAR2(100) := lu_ || '_' || module_ || '%';
   CURSOR check_exist IS
      SELECT 1
      FROM basic_data_translation
      WHERE module = module_
      AND path like path_
      AND lang_code != 'PROG';
   dummy_  NUMBER;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_ ;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      RETURN 'TRUE';
   END IF;
   CLOSE check_exist;
   RETURN 'FALSE';
END Translations_Exist___;


FUNCTION Reset_Use_Trans_Edited___ (
   module_                 IN VARCHAR2,
   lu_                     IN VARCHAR2,
   use_translation_        IN VARCHAR2 DEFAULT NULL,
   use_translation_edited_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   rec_ LANGUAGE_SYS_IMP_TAB%ROWTYPE;
   use_trans_        VARCHAR2(5):='FALSE';
   use_trans_edited_ VARCHAR2(5):='TRUE';
BEGIN
   IF ( use_translation_ IS NULL OR use_translation_edited_ IS NULL ) THEN
      rec_ := Get_Object_By_Keys___(module_ , lu_);
   END IF;
   use_trans_ := nvl(use_translation_, rec_.use_translation);
   use_trans_edited_ := nvl(use_translation_edited_, rec_.use_translation_edited);
   IF (use_trans_edited_ ='TRUE' ) THEN
      -- check whether use_translation has the default value i.e. TRUE if translations exist False otherwise.
      IF Translations_Exist___(module_ , lu_)='TRUE' THEN
         IF use_trans_ ='TRUE' THEN
            RETURN 'TRUE';
         END IF;
      ELSE
         IF use_trans_ ='FALSE' THEN
            RETURN 'TRUE';
         END IF;
      END IF;
   END IF;
   RETURN 'FALSE';
END Reset_Use_Trans_Edited___;


PROCEDURE Insert_Into_Imp_Tab___ (
   rec_ IN LANGUAGE_SYS_IMP_TAB%ROWTYPE )
IS
BEGIN
   INSERT INTO language_sys_imp_tab(
        module,
        lu,
        type,
        use_translation,
        show_prog_language,
        use_translation_edited,
        rowversion)
      VALUES(
         rec_.module,
         rec_.lu,
         rec_.type,
         rec_.use_translation,
         rec_.show_prog_language,
         rec_.use_translation_edited,
         SYSDATE);
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Insert_Into_Imp_Tab___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     LANGUAGE_SYS_IMP_TAB%ROWTYPE,
   newrec_     IN OUT LANGUAGE_SYS_IMP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF oldrec_.use_translation <> newrec_.use_translation THEN
      newrec_.use_translation_edited := 'TRUE';
      IF (Reset_Use_Trans_Edited___(newrec_.module, newrec_.lu, newrec_.use_translation,'TRUE') ='TRUE' ) THEN
         --reset value since the defalut value is used
         newrec_.use_translation_edited :='FALSE';
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Cleanup_Basic_Data_ (
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
   upper_module_    VARCHAR2(10) := Upper(module_);
   lower_lng_       VARCHAR2(5) := Lower(language_code_);
   CURSOR get_info IS
      SELECT module,lu
      FROM basic_data_translation b
      WHERE module = upper_module_
      AND NOT EXISTS (SELECT 1 FROM language_sys_imp_tab l
      WHERE l.module = b.module
      AND l.lu = b.lu)
      GROUP BY module, lu;
   newrec_ LANGUAGE_SYS_IMP_TAB%ROWTYPE;
BEGIN
   -- Only delete what needs to be deleted
   DELETE FROM language_sys_imp_tab i
      WHERE module = upper_module_
      AND show_prog_language = 'TRUE'             -- default value unchanged
      AND use_translation_edited = 'FALSE'       -- default value unchanged
      AND NOT EXISTS (SELECT 1 FROM basic_data_translation l
      WHERE l.module = i.module
      AND l.lu = i.lu
      AND l.lang_code = lower_lng_);

   FOR rec_ IN get_info LOOP
      newrec_.module:= rec_.module;
      newrec_.lu:= rec_.lu;
      newrec_.type:= 'Basic Data';
      newrec_.use_translation := 'FALSE';
      newrec_.show_prog_language:= 'TRUE';
      newrec_.use_translation_edited := 'FALSE';

     IF Translations_Exist___(rec_.module, rec_.lu)='TRUE' THEN
        newrec_.use_translation := 'TRUE';
     END IF;

     BEGIN
        Insert_Into_Imp_Tab___(newrec_);
     EXCEPTION
        WHEN OTHERS THEN
           NULL;
     END;
   END LOOP;
END Cleanup_Basic_Data_;


PROCEDURE Remove_From_Imp_Tab_ (
   module_ IN VARCHAR2,
   lu_     IN VARCHAR2 )
IS
   CURSOR check_ IS
      SELECT 1
      FROM basic_data_translation
      WHERE main_type = 'LU'
      AND type = 'Basic Data'
      AND path LIKE lu_ || '_' || module_ || '.%'
      AND attribute = 'Text';
   dummy_         NUMBER;
BEGIN
   OPEN check_;
   FETCH check_ INTO dummy_;
   IF check_%NOTFOUND THEN
      DELETE FROM language_sys_imp_tab
         WHERE module = module_
         AND lu = lu_
         AND type = 'Basic Data';
   END IF;
   CLOSE check_;
END Remove_From_Imp_Tab_;


PROCEDURE Insert_Into_Imp_Tab_ (
   module_ IN VARCHAR2,
   lu_     IN VARCHAR2 )
IS
   newrec_ LANGUAGE_SYS_IMP_TAB%ROWTYPE;
BEGIN
   IF Check_Exist___(module_ , lu_) THEN
      IF (Reset_Use_Trans_Edited___(module_ , lu_) ='TRUE' ) THEN
         --reset value since the defalut value is used
         UPDATE language_sys_imp_tab
            SET use_translation_edited ='FALSE'
            WHERE module = module_
            AND   lu = lu_;
      END IF;
      newrec_ := Get_Object_By_Keys___(module_ , lu_);
      IF newrec_.use_translation = 'FALSE' AND newrec_.use_translation_edited = 'FALSE' THEN
         IF Translations_Exist___(module_, lu_)='TRUE' THEN
            UPDATE language_sys_imp_tab
               SET use_translation ='TRUE'
               WHERE module = module_
               AND   lu = lu_;
         END IF;
      END IF;
   ELSE
      newrec_.module:= module_;
      newrec_.lu:= lu_;
      newrec_.type:= 'Basic Data';
      newrec_.use_translation := 'FALSE';
      newrec_.show_prog_language:= 'TRUE';
      newrec_.use_translation_edited := 'FALSE';
      IF Translations_Exist___(module_, lu_)='TRUE' THEN
         newrec_.use_translation := 'TRUE';
      END IF;
      BEGIN
         Insert_Into_Imp_Tab___(newrec_);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Insert_Into_Imp_Tab_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Use_Translation (
   module_          IN VARCHAR2,
   lu_              IN VARCHAR2,
   use_translation_ IN VARCHAR2 )
IS
   oldrec_      LANGUAGE_SYS_IMP_TAB%ROWTYPE;
   newrec_      LANGUAGE_SYS_IMP_TAB%ROWTYPE;
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(30);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('USE_TRANSLATION_DB', use_translation_, attr_);
   oldrec_ := Lock_By_Keys___(module_, lu_);
   newrec_ := oldrec_;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);  
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Use_Translation;


PROCEDURE Set_Show_Prog_Language (
   module_    IN VARCHAR2,
   lu_        IN VARCHAR2,
   show_prog_ IN VARCHAR2 )
IS
   oldrec_      LANGUAGE_SYS_IMP_TAB%ROWTYPE;
   newrec_      LANGUAGE_SYS_IMP_TAB%ROWTYPE;
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(30);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('SHOW_PROG_LANGUAGE_DB', show_prog_, attr_);
   oldrec_ := Lock_By_Keys___(module_, lu_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);  
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Show_Prog_Language;



