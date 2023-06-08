-----------------------------------------------------------------------------
--
--  Logical unit: ExtIncSbiHead
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150714  HimRlk  Bug 119098, Modified Change_Header_State__ by adding condition to avoid changing header state 
--  150714          if it is already set to Unmatched.
--  140226  RoJalk  Modified Do_Create_Error___ and replaced Unpack_Check_Update___ with Unpack___/Check_Update___
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100111  MaRalk  Removed a space in order to make generated code fully aligned with the existing code.
--  100106  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  060109  IsWilk  Removed the column approval_date.  
--  050907  JaBalk  Added info variable to Do_Unmatch___.
--  050905  JaBalk  removed Unmatch event from Partially Matched state and modified Do_Unmatch___.
--  050901  JaBalk  Added Unmatch event to Partially Matched state.
--  050805  UsRalk  Removed view EXT_INC_SBI_HEAD_CLIENT.
--  050727  JaBalk  Removed error_message_ from Change_Header_State__.
--  050727  IsAnlk  Modified Matched_Items_Exist___ as Matched_Items_Exist__.
--  050726  IsAnlk  Modified Change_Header_State__ and Do_Create_Error___ to handle error_message.
--  050725  UsRalk  Added private method Validate_Before_Manual_Match__.
--  050725  JaBalk  Changed the text of error messages.
--  050725  RaKalk  Modified Validate_Header___ to change the error message 'Atleast two of the net amount, tax amount or gross amount must have values'
--  050725          to 'At least two amounts, out of Net Amount, Tax Amount or Gross Amount must have values'.
--  050725  RaKalk  Added method Matched_Items_Exist___ blocked modifications when there are matched lines.
--  050725          Modified Unpack_Check_Update___
--  050725  IsAnlk  Modified Validate_Header___ to validate mandatory columns in Self_billing_Header.
--  050719  IsAnlk  Modified Validate_Header___ to validate total net, tax and gross amounts.
--  050718  JaBalk  Changed the client_state_list_.
--  050718  IsAnlk  Added Unmatch event and modified Do_Unmatch to call Set_Line_Unmatch__.
--  050715  IsAnlk  Renamed total_invoice column as tot_inv_net_amount.
--  050714  IsAnlk  Removed event MatchingError and replaced it by UnmatchHeader.
--  050713  IsAnlk  Added event UnmatchHeader to handle Unmatch flow correctly.
--  050712  JaBalk  Added events to change the state from Stopped to Stopped and Unmatched to Unmatched
--  050712          Changed to Changed.
--  050711  JaBalk  Modified the method Unpack_Check_Update___ to call change__.
--  050708  JaJalk  Modified the method Do_Cancel___ and added the cancellation logic.
--  050705  RaKalk  Added columns Company_Name and Payment_Terms_Desc
--  050705  RaKalk  Added method New_Header__.
--  050705  RaKalk  Removed Public new method.
--  050704  JaBalk  Removed Get_Total_Disc_Amount and added Get_Approval_Date, Get_Tot_Inv_Gross_Amount.
--  050704  JaBalk  Removed Get_Sender_Message_Id and changed the name of the savepoint validate to validate_sbi.
--  050704  JaBalk  Added Get_Total_Tax_Amount, Get_Total_Disc_Amount.
--  050630  JaJalk  Added the methods Do_Match__ and Validate Validate_Header___.
--  050627  JaJalk  Modified the state machine to support the new J-Invo self billing functionality.
--  040817  DhWilk  Inserted the General_SYS.Init_Method to Get_Sender_Message_Id & Get_Message_Status
--  040226  IsWilk  Removed the SUBSTRB for Unicode Changes.
--  ----------------EDGE Package Group 3 Unicode Changes---------------------
--  021114  GeKaLk  Modified Do_Unmatch to clear the attribute string.
--  020614  GeKaLk  Modified Do_Unmatch to remove the lines and the header of the self billing invoice.
--  020614  ArAmLk  Removed status 'SBICreated'
--  020610  ArAmLk  Remove all comments and trace_sys.
--  020605  ArAmLk  Added private method Do_Msg_Match__.
--  020603  ArAmLk  Added public function Get_Message_Status().
--  020530  ArAmLk  Modification in state machine.
--  020517  GeKaLk  Modifeid Do_Unmatch___.
--  020515  ArAmLk  Modify state machine by adding 'PartiallyMatched' event between status partiallMatched and InProcess..
--  020415  GeKaLk  Added Function Get_Sender_Message_Id().
--  020423  ArAmLk  Modifeid methods Do_Cancel___, Un_Matched_Lines_Exist___, Matched_Lines_Exist___, Is_Automatic_Match___
--  020415  ArAmLk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Header___
--   Validates the header records when matching.
PROCEDURE Validate_Header___ (
   rec_ IN EXT_INC_SBI_HEAD_TAB%ROWTYPE )
