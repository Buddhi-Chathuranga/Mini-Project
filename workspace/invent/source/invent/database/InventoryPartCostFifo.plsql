-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartCostFifo
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150729  ShKolk  Bug 122064, Modified Get_Average_Cost_Details to reduce context switches.
--  150717  ErFelk  Bug 123170, Restructured method Remove_Zero_Quantity_Records() to improve performance. Method Remove___() was removed. 
--  140127  UdGnlk  Merged Bug 112848, Added new method Transaction_Id_Not_In_Tab___() and modified Remove_Zero_Quantity_Records() and 
--  140127          Remove___() in order to create a collection of Issue Transaction ID's found in the recursive calls and avoid 
--  140127          dealing with an Issue Transaction ID more than once.
--  130918  PraWlk  Bug 99627, Added Remove_Zero_Quantity_Records() and replaced Remove_If_Not_Last_Record___() with Remove___()  
--  130918          to support cleanup of FIFO LIFO records. Also modified Update___() accordingly.
--  120913  GayDLK  Bug 101862, Modified Remove_Cost() by assigning 'TRUE' for cost_successfully_removed_ initially.
--  111201  MaaNlk  Bug 99448, Modified Get_Average_Cost_Details() in order to improve performance.
--  110628  PraWlk  Bug 93152, Added new method Copy_From_Cancelled_Issue() and added parameter unissue_transaction_id_ to
--  110628          Unissue_Cost() and passed the vaue of it when calling Inventory_Part_Fifo_Issue_API.Unissue_Quantity().
--  110627  PraWlk  Bug 95368, Modified Remove_Cost() by adding new parameters cost_successfully_removed_ and error_when_not_successful_
--  110627          to check and raise the error only when the cost successfully removed for the return transaction.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  101020  GayDLK  Bug 93473, Removed the IF condition used to check whether the rec_.quantity is greater than zero in  
--  101020          Remove_Cost(). Replaced the existing error messages with a new error message.  
--  100811  PraWlk  Bug 89848, Modified parameter type of cost_detail_tab_ to OUT and passed it to
--  100811          Inventory_Part_Fifo_Issue_API.Unissue_Quantity(). 
--  100510  KRPELK  Merge Rose Method Documentation.
--  100105  PraWlk  Bug 88061, Modified Get_Average_Cost_Details() to call Inventory_Part_Unit_Cost_API.Value_To_Cost_Details()
--  100105          only if there is a non-issued quantity left in the stack.
--  091221  PraWlk  Bug 84712, Modified Get_Cost_Details() to validate quantity before calling Get_Cost_Detail___().
--  091217  PraWlk  Bug 84712, Modified INVENTORY_PART_COST_FIFO to fetch quantity from method call,
--  091217          Removed Remove_If_Not_Last_Record___ method. Added new parameter to Issue_Cost,
--  091217          Issue_Cost_Details___ and Issue_Cost_Detail___  methods.Modified Issue_Cost_Details___ ,
--  091217          Issue_Cost_Detail___ , Remove_Cost, Receive_Cost and Get_Average_Cost_Details methods
--  091217          Added Get_Quantity_Not_Issued,Unissue_Cost and Modify_Last_Activity_Date methods.
--  090929  ChFolk  Removed unused variables in the package.
--  -------------------------------- 14.0.0 -----------------------------------
--  100105  PraWlk  Bug 88061, Modified Get_Average_Cost_Details() to call Inventory_Part_Unit_Cost_API.Value_To_Cost_Details()
--  100105          only if there is a non-issued quantity left in the stack.
--  091221  PraWlk  Bug 84712, Modified Get_Cost_Details() to validate quantity before calling Get_Cost_Detail___().
--  091217  PraWlk  Bug 84712, Modified INVENTORY_PART_COST_FIFO to fetch quantity from method call,
--  091217          Removed Remove_If_Not_Last_Record___ method. Added new parameter to Issue_Cost,
--  091217          Issue_Cost_Details___ and Issue_Cost_Detail___  methods.Modified Issue_Cost_Details___ ,
--  091217          Issue_Cost_Detail___ , Remove_Cost, Receive_Cost and Get_Average_Cost_Details methods
--  091217          Added Get_Quantity_Not_Issued,Unissue_Cost and Modify_Last_Activity_Date methods.
--  080428  RoJalk  Bug 73185, Added code to fetch the value to invepart_rec_ in
--  080428          Get_Cost_Details.
--  060210  LEPESE  Major redesign of methods Receive_Cost, Issue_Cost and Remove_Cost. Calls
--  060210          to Inventory_Part_Unit_Cost_API.Level_Transit_Account_Balance are removed.
--  060210          New out parameters pre_trans_level_qty_in_stock_, pre_trans_level_qty_in_transi_
--  060210          and pre_trans_avg_cost_detail_tab_ have been added. Parameter
--  060210          transit_qty_direction_db_ has been removed.
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  060104  IsAnlk  Added General_Sys.Init to Get_Cost,Get_Cost_Details.
--  051227  LEPESE  Added parameter inventory_valuation_method in calls to method
--  051227          Inventory_Part_Unit_Cost_API.Level_Transit_Account_Balance.
--  050928  LEPESE  Merged DMC changes below.
--  ***************** DMC Merge Begin *****************
--  050830  LEPESE  Method Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab changed from
--  050830          procedure to function.
--  050829  LEPESE  Complete redesign of all methods due to the fact that we have introduced
--  050829          the cost details functionality and the new child LU InventoryPartFifoDetail.
--  050825  LEPESE  Removed obsolete attribute unit_cost.
--  ***************** DMC Merge End *****************
--  040712  ErSolk  Bug 45653, Modified procedure Receive_Cost to remove last
--  040712          record if quantity on hand is zero when receiving new quantity.
--  040621  SHVESE  M4/Transibal: Added parameter transit_qty_direction_db_ to methods
--  040621          Issue_Cost, Receive_Cost and Remove_Cost. New method Issue_Cost___.
--  040621          Added call to Inventory_Part_Unit_Cost_API.Level_Transit_Account_Balance
--  040317  ErSolk  Bug 38946, Changed error messages in Remove_Cost.
--************************Edge***************************************************
--  030811  LEPESE  Changed values of parameters in call to method Get_Inventory_Value_By_Method.
--  030804  DAYJLK  Performed SP4 Merge.
--  021205  MKrase  Bug 34360, Changed loops in Issue_Cost from explicit cursor (open..fetch)
--                  to implicit (for..in..loop) for better performance.
--  020816  ANLASE  Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                  Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method.
--  ****************************  Take Off Baseline  *********************************
--  001019  PEADSE  Replaced calls to Inventory_Part_API.Get_Inventory_Value_By_Method with
--                  Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--  000925  JOHESE  Added undefines.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000113  SHVE    Replaced calls to Site_API.Get_Inventory_Value_Method_Db with
--                  Inventory_Part_API.Get_Invent_Valuation_Method_Db.
--  990506  SHVE    Replaced call to Inventory_Part_Cost_API.Get_Cost_Per_Part with
--                  Inventory_Part_API.Get_Inventory_Value_By_Method.
--  990428  ANHO    General performance improvements.
--  990415  ANHO    Upgraded to performance optimized template.
--  990217  JOHW    Changed the key according to Bug 8573.
--  980124  FRDI    Changed System parameter 'PURCHASE_VALUE_METHOD' to Site_API.Get_Inventory_Value_Method_Db.
--  990112  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  980210  FRDI    Format on amount columns, removed rounding from prices.
--  980210  JOHO    Format on amount columns. added get_currency_rounding.
--  980126  GOPE    Return 0 from GetAverageCost
--  971201  GOPE    Upgrade to fnd 2.0
--  970626  JICE    Corrected Lock-problem on LIFO, Issue_Cost.
--  970417  FRMA    Corrected cursor in Get_Average_cost. Replaced calls to Modify__ and Remove__ with
--                  a copy of their contents.
--  970416  FRMA    If no records found in Issue_Cost, Inventory_Part_Cost_API.Get_Part_Cost is returned.
--  970402  FRMA    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Issue_Cost_Details___ (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   qty_issued_from_stock_ IN NUMBER,
   issue_transaction_id_  IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   invepart_rec_          Inventory_Part_API.Public_Rec;
   qty_issued_from_stack_ NUMBER := 0;
   site_date_             DATE;
   value_detail_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_fifo IS
      SELECT *
      FROM INVENTORY_PART_COST_FIFO_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      ORDER BY sequence_no ASC
      FOR UPDATE;

   CURSOR get_lifo IS
      SELECT *
      FROM INVENTORY_PART_COST_FIFO_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      ORDER BY sequence_no DESC
      FOR UPDATE;

BEGIN

   invepart_rec_ := Inventory_Part_API.Get(contract_, part_no_);
   site_date_    := Site_API.Get_Site_Date(contract_);

   IF (invepart_rec_.inventory_valuation_method = 'FIFO') THEN

      FOR oldrec_ IN get_fifo LOOP

         oldrec_.quantity := Get_Quantity_Not_Issued(oldrec_.contract,
                                                     oldrec_.part_no, 
                                                     oldrec_.sequence_no);
         IF (oldrec_.quantity > 0) THEN
            Issue_Cost_Detail___(value_detail_tab_,
                                 qty_issued_from_stack_,
                                 qty_issued_from_stock_,
                                 oldrec_,
                                 issue_transaction_id_);

            IF (qty_issued_from_stack_ = qty_issued_from_stock_) THEN
               EXIT;
            END IF;
         END IF;
      END LOOP;

   ELSIF (invepart_rec_.inventory_valuation_method = 'LIFO') THEN

      FOR oldrec_ IN get_lifo LOOP
         oldrec_.quantity := Get_Quantity_Not_Issued(oldrec_.contract,
                                                     oldrec_.part_no, 
                                                     oldrec_.sequence_no);
         IF (oldrec_.quantity > 0) THEN
            Issue_Cost_Detail___(value_detail_tab_,
                                 qty_issued_from_stack_,
                                 qty_issued_from_stock_,
                                 oldrec_,
                                 issue_transaction_id_);

            IF (qty_issued_from_stack_ = qty_issued_from_stock_) THEN
               EXIT;
            END IF; 
         END IF;
      END LOOP;

   ELSE
      Raise_Value_Method_Error___;
   END IF;

   IF (qty_issued_from_stack_ = 0) THEN
      -- Not supposed to happen.
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(contract_,
                                                                                  part_no_,
                                                                                  NULL,
                                                                                  NULL,
                                                                                  NULL);
   ELSE
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Value_To_Cost_Details(
                                                                        value_detail_tab_,
                                                                        qty_issued_from_stack_);
   END IF;

   RETURN (cost_detail_tab_);
END Issue_Cost_Details___;
   
FUNCTION Transaction_Id_Not_In_Tab___ (
   transaction_id_     IN NUMBER,
   transaction_id_tab_ IN Inventory_Transaction_Hist_API.Transaction_Id_Tab ) RETURN BOOLEAN
IS
   transaction_id_not_in_tab_ BOOLEAN := TRUE;
BEGIN
   IF (transaction_id_tab_.COUNT > 0) THEN
      FOR i IN transaction_id_tab_.FIRST..transaction_id_tab_.LAST LOOP
         IF transaction_id_tab_(i) = transaction_id_ THEN
            transaction_id_not_in_tab_ := FALSE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN(transaction_id_not_in_tab_);
END Transaction_Id_Not_In_Tab___;


PROCEDURE Issue_Cost_Detail___ (
   value_detail_tab_      IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   qty_issued_from_stack_ IN OUT NUMBER,
   qty_issued_from_stock_ IN     NUMBER,
   oldrec_                IN     INVENTORY_PART_COST_FIFO_TAB%ROWTYPE,
   issue_transaction_id_  IN     NUMBER )
IS
   qty_to_issue_from_record_ NUMBER;
   cost_detail_tab_          Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(oldrec_.contract,
                                                                       oldrec_.part_no,
                                                                       oldrec_.sequence_no);
   qty_to_issue_from_record_ :=
                      LEAST((qty_issued_from_stock_ - qty_issued_from_stack_), oldrec_.quantity);

   Inventory_Part_Fifo_Issue_API.Issue_Quantity (oldrec_.contract,
                                                 oldrec_.part_no,
                                                 oldrec_.sequence_no,
                                                 issue_transaction_id_,
                                                 qty_to_issue_from_record_);
   Modify_Last_Activity_Date (oldrec_.contract, 
                              oldrec_.part_no, 
                              oldrec_.sequence_no);
   value_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(
                                                                        value_detail_tab_,
                                                                        cost_detail_tab_,
                                                                        qty_to_issue_from_record_);

   qty_issued_from_stack_  := qty_issued_from_stack_ + qty_to_issue_from_record_;
END Issue_Cost_Detail___;


PROCEDURE Raise_Value_Method_Error___
IS
BEGIN

   Error_SYS.Record_General(lu_name_, 'VALUEMETERROR: This operation is only allowed when the inventory valuation method is :P1 or :P2.',Inventory_Value_Method_API.Decode('FIFO'),Inventory_Value_Method_API.Decode('LIFO'));

END Raise_Value_Method_Error___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_COST_FIFO_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT inventory_part_cost_fifo_seq.nextval
   INTO   newrec_.sequence_no
   FROM   dual;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


PROCEDURE Get_Cost_Detail___ (
   value_detail_tab_        IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   qty_consumed_from_stack_ IN OUT NUMBER,
   qty_requested_           IN     NUMBER,
   record_                  IN     INVENTORY_PART_COST_FIFO_TAB%ROWTYPE )
IS
   qty_to_consume_from_record_ NUMBER;
   cost_detail_tab_            Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(record_.contract,
                                                                       record_.part_no,
                                                                       record_.sequence_no);
   qty_to_consume_from_record_ :=
                      LEAST((qty_requested_ - qty_consumed_from_stack_), record_.quantity);

   value_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(
                                                                      value_detail_tab_,
                                                                      cost_detail_tab_,
                                                                      qty_to_consume_from_record_);

   qty_consumed_from_stack_  := qty_consumed_from_stack_ + qty_to_consume_from_record_;
END Get_Cost_Detail___;

   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Cost
--   Returns the price for the required quantity.
FUNCTION Get_Cost (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2,
   quantity_ IN NUMBER ) RETURN NUMBER
IS
   total_avg_unit_cost_ NUMBER;
   cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   cost_detail_tab_     := Get_Cost_Details(contract_, part_no_, quantity_);
   total_avg_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);

   RETURN (total_avg_unit_cost_);
