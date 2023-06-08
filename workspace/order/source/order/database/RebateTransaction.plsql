-----------------------------------------------------------------------------
--
--  Logical unit: RebateTransaction
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170208  AmPalk   STRMF-6864, Passed in line number, release number and line item number to the New method. 
--  170131  ThImlk   STRMF-9389, Modified the method New() to add parameters, inv_line_sales_curr_amount and inv_lin_sale_gros_curr_amt 
--  170131           to handle when multiple currencies used in company, customer order and rebate agreement. 
--  170119  NiDalk   STRSC-3939, Removed use price including vat from rebate functionality.
--  170110  ThImlk   STRMF-8964, Modified the method New() to add parameters, invoiced_quantity, net_weight and net_volume.
--  131214  RoJalk   Hooks implementation - refactor files.
--  130211  ShKolk   Added inv_line_sales_gross_amount and use_price_incl_tax.
--  110713  MaMalk   Added the company finance filter to the base view.
--  100429  ChFolk   Made tax_code nullable to support sales taxes.
--  080616  JeLise   Added rma_no.
--  080611  JeLise   Moved call to Get_Transaction_Id___ from New to Insert___.
--  080609  JeLise   Added methods New and Get_Transaction_Id___.
--  080513  JeLise   Added invoice_id.
--  080508  KiSalk   Made sales_part_rebate_group and rebate_type public attributes.
--  080424  JeLise   Added part_no, period_aggregation_no, final_aggregation_no and removed incl_in_period_settlement
--  080424           and incl_in_final_settlement in the table. Also added methods Get_Incl_In_Period_Settlement and
--  080424           Get_Incl_In_Final_Settlement.
--  080411  JeLise   Added final_rebate_rate and final_rebate_amount.
--  080411  JeLise   Changed invoice_id Number to invoice_no Varchar2(50).
--  080222  JeLise   Removed method New and moved Create_Rebate_Transaction to RebateTransactionUtil.
--  080221  JeLise   Added sysdate in call to Rebate_Agreement_Receiver_API.Get_Active_Agreement in
--  080221           Create_Rebate_Transaction and added order_no.
--  080214  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Transaction_Id___ RETURN NUMBER
IS
   transaction_id_   NUMBER;
   CURSOR get_transaction_id IS
      SELECT rebate_transaction_id_seq.NEXTVAL
      FROM dual;
BEGIN
   OPEN get_transaction_id;
   FETCH get_transaction_id INTO transaction_id_;
   CLOSE get_transaction_id;
   RETURN transaction_id_;
