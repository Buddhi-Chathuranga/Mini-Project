-----------------------------------------------------------------------------
--
--  Logical unit: PlsqlapServer
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000710  JhMa    Created
--  000803  ToBa    Changed module name to PLAP
--  000823  JhMa    Added support for Application Context
--  001026  JhMa    Added FND_CONTEXT to __HEADER with DOMAIN and LANGUAGE
--  010102  JhMa    Corrected bug in __HEADER
--  010425  JhMa    ToDo #717 - Changed to support new CORBA interface
--  010516  Ranase  Added Invoke_Record and Replace_Record_Buffer
--  010820  ROOD    Changed module to FNDSER (ToDo#4021).
--  011003  ROOD    Removed methods for corba connection (ToDo4021).
--  011025  ROOD    Changed default values in Create_Connectivity_Message (ToDo#4021).
--  020212  JHMA    Modifications to comply with latest Connect framework (ToDo#4069).
--  020221  JhMaSe  ToDo #1758 - DLL replaced by Java
--  020409  JHMA    DLL replaced by Java (ToDo#4105).
--  020802  JhMaSe  Adapt USER credentials to ApplicationServer design
--  020829  DaJoSe  Added functions Invoke_Message, Post_Message, Invoke_Outbound_Request_BizAPI, Post_Outbound_BizAPI
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030313  HEDSJE  Updated for Fndext 3.0.0
--  030525  JhMaSe  ToDo# 3779 Table PLSQLAP_BUFFER_TMP replaced by Foundation1
--                  buffers in OUT_MESSAGE_RAW_TAB.
--  030917  JhMaSe  LOMG RAW (OUT_MESSAGE_RAW_TAB) replace by CLOB (OUT_MESSAGE_CLOB_TAB)
--  031005  ROOD    Merged changes earlier made only in FNDAS (DaJo 020829 and JhMa 020802).
--  031008  JHMASE  Publish Set_Trusted_Credentials and Set_Trusted_Mode
--  040114  BAMALK  Removed the constant app_ower_ and modified the constant fnd_user_. (Bug#42054)
--  040219  jhmase  Bug #42591
--  040312  HAAR    Renamed table Plsqlap_Environment to Plsqlap_Environment_Tab (Bug#42591).
--  040317  jhmase  New timestamp
--  040812  HAAR    Chenged Invoke_Buffer error handling to never return more than 255 characters.
--  050209  DOZE    Rewrite for web services (F1PR477)
--  050309  HAAR    Added method security (F1PR477).
--  050228  jhmase  Bug #49898 - N/A
--  050929  jhmase  Bug #53677 - Clear record after loading Connectivity Outbox
--  051201  henjse  Overloaded procedure Post_Outbound_BizAPI (F1PR480)
--  051212  DOZE    Split Invoke_rekord into Invoke_Record_ Invoke_Record_Impersonate and Invoke_Record_Authorize
--  061107  PEMASE  https:// support (Bug# 59929)
--  061212  pemase  Limit PLSQL_BUFFER_TMP resource utilization. (Bug #61975)
--  061114  UTGULK  Added methods Create_Application_Message__(),Find_Queue(),Post_Event_Message()
--                  Removed Create_Connectivity_Message, Create_Message_Lines___.Modified Post_Message and Post_Outbound_Bizapi.(Bug#58694).
--  070327  PEMA    Bug 64444, Making persistent connections configurable.
--  070614  JaPase  Bug 66008, Added nvl call in Find_Queue
--  081013  JHMASE  Bug #77879 - Possibility to send XML in CLOB with Plsql Access Provider
--  091201  JHMASE  Bug #87478 - Clear record after creating ApplicationMessage
--  100420  HAAR    Ping_Result__ always shows FALSE (Bug#90151).
--  101125  JHMASE  Bug #94560 - Timeout parameter added
--  110208  JHMASE  Bug #95691 - Timeout parameter passed correctly
--  110917  NaBaLK  Added Byte Order Mark at the beginning of the message text before converting to BLOB. (RDTERUNTIME-750)
--  120327  JHMASE  Bug #101947 - Subject parameter added to Post_Outbound_BizAPI
--  121126  JHMASE Bug #106950 - Correct Queue is not returned by Plsqlap_Server_API.Find_Queue
--  130107  JHMASE Bug #107673 - Correct Queue is not returned by Plsqlap_Server_API.Find_Queue
--  130131  JHMASE Bug #108134 - Correct Queue is not returned by Plsqlap_Server_API.Find_Queu
--  170214  UdLeLK   Users need to change MAIL_SENDER in email event actions (Bug#134162)
--  170620  JAPASE  TEJSL-1039 - Refactored. Added Invoke* methods taking CLOB.
--  181020  JAPASE  PACDATA-44 - Added support for Documents.
--  181115  JAPASE  PACDATA-158 - Refactored, new way of invoking.
--  190716  NADRSE PACZDATA-588 - Notify chosen connect node about released Invoke application message
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

default_recevier_   CONSTANT VARCHAR2(100) := 'CONNECT';
default_class_id_   CONSTANT VARCHAR2(100) := 'CONNECT_MSG';
default_media_code_ CONSTANT VARCHAR2(100) := 'CONNECT';
error_queue_        CONSTANT VARCHAR2(100) := 'ERROR';

DUMMY_DOC           CONSTANT VARCHAR2(10) := '__DUMMY__';

SUBTYPE type_interface_            IS VARCHAR2(255);
SUBTYPE type_method_               IS VARCHAR2(255);
SUBTYPE type_object_name_          IS VARCHAR2(255);
SUBTYPE type_host_name_            IS VARCHAR2(255);
SUBTYPE type_connection_string_    IS VARCHAR2(255);
SUBTYPE type_trace_file_           IS VARCHAR2(255);
SUBTYPE type_buffer_               IS PLSQLAP_BUFFER_TMP.buffer%TYPE;
SUBTYPE type_record_               IS Plsqlap_Record_API.type_record_;
SUBTYPE type_item_record_          IS Plsqlap_Record_API.type_item_record_;
SUBTYPE type_appmsg_record_        IS fndcn_application_message_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

INVOKE_REC        CONSTANT NUMBER := 1;
INVOKE_DOC        CONSTANT NUMBER := 2;
INVOKE_XML        CONSTANT NUMBER := 3;
INVOKE_IMPERS     CONSTANT NUMBER := 4;
INVOKE_JSON       CONSTANT NUMBER := 5;

INVOKE_QUEUE      CONSTANT VARCHAR2(30) := 'DEFAULT';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Find_Queue___ (
   message_function_  IN VARCHAR2,
   message_type_      IN VARCHAR2,
   receiver_          IN VARCHAR2,
   sender_            IN VARCHAR2,
   in_order_          IN BOOLEAN,
   cond_id_           OUT VARCHAR2,
   candidates_        OUT VARCHAR2 ) RETURN VARCHAR2
IS
   -- impl, called from Create_Application_Message___
   CURSOR c_condition_ (search_path_ VARCHAR2, match_query_expr_ VARCHAR2) IS
      WITH
         matching_condition_parts as (
            SELECT A.rule_name,
                   count(A.rule_name)    matched_conditions,
                   min(B.queue)          queue
              FROM routing_rule_condition_tab A,
                   routing_rule_tab B
             WHERE B.direction  = 'Outbound'
               AND B.route_type = 'APPLICATION_MESSAGE'
               AND B.enabled    = 1
               AND B.queue      IS NOT NULL
               AND A.rule_name  = B.rule_name
               AND ( ( -- simplified routing
                       search_path_ IS NOT NULL
                       AND A.match_query_expr = match_query_expr_
                       AND A.search_path      = search_path_
                       AND A.op               = '='
                     )
                     OR
                     ( -- full routing
                       A.search_path = 'MESSAGE_FUNCTION'
                       AND (  A.op = '='  AND A.match_query_expr  = message_function_
                           OR A.op = '!=' AND A.match_query_expr != nvl(message_function_,'-999999999999999')
                           OR A.op = 'sw' AND message_function_ LIKE A.match_query_expr||'%'
                           OR A.op = 'ew' AND message_function_ LIKE '%'||A.match_query_expr
                           )
                       OR
                       A.search_path = 'MESSAGE_TYPE'
                       AND (  A.op = '='  AND A.match_query_expr  = message_type_
                           OR A.op = '!=' AND A.match_query_expr != nvl(message_type_,'-999999999999999')
                           OR A.op = 'sw' AND message_type_ LIKE A.match_query_expr||'%'
                           OR A.op = 'ew' AND message_type_ LIKE '%'||A.match_query_expr
                           )
                       OR
                       A.search_path = 'SENDER'
                       AND (  A.op = '='  AND A.match_query_expr  = sender_
                           OR A.op = '!=' AND A.match_query_expr != nvl(sender_,'-999999999999999')
                           OR A.op = 'sw' AND sender_ LIKE A.match_query_expr||'%'
                           OR A.op = 'ew' AND sender_ LIKE '%'||A.match_query_expr
                           )
                       OR
                       A.search_path = 'RECEIVER'
                       AND (  A.op = '='  AND A.match_query_expr  = receiver_
                           OR A.op = '!=' AND A.match_query_expr != nvl(receiver_,'-999999999999999')
                           OR A.op = 'sw' AND receiver_ LIKE A.match_query_expr||'%'
                           OR A.op = 'ew' AND receiver_ LIKE '%'||A.match_query_expr
                           )
                     )
                   )
             GROUP BY A.rule_name
         ),
         all_condition_parts as (
            SELECT Y.rule_name,
                   min(X.matched_conditions)                                                                  matched_conditions,
                   count(Y.rule_name)                                                                         all_conditions,
                   sum(decode(Y.search_path,'MESSAGE_FUNCTION',1,'MESSAGE_TYPE',1,'SENDER',1,'RECEIVER',1,0)) appmsg_conditions,
                   sum(decode(Y.search_path,'MESSAGE_FUNCTION',0,'MESSAGE_TYPE',0,'SENDER',0,'RECEIVER',0,1)) content_based,
                   min(X.queue)                                                                               queue
              FROM routing_rule_condition_tab Y,
                   matching_condition_parts X
             WHERE Y.rule_name = X.rule_name
             GROUP BY Y.rule_name
         )
         SELECT * FROM all_condition_parts
          WHERE matched_conditions = appmsg_conditions
          ORDER BY all_conditions DESC, rule_name ASC;

   TYPE conditions_table_ IS TABLE OF c_condition_%ROWTYPE;
   TYPE queue_set_        IS TABLE OF BOOLEAN INDEX BY routing_rule_tab.queue%TYPE;

   simpl_search_path_       VARCHAR2(250);
   simpl_match_query_expr_  VARCHAR2(250) := NULL;
   max_cont_only_cond_cnt_  NUMBER := 0;
   conditions_              conditions_table_;
   queues_                  queue_set_;
   queue_                   routing_rule_tab.queue%TYPE;

   FUNCTION Get_Simplified_Routing_Attr RETURN VARCHAR2 IS
      CURSOR c_route_attr_ IS
         SELECT upper(parameter_value) parameter_value
           FROM config_instance_param_tab
          WHERE group_name       = 'Routing'
            AND instance_name    = 'OUTBOUND'
            AND parameter_name   = 'ATTRIBUTE'
            AND lower(parameter_value) != 'none';
   BEGIN
      FOR rec_ IN c_route_attr_ LOOP
         RETURN rec_.parameter_value;
      END LOOP;
      RETURN NULL;
   END Get_Simplified_Routing_Attr;

   FUNCTION Get_Simpl_Query_Expr (search_path_ IN VARCHAR2 ) RETURN VARCHAR2 IS
   BEGIN
      CASE search_path_
         WHEN 'MESSAGE_FUNCTION' THEN RETURN message_function_;
         WHEN 'MESSAGE_TYPE'     THEN RETURN message_type_;
         WHEN 'RECEIVER'         THEN RETURN receiver_;
         WHEN 'SENDER'           THEN RETURN sender_;
         ELSE RETURN NULL;
      END CASE;
   END Get_Simpl_Query_Expr;

   PROCEDURE Check_Config_Consistency IS
      cnt_ NUMBER;
   BEGIN
      SELECT count(*)
        INTO cnt_
        FROM routing_rule_tab R, config_instance_param_tab Q
       WHERE R.direction    = 'Outbound'
         AND R.route_type   = 'APPLICATION_MESSAGE'
         AND R.enabled = 1
         AND Q.group_name = 'MessageQueues'
         AND Q.instance_name = R.queue
         AND Q.parameter_name = 'EXECUTION_MODE'
         AND lower(Q.parameter_value) = 'inorder'
         AND NOT EXISTS
           ( SELECT NULL
               FROM routing_rule_condition_tab C
              WHERE C.rule_name   = R.rule_name
                AND C.search_path IN ('MESSAGE_FUNCTION','MESSAGE_TYPE','SENDER','RECEIVER')
           );
         IF cnt_ > 0 THEN
            Error_SYS.Appl_General(lu_name_, 'INORDERCONF: Inconsistent configuration: there are InOrder rules that don''t define any of MESSAGE_FUNCTION, MESSAGE_TYPE, SENDER or RECEIVER');
         END IF;
   END Check_Config_Consistency;

   FUNCTION Get_Content_Only_Cond_Cnt RETURN NUMBER IS
      cnt_ NUMBER;
   BEGIN
      SELECT nvl(max(count(R.rule_name)),0)
        INTO cnt_
        FROM routing_rule_tab R,
             routing_rule_condition_tab P
       WHERE R.direction  = 'Outbound'
         AND R.route_type = 'APPLICATION_MESSAGE'
         AND R.enabled    = 1
         AND R.queue      IS NOT NULL
         AND P.rule_name  = R.rule_name
         AND NOT EXISTS
           ( SELECT NULL
               FROM routing_rule_condition_tab C
              WHERE C.rule_name   = R.rule_name
                AND C.search_path IN ('MESSAGE_FUNCTION','MESSAGE_TYPE','SENDER','RECEIVER')
           )
       GROUP BY R.rule_name;
      RETURN cnt_;
   END Get_Content_Only_Cond_Cnt;

   FUNCTION Is_In_Order (queue_ IN VARCHAR2) RETURN BOOLEAN IS
      execution_mode_ config_instance_param_tab.parameter_value%TYPE;
   BEGIN
      IF queue_ = 'UNROUTED' THEN
         RETURN FALSE;
      END IF;
      SELECT lower(parameter_value)
        INTO execution_mode_
        FROM config_instance_param_tab
       WHERE group_name = 'MessageQueues'
         AND instance_name = queue_
         AND parameter_name = 'EXECUTION_MODE';
      RETURN execution_mode_ = 'inorder';
   END Is_In_Order;

   FUNCTION Check_In_Order (queue_ IN VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      IF in_order_ AND NOT Is_In_Order(queue_) THEN
         Error_SYS.Appl_General(lu_name_, 'INORDERQUEUE1: Expecting InOrder queue, but the found one is not.');
      ELSE
         RETURN queue_;
      END IF;
   END Check_In_Order;

BEGIN
   -- check simplified routing and consistency
   simpl_search_path_ := Get_Simplified_Routing_Attr;
   IF simpl_search_path_ IS NOT NULL THEN
      simpl_match_query_expr_ := Get_Simpl_Query_Expr(simpl_search_path_);
   ELSIF in_order_ THEN
      Check_Config_Consistency; -- check if configuration data is consistent
   ELSIF message_function_ <> 'EVENT_MSG' THEN
      max_cont_only_cond_cnt_ := Get_Content_Only_Cond_Cnt;
   END IF;

   -- fetch all rules with the four Application Message conditions satisfying the input data
   OPEN c_condition_(simpl_search_path_, simpl_match_query_expr_);
   FETCH c_condition_
   BULK COLLECT INTO conditions_;
   CLOSE c_condition_;

   -- no rules matching the message
   IF conditions_.count = 0 THEN
      IF in_order_ THEN
         Error_SYS.Appl_General(lu_name_, 'INORDERQUEUE2: Expecting InOrder queue, but could not find any');
      ELSIF message_function_ = 'EVENT_MSG' THEN
         RETURN 'NOTIFICATIONS';
      ELSIF max_cont_only_cond_cnt_ > 0 THEN
         RETURN 'UNROUTED'; -- just return UNROUTED if there exist rules without the four AppMsg attributes
      ELSE
         RETURN 'ERROR'; -- there are no rules that may satisfy the message
      END IF;
   END IF;

   -- rules are sorted according to the total number of conditions and description
   -- if the first rule doesn't have any other content based conditions and there are no other rules with more conditions then this is the one
   -- even if the second rule has the same number of conditions, the first one is better due to alphabetical ordering of description
   FOR i_ IN 1..conditions_.count LOOP
      IF i_ = 1 AND conditions_(i_).content_based = 0 AND conditions_(i_).all_conditions > max_cont_only_cond_cnt_ THEN
         cond_id_ := conditions_(i_).rule_name;
         RETURN Check_In_Order(conditions_(i_).queue); -- this is our rule - just return it
      END IF;
      -- just a candidate
      -- add the queue name to the set, but if there are other rules without the four AppMsg attributes we must set queue to UNROUTED
      queues_(CASE max_cont_only_cond_cnt_ WHEN 0 THEN conditions_(i_).queue ELSE 'UNROUTED' END) := TRUE; -- add the queue name to the set
      -- hints are only valid if there are no other rules without the four AppMsg attributes
      -- but we want to limit number of hints (10)
      IF max_cont_only_cond_cnt_ = 0 AND (i_ = 1 OR candidates_ IS NOT NULL) THEN
         candidates_ := CASE length(candidates_) + length(conditions_(i_).rule_name) > 4000
                           WHEN TRUE THEN NULL
                           ELSE candidates_ || conditions_(i_).rule_name || ','
                        END;
      END IF;
   END LOOP;

   -- analyze queues defined by found candidates
   queue_ := queues_.first;
   IF queues_.count = 1 THEN
      RETURN Check_In_Order(queue_); -- all found rules defined on the same queue - just return it.
   END IF;

   -- several queues found
   IF in_order_ THEN
      Error_SYS.Appl_General(lu_name_, 'INORDERQUEUE3: Expecting InOrder queue, but found several');
   END IF;

   WHILE queue_ IS NOT NULL LOOP
      IF Is_In_Order(queue_) THEN
         Error_SYS.Appl_General(lu_name_, 'INORDERQUEUE4: Several queues found; some are InOrder.');
      END IF;
      queue_ := queues_.next(queue_);
   END LOOP;

   RETURN CASE message_function_ WHEN 'EVENT_MSG' THEN 'NOTIFICATIONS' ELSE 'UNROUTED' END;
END Find_Queue___;


PROCEDURE Create_Application_Message___ (
   message_id_          IN OUT NUMBER,
   document_            IN     Plsqlap_Document_API.Document,
   sender_              IN     VARCHAR2,
   receiver_            IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_        IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_    IN     VARCHAR2 DEFAULT default_class_id_,
   subject_             IN     VARCHAR2 DEFAULT NULL,
   xml_                 IN     CLOB     DEFAULT NULL,
   external_message_id_ IN     VARCHAR2 DEFAULT NULL,
   in_order_            IN     BOOLEAN  DEFAULT FALSE,
   parameters_          IN     CLOB     DEFAULT NULL,
   rest_                IN     BOOLEAN  DEFAULT FALSE,
   invoke_timeout_      IN     NUMBER   DEFAULT NULL,
   run_as_              IN     VARCHAR2 DEFAULT NULL,
   is_json_             IN     BOOLEAN  DEFAULT FALSE)
IS
   queue_                  VARCHAR2(200);
   app_msg_rec_            fndcn_application_message_tab%ROWTYPE;
   addr_label_rec_         fndcn_address_label_tab%ROWTYPE;
   msg_body_rec_           fndcn_message_body_tab%ROWTYPE;
   message_action_         VARCHAR2(100);
   condition_id_           VARCHAR2(200);
   candidates_             VARCHAR2(4500);
   is_app_msg_rec_         BOOLEAN;
   doc_name_               VARCHAR2(4000) := Plsqlap_Document_API.Get_Document_Name(document_);
   invoke_                 BOOLEAN := invoke_timeout_ IS NOT NULL;
   invoke_method_          BOOLEAN := invoke_ AND instr(message_function_, ':') > 1; -- Invoke_Record_Impersonate, Invoke_Record_

   FUNCTION Get_Attribute_Value (name_ VARCHAR2) RETURN VARCHAR2 IS
      id_ Plsqlap_Document_API.Element_Id := Plsqlap_Document_API.Find_Element_Id(document_, name_);
   BEGIN
      RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE Plsqlap_Document_API.Get_Value(document_, id_) END;
   END;

   FUNCTION Get_Default_Sender RETURN VARCHAR2 IS
      default_sender_  VARCHAR2(200);
      dummy_           VARCHAR2(200);
   BEGIN
      Database_SYS.Get_Database_Properties(default_sender_, dummy_, dummy_);
      RETURN default_sender_;
   END;

   PROCEDURE Create_App_Msg_Rec IS
   BEGIN
      IF nvl(message_id_, 0) = 0 THEN
         SELECT fndcn_message_seq.NEXTVAL
         INTO   message_id_
         FROM   dual;
      END IF;

      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Creating APPLICATION_MESSAGE with ID ['||message_id_||']');
      app_msg_rec_.rowversion             := 1;
      app_msg_rec_.created_by             := Fnd_Session_API.Get_Fnd_User;
      app_msg_rec_.created_date           := SYSDATE;
      app_msg_rec_.created_timestamp      := SYSTIMESTAMP;
      app_msg_rec_.application_message_id := message_id_;
      app_msg_rec_.seq_no                 := message_id_;
      app_msg_rec_.state                  := CASE queue_ WHEN error_queue_ THEN 'Failed' ELSE 'Released' END;
      app_msg_rec_.state_date             := SYSDATE;
      app_msg_rec_.subject                := nvl(app_msg_rec_.subject, 'Message from Plsql Access Provider');
      app_msg_rec_.external_message_id    := nvl(app_msg_rec_.external_message_id, sys_guid());
      app_msg_rec_.queue                  := queue_;
      app_msg_rec_.route_rule_seq         := condition_id_;
      app_msg_rec_.route_rule_candidates  := candidates_;
      app_msg_rec_.error_text             := CASE queue_ WHEN error_queue_ THEN 'No valid routing rule found' ELSE NULL END;
      app_msg_rec_.invoke_timeout         := invoke_timeout_;
      INSERT INTO fndcn_application_message_tab VALUES app_msg_rec_;
   END;

   PROCEDURE Create_Address_Label_Rec (seq_no_ NUMBER ) IS
   BEGIN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Creating ADDRESS_LABEL with ID ['||message_id_||','||seq_no_||']');
      addr_label_rec_.rowversion             := 1;
      addr_label_rec_.application_message_id := message_id_;
      addr_label_rec_.seq_no                 := seq_no_;
      -- addr_label_rec_.sent                   := SYSDATE;
      addr_label_rec_.state                  := 'Released';
      INSERT INTO fndcn_address_label_tab VALUES addr_label_rec_;
   END;

   PROCEDURE Route_Message IS
      CURSOR route_address_ IS
         SELECT A.*, nvl(B.main_address,0) main_address, B.chain_link_no
         FROM routing_address_runtime_tab A,
              routing_rule_address_tab B
         WHERE B.rule_name = condition_id_
         AND   B.address_name = A.address_name
         ORDER BY B.chain_link_no, decode( nvl(B.main_address,0), 1, 2, 1);

      seq_ INTEGER := 0;
   BEGIN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Routing Application Message #' || to_char(message_id_) || ' in PL/SQL');
      FOR rec_ IN route_address_ LOOP
         addr_label_rec_.transport_connector   := rec_.transport_connector;
         addr_label_rec_.address_data          := rec_.address_data;
         addr_label_rec_.address_data_2        := rec_.address_data_2;
         addr_label_rec_.sender                := rec_.sender;
         addr_label_rec_.sender_organization   := rec_.sender_organization;
         addr_label_rec_.receiver              := rec_.receiver;
         addr_label_rec_.receiver_organization := rec_.receiver_organization;
         addr_label_rec_.options               := rec_.options;
         addr_label_rec_.transformer           := rec_.transformer;
         addr_label_rec_.response_transformer  := rec_.response_transformer;
         addr_label_rec_.envelope              := rec_.envelope;
         addr_label_rec_.encoding              := rec_.encoding; -- nvl(rec_.encoding,'UTF-8'); -- TODO: temp solution for ConnectTest!
         addr_label_rec_.sender_instance       := rec_.sender_instance;
         addr_label_rec_.zip                   := rec_.zip;
         addr_label_rec_.chain_link_no         := rec_.chain_link_no;
         addr_label_rec_.main_address          := rec_.main_address;
         Create_Address_Label_Rec(seq_);
         seq_ := seq_ +1;
      END LOOP;
   END;

   PROCEDURE Create_Msg_Body (seq_no_ NUMBER) IS
   BEGIN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Creating MESSAGE_BODY with ID ['||message_id_||','||seq_no_||']');
      msg_body_rec_.rowversion             := 1;
      msg_body_rec_.application_message_id := message_id_;
      msg_body_rec_.seq_no                 := seq_no_;
      msg_body_rec_.reply                  := 0;
      INSERT INTO fndcn_message_body_tab VALUES msg_body_rec_;
   END;

BEGIN
   IF invoke_ THEN
      queue_ := INVOKE_QUEUE;
      app_msg_rec_.tag := 'INVOKE';
   ELSE
      queue_ := Find_Queue___(message_function_, message_type_, receiver_, sender_, in_order_, condition_id_, candidates_);
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Found queue: ' ||queue_||' and rule: '||condition_id_);
   END IF;

   is_app_msg_rec_ := xml_ IS NULL AND doc_name_ = 'APPLICATION_MESSAGE';

   -- ------------------------------------------------------------------------------------
   -- Create application message - fndcn_application_message_tab
   IF is_app_msg_rec_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Message is an APPLICATION_MESSAGE');
      message_action_ := CASE message_function_ WHEN 'EVENT_MSG' THEN Get_Attribute_Value('MESSAGE_TYPE') ELSE NULL END;
      app_msg_rec_.message_type        := CASE nvl(message_action_,'*') WHEN '*' THEN message_type_ WHEN 'Event_Action' THEN 'EVENT_ACTION' ELSE 'EVENT' END;
      app_msg_rec_.message_function    := nvl(Get_Attribute_Value('MESSAGE_FUNCTION'), message_function_);
      app_msg_rec_.sender              := nvl(nvl(Get_Attribute_Value('SENDER'), sender_), Get_Default_Sender);
      app_msg_rec_.receiver            := nvl(Get_Attribute_Value('RECEIVER'), receiver_);
      app_msg_rec_.subject             := nvl(Get_Attribute_Value('SUBJECT'), subject_);
      app_msg_rec_.archive             := Get_Attribute_Value('ARCHIVE');
      app_msg_rec_.external_message_id := Get_Attribute_Value('EXTERNAL_MESSAGE_ID');
      app_msg_rec_.locale              := Get_Attribute_Value('LOCALE');
      app_msg_rec_.execute_as          := Get_Attribute_Value('EXECUTE_AS');
      app_msg_rec_.options             := Get_Attribute_Value('OPTIONS');
   ELSE
      app_msg_rec_.message_type        := message_type_;
      app_msg_rec_.message_function    := CASE invoke_method_
                                             WHEN TRUE THEN NULL -- Handler:Operation
                                             ELSE replace(message_function_, ':REPLICATION', '')
                                          END;
      app_msg_rec_.sender              := nvl(sender_, Get_Default_Sender);
      app_msg_rec_.receiver            := receiver_;
      app_msg_rec_.subject             := subject_;
      app_msg_rec_.archive             := 0;
      app_msg_rec_.external_message_id := external_message_id_; -- added ?
      app_msg_rec_.locale              := 'en-US';
      app_msg_rec_.execute_as          := 'Initiator';
      app_msg_rec_.initiated           := SYSDATE;
      --app_msg_rec_.initiated_by        := CASE invoke_ WHEN TRUE THEN nvl(run_as_, Fnd_Session_API.Get_Web_User) ELSE 'IFSCONNECT' END;
      app_msg_rec_.initiated_by        := CASE invoke_ WHEN TRUE THEN run_as_ ELSE 'IFSCONNECT' END;
      app_msg_rec_.inbound             := 0;
   END IF;
   Create_App_Msg_Rec;

   -- ------------------------------------------------------------------------------------
   -- Create address rows - fndcn_address_label_tab

   DECLARE
      addr_label_arr_id_ PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, 'ADDRESS_LABEL_LIST');
      addr_label_id_     PLSQLAP_Document_API.Element_Id;
      attr_id_           PLSQLAP_Document_API.Element_Id;
      addr_label_list_   PLSQLAP_Document_API.Child_Table;
      attr_list_         PLSQLAP_Document_API.Child_Table;
      addr_label_cnt_    BINARY_INTEGER;
      attr_name_         VARCHAR2(4000);
      attr_value_        VARCHAR2(4000);
   BEGIN
      IF addr_label_arr_id_ IS NOT NULL THEN
         addr_label_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, addr_label_arr_id_); -- list of ADDRESS_LABEL elements
      END IF;
      addr_label_cnt_ := addr_label_list_.count;
      IF addr_label_cnt_ > 0 THEN
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Adding #'||to_char(addr_label_cnt_)||' addresses from incoming record to Application Message #'||to_char(message_id_));
         FOR i IN 1..addr_label_cnt_ LOOP -- loop over ADDRESS_LABEL elements
            addr_label_id_ := addr_label_list_(i); -- an ADDRESS_LABEL
            attr_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, addr_label_id_); -- list of ADDRESS_LABEL attributes
            FOR j in 1..attr_list_.count LOOP -- loop over ADDRESS_LABAEL attributes
               attr_id_ := attr_list_(j); -- an attribute ID
               attr_name_ := PLSQLAP_Document_API.Get_Name(document_, attr_id_);
               attr_value_ := Plsqlap_Document_API.Get_Value(document_, attr_id_);
               CASE attr_name_
                  WHEN 'TRANSPORT_CONNECTOR'   THEN addr_label_rec_.transport_connector   := attr_value_;
                  WHEN 'ADDRESS_DATA'          THEN addr_label_rec_.address_data          := attr_value_;
                  WHEN 'ADDRESS_DATA_2'        THEN addr_label_rec_.address_data_2        := attr_value_;
                  WHEN 'ADDRESS_DATA2'         THEN addr_label_rec_.address_data_2        := attr_value_;
                  WHEN 'SENDER'                THEN addr_label_rec_.sender                := attr_value_;
                  WHEN 'SENDER_ORGANIZATION'   THEN addr_label_rec_.sender_organization   := attr_value_;
                  WHEN 'RECEIVER'              THEN addr_label_rec_.receiver              := attr_value_;
                  WHEN 'RECEIVER_ORGANIZATION' THEN addr_label_rec_.receiver_organization := attr_value_;
                  WHEN 'OPTIONS'               THEN addr_label_rec_.options               := attr_value_;
                  WHEN 'TRANSFORMER'           THEN addr_label_rec_.transformer           := attr_value_;
                  WHEN 'RESPONSE_TRANSFORMER'  THEN addr_label_rec_.response_transformer  := attr_value_;
                  WHEN 'ENVELOPE'              THEN addr_label_rec_.envelope              := attr_value_;
                  WHEN 'EXPIRES'               THEN addr_label_rec_.expires               := attr_value_; --date
                  WHEN 'RECEIPT_REQUIRED'      THEN addr_label_rec_.receipt_required      := attr_value_; --date
                  WHEN 'SENDER_INSTANCE'       THEN addr_label_rec_.sender_instance       := attr_value_;
                  ELSE NULL;
               END CASE;
            END LOOP;
            IF addr_label_rec_.sender IS NULL THEN
               addr_label_rec_.sender := sender_;
            END IF;
            IF addr_label_rec_.receiver IS NULL THEN
               addr_label_rec_.receiver := receiver_;
            END IF;
            addr_label_rec_.chain_link_no := 1;
            addr_label_rec_.main_address  := CASE i WHEN 1 THEN 1 ELSE 0 END;
            Create_Address_Label_Rec(i);
         END LOOP;
      ELSIF condition_id_ IS NOT NULL THEN -- only Replication ?
         Route_Message;
      ELSIF invoke_method_ THEN -- Invoke_Record_Impersonate, Invoke_Record_
         addr_label_rec_.transport_connector := 'InternalOperation';
         addr_label_rec_.address_data := message_function_;
         addr_label_rec_.chain_link_no := 1;
         addr_label_rec_.main_address  := 1;
         Create_Address_Label_Rec(1);
      END IF;
   END;

   -- ------------------------------------------------------------------------------------
   -- Create body row(s) - fndcn_message_body_tab

   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Creating body for Application Message #'||to_char(message_id_)||' of type '||doc_name_);
   msg_body_rec_.message_text  := empty_clob();
   msg_body_rec_.message_value := empty_blob();
   /* Message created by Command_SYS:
      <APPLICATION_MESSAGE>
         <SUBJECT>subject_</SUBJECT>
         <SENDER>sender_</SENDER>
         <MESSAGE_TYPE>Mail</MESSAGE_TYPE>
         <TEXT_BODY>
            <TEXT_BODY>
               <TEXT_BODY_TYPE>Str</TEXT_BODY_TYPE>
               <TEXT_VALUE>message_text_</TEXT_VALUE>
            </TEXT_BODY>
         </TEXT_BODY>
         <BINARY_BODY>
            <BINARY_BODY>
               <BINARY_BODY_TYPE>Binary</BINARY_BODY_TYPE>
               <BINARY_VALUE></BINARY_VALUE>
            </BINARY_BODY>
            ...
         </BINARY_BODY>
         <__EVENT_RECORD__>
            <event_name_>
               <attr_name_>attr_value_</attr_name_>
               ...
            </event_name_>
         <__EVENT_RECORD__>
         <ADDRESS_LABEL_LIST>
            ...
         </ADDRESS_LABEL_LIST>
      </APPLICATION_MESSAGE>
   */
   DECLARE
      agg_id_     PLSQLAP_Document_API.Element_Id;
      attr_id_    PLSQLAP_Document_API.Element_Id;
      attr_list_  PLSQLAP_Document_API.Child_Table;
      attr_name_  VARCHAR2(4000);
      rest_document_ Plsqlap_Document_API.Document;
      rest_parameter_xml_ CLOB;
   BEGIN
      IF is_app_msg_rec_ AND message_function_ = 'EVENT_MSG' THEN
         IF message_action_ = 'Mail' THEN
            agg_id_ := PLSQLAP_Document_API.Find_Element_Id(document_, 'TEXT_BODY/TEXT_BODY');
            IF agg_id_ IS NOT NULL THEN
               attr_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, agg_id_); -- list of attributes
            END IF;
            FOR i IN 1..attr_list_.count LOOP -- loop over attributes
               attr_id_ := attr_list_(i);
               attr_name_ := PLSQLAP_Document_API.Get_Name(document_, attr_id_);
               IF attr_name_ like 'TEXT_VALUE%' THEN
                  msg_body_rec_.message_text := msg_body_rec_.message_text || Plsqlap_Document_API.Get_Clob_Value(document_, attr_id_);
               ELSIF attr_name_ = 'TEXT_BODY_TYPE' AND Plsqlap_Document_API.Get_Value(document_, attr_id_) = 'Str' THEN
                  msg_body_rec_.body_type := 'Text';
               END IF ;
            END LOOP;
            msg_body_rec_.name := 'Body.txt';
            Create_Msg_Body(1);

            DECLARE
               arr_id_     PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, 'BINARY_BODY');
               elem_list_  PLSQLAP_Document_API.Child_Table;
               elem_id_    PLSQLAP_Document_API.Element_Id;

               FUNCTION Get_Value (parent_id_ IN PLSQLAP_Document_API.Element_Id, name_ IN VARCHAR2) RETURN VARCHAR2 IS
                  id_ PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, name_, parent_id_);
               BEGIN
                  RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE PLSQLAP_Document_API.Get_Value(document_, id_) END;
               END;

               FUNCTION Get_Clob_Value (parent_id_ IN PLSQLAP_Document_API.Element_Id, name_ IN VARCHAR2) RETURN CLOB IS
                  id_ PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, name_, parent_id_);
               BEGIN
                  RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE PLSQLAP_Document_API.Get_Clob_Value(document_, id_) END;
               END;

               FUNCTION Get_Blob_Value (parent_id_ IN PLSQLAP_Document_API.Element_Id, name_ IN VARCHAR2) RETURN BLOB IS
                  id_ PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, name_, parent_id_);
               BEGIN
                  RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE PLSQLAP_Document_API.Get_Blob_Value(document_, id_) END;
               END;

            BEGIN
               IF arr_id_ IS NOT NULL THEN
                  elem_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, arr_id_); -- list of BINARY_BODY elements
               END IF;
               FOR i IN 1..elem_list_.count LOOP -- loop over BINARY_BODY elements
                  elem_id_ := elem_list_(i);
                  msg_body_rec_.body_type     := Get_Value(elem_id_, 'BINARY_BODY_TYPE');
                  msg_body_rec_.name          := Get_Value(elem_id_, 'NAME');
                  msg_body_rec_.file_path     := Get_Value(elem_id_, 'FILE_PATH');
                  msg_body_rec_.message_value := Get_Blob_Value(elem_id_, 'BINARY_VALUE');
                  msg_body_rec_.message_text  := Get_Clob_Value(elem_id_, 'BINARY_LONG_VALUE');
                  Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Length message_text: ' ||to_char(length(msg_body_rec_.message_text)));
                  Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Length message_value: '||to_char(length(msg_body_rec_.message_value)));
                  Create_Msg_Body(i+1);
               END LOOP;
            END;
         ELSIF message_action_ = 'Event_Action' THEN
            agg_id_ := PLSQLAP_Document_API.Find_Element_Id(document_, '$EVENT_RECORD$'); -- for backward compatibility
            IF agg_id_ IS NULL THEN
               agg_id_ := PLSQLAP_Document_API.Get_Element_Id(document_, '__EVENT_RECORD__');
            END IF;
            agg_id_ := Plsqlap_Document_API.Get_Child_Elements(document_, agg_id_)(1);
            PLSQLAP_Document_API.To_Ifs_Xml(msg_body_rec_.message_text, document_, agg_id_);
            msg_body_rec_.body_type := 'XML';
            msg_body_rec_.name      := Plsqlap_Document_API.Get_Name(document_, agg_id_);
            Create_Msg_Body(1);
         ELSIF message_action_ = 'Rest' THEN
            msg_body_rec_.message_text := PLSQLAP_Document_API.Get_Clob_Value(document_,'REST_TEXT_VALUE');
            msg_body_rec_.name := 'Event_Rest.txt';
            msg_body_rec_.body_type := 'Text';
            rest_document_ := PLSQLAP_Document_API.New_Document('PARAMETERS');
            agg_id_ := PLSQLAP_Document_API.Find_Element_Id(document_, 'REST_PARAMETERS/PARAMETERS');
            IF agg_id_ IS NOT NULL THEN
               attr_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, agg_id_); -- list of attributes
            END IF;
            FOR i IN 1..attr_list_.count LOOP -- loop over attributes
               attr_id_ := attr_list_(i);
               attr_name_ := PLSQLAP_Document_API.Get_Name(document_, attr_id_);
               PLSQLAP_Document_API.Add_Attribute(rest_document_,attr_name_,Plsqlap_Document_API.Get_Value(document_, attr_id_));
            END LOOP;
            PLSQLAP_Document_API.To_IFS_Xml(rest_parameter_xml_,rest_document_);
            msg_body_rec_.parameters := rest_parameter_xml_;
            Create_Msg_Body(1);
            DECLARE
               arr_id_     PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, 'ATTACHMENT_BODY');
               elem_list_  PLSQLAP_Document_API.Child_Table;
               elem_id_    PLSQLAP_Document_API.Element_Id;
               attachment_  BLOB;

               FUNCTION Get_Value (parent_id_ IN PLSQLAP_Document_API.Element_Id, name_ IN VARCHAR2) RETURN VARCHAR2 IS
                  id_ PLSQLAP_Document_API.Element_Id := PLSQLAP_Document_API.Find_Element_Id(document_, name_, parent_id_);
               BEGIN
                  RETURN CASE id_ IS NULL WHEN TRUE THEN NULL ELSE PLSQLAP_Document_API.Get_Value(document_, id_) END;
               END;

            BEGIN
               IF arr_id_ IS NOT NULL THEN
                  elem_list_ := PLSQLAP_Document_API.Get_Child_Elements(document_, arr_id_); -- list of BINARY_BODY elements
               END IF;
               FOR i IN 1..elem_list_.count LOOP -- loop over BINARY_BODY elements
                  rest_document_ := PLSQLAP_Document_API.New_Document('PARAMETERS');
                  elem_id_ := elem_list_(i);
                  msg_body_rec_.body_type     := 'Binary';
                  msg_body_rec_.name          := 'FILENAME:'||Get_Value(elem_id_, 'FILENAME');
                  dbms_lob.createtemporary(attachment_, TRUE); 
                  Plsql_Rest_Sender_API.Get_Blob_Item('FND_EVENT_REST_BLOB_TAB', 'FILE_CONTENT', 'ROWKEY', Get_Value(elem_id_, 'ROWKEY'), attachment_);
                  msg_body_rec_.message_value := attachment_;
                  msg_body_rec_.message_text  := NULL;
                  Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'File name: ' ||msg_body_rec_.name);
                  Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Binary Body Type: ' ||msg_body_rec_.body_type);
                  Create_Msg_Body(i+1);
               END LOOP;
            END;
         ELSIF message_action_ IN ('SMS','Shell Command') THEN
            Error_SYS.Appl_General(lu_name_, 'OBSOLETEMSGTYPE: Obsolete Message Type :P1!', message_action_);
         END IF;
      ELSIF NOT is_app_msg_rec_ AND is_json_ THEN
         msg_body_rec_.body_type := 'JSON';
         IF NOT invoke_ THEN
            msg_body_rec_.name := CASE message_function_ WHEN default_class_id_ THEN 'MESSAGE_REQUEST.json' ELSE message_function_||'.json' END;
         END IF;

         IF xml_ IS NULL THEN
            PLSQLAP_Document_API.To_Json(msg_body_rec_.message_text, document_);
         ELSE
            msg_body_rec_.message_text := xml_;
         END IF;

         msg_body_rec_.parameters := parameters_;
         Create_Msg_Body(1);
      ELSIF NOT is_app_msg_rec_ THEN
         msg_body_rec_.body_type := 'XML';
         IF NOT invoke_ THEN
            msg_body_rec_.name := CASE message_function_ WHEN default_class_id_ THEN 'MESSAGE_REQUEST.xml' ELSE message_function_||'.xml' END;
         END IF;

         IF xml_ IS NULL THEN
            PLSQLAP_Document_API.To_Ifs_Xml(msg_body_rec_.message_text, document_, add_type_ => rest_, add_header_ => invoke_);
         ELSE
            msg_body_rec_.message_text := xml_;
         END IF;

         msg_body_rec_.parameters := parameters_;
         Create_Msg_Body(1);
      END IF;
   END;
