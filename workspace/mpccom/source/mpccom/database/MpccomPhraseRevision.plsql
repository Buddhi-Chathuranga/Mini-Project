-----------------------------------------------------------------------------
--
--  Logical unit: MpccomPhraseRevision
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200911  Ambslk  MF2020R1-7177 Added Validate_New_App_Routing() and Validate_Remove_App_Routing() methods.
--  200623  Ambslk  MF2020R1-5605, Implemented approval processes for revision.
--  200131  Ambslk  MFSPRING20-752, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_next_revision_no (
   phrase_id_ IN VARCHAR2) RETURN NUMBER
IS
   revision_no_ MPCCOM_PHRASE_REVISION_TAB.revision_no%TYPE;
   CURSOR get_revision_no_ IS
      SELECT NVL(MAX(revision_no)+1,1)
      FROM MPCCOM_PHRASE_REVISION_TAB
      WHERE phrase_id = phrase_id_;
   
BEGIN
	OPEN get_revision_no_;
   FETCH get_revision_no_ INTO revision_no_;
   CLOSE get_revision_no_;
   RETURN revision_no_;
END Get_next_revision_no;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   phrase_id_     VARCHAR2(10);
   revision_no_   NUMBER;
BEGIN
   phrase_id_     := CLIENT_SYS.Get_Item_Value('PHRASE_ID',attr_);
   revision_no_   := Get_next_revision_no(phrase_id_);
   super(attr_);
   Client_SYS.Add_To_Attr('REVISION_NO', revision_no_, attr_);
END Prepare_Insert___;
   
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT mpccom_phrase_revision_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   phrase_id_              Mpccom_Phrase_Revision_TAB.phrase_id%TYPE;
   contract_clause_type_   Mpccom_Phrase_TAB.contract_clause_type%TYPE;
   is_contract_clause_     Mpccom_Phrase_TAB.contract_clause%TYPE;
   
BEGIN
   
   phrase_id_              := newrec_.phrase_id;
   is_contract_clause_     := Mpccom_Phrase_API.Get_Contract_Clause_Db(phrase_id_);
   IF (is_contract_clause_ = Fnd_Boolean_API.DB_FALSE) THEN
      newrec_.approval_status := NULL;
   ELSE
      contract_clause_type_ := Mpccom_Phrase_API.Get_Contract_Clause_Type(phrase_id_);
      Copy_Approval_Template___(phrase_id_, newrec_.revision_no, contract_clause_type_);
      newrec_.approval_status := Get_Contract_Approval_Status(phrase_id_, newrec_.revision_no);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

PROCEDURE Copy_Approval_Template___ (
   phrase_id_                 IN VARCHAR2,
   revision_no_               IN NUMBER,
   contract_clause_type_      IN VARCHAR2)
IS

BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      DECLARE
         dummy_new_access_person_   VARCHAR2(200);
         dummy_new_access_group_    VARCHAR2(200);
         profile_id_                VARCHAR2(250);
         key_ref_                   VARCHAR2(2000);
      BEGIN
         key_ref_ := CLIENT_SYS.Get_Key_Reference(lu_name_, 'PHRASE_ID', phrase_id_, 'REVISION_NO', revision_no_);
         profile_id_ := Contract_Clause_Type_API.Get_Approval_Profile_Id(contract_clause_type_);
         IF (profile_id_ IS NOT NULL) THEN
            Approval_Routing_API.Copy_App_Profile(dummy_new_access_person_,
                                                  dummy_new_access_group_,
                                                  lu_name_,
                                                  key_ref_,
                                                  profile_id_ );
         END IF;
      END;
   $ELSE
      NULL;
   $END
