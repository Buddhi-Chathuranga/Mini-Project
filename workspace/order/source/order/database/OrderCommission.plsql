-----------------------------------------------------------------------------
--
--  Logical unit: OrderCommission
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110202  Nekolk  EANE-3744  added where clause to View ORDER_COMMISSION.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070123  Nuvelk  Added the general  General_SYS.Init_Method declaration to Get_Total_Curr_Amount(),since Pragma declaration was removed from the API 
--  070123          (this was necessary to support the modification done to the referencing function Order_Line_Commission_API.Get_Com_Receiver_Amount().
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040220  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  --------------- Edge Package Group 3 Unicode Changes------------------------
--  010528  JSAnse  Bug 21463, added call to General_SYS.Init_Method in procedure New.
--  000719  TFU     Merging from Chameleon
--  000517  BRO     Allowed the note_text to be changed from the client
--  000510  DEHA    Reoved using of view order_line_commission
--  000509  DEHA    Added fields note_id, note_text. 
--  000508  BRO     Added procedure Set_Last_Calculation_Date
--  000504  BRO     Changed the period until date to current date if closed in advance
--  000502  BjSa    Moved not null check for commission_no to Insert___
--  000420  DEHA    Implemented the methods Get_Total_Curr_Amount
--  000419  DEHA    Implemented the methods Close_Order_Commission,
--                  Get_Total_Base_Amount.
--  000417  BRO     Forbiden the change of the calc status if finally calculated
--  000410  DEHA    Recreated based on the model changes from 10/04/2000.
--  000406  BRO     Created
--  000406  DEHA    Created.
--  ----------------------------- 12.1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_COMMISSION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR fetch_commission_no IS
    SELECT order_commission_seq.NEXTVAL
    FROM dual;
BEGIN
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   OPEN fetch_commission_no;
   FETCH fetch_commission_no INTO newrec_.commission_no;
   CLOSE fetch_commission_no;
   Error_SYS.Check_Not_Null(lu_name_, 'COMMISSION_NO', newrec_.commission_no);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_commission_tab%ROWTYPE,
   newrec_ IN OUT order_commission_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- changes on closed, cancelled com. lines are not allowed
   IF (newrec_.commission_calc_status = 'FINALLYCALCULATED') THEN
      IF (indrec_.commission_no OR indrec_.period_from OR indrec_.period_until
          OR indrec_.last_calculation_date OR indrec_.commission_calc_status
          OR indrec_.commission_receiver OR indrec_.contract OR indrec_.note_id) THEN
         -- excepted changes on notes text
         Error_SYS.Record_General(lu_name_, 'FINALLYCALCULATED: Changes on a finally calculated item are not allowed.');
      END IF;  
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Total_Base_Amount
--   Public method for calculating the total commission amount in base (site)
--   currency for a commission header.
@UncheckedAccess
FUNCTION Get_Total_Base_Amount (
   commission_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_amount_         NUMBER;
   CURSOR get_total_com_amount IS
      SELECT sum(total_commission_amount)
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE commission_no = commission_no_
        AND rowstate != 'Cancelled';
BEGIN
   -- fetch the total amount for all corresponding order commission lines in base currency
   OPEN get_total_com_amount;
   FETCH get_total_com_amount INTO total_base_amount_;
   IF get_total_com_amount%NOTFOUND OR
      get_total_com_amount%NOTFOUND IS NULL THEN
      total_base_amount_ := 0;
   END IF;
   CLOSE get_total_com_amount;
   RETURN total_base_amount_;
END Get_Total_Base_Amount;


-- Get_Total_Curr_Amount
--   Public mehtod for calculating the total commission amount in the
--   commission receivers currency for a commission header.
FUNCTION Get_Total_Curr_Amount (
   commission_no_ IN NUMBER ) RETURN NUMBER
IS
   total_currency_amount_        NUMBER;

   CURSOR get_total_com_amount IS
      SELECT order_no, line_no, rel_no, line_item_no, commission_line_no
      FROM ORDER_LINE_COMMISSION_TAB
      WHERE commission_no = commission_no_
        AND rowstate != 'Cancelled';
BEGIN
   total_currency_amount_ := 0;
   FOR rec_ IN get_total_com_amount LOOP

      total_currency_amount_ :=
         total_currency_amount_ +
         ORDER_LINE_COMMISSION_API.Get_Com_Receiver_Amount(
                                      rec_.order_no,
                                      rec_.line_no,
                                      rec_.rel_no,
                                      rec_.line_item_no,
                                      rec_.commission_line_no);
   END LOOP;
   RETURN total_currency_amount_;
END Get_Total_Curr_Amount;


-- Set_Last_Calculation_Date
--   Public mehtod for setting the last calculation date.
PROCEDURE Set_Last_Calculation_Date (
   commission_no_ IN NUMBER,
   calc_date_ IN DATE DEFAULT NULL )
IS
   new_rec_       ORDER_COMMISSION_TAB%ROWTYPE;
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
BEGIN
   new_rec_ := Lock_By_Keys___ (commission_no_);
   new_rec_.last_calculation_date := NVL(calc_date_, Site_API.Get_Site_Date(Get_Contract(commission_no_)));
   Update___(NULL, NULL, new_rec_, attr_, objversion_, TRUE);
END Set_Last_Calculation_Date;


-- New
--   Public mehtod for inserting a new commission header.
PROCEDURE New (
   commission_no_ OUT NUMBER,
   period_from_ IN DATE,
   period_until_ IN DATE,
   commission_receiver_ IN VARCHAR2,
   contract_ IN VARCHAR2 )
IS
   newrec_                 ORDER_COMMISSION_TAB%ROWTYPE;
   attr_                   VARCHAR2(2000);
   objid_                  VARCHAR2(200);
   objversion_             VARCHAR2(200);
   indrec_                 Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('PERIOD_FROM', period_from_, attr_);
   Client_SYS.Add_To_Attr('PERIOD_UNTIL', period_until_, attr_);
   Client_SYS.Add_To_Attr('LAST_CALCULATION_DATE', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('COMMISSION_CALC_STATUS_DB', 'CALCULATED', attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', commission_receiver_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);

   Insert___(objid_, objversion_, newrec_, attr_);

   commission_no_ := newrec_.commission_no;
END New;


-- Close_Order_Commission
--   Public method for closing a commission header (set it to finally calculated).
PROCEDURE Close_Order_Commission (
   commission_no_       IN NUMBER)
IS
   order_com_rec_       ORDER_COMMISSION_TAB%ROWTYPE;
   current_date_        DATE;
   attr_                VARCHAR2(2000);
   dummy_objversion_    VARCHAR2(2000);
BEGIN
   -- close corresponding order commission lines
   ORDER_LINE_COMMISSION_API.Close_From_Header(commission_no_);
   -- set the status of the order commission (header) to "Finally Calculated"
   order_com_rec_ := Lock_By_Keys___ (commission_no_);
   order_com_rec_.commission_calc_status := 'FINALLYCALCULATED';
   -- check if the current date is in the period and if necessary, shorten the period
   current_date_ := TRUNC(Site_API.Get_Site_Date(order_com_rec_.contract));
   IF (current_date_ < order_com_rec_.period_until) THEN
      order_com_rec_.period_until := GREATEST(current_date_, order_com_rec_.period_from);
   END IF;
   Update___(NULL, NULL, order_com_rec_, attr_, dummy_objversion_, TRUE);
END Close_Order_Commission;