END Create_Application_Message___;


FUNCTION Dummy_Document___ RETURN Plsqlap_Document_API.Document
IS
BEGIN
   RETURN Plsqlap_Document_API.New_Document(DUMMY_DOC);
END Dummy_Document___;


PROCEDURE Record_To_Document___ (
   document_ OUT Plsqlap_Document_API.Document,
   record_   IN  type_record_ )
IS
   xml_ CLOB;
BEGIN
   IF record_.name_ IS NULL OR Plsqlap_Record_API.Get_Type(record_) = DUMMY_DOC THEN
      document_ := Dummy_Document___;
   ELSE
      Plsqlap_Record_API.To_Xml(xml_, record_, TRUE);
      Plsqlap_Document_API.From_Ifs_Xml(document_, xml_);--, add_type_ => TRUE);
   END IF;
END Record_To_Document___;


PROCEDURE From_Ifs_Xml___ (
   doc_ OUT Plsqlap_Document_API.Document,
   xml_ IN  CLOB )
IS
BEGIN
   IF xml_ IS NOT NULL AND Dbms_Lob.GetLength(xml_) > 0 THEN
      Plsqlap_Document_API.From_Ifs_Xml(doc_, xml_);
      IF Plsqlap_Document_API.Get_Document_Name(doc_) = DUMMY_DOC THEN
         Plsqlap_Document_API.Clear(doc_);
      END IF;
   ELSE
      Plsqlap_Document_API.Clear(doc_);
   END IF;
