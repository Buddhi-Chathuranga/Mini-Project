-----------------------------------------------------------------------------
--
--  Logical unit: OrderLineStagedBilling
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201014  ApWilk  Bug 150558 (SCZ-11847), Bug 150558 (SCZ-7444), Added the method Check_Stages_To_Invoice__().
--  171124  MaEelk  STRSC-14333, Modified Insert___ and added old document texts to the copied staged billing line.
--  171124  MaEelk  STRSC-14333. Modified Copy_Stages_From_Co_Line and added parameter con_order_no_, copy_document_texts_ and copy_notes_. This will support
--  171122          copying staged billing lines even to a different customer order.
--  171106  RaVdlk  STRSC-14007, Added Raise_Approval_Type_Error___ procedure for the message constant NO_AUTO, Raise_Invoice_Block_Error___ procedure for ORD_LINE_INV_BLOCK, 
--                  and procedure Raise_OrdLine_Closed_Error___ for the constant ORD_LINE_CLOSED       
--  170124  JeeJlk  Bug 133724, Reversed the bug 122944.
--  160411  JeeJlk  Bug 128565, Modified Check_Insert___ to stop overiding user entered value for approval_type.
--  151009  MeAblk  Bug 124608, Modified Recalculate() in order to avoid getting staged billing line % over 100 when reducing the order line amount.
--  150706  Hecolk  KES-880, Cancelling Preliminary Staged Billing CO invoice 
--  150728  ChBnlk  Bug 122944, Modified Recalculate() by adding a new parameter amount_changed_ and deprecated the previous method.  
--  141112  Hiralk  PRFI-3398, Modified Recalculate() to pass the correct parameters for method calls.
--  131030  ChBnlk  Bug 113285, Modified Insert___() to fetch staged billing flag of the customer order line using
--  131030          Customer_Order_Line_API.Get_Staged_Billing_Db().
--  120815  HimRlk Added new column amount_incl_tax.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110818  GayDLK Bug 97928, Modified Unpack_Check_Insert___() and Recalculate() to correct the rounding error of newrec_.amount when automatically 
--  110818         retreiving values using the Staged billing template for final stage payment line.
--  110202  Nekolk  EANE-3744  added where clause to View ORDER_LINE_STAGED_BILLING.
--  100520  KRPELK Merge Rose Method Documentation.
--  091229  MaRalk Modified the state machine according to the new template.
--  090930  MaMalk Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090526  SuJalk Bug 83114, Modified NO_APPROVE_1 and NO_APPROVE_2 error messages to remove quoted state and formatted them.
--  090522  DaGulk Bug 81231, Modified method Recalculate to check line_total_ amount is zero, if so set new_percent_ to zero.
--  090522         This will avoid the error message 'Divisor Equal to Zero'.
--  090430  DaGulk Bug 81231, Remove error message 'The amount to approve must be greater than zero' from function Order_Line_State_Ok___.
--  081215  ThAylk Bug 74645, Modified method Recalculate, to add an info manipulation logic to both If and Else blocks 
--  081215         to avoid same info getting raised more than once.
--  081124  ThAylk Bug 74643, Modified method Recalculate, to use available_percent_ in IF conditions to avoid rounding mismatches.  
--  061127  Cpeilk Modified error message for stage billing when prepayments exists in Unpack_Check_Insert___.
--  061025  Cpeilk Modified Unpack_Check_Insert___ to restrict stage billing when prepayments exists.
--  050920  NaLrlk Removed unused variables.
--  050622  MaEelk Invoiced blocked lines were not allowed to have stage billing lines.
--  050622         Modified Unpack_Check_Insert___ and Unpack_Check_Update___ 
--  050511  ChJalk Bug 51183, Modified FUNCTION Order_Line_State_Ok___ to give an error message when trying to approve a line
--  050511         if the amount is 0. Modified PROCEDURE Recalculate to update the amount correctly when line_total is updated. 
--  050324  JoEd   Added check on order header's delivery confirmation setting.
--                 Not allowed to add new stages if Confirm Deliveries = true.
--                 Code cleanup.
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes-----------------------
--  031013  PrJalk Bug Fix 106224, Chagned incorrect General_Sys.Init_Method calls.
--  030911  MiKulk Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030902  ChBalk CR Merge 02. 
--  030827  NaWalk Performed Code Cleanup.
--  030821  GaSolk Performed CR Merge.
--  030609  NuFilk Added method Copy_Stages_From_Co_Line and Remove_Stage_Lines.
--  ********************************************CR Merge***************************************************** 
--  030729  UsRalk Merged SP4 changes to TAKEOFF code.
--  030707  ChFolk Reversed the changes that has been done for Advance Payment.
--  030317  SeKalk Bug 35989, Added Set_Invoiced without invoice_id as a parameter
--  030227  SuAmlk Code Review.
--  030108  JaBalk Bug 34420, If the available_percent is zero then remove all stage lines
--  030108         which are in Planned or Approved state to avoid the numeric/value error.
--  021212  JaBalk Bug 34420, Added an error message ORD_LINE_CLOSED to refrain from modifying stage billing line
--  021212         when order line is Invoiced/Closed or Cancelled in Unpack_Check_Insert___,Unpack_Check_Update___.
--  021209  JaBalk Bug 34420, Added Get_Total_Invoiced_Percentage.
--  020724  NaMolk Bug 31053, Modified the procedure Recalculate, in order to calculate the percentage correctly
--  020724         when the order quantity is updated.
--  000913  FBen  Added UNDEFINE.
--  000614  PaLj  Chnaged length of description from 50 to 35 characters
--  000419  PaLj  Corrected Init_Method Errors
--  000327  PaLj  Removed an error message(CHANGE_PRICE) from Recalculate.
--  000222  PaLj  Added oldrec to Create_Stages_From_Template
--  000219  PaLj  Changed Auto_Approve_Lines
--  000129  JoEd  Added error message constant to "The invoiced amount exceeds..."
--                message text.
--  991201  PaLj  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Order_Line_State_Ok___ (
   rec_ IN ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   ok_    NUMBER;
   ok2_   NUMBER;
   CURSOR check_order IS
      SELECT 1
      FROM customer_order_tab
      WHERE order_no = rec_.order_no
      AND rowstate NOT IN ('Planned', 'Quoted', 'Cancelled');
   CURSOR check_order_line IS
      SELECT 1
      FROM customer_order_line_tab
      WHERE order_no = rec_.order_no
      AND line_no = rec_.line_no
      AND rel_no = rec_.rel_no
      AND line_item_no = rec_.line_item_no
      AND rowstate NOT IN ('Cancelled', 'Quoted');
BEGIN
   OPEN check_order;
   FETCH check_order INTO ok_;
   CLOSE check_order;
   IF (ok_ = 1) THEN
      OPEN check_order_line;
      FETCH check_order_line INTO ok2_;
      CLOSE check_order_line;
      IF (ok2_ = 1) THEN
         RETURN TRUE;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NO_APPROVE_1: The stage cannot be approved when the order line status is Cancelled.');
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NO_APPROVE_2: The stage cannot be approved when the order status is Planned or Cancelled.');
   END IF;
END Order_Line_State_Ok___;


PROCEDURE Do_Approve___ (
   rec_  IN OUT ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   site_date_ DATE;
BEGIN
   site_date_ := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(rec_.order_no));
   Set_Date_Approved(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.stage, site_date_);
   Client_SYS.Add_To_Attr('APPROVAL_DATE', site_date_, attr_);
END Do_Approve___;


PROCEDURE Do_Remove_Approval___ (
   rec_  IN OUT ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   site_date_ DATE;
BEGIN
   site_date_ := NULL;
   Set_Date_Approved(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.stage, site_date_);
   Client_SYS.Add_To_Attr('APPROVAL_DATE', site_date_, attr_);
END Do_Remove_Approval___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('APPROVAL_TYPE', Staged_Billing_Approval_API.Decode('MANUAL'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   old_note_id_ NUMBER; 
BEGIN
   newrec_.company := Site_API.Get_Company(Customer_Order_API.Get_Contract(newrec_.order_no));
   old_note_id_    := newrec_.note_id;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   IF (old_note_id_ IS NOT NULL) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;

   Client_SYS.Set_Item_Value('COMPANY', newrec_.company, attr_);
   Client_SYS.Set_Item_Value('NOTE_ID', newrec_.note_id, attr_);

   IF ( (newrec_.milestone_id IS NULL) AND (newrec_.approval_type = 'AUTOMATIC') ) THEN
      Raise_Approval_Type_Error___();
   END IF;

   super(objid_, objversion_, newrec_, attr_);
   IF Customer_Order_Line_API.Get_Staged_Billing_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 'NOT STAGED BILLING' THEN
      Customer_Order_Line_API.Modify_Staged_Billing(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, 'STAGED BILLING');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ( (newrec_.milestone_id IS NULL) AND (newrec_.approval_type = 'AUTOMATIC') ) THEN
      Raise_Approval_Type_Error___();
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.rowstate NOT IN ('Planned')) THEN
      Error_SYS.Record_General(lu_name_, 'NO_REMOVE: The staged billing line may not be removed!');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE )
IS
   number_of_rows_ NUMBER;

   CURSOR empty IS
      SELECT count(*)
      FROM  ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = remrec_.order_no
      AND   line_no = remrec_.line_no
      AND   rel_no = remrec_.rel_no
      AND   line_item_no = remrec_.line_item_no;
BEGIN
   super(objid_, remrec_);

   OPEN empty;
   FETCH empty INTO number_of_rows_;
   CLOSE empty;

   IF (number_of_rows_ = 0) THEN
      Customer_Order_Line_API.Modify_Staged_Billing(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, 'NOT STAGED BILLING');
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_line_staged_billing_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(4000);
   rounding_                   NUMBER;
   head_fetched_               BOOLEAN := FALSE;
   headrec_                    Customer_Order_API.Public_Rec;
   total_sum_amount_           NUMBER := 0;    
   total_sum_amount_incl_tax_  NUMBER := 0;   
   total_sum_percentage_       NUMBER := 0;
   tmp_sum_percentage_         NUMBER;
   tmp_sum_amount_             NUMBER;
   tmp_sum_amount_incl_tax_    NUMBER;
   total_order_line_cost_      NUMBER;
   total_order_line_incl_tax_  NUMBER;
BEGIN
   IF (indrec_.approval_type IS NULL) THEN 
      newrec_.approval_type := 'MANUAL';
   END IF;
   
   IF (indrec_.amount) THEN
      headrec_ := Customer_Order_API.Get(newrec_.order_no);
      head_fetched_ := TRUE;
      rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(headrec_.contract), headrec_.currency_code);
      newrec_.amount := ROUND(newrec_.amount, rounding_);
   END IF;
     
   IF (indrec_.amount_incl_tax) THEN
      headrec_ := Customer_Order_API.Get(newrec_.order_no);
      head_fetched_ := TRUE;
      rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(headrec_.contract), headrec_.currency_code);
      newrec_.amount_incl_tax := ROUND( newrec_.amount_incl_tax , rounding_);
   END IF;
   
   IF (newrec_.stage IS NULL) THEN
     newrec_.stage := Get_Next_Stage(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   tmp_sum_percentage_    := Get_Summed_Percent__(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   tmp_sum_amount_        := Get_Summed_Amount__(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   tmp_sum_amount_incl_tax_ := Get_Summed_Amount_Incl_Tax__(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   total_sum_percentage_  := tmp_sum_percentage_ + newrec_.total_percentage; 

   IF (total_sum_percentage_ = 100) THEN 
      total_sum_amount_incl_tax_ := tmp_sum_amount_incl_tax_ + newrec_.amount_incl_tax;
      total_sum_amount_          := tmp_sum_amount_ + newrec_.amount; 
      total_order_line_incl_tax_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      total_order_line_cost_     := Customer_Order_Line_API.Get_Sale_Price_Total(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      
      IF NOT head_fetched_ THEN
         headrec_ := Customer_Order_API.Get(newrec_.order_no);
         head_fetched_ := TRUE;
         rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(headrec_.contract), headrec_.currency_code);
      END IF;
      
      IF (total_order_line_cost_ != total_sum_amount_) THEN
         newrec_.amount          := total_order_line_cost_ - tmp_sum_amount_;  
         newrec_.amount          := ROUND(newrec_.amount, rounding_);
      END IF;

      IF (total_order_line_incl_tax_ != total_sum_amount_incl_tax_) THEN
         newrec_.amount_incl_tax := total_order_line_incl_tax_ - tmp_sum_amount_incl_tax_;  
         newrec_.amount_incl_tax := ROUND(newrec_.amount_incl_tax, rounding_);
      END IF; 
   END IF;
   
   super(newrec_, indrec_, attr_);

   -- order header (incl. confirm flag) is fetched for amount rounding
   IF NOT head_fetched_ THEN
      headrec_.confirm_deliveries := Customer_Order_API.Get_Confirm_Deliveries_Db(newrec_.order_no);
   END IF;

   IF (headrec_.confirm_deliveries = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'NO_NEW_STAGES: No changes may be made when the order uses Delivery Confirmation.');
   END IF;
   IF (Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IN ('Invoiced', 'Cancelled')) THEN
      Raise_OrdLine_Closed_Error___();
   END IF;

   IF (Customer_Order_Line_API.Get_Blocked_For_Invoicing_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 'TRUE') THEN
      Raise_Invoice_Block_Error___();
   END IF;
   
   --Check for prepayment exists before stage billing is entered for a Customer Order line.
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(newrec_.order_no) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXIST: The Required Prepayment amount exists. Cannot enter staged billing lines for this customer order.');
   END IF;

   Client_SYS.Add_To_Attr('STAGE', newrec_.stage, attr_);
   Client_SYS.Add_To_Attr('AMOUNT', newrec_.amount, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_INCL_TAX', newrec_.amount_incl_tax, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_line_staged_billing_tab%ROWTYPE,
   newrec_ IN OUT order_line_staged_billing_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   currency_code_ VARCHAR2(3);
   rounding_      NUMBER;
BEGIN
   IF (indrec_.amount AND (newrec_.amount IS NOT NULL))THEN
      currency_code_ := Customer_Order_API.Get_Currency_Code(newrec_.order_no);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(newrec_.company, currency_code_);
      newrec_.amount := ROUND(newrec_.amount, rounding_);      
   END IF;
   
   IF (indrec_.amount_incl_tax AND (newrec_.amount_incl_tax IS NOT NULL)) THEN
      Currency_code_ := Customer_Order_API.Get_Currency_Code(newrec_.order_no);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(newrec_.company, currency_code_);
      newrec_.amount_incl_tax := ROUND(newrec_.amount_incl_tax, rounding_);     
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);

   IF (Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IN ('Invoiced', 'Cancelled')) THEN
      Raise_OrdLine_Closed_Error___();
   END IF;

   IF (Customer_Order_Line_API.Get_Blocked_For_Invoicing_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 'TRUE') THEN
      Raise_Invoice_Block_Error___();
   END IF;
   
   IF newrec_.rowstate = 'Invoiced' THEN
      Error_SYS.Record_General(lu_name_, 'EDIT_INVOICED: The existing stage is invoiced and may not be changed');
   END IF;
   
   Client_SYS.Add_To_Attr('AMOUNT', newrec_.amount, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_INCL_TAX', newrec_.amount_incl_tax, attr_);
END Check_Update___;

PROCEDURE Raise_OrdLine_Closed_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'ORD_LINE_CLOSED: No changes may be made when the order line status is Invoiced/Closed or Cancelled');
END Raise_OrdLine_Closed_Error___;

PROCEDURE Raise_Invoice_Block_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'ORD_LINE_INV_BLOCK: Staged Billing cannot be used for Invoice Blocked Customer Order lines');
END Raise_Invoice_Block_Error___;

PROCEDURE Raise_Approval_Type_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NO_AUTO: Automatic approval type can not be chosen without a milestone connection!');
END Raise_Approval_Type_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Summed_Amount__
--   Returns the summed amount of all stages on this order line
@UncheckedAccess
FUNCTION Get_Summed_Amount__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER   ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR sum_amount IS
      SELECT SUM(amount) FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no   = order_no_
      AND    line_no   = line_no_
      AND     rel_no   = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   OPEN sum_amount;
   FETCH sum_amount INTO temp_;
   CLOSE sum_amount;
   RETURN temp_;
END Get_Summed_Amount__;


-- Get_Summed_Amount_Incl_Tax__
--   Returns the summed amount_incl_tax of all stages on this order line
@UncheckedAccess
FUNCTION Get_Summed_Amount_Incl_Tax__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER   ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR sum_amount IS
      SELECT SUM(amount_incl_tax) 
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN sum_amount;
   FETCH sum_amount INTO temp_;
   CLOSE sum_amount;
   RETURN temp_;
END Get_Summed_Amount_Incl_Tax__;


-- Get_Summed_Percent__
--   Returns the summed percent of all stages on this order line
@UncheckedAccess
FUNCTION Get_Summed_Percent__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER   ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR sum_percent IS
      SELECT SUM(total_percentage) FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no   = order_no_
      AND    line_no   = line_no_
      AND     rel_no   = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   OPEN sum_percent;
   FETCH sum_percent INTO temp_;
   CLOSE sum_percent;
   RETURN temp_;
END Get_Summed_Percent__;

PROCEDURE Check_Stages_To_Invoice__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2 DEFAULT NULL,
   rel_no_       IN VARCHAR2 DEFAULT NULL,
   line_item_no_ IN NUMBER DEFAULT NULL ) 
IS
   dummy_  NUMBER;
   CURSOR open_stages IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND rowstate  IN ('Approved', 'Planned');
      
   CURSOR open_stages_per_line IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate  IN ('Approved', 'Planned');      
BEGIN
   IF line_no_ IS NULL THEN
      OPEN open_stages;
      FETCH open_stages INTO dummy_;
      IF(open_stages%FOUND)THEN
         CLOSE open_stages;
         Error_SYS.Record_General(lu_name_, 'OPENHEADERSTAGE: The order still has approved/planned stages. Please check and make sure that all valid stages are invoiced before closing!');
      END IF;
   ELSE
      OPEN open_stages_per_line;
      FETCH open_stages_per_line INTO dummy_;
      IF(open_stages_per_line%FOUND)THEN
         CLOSE open_stages_per_line;
         Error_SYS.Record_General(lu_name_, 'OPENLINESTAGE: The order line still has approved/planned stages. Please check and make sure that all valid stages are invoiced before closing!');
      END IF;
   END IF;
END Check_Stages_To_Invoice__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Auto_Approve_Lines
--   Approves the payment profile if the ApprovalType is auto approval and
--   the status is planned for the Stage.
PROCEDURE Auto_Approve_Lines (
   milestone_id_  IN VARCHAR2,
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   approval_date_ IN DATE )
IS
   info_ VARCHAR2(2000);
   attr_ VARCHAR2(2000);

   CURSOR get_id_version IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion, stage
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE approval_type = 'AUTOMATIC'
      AND   rowstate = 'Planned'
      AND   order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   milestone_id = milestone_id_;
BEGIN
   FOR rec_ IN get_id_version LOOP
      Approve__(info_, rec_.objid, rec_.objversion, attr_, 'DO');
      IF approval_date_ IS NOT NULL THEN
         Set_Date_Approved(
         order_no_, line_no_, rel_no_, line_item_no_, rec_.stage, approval_date_);
      END IF;
   END LOOP;
END Auto_Approve_Lines;


-- Set_Date_Approved
--   Set the approval date for the stage
PROCEDURE Set_Date_Approved (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   stage_         IN NUMBER,
   approval_date_ IN DATE )
IS
   objid_      ORDER_LINE_STAGED_BILLING.objid%TYPE;
   objversion_ ORDER_LINE_STAGED_BILLING.objversion%TYPE;
   oldrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   newrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   --Set the date_approved.
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('APPROVAL_DATE', approval_date_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, stage_ );
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Date_Approved;


-- Order_Uses_Stage_Billing
--   Decide whether the order is having staged billing or not.
@UncheckedAccess
FUNCTION Order_Uses_Stage_Billing (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   order_found_ NUMBER;
   CURSOR find_order IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN find_order;
   FETCH find_order INTO order_found_;
   IF  (find_order%NOTFOUND) THEN
      order_found_ := 0;
   END IF;
   CLOSE find_order;
   RETURN order_found_;
END Order_Uses_Stage_Billing;


-- Get_Percent_Per_Order_Line
--   Gets the Percentage for a Staged Billing Line
@UncheckedAccess
FUNCTION Get_Percent_Per_Order_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   percentage_ NUMBER;
   CURSOR get_sum IS
      SELECT SUM(total_percentage)
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   OPEN get_sum;
   FETCH get_sum INTO percentage_;
   CLOSE get_sum;
   RETURN percentage_;
END Get_Percent_Per_Order_Line;


-- Set_Invoiced
--   When there is a invoice created for a stage, the staged billing line
--   is set to 'Invoiced'
--   Added this method to set the stage to Invoiced state for zero valued
--   orders without setting the invoice_id
PROCEDURE Set_Invoiced (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   stage_        IN NUMBER,
   invoice_id_   IN NUMBER )
IS
   newrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   oldrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_);
   newrec_ := oldrec_;
   newrec_.invoice_id   := invoice_id_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, stage_);
   Set_Invoiced__(info_, objid_, objversion_, attr_, 'DO');
END Set_Invoiced;


-- Set_Invoiced
--   When there is a invoice created for a stage, the staged billing line
--   is set to 'Invoiced'
--   Added this method to set the stage to Invoiced state for zero valued
--   orders without setting the invoice_id
PROCEDURE Set_Invoiced (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   stage_        IN NUMBER )
IS
   newrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   oldrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_);
   newrec_ := oldrec_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, stage_);
   Set_Invoiced__(info_, objid_, objversion_, attr_, 'DO');
