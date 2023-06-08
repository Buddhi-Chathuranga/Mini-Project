-----------------------------------------------------------------------------
--
--  Logical unit: RebatePeriodicAggLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210127  RavDlk   SC2020R1-12347, Removed unnecessary packing and unpacking of attrubute string in New and Set_Invoice_Id
--  170208  AmPalk   STRMF-6864, Modified New to receive line_no as an IN parameter. 
--  170131  ThImlk   STRMF-9389, Modified the method New() to add parameters, invoice_curr_amount and invoice_gross_curr_amount 
--  170131           to handle when multiple currencies used in company, customer order and rebate agreement. 
--  170110  ThImlk   STRMF-8964, Modified the method New() to add parameters, invoiced_quantity, net_weight and net_volume.
--  170105  ThImlk   STRMF-8400, Modified the method New() to add parameters, periodic_rebate_amount and rebate_cost_amount.
--  161116  ThImlk   STRMF-7700, Modified the method New() to add the parameter, Part_No.
--  130212  ShKolk   Added column invoice_gross_amount.
--  110823  NWeelk   Bug 96116, Made columns REBATE_RATE and REBATE_COST_RATE nullable.
--  100421  ChFolk   Made tax_code a nullable column.
--  080505  AmPalk   Made sales_part_rebate_group and rebate_cost_amount public attributes.
--  080228  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------




-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   aggregation_no_            IN NUMBER,
   line_no_                 IN NUMBER,
   hierarchy_id_              IN VARCHAR2,
   customer_level_            IN NUMBER,
   sales_part_rebate_group_   IN VARCHAR2,
   assortment_id_             IN VARCHAR2,
   assortment_node_id_        IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   rebate_type_               IN VARCHAR2,
   tax_code_                  IN VARCHAR2,
   rebate_rate_               IN NUMBER,
   rebate_cost_rate_          IN NUMBER,
   total_rebate_amount_       IN NUMBER,
   total_rebate_cost_amount_  IN NUMBER,
   invoice_amount_            IN NUMBER,
   invoice_gross_amount_      IN NUMBER,
   periodic_rebate_amount_    IN NUMBER,
   rebate_cost_amount_        IN NUMBER,
   invoiced_qty_              IN NUMBER,
   net_weight_                IN NUMBER,
   net_volume_                IN NUMBER,
   invoice_curr_amount_       IN NUMBER,
   invoice_gross_curr_amount_ IN NUMBER)
IS
   newrec_     REBATE_PERIODIC_AGG_LINE_TAB%ROWTYPE;
BEGIN
   newrec_.aggregation_no            := aggregation_no_;
   newrec_.line_no                   := line_no_;
   newrec_.hierarchy_id              := hierarchy_id_;
   newrec_.customer_level            := customer_level_;
   newrec_.sales_part_rebate_group   := sales_part_rebate_group_;
   newrec_.assortment_id             := assortment_id_;
   newrec_.assortment_node_id        := assortment_node_id_;
   newrec_.part_no                   := part_no_;
   newrec_.rebate_type               := rebate_type_;
   newrec_.rebate_rate               := rebate_rate_;
   newrec_.total_rebate_amount       := total_rebate_amount_;
   newrec_.tax_code                  := tax_code_;
   newrec_.rebate_cost_rate          := rebate_cost_rate_;
   newrec_.total_rebate_cost_amount  := total_rebate_cost_amount_;
   newrec_.invoice_amount            := invoice_amount_;
   newrec_.invoice_gross_amount      := invoice_gross_amount_;
   newrec_.periodic_rebate_amount    := periodic_rebate_amount_;
   newrec_.rebate_cost_amount        := rebate_cost_amount_;
   newrec_.invoiced_quantity         := invoiced_qty_;
   newrec_.net_weight                := net_weight_;
   newrec_.net_volume                := net_volume_;
   newrec_.invoice_curr_amount       := invoice_curr_amount_;
   newrec_.invoice_gross_curr_amount := invoice_gross_curr_amount_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Chk_Multiple_Tax_In_Aggr_Lines (
   aggregation_no_ IN NUMBER ) RETURN VARCHAR2
IS
   is_multiple_tax_ VARCHAR2(5);
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM REBATE_PERIODIC_AGG_LINE_TAB t
      WHERE t.aggregation_no = aggregation_no_
      AND   t.tax_code IS NULL
      AND   t.invoice_amount != t.invoice_gross_amount;
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

