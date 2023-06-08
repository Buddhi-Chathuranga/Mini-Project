-----------------------------------------------------------------------------
--
--  Logical unit: MediaArchiveAzureUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181105  ChahLK  Bug 142707, Removed check for wallet password.
--  180725  ChWkLk  Bug 143218, Modified Delete_Media_Item() to change the error meesage text to match its message constant.
--  180227  Hasplk  STRMF-17759, Merged LCS patch 140228.
--  180227          180214  Hasplk  Bug 140228, Added error handling and progress information logging for archiving background job 
--  170514  Chahlk  Bug 136626, Added Archiving Support for Media Item Language.
--  170407  PRDALK  Bug 135941,Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Prepare_Request___(
         http_request_     OUT   UTL_HTTP.req,
         operation_        IN    VARCHAR2,
         address_          IN    VARCHAR2,
         storage_name_     IN    VARCHAR2,
         container_name_   IN    VARCHAR2,
         access_key_       IN    VARCHAR2,
         media_id_         IN    NUMBER,
         wallet_path_      IN    VARCHAR2,
         wallet_password_  IN    VARCHAR2,
         lang_code_        IN    VARCHAR2 DEFAULT NULL,
         blob_length_      IN    NUMBER DEFAULT 0
         )
IS
   auth_header_         VARCHAR2(10000);
   cur_time_char_       VARCHAR2(100);
   urn_                 VARCHAR2(2000);
   temp_address_        VARCHAR2(2000):= address_ || '/' || container_name_ || '/';
   --Type of the blob stored in the Azure.
   --BlockBlob is the most efficient for large images
   blob_type_           VARCHAR2(10) := 'BlockBlob';
   --Azure API Version
   version_             VARCHAR2(20) := '2014-02-14';
   encoded_auth_header_ VARCHAR2(32000);
   file_name_           VARCHAR2(100);
   extension_           VARCHAR2(5) := '.file';
BEGIN
   file_name_ := 'ifs_media_item_' || media_id_;
   IF lang_code_ IS NULL THEN
      file_name_ := file_name_ || extension_;
   ELSE
      file_name_ := file_name_ || '_' || lang_code_ || extension_;
   END IF;

   cur_time_char_ := Get_Current_Gmt_Time___;

   IF (wallet_path_ IS NULL) THEN
      urn_ := Substr(temp_address_, Instr(temp_address_, ':'), length(temp_address_));
      temp_address_ := 'http' || urn_;
   ELSE
      UTL_HTTP.Set_Wallet('file:' || wallet_path_, wallet_password_);
   END IF;

   http_request_ := UTL_HTTP.begin_request (temp_address_ || file_name_, operation_);

   -- set header's attributes
   IF operation_ = 'PUT' THEN
      UTL_HTTP.set_header(http_request_, 'Content-Length',  blob_length_);
   END IF;
   UTL_HTTP.set_header(http_request_, 'x-ms-blob-type', blob_type_);
   UTL_HTTP.set_header(http_request_, 'x-ms-date', cur_time_char_);
   UTL_HTTP.set_header(http_request_, 'x-ms-version', version_);

   auth_header_ := Generate_Auth_Header___(operation_, storage_name_, container_name_, cur_time_char_, file_name_, blob_type_, version_, blob_length_);
   encoded_auth_header_ := Get_Encoded_Auth_Header(auth_header_, access_key_);
   UTL_HTTP.set_header(http_request_, 'Authorization', 'SharedKey ' || storage_name_ || ':' || encoded_auth_header_);
EXCEPTION
   WHEN OTHERS THEN
     Error_sys.record_General(lu_name_,'REQERROR: Unable to setup connection with Azure storage. Please verify the archive settings.');
END Prepare_Request___;


FUNCTION Get_Current_Gmt_Time___ RETURN VARCHAR2
IS
   CURSOR get_current_gmt_time IS
      SELECT  TO_CHAR(systimestamp at time zone 'GMT', 'Dy, dd Mon yyyy HH24:mi:SS TZR','NLS_DATE_LANGUAGE=AMERICAN')
      FROM DUAL;

   cur_time_char_       VARCHAR2(100);
BEGIN
   OPEN get_current_gmt_time;
   FETCH get_current_gmt_time INTO cur_time_char_;
   CLOSE get_current_gmt_time;

   RETURN cur_time_char_;
END;


