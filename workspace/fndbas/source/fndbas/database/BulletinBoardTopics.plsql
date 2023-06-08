-----------------------------------------------------------------------------
--
--  Logical unit: BulletinBoardTopics
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000401  Mangala  Created for Webkit 300Bx. This supports BulletinBoard Portlet
--                   server methods.
--  000407  Mangala  Add new implementation method to automaticaly add the Creater
--                   as User with write acess.
--  000531  ROOD     Changed all type declarations of type NUMBER(X) to NUMBER.
--                   Changed the calls to Fnd_Session_API.Get_Fnd_User and some
--                   minor performance improvements.
--  000601  ROOD     Removed method Insert_Owner___. Added call to Bulletin_Board_Topic_Users_API.New_.
--  000605  ROOD     Changed to use table in cursor in method Enumerate_Topics.
--  020624  ROOD     Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD     Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BULLETIN_BOARD_TOPICS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   -- Insert the owner as writer in the topic.
   Bulletin_Board_Topic_Users_API.New_(newrec_.topic_id, newrec_.owner, 'WRITER');
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bulletin_board_topics_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   CURSOR get_next_id IS
      SELECT Bulletin_Board_Topic_Id_Seq.NEXTVAL
      FROM dual;
BEGIN
   OPEN  get_next_id;
   FETCH get_next_id INTO newrec_.topic_id;
   CLOSE get_next_id;
   
   newrec_.owner := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_at := SYSDATE;
   
   super(newrec_, indrec_, attr_);
  
   Client_SYS.Add_To_Attr('TOPIC_ID', newrec_.topic_id, attr_);
   Client_SYS.Add_To_Attr('OWNER', newrec_.owner , attr_);
   Client_SYS.Add_To_Attr('CREATED_AT', newrec_.created_at, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enumerate_Topics (
   topic_id_   OUT VARCHAR2,
   topic_desc_ OUT VARCHAR2 )
IS
   identity_   VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;

   CURSOR get_next_topic IS
      SELECT topics.topic_id, topics.description
      FROM  BULLETIN_BOARD_TOPICS_TAB topics, bulletin_board_topic_users_tab users
      WHERE users.topic_id = topics.topic_id
      AND   users.identity = identity_;
BEGIN
   FOR topic_rec_ IN get_next_topic LOOP
      topic_desc_ := topic_desc_ || topic_rec_.description || CHR(30);
      topic_id_ := topic_id_ || TO_CHAR(topic_rec_.topic_id) || CHR(30);
   END LOOP;
END Enumerate_Topics;



