-----------------------------------------------------------------------------
--
--  Logical unit: OrdDetailStatLog
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210125  MaEelk SC2020R1-12290, Modified Create_Log__ and replaced the methods calls Prepare_Insert___, Pack___, Check_Insert___, Insert___ with New___
--  091110  MaMalk Replaced method Set_Trans_Date__ with Set_Trans_Execution_Date__. Modified methods Set_Trans_Execution_Date__
--  091110         and Create_Log__ to add the last_trans_date to the attr when it is not null.
--  091106  MaMalk Made necessary changes to add column company, drop columns log_no, status and
--  091106         make column company and issue_id as the key.        
--  ----------------- 14.0.0 ------------------------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040220  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ---------------Edge Package Group 3 Unicode Changes---------------------
--  990415  JakH  Y. Use of tables instead of views, removed function calls in selects.
--  990407  JakH  New template.
--  990315  JakH  Call 11779 Get_Last_Status method added to be able to se if a
--                log is already executing.
--  990304  JakH  Call 11290 Use of client values removed. Execution-date is
--                taken from sysdat since we dont have any real nice way of getting a
--                site-date....
--  990302  JakH  Modified the LU specific private methods to conform to the
--                F1 class model using the primitive class methods for insert
--                and update. Log_ids are created in the insert___ method and
--                since they are the unique keys for the records the checks for
--                correct Issue-id's are removed from the where statements.
--  990301  JakH  Added column execution_date.
--  990208  JoEd  Run through Design.
--  98xxxx  xxxx  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Log__ (
   issue_id_db_ IN     VARCHAR2,   
   company_     IN     VARCHAR2,
   log_date_    IN     DATE )
IS
   newrec_      ORD_DETAIL_STAT_LOG_TAB%ROWTYPE;
BEGIN
   newrec_.issue_id := issue_id_db_;
   newrec_.company := company_;
   newrec_.execution_date := TRUNC(SYSDATE);
   newrec_.last_trans_date := log_date_;   
   New___(newrec_);
END Create_Log__;


PROCEDURE Set_Trans_Execution_Date__ (
   issue_id_db_    IN VARCHAR2,
   company_        IN VARCHAR2,
   trans_date_     IN DATE,
   execution_date_ IN DATE )
IS
   attr_        VARCHAR2(2000);
   oldrec_      ORD_DETAIL_STAT_LOG_TAB%ROWTYPE;
   newrec_      ORD_DETAIL_STAT_LOG_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN

   oldrec_ := lock_by_keys___(issue_id_db_, company_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   IF (trans_date_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LAST_TRANS_DATE' , trans_date_, attr_);
   END IF;   
   Client_SYS.Add_To_Attr('EXECUTION_DATE' , execution_date_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);     
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Trans_Execution_Date__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
FUNCTION Exist (
   issue_id_db_ IN     VARCHAR2,   
   company_     IN     VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(issue_id_db_, company_);
END;



