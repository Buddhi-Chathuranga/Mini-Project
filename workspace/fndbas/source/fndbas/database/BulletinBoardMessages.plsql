-----------------------------------------------------------------------------
--
--  Logical unit: BulletinBoardMessages
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000401  Mangala  Created for Webkit 300Bx. This supports BulletinBoard Portlet
--                   server methods.
--  000526  ROOD     Modifications to synchronise with model and changes in Unpack_Check_Insert___.
--  030212  ROOD     Changed module to FNDBAS (ToDo#4149).
--  030221  ROOD     Modified a translateble constant that was not found by Localize
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bulletin_board_messages_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   id_    NUMBER;

   CURSOR get_max_id(topic_id_ IN VARCHAR2) IS
      SELECT MAX(message_id)
      FROM BULLETIN_BOARD_MESSAGES_TAB
      WHERE topic_id = topic_id_;
BEGIN
   Bulletin_Board_Topics_API.Exist(newrec_.topic_id);
   
   OPEN get_max_id(newrec_.topic_id);
   FETCH get_max_id INTO id_;
   CLOSE get_max_id;
   IF (id_ IS NULL) THEN
      id_ := 0;
   END IF;

   newrec_.message_id := id_ + 1;
   newrec_.created_at := SYSDATE;
   newrec_.writer     := Fnd_Session_API.Get_Fnd_User;

   IF (Bulletin_Board_Topic_Users_API.Is_Writer(newrec_.topic_id) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_,'NOTAWRITER: User :P1 does not have write access to this topic.', newrec_.writer);
   END IF;

   super(newrec_, indrec_, attr_);
   
   Client_SYS.Add_To_Attr('MESSAGE_ID', newrec_.message_id , attr_);
   Client_SYS.Add_To_Attr('OWNER', newrec_.writer , attr_);
   Client_SYS.Add_To_Attr('CREATED_AT', newrec_.created_at, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Messages (
   topic_id_ IN NUMBER ) RETURN VARCHAR2
IS
   msg_      VARCHAR2(2000);

   CURSOR get_next_message IS
      SELECT message, fnd_user_api.get_description(writer) writer_name, TO_CHAR(created_at, 'MM-DD-YYYY HH24:MI:SS') time, fnd_user_property_api.get_value(writer,'SMTP_MAIL_ADDRESS') email
      FROM  bulletin_board_messages
      WHERE topic_id = topic_id_
      ORDER BY created_at DESC;

BEGIN
   FOR message_rec_ IN get_next_message LOOP
      msg_ := msg_ || message_rec_.writer_name || CHR(31) || message_rec_.email || CHR(31) || message_rec_.time || CHR(31) || message_rec_.message || CHR(30);
   END LOOP;
   RETURN msg_;
END Get_Messages;



