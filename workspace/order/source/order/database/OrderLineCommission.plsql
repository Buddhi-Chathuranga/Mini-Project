-----------------------------------------------------------------------------
--
--  Logical unit: OrderLineCommission
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200607  LaThlk  Bug 148578(SCZ-4864), Modified the procedure Check_Total_Com_Amount__() by Adding commission_receiver_ as a default null parameter and
--  200607          adding it to the where clause of cursor get_all_commissions.
--  190930  DaZase  SCSPRING20-144, Added Raise_1_Com_Line_Error___ to solve MessageDefinitionValidation issue.
--  190408  KiSalk  Bug 147753(SCZ-4193), Changed cursor get_invoice_data of Get_Com_Receiver_Amount to fetch data even when creators_reference(order no) is null(e.g. collective invoices).
--  181021  BudKLK  Bug 144054, Modified the methods Cancel_Order_Commission_Lines() and Cancel() to change the size of the variables attr_ and info_ to avoid character string buffer too small error.
--  180831  DiKulk  Bug 136076, Added Set_Line_Exclude_Flag to handle the value for line_exclusion_flag.
--  180806  WaSaLK  Bug 142845, Modified Get_Com_Receiver_Amount() to retrieve relevant currency rate according to the invoice date if the calculation base is invoiced.
--  180202  RaVdlk  STRSC-16692, Documentation text of commssions for order lines was copied when 'Document Text' copy option is selected
--  171127  MaEelk  STRSC-12302, Added Copy_Manual_Commission_Lines to copy lines having value 'Manual' for the commission source.
--  160629  IzShlk  STRSC-1968, Removed obsolete Commission receiver active check from Check_Inser__ method and added data validity.
--  160310  NWeelk  STRLOC-236, Added method Has_Commission_Lines to return true if the specified order line has non cancelled commission lines.
--  150807  MAHPLK  KES-1211, Modified Create_Order_Commission_Lines() to return ORDER_LINE_COMMISSION_TAB%ROWTYPE.
--  150616  Hecolk  KES-538, Adding ability to cancel preliminary Customer Order Invoice
--  130712  ErFelk  Bug 111147, Modified Cancel_Order_Commission_Lines() by adding a call to procedure Create_Order_Com_Header().
--  111129  NipKlk  Bug 100111, Changed the error message NOT_USE_PERCENTAGE to be more convenient, Changed the view comment for FIXED_COMMISSION_AMOUNT to Updatable,
--  111129          Assigned the value_ to newrec_.fixed_commission_amount in Unpack_Check_Update___ method in IF statement for FIXED_COMMISSION_AMOUNT_DB.                                          
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110713  ChJalk  Added user_allowed_site filter to the base view and removed ORDER_LINE_COMMISSION_UIV. 
--  110302  PAWELK  EANE-3744 Modified the cursors to use ORDER_LINE_COMMISSION_TAB instead of the view, Added new view ORDER_LINE_COMMISSION_UIV.
--  110202  Nekolk  EANE-3744  added where clause to View ORDER_LINE_COMMISSION.
--  100520  KRPELK  Merge Rose Method Documentation.
--  091228  MaRalk  Modified the state machine according to the new template.
--  091104  MaRalk  Modified ORDER_LINE_COMMISSION - company, party_type column view comments. 
--  091027  MaRalk  Added dummy columns company, party_type to the view ORDER_LINE_COMMISSION and rollback the modifcation done to the view comment group_id.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  080521  SuJalk  Bug 73616, Modified the error message INVCOMAMOUNTINVALID to inform the user to recalculate the commission for the entire order line.
--  080421  MaMalk  Bug 72341, Modified Unpack_Check_Update___ to calculate the total commission amount when the commission percentage or
--  080421          the commission amount is changed for Invoiced based commission lines.
--  071022  NaLrlk  Bug 68466, Added procedure Check_Customer_Group__, used this procedure in Ref/Custom in column Group_Id view comment.
--  071022          Modified the server call check for Group_Id in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  070419  NiDalk  Modified Unpack_Check_Insert___ to set default value of Line_Exclude_Flag to 'TRUE'.
--  070123  NuVelk  Changed Get_Com_Receiver_Amount to consider the convertion_factor when calculating the commission in Receiver's currency. 
--  061018  IsWilk  Bug 59097, Added public attribute Line_Exclude_Flag. Modified methods Insert___, Unpack_Check_Insert___,
--  061018          Unpack_Check_Update___, Prepare_Insert___, Update___, Get and Copy_Commission_Lines.
--  061018          Added method Get_Line_Exclude_Flag.
--  060419  NaLrlk  Enlarge Customer - Changed variable definitions.
--  060410  IsWilk  Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  051006  SaRalk  Modified procedure Unpack_Check_Insert___.
--  050926  SaRalk  Modified procedures Unpack_Check_Insert___ and Change_Currency.
--  050920  MaGuse  Bug 53410. Modified method Check_Total_Com_Amount__, removed error messsage when commission < 0.
--  050920  NaLrlk  Removed unused variables.
--  050203  MaGuse  Bug 48250, Modified method Unpack_Check_Insert___ to prevent fixed commission lines from being entered on a cancelled order line.
--  041124  MaGuse  Bug 46197, Modified handling of corrections created when canceling order line. Modified
--  041124          method Cancel_Order_Commission_Lines. Added new default null parameter
--  041124          commission_line_source_ to method Create_Order_Commission_Line.
--  041124          Enabled handling of more than one open commission line at a time
--  041124          in a few specific scenarios. Modified methods Insert___ and Check_Open_Lines_Unicity__.
--  041124          Added check on commission_line_source in methods Unpack_Check_Insert___
--  041124          and Create_Order_Commission_Line. Added public attribute original_line_source_.
--  041124          Made commission_amount and commission_percentage not updateable
--  041124          when manually changing correction lines. Modified method Unpack_Check_Update___.
--  041124          Added new value 'Modified' to commission_line_source. Modified
--  041124          method Unpack_Check_Update___.
--  041124          Modified handling of commission agreement in method Unpack_Check_Insert___.
--  040220  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------------------13.3.0--------------------------------
--  031103  JaBalk  Call ID 107425, Modified the Connect_Fixed_To_Header__ not to select closed/cancelled fixed lines
--  031103          Removed the Check_Total_Com_Amount__ from Unpack_Check_Insert___, Unpack_Check_Update___
--  031103          Modified Check_Total_Com_Amount__.
--  031024  JaBalk  Call ID 107425, Removed the check for negative amount-AMOUNT_INVALID from Unpack_Check_insert___.
--  031010  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030916  JaBalk  Bug 37779, Changed the parameters and Restructured the method Check_Total_Com_Amount__()
--  030916          and removed some codes added to Bug 35402.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030902  ChBalk  CR Merge 02.
--  030819  UdGnlk  Performed CR Merge.
--  030610  NuFilk  Added method Copy_Commission_Lines.
--  **************** CR Merge *************************************************
--  030729  UsRalk  Merged SP4 code and TAKEOFF code.
--  030511  KaDilk  Bug 35402, Modified Get_Total_Due_Com_Amount, Check_Total_Com_Amount__, Unpack_Check_Update___,
--  030511          Unpack_Check_Insert___,Added Get_Sum_Due_Com_Amount function,and
--  030511          Added commission_calc_base_ parameter to Check_Total_Com_Amount__
--  030320  KaDilk  Bug 35402, Modifed the procedure  Check_Total_Com_Amount__
--  030320          and the functions Get_Total_Com_For_Co_Line, Get_Total_Due_Com_Amount.
--  030225  BhRalk  Bug 35402, Modified the Method Check_Total_Com_Amount__.
--  021216  MiKulk  Bug 34468, Modified the condition to avoid checking the commision amount against order amount
--  021216          if the total order amount negative.
--  021212  MiKulk  Bug 34468, Modified the Check_Total_Com_Amount__ not to check commision amount against order amount
--  021212          for CO lines created with Aquisition Service Order, where it is possible to have a negative amount.
--  021211  MKrase  Bug 34786, Modified the procedure Close_From_Header to clear the variable attr_.
--  020619  MiKulk  Bug 30989, Incrased the variable length for attr_ from 2000 to 32000 in Close_From_Header.
--  010622  GAOL    Bug fix 22739, Changed mult to div in calc in Get_Com_Receiver_Amount.
--  010528  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in procedures Close_From_Header and Modify
--  000129  PaLj    Bug fix 19118. Changed Cancel_Order_Commission_Lines to first cancel and then add corrections.
--  001206  JoAn    CID 56952 Changed Cancel_Order_Commission_Lines so that new
--                  correction lines are created with the right status.
--  001205  CaRa    Change / to * in function Get_Com_Receiver_Amount to return correct value.
--  001204  JoAn    Added logic for calculation of total_estimated_com_amount
--                  in Unpack_Check_Update.
--  001204  CARA    Made it possible to update a commission line to Fixed in Unpack_Check_Update___.
--                  Modify check if percentage commission when commission line is set to fixed.
--  000719  TFU     Merging from Chameleon
--  000525  BRO     Allowed only fixed lines creation in cancelled CO lines
--  000523  BRO     Modified Check_Total_Com_Amount__ in order to be able to
--                  ignore a commission line, moved the call from insert/update
--                  functions to unpack functions
--  000519  DEHA    Added Function for changing the currency
--                  (change_currency)
--  000516  BRO     Modified public states functions Cancel, Calculate and Recalculate
--                  in order to keep the Client_SYS.info__
--  000515  BRO     Added field agree_calc_info
--  000511  BRO     Added validity check on percentage in functions insert___
--                  and update___ (as this test should always be done)
--                  Allowed the note_text to be changed from the client
--  000510  DEHA    Customer is set during insert of order line commission;
--                  always updating total commission amount, if
--                  commission_percentage/ ommission_amount changes;
--                  move check for total com. amount after insert and
--                  update; set percentage to null during insert
--                  of fixed lines; remove percentage check for fixed lines;
--                  added public method close_from_header
--  000509  DEHA    Added fields note_id, note_text;
--                  removed IID CommissionNegativeFlag.
--  000509  ThIs    Added validation of customer group
--  000505  DEHA    Set the recalc-flag if commission_percentage,
--                  commission_amount changes; removing not allowed,# if a
--                  commission line is cancelled or closed; added the
--                  ability of cascade delete of order commission lines
--                  from customer order
--  000504  DEHA    Added checks for fixed commission lines;
--                  added private methods Check_Open_Lines_Unicity__,
--                  Check_Total_Com_Amount__;
--                  create com. lines only for active def. com. receivers;
--                  field com_calc_base must be mandantory
--  000503  DEHA    Added field total_estimated_com_amout, removed
--                  fields estimated_com_amount, estimated_com_percentage
--                  changed parameters in Get_Total_Est_Com_Amount;
--                  reimplemented function Get_Com_Receiver_Amount;
--                  if a fixed commission line is entered, it's state will
--                  be set to 'calculated' (func. Is_Fixed_Com___);
--                  corrected generated code from base templates
--                  for inserting rowstate.
--  000503  BjSa    Added Currency Rate
--  000428  BjSa    Added default values for commission_negative_flag_db and
--                  fixed_commission_amount_db and added logic for fetching agreement
--  000426  BRO     Added proc. Cancel_Order_Commission_Lines
--  000425  BRO     Added public procedure Calculate and Cancel
--  000419  DEHA    Moved procedures Create_Order_Commission_Lines and
--                  Refresh_Order_Commission_Lines from package
--                  CommissionCalculation into this LU. Renamed
--                  procedure Refresh_Order_Commission_Lines to
--                  Set_Order_Com_Lines_Changed. Added public
--                  method Modify.
--  000412  DEHA    Added new IID OrderLineChangeStatus; removed old
--                  functions Get_Total_Commission, Caluclate_Total_Commission
--                  added function Get_Next_Com_Line_No;
--  000411  DEHA    Recreated from model changes from 10/04/2000.
--  000407  DEHA    Recreated.
--  000406  BRO     Created
--  000406  DEHA    Created.
--  -------------------------- 12.1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_1_Com_Line_Error___
IS 
BEGIN
   Error_SYS.Record_General(lu_name_, 'COM_LINE_UNICITY: Only one open (not fixed) commission line is allowed.');
