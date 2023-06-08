-----------------------------------------------------------------------------
--
--  Logical unit: PlsqlRestSender
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181108  JAPASE  PACDATA-44 - Added support for Documents.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
default_recevier_   CONSTANT VARCHAR2(100) := 'CONNECT';

error_queue_        CONSTANT VARCHAR2(100) := 'ERROR';


SUBTYPE type_connection_string_    IS VARCHAR2(255);

SUBTYPE type_record_               IS Plsqlap_Record_API.type_record_;
SUBTYPE Document                   IS Plsqlap_Document_API.Document;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Call_Rest_EndPoint___ (
   msg_payload_doc_        IN OUT Document,
   msg_payload_rec_        IN OUT type_record_,
   xml_                    IN     CLOB      DEFAULT NULL,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     CLOB,
   callback_func_          IN     VARCHAR2,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2,
   query_parameters_       IN     CLOB,
   header_params_          IN     CLOB,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2,
   key_ref_                IN     VARCHAR2,
   sender_                 IN     VARCHAR2,
   message_type_           IN     VARCHAR2,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2,
   subject_                IN     VARCHAR2,
   in_order_               IN     BOOLEAN,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     VARCHAR2 DEFAULT NULL)
IS
   json_       CLOB;
   message_id_ NUMBER;
BEGIN
   Call_Rest_EndPoint___(
      msg_payload_doc_        => msg_payload_doc_,
      msg_payload_rec_        => msg_payload_rec_,
      xml_                    => xml_,
      json_                   => json_,
      message_id_             => message_id_,      
      rest_service_           => rest_service_,
      url_params_             => url_params_,
      callback_func_          => callback_func_,
      http_method_            => http_method_,
      http_req_headers_       => http_req_headers_,
      query_parameters_       => query_parameters_,
      header_params_          => header_params_,
      incld_resp_info_        => incld_resp_info_,
      fnd_user_               => fnd_user_,
      key_ref_                => key_ref_,
      sender_                 => sender_,
      message_type_           => message_type_,
      blob_info_              => blob_info_,
      receiver_               => receiver_,
      subject_                => subject_,
      in_order_               => in_order_,
      fail_notify_            => fail_notify_,
      failed_callback_fun_    => failed_callback_fun_,
      accepted_res_codes_     => accepted_res_codes_,
      auth_params_            => auth_params_,
      is_json_                => FALSE
   );
END Call_Rest_EndPoint___;

PROCEDURE Call_Rest_EndPoint___ (
   msg_payload_doc_        IN OUT Document,
   msg_payload_rec_        IN OUT type_record_,
   xml_                    IN     CLOB      DEFAULT NULL,
   json_                   IN OUT CLOB,
   message_id_             IN OUT NUMBER,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     CLOB,
   callback_func_          IN     VARCHAR2,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2,
   query_parameters_       IN     CLOB,
   header_params_          IN     CLOB,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2,
   key_ref_                IN     VARCHAR2,
   sender_                 IN     VARCHAR2,
   message_type_           IN     VARCHAR2,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2,
   subject_                IN     VARCHAR2,
   in_order_               IN     BOOLEAN,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     VARCHAR2 DEFAULT NULL,
   is_json_                IN     BOOLEAN  DEFAULT TRUE)
IS
   params_     Document := Plsqlap_Document_API.New_Document('PARAMETERS');
   para_clob_  CLOB;
   xml_clob_   CLOB := xml_;
