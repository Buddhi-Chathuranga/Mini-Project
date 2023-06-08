-----------------------------------------------------------------------------
--
--  Logical unit: ExtReceivingAdvice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191016  Satglk  Bug SCXTEND-892, Overriden Insert___ to assign the newly created date to Created Date field.
--  120130  ChJalk  Modified Finite_State_Events___ to add event 'Change' to the state 'MatchingInProgress'.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110718  MaMalk  Added the user allowed site and company finance filter to the base view.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100107  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  060420  RoJalk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 ------------------------------------------
--  050921  KeFelk  Added Get_Valid_Customer_No__.
--  050826  KeFelk  Added Set_To_Matching_In_Progress, It will be used in CustomerOrderTransfer LU.
--  050805  KeFelk  Added Clear_Error_Message___.
--  050728  KeFelk  Modifications to Finite_State_Machine___ due to introduction of more conditions.
--  050722  KeFelk  Modifications to Qty_Difference_Line_Exist___ and Matched_Line_Exist___.
--  050720  KeFelk  Move Auto_MAtching_Enabled__ to ExtReceivingAdviceLine.
--  050715  KeFelk  Added Refresh__ and Set_To_Stopped__.
--  050707  KeFelk  Added new methods and added more logic to the existing methods.
--  050627  KeFelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Clear_Error_Message___
--   Used to clear the error message during the matching process.
PROCEDURE Clear_Error_Message___ (
   objid_ IN VARCHAR2,
   objversion_ IN VARCHAR2 )
IS
   oldrec_      EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   newrec_      EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   attr_        VARCHAR2(32000);
   obj_version_ VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   obj_version_ := objversion_;
   oldrec_ := Lock_By_Id___(objid_, obj_version_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, obj_version_);
END Clear_Error_Message___;


FUNCTION All_Lines_Cancelled___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   count_   NUMBER:=0;
   c_count_ NUMBER:=0;
   exist_   BOOLEAN:=FALSE;

   CURSOR count_message_lines IS
      SELECT count(*)
      FROM  ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id;

   CURSOR count_cancelled_lines IS
      SELECT count(*)
      FROM  ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'Cancelled';
BEGIN
   OPEN  count_message_lines;
   FETCH count_message_lines INTO count_;
   CLOSE count_message_lines;

   IF (count_ != 0) THEN
      OPEN count_cancelled_lines;
      FETCH count_cancelled_lines INTO c_count_;
      CLOSE count_cancelled_lines;
      IF (count_ = c_count_) THEN
         exist_ := TRUE;
      END IF;
   END IF;
   RETURN exist_;
END All_Lines_Cancelled___;


FUNCTION Change_Line_Exist___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   exist_ BOOLEAN:=FALSE;

   CURSOR get_changed_lines IS
      SELECT 1
      FROM ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'Changed'
      AND   NOT EXISTS (SELECT 1 FROM ext_receiving_advice_line_tab
                WHERE  message_id = rec_.message_id
                AND    rowstate IN ('Stopped'));
BEGIN
   -- if there is an error in the header data the method Change_Line_Exist___ will not execute
   -- IF NOT (rec_.rowstate ='Stopped' AND (Stopped_Line_Exist___(rec_) = FALSE)) THEN
   IF (rec_.error_message IS NULL) THEN
      OPEN get_changed_lines;
      FETCH get_changed_lines INTO dummy_;
      IF (get_changed_lines%FOUND) THEN
         exist_ := TRUE;
      END IF;
      CLOSE get_changed_lines;
   END IF;
   RETURN exist_;
END Change_Line_Exist___;


FUNCTION Qty_Difference_Line_Exist___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   exist_ BOOLEAN:=FALSE;

   CURSOR get_qty_difference_lines IS
      SELECT 1
      FROM ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'QtyDifference'
      AND   NOT EXISTS (SELECT 1 FROM ext_receiving_advice_line_tab
                WHERE  message_id = rec_.message_id
                AND rowstate IN ('Changed','Stopped'));
BEGIN
   OPEN get_qty_difference_lines;
   FETCH get_qty_difference_lines INTO dummy_;

   IF (get_qty_difference_lines%FOUND) THEN
      exist_ := TRUE;
   END IF;

   CLOSE get_qty_difference_lines;
   RETURN exist_;
END Qty_Difference_Line_Exist___;


