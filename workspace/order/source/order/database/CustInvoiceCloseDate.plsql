-----------------------------------------------------------------------------
--
--  Logical unit: CustInvoiceCloseDate
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181114  SeJalk  SCUXXW4-14167, Validate Day of month to only enter an integer.
--  170201  NiDalk  Bug 131941, Modified Get_Closest_Closing_Day to consider offset when calculating the closest closing day. 
--  170201          Modified Get_Planned_Invoice_Date calculation to be based on delivery date and invoice date. Planned invoice date is 
--  170201          calculated as the closest close date greater than the last invoice date and the delivery date.
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method to add new parameter copy_info_
--  141025  SBalLK  Bug 119103, Added Copy_Customer() method to copy LU information when copying from existing customer.
--  140916  AyAmlk   Bug 118567, Modified Get_Planned_Invoice_Date() by reversing the bug 89154 correction and modified the code
--  140916           in order to prevent fetching a date from the past as the Planned Invoice Date.
--  120220  MeAblk   Bug 101093, Modified Get_Closest_Closing_Day() to return max_closing_day if today is greater than all closing dates.
--  120125  HimRlk   Bug 100389, Modified Get_Closest_Closing_Day() to return the minimum closing date when sysdate is greater than
--  120125           maximum closing date of the customer.
--  100513  Ajpelk  Merge rose method documentation
------------------------------Eagle---------------------------------------------
--  100323  SuThlk   Bug 89452, Modified cursor get_next_closing_date in Get_Planned_Invice_Date to select the future date.
--  100318  SuThlk   Bug 89154, Modified Get_Closest_Closing_Day and Get_Planned_Invice_Date to calculate correctly.
--  080229  MaMalk   Bug 72023, Modified methods Check_Closing_Dates and Check_Month_End to close open cursors.
--  060418  SaRalk   Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  050916  MaEelk   Modified Get_Planned_Invice_Date to get correct dates for planned incoice date.
--  050916           Considered LastInvoice Date in calculations
--  050816  IsWilk   Modified the PROCEDURE Unpack_Check_Update___ to compare the 
--  050816           validations with oldrec_.
--  050727  MaEelk   Modified Get_Closest_Closing_Day in order to calculate closing date 
--  050727           correctly for the month end.
--  050622  MaEelk   Modified the error message we get when having a closing date with a cycle interval.
--  050620  MaEelk   Modified the error message in Validate_Day_Of_Month.
--  050615  MaEelk   Modified Get_Planed_Invoice_Date. Moved the code of fetching
--  050615           last_invoice_date_ outside the IF Condittion. 
--  050610  IsWilk   Modified the PROCEDURE Unpack_Check_Insert___ to set the 
--  050610           default values to month_end.  
--  050525  IsWilk   Added FUNCTIONs Get_Closest_Closing_Day,Get_Planned_Invoice_Date
--  050525           and Check_Month_End.
--  050520  IsWilk   Added the PROCEDUREs Validate_Day_Of_Month, Validate_Month_End,
--  050520           Remove_Closing_Dates and FUNCTION Check_Closing_Dates and
--  050520           modified the PROCEDUREs Unpack_Check_Insert___ and
--  050520           Unpack_Check_Update___ to added the validations.
--  050517  IsWilk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MONTH_END_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_invoice_close_date_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   cyclic_period_ NUMBER;
BEGIN
   IF (NOT indrec_.month_end) THEN   
      newrec_.month_end := 'FALSE';
   END IF;
   IF (newrec_.customer_no IS NULL) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   END IF;
   IF (Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
      Cust_Ord_Customer_API.Exist(newrec_.customer_no);
   END IF;
   IF (newrec_.line_no IS NULL) THEN
      Get_Line_No__(newrec_.line_no, newrec_.customer_no);
   END IF;

   IF (newrec_.month_end = 'FALSE') AND (newrec_.day_of_month IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NEEDCLOSEDDATE: Closing Dates should have a value.');
   END IF;

   cyclic_period_ := Cust_Ord_Customer_API.Get_Cycle_Period(newrec_.customer_no);
   IF (cyclic_period_ !=0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOCLOSINGDATEALLOW: Closing Dates cannot be defined with a Cycle Interval.');
   END IF;

   Validate_Day_Of_Month(newrec_.customer_no, newrec_.day_of_month);

   Validate_Month_End(newrec_.customer_no, newrec_.month_end);
   
   super(newrec_, indrec_, attr_);

   IF (newrec_.day_of_month >= 31)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH1: Day of Month cannot be 31 or higher. Select End of Month instead.');
   END IF;

   IF (newrec_.day_of_month <= 0)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH2: Day of Month cannot be 0 or lesser. Select a valid date instead.');
   END IF;
   
   IF (FLOOR(newrec_.day_of_month) != newrec_.day_of_month)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH3: Day of Month must be an integer. Please select a valid date.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_invoice_close_date_tab%ROWTYPE,
   newrec_ IN OUT cust_invoice_close_date_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   cyclic_period_ NUMBER;   
BEGIN
   IF (Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
       Error_SYS.Item_Update(lu_name_, 'CUSTOMER_ID');
   END IF;
   IF (newrec_.month_end = 'FALSE') AND (newrec_.day_of_month IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NEEDCLOSEDDATE: Closing Dates should have a value.');
   END IF;

   cyclic_period_ := Cust_Ord_Customer_API.Get_Cycle_Period(newrec_.customer_no);
   IF (cyclic_period_ !=0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOCLOSINGDATEALLOW: Closing Dates cannot be defined with a Cycle Interval.');
   END IF;

   IF (newrec_.day_of_month != oldrec_.day_of_month) THEN
      Validate_Day_Of_Month(newrec_.customer_no, newrec_.day_of_month);
   END IF;

   IF (newrec_.month_end != oldrec_.month_end) THEN
      Validate_Month_End(newrec_.customer_no, newrec_.month_end);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.day_of_month >= 31)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH1: Day of Month cannot be 31 or higher. Select End of Month instead.');
   END IF;

   IF (newrec_.day_of_month <= 0)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH2: Day of Month cannot be 0 or lesser. Select a valid date instead.');
   END IF;
   IF (FLOOR(newrec_.day_of_month) != newrec_.day_of_month)  THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDAYOFMONTH3: Day of Month must be an integer. Please select a valid date.');
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Line_No__
--   This procedure is executing when entering new lines and out the line no
--   this is a simple number sequence.
PROCEDURE Get_Line_No__ (
   line_no_     IN OUT NUMBER,
   customer_no_ IN VARCHAR2 )
IS
   CURSOR get_line_no IS
    SELECT MAX(line_no)
    FROM   cust_invoice_close_date_tab
    WHERE  customer_no = customer_no_;
BEGIN
   OPEN get_line_no;
   FETCH get_line_no INTO line_no_;
   IF (line_no_ IS NULL) THEN
      line_no_ := 1;
   ELSE
      line_no_ := line_no_ + 1;
   END IF;
   CLOSE get_line_no;
END Get_Line_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Closest_Closing_Day
--   This function return the closest closing day for the given
--   customer and contract.
@UncheckedAccess
FUNCTION Get_Closest_Closing_Day(
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2,
   offset_      IN NUMBER     DEFAULT 0) RETURN DATE 
IS
   closest_closing_date_ DATE;
   site_offset_          NUMBER;

   CURSOR closest_closing_day IS
      SELECT MAX(CASE
                WHEN MONTH_END = 'TRUE'
                     AND TRUNC(LAST_DAY(SYSDATE + offset_)) = TRUNC(SYSDATE + offset_) THEN
                 TRUNC(SYSDATE + offset_)
                WHEN MONTH_END = 'TRUE' THEN
                 TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE + offset_, -1)))
                WHEN EXTRACT(DAY FROM SYSDATE + offset_) < DAY_OF_MONTH THEN
                 ADD_MONTHS(TRUNC(SYSDATE + offset_, 'MM'), -1) + DAY_OF_MONTH - 1
                ELSE
                 TRUNC(SYSDATE + offset_, 'MM') + DAY_OF_MONTH - 1
             END) Last_date
      FROM CUST_INVOICE_CLOSE_DATE_TAB t
      WHERE CUSTOMER_NO = customer_no_;
BEGIN
   IF Check_Closing_Dates(customer_no_) = 'FALSE' THEN
      RETURN NULL;
   END IF;

   site_offset_ := Site_API.Get_Offset(contract_) / 24;

   OPEN closest_closing_day;
   FETCH closest_closing_day
      INTO closest_closing_date_;
   CLOSE closest_closing_day;

   RETURN TRUNC(closest_closing_date_) + site_offset_;
END Get_Closest_Closing_Day;


-- Get_Planned_Invoice_Date
--   This function return the planned invoice date i.e calculated invoice date
--   based on the last invoice date and delivery date. Planned invoice date is closest close date 
--   greater than the delivery date and the last invoice date. Returned it for the given customer.
@UncheckedAccess
FUNCTION Get_Planned_Invoice_Date(
   customer_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   delivery_date_    IN DATE      DEFAULT NULL ) RETURN DATE 
IS
   last_invoice_date_ DATE;
   cycle_period_      NUMBER;
   next_closing_date_ DATE;
   min_date_          DATE;

   -- There is no risk to using CUST_ORD_CUSTOMER_TAB.LAST_IVC_DATE here, since we check for null value before using cursor.
   CURSOR Get_Next_Closing_Date IS
      SELECT MIN(CASE
                WHEN MONTH_END = 'TRUE'
                     AND LAST_DAY(min_date_) > min_date_ THEN
                -- There is a last day of month after our last invoice date
                 LAST_DAY(min_date_)
                WHEN MONTH_END = 'TRUE' THEN
                -- The last invoice date was on the last day of the month, so show next month last date
                 LAST_DAY(ADD_MONTHS(min_date_, 1))
                WHEN EXTRACT(DAY FROM min_date_) > DAY_OF_MONTH THEN
                -- The last invoice date was after this day of month
                 ADD_MONTHS(TRUNC(min_date_, 'MM'), 1) + DAY_OF_MONTH - 1
                ELSE
                -- Last chance, the day of month is upcoming
                 TRUNC(min_date_, 'MM') + DAY_OF_MONTH - 1
             END) Next_date
       FROM CUST_INVOICE_CLOSE_DATE_TAB d
       WHERE d.CUSTOMER_NO = customer_no_;
      
BEGIN
   last_invoice_date_ := Cust_Ord_Customer_API.Get_Last_Ivc_Date(customer_no_);

   IF last_invoice_date_ IS NULL THEN
      RETURN NULL;
   END IF;
   
   min_date_ := TRUNC(NVL(delivery_date_, last_invoice_date_));
   
   IF (min_date_ <= last_invoice_date_) THEN
      last_invoice_date_ := last_invoice_date_;
   END IF;
 
   ---site_offset_ := Site_API.Get_Offset(contract_) / 24;
   IF (Check_Closing_Dates(customer_no_) = 'TRUE') THEN
      -- Use the cursor to get the first closing date 
      OPEN get_next_closing_date;
      FETCH get_next_closing_date
         INTO next_closing_date_;
      CLOSE get_next_closing_date;

      RETURN next_closing_date_;
   END IF;

   -- Use the existing method. i.e. Last Ivc Date + Cycle Interval
   cycle_period_ := Cust_Ord_Customer_API.Get_Cycle_Period(customer_no_);
   
   IF cycle_period_ > 0 THEN
      next_closing_date_ := last_invoice_date_ + cycle_period_;
      WHILE  (next_closing_date_ < delivery_date_) LOOP 
         next_closing_date_ := next_closing_date_ + cycle_period_;   
      END LOOP;
      RETURN TRUNC(next_closing_date_);
   ELSE
      RETURN NULL;
   END IF;

END Get_Planned_Invoice_Date;


-- Validate_Day_Of_Month
--   This procedure validate the attribute Day Of Month and executing when
--   inserting and modifying.
PROCEDURE Validate_Day_Of_Month (
   customer_no_  IN VARCHAR2,
   day_of_month_ IN NUMBER )
IS
   CURSOR get_day IS
      SELECT day_of_month
      FROM   CUST_INVOICE_CLOSE_DATE_TAB
      WHERE  month_end = 'FALSE'
      AND    customer_no = customer_no_;
BEGIN
   FOR rec_ IN get_day LOOP
      IF (day_of_month_ = rec_.day_of_month) THEN
         Error_SYS.Record_General(lu_name_, 'DUPLICATEDAY: You have already specified :P1 for Day of Month. Please specify a different value.',rec_.day_of_month);
      END IF;
   END LOOP;
END Validate_Day_Of_Month;


-- Validate_Month_End
--   This procedure validate the attribute Month End and executing when
--   inserting and modifying.
PROCEDURE Validate_Month_End (
   customer_no_  IN VARCHAR2,
   month_end_db_ IN VARCHAR2 )
IS                            
BEGIN
   IF (Check_Month_End(customer_no_) = 'TRUE') THEN   
      IF (month_end_db_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDMONTHEND: Month End already exist.');
      END IF;
   END IF;
   
END Validate_Month_End; 


-- Remove_Closing_Dates
--   This procedure remove the all the closing dates records for the specific
PROCEDURE Remove_Closing_Dates (
   customer_no_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_lines IS
      SELECT line_no
      FROM CUST_INVOICE_CLOSE_DATE_TAB
      WHERE customer_no = customer_no_;

BEGIN
   FOR rec_ IN get_lines LOOP
      IF (Check_Exist___(customer_no_, rec_.line_no)) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, customer_no_, rec_.line_no);
         Remove__(info_, objid_, objversion_, 'DO');
      END IF;
   END LOOP;
END Remove_Closing_Dates;


-- Check_Closing_Dates
--   This function check whether the customer define closing dates.
--   Return TRUE if closing dates exist
@UncheckedAccess
FUNCTION Check_Closing_Dates (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_          NUMBER;

   CURSOR check_close_dates IS
      SELECT 1
      FROM   CUST_INVOICE_CLOSE_DATE_TAB
      WHERE  customer_no = customer_no_;
BEGIN
   OPEN check_close_dates;
   FETCH check_close_dates INTO dummy_;
   IF (check_close_dates%FOUND) THEN
      CLOSE check_close_dates;
      RETURN 'TRUE';
   ELSE
      CLOSE check_close_dates;
      RETURN 'FALSE';
   END IF;    
END Check_Closing_Dates;


-- Check_Month_End
--   This function check if the month end is true or false for
--   the given customer.
@UncheckedAccess
FUNCTION Check_Month_End (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;

   CURSOR check_month_end IS
      SELECT 1
      FROM   CUST_INVOICE_CLOSE_DATE_TAB
      WHERE  month_end ='TRUE'
      AND    customer_no = customer_no_;
BEGIN
   OPEN check_month_end;
   FETCH check_month_end INTO dummy_;
   IF (check_month_end%FOUND) THEN
      CLOSE check_month_end;
      RETURN 'TRUE';
   ELSE
      CLOSE check_month_end;
      RETURN 'FALSE';
   END IF;     
END Check_Month_End;


-- Copy_Customer
--    This method copy customer invoice dates to new customer if
--    defined in the source customer.
PROCEDURE Copy_Customer (
   customer_no_   IN VARCHAR2,
   new_id_        IN VARCHAR2,
   copy_info_     IN  Customer_Info_API.Copy_Param_Info)
IS
   CURSOR get_invoice_date_info IS
      SELECT line_no, day_of_month, month_end
      FROM   CUST_INVOICE_CLOSE_DATE_TAB
      WHERE customer_no = customer_no_
      ORDER BY line_no;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(200);
   newrec_     CUST_INVOICE_CLOSE_DATE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   IF(new_id_ IS NOT NULL) THEN
      FOR rec_ IN get_invoice_date_info LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_, attr_);
         Client_SYS.Add_To_Attr('LINE_NO', rec_.line_no, attr_);
         Client_SYS.Add_To_Attr('DAY_OF_MONTH', rec_.day_of_month, attr_);
         Client_SYS.Add_To_Attr('MONTH_END_DB', rec_.month_end, attr_);
         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
      -- Since discard the info in method it is possible to use private New method.
      -- But didn't use New_() method here since this is public server method.
      Client_SYS.Clear_Info;
   END IF;
END Copy_Customer;