BEGIN
   Plsqlap_Document_API.Add_Attribute(params_,'URL_PARAMS', url_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'CALLBACK_FUNC', callback_func_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_METHOD', http_method_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_REQ_HEADERS', http_req_headers_);
   IF blob_info_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'BLOB_INFO', blob_info_);
   END IF;
   Plsqlap_Document_API.Add_Attribute(params_,'QUERY_PARAMS', query_parameters_);
   Plsqlap_Document_API.Add_Attribute(params_,'FND_USER', fnd_user_ );
   Plsqlap_Document_API.Add_Attribute(params_,'KEY_REF', key_ref_);
   Plsqlap_Document_API.Add_Attribute(params_,'HEADER_PARAMS', header_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'INCLD_RESP_INFO', incld_resp_info_);

   IF fail_notify_ THEN
      Plsqlap_Document_API.Add_Attribute(params_,'FAIL_NOTIFY', fail_notify_);
      Plsqlap_Document_API.Add_Attribute(params_,'FAILED_CALLBACK_FUNC', failed_callback_fun_);
   END IF;

   IF accepted_res_codes_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'ACCEPTED_CODES', accepted_res_codes_);
   END IF;
   
   IF auth_params_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_, 'AUTH_PARAMS', Ins_Util_API.To_Base64(auth_params_));
   END IF;

   Plsqlap_Document_API.To_Ifs_Xml(para_clob_, params_);

   IF is_json_ THEN
      PLSQLAP_Server_API.Post_Outbound_Message (
         json_              => json_,
         message_id_        => message_id_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         message_type_      => message_type_,
         message_function_  => rest_service_,
         subject_           => subject_,
         in_order_          => in_order_,
         rest_              => TRUE,
         is_json_           => TRUE);
   -- TODO: msg_payload_rec_ must correspond to result of execution of rest_service_ BizAPI
   ELSIF xml_ IS NULL AND Plsqlap_Document_API.Get_Document_Name(msg_payload_doc_) = PLSQLAP_Server_API.DUMMY_DOC THEN
      PLSQLAP_Server_API.Post_Outbound_Message (
         message_body_      => msg_payload_rec_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         message_type_      => message_type_,
         message_function_  => rest_service_,
         subject_           => subject_,
         in_order_          => in_order_,
         rest_              => TRUE);
   ELSIF xml_ IS NULL THEN
      PLSQLAP_Server_API.Post_Outbound_Message (
         message_body_      => msg_payload_doc_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         message_type_      => message_type_,
         message_function_  => rest_service_,
         subject_           => subject_,
         in_order_          => in_order_,
         rest_              => TRUE);
   ELSE
      PLSQLAP_Server_API.Post_Outbound_Message (
         xml_               => xml_clob_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         message_type_      => message_type_,
         message_function_  => rest_service_,
         subject_           => subject_,
         in_order_          => in_order_,
         rest_              => TRUE);
   END IF;
END Call_Rest_EndPoint___;

PROCEDURE Call_Rest_EndPoint_Sync___(
   msg_payload_doc_        IN OUT Document,
   msg_payload_rec_        IN OUT type_record_,
   xml_                    IN OUT CLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     CLOB,
   callback_func_          IN     VARCHAR2,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2,
   query_parameters_       IN     CLOB,
   header_params_          IN     CLOB,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2,
   key_ref_                IN     VARCHAR2,
   sender_                 IN     VARCHAR2,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     VARCHAR2 DEFAULT NULL,
   is_json_                IN     BOOLEAN  DEFAULT FALSE)
IS
   params_     Document := Plsqlap_Document_API.New_Document('PARAMETERS');
   para_clob_  CLOB;
BEGIN
   Plsqlap_Document_API.Add_Attribute(params_,'URL_PARAMS', url_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'CALLBACK_FUNC', callback_func_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_METHOD', http_method_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_REQ_HEADERS', http_req_headers_);
   IF blob_info_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'BLOB_INFO', blob_info_);
   END IF;
   Plsqlap_Document_API.Add_Attribute(params_,'QUERY_PARAMS', query_parameters_);
   Plsqlap_Document_API.Add_Attribute(params_,'FND_USER', fnd_user_ );
   Plsqlap_Document_API.Add_Attribute(params_,'KEY_REF', key_ref_);
   Plsqlap_Document_API.Add_Attribute(params_,'HEADER_PARAMS', header_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'INCLD_RESP_INFO', incld_resp_info_);

   IF fail_notify_ THEN
      Plsqlap_Document_API.Add_Attribute(params_,'FAIL_NOTIFY', fail_notify_);
      Plsqlap_Document_API.Add_Attribute(params_,'FAILED_CALLBACK_FUNC', failed_callback_fun_);
   END IF;

   IF accepted_res_codes_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'ACCEPTED_CODES', accepted_res_codes_);
   END IF;
   
   IF auth_params_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'AUTH_PARAMS', Ins_Util_API.To_Base64(auth_params_));
   END IF;

   Plsqlap_Document_API.To_Ifs_Xml(para_clob_, params_);
   
   IF is_json_ THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         json_              => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         is_json_           => TRUE);
   ELSIF xml_ IS NULL AND Plsqlap_Document_API.Get_Document_Name(msg_payload_doc_) = PLSQLAP_Server_API.DUMMY_DOC AND msg_payload_rec_.name_ = PLSQLAP_Server_API.DUMMY_DOC THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         xml_               => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_);
   ELSIF xml_ IS NULL AND Plsqlap_Document_API.Get_Document_Name(msg_payload_doc_) = PLSQLAP_Server_API.DUMMY_DOC THEN
      Plsqlap_Server_API.Invoke_Outbound_Message(
         message_function_  => rest_service_,
         message_body_      => msg_payload_rec_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_);
   ELSIF xml_ IS NULL THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         message_body_      => msg_payload_doc_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_);
   ELSE
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         xml_               => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_);
   END IF;

