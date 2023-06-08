-----------------------------------------------------------------------------
--
--  Logical unit: FndStream
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
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT fnd_stream_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.message_id := fnd_stream_id_seq.nextval;
   newrec_.visible := Fnd_Boolean_API.DB_TRUE;
   newrec_.read := Fnd_Boolean_API.DB_FALSE;
   newrec_.created_date := sysdate;
   super(objid_, objversion_, newrec_, attr_);
   Client_Notification_SYS.Create_Message_(Client_Notification_Type_API.DB_FND_STREAM,Fnd_User_API.Get_Web_User(newrec_.to_user),newrec_.message_id,NULL);
END Insert___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
@UncheckedAccess
FUNCTION Translate_Message_ (
   stream_msg_type_ IN VARCHAR2,
   message_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE stream_msg_type_
   WHEN Fnd_Stream_Type_API.DB_SUBSCRIBED_OBJECT THEN
      RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg(message_);
   WHEN Fnd_Stream_Type_API.DB_SUBSCRIPTION_EXPIRED THEN
      RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg(message_);
   WHEN Fnd_Stream_Type_API.DB_BACKGROUND_JOB THEN
          RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg(message_);
   WHEN Fnd_Stream_Type_API.DB_REPORT THEN
          RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg(message_);
   ELSE
      RETURN message_;
   END CASE;
END Translate_Message_;

@UncheckedAccess
FUNCTION Translate_Message_Header (
   stream_header_type_ IN VARCHAR2,
   header_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE stream_header_type_ 
   WHEN Fnd_Stream_Type_API.DB_BACKGROUND_JOB THEN
       RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg_Header(header_);  
   WHEN Fnd_Stream_Type_API.DB_REPORT THEN
       RETURN Fnd_Obj_Subscription_Util_API.Get_Translated_Msg_Header(header_);  
   ELSE
   RETURN header_;
   END CASE;
END Translate_Message_Header;

PROCEDURE Cleanup_Messages_
IS 
   TYPE REC_LIST_TYP IS TABLE OF  fnd_stream_tab%ROWTYPE INDEX BY PLS_INTEGER;
   rec_list_ REC_LIST_TYP;
   keep_streams_days_ NUMBER := to_number(Fnd_Setting_API.Get_Value('KEEP_STREAMS_DAYS'));
   CURSOR old_streams_msgs_ IS 
      SELECT * FROM fnd_stream_tab where created_date+keep_streams_days_ < sysdate;
   
BEGIN
   OPEN old_streams_msgs_;
   LOOP 
      FETCH old_streams_msgs_ 
         BULK COLLECT INTO rec_list_ LIMIT 100;
      EXIT WHEN rec_list_.COUNT = 0;
      FOR i IN 1..rec_list_.COUNT LOOP
         Remove___(rec_list_(i));
      END LOOP;
   END LOOP;
END Cleanup_Messages_;
   
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE New_Stream_Item(stream_ IN OUT fnd_stream_tab%ROWTYPE)
IS
BEGIN
   stream_.visible := Fnd_Boolean_API.DB_TRUE;
   stream_.read := Fnd_Boolean_API.DB_FALSE;
   New___(stream_);
END New_Stream_Item;

PROCEDURE Create_Event_Action_Streams(
   from_ IN VARCHAR2,
   to_names_ IN VARCHAR2,
   header_ IN VARCHAR2,
   body_ IN VARCHAR2,
   url_ IN VARCHAR2)
IS
   stream_ fnd_stream_tab%ROWTYPE;
   to_user_list_ Utility_SYS.STRING_TABLE;
   to_user_count_ NUMBER;
BEGIN
   stream_.from_user := from_;
   stream_.header    := header_;
   stream_.message   := body_;
   stream_.url       := url_;
   stream_.stream_type := Fnd_Stream_Type_API.DB_GENERAL;
   stream_.read        := Fnd_Boolean_API.DB_FALSE;
   stream_.visible     := Fnd_Boolean_API.DB_TRUE;
   stream_.lu_name     := Fnd_Event_Action_API.lu_name_;
   Utility_SYS.Tokenize (to_names_,',',to_user_list_,to_user_count_);
   FOR i IN 1 .. to_user_count_ LOOP 
      stream_.message_id := NULL;
      stream_.to_user    := trim(to_user_list_(i)); 
      Fnd_Stream_API.New_Stream_Item(stream_);
   END LOOP;
END Create_Event_Action_Streams;

PROCEDURE Create_Background_Jobs_Stream(
   header_            VARCHAR2,
   message_           VARCHAR2,
   trans_header_lu_   VARCHAR2,
   trans_message_lu_  VARCHAR2,
   to_user_           VARCHAR2,
   custom_ref_        VARCHAR2 DEFAULT NULL,   
   url_               VARCHAR2 DEFAULT NULL,   
   message_parameter_ VARCHAR2 DEFAULT NULL,
   notes_             VARCHAR2 DEFAULT NULL,
   schedule_id_       NUMBER DEFAULT NULL,
   job_id_            NUMBER DEFAULT NULL,
   web_url_           VARCHAR2 DEFAULT NULL)
IS         
   stream_ref_msg_ VARCHAR2(4000);             
   stream_rec_       fnd_stream_tab%ROWTYPE;
BEGIN
   --Constructing the REF message        
   stream_ref_msg_ := Message_SYS.Construct('FndStream');
   Message_SYS.Add_Attribute(stream_ref_msg_, 'CUSTOM_REF',custom_ref_);    
   Message_SYS.Add_Attribute(stream_ref_msg_,'SCHEDULE_ID',schedule_id_);  
   Message_SYS.Add_Attribute(stream_ref_msg_,'JOB_ID',job_id_);
   stream_rec_.reference := stream_ref_msg_;            
   stream_rec_.stream_type := Fnd_Stream_Type_API.DB_BACKGROUND_JOB;
   stream_rec_.to_user := to_user_;  
   stream_rec_.notes := notes_;      
   stream_rec_.url:= url_;     
   stream_rec_.header := Fnd_Obj_Subscription_Util_API.Translatable_Msg_Header(trans_header_lu_,header_);
   stream_rec_.message:= Fnd_Obj_Subscription_Util_API.Translatable_Jobs_Message(trans_message_lu_,message_,message_parameter_);     
   stream_rec_.web_url := web_url_;
   Fnd_Stream_API.New_Stream_Item(stream_rec_); 
END Create_Background_Jobs_Stream;
   
   
PROCEDURE Create_Reports_Stream(
   header_ VARCHAR2,
   message_ VARCHAR2,
   trans_header_lu_ VARCHAR2,
   trans_message_lu_ VARCHAR2,
   to_user_ VARCHAR2,
   custom_ref_ VARCHAR2 DEFAULT NULL,   
   url_ VARCHAR2 DEFAULT NULL,   
   message_parameter_ VARCHAR2 DEFAULT NULL,
   notes_ VARCHAR2 DEFAULT NULL,
   schedule_id_ NUMBER DEFAULT NULL,
   job_id_ NUMBER DEFAULT NULL )
      
   IS         
      stream_ref_msg_ VARCHAR2(4000);             
      stream_rec_       fnd_stream_tab%ROWTYPE;
   BEGIN
         --Constructing the REF message        
      stream_ref_msg_ := Message_SYS.Construct('FndStream');
      Message_SYS.Add_Attribute(stream_ref_msg_, 'CUSTOM_REF',custom_ref_);    
      Message_SYS.Add_Attribute(stream_ref_msg_,'SCHEDULE_ID',schedule_id_);  
      Message_SYS.Add_Attribute(stream_ref_msg_,'JOB_ID',job_id_);
      stream_rec_.reference := stream_ref_msg_;            
      stream_rec_.stream_type := Fnd_Stream_Type_API.DB_REPORT;
      stream_rec_.to_user := to_user_;  
      stream_rec_.notes := notes_;      
      stream_rec_.url:= url_;     
      stream_rec_.header := Fnd_Obj_Subscription_Util_API.Translatable_Msg_Header(trans_header_lu_,header_);
      stream_rec_.message:= Fnd_Obj_Subscription_Util_API.Translatable_Jobs_Message(trans_message_lu_,message_,message_parameter_);     
       
      Fnd_Stream_API.New_Stream_Item(stream_rec_);
         
END Create_Reports_Stream;
   
-----------------------------------------------------------------------------
-- Returns the subset of given users who have newer messages available.
--
--   Parameter attribute string must contain <username, message_id>   
--   pairs. This method checks whether there are any newer messages for 
--   each user, by comparing the given message_id for the user, 
--   against the maximum message_id found in the database for that user 
--   (null values for message_id are accepted). 
--
--   If a newer message_id is found in the database, a pair
--   <username, max message_id found> is added to the return attribute list.
--
--   This way, the function returns 'a subset of the given users, who have
--   newer messages', each with the username and the message_id
--   of the latest message for that user.
-----------------------------------------------------------------------------

@UncheckedAccess
FUNCTION Get_Users_Having_New_Messages(
   attr_ IN VARCHAR2) RETURN VARCHAR2
IS
   ptr_                      NUMBER;
   value_                    VARCHAR2(256);
   username_                 VARCHAR2(256);
   results_attr_             VARCHAR2(32000);
   
   message_id_               NUMBER;
   max_message_id_           NUMBER;
   user_max_message_id_      NUMBER;
   all_users_max_message_id_ NUMBER;
   
   CURSOR get_latest_streams_id
   IS
      SELECT NVL(MAX(t.message_id), -1)
      FROM fnd_stream_tab t
      WHERE t.to_user = username_;
BEGIN
   Client_SYS.Clear_Attr(results_attr_);
   
   -- Get max message id of messages announced for all users.
   username_ := '*';
   OPEN get_latest_streams_id;
   FETCH get_latest_streams_id INTO all_users_max_message_id_;
   CLOSE get_latest_streams_id;
   
   -- Get max message id of messages for each requested user
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, username_, value_)) LOOP    
      BEGIN
         message_id_ := Client_SYS.Attr_Value_To_Number(value_);
      
         OPEN get_latest_streams_id;
         FETCH get_latest_streams_id INTO user_max_message_id_;
         CLOSE get_latest_streams_id;
      
         IF user_max_message_id_ > all_users_max_message_id_ THEN
            max_message_id_ := user_max_message_id_;
         ELSE
            max_message_id_ := all_users_max_message_id_;
         END IF;
      
         IF (message_id_ IS NULL) THEN              
            IF max_message_id_ != -1 THEN
               Client_SYS.Add_To_Attr(username_, max_message_id_, results_attr_);
            END IF;               
         ELSIF max_message_id_ > message_id_ THEN
            Client_SYS.Add_To_Attr(username_, max_message_id_, results_attr_);
         END IF;
      
      EXCEPTION
         WHEN OTHERS THEN
            Client_SYS.Add_To_Attr(username_, 'ERROR:' || SQLERRM, results_attr_);
      END;
   END LOOP;
   RETURN results_attr_;
END Get_Users_Having_New_Messages;

FUNCTION Transform_Key_Ref (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_id_ NUMBER;
   rec_ Fnd_Stream_API.Public_Rec;
BEGIN
   message_id_ := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'MESSAGE_ID');
   IF message_id_ IS NOT NULL then
      rec_ := Fnd_Stream_API.Get(message_id_);
      IF rec_.lu_name IS NOT NULL THEN
         RETURN Client_SYS.Get_Key_Reference_From_Objkey(rec_.lu_name, rec_.referenced_objkey);
      END IF;
   END IF;
   RETURN NULL;
END Transform_Key_Ref;