-- This method is generating the Auth header for different request types
FUNCTION Generate_Auth_Header___(request_type_     IN VARCHAR2,
                                 storage_name_     IN VARCHAR2,
                                 container_name_   IN VARCHAR2,
                                 current_time_     IN VARCHAR2,
                                 file_name_        IN VARCHAR2,
                                 blob_type_        IN VARCHAR2,
                                 version_          IN VARCHAR2,
                                 req_body_length_  IN VARCHAR2 DEFAULT 0) RETURN VARCHAR2
IS
   auth_header_    VARCHAR2(32000);
BEGIN
   auth_header_ :=  request_type_ || chr(10) ||
                    chr(10) ||
                    chr(10);

   IF request_type_ = 'PUT' THEN
      auth_header_ := auth_header_ ||
                      req_body_length_ || chr(10);
   ELSIF request_type_ = 'GET' THEN
      auth_header_ := auth_header_ ||
                      chr(10);
   ELSIF request_type_ = 'HEAD' THEN
      auth_header_ := auth_header_ ||
                      chr(10);
   ELSIF request_type_ = 'DELETE' THEN
      auth_header_ := auth_header_ ||
                      chr(10);
   END IF;

   auth_header_ := auth_header_ ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   chr(10) ||
                   'x-ms-blob-type:' || blob_type_ || chr(10) ||
                   'x-ms-date:' || current_time_ || chr(10) ||
                   'x-ms-version:' || version_ || chr(10) ||
                   '/' || storage_name_ || '/' || container_name_ || '/' || file_name_;
   RETURN auth_header_;
END Generate_Auth_Header___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- this method calls the azure rest api for each media item
-- and save in the blob storage
PROCEDURE Save_Media_Item(
         archive_no_       IN NUMBER,
         address_          IN VARCHAR2,
         storage_name_     IN VARCHAR2,
         container_name_   IN VARCHAR2,
         access_key_       IN VARCHAR2,
         media_id_         IN NUMBER,
         media_body_       IN BLOB,
         wallet_path_      IN VARCHAR2,
         wallet_password_  IN VARCHAR2,
         lang_code_        IN VARCHAR2 DEFAULT NULL)
IS
   http_request_        UTL_HTTP.req;
   http_response_       UTL_HTTP.resp;

   req_length_          NUMBER;
   offset_              NUMBER := 1;
   amount_              NUMBER := 2000;
   buffer_              RAW(32000);
   blob_length_         NUMBER;
   response_failed_     EXCEPTION;
BEGIN
   blob_length_ := DBMS_LOB.getlength(media_body_);

   -- preparing Request
   Prepare_Request___(http_request_, 'PUT', address_, storage_name_, container_name_, access_key_, media_id_, wallet_path_, wallet_password_, lang_code_,blob_length_);

   req_length_ := dbms_lob.getlength(media_body_);
   WHILE (offset_ <= req_length_) LOOP
      DBMS_LOB.read(media_body_, amount_, offset_, buffer_);
      UTL_HTTP.write_raw(http_request_, buffer_);
      offset_ := offset_ + amount_;
   END LOOP;

   -- get Response and obtain received value
   http_response_ := UTL_HTTP.get_response(http_request_);
   -- update the archive status
   IF http_response_.status_code = 201 THEN
      IF media_id_ != 0000 THEN
         IF lang_code_ IS NOT NULL  THEN
            Media_Item_Language_API.Update_Archive_Status(media_id_,lang_code_, Fnd_Boolean_API.DB_TRUE, archive_no_);
         ELSE
            Media_Item_API.Update_Archive_Status(media_id_, Fnd_Boolean_API.DB_TRUE, archive_no_);
         END IF;
      END IF;
   ELSE
      RAISE response_failed_;
   END IF;
   -- finalizing
   UTL_HTTP.end_response(http_response_);
EXCEPTION
   WHEN response_failed_ THEN
      UTL_HTTP.end_response(http_response_);
      Error_sys.record_General(lu_name_, 'SAVEERROR: Azure storage returned the following error: :P1', http_response_.reason_phrase);
   WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(http_response_);
      Error_sys.record_General(lu_name_, 'SAVEERRORENDOFBODY: HTTP End of body. Original Error : :P1', http_response_.reason_phrase);
   WHEN OTHERS THEN
      UTL_HTTP.end_response(http_response_);
      RAISE;
END Save_Media_Item;

-- this method calls the azure rest api for each media item
-- and get the blob item
FUNCTION Get_Media_Item(
      address_          IN VARCHAR2,
      storage_name_     IN VARCHAR2,
      container_name_   IN VARCHAR2,
      access_key_       IN VARCHAR2,
      media_id_         IN NUMBER,
      wallet_path_      IN VARCHAR2,
      wallet_password_  IN VARCHAR2,
      lang_code_        IN VARCHAR2 DEFAULT NULL) RETURN BLOB