END Raise_1_Com_Line_Error___;    

-- Get_Next_Com_Line_No___
--   Implementation Method which returns the next free commision line no
--   for a specified order line.
FUNCTION Get_Next_Com_Line_No___ (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   last_com_line_no_ NUMBER;

   CURSOR get_last_com_line_no IS
      SELECT NVL(MAX(commission_line_no), 0)
      FROM   ORDER_LINE_COMMISSION_TAB
      WHERE  order_no = order_no_
        AND  line_no = line_no_
        AND  rel_no = rel_no_
        AND  line_item_no = line_item_no_;
BEGIN
   OPEN get_last_com_line_no;
   FETCH get_last_com_line_no INTO last_com_line_no_;
   CLOSE get_last_com_line_no;
   RETURN last_com_line_no_ + 1;
END Get_Next_Com_Line_No___;


FUNCTION Is_Fixed_Com___ (
   rec_ IN ORDER_LINE_COMMISSION_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   IF rec_.fixed_commission_amount = 'FIXED' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Fixed_Com___;


PROCEDURE Do_Calculate___ (
   rec_  IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_      ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_  VARCHAR2(2000);
BEGIN
   newrec_ := rec_;
   newrec_.commission_recalc_flag := 'CALCULATED';
   Update___(NULL, NULL, newrec_, attr_, objversion_, TRUE);
END Do_Calculate___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   NULL;
END Do_Cancel___;

PROCEDURE Do_Close___ (
   rec_  IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   NULL;
END Do_Close___;


PROCEDURE Do_Recalculate___ (
   rec_  IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_      ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_  VARCHAR2(2000);
BEGIN
   -- recalc. only for not fixed commission lines
   IF newrec_.fixed_commission_amount <> 'FIXED' THEN
      newrec_ := rec_;
      newrec_.commission_recalc_flag := 'CALCULATED';
      Update___(NULL, NULL, newrec_, attr_, objversion_, TRUE);
   END IF;
END Do_Recalculate___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE', 0, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_AMOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('TOTAL_COMMISSION_AMOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECALC_FLAG_DB', 'CALCULATED', attr_);
   Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE', Commission_Line_Source_API.Decode('MANUAL'), attr_);
   Client_SYS.Add_To_Attr('FIXED_COMMISSION_AMOUNT_DB', 'NORMAL', attr_);
   Client_SYS.Add_To_Attr('LINE_EXCLUDE_FLAG_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   old_note_id_                  NUMBER;
BEGIN
   -- init values
   old_note_id_ := newrec_.note_id;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;

   IF (old_note_id_ IS NOT NULL) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   -- inserting ...
   Finite_State_Init___(newrec_, attr_);

   super(objid_, objversion_, newrec_, attr_);

   -- check unicity of open lines, which are not fixed
   IF newrec_.fixed_commission_amount <> 'FIXED' THEN
      Check_Open_Lines_Unicity__ (
         newrec_.order_no,
         newrec_.line_no,
         newrec_.rel_no,
         newrec_.line_item_no,
         newrec_.commission_receiver,
         newrec_.commission_line_source);
   END IF;

   -- check the percentage
   IF (NVL(newrec_.commission_percentage, 0) < 0 OR NVL(newrec_.commission_percentage, 0) > 100 OR
       NVL(newrec_.commission_percentage_calc, 0) < 0 OR NVL(newrec_.commission_percentage_calc, 0) > 100)
   THEN
      Error_SYS.Record_General(lu_name_, 'PERCENT_INVALID: The commission percentage is invalid.');
   END IF;

   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- check the percentage
   IF (NVL(newrec_.commission_percentage, 0) < 0 OR NVL(newrec_.commission_percentage, 0) > 100 OR
       NVL(newrec_.commission_percentage_calc, 0) < 0 OR NVL(newrec_.commission_percentage_calc, 0) > 100)
   THEN
      Error_SYS.Record_General(lu_name_, 'PERCENT_INVALID: The commission percentage is invalid.');
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ORDER_LINE_COMMISSION_TAB%ROWTYPE )
IS
BEGIN
   -- removing not allowed if a commission line is cancelled or closed;
   IF remrec_.rowstate = 'Closed' OR
      remrec_.rowstate = 'Cancelled' THEN
      Error_SYS.Record_General(lu_name_, 'REMOVE_RESTRICT: Closed or cancelled commission lines can''t be removed.');
   END IF;
   -- Call this method to check the commission against to order/invoice amount when removing the line
   Check_Total_Com_Amount__ (remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, remrec_.commission_line_no, 0, 0);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_LINE_COMMISSION_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_line_commission_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   date_entered_              DATE;
   company_                   VARCHAR2(20);
   curr_type_                 VARCHAR2(10);
   conv_factor_               NUMBER;
   curr_code_                 VARCHAR2(03);
   col_objstate_db_           customer_order_line_tab.rowstate%TYPE;
   revision_date_             DATE;
   created_by_server_         NUMBER := 0;

BEGIN
   IF newrec_.line_exclude_flag IS NULL THEN
      newrec_.line_exclude_flag := 'TRUE';
   END IF;
   
   created_by_server_ := Client_SYS.Get_Item_Value('CREATED_BY_SERVER', attr_);  
   newrec_.commission_line_no := Get_Next_Com_Line_No___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);       
   
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.commission_percentage < 0) OR
      (newrec_.commission_percentage > 100) THEN
      Error_SYS.Record_General(lu_name_, 'PERCENTAGE_INVALID: Percentage must be between 0 and 100');
   END IF;
   
   IF (created_by_server_ = 0) THEN

      --Manually entered lines should always have line_source 'MANUAL'.
      IF (newrec_.commission_line_source != 'MANUAL') THEN
         Error_SYS.Record_General(lu_name_, 'WRONG_LINE_SOURCE: The line source can not be entered as :P1 for a manual commission line.', Commission_Line_Source_API.Decode(newrec_.commission_line_source));
      END IF;
   END IF;

   date_entered_ := Customer_Order_Line_API.Get_Date_Entered (newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );

   -- check if the CO line is cancelled
   col_objstate_db_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF (col_objstate_db_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CANCELLED_OL: Commission lines can not be entered on a cancelled customer order line.');
   END IF;

   -- Fetch Agreement from Commission Receiver only for system created lines
   IF (newrec_.fixed_commission_amount <> 'FIXED' AND newrec_.commission_line_source != 'MANUAL') THEN
      newrec_.agreement_id := Commission_Receiver_API.Get_Agreement_Id (newrec_.commission_receiver);
      IF (newrec_.agreement_id IS NOT NULL) THEN
         newrec_.commission_calc_base := Commission_Agree_API.Get_Comm_Calc_Base_Db(newrec_.agreement_id);
         IF (newrec_.commission_calc_base = 'INVOICED') THEN
            -- Fetch valid revision using invoice date if invoice exists, otherwise use order date.
            revision_date_ := NVL(Customer_Order_Inv_Item_API.Get_Order_line_Invoice_Date(newrec_.order_no,
                                                                                          newrec_.line_no,
                                                                                          newrec_.rel_no,
                                                                                          newrec_.line_item_no), date_entered_);
         ELSIF (newrec_.commission_calc_base = 'ORDER') THEN
            --Fetch valid revision using date entered on customer order line.
            revision_date_ := date_entered_;
         END IF;
         newrec_.revision_no := Commission_Agree_API.Get_Agree_Version ( newrec_.agreement_id, revision_date_);
      END IF;
   END IF;
   -- commission calc. base must be mandantory (set by agreement, or if no agreement
   -- is set, when is must be specified manually)
   Error_SYS.Check_Not_Null(lu_name_, 'COMMISSION_CALC_BASE', newrec_.commission_calc_base);

   -- Compute currency rate
   curr_code_ := Commission_Receiver_API.Get_Currency_Code (newrec_.commission_receiver);
   IF newrec_.contract IS NULL THEN
      newrec_.contract := Customer_Order_API.Get_Contract(newrec_.order_no);
   END IF;

   company_ := Site_API.Get_Company(newrec_.contract);
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, newrec_.currency_rate, company_, curr_code_, date_entered_, 'CUSTOMER', NVL(Customer_Order_API.Get_Customer_No_Pay(newrec_.order_no),NVL(newrec_.customer_no, Customer_Order_API.Get_Customer_No(newrec_.order_no))));
   newrec_.currency_rate := newrec_.currency_rate / conv_factor_;

   IF (newrec_.commission_calc_base = 'ORDER') AND
      (newrec_.commission_amount IS NOT NULL) THEN
       newrec_.total_commission_amount := newrec_.commission_amount;
   END IF;

   -- set the percentage to null, if it's a fixed commission line
   IF (newrec_.fixed_commission_amount = 'FIXED') AND
      (newrec_.commission_percentage IS NOT NULL) THEN
      IF newrec_.commission_percentage <> 0 THEN
         Client_SYS.Add_Info(lu_name_, 'REMOVEPERCENT: For fixed lines the entered percentage value is removed.');
      END IF;
      newrec_.commission_percentage := NULL;
      Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE', newrec_.commission_percentage, attr_);
   END IF;
   Client_SYS.Add_To_Attr('COMMISSION_LINE_NO', newrec_.commission_line_no, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', newrec_.agreement_id, attr_);
   Client_SYS.Add_To_Attr('REVISION_NO', newrec_.revision_no, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_CALC_BASE', Commission_Calc_Base_API.Decode(newrec_.commission_calc_base), attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE', newrec_.currency_rate, attr_);
   Client_SYS.Add_To_Attr('TOTAL_COMMISSION_AMOUNT', newrec_.total_commission_amount, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_line_commission_tab%ROWTYPE,
   newrec_ IN OUT order_line_commission_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(4000);
   company_                   VARCHAR2(20);
   party_type_id_             VARCHAR2(20);
   not_only_note_text_        BOOLEAN;
BEGIN

   -- set the recalc-flag if commission_percentage, commission_amount changes
   -- changes on closed, cancelled com. lines are not allowed
   IF (newrec_.rowstate = 'Closed' OR newrec_.rowstate = 'Cancelled') THEN
      not_only_note_text_ := FALSE;
      IF Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) THEN
         not_only_note_text_ := name_ <> 'NOTE_TEXT';
      END IF;
      IF Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) THEN
         not_only_note_text_ := TRUE;
      END IF;
      -- excepted changes on notes text
      IF (not_only_note_text_) THEN
         Error_SYS.Record_General(lu_name_, 'UPDATE_RESTRICT: Changing of closed/ cancelled commission lines are not allowed.');
      END IF;
   END IF;

   IF (indrec_.sales_price_group_id) THEN
      indrec_.sales_price_group_id := FALSE;
   END IF;
     
   super(oldrec_, newrec_, indrec_, attr_);
   
   Error_SYS.Check_Not_Null(lu_name_, 'COMMISSION_CALC_BASE', newrec_.commission_calc_base);
   Error_SYS.Check_Not_Null(lu_name_, 'NOTE_ID', newrec_.note_id);
   
   IF ((newrec_.commission_calc_base = 'ORDER') AND (newrec_.rowstate = 'Created') AND (NVL(oldrec_.commission_amount,0) <> NVL(newrec_.commission_amount, 0))) THEN
       newrec_.total_commission_amount := newrec_.commission_amount;
   END IF;

   -- Updating total commission amount, if manual entered percentage
   -- or amount changes
   IF ((NVL(oldrec_.commission_percentage, 0) <> NVL(newrec_.commission_percentage, 0)) OR
      (NVL(oldrec_.commission_amount, 0) <> NVL(newrec_.commission_amount, 0))) AND
      (newrec_.rowstate = 'Calculated') THEN
      IF (newrec_.commission_line_source = 'CORRECTION' ) THEN
         Error_SYS.Record_General(lu_name_, 'UPDATE_CORR: Changing of correction line is not allowed.');
      END IF;
      IF (newrec_.commission_calc_base = 'INVOICED') THEN
         newrec_.total_estimated_com_amount :=
            Commission_Calculation_API.Get_Total_Com_Amount(
               newrec_.order_no,
               newrec_.line_no,
               newrec_.rel_no,
               newrec_.line_item_no,
               newrec_.commission_line_no,
               newrec_.commission_percentage,
               newrec_.commission_amount);
      ELSE
         newrec_.total_commission_amount :=
            Commission_Calculation_API.Get_Total_Com_Amount(
               newrec_.order_no,
               newrec_.line_no,
               newrec_.rel_no,
               newrec_.line_item_no,
               newrec_.commission_line_no,
               newrec_.commission_percentage,
               newrec_.commission_amount);

      END IF;
   END IF;

   IF (newrec_.commission_line_source = 'SYSTEM') THEN
      IF (NVL(newrec_.commission_percentage_calc, 0) != NVL(newrec_.commission_percentage, 0)) OR
         (NVL(newrec_.commission_amount_calc, 0) != NVL(newrec_.commission_amount, 0)) THEN
         --Manual modifications have been made on a system generated line.
         newrec_.commission_line_source := 'MODIFIED';
      END IF;
   END IF;

   IF ( newrec_.group_id IS NOT NULL) THEN
      company_ := Site_API.Get_Company(newrec_.contract);
      party_type_id_ := Party_Type_API.Decode('CUSTOMER');
      Invoice_Party_Type_Group_API.Exist(company_, party_type_id_, newrec_.group_id);
   END IF;

   -- check, if for fixed commission lines a percentage value is inserted/ updated
   IF (newrec_.fixed_commission_amount = 'FIXED') AND
      (newrec_.commission_percentage > 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_USE_PERCENTAGE: Fixed Commission check box cannot be selected, if the value in the Commission (%) field is greater than zero.');
   END IF;
   
   IF ((oldrec_.commission_no IS NOT NULL) AND (newrec_.commission_calc_base = 'INVOICED')) THEN
      IF ((NVL(oldrec_.commission_percentage, 0) <> NVL(newrec_.commission_percentage, 0)) OR
         (NVL(oldrec_.commission_amount, 0) <> NVL(newrec_.commission_amount, 0))) THEN
         newrec_.total_commission_amount := Commission_Calculation_API.Get_Total_Com_Amount(newrec_.order_no,
                                                                                            newrec_.line_no,
                                                                                            newrec_.rel_no,
                                                                                            newrec_.line_item_no,
                                                                                            newrec_.commission_line_no,
                                                                                            newrec_.commission_percentage,
                                                                                            newrec_.commission_amount);
      END IF;
   END IF; 

   Client_SYS.Add_to_Attr('TOTAL_COMMISSION_AMOUNT', newrec_.total_commission_amount, attr_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Open_Lines_Unicity__
--   Private Method checks, if there's only one open not fixed order commission
--   line for a customer order line and a commission receiver.
PROCEDURE Check_Open_Lines_Unicity__ (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   commission_receiver_    IN VARCHAR2,
   commission_line_source_ IN VARCHAR2 )
IS
   number_open_lines_      NUMBER;

      CURSOR get_open_lines IS
     SELECT count(*)
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_receiver = commission_receiver_
        AND (rowstate IN ('Created', 'Calculated') AND fixed_commission_amount <> 'FIXED');

   CURSOR get_open_for_manual IS
     SELECT count(*)
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_receiver = commission_receiver_
        AND rowstate IN ('Created', 'Calculated')
        AND commission_line_source != 'CORRECTION'
        AND fixed_commission_amount <> 'FIXED';

   CURSOR get_open_for_corr IS
     SELECT count(*)
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_receiver = commission_receiver_
        AND rowstate IN ('Created', 'Calculated')
        AND commission_line_source != 'MANUAL';

BEGIN
   IF (commission_line_source_ = 'MANUAL') THEN
      --New manual line.
      OPEN get_open_for_manual;
      FETCH get_open_for_manual INTO number_open_lines_;
      IF get_open_for_manual%NOTFOUND OR
         get_open_for_manual%FOUND IS NULL THEN
         number_open_lines_ := 0;
      END IF;
      CLOSE get_open_for_manual;

      IF number_open_lines_ > 1 THEN
         Raise_1_Com_Line_Error___;
      END IF;
   ELSIF (commission_line_source_ = 'CORRECTION') THEN
      --New system generated correction line.
      OPEN get_open_for_corr;
      FETCH get_open_for_corr INTO number_open_lines_;
      IF get_open_for_corr%NOTFOUND OR
         get_open_for_corr%FOUND IS NULL THEN
         number_open_lines_ := 0;
      END IF;
      CLOSE get_open_for_corr;

      IF number_open_lines_ > 1 THEN
         Error_SYS.Record_General(lu_name_, 'CORR_LINE_UNICITY: Only one open system generated (system, modified or correction) commission line is allowed');
      END IF;
   ELSE
      --New system generated line.
      OPEN get_open_lines;
      FETCH get_open_lines INTO number_open_lines_;
      IF get_open_lines%NOTFOUND OR
         get_open_lines%FOUND IS NULL THEN
         number_open_lines_ := 0;
      END IF;
      CLOSE get_open_lines;

      IF number_open_lines_ > 1 THEN
         Raise_1_Com_Line_Error___;
      END IF;
   END IF;
END Check_Open_Lines_Unicity__;

-- Check_Total_Com_Amount__
--   Method for checking if the total commission amount for a customer order
--   line is not greater than the order amount. It is possible to make the
--   total on all the lines excepted one whose the line_no and the amount are given.
PROCEDURE Check_Total_Com_Amount__ (
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   rel_no_                  IN VARCHAR2,
   line_item_no_            IN NUMBER,
   commission_line_no_      IN NUMBER DEFAULT NULL,
   new_percentage_          IN NUMBER DEFAULT NULL,
   new_commission_amount_   IN NUMBER DEFAULT NULL,
   commission_receiver_     IN VARCHAR2 DEFAULT NULL )
IS
   gross_invoice_amount_        NUMBER:=0;
   invoice_exist_               NUMBER;
   order_based_                 NUMBER:=0;
   total_com_amount_            NUMBER:=0;
   total_base_order_amount_     NUMBER:=0;
   changed_percentage_          NUMBER:=0;
   changed_com_amount_          NUMBER:=0;
   contract_                    VARCHAR2(5);
   is_new_line_insert_          BOOLEAN:=TRUE;
   no_check_                    BOOLEAN:=FALSE;
   expected_commission_         NUMBER:=0;

   CURSOR get_all_commissions IS
     SELECT *
     FROM  order_line_commission_tab
     WHERE order_no = order_no_
     AND   line_no = line_no_
     AND   rel_no = rel_no_
     AND   line_item_no = line_item_no_
     AND   rowstate != 'Cancelled'
     AND   commission_receiver LIKE NVL(commission_receiver_, '%')
     ORDER BY commission_calc_base;

BEGIN
   contract_ := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);
   invoice_exist_:=Commission_Calculation_API.Check_Invoice_Exist(order_no_, line_no_, rel_no_, line_item_no_,contract_);
   gross_invoice_amount_ := Customer_Order_Inv_Item_API.Get_Total_Net_Invoice_Amount(order_no_, line_no_, rel_no_, line_item_no_);
   --Note: Get the base order line total
   total_base_order_amount_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, line_no_, rel_no_, line_item_no_);
   FOR commission_rec_ IN get_all_commissions LOOP
      IF (commission_line_no_ IS NOT NULL AND commission_rec_.commission_line_no = commission_line_no_) THEN
         changed_percentage_:=NVL(new_percentage_,0);
         changed_com_amount_:=NVL(new_commission_amount_,0);
         -- Note: is_new_line_insert_ is used to identify whether the new line has been inserted or not
         is_new_line_insert_:=FALSE;
      ELSE
         changed_percentage_:=NVL(commission_rec_.commission_percentage,0);
         changed_com_amount_:=NVL(commission_rec_.commission_amount,0);
      END IF;
      expected_commission_:=0;
      IF (commission_rec_.commission_calc_base = 'INVOICED') THEN
         IF (invoice_exist_ = 1) THEN
               IF (gross_invoice_amount_ =  0 ) THEN
               -- Note: can't calculate % commission for 0 gross invoice amount
                  IF (NVL(commission_rec_.total_commission_amount,0) = 0 ) THEN
                     commission_rec_.total_commission_amount := changed_com_amount_;
                  END IF;
                  expected_commission_:=commission_rec_.total_commission_amount;
                  IF (is_new_line_insert_ = FALSE AND changed_percentage_ = 0 AND changed_com_amount_ = 0) THEN
                     no_check_ :=TRUE;
                  END IF;
                  changed_com_amount_:=0;
               ELSE
                  expected_commission_:=NVL(changed_percentage_,0) * gross_invoice_amount_/100;
               END IF;
            total_com_amount_ := total_com_amount_ + expected_commission_ + changed_com_amount_;
         ELSE
            total_com_amount_ := total_com_amount_ + (changed_percentage_ * total_base_order_amount_/100) + changed_com_amount_;
         END IF;
      ELSE
         total_com_amount_ := total_com_amount_ + (changed_percentage_ * total_base_order_amount_/100) + changed_com_amount_;
         order_based_ :=1;
      END IF;
   END LOOP;
   IF (is_new_line_insert_ = TRUE) THEN
      total_com_amount_ := total_com_amount_ + (NVL(new_percentage_,0) *  total_base_order_amount_/100) + NVL(new_commission_amount_,0);
   END IF;

   IF (new_commission_amount_ < 0) THEN
      no_check_ := TRUE;
   END IF;
   -- check com. amount against order amount
   -- Note: IF the total order amount is negative and the CO lines created with Aquisition Service Order, then avoid checking the commision amount against order amount.
   IF (NOT((Customer_Order_Line_API.Get_Supply_Code(order_no_,line_no_,rel_no_,line_item_no_)=Order_Supply_Type_API.Decode('SEO')) AND (total_base_order_amount_ < 0)))THEN
      -- Note: When Order Line is in Invoiced State and all the commission lines are in Invoiced Based,
      -- Note: then the total_com_amount_ should be compared with invoiced_amount_ not with total_base_order_amount_
      IF ( invoice_exist_ > 0 AND order_based_ = 0 )THEN
         IF ( total_com_amount_ > gross_invoice_amount_ AND total_com_amount_ > 0 AND no_check_ = FALSE) THEN
            -- 73616, Modified the error message to inform the user that commissions have to be recalculated for the whole CO Line.
            Error_SYS.Record_General(lu_name_, 'INVCOMAMOUNTINVALID: Total commission amount for order line is greater than the invoiced amount. You need to recalculate commissions for the entire order line.');
         END IF;
      ELSIF (total_com_amount_ > total_base_order_amount_) THEN
         Error_SYS.Record_General(lu_name_, 'COM_AMOUNT_INVALID: Total commission amount for order line is greater than the order amount.');
      END IF;
   END IF;

END Check_Total_Com_Amount__;


-- Connect_Fixed_To_Header__
--   Private method which connects fixed commission lines to a commission
--   header for a given customer order line and commission receiver.
PROCEDURE Connect_Fixed_To_Header__ (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   commission_receiver_ IN VARCHAR2,
   commission_no_ IN NUMBER )
IS
   CURSOR get_olc_line_no IS
     SELECT commission_line_no
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_receiver =  commission_receiver_
        AND fixed_commission_amount = 'FIXED'
        AND rowstate NOT IN ('Cancelled', 'Closed');
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, line_no_, rel_no_, line_item_no_, rec_.commission_line_no);
      new_olc_rec_.commission_no := commission_no_;
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Connect_Fixed_To_Header__;


-- Check_Customer_Group__
--   Checks if the group_id exists. If found, print an error message.
--   Used for restricted delete check when removing an group_id (INVOIC-module).
PROCEDURE Check_Customer_Group__ (
   key_list_ IN VARCHAR2 )
IS
   company_     VARCHAR2(20);
   party_type_  VARCHAR2(200);
   group_id_    ORDER_LINE_COMMISSION_TAB.group_id%TYPE;
   found_       NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE Site_API.Get_Company(contract) = company_
         AND group_id = group_id_;
BEGIN
   company_    := SUBSTR(key_list_, 1, INSTR(key_list_, '^') - 1);
   party_type_ := SUBSTR(key_list_, INSTR(key_list_, '^') + 1, INSTR(key_list_, '^' , 1, 2) - (INSTR(key_list_, '^') + 1));
   group_id_   := SUBSTR(key_list_, INSTR(key_list_, '^', 1, 2) + 1, INSTR(key_list_, '^' , 1, 3) - (INSTR(key_list_, '^',1,2) + 1));
   
   IF (party_type_ = 'CUSTOMER') THEN
      OPEN exist_control;
      FETCH exist_control INTO found_;
      IF (exist_control%NOTFOUND) THEN
         found_ := 0;
      END IF;
      CLOSE exist_control;
      IF (found_ = 1) THEN
         Error_SYS.Record_General(lu_name_, 'NO_GROUP_ID: Customer Group :P1 exists on one or several Order Line Commission(s)', group_id_);
      END IF;
   END IF;
END Check_Customer_Group__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Order_Commission_Lines
--   Fetches default commission receivers from the customer and creates
--   empty commission lines.
PROCEDURE Create_Order_Commission_Lines (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   contract_      IN VARCHAR2,
   customer_no_   IN VARCHAR2 )
IS
   CURSOR get_default_com IS
     SELECT a.commission_receiver
       FROM cust_def_com_receiver_tab a, commission_receiver_tab b
       WHERE a.customer_no = customer_no_
       AND a.commission_receiver = b.commission_receiver
       AND b.rowstate = 'Active';
   
   temp_olc_rec_          ORDER_LINE_COMMISSION_TAB%ROWTYPE;
BEGIN
   -- fetch the default commission receivers for the customer
   -- create for every commission receiver a new order commission line
   FOR rec_ IN get_default_com LOOP
      temp_olc_rec_ := Create_Order_Commission_Line (
                        order_no_,
                        line_no_,
                        rel_no_,
                        line_item_no_,
                        contract_,
                        customer_no_,
                        rec_.commission_receiver);
   END LOOP;
END Create_Order_Commission_Lines;


-- Create_Order_Commission_Line
--   Creates an order commission line for the specified commission receiver.
FUNCTION Create_Order_Commission_Line (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   contract_               IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   commission_receiver_    IN VARCHAR2,
   commission_line_source_ IN VARCHAR2 DEFAULT NULL ) RETURN ORDER_LINE_COMMISSION_TAB%ROWTYPE
IS
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_                      VARCHAR2(2000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   indrec_                    Indicator_Rec;
BEGIN

   new_olc_rec_ := NULL;

   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', commission_receiver_, attr_);

   IF (commission_line_source_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE_DB', commission_line_source_, attr_);
   ELSE
       Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE_DB', 'SYSTEM', attr_);
   END IF;

   Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE_DB', 'SYSTEM', attr_);
   -- we fill this field with any value; if an agreement exist, this value
   -- will be overwritten in the unpack_check_insert
   Client_SYS.Add_To_Attr('COMMISSION_CALC_BASE_DB', 'ORDER', attr_);
   Client_SYS.Add_To_Attr('CREATED_BY_SERVER', 1, attr_);

   Unpack___(new_olc_rec_, indrec_, attr_);
   Check_Insert___(new_olc_rec_, indrec_, attr_);
   Insert___(objid_, objversion_, new_olc_rec_, attr_);

   RETURN new_olc_rec_;

END Create_Order_Commission_Line;


-- Cancel_Order_Commission_Lines
--   Public method for cancel commission lines.
PROCEDURE Cancel_Order_Commission_Lines (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER )
IS
   CURSOR loop_com_lines IS
      SELECT *
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND rowstate <> 'Cancelled';

   CURSOR get_com_receiver IS
      SELECT DISTINCT commission_receiver
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND rowstate = 'Closed';

   CURSOR get_closed_lines(com_receiver_ IN VARCHAR2) IS
      SELECT *
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND commission_receiver = com_receiver_
         AND rowstate = 'Closed';

   info_                      VARCHAR2(32000);
   attr_                      VARCHAR2(32000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   closed_exist_              NUMBER := 0;
   line_copied_               NUMBER := 0;
   total_commission_amount_   NUMBER := 0;


BEGIN

   FOR olc_rec_ IN loop_com_lines LOOP
      IF (olc_rec_.rowstate != 'Closed') THEN
         -- if the comission calculation is not closed, the item is cancelled
         Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, olc_rec_.commission_line_no);
         Cancel__(info_, objid_, objversion_, attr_, 'DO');
      ELSE
         closed_exist_ := 1;
      END IF;
   END LOOP;

   IF (closed_exist_ = 1) THEN
      -- if the comission calculation is closed the cancellation
      -- is postponed to the next period

      FOR receiver_rec_ IN get_com_receiver LOOP
         --Create one new correction line per receiver.
         FOR olc_rec_ IN get_closed_lines(receiver_rec_.commission_receiver) LOOP

            IF (line_copied_ = 0) THEN
               new_olc_rec_ := olc_rec_;
               line_copied_ := 1;
            END IF;

            total_commission_amount_ := total_commission_amount_ + olc_rec_.total_commission_amount;
         END LOOP;

         IF (line_copied_ = 1) THEN
            IF (NVL(total_commission_amount_, 0) != 0) THEN
               Commission_Calculation_API.Create_Order_Com_Header( new_olc_rec_.commission_no,
                                                                   order_no_,
                                                                   line_no_,
                                                                   rel_no_,
                                                                   line_item_no_,
                                                                   receiver_rec_.commission_receiver);
               new_olc_rec_.commission_line_no := Get_Next_Com_Line_No___(order_no_, line_no_, rel_no_, line_item_no_);
               new_olc_rec_.commission_percentage := NULL;
               new_olc_rec_.commission_percentage_calc := NULL;
               new_olc_rec_.total_commission_amount := (total_commission_amount_ * -1);
               new_olc_rec_.commission_amount := new_olc_rec_.total_commission_amount;
               new_olc_rec_.commission_amount_calc := new_olc_rec_.total_commission_amount;
               new_olc_rec_.fixed_commission_amount := 'NORMAL';
               new_olc_rec_.commission_line_source := 'CORRECTION';
               new_olc_rec_.rowstate := NULL;

               Insert___ (objid_, objversion_, new_olc_rec_, attr_);
               Calculate__(info_, objid_, objversion_, attr_, 'DO');
            END IF;
            line_copied_ := 0;
            total_commission_amount_ := 0;
         END IF;

      END LOOP;
   END IF;

END Cancel_Order_Commission_Lines;


-- Calculate
--   Method for setting the the commission line to Calculated.
PROCEDURE Calculate (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   commission_line_no_  IN NUMBER )
IS
   rec_  ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_ VARCHAR2(2000);
BEGIN
   -- Generates the Calculate event
   rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, commission_line_no_);
   Finite_State_Machine___(rec_, 'Calculate', attr_);
END Calculate;


-- Recalculate
--   Public method for recalculating an order commission line.
PROCEDURE Recalculate (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   commission_line_no_  IN NUMBER )
IS
   rec_  ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_ VARCHAR2(2000);
BEGIN
   -- Generates the Recalculate event
   rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, commission_line_no_);
   Finite_State_Machine___(rec_, 'Recalculate', attr_);
END Recalculate;


-- Cancel
--   Method for setting the the commission line to Cancelled.
PROCEDURE Cancel (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   commission_line_no_  IN NUMBER )
IS
   rec_  ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);
BEGIN
   -- Generates the Cancel event
   rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, commission_line_no_);
   Finite_State_Machine___(rec_, 'Cancel', attr_);
