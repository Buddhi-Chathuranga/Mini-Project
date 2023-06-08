-----------------------------------------------------------------------------
--
--  Logical unit: SiteToSiteReserveSetup
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201109  RasDlk  SCZ-11538, Modified Prepare_Insert___() by setting VISIBLE_PLANNED to REL_MTRL_PLANNING_DB field.
--  200708  ErFelk  Bug 152094(SCZ-10712), Modified Prepare_Insert___() by setting REL_MTRL_PLANNING_DB as TRUE.
--  140709  HimRlk  Added new field supply_site_avail_allowed.
--  130812  MaIklk  TIBE-938, Removed inst_CustOrdCustomer_ global variable and used conditional compilation instead.
--  100430  Ajpelk  Merge rose method documentation
--  070510  RaKalk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to set the int_cust_no_ length to 20
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040224  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0 -----------------------------------
--  031015  DaZa    Changed the check from 031009 to dynamic PL/SQL.
--  031009  DaZa    Added check for internal customer in Unpack_Check_Insert___/Unpack_Check_Update___.
--  200803  MaEelk  Performed CR Merge (CR Only).
--  030414  DaZa    Renamed LU to SiteToSiteReserveSetup.
--  030328  DaZa    Created.
--  ************************* CR Merge *************************************
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SUPPLY_SITE_RESERVE_TYPE', Supply_Site_Reserve_Type_API.Decode('MANUAL'), attr_);
   Client_SYS.Add_To_Attr('SUPPLY_SITE_AVAIL_ALLOWED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('REL_MTRL_PLANNING', Rel_Mtrl_Planning_API.Decode('VISIBLE_PLANNED'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_to_site_reserve_setup_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);  
   int_cust_no_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.supply_site = newrec_.demand_site) THEN
      Error_SYS.Record_General(lu_name_, 'DEMANDSAMEASSITE: The demand site should not be the same as the supply site');
   END IF;

   $IF (Component_Order_SYS.INSTALLED) $THEN
      int_cust_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(newrec_.demand_site);              
      IF (int_cust_no_ IS NULL) THEN
         Client_SYS.Add_Info(lu_name_, 'NO_INTERNAL_CUSTOMER: There is no internal customer defined for the demand site. Please update the connection between customer and the demand site before running the internal order flow.');
      END IF;
   $END
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_to_site_reserve_setup_tab%ROWTYPE,
   newrec_ IN OUT site_to_site_reserve_setup_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);   
   int_cust_no_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   $IF (Component_Order_SYS.INSTALLED) $THEN
      int_cust_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(newrec_.demand_site);               
      IF (int_cust_no_ IS NULL) THEN
         Client_SYS.Add_Info(lu_name_, 'NO_INTERNAL_CUSTOMER: There is no internal customer defined for the demand site. Please update the connection between customer and the demand site before running the internal order flow.');
      END IF;
   $END
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Supply_Site_Reserve_Db
--   Gets the DB value of the Supply Site Reserve Type.
@UncheckedAccess
FUNCTION Get_Supply_Site_Reserve_Db (
   supply_site_ IN VARCHAR2,
   demand_site_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SITE_TO_SITE_RESERVE_SETUP_TAB.supply_site_reserve_type%TYPE;
   CURSOR get_attr IS
      SELECT supply_site_reserve_type
      FROM SITE_TO_SITE_RESERVE_SETUP_TAB
      WHERE supply_site = supply_site_
      AND   demand_site = demand_site_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Supply_Site_Reserve_Db;


-- Connection_Allowed
--   Checks if there is a record exists for a given supply site and
--   a demand site.
@UncheckedAccess
FUNCTION Connection_Allowed (
   supply_site_ IN VARCHAR2,
   demand_site_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(supply_site_, demand_site_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Connection_Allowed;



