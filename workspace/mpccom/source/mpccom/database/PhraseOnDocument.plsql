-----------------------------------------------------------------------------
--
--  Logical unit: PhraseOnDocument
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170717  niedlk   SCUXX-420, Added function Phrase_On_Doc_Exists to check if document phrases exist for the given document code, current site date and company.
--  160627  SBalLK   Bug 129904, Modified Check_Valid_Date___() method to validate valid until date when update the records to verify valid date region correctly.
--  120720  SBallk   Bug 101597, Added valid_for_all_companies column and modified Get_Phrase_Id_Tab() and Get_Phrase_Id_List()
--  120720           methods to enhance the document phrase functionality to company and site specific level.
--  120720           Added Get_Valid_For_All_Companies, Get_Valid_For_All_Companies_Db, Get_Valid_Until and Get methods.
--  100430  Ajpelk   Merge rose method documentation
--  090406  UdGnlk   Bug 81559, Added Get_Phrase_Id_Tab() to support document phrases. Added Check_Valid_Date___()
--  090406           and update Unpack_Check_Insert___(), Unpack_Check_Update___ () for date validations.        
--  060111  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111           and added UNDEFINE according to the new template.
--  040224  SaNalk   Removed SUBSTRB.
--  ------------------------------- 13.3.0 ----------------------------------
--  001030  PERK     Changed substr to substrb in Get_Phrase_Id_List
--  000925  JOHESE   Added undefines.
--  990422  JOHW     General performance improvements.
--  990414  JOHW     Upgraded to performance optimized template.
--  971208  JOKE     Converted to Foundation1 2.0.0 (32-bit).
--  970618  PELA     Added validation in Unpack_Check_Insert and Unpack_Check_Update that 'Valid From'<'Valid Until'.
--  970313  CHAN     Changed tabl name: document_phrases is replaced by
--                   phrase_on_document_tab
--  970226  PELA     Uses column rowversion as objversion (timestamp).
--  961214  JOKE     Modified with new workbench default templates.
--  961107  JOBE     Changed for compatibility with workbench.
--  960802  JOAN     Added function Get_Phrase_Id_List
--  960611  AnAr     Added 'Update Not Allowed' to VALID_FROM.
--  960523  JOHNI    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Phrase_Id_Tab IS TABLE OF phrase_on_document_tab.phrase_id%TYPE INDEX BY PLS_INTEGER ;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Valid_Date___
--   This procedure validate the valid from and valid until dates and raise errors.
PROCEDURE Check_Valid_Date___ (
   newrec_  IN PHRASE_ON_DOCUMENT_TAB%ROWTYPE,
   action_  IN VARCHAR2 )
IS
   check_             NUMBER;
   data_found         EXCEPTION;
   invalid_date_found EXCEPTION;

   CURSOR check_for_insert IS
      SELECT 1
      FROM  PHRASE_ON_DOCUMENT_TAB
      WHERE document_code = newrec_.document_code
      AND   phrase_id     = newrec_.phrase_id
      AND   ((valid_from BETWEEN newrec_.valid_from AND newrec_.valid_until) 
      OR    (newrec_.valid_from BETWEEN valid_from AND valid_until));

   CURSOR check_for_update IS
      SELECT 1
      FROM  PHRASE_ON_DOCUMENT_TAB
      WHERE newrec_.document_code = document_code
      AND   newrec_.phrase_id = phrase_id 
      AND   newrec_.valid_from != valid_from  
      AND   (newrec_.valid_until BETWEEN valid_from AND valid_until);

BEGIN
   IF (newrec_.valid_from > newrec_.valid_until) THEN
      RAISE invalid_date_found;
   END IF;

   IF (action_ = 'INSERT') THEN
      OPEN check_for_insert;
      FETCH check_for_insert INTO check_;
      IF check_for_insert%FOUND THEN
         CLOSE check_for_insert;
         RAISE data_found;
      END IF;
      CLOSE check_for_insert;
   ELSIF (action_ = 'UPDATE') THEN
      OPEN check_for_update;
      FETCH check_for_update INTO check_;
      IF check_for_update%FOUND THEN
         CLOSE check_for_update;
         RAISE data_found;
      END IF;
      CLOSE check_for_update;
   END IF;

   EXCEPTION
      WHEN data_found THEN
         Error_SYS.Record_General('PhraseOnDocument', 'INVALID_PERIOD: Document Phrase ID :P1 overlaps with valid period(s) of the same document phrase connected to Document :P2.',newrec_.phrase_id, newrec_.document_code);
      WHEN invalid_date_found THEN
         Error_SYS.Record_General('PhraseOnDocument', 'FROMTOBIG: [Valid From] must be less than [Valid Until].');
