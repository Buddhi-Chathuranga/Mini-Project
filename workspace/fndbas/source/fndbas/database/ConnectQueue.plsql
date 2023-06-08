-----------------------------------------------------------------------------
--
--  Logical unit: ConnectQueue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2019-11-14  japase  PACZDATA-1813: Added handling of system and disabled queues
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Queues IS TABLE OF connect_queue_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

DEFAULT_QUEUE        CONSTANT VARCHAR2(20) := 'DEFAULT';
ERROR_QUEUE          CONSTANT VARCHAR2(20) := 'ERROR';
NOTIFICATIONS_QUEUE  CONSTANT VARCHAR2(20) := 'NOTIFICATIONS';
TRASHCAN_QUEUE       CONSTANT VARCHAR2(20) := 'TRASHCAN';
UNROUTED_QUEUE       CONSTANT VARCHAR2(20) := 'UNROUTED';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_System_Queue___ (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN name_ IN (DEFAULT_QUEUE, ERROR_QUEUE, NOTIFICATIONS_QUEUE, TRASHCAN_QUEUE, UNROUTED_QUEUE);
END Is_System_Queue___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT connect_queue_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.static_config := CASE Is_System_Queue___(newrec_.instance_name) WHEN TRUE THEN '1' ELSE '0' END;
   newrec_.enabled := CASE newrec_.instance_name IN (ERROR_QUEUE, TRASHCAN_QUEUE) WHEN TRUE THEN 'FALSE' ELSE 'TRUE' END;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN connect_queue_tab%ROWTYPE )
IS
BEGIN
   IF Is_System_Queue___(remrec_.instance_name) THEN
      Error_SYS.Appl_General(lu_name_, 'REMOVE_SYSTEM: System queue [:P1] cannot be removed', remrec_.instance_name);
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Queue_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_queue_tab%ROWTYPE,
   newrec_     IN OUT connect_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Queue_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_queue_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Queue_(remrec_.instance_name);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Setup_Attributes__(
   attr_ OUT VARCHAR2,
   instance_name_ IN VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_, instance_name_);
   Client_SYS.Add_To_Attr('INSTANCE_NAME', instance_name_, attr_);

END Setup_Attributes__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE To_Runtime_Params_ (
   params_ IN OUT Connect_Runtime_Params_Type,
   queues_ IN     Connect_Queues) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'MessageQueues'                                        group_name,
            instance_name,                                         -- primary key
            decode(enabled,'TRUE','MessageQueue','DisabledQueue')  instance_type,
            execution_mode,                                        -- parameters
            stop_queue,
            log_level,
            to_char(priority)                                      priority, -- convert to VARCHAR2
            to_char(thread_count)                                  thread_count
         FROM
            TABLE(queues_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            execution_mode,
            stop_queue,
            log_level,
            priority,
            thread_count
         )
      )
   );
END To_Runtime_Params_;

PROCEDURE Set_Default_Values___ (
   attr_          OUT VARCHAR2,
   instance_name_ IN VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('DESCRIPTION', 'Description of ' || instance_name_, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_MODE_DB', 'InParallel', attr_);
   Client_SYS.Add_To_Attr('LOG_LEVEL_DB', 'ERROR', attr_);
   Client_SYS.Add_To_Attr('STOP_QUEUE', 'FALSE', attr_);
END Set_Default_Values___;

