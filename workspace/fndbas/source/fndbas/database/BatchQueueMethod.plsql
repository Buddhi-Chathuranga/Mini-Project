-----------------------------------------------------------------------------
--
--  Logical unit: BatchQueueMethod
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971203  ERFO  Created for Foundation1 release 2.1.0 (ToDo #1712).
--  971204  ERFO  Added Get_Default_Queue and Update_Queue_Connection___.
--  971205  ERFO  Changes in Insert___ for method name conventions.
--  990601  ERFO  Added parameter lang_code_ in Get_Default_Queue and
--                changed logic in Get_Default_Queue (Bug #3402).
--  990614  RaKu  Changed to Yoshimura-templates (ToDo #3413).
--  990615  Raku  Added warning in Unpack_Check_Insert___ (ToDo #3413).
--  990616  RaKu  Modifyed warning in Unpack_Check_Insert___ (ToDo #3413).
--  000808  ROOD  Changes in Get_Default_Queue (Bug#16739).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  130821  PGAN  Added Remove_Method__(Bug #111810).
--  140309  USRA  Changed the logic at [Get_Default_Queue] (Bug#115040/TEBASE-82).
--  140524  ASWI  Changed Update___ to eliminate duplicate BatchQueueMethod (Bug#113984 Merge).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT BATCH_QUEUE_METHOD_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
   active_ VARCHAR2(200);
BEGIN
   super(newrec_, indrec_, attr_);

   SELECT active INTO active_
      FROM  batch_queue_tab
      WHERE queue_id = newrec_.queue_id;
   IF (active_ = 'FALSE') OR (active_ IS NULL) THEN
      Client_SYS.Add_Warning(lu_name_, 'QUEUE_DISABLED: The Batch Queue :P1 is not active.', newrec_.queue_id);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_QUEUE_METHOD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --
   -- Remove any existing method name
   --
   DELETE FROM batch_queue_method_tab
      WHERE upper(method_name) = upper(newrec_.method_name);
   --
   -- Generate a sequence according to existing objects
   --
   SELECT nvl(max(method_id) + 1, 1)
      INTO newrec_.method_id
      FROM BATCH_QUEUE_METHOD_TAB
      WHERE queue_id = newrec_.queue_id;
   newrec_.method_name := replace(initcap(replace(newrec_.method_name, '_', ' ')), ' ', '_');
   newrec_.method_name := replace(newrec_.method_name, 'Api', 'API');
   Client_SYS.Add_To_Attr('METHOD_ID', newrec_.method_id, attr_);
   Client_SYS.Add_To_Attr('METHOD_NAME', newrec_.method_name, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     batch_queue_method_tab%ROWTYPE,
   newrec_     IN OUT batch_queue_method_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --
   -- Remove any existing method name to prevent multiple copies of the same method.
   --
   IF by_keys_ THEN
      DELETE FROM batch_queue_method_tab
         WHERE upper(method_name) = upper(newrec_.method_name)
           AND NOT (queue_id = newrec_.queue_id AND method_id = newrec_.method_id);
   ELSE
      DELETE FROM batch_queue_method_tab
         WHERE upper(method_name) = upper(newrec_.method_name)
           AND rowid <> objid_;
   END IF;
  
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Update_Queue_Connection___ (
   queue_id_    IN NUMBER,
   method_name_ IN VARCHAR2 )
IS
   newrec_ BATCH_QUEUE_METHOD_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
   attr_   VARCHAR2(2000);
   objid_  VARCHAR2(2000);
   objv_   VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('QUEUE_ID', queue_id_, attr_);
   Client_SYS.Add_To_Attr('METHOD_NAME', method_name_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objv_, newrec_, attr_);
END Update_Queue_Connection___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_Method__(
   method_name_ VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   queue_id_   NUMBER;
   method_id_  NUMBER;
   remrec_     BATCH_QUEUE_METHOD_TAB%ROWTYPE;
   
   CURSOR get_attr IS
   SELECT queue_id,method_id
     FROM BATCH_QUEUE_METHOD_TAB
    WHERE UPPER(method_name) = UPPER(method_name_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO queue_id_,method_id_;
   
   IF get_attr%FOUND THEN
      Get_Id_Version_By_Keys___(objid_, objversion_,queue_id_, method_id_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   CLOSE get_attr;
END Remove_Method__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Default_Queue (
   method_name_ IN VARCHAR2,
   lang_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   default_queue_  NUMBER;

   CURSOR get_met_queue IS
      SELECT queue_id
        FROM batch_queue_method_tab
       WHERE upper(method_name) = upper(method_name_);

   CURSOR get_queue_state IS
      SELECT lang_code, active, description
        FROM batch_queue
       WHERE queue_id = default_queue_;

   queue_state_rec_ get_queue_state%ROWTYPE;
BEGIN
   OPEN  get_met_queue;
   FETCH get_met_queue INTO default_queue_;
   CLOSE get_met_queue;

   IF ( default_queue_ IS NULL ) THEN
      -- No method connection exist, create a new one.
      default_queue_ := 0;
      Update_Queue_Connection___(default_queue_, method_name_);
   END IF;

   OPEN  get_queue_state;
   FETCH get_queue_state INTO queue_state_rec_;
   CLOSE get_queue_state;

   IF NOT ( queue_state_rec_.active = 'TRUE' ) THEN
      Client_SYS.Add_Info(lu_name_, 'NOACTIVEQ: The Batch Queue Method [:P1] is registered with an inactive Batch Queue (:P2 - :P3).', method_name_, default_queue_, queue_state_rec_.description);
   END IF;

   IF NOT ( (lang_code_ IS NULL) OR (lang_code_ = '%') OR (queue_state_rec_.lang_code = lang_code_) ) THEN
      Client_SYS.Add_Info(lu_name_, 'WRONGLANG: The default Batch Queue (:P1) for Batch Queue Method [:P2] will only run jobs in [:P3] language.', default_queue_ || ' - ' || queue_state_rec_.description, method_name_, queue_state_rec_.lang_code);
   END IF;

   RETURN default_queue_;
END Get_Default_Queue;
