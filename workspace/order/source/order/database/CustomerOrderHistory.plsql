-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderHistory
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  MaEelk  SC2020R1-11981, Modified New and replaced the logic Pack___, Unpack_Check_Insert___ and Insert___ with New___.
--  170505  niedlk  APPUXX-11508, Modified Get_Invoiced_Closed_Date function to be used in UXx.
--  160603  Dinklk  APPUXX-1560, Added a new function Get_Invoiced_Closed_Date to be used in UXx.
--  160111  JeeJlk  Bug 125118, Modified Insert___ to assign hist_state column customer order objstate value.
--  120821  MalLlk  Bug 102753, Modified the procedure New() by adding a new parameter.
--  120319  ErFelk  Bug 101638, Increased the length of attr_ to 32000 in New Procedure.
--  070510  RaKalk  Changed the length of the CUSTOMER_ORDER_HISTORY.MESSAGE_TEXT to 2000
--  040224  IsWilk  Removed the SUBSTRB from for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  020308  NaWa  Bug fix 26407 Made both date/time inserted in the table, by Removing the SQL command 'TRUNC'
--                From the fied 'DATE_ENTERED'
--  010508  MaGu  Bug fix 21382. Added perfomance enhancements to method Insert___.
--                Moved fetch of nextval to inside the INSERT statement.
--                Use RETURNING statement instead of another SELECT for fetching objid_.
--  --------------------------- 13.0 ----------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990414  RaKu  New template.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  971120  RaKu  Changed to FND200 Templates.
--  970527  JOED  Added state as message text if null when insert.
--  970417  JOED  Removed objstate from New parameter list.
--  970416  JOED  Renamed column status_code to objstate.
--                Changed message_text to not mandatory.
--  970312  RaKu  Changed table name.
--  970218  EVWE  Changed to rowversion (10.3 Project)
--  960409  RaKu  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_HISTORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no := oehistory_no.nextval;
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.hist_state IS NULL) THEN
      newrec_.hist_state := Customer_Order_API.Get_Objstate(newrec_.hist_state);
   END IF;
   Client_SYS.Add_To_Attr('HISTORY_NO', newrec_.history_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new instance.
PROCEDURE New (
   order_no_     IN VARCHAR2,
   message_text_ IN VARCHAR2 DEFAULT NULL,
   objstate_     IN VARCHAR2 DEFAULT NULL )
IS
   newrec_     CUSTOMER_ORDER_HISTORY_TAB%ROWTYPE;
   hist_state_ CUSTOMER_ORDER_HISTORY_TAB.hist_state%TYPE;
BEGIN
   hist_state_ := NVL(objstate_, Customer_Order_API.Get_Objstate(order_no_));
   
   newrec_.order_no := order_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_));
   newrec_.userid := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      newrec_.message_text :=  Customer_Order_API.Finite_State_Decode__(hist_state_);
   ELSE
       newrec_.message_text := message_text_;
   END IF;   
   newrec_.hist_state := hist_state_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Hist_State (
   history_no_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   CUSTOMER_ORDER_HISTORY_TAB
      WHERE  history_no = history_no_;

   hist_state_  VARCHAR2(20);
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Customer_Order_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;

-- This function is used in UXx pages
FUNCTION Get_Invoiced_Closed_Date (
   order_no_     IN VARCHAR2 ) RETURN DATE
IS
   CURSOR get_inv_closed_date IS
      SELECT MAX(date_entered)
      FROM   CUSTOMER_ORDER_HISTORY_TAB
      WHERE  hist_state = 'Invoiced'
      AND order_no = order_no_;

   date_entered_  DATE;
BEGIN
   OPEN get_inv_closed_date;
   FETCH get_inv_closed_date INTO date_entered_;
   CLOSE get_inv_closed_date;
   RETURN date_entered_;
END Get_Invoiced_Closed_Date;