IS
   http_request_        UTL_HTTP.req;
   http_response_       UTL_HTTP.resp;

   media_item_blob_     BLOB;
   media_item_raw_      RAW(32767);
   err_msg_             VARCHAR2(1000);
   response_failed_     EXCEPTION;
BEGIN
   -- preparing Request
   Prepare_Request___(http_request_, 'GET', address_, storage_name_, container_name_, access_key_, media_id_, wallet_path_, wallet_password_,lang_code_);
   -- get Response and obtain received value
   http_response_ := UTL_HTTP.get_response(http_request_);

   IF http_response_.status_code = 200 THEN
      DBMS_LOB.createtemporary(lob_loc => media_item_blob_, cache => true, dur => dbms_lob.call);
      BEGIN
         LOOP
            UTL_HTTP.read_raw(http_response_, media_item_raw_, 32766);
            DBMS_LOB.writeappend(media_item_blob_, UTL_RAW.length(media_item_raw_), media_item_raw_);
         END LOOP;
      EXCEPTION
         WHEN UTL_HTTP.end_of_body THEN
            NULL;
      END;
   ELSE
      RAISE response_failed_;
   END IF;
   -- finalizing
   UTL_HTTP.end_response(http_response_);
   RETURN media_item_blob_;
EXCEPTION
   WHEN response_failed_ THEN
      media_item_blob_ := NULL;
      UTL_HTTP.end_response(http_response_);
      Error_sys.record_General(lu_name_, 'SAVEERROR: Azure storage returned the following error: :P1', http_response_.reason_phrase);
      RETURN media_item_blob_;
   WHEN OTHERS THEN
      media_item_blob_ := NULL;
      err_msg_ := SUBSTR(SQLERRM, 1, 200);
      UTL_HTTP.end_response(http_response_);
      RETURN media_item_blob_;
END Get_Media_Item;

PROCEDURE Delete_Media_Item(
         success_          OUT VARCHAR2,
         address_          IN VARCHAR2,
         storage_name_     IN VARCHAR2,
         container_name_   IN VARCHAR2,
         access_key_       IN VARCHAR2,
         media_id_         IN NUMBER,
         wallet_path_      IN VARCHAR2,
         wallet_password_  IN VARCHAR2,
         lang_code_        IN VARCHAR2 DEFAULT NULL)
IS
   http_request_        UTL_HTTP.req;
   http_response_       UTL_HTTP.resp;

   err_msg_             VARCHAR2(1000);
   response_failed_     EXCEPTION;
BEGIN
   success_ := 'FALSE';
   -- preparing Request
   Prepare_Request___(http_request_, 'DELETE', address_, storage_name_, container_name_, access_key_, media_id_,wallet_path_,wallet_password_,lang_code_);
   -- get Response and obtain received value
   http_response_ := UTL_HTTP.get_response(http_request_);
   IF http_response_.status_code = 202 THEN
      -- finalizing
      UTL_HTTP.end_response(http_response_);
      success_ := 'TRUE';
   ELSE
      RAISE response_failed_;
   END IF;
EXCEPTION
   WHEN response_failed_ THEN
      UTL_HTTP.end_response(http_response_);
      Error_sys.record_General(lu_name_, 'SAVEERROR: Azure storage returned the following error: :P1', http_response_.reason_phrase);
   WHEN OTHERS THEN
      err_msg_ := SUBSTR(SQLERRM, 1, 200);
      UTL_HTTP.end_response(http_response_);
      RAISE;
END Delete_Media_Item;

-- this method encode the auth header in order to send it to the azure
FUNCTION Get_Encoded_Auth_Header(
            auth_header_ IN VARCHAR2,
            access_key_  IN VARCHAR2) RETURN VARCHAR2
IS
   mac_encoded_auth_     RAW(10000);
   encoded_auth_header_  VARCHAR2(32000);
BEGIN
   -- Java Stored Procedure can be used to do the same thing
   -- Encoding the Authentication Header
   mac_encoded_auth_ := DBMS_CRYPTO.mac(UTL_I18N.string_to_raw(auth_header_, 'UTF8'),
                                       DBMS_CRYPTO.HMAC_SH256,
                                       UTL_ENCODE.base64_decode(UTL_I18N.string_to_raw(access_key_, 'UTF8')));
   encoded_auth_header_ := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(mac_encoded_auth_));
   RETURN encoded_auth_header_;
END Get_Encoded_Auth_Header;
