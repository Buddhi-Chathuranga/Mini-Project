-----------------------------------------------------------------------------
--
--  Logical unit: InventTransactionReport
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210310  SBalLK   Bug 158424(SCZ-14030), Modified Print_Report() method to use user session language to while print the report.
--  180527  SBalLK   Bug 142184, Modified Prepare_Insert___() method to send contract connected company when creating new record.
--  151223  ApWilk   Bug 126430, Replaced the Order_No as source_ref1 in Create_Inv_Trans_Report___.
--  150728  ShKolk   Bug 123092, Modified Print_Report() to set COPIES option to support StreamServe reports.
--  150717  IsSalk   KES-1085, Renamed usages of order_no of the view Invent_Trans_Report_Available to source_ref1.
--  130913  PraWlk   Bug 112432, Called Validate___() from Create_Inv_Trans_Rep_Attr__() to validate the parameters when the schedule task is executed. 
--  130730  UdGnlk   TIBE-868, Removed global constant and moved to method.
--  121010  MaMalk   Bug 102071, Modified methods New___  and Create_Inv_Trans_Report___ to handle DB values for the parameters 
--  121010           print_cost_, group_per_warehouse_, group_per_user_ and group_per_order_ in schedule tasks.
--  111027  NISMLK   SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  111027  MaEelk   Added UAS filter to INVENT_TRANS_REPORT_AVAILABLE.
--  110916  Darklk   Bug 98988, Modified Create_Inv_Trans_Report__ to avoid creating another background job when it's invoked from a schedule job.
--  110912  Darklk   Bug 98808, Modified the procedure New___ to retrieve the newly inserted transaction_report_id by adding a OUT parameter,
--  110912           modified the procedure Create_Inv_Trans_Report___ to avoid get an incorrect value to the variable transaction_report_id_
--  110912           and removed the Get_Current_Trans_Report_Id___.
--  110802  MaEelk   Replaced the obsolete method call Print_Server_SYS.Enumerate_Printer_Id with Logical_Printer_API.Enumerate_Printer_Id.
--  110225  ChJalk   Moved 'User Allowed Site' Default Where condition from client to base view.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  080711  SuSalk   Bug 75268, Modified transaction_report_id prompt to Inv Trans Report ID in base view and
--  080711           INVENT_TRANS_REPORT_AVAILABLE view.
--  080303  NiBalk   Bug 72023, Modified Check_If_Printed and Check_If_Cancelled, to have a single return.
--  071031  RoJalk   Bug 68811, Increased the length to 2000 of source in INVENT_TRANS_REPORT_AVAILABLE view. 
--  070529  ShVese   CID 144851- Added an outer join to inventory location in the view
--                   INVENT_TRANS_REPORT_AVAILABLE.
--  070416  RaKalk   Modified INVENT_TRANS_REPORT_AVAILABLE view to fetch transaction value from MpccomTransactionCode LU
--  070131  NaLrlk   Removed the CURSOR and Added REF CURSOR get_available_transactions in Create_Inv_Trans_Report___.
--  061030  MaJalk   Added attribute number_series. Modified methods Validate___, Update___,
--  061030           Check_Before_Insert___, Check_Before_Update___.   
--  061019  ISWILK   Added the GROUP_PER_WAREHOUSE to the view and parameter group_per_warehouse_
--  061019           to the relavant methods.
--  061019  ISWILK   Added the company_ as a parameter to the Create_Inv_Trans_Report___, New___
--  061019           removed the newrec_ and added the relavant parameters in Validate___
--  061019           and also removed the call to Site_API.Get_Company.
--  060915  ISWILK   Removed the PROCEDURE Inv_Trans_Report_Impl___ and moved the logic to
--  060915           PROCEDUREs Create_Inv_Trans_Rep_Attr__, Create_Inv_Trans_Report___.
--  060914  ISWILK   Added the FUNCTION Set_Date_For_Time___ to set the correct date for time fields
--  060914           and removed the REPLACE in PROCEDURE Connect_All_To_Report.
--  060908  ISWILK   Modified the view invent_trans_rep_grp_type to tab in Create_Inv_Trans_Report___.
--  060905  SARALK   Changed use of invent_trans_code_rep_type_tab, invent_trans_rep_grp_type_tab and
--  060905           inventory_transaction_hist_tab to corresponding views.
--  060905           Removed function Connected_Lines_Exist and replaced call with Inventory_Transaction_Hist_API.Connected_Lines_Exist.
--  060905           Modified procedures Validate_Params and Validate___ to use method call Inventory_Location_API.Check_Warehouse_Exist.
--  060905           Modified procedure Insert___ to TRUNC newrec_.from_trans_date_created and newrec_.to_trans_date_created.
--  060904  ISWILK   Added the GROUP_PER_USER to the view and added parameter group_per_user_ to the relavant methods.
--  060830  ISWILK   Modified the PROCEDURE Check_Before_Update___ by adding NVL to transactions_created_by.
--  060823  KeFelk   transactions_created_by is set to not mandatory and relavant modifications in the New__.
--  060814  ChJalk   Modified hard_coded dates to be able to use any calendar.
--  060810  ISWILK   Removed unused variables and modified the PROCEDURE New___.
--  060810  ISWILK   Modified the PROCEDURE Inv_Trans_Report_Impl___.
--  060804  KEFELK   Added update not allowed conditions to Unpack_Check_Update___.
--  060804  KEFELK   Added Warehouse to the INVENT_TRANS_REPORT_AVAILABLE and reflected it the relavant methods.
--  060804  ISWILK   Modified the PROCEDURE Check_Inv_Trans_Rep_Code_Exist, Check_Report_Type_Id_Is_Used.
--  060803  ISWILK   Added the PROCEDURE Check_Report_Type_Id_Is_Used to use in INVENT_TRANS_REP_GRP_TYPE_API.
--  060803  ISWILK   Modified the PROCEDURE PROCEDURE Print_Report to remove unnecessary code.
--  060802  ISWILK   Modified the PROCEDURE Unpack_Check_Insert___, Unpack_Check_Update___
--  060802           to set the correct time to from_trans_date_time_created, to_trans_date_time_created
--  060802           and set the report_type_id as update allowed.
--  060801  SARALK   Modified procedure Prepare_Insert___, Unpack_Check_Insert___,
--  060801           Unpack_Check_Update___, Validate___ and Validate_Params to handle date and time values.
--  060728  SARALK   Added function Connected_Lines_Exist.
--  060728  ISWILK   Made the contract as a public attribute.
--  060727  ISWILK   Removed the print_report_ parameter from PROCEDURE Print_Report.
--  060727           and modified the Inv_Trans_Report_Impl___.
--  060726  ISWILK   Added Get_Current_Trans_Report_Id___, Set_Print_Info and remove Cancel_Report.
--  060725  ISWILK   Added Inv_Trans_Report_Impl___, Validate___ & modified Create_Inv_Trans_Report___.
--  060724  ISWILK   Modified the get_available_trans in Connect_All_To_Report and
--  060724           get_transactions in Create_Inv_Trans_Report___.
--  060721  ISWILK   Renamed the Connect_All_Trans_Report to Connect_All_To_Report
--  060721           and Disconnect_All_Trans_Report to Disconnect_All_From_Report.
--  060720  ISWILK   Modified the company, report_type_id and report_group_id as
--  060720           private attributes and added the logic to the Print_Report,
--  060720           Cancel_Inv_Trans_Report, Disconnect_All_Trans_Report.
--  060718  ISWILK   Modified the PROCEDURE Validate_Params.
--  060718  SARALK   Added some columns to INVENT_TRANS_REPORT_AVAILABLE.
--  060718  ISWILK   Modified the where clause of INVENT_TRANS_REPORT_AVAILABLE
--  060718           and PROCEDUREs Create_Inv_Trans_Report__, New___, Validate_Params.
--  060717  ISWILK   Added the PROCEDURE New___ and added the logic to Create_Inv_Trans_Report___
--  060717           and modified the Create_Inv_Trans_Rep_Attr__.
--  060717  SARALK   Added functions Check_If_Printed and Check_If_Cancelled and procedure Cancel_Report.
--  060714  ISWILK   Modified Prepare_Insert___, Unpack_Check_Insert___ to set the values when
--  060714           & added the logic to Check_Inv_Trans_Rep_Code_Exist, Create_Inv_Trans_Report__
--  060714           Create_Inv_Trans_Report___, Create_Inv_Trans_Rep_Attr__.
--  060714  ISWILK   Added the view INVENT_TRANS_REPORT_AVAILABLE and PROCEDURE Validate_Params.
--  060714  SARALK   Set the sequence to transaction_report_id in PROCEDURE Insert___
--  060714           and added default values in PROCEDURE Perpare_Insert___.
--  060712  ISWILK   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Create_Inv_Trans_Report___
--   This is used to create the InventoryTransaction Report and fetch the
--   transaction with creating new record and report. Calling only from this LU.
PROCEDURE Create_Inv_Trans_Report___ (
   report_type_id_               IN VARCHAR2,
   report_group_id_              IN VARCHAR2,
   contract_                     IN VARCHAR2,
   company_                      IN VARCHAR2,
   warehouse_                    IN VARCHAR2,
   transactions_created_by_      IN VARCHAR2,
   from_trans_date_created_      IN DATE,
   to_trans_date_time_created_   IN DATE,
   from_trans_date_time_created_ IN DATE,
   to_trans_date_created_        IN DATE,
   print_cost_db_                IN VARCHAR2,
   group_per_warehouse_db_       IN VARCHAR2,
   group_per_user_db_            IN VARCHAR2,
   group_per_order_db_           IN VARCHAR2,
   print_report_                 IN VARCHAR2 )