END From_Ifs_Xml___;


PROCEDURE From_Xml___ (
   rec_ OUT type_record_,
   xml_ IN  CLOB )
IS
BEGIN
   IF xml_ IS NOT NULL AND Dbms_Lob.GetLength(xml_) > 0 THEN
      rec_ := Plsqlap_Record_API.From_Xml(xml_);
   ELSE
      Plsqlap_Record_API.Clear_Record(rec_);
   END IF;
END From_Xml___;


PROCEDURE To_Xml___ (
   xml_ OUT CLOB,
   rec_ IN  type_record_ )
IS
BEGIN
   IF rec_.name_ IS NULL THEN
      xml_ := '<'||DUMMY_DOC||'/>';
   ELSE
      Plsqlap_Record_API.To_Xml(xml_, rec_);
   END IF;
END To_Xml___;


FUNCTION Get_Run_As___ (
   run_as_identity_ IN VARCHAR2) RETURN VARCHAR2
IS
   run_as_ VARCHAR2(255) := nvl(run_as_identity_, Fnd_User_API.Get_Web_User(Fnd_Session_API.Get_Fnd_User()));
BEGIN
   IF run_as_ IS NULL THEN
      Error_SYS.Appl_General(lu_name_, 'NODIRID: User :P1 is not configured properly. Directory ID missing.', Fnd_Session_API.Get_Fnd_User());
   END IF;
   RETURN run_as_;
