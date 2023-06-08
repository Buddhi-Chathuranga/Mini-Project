-----------------------------------------------------------------------------
--
--  Logical unit: CustomerAgreementSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180119  CKumlk   STRSC-15930, Modified Check_Delete___ and Check_Insert___ by changing Get_State() to Get_Objstate(). 
--  170509  DilMlk   Bug 134573, Modified Check_Delete___() to check site is used in Service contract before deleting.
--  150914  MeAblk   Bug 124475, Override Check_Delete___ and modified Check_Insert___ in order to avoid make any update to the agreement when 
--  150914           it is in 'Closed' state.
--  111116  ChJalk   Modified the view CUSTOMER_AGREEMENT_SITE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111021  ChJalk   Modified the base view CUSTOMER_AGREEMENT_SITE to use the user allowed company filter.
--  080211  MaJalk   Added check for user allowed site at Check_Delete___. 
--  080208  MaJalk   Added User_Allowed_Site_API.Exist call to Unpack_Check_Insert___.
--  080123  MaJalk   Changed error message INVALSITE at Unpack_Check_Insert___.
--  071226  KiSalk   Added method Copy_All_Agreement_Sites__
--  071203  MaJalk   Modified Unpack_Check_Insert___ to validate contract.
--  071129  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_AGREEMENT_SITE_TAB%ROWTYPE )
IS
BEGIN
   IF (Customer_Agreement_API.Get_Objstate(remrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
   $IF Component_Srvcon_SYS.INSTALLED  $THEN
      Sc_Contract_Agreement_API.Check_Delete(remrec_.contract, remrec_.agreement_id);
   $END
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_agreement_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   company_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (Customer_Agreement_API.Get_Objstate(newrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   company_ := Customer_Agreement_API.Get_Company(newrec_.agreement_id);
   IF (NVL(Site_API.Get_Company(newrec_.contract), ' ') != company_) THEN
      Error_SYS.Record_General(lu_name_, 'INVALSITE: Site :P1 is not connected to company :P2 and can not be added to the agreement.',newrec_.contract, company_);
   END IF;
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_All_Agreement_Sites__ (
   from_agreement_id_   IN VARCHAR2,
   to_agreement_id_     IN VARCHAR2 )
IS
   attr_            VARCHAR2(32000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          CUSTOMER_AGREEMENT_SITE_TAB%ROWTYPE;
   indrec_          Indicator_Rec;

   CURSOR    source IS
      SELECT *
      FROM CUSTOMER_AGREEMENT_SITE_TAB
      WHERE agreement_id = from_agreement_id_;
BEGIN   
   -- Copy the lines 
   FOR source_rec_ IN source LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', source_rec_.contract, attr_);
      Client_SYS.Add_To_Attr('AGREEMENT_ID', to_agreement_id_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      Reset_Indicator_Rec___(indrec_);
   END LOOP;
END Copy_All_Agreement_Sites__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   agreement_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, agreement_id_);
END Check_Exist;


PROCEDURE New (
   agreement_id_  IN  VARCHAR2,
   contract_      IN  VARCHAR2 )
IS
   objid_      CUSTOMER_AGREEMENT_SITE.objid%TYPE;
   objversion_ CUSTOMER_AGREEMENT_SITE.objversion%TYPE;
   newrec_     CUSTOMER_AGREEMENT_SITE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);   
END New;



