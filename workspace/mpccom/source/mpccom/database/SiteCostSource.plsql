-----------------------------------------------------------------------------
--
--  Logical unit: SiteCostSource
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111005  DeKoLK EANE-3742, Moved 'User Allowed Site' in Default Where condition from client.
--  051104  JoEd     Changed Get_Cost_Source_Id. Removed Get_Current_Cost_Source_Id.
--  050914  JOHESE   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_cost_source_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN   
   super(newrec_, indrec_, attr_);
   IF newrec_.company != Site_API.Get_Company(newrec_.contract) THEN
      Error_sys.Record_General(lu_name_, 'WRONGCOMPANY: Site :P1 does not exist in company :P2.', newrec_.contract, newrec_.company);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_cost_source_tab%ROWTYPE,
   newrec_ IN OUT site_cost_source_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.company != Site_API.Get_Company(newrec_.contract) THEN
      Error_sys.Record_General(lu_name_, 'WRONGCOMPANY: Site :P1 does not exist in company :P2.', newrec_.contract, newrec_.company);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Cost_Source_Id (
   contract_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN VARCHAR2
IS
   temp_ SITE_COST_SOURCE_TAB.cost_source_id%TYPE;
   CURSOR get_attr IS
      SELECT cost_source_id
      FROM SITE_COST_SOURCE_TAB
      WHERE contract = contract_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Cost_Source_Id;