END Call_Rest_EndPoint_Sync___;

--To get blob response
PROCEDURE Call_Rest_EndPoint_Sync___(
   msg_payload_doc_        IN     Document,
   msg_payload_rec_        IN     type_record_,
   xml_                    IN     CLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     CLOB,
   callback_func_          IN     VARCHAR2,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2,
   query_parameters_       IN     CLOB,
   header_params_          IN     CLOB,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2,
   key_ref_                IN     VARCHAR2,
   sender_                 IN     VARCHAR2,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     VARCHAR2 DEFAULT NULL,
   is_json_                IN     BOOLEAN  DEFAULT FALSE,
   binary_response_        OUT    BLOB)
IS
   params_     Document := Plsqlap_Document_API.New_Document('PARAMETERS');
   para_clob_  CLOB;
BEGIN
   Plsqlap_Document_API.Add_Attribute(params_,'URL_PARAMS', url_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'CALLBACK_FUNC', callback_func_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_METHOD', http_method_);
   Plsqlap_Document_API.Add_Attribute(params_,'HTTP_REQ_HEADERS', http_req_headers_);
   IF blob_info_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'BLOB_INFO', blob_info_);
   END IF;
   Plsqlap_Document_API.Add_Attribute(params_,'QUERY_PARAMS', query_parameters_);
   Plsqlap_Document_API.Add_Attribute(params_,'FND_USER', fnd_user_ );
   Plsqlap_Document_API.Add_Attribute(params_,'KEY_REF', key_ref_);
   Plsqlap_Document_API.Add_Attribute(params_,'HEADER_PARAMS', header_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'INCLD_RESP_INFO', incld_resp_info_);

   IF fail_notify_ THEN
      Plsqlap_Document_API.Add_Attribute(params_,'FAIL_NOTIFY', fail_notify_);
      Plsqlap_Document_API.Add_Attribute(params_,'FAILED_CALLBACK_FUNC', failed_callback_fun_);
   END IF;

   IF accepted_res_codes_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'ACCEPTED_CODES', accepted_res_codes_);
   END IF;
   
   IF auth_params_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(params_,'AUTH_PARAMS', Ins_Util_API.To_Base64(auth_params_));
   END IF;

   Plsqlap_Document_API.To_Ifs_Xml(para_clob_, params_);
   
   IF is_json_ THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         input_             => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         is_json_           => TRUE,
         binary_response_   => binary_response_);
   ELSIF xml_ IS NULL AND Plsqlap_Document_API.Get_Document_Name(msg_payload_doc_) = PLSQLAP_Server_API.DUMMY_DOC AND msg_payload_rec_.name_ = PLSQLAP_Server_API.DUMMY_DOC THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         input_             => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         is_json_           => FALSE,
         binary_response_   => binary_response_);
   ELSIF xml_ IS NULL AND Plsqlap_Document_API.Get_Document_Name(msg_payload_doc_) = PLSQLAP_Server_API.DUMMY_DOC THEN
      Plsqlap_Server_API.Invoke_Outbound_Message(
         message_function_  => rest_service_,
         message_body_      => msg_payload_rec_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         binary_response_   => binary_response_);
   ELSIF xml_ IS NULL THEN
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         message_body_      => msg_payload_doc_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         binary_response_   => binary_response_);

   ELSE
      PLSQLAP_Server_API.Invoke_Outbound_Message (
         message_function_  => rest_service_,
         input_             => xml_,
         parameters_        => para_clob_,
         sender_            => sender_,
         receiver_          => receiver_,
         is_json_           => FALSE,
         binary_response_   => binary_response_);
   END IF;

