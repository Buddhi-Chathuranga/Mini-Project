-----------------------------------------------------------------------------
--
--  Logical unit: CompanyDistributionInfo
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201221  DiJwlk  SC2020R1-11841, Modified New_Data_Capture_Menu__(), Remove_Data_Capture_Menu__() by removing string manipulations to optimize performance.
--  160310  KhVeSe  LIM-4892, removed public method Remove_Data_Capture_Menu and modified method New_Data_Capture_Menu__().
--  160223  KhVese  LIM-4892, Added methods New_Data_Capture_Menu__(), Remove_Data_Capture_Menu__() and Remove_Data_Capture_Menu().
--  160223          Also modified method Check_Update___() to validate user.
--  140424  DipeLK  PBFI-6782 ,Added create company tool support from the developer studio
--  140128  SURBLK  Removed use_price_incl_tax from the model.
--  130812  ChJalk  TIBE-927, Removed the global variables inst_TaxRegime_, inst_CompanyInvoiceInfo_, inst_CostBucket_ and inst_SsccBasicData_.
--  120616  MaEelk  Removed columns OWNERSHIP_TRANSFER_POINT, KEEP_ENG_REV_SITE_MOVE, STOCK_CTRL_TYPES_BLOCKED, UOM_FOR_VOLUME,
--  120616          UOM_FOR_WEIGHT, UOM_FOR_LENGTH, UOM_FOR_TEMPERATURE and UOM_FOR_DENSITY from CompanyDistributionInfo
--  120616          and moved them to CompanyInventInfo in INVENT.
--  120529  MAHPLK  Moved BASE_FOR_ADV_INVOICE, ORDER_TAXABLE, INTERSITE_PROFITABILITY, DELAY_COGS_TO_DELIV_CONF, PREPAYMENT_INV_METHOD
--                  and ORDER_NO_ON_INCOMING_CO to CompanyOrderInfo LU in ORDER module.
--  120611  JeeJlk  Modified Unpack_Check_Insert___ by setting use_price_incl_tax FALSE.
--  120528  JeeJlk  Added method Get_Use_Price_Incl_Tax_Db.
--  120528  JeeJlk  Modifed copy___, Import___, Export___ and VIEWPCT by adding USE_PRICE_INCL_TAX  to support company templates.
--  120523  JeeJlk  Added new column Use_Price_Incl_Tax.
--  120306  GiSalk  Bug 101505, Removed methods Validate_Delay_Cogs_To_Dc___ and Validate_Preacc_At_Pr_Rel___,  and removed the places where they
--  120306          had been called in Unpack_Check_Insert___ and Unpack_Check_Update___. Modified Validate_Posting_Group___ by removing the error 
--  120306          message generated when Cost Bucket is not installed. Removed the global LU constant inst_PurchaseReq_.
--  120201  ChJalk  Added ENUMERATION to the column comments of ALLOW_CONVERT_QUOTE_TO_PO and STOCK_CTRL_TYPES_BLOCKED in the base view.
--  110916  DaZase  Added method Compare_Uoms.
--  110914  DaZase  Added method Raise_Uom_Changed_Warning___ and calls to it from Unpack_Check_Update___.
--  110815  GayDLK  Bug 93972, Added public attribute stock_ctrl_types_blocked and public method Stock_Ctrl_Types_Blocked. 
--  110815          Modified the SELECT list of the Get() and modified the view COMPANY_DISTRIBUTION_INFO_PCT and methods Copy___(), 
--  110815          Export___() and Import___() to support company and company template creation.            
--  110224  KEKULK   Added  allow_convert_quote_to_po to  COMPANY_DISTRIBUTION_INFO_TAB
--  100811  PraWlk  Bug 91276, Modified cursor get_data in method Import___() by removing columns c8 and c13 from the select statement.
--  100709   UTSWLK  Added public attribute uom_for_density.
--  100811          Modified Insert___() by removing unnesessary call to Company_Invent_Info_API.New().
--  100323  AndDse  Bug 88066, Removed General_SYS.Init_Method from Get_Ownership_Transfer_Pnt_Db since pragma has been added.
--  100426  Ajpelk  Merge rose method documentation
--  100413  JeLise  Changed from calling procedure Statutory_Fee_API.Get_Fee_Type to calling function 
--  100413          Statutory_Fee_API.Get_Fee_Type in Validate_Tax___.
--  100120  ChFolk  Modified view comments of notify_suppl_cons_consum_db to set the column size as VARCHAR2(5).
--  091203  MaEelk  Added public attribute notify_suppl_cons_consum to the LU
--  091203          and function Get_Notify_Sup_Cons_Consum_Db. 
--  091203          Did neessary changes relates to company template.
--  ---------------------- 14.0.0 -------------------------------------------
--  091030  KiSalk  Bug 86768, Merged IPR to APP75 Core.
--  090713  AmPalk  Bug 83121, Made company prefix a varchar2.
--  090820  NaLrlk  Modified the columns sscc_company_prefix and company_prefix into updatable.
--  090712  NaLrlk  Added public attribute uom_for_length and uom_for_temperature.
--  090615  NaLrlk  Modified the attribute sscc_company_prefix to varchar2 from number.
--  090429  KiSalk  Added attribute sscc_company_prefix, methods Exist_Sscc_Basic_Data___ and Get_Sscc_Company_Prefix.
--  080721  AmPalk  Modified methods Copy___, Export___, Import___, Prepare_Insert___ and company_distribution_info_pct to handle uom_for_volume and uom_for_weight.
--  080724  AmPalk  Added uom_for_volume and uom_for_weight.
--  080421  KiSalk  Added attribute and method company_prefix Get_Company_Prefix.
--  ---------------------- Nice Price ----------------------
--  090603  HoInlk  Bug 82024, Added public attribute keep_eng_rev_site_move to LU and company template.
--  090603          Added public method Get_Keep_Eng_Rev_Site_Move_Db.
--  090519  AndDse  Bug 82427, Added attribute check_preacc_at_pr_release and functions Check_Preacc_At_Pr_Release,Validate_Preacc_At_Pr_Rel___.
--  090210  HoInlk  Bug 80288, Modified Import__ to add tax code only if INVOIC is installed.
--  071204  MaEelk  Bug 67937, Added public attribute order_no_on_incoming_co to the LU
--  071204          and did neessary changes related to company template.
--  071204          Added public method Get_Order_No_On_Incoming_Co_Db
--  071113  MaEelk  Bug 68684, Added post_non_inv_purch_rcpt to Copy___ method
--  070810  DAYJLK  Bug 66401, Modified Validate_Tax___, in order to avoid fetching the tax code
--  070810          when INVOIC module is not installed.
--  070212  RaKalk  Bug 61905, Added public attribute post_non_inv_purch_rcpt. Modified Import___, Export___ methods
--  061214  ChBalk  Added validations to enable prepayment inv method only for vat tax regime.
--  061030  RaKalk  Modified Import__ and Export__ methods to fix company creation errors.
--  061030  RaKalk  Removed the post_charge_price_diff check box from the LU
--  061009  ChBalk  Added public field PREPAYMENT_INV_METHOD.
--  060802  NaLrlk  Added the new lov view COMPANY_DISTRIBUTION_INFO_LOV.
--  060610  NaWilk  Added public field post_charge_price_diff.
--  060505  OsAllk  Modifed the method Validate_Tax___ to by pass the validation if INVOICE is not installed.
--  060313  IsWilk  Correct the order of the columns in CURSOR get_attr in FUNCTION Get.
--  060308  JoEd    Fixed Copy___ - tax_free_tax_code attribute mismatch.
--  060306  JaJalk  Added Assert safe annotation.
--  060220  KeFelk  Added public attrubutes Purch_Taxable and renamed Taxable to Order_Taxable.
--  060214  KeFelk  Removed Validate_Tax_Free___ and changed the Validate_Tax___ logic.
--                  And remove the default tax codes in the Prepare_Insert___.
--  060213  JoEd    Added public attribute use_transit_balance_posting.
--                  Fixed Import___, Export___ and Copy___ to handle the mandatory_posting_group,
--                  mandatory_cost_source and use_accounting_year attributes correctly.
--  060120  JaJalk  Added Assert safe annotation.
--  060104  IsAnlk  Removed TRUE from Gerenal_SYS.Init in Get_Ownership_Transfer_Pnt_Db.
--  051122  JoEd    Removed the error messages from the Get..._Db functions.
--  051104  KeFelk  Added public attribute Tax_Free_Tax_Code and Validate_Tax_Free___.
--  051103  JoEd    Added public attribute use_accounting_year.
--  051103  HaPulk  Removed view COMPANY_DISTRIBUTION_INFO_ECT.
--  051101  JoEd    Added public attributes mandatory_posting_group and mandatory_cost_source.
--  051005  KeFelk  Replaced Site_API with Site_Invent_Info_API in Check_Ownership_Trans_Point___.
--  050919  NaLrlk  Removed unused variables.
--  050715  SaJjlk  Added condition for Sales Tax in method Prepare_Insert___.
--  050707  SaNalk  Added General_SYS.Init_Method to  Get_Ownership_Transfer_Pnt_Db and Get_Post_Price_Diff_At_Arr_Db.
--  050607  UsRalk  Corrected the view comments on VIEWPCT.
--  050502  AnLaSe  Add and upgrade of this table is handled differently than other tables.
--                  Upgrade must be performed manually in the client by RMB Update Company on frmCompany .
--                  If Update Company is not done and information from this table is required, alert the user.
--                  Added error messages in Get_Intersite_Profitability_Db and Get_Post_Price_Diff_At_Arr_Db.
--                  Modified error messages in Get_Ownership_Transfer_Pnt_Db and Get_Post_Price_Dif_at_Arr_Db.
--  050310  AnLaSe  SCJP625: Added attribute delay_cogs_to_deliv_conf, methods Get_Delay_Cogs_To_Dc_Db and
--                  Validate_Delay_Cogs_To_Dc___.
--  050201  LEPESE  Renamed Validate_Ownership_Tran_Pnt___ to Check_Ownership_Trans_Point___ and
--                  added new parameters and added call to Site_API.Check_Ownership_Transfer_Point
--                  when ownership_transfer_point is set to 'RECEIPT INTO INVENTORY'.
--                  Check_Ownership_Trans_Point___ is called both during insert and update checks.
--  050104  SaRalk  Added new function Get_Taxable_Db.
--  041125  SaNalk  Modified calls to Sales_Part_Taxable_API in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  041119  DiVelk  Modifed If condition in Validate_Tax___.
--  041118  SaNalk  Added dynamic calls in Prepare_Insert___,Validate_Tax___ and Unpack_Check_Insert___.
--  041117  MaEelk  Renamed Error Tags in Get_Ownership_Transfer_Pnt_Db and
--  041117          Get_Post_Price_Dif_at_Arr_Db. Reordered the cursors and attributes in Import___.
--  041116  Samnlk  Modify the error message in Validate_Ownership_Tran_Pnt___.
--  041116  Samnlk  Change the error message in Validate_Ownership_Tran_Pnt___.
--  041111  SaNalk  Modified the call to Validate_Ownership_Tran_Pnt___ in Unpack_Check_Update___.
--  041108  SaNalk  Modified Validate_Ownership_Tran_Pnt___ and called it in Unpack_Check_Update___.
--  041105  SaNalk  Modified Prepare_Insert___ and Import___.
--  041103  SaNalk  Added methods Get_Ownership_Transfer_Pnt_Db, Get_Post_Price_Diff_At_Arr_Db and Validate_Ownership_Trans_Pnt___.
--                  Modified views VIEWPCT,VIEWECT and methods Copy___,Export___,Import___ for ownership_transfer_point and post_price_diff_at_arrival.
--  041102  SaNalk  Added ownership_transfer_point and post_price_diff_at_arrival.
--  041101  SaNalk  Moved the LU to MPCCOM Module.
--  041013  DiVelk  Modified method [Validate_Tax___].
--  040923  AnLaSe  Added attribute intersite_profitability. Added methods Get_Intersite_Profitability_Db and
--                  Check_Enable_Int_Profit___. Modified select in COMPANY_DISTRIBUTION_INFO_ECT.
--                  according to recommendations for Company Template.
--  040923  DiVelk  Modified methods [Copy___],[Import___],[Export___] and [Prepare_Insert___].
--                  Added Tax_Code and Taxable to VIEWPCT and VIEWECT.
--  040917  DiVelk  Added Tax_Code and Taxable.Added procedure Validate_Tax___.Modified Prepare_Insert___.
--  040817  DhWilk  Inserted General_SYS.Init_Method to Get_Base_For_Adv_Inv_Db
--  040408  HeWelk  Performed TouchDown merge.
--  040210  AjShlk  Created
--  040224  AjShlk  Modified Copy___(), Import___() to support company creation
--  ------------------------------ 13.3.0------------------------------------
-- 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Posting_Group___ (
   company_ IN VARCHAR2 )
