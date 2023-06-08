-----------------------------------------------------------------------------
--
--  Logical unit: MessageArchiveUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051212  JHMASE  Created
--  070130  KIPELK  Add column MESSAGE_TEXT to FNDCN_MSG_ARCHIVE_BODY_TAB
--  110516  JHMASE  EASTONE-20126: Added DROP TRIGGER before CREATE TRIGGE
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Archive_Address_Label___ (
   application_message_id_   IN VARCHAR2 )
IS
   CURSOR addresses IS
      SELECT *
      FROM   fndcn_address_label_tab
      WHERE  application_message_id  = application_message_id_;
BEGIN
   FOR rec_ IN addresses LOOP
      INSERT INTO fndcn_msg_archive_addr_tab (
         rowversion,
         reply,
         zip,
         message_archive_id,
         sub_system,
         sent,
         sender,
         response_transformer,
         address_data_2,
         state,
         transport_connector,
         sender_organization,
         receiver,
         encoding,
         transformer,
         envelope,
         receiver_organization,
         seq_no,
         options,
         address_data,
         response,
         sender_instance )
      VALUES (
         1,
         rec_.reply,
         rec_.zip,
         rec_.application_message_id,
         rec_.sub_system,
         rec_.sent,
         rec_.sender,
         rec_.response_transformer,
         rec_.address_data_2,
         rec_.state,
         rec_.transport_connector,
         rec_.sender_organization,
         rec_.receiver,
         rec_.encoding,
         rec_.transformer,
         rec_.envelope,
         rec_.receiver_organization,
         rec_.seq_no,
         rec_.options,
         rec_.address_data,
         rec_.response,
         rec_.sender_instance );
   END LOOP;
EXCEPTION
   WHEN dup_val_on_index THEN null;
   WHEN others           THEN raise;
END Archive_Address_Label___;


PROCEDURE Archive_Body___ (
   application_message_id_   IN VARCHAR2 )
IS
   CURSOR bodies IS
      SELECT *
      FROM   fndcn_message_body_tab
      WHERE  application_message_id  = application_message_id_;
BEGIN
   FOR rec_ IN bodies LOOP
      INSERT INTO fndcn_msg_archive_body_tab (
         rowversion,
         body_id,
         name,
         message_archive_id,
         seq_no,
         body_type,
         message_value,
         reply,
         message_text)
      VALUES (
         1,
         rec_.body_id,
         rec_.name,
         rec_.application_message_id,
         rec_.seq_no,
         rec_.body_type,
         rec_.message_value,
         rec_.reply,
         rec_.message_text);
   END LOOP;
EXCEPTION
   WHEN dup_val_on_index THEN null;
   WHEN others           THEN raise;
END Archive_Body___;


PROCEDURE Archive_Application_Message___ (
   message_ IN fndcn_application_message_tab%ROWTYPE )
IS
BEGIN
   INSERT INTO fndcn_msg_archive_tab (
      rowversion,
      created_by,
      created_date,
      connectivity_id,
      state_date,
      queue,
      message_archive_id,
      execute_as,
      subject,
      sender,
      message_type,
      message_function,
      external_message_id,
      locale,
      state,
      options,
      initiated_by,
      initiated,
      receiver,
      seq_no,
      created_from,
      inbound )
   VALUES (
      message_.rowversion,
      message_.created_by,
      message_.created_date,
      message_.connectivity_id,
      message_.state_date,
      message_.queue,
      message_.application_message_id,
      message_.execute_as,
      message_.subject,
      message_.sender,
      message_.message_type,
      message_.message_function,
      message_.external_message_id,
      message_.locale,
      message_.state,
      message_.options,
      message_.initiated_by,
      message_.initiated,
      message_.receiver,
      message_.seq_no,
      message_.created_from,
      message_.inbound );
EXCEPTION
   WHEN dup_val_on_index THEN null;
   WHEN others           THEN raise;
END Archive_Application_Message___;


PROCEDURE New_Message_Archive_Search___ (
   msg_ IN fndcn_application_message_tab%ROWTYPE )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(32000);