END Cancel;


-- Close_From_Header
--   Public method for closing all commission lines for a transferred comission no.
PROCEDURE Close_From_Header (
   commission_no_ IN NUMBER )
IS
   info_                VARCHAR2(2000);
   attr_                VARCHAR2(32000);
   CURSOR get_olcs IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE commission_no = commission_no_
        AND rowstate != 'Cancelled'
        AND rowstate != 'Closed';
BEGIN
   -- close all correspoding commission order lines
   FOR rec_ IN get_olcs LOOP
      Close__(info_, rec_.objid, rec_.objversion, attr_, 'DO');
      attr_ := null;
   END LOOP;
END Close_From_Header;


-- Set_Order_Com_Lines_Changed
--   Public method for setting flag of the corresponding order commission
--   to NeedCalculation.
--   Function schould exist with two different parameter
--   lists (ref. to customer order, customer order line).
--   So the function would be implemented as an overdriven
PROCEDURE Set_Order_Com_Lines_Changed (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_olc_line_no IS
     SELECT commission_line_no
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_;
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_          VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   -- set the status of all order commission lines which belongs to
   -- a customer order line to be "changed"
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, line_no_, rel_no_, line_item_no_, rec_.commission_line_no);
      new_olc_rec_.commission_recalc_flag := 'NEEDCALCULATION';
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Set_Order_Com_Lines_Changed;