END Get_Transaction_Id___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REBATE_TRANSACTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.transaction_id := Get_Transaction_Id___;
   Client_SYS.Add_To_Attr('TRANSACTION_ID', newrec_.transaction_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Incl_In_Period_Settlement (
   transaction_id_ IN NUMBER ) RETURN VARCHAR2
IS
   aggregation_no_   NUMBER;
   CURSOR get_aggregation_no IS
      SELECT period_aggregation_no
      FROM REBATE_TRANSACTION_TAB
      WHERE transaction_id = transaction_id_;
BEGIN
   OPEN get_aggregation_no;
   FETCH get_aggregation_no INTO aggregation_no_;
   CLOSE get_aggregation_no;
   IF aggregation_no_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Get_Incl_In_Period_Settlement;


@UncheckedAccess
FUNCTION Get_Incl_In_Final_Settlement (
   transaction_id_ IN NUMBER ) RETURN VARCHAR2
IS
   aggregation_no_   NUMBER;
   CURSOR get_aggregation_no IS
      SELECT final_aggregation_no
      FROM REBATE_TRANSACTION_TAB
      WHERE transaction_id = transaction_id_;
BEGIN
   OPEN get_aggregation_no;
   FETCH get_aggregation_no INTO aggregation_no_;
   CLOSE get_aggregation_no;
   IF aggregation_no_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Get_Incl_In_Final_Settlement;


PROCEDURE New (
   company_                     IN VARCHAR2,
   invoice_no_                  IN VARCHAR2,
   item_id_                     IN NUMBER,
   customer_no_                 IN VARCHAR2,
   hierarchy_id_                IN VARCHAR2,
   customer_level_              IN NUMBER,
   assortment_id_               IN VARCHAR2,
   assortment_node_id_          IN VARCHAR2,
   agreement_id_                IN VARCHAR2,
   agreement_type_db_           IN VARCHAR2,
   sales_part_rebate_group_     IN VARCHAR2,
   rebate_type_                 IN VARCHAR2,
   rebate_rate_                 IN NUMBER,
   total_rebate_amount_         IN NUMBER,
   rebate_cost_rate_            IN NUMBER,
   total_rebate_cost_amount_    IN NUMBER,
   inv_line_sales_amount_       IN NUMBER,
   inv_line_sales_gross_amount_ IN NUMBER,
   inv_line_sales_curr_amount_  IN NUMBER,
   inv_lin_sale_gros_curr_amt_  IN NUMBER,
   tax_code_                    IN VARCHAR2,
   transaction_date_            IN DATE,
   pos_                         IN NUMBER,
   contract_                    IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER, 
   part_no_                     IN VARCHAR2,
   sales_unit_meas_             IN VARCHAR2,
   invoice_id_                  IN NUMBER,
   rma_no_                      IN NUMBER,
   periodic_rebate_amount_      IN NUMBER,
   rebate_cost_amount_          IN NUMBER,
   invoiced_qty_                IN NUMBER,
   net_weight_                  IN NUMBER,
   net_volume_                  IN NUMBER)
IS
   attr_             VARCHAR2(2000);
   objid_            REBATE_TRANSACTION.objid%TYPE;
   objversion_       REBATE_TRANSACTION.objversion%TYPE;
   newrec_           REBATE_TRANSACTION_TAB%ROWTYPE;
   indrec_           Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_NO', invoice_no_, attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('HIERARCHY_ID', hierarchy_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', customer_level_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID', assortment_node_id_, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_TYPE_DB', agreement_type_db_, attr_);
   Client_SYS.Add_To_Attr('SALES_PART_REBATE_GROUP', sales_part_rebate_group_, attr_);
   Client_SYS.Add_To_Attr('REBATE_TYPE', rebate_type_, attr_);
   Client_SYS.Add_To_Attr('REBATE_RATE', rebate_rate_, attr_);
   Client_SYS.Add_To_Attr('TOTAL_REBATE_AMOUNT', total_rebate_amount_, attr_);
   Client_SYS.Add_To_Attr('REBATE_COST_RATE', rebate_cost_rate_, attr_);
   Client_SYS.Add_To_Attr('TOTAL_REBATE_COST_AMOUNT', total_rebate_cost_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LINE_SALES_AMOUNT', inv_line_sales_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LINE_SALES_GROSS_AMOUNT', inv_line_sales_gross_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LINE_SALES_CURR_AMOUNT', inv_line_sales_curr_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LIN_SALE_GROS_CURR_AMT', inv_lin_sale_gros_curr_amt_, attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_DATE', transaction_date_, attr_);
   Client_SYS.Add_To_Attr('POS', pos_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', sales_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   Client_SYS.Add_To_Attr('RMA_NO', rma_no_, attr_);
   Client_SYS.Add_To_Attr('PERIODIC_REBATE_AMOUNT', periodic_rebate_amount_, attr_);
   Client_SYS.Add_To_Attr('REBATE_COST_AMOUNT', rebate_cost_amount_, attr_);
   Client_SYS.Add_To_Attr('INVOICED_QUANTITY', invoiced_qty_, attr_);
   Client_SYS.Add_To_Attr('NET_WEIGHT', net_weight_, attr_);
   Client_SYS.Add_To_Attr('NET_VOLUME', net_volume_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );
END New;



