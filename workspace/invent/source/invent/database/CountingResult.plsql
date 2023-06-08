-----------------------------------------------------------------------------
--
--  Logical unit: CountingResult
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220113  JaThlk  SC21R2-2932, Modified Check_Insert___ to send an additional parameter, create_count_result_line_ when validating count part.
--  210118  SBalLK   Issue SC2020R1-11830, Modified New_Result() method by removing attr_ functionality to optimize the performance.
--  200226  SBalLK  Bug 151321(SCZ-8061), Added Check_Approval_Needed() method with inventory part in stock keys for calling from client where
--  200226          part ownership value not available in client.
--  190131  LaThlk  Bug 145505(SCZ-2030), Modified Insert___() by setting the count report line as confirmed before the counting result record is inserted.
--  180611  DaZase  SCUXXW4-5929, Added Get_Diff_Amount() and Get_Diff_Percentage() to be used from new Aurena client. 
--  170921  SURBLK  STRSC-12082, Added new method Get_Row_Identity to get the rowid.
--  161110  PrYaLK  Bug 132464, Modified Complete_Or_Cancel_Part___() by adding a new parameter configuration_id_ and used it in Cancel_Part() and
--  161110          Complete_Part() methods in order to cancel or complete the rejected records which have different configuration IDs.
--  160929  LEPESE  LIM-8882, Added value for parameter handling_unit_id_ in call to method Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock.
--  160920  SBalLK  Bug 129839, Modified Insert___() to set the counting report line as confirmed after the record inserted in to the counting result.
--  160629  Jhalse  LIM-7520, Changed several methods to use server based refresh of the handling unit snapshot.
--  160629                    Added new parameters to several methods to make use of the new Inventory_Event_ID concept.
--  151201  LEPESE  LIM-3917, renamed Inventory_Part_In_Stock_API.Count_Part_No_Pallet into Inventory_Part_In_Stock_API.Count_Part.
--  151201  LEPESE  LIM-4470, reversed the removal of call to Inventory_Part_In_Stock_API.Count_Part_No_Pallet from Do_Complete___.  
--  151125  JeLise  LIM-4470, Removed call to Inventory_Part_In_Stock_API.Count_Part_No_Pallet.
--  150508  JeLise  LIM-2883, Added activity_seq and handling_unit_id as parameters in Get_Last_Completed_Count_Date.
--  150408  Chfose  Added usage of new key column handling_unit_id throughout the logic.
--  140610  AwWelk  PRSC-1041, Modified Insert___() and Completed___() methods to take part ownership as COMPANY OWNED when it is found null 
--  140610          through the call to Inventory_Part_In_Stock_API.Get_Part_Ownership_Db().
--  130730  MaRalk  TIBE-833, Removed global LU constant inst_Project_ and modified Unpack_Check_Insert___ 
--  130730          using conditional compilation instead.
--  130625  TiRalk  Bug 110648, Modified Complete___() and Check_Approval_Needed() by moving common logic to new method Check_Approval_Needed___
--  130625          to consider part ownership when counting and modified Insert___ to add correct unit cost considering part ownership.
--  130111  Asawlk  Bug 106455, Modified New_Result() to create a new record in TemporaryPartTracking LU when "Identify Serials" dialog has not been invoked.
--  130108  GiSalk  Bug 106869, Added function Get_Total_Difference_Qty. 
--  121212  NipKlk  Bug 107075, Modified method New_Result() to validate the lowercase lot batch numbers to make them upper if no such lot batch number 
--  121212          available in Lot_Batch_Master.
--  120407  Asawlk  Bug 102063, Modified Do__Complete___() by passing values to inv_list_no_ and seq_no_ when calling Inventory_Part_Loc_Pallet_API.Count_Part()
--  120407          and Inventory_Part_In_Stock_API.Count_Part_No_Pallet(). 
--  111215  GanNLK  In the insert__ procedure, moved objversion to the bottom of the procedure.
--  111027  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  110224  LEPESE  Modification in Update___ to remove the part_tracking_session_id if qty_counted = qty_onhand.
--  110222  LEPESE  Added attribute part_tracking_session_id. Added function Part_Track_Id_Is_On_Rejected.
--  110222          Added parameter part_tracking_session_id_ to both overloaded versions of method New_Result().
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  101029  PraWlk  Bug 93902, Modified error message NOTALLOWREDUCING by correcting spelling mistakes.
--  101019  DAYJLK  Bug 92986, Added function Counting_Report_Exist.
--  100628  MaMalk  Changed the model and aligned the code in Finite_State_Machine___ according to the generated code.
--  100628          Moved the logic in public method Reset_Freeze_Flag to Reset_Freeze_Flag___ implementation method.
--  100628          Removed method Do_Cancel___  since it didn't contain any logic.
--  100511  KRPELK  Merge Rose Method Documentation.
--  100609  DAYJLK  Bug 90997, Added function Get_Last_Completed_Count_Date.
--  100128  Asawlk  Bug 88071, Modified Unpack_Check_Update___() to stop any modifications to qty_counted and catch_qty_counted
--  100128          when the record is in 'Cancelled' state too.
--  100122  Asawlk  Bug 88071, Modified Unpack_Check_Update___() to stop any modifications to qty_counted and catch_qty_counted
--  100122          when the record is in 'Completed' state.
--  090928  ChFolk  Removed unused parameter configuration_id_ in Complete_Or_Cancel_Part___ and unused variables in the package.
--  -------------------------------------- 14.0.0 -----------------------------
--  090730  Asawlk  Bug 84611, Modified method Complete_Or_Cancel_Report___() to raise an error when there are 
--  090730          no records found to be completed or canceled. 
--  090728  MaEelk  Bug 84709, Modified Complete_Or_Cancel_Part___ to raise an error where there are no rejected 
--  090728          parts to be completed or canceled.
--  090605  SuThlk  Bug 82951, Added new overloaded New_Result to wrap the existing functionality and return some values to client.
--  081007  NWeelk  Bug 76996, Modified the procedure Reset_Freeze_Flag, to reset the freeze flag when necessary.
--  081007          Restructured the code.
--  080630  Prawlk  Bug 74539, Changed methods Complete_Or_Cancel_Part and Complete_Or_Cancel_Report
--  080630          to implementation methods. Added methods Cancel_Part, Complete_Part, Cancel_Report
--  080630          and Complete_Report to call these implementation methods.
--  080627  Prawlk  Bug 74974, Added method Counting_Report_Line_Exist___ and used it in   
--  080627          Unpack_Check_Insert___ to check the existence of a record with the 
--  080627          same inv_list_no and seq as on the record currently being inserted.
--  071031  RoJalk  Bug 68811, Increased the length to 2000 of note_text in COUNTING_RESULT view. 
--  070621  DAYJLK  Modified text of error messages LOTUPPER, and SERIALUPPER.
--  070620  DAYJLK  Bug 65758, Added code in Unpack_Check_Insert___ to raise an error message 
--  070620          if a new lot_batch_no/serial_no has been added in lower case.
--  060322  LEPESE  Minor change in method New_Result to create a cost_detail_tab_ entry with
--  060322          unit_cost = 0 when no default cost structure can be found.
--  060216  LEPESE  Modifications in method Do__Complete___ to solve an upgrade problem where
--  060216          rejected counting results exist with NULL in cost_detail_id. In that case we
--  060216          create cost details right before calling Inventory_Part_In_Stock_API.
--  060123  MiKulk  Modified the method Check_Approval_Needed to correctly retrive values for the counting params.
--  060120  NiDalk  Added Assert safe annotation. 
--  051021  LEPESE  Added method Cost_Detail_Id_Is_On_Rejected.
--  051014  LEPESE  Changes for attribute inventory_value. No notice is taken to value sent in
--  051014          trough the New_Result method. Instead inventory_value is set inside Insert___.
--  051005  DaZase  Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  051005   KeFelk  Added Site_Invent_Info_API in some places for Site_API.
--  051004  LEPESE  Removed all references towards the Cost_Details_Enabled flag on Company.
--  050916  LEPESE  Added part_no_ in call to Temporary_Part_Cost_Detail_API.Add_Details.
--  050803  LEPESE  A new attribute cost_detail_id added to this LU. cost_detail_id_ is added
--  050803          as new parameter to method New_Result. Business logic added inside method
--  050803          New_Result to secure correct values in LU TemporaryPartCostDetail.
--  050803          Additional logic for cost_detail_id added to methods Unpack_Check_Insert___,
--  050803          Do_Complete___, Completed___ and Check_Approval_Needed.
--  **********************  DMC Begin  ****************************************
--  041020  SaJjlk  More validations to catch_qty_counted in Handle_Catch_Qty_Counting___ and renaming method to Check_Catch_Qty_Counting___.
--  041011  SaJjlk  Modifications to counting for catch unit enabled parts.
--  041005  SaJjlk  Added new method Handle_Catch_Qty_Counting___.
--  040920  SaJjlk  Added parameter catch_qty_counted_ to method call Inventory_Part_In_Stock_API.Validate_Count_Part.
--                  Added parameter catch_qty_difference_ to method calls Inventory_Part_Loc_Pallet_API.Count_Part and Inventory_Part_In_Stock_API.Count_Part_No_Pallet.
--  040917  SaJjlk  Added columns CATCH_QTY_ONHAND, CATCH_QTY_COUNTED and added them as parameters to method New_Result.
--  040812  DiVelk  Added 'activity_seq' to Counting_Report_Line_API.Get_Count_Report_No in
--  040812          Unpack_Check_Insert___. Modified [Unpack_Check_Insert___].
--  040810  MaEelk  Added the correct value of activity_seq to Inventory_Part_In_Stock_API.Validate_Count_Part
--  040810          in Procedure Unpack_Check_Insert___.
--  040722  Samnlk  Change the procedure Do__Complete___.
--  040721  DiVelk  Modified view comments of NOTE_TEXT.
--  040716  DiVelk  Added parameter Note_Text to [New_Result].
--  040715  DiVelk  Added new key Activity_Seq and attributes Project_Id, Note_Text.
--  040504  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes ---------------------
--  -------------------------------- 13.3.0 ----------------------------------
--  030626  DAYJLK  Modified view Counting_Result and relevant methods to handle new column Condition_Code.
--  030626          Added new default null parameters inventory_value_ and condition_code_ to parameter list
--  030626          of procedure New_Result. Modified procedures New_Result and Do__Complete___.
--  030605  JOHESE  Added check in Unpack_Check_Insert___ to prevent parts with part availability control 'not allow reducing' to be reduced
--  020918  LEPESE  ***************** IceAge Merge Start *********************
--  020813  ThJalk  Bug 32020, Added a check in PROCEDURE New_Result to see whether Inventory location exist before save new line in count report.
--  020503  Carase  Bug 29371. This bug correction complements bug 27874.
--                  Modified the PROCEDURE New_Result to fetch the qty_onhand from the
--                  Inventory_Part_Loc_Pallet_API when pallet exist.
--  020918  LEPESE  ***************** IceAge Merge End ***********************
--  020523  NASALK  Extended length of Serial no from VARCHAR2(15) to VARCHAR2(50) in view comments
--  020311  IsWilk  Bug Fix 27874, Modified the above correction.
--  020311  IsWilk  Bug Fix 27874, Modified the PROCEDURE New_Result.
--  020301  SaKaLk  Bug Fix 27917, Added a validation before calling INVENTORY_PART_IN_STOCK_API.Reset_Freeze_Flag.
--  000925  JOHESE  Added undefines.
--  000825  PaLj    CTO-adaptions. Configuration_Id added as key.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000103  AnHo    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Do_Complete___ (
   rec_  IN OUT counting_result_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_               counting_result_tab%ROWTYPE;
   newrec_               counting_result_tab%ROWTYPE;
   objid_                counting_result.objid%TYPE;
   objversion_           counting_result.objversion%TYPE;
   qty_difference_       NUMBER;
   catch_qty_difference_ NUMBER;
   cost_detail_id_       counting_result_tab.cost_detail_id%TYPE;
   indrec_               Indicator_Rec;
BEGIN
   qty_difference_       := rec_.qty_counted - rec_.qty_onhand;
   catch_qty_difference_ := rec_.catch_qty_counted - NVL(rec_.catch_qty_onhand,0);

   IF (rec_.cost_detail_id IS NULL) THEN
      cost_detail_id_ := Temporary_Part_Cost_Detail_API.Get_Next_Cost_Detail_Id;

      Temporary_Part_Cost_Detail_API.Generate_Details_From_Total(rec_.contract,
                                                                 rec_.part_no,
                                                                 rec_.configuration_id,
                                                                 rec_.inventory_value,
                                                                 cost_detail_id_);
   ELSE
      cost_detail_id_ := rec_.cost_detail_id;
   END IF;

   Inventory_Part_In_Stock_API.Count_Part(contract_                 => rec_.contract,
                                          part_no_                  => rec_.part_no,
                                          configuration_id_         => rec_.configuration_id,
                                          location_no_              => rec_.location_no,
                                          lot_batch_no_             => rec_.lot_batch_no,
                                          serial_no_                => rec_.serial_no,
                                          eng_chg_level_            => rec_.eng_chg_level,
                                          waiv_dev_rej_no_          => rec_.waiv_dev_rej_no,
                                          activity_seq_             => rec_.activity_seq,
                                          handling_unit_id_         => rec_.handling_unit_id,
                                          qty_difference_           => qty_difference_,
                                          catch_qty_difference_     => catch_qty_difference_,
                                          unit_cost_                => rec_.inventory_value,
                                          condition_code_           => rec_.condition_code,
                                          note_text_                => rec_.note_text,
                                          cost_detail_id_           => cost_detail_id_,
                                          part_tracking_session_id_ => rec_.part_tracking_session_id,
                                          inv_list_no_              => rec_.inv_list_no,
                                          seq_no_                   => rec_.seq);
   
   IF (rec_.rowstate = 'Rejected') THEN
      Client_SYS.Add_To_Attr('APPROVAL_USER_ID', Fnd_Session_API.Get_Fnd_User, attr_);
   END IF;
   Client_SYS.Add_To_Attr('DATE_COMPLETED', Site_API.Get_Site_Date(rec_.contract), attr_);

   oldrec_ := Lock_By_Keys___(contract_         => rec_.contract, 
                              part_no_          => rec_.part_no, 
                              configuration_id_ => rec_.configuration_id, 
                              location_no_      => rec_.location_no, 
                              lot_batch_no_     => rec_.lot_batch_no, 
                              serial_no_        => rec_.serial_no,
                              eng_chg_level_    => rec_.eng_chg_level, 
                              waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                              activity_seq_     => rec_.activity_seq, 
                              handling_unit_id_ => rec_.handling_unit_id,
                              count_date_       => rec_.count_date);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
END Do_Complete___;


PROCEDURE Do_Reject___ (
   rec_  IN OUT counting_result_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   IF (Inventory_Part_In_Stock_API.Check_Exist(contract_         => rec_.contract,
                                               part_no_          => rec_.part_no,
                                               configuration_id_ => rec_.configuration_id,
                                               location_no_      => rec_.location_no,
                                               lot_batch_no_     => rec_.lot_batch_no,
                                               serial_no_        => rec_.serial_no,
                                               eng_chg_level_    => rec_.eng_chg_level,
                                               waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                               activity_seq_     => rec_.activity_seq,
                                               handling_unit_id_ => rec_.handling_unit_id)) THEN

      Inventory_Part_In_Stock_API.Set_Freeze_Flag(contract_         => rec_.contract,
                                                  part_no_          => rec_.part_no,
                                                  configuration_id_ => rec_.configuration_id,
                                                  location_no_      => rec_.location_no,
                                                  lot_batch_no_     => rec_.lot_batch_no,
                                                  serial_no_        => rec_.serial_no,
                                                  eng_chg_level_    => rec_.eng_chg_level,
                                                  waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                                  activity_seq_     => rec_.activity_seq,
                                                  handling_unit_id_ => rec_.handling_unit_id);
   END IF;
END Do_Reject___;


-- Reset_Freeze_Flag___
--   Checks if the freeze flag on a part on a specific location should be
--   reset to Not frozen and if it should a call to Reset_Freeze_Flag in
--   InventoryPartLocation is made.
PROCEDURE Reset_Freeze_Flag___ (
   rec_  IN OUT counting_result_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   rejected_record_exists_ VARCHAR2(5); 
   exit_procedure_         EXCEPTION;
                                        
   CURSOR get_counting_report_lines IS  
      SELECT inv_list_no, seq           
      FROM counting_report_line_pub     
      WHERE contract         = rec_.contract
      AND   part_no          = rec_.part_no
      AND   configuration_id = rec_.configuration_id
      AND   location_no      = rec_.location_no    
      AND   lot_batch_no     = rec_.lot_batch_no    
      AND   serial_no        = rec_.serial_no       
      AND   eng_chg_level    = rec_.eng_chg_level    
      AND   waiv_dev_rej_no  = rec_.waiv_dev_rej_no  
      AND   activity_seq     = rec_.activity_seq
      AND   handling_unit_id = rec_.handling_unit_id;   
BEGIN
   rejected_record_exists_ := Check_Rejected_Part_Location(contract_         => rec_.contract,              
                                                           part_no_          => rec_.part_no,               
                                                           configuration_id_ => rec_.configuration_id,      
                                                           location_no_      => rec_.location_no,           
                                                           lot_batch_no_     => rec_.lot_batch_no,          
                                                           serial_no_        => rec_.serial_no,             
                                                           eng_chg_level_    => rec_.eng_chg_level,         
                                                           waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,       
                                                           activity_seq_     => rec_.activity_seq,
                                                           handling_unit_id_ => rec_.handling_unit_id);         
   IF (rejected_record_exists_ = 'TRUE') THEN 
      RAISE exit_procedure_;                        
   END IF;                                    

   FOR countingrec_ IN get_counting_report_lines LOOP      
      IF NOT (Counting_Report_Line_Exist___(countingrec_.inv_list_no, countingrec_.seq)) THEN    
         IF (Counting_Report_API.Get_Freeze_Code_Db(countingrec_.inv_list_no) = 'Y') THEN 
            RAISE exit_procedure_; 
         END IF;           
      END IF;              
   END LOOP;               

   Inventory_Part_In_Stock_API.Reset_Freeze_Flag(contract_         => rec_.contract,                     
                                                 part_no_          => rec_.part_no,                      
                                                 configuration_id_ => rec_.configuration_id,             
                                                 location_no_      => rec_.location_no,                  
                                                 lot_batch_no_     => rec_.lot_batch_no,                 
                                                 serial_no_        => rec_.serial_no,                    
                                                 eng_chg_level_    => rec_.eng_chg_level,                
                                                 waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,              
                                                 activity_seq_     => rec_.activity_seq,
                                                 handling_unit_id_ => rec_.handling_unit_id); 
EXCEPTION  
   WHEN exit_procedure_ THEN  
      NULL;         
END Reset_Freeze_Flag___;


FUNCTION Completed___ (
   rec_ IN counting_result_tab%ROWTYPE ) RETURN BOOLEAN
IS
   qty_difference_    NUMBER;
   quantity_onhand_   NUMBER;
   unit_cost_         NUMBER;
   part_ownership_db_ VARCHAR2(20);
BEGIN
   qty_difference_  := rec_.qty_counted - rec_.qty_onhand;
   quantity_onhand_ := rec_.qty_onhand;

   IF (qty_difference_ != 0) THEN
      IF(rec_.count_diff_amount IS NOT NULL) THEN
         part_ownership_db_ := Inventory_Part_In_Stock_API.Get_Part_Ownership_Db(contract_         => rec_.contract,
                                                                                 part_no_          => rec_.part_no,
                                                                                 configuration_id_ => rec_.configuration_id,
                                                                                 location_no_      => rec_.location_no,
                                                                                 lot_batch_no_     => rec_.lot_batch_no,
                                                                                 serial_no_        => rec_.serial_no,
                                                                                 eng_chg_level_    => rec_.eng_chg_level,
                                                                                 waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                                                                 activity_seq_     => rec_.activity_seq,
                                                                                 handling_unit_id_ => rec_.handling_unit_id);
         IF NVL(part_ownership_db_, Part_Ownership_API.DB_COMPANY_OWNED) IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_CONSIGNMENT) THEN
            IF (rec_.cost_detail_id IS NULL) THEN
               unit_cost_ := rec_.inventory_value;
            ELSE
               unit_cost_ := Temporary_Part_Cost_Detail_API.Get_Total_Unit_Cost(rec_.cost_detail_id);
            END IF;
         ELSE
            unit_cost_ := 0;
         END IF;
      END IF;

      IF (Check_Approval_Needed___(qty_difference_,
                                   rec_.count_diff_amount,
                                   unit_cost_,
                                   rec_.count_diff_percentage,
                                   quantity_onhand_)) THEN
         RETURN FALSE;
      END IF;
   END IF;

   RETURN TRUE;
END Completed___;


-- Counting_Report_Line_Exist___
--   Check if a counting report line exists.
FUNCTION Counting_Report_Line_Exist___ (
   inv_list_no_ IN VARCHAR2,
   seq_         IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR line_exists IS
      SELECT 1
      FROM counting_result_tab
      WHERE inv_list_no = inv_list_no_
      AND   seq = seq_;
BEGIN
   OPEN line_exists;
   FETCH line_exists INTO dummy_;
   IF (line_exists%FOUND) THEN
      CLOSE line_exists;
      RETURN TRUE;
   END IF;
   CLOSE line_exists;
   RETURN FALSE;
END Counting_Report_Line_Exist___;


-- Complete_Or_Cancel_Part___
--   This procedure is used to complete or cancel (events) all rejected
--   records on an inventory part.
PROCEDURE Complete_Or_Cancel_Part___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   event_            IN VARCHAR2 )
IS
   rec_  counting_result_tab%ROWTYPE;
   attr_ VARCHAR2(2000);
   CURSOR check_part IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, count_date
      FROM counting_result_tab
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   configuration_id = configuration_id_
      AND   inv_list_no = '*'
      AND   rowstate = 'Rejected';
   TYPE Rejected_Result_Tab IS TABLE OF check_part%ROWTYPE
      INDEX BY PLS_INTEGER;
 
   rejected_result_tab_ Rejected_Result_Tab;     
BEGIN
   OPEN  check_part;
   FETCH check_part BULK COLLECT INTO rejected_result_tab_;
   CLOSE check_part;
   IF (rejected_result_tab_.COUNT > 0) THEN
      FOR i IN rejected_result_tab_.FIRST..rejected_result_tab_.LAST LOOP
         rec_ := Get_Object_By_Keys___(contract_         => rejected_result_tab_(i).contract, 
                                       part_no_          => rejected_result_tab_(i).part_no, 
                                       configuration_id_ => rejected_result_tab_(i).configuration_id,
                                       location_no_      => rejected_result_tab_(i).location_no, 
                                       lot_batch_no_     => rejected_result_tab_(i).lot_batch_no, 
                                       serial_no_        => rejected_result_tab_(i).serial_no,
                                       eng_chg_level_    => rejected_result_tab_(i).eng_chg_level, 
                                       waiv_dev_rej_no_  => rejected_result_tab_(i).waiv_dev_rej_no, 
                                       activity_seq_     => rejected_result_tab_(i).activity_seq,
                                       handling_unit_id_ => rejected_result_tab_(i).handling_unit_id,
                                       count_date_       => rejected_result_tab_(i).count_date);
         Finite_State_Machine___(rec_, event_, attr_);
      END LOOP;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOREJDATA: The counting results for all lines have been approved or canceled.');
   END IF;
END Complete_Or_Cancel_Part___;


-- Complete_Or_Cancel_Report___
--   This procedure is used to complete or cancel (events) all rejected
--   records on a count report.
PROCEDURE Complete_Or_Cancel_Report___ (
   inv_list_no_ IN VARCHAR2,
   event_       IN VARCHAR2 )
IS
   rec_           counting_result_tab%ROWTYPE;
   attr_          VARCHAR2(2000);
   records_exist_ BOOLEAN := FALSE;
   CURSOR check_report IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
             eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, count_date
      FROM counting_result_tab
      WHERE inv_list_no = inv_list_no_
      AND   rowstate = 'Rejected';
BEGIN
   FOR compl_rec_ IN check_report LOOP
      rec_ := Get_Object_By_Keys___(contract_         => compl_rec_.contract, 
                                    part_no_          => compl_rec_.part_no, 
                                    configuration_id_ => compl_rec_.configuration_id,
                                    location_no_      => compl_rec_.location_no, 
                                    lot_batch_no_     => compl_rec_.lot_batch_no, 
                                    serial_no_        => compl_rec_.serial_no,
                                    eng_chg_level_    => compl_rec_.eng_chg_level, 
                                    waiv_dev_rej_no_  => compl_rec_.waiv_dev_rej_no, 
                                    activity_seq_     => compl_rec_.activity_seq,
                                    handling_unit_id_ => compl_rec_.handling_unit_id,
                                    count_date_       => compl_rec_.count_date);
      Finite_State_Machine___(rec_, event_, attr_);
      records_exist_ := TRUE;
   END LOOP;
   IF NOT(records_exist_) THEN
      Error_SYS.Record_General(lu_name_,'NORECORDEXIST: The lines for which counting has been performed have already been approved or canceled.');      
   END IF;
END Complete_Or_Cancel_Report___;


FUNCTION Check_Approval_Needed___ (
   qty_difference_        IN NUMBER,
   count_diff_amount_     IN NUMBER,
   inventory_value_       IN NUMBER,
   count_diff_percentage_ IN NUMBER,
   quantity_onhand_       IN NUMBER ) RETURN BOOLEAN
IS
   quantity_on_hand_ NUMBER;
BEGIN
   IF count_diff_amount_ IS NOT NULL THEN 
      IF (ABS(qty_difference_ * inventory_value_) > count_diff_amount_) THEN
         RETURN TRUE;
      END IF;
   END IF; 

   IF (count_diff_percentage_ IS NOT NULL) THEN
      IF (quantity_onhand_ = 0) THEN
         quantity_on_hand_ := 1;
      ELSE
         quantity_on_hand_ := quantity_onhand_;
      END IF;
      IF ((ABS((qty_difference_ / quantity_on_hand_) * 100)) > count_diff_percentage_) THEN
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Check_Approval_Needed___;


-- Check_Catch_Qty_Counting___
--   Handles the counting of catch unit enabled parts.
PROCEDURE Check_Catch_Qty_Counting___ (
   newrec_ IN OUT counting_result_tab%ROWTYPE)
IS
BEGIN
   IF (newrec_.catch_qty_counted IS NULL) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'CATCH_QTY_COUNTED', newrec_.catch_qty_counted);
   END IF;

   IF (newrec_.catch_qty_counted < 0) THEN
      Error_SYS.Record_General('CountingResult', 'CATCHNONEGATIVE: The catch quantity counted must be greater than or equal to zero.');
   END IF;

   IF (newrec_.qty_counted = 0) THEN
      IF (newrec_.catch_qty_counted != 0) THEN
         Error_SYS.Record_General('CountingResult', 'CATCHQTYISZERO: The catch quantity counted must be zero when the quantity counted is zero.');
      END IF;
   ELSE
      IF (newrec_.catch_qty_counted = 0) THEN
         Error_SYS.Record_General('CountingResult','CATCHQTYCANNOTZERO: The catch quantity counted cannot be zero when the quantity counted is greater than zero.');
      END IF;
   END IF;
END Check_Catch_Qty_Counting___;

@Override
PROCEDURE Insert___ (
   objid_               OUT    VARCHAR2,
   objversion_          OUT    VARCHAR2,
   newrec_              IN OUT counting_result_tab%ROWTYPE,
   attr_                IN OUT VARCHAR2)
IS
   part_ownership_db_ VARCHAR2(20);
BEGIN
   newrec_.count_diff_percentage := Site_Invent_Info_API.Get_Count_Diff_Percentage(newrec_.contract);
   newrec_.count_diff_amount     := Site_Invent_Info_API.Get_Count_Diff_Amount(newrec_.contract);
   
   part_ownership_db_ := Inventory_Part_In_Stock_API.Get_Part_Ownership_Db(contract_         => newrec_.contract,
                                                                           part_no_          => newrec_.part_no,
                                                                           configuration_id_ => newrec_.configuration_id,
                                                                           location_no_      => newrec_.location_no,
                                                                           lot_batch_no_     => newrec_.lot_batch_no,
                                                                           serial_no_        => newrec_.serial_no,
                                                                           eng_chg_level_    => newrec_.eng_chg_level,
                                                                           waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                           activity_seq_     => newrec_.activity_seq,
                                                                           handling_unit_id_ => newrec_.handling_unit_id);

   IF NVL(part_ownership_db_, Part_Ownership_API.DB_COMPANY_OWNED) IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_CONSIGNMENT) THEN
      newrec_.inventory_value := Temporary_Part_Cost_Detail_API.Get_Total_Unit_Cost(newrec_.cost_detail_id);
   ELSE
      newrec_.inventory_value := 0;
   END IF;
   
   IF(newrec_.inv_list_no != '*') THEN
      Counting_Report_Line_API.Set_Confirmed(newrec_.inv_list_no, newrec_.seq);
      
      IF (Counting_Report_Line_API.Check_Unconfirmed_Lines(newrec_.inv_list_no) = Fnd_Boolean_API.DB_FALSE) THEN
         Hu_Snapshot_For_Refresh_API.New(source_ref1_          => newrec_.inv_list_no,
                                         source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT);
      END IF;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);   
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     counting_result_tab%ROWTYPE,
   newrec_     IN OUT counting_result_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ((newrec_.qty_onhand = newrec_.qty_counted) AND 
       (newrec_.part_tracking_session_id IS NOT NULL)) THEN
      Temporary_Part_Tracking_API.Remove_Session(newrec_.part_tracking_session_id);
      newrec_.part_tracking_session_id := NULL;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT counting_result_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   freeze_flag_db_   VARCHAR2(5);
   inv_list_no_      VARCHAR2(15);
   site_check_       NUMBER;
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.inv_list_no != '*') THEN
      IF (Counting_Report_Line_Exist___(newrec_.inv_list_no, newrec_.seq)) THEN
         Error_SYS.Record_General('CountingResult', 'COUNTCONFIRMED: The counting result for line :P1 on counting report :P2 has already been confirmed.', newrec_.seq, newrec_.inv_list_no);
      END IF;
      Counting_Report_Line_API.Exist(newrec_.inv_list_no, newrec_.seq);
      Inventory_Part_In_Stock_API.Exist(contract_         => newrec_.contract, 
                                        part_no_          => newrec_.part_no, 
                                        configuration_id_ => newrec_.configuration_id, 
                                        location_no_      => newrec_.location_no, 
                                        lot_batch_no_     => newrec_.lot_batch_no, 
                                        serial_no_        => newrec_.serial_no, 
                                        eng_chg_level_    => newrec_.eng_chg_level, 
                                        waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                        activity_seq_     => newrec_.activity_seq,
                                        handling_unit_id_ => newrec_.handling_unit_id);
   END IF;

   IF (newrec_.qty_counted < newrec_.qty_onhand) THEN
      IF Part_Availability_Control_API.Check_Counting_Control (
         Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_         => newrec_.contract,
                                                                 part_no_          => newrec_.part_no,
                                                                 configuration_id_ => newrec_.configuration_id,
                                                                 location_no_      => newrec_.location_no,
                                                                 lot_batch_no_     => newrec_.lot_batch_no,
                                                                 serial_no_        => newrec_.serial_no,
                                                                 eng_chg_level_    => newrec_.eng_chg_level,
                                                                 waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                 activity_seq_     => newrec_.activity_seq,
                                                                 handling_unit_id_ => newrec_.handling_unit_id)
                                                               ) = 'NOT ALLOW REDUCING' THEN
         Error_SYS.Record_General('CountingResult', 'NOTALLOWREDUCING: Reducing quantity is not allowed by Part Availability Control');
      END IF;
   END IF;

   IF (newrec_.inv_list_no = '*') THEN
      freeze_flag_db_ := Inventory_Part_In_Stock_API.Get_Freeze_Flag_Db(contract_         => newrec_.contract,
                                                                        part_no_          => newrec_.part_no,
                                                                        configuration_id_ => newrec_.configuration_id,
                                                                        location_no_      => newrec_.location_no,
                                                                        lot_batch_no_     => newrec_.lot_batch_no,
                                                                        serial_no_        => newrec_.serial_no,
                                                                        eng_chg_level_    => newrec_.eng_chg_level,
                                                                        waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                        activity_seq_     => newrec_.activity_seq,
                                                                        handling_unit_id_ => newrec_.handling_unit_id);
      IF (freeze_flag_db_ = 'Y') THEN
         inv_list_no_ := Counting_Report_Line_API.Get_Count_Report_No(contract_         => newrec_.contract,
                                                                      part_no_          => newrec_.part_no,
                                                                      configuration_id_ => newrec_.configuration_id,
                                                                      location_no_      => newrec_.location_no,
                                                                      lot_batch_no_     => newrec_.lot_batch_no,
                                                                      eng_chg_level_    => newrec_.eng_chg_level,
                                                                      waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                      serial_no_        => newrec_.serial_no,
                                                                      activity_seq_     => newrec_.activity_seq,
                                                                      handling_unit_id_ => newrec_.handling_unit_id);
         IF (inv_list_no_ IS NULL) THEN
            Error_SYS.Record_General('CountingResult', 'PARTLOCFROZENNOREP: The record is frozen for counting.');
         ELSE
            Error_SYS.Record_General('CountingResult', 'PARTLOCFROZEN: The record is frozen for counting on Count Report No :P1', inv_list_no_);
         END IF;
      END IF;
   END IF;

   Inventory_Part_In_Stock_API.Validate_Count_Part(contract_                       => newrec_.contract,
                                                   part_no_                        => newrec_.part_no,
                                                   configuration_id_               => newrec_.configuration_id,
                                                   location_no_                    => newrec_.location_no,
                                                   lot_batch_no_                   => newrec_.lot_batch_no,
                                                   serial_no_                      => newrec_.serial_no,
                                                   eng_chg_level_                  => newrec_.eng_chg_level,
                                                   waiv_dev_rej_no_                => newrec_.waiv_dev_rej_no,
                                                   activity_seq_                   => newrec_.activity_seq,
                                                   handling_unit_id_               => newrec_.handling_unit_id,
                                                   qty_counted_                    => newrec_.qty_counted,
                                                   catch_qty_counted_              => newrec_.catch_qty_counted,
                                                   qty_difference_                 => newrec_.qty_counted - newrec_.qty_onhand,
                                                   part_tracking_session_id_       => newrec_.part_tracking_session_id,
                                                   ignore_serial_in_different_loc_ => TRUE);

   $IF Component_Proj_SYS.INSTALLED $THEN
      IF (newrec_.activity_seq != 0) THEN
         newrec_.project_id := Activity_API.Get_Project_Id(newrec_.activity_seq);
         site_check_        := Project_Site_API.Project_Site_Exist(newrec_.project_id,newrec_.contract);   
         
         IF site_check_ = 0 THEN
            Error_SYS.Record_General(lu_name_,'NOTPRJSITECOUNTRESULT: Site :P1 is not a valid project site for project :P2.',newrec_.contract,newrec_.project_id);
         END IF; 
      END IF;              
   $END

   IF (Lot_Batch_Master_API.Check_Exist(newrec_.part_no, newrec_.lot_batch_no) = 'FALSE' ) THEN
      Error_SYS.Check_Valid_Key_String('LOT_BATCH_NO',newrec_.lot_batch_no);
      IF (UPPER(newrec_.lot_batch_no) != newrec_.lot_batch_no) THEN
         Error_SYS.Record_General(lu_name_,'LOTUPPER: The Lot/Batch number must be entered in uppercase.');
      END IF;
   END IF;

   IF (Part_Serial_Catalog_API.Check_Exist(newrec_.part_no, newrec_.serial_no) = 'FALSE' ) THEN
      Error_SYS.Check_Valid_Key_String('SERIAL_NO',newrec_.serial_no);
      IF (UPPER(newrec_.serial_no) != newrec_.serial_no) THEN
         Error_SYS.Record_General(lu_name_,'SERIALUPPER: The Serial Number must be entered in uppercase.');
      END IF;
   END IF;

  --If catch unit handling is enabled on the part the catch_qty_counted should be mandatory
   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   IF (part_catalog_rec_.catch_unit_enabled = 'TRUE') THEN
      Check_Catch_Qty_Counting___(newrec_);
   ELSE
      newrec_.catch_qty_counted := NULL;
      newrec_.catch_qty_onhand  := NULL;
   END IF;

   IF (newrec_.cost_detail_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'COSTDETERR: A cost detail structure must be defined for this counting result.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     counting_result_tab%ROWTYPE,
   newrec_ IN OUT counting_result_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
   number_null_      NUMBER := -999999999999;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.part_tracking_session_id) AND
       (oldrec_.part_tracking_session_id IS NOT NULL) AND (newrec_.part_tracking_session_id IS NOT NULL) THEN
      Error_SYS.Item_Update(lu_name_, 'PART_TRACKING_SESSION_ID');
   END IF;

   IF (oldrec_.rowstate IN ('Completed', 'Cancelled')) THEN
      IF (oldrec_.qty_counted != newrec_.qty_counted) OR 
          (NVL(oldrec_.catch_qty_counted, number_null_) != NVL(newrec_.catch_qty_counted, number_null_)) THEN
         Error_SYS.Record_General('CountingResult', 'INVALID_QTY_MODIFY: The counted quantity/counted catch quantity cannot be modified since it has been approved or canceled.');
      END IF;
   ELSE
      --If catch unit handling is enabled on the part the catch_qty_counted should be mandatory
      part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   
      IF (part_catalog_rec_.catch_unit_enabled = 'TRUE') THEN
         Check_Catch_Qty_Counting___(newrec_);
      ELSE
         newrec_.catch_qty_counted := NULL;
         newrec_.catch_qty_onhand  := NULL;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Returns TRUE if the record exist otherwise it returns FALSE.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   count_date_       IN DATE ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___ (contract_          => contract_,
                       part_no_           => part_no_,
                       configuration_id_  => configuration_id_,
                       location_no_       => location_no_,
                       lot_batch_no_      => lot_batch_no_,
                       serial_no_         => serial_no_,
                       eng_chg_level_     => eng_chg_level_,
                       waiv_dev_rej_no_   => waiv_dev_rej_no_,
                       activity_seq_      => activity_seq_,
                       handling_unit_id_  => handling_unit_id_,
                       count_date_        => count_date_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- New_Result
--   Creates a new record in LU CountingResult and checks if the difference
--   between quantity counted and quantity onhand exceeds the Max Counting
--   Difference Amount and/or the Max Counting Difference Percentage.
--   If they are exceeded the record gets state Completed, if not it gets
--   the state Rejected.
PROCEDURE New_Result (
   tot_qty_onhand_           OUT NUMBER,
   tot_qty_reserved_         OUT NUMBER,
   tot_qty_in_transit_       OUT NUMBER,
   tot_qty_in_order_transit_ OUT NUMBER,
   acc_count_diff_           OUT NUMBER,
   state_                    OUT VARCHAR2,
   contract_                 IN  VARCHAR2,
   part_no_                  IN  VARCHAR2,
   configuration_id_         IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   count_date_               IN  DATE,
   inv_list_no_              IN  VARCHAR2,
   seq_                      IN  NUMBER,
   qty_onhand_               IN  NUMBER,
   qty_counted_              IN  NUMBER,
   catch_qty_onhand_         IN  NUMBER,
   catch_qty_counted_        IN  NUMBER,
   count_user_id_            IN  VARCHAR2,
   inventory_value_          IN  NUMBER,
   condition_code_           IN  VARCHAR2,
   note_text_                IN  VARCHAR2,
   cost_detail_id_           IN  NUMBER,
   part_tracking_session_id_ IN  NUMBER DEFAULT NULL )
IS
   local_lot_batch_no_ counting_result_tab.lot_batch_no%TYPE;
   local_session_id_   NUMBER;
   local_serial_no_    counting_result_tab.serial_no%TYPE;
BEGIN
  local_serial_no_  := serial_no_; 
  local_session_id_ := part_tracking_session_id_;

  IF ((local_session_id_ IS NULL) AND (qty_onhand_ < qty_counted_) AND (local_serial_no_ != '*')) THEN
     -- Positive counting difference for a specified serial number.
     IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_)) THEN
        -- Part is configured to have serial tracking only during receipt and issue, not in inventory
        local_serial_no_ := Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock(part_no_, 
                                                                                local_serial_no_, 
                                                                                Part_Catalog_API.Get(part_no_),
                                                                                Inventory_Location_API.Get_Location_Type_Db(contract_,location_no_),
                                                                                handling_unit_id_);
        IF (local_serial_no_ = '*') THEN
           -- The serial number should not be specified on the stock record so we need to add 
           -- an entry in the temporary part tracking object.
           local_session_id_ := Temporary_Part_Tracking_API.Get_Next_Session_Id;
           Temporary_Part_Tracking_API.New(local_session_id_, 
                                           serial_no_, 
                                           catch_qty_counted_, 
                                           contract_, 
                                           part_no_, 
                                           'POSITIVE_COUNTING_DIFF');
        END IF;
     END IF;
  END IF;
  
  local_lot_batch_no_ := lot_batch_no_;
  IF (local_lot_batch_no_ != UPPER(local_lot_batch_no_)) THEN
     IF (Lot_Batch_Master_API.Check_Exist(part_no_, local_lot_batch_no_ ) = 'FALSE') THEN
        local_lot_batch_no_ := UPPER(local_lot_batch_no_);
     END IF;
  END IF;
  
  New_Result(state_                    => state_,
             contract_                 => contract_,
             part_no_                  => part_no_,
             configuration_id_         => configuration_id_,
             location_no_              => location_no_,
             lot_batch_no_             => local_lot_batch_no_,
             serial_no_                => local_serial_no_,
             eng_chg_level_            => eng_chg_level_,
             waiv_dev_rej_no_          => waiv_dev_rej_no_,
             activity_seq_             => activity_seq_,
             handling_unit_id_         => handling_unit_id_,
             count_date_               => count_date_,
             inv_list_no_              => inv_list_no_,
             seq_                      => seq_,
             qty_onhand_               => qty_onhand_,
             qty_counted_              => qty_counted_,
             catch_qty_onhand_         => catch_qty_onhand_,
             catch_qty_counted_        => catch_qty_counted_,
             count_user_id_            => count_user_id_,
             inventory_value_          => inventory_value_,
             condition_code_           => condition_code_,
             note_text_                => note_text_,
             cost_detail_id_           => cost_detail_id_,
             part_tracking_session_id_ => local_session_id_);

   Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_       => tot_qty_onhand_,
                                                      qty_reserved_     => tot_qty_reserved_,
                                                      qty_in_transit_   => tot_qty_in_transit_,
                                                      contract_         => contract_, 
                                                      part_no_          => part_no_,
                                                      configuration_id_ => configuration_id_);

   tot_qty_in_order_transit_ := Inventory_Part_In_Transit_API.Get_Total_Qty_In_Order_Transit(
                                                                            contract_, 
                                                                            part_no_,
                                                                            configuration_id_);
   tot_qty_in_transit_       := tot_qty_in_transit_ - tot_qty_in_order_transit_;
   acc_count_diff_           := Inventory_Part_API.Get_Count_Variance(contract_, part_no_);
