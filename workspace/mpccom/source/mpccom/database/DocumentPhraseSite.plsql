-----------------------------------------------------------------------------
--
--  Logical unit: DocumentPhraseSite
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210104   BudKlk   SC2020R1-11864, Removed Client_SYS.Add_To_Attr and made assignments directly to record where it is possible.
--  120416   SBallk   Bug 101597, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT document_phrase_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT(indrec_.valid_until) THEN
      newrec_.valid_until := Phrase_On_Document_API.Get_Valid_Until (newrec_.document_code, newrec_.phrase_id, newrec_.valid_from );
   END IF;
   super(newrec_, indrec_, attr_);

   IF (NVL(Company_Site_API.Get_Company(newrec_.contract), '') != newrec_.company ) THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRINVALSITE: Site :P1 is not connected to company :P2 and can not be added site for the document phrase.',newrec_.contract, newrec_.company);
   END IF;

   IF Mpccom_Document_API.Get_Document_Phrase_Support_Db(newrec_.document_code) = Document_Phrase_Support_API.DB_AT_COMPANY_LEVEL THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRSITELEVEL: :P1 is not support for site level document phrase.', Mpccom_Document_API.Get_Description (newrec_.document_code));
   END IF;
   
   IF Document_Phrase_Company_API.Get_Valid_For_All_Sites_Db( newrec_.document_code,
                                                               newrec_.phrase_id,
                                                               newrec_.valid_from,
                                                               newrec_.company ) = Fnd_Boolean_API.DB_TRUE  THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRNOSITE: Cannot have site(s) if document phrase valid for all sites.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove_Valid_Sites
--   This method removes the sites which are in selected company.
PROCEDURE Remove_Valid_Sites(
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE,
   company_       IN VARCHAR2 )
IS
   CURSOR get_del_rec IS
      SELECT   contract 
        FROM   DOCUMENT_PHRASE_SITE_TAB
       WHERE   document_code = document_code_ 
         AND   phrase_id = phrase_id_ 
         AND   valid_from = valid_from_
         AND   company = company_;
               
   remrec_        DOCUMENT_PHRASE_SITE_TAB%ROWTYPE;
   objid_         DOCUMENT_PHRASE_SITE.OBJID%TYPE;
   objversion_    DOCUMENT_PHRASE_SITE.OBJVERSION%TYPE;

BEGIN
   FOR rec_ IN get_del_rec  LOOP
      Get_Id_Version_By_Keys___ ( objid_, objversion_, document_code_, phrase_id_, valid_from_, company_, rec_.contract );
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;

END Remove_Valid_Sites;


-- Modify_Valid_Until_Dates
--   This method modify the valid_until column value in multiple sites belong to one company.
PROCEDURE Modify_Valid_Until_Dates (
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE,
   company_       IN VARCHAR2,
   valid_until_   IN DATE )
IS
   CURSOR get_update_rec IS
      SELECT   contract 
        FROM   DOCUMENT_PHRASE_SITE_TAB
       WHERE   document_code = document_code_ 
         AND   phrase_id = phrase_id_ 
         AND   valid_from = valid_from_
         AND   company = company_;

BEGIN

   FOR rec_ IN get_update_rec  LOOP
      Modify_Valid_Until ( document_code_, phrase_id_, valid_from_, company_, rec_.contract, valid_until_ );
   END LOOP;

END Modify_Valid_Until_Dates;


-- Modify_Valid_Until
--   This method modify the valid_until column value for specific key values.
PROCEDURE Modify_Valid_Until (
   document_code_ IN VARCHAR2,
   phrase_id_     IN VARCHAR2,
   valid_from_    IN DATE,
   company_       IN VARCHAR2,
   contract_      IN VARCHAR2,
   valid_until_   IN DATE )
IS
   newrec_        DOCUMENT_PHRASE_SITE_TAB%ROWTYPE;

BEGIN
   newrec_ := Lock_By_Keys___( document_code_, phrase_id_, valid_from_, company_, contract_); 
   newrec_.valid_until := valid_until_;
   Modify___(newrec_);

END Modify_Valid_Until;


@UncheckedAccess
FUNCTION Get_Phrase_Id_Tab (
   document_code_ IN VARCHAR2,
   company_       IN VARCHAR2,
   site_          IN VARCHAR2,
   site_date_     IN DATE ) RETURN Phrase_On_Document_API.Phrase_Id_Tab
IS
   phrase_on_doc_tab_   Phrase_On_Document_API.Phrase_Id_Tab;
   local_company_       VARCHAR2(20);

   CURSOR get_site_phrase_id_ IS
      SELECT   phrase_id
        FROM   DOCUMENT_PHRASE_SITE_TAB 
       WHERE   document_code = document_code_
         AND   company = local_company_
         AND   contract = site_
         AND   TRUNC( site_date_ ) BETWEEN TRUNC(valid_from) AND TRUNC(valid_until) ;

BEGIN
   local_company_ := NVL(company_, Site_API.Get_Company(site_));

   OPEN  get_site_phrase_id_;
   FETCH get_site_phrase_id_ BULK COLLECT INTO phrase_on_doc_tab_;
   CLOSE get_site_phrase_id_;

   RETURN (phrase_on_doc_tab_);
END Get_Phrase_Id_Tab;