IS
BEGIN

   IF (rec_.customer_no IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'CUSTOMERNULL: Customer No must have a value');
   END IF;

   IF (rec_.currency IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'CURRCODENULL: Currency must have a value');
   END IF;

   IF (rec_.tot_inv_net_amount IS NOT NULL AND rec_.total_tax_amount IS NOT NULL AND rec_.tot_inv_gross_amount IS NOT NULL) THEN
      IF (rec_.tot_inv_net_amount + rec_.total_tax_amount != rec_.tot_inv_gross_amount) THEN
         Error_Sys.Record_General(lu_name_, 'VALUEERRORTOTAL: The sum of Total Invoiced Net Amount and Total Tax Amount must be equal to Total Invoiced Gross Amount of the message.');
      END IF;
   ELSE
      IF ((rec_.tot_inv_net_amount IS NULL AND rec_.total_tax_amount IS NULL) OR (rec_.tot_inv_net_amount IS NULL AND rec_.tot_inv_gross_amount IS NULL)
         OR (rec_.tot_inv_gross_amount IS NULL AND rec_.total_tax_amount IS NULL)) THEN
         Error_Sys.Record_General(lu_name_, 'AMOUNTNULL: At least two amounts out of Total Invoiced Net Amount, Total Tax Amount and Total Gross Amount must have values.');
      END IF;
   END IF;

   -- Validates the customer number received with the massage.
   Customer_Info_API.Exist(rec_.customer_no);

END Validate_Header___;