END New_Result;


-- New_Result
--   Creates a new record in LU CountingResult and checks if the difference
--   between quantity counted and quantity onhand exceeds the Max Counting
--   Difference Amount and/or the Max Counting Difference Percentage.
--   If they are exceeded the record gets state Completed, if not it gets
--   the state Rejected.
PROCEDURE New_Result (
   state_                    OUT VARCHAR2,
   contract_                 IN  VARCHAR2,
   part_no_                  IN  VARCHAR2,
   configuration_id_         IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   count_date_               IN  DATE,
   inv_list_no_              IN  VARCHAR2,
   seq_                      IN  NUMBER,
   qty_onhand_               IN  NUMBER,
   qty_counted_              IN  NUMBER,
   catch_qty_onhand_         IN  NUMBER,
   catch_qty_counted_        IN  NUMBER,
   count_user_id_            IN  VARCHAR2,
   inventory_value_          IN  NUMBER   DEFAULT NULL,
   condition_code_           IN  VARCHAR2 DEFAULT NULL,
   note_text_                IN  VARCHAR2 DEFAULT NULL,
   cost_detail_id_           IN  NUMBER   DEFAULT NULL,
   part_tracking_session_id_ IN  NUMBER   DEFAULT NULL)
IS
   newrec_                counting_result_tab%ROWTYPE;
   local_cost_detail_id_  NUMBER;
   inv_part_in_stock_rec_ Inventory_Part_In_Stock_API.Public_Rec;
   cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN
   Inventory_Location_API.Exist(contract_,location_no_);
   
   newrec_.contract         := contract_;
   newrec_.part_no          := part_no_;
   newrec_.configuration_id := configuration_id_;
   newrec_.location_no      := location_no_;
   newrec_.lot_batch_no     := lot_batch_no_;
   newrec_.serial_no        := serial_no_;
   newrec_.eng_chg_level    := eng_chg_level_;
   newrec_.waiv_dev_rej_no  := waiv_dev_rej_no_;
   newrec_.activity_seq     := activity_seq_;
   newrec_.handling_unit_id := handling_unit_id_;
   newrec_.count_date       := NVL(count_date_, Site_API.Get_Site_Date(contract_));
   newrec_.inv_list_no      := NVL(inv_list_no_, '*');
   newrec_.seq              := NVL(seq_, 0);
   
   IF (qty_onhand_ IS NOT NULL) THEN
      --Here we have to use the qty_onhand_ from the Inventory_Part_In_Stock_API due to rounding problem.
      inv_part_in_stock_rec_ := Inventory_Part_In_Stock_API.Get(contract_           => contract_,
                                                                part_no_            => part_no_,
                                                                configuration_id_   => configuration_id_,
                                                                location_no_        => location_no_,
                                                                lot_batch_no_       => lot_batch_no_,
                                                                serial_no_          => serial_no_,
                                                                eng_chg_level_      => eng_chg_level_,
                                                                waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                activity_seq_       => activity_seq_,
                                                                handling_unit_id_   => handling_unit_id_);
      
      newrec_.qty_onhand       := NVL(inv_part_in_stock_rec_.qty_onhand, qty_onhand_);
      newrec_.catch_qty_onhand := NVL(inv_part_in_stock_rec_.catch_qty_onhand, catch_qty_onhand_);
   END IF;
   
   newrec_.qty_counted       := qty_counted_;
   newrec_.catch_qty_counted := catch_qty_counted_;
   newrec_.count_user_id     := NVL(count_user_id_, Fnd_Session_API.Get_Fnd_User);

   IF (cost_detail_id_ IS NULL) THEN
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Default_Details(contract_,
                                                                           part_no_,
                                                                           configuration_id_,
                                                                           lot_batch_no_,
                                                                           serial_no_,
                                                                           condition_code_,
                                                                           'COUNTING');
      IF (cost_detail_tab_.COUNT = 0) THEN
         cost_detail_tab_(1).accounting_year := '*';
         cost_detail_tab_(1).contract        := contract_;
         cost_detail_tab_(1).cost_bucket_id  := '*';
         cost_detail_tab_(1).company         := Site_API.Get_Company(contract_);
         cost_detail_tab_(1).cost_source_id  := '*';
         cost_detail_tab_(1).unit_cost       := 0;
      END IF;

      Temporary_Part_Cost_Detail_API.Add_Details(local_cost_detail_id_,
                                                 cost_detail_tab_,
                                                 part_no_);
   ELSE
      IF (Temporary_Part_Cost_Detail_API.Cost_Detail_Id_Exist(cost_detail_id_)) THEN
         local_cost_detail_id_ := cost_detail_id_;
      END IF;
   END IF;

   newrec_.cost_detail_id := local_cost_detail_id_;
   newrec_.condition_code := condition_code_;
   newrec_.note_text := note_text_;
   newrec_.part_tracking_session_id := part_tracking_session_id_;
   New___(newrec_);

   state_ := newrec_.rowstate;
