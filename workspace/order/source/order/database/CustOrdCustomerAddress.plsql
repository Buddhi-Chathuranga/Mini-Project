-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdCustomerAddress
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200104  NiDalk  SC2020R1-10813, Modified Copy_Customer to transfer correct address id when Modify_Cust_Addr_Details___ is called
--  201126  MaEelk  SC2020R1-11396, Replaced the method call Customer_Info_Address_Type_API.Check_Exist with Customer_Info_Address_Type_API.Exists_Db
--  201126          in Is_Ship_Location and Is_Bill_Location. Added two methods Is_Valid_Ship_Location and Is_Valid_Bill_Location
--  200714  Skanlk  Bug 154301(SCZ-10343), Added a new method Modify_Cust_Addr_Details___. Modified Copy_Customer() method by removing the call to the
--  200714          Remove__ method and added Modify_Cust_Addr_Details___ method on it to solve the error when changing Customer Category from Prospect to Customer.
--  190125  MiKulk  Added the reord type Customer_Info_Address_Rec and function Get_Customer_Info_Address for performance testing.
--  180221  ErFelk  STRSC-17278, Modified Copy_Customer() to update the record if it is already been created. 
--  170208  ErFelk  Bug 132505, Added Method Set_End_Cust_Ord_Addr_Info() to set the Ship via, Delivery Terms and Delivery Location 
--  170208          when the End Customer is changed or entered. This is called from Customer_Info_Address_API in ENTERP. 
--  161129  NWeelk  FINHR-2035, Removed methods Get_Vat and Get_Vat_Db.
--  160608  MaIklk  LIM-7442, Checked delivery notes exist when deleting address record.
--  160517  Chgulk  STRLOC-80, Added New address fields.
--  151210  MaIklk  LIM-4060, Checked whether any shipment exists for given address no in check_delete.
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150708  Wahelk  BLU-956, Added new method Copy_Customer_Def_Address
--  150706  Wahelk  BLU-956, Added new paremeter to Copy_Customer method 
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140714  MAHPLK  PRSC-427, Removed Get_Company_Name2 and Modify_Company_Name
--  140710  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  140313  MiKulk   Modified the Copy_Customer method by adding only the relevent attribute to the attr_.
--  130226  SALIDE  EDEL-2020, Set the value of company_name2 with the name from Customer Info Address.
--  130104  MaIklk  Handled to check order quotation references when deleting.
--  130805  MeAblk  Removed attribute shipment_measure_edit, multi_lot_batch_per_pallet and related get method.
--  130705  MAHPLK  Removed load sequence no from LU.
--  130417  MaMalk  Removed Shipment_Creation attribute due to the introduction of Shipment_Type.
--  130405  MaMalk  Added Shipment_Type attribute to remove the Shipment_Creation since we are moving Shipment_Creation to Shipment Type.
--  121226  AyAmlk  Bug 107422, Added COUNTRY to the views CUST_ADDRESS_SHIP_LOV and CUST_BILL_ADDRESS_LOV.
--  121109  MaRalk  Modified method Prepare_Insert___ to fetch the end customer's name as customer name when an end customer is connected.
--  121026  MaRalk  Added methods Modify_Company_Name and Check_Exist.
--  120412  AyAmlk  Bug 100608, Increased the column length of delivery_terms to 5 in views CUST_ORD_CUSTOMER_ADDRESS, CUST_ORD_CUSTOMER_ADDRESS_ENT.
--  110914  HimRlk  Bug 98108, Added new lov view CUST_BILL_ADDRESS_LOV for document address.
--  110331  AndDse  BP-4734, Added info message if customer calendar is in status pending.
--  110314  UTSWLK  Added method Check_Cust_Calendar_Id_Entered.
--  101222  MiKulk  Added the new parameter supply_country_ for the method Get_Vat_Db.
--  101203  AndDse  BP-3485, Added column CUST_CALENDAR_ID to CUST_ORD_CUSTOMER_ADDRESS_TAB. Added procedure Check_Cust_Address_Values___ and use this for check.
--  100520  KRPELK  Merge Rose Method Documentation.
--  090923  MaMalk  Removed unused function Leadtime_Exists___. Modified Get_Email to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090824  PraWlk  Bug 84866, Modified Check_Delete___ to avoid deleting an address used in customer invoice.
--  080605  SaJjlk  Bug 74521, Modified method Get_Email to use method Contact_Util_API.Get_Cust_Comm_Method_Value.
--  080201  ChJalk  Bug 70889, Added new method Get_Email.
--  080130  NaLrlk  Bug 70005, Added the public attribute del_terms_location.
--  080112  ChJalk  Bug 70522, Modified Unpack_Check_Insert__ to correct the parameters passing into NVL.
--  070218  SaJjlk  Modified method Prepare_Insert___ to correctly set default values for SHIPMENT_MEASURE_EDIT_DB and SHIPMENT_UNCON_STRUCT_DB. 
--  070215  RaNhlk  Modified prepare_Insert__ to add SHIPMENT_MEASURE_EDIT_DB and SHIPMENT_UNCON_STRUCT_DB to attr_. 
--  070213  RaNhlk  Modified Unpack_Check_Insert__ to set default value to shipment_measure_edit and shipment_uncon_struct.
--  070128  RaNhlk  Added columns shipment_measure_edit and shipment_uncon_struct.
--  070125  SaJjlk  Increased length of column SHIPMENT_CREATION on view 
--  070125          CUST_ORD_CUSTOMER_ADDRESS and CUST_ORD_CUSTOMER_ADDRESS_ENT.
--  070119  RoJalk  Removed not-null check for the deliver delivery_terms_desc.
--  060823  MiKulk  Modified the method Copy_Customer, to copy the supply chain parameteres also.
--  060518  RaKalk  Bug 57776, Added ZIP CODE field to views CUST_ADDRESS_SHIP_LOV and CUST_ADDRESS_BILL_LOV.
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060417  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060320  RaKalk   Modified Copy_Customer procedure to copy the MULTI_LOT_BATCH_PER_PALLET field
--  060316   RaKalk   Modified Unpack_Check_Insert___ to set default value FALSE to Multi_Lot_Batch_Per_Pallet field
--  060315   RaKalk   Added Multi_Lot_Batch_Per_Pallet field and Get_Multi_Lot_Batch_Per_Pal_Db function
--  051005  MaJalk  Bug 53652, Added city to VIEWSHIP, VIEWBILL, VIEWPAYER and VIEW_MATRIX.
--  050802  KiSalk  Bug 51603, In CUST_ORD_CUSTOMER_ADDRESS's view comment reference of
--  050802          addr_no to CustomerInfoAddress, changed to 'CASCADE'.
--  050103  JaBalk  Small modification after code review.
--  041223  JaBalk  Added Shipment_Creation db column.
--  041007  DaRulk  Bug 47310, Changes in CUST_ADDRESS_MATRIX_LOV.
--  040722  IsWilk  Added the FUNCTION Get_Intrastat_Exempt_Db.
--  040218  IsWilk  Removed the SUBSTRB from the view and modified SUBSTRB to SUBSTR in the views for Unicode Changes.
--  -------------------------------- 13.3.0 -------------------------------------------
--- 031030  DaZa    Added extra checks for delivery_time in Unpack_Check_Insert___/Update___.
--  030820  UdGnlk  Performed CR Merge and move the public view CUST_ORD_CUSTOMER_ADDRESS_PUB
--                  to the CustOrdCustomerAddress API.
--  030807  ChBalk  Removed entry to 'Customer_Address_Leadtime_API.New' from Update___.
--  030725  WaJalk  Added view CUST_ADDRESS_MATRIX_LOV.
--  030702  NuFilk  Removed Insert into Leadtime tabs in method Insert___.
--  030507  ChBalk  Added call to SiteToSiteLeadtimeAPI.New
--  **************** CR Merge ***********************************************
--  021211  Asawlk Merged bug fixes in 2002-3 SP3
--  021003  GaJalk Bug 32993, Added functions Is_Default_Pay_Location__ and Is_Pay_Location.
--  020307  PerK  Added Get_County
--  010917  JICE  Added public view CUST_ORD_CUSTOMER_ADDRESS_PUB.
--  010314  MaGu  Bug fix 19177. Corrected view comments for intrastat_exempt in
--                CUST_ORD_CUSTOMER_ADDRESS_ENT.
--  010216  MaGu  Bug fix 19177. Added public attribute intrastat_exempt.
--  001015  CaSt  Added public method Modify.
--  001013  CaSt  Added public method Remove.
--  000914  MaGu  Added get functions for new address columns.
--  000913  FBen  Added UNDEFINE.
--  000511  DaZa  Made contact public, added methods Get_Contact and public New.
--  000119  JoEd  Added methods Get_Vat and Get_Vat_Db.
--                Also changed Copy_Customer to use a for loop instead of while.
--  --------------------- 12.0 ----------------------------------------------
--  991111  PaLj  Added Method Copy_Customer
--  991022  JoEd  Increased length of company_name2 column.
--  991007  JoEd  Corrected double-byte problems.
--  991005  JoEd  Added VIEWPAYER for customer_no_pay LOV in frmCustomerOrder
--                client form.
--  --------------------------- 11.1 ----------------------------------------
--  990614  JoEd  Added functions Is_Visit_Location and Is_Default_Visit_Location__.
--  990420  RaKu  Replaces view-call CUSTOMER_ADDRESS_LEADTIME with CUSTOMER_ADDRESS_LEADTIME_TAB.
--  990419  JoAn  Route Id and Load Sequence No allowed for all ship locations
--                not just the default ship location.
--  990409  JakH  New template.
--  990126  JoEd  Added public attribute delivery_time.
--                Changed default value on Is_Valid.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  981202  JoEd  Changed calls to Enterprise.
--  981005  RaKu  Added functoin Get_Ean_Location. Added contract in calls to Customer_Address_Leadtime.
--  980413  RaKu  SID 3382. Added check for LoadSequence in Unpack_Check_Insert___/Update___.
--  980408  JoAn  SID 2154 Added check for valid date to address LOV:s
--  980319  JoAn  Added function Is_Valid
--  980224  RaKu  Added function Get_Id_By_Ean_Location.
--  980204  KaAs  Add Get_load_sequence_no.
--  980129  KaAs  Add control of route. IF route be changed  THEN load sequence will be reset
--                to 0 othewise nothing will be happend.
--  980119  KaAs  Add route id och load sequence no in both view.
--  971124  RaKu  Changed to FND200 Templates.
--  971027  JoAn  Converted Is_Ship_Location__ and Is_Bill_Location__ to public.
--  971020  JoAn  Reverted changes in Is_Ship_Location__ and Is_Bill_Location__.
--                Added Is_Default_Ship_Location__ and Is_Default_Bill_Location__.
--  970916  RaKu  Changed Is_Ship_Location__ and Is_Ship_Location__. Calls
--                Is_Type_Default instead of Is_Type.
--  970925  JoAn  Changed Exist to return more descriptive error message
--  970916  JoAn  Removed reference to CustOrdCustomer
--  970908  RaKu  Made changes in comments.
--  970826  JoAn  Changes due to integration with Enterprise.
--                Removed columns stored in Enterprise or Invoice module.
--                Removed Modify_Or_New_Leadtime, Added Leadtime_Exists___
--  970605  PAZE  Added country_code not null check.
--  970604  JoEd  Changed Get_... functions
--  970604  PAZE  Country_code set to required.
--  970530  JoEd  Changed LOV flags and prompt of the columns.
--  970527  JoEd  Moved call to Leadtime from client CustomerAddress form.
--                Added call to Remove of leadtime when removing address.
--  970522  JoAn  Changed name of cursor get_addr in Get_.. methods to get_attr
--  970521  JoEd  Rebuild Get_.. methods calling Get_Instance___.
--                Added .._db columns in the view for all IID columns.
--  970508  PAZE  Changed language_code length.
--                Reference MPCcomCountry changed to ApplicationCountry and
--                MPCcom_Country_API to Application_Country_API.
--  970325  JoEd  BUG 97-0021. Added two new LOV views. New template.
--  970312  RaKu  Changed tablename.
--  970220  RaKu  Added company in Insert___. Was removed by mistake.
--  970219  PAZE  Changed rowversion (10.3 project).
--  970206  RaKu  Added function-column language_code. BUG 97-0002 and 97-0003
--  970206  ASBE  BUG 97-0010 At least one address type must be selected. Added
--                error message ADDRESSTYPE.
--  960216  JOLA  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Customer_Info_Address_Rec IS RECORD
  (customer_no                    CUSTOMER_INFO_ADDRESS_TAB.customer_id%TYPE,
   address_no                     CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE,
--   "rowid"                        rowid,
--   rowversion                     CUSTOMER_INFO_ADDRESS_TAB.rowversion%TYPE,
--   rowkey                         CUSTOMER_INFO_ADDRESS_TAB.rowkey%TYPE,
   name                           CUSTOMER_INFO_ADDRESS_TAB.name%TYPE,
   address                        CUSTOMER_INFO_ADDRESS_TAB.address%TYPE,
--   ean_location                   CUSTOMER_INFO_ADDRESS_TAB.ean_location%TYPE,
--   valid_from                     CUSTOMER_INFO_ADDRESS_TAB.valid_from%TYPE,
--   valid_to                       CUSTOMER_INFO_ADDRESS_TAB.valid_to%TYPE,
--   party                          CUSTOMER_INFO_ADDRESS_TAB.party%TYPE,
   country                        CUSTOMER_INFO_ADDRESS_TAB.country%TYPE,
--   party_type                     CUSTOMER_INFO_ADDRESS_TAB.party_type%TYPE,
--   secondary_contact              CUSTOMER_INFO_ADDRESS_TAB.secondary_contact%TYPE,
--   primary_contact                CUSTOMER_INFO_ADDRESS_TAB.primary_contact%TYPE,
   address1                       CUSTOMER_INFO_ADDRESS_TAB.address1%TYPE,
   address2                       CUSTOMER_INFO_ADDRESS_TAB.address2%TYPE,
   address3                       CUSTOMER_INFO_ADDRESS_TAB.address3%TYPE,
   address4                       CUSTOMER_INFO_ADDRESS_TAB.address4%TYPE,
   address5                       CUSTOMER_INFO_ADDRESS_TAB.address5%TYPE,
   address6                       CUSTOMER_INFO_ADDRESS_TAB.address6%TYPE,
   zip_code                       CUSTOMER_INFO_ADDRESS_TAB.zip_code%TYPE,
   city                           CUSTOMER_INFO_ADDRESS_TAB.city%TYPE,
   county                         CUSTOMER_INFO_ADDRESS_TAB.county%TYPE,
   state                          CUSTOMER_INFO_ADDRESS_TAB.state%TYPE,
   in_city                        CUSTOMER_INFO_ADDRESS_TAB.in_city%TYPE
--   jurisdiction_code              CUSTOMER_INFO_ADDRESS_TAB.jurisdiction_code%TYPE,
--   comm_id                        CUSTOMER_INFO_ADDRESS_TAB.comm_id%TYPE,
--   output_media                   CUSTOMER_INFO_ADDRESS_TAB.output_media%TYPE,
--   end_customer_id                CUSTOMER_INFO_ADDRESS_TAB.end_customer_id%TYPE,
--   end_cust_addr_id               CUSTOMER_INFO_ADDRESS_TAB.end_cust_addr_id%TYPE,
--   customer_branch                CUSTOMER_INFO_ADDRESS_TAB.customer_branch%TYPE
);

