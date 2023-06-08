-----------------------------------------------------------------------------
--
--  Logical unit: CustHierarchyRebateAttr
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181010  SeJalk   SCUXXW4-9837, Modified Prepare_Insert___ to set default company for user.
--  081208  KiSalk   Added method Check_Hierarchy_Reb_Per_Assort.
--  080922  JeLise   Added check on rebate_agreement in Check_Delete___.
--  080919  JeLise   Added check on assortment state in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  080916  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_hierarchy_rebate_attr_tab%ROWTYPE,
   newrec_ IN OUT cust_hierarchy_rebate_attr_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   state_ VARCHAR2(20);
   CURSOR get_assortment_state(assortment_id_ VARCHAR2) IS
      SELECT objstate
        FROM assortment_structure
       WHERE assortment_id = assortment_id_;
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   OPEN get_assortment_state(newrec_.assortment_id);
   FETCH get_assortment_state INTO state_;
   CLOSE get_assortment_state;
   IF state_ != 'Active' THEN
      Error_SYS.State_General(lu_name_, 'ASSORTMENTSTATE: The Assortment ":P1" is not Active and cannot be connected to this hierarchy.', newrec_.assortment_id);
   END IF;
END Check_Common___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUST_HIERARCHY_REBATE_ATTR_TAB%ROWTYPE )
IS
   dummy_   NUMBER;

   CURSOR check_rebate_agreement(hierarchy_id_ VARCHAR2, company_ VARCHAR2) IS
      SELECT 1
      FROM rebate_agreement_tab
      WHERE company = company_
      AND   hierarchy_id = hierarchy_id_
      AND   rowstate != 'Closed';
BEGIN
   OPEN check_rebate_agreement(remrec_.hierarchy_id, remrec_.company);
   FETCH check_rebate_agreement INTO dummy_;
   IF check_rebate_agreement%FOUND THEN
      CLOSE check_rebate_agreement;
      Error_SYS.Record_General(lu_name_, 'HIERARCHY_USED: This hierarchy is used in a Rebate Agreement that is not Closed and therefore cannot be deleted.');
   END IF;
   CLOSE check_rebate_agreement;
   
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   company_ Cust_Hierarchy_Rebate_Attr_tab.company%TYPE;
BEGIN
   super(attr_);
   User_Finance_Api.Get_Default_Company(company_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Hierarchy_Reb_Per_Assort
--   This will return 1 if the assortment_id is connected in Hierarchy Rebate Set-up; 0 otherwise.
@UncheckedAccess
FUNCTION Check_Hierarchy_Reb_Per_Assort (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_records IS
      SELECT count(*)
      FROM   CUST_HIERARCHY_REBATE_ATTR_TAB
      WHERE  assortment_id = assortment_id_;
BEGIN

   OPEN exist_records;
   FETCH exist_records INTO dummy_;
   CLOSE exist_records;

   IF (dummy_ > 0) THEN
      dummy_ := 1;
   END IF;

   RETURN dummy_;
END Check_Hierarchy_Reb_Per_Assort;



