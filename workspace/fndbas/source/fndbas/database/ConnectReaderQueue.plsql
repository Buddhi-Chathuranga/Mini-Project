-----------------------------------------------------------------------------
--
--  Logical unit: ConnectReaderQueue
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

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_reader_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.seq_no := Connect_Reader_Queue_Seq.Nextval;
   newrec_.created := systimestamp;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_reader_queue_tab%ROWTYPE,
   newrec_     IN OUT connect_reader_queue_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.modified := systimestamp;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

--
-- New message ID
--
PROCEDURE New_Message__ (
   reader_       IN VARCHAR2,
   message_id_   IN VARCHAR2,
   message_name_ IN VARCHAR2,
   body_         IN BLOB)
IS
   rec_ connect_reader_queue_tab%ROWTYPE;
BEGIN
   rec_.reader_name := reader_;
   rec_.message_id := message_id_;
   rec_.message_name := message_name_;
   rec_.message_body := body_;
   rec_.state := Connect_Reader_Msg_State_API.DB_LISTED;
   New___(rec_);
END New_Message__;

--
-- Update retry state
--
PROCEDURE Update_State__ (
   seq_no_     IN INTEGER)
IS
BEGIN
   UPDATE connect_reader_queue_tab
   SET state = decode(state,'READ_RETRIED','READ_RETRY','DELETE_RETRIED','DELETE_RETRY'),
       rowversion = rowversion + 1
   WHERE seq_no = seq_no_
   AND state in ('READ_RETRIED','DELETE_RETRIED');
   IF SQL%ROWCOUNT <> 1 THEN
      Error_SYS.Appl_General(lu_name_, 'STATEUPDAET_ERR: Error while updating state for [:P1] (updated rows: [:P2])', seq_no_, SQL%ROWCOUNT);
   END IF;
END Update_State__;


--
-- Delete message ID
--
PROCEDURE Delete_Message__ (
   reader_     IN VARCHAR2,
   message_id_ IN VARCHAR2)
IS
   rec_ connect_reader_queue_tab%ROWTYPE;
BEGIN
   rec_.reader_name := reader_;
   rec_.message_id := message_id_;
   Delete___(rec_);
END Delete_Message__;


--
-- Generate MISSING_READER_QUEUE_MESSAGE event
--
PROCEDURE Raise_Reader_Proc_Err_Event__ (
   message_        IN VARCHAR2,
   reader_         IN VARCHAR2,
   message_id_     IN VARCHAR2,
   disable_reader_ IN VARCHAR2)
IS
   msg_      VARCHAR2(32000);
   fnd_user_ VARCHAR2(30);
BEGIN
   IF (Event_SYS.Event_Enabled(lu_name_, 'READER_PROCESSING_ERROR')) THEN
       msg_ := Message_SYS.Construct('READER_PROCESSING_ERROR');
       ---
       --- Standard event parameters
       ---
       fnd_user_ := Fnd_Session_API.Get_Fnd_User;
       Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate);
       Message_SYS.Add_attribute(msg_, 'USER_IDENTITY',  fnd_user_);
       Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION',  Fnd_User_API.Get_Description(fnd_user_));
       Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
       Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
       ---
       --- Event specific parameters
       ---
       Message_SYS.Add_Attribute(msg_, 'MESSAGE', message_);
       Message_SYS.Add_Attribute(msg_, 'READER', reader_);
       Message_SYS.Add_Attribute(msg_, 'MESSAGE_ID', message_id_);
       Message_SYS.Add_Attribute(msg_, 'DISABLE_READER', disable_reader_);
       --
       -- Generate event
       --
       Event_SYS.Event_Execute(lu_name_, 'READER_PROCESSING_ERROR', msg_);
    END IF;
END Raise_Reader_Proc_Err_Event__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Disable Connect Reader, if not already disabled
--
PROCEDURE Disable_Reader (
   reader_ IN VARCHAR2)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   enabled_    VARCHAR2(100);
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
BEGIN
   Dbms_Output.Put_Line('Disabling Connect Reader [' || reader_ || ']');
   SELECT objid, objversion, upper(enabled)
     INTO objid_, objversion_, enabled_
     FROM connect_reader
    WHERE instance_name  = reader_;
   IF enabled_ = 'TRUE' THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ENABLED', 'FALSE', attr_);
      Connect_Reader_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Dbms_Output.Put_Line('Reader [' || reader_ || '] already disabled');
   END IF;
END Disable_Reader;