-- Set_Order_Com_Lines_Changed
--   Public method for setting flag of the corresponding order commission
--   to NeedCalculation.
--   Function schould exist with two different parameter
--   lists (ref. to customer order, customer order line).
--   So the function would be implemented as an overdriven
PROCEDURE Set_Order_Com_Lines_Changed (
   order_no_ IN VARCHAR2 )
IS
   CURSOR get_olc_line_no IS
     SELECT line_no, rel_no, line_item_no, commission_line_no
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_;
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_          VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   -- set the status of all order commission lines which belongs to
   -- a customer order line to be "changed"
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.commission_line_no);
      new_olc_rec_.commission_recalc_flag := 'NEEDCALCULATION';
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Set_Order_Com_Lines_Changed;


-- Reset_Order_Com_Lines_Changed
--   Public method to reset the flag NeedCalculation.
PROCEDURE Reset_Order_Com_Lines_Changed (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   commission_receiver_ IN VARCHAR2 )
IS
   CURSOR get_olc_line_no IS
     SELECT commission_line_no
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_receiver =  commission_receiver_;
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   -- set the status of all order commission lines which belongs to
   -- a customer order line to be "changed"
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, line_no_, rel_no_, line_item_no_, rec_.commission_line_no);
      new_olc_rec_.commission_recalc_flag := 'CALCULATED';
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Reset_Order_Com_Lines_Changed;

