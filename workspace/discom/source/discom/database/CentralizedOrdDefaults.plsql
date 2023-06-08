-----------------------------------------------------------------------------
--
--  Logical unit: CentralizedOrdDefaults
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------------
-- 2022-06-08  GrGalk SCDEV-10852, Added validations for the Date Range in Centralized Order Defaults
-------------------------------------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
-- Get_Site_Defaults
@UncheckedAccess
PROCEDURE Get_Site_Defaults (
   header_contract_        OUT VARCHAR2,
   centralized_order_from_ OUT VARCHAR2,
   contract_               IN VARCHAR2,
   date_                   IN DATE)
IS
   CURSOR Get_Site_Defaults IS
      SELECT purch_order_header_site, centralized_order_from
      FROM centralized_ord_defaults_tab
      WHERE contract = contract_
      AND TRUNC(date_) BETWEEN valid_from AND valid_to;
BEGIN
   OPEN Get_Site_Defaults;
   FETCH Get_Site_Defaults INTO header_contract_, centralized_order_from_;
   CLOSE Get_Site_Defaults;
END Get_Site_Defaults;

-------------------- PRIVATE DECLARATIONS -----------------------------------

last_calender_date_ CONSTANT DATE := Database_SYS.Last_Calendar_Date_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Validate_Date_Range___
PROCEDURE Validate_Date_Range___ (
   newrec_ IN centralized_ord_defaults_tab%ROWTYPE)
IS
   CURSOR validate_input IS
     SELECT 1
     FROM   centralized_ord_defaults_tab
     WHERE  contract = newrec_.contract
     AND    purch_order_header_site != newrec_.purch_order_header_site
     AND   (newrec_.valid_from BETWEEN valid_from AND valid_to OR
            NVL(newrec_.valid_to, last_calender_date_) BETWEEN valid_from AND valid_to   OR
            newrec_.valid_from < valid_from AND NVL(newrec_.valid_to, last_calender_date_) > valid_to);
   rec_ NUMBER;   
BEGIN
   IF (newrec_.valid_from > newrec_.valid_to) THEN 
      Error_SYS.Record_General(lu_name_, 'STARTINVALID: Start date can not be later then end date.');
   ELSE
         OPEN validate_input;
         FETCH validate_input INTO rec_;
         IF validate_input%FOUND THEN 
            CLOSE validate_input;
            Raise_Date_Overlap_Error___;
         END IF;
         CLOSE validate_input;
   END IF;            
END Validate_Date_Range___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT centralized_ord_defaults_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Validate_Date_Range___(newrec_);
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     centralized_ord_defaults_tab%ROWTYPE,
   newrec_ IN OUT centralized_ord_defaults_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Date_Range___(newrec_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     centralized_ord_defaults_tab%ROWTYPE,
   newrec_ IN OUT centralized_ord_defaults_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.valid_to IS NULL) THEN 
      newrec_.valid_to := last_calender_date_;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

PROCEDURE Raise_Date_Overlap_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DATEDOVERLAP: Defined date periods can not overlap.');
END Raise_Date_Overlap_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