END Get_Run_As___;


FUNCTION Create_Invoke_Operation_Xml___ (
   message_function_ IN VARCHAR2,
   sender_           IN VARCHAR2,
   receiver_         IN VARCHAR2,
   body_             IN CLOB,
   encoded_          IN BOOLEAN DEFAULT FALSE ) RETURN CLOB
IS
BEGIN
   RETURN '<INVOKE_OPERATION><OPERATION_NAME>'||message_function_||'</OPERATION_NAME><SENDER>'
          ||sender_||'</SENDER><RECEIVER>'||receiver_||'</RECEIVER>'
          ||CASE encoded_ WHEN TRUE THEN '<BODY_ENCODED>TRUE</BODY_ENCODED>' ELSE '' END
          ||'<MESSAGE_BODY>'||body_||'</MESSAGE_BODY></INVOKE_OPERATION>';
END Create_Invoke_Operation_Xml___;


PROCEDURE Receive_Aq_Response___ (
   state_       OUT VARCHAR2,
   body_seq_no_ OUT NUMBER,
   message_id_  IN  NUMBER,
   timeout_     IN  NUMBER )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   Batch_Processor_Jms_API.Receive_Response_Message(state_, body_seq_no_, message_id_, timeout_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Dequeued Application Message #'||message_id_||' in state ['||state_||'] with response in Message Body #'||body_seq_no_);
   @ApproveTransactionStatement(2018-11-19,japase)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2018-11-19,japase)
      ROLLBACK;
      IF sqlcode = -25228 THEN -- ORA-25228: timeout or end-of-fetch during message dequeue from IFSAPP.BATCH_PROC_RESP_QUEUE
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Timeout ['||timeout_||' sec] occured while waiting for ['||message_id_||']');
         Error_SYS.Appl_General(lu_name_, 'DEQTIMEOUT: Timeout [:P1 sec] occured while waiting for invoke response.', timeout_);
      END IF;
      RAISE;
