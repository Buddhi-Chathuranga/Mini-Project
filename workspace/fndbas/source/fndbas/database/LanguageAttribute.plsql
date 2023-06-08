-----------------------------------------------------------------------------
--
--  Logical unit: LanguageAttribute
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050418  STDA    Added procedure Reset_Changed_ (F1PR480).
--  050914  STDA    Added termbinding attributes (F1PR480).
--  051108  BJSA    Added Modify_Term_Binding_ (TU227).
--  060518  STDA    TermBinding info only updated if connection_complete_ = 1 (Bug#58091)
--  070119  STDA    Added model reference attributes (BUG#61395).
--  090331  JOWISE  Added functionality for Copying Translations from SO to RWC
--  100907  JOWISE  Added parameter rwc_sub_type_ to Copy_Term_
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  110218  TOBESE  Modified Copy_Term_ to handle updates in APF (Bug#95860).
--  110601  TOBESE  Enhancements in Term application of Copy Translation algorithm for APF (Bug#97390).
--  110629  JOWISE  Corrected removal of so termsbindings.
--  120227  JOWISE  Added possibility to run copy translations with on spec langauge
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE attribute_rectype IS RECORD (
  attribute_id                NUMBER,
  context_id                  NUMBER,
  name                        VARCHAR2(200),
  prog_text                   VARCHAR2(500),
  changed                     VARCHAR2(1),
  method                      VARCHAR2(1),
  ref_attr                    NUMBER,
  customer_fitting            VARCHAR2(1),
  obsolete                    VARCHAR2(1),
  display_name_type           VARCHAR2(100),
  connection_complete         NUMBER,
  exclude_from_documentation  NUMBER,
  entered_by                  VARCHAR2(100),
  entered_date                DATE,
  modified_by                 VARCHAR2(100),
  modified_date               DATE,
  verified                     NUMBER,
  databound_view                VARCHAR2(100),
  databound_attribute         VARCHAR2(100));


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Generate_Sequence_Id___ RETURN NUMBER
IS
   attribute_id_ NUMBER;
   CURSOR get_seq IS
      SELECT Language_Attribute_SEQ.nextval
      FROM   dual;
BEGIN
   OPEN get_seq;
   FETCH get_seq INTO attribute_id_;
   CLOSE get_seq;
   RETURN ( attribute_id_ );
END Generate_Sequence_Id___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     LANGUAGE_ATTRIBUTE_TAB%ROWTYPE,
   newrec_     IN OUT LANGUAGE_ATTRIBUTE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   
BEGIN
   newrec_.modified_date := sysdate;
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User;
   IF (newrec_.work_flow = 'UNUSED') THEN
      newrec_.usage := 'FALSE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr( 'MODIFIED_DATE', newrec_.modified_date, attr_ );
   Client_SYS.Add_To_Attr( 'MODIFIED_BY', newrec_.modified_by, attr_ ); 
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get_Id__ (
   attribute_id_ OUT NUMBER,
   context_id_   IN  NUMBER,
   name_         IN  VARCHAR2 )
IS
BEGIN
   attribute_id_ := Get_Id_(context_id_ , name_);
END Get_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Id_ (
   context_id_ IN NUMBER,
   name_       IN VARCHAR2 ) RETURN NUMBER
IS
   attribute_id_ LANGUAGE_ATTRIBUTE_TAB.attribute_id%TYPE;
   CURSOR get_id IS
      SELECT attribute_id
      FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE name = name_
      AND context_id = context_id_ ;
BEGIN
   OPEN get_id;
   FETCH get_id INTO attribute_id_;
   IF (get_id%FOUND) THEN
      CLOSE get_id;
      RETURN (attribute_id_);
   END IF;
   CLOSE get_id;
   RETURN (0);
END Get_Id_;


PROCEDURE Make_Method_ (
   attribute_id_            IN NUMBER,
   method_                  IN VARCHAR2,
   attribute_id_referenced_ IN NUMBER )
IS
   new_ref_attr_ NUMBER;
BEGIN
   -- IF method is refeerence we must check so that the referenced attribute exists
   IF method_ = 'R' THEN
      new_ref_attr_ := attribute_id_referenced_ ;
   ELSE
      new_ref_attr_ := NULL;
   END IF;
   -- Update the attribute
   UPDATE LANGUAGE_ATTRIBUTE_TAB
   SET method = Language_Tr_Method_API.Encode(method_), 
       ref_attr = new_ref_attr_,
       rowversion = sysdate
   WHERE attribute_id = attribute_id_;
   IF (sql%NOTFOUND) THEN
      Error_SYS.Appl_General('LanguageAttribute', 'INVALIDATR: The attribute id is invalid');
   END IF;
END Make_Method_;


PROCEDURE Make_Obsolete_ (
   context_id_ IN NUMBER )
IS
BEGIN
   UPDATE LANGUAGE_ATTRIBUTE_TAB
      SET obsolete = 'Y',
          rowversion = sysdate
      WHERE context_id = context_id_;
END Make_Obsolete_;

PROCEDURE Make_Field_Desc_Obsolete_ (
   context_id_ IN VARCHAR2 )
IS
BEGIN
   UPDATE LANGUAGE_ATTRIBUTE_TAB a
      SET field_desc_obsolete = 'Y',
          rowversion = sysdate
      WHERE context_id IN (SELECT REGEXP_SUBSTR(context_id_,'[^,]+', 1, level) FROM dual
                           CONNECT BY REGEXP_SUBSTR(context_id_, '[^,]+', 1, level) IS NOT NULL);
   /*UPDATE LANGUAGE_CONTEXT_TAB
      SET obsolete = 'Y',
          rowversion = sysdate
      WHERE context_id IN (SELECT REGEXP_SUBSTR(context_id_,'[^,]+', 1, level) FROM dual
                           CONNECT BY REGEXP_SUBSTR(context_id_, '[^,]+', 1, level) IS NOT NULL);*/
END Make_Field_Desc_Obsolete_;


PROCEDURE Make_Usage_Obsolete_ (
   context_id_ IN NUMBER )
IS
BEGIN
   UPDATE LANGUAGE_ATTRIBUTE_TAB
      SET USAGE = 'FALSE',
          field_desc_obsolete = 'Y',
          rowversion = sysdate
      WHERE context_id = context_id_;
END Make_Usage_Obsolete_;


PROCEDURE Purge_ (
   attribute_id_ IN NUMBER )
IS
BEGIN
   NULL;
END Purge_;


PROCEDURE Refresh_ (
   attribute_id_               OUT NUMBER,
   context_id_                 IN  NUMBER,
   name_                       IN  VARCHAR2,
   prog_text_                  IN  VARCHAR2)
IS
   current_attribute_id_    LANGUAGE_ATTRIBUTE.attribute_id%TYPE;
   current_prog_text_       LANGUAGE_ATTRIBUTE.prog_text%TYPE;
   prog_text_unicode_       LANGUAGE_ATTRIBUTE.prog_text%TYPE := Database_Sys.Unistr(prog_text_);

   CURSOR get_attribute IS
      SELECT attribute_id, prog_text
      FROM   LANGUAGE_ATTRIBUTE_TAB
      WHERE  name = name_
      AND    context_id = context_id_;
BEGIN
   -- Check if attribute already exists. IF so, then also read the old prog text.
   OPEN get_attribute;
   FETCH get_attribute INTO current_attribute_id_, current_prog_text_;
   IF get_attribute%FOUND THEN
        -- Check if prog text has changed. 
        -- If no change only the obsolete flag is cleared.
        -- If changes exists, changed flag is set, texts updated and translations will be 
        -- stamped with equivalent information
        IF (replace(nvl(prog_text_unicode_, '@<<@>>@'),' ','') = replace(nvl(current_prog_text_,'@<<@>>@'),' ','')) THEN
            UPDATE LANGUAGE_ATTRIBUTE_TAB
                SET obsolete = 'N',
                prog_text = prog_text_unicode_, 
                prog_text_short = substr( prog_text_unicode_, 1, 500 ),
                rowversion = sysdate
            WHERE attribute_id = current_attribute_id_;
        ELSE
        -- Update changed and obsolete flags for attribute
            UPDATE LANGUAGE_ATTRIBUTE_TAB
                SET obsolete = 'N', 
                changed = 'C', 
                prog_text = prog_text_unicode_, 
                prog_text_short = substr( prog_text_unicode_, 1, 500 ),
                rowversion = sysdate
            WHERE attribute_id = current_attribute_id_;
            -- Update changed flags for attribute translations
            Language_Translation_API.Make_Changed_( current_attribute_id_);
        END IF;
   ELSE
        current_attribute_id_ := Generate_Sequence_Id___;       
        INSERT INTO LANGUAGE_ATTRIBUTE_TAB
           (attribute_id, context_id, name, usage, work_flow, field_desc_obsolete, prog_text, prog_text_short,
           changed, method, ref_attr, obsolete, rowversion)
        VALUES
           (current_attribute_id_, context_id_, name_,'FALSE', 'UNUSED', 'Y', prog_text_unicode_, substr( prog_text_unicode_, 1, 500 ),
           'N', 'M', null, 'N', SYSDATE); 
   END IF;
   -- Close cursor and return attribute id
   CLOSE get_attribute;
   attribute_id_ := current_attribute_id_;
END Refresh_;

PROCEDURE Refresh_ (
   attribute_id_               OUT NUMBER,
   context_id_                 IN  NUMBER,
   name_                       IN  VARCHAR2,
   prog_text_                  IN  VARCHAR2,
   in_usage_                   IN  VARCHAR2,
   long_prog_text_             IN  VARCHAR2,
   source_                     IN  VARCHAR2 DEFAULT NULL)
IS
   current_attribute_id_    LANGUAGE_ATTRIBUTE.attribute_id%TYPE;
   usage_                   LANGUAGE_ATTRIBUTE.usage%TYPE;

BEGIN
   Refresh_(current_attribute_id_, context_id_, name_, prog_text_);
   
   IF ((upper(in_usage_) = 'USED') OR (upper(in_usage_) = 'TRUE')) THEN
      usage_ := 'TRUE';
   ELSE
      usage_ := 'FALSE';
   END IF;
   
   Refresh_Usage_(current_attribute_id_, context_id_, name_, long_prog_text_, nvl(upper(usage_),'FALSE'),source_);
   
   attribute_id_ := current_attribute_id_;
END Refresh_;

PROCEDURE Refresh_Usage_ (
   attribute_id_               OUT NUMBER,
   context_id_                 IN  NUMBER,
   name_                       IN  VARCHAR2,
   long_prog_text_             IN  VARCHAR2,
   usage_                      IN  VARCHAR2 DEFAULT 'TRUE',
   source_                     IN  VARCHAR2 DEFAULT 'FILE')
IS
   current_attribute_id_    LANGUAGE_ATTRIBUTE.attribute_id%TYPE;
   current_long_prog_text_  LANGUAGE_ATTRIBUTE.long_prog_text%TYPE;
   long_prog_text_unicode_  LANGUAGE_ATTRIBUTE.long_prog_text%TYPE := Database_Sys.Unistr(long_prog_text_);
   current_work_flow_       LANGUAGE_ATTRIBUTE.work_flow_db%TYPE;
   work_flow_               LANGUAGE_ATTRIBUTE.work_flow_db%TYPE;
   field_desc_obsolete_     LANGUAGE_ATTRIBUTE.field_desc_obsolete_db%TYPE := 'N';
   modified_by_             LANGUAGE_ATTRIBUTE.modified_by%TYPE;
   
   CURSOR get_attribute IS
      SELECT attribute_id, long_prog_text, work_flow, modified_by
      FROM   LANGUAGE_ATTRIBUTE_TAB
      WHERE  name = name_
      AND    context_id = context_id_;
BEGIN
   
   IF (usage_ = 'FALSE') THEN
            work_flow_ := 'UNUSED';
            field_desc_obsolete_ := 'Y';
   END IF;
         
   -- Check if attribute already exists. IF so, then also read the old prog text and long prog text
   OPEN get_attribute;
   FETCH get_attribute INTO current_attribute_id_, current_long_prog_text_ ,current_work_flow_,modified_by_ ;
   IF get_attribute%FOUND THEN
      IF source_ = 'FILE' THEN
         -- Check if the long_prog_text is changed
         -- If changed obsolete flag is cleared.
         -- If changes exists, translations will be stamped with equivalent information
         -- The work flow will be set according to the existing work flow state     
         IF (nvl(long_prog_text_unicode_, '@<<@>>@') != nvl(current_long_prog_text_,'@<<@>>@')) THEN       
            
            -- Update changed flags for usage translations
            UPDATE LANGUAGE_ATTRIBUTE_TAB
            SET usage = usage_,
            field_desc_obsolete = field_desc_obsolete_,
            -- check for the already existing unused work flow state and update the status accordingly
            work_flow = decode(long_prog_text_unicode_, NULL,  nvl(work_flow_, work_flow) , decode(current_work_flow_, 'UNUSED', 'PRELIMINARY' , work_flow)),
            long_prog_text = long_prog_text_unicode_,
            rowversion = sysdate
            WHERE attribute_id = current_attribute_id_;
            Language_Translation_API.Make_Usage_Changed_( current_attribute_id_);
         ELSE
            UPDATE LANGUAGE_ATTRIBUTE_TAB
            SET usage = usage_,
            field_desc_obsolete = field_desc_obsolete_,
            work_flow = decode(current_long_prog_text_, NULL, decode(current_work_flow_, 'UNUSED', nvl(work_flow_,'PRELIMINARY'),nvl(work_flow_,work_flow)), work_flow),
            rowversion = sysdate
            WHERE attribute_id = current_attribute_id_;
         END IF;
      -- Adding new field description which is found when scanning language XML files
      -- Here updating new field description with correct values since new attribute is 
      -- already added by above Refresh__ method
      ELSIF ((source_ = 'SCAN') AND (usage_ = 'TRUE') AND (current_long_prog_text_ IS NULL) AND (modified_by_ IS NULL)) THEN   
            UPDATE LANGUAGE_ATTRIBUTE_TAB
            SET usage = usage_,
            field_desc_obsolete = field_desc_obsolete_,
            work_flow = nvl(work_flow_,'PRELIMINARY'),
            -- long_prog_text = long_prog_text_unicode_,--Temporary fix to avoid updating long prog text with prog text (PACCFW-2216)
            changed = 'N',
            method = 'M',
            ref_attr = NULL,
            obsolete = 'N',
            rowversion = sysdate
            WHERE attribute_id = current_attribute_id_;
      ELSE
         -- Rescanning for contexts, upodate only the rowversion
         UPDATE LANGUAGE_ATTRIBUTE_TAB
         SET field_desc_obsolete = decode(usage_,'TRUE','N','Y'),
         rowversion = sysdate
         WHERE attribute_id = current_attribute_id_;
      END IF;
   ELSE
      current_attribute_id_ := Generate_Sequence_Id___;
      INSERT INTO LANGUAGE_ATTRIBUTE_TAB
         (attribute_id, context_id, name, usage, work_flow, field_desc_obsolete, long_prog_text,
           changed, method, ref_attr, obsolete, rowversion)
      VALUES
         (current_attribute_id_, context_id_, name_, usage_, nvl(work_flow_,'PRELIMINARY'), field_desc_obsolete_, long_prog_text_unicode_,
           'N', 'M', null, 'N', sysdate); 
   END IF;
   -- Close cursor and return attribute id
   CLOSE get_attribute;
   attribute_id_ := current_attribute_id_;
END Refresh_Usage_;

PROCEDURE Remove_Context_ (
   context_id_ IN NUMBER )
IS
   attribute_id_ NUMBER;
   CURSOR attributes IS
      SELECT attribute_id
      FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE context_id = context_id_;
BEGIN
   -- Delete translations for all attributes of the context
   OPEN attributes;
   FETCH attributes INTO attribute_id_;
   WHILE (attributes%FOUND) LOOP
      Language_Translation_API.Remove_Attribute_( attribute_id_ );
      FETCH attributes INTO attribute_id_;
   END LOOP;
   CLOSE attributes;
   -- Delte the attributes themselves from the context
   DELETE FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE context_id = context_id_;
END Remove_Context_;


PROCEDURE Remove_Context_Language_ (
   context_id_ IN NUMBER,
   lang_code_ IN VARCHAR2 )
IS
   attribute_id_ NUMBER;
   CURSOR attributes IS
      SELECT attribute_id
      FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE context_id = context_id_;
BEGIN
   -- Delete translations for all attributes of the context
   OPEN attributes;
   FETCH attributes INTO attribute_id_;
   WHILE (attributes%FOUND) LOOP
      Language_Translation_API.Remove_Attribute_Language_( attribute_id_, lang_code_ );
      FETCH attributes INTO attribute_id_;
   END LOOP;
   CLOSE attributes;
END Remove_Context_Language_;


PROCEDURE Reset_Changed_ (
   attribute_id_ IN NUMBER )
IS
BEGIN
   -- Change status flag changed to not changed
   UPDATE LANGUAGE_ATTRIBUTE_TAB
      SET changed = 'N',
          rowversion = sysdate
      WHERE attribute_id = attribute_id_;
END Reset_Changed_;


PROCEDURE Copy_Constants_ (
   so_context_id_ IN NUMBER,
   remove_old_    IN NUMBER,
   language_      IN VARCHAR2 DEFAULT NULL )
IS
      

   CURSOR get_so_constants IS
      SELECT attribute_id, name, prog_text_short
      FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE context_id = so_context_id_
      AND obsolete = 'N'
      AND prog_text IS NOT NULL;

   CURSOR get_rwc_constants(so_name_ VARCHAR2, prog_text_short_ VARCHAR2) IS
      SELECT attribute_id, prog_text_short
      FROM LANGUAGE_ATTRIBUTE_TAB
      WHERE name = so_name_
      AND context_id NOT IN (so_context_id_)
      AND obsolete = 'N'
      AND (prog_text_short = replace(prog_text_short_, chr(13), '') or
           prog_text_short = replace(prog_text_short_, '\''', ''''));

BEGIN

   FOR get_so_constants_rec_ IN get_so_constants LOOP      
      dbms_output.put_line('Attribute: ' || get_so_constants_rec_.attribute_id || ' , name: ' || get_so_constants_rec_.name || ', prog: ' || get_so_constants_rec_.prog_text_short);
      FOR get_rwc_constants_rec_ IN get_rwc_constants(get_so_constants_rec_.name,
                                                      get_so_constants_rec_.prog_text_short) LOOP
         dbms_output.put_line('   RWC Match: ' || get_rwc_constants_rec_.attribute_id || ' - ' || get_rwc_constants_rec_.prog_text_short);
         Language_Translation_API.Copy_Text_Translations_(get_so_constants_rec_.attribute_id, get_rwc_constants_rec_.attribute_id, remove_old_, language_);
      END LOOP;
   END LOOP;

END Copy_Constants_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Modify_Long_Prog_Text(
   attribute_id_     IN NUMBER,
   long_prog_text_   IN VARCHAR2)
IS
   newrec_  language_attribute_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(attribute_id_);
   newrec_.long_prog_text := long_prog_text_;
   Modify___(newrec_);
END Modify_Long_Prog_Text;