-- Reset_Order_Com_Lines_Changed
-- Public method for Resetting flag of the corresponding order commissions of an order to 'Calculated'.
PROCEDURE Reset_Order_Com_Lines_Changed (
   order_no_ IN VARCHAR2 )
IS
   CURSOR get_olc_line_no IS
     SELECT line_no, 
            rel_no, 
            line_item_no, 
            commission_line_no
     FROM ORDER_LINE_COMMISSION_TAB
     WHERE order_no = order_no_;
   new_olc_rec_   ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.commission_line_no);
      new_olc_rec_.commission_recalc_flag := 'CALCULATED';
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Reset_Order_Com_Lines_Changed;

-- Modify
--   A public update method.
PROCEDURE Modify (
   newrec_ IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE)
IS
   oldrec_                    ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___ (newrec_.order_no, newrec_.line_no, newrec_.rel_no,
                               newrec_.line_item_no, newrec_.commission_line_no);
   -- changes on closed, cancelled com. lines are not allowed
   IF (oldrec_.rowstate = 'Closed') OR
      (oldrec_.rowstate = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATE_RESTRICT: Changing of closed/ cancelled commission lines are not allowed.');
   END IF;

   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify;


-- Get_Total_Com_For_Co_Line
--   Returns the total commission for one order line in base currency.
@UncheckedAccess
FUNCTION Get_Total_Com_For_Co_Line (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN NUMBER
IS
   amount_               NUMBER := 0;
   CURSOR get_com_lines IS
     SELECT total_commission_amount
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND rowstate NOT IN ('Created', 'Cancelled')
        ORDER BY commission_line_no;
BEGIN
   -- Note: Only sum the total_commision_amount to show it in the total_commission in the header
   FOR rec_ IN get_com_lines LOOP
      amount_ := amount_ + rec_.total_commission_amount;
   END LOOP;
   RETURN amount_;
END Get_Total_Com_For_Co_Line;


-- Get_Total_Due_Com_Amount
--   Public Method to calculate the estimated total commission amount
--   for a order line commission.
@UncheckedAccess
FUNCTION Get_Total_Due_Com_Amount (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   commission_line_no_ IN NUMBER,
   from_client_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_normal_fixed_line IS
      SELECT commission_recalc_flag,commission_percentage, commission_amount, total_commission_amount, total_estimated_com_amount, commission_calc_base, fixed_commission_amount
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   commission_line_no = commission_line_no_
      AND   rowstate != 'Cancelled';
   normal_fixed_comm_line_  get_normal_fixed_line%ROWTYPE;
   total_due_com_amount_    NUMBER;
   order_line_total_base_   NUMBER;
   invoice_line_total_base_ NUMBER;
   line_total_diff_         NUMBER;
BEGIN
   -- Note: Restructure this method to get the due for invoice base and not invoiced line
   total_due_com_amount_ := 0;
   order_line_total_base_:=Customer_order_Line_API.Get_Base_Sale_Price_Total(order_no_,line_no_,rel_no_,line_item_no_);
   OPEN get_normal_fixed_line;
   FETCH get_normal_fixed_line INTO normal_fixed_comm_line_;
   CLOSE get_normal_fixed_line;
   -- Order base lines should not have a value for Total_Due_Com_amount
   IF (normal_fixed_comm_line_.commission_calc_base = 'ORDER') THEN
      RETURN 0;
   END IF;

   IF (normal_fixed_comm_line_.fixed_commission_amount = 'NORMAL') THEN
      IF (normal_fixed_comm_line_.commission_percentage IS NOT NULL ) THEN
         total_due_com_amount_  :=(normal_fixed_comm_line_.commission_percentage*order_line_total_base_)/100 - nvl(normal_fixed_comm_line_.total_commission_amount,0);
      END IF;
      total_due_com_amount_  :=total_due_com_amount_ + NVL(normal_fixed_comm_line_.commission_amount,0);
   ELSE
      -- Fixed lines doesn't have a percentage so assign commission amount to due
      total_due_com_amount_ := normal_fixed_comm_line_.commission_amount;
   END IF;

   IF (Customer_Order_Line_API.Get_Objstate(order_no_,line_no_,rel_no_,line_item_no_) = 'Invoiced') THEN
      -- if this method is calling from client it should show 0 value, from server then it should return a value for other calculation purposes
      IF (from_client_ = 'TRUE') THEN
         total_due_com_amount_ := 0;
      ELSE
         -- after invoicing the recalculation flag will be checked. once you recalculated it will be unchecked.At that time it should show 0
         IF (normal_fixed_comm_line_.commission_recalc_flag = 'CALCULATED') THEN
            total_due_com_amount_:=0;
         END IF;
      END IF;
   ELSE
      invoice_line_total_base_:= Customer_Order_Inv_Item_API.Get_Total_Net_Invoice_Amount(order_no_, line_no_, rel_no_, line_item_no_);
      -- get the diffrence of order total and invoice total in base currency
      line_total_diff_:= order_line_total_base_ - invoice_line_total_base_;
      --if all quantity invoiced then due should be 0
      IF (line_total_diff_ = 0) THEN
         total_due_com_amount_ := 0;
      ELSE
         -- if it is partially delivered and having invoice the remaining commission value should be shown in the due
         IF (invoice_line_total_base_ > 0) THEN
            total_due_com_amount_:= NVL(normal_fixed_comm_line_.commission_percentage, 0) * NVL(line_total_diff_, 0) / 100;
         END IF;
      END IF;
   END IF;
   RETURN total_due_com_amount_;
END Get_Total_Due_Com_Amount;


-- Get_Com_Receiver_Amount
--   Get the total amount in receivers currency.
FUNCTION Get_Com_Receiver_Amount (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   commission_line_no_ IN NUMBER ) RETURN NUMBER
IS
   base_amount_          NUMBER;
   curr_amount_          NUMBER;
   curr_code_            COMMISSION_RECEIVER_TAB.currency_code%TYPE;
   curr_rate_            NUMBER;
   company_              VARCHAR2(20);
   rounding_             NUMBER;
   commission_receiver_  ORDER_LINE_COMMISSION_TAB.commission_receiver%TYPE;
   contract_             ORDER_LINE_COMMISSION_TAB.contract%TYPE;
   curr_type_            CURRENCY_TYPE_TAB.currency_type%TYPE;
   conv_factor_          NUMBER;
   rate_                 NUMBER;
   calc_percentage_      NUMBER;
   base_com_amt_line_    NUMBER;
   commission_calc_base_ ORDER_LINE_COMMISSION_TAB.Commission_Calc_Base%TYPE;
   invoice_no_           NUMBER;
   invoice_date_         DATE;

   CURSOR get_com_line IS
     SELECT contract, total_commission_amount, commission_receiver,commission_calc_base
       FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND commission_line_no = commission_line_no_;
        
   CURSOR get_invoice_data IS
     SELECT invoice_date,curr_rate
       FROM CUSTOMER_ORDER_INV_HEAD 
      WHERE company = company_
        AND invoice_id = invoice_no_;
         
   CURSOR get_net_amount IS 
      SELECT net_curr_amount,invoice_id 
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND release_no = rel_no_
         AND line_item_no = line_item_no_;
   
BEGIN
   -- fetch data from order com. line
   OPEN get_com_line;
   FETCH get_com_line INTO contract_, base_amount_, commission_receiver_, commission_calc_base_;
   IF get_com_line%NOTFOUND OR
      get_com_line%FOUND IS NULL THEN
      RETURN NULL;
   END IF;
   CLOSE get_com_line;

   -- base data for currency calculations
   company_ := Site_API.Get_Company(contract_);
   curr_code_ := Commission_Receiver_Api.Get_Currency_Code(commission_receiver_);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, curr_code_);

   IF (Company_Finance_API.Get_Currency_Code(company_) = curr_code_) THEN
      curr_amount_ := base_amount_;
   ELSE
      -- calc. the amount 
      IF(commission_calc_base_ = 'INVOICED')THEN  
         curr_amount_ := 0;
         
         FOR amt_rec_ IN get_net_amount LOOP
            invoice_no_ := amt_rec_.invoice_id;
            OPEN get_invoice_data;
            FETCH get_invoice_data INTO invoice_date_,curr_rate_;
            CLOSE get_invoice_data;
            
            calc_percentage_ := Get_Commission_Percentage(order_no_,line_no_,rel_no_,line_item_no_,commission_line_no_);
            base_com_amt_line_ := amt_rec_.net_curr_amount * curr_rate_ *(calc_percentage_/100);                                                           
            Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, curr_rate_, company_, curr_code_,
                                                           invoice_date_);
            rate_ := curr_rate_ / conv_factor_; 
            curr_amount_ := base_com_amt_line_ / rate_ + curr_amount_; 
         END LOOP;
         
         curr_amount_ := round(curr_amount_, rounding_);
      ELSE                               
         Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, curr_rate_, company_, curr_code_,
                                                        Site_API.Get_Site_Date(contract_));
         rate_ := curr_rate_ / conv_factor_;
         curr_amount_ := round(base_amount_ / rate_, rounding_);
      END IF;
      
      IF (rate_ = 0) THEN
         curr_amount_ := 0;
      END IF;
   END IF;

   RETURN curr_amount_;