END Set_Invoiced;


-- Set_Uninvoiced
-- When an invoice related to a stage is cancelled, the Staged Billing Line is set back to 'Approved' state.
PROCEDURE Set_Uninvoiced (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   stage_        IN NUMBER )
IS
   newrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   oldrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_);
   newrec_ := oldrec_;
   newrec_.invoice_id   := NULL;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, stage_);
   Set_Uninvoiced__(info_, objid_, objversion_, attr_, 'DO');
END Set_Uninvoiced;


-- Recalculate
--   This procedure recalculates the percentage and amount on the stages
--   when the order line total amount has changed.
PROCEDURE Recalculate (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   line_total_            IN NUMBER,
   old_line_total_        IN NUMBER,
   line_gross_            IN NUMBER,
   old_line_gross_        IN NUMBER,
   new_qty_               IN NUMBER,
   old_qty_               IN NUMBER,
   use_price_incl_tax_db_ IN VARCHAR2)
IS
   CURSOR get_first_stage IS
      SELECT stage
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;

   CURSOR get_invoiced_sum IS
      SELECT SUM(amount), SUM(amount_incl_tax)
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate = 'Invoiced';

   CURSOR get_sum IS
      SELECT SUM(amount), SUM(amount_incl_tax), SUM(total_percentage)
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;

   CURSOR get_stages IS
      SELECT stage, total_percentage, amount, amount_incl_tax, rowstate
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no   = order_no_
      AND line_no      = line_no_
      AND rel_no       = rel_no_
      AND line_item_no = line_item_no_;

   new_amount_                   NUMBER := 0;
   new_amount_incl_tax_          NUMBER := 0;
   new_percent_                  NUMBER;
   invoiced_sum_                 NUMBER;
   invoiced_sum_incl_tax_        NUMBER;
   old_sum_                      NUMBER;
   old_sum_incl_tax_             NUMBER;
   summed_amount_                NUMBER := 0;
   summed_amount_incl_tax_       NUMBER := 0;
   summed_percent_               NUMBER := 0;
   old_summed_percent_           NUMBER := 0;
   available_percent_            NUMBER := 0;
   old_not_invoiced_percent_sum_ NUMBER := 0;
   err_                          NUMBER := 0;
   exit_                         NUMBER;

   newrec_                       ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   oldrec_                       ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   attr_                         VARCHAR2(32000) := NULL;
   objid_                        VARCHAR2(2000);
   objversion_                   VARCHAR2(2000);

   currency_code_                VARCHAR2(3);
   rounding_                     NUMBER;
   first_stage_                  NUMBER;
   deleted_stage_                BOOLEAN:=FALSE;
   current_info_                 VARCHAR2(32000);
   source_msg_text_              VARCHAR2(2000) := NULL;
   len_msg_text_                 NUMBER:= 0;
   total_order_line_cost_        NUMBER;
   total_order_line_incl_tax_    NUMBER;
   total_sum_amount_             NUMBER := 0;                                          
   total_sum_percentage_         NUMBER := 0;
   total_sum_amount_incl_tax_    NUMBER := 0;
   old_total_percentage_         NUMBER := 0;
   company_                      VARCHAR2(20);
   line_tax_dom_amount_          NUMBER; 
   line_net_dom_amount_          NUMBER; 
   line_gross_dom_amount_        NUMBER; 
   line_tax_curr_amount_         NUMBER;