END New_Result;


-- Check_Rejected_Part
--   Checks if the part_no and the contract exists in LU CountingResult
--   with state Rejected and inv_list_no = '*'.
@UncheckedAccess
FUNCTION Check_Rejected_Part (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR check_part IS
      SELECT 1
      FROM   counting_result_tab
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   configuration_id = configuration_id_
      AND   inv_list_no = '*'
      AND   rowstate = 'Rejected';
BEGIN
   OPEN check_part;
   FETCH check_part INTO dummy_;
   IF check_part%FOUND THEN
      CLOSE check_part;
      RETURN 'TRUE';
   END IF;
   CLOSE check_part;
   RETURN 'FALSE';
END Check_Rejected_Part;


-- Check_Rejected_Report
--   Checks if a count report exists in LU CountingResult with state Rejected.
@UncheckedAccess
FUNCTION Check_Rejected_Report (
   inv_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_     NUMBER;
   CURSOR check_report IS
      SELECT 1
      FROM   counting_result_tab
      WHERE inv_list_no = inv_list_no_
      AND   rowstate = 'Rejected';
BEGIN
   OPEN check_report;
   FETCH check_report INTO dummy_;
   IF check_report%FOUND THEN
      CLOSE check_report;
      RETURN 'TRUE';
   END IF;
   CLOSE check_report;
   RETURN 'FALSE';
END Check_Rejected_Report;


-- Check_Approval_Needed
--   Checks if the difference between quantity counted and quantity onhand exceeds
--   the Max Counting Difference Amount or the Max Counting Difference Percentage
--   (on Site level). Returns TRUE if the limits are exceeded and FALSE if they
--   are not exceeded. Called from Counting Report Line.
@UncheckedAccess
FUNCTION Check_Approval_Needed (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   qty_counted_       IN NUMBER,
   qty_onhand_        IN NUMBER,
   part_ownership_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   qty_difference_        NUMBER;
   inventory_value_       NUMBER;
   quantity_onhand_       NUMBER;
   count_diff_amount_     NUMBER;
   count_diff_percentage_ NUMBER;
BEGIN
   qty_difference_  := qty_counted_ - qty_onhand_;
   quantity_onhand_ := qty_onhand_;

   IF (qty_difference_ != 0) THEN
      count_diff_amount_     := Site_Invent_Info_API.Get_Count_Diff_Amount(contract_);
      count_diff_percentage_ := Site_Invent_Info_API.Get_Count_Diff_Percentage(contract_);
      IF part_ownership_db_ IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_CONSIGNMENT) THEN
         inventory_value_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                        part_no_,
                                                                                        configuration_id_,
                                                                                        NULL,
                                                                                        NULL);
      ELSE
         inventory_value_ := 0;
      END IF;
      
      IF (Check_Approval_Needed___(qty_difference_,
                                   count_diff_amount_,
                                   inventory_value_,
                                   count_diff_percentage_,
                                   quantity_onhand_)) THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   RETURN 'FALSE';
END Check_Approval_Needed;


@UncheckedAccess
FUNCTION Check_Approval_Needed (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_counted_      IN NUMBER,
   qty_onhand_       IN NUMBER ) RETURN VARCHAR2
IS
   part_ownership_db_ VARCHAR2(20);
BEGIN
   part_ownership_db_ := Inventory_Part_In_Stock_API.Get_Part_Ownership_Db(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   RETURN Check_Approval_Needed(contract_, part_no_, configuration_id_, qty_counted_, qty_onhand_, part_ownership_db_);
END Check_Approval_Needed;


-- Check_Rejected_Part_Location
--   Checks if the part_no on a specific location exists in LU CountingResult
--   with state Rejected.
@UncheckedAccess
FUNCTION Check_Rejected_Part_Location (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR check_part_loc IS
      SELECT 1
      FROM   counting_result_tab
      WHERE  contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    location_no      = location_no_
      AND    lot_batch_no     = lot_batch_no_
      AND    serial_no        = serial_no_
      AND    eng_chg_level    = eng_chg_level_
      AND    waiv_dev_rej_no  = waiv_dev_rej_no_
      AND    activity_seq     = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    rowstate         = 'Rejected';
BEGIN
   OPEN check_part_loc;
   FETCH check_part_loc INTO dummy_;
   IF check_part_loc%FOUND THEN
      CLOSE check_part_loc;
      RETURN 'TRUE';
   END IF;
   CLOSE check_part_loc;
   RETURN 'FALSE';
END Check_Rejected_Part_Location;


-- Cost_Detail_Id_Is_On_Rejected
--   This method tells you if a specific cost detail ID is connected to
--   a rejected counting result.
@UncheckedAccess
FUNCTION Cost_Detail_Id_Is_On_Rejected (
   cost_detail_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_                         NUMBER;
   cost_detail_id_is_on_rejected_ BOOLEAN := FALSE;

   CURSOR check_rejected IS
      SELECT 1
        FROM counting_result_tab
       WHERE cost_detail_id = cost_detail_id_
         AND rowstate       = 'Rejected';
BEGIN
   OPEN  check_rejected;
   FETCH check_rejected INTO dummy_;
   IF check_rejected%FOUND THEN
      cost_detail_id_is_on_rejected_ := TRUE;
   END IF;
   CLOSE check_rejected;

   RETURN (cost_detail_id_is_on_rejected_);
END Cost_Detail_Id_Is_On_Rejected;


-- Cancel_Part
--   This procedure is used to cancel all rejected records on an inventory part.
PROCEDURE Cancel_Part (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Complete_Or_Cancel_Part___ (contract_, part_no_, configuration_id_, 'Cancel');
END Cancel_Part;


-- Complete_Part
--   This procedure is used to complete all rejected records on an inventory part.
PROCEDURE Complete_Part (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Complete_Or_Cancel_Part___ (contract_, part_no_, configuration_id_, 'Complete');
END Complete_Part;


-- Cancel_Report
--   This procedure is used to cancel all rejected records on a count report.
PROCEDURE Cancel_Report (
   inv_list_no_ IN VARCHAR2 )
IS
BEGIN
   Complete_Or_Cancel_Report___ (inv_list_no_, 'Cancel');
END Cancel_Report;


-- Complete_Report
--   This procedure is used to complete all rejected records on a count report.
PROCEDURE Complete_Report (
   inv_list_no_ IN VARCHAR2 )
IS
BEGIN
   Complete_Or_Cancel_Report___ (inv_list_no_, 'Complete');
END Complete_Report;


@UncheckedAccess
FUNCTION Get_Last_Completed_Count_Date (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN DATE
IS
   last_date_completed_ DATE;

   CURSOR get_last_date_completed IS
      SELECT TRUNC(MAX(date_completed))
      FROM counting_result_tab
      WHERE part_no          = part_no_
      AND   contract         = contract_
      AND   configuration_id = configuration_id_
      AND   location_no      = location_no_
      AND   lot_batch_no     = lot_batch_no_
      AND   serial_no        = serial_no_
      AND   eng_chg_level    = eng_chg_level_
      AND   waiv_dev_rej_no  = waiv_dev_rej_no_
      AND   activity_seq     = activity_seq_
      AND   handling_unit_id = handling_unit_id_
      AND   rowstate         = 'Completed';
BEGIN
   OPEN get_last_date_completed;
   FETCH get_last_date_completed INTO last_date_completed_;
   CLOSE get_last_date_completed;
   RETURN last_date_completed_;
END Get_Last_Completed_Count_Date;


@UncheckedAccess
FUNCTION Counting_Report_Exist (
   inv_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_                 NUMBER;
   counting_report_exist_ VARCHAR2(5) := 'FALSE';

   CURSOR exist_control IS
      SELECT 1
        FROM counting_result_tab
       WHERE inv_list_no = inv_list_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      counting_report_exist_ := 'TRUE';
   END IF;
   CLOSE exist_control;

   RETURN (counting_report_exist_);
END Counting_Report_Exist;


@UncheckedAccess
FUNCTION Part_Track_Id_Is_On_Rejected (
   part_tracking_session_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_                        NUMBER;
   part_track_id_is_on_rejected_ BOOLEAN := FALSE;

   CURSOR check_rejected IS
      SELECT 1
        FROM counting_result_tab
       WHERE part_tracking_session_id = part_tracking_session_id_
         AND rowstate                 = 'Rejected';
BEGIN
   OPEN  check_rejected;
   FETCH check_rejected INTO dummy_;
   IF check_rejected%FOUND THEN
      part_track_id_is_on_rejected_ := TRUE;
   END IF;
   CLOSE check_rejected;

   RETURN (part_track_id_is_on_rejected_);
END Part_Track_Id_Is_On_Rejected;


@UncheckedAccess
FUNCTION Get_Total_Difference_Qty(
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2) RETURN NUMBER
IS
   total_difference_ NUMBER;
   CURSOR get_total_difference IS
      SELECT SUM(qty_counted-qty_onhand)
      FROM   counting_result_tab
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   configuration_id = configuration_id_
      AND   inv_list_no = '*'
      AND   rowstate = 'Rejected';
BEGIN
   OPEN get_total_difference;
   FETCH get_total_difference INTO total_difference_;
   CLOSE get_total_difference;
   RETURN total_difference_;              
END Get_Total_Difference_Qty;


@UncheckedAccess
FUNCTION Get_Row_Identity (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   count_date_       IN DATE ) RETURN VARCHAR2
IS
   rowid_ VARCHAR2(2000);

   CURSOR get_row_id IS
         SELECT rowid
         FROM  counting_result_tab
         WHERE contract = contract_
         AND   part_no = part_no_
         AND   configuration_id = configuration_id_
         AND   location_no = location_no_
         AND   lot_batch_no = lot_batch_no_
         AND   serial_no = serial_no_
         AND   eng_chg_level = eng_chg_level_
         AND   waiv_dev_rej_no = waiv_dev_rej_no_
         AND   activity_seq = activity_seq_
         AND   handling_unit_id = handling_unit_id_
         AND   count_date = count_date_;
BEGIN

   OPEN get_row_id;
   FETCH get_row_id INTO rowid_;
   CLOSE get_row_id;
   RETURN rowid_;
                            
END Get_Row_Identity;


-- Used from Aurena client (doing the same thing that was done in colnQtyCounted_OnPM_DataItemValidate and tblCountingResultPart_OnSAM_FetchRowDone)
FUNCTION Get_Diff_Amount (
   contract_        VARCHAR2,
   qty_counted_     NUMBER,
   qty_onhand_      NUMBER,
   inventory_value_ NUMBER ) RETURN NUMBER
IS
   diff_amount_   NUMBER;
   curr_decimals_ NUMBER;
BEGIN
   curr_decimals_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), 
                                                             Currency_Code_API.Get_Currency_Code(Site_API.Get_Company(contract_)));

   diff_amount_ := TRUNC(((qty_counted_ - qty_onhand_) * inventory_value_), curr_decimals_);
   -- TODO: Not sure if we need to have similar handling of "overflow" like the IEE client had here. Have not added that yet.

   RETURN diff_amount_;
END Get_Diff_Amount;


-- Used from Aurena client (doing the same thing that was done in colnQtyCounted_OnPM_DataItemValidate and tblCountingResultPart_OnSAM_FetchRowDone)
FUNCTION Get_Diff_Percentage (
   qty_counted_     NUMBER,
   qty_onhand_      NUMBER ) RETURN NUMBER
IS
   diff_percentage_   NUMBER;
BEGIN
   IF (qty_onhand_ = 0) THEN
      diff_percentage_ := (qty_counted_ - qty_onhand_) * 100;
   ELSE
      diff_percentage_ := TRUNC((((qty_counted_ - qty_onhand_) / qty_onhand_) * 100), 2);
   END IF;
   -- TODO: Not sure if we need to have similar handling of "overflow" like the IEE client had here. Have not added that yet. 

   RETURN diff_percentage_;
END Get_Diff_Percentage;

