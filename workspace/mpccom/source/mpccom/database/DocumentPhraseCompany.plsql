-----------------------------------------------------------------------------
--
--  Logical unit: DocumentPhraseCompany
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222   BudKlk   SC2020R1-11841, Removed Client_SYS.Add_To_Attr and made assignments directly to record where it is possible.
--  120416   SBallk   Bug 101597, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr ('VALID_FOR_ALL_SITES_DB', 'TRUE', attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DOCUMENT_PHRASE_COMPANY_TAB%ROWTYPE,
   newrec_     IN OUT DOCUMENT_PHRASE_COMPANY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF newrec_.valid_until != oldrec_.valid_until THEN
      Document_Phrase_Site_API.Modify_Valid_Until_Dates ( newrec_.document_code,
                                                         newrec_.phrase_id,
                                                         newrec_.valid_from,
                                                         newrec_.company,
                                                         newrec_.valid_until);
   END IF;

   IF ( newrec_.valid_for_all_sites = Fnd_Boolean_API.DB_TRUE ) AND
      ( newrec_.valid_for_all_sites != oldrec_.valid_for_all_sites ) THEN

      Document_Phrase_Site_API.Remove_Valid_Sites(newrec_.document_code,
                                                  newrec_.phrase_id,
                                                  newrec_.valid_from,
                                                  newrec_.company );
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT document_phrase_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT (indrec_.valid_until) THEN
      newrec_.valid_until := Phrase_On_Document_API.Get_Valid_Until ( newrec_.document_code, newrec_.phrase_id, newrec_.valid_from);
   END IF;

   super(newrec_, indrec_, attr_);

   IF Mpccom_Document_API.Get_Document_Phrase_Support_Db (newrec_.document_code) = Document_Phrase_Support_API.DB_AT_SYSTEM_LEVEL THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRCOMPLEVEL: The document type :P1 is not supported by document phrase at company level.', Mpccom_Document_API.Get_Description (newrec_.document_code));
   END IF;

   IF Phrase_On_Document_API.Get_Valid_For_All_Companies_Db (newrec_.document_code, 
                                                             newrec_.phrase_id, 
                                                             newrec_.valid_from ) = Fnd_Boolean_API.DB_TRUE THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRNOCOMP: Cannot have company(s) if document phrase valid for all companies.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Phrase_Id_Tab
--   This method selects all the phrase ids for a specific document code and inserts
--   it to a table and returns the table.
@UncheckedAccess
FUNCTION Get_Phrase_Id_Tab (
   document_code_ IN VARCHAR2,
   company_       IN VARCHAR2,
   site_date_    IN DATE ) RETURN Phrase_On_Document_API.Phrase_Id_Tab
IS
   phrase_on_doc_tab_   Phrase_On_Document_API.Phrase_Id_Tab;

   CURSOR get_company_phrase_id_ IS
      SELECT   phrase_id
        FROM   DOCUMENT_PHRASE_COMPANY_TAB 
       WHERE   document_code = document_code_
         AND   company = company_
         AND   valid_for_all_sites = 'TRUE'
         AND   TRUNC(site_date_) BETWEEN TRUNC(valid_from) AND TRUNC(valid_until) ;

BEGIN
   IF ( document_code_ IS NOT NULL AND company_ IS NOT NULL) THEN
      IF ( document_code_ IS NOT NULL ) THEN
         OPEN  get_company_phrase_id_;
         FETCH get_company_phrase_id_ BULK COLLECT INTO phrase_on_doc_tab_;
         CLOSE get_company_phrase_id_;
      END IF;
   END IF;
   RETURN (phrase_on_doc_tab_);
END Get_Phrase_Id_Tab;


-- Remove_Valid_Companies
--   This method  remove the all site which related to the selected keys.
PROCEDURE Remove_Valid_Companies(
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE )
IS
   CURSOR get_del_rec IS
      SELECT   company 
        FROM   DOCUMENT_PHRASE_COMPANY_TAB
       WHERE   document_code = document_code_ 
         AND   phrase_id = phrase_id_ 
         AND   valid_from = valid_from_;

   remrec_        DOCUMENT_PHRASE_COMPANY_TAB%ROWTYPE;
   objid_         DOCUMENT_PHRASE_COMPANY.OBJID%TYPE;
   objversion_    DOCUMENT_PHRASE_COMPANY.OBJVERSION%TYPE;

BEGIN
   FOR rec_ IN get_del_rec  LOOP
      
      Document_Phrase_Site_API.Remove_Valid_Sites(document_code_, phrase_id_, valid_from_, rec_.company );

      Get_Id_Version_By_Keys___ ( objid_, objversion_, document_code_, phrase_id_, valid_from_, rec_.company);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);

   END LOOP;
END Remove_Valid_Companies;


-- Modify_Valid_Until
--   This method modfies the valid_until value which related to the selected keys.
PROCEDURE Modify_Valid_Until (
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE,
   company_       IN VARCHAR2,
   valid_until_   IN DATE)
IS
   newrec_        DOCUMENT_PHRASE_COMPANY_TAB%ROWTYPE;
BEGIN

   newrec_ := Lock_By_Keys___( document_code_, phrase_id_, valid_from_, company_ );
   newrec_.valid_until := valid_until_;
   Modify___(newrec_);
END Modify_Valid_Until;


-- Modify_Valid_Until_Dates
--   This method modify the valid_until column value in multiple companies belong to system.
PROCEDURE Modify_Valid_Until_Dates (
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE,
   valid_until_   IN DATE)
IS
   attr_          VARCHAR2(2000);

   CURSOR get_rec IS
      SELECT   company 
        FROM   DOCUMENT_PHRASE_COMPANY_TAB
       WHERE   document_code = document_code_ 
         AND   phrase_id = phrase_id_ 
         AND   valid_from = valid_from_;
BEGIN
   Client_SYS.Clear_Attr ( attr_ );

   FOR rec_ IN get_rec  LOOP
      Modify_Valid_Until( document_code_, phrase_id_, valid_from_, rec_.company, valid_until_);
      Document_Phrase_Site_API.Modify_Valid_Until_Dates (document_code_, phrase_id_, valid_from_, rec_.company, valid_until_ );
   END LOOP;

END Modify_Valid_Until_Dates;