BEGIN

   Trace_SYS.Field('order_no_ ',order_no_);
   Trace_SYS.Field('line_no_',line_no_);
   Trace_SYS.Field('rel_no_',rel_no_);
   Trace_SYS.Field('line_item_no_',line_item_no_);
   Trace_SYS.Field('line_total_ ',line_total_);
   Trace_SYS.Field('old_line_total_ ',old_line_total_ );
   Trace_SYS.Field('line_gross_ ', line_gross_);
   Trace_SYS.Field('old_line_gross_ ',old_line_gross_);
   Trace_SYS.Field('new_qty_ ',new_qty_);
   Trace_SYS.Field('old_qty_ ',old_qty_);
   Trace_SYS.Field('use_price_incl_tax_db_ ', use_price_incl_tax_db_);

   OPEN get_invoiced_sum;
   FETCH get_invoiced_sum INTO invoiced_sum_, invoiced_sum_incl_tax_;
   CLOSE get_invoiced_sum;

   Trace_SYS.Field('invoiced_sum_ ',invoiced_sum_);

   OPEN get_sum;
   FETCH get_sum INTO old_sum_, old_sum_incl_tax_, old_total_percentage_;
   CLOSE get_sum;

   IF (line_total_ < invoiced_sum_) OR (line_gross_ < invoiced_sum_incl_tax_) THEN
      Error_SYS.Record_General(lu_name_, 'EXCEEDED_AMOUNT: The invoiced amount exceeds the new order line value!');
   ELSE

      OPEN get_first_stage;
      FETCH get_first_stage INTO first_stage_;
      CLOSE get_first_stage;

      currency_code_ := Customer_Order_API.Get_Currency_Code(order_no_);
      company_ := Get_Company(order_no_, line_no_, rel_no_, line_item_no_, first_stage_);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);     

      FOR stage_rec_ IN get_stages LOOP
         IF ((stage_rec_.rowstate = 'Invoiced')) THEN
            IF use_price_incl_tax_db_ = 'TRUE' THEN
               IF line_gross_ = 0 THEN
                  new_percent_ := 0;
               ELSE
                  new_percent_ := (stage_rec_.amount_incl_tax/line_gross_)*100;
               END IF;
               summed_amount_incl_tax_ := summed_amount_incl_tax_ + stage_rec_.amount_incl_tax;               
            ELSE
               IF line_total_ = 0 THEN
                  new_percent_ := 0;
               ELSE
                  new_percent_ := (stage_rec_.amount/line_total_)*100;
               END IF; 
               summed_amount_ := summed_amount_ + stage_rec_.amount;               
            END IF;
            Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                                    line_net_dom_amount_, 
                                                    line_gross_dom_amount_, 
                                                    line_tax_curr_amount_, 
                                                    summed_amount_, 
                                                    summed_amount_incl_tax_, 
                                                    company_, 
                                                    Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                    order_no_, 
                                                    line_no_, 
                                                    rel_no_, 
                                                    line_item_no_,
                                                    '*');
            -- UPDATE total_percentage --
            oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
            newrec_ := oldrec_;
            newrec_.total_percentage := new_percent_;            
            summed_percent_ := summed_percent_ + new_percent_;
            old_summed_percent_ := old_summed_percent_ + stage_rec_.total_percentage;
            Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
         END IF;
      END LOOP;
      available_percent_ := 100 - summed_percent_;
      -- No invoiced amount --> simple recalculation of amount
      IF summed_percent_ = 0 THEN
         FOR stage_rec_ IN get_stages LOOP
            IF stage_rec_.rowstate != 'Invoiced' THEN
               total_sum_percentage_  := summed_percent_ + stage_rec_.total_percentage; 
               new_amount_incl_tax_ := ROUND((line_gross_ * (stage_rec_.total_percentage / 100)), rounding_);
               new_amount_ := ROUND( (line_total_ * (stage_rec_.total_percentage / 100)), rounding_ );
               IF (total_sum_percentage_ = 100) THEN
                  IF use_price_incl_tax_db_ = 'TRUE' THEN                     
                     total_sum_amount_incl_tax_ := summed_amount_incl_tax_ +  new_amount_incl_tax_;
                     total_sum_amount_          := summed_amount_ + new_amount_; 
                     total_order_line_incl_tax_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, line_no_, rel_no_, line_item_no_);
                     total_order_line_cost_     := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, line_no_, rel_no_, line_item_no_);

                     IF (total_order_line_incl_tax_ != total_sum_amount_incl_tax_) THEN
                        new_amount_incl_tax_ := total_order_line_incl_tax_ - summed_amount_incl_tax_;
                     END IF;
                     IF (total_order_line_cost_ != total_sum_amount_) THEN
                        new_amount_ := total_order_line_cost_ - summed_amount_; 
                     END IF;                     
                  ELSE                     
                     total_sum_amount_          := summed_amount_ + new_amount_;
                     total_sum_amount_incl_tax_ := summed_amount_incl_tax_ +  new_amount_incl_tax_;                     
                     total_order_line_cost_     := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, line_no_, rel_no_, line_item_no_);
                     total_order_line_incl_tax_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, line_no_, rel_no_, line_item_no_);
                     IF (total_order_line_cost_ != total_sum_amount_) THEN
                        new_amount_ := total_order_line_cost_ - summed_amount_; 
                     END IF;
                     IF (total_order_line_incl_tax_ != total_sum_amount_incl_tax_) THEN
                        new_amount_incl_tax_ := total_order_line_incl_tax_ - summed_amount_incl_tax_;
                     END IF;                    
                  END IF;
               ELSE
                  Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                                          line_net_dom_amount_, 
                                                          line_gross_dom_amount_, 
                                                          line_tax_curr_amount_, 
                                                          new_amount_, 
                                                          new_amount_incl_tax_, 
                                                          company_, 
                                                          Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                          order_no_, 
                                                          line_no_, 
                                                          rel_no_, 
                                                          line_item_no_,
                                                          '*');
               END IF;
               -- UPDATE amount --
               oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
               newrec_ := oldrec_;
               newrec_.amount := new_amount_;
               newrec_.amount_incl_tax := new_amount_incl_tax_;
               summed_percent_ := summed_percent_ + stage_rec_.total_percentage;
               summed_amount_ := summed_amount_ + new_amount_;
               summed_amount_incl_tax_ := summed_amount_incl_tax_ + new_amount_incl_tax_;
               Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
            END IF;
         END LOOP;
      -- profile to cover total order line amount(i.e 100%). 
      ELSIF (old_total_percentage_ = 100) THEN
         available_percent_ := 100 - summed_percent_;
         old_not_invoiced_percent_sum_ := 100 - old_summed_percent_;
         FOR stage_rec_ IN get_stages LOOP
            IF (stage_rec_.rowstate != 'Invoiced') THEN
               oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
               newrec_ := oldrec_;
               -- Note: IF the available_percent is zero then remove all stage lines which are in Planned or Approved state
               IF (available_percent_ = 0) THEN
                  Get_Id_Version_By_Keys___ (objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
                  Delete___(objid_, oldrec_);
                  deleted_stage_:=TRUE;
               ELSE
                  new_percent_ := (stage_rec_.total_percentage / old_not_invoiced_percent_sum_) * available_percent_;
                  IF use_price_incl_tax_db_ = 'TRUE' THEN
                     new_amount_incl_tax_ := Round( (line_gross_ * (new_percent_ / 100)), rounding_ );                     
                  ELSE
                     new_amount_ := Round( (line_total_ * (new_percent_ / 100)), rounding_ );                     
                  END IF;
                  Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                                          line_net_dom_amount_, 
                                                          line_gross_dom_amount_, 
                                                          line_tax_curr_amount_, 
                                                          new_amount_, 
                                                          new_amount_incl_tax_, 
                                                          company_, 
                                                          Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                          order_no_, 
                                                          line_no_, 
                                                          rel_no_, 
                                                          line_item_no_,
                                                          '*');
                  -- Update amount AND total_percentage --
                  newrec_.amount := new_amount_;
                  newrec_.amount_incl_tax := new_amount_incl_tax_;
                  summed_amount_ := summed_amount_ + new_amount_;
                  summed_amount_incl_tax_ := summed_amount_incl_tax_ + new_amount_incl_tax_;
                  summed_percent_ := summed_percent_ + new_percent_;             
                  newrec_.total_percentage := new_percent_;
                  Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
               END IF;
            END IF;
         END LOOP;
      -- profile not to cover total order line amount(i.e less than 100%).   
      ELSIF (old_total_percentage_ != 100) THEN
         available_percent_ := 100 - summed_percent_;
         FOR stage_rec_ IN get_stages LOOP
            IF (stage_rec_.rowstate != 'Invoiced') THEN
               IF use_price_incl_tax_db_ = 'TRUE' THEN
                  new_percent_ := (stage_rec_.amount_incl_tax/line_gross_) *100;
                  new_amount_incl_tax_ := Round( (line_gross_ * (new_percent_ / 100)), rounding_ );                  
               ELSE
                  new_percent_ := (stage_rec_.amount/line_total_)*100;
                  new_amount_ := Round( (line_total_ * (new_percent_ / 100)), rounding_ );                  
               END IF;
               Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                                       line_net_dom_amount_, 
                                                       line_gross_dom_amount_, 
                                                       line_tax_curr_amount_, 
                                                       new_amount_, 
                                                       new_amount_incl_tax_, 
                                                       company_, 
                                                       Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                       order_no_, 
                                                       line_no_, 
                                                       rel_no_, 
                                                       line_item_no_,
                                                       '*');
               -- Update amount AND total_percentage --
               oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
               newrec_ := oldrec_;
               newrec_.amount := new_amount_;
               newrec_.amount_incl_tax := new_amount_incl_tax_;
               summed_percent_ := summed_percent_ + new_percent_;
               summed_amount_ := summed_amount_ + new_amount_;
               summed_amount_incl_tax_ := summed_amount_incl_tax_ + new_amount_incl_tax_;
               newrec_.total_percentage := new_percent_;
               Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
            END IF;
         END LOOP;
      END IF;

      IF ((old_line_total_ = old_sum_) AND (summed_amount_ != line_total_*(summed_percent_/100))) THEN
         Trace_SYS.Field('MISSING summed_amount_ ',summed_amount_);
         Trace_SYS.Field('MISSING line_total_ ',line_total_);
         Trace_SYS.Field('MISSING summed_amount_incl_tax_ ',summed_amount_incl_tax_);
         Trace_SYS.Field('MISSING line_gross_ ',line_gross_);
         IF use_price_incl_tax_db_ = 'TRUE' THEN
            err_ := line_gross_ - summed_amount_incl_tax_;
         ELSE
            err_ := line_total_ - summed_amount_;
         END IF;
         Trace_SYS.Field('MISSING err_ ',err_);
         exit_ := 0;
         FOR stage_rec_ IN get_stages LOOP
            IF stage_rec_.rowstate != 'Invoiced' THEN
               oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, stage_rec_.stage);
               newrec_ := oldrec_;
               Trace_SYS.Field('MISSING newrec_.amount',newrec_.amount);
               Trace_SYS.Field('MISSING newrec_.amount_incl_tax',newrec_.amount_incl_tax);
               IF use_price_incl_tax_db_ = 'TRUE' THEN
                  newrec_.amount_incl_tax := oldrec_.amount_incl_tax + err_;                  
               ELSE
                  newrec_.amount := oldrec_.amount + err_;                  
               END IF;
               Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                                       line_net_dom_amount_, 
                                                       line_gross_dom_amount_, 
                                                       line_tax_curr_amount_, 
                                                       newrec_.amount, 
                                                       newrec_.amount_incl_tax, 
                                                       company_, 
                                                       Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                       order_no_, 
                                                       line_no_, 
                                                       rel_no_, 
                                                       line_item_no_,
                                                       '*');
               Trace_SYS.Field('MISSING newrec_.amount',newrec_.amount);
               Trace_SYS.Field('MISSING newrec_.amount_incl_tax',newrec_.amount_incl_tax);
               Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
               exit_ := 1;
            END IF;
            EXIT WHEN (exit_ = 1);
         END LOOP;
      END IF;

     IF (summed_percent_ != 100) THEN
        Trace_SYS.Field('MISSING summed_percent_ ',summed_percent_);
     END IF;

   END IF; -- line_total_ < invoiced_sum_
   
   current_info_ := Customer_Order_Line_API.Get_Current_Info(); 
   -- Note: Added info to indicate some stages have been removed
   IF (deleted_stage_ = TRUE) THEN
      source_msg_text_ := Language_SYS.Translate_Msg_(lu_name_, 'REMOVESTAGES: The Staged Billing Profile has been recalculated and some stages which becomes zero percent have been removed to cover 100 percent!');
      source_msg_text_ := LTRIM(SUBSTR(source_msg_text_, INSTR(source_msg_text_, ':') + 1));
      len_msg_text_ := INSTR(current_info_, source_msg_text_);
      IF (len_msg_text_ IS NULL) OR (len_msg_text_= 0) THEN
         Client_SYS.Add_Info(lu_name_, 'REMOVESTAGES: The Staged Billing Profile has been recalculated and some stages which becomes zero percent have been removed to cover 100 percent!');
      END IF;
   ELSE
      source_msg_text_ := Language_SYS.Translate_Msg_(lu_name_, 'RECALC: The Staged Billing Profile has been recalculated! Please verify that the stages cover 100 percent of the order line total!');
      source_msg_text_ := LTRIM(SUBSTR(source_msg_text_, INSTR(source_msg_text_, ':') + 1));
      len_msg_text_ := INSTR(current_info_, source_msg_text_);
      IF (len_msg_text_ IS NULL) OR (len_msg_text_= 0) THEN
         Client_SYS.Add_Info(lu_name_, 'RECALC: The Staged Billing Profile has been recalculated! Please verify that the stages cover 100 percent of the order line total!');
      END IF;
   END IF;
