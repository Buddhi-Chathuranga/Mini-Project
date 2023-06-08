-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderMilestone
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210111  MaEelk  SC2020R1-12026, Modified Insert_From_Templates and Copy_Milestone_Lines. Replaced Unpack___, Check_Insert___ and Insert___ with New___.
--  201102  RasDlk  Bug 156138(SCZ-12174), In Check_Close___, replaced Get_State call with Get_Objstate to work for different languages.
--  171121  MaEelk  STRSC-14333, Changed Copy_Milestone_Lines and supported Milestones to be copied to a different customer order 
--  171121          as well as to the same customer order
--  170926  RaVdlk  STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  151126  BudKlk  Bug 125710, Modified the method Close__() to retrive the values to the rec_ from CUSTOMER_ORDER_MILESTONE_TAB. 
--  120109  NaLrlk  Modified the methods Unpack_Check_Insert___, Prepare_Insert___ and Insert_From_Templates to handle the contract.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  11129   ChJalk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to handle contract column.
--  111122  ChJalk  Added user allowed site filter to the view CUSTOMER_ORDER_MILESTONE and removed the view CUSTOMER_ORDER_MILESTONE_UIV.
--  110303  MalLlk  Added new view CUSTOMER_ORDER_MILESTONE_UIV with user allowed site filter to be used in the client.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_ORDER_MILESTONE.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100305  ShVese  Created method Do_Set_Date_Finished___ and called it from Finite_State_Machine. Also fixed few annotation warnings.
--  091230  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  090924  MaMalk  Removed constant state_separator_. Modified Finite_State_Machine___ and Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  080318  ThAylk  Bug 69894, Added if condition to remove unnecessary calls to refresh project activity cost in method Update___. 
--  070605  MaJalk  Modified Finite_State_Machine___, Validate_Insert___, Validate_Update___, Insert_From_Templates
--  070605          to be able to release closed milestone lines.
--  070529  MaJalk  Modified Validate_Insert___ and Insert_From_Templates to check CO line state.
--  070522  MaJalk  Added new error message to Validate_Insert___.
--  070521  MaJalk  Modified Finite_State_Machine___ and added new method Check_Close___.
--  070505  MaJalk  Added method Get_State.
--  060207  IsAnlk  Mofdified Delete_Tree to check before delete.
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  040907  SaNalk  Added Get_Max_Progress.Modified Delete___,Update___,Insert___ and Finite_State_Set___ 
--  040907          to updated progress information if a project activity is connected to CO line.
--  040218  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes---------------------
--  030902  GaSolk Performed CR Merge 2.
--  030609  NuFilk Added Copy_Milestone_Lines method.
--  ******************************CR Merge***********************************
--  000913  FBen  Added UNDEFINE.
--  000303  PaLj  CID 34011 Set date_finshed in Finite_State_Set___
--                when state is closed and date is NULL.
--  000131  PaLj  Added call to Order_Line_Staged_Billing_API.Auto_Approve_Lines in Modify__
--  000114  PaLj  Changed Call to Staged_Billing in method Close__
--  991214  PaLj  Added Call to Staged_Billing in method Close__
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990527  JoEd  Changed error message STARTAFTEREXPECTED to work with Localize.
--  990419  RaKu  Y.Cleanup. Removed VIEW CUSTOMER_ORDER_MILESTONE_LINE.
--  990409  PaLj  YOSHIMURA - New Template
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  981116  CAST  SID 6934: Leadtime has to be an integer.
--  981116  CAST  SID 6980: Check that milestones connected to an invoiced/closed orderline are not updated.
--  981113  CAST  SID 6918: date_finished should be emptied when re-releasing a closed milestone-line.
--  981103  CAST  Check that progress is a number between 0 and 100.
--  981020  CAST  Added column progress.
--  980826  KaSu  Declared the LU Specific Implementaions methods.
--                Also moved the LU specific method definitions
--                to the correct place.
--  980825  KaSu  Modified Validate_Update and Created CUSTOMER_ORDER_MILESTONE_LINE
--  980823  KaSu  Modified Check_For_Cycle___,Validate_Update and
--  980806  KaSu  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Insert___
--   This will do validation regarding the milestones before inserting a record.
PROCEDURE Validate_Insert___ (
   newrec_ IN CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE )
