-----------------------------------------------------------------------------
--
--  Logical unit: PackSizeChargeListSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180119  CKumlk   STRSC-15930, Modified Check_Insert___ by changing Get_State() to Get_Objstate(). 
--  111116  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST_SITE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST_SITE to use the user allowed company filter.
--  090930  DaZase   Added length on view comment for charge_list_no.
--  081126  MaJalk   Modified error message PLINVALIDSITE.
--    081007   MaJalk   At Unpack_Check_Insert___, modified error messages.
--    080815   MaJalk   Added validations for site at Unpack_Check_Insert___.
--    080806   MaJalk   Added methods New and Check_Site_Exist.
--    080730   MaJalk   Added error message INVALSITE2 to Unpack_Check_Insert___.
--  080630  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pack_size_charge_list_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   charge_list_no_   VARCHAR2(10);
   head_rec_         Pack_Size_Charge_List_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);

   head_rec_ := Pack_Size_Charge_List_API.Get(newrec_.charge_list_no);
   
   IF (Sales_Charge_Type_API.Get_Unit_Charge_Db(newrec_.contract, head_rec_.charge_type) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'INVALSITE: Unit charge is not enabled for the charge type :P1 at site :P2.', head_rec_.charge_type, newrec_.contract);
   END IF;

   IF (Sales_Charge_Type_API.Check_Exist(newrec_.contract, head_rec_.charge_type) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'INVALSITE2: The charge type :P1 does not exist in site :P2.', head_rec_.charge_type, newrec_.contract);
   END IF;

   IF (NVL(Site_API.Get_Company(newrec_.contract), ' ') != head_rec_.company) THEN
      Error_SYS.Record_General(lu_name_, 'PLINVALIDSITE: Site :P1 is not connected to company :P2 and cannot be added to the pack size charge price list.',newrec_.contract, head_rec_.company);
   END IF;

   IF NOT(Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, head_rec_.charge_type) = 'PACK_SIZE') THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: The sales charge type :P1 does not exist as a pack size charge for the site :P2.',head_rec_.charge_type, newrec_.contract);
   END IF;
   
   IF (Pack_Size_Charge_List_API.Get_Objstate(newrec_.charge_list_no) = 'Active') THEN
      charge_list_no_ := Pack_Size_Charge_List_API.Get_Active_Chg_List_For_Site(newrec_.contract, sysdate, head_rec_.use_price_incl_tax);
      IF (newrec_.charge_list_no != NVL(charge_list_no_, newrec_.charge_list_no)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALSITE3: The site :P1 cannot be connected since the site is already connected to an active pack size charge price list :P2 with the same period and usage of price including tax.', newrec_.contract, charge_list_no_);
      END IF;
   END IF;
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public interface for create new valid for site.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     PACK_SIZE_CHARGE_LIST_SITE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   -- Retrieve the default attribute values.
   Client_SYS.Add_To_Attr('CHARGE_LIST_NO', Client_SYS.Get_Item_Value('CHARGE_LIST_NO', attr_), new_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', Client_SYS.Get_Item_Value('CONTRACT', attr_), new_attr_);
   
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the default attribute values with the ones passed in the in parameter string.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Check_Site_Exist
--   Check for existence for a site.
@UncheckedAccess
FUNCTION Check_Site_Exist (
   charge_list_no_ IN VARCHAR2,
   contract_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM PACK_SIZE_CHARGE_LIST_SITE_TAB
      WHERE charge_list_no = charge_list_no_
      AND   contract       = contract_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Site_Exist;



