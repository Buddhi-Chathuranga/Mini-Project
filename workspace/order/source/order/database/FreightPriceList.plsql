-----------------------------------------------------------------------------
--
--  Logical unit: FreightPriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130121  RavDlk   SC2020R1-12047,Removed unnecessary packing and unpacking of attrubute string in Copy_Freight_List__
--  160601  MAHPLK   FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  140321  HimRlk   Added new parameter use_price_incl_tax_ to Get_Active_Freight_List_No().
--  140305  SURBLK   Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.--  130207  JeeJlk   Added new column USE_PRICE_INCL_TAX.
--  120127  ChJalk   Added column State to the view comments of base view.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111116  ChJalk   Modified the view FREIGHT_PRICE_LIST to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk   Modified the view FREIGHT_PRICE_LIST to use the user allowed company filter.
--  110323  NiBalk   EANE-4853, Removed user allowed site filter from where clause of view FREIGHT_PRICE_LIST.
--  110203  Nekolk   EANE-3744  added where clause to View FREIGHT_PRICE_LIST.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  091009  UtSwlk   Modified Copy_Freight_List__to copy data in zone info tab.
--  090825  ShKolk   Modified Unpack_Check_Insert___() added validation to the site and company.
--  090220  MaHplk   Added Forwarder ID to LU.
--  090210  ShKolk   Added validation to Prepare_Insert___() to check the company.
--  090102  ShKolk   Removed attribute min_freight_amount and Get_Min_Freight_Amount().
--  081008  MaJalk   Added method Copy_Freight_List__.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080918  MaJalk   Added Check_Restricted_Delete to Check_Delete___ and Do_Cascade_Delete to Delete___.
--  080917  MaJalk   Set default value for FREIGHT_BASIS.
--  080917  MaJalk   Added attribute min_freight_amount.
--  080915  MaJalk   Added attribute company.
--  080915  MaJalk   Removed NULL check for Price List No at Unpack_Check_Insert___.
--  080912  MaHplk   Modified view comment of zone_definition_id.
--  080825  RoJalk   Added Get_Objstate, renamed Active_Freight_List_Exists to
--  080825           Get_Active_Freight_List_No.
--  080828  RoJalk   Modified Unpack_Check_Insert___ to include some validations.
--  080828  RoJalk   Modified Prepare_Insert___ to set the default site.
--  080828  RoJalk   Modified Prepare_Insert___ to set the default site.
--  080822  RoJalk   Modified Unpack_Check_Update___  to stop the modification of Closed freight lists.
--  080822  RoJalk   Modified Unpack_Check_Insert___ and Insert___ to generate price_list_no using a sequence.
--  080822  RoJalk   Added methods Activate__  and Close__.
--  080815  RoJalk   Called Freight_Price_List_Base_API.Post_Insert_Actions__ from Insert___.
--  080815  RoJalk   Cretaed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_ VARCHAR2(2000);
BEGIN
   company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
   super(attr_);
   IF (company_ = Site_API.Get_Company(User_Allowed_Site_API.Get_Default_Site)) THEN
      Client_SYS.Add_To_Attr('CONTRACT', User_Allowed_Site_API.Get_Default_Site, attr_);
   END IF;
   Client_SYS.Add_To_Attr('FREIGHT_BASIS', Freight_Basis_API.Decode('WEIGHT_BASED'), attr_);
   Client_SYS.Add_To_Attr('FORWARDER_ID', '*', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(User_Allowed_Site_API.Get_Default_Site), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.price_list_no IS NULL) THEN
      newrec_.price_list_no := Freight_Price_List_Base_API.Get_Next_Price_List_No__();
   END IF;
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', newrec_.price_list_no, attr_);

   super(objid_, objversion_, newrec_, attr_);
   Freight_Price_List_Base_API.Post_Insert_Actions__(attr_, newrec_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   super(remrec_);
   Reference_SYS.Check_Restricted_Delete('FreightPriceListBase', key_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.price_list_no || '^';
   Reference_SYS.Do_Cascade_Delete('FreightPriceListBase', key_);
   super(objid_, remrec_);
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     freight_price_list_base_tab%ROWTYPE,
   newrec_ IN OUT freight_price_list_base_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF indrec_.use_price_incl_tax = FALSE OR newrec_.use_price_incl_tax IS NULL THEN
      newrec_.use_price_incl_tax := Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(User_Allowed_Site_API.Get_Default_Site);
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);    
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT freight_price_list_base_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
     
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (newrec_.company != Site_API.Get_Company(newrec_.contract)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTSAMECOMP: Site :P1 does not belong to the Company :P2.', newrec_.contract, newrec_.company);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     freight_price_list_base_tab%ROWTYPE,
   newrec_ IN OUT freight_price_list_base_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN

   IF (newrec_.rowstate = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when status is closed.');
   END IF;
   IF (indrec_.use_price_incl_tax) THEN
      IF (newrec_.rowstate = 'Active' ) THEN
         Freight_Price_List_Base_API.Check_Active_Price_List__(newrec_, attr_);
      END IF;      
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Freight_List__
--   Copies an Existing Freight Price List to a new one.
PROCEDURE Copy_Freight_List__ (
   to_price_list_no_    IN OUT VARCHAR2,
   price_list_no_       IN VARCHAR2,
   to_price_list_desc_  IN VARCHAR2,   
   valid_from_date_     IN DATE,
   to_valid_from_date_  IN DATE )
IS
   copyrec_      FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE;
   newrec_       FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE;

   CURSOR get_attr IS
      SELECT *
      FROM   freight_price_list_base_tab
      WHERE  price_list_no = price_list_no_;
BEGIN

   IF (to_valid_from_date_ IS NOT NULL) AND (valid_from_date_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'VALID_FROM_DT: The Valid From must be entered on the source freight price list when using Valid From on the destination freight price list.');
   END IF;

   -- Check if from freight price list exist
   IF (NOT Check_Exist___(price_list_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'NO_FREIGHT_LIST_EXIST: Freight price list :P1 does not exist.', price_list_no_);
   END IF;

   --From freight price list
   OPEN get_attr;
   FETCH get_attr INTO copyrec_;
   CLOSE get_attr;

   IF (to_price_list_no_ IS NOT NULL ) THEN
      -- Check if to freight price list already exists
      IF (Check_Exist___(to_price_list_no_)) THEN
         Error_SYS.Record_General(lu_name_, 'FREIGHT_LIST_EXIST: Freight price list :P1 already exist.', to_price_list_no_);
      END IF;
      newrec_.price_list_no := to_price_list_no_;
   END IF;
   
   newrec_.description := to_price_list_desc_;
   newrec_.freight_basis := copyrec_.freight_basis;
   newrec_.freight_map_id := copyrec_.freight_map_id;
   newrec_.charge_type := copyrec_.charge_type;
   newrec_.ship_via_code := copyrec_.ship_via_code;
   newrec_.company := copyrec_.company;
   newrec_.contract := copyrec_.contract;
   newrec_.forwarder_id := copyrec_.forwarder_id;
   newrec_.use_price_incl_tax := copyrec_.use_price_incl_tax;
   New___(newrec_);
   
   -- Copy all rows on freight price list-charges tab.
   Freight_Price_List_Line_API.Copy_All_Charges__(price_list_no_, to_price_list_no_, valid_from_date_, to_valid_from_date_);

   -- Copy all rows on freight price list-valid for site tab.
   Freight_Price_List_Site_API.Copy_All_Sites__(price_list_no_, to_price_list_no_);

   -- Copy all rows on freight price list-zone info tab.
   Freight_Price_List_Zone_API.Copy_All_Zone_Info__(price_list_no_, to_price_list_no_);
  
END Copy_Freight_List__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Active_Freight_List_No
--   Returns valid active price list found for the given contract, freight map id,
--   ship via code_ and/or vendor_no.
@UncheckedAccess
FUNCTION Get_Active_Freight_List_No (
   contract_      IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   zone_def_id_   IN VARCHAR2,
   forwarder_id_  IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Freight_Price_List_Base_API.Get_Active_Freight_List_No(contract_, ship_via_code_, zone_def_id_, forwarder_id_, use_price_incl_tax_);
END Get_Active_Freight_List_No;


@UncheckedAccess
FUNCTION Get_Objstate (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Freight_Price_List_Base_API.Get_Objstate(price_list_no_);
END Get_Objstate;