END Receive_Aq_Response___;


PROCEDURE Invoke_Aq___ (
   document_            IN     Plsqlap_Document_API.Document,
   xml_                 IN OUT CLOB,
   mode_                IN     NUMBER,
   message_type_        IN     VARCHAR2,
   message_function_    IN     VARCHAR2,
   sender_              IN     VARCHAR2,
   receiver_            IN     VARCHAR2,
   timeout_             IN     NUMBER,
   run_as_              IN     VARCHAR2,
   stat_enabled_        IN     BOOLEAN,
   parameters_          IN     CLOB DEFAULT NULL,
   is_json_             IN     BOOLEAN  DEFAULT FALSE)
IS
   message_id_    NUMBER := 0;
   body_seq_no_   NUMBER;
   state_         VARCHAR2(50);
   err_msg_       VARCHAR2(2000);

   PROCEDURE Get_Queue_Parameters (
      queue_stopped_ OUT BOOLEAN,
      priority_      OUT NUMBER) IS
   BEGIN
      queue_stopped_  := FALSE;
      priority_       := NULL;
      FOR p_ IN (SELECT parameter_name, parameter_value
                  FROM config_instance_param_tab
                 WHERE group_name = 'MessageQueues'
                   AND instance_name = INVOKE_QUEUE
                   AND parameter_name IN ('STOP_QUEUE', 'PRIORITY'))
      LOOP
         IF p_.parameter_name = 'STOP_QUEUE' THEN
            IF lower(p_.parameter_value) = 'true' THEN
               queue_stopped_ := TRUE;
            END IF;
         ELSIF p_.parameter_name = 'PRIORITY' THEN
            priority_ := to_number(p_.parameter_value);
         END IF;
      END LOOP;
   END;

   PROCEDURE Create_Invoke_Appmsg IS
      PRAGMA AUTONOMOUS_TRANSACTION;

      queue_stopped_  BOOLEAN;
      priority_       NUMBER;
      node_id_        VARCHAR2(100);
   BEGIN
      Get_Queue_Parameters(queue_stopped_, priority_);

      IF queue_stopped_ THEN
         Error_SYS.Appl_General(lu_name_, 'INVQUEUESTOPPED: DEFAULT queue used for Invoke messages is stopped');
      END IF;

      node_id_ := Connect_Node_API.Choose_Node_(TRUE);
      IF node_id_ = '?' THEN
         Error_SYS.Appl_General(lu_name_, 'ERRPING: No response from MWS server [INT]');
      END IF;

      Create_Application_Message___ (
         message_id_       => message_id_,
         document_         => document_,
         xml_              => xml_,
         sender_           => sender_,
         receiver_         => receiver_,
         message_type_     => message_type_,
         message_function_ => message_function_,
         invoke_timeout_   => timeout_,
         run_as_            => run_as_,
         parameters_        => parameters_,
         is_json_          => is_json_);

      --
      -- Send JMS message because ApplicationMessage trigger skips JMS for Invoke messages
      --
      Batch_Processor_Jms_API.Send_Jms_Message(
         method_                 => 'ProcessMessage',
         queue_                  => INVOKE_QUEUE,
         application_message_id_ => message_id_,
         execution_mode_         => 'Invoke',
         priority_               => priority_,
         chosen_node_id_         => node_id_);

      --
      -- Notify chosen node
      --   (1) lock node NOWAIT
      --   (2) COMMIT
      --   (3) send pipe message
      --
      Connect_Node_API.Lock_Node_No_Wait_(node_id_, is_invoke_ => 'TRUE');

      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Application Message #'||message_id_||' created.');
      @ApproveTransactionStatement(2018-11-19,japase)
      COMMIT;

      Connect_Node_API.Send_Pipe_Message_(node_id_, is_invoke_ => 'TRUE', text_ => 'Invoking');
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2018-11-19,japase)
         ROLLBACK;
         RAISE;
   END;

   PROCEDURE Fetch_Invoke_Response IS

      body_type_    VARCHAR2(100);
      blob_         BLOB;
      dest_offsset_ INTEGER := 1;
      src_offsset_  INTEGER := 1;
      lang_context_ INTEGER := Dbms_Lob.DEFAULT_LANG_CTX;
      warning_      INTEGER;

      FUNCTION Remove_Xml_Header (xml_ CLOB) RETURN CLOB IS
      BEGIN
         RETURN replace(replace(xml_,'<?xml version=''1.0'' encoding=''UTF-8''?>'),'<?xml version="1.0" encoding="UTF-8"?>');
      END;

      FUNCTION Create_Response (msg_ IN CLOB, header_ IN BOOLEAN DEFAULT FALSE, info_ IN BOOLEAN DEFAULT TRUE ) RETURN CLOB IS
      BEGIN
         RETURN CASE header_ WHEN TRUE THEN '<?xml version="1.0" encoding="UTF-8"?>' ELSE '' END ||
                '<RESPONSE xmlns="urn:ifsworld-com:schemas:info_response">'||
                CASE info_ WHEN TRUE THEN '<INFO>' ELSE '' END || msg_||
                CASE info_ WHEN TRUE THEN '</INFO>' ELSE '' END ||'</RESPONSE>';
      END;

   BEGIN
      SELECT body_type_db, message_value
      INTO   body_type_, blob_
      FROM   message_body
      WHERE  application_message_id = message_id_
      AND    seq_no = body_seq_no_;

      IF blob_ IS NULL THEN
         IF mode_ = INVOKE_IMPERS AND body_type_ = 'XML' THEN
            xml_ := Create_Response('Message is successfully executed', FALSE, FALSE);
         END IF;
         RETURN;
      END IF;

      Dbms_Lob.CreateTemporary(lob_loc => xml_, cache => false);
      Dbms_Lob.ConvertToClob (
         dest_lob     => xml_,                     -- in out
         src_blob     => blob_,                    -- in
         amount       => Dbms_Lob.LOBMAXSIZE,      -- in
         dest_offset  => dest_offsset_,            -- in out
         src_offset   => src_offsset_,             -- in out
         blob_csid    => Dbms_Lob.DEFAULT_CSID,    -- in
         lang_context => lang_context_,            -- in out
         warning      => warning_ );               -- out

      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Fetched message body:'||chr(10)||dbms_lob.substr(xml_, 4000, 1));

      IF mode_ = INVOKE_REC THEN
         xml_ := Create_Invoke_Operation_Xml___(message_function_, sender_, receiver_,
                    CASE body_type_ WHEN 'XML' THEN Remove_Xml_Header(xml_) ELSE Create_Response(xml_) END);
      ELSIF mode_ = INVOKE_DOC AND body_type_ = 'Text' THEN
         xml_ := Create_Response(xml_);
      ELSIF mode_ = INVOKE_XML AND body_type_ = 'Text' THEN
         xml_ := Create_Response(xml_, TRUE);
      ELSIF mode_ = INVOKE_IMPERS AND body_type_ = 'XML' THEN
         xml_ := Remove_Xml_Header(xml_);
      END IF;

   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Appl_General(lu_name_, 'ERRINVRESP: Message Body [:P1] for Application Message [:P2] doesn''t exist', body_seq_no_, message_id_);
   END;

   FUNCTION Fetch_Error RETURN VARCHAR2 IS
      msg_ VARCHAR2(2000);
   BEGIN
      SELECT error_text
      INTO   msg_
      FROM   application_message
      WHERE  application_message_id = message_id_;
      RETURN msg_;
   END;

BEGIN
   DECLARE
      DB_INVOKE_AQ CONSTANT VARCHAR2(30) := App_Message_Stat_Type_API.DB_INVOKE_AQ;
      DB_CREATE_AM CONSTANT VARCHAR2(30) := App_Message_Stat_Type_API.DB_CREATE_AM;
      DB_IMPERS    CONSTANT VARCHAR2(30) := App_Message_Stat_Category_API.DB_IMPERS;
      DB_INT_OP    CONSTANT VARCHAR2(30) := App_Message_Stat_Category_API.DB_INT_OP;

      stat_category_   VARCHAR2(30);
      invoke_aq_start_ TIMESTAMP(6);
      create_am_start_ TIMESTAMP(6);
   BEGIN
      IF App_Message_Processing_API.Is_Queue_Stopped_('DEFAULT') = 'TRUE' THEN
         Error_SYS.Appl_General(lu_name_, 'INVQUEUESTOPPED: DEFAULT queue used for Invoke messages is stopped');
      END IF;

      IF stat_enabled_ THEN
         invoke_aq_start_ := SYSTIMESTAMP;
         IF mode_ = INVOKE_IMPERS THEN
            stat_category_ := DB_IMPERS;
         ELSE
            stat_category_ := DB_INT_OP;
         END IF;
      END IF;
      create_am_start_ := SYSTIMESTAMP;
      Create_Invoke_Appmsg;
      IF stat_enabled_ THEN
         Application_Message_Stat_API.New_(message_id_, DB_CREATE_AM, stat_category_, create_am_start_);
      END IF;
      Receive_Aq_Response___(state_, body_seq_no_, message_id_, timeout_);
      IF state_ = 'Finished' AND body_seq_no_ >= 0 THEN
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Fetching response for mode ['||mode_||']...');
         Fetch_Invoke_Response;
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Formatted response:'||chr(10)||dbms_lob.substr(xml_, 4000, 1));
         IF stat_enabled_ THEN
            Application_Message_Stat_API.New_(message_id_, DB_INVOKE_AQ, stat_category_, invoke_aq_start_);
         END IF;
      ELSE
         err_msg_ := Fetch_Error;
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Error message:'||err_msg_);
         IF stat_enabled_ THEN
            Application_Message_Stat_API.New_(message_id_, DB_INVOKE_AQ, stat_category_, invoke_aq_start_);
         END IF;
         Error_SYS.Appl_General(lu_name_, 'ERRINV: :P1', err_msg_);
      END IF;
   END;