END Copy_Approval_Template___;
   
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     mpccom_phrase_revision_tab%ROWTYPE,
   newrec_ IN OUT mpccom_phrase_revision_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF indrec_.phase_in_date OR indrec_.phase_out_date THEN
      IF (newrec_.phase_out_date IS NOT NULL AND newrec_.phase_out_date < newrec_.phase_in_date) THEN
         Error_SYS.Record_General(lu_name_, 'EXCEEDPHASEINDATE: Phase In Date must be earlier than Phase Out Date.');
      END IF;

      IF (Mpccom_Phrase_API.Get_Contract_Clause_Db(newrec_.phrase_id)= Fnd_Boolean_API.DB_FALSE) THEN
         IF (Existing_Overlap_Revision___(newrec_.phrase_id, newrec_.revision_no, newrec_.phase_in_date, newrec_.phase_out_date)) THEN
            Error_SYS.Record_General(lu_name_, 'OVERLAPREVISIONS: Date range of an existing revision overlaps the date range of this revision.');
         END IF;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_phrase_revision_tab%ROWTYPE,
   newrec_ IN OUT mpccom_phrase_revision_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.approval_status = 'ACTIVE') THEN
      IF Active_Revision_Exist___(newrec_.phrase_id, newrec_.revision_no, newrec_.phase_in_date, newrec_.phase_out_date) THEN
         Error_SYS.Record_General(lu_name_, 'ACTIVE_REV_EXIST: Date range of an active revision overlaps the date range of this revision.');
      END IF;
   ELSIF (newrec_.approval_status = 'OBSOLETE') THEN
      IF (newrec_.phase_out_date IS NULL) OR (newrec_.phase_out_date >= TRUNC(SYSDATE)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTSETOBSOLETE: It is not possible to update the revision to Obsolete status unless it is already phased out.');
      END IF;
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

FUNCTION Active_Revision_Exist___ (
   phrase_id_      IN VARCHAR2,
   revision_no_    IN NUMBER,
   begin_date_     IN DATE,
   end_date_       IN DATE) RETURN BOOLEAN
IS
   dummy_         NUMBER;
   end_of_time_   DATE := Database_SYS.Get_Last_Calendar_Date;

   CURSOR get_active_revs IS
      SELECT 1
      FROM MPCCOM_PHRASE_REVISION_TAB
      WHERE (phase_in_date BETWEEN begin_date_
             AND NVL(end_date_, end_of_time_)
          OR NVL(phase_out_date, end_of_time_) BETWEEN begin_date_
             AND NVL(end_date_, end_of_time_)
          OR (begin_date_ BETWEEN phase_in_date
              AND NVL(phase_out_date, end_of_time_)
              AND NVL(end_date_, end_of_time_) BETWEEN phase_in_date
              AND NVL(phase_out_date, end_of_time_)))
      AND   revision_no <> revision_no_
      AND   phrase_id = phrase_id_
      AND   approval_status = 'ACTIVE';
BEGIN
   OPEN get_active_revs ;
   FETCH get_active_revs INTO dummy_;
   IF(get_active_revs%FOUND)THEN
      CLOSE get_active_revs;
      RETURN TRUE;
   END IF;
   CLOSE get_active_revs;
   RETURN FALSE; 
END Active_Revision_Exist___;

FUNCTION Existing_Overlap_Revision___ (
   phrase_id_      IN VARCHAR2,
   revision_no_    IN NUMBER,
   begin_date_     IN DATE,
   end_date_       IN DATE) RETURN BOOLEAN
IS
   dummy_         NUMBER;
   end_of_time_   DATE := Database_SYS.Get_Last_Calendar_Date;
   
   CURSOR get_overlap_revs IS
      SELECT 1
      FROM MPCCOM_PHRASE_REVISION_TAB
      WHERE (phase_in_date BETWEEN begin_date_
             AND NVL(end_date_, end_of_time_)
          OR NVL(phase_out_date, end_of_time_) BETWEEN begin_date_
             AND NVL(end_date_, end_of_time_)
          OR (begin_date_ BETWEEN phase_in_date
              AND NVL(phase_out_date, end_of_time_)
              AND NVL(end_date_, end_of_time_) BETWEEN phase_in_date
              AND NVL(phase_out_date, end_of_time_)))
      AND   revision_no <> revision_no_
      AND   phrase_id = phrase_id_;
BEGIN
   OPEN get_overlap_revs;
   FETCH get_overlap_revs INTO dummy_;
   IF (get_overlap_revs%FOUND) THEN
      RETURN TRUE;
      CLOSE get_overlap_revs;
   END IF;
   CLOSE get_overlap_revs;
   RETURN FALSE; 
END Existing_Overlap_Revision___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Add_Approval_Template (
   phrase_id_                   IN VARCHAR2,
   contract_clause_type_        IN VARCHAR2)
IS
   CURSOR get_revision IS
      SELECT * FROM MPCCOM_PHRASE_REVISION_TAB 
      WHERE phrase_id = phrase_id_;
BEGIN
   FOR revision_rec_ IN get_revision LOOP
      Copy_Approval_Template___(phrase_id_, revision_rec_.revision_no, contract_clause_type_);
      revision_rec_.approval_status := Get_Contract_Approval_Status(phrase_id_, revision_rec_.revision_no);
      Modify___(revision_rec_);
   END LOOP;
END Add_Approval_Template;

PROCEDURE Remove_Approval_Template (
   phrase_id_                   IN VARCHAR2)
IS
BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      DECLARE
         key_ref_ VARCHAR2(2000);
         
         CURSOR get_revision IS
            SELECT * FROM MPCCOM_PHRASE_REVISION_TAB 
            WHERE phrase_id = phrase_id_;
            
      BEGIN
         FOR revision_rec_ IN get_revision LOOP
            key_ref_ := CLIENT_SYS.Get_Key_Reference(lu_name_, 'PHRASE_ID', phrase_id_, 'REVISION_NO', revision_rec_.revision_no);
            IF (Approval_Routing_API.Exist_Routing(lu_name_, key_ref_)  = 'TRUE') THEN
               Approval_Routing_API.Remove_Approval_Routing(lu_name_, key_ref_);
            END IF;
            revision_rec_.approval_status := NULL;
            Modify___(revision_rec_);
         END LOOP;
      END;
   $ELSE
      NULL;
   $END
END Remove_Approval_Template;

PROCEDURE Set_Clause_Approved (
   phrase_id_                   IN VARCHAR2,
   revision_no_                 IN NUMBER )
IS
   revision_rec_  MPCCOM_PHRASE_REVISION_TAB%ROWTYPE;
            
BEGIN
   revision_rec_ := Get_Object_By_Keys___(phrase_id_, revision_no_);
   revision_rec_.approval_status := Get_Contract_Approval_Status(phrase_id_, revision_no_, TRUE);
   Modify___(revision_rec_);
END Set_Clause_Approved;

PROCEDURE Set_Clause_Active (
   phrase_id_                   IN VARCHAR2,
   revision_no_                 IN NUMBER,
   activate_                    IN BOOLEAN DEFAULT FALSE )
IS
   revision_rec_  MPCCOM_PHRASE_REVISION_TAB%ROWTYPE;
            
BEGIN
   revision_rec_ := Get_Object_By_Keys___(phrase_id_, revision_no_);
   revision_rec_.approval_status := Contract_Clause_Status_API.DB_ACTIVE;
   Modify___(revision_rec_);
END Set_Clause_Active;

PROCEDURE Set_Clause_Obsolete (
   phrase_id_                   IN VARCHAR2,
   revision_no_                 IN NUMBER,
   obsolete_                    IN BOOLEAN DEFAULT FALSE)
IS
   revision_rec_  MPCCOM_PHRASE_REVISION_TAB%ROWTYPE;
            
BEGIN
   revision_rec_ := Get_Object_By_Keys___(phrase_id_, revision_no_);
   revision_rec_.approval_status := Contract_Clause_Status_API.DB_OBSOLETE;
   Modify___(revision_rec_);
END Set_Clause_Obsolete;

FUNCTION Phrase_Text_Exists (
   phrase_id_                   IN VARCHAR2,
   revision_no_                 IN NUMBER) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   check_val_  VARCHAR2(5);
   
   CURSOR get_phrase_text IS
      SELECT 1 
         FROM MPCCOM_PHRASE_TEXT_TAB 
         WHERE phrase_id = phrase_id_
         AND revision_no = revision_no_;
   
BEGIN
   check_val_ := 'FALSE';
   OPEN get_phrase_text ;
   FETCH get_phrase_text INTO dummy_;
   IF(get_phrase_text%NOTFOUND)THEN
      CLOSE get_phrase_text;
      check_val_ := 'TRUE';
      RETURN check_val_;
   END IF;
   CLOSE get_phrase_text;
   RETURN check_val_;  
END Phrase_Text_Exists;

-- This will be called from Approval_Routing_API.Validate_Modify_App_Routing___ to throw an error message when approving step where no phrase text is defined for the relevant revision.
PROCEDURE Validate_Modify_App_Routing(
   key_ref_    IN VARCHAR2,
   attr_       IN VARCHAR2)
IS
   approval_status_db_ VARCHAR2(20);
   
BEGIN
   IF Phrase_Text_Exists(Client_SYS.Get_Key_Reference_Value(key_ref_,'PHRASE_ID'), Client_SYS.Get_Key_Reference_Value(key_ref_,'REVISION_NO')) = 'TRUE' THEN
      Error_SYS.Record_General(lu_name_, 'NOPHRASETEXT: Phrase text must be defined before approval.');
   ELSE
      approval_status_db_ := Client_SYS.Get_Item_Value('APPROVAL_STATUS_DB', attr_);
      IF approval_status_db_ = 'APP' THEN
         Set_Clause_Approved(Client_SYS.Get_Key_Reference_Value(key_ref_,'PHRASE_ID'), Client_SYS.Get_Key_Reference_Value(key_ref_,'REVISION_NO'));
      END IF;
   END IF;
END Validate_Modify_App_Routing;

-- This will be called from Approval_Routing_API.Validate_New_App_Routing___ to throw an error message when adding new approval steps to revisions which are in Inactive, Approved, Obsolete, Active status.
PROCEDURE Validate_New_App_Routing(
   key_ref_    IN VARCHAR2,
   attr_       IN VARCHAR2)
IS
   approval_status_db_ mpccom_phrase_revision_tab.approval_status%TYPE;
   
BEGIN
   approval_status_db_:= Get_Approval_Status_Db(Client_SYS.Get_Key_Reference_Value(key_ref_,'PHRASE_ID'), Client_SYS.Get_Key_Reference_Value(key_ref_,'REVISION_NO'));
   IF (approval_status_db_ = 'INACTIVE') THEN
      Error_SYS.Record_General(lu_name_, 'INACTIVE_REVISION: Contract Clause Type of this phrase does not require approval. New approval steps are not allowed.');
   ELSIF (approval_status_db_ IN ('ACTIVE', 'OBSOLETE', 'APPROVED')) THEN
      Error_SYS.Record_General(lu_name_, 'NO_NEW_APP_STEPS: Changes to approval steps are not allowed when the revision status is :P1', Contract_Clause_Status_API.Decode(approval_status_db_));
   END IF;
END Validate_New_App_Routing;

-- This will be called from Approval_Routing_API.Validate_Remove_App_Routing___ when deleting approval steps in the attachment.
PROCEDURE Validate_Remove_App_Routing(
   key_ref_    IN VARCHAR2,
   attr_       IN VARCHAR2)
IS
   approval_status_ mpccom_phrase_revision_tab.approval_status%TYPE;
   
BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      approval_status_:= Get_Approval_Status_Db(Client_SYS.Get_Key_Reference_Value(key_ref_,'PHRASE_ID'), Client_SYS.Get_Key_Reference_Value(key_ref_,'REVISION_NO'));
      IF (approval_status_ = 'APPROVAL_REQUIRED') THEN
         IF Approval_Routing_API.Get_Total_To_Approve(lu_name_, key_ref_) = 1 THEN
            Error_SYS.Record_General(lu_name_, 'NOT_TO_DELETE_STEP: Contract Clause Type of this phrase requires approval. At least one approval step should remain in the Approval Process.');
         END IF;
      ELSE
         IF (Approval_Routing_API.Get_Total_To_Approve(lu_name_, key_ref_) - Approval_Routing_API.Get_Num_Actual_Approved(lu_name_, key_ref_) = 1) THEN
            Set_Clause_Approved(Client_SYS.Get_Key_Reference_Value(key_ref_,'PHRASE_ID'), Client_SYS.Get_Key_Reference_Value(key_ref_,'REVISION_NO'));
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Remove_App_Routing;

FUNCTION Get_Contract_Approval_Status (
   phrase_id_                 IN VARCHAR2,
   revision_no_               IN NUMBER,
   is_approval_started_       IN BOOLEAN DEFAULT FALSE) RETURN mpccom_phrase_revision_tab.approval_status%TYPE
IS
BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      DECLARE
         approval_status_  mpccom_phrase_revision_tab.approval_status%TYPE;
         key_ref_          VARCHAR2(2000);

      BEGIN
         key_ref_ := CLIENT_SYS.Get_Key_Reference(lu_name_, 'PHRASE_ID', phrase_id_, 'REVISION_NO', revision_no_);
         
         IF (Approval_Routing_API.Exist_Routing(lu_name_, key_ref_)  = 'TRUE') THEN
            IF is_approval_started_ THEN
               IF (Approval_Routing_API.Get_Num_Actual_Approved(lu_name_, key_ref_) = Approval_Routing_API.Get_Total_To_Approve(lu_name_, key_ref_) - 1) THEN
                  approval_status_ := Contract_Clause_Status_API.DB_APPROVED;
               ELSE
                  approval_status_ := Contract_Clause_Status_API.DB_APPROVAL_IN_PROGRESS;
               END IF;
            ELSE
               approval_status_ := Contract_Clause_Status_API.DB_APPROVAL_REQUIRED;
            END IF;
         ELSE
            approval_status_ := Contract_Clause_Status_API.DB_INACTIVE;
         END IF;

         RETURN approval_status_;
      END;
   $ELSE
      RETURN NULL;
   $END
END Get_Contract_Approval_Status;

PROCEDURE Check_Overlap_Revision (
   phrase_id_   IN VARCHAR2)
IS
   CURSOR get_phrase_record IS
      SELECT *
        FROM MPCCOM_PHRASE_REVISION_TAB
       WHERE phrase_id = phrase_id_;
BEGIN
   FOR phrase_rec_ IN get_phrase_record LOOP
      IF (Existing_Overlap_Revision___(phrase_rec_.phrase_id, phrase_rec_.revision_no, phrase_rec_.phase_in_date, phrase_rec_.phase_out_date)) THEN
         Error_SYS.Record_General(lu_name_, 'OVERLAPDATERANGE: Overlapping date ranges for revisions are not allowed for phrases which are not contract clauses.');
      END IF;
   END LOOP;
END Check_Overlap_Revision;
