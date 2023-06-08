-----------------------------------------------------------------------------
--
--  Logical unit: MpccomPhrase
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201019  Ambslk  MF2020R1-7726, Added Exists_On_Document___() method to check if the phrase is already used in DOcument phrases.
--  201012  Ambslk  MF2020R1-7569, Modified Check_Update___() and Update___() methods.
--  200930  Ambslk  MF2020R1-7443, Added Is_Contract_Clause_Editable() method.
--  200907  MUSHLK  MF2020R1-7071, Added method Active_Phrase_Revision_Exists().
--  200818  Ambslk  MF2020R1-5605, Moved Add_Approval_Template() and Remove_Approval_Template() methods to Update()__.
--  200623  Ambslk  MF2020R1-5605, Implemented approval processes for revision.
--  200616  ambslk  MF2020R1-5834, Make the call Check_Update___() dynamic.
--  200518  ambslk  MF2020R1-5703, Override Check_Update___() method of MPCCOM_PHRASE entity to throw an error when the user switches from phrase to contract 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
FUNCTION Active_Phrase_Revision_Exists (
   phrase_id_   IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_      NUMBER;
   exists_     VARCHAR2(5);
   
   CURSOR get_active_phrase_revs IS
      SELECT 1
      FROM  MPCCOM_PHRASE_REVISION_TAB
      WHERE phrase_id = phrase_id_
      AND   approval_status = 'ACTIVE';
BEGIN
   exists_ := 'FALSE';
   OPEN get_active_phrase_revs ;
   FETCH get_active_phrase_revs INTO dummy_;
   IF(get_active_phrase_revs%FOUND)THEN
      exists_ := 'TRUE';
   END IF;
   CLOSE get_active_phrase_revs;
   RETURN exists_;  
END Active_Phrase_Revision_Exists;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_phrase_tab%ROWTYPE,
   newrec_ IN OUT mpccom_phrase_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      DECLARE
         is_contract_clause_      Mpccom_Phrase_TAB.contract_clause%TYPE;
         contract_clause_type_    Mpccom_Phrase_TAB.contract_clause_type%TYPE;
         dummy_                   Number;
         
         CURSOR get_approval_status IS
            SELECT 1 
            FROM MPCCOM_PHRASE_REVISION_TAB 
            WHERE phrase_id = newrec_.phrase_id
            AND approval_status IN ('APPROVED', 'APPROVAL_IN_PROGRESS', 'ACTIVE', 'OBSOLETE');
            
      BEGIN
         is_contract_clause_ := newrec_.contract_clause;
         contract_clause_type_ := newrec_.contract_clause_type;
         IF (indrec_.contract_clause OR indrec_.contract_clause_type) THEN
            IF(indrec_.contract_clause AND Exists_On_Document___(newrec_.phrase_id) = 'TRUE') THEN
               Error_SYS.Record_General(lu_name_, 'DOC_PHRASE_EXISTS: This phrase is already used in a Document Phrase.');
            END IF;
            IF (is_contract_clause_ = Fnd_Boolean_API.DB_TRUE AND contract_clause_type_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'CLAUSETYPENULL: Clause Type must have a value for Phrases of type Contract Clause.');
            ELSE
               OPEN get_approval_status ;
               FETCH get_approval_status INTO dummy_;
               IF(get_approval_status%NOTFOUND)THEN
                  CLOSE get_approval_status;
                  IF is_contract_clause_ = Fnd_Boolean_API.DB_FALSE THEN
                     Mpccom_Phrase_Revision_API.Check_Overlap_Revision(newrec_.phrase_id);
                     newrec_.contract_clause_type := NULL; 
                  END IF;
               ELSE
                  CLOSE get_approval_status;
                  Error_SYS.Record_General(lu_name_, 'CANNOTALTER: Contract Clause Type can only be changed when all revisions are in either Inactive or Approval Required status.');
               END IF;
            END IF;
         END IF;
      END;
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_phrase_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (newrec_.contract_clause = Fnd_Boolean_API.DB_TRUE AND newrec_.contract_clause_type IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CLAUSETYPENULL: Clause Type must have a value for Phrases of type Contract Clause.');
      END IF;
   $END
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     mpccom_phrase_tab%ROWTYPE,
   newrec_     IN OUT mpccom_phrase_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
         
BEGIN
   IF (Validate_SYS.Is_Changed(oldrec_.contract_clause, newrec_.contract_clause)) THEN
      IF (newrec_.contract_clause_type IS NOT NULL AND newrec_.contract_clause = Fnd_Boolean_API.DB_TRUE) THEN
         Mpccom_Phrase_Revision_API.Add_Approval_Template(newrec_.phrase_id, newrec_.contract_clause_type);
      ELSE
         Mpccom_Phrase_Revision_API.Remove_Approval_Template(newrec_.phrase_id);
      END IF;
   ELSIF (Validate_SYS.Is_Changed(oldrec_.contract_clause_type, newrec_.contract_clause_type)) THEN
      Mpccom_Phrase_Revision_API.Remove_Approval_Template(newrec_.phrase_id);
      Mpccom_Phrase_Revision_API.Add_Approval_Template(newrec_.phrase_id, newrec_.contract_clause_type);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

FUNCTION Exists_On_Document___ (
   phrase_id_   IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   check_val_  VARCHAR2(5);
   
   CURSOR get_document_phrase IS
      SELECT 1
        FROM PHRASE_ON_DOCUMENT_TAB
       WHERE phrase_id = phrase_id_;
BEGIN
	check_val_ := 'FALSE';
   OPEN get_document_phrase ;
   FETCH get_document_phrase INTO dummy_;
   IF(get_document_phrase%FOUND)THEN
      CLOSE get_document_phrase;
      check_val_ := 'TRUE';
      RETURN check_val_;
   END IF;
   CLOSE get_document_phrase;
   RETURN check_val_;  
END Exists_On_Document___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Is_Contract_Clause_Editable (
   phrase_id_   IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   check_val_  VARCHAR2(5);
   
   CURSOR get_phrase IS
      SELECT 1
        FROM MPCCOM_PHRASE_REVISION_TAB
       WHERE phrase_id = phrase_id_
         AND approval_status IN
             ('APPROVED', 'APPROVAL_IN_PROGRESS', 'ACTIVE', 'OBSOLETE');
BEGIN
	check_val_ := 'TRUE';
   OPEN get_phrase ;
   FETCH get_phrase INTO dummy_;
   IF(get_phrase%FOUND)THEN
      CLOSE get_phrase;
      check_val_ := 'FALSE';
      RETURN check_val_;
   END IF;
   CLOSE get_phrase;
   RETURN check_val_;  
END Is_Contract_Clause_Editable;