IS
   transaction_report_id_        INVENT_TRANSACTION_REPORT_TAB.transaction_report_id%TYPE;
   prev_userid_                  INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE :=NULL;
   prev_order_no_                INVENT_TRANSACTION_REPORT_TAB.order_no%TYPE := NULL;
   prev_report_type_id_          INVENT_TRANSACTION_REPORT_TAB.report_type_id%TYPE := NULL;
   prev_warehouse_               INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE := NULL;
   curr_warehouse_               INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE;
   curr_userid_                  INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   curr_order_no_                INVENT_TRANSACTION_REPORT_TAB.order_no%TYPE;
   new_warehouse_                INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE;
   new_user_id_                  INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   new_order_no_                 INVENT_TRANSACTION_REPORT_TAB.order_no%TYPE;
   valid_from_date_time_created_ INVENT_TRANSACTION_REPORT_TAB.from_trans_date_time_created%TYPE;
   valid_to_date_time_created_   INVENT_TRANSACTION_REPORT_TAB.to_trans_date_time_created%TYPE;
   rec_transaction_id_           INVENT_TRANS_REPORT_AVAILABLE.transaction_id%TYPE;
   rec_report_type_id_           INVENT_TRANSACTION_REPORT_TAB.report_type_id%TYPE;
   rec_warehouse_                INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE;
   rec_userid_                   INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   rec_order_no_                 INVENT_TRANSACTION_REPORT_TAB.order_no%TYPE;
   last_calendar_date_           DATE    := Database_Sys.last_calendar_date_;
   first_calendar_date_          DATE    := Database_Sys.first_calendar_date_;

   stmt_                         VARCHAR2(32000);
   TYPE RecordType               IS REF CURSOR;
   get_available_transactions_   RecordType;