END Call_Rest_EndPoint_Sync___;

FUNCTION Doc_To_Xml___ (doc_ Document) RETURN CLOB
IS
   xml_ CLOB;
BEGIN
   IF Plsqlap_Document_API.Is_Initialized(doc_) THEN
      Plsqlap_Document_API.To_Ifs_Xml(xml_, doc_);
   END IF;
   RETURN xml_;
END Doc_To_Xml___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Value__ ( xml_     IN CLOB,
                     element_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      start_   NUMBER;
      end_     NUMBER;
   BEGIN
      start_ := dbms_lob.instr(xml_,element_) + LENGTH(element_);
      end_   := dbms_lob.instr(xml_,REPLACE(element_,'<','</'));
      RETURN(dbms_lob.substr(xml_, end_ - start_, start_));

   END Get_Value__;

FUNCTION REST_Common_Callback (xml_ CLOB) RETURN CLOB IS
   app_msg_id_ NUMBER;
   parameters_ CLOB;
   callback_fn_ VARCHAR2(500);
   plsql_block_  VARCHAR2(1000);
   fnd_user_  VARCHAR2(100);
   key_ref_ VARCHAR2(1000);
   inc_resp_code_ VARCHAR2(200);
   position1_     NUMBER;
   position2_     NUMBER;
   response_code_ VARCHAR2(32000);
   result_        CLOB;
   length_        VARCHAR2(32000);
   headers_       VARCHAR2(32000);
BEGIN
   app_msg_id_ := App_Context_SYS.Find_Number_Value('APPLICATION_MESSAGE_ID', 0);

   BEGIN
      SELECT t.parameters
      INTO   parameters_
      FROM   fndcn_message_body_tab t
      WHERE  t.application_message_id = app_msg_id_ AND t.seq_no=1;
   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Record_Not_Exist(Application_Message_API.lu_name_, p1_ => app_msg_id_);
      WHEN OTHERS THEN
         NULL;
   END;
   callback_fn_ := Get_Value__(parameters_,'<CALLBACK_FUNC>');
   fnd_user_  := Get_Value__(parameters_,'<FND_USER>');
   key_ref_ := Get_Value__(parameters_,'<KEY_REF>');
   inc_resp_code_ := Get_Value__(parameters_,'<INCLD_RESP_INFO>');

   IF (inc_resp_code_ IS NOT NULL AND inc_resp_code_='TRUE') THEN
   --get response code, body and headers if they are included
      position1_ := DBMS_LOB.instr(xml_,'#',1);
      position2_ := DBMS_LOB.instr(xml_,'#',position1_+1);
      response_code_ := DBMS_LOB.SUBSTR(xml_,position1_-1, 1);
      position2_ := DBMS_LOB.instr(xml_,'#',position1_+1);
      length_ := DBMS_LOB.SUBSTR(xml_, position2_-(position1_+1),position1_+1);
      DBMS_LOB.createtemporary(result_, true);
      result_ := TO_CLOB(DBMS_LOB.SUBSTR(xml_,TO_NUMBER(length_),position2_+1));
      headers_ := DBMS_LOB.SUBSTR(xml_,offset => position2_+TO_NUMBER(length_)+1);
   ELSE
      result_ := xml_;
   END IF;
   --BEGIN
   IF (inc_resp_code_ IS NOT NULL AND inc_resp_code_='TRUE') THEN
      IF key_ref_ IS NOT NULL THEN
         IF fnd_user_ IS NOT NULL THEN
            plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id, :fnd_user, :key_ref, :response_code,:headers); END;';
            @ApproveDynamicStatement(2018-08-13,xxx)
            EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_, fnd_user_, key_ref_, response_code_, headers_ ;
         ELSE
            plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id,:key_ref, :response_code,:headers); END;';
            @ApproveDynamicStatement(2018-07-29,xxx)
            EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_, key_ref_, response_code_, headers_ ;
         END IF;
      ELSE
         plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id, :response_code,:headers); END;';
         @ApproveDynamicStatement(2018-07-29,xxx)
         EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_ ,response_code_, headers_;
      END IF;
   ELSE
      IF key_ref_ IS NOT NULL THEN
         IF fnd_user_ IS NOT NULL THEN
            plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id, :fnd_user, :key_ref); END;';
            @ApproveDynamicStatement(2018-08-13,xxx)
            EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_, fnd_user_, key_ref_ ;
         ELSE
            plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id,:key_ref); END;';
            @ApproveDynamicStatement(2018-07-29,xxx)
            EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_, key_ref_ ;
         END IF;
      ELSE
         plsql_block_ := 'BEGIN '|| callback_fn_ || ' (:result, :app_msg_id ); END;';
         @ApproveDynamicStatement(2018-07-29,xxx)
         EXECUTE IMMEDIATE plsql_block_ USING result_, app_msg_id_ ;
      END IF;
   END IF;
   --END;
   RETURN result_;
