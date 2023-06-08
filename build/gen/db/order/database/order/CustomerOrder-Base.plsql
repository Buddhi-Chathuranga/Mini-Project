-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrder
--  Component:    ORDER
--
--  Template:     3.0
--  Built by:     IFS Developer Studio (unit-test)
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Base;

-------------------- PUBLIC DECLARATIONS ------------------------------------

--TYPE Primary_Key_Rec IS RECORD
--  (order_no                       CUSTOMER_ORDER_TAB.order_no%TYPE);

TYPE Public_Rec IS RECORD
  (order_no                       CUSTOMER_ORDER_TAB.order_no%TYPE,
   "rowid"                        rowid,
   rowversion                     CUSTOMER_ORDER_TAB.rowversion%TYPE,
   rowkey                         CUSTOMER_ORDER_TAB.rowkey%TYPE,
   rowstate                       CUSTOMER_ORDER_TAB.rowstate%TYPE,
   authorize_code                 CUSTOMER_ORDER_TAB.authorize_code%TYPE,
   bill_addr_no                   CUSTOMER_ORDER_TAB.bill_addr_no%TYPE,
   contract                       CUSTOMER_ORDER_TAB.contract%TYPE,
   country_code                   CUSTOMER_ORDER_TAB.country_code%TYPE,
   currency_code                  CUSTOMER_ORDER_TAB.currency_code%TYPE,
   customer_no                    CUSTOMER_ORDER_TAB.customer_no%TYPE,
   customer_no_pay                CUSTOMER_ORDER_TAB.customer_no_pay%TYPE,
   customer_no_pay_addr_no        CUSTOMER_ORDER_TAB.customer_no_pay_addr_no%TYPE,
   customer_no_pay_ref            CUSTOMER_ORDER_TAB.customer_no_pay_ref%TYPE,
   delivery_terms                 CUSTOMER_ORDER_TAB.delivery_terms%TYPE,
   district_code                  CUSTOMER_ORDER_TAB.district_code%TYPE,
   language_code                  CUSTOMER_ORDER_TAB.language_code%TYPE,
   market_code                    CUSTOMER_ORDER_TAB.market_code%TYPE,
   note_id                        CUSTOMER_ORDER_TAB.note_id%TYPE,
   order_code                     CUSTOMER_ORDER_TAB.order_code%TYPE,
   order_id                       CUSTOMER_ORDER_TAB.order_id%TYPE,
   pay_term_id                    CUSTOMER_ORDER_TAB.pay_term_id%TYPE,
   pre_accounting_id              CUSTOMER_ORDER_TAB.pre_accounting_id%TYPE,
   print_control_code             CUSTOMER_ORDER_TAB.print_control_code%TYPE,
   region_code                    CUSTOMER_ORDER_TAB.region_code%TYPE,
   salesman_code                  CUSTOMER_ORDER_TAB.salesman_code%TYPE,
   ship_addr_no                   CUSTOMER_ORDER_TAB.ship_addr_no%TYPE,
   ship_via_code                  CUSTOMER_ORDER_TAB.ship_via_code%TYPE,
   addr_flag                      CUSTOMER_ORDER_TAB.addr_flag%TYPE,
   grp_disc_calc_flag             CUSTOMER_ORDER_TAB.grp_disc_calc_flag%TYPE,
   customer_po_no                 CUSTOMER_ORDER_TAB.customer_po_no%TYPE,
   cust_ref                       CUSTOMER_ORDER_TAB.cust_ref%TYPE,
   date_entered                   CUSTOMER_ORDER_TAB.date_entered%TYPE,
   delivery_leadtime              CUSTOMER_ORDER_TAB.delivery_leadtime%TYPE,
   label_note                     CUSTOMER_ORDER_TAB.label_note%TYPE,
   note_text                      CUSTOMER_ORDER_TAB.note_text%TYPE,
   order_conf                     CUSTOMER_ORDER_TAB.order_conf%TYPE,
   tax_liability                  CUSTOMER_ORDER_TAB.tax_liability%TYPE,
   wanted_delivery_date           CUSTOMER_ORDER_TAB.wanted_delivery_date%TYPE,
   internal_po_no                 CUSTOMER_ORDER_TAB.internal_po_no%TYPE,
   route_id                       CUSTOMER_ORDER_TAB.route_id%TYPE,
   agreement_id                   CUSTOMER_ORDER_TAB.agreement_id%TYPE,
   forward_agent_id               CUSTOMER_ORDER_TAB.forward_agent_id%TYPE,
   internal_delivery_type         CUSTOMER_ORDER_TAB.internal_delivery_type%TYPE,
   external_ref                   CUSTOMER_ORDER_TAB.external_ref%TYPE,
   project_id                     CUSTOMER_ORDER_TAB.project_id%TYPE,
   staged_billing                 CUSTOMER_ORDER_TAB.staged_billing%TYPE,
   sm_connection                  CUSTOMER_ORDER_TAB.sm_connection%TYPE,
   scheduling_connection          CUSTOMER_ORDER_TAB.scheduling_connection%TYPE,
   priority                       CUSTOMER_ORDER_TAB.priority%TYPE,
   intrastat_exempt               CUSTOMER_ORDER_TAB.intrastat_exempt%TYPE,
   additional_discount            CUSTOMER_ORDER_TAB.additional_discount%TYPE,
   pay_term_base_date             CUSTOMER_ORDER_TAB.pay_term_base_date%TYPE,
   summarized_source_lines        CUSTOMER_ORDER_TAB.summarized_source_lines%TYPE,
   case_id                        CUSTOMER_ORDER_TAB.case_id%TYPE,
   task_id                        CUSTOMER_ORDER_TAB.task_id%TYPE,
   confirm_deliveries             CUSTOMER_ORDER_TAB.confirm_deliveries%TYPE,
   check_sales_grp_deliv_conf     CUSTOMER_ORDER_TAB.check_sales_grp_deliv_conf%TYPE,
   delay_cogs_to_deliv_conf       CUSTOMER_ORDER_TAB.delay_cogs_to_deliv_conf%TYPE,
   cancel_reason                  CUSTOMER_ORDER_TAB.cancel_reason%TYPE,
   jinsui_invoice                 CUSTOMER_ORDER_TAB.jinsui_invoice%TYPE,
   blocked_reason                 CUSTOMER_ORDER_TAB.blocked_reason%TYPE,
   blocked_from_state             CUSTOMER_ORDER_TAB.blocked_from_state%TYPE,
   sales_contract_no              CUSTOMER_ORDER_TAB.sales_contract_no%TYPE,
   contract_rev_seq               CUSTOMER_ORDER_TAB.contract_rev_seq%TYPE,
   contract_line_no               CUSTOMER_ORDER_TAB.contract_line_no%TYPE,
   contract_item_no               CUSTOMER_ORDER_TAB.contract_item_no%TYPE,
   released_from_credit_check     CUSTOMER_ORDER_TAB.released_from_credit_check%TYPE,
   proposed_prepayment_amount     CUSTOMER_ORDER_TAB.proposed_prepayment_amount%TYPE,
   prepayment_approved            CUSTOMER_ORDER_TAB.prepayment_approved%TYPE,
   backorder_option               CUSTOMER_ORDER_TAB.backorder_option%TYPE,
   expected_prepayment_date       CUSTOMER_ORDER_TAB.expected_prepayment_date%TYPE,
   shipment_creation              CUSTOMER_ORDER_TAB.shipment_creation%TYPE,
   use_pre_ship_del_note          CUSTOMER_ORDER_TAB.use_pre_ship_del_note%TYPE,
   pick_inventory_type            CUSTOMER_ORDER_TAB.pick_inventory_type%TYPE,
   tax_id_no                      CUSTOMER_ORDER_TAB.tax_id_no%TYPE,
   tax_id_validated_date          CUSTOMER_ORDER_TAB.tax_id_validated_date%TYPE,
   classification_standard        CUSTOMER_ORDER_TAB.classification_standard%TYPE,
   msg_sequence_no                CUSTOMER_ORDER_TAB.msg_sequence_no%TYPE,
   msg_version_no                 CUSTOMER_ORDER_TAB.msg_version_no%TYPE,
   currency_rate_type             CUSTOMER_ORDER_TAB.currency_rate_type%TYPE,
   del_terms_location             CUSTOMER_ORDER_TAB.del_terms_location%TYPE,
   internal_ref                   CUSTOMER_ORDER_TAB.internal_ref%TYPE,
   internal_po_label_note         CUSTOMER_ORDER_TAB.internal_po_label_note%TYPE,
   supply_country                 CUSTOMER_ORDER_TAB.supply_country%TYPE,
   rebate_customer                CUSTOMER_ORDER_TAB.rebate_customer%TYPE,
   freight_map_id                 CUSTOMER_ORDER_TAB.freight_map_id%TYPE,
   zone_id                        CUSTOMER_ORDER_TAB.zone_id%TYPE,
   freight_price_list_no          CUSTOMER_ORDER_TAB.freight_price_list_no%TYPE,
   summarized_freight_charges     CUSTOMER_ORDER_TAB.summarized_freight_charges%TYPE,
   apply_fix_deliv_freight        CUSTOMER_ORDER_TAB.apply_fix_deliv_freight%TYPE,
   fix_deliv_freight              CUSTOMER_ORDER_TAB.fix_deliv_freight%TYPE,
   print_delivered_lines          CUSTOMER_ORDER_TAB.print_delivered_lines%TYPE,
   cust_calendar_id               CUSTOMER_ORDER_TAB.cust_calendar_id%TYPE,
   ext_transport_calendar_id      CUSTOMER_ORDER_TAB.ext_transport_calendar_id%TYPE,
   use_price_incl_tax             CUSTOMER_ORDER_TAB.use_price_incl_tax%TYPE,
   customs_value_currency         CUSTOMER_ORDER_TAB.customs_value_currency%TYPE,
   business_opportunity_no        CUSTOMER_ORDER_TAB.business_opportunity_no%TYPE,
   picking_leadtime               CUSTOMER_ORDER_TAB.picking_leadtime%TYPE,
   shipment_type                  CUSTOMER_ORDER_TAB.shipment_type%TYPE,
   vendor_no                      CUSTOMER_ORDER_TAB.vendor_no%TYPE,
   quotation_no                   CUSTOMER_ORDER_TAB.quotation_no%TYPE,
   free_of_chg_tax_pay_party      CUSTOMER_ORDER_TAB.free_of_chg_tax_pay_party%TYPE,
   blocked_type                   CUSTOMER_ORDER_TAB.blocked_type%TYPE,
   b2b_order                      CUSTOMER_ORDER_TAB.b2b_order%TYPE,
   limit_sales_to_assortments     CUSTOMER_ORDER_TAB.limit_sales_to_assortments%TYPE,
   final_consumer                 CUSTOMER_ORDER_TAB.final_consumer%TYPE,
   customer_tax_usage_type        CUSTOMER_ORDER_TAB.customer_tax_usage_type%TYPE,
   invoice_reason_id              CUSTOMER_ORDER_TAB.invoice_reason_id%TYPE,
   delivery_reason_id             CUSTOMER_ORDER_TAB.delivery_reason_id%TYPE,
   component_a                    CUSTOMER_ORDER_TAB.component_a%TYPE,
   service_code                   CUSTOMER_ORDER_TAB.service_code%TYPE,
   disc_price_round               CUSTOMER_ORDER_TAB.disc_price_round%TYPE,
   business_transaction_id        CUSTOMER_ORDER_TAB.business_transaction_id%TYPE,
   invoiced_closed_date           CUSTOMER_ORDER_TAB.invoiced_closed_date%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (order_no                       BOOLEAN := FALSE,
   authorize_code                 BOOLEAN := FALSE,
   bill_addr_no                   BOOLEAN := FALSE,
   contract                       BOOLEAN := FALSE,
   country_code                   BOOLEAN := FALSE,
   currency_code                  BOOLEAN := FALSE,
   customer_no                    BOOLEAN := FALSE,
   customer_no_pay                BOOLEAN := FALSE,
   customer_no_pay_addr_no        BOOLEAN := FALSE,
   customer_no_pay_ref            BOOLEAN := FALSE,
   delivery_terms                 BOOLEAN := FALSE,
   district_code                  BOOLEAN := FALSE,
   language_code                  BOOLEAN := FALSE,
   market_code                    BOOLEAN := FALSE,
   note_id                        BOOLEAN := FALSE,
   order_code                     BOOLEAN := FALSE,
   order_id                       BOOLEAN := FALSE,
   pay_term_id                    BOOLEAN := FALSE,
   pre_accounting_id              BOOLEAN := FALSE,
   print_control_code             BOOLEAN := FALSE,
   region_code                    BOOLEAN := FALSE,
   salesman_code                  BOOLEAN := FALSE,
   ship_addr_no                   BOOLEAN := FALSE,
   ship_via_code                  BOOLEAN := FALSE,
   addr_flag                      BOOLEAN := FALSE,
   grp_disc_calc_flag             BOOLEAN := FALSE,
   customer_po_no                 BOOLEAN := FALSE,
   cust_ref                       BOOLEAN := FALSE,
   date_entered                   BOOLEAN := FALSE,
   delivery_leadtime              BOOLEAN := FALSE,
   label_note                     BOOLEAN := FALSE,
   note_text                      BOOLEAN := FALSE,
   order_conf                     BOOLEAN := FALSE,
   order_conf_flag                BOOLEAN := FALSE,
   pack_list_flag                 BOOLEAN := FALSE,
   pick_list_flag                 BOOLEAN := FALSE,
   tax_liability                  BOOLEAN := FALSE,
   wanted_delivery_date           BOOLEAN := FALSE,
   internal_po_no                 BOOLEAN := FALSE,
   route_id                       BOOLEAN := FALSE,
   agreement_id                   BOOLEAN := FALSE,
   forward_agent_id               BOOLEAN := FALSE,
   internal_delivery_type         BOOLEAN := FALSE,
   external_ref                   BOOLEAN := FALSE,
   project_id                     BOOLEAN := FALSE,
   staged_billing                 BOOLEAN := FALSE,
   sm_connection                  BOOLEAN := FALSE,
   scheduling_connection          BOOLEAN := FALSE,
   priority                       BOOLEAN := FALSE,
   intrastat_exempt               BOOLEAN := FALSE,
   additional_discount            BOOLEAN := FALSE,
   pay_term_base_date             BOOLEAN := FALSE,
   summarized_source_lines        BOOLEAN := FALSE,
   case_id                        BOOLEAN := FALSE,
   task_id                        BOOLEAN := FALSE,
   confirm_deliveries             BOOLEAN := FALSE,
   check_sales_grp_deliv_conf     BOOLEAN := FALSE,
   delay_cogs_to_deliv_conf       BOOLEAN := FALSE,
   cancel_reason                  BOOLEAN := FALSE,
   jinsui_invoice                 BOOLEAN := FALSE,
   blocked_reason                 BOOLEAN := FALSE,
   blocked_from_state             BOOLEAN := FALSE,
   sales_contract_no              BOOLEAN := FALSE,
   contract_rev_seq               BOOLEAN := FALSE,
   contract_line_no               BOOLEAN := FALSE,
   contract_item_no               BOOLEAN := FALSE,
   released_from_credit_check     BOOLEAN := FALSE,
   proposed_prepayment_amount     BOOLEAN := FALSE,
   prepayment_approved            BOOLEAN := FALSE,
   backorder_option               BOOLEAN := FALSE,
   expected_prepayment_date       BOOLEAN := FALSE,
   shipment_creation              BOOLEAN := FALSE,
   use_pre_ship_del_note          BOOLEAN := FALSE,
   pick_inventory_type            BOOLEAN := FALSE,
   tax_id_no                      BOOLEAN := FALSE,
   tax_id_validated_date          BOOLEAN := FALSE,
   classification_standard        BOOLEAN := FALSE,
   msg_sequence_no                BOOLEAN := FALSE,
   msg_version_no                 BOOLEAN := FALSE,
   currency_rate_type             BOOLEAN := FALSE,
   del_terms_location             BOOLEAN := FALSE,
   internal_ref                   BOOLEAN := FALSE,
   internal_po_label_note         BOOLEAN := FALSE,
   supply_country                 BOOLEAN := FALSE,
   rebate_customer                BOOLEAN := FALSE,
   freight_map_id                 BOOLEAN := FALSE,
   zone_id                        BOOLEAN := FALSE,
   freight_price_list_no          BOOLEAN := FALSE,
   summarized_freight_charges     BOOLEAN := FALSE,
   apply_fix_deliv_freight        BOOLEAN := FALSE,
   fix_deliv_freight              BOOLEAN := FALSE,
   print_delivered_lines          BOOLEAN := FALSE,
   cust_calendar_id               BOOLEAN := FALSE,
   ext_transport_calendar_id      BOOLEAN := FALSE,
   use_price_incl_tax             BOOLEAN := FALSE,
   customs_value_currency         BOOLEAN := FALSE,
   business_opportunity_no        BOOLEAN := FALSE,
   picking_leadtime               BOOLEAN := FALSE,
   shipment_type                  BOOLEAN := FALSE,
   vendor_no                      BOOLEAN := FALSE,
   quotation_no                   BOOLEAN := FALSE,
   free_of_chg_tax_pay_party      BOOLEAN := FALSE,
   blocked_type                   BOOLEAN := FALSE,
   b2b_order                      BOOLEAN := FALSE,
   main_representative_id         BOOLEAN := FALSE,
   limit_sales_to_assortments     BOOLEAN := FALSE,
   final_consumer                 BOOLEAN := FALSE,
   customer_tax_usage_type        BOOLEAN := FALSE,
   invoice_reason_id              BOOLEAN := FALSE,
   delivery_reason_id             BOOLEAN := FALSE,
   component_a                    BOOLEAN := FALSE,
   service_code                   BOOLEAN := FALSE,
   disc_price_round               BOOLEAN := FALSE,
   business_transaction_id        BOOLEAN := FALSE,
   invoiced_closed_date           BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'ORDER_NO', order_no_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'ORDER_NO', Fnd_Session_API.Get_Language) || ': ' || order_no_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   order_no_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(order_no_),
                            Formatted_Key___(order_no_));
   Error_SYS.Fnd_Too_Many_Rows(Customer_Order_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(order_no_),
                            Formatted_Key___(order_no_));
   Error_SYS.Fnd_Record_Not_Exist(Customer_Order_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN customer_order_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.order_no),
                            Formatted_Key___(rec_.order_no));
   Error_SYS.Fnd_Record_Exist(Customer_Order_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN customer_order_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Customer_Order_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Customer_Order_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN customer_order_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.order_no),
                            Formatted_Key___(rec_.order_no));
   Error_SYS.Fnd_Record_Modified(Customer_Order_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(order_no_),
                            Formatted_Key___(order_no_));
   Error_SYS.Fnd_Record_Locked(Customer_Order_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(order_no_),
                            Formatted_Key___(order_no_));
   Error_SYS.Fnd_Record_Removed(Customer_Order_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN customer_order_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customer_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  customer_order_tab
      WHERE rowid = objid_
      AND    to_char(rowversion,'YYYYMMDDHH24MISS') = objversion_
      FOR UPDATE NOWAIT;
   RETURN rec_;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Fnd_Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT *
            INTO  rec_
            FROM  customer_order_tab
            WHERE rowid = objid_;
         Raise_Record_Modified___(rec_);
      EXCEPTION
         WHEN no_data_found THEN
            Error_SYS.Fnd_Record_Removed(lu_name_);
         WHEN too_many_rows THEN
            Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
      END;
END Lock_By_Id___;


-- Lock_By_Keys___
--    Locks a database row based on the primary key values.
--    Waits until record released if locked by another session.
FUNCTION Lock_By_Keys___ (
   order_no_ IN VARCHAR2) RETURN customer_order_tab%ROWTYPE
IS
   rec_        customer_order_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customer_order_tab
         WHERE order_no = order_no_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(order_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(order_no_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   order_no_ IN VARCHAR2) RETURN customer_order_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customer_order_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customer_order_tab
         WHERE order_no = order_no_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(order_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(order_no_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(order_no_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN customer_order_tab%ROWTYPE
IS
   lu_rec_ customer_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customer_order_tab
      WHERE rowid = objid_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Fnd_Record_Removed(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Get_Object_By_Id___');
END Get_Object_By_Id___;


-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab%ROWTYPE
IS
   lu_rec_ customer_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Check_Exist___');
END Check_Exist___;





-- Get_Version_By_Id___
--    Fetched the objversion for a database row based on the objid.
PROCEDURE Get_Version_By_Id___ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objversion_
      FROM  customer_order_tab
      WHERE rowid = objid_;
EXCEPTION
   WHEN no_data_found THEN
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Get_Version_By_Id___');
END Get_Version_By_Id___;


-- Get_Version_By_Keys___
--    Fetched the objversion for a database row based on the primary key.
PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   order_no_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT customer_order_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);
BEGIN
   Reset_Indicator_Rec___(indrec_);
   Client_SYS.Clear_Attr(msg_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('ORDER_NO') THEN
         newrec_.order_no := value_;
         indrec_.order_no := TRUE;
      WHEN ('AUTHORIZE_CODE') THEN
         newrec_.authorize_code := value_;
         indrec_.authorize_code := TRUE;
      WHEN ('BILL_ADDR_NO') THEN
         newrec_.bill_addr_no := value_;
         indrec_.bill_addr_no := TRUE;
      WHEN ('CONTRACT') THEN
         newrec_.contract := value_;
         indrec_.contract := TRUE;
      WHEN ('COUNTRY_CODE') THEN
         newrec_.country_code := value_;
         indrec_.country_code := TRUE;
      WHEN ('CURRENCY_CODE') THEN
         newrec_.currency_code := value_;
         indrec_.currency_code := TRUE;
      WHEN ('CUSTOMER_NO') THEN
         newrec_.customer_no := value_;
         indrec_.customer_no := TRUE;
      WHEN ('CUSTOMER_NO_PAY') THEN
         newrec_.customer_no_pay := value_;
         indrec_.customer_no_pay := TRUE;
      WHEN ('CUSTOMER_NO_PAY_ADDR_NO') THEN
         newrec_.customer_no_pay_addr_no := value_;
         indrec_.customer_no_pay_addr_no := TRUE;
      WHEN ('CUSTOMER_NO_PAY_REF') THEN
         newrec_.customer_no_pay_ref := value_;
         indrec_.customer_no_pay_ref := TRUE;
      WHEN ('DELIVERY_TERMS') THEN
         newrec_.delivery_terms := value_;
         indrec_.delivery_terms := TRUE;
      WHEN ('DISTRICT_CODE') THEN
         newrec_.district_code := value_;
         indrec_.district_code := TRUE;
      WHEN ('LANGUAGE_CODE') THEN
         newrec_.language_code := value_;
         indrec_.language_code := TRUE;
      WHEN ('MARKET_CODE') THEN
         newrec_.market_code := value_;
         indrec_.market_code := TRUE;
      WHEN ('NOTE_ID') THEN
         newrec_.note_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.note_id := TRUE;
      WHEN ('ORDER_CODE') THEN
         newrec_.order_code := value_;
         indrec_.order_code := TRUE;
      WHEN ('ORDER_ID') THEN
         newrec_.order_id := value_;
         indrec_.order_id := TRUE;
      WHEN ('PAY_TERM_ID') THEN
         newrec_.pay_term_id := value_;
         indrec_.pay_term_id := TRUE;
      WHEN ('PRE_ACCOUNTING_ID') THEN
         newrec_.pre_accounting_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.pre_accounting_id := TRUE;
      WHEN ('PRINT_CONTROL_CODE') THEN
         newrec_.print_control_code := value_;
         indrec_.print_control_code := TRUE;
      WHEN ('REGION_CODE') THEN
         newrec_.region_code := value_;
         indrec_.region_code := TRUE;
      WHEN ('SALESMAN_CODE') THEN
         newrec_.salesman_code := value_;
         indrec_.salesman_code := TRUE;
      WHEN ('SHIP_ADDR_NO') THEN
         newrec_.ship_addr_no := value_;
         indrec_.ship_addr_no := TRUE;
      WHEN ('SHIP_VIA_CODE') THEN
         newrec_.ship_via_code := value_;
         indrec_.ship_via_code := TRUE;
      WHEN ('ADDR_FLAG') THEN
         newrec_.addr_flag := Gen_Yes_No_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.addr_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.addr_flag := TRUE;
      WHEN ('ADDR_FLAG_DB') THEN
         newrec_.addr_flag := value_;
         indrec_.addr_flag := TRUE;
      WHEN ('GRP_DISC_CALC_FLAG') THEN
         newrec_.grp_disc_calc_flag := Gen_Yes_No_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.grp_disc_calc_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.grp_disc_calc_flag := TRUE;
      WHEN ('GRP_DISC_CALC_FLAG_DB') THEN
         newrec_.grp_disc_calc_flag := value_;
         indrec_.grp_disc_calc_flag := TRUE;
      WHEN ('CUSTOMER_PO_NO') THEN
         newrec_.customer_po_no := value_;
         indrec_.customer_po_no := TRUE;
      WHEN ('CUST_REF') THEN
         newrec_.cust_ref := value_;
         indrec_.cust_ref := TRUE;
      WHEN ('DATE_ENTERED') THEN
         newrec_.date_entered := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.date_entered := TRUE;
      WHEN ('DELIVERY_LEADTIME') THEN
         newrec_.delivery_leadtime := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.delivery_leadtime := TRUE;
      WHEN ('LABEL_NOTE') THEN
         newrec_.label_note := value_;
         indrec_.label_note := TRUE;
      WHEN ('NOTE_TEXT') THEN
         newrec_.note_text := value_;
         indrec_.note_text := TRUE;
      WHEN ('ORDER_CONF') THEN
         newrec_.order_conf := Order_Confirmation_Printed_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.order_conf IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.order_conf := TRUE;
      WHEN ('ORDER_CONF_DB') THEN
         newrec_.order_conf := value_;
         indrec_.order_conf := TRUE;
      WHEN ('ORDER_CONF_FLAG') THEN
         newrec_.order_conf_flag := Print_Order_Confirmation_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.order_conf_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.order_conf_flag := TRUE;
      WHEN ('ORDER_CONF_FLAG_DB') THEN
         newrec_.order_conf_flag := value_;
         indrec_.order_conf_flag := TRUE;
      WHEN ('PACK_LIST_FLAG') THEN
         newrec_.pack_list_flag := Print_Pack_List_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.pack_list_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.pack_list_flag := TRUE;
      WHEN ('PACK_LIST_FLAG_DB') THEN
         newrec_.pack_list_flag := value_;
         indrec_.pack_list_flag := TRUE;
      WHEN ('PICK_LIST_FLAG') THEN
         newrec_.pick_list_flag := Print_Pick_List_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.pick_list_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.pick_list_flag := TRUE;
      WHEN ('PICK_LIST_FLAG_DB') THEN
         newrec_.pick_list_flag := value_;
         indrec_.pick_list_flag := TRUE;
      WHEN ('TAX_LIABILITY') THEN
         newrec_.tax_liability := value_;
         indrec_.tax_liability := TRUE;
      WHEN ('WANTED_DELIVERY_DATE') THEN
         newrec_.wanted_delivery_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.wanted_delivery_date := TRUE;
      WHEN ('INTERNAL_PO_NO') THEN
         newrec_.internal_po_no := value_;
         indrec_.internal_po_no := TRUE;
      WHEN ('ROUTE_ID') THEN
         newrec_.route_id := value_;
         indrec_.route_id := TRUE;
      WHEN ('AGREEMENT_ID') THEN
         newrec_.agreement_id := value_;
         indrec_.agreement_id := TRUE;
      WHEN ('FORWARD_AGENT_ID') THEN
         newrec_.forward_agent_id := value_;
         indrec_.forward_agent_id := TRUE;
      WHEN ('INTERNAL_DELIVERY_TYPE') THEN
         newrec_.internal_delivery_type := Order_Delivery_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.internal_delivery_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.internal_delivery_type := TRUE;
      WHEN ('INTERNAL_DELIVERY_TYPE_DB') THEN
         newrec_.internal_delivery_type := value_;
         indrec_.internal_delivery_type := TRUE;
      WHEN ('EXTERNAL_REF') THEN
         newrec_.external_ref := value_;
         indrec_.external_ref := TRUE;
      WHEN ('PROJECT_ID') THEN
         newrec_.project_id := value_;
         indrec_.project_id := TRUE;
      WHEN ('STAGED_BILLING') THEN
         newrec_.staged_billing := Staged_Billing_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.staged_billing IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.staged_billing := TRUE;
      WHEN ('STAGED_BILLING_DB') THEN
         newrec_.staged_billing := value_;
         indrec_.staged_billing := TRUE;
      WHEN ('SM_CONNECTION') THEN
         newrec_.sm_connection := Service_Management_Connect_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.sm_connection IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.sm_connection := TRUE;
      WHEN ('SM_CONNECTION_DB') THEN
         newrec_.sm_connection := value_;
         indrec_.sm_connection := TRUE;
      WHEN ('SCHEDULING_CONNECTION') THEN
         newrec_.scheduling_connection := Schedule_Agreement_Order_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.scheduling_connection IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.scheduling_connection := TRUE;
      WHEN ('SCHEDULING_CONNECTION_DB') THEN
         newrec_.scheduling_connection := value_;
         indrec_.scheduling_connection := TRUE;
      WHEN ('PRIORITY') THEN
         newrec_.priority := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.priority := TRUE;
      WHEN ('INTRASTAT_EXEMPT') THEN
         newrec_.intrastat_exempt := Intrastat_Exempt_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.intrastat_exempt IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.intrastat_exempt := TRUE;
      WHEN ('INTRASTAT_EXEMPT_DB') THEN
         newrec_.intrastat_exempt := value_;
         indrec_.intrastat_exempt := TRUE;
      WHEN ('ADDITIONAL_DISCOUNT') THEN
         newrec_.additional_discount := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.additional_discount := TRUE;
      WHEN ('PAY_TERM_BASE_DATE') THEN
         newrec_.pay_term_base_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.pay_term_base_date := TRUE;
      WHEN ('SUMMARIZED_SOURCE_LINES') THEN
         newrec_.summarized_source_lines := Gen_Yes_No_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.summarized_source_lines IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.summarized_source_lines := TRUE;
      WHEN ('SUMMARIZED_SOURCE_LINES_DB') THEN
         newrec_.summarized_source_lines := value_;
         indrec_.summarized_source_lines := TRUE;
      WHEN ('CASE_ID') THEN
         newrec_.case_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.case_id := TRUE;
      WHEN ('TASK_ID') THEN
         newrec_.task_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.task_id := TRUE;
      WHEN ('CONFIRM_DELIVERIES') THEN
         newrec_.confirm_deliveries := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.confirm_deliveries IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.confirm_deliveries := TRUE;
      WHEN ('CONFIRM_DELIVERIES_DB') THEN
         newrec_.confirm_deliveries := value_;
         indrec_.confirm_deliveries := TRUE;
      WHEN ('CHECK_SALES_GRP_DELIV_CONF') THEN
         newrec_.check_sales_grp_deliv_conf := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.check_sales_grp_deliv_conf IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.check_sales_grp_deliv_conf := TRUE;
      WHEN ('CHECK_SALES_GRP_DELIV_CONF_DB') THEN
         newrec_.check_sales_grp_deliv_conf := value_;
         indrec_.check_sales_grp_deliv_conf := TRUE;
      WHEN ('DELAY_COGS_TO_DELIV_CONF') THEN
         newrec_.delay_cogs_to_deliv_conf := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.delay_cogs_to_deliv_conf IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.delay_cogs_to_deliv_conf := TRUE;
      WHEN ('DELAY_COGS_TO_DELIV_CONF_DB') THEN
         newrec_.delay_cogs_to_deliv_conf := value_;
         indrec_.delay_cogs_to_deliv_conf := TRUE;
      WHEN ('CANCEL_REASON') THEN
         newrec_.cancel_reason := value_;
         indrec_.cancel_reason := TRUE;
      WHEN ('JINSUI_INVOICE') THEN
         newrec_.jinsui_invoice := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.jinsui_invoice IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.jinsui_invoice := TRUE;
      WHEN ('JINSUI_INVOICE_DB') THEN
         newrec_.jinsui_invoice := value_;
         indrec_.jinsui_invoice := TRUE;
      WHEN ('BLOCKED_REASON') THEN
         newrec_.blocked_reason := value_;
         indrec_.blocked_reason := TRUE;
      WHEN ('BLOCKED_FROM_STATE') THEN
         newrec_.blocked_from_state := value_;
         indrec_.blocked_from_state := TRUE;
      WHEN ('SALES_CONTRACT_NO') THEN
         newrec_.sales_contract_no := value_;
         indrec_.sales_contract_no := TRUE;
      WHEN ('CONTRACT_REV_SEQ') THEN
         newrec_.contract_rev_seq := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.contract_rev_seq := TRUE;
      WHEN ('CONTRACT_LINE_NO') THEN
         newrec_.contract_line_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.contract_line_no := TRUE;
      WHEN ('CONTRACT_ITEM_NO') THEN
         newrec_.contract_item_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.contract_item_no := TRUE;
      WHEN ('RELEASED_FROM_CREDIT_CHECK') THEN
         newrec_.released_from_credit_check := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.released_from_credit_check IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.released_from_credit_check := TRUE;
      WHEN ('RELEASED_FROM_CREDIT_CHECK_DB') THEN
         newrec_.released_from_credit_check := value_;
         indrec_.released_from_credit_check := TRUE;
      WHEN ('PROPOSED_PREPAYMENT_AMOUNT') THEN
         newrec_.proposed_prepayment_amount := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.proposed_prepayment_amount := TRUE;
      WHEN ('PREPAYMENT_APPROVED') THEN
         newrec_.prepayment_approved := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.prepayment_approved IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.prepayment_approved := TRUE;
      WHEN ('PREPAYMENT_APPROVED_DB') THEN
         newrec_.prepayment_approved := value_;
         indrec_.prepayment_approved := TRUE;
      WHEN ('BACKORDER_OPTION') THEN
         newrec_.backorder_option := Customer_Backorder_Option_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.backorder_option IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.backorder_option := TRUE;
      WHEN ('BACKORDER_OPTION_DB') THEN
         newrec_.backorder_option := value_;
         indrec_.backorder_option := TRUE;
      WHEN ('EXPECTED_PREPAYMENT_DATE') THEN
         newrec_.expected_prepayment_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.expected_prepayment_date := TRUE;
      WHEN ('SHIPMENT_CREATION') THEN
         newrec_.shipment_creation := Shipment_Creation_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.shipment_creation IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.shipment_creation := TRUE;
      WHEN ('SHIPMENT_CREATION_DB') THEN
         newrec_.shipment_creation := value_;
         indrec_.shipment_creation := TRUE;
      WHEN ('USE_PRE_SHIP_DEL_NOTE') THEN
         newrec_.use_pre_ship_del_note := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.use_pre_ship_del_note IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.use_pre_ship_del_note := TRUE;
      WHEN ('USE_PRE_SHIP_DEL_NOTE_DB') THEN
         newrec_.use_pre_ship_del_note := value_;
         indrec_.use_pre_ship_del_note := TRUE;
      WHEN ('PICK_INVENTORY_TYPE') THEN
         newrec_.pick_inventory_type := Pick_Inventory_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.pick_inventory_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.pick_inventory_type := TRUE;
      WHEN ('PICK_INVENTORY_TYPE_DB') THEN
         newrec_.pick_inventory_type := value_;
         indrec_.pick_inventory_type := TRUE;
      WHEN ('TAX_ID_NO') THEN
         newrec_.tax_id_no := value_;
         indrec_.tax_id_no := TRUE;
      WHEN ('TAX_ID_VALIDATED_DATE') THEN
         newrec_.tax_id_validated_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.tax_id_validated_date := TRUE;
      WHEN ('CLASSIFICATION_STANDARD') THEN
         newrec_.classification_standard := value_;
         indrec_.classification_standard := TRUE;
      WHEN ('MSG_SEQUENCE_NO') THEN
         newrec_.msg_sequence_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.msg_sequence_no := TRUE;
      WHEN ('MSG_VERSION_NO') THEN
         newrec_.msg_version_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.msg_version_no := TRUE;
      WHEN ('CURRENCY_RATE_TYPE') THEN
         newrec_.currency_rate_type := value_;
         indrec_.currency_rate_type := TRUE;
      WHEN ('DEL_TERMS_LOCATION') THEN
         newrec_.del_terms_location := value_;
         indrec_.del_terms_location := TRUE;
      WHEN ('INTERNAL_REF') THEN
         newrec_.internal_ref := value_;
         indrec_.internal_ref := TRUE;
      WHEN ('INTERNAL_PO_LABEL_NOTE') THEN
         newrec_.internal_po_label_note := value_;
         indrec_.internal_po_label_note := TRUE;
      WHEN ('SUPPLY_COUNTRY') THEN
         newrec_.supply_country := Iso_Country_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.supply_country IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.supply_country := TRUE;
      WHEN ('SUPPLY_COUNTRY_DB') THEN
         newrec_.supply_country := value_;
         indrec_.supply_country := TRUE;
      WHEN ('REBATE_CUSTOMER') THEN
         newrec_.rebate_customer := value_;
         indrec_.rebate_customer := TRUE;
      WHEN ('FREIGHT_MAP_ID') THEN
         newrec_.freight_map_id := value_;
         indrec_.freight_map_id := TRUE;
      WHEN ('ZONE_ID') THEN
         newrec_.zone_id := value_;
         indrec_.zone_id := TRUE;
      WHEN ('FREIGHT_PRICE_LIST_NO') THEN
         newrec_.freight_price_list_no := value_;
         indrec_.freight_price_list_no := TRUE;
      WHEN ('SUMMARIZED_FREIGHT_CHARGES') THEN
         newrec_.summarized_freight_charges := Gen_Yes_No_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.summarized_freight_charges IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.summarized_freight_charges := TRUE;
      WHEN ('SUMMARIZED_FREIGHT_CHARGES_DB') THEN
         newrec_.summarized_freight_charges := value_;
         indrec_.summarized_freight_charges := TRUE;
      WHEN ('APPLY_FIX_DELIV_FREIGHT') THEN
         newrec_.apply_fix_deliv_freight := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.apply_fix_deliv_freight IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.apply_fix_deliv_freight := TRUE;
      WHEN ('APPLY_FIX_DELIV_FREIGHT_DB') THEN
         newrec_.apply_fix_deliv_freight := value_;
         indrec_.apply_fix_deliv_freight := TRUE;
      WHEN ('FIX_DELIV_FREIGHT') THEN
         newrec_.fix_deliv_freight := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.fix_deliv_freight := TRUE;
      WHEN ('PRINT_DELIVERED_LINES') THEN
         newrec_.print_delivered_lines := Delivery_Note_Options_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.print_delivered_lines IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.print_delivered_lines := TRUE;
      WHEN ('PRINT_DELIVERED_LINES_DB') THEN
         newrec_.print_delivered_lines := value_;
         indrec_.print_delivered_lines := TRUE;
      WHEN ('CUST_CALENDAR_ID') THEN
         newrec_.cust_calendar_id := value_;
         indrec_.cust_calendar_id := TRUE;
      WHEN ('EXT_TRANSPORT_CALENDAR_ID') THEN
         newrec_.ext_transport_calendar_id := value_;
         indrec_.ext_transport_calendar_id := TRUE;
      WHEN ('USE_PRICE_INCL_TAX') THEN
         newrec_.use_price_incl_tax := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.use_price_incl_tax IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.use_price_incl_tax := TRUE;
      WHEN ('USE_PRICE_INCL_TAX_DB') THEN
         newrec_.use_price_incl_tax := value_;
         indrec_.use_price_incl_tax := TRUE;
      WHEN ('CUSTOMS_VALUE_CURRENCY') THEN
         newrec_.customs_value_currency := value_;
         indrec_.customs_value_currency := TRUE;
      WHEN ('BUSINESS_OPPORTUNITY_NO') THEN
         newrec_.business_opportunity_no := value_;
         indrec_.business_opportunity_no := TRUE;
      WHEN ('PICKING_LEADTIME') THEN
         newrec_.picking_leadtime := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.picking_leadtime := TRUE;
      WHEN ('SHIPMENT_TYPE') THEN
         newrec_.shipment_type := value_;
         indrec_.shipment_type := TRUE;
      WHEN ('VENDOR_NO') THEN
         newrec_.vendor_no := value_;
         indrec_.vendor_no := TRUE;
      WHEN ('QUOTATION_NO') THEN
         newrec_.quotation_no := value_;
         indrec_.quotation_no := TRUE;
      WHEN ('FREE_OF_CHG_TAX_PAY_PARTY') THEN
         newrec_.free_of_chg_tax_pay_party := Tax_Paying_Party_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.free_of_chg_tax_pay_party IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.free_of_chg_tax_pay_party := TRUE;
      WHEN ('FREE_OF_CHG_TAX_PAY_PARTY_DB') THEN
         newrec_.free_of_chg_tax_pay_party := value_;
         indrec_.free_of_chg_tax_pay_party := TRUE;
      WHEN ('BLOCKED_TYPE') THEN
         newrec_.blocked_type := Customer_Order_Block_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.blocked_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.blocked_type := TRUE;
      WHEN ('BLOCKED_TYPE_DB') THEN
         newrec_.blocked_type := value_;
         indrec_.blocked_type := TRUE;
      WHEN ('B2B_ORDER') THEN
         newrec_.b2b_order := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.b2b_order IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.b2b_order := TRUE;
      WHEN ('B2B_ORDER_DB') THEN
         newrec_.b2b_order := value_;
         indrec_.b2b_order := TRUE;
      WHEN ('MAIN_REPRESENTATIVE_ID') THEN
         newrec_.main_representative_id := value_;
         indrec_.main_representative_id := TRUE;
      WHEN ('LIMIT_SALES_TO_ASSORTMENTS') THEN
         newrec_.limit_sales_to_assortments := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.limit_sales_to_assortments IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.limit_sales_to_assortments := TRUE;
      WHEN ('LIMIT_SALES_TO_ASSORTMENTS_DB') THEN
         newrec_.limit_sales_to_assortments := value_;
         indrec_.limit_sales_to_assortments := TRUE;
      WHEN ('FINAL_CONSUMER') THEN
         newrec_.final_consumer := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.final_consumer IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.final_consumer := TRUE;
      WHEN ('FINAL_CONSUMER_DB') THEN
         newrec_.final_consumer := value_;
         indrec_.final_consumer := TRUE;
      WHEN ('CUSTOMER_TAX_USAGE_TYPE') THEN
         newrec_.customer_tax_usage_type := value_;
         indrec_.customer_tax_usage_type := TRUE;
      WHEN ('INVOICE_REASON_ID') THEN
         newrec_.invoice_reason_id := value_;
         indrec_.invoice_reason_id := TRUE;
      WHEN ('DELIVERY_REASON_ID') THEN
         newrec_.delivery_reason_id := value_;
         indrec_.delivery_reason_id := TRUE;
      WHEN ('COMPONENT_A') THEN
         newrec_.component_a := value_;
         indrec_.component_a := TRUE;
      WHEN ('SERVICE_CODE') THEN
         newrec_.service_code := value_;
         indrec_.service_code := TRUE;
      WHEN ('DISC_PRICE_ROUND') THEN
         newrec_.disc_price_round := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.disc_price_round IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.disc_price_round := TRUE;
      WHEN ('DISC_PRICE_ROUND_DB') THEN
         newrec_.disc_price_round := value_;
         indrec_.disc_price_round := TRUE;
      WHEN ('BUSINESS_TRANSACTION_ID') THEN
         newrec_.business_transaction_id := value_;
         indrec_.business_transaction_id := TRUE;
      WHEN ('INVOICED_CLOSED_DATE') THEN
         newrec_.invoiced_closed_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.invoiced_closed_date := TRUE;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;
EXCEPTION
   WHEN value_error THEN
      Raise_Item_Format___(name_, value_);
END Unpack___;


-- Pack___
--   Reads a record and packs its contents into an attribute string.
--   This is intended to be the reverse of Unpack___
FUNCTION Pack___ (
   rec_ IN customer_order_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.order_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_NO', rec_.order_no, attr_);
   END IF;
   IF (rec_.authorize_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', rec_.authorize_code, attr_);
   END IF;
   IF (rec_.bill_addr_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', rec_.bill_addr_no, attr_);
   END IF;
   IF (rec_.contract IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (rec_.country_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   END IF;
   IF (rec_.currency_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CURRENCY_CODE', rec_.currency_code, attr_);
   END IF;
   IF (rec_.customer_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO', rec_.customer_no, attr_);
   END IF;
   IF (rec_.customer_no_pay IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', rec_.customer_no_pay, attr_);
   END IF;
   IF (rec_.customer_no_pay_addr_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', rec_.customer_no_pay_addr_no, attr_);
   END IF;
   IF (rec_.customer_no_pay_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_REF', rec_.customer_no_pay_ref, attr_);
   END IF;
   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;
   IF (rec_.district_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DISTRICT_CODE', rec_.district_code, attr_);
   END IF;
   IF (rec_.language_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
   END IF;
   IF (rec_.market_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MARKET_CODE', rec_.market_code, attr_);
   END IF;
   IF (rec_.note_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (rec_.order_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_CODE', rec_.order_code, attr_);
   END IF;
   IF (rec_.order_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_ID', rec_.order_id, attr_);
   END IF;
   IF (rec_.pay_term_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_ID', rec_.pay_term_id, attr_);
   END IF;
   IF (rec_.pre_accounting_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', rec_.pre_accounting_id, attr_);
   END IF;
   IF (rec_.print_control_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRINT_CONTROL_CODE', rec_.print_control_code, attr_);
   END IF;
   IF (rec_.region_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REGION_CODE', rec_.region_code, attr_);
   END IF;
   IF (rec_.salesman_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   END IF;
   IF (rec_.ship_addr_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', rec_.ship_addr_no, attr_);
   END IF;
   IF (rec_.ship_via_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   END IF;
   IF (rec_.addr_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDR_FLAG', Gen_Yes_No_API.Decode(rec_.addr_flag), attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB', rec_.addr_flag, attr_);
   END IF;
   IF (rec_.grp_disc_calc_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG', Gen_Yes_No_API.Decode(rec_.grp_disc_calc_flag), attr_);
      Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG_DB', rec_.grp_disc_calc_flag, attr_);
   END IF;
   IF (rec_.customer_po_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', rec_.customer_po_no, attr_);
   END IF;
   IF (rec_.cust_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref, attr_);
   END IF;
   IF (rec_.date_entered IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   END IF;
   IF (rec_.delivery_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
   END IF;
   IF (rec_.label_note IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note, attr_);
   END IF;
   IF (rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (rec_.order_conf IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_CONF', Order_Confirmation_Printed_API.Decode(rec_.order_conf), attr_);
      Client_SYS.Add_To_Attr('ORDER_CONF_DB', rec_.order_conf, attr_);
   END IF;
   IF (rec_.order_conf_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_CONF_FLAG', Print_Order_Confirmation_API.Decode(rec_.order_conf_flag), attr_);
      Client_SYS.Add_To_Attr('ORDER_CONF_FLAG_DB', rec_.order_conf_flag, attr_);
   END IF;
   IF (rec_.pack_list_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PACK_LIST_FLAG', Print_Pack_List_API.Decode(rec_.pack_list_flag), attr_);
      Client_SYS.Add_To_Attr('PACK_LIST_FLAG_DB', rec_.pack_list_flag, attr_);
   END IF;
   IF (rec_.pick_list_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PICK_LIST_FLAG', Print_Pick_List_API.Decode(rec_.pick_list_flag), attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_FLAG_DB', rec_.pick_list_flag, attr_);
   END IF;
   IF (rec_.tax_liability IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_LIABILITY', rec_.tax_liability, attr_);
   END IF;
   IF (rec_.wanted_delivery_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.wanted_delivery_date, attr_);
   END IF;
   IF (rec_.internal_po_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_PO_NO', rec_.internal_po_no, attr_);
   END IF;
   IF (rec_.route_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
   END IF;
   IF (rec_.agreement_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AGREEMENT_ID', rec_.agreement_id, attr_);
   END IF;
   IF (rec_.forward_agent_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id, attr_);
   END IF;
   IF (rec_.internal_delivery_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE', Order_Delivery_Type_API.Decode(rec_.internal_delivery_type), attr_);
      Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE_DB', rec_.internal_delivery_type, attr_);
   END IF;
   IF (rec_.external_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXTERNAL_REF', rec_.external_ref, attr_);
   END IF;
   IF (rec_.project_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PROJECT_ID', rec_.project_id, attr_);
   END IF;
   IF (rec_.staged_billing IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STAGED_BILLING', Staged_Billing_Type_API.Decode(rec_.staged_billing), attr_);
      Client_SYS.Add_To_Attr('STAGED_BILLING_DB', rec_.staged_billing, attr_);
   END IF;
   IF (rec_.sm_connection IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SM_CONNECTION', Service_Management_Connect_API.Decode(rec_.sm_connection), attr_);
      Client_SYS.Add_To_Attr('SM_CONNECTION_DB', rec_.sm_connection, attr_);
   END IF;
   IF (rec_.scheduling_connection IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION', Schedule_Agreement_Order_API.Decode(rec_.scheduling_connection), attr_);
      Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION_DB', rec_.scheduling_connection, attr_);
   END IF;
   IF (rec_.priority IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRIORITY', rec_.priority, attr_);
   END IF;
   IF (rec_.intrastat_exempt IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT', Intrastat_Exempt_API.Decode(rec_.intrastat_exempt), attr_);
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', rec_.intrastat_exempt, attr_);
   END IF;
   IF (rec_.additional_discount IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', rec_.additional_discount, attr_);
   END IF;
   IF (rec_.pay_term_base_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_BASE_DATE', rec_.pay_term_base_date, attr_);
   END IF;
   IF (rec_.summarized_source_lines IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES', Gen_Yes_No_API.Decode(rec_.summarized_source_lines), attr_);
      Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES_DB', rec_.summarized_source_lines, attr_);
   END IF;
   IF (rec_.case_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CASE_ID', rec_.case_id, attr_);
   END IF;
   IF (rec_.task_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TASK_ID', rec_.task_id, attr_);
   END IF;
   IF (rec_.confirm_deliveries IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES', Fnd_Boolean_API.Decode(rec_.confirm_deliveries), attr_);
      Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES_DB', rec_.confirm_deliveries, attr_);
   END IF;
   IF (rec_.check_sales_grp_deliv_conf IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF', Fnd_Boolean_API.Decode(rec_.check_sales_grp_deliv_conf), attr_);
      Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF_DB', rec_.check_sales_grp_deliv_conf, attr_);
   END IF;
   IF (rec_.delay_cogs_to_deliv_conf IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF', Fnd_Boolean_API.Decode(rec_.delay_cogs_to_deliv_conf), attr_);
      Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF_DB', rec_.delay_cogs_to_deliv_conf, attr_);
   END IF;
   IF (rec_.cancel_reason IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CANCEL_REASON', rec_.cancel_reason, attr_);
   END IF;
   IF (rec_.jinsui_invoice IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('JINSUI_INVOICE', Fnd_Boolean_API.Decode(rec_.jinsui_invoice), attr_);
      Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', rec_.jinsui_invoice, attr_);
   END IF;
   IF (rec_.blocked_reason IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BLOCKED_REASON', rec_.blocked_reason, attr_);
   END IF;
   IF (rec_.blocked_from_state IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BLOCKED_FROM_STATE', rec_.blocked_from_state, attr_);
   END IF;
   IF (rec_.sales_contract_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALES_CONTRACT_NO', rec_.sales_contract_no, attr_);
   END IF;
   IF (rec_.contract_rev_seq IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT_REV_SEQ', rec_.contract_rev_seq, attr_);
   END IF;
   IF (rec_.contract_line_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT_LINE_NO', rec_.contract_line_no, attr_);
   END IF;
   IF (rec_.contract_item_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT_ITEM_NO', rec_.contract_item_no, attr_);
   END IF;
   IF (rec_.released_from_credit_check IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK', Fnd_Boolean_API.Decode(rec_.released_from_credit_check), attr_);
      Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK_DB', rec_.released_from_credit_check, attr_);
   END IF;
   IF (rec_.proposed_prepayment_amount IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PROPOSED_PREPAYMENT_AMOUNT', rec_.proposed_prepayment_amount, attr_);
   END IF;
   IF (rec_.prepayment_approved IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED', Fnd_Boolean_API.Decode(rec_.prepayment_approved), attr_);
      Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED_DB', rec_.prepayment_approved, attr_);
   END IF;
   IF (rec_.backorder_option IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BACKORDER_OPTION', Customer_Backorder_Option_API.Decode(rec_.backorder_option), attr_);
      Client_SYS.Add_To_Attr('BACKORDER_OPTION_DB', rec_.backorder_option, attr_);
   END IF;
   IF (rec_.expected_prepayment_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXPECTED_PREPAYMENT_DATE', rec_.expected_prepayment_date, attr_);
   END IF;
   IF (rec_.shipment_creation IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_CREATION', Shipment_Creation_API.Decode(rec_.shipment_creation), attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_CREATION_DB', rec_.shipment_creation, attr_);
   END IF;
   IF (rec_.use_pre_ship_del_note IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE', Fnd_Boolean_API.Decode(rec_.use_pre_ship_del_note), attr_);
      Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE_DB', rec_.use_pre_ship_del_note, attr_);
   END IF;
   IF (rec_.pick_inventory_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE', Pick_Inventory_Type_API.Decode(rec_.pick_inventory_type), attr_);
      Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE_DB', rec_.pick_inventory_type, attr_);
   END IF;
   IF (rec_.tax_id_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_ID_NO', rec_.tax_id_no, attr_);
   END IF;
   IF (rec_.tax_id_validated_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', rec_.tax_id_validated_date, attr_);
   END IF;
   IF (rec_.classification_standard IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', rec_.classification_standard, attr_);
   END IF;
   IF (rec_.msg_sequence_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MSG_SEQUENCE_NO', rec_.msg_sequence_no, attr_);
   END IF;
   IF (rec_.msg_version_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MSG_VERSION_NO', rec_.msg_version_no, attr_);
   END IF;
   IF (rec_.currency_rate_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', rec_.currency_rate_type, attr_);
   END IF;
   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;
   IF (rec_.internal_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_REF', rec_.internal_ref, attr_);
   END IF;
   IF (rec_.internal_po_label_note IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_PO_LABEL_NOTE', rec_.internal_po_label_note, attr_);
   END IF;
   IF (rec_.supply_country IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Iso_Country_API.Decode(rec_.supply_country), attr_);
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY_DB', rec_.supply_country, attr_);
   END IF;
   IF (rec_.rebate_customer IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REBATE_CUSTOMER', rec_.rebate_customer, attr_);
   END IF;
   IF (rec_.freight_map_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', rec_.freight_map_id, attr_);
   END IF;
   IF (rec_.zone_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ZONE_ID', rec_.zone_id, attr_);
   END IF;
   IF (rec_.freight_price_list_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FREIGHT_PRICE_LIST_NO', rec_.freight_price_list_no, attr_);
   END IF;
   IF (rec_.summarized_freight_charges IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES', Gen_Yes_No_API.Decode(rec_.summarized_freight_charges), attr_);
      Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES_DB', rec_.summarized_freight_charges, attr_);
   END IF;
   IF (rec_.apply_fix_deliv_freight IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT', Fnd_Boolean_API.Decode(rec_.apply_fix_deliv_freight), attr_);
      Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT_DB', rec_.apply_fix_deliv_freight, attr_);
   END IF;
   IF (rec_.fix_deliv_freight IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FIX_DELIV_FREIGHT', rec_.fix_deliv_freight, attr_);
   END IF;
   IF (rec_.print_delivered_lines IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES', Delivery_Note_Options_API.Decode(rec_.print_delivered_lines), attr_);
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES_DB', rec_.print_delivered_lines, attr_);
   END IF;
   IF (rec_.cust_calendar_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_CALENDAR_ID', rec_.cust_calendar_id, attr_);
   END IF;
   IF (rec_.ext_transport_calendar_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', rec_.ext_transport_calendar_id, attr_);
   END IF;
   IF (rec_.use_price_incl_tax IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX', Fnd_Boolean_API.Decode(rec_.use_price_incl_tax), attr_);
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', rec_.use_price_incl_tax, attr_);
   END IF;
   IF (rec_.customs_value_currency IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_VALUE_CURRENCY', rec_.customs_value_currency, attr_);
   END IF;
   IF (rec_.business_opportunity_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BUSINESS_OPPORTUNITY_NO', rec_.business_opportunity_no, attr_);
   END IF;
   IF (rec_.picking_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
   END IF;
   IF (rec_.shipment_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, attr_);
   END IF;
   IF (rec_.vendor_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VENDOR_NO', rec_.vendor_no, attr_);
   END IF;
   IF (rec_.quotation_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QUOTATION_NO', rec_.quotation_no, attr_);
   END IF;
   IF (rec_.free_of_chg_tax_pay_party IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FREE_OF_CHG_TAX_PAY_PARTY', Tax_Paying_Party_API.Decode(rec_.free_of_chg_tax_pay_party), attr_);
      Client_SYS.Add_To_Attr('FREE_OF_CHG_TAX_PAY_PARTY_DB', rec_.free_of_chg_tax_pay_party, attr_);
   END IF;
   IF (rec_.blocked_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BLOCKED_TYPE', Customer_Order_Block_Type_API.Decode(rec_.blocked_type), attr_);
      Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', rec_.blocked_type, attr_);
   END IF;
   IF (rec_.b2b_order IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('B2B_ORDER', Fnd_Boolean_API.Decode(rec_.b2b_order), attr_);
      Client_SYS.Add_To_Attr('B2B_ORDER_DB', rec_.b2b_order, attr_);
   END IF;
   IF (rec_.main_representative_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rec_.main_representative_id, attr_);
   END IF;
   IF (rec_.limit_sales_to_assortments IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS', Fnd_Boolean_API.Decode(rec_.limit_sales_to_assortments), attr_);
      Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS_DB', rec_.limit_sales_to_assortments, attr_);
   END IF;
   IF (rec_.final_consumer IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FINAL_CONSUMER', Fnd_Boolean_API.Decode(rec_.final_consumer), attr_);
      Client_SYS.Add_To_Attr('FINAL_CONSUMER_DB', rec_.final_consumer, attr_);
   END IF;
   IF (rec_.customer_tax_usage_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rec_.customer_tax_usage_type, attr_);
   END IF;
   IF (rec_.invoice_reason_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INVOICE_REASON_ID', rec_.invoice_reason_id, attr_);
   END IF;
   IF (rec_.delivery_reason_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_REASON_ID', rec_.delivery_reason_id, attr_);
   END IF;
   IF (rec_.component_a IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COMPONENT_A', rec_.component_a, attr_);
   END IF;
   IF (rec_.service_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SERVICE_CODE', rec_.service_code, attr_);
   END IF;
   IF (rec_.disc_price_round IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DISC_PRICE_ROUND', Fnd_Boolean_API.Decode(rec_.disc_price_round), attr_);
      Client_SYS.Add_To_Attr('DISC_PRICE_ROUND_DB', rec_.disc_price_round, attr_);
   END IF;
   IF (rec_.business_transaction_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BUSINESS_TRANSACTION_ID', rec_.business_transaction_id, attr_);
   END IF;
   IF (rec_.invoiced_closed_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INVOICED_CLOSED_DATE', rec_.invoiced_closed_date, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN customer_order_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.order_no) THEN
      Client_SYS.Add_To_Attr('ORDER_NO', rec_.order_no, attr_);
   END IF;
   IF (indrec_.authorize_code) THEN
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', rec_.authorize_code, attr_);
   END IF;
   IF (indrec_.bill_addr_no) THEN
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', rec_.bill_addr_no, attr_);
   END IF;
   IF (indrec_.contract) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (indrec_.country_code) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   END IF;
   IF (indrec_.currency_code) THEN
      Client_SYS.Add_To_Attr('CURRENCY_CODE', rec_.currency_code, attr_);
   END IF;
   IF (indrec_.customer_no) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO', rec_.customer_no, attr_);
   END IF;
   IF (indrec_.customer_no_pay) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', rec_.customer_no_pay, attr_);
   END IF;
   IF (indrec_.customer_no_pay_addr_no) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', rec_.customer_no_pay_addr_no, attr_);
   END IF;
   IF (indrec_.customer_no_pay_ref) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_REF', rec_.customer_no_pay_ref, attr_);
   END IF;
   IF (indrec_.delivery_terms) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;
   IF (indrec_.district_code) THEN
      Client_SYS.Add_To_Attr('DISTRICT_CODE', rec_.district_code, attr_);
   END IF;
   IF (indrec_.language_code) THEN
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
   END IF;
   IF (indrec_.market_code) THEN
      Client_SYS.Add_To_Attr('MARKET_CODE', rec_.market_code, attr_);
   END IF;
   IF (indrec_.note_id) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (indrec_.order_code) THEN
      Client_SYS.Add_To_Attr('ORDER_CODE', rec_.order_code, attr_);
   END IF;
   IF (indrec_.order_id) THEN
      Client_SYS.Add_To_Attr('ORDER_ID', rec_.order_id, attr_);
   END IF;
   IF (indrec_.pay_term_id) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_ID', rec_.pay_term_id, attr_);
   END IF;
   IF (indrec_.pre_accounting_id) THEN
      Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', rec_.pre_accounting_id, attr_);
   END IF;
   IF (indrec_.print_control_code) THEN
      Client_SYS.Add_To_Attr('PRINT_CONTROL_CODE', rec_.print_control_code, attr_);
   END IF;
   IF (indrec_.region_code) THEN
      Client_SYS.Add_To_Attr('REGION_CODE', rec_.region_code, attr_);
   END IF;
   IF (indrec_.salesman_code) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   END IF;
   IF (indrec_.ship_addr_no) THEN
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', rec_.ship_addr_no, attr_);
   END IF;
   IF (indrec_.ship_via_code) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   END IF;
   IF (indrec_.addr_flag) THEN
      Client_SYS.Add_To_Attr('ADDR_FLAG', Gen_Yes_No_API.Decode(rec_.addr_flag), attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB', rec_.addr_flag, attr_);
   END IF;
   IF (indrec_.grp_disc_calc_flag) THEN
      Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG', Gen_Yes_No_API.Decode(rec_.grp_disc_calc_flag), attr_);
      Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG_DB', rec_.grp_disc_calc_flag, attr_);
   END IF;
   IF (indrec_.customer_po_no) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', rec_.customer_po_no, attr_);
   END IF;
   IF (indrec_.cust_ref) THEN
      Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref, attr_);
   END IF;
   IF (indrec_.date_entered) THEN
      Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   END IF;
   IF (indrec_.delivery_leadtime) THEN
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
   END IF;
   IF (indrec_.label_note) THEN
      Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note, attr_);
   END IF;
   IF (indrec_.note_text) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (indrec_.order_conf) THEN
      Client_SYS.Add_To_Attr('ORDER_CONF', Order_Confirmation_Printed_API.Decode(rec_.order_conf), attr_);
      Client_SYS.Add_To_Attr('ORDER_CONF_DB', rec_.order_conf, attr_);
   END IF;
   IF (indrec_.order_conf_flag) THEN
      Client_SYS.Add_To_Attr('ORDER_CONF_FLAG', Print_Order_Confirmation_API.Decode(rec_.order_conf_flag), attr_);
      Client_SYS.Add_To_Attr('ORDER_CONF_FLAG_DB', rec_.order_conf_flag, attr_);
   END IF;
   IF (indrec_.pack_list_flag) THEN
      Client_SYS.Add_To_Attr('PACK_LIST_FLAG', Print_Pack_List_API.Decode(rec_.pack_list_flag), attr_);
      Client_SYS.Add_To_Attr('PACK_LIST_FLAG_DB', rec_.pack_list_flag, attr_);
   END IF;
   IF (indrec_.pick_list_flag) THEN
      Client_SYS.Add_To_Attr('PICK_LIST_FLAG', Print_Pick_List_API.Decode(rec_.pick_list_flag), attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_FLAG_DB', rec_.pick_list_flag, attr_);
   END IF;
   IF (indrec_.tax_liability) THEN
      Client_SYS.Add_To_Attr('TAX_LIABILITY', rec_.tax_liability, attr_);
   END IF;
   IF (indrec_.wanted_delivery_date) THEN
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.wanted_delivery_date, attr_);
   END IF;
   IF (indrec_.internal_po_no) THEN
      Client_SYS.Add_To_Attr('INTERNAL_PO_NO', rec_.internal_po_no, attr_);
   END IF;
   IF (indrec_.route_id) THEN
      Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
   END IF;
   IF (indrec_.agreement_id) THEN
      Client_SYS.Add_To_Attr('AGREEMENT_ID', rec_.agreement_id, attr_);
   END IF;
   IF (indrec_.forward_agent_id) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id, attr_);
   END IF;
   IF (indrec_.internal_delivery_type) THEN
      Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE', Order_Delivery_Type_API.Decode(rec_.internal_delivery_type), attr_);
      Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE_DB', rec_.internal_delivery_type, attr_);
   END IF;
   IF (indrec_.external_ref) THEN
      Client_SYS.Add_To_Attr('EXTERNAL_REF', rec_.external_ref, attr_);
   END IF;
   IF (indrec_.project_id) THEN
      Client_SYS.Add_To_Attr('PROJECT_ID', rec_.project_id, attr_);
   END IF;
   IF (indrec_.staged_billing) THEN
      Client_SYS.Add_To_Attr('STAGED_BILLING', Staged_Billing_Type_API.Decode(rec_.staged_billing), attr_);
      Client_SYS.Add_To_Attr('STAGED_BILLING_DB', rec_.staged_billing, attr_);
   END IF;
   IF (indrec_.sm_connection) THEN
      Client_SYS.Add_To_Attr('SM_CONNECTION', Service_Management_Connect_API.Decode(rec_.sm_connection), attr_);
      Client_SYS.Add_To_Attr('SM_CONNECTION_DB', rec_.sm_connection, attr_);
   END IF;
   IF (indrec_.scheduling_connection) THEN
      Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION', Schedule_Agreement_Order_API.Decode(rec_.scheduling_connection), attr_);
      Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION_DB', rec_.scheduling_connection, attr_);
   END IF;
   IF (indrec_.priority) THEN
      Client_SYS.Add_To_Attr('PRIORITY', rec_.priority, attr_);
   END IF;
   IF (indrec_.intrastat_exempt) THEN
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT', Intrastat_Exempt_API.Decode(rec_.intrastat_exempt), attr_);
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', rec_.intrastat_exempt, attr_);
   END IF;
   IF (indrec_.additional_discount) THEN
      Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', rec_.additional_discount, attr_);
   END IF;
   IF (indrec_.pay_term_base_date) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_BASE_DATE', rec_.pay_term_base_date, attr_);
   END IF;
   IF (indrec_.summarized_source_lines) THEN
      Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES', Gen_Yes_No_API.Decode(rec_.summarized_source_lines), attr_);
      Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES_DB', rec_.summarized_source_lines, attr_);
   END IF;
   IF (indrec_.case_id) THEN
      Client_SYS.Add_To_Attr('CASE_ID', rec_.case_id, attr_);
   END IF;
   IF (indrec_.task_id) THEN
      Client_SYS.Add_To_Attr('TASK_ID', rec_.task_id, attr_);
   END IF;
   IF (indrec_.confirm_deliveries) THEN
      Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES', Fnd_Boolean_API.Decode(rec_.confirm_deliveries), attr_);
      Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES_DB', rec_.confirm_deliveries, attr_);
   END IF;
   IF (indrec_.check_sales_grp_deliv_conf) THEN
      Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF', Fnd_Boolean_API.Decode(rec_.check_sales_grp_deliv_conf), attr_);
      Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF_DB', rec_.check_sales_grp_deliv_conf, attr_);
   END IF;
   IF (indrec_.delay_cogs_to_deliv_conf) THEN
      Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF', Fnd_Boolean_API.Decode(rec_.delay_cogs_to_deliv_conf), attr_);
      Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF_DB', rec_.delay_cogs_to_deliv_conf, attr_);
   END IF;
   IF (indrec_.cancel_reason) THEN
      Client_SYS.Add_To_Attr('CANCEL_REASON', rec_.cancel_reason, attr_);
   END IF;
   IF (indrec_.jinsui_invoice) THEN
      Client_SYS.Add_To_Attr('JINSUI_INVOICE', Fnd_Boolean_API.Decode(rec_.jinsui_invoice), attr_);
      Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', rec_.jinsui_invoice, attr_);
   END IF;
   IF (indrec_.blocked_reason) THEN
      Client_SYS.Add_To_Attr('BLOCKED_REASON', rec_.blocked_reason, attr_);
   END IF;
   IF (indrec_.blocked_from_state) THEN
      Client_SYS.Add_To_Attr('BLOCKED_FROM_STATE', rec_.blocked_from_state, attr_);
   END IF;
   IF (indrec_.sales_contract_no) THEN
      Client_SYS.Add_To_Attr('SALES_CONTRACT_NO', rec_.sales_contract_no, attr_);
   END IF;
   IF (indrec_.contract_rev_seq) THEN
      Client_SYS.Add_To_Attr('CONTRACT_REV_SEQ', rec_.contract_rev_seq, attr_);
   END IF;
   IF (indrec_.contract_line_no) THEN
      Client_SYS.Add_To_Attr('CONTRACT_LINE_NO', rec_.contract_line_no, attr_);
   END IF;
   IF (indrec_.contract_item_no) THEN
      Client_SYS.Add_To_Attr('CONTRACT_ITEM_NO', rec_.contract_item_no, attr_);
   END IF;
   IF (indrec_.released_from_credit_check) THEN
      Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK', Fnd_Boolean_API.Decode(rec_.released_from_credit_check), attr_);
      Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK_DB', rec_.released_from_credit_check, attr_);
   END IF;
   IF (indrec_.proposed_prepayment_amount) THEN
      Client_SYS.Add_To_Attr('PROPOSED_PREPAYMENT_AMOUNT', rec_.proposed_prepayment_amount, attr_);
   END IF;
   IF (indrec_.prepayment_approved) THEN
      Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED', Fnd_Boolean_API.Decode(rec_.prepayment_approved), attr_);
      Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED_DB', rec_.prepayment_approved, attr_);
   END IF;
   IF (indrec_.backorder_option) THEN
      Client_SYS.Add_To_Attr('BACKORDER_OPTION', Customer_Backorder_Option_API.Decode(rec_.backorder_option), attr_);
      Client_SYS.Add_To_Attr('BACKORDER_OPTION_DB', rec_.backorder_option, attr_);
   END IF;
   IF (indrec_.expected_prepayment_date) THEN
      Client_SYS.Add_To_Attr('EXPECTED_PREPAYMENT_DATE', rec_.expected_prepayment_date, attr_);
   END IF;
   IF (indrec_.shipment_creation) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_CREATION', Shipment_Creation_API.Decode(rec_.shipment_creation), attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_CREATION_DB', rec_.shipment_creation, attr_);
   END IF;
   IF (indrec_.use_pre_ship_del_note) THEN
      Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE', Fnd_Boolean_API.Decode(rec_.use_pre_ship_del_note), attr_);
      Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE_DB', rec_.use_pre_ship_del_note, attr_);
   END IF;
   IF (indrec_.pick_inventory_type) THEN
      Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE', Pick_Inventory_Type_API.Decode(rec_.pick_inventory_type), attr_);
      Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE_DB', rec_.pick_inventory_type, attr_);
   END IF;
   IF (indrec_.tax_id_no) THEN
      Client_SYS.Add_To_Attr('TAX_ID_NO', rec_.tax_id_no, attr_);
   END IF;
   IF (indrec_.tax_id_validated_date) THEN
      Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', rec_.tax_id_validated_date, attr_);
   END IF;
   IF (indrec_.classification_standard) THEN
      Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', rec_.classification_standard, attr_);
   END IF;
   IF (indrec_.msg_sequence_no) THEN
      Client_SYS.Add_To_Attr('MSG_SEQUENCE_NO', rec_.msg_sequence_no, attr_);
   END IF;
   IF (indrec_.msg_version_no) THEN
      Client_SYS.Add_To_Attr('MSG_VERSION_NO', rec_.msg_version_no, attr_);
   END IF;
   IF (indrec_.currency_rate_type) THEN
      Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', rec_.currency_rate_type, attr_);
   END IF;
   IF (indrec_.del_terms_location) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;
   IF (indrec_.internal_ref) THEN
      Client_SYS.Add_To_Attr('INTERNAL_REF', rec_.internal_ref, attr_);
   END IF;
   IF (indrec_.internal_po_label_note) THEN
      Client_SYS.Add_To_Attr('INTERNAL_PO_LABEL_NOTE', rec_.internal_po_label_note, attr_);
   END IF;
   IF (indrec_.supply_country) THEN
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Iso_Country_API.Decode(rec_.supply_country), attr_);
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY_DB', rec_.supply_country, attr_);
   END IF;
   IF (indrec_.rebate_customer) THEN
      Client_SYS.Add_To_Attr('REBATE_CUSTOMER', rec_.rebate_customer, attr_);
   END IF;
   IF (indrec_.freight_map_id) THEN
      Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', rec_.freight_map_id, attr_);
   END IF;
   IF (indrec_.zone_id) THEN
      Client_SYS.Add_To_Attr('ZONE_ID', rec_.zone_id, attr_);
   END IF;
   IF (indrec_.freight_price_list_no) THEN
      Client_SYS.Add_To_Attr('FREIGHT_PRICE_LIST_NO', rec_.freight_price_list_no, attr_);
   END IF;
   IF (indrec_.summarized_freight_charges) THEN
      Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES', Gen_Yes_No_API.Decode(rec_.summarized_freight_charges), attr_);
      Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES_DB', rec_.summarized_freight_charges, attr_);
   END IF;
   IF (indrec_.apply_fix_deliv_freight) THEN
      Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT', Fnd_Boolean_API.Decode(rec_.apply_fix_deliv_freight), attr_);
      Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT_DB', rec_.apply_fix_deliv_freight, attr_);
   END IF;
   IF (indrec_.fix_deliv_freight) THEN
      Client_SYS.Add_To_Attr('FIX_DELIV_FREIGHT', rec_.fix_deliv_freight, attr_);
   END IF;
   IF (indrec_.print_delivered_lines) THEN
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES', Delivery_Note_Options_API.Decode(rec_.print_delivered_lines), attr_);
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES_DB', rec_.print_delivered_lines, attr_);
   END IF;
   IF (indrec_.cust_calendar_id) THEN
      Client_SYS.Add_To_Attr('CUST_CALENDAR_ID', rec_.cust_calendar_id, attr_);
   END IF;
   IF (indrec_.ext_transport_calendar_id) THEN
      Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', rec_.ext_transport_calendar_id, attr_);
   END IF;
   IF (indrec_.use_price_incl_tax) THEN
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX', Fnd_Boolean_API.Decode(rec_.use_price_incl_tax), attr_);
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', rec_.use_price_incl_tax, attr_);
   END IF;
   IF (indrec_.customs_value_currency) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_VALUE_CURRENCY', rec_.customs_value_currency, attr_);
   END IF;
   IF (indrec_.business_opportunity_no) THEN
      Client_SYS.Add_To_Attr('BUSINESS_OPPORTUNITY_NO', rec_.business_opportunity_no, attr_);
   END IF;
   IF (indrec_.picking_leadtime) THEN
      Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
   END IF;
   IF (indrec_.shipment_type) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, attr_);
   END IF;
   IF (indrec_.vendor_no) THEN
      Client_SYS.Add_To_Attr('VENDOR_NO', rec_.vendor_no, attr_);
   END IF;
   IF (indrec_.quotation_no) THEN
      Client_SYS.Add_To_Attr('QUOTATION_NO', rec_.quotation_no, attr_);
   END IF;
   IF (indrec_.free_of_chg_tax_pay_party) THEN
      Client_SYS.Add_To_Attr('FREE_OF_CHG_TAX_PAY_PARTY', Tax_Paying_Party_API.Decode(rec_.free_of_chg_tax_pay_party), attr_);
      Client_SYS.Add_To_Attr('FREE_OF_CHG_TAX_PAY_PARTY_DB', rec_.free_of_chg_tax_pay_party, attr_);
   END IF;
   IF (indrec_.blocked_type) THEN
      Client_SYS.Add_To_Attr('BLOCKED_TYPE', Customer_Order_Block_Type_API.Decode(rec_.blocked_type), attr_);
      Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', rec_.blocked_type, attr_);
   END IF;
   IF (indrec_.b2b_order) THEN
      Client_SYS.Add_To_Attr('B2B_ORDER', Fnd_Boolean_API.Decode(rec_.b2b_order), attr_);
      Client_SYS.Add_To_Attr('B2B_ORDER_DB', rec_.b2b_order, attr_);
   END IF;
   IF (indrec_.main_representative_id) THEN
      Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rec_.main_representative_id, attr_);
   END IF;
   IF (indrec_.limit_sales_to_assortments) THEN
      Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS', Fnd_Boolean_API.Decode(rec_.limit_sales_to_assortments), attr_);
      Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS_DB', rec_.limit_sales_to_assortments, attr_);
   END IF;
   IF (indrec_.final_consumer) THEN
      Client_SYS.Add_To_Attr('FINAL_CONSUMER', Fnd_Boolean_API.Decode(rec_.final_consumer), attr_);
      Client_SYS.Add_To_Attr('FINAL_CONSUMER_DB', rec_.final_consumer, attr_);
   END IF;
   IF (indrec_.customer_tax_usage_type) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rec_.customer_tax_usage_type, attr_);
   END IF;
   IF (indrec_.invoice_reason_id) THEN
      Client_SYS.Add_To_Attr('INVOICE_REASON_ID', rec_.invoice_reason_id, attr_);
   END IF;
   IF (indrec_.delivery_reason_id) THEN
      Client_SYS.Add_To_Attr('DELIVERY_REASON_ID', rec_.delivery_reason_id, attr_);
   END IF;
   IF (indrec_.component_a) THEN
      Client_SYS.Add_To_Attr('COMPONENT_A', rec_.component_a, attr_);
   END IF;
   IF (indrec_.service_code) THEN
      Client_SYS.Add_To_Attr('SERVICE_CODE', rec_.service_code, attr_);
   END IF;
   IF (indrec_.disc_price_round) THEN
      Client_SYS.Add_To_Attr('DISC_PRICE_ROUND', Fnd_Boolean_API.Decode(rec_.disc_price_round), attr_);
      Client_SYS.Add_To_Attr('DISC_PRICE_ROUND_DB', rec_.disc_price_round, attr_);
   END IF;
   IF (indrec_.business_transaction_id) THEN
      Client_SYS.Add_To_Attr('BUSINESS_TRANSACTION_ID', rec_.business_transaction_id, attr_);
   END IF;
   IF (indrec_.invoiced_closed_date) THEN
      Client_SYS.Add_To_Attr('INVOICED_CLOSED_DATE', rec_.invoiced_closed_date, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN customer_order_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', rec_.order_no, attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', rec_.authorize_code, attr_);
   Client_SYS.Add_To_Attr('BILL_ADDR_NO', rec_.bill_addr_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', rec_.currency_code, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', rec_.customer_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', rec_.customer_no_pay, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', rec_.customer_no_pay_addr_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_REF', rec_.customer_no_pay_ref, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   Client_SYS.Add_To_Attr('DISTRICT_CODE', rec_.district_code, attr_);
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
   Client_SYS.Add_To_Attr('MARKET_CODE', rec_.market_code, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   Client_SYS.Add_To_Attr('ORDER_CODE', rec_.order_code, attr_);
   Client_SYS.Add_To_Attr('ORDER_ID', rec_.order_id, attr_);
   Client_SYS.Add_To_Attr('PAY_TERM_ID', rec_.pay_term_id, attr_);
   Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', rec_.pre_accounting_id, attr_);
   Client_SYS.Add_To_Attr('PRINT_CONTROL_CODE', rec_.print_control_code, attr_);
   Client_SYS.Add_To_Attr('REGION_CODE', rec_.region_code, attr_);
   Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', rec_.ship_addr_no, attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   Client_SYS.Add_To_Attr('ADDR_FLAG', rec_.addr_flag, attr_);
   Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG', rec_.grp_disc_calc_flag, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', rec_.customer_po_no, attr_);
   Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref, attr_);
   Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
   Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF', rec_.order_conf, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_FLAG', rec_.order_conf_flag, attr_);
   Client_SYS.Add_To_Attr('PACK_LIST_FLAG', rec_.pack_list_flag, attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_FLAG', rec_.pick_list_flag, attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', rec_.tax_liability, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.wanted_delivery_date, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_PO_NO', rec_.internal_po_no, attr_);
   Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', rec_.agreement_id, attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE', rec_.internal_delivery_type, attr_);
   Client_SYS.Add_To_Attr('EXTERNAL_REF', rec_.external_ref, attr_);
   Client_SYS.Add_To_Attr('PROJECT_ID', rec_.project_id, attr_);
   Client_SYS.Add_To_Attr('STAGED_BILLING', rec_.staged_billing, attr_);
   Client_SYS.Add_To_Attr('SM_CONNECTION', rec_.sm_connection, attr_);
   Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION', rec_.scheduling_connection, attr_);
   Client_SYS.Add_To_Attr('PRIORITY', rec_.priority, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT', rec_.intrastat_exempt, attr_);
   Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', rec_.additional_discount, attr_);
   Client_SYS.Add_To_Attr('PAY_TERM_BASE_DATE', rec_.pay_term_base_date, attr_);
   Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES', rec_.summarized_source_lines, attr_);
   Client_SYS.Add_To_Attr('CASE_ID', rec_.case_id, attr_);
   Client_SYS.Add_To_Attr('TASK_ID', rec_.task_id, attr_);
   Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES', rec_.confirm_deliveries, attr_);
   Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF', rec_.check_sales_grp_deliv_conf, attr_);
   Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF', rec_.delay_cogs_to_deliv_conf, attr_);
   Client_SYS.Add_To_Attr('CANCEL_REASON', rec_.cancel_reason, attr_);
   Client_SYS.Add_To_Attr('JINSUI_INVOICE', rec_.jinsui_invoice, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_REASON', rec_.blocked_reason, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FROM_STATE', rec_.blocked_from_state, attr_);
   Client_SYS.Add_To_Attr('SALES_CONTRACT_NO', rec_.sales_contract_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT_REV_SEQ', rec_.contract_rev_seq, attr_);
   Client_SYS.Add_To_Attr('CONTRACT_LINE_NO', rec_.contract_line_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT_ITEM_NO', rec_.contract_item_no, attr_);
   Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK', rec_.released_from_credit_check, attr_);
   Client_SYS.Add_To_Attr('PROPOSED_PREPAYMENT_AMOUNT', rec_.proposed_prepayment_amount, attr_);
   Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED', rec_.prepayment_approved, attr_);
   Client_SYS.Add_To_Attr('BACKORDER_OPTION', rec_.backorder_option, attr_);
   Client_SYS.Add_To_Attr('EXPECTED_PREPAYMENT_DATE', rec_.expected_prepayment_date, attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_CREATION', rec_.shipment_creation, attr_);
   Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE', rec_.use_pre_ship_del_note, attr_);
   Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE', rec_.pick_inventory_type, attr_);
   Client_SYS.Add_To_Attr('TAX_ID_NO', rec_.tax_id_no, attr_);
   Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', rec_.tax_id_validated_date, attr_);
   Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', rec_.classification_standard, attr_);
   Client_SYS.Add_To_Attr('MSG_SEQUENCE_NO', rec_.msg_sequence_no, attr_);
   Client_SYS.Add_To_Attr('MSG_VERSION_NO', rec_.msg_version_no, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', rec_.currency_rate_type, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_REF', rec_.internal_ref, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_PO_LABEL_NOTE', rec_.internal_po_label_note, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', rec_.supply_country, attr_);
   Client_SYS.Add_To_Attr('REBATE_CUSTOMER', rec_.rebate_customer, attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', rec_.freight_map_id, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', rec_.zone_id, attr_);
   Client_SYS.Add_To_Attr('FREIGHT_PRICE_LIST_NO', rec_.freight_price_list_no, attr_);
   Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES', rec_.summarized_freight_charges, attr_);
   Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT', rec_.apply_fix_deliv_freight, attr_);
   Client_SYS.Add_To_Attr('FIX_DELIV_FREIGHT', rec_.fix_deliv_freight, attr_);
   Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES', rec_.print_delivered_lines, attr_);
   Client_SYS.Add_To_Attr('CUST_CALENDAR_ID', rec_.cust_calendar_id, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', rec_.ext_transport_calendar_id, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX', rec_.use_price_incl_tax, attr_);
   Client_SYS.Add_To_Attr('CUSTOMS_VALUE_CURRENCY', rec_.customs_value_currency, attr_);
   Client_SYS.Add_To_Attr('BUSINESS_OPPORTUNITY_NO', rec_.business_opportunity_no, attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, attr_);
   Client_SYS.Add_To_Attr('VENDOR_NO', rec_.vendor_no, attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', rec_.quotation_no, attr_);
   Client_SYS.Add_To_Attr('FREE_OF_CHG_TAX_PAY_PARTY', rec_.free_of_chg_tax_pay_party, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_TYPE', rec_.blocked_type, attr_);
   Client_SYS.Add_To_Attr('B2B_ORDER', rec_.b2b_order, attr_);
   Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rec_.main_representative_id, attr_);
   Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS', rec_.limit_sales_to_assortments, attr_);
   Client_SYS.Add_To_Attr('FINAL_CONSUMER', rec_.final_consumer, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rec_.customer_tax_usage_type, attr_);
   Client_SYS.Add_To_Attr('INVOICE_REASON_ID', rec_.invoice_reason_id, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_REASON_ID', rec_.delivery_reason_id, attr_);
   Client_SYS.Add_To_Attr('COMPONENT_A', rec_.component_a, attr_);
   Client_SYS.Add_To_Attr('SERVICE_CODE', rec_.service_code, attr_);
   Client_SYS.Add_To_Attr('DISC_PRICE_ROUND', rec_.disc_price_round, attr_);
   Client_SYS.Add_To_Attr('BUSINESS_TRANSACTION_ID', rec_.business_transaction_id, attr_);
   Client_SYS.Add_To_Attr('INVOICED_CLOSED_DATE', rec_.invoiced_closed_date, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   Client_SYS.Add_To_Attr('ROWSTATE', rec_.rowstate, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN customer_order_tab%ROWTYPE
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.rowstate                       := public_.rowstate;
   rec_.order_no                       := public_.order_no;
   rec_.authorize_code                 := public_.authorize_code;
   rec_.bill_addr_no                   := public_.bill_addr_no;
   rec_.contract                       := public_.contract;
   rec_.country_code                   := public_.country_code;
   rec_.currency_code                  := public_.currency_code;
   rec_.customer_no                    := public_.customer_no;
   rec_.customer_no_pay                := public_.customer_no_pay;
   rec_.customer_no_pay_addr_no        := public_.customer_no_pay_addr_no;
   rec_.customer_no_pay_ref            := public_.customer_no_pay_ref;
   rec_.delivery_terms                 := public_.delivery_terms;
   rec_.district_code                  := public_.district_code;
   rec_.language_code                  := public_.language_code;
   rec_.market_code                    := public_.market_code;
   rec_.note_id                        := public_.note_id;
   rec_.order_code                     := public_.order_code;
   rec_.order_id                       := public_.order_id;
   rec_.pay_term_id                    := public_.pay_term_id;
   rec_.pre_accounting_id              := public_.pre_accounting_id;
   rec_.print_control_code             := public_.print_control_code;
   rec_.region_code                    := public_.region_code;
   rec_.salesman_code                  := public_.salesman_code;
   rec_.ship_addr_no                   := public_.ship_addr_no;
   rec_.ship_via_code                  := public_.ship_via_code;
   rec_.addr_flag                      := public_.addr_flag;
   rec_.grp_disc_calc_flag             := public_.grp_disc_calc_flag;
   rec_.customer_po_no                 := public_.customer_po_no;
   rec_.cust_ref                       := public_.cust_ref;
   rec_.date_entered                   := public_.date_entered;
   rec_.delivery_leadtime              := public_.delivery_leadtime;
   rec_.label_note                     := public_.label_note;
   rec_.note_text                      := public_.note_text;
   rec_.order_conf                     := public_.order_conf;
   rec_.tax_liability                  := public_.tax_liability;
   rec_.wanted_delivery_date           := public_.wanted_delivery_date;
   rec_.internal_po_no                 := public_.internal_po_no;
   rec_.route_id                       := public_.route_id;
   rec_.agreement_id                   := public_.agreement_id;
   rec_.forward_agent_id               := public_.forward_agent_id;
   rec_.internal_delivery_type         := public_.internal_delivery_type;
   rec_.external_ref                   := public_.external_ref;
   rec_.project_id                     := public_.project_id;
   rec_.staged_billing                 := public_.staged_billing;
   rec_.sm_connection                  := public_.sm_connection;
   rec_.scheduling_connection          := public_.scheduling_connection;
   rec_.priority                       := public_.priority;
   rec_.intrastat_exempt               := public_.intrastat_exempt;
   rec_.additional_discount            := public_.additional_discount;
   rec_.pay_term_base_date             := public_.pay_term_base_date;
   rec_.summarized_source_lines        := public_.summarized_source_lines;
   rec_.case_id                        := public_.case_id;
   rec_.task_id                        := public_.task_id;
   rec_.confirm_deliveries             := public_.confirm_deliveries;
   rec_.check_sales_grp_deliv_conf     := public_.check_sales_grp_deliv_conf;
   rec_.delay_cogs_to_deliv_conf       := public_.delay_cogs_to_deliv_conf;
   rec_.cancel_reason                  := public_.cancel_reason;
   rec_.jinsui_invoice                 := public_.jinsui_invoice;
   rec_.blocked_reason                 := public_.blocked_reason;
   rec_.blocked_from_state             := public_.blocked_from_state;
   rec_.sales_contract_no              := public_.sales_contract_no;
   rec_.contract_rev_seq               := public_.contract_rev_seq;
   rec_.contract_line_no               := public_.contract_line_no;
   rec_.contract_item_no               := public_.contract_item_no;
   rec_.released_from_credit_check     := public_.released_from_credit_check;
   rec_.proposed_prepayment_amount     := public_.proposed_prepayment_amount;
   rec_.prepayment_approved            := public_.prepayment_approved;
   rec_.backorder_option               := public_.backorder_option;
   rec_.expected_prepayment_date       := public_.expected_prepayment_date;
   rec_.shipment_creation              := public_.shipment_creation;
   rec_.use_pre_ship_del_note          := public_.use_pre_ship_del_note;
   rec_.pick_inventory_type            := public_.pick_inventory_type;
   rec_.tax_id_no                      := public_.tax_id_no;
   rec_.tax_id_validated_date          := public_.tax_id_validated_date;
   rec_.classification_standard        := public_.classification_standard;
   rec_.msg_sequence_no                := public_.msg_sequence_no;
   rec_.msg_version_no                 := public_.msg_version_no;
   rec_.currency_rate_type             := public_.currency_rate_type;
   rec_.del_terms_location             := public_.del_terms_location;
   rec_.internal_ref                   := public_.internal_ref;
   rec_.internal_po_label_note         := public_.internal_po_label_note;
   rec_.supply_country                 := public_.supply_country;
   rec_.rebate_customer                := public_.rebate_customer;
   rec_.freight_map_id                 := public_.freight_map_id;
   rec_.zone_id                        := public_.zone_id;
   rec_.freight_price_list_no          := public_.freight_price_list_no;
   rec_.summarized_freight_charges     := public_.summarized_freight_charges;
   rec_.apply_fix_deliv_freight        := public_.apply_fix_deliv_freight;
   rec_.fix_deliv_freight              := public_.fix_deliv_freight;
   rec_.print_delivered_lines          := public_.print_delivered_lines;
   rec_.cust_calendar_id               := public_.cust_calendar_id;
   rec_.ext_transport_calendar_id      := public_.ext_transport_calendar_id;
   rec_.use_price_incl_tax             := public_.use_price_incl_tax;
   rec_.customs_value_currency         := public_.customs_value_currency;
   rec_.business_opportunity_no        := public_.business_opportunity_no;
   rec_.picking_leadtime               := public_.picking_leadtime;
   rec_.shipment_type                  := public_.shipment_type;
   rec_.vendor_no                      := public_.vendor_no;
   rec_.quotation_no                   := public_.quotation_no;
   rec_.free_of_chg_tax_pay_party      := public_.free_of_chg_tax_pay_party;
   rec_.blocked_type                   := public_.blocked_type;
   rec_.b2b_order                      := public_.b2b_order;
   rec_.limit_sales_to_assortments     := public_.limit_sales_to_assortments;
   rec_.final_consumer                 := public_.final_consumer;
   rec_.customer_tax_usage_type        := public_.customer_tax_usage_type;
   rec_.invoice_reason_id              := public_.invoice_reason_id;
   rec_.delivery_reason_id             := public_.delivery_reason_id;
   rec_.component_a                    := public_.component_a;
   rec_.service_code                   := public_.service_code;
   rec_.disc_price_round               := public_.disc_price_round;
   rec_.business_transaction_id        := public_.business_transaction_id;
   rec_.invoiced_closed_date           := public_.invoiced_closed_date;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN customer_order_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.rowstate                       := rec_.rowstate;
   public_.order_no                       := rec_.order_no;
   public_.authorize_code                 := rec_.authorize_code;
   public_.bill_addr_no                   := rec_.bill_addr_no;
   public_.contract                       := rec_.contract;
   public_.country_code                   := rec_.country_code;
   public_.currency_code                  := rec_.currency_code;
   public_.customer_no                    := rec_.customer_no;
   public_.customer_no_pay                := rec_.customer_no_pay;
   public_.customer_no_pay_addr_no        := rec_.customer_no_pay_addr_no;
   public_.customer_no_pay_ref            := rec_.customer_no_pay_ref;
   public_.delivery_terms                 := rec_.delivery_terms;
   public_.district_code                  := rec_.district_code;
   public_.language_code                  := rec_.language_code;
   public_.market_code                    := rec_.market_code;
   public_.note_id                        := rec_.note_id;
   public_.order_code                     := rec_.order_code;
   public_.order_id                       := rec_.order_id;
   public_.pay_term_id                    := rec_.pay_term_id;
   public_.pre_accounting_id              := rec_.pre_accounting_id;
   public_.print_control_code             := rec_.print_control_code;
   public_.region_code                    := rec_.region_code;
   public_.salesman_code                  := rec_.salesman_code;
   public_.ship_addr_no                   := rec_.ship_addr_no;
   public_.ship_via_code                  := rec_.ship_via_code;
   public_.addr_flag                      := rec_.addr_flag;
   public_.grp_disc_calc_flag             := rec_.grp_disc_calc_flag;
   public_.customer_po_no                 := rec_.customer_po_no;
   public_.cust_ref                       := rec_.cust_ref;
   public_.date_entered                   := rec_.date_entered;
   public_.delivery_leadtime              := rec_.delivery_leadtime;
   public_.label_note                     := rec_.label_note;
   public_.note_text                      := rec_.note_text;
   public_.order_conf                     := rec_.order_conf;
   public_.tax_liability                  := rec_.tax_liability;
   public_.wanted_delivery_date           := rec_.wanted_delivery_date;
   public_.internal_po_no                 := rec_.internal_po_no;
   public_.route_id                       := rec_.route_id;
   public_.agreement_id                   := rec_.agreement_id;
   public_.forward_agent_id               := rec_.forward_agent_id;
   public_.internal_delivery_type         := rec_.internal_delivery_type;
   public_.external_ref                   := rec_.external_ref;
   public_.project_id                     := rec_.project_id;
   public_.staged_billing                 := rec_.staged_billing;
   public_.sm_connection                  := rec_.sm_connection;
   public_.scheduling_connection          := rec_.scheduling_connection;
   public_.priority                       := rec_.priority;
   public_.intrastat_exempt               := rec_.intrastat_exempt;
   public_.additional_discount            := rec_.additional_discount;
   public_.pay_term_base_date             := rec_.pay_term_base_date;
   public_.summarized_source_lines        := rec_.summarized_source_lines;
   public_.case_id                        := rec_.case_id;
   public_.task_id                        := rec_.task_id;
   public_.confirm_deliveries             := rec_.confirm_deliveries;
   public_.check_sales_grp_deliv_conf     := rec_.check_sales_grp_deliv_conf;
   public_.delay_cogs_to_deliv_conf       := rec_.delay_cogs_to_deliv_conf;
   public_.cancel_reason                  := rec_.cancel_reason;
   public_.jinsui_invoice                 := rec_.jinsui_invoice;
   public_.blocked_reason                 := rec_.blocked_reason;
   public_.blocked_from_state             := rec_.blocked_from_state;
   public_.sales_contract_no              := rec_.sales_contract_no;
   public_.contract_rev_seq               := rec_.contract_rev_seq;
   public_.contract_line_no               := rec_.contract_line_no;
   public_.contract_item_no               := rec_.contract_item_no;
   public_.released_from_credit_check     := rec_.released_from_credit_check;
   public_.proposed_prepayment_amount     := rec_.proposed_prepayment_amount;
   public_.prepayment_approved            := rec_.prepayment_approved;
   public_.backorder_option               := rec_.backorder_option;
   public_.expected_prepayment_date       := rec_.expected_prepayment_date;
   public_.shipment_creation              := rec_.shipment_creation;
   public_.use_pre_ship_del_note          := rec_.use_pre_ship_del_note;
   public_.pick_inventory_type            := rec_.pick_inventory_type;
   public_.tax_id_no                      := rec_.tax_id_no;
   public_.tax_id_validated_date          := rec_.tax_id_validated_date;
   public_.classification_standard        := rec_.classification_standard;
   public_.msg_sequence_no                := rec_.msg_sequence_no;
   public_.msg_version_no                 := rec_.msg_version_no;
   public_.currency_rate_type             := rec_.currency_rate_type;
   public_.del_terms_location             := rec_.del_terms_location;
   public_.internal_ref                   := rec_.internal_ref;
   public_.internal_po_label_note         := rec_.internal_po_label_note;
   public_.supply_country                 := rec_.supply_country;
   public_.rebate_customer                := rec_.rebate_customer;
   public_.freight_map_id                 := rec_.freight_map_id;
   public_.zone_id                        := rec_.zone_id;
   public_.freight_price_list_no          := rec_.freight_price_list_no;
   public_.summarized_freight_charges     := rec_.summarized_freight_charges;
   public_.apply_fix_deliv_freight        := rec_.apply_fix_deliv_freight;
   public_.fix_deliv_freight              := rec_.fix_deliv_freight;
   public_.print_delivered_lines          := rec_.print_delivered_lines;
   public_.cust_calendar_id               := rec_.cust_calendar_id;
   public_.ext_transport_calendar_id      := rec_.ext_transport_calendar_id;
   public_.use_price_incl_tax             := rec_.use_price_incl_tax;
   public_.customs_value_currency         := rec_.customs_value_currency;
   public_.business_opportunity_no        := rec_.business_opportunity_no;
   public_.picking_leadtime               := rec_.picking_leadtime;
   public_.shipment_type                  := rec_.shipment_type;
   public_.vendor_no                      := rec_.vendor_no;
   public_.quotation_no                   := rec_.quotation_no;
   public_.free_of_chg_tax_pay_party      := rec_.free_of_chg_tax_pay_party;
   public_.blocked_type                   := rec_.blocked_type;
   public_.b2b_order                      := rec_.b2b_order;
   public_.limit_sales_to_assortments     := rec_.limit_sales_to_assortments;
   public_.final_consumer                 := rec_.final_consumer;
   public_.customer_tax_usage_type        := rec_.customer_tax_usage_type;
   public_.invoice_reason_id              := rec_.invoice_reason_id;
   public_.delivery_reason_id             := rec_.delivery_reason_id;
   public_.component_a                    := rec_.component_a;
   public_.service_code                   := rec_.service_code;
   public_.disc_price_round               := rec_.disc_price_round;
   public_.business_transaction_id        := rec_.business_transaction_id;
   public_.invoiced_closed_date           := rec_.invoiced_closed_date;
   RETURN public_;
END Table_To_Public___;


-- Reset_Indicator_Rec___
--   Resets all elements of given Indicator_Rec to FALSE.
PROCEDURE Reset_Indicator_Rec___ (
   indrec_ IN OUT Indicator_Rec )
IS
   empty_indrec_ Indicator_Rec;
BEGIN
   indrec_ := empty_indrec_;
END Reset_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the content of a table record.
FUNCTION Get_Indicator_Rec___ (
   rec_ IN customer_order_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.order_no := rec_.order_no IS NOT NULL;
   indrec_.authorize_code := rec_.authorize_code IS NOT NULL;
   indrec_.bill_addr_no := rec_.bill_addr_no IS NOT NULL;
   indrec_.contract := rec_.contract IS NOT NULL;
   indrec_.country_code := rec_.country_code IS NOT NULL;
   indrec_.currency_code := rec_.currency_code IS NOT NULL;
   indrec_.customer_no := rec_.customer_no IS NOT NULL;
   indrec_.customer_no_pay := rec_.customer_no_pay IS NOT NULL;
   indrec_.customer_no_pay_addr_no := rec_.customer_no_pay_addr_no IS NOT NULL;
   indrec_.customer_no_pay_ref := rec_.customer_no_pay_ref IS NOT NULL;
   indrec_.delivery_terms := rec_.delivery_terms IS NOT NULL;
   indrec_.district_code := rec_.district_code IS NOT NULL;
   indrec_.language_code := rec_.language_code IS NOT NULL;
   indrec_.market_code := rec_.market_code IS NOT NULL;
   indrec_.note_id := rec_.note_id IS NOT NULL;
   indrec_.order_code := rec_.order_code IS NOT NULL;
   indrec_.order_id := rec_.order_id IS NOT NULL;
   indrec_.pay_term_id := rec_.pay_term_id IS NOT NULL;
   indrec_.pre_accounting_id := rec_.pre_accounting_id IS NOT NULL;
   indrec_.print_control_code := rec_.print_control_code IS NOT NULL;
   indrec_.region_code := rec_.region_code IS NOT NULL;
   indrec_.salesman_code := rec_.salesman_code IS NOT NULL;
   indrec_.ship_addr_no := rec_.ship_addr_no IS NOT NULL;
   indrec_.ship_via_code := rec_.ship_via_code IS NOT NULL;
   indrec_.addr_flag := rec_.addr_flag IS NOT NULL;
   indrec_.grp_disc_calc_flag := rec_.grp_disc_calc_flag IS NOT NULL;
   indrec_.customer_po_no := rec_.customer_po_no IS NOT NULL;
   indrec_.cust_ref := rec_.cust_ref IS NOT NULL;
   indrec_.date_entered := rec_.date_entered IS NOT NULL;
   indrec_.delivery_leadtime := rec_.delivery_leadtime IS NOT NULL;
   indrec_.label_note := rec_.label_note IS NOT NULL;
   indrec_.note_text := rec_.note_text IS NOT NULL;
   indrec_.order_conf := rec_.order_conf IS NOT NULL;
   indrec_.order_conf_flag := rec_.order_conf_flag IS NOT NULL;
   indrec_.pack_list_flag := rec_.pack_list_flag IS NOT NULL;
   indrec_.pick_list_flag := rec_.pick_list_flag IS NOT NULL;
   indrec_.tax_liability := rec_.tax_liability IS NOT NULL;
   indrec_.wanted_delivery_date := rec_.wanted_delivery_date IS NOT NULL;
   indrec_.internal_po_no := rec_.internal_po_no IS NOT NULL;
   indrec_.route_id := rec_.route_id IS NOT NULL;
   indrec_.agreement_id := rec_.agreement_id IS NOT NULL;
   indrec_.forward_agent_id := rec_.forward_agent_id IS NOT NULL;
   indrec_.internal_delivery_type := rec_.internal_delivery_type IS NOT NULL;
   indrec_.external_ref := rec_.external_ref IS NOT NULL;
   indrec_.project_id := rec_.project_id IS NOT NULL;
   indrec_.staged_billing := rec_.staged_billing IS NOT NULL;
   indrec_.sm_connection := rec_.sm_connection IS NOT NULL;
   indrec_.scheduling_connection := rec_.scheduling_connection IS NOT NULL;
   indrec_.priority := rec_.priority IS NOT NULL;
   indrec_.intrastat_exempt := rec_.intrastat_exempt IS NOT NULL;
   indrec_.additional_discount := rec_.additional_discount IS NOT NULL;
   indrec_.pay_term_base_date := rec_.pay_term_base_date IS NOT NULL;
   indrec_.summarized_source_lines := rec_.summarized_source_lines IS NOT NULL;
   indrec_.case_id := rec_.case_id IS NOT NULL;
   indrec_.task_id := rec_.task_id IS NOT NULL;
   indrec_.confirm_deliveries := rec_.confirm_deliveries IS NOT NULL;
   indrec_.check_sales_grp_deliv_conf := rec_.check_sales_grp_deliv_conf IS NOT NULL;
   indrec_.delay_cogs_to_deliv_conf := rec_.delay_cogs_to_deliv_conf IS NOT NULL;
   indrec_.cancel_reason := rec_.cancel_reason IS NOT NULL;
   indrec_.jinsui_invoice := rec_.jinsui_invoice IS NOT NULL;
   indrec_.blocked_reason := rec_.blocked_reason IS NOT NULL;
   indrec_.blocked_from_state := rec_.blocked_from_state IS NOT NULL;
   indrec_.sales_contract_no := rec_.sales_contract_no IS NOT NULL;
   indrec_.contract_rev_seq := rec_.contract_rev_seq IS NOT NULL;
   indrec_.contract_line_no := rec_.contract_line_no IS NOT NULL;
   indrec_.contract_item_no := rec_.contract_item_no IS NOT NULL;
   indrec_.released_from_credit_check := rec_.released_from_credit_check IS NOT NULL;
   indrec_.proposed_prepayment_amount := rec_.proposed_prepayment_amount IS NOT NULL;
   indrec_.prepayment_approved := rec_.prepayment_approved IS NOT NULL;
   indrec_.backorder_option := rec_.backorder_option IS NOT NULL;
   indrec_.expected_prepayment_date := rec_.expected_prepayment_date IS NOT NULL;
   indrec_.shipment_creation := rec_.shipment_creation IS NOT NULL;
   indrec_.use_pre_ship_del_note := rec_.use_pre_ship_del_note IS NOT NULL;
   indrec_.pick_inventory_type := rec_.pick_inventory_type IS NOT NULL;
   indrec_.tax_id_no := rec_.tax_id_no IS NOT NULL;
   indrec_.tax_id_validated_date := rec_.tax_id_validated_date IS NOT NULL;
   indrec_.classification_standard := rec_.classification_standard IS NOT NULL;
   indrec_.msg_sequence_no := rec_.msg_sequence_no IS NOT NULL;
   indrec_.msg_version_no := rec_.msg_version_no IS NOT NULL;
   indrec_.currency_rate_type := rec_.currency_rate_type IS NOT NULL;
   indrec_.del_terms_location := rec_.del_terms_location IS NOT NULL;
   indrec_.internal_ref := rec_.internal_ref IS NOT NULL;
   indrec_.internal_po_label_note := rec_.internal_po_label_note IS NOT NULL;
   indrec_.supply_country := rec_.supply_country IS NOT NULL;
   indrec_.rebate_customer := rec_.rebate_customer IS NOT NULL;
   indrec_.freight_map_id := rec_.freight_map_id IS NOT NULL;
   indrec_.zone_id := rec_.zone_id IS NOT NULL;
   indrec_.freight_price_list_no := rec_.freight_price_list_no IS NOT NULL;
   indrec_.summarized_freight_charges := rec_.summarized_freight_charges IS NOT NULL;
   indrec_.apply_fix_deliv_freight := rec_.apply_fix_deliv_freight IS NOT NULL;
   indrec_.fix_deliv_freight := rec_.fix_deliv_freight IS NOT NULL;
   indrec_.print_delivered_lines := rec_.print_delivered_lines IS NOT NULL;
   indrec_.cust_calendar_id := rec_.cust_calendar_id IS NOT NULL;
   indrec_.ext_transport_calendar_id := rec_.ext_transport_calendar_id IS NOT NULL;
   indrec_.use_price_incl_tax := rec_.use_price_incl_tax IS NOT NULL;
   indrec_.customs_value_currency := rec_.customs_value_currency IS NOT NULL;
   indrec_.business_opportunity_no := rec_.business_opportunity_no IS NOT NULL;
   indrec_.picking_leadtime := rec_.picking_leadtime IS NOT NULL;
   indrec_.shipment_type := rec_.shipment_type IS NOT NULL;
   indrec_.vendor_no := rec_.vendor_no IS NOT NULL;
   indrec_.quotation_no := rec_.quotation_no IS NOT NULL;
   indrec_.free_of_chg_tax_pay_party := rec_.free_of_chg_tax_pay_party IS NOT NULL;
   indrec_.blocked_type := rec_.blocked_type IS NOT NULL;
   indrec_.b2b_order := rec_.b2b_order IS NOT NULL;
   indrec_.main_representative_id := rec_.main_representative_id IS NOT NULL;
   indrec_.limit_sales_to_assortments := rec_.limit_sales_to_assortments IS NOT NULL;
   indrec_.final_consumer := rec_.final_consumer IS NOT NULL;
   indrec_.customer_tax_usage_type := rec_.customer_tax_usage_type IS NOT NULL;
   indrec_.invoice_reason_id := rec_.invoice_reason_id IS NOT NULL;
   indrec_.delivery_reason_id := rec_.delivery_reason_id IS NOT NULL;
   indrec_.component_a := rec_.component_a IS NOT NULL;
   indrec_.service_code := rec_.service_code IS NOT NULL;
   indrec_.disc_price_round := rec_.disc_price_round IS NOT NULL;
   indrec_.business_transaction_id := rec_.business_transaction_id IS NOT NULL;
   indrec_.invoiced_closed_date := rec_.invoiced_closed_date IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN customer_order_tab%ROWTYPE,
   newrec_ IN customer_order_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.order_no := Validate_SYS.Is_Changed(oldrec_.order_no, newrec_.order_no);
   indrec_.authorize_code := Validate_SYS.Is_Changed(oldrec_.authorize_code, newrec_.authorize_code);
   indrec_.bill_addr_no := Validate_SYS.Is_Changed(oldrec_.bill_addr_no, newrec_.bill_addr_no);
   indrec_.contract := Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract);
   indrec_.country_code := Validate_SYS.Is_Changed(oldrec_.country_code, newrec_.country_code);
   indrec_.currency_code := Validate_SYS.Is_Changed(oldrec_.currency_code, newrec_.currency_code);
   indrec_.customer_no := Validate_SYS.Is_Changed(oldrec_.customer_no, newrec_.customer_no);
   indrec_.customer_no_pay := Validate_SYS.Is_Changed(oldrec_.customer_no_pay, newrec_.customer_no_pay);
   indrec_.customer_no_pay_addr_no := Validate_SYS.Is_Changed(oldrec_.customer_no_pay_addr_no, newrec_.customer_no_pay_addr_no);
   indrec_.customer_no_pay_ref := Validate_SYS.Is_Changed(oldrec_.customer_no_pay_ref, newrec_.customer_no_pay_ref);
   indrec_.delivery_terms := Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms);
   indrec_.district_code := Validate_SYS.Is_Changed(oldrec_.district_code, newrec_.district_code);
   indrec_.language_code := Validate_SYS.Is_Changed(oldrec_.language_code, newrec_.language_code);
   indrec_.market_code := Validate_SYS.Is_Changed(oldrec_.market_code, newrec_.market_code);
   indrec_.note_id := Validate_SYS.Is_Changed(oldrec_.note_id, newrec_.note_id);
   indrec_.order_code := Validate_SYS.Is_Changed(oldrec_.order_code, newrec_.order_code);
   indrec_.order_id := Validate_SYS.Is_Changed(oldrec_.order_id, newrec_.order_id);
   indrec_.pay_term_id := Validate_SYS.Is_Changed(oldrec_.pay_term_id, newrec_.pay_term_id);
   indrec_.pre_accounting_id := Validate_SYS.Is_Changed(oldrec_.pre_accounting_id, newrec_.pre_accounting_id);
   indrec_.print_control_code := Validate_SYS.Is_Changed(oldrec_.print_control_code, newrec_.print_control_code);
   indrec_.region_code := Validate_SYS.Is_Changed(oldrec_.region_code, newrec_.region_code);
   indrec_.salesman_code := Validate_SYS.Is_Changed(oldrec_.salesman_code, newrec_.salesman_code);
   indrec_.ship_addr_no := Validate_SYS.Is_Changed(oldrec_.ship_addr_no, newrec_.ship_addr_no);
   indrec_.ship_via_code := Validate_SYS.Is_Changed(oldrec_.ship_via_code, newrec_.ship_via_code);
   indrec_.addr_flag := Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag);
   indrec_.grp_disc_calc_flag := Validate_SYS.Is_Changed(oldrec_.grp_disc_calc_flag, newrec_.grp_disc_calc_flag);
   indrec_.customer_po_no := Validate_SYS.Is_Changed(oldrec_.customer_po_no, newrec_.customer_po_no);
   indrec_.cust_ref := Validate_SYS.Is_Changed(oldrec_.cust_ref, newrec_.cust_ref);
   indrec_.date_entered := Validate_SYS.Is_Changed(oldrec_.date_entered, newrec_.date_entered);
   indrec_.delivery_leadtime := Validate_SYS.Is_Changed(oldrec_.delivery_leadtime, newrec_.delivery_leadtime);
   indrec_.label_note := Validate_SYS.Is_Changed(oldrec_.label_note, newrec_.label_note);
   indrec_.note_text := Validate_SYS.Is_Changed(oldrec_.note_text, newrec_.note_text);
   indrec_.order_conf := Validate_SYS.Is_Changed(oldrec_.order_conf, newrec_.order_conf);
   indrec_.order_conf_flag := Validate_SYS.Is_Changed(oldrec_.order_conf_flag, newrec_.order_conf_flag);
   indrec_.pack_list_flag := Validate_SYS.Is_Changed(oldrec_.pack_list_flag, newrec_.pack_list_flag);
   indrec_.pick_list_flag := Validate_SYS.Is_Changed(oldrec_.pick_list_flag, newrec_.pick_list_flag);
   indrec_.tax_liability := Validate_SYS.Is_Changed(oldrec_.tax_liability, newrec_.tax_liability);
   indrec_.wanted_delivery_date := Validate_SYS.Is_Changed(oldrec_.wanted_delivery_date, newrec_.wanted_delivery_date);
   indrec_.internal_po_no := Validate_SYS.Is_Changed(oldrec_.internal_po_no, newrec_.internal_po_no);
   indrec_.route_id := Validate_SYS.Is_Changed(oldrec_.route_id, newrec_.route_id);
   indrec_.agreement_id := Validate_SYS.Is_Changed(oldrec_.agreement_id, newrec_.agreement_id);
   indrec_.forward_agent_id := Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id);
   indrec_.internal_delivery_type := Validate_SYS.Is_Changed(oldrec_.internal_delivery_type, newrec_.internal_delivery_type);
   indrec_.external_ref := Validate_SYS.Is_Changed(oldrec_.external_ref, newrec_.external_ref);
   indrec_.project_id := Validate_SYS.Is_Changed(oldrec_.project_id, newrec_.project_id);
   indrec_.staged_billing := Validate_SYS.Is_Changed(oldrec_.staged_billing, newrec_.staged_billing);
   indrec_.sm_connection := Validate_SYS.Is_Changed(oldrec_.sm_connection, newrec_.sm_connection);
   indrec_.scheduling_connection := Validate_SYS.Is_Changed(oldrec_.scheduling_connection, newrec_.scheduling_connection);
   indrec_.priority := Validate_SYS.Is_Changed(oldrec_.priority, newrec_.priority);
   indrec_.intrastat_exempt := Validate_SYS.Is_Changed(oldrec_.intrastat_exempt, newrec_.intrastat_exempt);
   indrec_.additional_discount := Validate_SYS.Is_Changed(oldrec_.additional_discount, newrec_.additional_discount);
   indrec_.pay_term_base_date := Validate_SYS.Is_Changed(oldrec_.pay_term_base_date, newrec_.pay_term_base_date);
   indrec_.summarized_source_lines := Validate_SYS.Is_Changed(oldrec_.summarized_source_lines, newrec_.summarized_source_lines);
   indrec_.case_id := Validate_SYS.Is_Changed(oldrec_.case_id, newrec_.case_id);
   indrec_.task_id := Validate_SYS.Is_Changed(oldrec_.task_id, newrec_.task_id);
   indrec_.confirm_deliveries := Validate_SYS.Is_Changed(oldrec_.confirm_deliveries, newrec_.confirm_deliveries);
   indrec_.check_sales_grp_deliv_conf := Validate_SYS.Is_Changed(oldrec_.check_sales_grp_deliv_conf, newrec_.check_sales_grp_deliv_conf);
   indrec_.delay_cogs_to_deliv_conf := Validate_SYS.Is_Changed(oldrec_.delay_cogs_to_deliv_conf, newrec_.delay_cogs_to_deliv_conf);
   indrec_.cancel_reason := Validate_SYS.Is_Changed(oldrec_.cancel_reason, newrec_.cancel_reason);
   indrec_.jinsui_invoice := Validate_SYS.Is_Changed(oldrec_.jinsui_invoice, newrec_.jinsui_invoice);
   indrec_.blocked_reason := Validate_SYS.Is_Changed(oldrec_.blocked_reason, newrec_.blocked_reason);
   indrec_.blocked_from_state := Validate_SYS.Is_Changed(oldrec_.blocked_from_state, newrec_.blocked_from_state);
   indrec_.sales_contract_no := Validate_SYS.Is_Changed(oldrec_.sales_contract_no, newrec_.sales_contract_no);
   indrec_.contract_rev_seq := Validate_SYS.Is_Changed(oldrec_.contract_rev_seq, newrec_.contract_rev_seq);
   indrec_.contract_line_no := Validate_SYS.Is_Changed(oldrec_.contract_line_no, newrec_.contract_line_no);
   indrec_.contract_item_no := Validate_SYS.Is_Changed(oldrec_.contract_item_no, newrec_.contract_item_no);
   indrec_.released_from_credit_check := Validate_SYS.Is_Changed(oldrec_.released_from_credit_check, newrec_.released_from_credit_check);
   indrec_.proposed_prepayment_amount := Validate_SYS.Is_Changed(oldrec_.proposed_prepayment_amount, newrec_.proposed_prepayment_amount);
   indrec_.prepayment_approved := Validate_SYS.Is_Changed(oldrec_.prepayment_approved, newrec_.prepayment_approved);
   indrec_.backorder_option := Validate_SYS.Is_Changed(oldrec_.backorder_option, newrec_.backorder_option);
   indrec_.expected_prepayment_date := Validate_SYS.Is_Changed(oldrec_.expected_prepayment_date, newrec_.expected_prepayment_date);
   indrec_.shipment_creation := Validate_SYS.Is_Changed(oldrec_.shipment_creation, newrec_.shipment_creation);
   indrec_.use_pre_ship_del_note := Validate_SYS.Is_Changed(oldrec_.use_pre_ship_del_note, newrec_.use_pre_ship_del_note);
   indrec_.pick_inventory_type := Validate_SYS.Is_Changed(oldrec_.pick_inventory_type, newrec_.pick_inventory_type);
   indrec_.tax_id_no := Validate_SYS.Is_Changed(oldrec_.tax_id_no, newrec_.tax_id_no);
   indrec_.tax_id_validated_date := Validate_SYS.Is_Changed(oldrec_.tax_id_validated_date, newrec_.tax_id_validated_date);
   indrec_.classification_standard := Validate_SYS.Is_Changed(oldrec_.classification_standard, newrec_.classification_standard);
   indrec_.msg_sequence_no := Validate_SYS.Is_Changed(oldrec_.msg_sequence_no, newrec_.msg_sequence_no);
   indrec_.msg_version_no := Validate_SYS.Is_Changed(oldrec_.msg_version_no, newrec_.msg_version_no);
   indrec_.currency_rate_type := Validate_SYS.Is_Changed(oldrec_.currency_rate_type, newrec_.currency_rate_type);
   indrec_.del_terms_location := Validate_SYS.Is_Changed(oldrec_.del_terms_location, newrec_.del_terms_location);
   indrec_.internal_ref := Validate_SYS.Is_Changed(oldrec_.internal_ref, newrec_.internal_ref);
   indrec_.internal_po_label_note := Validate_SYS.Is_Changed(oldrec_.internal_po_label_note, newrec_.internal_po_label_note);
   indrec_.supply_country := Validate_SYS.Is_Changed(oldrec_.supply_country, newrec_.supply_country);
   indrec_.rebate_customer := Validate_SYS.Is_Changed(oldrec_.rebate_customer, newrec_.rebate_customer);
   indrec_.freight_map_id := Validate_SYS.Is_Changed(oldrec_.freight_map_id, newrec_.freight_map_id);
   indrec_.zone_id := Validate_SYS.Is_Changed(oldrec_.zone_id, newrec_.zone_id);
   indrec_.freight_price_list_no := Validate_SYS.Is_Changed(oldrec_.freight_price_list_no, newrec_.freight_price_list_no);
   indrec_.summarized_freight_charges := Validate_SYS.Is_Changed(oldrec_.summarized_freight_charges, newrec_.summarized_freight_charges);
   indrec_.apply_fix_deliv_freight := Validate_SYS.Is_Changed(oldrec_.apply_fix_deliv_freight, newrec_.apply_fix_deliv_freight);
   indrec_.fix_deliv_freight := Validate_SYS.Is_Changed(oldrec_.fix_deliv_freight, newrec_.fix_deliv_freight);
   indrec_.print_delivered_lines := Validate_SYS.Is_Changed(oldrec_.print_delivered_lines, newrec_.print_delivered_lines);
   indrec_.cust_calendar_id := Validate_SYS.Is_Changed(oldrec_.cust_calendar_id, newrec_.cust_calendar_id);
   indrec_.ext_transport_calendar_id := Validate_SYS.Is_Changed(oldrec_.ext_transport_calendar_id, newrec_.ext_transport_calendar_id);
   indrec_.use_price_incl_tax := Validate_SYS.Is_Changed(oldrec_.use_price_incl_tax, newrec_.use_price_incl_tax);
   indrec_.customs_value_currency := Validate_SYS.Is_Changed(oldrec_.customs_value_currency, newrec_.customs_value_currency);
   indrec_.business_opportunity_no := Validate_SYS.Is_Changed(oldrec_.business_opportunity_no, newrec_.business_opportunity_no);
   indrec_.picking_leadtime := Validate_SYS.Is_Changed(oldrec_.picking_leadtime, newrec_.picking_leadtime);
   indrec_.shipment_type := Validate_SYS.Is_Changed(oldrec_.shipment_type, newrec_.shipment_type);
   indrec_.vendor_no := Validate_SYS.Is_Changed(oldrec_.vendor_no, newrec_.vendor_no);
   indrec_.quotation_no := Validate_SYS.Is_Changed(oldrec_.quotation_no, newrec_.quotation_no);
   indrec_.free_of_chg_tax_pay_party := Validate_SYS.Is_Changed(oldrec_.free_of_chg_tax_pay_party, newrec_.free_of_chg_tax_pay_party);
   indrec_.blocked_type := Validate_SYS.Is_Changed(oldrec_.blocked_type, newrec_.blocked_type);
   indrec_.b2b_order := Validate_SYS.Is_Changed(oldrec_.b2b_order, newrec_.b2b_order);
   indrec_.main_representative_id := Validate_SYS.Is_Changed(oldrec_.main_representative_id, newrec_.main_representative_id);
   indrec_.limit_sales_to_assortments := Validate_SYS.Is_Changed(oldrec_.limit_sales_to_assortments, newrec_.limit_sales_to_assortments);
   indrec_.final_consumer := Validate_SYS.Is_Changed(oldrec_.final_consumer, newrec_.final_consumer);
   indrec_.customer_tax_usage_type := Validate_SYS.Is_Changed(oldrec_.customer_tax_usage_type, newrec_.customer_tax_usage_type);
   indrec_.invoice_reason_id := Validate_SYS.Is_Changed(oldrec_.invoice_reason_id, newrec_.invoice_reason_id);
   indrec_.delivery_reason_id := Validate_SYS.Is_Changed(oldrec_.delivery_reason_id, newrec_.delivery_reason_id);
   indrec_.component_a := Validate_SYS.Is_Changed(oldrec_.component_a, newrec_.component_a);
   indrec_.service_code := Validate_SYS.Is_Changed(oldrec_.service_code, newrec_.service_code);
   indrec_.disc_price_round := Validate_SYS.Is_Changed(oldrec_.disc_price_round, newrec_.disc_price_round);
   indrec_.business_transaction_id := Validate_SYS.Is_Changed(oldrec_.business_transaction_id, newrec_.business_transaction_id);
   indrec_.invoiced_closed_date := Validate_SYS.Is_Changed(oldrec_.invoiced_closed_date, newrec_.invoiced_closed_date);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE );


-- Check_Del_Country_Code_Ref___
--   Perform validation on the DelCountryCodeRef reference.
PROCEDURE Check_Del_Country_Code_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE );


-- Check_Component_A_Ref___
--   Perform validation on the ComponentARef reference.
PROCEDURE Check_Component_A_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE );


-- Check_Service_Code_Ref___
--   Perform validation on the ServiceCodeRef reference.
PROCEDURE Check_Service_Code_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE );


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_order_tab%ROWTYPE,
   newrec_ IN OUT customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.order_no IS NOT NULL
       AND indrec_.order_no
       AND Validate_SYS.Is_Changed(oldrec_.order_no, newrec_.order_no)) THEN
      Error_SYS.Check_Upper(lu_name_, 'ORDER_NO', newrec_.order_no);
   END IF;
   IF (newrec_.internal_po_no IS NOT NULL
       AND indrec_.internal_po_no
       AND Validate_SYS.Is_Changed(oldrec_.internal_po_no, newrec_.internal_po_no)) THEN
      Error_SYS.Check_Upper(lu_name_, 'INTERNAL_PO_NO', newrec_.internal_po_no);
   END IF;
   IF (newrec_.tax_id_no IS NOT NULL
       AND indrec_.tax_id_no
       AND Validate_SYS.Is_Changed(oldrec_.tax_id_no, newrec_.tax_id_no)) THEN
      Error_SYS.Check_Upper(lu_name_, 'TAX_ID_NO', newrec_.tax_id_no);
   END IF;
   IF (newrec_.addr_flag IS NOT NULL)
   AND (indrec_.addr_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag)) THEN
      Gen_Yes_No_API.Exist_Db(newrec_.addr_flag);
   END IF;
   IF (newrec_.grp_disc_calc_flag IS NOT NULL)
   AND (indrec_.grp_disc_calc_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.grp_disc_calc_flag, newrec_.grp_disc_calc_flag)) THEN
      Gen_Yes_No_API.Exist_Db(newrec_.grp_disc_calc_flag);
   END IF;
   IF (newrec_.order_conf IS NOT NULL)
   AND (indrec_.order_conf)
   AND (Validate_SYS.Is_Changed(oldrec_.order_conf, newrec_.order_conf)) THEN
      Order_Confirmation_Printed_API.Exist_Db(newrec_.order_conf);
   END IF;
   IF (newrec_.order_conf_flag IS NOT NULL)
   AND (indrec_.order_conf_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.order_conf_flag, newrec_.order_conf_flag)) THEN
      Print_Order_Confirmation_API.Exist_Db(newrec_.order_conf_flag);
   END IF;
   IF (newrec_.pack_list_flag IS NOT NULL)
   AND (indrec_.pack_list_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.pack_list_flag, newrec_.pack_list_flag)) THEN
      Print_Pack_List_API.Exist_Db(newrec_.pack_list_flag);
   END IF;
   IF (newrec_.pick_list_flag IS NOT NULL)
   AND (indrec_.pick_list_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.pick_list_flag, newrec_.pick_list_flag)) THEN
      Print_Pick_List_API.Exist_Db(newrec_.pick_list_flag);
   END IF;
   IF (newrec_.internal_delivery_type IS NOT NULL)
   AND (indrec_.internal_delivery_type)
   AND (Validate_SYS.Is_Changed(oldrec_.internal_delivery_type, newrec_.internal_delivery_type)) THEN
      Order_Delivery_Type_API.Exist_Db(newrec_.internal_delivery_type);
   END IF;
   IF (newrec_.staged_billing IS NOT NULL)
   AND (indrec_.staged_billing)
   AND (Validate_SYS.Is_Changed(oldrec_.staged_billing, newrec_.staged_billing)) THEN
      Staged_Billing_Type_API.Exist_Db(newrec_.staged_billing);
   END IF;
   IF (newrec_.sm_connection IS NOT NULL)
   AND (indrec_.sm_connection)
   AND (Validate_SYS.Is_Changed(oldrec_.sm_connection, newrec_.sm_connection)) THEN
      Service_Management_Connect_API.Exist_Db(newrec_.sm_connection);
   END IF;
   IF (newrec_.scheduling_connection IS NOT NULL)
   AND (indrec_.scheduling_connection)
   AND (Validate_SYS.Is_Changed(oldrec_.scheduling_connection, newrec_.scheduling_connection)) THEN
      Schedule_Agreement_Order_API.Exist_Db(newrec_.scheduling_connection);
   END IF;
   IF (newrec_.intrastat_exempt IS NOT NULL)
   AND (indrec_.intrastat_exempt)
   AND (Validate_SYS.Is_Changed(oldrec_.intrastat_exempt, newrec_.intrastat_exempt)) THEN
      Intrastat_Exempt_API.Exist_Db(newrec_.intrastat_exempt);
   END IF;
   IF (newrec_.summarized_source_lines IS NOT NULL)
   AND (indrec_.summarized_source_lines)
   AND (Validate_SYS.Is_Changed(oldrec_.summarized_source_lines, newrec_.summarized_source_lines)) THEN
      Gen_Yes_No_API.Exist_Db(newrec_.summarized_source_lines);
   END IF;
   IF (newrec_.confirm_deliveries IS NOT NULL)
   AND (indrec_.confirm_deliveries)
   AND (Validate_SYS.Is_Changed(oldrec_.confirm_deliveries, newrec_.confirm_deliveries)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.confirm_deliveries);
   END IF;
   IF (newrec_.check_sales_grp_deliv_conf IS NOT NULL)
   AND (indrec_.check_sales_grp_deliv_conf)
   AND (Validate_SYS.Is_Changed(oldrec_.check_sales_grp_deliv_conf, newrec_.check_sales_grp_deliv_conf)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.check_sales_grp_deliv_conf);
   END IF;
   IF (newrec_.delay_cogs_to_deliv_conf IS NOT NULL)
   AND (indrec_.delay_cogs_to_deliv_conf)
   AND (Validate_SYS.Is_Changed(oldrec_.delay_cogs_to_deliv_conf, newrec_.delay_cogs_to_deliv_conf)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.delay_cogs_to_deliv_conf);
   END IF;
   IF (newrec_.jinsui_invoice IS NOT NULL)
   AND (indrec_.jinsui_invoice)
   AND (Validate_SYS.Is_Changed(oldrec_.jinsui_invoice, newrec_.jinsui_invoice)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.jinsui_invoice);
   END IF;
   IF (newrec_.released_from_credit_check IS NOT NULL)
   AND (indrec_.released_from_credit_check)
   AND (Validate_SYS.Is_Changed(oldrec_.released_from_credit_check, newrec_.released_from_credit_check)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.released_from_credit_check);
   END IF;
   IF (newrec_.prepayment_approved IS NOT NULL)
   AND (indrec_.prepayment_approved)
   AND (Validate_SYS.Is_Changed(oldrec_.prepayment_approved, newrec_.prepayment_approved)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.prepayment_approved);
   END IF;
   IF (newrec_.backorder_option IS NOT NULL)
   AND (indrec_.backorder_option)
   AND (Validate_SYS.Is_Changed(oldrec_.backorder_option, newrec_.backorder_option)) THEN
      Customer_Backorder_Option_API.Exist_Db(newrec_.backorder_option);
   END IF;
   IF (newrec_.shipment_creation IS NOT NULL)
   AND (indrec_.shipment_creation)
   AND (Validate_SYS.Is_Changed(oldrec_.shipment_creation, newrec_.shipment_creation)) THEN
      Shipment_Creation_API.Exist_Customer_Order_Db(newrec_.shipment_creation);
   END IF;
   IF (newrec_.use_pre_ship_del_note IS NOT NULL)
   AND (indrec_.use_pre_ship_del_note)
   AND (Validate_SYS.Is_Changed(oldrec_.use_pre_ship_del_note, newrec_.use_pre_ship_del_note)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.use_pre_ship_del_note);
   END IF;
   IF (newrec_.pick_inventory_type IS NOT NULL)
   AND (indrec_.pick_inventory_type)
   AND (Validate_SYS.Is_Changed(oldrec_.pick_inventory_type, newrec_.pick_inventory_type)) THEN
      Pick_Inventory_Type_API.Exist_Db(newrec_.pick_inventory_type);
   END IF;
   IF (newrec_.supply_country IS NOT NULL)
   AND (indrec_.supply_country)
   AND (Validate_SYS.Is_Changed(oldrec_.supply_country, newrec_.supply_country)) THEN
      Iso_Country_API.Exist(newrec_.supply_country);
   END IF;
   IF (newrec_.summarized_freight_charges IS NOT NULL)
   AND (indrec_.summarized_freight_charges)
   AND (Validate_SYS.Is_Changed(oldrec_.summarized_freight_charges, newrec_.summarized_freight_charges)) THEN
      Gen_Yes_No_API.Exist_Db(newrec_.summarized_freight_charges);
   END IF;
   IF (newrec_.apply_fix_deliv_freight IS NOT NULL)
   AND (indrec_.apply_fix_deliv_freight)
   AND (Validate_SYS.Is_Changed(oldrec_.apply_fix_deliv_freight, newrec_.apply_fix_deliv_freight)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.apply_fix_deliv_freight);
   END IF;
   IF (newrec_.print_delivered_lines IS NOT NULL)
   AND (indrec_.print_delivered_lines)
   AND (Validate_SYS.Is_Changed(oldrec_.print_delivered_lines, newrec_.print_delivered_lines)) THEN
      Delivery_Note_Options_API.Exist_Db(newrec_.print_delivered_lines);
   END IF;
   IF (newrec_.use_price_incl_tax IS NOT NULL)
   AND (indrec_.use_price_incl_tax)
   AND (Validate_SYS.Is_Changed(oldrec_.use_price_incl_tax, newrec_.use_price_incl_tax)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.use_price_incl_tax);
   END IF;
   IF (newrec_.free_of_chg_tax_pay_party IS NOT NULL)
   AND (indrec_.free_of_chg_tax_pay_party)
   AND (Validate_SYS.Is_Changed(oldrec_.free_of_chg_tax_pay_party, newrec_.free_of_chg_tax_pay_party)) THEN
      Tax_Paying_Party_API.Exist_Db(newrec_.free_of_chg_tax_pay_party);
   END IF;
   IF (newrec_.blocked_type IS NOT NULL)
   AND (indrec_.blocked_type)
   AND (Validate_SYS.Is_Changed(oldrec_.blocked_type, newrec_.blocked_type)) THEN
      Customer_Order_Block_Type_API.Exist_Db(newrec_.blocked_type);
   END IF;
   IF (newrec_.b2b_order IS NOT NULL)
   AND (indrec_.b2b_order)
   AND (Validate_SYS.Is_Changed(oldrec_.b2b_order, newrec_.b2b_order)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.b2b_order);
   END IF;
   IF (newrec_.limit_sales_to_assortments IS NOT NULL)
   AND (indrec_.limit_sales_to_assortments)
   AND (Validate_SYS.Is_Changed(oldrec_.limit_sales_to_assortments, newrec_.limit_sales_to_assortments)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.limit_sales_to_assortments);
   END IF;
   IF (newrec_.final_consumer IS NOT NULL)
   AND (indrec_.final_consumer)
   AND (Validate_SYS.Is_Changed(oldrec_.final_consumer, newrec_.final_consumer)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.final_consumer);
   END IF;
   IF (newrec_.disc_price_round IS NOT NULL)
   AND (indrec_.disc_price_round)
   AND (Validate_SYS.Is_Changed(oldrec_.disc_price_round, newrec_.disc_price_round)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.disc_price_round);
   END IF;
   IF (newrec_.authorize_code IS NOT NULL)
   AND (indrec_.authorize_code)
   AND (Validate_SYS.Is_Changed(oldrec_.authorize_code, newrec_.authorize_code)) THEN
      Order_Coordinator_API.Exist(newrec_.authorize_code);
   END IF;
   IF (newrec_.customer_no IS NOT NULL AND newrec_.bill_addr_no IS NOT NULL)
   AND (indrec_.customer_no OR indrec_.bill_addr_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_no, newrec_.customer_no)
     OR Validate_SYS.Is_Changed(oldrec_.bill_addr_no, newrec_.bill_addr_no)) THEN
      Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.bill_addr_no);
   END IF;
   IF (newrec_.contract IS NOT NULL)
   AND (indrec_.contract)
   AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)) THEN
      Site_API.Exist(newrec_.contract);
   END IF;
   IF (newrec_.country_code IS NOT NULL)
   AND (indrec_.country_code)
   AND (Validate_SYS.Is_Changed(oldrec_.country_code, newrec_.country_code)) THEN
      Iso_Country_API.Exist(newrec_.country_code);
   END IF;
   IF (newrec_.currency_code IS NOT NULL)
   AND (indrec_.currency_code)
   AND (Validate_SYS.Is_Changed(oldrec_.currency_code, newrec_.currency_code)) THEN
      Iso_Currency_API.Exist(newrec_.currency_code);
   END IF;
   IF (newrec_.customer_no IS NOT NULL)
   AND (indrec_.customer_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_no, newrec_.customer_no)) THEN
      Cust_Ord_Customer_API.Exist(newrec_.customer_no);
   END IF;
   IF (newrec_.customer_no_pay IS NOT NULL)
   AND (indrec_.customer_no_pay)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_no_pay, newrec_.customer_no_pay)) THEN
      Cust_Ord_Customer_API.Exist(newrec_.customer_no_pay);
   END IF;
   IF (newrec_.customer_no_pay IS NOT NULL AND newrec_.customer_no_pay_addr_no IS NOT NULL)
   AND (indrec_.customer_no_pay OR indrec_.customer_no_pay_addr_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_no_pay, newrec_.customer_no_pay)
     OR Validate_SYS.Is_Changed(oldrec_.customer_no_pay_addr_no, newrec_.customer_no_pay_addr_no)) THEN
      Customer_Info_Address_API.Exist(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no);
   END IF;
   IF (newrec_.delivery_terms IS NOT NULL)
   AND (indrec_.delivery_terms)
   AND (Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms)) THEN
      Order_Delivery_Term_API.Exist(newrec_.delivery_terms);
   END IF;
   IF (newrec_.district_code IS NOT NULL)
   AND (indrec_.district_code)
   AND (Validate_SYS.Is_Changed(oldrec_.district_code, newrec_.district_code)) THEN
      Sales_District_API.Exist(newrec_.district_code);
   END IF;
   IF (newrec_.language_code IS NOT NULL)
   AND (indrec_.language_code)
   AND (Validate_SYS.Is_Changed(oldrec_.language_code, newrec_.language_code)) THEN
      Application_Language_API.Exist(newrec_.language_code);
   END IF;
   IF (newrec_.market_code IS NOT NULL)
   AND (indrec_.market_code)
   AND (Validate_SYS.Is_Changed(oldrec_.market_code, newrec_.market_code)) THEN
      Sales_Market_API.Exist(newrec_.market_code);
   END IF;
   IF (newrec_.order_code IS NOT NULL)
   AND (indrec_.order_code)
   AND (Validate_SYS.Is_Changed(oldrec_.order_code, newrec_.order_code)) THEN
      Customer_Order_Code_API.Exist(newrec_.order_code);
   END IF;
   IF (newrec_.order_id IS NOT NULL)
   AND (indrec_.order_id)
   AND (Validate_SYS.Is_Changed(oldrec_.order_id, newrec_.order_id)) THEN
      Cust_Order_Type_API.Exist(newrec_.order_id);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.pay_term_id IS NOT NULL)
   AND (indrec_.contract OR indrec_.pay_term_id)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.pay_term_id, newrec_.pay_term_id)) THEN
      Payment_Term_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.pay_term_id);
   END IF;
   IF (newrec_.print_control_code IS NOT NULL)
   AND (indrec_.print_control_code)
   AND (Validate_SYS.Is_Changed(oldrec_.print_control_code, newrec_.print_control_code)) THEN
      Cust_Ord_Print_Control_API.Exist(newrec_.print_control_code);
   END IF;
   IF (newrec_.region_code IS NOT NULL)
   AND (indrec_.region_code)
   AND (Validate_SYS.Is_Changed(oldrec_.region_code, newrec_.region_code)) THEN
      Sales_Region_API.Exist(newrec_.region_code);
   END IF;
   IF (newrec_.salesman_code IS NOT NULL)
   AND (indrec_.salesman_code)
   AND (Validate_SYS.Is_Changed(oldrec_.salesman_code, newrec_.salesman_code)) THEN
      Sales_Part_Salesman_API.Exist(newrec_.salesman_code);
   END IF;
   IF (newrec_.customer_no IS NOT NULL AND newrec_.ship_addr_no IS NOT NULL)
   AND (indrec_.customer_no OR indrec_.ship_addr_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_no, newrec_.customer_no)
     OR Validate_SYS.Is_Changed(oldrec_.ship_addr_no, newrec_.ship_addr_no)) THEN
      Cust_Ord_Customer_Address_API.Exist(newrec_.customer_no, newrec_.ship_addr_no);
   END IF;
   IF (newrec_.ship_via_code IS NOT NULL)
   AND (indrec_.ship_via_code)
   AND (Validate_SYS.Is_Changed(oldrec_.ship_via_code, newrec_.ship_via_code)) THEN
      Mpccom_Ship_Via_API.Exist(newrec_.ship_via_code);
   END IF;
   IF (newrec_.route_id IS NOT NULL)
   AND (indrec_.route_id)
   AND (Validate_SYS.Is_Changed(oldrec_.route_id, newrec_.route_id)) THEN
      Delivery_Route_API.Exist(newrec_.route_id);
   END IF;
   IF (newrec_.agreement_id IS NOT NULL)
   AND (indrec_.agreement_id)
   AND (Validate_SYS.Is_Changed(oldrec_.agreement_id, newrec_.agreement_id)) THEN
      Customer_Agreement_API.Exist(newrec_.agreement_id);
   END IF;
   IF (newrec_.forward_agent_id IS NOT NULL)
   AND (indrec_.forward_agent_id)
   AND (Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) THEN
      Forwarder_Info_API.Exist(newrec_.forward_agent_id);
   END IF;
$IF Component_PROJ_SYS.INSTALLED $THEN
   IF (newrec_.project_id IS NOT NULL)
   AND (indrec_.project_id)
   AND (Validate_SYS.Is_Changed(oldrec_.project_id, newrec_.project_id)) THEN
      Project_API.Exist(newrec_.project_id);
   END IF;
$END
$IF Component_CALLC_SYS.INSTALLED $THEN
   IF (newrec_.case_id IS NOT NULL AND newrec_.task_id IS NOT NULL)
   AND (indrec_.case_id OR indrec_.task_id)
   AND (Validate_SYS.Is_Changed(oldrec_.case_id, newrec_.case_id)
     OR Validate_SYS.Is_Changed(oldrec_.task_id, newrec_.task_id)) THEN
      Cc_Case_Task_API.Exist(newrec_.case_id, newrec_.task_id);
   END IF;
$END
   IF (newrec_.cancel_reason IS NOT NULL)
   AND (indrec_.cancel_reason)
   AND (Validate_SYS.Is_Changed(oldrec_.cancel_reason, newrec_.cancel_reason)) THEN
      Check_Cancel_Reason_Ref___(newrec_);
   END IF;
   IF (newrec_.classification_standard IS NOT NULL)
   AND (indrec_.classification_standard)
   AND (Validate_SYS.Is_Changed(oldrec_.classification_standard, newrec_.classification_standard)) THEN
      Classification_Standard_API.Exist(newrec_.classification_standard);
   END IF;
   IF (newrec_.rebate_customer IS NOT NULL)
   AND (indrec_.rebate_customer)
   AND (Validate_SYS.Is_Changed(oldrec_.rebate_customer, newrec_.rebate_customer)) THEN
      Cust_Ord_Customer_API.Exist(newrec_.rebate_customer);
   END IF;
   IF (newrec_.freight_map_id IS NOT NULL)
   AND (indrec_.freight_map_id)
   AND (Validate_SYS.Is_Changed(oldrec_.freight_map_id, newrec_.freight_map_id)) THEN
      Freight_Map_API.Exist(newrec_.freight_map_id);
   END IF;
   IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL)
   AND (indrec_.freight_map_id OR indrec_.zone_id)
   AND (Validate_SYS.Is_Changed(oldrec_.freight_map_id, newrec_.freight_map_id)
     OR Validate_SYS.Is_Changed(oldrec_.zone_id, newrec_.zone_id)) THEN
      Freight_Zone_API.Exist(newrec_.freight_map_id, newrec_.zone_id);
   END IF;
   IF (newrec_.freight_price_list_no IS NOT NULL)
   AND (indrec_.freight_price_list_no)
   AND (Validate_SYS.Is_Changed(oldrec_.freight_price_list_no, newrec_.freight_price_list_no)) THEN
      Freight_Price_List_Base_API.Exist(newrec_.freight_price_list_no);
   END IF;
   IF (newrec_.cust_calendar_id IS NOT NULL)
   AND (indrec_.cust_calendar_id)
   AND (Validate_SYS.Is_Changed(oldrec_.cust_calendar_id, newrec_.cust_calendar_id)) THEN
      Work_Time_Calendar_API.Exist(newrec_.cust_calendar_id);
   END IF;
   IF (newrec_.ext_transport_calendar_id IS NOT NULL)
   AND (indrec_.ext_transport_calendar_id)
   AND (Validate_SYS.Is_Changed(oldrec_.ext_transport_calendar_id, newrec_.ext_transport_calendar_id)) THEN
      Work_Time_Calendar_API.Exist(newrec_.ext_transport_calendar_id);
   END IF;
   IF (newrec_.customs_value_currency IS NOT NULL)
   AND (indrec_.customs_value_currency)
   AND (Validate_SYS.Is_Changed(oldrec_.customs_value_currency, newrec_.customs_value_currency)) THEN
      Iso_Currency_API.Exist(newrec_.customs_value_currency);
   END IF;
   IF (newrec_.tax_liability IS NOT NULL AND Customer_Order_Address_API.Get_Country_Code(newrec_.order_no) IS NOT NULL)
   AND (indrec_.tax_liability OR indrec_.order_no)
   AND (Validate_SYS.Is_Changed(oldrec_.tax_liability, newrec_.tax_liability)
     OR Validate_SYS.Is_Changed(Customer_Order_Address_API.Get_Country_Code(oldrec_.order_no), Customer_Order_Address_API.Get_Country_Code(newrec_.order_no))) THEN
      Check_Del_Country_Code_Ref___(newrec_);
   END IF;
   IF (newrec_.shipment_type IS NOT NULL)
   AND (indrec_.shipment_type)
   AND (Validate_SYS.Is_Changed(oldrec_.shipment_type, newrec_.shipment_type)) THEN
      Shipment_Type_API.Exist(newrec_.shipment_type);
   END IF;
$IF Component_CRM_SYS.INSTALLED $THEN
   IF (newrec_.business_opportunity_no IS NOT NULL)
   AND (indrec_.business_opportunity_no)
   AND (Validate_SYS.Is_Changed(oldrec_.business_opportunity_no, newrec_.business_opportunity_no)) THEN
      Business_Opportunity_API.Exist(newrec_.business_opportunity_no);
   END IF;
$END
$IF Component_PURCH_SYS.INSTALLED $THEN
   IF (newrec_.vendor_no IS NOT NULL)
   AND (indrec_.vendor_no)
   AND (Validate_SYS.Is_Changed(oldrec_.vendor_no, newrec_.vendor_no)) THEN
      Supplier_API.Exist(newrec_.vendor_no);
   END IF;
$END
   IF (newrec_.quotation_no IS NOT NULL)
   AND (indrec_.quotation_no)
   AND (Validate_SYS.Is_Changed(oldrec_.quotation_no, newrec_.quotation_no)) THEN
      Order_Quotation_API.Exist(newrec_.quotation_no);
   END IF;
   IF (newrec_.blocked_reason IS NOT NULL)
   AND (indrec_.blocked_reason)
   AND (Validate_SYS.Is_Changed(oldrec_.blocked_reason, newrec_.blocked_reason)) THEN
      Block_Reasons_API.Exist(newrec_.blocked_reason);
   END IF;
$IF Component_CRM_SYS.INSTALLED $THEN
   IF (newrec_.main_representative_id IS NOT NULL)
   AND (indrec_.main_representative_id)
   AND (Validate_SYS.Is_Changed(oldrec_.main_representative_id, newrec_.main_representative_id)) THEN
      Business_Representative_API.Exist(newrec_.main_representative_id);
   END IF;
$END
   IF (newrec_.customer_tax_usage_type IS NOT NULL)
   AND (indrec_.customer_tax_usage_type)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_tax_usage_type, newrec_.customer_tax_usage_type)) THEN
      Customer_Tax_Usage_Type_API.Exist(newrec_.customer_tax_usage_type);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.invoice_reason_id IS NOT NULL)
   AND (indrec_.contract OR indrec_.invoice_reason_id)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.invoice_reason_id, newrec_.invoice_reason_id)) THEN
      Invoice_Reason_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.invoice_reason_id);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.delivery_reason_id IS NOT NULL)
   AND (indrec_.contract OR indrec_.delivery_reason_id)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.delivery_reason_id, newrec_.delivery_reason_id)) THEN
      Delivery_Reason_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.delivery_reason_id);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.component_a IS NOT NULL)
   AND (indrec_.contract OR indrec_.component_a)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.component_a, newrec_.component_a)) THEN
      Check_Component_A_Ref___(newrec_);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.customer_no IS NOT NULL AND newrec_.service_code IS NOT NULL)
   AND (indrec_.contract OR indrec_.customer_no OR indrec_.service_code)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.customer_no, newrec_.customer_no)
     OR Validate_SYS.Is_Changed(oldrec_.service_code, newrec_.service_code)) THEN
      Check_Service_Code_Ref___(newrec_);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.business_transaction_id IS NOT NULL)
   AND (indrec_.contract OR indrec_.business_transaction_id)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.business_transaction_id, newrec_.business_transaction_id)) THEN
      Business_Transaction_Id_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.business_transaction_id);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'AUTHORIZE_CODE', newrec_.authorize_code);
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
   Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_CODE', newrec_.currency_code);
   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO', newrec_.customer_no);
   Error_SYS.Check_Not_Null(lu_name_, 'DELIVERY_TERMS', newrec_.delivery_terms);
   Error_SYS.Check_Not_Null(lu_name_, 'LANGUAGE_CODE', newrec_.language_code);
   Error_SYS.Check_Not_Null(lu_name_, 'ORDER_CODE', newrec_.order_code);
   Error_SYS.Check_Not_Null(lu_name_, 'ORDER_ID', newrec_.order_id);
   Error_SYS.Check_Not_Null(lu_name_, 'SHIP_ADDR_NO', newrec_.ship_addr_no);
   Error_SYS.Check_Not_Null(lu_name_, 'ADDR_FLAG', newrec_.addr_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'GRP_DISC_CALC_FLAG', newrec_.grp_disc_calc_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'DELIVERY_LEADTIME', newrec_.delivery_leadtime);
   Error_SYS.Check_Not_Null(lu_name_, 'ORDER_CONF', newrec_.order_conf);
   Error_SYS.Check_Not_Null(lu_name_, 'ORDER_CONF_FLAG', newrec_.order_conf_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'PACK_LIST_FLAG', newrec_.pack_list_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'PICK_LIST_FLAG', newrec_.pick_list_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'TAX_LIABILITY', newrec_.tax_liability);
   Error_SYS.Check_Not_Null(lu_name_, 'WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date);
   Error_SYS.Check_Not_Null(lu_name_, 'STAGED_BILLING', newrec_.staged_billing);
   Error_SYS.Check_Not_Null(lu_name_, 'SM_CONNECTION', newrec_.sm_connection);
   Error_SYS.Check_Not_Null(lu_name_, 'SCHEDULING_CONNECTION', newrec_.scheduling_connection);
   Error_SYS.Check_Not_Null(lu_name_, 'INTRASTAT_EXEMPT', newrec_.intrastat_exempt);
   Error_SYS.Check_Not_Null(lu_name_, 'SUMMARIZED_SOURCE_LINES', newrec_.summarized_source_lines);
   Error_SYS.Check_Not_Null(lu_name_, 'CONFIRM_DELIVERIES', newrec_.confirm_deliveries);
   Error_SYS.Check_Not_Null(lu_name_, 'CHECK_SALES_GRP_DELIV_CONF', newrec_.check_sales_grp_deliv_conf);
   Error_SYS.Check_Not_Null(lu_name_, 'DELAY_COGS_TO_DELIV_CONF', newrec_.delay_cogs_to_deliv_conf);
   Error_SYS.Check_Not_Null(lu_name_, 'JINSUI_INVOICE', newrec_.jinsui_invoice);
   Error_SYS.Check_Not_Null(lu_name_, 'RELEASED_FROM_CREDIT_CHECK', newrec_.released_from_credit_check);
   Error_SYS.Check_Not_Null(lu_name_, 'PROPOSED_PREPAYMENT_AMOUNT', newrec_.proposed_prepayment_amount);
   Error_SYS.Check_Not_Null(lu_name_, 'PREPAYMENT_APPROVED', newrec_.prepayment_approved);
   Error_SYS.Check_Not_Null(lu_name_, 'BACKORDER_OPTION', newrec_.backorder_option);
   Error_SYS.Check_Not_Null(lu_name_, 'SHIPMENT_CREATION', newrec_.shipment_creation);
   Error_SYS.Check_Not_Null(lu_name_, 'USE_PRE_SHIP_DEL_NOTE', newrec_.use_pre_ship_del_note);
   Error_SYS.Check_Not_Null(lu_name_, 'PICK_INVENTORY_TYPE', newrec_.pick_inventory_type);
   Error_SYS.Check_Not_Null(lu_name_, 'SUPPLY_COUNTRY', newrec_.supply_country);
   Error_SYS.Check_Not_Null(lu_name_, 'SUMMARIZED_FREIGHT_CHARGES', newrec_.summarized_freight_charges);
   Error_SYS.Check_Not_Null(lu_name_, 'APPLY_FIX_DELIV_FREIGHT', newrec_.apply_fix_deliv_freight);
   Error_SYS.Check_Not_Null(lu_name_, 'PRINT_DELIVERED_LINES', newrec_.print_delivered_lines);
   Error_SYS.Check_Not_Null(lu_name_, 'USE_PRICE_INCL_TAX', newrec_.use_price_incl_tax);
   Error_SYS.Check_Not_Null(lu_name_, 'PICKING_LEADTIME', newrec_.picking_leadtime);
   Error_SYS.Check_Not_Null(lu_name_, 'SHIPMENT_TYPE', newrec_.shipment_type);
   Error_SYS.Check_Not_Null(lu_name_, 'FREE_OF_CHG_TAX_PAY_PARTY', newrec_.free_of_chg_tax_pay_party);
   Error_SYS.Check_Not_Null(lu_name_, 'BLOCKED_TYPE', newrec_.blocked_type);
   Error_SYS.Check_Not_Null(lu_name_, 'B2B_ORDER', newrec_.b2b_order);
   Error_SYS.Check_Not_Null(lu_name_, 'LIMIT_SALES_TO_ASSORTMENTS', newrec_.limit_sales_to_assortments);
   Error_SYS.Check_Not_Null(lu_name_, 'FINAL_CONSUMER', newrec_.final_consumer);
   Error_SYS.Check_Not_Null(lu_name_, 'DISC_PRICE_ROUND', newrec_.disc_price_round);
END Check_Common___;


-- Prepare_Insert___
--   Set client default values into an attribute string.
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Clear_Attr(attr_);
END Prepare_Insert___;


-- Check_Insert___
--   Perform validations on a new record before it is insert.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ customer_order_tab%ROWTYPE;
BEGIN
   Validate_SYS.Item_Insert(lu_name_, 'DISC_PRICE_ROUND', indrec_.disc_price_round);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_order_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   newrec_.rowstate := '<UNDEFINED>';
   INSERT
      INTO customer_order_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   newrec_.rowstate := NULL;
   Finite_State_Init___(newrec_, attr_);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMER_ORDER_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMER_ORDER_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Insert___;


-- Prepare_New___
--    Set default values for a table record.
PROCEDURE Prepare_New___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE )
IS
   attr_    VARCHAR2(32000);
   indrec_  Indicator_Rec;
BEGIN
   attr_ := Pack___(newrec_);
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
END Prepare_New___;


-- New___
--    Checks and creates a new record.
PROCEDURE New___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE )
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
BEGIN
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New___;


-- Check_Update___
--   Perform validations on a new record before it is updated.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_tab%ROWTYPE,
   newrec_ IN OUT customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'ORDER_NO', indrec_.order_no);
   Validate_SYS.Item_Update(lu_name_, 'CONTRACT', indrec_.contract);
   Validate_SYS.Item_Update(lu_name_, 'CURRENCY_CODE', indrec_.currency_code);
   Validate_SYS.Item_Update(lu_name_, 'CUSTOMER_NO', indrec_.customer_no);
   Validate_SYS.Item_Update(lu_name_, 'NOTE_ID', indrec_.note_id);
   Validate_SYS.Item_Update(lu_name_, 'ORDER_CODE', indrec_.order_code);
   Validate_SYS.Item_Update(lu_name_, 'ORDER_ID', indrec_.order_id);
   Validate_SYS.Item_Update(lu_name_, 'PRE_ACCOUNTING_ID', indrec_.pre_accounting_id);
   Validate_SYS.Item_Update(lu_name_, 'DATE_ENTERED', indrec_.date_entered);
   Validate_SYS.Item_Update(lu_name_, 'INTERNAL_PO_NO', indrec_.internal_po_no);
   Validate_SYS.Item_Update(lu_name_, 'USE_PRE_SHIP_DEL_NOTE', indrec_.use_pre_ship_del_note);
   Validate_SYS.Item_Update(lu_name_, 'PICK_INVENTORY_TYPE', indrec_.pick_inventory_type);
   Validate_SYS.Item_Update(lu_name_, 'USE_PRICE_INCL_TAX', indrec_.use_price_incl_tax);
   Validate_SYS.Item_Update(lu_name_, 'BUSINESS_OPPORTUNITY_NO', indrec_.business_opportunity_no);
   Validate_SYS.Item_Update(lu_name_, 'B2B_ORDER', indrec_.b2b_order);
   Validate_SYS.Item_Update(lu_name_, 'DISC_PRICE_ROUND', indrec_.disc_price_round);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_order_tab%ROWTYPE,
   newrec_     IN OUT customer_order_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE customer_order_tab
         SET ROW = newrec_
         WHERE order_no = newrec_.order_no;
   ELSE
      UPDATE customer_order_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMER_ORDER_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Customer_Order_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMER_ORDER_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Update___;


-- Modify___
--    Modifies an existing instance of the logical unit.
PROCEDURE Modify___ (
   newrec_         IN OUT customer_order_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     customer_order_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.order_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.order_no);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Check_Delete___ (
   remrec_ IN customer_order_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.order_no||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_order_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.order_no||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  customer_order_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  customer_order_tab
         WHERE order_no = remrec_.order_no;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN customer_order_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT customer_order_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     customer_order_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.order_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.order_no);
   END IF;
   Check_Delete___(oldrec_);
   Delete___(NULL, oldrec_);
END Remove___;


-- Lock__
--    Client-support to lock a specific instance of the logical unit.
@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
   dummy_ customer_order_tab%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Id___(objid_, objversion_);
   info_ := Client_SYS.Get_All_Info;
END Lock__;


-- New__
--    Client-support interface to create LU instances.
--       action_ = 'PREPARE'
--          Default values and handle of information to client.
--          The default values are set in procedure Prepare_Insert___.
--       action_ = 'CHECK'
--          Check all attributes before creating new object and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___.
--       action_ = 'DO'
--          Creation of new instances of the logical unit and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___
--          before calling procedure Insert___.
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_   customer_order_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'PREPARE') THEN
      Prepare_Insert___(attr_);
   ELSIF (action_ = 'CHECK') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New__;


-- Modify__
--    Client-support interface to modify attributes for LU instances.
--       action_ = 'CHECK'
--          Check all attributes before modifying an existing object and
--          handle of information to client. The attribute list is unpacked,
--          checked and prepared(defaults) in procedures Unpack___ and Check_Update___.
--       action_ = 'DO'
--          Modification of an existing instance of the logical unit. The
--          procedure unpacks the attributes, checks all values before
--          procedure Update___ is called.
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_   customer_order_tab%ROWTYPE;
   newrec_   customer_order_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Remove__
--    Client-support interface to remove LU instances.
--       action_ = 'CHECK'
--          Check whether a specific LU-instance may be removed or not.
--          The procedure fetches the complete record by calling procedure
--          Get_Object_By_Id___. Then the check is made by calling procedure
--          Check_Delete___.
--       action_ = 'DO'
--          Remove an existing instance of the logical unit. The procedure
--          fetches the complete LU-record, checks for a delete and then
--          deletes the record by calling procedure Delete___.
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-- Get_Key_By_Rowkey
--   Returns a table record with only keys (other attributes are NULL) based on a rowkey.
@UncheckedAccess
FUNCTION Get_Key_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN customer_order_tab%ROWTYPE
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_no
      INTO  rec_.order_no
      FROM  customer_order_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.order_no, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(order_no_)) THEN
      Raise_Record_Not_Exist___(order_no_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(order_no_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   order_no_ customer_order_tab.order_no%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT order_no
   INTO  order_no_
   FROM  customer_order_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(order_no_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Authorize_Code
--   Fetches the AuthorizeCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Authorize_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.authorize_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT authorize_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Authorize_Code');
END Get_Authorize_Code;


-- Get_Bill_Addr_No
--   Fetches the BillAddrNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Bill_Addr_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.bill_addr_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT bill_addr_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Bill_Addr_No');
END Get_Bill_Addr_No;


-- Get_Contract
--   Fetches the Contract attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.contract%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Contract');
END Get_Contract;


-- Get_Country_Code
--   Fetches the CountryCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Country_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.country_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT country_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Country_Code');
END Get_Country_Code;


-- Get_Currency_Code
--   Fetches the CurrencyCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Currency_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.currency_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT currency_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Currency_Code');
END Get_Currency_Code;


-- Get_Customer_No
--   Fetches the CustomerNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_No');
END Get_Customer_No;


-- Get_Customer_No_Pay
--   Fetches the CustomerNoPay attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_No_Pay (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_no_pay%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_no_pay
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_No_Pay');
END Get_Customer_No_Pay;


-- Get_Customer_No_Pay_Addr_No
--   Fetches the CustomerNoPayAddrNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_No_Pay_Addr_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_no_pay_addr_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_no_pay_addr_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_No_Pay_Addr_No');
END Get_Customer_No_Pay_Addr_No;


-- Get_Customer_No_Pay_Ref
--   Fetches the CustomerNoPayReference attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_No_Pay_Ref (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_no_pay_ref%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_no_pay_ref
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_No_Pay_Ref');
END Get_Customer_No_Pay_Ref;


-- Get_Delivery_Terms
--   Fetches the DeliveryTerms attribute for a record.
@UncheckedAccess
FUNCTION Get_Delivery_Terms (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.delivery_terms%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delivery_terms
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Delivery_Terms');
END Get_Delivery_Terms;


-- Get_District_Code
--   Fetches the DistrictCode attribute for a record.
@UncheckedAccess
FUNCTION Get_District_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.district_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT district_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_District_Code');
END Get_District_Code;


-- Get_Language_Code
--   Fetches the LanguageCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Language_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.language_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT language_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Language_Code');
END Get_Language_Code;


-- Get_Market_Code
--   Fetches the MarketCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Market_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.market_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT market_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Market_Code');
END Get_Market_Code;


-- Get_Note_Id
--   Fetches the NoteId attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Id (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.note_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT note_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Note_Id');
END Get_Note_Id;


-- Get_Order_Code
--   Fetches the OrderCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Order_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.order_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Order_Code');
END Get_Order_Code;


-- Get_Order_Id
--   Fetches the OrderId attribute for a record.
@UncheckedAccess
FUNCTION Get_Order_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.order_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Order_Id');
END Get_Order_Id;


-- Get_Pay_Term_Id
--   Fetches the PayTermId attribute for a record.
@UncheckedAccess
FUNCTION Get_Pay_Term_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.pay_term_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT pay_term_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Pay_Term_Id');
END Get_Pay_Term_Id;


-- Get_Pre_Accounting_Id
--   Fetches the PreAccountingId attribute for a record.
@UncheckedAccess
FUNCTION Get_Pre_Accounting_Id (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.pre_accounting_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT pre_accounting_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Pre_Accounting_Id');
END Get_Pre_Accounting_Id;


-- Get_Print_Control_Code
--   Fetches the PrintControlCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Print_Control_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.print_control_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT print_control_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Print_Control_Code');
END Get_Print_Control_Code;


-- Get_Region_Code
--   Fetches the RegionCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Region_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.region_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT region_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Region_Code');
END Get_Region_Code;


-- Get_Salesman_Code
--   Fetches the SalesmanCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Salesman_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.salesman_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT salesman_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Salesman_Code');
END Get_Salesman_Code;


-- Get_Ship_Addr_No
--   Fetches the ShipAddrNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Ship_Addr_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.ship_addr_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ship_addr_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Ship_Addr_No');
END Get_Ship_Addr_No;


-- Get_Ship_Via_Code
--   Fetches the ShipViaCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Ship_Via_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.ship_via_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ship_via_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Ship_Via_Code');
END Get_Ship_Via_Code;


-- Get_Addr_Flag
--   Fetches the AddrFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Addr_Flag (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.addr_flag%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT addr_flag
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Gen_Yes_No_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Addr_Flag');
END Get_Addr_Flag;


-- Get_Addr_Flag_Db
--   Fetches the DB value of AddrFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Addr_Flag_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.addr_flag%TYPE
IS
   temp_ customer_order_tab.addr_flag%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT addr_flag
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Addr_Flag_Db');
END Get_Addr_Flag_Db;


-- Get_Grp_Disc_Calc_Flag
--   Fetches the GrpDiscCalcFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Grp_Disc_Calc_Flag (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.grp_disc_calc_flag%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT grp_disc_calc_flag
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Gen_Yes_No_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Grp_Disc_Calc_Flag');
END Get_Grp_Disc_Calc_Flag;


-- Get_Grp_Disc_Calc_Flag_Db
--   Fetches the DB value of GrpDiscCalcFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Grp_Disc_Calc_Flag_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.grp_disc_calc_flag%TYPE
IS
   temp_ customer_order_tab.grp_disc_calc_flag%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT grp_disc_calc_flag
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Grp_Disc_Calc_Flag_Db');
END Get_Grp_Disc_Calc_Flag_Db;


-- Get_Customer_Po_No
--   Fetches the CustomerPoNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Po_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_po_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_po_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_Po_No');
END Get_Customer_Po_No;


-- Get_Cust_Ref
--   Fetches the CustRef attribute for a record.
@UncheckedAccess
FUNCTION Get_Cust_Ref (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.cust_ref%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cust_ref
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Cust_Ref');
END Get_Cust_Ref;


-- Get_Date_Entered
--   Fetches the DateEntered attribute for a record.
@UncheckedAccess
FUNCTION Get_Date_Entered (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.date_entered%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT date_entered
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Date_Entered');
END Get_Date_Entered;


-- Get_Delivery_Leadtime
--   Fetches the DeliveryLeadtime attribute for a record.
@UncheckedAccess
FUNCTION Get_Delivery_Leadtime (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.delivery_leadtime%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delivery_leadtime
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Delivery_Leadtime');
END Get_Delivery_Leadtime;


-- Get_Label_Note
--   Fetches the LabelNote attribute for a record.
@UncheckedAccess
FUNCTION Get_Label_Note (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.label_note%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT label_note
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Label_Note');
END Get_Label_Note;


-- Get_Note_Text
--   Fetches the NoteText attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Text (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.note_text%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT note_text
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Note_Text');
END Get_Note_Text;


-- Get_Order_Conf
--   Fetches the OrderConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Order_Conf (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.order_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Order_Confirmation_Printed_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Order_Conf');
END Get_Order_Conf;


-- Get_Order_Conf_Db
--   Fetches the DB value of OrderConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Order_Conf_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.order_conf%TYPE
IS
   temp_ customer_order_tab.order_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Order_Conf_Db');
END Get_Order_Conf_Db;


-- Get_Tax_Liability
--   Fetches the TaxLiability attribute for a record.
@UncheckedAccess
FUNCTION Get_Tax_Liability (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.tax_liability%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT tax_liability
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Tax_Liability');
END Get_Tax_Liability;


-- Get_Wanted_Delivery_Date
--   Fetches the WantedDeliveryDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Wanted_Delivery_Date (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.wanted_delivery_date%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT wanted_delivery_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Wanted_Delivery_Date');
END Get_Wanted_Delivery_Date;


-- Get_Internal_Po_No
--   Fetches the InternalPoNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Internal_Po_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.internal_po_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT internal_po_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Internal_Po_No');
END Get_Internal_Po_No;


-- Get_Route_Id
--   Fetches the RouteId attribute for a record.
@UncheckedAccess
FUNCTION Get_Route_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.route_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT route_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Route_Id');
END Get_Route_Id;


-- Get_Agreement_Id
--   Fetches the AgreementId attribute for a record.
@UncheckedAccess
FUNCTION Get_Agreement_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.agreement_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT agreement_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Agreement_Id');
END Get_Agreement_Id;


-- Get_Forward_Agent_Id
--   Fetches the ForwardAgentId attribute for a record.
@UncheckedAccess
FUNCTION Get_Forward_Agent_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.forward_agent_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT forward_agent_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Forward_Agent_Id');
END Get_Forward_Agent_Id;


-- Get_Internal_Delivery_Type
--   Fetches the InternalDeliveryType attribute for a record.
@UncheckedAccess
FUNCTION Get_Internal_Delivery_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.internal_delivery_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT internal_delivery_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Order_Delivery_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Internal_Delivery_Type');
END Get_Internal_Delivery_Type;


-- Get_Internal_Delivery_Type_Db
--   Fetches the DB value of InternalDeliveryType attribute for a record.
@UncheckedAccess
FUNCTION Get_Internal_Delivery_Type_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.internal_delivery_type%TYPE
IS
   temp_ customer_order_tab.internal_delivery_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT internal_delivery_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Internal_Delivery_Type_Db');
END Get_Internal_Delivery_Type_Db;


-- Get_External_Ref
--   Fetches the ExternalRef attribute for a record.
@UncheckedAccess
FUNCTION Get_External_Ref (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.external_ref%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT external_ref
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_External_Ref');
END Get_External_Ref;


-- Get_Project_Id
--   Fetches the ProjectId attribute for a record.
@UncheckedAccess
FUNCTION Get_Project_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.project_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT project_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Project_Id');
END Get_Project_Id;


-- Get_Staged_Billing
--   Fetches the StagedBilling attribute for a record.
@UncheckedAccess
FUNCTION Get_Staged_Billing (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.staged_billing%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT staged_billing
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Staged_Billing_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Staged_Billing');
END Get_Staged_Billing;


-- Get_Staged_Billing_Db
--   Fetches the DB value of StagedBilling attribute for a record.
@UncheckedAccess
FUNCTION Get_Staged_Billing_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.staged_billing%TYPE
IS
   temp_ customer_order_tab.staged_billing%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT staged_billing
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Staged_Billing_Db');
END Get_Staged_Billing_Db;


-- Get_Sm_Connection
--   Fetches the SmConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Sm_Connection (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.sm_connection%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT sm_connection
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Service_Management_Connect_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Sm_Connection');
END Get_Sm_Connection;


-- Get_Sm_Connection_Db
--   Fetches the DB value of SmConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Sm_Connection_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.sm_connection%TYPE
IS
   temp_ customer_order_tab.sm_connection%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT sm_connection
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Sm_Connection_Db');
END Get_Sm_Connection_Db;


-- Get_Scheduling_Connection
--   Fetches the SchedulingConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Scheduling_Connection (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.scheduling_connection%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT scheduling_connection
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Schedule_Agreement_Order_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Scheduling_Connection');
END Get_Scheduling_Connection;


-- Get_Scheduling_Connection_Db
--   Fetches the DB value of SchedulingConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Scheduling_Connection_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.scheduling_connection%TYPE
IS
   temp_ customer_order_tab.scheduling_connection%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT scheduling_connection
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Scheduling_Connection_Db');
END Get_Scheduling_Connection_Db;


-- Get_Priority
--   Fetches the Priority attribute for a record.
@UncheckedAccess
FUNCTION Get_Priority (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.priority%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT priority
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Priority');
END Get_Priority;


-- Get_Intrastat_Exempt
--   Fetches the IntrastatExempt attribute for a record.
@UncheckedAccess
FUNCTION Get_Intrastat_Exempt (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.intrastat_exempt%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT intrastat_exempt
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Intrastat_Exempt_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Intrastat_Exempt');
END Get_Intrastat_Exempt;


-- Get_Intrastat_Exempt_Db
--   Fetches the DB value of IntrastatExempt attribute for a record.
@UncheckedAccess
FUNCTION Get_Intrastat_Exempt_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.intrastat_exempt%TYPE
IS
   temp_ customer_order_tab.intrastat_exempt%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT intrastat_exempt
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Intrastat_Exempt_Db');
END Get_Intrastat_Exempt_Db;


-- Get_Additional_Discount
--   Fetches the AdditionalDiscount attribute for a record.
@UncheckedAccess
FUNCTION Get_Additional_Discount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.additional_discount%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT additional_discount
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Additional_Discount');
END Get_Additional_Discount;


-- Get_Pay_Term_Base_Date
--   Fetches the PayTermBaseDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Pay_Term_Base_Date (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.pay_term_base_date%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT pay_term_base_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Pay_Term_Base_Date');
END Get_Pay_Term_Base_Date;


-- Get_Summarized_Source_Lines
--   Fetches the SummarizedSourceLines attribute for a record.
@UncheckedAccess
FUNCTION Get_Summarized_Source_Lines (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.summarized_source_lines%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT summarized_source_lines
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Gen_Yes_No_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Summarized_Source_Lines');
END Get_Summarized_Source_Lines;


-- Get_Summarized_Source_Lines_Db
--   Fetches the DB value of SummarizedSourceLines attribute for a record.
@UncheckedAccess
FUNCTION Get_Summarized_Source_Lines_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.summarized_source_lines%TYPE
IS
   temp_ customer_order_tab.summarized_source_lines%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT summarized_source_lines
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Summarized_Source_Lines_Db');
END Get_Summarized_Source_Lines_Db;


-- Get_Case_Id
--   Fetches the CaseId attribute for a record.
@UncheckedAccess
FUNCTION Get_Case_Id (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.case_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT case_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Case_Id');
END Get_Case_Id;


-- Get_Task_Id
--   Fetches the TaskId attribute for a record.
@UncheckedAccess
FUNCTION Get_Task_Id (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.task_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT task_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Task_Id');
END Get_Task_Id;


-- Get_Confirm_Deliveries
--   Fetches the ConfirmDeliveries attribute for a record.
@UncheckedAccess
FUNCTION Get_Confirm_Deliveries (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.confirm_deliveries%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT confirm_deliveries
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Confirm_Deliveries');
END Get_Confirm_Deliveries;


-- Get_Confirm_Deliveries_Db
--   Fetches the DB value of ConfirmDeliveries attribute for a record.
@UncheckedAccess
FUNCTION Get_Confirm_Deliveries_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.confirm_deliveries%TYPE
IS
   temp_ customer_order_tab.confirm_deliveries%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT confirm_deliveries
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Confirm_Deliveries_Db');
END Get_Confirm_Deliveries_Db;


-- Get_Check_Sales_Grp_Deliv_Conf
--   Fetches the CheckSalesGrpDelivConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Check_Sales_Grp_Deliv_Conf (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.check_sales_grp_deliv_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT check_sales_grp_deliv_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Check_Sales_Grp_Deliv_Conf');
END Get_Check_Sales_Grp_Deliv_Conf;


-- Get_Check_Sales_Grp_Dc_Db
--   Fetches the DB value of CheckSalesGrpDelivConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Check_Sales_Grp_Dc_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.check_sales_grp_deliv_conf%TYPE
IS
   temp_ customer_order_tab.check_sales_grp_deliv_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT check_sales_grp_deliv_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Check_Sales_Grp_Dc_Db');
END Get_Check_Sales_Grp_Dc_Db;


-- Get_Delay_Cogs_To_Deliv_Conf
--   Fetches the DelayCogsToDelivConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Delay_Cogs_To_Deliv_Conf (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.delay_cogs_to_deliv_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delay_cogs_to_deliv_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Delay_Cogs_To_Deliv_Conf');
END Get_Delay_Cogs_To_Deliv_Conf;


-- Get_Delay_Cogs_To_Dc_Db
--   Fetches the DB value of DelayCogsToDelivConf attribute for a record.
@UncheckedAccess
FUNCTION Get_Delay_Cogs_To_Dc_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.delay_cogs_to_deliv_conf%TYPE
IS
   temp_ customer_order_tab.delay_cogs_to_deliv_conf%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delay_cogs_to_deliv_conf
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Delay_Cogs_To_Dc_Db');
END Get_Delay_Cogs_To_Dc_Db;


-- Get_Cancel_Reason
--   Fetches the CancelReason attribute for a record.
@UncheckedAccess
FUNCTION Get_Cancel_Reason (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.cancel_reason%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cancel_reason
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Cancel_Reason');
END Get_Cancel_Reason;


-- Get_Jinsui_Invoice
--   Fetches the JinsuiInvoice attribute for a record.
@UncheckedAccess
FUNCTION Get_Jinsui_Invoice (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.jinsui_invoice%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT jinsui_invoice
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Jinsui_Invoice');
END Get_Jinsui_Invoice;


-- Get_Jinsui_Invoice_Db
--   Fetches the DB value of JinsuiInvoice attribute for a record.
@UncheckedAccess
FUNCTION Get_Jinsui_Invoice_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.jinsui_invoice%TYPE
IS
   temp_ customer_order_tab.jinsui_invoice%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT jinsui_invoice
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Jinsui_Invoice_Db');
END Get_Jinsui_Invoice_Db;


-- Get_Blocked_Reason
--   Fetches the BlockedReason attribute for a record.
@UncheckedAccess
FUNCTION Get_Blocked_Reason (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.blocked_reason%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT blocked_reason
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Blocked_Reason');
END Get_Blocked_Reason;


-- Get_Blocked_From_State
--   Fetches the BlockedFromState attribute for a record.
@UncheckedAccess
FUNCTION Get_Blocked_From_State (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.blocked_from_state%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT blocked_from_state
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Blocked_From_State');
END Get_Blocked_From_State;


-- Get_Sales_Contract_No
--   Fetches the SalesContractNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Sales_Contract_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.sales_contract_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT sales_contract_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Sales_Contract_No');
END Get_Sales_Contract_No;


-- Get_Contract_Rev_Seq
--   Fetches the ContractRevSeq attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract_Rev_Seq (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.contract_rev_seq%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract_rev_seq
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Contract_Rev_Seq');
END Get_Contract_Rev_Seq;


-- Get_Contract_Line_No
--   Fetches the ContractLineNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract_Line_No (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.contract_line_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract_line_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Contract_Line_No');
END Get_Contract_Line_No;


-- Get_Contract_Item_No
--   Fetches the ContractItemNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract_Item_No (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.contract_item_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract_item_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Contract_Item_No');
END Get_Contract_Item_No;


-- Get_Released_From_Credit_Check
--   Fetches the ReleasedFromCreditCheck attribute for a record.
@UncheckedAccess
FUNCTION Get_Released_From_Credit_Check (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.released_from_credit_check%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT released_from_credit_check
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Released_From_Credit_Check');
END Get_Released_From_Credit_Check;


-- Get_Released_From_Credit_Ch_Db
--   Fetches the DB value of ReleasedFromCreditCheck attribute for a record.
@UncheckedAccess
FUNCTION Get_Released_From_Credit_Ch_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.released_from_credit_check%TYPE
IS
   temp_ customer_order_tab.released_from_credit_check%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT released_from_credit_check
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Released_From_Credit_Ch_Db');
END Get_Released_From_Credit_Ch_Db;


-- Get_Proposed_Prepayment_Amount
--   Fetches the ProposedPrepaymentAmount attribute for a record.
@UncheckedAccess
FUNCTION Get_Proposed_Prepayment_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.proposed_prepayment_amount%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT proposed_prepayment_amount
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Proposed_Prepayment_Amount');
END Get_Proposed_Prepayment_Amount;


-- Get_Prepayment_Approved
--   Fetches the PrepaymentApproved attribute for a record.
@UncheckedAccess
FUNCTION Get_Prepayment_Approved (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.prepayment_approved%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT prepayment_approved
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Prepayment_Approved');
END Get_Prepayment_Approved;


-- Get_Prepayment_Approved_Db
--   Fetches the DB value of PrepaymentApproved attribute for a record.
@UncheckedAccess
FUNCTION Get_Prepayment_Approved_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.prepayment_approved%TYPE
IS
   temp_ customer_order_tab.prepayment_approved%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT prepayment_approved
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Prepayment_Approved_Db');
END Get_Prepayment_Approved_Db;


-- Get_Backorder_Option
--   Fetches the BackorderOption attribute for a record.
@UncheckedAccess
FUNCTION Get_Backorder_Option (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.backorder_option%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT backorder_option
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Customer_Backorder_Option_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Backorder_Option');
END Get_Backorder_Option;


-- Get_Backorder_Option_Db
--   Fetches the DB value of BackorderOption attribute for a record.
@UncheckedAccess
FUNCTION Get_Backorder_Option_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.backorder_option%TYPE
IS
   temp_ customer_order_tab.backorder_option%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT backorder_option
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Backorder_Option_Db');
END Get_Backorder_Option_Db;


-- Get_Expected_Prepayment_Date
--   Fetches the ExpectedPrepaymentDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Expected_Prepayment_Date (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.expected_prepayment_date%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT expected_prepayment_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Expected_Prepayment_Date');
END Get_Expected_Prepayment_Date;


-- Get_Shipment_Creation
--   Fetches the ShipmentCreation attribute for a record.
@UncheckedAccess
FUNCTION Get_Shipment_Creation (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.shipment_creation%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT shipment_creation
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Shipment_Creation_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Shipment_Creation');
END Get_Shipment_Creation;


-- Get_Shipment_Creation_Db
--   Fetches the DB value of ShipmentCreation attribute for a record.
@UncheckedAccess
FUNCTION Get_Shipment_Creation_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.shipment_creation%TYPE
IS
   temp_ customer_order_tab.shipment_creation%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT shipment_creation
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Shipment_Creation_Db');
END Get_Shipment_Creation_Db;


-- Get_Use_Pre_Ship_Del_Note
--   Fetches the UsePreShipDelNote attribute for a record.
@UncheckedAccess
FUNCTION Get_Use_Pre_Ship_Del_Note (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.use_pre_ship_del_note%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT use_pre_ship_del_note
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Use_Pre_Ship_Del_Note');
END Get_Use_Pre_Ship_Del_Note;


-- Get_Use_Pre_Ship_Del_Note_Db
--   Fetches the DB value of UsePreShipDelNote attribute for a record.
@UncheckedAccess
FUNCTION Get_Use_Pre_Ship_Del_Note_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.use_pre_ship_del_note%TYPE
IS
   temp_ customer_order_tab.use_pre_ship_del_note%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT use_pre_ship_del_note
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Use_Pre_Ship_Del_Note_Db');
END Get_Use_Pre_Ship_Del_Note_Db;


-- Get_Pick_Inventory_Type
--   Fetches the PickInventoryType attribute for a record.
@UncheckedAccess
FUNCTION Get_Pick_Inventory_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.pick_inventory_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT pick_inventory_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Pick_Inventory_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Pick_Inventory_Type');
END Get_Pick_Inventory_Type;


-- Get_Pick_Inventory_Type_Db
--   Fetches the DB value of PickInventoryType attribute for a record.
@UncheckedAccess
FUNCTION Get_Pick_Inventory_Type_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.pick_inventory_type%TYPE
IS
   temp_ customer_order_tab.pick_inventory_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT pick_inventory_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Pick_Inventory_Type_Db');
END Get_Pick_Inventory_Type_Db;


-- Get_Tax_Id_No
--   Fetches the TaxIdNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Tax_Id_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.tax_id_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT tax_id_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Tax_Id_No');
END Get_Tax_Id_No;


-- Get_Tax_Id_Validated_Date
--   Fetches the TaxIdValidatedDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Tax_Id_Validated_Date (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.tax_id_validated_date%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT tax_id_validated_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Tax_Id_Validated_Date');
END Get_Tax_Id_Validated_Date;


-- Get_Classification_Standard
--   Fetches the ClassificationStandard attribute for a record.
@UncheckedAccess
FUNCTION Get_Classification_Standard (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.classification_standard%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT classification_standard
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Classification_Standard');
END Get_Classification_Standard;


-- Get_Msg_Sequence_No
--   Fetches the MsgSequenceNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Msg_Sequence_No (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.msg_sequence_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT msg_sequence_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Msg_Sequence_No');
END Get_Msg_Sequence_No;


-- Get_Msg_Version_No
--   Fetches the MsgVersionNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Msg_Version_No (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.msg_version_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT msg_version_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Msg_Version_No');
END Get_Msg_Version_No;


-- Get_Currency_Rate_Type
--   Fetches the CurrencyRateType attribute for a record.
@UncheckedAccess
FUNCTION Get_Currency_Rate_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.currency_rate_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT currency_rate_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Currency_Rate_Type');
END Get_Currency_Rate_Type;


-- Get_Del_Terms_Location
--   Fetches the DelTermsLocation attribute for a record.
@UncheckedAccess
FUNCTION Get_Del_Terms_Location (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.del_terms_location%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT del_terms_location
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Del_Terms_Location');
END Get_Del_Terms_Location;


-- Get_Internal_Ref
--   Fetches the InternalRef attribute for a record.
@UncheckedAccess
FUNCTION Get_Internal_Ref (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.internal_ref%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT internal_ref
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Internal_Ref');
END Get_Internal_Ref;


-- Get_Internal_Po_Label_Note
--   Fetches the InternalPoLabelNote attribute for a record.
@UncheckedAccess
FUNCTION Get_Internal_Po_Label_Note (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.internal_po_label_note%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT internal_po_label_note
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Internal_Po_Label_Note');
END Get_Internal_Po_Label_Note;


-- Get_Supply_Country
--   Fetches the SupplyCountry attribute for a record.
@UncheckedAccess
FUNCTION Get_Supply_Country (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.supply_country%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supply_country
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Iso_Country_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Supply_Country');
END Get_Supply_Country;


-- Get_Supply_Country_Db
--   Fetches the DB value of SupplyCountry attribute for a record.
@UncheckedAccess
FUNCTION Get_Supply_Country_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.supply_country%TYPE
IS
   temp_ customer_order_tab.supply_country%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supply_country
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Supply_Country_Db');
END Get_Supply_Country_Db;


-- Get_Rebate_Customer
--   Fetches the RebateCustomer attribute for a record.
@UncheckedAccess
FUNCTION Get_Rebate_Customer (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.rebate_customer%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rebate_customer
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Rebate_Customer');
END Get_Rebate_Customer;


-- Get_Freight_Map_Id
--   Fetches the FreightMapId attribute for a record.
@UncheckedAccess
FUNCTION Get_Freight_Map_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.freight_map_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT freight_map_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Freight_Map_Id');
END Get_Freight_Map_Id;


-- Get_Zone_Id
--   Fetches the ZoneId attribute for a record.
@UncheckedAccess
FUNCTION Get_Zone_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.zone_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT zone_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Zone_Id');
END Get_Zone_Id;


-- Get_Freight_Price_List_No
--   Fetches the FreightPriceListNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Freight_Price_List_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.freight_price_list_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT freight_price_list_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Freight_Price_List_No');
END Get_Freight_Price_List_No;


-- Get_Summarized_Freight_Charges
--   Fetches the SummarizedFreightCharges attribute for a record.
@UncheckedAccess
FUNCTION Get_Summarized_Freight_Charges (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.summarized_freight_charges%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT summarized_freight_charges
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Gen_Yes_No_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Summarized_Freight_Charges');
END Get_Summarized_Freight_Charges;


-- Get_Summarized_Freight_Char_Db
--   Fetches the DB value of SummarizedFreightCharges attribute for a record.
@UncheckedAccess
FUNCTION Get_Summarized_Freight_Char_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.summarized_freight_charges%TYPE
IS
   temp_ customer_order_tab.summarized_freight_charges%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT summarized_freight_charges
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Summarized_Freight_Char_Db');
END Get_Summarized_Freight_Char_Db;


-- Get_Apply_Fix_Deliv_Freight
--   Fetches the ApplyFixDelivFreight attribute for a record.
@UncheckedAccess
FUNCTION Get_Apply_Fix_Deliv_Freight (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.apply_fix_deliv_freight%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT apply_fix_deliv_freight
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Apply_Fix_Deliv_Freight');
END Get_Apply_Fix_Deliv_Freight;


-- Get_Apply_Fix_Deliv_Freight_Db
--   Fetches the DB value of ApplyFixDelivFreight attribute for a record.
@UncheckedAccess
FUNCTION Get_Apply_Fix_Deliv_Freight_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.apply_fix_deliv_freight%TYPE
IS
   temp_ customer_order_tab.apply_fix_deliv_freight%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT apply_fix_deliv_freight
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Apply_Fix_Deliv_Freight_Db');
END Get_Apply_Fix_Deliv_Freight_Db;


-- Get_Fix_Deliv_Freight
--   Fetches the FixDelivFreight attribute for a record.
@UncheckedAccess
FUNCTION Get_Fix_Deliv_Freight (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.fix_deliv_freight%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT fix_deliv_freight
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Fix_Deliv_Freight');
END Get_Fix_Deliv_Freight;


-- Get_Print_Delivered_Lines
--   Fetches the PrintDeliveredLines attribute for a record.
@UncheckedAccess
FUNCTION Get_Print_Delivered_Lines (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.print_delivered_lines%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT print_delivered_lines
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Delivery_Note_Options_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Print_Delivered_Lines');
END Get_Print_Delivered_Lines;


-- Get_Print_Delivered_Lines_Db
--   Fetches the DB value of PrintDeliveredLines attribute for a record.
@UncheckedAccess
FUNCTION Get_Print_Delivered_Lines_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.print_delivered_lines%TYPE
IS
   temp_ customer_order_tab.print_delivered_lines%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT print_delivered_lines
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Print_Delivered_Lines_Db');
END Get_Print_Delivered_Lines_Db;


-- Get_Cust_Calendar_Id
--   Fetches the CustCalendarId attribute for a record.
@UncheckedAccess
FUNCTION Get_Cust_Calendar_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.cust_calendar_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cust_calendar_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Cust_Calendar_Id');
END Get_Cust_Calendar_Id;


-- Get_Ext_Transport_Calendar_Id
--   Fetches the ExtTransportCalendarId attribute for a record.
@UncheckedAccess
FUNCTION Get_Ext_Transport_Calendar_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.ext_transport_calendar_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ext_transport_calendar_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Ext_Transport_Calendar_Id');
END Get_Ext_Transport_Calendar_Id;


-- Get_Use_Price_Incl_Tax
--   Fetches the UsePriceInclTax attribute for a record.
@UncheckedAccess
FUNCTION Get_Use_Price_Incl_Tax (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.use_price_incl_tax%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT use_price_incl_tax
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Use_Price_Incl_Tax');
END Get_Use_Price_Incl_Tax;


-- Get_Use_Price_Incl_Tax_Db
--   Fetches the DB value of UsePriceInclTax attribute for a record.
@UncheckedAccess
FUNCTION Get_Use_Price_Incl_Tax_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.use_price_incl_tax%TYPE
IS
   temp_ customer_order_tab.use_price_incl_tax%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT use_price_incl_tax
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Use_Price_Incl_Tax_Db');
END Get_Use_Price_Incl_Tax_Db;


-- Get_Customs_Value_Currency
--   Fetches the CustomsValueCurrency attribute for a record.
@UncheckedAccess
FUNCTION Get_Customs_Value_Currency (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customs_value_currency%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customs_value_currency
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customs_Value_Currency');
END Get_Customs_Value_Currency;


-- Get_Business_Opportunity_No
--   Fetches the BusinessOpportunityNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Business_Opportunity_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.business_opportunity_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT business_opportunity_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Business_Opportunity_No');
END Get_Business_Opportunity_No;


-- Get_Picking_Leadtime
--   Fetches the PickingLeadtime attribute for a record.
@UncheckedAccess
FUNCTION Get_Picking_Leadtime (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ customer_order_tab.picking_leadtime%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT picking_leadtime
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Picking_Leadtime');
END Get_Picking_Leadtime;


-- Get_Shipment_Type
--   Fetches the ShipmentType attribute for a record.
@UncheckedAccess
FUNCTION Get_Shipment_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.shipment_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT shipment_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Shipment_Type');
END Get_Shipment_Type;


-- Get_Vendor_No
--   Fetches the VendorNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Vendor_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.vendor_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT vendor_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Vendor_No');
END Get_Vendor_No;


-- Get_Quotation_No
--   Fetches the QuotationNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Quotation_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.quotation_no%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT quotation_no
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Quotation_No');
END Get_Quotation_No;


-- Get_Free_Of_Chg_Tax_Pay_Party
--   Fetches the FreeOfChgTaxPayParty attribute for a record.
@UncheckedAccess
FUNCTION Get_Free_Of_Chg_Tax_Pay_Party (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.free_of_chg_tax_pay_party%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT free_of_chg_tax_pay_party
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Tax_Paying_Party_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Free_Of_Chg_Tax_Pay_Party');
END Get_Free_Of_Chg_Tax_Pay_Party;


-- Get_Free_Of_Chg_Tax_Pay_Par_Db
--   Fetches the DB value of FreeOfChgTaxPayParty attribute for a record.
@UncheckedAccess
FUNCTION Get_Free_Of_Chg_Tax_Pay_Par_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.free_of_chg_tax_pay_party%TYPE
IS
   temp_ customer_order_tab.free_of_chg_tax_pay_party%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT free_of_chg_tax_pay_party
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Free_Of_Chg_Tax_Pay_Par_Db');
END Get_Free_Of_Chg_Tax_Pay_Par_Db;


-- Get_Blocked_Type
--   Fetches the BlockedType attribute for a record.
@UncheckedAccess
FUNCTION Get_Blocked_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.blocked_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT blocked_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Customer_Order_Block_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Blocked_Type');
END Get_Blocked_Type;


-- Get_Blocked_Type_Db
--   Fetches the DB value of BlockedType attribute for a record.
@UncheckedAccess
FUNCTION Get_Blocked_Type_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.blocked_type%TYPE
IS
   temp_ customer_order_tab.blocked_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT blocked_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Blocked_Type_Db');
END Get_Blocked_Type_Db;


-- Get_B2b_Order
--   Fetches the B2bOrder attribute for a record.
@UncheckedAccess
FUNCTION Get_B2b_Order (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.b2b_order%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT b2b_order
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_B2b_Order');
END Get_B2b_Order;


-- Get_B2b_Order_Db
--   Fetches the DB value of B2bOrder attribute for a record.
@UncheckedAccess
FUNCTION Get_B2b_Order_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.b2b_order%TYPE
IS
   temp_ customer_order_tab.b2b_order%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT b2b_order
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_B2b_Order_Db');
END Get_B2b_Order_Db;


-- Get_Limit_Sales_To_Assortments
--   Fetches the LimitSalesToAssortments attribute for a record.
@UncheckedAccess
FUNCTION Get_Limit_Sales_To_Assortments (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.limit_sales_to_assortments%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT limit_sales_to_assortments
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Limit_Sales_To_Assortments');
END Get_Limit_Sales_To_Assortments;


-- Get_Limit_Sales_To_Assortme_Db
--   Fetches the DB value of LimitSalesToAssortments attribute for a record.
@UncheckedAccess
FUNCTION Get_Limit_Sales_To_Assortme_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.limit_sales_to_assortments%TYPE
IS
   temp_ customer_order_tab.limit_sales_to_assortments%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT limit_sales_to_assortments
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Limit_Sales_To_Assortme_Db');
END Get_Limit_Sales_To_Assortme_Db;


-- Get_Final_Consumer
--   Fetches the FinalConsumer attribute for a record.
@UncheckedAccess
FUNCTION Get_Final_Consumer (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.final_consumer%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT final_consumer
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Final_Consumer');
END Get_Final_Consumer;


-- Get_Final_Consumer_Db
--   Fetches the DB value of FinalConsumer attribute for a record.
@UncheckedAccess
FUNCTION Get_Final_Consumer_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.final_consumer%TYPE
IS
   temp_ customer_order_tab.final_consumer%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT final_consumer
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Final_Consumer_Db');
END Get_Final_Consumer_Db;


-- Get_Customer_Tax_Usage_Type
--   Fetches the CustomerTaxUsageType attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Tax_Usage_Type (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.customer_tax_usage_type%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_tax_usage_type
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Customer_Tax_Usage_Type');
END Get_Customer_Tax_Usage_Type;


-- Get_Invoice_Reason_Id
--   Fetches the InvoiceReasonId attribute for a record.
@UncheckedAccess
FUNCTION Get_Invoice_Reason_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.invoice_reason_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT invoice_reason_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Invoice_Reason_Id');
END Get_Invoice_Reason_Id;


-- Get_Delivery_Reason_Id
--   Fetches the DeliveryReasonId attribute for a record.
@UncheckedAccess
FUNCTION Get_Delivery_Reason_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.delivery_reason_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delivery_reason_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Delivery_Reason_Id');
END Get_Delivery_Reason_Id;


-- Get_Component_A
--   Fetches the ComponentA attribute for a record.
@UncheckedAccess
FUNCTION Get_Component_A (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.component_a%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT component_a
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Component_A');
END Get_Component_A;


-- Get_Service_Code
--   Fetches the ServiceCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Service_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.service_code%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT service_code
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Service_Code');
END Get_Service_Code;


-- Get_Disc_Price_Round
--   Fetches the DiscPriceRound attribute for a record.
@UncheckedAccess
FUNCTION Get_Disc_Price_Round (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.disc_price_round%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT disc_price_round
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Disc_Price_Round');
END Get_Disc_Price_Round;


-- Get_Disc_Price_Round_Db
--   Fetches the DB value of DiscPriceRound attribute for a record.
@UncheckedAccess
FUNCTION Get_Disc_Price_Round_Db (
   order_no_ IN VARCHAR2 ) RETURN customer_order_tab.disc_price_round%TYPE
IS
   temp_ customer_order_tab.disc_price_round%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT disc_price_round
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Disc_Price_Round_Db');
END Get_Disc_Price_Round_Db;


-- Get_Business_Transaction_Id
--   Fetches the BusinessTransactionId attribute for a record.
@UncheckedAccess
FUNCTION Get_Business_Transaction_Id (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.business_transaction_id%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT business_transaction_id
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Business_Transaction_Id');
END Get_Business_Transaction_Id;


-- Get_Invoiced_Closed_Date
--   Fetches the InvoicedClosedDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Invoiced_Closed_Date (
   order_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ customer_order_tab.invoiced_closed_date%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT invoiced_closed_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Invoiced_Closed_Date');
END Get_Invoiced_Closed_Date;


-- Get_State
--   Fetches the State attribute for a record.
@UncheckedAccess
FUNCTION Get_State (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Decode__(Get_Objstate(order_no_));
END Get_State;


-- Get_Objstate
--   Fetches the Objstate attribute for a record.
@UncheckedAccess
FUNCTION Get_Objstate (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_order_tab.rowstate%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowstate
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Objstate');
END Get_Objstate;


-- Get_Objevents
--   Fetches the Objevents attribute for a record.
@UncheckedAccess
FUNCTION Get_Objevents (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Events__(Get_Objstate(order_no_));
END Get_Objevents;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ customer_order_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.order_no);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   order_no_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_no, rowid, rowversion, rowkey, rowstate,
          authorize_code, 
          bill_addr_no, 
          contract, 
          country_code, 
          currency_code, 
          customer_no, 
          customer_no_pay, 
          customer_no_pay_addr_no, 
          customer_no_pay_ref, 
          delivery_terms, 
          district_code, 
          language_code, 
          market_code, 
          note_id, 
          order_code, 
          order_id, 
          pay_term_id, 
          pre_accounting_id, 
          print_control_code, 
          region_code, 
          salesman_code, 
          ship_addr_no, 
          ship_via_code, 
          addr_flag, 
          grp_disc_calc_flag, 
          customer_po_no, 
          cust_ref, 
          date_entered, 
          delivery_leadtime, 
          label_note, 
          note_text, 
          order_conf, 
          tax_liability, 
          wanted_delivery_date, 
          internal_po_no, 
          route_id, 
          agreement_id, 
          forward_agent_id, 
          internal_delivery_type, 
          external_ref, 
          project_id, 
          staged_billing, 
          sm_connection, 
          scheduling_connection, 
          priority, 
          intrastat_exempt, 
          additional_discount, 
          pay_term_base_date, 
          summarized_source_lines, 
          case_id, 
          task_id, 
          confirm_deliveries, 
          check_sales_grp_deliv_conf, 
          delay_cogs_to_deliv_conf, 
          cancel_reason, 
          jinsui_invoice, 
          blocked_reason, 
          blocked_from_state, 
          sales_contract_no, 
          contract_rev_seq, 
          contract_line_no, 
          contract_item_no, 
          released_from_credit_check, 
          proposed_prepayment_amount, 
          prepayment_approved, 
          backorder_option, 
          expected_prepayment_date, 
          shipment_creation, 
          use_pre_ship_del_note, 
          pick_inventory_type, 
          tax_id_no, 
          tax_id_validated_date, 
          classification_standard, 
          msg_sequence_no, 
          msg_version_no, 
          currency_rate_type, 
          del_terms_location, 
          internal_ref, 
          internal_po_label_note, 
          supply_country, 
          rebate_customer, 
          freight_map_id, 
          zone_id, 
          freight_price_list_no, 
          summarized_freight_charges, 
          apply_fix_deliv_freight, 
          fix_deliv_freight, 
          print_delivered_lines, 
          cust_calendar_id, 
          ext_transport_calendar_id, 
          use_price_incl_tax, 
          customs_value_currency, 
          business_opportunity_no, 
          picking_leadtime, 
          shipment_type, 
          vendor_no, 
          quotation_no, 
          free_of_chg_tax_pay_party, 
          blocked_type, 
          b2b_order, 
          limit_sales_to_assortments, 
          final_consumer, 
          customer_tax_usage_type, 
          invoice_reason_id, 
          delivery_reason_id, 
          component_a, 
          service_code, 
          disc_price_round, 
          business_transaction_id, 
          invoiced_closed_date
      INTO  temp_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ customer_order_tab.rowkey%TYPE;
BEGIN
   IF (order_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  customer_order_tab
      WHERE order_no = order_no_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_no_, 'Get_Objkey');
END Get_Objkey;

-------------------- FINITE STATE MACHINE -----------------------------------

-- Get_Db_Values___
--   Returns the the list of DB (stored in database) values.
FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Planned^Blocked^Delivered^Invoiced^Released^Reserved^Picked^PartiallyDelivered^Cancelled^');
END Get_Db_Values___;


-- Get_Client_Values___
--   Returns the the list of client (in PROG language) values.
FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Planned^Blocked^Delivered^Invoiced/Closed^Released^Reserved^Picked^Partially Delivered^Cancelled^');
END Get_Client_Values___;


-- Do_Release_Blocked___
--    Execute the DoReleaseBlocked action within the finite state machine.
PROCEDURE Do_Release_Blocked___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Cancelled___
--    Execute the DoSetLineCancelled action within the finite state machine.
PROCEDURE Do_Set_Line_Cancelled___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Assigned___
--    Execute the DoSetLineQtyAssigned action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Assigned___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Confdiff___
--    Execute the DoSetLineQtyConfdiff action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Confdiff___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Invoiced___
--    Execute the DoSetLineQtyInvoiced action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Invoiced___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Picked___
--    Execute the DoSetLineQtyPicked action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Picked___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Shipdiff___
--    Execute the DoSetLineQtyShipdiff action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Shipdiff___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Qty_Shipped___
--    Execute the DoSetLineQtyShipped action within the finite state machine.
PROCEDURE Do_Set_Line_Qty_Shipped___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Line_Uninvoiced___
--    Execute the DoSetLineUninvoiced action within the finite state machine.
PROCEDURE Do_Set_Line_Uninvoiced___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Rent_Line_Completed___
--    Execute the DoSetRentLineCompleted action within the finite state machine.
PROCEDURE Do_Set_Rent_Line_Completed___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Set_Rent_Line_Reopened___
--    Execute the DoSetRentLineReopened action within the finite state machine.
PROCEDURE Do_Set_Rent_Line_Reopened___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Do_Undo_Line_Delivery___
--    Execute the DoUndoLineDelivery action within the finite state machine.
PROCEDURE Do_Undo_Line_Delivery___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Order_Delivered___
--    Execute the OrderDelivered action within the finite state machine.
PROCEDURE Order_Delivered___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- All_Charges_Fully_Invoiced___
--    Evaluates the AllChargesFullyInvoiced condition within the finite state machine.
FUNCTION All_Charges_Fully_Invoiced___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Only_Charges_Exist___
--    Evaluates the OnlyChargesExist condition within the finite state machine.
FUNCTION Only_Charges_Exist___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Fully_Delivered___
--    Evaluates the OrderIsFullyDelivered condition within the finite state machine.
FUNCTION Order_Is_Fully_Delivered___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Fully_Invoiced___
--    Evaluates the OrderIsFullyInvoiced condition within the finite state machine.
FUNCTION Order_Is_Fully_Invoiced___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Manual_Block___
--    Evaluates the OrderIsManualBlock condition within the finite state machine.
FUNCTION Order_Is_Manual_Block___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Picked___
--    Evaluates the OrderIsPicked condition within the finite state machine.
FUNCTION Order_Is_Picked___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Planned___
--    Evaluates the OrderIsPlanned condition within the finite state machine.
FUNCTION Order_Is_Planned___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Is_Reserved___
--    Evaluates the OrderIsReserved condition within the finite state machine.
FUNCTION Order_Is_Reserved___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Order_Partially_Delivered___
--    Evaluates the OrderPartiallyDelivered condition within the finite state machine.
FUNCTION Order_Partially_Delivered___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Finite_State_Set___
--    Updates the state column in the database for given record.
@RmcomAccessCheck CustomerOrder(order_no,customer_no)
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT customer_order_tab%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   rec_.rowversion := sysdate;
   UPDATE customer_order_tab
      SET rowstate = state_,
          rowversion = rec_.rowversion
      WHERE order_no = rec_.order_no;
   rec_.rowstate := state_;
END Finite_State_Set___;


-- Finite_State_Machine___
--    Execute the state machine logic given a specific event.
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT customer_order_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   state_ customer_order_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   IF (state_ IS NULL) THEN
      IF (event_ IS NULL) THEN
         Finite_State_Set___(rec_, 'Planned');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Blocked') THEN
      IF (event_ IS NULL) THEN
         NULL;
      ELSIF (event_ = 'ReleaseBlocked') THEN
         IF (Order_Is_Planned___(rec_) AND Order_Is_Manual_Block___(rec_)) THEN
            Do_Release_Blocked___(rec_, attr_);
            Finite_State_Set___(rec_, 'Planned');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF ((Order_Is_Planned___(rec_) AND  NOT Order_Is_Manual_Block___(rec_)) OR ( NOT Order_Is_Planned___(rec_))) THEN
            Do_Release_Blocked___(rec_, attr_);
            Finite_State_Set___(rec_, 'Released');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetCancelled') THEN
         Finite_State_Set___(rec_, 'Cancelled');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyConfirmeddiff') THEN
         Do_Set_Line_Qty_Confdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Cancelled') THEN
      IF (event_ IS NULL) THEN
         NULL;
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Delivered') THEN
      IF (event_ IS NULL) THEN
         IF (Order_Is_Fully_Invoiced___(rec_)) THEN
            Finite_State_Set___(rec_, 'Invoiced');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (NOT Order_Is_Fully_Delivered___(rec_)) THEN
            Finite_State_Set___(rec_, 'PartiallyDelivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'NewOrderLineAdded') THEN
         Finite_State_Set___(rec_, 'PartiallyDelivered');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyConfirmeddiff') THEN
         Do_Set_Line_Qty_Confdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetRentLineCompleted') THEN
         Do_Set_Rent_Line_Completed___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetRentLineReopened') THEN
         Do_Set_Rent_Line_Reopened___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'UndoLineDelivery') THEN
         Do_Undo_Line_Delivery___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Invoiced') THEN
      IF (event_ IS NULL) THEN
         IF (Only_Charges_Exist___(rec_) AND  NOT All_Charges_Fully_Invoiced___(rec_)) THEN
            Finite_State_Set___(rec_, 'Released');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (NOT Order_Is_Fully_Invoiced___(rec_)) THEN
            Finite_State_Set___(rec_, 'Delivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'NewOrChangedCharge') THEN
         IF (Only_Charges_Exist___(rec_)) THEN
            Finite_State_Set___(rec_, 'Released');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (Order_Is_Fully_Delivered___(rec_)) THEN
            Finite_State_Set___(rec_, 'Delivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'NewOrderLineAdded') THEN
         Finite_State_Set___(rec_, 'PartiallyDelivered');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetRentLineReopened') THEN
         Do_Set_Rent_Line_Reopened___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'UndoLineDelivery') THEN
         Do_Undo_Line_Delivery___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'PartiallyDelivered') THEN
      IF (event_ IS NULL) THEN
         IF (Order_Is_Fully_Delivered___(rec_)) THEN
            Order_Delivered___(rec_, attr_);
            Finite_State_Set___(rec_, 'Delivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (NOT Order_Partially_Delivered___(rec_)) THEN
            Finite_State_Set___(rec_, 'Picked');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetBlocked') THEN
         Finite_State_Set___(rec_, 'Blocked');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyConfirmeddiff') THEN
         Do_Set_Line_Qty_Confdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetRentLineCompleted') THEN
         Do_Set_Rent_Line_Completed___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetRentLineReopened') THEN
         Do_Set_Rent_Line_Reopened___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'UndoLineDelivery') THEN
         Do_Undo_Line_Delivery___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Picked') THEN
      IF (event_ IS NULL) THEN
         IF (Order_Partially_Delivered___(rec_)) THEN
            Finite_State_Set___(rec_, 'PartiallyDelivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (NOT Order_Is_Picked___(rec_)) THEN
            Finite_State_Set___(rec_, 'Reserved');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetBlocked') THEN
         Finite_State_Set___(rec_, 'Blocked');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Planned') THEN
      IF (event_ IS NULL) THEN
         NULL;
      ELSIF (event_ = 'SetBlocked') THEN
         IF (Order_Is_Manual_Block___(rec_)) THEN
            Finite_State_Set___(rec_, 'Blocked');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetCancelled') THEN
         Finite_State_Set___(rec_, 'Cancelled');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetReleased') THEN
         Finite_State_Set___(rec_, 'Released');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Released') THEN
      IF (event_ IS NULL) THEN
         IF (Order_Is_Reserved___(rec_)) THEN
            Finite_State_Set___(rec_, 'Reserved');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF ((Only_Charges_Exist___(rec_) AND All_Charges_Fully_Invoiced___(rec_)) AND (Order_Is_Fully_Invoiced___(rec_))) THEN
            Finite_State_Set___(rec_, 'Invoiced');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetBlocked') THEN
         Finite_State_Set___(rec_, 'Blocked');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetCancelled') THEN
         Finite_State_Set___(rec_, 'Cancelled');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Reserved') THEN
      IF (event_ IS NULL) THEN
         IF (Order_Partially_Delivered___(rec_)) THEN
            Finite_State_Set___(rec_, 'PartiallyDelivered');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (Order_Is_Picked___(rec_)) THEN
            Finite_State_Set___(rec_, 'Picked');
            Finite_State_Machine___(rec_, NULL, attr_);
         ELSIF (NOT Order_Is_Reserved___(rec_)) THEN
            Finite_State_Set___(rec_, 'Released');
            Finite_State_Machine___(rec_, NULL, attr_);
         END IF;
      ELSIF (event_ = 'SetBlocked') THEN
         Finite_State_Set___(rec_, 'Blocked');
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineCancelled') THEN
         Do_Set_Line_Cancelled___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyAssigned') THEN
         Do_Set_Line_Qty_Assigned___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyInvoiced') THEN
         Do_Set_Line_Qty_Invoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyPicked') THEN
         Do_Set_Line_Qty_Picked___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipdiff') THEN
         Do_Set_Line_Qty_Shipdiff___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineQtyShipped') THEN
         Do_Set_Line_Qty_Shipped___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSIF (event_ = 'SetLineUninvoiced') THEN
         Do_Set_Line_Uninvoiced___(rec_, attr_);
         Finite_State_Machine___(rec_, NULL, attr_);
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSE
      Error_SYS.State_Not_Exist(lu_name_, Finite_State_Decode__(state_));
   END IF;
END Finite_State_Machine___;


-- Finite_State_Add_To_Attr___
--    Add current state and lists of allowed events to an attribute string.
PROCEDURE Finite_State_Add_To_Attr___ (
   rec_  IN     customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   state_ customer_order_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   Client_SYS.Add_To_Attr('__OBJSTATE', state_, attr_);
   Client_SYS.Add_To_Attr('__OBJEVENTS', Finite_State_Events__(state_), attr_);
   Client_SYS.Add_To_Attr('STATE', Finite_State_Decode__(state_), attr_);
END Finite_State_Add_To_Attr___;


-- Finite_State_Init___
--    Runs the initial start event for the state machine.
PROCEDURE Finite_State_Init___ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Finite_State_Machine___(rec_, NULL, attr_);
   Finite_State_Add_To_Attr___(rec_, attr_);
END Finite_State_Init___;


-- Finite_State_Init_
--    Runs the initial start event for a basedOn child entity.
@ServerOnlyAccess
PROCEDURE Finite_State_Init_ (
   rec_  IN OUT customer_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Finite_State_Init___(rec_, attr_);
END Finite_State_Init_;


-- Finite_State_Decode__
--   Returns the client equivalent for any database representation of
--   a state name = objstate.
@UncheckedAccess
FUNCTION Finite_State_Decode__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_state_));
END Finite_State_Decode__;


-- Finite_State_Encode__
--   Returns the database equivalent for any client representation of
--   a state name = state.
@UncheckedAccess
FUNCTION Finite_State_Encode__ (
   client_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_state_));
END Finite_State_Encode__;


-- Enumerate_States__
--   Returns a list of all possible finite states in client terminology.
@UncheckedAccess
PROCEDURE Enumerate_States__ (
   client_values_ OUT VARCHAR2 )
IS
BEGIN
   client_values_ := Domain_SYS.Enumerate_(Domain_SYS.Get_Translated_Values(lu_name_));
END Enumerate_States__;


-- Enumerate_States_Db__
--   Returns a list of all possible finite states in database terminology.
@UncheckedAccess
PROCEDURE Enumerate_States_Db__ (
   db_values_ OUT VARCHAR2 )
IS
BEGIN
   db_values_ := Domain_SYS.Enumerate_(Get_Db_Values___);
END Enumerate_States_Db__;


-- Finite_State_Events__
--   Returns a list of allowed events for a given state
--   NOTE! Regardless of conditions if not otherwize encoded
@UncheckedAccess
FUNCTION Finite_State_Events__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (db_state_ IS NULL) THEN
      RETURN NULL;
   ELSIF (db_state_ = 'Blocked') THEN
      RETURN 'ReleaseBlocked^SetCancelled^SetLineCancelled^SetLineQtyAssigned^SetLineQtyConfirmeddiff^SetLineQtyInvoiced^SetLineQtyShipdiff^SetLineUninvoiced^SetLineQtyPicked^SetLineQtyShipped^';
   ELSIF (db_state_ = 'Cancelled') THEN
      RETURN NULL;
   ELSIF (db_state_ = 'Delivered') THEN
      RETURN 'NewOrderLineAdded^UndoLineDelivery^SetLineQtyAssigned^SetLineQtyConfirmeddiff^SetLineQtyInvoiced^SetLineQtyPicked^SetLineQtyShipdiff^SetRentLineCompleted^SetRentLineReopened^SetLineQtyShipped^SetLineUninvoiced^';
   ELSIF (db_state_ = 'Invoiced') THEN
      RETURN 'NewOrChangedCharge^NewOrderLineAdded^SetLineQtyAssigned^SetLineQtyPicked^SetLineQtyShipdiff^SetRentLineReopened^SetLineUninvoiced^UndoLineDelivery^SetLineQtyShipped^';
   ELSIF (db_state_ = 'PartiallyDelivered') THEN
      RETURN 'SetLineQtyConfirmeddiff^SetLineQtyPicked^SetLineQtyShipdiff^SetRentLineCompleted^UndoLineDelivery^SetRentLineReopened^SetBlocked^SetLineCancelled^SetLineQtyAssigned^SetLineQtyShipped^SetLineQtyInvoiced^SetLineUninvoiced^';
   ELSIF (db_state_ = 'Picked') THEN
      RETURN 'SetLineQtyPicked^SetLineQtyShipdiff^SetBlocked^SetLineCancelled^SetLineQtyAssigned^SetLineQtyShipped^SetLineQtyInvoiced^SetLineUninvoiced^';
   ELSIF (db_state_ = 'Planned') THEN
      RETURN 'SetCancelled^SetLineCancelled^SetLineQtyAssigned^SetReleased^SetLineQtyInvoiced^SetBlocked^';
   ELSIF (db_state_ = 'Released') THEN
      RETURN 'SetCancelled^SetLineQtyShipdiff^SetBlocked^SetLineCancelled^SetLineQtyAssigned^SetLineQtyShipped^SetLineQtyInvoiced^SetLineUninvoiced^';
   ELSIF (db_state_ = 'Reserved') THEN
      RETURN 'SetLineQtyPicked^SetLineQtyShipdiff^SetBlocked^SetLineCancelled^SetLineQtyAssigned^SetLineQtyShipped^SetLineQtyInvoiced^SetLineUninvoiced^';
   ELSE
      RETURN NULL;
   END IF;
END Finite_State_Events__;


-- Enumerate_Events__
--   Returns a list of all possible events.
@UncheckedAccess
PROCEDURE Enumerate_Events__ (
   db_events_ OUT VARCHAR2 )
IS
BEGIN
   db_events_ := 'NewOrChangedCharge^NewOrderLineAdded^ReleaseBlocked^SetBlocked^SetCancelled^SetLineCancelled^SetLineQtyAssigned^SetLineQtyConfirmeddiff^SetLineQtyInvoiced^SetLineQtyPicked^SetLineQtyShipdiff^SetLineQtyShipped^SetLineUninvoiced^SetReleased^SetRentLineCompleted^SetRentLineReopened^UndoLineDelivery^';
END Enumerate_Events__;


-- New_Or_Changed_Charge__
--   Executes the NewOrChangedCharge event logic as defined in the state machine.
PROCEDURE New_Or_Changed_Charge__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'NewOrChangedCharge', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New_Or_Changed_Charge__;


-- New_Order_Line_Added__
--   Executes the NewOrderLineAdded event logic as defined in the state machine.
PROCEDURE New_Order_Line_Added__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'NewOrderLineAdded', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New_Order_Line_Added__;


-- Release_Blocked__
--   Executes the ReleaseBlocked event logic as defined in the state machine.
PROCEDURE Release_Blocked__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'ReleaseBlocked', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Release_Blocked__;


-- Set_Blocked__
--   Executes the SetBlocked event logic as defined in the state machine.
PROCEDURE Set_Blocked__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetBlocked', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Blocked__;


-- Set_Cancelled__
--   Executes the SetCancelled event logic as defined in the state machine.
PROCEDURE Set_Cancelled__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetCancelled', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Cancelled__;


-- Set_Line_Cancelled__
--   Executes the SetLineCancelled event logic as defined in the state machine.
PROCEDURE Set_Line_Cancelled__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineCancelled', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Cancelled__;


-- Set_Line_Qty_Assigned__
--   Executes the SetLineQtyAssigned event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Assigned__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyAssigned', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Assigned__;


-- Set_Line_Qty_Confirmeddiff__
--   Executes the SetLineQtyConfirmeddiff event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Confirmeddiff__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyConfirmeddiff', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Confirmeddiff__;


-- Set_Line_Qty_Invoiced__
--   Executes the SetLineQtyInvoiced event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Invoiced__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyInvoiced', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Invoiced__;


-- Set_Line_Qty_Picked__
--   Executes the SetLineQtyPicked event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Picked__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyPicked', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Picked__;


-- Set_Line_Qty_Shipdiff__
--   Executes the SetLineQtyShipdiff event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Shipdiff__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyShipdiff', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Shipdiff__;


-- Set_Line_Qty_Shipped__
--   Executes the SetLineQtyShipped event logic as defined in the state machine.
PROCEDURE Set_Line_Qty_Shipped__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineQtyShipped', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Qty_Shipped__;


-- Set_Line_Uninvoiced__
--   Executes the SetLineUninvoiced event logic as defined in the state machine.
PROCEDURE Set_Line_Uninvoiced__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetLineUninvoiced', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Line_Uninvoiced__;


-- Set_Released__
--   Executes the SetReleased event logic as defined in the state machine.
PROCEDURE Set_Released__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetReleased', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Released__;


-- Set_Rent_Line_Completed__
--   Executes the SetRentLineCompleted event logic as defined in the state machine.
PROCEDURE Set_Rent_Line_Completed__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetRentLineCompleted', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Rent_Line_Completed__;


-- Set_Rent_Line_Reopened__
--   Executes the SetRentLineReopened event logic as defined in the state machine.
PROCEDURE Set_Rent_Line_Reopened__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'SetRentLineReopened', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Set_Rent_Line_Reopened__;


-- Undo_Line_Delivery__
--   Executes the UndoLineDelivery event logic as defined in the state machine.
PROCEDURE Undo_Line_Delivery__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ customer_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'UndoLineDelivery', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Undo_Line_Delivery__;



-------------------- COMPLEX STRUCTURE METHODS ------------------------------------

-------------------- FOUNDATION1 METHODS ------------------------------------


-- Language_Refreshed
--   Framework method that updates translations to a new language.
@UncheckedAccess
PROCEDURE Language_Refreshed
IS
BEGIN
   Domain_SYS.Language_Refreshed(lu_name_, Get_Client_Values___, Get_Db_Values___, 'STATE');
END Language_Refreshed;


-- Init
--   Framework method that initializes this package.
@UncheckedAccess
PROCEDURE Init
IS
BEGIN
   Domain_SYS.Load_State(lu_name_, Get_Client_Values___, Get_Db_Values___);
END Init;