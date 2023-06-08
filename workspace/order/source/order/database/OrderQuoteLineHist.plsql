-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuoteLineHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210122  MaEelk SC2020R1-12278, Modified New and replaced Pack___, Check_Insert___ and Insert___ with New___. 
--  210122         Replaced the calls to Order_Quotation_API.Get_Contract and Order_Quotation_API.Get_Revision_No with Order_Quotation_API.Get.
--  210122         Removed the code assigning hist_state_ to newrec_.hist_state since it leads to an error from check_common.
--  210112         hist_state has been modeled as a non insertable column in the entity.
--  160111  JeeJlk Bug 125118, Modified Insert___ to assign hist_state column order quotation line objstate value.
--  120127  ChJalk Added column State to the base view.
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------------------13.3.0--------------------------------
--  010522  JSAnse Bug fix 21592, Removed  CLient_SYS.Attr_To_Dbms_Output.
--  000712  LUDI   Merged from Chameleon
-----------------------------------------------------------------------------
--  000524  LIN    call for Get_History_No corrected
--  000523  GBO    Added two New procedures and Get_History_No
--  000522  LUDI   New field
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTE_LINE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_History_No__( newrec_.history_no, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF (newrec_.hist_state IS NULL) THEN
      newrec_.hist_state := Order_Quotation_Line_API.Get_Objstate(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
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
   quotation_no_ IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   CURSOR get_history_no IS
      SELECT max(to_number(history_no))
      FROM   ORDER_QUOTE_LINE_HIST_TAB
      WHERE line_item_no = line_item_no_
      AND rel_no = rel_no_
      AND line_no = line_no_
      AND quotation_no = quotation_no_;
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
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT Null )
IS
   newrec_     ORDER_QUOTE_LINE_HIST_TAB%ROWTYPE;
   hist_state_ ORDER_QUOTE_LINE_HIST_TAB.hist_state%TYPE;
   quotation_rec_ Order_Quotation_API.Public_Rec;
BEGIN
   quotation_rec_ := Order_Quotation_API.Get(quotation_no_);
   newrec_.quotation_no := quotation_no_;
   newrec_.line_no := line_no_;
   newrec_.rel_no := rel_no_;
   newrec_.line_item_no := line_item_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(quotation_rec_.contract);
   newrec_.userid := Fnd_Session_API.Get_Fnd_User;
   newrec_.revision_no := quotation_rec_.revision_no;
   
   IF (message_text_ IS NULL) THEN
      hist_state_ := Order_Quotation_Line_API.Get_Objstate(quotation_no_, line_no_, rel_no_, line_item_no_);      
      newrec_.message_text := Order_Quotation_Line_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   New___(newrec_);
END New;


-- New
--   Creates a new instance
--   Creates a new instance
PROCEDURE New (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   event_        IN VARCHAR2,
   old_value_    IN VARCHAR2,
   new_value_    IN VARCHAR2,
   logical_unit_ IN VARCHAR2,
   id_key_       IN VARCHAR2,
   revision_no_  IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT Null )
IS
   newrec_     ORDER_QUOTE_LINE_HIST_TAB%ROWTYPE;
   hist_state_ ORDER_QUOTE_LINE_HIST_TAB.hist_state%TYPE;
BEGIN
   newrec_.quotation_no := quotation_no_;
   newrec_.line_no := line_no_;
   newrec_.rel_no := rel_no_;
   newrec_.line_item_no := line_item_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Order_Quotation_API.Get_Contract(quotation_no_));
   newrec_.userid := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      hist_state_ := Order_Quotation_Line_API.Get_Objstate(quotation_no_, line_no_, rel_no_, line_item_no_);     
      newrec_.message_text := Order_Quotation_Line_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   newrec_.event := event_;
   newrec_.old_value := SUBSTR(old_value_,1,35);
   newrec_.new_value := SUBSTR(new_value_,1,35);
   newrec_.location := logical_unit_;
   newrec_.location_ref := id_key_;
   newrec_.revision_no := revision_no_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Hist_State (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   history_no_   IN NUMBER  ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   ORDER_QUOTE_LINE_HIST_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    history_no = history_no_;

   hist_state_ order_quote_line_hist_tab.hist_state%TYPE;
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Order_Quotation_Line_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;