BEGIN
    Client_SYS.Clear_Attr(attr_);
    Client_SYS.Add_To_Attr('MESSAGE_FUNCTION'   , msg_.message_function      , attr_);
    Client_SYS.Add_To_Attr('MESSAGE_TYPE'       , msg_.message_type          , attr_);
    Client_SYS.Add_To_Attr('SENDER'             , msg_.sender                , attr_);
    Client_SYS.Add_To_Attr('RECEIVER'           , msg_.receiver              , attr_);
    Client_SYS.Add_To_Attr('INBOUND'            , msg_.inbound               , attr_);
    Client_SYS.Add_To_Attr('PROCESSED_DATE'     , msg_.initiated             , attr_);
    Client_SYS.Add_To_Attr('EXTERNAL_MESSAGE_ID', msg_.external_message_id   , attr_);
    Client_SYS.Add_To_Attr('ARCHIVE_ID'         , msg_.application_message_id, attr_);
    Client_SYS.Add_To_Attr('MESSAGE_FUNCTION'   , msg_.message_function      , attr_);
    Client_SYS.Add_To_Attr('SEARCH_ID'          , sys_guid()                 , attr_);
    Client_SYS.Add_To_Attr('ELEMENT_NAME'       , msg_.queue                 , attr_);
    Client_SYS.Add_To_Attr('ELEMENT_VALUE'      , msg_.subject               , attr_);
    Message_Archive_Search_API.New__(info_, objid_, objversion_, attr_, 'DO');
END New_Message_Archive_Search___;


PROCEDURE Delete_Message___ (id_ IN NUMBER) IS
BEGIN
   DELETE fndcn_address_label_tab       WHERE application_message_id = id_;
   DELETE fndcn_message_body_tab        WHERE application_message_id = id_;
   DELETE fndcn_application_message_tab WHERE application_message_id = id_;
END Delete_Message___;


PROCEDURE Archive_Chunk___ (
   queue_          IN  VARCHAR2,
   state_          IN  VARCHAR2,
   age_in_days_    IN  NUMBER,
   max_count_      IN  NUMBER,
   archived_count_ OUT NUMBER)
IS
   count_ NUMBER := 0;
BEGIN
   FOR m_ IN (SELECT *
                FROM fndcn_application_message_tab
               WHERE queue = queue_
                 AND state = state_
                 AND state_date < SYSDATE - age_in_days_
                 AND (tag IS NULL OR tag <> 'BATCH'))
   LOOP
      Archive_Message(m_);
      New_Message_Archive_Search___(m_);
      Delete_Message___(m_.application_message_id);
      count_ := count_ + 1;
      EXIT WHEN count_ >= max_count_;
   END LOOP;
   archived_count_ := count_;
END Archive_Chunk___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Archive_Message (
   message_ IN fndcn_application_message_tab%ROWTYPE )
IS
BEGIN
   archive_address_label___(message_.application_message_id);
   archive_body___(message_.application_message_id);
   archive_application_message___(message_);
END Archive_Message;


PROCEDURE Archive (
   queue_        IN VARCHAR2,
   state_        IN VARCHAR2,
   hours_old_    IN NUMBER,
   commit_count_ IN NUMBER := 10000)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   age_in_days_ NUMBER := hours_old_ / 24;
   total_count_ NUMBER := 0;
   count_       NUMBER;
BEGIN
   LOOP
      Archive_Chunk___(queue_          => queue_,
                       state_          => state_,
                       age_in_days_    => age_in_days_,
                       max_count_      => commit_count_,
                       archived_count_ => count_);
      @ApproveTransactionStatement(2015-02-20,madrse)
      COMMIT;
      Dbms_Output.Put_Line('Archived and committed chunk of [' || count_ || '] messages on queue [' || queue_ || ']');
      total_count_ := total_count_ + count_;
      EXIT WHEN count_ < commit_count_;
   END LOOP;
   Dbms_Output.Put_Line('Totally archived and committed [' || total_count_ || '] messages on queue [' || queue_ || ']');
END Archive;

