-----------------------------------------------------------------------------
--
--  Logical unit: FndWorkflowTaskUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120619  AsWiLk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Post_To_Folder___ (
   user_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   folder_id_           VARCHAR2(100);	
   attr_                VARCHAR2(2000);	
   info_                VARCHAR2(2000);
   objid_               VARCHAR2(200);
   objversion_          VARCHAR2(200);
   item_counter_        NUMBER;
   unread_item_counter_ NUMBER;
   CURSOR folder_exist(user_id_ IN VARCHAR2) IS
      SELECT folder_id, item_counter, unread_item_counter
      FROM TODO_FOLDER_TAB
      WHERE identity = user_id_
      AND main_folder = 1
      AND folder_type = ToDo_Folder_Type_API.DB_TODO;
BEGIN
   OPEN folder_exist (user_);
   FETCH folder_exist INTO folder_id_, item_counter_, unread_item_counter_;
   IF (folder_exist%NOTFOUND) THEN
      folder_id_ := Sys_Guid;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'FOLDER_ID', folder_id_, attr_ );
      Client_SYS.Add_To_Attr( 'IDENTITY', user_, attr_ );
      Client_SYS.Add_To_Attr( 'MAIN_FOLDER', 1, attr_ );
      Client_SYS.Add_To_Attr( 'FOLDER_INDEX', 0, attr_ );
      Client_SYS.Add_To_Attr( 'ITEM_COUNTER', 0, attr_ );
      Client_SYS.Add_To_Attr( 'UNREAD_ITEM_COUNTER', 0, attr_ );
      Client_SYS.Add_To_Attr( 'FOLDER_TYPE_DB', ToDo_Folder_Type_API.DB_TODO, attr_ );
      Client_SYS.Add_To_Attr( 'NAME', ToDo_Folder_Type_API.Decode(ToDo_Folder_Type_API.DB_TODO), attr_ );
      ToDo_Folder_API.New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      UPDATE TODO_FOLDER_TAB
      SET item_counter = item_counter_ + 1,
          unread_item_counter = unread_item_counter_ + 1
      WHERE folder_id = folder_id_
      AND identity = user_
      AND main_folder = 1
      AND folder_type = ToDo_Folder_Type_API.DB_TODO;
   END IF;
   CLOSE folder_exist;
   RETURN folder_id_;
END Post_To_Folder___;


PROCEDURE New_My_Todo_Item___ (
   item_id_ IN VARCHAR2,
   sender_ IN VARCHAR2,
   receiver_ IN VARCHAR2,
   due_date_ IN DATE )
IS
   attr_         VARCHAR2(2000);
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(200);
   objversion_   VARCHAR2(200);
   person_id_    VARCHAR2(50);
BEGIN
$IF Component_Enterp_SYS.INSTALLED $THEN
   person_id_ := Person_Info_API.Get_Id_For_User(receiver_);
   IF (person_id_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'ITEM_ID', item_id_, attr_ );
      Client_SYS.Add_To_Attr( 'IDENTITY', person_id_, attr_ );
      Client_SYS.Add_To_Attr( 'SENT_BY', sender_, attr_ );
      Client_SYS.Add_To_Attr( 'DUE_DATE', due_date_, attr_ );
      Client_SYS.Add_To_Attr( 'FOLDER_ID', Post_To_Folder___(receiver_), attr_ );
      Client_SYS.Add_To_Attr( 'TIME_STAMP', SYSDATE, attr_ );
      Client_SYS.Add_To_Attr( 'NEW_ITEM', 1, attr_ );
      Client_SYS.Add_To_Attr( 'DATE_RECEIVED', SYSDATE, attr_ );
      My_ToDo_Item_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
$ELSE
   NULL;
$END
END New_My_Todo_Item___;

PROCEDURE Unpack_Recievers___ (
  receiver_ IN VARCHAR2,
  array_    IN OUT DBMS_UTILITY.lname_array,
  count_    IN OUT NUMBER )
IS
   del_regex_   VARCHAR2(5)     := '(,|;)';
   l_string_    VARCHAR2(32767) := receiver_ || ';';
   l_del_index_ PLS_INTEGER     := 1;
   l_index_     PLS_INTEGER     := 1;
   index_       PLS_INTEGER     := 1;
BEGIN
   LOOP
      l_del_index_   := REGEXP_INSTR(l_string_, del_regex_, l_index_);
      array_(index_) := SUBSTR(l_string_, l_index_, l_del_index_ - l_index_);
      l_index_       := l_del_index_+ 1;
      index_         := index_+1;
   EXIT
      WHEN l_del_index_ = LENGTH(l_string_);
   END LOOP;
   count_ := index_-1;
