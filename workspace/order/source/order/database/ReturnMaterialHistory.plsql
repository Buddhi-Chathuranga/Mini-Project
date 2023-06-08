-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterialHistory
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210125  RavDlk  SC2020R1-12281,Removed unnecessary packing and unpacking of attribute string in New
--  160111  JeeJlk  Bug 125118, Overided Insert___. Modified Insert___ to assign hist_state column return material objstate value.
--  130307  SudJlk Bug 108372, Increased message_text column length up to 2000.
--  120125  ChJalk Added view comments for STATE.
--  100517  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060119  SaJjlk Added the returning clause to method Insert___.
--  040224  IsWilk Removed SUBSTRB for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  011128  KiSalk Changed DATATYPE to STRING(100) for message_text
--  000114  JakH  Cleaned up use of History No.
--  991203  JakH  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT return_material_history_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_History_No__(newrec_.history_no, newrec_.rma_no);
   IF (newrec_.hist_state IS NULL) THEN
      newrec_.hist_state :=  Return_Material_API.Get_Objstate(newrec_.rma_no);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('HISTORY_NO', newrec_.history_no, attr_);
   trace_sys.field('History No', newrec_.history_no);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_History_No__
--   Gets the next history number for this rma.
PROCEDURE Get_History_No__ (
   history_no_ IN OUT VARCHAR2,
   rma_no_     IN     NUMBER )
IS
   CURSOR get_history_no is
      SELECT max(to_number(history_no))
      FROM   RETURN_MATERIAL_HISTORY_TAB
      WHERE  rma_no = rma_no_;
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
PROCEDURE New (
   rma_no_       IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT Null )
IS
   newrec_     RETURN_MATERIAL_HISTORY_TAB%ROWTYPE;
   hist_state_ RETURN_MATERIAL_HISTORY_TAB.hist_state%TYPE;
BEGIN
   hist_state_ := Return_Material_API.Get_Objstate(rma_no_);
   newrec_.rma_no       := rma_no_;
   newrec_.date_entered := Site_API.Get_Site_Date(Return_Material_API.Get_Contract(rma_no_));
   newrec_.userid       := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      newrec_.message_text := Return_Material_API.Finite_State_Decode__(hist_state_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   newrec_.hist_state := hist_state_;
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Hist_State (
   rma_no_ IN NUMBER,
   history_no_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   RETURN_MATERIAL_HISTORY_TAB
      WHERE  rma_no = rma_no_
      AND    history_no = history_no_;

   hist_state_    VARCHAR2(20);
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Return_Material_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;

