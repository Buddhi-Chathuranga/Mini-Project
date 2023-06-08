-----------------------------------------------------------------------------
--
--  Logical unit: MyTodoItem
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120705  MaBose  Conditional compiliation improvements - Bug 10391
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT my_todo_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;   
$IF Component_Enterp_SYS.INSTALLED $THEN
   Person_Info_API.Exist(newrec_.identity);
$END
   super(newrec_, indrec_, attr_);
   newrec_.read := 0;
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     my_todo_item_tab%ROWTYPE,
   newrec_ IN OUT my_todo_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   indrec_.sent_by := FALSE; -- Don't validate sent_by
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

@Override 
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     my_todo_item_tab%ROWTYPE,
   newrec_     IN OUT my_todo_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Create_Streams_Notification___(newrec_);
END Update___;

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT my_todo_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Create_Streams_Notification___(newrec_);
END Insert___;

PROCEDURE Create_Streams_Notification___ (
   newrec_ IN my_todo_item_tab%ROWTYPE)
IS
   to_user_id_ VARCHAR2(100);
   curr_user_id_ VARCHAR2(100);
   from_user_id_ VARCHAR2(100);
   msg_ VARCHAR2(32000);
   stream_rec_ fnd_stream_tab%ROWTYPE;
   
   CURSOR get_todo_item (item_id_ VARCHAR2, folder_id_ VARCHAR2, folder_type_ VARCHAR2) IS
      SELECT i.item_id, i.title, i.item_message, i.url
      FROM todo_item_tab i, todo_folder_tab f
      WHERE i.item_id = item_id_
      AND f.folder_id = folder_id_
      AND f.folder_type = folder_type_;

   rec_ get_todo_item%ROWTYPE;
   
BEGIN
   $IF Component_Enterp_SYS.INSTALLED $THEN
      to_user_id_ := Person_Info_API.Get_User_Id(newrec_.identity);
      IF (newrec_.sent_by IS NOT NULL) THEN
         from_user_id_ := Person_Info_API.Get_User_Id(newrec_.sent_by);
      END IF;
   $END

   curr_user_id_ := Fnd_Session_API.Get_Fnd_User();

   IF (from_user_id_ IS NOT NULL AND to_user_id_ IS NOT NULL AND curr_user_id_ != to_user_id_) THEN
      OPEN get_todo_item (newrec_.item_id, newrec_.folder_id, Todo_Folder_Type_API.DB_TODO);
      FETCH get_todo_item INTO rec_;
      CLOSE get_todo_item;
      
      IF (rec_.item_id IS NOT NULL) THEN
         stream_rec_.from_user := from_user_id_;
         stream_rec_.header := rec_.title;
         stream_rec_.lu_name := lu_name_;
         stream_rec_.message := rec_.item_message;
         stream_rec_.stream_type := Fnd_Stream_Type_API.DB_TASK;
         stream_rec_.to_user := to_user_id_;
         stream_rec_.url := rec_.url;
         stream_rec_.visible := 'TRUE';
         stream_rec_.read := 'FALSE';
         
         -- Reference
         msg_ := Message_Sys.Construct(lu_name_);
         Message_Sys.Add_Attribute( msg_, 'ITEM_ID', newrec_.item_id);
         Message_Sys.Add_Attribute( msg_, 'IDENTITY', to_user_id_);
         stream_rec_.reference := msg_;
         Fnd_Stream_API.New_Stream_Item(stream_rec_);
      END IF;
   END IF;
END Create_Streams_Notification___;

PROCEDURE Insert_Basic_My_Todo_Item__ (
   person_id_          IN VARCHAR2 DEFAULT NULL,   
   item_id_          IN VARCHAR2 )
IS
   newrec_     my_todo_item_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);   
   folder_id_ VARCHAR2(100);
   temp_id_ VARCHAR2(100);
   CURSOR folder_cursor (user_identity_ VARCHAR2 ) IS 
      SELECT t.folder_id
      FROM todo_folder t
      WHERE t.identity = user_identity_
      AND t.folder_type_db = 'Todo';
BEGIN
   $IF Component_Enterp_SYS.INSTALLED $THEN
      temp_id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User());
   $END 
   OPEN folder_cursor (NVL(person_id_, temp_id_));
   FETCH folder_cursor INTO folder_id_;
   CLOSE folder_cursor;   
   newrec_.created_by        := temp_id_;
   newrec_.created_date      := sysdate;
   newrec_.date_received     := sysdate;
   newrec_.folder_id         := folder_id_;
   newrec_.identity          := NVL(person_id_, temp_id_);
   newrec_.item_id           := item_id_;
   newrec_.new_item          := 1;
   newrec_.read              := 1;
   newrec_.sent_by           := temp_id_;
   Insert___(objid_, objversion_, newrec_, attr_);
END Insert_Basic_My_Todo_Item__;

PROCEDURE Insert_Basic_Sent_To_Item__ (
   sender_          IN VARCHAR2 DEFAULT NULL,
   item_id_          IN VARCHAR2 )
IS
   newrec_     my_todo_item_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);   
   folder_id_ VARCHAR2(100);
   temp_id_ VARCHAR2(100);
   
   CURSOR folder_cursor (person_identity_ VARCHAR2 ) IS 
      SELECT t.folder_id
      FROM TODO_FOLDER t
      WHERE t.identity = person_identity_
      AND t.folder_type_db = 'SentItems';
BEGIN
   
   $IF Component_Enterp_SYS.INSTALLED $THEN
      temp_id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User());
   $END 
   OPEN folder_cursor (NVL(sender_, temp_id_));
   FETCH folder_cursor INTO folder_id_;
   CLOSE folder_cursor;
   newrec_.created_by        := NVL(sender_, temp_id_);
   newrec_.created_date      := SYSDATE;
   newrec_.date_received     := SYSDATE;
   newrec_.folder_id         := folder_id_;
   newrec_.identity          := NVL(sender_, temp_id_);
   newrec_.item_id           := item_id_;
   newrec_.new_item          := 1;
   newrec_.read              := 1;
   newrec_.sent_by           := NVL(sender_, temp_id_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Insert_Basic_Sent_To_Item__;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