FUNCTION Matched_Line_Exist___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   exist_ BOOLEAN:=FALSE;

   CURSOR get_matched_lines IS
      SELECT 1
      FROM ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'Matched'
      AND   NOT EXISTS (SELECT 1 FROM ext_receiving_advice_line_tab
                WHERE  message_id = rec_.message_id
                AND rowstate IN ('QtyDifference','Changed','Stopped'));
BEGIN
   OPEN get_matched_lines;
   FETCH get_matched_lines INTO dummy_;

   IF (get_matched_lines%FOUND) THEN
      exist_ := TRUE;
   END IF;

   CLOSE get_matched_lines;
   RETURN exist_;
END Matched_Line_Exist___;


FUNCTION All_Lines_Matched___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   count_   NUMBER:=0;
   c_count_ NUMBER:=0;
   exist_   BOOLEAN:=FALSE;

   CURSOR count_message_lines IS
      SELECT count(*)
      FROM  ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id;

   CURSOR count_matched_lines IS
      SELECT count(*)
      FROM  ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'Matched';
BEGIN
   OPEN  count_message_lines;
   FETCH count_message_lines INTO count_;
   CLOSE count_message_lines;

   IF (count_ > 0) THEN
      OPEN count_matched_lines;
      FETCH count_matched_lines INTO c_count_;
      CLOSE count_matched_lines;
      IF (count_ = c_count_) THEN
         exist_ := TRUE;
      END IF;
   END IF;
   RETURN exist_;
END All_Lines_Matched___;


FUNCTION Stopped_Line_Exist___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   exist_ BOOLEAN:=FALSE;

   CURSOR get_stopped_lines IS
      SELECT 1
      FROM ext_receiving_advice_line_tab
      WHERE message_id = rec_.message_id
      AND   rowstate = 'Stopped';
BEGIN
  OPEN get_stopped_lines;
  FETCH get_stopped_lines INTO dummy_;
  IF (get_stopped_lines%FOUND) THEN
    exist_ := TRUE;
  END IF;
  CLOSE get_stopped_lines;
  RETURN exist_;
END Stopped_Line_Exist___;

FUNCTION Stopped_Line_Not_Exist___ (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
  RETURN NOT Stopped_Line_Exist___(rec_);
END Stopped_Line_Not_Exist___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_message_lines IS
      SELECT message_line
      FROM   ext_receiving_advice_line_tab
      WHERE  message_id = rec_.message_id
      AND    rowstate !='Cancelled';
BEGIN

   FOR message_rec_ IN get_message_lines LOOP
      Ext_Receiving_Advice_Line_API.Set_To_Cancelled__(rec_.message_id, message_rec_.message_line);
   END LOOP;
END Do_Cancel___;


PROCEDURE Do_Matching_Error___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_        EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   newrec_        EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   error_message_ VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.message_id);
   newrec_ := oldrec_;
   error_message_ := Client_SYS.Get_Item_Value('ERROR_MESSAGE',attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE',error_message_,attr_);
END Do_Matching_Error___;


PROCEDURE Do_Match___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   error_message_ VARCHAR2(2000);
   customer_no_   EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;

   CURSOR get_message_lines IS
      SELECT message_line
      FROM   ext_receiving_advice_line_tab
      WHERE  message_id = rec_.message_id
      AND    rowstate IN ('Received','Changed','Stopped');
BEGIN
   @ApproveTransactionStatement(2013-12-09,haarse)
   SAVEPOINT Match;
   customer_no_ := rec_.customer_no;
   Validate_Message__(customer_no_, rec_.internal_customer_site);

   IF (rec_.error_message IS NOT NULL) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
      Clear_Error_Message___(objid_, objversion_);
   END IF;

   FOR message_rec_ IN get_message_lines LOOP
      Ext_Receiving_Advice_Line_API.Clear_Line_Error_Message__(rec_.message_id, message_rec_.message_line);
      Ext_Receiving_Advice_Line_API.Set_To_Matching_in_Progress__(rec_.message_id, message_rec_.message_line);
   END LOOP;
EXCEPTION
   WHEN others THEN
      error_message_ := SQLERRM;
      @ApproveTransactionStatement(2013-12-09,haarse)
      ROLLBACK TO Match;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
      Matching_Error__(info_, objid_, objversion_, attr_, 'DO');
END Do_Match___;


PROCEDURE Do_Update___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_       EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   newrec_       EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.message_id);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('MATCHED_DATE', SYSDATE, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('MATCHED_DATE', SYSDATE, attr_);
END Do_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   newrec_     IN OUT EXT_RECEIVING_ADVICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
   info_  VARCHAR2(2000);
   rowid_ VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.error_message IS NULL AND newrec_.matched_date IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id);
      Change__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_receiving_advice_tab%ROWTYPE,
   newrec_ IN OUT ext_receiving_advice_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT(indrec_.error_message) THEN
     newrec_.error_message := NULL;
   END IF;
   IF NOT(indrec_.matched_date) THEN     
      newrec_.matched_date  := NULL;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.rowstate IN ('Matched','QtyDifference', 'PartiallyMatched', 'Cancelled') THEN
      IF newrec_.matched_date IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOTALLOWUPDATEHEAD: Changes are not allowed when message is in :P1 state.', newrec_.rowstate);
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ext_receiving_advice_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.created_date IS NULL THEN   
      IF newrec_.contract IS NOT NULL THEN
         newrec_.created_date := Site_API.Get_Site_Date(newrec_.contract);
      ELSE 
         newrec_.created_date := sysdate;
      END IF;   
      Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   END IF;  
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Validate_Message__
--   Validates the incoming message header.
PROCEDURE Validate_Message__ (
   customer_no_            IN OUT VARCHAR2,
   internal_customer_site_ IN     VARCHAR2 )