END REST_Common_Callback;

PROCEDURE Call_Rest_EndPoint (
   rest_service_           IN     VARCHAR2,
   message_payload_        IN OUT type_record_,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2  DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL,
   sync_                   IN     BOOLEAN    DEFAULT FALSE)
IS
   dummy_doc_  Document := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   xml_ CLOB := NULL;
BEGIN
   IF (sync_ = FALSE) THEN
      Call_Rest_EndPoint___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => message_payload_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         message_type_     => message_type_,
         receiver_         => receiver_,
         subject_          => subject_,
         in_order_         => in_order_,
         fail_notify_       => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => PLSQLAP_Record_API.To_XML(auth_params_));
   ELSE
      Call_Rest_EndPoint_Sync___(
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => message_payload_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_       => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => PLSQLAP_Record_API.To_XML(auth_params_));
      END IF;

END Call_Rest_EndPoint;

PROCEDURE Call_Rest_EndPoint (
   rest_service_           IN     VARCHAR2,
   message_payload_        IN OUT Document,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN    VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL,
   sync_                   IN     BOOLEAN  DEFAULT FALSE)
IS
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
   xml_ CLOB := NULL;
BEGIN
   IF(sync_ = FALSE) THEN
      Call_Rest_EndPoint___ (
         msg_payload_doc_  => message_payload_,
         msg_payload_rec_  => dummy_rec_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_ ,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         message_type_     => message_type_,
         receiver_         => receiver_,
         subject_          => subject_,
         in_order_         => in_order_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_));
   ELSE
      Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => message_payload_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_ ,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_));
   END IF;
END Call_Rest_EndPoint;

-- Overloaded methods to get binary response
PROCEDURE Call_Rest_EndPoint (
   rest_service_           IN     VARCHAR2,
   message_payload_        IN     type_record_,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2  DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL,
   binary_response_        OUT    BLOB)
IS
   dummy_doc_  Document := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   xml_ CLOB := NULL;
BEGIN

   Call_Rest_EndPoint_Sync___(
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => message_payload_,
      xml_              => xml_,
      rest_service_     => rest_service_,
      url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
      header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
      incld_resp_info_  => incld_resp_info_,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      receiver_         => receiver_,
      fail_notify_       => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_         => PLSQLAP_Record_API.To_XML(auth_params_),
      binary_response_     => binary_response_);
END Call_Rest_EndPoint;

PROCEDURE Call_Rest_EndPoint (
   rest_service_           IN     VARCHAR2,
   message_payload_        IN     Document,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN    VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL,
   binary_response_        OUT    BLOB)
IS
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
   xml_ CLOB := NULL;
