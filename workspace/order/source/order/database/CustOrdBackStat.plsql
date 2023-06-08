-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdBackStat
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120130  MaRalk  Umcommented view column comments of CUST_ORD_BACK_STAT-objstate, state columns
--  120130          to avoid model errors generated from PLSQL implementation test.
--  110131  Nekolk  EANE-3744  added where clause to View CUST_ORD_BACK_STAT.
--  060601  MiErlk  Enlarge Identity - Changed view comments Description.
--  060418  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  040218  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes----------------------  
--  021205  GaSolk Added ADDITIONAL_DISCOUNT and ADDITIONAL_CURR_DISCOUNT to the LU.
--  991007  JoEd   Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990609  JakH   Changed prompts.
--  990406  JakH   New templates.
--  990319  JakH   CID 12678 Added rowstate from customer order line to backlog
--  990204  JoEd   Run through Design.
--  981029  KaSu   Renamed the prompt contract as Site.
--                 Renamed the prompts with name Catalog as name with Sales Part.
--  981022  Reza   General_SYS.Init_Method() has been included in the necessary Procedures
--  98xxxx  xxxx   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_ord_back_stat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (Client_Sys.Item_Exist('STATE',attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'STATE');
   END IF;
   
   super(newrec_, indrec_, attr_); 
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_ord_back_stat_tab%ROWTYPE,
   newrec_ IN OUT cust_ord_back_stat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (Client_Sys.Item_Exist('STATE',attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'STATE');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);  
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


