-----------------------------------------------------------------------------
--
--  Logical unit: RebateFinalAggLog
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170307  AmPalk   STRMF-6615, Modified Get_Last_Run_Date to compare agreement_id.
--  131113  RoJalk   Hooks implementation - refactor files.
--  130215  ShKolk   Added MAX function to select of Get_Last_Run_Date().
--  100526  NaLrlk   Changed the method call Ord_Process_Status_API to Rebate_Process_Status_API that it used.
--  080602  JeLise   Added code to methods Get_Last_Run_Date, Insert___, Remove, Modify and New.
--  080409  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REBATE_FINAL_AGG_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_process_id IS
      SELECT nvl(max(process_id), 0) + 1
      FROM REBATE_FINAL_AGG_LOG_TAB;
BEGIN
   OPEN get_process_id;
   FETCH get_process_id INTO newrec_.process_id;
   CLOSE get_process_id;
   Client_SYS.Add_To_Attr('PROCESS_ID', newrec_.process_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove (
   process_id_ IN NUMBER )
IS
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, process_id_);
   Remove__(info_, objid_, objversion_, 'DO');
END Remove;


PROCEDURE Modify (
   attr_       IN OUT VARCHAR2,
   process_id_ IN     NUMBER )
IS
   newrec_     REBATE_FINAL_AGG_LOG_TAB%ROWTYPE;
   oldrec_     REBATE_FINAL_AGG_LOG_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(process_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify;


PROCEDURE New (
   attr_       IN OUT VARCHAR2,
   process_id_ IN OUT NUMBER )
IS
   newrec_     REBATE_FINAL_AGG_LOG_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   process_id_ := newrec_.process_id;
END New;


@UncheckedAccess
FUNCTION Get_Last_Run_Date (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   agreement_id_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ REBATE_FINAL_AGG_LOG_TAB.last_run_date%TYPE;
   CURSOR get_attr IS
      SELECT MAX(last_run_date)
      FROM REBATE_FINAL_AGG_LOG_TAB
      WHERE company = company_
      AND   customer_no = customer_no_
      AND   agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Last_Run_Date;