FUNCTION All_Lines_Matched___ (
   rec_  IN     EXT_INC_SBI_HEAD_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_lines IS
      SELECT rowstate
        FROM ext_inc_sbi_item_tab
       WHERE message_id = rec_.message_id;

BEGIN

   FOR line_rec IN get_lines LOOP
      IF (line_rec.rowstate != 'Matched') THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;

END All_Lines_Matched___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT message_line
        FROM ext_inc_sbi_item_tab
       WHERE message_id = rec_.message_id;
BEGIN

   FOR line_rec_ IN get_lines LOOP
      Ext_Inc_Sbi_Item_API.Set_Line_Cancel__(rec_.message_id, line_rec_.message_line);
   END LOOP;
END Do_Cancel___;


PROCEDURE Do_Create_Error___ (
   rec_  IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_     EXT_INC_SBI_HEAD_TAB%ROWTYPE;
   newrec_     EXT_INC_SBI_HEAD_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   error_msg_  VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(rec_.message_id);
   newrec_ := oldrec_;
   error_msg_ := Client_SYS.Get_Item_Value('ERROR_MESSAGE', attr_);
   IF (error_msg_ IS NOT NULL) THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_msg_, attr_);
   END IF;

END Do_Create_Error___;


PROCEDURE Do_Match___ (
   rec_  IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   message_line_  NUMBER;
   newrec_        EXT_INC_SBI_HEAD_TAB%ROWTYPE;
   error_message_ VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(32000);

   CURSOR get_lines IS
      SELECT message_line
        FROM ext_inc_sbi_item_tab
       WHERE message_id = rec_.message_id
         AND rowstate IN ('Received', 'Changed', 'Stopped','UnMatched');
BEGIN
   @ApproveTransactionStatement(2014-08-13,darklk)
   SAVEPOINT validate_sbi;

   Validate_Header___(rec_);

   FOR line_ IN get_lines LOOP
      message_line_ := line_.message_line;
      Ext_Inc_Sbi_Item_API.Do_Automatic_Match__(rec_.message_id,line_.message_line);
   END LOOP;

EXCEPTION
   WHEN OTHERS THEN
      error_message_ := SQLERRM;
      @ApproveTransactionStatement(2014-08-13,darklk)
      ROLLBACK TO validate_sbi;

      -- An error was trapped. Rollback entire transaction and write error_message.
      IF (message_line_ IS NULL) THEN
         -- The error was caused when from header
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
         Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
         Invalid_Message_Header__(info_, objid_, objversion_, attr_, 'DO');
      ELSE
         -- The error was caused from line
         Ext_Inc_Sbi_Item_API.Set_Line_Error__(rec_.message_id, message_line_, error_message_);
         newrec_ := Get_Object_By_Keys___(rec_.message_id);
         Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);
      END IF;
END Do_Match___;


PROCEDURE Do_Unmatch___ (
   rec_  IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   sbi_no_ SELF_BILLING_HEADER_TAB.sbi_no%TYPE;
   info_   VARCHAR2(2000);
BEGIN

   sbi_no_ := Self_Billing_Header_API.Get_Preliminary_Sbi_By_Msg(rec_.message_id);

   -- Remove all lines from self billing invoice.
   Self_Billing_Item_API.Unmatch_All(sbi_no_);
   -- Remove the self billing invoice Header.
   Self_Billing_Header_API.Remove(info_, sbi_no_);

END Do_Unmatch___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   newrec_     IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_  VARCHAR2(32000);
   rowid_ VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Set the status to Changed when changing any of the fields in header
   IF (newrec_.error_message IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id);
      Change__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_inc_sbi_head_tab%ROWTYPE,
   newrec_ IN OUT ext_inc_sbi_head_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   
   IF ((newrec_.rowstate = 'Cancelled') OR (newrec_.rowstate = 'Matched') OR (newrec_.rowstate = 'PartiallyMatched')) THEN
      Error_Sys.Record_General(lu_name_, 'MODNOTALLOWED: Changes are not allowed when the status is Matched or Cancelled or Partially Matched');
   END IF;

   IF (Matched_Items_Exist__(newrec_.message_id) = 'TRUE' AND newrec_.error_message IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'NOMODIFYMATCHEDLINES: Changes are not allowed when the lines with status Matched exist');
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT ext_inc_sbi_head_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS 
BEGIN
   -- Clear the error_message.
   newrec_.error_message := NULL;
   super(newrec_, indrec_, attr_);
END Unpack___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Do_Match__
--   This method will be called from the line to validate and match the records.
PROCEDURE Do_Match__ (
   attr_ IN OUT VARCHAR2,
   rec_  IN OUT EXT_INC_SBI_HEAD_TAB%ROWTYPE )
IS
BEGIN
   Do_Match___ (rec_,attr_);
END Do_Match__;


PROCEDURE New_Header__ (
   rec_ IN EXT_INC_SBI_HEAD_TAB%ROWTYPE )
IS
   newrec_      EXT_INC_SBI_HEAD_TAB%ROWTYPE;
   newattr_     VARCHAR2(32000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   newrec_ := rec_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New_Header__;


-- Change_Header_State__
--   Changes the state according to the event sent by the Item.
PROCEDURE Change_Header_State__ (
   message_id_    IN NUMBER,
   event_         IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   rowstate_   VARCHAR2(20);
   rec_        EXT_INC_SBI_HEAD_TAB%ROWTYPE;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   rowstate_ := Get_Message_Status (message_id_ );

   Client_SYS.Clear_Attr(attr_);

   IF ((event_ = 'InvalidMessageHeader') AND (rowstate_ != 'Stopped')) THEN
      Invalid_Message_Header__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF ((event_ = 'Change') AND (rowstate_ != 'Changed')) THEN
      Change__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF ((event_ = 'UnmatchHeader') AND (rowstate_ != 'Unmatched')) THEN
      Unmatch_Header__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF (event_ = 'MatchHeader') THEN
      Match_Header__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF (event_ = 'Match') THEN
      Match__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF (event_ IS NULL) THEN
      rec_ := Get_Object_By_Keys___(message_id_);
      Finite_State_Machine___(rec_, NULL, attr_);
   END IF;
END Change_Header_State__;


-- Matched_Items_Exist__
--   Return TRUE, atleast one line is matched
@UncheckedAccess
FUNCTION Matched_Items_Exist__ (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ VARCHAR2(5) := 'FALSE';

   CURSOR get_matched_items IS
      SELECT 1
        FROM ext_inc_sbi_item_tab
       WHERE message_id = message_id_
         AND rowstate = 'Matched';

BEGIN
   OPEN get_matched_items;
   FETCH get_matched_items INTO dummy_;
   IF get_matched_items%FOUND THEN
      dummy_ := 'TRUE';
   ELSE
      dummy_ := 'FALSE';
   END IF;
   CLOSE get_matched_items;

   RETURN dummy_;
END Matched_Items_Exist__;


-- Validate_Before_Manual_Match__
--   Perform the validations required by the manual matching process.
PROCEDURE Validate_Before_Manual_Match__ (
   error_message_ OUT VARCHAR2,
   message_id_    IN  NUMBER )
IS
   info_          VARCHAR2(32000);
   attr_          VARCHAR2(32000);
   objid_         EXT_INC_SBI_HEAD.objid%TYPE;
   objversion_    EXT_INC_SBI_HEAD.objversion%TYPE;
   rec_           EXT_INC_SBI_HEAD_TAB%ROWTYPE;
BEGIN

   rec_ := Get_Object_By_Keys___(message_id_);
   Validate_Header___(rec_);
EXCEPTION
   WHEN OTHERS THEN
      error_message_ := SQLERRM;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
      Invalid_Message_Header__(info_, objid_, objversion_, attr_, 'DO');
      error_message_ := Language_SYS.Translate_Constant(lu_name_, error_message_);
END Validate_Before_Manual_Match__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Message_Status
--   This will return the objstate for a given message_id.
FUNCTION Get_Message_Status (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ EXT_INC_SBI_HEAD_TAB.rowstate%TYPE;

   CURSOR get_attr IS
      SELECT rowstate
      FROM EXT_INC_SBI_HEAD_TAB
      WHERE message_id = message_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   RETURN temp_;
END Get_Message_Status;


