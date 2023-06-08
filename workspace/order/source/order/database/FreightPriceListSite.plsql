-----------------------------------------------------------------------------
--
--  Logical unit: FreightPriceListSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130121  RavDlk   SC2020R1-12047,Removed unnecessary packing and unpacking of attrubute string in Copy_All_Sites__
--  111116  ChJalk   Modified the view FREIGHT_PRICE_LIST_SITE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk   Modified the base view FREIGHT_PRICE_LIST_SITE to use the user allowed company filter.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090220  MaHplk   Modified Validate___.
--    081008   MaJalk   Added method Copy_All_Sites__.
--    080919   MaJalk   Modified Error messages at method Validate___.
--    080918   MaJalk   Removed validation for active site at method Validate___.
--  080826  RoJalk   Modified Validate___.
--  080826  RoJalk   Modified Validate___.
--  080826  RoJalk   Added FUNCTION Check_Exist.
--  080825  MaJalk   Changed sales_charge_type_category to sales_chg_type_category.
--  080822  RoJalk   Modified Validate___.
--  080819  RoJalk   Modified Validate___.
--  080815  Rojalk   Added method Validate___ and called from Unpack_Check_Insert___.
--  080815  RoJalk   Cretaed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate___
--   Includes validations to be executed when adding a new record.
PROCEDURE Validate___ (
   newrec_ IN FREIGHT_PRICE_LIST_SITE_TAB%ROWTYPE )
IS
   freight_price_list_rec_   Freight_Price_List_Base_API.Public_Rec;
   sales_charge_type_rec_    Sales_Charge_Type_API.Public_Rec;
   company_                  VARCHAR2(20);
   active_price_list_no_     VARCHAR2(10);
BEGIN

   freight_price_list_rec_ := Freight_Price_List_Base_API.Get(newrec_.price_list_no);
   sales_charge_type_rec_  := Sales_Charge_Type_API.Get(newrec_.contract, freight_price_list_rec_.charge_type);

   IF (Freight_Price_List_Base_API.Get_Objstate(newrec_.price_list_no) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Sites can not be connected to a closed Freight Price List.');
   END IF;

   IF (Sales_Charge_Type_API.Check_Exist(newrec_.contract, freight_price_list_rec_.charge_type ) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'INVCHARGE: Charge Type :P1 is not defined for the Site :P2.', freight_price_list_rec_.charge_type , newrec_.contract);
   END IF;

   IF (sales_charge_type_rec_.sales_chg_type_category != 'FREIGHT') THEN
      Error_SYS.Record_General(lu_name_, 'CHGNOTFREIGHT: Charge Type :P1 should be of charge type category Freight.', freight_price_list_rec_.charge_type);
   END IF;

   IF (NOT (Freight_Zone_Valid_Site_API.Check_Exist(newrec_.contract, freight_price_list_rec_.freight_map_id ))) THEN
      Error_SYS.Record_General(lu_name_, 'INVSITE: The Site :P1 cannot be connected since it is not using Freight Map :P2.', newrec_.contract, freight_price_list_rec_.freight_map_id );
   END IF;

   IF (Freight_Price_List_Base_API.Get_Objstate(newrec_.price_list_no) = 'Active') THEN
      active_price_list_no_ := Freight_Price_List_Base_API.Get_Active_For_Site(newrec_.price_list_no, newrec_.contract, freight_price_list_rec_.ship_via_code, freight_price_list_rec_.forwarder_id, freight_price_list_rec_.use_price_incl_tax);
      IF (active_price_list_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ACTLISTFOUND: The site :P1 cannot be connected since the site is already connected to an active freight price list :P2 with the same ship-via, forwarder and usage of price including tax.', newrec_.contract, active_price_list_no_, freight_price_list_rec_.ship_via_code );
      END IF;
   END IF;

   company_ := Site_API.Get_Company(freight_price_list_rec_.contract);

   IF (company_  != (Site_API.Get_Company(newrec_.contract ))) THEN
      Error_SYS.Record_General(lu_name_, 'NOTSAMECOMP: Site :P1 does not belong to the Company :P2.', newrec_.contract, company_);
   END IF;

END Validate___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT freight_price_list_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Validate___(newrec_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_All_Sites__
--   Copies all Valid for Site records from one freight price list to another.
PROCEDURE Copy_All_Sites__ (
   price_list_no_    IN VARCHAR2,
   to_price_list_no_ IN VARCHAR2 )
IS
   newrec_       FREIGHT_PRICE_LIST_SITE_TAB%ROWTYPE;

   CURSOR    source IS
      SELECT *
      FROM   freight_price_list_site_tab
      WHERE  price_list_no = price_list_no_;
BEGIN

   -- Copy the lines
   FOR source_rec_ IN source LOOP
      IF NOT(Check_Exist___(to_price_list_no_, source_rec_.contract)) THEN
         newrec_.contract := source_rec_.contract;
         newrec_.price_list_no := to_price_list_no_;
         New___(newrec_);
      END IF;
   END LOOP;

END Copy_All_Sites__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   public interface provided to add a new record.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(32000);
   newrec_     FREIGHT_PRICE_LIST_SITE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the attribute values with the ones passed in the in parameter string.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Check_Exist
--   Returns TRUE if a record exist for the given price_list_no and contract.
@UncheckedAccess
FUNCTION Check_Exist (
   price_list_no_ IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Check_Exist___(price_list_no_, contract_));
END Check_Exist;



