-----------------------------------------------------------------------------
--
--  Logical unit: DataSubjectConsentPurp
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Merged, LCS 139441, GDPR implemented 
--  171114  KrWiPL  GDPR-108, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     data_subject_consent_purp_tab%ROWTYPE,
   newrec_ IN OUT data_subject_consent_purp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.effective_on IS NOT NULL AND newrec_.effective_until IS NOT NULL) THEN
      IF (newrec_.effective_until < newrec_.effective_on) THEN
         Error_SYS.Record_General(lu_name_,'INCORRECTEFFECTIVEDATES: Effective On date cannot be later than Effective Until in :P1 consent',
                                  Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'PersDataProcessPurpose', newrec_.process_purpose_id||'^PURPOSE_NAME'));
      END IF;
   END IF;
END Check_Common___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Consent_Action_Purpose (
   key_ref_         IN VARCHAR2,
   operation_date_  IN DATE,
   action_          IN VARCHAR2,
   purpose_id_      IN NUMBER,
   valid_        IN VARCHAR2,
   effective_on_    IN DATE,
   effective_unitl_ IN DATE)
IS
   newrec_       DATA_SUBJECT_CONSENT_PURP_TAB%ROWTYPE;
BEGIN   
   IF Exists_Db(key_ref_, operation_date_, action_, purpose_id_) THEN
      newrec_ := Get_Object_By_Keys___(key_ref_, operation_date_, action_, purpose_id_);
      newrec_.valid := valid_;
      newrec_.effective_on := effective_on_;
      newrec_.effective_until := effective_unitl_;
      Modify___(newrec_);
   ELSE
      newrec_.key_ref := key_ref_;
      newrec_.operation_date := operation_date_;
      newrec_.action := action_;
      newrec_.process_purpose_id := purpose_id_;
      newrec_.valid := valid_;
      newrec_.effective_on := effective_on_;
      newrec_.effective_until := effective_unitl_;
      New___(newrec_);
   END IF;
END Consent_Action_Purpose;