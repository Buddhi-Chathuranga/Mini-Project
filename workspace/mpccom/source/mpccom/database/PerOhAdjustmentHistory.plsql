-----------------------------------------------------------------------------
--
--  Logical unit: PerOhAdjustmentHistory
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200916  Dinklk  MF2020R1-7197, Added posting_group_id to Oh_Adjustment_Rec and fetched posting_group_id inside Get_Adjustments_To_Execute__.
--  200914  Dinklk  MF2020R1-7147: Overridden Check_Common___ to make sure either cost source id or posting cost group id have a value.
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  100429  Ajpelk  Merge rose method documentation
--  091006  ChFolk  Removed un used global constants and variables.
--  -------------------------------- 14.0.0 ---------------------------------
--  060321  JoAnSe  Corrected Init_Method call for Set_Executed
--  060309  JoAnSe  New interface for Set_Executed and Set_Error
--  051101  JoAnSe  adjustment_id returned in record by Get_Adjustments_To_Execute__
--  051021  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Oh_Adjustment_Rec IS RECORD (
   adjustment_id              NUMBER,
   company                    VARCHAR2(20),
   accounting_year            NUMBER,
   oh_type                    VARCHAR2(50),
   cost_source_id             VARCHAR2(20),
   posting_group_id           VARCHAR2(20),
   adjustment_percentage      NUMBER,
   dating_of_postings         VARCHAR2(50));

TYPE Oh_Adjustment_Tab IS TABLE OF Oh_Adjustment_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Adjustment_Id___
--   Retrive the next adjustment id to use for the specified company
FUNCTION Get_Next_Adjustment_Id___ (
   company_ IN VARCHAR2 ) RETURN NUMBER
IS
   ret_val_ NUMBER;

   CURSOR get_next_id IS
      SELECT MAX(adjustment_id) + 1
      FROM PER_OH_ADJUSTMENT_HISTORY_TAB
      WHERE company = company_;
BEGIN
   OPEN get_next_id;
   FETCH get_next_id INTO ret_val_;
   CLOSE get_next_id;
   RETURN NVL(ret_val_, 1);
END Get_Next_Adjustment_Id___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PER_OH_ADJUSTMENT_HISTORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.adjustment_id := Get_Next_Adjustment_Id___(newrec_.company);
   newrec_.date_created := SYSDATE;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT per_oh_adjustment_history_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     per_oh_adjustment_history_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY per_oh_adjustment_history_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.cost_source_id IS NOT NULL AND newrec_.posting_group_id IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'COSTPOSTINGNOTNULL: Either Cost Source ID or Posting Group ID can have a value.');
   ELSIF newrec_.cost_source_id IS NULL AND newrec_.posting_group_id IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'COSTPOSTINGNULL: Either Cost Source ID or Posting Group ID should have a value.');
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Adjustments_To_Execute__
--   Returns a table of Oh_Adjustment_Rec records with adjustments to execute
--   within the specified adjustment_run_id
FUNCTION Get_Adjustments_To_Execute__ (
   adjustment_run_id_ IN NUMBER ) RETURN Oh_Adjustment_Tab
IS
   oh_adjustment_tab_ Oh_Adjustment_Tab;

   CURSOR get_adjustments IS
      SELECT adjustment_id,
             company,
             accounting_year,
             oh_type,
             cost_source_id,
             posting_group_id,
             adjustment_percentage,
             dating_of_postings
      FROM PER_OH_ADJUSTMENT_HISTORY_TAB
      WHERE adjustment_run_id = adjustment_run_id_;
BEGIN
   OPEN get_adjustments;
   FETCH get_adjustments BULK COLLECT INTO oh_adjustment_tab_;
   CLOSE get_adjustments;

   RETURN oh_adjustment_tab_;   
END Get_Adjustments_To_Execute__;


@Override
PROCEDURE Set_Error__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ PER_OH_ADJUSTMENT_HISTORY_TAB%ROWTYPE;
   newrec_ PER_OH_ADJUSTMENT_HISTORY_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
       oldrec_ := Lock_By_Id___(objid_, objversion_); 
       newrec_ := oldrec_;
       -- Pass on the error description
       newrec_.error_description := Client_SYS.Get_Item_Value('ERROR_DESCRIPTION', attr_);
       Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Set_Error__;


-- Get_Next_Run_Id__
--   Return the next adjustment run id.
--   This id is used to identify adjustments executed at the same time.
@UncheckedAccess
FUNCTION Get_Next_Run_Id__ RETURN NUMBER
IS
   run_id_     NUMBER;

   CURSOR get_next_run_id IS
      SELECT Per_Oh_Adjustment_Run_Id.nextval
      FROM dual;
BEGIN
   OPEN get_next_run_id;
   FETCH get_next_run_id INTO run_id_;
   CLOSE get_next_run_id;
   RETURN(run_id_);
END Get_Next_Run_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Executed
--   Sets the state to 'Executed'
PROCEDURE Set_Executed (
   company_       IN VARCHAR2,
   adjustment_id_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   attr_ VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, adjustment_id_);
   Set_Executed__(info_, objid_, objversion_, attr_, 'DO');
END Set_Executed;


-- Set_Error
--   Sets the state to 'Error'. Also sets the error description.
PROCEDURE Set_Error (
   company_           IN VARCHAR2,
   adjustment_id_     IN NUMBER,
   error_description_ IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   error_attr_ VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, adjustment_id_);

   Client_SYS.Add_To_Attr('ERROR_DESCRIPTION', error_description_, error_attr_);
   Set_Error__(info_, objid_, objversion_, error_attr_, 'DO');
END Set_Error;