END Invoke_Aq___;

--Overloaded methosd for getting binary response
PROCEDURE Invoke_Aq___ (
   document_            IN     Plsqlap_Document_API.Document,
   xml_                 IN     CLOB,
   mode_                IN     NUMBER,
   message_type_        IN     VARCHAR2,
   message_function_    IN     VARCHAR2,
   sender_              IN     VARCHAR2,
   receiver_            IN     VARCHAR2,
   timeout_             IN     NUMBER,
   run_as_              IN     VARCHAR2,
   stat_enabled_        IN     BOOLEAN,
   parameters_          IN     CLOB DEFAULT NULL,
   is_json_             IN     BOOLEAN  DEFAULT FALSE,
   binary_response_     OUT    BLOB)
IS
   message_id_    NUMBER := 0;
   body_seq_no_   NUMBER;
   state_         VARCHAR2(50);
   err_msg_       VARCHAR2(2000);

   PROCEDURE Get_Queue_Parameters (
      queue_stopped_ OUT BOOLEAN,
      priority_      OUT NUMBER) IS
   BEGIN
      queue_stopped_  := FALSE;
      priority_       := NULL;
      FOR p_ IN (SELECT parameter_name, parameter_value
                  FROM config_instance_param_tab
                 WHERE group_name = 'MessageQueues'
                   AND instance_name = INVOKE_QUEUE
                   AND parameter_name IN ('STOP_QUEUE', 'PRIORITY'))
      LOOP
         IF p_.parameter_name = 'STOP_QUEUE' THEN
            IF lower(p_.parameter_value) = 'true' THEN
               queue_stopped_ := TRUE;
            END IF;
         ELSIF p_.parameter_name = 'PRIORITY' THEN
            priority_ := to_number(p_.parameter_value);
         END IF;
      END LOOP;
   END;

   PROCEDURE Create_Invoke_Appmsg IS
      PRAGMA AUTONOMOUS_TRANSACTION;

      queue_stopped_  BOOLEAN;
      priority_       NUMBER;
      node_id_        VARCHAR2(100);
   BEGIN
      Get_Queue_Parameters(queue_stopped_, priority_);

      IF queue_stopped_ THEN
         Error_SYS.Appl_General(lu_name_, 'INVQUEUESTOPPED: DEFAULT queue used for Invoke messages is stopped');
      END IF;

      node_id_ := Connect_Node_API.Choose_Node_(TRUE);
      IF node_id_ = '?' THEN
         Error_SYS.Appl_General(lu_name_, 'ERRPING: No response from MWS server [INT]');
      END IF;

      Create_Application_Message___ (
         message_id_       => message_id_,
         document_         => document_,
         xml_              => xml_,
         sender_           => sender_,
         receiver_         => receiver_,
         message_type_     => message_type_,
         message_function_ => message_function_,
         invoke_timeout_   => timeout_,
         run_as_            => run_as_,
         parameters_        => parameters_,
         is_json_          => is_json_);

      --
      -- Send JMS message because ApplicationMessage trigger skips JMS for Invoke messages
      --
      Batch_Processor_Jms_API.Send_Jms_Message(
         method_                 => 'ProcessMessage',
         queue_                  => INVOKE_QUEUE,
         application_message_id_ => message_id_,
         execution_mode_         => 'Invoke',
         priority_               => priority_,
         chosen_node_id_         => node_id_);

      --
      -- Notify chosen node
      --   (1) lock node NOWAIT
      --   (2) COMMIT
      --   (3) send pipe message
      --
      Connect_Node_API.Lock_Node_No_Wait_(node_id_, is_invoke_ => 'TRUE');

      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Application Message #'||message_id_||' created.');
      @ApproveTransactionStatement(2018-11-19,japase)
      COMMIT;

      Connect_Node_API.Send_Pipe_Message_(node_id_, is_invoke_ => 'TRUE', text_ => 'Invoking');
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2018-11-19,japase)
         ROLLBACK;
         RAISE;
   END;

   PROCEDURE Fetch_Invoke_Response IS

      body_type_    VARCHAR2(100);
      
   BEGIN
      SELECT body_type_db, message_value
      INTO   body_type_, binary_response_
      FROM   message_body
      WHERE  application_message_id = message_id_
      AND    seq_no = body_seq_no_;
        
   EXCEPTION
      WHEN no_data_found THEN
         Error_SYS.Appl_General(lu_name_, 'ERRINVRESP: Message Body [:P1] for Application Message [:P2] doesn''t exist', body_seq_no_, message_id_);
   END;

   FUNCTION Fetch_Error RETURN VARCHAR2 IS
      msg_ VARCHAR2(2000);
   BEGIN
      SELECT error_text
      INTO   msg_
      FROM   application_message
      WHERE  application_message_id = message_id_;
      RETURN msg_;
   END;

BEGIN
   DECLARE
      DB_INVOKE_AQ CONSTANT VARCHAR2(30) := App_Message_Stat_Type_API.DB_INVOKE_AQ;
      DB_CREATE_AM CONSTANT VARCHAR2(30) := App_Message_Stat_Type_API.DB_CREATE_AM;
      DB_IMPERS    CONSTANT VARCHAR2(30) := App_Message_Stat_Category_API.DB_IMPERS;
      DB_INT_OP    CONSTANT VARCHAR2(30) := App_Message_Stat_Category_API.DB_INT_OP;

      stat_category_   VARCHAR2(30);
      invoke_aq_start_ TIMESTAMP(6);
      create_am_start_ TIMESTAMP(6);
   BEGIN
      IF App_Message_Processing_API.Is_Queue_Stopped_('DEFAULT') = 'TRUE' THEN
         Error_SYS.Appl_General(lu_name_, 'INVQUEUESTOPPED: DEFAULT queue used for Invoke messages is stopped');
      END IF;

      IF stat_enabled_ THEN
         invoke_aq_start_ := SYSTIMESTAMP;
         IF mode_ = INVOKE_IMPERS THEN
            stat_category_ := DB_IMPERS;
         ELSE
            stat_category_ := DB_INT_OP;
         END IF;
      END IF;
      create_am_start_ := SYSTIMESTAMP;
      Create_Invoke_Appmsg;
      IF stat_enabled_ THEN
         Application_Message_Stat_API.New_(message_id_, DB_CREATE_AM, stat_category_, create_am_start_);
      END IF;
      Receive_Aq_Response___(state_, body_seq_no_, message_id_, timeout_);
      IF state_ = 'Finished' AND body_seq_no_ >= 0 THEN
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Fetching response for mode ['||mode_||']...');
         Fetch_Invoke_Response;
         IF stat_enabled_ THEN
            Application_Message_Stat_API.New_(message_id_, DB_INVOKE_AQ, stat_category_, invoke_aq_start_);
         END IF;
      ELSE
         err_msg_ := Fetch_Error;
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Error message:'||err_msg_);
         IF stat_enabled_ THEN
            Application_Message_Stat_API.New_(message_id_, DB_INVOKE_AQ, stat_category_, invoke_aq_start_);
         END IF;
         Error_SYS.Appl_General(lu_name_, 'ERRINV: :P1', err_msg_);
      END IF;
   END;
END Invoke_Aq___;

PROCEDURE Invoke___ (
   document_          IN     Plsqlap_Document_API.Document,
   xml_               IN OUT CLOB,
   mode_              IN     NUMBER, -- INVOKE_REC, INVOKE_DOC, INVOKE_XML, INVOKE_IMPERS
   message_type_      IN     VARCHAR2,
   message_function_  IN     VARCHAR2,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT NULL,
   req_timeout_       IN     NUMBER   DEFAULT NULL,
   run_as_            IN     VARCHAR2 DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL,
   is_json_           IN     BOOLEAN  DEFAULT FALSE)
IS
   DEF_TIMEOUT   CONSTANT NUMBER := 1200;
   stat_enabled_ BOOLEAN := FALSE;
   timeout_      NUMBER  := nvl(req_timeout_, DEF_TIMEOUT);
   doc_          Plsqlap_Document_API.Document := CASE Plsqlap_Document_API.Is_Initialized(document_)
                                                     WHEN TRUE THEN document_
                                                     ELSE Dummy_Document___
                                                  END;

   PROCEDURE Get_Parameters IS
      CURSOR params IS
         SELECT property_name, property_value
         FROM   jsf_property_tab
         WHERE  property_group = 'IFS'
         AND    property_name IN ('ifs.plsqlapInvokeTimeout', 'ifs.enableApplicationMessageStat')
         AND    property_value IS NOT NULL;
   BEGIN
      FOR par_ IN params LOOP
         CASE par_.property_name
            WHEN 'ifs.plsqlapInvokeTimeout'         THEN timeout_      := nvl(req_timeout_, par_.property_value);
            WHEN 'ifs.enableApplicationMessageStat' THEN stat_enabled_ := CASE upper(par_.property_value) WHEN 'TRUE' THEN TRUE ELSE FALSE END;
            ELSE NULL;
         END CASE;
      END LOOP;
   END;

   FUNCTION Get_Run_As RETURN VARCHAR2 IS
      FUNCTION Get_Plap_User RETURN VARCHAR2 IS
         user_ VARCHAR2(255);
      BEGIN
         SELECT value
         INTO   user_
         FROM   plsqlap_environment_tab
         WHERE  name = 'USER';
         RETURN user_;
      EXCEPTION
         WHEN no_data_found THEN
            RETURN 'IFSPLSQLAP';
      END;
   BEGIN
      IF mode_ = INVOKE_IMPERS THEN
         RETURN nvl(run_as_, Get_Plap_User);
      ELSE
         RETURN Fnd_User_API.Get_Web_User(Fnd_Session_API.Get_Fnd_User);
      END IF;
   END;

BEGIN
   Get_Parameters;
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Invoking operation through AQ...');
   IF mode_ = INVOKE_REC THEN
      xml_ := '<?xml version=''1.0'' encoding=''UTF-8''?>' || xml_;
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Converted Record:'||chr(10)||dbms_lob.substr(xml_, 4000, 1));
   END IF;
   Invoke_Aq___(doc_, xml_, mode_, message_type_, message_function_, sender_, receiver_, timeout_, Get_Run_As, stat_enabled_, parameters_, is_json_);
   IF mode_ = INVOKE_XML THEN
      IF xml_ IS NOT NULL THEN
         xml_ := replace(replace(xml_, '<'||DUMMY_DOC||'></'||DUMMY_DOC||'>'), '<'||DUMMY_DOC||'/>');
      END IF;
      IF xml_ IS NOT NULL AND rtrim(ltrim(xml_)) LIKE '<?xml %?>' THEN
         xml_ := NULL;
      END IF;
   END IF;
END Invoke___;

