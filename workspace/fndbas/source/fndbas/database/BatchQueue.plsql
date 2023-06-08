-----------------------------------------------------------------------------
--
--  Logical unit: BatchQueue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971203  ERFO  Created for Foundation1 release 2.1.0 (ToDo #1712).
--  980319  ERFO  Added new public attribute ExecutionPlan and
--                added two new server default values (ToDo #2264).
--  980330  ERFO  Changed size of ExecutionPlan from 50 to 200 (ToDo #2297).
--  980904  ERFO  Solved language independency for default queue (Bug #2671).
--  981110  ERFO  Changed view to ensure translated description and protected
--                description of default queue from being updated (Bug #2671).
--  981214  ERFO  Added new attribute LangCode and added warnings when
--                batch queus are created or modified (ToDo #3017).
--  990601  ERFO  Remove possibility to deactive the default queue or
--                change the language setting (Bug #3402).
--  990603  ERFO  Changes in method Update___ and Delete___ to solve stop and
--                start of deactivated or removed batch queues (Bug #3406).
--  990614  RaKu  Changed to Yoshimura-templates (ToDo #3413).
--  990705  ERFO  Applied usage of Language_SYS.Exist (ToDo #3430).
--  000821  ROOD  Added initiation of batch queue in Insert___ (Bug #17003).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050615  HAAR  Changed Delete___ to use System privileges (F1PR483).
--  140321  USRA  Replaced Add_Warning with Add_Info (TEBASE-62).
-----------------------------------------------------------------------------
--
-- Note: Due to the use of DDL statements there might be partial commits in transactions.
--       Be extra carefull when rolling back.
--
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PROCESS_NUMBER', 1, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_PLAN', 'sysdate + 30/86400', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT batch_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --
   -- Generate a sequence according to existing objects
   --
   LOCK TABLE BATCH_QUEUE_TAB IN EXCLUSIVE MODE;
   SELECT nvl(max(queue_id) + 1, 1)
      INTO newrec_.queue_id
      FROM BATCH_QUEUE;
   Client_SYS.Add_To_Attr('QUEUE_ID', newrec_.queue_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
   --
   -- Initiate the queue according to setting in ACTIVE parameter.
   --
   IF newrec_.active = 'TRUE' THEN
      Transaction_SYS.Init_Processing__(newrec_.queue_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     batch_queue_tab%ROWTYPE,
   newrec_ IN OUT batch_queue_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.queue_id = 0 AND indrec_.description THEN
      Error_SYS.Item_Update(lu_name_, 'DESCRIPTION');
   END IF;   
   IF NVL(newrec_.active, 'FALSE') <> 'TRUE' AND indrec_.active THEN
      Client_SYS.Add_Info(lu_name_, 'DEFWERR1: The queue ":P1" was deactivated. This may lead to unprocessed jobs.',newrec_.description);
   END IF;
   
   IF NVL(newrec_.lang_code, '%') <> '%' AND indrec_.lang_code THEN
      Client_SYS.Add_Info(lu_name_, 'DEFWERR2: A language was specified to the queue ":P1". This may lead to unprocessed jobs in the queue.',newrec_.description);
   END IF;
   IF (nvl(oldrec_.node_attached, 'FALSE') <> nvl(newrec_.node_attached, 'FALSE')) OR (nvl(oldrec_.node, '-1') <> nvl(newrec_.node, '-1'))THEN
      Client_SYS.Add_Info(lu_name_, 'INITREQD: The parameter change on Batch Queue [ :P1 - :P2 ] will not take effect until the Batch Queue is initialized.', newrec_.queue_id, newrec_.description);
   END IF;
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     batch_queue_tab%ROWTYPE,
   newrec_ IN OUT batch_queue_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.lang_code IS NOT NULL AND newrec_.lang_code <> '%') THEN
      BEGIN
         Language_SYS.Exist(newrec_.lang_code);
      EXCEPTION
         WHEN OTHERS THEN
            Client_SYS.Add_Info(lu_name_, 'NOLANG: The language ":P1" is not installed in the translation database and may not work correctly with batch queue ":P2 - :P3".', newrec_.lang_code, newrec_.queue_id, newrec_.description);
      END;
   END IF;
   Validate_Node_Connection___(newrec_);
END Check_Common___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     batch_queue_tab%ROWTYPE,
   newrec_     IN OUT batch_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --
   -- Start or stop queue processes when active flag is changed
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (nvl(oldrec_.active, 'FALSE') <> nvl(newrec_.active, 'FALSE')) THEN
      Transaction_SYS.Init_Processing__(oldrec_.queue_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN batch_queue_tab%ROWTYPE )
IS
BEGIN
   IF (remrec_.queue_id = 0) THEN
      Error_SYS.Appl_General(lu_name_, 'REM: The default queue can not be removed!');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN batch_queue_tab%ROWTYPE )
IS
   index_    NUMBER;
   CURSOR get_queue_met IS
      SELECT method_id
      FROM   batch_queue_method_tab
      WHERE  queue_id = remrec_.queue_id;
BEGIN
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   -- Update the jobs to the default queue
   --
   SELECT nvl(max(method_id), 0)
      INTO index_
      FROM batch_queue_method_tab
      WHERE queue_id = 0;
   FOR rec IN get_queue_met LOOP
      UPDATE batch_queue_method_tab
         SET queue_id = 0,
             method_id = index_ + 1
         WHERE queue_id = remrec_.queue_id
         AND   method_id = rec.method_id;
      index_ := index_ + 1;
   END LOOP;
   --
   -- Standard
   --
   super(objid_, remrec_);
   -- Remove the database process/es run by the queue
   Transaction_SYS.Stop_Processing__(remrec_.queue_id);
END Delete___;

PROCEDURE Validate_Node_Connection___ (
   newrec_     IN OUT batch_queue_tab%ROWTYPE )
IS
   dummy_ NUMBER;
   valid_ BOOLEAN;
   CURSOR check_rac_nodes IS
      SELECT 1
        FROM oracle_rac_instances
       WHERE inst_id = newrec_.node;
BEGIN
   IF newrec_.node_attached = 'TRUE' THEN
      -- 1. A node must be specified:
      IF newrec_.node IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NODENULL: A node was not specified while trying to attach the Batch Queue [ :P1 - :P2 ] to an Oracle RAC node.', newrec_.queue_id, newrec_.description);
      END IF;
      -- 2. The selected node must be available:
      OPEN  check_rac_nodes;
      FETCH check_rac_nodes INTO dummy_;
      valid_ := check_rac_nodes%FOUND;
      CLOSE check_rac_nodes;
      IF NOT valid_ THEN
         Error_SYS.Record_General(lu_name_, 'NODENOAVAIL: Failed to attach the Batch Queue [ :P1 - :P2 ] to Oracle RAC Instance [ :P3 ].', newrec_.queue_id, newrec_.description, newrec_.node);
      END IF;
   END IF;
END Validate_Node_Connection___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- ----------------------------------------------------------------------------
-- Do_New__
--    Same as calling the private New__ method with ACTION set to: 'DO'.
-- ----------------------------------------------------------------------------
PROCEDURE Do_New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2 )
IS
   newrec_   batch_queue_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Do_New__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Queue_Name RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000);
BEGIN
   temp_ := Language_SYS.Translate_Constant(lu_name_, 'DEFQUEUENAME: Default Queue');
   RETURN(temp_);
END Get_Default_Queue_Name;
