-----------------------------------------------------------------------------
--
--  Logical unit: WebServicesUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041101  DOZE    Created
--  050209  DOZE    API changes for F1PR477
--  050531  DOZE    Added remote debug parameters
--  060111  DOZE    Added closing of requests at failure
--  061107  PEMA    https:// support (Bug# 59929)
--  070105  PEMA    Perforance: HTTP Persistent connections (Bug# 62558)
--  070110  PEMA    Fix ORA-29259, ORA-12537 errors caused by Bug# 62558. (Bug# 62884)
--                  Problem due to UTL_HTTP failing to recoginize server-side connection closed.
--  070122  KIPE    Set InteractiveMode FALSE in invoke().
--  070216  PEMA    Bug 63615. Addional followup fixes to 62558, 62884.
--                  Close persistent connections in error handler.
--  070216  MAOL    Changed length to lenghtb for http content-length. (Bug# 63617)
--  070419  MAOL    Fixed http content-length problem for non Unicode databases
--                  as well. (Bug#64857)
--  070426  PEMA    Bug 64444, Additional followup fixes to 63615, 62558, 62884.
--                  Changing default to non-persistent connections.
--                  Persistent connections are configurable using PLSQL_ENVIRONMENT_TAB.
--                  Better error handling; Some "hard" UTL_HTTP errors are rethrown ...
--                  ... as normal IFS Applications error messages
--  070521  UTGU    Added exception for ora-12541 in Invoke(Bug#65217).
--  080508  HAAR    Changed confusing error message (Bug#72493).
--  081208  HAAR    Try to fix so that special characters works in usenam and password (Bug#76346).
--  090422  UDLE    (Bug #81998) Set Http transfer timeout value
--  090715  UDLE    Fixed error when an outbound request Bizapi receives a large response message (Bug#82970)
--  100121  JHMASE  Added use of Proxy Server (Bug#88597)
--  120203  JHMASE  Added redirect on HTTP 301 and HTTP 302 (support for HTTPS).
--  120405  BUHILK  Throw a custom error message for connection timeout ORA-12535 (Bug#100337 merge
--  141204  ASWILK  End the first created request before creating a new request in the case of redirect. (Bug#119857 merge)
--  150303  ASWILK  Bad Argument error after bug fix 119857. (Bug#121319 merge)
--  150429  ASWILK  wallet information not set for SSL connections. (Bug#122176)       
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Request IS RECORD(
   Method    VARCHAR2(256),
   Namespace VARCHAR2(256),
   Body      CLOB);
TYPE Response IS RECORD(
   Doc Xmltype);

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Generate_Envelope___ (
   request_ IN OUT NOCOPY Request,
   envelope_ IN OUT NOCOPY CLOB )
IS
BEGIN   
  envelope_ := '<?xml version="1.0" encoding="UTF-8" ?>
                  <SOAP:Envelope
                  xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance"
                  xmlns:xsd="http://www.w3.org/1999/XMLSchema">
                  <SOAP:Body>' || request_.BODY || '</SOAP:Body></SOAP:Envelope>';
END Generate_Envelope___;


PROCEDURE Show_Envelope___ (
   envelope_ IN VARCHAR2 )
IS
   i_   PLS_INTEGER;
   len_ PLS_INTEGER;
BEGIN
   i_   := 1;
   len_ := Length(envelope_);
   WHILE (i_ <= len_) LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.info_, Substr(envelope_, i_, 250));
      i_ := i_ + 250;
   END LOOP;
END Show_Envelope___;


PROCEDURE Check_Fault___ (
   response_ IN OUT NOCOPY Response)
IS
   fault_node_   Xmltype;
   fault_code_   VARCHAR2(256);
   detail_       VARCHAR2(32767);
BEGIN
   fault_node_ := response_.Doc.Extract('/soap:Fault',
                                      'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/');
   IF (fault_node_ IS NOT NULL) THEN
      fault_code_ := fault_node_.extract('/soap:Fault/faultcode/child::text()',
                                        'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/').Getstringval();
      detail_ := fault_node_.extract('/soap:Fault/detail/ifserr:error/ifserr:errordetail/child::text()',
                                          'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/ xmlns:ifserr="urn:ifsworld-com:schemas:error"').Getstringval();
      Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_FAULT: :P1', detail_);
   END IF;
END Check_Fault___;


PROCEDURE Initialize_Proxy_Server___
IS
   proxy_server_        Fnd_Setting_TAB.value%TYPE := Fnd_Setting_API.Get_Value('PROXY_SERVER');
   no_proxy_domains_    Fnd_Setting_TAB.value%TYPE := Fnd_Setting_API.Get_Value('NO_PROXY_DOMAINS');
   ssl_wallet_path_     VARCHAR2(256);
   ssl_wallet_password_ VARCHAR2(128);
BEGIN
   IF ( (proxy_server_ IS NOT NULL) AND (proxy_server_ <> '*') ) THEN
      IF ( (no_proxy_domains_ IS NOT NULL) AND (no_proxy_domains_ <> '*') ) THEN
         Utl_Http.Set_Proxy(proxy_server_, no_proxy_domains_);
      ELSE
         Utl_Http.Set_Proxy(proxy_server_);
      END IF;
   END IF;
   Plsqlap_Server_API.Get_Wallet_Info_(ssl_wallet_path_, ssl_wallet_password_);
   Utl_Http.set_wallet( ssl_wallet_path_ , ssl_wallet_password_ );
END Initialize_Proxy_Server___;

FUNCTION Get_Request_Byte_Length___ (
   request_envelope_ IN CLOB ) RETURN NUMBER
IS
   chunks_ NUMBER := 0;
   l_byte_ NUMBER := 0;
   l_lob_  NUMBER := 0;
BEGIN
   IF (request_envelope_ IS NOT NULL) THEN
      l_lob_ := dbms_lob.getlength(request_envelope_);
      IF l_lob_ > 0 THEN
         chunks_ := CEIL(l_lob_ / 4000);
         FOR i_ IN 1.. chunks_ LOOP
          l_byte_ := l_byte_ + lengthb( Convert(dbms_lob.substr( request_envelope_, 4000, (i_-1) * 4000 + 1 ),'AL32UTF8'));
         END LOOP;
      END IF;
   END IF;
   RETURN l_byte_;
END Get_Request_Byte_Length___;

PROCEDURE Write_Request_Envelope___ (
   http_req_  IN OUT Utl_Http.Req,
   request_envelope_ IN     CLOB )
IS
   chunks_ NUMBER := 0;
   temp_chunk_  VARCHAR2(32000);
   l_lob_   NUMBER := 0;
BEGIN
   IF (request_envelope_ IS NOT NULL) THEN
      l_lob_ := dbms_lob.getlength(request_envelope_);
      IF l_lob_ > 0 THEN
         chunks_ := CEIL(l_lob_ / 4000);
         FOR i IN 1.. chunks_ LOOP
          temp_chunk_ := dbms_lob.substr(request_envelope_, 4000, (i-1) * 4000 + 1); 
          Utl_Http.Write_Text(http_req_, temp_chunk_);
         END LOOP;
      END IF;
   END IF;
END Write_Request_Envelope___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION New_Request (
   record_ IN PLSQLAP_Server_API.type_record_ ) RETURN request
IS
   request_ Request;
BEGIN
   PLSQLAP_Record_API.To_XML(request_.Body, record_);
   RETURN request_;
END New_Request;


@UncheckedAccess
PROCEDURE Add_Parameter (
   request_ IN OUT NOCOPY Request,
   name_ IN VARCHAR2,
   type_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
   tmp_req_ varchar2(32767);
BEGIN
   IF ((request_.Body IS NOT NULL) AND (dbms_lob.getlength(request_.Body)>0))   THEN
      tmp_req_ :=  '<' || name_ ||'>' || value_ || '</' || name_ || '>';
      dbms_lob.writeappend(request_.Body, length(tmp_req_), tmp_req_);
   END IF;
END Add_Parameter;


@UncheckedAccess
FUNCTION Invoke (
   request_ IN OUT NOCOPY Request,
   url_ IN VARCHAR2,
   action_ IN VARCHAR2,
   run_as_identity_ IN VARCHAR2 DEFAULT NULL,
   user_ IN VARCHAR2 DEFAULT NULL,
   password_ IN VARCHAR2 DEFAULT NULL,
   locale_ IN VARCHAR2 DEFAULT NULL,
   timeout_ IN NUMBER DEFAULT NULL) RETURN Response
IS
   --Begin Bug 82970
   envelope_ CLOB;
   tempreq_ VARCHAR2(32767);
   --End Bug 82970
   request_envelope_  CLOB;
   http_req_  Utl_Http.Req;
   http_resp_ Utl_Http.Resp;
   response_  Response;
   lang_      VARCHAR2(8);
   l_url_     VARCHAR2(4000) := url_;
   req_byte_len_   NUMBER;

   -- Begin Bug# 62558 HTTP Persistent connections
   -- The maximum number of persistent connections maintained in the current session.
   -- Should be a small number >= 1 and is arbitrarily choosen.
   max_conns_ PLS_INTEGER := 3;
   -- End Bug# 62558 HTTP Persistent connections

   -- Begin Bug# 62884 Hide errors caused by closed connections
   connection_error_ NUMBER := 0;
   -- End Bug# 62884 Hide errors caused by closed connections

   -- Begin Bug 63615 Hide errors caused by closed connections
   host_ VARCHAR2(200); -- hostname of server
   -- End Bug 63615 Hide errors caused by closed connections
   connection_server_down EXCEPTION;
   PRAGMA EXCEPTION_INIT(connection_server_down, -12541);
BEGIN
   -- Begin Bug 82970 Initialize the CLOB.
   DBMS_LOB.createtemporary(envelope_, FALSE);
   -- Begin Bug 63615 Hide errors caused by closed connections
   --   Retrieve hostname from URL. 
   --   URL is of form PROTOCOL://HOSTNAME:PORT/URI (:PORT is optional)
   --   Hostname is a series of DNS labels, seperated by dot (period).
   --   DNS labels may contain Letters, numbers, dash symbol ("-"). 
   --   No other punctuation is permitted, including the underscore ("_"). 
   host_ := REGEXP_REPLACE(l_url_,'^\w+://([-.A-Za-z0-9]*).*$','\1');
   -- Begin Bug 63615 Hide errors caused by closed connections


      DBMS_LOB.createtemporary(request_envelope_, FALSE, DBMS_LOB.call);
      Generate_Envelope___(request_, request_envelope_);

   


--   show_envelope___(envelope_);
   IF timeout_ IS NULL THEN
      Utl_Http.Set_Transfer_Timeout(To_Number(Fnd_Setting_API.Get_Value('TRANSFER_TIMEOUT')));
   ELSE
      Utl_Http.Set_Transfer_Timeout(timeout_);
   END IF;
   /* request that exceptions are raised for error Status Codes */
--   Utl_Http.Set_Response_Error_Check ( enable => true );
   /* allow testing for exceptions like Utl_Http.Http_Server_Error */
   Utl_Http.Set_Detailed_Excp_Support ( enable => true );

   -- Begin Bug# 62558 HTTP Persistent connections
   UTL_HTTP.set_persistent_conn_support(FALSE, max_conns_);
   -- End Bug# 62558 HTTP Persistent connections

   -- Begin Bug# 62884 Hide errors caused by closed connections
   <<connection_restart>>
   -- End Bug# 62884 Hide errors caused by closed connections
   host_ := REGEXP_REPLACE(l_url_,'^\w+://([-.A-Za-z0-9]*).*$','\1');

   http_req_ := Utl_Http.Begin_Request(l_url_, 'POST', 'HTTP/1.1');
   
   -- Begin Bug# 62558 HTTP Persistent connections
   -- Important authentication cosiderations: 
   --   With HTTP Basic auth., persistent connections are OK.
   --   With WIA / NTLM auth., persistent connections are ??? (Bad?).
   --   With WIA / Negociate (RFC4559) auth., persisntent connections are BAD.
   --   With SSL/TLS/PCT auth., persisntent connections are BAD.
   -- I.e. with current implementation of persistent connections, we cannot add support for
   -- other authentication schemes. That would require a "when to close connection" logic.
   -- Potential problem for Security Checkpoint if trying to add support for more auth. types,
   -- not an issue for "normal" PL/SQL Access Provider applications.
   -- Begin Bug# 64444 Persistent connection problems
   -- Old: UTL_HTTP.set_persistent_conn_support(Http_Req, TRUE);
   Utl_Http.set_persistent_conn_support(http_req_, Plsqlap_Server_API.Get_Persistent_Con_);
   -- End Bug# 64444 Persistent connection problems
   -- End Bug# 62558 HTTP Persistent connections

   -- Begin Bug# 62644 Set InteractiveMode FALSE
   Utl_Http.Set_Header(http_req_, 'InteractiveMode', 'FALSE');
   -- End Bug# 62644 Set InteractiveMode FALSE
   Utl_Http.Set_Header(http_req_, 'Content-Type', 'text/xml;');
  
   req_byte_len_ := Get_Request_Byte_Length___(request_envelope_);   

   IF (req_byte_len_ IS NOT NULL AND req_byte_len_ > 32767) THEN
      UTL_HTTP.Set_Header(http_req_, 'Transfer-Encoding', 'chunked' );
   ELSE
      Utl_Http.Set_Header(http_req_, 'Content-Length', req_byte_len_); 
   END IF;

   Utl_Http.Set_Header(http_req_, 'SOAPAction', action_);
   IF user_ IS NOT NULL THEN
      Utl_Http.Set_Authentication(http_req_, user_ , password_, 'Basic', FALSE);
   END IF;
   Utl_Http.Set_Body_Charset(http_req_, 'UTF-8');
   IF locale_ IS NULL THEN
      lang_ := Language_Code_API.Get_Lang_Code_Rfc3066(Fnd_Session_API.Get_Language());
   ELSE
      lang_ := locale_;
   END IF;
   Utl_Http.Set_Header(http_req_, 'Accept-Language', lang_);
   IF run_as_identity_ IS NOT NULL THEN
      Utl_Http.Set_Header(http_req_, 'Run-As-Identity', run_as_identity_);
   END IF;
   
   Write_Request_Envelope___(http_req_,request_envelope_);
   
   -- Begin Bug# 62884 Hide errors caused by closed connections
   DECLARE
     connection_failed_1 EXCEPTION ;
     connection_failed_2 EXCEPTION ;
     PRAGMA EXCEPTION_INIT(connection_failed_1, -12537);
     PRAGMA EXCEPTION_INIT(connection_failed_2, -29259);
   -- End Bug# 62884 Hide errors caused by closed connections
   -- Begin Bug# 64444 Persistent connection problems
     connection_failed_3 EXCEPTION ;
     connection_failed_4 EXCEPTION ;
     PRAGMA EXCEPTION_INIT(connection_failed_3, -12570);
     PRAGMA EXCEPTION_INIT(connection_failed_4, -12571);
     connection_timeout EXCEPTION ;
     PRAGMA EXCEPTION_INIT(connection_timeout, -12535);
   -- End Bug# 64444 Persistent connection problems


   BEGIN
      http_resp_ := Utl_Http.Get_Response(http_req_);
      
      IF ((http_resp_.status_code = 301) OR (http_resp_.status_code = 302)) THEN
         Utl_Http.Get_Header_By_Name(http_resp_, 'Location', l_url_);
         connection_error_ := connection_error_ + 1;
         IF connection_error_ < 3 THEN
            Utl_Http.Close_Persistent_Conns( host => host_ );
			Utl_Http.End_Response(http_resp_);
            GOTO connection_restart;
         ELSE
            Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_ERRORS: Network error, code :P1, while communicating with application server.', 1);
         END IF;
      END IF;

      IF (http_resp_.status_code = 500) OR (http_resp_.status_code<400) THEN
         -- Begin Bug 82970
         BEGIN
            LOOP
               Utl_Http.Read_Text(http_resp_, tempreq_, 32767);
               DBMS_LOB.writeappend (envelope_, LENGTH(tempreq_), tempreq_);
            END LOOP;
         EXCEPTION
            WHEN UTL_HTTP.end_of_body THEN
               Utl_Http.End_Response(http_resp_);
         END;
         -- End Bug 82970 
         --Utl_Http.Read_Text(Http_Resp, envelope_);
         --Utl_Http.End_Response(Http_Resp);
         response_.Doc := Xmltype.Createxml(envelope_);
         response_.Doc := response_.Doc.Extract('/soap:Envelope/soap:Body/child::node()', 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"');
         Check_Fault___(response_);
      ELSIF (http_resp_.status_code = Utl_Http.HTTP_UNAUTHORIZED) THEN
         Utl_Http.End_Response(http_resp_);
         Raise_Application_Error( -20401, 'HTTP 401, Unauthorized access');
      ELSE
         Utl_Http.End_Response(http_resp_);
         Raise_Application_Error( -20000, 'Request_Failed: ' || http_resp_.status_code );
      END IF;
   EXCEPTION
      WHEN Utl_Http.Request_Failed THEN
        Raise_Application_Error( -20000, 'Request_Failed: ' || Utl_Http.Get_Detailed_Sqlerrm );
      WHEN Utl_Http.Http_Server_Error THEN
        Raise_Application_Error( -20000, 'Http_Server_Error: ' || Utl_Http.Get_Detailed_Sqlerrm );
      WHEN Utl_Http.Http_Client_Error THEN
        Raise_Application_Error ( -20000, 'Http_Client_Error: ' || Utl_Http.Get_Detailed_Sqlerrm);

   -- Begin Bug# 62884 Hide errors caused by closed connections
      WHEN connection_failed_1 THEN      
        connection_error_ := connection_error_ + 1;
        IF connection_error_ < 3 THEN
          Utl_Http.Close_Persistent_Conns( host => host_ ); 
          GOTO connection_restart;
        ELSE
          Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_ERRORS: Network error, code :P1, while communicating with application server.', 1); 
        END IF;        
      WHEN connection_failed_2 THEN
        connection_error_ := connection_error_ + 1;
        IF connection_error_ < 3 THEN
          Utl_Http.Close_Persistent_Conns( host => host_ ); 
          GOTO connection_restart;
        ELSE
          Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_ERRORS: Network error, code :P1, while communicating with application server.', 2); 
        END IF;        
   -- End Bug# 62884 Hide errors caused by closed connections
   -- Begin Bug# 64444 Persistent connection problems
      WHEN connection_failed_3 THEN
        connection_error_ := connection_error_ + 1;
        IF connection_error_ < 3 THEN
          Utl_Http.Close_Persistent_Conns( host => host_ );
          GOTO connection_restart;
        ELSE
          Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_ERRORS: Network error, code :P1, while communicating with application server.', 3);
        END IF;
      WHEN connection_failed_4 THEN
        connection_error_ := connection_error_ + 1;
        IF connection_error_ < 3 THEN
          Utl_Http.Close_Persistent_Conns( host => host_ );
          GOTO connection_restart;
        ELSE
          Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_ERRORS: Network error, code :P1, while communicating with application server.', 4);
        END IF;
      WHEN connection_timeout THEN
        Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_TIMEOUT: Network timeout while communicating with application server.');
   -- End Bug# 64444 Persistent connection problems

   END;
   RETURN response_;
EXCEPTION
   WHEN connection_server_down THEN 
      Error_SYS.Appl_General(lu_name_, 'UTL_HTTP_DOWN: Error when trying to communicate with the application server. This is likely due to one of the following reasons.
      1) Network problems.
      2) The application server being offline.
      3) PL/SQL Access Provider connection string (:P1) is incorrect.',l_url_);
END Invoke;

@Override
@UncheckedAccess
PROCEDURE Init 
IS
BEGIN
   super();
   Initialize_Proxy_Server___;
END Init;
