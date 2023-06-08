-----------------------------------------------------------------------------
--
--  Logical unit: Command
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960718  MADR  Created for IFS Foundation 1.2.2 (Idea #757).
--  960827  MADR  Added commands for execution of SQL statements
--  960930  MADR  Added commands for enumeration and deletion of OS files
--  961031  MADR  Added support for return information in buffers (Idea #851).
--  961106  MADR  Added new parameter from_alias_ to Mail command
--  970203  MADR  Published all helper methods for command creation
--  970404  MADR  Added new command Send_Socket_Message
--                Added optional parameter LABEL to all commands
--  970416  MADR  Added methods for checking if Event Server is active
--  970421  MADR  Added procedure Report_Event - a command for event logging
--  970502  MADR  Added new parameter instance_id_ to procedure Submit_From_File
--  970522  MADR  Use new packages Fnd_Setting_API, Fnd_Session_API, Fnd_User_API
--  970526  MADR  Added method Assign_Event_Server_Instance
--  970604  MADR  Added private methods for command queue maintenance
--  970630  MADR  New command for Socket dialog: Socket_Request
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  970817  MANY  Added new method Cleanup().
--  980116  ERFO  Changed package initialization only to include logic
--                towards system configuration and not Event Server active
--                flags in FndUserProperty (ToDo #2003).
--  980415  TOWR  Added command_sys_active_ check against FNDSETTING Event Server
--                active in Submit_From_File (Bug #2354)
--  981210  ERFO  Review of declarations regarding size limitation (Bug #2913).
--  990216  ERFO  Solve problem with depending Event Server jobs (Bug #3068).
--  990324  TOWR  Changes according to new java structure ifs.fnd.es
--  990427  ERFO  Performance solution in method Cleanup_ (Bug #3331).
--  000822  ROOD  Rearrangements in method Cleanup_ (Bug #14557).
--  010815  ROOD  Implemented the usage of the Connect 2.X interface as an
--                alternative to the EventServer (ToDo#4021).
--  010822  ROOD  Modifications in the method Mail (ToDo#4021).
--  010910  ROOD  Corrections in method Submit_From_File (Bug#24287).
--  011021  ROOD  Removed traces in method Mail.
--  011025  ROOD  Modified calls to Create_Connectivity_Message (ToDo#4021)
--  020129  ROOD  Added method Event_Application_Message_ (ToDo#4069).
--  020207  ROOD  Added validation of parameter combination in
--                Event_Application_Message_ (ToDo#4069).
--  020318  ROOD  Corrected variable declaration in Net_Message (Bug#28702).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030307  ROOD  Removed usage of Event Server and Command_SYS tables (ToDo#4149).
--  030827  ROOD  Added information for fnd_user in Socket_Message and Net_Message.
--  031004  ROOD  Handled overflow error in Create_Application_Message___ (Bug#37931).
--  040316  NIPE  Increase the length of info_ in Net_Message and Socket_Message to 32000 (Bug#43486).
--  041115  JHMA  Removed limitation of 2000 characters in TEXT_BODY.TEXT_VALUE (Bug#46810).
--  050506  BAMALK Create_Application_Message___ Replaced char(30) with '^' in TEXT_BODY.(Bug#48027).
--  050506  BAMALK Increased the size of name_ variable in the method Tokenize (Bug#48268).
--  050610  Bamalk Net_Message and Socket_Message : Introduced new variable dest_count_ (Bug#50126).
--  051121  Bamalk Mail : Set the Sender Address based on From Alias (Bug#54488).
--  060228  SukMlk Merged Bug#54499: Moved code from Tokenize to Tokenize___, called Tokenize___ from Mail.
--                 Other messeging methods call the Tokenize (which in turn calls Tokenize___).
--  060516  ASWILK Increased the size of name_ variable to 250 in the method Tokenize (Bug#58002).
--  061114  UTGULK Replaced all calls to Plsqlap_Server_API.Create_Connectivity_Message with Plsqlap_Server_API.Post_Event_Message.(Bug#58694)
--  070515  NiWi   Modified Mail. Bug#64206.
--  070622  SUMA  Changed the Constructor to fecth the event_executor_ from FndSettings(Hardcoded value)(F1PR499)
--  090507  JHMASE Choose WinPopUp destination. Bug #82672.
--  090730  UsRaLK Changed Socket_Message and Net_Message to use the new Fnd_Session_API.Get_Properties_. (Bug#83435)
--  091116  JHMASE Custom Event with action 'Application Message' generates invalid XML. (Bug #87159)
--  100330  NaBaLK Increased size of address_data_ in method Mail() (Bug#89044)
--  100901  DUWI   Depreciated the methods Socket_Message and Send_Socket_Message (EACS-986)
--  140822  MaBose Depreciated the methods Net_Message  (TEBASE-231).
--	 170214  UdLeLK Users need to change MAIL_SENDER in email event actions (Bug#134162)
--  181020  JAPASE PACDATA-44 - Re-factored to use Documents instead of Records.
-----------------------------------------------------------------------------
--
--  Dependencies: General_SYS
--                Message_SYS
--                Fnd_Setting_API
--                Fnd_Session_API
--                Fnd_User_API
--
--  Contents:     Implementation helper methods for Application Message creation
--                Public methods for command request
--                Public helper methods for command creatio
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE name_table     IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE date_table     IS TABLE OF DATE          INDEX BY BINARY_INTEGER;
TYPE number_table   IS TABLE OF NUMBER        INDEX BY BINARY_INTEGER;
TYPE filename_table IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
DUMMY_DOC           CONSTANT VARCHAR2(10) := '__DUMMY__';
TYPE attachment_rec IS RECORD (
    clob_     CLOB,
    blob_     BLOB,
    file_path_ VARCHAR2(32767)
  );
  TYPE rest_attachment_rec IS RECORD (
    rowkey_ VARCHAR2(32767),
    file_name_ VARCHAR2(4000)
  );
TYPE attachment_arr IS TABLE OF attachment_rec INDEX BY VARCHAR2(1000);
TYPE rest_attachment_arr IS TABLE OF rest_attachment_rec INDEX BY VARCHAR2(1000);

   lu_            CONSTANT VARCHAR2(30) := 'FndEventAction';
   file_service_  CONSTANT VARCHAR2(30) := 'Attachments';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Attachment_Blob___ (
   string_ IN VARCHAR2 ) RETURN BLOB
IS
   field_table_   Utility_SYS.STRING_TABLE;
   field_count_   NUMBER;
   blob_          BLOB;
BEGIN
   Utility_SYS.Tokenize(string_, Client_SYS.field_separator_, field_table_, field_count_);
--dbms_output.put_line('Field count:'||field_count_);
--dbms_output.put_line(' Field table:'||field_table_(1));
   -- Check package and method
   Assert_SYS.Assert_Is_Package_Method(Substr(field_table_(1), 1, Instr(field_table_(1), '(')-1));
   -- Check rowkey
   Assert_SYS.Assert_Is_Alphanumeric(Assert_SYS.Encode_Single_Quote_String(field_table_(2)));
   -- Execute the method
   @ApproveDynamicStatement(2016-09-27,haarse)
   EXECUTE IMMEDIATE 'BEGIN :return_blob := '||field_table_(1)||'; END;' USING  OUT blob_, IN field_table_(2);
   RETURN blob_;
END Get_Attachment_Blob___;


FUNCTION Create_Application_Message___ (
   message_text_  IN CLOB,
   subject_       IN VARCHAR2 DEFAULT NULL,
   sender_        IN VARCHAR2 DEFAULT NULL ) RETURN Plsqlap_Document_API.Document
IS
   text_body_type_      VARCHAR2(3)  := 'Str';
   application_message_ Plsqlap_Document_API.Document;
   text_body_id_        Plsqlap_Document_API.Element_Id;
BEGIN
   application_message_ := Plsqlap_Document_API.New_Document('APPLICATION_MESSAGE');

   IF subject_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'SUBJECT', subject_);
   END IF;
   IF sender_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'SENDER', sender_);
   END IF;
   Plsqlap_Document_API.Add_Attribute(application_message_, 'MESSAGE_TYPE', 'Mail');

   text_body_id_ := Plsqlap_Document_API.Add_Aggregate(application_message_,'TEXT_BODY','TEXT_BODY');
   Plsqlap_Document_API.Add_Attribute(application_message_, 'TEXT_BODY_TYPE', text_body_type_, text_body_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_, 'TEXT_VALUE', replace(message_text_ ,chr(30),'^'), text_body_id_);

   RETURN application_message_;
END Create_Application_Message___;

--Create Application Message for Rest
FUNCTION Create_Rest_Application_Message___ (
   message_text_  IN CLOB,
   url_params_    IN VARCHAR2,
   http_method_   IN VARCHAR2,
   blob_info_     IN VARCHAR2,
   query_params_  IN VARCHAR2,
   header_params_ IN VARCHAR2) RETURN Plsqlap_Document_API.Document
IS
   application_message_ Plsqlap_Document_API.Document;
   param_elem_id_        Plsqlap_Document_API.Element_Id;
BEGIN
   application_message_ := Plsqlap_Document_API.New_Document('APPLICATION_MESSAGE');

   Plsqlap_Document_API.Add_Attribute(application_message_, 'MESSAGE_TYPE', 'Rest');

   IF(message_text_ IS NOT NULL) THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'REST_TEXT_VALUE', replace(message_text_ ,chr(30),'^'));
   ELSE
      Plsqlap_Document_API.Add_Attribute(application_message_, 'REST_TEXT_VALUE', DUMMY_DOC);
   END IF;
   
   param_elem_id_ := Plsqlap_Document_API.Add_Aggregate(application_message_,'REST_PARAMETERS','PARAMETERS');
   Plsqlap_Document_API.Add_Attribute(application_message_,'URL_PARAMS', NVL(url_params_,'<></>'), param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'CALLBACK_FUNC', '', param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'HTTP_METHOD', http_method_, param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'HTTP_REQ_HEADERS', header_params_, param_elem_id_);
   IF blob_info_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_,'BLOB_INFO', blob_info_, param_elem_id_);
   END IF;
   Plsqlap_Document_API.Add_Attribute(application_message_,'QUERY_PARAMS', NVL(query_params_,'<></>'), param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'FND_USER', '', param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'KEY_REF', '', param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'HEADER_PARAMS', '<></>',param_elem_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_,'INCLD_RESP_INFO', '', param_elem_id_);
 
   RETURN application_message_;
END Create_Rest_Application_Message___;


PROCEDURE Create_Address_Label___ (
   application_message_ IN OUT Plsqlap_Document_API.Document,
   transport_connector_ IN     VARCHAR2,
   address_data_        IN     VARCHAR2,
   address_data2_       IN     VARCHAR2,
   sender_              IN     VARCHAR2 DEFAULT NULL,
   options_             IN     VARCHAR2 DEFAULT NULL,
   mail_sender_         IN     VARCHAR2 DEFAULT NULL )
IS
   addr_label_id_ Plsqlap_Document_API.Element_Id;
BEGIN
   addr_label_id_ := Plsqlap_Document_API.Add_Aggregate(application_message_, 'ADDRESS_LABEL_LIST', 'ADDRESS_LABEL');

   Plsqlap_Document_API.Add_Attribute(application_message_, 'TRANSPORT_CONNECTOR', transport_connector_, addr_label_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_, 'ADDRESS_DATA', address_data_, addr_label_id_);
   Plsqlap_Document_API.Add_Attribute(application_message_, 'SENT', sysdate, addr_label_id_);
   IF sender_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'SENDER', sender_, addr_label_id_);
   END IF;
   IF options_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'OPTIONS', options_, addr_label_id_);
   END IF;
   -- Add cc addresses if any
   IF address_data2_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'ADDRESS_DATA2', address_data2_, addr_label_id_);
   END IF;
   IF mail_sender_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(application_message_, 'SENDER_INSTANCE', mail_sender_, addr_label_id_);
   END IF;
END Create_Address_Label___;


FUNCTION Contains_Email_Address___ (
   address_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   token_position_ NUMBER;
   retval_         VARCHAR2 (5);
BEGIN
   retval_ := 'FALSE';

   token_position_ := instr(address_list_,'<'); -- look for a starting '<'
   IF token_position_ > 0 THEN
      token_position_ := instr(address_list_,'@', token_position_); -- Look for an '@' in the middle
      IF token_position_ > 0 THEN
         token_position_ := instr(address_list_,'>', token_position_); -- Look for an '>' at the end
            IF token_position_ > 0 THEN
               retval_ := 'TRUE'; -- This list does contains an email address
            END IF;
      END IF;
   END IF;

   RETURN retval_;
END Contains_Email_Address___;


PROCEDURE Tokenize___ (
   name_table_ OUT name_table,
   name_count_ OUT NUMBER,
   name_list_ IN VARCHAR2,
   check_for_email_add_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   delimiter_ VARCHAR2(1) := ',';
   list_      VARCHAR2(32000);
   name_      VARCHAR2(250);
   count_     NUMBER := 0;
   pos_       NUMBER := 1;
   next_      NUMBER;

BEGIN
   IF check_for_email_add_ != 'TRUE' THEN -- Email address checking is false or something else (a mistake).
      list_ := replace(name_list_,' ',delimiter_);
      list_ := replace(list_,';',delimiter_);
   ELSE
      IF Contains_Email_Address___( name_list_ ) = 'TRUE' THEN
         list_  := name_list_; -- If there is an email address in the list, we dont replace the spaces with a delimiter
      ELSE
         list_ := replace(name_list_,' ',delimiter_);
         list_ := replace(list_,';',delimiter_);
      END IF;
   END IF;


   WHILE pos_ <= length(list_) LOOP
      WHILE substr(list_,pos_,1) = delimiter_ LOOP
         pos_ := pos_ + 1;
      END LOOP;
      next_ := instr(list_,delimiter_,pos_);
      IF next_ = 0 THEN
         next_ := length(list_)+1;
      END IF;
      name_ := substr(list_,pos_,next_-pos_);
      IF name_ IS NOT NULL THEN
         count_ := count_ + 1;
         name_table_(count_) := name_;
      END IF;
      pos_ := next_ + 1;
   END LOOP;
   name_count_ := count_;
END Tokenize___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Attachment_Blob (
   string_ IN VARCHAR2 ) RETURN BLOB
IS
BEGIN
   RETURN(Get_Attachment_Blob___(string_));
END Get_Attachment_Blob;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Event_Application_Message_
--   Creates an application message from an Event Action and send it to
--   the Application Server. Only to be used by the Event Registry in it's
--   integration with Application Server. Public methods for creation of
--   application messages are available in PL/SQL Access Provider.
PROCEDURE Event_Application_Message_ (
   connector_    IN VARCHAR2 DEFAULT NULL,
   address_data_ IN VARCHAR2 DEFAULT NULL,
   envelope_     IN VARCHAR2 DEFAULT NULL,
   transformer_  IN VARCHAR2 DEFAULT NULL,
   message_data_ IN VARCHAR2 )
IS
   message_type_        VARCHAR2(13) := 'Event_Action';
   event_name_          VARCHAR2(100) := Message_SYS.Get_Name(message_data_);
   application_message_ Plsqlap_Document_API.Document;
   id_                  Plsqlap_Document_API.Element_Id;
   names_               Message_SYS.name_table;
   values_              Message_SYS.line_table;
   attribute_count_     NUMBER;

   FUNCTION Replace_Colon (element_name_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      IF ( INSTR(element_name_,':') > 0 ) THEN
         RETURN REPLACE(element_name_,':','_');
      ELSE
         RETURN element_name_;
      END IF;
   END Replace_Colon;
BEGIN
   General_SYS.Check_Security(service_, 'COMMAND_SYS', 'Event_Application_Message_');
   -- Create the Application Message
   application_message_ := Plsqlap_Document_API.New_Document('APPLICATION_MESSAGE');
   Plsqlap_Document_API.Add_Attribute(application_message_, 'MESSAGE_TYPE', message_type_);
   Plsqlap_Document_API.Add_Attribute(application_message_, 'MESSAGE_FUNCTION', event_name_);

   -- Create the address label if the correct values are given
   IF connector_ IS NOT NULL OR address_data_ IS NOT NULL THEN
      IF connector_ IS NOT NULL AND address_data_ IS NOT NULL THEN
         -- Add the address label to the application message
         id_ := PLSQLAP_Document_API.Add_Aggregate(application_message_, 'ADDRESS_LABEL_LIST', 'ADDRESS_LABEL');
         Plsqlap_Document_API.Add_Attribute(application_message_, 'TRANSPORT_CONNECTOR', connector_, id_);
         Plsqlap_Document_API.Add_Attribute(application_message_, 'ADDRESS_DATA', address_data_, id_);
         Plsqlap_Document_API.Add_Attribute(application_message_, 'ENVELOPE', envelope_, id_);
         Plsqlap_Document_API.Add_Attribute(application_message_, 'TRANSFORMER', transformer_, id_);
      ELSE
         Error_SYS.Record_General(service_, 'ERROR_AM_ADDRESS: Erroneous address information when sending Application Message for Event :P1! Both Connector and Address Data has to be stated if any of them are. Check the setup of this Event!', event_name_);
      END IF;
   ELSIF envelope_ IS NOT NULL OR transformer_ IS NOT NULL THEN
      Error_SYS.Record_General(service_, 'ERROR_AM_TRANSFORM: Erroneous address information when sending Application Message for Event :P1! Envelope and Transformer cannot be stated unless both Connector and Address Data are. Check the setup of this Event!', event_name_);
   END IF;

   -- Add event record containing all of the attributes to the application message
   --id_ := PLSQLAP_Document_API.Add_Aggregate(application_message_, '$EVENT_RECORD$', event_name_);
   id_ := PLSQLAP_Document_API.Add_Aggregate(application_message_, '__EVENT_RECORD__', event_name_);
   -- Loop over all attributes in message and insert into record
   Message_SYS.Get_Attributes(message_data_, attribute_count_, names_, values_);
   FOR attribute IN 1..attribute_count_ LOOP
      Plsqlap_Document_API.Add_Attribute(application_message_, Replace_Colon(names_(attribute)), values_(attribute), id_);
   END LOOP;

   -- Spool a trace of the message sent
   Plsqlap_Document_API.Debug(application_message_);
   -- Create application Message
   Plsqlap_Server_API.Post_Event_Message(application_message_, class_id_ => 'EVENT_MSG');
END Event_Application_Message_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Net_Message
--   Send a net message to specified client(s)
PROCEDURE Net_Message (
   to_         IN VARCHAR2,
   msg_        IN VARCHAR2,
   error_text_ IN VARCHAR2 DEFAULT NULL,
   timer_      IN VARCHAR2 DEFAULT NULL,
   audit_      IN VARCHAR2 DEFAULT NULL,
   label_      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETENETMSG: Calling obsolete interface Command_SYS.Net_Message!');
END Net_Message;


-- Socket_Message
--   Send a message to specified client(s)
PROCEDURE Socket_Message (
   to_         IN VARCHAR2,
   msg_        IN VARCHAR2,
   error_text_ IN VARCHAR2 DEFAULT NULL,
   timer_      IN VARCHAR2 DEFAULT NULL,
   audit_      IN VARCHAR2 DEFAULT NULL,
   label_      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETESOCKMSG: Calling obsolete interface Command_SYS.Socket_Message!');
END Socket_Message;


-- Send_Socket_Message
--   Send a message to specified host (or IP address) and port
PROCEDURE Send_Socket_Message (
   host_       IN VARCHAR2,
   port_       IN NUMBER,
   msg_        IN VARCHAR2,
   error_text_ IN VARCHAR2 DEFAULT NULL,
   timer_      IN VARCHAR2 DEFAULT NULL,
   audit_      IN VARCHAR2 DEFAULT NULL,
   label_      IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETESENDSOCKMSG: Calling obsolete interface Command_SYS.Send_Socket_Message!');
END Send_Socket_Message;


PROCEDURE Send_Rest_Message (
            rest_message_  IN CLOB,
            end_point_     IN VARCHAR2,
            auth_method_   IN VARCHAR2,
            login_info_    IN VARCHAR2,
            rest_sender_   IN VARCHAR2,
            header_params_ IN VARCHAR2,
            url_params_    IN VARCHAR2,
            http_method_   IN VARCHAR2,
            blob_info_     IN VARCHAR2,
            query_params_  IN VARCHAR2,
            attach_        IN CLOB DEFAULT NULL)
IS
   app_message_         Plsqlap_Document_API.Document;
   transport_connector_ CONSTANT VARCHAR2(4) := 'REST';
   options_             VARCHAR2(2000);
   attachments_   rest_attachment_arr;
   name_          Message_SYS.name_table_clob;
   value_         Message_SYS.line_table_clob;
   count_         NUMBER;
   name2_         Message_SYS.name_table_clob;
   value2_        Message_SYS.line_table_clob;
   count2_        NUMBER;
   
   PROCEDURE Add_Rest_Attachment___ (
      attachments_ IN OUT NOCOPY rest_attachment_arr,
      rowkey_      IN     VARCHAR2,
      filename_    IN     VARCHAR2 )
   IS
   BEGIN
		Add_Rest_Attachment(attachments_, rowkey_, filename_);
   END Add_Rest_Attachment___;
   
   PROCEDURE Create_Rest_Attachments___ (
      attachments_ IN rest_attachment_arr )
   IS
      filename_  VARCHAR2(4000);
      arr_id_    Plsqlap_Document_API.Element_Id;
      body_id_   Plsqlap_Document_API.Element_Id;
   BEGIN
      filename_ := attachments_.first;
      IF filename_ IS NOT NULL THEN
         arr_id_  := PLSQLAP_Document_API.Add_Array(app_message_, 'ATTACHMENT_BODY');
      END IF;
      WHILE filename_ IS NOT NULL LOOP
         body_id_ := Plsqlap_Document_API.Add_Document(app_message_, 'ATTACHMENT_BODY', arr_id_);
         IF (attachments_(filename_).rowkey_ IS NOT NULL) THEN
            Plsqlap_Document_API.Add_Attribute(app_message_, 'ROWKEY', attachments_(filename_).rowkey_, body_id_);
            Plsqlap_Document_API.Add_Attribute(app_message_, 'FILENAME', filename_, body_id_);
         END IF;
         filename_ := attachments_.next(filename_);
      END LOOP;
   END Create_Rest_Attachments___;
BEGIN
   options_ := login_info_||' http_method:NONE'||chr(13)||chr(10)||header_params_;
   Message_SYS.Get_Clob_Attributes(attach_, count_, name_, value_);
   IF count_ = 0 THEN
      IF (attach_ = '!ATTACHMENTS') THEN
         NULL;
      ELSE
         Add_Rest_Attachment___(attachments_, attach_, '');
      END IF;
   ELSE
      FOR i IN 1..count_ LOOP
         BEGIN
            Message_SYS.Get_Clob_Attributes(value_(i), count2_, name2_, value2_);
            CASE Message_SYS.Get_Name(value_(i))
               WHEN 'BLOB' THEN
                  Add_Rest_Attachment___(attachments_, value2_(1), value2_(2));
               ELSE
                  Dbms_Output.Put_Line(Message_SYS.Get_Name(value_(i)));
            END CASE;
         EXCEPTION
            WHEN no_data_found THEN
               Error_SYS.Appl_General(service_, 'NO_ARGUMENTS: Not enough arguments for some attachment.');
         END;
      END LOOP;
   END IF;
   app_message_  := Create_Rest_Application_Message___(rest_message_,url_params_,http_method_,blob_info_,query_params_,header_params_);
   Create_Address_Label___(app_message_, Transport_Connector_ => transport_connector_,
                                         Address_Data_ => end_point_,
                                         Address_Data2_ => auth_method_,
                                         Sender_ => null,
                                         options_ => options_,
                                         mail_sender_ => rest_sender_);
   Create_Rest_Attachments___(attachments_);
   Plsqlap_Document_API.Debug(app_message_);
   -- Create application Message
   Plsqlap_Server_API.Post_Event_Message(app_message_, class_id_ => 'EVENT_MSG');
END Send_Rest_Message;
-- Mail
--   Send a SMTP mail to specified user(s)
--   A list of binary files may be attached to the message
/*
PROCEDURE Mail (
   from_user_name_ IN VARCHAR2,
   to_user_name_   IN VARCHAR2,
   text_           IN VARCHAR2,
   error_text_     IN VARCHAR2 DEFAULT NULL,
   attach_         IN VARCHAR2 DEFAULT NULL,
   cc_             IN VARCHAR2 DEFAULT NULL,
   subject_        IN VARCHAR2 DEFAULT NULL,
   timer_          IN VARCHAR2 DEFAULT NULL,
   audit_          IN VARCHAR2 DEFAULT NULL,
   from_alias_     IN VARCHAR2 DEFAULT NULL,
   label_          IN VARCHAR2 DEFAULT NULL )
IS
   dest_                 name_table;
   count_                NUMBER;
   transport_connector_  VARCHAR2(4) := 'Mail';
--   message_type_         VARCHAR2(4) := 'Mail';
   binary_body_type_     VARCHAR2(6) := 'Binary';
   equal_pos_            NUMBER;
   address_data_         VARCHAR2(4000);
   cc_address_data_      VARCHAR2(2000);
   options_              VARCHAR2(2000);
   app_message_          Plsqlap_Record_API.type_record_;
   app_label_            Plsqlap_Record_API.type_record_;
   binary_body_          Plsqlap_Record_API.type_record_;
   sender_email_         VARCHAR2(250);
BEGIN
   General_SYS.Check_Security(service_, 'COMMAND_SYS', 'Mail');
   -- Create the Application Message
   app_message_  := Create_Application_Message___(message_text_ => to_clob(text_),
                                                  Subject_ => subject_,
                                                  Sender_  => from_alias_);

   -- Attachment. Could be just a file or a demand to load a file from disk
   IF (length(attach_) > 0) THEN
      equal_pos_ := instr(attach_,'=');
      IF (equal_pos_ > 0) THEN
         binary_body_ := Plsqlap_Record_API.New_record('BINARY_BODY');
         Plsqlap_Record_API.Set_Value(binary_body_, 'BINARY_BODY_TYPE', binary_body_type_, Plsqlap_Record_API.Dt_Enumeration);
         -- Attach file contents
         Plsqlap_Record_API.Set_Value(binary_body_, 'BINARY_VALUE', substr(attach_, equal_pos_ + 1, length(attach_)-equal_pos_), Plsqlap_Record_API.Dt_Long_Binary);
         -- Prepare the options attribute in address label with filename
         options_ := 'FILENAME='||substr(attach_, 1, equal_pos_ - 1);
         Plsqlap_Record_API.Add_Aggregate(app_message_, 'BINARY_BODY', binary_body_);
      ELSE
         -- Attachment without a '=' is considered to be 'load file from disk'
         -- Prepare the options attribute in address label with filepath
         options_ := 'FILEPATH='||attach_;
         -- Plsqlap_Record_API.Set_Value(app_message_, 'OPTIONS','FILEPATH='||attach_, Plsqlap_Record_API.dt_Text);
      END IF;
   END IF;

   -- Investigate addresses for each receiver and add it to the list of addresses
   Tokenize___( dest_, count_, to_user_name_ );
   FOR i_ IN 1..count_ LOOP
      -- Transform into mail address if not already done
      IF (instr(dest_(i_), '@') <= 0) THEN
         dest_(i_) := Fnd_User_API.Get_Property(upper(dest_(i_)), 'SMTP_MAIL_ADDRESS');
      END IF;

      IF address_data_ IS NULL THEN
         address_data_ := dest_(i_);
      ELSE
         address_data_ := address_data_ ||';'||dest_(i_);
      END IF;
   END LOOP;

   -- Create the address label
   sender_email_ := Fnd_User_API.Get_Property(upper(from_user_name_), 'SMTP_MAIL_ADDRESS');
   IF sender_email_ IS NOT NULL THEN
      app_label_ := Create_Address_Label___(Transport_Connector_ => transport_connector_,
                                   Address_Data_ => address_data_,
                                   Address_Data2_ => NULL,
                                   Sender_ => sender_email_);
   ELSE
      app_label_ := Create_Address_Label___(Transport_Connector_ => transport_connector_,
                                   Address_Data_ => address_data_,
                                   Address_Data2_ => NULL,
                                   Sender_ => from_alias_);
   END IF;

   -- Investigate addresses for each CC-receiver and add it to the second list of addresses
   Tokenize___( dest_, count_, cc_ );
   FOR i_ IN 1..count_ LOOP
      -- Transform into mail address if not already done
      IF (instr(dest_(i_), '@') <= 0) THEN
         dest_(i_) := Fnd_User_API.Get_Property(upper(dest_(i_)), 'SMTP_MAIL_ADDRESS');
      END IF;

      IF cc_address_data_ IS NULL THEN
         cc_address_data_ := dest_(i_);
      ELSE
         cc_address_data_ := cc_address_data_ ||';'||dest_(i_);
      END IF;
   END LOOP;

   -- Add cc addresses if any
   IF cc_address_data_ IS NOT NULL THEN
      Plsqlap_Record_API.Set_Value(app_label_, 'ADDRESS_DATA2', cc_address_data_, Plsqlap_Record_API.dt_Text);
   END IF;

   -- Add filename or filepath for the attached file if any
   IF options_ IS NOT NULL THEN
      Plsqlap_Record_API.Set_Value(app_label_, 'OPTIONS', options_, Plsqlap_Record_API.dt_Text);
   END IF;
   Plsqlap_Record_API.Add_Array(app_message_,'ADDRESS_LABEL_LIST',app_label_);

   -- Spool a trace of the message sent
   Plsqlap_Record_API.Debug(app_message_);
   -- Create application Message
   Plsqlap_Server_API.Post_Event_Message( app_message_, class_id_ => 'EVENT_MSG');
END Mail;
*/
PROCEDURE Add_Attachment (
   attachments_ IN OUT attachment_arr,
   filename_ IN VARCHAR2,
   attachment_ IN CLOB )
IS
BEGIN
	attachments_(filename_).clob_ := attachment_;
END Add_Attachment;

PROCEDURE Add_Attachment (
   attachments_ IN OUT attachment_arr,
   filename_ IN VARCHAR2,
   attachment_ IN BLOB )
IS
BEGIN
	attachments_(filename_).blob_ := attachment_;
END Add_Attachment;

PROCEDURE Add_Attachment (
   attachments_ IN OUT attachment_arr,
   filepath_ IN VARCHAR2,
   i_        IN NUMBER )
IS
BEGIN
	attachments_('FILE'||i_).file_path_ := filepath_;
END Add_Attachment;

PROCEDURE Add_Rest_Attachment (
   attachments_ IN OUT rest_attachment_arr,
   rowkey_      IN VARCHAR2,
   filename_    IN VARCHAR2 )
IS
BEGIN
	attachments_(filename_).rowkey_ := rowkey_;
END Add_Rest_Attachment;
/*
PROCEDURE Create_Mail_Attachment (
   rowkey_      IN VARCHAR2,
   filename_    IN VARCHAR2,
   binary_      IN BLOB,
   description_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Fnd_File_Storage_API.Create_Binary(file_service_, lu_, rowkey_, filename_, binary_, description_);
END Create_Mail_Attachment;

PROCEDURE Remove_Mail_Attachment (
   rowkey_      IN VARCHAR2,
   filename_    IN VARCHAR2 )
IS
BEGIN
   Fnd_File_Storage_API.Remove(file_service_, lu_, rowkey_, filename_);
END Remove_Mail_Attachment;
*/
/*
@Deprecated
PROCEDURE Mail (
   from_user_name_ IN VARCHAR2,
   to_user_name_   IN VARCHAR2,
   text_           IN VARCHAR2,
   error_text_     IN VARCHAR2 DEFAULT NULL,
   attach_         IN VARCHAR2 DEFAULT NULL,
   cc_             IN VARCHAR2 DEFAULT NULL,
   subject_        IN VARCHAR2 DEFAULT NULL,
   timer_          IN VARCHAR2 DEFAULT NULL,
   audit_          IN VARCHAR2 DEFAULT NULL,
   from_alias_     IN VARCHAR2 DEFAULT NULL,
   label_          IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Error_Sys.Deprecated_Error_(lu_name_, 'Mail');
END Mail;
*/
PROCEDURE Mail (
   from_user_name_ IN VARCHAR2,
   to_user_name_   IN VARCHAR2,
   text_           IN VARCHAR2,
   error_text_     IN VARCHAR2 DEFAULT NULL,
   attach_         IN VARCHAR2 DEFAULT NULL,
   cc_             IN VARCHAR2 DEFAULT NULL,
   subject_        IN VARCHAR2 DEFAULT NULL,
   timer_          IN VARCHAR2 DEFAULT NULL,
   audit_          IN VARCHAR2 DEFAULT NULL,
   from_alias_     IN VARCHAR2 DEFAULT NULL,
   label_          IN VARCHAR2 DEFAULT NULL)
IS
   dest_                 name_table;
   count_                NUMBER;
   transport_connector_  VARCHAR2(4) := 'Mail';
   message_type_         VARCHAR2(4) := 'Mail';
   binary_body_type_     VARCHAR2(6) := 'Binary';
   equal_pos_            NUMBER;
   address_data_         VARCHAR2(4000);
   cc_address_data_      VARCHAR2(2000);
   options_              VARCHAR2(2000);
   app_message_          Plsqlap_Document_API.Document;
   id_                   Plsqlap_Document_API.Element_Id;
   sender_email_         VARCHAR2(250);

   FUNCTION Create_Application_Message___ (
      text_value_    IN VARCHAR2,
      subject_       IN VARCHAR2 DEFAULT NULL,
      sender_        IN VARCHAR2 DEFAULT NULL,
      message_type_  IN VARCHAR2 ) RETURN Plsqlap_Document_API.Document
   IS
      text_body_type_      VARCHAR2(3)  := 'Str';
      local_text_value_    VARCHAR2(32000) := text_value_;
      application_message_ Plsqlap_Document_API.Document;
      text_body_id_        Plsqlap_Document_API.Element_Id;
   BEGIN
      application_message_ := Plsqlap_Document_API.New_Document('APPLICATION_MESSAGE');

      IF subject_ IS NOT NULL THEN
         Plsqlap_Document_API.Add_Attribute(application_message_, 'SUBJECT', subject_);
      END IF;
      IF sender_ IS NOT NULL THEN
         Plsqlap_Document_API.Add_Attribute(application_message_, 'SENDER', sender_);
      END IF;
      Plsqlap_Document_API.Add_Attribute(application_message_, 'MESSAGE_TYPE', message_type_);
      IF message_type_ = 'Mail' AND INSTR(local_text_value_ ,chr(30)) > 0 THEN
          local_text_value_  := REPLACE(local_text_value_ ,chr(30),'^');
      END IF;

      text_body_id_ := Plsqlap_Document_API.Add_Aggregate(application_message_, 'TEXT_BODY', 'TEXT_BODY');
      Plsqlap_Document_API.Add_Attribute(application_message_, 'TEXT_BODY_TYPE', text_body_type_, text_body_id_);
      Plsqlap_Document_API.Add_Attribute(application_message_, 'TEXT_VALUE', local_text_value_, text_body_id_);

      RETURN application_message_;
   END Create_Application_Message___;

   FUNCTION Create_Address_Label___ (
      transport_connector_ IN VARCHAR2,
      address_data_        IN VARCHAR2,
      sender_              IN VARCHAR2 DEFAULT NULL,
      options_             IN VARCHAR2 DEFAULT NULL,
      mail_sender_         IN VARCHAR2 DEFAULT NULL ) RETURN Plsqlap_Document_API.Element_Id
   IS
      addr_label_id_   Plsqlap_Document_API.Element_Id;
   BEGIN
      addr_label_id_ := Plsqlap_Document_API.Add_Aggregate(app_message_, 'ADDRESS_LABEL_LIST', 'ADDRESS_LABEL');
      Plsqlap_Document_API.Add_Attribute(app_message_, 'TRANSPORT_CONNECTOR', transport_connector_, addr_label_id_);
      Plsqlap_Document_API.Add_Attribute(app_message_, 'ADDRESS_DATA', address_data_, addr_label_id_);
      Plsqlap_Document_API.Add_Attribute(app_message_, 'SENT', SYSDATE, addr_label_id_);
      IF sender_ IS NOT NULL THEN
         Plsqlap_Document_API.Add_Attribute(app_message_, 'SENDER', sender_, addr_label_id_);
      END IF;
      IF options_ IS NOT NULL THEN
         Plsqlap_Document_API.Add_Attribute(app_message_, 'OPTIONS', options_, addr_label_id_);
      END IF;
      IF mail_sender_ IS NOT NULL THEN
         Plsqlap_Document_API.Add_Attribute(app_message_, 'SENDER_INSTANCE', mail_sender_, addr_label_id_);
      END IF;

      RETURN addr_label_id_;
   END Create_Address_Label___;

BEGIN
   General_SYS.Check_Security(service_, 'COMMAND_SYS', 'Mail');
   -- Create the Application Message
   app_message_  := Create_Application_Message___(Text_Value_ => text_,
                                                  Subject_ => subject_,
                                                  Sender_  => from_alias_,
                                                  Message_Type_ => message_type_);

   -- Attachment. Could be just a file or a demand to load a file from disk
   IF (length(attach_) > 0) THEN
      equal_pos_ := instr(attach_,'=');
      IF (equal_pos_ > 0) THEN
         id_ := Plsqlap_Document_API.Add_Aggregate(app_message_, 'BINARY_BODY', 'BINARY_BODY');
         Plsqlap_Document_API.Add_Attribute(app_message_, 'BINARY_BODY_TYPE', binary_body_type_, id_);
         -- Attach file contents
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Mail [1]: adding BINARY_VALUE');
         DECLARE
            blob_ BLOB := Utl_Raw.Cast_To_Raw(substr(attach_, equal_pos_ + 1, length(attach_)-equal_pos_));
         BEGIN
            Plsqlap_Document_API.Add_Attribute(app_message_, 'BINARY_VALUE', blob_, id_);
         END;
         -- Prepare the options attribute in address label with filename
         options_ := 'FILENAME='||substr(attach_, 1, equal_pos_ - 1);
      ELSE
         -- Attachment without a '=' is considered to be 'load file from disk'
         -- Prepare the options attribute in address label with filepath
         options_ := 'FILEPATH='||attach_;
      END IF;
   END IF;

   -- Investigate addresses for each receiver and add it to the list of addresses
   Tokenize___( dest_, count_, to_user_name_ );
   FOR i_ IN 1..count_ LOOP
      -- Transform into mail address if not already done
      IF (instr(dest_(i_), '@') <= 0) THEN
         dest_(i_) := Fnd_User_API.Get_Property(upper(dest_(i_)), 'SMTP_MAIL_ADDRESS');
      END IF;

      IF address_data_ IS NULL THEN
         address_data_ := dest_(i_);
      ELSE
         address_data_ := address_data_ ||';'||dest_(i_);
      END IF;
   END LOOP;

   -- Create the address label
   sender_email_ := Fnd_User_API.Get_Property(upper(from_user_name_), 'SMTP_MAIL_ADDRESS');
   IF sender_email_ IS NOT NULL THEN
      id_ := Create_Address_Label___(Transport_Connector_ => transport_connector_,
                                     Address_Data_ => address_data_,
                                     Sender_ => sender_email_);
   ELSE
      id_ := Create_Address_Label___(Transport_Connector_ => transport_connector_,
                                     Address_Data_ => address_data_,
                                     Sender_ => from_alias_);
   END IF;

   -- Investigate addresses for each CC-receiver and add it to the second list of addresses
   Tokenize___( dest_, count_, cc_ );
   FOR i_ IN 1..count_ LOOP
      -- Transform into mail address if not already done
      IF (instr(dest_(i_), '@') <= 0) THEN
         dest_(i_) := Fnd_User_API.Get_Property(upper(dest_(i_)), 'SMTP_MAIL_ADDRESS');
      END IF;

      IF cc_address_data_ IS NULL THEN
         cc_address_data_ := dest_(i_);
      ELSE
         cc_address_data_ := cc_address_data_ ||';'||dest_(i_);
      END IF;
   END LOOP;

   -- Add cc addresses if any
   IF cc_address_data_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(app_message_, 'ADDRESS_DATA2', cc_address_data_, id_);
   END IF;

   -- Add filename or filepath for the attached file if any
   IF options_ IS NOT NULL THEN
      Plsqlap_Document_API.Add_Attribute(app_message_, 'OPTIONS', options_, id_);
   END IF;

   -- Spool a trace of the message sent
   Plsqlap_Document_API.Debug(app_message_);
   -- Create application Message
   Plsqlap_Server_API.Post_Event_Message( app_message_, class_id_ => 'EVENT_MSG');
END Mail;

PROCEDURE Mail (
   sender_        IN VARCHAR2,
   from_          IN VARCHAR2,
   to_list_       IN VARCHAR2,
   cc_list_       IN VARCHAR2 DEFAULT NULL,
   bcc_list_      IN VARCHAR2 DEFAULT NULL,
   subject_       IN VARCHAR2,
   text_          IN CLOB,
   attach_        IN CLOB,
   rowkey_        IN VARCHAR2 DEFAULT NULL,
   mail_sender_   IN VARCHAR2 DEFAULT NULL)
IS
   attachments_   attachment_arr;
   name_          Message_SYS.name_table_clob;
   value_         Message_SYS.line_table_clob;
   count_         NUMBER;
   name2_         Message_SYS.name_table_clob;
   value2_        Message_SYS.line_table_clob;
   count2_        NUMBER;

   PROCEDURE Add_Blob_Attachment___ (
      attachments_ IN OUT attachment_arr,
      filename_ IN VARCHAR2,
      method_ IN VARCHAR2 )
   IS
      attachment_   BLOB;
      rowkey_local_ VARCHAR2(1000);
   BEGIN
      rowkey_local_ := Utility_SYS.Between_Str(method_, '(', ')', 'FALSE');
--   Dbms_Output.put_line(rowkey_);
--   Dbms_Output.put_line(replace(method_, Utility_SYS.Between_Str(method_, '(', ')', 'TRUE'), '(:ROWKEY)'));
      @ApproveDynamicStatement(2016-10-24,haarse)
      EXECUTE IMMEDIATE 'BEGIN :attachment := '||replace(method_, Utility_SYS.Between_Str(method_, '(', ')', 'TRUE'), '(:ROWKEY)')||'; END;' USING OUT attachment_, IN rowkey_local_;
		Add_Attachment(attachments_, filename_, attachment_);
   END Add_Blob_Attachment___;

   PROCEDURE Add_Clob_Attachment___ (
      attachments_ IN OUT attachment_arr,
      filename_ IN VARCHAR2,
      method_ IN VARCHAR2 )
   IS
      attachment_ CLOB;
      rowkey_local_ VARCHAR2(1000);
   BEGIN
      rowkey_local_ := Utility_SYS.Between_Str(method_, '(', ')', 'FALSE');
--   Dbms_Output.put_line(rowkey_);
--   Dbms_Output.put_line(replace(method_, Utility_SYS.Between_Str(method_, '(', ')', 'TRUE'), '(:ROWKEY)'));
      @ApproveDynamicStatement(2016-10-24,haarse)
      EXECUTE IMMEDIATE 'BEGIN :attachment := '||replace(method_, Utility_SYS.Between_Str(method_, '(', ')', 'TRUE'), '(:ROWKEY)')||'; END;' USING OUT attachment_, IN rowkey_local_;
		Add_Attachment(attachments_, filename_, attachment_);
   END Add_Clob_Attachment___;

   PROCEDURE Add_Text_Attachment___ (
      attachments_ IN OUT attachment_arr,
      filename_ IN VARCHAR2,
      text_ IN CLOB )
   IS
   BEGIN
		Add_Attachment(attachments_, filename_, text_);
   END Add_Text_Attachment___;

   PROCEDURE Add_File_Attachment___ (
      attachments_ IN OUT attachment_arr,
      filepath_    IN     VARCHAR2,
      i_           IN     NUMBER )
   IS
   BEGIN
		Add_Attachment(attachments_, filepath_, i_);
   END Add_File_Attachment___;
/*
   PROCEDURE Check_File_Storage___ (
      rowkey_      IN     VARCHAR2,
      attachments_ IN OUT attachment_arr )
   IS
      CURSOR get_attachments IS
      SELECT long_text, binary, filename
      FROM fnd_file_storage_tab
      WHERE service = file_service_
      AND lu = lu_
      AND rowkey = rowkey_;
   BEGIN
      FOR rec_ IN get_attachments LOOP
         CASE
            WHEN rec_.binary IS NOT NULL THEN
               Add_Attachment(attachments_, rec_.filename, rec_.binary);
            ELSE
               Add_Attachment(attachments_, rec_.filename, rec_.long_text);
         END CASE;
      END LOOP;
   END Check_File_Storage___;
*/
BEGIN
   General_SYS.Check_Security(service_, 'COMMAND_SYS', 'Mail');
   Message_SYS.Get_Clob_Attributes(attach_, count_, name_, value_);
   -- If this is not a message then it is a file path
   IF count_ = 0 THEN
      IF (attach_ = '!ATTACHMENTS') THEN
         NULL;
      ELSE
         Add_File_Attachment___(attachments_, attach_, 1);
      END IF;
   ELSE
      FOR i IN 1..count_ LOOP
         --Dbms_output.put_line(name_(i) || ':   '|| value_(i));
         BEGIN
            Message_SYS.Get_Clob_Attributes(value_(i), count2_, name2_, value2_);
            --Dbms_output.put_line(name2_(1) || ':   '|| value2_(1));
            CASE Message_SYS.Get_Name(value_(i))
               WHEN 'BLOB' THEN
                  Add_Blob_Attachment___(attachments_, value2_(1), value2_(2));
               WHEN 'CLOB' THEN
                  Add_Clob_Attachment___(attachments_, value2_(1), value2_(2));
               WHEN 'TEXT' THEN
                  Add_Text_Attachment___(attachments_, value2_(1), value2_(2));
               WHEN 'FILE' THEN
                  Add_File_Attachment___(attachments_, value2_(1), i);
               ELSE
                  Dbms_Output.Put_Line(Message_SYS.Get_Name(value_(i)));
            END CASE;
         EXCEPTION
            WHEN no_data_found THEN
               Error_SYS.Appl_General(service_, 'NO_ARGUMENTS: Not enough arguments for some attachment.');
         END;
      END LOOP;
   END IF;
/*
   -- LU connections only works if you get a rowkey
   IF (rowkey_ IS NOT NULL) THEN
      Check_File_Storage___(rowkey_, attachments_);
   END  IF;
*/
   Mail(sender_, from_, to_list_, cc_list_, bcc_list_, subject_, text_, attachments_, mail_sender_);
END Mail;

PROCEDURE Mail(
   sender_        IN VARCHAR2,
   from_          IN VARCHAR2,
   to_list_       IN VARCHAR2,
   cc_list_       IN VARCHAR2 DEFAULT NULL,
   bcc_list_      IN VARCHAR2 DEFAULT NULL,
   subject_       IN VARCHAR2,
   text_          IN CLOB,
   attachments_   attachment_arr,
   mail_sender_   IN VARCHAR2 DEFAULT NULL)
IS
   new_sender_          VARCHAR2(5000)       := sender_;
   new_from_            VARCHAR2(32000);
   new_to_list_         VARCHAR2(32000);
   new_cc_list_         VARCHAR2(32000);
   new_bcc_list_        VARCHAR2(32000);
   transport_connector_ CONSTANT VARCHAR2(4) := 'Mail';
--   message_type_        CONSTANT VARCHAR2(4) := 'Mail';
   file_                CONSTANT VARCHAR2(9) := 'FILENAME:';
   options_             CONSTANT VARCHAR2(4) := 'BCC=';
   app_message_         Plsqlap_Document_API.Document;
   binary_body_type_    CONSTANT VARCHAR2(6) := 'Binary';

   PROCEDURE Create_Attachments___ (
      attachments_ IN attachment_arr )
   IS
      filename_  VARCHAR2(4000);
      arr_id_    Plsqlap_Document_API.Element_Id;
      body_id_   Plsqlap_Document_API.Element_Id;
   BEGIN
      filename_ := attachments_.first;
      IF filename_ IS NOT NULL THEN
         arr_id_  := PLSQLAP_Document_API.Add_Array(app_message_, 'BINARY_BODY');
      END IF;
      WHILE filename_ IS NOT NULL LOOP
         body_id_ := Plsqlap_Document_API.Add_Document(app_message_, 'BINARY_BODY', arr_id_);
         Plsqlap_Document_API.Add_Attribute(app_message_, 'BINARY_BODY_TYPE', binary_body_type_, body_id_);
         IF (attachments_(filename_).clob_ IS NOT NULL) THEN
            Plsqlap_Document_API.Add_Attribute(app_message_, 'NAME', file_ || filename_, body_id_);
            Plsqlap_Document_API.Add_Attribute(app_message_, 'BINARY_LONG_VALUE', attachments_(filename_).clob_, body_id_);
         ELSIF (attachments_(filename_).blob_ IS NOT NULL) THEN
            Plsqlap_Document_API.Add_Attribute(app_message_, 'NAME', file_ || filename_, body_id_);
            Plsqlap_Document_API.Add_Attribute(app_message_, 'BINARY_VALUE', attachments_(filename_).blob_, body_id_);
         ELSIF (attachments_(filename_).file_path_ IS NOT NULL) THEN
            Plsqlap_Document_API.Add_Attribute(app_message_, 'FILE_PATH', attachments_(filename_).file_path_, body_id_);
         END IF;
         filename_ := attachments_.next(filename_);
      END LOOP;
   END Create_Attachments___;

   FUNCTION Convert_Fnd_User_To_Mail___ (
      mail_list_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      count_      NUMBER;
      mail_table_ Utility_SYS.STRING_TABLE;
      new_list_ VARCHAR2(32000);
   BEGIN
      Utility_SYS.Tokenize(mail_list_, ';', mail_table_, count_);
      FOR i_ IN 1..count_ LOOP
         -- Transform into mail address if not already done
         IF (instr(mail_table_(i_), '@') <= 0) THEN
            mail_table_(i_) := Fnd_User_API.Get_Property(ltrim(rtrim(upper(mail_table_(i_)))), 'SMTP_MAIL_ADDRESS');
         END IF;
         IF mail_table_(i_) IS NOT NULL THEN
            new_list_ := new_list_ || mail_table_(i_) || ';';
         END IF;
      END LOOP;
      -- strip last ;
      new_list_ := substr(new_list_, 1, length(new_list_)-1);
      RETURN(new_list_);
   END Convert_Fnd_User_To_Mail___;

BEGIN
   General_SYS.Check_Security(service_, 'COMMAND_SYS', 'Mail');
   -- Create the address label
   new_from_     := Convert_Fnd_User_To_Mail___(from_);
   -- Create the Application Message
   IF (new_sender_ IS NULL) THEN
      new_sender_ := new_from_;
   END IF;
   app_message_  := Create_Application_Message___(message_text_ => text_,
                                                  Subject_ => subject_,
                                                  Sender_  => new_sender_);
   new_to_list_  := Convert_Fnd_User_To_Mail___(to_list_);
   new_cc_list_  := Convert_Fnd_User_To_Mail___(cc_list_);
   new_bcc_list_ := Convert_Fnd_User_To_Mail___(bcc_list_);
   Create_Address_Label___(app_message_, Transport_Connector_ => transport_connector_,
                                         Address_Data_ => new_to_list_,
                                         Address_Data2_ => new_cc_list_,
                                         Sender_ => new_from_,
                                         options_ => options_ || new_bcc_list_,
                                         mail_sender_ => mail_sender_);
   Create_Attachments___(attachments_);
   -- Spool a trace of the message sent
   Plsqlap_Document_API.Debug(app_message_);
   -- Create application Message
   Plsqlap_Server_API.Post_Event_Message(app_message_, class_id_ => 'EVENT_MSG');
END Mail;


-- Is_Active
--   Return TRUE if command handling is activated
@UncheckedAccess
FUNCTION Is_Active RETURN BOOLEAN
IS
BEGIN
   RETURN TRUE;
END Is_Active;



-- Is_Active
--   Return TRUE if command handling is activated
@UncheckedAccess
PROCEDURE Is_Active (
   flag_ OUT VARCHAR2 )
IS
BEGIN
   flag_ := 'TRUE';
END Is_Active;



-- Tokenize
--   Tokenize comma-separated list into an array of VARCHARs
@UncheckedAccess
PROCEDURE Tokenize (
   name_table_ OUT name_table,
   name_count_ OUT NUMBER,
   name_list_  IN  VARCHAR2 )
IS
BEGIN
   Tokenize___(name_table_,
               name_count_,
               name_list_);
END Tokenize;




