-----------------------------------------------------------------------------
--
--  Logical unit: TargetCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT target_company_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   INSERT INTO target_company_data_tmp (
      source_company,
      target_company)
   VALUES (
      newrec_.source_company,
      newrec_.target_company);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Target_Company ( 
   company_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_   NUMBER;
   CURSOR check_target IS
      SELECT 1
      FROM   target_company_tab
      WHERE  target_company = company_; 
BEGIN
   OPEN check_target;
   FETCH check_target INTO exist_;
   IF (check_target%FOUND) THEN
      CLOSE check_target;
      RETURN TRUE;
   ELSE
      CLOSE check_target;
      RETURN FALSE;
   END IF;
END Check_Target_Company;