-- Overloaded method for getting blob response 
PROCEDURE Invoke___ (
   document_          IN     Plsqlap_Document_API.Document,
   xml_               IN     CLOB,
   mode_              IN     NUMBER, -- INVOKE_REC, INVOKE_DOC, INVOKE_XML, INVOKE_IMPERS
   message_type_      IN     VARCHAR2,
   message_function_  IN     VARCHAR2,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT NULL,
   req_timeout_       IN     NUMBER   DEFAULT NULL,
   run_as_            IN     VARCHAR2 DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL,
   is_json_           IN     BOOLEAN  DEFAULT FALSE,
   binary_response_   OUT    BLOB)
IS
   DEF_TIMEOUT   CONSTANT NUMBER := 1200;
   stat_enabled_ BOOLEAN := FALSE;
   timeout_      NUMBER  := nvl(req_timeout_, DEF_TIMEOUT);
   doc_          Plsqlap_Document_API.Document := CASE Plsqlap_Document_API.Is_Initialized(document_)
                                                     WHEN TRUE THEN document_
                                                     ELSE Dummy_Document___
                                                     END;
   input_xml_ CLOB;

   PROCEDURE Get_Parameters IS
      CURSOR params IS
         SELECT property_name, property_value
         FROM   jsf_property_tab
         WHERE  property_group = 'IFS'
         AND    property_name IN ('ifs.plsqlapInvokeTimeout', 'ifs.enableApplicationMessageStat')
         AND    property_value IS NOT NULL;
   BEGIN
      FOR par_ IN params LOOP
         CASE par_.property_name
            WHEN 'ifs.plsqlapInvokeTimeout'         THEN timeout_      := nvl(req_timeout_, par_.property_value);
            WHEN 'ifs.enableApplicationMessageStat' THEN stat_enabled_ := CASE upper(par_.property_value) WHEN 'TRUE' THEN TRUE ELSE FALSE END;
            ELSE NULL;
         END CASE;
      END LOOP;
   END;

   FUNCTION Get_Run_As RETURN VARCHAR2 IS
      FUNCTION Get_Plap_User RETURN VARCHAR2 IS
         user_ VARCHAR2(255);
      BEGIN
         SELECT value
         INTO   user_
         FROM   plsqlap_environment_tab
         WHERE  name = 'USER';
         RETURN user_;
      EXCEPTION
         WHEN no_data_found THEN
            RETURN 'IFSPLSQLAP';
      END;
   BEGIN
      IF mode_ = INVOKE_IMPERS THEN
         RETURN nvl(run_as_, Get_Plap_User);
      ELSE
         RETURN Fnd_User_API.Get_Web_User(Fnd_Session_API.Get_Fnd_User);
      END IF;
   END;

BEGIN
   Get_Parameters;
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Invoking operation through AQ...');
   IF mode_ = INVOKE_REC THEN
      input_xml_ := '<?xml version=''1.0'' encoding=''UTF-8''?>' || xml_;
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Converted Record:'||chr(10)||dbms_lob.substr(xml_, 4000, 1));
   END IF;
   Invoke_Aq___(doc_, input_xml_, mode_, message_type_, message_function_, sender_, receiver_, timeout_, Get_Run_As, stat_enabled_, parameters_, is_json_, binary_response_);
END Invoke___;


PROCEDURE Create_Path___(path_ VARCHAR2) AS
LANGUAGE JAVA NAME 'IfsOsPathTool.createOsPath(java.lang.String)';


FUNCTION Verify_Path___(path_ VARCHAR2) RETURN VARCHAR2 AS
LANGUAGE JAVA NAME 'IfsOsPathTool.osPathExist(java.lang.String) return java.lang.String';


PROCEDURE Fnd_Clob_Trace___ (xml_  IN CLOB)
IS
   length_           INTEGER;
   offset_           INTEGER := 1;
   amount_           INTEGER := 32000;
BEGIN
   length_ := dbms_lob.getlength(xml_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Invoke___ resut record: ');
   WHILE(offset_<length_) LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, dbms_lob.substr(xml_,amount_,offset_));
      offset_ := offset_ + amount_;
   END LOOP;
END Fnd_Clob_Trace___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Exists_Tmp_Record__ (
   exists_ OUT VARCHAR2,
   guid_ IN VARCHAR2 )
IS
   -- called from ApplicationServerTesting.serverpackage
   CURSOR c IS
      SELECT 'TRUE'
      FROM plsqlap_environment_tab
      WHERE name = guid_;
BEGIN
   exists_ := 'FALSE';
   OPEN c;
   FETCH c INTO exists_;
   CLOSE c;
END Exists_Tmp_Record__;


FUNCTION Test_Find_Queue__ (
   message_function_  IN VARCHAR2,
   message_type_      IN VARCHAR2 DEFAULT NULL,
   receiver_          IN VARCHAR2 DEFAULT NULL,
   sender_            IN VARCHAR2 DEFAULT NULL,
   in_order_          IN BOOLEAN  DEFAULT FALSE ) RETURN VARCHAR2
IS
   cond_id_     VARCHAR2(50);
   candidates_  VARCHAR2(4000);
   queue_       VARCHAR2(50);
BEGIN
   queue_ := Find_Queue___ (message_function_, message_type_, receiver_, sender_, in_order_, cond_id_, candidates_);
   RETURN 'QUEUE: ' || queue_ || ', RULE: ' || cond_id_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'ERROR: ' || sqlerrm;
END Test_Find_Queue__;


PROCEDURE Write_Wallet__ (
   file_name_ IN VARCHAR2,
   wallet_    IN BLOB )
IS
   path_       VARCHAR2(300);
   l_output_   utl_file.file_type;
   t_chucklen_ NUMBER := 4096;
   t_chuck_    RAW(4096);
   t_position_ NUMBER;
   t_remain_   NUMBER;
   l_length_   NUMBER;
   CURSOR get_path IS
     SELECT replace(VALUE, 'file:')
     INTO path_
     FROM plsqlap_environment_tab
     WHERE NAME = 'SSL_WALLET_PATH';
   FUNCTION Get_Default_Path RETURN VARCHAR2
   IS
      default_path_ VARCHAR2(300);
      CURSOR get_default IS
         SELECT p.VALUE||'/admin/'||i.instance_name||'/ifs_wallet'
         FROM v$parameter p, v$instance i
         WHERE p.NAME = 'diagnostic_dest';
   BEGIN
      OPEN get_default;
      FETCH get_default INTO default_path_;
      CLOSE get_default;
      Create_Path___(default_path_);
      Set_Plsqlap_Environment('SSL_WALLET_PATH', 'file:'||default_path_);
      RETURN default_path_;
   END Get_Default_Path;
BEGIN
   OPEN get_path;
   FETCH get_path INTO path_;
   CLOSE get_path;
   IF path_ IS NULL THEN
      path_ := Get_Default_Path;
   ELSE
      IF Verify_Path___(path_) = 'false' THEN
         path_ := Get_Default_Path;
      END IF;
   END IF;
   @ApproveDynamicStatement(2018-04-16,MABOSE)
   EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY WALLET_DIR AS '''||path_||'''';
   BEGIN
      INSERT INTO plsqlap_environment_tab
     (NAME, blob_value)
      VALUES
     ('SSL_WALLET_FILE', wallet_);
   EXCEPTION
      WHEN dup_val_on_index THEN
      UPDATE plsqlap_environment_tab
      SET blob_value = wallet_
      WHERE NAME = 'SSL_WALLET_FILE';
   END;
   @ApproveTransactionStatement(2018-04-16,MABOSE)
   COMMIT;
   l_length_ := NVL(Dbms_LOB.Getlength(wallet_),0);
   t_remain_ := l_length_;
   t_position_ := 1;
   t_chucklen_ := 4096;
   l_output_ := utl_file.fopen('WALLET_DIR', file_name_, 'wb', 32767);
   WHILE ( t_position_ < l_length_ ) LOOP
      dbms_lob.READ (wallet_, t_chucklen_, t_position_, t_chuck_);
      utl_file.put_raw(l_output_, t_chuck_);
      utl_file.fflush(l_output_);
      t_position_ := t_position_ + t_chucklen_;
      t_remain_ := t_remain_ - t_chucklen_;

      IF t_remain_ < 4096 THEN
          t_chucklen_ := t_remain_;
      END IF;
   END LOOP;
   utl_file.fclose(l_output_);
END Write_Wallet__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Invoke_Operation_ (
   document_  IN OUT Plsqlap_Document_API.Document,
   interface_ IN     type_interface_,
   method_    IN     type_method_,
   run_as_    IN     VARCHAR2 DEFAULT NULL)
IS
   xml_ CLOB := NULL;
BEGIN
   Invoke___(document_, xml_, INVOKE_IMPERS, default_media_code_, interface_||':'||method_, run_as_ => Get_Run_As___(run_as_));
   From_Ifs_Xml___(document_, xml_);
END Invoke_Operation_;


@UncheckedAccess
PROCEDURE Get_Wallet_Info_ (
   ssl_wallet_path_     OUT VARCHAR2,
   ssl_wallet_password_ OUT VARCHAR2 )
IS
   -- called from WebServicesUtil.plsql
   CURSOR c1 IS
      SELECT name, VALUE
      FROM   plsqlap_environment_tab
      WHERE name IN ('SSL_WALLET_PATH', 'SSL_WALLET_PASSWORD');
BEGIN
   FOR rec_ IN c1 LOOP
      IF ( UPPER(rec_.name) = 'SSL_WALLET_PATH' ) THEN
         ssl_wallet_path_ := rec_.value;
      ELSIF ( UPPER(rec_.name) = 'SSL_WALLET_PASSWORD' ) THEN
         ssl_wallet_password_ := rec_.value;
      END IF;
   END LOOP;
END Get_Wallet_Info_;


@UncheckedAccess
FUNCTION Get_Persistent_Con_ RETURN BOOLEAN
IS
   -- called from WebServicesUtil.plsql
   temp_ BOOLEAN;
   CURSOR c1 IS
      SELECT value
      FROM   plsqlap_environment_tab
      WHERE name = 'HTTP_PER_CONS';
BEGIN
   FOR rec_ IN c1 LOOP
     IF nvl(UPPER(rec_.value),'FALSE') = 'TRUE' THEN
        temp_ := TRUE;
     ELSE
        temp_ := FALSE;
     END IF;
   END LOOP;
   RETURN temp_;
END Get_Persistent_Con_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Plsqlap_Environment ( -- TODO: do we still need this function?
   name_  IN VARCHAR2 DEFAULT NULL,
   value_ IN VARCHAR2 DEFAULT NULL )
IS
   -- called from FndadmInstallation.plsql , ConfigurePlsqlAccessProviderTask.java and com.ifsworld.adminconsole.database.access.DatabaseUtils.java
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF ( name_ IS NOT NULL ) THEN
      UPDATE plsqlap_environment_tab
         SET value = value_
       WHERE name = UPPER(name_);
       IF ( SQL%NOTFOUND ) THEN
         INSERT INTO plsqlap_environment_tab (name, value)
            VALUES (UPPER(name_), value_);
      END IF;
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
   END IF;
   IF name_ IN ('SSL_WALLET_PATH', 'SSL_WALLET_PASSWORD') THEN
      Web_Services_Util_API.Init;
   END IF;
END Set_Plsqlap_Environment;


PROCEDURE Post_Event_Message (
   application_message_ IN OUT type_record_,
   class_id_            IN     VARCHAR2      DEFAULT NULL )  -- obsolete
IS
   -- called from Command.plsql
   doc_ Plsqlap_Document_API.Document;
