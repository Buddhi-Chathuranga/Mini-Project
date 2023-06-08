-----------------------------------------------------------------------------
--
--  Logical unit: ExtCurrencyTask
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_currency_task_tab%ROWTYPE,
   newrec_ IN OUT ext_currency_task_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   CURSOR get_currency_tasks IS
   SELECT company, currency_type
      FROM ext_currency_task_detail_tab d
     WHERE d.task_id = newrec_.task_id;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF indrec_.workflow AND 
      oldrec_.workflow = Fnd_Boolean_API.DB_TRUE AND newrec_.workflow = Fnd_Boolean_API.DB_FALSE THEN
      FOR rec_ IN get_currency_tasks LOOP
         Currency_Type_API.Exist(rec_.company, rec_.currency_type);
      END LOOP;
   END IF;
END Check_Update___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Check_Allowed(
   task_id_    IN VARCHAR2)
IS
BEGIN
   Exist(task_id_);
   IF task_id_ IS NOT NULL THEN
      IF (Ext_Currency_Task_API.Get_Workflow_Db(task_id_) = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_, 'WFTASKNOTALLOWED: Task ID :P1 is only valid for Workflow.', task_id_);
      END IF; 
   END IF;
END Check_Allowed;

@IgnoreUnitTest DMLOperation
PROCEDURE Update_Last_Updated(
   task_id_    IN VARCHAR2)
IS
BEGIN
   UPDATE ext_currency_task_tab
   SET last_updated = sysdate
   WHERE task_id    = task_id_;
END Update_Last_Updated;

FUNCTION Company_Row_Exist(
   task_id_    IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR row_exist IS
   SELECT 1
   FROM ext_currency_task_detail_tab
   WHERE task_id = task_id_;
   ndummy_  NUMBER;
BEGIN
   OPEN row_exist;
   FETCH row_exist INTO ndummy_;
   IF row_exist%FOUND THEN
      CLOSE row_exist;
      RETURN 'TRUE';
   ELSE
      CLOSE row_exist;
      RETURN 'FALSE';
   END IF;
END Company_Row_Exist;