BEGIN  
   Call_Rest_EndPoint_Sync___ (
      msg_payload_doc_  => message_payload_,
      msg_payload_rec_  => dummy_rec_,
      xml_              => xml_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      receiver_         => receiver_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_         => Doc_To_Xml___(auth_params_),
      binary_response_     => binary_response_);
END Call_Rest_EndPoint;

PROCEDURE Call_Rest_EndPoint (
   rest_service_           IN     VARCHAR2,
   xml_                    IN     CLOB,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         message_type_     => message_type_,
         receiver_         => receiver_,
         subject_          => subject_,
         in_order_         => in_order_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => PLSQLAP_Record_API.To_XML(auth_params_));
   END Call_Rest_EndPoint;

   PROCEDURE Call_Rest_EndPoint1 (
   rest_service_           IN     VARCHAR2,
   xml_                    IN OUT CLOB,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'CONNECT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_        => PLSQLAP_Record_API.To_XML(auth_params_));
END Call_Rest_EndPoint1;

--Overloaded method to get binary response 
PROCEDURE Call_Rest_EndPoint1 (
   rest_service_           IN     VARCHAR2,
   xml_                    IN     CLOB,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'CONNECT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL,
   binary_response_        OUT    BLOB)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_        => PLSQLAP_Record_API.To_XML(auth_params_),
         binary_response_     => binary_response_);
END Call_Rest_EndPoint1;

PROCEDURE Call_Rest_EndPoint2 (
   rest_service_           IN     VARCHAR2,
   xml_                    IN     CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      xml_              => xml_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      message_type_     => message_type_,
      receiver_         => receiver_,
      subject_          => subject_,
      in_order_         => in_order_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_         => Doc_To_Xml___(auth_params_));
END Call_Rest_EndPoint2;

PROCEDURE Call_Rest_EndPoint3 (
   rest_service_           IN     VARCHAR2,
   xml_                    IN OUT CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'CONNECT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_));
END Call_Rest_EndPoint3;

-- Overloaded method to get Binary Response
PROCEDURE Call_Rest_EndPoint3 (
   rest_service_           IN     VARCHAR2,
   xml_                    IN     CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'CONNECT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL,
   binary_response_        OUT    BLOB)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_),
         binary_response_     => binary_response_);
END Call_Rest_EndPoint3;

PROCEDURE Call_Rest_EndPoint_Json (
   rest_service_           IN     VARCHAR2,
   json_                   IN OUT CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
   message_id_ NUMBER;
BEGIN
   Call_Rest_EndPoint___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      json_             => json_,
      message_id_       => message_id_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      message_type_     => message_type_,
      receiver_         => receiver_,
      subject_          => subject_,
      in_order_         => in_order_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_         => Doc_To_Xml___(auth_params_),
      is_json_             => TRUE);
END Call_Rest_EndPoint_Json;

PROCEDURE Call_Rest_EndPoint_Json (
   rest_service_           IN     VARCHAR2,
   json_                   IN OUT CLOB,
   message_id_             IN OUT NUMBER,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      json_             => json_,
      message_id_       => message_id_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      message_type_     => message_type_,
      receiver_         => receiver_,
      subject_          => subject_,
      in_order_         => in_order_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_         => Doc_To_Xml___(auth_params_),
      is_json_             => TRUE);
END Call_Rest_EndPoint_Json;

PROCEDURE Call_Rest_EndPoint_Json_Sync (
   rest_service_           IN     VARCHAR2,
   json_                   IN OUT CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => json_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         blob_info_        => NULL,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_),
         is_json_             => TRUE);
END Call_Rest_EndPoint_Json_Sync;

--Overloaded method to get Binary response
PROCEDURE Call_Rest_EndPoint_Json_Sync (
   rest_service_           IN     VARCHAR2,
   json_                   IN     CLOB,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_           IN     VARCHAR2 DEFAULT 'EVENT',
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL,
   binary_response_        OUT    BLOB)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => json_,
         rest_service_     => rest_service_,
         url_params_       => Doc_To_Xml___(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => Doc_To_Xml___(query_parameters_),
         header_params_    => Doc_To_Xml___(header_params_),
         incld_resp_info_  => incld_resp_info_,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         blob_info_        => NULL,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => Doc_To_Xml___(auth_params_),
         is_json_             => TRUE,
         binary_response_     => binary_response_);