BEGIN
   Record_To_Document___(doc_, application_message_);
   Post_Event_Message(doc_);
END Post_Event_Message;


PROCEDURE Post_Event_Message (
   application_message_ IN OUT Plsqlap_Document_API.Document,
   class_id_            IN     VARCHAR2      DEFAULT NULL )  -- obsolete
IS
   message_id_ NUMBER;
BEGIN
   -- verify that the record passed is an application message
   IF Plsqlap_Document_API.Get_Document_Name(application_message_) <> 'APPLICATION_MESSAGE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOAMDOC: The document passed is not an Application Message.');
   END IF;
   Create_Application_Message___(message_id_, application_message_, NULL, message_function_ => 'EVENT_MSG');
END Post_Event_Message;


PROCEDURE Post_Outbound_Message (
   message_body_            IN OUT type_record_,
   message_id_              IN OUT NUMBER,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
   doc_ Plsqlap_Document_API.Document;
BEGIN
   Record_To_Document___(doc_, message_body_);
   Create_Application_Message___ (
      message_id_        => message_id_,
      document_          => doc_,
      sender_            => sender_,
      receiver_          => receiver_,
      message_type_      => message_type_,
      message_function_  => message_function_,
      subject_           => subject_,
      in_order_          => in_order_,
      parameters_        => parameters_,
      rest_              => rest_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   message_body_            IN OUT type_record_,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
   message_id_ NUMBER;
BEGIN
   Post_Outbound_Message(message_body_, message_id_, sender_, receiver_, message_type_, message_function_,
                         subject_, in_order_, rest_, parameters_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   message_body_            IN OUT Plsqlap_Document_API.Document,
   message_id_              IN OUT NUMBER,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
BEGIN
   Create_Application_Message___ (
      message_id_        => message_id_,
      document_          => message_body_,
      sender_            => sender_,
      receiver_          => receiver_,
      message_type_      => message_type_,
      message_function_  => message_function_,
      subject_           => subject_,
      in_order_          => in_order_,
      parameters_        => parameters_,
      rest_              => rest_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   message_body_            IN OUT Plsqlap_Document_API.Document,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
   message_id_ NUMBER;
BEGIN
   Post_Outbound_Message(message_body_, message_id_, sender_, receiver_, message_type_, message_function_,
                         subject_, in_order_, rest_, parameters_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   xml_                     IN OUT CLOB,
   message_id_              IN OUT NUMBER,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   external_message_id_     IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
BEGIN
   Create_Application_Message___ (
      message_id_          => message_id_,
      document_            => Dummy_Document___,
      xml_                 => xml_,
      sender_              => sender_,
      receiver_            => receiver_,
      message_type_        => message_type_,
      message_function_    => message_function_,
      subject_             => subject_,
      external_message_id_ => external_message_id_,
      in_order_            => in_order_,
      parameters_          => parameters_,
      rest_                => rest_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   xml_                     IN OUT CLOB,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   external_message_id_     IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL)
IS
   message_id_ NUMBER;
BEGIN
   Post_Outbound_Message(xml_, message_id_, sender_, receiver_, message_type_, message_function_,
                         subject_, external_message_id_, in_order_, rest_, parameters_);
END Post_Outbound_Message;

PROCEDURE Post_Outbound_Message (
   json_                    IN OUT CLOB,
   message_id_              IN OUT NUMBER,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   external_message_id_     IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL,   
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   is_json_                 IN     BOOLEAN )
IS
BEGIN
   Create_Application_Message___ (
      message_id_          => message_id_,
      document_            => Dummy_Document___,
      xml_                 => json_,
      sender_              => sender_,
      receiver_            => receiver_,
      message_type_        => message_type_,
      message_function_    => message_function_,
      subject_             => subject_,
      external_message_id_ => external_message_id_,
      in_order_            => in_order_,
      parameters_          => parameters_,
      rest_                => rest_,
      is_json_             => is_json_);
END Post_Outbound_Message;


PROCEDURE Post_Outbound_Message (
   json_                     IN OUT CLOB,
   sender_                  IN     VARCHAR2 DEFAULT NULL,
   receiver_                IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_            IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_        IN     VARCHAR2 DEFAULT default_class_id_,
   subject_                 IN     VARCHAR2 DEFAULT NULL,
   external_message_id_     IN     VARCHAR2 DEFAULT NULL,
   in_order_                IN     BOOLEAN  DEFAULT FALSE,
   parameters_              IN     CLOB     DEFAULT NULL,   
   rest_                    IN     BOOLEAN  DEFAULT FALSE,
   is_json_                 IN     BOOLEAN  )
IS
   message_id_ NUMBER;
BEGIN
   Post_Outbound_Message(json_, message_id_, sender_, receiver_, message_type_, message_function_,
                         subject_, external_message_id_, in_order_, parameters_, rest_, is_json_);
END Post_Outbound_Message;


PROCEDURE Invoke_Outbound_Message (
   message_body_      IN OUT type_record_,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL)
IS
   xml_ CLOB := NULL;
BEGIN
   To_Xml___(xml_, message_body_);
   Invoke___(Dummy_Document___, xml_, INVOKE_REC, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_);
   From_Xml___(message_body_, xml_);
END Invoke_Outbound_Message;


PROCEDURE Invoke_Outbound_Message (
   message_body_      IN OUT Plsqlap_Document_API.Document,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL)
IS
   xml_ CLOB := NULL;
BEGIN
   Invoke___(message_body_, xml_, INVOKE_DOC, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_);
   From_Ifs_Xml___(message_body_, xml_);
END Invoke_Outbound_Message;


PROCEDURE Invoke_Outbound_Message (
   xml_               IN OUT CLOB,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL)
IS
BEGIN
   Invoke___(Dummy_Document___, xml_, INVOKE_XML, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_);
END Invoke_Outbound_Message;


PROCEDURE Invoke_Outbound_Message (
   json_              IN     OUT CLOB,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB     DEFAULT NULL,
   is_json_           IN     BOOLEAN  )
IS
BEGIN
   Invoke___(Dummy_Document___, json_, INVOKE_JSON, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_, is_json_ => TRUE);
END Invoke_Outbound_Message;

-- Overloaded method for getting Binary Response
PROCEDURE Invoke_Outbound_Message (
   input_             IN     CLOB,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB     DEFAULT NULL,
   is_json_           IN     BOOLEAN,
   binary_response_   OUT    BLOB)
IS
   mode_ VARCHAR2(25);
BEGIN
   IF(is_json_) THEN
      mode_ := INVOKE_JSON;
   ELSE
      mode_ := INVOKE_XML;
   END IF;
   Invoke___(Dummy_Document___, input_, mode_, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_, is_json_ => TRUE, binary_response_ => binary_response_);
END Invoke_Outbound_Message;

PROCEDURE Invoke_Outbound_Message (
   message_body_      IN     type_record_,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL,
   binary_response_   OUT    BLOB)
IS
   xml_ CLOB := NULL;
BEGIN
   To_Xml___(xml_, message_body_);
   Invoke___(Dummy_Document___, xml_, INVOKE_REC, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_,binary_response_ => binary_response_);
END Invoke_Outbound_Message;

PROCEDURE Invoke_Outbound_Message (
   message_body_      IN     Plsqlap_Document_API.Document,
   sender_            IN     VARCHAR2 DEFAULT NULL,
   receiver_          IN     VARCHAR2 DEFAULT default_recevier_,
   message_type_      IN     VARCHAR2 DEFAULT default_media_code_,
   message_function_  IN     VARCHAR2 DEFAULT default_class_id_,
   timeout_           IN     NUMBER   DEFAULT NULL,
   parameters_        IN     CLOB DEFAULT NULL,
   binary_response_   OUT    BLOB)
IS
   xml_ CLOB := NULL;
BEGIN
   Invoke___(message_body_, xml_, INVOKE_DOC, message_type_, message_function_, sender_, receiver_, timeout_, parameters_ => parameters_,binary_response_ => binary_response_);
END Invoke_Outbound_Message;

-- Obsolete procedures - to be removed

PROCEDURE Post_Outbound_With_Params (
   bizapi_name_ VARCHAR2, message_body_ IN OUT type_record_, parameters_ CLOB DEFAULT NULL, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_With_Params is not supported');
END Post_Outbound_With_Params;

PROCEDURE Post_Outbound_With_Params (
   bizapi_name_ VARCHAR2, message_body_ IN OUT Plsqlap_Document_API.Document, parameters_ CLOB DEFAULT NULL, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_With_Params is not supported');
END Post_Outbound_With_Params;

PROCEDURE Post_Outbound_With_Params (
   bizapi_name_ VARCHAR2, xml_ CLOB, parameters_ CLOB DEFAULT NULL, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_With_Params is not supported');
END Post_Outbound_With_Params;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, message_body_ IN OUT type_record_, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, message_id_ IN OUT NUMBER, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, message_body_ IN OUT Plsqlap_Document_API.Document, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, message_id_ IN OUT NUMBER, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, message_body_ IN OUT type_record_, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, message_body_ IN OUT Plsqlap_Document_API.Document, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, xml_ CLOB, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, external_message_id_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Post_Outbound_Bizapi (
   bizapi_name_ VARCHAR2, xml_ CLOB, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, message_type_ VARCHAR2 DEFAULT NULL, message_function_ VARCHAR2 DEFAULT NULL, message_id_ IN OUT NUMBER, external_message_id_ VARCHAR2 DEFAULT NULL, subject_ VARCHAR2 DEFAULT NULL, in_order_ BOOLEAN DEFAULT FALSE) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Post_Outbound_Bizapi is not supported');
END Post_Outbound_Bizapi;

PROCEDURE Invoke_Record_Impersonate (
   interface_ type_interface_, method_ type_method_, record_ IN OUT type_record_, run_as_identity_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, activity_ BOOLEAN DEFAULT FALSE, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Record_Impersonate is not supported');
END Invoke_Record_Impersonate;

PROCEDURE Invoke_Record_Impersonate (
   interface_ type_interface_, method_ type_method_, document_ IN OUT Plsqlap_Document_API.Document, run_as_identity_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, activity_ BOOLEAN DEFAULT FALSE, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Record_Impersonate is not supported');
END Invoke_Record_Impersonate;

PROCEDURE Invoke_Record_Impersonate (
   interface_ type_interface_, method_ type_method_, xml_ IN OUT CLOB, run_as_identity_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, activity_ BOOLEAN DEFAULT FALSE, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Record_Impersonate is not supported');
END Invoke_Record_Impersonate;

PROCEDURE Invoke_Outbound_Request_BizAPI (
   bizapi_name_ VARCHAR2, message_body_ IN OUT type_record_, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Outbound_Request_BizAPI is not supported');
END Invoke_Outbound_Request_BizAPI;

PROCEDURE Invoke_Outbound_Request_BizAPI (
   bizapi_name_ VARCHAR2, message_body_ IN OUT Plsqlap_Document_API.Document, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Outbound_Request_BizAPI is not supported');
END Invoke_Outbound_Request_BizAPI;

PROCEDURE Invoke_Outbound_Request_BizAPI(
   bizapi_name_ VARCHAR2, xml_ IN OUT CLOB, sender_ VARCHAR2 DEFAULT NULL, receiver_ VARCHAR2 DEFAULT NULL, connection_string_ type_connection_string_ DEFAULT NULL, timeout_ NUMBER DEFAULT NULL) IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'Procedure Invoke_Outbound_Request_BizAPI is not supported');
END Invoke_Outbound_Request_BizAPI;