TYPE Customer_Order_Address_Arr IS TABLE OF Customer_Info_Address_Rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Cust_Address_Values___ (
   newrec_    IN CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE,
   oldrec_    IN CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE )
IS
BEGIN

   IF (Is_Ship_Location(newrec_.customer_no, newrec_.addr_no) = 0) THEN
      IF (newrec_.delivery_time IS NOT NULL) THEN
         Error_SYS.Item_General(lu_name_, 'DELIVERY_TIME', 'NOSHIPADDR: This address is not a delivery address. [:NAME] may not be specified.');
      END IF;
   END IF;

   Cust_Ord_Customer_API.Validate_Customer_Calendar(newrec_.customer_no, newrec_.cust_calendar_id, TRUE);
   
END Check_Cust_Address_Values___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   
BEGIN   
   super(attr_);   
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'INCLUDE', attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_UNCON_STRUCT_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS    
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.cust_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.cust_calendar_id);
   END IF; 
    

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE,
   newrec_     IN OUT CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (to_char(newrec_.delivery_time, 'HH24:MI:SS') = '00:00:00') AND ((to_char(oldrec_.delivery_time, 'HH24:MI:SS') != '00:00:00') OR (oldrec_.delivery_time IS NULL)) THEN
      Client_SYS.Add_Info(lu_name_, 'ZERODELIVERYTIME: Delivery Time 00:00:00 will be considered as no specific delivery time, since this is the time specification set on all delivery dates.');
   END IF;

   IF (NVL(newrec_.cust_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.cust_calendar_id, Database_Sys.string_null_)) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.cust_calendar_id);
   END IF;   
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE )
IS
   quote_count_   NUMBER;
   ref_lu_prompt_ VARCHAR2(2000);