IS
   all_defined_ VARCHAR2(5);
BEGIN
   $IF Component_Cost_SYS.INSTALLED $THEN
      all_defined_ := Cost_Bucket_API.Posting_Group_Defined(company_);         
      IF (all_defined_ = 'FALSE') THEN
         Error_SYS.Item_General(lu_name_, 'MANDATORY_POSTING_GROUP_DB', 'COSTBUCKET: The box [:NAME] can only be checked when all Cost Buckets connected to Company '':P1'' have defined Posting Cost Groups.', company_);
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Posting_Group___;

PROCEDURE Check_Company_Prefix_Ref___ (
   newrec_ IN OUT NOCOPY company_distribution_info_tab%ROWTYPE )
IS  
BEGIN
   IF (newrec_.company_prefix IS NOT NULL) THEN
      Gtin_Basic_Data_API.Company_Prefix_Exists(newrec_.company_prefix); 
   END IF;
END Check_Company_Prefix_Ref___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);

   Client_SYS.Add_To_Attr('MANDATORY_POSTING_GROUP_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('MANDATORY_COST_SOURCE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_ACCOUNTING_YEAR_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_distribution_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.mandatory_posting_group) THEN 
   newrec_.mandatory_posting_group := 'FALSE';
   END IF;
   IF NOT (indrec_.mandatory_cost_source) THEN 
   newrec_.mandatory_cost_source := 'FALSE';
   END IF;
   IF NOT (indrec_.use_accounting_year) THEN 
   newrec_.use_accounting_year := 'FALSE';
   END IF;

   super(newrec_, indrec_, attr_);
   
   IF (newrec_.mandatory_posting_group = 'TRUE') THEN
      Validate_Posting_Group___(newrec_.company);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_distribution_info_tab%ROWTYPE,
   newrec_ IN OUT company_distribution_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   User_Finance_API.Exist_User(newrec_.company, Fnd_Session_API.Get_Fnd_User);

   IF (newrec_.mandatory_posting_group = 'TRUE') AND (oldrec_.mandatory_posting_group = 'FALSE') THEN
      Validate_Posting_Group___(newrec_.company);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New_Data_Capture_Menu__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2)