END Call_Rest_EndPoint_Json_Sync;

PROCEDURE Call_Rest_EndPoint_Empty_Body (
   rest_service_           IN     VARCHAR2,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      rest_service_     => rest_service_,
      url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
      header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      message_type_     => 'EVENT',
      blob_info_        => blob_info_,
      receiver_         => receiver_,
      subject_          => subject_,
      in_order_         => in_order_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_        => PLSQLAP_Record_API.To_XML(auth_params_));
END Call_Rest_EndPoint_Empty_Body;

PROCEDURE Call_Rest_EndPoint_Empty_Body2 (
   rest_service_           IN     VARCHAR2,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   Call_Rest_EndPoint___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      message_type_     => 'EVENT',
      blob_info_        => blob_info_,
      receiver_         => receiver_,
      subject_          => subject_,
      in_order_         => in_order_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_        => Doc_To_Xml___(auth_params_));
END Call_Rest_EndPoint_Empty_Body2;

PROCEDURE Call_Rest_EP_Empty_Body_Sync (
   xml_                    OUT    CLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
      xml_ := NULL;
      Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_ ,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         blob_info_        => blob_info_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_   => accepted_res_codes_,
         auth_params_        => PLSQLAP_Record_API.To_XML(auth_params_));
END Call_Rest_EP_Empty_Body_Sync;