END Check_Valid_Date___;


-- Merge_Phrase_Id_Table___
--   This method merge two phase_id tables.
PROCEDURE Merge_Phrase_Id_Table___ (
   parent_table_  IN OUT Phrase_Id_Tab,
   child_table_   IN     Phrase_Id_Tab )
IS
   count_b_ NUMBER := parent_table_.count;
BEGIN
   IF child_table_ IS NOT NULL AND child_table_.count >0 THEN
      FOR count_a IN child_table_.FIRST..child_table_.LAST LOOP
         count_b_ := count_b_ + 1;
         parent_table_( count_b_) := child_table_ (count_a);
      END LOOP;
   END IF;
END  Merge_Phrase_Id_Table___;


FUNCTION Get_System_Phrase_Id_Tab___ (
   document_code_  IN VARCHAR2,
   site_date_      IN DATE ) RETURN Phrase_Id_Tab
IS
   phrase_on_doc_tab_   Phrase_Id_Tab;

   CURSOR get_system_phrase_id IS
      SELECT   phrase_id
        FROM   PHRASE_ON_DOCUMENT_TAB 
       WHERE   valid_for_all_companies = 'TRUE'
         AND   document_code = document_code_
         AND   TRUNC(site_date_) BETWEEN TRUNC(valid_from) AND TRUNC(valid_until) ;

BEGIN
   OPEN  get_system_phrase_id;
   FETCH get_system_phrase_id BULK COLLECT INTO phrase_on_doc_tab_;
   CLOSE get_system_phrase_id;
   RETURN (phrase_on_doc_tab_);
END Get_System_Phrase_Id_Tab___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr ('VALID_FOR_ALL_COMPANIES_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     PHRASE_ON_DOCUMENT_TAB%ROWTYPE,
   newrec_     IN OUT PHRASE_ON_DOCUMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF newrec_.valid_until != oldrec_.valid_until THEN
      Document_Phrase_Company_API.Modify_Valid_Until_Dates (newrec_.document_code,
                                                            newrec_.phrase_id,
                                                            newrec_.valid_from,
                                                            newrec_.valid_until );
   END IF;

   IF  (newrec_.valid_for_all_companies = Fnd_Boolean_API.DB_TRUE) AND 
       (newrec_.valid_for_all_companies != oldrec_.valid_for_all_companies) THEN

      Document_Phrase_Company_API.Remove_Valid_Companies (newrec_.document_code,
                                                          newrec_.phrase_id,
                                                          newrec_.valid_from );
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT phrase_on_document_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF Mpccom_Document_API.Get_Document_Phrase_Support_Db (newrec_.document_code) = Document_Phrase_Support_API.DB_NOT_SUPPORTED THEN
      Error_SYS.Record_General(lu_name_, 'DOCPHRNOTSUP: The document type :P1 is not supported by document phrase.', Mpccom_Document_API.Get_Description (newrec_.document_code));
   END IF;
   Check_Valid_Date___(newrec_, 'INSERT');

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     phrase_on_document_tab%ROWTYPE,
   newrec_ IN OUT phrase_on_document_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.valid_until != oldrec_.valid_until) THEN
      Check_Valid_Date___(newrec_, 'UPDATE');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Phrase_Id_List
--   Returns a semicolon separated list containing all phrase id:s
--   valid for the specified document code.
@UncheckedAccess
FUNCTION Get_Phrase_Id_List (
   output_code_   IN VARCHAR2,
   company_       IN VARCHAR2,
   site_          IN VARCHAR2 ) RETURN VARCHAR2
IS
  phrase_id_list_      VARCHAR2(2000) := NULL;
  phrase_on_doc_tab_   Phrase_Id_Tab;

BEGIN
   phrase_on_doc_tab_ := Get_Phrase_Id_Tab(output_code_, company_, site_ );
   IF (phrase_on_doc_tab_.COUNT > 0) THEN
      FOR n IN phrase_on_doc_tab_.FIRST..phrase_on_doc_tab_.LAST LOOP
         IF (phrase_id_list_ IS NULL) THEN
            phrase_id_list_ := phrase_on_doc_tab_(n);
         ELSE
            phrase_id_list_ := substr(phrase_id_list_ || ';' || phrase_on_doc_tab_(n), 1, 2000);
         END IF;
      END LOOP;
   END IF;
   RETURN phrase_id_list_;
