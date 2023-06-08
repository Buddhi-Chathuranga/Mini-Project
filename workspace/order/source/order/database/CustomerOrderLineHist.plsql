-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderLineHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210727  MiKulk SC21R2-2058, Added a new method Get_Invoiced_Closed_Date.
--  210107  MaEelk SC2020R1-11981, Modified New and replaced the logic Pack___, Unpack_Check_Insert___ and Insert___ with New___
--  160111  JeeJlk Bug 125118, Modified Insert___ to assign hist_state column customer order line objstate value.
--  140723  Vwloza Added Get_Created_Date() and Get_Created_Userid().
--  130307  SudJlk Bug 108372, Increased message_text column length up to 2000.
--  120510  Darklk Bug 102362, Modified the procedure New by adding a new parameter in order to override the objstate.
--  120127  ChJalk Added view comments for the column state in the base view.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_ORDER_LINE_HIST.
--  071119  MaRalk Bug 67755, Modified message_text column length in CUSTOMER_ORDER_LINE_HIST view.
--  071119         Modified function Get_Message.     
--  070123  NaWilk Added derived attribute Contract.
--  040224  IsWilk Removed SUBSTRB for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  031008  PrJalk Bug Fix 106224, Added Missing General_Sys.Init_Method calls.
--  030804  ChFolk Performed SP4 Merge. (SP4Only)
--  030429  ErSolk Bug 37057, Added new function 'Get_Message'.
--  020308  NaWa  Bug fix 26407 Made both date/time inserted in the table, by Removing the SQL command 'TRUNC'
--                From the fied 'DATE_ENTERED'
--  010508  MaGu  Bug fix 21382. Added perfomance enhancements to method Insert___.
--                Moved fetch of nextval to inside the INSERT statement.
--                Use RETURNING statement instead of another SELECT for fetching objid_.
--  --------------------------- 13.0 ----------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990414  RaKu  New templates.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  971120  RaKu  Changed to FND200 Templates.
--  970527  JOED  Added state as message text if null when insert.
--  970418  JoAn  Set reference on line_item_no to NOCHECK
--  970417  JOED  Removed objstate from New parameter list.
--  970416  JOED  Renamed column status_code to objstate.
--  970312  RaKu  Changed table name.
--  970219  EVWE  Changed to rowversion (10.3 Project)
--  951106  STOL  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_LINE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no := oehistory_no.nextval;
   IF (newrec_.hist_state IS NULL) THEN
      newrec_.hist_state := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;
   super(objid_, objversion_, newrec_, attr_);

   Client_SYS.Add_To_Attr('HISTORY_NO', newrec_.history_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_line_hist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (Client_SYS.Item_Exist('CONTRACT', attr_)) THEN
         Error_SYS.Item_Insert(lu_name_, 'CONTRACT');
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_line_hist_tab%ROWTYPE,
   newrec_ IN OUT customer_order_line_hist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (Client_SYS.Item_Exist('CONTRACT', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CONTRACT');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove
--   Removes all records.
PROCEDURE Remove (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   remrec_ CUSTOMER_ORDER_LINE_HIST_TAB%ROWTYPE;

   CURSOR get_record IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   FOR rec_ IN get_record LOOP
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   END LOOP;
END Remove;


-- New
--   Inserts new record.
PROCEDURE New (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT NULL,
   objstate_     IN VARCHAR2 DEFAULT NULL )
IS
   newrec_     CUSTOMER_ORDER_LINE_HIST_TAB%ROWTYPE;
   hist_state_ CUSTOMER_ORDER_LINE_HIST_TAB.hist_state%TYPE;
BEGIN
   hist_state_ := NVL(objstate_, Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_));
   newrec_.order_no := order_no_;
   newrec_.line_no := line_no_;
   newrec_.rel_no := rel_no_;
   newrec_.line_item_no := line_item_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_));
   newrec_.userid := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      newrec_.message_text := Customer_Order_Line_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;   
   newrec_.hist_state := hist_state_;
   New___(newrec_);  
END New;


-- Get_Message
--   Returns the Message Text with the Pick List No.
FUNCTION Get_Message (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN VARCHAR2
IS
   message_text_  CUSTOMER_ORDER_LINE_HIST_TAB.message_text%TYPE;

   CURSOR check_history_cur IS
      SELECT message_text
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  order_no       = order_no_
      AND    line_no        = line_no_
      AND    rel_no         = rel_no_
      AND    line_item_no   = line_item_no_
      AND    hist_state     ='Reserved'
      AND    history_no     = ( SELECT MAX(history_no)
                                   FROM   CUSTOMER_ORDER_LINE_HIST_TAB
                                   WHERE  order_no       = order_no_
                                   AND    line_no        = line_no_
                                   AND    rel_no         = rel_no_
                                   AND    line_item_no   = line_item_no_
                                   AND    hist_state     ='Reserved');

BEGIN
   OPEN check_history_cur;
   FETCH check_history_cur INTO message_text_;
   CLOSE check_history_cur;
   RETURN message_text_;
END Get_Message;

@UncheckedAccess
FUNCTION Get_Hist_State (
   history_no_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  history_no = history_no_;

   hist_state_  VARCHAR2(20);
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Customer_Order_Line_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;

-- Get_Created_Date
--   Returns the created date_entered from history.
@UncheckedAccess
FUNCTION Get_Created_Date (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN DATE
IS
   date_entered_  CUSTOMER_ORDER_LINE_HIST_TAB.date_entered%TYPE;
   CURSOR get_created_date IS
      SELECT date_entered
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  order_no       = order_no_
      AND    line_no        = line_no_
      AND    rel_no         = rel_no_
      AND    line_item_no   = line_item_no_
      ORDER BY history_no;
BEGIN
   OPEN get_created_date;
   FETCH get_created_date INTO date_entered_;
   CLOSE get_created_date;
   RETURN date_entered_;
END Get_Created_Date;

-- Get_Created_Userid
--   Returns the created user_id from history.
@UncheckedAccess
FUNCTION Get_Created_Userid (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN VARCHAR2
IS
   userid_  CUSTOMER_ORDER_LINE_HIST_TAB.userid%TYPE;
   CURSOR get_userid IS
      SELECT userid
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  order_no       = order_no_
      AND    line_no        = line_no_
      AND    rel_no         = rel_no_
      AND    line_item_no   = line_item_no_
      ORDER BY history_no;
BEGIN
   OPEN get_userid;
   FETCH get_userid INTO userid_;
   CLOSE get_userid;
   RETURN userid_;
END Get_Created_Userid;


-- Get_Invoiced_Closed_Date
--   Returns the last invoiced closed date
FUNCTION Get_Invoiced_Closed_Date (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN DATE
IS
   CURSOR get_inv_closed_date IS
      SELECT MAX(date_entered)
      FROM   CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE  hist_state     = 'Invoiced'
      AND    order_no       = order_no_
      AND    line_no        = line_no_
      AND    rel_no         = rel_no_
      AND    line_item_no   = line_item_no_;
   date_entered_  DATE;
BEGIN
   OPEN get_inv_closed_date;
   FETCH get_inv_closed_date INTO date_entered_;
   CLOSE get_inv_closed_date;
   RETURN date_entered_;
END Get_Invoiced_Closed_Date;