END Get_Com_Receiver_Amount;


-- Change_Currency
--   Public method which updates the currency in all  commission order
--   lines which are connected to a given commission receiver.
PROCEDURE Change_Currency (
   commission_receiver_ IN VARCHAR2,
   currency_code_ IN VARCHAR2 )
IS
   curr_rate_            NUMBER;
   company_              VARCHAR2(20);
   curr_type_            currency_type_tab.currency_type%TYPE;
   conv_factor_          NUMBER;
   date_entered_         DATE;
   oldrec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   newrec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000);
   objversion_           VARCHAR2(2000);

   CURSOR get_com_lines IS
      SELECT order_no, line_no, rel_no, line_item_no, commission_line_no
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE commission_receiver = commission_receiver_
         AND rowstate <> 'Cancelled'
         AND currency_rate IS NOT NULL;
BEGIN
    -- update currency rate in corresponding order commission lines
   FOR rec_ IN get_com_lines LOOP
      oldrec_ :=  Lock_By_Keys___ (rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.commission_line_no);
      newrec_ := oldrec_;
      company_ := Site_API.Get_Company(newrec_.contract);
      date_entered_ := Customer_Order_Line_API.Get_Date_Entered (newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );
      invoice_library_API.Get_Currency_Rate_Defaults(
        curr_type_,
        conv_factor_,
        curr_rate_,
        company_,
        currency_code_,
        date_entered_,
        'CUSTOMER',
        NVL(Customer_Order_API.Get_Customer_No_Pay(rec_.order_no),newrec_.customer_no));
      newrec_.currency_rate := curr_rate_;
      Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   END LOOP;