END Get_Cost;


-- Get_Cost_Details
--   Returns the cost details for the required quantity.
FUNCTION Get_Cost_Details (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   qty_requested_ IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   invepart_rec_            Inventory_Part_API.Public_Rec;
   qty_consumed_from_stack_ NUMBER := 0;
   value_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   cost_detail_tab_         Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_fifo IS
      SELECT *
      FROM INVENTORY_PART_COST_FIFO_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      ORDER BY sequence_no ASC;

   CURSOR get_lifo IS
      SELECT *
      FROM INVENTORY_PART_COST_FIFO_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      ORDER BY sequence_no DESC;
BEGIN

   invepart_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (invepart_rec_.inventory_valuation_method = 'FIFO') THEN

      FOR record_ IN get_fifo LOOP
         record_.quantity := Get_Quantity_Not_Issued(record_.contract,
                                                     record_.part_no, 
                                                     record_.sequence_no);
         IF (record_.quantity > 0) THEN

            Get_Cost_Detail___(value_detail_tab_,
                               qty_consumed_from_stack_,
                               qty_requested_,
                               record_);

            IF (qty_consumed_from_stack_ = qty_requested_) THEN
               EXIT;
            END IF;
         END IF;
      END LOOP;

   ELSIF (invepart_rec_.inventory_valuation_method = 'LIFO') THEN

      FOR record_ IN get_lifo LOOP
         record_.quantity := Get_Quantity_Not_Issued(record_.contract,
                                                     record_.part_no, 
                                                     record_.sequence_no);
         IF (record_.quantity > 0) THEN


            Get_Cost_Detail___(value_detail_tab_,
                               qty_consumed_from_stack_,
                               qty_requested_,
                               record_);

            IF (qty_consumed_from_stack_ = qty_requested_) THEN
               EXIT;
            END IF;
         END IF;
      END LOOP;

   ELSE
      Raise_Value_Method_Error___;
   END IF;

   IF (qty_consumed_from_stack_ > 0) THEN
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Value_To_Cost_Details(
                                                                        value_detail_tab_,
                                                                        qty_consumed_from_stack_);
   END IF;

   RETURN (cost_detail_tab_);
END Get_Cost_Details;


-- Issue_Cost
--   Returns the price for the required quantity.
--   If no quantity is available in the FIFO then Null is returned.
--   FIFO is decreased by the required quantity.
PROCEDURE Issue_Cost (
   pre_trans_level_qty_in_stock_  OUT NUMBER,
   pre_trans_level_qty_in_transi_ OUT NUMBER,
   pre_trans_avg_cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   issued_cost_detail_tab_        OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   contract_                      IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   quantity_                      IN  NUMBER,
   issue_transaction_id_          IN  NUMBER )
IS
BEGIN

   Inventory_Part_Unit_Cost_API.Get_Tot_Company_Owned_Stock(pre_trans_level_qty_in_stock_,
                                                            pre_trans_level_qty_in_transi_,
                                                            contract_,
                                                            part_no_);

   pre_trans_avg_cost_detail_tab_ := Get_Average_Cost_Details(contract_, part_no_);
   issued_cost_detail_tab_        := Issue_Cost_Details___(contract_,
                                                           part_no_,
                                                           quantity_,
                                                           issue_transaction_id_);
END Issue_Cost;


-- Remove_Cost
--   Removes an instance of InventoryPartCostFifo. Is used when correcting
--   deliveries. Transaction POUNRCPT and SUNREC.
PROCEDURE Remove_Cost (
   cost_successfully_removed_     OUT BOOLEAN,
   pre_trans_level_qty_in_stock_  OUT NUMBER,
   pre_trans_level_qty_in_transi_ OUT NUMBER,
   pre_trans_avg_cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_                IN  NUMBER,
   quantity_                      IN  NUMBER,
   reverse_transaction_id_        IN  NUMBER,
   error_when_not_successful_     IN  BOOLEAN )
IS
   rec_                 INVENTORY_PART_COST_FIFO_TAB%ROWTYPE;
   quantity_not_issued_ NUMBER;
   exit_procedure       EXCEPTION;

   CURSOR get_rec IS
      SELECT *
      FROM INVENTORY_PART_COST_FIFO_TAB
      WHERE transaction_id = transaction_id_;

BEGIN
   cost_successfully_removed_ := TRUE;
   -- Cancel quantity from delivery. IF remaining quantity = 0
   -- and record is not the last for current part, record is removed.
   OPEN get_rec;
   FETCH get_rec INTO rec_;
   IF (get_rec%FOUND) THEN
      quantity_not_issued_ := Get_Quantity_Not_Issued(rec_.contract,
                                                      rec_.part_no,
                                                      rec_.sequence_no);
   END IF;

   IF (get_rec%NOTFOUND OR quantity_not_issued_ < quantity_) THEN
      IF (error_when_not_successful_) THEN
         Error_SYS.Record_General('InventoryPartCostFifo', 'NOQTY: The quantity received for the receipt transaction :P1 is no longer available on the FIFO stack. You are not allowed to cancel the receipt.', transaction_id_);
      ELSE
         cost_successfully_removed_ := FALSE;
         CLOSE get_rec;
         RAISE exit_procedure;
      END IF;
   END IF;
   CLOSE get_rec;

   Inventory_Part_Unit_Cost_API.Get_Tot_Company_Owned_Stock(pre_trans_level_qty_in_stock_,
                                                            pre_trans_level_qty_in_transi_,
                                                            rec_.contract,
                                                            rec_.part_no);

   pre_trans_avg_cost_detail_tab_ := Get_Average_Cost_Details(rec_.contract, rec_.part_no);

   Inventory_Part_Fifo_Issue_API.Issue_Quantity (rec_.contract,
                                                 rec_.part_no,
                                                 rec_.sequence_no,
                                                 reverse_transaction_id_,
                                                 quantity_);
   Modify_Last_Activity_Date (rec_.contract, 
                              rec_.part_no, 
                              rec_.sequence_no);
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Remove_Cost;


-- Get_Average_Cost
--   Returns the average cost for a part.
@UncheckedAccess
FUNCTION Get_Average_Cost (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   total_avg_unit_cost_  NUMBER;
   cost_detail_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN
   cost_detail_tab_     := Get_Average_Cost_Details(contract_, part_no_);
   total_avg_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);

   RETURN (total_avg_unit_cost_);
END Get_Average_Cost;


-- Get_Average_Cost_Details
--   Returns the average cost details for a part.
@UncheckedAccess
FUNCTION Get_Average_Cost_Details (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   value_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_quantity_   NUMBER := 0;

   latest_activity_date_        INVENTORY_PART_COST_FIFO_TAB.last_activity_date%TYPE := Database_SYS.first_calendar_date_;
   latest_activity_sequence_no_ INVENTORY_PART_COST_FIFO_TAB.sequence_no%TYPE;
   
   CURSOR get_stack_records IS
      SELECT sequence_no,
             quantity - NVL((SELECT SUM(issued_quantity)
                             FROM inventory_part_fifo_issue_tab ipfi
                             WHERE ipfi.contract    = ipcf.contract
                             AND   ipfi.part_no     = ipcf.part_no
                             AND   ipfi.sequence_no = ipcf.sequence_no),0)
                      + NVL((SELECT SUM(unissued_quantity)
                             FROM inventory_part_fifo_uniss_tab ipfu
                             WHERE ipfu.contract    = ipcf.contract
                             AND   ipfu.part_no     = ipcf.part_no
                             AND   ipfu.sequence_no = ipcf.sequence_no),0) quantity_not_issued,
             last_activity_date
      FROM inventory_part_cost_fifo_tab ipcf
      WHERE ipcf.contract = contract_
      AND   ipcf.part_no  = part_no_;

   TYPE Stack_Record_Tab IS TABLE OF get_stack_records%ROWTYPE;
   stack_record_tab_ Stack_Record_Tab;

BEGIN
   
   OPEN  get_stack_records;
   FETCH get_stack_records BULK COLLECT INTO stack_record_tab_;
   CLOSE get_stack_records;
   
   IF (stack_record_tab_.COUNT > 0) THEN
      FOR i IN stack_record_tab_.FIRST..stack_record_tab_.LAST LOOP
         IF (stack_record_tab_(i).quantity_not_issued != 0) THEN
            cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(contract_,
                                                                                part_no_,
                                                                                stack_record_tab_(i).sequence_no);

            value_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(value_detail_tab_,
                                                                                      cost_detail_tab_,
                                                                                      stack_record_tab_(i).quantity_not_issued);
            total_quantity_ := total_quantity_ + stack_record_tab_(i).quantity_not_issued;
         END IF;

         IF (stack_record_tab_(i).last_activity_date > latest_activity_date_) THEN
            latest_activity_date_ := stack_record_tab_(i).last_activity_date;
            latest_activity_sequence_no_ := stack_record_tab_(i).sequence_no;
         END IF;
      END LOOP;
   END IF;
   
   IF (total_quantity_ > 0) THEN
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Value_To_Cost_Details(value_detail_tab_,
                                                                             total_quantity_);
   ELSE
      IF (latest_activity_sequence_no_ IS NOT NULL) THEN
         cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(contract_,
                                                                             part_no_,
                                                                             latest_activity_sequence_no_);
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Average_Cost_Details;


-- Receive_Cost
--   Creates a new instance of InventoryPartCostFifo.
PROCEDURE Receive_Cost (
   pre_trans_level_qty_in_stock_  OUT NUMBER,
   pre_trans_level_qty_in_transi_ OUT NUMBER,
   pre_trans_avg_cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   contract_                      IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   quantity_                      IN  NUMBER,
   cost_detail_tab_               IN  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_                IN  NUMBER )
IS
  objid_                       INVENTORY_PART_COST_FIFO.OBJID%TYPE;
  objversion_                  INVENTORY_PART_COST_FIFO.OBJVERSION%TYPE;
  attr_                        VARCHAR2(32000);
  sitedate_                    DATE;
  newrec_                      INVENTORY_PART_COST_FIFO_TAB%ROWTYPE;
  sequence_no_                 INVENTORY_PART_COST_FIFO_TAB.SEQUENCE_NO%TYPE;
  remrec_                      INVENTORY_PART_COST_FIFO_TAB%ROWTYPE;
  indrec_                      Indicator_Rec;
   CURSOR get_record IS
      SELECT sequence_no
      FROM   INVENTORY_PART_COST_FIFO_TAB
      WHERE  contract = contract_
      AND    part_no  = part_no_
      AND    quantity = 0;

BEGIN

   Inventory_Part_Unit_Cost_API.Get_Tot_Company_Owned_Stock(pre_trans_level_qty_in_stock_,
                                                            pre_trans_level_qty_in_transi_,
                                                            contract_,
                                                            part_no_);

   sitedate_ := Site_API.Get_Site_Date(contract_);

   OPEN get_record;
   FETCH get_record INTO sequence_no_;
   IF get_record%FOUND THEN
      Get_Id_Version_By_Keys___ (objid_, objversion_, contract_, part_no_, sequence_no_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   CLOSE get_record;

   pre_trans_avg_cost_detail_tab_ := Get_Average_Cost_Details(contract_, part_no_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('QUANTITY', quantity_, attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_ID', transaction_id_, attr_);
   Client_SYS.Add_To_Attr('INSERT_DATE', sitedate_, attr_);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', sitedate_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   Inventory_Part_Fifo_Detail_API.Add_Cost_Details(newrec_.contract,
                                                   newrec_.part_no,
                                                   newrec_.sequence_no,
                                                   cost_detail_tab_);
END Receive_Cost;


PROCEDURE Unissue_Cost (
   pre_trans_level_qty_in_stock_  OUT NUMBER,
   pre_trans_level_qty_in_transi_ OUT NUMBER,
   pre_trans_avg_cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   cost_detail_tab_               OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   contract_                      IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   quantity_                      IN  NUMBER,
   issue_transaction_id_          IN  NUMBER,
   unissue_transaction_id_        IN  NUMBER )
IS
BEGIN

   Inventory_Part_Unit_Cost_API.Get_Tot_Company_Owned_Stock(pre_trans_level_qty_in_stock_,
                                                            pre_trans_level_qty_in_transi_,
                                                            contract_,
                                                            part_no_);

   pre_trans_avg_cost_detail_tab_ := Get_Average_Cost_Details(contract_, part_no_);
   
   Inventory_Part_Fifo_Issue_API.Unissue_Quantity(cost_detail_tab_,
                                                  contract_,
                                                  part_no_,
                                                  issue_transaction_id_,
                                                  quantity_,
                                                  unissue_transaction_id_);
END Unissue_Cost;


@UncheckedAccess
FUNCTION Get_Quantity_Not_Issued (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN  NUMBER ) RETURN NUMBER
IS 
   quantity_not_issued_ INVENTORY_PART_COST_FIFO_TAB.quantity%TYPE;
   record_              INVENTORY_PART_COST_FIFO_TAB%ROWTYPE; 
BEGIN 
   record_              := Get_Object_By_Keys___(contract_, part_no_, sequence_no_); 
   quantity_not_issued_ := record_.quantity - Inventory_Part_Fifo_Issue_API.Get_Total_Issued_Quantity(contract_,
                                                                                                      part_no_,
                                                                                                      sequence_no_);
   RETURN (quantity_not_issued_);
END Get_Quantity_Not_Issued;


PROCEDURE Modify_Last_Activity_Date (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER )
IS 
   oldrec_        INVENTORY_PART_COST_FIFO_TAB%ROWTYPE; 
   newrec_        INVENTORY_PART_COST_FIFO_TAB%ROWTYPE;
   objid_         INVENTORY_PART_COST_FIFO.OBJID%TYPE;
   objversion_    INVENTORY_PART_COST_FIFO.OBJVERSION%TYPE;
   attr_          VARCHAR2(32000);
   site_date_     DATE;
   indrec_        Indicator_Rec;
BEGIN
   
   site_date_ := Site_API.Get_Site_Date(contract_);
   oldrec_    := Get_Object_By_Keys___(contract_, part_no_, sequence_no_); 
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', site_date_, attr_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

END Modify_Last_Activity_Date;


PROCEDURE Copy_From_Cancelled_Issue (
   pre_trans_level_qty_in_stock_  OUT NUMBER,
   pre_trans_level_qty_in_transi_ OUT NUMBER,
   pre_trans_avg_cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   contract_                      IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   old_issue_cancel_trans_id_     IN  NUMBER,
   new_issue_transaction_id_      IN  NUMBER)
IS
BEGIN

   Inventory_Part_Unit_Cost_API.Get_Tot_Company_Owned_Stock(pre_trans_level_qty_in_stock_,
                                                            pre_trans_level_qty_in_transi_,
                                                            contract_,
                                                            part_no_);

   pre_trans_avg_cost_detail_tab_ := Get_Average_Cost_Details(contract_, part_no_);

   Inventory_Part_Fifo_Uniss_API.Copy_To_New_Issue(old_issue_cancel_trans_id_, new_issue_transaction_id_);

END Copy_From_Cancelled_Issue;

-- Remove_Zero_Quantity_Records
--   Checks if the last activity date is older than the given no of days and
--   the not issued qty is 0. If yes Remove_If_Not_Last_Record___() will be called.
PROCEDURE Remove_Zero_Quantity_Records (
   number_of_removed_records_ OUT  NUMBER,
   contract_                  IN   VARCHAR2,
   no_of_days_                IN   NUMBER) 
IS
   CURSOR fifo_records IS
      SELECT part_no, sequence_no
      FROM   INVENTORY_PART_COST_FIFO_TAB 
      WHERE  contract = contract_
      AND    last_activity_date < TRUNC(SYSDATE - no_of_days_)
      FOR UPDATE;
BEGIN
   number_of_removed_records_ := 0;
   FOR remrec_ IN fifo_records LOOP
      IF (Get_Quantity_Not_Issued(contract_, remrec_.part_no, remrec_.sequence_no) = 0) THEN 

         DELETE FROM INVENTORY_PART_COST_FIFO_TAB
               WHERE contract = contract_ AND part_no = remrec_.part_no AND sequence_no = remrec_.sequence_no;

         DELETE FROM INVENTORY_PART_FIFO_DETAIL_TAB
               WHERE contract = contract_ AND part_no = remrec_.part_no AND sequence_no = remrec_.sequence_no;

         DELETE FROM INVENTORY_PART_FIFO_ISSUE_TAB
               WHERE contract = contract_ AND part_no = remrec_.part_no AND sequence_no = remrec_.sequence_no;

         DELETE FROM INVENTORY_PART_FIFO_UNISS_TAB
               WHERE contract = contract_ AND part_no = remrec_.part_no AND sequence_no = remrec_.sequence_no;

         number_of_removed_records_ := number_of_removed_records_ + 1;
      END IF;
   END LOOP;
END Remove_Zero_Quantity_Records;