END Get_Phrase_Id_List;


-- Get_Phrase_Id_Tab
--   This method selects all the phrase ids for a specific document code and inserts
--   it to a table and returns the table.
@UncheckedAccess
FUNCTION Get_Phrase_Id_Tab (
   output_code_   IN VARCHAR2,
   company_       IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN Phrase_Id_Tab
IS
   phrase_on_doc_tab_   Phrase_Id_Tab;
   temp_phrase_tab_     Phrase_Id_Tab;
   document_code_       PHRASE_ON_DOCUMENT_TAB.document_code%TYPE;
   local_company_       VARCHAR2(20);
   site_date_           DATE;

   CURSOR get_document_code IS
      SELECT document_code
        FROM mpccom_document_tab
       WHERE output_code = output_code_;

BEGIN
   IF (output_code_ IS NOT NULL) THEN
      OPEN  get_document_code;
      FETCH get_document_code INTO document_code_;
      CLOSE get_document_code;

      --document_code_ := Mpccom_Document_API.Get_Document_Code(output_code_);

      IF (document_code_ IS NOT NULL) THEN
         site_date_         := Site_API.Get_Site_Date(NVL(contract_, User_Allowed_Site_API.Get_Default_Site()));
         local_company_     := NVL(company_, Site_API.Get_Company(contract_));
         phrase_on_doc_tab_ := Get_System_Phrase_Id_Tab___(document_code_, site_date_);
   
         IF (local_company_ IS NOT NULL) THEN
            temp_phrase_tab_ := Document_Phrase_Company_API.Get_Phrase_Id_Tab(document_code_, local_company_, site_date_);
            Merge_Phrase_Id_Table___ (phrase_on_doc_tab_, temp_phrase_tab_);
         END IF;
   
         IF (contract_ IS NOT NULL) THEN
            temp_phrase_tab_ := Document_Phrase_Site_API.Get_Phrase_Id_Tab (document_code_, local_company_, contract_, site_date_);
            Merge_Phrase_Id_Table___ (phrase_on_doc_tab_, temp_phrase_tab_);
         END IF;
      END IF;
   END IF;

   RETURN (phrase_on_doc_tab_);
END Get_Phrase_Id_Tab;

@UncheckedAccess
FUNCTION Phrase_On_Doc_Exists (
   document_code_ IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN VARCHAR2
IS 
   site_date_ DATE;
   dummy_     NUMBER;
   company_   VARCHAR2(20);
   result_    VARCHAR2(10);
   
   -- Check if document phrases exist for the given document code and date which are valid for all companies.
   CURSOR phrase_on_doc_exists_ IS
      SELECT 1
      FROM   phrase_on_document_tab
      WHERE  document_code = document_code_
      AND    site_date_ BETWEEN valid_from AND valid_until
      AND    valid_for_all_companies = 'TRUE';
    
    -- Check if document phrases exist for the given document code, date and company.
    CURSOR phrase_on_doc_exists_comp_ IS
      SELECT 1
      FROM   document_phrase_company_tab
      WHERE  company = company_
      AND    document_code = document_code_
      AND    site_date_ BETWEEN valid_from AND valid_until;
BEGIN
   site_date_ := Site_API.Get_Site_Date(contract_);
   company_ := Site_API.Get_Company(contract_);
   
   OPEN phrase_on_doc_exists_;
   FETCH phrase_on_doc_exists_ INTO dummy_;
   IF (phrase_on_doc_exists_%NOTFOUND) THEN
      CLOSE phrase_on_doc_exists_;      
      OPEN phrase_on_doc_exists_comp_;
      FETCH phrase_on_doc_exists_comp_ INTO dummy_;
      IF (phrase_on_doc_exists_comp_%FOUND) THEN
         CLOSE phrase_on_doc_exists_comp_;
         result_ := 'TRUE';
      ELSE
         CLOSE phrase_on_doc_exists_comp_;
         result_ := 'FALSE';
      END IF;
   ELSE
      CLOSE phrase_on_doc_exists_;
      result_ := 'TRUE';
   END IF;
   RETURN result_;
END Phrase_On_Doc_Exists;