BEGIN

   valid_from_date_time_created_ := Set_Date_For_Time___(from_trans_date_created_, from_trans_date_time_created_);
   valid_to_date_time_created_   := Set_Date_For_Time___(to_trans_date_created_, to_trans_date_time_created_);

   stmt_ := 'SELECT transaction_id, report_type_id, warehouse, userid, source_ref1
             FROM   invent_trans_report_available
             WHERE  contract = :contract
             AND    (report_type_id = :report_type_id OR :report_type_id IS NULL)
             AND    (userid = :transactions_created_by OR :transactions_created_by IS NULL)
             AND    (warehouse = :warehouse OR :warehouse IS NULL)
             AND    date_created BETWEEN TRUNC(NVL(:from_trans_date_created, :first_calendar_date))
                    AND TRUNC(NVL(:to_trans_date_created, :last_calendar_date))
             AND    date_time_created BETWEEN NVL(:valid_from_date_time_created, :first_calendar_date)
                    AND NVL(:valid_to_date_time_created, :last_calendar_date)
             ORDER BY report_type_id ';
     
   IF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
      stmt_ := stmt_ || ', source_ref1';
   ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
      stmt_ := stmt_ || ', userid';
   ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'FALSE') THEN
      stmt_ := stmt_ || ', warehouse';
   ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
      stmt_ := stmt_ || ', userid, source_ref1';
   ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
      stmt_ := stmt_ || ', warehouse, source_ref1';
   ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
      stmt_ := stmt_ || ', warehouse, userid';
   ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
      stmt_ := stmt_ || ', warehouse, userid, source_ref1';
   END IF;
   -- Fetch the available transactions

   @ApproveDynamicStatement(2007-01-31,nalrlk)
   OPEN get_available_transactions_ FOR stmt_ USING contract_, report_type_id_, report_type_id_, transactions_created_by_,
                                                   transactions_created_by_, warehouse_, warehouse_, from_trans_date_created_,
                                                   first_calendar_date_, to_trans_date_created_, last_calendar_date_, valid_from_date_time_created_,
                                                   first_calendar_date_, valid_to_date_time_created_, last_calendar_date_;
   LOOP
      FETCH get_available_transactions_ INTO rec_transaction_id_, rec_report_type_id_, rec_warehouse_, rec_userid_, rec_order_no_;
      EXIT WHEN get_available_transactions_%NOTFOUND;
      IF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'FALSE') THEN
         curr_warehouse_ := CHR(32);
         curr_userid_    := CHR(32);
         curr_order_no_  := CHR(32);
      ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
         curr_warehouse_ := CHR(32);
         curr_userid_    := CHR(32);
         curr_order_no_  := (NVL(rec_order_no_, CHR(32)));
      ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
         curr_warehouse_ := CHR(32);
         curr_userid_    := (NVL(rec_userid_, CHR(32)));
         curr_order_no_  := CHR(32);
      ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'FALSE') THEN
         curr_warehouse_ := (NVL(rec_warehouse_, CHR(32)));
         curr_userid_    := CHR(32);
         curr_order_no_  := CHR(32);
      ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
         curr_warehouse_ := CHR(32);
         curr_userid_    := (NVL(rec_userid_, CHR(32)));
         curr_order_no_  := (NVL(rec_order_no_, CHR(32)));
      ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
         curr_warehouse_ := (NVL(rec_warehouse_, CHR(32)));
         curr_userid_    := CHR(32);
         curr_order_no_  := (NVL(rec_order_no_, CHR(32)));
      ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
         curr_warehouse_ := (NVL(rec_warehouse_, CHR(32)));
         curr_userid_    := (NVL(rec_userid_, CHR(32)));
         curr_order_no_  := CHR(32);
      ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
         curr_warehouse_ := (NVL(rec_warehouse_, CHR(32)));
         curr_userid_    := (NVL(rec_userid_, CHR(32)));
         curr_order_no_  := (NVL(rec_order_no_, CHR(32)));
      END IF;

      IF ((NVL(prev_report_type_id_, CHR(32)) != rec_report_type_id_)) OR
         (group_per_warehouse_db_ = 'TRUE' AND NVL(prev_warehouse_, CHR(32)) != (curr_warehouse_)) OR
         (group_per_user_db_ = 'TRUE' AND prev_userid_ != curr_userid_) OR
         (group_per_order_db_ = 'TRUE' AND NVL(prev_order_no_, CHR(32)) != curr_order_no_) THEN

         IF ((transaction_report_id_ IS NOT NULL) AND (print_report_ = 'Y')) THEN
            -- Print the Inventory Transaction Report.
            Print_Report(transaction_report_id_);
         END IF;

         new_warehouse_ := warehouse_;
         new_user_id_   := transactions_created_by_;

         IF (group_per_warehouse_db_ = 'TRUE') THEN
            new_warehouse_ := rec_warehouse_;
         END IF;

         IF (group_per_user_db_ = 'TRUE') THEN
            new_user_id_ := rec_userid_;
         END IF;

         IF (group_per_order_db_ = 'TRUE') THEN
            new_order_no_ := rec_order_no_;
         END IF;

         -- Create a Tranasction Report.
         New___(transaction_report_id_,
                rec_report_type_id_,
                report_group_id_,
                contract_,
                company_,
                new_warehouse_,
                new_user_id_,
                from_trans_date_created_,
                to_trans_date_time_created_,
                from_trans_date_time_created_,
                to_trans_date_created_,
                print_cost_db_,
                group_per_warehouse_db_,
                group_per_user_db_,
                group_per_order_db_,
                new_order_no_);

         prev_report_type_id_ := rec_report_type_id_;

         IF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'FALSE') THEN
            prev_warehouse_ := CHR(32);
            prev_userid_    := CHR(32);
            prev_order_no_  := CHR(32);
         ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
            prev_warehouse_ := CHR(32);
            prev_userid_    := CHR(32);
            prev_order_no_  := (NVL(rec_order_no_, CHR(32)));
         ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
            prev_warehouse_ := CHR(32);
            prev_userid_    := rec_userid_;
            prev_order_no_  := CHR(32);
         ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'FALSE') THEN
            prev_warehouse_ := rec_warehouse_;
            prev_userid_    := CHR(32);
            prev_order_no_  := CHR(32);
         ELSIF (group_per_warehouse_db_ = 'FALSE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
            prev_warehouse_ := CHR(32);
            prev_userid_    := rec_userid_;
            prev_order_no_  := (NVL(rec_order_no_, CHR(32)));
         ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'FALSE') AND (group_per_order_db_ = 'TRUE') THEN
            prev_warehouse_ := rec_warehouse_;
            prev_userid_    := CHR(32);
            prev_order_no_  := (NVL(rec_order_no_, CHR(32)));
         ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'FALSE') THEN
            prev_warehouse_ := rec_warehouse_;
            prev_userid_    := rec_userid_;
            prev_order_no_  := CHR(32);
         ELSIF (group_per_warehouse_db_ = 'TRUE') AND (group_per_user_db_ = 'TRUE') AND (group_per_order_db_ = 'TRUE') THEN
            prev_warehouse_ := rec_warehouse_;
            prev_userid_    := rec_userid_;
            prev_order_no_  := (NVL(rec_order_no_, CHR(32)));
         END IF;
      END IF;
      -- Connect available transactions to the Transaction Report.
      Inventory_Transaction_Hist_API.Set_Report_Id(rec_transaction_id_,
                                                   transaction_report_id_);

   END LOOP;
   CLOSE get_available_transactions_; 
     
   IF ((transaction_report_id_ IS NOT NULL) AND (print_report_ = 'Y')) THEN
      -- Print the Inventory Transaction Report.
      Print_Report(transaction_report_id_);
   END IF;
END Create_Inv_Trans_Report___;