--Overloaded methpd to get binary response
PROCEDURE Call_Rest_EP_Empty_Body_Sync (
   response_               OUT    BLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     type_record_ DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     type_record_ DEFAULT NULL,
   header_params_          IN     type_record_ DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     type_record_ DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
   xml_  CLOB              := NULL;
BEGIN
      Call_Rest_EndPoint_Sync___ (
         msg_payload_doc_  => dummy_doc_,
         msg_payload_rec_  => dummy_rec_,
         xml_              => xml_,
         rest_service_     => rest_service_,
         url_params_       => PLSQLAP_Record_API.To_XML(url_params_),
         callback_func_    => callback_func_,
         http_method_      => http_method_,
         http_req_headers_ => http_req_headers_,
         query_parameters_ => PLSQLAP_Record_API.To_XML(query_parameters_),
         header_params_    => PLSQLAP_Record_API.To_XML(header_params_),
         incld_resp_info_  => incld_resp_info_ ,
         fnd_user_         => fnd_user_,
         key_ref_          => key_ref_,
         sender_           => sender_,
         blob_info_        => blob_info_,
         receiver_         => receiver_,
         fail_notify_      => fail_notify_,
         failed_callback_fun_ => failed_callback_fun_,
         accepted_res_codes_  => accepted_res_codes_,
         auth_params_         => PLSQLAP_Record_API.To_XML(auth_params_),
         binary_response_     => response_);
END Call_Rest_EP_Empty_Body_Sync;

PROCEDURE Call_Rest_EP_Empty_Body_Sync2 (
   xml_                    OUT    CLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
BEGIN
   xml_ := NULL;
   Call_Rest_EndPoint_Sync___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      xml_             => xml_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      blob_info_        => blob_info_,
      receiver_         => receiver_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_        => Doc_To_Xml___(auth_params_));
END Call_Rest_EP_Empty_Body_Sync2;

-- Overloaded method to get Binary Response
PROCEDURE Call_Rest_EP_Empty_Body_Sync2 (
   response_               OUT    BLOB,
   rest_service_           IN     VARCHAR2,
   url_params_             IN     Document DEFAULT NULL,
   callback_func_          IN     VARCHAR2 DEFAULT NULL,
   http_method_            IN     VARCHAR2,
   http_req_headers_       IN     VARCHAR2 DEFAULT NULL,
   query_parameters_       IN     Document DEFAULT NULL,
   header_params_          IN     Document DEFAULT NULL,
   incld_resp_info_        IN     BOOLEAN DEFAULT NULL,
   fnd_user_               IN     VARCHAR2 DEFAULT NULL,
   key_ref_                IN     VARCHAR2 DEFAULT NULL,
   blob_info_              IN     VARCHAR2 DEFAULT NULL,
   sender_                 IN     VARCHAR2 DEFAULT NULL,
   receiver_               IN     VARCHAR2 DEFAULT default_recevier_,
   subject_                IN     VARCHAR2 DEFAULT NULL,
   in_order_               IN     BOOLEAN  DEFAULT FALSE,
   fail_notify_            IN     BOOLEAN  DEFAULT FALSE,
   failed_callback_fun_    IN     VARCHAR2 DEFAULT NULL,
   accepted_res_codes_     IN     VARCHAR2 DEFAULT NULL,
   auth_params_            IN     Document DEFAULT NULL)
IS
   dummy_doc_  Document     := Plsqlap_Document_API.New_Document(PLSQLAP_Server_API.DUMMY_DOC);
   dummy_rec_  type_record_ := PLSQLAP_Record_API.New_Record(PLSQLAP_Server_API.DUMMY_DOC);
   xml_ CLOB                := NULL;
BEGIN
   Call_Rest_EndPoint_Sync___ (
      msg_payload_doc_  => dummy_doc_,
      msg_payload_rec_  => dummy_rec_,
      xml_             => xml_,
      rest_service_     => rest_service_,
      url_params_       => Doc_To_Xml___(url_params_),
      callback_func_    => callback_func_,
      http_method_      => http_method_,
      http_req_headers_ => http_req_headers_,
      query_parameters_ => Doc_To_Xml___(query_parameters_),
      header_params_    => Doc_To_Xml___(header_params_),
      incld_resp_info_  => incld_resp_info_ ,
      fnd_user_         => fnd_user_,
      key_ref_          => key_ref_,
      sender_           => sender_,
      blob_info_        => blob_info_,
      receiver_         => receiver_,
      fail_notify_      => fail_notify_,
      failed_callback_fun_ => failed_callback_fun_,
      accepted_res_codes_  => accepted_res_codes_,
      auth_params_        => Doc_To_Xml___(auth_params_),
      binary_response_     => response_);
END Call_Rest_EP_Empty_Body_Sync2;


FUNCTION Create_Blob_Item (
   path_           IN VARCHAR2,
   file_name_      IN VARCHAR2) RETURN BLOB
IS
   blob_item_           BLOB;
   dest_offset_         NUMBER := 1;
   src_offset_          NUMBER := 1;
   directory_           VARCHAR2(100);
   bfile_               BFILE;

BEGIN
   directory_ := 'CREATE OR REPLACE DIRECTORY file_dir AS ' || '''' || path_ || '''';
   @ApproveDynamicStatement(2018-07-10,udlelk)
   EXECUTE IMMEDIATE(directory_);

   bfile_ := BFILENAME('FILE_DIR', file_name_);

   DBMS_LOB.createtemporary(lob_loc => blob_item_, cache => true, dur => dbms_lob.call);
   DBMS_LOB.open(bfile_, DBMS_LOB.lob_readonly);

   DBMS_LOB.loadblobfromfile(dest_lob    => blob_item_,
                             src_bfile   => bfile_,
                             amount      => DBMS_LOB.lobmaxsize,
                             dest_offset => dest_offset_,
                             src_offset  => src_offset_);

   DBMS_LOB.close(bfile_);

   RETURN blob_item_;
END Create_Blob_Item;


PROCEDURE Get_Blob_Item(
   table_name_    IN    VARCHAR2,
   blob_field_    IN    VARCHAR2,
   key_field_     IN    VARCHAR2,
   key_value_     IN    VARCHAR2,
   blob_value_    OUT   BLOB)
IS
   sql_string_      VARCHAR2(4000);
BEGIN
   sql_string_ := 'SELECT '|| blob_field_ ||' FROM '|| table_name_ ||' WHERE ' || key_field_ || ' = ''' || key_value_ ||'''';

      @ApproveDynamicStatement(2018-07-11,UDLELK)
      EXECUTE IMMEDIATE sql_string_ INTO blob_value_;

END Get_Blob_Item;

-------------------- LU  NEW METHODS -------------------------------------
