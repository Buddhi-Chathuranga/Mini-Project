-----------------------------------------------------------------------------
--
--  Logical unit: CompanyBasicDataWindow
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
   newrec_     IN OUT company_basic_data_window_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_target_companies IS
      SELECT target_company
      FROM   target_company_data_tmp
      WHERE  source_company = newrec_.source_company
      AND    target_company != newrec_.target_company;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   FOR rec_ IN get_target_companies LOOP
      newrec_.target_company := rec_.target_company;
      super(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_basic_data_window_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   exist_   NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM   company_basic_data_window_tab
      WHERE  target_company    = newrec_.target_company
      AND    logical_unit_name = newrec_.logical_unit_name;
BEGIN
   OPEN  check_exist;
   FETCH check_exist INTO exist_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      Error_SYS.Record_General(lu_name_, 'TARGETUSED: Target Company :P1 and page :P2 already used in another combination', newrec_.target_company, newrec_.logical_unit_name);
   END IF;
   CLOSE check_exist;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Company_Basic_Data (
   newrec_ IN OUT company_basic_data_window_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END Create_Company_Basic_Data;


FUNCTION Check_Copy_From_Company (
   company_             IN VARCHAR2,
   logical_unit_name_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_   NUMBER;
   CURSOR check_copy_from_company IS
      SELECT 1
      FROM   company_basic_data_window_tab c, source_company_tab s
      WHERE  target_company      = company_
      AND    logical_unit_name   = logical_unit_name_
      AND    copy_from_company   = 'TRUE'
      AND    s.source_company    = c.source_company
      AND    s.rowstate          = 'Active';
BEGIN
   OPEN  check_copy_from_company;
   FETCH check_copy_from_company INTO exist_;
   IF (check_copy_from_company%FOUND) THEN
      CLOSE check_copy_from_company;
      RETURN TRUE;
   END IF;
   CLOSE check_copy_from_company;
   RETURN FALSE;
END Check_Copy_From_Company;


@UncheckedAccess
FUNCTION Check_Copy_From_Source_Company (
   target_company_      IN VARCHAR2,
   source_company_      IN VARCHAR2,
   logical_unit_name_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_   NUMBER;
   CURSOR check_copy_from_company IS
      SELECT 1
      FROM   company_basic_data_window_tab c, source_company_tab s
      WHERE  target_company      = target_company_
      AND    c.source_company    != source_company_
      AND    logical_unit_name   = logical_unit_name_
      AND    copy_from_company   = 'TRUE'
      AND    s.source_company    = c.source_company
      AND    s.rowstate          = 'Active';
BEGIN
   OPEN  check_copy_from_company;
   FETCH check_copy_from_company INTO exist_;
   IF (check_copy_from_company%FOUND) THEN
      CLOSE check_copy_from_company;
      RETURN TRUE;
   END IF;
   CLOSE check_copy_from_company;
   RETURN FALSE;
END Check_Copy_From_Source_Company;


@UncheckedAccess
FUNCTION Is_Active_Lu_Exist (
   source_company_      IN VARCHAR2,
   logical_unit_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ NUMBER;
   CURSOR exist_lu IS
      SELECT 1
      FROM   company_basic_data_window_tab ct, source_company_tab st
      WHERE  ct.source_company    = st.source_company
      AND    ct.source_company    = source_company_
      AND    ct.logical_unit_name = logical_unit_name_
      AND    st.rowstate          = 'Active';
BEGIN
   OPEN exist_lu;
   FETCH exist_lu INTO exist_;
   IF (exist_lu%FOUND) THEN
      CLOSE exist_lu;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_lu;
   RETURN 'FALSE';
END Is_Active_Lu_Exist;


@UncheckedAccess
FUNCTION Get_Include ( 
   source_company_      IN VARCHAR2,
   target_company_      IN VARCHAR2,
   logical_unit_name_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(source_company_, target_company_, logical_unit_name_)) THEN
      IF (Is_Active_Lu_Exist(source_company_,logical_unit_name_) = 'TRUE') THEN 
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   ELSE
      RETURN 'FALSE';
   END IF;
END Get_Include;
