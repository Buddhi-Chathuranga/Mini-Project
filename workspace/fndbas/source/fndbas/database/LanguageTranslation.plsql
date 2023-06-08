-----------------------------------------------------------------------------
--
--  Logical unit: LanguageTranslation
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000912  RaKu    Bug#17429. Replaced Exists-checks with a cursor in Refresh_.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040419  STDA    Added call to Database_SYS.Unistr to support unicode (F1PR408B).
--  050418  STDA    Added status_db value in insert/update procedure (F1PR480).
--  050914  STDA    Added term_usage_version_id to view language_translation_exp (F1PR480).
--  051201  STDA    Added view language_translation_loc for new localize form.
--  060217  STDA    Updated to template 2.3
--  061120  BJSA    Performance optimized view LANGUAGE_TRANSLATION_LOC (F1PR486)
--  070125  STDA    Added filter for RWC in view language_translation_loc (BUG#61395).
--  070831  LALI    Added new main type BI handling in view language_translation_loc(BUG#69111).
--  090331  JOWISE  Added functionality for Copying Translations from SO to RWC
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  110601  TOBESE  Enhancements in Term application of Copy Translation algorithm for APF (Bug#97390).
--  120224  JOWISE  Added new main type MT in view language_translation_loc
--  120227  JOWISE  Added possibility to run copy translations with on spec langauge
-----------------------------------------------------------------------------

layer Core;

@ApproveGlobalVariable
client_layout_name_    VARCHAR2(128);
-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT language_translation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   
   IF (newrec_.long_status IS NULL) THEN
      newrec_.long_status := 'O';
   END IF;
   IF (newrec_.status IS NULL) THEN
      newrec_.status := 'O';
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;



@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT LANGUAGE_TRANSLATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.last_update := sysdate;
   newrec_.updated_by  := Fnd_Session_API.Get_Fnd_User();
   super(objid_, objversion_, newrec_, attr_);
   --Client_SYS.Add_To_Attr( 'LAST_UPDATE', newrec_.rowversion, attr_ );  
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     LANGUAGE_TRANSLATION_TAB%ROWTYPE,
   newrec_     IN OUT LANGUAGE_TRANSLATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   $IF Component_Fnddev_SYS.INSTALLED $THEN
      CURSOR get_text IS
         select * from language_text_translation
         where lang_code = oldrec_.lang_code
         and attribute_id = oldrec_.attribute_id;
   $END
BEGIN
   newrec_.last_update := sysdate;   
   newrec_.updated_by  := Fnd_Session_API.Get_Fnd_User();
   IF newrec_.reject_status = 'REJECTED' THEN
      IF trim(newrec_.reject_information) IS NULL  THEN 
         Error_SYS.Appl_General(lu_name_, 'NOREJECTINFO: Reject Information can not be empty.');
      ELSE
         $IF Component_Fnddev_SYS.INSTALLED $THEN 
            FOR text_rec_ IN get_Text LOOP       
               Xliff_Import_Logs_API.Xliff_Import_Log_Text('TEXT', 
                                                            oldrec_.lang_code, 
                                                            text_rec_.path, 
                                                            text_rec_.module, 
                                                            text_rec_.prog_text,
                                                            newrec_.text,
                                                            oldrec_.text,
                                                            text_rec_.name,
                                                            text_rec_.main_type,
                                                            text_rec_.sub_type,
                                                            oldrec_.status,
                                                            newrec_.reject_information,
                                                            text_rec_.layer);
            END LOOP;
         $ELSE 
            NULL;
         $END
      END IF;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --Client_SYS.Add_To_Attr( 'LAST_UPDATE', newrec_.rowversion, attr_ );  
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get_Text__ (
   text_         OUT VARCHAR2,
   attribute_id_ IN  NUMBER,
   lang_code_    IN  VARCHAR2 )
IS
BEGIN
   text_ := Get_Text( attribute_id_, lang_code_ );
END Get_Text__;


@UncheckedAccess
PROCEDURE Get_Text_And_Status__ (
   text_         OUT VARCHAR2,
   status_       OUT VARCHAR2,
   attribute_id_ IN  NUMBER,
   lang_code_    IN  VARCHAR2 )
IS
   CURSOR get_text IS
      SELECT text, status
      FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_
      AND lang_code = lang_code_;
BEGIN
   OPEN get_text;
   FETCH get_text INTO text_, status_;
   CLOSE get_text;
END Get_Text_And_Status__;


@UncheckedAccess
FUNCTION Str_Compare__ (
   search_for_ IN VARCHAR2,
   search_in_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF instr( search_in_, search_for_ ) > 0 THEN
      RETURN 'Y';
   ELSE
      RETURN NULL;
   END IF;
END Str_Compare__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Objid_ (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000);
      CURSOR get_attr IS
      SELECT rowid
      FROM   LANGUAGE_TRANSLATION_TAB
      WHERE  attribute_id = attribute_id_
      AND    lang_code = lang_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objid_;


@UncheckedAccess
FUNCTION Get_Objversion_ (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000);
   CURSOR get_attr IS
      SELECT TO_CHAR(rowversion,'YYYYMMDDHH24MISS')
      FROM  LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_
      AND   lang_code = lang_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objversion_;


PROCEDURE Make_Changed_ (
   attribute_id_ IN NUMBER )
IS
BEGIN
   UPDATE LANGUAGE_TRANSLATION_TAB
      SET status = 'C', reject_status = NULL, reject_information = NULL
      WHERE attribute_id = attribute_id_;
   -- Remove english translation if prog text changed, prog text will be used (as fallback) 
   Remove_Attribute_Language_(attribute_id_,'en');
END Make_Changed_;

PROCEDURE Set_Status_To_Changed_ (
   attribute_id_ IN NUMBER )
IS
BEGIN
   UPDATE LANGUAGE_TRANSLATION_TAB
      SET status = 'C'
      WHERE attribute_id = attribute_id_;
END Set_Status_To_Changed_;

PROCEDURE Make_Usage_Changed_ (
   attribute_id_ IN NUMBER)
IS
BEGIN
   UPDATE language_translation_tab
      SET long_status = 
         (CASE 
            WHEN long_text IS NOT NULL 
               THEN 'C'
            ELSE
               'N'
         END)    
    WHERE attribute_id = attribute_id_;
END Make_Usage_Changed_;


PROCEDURE Remove_Attribute_ (
   attribute_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_;
END Remove_Attribute_;


PROCEDURE Remove_Attribute_Language_ (
   attribute_id_ IN NUMBER,
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_ 
      AND   lang_code = lang_code_;
END Remove_Attribute_Language_;

PROCEDURE Refresh_ (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,   
   text_         IN VARCHAR2,
   status_       IN VARCHAR2,
   a_text_prog_  IN VARCHAR2 DEFAULT NULL)
IS
   objid_               ROWID;
   CURSOR translation IS
      SELECT rowid
      FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_
      AND lang_code = lang_code_;

   dummy_ NUMBER;
   layout_name_   VARCHAR2(128);

   CURSOR exist_control IS
      SELECT 1
      FROM   language_attribute_tab
      WHERE  attribute_id = attribute_id_
      AND EXISTS (SELECT 1
                  FROM   language_code_tab
                  WHERE  lang_code = lang_code_);

   CURSOR get_client_layout_name IS
      SELECT substr(lc.path, 1,instr(lc.path, '.')-1) AS layout_name
      FROM language_context_tab lc
      INNER JOIN language_attribute_tab la
      ON lc.context_id = la.context_id
      AND la.attribute_id = attribute_id_;

   text_unicode_      LANGUAGE_TRANSLATION_TAB.text%TYPE := Database_Sys.Unistr(text_);   
   a_prog_            LANGUAGE_ATTRIBUTE_TAB.prog_text%TYPE;
   a_source_prog_     LANGUAGE_ATTRIBUTE_TAB.prog_text%TYPE;

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);
   a_prog_ := Language_Attribute_API.Get_Prog_Text(attribute_id_);
   
   a_source_prog_ := NVL(a_text_prog_,a_prog_);
   
   -- The previous prog text and actual prog text will be analyzed, space ignored. If differ, the record will not be inserted, outdated.
   IF (lang_code_ = 'en' AND replace(a_prog_,' ','') != replace(a_source_prog_,' ','')) THEN
      RETURN;
   END IF;
   OPEN translation;
   FETCH translation INTO objid_;
   IF translation%FOUND THEN
      CLOSE translation;
      -- The previous prog text and actual prog text will be analyzed, space ignored. If differ, status will be C (Changed)
      UPDATE LANGUAGE_TRANSLATION_TAB
      SET text = text_unicode_, 
          diff_text = NULL,
          status = decode(replace(a_prog_,' ',''), replace(a_source_prog_,' ',''), status_, 'C'),
          last_update = SYSDATE,
          updated_by = Fnd_Session_API.Get_Fnd_User(),
          rowversion = SYSDATE                
      WHERE rowid = objid_;
   ELSE
      CLOSE translation;
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         INSERT INTO LANGUAGE_TRANSLATION_TAB
               (attribute_id, lang_code, text, status, long_status, last_update, updated_by, rowversion)
            VALUES
               (attribute_id_, lang_code_, text_unicode_, 'O', 'O', SYSDATE, Fnd_Session_API.Get_Fnd_User(), SYSDATE);
      ELSE
         CLOSE exist_control;
      END IF;
   END IF;
   
   OPEN get_client_layout_name;
   FETCH get_client_layout_name INTO layout_name_;
   CLOSE get_client_layout_name;   
   
   IF client_layout_name_ IS NULL OR client_layout_name_ != layout_name_ THEN
      Model_Design_SYS.Refresh_Client_Version(layout_name_);
      client_layout_name_ := layout_name_;
   END IF;
END Refresh_;

PROCEDURE Refresh_Usage_ (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,
   long_text_    IN VARCHAR2,
   status_       IN VARCHAR2 DEFAULT 'O')
IS
   objid_               ROWID;
   CURSOR translation IS
      SELECT rowid
      FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_
      AND lang_code = lang_code_;

   dummy_ NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   language_attribute_tab
      WHERE  attribute_id = attribute_id_
      AND EXISTS (SELECT 1
                  FROM   language_code_tab
                  WHERE  lang_code = lang_code_);
--

   long_text_unicode_ VARCHAR2(32000) := Database_Sys.Unistr(long_text_);

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);
   OPEN translation;
   FETCH translation INTO objid_;
   IF translation%FOUND THEN
      CLOSE translation;
      -- Even if import of lng has set the status of long_text to changed, the import (refresh_) will
      -- set the statues to Ok, the data in trs files will be considered as Ok.
      UPDATE LANGUAGE_TRANSLATION_TAB
      SET long_text = long_text_unicode_, 
          long_status = status_,          
          last_update = SYSDATE,
          rowversion = SYSDATE                
      WHERE rowid = objid_;
   ELSE
      CLOSE translation;
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         INSERT INTO LANGUAGE_TRANSLATION_TAB
               (attribute_id, lang_code, status, long_text, long_status, last_update, rowversion)
            VALUES
               (attribute_id_, lang_code_, 'N', long_text_unicode_, 'O', SYSDATE, SYSDATE);
      ELSE
         CLOSE exist_control;
      END IF;
   END IF;
END Refresh_Usage_;

-- Apply_Diff_
--   Applies the diff text. This means that the current text is updated to the diff text.
PROCEDURE Apply_Diff_ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2 )
IS
   newrec_ LANGUAGE_TRANSLATION_TAB%ROWTYPE;
   dummy_  LANGUAGE_TRANSLATION_TAB%ROWTYPE;
BEGIN
   
   dummy_ := Lock_By_Id___(objid_, objversion_);   
   newrec_.rowversion := sysdate;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   Client_SYS.Clear_Attr( attr_ );

   UPDATE LANGUAGE_TRANSLATION_TAB 
   SET    text = diff_text, 
          diff_text = NULL, 
          rowversion = newrec_.rowversion
   WHERE rowid = objid_;

   Client_SYS.Add_To_Attr( 'LAST_UPDATE', sysdate, attr_ );
   info_ := Client_SYS.Get_All_Info;
END Apply_Diff_;


PROCEDURE Copy_Text_Translations_ (
   so_attribute_id_ IN NUMBER,
   rwc_attribute_id_ IN NUMBER,
   remove_old_ IN NUMBER,
   language_ IN VARCHAR2 DEFAULT NULL)
IS
   info_ VARCHAR2(2000);
   rwc_text_ LANGUAGE_TRANSLATION_TAB.TEXT%TYPE;
   language_code_ VARCHAR2(100);
   
   CURSOR get_so IS
      SELECT lang_code, REPLACE(text, '\''', '''') AS text 
      FROM LANGUAGE_TRANSLATION_TAB 
      WHERE attribute_id = so_attribute_id_
      AND lang_code LIKE language_code_;

   CURSOR get_rwc(lang_code_ VARCHAR2) IS 
      SELECT text 
      FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = rwc_attribute_id_
      AND lang_code = lang_code_;
BEGIN
   
   IF language_ IS NULL THEN
      language_code_ := '%';
   ELSE
      language_code_ := language_;
   END IF;

      
   FOR get_rec_ IN get_so LOOP
      OPEN get_rwc(get_rec_.lang_code);
      FETCH get_rwc INTO rwc_text_;
      IF get_rwc%FOUND THEN
         dbms_output.put_line('      Existing translation: ' || rwc_text_);
      ELSE
         dbms_output.put_line('      Importing: ' || get_rec_.lang_code || '-' || get_rec_.text);
         Import(info_, rwc_attribute_id_, get_rec_.lang_code,get_rec_.text);
      END IF;
      CLOSE get_rwc;
     
      IF (remove_old_ = 1) THEN
         Remove_Attribute_Language_(so_attribute_id_, get_rec_.lang_code);
      END IF;
   END LOOP;

END Copy_Text_Translations_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import (
   info_         IN OUT VARCHAR2,
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,
   text_         IN VARCHAR2)
IS
BEGIN
   refresh_(attribute_id_, lang_code_,text_, 'O');
EXCEPTION
   WHEN others THEN
      info_ := SQLERRM(SQLCODE);
END Import;

PROCEDURE Write_Xliff_Text_Translations (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,
   text_         IN VARCHAR2,
   status_       IN VARCHAR2)
IS
   objid_        ROWID;
   CURSOR exist_control IS
      SELECT objid
      FROM   LANGUAGE_TRANSLATION
      WHERE  attribute_id = attribute_id_
      AND lang_code = lang_code_;

   text_unicode_ LANGUAGE_TRANSLATION_TAB.text%TYPE := Database_Sys.Unistr(text_);

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);
   Error_SYS.Check_Not_Null(lu_name_, 'STATUS', status_);
   
   OPEN exist_control;
   FETCH exist_control INTO objid_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      UPDATE LANGUAGE_TRANSLATION_TAB
               SET text = text_unicode_, diff_text = NULL, status = status_, rowversion = SYSDATE, last_update = SYSDATE
               WHERE rowid = objid_
               AND lang_code = lang_code_
               AND attribute_id = attribute_id_;
   ELSE
      INSERT INTO LANGUAGE_TRANSLATION_TAB
         (attribute_id, lang_code, text, status,long_status,last_update, reject_status, reject_information, case_id, rowversion)
         VALUES
         (attribute_id_, lang_code_, text_unicode_, status_,'N', SYSDATE, NULL, NULL, NULL, SYSDATE);
      CLOSE exist_control;
   END IF;
END Write_Xliff_Text_Translations;

PROCEDURE Write_Xliff_Long_Text_Trans (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,
   long_text_    IN VARCHAR2,
   status_       IN VARCHAR2)
IS
   objid_        ROWID;
   CURSOR exist_control IS
      SELECT objid
      FROM   LANGUAGE_TRANSLATION
      WHERE  attribute_id = attribute_id_
      AND lang_code = lang_code_;

   long_text_unicode_ LANGUAGE_TRANSLATION_TAB.long_text%TYPE := Database_Sys.Unistr(long_text_);

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);
   Error_SYS.Check_Not_Null(lu_name_, 'STATUS', status_);
   
   OPEN exist_control;
   FETCH exist_control INTO objid_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      UPDATE LANGUAGE_TRANSLATION_TAB
               SET long_text = long_text_unicode_, diff_text = NULL, status = status_, rowversion = SYSDATE, last_update = SYSDATE
               WHERE rowid = objid_
               AND lang_code = lang_code_
               AND attribute_id = attribute_id_;
   ELSE
      INSERT INTO LANGUAGE_TRANSLATION_TAB
         (attribute_id, lang_code, text, status, last_update, reject_status, reject_information, case_id, rowversion)
         VALUES
         (attribute_id_, lang_code_, long_text_unicode_, status_, SYSDATE, NULL, NULL, NULL, SYSDATE);
      CLOSE exist_control;
   END IF;
END Write_Xliff_Long_Text_Trans;


PROCEDURE Remove_Rejection (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET reject_status = NULL, reject_information = NULL, case_id = NULL
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Remove_Rejection;

PROCEDURE Remove_Long_Text_Rejection (
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET long_reject_status = NULL, long_reject_information = NULL, long_case_id = NULL
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Remove_Long_Text_Rejection;

PROCEDURE Add_Rejection (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   reject_information_ IN VARCHAR2,
   case_id_            IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET reject_status = 'REJECTED', reject_information = reject_information_, case_id = case_id_
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Add_Rejection;

PROCEDURE Add_Long_Text_Rejection (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   reject_information_ IN VARCHAR2,
   case_id_            IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET long_reject_status = 'REJECTED', long_reject_information = reject_information_, long_case_id = case_id_
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Add_Long_Text_Rejection;

PROCEDURE Change_Long_Text_Status (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   status_             IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET long_status = status_
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Change_Long_Text_Status;

PROCEDURE Change_Text_Status (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   status_             IN VARCHAR2)
IS

BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);

   UPDATE LANGUAGE_TRANSLATION_TAB
               SET status = status_
               WHERE lang_code = lang_code_
               AND attribute_id = attribute_id_;
END Change_Text_Status;

PROCEDURE Add_Export_Rejections (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_status = 'REJECTED'
   and lc.sub_type <> 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_export = 'EXPORTED'
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Add_Export_Rejections;

PROCEDURE Add_Export_Rej_Comp_Templ (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_status = 'REJECTED'
   and lc.sub_type = 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_export = 'EXPORTED'
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Add_Export_Rej_Comp_Templ;

PROCEDURE Reset_Export_Flag (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_export = 'EXPORTED'
   and lc.sub_type <> 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_export = null
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Reset_Export_Flag;

PROCEDURE Reset_Export_Rej_Comp_Templ (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_export = 'EXPORTED'
   and lc.sub_type = 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_export = null
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Reset_Export_Rej_Comp_Templ;

PROCEDURE Remove_Rejections (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_status = 'REJECTED'
   AND lt.reject_export = 'EXPORTED'
   and lc.sub_type <> 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_status = NULL, 
       reject_information = NULL, 
       case_id = NULL,
       reject_export = null
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Remove_Rejections;

PROCEDURE Remove_Rejections_Comp_Templ (
   lang_code_    IN VARCHAR2)
IS
cursor get_text_not_ct is
   select lc.sub_type, la.attribute_id, lt.lang_code 
   from language_context_tab lc, language_attribute_tab la, language_translation_tab lt
   where lt.reject_status = 'REJECTED'
   AND lt.reject_export = 'EXPORTED'
   and lc.sub_type = 'Company Template'
   and lc.context_id = la.attribute_id
   and la.attribute_id = lt.attribute_id
   AND lt.lang_code = lang_code_;
   
BEGIN
   for rec_ in get_text_not_ct loop
       UPDATE LANGUAGE_TRANSLATION_TAB
       SET reject_status = NULL, 
       reject_information = NULL, 
       case_id = NULL,
       reject_export = null
       WHERE lang_code = rec_.lang_code
       AND attribute_id =rec_.attribute_id;
  end loop;
END Remove_Rejections_Comp_Templ;

PROCEDURE Remove_Trans_Review_Prefix (
   lang_code_    IN VARCHAR2)
IS
   cursor get_text is
       select text, substr(text,3) new_text, attribute_id, lang_code  
       from language_translation_tab 
       where text like '*>%';
BEGIN
  for rec_text_ in get_text loop
       update language_translation_tab 
       set text = rec_text_.new_text
       where attribute_id = rec_text_.attribute_id
       and lang_code = rec_text_.lang_code;
  end loop;
END Remove_Trans_Review_Prefix;

@UncheckedAccess
FUNCTION Is_Cf_Translation_Possible (
      path_ IN VARCHAR2 ) RETURN NUMBER
   IS
      dummy_ NUMBER;
   BEGIN
      SELECT 1
         INTO  dummy_
         FROM  language_translation_exp
         WHERE module = 'CONFIG'
         AND   path = path_;
      RETURN 1;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN 0;
      WHEN too_many_rows THEN
         RETURN 1;
END Is_Cf_Translation_Possible;

PROCEDURE Write_Field_Desc_Trans(
   attribute_id_ IN NUMBER,
   lang_code_    IN VARCHAR2,
   long_text_    IN VARCHAR2,
   status_       IN VARCHAR2)
IS

   objid_        ROWID;
   long_text_unicode_ LANGUAGE_TRANSLATION_TAB.long_text%TYPE := Database_Sys.Unistr(long_text_);
   CURSOR exist_control IS
      SELECT objid
      FROM   LANGUAGE_TRANSLATION
      WHERE  attribute_id = attribute_id_
      AND lang_code = lang_code_;
      
BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', lang_code_);
   Error_SYS.Check_Not_Null(lu_name_, 'STATUS', status_);
   OPEN exist_control;
   FETCH exist_control INTO objid_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      UPDATE LANGUAGE_TRANSLATION_TAB
         SET long_text = long_text_unicode_, diff_text = NULL, long_status = status_, rowversion = SYSDATE, last_update = SYSDATE
         WHERE rowid = objid_
         AND lang_code = lang_code_
         AND attribute_id = attribute_id_;
   ELSE
      INSERT INTO LANGUAGE_TRANSLATION_TAB
         (attribute_id, lang_code, long_text,status, long_status, last_update, reject_status, reject_information, case_id, rowversion)
         VALUES
         (attribute_id_, lang_code_, long_text_unicode_,'N', status_, SYSDATE, NULL, NULL, NULL, SYSDATE);
      CLOSE exist_control;
   END IF;
END Write_Field_Desc_Trans;

PROCEDURE Reject_Trans_And_Refresh (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   reject_information_ IN VARCHAR2,
   case_id_            IN VARCHAR2,
   status_             IN VARCHAR2 ) 
IS
BEGIN
   Add_Rejection(attribute_id_, lang_code_, reject_information_, case_id_);
   
   IF Fnd_Setting_API.Get_Value('TRANS_MODE') = 'SUPP' THEN
      Refresh_(attribute_id_, lang_code_, reject_information_, status_);
   END IF;
END Reject_Trans_And_Refresh;

PROCEDURE Reject_Long_Trans_And_Refresh (
   attribute_id_       IN NUMBER,
   lang_code_          IN VARCHAR2,
   reject_information_ IN VARCHAR2,
   case_id_            IN VARCHAR2,
   status_             IN VARCHAR2 ) 
IS
BEGIN
   Add_Long_Text_Rejection(attribute_id_, lang_code_, reject_information_, case_id_);
   
   IF Fnd_Setting_API.Get_Value('TRANS_MODE') = 'SUPP' THEN
      Refresh_Usage_(attribute_id_, lang_code_, reject_information_, status_);
   END IF;
END Reject_Long_Trans_And_Refresh;