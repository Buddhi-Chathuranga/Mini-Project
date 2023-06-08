-----------------------------------------------------------------------------
--
--  Logical unit: RebateFinalAggLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170208  AmPalk   STRMF-6864, Modified New to receive line_no as an IN parameter. 
--  170131  ThImlk   STRMF-9389, Modified the method New() to add parameters, inv_line_curr_amount and inv_line_gross_curr_amount, 
--  170131           to handle when multiple currencies used in company, customer order and rebate agreement. 
--  161118  RaKalk   STRMF-7712, Added Part No Column
--  160329  NiDalk   Bug 127211, Added remaining_cost column.
--  131113  RoJalk   Hooks implementation - refactor files.
--  130212  ShKolk   Added column invoice_line_gross_amount.
--  080604  JeLise   Added Get methods.
--  080602  JeLise   Added method Get_Sales_Part_Rebate_Group.
--  080530  JeLise   Added method Get_Total_Amount_To_Invoice.
--  080415  JeLise   Changed parameters in method New.
--  080411  JeLise   Removed rebate_cost_rate and rebate_cost_amount and added amount_to_invoice.
--  080409  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE New (
   aggregation_no_               IN NUMBER,
   line_no_                   IN NUMBER,
   hierarchy_id_                 IN VARCHAR2,
   customer_level_               IN NUMBER,
   sales_part_rebate_group_      IN VARCHAR2,
   assortment_id_                IN VARCHAR2,
   assortment_node_id_           IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   rebate_type_                  IN VARCHAR2,
   tax_code_                     IN VARCHAR2,
   final_rebate_rate_            IN NUMBER,
   final_rebate_amount_          IN NUMBER,
   invoiced_rebate_amount_       IN NUMBER,
   invoice_line_amount_          IN NUMBER,
   invoice_line_gross_amount_    IN NUMBER,
   inv_line_curr_amount_         IN NUMBER,
   inv_line_gross_curr_amount_   IN NUMBER,
   amount_to_invoice_            IN NUMBER,
   remaining_cost_               IN NUMBER DEFAULT NULL)
IS
   objid_      REBATE_FINAL_AGG_LINE.objid%TYPE;
   objversion_ REBATE_FINAL_AGG_LINE.objversion%TYPE;
   newrec_     REBATE_FINAL_AGG_LINE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('AGGREGATION_NO', aggregation_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('HIERARCHY_ID', hierarchy_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', customer_level_, attr_);
   Client_SYS.Add_To_Attr('SALES_PART_REBATE_GROUP', sales_part_rebate_group_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID', assortment_node_id_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('REBATE_TYPE', rebate_type_, attr_);
   Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   Client_SYS.Add_To_Attr('FINAL_REBATE_RATE', final_rebate_rate_, attr_);
   Client_SYS.Add_To_Attr('FINAL_REBATE_AMOUNT', final_rebate_amount_, attr_);
   Client_SYS.Add_To_Attr('INVOICED_REBATE_AMOUNT', invoiced_rebate_amount_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_LINE_AMOUNT', invoice_line_amount_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_LINE_GROSS_AMOUNT', invoice_line_gross_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LINE_CURR_AMOUNT', inv_line_curr_amount_, attr_);
   Client_SYS.Add_To_Attr('INV_LINE_GROSS_CURR_AMOUNT', inv_line_gross_curr_amount_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_TO_INVOICE', amount_to_invoice_, attr_);
   Client_SYS.Add_To_Attr('REMAINING_COST', NVL(remaining_cost_, 0), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );
END New;


@UncheckedAccess
FUNCTION Get_Total_Amount_To_Invoice (
   aggregation_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ REBATE_FINAL_AGG_LINE_TAB.amount_to_invoice%TYPE;
   CURSOR get_attr IS
      SELECT SUM(amount_to_invoice)
      FROM REBATE_FINAL_AGG_LINE_TAB
      WHERE aggregation_no = aggregation_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Amount_To_Invoice;

@UncheckedAccess
FUNCTION Chk_Multiple_Tax_In_Aggr_Lines (
   aggregation_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_            NUMBER;
   is_multiple_tax_ VARCHAR2(5);
   CURSOR get_attr IS
      SELECT 1
      FROM REBATE_FINAL_AGG_LINE_TAB t
      WHERE t.aggregation_no = aggregation_no_
      AND   t.tax_code IS NULL
      AND   t.invoice_line_amount != t.invoice_line_gross_amount;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%NOTFOUND) THEN
      is_multiple_tax_ := 'FALSE';
   ELSE
      is_multiple_tax_ := 'TRUE';
   END IF;  
   CLOSE get_attr;
   RETURN is_multiple_tax_;
END Chk_Multiple_Tax_In_Aggr_Lines;