END Recalculate;


-- Get_Next_Stage
--   This is used to get the next stage no for the particular order line.
@UncheckedAccess
FUNCTION Get_Next_Stage (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ORDER_LINE_STAGED_BILLING_TAB.stage%TYPE;
   CURSOR get_stage IS
      SELECT NVL(MAX(stage), 0)
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN get_stage;
   FETCH get_stage INTO temp_;
   CLOSE get_stage;
   temp_ := temp_ + 1;
   RETURN temp_;
END Get_Next_Stage;


-- Create_Stages_From_Template
--   This function creates new stages for each new order line. The stages
--   are copied from StagedBillingTemplate
PROCEDURE Create_Stages_From_Template (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   applicable_line_total_ IN NUMBER )
IS
   attr_             VARCHAR2(2000) := NULL;
   oldrec_           ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   newrec_           ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   amount_           NUMBER;
   headrec_          Customer_Order_API.Public_Rec;
   company_          VARCHAR2(20);
   rounding_         NUMBER;
   amount_incl_tax_  NUMBER;
   indrec_           Indicator_Rec;
   line_tax_dom_amount_   NUMBER; 
   line_net_dom_amount_   NUMBER; 
   line_gross_dom_amount_ NUMBER; 
   line_tax_curr_amount_  NUMBER;

   CURSOR get_template IS
   SELECT stage,
          description,
          total_percentage,
          expected_approval_date
   FROM STAGED_BILLING_TEMPLATE_TAB
   WHERE order_no = order_no_;
BEGIN
   headrec_ := Customer_Order_API.Get(order_no_);
   company_ := Site_API.Get_Company(headrec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, headrec_.currency_code);   

   FOR stagerec_ IN get_template LOOP
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('STAGE', stagerec_.stage, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', stagerec_.description, attr_);
      Client_SYS.Add_To_Attr('TOTAL_PERCENTAGE', stagerec_.total_percentage, attr_);
      IF (headrec_.use_price_incl_tax = 'TRUE') THEN
         amount_incl_tax_ := ROUND ((applicable_line_total_ * (stagerec_.total_percentage / 100)), rounding_);         
      ELSE
         amount_ := ROUND( (applicable_line_total_ * (stagerec_.total_percentage / 100) ), rounding_ );         
      END IF;
      Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                              line_net_dom_amount_, 
                                              line_gross_dom_amount_, 
                                              line_tax_curr_amount_, 
                                              amount_, 
                                              amount_incl_tax_, 
                                              company_, 
                                              Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                              order_no_, 
                                              line_no_, 
                                              rel_no_, 
                                              line_item_no_,
                                              '*');
      Client_SYS.Add_To_Attr('AMOUNT', amount_, attr_);
      Client_SYS.Add_To_Attr('AMOUNT_INCL_TAX', amount_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('EXPECTED_APPROVAL_DATE', stagerec_.expected_approval_date, attr_);
      Client_SYS.Add_To_Attr('APPROVAL_TYPE_DB', 'MANUAL', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Create_Stages_From_Template;


-- Get_Total_Invoiced_Percentage
--   Get the total percentage of invoiced stage billing lines
FUNCTION Get_Total_Invoiced_Percentage (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   tot_percentage_ NUMBER;
   CURSOR get_sum_invoiced_percentage IS
      SELECT SUM(total_percentage)
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   rowstate = 'Invoiced';
BEGIN
   OPEN get_sum_invoiced_percentage;
   FETCH get_sum_invoiced_percentage INTO tot_percentage_;
   CLOSE get_sum_invoiced_percentage;
   RETURN nvl(tot_percentage_,0);
END Get_Total_Invoiced_Percentage;


-- Copy_Stages_From_Co_Line
--   Copy stage line information from customer order line to a new customer order line.
PROCEDURE Copy_Stages_From_Co_Line (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   con_order_no_         IN VARCHAR2,   
   con_line_no_          IN VARCHAR2,
   con_rel_no_           IN VARCHAR2,
   con_line_item_no_     IN NUMBER,
   copy_document_texts_  IN BOOLEAN,
   copy_notes_           IN BOOLEAN )
IS
   attr_       VARCHAR2(2000) := NULL;
   oldrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   newrec_     ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_records IS
   SELECT *
   FROM ORDER_LINE_STAGED_BILLING_TAB
   WHERE order_no = con_order_no_
     AND line_no = con_line_no_
     AND rel_no  = con_rel_no_
     AND line_item_no = con_line_item_no_;
BEGIN
   FOR stagerec_ IN get_records LOOP
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('STAGE', stagerec_.stage, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', stagerec_.description, attr_);
      Client_SYS.Add_To_Attr('TOTAL_PERCENTAGE', stagerec_.total_percentage, attr_);
      Client_SYS.Add_To_Attr('AMOUNT', stagerec_.amount, attr_);
      Client_SYS.Add_To_Attr('AMOUNT_INCL_TAX', stagerec_.amount_incl_tax, attr_);
      Client_SYS.Add_To_Attr('APPROVAL_TYPE_DB', stagerec_.approval_type, attr_);
      Client_SYS.Add_To_Attr('MILESTONE_ID', stagerec_.milestone_id, attr_); 
      
      IF (order_no_ = con_order_no_) THEN
         Client_SYS.Add_To_Attr('EXPECTED_APPROVAL_DATE', stagerec_.expected_approval_date, attr_);
         Client_SYS.Add_To_Attr('APPROVAL_DATE', stagerec_.approval_date, attr_);
      END IF;
      
      IF (copy_document_texts_) THEN
         Client_SYS.Add_To_Attr('NOTE_ID', stagerec_.note_id, attr_);
      END IF;

      IF (copy_notes_) THEN
         Client_SYS.Add_To_Attr('NOTE_TEXT', stagerec_.note_text, attr_);
      END IF;      
      -- Do not Specify Invoice_ID or company for new Lines created
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_Stages_From_Co_Line;


-- Remove_Stage_Lines
--   Removes all stage lines connected to the specified customer order line
PROCEDURE Remove_Stage_Lines (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   remrec_  ORDER_LINE_STAGED_BILLING_TAB%ROWTYPE;
   CURSOR get_record IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   FOR stage_rec_ IN get_record LOOP 
      remrec_ := Lock_By_Id___( stage_rec_.objid , stage_rec_.objversion);
      Delete___(stage_rec_.objid, remrec_);
   END LOOP;
END Remove_Stage_Lines;


