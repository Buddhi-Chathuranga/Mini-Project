-----------------------------------------------------------------------------
--
--  Logical unit: FndOraAdvancedQueue
--  Component:    FNDBAS
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

FUNCTION Get_Queue_Table___ (queue_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   table_name_ VARCHAR2(30);
BEGIN
   SELECT queue_table
   INTO table_name_
   FROM user_queues
   WHERE name = UPPER(queue_name_);
   RETURN table_name_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Error_SYS.Too_Many_Rows(lu_name_,NULL,'Get_Queue_Table___');
END Get_Queue_Table___;
   
PROCEDURE Register_Callback___(queue_name_     IN VARCHAR2,
                               consumer_name_  IN VARCHAR2,
                               callback_       IN VARCHAR2,
                               owner_          IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
                               namespace_      IN NUMBER   DEFAULT DBMS_AQ.NAMESPACE_AQ)
IS
   reg_info_list_ SYS.AQ$_REG_INFO_LIST;
   reg_info_      SYS.AQ$_REG_INFO;
   f_consumer_name_ VARCHAR2(150) := owner_||'.'||queue_name_||':'||consumer_name_;
BEGIN
   reg_info_ := SYS.AQ$_REG_INFO(f_consumer_name_, namespace_, callback_, HEXTORAW('FF'));
   reg_info_list_ := SYS.AQ$_REG_INFO_LIST(reg_info_);
   Dbms_Aq.Register(reg_info_list_, 1);
END Register_Callback___;

PROCEDURE Unregister_Callback___(queue_name_     IN VARCHAR2,
                                 consumer_name_  IN VARCHAR2,
                                 callback_       IN VARCHAR2,
                                 q_owner_        IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
                                 namespace_      IN NUMBER   DEFAULT DBMS_AQ.NAMESPACE_AQ)
IS
   reg_info_list_ SYS.AQ$_REG_INFO_LIST;
   reg_info_      SYS.AQ$_REG_INFO;
   f_consumer_name_ VARCHAR2(150) := q_owner_||'.'||queue_name_||':'||consumer_name_;
BEGIN
   reg_info_ := SYS.AQ$_REG_INFO(f_consumer_name_, namespace_, callback_, HEXTORAW('FF'));
   reg_info_list_ := SYS.AQ$_REG_INFO_LIST(reg_info_);
   Dbms_Aq.Unregister(reg_info_list_, 1);
END Unregister_Callback___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Start_Queue(
   queue_name_ IN VARCHAR2,
   owner_      IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner )
IS
BEGIN
   Dbms_Aqadm.Start_Queue(owner_ || '.' || queue_name_);
END Start_Queue;

PROCEDURE Stop_Queue(
   queue_name_ IN VARCHAR2,
   owner_      IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner)
IS
BEGIN
   Dbms_Aqadm.Stop_Queue(owner_ || '.' || queue_name_);
END Stop_Queue;

PROCEDURE Add_Subscriber(
   queue_name_    IN VARCHAR2,
   consumer_name_ IN VARCHAR2,
   q_owner_       IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   address_       IN VARCHAR2 DEFAULT NULL,
   protocol_      IN VARCHAR2 DEFAULT NULL )
IS
   agent_ sys.aq$_agent := sys.aq$_agent(consumer_name_, address_, protocol_);
   f_queue_name_  VARCHAR2(100) := q_owner_||'.'||queue_name_;
BEGIN
   Dbms_Aqadm.Add_Subscriber(f_queue_name_, agent_);
END Add_Subscriber;

PROCEDURE Remove_Subscriber(
   queue_name_    IN VARCHAR2,
   consumer_name_ IN VARCHAR2,
   q_owner_       IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   address_       IN VARCHAR2 DEFAULT NULL,
   protocol_      IN VARCHAR2 DEFAULT NULL )
IS
   agent_ sys.aq$_agent := sys.aq$_agent(consumer_name_, address_, protocol_);
BEGIN
   Dbms_Aqadm.Remove_Subscriber(q_owner_||'.'||queue_name_, agent_);
END Remove_Subscriber;

PROCEDURE Remove_All_Subscribers(
   queue_name_    IN VARCHAR2,
   q_owner_       IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner )
IS
   CURSOR get_subscribers IS
      SELECT queue_name,consumer_name
      FROM user_queue_subscribers
      WHERE queue_name = queue_name_;

   TYPE subs_tab IS TABLE OF Get_Subscribers%ROWTYPE;
   subscribers_ subs_tab;
BEGIN
   OPEN get_subscribers;
   FETCH get_subscribers BULK COLLECT INTO subscribers_;
   CLOSE get_subscribers;

   FOR i_ IN 1..subscribers_.COUNT LOOP
      Remove_Subscriber(subscribers_(i_).queue_name, subscribers_(i_).consumer_name);
   END LOOP;
END Remove_All_Subscribers;

PROCEDURE Register_PLSQL_Callback(
   queue_name_      IN VARCHAR2,
   consumer_name_   IN VARCHAR2,
   callback_method_ IN VARCHAR2,
   q_owner_         IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   method_owner_    IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   namespace_       IN NUMBER   DEFAULT DBMS_AQ.NAMESPACE_AQ,
   protocol_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Register_Callback___(queue_name_, consumer_name_, 'plsql://'||method_owner_||'.'||callback_method_, q_owner_, namespace_);
END Register_PLSQL_Callback;

PROCEDURE Unregister_PLSQL_Callback(
   queue_name_      IN VARCHAR2,
   consumer_name_   IN VARCHAR2,
   callback_method_ IN VARCHAR2,
   q_owner_         IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   method_owner_    IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   namespace_       IN NUMBER   DEFAULT DBMS_AQ.NAMESPACE_AQ,
   protocol_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Unregister_Callback___(queue_name_, consumer_name_, 'plsql://'||method_owner_||'.'||callback_method_, q_owner_, namespace_);
END Unregister_PLSQL_Callback;

PROCEDURE Purge_Queue_Table(
   queue_name_ IN VARCHAR2,
   q_owner_    IN VARCHAR2 DEFAULT Fnd_Session_API.Get_App_Owner,
   options_    IN VARCHAR2 DEFAULT NULL,
   lock_       IN BOOLEAN  DEFAULT FALSE,
   delivery_mode_ IN PLS_INTEGER DEFAULT dbms_aqadm.PERSISTENT) 
IS
   purge_opt_ dbms_aqadm.aq$_purge_options_t;
   queue_table_ VARCHAR2(100) := q_owner_||'.'||Get_Queue_Table___(queue_name_);
BEGIN
   purge_opt_.block := lock_;
   purge_opt_.delivery_mode  := delivery_mode_;
   Dbms_Aqadm.Purge_Queue_Table(queue_table_, options_, purge_opt_);
END Purge_Queue_Table;

@UncheckedAccess
FUNCTION Get_Queued_Msg_Count(
   queue_name_ IN VARCHAR2) RETURN NUMBER
IS
   queue_tab_ VARCHAR2(30) := Get_Queue_Table___(queue_name_);
   msgs_ NUMBER;
BEGIN
   IF queue_tab_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'NOQUEUETAB: ":P1" is not a valid queue', queue_name_); 
   END IF;
   @ApproveDynamicStatement(2014-10-06,mabose)
   EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||queue_tab_ INTO msgs_;
   RETURN msgs_;
END Get_Queued_Msg_Count;