END Change_Currency;


-- Copy_Commission_Lines
--   Removes the commission lines existing for the order line and
--   copies the originating line commission details to all new lines
--   which are created through sourcing the customer order line.
PROCEDURE Copy_Commission_Lines (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   con_line_no_      IN VARCHAR2,
   con_rel_no_       IN VARCHAR2,
   con_line_item_no_ IN NUMBER )
IS
   objid_         ORDER_LINE_COMMISSION.objid%TYPE;
   objversion_    ORDER_LINE_COMMISSION.objversion%TYPE;
   oldrec_        ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   newrec_        ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_          VARCHAR2(2000) := NULL;
   info_          VARCHAR2(2000);
   indrec_        Indicator_Rec;

   CURSOR get_old_order_rec IS
      SELECT *
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
      AND   line_no = con_line_no_
      AND   rel_no = con_rel_no_
      AND   line_item_no = con_line_item_no_;

   CURSOR get_new_line_rec IS
      SELECT commission_line_no
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN

   FOR get_line_rec_ IN get_new_line_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, get_line_rec_.commission_line_no);
      Remove__(info_,  objid_,  objversion_, 'DO');
   END LOOP;
   FOR get_old_line_rec_ IN get_old_order_rec LOOP
      attr_ := NULL;
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', get_old_line_rec_.contract, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', get_old_line_rec_.customer_no, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', get_old_line_rec_.commission_receiver, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE_DB', get_old_line_rec_.commission_line_source, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_CALC_BASE_DB', get_old_line_rec_.commission_calc_base, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE', get_old_line_rec_.commission_percentage, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE_CALC', get_old_line_rec_.commission_percentage_calc, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_AMOUNT', get_old_line_rec_.commission_amount, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_AMOUNT_CALC', get_old_line_rec_.commission_amount_calc, attr_);
      Client_SYS.Add_To_Attr('TOTAL_COMMISSION_AMOUNT', get_old_line_rec_.total_commission_amount, attr_);
      Client_SYS.Add_To_Attr('QTY', get_old_line_rec_.qty, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', get_old_line_rec_.discount, attr_);
      Client_SYS.Add_To_Attr('CALCULATION_DATE', get_old_line_rec_.calculation_date, attr_);
      Client_SYS.Add_To_Attr('IDENTITY_TYPE_DB', get_old_line_rec_.identity_type, attr_);
      Client_SYS.Add_To_Attr('AGREEMENT_ID', get_old_line_rec_.agreement_id, attr_);
      Client_SYS.Add_To_Attr('REVISION_NO', get_old_line_rec_.revision_no, attr_);
      Client_SYS.Add_To_Attr('GROUP_ID', get_old_line_rec_.group_id, attr_);
      Client_SYS.Add_To_Attr('STAT_CUST_GRP', get_old_line_rec_.stat_cust_grp, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', get_old_line_rec_.catalog_no, attr_);
      Client_SYS.Add_To_Attr('MARKET_CODE', get_old_line_rec_.market_code, attr_);
      Client_SYS.Add_To_Attr('COUNTRY_CODE', get_old_line_rec_.country_code, attr_);
      Client_SYS.Add_To_Attr('REGION_CODE', get_old_line_rec_.region_code, attr_);
      Client_SYS.Add_To_Attr('CATALOG_GROUP', get_old_line_rec_.catalog_group, attr_);
      Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ID', get_old_line_rec_.sales_price_group_id, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_NO', get_old_line_rec_.commission_no, attr_);
      Client_SYS.Add_To_Attr('PART_PRODUCT_FAMILY', get_old_line_rec_.part_product_family, attr_);
      Client_SYS.Add_To_Attr('COMMODITY_CODE', get_old_line_rec_.commodity_code, attr_);
      Client_SYS.Add_To_Attr('PART_PRODUCT_CODE', get_old_line_rec_.part_product_code, attr_);
      Client_SYS.Add_To_Attr('AMOUNT', get_old_line_rec_.amount, attr_);
      Client_SYS.Add_To_Attr('FIXED_COMMISSION_AMOUNT_DB', get_old_line_rec_.fixed_commission_amount, attr_);
      Client_SYS.Add_To_Attr('CURRENCY_RATE', get_old_line_rec_.currency_rate, attr_);
      Client_SYS.Add_To_Attr('TOTAL_ESTIMATED_COM_AMOUNT', get_old_line_rec_.total_estimated_com_amount, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_RECALC_FLAG', Commission_Recalc_Flag_API.Decode(get_old_line_rec_.commission_recalc_flag) , attr_);
      Client_SYS.Add_To_Attr('NOTE_ID', get_old_line_rec_.note_id, attr_);
      Client_SYS.Add_To_Attr('NOTE_TEXT', get_old_line_rec_.note_text, attr_);
      Client_SYS.Add_To_Attr('ORIGINAL_LINE_SOURCE_DB', get_old_line_rec_.original_line_source, attr_);
      Client_SYS.Add_To_Attr('CREATED_BY_SERVER', 1, attr_);
      Client_SYS.Add_To_Attr('LINE_EXCLUDE_FLAG_DB', get_old_line_rec_.line_exclude_flag, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_Commission_Lines;


-- Get_Sum_Due_Com_Amount
--   This function will return sum of all commission line's due amount
FUNCTION Get_Sum_Due_Com_Amount (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_com_lines IS
      SELECT commission_line_no
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate != 'Cancelled'
      ORDER BY commission_line_no;

      total_due_ NUMBER:=0;
BEGIN
   FOR com_rec_ IN get_com_lines LOOP
      total_due_ := total_due_ + Get_Total_Due_Com_Amount(order_no_,line_no_,rel_no_,line_item_no_,com_rec_.commission_line_no,'FALSE');
   END LOOP;
   RETURN total_due_;
END Get_Sum_Due_Com_Amount;

-- Has_Commission_Lines
--   This function will return true if the specified order line has non cancelled commission lines.
FUNCTION Has_Commission_Lines (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   found_              NUMBER; 
   CURSOR get_com_lines IS
      SELECT 1
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate != 'Cancelled';     
BEGIN
   OPEN get_com_lines;
   FETCH get_com_lines INTO found_;
   IF (get_com_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_com_lines;
   RETURN (found_ = 1);
END Has_Commission_Lines; 

-- Copy_Manual_Commission_Lines
--   Copies the manual commission lines exixts in the original customer order
PROCEDURE Copy_Manual_Commission_Lines (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   con_order_no_         IN VARCHAR2,
   con_line_no_          IN VARCHAR2,
   con_rel_no_           IN VARCHAR2,
   con_line_item_no_     IN NUMBER,
   copy_document_texts_  IN BOOLEAN,
   copy_notes_           IN BOOLEAN)
IS
   objid_         ORDER_LINE_COMMISSION.objid%TYPE;
   objversion_    ORDER_LINE_COMMISSION.objversion%TYPE;
   oldrec_        ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   newrec_        ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   attr_          VARCHAR2(2000) := NULL;
   indrec_        Indicator_Rec;

   CURSOR get_commission_line IS
      SELECT *
      FROM order_line_commission_tab
      WHERE order_no = con_order_no_
      AND   line_no = con_line_no_
      AND   rel_no = con_rel_no_
      AND   line_item_no = con_line_item_no_
      AND   commission_line_source = 'MANUAL';

BEGIN

   FOR get_commission_line_rec IN get_commission_line LOOP
      attr_ := NULL;
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', get_commission_line_rec.contract, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', get_commission_line_rec.customer_no, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', get_commission_line_rec.commission_receiver, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_LINE_SOURCE_DB', get_commission_line_rec.commission_line_source, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_CALC_BASE_DB', get_commission_line_rec.commission_calc_base, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE', get_commission_line_rec.commission_percentage, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_PERCENTAGE_CALC', get_commission_line_rec.commission_percentage_calc, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_AMOUNT', get_commission_line_rec.commission_amount, attr_);
      Client_SYS.Add_To_Attr('QTY', get_commission_line_rec.qty, attr_);
      Client_SYS.Add_To_Attr('IDENTITY_TYPE_DB', get_commission_line_rec.identity_type, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', get_commission_line_rec.catalog_no, attr_);
      Client_SYS.Add_To_Attr('AMOUNT', get_commission_line_rec.amount, attr_);
      Client_SYS.Add_To_Attr('FIXED_COMMISSION_AMOUNT_DB', get_commission_line_rec.fixed_commission_amount, attr_);
      Client_SYS.Add_To_Attr('COMMISSION_RECALC_FLAG_DB', get_commission_line_rec.commission_recalc_flag, attr_);
      Client_SYS.Add_To_Attr('ORIGINAL_LINE_SOURCE_DB', get_commission_line_rec.original_line_source, attr_);
      Client_SYS.Add_To_Attr('CREATED_BY_SERVER', 0, attr_);
      Client_SYS.Add_To_Attr('LINE_EXCLUDE_FLAG_DB', get_commission_line_rec.line_exclude_flag, attr_);
      IF (copy_document_texts_) THEN
         Client_SYS.Add_To_Attr('NOTE_ID', get_commission_line_rec.note_id, attr_);
      END IF;
      IF (copy_notes_) THEN
         Client_SYS.Add_To_Attr('NOTE_TEXT', get_commission_line_rec.note_text, attr_);
      END IF;      

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_Manual_Commission_Lines;

-- This method set the value for the line_exclude_flag
-- Valid values for the line_exclude_flag are 'TRUE' and 'FALSE'
PROCEDURE Set_Line_Exclude_Flag (
   order_no_          IN   VARCHAR2,
   line_no_           IN   VARCHAR2,
   rel_no_            IN   VARCHAR2,
   line_item_no_      IN   NUMBER,
   line_exclude_flag_ IN   VARCHAR2 )
IS
   CURSOR get_olc_line_no IS
     SELECT commission_line_no
     FROM ORDER_LINE_COMMISSION_TAB
     WHERE order_no = order_no_
           AND line_no = line_no_
           AND rel_no = rel_no_
           AND line_item_no = line_item_no_;
   new_olc_rec_               ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
BEGIN
   
   FOR rec_ IN get_olc_line_no LOOP
      new_olc_rec_ := Lock_By_Keys___ (order_no_, line_no_, rel_no_, line_item_no_, rec_.commission_line_no);
      new_olc_rec_.line_exclude_flag := line_exclude_flag_;
      Update___(NULL, NULL, new_olc_rec_, attr_, objversion_, TRUE);
   END LOOP;
END Set_Line_Exclude_Flag;