BEGIN
   super(remrec_);   
   -- Check Shipment exist for the given customer address
   Shipment_API.Check_Exist_By_Address(Sender_Receiver_Type_API.DB_CUSTOMER, remrec_.customer_no, remrec_.addr_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);   
   -- Check Order quotation record is used,
   quote_count_ := Order_Quotation_API.Get_Ship_Address_Count(remrec_.customer_no, remrec_.addr_no);
   IF ( quote_count_ > 0 ) THEN
      ref_lu_prompt_ := Language_SYS.Translate_Lu_Prompt_('OrderQuotation');
      Error_SYS.Record_Constraint(lu_name_, ref_lu_prompt_, to_char(quote_count_), NULL, remrec_.customer_no );
   END IF;   
    -- Check Order quotation line records are used,
   quote_count_ := Order_Quotation_Line_API.Get_Ship_Address_Count(remrec_.customer_no, remrec_.addr_no);
   IF ( quote_count_ > 0 ) THEN
      ref_lu_prompt_ := Language_SYS.Translate_Lu_Prompt_('OrderQuotationLine');
      Error_SYS.Record_Constraint(lu_name_, ref_lu_prompt_, to_char(quote_count_), NULL, remrec_.customer_no );
   END IF;
   -- Check any delivery notes exist
   Deliver_Customer_Order_API.Check_Del_Note_Addr_No(remrec_.customer_no, remrec_.addr_no);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE )
