-----------------------------------------------------------------------------
--
--  Logical unit: SiteDiscomInfo
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220707  MiKulk  SCDEV-12307, Modified Prepare_Insert___ and to set default values to INCL_RELEASED_PO_LINES, INCL_CONFIRMED_PO_LINES, INCL_ARRIVED_PO_LINES, INCL_RECEIVED_PO_LINES, 
--  220707          INCL_PAST_DUE_PO_LINES, PO_PAST_DUE_DAYS_ALLOWED and INCL_PLANNED_DO. Added validates for PO_PAST_DUE_DAYS_ALLOWED to be a positive integer in Check_Common. Update Check_Insert___ to set default values for new attributes.
--  220602  Amiflk  SCDEV-10421, Modified Prepare_Insert___() to handle the ORDER_LEVEL default value of Cust_Order_Confirmation enumeration.
--  220422  Amiflk  SCDEV-9434,  Modified Prepare_Insert___() and Check_Insert() to add the CUST_ORDER_CONFIRMATION_DB attribute.
--  220120  Aabalk  SC21R2-7164, Moved common logic from Check_Insert___ and Check_Update___ into Check_Common___.
--  211209  Cpeilk  SC21R2-2566, Added column adhoc_pur_rqst_approval to check whether supp_auto_approval_user is correctly validated against new column values.
--  210215  ErRalk  SC2020R1-11985, Modified New to fetch the Use Price Incl Tax value when both order and purch component are installed.
--  210126  RoJalk  SC2020R1-11621, Modified New to call New___ instead of Unpack methods.
--  210113  ErRalk  SC2020R1-11985, Modified New and Check_Insert___ to increase the performance.
--  200813  AsZelk  SC2020R1-7066, Removed dynamic dependency to Invent.
--  200601  Aabalk  SCSPRING20-1687, Moved code to check if entered location is a shipment location, from Check_Insert___ and Check_Update___
--  200601          to Check_Common___. Modified Check_Common___ by adding a check to validate if selected shipment location is a non-remote warehouse location.
--  200601          Added method Check_Site_Shipment_Location to validate if the inventory location is a shipment location and not in a remote warehouse.
--  191118  ErRalk  SCSPRING20-959, Modified attribute PURCHASE_RECEIVE_CASE_DB into RECEIVE_CASE_DB.
--  181115  Asawlk  Bug 145345(SCZ-1613), Modified Prepare_Insert___ to add the client value of RESERV_FROM_TRANSP_TASK to the attribute string.
--  171129  DAYJLK  STRSC-13921, Modified Check_Insert___ and Prepare_Insert___ to set default values for new attribute reserv_from_transp_task.
--  170705  KhVeSE  STRSC-8973, Added attribute UNATTACH_HU_AT_DELIVERY_DB to methods New() and Prepare_Insert___();
--  170316  SURBLK  Renamed attribute OVERRULE_LMT_SALE_TO_ASSRT into ALLOW_OVERRULE_LIMIT_SALES.
--  170127  KhVese  LIM-10221, Removed ADJUST_PICK_RESERVATION from Prepare_Insert___ and New.
--  170126  IsSalk  STRSC-5605, Added OVERRULE_LMT_SALE_TO_ASSRT to Prepare_Insert___ and New.
--  161025  KhVese  STRSC-4537, Added ADJUST_PICK_RESERVATION to Prepare_Insert___ and New.
--  160924  MaEelk  LIM-8562, Added PRINT_PICK_REPORT to Prepare_Insert___ and New.
--  160623  DilMlk  STRSC-1199, Added columns dir_del_approval, order_conf_approval, order_conf_diff_approval and create_conf_change_order to Prepare_Insert___().
--  160623          Added validation for them in Check_Insert___ and Check_Update___.
--  150607  TiRalk  ORA-629, Modified Get_Over_Delivery_Actions() to fetch actions when over delivery performed.
--  150605  TiRalk  ORA-628, Added Get_Default_Over_Del_Tolerance() to get the over delivery tolerance value.
--  150527  TiRalk  ORA-625, Added columns over_tolerance, action_non_authorize and action_authorize to methods Prepare_Insert___() and New(). 
--  140707  MAHPLK  Added EXEC_ORDER_CHANGE_ONLINE column to SITE_DISCOM_INFO_TAB. 
--  140702  HimRlk  Added new column release_internal_order.
--  140701  MaEelk  Added column discount_type to Prepare_Insert___ and New nethods . 
--  140304  SURBLK  Removed column use_price_incl_tax and added use_price_incl_tax_order and use_price_incl_tax_purch.
--  130702  MaIklk  Renamed global variable cache_id_contract_ to micro_cache_id_contract_.
--                  Also removed global varaibles which used to check whether logical_unit_is_installed and instead used conditional compilation.
--  130625  MeAblk  Converted the static calls to Shipment_Type_API.Exist into dynamic calls.  
--  130620  ShKolk  Added columns order_id, priority and replicate_doc_text.
--  130618  SURBLK  Added attribute forward_agent_id.
--  130610  SurBlk  Added columns edi_auto_order_approval, edi_auto_change_approval, edi_authorize_code, edi_auto_approval_user.
--  130410  MaMalk  Set default shipment_type into Prepare_Insert___ and New methods to 'NA'.
--  130201  JaNslk  Bug 107864, Implemented micro cache for all get methods corresponding to public attributes. 
--                  Also added methods Invalidate_Cache___ and Update_Cache___
--  120828  MeAblk  Changed the shipment_type column as a mandatory. Set default shipment_type into Prepare_Insert___ and New methods. 
--  120823  MeAblk  Added new attribute shipment_type. .
--  120525  HimRlk  Added public column use_price_incl_tax.
--  120119  MaRalk  Added ENUMERATION=FndBoolean for the view comments CREATE_BASE_PRICE_PLANNED, ENFORCE_USE_OF_POCO and   
--  120119          ENUMERATION=PurchaseReceiveCase to view comments PURCHASE_RECEIVE_CASE to avoid model errors generated from PLSQL implementation test.
--  110412  JeLise  Added call to User_Allowed_Site_API.Exist in Unpack_Check_Update___.
--  110311  IsSalk  Bug 95798, Modified the procedure Update___ to update the doc reference when the part catalog description is used instead of purchase part description.
--  110308  Darklk  Bug 95798, Modified the procedure Update___ to update the doc reference when the part catalog description is used instead of sales part description.
--  110224  JeLise  Added attribute purchase_receive_case.
--  110207  RiLase  Added CREATE_BASE_PRICE_PLANNED.
--  101208  SuSalk  Modified New() method.
--  101202  SuSalk  Modified Get(),Unpack_Check_Insert___(),Prepare_Insert___() and Unpack_Check_Update___() methods
--  101202          to handle enforce_use_of_poco.Added Get_Enforce_Use_Of_Poco_Db().
--  100818  MaHplk  Added new attribute price_effetive_date.
--  100429  DEKOLK  Merge Rose method documentation.
--  ------------------------- Eagle -------------------------------------------
--  090728  TiRalk  Bug 81024, Added function Get_Purch_Comp_Method_Db.
--  090519  DaGulk  Bug 82645, Added new error message in Unpack_Check_Update___ to validat the inventory location type is SHIPMENT.  
--  090512  DaGulk  Bug 82645, Modified methods Unpack_Check_Update___ and Unpack_Check_Insert___to dynamically check inventory location Exist.
--  090512          Added global constant inst_InventoryLocation_.                             
--  090420  DaGulk  Added new column ship_inventory_location_no and function Get_Ship_Inventory_Location_No.
--  090223  MaHplk  Added attribute shipment_freight_charge.
--  081114  MaJalk  Added attribute fair_share_reservation.
--  070213  NuVelk  Added new column use_pre_ship_del_note and functions Get_Use_Pre_Ship_Del_Note, Get_Use_Pre_Ship_Del_Note_Db.
--  061219  NuVelk  Added new column create_ord_in_rel_state and functions Get_Create_Ord_In_Rel_State, Get_Create_Ord_In_Rel_State_Db.
--  060711  KanGlk  Added new columns use_partca_desc_order and use_partca_desc_purch and
--  060711          functions Get_Use_Partca_Desc_Order, Get_Use_Partca_Desc_Order_Db,
--  060711          Get_Use_Partca_Desc_Purch and Get_Use_Partca_Desc_Purch_Db.
--  060109  MiKulk  Added the function Check_Exist.
--  051012  IsAnlk  Added public New method.
--  051011  KeFelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   approval_option_client_value_ VARCHAR2(20);
BEGIN
   super(attr_);
   approval_option_client_value_ := Approval_Option_API.Get_Client_Value(2);
   Client_SYS.Add_To_Attr('PURCH_COMP_METHOD', Purchase_Component_Method_API.Decode('CUST ORDER'), attr_);
   Client_SYS.Add_To_Attr('CUST_ORDER_PRICING_METHOD', CUST_ORDER_PRICING_METHOD_API.Decode('SYSTEM_DATE'), attr_);
   Client_SYS.Add_To_Attr('CUST_ORDER_DISCOUNT_METHOD', CUST_ORDER_DISCOUNT_METHOD_API.Decode('SINGLE_DISCOUNT'), attr_);
   Client_SYS.Add_To_Attr('DISP_COND_CUSTOMER_ORDER_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DISP_COND_PURCHASE_ORDER_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PARTCA_DESC_ORDER_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PARTCA_DESC_PURCH_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CREATE_ORD_IN_REL_STATE_DB','TRUE', attr_);
   Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('FAIR_SHARE_RESERVATION_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_FREIGHT_CHARGE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SEND_AUTO_DIS_ADV_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PRICE_EFFECTIVE_DATE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ENFORCE_USE_OF_POCO_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CREATE_BASE_PRICE_PLANNED_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('RECEIVE_CASE_DB', 'ARRINV', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_PURCH_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_ORDER_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_TYPE', 'NA', attr_);
   Client_SYS.Add_To_Attr('FINALIZE_SUPP_SHIPMENT_DB','TRUE', attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE','G', attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('EXEC_ORDER_CHANGE_ONLINE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_FREEZE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('OVER_DELIVERY_DB', 'FALSE', attr_);   
   Client_SYS.Add_To_Attr('ACTION_NON_AUTHORIZED_DB', 'NONE', attr_);
   Client_SYS.Add_To_Attr('ACTION_AUTHORIZED_DB', 'WARNING', attr_);
   Client_SYS.Add_To_Attr('DIR_DEL_APPROVAL', approval_option_client_value_, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_APPROVAL', approval_option_client_value_, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_DIFF_APPROVAL', approval_option_client_value_, attr_);
   Client_SYS.Add_To_Attr('ADHOC_PUR_RQST_APPROVAL', approval_option_client_value_, attr_);
   Client_SYS.Add_To_Attr('CREATE_CONF_CHANGE_ORDER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PRINT_PICK_REPORT', Invent_Report_Print_Option_API.Decode(Invent_Report_Print_Option_API.DB_DETAILED), attr_);
   Client_SYS.Add_To_Attr('ALLOW_OVERRULE_LIMIT_SALES_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('UNATTACH_HU_AT_DELIVERY_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('RESERV_FROM_TRANSP_TASK', Reserve_From_Transp_Task_API.Decode(Reserve_From_Transp_Task_API.DB_USE_INVENTORY_DEFAULT), attr_);
   Client_SYS.Add_To_Attr('CUST_ORDER_CONFIRMATION_DB', Cust_Order_Confirmation_API.DB_ORDER_LEVEL, attr_);
   Client_SYS.Add_To_Attr('INCL_RELEASED_PO_LINES','TRUE', attr_);
   Client_SYS.Add_To_Attr('INCL_CONFIRMED_PO_LINES','TRUE', attr_);
   Client_SYS.Add_To_Attr('INCL_ARRIVED_PO_LINES','TRUE', attr_);
   Client_SYS.Add_To_Attr('INCL_RECEIVED_PO_LINES','TRUE', attr_);
   Client_SYS.Add_To_Attr('INCL_PAST_DUE_PO_LINES','TRUE', attr_);
   Client_SYS.Add_To_Attr('PO_PAST_DUE_DAYS_ALLOWED',0, attr_);
   Client_SYS.Add_To_Attr('INCL_PLANNED_DO','TRUE', attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SITE_DISCOM_INFO_TAB%ROWTYPE,
   newrec_     IN OUT SITE_DISCOM_INFO_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
      $IF (Component_Order_SYS.INSTALLED) $THEN
      IF (newrec_.use_partca_desc_order != oldrec_.use_partca_desc_order) THEN      
         Sales_Part_API.Handle_Partca_Desc_Flag_Change(newrec_.contract);       
      END IF;
   $END
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (newrec_.use_partca_desc_purch != oldrec_.use_partca_desc_purch) THEN
          Purchase_Part_API.Handle_Partca_Desc_Flag_Change(newrec_.contract);
      END IF;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     site_discom_info_tab%ROWTYPE,
   newrec_ IN OUT site_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY OR newrec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      -- Automatic Order/Change Approval is ON.
      IF (newrec_.edi_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming customer order or for incoming change requests.');
      END IF;
   END IF;
   
   IF (newrec_.dir_del_approval = Approval_Option_API.DB_AUTOMATICALLY OR 
       newrec_.order_conf_approval = Approval_Option_API.DB_AUTOMATICALLY OR 
       newrec_.order_conf_diff_approval = Approval_Option_API.DB_AUTOMATICALLY OR
       newrec_.adhoc_pur_rqst_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      -- Automatic Approval is ON for delivery notifications/order confirmations.
      IF (newrec_.supp_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_SUPP_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming delivery notification or incoming order confirmation with/without differences or incoming ad-hoc purchase request.');
      END IF;
   END IF;
   
   IF (newrec_.price_effective_date = 'TRUE') THEN
      IF (newrec_.cust_order_pricing_method != 'DELIVERY_DATE') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGPRICINGMETHOD: The Update Price Effective Date Automatically is only allowed for pricing method Delivery Date.');
      END IF;
   END IF;
   
   IF (NVL(newrec_.over_delivery_tolerance, 0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGOVDTREQ: Over Delivery Tolerance should be greater than 0');
   END IF;
   
   --   Added an IF condition to check whether entered location is a shipment location.
   IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
      Check_Site_Shipment_Location(newrec_.contract, newrec_.ship_inventory_location_no);
   END IF;   
      
   IF (newrec_.po_past_due_days_allowed < 0 OR newrec_.po_past_due_days_allowed != ROUND(newrec_.po_past_due_days_allowed)) THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDPASTDUESAYS: Past Due Days must be a positive integer.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;

  
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);
   company_ VARCHAR2(20);
BEGIN
   IF NOT indrec_.dir_del_approval THEN
      newrec_.dir_del_approval  := Approval_Option_API.DB_MANUALLY;
   END IF;
   IF NOT indrec_.order_conf_approval THEN
      newrec_.order_conf_approval  := Approval_Option_API.DB_MANUALLY;
   END IF;
   IF NOT indrec_.order_conf_diff_approval THEN
      newrec_.order_conf_diff_approval  := Approval_Option_API.DB_MANUALLY;
   END IF;
   IF NOT indrec_.adhoc_pur_rqst_approval THEN
      newrec_.adhoc_pur_rqst_approval  := Approval_Option_API.DB_MANUALLY;
   END IF;
   IF NOT (indrec_.reserv_from_transp_task) THEN
      newrec_.reserv_from_transp_task  := Reserve_From_Transp_Task_API.DB_USE_INVENTORY_DEFAULT;
   END IF;
   IF NOT (indrec_.cust_order_confirmation) THEN
      newrec_.cust_order_confirmation  := Cust_Order_Confirmation_API.DB_ORDER_LEVEL;
   END IF;
   
   IF (newrec_.incl_released_po_lines IS NULL) THEN
      newrec_.incl_released_po_lines := 'TRUE';
   END IF;
   
   IF (newrec_.incl_confirmed_po_lines IS NULL) THEN
      newrec_.incl_confirmed_po_lines := 'TRUE';
   END IF;
   
   IF (newrec_.incl_arrived_po_lines IS NULL) THEN
      newrec_.incl_arrived_po_lines := 'TRUE';
   END IF;
   
   IF (newrec_.incl_received_po_lines IS NULL) THEN
      newrec_.incl_received_po_lines := 'TRUE';
   END IF;
   
   IF (newrec_.incl_past_due_po_lines IS NULL) THEN
      newrec_.incl_past_due_po_lines := 'TRUE';
   END IF;
   
   IF (newrec_.incl_planned_do IS NULL) THEN
      newrec_.incl_planned_do := 'TRUE';
   END IF;
       
   IF (newrec_.po_past_due_days_allowed IS NULL) THEN
      newrec_.po_past_due_days_allowed := 0;
   END IF;
   
   super(newrec_, indrec_, attr_);
   company_ := Site_API.Get_Company(newrec_.contract);
   
   IF (newrec_.release_internal_order IS NULL) THEN
      newrec_.release_internal_order := Approval_Option_API.DB_NOT_APPLICABLE;
   END IF;

   IF (newrec_.cust_order_pricing_method = 'DELIVERY_DATE') THEN
      IF (newrec_.price_effective_date = 'FALSE') THEN
         newrec_.price_effective_date := 'TRUE';
      END IF;
   END IF;

   IF (newrec_.document_address_id IS NOT NULL) THEN
      Company_Address_API.Exist(company_, newrec_.document_address_id);
   END IF;

   IF (newrec_.branch IS NOT NULL) THEN
      Branch_API.Exist(company_, newrec_.branch);
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_discom_info_tab%ROWTYPE,
   newrec_ IN OUT site_discom_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(4000);
   company_              VARCHAR2(20);
   char_null_            VARCHAR2(12) := 'VARCHAR2NULL';   
   doc_add_exists_       VARCHAR2(5);
   stmt_                 VARCHAR2(2000);
   any_shipment_connect_ VARCHAR2(5);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   company_ := Site_API.Get_Company(newrec_.contract);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (newrec_.shipment_freight_charge != oldrec_.shipment_freight_charge) THEN
      stmt_ := 'BEGIN :any_shipment_connect_ := Shipment_Handling_Utility_API.Any_Shipment_Conn_For_Site(:contract);END;';
      @ApproveDynamicStatement(2009-08-04,mahplk)
      EXECUTE IMMEDIATE stmt_
         USING OUT any_shipment_connect_,
               IN newrec_.contract;
      IF (any_shipment_connect_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'SHIPCONNLINEEXIST: There are Shipments in Preliminary status with connected Order Lines');
      END IF;
   END IF;

   IF (newrec_.document_address_id IS NOT NULL) THEN
      Company_Address_API.Exist(company_, newrec_.document_address_id);
   END IF;

   IF ((NVL(newrec_.document_address_id, char_null_) != NVL(oldrec_.document_address_id, char_null_))
        AND newrec_.document_address_id IS NOT NULL) THEN
      doc_add_exists_ := Company_Address_Type_API.Check_Exist(company_,
                                                              newrec_.document_address_id,
                                                              Address_Type_Code_API.Decode('INVOICE'));
      IF (doc_add_exists_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'DOCTYPENOTEXISTUP: Address ID :P1 in company :P2 is not a document address.', newrec_.document_address_id, company_ );
      END IF;
   END IF;

   IF (newrec_.branch IS NOT NULL) THEN
      Branch_API.Exist(company_, newrec_.branch);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Document_Address_Id (
   contract_        IN VARCHAR2,
   extended_search_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   document_address_id_ SITE_DISCOM_INFO_TAB.document_address_id%TYPE;
   CURSOR get_attr IS
      SELECT document_address_id
      FROM SITE_DISCOM_INFO_TAB
      WHERE contract = contract_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO document_address_id_;
   CLOSE get_attr;
   IF (extended_search_ = 'TRUE') THEN
      document_address_id_ := NVL(document_address_id_, Company_Address_Type_API.Get_Document_Address(Site_API.Get_Company(contract_)));
   END IF;
   RETURN document_address_id_;
END Get_Document_Address_Id;


-- New
--   Creates new record.
PROCEDURE New (
   contract_ IN VARCHAR2 )
IS
   newrec_                                SITE_DISCOM_INFO_TAB%ROWTYPE;
   use_price_incl_tax_purch_ VARCHAR2(20) := 'FALSE';
   use_price_incl_tax_order_ VARCHAR2(20) := 'FALSE';
   order_installed_    BOOLEAN := FALSE;
   purch_installed_    BOOLEAN := FALSE;
   rec_        Company_Tax_Discom_Info_API.Public_Rec;
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      order_installed_ := TRUE;
   $END
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      purch_installed_ := TRUE;
   $END
   
   IF (order_installed_) OR (purch_installed_) THEN 
      rec_ := Company_Tax_Discom_Info_API.Get(Site_API.Get_Company(contract_));
   END IF;   
   
   IF (order_installed_) THEN
      use_price_incl_tax_order_ := rec_.use_price_incl_tax_ord;
   END IF;
   IF (purch_installed_) THEN
      use_price_incl_tax_purch_ := rec_.use_price_incl_tax_pur;
   END IF;
   
   newrec_.contract                   := contract_;
   newrec_.purch_comp_method          := Purchase_Component_Method_API.DB_CUSTOMER_ORDER;
   newrec_.cust_order_pricing_method  := Cust_Order_Pricing_Method_API.DB_SYSTEM_DATE;
   newrec_.cust_order_discount_method := Cust_Order_Discount_Method_API.DB_SINGLE_DISCOUNT;
   newrec_.disp_cond_customer_order   := Fnd_Boolean_API.DB_FALSE;
   newrec_.disp_cond_purchase_order   := Fnd_Boolean_API.DB_FALSE;
   newrec_.use_partca_desc_order      := Fnd_Boolean_API.DB_FALSE;
   newrec_.use_partca_desc_purch      := Fnd_Boolean_API.DB_FALSE;
   newrec_.create_ord_in_rel_state    := Fnd_Boolean_API.DB_TRUE;
   newrec_.use_pre_ship_del_note      := Fnd_Boolean_API.DB_FALSE;
   newrec_.fair_share_reservation     := Fnd_Boolean_API.DB_FALSE;
   newrec_.shipment_freight_charge    := Fnd_Boolean_API.DB_FALSE;
   newrec_.send_auto_dis_adv          := Fnd_Boolean_API.DB_FALSE;
   newrec_.price_effective_date       := Fnd_Boolean_API.DB_FALSE;
   newrec_.enforce_use_of_poco        := Fnd_Boolean_API.DB_FALSE;
   newrec_.create_base_price_planned  := Fnd_Boolean_API.DB_FALSE;
   newrec_.receive_case               := Receive_Case_API.DB_RECEIVE_INTO_ARRIVAL;
   newrec_.use_price_incl_tax_purch   := use_price_incl_tax_purch_;
   newrec_.use_price_incl_tax_order   := use_price_incl_tax_order_;
   newrec_.shipment_type              := 'NA';
   newrec_.finalize_supp_shipment     := Fnd_Boolean_API.DB_TRUE;
   newrec_.discount_type              := 'G';
   newrec_.release_internal_order     := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.edi_auto_order_approval    := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.edi_auto_change_approval   := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.exec_order_change_online   := Fnd_Boolean_API.DB_FALSE;
   newrec_.discount_freeze            := Fnd_Boolean_API.DB_FALSE;
   newrec_.over_delivery              := Fnd_Boolean_API.DB_FALSE;
   newrec_.action_non_authorized      := Over_Delivery_No_Authorize_API.DB_NONE;
   newrec_.action_authorized          := Over_Delivery_Authorize_API.DB_WARNING;
   newrec_.dir_del_approval           := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.order_conf_approval        := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.order_conf_diff_approval   := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.adhoc_pur_rqst_approval    := Approval_Option_API.DB_NOT_APPLICABLE;
   newrec_.create_conf_change_order   := Fnd_Boolean_API.DB_FALSE;
   newrec_.print_pick_report          := Invent_Report_Print_Option_API.DB_DETAILED;
   newrec_.allow_overrule_limit_sales := Fnd_Boolean_API.DB_FALSE;
   newrec_.unattach_hu_at_delivery    := Fnd_Boolean_API.DB_TRUE;
   New___(newrec_);
END New;


@UncheckedAccess
FUNCTION Get_Disp_Cond_Cust_Order_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.disp_cond_customer_order;
END Get_Disp_Cond_Cust_Order_Db;


@UncheckedAccess
FUNCTION Get_Create_Base_Price_Plan_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.create_base_price_planned;
END Get_Create_Base_Price_Plan_Db;


@UncheckedAccess
FUNCTION Get_Disp_Cond_Purch_Order_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.disp_cond_purchase_order;
END Get_Disp_Cond_Purch_Order_Db;


-- Check_Exist
--   A fucntion to check the existance of a site and return a boolean value.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_);
END Check_Exist;

-- Get_Default_Over_Del_Tolerance
--   Returns Over Delivery Tolerance if the Perform Check box is checked.
FUNCTION Get_Default_Over_Del_Tolerance (   
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_       SITE_DISCOM_INFO_TAB.over_delivery_tolerance%TYPE;  
   rec_        Public_Rec;
BEGIN 
   rec_  := Get(contract_);
   IF (rec_.over_delivery = 'TRUE') THEN      
      temp_ := rec_.over_delivery_tolerance;  
   END IF;
   RETURN temp_;
END Get_Default_Over_Del_Tolerance;

FUNCTION Get_Over_Delivery_Actions (   
   contract_   IN VARCHAR2,
   authorize_  IN VARCHAR2) RETURN VARCHAR2
IS
   action_     VARCHAR2(20);
   rec_        Public_Rec;         
BEGIN 
   rec_  := Get(contract_);  
   IF (rec_.over_delivery = 'TRUE') THEN 
      IF authorize_ = 'TRUE' THEN 
         action_ := rec_.action_authorized;
      ELSE
         action_ := rec_.action_non_authorized;
      END IF;
   END IF;
   RETURN action_;
END Get_Over_Delivery_Actions;


PROCEDURE Check_Site_Shipment_Location (
   contract_      IN VARCHAR2,
   location_no_   IN VARCHAR2)
IS
   location_type_ VARCHAR2(20);
BEGIN
   location_type_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   IF (location_type_ != 'SHIPMENT') THEN
      Error_SYS.Record_General(lu_name_,'INVALID_SHIP_LOC: Location :P1 is not a shipment location.', location_no_);
   END IF;
   IF (Inventory_Location_API.Get_Remote_Warehouse(contract_, location_no_) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INV_NON_REM_LOC: Cannot select a remote warehouse location for a site.');
   END IF;
END Check_Site_Shipment_Location;