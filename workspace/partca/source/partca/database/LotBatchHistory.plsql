-----------------------------------------------------------------------------
--
--  Logical unit: LotBatchHistory
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK  Issue SC2020R1-11830, Modified New() method by removing attr_ functionality to optimize the performance.
--  100423  KRPELK Merge Rose Method Documentation.
--  090929  MaJalk Removed unused methods.
--  --------------------------------- 13.0.0---------------------------------
--  041107  IsWilk Added the FUNCTION Get_Sum_Transaction_Qty. 
--  040224  LoPrlk Removed substrb from code. &VIEW was altered.
--  031204  LaBolk Modified lines in the design history to remove red code.
--  ----------------------- 12.3.0----------------------------
--  031020  AnLaSE Call Id 108783: increased length from 4 to 30 for order_ref3.
--  031020  AnLaSe Call Id 107642: Added reference to OrderType.  Added undefine.
--  031013  PrJalk Bug Fix 106224, Chagned incorrect General_Sys.Init_Method calls.
--  020802  BEHAUS Lot Batch Mod. Added Condition code to LB Master
--  020715  BEHAUS Merged from Lot Batch Mod VAP.
--          -----------------------------------------------------------------
--  020618  FRWAUS Pharmaceutical Mod - Potency Mod - added attribute Potency to LU.
--  020506  BEHAUS Lot Batch Mod. Added more Logic from 2.1.
--  020503  BEHAUS Lot Batch Mod. Copied from PHS implementation.
--  020502  BEHAUS Lot Batch Mod. Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT LOT_BATCH_HISTORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_sequence_no_ IS
      SELECT lot_batch_history_seq.nextval
      FROM   dual;
BEGIN
   OPEN get_sequence_no_;
   FETCH get_sequence_no_ INTO newrec_.sequence_no;
   CLOSE get_sequence_no_;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', newrec_.sequence_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts a new history instance for the lot batch
--   Potency Mod - Added default null attribute parameter potency
PROCEDURE New (
   sequence_no_      OUT NUMBER,
   lot_batch_no_     IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   transaction_date_ IN  DATE,
   transaction_desc_ IN  VARCHAR2,
   transaction_qty_  IN  NUMBER,
   order_type_       IN VARCHAR2,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN NUMBER,
   potency_          IN NUMBER,
   condition_code_   IN VARCHAR2 DEFAULT NULL )
IS
   newrec_              LOT_BATCH_HISTORY_TAB%ROWTYPE;
BEGIN
   newrec_.part_no          := part_no_;
   newrec_.lot_batch_no     := lot_batch_no_;
   newrec_.contract         := contract_;
   newrec_.transaction_date := transaction_date_;
   newrec_.transaction_desc := transaction_desc_;
   newrec_.transaction_qty  := transaction_qty_;
   newrec_.order_type       := order_type_;
   newrec_.order_ref1       := order_ref1_;
   newrec_.order_ref2       := order_ref2_;
   newrec_.order_ref3       := order_ref3_;
   newrec_.order_ref4       := order_ref4_;
   newrec_.condition_code   := condition_code_;
   New___(newrec_);
   
   sequence_no_ := newrec_.sequence_no;
END New;


-- Get_Latest_Sequence_No
--   Gets the latest sequence number.
FUNCTION Get_Latest_Sequence_No (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN NULL;
END Get_Latest_Sequence_No;


-- Get_Sum_Transaction_Qty
--   This function return the total transaction qty for the given order_type,
--   order_ref1, order_ref2, order_ref3, order_ref4, contract, part_no and lot_batch_no.
@UncheckedAccess
FUNCTION Get_Sum_Transaction_Qty (
   order_type_   IN VARCHAR2,
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER:=0;

   CURSOR get_sum_trans_qty IS
      SELECT SUM(transaction_qty)
      FROM   lot_batch_history_tab
      WHERE  order_type = order_type_
      AND    order_ref1 = order_ref1_
      AND    (order_ref2 = order_ref2_ OR order_ref2_ IS NULL)
      AND    (order_ref3 = order_ref3_ OR order_ref3_ IS NULL)
      AND    (order_ref4 = order_ref4_ OR order_ref4_ IS NULL)
      AND    contract = contract_
      AND    (part_no = part_no_ OR part_no_ IS NULL)
      AND    lot_batch_no = lot_batch_no_;

BEGIN
   OPEN get_sum_trans_qty;
   FETCH get_sum_trans_qty INTO temp_;
   CLOSE get_sum_trans_qty;
   RETURN temp_;
END Get_Sum_Transaction_Qty;



