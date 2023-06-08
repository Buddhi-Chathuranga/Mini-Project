-----------------------------------------------------------------------------
--
--  Logical unit: MpccomPhraseText
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210628  Ambslk  MF21R2-1980, Modified Get_All_Phrases() and Get_Phrase_Text() methods to fetch revision_no in which phase_in_date is lesser than or equal to sysdate.
--  200903  Ambslk  MF2020R1-7066, Modified Check_Common___ method to restrict making changes to the phrase texts when the revision is in approval progress.
--  200131  Ambslk  MFSPRING20-752, Added revision_no to Get_Phrase_Text method.
--  120720  SBallk  Bug 101597, Modified Get_All_Phrases method by adding parameter to fetch location specific
--  120720          document phrases as a single text.
--  100520  MoNilk  Modified REF in column comment on language_code to IsoLanguage in MPCCOM_PHRASE_TEXT.
--  100429  Ajpelk  Merge rose method documentation.
--  ------------------------ 14.0.0 -----------------------------------------
--  091002  SuSalk  Bug 86117, Added phrase description to the MPCCOM_PHRASE_TEXT_LOV view.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040224  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0------------------------------------
--  001030  PERK  Changed substr to substrb in Get_All_Phrases
--  000925  JOHESE  Added undefines.
--  990506  DAZA  General performance improvements. Added NOCHECK to VIEW_LOV.
--  990414  JOHW  Upgraded to performance optimized template.
--  971208  JOKE  Converted to Foundation1 2.0.0 (32-bit).
--  970602  PELA  Bug correction (Uses column rowversion as objversion(timestamp)).
--  970506  FRMA  Changed reference for language_code (from Mpccom_Language to
--                Application_Language).
--  970313  MAGN  Changed tablename phrase_text to mpccom_phrase_text_tab.
--  970226  MAGN  Uses column rowversion as objversion(timestamp).
--  970123  JOKE  Added LOV-View since LOV needs a key.
--  961215  JOKE  Modified with new workbench default templates.
--  961205  JOBE  Modified for compatibility with workbench.
--  960912  JOAN  Added function Get_All_Phrases
--                Changed return type for Get_Phrase_Text to VARCHAR2
--  960802  JOAN  Added function Get_Phrase_Text.
--  960701  JOBE  Added function Get_Phrase_Text.
--  960626  JOBE  Added VIEW_LOV.
--  960606  AnAr  Added convertion for PhraseText.
--  960523  JOHNI Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     mpccom_phrase_text_tab%ROWTYPE,
   newrec_ IN OUT mpccom_phrase_text_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF Mpccom_Phrase_Revision_API.Get_Approval_Status_Db(newrec_.phrase_id, newrec_.revision_no) = Contract_Clause_Status_API.DB_APPROVAL_IN_PROGRESS THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTMODIFYPHRASETEXT: Revision approval is in progress. Phrase text changes are not allowed.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_All_Phrases
--   Retrieve all the phrases for the specified document and language code
--   The phrases are concatenated into one single returned string max
--   2000 characters long.
--   The phrases are separated with CR+LF characters.
@UncheckedAccess
FUNCTION Get_All_Phrases (
   language_code_ IN VARCHAR2,
   document_code_ IN VARCHAR2,
   company_       IN VARCHAR2 DEFAULT NULL,
   contract_      IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   phrase_id_list_      VARCHAR2(2000);
   next_phrase_id_      VARCHAR2(10);
   phrases_             VARCHAR2(2000);
   next_phrase_         VARCHAR2(2000);
   n0_                  NUMBER;
   n1_                  NUMBER;
   done_                BOOLEAN;
   revision_no_         NUMBER;
   
   CURSOR get_active_revision_(phrase_id_ VARCHAR2) IS
      SELECT revision_no 
      FROM Mpccom_Phrase_Revision_tab 
      WHERE phrase_id = phrase_id_
      AND (phase_out_date IS NULL OR TRUNC(phase_out_date) > TRUNC(sysdate))
      AND TRUNC(phase_in_date) <= TRUNC(sysdate);
      
BEGIN
      -- Retrieve the document phrase(s) if any
      -- The phrases are concatenated into one single string
      phrases_ := NULL;

      -- First retrieve a semicolon separated list of phrase id:s for the document
      phrase_id_list_ := Phrase_On_Document_API.Get_Phrase_Id_List( Mpccom_Document_API.Get_Output_Code (document_code_), company_, contract_ );

      IF (phrase_id_list_ IS NOT NULL) THEN
         done_ := FALSE;
         n0_ := 1;
         WHILE (done_ = FALSE) LOOP
            -- Get the position of the next ';' in the list.
            n1_ := INSTR(phrase_id_list_, ';', n0_);
            IF (n1_ = 0) THEN
               next_phrase_id_ := SUBSTR(phrase_id_list_, n0_);
            ELSE
               next_phrase_id_ := SUBSTR(phrase_id_list_, n0_, n1_ - n0_);
            END IF;

            OPEN get_active_revision_(next_phrase_id_);
            FETCH get_active_revision_ INTO revision_no_;
            CLOSE get_active_revision_;
            
            next_phrase_ := Get_Phrase_Text(next_phrase_id_,  revision_no_, language_code_);
            
            IF (next_phrase_ IS NOT NULL) THEN
               IF (phrases_ IS NULL) THEN
                  phrases_ := SUBSTR(next_phrase_, 1, 2000);
               ELSE
                  phrases_ := SUBSTR(phrases_ || CHR(13) || CHR(10) || next_phrase_, 1, 2000);
               END IF;
            END IF;
            IF (n1_ = 0) THEN
               done_ := TRUE;
            ELSE
               n0_ := n1_ + 1;
            END IF;
         END LOOP;
      END IF;

      RETURN phrases_;
END Get_All_Phrases;


FUNCTION Get_Phrase_Text (
   phrase_id_ IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   revision_no_         NUMBER;
   
   CURSOR get_active_revision_(phrase_id_ VARCHAR2) IS
      SELECT revision_no 
      FROM Mpccom_Phrase_Revision_tab 
      WHERE phrase_id = phrase_id_
      AND (phase_out_date IS NULL OR TRUNC(phase_out_date) > TRUNC(sysdate))
      AND TRUNC(phase_in_date) <= TRUNC(sysdate);
BEGIN
	OPEN get_active_revision_(phrase_id_);
   FETCH get_active_revision_ INTO revision_no_;
   CLOSE get_active_revision_;
   RETURN Get_Phrase_Text(phrase_id_, revision_no_, language_code_);
END Get_Phrase_Text;