IS
BEGIN

   --checking that lead_time is an integer
   IF (newrec_.lead_time != TRUNC(newrec_.lead_time, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIMENOTINTEGER: The lead time can only be integer');
   END IF;
   --checking for valid start date, end date, and lead time
   IF (newrec_.start_date IS NOT NULL) AND (newrec_.date_expected IS NOT NULL)  THEN
      IF (trunc(newrec_.start_date) > trunc(newrec_.date_expected)) THEN
         Error_SYS.Record_General(lu_name_, 'STARTAFTEREXPECTED: The start date cannot come after the expected date.');
      END IF;
      IF (newrec_.lead_time IS NOT NULL) THEN
         IF (trunc(newrec_.start_date) + trunc(newrec_.lead_time) != trunc(newrec_.date_expected)) THEN
            Error_SYS.Record_General(lu_name_, 'INCONSISTENTDATES: The start date and lead time and date expected are not consistent.');
         END IF;
      END IF;
   END IF;
   --checking for valid date_finished
   IF (newrec_.date_finished IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INITDATEFINISHED: The date finished cannot have value for a new mile stone');
   END IF;
   --checking for valid parent
   IF (newrec_.previous_milestone IS NOT NULL) THEN
      IF NOT Check_Exist___ ( newrec_.order_no , newrec_.line_no , newrec_.rel_no , newrec_.line_item_no , newrec_.previous_milestone ) THEN
         Error_SYS.Record_General(lu_name_, 'PREVIOUSMISSING: Corresponding previous milestone is not found');
      END IF;
   END IF;
   --checking for valid progress
   IF (newrec_.progress < 0) OR (newrec_.progress > 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGPROGRESS: Progress must be a number between 0 and 100');
   END IF;
END  Validate_Insert___;


-- Validate_Update___
--   This will do validation regarding the milestones before updating a record.
PROCEDURE Validate_Update___ (
   newrec_ IN CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE )
IS
   line_state_  VARCHAR2(20);
   oldrec_      Public_Rec;
BEGIN
   oldrec_ := Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.milestone_id);
   
   --Checking whether the milestone is closed
   IF newrec_.rowstate = 'Closed' THEN
      Error_SYS.Record_General(lu_name_, 'CLOSED: A Milestone cannot be modified when it is Closed');
   END IF;   
   
   --Checking whether the order line has status invoiced/closed
   line_state_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF (line_state_ = 'Invoiced') THEN
      IF NOT((newrec_.start_date != oldrec_.start_date) OR (NVL(to_char(newrec_.date_finished), '0') != NVL(to_char(oldrec_.date_finished), '0'))) THEN
         Error_SYS.Record_General(lu_name_, 'ORDERLINECLOSED: A Milestone cannot be modified when the order line is Invoiced/Closed');
      END IF;
   END IF;

   --checking that lead_time is an integer
   IF (newrec_.lead_time != TRUNC(newrec_.lead_time, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIMENOTINTEGER: The lead time can only be integer');
   END IF;
   --checking for valid date start date, end date, and lead time
   IF (newrec_.start_date IS NOT NULL) AND (newrec_.date_expected IS NOT NULL)  THEN
      IF (trunc(newrec_.start_date) > trunc(newrec_.date_expected)) THEN
         Error_SYS.Record_General(lu_name_, 'STARTAFTEREXPECTED: The start date cannot come after the expected date.');
      END IF;
      IF (newrec_.lead_time IS NOT NULL) THEN
         IF (trunc(newrec_.start_date) + trunc(newrec_.lead_time) != trunc(newrec_.date_expected)) THEN
            Error_SYS.Record_General(lu_name_, 'INCONSISTENTDATES: The start date and lead time and date expected are not consistent.');
         END IF;
      END IF;
   END IF;
   --checking for valid date_finished
   IF (newrec_.date_finished IS NOT NULL) THEN
      -- CUSTOMER_ORDER_LINE_API.Get_Contract(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no)
      IF (TRUNC(newrec_.date_finished) > TRUNC(Site_API.Get_Site_Date(newrec_.contract))) THEN
         Error_SYS.Record_General(lu_name_, 'FINISHEDFUTURE: The date finished cannot have a future date value');
      END IF;
      IF (newrec_.start_date IS NOT NULL)  THEN
         IF (TRUNC(newrec_.start_date) > TRUNC(newrec_.date_finished)  ) THEN
            Error_SYS.Record_General(lu_name_, 'STARTAFTERFINSHED: The date finished cannot come before start date');
         END IF;
      END IF;
   END IF;
   --checking for valid parent and for cycles
   IF (newrec_.previous_milestone IS NOT NULL) THEN
      IF NOT Check_Exist___ ( newrec_.order_no , newrec_.line_no , newrec_.rel_no , newrec_.line_item_no , newrec_.previous_milestone ) THEN
         Error_SYS.Record_General(lu_name_, 'PREVIOUSMISSING: Corresponding previous milestone is not found');
      ELSIF (newrec_.previous_milestone = newrec_.milestone_id) THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPREVIOUS: A milestone cannot have itself as its previous milestone');
      END IF;
      Check_For_Cycle___(newrec_);
   END IF;
   --checking for valid progress
   IF (newrec_.progress < 0) OR (newrec_.progress > 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGPROGRESS: Progress must be a number between 0 and 100');
   END IF;
END  Validate_Update___;


-- Withdraw_Parenthood___
--   This will remove the given milstone being a parent to any other milestone.
--   i.e. The given milestone will no more have any children. But the children
--   milestone will remain active on their own.
PROCEDURE Withdraw_Parenthood___ (
   remrec_ IN CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE )
IS
   dummy_ CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
   CURSOR children IS
      SELECT *
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no = remrec_.order_no
      AND line_no =  remrec_.line_no
      AND rel_no =  remrec_.rel_no
      AND line_item_no =  remrec_.line_item_no
      AND previous_milestone =  remrec_.milestone_id;
BEGIN
   FOR childrec_ IN children LOOP
      dummy_ := Lock_By_Keys___(childrec_.order_no, childrec_.line_no,
      childrec_.rel_no, childrec_.line_item_no, childrec_.milestone_id);
   END LOOP;

   UPDATE CUSTOMER_ORDER_MILESTONE_TAB
      SET previous_milestone = NULL
      WHERE order_no = remrec_.order_no
      AND line_no =  remrec_.line_no
      AND rel_no =  remrec_.rel_no
      AND previous_milestone =  remrec_.milestone_id;
END Withdraw_Parenthood___;


PROCEDURE Do_Set_Date_Finished___ (
   rec_  IN OUT CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   -- When a milestone is re-released, date_finished is emptied
   rec_.date_finished := NULL;
END Do_Set_Date_Finished___;


-- Check_For_Cycle___
--   This will check whether there exist any cycles when entering milestone.
--   If there exist any cycle then this will give error.
--   e.g. for cycle :
--   A is parent of B.
--   B is parent of C.
--   C is parent of A.
PROCEDURE Check_For_Cycle___ (
   newrec_ IN CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE)
IS
   ascendent_count_   NUMBER;
   previous_milestone_  VARCHAR2(5);

   CURSOR cur_asec_count IS
      SELECT count(*)
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no = newrec_.order_no
      AND line_no = newrec_.line_no
      AND rel_no =  newrec_.rel_no
      AND line_item_no = newrec_.line_item_no;
BEGIN
   OPEN  cur_asec_count;
   FETCH cur_asec_count INTO ascendent_count_;
   CLOSE cur_asec_count;
   previous_milestone_ := newrec_.previous_milestone;
   WHILE ( ascendent_count_ > 0 ) AND (previous_milestone_ IS NOT NULL) AND (newrec_.milestone_id != previous_milestone_) LOOP
      ascendent_count_  := ascendent_count_ - 1 ;
      previous_milestone_ := Get_Previous_Milestone(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, previous_milestone_);
   END LOOP;
   IF (previous_milestone_ IS NOT NULL) OR (newrec_.milestone_id = previous_milestone_) THEN
      Error_SYS.Record_General(lu_name_, 'CYCLE: There should not be any cycles when setting previous milestones ');
   END IF;
END Check_For_Cycle___;


FUNCTION Check_Close___ (
   rec_  IN     CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   state_ VARCHAR2(30);
BEGIN
   IF (rec_.previous_milestone IS NOT NULL) THEN
      state_ := Get_Objstate(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.previous_milestone);
      IF (state_ != 'Closed') THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTCLOSE: Milestone cannot be Closed when Previous Milestone for the line is in state Released.');
      END IF;
   END IF;
   RETURN TRUE;
END Check_Close___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
   activity_seq_ NUMBER;
BEGIN
   IF ( (state_ = 'Closed') AND (rec_.date_finished IS NULL) ) THEN
      rec_.date_finished := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(rec_.order_no));
   END IF;
   super(rec_, state_);
   
   UPDATE customer_order_milestone_tab
      SET date_finished = rec_.date_finished
      WHERE order_no = rec_.order_no
      AND   line_no = rec_.line_no
      AND   rel_no = rec_.rel_no
      AND   line_item_no = rec_.line_item_no
      AND   milestone_id = rec_.milestone_id;

   activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(rec_.order_no, rec_.line_no, rec_.rel_no,rec_.line_item_no);
   IF (activity_seq_ IS NOT NULL) THEN
      Customer_Order_Line_API.Calculate_Cost_And_Progress(rec_.order_no, rec_.line_no, rec_.rel_no,rec_.line_item_no);
   END IF;
END Finite_State_Set___;


@Override
PROCEDURE Finite_State_Add_To_Attr___ (
   rec_  IN     CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(rec_, attr_);
   Client_SYS.Add_To_Attr('DATE_FINISHED', rec_.date_finished, attr_);
END Finite_State_Add_To_Attr___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_ CUSTOMER_ORDER_MILESTONE_TAB.contract%TYPE;
BEGIN
   contract_ := Customer_Order_API.Get_Contract(Client_SYS.Get_Item_Value('ORDER_NO', attr_));
   super(attr_);
   Client_SYS.Add_To_Attr('START_DATE', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('PROGRESS', 0, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   activity_seq_ NUMBER;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
      
   activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(newrec_.order_no, newrec_.line_no, newrec_.rel_no,newrec_.line_item_no);
   IF (activity_seq_ IS NOT NULL) THEN
      Customer_Order_Line_API.Calculate_Cost_And_Progress(newrec_.order_no, newrec_.line_no, newrec_.rel_no,newrec_.line_item_no);
   END IF;
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   activity_seq_ NUMBER;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(newrec_.order_no, newrec_.line_no, newrec_.rel_no,newrec_.line_item_no);
   IF (activity_seq_ IS NOT NULL) THEN
      IF (NVL(oldrec_.progress,-1) != NVL(newrec_.progress,-1)) THEN
         Customer_Order_Line_API.Calculate_Cost_And_Progress(newrec_.order_no, newrec_.line_no, newrec_.rel_no,newrec_.line_item_no);
      END IF;
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE )
IS
   activity_seq_ NUMBER;
BEGIN
   super(objid_, remrec_);

   activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(remrec_.order_no, remrec_.line_no, remrec_.rel_no,remrec_.line_item_no);
   IF (activity_seq_ IS NOT NULL) THEN
      Customer_Order_Line_API.Calculate_Cost_And_Progress(remrec_.order_no, remrec_.line_no, remrec_.rel_no,remrec_.line_item_no);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_milestone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.contract := Customer_Order_API.Get_Contract(newrec_.order_no);
   super(newrec_, indrec_, attr_);
   
   Validate_Insert___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_milestone_tab%ROWTYPE,
   newrec_ IN OUT customer_order_milestone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Update___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_                CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   
   IF (action_ = 'DO') THEN
      newrec_.origin_date_expected := newrec_.date_expected;
      Client_SYS.Add_To_Attr('ORIGIN_DATE_EXPECTED', newrec_.origin_date_expected, attr_);
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;   
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
   newrec_ CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   
   IF (action_ = 'DO') THEN
      IF (oldrec_.origin_date_expected IS NULL)
         AND (newrec_.origin_date_expected IS NULL) AND (newrec_.date_expected IS NOT NULL) THEN
         newrec_.origin_date_expected := newrec_.date_expected;
         Client_SYS.Add_To_Attr('ORIGIN_DATE_EXPECTED', newrec_.origin_date_expected, attr_);
      END IF;
      IF (oldrec_.date_finished IS NULL) AND (newrec_.date_finished IS NOT NULL) THEN
         Finite_State_Set___ ( newrec_, 'Closed' );
         Finite_State_Add_To_Attr___(newrec_, attr_);
         Order_Line_Staged_Billing_API.Auto_Approve_Lines(newrec_.milestone_id,
              newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.date_finished);
      END IF;   
   END IF; 
   info_ := info_ || Client_SYS.Get_All_Info;   
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   END IF;
   
   super(info_, objid_, objversion_, action_);
   
   IF (action_ = 'DO') THEN
      Withdraw_Parenthood___(remrec_);      
   END IF;   
   info_ := info_ || Client_SYS.Get_All_Info;
END Remove__;


@Override
PROCEDURE Close__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   rec_ := Lock_By_Id___(objid_, objversion_);
   IF (action_ = 'DO') THEN
       Order_Line_Staged_Billing_API.Auto_Approve_Lines(rec_.milestone_id,
              rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.date_finished);   
   END IF;   
   
END Close__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Milestone_Exist
--   This will return 'TRUE' if the given milestone exist, else 'FALSE'.
@UncheckedAccess
FUNCTION Milestone_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(5);
   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no   = order_no_
      AND   line_no    = line_no_
      AND   rel_no = rel_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO exist_;
   IF exist_control%NOTFOUND THEN
      exist_ := 'FALSE';
   END IF;
   CLOSE exist_control;
   RETURN exist_;
END Milestone_Exist;


-- Child_Exist
--   This will return 'TRUE' if there exist atleast one child for the given
--   milestone, else 'FALSE'.
@UncheckedAccess
FUNCTION Child_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   milestone_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(5);
   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no            = order_no_
      AND   line_no             = line_no_
      AND   rel_no              = rel_no_
      AND   previous_milestone  = milestone_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO exist_;
   IF exist_control%NOTFOUND THEN
      exist_ := 'FALSE';
   END IF;
   CLOSE exist_control;
   RETURN exist_;
END Child_Exist;


-- Insert_From_Templates
--   This will insert all the milestones having the given TemplateId to the
--   given customer order line. The milestones with the given TemplateId are
--   obtained from the LU CustMilestoneTemplLine.
PROCEDURE Insert_From_Templates (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   template_id_  IN VARCHAR2)
IS
   newrec_           CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
   CURSOR cur_templ_ IS
      SELECT *
      FROM CUST_MILESTONE_TEMPL_LINE
      WHERE template_id = template_id_;
BEGIN
   IF order_no_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'ORDERNOMSSING: Order No Missing');
   END IF;
   IF line_no_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'LINENOMSSING:  Line No Missing');
   END IF;
   IF rel_no_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'RELEASENOMSSING:  Release No Missing');
   END IF;
   IF template_id_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'TEMPLATEIDMSSING: Template Id Missing');
   END IF;
   
   FOR templ_ IN cur_templ_ LOOP
      newrec_.order_no := order_no_;
      newrec_.line_no := line_no_;
      newrec_.rel_no := rel_no_;
      newrec_.line_item_no := line_item_no_;
      newrec_.milestone_id := templ_.milestone_id;
      newrec_.description := templ_.description;
      newrec_.lead_time := templ_.lead_time;
      newrec_.previous_milestone := templ_.previous_milestone;
      newrec_.note := templ_.note;
      newrec_.progress := templ_.progress;
      New___(newrec_);
   END LOOP;
END Insert_From_Templates;


-- Delete_Tree
--   This will delete the given milestone and all its descendent descendent milestones.
PROCEDURE Delete_Tree (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   milestone_id_ IN VARCHAR2 )
IS
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   CURSOR children IS
      SELECT milestone_id
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND previous_milestone = milestone_id_;
   CURSOR getrec IS
      SELECT *
      FROM CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND milestone_id = milestone_id_;
   rec_  CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;
BEGIN
   OPEN getrec;
   FETCH getrec INTO rec_;
   IF (getrec%FOUND) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_,
      order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.milestone_id);
      Check_Delete___(rec_);
      Delete___ (objid_, rec_ );
      FOR child_ IN children LOOP
         Delete_Tree(order_no_, line_no_, rel_no_, line_item_no_, child_.milestone_id);
      END LOOP;
   END IF;
   CLOSE getrec;
END Delete_Tree;


-- Copy_Milestone_Lines
--   copies all milestone details related to a customer order line to a
--   another customer order line.
PROCEDURE Copy_Milestone_Lines (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   con_order_no_     IN VARCHAR2,
   con_line_no_      IN VARCHAR2,
   con_rel_no_       IN VARCHAR2,
   con_line_item_no_ IN NUMBER )
IS
   newrec_      CUSTOMER_ORDER_MILESTONE_TAB%ROWTYPE;

    -- Note: Select all details to update with old line information
   CURSOR get_milestone_line IS
      SELECT *
      FROM  CUSTOMER_ORDER_MILESTONE_TAB
      WHERE order_no = con_order_no_
        AND line_no = con_line_no_
        AND rel_no = con_rel_no_
        AND line_item_no = con_line_item_no_;
BEGIN
   FOR mile_stone_rec_ IN get_milestone_line LOOP
      newrec_.order_no := order_no_;
      newrec_.line_no := line_no_;
      newrec_.rel_no := rel_no_;
      newrec_.line_item_no := line_item_no_;
      newrec_.milestone_id := mile_stone_rec_.milestone_id;
      newrec_.description :=  mile_stone_rec_.description;
      newrec_.lead_time :=  mile_stone_rec_.lead_time;
      newrec_.previous_milestone := mile_stone_rec_.previous_milestone;
      newrec_.note := mile_stone_rec_.note;
      newrec_.progress :=  mile_stone_rec_.progress;
      newrec_.contract := mile_stone_rec_.contract;
      
      IF (order_no_ = con_order_no_) THEN      
         newrec_.start_date := mile_stone_rec_.start_date;
         newrec_.date_expected := mile_stone_rec_.date_expected;
         newrec_.origin_date_expected := mile_stone_rec_.origin_date_expected;
         newrec_.date_finished := mile_stone_rec_.date_finished;
      ELSE
         newrec_.start_date :=  SYSDATE;
         newrec_.date_expected := (sysdate + mile_stone_rec_.lead_time);
      END IF;
      New___(newrec_);
   END LOOP;
END Copy_Milestone_Lines;


-- Get_Max_Progress
--   Returns the Maximum Progress value of the Closed Milestones.
@UncheckedAccess
FUNCTION Get_Max_Progress (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   progress_ NUMBER;
   CURSOR get_max_progress IS
      SELECT MAX(progress/100)
      FROM   CUSTOMER_ORDER_MILESTONE_TAB
      WHERE  order_no = order_no_
      AND    line_no    = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    rowstate = 'Closed';
BEGIN
   OPEN get_max_progress;
   FETCH get_max_progress INTO progress_;
   CLOSE get_max_progress;
   progress_ := NVL(progress_, 0);
   RETURN progress_ ;
END Get_Max_Progress;





