-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotationHistory
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210112  RavDlk  SC2020R1-12037, Removed unnecessary packing and unpacking of attrubute string in New
--  160111  JeeJlk  Bug 125118, Modified Insert___ to assign hist_state column order quotation objstate value.
--  120319  ErFelk  Bug 101638, Increased the length of message_text to 2000 in the base view comments.
--  120319          Also Increased the length of attr_ to 32000 in New procedures. 
--  120127  ChJalk  Added column State to the base view.
--  110818  NaLrlk  Bug 95520, Increased the length of columns OLD_VALUE and NEW_VALUE in view ORDER_QUOTATION_HISTORY.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------------------13.3.0-------------------------------
--  000712  LUDI  Merged from Chameleon
-----------------------------------------------------------------------------
--  000517  GBO   Corrected bug with DB values ( event / location )
--  000516  LUDI  New fields
--  000510  GBO   Added Cascade delete
--  000410  TFU   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTATION_HISTORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_History_No__( newrec_.history_no, newrec_.quotation_no);
   IF (newrec_.hist_state IS NULL) THEN
      newrec_.hist_state := Order_Quotation_API.Get_Objstate(newrec_.quotation_no);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_History_No__
--   Gets the next history number for this rma.
PROCEDURE Get_History_No__ (
   history_no_   IN OUT VARCHAR2,
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_history_no IS
      SELECT max(to_number(history_no))
      FROM   ORDER_QUOTATION_HISTORY_TAB
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN get_history_no;
   FETCH get_history_no INTO history_no_;
   IF history_no_ IS NULL THEN
      history_no_ := 1;
   ELSE
      history_no_ := to_number(history_no_) +1;
   END IF;
   CLOSE get_history_no;
END Get_History_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new instance
--   Creates a new instance
PROCEDURE New (
   quotation_no_ IN VARCHAR2,
   event_        IN VARCHAR2,
   old_value_    IN VARCHAR2,
   new_value_    IN VARCHAR2,
   logical_unit_ IN VARCHAR2,
   id_key_       IN VARCHAR2,
   revision_no_  IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT Null )
IS
   newrec_     ORDER_QUOTATION_HISTORY_TAB%ROWTYPE;
   hist_state_ ORDER_QUOTATION_HISTORY_TAB.hist_state%TYPE;
BEGIN
   hist_state_          := Order_Quotation_API.Get_Objstate(quotation_no_);
   newrec_.quotation_no := quotation_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Order_Quotation_API.Get_Contract(quotation_no_));
   newrec_.userid       := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      newrec_.message_text := Order_Quotation_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   newrec_.event        := event_;
   newrec_.old_value    := old_value_;
   newrec_.new_value    := new_value_;
   newrec_.location     := logical_unit_;
   newrec_.location_ref := id_key_;
   newrec_.revision_no  := revision_no_;
   newrec_.hist_state   := hist_state_;
   New___(newrec_);
END New;


-- New
--   Creates a new instance
--   Creates a new instance
PROCEDURE New (
   quotation_no_ IN VARCHAR2,
   message_text_ IN VARCHAR2 DEFAULT Null )
IS
   newrec_     ORDER_QUOTATION_HISTORY_TAB%ROWTYPE;
   hist_state_ ORDER_QUOTATION_HISTORY_TAB.hist_state%TYPE;
BEGIN
   hist_state_ := Order_Quotation_API.Get_Objstate(quotation_no_);
   newrec_.quotation_no := quotation_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Order_Quotation_API.Get_Contract(quotation_no_));
   newrec_.userid       := Fnd_Session_API.Get_Fnd_User;
   newrec_.revision_no  := Order_Quotation_API.Get_Revision_No( quotation_no_);
   IF (message_text_ IS NULL) THEN
      newrec_.message_text := Order_Quotation_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text :=  message_text_;
   END IF;
   newrec_.hist_state := hist_state_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Hist_State (
   quotation_no_ IN VARCHAR2,
   history_no_   IN NUMBER  ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   ORDER_QUOTATION_HISTORY_TAB
      WHERE  quotation_no = quotation_no_
      AND    history_no = history_no_;

   hist_state_    VARCHAR2(20);
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Order_Quotation_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;


