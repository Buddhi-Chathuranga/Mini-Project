-----------------------------------------------------------------------------
--
--  Logical unit: PackSizeChargeList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170926  RaVdlk   STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  140808  PraWlk  PRSC-2145, Modified Check_Usage() by using state 'CO Created' insted of 'Won' in the condition.
--  140305  SURBLK  Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  131031  MaMalk   Made company mandatory.
--  130206  HimRlk   Added new public column use_price_incl_tax.
--  120130  MaRalk   Added parameter contract to the reference SalesChargeType in the PACK_SIZE_CHARGE_LIST-CHARGE_TYPE 
--  120130           column to avoid model errors generated from PLSQL implementation test.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111116  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST to use the user allowed company filter.
--  110524  NaLrlk   Added Pack Size charge category validation in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  100420  ShKolk   Added created_date, valid_from, valid_to.
--  090930  DaZase   Added length on view comment for charge_list_no and description.
--  081114   MaJalk   Changed association Company to CompanyFinance.
--  081030  MaJalk   Changed implementation method Check_Usage___ to public.
--  081015   MaJalk   Changed error messages at Check_Usage___.
--  081007   MaJalk   Added methods Get_State and Get_State__.
--  081006   MaJalk   Removed attribute currency_code.
--  080828   MaJalk   Added user allowed default site at Prepare_Insert___ and changed cursors at Check_Usage___.
--  080825   MaJalk   Added method Get_Next_Charge_List_No___.
--  080821   MaJalk   Added method Check_Usage___.
--  080806   MaJalk   Added method Post_Insert_Actions___ and modified Update___.
--  080725  MaJalk   Added methods Get_Active_Chg_List_For_Site, Check_Active_Pack_List___.
--  080630  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Post_Insert_Actions___ (
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT PACK_SIZE_CHARGE_LIST_TAB%ROWTYPE )
IS
   target_info_       VARCHAR2(2000);
   target_attr_       VARCHAR2(2000);
BEGIN

   IF (newrec_.contract IS NOT NULL ) THEN
      Client_SYS.Add_To_Attr('CHARGE_LIST_NO', newrec_.charge_list_no, target_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, target_attr_);
      Pack_Size_Charge_List_Site_API.New(target_info_, target_attr_);
   END IF;

END Post_Insert_Actions___;