END Unpack_Recievers___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Human_Task (
   task_id_                OUT VARCHAR2,
   subject_                IN VARCHAR2,
   message_                IN VARCHAR2,
   receiver_               IN VARCHAR2,
   url_                    IN VARCHAR2,
   priority_               IN VARCHAR2,
   due_date_               IN DATE,
   business_object_        IN VARCHAR2,
   response_options_       IN VARCHAR2 )
IS
   identity_   VARCHAR2(200) := Fnd_Session_API.Get_Fnd_User;
   task_attr_  VARCHAR2(4000);
   shared_     NUMBER := 0;
   count_      BINARY_INTEGER;
   array_      DBMS_UTILITY.lname_array;
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(200);
   objversion_ VARCHAR2(200);
   sent_to_users_      VARCHAR2(4000);
   to_user_            VARCHAR2(50);

   PROCEDURE AddElement(list_ IN OUT VARCHAR2,element_ IN VARCHAR2)
   IS
   BEGIN
      list_ := list_ || ';' || element_;
   END AddElement;
   
   FUNCTION ContainsElement(list_ IN OUT VARCHAR2,element_ IN VARCHAR2) RETURN BOOLEAN 
   IS
   BEGIN
      IF Instr(list_,';' || element_) > 0 THEN
         Return(TRUE);
      ELSE
         Return(FALSE);
      END IF;
   END ContainsElement;   
   

BEGIN
   task_id_ := Sys_Guid;
   Client_SYS.Clear_Attr(task_attr_);
   Client_SYS.Add_To_Attr( 'ITEM_ID', task_id_, task_attr_ );
   Client_SYS.Add_To_Attr( 'TITLE', subject_, task_attr_ );
   Client_SYS.Add_To_Attr( 'ITEM_MESSAGE', message_, task_attr_ );
   Client_SYS.Add_To_Attr( 'URL', url_, task_attr_ );
   Client_SYS.Add_To_Attr( 'PRIORITY_DB',priority_, task_attr_ );
   Client_SYS.Add_To_Attr( 'BUSINESS_OBJECT', business_object_, task_attr_ );      
   Client_SYS.Add_To_Attr( 'COMPLETE_RESPONSE_OPTIONS', response_options_, task_attr_ );
   Client_SYS.Add_To_Attr( 'ITEM_TYPE_DB', ToDo_Item_Type_API.DB_WORKFLOW, task_attr_ );
   shared_ := 0;
   IF (receiver_ IS NOT NULL) THEN
      --unpack receivers
      Unpack_Recievers___(receiver_,array_,count_);
      --shared if more than 1
      IF (count_ > 1) THEN
         shared_ := 1;
      ELSE
         shared_ := 0; 
      END IF;		
   END IF;
   Client_SYS.Add_To_Attr( 'SHARED', shared_, task_attr_ );
   ToDo_Item_API.New__(info_, objid_, objversion_, task_attr_, 'DO');	
   IF (receiver_ IS NULL) THEN
      New_My_Todo_Item___(task_id_, identity_, identity_, due_date_);
   ELSE      
      FOR i IN 1..count_ LOOP
         to_user_ := TRIM(array_(i));
         IF (NOT ContainsElement(sent_to_users_,to_user_)) THEN --just keep track of who we send the task to , so the same user is not assinged twice
            New_My_Todo_Item___(task_id_, identity_,to_user_,due_date_);
            AddElement(sent_to_users_ , to_user_);
         END IF;               
      END LOOP;
   END IF;
END Create_Human_Task;



PROCEDURE Create_Human_Task (
   task_id_ OUT VARCHAR2,
   attr_ IN VARCHAR2 )
IS
BEGIN
   Create_Human_Task(task_id_,
                     Client_SYS.Get_Item_Value('SUBJECT', attr_),
                     Client_SYS.Get_Item_Value('MESSAGE', attr_),
                     Client_SYS.Get_Item_Value('RECEIVER', attr_),
                     Client_SYS.Get_Item_Value('URL', attr_),
                     Client_SYS.Get_Item_Value('PRIORITY', attr_),
                     NULL, 
                     Client_SYS.Get_Item_Value('BUSINESS_OBJECT', attr_),
                     NULL);
   --TODO set due date in event action
END Create_Human_Task;