IS
   valid_customer_no_  EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;
   coc_rec_            Cust_Ord_Customer_API.Public_Rec;
BEGIN

   IF (internal_customer_site_ IS NOT NULL ) THEN
      valid_customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(internal_customer_site_);

      IF valid_customer_no_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOINTERNALCUSTOMER: There is no customer set up for internal site :P1', internal_customer_site_);
      END IF;

      IF (customer_no_ IS NOT NULL AND valid_customer_no_ != customer_no_) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCUSTOMER: For internal orders Customer No should be ignored. Or it should be equal to customer :P1 for internal site :P2', valid_customer_no_, internal_customer_site_);
      END IF;
   ELSE
      valid_customer_no_ := customer_no_;
   END IF;

   Customer_Info_API.Exist(valid_customer_no_);
   coc_rec_  := Cust_Ord_Customer_API.Get(valid_customer_no_);
   customer_no_ := valid_customer_no_;

   IF (coc_rec_.receiving_advice_type = 'DO_NOT_USE') THEN
      Error_SYS.Record_General(lu_name_, 'NOCUSSETUP: Customer is not set up to use Receiving Advice.');
   END IF;
END Validate_Message__;


-- Refresh__
--   Sends a null event to Finite State Machine.
PROCEDURE Refresh__ (
   message_id_    IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   rec_ EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   rec_ := Lock_By_Id___(objid_, objversion_);
   Finite_State_Machine___(rec_, NULL, attr_);
END Refresh__;


-- Set_To_Stopped__
--   Changes the state to 'Stopped'.
PROCEDURE Set_To_Stopped__ (
   message_id_    IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
   Manual_Matching_Error__(info_, objid_, objversion_, attr_, 'DO');
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
END Set_To_Stopped__;


-- Get_Valid_Customer_No__
--   Use to get the valid customer No.
@UncheckedAccess
FUNCTION Get_Valid_Customer_No__ (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   customer_no_ EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;
   rec_         Ext_Receiving_Advice_API.Public_Rec;
BEGIN
   rec_ := Ext_Receiving_Advice_API.Get(message_id_);
   customer_no_ := rec_.customer_no;
   IF (rec_.internal_customer_site IS NOT NULL ) THEN
      customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.internal_customer_site);
   END IF;
   RETURN customer_no_;
END Get_Valid_Customer_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public New function which accepts a record of the LU to create a new record.
PROCEDURE New (
   rec_ IN EXT_RECEIVING_ADVICE_TAB%ROWTYPE )
IS
   newrec_     EXT_RECEIVING_ADVICE_TAB%ROWTYPE;
   newattr_    VARCHAR2(32000);
   objid_      EXT_RECEIVING_ADVICE.objid%TYPE;
   objversion_ EXT_RECEIVING_ADVICE.objversion%TYPE;
BEGIN
   newrec_ := rec_;
   Error_SYS.Check_Not_Null(lu_name_, 'MESSAGE_ID', rec_.message_id);

   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


-- Set_To_Matching_In_Progress
--   Changes the state to 'Matching In Progress'.
PROCEDURE Set_To_Matching_In_Progress (
   message_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Match__(info_, objid_, objversion_, attr_, 'DO');
END Set_To_Matching_In_Progress;