-- Check_Active_Pack_List___
--   Selects Sites for a given Charge List No and Check whether there is a
--   Active Charge List for the selected sites. This method calls
--   when state change of a charge lists which is in state Planned or Closed.
PROCEDURE Check_Active_Pack_List___ (
   rec_  IN OUT PACK_SIZE_CHARGE_LIST_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   chg_list_no_         PACK_SIZE_CHARGE_LIST_TAB.charge_list_no%TYPE;
   last_calendar_date_  DATE := Database_SYS.last_calendar_date_;

   CURSOR get_active_chg_list (contract_ VARCHAR2)IS
      SELECT   charge_list_no
      FROM     PACK_SIZE_CHARGE_LIST_TAB
      WHERE    charge_list_no IN (SELECT charge_list_no
                                  FROM Pack_Size_Charge_List_Site_Tab
                                  WHERE contract = contract_)
        AND rowstate = 'Active'
        AND charge_list_no != rec_.charge_list_no
        AND use_price_incl_tax = rec_.use_price_incl_tax
        AND (
             ( TRUNC(rec_.valid_from)                        >= TRUNC(valid_from) and TRUNC(rec_.valid_from)                        <= TRUNC(NVL(valid_to, last_calendar_date_)) ) OR
             ( TRUNC(NVL(rec_.valid_to,last_calendar_date_)) >= TRUNC(valid_from) and TRUNC(NVL(rec_.valid_to,last_calendar_date_)) <= TRUNC(NVL(valid_to, last_calendar_date_)) ) OR
             ( TRUNC(rec_.valid_from)                        <= TRUNC(valid_from) and TRUNC(NVL(rec_.valid_to,last_calendar_date_)) >= TRUNC(NVL(valid_to, last_calendar_date_)) ) 
            );


   CURSOR get_contract IS
      SELECT contract
      FROM pack_size_charge_list_site_tab
      WHERE charge_list_no = rec_.charge_list_no;
BEGIN

   FOR contract_rec_ IN get_contract LOOP
      OPEN get_active_chg_list(contract_rec_.contract);
      FETCH get_active_chg_list INTO chg_list_no_;
      CLOSE get_active_chg_list;

      IF (chg_list_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTACTIVATE: There cannot be more than one active pack size charge price list for the same valid site, period and usage of price including tax.');
      END IF;
   END LOOP;

END Check_Active_Pack_List___;


-- Get_Next_Charge_List_No___
--   Returns next number for pack size charge list no from sequence.
FUNCTION Get_Next_Charge_List_No___ RETURN VARCHAR2
IS
   charge_list_no_ PACK_SIZE_CHARGE_LIST_TAB.charge_list_no%TYPE;
BEGIN
   SELECT pack_size_price_list_seq.nextval INTO charge_list_no_ FROM dual;
   RETURN charge_list_no_;
END Get_Next_Charge_List_No___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', User_Allowed_Site_API.Get_Default_Site, attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(User_Allowed_Site_API.Get_Default_Site), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PACK_SIZE_CHARGE_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.charge_list_no IS NULL) THEN
      newrec_.charge_list_no := Get_Next_Charge_List_No___();
      Client_SYS.Add_To_Attr('CHARGE_LIST_NO', newrec_.charge_list_no, attr_);
   END IF;

   super(objid_, objversion_, newrec_, attr_);

   Post_Insert_Actions___(attr_, newrec_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     PACK_SIZE_CHARGE_LIST_TAB%ROWTYPE,
   newrec_     IN OUT PACK_SIZE_CHARGE_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   target_info_       VARCHAR2(2000);
   target_attr_       VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF (newrec_.contract != oldrec_.contract AND
      NOT (Pack_Size_Charge_List_Site_API.Check_Site_Exist(newrec_.charge_list_no, newrec_.contract))) THEN
      Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, target_attr_);
      Client_SYS.Add_To_Attr('CHARGE_LIST_NO', newrec_.charge_list_no, target_attr_);

      Pack_Size_Charge_List_Site_API.New(target_info_, target_attr_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pack_size_charge_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (Site_API.Get_Company(newrec_.contract) != newrec_.company) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDPSCLSITE: Site :P1 is not connected to Company :P2 and can not be added to the Pack Size Charge List.',newrec_.contract, newrec_.company);
   END IF;

   IF Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type) != Sales_Chg_Type_Category_API.db_pack_size THEN
      Error_SYS.Record_General(lu_name_, 'NOTPACKSIZECHG: The specified charge type category should be Pack Size for a given charge type.');
   END IF;
   IF (Sales_Charge_Type_API.Get_Unit_Charge_Db(newrec_.contract, newrec_.charge_type) = Fnd_Boolean_API.db_false) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Unit Charge has not enabled for the Charge Type :P1 at Site :P2.', newrec_.charge_type, newrec_.contract);
   END IF;
   IF newrec_.valid_to < newrec_.valid_from THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_VALID_TO: The Valid To date cannot be earlier than Valid From date.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     pack_size_charge_list_tab%ROWTYPE,
   newrec_ IN OUT pack_size_charge_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;

   IF Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type) != Sales_Chg_Type_Category_API.db_pack_size THEN
      Error_SYS.Record_General(lu_name_, 'NOTPACKSIZECHG: The specified charge type category should be Pack Size for a given charge type.');
   END IF;
   IF (Sales_Charge_Type_API.Get_Unit_Charge_Db(newrec_.contract, newrec_.charge_type) = Fnd_Boolean_API.db_false) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Unit Charge has not enabled for the Charge Type :P1 at Site :P2.', newrec_.charge_type, newrec_.contract);
   END IF;
   IF newrec_.valid_to < newrec_.valid_from THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_VALID_TO: The Valid To date cannot be earlier than Valid From date.');
   END IF;
   IF newrec_.rowstate = 'Active' THEN
      Check_Active_Pack_List___(newrec_, attr_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Active_Chg_List_For_Site
--   Selects Active Charge List No for a given Site and use price incl tax value.
@UncheckedAccess
FUNCTION Get_Active_Chg_List_For_Site (
   contract_               IN VARCHAR2,
   price_effectivity_date_ IN DATE,
   use_price_incl_tax_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ PACK_SIZE_CHARGE_LIST_TAB.charge_list_no%TYPE;
   CURSOR get_active_chg_list IS
      SELECT   charge_list_no
      FROM     PACK_SIZE_CHARGE_LIST_TAB
      WHERE    charge_list_no IN (SELECT charge_list_no
                                  FROM Pack_Size_Charge_List_Site_Tab
                                  WHERE contract = contract_)
        AND rowstate = 'Active'
        AND use_price_incl_tax = use_price_incl_tax_db_
        AND TRUNC(price_effectivity_date_) >= TRUNC(valid_from)
        AND TRUNC(price_effectivity_date_) <= TRUNC(NVL(valid_to, Database_SYS.last_calendar_date_));
BEGIN
   OPEN get_active_chg_list;
   FETCH get_active_chg_list INTO temp_;
   CLOSE get_active_chg_list;
   RETURN temp_;
END Get_Active_Chg_List_For_Site;

-- Check_Usage
--   Check CO and SQ which are in process, that used pack size charge list.
@UncheckedAccess
FUNCTION Check_Usage (
   charge_list_no_ IN VARCHAR2,
   charge_type_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_   NUMBER;

   CURSOR get_cust_order IS
      SELECT 1
      FROM customer_order_line_tab colt, customer_order_charge_tab coct
      WHERE colt.order_no = coct.order_no
      AND   colt.line_no = coct.line_no
      AND   colt.rel_no = coct.rel_no
      AND   colt.line_item_no = coct.line_item_no
      AND   coct.charge_type = charge_type_
      AND   coct.charge_price_list_no = charge_list_no_
      AND   colt.rowstate NOT IN ('Invoiced', 'Cancelled');


   CURSOR get_order_quot IS
      SELECT 1
      FROM order_quotation_line_tab oqlt, order_quotation_charge_tab oqct
      WHERE oqlt.quotation_no = oqct.quotation_no
      AND   oqlt.line_no = oqct.line_no
      AND   oqlt.rel_no = oqct.rel_no
      AND   oqlt.line_item_no = oqct.line_item_no
      AND   oqct.charge_type = charge_type_
      AND   oqct.charge_price_list_no = charge_list_no_
      AND   oqlt.rowstate NOT IN ('Cancelled', 'CO Created', 'Lost');
BEGIN

   OPEN get_cust_order;
   FETCH get_cust_order INTO exist_;
   IF (get_cust_order%FOUND) THEN
      CLOSE get_cust_order;
      RETURN('ORDER_FOUND');
   END IF;
   CLOSE get_cust_order;

   OPEN get_order_quot;
   FETCH get_order_quot INTO exist_;
   IF (get_order_quot%FOUND) THEN
      CLOSE get_order_quot;
      RETURN('QUOTATION_FOUND');
   END IF;
   CLOSE get_order_quot;
   RETURN('NOT_FOUND');
END Check_Usage;