IS
BEGIN
   IF (Customer_Order_Inv_Head_API.Inv_Address_Exist(remrec_.customer_no, remrec_.addr_no))THEN
      Error_SYS.Record_General(lu_name_, 'INVOICEEXISTS: The customer address is being used in customer invoice(s), and therefore cannot be removed.');
   END IF;
   Reference_SYS.Check_Restricted_Delete(lu_name_, remrec_.customer_no || '^' || remrec_.addr_no || '^');
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_ord_customer_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_    CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;   
BEGIN
   oldrec_ := newrec_;  
   IF (newrec_.customer_no IS NULL) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   END IF;
   IF(Client_SYS.Item_Exist('ADDRESS_ID', attr_)) THEN
      newrec_.addr_no := Client_SYS.Get_Item_Value('ADDRESS_ID', attr_);
      Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.addr_no);
   END IF; 

   newrec_.intrastat_exempt            := NVL(newrec_.intrastat_exempt,'INCLUDE');
   newrec_.shipment_uncon_struct       := NVL(newrec_.shipment_uncon_struct,'FALSE');

   super(newrec_, indrec_, attr_);

   Check_Cust_Address_Values___(newrec_, oldrec_);

   IF (to_char(newrec_.delivery_time, 'HH24:MI:SS') = '00:00:00') THEN
      Client_SYS.Add_Info(lu_name_, 'ZERODELIVERYTIME: Delivery Time 00:00:00 will be considered as no specific delivery time, since this is the time specification set on all delivery dates.');
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_ord_customer_address_tab%ROWTYPE,
   newrec_ IN OUT cust_ord_customer_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF(Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CUSTOMER_ID');
   END IF;
   IF(Client_SYS.Item_Exist('ADDRESS_ID', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'ADDRESS_ID');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   Check_Cust_Address_Values___(newrec_, oldrec_);
END Check_Update___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Is_Default_Bill_Location__
--   Check if the specified address has been specified as the default bill
--   location, return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Default_Bill_Location__ (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Is_Default(customer_no_, addr_no_, Address_Type_Code_API.Decode('INVOICE')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Default_Bill_Location__;


-- Is_Default_Ship_Location__
--   Check if the specified address has been specified as the default delivery
--   location, return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Default_Ship_Location__ (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Is_Default(customer_no_, addr_no_, Address_Type_Code_API.Decode('DELIVERY')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Default_Ship_Location__;


-- Is_Default_Visit_Location__
--   Check if the specified address has been specified as the default visit
--   location, return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Default_Visit_Location__ (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Is_Default(customer_no_, addr_no_, Address_Type_Code_API.Decode('VISIT')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Default_Visit_Location__;


-- Is_Default_Pay_Location__
--   Check if the specified address has been specified as the default pay location,
--   return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Default_Pay_Location__ (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Is_Default(customer_no_, addr_no_, Address_Type_Code_API.Decode('PAY')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Default_Pay_Location__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
PROCEDURE Exist (
   customer_no_ IN VARCHAR2,
   addr_no_ IN VARCHAR2 )
IS
BEGIN
   Customer_Info_Address_API.Exist(customer_no_, addr_no_);
   IF (NOT Check_Exist___(customer_no_, addr_no_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'ORDERADDRATTR: Order attributes are missing for customer :P1 address number :P2',
      customer_no_, addr_no_);
   END IF;   
   super(customer_no_, addr_no_);
END Exist;


-- Check_Cust_Calendar_Id_Entered
--   Returns 1 if there is a cust_calendar_id entered in any address for the customer.
@UncheckedAccess
FUNCTION Check_Cust_Calendar_Id_Entered (
   customer_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_     NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE customer_no = customer_no_
      AND   cust_calendar_id IS NOT NULL;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN NVL(temp_, 0);
END Check_Cust_Calendar_Id_Entered;


-- Get_Addr_1
--   Returns addr_1
@UncheckedAccess
FUNCTION Get_Addr_1 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 1);
END Get_Addr_1;


-- Get_Addr_2
--   Returns addr_2
@UncheckedAccess
FUNCTION Get_Addr_2 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 2);
END Get_Addr_2;


-- Get_Addr_3
--   Returns addr_3
@UncheckedAccess
FUNCTION Get_Addr_3 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 3);
END Get_Addr_3;


-- Get_Addr_4
--   Returns addr_4
@UncheckedAccess
FUNCTION Get_Addr_4 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 4);
END Get_Addr_4;


-- Get_Addr_5
--   Returns addr_5
@UncheckedAccess
FUNCTION Get_Addr_5 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 5);
END Get_Addr_5;

@UncheckedAccess
FUNCTION Get_Addr_6 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 6);
END Get_Addr_6;

@UncheckedAccess
FUNCTION Get_Addr_7 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 7);
END Get_Addr_7;

@UncheckedAccess
FUNCTION Get_Addr_8 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 8);
END Get_Addr_8;

@UncheckedAccess
FUNCTION Get_Addr_9 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 9);
END Get_Addr_9;

@UncheckedAccess
FUNCTION Get_Addr_10 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Line(customer_no_, addr_no_, 10);
END Get_Addr_10;

-- Get_Country_Code
--   Return the country code retrieved from Enterprise
@UncheckedAccess
FUNCTION Get_Country_Code (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Country_API.Encode(Customer_Info_Address_API.Get_Country(customer_no_, addr_no_));
END Get_Country_Code;


-- Is_Bill_Location
--   Check if the specified address has been specified as a bill location,
--   return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Bill_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Exists_Db(customer_no_, addr_no_, 'INVOICE')) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Bill_Location;


-- Is_Ship_Location
--   Check if the specified address has been specified as a delivery location,
--   return TRUE if this is the case FALSE if not.
--   Check if the specified address has been specified as a visit location,
--   return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Ship_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Exists_Db(customer_no_, addr_no_, 'DELIVERY')) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Ship_Location;


@UncheckedAccess
FUNCTION Is_Visit_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Check_Exist(customer_no_, addr_no_, Address_Type_Code_API.Decode('VISIT')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Visit_Location;


-- Is_Valid
--   Check if the specified address is valid at the specified date.
--   return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Valid (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2,
   check_date_  IN DATE DEFAULT NULL ) RETURN NUMBER
IS
   date_  DATE := nvl(check_date_, Site_API.Get_Site_Date(User_Default_API.Get_Contract));
BEGIN
   IF (Customer_Info_Address_API.Is_Valid(customer_no_, addr_no_, date_) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Valid;


-- Get_Id_By_Ean_Location
--   Return the address id of the address conneced to the specified
--   EAN location number.
@UncheckedAccess
FUNCTION Get_Id_By_Ean_Location (
   customer_no_  IN VARCHAR2,
   ean_location_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Id_By_Ean_Location(customer_no_, ean_location_);
END Get_Id_By_Ean_Location;


-- Get_Ean_Location
--   Return the EAN location of the address conneced to the specified
--   customer no and address no.
@UncheckedAccess
FUNCTION Get_Ean_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Ean_Location(customer_no_, addr_no_);
END Get_Ean_Location;


-- Copy_Customer
--   Copies the customer information in CustOrdCustomerAddressTab to a new customer id
PROCEDURE Copy_Customer (
   customer_id_         IN VARCHAR2,
   new_id_              IN VARCHAR2,
   copy_info_           IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_                    VARCHAR2(100);
   objversion_               VARCHAR2(200);
   attr_                     VARCHAR2(2000);
   indrec_                   Indicator_Rec;
   newrec_                   CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   new_del_address_          CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   
   CURSOR get_attr IS
      SELECT *
        FROM CUST_ORD_CUSTOMER_ADDRESS_TAB
        WHERE customer_no = customer_id_; 

   CURSOR get_def_attr IS
      SELECT *
      FROM CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE customer_no = customer_id_
      AND  addr_no = copy_info_.temp_del_addr;
BEGIN
  IF (copy_info_.copy_convert_option = 'CONVERT' ) THEN 
      new_del_address_ := nvl(copy_info_.new_del_address,copy_info_.temp_del_addr);
      IF (copy_info_.temp_del_addr IS NOT NULL) THEN
         FOR def_ IN get_def_attr LOOP
            --overwrite exsiting
            IF (Check_Exist___(new_id_, new_del_address_)) THEN
               Client_SYS.Clear_Attr(attr_);
               attr_ := Pack___(def_);
               Modify_Cust_Addr_Details___(attr_, new_id_, new_del_address_);
            ELSE
               Client_SYS.Clear_Attr(attr_);
               attr_ := Pack___(def_);
               Client_SYS.Set_Item_Value('CUSTOMER_NO',new_id_,attr_);
               Client_SYS.Set_Item_Value('ADDR_NO',new_del_address_,attr_);
               Unpack___(newrec_, indrec_, attr_);
               Check_Insert___(newrec_, indrec_, attr_);
               Insert___(objid_, objversion_, newrec_, attr_);
            END IF;
         END LOOP;
      END IF;
  ELSE
      --copy customer 
      FOR rec_ IN get_attr LOOP
         Client_SYS.Clear_Attr(attr_);
         attr_ := Pack___(rec_);
         IF (Cust_Ord_Customer_Address_API.Exists( new_id_, rec_.addr_no)) THEN 
            -- When an end customer is connected to a customer, during the coping process the new customer 
            -- record will get insert through Customer_Info_Address_API before coming to this method.
            -- Therefore it is necessary to check wheather a record exist from the new_id and do an update.
               Modify_Cust_Addr_Details___(attr_, new_id_, rec_.addr_no);
         ELSE
            Client_SYS.Set_Item_Value('CUSTOMER_NO',new_id_,attr_);
            Unpack___(newrec_, indrec_, attr_);
            Check_Insert___(newrec_, indrec_, attr_);
            Insert___(objid_, objversion_, newrec_, attr_);
         END IF;
      END LOOP;
   END IF;

   Client_SYS.Clear_Info;
END Copy_Customer;

PROCEDURE Modify_Cust_Addr_Details___ (
   attr_                IN OUT VARCHAR2,
   customer_no_         IN VARCHAR2,
   addr_no_             IN VARCHAR2)
IS
   newrec_              CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   oldrec_              CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   dummy_               VARCHAR2(32000);
   objid_               VARCHAR2(100);
   objversion_          VARCHAR2(200);
   indrec_              Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_);            
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_no_, addr_no_);
   newrec_ := oldrec_;
   -- When updating keys needs to be removed from the attr.
   dummy_ := Client_SYS.Cut_Item_Value('CUSTOMER_NO', attr_);
   dummy_ := Client_SYS.Cut_Item_Value('ADDR_NO', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Cust_Addr_Details___;

-- New
--   Public new method
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   -- Retrieve default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the default attribute values with the ones passed in the inparameter string.
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


-- Get_Name
--   Returns name
@UncheckedAccess
FUNCTION Get_Name (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Name(customer_no_, addr_no_);
END Get_Name;


-- Get_Address1
--   Returns address1
@UncheckedAccess
FUNCTION Get_Address1 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address1(customer_no_, addr_no_);
END Get_Address1;


-- Get_Address2
--   Returns address2
@UncheckedAccess
FUNCTION Get_Address2 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address2(customer_no_, addr_no_);
END Get_Address2;

@UncheckedAccess
FUNCTION Get_Address3 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address3(customer_no_, addr_no_);
END Get_Address3;

@UncheckedAccess
FUNCTION Get_Address4 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address4(customer_no_, addr_no_);
END Get_Address4;

@UncheckedAccess
FUNCTION Get_Address5 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address5(customer_no_, addr_no_);
END Get_Address5;

@UncheckedAccess
FUNCTION Get_Address6 (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Address6(customer_no_, addr_no_);
END Get_Address6;

-- Get_Zip_Code
--   Returns zip_code
@UncheckedAccess
FUNCTION Get_Zip_Code (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_Zip_Code(customer_no_, addr_no_);
END Get_Zip_Code;


-- Get_City
--   Returns city
@UncheckedAccess
FUNCTION Get_City (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_City(customer_no_, addr_no_);
END Get_City;


-- Get_State
--   Returns state
--   Returns state
@UncheckedAccess
FUNCTION Get_State (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_State(customer_no_, addr_no_);
END Get_State;


@UncheckedAccess
FUNCTION Get_County (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customer_Info_Address_API.Get_County(customer_no_, addr_no_);
END Get_County;

@UncheckedAccess
FUNCTION Get_Customer_Info_Address (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN Customer_Order_Address_Arr PIPELINED
IS
   main_rec_   Customer_Info_Address_API.Public_Rec;
   rec_ Customer_Info_Address_Rec;
BEGIN
   main_rec_ := Customer_Info_Address_API.Get(customer_no_, addr_no_);
   rec_.customer_no := main_rec_.customer_id;
   rec_.address_no  := main_rec_.address_id;
   rec_.name        := main_rec_.name;
   rec_.address     := main_rec_.address;
   rec_.address1    := main_rec_.address1;
   rec_.address2    := main_rec_.address2;
   rec_.address3    := main_rec_.address3;
   rec_.address4    := main_rec_.address4;
   rec_.address5    := main_rec_.address5;
   rec_.address6    := main_rec_.address6;
   rec_.zip_code    := main_rec_.zip_code;
   rec_.city        := main_rec_.city;
   rec_.county      := main_rec_.county;
   rec_.state       := main_rec_.state;
   rec_.in_city     := main_rec_.in_city;
   rec_.country     := main_rec_.country;
   PIPE ROW (rec_);                                                                                     
END Get_Customer_Info_Address;

-- Remove
--   Remove a record
PROCEDURE Remove (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 )
IS
   remrec_     CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(customer_no_, addr_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_no_, addr_no_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Modify
--   Modify a record
PROCEDURE Modify (
   info_        OUT    VARCHAR2,
   attr_        IN OUT VARCHAR2,
   customer_no_ IN     VARCHAR2,
   addr_no_     IN     VARCHAR2 )
IS
   oldrec_     CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   newrec_     CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify;


-- Is_Pay_Location
--   Return TRUE if the specified address is a pay address
@UncheckedAccess
FUNCTION Is_Pay_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Customer_Info_Address_Type_API.Check_Exist(customer_no_, addr_no_, Address_Type_Code_API.Decode('PAY')) = 'TRUE') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Pay_Location;


-- Get_Email
--   Returns the valid email address for Customer Order communication method.
@UncheckedAccess
FUNCTION Get_Email (
   customer_no_   IN VARCHAR2,
   contact_       IN VARCHAR2,
   addr_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   email_ VARCHAR2(200);
BEGIN
   IF Fnd_Event_API.Get_Event_Enable('PrintJob', 'PDF_REPORT_CREATED') = 'FALSE' THEN
      email_ := NULL;
   ELSE
      email_ := Contact_Util_API.Get_Cust_Comm_Method_Value(customer_no_, addr_no_, contact_,'E_MAIL');
   END IF;            
   RETURN email_;
END Get_Email;


-- Check_Exist
--   Check if the specified record exists.
@UncheckedAccess
FUNCTION Check_Exist (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(customer_no_, addr_no_);
END Check_Exist;

-- Set_End_Cust_Ord_Addr_Info
--   Set the Ship via, Delivery Terms and Delivery Location when the End Customer is changed or entered.
PROCEDURE Set_End_Cust_Ord_Addr_Info(
  customer_id_       IN  VARCHAR2,
  end_customer_id_   IN  VARCHAR2,
  customer_addr_     IN  VARCHAR2,
  end_customer_addr_ IN  VARCHAR2 )
IS
   ship_via_             CUST_ORD_CUSTOMER_ADDRESS_TAB.ship_via_code%TYPE;
   del_terms_            CUST_ORD_CUSTOMER_ADDRESS_TAB.delivery_terms%TYPE;
   del_terms_location_   CUST_ORD_CUSTOMER_ADDRESS_TAB.del_terms_location%TYPE;
   end_cus_rec_          Public_Rec;   
   rec_                  CUST_ORD_CUSTOMER_ADDRESS_TAB%ROWTYPE;
BEGIN
   end_cus_rec_         := Get(end_customer_id_, end_customer_addr_);
   ship_via_            := end_cus_rec_.ship_via_code;
   del_terms_           := end_cus_rec_.delivery_terms;
   del_terms_location_  := end_cus_rec_.del_terms_location;
   
   IF (ship_via_ IS NOT NULL AND del_terms_ IS NOT NULL) THEN 
      IF (Cust_Ord_Customer_Address_API.Exists(customer_id_, customer_addr_)) THEN 
         rec_                    := Get_Object_By_Keys___(customer_id_, customer_addr_);
         rec_.ship_via_code      := ship_via_;
         rec_.delivery_terms     := del_terms_;
         rec_.del_terms_location := del_terms_location_;  
         Modify___(rec_);
      ELSE 
         rec_.customer_no    := customer_id_;
         rec_.addr_no        := customer_addr_;
         rec_.ship_via_code  := ship_via_;
         rec_.delivery_terms := del_terms_; 
         New___(rec_);
      END IF;
   END IF;
END Set_End_Cust_Ord_Addr_Info;

@UncheckedAccess
FUNCTION Is_Valid_Ship_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF ((Cust_Ord_Customer_Address_API.Is_Valid(customer_no_, addr_no_) = 1) 
      AND (Cust_Ord_Customer_Address_API.Is_Ship_Location(customer_no_, addr_no_) = 1)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Valid_Ship_Location;

@UncheckedAccess
FUNCTION Is_Valid_Bill_Location (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF ((Cust_Ord_Customer_Address_API.Is_Valid(customer_no_, addr_no_) = 1) 
      AND (Cust_Ord_Customer_Address_API.Is_Bill_Location(customer_no_, addr_no_) = 1)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Valid_Bill_Location;