-- New___
--   This will insert a new record to this LU. Calling only from this LU.
PROCEDURE New___ (
   transaction_report_id_        OUT VARCHAR2,
   report_type_id_               IN  VARCHAR2,
   report_group_id_              IN  VARCHAR2,
   contract_                     IN  VARCHAR2,
   company_                      IN  VARCHAR2,
   warehouse_                    IN  VARCHAR2,
   transactions_created_by_      IN  VARCHAR2,
   from_trans_date_created_      IN  DATE,
   to_trans_date_time_created_   IN  DATE,
   from_trans_date_time_created_ IN  DATE,
   to_trans_date_created_        IN  DATE,
   print_cost_                   IN  VARCHAR2,
   group_per_warehouse_          IN  VARCHAR2,
   group_per_user_               IN  VARCHAR2,
   group_per_order_              IN  VARCHAR2,
   order_no_                     IN  VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      INVENT_TRANSACTION_REPORT.objid%TYPE;
   objversion_ INVENT_TRANSACTION_REPORT.objversion%TYPE;
   newrec_     INVENT_TRANSACTION_REPORT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE', warehouse_, attr_);
   Client_SYS.Add_To_Attr('TRANSACTIONS_CREATED_BY', transactions_created_by_, attr_);
   Client_SYS.Add_To_Attr('FROM_TRANS_DATE_CREATED', from_trans_date_created_, attr_);
   Client_SYS.Add_To_Attr('FROM_TRANS_DATE_TIME_CREATED', from_trans_date_time_created_, attr_);
   Client_SYS.Add_To_Attr('TO_TRANS_DATE_CREATED', to_trans_date_created_, attr_);
   Client_SYS.Add_To_Attr('TO_TRANS_DATE_TIME_CREATED', to_trans_date_time_created_, attr_);

   Client_SYS.Add_To_Attr('REPORT_CREATED_BY', Fnd_Session_API.Get_Fnd_User, attr_);
   Client_SYS.Add_To_Attr('REPORT_DATE_CREATED', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Add_To_Attr('PRINT_COST_DB', print_cost_, attr_);
   Client_SYS.Add_To_Attr('AUTOMATICALLY_CREATED_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('GROUP_PER_WAREHOUSE_DB', group_per_warehouse_, attr_);
   Client_SYS.Add_To_Attr('GROUP_PER_USER_DB', group_per_user_, attr_);

   Client_SYS.Add_To_Attr('GROUP_PER_ORDER_DB', group_per_order_, attr_);
   IF (group_per_order_ = 'TRUE') THEN
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('REPORT_TYPE_ID', report_type_id_, attr_);
   Client_SYS.Add_To_Attr('REPORT_GROUP_ID', report_group_id_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );
   transaction_report_id_ := newrec_.transaction_report_id;
END New___;


-- Validate___
--   This is used to validate the manually entering data and used in
--   Unpack_Check_Insert and Unpack_Check_Update.
PROCEDURE Validate___ (
   company_                      IN VARCHAR2,
   contract_                     IN VARCHAR2,
   warehouse_                    IN VARCHAR2,
   report_group_id_              IN VARCHAR2,
   report_type_id_               IN VARCHAR2,
   transactions_created_by_      IN VARCHAR2,
   from_trans_date_created_      IN DATE,
   to_trans_date_created_        IN DATE,
   from_trans_date_time_created_ IN DATE,
   to_trans_date_time_created_   IN DATE )
IS
BEGIN

   IF (contract_ IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (warehouse_ IS NOT NULL) THEN
      IF (Inventory_Location_API.Check_Warehouse_Exist(contract_, warehouse_) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_,'ERRWAREHOUSE: Warehouse :P1 is not a valid warehouse.', warehouse_ );
      END IF;
   END IF;

   IF (report_type_id_ IS NOT NULL) THEN
      Invent_Trans_Report_Type_API.Exist(company_, report_type_id_);
   END IF;

   IF (report_group_id_ IS NOT NULL) THEN
      Invent_Trans_Report_Group_API.Exist(company_, report_group_id_);
   END IF;

   IF (transactions_created_by_ IS NOT NULL) THEN
      Fnd_User_API.Exist(transactions_created_by_);
   END IF;

   IF ((from_trans_date_created_ IS NOT NULL) AND (to_trans_date_created_ IS NOT NULL)
      AND ( TRUNC(from_trans_date_created_) > TRUNC(to_trans_date_created_ ))) THEN
      Error_SYS.Record_General(lu_name_,'COMPARE_DATE: From date may not be earlier than To date.');
   END IF;
   
   IF TRUNC(from_trans_date_created_) = TRUNC(to_trans_date_created_) THEN
      IF (TO_CHAR(from_trans_date_time_created_,'HH24:MI:SS') != '00:00:00') THEN
         IF (from_trans_date_time_created_ > to_trans_date_time_created_) THEN
            Error_SYS.Record_General(lu_name_,'COMPARE_DATE: From date may not be earlier than To date.');
         END IF;
      END IF;
   END IF;
END Validate___;


-- Check_Before_Insert___
--   This procedure will check the attributes beofore inserting a record.
PROCEDURE Check_Before_Insert___ (
   newrec_ IN OUT INVENT_TRANSACTION_REPORT_TAB%ROWTYPE )
IS
BEGIN

   IF (newrec_.report_group_id IS NOT NULL) THEN
      Invent_Trans_Report_Group_API.Exist(newrec_.company, newrec_.report_group_id);
   END IF;

   IF (newrec_.from_trans_date_time_created IS NOT NULL) THEN
      newrec_.from_trans_date_time_created := Set_Date_For_Time___(newrec_.from_trans_date_created, newrec_.from_trans_date_time_created);
   END IF;

   IF (newrec_.to_trans_date_time_created IS NOT NULL) THEN
      newrec_.to_trans_date_time_created := Set_Date_For_Time___(newrec_.to_trans_date_created, newrec_.to_trans_date_time_created);
   END IF;

   Validate___(newrec_.company,
               newrec_.contract,
               newrec_.warehouse,
               newrec_.report_group_id,
               newrec_.report_type_id,
               newrec_.transactions_created_by,
               newrec_.from_trans_date_created,
               newrec_.to_trans_date_created,
               newrec_.from_trans_date_time_created,
               newrec_.to_trans_date_time_created);

   IF (newrec_.automatically_created IS NULL) THEN
      newrec_.automatically_created := 'FALSE';
   END IF;

   IF (newrec_.group_per_order IS NULL) THEN
      newrec_.group_per_order := 'FALSE';
   END IF;

   IF (newrec_.print_cost IS NULL) THEN
      newrec_.print_cost := 'FALSE';
   END IF;

END Check_Before_Insert___;


-- Check_Before_Update___
--   This procedure will check the attributes beofore modifying a record.
PROCEDURE Check_Before_Update___ (
   newrec_ IN OUT INVENT_TRANSACTION_REPORT_TAB%ROWTYPE,
   oldrec_ IN     INVENT_TRANSACTION_REPORT_TAB%ROWTYPE )
IS 
   last_calendar_date_   DATE    := Database_Sys.last_calendar_date_;
BEGIN

   IF (newrec_.date_cancelled != Site_API.Get_Site_Date(newrec_.contract)) THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDATECANTRANREP: Changes are not allowed for cancelled transaction reports');
   END IF;

   IF (oldrec_.report_type_id != newrec_.report_type_id OR
       oldrec_.contract != newrec_.contract OR
       NVL(oldrec_.warehouse, CHR(32)) != NVL(newrec_.warehouse, CHR(32)) OR
       NVL(oldrec_.transactions_created_by, CHR(32)) != NVL(newrec_.transactions_created_by, CHR(32)) OR
       NVL(oldrec_.from_trans_date_created, last_calendar_date_) != NVL(newrec_.from_trans_date_created, last_calendar_date_) OR
       NVL(oldrec_.from_trans_date_time_created, last_calendar_date_) != NVL(newrec_.from_trans_date_time_created, last_calendar_date_) OR
       NVL(oldrec_.to_trans_date_created, last_calendar_date_) != NVL(newrec_.to_trans_date_created, last_calendar_date_) OR
       NVL(oldrec_.to_trans_date_time_created, last_calendar_date_) != NVL(newrec_.to_trans_date_time_created, last_calendar_date_) ) THEN

       IF (Inventory_Transaction_Hist_API.Connected_Lines_Exist(newrec_.transaction_report_id) = 1) THEN
          Error_SYS.Record_General(lu_name_, 'NOUPDATETRANREP: Selection criteria cannot be updated when connected transactions exist.');
       END IF;
   END IF;

   IF (newrec_.from_trans_date_time_created IS NOT NULL) THEN
      newrec_.from_trans_date_time_created := Set_Date_For_Time___(newrec_.from_trans_date_created, newrec_.from_trans_date_time_created);
   END IF;

   IF (newrec_.to_trans_date_time_created IS NOT NULL) THEN
      newrec_.to_trans_date_time_created := Set_Date_For_Time___(newrec_.to_trans_date_created, newrec_.to_trans_date_time_created);
   END IF;

   Validate___(newrec_.company,
               newrec_.contract,
               newrec_.warehouse,
               newrec_.report_group_id,
               newrec_.report_type_id,
               newrec_.transactions_created_by,
               newrec_.from_trans_date_created,
               newrec_.to_trans_date_created,
               newrec_.from_trans_date_time_created,
               newrec_.to_trans_date_time_created);
END Check_Before_Update___;


-- Set_Date_For_Time___
--   This Implementation Function is used to set correct date to the time fileds.
FUNCTION Set_Date_For_Time___ (
   trans_date_created_      IN DATE,
   trans_date_time_created_ IN DATE ) RETURN DATE
IS
   temp_time_created_   DATE;
BEGIN
   temp_time_created_ := TO_DATE(REPLACE(TO_CHAR(trans_date_time_created_,'YYYY-MM-DD HH24:MI:SS'),
                                         TO_CHAR(trans_date_time_created_, 'YYYY-MM-DD'),
                                         TO_CHAR(trans_date_created_,'YYYY-MM-DD')), 'YYYY-MM-DD HH24:MI:SS');
   RETURN temp_time_created_;
END Set_Date_For_Time___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_    INVENT_TRANSACTION_REPORT_TAB.company%TYPE;
   contract_   INVENT_TRANSACTION_REPORT_TAB.contract%TYPE;
   user_       INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   site_date_  DATE;
BEGIN
   super(attr_);
   contract_  := User_Default_API.Get_Contract;
   company_   := Site_API.Get_Company(contract_);
   site_date_ := Site_API.Get_Site_Date(contract_);
   user_      := Fnd_Session_API.Get_Fnd_User;
   
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('TRANSACTIONS_CREATED_BY', user_, attr_);
   Client_SYS.Add_To_Attr('PRINT_COST_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('FROM_TRANS_DATE_CREATED', site_date_, attr_);
   Client_SYS.Add_To_Attr('FROM_TRANS_DATE_TIME_CREATED', TO_DATE(REPLACE(TO_CHAR(site_date_,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(site_date_,'HH24:MI:SS'), '00:00:00'),'YYYY-MM-DD HH24:MI:SS'), attr_);
   Client_SYS.Add_To_Attr('TO_TRANS_DATE_CREATED', site_date_, attr_);
   Client_SYS.Add_To_Attr('TO_TRANS_DATE_TIME_CREATED', site_date_, attr_);
   Client_SYS.Add_To_Attr('REPORT_CREATED_BY', user_, attr_);
   Client_SYS.Add_To_Attr('REPORT_DATE_CREATED', site_date_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENT_TRANSACTION_REPORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   
   SELECT invent_trans_rep_series_id.nextval
   INTO   newrec_.transaction_report_id
   FROM   DUAL;

   Error_SYS.Check_Not_Null(lu_name_, 'TRANSACTION_REPORT_ID', newrec_.transaction_report_id);
   newrec_.from_trans_date_created := TRUNC(newrec_.from_trans_date_created);
   newrec_.to_trans_date_created   := TRUNC(newrec_.to_trans_date_created);
   newrec_.number_series := Invent_Trans_Rep_Series_API.Get_Valid_Next_Report_No__(newrec_.company,
                                                                                   newrec_.report_type_id,
                                                                                   newrec_.contract,
                                                                                   newrec_.warehouse);
   super(objid_, objversion_, newrec_, attr_);
      Client_SYS.Add_To_Attr('TRANSACTION_REPORT_ID', newrec_.transaction_report_id, attr_);
      Client_SYS.Add_To_Attr('NUMBER_SERIES', newrec_.number_series, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENT_TRANSACTION_REPORT_TAB%ROWTYPE,
   newrec_     IN OUT INVENT_TRANSACTION_REPORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
 
   IF (oldrec_.contract != newrec_.contract OR
       NVL(oldrec_.warehouse, CHR(32)) != NVL(newrec_.warehouse, CHR(32)) OR
       oldrec_.report_type_id != newrec_.report_type_id) THEN
       newrec_.number_series := Invent_Trans_Rep_Series_API.Get_Valid_Next_Report_No__(newrec_.company,
                                                                                   newrec_.report_type_id,
                                                                                   newrec_.contract,
                                                                                   newrec_.warehouse);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_transaction_report_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Check_Before_Insert___(newrec_);
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     invent_transaction_report_tab%ROWTYPE,
   newrec_ IN OUT invent_transaction_report_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Check_Before_Update___(newrec_, oldrec_);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Inv_Trans_Report__
--   This method will start to create the Inventory Transaction Report from
--   Calling the private method CreateInvTransReport.
PROCEDURE Create_Inv_Trans_Report__ (
   attr_ IN VARCHAR2 )
IS
   batch_desc_ VARCHAR2(100);
BEGIN

   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Create_Inv_Trans_Rep_Attr__(attr_);
   ELSE
      batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDINVTRANS: Create Inventory Transaction Report');
      Transaction_SYS.Deferred_Call('Invent_Transaction_Report_API.Create_Inv_Trans_Rep_Attr__', attr_, batch_desc_);
   END IF;
END Create_Inv_Trans_Report__;


-- Create_Inv_Trans_Rep_Attr__
--   This method unpack the attributes those are sending from the client.
PROCEDURE Create_Inv_Trans_Rep_Attr__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(2000);
   report_type_id_               INVENT_TRANSACTION_REPORT_TAB.report_type_id%TYPE;
   report_group_id_              INVENT_TRANSACTION_REPORT_TAB.report_group_id%TYPE;
   contract_                     INVENT_TRANSACTION_REPORT_TAB.contract%TYPE;
   warehouse_                    INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE;
   transactions_created_by_      INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   from_trans_date_created_      INVENT_TRANSACTION_REPORT_TAB.from_trans_date_created%TYPE;
   to_trans_date_time_created_   INVENT_TRANSACTION_REPORT_TAB.to_trans_date_time_created%TYPE;
   from_trans_date_time_created_ INVENT_TRANSACTION_REPORT_TAB.from_trans_date_time_created%TYPE;
   to_trans_date_created_        INVENT_TRANSACTION_REPORT_TAB.to_trans_date_created%TYPE;
   print_cost_                   INVENT_TRANSACTION_REPORT_TAB.print_cost%TYPE;
   group_per_warehouse_          INVENT_TRANSACTION_REPORT_TAB.group_per_warehouse%TYPE;
   group_per_user_               INVENT_TRANSACTION_REPORT_TAB.group_per_user%TYPE;
   group_per_order_              INVENT_TRANSACTION_REPORT_TAB.group_per_order%TYPE;
   print_report_                 VARCHAR2(3);
   company_                      INVENT_TRANSACTION_REPORT_TAB.company%TYPE;
   error_desc_                   VARCHAR2(2000);

   CURSOR get_report_types IS
      SELECT report_type_id
      FROM   invent_trans_rep_grp_type_tab
      WHERE  company = company_
      AND    report_group_id = report_group_id_;

BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'REPORT_TYPE_ID') THEN
         report_type_id_ := value_;
      ELSIF (name_ = 'REPORT_GROUP_ID') THEN
         report_group_id_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
       ELSIF (name_ = 'COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'WAREHOUSE') THEN
         warehouse_ := value_;
      ELSIF (name_ = 'TRANSACTIONS_CREATED_BY') THEN
         transactions_created_by_ := value_;
      ELSIF (name_ = 'FROM_TRANS_DATE_CREATED') THEN
         from_trans_date_created_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_TRANS_DATE_TIME_CREATED') THEN
         to_trans_date_time_created_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'FROM_TRANS_DATE_TIME_CREATED') THEN
         from_trans_date_time_created_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_TRANS_DATE_CREATED') THEN
         to_trans_date_created_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'PRINT_COST') THEN
         print_cost_ := value_;
      ELSIF (name_ = 'GROUP_PER_ORDER') THEN
         group_per_order_ := value_;
      ELSIF (name_ = 'GROUP_PER_USER') THEN
         group_per_user_ := value_;
      ELSIF (name_ = 'GROUP_PER_WAREHOUSE') THEN
         group_per_warehouse_ := value_;
      ELSIF (name_ = 'PRINT_REPORT') THEN
         print_report_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   BEGIN
      Validate___( company_, 
                   contract_, 
                   warehouse_, 
                   report_group_id_, 
                   report_type_id_, 
                   transactions_created_by_, 
                   from_trans_date_created_, 
                   to_trans_date_created_, 
                   from_trans_date_time_created_, 
                   to_trans_date_time_created_ );
   EXCEPTION
      WHEN OTHERS THEN
         error_desc_ := SUBSTR(sqlerrm, Instr(sqlerrm, ':', 1, 2)+2, 2000);
         Transaction_SYS.Set_Status_Info(error_desc_, 'WARNING');
   END;

   IF (report_group_id_ IS NOT NULL) THEN
      FOR type_rec_ IN get_report_types LOOP
         Create_Inv_Trans_Report___(type_rec_.report_type_id,
                                  report_group_id_,
                                  contract_,
                                  company_,
                                  warehouse_,
                                  transactions_created_by_,
                                  from_trans_date_created_,
                                  to_trans_date_time_created_,
                                  from_trans_date_time_created_,
                                  to_trans_date_created_,
                                  print_cost_,
                                  group_per_warehouse_,
                                  group_per_user_,
                                  group_per_order_,
                                  print_report_ );
      END LOOP;
   ELSE
      Create_Inv_Trans_Report___(report_type_id_,
                               NULL,
                               contract_,
                               company_,
                               warehouse_,
                               transactions_created_by_,
                               from_trans_date_created_,
                               to_trans_date_time_created_,
                               from_trans_date_time_created_,
                               to_trans_date_created_,
                               print_cost_,
                               group_per_warehouse_,
                               group_per_user_,
                               group_per_order_,
                               print_report_ );
   END IF;
END Create_Inv_Trans_Rep_Attr__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Print_Report
--   This method create the specific transaction_report_id and update
--   the printed_by and date_printed.
PROCEDURE Print_Report (
   transaction_report_id_ IN VARCHAR2 )
IS
   printed_by_      INVENT_TRANSACTION_REPORT_TAB.printed_by%TYPE;
   info_            VARCHAR2(2000);
   printer_id_      VARCHAR2(100);
   print_attr_      VARCHAR2(200);
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   print_job_id_    NUMBER;
   printer_id_list_ VARCHAR2(32000);

BEGIN

   printed_by_ := Fnd_Session_API.Get_Fnd_User;

   -- Generate a new print job id
   printer_id_ := Printer_Connection_API.Get_Default_Printer(printed_by_, 'INVENT_TRANSACTION_REPORT_REP');
   Client_SYS.Clear_Attr(print_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_attr_);
   Print_Job_API.New(print_job_id_, print_attr_);

   -- Create the report
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'INVENT_TRANSACTION_REPORT_REP', report_attr_);
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_REPORT_ID', transaction_report_id_, parameter_attr_);
   Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);
   Client_SYS.Clear_Attr(print_attr_);

   info_ := Language_SYS.Translate_Constant(lu_name_, 'COUNTREPORT: The Inventory Transaction Report(s) were created successfully.');

   Transaction_SYS.Set_Progress_Info(info_);

   -- Connect the created report to a print job id
   Client_SYS.Clear_Attr(print_attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY',   result_key_,   print_attr_);
   Client_SYS.Add_To_Attr('OPTIONS',      'COPIES(1)',   print_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE',    Fnd_Session_API.Get_Language, print_attr_);
   Print_Job_Contents_API.New_Instance(print_attr_);

   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;

   -- Update the printed_by and date_printed
   Set_Print_Inv_Trans_Report(transaction_report_id_);
END Print_Report;


-- Check_Inv_Trans_Rep_Code_Exist
--   This method check if the specific transaction_code report is printed
--   or not. It will give an error message when the report is not printed.
PROCEDURE Check_Inv_Trans_Rep_Code_Exist (
   transaction_code_ IN VARCHAR2,
   report_type_id_   IN VARCHAR2,
   company_          IN VARCHAR2 )
IS
   exist_ BOOLEAN;

   CURSOR get_report_id IS
      SELECT transaction_report_id
      FROM   INVENT_TRANSACTION_REPORT_TAB
      WHERE  report_type_id= report_type_id_
      AND    company = company_
      AND    printed_by IS NULL
      AND    cancelled_by IS NULL;

BEGIN
   FOR rec_ IN get_report_id LOOP
      exist_ := Inventory_Transaction_Hist_API.Check_Inv_Trans_Rep_Code_Exist(rec_.transaction_report_id,
                                                                       transaction_code_);
      IF NOT (exist_) THEN
         EXIT;
      END IF;
   END LOOP;

   IF (exist_) THEN
      Error_SYS.Record_General(lu_name_, 'TRACODEEXIST: Transaction code exist on a report that is not printed.');
   END IF;
END Check_Inv_Trans_Rep_Code_Exist;


-- Cancel_Inv_Trans_Report
--   This method disconnect and cancell the report for th given transcation_report_id.
PROCEDURE Cancel_Inv_Trans_Report (
   transaction_report_id_ IN VARCHAR2 )
IS
   newrec_          INVENT_TRANSACTION_REPORT_TAB%ROWTYPE;
   oldrec_          INVENT_TRANSACTION_REPORT_TAB%ROWTYPE;
   attr_            VARCHAR2(32000) := NULL;
   objid_           INVENT_TRANSACTION_REPORT.objid%TYPE;
   objversion_      INVENT_TRANSACTION_REPORT.objversion%TYPE;
   indrec_          Indicator_Rec;

BEGIN
   Disconnect_All_From_Report(transaction_report_id_);

   Client_SYS.Add_to_Attr('CANCELLED_BY', Fnd_Session_API.Get_Fnd_User, attr_);
   Client_SYS.Add_to_Attr('DATE_CANCELLED', Site_API.Get_Site_Date(Get_Contract(transaction_report_id_)), attr_);
   Get_Id_Version_By_Keys___ (objid_, objversion_ , transaction_report_id_);
   oldrec_ := Lock_By_Id___( objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_ );
END Cancel_Inv_Trans_Report;


-- Connect_All_To_Report
--   Connect the report_type_Id to the Inventory Transaction History for
--   the given transcation_report_id.
PROCEDURE Connect_All_To_Report (
   transaction_report_id_ IN VARCHAR2 )
IS
   
   last_calendar_date_    DATE    := Database_Sys.last_calendar_date_;
   first_calendar_date_   DATE    := Database_Sys.first_calendar_date_;
   
   CURSOR get_available_trans IS
      SELECT itra.transaction_id
      FROM   invent_trans_report_available itra, INVENT_TRANSACTION_REPORT_TAB itr
      WHERE  itr.transaction_report_id = transaction_report_id_
      AND    itra.contract = itr.contract
      AND    itra.report_type_id = itr.report_type_id
      AND    (itra.userid = itr.transactions_created_by OR itr.transactions_created_by IS NULL)
      AND    (itra.warehouse = itr.warehouse OR itr.warehouse IS NULL)
      AND    itra.date_created BETWEEN TRUNC(NVL(itr.from_trans_date_created, first_calendar_date_))
                                 AND   TRUNC(NVL(itr.to_trans_date_created, last_calendar_date_))
      AND    itra.date_time_created BETWEEN NVL(itr.from_trans_date_time_created, first_calendar_date_)
                                    AND NVL(itr.to_trans_date_time_created, last_calendar_date_);
BEGIN
   FOR rec_ IN get_available_trans LOOP
      Inventory_Transaction_Hist_API.Set_Report_Id(rec_.transaction_id, transaction_report_id_);
   END LOOP;
END Connect_All_To_Report;


-- Disconnect_All_From_Report
--   Disconnect the Repor for the given transaction_report_id.
PROCEDURE Disconnect_All_From_Report (
   transaction_report_id_ IN VARCHAR2 )
IS
   CURSOR get_connected_trans IS
      SELECT transaction_id
      FROM   inventory_transaction_hist_pub
      WHERE  transaction_report_id = transaction_report_id_;
BEGIN
   FOR rec_ IN get_connected_trans LOOP
      Inventory_Transaction_Hist_API.Reset_Report_Id(rec_.transaction_id);
   END LOOP;
END Disconnect_All_From_Report;


-- Validate_Params
--   This is used to Schedule Task to validate all the parameters
--   and calling from the client.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                        NUMBER;
   name_arr_                     Message_SYS.name_table;
   value_arr_                    Message_SYS.line_table;
   contract_                     INVENT_TRANSACTION_REPORT_TAB.contract%TYPE;
   warehouse_                    INVENT_TRANSACTION_REPORT_TAB.warehouse%TYPE;
   report_group_id_              INVENT_TRANSACTION_REPORT_TAB.report_group_id%TYPE;
   report_type_id_               INVENT_TRANSACTION_REPORT_TAB.report_type_id%TYPE;
   transactions_created_by_      INVENT_TRANSACTION_REPORT_TAB.transactions_created_by%TYPE;
   company_                      INVENT_TRANSACTION_REPORT_TAB.company%TYPE;
   from_trans_date_created_      INVENT_TRANSACTION_REPORT_TAB.from_trans_date_created%TYPE;
   to_trans_date_created_        INVENT_TRANSACTION_REPORT_TAB.to_trans_date_created%TYPE;
   from_trans_date_time_created_ INVENT_TRANSACTION_REPORT_TAB.from_trans_date_time_created%TYPE;
   to_trans_date_time_created_   INVENT_TRANSACTION_REPORT_TAB.to_trans_date_time_created%TYPE;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAREHOUSE') THEN
         warehouse_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'REPORT_GROUP_ID') THEN
         report_group_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'REPORT_TYPE_ID') THEN
         report_type_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TRANSACTIONS_CREATED_BY') THEN
         transactions_created_by_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'FROM_TRANS_DATE_CREATED') THEN
         from_trans_date_created_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'FROM_TRANS_DATE_TIME_CREATED') THEN
         from_trans_date_time_created_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
         from_trans_date_time_created_ := Set_Date_For_Time___(from_trans_date_created_, from_trans_date_time_created_);
      ELSIF (name_arr_(n_) = 'TO_TRANS_DATE_CREATED') THEN
         to_trans_date_created_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'TO_TRANS_DATE_TIME_CREATED') THEN
         to_trans_date_time_created_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
         to_trans_date_time_created_ := Set_Date_For_Time___(to_trans_date_created_, to_trans_date_time_created_);
      END IF;
   END LOOP;

   Validate___(company_,
               contract_,
               warehouse_,
               report_group_id_,
               report_type_id_,
               transactions_created_by_,
               from_trans_date_created_,
               to_trans_date_created_,
               from_trans_date_time_created_,
               to_trans_date_time_created_);
END Validate_Params;


-- Check_If_Printed
--   This function checks whether a given report is printed and returns
--   either TRUE or FALSE.
@UncheckedAccess
FUNCTION Check_If_Printed (
   transaction_report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   printed_by_    INVENT_TRANSACTION_REPORT_TAB.printed_by%TYPE;
   date_printed_  INVENT_TRANSACTION_REPORT_TAB.date_printed%TYPE;
   temp_          VARCHAR2(5) := 'FALSE';                

   CURSOR  get_printed_info IS
      SELECT printed_by, date_printed
      FROM   INVENT_TRANSACTION_REPORT_TAB
      WHERE  transaction_report_id = transaction_report_id_;
BEGIN
   OPEN get_printed_info;
   FETCH get_printed_info INTO printed_by_, date_printed_;
   IF (printed_by_ IS NOT NULL) AND (date_printed_ IS NOT NULL) THEN
      temp_ := 'TRUE';
   END IF;
   CLOSE get_printed_info;
   RETURN temp_;   
END Check_If_Printed;


-- Check_If_Cancelled
--   This function checks whether a given report is cancelled and returns
--   either TRUE or FALSE.
@UncheckedAccess
FUNCTION Check_If_Cancelled (
   transaction_report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cancelled_by_     INVENT_TRANSACTION_REPORT_TAB.cancelled_by%TYPE;
   date_cancelled_   INVENT_TRANSACTION_REPORT_TAB.date_cancelled%TYPE;
   temp_             VARCHAR2(5) := 'FALSE';                

   CURSOR get_cancelled_info IS
      SELECT cancelled_by, date_cancelled
      FROM   INVENT_TRANSACTION_REPORT_TAB
      WHERE  transaction_report_id = transaction_report_id_;
BEGIN
   OPEN get_cancelled_info;
   FETCH get_cancelled_info INTO cancelled_by_, date_cancelled_;
   IF (cancelled_by_ IS NOT NULL) AND (date_cancelled_ IS NOT NULL) THEN
      temp_ := 'TRUE';
   END IF;
   CLOSE get_cancelled_info;
   RETURN temp_;
END Check_If_Cancelled;


-- Set_Print_Inv_Trans_Report
--   Update the date_printed and printed_by.
PROCEDURE Set_Print_Inv_Trans_Report (
   transaction_report_id_ IN VARCHAR2 )
IS
   newrec_       INVENT_TRANSACTION_REPORT_TAB%ROWTYPE;
   oldrec_       INVENT_TRANSACTION_REPORT_TAB%ROWTYPE;
   attr_         VARCHAR2(32000) := NULL;
   objid_        INVENT_TRANSACTION_REPORT.objid%TYPE;
   objversion_   INVENT_TRANSACTION_REPORT.objversion%TYPE;
   indrec_       Indicator_Rec;

BEGIN

   Client_SYS.Add_to_Attr('PRINTED_BY', Fnd_Session_API.Get_Fnd_User, attr_);
   Client_SYS.Add_to_Attr('DATE_PRINTED', Site_API.Get_Site_Date(Get_Contract(transaction_report_id_)), attr_);
   Get_Id_Version_By_Keys___ (objid_, objversion_ , transaction_report_id_);
   oldrec_ := Lock_By_Id___( objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_ );
END Set_Print_Inv_Trans_Report;


-- Check_Report_Type_Id_Is_Used
--   This procedure check if the report type is exist in the Printed
--   Inventory Transaction report. If not printed warning shoudl be displayed.
PROCEDURE Check_Report_Type_Id_Is_Used (
   company_         IN VARCHAR2,
   report_type_id_  IN VARCHAR2,
   report_group_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER := 0;

   CURSOR check_report_group IS
      SELECT 1
      FROM   INVENT_TRANSACTION_REPORT_TAB
      WHERE  company = company_
      AND    report_type_id = report_type_id_
      AND    report_group_id = report_group_id_
      AND    printed_by IS NULL
      AND    cancelled_by IS NULL;
BEGIN
   OPEN check_report_group;
   FETCH check_report_group INTO dummy_;
   CLOSE check_report_group;
   IF (dummy_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'REPORTTYPEEXIST: Report Type Id :P1, is used by Inventory Transaction report(s) that are not printed.', report_type_id_);
   END IF;
END Check_Report_Type_Id_Is_Used;