IS
   company_        VARCHAR2(20);
   newrec_         company_distribution_info_tab%ROWTYPE;
   oldrec_         company_distribution_info_tab%ROWTYPE;
   indrec_         Indicator_Rec;
   exit_procedure_ EXCEPTION;
BEGIN
   IF (action_ = 'PREPARE') THEN
      RAISE exit_procedure_;
   END IF;

   company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
   Exist(company_);
   Get_Id_Version_By_Keys___(objid_, objversion_, company_);
   
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      newrec_ := oldrec_;     
      newrec_.data_capture_menu_id := Client_SYS.Get_Item_Value('DATA_CAPTURE_MENU_ID', attr_);
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Keys_Nowait___(company_);
      newrec_ := oldrec_;      
      newrec_.data_capture_menu_id := Client_SYS.Get_Item_Value('DATA_CAPTURE_MENU_ID', attr_);
      IF Validate_SYS.Is_Equal(oldrec_.data_capture_menu_id, newrec_.data_capture_menu_id) THEN 
         Error_SYS.Record_Exist('CompanyDistributionInfo');
      END IF;
      Modify___(newrec_, FALSE);
      IF ((oldrec_.data_capture_menu_id IS NOT NULL) AND (newrec_.data_capture_menu_id IS NOT NULL)) THEN  
         Client_SYS.Add_Info(lu_name_, 'CHANGEMENU: The warehouse data collection menu ID for company :P1 was changed from :P2 to :P3.', 
                             newrec_.company, oldrec_.data_capture_menu_id, newrec_.data_capture_menu_id );
      END IF ; 
   END IF;
   info_ := Client_SYS.Get_All_Info;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END New_Data_Capture_Menu__;

   
PROCEDURE Remove_Data_Capture_Menu__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   attr_             VARCHAR2(2000);
   newrec_           company_distribution_info_tab%ROWTYPE;
   oldrec_           company_distribution_info_tab%ROWTYPE;
   indrec_           Indicator_Rec;
   new_objversion_   COMPANY_DISTRIBUTION_INFO.objversion%TYPE := objversion_;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      newrec_ := oldrec_;     
      newrec_.data_capture_menu_id := to_char(NULL);
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, new_objversion_);
      newrec_ := oldrec_;      
      newrec_.data_capture_menu_id := to_char(NULL);
      Modify___(newrec_, FALSE);
   END IF;
   
END Remove_Data_Capture_Menu__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
